1 // SPDX-License-Identifier: GPL-3.0
2 // File: @openzeppelin/contracts/utils/Strings.sol
3 
4 /// @title WingWars
5 /// @author André Costa @ Terratecc
6 
7 
8 pragma solidity ^0.8.9;
9 
10 /**
11  * @dev String operations.
12  */
13 library Strings {
14     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
15 
16     /**
17      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
18      */
19     function toString(uint256 value) internal pure returns (string memory) {
20         // Inspired by OraclizeAPI's implementation - MIT licence
21         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
22 
23         if (value == 0) {
24             return "0";
25         }
26         uint256 temp = value;
27         uint256 digits;
28         while (temp != 0) {
29             digits++;
30             temp /= 10;
31         }
32         bytes memory buffer = new bytes(digits);
33         while (value != 0) {
34             digits -= 1;
35             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
36             value /= 10;
37         }
38         return string(buffer);
39     }
40 
41     /**
42      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
43      */
44     function toHexString(uint256 value) internal pure returns (string memory) {
45         if (value == 0) {
46             return "0x00";
47         }
48         uint256 temp = value;
49         uint256 length = 0;
50         while (temp != 0) {
51             length++;
52             temp >>= 8;
53         }
54         return toHexString(value, length);
55     }
56 
57     /**
58      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
59      */
60     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
61         bytes memory buffer = new bytes(2 * length + 2);
62         buffer[0] = "0";
63         buffer[1] = "x";
64         for (uint256 i = 2 * length + 1; i > 1; --i) {
65             buffer[i] = _HEX_SYMBOLS[value & 0xf];
66             value >>= 4;
67         }
68         require(value == 0, "Strings: hex length insufficient");
69         return string(buffer);
70     }
71 }
72 
73 // File: @openzeppelin/contracts/utils/Context.sol
74 
75 
76 
77 pragma solidity ^0.8.9;
78 
79 /**
80  * @dev Provides information about the current execution context, including the
81  * sender of the transaction and its data. While these are generally available
82  * via msg.sender and msg.data, they should not be accessed in such a direct
83  * manner, since when dealing with meta-transactions the account sending and
84  * paying for execution may not be the actual sender (as far as an application
85  * is concerned).
86  *
87  * This contract is only required for intermediate, library-like contracts.
88  */
89 abstract contract Context {
90     function _msgSender() internal view virtual returns (address) {
91         return msg.sender;
92     }
93 
94     function _msgData() internal view virtual returns (bytes calldata) {
95         return msg.data;
96     }
97 }
98 
99 // File: @openzeppelin/contracts/access/Ownable.sol
100 
101 
102 
103 pragma solidity ^0.8.9;
104 
105 
106 /**
107  * @dev Contract module which provides a basic access control mechanism, where
108  * there is an account (an owner) that can be granted exclusive access to
109  * specific functions.
110  *
111  * By default, the owner account will be the one that deploys the contract. This
112  * can later be changed with {transferOwnership}.
113  *
114  * This module is used through inheritance. It will make available the modifier
115  * `onlyOwner`, which can be applied to your functions to restrict their use to
116  * the owner.
117  */
118 abstract contract Ownable is Context {
119     address private _owner;
120 
121     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
122 
123     /**
124      * @dev Initializes the contract setting the deployer as the initial owner.
125      */
126     constructor() {
127         _setOwner(_msgSender());
128     }
129 
130     /**
131      * @dev Returns the address of the current owner.
132      */
133     function owner() public view virtual returns (address) {
134         return _owner;
135     }
136 
137     /**
138      * @dev Throws if called by any account other than the owner.
139      */
140     modifier onlyOwner() {
141         require(owner() == _msgSender(), "Ownable: caller is not the owner");
142         _;
143     }
144 
145     /**
146      * @dev Leaves the contract without owner. It will not be possible to call
147      * `onlyOwner` functions anymore. Can only be called by the current owner.
148      *
149      * NOTE: Renouncing ownership will leave the contract without an owner,
150      * thereby removing any functionality that is only available to the owner.
151      */
152     function renounceOwnership() public virtual onlyOwner {
153         _setOwner(address(0));
154     }
155 
156     /**
157      * @dev Transfers ownership of the contract to a new account (`newOwner`).
158      * Can only be called by the current owner.
159      */
160     function transferOwnership(address newOwner) public virtual onlyOwner {
161         require(newOwner != address(0), "Ownable: new owner is the zero address");
162         _setOwner(newOwner);
163     }
164 
165     function _setOwner(address newOwner) private {
166         address oldOwner = _owner;
167         _owner = newOwner;
168         emit OwnershipTransferred(oldOwner, newOwner);
169     }
170 }
171 
172 // File: @openzeppelin/contracts/utils/Address.sol
173 
174 
175 
176 pragma solidity ^0.8.9;
177 
178 /**
179  * @dev Collection of functions related to the address type
180  */
181 library Address {
182     /**
183      * @dev Returns true if `account` is a contract.
184      *
185      * [IMPORTANT]
186      * ====
187      * It is unsafe to assume that an address for which this function returns
188      * false is an externally-owned account (EOA) and not a contract.
189      *
190      * Among others, `isContract` will return false for the following
191      * types of addresses:
192      *
193      *  - an externally-owned account
194      *  - a contract in construction
195      *  - an address where a contract will be created
196      *  - an address where a contract lived, but was destroyed
197      * ====
198      */
199     function isContract(address account) internal view returns (bool) {
200         // This method relies on extcodesize, which returns 0 for contracts in
201         // construction, since the code is only stored at the end of the
202         // constructor execution.
203 
204         uint256 size;
205         assembly {
206             size := extcodesize(account)
207         }
208         return size > 0;
209     }
210 
211     /**
212      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
213      * `recipient`, forwarding all available gas and reverting on errors.
214      *
215      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
216      * of certain opcodes, possibly making contracts go over the 2300 gas limit
217      * imposed by `transfer`, making them unable to receive funds via
218      * `transfer`. {sendValue} removes this limitation.
219      *
220      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
221      *
222      * IMPORTANT: because control is transferred to `recipient`, care must be
223      * taken to not create reentrancy vulnerabilities. Consider using
224      * {ReentrancyGuard} or the
225      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
226      */
227     function sendValue(address payable recipient, uint256 amount) internal {
228         require(address(this).balance >= amount, "Address: insufficient balance");
229 
230         (bool success, ) = recipient.call{value: amount}("");
231         require(success, "Address: unable to send value, recipient may have reverted");
232     }
233 
234     /**
235      * @dev Performs a Solidity function call using a low level `call`. A
236      * plain `call` is an unsafe replacement for a function call: use this
237      * function instead.
238      *
239      * If `target` reverts with a revert reason, it is bubbled up by this
240      * function (like regular Solidity function calls).
241      *
242      * Returns the raw returned data. To convert to the expected return value,
243      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
244      *
245      * Requirements:
246      *
247      * - `target` must be a contract.
248      * - calling `target` with `data` must not revert.
249      *
250      * _Available since v3.1._
251      */
252     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
253         return functionCall(target, data, "Address: low-level call failed");
254     }
255 
256     /**
257      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
258      * `errorMessage` as a fallback revert reason when `target` reverts.
259      *
260      * _Available since v3.1._
261      */
262     function functionCall(
263         address target,
264         bytes memory data,
265         string memory errorMessage
266     ) internal returns (bytes memory) {
267         return functionCallWithValue(target, data, 0, errorMessage);
268     }
269 
270     /**
271      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
272      * but also transferring `value` wei to `target`.
273      *
274      * Requirements:
275      *
276      * - the calling contract must have an ETH balance of at least `value`.
277      * - the called Solidity function must be `payable`.
278      *
279      * _Available since v3.1._
280      */
281     function functionCallWithValue(
282         address target,
283         bytes memory data,
284         uint256 value
285     ) internal returns (bytes memory) {
286         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
287     }
288 
289     /**
290      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
291      * with `errorMessage` as a fallback revert reason when `target` reverts.
292      *
293      * _Available since v3.1._
294      */
295     function functionCallWithValue(
296         address target,
297         bytes memory data,
298         uint256 value,
299         string memory errorMessage
300     ) internal returns (bytes memory) {
301         require(address(this).balance >= value, "Address: insufficient balance for call");
302         require(isContract(target), "Address: call to non-contract");
303 
304         (bool success, bytes memory returndata) = target.call{value: value}(data);
305         return verifyCallResult(success, returndata, errorMessage);
306     }
307 
308     /**
309      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
310      * but performing a static call.
311      *
312      * _Available since v3.3._
313      */
314     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
315         return functionStaticCall(target, data, "Address: low-level static call failed");
316     }
317 
318     /**
319      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
320      * but performing a static call.
321      *
322      * _Available since v3.3._
323      */
324     function functionStaticCall(
325         address target,
326         bytes memory data,
327         string memory errorMessage
328     ) internal view returns (bytes memory) {
329         require(isContract(target), "Address: static call to non-contract");
330 
331         (bool success, bytes memory returndata) = target.staticcall(data);
332         return verifyCallResult(success, returndata, errorMessage);
333     }
334 
335     /**
336      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
337      * but performing a delegate call.
338      *
339      * _Available since v3.4._
340      */
341     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
342         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
343     }
344 
345     /**
346      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
347      * but performing a delegate call.
348      *
349      * _Available since v3.4._
350      */
351     function functionDelegateCall(
352         address target,
353         bytes memory data,
354         string memory errorMessage
355     ) internal returns (bytes memory) {
356         require(isContract(target), "Address: delegate call to non-contract");
357 
358         (bool success, bytes memory returndata) = target.delegatecall(data);
359         return verifyCallResult(success, returndata, errorMessage);
360     }
361 
362     /**
363      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
364      * revert reason using the provided one.
365      *
366      * _Available since v4.3._
367      */
368     function verifyCallResult(
369         bool success,
370         bytes memory returndata,
371         string memory errorMessage
372     ) internal pure returns (bytes memory) {
373         if (success) {
374             return returndata;
375         } else {
376             // Look for revert reason and bubble it up if present
377             if (returndata.length > 0) {
378                 // The easiest way to bubble the revert reason is using memory via assembly
379 
380                 assembly {
381                     let returndata_size := mload(returndata)
382                     revert(add(32, returndata), returndata_size)
383                 }
384             } else {
385                 revert(errorMessage);
386             }
387         }
388     }
389 }
390 
391 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
392 
393 pragma solidity ^0.8.9;
394 
395 /**
396  * @title ERC721 token receiver interface
397  * @dev Interface for any contract that wants to support safeTransfers
398  * from ERC721 asset contracts.
399  */
400 interface IERC721Receiver {
401     /**
402      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
403      * by `operator` from `from`, this function is called.
404      *
405      * It must return its Solidity selector to confirm the token transfer.
406      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
407      *
408      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
409      */
410     function onERC721Received(
411         address operator,
412         address from,
413         uint256 tokenId,
414         bytes calldata data
415     ) external returns (bytes4);
416 }
417 
418 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
419 
420 
421 
422 pragma solidity ^0.8.9;
423 
424 /**
425  * @dev Interface of the ERC165 standard, as defined in the
426  * https://eips.ethereum.org/EIPS/eip-165[EIP].
427  *
428  * Implementers can declare support of contract interfaces, which can then be
429  * queried by others ({ERC165Checker}).
430  *
431  * For an implementation, see {ERC165}.
432  */
433 interface IERC165 {
434     /**
435      * @dev Returns true if this contract implements the interface defined by
436      * `interfaceId`. See the corresponding
437      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
438      * to learn more about how these ids are created.
439      *
440      * This function call must use less than 30 000 gas.
441      */
442     function supportsInterface(bytes4 interfaceId) external view returns (bool);
443 }
444 
445 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
446 
447 
448 
449 pragma solidity ^0.8.9;
450 
451 
452 /**
453  * @dev Implementation of the {IERC165} interface.
454  *
455  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
456  * for the additional interface id that will be supported. For example:
457  *
458  * ```solidity
459  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
460  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
461  * }
462  * ```
463  *
464  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
465  */
466 abstract contract ERC165 is IERC165 {
467     /**
468      * @dev See {IERC165-supportsInterface}.
469      */
470     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
471         return interfaceId == type(IERC165).interfaceId;
472     }
473 }
474 
475 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
476 
477 
478 
479 pragma solidity ^0.8.9;
480 
481 
482 /**
483  * @dev Required interface of an ERC721 compliant contract.
484  */
485 interface IERC721 is IERC165 {
486     /**
487      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
488      */
489     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
490 
491     /**
492      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
493      */
494     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
495 
496     /**
497      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
498      */
499     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
500 
501     /**
502      * @dev Returns the number of tokens in ``owner``'s account.
503      */
504     function balanceOf(address owner) external view returns (uint256 balance);
505 
506     /**
507      * @dev Returns the owner of the `tokenId` token.
508      *
509      * Requirements:
510      *
511      * - `tokenId` must exist.
512      */
513     function ownerOf(uint256 tokenId) external view returns (address owner);
514 
515     /**
516      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
517      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
518      *
519      * Requirements:
520      *
521      * - `from` cannot be the zero address.
522      * - `to` cannot be the zero address.
523      * - `tokenId` token must exist and be owned by `from`.
524      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
525      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
526      *
527      * Emits a {Transfer} event.
528      */
529     function safeTransferFrom(
530         address from,
531         address to,
532         uint256 tokenId
533     ) external;
534 
535     /**
536      * @dev Transfers `tokenId` token from `from` to `to`.
537      *
538      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
539      *
540      * Requirements:
541      *
542      * - `from` cannot be the zero address.
543      * - `to` cannot be the zero address.
544      * - `tokenId` token must be owned by `from`.
545      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
546      *
547      * Emits a {Transfer} event.
548      */
549     function transferFrom(
550         address from,
551         address to,
552         uint256 tokenId
553     ) external;
554 
555     /**
556      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
557      * The approval is cleared when the token is transferred.
558      *
559      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
560      *
561      * Requirements:
562      *
563      * - The caller must own the token or be an approved operator.
564      * - `tokenId` must exist.
565      *
566      * Emits an {Approval} event.
567      */
568     function approve(address to, uint256 tokenId) external;
569 
570     /**
571      * @dev Returns the account approved for `tokenId` token.
572      *
573      * Requirements:
574      *
575      * - `tokenId` must exist.
576      */
577     function getApproved(uint256 tokenId) external view returns (address operator);
578 
579     /**
580      * @dev Approve or remove `operator` as an operator for the caller.
581      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
582      *
583      * Requirements:
584      *
585      * - The `operator` cannot be the caller.
586      *
587      * Emits an {ApprovalForAll} event.
588      */
589     function setApprovalForAll(address operator, bool _approved) external;
590 
591     /**
592      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
593      *
594      * See {setApprovalForAll}
595      */
596     function isApprovedForAll(address owner, address operator) external view returns (bool);
597 
598     /**
599      * @dev Safely transfers `tokenId` token from `from` to `to`.
600      *
601      * Requirements:
602      *
603      * - `from` cannot be the zero address.
604      * - `to` cannot be the zero address.
605      * - `tokenId` token must exist and be owned by `from`.
606      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
607      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
608      *
609      * Emits a {Transfer} event.
610      */
611     function safeTransferFrom(
612         address from,
613         address to,
614         uint256 tokenId,
615         bytes calldata data
616     ) external;
617 }
618 
619 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
620 
621 
622 
623 pragma solidity ^0.8.9;
624 
625 
626 /**
627  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
628  * @dev See https://eips.ethereum.org/EIPS/eip-721
629  */
630 interface IERC721Metadata is IERC721 {
631     /**
632      * @dev Returns the token collection name.
633      */
634     function name() external view returns (string memory);
635 
636     /**
637      * @dev Returns the token collection symbol.
638      */
639     function symbol() external view returns (string memory);
640 
641     /**
642      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
643      */
644     function tokenURI(uint256 tokenId) external view returns (string memory);
645 }
646 
647 
648 pragma solidity >=0.8.9;
649 // to enable certain compiler features
650 
651 
652 
653 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
654     using Address for address;
655     using Strings for uint256;
656 
657     // Token name
658     string private _name;
659 
660     // Token symbol
661     string private _symbol;
662 
663     // Mapping from token ID to owner address
664     mapping(uint256 => address) private _owners;
665 
666     // Mapping owner address to token count
667     mapping(address => uint256) private _balances;
668 
669     // Mapping from token ID to approved address
670     mapping(uint256 => address) private _tokenApprovals;
671 
672     // Mapping from owner to operator approvals
673     mapping(address => mapping(address => bool)) private _operatorApprovals;
674     
675     //Mapping para atribuirle un URI para cada token
676     mapping(uint256 => string) internal id_to_URI;
677 
678     /**
679      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
680      */
681     constructor(string memory name_, string memory symbol_) {
682         _name = name_;
683         _symbol = symbol_;
684     }
685 
686     /**
687      * @dev See {IERC165-supportsInterface}.
688      */
689     
690     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
691         return
692             interfaceId == type(IERC721).interfaceId ||
693             interfaceId == type(IERC721Metadata).interfaceId ||
694             super.supportsInterface(interfaceId);
695     }
696     
697 
698     /**
699      * @dev See {IERC721-balanceOf}.
700      */
701     function balanceOf(address owner) public view virtual override returns (uint256) {
702         require(owner != address(0), "ERC721: balance query for the zero address");
703         return _balances[owner];
704     }
705 
706     /**
707      * @dev See {IERC721-ownerOf}.
708      */
709     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
710         address owner = _owners[tokenId];
711         require(owner != address(0), "ERC721: owner query for nonexistent token");
712         return owner;
713     }
714 
715     /**
716      * @dev See {IERC721Metadata-name}.
717      */
718     function name() public view virtual override returns (string memory) {
719         return _name;
720     }
721 
722     /**
723      * @dev See {IERC721Metadata-symbol}.
724      */
725     function symbol() public view virtual override returns (string memory) {
726         return _symbol;
727     }
728 
729     /**
730      * @dev See {IERC721Metadata-tokenURI}.
731      */
732     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {  }
733 
734     /**
735      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
736      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
737      * by default, can be overriden in child contracts.
738      */
739     function _baseURI() internal view virtual returns (string memory) {
740         return "";
741     }
742 
743     /**
744      * @dev See {IERC721-approve}.
745      */
746     function approve(address to, uint256 tokenId) public virtual override {
747         address owner = ERC721.ownerOf(tokenId);
748         require(to != owner, "ERC721: approval to current owner");
749 
750         require(
751             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
752             "ERC721: approve caller is not owner nor approved for all"
753         );
754 
755         _approve(to, tokenId);
756     }
757 
758     /**
759      * @dev See {IERC721-getApproved}.
760      */
761     function getApproved(uint256 tokenId) public view virtual override returns (address) {
762         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
763 
764         return _tokenApprovals[tokenId];
765     }
766 
767     /**
768      * @dev See {IERC721-setApprovalForAll}.
769      */
770     function setApprovalForAll(address operator, bool approved) public virtual override {
771         require(operator != _msgSender(), "ERC721: approve to caller");
772 
773         _operatorApprovals[_msgSender()][operator] = approved;
774         emit ApprovalForAll(_msgSender(), operator, approved);
775     }
776 
777     /**
778      * @dev See {IERC721-isApprovedForAll}.
779      */
780     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
781         return _operatorApprovals[owner][operator];
782     }
783 
784     /**
785      * @dev See {IERC721-transferFrom}.
786      */
787     function transferFrom(
788         address from,
789         address to,
790         uint256 tokenId
791     ) public virtual override {
792         //solhint-disable-next-line max-line-length
793         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
794 
795         _transfer(from, to, tokenId);
796     }
797 
798     /**
799      * @dev See {IERC721-safeTransferFrom}.
800      */
801     function safeTransferFrom(
802         address from,
803         address to,
804         uint256 tokenId
805     ) public virtual override {
806         safeTransferFrom(from, to, tokenId, "");
807     }
808 
809     /**
810      * @dev See {IERC721-safeTransferFrom}.
811      */
812     function safeTransferFrom(
813         address from,
814         address to,
815         uint256 tokenId,
816         bytes memory _data
817     ) public virtual override {
818         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
819         _safeTransfer(from, to, tokenId, _data);
820     }
821 
822     /**
823      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
824      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
825      *
826      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
827      *
828      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
829      * implement alternative mechanisms to perform token transfer, such as signature-based.
830      *
831      * Requirements:
832      *
833      * - `from` cannot be the zero address.
834      * - `to` cannot be the zero address.
835      * - `tokenId` token must exist and be owned by `from`.
836      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
837      *
838      * Emits a {Transfer} event.
839      */
840     function _safeTransfer(
841         address from,
842         address to,
843         uint256 tokenId,
844         bytes memory _data
845     ) internal virtual {
846         _transfer(from, to, tokenId);
847         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
848     }
849 
850     /**
851      * @dev Returns whether `tokenId` exists.
852      *
853      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
854      *
855      * Tokens start existing when they are minted (`_mint`),
856      * and stop existing when they are burned (`_burn`).
857      */
858     function _exists(uint256 tokenId) internal view virtual returns (bool) {
859         return _owners[tokenId] != address(0);
860     }
861 
862     /**
863      * @dev Returns whether `spender` is allowed to manage `tokenId`.
864      *
865      * Requirements:
866      *
867      * - `tokenId` must exist.
868      */
869     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
870         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
871         address owner = ERC721.ownerOf(tokenId);
872         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
873     }
874 
875     /**
876      * @dev Safely mints `tokenId` and transfers it to `to`.
877      *
878      * Requirements:
879      *
880      * - `tokenId` must not exist.
881      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
882      *
883      * Emits a {Transfer} event.
884      */
885     function _safeMint(address to, uint256 tokenId) internal virtual {
886         _safeMint(to, tokenId, "");
887     }
888 
889     /**
890      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
891      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
892      */
893     function _safeMint(
894         address to,
895         uint256 tokenId,
896         bytes memory _data
897     ) internal virtual {
898         _mint(to, tokenId);
899         require(
900             _checkOnERC721Received(address(0), to, tokenId, _data),
901             "ERC721: transfer to non ERC721Receiver implementer"
902         );
903     }
904 
905     /**
906      * @dev Mints `tokenId` and transfers it to `to`.
907      *
908      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
909      *
910      * Requirements:
911      *
912      * - `tokenId` must not exist.
913      * - `to` cannot be the zero address.
914      *
915      * Emits a {Transfer} event.
916      */
917     function _mint(address to, uint256 tokenId) internal virtual {
918         require(to != address(0), "ERC721: mint to the zero address");
919         require(!_exists(tokenId), "ERC721: token already minted");
920 
921         _beforeTokenTransfer(address(0), to, tokenId);
922 
923         _balances[to] += 1;
924         _owners[tokenId] = to;
925 
926         emit Transfer(address(0), to, tokenId);
927     }
928 
929     /**
930      * @dev Destroys `tokenId`.
931      * The approval is cleared when the token is burned.
932      *
933      * Requirements:
934      *
935      * - `tokenId` must exist.
936      *
937      * Emits a {Transfer} event.
938      */
939     function _burn(uint256 tokenId) internal virtual {
940         address owner = ERC721.ownerOf(tokenId);
941 
942         _beforeTokenTransfer(owner, address(0), tokenId);
943 
944         // Clear approvals
945         _approve(address(0), tokenId);
946 
947         _balances[owner] -= 1;
948         delete _owners[tokenId];
949 
950         emit Transfer(owner, address(0), tokenId);
951     }
952 
953     /**
954      * @dev Transfers `tokenId` from `from` to `to`.
955      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
956      *
957      * Requirements:
958      *
959      * - `to` cannot be the zero address.
960      * - `tokenId` token must be owned by `from`.
961      *
962      * Emits a {Transfer} event.
963      */
964     function _transfer(
965         address from,
966         address to,
967         uint256 tokenId
968     ) internal virtual {
969         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
970         require(to != address(0), "ERC721: transfer to the zero address");
971 
972         _beforeTokenTransfer(from, to, tokenId);
973 
974         // Clear approvals from the previous owner
975         _approve(address(0), tokenId);
976 
977         _balances[from] -= 1;
978         _balances[to] += 1;
979         _owners[tokenId] = to;
980 
981         emit Transfer(from, to, tokenId);
982     }
983 
984     /**
985      * @dev Approve `to` to operate on `tokenId`
986      *
987      * Emits a {Approval} event.
988      */
989     function _approve(address to, uint256 tokenId) internal virtual {
990         _tokenApprovals[tokenId] = to;
991         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
992     }
993 
994     /**
995      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
996      * The call is not executed if the target address is not a contract.
997      *
998      * @param from address representing the previous owner of the given token ID
999      * @param to target address that will receive the tokens
1000      * @param tokenId uint256 ID of the token to be transferred
1001      * @param _data bytes optional data to send along with the call
1002      * @return bool whether the call correctly returned the expected magic value
1003      */
1004     function _checkOnERC721Received(
1005         address from,
1006         address to,
1007         uint256 tokenId,
1008         bytes memory _data
1009     ) private returns (bool) {
1010         if (to.isContract()) {
1011             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1012                 return retval == IERC721Receiver.onERC721Received.selector;
1013             } catch (bytes memory reason) {
1014                 if (reason.length == 0) {
1015                     revert("ERC721: transfer to non ERC721Receiver implementer");
1016                 } else {
1017                     assembly {
1018                         revert(add(32, reason), mload(reason))
1019                     }
1020                 }
1021             }
1022         } else {
1023             return true;
1024         }
1025     }
1026 
1027     /**
1028      * @dev Hook that is called before any token transfer. This includes minting
1029      * and burning.
1030      *
1031      * Calling conditions:
1032      *
1033      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1034      * transferred to `to`.
1035      * - When `from` is zero, `tokenId` will be minted for `to`.
1036      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1037      * - `from` and `to` are never both zero.
1038      *
1039      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1040      */
1041     function _beforeTokenTransfer(
1042         address from,
1043         address to,
1044         uint256 tokenId
1045     ) internal virtual {}
1046 }
1047 
1048 pragma solidity ^0.8.9;
1049 
1050 /**
1051  * @dev Contract module that helps prevent reentrant calls to a function.
1052  *
1053  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1054  * available, which can be applied to functions to make sure there are no nested
1055  * (reentrant) calls to them.
1056  *
1057  * Note that because there is a single `nonReentrant` guard, functions marked as
1058  * `nonReentrant` may not call one another. This can be worked around by making
1059  * those functions `private`, and then adding `external` `nonReentrant` entry
1060  * points to them.
1061  *
1062  * TIP: If you would like to learn more about reentrancy and alternative ways
1063  * to protect against it, check out our blog post
1064  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1065  */
1066 abstract contract ReentrancyGuard {
1067     // Booleans are more expensive than uint256 or any type that takes up a full
1068     // word because each write operation emits an extra SLOAD to first read the
1069     // slot's contents, replace the bits taken up by the boolean, and then write
1070     // back. This is the compiler's defense against contract upgrades and
1071     // pointer aliasing, and it cannot be disabled.
1072 
1073     // The values being non-zero value makes deployment a bit more expensive,
1074     // but in exchange the refund on every call to nonReentrant will be lower in
1075     // amount. Since refunds are capped to a percentage of the total
1076     // transaction's gas, it is best to keep them low in cases like this one, to
1077     // increase the likelihood of the full refund coming into effect.
1078     uint256 private constant _NOT_ENTERED = 1;
1079     uint256 private constant _ENTERED = 2;
1080 
1081     uint256 private _status;
1082 
1083     constructor() {
1084         _status = _NOT_ENTERED;
1085     }
1086 
1087     /**
1088      * @dev Prevents a contract from calling itself, directly or indirectly.
1089      * Calling a `nonReentrant` function from another `nonReentrant`
1090      * function is not supported. It is possible to prevent this from happening
1091      * by making the `nonReentrant` function external, and making it call a
1092      * `private` function that does the actual work.
1093      */
1094     modifier nonReentrant() {
1095         // On the first call to nonReentrant, _notEntered will be true
1096         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1097 
1098         // Any calls to nonReentrant after this point will fail
1099         _status = _ENTERED;
1100 
1101         _;
1102 
1103         // By storing the original value once again, a refund is triggered (see
1104         // https://eips.ethereum.org/EIPS/eip-2200)
1105         _status = _NOT_ENTERED;
1106     }
1107 }
1108 
1109 
1110 pragma solidity ^0.8.9;
1111 
1112 /**
1113  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1114  * @dev See https://eips.ethereum.org/EIPS/eip-721
1115  */
1116 interface IERC721Enumerable is IERC721 {
1117     /**
1118      * @dev Returns the total amount of tokens stored by the contract.
1119      */
1120     function totalSupply() external view returns (uint256);
1121 
1122     /**
1123      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1124      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1125      */
1126     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1127 
1128     /**
1129      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1130      * Use along with {totalSupply} to enumerate all tokens.
1131      */
1132     function tokenByIndex(uint256 index) external view returns (uint256);
1133 }
1134 
1135 
1136 // Creator: Chiru Labs
1137 
1138 pragma solidity ^0.8.9;
1139 
1140 /**
1141  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1142  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1143  *
1144  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
1145  *
1146  * Does not support burning tokens to address(0).
1147  *
1148  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
1149  */
1150 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1151     using Address for address;
1152     using Strings for uint256;
1153 
1154     struct TokenOwnership {
1155         address addr;
1156         uint64 startTimestamp;
1157     }
1158 
1159     struct AddressData {
1160         uint128 balance;
1161         uint128 numberMinted;
1162     }
1163 
1164     uint256 internal currentIndex;
1165 
1166     // Token name
1167     string private _name;
1168 
1169     // Token symbol
1170     string private _symbol;
1171 
1172     // Mapping from token ID to ownership details
1173     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1174     mapping(uint256 => TokenOwnership) internal _ownerships;
1175 
1176     // Mapping owner address to address data
1177     mapping(address => AddressData) private _addressData;
1178 
1179     // Mapping from token ID to approved address
1180     mapping(uint256 => address) private _tokenApprovals;
1181 
1182     // Mapping from owner to operator approvals
1183     mapping(address => mapping(address => bool)) private _operatorApprovals;
1184 
1185     constructor(string memory name_, string memory symbol_) {
1186         _name = name_;
1187         _symbol = symbol_;
1188     }
1189 
1190     /**
1191      * @dev See {IERC721Enumerable-totalSupply}.
1192      */
1193     function totalSupply() public view virtual override returns (uint256) {
1194         return currentIndex;
1195     }
1196 
1197     /**
1198      * @dev See {IERC721Enumerable-tokenByIndex}.
1199      */
1200     function tokenByIndex(uint256 index) public view override returns (uint256) {
1201         require(index < totalSupply(), 'ERC721A: global index out of bounds');
1202         return index;
1203     }
1204 
1205     /**
1206      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1207      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1208      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1209      */
1210     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1211         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
1212         uint256 numMintedSoFar = totalSupply();
1213         uint256 tokenIdsIdx;
1214         address currOwnershipAddr;
1215 
1216         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
1217         unchecked {
1218             for (uint256 i; i < numMintedSoFar; i++) {
1219                 TokenOwnership memory ownership = _ownerships[i];
1220                 if (ownership.addr != address(0)) {
1221                     currOwnershipAddr = ownership.addr;
1222                 }
1223                 if (currOwnershipAddr == owner) {
1224                     if (tokenIdsIdx == index) {
1225                         return i;
1226                     }
1227                     tokenIdsIdx++;
1228                 }
1229             }
1230         }
1231 
1232         revert('ERC721A: unable to get token of owner by index');
1233     }
1234 
1235     /**
1236      * @dev See {IERC165-supportsInterface}.
1237      */
1238     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1239         return
1240             interfaceId == type(IERC721).interfaceId ||
1241             interfaceId == type(IERC721Metadata).interfaceId ||
1242             interfaceId == type(IERC721Enumerable).interfaceId ||
1243             super.supportsInterface(interfaceId);
1244     }
1245 
1246     /**
1247      * @dev See {IERC721-balanceOf}.
1248      */
1249     function balanceOf(address owner) public view override returns (uint256) {
1250         require(owner != address(0), 'ERC721A: balance query for the zero address');
1251         return uint256(_addressData[owner].balance);
1252     }
1253 
1254     function _numberMinted(address owner) internal view returns (uint256) {
1255         require(owner != address(0), 'ERC721A: number minted query for the zero address');
1256         return uint256(_addressData[owner].numberMinted);
1257     }
1258 
1259     /**
1260      * Gas spent here starts off proportional to the maximum mint batch size.
1261      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1262      */
1263     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1264         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
1265 
1266         unchecked {
1267             for (uint256 curr = tokenId; curr >= 0; curr--) {
1268                 TokenOwnership memory ownership = _ownerships[curr];
1269                 if (ownership.addr != address(0)) {
1270                     return ownership;
1271                 }
1272             }
1273         }
1274 
1275         revert('ERC721A: unable to determine the owner of token');
1276     }
1277 
1278     /**
1279      * @dev See {IERC721-ownerOf}.
1280      */
1281     function ownerOf(uint256 tokenId) public view override returns (address) {
1282         return ownershipOf(tokenId).addr;
1283     }
1284 
1285     /**
1286      * @dev See {IERC721Metadata-name}.
1287      */
1288     function name() public view virtual override returns (string memory) {
1289         return _name;
1290     }
1291 
1292     /**
1293      * @dev See {IERC721Metadata-symbol}.
1294      */
1295     function symbol() public view virtual override returns (string memory) {
1296         return _symbol;
1297     }
1298 
1299     /**
1300      * @dev See {IERC721Metadata-tokenURI}.
1301      */
1302     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1303         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
1304 
1305         string memory baseURI = _baseURI();
1306         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1307     }
1308 
1309     /**
1310      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1311      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1312      * by default, can be overriden in child contracts.
1313      */
1314     function _baseURI() internal view virtual returns (string memory) {
1315         return '';
1316     }
1317 
1318     /**
1319      * @dev See {IERC721-approve}.
1320      */
1321     function approve(address to, uint256 tokenId) public override {
1322         address owner = ERC721A.ownerOf(tokenId);
1323         require(to != owner, 'ERC721A: approval to current owner');
1324 
1325         require(
1326             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1327             'ERC721A: approve caller is not owner nor approved for all'
1328         );
1329 
1330         _approve(to, tokenId, owner);
1331     }
1332 
1333     /**
1334      * @dev See {IERC721-getApproved}.
1335      */
1336     function getApproved(uint256 tokenId) public view override returns (address) {
1337         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
1338 
1339         return _tokenApprovals[tokenId];
1340     }
1341 
1342     /**
1343      * @dev See {IERC721-setApprovalForAll}.
1344      */
1345     function setApprovalForAll(address operator, bool approved) public override {
1346         require(operator != _msgSender(), 'ERC721A: approve to caller');
1347 
1348         _operatorApprovals[_msgSender()][operator] = approved;
1349         emit ApprovalForAll(_msgSender(), operator, approved);
1350     }
1351 
1352     /**
1353      * @dev See {IERC721-isApprovedForAll}.
1354      */
1355     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1356         return _operatorApprovals[owner][operator];
1357     }
1358 
1359     /**
1360      * @dev See {IERC721-transferFrom}.
1361      */
1362     function transferFrom(
1363         address from,
1364         address to,
1365         uint256 tokenId
1366     ) public virtual override {
1367         _transfer(from, to, tokenId);
1368     }
1369 
1370     /**
1371      * @dev See {IERC721-safeTransferFrom}.
1372      */
1373     function safeTransferFrom(
1374         address from,
1375         address to,
1376         uint256 tokenId
1377     ) public virtual override {
1378         safeTransferFrom(from, to, tokenId, '');
1379     }
1380 
1381     /**
1382      * @dev See {IERC721-safeTransferFrom}.
1383      */
1384     function safeTransferFrom(
1385         address from,
1386         address to,
1387         uint256 tokenId,
1388         bytes memory _data
1389     ) public override {
1390         _transfer(from, to, tokenId);
1391         require(
1392             _checkOnERC721Received(from, to, tokenId, _data),
1393             'ERC721A: transfer to non ERC721Receiver implementer'
1394         );
1395     }
1396 
1397     /**
1398      * @dev Returns whether `tokenId` exists.
1399      *
1400      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1401      *
1402      * Tokens start existing when they are minted (`_mint`),
1403      */
1404     function _exists(uint256 tokenId) internal view returns (bool) {
1405         return tokenId < currentIndex;
1406     }
1407 
1408     function _safeMint(address to, uint256 quantity) internal {
1409         _safeMint(to, quantity, '');
1410     }
1411 
1412     /**
1413      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1414      *
1415      * Requirements:
1416      *
1417      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1418      * - `quantity` must be greater than 0.
1419      *
1420      * Emits a {Transfer} event.
1421      */
1422     function _safeMint(
1423         address to,
1424         uint256 quantity,
1425         bytes memory _data
1426     ) internal {
1427         _mint(to, quantity, _data, true);
1428     }
1429 
1430     /**
1431      * @dev Mints `quantity` tokens and transfers them to `to`.
1432      *
1433      * Requirements:
1434      *
1435      * - `to` cannot be the zero address.
1436      * - `quantity` must be greater than 0.
1437      *
1438      * Emits a {Transfer} event.
1439      */
1440     function _mint(
1441         address to,
1442         uint256 quantity,
1443         bytes memory _data,
1444         bool safe
1445     ) internal {
1446         uint256 startTokenId = currentIndex;
1447         require(to != address(0), 'ERC721A: mint to the zero address');
1448         require(quantity != 0, 'ERC721A: quantity must be greater than 0');
1449 
1450         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1451 
1452         // Overflows are incredibly unrealistic.
1453         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1454         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1455         unchecked {
1456             _addressData[to].balance += uint128(quantity);
1457             _addressData[to].numberMinted += uint128(quantity);
1458 
1459             _ownerships[startTokenId].addr = to;
1460             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1461 
1462             uint256 updatedIndex = startTokenId;
1463 
1464             for (uint256 i; i < quantity; i++) {
1465                 emit Transfer(address(0), to, updatedIndex);
1466                 if (safe) {
1467                     require(
1468                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1469                         'ERC721A: transfer to non ERC721Receiver implementer'
1470                     );
1471                 }
1472 
1473                 updatedIndex++;
1474             }
1475 
1476             currentIndex = updatedIndex;
1477         }
1478 
1479         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1480     }
1481 
1482     /**
1483      * @dev Transfers `tokenId` from `from` to `to`.
1484      *
1485      * Requirements:
1486      *
1487      * - `to` cannot be the zero address.
1488      * - `tokenId` token must be owned by `from`.
1489      *
1490      * Emits a {Transfer} event.
1491      */
1492     function _transfer(
1493         address from,
1494         address to,
1495         uint256 tokenId
1496     ) private {
1497         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1498 
1499         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1500             getApproved(tokenId) == _msgSender() ||
1501             isApprovedForAll(prevOwnership.addr, _msgSender()));
1502 
1503         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1504 
1505         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1506         require(to != address(0), 'ERC721A: transfer to the zero address');
1507 
1508         _beforeTokenTransfers(from, to, tokenId, 1);
1509 
1510         // Clear approvals from the previous owner
1511         _approve(address(0), tokenId, prevOwnership.addr);
1512 
1513         // Underflow of the sender's balance is impossible because we check for
1514         // ownership above and the recipient's balance can't realistically overflow.
1515         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1516         unchecked {
1517             _addressData[from].balance -= 1;
1518             _addressData[to].balance += 1;
1519 
1520             _ownerships[tokenId].addr = to;
1521             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1522 
1523             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1524             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1525             uint256 nextTokenId = tokenId + 1;
1526             if (_ownerships[nextTokenId].addr == address(0)) {
1527                 if (_exists(nextTokenId)) {
1528                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1529                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1530                 }
1531             }
1532         }
1533 
1534         emit Transfer(from, to, tokenId);
1535         _afterTokenTransfers(from, to, tokenId, 1);
1536     }
1537 
1538     /**
1539      * @dev Approve `to` to operate on `tokenId`
1540      *
1541      * Emits a {Approval} event.
1542      */
1543     function _approve(
1544         address to,
1545         uint256 tokenId,
1546         address owner
1547     ) private {
1548         _tokenApprovals[tokenId] = to;
1549         emit Approval(owner, to, tokenId);
1550     }
1551 
1552     /**
1553      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1554      * The call is not executed if the target address is not a contract.
1555      *
1556      * @param from address representing the previous owner of the given token ID
1557      * @param to target address that will receive the tokens
1558      * @param tokenId uint256 ID of the token to be transferred
1559      * @param _data bytes optional data to send along with the call
1560      * @return bool whether the call correctly returned the expected magic value
1561      */
1562     function _checkOnERC721Received(
1563         address from,
1564         address to,
1565         uint256 tokenId,
1566         bytes memory _data
1567     ) private returns (bool) {
1568         if (to.isContract()) {
1569             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1570                 return retval == IERC721Receiver(to).onERC721Received.selector;
1571             } catch (bytes memory reason) {
1572                 if (reason.length == 0) {
1573                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1574                 } else {
1575                     assembly {
1576                         revert(add(32, reason), mload(reason))
1577                     }
1578                 }
1579             }
1580         } else {
1581             return true;
1582         }
1583     }
1584 
1585     /**
1586      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1587      *
1588      * startTokenId - the first token id to be transferred
1589      * quantity - the amount to be transferred
1590      *
1591      * Calling conditions:
1592      *
1593      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1594      * transferred to `to`.
1595      * - When `from` is zero, `tokenId` will be minted for `to`.
1596      */
1597     function _beforeTokenTransfers(
1598         address from,
1599         address to,
1600         uint256 startTokenId,
1601         uint256 quantity
1602     ) internal virtual {}
1603 
1604     /**
1605      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1606      * minting.
1607      *
1608      * startTokenId - the first token id to be transferred
1609      * quantity - the amount to be transferred
1610      *
1611      * Calling conditions:
1612      *
1613      * - when `from` and `to` are both non-zero.
1614      * - `from` and `to` are never both zero.
1615      */
1616     function _afterTokenTransfers(
1617         address from,
1618         address to,
1619         uint256 startTokenId,
1620         uint256 quantity
1621     ) internal virtual {}
1622 }
1623 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
1624 
1625 
1626 contract WingWars is ERC721A, Ownable, ReentrancyGuard {
1627     
1628     using Strings for uint256;
1629     
1630     //declares the maximum amount of tokens that can be minted, total and in presale
1631     uint256 private maxTotalTokens;
1632     
1633     //initial part of the URI for the metadata
1634     string private _currentBaseURI;
1635     
1636     //the amount of reserved mints that have currently been executed by creator and giveaways
1637     uint private _reservedMints;
1638     
1639     //the maximum amount of reserved mints allowed for creator and giveaways
1640     uint private maxReservedMints = 100;
1641 
1642     //amount of mints that each address has executed
1643     mapping(address => uint256) public mintsPerAddress;
1644     
1645     //current state os sale
1646     enum State {NoSale, OpenSale}
1647 
1648     State private saleState_;
1649     
1650     //declaring initial values for variables
1651     constructor() ERC721A('Wing Wars', 'WW') {
1652         maxTotalTokens = 5000;
1653 
1654         _currentBaseURI = "ipfs://.../";
1655     }
1656     
1657     //in case somebody accidentaly sends funds or transaction to contract
1658     receive() payable external {}
1659     fallback() payable external {
1660         revert();
1661     }
1662     
1663     //visualize baseURI
1664     function _baseURI() internal view virtual override returns (string memory) {
1665         return _currentBaseURI;
1666     }
1667     
1668     //change baseURI in case needed for IPFS
1669     function changeBaseURI(string memory baseURI_) public onlyOwner {
1670         _currentBaseURI = baseURI_;
1671     }
1672 
1673     function setSaleState(uint newSaleState) public onlyOwner {
1674         require(newSaleState < 2, "Invalid Sale State!");
1675         if (newSaleState == 0) {
1676             saleState_ = State.NoSale;
1677         }
1678         else {
1679             saleState_ = State.OpenSale;
1680         }
1681     }
1682 
1683     //mint a @param number of NFTs in public sale
1684     function mint(uint number) public nonReentrant {
1685         require(msg.sender == tx.origin, "Sender is not the same as origin!");
1686         require(saleState_ == State.OpenSale, "Sale in not open yet!");
1687         require(totalSupply() < maxTotalTokens - (maxReservedMints - _reservedMints), "Not enough NFTs left to mint..");
1688         require(mintsPerAddress[msg.sender] + number <= 10, "Exceeds Mint Limit!");
1689 
1690         _safeMint(msg.sender, number);
1691         mintsPerAddress[msg.sender] += number;
1692     }
1693     
1694     function tokenURI(uint256 tokenId_) public view virtual override returns (string memory) {
1695         require(_exists(tokenId_), "ERC721Metadata: URI query for nonexistent token");
1696 
1697         tokenId_ += 1;
1698         string memory baseURI = _baseURI();
1699         return string(abi.encodePacked(baseURI, tokenId_.toString(), ".json")); 
1700     }
1701     
1702     //reserved NFTs for creator
1703     function reservedMint(uint number, address recipient) public onlyOwner {
1704         require(_reservedMints + number <= maxReservedMints, "Not enough Reserved NFTs left to mint..");
1705 
1706         _safeMint(recipient, number);
1707         mintsPerAddress[recipient] += number;
1708         _reservedMints += number; 
1709         
1710     }
1711     
1712     //burn the tokens that have not been sold yet
1713     function burnTokens() public onlyOwner {
1714         maxTotalTokens = totalSupply();
1715     }
1716     
1717     //se the current account balance
1718     function accountBalance() public onlyOwner view returns(uint) {
1719         return address(this).balance;
1720     }
1721     
1722     //retrieve all funds recieved from minting
1723     function withdraw() public onlyOwner {
1724         uint256 balance = accountBalance();
1725         require(balance > 0, 'No Funds to withdraw, Balance is 0');
1726 
1727         _withdraw(payable(msg.sender), balance); 
1728     }
1729     
1730     //send the percentage of funds to a shareholder´s wallet
1731     function _withdraw(address payable account, uint256 amount) internal {
1732         (bool sent, ) = account.call{value: amount}("");
1733         require(sent, "Failed to send Ether");
1734     }
1735     
1736     //to see the total amount of reserved mints left 
1737     function reservedMintsLeft() public onlyOwner view returns(uint) {
1738         return maxReservedMints - _reservedMints;
1739     }
1740     
1741     //see current state of sale
1742     //see the current state of the sale
1743     function saleState() public view returns(State){
1744         return saleState_;
1745     }
1746     
1747    
1748 }