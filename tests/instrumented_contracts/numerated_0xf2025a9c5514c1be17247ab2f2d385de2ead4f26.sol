1 // SPDX-License-Identifier: MIT
2 // written by 0xInuarashi || https://twitter.com/0xInuarashi || Inuarashi#1234 (Discord)
3 pragma solidity ^0.8.0;
4 
5 // ability to future-switch between transfer hook yield vs claim loop yield
6 
7 /**
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes calldata) {
23         return msg.data;
24     }
25 }
26 
27 
28 /**
29  * @dev Contract module which provides a basic access control mechanism, where
30  * there is an account (an owner) that can be granted exclusive access to
31  * specific functions.
32  *
33  * By default, the owner account will be the one that deploys the contract. This
34  * can later be changed with {transferOwnership}.
35  *
36  * This module is used through inheritance. It will make available the modifier
37  * `onlyOwner`, which can be applied to your functions to restrict their use to
38  * the owner.
39  */
40 abstract contract Ownable is Context {
41     address private _owner;
42 
43     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
44 
45     /**
46      * @dev Initializes the contract setting the deployer as the initial owner.
47      */
48     constructor() {
49         _setOwner(_msgSender());
50     }
51 
52     /**
53      * @dev Returns the address of the current owner.
54      */
55     function owner() public view virtual returns (address) {
56         return _owner;
57     }
58 
59     /**
60      * @dev Throws if called by any account other than the owner.
61      */
62     modifier onlyOwner() {
63         require(owner() == _msgSender(), "Ownable: caller is not the owner");
64         _;
65     }
66 
67     /**
68      * @dev Leaves the contract without owner. It will not be possible to call
69      * `onlyOwner` functions anymore. Can only be called by the current owner.
70      *
71      * NOTE: Renouncing ownership will leave the contract without an owner,
72      * thereby removing any functionality that is only available to the owner.
73      */
74     function renounceOwnership() public virtual onlyOwner {
75         _setOwner(address(0));
76     }
77 
78     /**
79      * @dev Transfers ownership of the contract to a new account (`newOwner`).
80      * Can only be called by the current owner.
81      */
82     function transferOwnership(address newOwner) public virtual onlyOwner {
83         require(newOwner != address(0), "Ownable: new owner is the zero address");
84         _setOwner(newOwner);
85     }
86 
87     function _setOwner(address newOwner) private {
88         address oldOwner = _owner;
89         _owner = newOwner;
90         emit OwnershipTransferred(oldOwner, newOwner);
91     }
92 }
93 
94 /**
95  * @dev Interface of the ERC165 standard, as defined in the
96  * https://eips.ethereum.org/EIPS/eip-165[EIP].
97  *
98  * Implementers can declare support of contract interfaces, which can then be
99  * queried by others ({ERC165Checker}).
100  *
101  * For an implementation, see {ERC165}.
102  */
103 interface IERC165 {
104     /**
105      * @dev Returns true if this contract implements the interface defined by
106      * `interfaceId`. See the corresponding
107      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
108      * to learn more about how these ids are created.
109      *
110      * This function call must use less than 30 000 gas.
111      */
112     function supportsInterface(bytes4 interfaceId) external view returns (bool);
113 }
114 
115 /**
116  * @dev Implementation of the {IERC165} interface.
117  *
118  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
119  * for the additional interface id that will be supported. For example:
120  *
121  * ```solidity
122  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
123  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
124  * }
125  * ```
126  *
127  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
128  */
129 abstract contract ERC165 is IERC165 {
130     /**
131      * @dev See {IERC165-supportsInterface}.
132      */
133     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
134         return interfaceId == type(IERC165).interfaceId;
135     }
136 }
137 
138 
139 /**
140  * @dev Collection of functions related to the address type
141  */
142 library Address {
143     /**
144      * @dev Returns true if `account` is a contract.
145      *
146      * [IMPORTANT]
147      * ====
148      * It is unsafe to assume that an address for which this function returns
149      * false is an externally-owned account (EOA) and not a contract.
150      *
151      * Among others, `isContract` will return false for the following
152      * types of addresses:
153      *
154      *  - an externally-owned account
155      *  - a contract in construction
156      *  - an address where a contract will be created
157      *  - an address where a contract lived, but was destroyed
158      * ====
159      */
160     function isContract(address account) internal view returns (bool) {
161         // This method relies on extcodesize, which returns 0 for contracts in
162         // construction, since the code is only stored at the end of the
163         // constructor execution.
164 
165         uint256 size;
166         assembly {
167             size := extcodesize(account)
168         }
169         return size > 0;
170     }
171 
172     /**
173      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
174      * `recipient`, forwarding all available gas and reverting on errors.
175      *
176      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
177      * of certain opcodes, possibly making contracts go over the 2300 gas limit
178      * imposed by `transfer`, making them unable to receive funds via
179      * `transfer`. {sendValue} removes this limitation.
180      *
181      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
182      *
183      * IMPORTANT: because control is transferred to `recipient`, care must be
184      * taken to not create reentrancy vulnerabilities. Consider using
185      * {ReentrancyGuard} or the
186      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
187      */
188     function sendValue(address payable recipient, uint256 amount) internal {
189         require(address(this).balance >= amount, "Address: insufficient balance");
190 
191         (bool success, ) = recipient.call{value: amount}("");
192         require(success, "Address: unable to send value, recipient may have reverted");
193     }
194 
195     /**
196      * @dev Performs a Solidity function call using a low level `call`. A
197      * plain `call` is an unsafe replacement for a function call: use this
198      * function instead.
199      *
200      * If `target` reverts with a revert reason, it is bubbled up by this
201      * function (like regular Solidity function calls).
202      *
203      * Returns the raw returned data. To convert to the expected return value,
204      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
205      *
206      * Requirements:
207      *
208      * - `target` must be a contract.
209      * - calling `target` with `data` must not revert.
210      *
211      * _Available since v3.1._
212      */
213     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
214         return functionCall(target, data, "Address: low-level call failed");
215     }
216 
217     /**
218      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
219      * `errorMessage` as a fallback revert reason when `target` reverts.
220      *
221      * _Available since v3.1._
222      */
223     function functionCall(
224         address target,
225         bytes memory data,
226         string memory errorMessage
227     ) internal returns (bytes memory) {
228         return functionCallWithValue(target, data, 0, errorMessage);
229     }
230 
231     /**
232      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
233      * but also transferring `value` wei to `target`.
234      *
235      * Requirements:
236      *
237      * - the calling contract must have an ETH balance of at least `value`.
238      * - the called Solidity function must be `payable`.
239      *
240      * _Available since v3.1._
241      */
242     function functionCallWithValue(
243         address target,
244         bytes memory data,
245         uint256 value
246     ) internal returns (bytes memory) {
247         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
248     }
249 
250     /**
251      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
252      * with `errorMessage` as a fallback revert reason when `target` reverts.
253      *
254      * _Available since v3.1._
255      */
256     function functionCallWithValue(
257         address target,
258         bytes memory data,
259         uint256 value,
260         string memory errorMessage
261     ) internal returns (bytes memory) {
262         require(address(this).balance >= value, "Address: insufficient balance for call");
263         require(isContract(target), "Address: call to non-contract");
264 
265         (bool success, bytes memory returndata) = target.call{value: value}(data);
266         return verifyCallResult(success, returndata, errorMessage);
267     }
268 
269     /**
270      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
271      * but performing a static call.
272      *
273      * _Available since v3.3._
274      */
275     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
276         return functionStaticCall(target, data, "Address: low-level static call failed");
277     }
278 
279     /**
280      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
281      * but performing a static call.
282      *
283      * _Available since v3.3._
284      */
285     function functionStaticCall(
286         address target,
287         bytes memory data,
288         string memory errorMessage
289     ) internal view returns (bytes memory) {
290         require(isContract(target), "Address: static call to non-contract");
291 
292         (bool success, bytes memory returndata) = target.staticcall(data);
293         return verifyCallResult(success, returndata, errorMessage);
294     }
295 
296     /**
297      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
298      * but performing a delegate call.
299      *
300      * _Available since v3.4._
301      */
302     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
303         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
304     }
305 
306     /**
307      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
308      * but performing a delegate call.
309      *
310      * _Available since v3.4._
311      */
312     function functionDelegateCall(
313         address target,
314         bytes memory data,
315         string memory errorMessage
316     ) internal returns (bytes memory) {
317         require(isContract(target), "Address: delegate call to non-contract");
318 
319         (bool success, bytes memory returndata) = target.delegatecall(data);
320         return verifyCallResult(success, returndata, errorMessage);
321     }
322 
323     /**
324      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
325      * revert reason using the provided one.
326      *
327      * _Available since v4.3._
328      */
329     function verifyCallResult(
330         bool success,
331         bytes memory returndata,
332         string memory errorMessage
333     ) internal pure returns (bytes memory) {
334         if (success) {
335             return returndata;
336         } else {
337             // Look for revert reason and bubble it up if present
338             if (returndata.length > 0) {
339                 // The easiest way to bubble the revert reason is using memory via assembly
340 
341                 assembly {
342                     let returndata_size := mload(returndata)
343                     revert(add(32, returndata), returndata_size)
344                 }
345             } else {
346                 revert(errorMessage);
347             }
348         }
349     }
350 }
351 
352 
353 /**
354  * @dev String operations.
355  */
356 library Strings {
357     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
358 
359     /**
360      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
361      */
362     function toString(uint256 value) internal pure returns (string memory) {
363         // Inspired by OraclizeAPI's implementation - MIT licence
364         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
365 
366         if (value == 0) {
367             return "0";
368         }
369         uint256 temp = value;
370         uint256 digits;
371         while (temp != 0) {
372             digits++;
373             temp /= 10;
374         }
375         bytes memory buffer = new bytes(digits);
376         while (value != 0) {
377             digits -= 1;
378             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
379             value /= 10;
380         }
381         return string(buffer);
382     }
383 
384     /**
385      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
386      */
387     function toHexString(uint256 value) internal pure returns (string memory) {
388         if (value == 0) {
389             return "0x00";
390         }
391         uint256 temp = value;
392         uint256 length = 0;
393         while (temp != 0) {
394             length++;
395             temp >>= 8;
396         }
397         return toHexString(value, length);
398     }
399 
400     /**
401      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
402      */
403     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
404         bytes memory buffer = new bytes(2 * length + 2);
405         buffer[0] = "0";
406         buffer[1] = "x";
407         for (uint256 i = 2 * length + 1; i > 1; --i) {
408             buffer[i] = _HEX_SYMBOLS[value & 0xf];
409             value >>= 4;
410         }
411         require(value == 0, "Strings: hex length insufficient");
412         return string(buffer);
413     }
414 }
415 
416 
417 
418 
419 /**
420  * @dev Required interface of an ERC721 compliant contract.
421  */
422 interface IERC721 is IERC165 {
423     /**
424      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
425      */
426     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
427 
428     /**
429      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
430      */
431     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
432 
433     /**
434      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
435      */
436     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
437 
438     /**
439      * @dev Returns the number of tokens in ``owner``'s account.
440      */
441     function balanceOf(address owner) external view returns (uint256 balance);
442 
443     /**
444      * @dev Returns the owner of the `tokenId` token.
445      *
446      * Requirements:
447      *
448      * - `tokenId` must exist.
449      */
450     function ownerOf(uint256 tokenId) external view returns (address owner);
451 
452     /**
453      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
454      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
455      *
456      * Requirements:
457      *
458      * - `from` cannot be the zero address.
459      * - `to` cannot be the zero address.
460      * - `tokenId` token must exist and be owned by `from`.
461      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
462      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
463      *
464      * Emits a {Transfer} event.
465      */
466     function safeTransferFrom(
467         address from,
468         address to,
469         uint256 tokenId
470     ) external;
471 
472     /**
473      * @dev Transfers `tokenId` token from `from` to `to`.
474      *
475      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
476      *
477      * Requirements:
478      *
479      * - `from` cannot be the zero address.
480      * - `to` cannot be the zero address.
481      * - `tokenId` token must be owned by `from`.
482      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
483      *
484      * Emits a {Transfer} event.
485      */
486     function transferFrom(
487         address from,
488         address to,
489         uint256 tokenId
490     ) external;
491 
492     /**
493      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
494      * The approval is cleared when the token is transferred.
495      *
496      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
497      *
498      * Requirements:
499      *
500      * - The caller must own the token or be an approved operator.
501      * - `tokenId` must exist.
502      *
503      * Emits an {Approval} event.
504      */
505     function approve(address to, uint256 tokenId) external;
506 
507     /**
508      * @dev Returns the account approved for `tokenId` token.
509      *
510      * Requirements:
511      *
512      * - `tokenId` must exist.
513      */
514     function getApproved(uint256 tokenId) external view returns (address operator);
515 
516     /**
517      * @dev Approve or remove `operator` as an operator for the caller.
518      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
519      *
520      * Requirements:
521      *
522      * - The `operator` cannot be the caller.
523      *
524      * Emits an {ApprovalForAll} event.
525      */
526     function setApprovalForAll(address operator, bool _approved) external;
527 
528     /**
529      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
530      *
531      * See {setApprovalForAll}
532      */
533     function isApprovedForAll(address owner, address operator) external view returns (bool);
534 
535     /**
536      * @dev Safely transfers `tokenId` token from `from` to `to`.
537      *
538      * Requirements:
539      *
540      * - `from` cannot be the zero address.
541      * - `to` cannot be the zero address.
542      * - `tokenId` token must exist and be owned by `from`.
543      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
544      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
545      *
546      * Emits a {Transfer} event.
547      */
548     function safeTransferFrom(
549         address from,
550         address to,
551         uint256 tokenId,
552         bytes calldata data
553     ) external;
554 }
555 
556 
557 /**
558  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
559  * @dev See https://eips.ethereum.org/EIPS/eip-721
560  */
561 interface IERC721Metadata is IERC721 {
562     /**
563      * @dev Returns the token collection name.
564      */
565     function name() external view returns (string memory);
566 
567     /**
568      * @dev Returns the token collection symbol.
569      */
570     function symbol() external view returns (string memory);
571 
572     /**
573      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
574      */
575     function tokenURI(uint256 tokenId) external view returns (string memory);
576 }
577 
578 
579 /**
580  * @title ERC721 token receiver interface
581  * @dev Interface for any contract that wants to support safeTransfers
582  * from ERC721 asset contracts.
583  */
584 interface IERC721Receiver {
585     /**
586      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
587      * by `operator` from `from`, this function is called.
588      *
589      * It must return its Solidity selector to confirm the token transfer.
590      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
591      *
592      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
593      */
594     function onERC721Received(
595         address operator,
596         address from,
597         uint256 tokenId,
598         bytes calldata data
599     ) external returns (bytes4);
600 }
601 
602 
603 /**
604  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
605  * the Metadata extension, but not including the Enumerable extension, which is available separately as
606  * {ERC721Enumerable}.
607  */
608 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
609     using Address for address;
610     using Strings for uint256;
611 
612     // Token name
613     string private _name;
614 
615     // Token symbol
616     string private _symbol;
617 
618     // Mapping from token ID to owner address
619     mapping(uint256 => address) private _owners;
620 
621     // Mapping owner address to token count
622     mapping(address => uint256) private _balances;
623 
624     // Mapping from token ID to approved address
625     mapping(uint256 => address) private _tokenApprovals;
626 
627     // Mapping from owner to operator approvals
628     mapping(address => mapping(address => bool)) private _operatorApprovals;
629 
630     /**
631      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
632      */
633     constructor(string memory name_, string memory symbol_) {
634         _name = name_;
635         _symbol = symbol_;
636     }
637 
638     /**
639      * @dev See {IERC165-supportsInterface}.
640      */
641     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
642         return
643             interfaceId == type(IERC721).interfaceId ||
644             interfaceId == type(IERC721Metadata).interfaceId ||
645             super.supportsInterface(interfaceId);
646     }
647 
648     /**
649      * @dev See {IERC721-balanceOf}.
650      */
651     function balanceOf(address owner) public view virtual override returns (uint256) {
652         require(owner != address(0), "ERC721: balance query for the zero address");
653         return _balances[owner];
654     }
655 
656     /**
657      * @dev See {IERC721-ownerOf}.
658      */
659     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
660         address owner = _owners[tokenId];
661         require(owner != address(0), "ERC721: owner query for nonexistent token");
662         return owner;
663     }
664 
665     /**
666      * @dev See {IERC721Metadata-name}.
667      */
668     function name() public view virtual override returns (string memory) {
669         return _name;
670     }
671 
672     /**
673      * @dev See {IERC721Metadata-symbol}.
674      */
675     function symbol() public view virtual override returns (string memory) {
676         return _symbol;
677     }
678 
679     /**
680      * @dev See {IERC721Metadata-tokenURI}.
681      */
682     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
683         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
684 
685         string memory baseURI = _baseURI();
686         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
687     }
688 
689     /**
690      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
691      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
692      * by default, can be overriden in child contracts.
693      */
694     function _baseURI() internal view virtual returns (string memory) {
695         return "";
696     }
697 
698     /**
699      * @dev See {IERC721-approve}.
700      */
701     function approve(address to, uint256 tokenId) public virtual override {
702         address owner = ERC721.ownerOf(tokenId);
703         require(to != owner, "ERC721: approval to current owner");
704 
705         require(
706             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
707             "ERC721: approve caller is not owner nor approved for all"
708         );
709 
710         _approve(to, tokenId);
711     }
712 
713     /**
714      * @dev See {IERC721-getApproved}.
715      */
716     function getApproved(uint256 tokenId) public view virtual override returns (address) {
717         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
718 
719         return _tokenApprovals[tokenId];
720     }
721 
722     /**
723      * @dev See {IERC721-setApprovalForAll}.
724      */
725     function setApprovalForAll(address operator, bool approved) public virtual override {
726         require(operator != _msgSender(), "ERC721: approve to caller");
727 
728         _operatorApprovals[_msgSender()][operator] = approved;
729         emit ApprovalForAll(_msgSender(), operator, approved);
730     }
731 
732     /**
733      * @dev See {IERC721-isApprovedForAll}.
734      */
735     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
736         return _operatorApprovals[owner][operator];
737     }
738 
739     /**
740      * @dev See {IERC721-transferFrom}.
741      */
742     function transferFrom(
743         address from,
744         address to,
745         uint256 tokenId
746     ) public virtual override {
747         //solhint-disable-next-line max-line-length
748         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
749 
750         _transfer(from, to, tokenId);
751     }
752 
753     /**
754      * @dev See {IERC721-safeTransferFrom}.
755      */
756     function safeTransferFrom(
757         address from,
758         address to,
759         uint256 tokenId
760     ) public virtual override {
761         safeTransferFrom(from, to, tokenId, "");
762     }
763 
764     /**
765      * @dev See {IERC721-safeTransferFrom}.
766      */
767     function safeTransferFrom(
768         address from,
769         address to,
770         uint256 tokenId,
771         bytes memory _data
772     ) public virtual override {
773         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
774         _safeTransfer(from, to, tokenId, _data);
775     }
776 
777     /**
778      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
779      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
780      *
781      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
782      *
783      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
784      * implement alternative mechanisms to perform token transfer, such as signature-based.
785      *
786      * Requirements:
787      *
788      * - `from` cannot be the zero address.
789      * - `to` cannot be the zero address.
790      * - `tokenId` token must exist and be owned by `from`.
791      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
792      *
793      * Emits a {Transfer} event.
794      */
795     function _safeTransfer(
796         address from,
797         address to,
798         uint256 tokenId,
799         bytes memory _data
800     ) internal virtual {
801         _transfer(from, to, tokenId);
802         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
803     }
804 
805     /**
806      * @dev Returns whether `tokenId` exists.
807      *
808      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
809      *
810      * Tokens start existing when they are minted (`_mint`),
811      * and stop existing when they are burned (`_burn`).
812      */
813     function _exists(uint256 tokenId) internal view virtual returns (bool) {
814         return _owners[tokenId] != address(0);
815     }
816 
817     /**
818      * @dev Returns whether `spender` is allowed to manage `tokenId`.
819      *
820      * Requirements:
821      *
822      * - `tokenId` must exist.
823      */
824     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
825         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
826         address owner = ERC721.ownerOf(tokenId);
827         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
828     }
829 
830     /**
831      * @dev Safely mints `tokenId` and transfers it to `to`.
832      *
833      * Requirements:
834      *
835      * - `tokenId` must not exist.
836      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
837      *
838      * Emits a {Transfer} event.
839      */
840     function _safeMint(address to, uint256 tokenId) internal virtual {
841         _safeMint(to, tokenId, "");
842     }
843 
844     /**
845      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
846      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
847      */
848     function _safeMint(
849         address to,
850         uint256 tokenId,
851         bytes memory _data
852     ) internal virtual {
853         _mint(to, tokenId);
854         require(
855             _checkOnERC721Received(address(0), to, tokenId, _data),
856             "ERC721: transfer to non ERC721Receiver implementer"
857         );
858     }
859 
860     /**
861      * @dev Mints `tokenId` and transfers it to `to`.
862      *
863      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
864      *
865      * Requirements:
866      *
867      * - `tokenId` must not exist.
868      * - `to` cannot be the zero address.
869      *
870      * Emits a {Transfer} event.
871      */
872     function _mint(address to, uint256 tokenId) internal virtual {
873         require(to != address(0), "ERC721: mint to the zero address");
874         require(!_exists(tokenId), "ERC721: token already minted");
875 
876         _beforeTokenTransfer(address(0), to, tokenId);
877 
878         _balances[to] += 1;
879         _owners[tokenId] = to;
880 
881         emit Transfer(address(0), to, tokenId);
882     }
883 
884     /**
885      * @dev Destroys `tokenId`.
886      * The approval is cleared when the token is burned.
887      *
888      * Requirements:
889      *
890      * - `tokenId` must exist.
891      *
892      * Emits a {Transfer} event.
893      */
894     function _burn(uint256 tokenId) internal virtual {
895         address owner = ERC721.ownerOf(tokenId);
896 
897         _beforeTokenTransfer(owner, address(0), tokenId);
898 
899         // Clear approvals
900         _approve(address(0), tokenId);
901 
902         _balances[owner] -= 1;
903         delete _owners[tokenId];
904 
905         emit Transfer(owner, address(0), tokenId);
906     }
907 
908     /**
909      * @dev Transfers `tokenId` from `from` to `to`.
910      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
911      *
912      * Requirements:
913      *
914      * - `to` cannot be the zero address.
915      * - `tokenId` token must be owned by `from`.
916      *
917      * Emits a {Transfer} event.
918      */
919     function _transfer(
920         address from,
921         address to,
922         uint256 tokenId
923     ) internal virtual {
924         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
925         require(to != address(0), "ERC721: transfer to the zero address");
926 
927         _beforeTokenTransfer(from, to, tokenId);
928 
929         // Clear approvals from the previous owner
930         _approve(address(0), tokenId);
931 
932         _balances[from] -= 1;
933         _balances[to] += 1;
934         _owners[tokenId] = to;
935 
936         emit Transfer(from, to, tokenId);
937     }
938 
939     /**
940      * @dev Approve `to` to operate on `tokenId`
941      *
942      * Emits a {Approval} event.
943      */
944     function _approve(address to, uint256 tokenId) internal virtual {
945         _tokenApprovals[tokenId] = to;
946         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
947     }
948 
949     /**
950      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
951      * The call is not executed if the target address is not a contract.
952      *
953      * @param from address representing the previous owner of the given token ID
954      * @param to target address that will receive the tokens
955      * @param tokenId uint256 ID of the token to be transferred
956      * @param _data bytes optional data to send along with the call
957      * @return bool whether the call correctly returned the expected magic value
958      */
959     function _checkOnERC721Received(
960         address from,
961         address to,
962         uint256 tokenId,
963         bytes memory _data
964     ) private returns (bool) {
965         if (to.isContract()) {
966             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
967                 return retval == IERC721Receiver.onERC721Received.selector;
968             } catch (bytes memory reason) {
969                 if (reason.length == 0) {
970                     revert("ERC721: transfer to non ERC721Receiver implementer");
971                 } else {
972                     assembly {
973                         revert(add(32, reason), mload(reason))
974                     }
975                 }
976             }
977         } else {
978             return true;
979         }
980     }
981 
982     /**
983      * @dev Hook that is called before any token transfer. This includes minting
984      * and burning.
985      *
986      * Calling conditions:
987      *
988      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
989      * transferred to `to`.
990      * - When `from` is zero, `tokenId` will be minted for `to`.
991      * - When `to` is zero, ``from``'s `tokenId` will be burned.
992      * - `from` and `to` are never both zero.
993      *
994      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
995      */
996     function _beforeTokenTransfer(
997         address from,
998         address to,
999         uint256 tokenId
1000     ) internal virtual {}
1001 }
1002 
1003 /**
1004  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1005  * @dev See https://eips.ethereum.org/EIPS/eip-721
1006  */
1007 interface IERC721Enumerable is IERC721 {
1008     /**
1009      * @dev Returns the total amount of tokens stored by the contract.
1010      */
1011     function totalSupply() external view returns (uint256);
1012 
1013     /**
1014      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1015      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1016      */
1017     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1018 
1019     /**
1020      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1021      * Use along with {totalSupply} to enumerate all tokens.
1022      */
1023     function tokenByIndex(uint256 index) external view returns (uint256);
1024 }
1025 
1026 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1027     // Mapping from owner to list of owned token IDs
1028     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1029 
1030     // Mapping from token ID to index of the owner tokens list
1031     mapping(uint256 => uint256) private _ownedTokensIndex;
1032 
1033     // Array with all token ids, used for enumeration
1034     uint256[] private _allTokens;
1035 
1036     // Mapping from token id to position in the allTokens array
1037     mapping(uint256 => uint256) private _allTokensIndex;
1038 
1039     /**
1040      * @dev See {IERC165-supportsInterface}.
1041      */
1042     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1043         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1044     }
1045 
1046     /**
1047      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1048      */
1049     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1050         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1051         return _ownedTokens[owner][index];
1052     }
1053 
1054     /**
1055      * @dev See {IERC721Enumerable-totalSupply}.
1056      */
1057     function totalSupply() public view virtual override returns (uint256) {
1058         return _allTokens.length;
1059     }
1060 
1061     /**
1062      * @dev See {IERC721Enumerable-tokenByIndex}.
1063      */
1064     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1065         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1066         return _allTokens[index];
1067     }
1068 
1069     /**
1070      * @dev Hook that is called before any token transfer. This includes minting
1071      * and burning.
1072      *
1073      * Calling conditions:
1074      *
1075      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1076      * transferred to `to`.
1077      * - When `from` is zero, `tokenId` will be minted for `to`.
1078      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1079      * - `from` cannot be the zero address.
1080      * - `to` cannot be the zero address.
1081      *
1082      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1083      */
1084     function _beforeTokenTransfer(
1085         address from,
1086         address to,
1087         uint256 tokenId
1088     ) internal virtual override {
1089         super._beforeTokenTransfer(from, to, tokenId);
1090 
1091         if (from == address(0)) {
1092             _addTokenToAllTokensEnumeration(tokenId);
1093         } else if (from != to) {
1094             _removeTokenFromOwnerEnumeration(from, tokenId);
1095         }
1096         if (to == address(0)) {
1097             _removeTokenFromAllTokensEnumeration(tokenId);
1098         } else if (to != from) {
1099             _addTokenToOwnerEnumeration(to, tokenId);
1100         }
1101     }
1102 
1103     /**
1104      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1105      * @param to address representing the new owner of the given token ID
1106      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1107      */
1108     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1109         uint256 length = ERC721.balanceOf(to);
1110         _ownedTokens[to][length] = tokenId;
1111         _ownedTokensIndex[tokenId] = length;
1112     }
1113 
1114     /**
1115      * @dev Private function to add a token to this extension's token tracking data structures.
1116      * @param tokenId uint256 ID of the token to be added to the tokens list
1117      */
1118     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1119         _allTokensIndex[tokenId] = _allTokens.length;
1120         _allTokens.push(tokenId);
1121     }
1122 
1123     /**
1124      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1125      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1126      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1127      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1128      * @param from address representing the previous owner of the given token ID
1129      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1130      */
1131     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1132         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1133         // then delete the last slot (swap and pop).
1134 
1135         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1136         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1137 
1138         // When the token to delete is the last token, the swap operation is unnecessary
1139         if (tokenIndex != lastTokenIndex) {
1140             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1141 
1142             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1143             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1144         }
1145 
1146         // This also deletes the contents at the last position of the array
1147         delete _ownedTokensIndex[tokenId];
1148         delete _ownedTokens[from][lastTokenIndex];
1149     }
1150 
1151     /**
1152      * @dev Private function to remove a token from this extension's token tracking data structures.
1153      * This has O(1) time complexity, but alters the order of the _allTokens array.
1154      * @param tokenId uint256 ID of the token to be removed from the tokens list
1155      */
1156     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1157         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1158         // then delete the last slot (swap and pop).
1159 
1160         uint256 lastTokenIndex = _allTokens.length - 1;
1161         uint256 tokenIndex = _allTokensIndex[tokenId];
1162 
1163         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1164         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1165         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1166         uint256 lastTokenId = _allTokens[lastTokenIndex];
1167 
1168         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1169         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1170 
1171         // This also deletes the contents at the last position of the array
1172         delete _allTokensIndex[tokenId];
1173         _allTokens.pop();
1174     }
1175 }
1176 
1177 contract Sleepwalkers is ERC721Enumerable, Ownable {
1178     uint public maxTokens = 8888;
1179     uint public mintPrice = 0.0888 ether;
1180     uint public maxMintsPerTx = 10;
1181     
1182     mapping(uint => uint) public muleSquadUsedForMint;
1183 
1184     string internal baseTokenURI;
1185     string internal baseTokenURI_EXT;
1186 
1187     address public mulesquadAddress;
1188     address public cyberkongzAddress;
1189     address public anonymiceAddress;
1190     IERC721 Mulesquad;
1191     IERC721 Cyberkongz;
1192     IERC721 Anonymice;
1193 
1194     event Mint(address indexed to, uint tokenId);
1195     
1196     constructor() ERC721("Sleepwalkers", "SLP") {}
1197     
1198     function withdrawEther() public onlyOwner {
1199         payable(msg.sender).transfer(address(this).balance); 
1200     }
1201 
1202     modifier onlySender {
1203         require(msg.sender == tx.origin, "No smart contracts!");
1204         _;
1205     }
1206 
1207     function setMulesquad(address address_) public onlyOwner {
1208         mulesquadAddress = address_;
1209         Mulesquad = IERC721(address_);
1210     }
1211     function setCyberkongz(address address_) public onlyOwner {
1212         cyberkongzAddress = address_;
1213         Cyberkongz = IERC721(address_);
1214     }
1215     function setAnonymice(address address_) public onlyOwner {
1216         anonymiceAddress = address_;
1217         Anonymice = IERC721(address_);
1218     }
1219 
1220     // Owner Mint
1221     function ownerMint(address address_, uint amount_) public onlyOwner {
1222         require(maxTokens >= totalSupply() + amount_, "Not enough tokens remaining!");
1223 
1224         for (uint i = 0; i < amount_; i++) {
1225             uint _mintId = totalSupply() + 1; // iterate from 1
1226             _mint(address_, _mintId);
1227             emit Mint(address_, _mintId);
1228         }
1229     }
1230 
1231     // Mint with Token
1232     bool public claimEnabled;
1233     uint public claimTime;
1234     uint public claimMinted;
1235     
1236     modifier publicClaiming {
1237         require(claimEnabled && block.timestamp >= claimTime, "Public Claiming is not available!");
1238         _;
1239     }
1240 
1241     function setClaimEnabled(bool bool_, uint claimTime_) public onlyOwner {
1242         claimEnabled = bool_;
1243         claimTime = claimTime_;
1244     }
1245 
1246     function claim(uint tokenId_) public onlySender publicClaiming {
1247         require(msg.sender == Mulesquad.ownerOf(tokenId_), "You do not own this Mulesquad!");
1248         require(maxTokens > totalSupply(), "No more remaining tokens left!");
1249         require(muleSquadUsedForMint[tokenId_] == 0, "This token was already used for claiming!");
1250 
1251         muleSquadUsedForMint[tokenId_]++;
1252         claimMinted++;
1253 
1254         uint _mintId = totalSupply() + 1; // iterate from 1
1255         _mint(msg.sender, _mintId);
1256         emit Mint(msg.sender, _mintId);
1257     }
1258 
1259     // Whitelisted Minting
1260     bool public whitelistMintEnabled;
1261     uint public whitelistMintTime;
1262     uint public whitelistHasMinted;
1263 
1264     modifier whitelistMinting {
1265         require(whitelistMintEnabled && block.timestamp >= whitelistMintTime, "Whitelisted Minting is not yet available!");
1266         _;
1267     }
1268 
1269     function setWhitelistMintingStatus(bool bool_, uint mintTime_) public onlyOwner {
1270         whitelistMintEnabled = bool_;
1271         whitelistMintTime = mintTime_;
1272     }
1273 
1274     function whitelistMint(uint amount_) public payable onlySender whitelistMinting {
1275         require(Anonymice.balanceOf(msg.sender) > 0 || Cyberkongz.balanceOf(msg.sender) > 0 || Mulesquad.balanceOf(msg.sender) > 0, "You do not have a Mulesquad, Anonymice, or Cyberkongz!");
1276         require(maxMintsPerTx >= amount_, "Over maximum mints per Tx!");
1277         require(maxTokens >= totalSupply() + amount_, "Not enough remaining tokens left!");
1278         require(msg.value == mintPrice * amount_, "Invalid value sent!");
1279 
1280         whitelistHasMinted += amount_;
1281 
1282         for (uint i = 0; i < amount_; i++) {
1283             uint _mintId = totalSupply() + 1; // iterate from 1
1284             _mint(msg.sender, _mintId);
1285             emit Mint(msg.sender, _mintId);
1286         }
1287     }
1288 
1289     // Public Minting
1290     bool public publicMintEnabled;
1291     uint public publicMintTime;
1292     uint public publicHasMinted;
1293 
1294     modifier publicMinting {
1295         require(publicMintEnabled && block.timestamp >= publicMintTime, "Public Minting is not yet enabled!");
1296         _;
1297     }
1298 
1299     function setPublicMintingStatus(bool bool_, uint mintTime_) public onlyOwner {
1300         publicMintEnabled = bool_;
1301         publicMintTime = mintTime_;
1302     }
1303 
1304     function mint(uint amount_) public payable onlySender publicMinting {
1305         require(maxMintsPerTx >= amount_, "Over maximum mints per Tx!");
1306         require(maxTokens >= totalSupply() + amount_, "Not enough remaining tokens left!");
1307         require(msg.value == mintPrice * amount_, "Invalid value sent!");
1308 
1309         publicHasMinted += amount_;
1310 
1311         for (uint i = 0; i < amount_; i++) {
1312             uint _mintId = totalSupply() + 1; // iterate from 1
1313             _mint(msg.sender, _mintId);
1314             emit Mint(msg.sender, _mintId);
1315         }
1316     }
1317 
1318     // General NFT Administration
1319     function setBaseTokenURI(string memory uri_) external onlyOwner {
1320         baseTokenURI = uri_;
1321     }
1322     function setBaseTokenURI_EXT(string memory ext_) external onlyOwner {
1323         baseTokenURI_EXT = ext_;
1324     }
1325 
1326     function tokenURI(uint tokenId_) public view override returns (string memory) {
1327         require(_exists(tokenId_), "Query for non-existent token!");
1328         return string(abi.encodePacked(baseTokenURI, Strings.toString(tokenId_), baseTokenURI_EXT));
1329     }
1330     function walletOfOwner(address address_) public view returns (uint[] memory) {
1331         uint _balance = balanceOf(address_); // get balance of address
1332         uint[] memory _tokenIds = new uint[](_balance); // initialize array 
1333         for (uint i = 0; i < _balance; i++) {
1334             _tokenIds[i] = tokenOfOwnerByIndex(address_, i);
1335         }
1336         return _tokenIds;
1337     }
1338 }