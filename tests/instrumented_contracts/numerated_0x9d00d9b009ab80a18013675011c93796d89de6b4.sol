1 //SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 /**
5  * @dev Provides information about the current execution context, including the
6  * sender of the transaction and its data. While these are generally available
7  * via msg.sender and msg.data, they should not be accessed in such a direct
8  * manner, since when dealing with meta-transactions the account sending and
9  * paying for execution may not be the actual sender (as far as an application
10  * is concerned).
11  *
12  * This contract is only required for intermediate, library-like contracts.
13  */
14 abstract contract Context {
15     function _msgSender() internal view virtual returns (address) {
16         return msg.sender;
17     }
18 
19     function _msgData() internal view virtual returns (bytes calldata) {
20         return msg.data;
21     }
22 }
23 
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
113  * @dev Implementation of the {IERC165} interface.
114  *
115  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
116  * for the additional interface id that will be supported. For example:
117  *
118  * ```solidity
119  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
120  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
121  * }
122  * ```
123  *
124  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
125  */
126 abstract contract ERC165 is IERC165 {
127     /**
128      * @dev See {IERC165-supportsInterface}.
129      */
130     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
131         return interfaceId == type(IERC165).interfaceId;
132     }
133 }
134 
135 
136 /**
137  * @dev Collection of functions related to the address type
138  */
139 library Address {
140     /**
141      * @dev Returns true if `account` is a contract.
142      *
143      * [IMPORTANT]
144      * ====
145      * It is unsafe to assume that an address for which this function returns
146      * false is an externally-owned account (EOA) and not a contract.
147      *
148      * Among others, `isContract` will return false for the following
149      * types of addresses:
150      *
151      *  - an externally-owned account
152      *  - a contract in construction
153      *  - an address where a contract will be created
154      *  - an address where a contract lived, but was destroyed
155      * ====
156      */
157     function isContract(address account) internal view returns (bool) {
158         // This method relies on extcodesize, which returns 0 for contracts in
159         // construction, since the code is only stored at the end of the
160         // constructor execution.
161 
162         uint256 size;
163         assembly {
164             size := extcodesize(account)
165         }
166         return size > 0;
167     }
168 
169     /**
170      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
171      * `recipient`, forwarding all available gas and reverting on errors.
172      *
173      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
174      * of certain opcodes, possibly making contracts go over the 2300 gas limit
175      * imposed by `transfer`, making them unable to receive funds via
176      * `transfer`. {sendValue} removes this limitation.
177      *
178      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
179      *
180      * IMPORTANT: because control is transferred to `recipient`, care must be
181      * taken to not create reentrancy vulnerabilities. Consider using
182      * {ReentrancyGuard} or the
183      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
184      */
185     function sendValue(address payable recipient, uint256 amount) internal {
186         require(address(this).balance >= amount, "Address: insufficient balance");
187 
188         (bool success, ) = recipient.call{value: amount}("");
189         require(success, "Address: unable to send value, recipient may have reverted");
190     }
191 
192     /**
193      * @dev Performs a Solidity function call using a low level `call`. A
194      * plain `call` is an unsafe replacement for a function call: use this
195      * function instead.
196      *
197      * If `target` reverts with a revert reason, it is bubbled up by this
198      * function (like regular Solidity function calls).
199      *
200      * Returns the raw returned data. To convert to the expected return value,
201      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
202      *
203      * Requirements:
204      *
205      * - `target` must be a contract.
206      * - calling `target` with `data` must not revert.
207      *
208      * _Available since v3.1._
209      */
210     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
211         return functionCall(target, data, "Address: low-level call failed");
212     }
213 
214     /**
215      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
216      * `errorMessage` as a fallback revert reason when `target` reverts.
217      *
218      * _Available since v3.1._
219      */
220     function functionCall(
221         address target,
222         bytes memory data,
223         string memory errorMessage
224     ) internal returns (bytes memory) {
225         return functionCallWithValue(target, data, 0, errorMessage);
226     }
227 
228     /**
229      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
230      * but also transferring `value` wei to `target`.
231      *
232      * Requirements:
233      *
234      * - the calling contract must have an ETH balance of at least `value`.
235      * - the called Solidity function must be `payable`.
236      *
237      * _Available since v3.1._
238      */
239     function functionCallWithValue(
240         address target,
241         bytes memory data,
242         uint256 value
243     ) internal returns (bytes memory) {
244         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
245     }
246 
247     /**
248      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
249      * with `errorMessage` as a fallback revert reason when `target` reverts.
250      *
251      * _Available since v3.1._
252      */
253     function functionCallWithValue(
254         address target,
255         bytes memory data,
256         uint256 value,
257         string memory errorMessage
258     ) internal returns (bytes memory) {
259         require(address(this).balance >= value, "Address: insufficient balance for call");
260         require(isContract(target), "Address: call to non-contract");
261 
262         (bool success, bytes memory returndata) = target.call{value: value}(data);
263         return verifyCallResult(success, returndata, errorMessage);
264     }
265 
266     /**
267      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
268      * but performing a static call.
269      *
270      * _Available since v3.3._
271      */
272     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
273         return functionStaticCall(target, data, "Address: low-level static call failed");
274     }
275 
276     /**
277      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
278      * but performing a static call.
279      *
280      * _Available since v3.3._
281      */
282     function functionStaticCall(
283         address target,
284         bytes memory data,
285         string memory errorMessage
286     ) internal view returns (bytes memory) {
287         require(isContract(target), "Address: static call to non-contract");
288 
289         (bool success, bytes memory returndata) = target.staticcall(data);
290         return verifyCallResult(success, returndata, errorMessage);
291     }
292 
293     /**
294      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
295      * but performing a delegate call.
296      *
297      * _Available since v3.4._
298      */
299     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
300         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
301     }
302 
303     /**
304      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
305      * but performing a delegate call.
306      *
307      * _Available since v3.4._
308      */
309     function functionDelegateCall(
310         address target,
311         bytes memory data,
312         string memory errorMessage
313     ) internal returns (bytes memory) {
314         require(isContract(target), "Address: delegate call to non-contract");
315 
316         (bool success, bytes memory returndata) = target.delegatecall(data);
317         return verifyCallResult(success, returndata, errorMessage);
318     }
319 
320     /**
321      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
322      * revert reason using the provided one.
323      *
324      * _Available since v4.3._
325      */
326     function verifyCallResult(
327         bool success,
328         bytes memory returndata,
329         string memory errorMessage
330     ) internal pure returns (bytes memory) {
331         if (success) {
332             return returndata;
333         } else {
334             // Look for revert reason and bubble it up if present
335             if (returndata.length > 0) {
336                 // The easiest way to bubble the revert reason is using memory via assembly
337 
338                 assembly {
339                     let returndata_size := mload(returndata)
340                     revert(add(32, returndata), returndata_size)
341                 }
342             } else {
343                 revert(errorMessage);
344             }
345         }
346     }
347 }
348 
349 
350 /**
351  * @dev String operations.
352  */
353 library Strings {
354     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
355 
356     /**
357      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
358      */
359     function toString(uint256 value) internal pure returns (string memory) {
360         // Inspired by OraclizeAPI's implementation - MIT licence
361         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
362 
363         if (value == 0) {
364             return "0";
365         }
366         uint256 temp = value;
367         uint256 digits;
368         while (temp != 0) {
369             digits++;
370             temp /= 10;
371         }
372         bytes memory buffer = new bytes(digits);
373         while (value != 0) {
374             digits -= 1;
375             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
376             value /= 10;
377         }
378         return string(buffer);
379     }
380 
381     /**
382      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
383      */
384     function toHexString(uint256 value) internal pure returns (string memory) {
385         if (value == 0) {
386             return "0x00";
387         }
388         uint256 temp = value;
389         uint256 length = 0;
390         while (temp != 0) {
391             length++;
392             temp >>= 8;
393         }
394         return toHexString(value, length);
395     }
396 
397     /**
398      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
399      */
400     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
401         bytes memory buffer = new bytes(2 * length + 2);
402         buffer[0] = "0";
403         buffer[1] = "x";
404         for (uint256 i = 2 * length + 1; i > 1; --i) {
405             buffer[i] = _HEX_SYMBOLS[value & 0xf];
406             value >>= 4;
407         }
408         require(value == 0, "Strings: hex length insufficient");
409         return string(buffer);
410     }
411 }
412 
413 
414 
415 
416 /**
417  * @dev Required interface of an ERC721 compliant contract.
418  */
419 interface IERC721 is IERC165 {
420     /**
421      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
422      */
423     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
424 
425     /**
426      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
427      */
428     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
429 
430     /**
431      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
432      */
433     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
434 
435     /**
436      * @dev Returns the number of tokens in ``owner``'s account.
437      */
438     function balanceOf(address owner) external view returns (uint256 balance);
439 
440     /**
441      * @dev Returns the owner of the `tokenId` token.
442      *
443      * Requirements:
444      *
445      * - `tokenId` must exist.
446      */
447     function ownerOf(uint256 tokenId) external view returns (address owner);
448 
449     /**
450      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
451      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
452      *
453      * Requirements:
454      *
455      * - `from` cannot be the zero address.
456      * - `to` cannot be the zero address.
457      * - `tokenId` token must exist and be owned by `from`.
458      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
459      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
460      *
461      * Emits a {Transfer} event.
462      */
463     function safeTransferFrom(
464         address from,
465         address to,
466         uint256 tokenId
467     ) external;
468 
469     /**
470      * @dev Transfers `tokenId` token from `from` to `to`.
471      *
472      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
473      *
474      * Requirements:
475      *
476      * - `from` cannot be the zero address.
477      * - `to` cannot be the zero address.
478      * - `tokenId` token must be owned by `from`.
479      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
480      *
481      * Emits a {Transfer} event.
482      */
483     function transferFrom(
484         address from,
485         address to,
486         uint256 tokenId
487     ) external;
488 
489     /**
490      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
491      * The approval is cleared when the token is transferred.
492      *
493      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
494      *
495      * Requirements:
496      *
497      * - The caller must own the token or be an approved operator.
498      * - `tokenId` must exist.
499      *
500      * Emits an {Approval} event.
501      */
502     function approve(address to, uint256 tokenId) external;
503 
504     /**
505      * @dev Returns the account approved for `tokenId` token.
506      *
507      * Requirements:
508      *
509      * - `tokenId` must exist.
510      */
511     function getApproved(uint256 tokenId) external view returns (address operator);
512 
513     /**
514      * @dev Approve or remove `operator` as an operator for the caller.
515      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
516      *
517      * Requirements:
518      *
519      * - The `operator` cannot be the caller.
520      *
521      * Emits an {ApprovalForAll} event.
522      */
523     function setApprovalForAll(address operator, bool _approved) external;
524 
525     /**
526      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
527      *
528      * See {setApprovalForAll}
529      */
530     function isApprovedForAll(address owner, address operator) external view returns (bool);
531 
532     /**
533      * @dev Safely transfers `tokenId` token from `from` to `to`.
534      *
535      * Requirements:
536      *
537      * - `from` cannot be the zero address.
538      * - `to` cannot be the zero address.
539      * - `tokenId` token must exist and be owned by `from`.
540      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
541      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
542      *
543      * Emits a {Transfer} event.
544      */
545     function safeTransferFrom(
546         address from,
547         address to,
548         uint256 tokenId,
549         bytes calldata data
550     ) external;
551 }
552 
553 
554 /**
555  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
556  * @dev See https://eips.ethereum.org/EIPS/eip-721
557  */
558 interface IERC721Metadata is IERC721 {
559     /**
560      * @dev Returns the token collection name.
561      */
562     function name() external view returns (string memory);
563 
564     /**
565      * @dev Returns the token collection symbol.
566      */
567     function symbol() external view returns (string memory);
568 
569     /**
570      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
571      */
572     function tokenURI(uint256 tokenId) external view returns (string memory);
573 }
574 
575 
576 /**
577  * @title ERC721 token receiver interface
578  * @dev Interface for any contract that wants to support safeTransfers
579  * from ERC721 asset contracts.
580  */
581 interface IERC721Receiver {
582     /**
583      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
584      * by `operator` from `from`, this function is called.
585      *
586      * It must return its Solidity selector to confirm the token transfer.
587      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
588      *
589      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
590      */
591     function onERC721Received(
592         address operator,
593         address from,
594         uint256 tokenId,
595         bytes calldata data
596     ) external returns (bytes4);
597 }
598 
599 
600 /**
601  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
602  * the Metadata extension, but not including the Enumerable extension, which is available separately as
603  * {ERC721Enumerable}.
604  */
605 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
606     using Address for address;
607     using Strings for uint256;
608 
609     // Token name
610     string private _name;
611 
612     // Token symbol
613     string private _symbol;
614 
615     // Mapping from token ID to owner address
616     mapping(uint256 => address) private _owners;
617 
618     // Mapping owner address to token count
619     mapping(address => uint256) private _balances;
620 
621     // Mapping from token ID to approved address
622     mapping(uint256 => address) private _tokenApprovals;
623 
624     // Mapping from owner to operator approvals
625     mapping(address => mapping(address => bool)) private _operatorApprovals;
626 
627     /**
628      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
629      */
630     constructor(string memory name_, string memory symbol_) {
631         _name = name_;
632         _symbol = symbol_;
633     }
634 
635     /**
636      * @dev See {IERC165-supportsInterface}.
637      */
638     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
639         return
640             interfaceId == type(IERC721).interfaceId ||
641             interfaceId == type(IERC721Metadata).interfaceId ||
642             super.supportsInterface(interfaceId);
643     }
644 
645     /**
646      * @dev See {IERC721-balanceOf}.
647      */
648     function balanceOf(address owner) public view virtual override returns (uint256) {
649         require(owner != address(0), "ERC721: balance query for the zero address");
650         return _balances[owner];
651     }
652 
653     /**
654      * @dev See {IERC721-ownerOf}.
655      */
656     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
657         address owner = _owners[tokenId];
658         require(owner != address(0), "ERC721: owner query for nonexistent token");
659         return owner;
660     }
661 
662     /**
663      * @dev See {IERC721Metadata-name}.
664      */
665     function name() public view virtual override returns (string memory) {
666         return _name;
667     }
668 
669     /**
670      * @dev See {IERC721Metadata-symbol}.
671      */
672     function symbol() public view virtual override returns (string memory) {
673         return _symbol;
674     }
675 
676     /**
677      * @dev See {IERC721Metadata-tokenURI}.
678      */
679     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
680         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
681 
682         string memory baseURI = _baseURI();
683         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
684     }
685 
686     /**
687      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
688      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
689      * by default, can be overriden in child contracts.
690      */
691     function _baseURI() internal view virtual returns (string memory) {
692         return "";
693     }
694 
695     /**
696      * @dev See {IERC721-approve}.
697      */
698     function approve(address to, uint256 tokenId) public virtual override {
699         address owner = ERC721.ownerOf(tokenId);
700         require(to != owner, "ERC721: approval to current owner");
701 
702         require(
703             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
704             "ERC721: approve caller is not owner nor approved for all"
705         );
706 
707         _approve(to, tokenId);
708     }
709 
710     /**
711      * @dev See {IERC721-getApproved}.
712      */
713     function getApproved(uint256 tokenId) public view virtual override returns (address) {
714         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
715 
716         return _tokenApprovals[tokenId];
717     }
718 
719     /**
720      * @dev See {IERC721-setApprovalForAll}.
721      */
722     function setApprovalForAll(address operator, bool approved) public virtual override {
723         require(operator != _msgSender(), "ERC721: approve to caller");
724 
725         _operatorApprovals[_msgSender()][operator] = approved;
726         emit ApprovalForAll(_msgSender(), operator, approved);
727     }
728 
729     /**
730      * @dev See {IERC721-isApprovedForAll}.
731      */
732     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
733         return _operatorApprovals[owner][operator];
734     }
735 
736     /**
737      * @dev See {IERC721-transferFrom}.
738      */
739     function transferFrom(
740         address from,
741         address to,
742         uint256 tokenId
743     ) public virtual override {
744         //solhint-disable-next-line max-line-length
745         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
746 
747         _transfer(from, to, tokenId);
748     }
749 
750     /**
751      * @dev See {IERC721-safeTransferFrom}.
752      */
753     function safeTransferFrom(
754         address from,
755         address to,
756         uint256 tokenId
757     ) public virtual override {
758         safeTransferFrom(from, to, tokenId, "");
759     }
760 
761     /**
762      * @dev See {IERC721-safeTransferFrom}.
763      */
764     function safeTransferFrom(
765         address from,
766         address to,
767         uint256 tokenId,
768         bytes memory _data
769     ) public virtual override {
770         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
771         _safeTransfer(from, to, tokenId, _data);
772     }
773 
774     /**
775      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
776      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
777      *
778      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
779      *
780      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
781      * implement alternative mechanisms to perform token transfer, such as signature-based.
782      *
783      * Requirements:
784      *
785      * - `from` cannot be the zero address.
786      * - `to` cannot be the zero address.
787      * - `tokenId` token must exist and be owned by `from`.
788      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
789      *
790      * Emits a {Transfer} event.
791      */
792     function _safeTransfer(
793         address from,
794         address to,
795         uint256 tokenId,
796         bytes memory _data
797     ) internal virtual {
798         _transfer(from, to, tokenId);
799         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
800     }
801 
802     /**
803      * @dev Returns whether `tokenId` exists.
804      *
805      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
806      *
807      * Tokens start existing when they are minted (`_mint`),
808      * and stop existing when they are burned (`_burn`).
809      */
810     function _exists(uint256 tokenId) internal view virtual returns (bool) {
811         return _owners[tokenId] != address(0);
812     }
813 
814     /**
815      * @dev Returns whether `spender` is allowed to manage `tokenId`.
816      *
817      * Requirements:
818      *
819      * - `tokenId` must exist.
820      */
821     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
822         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
823         address owner = ERC721.ownerOf(tokenId);
824         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
825     }
826 
827     /**
828      * @dev Safely mints `tokenId` and transfers it to `to`.
829      *
830      * Requirements:
831      *
832      * - `tokenId` must not exist.
833      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
834      *
835      * Emits a {Transfer} event.
836      */
837     function _safeMint(address to, uint256 tokenId) internal virtual {
838         _safeMint(to, tokenId, "");
839     }
840 
841     /**
842      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
843      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
844      */
845     function _safeMint(
846         address to,
847         uint256 tokenId,
848         bytes memory _data
849     ) internal virtual {
850         _mint(to, tokenId);
851         require(
852             _checkOnERC721Received(address(0), to, tokenId, _data),
853             "ERC721: transfer to non ERC721Receiver implementer"
854         );
855     }
856 
857     /**
858      * @dev Mints `tokenId` and transfers it to `to`.
859      *
860      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
861      *
862      * Requirements:
863      *
864      * - `tokenId` must not exist.
865      * - `to` cannot be the zero address.
866      *
867      * Emits a {Transfer} event.
868      */
869     function _mint(address to, uint256 tokenId) internal virtual {
870         require(to != address(0), "ERC721: mint to the zero address");
871         require(!_exists(tokenId), "ERC721: token already minted");
872 
873         _beforeTokenTransfer(address(0), to, tokenId);
874 
875         _balances[to] += 1;
876         _owners[tokenId] = to;
877 
878         emit Transfer(address(0), to, tokenId);
879     }
880 
881     /**
882      * @dev Destroys `tokenId`.
883      * The approval is cleared when the token is burned.
884      *
885      * Requirements:
886      *
887      * - `tokenId` must exist.
888      *
889      * Emits a {Transfer} event.
890      */
891     function _burn(uint256 tokenId) internal virtual {
892         address owner = ERC721.ownerOf(tokenId);
893 
894         _beforeTokenTransfer(owner, address(0), tokenId);
895 
896         // Clear approvals
897         _approve(address(0), tokenId);
898 
899         _balances[owner] -= 1;
900         delete _owners[tokenId];
901 
902         emit Transfer(owner, address(0), tokenId);
903     }
904 
905     /**
906      * @dev Transfers `tokenId` from `from` to `to`.
907      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
908      *
909      * Requirements:
910      *
911      * - `to` cannot be the zero address.
912      * - `tokenId` token must be owned by `from`.
913      *
914      * Emits a {Transfer} event.
915      */
916     function _transfer(
917         address from,
918         address to,
919         uint256 tokenId
920     ) internal virtual {
921         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
922         require(to != address(0), "ERC721: transfer to the zero address");
923 
924         _beforeTokenTransfer(from, to, tokenId);
925 
926         // Clear approvals from the previous owner
927         _approve(address(0), tokenId);
928 
929         _balances[from] -= 1;
930         _balances[to] += 1;
931         _owners[tokenId] = to;
932 
933         emit Transfer(from, to, tokenId);
934     }
935 
936     /**
937      * @dev Approve `to` to operate on `tokenId`
938      *
939      * Emits a {Approval} event.
940      */
941     function _approve(address to, uint256 tokenId) internal virtual {
942         _tokenApprovals[tokenId] = to;
943         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
944     }
945 
946     /**
947      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
948      * The call is not executed if the target address is not a contract.
949      *
950      * @param from address representing the previous owner of the given token ID
951      * @param to target address that will receive the tokens
952      * @param tokenId uint256 ID of the token to be transferred
953      * @param _data bytes optional data to send along with the call
954      * @return bool whether the call correctly returned the expected magic value
955      */
956     function _checkOnERC721Received(
957         address from,
958         address to,
959         uint256 tokenId,
960         bytes memory _data
961     ) private returns (bool) {
962         if (to.isContract()) {
963             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
964                 return retval == IERC721Receiver.onERC721Received.selector;
965             } catch (bytes memory reason) {
966                 if (reason.length == 0) {
967                     revert("ERC721: transfer to non ERC721Receiver implementer");
968                 } else {
969                     assembly {
970                         revert(add(32, reason), mload(reason))
971                     }
972                 }
973             }
974         } else {
975             return true;
976         }
977     }
978 
979     /**
980      * @dev Hook that is called before any token transfer. This includes minting
981      * and burning.
982      *
983      * Calling conditions:
984      *
985      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
986      * transferred to `to`.
987      * - When `from` is zero, `tokenId` will be minted for `to`.
988      * - When `to` is zero, ``from``'s `tokenId` will be burned.
989      * - `from` and `to` are never both zero.
990      *
991      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
992      */
993     function _beforeTokenTransfer(
994         address from,
995         address to,
996         uint256 tokenId
997     ) internal virtual {}
998 }
999 
1000 /**
1001  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1002  * @dev See https://eips.ethereum.org/EIPS/eip-721
1003  */
1004 interface IERC721Enumerable is IERC721 {
1005     /**
1006      * @dev Returns the total amount of tokens stored by the contract.
1007      */
1008     function totalSupply() external view returns (uint256);
1009 
1010     /**
1011      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1012      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1013      */
1014     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1015 
1016     /**
1017      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1018      * Use along with {totalSupply} to enumerate all tokens.
1019      */
1020     function tokenByIndex(uint256 index) external view returns (uint256);
1021 }
1022 
1023 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1024     // Mapping from owner to list of owned token IDs
1025     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1026 
1027     // Mapping from token ID to index of the owner tokens list
1028     mapping(uint256 => uint256) private _ownedTokensIndex;
1029 
1030     // Array with all token ids, used for enumeration
1031     uint256[] private _allTokens;
1032 
1033     // Mapping from token id to position in the allTokens array
1034     mapping(uint256 => uint256) private _allTokensIndex;
1035 
1036     /**
1037      * @dev See {IERC165-supportsInterface}.
1038      */
1039     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1040         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1041     }
1042 
1043     /**
1044      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1045      */
1046     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1047         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1048         return _ownedTokens[owner][index];
1049     }
1050 
1051     /**
1052      * @dev See {IERC721Enumerable-totalSupply}.
1053      */
1054     function totalSupply() public view virtual override returns (uint256) {
1055         return _allTokens.length;
1056     }
1057 
1058     /**
1059      * @dev See {IERC721Enumerable-tokenByIndex}.
1060      */
1061     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1062         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1063         return _allTokens[index];
1064     }
1065 
1066     /**
1067      * @dev Hook that is called before any token transfer. This includes minting
1068      * and burning.
1069      *
1070      * Calling conditions:
1071      *
1072      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1073      * transferred to `to`.
1074      * - When `from` is zero, `tokenId` will be minted for `to`.
1075      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1076      * - `from` cannot be the zero address.
1077      * - `to` cannot be the zero address.
1078      *
1079      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1080      */
1081     function _beforeTokenTransfer(
1082         address from,
1083         address to,
1084         uint256 tokenId
1085     ) internal virtual override {
1086         super._beforeTokenTransfer(from, to, tokenId);
1087 
1088         if (from == address(0)) {
1089             _addTokenToAllTokensEnumeration(tokenId);
1090         } else if (from != to) {
1091             _removeTokenFromOwnerEnumeration(from, tokenId);
1092         }
1093         if (to == address(0)) {
1094             _removeTokenFromAllTokensEnumeration(tokenId);
1095         } else if (to != from) {
1096             _addTokenToOwnerEnumeration(to, tokenId);
1097         }
1098     }
1099 
1100     /**
1101      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1102      * @param to address representing the new owner of the given token ID
1103      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1104      */
1105     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1106         uint256 length = ERC721.balanceOf(to);
1107         _ownedTokens[to][length] = tokenId;
1108         _ownedTokensIndex[tokenId] = length;
1109     }
1110 
1111     /**
1112      * @dev Private function to add a token to this extension's token tracking data structures.
1113      * @param tokenId uint256 ID of the token to be added to the tokens list
1114      */
1115     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1116         _allTokensIndex[tokenId] = _allTokens.length;
1117         _allTokens.push(tokenId);
1118     }
1119 
1120     /**
1121      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1122      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1123      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1124      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1125      * @param from address representing the previous owner of the given token ID
1126      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1127      */
1128     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1129         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1130         // then delete the last slot (swap and pop).
1131 
1132         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1133         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1134 
1135         // When the token to delete is the last token, the swap operation is unnecessary
1136         if (tokenIndex != lastTokenIndex) {
1137             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1138 
1139             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1140             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1141         }
1142 
1143         // This also deletes the contents at the last position of the array
1144         delete _ownedTokensIndex[tokenId];
1145         delete _ownedTokens[from][lastTokenIndex];
1146     }
1147 
1148     /**
1149      * @dev Private function to remove a token from this extension's token tracking data structures.
1150      * This has O(1) time complexity, but alters the order of the _allTokens array.
1151      * @param tokenId uint256 ID of the token to be removed from the tokens list
1152      */
1153     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1154         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1155         // then delete the last slot (swap and pop).
1156 
1157         uint256 lastTokenIndex = _allTokens.length - 1;
1158         uint256 tokenIndex = _allTokensIndex[tokenId];
1159 
1160         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1161         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1162         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1163         uint256 lastTokenId = _allTokens[lastTokenIndex];
1164 
1165         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1166         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1167 
1168         // This also deletes the contents at the last position of the array
1169         delete _allTokensIndex[tokenId];
1170         _allTokens.pop();
1171     }
1172 }
1173 
1174 interface iFont {
1175     function fontBase64() external view returns (string memory);
1176 }
1177 
1178 interface iMTM {
1179     function getTransponderStatus(uint tokenId_) external view returns (bool);
1180 }
1181 
1182 contract Transponders is ERC721Enumerable, Ownable {
1183 
1184     address public mtmAddress;
1185     address public fontAddress;
1186     
1187     event Mint(address to, uint tokenId);
1188     
1189     constructor() ERC721("Transponders", "TRANSPONDER") {}
1190 
1191     function fontBase64() internal view returns (string memory) {
1192         return iFont(fontAddress).fontBase64();
1193     }
1194 
1195     modifier onlyMinter() {
1196         require(msg.sender == mtmAddress, "You are not the chosen one!");
1197         _;
1198     }
1199     
1200     function setFontAddress(address address_) external onlyOwner {
1201         fontAddress = address_;
1202     }
1203     function setMTMAddress(address address_) external onlyOwner {
1204         mtmAddress = address_;
1205     }
1206     
1207     function mintTransponder(address to_, uint tokenId_) public onlyMinter {
1208         emit Mint(to_, tokenId_);
1209         _mint(to_, tokenId_);
1210     }
1211 
1212     // function testMintMany(uint amount_) public {
1213     //     for (uint i = 0; i < amount_; i++) {
1214     //         emit Mint(msg.sender, totalSupply());
1215     //         _mint(msg.sender, totalSupply());
1216     //     }
1217     // }
1218 
1219     function getTransponderStatus(uint tokenId_) public view returns (string memory) {
1220         bool _transponderIsNew = iMTM(mtmAddress).getTransponderStatus(tokenId_);
1221         if (_transponderIsNew) {
1222             return "New";
1223         }
1224         return "Used";
1225     }
1226 
1227     // heres the metadata delivery stuff
1228     string public tokenName = "Transponder";
1229     string public tokenDescription = "Transponders are tools used to send sattelite signals to the Martians. They are used to write into the Message to Martians. Available through https://messagetomartians.com";
1230     string public tokenExternalUrl = "https://messagetomartians.com";
1231 
1232     function setTokenName(string memory tokenName_) external onlyOwner {
1233         tokenName = tokenName_;
1234     }
1235     function setTokenDescription(string memory tokenDescription_) external onlyOwner {
1236         tokenDescription = tokenDescription_;
1237     }
1238     function setTokenExternalUrl(string memory tokenExternalUrl_) external onlyOwner {
1239         tokenExternalUrl = tokenExternalUrl_;
1240     }
1241 
1242     function tokenURI(uint tokenId_) public view override returns (string memory) {
1243         string memory _header = string(abi.encodePacked('data:application/json;utf8, '));
1244         string memory _name = string(abi.encodePacked('{"name": "', tokenName, ' #', Strings.toString(tokenId_), '",'));
1245         string memory _image = string(abi.encodePacked('"image":', '"data:image/svg+xml;utf8, ', "<svg xmlns='http://www.w3.org/2000/svg' width='500' height='500' style='background-color:#000000'><style>@font-face{font-family:'Minecraft'; src:url('data:application/octet-stream;base64,", fontBase64() ,"');</style><text fill='#ffffff' font-family='Minecraft' x='50%' y='50%' dominant-baseline='middle' text-anchor='middle' font-size='32px'>", tokenName, ' (', getTransponderStatus(tokenId_), ')','</text></svg>",'));
1246         string memory _external_url = string(abi.encodePacked('"external_url": "', tokenExternalUrl ,'",'));
1247         string memory _description = string(abi.encodePacked('"description": "', tokenDescription ,'",'));
1248         string memory _attributes = string(abi.encodePacked('"attributes":[{"trait_type": "transponder status", "value": "', getTransponderStatus(tokenId_), '"}]}'));
1249         string memory _metadata = string(abi.encodePacked(_header, _name, _image, _external_url, _description, _attributes));
1250         return _metadata;
1251     }
1252 
1253     function getTokensOfAddress(address address_) public view returns (uint[] memory) {
1254         uint _tokenBalance = balanceOf(address_);
1255         uint[] memory _tokenIds = new uint[](_tokenBalance);
1256         for (uint i = 0; i < _tokenBalance; i++) {
1257             _tokenIds[i] = tokenOfOwnerByIndex(address_, i);
1258         }
1259         return _tokenIds;
1260     }
1261 }