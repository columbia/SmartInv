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
618 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
619 
620 
621 
622 pragma solidity ^0.8.0;
623 
624 
625 /**
626  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
627  * @dev See https://eips.ethereum.org/EIPS/eip-721
628  */
629 interface IERC721Enumerable is IERC721 {
630     /**
631      * @dev Returns the total amount of tokens stored by the contract.
632      */
633     function totalSupply() external view returns (uint256);
634 
635     /**
636      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
637      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
638      */
639     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
640 
641     /**
642      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
643      * Use along with {totalSupply} to enumerate all tokens.
644      */
645     function tokenByIndex(uint256 index) external view returns (uint256);
646 }
647 
648 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
649 
650 
651 
652 pragma solidity ^0.8.0;
653 
654 
655 /**
656  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
657  * @dev See https://eips.ethereum.org/EIPS/eip-721
658  */
659 interface IERC721Metadata is IERC721 {
660     /**
661      * @dev Returns the token collection name.
662      */
663     function name() external view returns (string memory);
664 
665     /**
666      * @dev Returns the token collection symbol.
667      */
668     function symbol() external view returns (string memory);
669 
670     /**
671      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
672      */
673     function tokenURI(uint256 tokenId) external view returns (string memory);
674 }
675 
676 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
677 
678 
679 
680 pragma solidity ^0.8.0;
681 
682 
683 
684 
685 
686 
687 
688 
689 /**
690  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
691  * the Metadata extension, but not including the Enumerable extension, which is available separately as
692  * {ERC721Enumerable}.
693  */
694 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
695     using Address for address;
696     using Strings for uint256;
697 
698     // Token name
699     string private _name;
700 
701     // Token symbol
702     string private _symbol;
703 
704     // Mapping from token ID to owner address
705     mapping(uint256 => address) private _owners;
706 
707     // Mapping owner address to token count
708     mapping(address => uint256) private _balances;
709 
710     // Mapping from token ID to approved address
711     mapping(uint256 => address) private _tokenApprovals;
712 
713     // Mapping from owner to operator approvals
714     mapping(address => mapping(address => bool)) private _operatorApprovals;
715 
716     /**
717      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
718      */
719     constructor(string memory name_, string memory symbol_) {
720         _name = name_;
721         _symbol = symbol_;
722     }
723 
724     /**
725      * @dev See {IERC165-supportsInterface}.
726      */
727     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
728         return
729             interfaceId == type(IERC721).interfaceId ||
730             interfaceId == type(IERC721Metadata).interfaceId ||
731             super.supportsInterface(interfaceId);
732     }
733 
734     /**
735      * @dev See {IERC721-balanceOf}.
736      */
737     function balanceOf(address owner) public view virtual override returns (uint256) {
738         require(owner != address(0), "ERC721: balance query for the zero address");
739         return _balances[owner];
740     }
741 
742     /**
743      * @dev See {IERC721-ownerOf}.
744      */
745     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
746         address owner = _owners[tokenId];
747         require(owner != address(0), "ERC721: owner query for nonexistent token");
748         return owner;
749     }
750 
751     /**
752      * @dev See {IERC721Metadata-name}.
753      */
754     function name() public view virtual override returns (string memory) {
755         return _name;
756     }
757 
758     /**
759      * @dev See {IERC721Metadata-symbol}.
760      */
761     function symbol() public view virtual override returns (string memory) {
762         return _symbol;
763     }
764 
765     /**
766      * @dev See {IERC721Metadata-tokenURI}.
767      */
768     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
769         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
770 
771         string memory baseURI = _baseURI();
772         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
773     }
774 
775     /**
776      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
777      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
778      * by default, can be overriden in child contracts.
779      */
780     function _baseURI() internal view virtual returns (string memory) {
781         return "";
782     }
783 
784     /**
785      * @dev See {IERC721-approve}.
786      */
787     function approve(address to, uint256 tokenId) public virtual override {
788         address owner = ERC721.ownerOf(tokenId);
789         require(to != owner, "ERC721: approval to current owner");
790 
791         require(
792             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
793             "ERC721: approve caller is not owner nor approved for all"
794         );
795 
796         _approve(to, tokenId);
797     }
798 
799     /**
800      * @dev See {IERC721-getApproved}.
801      */
802     function getApproved(uint256 tokenId) public view virtual override returns (address) {
803         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
804 
805         return _tokenApprovals[tokenId];
806     }
807 
808     /**
809      * @dev See {IERC721-setApprovalForAll}.
810      */
811     function setApprovalForAll(address operator, bool approved) public virtual override {
812         require(operator != _msgSender(), "ERC721: approve to caller");
813 
814         _operatorApprovals[_msgSender()][operator] = approved;
815         emit ApprovalForAll(_msgSender(), operator, approved);
816     }
817 
818     /**
819      * @dev See {IERC721-isApprovedForAll}.
820      */
821     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
822         return _operatorApprovals[owner][operator];
823     }
824 
825     /**
826      * @dev See {IERC721-transferFrom}.
827      */
828     function transferFrom(
829         address from,
830         address to,
831         uint256 tokenId
832     ) public virtual override {
833         //solhint-disable-next-line max-line-length
834         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
835 
836         _transfer(from, to, tokenId);
837     }
838 
839     /**
840      * @dev See {IERC721-safeTransferFrom}.
841      */
842     function safeTransferFrom(
843         address from,
844         address to,
845         uint256 tokenId
846     ) public virtual override {
847         safeTransferFrom(from, to, tokenId, "");
848     }
849 
850     /**
851      * @dev See {IERC721-safeTransferFrom}.
852      */
853     function safeTransferFrom(
854         address from,
855         address to,
856         uint256 tokenId,
857         bytes memory _data
858     ) public virtual override {
859         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
860         _safeTransfer(from, to, tokenId, _data);
861     }
862 
863     /**
864      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
865      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
866      *
867      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
868      *
869      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
870      * implement alternative mechanisms to perform token transfer, such as signature-based.
871      *
872      * Requirements:
873      *
874      * - `from` cannot be the zero address.
875      * - `to` cannot be the zero address.
876      * - `tokenId` token must exist and be owned by `from`.
877      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
878      *
879      * Emits a {Transfer} event.
880      */
881     function _safeTransfer(
882         address from,
883         address to,
884         uint256 tokenId,
885         bytes memory _data
886     ) internal virtual {
887         _transfer(from, to, tokenId);
888         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
889     }
890 
891     /**
892      * @dev Returns whether `tokenId` exists.
893      *
894      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
895      *
896      * Tokens start existing when they are minted (`_mint`),
897      * and stop existing when they are burned (`_burn`).
898      */
899     function _exists(uint256 tokenId) internal view virtual returns (bool) {
900         return _owners[tokenId] != address(0);
901     }
902 
903     /**
904      * @dev Returns whether `spender` is allowed to manage `tokenId`.
905      *
906      * Requirements:
907      *
908      * - `tokenId` must exist.
909      */
910     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
911         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
912         address owner = ERC721.ownerOf(tokenId);
913         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
914     }
915 
916     /**
917      * @dev Safely mints `tokenId` and transfers it to `to`.
918      *
919      * Requirements:
920      *
921      * - `tokenId` must not exist.
922      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
923      *
924      * Emits a {Transfer} event.
925      */
926     function _safeMint(address to, uint256 tokenId) internal virtual {
927         _safeMint(to, tokenId, "");
928     }
929 
930     /**
931      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
932      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
933      */
934     function _safeMint(
935         address to,
936         uint256 tokenId,
937         bytes memory _data
938     ) internal virtual {
939         _mint(to, tokenId);
940         require(
941             _checkOnERC721Received(address(0), to, tokenId, _data),
942             "ERC721: transfer to non ERC721Receiver implementer"
943         );
944     }
945 
946     /**
947      * @dev Mints `tokenId` and transfers it to `to`.
948      *
949      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
950      *
951      * Requirements:
952      *
953      * - `tokenId` must not exist.
954      * - `to` cannot be the zero address.
955      *
956      * Emits a {Transfer} event.
957      */
958     function _mint(address to, uint256 tokenId) internal virtual {
959         require(to != address(0), "ERC721: mint to the zero address");
960         require(!_exists(tokenId), "ERC721: token already minted");
961 
962         _beforeTokenTransfer(address(0), to, tokenId);
963 
964         _balances[to] += 1;
965         _owners[tokenId] = to;
966 
967         emit Transfer(address(0), to, tokenId);
968     }
969 
970     /**
971      * @dev Destroys `tokenId`.
972      * The approval is cleared when the token is burned.
973      *
974      * Requirements:
975      *
976      * - `tokenId` must exist.
977      *
978      * Emits a {Transfer} event.
979      */
980     function _burn(uint256 tokenId) internal virtual {
981         address owner = ERC721.ownerOf(tokenId);
982 
983         _beforeTokenTransfer(owner, address(0), tokenId);
984 
985         // Clear approvals
986         _approve(address(0), tokenId);
987 
988         _balances[owner] -= 1;
989         delete _owners[tokenId];
990 
991         emit Transfer(owner, address(0), tokenId);
992     }
993 
994     /**
995      * @dev Transfers `tokenId` from `from` to `to`.
996      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
997      *
998      * Requirements:
999      *
1000      * - `to` cannot be the zero address.
1001      * - `tokenId` token must be owned by `from`.
1002      *
1003      * Emits a {Transfer} event.
1004      */
1005     function _transfer(
1006         address from,
1007         address to,
1008         uint256 tokenId
1009     ) internal virtual {
1010         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1011         require(to != address(0), "ERC721: transfer to the zero address");
1012 
1013         _beforeTokenTransfer(from, to, tokenId);
1014 
1015         // Clear approvals from the previous owner
1016         _approve(address(0), tokenId);
1017 
1018         _balances[from] -= 1;
1019         _balances[to] += 1;
1020         _owners[tokenId] = to;
1021 
1022         emit Transfer(from, to, tokenId);
1023     }
1024 
1025     /**
1026      * @dev Approve `to` to operate on `tokenId`
1027      *
1028      * Emits a {Approval} event.
1029      */
1030     function _approve(address to, uint256 tokenId) internal virtual {
1031         _tokenApprovals[tokenId] = to;
1032         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1033     }
1034 
1035     /**
1036      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1037      * The call is not executed if the target address is not a contract.
1038      *
1039      * @param from address representing the previous owner of the given token ID
1040      * @param to target address that will receive the tokens
1041      * @param tokenId uint256 ID of the token to be transferred
1042      * @param _data bytes optional data to send along with the call
1043      * @return bool whether the call correctly returned the expected magic value
1044      */
1045     function _checkOnERC721Received(
1046         address from,
1047         address to,
1048         uint256 tokenId,
1049         bytes memory _data
1050     ) private returns (bool) {
1051         if (to.isContract()) {
1052             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1053                 return retval == IERC721Receiver.onERC721Received.selector;
1054             } catch (bytes memory reason) {
1055                 if (reason.length == 0) {
1056                     revert("ERC721: transfer to non ERC721Receiver implementer");
1057                 } else {
1058                     assembly {
1059                         revert(add(32, reason), mload(reason))
1060                     }
1061                 }
1062             }
1063         } else {
1064             return true;
1065         }
1066     }
1067 
1068     /**
1069      * @dev Hook that is called before any token transfer. This includes minting
1070      * and burning.
1071      *
1072      * Calling conditions:
1073      *
1074      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1075      * transferred to `to`.
1076      * - When `from` is zero, `tokenId` will be minted for `to`.
1077      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1078      * - `from` and `to` are never both zero.
1079      *
1080      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1081      */
1082     function _beforeTokenTransfer(
1083         address from,
1084         address to,
1085         uint256 tokenId
1086     ) internal virtual {}
1087 }
1088 
1089 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1090 
1091 
1092 
1093 pragma solidity ^0.8.0;
1094 
1095 
1096 
1097 /**
1098  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1099  * enumerability of all the token ids in the contract as well as all token ids owned by each
1100  * account.
1101  */
1102 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1103     // Mapping from owner to list of owned token IDs
1104     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1105 
1106     // Mapping from token ID to index of the owner tokens list
1107     mapping(uint256 => uint256) private _ownedTokensIndex;
1108 
1109     // Array with all token ids, used for enumeration
1110     uint256[] private _allTokens;
1111 
1112     // Mapping from token id to position in the allTokens array
1113     mapping(uint256 => uint256) private _allTokensIndex;
1114 
1115     /**
1116      * @dev See {IERC165-supportsInterface}.
1117      */
1118     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1119         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1120     }
1121 
1122     /**
1123      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1124      */
1125     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1126         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1127         return _ownedTokens[owner][index];
1128     }
1129 
1130     /**
1131      * @dev See {IERC721Enumerable-totalSupply}.
1132      */
1133     function totalSupply() public view virtual override returns (uint256) {
1134         return _allTokens.length;
1135     }
1136 
1137     /**
1138      * @dev See {IERC721Enumerable-tokenByIndex}.
1139      */
1140     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1141         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1142         return _allTokens[index];
1143     }
1144 
1145     /**
1146      * @dev Hook that is called before any token transfer. This includes minting
1147      * and burning.
1148      *
1149      * Calling conditions:
1150      *
1151      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1152      * transferred to `to`.
1153      * - When `from` is zero, `tokenId` will be minted for `to`.
1154      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1155      * - `from` cannot be the zero address.
1156      * - `to` cannot be the zero address.
1157      *
1158      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1159      */
1160     function _beforeTokenTransfer(
1161         address from,
1162         address to,
1163         uint256 tokenId
1164     ) internal virtual override {
1165         super._beforeTokenTransfer(from, to, tokenId);
1166 
1167         if (from == address(0)) {
1168             _addTokenToAllTokensEnumeration(tokenId);
1169         } else if (from != to) {
1170             _removeTokenFromOwnerEnumeration(from, tokenId);
1171         }
1172         if (to == address(0)) {
1173             _removeTokenFromAllTokensEnumeration(tokenId);
1174         } else if (to != from) {
1175             _addTokenToOwnerEnumeration(to, tokenId);
1176         }
1177     }
1178 
1179     /**
1180      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1181      * @param to address representing the new owner of the given token ID
1182      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1183      */
1184     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1185         uint256 length = ERC721.balanceOf(to);
1186         _ownedTokens[to][length] = tokenId;
1187         _ownedTokensIndex[tokenId] = length;
1188     }
1189 
1190     /**
1191      * @dev Private function to add a token to this extension's token tracking data structures.
1192      * @param tokenId uint256 ID of the token to be added to the tokens list
1193      */
1194     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1195         _allTokensIndex[tokenId] = _allTokens.length;
1196         _allTokens.push(tokenId);
1197     }
1198 
1199     /**
1200      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1201      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1202      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1203      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1204      * @param from address representing the previous owner of the given token ID
1205      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1206      */
1207     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1208         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1209         // then delete the last slot (swap and pop).
1210 
1211         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1212         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1213 
1214         // When the token to delete is the last token, the swap operation is unnecessary
1215         if (tokenIndex != lastTokenIndex) {
1216             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1217 
1218             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1219             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1220         }
1221 
1222         // This also deletes the contents at the last position of the array
1223         delete _ownedTokensIndex[tokenId];
1224         delete _ownedTokens[from][lastTokenIndex];
1225     }
1226 
1227     /**
1228      * @dev Private function to remove a token from this extension's token tracking data structures.
1229      * This has O(1) time complexity, but alters the order of the _allTokens array.
1230      * @param tokenId uint256 ID of the token to be removed from the tokens list
1231      */
1232     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1233         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1234         // then delete the last slot (swap and pop).
1235 
1236         uint256 lastTokenIndex = _allTokens.length - 1;
1237         uint256 tokenIndex = _allTokensIndex[tokenId];
1238 
1239         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1240         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1241         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1242         uint256 lastTokenId = _allTokens[lastTokenIndex];
1243 
1244         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1245         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1246 
1247         // This also deletes the contents at the last position of the array
1248         delete _allTokensIndex[tokenId];
1249         _allTokens.pop();
1250     }
1251 }
1252 
1253 // File: contract-f5c0edde6e.sol
1254 
1255 
1256 pragma solidity ^0.8.0;
1257 
1258 
1259 
1260 contract EthereumScape is ERC721Enumerable, Ownable {
1261 
1262     using Strings for uint256;
1263 
1264     string _baseTokenURI;
1265     uint256 private _reserved = 200;
1266     uint256 private _price = 0.02 ether;
1267     bool public _paused = false;
1268     bool public mintIsActive = true;
1269 
1270     address t1 = 0xcE22eA7E78286E6364899d53cFb7a252F6aEc989;
1271 
1272 
1273     constructor(string memory baseURI) ERC721("EthereumScape", "SCAPE")  {
1274         setBaseURI(baseURI);
1275 
1276     }
1277 
1278     function Mint(uint256 num) public payable {
1279         uint256 supply = totalSupply();
1280         require( !_paused,                              "Sale paused" );
1281         require( num < 21,                              "You can mint a maximum of 20 EtheureumScape" );
1282         require( supply + num < 8888 - _reserved,      "Exceeds maximum EtheureumScape supply" );
1283         require( msg.value >= _price * num,             "Ether sent is not correct" );
1284 
1285         for(uint256 i; i < num; i++){
1286             _safeMint( msg.sender, supply + i );
1287         }
1288     }
1289 
1290     function walletOfOwner(address _owner) public view returns(uint256[] memory) {
1291         uint256 tokenCount = balanceOf(_owner);
1292 
1293         uint256[] memory tokensId = new uint256[](tokenCount);
1294         for(uint256 i; i < tokenCount; i++){
1295             tokensId[i] = tokenOfOwnerByIndex(_owner, i);
1296         }
1297         return tokensId;
1298     }
1299 
1300     function setPrice(uint256 _newPrice) public onlyOwner() {
1301         _price = _newPrice;
1302     }
1303 
1304     function _baseURI() internal view virtual override returns (string memory) {
1305         return _baseTokenURI;
1306     }
1307 
1308     function setBaseURI(string memory baseURI) public onlyOwner {
1309         _baseTokenURI = baseURI;
1310     }
1311 
1312     function getPrice() public view returns (uint256){
1313         return _price;
1314     }
1315 
1316     function giveAway(address _to, uint256 _amount) external onlyOwner() {
1317         require( _amount <= _reserved, "Exceeds reserved EthereumScape" );
1318 
1319         uint256 supply = totalSupply();
1320         for(uint256 i; i < _amount; i++){
1321             _safeMint( _to, supply + i );
1322         }
1323 
1324         _reserved -= _amount;
1325     }
1326 
1327     function pause(bool val) public onlyOwner {
1328         _paused = val;
1329     }
1330     
1331 
1332     function withdrawAll() public payable onlyOwner {
1333         uint256 _each = address(this).balance;
1334         require(payable(t1).send(_each));
1335     }
1336 }