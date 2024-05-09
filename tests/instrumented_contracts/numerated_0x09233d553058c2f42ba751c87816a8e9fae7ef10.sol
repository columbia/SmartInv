1 // SPDX-License-Identifier: Unlimited
2 pragma solidity ^0.8.0;
3 
4 /**
5  * @dev Interface of the ERC165 standard, as defined in the
6  * https://eips.ethereum.org/EIPS/eip-165[EIP].
7  *
8  * Implementers can declare support of contract interfaces, which can then be
9  * queried by others ({ERC165Checker}).
10  *
11  * For an implementation, see {ERC165}.
12  */
13 interface IERC165 {
14     /**
15      * @dev Returns true if this contract implements the interface defined by
16      * `interfaceId`. See the corresponding
17      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
18      * to learn more about how these ids are created.
19      *
20      * This function call must use less than 30 000 gas.
21      */
22     function supportsInterface(bytes4 interfaceId) external view returns (bool);
23 }
24 
25 /**
26  * @dev Implementation of the {IERC165} interface.
27  *
28  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
29  * for the additional interface id that will be supported. For example:
30  *
31  * ```solidity
32  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
33  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
34  * }
35  * ```
36  *
37  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
38  */
39 abstract contract ERC165 is IERC165 {
40     /**
41      * @dev See {IERC165-supportsInterface}.
42      */
43     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
44         return interfaceId == type(IERC165).interfaceId;
45     }
46 }
47 
48 /**
49  * @dev Required interface of an ERC721 compliant contract.
50  */
51 interface IERC721 is IERC165 {
52     /**
53      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
54      */
55     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
56 
57     /**
58      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
59      */
60     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
61 
62     /**
63      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
64      */
65     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
66 
67     /**
68      * @dev Returns the number of tokens in ``owner``'s account.
69      */
70     function balanceOf(address owner) external view returns (uint256 balance);
71 
72     /**
73      * @dev Returns the owner of the `tokenId` token.
74      *
75      * Requirements:
76      *
77      * - `tokenId` must exist.
78      */
79     function ownerOf(uint256 tokenId) external view returns (address owner);
80 
81     /**
82      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
83      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
84      *
85      * Requirements:
86      *
87      * - `from` cannot be the zero address.
88      * - `to` cannot be the zero address.
89      * - `tokenId` token must exist and be owned by `from`.
90      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
91      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
92      *
93      * Emits a {Transfer} event.
94      */
95     function safeTransferFrom(
96         address from,
97         address to,
98         uint256 tokenId
99     ) external;
100 
101     /**
102      * @dev Transfers `tokenId` token from `from` to `to`.
103      *
104      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
105      *
106      * Requirements:
107      *
108      * - `from` cannot be the zero address.
109      * - `to` cannot be the zero address.
110      * - `tokenId` token must be owned by `from`.
111      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
112      *
113      * Emits a {Transfer} event.
114      */
115     function transferFrom(
116         address from,
117         address to,
118         uint256 tokenId
119     ) external;
120 
121     /**
122      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
123      * The approval is cleared when the token is transferred.
124      *
125      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
126      *
127      * Requirements:
128      *
129      * - The caller must own the token or be an approved operator.
130      * - `tokenId` must exist.
131      *
132      * Emits an {Approval} event.
133      */
134     function approve(address to, uint256 tokenId) external;
135 
136     /**
137      * @dev Returns the account approved for `tokenId` token.
138      *
139      * Requirements:
140      *
141      * - `tokenId` must exist.
142      */
143     function getApproved(uint256 tokenId) external view returns (address operator);
144 
145     /**
146      * @dev Approve or remove `operator` as an operator for the caller.
147      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
148      *
149      * Requirements:
150      *
151      * - The `operator` cannot be the caller.
152      *
153      * Emits an {ApprovalForAll} event.
154      */
155     function setApprovalForAll(address operator, bool _approved) external;
156 
157     /**
158      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
159      *
160      * See {setApprovalForAll}
161      */
162     function isApprovedForAll(address owner, address operator) external view returns (bool);
163 
164     /**
165      * @dev Safely transfers `tokenId` token from `from` to `to`.
166      *
167      * Requirements:
168      *
169      * - `from` cannot be the zero address.
170      * - `to` cannot be the zero address.
171      * - `tokenId` token must exist and be owned by `from`.
172      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
173      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
174      *
175      * Emits a {Transfer} event.
176      */
177     function safeTransferFrom(
178         address from,
179         address to,
180         uint256 tokenId,
181         bytes calldata data
182     ) external;
183 }
184 
185 /**
186  * @title ERC721 token receiver interface
187  * @dev Interface for any contract that wants to support safeTransfers
188  * from ERC721 asset contracts.
189  */
190 interface IERC721Receiver {
191     /**
192      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
193      * by `operator` from `from`, this function is called.
194      *
195      * It must return its Solidity selector to confirm the token transfer.
196      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
197      *
198      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
199      */
200     function onERC721Received(
201         address operator,
202         address from,
203         uint256 tokenId,
204         bytes calldata data
205     ) external returns (bytes4);
206 }
207 
208 /**
209  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
210  * @dev See https://eips.ethereum.org/EIPS/eip-721
211  */
212 interface IERC721Metadata is IERC721 {
213     /**
214      * @dev Returns the token collection name.
215      */
216     function name() external view returns (string memory);
217 
218     /**
219      * @dev Returns the token collection symbol.
220      */
221     function symbol() external view returns (string memory);
222 
223     /**
224      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
225      */
226     function tokenURI(uint256 tokenId) external view returns (string memory);
227 }
228 
229 /**
230  * @dev Collection of functions related to the address type
231  */
232 library Address {
233     /**
234      * @dev Returns true if `account` is a contract.
235      *
236      * [IMPORTANT]
237      * ====
238      * It is unsafe to assume that an address for which this function returns
239      * false is an externally-owned account (EOA) and not a contract.
240      *
241      * Among others, `isContract` will return false for the following
242      * types of addresses:
243      *
244      *  - an externally-owned account
245      *  - a contract in construction
246      *  - an address where a contract will be created
247      *  - an address where a contract lived, but was destroyed
248      * ====
249      */
250     function isContract(address account) internal view returns (bool) {
251         // This method relies on extcodesize, which returns 0 for contracts in
252         // construction, since the code is only stored at the end of the
253         // constructor execution.
254 
255         uint256 size;
256         assembly {
257             size := extcodesize(account)
258         }
259         return size > 0;
260     }
261 
262     /**
263      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
264      * `recipient`, forwarding all available gas and reverting on errors.
265      *
266      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
267      * of certain opcodes, possibly making contracts go over the 2300 gas limit
268      * imposed by `transfer`, making them unable to receive funds via
269      * `transfer`. {sendValue} removes this limitation.
270      *
271      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
272      *
273      * IMPORTANT: because control is transferred to `recipient`, care must be
274      * taken to not create reentrancy vulnerabilities. Consider using
275      * {ReentrancyGuard} or the
276      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
277      */
278     function sendValue(address payable recipient, uint256 amount) internal {
279         require(address(this).balance >= amount, "Address: insufficient balance");
280 
281         (bool success, ) = recipient.call{value: amount}("");
282         require(success, "Address: unable to send value, recipient may have reverted");
283     }
284 
285     /**
286      * @dev Performs a Solidity function call using a low level `call`. A
287      * plain `call` is an unsafe replacement for a function call: use this
288      * function instead.
289      *
290      * If `target` reverts with a revert reason, it is bubbled up by this
291      * function (like regular Solidity function calls).
292      *
293      * Returns the raw returned data. To convert to the expected return value,
294      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
295      *
296      * Requirements:
297      *
298      * - `target` must be a contract.
299      * - calling `target` with `data` must not revert.
300      *
301      * _Available since v3.1._
302      */
303     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
304         return functionCall(target, data, "Address: low-level call failed");
305     }
306 
307     /**
308      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
309      * `errorMessage` as a fallback revert reason when `target` reverts.
310      *
311      * _Available since v3.1._
312      */
313     function functionCall(
314         address target,
315         bytes memory data,
316         string memory errorMessage
317     ) internal returns (bytes memory) {
318         return functionCallWithValue(target, data, 0, errorMessage);
319     }
320 
321     /**
322      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
323      * but also transferring `value` wei to `target`.
324      *
325      * Requirements:
326      *
327      * - the calling contract must have an ETH balance of at least `value`.
328      * - the called Solidity function must be `payable`.
329      *
330      * _Available since v3.1._
331      */
332     function functionCallWithValue(
333         address target,
334         bytes memory data,
335         uint256 value
336     ) internal returns (bytes memory) {
337         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
338     }
339 
340     /**
341      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
342      * with `errorMessage` as a fallback revert reason when `target` reverts.
343      *
344      * _Available since v3.1._
345      */
346     function functionCallWithValue(
347         address target,
348         bytes memory data,
349         uint256 value,
350         string memory errorMessage
351     ) internal returns (bytes memory) {
352         require(address(this).balance >= value, "Address: insufficient balance for call");
353         require(isContract(target), "Address: call to non-contract");
354 
355         (bool success, bytes memory returndata) = target.call{value: value}(data);
356         return _verifyCallResult(success, returndata, errorMessage);
357     }
358 
359     /**
360      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
361      * but performing a static call.
362      *
363      * _Available since v3.3._
364      */
365     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
366         return functionStaticCall(target, data, "Address: low-level static call failed");
367     }
368 
369     /**
370      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
371      * but performing a static call.
372      *
373      * _Available since v3.3._
374      */
375     function functionStaticCall(
376         address target,
377         bytes memory data,
378         string memory errorMessage
379     ) internal view returns (bytes memory) {
380         require(isContract(target), "Address: static call to non-contract");
381 
382         (bool success, bytes memory returndata) = target.staticcall(data);
383         return _verifyCallResult(success, returndata, errorMessage);
384     }
385 
386     /**
387      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
388      * but performing a delegate call.
389      *
390      * _Available since v3.4._
391      */
392     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
393         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
394     }
395 
396     /**
397      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
398      * but performing a delegate call.
399      *
400      * _Available since v3.4._
401      */
402     function functionDelegateCall(
403         address target,
404         bytes memory data,
405         string memory errorMessage
406     ) internal returns (bytes memory) {
407         require(isContract(target), "Address: delegate call to non-contract");
408 
409         (bool success, bytes memory returndata) = target.delegatecall(data);
410         return _verifyCallResult(success, returndata, errorMessage);
411     }
412 
413     function _verifyCallResult(
414         bool success,
415         bytes memory returndata,
416         string memory errorMessage
417     ) private pure returns (bytes memory) {
418         if (success) {
419             return returndata;
420         } else {
421             // Look for revert reason and bubble it up if present
422             if (returndata.length > 0) {
423                 // The easiest way to bubble the revert reason is using memory via assembly
424 
425                 assembly {
426                     let returndata_size := mload(returndata)
427                     revert(add(32, returndata), returndata_size)
428                 }
429             } else {
430                 revert(errorMessage);
431             }
432         }
433     }
434 }
435 
436 /*
437  * @dev Provides information about the current execution context, including the
438  * sender of the transaction and its data. While these are generally available
439  * via msg.sender and msg.data, they should not be accessed in such a direct
440  * manner, since when dealing with meta-transactions the account sending and
441  * paying for execution may not be the actual sender (as far as an application
442  * is concerned).
443  *
444  * This contract is only required for intermediate, library-like contracts.
445  */
446 abstract contract Context {
447     function _msgSender() internal view virtual returns (address) {
448         return msg.sender;
449     }
450 
451     function _msgData() internal view virtual returns (bytes calldata) {
452         return msg.data;
453     }
454 }
455 
456 /**
457  * @dev String operations.
458  */
459 library Strings {
460     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
461 
462     /**
463      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
464      */
465     function toString(uint256 value) internal pure returns (string memory) {
466         // Inspired by OraclizeAPI's implementation - MIT licence
467         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
468 
469         if (value == 0) {
470             return "0";
471         }
472         uint256 temp = value;
473         uint256 digits;
474         while (temp != 0) {
475             digits++;
476             temp /= 10;
477         }
478         bytes memory buffer = new bytes(digits);
479         while (value != 0) {
480             digits -= 1;
481             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
482             value /= 10;
483         }
484         return string(buffer);
485     }
486 
487     /**
488      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
489      */
490     function toHexString(uint256 value) internal pure returns (string memory) {
491         if (value == 0) {
492             return "0x00";
493         }
494         uint256 temp = value;
495         uint256 length = 0;
496         while (temp != 0) {
497             length++;
498             temp >>= 8;
499         }
500         return toHexString(value, length);
501     }
502 
503     /**
504      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
505      */
506     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
507         bytes memory buffer = new bytes(2 * length + 2);
508         buffer[0] = "0";
509         buffer[1] = "x";
510         for (uint256 i = 2 * length + 1; i > 1; --i) {
511             buffer[i] = _HEX_SYMBOLS[value & 0xf];
512             value >>= 4;
513         }
514         require(value == 0, "Strings: hex length insufficient");
515         return string(buffer);
516     }
517 }
518 
519 /**
520  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
521  * @dev See https://eips.ethereum.org/EIPS/eip-721
522  */
523 interface IERC721Enumerable is IERC721 {
524     /**
525      * @dev Returns the total amount of tokens stored by the contract.
526      */
527     function totalSupply() external view returns (uint256);
528 
529     /**
530      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
531      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
532      */
533     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
534 
535     /**
536      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
537      * Use along with {totalSupply} to enumerate all tokens.
538      */
539     function tokenByIndex(uint256 index) external view returns (uint256);
540 }
541 
542 /**
543  * @dev Contract module which provides a basic access control mechanism, where
544  * there is an account (an owner) that can be granted exclusive access to
545  * specific functions.
546  *
547  * By default, the owner account will be the one that deploys the contract. This
548  * can later be changed with {transferOwnership}.
549  *
550  * This module is used through inheritance. It will make available the modifier
551  * `onlyOwner`, which can be applied to your functions to restrict their use to
552  * the owner.
553  */
554 abstract contract Ownable is Context {
555     address private _owner;
556 
557     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
558 
559     /**
560      * @dev Initializes the contract setting the deployer as the initial owner.
561      */
562     constructor() {
563         _setOwner(_msgSender());
564     }
565 
566     /**
567      * @dev Returns the address of the current owner.
568      */
569     function owner() public view virtual returns (address) {
570         return _owner;
571     }
572 
573     /**
574      * @dev Throws if called by any account other than the owner.
575      */
576     modifier onlyOwner() {
577         require(owner() == _msgSender(), "Ownable: caller is not the owner");
578         _;
579     }
580 
581     /**
582      * @dev Leaves the contract without owner. It will not be possible to call
583      * `onlyOwner` functions anymore. Can only be called by the current owner.
584      *
585      * NOTE: Renouncing ownership will leave the contract without an owner,
586      * thereby removing any functionality that is only available to the owner.
587      */
588     function renounceOwnership() public virtual onlyOwner {
589         _setOwner(address(0));
590     }
591 
592     /**
593      * @dev Transfers ownership of the contract to a new account (`newOwner`).
594      * Can only be called by the current owner.
595      */
596     function transferOwnership(address newOwner) public virtual onlyOwner {
597         require(newOwner != address(0), "Ownable: new owner is the zero address");
598         _setOwner(newOwner);
599     }
600 
601     function _setOwner(address newOwner) private {
602         address oldOwner = _owner;
603         _owner = newOwner;
604         emit OwnershipTransferred(oldOwner, newOwner);
605     }
606 }
607 
608 /**
609  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
610  * the Metadata extension, but not including the Enumerable extension, which is available separately as
611  * {ERC721Enumerable}.
612  */
613 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
614     using Address for address;
615     using Strings for uint256;
616 
617     // Token name
618     string private _name;
619 
620     // Token symbol
621     string private _symbol;
622 
623     // Mapping from token ID to owner address
624     mapping(uint256 => address) private _owners;
625 
626     // Mapping owner address to token count
627     mapping(address => uint256) private _balances;
628 
629     // Mapping from token ID to approved address
630     mapping(uint256 => address) private _tokenApprovals;
631 
632     // Mapping from owner to operator approvals
633     mapping(address => mapping(address => bool)) private _operatorApprovals;
634 
635     /**
636      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
637      */
638     constructor(string memory name_, string memory symbol_) {
639         _name = name_;
640         _symbol = symbol_;
641     }
642 
643     /**
644      * @dev See {IERC165-supportsInterface}.
645      */
646     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
647         return
648             interfaceId == type(IERC721).interfaceId ||
649             interfaceId == type(IERC721Metadata).interfaceId ||
650             super.supportsInterface(interfaceId);
651     }
652 
653     /**
654      * @dev See {IERC721-balanceOf}.
655      */
656     function balanceOf(address owner) public view virtual override returns (uint256) {
657         require(owner != address(0), "ERC721: balance query for the zero address");
658         return _balances[owner];
659     }
660 
661     /**
662      * @dev See {IERC721-ownerOf}.
663      */
664     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
665         address owner = _owners[tokenId];
666         require(owner != address(0), "ERC721: owner query for nonexistent token");
667         return owner;
668     }
669 
670     /**
671      * @dev See {IERC721Metadata-name}.
672      */
673     function name() public view virtual override returns (string memory) {
674         return _name;
675     }
676 
677     /**
678      * @dev See {IERC721Metadata-symbol}.
679      */
680     function symbol() public view virtual override returns (string memory) {
681         return _symbol;
682     }
683 
684     /**
685      * @dev See {IERC721Metadata-tokenURI}.
686      */
687     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
688         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
689 
690         string memory baseURI = _baseURI();
691         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
692     }
693 
694     /**
695      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
696      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
697      * by default, can be overriden in child contracts.
698      */
699     function _baseURI() internal view virtual returns (string memory) {
700         return "";
701     }
702 
703     /**
704      * @dev See {IERC721-approve}.
705      */
706     function approve(address to, uint256 tokenId) public virtual override {
707         address owner = ERC721.ownerOf(tokenId);
708         require(to != owner, "ERC721: approval to current owner");
709 
710         require(
711             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
712             "ERC721: approve caller is not owner nor approved for all"
713         );
714 
715         _approve(to, tokenId);
716     }
717 
718     /**
719      * @dev See {IERC721-getApproved}.
720      */
721     function getApproved(uint256 tokenId) public view virtual override returns (address) {
722         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
723 
724         return _tokenApprovals[tokenId];
725     }
726 
727     /**
728      * @dev See {IERC721-setApprovalForAll}.
729      */
730     function setApprovalForAll(address operator, bool approved) public virtual override {
731         require(operator != _msgSender(), "ERC721: approve to caller");
732 
733         _operatorApprovals[_msgSender()][operator] = approved;
734         emit ApprovalForAll(_msgSender(), operator, approved);
735     }
736 
737     /**
738      * @dev See {IERC721-isApprovedForAll}.
739      */
740     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
741         return _operatorApprovals[owner][operator];
742     }
743 
744     /**
745      * @dev See {IERC721-transferFrom}.
746      */
747     function transferFrom(
748         address from,
749         address to,
750         uint256 tokenId
751     ) public virtual override {
752         //solhint-disable-next-line max-line-length
753         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
754 
755         _transfer(from, to, tokenId);
756     }
757 
758     /**
759      * @dev See {IERC721-safeTransferFrom}.
760      */
761     function safeTransferFrom(
762         address from,
763         address to,
764         uint256 tokenId
765     ) public virtual override {
766         safeTransferFrom(from, to, tokenId, "");
767     }
768 
769     /**
770      * @dev See {IERC721-safeTransferFrom}.
771      */
772     function safeTransferFrom(
773         address from,
774         address to,
775         uint256 tokenId,
776         bytes memory _data
777     ) public virtual override {
778         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
779         _safeTransfer(from, to, tokenId, _data);
780     }
781 
782     /**
783      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
784      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
785      *
786      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
787      *
788      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
789      * implement alternative mechanisms to perform token transfer, such as signature-based.
790      *
791      * Requirements:
792      *
793      * - `from` cannot be the zero address.
794      * - `to` cannot be the zero address.
795      * - `tokenId` token must exist and be owned by `from`.
796      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
797      *
798      * Emits a {Transfer} event.
799      */
800     function _safeTransfer(
801         address from,
802         address to,
803         uint256 tokenId,
804         bytes memory _data
805     ) internal virtual {
806         _transfer(from, to, tokenId);
807         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
808     }
809 
810     /**
811      * @dev Returns whether `tokenId` exists.
812      *
813      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
814      *
815      * Tokens start existing when they are minted (`_mint`),
816      * and stop existing when they are burned (`_burn`).
817      */
818     function _exists(uint256 tokenId) internal view virtual returns (bool) {
819         return _owners[tokenId] != address(0);
820     }
821 
822     /**
823      * @dev Returns whether `spender` is allowed to manage `tokenId`.
824      *
825      * Requirements:
826      *
827      * - `tokenId` must exist.
828      */
829     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
830         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
831         address owner = ERC721.ownerOf(tokenId);
832         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
833     }
834 
835     /**
836      * @dev Safely mints `tokenId` and transfers it to `to`.
837      *
838      * Requirements:
839      *
840      * - `tokenId` must not exist.
841      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
842      *
843      * Emits a {Transfer} event.
844      */
845     function _safeMint(address to, uint256 tokenId) internal virtual {
846         _safeMint(to, tokenId, "");
847     }
848 
849     /**
850      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
851      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
852      */
853     function _safeMint(
854         address to,
855         uint256 tokenId,
856         bytes memory _data
857     ) internal virtual {
858         _mint(to, tokenId);
859         require(
860             _checkOnERC721Received(address(0), to, tokenId, _data),
861             "ERC721: transfer to non ERC721Receiver implementer"
862         );
863     }
864 
865     /**
866      * @dev Mints `tokenId` and transfers it to `to`.
867      *
868      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
869      *
870      * Requirements:
871      *
872      * - `tokenId` must not exist.
873      * - `to` cannot be the zero address.
874      *
875      * Emits a {Transfer} event.
876      */
877     function _mint(address to, uint256 tokenId) internal virtual {
878         require(to != address(0), "ERC721: mint to the zero address");
879         require(!_exists(tokenId), "ERC721: token already minted");
880 
881         _beforeTokenTransfer(address(0), to, tokenId);
882 
883         _balances[to] += 1;
884         _owners[tokenId] = to;
885 
886         emit Transfer(address(0), to, tokenId);
887     }
888 
889     /**
890      * @dev Destroys `tokenId`.
891      * The approval is cleared when the token is burned.
892      *
893      * Requirements:
894      *
895      * - `tokenId` must exist.
896      *
897      * Emits a {Transfer} event.
898      */
899     function _burn(uint256 tokenId) internal virtual {
900         address owner = ERC721.ownerOf(tokenId);
901 
902         _beforeTokenTransfer(owner, address(0), tokenId);
903 
904         // Clear approvals
905         _approve(address(0), tokenId);
906 
907         _balances[owner] -= 1;
908         delete _owners[tokenId];
909 
910         emit Transfer(owner, address(0), tokenId);
911     }
912 
913     /**
914      * @dev Transfers `tokenId` from `from` to `to`.
915      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
916      *
917      * Requirements:
918      *
919      * - `to` cannot be the zero address.
920      * - `tokenId` token must be owned by `from`.
921      *
922      * Emits a {Transfer} event.
923      */
924     function _transfer(
925         address from,
926         address to,
927         uint256 tokenId
928     ) internal virtual {
929         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
930         require(to != address(0), "ERC721: transfer to the zero address");
931 
932         _beforeTokenTransfer(from, to, tokenId);
933 
934         // Clear approvals from the previous owner
935         _approve(address(0), tokenId);
936 
937         _balances[from] -= 1;
938         _balances[to] += 1;
939         _owners[tokenId] = to;
940 
941         emit Transfer(from, to, tokenId);
942     }
943 
944     /**
945      * @dev Approve `to` to operate on `tokenId`
946      *
947      * Emits a {Approval} event.
948      */
949     function _approve(address to, uint256 tokenId) internal virtual {
950         _tokenApprovals[tokenId] = to;
951         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
952     }
953 
954     /**
955      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
956      * The call is not executed if the target address is not a contract.
957      *
958      * @param from address representing the previous owner of the given token ID
959      * @param to target address that will receive the tokens
960      * @param tokenId uint256 ID of the token to be transferred
961      * @param _data bytes optional data to send along with the call
962      * @return bool whether the call correctly returned the expected magic value
963      */
964     function _checkOnERC721Received(
965         address from,
966         address to,
967         uint256 tokenId,
968         bytes memory _data
969     ) private returns (bool) {
970         if (to.isContract()) {
971             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
972                 return retval == IERC721Receiver(to).onERC721Received.selector;
973             } catch (bytes memory reason) {
974                 if (reason.length == 0) {
975                     revert("ERC721: transfer to non ERC721Receiver implementer");
976                 } else {
977                     assembly {
978                         revert(add(32, reason), mload(reason))
979                     }
980                 }
981             }
982         } else {
983             return true;
984         }
985     }
986 
987     /**
988      * @dev Hook that is called before any token transfer. This includes minting
989      * and burning.
990      *
991      * Calling conditions:
992      *
993      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
994      * transferred to `to`.
995      * - When `from` is zero, `tokenId` will be minted for `to`.
996      * - When `to` is zero, ``from``'s `tokenId` will be burned.
997      * - `from` and `to` are never both zero.
998      *
999      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1000      */
1001     function _beforeTokenTransfer(
1002         address from,
1003         address to,
1004         uint256 tokenId
1005     ) internal virtual {}
1006 }
1007 
1008 /**
1009  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1010  * enumerability of all the token ids in the contract as well as all token ids owned by each
1011  * account.
1012  */
1013 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1014     // Mapping from owner to list of owned token IDs
1015     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1016 
1017     // Mapping from token ID to index of the owner tokens list
1018     mapping(uint256 => uint256) private _ownedTokensIndex;
1019 
1020     // Array with all token ids, used for enumeration
1021     uint256[] private _allTokens;
1022 
1023     // Mapping from token id to position in the allTokens array
1024     mapping(uint256 => uint256) private _allTokensIndex;
1025 
1026     /**
1027      * @dev See {IERC165-supportsInterface}.
1028      */
1029     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1030         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1031     }
1032 
1033     /**
1034      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1035      */
1036     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1037         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1038         return _ownedTokens[owner][index];
1039     }
1040 
1041     /**
1042      * @dev See {IERC721Enumerable-totalSupply}.
1043      */
1044     function totalSupply() public view virtual override returns (uint256) {
1045         return _allTokens.length;
1046     }
1047 
1048     /**
1049      * @dev See {IERC721Enumerable-tokenByIndex}.
1050      */
1051     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1052         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1053         return _allTokens[index];
1054     }
1055 
1056     /**
1057      * @dev Hook that is called before any token transfer. This includes minting
1058      * and burning.
1059      *
1060      * Calling conditions:
1061      *
1062      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1063      * transferred to `to`.
1064      * - When `from` is zero, `tokenId` will be minted for `to`.
1065      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1066      * - `from` cannot be the zero address.
1067      * - `to` cannot be the zero address.
1068      *
1069      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1070      */
1071     function _beforeTokenTransfer(
1072         address from,
1073         address to,
1074         uint256 tokenId
1075     ) internal virtual override {
1076         super._beforeTokenTransfer(from, to, tokenId);
1077 
1078         if (from == address(0)) {
1079             _addTokenToAllTokensEnumeration(tokenId);
1080         } else if (from != to) {
1081             _removeTokenFromOwnerEnumeration(from, tokenId);
1082         }
1083         if (to == address(0)) {
1084             _removeTokenFromAllTokensEnumeration(tokenId);
1085         } else if (to != from) {
1086             _addTokenToOwnerEnumeration(to, tokenId);
1087         }
1088     }
1089 
1090     /**
1091      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1092      * @param to address representing the new owner of the given token ID
1093      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1094      */
1095     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1096         uint256 length = ERC721.balanceOf(to);
1097         _ownedTokens[to][length] = tokenId;
1098         _ownedTokensIndex[tokenId] = length;
1099     }
1100 
1101     /**
1102      * @dev Private function to add a token to this extension's token tracking data structures.
1103      * @param tokenId uint256 ID of the token to be added to the tokens list
1104      */
1105     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1106         _allTokensIndex[tokenId] = _allTokens.length;
1107         _allTokens.push(tokenId);
1108     }
1109 
1110     /**
1111      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1112      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1113      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1114      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1115      * @param from address representing the previous owner of the given token ID
1116      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1117      */
1118     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1119         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1120         // then delete the last slot (swap and pop).
1121 
1122         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1123         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1124 
1125         // When the token to delete is the last token, the swap operation is unnecessary
1126         if (tokenIndex != lastTokenIndex) {
1127             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1128 
1129             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1130             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1131         }
1132 
1133         // This also deletes the contents at the last position of the array
1134         delete _ownedTokensIndex[tokenId];
1135         delete _ownedTokens[from][lastTokenIndex];
1136     }
1137 
1138     /**
1139      * @dev Private function to remove a token from this extension's token tracking data structures.
1140      * This has O(1) time complexity, but alters the order of the _allTokens array.
1141      * @param tokenId uint256 ID of the token to be removed from the tokens list
1142      */
1143     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1144         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1145         // then delete the last slot (swap and pop).
1146 
1147         uint256 lastTokenIndex = _allTokens.length - 1;
1148         uint256 tokenIndex = _allTokensIndex[tokenId];
1149 
1150         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1151         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1152         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1153         uint256 lastTokenId = _allTokens[lastTokenIndex];
1154 
1155         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1156         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1157 
1158         // This also deletes the contents at the last position of the array
1159         delete _allTokensIndex[tokenId];
1160         _allTokens.pop();
1161     }
1162 }
1163 
1164 abstract contract ReentrancyGuard {
1165     // Booleans are more expensive than uint256 or any type that takes up a full
1166     // word because each write operation emits an extra SLOAD to first read the
1167     // slot's contents, replace the bits taken up by the boolean, and then write
1168     // back. This is the compiler's defense against contract upgrades and
1169     // pointer aliasing, and it cannot be disabled.
1170 
1171     // The values being non-zero value makes deployment a bit more expensive,
1172     // but in exchange the refund on every call to nonReentrant will be lower in
1173     // amount. Since refunds are capped to a percentage of the total
1174     // transaction's gas, it is best to keep them low in cases like this one, to
1175     // increase the likelihood of the full refund coming into effect.
1176     uint256 private constant _NOT_ENTERED = 1;
1177     uint256 private constant _ENTERED = 2;
1178 
1179     uint256 private _status;
1180 
1181     constructor() {
1182         _status = _NOT_ENTERED;
1183     }
1184 
1185     /**
1186      * @dev Prevents a contract from calling itself, directly or indirectly.
1187      * Calling a `nonReentrant` function from another `nonReentrant`
1188      * function is not supported. It is possible to prevent this from happening
1189      * by making the `nonReentrant` function external, and making it call a
1190      * `private` function that does the actual work.
1191      */
1192     modifier nonReentrant() {
1193         // On the first call to nonReentrant, _notEntered will be true
1194         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1195 
1196         // Any calls to nonReentrant after this point will fail
1197         _status = _ENTERED;
1198 
1199         _;
1200 
1201         // By storing the original value once again, a refund is triggered (see
1202         // https://eips.ethereum.org/EIPS/eip-2200)
1203         _status = _NOT_ENTERED;
1204     }
1205 }
1206 
1207 contract MPHPresale {
1208 
1209 	mapping (address => uint8) public _presaleAddresses;
1210 	mapping (address => bool) public _presaleAddressesMinted;
1211 	address public owner;
1212 
1213     constructor () {
1214         owner = msg.sender;
1215     }
1216 
1217     function setMainContract(address _address) public {
1218         require(msg.sender == owner, "My Pet Hooligan: You are not the owner");
1219         owner = _address;
1220     }
1221 
1222     function addPresalers(address[] calldata _addresses, uint8[] calldata _amounts) public {
1223         require(msg.sender == owner, "My Pet Hooligan: You are not the owner");
1224         for (uint x = 0; x < _addresses.length; x++) {
1225             _presaleAddresses[_addresses[x]] = _amounts[x];
1226         }
1227     }
1228     
1229     function removePresalers(address[] calldata _addresses) public {
1230         require(msg.sender == owner, "My Pet Hooligan: You are not the owner");
1231         for (uint x = 0; x < _addresses.length; x++) {
1232             _presaleAddresses[_addresses[x]] = 0;
1233         }
1234     }
1235 
1236     function isInPresale(address _address) public view returns (uint8) {
1237         return _presaleAddresses[_address];
1238     }
1239 
1240     function isInMintedPresale(address _address) public view returns (bool) {
1241         return _presaleAddressesMinted[_address];
1242     }
1243 
1244     function addToMinted(address _address) public {
1245         require(msg.sender == owner, "My Pet Hooligan: You are not the owner");
1246         _presaleAddressesMinted[_address] = true;
1247     }
1248 
1249 }
1250 
1251 contract MPH is ERC721Enumerable, Ownable, ReentrancyGuard {
1252     uint public constant MAX = 8888;
1253 	string _baseTokenURI;
1254 	bool _didWeGetTheReserves = false;
1255 	uint _saleTime = 1639497600;
1256 	uint _presaleTime = 1639411200;
1257 	uint _price = 80000000000000000;
1258 	mapping (uint256 => string) public _tokenURI;
1259     address public _presaleContract;
1260 	address[] public _presaleAddresses;
1261 	address[] public _presaleAddressesMinted;
1262 	
1263     constructor(string memory baseURI) ERC721("My Pet Hooligan", "MPH")  {
1264         setBaseURI(baseURI);
1265     }
1266 
1267     function mint(uint _count) public payable nonReentrant {
1268         require(totalSupply() + _count <= MAX, "My Pet Hooligan: Not enough left to mint");
1269         require(totalSupply() < MAX, "My Pet Hooligan: Not enough left to mint");
1270         require(_count <= 5, "My Pet Hooligan: Exceeds the max you can mint");
1271         require(msg.value >= price(_count), "My Pet Hooligan: Value below price");
1272         
1273 
1274         if (block.timestamp >= _saleTime) {
1275             for (uint x = 0; x < _count; x++) {
1276                 _safeMint(msg.sender, totalSupply());
1277             }
1278         } else if (block.timestamp < _saleTime && block.timestamp >= _presaleTime) {
1279             require(_count <= MPHPresale(_presaleContract).isInPresale(msg.sender), "My Pet Hooligan: Exceeds the max you can mint in the presale");
1280             require(MPHPresale(_presaleContract).isInPresale(msg.sender) > 0, "My Pet Hooligan: You are not in the presale");
1281             require(MPHPresale(_presaleContract).isInMintedPresale(msg.sender) == false, "My Pet Hooligan: You already minted from the presale");
1282             for (uint x = 0; x < _count; x++) {
1283                 _safeMint(msg.sender, totalSupply());
1284             }
1285             MPHPresale(_presaleContract).addToMinted(msg.sender);
1286         }
1287     }
1288 
1289     function price(uint _count) public view returns (uint256) {
1290         return _price * _count;
1291     }
1292 
1293     function _baseURI() internal view virtual override returns (string memory) {
1294         return _baseTokenURI;
1295     }
1296     
1297     function setNewPrice(uint _newPrice) public onlyOwner {
1298         _price = _newPrice;
1299     }
1300     
1301     function setBaseURI(string memory baseURI) public onlyOwner {
1302         _baseTokenURI = baseURI;
1303     }
1304 
1305     function setPresaleAddress(address _address) public onlyOwner {
1306         _presaleContract = _address;
1307     }
1308     
1309     function changeSaleTime(uint _newDate) public onlyOwner {
1310         _saleTime = _newDate;
1311     }
1312     
1313     function changePreSaleTime(uint _newDate) public onlyOwner {
1314         _presaleTime = _newDate;
1315     }
1316     
1317     function getReserves44() public onlyOwner {
1318         require(totalSupply() + 44 <= MAX, "My Pet Hooligan: Not enough left to mint");
1319         for (uint x = 0; x < 44; x++) {
1320             _safeMint(msg.sender, totalSupply());
1321         }
1322     }
1323 
1324     function walletOfOwner(address _owner) external view returns(uint256[] memory) {
1325         uint tokenCount = balanceOf(_owner);
1326         uint256[] memory tokensId = new uint256[](tokenCount);
1327         for(uint i = 0; i < tokenCount; i++){
1328             tokensId[i] = tokenOfOwnerByIndex(_owner, i);
1329         }
1330         return tokensId;
1331     }
1332 
1333     function withdrawAll() public payable onlyOwner {
1334         require(payable(_msgSender()).send(address(this).balance));
1335     }
1336 }