1 // File: @openzeppelin/contracts/utils/Strings.sol
2 
3 
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev String operations.
9  */
10 library Strings {
11     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
12 
13     /**
14      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
15      */
16     function toString(uint256 value) internal pure returns (string memory) {
17         // Inspired by OraclizeAPI's implementation - MIT licence
18         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
19 
20         if (value == 0) {
21             return "0";
22         }
23         uint256 temp = value;
24         uint256 digits;
25         while (temp != 0) {
26             digits++;
27             temp /= 10;
28         }
29         bytes memory buffer = new bytes(digits);
30         while (value != 0) {
31             digits -= 1;
32             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
33             value /= 10;
34         }
35         return string(buffer);
36     }
37 
38     /**
39      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
40      */
41     function toHexString(uint256 value) internal pure returns (string memory) {
42         if (value == 0) {
43             return "0x00";
44         }
45         uint256 temp = value;
46         uint256 length = 0;
47         while (temp != 0) {
48             length++;
49             temp >>= 8;
50         }
51         return toHexString(value, length);
52     }
53 
54     /**
55      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
56      */
57     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
58         bytes memory buffer = new bytes(2 * length + 2);
59         buffer[0] = "0";
60         buffer[1] = "x";
61         for (uint256 i = 2 * length + 1; i > 1; --i) {
62             buffer[i] = _HEX_SYMBOLS[value & 0xf];
63             value >>= 4;
64         }
65         require(value == 0, "Strings: hex length insufficient");
66         return string(buffer);
67     }
68 }
69 
70 // File: @openzeppelin/contracts/utils/Context.sol
71 
72 
73 
74 pragma solidity ^0.8.0;
75 
76 /**
77  * @dev Provides information about the current execution context, including the
78  * sender of the transaction and its data. While these are generally available
79  * via msg.sender and msg.data, they should not be accessed in such a direct
80  * manner, since when dealing with meta-transactions the account sending and
81  * paying for execution may not be the actual sender (as far as an application
82  * is concerned).
83  *
84  * This contract is only required for intermediate, library-like contracts.
85  */
86 abstract contract Context {
87     function _msgSender() internal view virtual returns (address) {
88         return msg.sender;
89     }
90 
91     function _msgData() internal view virtual returns (bytes calldata) {
92         return msg.data;
93     }
94 }
95 
96 // File: @openzeppelin/contracts/access/Ownable.sol
97 
98 
99 
100 pragma solidity ^0.8.0;
101 
102 
103 /**
104  * @dev Contract module which provides a basic access control mechanism, where
105  * there is an account (an owner) that can be granted exclusive access to
106  * specific functions.
107  *
108  * By default, the owner account will be the one that deploys the contract. This
109  * can later be changed with {transferOwnership}.
110  *
111  * This module is used through inheritance. It will make available the modifier
112  * `onlyOwner`, which can be applied to your functions to restrict their use to
113  * the owner.
114  */
115 abstract contract Ownable is Context {
116     address private _owner;
117 
118     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
119 
120     /**
121      * @dev Initializes the contract setting the deployer as the initial owner.
122      */
123     constructor() {
124         _setOwner(_msgSender());
125     }
126 
127     /**
128      * @dev Returns the address of the current owner.
129      */
130     function owner() public view virtual returns (address) {
131         return _owner;
132     }
133 
134     /**
135      * @dev Throws if called by any account other than the owner.
136      */
137     modifier onlyOwner() {
138         require(owner() == _msgSender(), "Ownable: caller is not the owner");
139         _;
140     }
141 
142     /**
143      * @dev Leaves the contract without owner. It will not be possible to call
144      * `onlyOwner` functions anymore. Can only be called by the current owner.
145      *
146      * NOTE: Renouncing ownership will leave the contract without an owner,
147      * thereby removing any functionality that is only available to the owner.
148      */
149     function renounceOwnership() public virtual onlyOwner {
150         _setOwner(address(0));
151     }
152 
153     /**
154      * @dev Transfers ownership of the contract to a new account (`newOwner`).
155      * Can only be called by the current owner.
156      */
157     function transferOwnership(address newOwner) public virtual onlyOwner {
158         require(newOwner != address(0), "Ownable: new owner is the zero address");
159         _setOwner(newOwner);
160     }
161 
162     function _setOwner(address newOwner) private {
163         address oldOwner = _owner;
164         _owner = newOwner;
165         emit OwnershipTransferred(oldOwner, newOwner);
166     }
167 }
168 
169 // File: @openzeppelin/contracts/utils/Address.sol
170 
171 
172 
173 pragma solidity ^0.8.0;
174 
175 /**
176  * @dev Collection of functions related to the address type
177  */
178 library Address {
179     /**
180      * @dev Returns true if `account` is a contract.
181      *
182      * [IMPORTANT]
183      * ====
184      * It is unsafe to assume that an address for which this function returns
185      * false is an externally-owned account (EOA) and not a contract.
186      *
187      * Among others, `isContract` will return false for the following
188      * types of addresses:
189      *
190      *  - an externally-owned account
191      *  - a contract in construction
192      *  - an address where a contract will be created
193      *  - an address where a contract lived, but was destroyed
194      * ====
195      */
196     function isContract(address account) internal view returns (bool) {
197         // This method relies on extcodesize, which returns 0 for contracts in
198         // construction, since the code is only stored at the end of the
199         // constructor execution.
200 
201         uint256 size;
202         assembly {
203             size := extcodesize(account)
204         }
205         return size > 0;
206     }
207 
208     /**
209      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
210      * `recipient`, forwarding all available gas and reverting on errors.
211      *
212      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
213      * of certain opcodes, possibly making contracts go over the 2300 gas limit
214      * imposed by `transfer`, making them unable to receive funds via
215      * `transfer`. {sendValue} removes this limitation.
216      *
217      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
218      *
219      * IMPORTANT: because control is transferred to `recipient`, care must be
220      * taken to not create reentrancy vulnerabilities. Consider using
221      * {ReentrancyGuard} or the
222      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
223      */
224     function sendValue(address payable recipient, uint256 amount) internal {
225         require(address(this).balance >= amount, "Address: insufficient balance");
226 
227         (bool success, ) = recipient.call{value: amount}("");
228         require(success, "Address: unable to send value, recipient may have reverted");
229     }
230 
231     /**
232      * @dev Performs a Solidity function call using a low level `call`. A
233      * plain `call` is an unsafe replacement for a function call: use this
234      * function instead.
235      *
236      * If `target` reverts with a revert reason, it is bubbled up by this
237      * function (like regular Solidity function calls).
238      *
239      * Returns the raw returned data. To convert to the expected return value,
240      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
241      *
242      * Requirements:
243      *
244      * - `target` must be a contract.
245      * - calling `target` with `data` must not revert.
246      *
247      * _Available since v3.1._
248      */
249     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
250         return functionCall(target, data, "Address: low-level call failed");
251     }
252 
253     /**
254      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
255      * `errorMessage` as a fallback revert reason when `target` reverts.
256      *
257      * _Available since v3.1._
258      */
259     function functionCall(
260         address target,
261         bytes memory data,
262         string memory errorMessage
263     ) internal returns (bytes memory) {
264         return functionCallWithValue(target, data, 0, errorMessage);
265     }
266 
267     /**
268      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
269      * but also transferring `value` wei to `target`.
270      *
271      * Requirements:
272      *
273      * - the calling contract must have an ETH balance of at least `value`.
274      * - the called Solidity function must be `payable`.
275      *
276      * _Available since v3.1._
277      */
278     function functionCallWithValue(
279         address target,
280         bytes memory data,
281         uint256 value
282     ) internal returns (bytes memory) {
283         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
284     }
285 
286     /**
287      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
288      * with `errorMessage` as a fallback revert reason when `target` reverts.
289      *
290      * _Available since v3.1._
291      */
292     function functionCallWithValue(
293         address target,
294         bytes memory data,
295         uint256 value,
296         string memory errorMessage
297     ) internal returns (bytes memory) {
298         require(address(this).balance >= value, "Address: insufficient balance for call");
299         require(isContract(target), "Address: call to non-contract");
300 
301         (bool success, bytes memory returndata) = target.call{value: value}(data);
302         return verifyCallResult(success, returndata, errorMessage);
303     }
304 
305     /**
306      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
307      * but performing a static call.
308      *
309      * _Available since v3.3._
310      */
311     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
312         return functionStaticCall(target, data, "Address: low-level static call failed");
313     }
314 
315     /**
316      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
317      * but performing a static call.
318      *
319      * _Available since v3.3._
320      */
321     function functionStaticCall(
322         address target,
323         bytes memory data,
324         string memory errorMessage
325     ) internal view returns (bytes memory) {
326         require(isContract(target), "Address: static call to non-contract");
327 
328         (bool success, bytes memory returndata) = target.staticcall(data);
329         return verifyCallResult(success, returndata, errorMessage);
330     }
331 
332     /**
333      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
334      * but performing a delegate call.
335      *
336      * _Available since v3.4._
337      */
338     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
339         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
340     }
341 
342     /**
343      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
344      * but performing a delegate call.
345      *
346      * _Available since v3.4._
347      */
348     function functionDelegateCall(
349         address target,
350         bytes memory data,
351         string memory errorMessage
352     ) internal returns (bytes memory) {
353         require(isContract(target), "Address: delegate call to non-contract");
354 
355         (bool success, bytes memory returndata) = target.delegatecall(data);
356         return verifyCallResult(success, returndata, errorMessage);
357     }
358 
359     /**
360      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
361      * revert reason using the provided one.
362      *
363      * _Available since v4.3._
364      */
365     function verifyCallResult(
366         bool success,
367         bytes memory returndata,
368         string memory errorMessage
369     ) internal pure returns (bytes memory) {
370         if (success) {
371             return returndata;
372         } else {
373             // Look for revert reason and bubble it up if present
374             if (returndata.length > 0) {
375                 // The easiest way to bubble the revert reason is using memory via assembly
376 
377                 assembly {
378                     let returndata_size := mload(returndata)
379                     revert(add(32, returndata), returndata_size)
380                 }
381             } else {
382                 revert(errorMessage);
383             }
384         }
385     }
386 }
387 
388 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
389 
390 
391 
392 pragma solidity ^0.8.0;
393 
394 /**
395  * @title ERC721 token receiver interface
396  * @dev Interface for any contract that wants to support safeTransfers
397  * from ERC721 asset contracts.
398  */
399 interface IERC721Receiver {
400     /**
401      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
402      * by `operator` from `from`, this function is called.
403      *
404      * It must return its Solidity selector to confirm the token transfer.
405      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
406      *
407      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
408      */
409     function onERC721Received(
410         address operator,
411         address from,
412         uint256 tokenId,
413         bytes calldata data
414     ) external returns (bytes4);
415 }
416 
417 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
418 
419 
420 
421 pragma solidity ^0.8.0;
422 
423 /**
424  * @dev Interface of the ERC165 standard, as defined in the
425  * https://eips.ethereum.org/EIPS/eip-165[EIP].
426  *
427  * Implementers can declare support of contract interfaces, which can then be
428  * queried by others ({ERC165Checker}).
429  *
430  * For an implementation, see {ERC165}.
431  */
432 interface IERC165 {
433     /**
434      * @dev Returns true if this contract implements the interface defined by
435      * `interfaceId`. See the corresponding
436      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
437      * to learn more about how these ids are created.
438      *
439      * This function call must use less than 30 000 gas.
440      */
441     function supportsInterface(bytes4 interfaceId) external view returns (bool);
442 }
443 
444 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
445 
446 
447 
448 pragma solidity ^0.8.0;
449 
450 
451 /**
452  * @dev Implementation of the {IERC165} interface.
453  *
454  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
455  * for the additional interface id that will be supported. For example:
456  *
457  * ```solidity
458  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
459  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
460  * }
461  * ```
462  *
463  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
464  */
465 abstract contract ERC165 is IERC165 {
466     /**
467      * @dev See {IERC165-supportsInterface}.
468      */
469     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
470         return interfaceId == type(IERC165).interfaceId;
471     }
472 }
473 
474 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
475 
476 
477 
478 pragma solidity ^0.8.0;
479 
480 
481 /**
482  * @dev Required interface of an ERC721 compliant contract.
483  */
484 interface IERC721 is IERC165 {
485     /**
486      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
487      */
488     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
489 
490     /**
491      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
492      */
493     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
494 
495     /**
496      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
497      */
498     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
499 
500     /**
501      * @dev Returns the number of tokens in ``owner``'s account.
502      */
503     function balanceOf(address owner) external view returns (uint256 balance);
504 
505     /**
506      * @dev Returns the owner of the `tokenId` token.
507      *
508      * Requirements:
509      *
510      * - `tokenId` must exist.
511      */
512     function ownerOf(uint256 tokenId) external view returns (address owner);
513 
514     /**
515      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
516      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
517      *
518      * Requirements:
519      *
520      * - `from` cannot be the zero address.
521      * - `to` cannot be the zero address.
522      * - `tokenId` token must exist and be owned by `from`.
523      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
524      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
525      *
526      * Emits a {Transfer} event.
527      */
528     function safeTransferFrom(
529         address from,
530         address to,
531         uint256 tokenId
532     ) external;
533 
534     /**
535      * @dev Transfers `tokenId` token from `from` to `to`.
536      *
537      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
538      *
539      * Requirements:
540      *
541      * - `from` cannot be the zero address.
542      * - `to` cannot be the zero address.
543      * - `tokenId` token must be owned by `from`.
544      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
545      *
546      * Emits a {Transfer} event.
547      */
548     function transferFrom(
549         address from,
550         address to,
551         uint256 tokenId
552     ) external;
553 
554     /**
555      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
556      * The approval is cleared when the token is transferred.
557      *
558      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
559      *
560      * Requirements:
561      *
562      * - The caller must own the token or be an approved operator.
563      * - `tokenId` must exist.
564      *
565      * Emits an {Approval} event.
566      */
567     function approve(address to, uint256 tokenId) external;
568 
569     /**
570      * @dev Returns the account approved for `tokenId` token.
571      *
572      * Requirements:
573      *
574      * - `tokenId` must exist.
575      */
576     function getApproved(uint256 tokenId) external view returns (address operator);
577 
578     /**
579      * @dev Approve or remove `operator` as an operator for the caller.
580      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
581      *
582      * Requirements:
583      *
584      * - The `operator` cannot be the caller.
585      *
586      * Emits an {ApprovalForAll} event.
587      */
588     function setApprovalForAll(address operator, bool _approved) external;
589 
590     /**
591      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
592      *
593      * See {setApprovalForAll}
594      */
595     function isApprovedForAll(address owner, address operator) external view returns (bool);
596 
597     /**
598      * @dev Safely transfers `tokenId` token from `from` to `to`.
599      *
600      * Requirements:
601      *
602      * - `from` cannot be the zero address.
603      * - `to` cannot be the zero address.
604      * - `tokenId` token must exist and be owned by `from`.
605      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
606      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
607      *
608      * Emits a {Transfer} event.
609      */
610     function safeTransferFrom(
611         address from,
612         address to,
613         uint256 tokenId,
614         bytes calldata data
615     ) external;
616 }
617 
618 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
619 
620 
621 
622 pragma solidity ^0.8.0;
623 
624 
625 /**
626  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
627  * @dev See https://eips.ethereum.org/EIPS/eip-721
628  */
629 interface IERC721Metadata is IERC721 {
630     /**
631      * @dev Returns the token collection name.
632      */
633     function name() external view returns (string memory);
634 
635     /**
636      * @dev Returns the token collection symbol.
637      */
638     function symbol() external view returns (string memory);
639 
640     /**
641      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
642      */
643     function tokenURI(uint256 tokenId) external view returns (string memory);
644 }
645 
646 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
647 
648 
649 
650 pragma solidity ^0.8.0;
651 
652 
653 
654 
655 
656 
657 
658 
659 /**
660  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
661  * the Metadata extension, but not including the Enumerable extension, which is available separately as
662  * {ERC721Enumerable}.
663  */
664 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
665     using Address for address;
666     using Strings for uint256;
667 
668     // Token name
669     string private _name;
670 
671     // Token symbol
672     string private _symbol;
673 
674     // Mapping from token ID to owner address
675     mapping(uint256 => address) private _owners;
676 
677     // Mapping owner address to token count
678     mapping(address => uint256) private _balances;
679 
680     // Mapping from token ID to approved address
681     mapping(uint256 => address) private _tokenApprovals;
682 
683     // Mapping from owner to operator approvals
684     mapping(address => mapping(address => bool)) private _operatorApprovals;
685 
686     /**
687      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
688      */
689     constructor(string memory name_, string memory symbol_) {
690         _name = name_;
691         _symbol = symbol_;
692     }
693 
694     /**
695      * @dev See {IERC165-supportsInterface}.
696      */
697     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
698         return
699             interfaceId == type(IERC721).interfaceId ||
700             interfaceId == type(IERC721Metadata).interfaceId ||
701             super.supportsInterface(interfaceId);
702     }
703 
704     /**
705      * @dev See {IERC721-balanceOf}.
706      */
707     function balanceOf(address owner) public view virtual override returns (uint256) {
708         require(owner != address(0), "ERC721: balance query for the zero address");
709         return _balances[owner];
710     }
711 
712     /**
713      * @dev See {IERC721-ownerOf}.
714      */
715     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
716         address owner = _owners[tokenId];
717         require(owner != address(0), "ERC721: owner query for nonexistent token");
718         return owner;
719     }
720 
721     /**
722      * @dev See {IERC721Metadata-name}.
723      */
724     function name() public view virtual override returns (string memory) {
725         return _name;
726     }
727 
728     /**
729      * @dev See {IERC721Metadata-symbol}.
730      */
731     function symbol() public view virtual override returns (string memory) {
732         return _symbol;
733     }
734 
735     /**
736      * @dev See {IERC721Metadata-tokenURI}.
737      */
738     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
739         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
740 
741         string memory baseURI = _baseURI();
742         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
743     }
744 
745     /**
746      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
747      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
748      * by default, can be overriden in child contracts.
749      */
750     function _baseURI() internal view virtual returns (string memory) {
751         return "";
752     }
753 
754     /**
755      * @dev See {IERC721-approve}.
756      */
757     function approve(address to, uint256 tokenId) public virtual override {
758         address owner = ERC721.ownerOf(tokenId);
759         require(to != owner, "ERC721: approval to current owner");
760 
761         require(
762             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
763             "ERC721: approve caller is not owner nor approved for all"
764         );
765 
766         _approve(to, tokenId);
767     }
768 
769     /**
770      * @dev See {IERC721-getApproved}.
771      */
772     function getApproved(uint256 tokenId) public view virtual override returns (address) {
773         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
774 
775         return _tokenApprovals[tokenId];
776     }
777 
778     /**
779      * @dev See {IERC721-setApprovalForAll}.
780      */
781     function setApprovalForAll(address operator, bool approved) public virtual override {
782         require(operator != _msgSender(), "ERC721: approve to caller");
783 
784         _operatorApprovals[_msgSender()][operator] = approved;
785         emit ApprovalForAll(_msgSender(), operator, approved);
786     }
787 
788     /**
789      * @dev See {IERC721-isApprovedForAll}.
790      */
791     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
792         return _operatorApprovals[owner][operator];
793     }
794 
795     /**
796      * @dev See {IERC721-transferFrom}.
797      */
798     function transferFrom(
799         address from,
800         address to,
801         uint256 tokenId
802     ) public virtual override {
803         //solhint-disable-next-line max-line-length
804         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
805 
806         _transfer(from, to, tokenId);
807     }
808 
809     /**
810      * @dev See {IERC721-safeTransferFrom}.
811      */
812     function safeTransferFrom(
813         address from,
814         address to,
815         uint256 tokenId
816     ) public virtual override {
817         safeTransferFrom(from, to, tokenId, "");
818     }
819 
820     /**
821      * @dev See {IERC721-safeTransferFrom}.
822      */
823     function safeTransferFrom(
824         address from,
825         address to,
826         uint256 tokenId,
827         bytes memory _data
828     ) public virtual override {
829         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
830         _safeTransfer(from, to, tokenId, _data);
831     }
832 
833     /**
834      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
835      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
836      *
837      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
838      *
839      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
840      * implement alternative mechanisms to perform token transfer, such as signature-based.
841      *
842      * Requirements:
843      *
844      * - `from` cannot be the zero address.
845      * - `to` cannot be the zero address.
846      * - `tokenId` token must exist and be owned by `from`.
847      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
848      *
849      * Emits a {Transfer} event.
850      */
851     function _safeTransfer(
852         address from,
853         address to,
854         uint256 tokenId,
855         bytes memory _data
856     ) internal virtual {
857         _transfer(from, to, tokenId);
858         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
859     }
860 
861     /**
862      * @dev Returns whether `tokenId` exists.
863      *
864      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
865      *
866      * Tokens start existing when they are minted (`_mint`),
867      * and stop existing when they are burned (`_burn`).
868      */
869     function _exists(uint256 tokenId) internal view virtual returns (bool) {
870         return _owners[tokenId] != address(0);
871     }
872 
873     /**
874      * @dev Returns whether `spender` is allowed to manage `tokenId`.
875      *
876      * Requirements:
877      *
878      * - `tokenId` must exist.
879      */
880     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
881         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
882         address owner = ERC721.ownerOf(tokenId);
883         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
884     }
885 
886     /**
887      * @dev Safely mints `tokenId` and transfers it to `to`.
888      *
889      * Requirements:
890      *
891      * - `tokenId` must not exist.
892      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
893      *
894      * Emits a {Transfer} event.
895      */
896     function _safeMint(address to, uint256 tokenId) internal virtual {
897         _safeMint(to, tokenId, "");
898     }
899 
900     /**
901      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
902      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
903      */
904     function _safeMint(
905         address to,
906         uint256 tokenId,
907         bytes memory _data
908     ) internal virtual {
909         _mint(to, tokenId);
910         require(
911             _checkOnERC721Received(address(0), to, tokenId, _data),
912             "ERC721: transfer to non ERC721Receiver implementer"
913         );
914     }
915 
916     /**
917      * @dev Mints `tokenId` and transfers it to `to`.
918      *
919      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
920      *
921      * Requirements:
922      *
923      * - `tokenId` must not exist.
924      * - `to` cannot be the zero address.
925      *
926      * Emits a {Transfer} event.
927      */
928     function _mint(address to, uint256 tokenId) internal virtual {
929         require(to != address(0), "ERC721: mint to the zero address");
930         require(!_exists(tokenId), "ERC721: token already minted");
931 
932         _beforeTokenTransfer(address(0), to, tokenId);
933 
934         _balances[to] += 1;
935         _owners[tokenId] = to;
936 
937         emit Transfer(address(0), to, tokenId);
938     }
939 
940     /**
941      * @dev Destroys `tokenId`.
942      * The approval is cleared when the token is burned.
943      *
944      * Requirements:
945      *
946      * - `tokenId` must exist.
947      *
948      * Emits a {Transfer} event.
949      */
950     function _burn(uint256 tokenId) internal virtual {
951         address owner = ERC721.ownerOf(tokenId);
952 
953         _beforeTokenTransfer(owner, address(0), tokenId);
954 
955         // Clear approvals
956         _approve(address(0), tokenId);
957 
958         _balances[owner] -= 1;
959         delete _owners[tokenId];
960 
961         emit Transfer(owner, address(0), tokenId);
962     }
963 
964     /**
965      * @dev Transfers `tokenId` from `from` to `to`.
966      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
967      *
968      * Requirements:
969      *
970      * - `to` cannot be the zero address.
971      * - `tokenId` token must be owned by `from`.
972      *
973      * Emits a {Transfer} event.
974      */
975     function _transfer(
976         address from,
977         address to,
978         uint256 tokenId
979     ) internal virtual {
980         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
981         require(to != address(0), "ERC721: transfer to the zero address");
982 
983         _beforeTokenTransfer(from, to, tokenId);
984 
985         // Clear approvals from the previous owner
986         _approve(address(0), tokenId);
987 
988         _balances[from] -= 1;
989         _balances[to] += 1;
990         _owners[tokenId] = to;
991 
992         emit Transfer(from, to, tokenId);
993     }
994 
995     /**
996      * @dev Approve `to` to operate on `tokenId`
997      *
998      * Emits a {Approval} event.
999      */
1000     function _approve(address to, uint256 tokenId) internal virtual {
1001         _tokenApprovals[tokenId] = to;
1002         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1003     }
1004 
1005     /**
1006      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1007      * The call is not executed if the target address is not a contract.
1008      *
1009      * @param from address representing the previous owner of the given token ID
1010      * @param to target address that will receive the tokens
1011      * @param tokenId uint256 ID of the token to be transferred
1012      * @param _data bytes optional data to send along with the call
1013      * @return bool whether the call correctly returned the expected magic value
1014      */
1015     function _checkOnERC721Received(
1016         address from,
1017         address to,
1018         uint256 tokenId,
1019         bytes memory _data
1020     ) private returns (bool) {
1021         if (to.isContract()) {
1022             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1023                 return retval == IERC721Receiver.onERC721Received.selector;
1024             } catch (bytes memory reason) {
1025                 if (reason.length == 0) {
1026                     revert("ERC721: transfer to non ERC721Receiver implementer");
1027                 } else {
1028                     assembly {
1029                         revert(add(32, reason), mload(reason))
1030                     }
1031                 }
1032             }
1033         } else {
1034             return true;
1035         }
1036     }
1037 
1038     /**
1039      * @dev Hook that is called before any token transfer. This includes minting
1040      * and burning.
1041      *
1042      * Calling conditions:
1043      *
1044      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1045      * transferred to `to`.
1046      * - When `from` is zero, `tokenId` will be minted for `to`.
1047      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1048      * - `from` and `to` are never both zero.
1049      *
1050      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1051      */
1052     function _beforeTokenTransfer(
1053         address from,
1054         address to,
1055         uint256 tokenId
1056     ) internal virtual {}
1057 }
1058 
1059 // File: contracts/Champs.sol
1060 
1061 // WallstreetNFTs.io Champs
1062 
1063 pragma solidity ^0.8.2;
1064 
1065 
1066 
1067 contract WallstreetNFTS is ERC721, Ownable {
1068     
1069     uint public mintPrice = 0.05 ether;
1070     uint public maxItems = 10080;
1071     uint public totalSupply = 0;
1072     uint public maxItemsPerTx = 25;
1073     string public _baseTokenURI;
1074     bool public publicMintPaused = false;
1075     uint public startTimestamp = 1636056000;
1076     
1077     event Mint(address indexed owner, uint indexed tokenId);
1078     
1079     constructor() ERC721("WallstreetNFTs", "CHAMP") {}
1080     
1081     receive() external payable {}
1082     
1083     function givewayMint(address to, uint amount) external onlyOwner {
1084         _mintWithoutValidation(to, amount);
1085     }
1086     
1087     function publicMint() external payable {
1088         require(block.timestamp > startTimestamp, "publicMint: Not open yet");
1089         require(!publicMintPaused, "publicMint: Paused");
1090         uint remainder = msg.value % mintPrice;
1091         uint amount = msg.value / mintPrice;
1092         require(remainder == 0, "publicMint: Send a divisible amount of eth");
1093         require(amount <= maxItemsPerTx, "publicMint: Surpasses maxItemsPerTx");
1094         
1095         _mintWithoutValidation(msg.sender, amount);
1096     }
1097     
1098     function _mintWithoutValidation(address to, uint amount) internal {
1099         require(totalSupply + amount <= maxItems, "mintWithoutValidation: Sold out");
1100         for (uint i = 0; i < amount; i++) {
1101             _mint(to, totalSupply);
1102             emit Mint(to, totalSupply);
1103             totalSupply += 1;
1104         }
1105     }
1106     
1107     function isOpen() external view returns (bool) {
1108         return block.timestamp >= startTimestamp && !publicMintPaused && totalSupply < maxItems;
1109     }
1110     
1111     // ADMIN FUNCTIONS
1112     
1113     function setStartTimestamp(uint _startTimestamp) external onlyOwner {
1114         startTimestamp = _startTimestamp;
1115     }
1116     
1117     function setMintPrice(uint _mintPrice) external onlyOwner {
1118         mintPrice = _mintPrice;
1119     }
1120     
1121     function setPublicMintPaused(bool _publicMintPaused) external onlyOwner {
1122         publicMintPaused = _publicMintPaused;
1123     }
1124     
1125     function setMaxItemsPerTx(uint _maxItemsPerTx) external onlyOwner {
1126         maxItemsPerTx = _maxItemsPerTx;
1127     }
1128     
1129     function setBaseTokenURI(string memory __baseTokenURI) external onlyOwner {
1130         _baseTokenURI = __baseTokenURI;
1131     }
1132     
1133     /**
1134      * @dev Withdraw the contract balance to the dev address or splitter address
1135      */
1136     function withdraw() external onlyOwner {
1137         sendEth(owner(), address(this).balance);
1138     }
1139 
1140     function sendEth(address to, uint amount) internal {
1141         (bool success,) = to.call{value: amount}("");
1142         require(success, "Failed to send ether");
1143     }
1144 
1145     // METADATA FUNCTIONALITY
1146 
1147     /**
1148      * @dev Returns a URI for a given token ID's metadata
1149      */
1150     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1151         return string(abi.encodePacked(_baseTokenURI, Strings.toString(_tokenId)));
1152     }
1153 }