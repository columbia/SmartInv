1 /**
2  *Submitted for verification at Etherscan.io on 2021-09-22
3 */
4 
5 // SPDX-License-Identifier: MIT
6 pragma solidity ^0.8.0;
7 
8 // File: @openzeppelin/contracts/utils/Context.sol
9 
10 /**
11  * @dev Provides information about the current execution context, including the
12  * sender of the transaction and its data. While these are generally available
13  * via msg.sender and msg.data, they should not be accessed in such a direct
14  * manner, since when dealing with meta-transactions the account sending and
15  * paying for execution may not be the actual sender (as far as an application
16  * is concerned).
17  *
18  * This contract is only required for intermediate, library-like contracts.
19  */
20 abstract contract Context {
21     function _msgSender() internal view virtual returns (address) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal view virtual returns (bytes calldata) {
26         return msg.data;
27     }
28 }
29 
30 // File: @openzeppelin/contracts/access/Ownable.sol
31 
32 /**
33  * @dev Contract module which provides a basic access control mechanism, where
34  * there is an account (an owner) that can be granted exclusive access to
35  * specific functions.
36  *
37  * By default, the owner account will be the one that deploys the contract. This
38  * can later be changed with {transferOwnership}.
39  *
40  * This module is used through inheritance. It will make available the modifier
41  * `onlyOwner`, which can be applied to your functions to restrict their use to
42  * the owner.
43  */
44 abstract contract Ownable is Context {
45     address private _owner;
46 
47     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48 
49     /**
50      * @dev Initializes the contract setting the deployer as the initial owner.
51      */
52     constructor() {
53         _setOwner(_msgSender());
54     }
55 
56     /**
57      * @dev Returns the address of the current owner.
58      */
59     function owner() public view virtual returns (address) {
60         return _owner;
61     }
62 
63     /**
64      * @dev Throws if called by any account other than the owner.
65      */
66     modifier onlyOwner() {
67         require(owner() == _msgSender(), "Ownable: caller is not the owner");
68         _;
69     }
70 
71     /**
72      * @dev Leaves the contract without owner. It will not be possible to call
73      * `onlyOwner` functions anymore. Can only be called by the current owner.
74      *
75      * NOTE: Renouncing ownership will leave the contract without an owner,
76      * thereby removing any functionality that is only available to the owner.
77      */
78     function renounceOwnership() public virtual onlyOwner {
79         _setOwner(address(0));
80     }
81 
82     /**
83      * @dev Transfers ownership of the contract to a new account (`newOwner`).
84      * Can only be called by the current owner.
85      */
86     function transferOwnership(address newOwner) public virtual onlyOwner {
87         require(newOwner != address(0), "Ownable: new owner is the zero address");
88         _setOwner(newOwner);
89     }
90 
91     function _setOwner(address newOwner) private {
92         address oldOwner = _owner;
93         _owner = newOwner;
94         emit OwnershipTransferred(oldOwner, newOwner);
95     }
96 }
97 
98 
99 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
100 
101 /**
102  * @dev Interface of the ERC165 standard, as defined in the
103  * https://eips.ethereum.org/EIPS/eip-165[EIP].
104  *
105  * Implementers can declare support of contract interfaces, which can then be
106  * queried by others ({ERC165Checker}).
107  *
108  * For an implementation, see {ERC165}.
109  */
110 interface IERC165 {
111     /**
112      * @dev Returns true if this contract implements the interface defined by
113      * `interfaceId`. See the corresponding
114      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
115      * to learn more about how these ids are created.
116      *
117      * This function call must use less than 30 000 gas.
118      */
119     function supportsInterface(bytes4 interfaceId) external view returns (bool);
120 }
121 
122 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
123 
124 /**
125  * @dev Required interface of an ERC721 compliant contract.
126  */
127 interface IERC721 is IERC165 {
128     /**
129      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
130      */
131     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
132 
133     /**
134      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
135      */
136     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
137 
138     /**
139      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
140      */
141     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
142 
143     /**
144      * @dev Returns the number of tokens in ``owner``'s account.
145      */
146     function balanceOf(address owner) external view returns (uint256 balance);
147 
148     /**
149      * @dev Returns the owner of the `tokenId` token.
150      *
151      * Requirements:
152      *
153      * - `tokenId` must exist.
154      */
155     function ownerOf(uint256 tokenId) external view returns (address owner);
156 
157     /**
158      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
159      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
160      *
161      * Requirements:
162      *
163      * - `from` cannot be the zero address.
164      * - `to` cannot be the zero address.
165      * - `tokenId` token must exist and be owned by `from`.
166      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
167      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
168      *
169      * Emits a {Transfer} event.
170      */
171     function safeTransferFrom(
172         address from,
173         address to,
174         uint256 tokenId
175     ) external;
176 
177     /**
178      * @dev Transfers `tokenId` token from `from` to `to`.
179      *
180      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
181      *
182      * Requirements:
183      *
184      * - `from` cannot be the zero address.
185      * - `to` cannot be the zero address.
186      * - `tokenId` token must be owned by `from`.
187      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
188      *
189      * Emits a {Transfer} event.
190      */
191     function transferFrom(
192         address from,
193         address to,
194         uint256 tokenId
195     ) external;
196 
197     /**
198      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
199      * The approval is cleared when the token is transferred.
200      *
201      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
202      *
203      * Requirements:
204      *
205      * - The caller must own the token or be an approved operator.
206      * - `tokenId` must exist.
207      *
208      * Emits an {Approval} event.
209      */
210     function approve(address to, uint256 tokenId) external;
211 
212     /**
213      * @dev Returns the account approved for `tokenId` token.
214      *
215      * Requirements:
216      *
217      * - `tokenId` must exist.
218      */
219     function getApproved(uint256 tokenId) external view returns (address operator);
220 
221     /**
222      * @dev Approve or remove `operator` as an operator for the caller.
223      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
224      *
225      * Requirements:
226      *
227      * - The `operator` cannot be the caller.
228      *
229      * Emits an {ApprovalForAll} event.
230      */
231     function setApprovalForAll(address operator, bool _approved) external;
232 
233     /**
234      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
235      *
236      * See {setApprovalForAll}
237      */
238     function isApprovedForAll(address owner, address operator) external view returns (bool);
239 
240     /**
241      * @dev Safely transfers `tokenId` token from `from` to `to`.
242      *
243      * Requirements:
244      *
245      * - `from` cannot be the zero address.
246      * - `to` cannot be the zero address.
247      * - `tokenId` token must exist and be owned by `from`.
248      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
249      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
250      *
251      * Emits a {Transfer} event.
252      */
253     function safeTransferFrom(
254         address from,
255         address to,
256         uint256 tokenId,
257         bytes calldata data
258     ) external;
259 }
260 
261 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
262 
263 /**
264  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
265  * @dev See https://eips.ethereum.org/EIPS/eip-721
266  */
267 interface IERC721Enumerable is IERC721 {
268     /**
269      * @dev Returns the total amount of tokens stored by the contract.
270      */
271     function totalSupply() external view returns (uint256);
272 
273     /**
274      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
275      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
276      */
277     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
278 
279     /**
280      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
281      * Use along with {totalSupply} to enumerate all tokens.
282      */
283     function tokenByIndex(uint256 index) external view returns (uint256);
284 }
285 
286 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
287 
288 
289 /**
290  * @dev Implementation of the {IERC165} interface.
291  *
292  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
293  * for the additional interface id that will be supported. For example:
294  *
295  * ```solidity
296  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
297  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
298  * }
299  * ```
300  *
301  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
302  */
303 abstract contract ERC165 is IERC165 {
304     /**
305      * @dev See {IERC165-supportsInterface}.
306      */
307     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
308         return interfaceId == type(IERC165).interfaceId;
309     }
310 }
311 
312 // File: @openzeppelin/contracts/utils/Strings.sol
313 
314 /**
315  * @dev String operations.
316  */
317 library Strings {
318     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
319 
320     /**
321      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
322      */
323     function toString(uint256 value) internal pure returns (string memory) {
324         // Inspired by OraclizeAPI's implementation - MIT licence
325         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
326 
327         if (value == 0) {
328             return "0";
329         }
330         uint256 temp = value;
331         uint256 digits;
332         while (temp != 0) {
333             digits++;
334             temp /= 10;
335         }
336         bytes memory buffer = new bytes(digits);
337         while (value != 0) {
338             digits -= 1;
339             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
340             value /= 10;
341         }
342         return string(buffer);
343     }
344 
345     /**
346      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
347      */
348     function toHexString(uint256 value) internal pure returns (string memory) {
349         if (value == 0) {
350             return "0x00";
351         }
352         uint256 temp = value;
353         uint256 length = 0;
354         while (temp != 0) {
355             length++;
356             temp >>= 8;
357         }
358         return toHexString(value, length);
359     }
360 
361     /**
362      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
363      */
364     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
365         bytes memory buffer = new bytes(2 * length + 2);
366         buffer[0] = "0";
367         buffer[1] = "x";
368         for (uint256 i = 2 * length + 1; i > 1; --i) {
369             buffer[i] = _HEX_SYMBOLS[value & 0xf];
370             value >>= 4;
371         }
372         require(value == 0, "Strings: hex length insufficient");
373         return string(buffer);
374     }
375 }
376 
377 // File: @openzeppelin/contracts/utils/Address.sol
378 
379 /**
380  * @dev Collection of functions related to the address type
381  */
382 library Address {
383     /**
384      * @dev Returns true if `account` is a contract.
385      *
386      * [IMPORTANT]
387      * ====
388      * It is unsafe to assume that an address for which this function returns
389      * false is an externally-owned account (EOA) and not a contract.
390      *
391      * Among others, `isContract` will return false for the following
392      * types of addresses:
393      *
394      *  - an externally-owned account
395      *  - a contract in construction
396      *  - an address where a contract will be created
397      *  - an address where a contract lived, but was destroyed
398      * ====
399      */
400     function isContract(address account) internal view returns (bool) {
401         // This method relies on extcodesize, which returns 0 for contracts in
402         // construction, since the code is only stored at the end of the
403         // constructor execution.
404 
405         uint256 size;
406         assembly {
407             size := extcodesize(account)
408         }
409         return size > 0;
410     }
411 
412     /**
413      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
414      * `recipient`, forwarding all available gas and reverting on errors.
415      *
416      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
417      * of certain opcodes, possibly making contracts go over the 2300 gas limit
418      * imposed by `transfer`, making them unable to receive funds via
419      * `transfer`. {sendValue} removes this limitation.
420      *
421      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
422      *
423      * IMPORTANT: because control is transferred to `recipient`, care must be
424      * taken to not create reentrancy vulnerabilities. Consider using
425      * {ReentrancyGuard} or the
426      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
427      */
428     function sendValue(address payable recipient, uint256 amount) internal {
429         require(address(this).balance >= amount, "Address: insufficient balance");
430 
431         (bool success, ) = recipient.call{value: amount}("");
432         require(success, "Address: unable to send value, recipient may have reverted");
433     }
434 
435     /**
436      * @dev Performs a Solidity function call using a low level `call`. A
437      * plain `call` is an unsafe replacement for a function call: use this
438      * function instead.
439      *
440      * If `target` reverts with a revert reason, it is bubbled up by this
441      * function (like regular Solidity function calls).
442      *
443      * Returns the raw returned data. To convert to the expected return value,
444      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
445      *
446      * Requirements:
447      *
448      * - `target` must be a contract.
449      * - calling `target` with `data` must not revert.
450      *
451      * _Available since v3.1._
452      */
453     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
454         return functionCall(target, data, "Address: low-level call failed");
455     }
456 
457     /**
458      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
459      * `errorMessage` as a fallback revert reason when `target` reverts.
460      *
461      * _Available since v3.1._
462      */
463     function functionCall(
464         address target,
465         bytes memory data,
466         string memory errorMessage
467     ) internal returns (bytes memory) {
468         return functionCallWithValue(target, data, 0, errorMessage);
469     }
470 
471     /**
472      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
473      * but also transferring `value` wei to `target`.
474      *
475      * Requirements:
476      *
477      * - the calling contract must have an ETH balance of at least `value`.
478      * - the called Solidity function must be `payable`.
479      *
480      * _Available since v3.1._
481      */
482     function functionCallWithValue(
483         address target,
484         bytes memory data,
485         uint256 value
486     ) internal returns (bytes memory) {
487         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
488     }
489 
490     /**
491      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
492      * with `errorMessage` as a fallback revert reason when `target` reverts.
493      *
494      * _Available since v3.1._
495      */
496     function functionCallWithValue(
497         address target,
498         bytes memory data,
499         uint256 value,
500         string memory errorMessage
501     ) internal returns (bytes memory) {
502         require(address(this).balance >= value, "Address: insufficient balance for call");
503         require(isContract(target), "Address: call to non-contract");
504 
505         (bool success, bytes memory returndata) = target.call{value: value}(data);
506         return verifyCallResult(success, returndata, errorMessage);
507     }
508 
509     /**
510      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
511      * but performing a static call.
512      *
513      * _Available since v3.3._
514      */
515     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
516         return functionStaticCall(target, data, "Address: low-level static call failed");
517     }
518 
519     /**
520      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
521      * but performing a static call.
522      *
523      * _Available since v3.3._
524      */
525     function functionStaticCall(
526         address target,
527         bytes memory data,
528         string memory errorMessage
529     ) internal view returns (bytes memory) {
530         require(isContract(target), "Address: static call to non-contract");
531 
532         (bool success, bytes memory returndata) = target.staticcall(data);
533         return verifyCallResult(success, returndata, errorMessage);
534     }
535 
536     /**
537      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
538      * but performing a delegate call.
539      *
540      * _Available since v3.4._
541      */
542     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
543         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
544     }
545 
546     /**
547      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
548      * but performing a delegate call.
549      *
550      * _Available since v3.4._
551      */
552     function functionDelegateCall(
553         address target,
554         bytes memory data,
555         string memory errorMessage
556     ) internal returns (bytes memory) {
557         require(isContract(target), "Address: delegate call to non-contract");
558 
559         (bool success, bytes memory returndata) = target.delegatecall(data);
560         return verifyCallResult(success, returndata, errorMessage);
561     }
562 
563     /**
564      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
565      * revert reason using the provided one.
566      *
567      * _Available since v4.3._
568      */
569     function verifyCallResult(
570         bool success,
571         bytes memory returndata,
572         string memory errorMessage
573     ) internal pure returns (bytes memory) {
574         if (success) {
575             return returndata;
576         } else {
577             // Look for revert reason and bubble it up if present
578             if (returndata.length > 0) {
579                 // The easiest way to bubble the revert reason is using memory via assembly
580 
581                 assembly {
582                     let returndata_size := mload(returndata)
583                     revert(add(32, returndata), returndata_size)
584                 }
585             } else {
586                 revert(errorMessage);
587             }
588         }
589     }
590 }
591 
592 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
593 
594 /**
595  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
596  * @dev See https://eips.ethereum.org/EIPS/eip-721
597  */
598 interface IERC721Metadata is IERC721 {
599     /**
600      * @dev Returns the token collection name.
601      */
602     function name() external view returns (string memory);
603 
604     /**
605      * @dev Returns the token collection symbol.
606      */
607     function symbol() external view returns (string memory);
608 
609     /**
610      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
611      */
612     function tokenURI(uint256 tokenId) external view returns (string memory);
613 }
614 
615 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
616 
617 /**
618  * @title ERC721 token receiver interface
619  * @dev Interface for any contract that wants to support safeTransfers
620  * from ERC721 asset contracts.
621  */
622 interface IERC721Receiver {
623     /**
624      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
625      * by `operator` from `from`, this function is called.
626      *
627      * It must return its Solidity selector to confirm the token transfer.
628      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
629      *
630      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
631      */
632     function onERC721Received(
633         address operator,
634         address from,
635         uint256 tokenId,
636         bytes calldata data
637     ) external returns (bytes4);
638 }
639 
640 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
641 
642 /**
643  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
644  * the Metadata extension, but not including the Enumerable extension, which is available separately as
645  * {ERC721Enumerable}.
646  */
647 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
648     using Address for address;
649     using Strings for uint256;
650 
651     // Token name
652     string private _name;
653 
654     // Token symbol
655     string private _symbol;
656 
657     // Mapping from token ID to owner address
658     mapping(uint256 => address) private _owners;
659 
660     // Mapping owner address to token count
661     mapping(address => uint256) private _balances;
662 
663     // Mapping from token ID to approved address
664     mapping(uint256 => address) private _tokenApprovals;
665 
666     // Mapping from owner to operator approvals
667     mapping(address => mapping(address => bool)) private _operatorApprovals;
668 
669     /**
670      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
671      */
672     constructor(string memory name_, string memory symbol_) {
673         _name = name_;
674         _symbol = symbol_;
675     }
676 
677     /**
678      * @dev See {IERC165-supportsInterface}.
679      */
680     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
681         return
682             interfaceId == type(IERC721).interfaceId ||
683             interfaceId == type(IERC721Metadata).interfaceId ||
684             super.supportsInterface(interfaceId);
685     }
686 
687     /**
688      * @dev See {IERC721-balanceOf}.
689      */
690     function balanceOf(address owner) public view virtual override returns (uint256) {
691         require(owner != address(0), "ERC721: balance query for the zero address");
692         return _balances[owner];
693     }
694 
695     /**
696      * @dev See {IERC721-ownerOf}.
697      */
698     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
699         address owner = _owners[tokenId];
700         require(owner != address(0), "ERC721: owner query for nonexistent token");
701         return owner;
702     }
703 
704     /**
705      * @dev See {IERC721Metadata-name}.
706      */
707     function name() public view virtual override returns (string memory) {
708         return _name;
709     }
710 
711     /**
712      * @dev See {IERC721Metadata-symbol}.
713      */
714     function symbol() public view virtual override returns (string memory) {
715         return _symbol;
716     }
717 
718     /**
719      * @dev See {IERC721Metadata-tokenURI}.
720      */
721     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
722         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
723 
724         string memory baseURI = _baseURI();
725         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
726     }
727 
728     /**
729      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
730      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
731      * by default, can be overriden in child contracts.
732      */
733     function _baseURI() internal view virtual returns (string memory) {
734         return "";
735     }
736 
737     /**
738      * @dev See {IERC721-approve}.
739      */
740     function approve(address to, uint256 tokenId) public virtual override {
741         address owner = ERC721.ownerOf(tokenId);
742         require(to != owner, "ERC721: approval to current owner");
743 
744         require(
745             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
746             "ERC721: approve caller is not owner nor approved for all"
747         );
748 
749         _approve(to, tokenId);
750     }
751 
752     /**
753      * @dev See {IERC721-getApproved}.
754      */
755     function getApproved(uint256 tokenId) public view virtual override returns (address) {
756         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
757 
758         return _tokenApprovals[tokenId];
759     }
760 
761     /**
762      * @dev See {IERC721-setApprovalForAll}.
763      */
764     function setApprovalForAll(address operator, bool approved) public virtual override {
765         require(operator != _msgSender(), "ERC721: approve to caller");
766 
767         _operatorApprovals[_msgSender()][operator] = approved;
768         emit ApprovalForAll(_msgSender(), operator, approved);
769     }
770 
771     /**
772      * @dev See {IERC721-isApprovedForAll}.
773      */
774     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
775         return _operatorApprovals[owner][operator];
776     }
777 
778     /**
779      * @dev See {IERC721-transferFrom}.
780      */
781     function transferFrom(
782         address from,
783         address to,
784         uint256 tokenId
785     ) public virtual override {
786         //solhint-disable-next-line max-line-length
787         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
788 
789         _transfer(from, to, tokenId);
790     }
791 
792     /**
793      * @dev See {IERC721-safeTransferFrom}.
794      */
795     function safeTransferFrom(
796         address from,
797         address to,
798         uint256 tokenId
799     ) public virtual override {
800         safeTransferFrom(from, to, tokenId, "");
801     }
802 
803     /**
804      * @dev See {IERC721-safeTransferFrom}.
805      */
806     function safeTransferFrom(
807         address from,
808         address to,
809         uint256 tokenId,
810         bytes memory _data
811     ) public virtual override {
812         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
813         _safeTransfer(from, to, tokenId, _data);
814     }
815 
816     /**
817      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
818      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
819      *
820      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
821      *
822      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
823      * implement alternative mechanisms to perform token transfer, such as signature-based.
824      *
825      * Requirements:
826      *
827      * - `from` cannot be the zero address.
828      * - `to` cannot be the zero address.
829      * - `tokenId` token must exist and be owned by `from`.
830      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
831      *
832      * Emits a {Transfer} event.
833      */
834     function _safeTransfer(
835         address from,
836         address to,
837         uint256 tokenId,
838         bytes memory _data
839     ) internal virtual {
840         _transfer(from, to, tokenId);
841         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
842     }
843 
844     /**
845      * @dev Returns whether `tokenId` exists.
846      *
847      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
848      *
849      * Tokens start existing when they are minted (`_mint`),
850      * and stop existing when they are burned (`_burn`).
851      */
852     function _exists(uint256 tokenId) internal view virtual returns (bool) {
853         return _owners[tokenId] != address(0);
854     }
855 
856     /**
857      * @dev Returns whether `spender` is allowed to manage `tokenId`.
858      *
859      * Requirements:
860      *
861      * - `tokenId` must exist.
862      */
863     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
864         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
865         address owner = ERC721.ownerOf(tokenId);
866         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
867     }
868 
869     /**
870      * @dev Safely mints `tokenId` and transfers it to `to`.
871      *
872      * Requirements:
873      *
874      * - `tokenId` must not exist.
875      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
876      *
877      * Emits a {Transfer} event.
878      */
879     function _safeMint(address to, uint256 tokenId) internal virtual {
880         _safeMint(to, tokenId, "");
881     }
882 
883     /**
884      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
885      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
886      */
887     function _safeMint(
888         address to,
889         uint256 tokenId,
890         bytes memory _data
891     ) internal virtual {
892         _mint(to, tokenId);
893         require(
894             _checkOnERC721Received(address(0), to, tokenId, _data),
895             "ERC721: transfer to non ERC721Receiver implementer"
896         );
897     }
898 
899     /**
900      * @dev Mints `tokenId` and transfers it to `to`.
901      *
902      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
903      *
904      * Requirements:
905      *
906      * - `tokenId` must not exist.
907      * - `to` cannot be the zero address.
908      *
909      * Emits a {Transfer} event.
910      */
911     function _mint(address to, uint256 tokenId) internal virtual {
912         require(to != address(0), "ERC721: mint to the zero address");
913         require(!_exists(tokenId), "ERC721: token already minted");
914 
915         _beforeTokenTransfer(address(0), to, tokenId);
916 
917         _balances[to] += 1;
918         _owners[tokenId] = to;
919 
920         emit Transfer(address(0), to, tokenId);
921     }
922 
923     /**
924      * @dev Destroys `tokenId`.
925      * The approval is cleared when the token is burned.
926      *
927      * Requirements:
928      *
929      * - `tokenId` must exist.
930      *
931      * Emits a {Transfer} event.
932      */
933     function _burn(uint256 tokenId) internal virtual {
934         address owner = ERC721.ownerOf(tokenId);
935 
936         _beforeTokenTransfer(owner, address(0), tokenId);
937 
938         // Clear approvals
939         _approve(address(0), tokenId);
940 
941         _balances[owner] -= 1;
942         delete _owners[tokenId];
943 
944         emit Transfer(owner, address(0), tokenId);
945     }
946 
947     /**
948      * @dev Transfers `tokenId` from `from` to `to`.
949      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
950      *
951      * Requirements:
952      *
953      * - `to` cannot be the zero address.
954      * - `tokenId` token must be owned by `from`.
955      *
956      * Emits a {Transfer} event.
957      */
958     function _transfer(
959         address from,
960         address to,
961         uint256 tokenId
962     ) internal virtual {
963         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
964         require(to != address(0), "ERC721: transfer to the zero address");
965 
966         _beforeTokenTransfer(from, to, tokenId);
967 
968         // Clear approvals from the previous owner
969         _approve(address(0), tokenId);
970 
971         _balances[from] -= 1;
972         _balances[to] += 1;
973         _owners[tokenId] = to;
974 
975         emit Transfer(from, to, tokenId);
976     }
977 
978     /**
979      * @dev Approve `to` to operate on `tokenId`
980      *
981      * Emits a {Approval} event.
982      */
983     function _approve(address to, uint256 tokenId) internal virtual {
984         _tokenApprovals[tokenId] = to;
985         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
986     }
987 
988     /**
989      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
990      * The call is not executed if the target address is not a contract.
991      *
992      * @param from address representing the previous owner of the given token ID
993      * @param to target address that will receive the tokens
994      * @param tokenId uint256 ID of the token to be transferred
995      * @param _data bytes optional data to send along with the call
996      * @return bool whether the call correctly returned the expected magic value
997      */
998     function _checkOnERC721Received(
999         address from,
1000         address to,
1001         uint256 tokenId,
1002         bytes memory _data
1003     ) private returns (bool) {
1004         if (to.isContract()) {
1005             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1006                 return retval == IERC721Receiver.onERC721Received.selector;
1007             } catch (bytes memory reason) {
1008                 if (reason.length == 0) {
1009                     revert("ERC721: transfer to non ERC721Receiver implementer");
1010                 } else {
1011                     assembly {
1012                         revert(add(32, reason), mload(reason))
1013                     }
1014                 }
1015             }
1016         } else {
1017             return true;
1018         }
1019     }
1020 
1021     /**
1022      * @dev Hook that is called before any token transfer. This includes minting
1023      * and burning.
1024      *
1025      * Calling conditions:
1026      *
1027      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1028      * transferred to `to`.
1029      * - When `from` is zero, `tokenId` will be minted for `to`.
1030      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1031      * - `from` and `to` are never both zero.
1032      *
1033      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1034      */
1035     function _beforeTokenTransfer(
1036         address from,
1037         address to,
1038         uint256 tokenId
1039     ) internal virtual {}
1040 }
1041 
1042 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1043 
1044 /**
1045  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1046  * enumerability of all the token ids in the contract as well as all token ids owned by each
1047  * account.
1048  */
1049 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1050     // Mapping from owner to list of owned token IDs
1051     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1052 
1053     // Mapping from token ID to index of the owner tokens list
1054     mapping(uint256 => uint256) private _ownedTokensIndex;
1055 
1056     // Array with all token ids, used for enumeration
1057     uint256[] private _allTokens;
1058 
1059     // Mapping from token id to position in the allTokens array
1060     mapping(uint256 => uint256) private _allTokensIndex;
1061 
1062     /**
1063      * @dev See {IERC165-supportsInterface}.
1064      */
1065     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1066         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1067     }
1068 
1069     /**
1070      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1071      */
1072     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1073         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1074         return _ownedTokens[owner][index];
1075     }
1076 
1077     /**
1078      * @dev See {IERC721Enumerable-totalSupply}.
1079      */
1080     function totalSupply() public view virtual override returns (uint256) {
1081         return _allTokens.length;
1082     }
1083 
1084     /**
1085      * @dev See {IERC721Enumerable-tokenByIndex}.
1086      */
1087     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1088         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1089         return _allTokens[index];
1090     }
1091 
1092     /**
1093      * @dev Hook that is called before any token transfer. This includes minting
1094      * and burning.
1095      *
1096      * Calling conditions:
1097      *
1098      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1099      * transferred to `to`.
1100      * - When `from` is zero, `tokenId` will be minted for `to`.
1101      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1102      * - `from` cannot be the zero address.
1103      * - `to` cannot be the zero address.
1104      *
1105      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1106      */
1107     function _beforeTokenTransfer(
1108         address from,
1109         address to,
1110         uint256 tokenId
1111     ) internal virtual override {
1112         super._beforeTokenTransfer(from, to, tokenId);
1113 
1114         if (from == address(0)) {
1115             _addTokenToAllTokensEnumeration(tokenId);
1116         } else if (from != to) {
1117             _removeTokenFromOwnerEnumeration(from, tokenId);
1118         }
1119         if (to == address(0)) {
1120             _removeTokenFromAllTokensEnumeration(tokenId);
1121         } else if (to != from) {
1122             _addTokenToOwnerEnumeration(to, tokenId);
1123         }
1124     }
1125 
1126     /**
1127      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1128      * @param to address representing the new owner of the given token ID
1129      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1130      */
1131     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1132         uint256 length = ERC721.balanceOf(to);
1133         _ownedTokens[to][length] = tokenId;
1134         _ownedTokensIndex[tokenId] = length;
1135     }
1136 
1137     /**
1138      * @dev Private function to add a token to this extension's token tracking data structures.
1139      * @param tokenId uint256 ID of the token to be added to the tokens list
1140      */
1141     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1142         _allTokensIndex[tokenId] = _allTokens.length;
1143         _allTokens.push(tokenId);
1144     }
1145 
1146     /**
1147      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1148      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1149      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1150      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1151      * @param from address representing the previous owner of the given token ID
1152      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1153      */
1154     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1155         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1156         // then delete the last slot (swap and pop).
1157 
1158         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1159         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1160 
1161         // When the token to delete is the last token, the swap operation is unnecessary
1162         if (tokenIndex != lastTokenIndex) {
1163             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1164 
1165             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1166             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1167         }
1168 
1169         // This also deletes the contents at the last position of the array
1170         delete _ownedTokensIndex[tokenId];
1171         delete _ownedTokens[from][lastTokenIndex];
1172     }
1173 
1174     /**
1175      * @dev Private function to remove a token from this extension's token tracking data structures.
1176      * This has O(1) time complexity, but alters the order of the _allTokens array.
1177      * @param tokenId uint256 ID of the token to be removed from the tokens list
1178      */
1179     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1180         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1181         // then delete the last slot (swap and pop).
1182 
1183         uint256 lastTokenIndex = _allTokens.length - 1;
1184         uint256 tokenIndex = _allTokensIndex[tokenId];
1185 
1186         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1187         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1188         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1189         uint256 lastTokenId = _allTokens[lastTokenIndex];
1190 
1191         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1192         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1193 
1194         // This also deletes the contents at the last position of the array
1195         delete _allTokensIndex[tokenId];
1196         _allTokens.pop();
1197     }
1198 }
1199 
1200 
1201 contract NFTGRABBER is ERC721Enumerable, Ownable{
1202     uint public constant MAX_NFTS = 10000;
1203     bool public isSaleOpen = false;
1204 	uint private NFT_PRICE = 0.001 ether;
1205 	string _baseTokenURI = "";
1206 	
1207 	address private master;
1208 
1209     constructor() ERC721("NFTGRABBER TEST", "NFTGRABBER")  {
1210         master = msg.sender;
1211     }
1212 
1213     function mint(uint256 numberOfTokens) public payable {
1214         uint256 ts = totalSupply();
1215         require(isSaleOpen, "Sale not open yet");
1216         require(msg.value >=NFT_PRICE, "Value below price");
1217         require(totalSupply() < MAX_NFTS, "All minted");
1218         
1219         for (uint256 i = 0; i < numberOfTokens; i++) {
1220             _safeMint(msg.sender, ts + i);
1221         }
1222     }
1223     
1224     function _baseURI() internal view virtual override returns (string memory) {
1225         return _baseTokenURI;
1226     }
1227     
1228     function setBaseURI(string memory baseURI) public onlyOwner {
1229         _baseTokenURI = baseURI;
1230     }
1231 
1232     function walletOfOwner(address _owner) external view returns(uint256[] memory) {
1233         uint tokenCount = balanceOf(_owner);
1234         uint256[] memory tokensId = new uint256[](tokenCount);
1235         for(uint i = 0; i < tokenCount; i++){
1236             tokensId[i] = tokenOfOwnerByIndex(_owner, i);
1237         }
1238         return tokensId;
1239     }
1240     
1241     function setSaleState(bool _status) public onlyOwner {
1242         isSaleOpen = _status;
1243     }
1244     
1245     function withdrawAll() public onlyOwner {
1246         require(payable(master).send(address(this).balance));
1247     }
1248     
1249 }