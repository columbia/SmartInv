1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /*
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes calldata) {
21         return msg.data;
22     }
23 }
24 
25 /**
26  * @dev Contract module which provides a basic access control mechanism, where
27  * there is an account (an owner) that can be granted exclusive access to
28  * specific functions.
29  *
30  * By default, the owner account will be the one that deploys the contract. This
31  * can later be changed with {transferOwnership}.
32  *
33  * This module is used through inheritance. It will make available the modifier
34  * `onlyOwner`, which can be applied to your functions to restrict their use to
35  * the owner.
36  */
37 abstract contract Ownable is Context {
38     address private _owner;
39 
40     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
41 
42     /**
43      * @dev Initializes the contract setting the deployer as the initial owner.
44      */
45     constructor() {
46         _setOwner(_msgSender());
47     }
48 
49     /**
50      * @dev Returns the address of the current owner.
51      */
52     function owner() public view virtual returns (address) {
53         return _owner;
54     }
55 
56     /**
57      * @dev Throws if called by any account other than the owner.
58      */
59     modifier onlyOwner() {
60         require(owner() == _msgSender(), "Ownable: caller is not the owner");
61         _;
62     }
63 
64     /**
65      * @dev Leaves the contract without owner. It will not be possible to call
66      * `onlyOwner` functions anymore. Can only be called by the current owner.
67      *
68      * NOTE: Renouncing ownership will leave the contract without an owner,
69      * thereby removing any functionality that is only available to the owner.
70      */
71     function renounceOwnership() public virtual onlyOwner {
72         _setOwner(address(0));
73     }
74 
75     /**
76      * @dev Transfers ownership of the contract to a new account (`newOwner`).
77      * Can only be called by the current owner.
78      */
79     function transferOwnership(address newOwner) public virtual onlyOwner {
80         require(newOwner != address(0), "Ownable: new owner is the zero address");
81         _setOwner(newOwner);
82     }
83 
84     function _setOwner(address newOwner) private {
85         address oldOwner = _owner;
86         _owner = newOwner;
87         emit OwnershipTransferred(oldOwner, newOwner);
88     }
89 }
90 
91 /**
92  * @dev Interface of the ERC165 standard, as defined in the
93  * https://eips.ethereum.org/EIPS/eip-165[EIP].
94  *
95  * Implementers can declare support of contract interfaces, which can then be
96  * queried by others ({ERC165Checker}).
97  *
98  * For an implementation, see {ERC165}.
99  */
100 interface IERC165 {
101     /**
102      * @dev Returns true if this contract implements the interface defined by
103      * `interfaceId`. See the corresponding
104      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
105      * to learn more about how these ids are created.
106      *
107      * This function call must use less than 30 000 gas.
108      */
109     function supportsInterface(bytes4 interfaceId) external view returns (bool);
110 }
111 
112 /**
113  * @dev Required interface of an ERC721 compliant contract.
114  */
115 interface IERC721 is IERC165 {
116     /**
117      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
118      */
119     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
120 
121     /**
122      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
123      */
124     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
125 
126     /**
127      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
128      */
129     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
130 
131     /**
132      * @dev Returns the number of tokens in ``owner``'s account.
133      */
134     function balanceOf(address owner) external view returns (uint256 balance);
135 
136     /**
137      * @dev Returns the owner of the `tokenId` token.
138      *
139      * Requirements:
140      *
141      * - `tokenId` must exist.
142      */
143     function ownerOf(uint256 tokenId) external view returns (address owner);
144 
145     /**
146      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
147      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
148      *
149      * Requirements:
150      *
151      * - `from` cannot be the zero address.
152      * - `to` cannot be the zero address.
153      * - `tokenId` token must exist and be owned by `from`.
154      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
155      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
156      *
157      * Emits a {Transfer} event.
158      */
159     function safeTransferFrom(
160         address from,
161         address to,
162         uint256 tokenId
163     ) external;
164 
165     /**
166      * @dev Transfers `tokenId` token from `from` to `to`.
167      *
168      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
169      *
170      * Requirements:
171      *
172      * - `from` cannot be the zero address.
173      * - `to` cannot be the zero address.
174      * - `tokenId` token must be owned by `from`.
175      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
176      *
177      * Emits a {Transfer} event.
178      */
179     function transferFrom(
180         address from,
181         address to,
182         uint256 tokenId
183     ) external;
184 
185     /**
186      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
187      * The approval is cleared when the token is transferred.
188      *
189      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
190      *
191      * Requirements:
192      *
193      * - The caller must own the token or be an approved operator.
194      * - `tokenId` must exist.
195      *
196      * Emits an {Approval} event.
197      */
198     function approve(address to, uint256 tokenId) external;
199 
200     /**
201      * @dev Returns the account approved for `tokenId` token.
202      *
203      * Requirements:
204      *
205      * - `tokenId` must exist.
206      */
207     function getApproved(uint256 tokenId) external view returns (address operator);
208 
209     /**
210      * @dev Approve or remove `operator` as an operator for the caller.
211      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
212      *
213      * Requirements:
214      *
215      * - The `operator` cannot be the caller.
216      *
217      * Emits an {ApprovalForAll} event.
218      */
219     function setApprovalForAll(address operator, bool _approved) external;
220 
221     /**
222      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
223      *
224      * See {setApprovalForAll}
225      */
226     function isApprovedForAll(address owner, address operator) external view returns (bool);
227 
228     /**
229      * @dev Safely transfers `tokenId` token from `from` to `to`.
230      *
231      * Requirements:
232      *
233      * - `from` cannot be the zero address.
234      * - `to` cannot be the zero address.
235      * - `tokenId` token must exist and be owned by `from`.
236      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
237      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
238      *
239      * Emits a {Transfer} event.
240      */
241     function safeTransferFrom(
242         address from,
243         address to,
244         uint256 tokenId,
245         bytes calldata data
246     ) external;
247 }
248 
249 /**
250  * @title ERC721 token receiver interface
251  * @dev Interface for any contract that wants to support safeTransfers
252  * from ERC721 asset contracts.
253  */
254 interface IERC721Receiver {
255     /**
256      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
257      * by `operator` from `from`, this function is called.
258      *
259      * It must return its Solidity selector to confirm the token transfer.
260      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
261      *
262      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
263      */
264     function onERC721Received(
265         address operator,
266         address from,
267         uint256 tokenId,
268         bytes calldata data
269     ) external returns (bytes4);
270 }
271 
272 /**
273  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
274  * @dev See https://eips.ethereum.org/EIPS/eip-721
275  */
276 interface IERC721Metadata is IERC721 {
277     /**
278      * @dev Returns the token collection name.
279      */
280     function name() external view returns (string memory);
281 
282     /**
283      * @dev Returns the token collection symbol.
284      */
285     function symbol() external view returns (string memory);
286 
287     /**
288      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
289      */
290     function tokenURI(uint256 tokenId) external view returns (string memory);
291 }
292 
293 /**
294  * @dev Collection of functions related to the address type
295  */
296 library Address {
297     /**
298      * @dev Returns true if `account` is a contract.
299      *
300      * [IMPORTANT]
301      * ====
302      * It is unsafe to assume that an address for which this function returns
303      * false is an externally-owned account (EOA) and not a contract.
304      *
305      * Among others, `isContract` will return false for the following
306      * types of addresses:
307      *
308      *  - an externally-owned account
309      *  - a contract in construction
310      *  - an address where a contract will be created
311      *  - an address where a contract lived, but was destroyed
312      * ====
313      */
314     function isContract(address account) internal view returns (bool) {
315         // This method relies on extcodesize, which returns 0 for contracts in
316         // construction, since the code is only stored at the end of the
317         // constructor execution.
318 
319         uint256 size;
320         assembly {
321             size := extcodesize(account)
322         }
323         return size > 0;
324     }
325 
326     /**
327      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
328      * `recipient`, forwarding all available gas and reverting on errors.
329      *
330      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
331      * of certain opcodes, possibly making contracts go over the 2300 gas limit
332      * imposed by `transfer`, making them unable to receive funds via
333      * `transfer`. {sendValue} removes this limitation.
334      *
335      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
336      *
337      * IMPORTANT: because control is transferred to `recipient`, care must be
338      * taken to not create reentrancy vulnerabilities. Consider using
339      * {ReentrancyGuard} or the
340      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
341      */
342     function sendValue(address payable recipient, uint256 amount) internal {
343         require(address(this).balance >= amount, "Address: insufficient balance");
344 
345         (bool success, ) = recipient.call{value: amount}("");
346         require(success, "Address: unable to send value, recipient may have reverted");
347     }
348 
349     /**
350      * @dev Performs a Solidity function call using a low level `call`. A
351      * plain `call` is an unsafe replacement for a function call: use this
352      * function instead.
353      *
354      * If `target` reverts with a revert reason, it is bubbled up by this
355      * function (like regular Solidity function calls).
356      *
357      * Returns the raw returned data. To convert to the expected return value,
358      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
359      *
360      * Requirements:
361      *
362      * - `target` must be a contract.
363      * - calling `target` with `data` must not revert.
364      *
365      * _Available since v3.1._
366      */
367     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
368         return functionCall(target, data, "Address: low-level call failed");
369     }
370 
371     /**
372      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
373      * `errorMessage` as a fallback revert reason when `target` reverts.
374      *
375      * _Available since v3.1._
376      */
377     function functionCall(
378         address target,
379         bytes memory data,
380         string memory errorMessage
381     ) internal returns (bytes memory) {
382         return functionCallWithValue(target, data, 0, errorMessage);
383     }
384 
385     /**
386      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
387      * but also transferring `value` wei to `target`.
388      *
389      * Requirements:
390      *
391      * - the calling contract must have an ETH balance of at least `value`.
392      * - the called Solidity function must be `payable`.
393      *
394      * _Available since v3.1._
395      */
396     function functionCallWithValue(
397         address target,
398         bytes memory data,
399         uint256 value
400     ) internal returns (bytes memory) {
401         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
402     }
403 
404     /**
405      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
406      * with `errorMessage` as a fallback revert reason when `target` reverts.
407      *
408      * _Available since v3.1._
409      */
410     function functionCallWithValue(
411         address target,
412         bytes memory data,
413         uint256 value,
414         string memory errorMessage
415     ) internal returns (bytes memory) {
416         require(address(this).balance >= value, "Address: insufficient balance for call");
417         require(isContract(target), "Address: call to non-contract");
418 
419         (bool success, bytes memory returndata) = target.call{value: value}(data);
420         return _verifyCallResult(success, returndata, errorMessage);
421     }
422 
423     /**
424      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
425      * but performing a static call.
426      *
427      * _Available since v3.3._
428      */
429     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
430         return functionStaticCall(target, data, "Address: low-level static call failed");
431     }
432 
433     /**
434      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
435      * but performing a static call.
436      *
437      * _Available since v3.3._
438      */
439     function functionStaticCall(
440         address target,
441         bytes memory data,
442         string memory errorMessage
443     ) internal view returns (bytes memory) {
444         require(isContract(target), "Address: static call to non-contract");
445 
446         (bool success, bytes memory returndata) = target.staticcall(data);
447         return _verifyCallResult(success, returndata, errorMessage);
448     }
449 
450     /**
451      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
452      * but performing a delegate call.
453      *
454      * _Available since v3.4._
455      */
456     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
457         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
458     }
459 
460     /**
461      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
462      * but performing a delegate call.
463      *
464      * _Available since v3.4._
465      */
466     function functionDelegateCall(
467         address target,
468         bytes memory data,
469         string memory errorMessage
470     ) internal returns (bytes memory) {
471         require(isContract(target), "Address: delegate call to non-contract");
472 
473         (bool success, bytes memory returndata) = target.delegatecall(data);
474         return _verifyCallResult(success, returndata, errorMessage);
475     }
476 
477     function _verifyCallResult(
478         bool success,
479         bytes memory returndata,
480         string memory errorMessage
481     ) private pure returns (bytes memory) {
482         if (success) {
483             return returndata;
484         } else {
485             // Look for revert reason and bubble it up if present
486             if (returndata.length > 0) {
487                 // The easiest way to bubble the revert reason is using memory via assembly
488 
489                 assembly {
490                     let returndata_size := mload(returndata)
491                     revert(add(32, returndata), returndata_size)
492                 }
493             } else {
494                 revert(errorMessage);
495             }
496         }
497     }
498 }
499 
500 /**
501  * @dev String operations.
502  */
503 library Strings {
504     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
505 
506     /**
507      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
508      */
509     function toString(uint256 value) internal pure returns (string memory) {
510         // Inspired by OraclizeAPI's implementation - MIT licence
511         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
512 
513         if (value == 0) {
514             return "0";
515         }
516         uint256 temp = value;
517         uint256 digits;
518         while (temp != 0) {
519             digits++;
520             temp /= 10;
521         }
522         bytes memory buffer = new bytes(digits);
523         while (value != 0) {
524             digits -= 1;
525             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
526             value /= 10;
527         }
528         return string(buffer);
529     }
530 
531     /**
532      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
533      */
534     function toHexString(uint256 value) internal pure returns (string memory) {
535         if (value == 0) {
536             return "0x00";
537         }
538         uint256 temp = value;
539         uint256 length = 0;
540         while (temp != 0) {
541             length++;
542             temp >>= 8;
543         }
544         return toHexString(value, length);
545     }
546 
547     /**
548      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
549      */
550     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
551         bytes memory buffer = new bytes(2 * length + 2);
552         buffer[0] = "0";
553         buffer[1] = "x";
554         for (uint256 i = 2 * length + 1; i > 1; --i) {
555             buffer[i] = _HEX_SYMBOLS[value & 0xf];
556             value >>= 4;
557         }
558         require(value == 0, "Strings: hex length insufficient");
559         return string(buffer);
560     }
561 }
562 
563 /**
564  * @dev Implementation of the {IERC165} interface.
565  *
566  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
567  * for the additional interface id that will be supported. For example:
568  *
569  * ```solidity
570  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
571  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
572  * }
573  * ```
574  *
575  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
576  */
577 abstract contract ERC165 is IERC165 {
578     /**
579      * @dev See {IERC165-supportsInterface}.
580      */
581     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
582         return interfaceId == type(IERC165).interfaceId;
583     }
584 }
585 
586 /**
587  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
588  * the Metadata extension, but not including the Enumerable extension, which is available separately as
589  * {ERC721Enumerable}.
590  */
591 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
592     using Address for address;
593     using Strings for uint256;
594 
595     // Token name
596     string private _name;
597 
598     // Token symbol
599     string private _symbol;
600 
601     // Mapping from token ID to owner address
602     mapping(uint256 => address) private _owners;
603 
604     // Mapping owner address to token count
605     mapping(address => uint256) private _balances;
606 
607     // Mapping from token ID to approved address
608     mapping(uint256 => address) private _tokenApprovals;
609 
610     // Mapping from owner to operator approvals
611     mapping(address => mapping(address => bool)) private _operatorApprovals;
612 
613     /**
614      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
615      */
616     constructor(string memory name_, string memory symbol_) {
617         _name = name_;
618         _symbol = symbol_;
619     }
620 
621     /**
622      * @dev See {IERC165-supportsInterface}.
623      */
624     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
625         return
626             interfaceId == type(IERC721).interfaceId ||
627             interfaceId == type(IERC721Metadata).interfaceId ||
628             super.supportsInterface(interfaceId);
629     }
630 
631     /**
632      * @dev See {IERC721-balanceOf}.
633      */
634     function balanceOf(address owner) public view virtual override returns (uint256) {
635         require(owner != address(0), "ERC721: balance query for the zero address");
636         return _balances[owner];
637     }
638 
639     /**
640      * @dev See {IERC721-ownerOf}.
641      */
642     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
643         address owner = _owners[tokenId];
644         require(owner != address(0), "ERC721: owner query for nonexistent token");
645         return owner;
646     }
647 
648     /**
649      * @dev See {IERC721Metadata-name}.
650      */
651     function name() public view virtual override returns (string memory) {
652         return _name;
653     }
654 
655     /**
656      * @dev See {IERC721Metadata-symbol}.
657      */
658     function symbol() public view virtual override returns (string memory) {
659         return _symbol;
660     }
661 
662     /**
663      * @dev See {IERC721Metadata-tokenURI}.
664      */
665     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
666         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
667 
668         string memory baseURI = _baseURI();
669         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
670     }
671 
672     /**
673      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
674      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
675      * by default, can be overriden in child contracts.
676      */
677     function _baseURI() internal view virtual returns (string memory) {
678         return "";
679     }
680 
681     /**
682      * @dev See {IERC721-approve}.
683      */
684     function approve(address to, uint256 tokenId) public virtual override {
685         address owner = ERC721.ownerOf(tokenId);
686         require(to != owner, "ERC721: approval to current owner");
687 
688         require(
689             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
690             "ERC721: approve caller is not owner nor approved for all"
691         );
692 
693         _approve(to, tokenId);
694     }
695 
696     /**
697      * @dev See {IERC721-getApproved}.
698      */
699     function getApproved(uint256 tokenId) public view virtual override returns (address) {
700         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
701 
702         return _tokenApprovals[tokenId];
703     }
704 
705     /**
706      * @dev See {IERC721-setApprovalForAll}.
707      */
708     function setApprovalForAll(address operator, bool approved) public virtual override {
709         require(operator != _msgSender(), "ERC721: approve to caller");
710 
711         _operatorApprovals[_msgSender()][operator] = approved;
712         emit ApprovalForAll(_msgSender(), operator, approved);
713     }
714 
715     /**
716      * @dev See {IERC721-isApprovedForAll}.
717      */
718     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
719         return _operatorApprovals[owner][operator];
720     }
721 
722     /**
723      * @dev See {IERC721-transferFrom}.
724      */
725     function transferFrom(
726         address from,
727         address to,
728         uint256 tokenId
729     ) public virtual override {
730         //solhint-disable-next-line max-line-length
731         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
732 
733         _transfer(from, to, tokenId);
734     }
735 
736     /**
737      * @dev See {IERC721-safeTransferFrom}.
738      */
739     function safeTransferFrom(
740         address from,
741         address to,
742         uint256 tokenId
743     ) public virtual override {
744         safeTransferFrom(from, to, tokenId, "");
745     }
746 
747     /**
748      * @dev See {IERC721-safeTransferFrom}.
749      */
750     function safeTransferFrom(
751         address from,
752         address to,
753         uint256 tokenId,
754         bytes memory _data
755     ) public virtual override {
756         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
757         _safeTransfer(from, to, tokenId, _data);
758     }
759 
760     /**
761      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
762      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
763      *
764      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
765      *
766      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
767      * implement alternative mechanisms to perform token transfer, such as signature-based.
768      *
769      * Requirements:
770      *
771      * - `from` cannot be the zero address.
772      * - `to` cannot be the zero address.
773      * - `tokenId` token must exist and be owned by `from`.
774      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
775      *
776      * Emits a {Transfer} event.
777      */
778     function _safeTransfer(
779         address from,
780         address to,
781         uint256 tokenId,
782         bytes memory _data
783     ) internal virtual {
784         _transfer(from, to, tokenId);
785         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
786     }
787 
788     /**
789      * @dev Returns whether `tokenId` exists.
790      *
791      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
792      *
793      * Tokens start existing when they are minted (`_mint`),
794      * and stop existing when they are burned (`_burn`).
795      */
796     function _exists(uint256 tokenId) internal view virtual returns (bool) {
797         return _owners[tokenId] != address(0);
798     }
799 
800     /**
801      * @dev Returns whether `spender` is allowed to manage `tokenId`.
802      *
803      * Requirements:
804      *
805      * - `tokenId` must exist.
806      */
807     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
808         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
809         address owner = ERC721.ownerOf(tokenId);
810         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
811     }
812 
813     /**
814      * @dev Safely mints `tokenId` and transfers it to `to`.
815      *
816      * Requirements:
817      *
818      * - `tokenId` must not exist.
819      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
820      *
821      * Emits a {Transfer} event.
822      */
823     function _safeMint(address to, uint256 tokenId) internal virtual {
824         _safeMint(to, tokenId, "");
825     }
826 
827     /**
828      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
829      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
830      */
831     function _safeMint(
832         address to,
833         uint256 tokenId,
834         bytes memory _data
835     ) internal virtual {
836         _mint(to, tokenId);
837         require(
838             _checkOnERC721Received(address(0), to, tokenId, _data),
839             "ERC721: transfer to non ERC721Receiver implementer"
840         );
841     }
842 
843     /**
844      * @dev Mints `tokenId` and transfers it to `to`.
845      *
846      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
847      *
848      * Requirements:
849      *
850      * - `tokenId` must not exist.
851      * - `to` cannot be the zero address.
852      *
853      * Emits a {Transfer} event.
854      */
855     function _mint(address to, uint256 tokenId) internal virtual {
856         require(to != address(0), "ERC721: mint to the zero address");
857         require(!_exists(tokenId), "ERC721: token already minted");
858 
859         _beforeTokenTransfer(address(0), to, tokenId);
860 
861         _balances[to] += 1;
862         _owners[tokenId] = to;
863 
864         emit Transfer(address(0), to, tokenId);
865     }
866 
867     /**
868      * @dev Destroys `tokenId`.
869      * The approval is cleared when the token is burned.
870      *
871      * Requirements:
872      *
873      * - `tokenId` must exist.
874      *
875      * Emits a {Transfer} event.
876      */
877     function _burn(uint256 tokenId) internal virtual {
878         address owner = ERC721.ownerOf(tokenId);
879 
880         _beforeTokenTransfer(owner, address(0), tokenId);
881 
882         // Clear approvals
883         _approve(address(0), tokenId);
884 
885         _balances[owner] -= 1;
886         delete _owners[tokenId];
887 
888         emit Transfer(owner, address(0), tokenId);
889     }
890 
891     /**
892      * @dev Transfers `tokenId` from `from` to `to`.
893      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
894      *
895      * Requirements:
896      *
897      * - `to` cannot be the zero address.
898      * - `tokenId` token must be owned by `from`.
899      *
900      * Emits a {Transfer} event.
901      */
902     function _transfer(
903         address from,
904         address to,
905         uint256 tokenId
906     ) internal virtual {
907         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
908         require(to != address(0), "ERC721: transfer to the zero address");
909 
910         _beforeTokenTransfer(from, to, tokenId);
911 
912         // Clear approvals from the previous owner
913         _approve(address(0), tokenId);
914 
915         _balances[from] -= 1;
916         _balances[to] += 1;
917         _owners[tokenId] = to;
918 
919         emit Transfer(from, to, tokenId);
920     }
921 
922     /**
923      * @dev Approve `to` to operate on `tokenId`
924      *
925      * Emits a {Approval} event.
926      */
927     function _approve(address to, uint256 tokenId) internal virtual {
928         _tokenApprovals[tokenId] = to;
929         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
930     }
931 
932     /**
933      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
934      * The call is not executed if the target address is not a contract.
935      *
936      * @param from address representing the previous owner of the given token ID
937      * @param to target address that will receive the tokens
938      * @param tokenId uint256 ID of the token to be transferred
939      * @param _data bytes optional data to send along with the call
940      * @return bool whether the call correctly returned the expected magic value
941      */
942     function _checkOnERC721Received(
943         address from,
944         address to,
945         uint256 tokenId,
946         bytes memory _data
947     ) private returns (bool) {
948         if (to.isContract()) {
949             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
950                 return retval == IERC721Receiver(to).onERC721Received.selector;
951             } catch (bytes memory reason) {
952                 if (reason.length == 0) {
953                     revert("ERC721: transfer to non ERC721Receiver implementer");
954                 } else {
955                     assembly {
956                         revert(add(32, reason), mload(reason))
957                     }
958                 }
959             }
960         } else {
961             return true;
962         }
963     }
964 
965     /**
966      * @dev Hook that is called before any token transfer. This includes minting
967      * and burning.
968      *
969      * Calling conditions:
970      *
971      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
972      * transferred to `to`.
973      * - When `from` is zero, `tokenId` will be minted for `to`.
974      * - When `to` is zero, ``from``'s `tokenId` will be burned.
975      * - `from` and `to` are never both zero.
976      *
977      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
978      */
979     function _beforeTokenTransfer(
980         address from,
981         address to,
982         uint256 tokenId
983     ) internal virtual {}
984 }
985 
986 /**
987  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
988  * @dev See https://eips.ethereum.org/EIPS/eip-721
989  */
990 interface IERC721Enumerable is IERC721 {
991     /**
992      * @dev Returns the total amount of tokens stored by the contract.
993      */
994     function totalSupply() external view returns (uint256);
995 
996     /**
997      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
998      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
999      */
1000     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1001 
1002     /**
1003      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1004      * Use along with {totalSupply} to enumerate all tokens.
1005      */
1006     function tokenByIndex(uint256 index) external view returns (uint256);
1007 }
1008 
1009 /**
1010  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1011  * enumerability of all the token ids in the contract as well as all token ids owned by each
1012  * account.
1013  */
1014 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1015     // Mapping from owner to list of owned token IDs
1016     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1017 
1018     // Mapping from token ID to index of the owner tokens list
1019     mapping(uint256 => uint256) private _ownedTokensIndex;
1020 
1021     // Array with all token ids, used for enumeration
1022     uint256[] private _allTokens;
1023 
1024     // Mapping from token id to position in the allTokens array
1025     mapping(uint256 => uint256) private _allTokensIndex;
1026 
1027     /**
1028      * @dev See {IERC165-supportsInterface}.
1029      */
1030     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1031         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1032     }
1033 
1034     /**
1035      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1036      */
1037     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1038         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1039         return _ownedTokens[owner][index];
1040     }
1041 
1042     /**
1043      * @dev See {IERC721Enumerable-totalSupply}.
1044      */
1045     function totalSupply() public view virtual override returns (uint256) {
1046         return _allTokens.length;
1047     }
1048 
1049     /**
1050      * @dev See {IERC721Enumerable-tokenByIndex}.
1051      */
1052     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1053         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1054         return _allTokens[index];
1055     }
1056 
1057     /**
1058      * @dev Hook that is called before any token transfer. This includes minting
1059      * and burning.
1060      *
1061      * Calling conditions:
1062      *
1063      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1064      * transferred to `to`.
1065      * - When `from` is zero, `tokenId` will be minted for `to`.
1066      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1067      * - `from` cannot be the zero address.
1068      * - `to` cannot be the zero address.
1069      *
1070      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1071      */
1072     function _beforeTokenTransfer(
1073         address from,
1074         address to,
1075         uint256 tokenId
1076     ) internal virtual override {
1077         super._beforeTokenTransfer(from, to, tokenId);
1078 
1079         if (from == address(0)) {
1080             _addTokenToAllTokensEnumeration(tokenId);
1081         } else if (from != to) {
1082             _removeTokenFromOwnerEnumeration(from, tokenId);
1083         }
1084         if (to == address(0)) {
1085             _removeTokenFromAllTokensEnumeration(tokenId);
1086         } else if (to != from) {
1087             _addTokenToOwnerEnumeration(to, tokenId);
1088         }
1089     }
1090 
1091     /**
1092      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1093      * @param to address representing the new owner of the given token ID
1094      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1095      */
1096     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1097         uint256 length = ERC721.balanceOf(to);
1098         _ownedTokens[to][length] = tokenId;
1099         _ownedTokensIndex[tokenId] = length;
1100     }
1101 
1102     /**
1103      * @dev Private function to add a token to this extension's token tracking data structures.
1104      * @param tokenId uint256 ID of the token to be added to the tokens list
1105      */
1106     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1107         _allTokensIndex[tokenId] = _allTokens.length;
1108         _allTokens.push(tokenId);
1109     }
1110 
1111     /**
1112      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1113      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1114      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1115      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1116      * @param from address representing the previous owner of the given token ID
1117      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1118      */
1119     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1120         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1121         // then delete the last slot (swap and pop).
1122 
1123         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1124         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1125 
1126         // When the token to delete is the last token, the swap operation is unnecessary
1127         if (tokenIndex != lastTokenIndex) {
1128             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1129 
1130             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1131             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1132         }
1133 
1134         // This also deletes the contents at the last position of the array
1135         delete _ownedTokensIndex[tokenId];
1136         delete _ownedTokens[from][lastTokenIndex];
1137     }
1138 
1139     /**
1140      * @dev Private function to remove a token from this extension's token tracking data structures.
1141      * This has O(1) time complexity, but alters the order of the _allTokens array.
1142      * @param tokenId uint256 ID of the token to be removed from the tokens list
1143      */
1144     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1145         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1146         // then delete the last slot (swap and pop).
1147 
1148         uint256 lastTokenIndex = _allTokens.length - 1;
1149         uint256 tokenIndex = _allTokensIndex[tokenId];
1150 
1151         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1152         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1153         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1154         uint256 lastTokenId = _allTokens[lastTokenIndex];
1155 
1156         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1157         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1158 
1159         // This also deletes the contents at the last position of the array
1160         delete _allTokensIndex[tokenId];
1161         _allTokens.pop();
1162     }
1163 }
1164 
1165 /**
1166  * @title MonstersBash contract
1167  * @dev Extends ERC721 Token
1168  */
1169 contract MonstersBash is ERC721, ERC721Enumerable, Ownable {
1170 
1171     using Strings for uint256;
1172 
1173     uint256 public salePrice = 0.08001 ether;
1174     bool public saleIsActive = false;
1175     uint256 public constant MAX_NFTS_PER_TX = 20;
1176     uint256 public constant MAX_SUPPLY = 10000;
1177     uint256 public constant MAX_EXCLUSIVE_PER_WALLET = 5;
1178     uint256 public exclusiveMintRemaining = 2000;
1179     address public exclusiveNftAddress;
1180     address payable public multisig;
1181     address payable public splitter;
1182     bool private reserved = false;
1183 
1184     constructor(address payable _multisig, address payable _splitter) ERC721("Monsters Bash", "MBASH") {
1185         multisig = _multisig;
1186         splitter = _splitter;
1187     }
1188 
1189     function toggleSaleState() public onlyOwner {
1190         saleIsActive = !saleIsActive;
1191     }
1192 
1193     function setPrice(uint256 _salePrice) public onlyOwner {
1194         salePrice = _salePrice;
1195     }
1196 
1197     function mint(uint256 n) public payable {
1198         require(saleIsActive, "Sale must be active!");
1199         require(n <= MAX_NFTS_PER_TX, "Exceeded max NFTs per transaction");
1200         require(salePrice * n <= msg.value, "Not enough Ether sent");
1201 
1202         uint256 mintIndex = totalSupply();
1203         require(mintIndex + n <= MAX_SUPPLY, "Mint would exceed max supply of NFTs");
1204 
1205         payable(splitter).transfer(address(this).balance);
1206         for (uint256 i = 0; i < n; i++) {
1207             _safeMint(msg.sender, mintIndex + i);
1208         }
1209     }
1210 
1211     /*
1212    * FLS: ladies first presale
1213    */
1214     function mintExclusive(uint256 n) public payable {
1215         require(exclusiveNftAddress != address(0), "Exclusive mints not enabled!");
1216         require(exclusiveMintRemaining > 0, "No more exclusive mints available!");
1217         require(n <= exclusiveMintRemaining, "Mint would exceed max supply of exclusive mints!");
1218         require(ERC721(exclusiveNftAddress).balanceOf(msg.sender) > 0, "Not holding an exclusive NFT!");
1219         require(this.balanceOf(msg.sender) + n <= MAX_EXCLUSIVE_PER_WALLET, "Exceeded max NFTs per wallet");
1220         require(salePrice * n <= msg.value, "Not enough Ether sent");
1221 
1222         uint256 mintIndex = totalSupply();
1223         require(mintIndex + n <= MAX_SUPPLY, "Mint would exceed max supply of NFTs");
1224 
1225         exclusiveMintRemaining -= n;
1226         payable(splitter).transfer(address(this).balance);
1227         for (uint256 i = 0; i < n; i++) {
1228             _safeMint(msg.sender, mintIndex + i);
1229         }
1230     }
1231 
1232     function setExclusiveAddress(address _exclusiveNftAddress) public onlyOwner {
1233         exclusiveNftAddress = _exclusiveNftAddress;
1234     }
1235 
1236     function setExclusiveMintRemaining(uint256 n) public onlyOwner {
1237         exclusiveMintRemaining = n;
1238     }
1239 
1240     /*
1241     * reserve for team and giveaways
1242     */
1243     function reserve() public onlyOwner {
1244         require(!reserved, "already reserved");
1245         reserved = true;
1246         uint supply = totalSupply();
1247         for (uint256 i = 0; i < 100; i++) {
1248             _safeMint(msg.sender, supply + i);
1249         }
1250     }
1251 
1252     /**
1253      * emergency withdraw function to multisig
1254      */
1255     function withdrawMultisig() public onlyOwner {
1256         payable(multisig).transfer(address(this).balance);
1257     }
1258 
1259     string private _baseURIextension;
1260 
1261     function setBaseURI(string memory baseURI_) external onlyOwner() {
1262         _baseURIextension = baseURI_;
1263     }
1264 
1265     function _baseURI() internal view virtual override returns (string memory) {
1266         return _baseURIextension;
1267     }
1268 
1269     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1270         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1271 
1272         if (tokenURIExternal != address(0)) {
1273             return ERC721(tokenURIExternal).tokenURI(tokenId);
1274         }
1275 
1276         string memory baseURI = _baseURI();
1277         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1278     }
1279 
1280     // Allow metadata to be brought on-chain through another smart contract
1281     address private tokenURIExternal;
1282 
1283     function updateTokenURIExternal(address _tokenURIExternal) public onlyOwner {
1284         tokenURIExternal = _tokenURIExternal;
1285     }
1286 
1287     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal override(ERC721, ERC721Enumerable) {
1288         super._beforeTokenTransfer(from, to, tokenId);
1289     }
1290 
1291     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, ERC721Enumerable) returns (bool) {
1292         return super.supportsInterface(interfaceId);
1293     }
1294 
1295 }