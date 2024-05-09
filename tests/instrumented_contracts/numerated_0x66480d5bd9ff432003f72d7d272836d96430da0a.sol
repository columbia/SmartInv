1 // SPDX-License-Identifier: MIT
2 
3 /**
4 Omega Droids - collection belongs to the 0xd38 Universe.
5 Official website - www.0xd38.xyz
6 */
7 
8 pragma solidity ^0.8.0;
9 
10 library Counters {
11     struct Counter {
12 
13         uint256 _value; // default: 0
14     }
15 
16     function current(Counter storage counter) internal view returns (uint256) {
17         return counter._value;
18     }
19 
20     function increment(Counter storage counter) internal {
21         unchecked {
22             counter._value += 1;
23         }
24     }
25 
26     function decrement(Counter storage counter) internal {
27         uint256 value = counter._value;
28         require(value > 0, "Counter:decrement overflow");
29         unchecked {
30             counter._value = value - 1;
31         }
32     }
33 
34     function reset(Counter storage counter) internal {
35         counter._value = 0;
36     }
37 }
38 
39 
40 pragma solidity ^0.8.0;
41 
42 /**
43  * @dev String operations.
44  */
45 library Strings {
46     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
47 
48     /**
49      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
50      */
51     function toString(uint256 value) internal pure returns (string memory) {
52         // Inspired by OraclizeAPI's implementation - MIT licence
53         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
54 
55         if (value == 0) {
56             return "0";
57         }
58         uint256 temp = value;
59         uint256 digits;
60         while (temp != 0) {
61             digits++;
62             temp /= 10;
63         }
64         bytes memory buffer = new bytes(digits);
65         while (value != 0) {
66             digits -= 1;
67             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
68             value /= 10;
69         }
70         return string(buffer);
71     }
72 
73     /**
74      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
75      */
76     function toHexString(uint256 value) internal pure returns (string memory) {
77         if (value == 0) {
78             return "0x00";
79         }
80         uint256 temp = value;
81         uint256 length = 0;
82         while (temp != 0) {
83             length++;
84             temp >>= 8;
85         }
86         return toHexString(value, length);
87     }
88 
89     /**
90      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
91      */
92     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
93         bytes memory buffer = new bytes(2 * length + 2);
94         buffer[0] = "0";
95         buffer[1] = "x";
96         for (uint256 i = 2 * length + 1; i > 1; --i) {
97             buffer[i] = _HEX_SYMBOLS[value & 0xf];
98             value >>= 4;
99         }
100         require(value == 0, "Strings: hex length insufficient");
101         return string(buffer);
102     }
103 }
104 
105 pragma solidity ^0.8.0;
106 
107 /**
108  * @dev Provides information about the current execution context, including the
109  * sender of the transaction and its data. While these are generally available
110  * via msg.sender and msg.data, they should not be accessed in such a direct
111  * manner, since when dealing with meta-transactions the account sending and
112  * paying for execution may not be the actual sender (as far as an application
113  * is concerned).
114  *
115  * This contract is only required for intermediate, library-like contracts.
116  */
117 abstract contract Context {
118     function _msgSender() internal view virtual returns (address) {
119         return msg.sender;
120     }
121 
122     function _msgData() internal view virtual returns (bytes calldata) {
123         return msg.data;
124     }
125 }
126 
127 
128 pragma solidity ^0.8.0;
129 
130 abstract contract Ownable is Context {
131     address private _owner;
132 
133     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
134 
135     /**
136      * @dev Initializes the contract setting the deployer as the initial owner.
137      */
138     constructor() {
139         _transferOwnership(_msgSender());
140     }
141 
142     /**
143      * @dev Returns the address of the current owner.
144      */
145     function owner() public view virtual returns (address) {
146         return _owner;
147     }
148 
149     /**
150      * @dev Throws if called by any account other than the owner.
151      */
152     modifier onlyOwner() {
153         require(owner() == _msgSender(), "Ownable: caller is not the owner");
154         _;
155     }
156 
157     /**
158      * @dev Leaves the contract without owner. It will not be possible to call
159      * `onlyOwner` functions anymore. Can only be called by the current owner.
160      *
161      * NOTE: Renouncing ownership will leave the contract without an owner,
162      * thereby removing any functionality that is only available to the owner.
163      */
164     function renounceOwnership() public virtual onlyOwner {
165         _transferOwnership(address(0));
166     }
167 
168     /**
169      * @dev Transfers ownership of the contract to a new account (`newOwner`).
170      * Can only be called by the current owner.
171      */
172     function transferOwnership(address newOwner) public virtual onlyOwner {
173         require(newOwner != address(0), "Ownable: new owner is the zero address");
174         _transferOwnership(newOwner);
175     }
176 
177     /**
178      * @dev Transfers ownership of the contract to a new account (`newOwner`).
179      * Internal function without access restriction.
180      */
181     function _transferOwnership(address newOwner) internal virtual {
182         address oldOwner = _owner;
183         _owner = newOwner;
184         emit OwnershipTransferred(oldOwner, newOwner);
185     }
186 }
187 
188 pragma solidity ^0.8.1;
189 
190 /**
191  * @dev Collection of functions related to the address type
192  */
193 library Address {
194     /**
195      * @dev Returns true if `account` is a contract.
196      *
197      * [IMPORTANT]
198      * ====
199      * It is unsafe to assume that an address for which this function returns
200      * false is an externally-owned account (EOA) and not a contract.
201      *
202      * Among others, `isContract` will return false for the following
203      * types of addresses:
204      *
205      *  - an externally-owned account
206      *  - a contract in construction
207      *  - an address where a contract will be created
208      *  - an address where a contract lived, but was destroyed
209      * ====
210      *
211      * [IMPORTANT]
212      * ====
213      * You shouldn't rely on `isContract` to protect against flash loan attacks!
214      *
215      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
216      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
217      * constructor.
218      * ====
219      */
220     function isContract(address account) internal view returns (bool) {
221         // This method relies on extcodesize/address.code.length, which returns 0
222         // for contracts in construction, since the code is only stored at the end
223         // of the constructor execution.
224 
225         return account.code.length > 0;
226     }
227 
228     /**
229      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
230      * `recipient`, forwarding all available gas and reverting on errors.
231      *
232      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
233      * of certain opcodes, possibly making contracts go over the 2300 gas limit
234      * imposed by `transfer`, making them unable to receive funds via
235      * `transfer`. {sendValue} removes this limitation.
236      *
237      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
238      *
239      * IMPORTANT: because control is transferred to `recipient`, care must be
240      * taken to not create reentrancy vulnerabilities. Consider using
241      * {ReentrancyGuard} or the
242      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
243      */
244     function sendValue(address payable recipient, uint256 amount) internal {
245         require(address(this).balance >= amount, "Address: insufficient balance");
246 
247         (bool success, ) = recipient.call{value: amount}("");
248         require(success, "Address: unable to send value, recipient may have reverted");
249     }
250 
251     /**
252      * @dev Performs a Solidity function call using a low level `call`. A
253      * plain `call` is an unsafe replacement for a function call: use this
254      * function instead.
255      *
256      * If `target` reverts with a revert reason, it is bubbled up by this
257      * function (like regular Solidity function calls).
258      *
259      * Returns the raw returned data. To convert to the expected return value,
260      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
261      *
262      * Requirements:
263      *
264      * - `target` must be a contract.
265      * - calling `target` with `data` must not revert.
266      *
267      * _Available since v3.1._
268      */
269     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
270         return functionCall(target, data, "Address: low-level call failed");
271     }
272 
273     /**
274      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
275      * `errorMessage` as a fallback revert reason when `target` reverts.
276      *
277      * _Available since v3.1._
278      */
279     function functionCall(
280         address target,
281         bytes memory data,
282         string memory errorMessage
283     ) internal returns (bytes memory) {
284         return functionCallWithValue(target, data, 0, errorMessage);
285     }
286 
287     /**
288      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
289      * but also transferring `value` wei to `target`.
290      *
291      * Requirements:
292      *
293      * - the calling contract must have an ETH balance of at least `value`.
294      * - the called Solidity function must be `payable`.
295      *
296      * _Available since v3.1._
297      */
298     function functionCallWithValue(
299         address target,
300         bytes memory data,
301         uint256 value
302     ) internal returns (bytes memory) {
303         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
304     }
305 
306     /**
307      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
308      * with `errorMessage` as a fallback revert reason when `target` reverts.
309      *
310      * _Available since v3.1._
311      */
312     function functionCallWithValue(
313         address target,
314         bytes memory data,
315         uint256 value,
316         string memory errorMessage
317     ) internal returns (bytes memory) {
318         require(address(this).balance >= value, "Address: insufficient balance for call");
319         require(isContract(target), "Address: call to non-contract");
320 
321         (bool success, bytes memory returndata) = target.call{value: value}(data);
322         return verifyCallResult(success, returndata, errorMessage);
323     }
324 
325     /**
326      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
327      * but performing a static call.
328      *
329      * _Available since v3.3._
330      */
331     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
332         return functionStaticCall(target, data, "Address: low-level static call failed");
333     }
334 
335     /**
336      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
337      * but performing a static call.
338      *
339      * _Available since v3.3._
340      */
341     function functionStaticCall(
342         address target,
343         bytes memory data,
344         string memory errorMessage
345     ) internal view returns (bytes memory) {
346         require(isContract(target), "Address: static call to non-contract");
347 
348         (bool success, bytes memory returndata) = target.staticcall(data);
349         return verifyCallResult(success, returndata, errorMessage);
350     }
351 
352     /**
353      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
354      * but performing a delegate call.
355      *
356      * _Available since v3.4._
357      */
358     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
359         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
360     }
361 
362     /**
363      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
364      * but performing a delegate call.
365      *
366      * _Available since v3.4._
367      */
368     function functionDelegateCall(
369         address target,
370         bytes memory data,
371         string memory errorMessage
372     ) internal returns (bytes memory) {
373         require(isContract(target), "Address: delegate call to non-contract");
374 
375         (bool success, bytes memory returndata) = target.delegatecall(data);
376         return verifyCallResult(success, returndata, errorMessage);
377     }
378 
379     /**
380      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
381      * revert reason using the provided one.
382      *
383      * _Available since v4.3._
384      */
385     function verifyCallResult(
386         bool success,
387         bytes memory returndata,
388         string memory errorMessage
389     ) internal pure returns (bytes memory) {
390         if (success) {
391             return returndata;
392         } else {
393             // Look for revert reason and bubble it up if present
394             if (returndata.length > 0) {
395                 // The easiest way to bubble the revert reason is using memory via assembly
396 
397                 assembly {
398                     let returndata_size := mload(returndata)
399                     revert(add(32, returndata), returndata_size)
400                 }
401             } else {
402                 revert(errorMessage);
403             }
404         }
405     }
406 }
407 
408 pragma solidity ^0.8.0;
409 
410 /**
411  * @title ERC721 token receiver interface
412  * @dev Interface for any contract that wants to support safeTransfers
413  * from ERC721 asset contracts.
414  */
415 interface IERC721Receiver {
416     /**
417      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
418      * by `operator` from `from`, this function is called.
419      *
420      * It must return its Solidity selector to confirm the token transfer.
421      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
422      *
423      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
424      */
425     function onERC721Received(
426         address operator,
427         address from,
428         uint256 tokenId,
429         bytes calldata data
430     ) external returns (bytes4);
431 }
432 
433 pragma solidity ^0.8.0;
434 
435 /**
436  * @dev Interface of the ERC165 standard, as defined in the
437  * https://eips.ethereum.org/EIPS/eip-165[EIP].
438  *
439  * Implementers can declare support of contract interfaces, which can then be
440  * queried by others ({ERC165Checker}).
441  *
442  * For an implementation, see {ERC165}.
443  */
444 interface IERC165 {
445     /**
446      * @dev Returns true if this contract implements the interface defined by
447      * `interfaceId`. See the corresponding
448      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
449      * to learn more about how these ids are created.
450      *
451      * This function call must use less than 30 000 gas.
452      */
453     function supportsInterface(bytes4 interfaceId) external view returns (bool);
454 }
455 
456 pragma solidity ^0.8.0;
457 
458 abstract contract ERC165 is IERC165 {
459     /**
460      * @dev See {IERC165-supportsInterface}.
461      */
462     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
463         return interfaceId == type(IERC165).interfaceId;
464     }
465 }
466 
467 pragma solidity ^0.8.0;
468 
469 interface IERC721 is IERC165 {
470     /**
471      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
472      */
473     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
474 
475     /**
476      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
477      */
478     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
479 
480     /**
481      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
482      */
483     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
484 
485     /**
486      * @dev Returns the number of tokens in ``owner``'s account.
487      */
488     function balanceOf(address owner) external view returns (uint256 balance);
489 
490     /**
491      * @dev Returns the owner of the `tokenId` token.
492      *
493      * Requirements:
494      *
495      * - `tokenId` must exist.
496      */
497     function ownerOf(uint256 tokenId) external view returns (address owner);
498 
499     function safeTransferFrom(
500         address from,
501         address to,
502         uint256 tokenId
503     ) external;
504 
505     function transferFrom(
506         address from,
507         address to,
508         uint256 tokenId
509     ) external;
510 
511     function approve(address to, uint256 tokenId) external;
512 
513     /**
514      * @dev Returns the account approved for `tokenId` token.
515      *
516      * Requirements:
517      *
518      * - `tokenId` must exist.
519      */
520     function getApproved(uint256 tokenId) external view returns (address operator);
521 
522     /**
523      * @dev Approve or remove `operator` as an operator for the caller.
524      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
525      *
526      * Requirements:
527      *
528      * - The `operator` cannot be the caller.
529      *
530      * Emits an {ApprovalForAll} event.
531      */
532     function setApprovalForAll(address operator, bool _approved) external;
533 
534     /**
535      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
536      *
537      * See {setApprovalForAll}
538      */
539     function isApprovedForAll(address owner, address operator) external view returns (bool);
540 
541     /**
542      * @dev Safely transfers `tokenId` token from `from` to `to`.
543      *
544      * Requirements:
545      *
546      * - `from` cannot be the zero address.
547      * - `to` cannot be the zero address.
548      * - `tokenId` token must exist and be owned by `from`.
549      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
550      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
551      *
552      * Emits a {Transfer} event.
553      */
554     function safeTransferFrom(
555         address from,
556         address to,
557         uint256 tokenId,
558         bytes calldata data
559     ) external;
560 }
561 
562 
563 pragma solidity ^0.8.0;
564 
565 
566 /**
567  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
568  * @dev See https://eips.ethereum.org/EIPS/eip-721
569  */
570 interface IERC721Enumerable is IERC721 {
571     /**
572      * @dev Returns the total amount of tokens stored by the contract.
573      */
574     function totalSupply() external view returns (uint256);
575 
576     /**
577      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
578      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
579      */
580     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
581 
582     /**
583      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
584      * Use along with {totalSupply} to enumerate all tokens.
585      */
586     function tokenByIndex(uint256 index) external view returns (uint256);
587 }
588 
589 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
590 
591 
592 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
593 
594 pragma solidity ^0.8.0;
595 
596 
597 /**
598  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
599  * @dev See https://eips.ethereum.org/EIPS/eip-721
600  */
601 interface IERC721Metadata is IERC721 {
602     /**
603      * @dev Returns the token collection name.
604      */
605     function name() external view returns (string memory);
606 
607     /**
608      * @dev Returns the token collection symbol.
609      */
610     function symbol() external view returns (string memory);
611 
612     /**
613      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
614      */
615     function tokenURI(uint256 tokenId) external view returns (string memory);
616 }
617 
618 
619 pragma solidity ^0.8.0;
620 
621 /**
622  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
623  * the Metadata extension, but not including the Enumerable extension, which is available separately as
624  * {ERC721Enumerable}.
625  */
626 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
627     using Address for address;
628     using Strings for uint256;
629 
630     // Token name
631     string private _name;
632 
633     // Token symbol
634     string private _symbol;
635 
636     // Mapping from token ID to owner address
637     mapping(uint256 => address) private _owners;
638 
639     // Mapping owner address to token count
640     mapping(address => uint256) private _balances;
641 
642     // Mapping from token ID to approved address
643     mapping(uint256 => address) private _tokenApprovals;
644 
645     // Mapping from owner to operator approvals
646     mapping(address => mapping(address => bool)) private _operatorApprovals;
647 
648     /**
649      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
650      */
651     constructor(string memory name_, string memory symbol_) {
652         _name = name_;
653         _symbol = symbol_;
654     }
655 
656     /**
657      * @dev See {IERC165-supportsInterface}.
658      */
659     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
660         return
661             interfaceId == type(IERC721).interfaceId ||
662             interfaceId == type(IERC721Metadata).interfaceId ||
663             super.supportsInterface(interfaceId);
664     }
665 
666     /**
667      * @dev See {IERC721-balanceOf}.
668      */
669     function balanceOf(address owner) public view virtual override returns (uint256) {
670         require(owner != address(0), "ERC721: balance query for the zero address");
671         return _balances[owner];
672     }
673 
674     /**
675      * @dev See {IERC721-ownerOf}.
676      */
677     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
678         address owner = _owners[tokenId];
679         require(owner != address(0), "ERC721: owner query for nonexistent token");
680         return owner;
681     }
682 
683     /**
684      * @dev See {IERC721Metadata-name}.
685      */
686     function name() public view virtual override returns (string memory) {
687         return _name;
688     }
689 
690     /**
691      * @dev See {IERC721Metadata-symbol}.
692      */
693     function symbol() public view virtual override returns (string memory) {
694         return _symbol;
695     }
696 
697     /**
698      * @dev See {IERC721Metadata-tokenURI}.
699      */
700     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
701         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
702 
703         string memory baseURI = _baseURI();
704         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
705     }
706 
707     /**
708      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
709      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
710      * by default, can be overriden in child contracts.
711      */
712     function _baseURI() internal view virtual returns (string memory) {
713         return "";
714     }
715 
716     /**
717      * @dev See {IERC721-approve}.
718      */
719     function approve(address to, uint256 tokenId) public virtual override {
720         address owner = ERC721.ownerOf(tokenId);
721         require(to != owner, "ERC721: approval to current owner");
722 
723         require(
724             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
725             "ERC721: approve caller is not owner nor approved for all"
726         );
727 
728         _approve(to, tokenId);
729     }
730 
731     /**
732      * @dev See {IERC721-getApproved}.
733      */
734     function getApproved(uint256 tokenId) public view virtual override returns (address) {
735         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
736 
737         return _tokenApprovals[tokenId];
738     }
739 
740     /**
741      * @dev See {IERC721-setApprovalForAll}.
742      */
743     function setApprovalForAll(address operator, bool approved) public virtual override {
744         _setApprovalForAll(_msgSender(), operator, approved);
745     }
746 
747     /**
748      * @dev See {IERC721-isApprovedForAll}.
749      */
750     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
751         return _operatorApprovals[owner][operator];
752     }
753 
754     /**
755      * @dev See {IERC721-transferFrom}.
756      */
757     function transferFrom(
758         address from,
759         address to,
760         uint256 tokenId
761     ) public virtual override {
762         //solhint-disable-next-line max-line-length
763         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
764 
765         _transfer(from, to, tokenId);
766     }
767 
768     /**
769      * @dev See {IERC721-safeTransferFrom}.
770      */
771     function safeTransferFrom(
772         address from,
773         address to,
774         uint256 tokenId
775     ) public virtual override {
776         safeTransferFrom(from, to, tokenId, "");
777     }
778 
779     /**
780      * @dev See {IERC721-safeTransferFrom}.
781      */
782     function safeTransferFrom(
783         address from,
784         address to,
785         uint256 tokenId,
786         bytes memory _data
787     ) public virtual override {
788         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
789         _safeTransfer(from, to, tokenId, _data);
790     }
791 
792     /**
793      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
794      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
795      *
796      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
797      *
798      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
799      * implement alternative mechanisms to perform token transfer, such as signature-based.
800      *
801      * Requirements:
802      *
803      * - `from` cannot be the zero address.
804      * - `to` cannot be the zero address.
805      * - `tokenId` token must exist and be owned by `from`.
806      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
807      *
808      * Emits a {Transfer} event.
809      */
810     function _safeTransfer(
811         address from,
812         address to,
813         uint256 tokenId,
814         bytes memory _data
815     ) internal virtual {
816         _transfer(from, to, tokenId);
817         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
818     }
819 
820     /**
821      * @dev Returns whether `tokenId` exists.
822      *
823      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
824      *
825      * Tokens start existing when they are minted (`_mint`),
826      * and stop existing when they are burned (`_burn`).
827      */
828     function _exists(uint256 tokenId) internal view virtual returns (bool) {
829         return _owners[tokenId] != address(0);
830     }
831 
832     /**
833      * @dev Returns whether `spender` is allowed to manage `tokenId`.
834      *
835      * Requirements:
836      *
837      * - `tokenId` must exist.
838      */
839     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
840         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
841         address owner = ERC721.ownerOf(tokenId);
842         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
843     }
844 
845     /**
846      * @dev Safely mints `tokenId` and transfers it to `to`.
847      *
848      * Requirements:
849      *
850      * - `tokenId` must not exist.
851      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
852      *
853      * Emits a {Transfer} event.
854      */
855     function _safeMint(address to, uint256 tokenId) internal virtual {
856         _safeMint(to, tokenId, "");
857     }
858 
859     /**
860      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
861      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
862      */
863     function _safeMint(
864         address to,
865         uint256 tokenId,
866         bytes memory _data
867     ) internal virtual {
868         _mint(to, tokenId);
869         require(
870             _checkOnERC721Received(address(0), to, tokenId, _data),
871             "ERC721: transfer to non ERC721Receiver implementer"
872         );
873     }
874 
875     /**
876      * @dev Mints `tokenId` and transfers it to `to`.
877      *
878      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
879      *
880      * Requirements:
881      *
882      * - `tokenId` must not exist.
883      * - `to` cannot be the zero address.
884      *
885      * Emits a {Transfer} event.
886      */
887     function _mint(address to, uint256 tokenId) internal virtual {
888         require(to != address(0), "ERC721: mint to the zero address");
889         require(!_exists(tokenId), "ERC721: token already minted");
890 
891         _beforeTokenTransfer(address(0), to, tokenId);
892 
893         _balances[to] += 1;
894         _owners[tokenId] = to;
895 
896         emit Transfer(address(0), to, tokenId);
897 
898         _afterTokenTransfer(address(0), to, tokenId);
899     }
900 
901     /**
902      * @dev Destroys `tokenId`.
903      * The approval is cleared when the token is burned.
904      *
905      * Requirements:
906      *
907      * - `tokenId` must exist.
908      *
909      * Emits a {Transfer} event.
910      */
911     function _burn(uint256 tokenId) internal virtual {
912         address owner = ERC721.ownerOf(tokenId);
913 
914         _beforeTokenTransfer(owner, address(0), tokenId);
915 
916         // Clear approvals
917         _approve(address(0), tokenId);
918 
919         _balances[owner] -= 1;
920         delete _owners[tokenId];
921 
922         emit Transfer(owner, address(0), tokenId);
923 
924         _afterTokenTransfer(owner, address(0), tokenId);
925     }
926 
927     /**
928      * @dev Transfers `tokenId` from `from` to `to`.
929      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
930      *
931      * Requirements:
932      *
933      * - `to` cannot be the zero address.
934      * - `tokenId` token must be owned by `from`.
935      *
936      * Emits a {Transfer} event.
937      */
938     function _transfer(
939         address from,
940         address to,
941         uint256 tokenId
942     ) internal virtual {
943         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
944         require(to != address(0), "ERC721: transfer to the zero address");
945 
946         _beforeTokenTransfer(from, to, tokenId);
947 
948         // Clear approvals from the previous owner
949         _approve(address(0), tokenId);
950 
951         _balances[from] -= 1;
952         _balances[to] += 1;
953         _owners[tokenId] = to;
954 
955         emit Transfer(from, to, tokenId);
956 
957         _afterTokenTransfer(from, to, tokenId);
958     }
959 
960     /**
961      * @dev Approve `to` to operate on `tokenId`
962      *
963      * Emits a {Approval} event.
964      */
965     function _approve(address to, uint256 tokenId) internal virtual {
966         _tokenApprovals[tokenId] = to;
967         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
968     }
969 
970     /**
971      * @dev Approve `operator` to operate on all of `owner` tokens
972      *
973      * Emits a {ApprovalForAll} event.
974      */
975     function _setApprovalForAll(
976         address owner,
977         address operator,
978         bool approved
979     ) internal virtual {
980         require(owner != operator, "ERC721: approve to caller");
981         _operatorApprovals[owner][operator] = approved;
982         emit ApprovalForAll(owner, operator, approved);
983     }
984 
985     /**
986      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
987      * The call is not executed if the target address is not a contract.
988      *
989      * @param from address representing the previous owner of the given token ID
990      * @param to target address that will receive the tokens
991      * @param tokenId uint256 ID of the token to be transferred
992      * @param _data bytes optional data to send along with the call
993      * @return bool whether the call correctly returned the expected magic value
994      */
995     function _checkOnERC721Received(
996         address from,
997         address to,
998         uint256 tokenId,
999         bytes memory _data
1000     ) private returns (bool) {
1001         if (to.isContract()) {
1002             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1003                 return retval == IERC721Receiver.onERC721Received.selector;
1004             } catch (bytes memory reason) {
1005                 if (reason.length == 0) {
1006                     revert("ERC721: transfer to non ERC721Receiver implementer");
1007                 } else {
1008                     assembly {
1009                         revert(add(32, reason), mload(reason))
1010                     }
1011                 }
1012             }
1013         } else {
1014             return true;
1015         }
1016     }
1017 
1018     function _beforeTokenTransfer(
1019         address from,
1020         address to,
1021         uint256 tokenId
1022     ) internal virtual {}
1023 
1024     /**
1025      * @dev Hook that is called after any transfer of tokens. This includes
1026      * minting and burning.
1027      *
1028      * Calling conditions:
1029      *
1030      * - when `from` and `to` are both non-zero.
1031      * - `from` and `to` are never both zero.
1032      *
1033      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1034      */
1035     function _afterTokenTransfer(
1036         address from,
1037         address to,
1038         uint256 tokenId
1039     ) internal virtual {}
1040 }
1041 
1042 
1043 pragma solidity ^0.8.0;
1044 
1045 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1046     // Mapping from owner to list of owned token IDs
1047     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1048 
1049     // Mapping from token ID to index of the owner tokens list
1050     mapping(uint256 => uint256) private _ownedTokensIndex;
1051 
1052     // Array with all token ids, used for enumeration
1053     uint256[] private _allTokens;
1054 
1055     // Mapping from token id to position in the allTokens array
1056     mapping(uint256 => uint256) private _allTokensIndex;
1057 
1058     /**
1059      * @dev See {IERC165-supportsInterface}.
1060      */
1061     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1062         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1063     }
1064 
1065     /**
1066      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1067      */
1068     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1069         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1070         return _ownedTokens[owner][index];
1071     }
1072 
1073     /**
1074      * @dev See {IERC721Enumerable-totalSupply}.
1075      */
1076     function totalSupply() public view virtual override returns (uint256) {
1077         return _allTokens.length;
1078     }
1079 
1080     /**
1081      * @dev See {IERC721Enumerable-tokenByIndex}.
1082      */
1083     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1084         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1085         return _allTokens[index];
1086     }
1087 
1088     function _beforeTokenTransfer(
1089         address from,
1090         address to,
1091         uint256 tokenId
1092     ) internal virtual override {
1093         super._beforeTokenTransfer(from, to, tokenId);
1094 
1095         if (from == address(0)) {
1096             _addTokenToAllTokensEnumeration(tokenId);
1097         } else if (from != to) {
1098             _removeTokenFromOwnerEnumeration(from, tokenId);
1099         }
1100         if (to == address(0)) {
1101             _removeTokenFromAllTokensEnumeration(tokenId);
1102         } else if (to != from) {
1103             _addTokenToOwnerEnumeration(to, tokenId);
1104         }
1105     }
1106 
1107     /**
1108      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1109      * @param to address representing the new owner of the given token ID
1110      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1111      */
1112     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1113         uint256 length = ERC721.balanceOf(to);
1114         _ownedTokens[to][length] = tokenId;
1115         _ownedTokensIndex[tokenId] = length;
1116     }
1117 
1118     /**
1119      * @dev Private function to add a token to this extension's token tracking data structures.
1120      * @param tokenId uint256 ID of the token to be added to the tokens list
1121      */
1122     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1123         _allTokensIndex[tokenId] = _allTokens.length;
1124         _allTokens.push(tokenId);
1125     }
1126 
1127     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1128         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1129         // then delete the last slot (swap and pop).
1130 
1131         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1132         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1133 
1134         // When the token to delete is the last token, the swap operation is unnecessary
1135         if (tokenIndex != lastTokenIndex) {
1136             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1137 
1138             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1139             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1140         }
1141 
1142         // This also deletes the contents at the last position of the array
1143         delete _ownedTokensIndex[tokenId];
1144         delete _ownedTokens[from][lastTokenIndex];
1145     }
1146 
1147     /**
1148      * @dev Private function to remove a token from this extension's token tracking data structures.
1149      * This has O(1) time complexity, but alters the order of the _allTokens array.
1150      * @param tokenId uint256 ID of the token to be removed from the tokens list
1151      */
1152     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1153         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1154         // then delete the last slot (swap and pop).
1155 
1156         uint256 lastTokenIndex = _allTokens.length - 1;
1157         uint256 tokenIndex = _allTokensIndex[tokenId];
1158 
1159         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1160         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1161         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1162         uint256 lastTokenId = _allTokens[lastTokenIndex];
1163 
1164         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1165         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1166 
1167         // This also deletes the contents at the last position of the array
1168         delete _allTokensIndex[tokenId];
1169         _allTokens.pop();
1170     }
1171 }
1172 
1173 
1174 pragma solidity ^0.8.4;
1175 
1176 error ApprovalCallerNotOwnerNorApproved();
1177 error ApprovalQueryForNonexistentToken();
1178 error ApproveToCaller();
1179 error ApprovalToCurrentOwner();
1180 error BalanceQueryForZeroAddress();
1181 error MintToZeroAddress();
1182 error MintZeroQuantity();
1183 error OwnerQueryForNonexistentToken();
1184 error TransferCallerNotOwnerNorApproved();
1185 error TransferFromIncorrectOwner();
1186 error TransferToNonERC721ReceiverImplementer();
1187 error TransferToZeroAddress();
1188 error URIQueryForNonexistentToken();
1189 
1190 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
1191     using Address for address;
1192     using Strings for uint256;
1193 
1194     // Compiler will pack this into a single 256bit word.
1195     struct TokenOwnership {
1196         // The address of the owner.
1197         address addr;
1198         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
1199         uint64 startTimestamp;
1200         // Whether the token has been burned.
1201         bool burned;
1202     }
1203 
1204     // Compiler will pack this into a single 256bit word.
1205     struct AddressData {
1206         // Realistically, 2**64-1 is more than enough.
1207         uint64 balance;
1208         // Keeps track of mint count with minimal overhead for tokenomics.
1209         uint64 numberMinted;
1210         // Keeps track of burn count with minimal overhead for tokenomics.
1211         uint64 numberBurned;
1212         // For miscellaneous variable(s) pertaining to the address
1213         // (e.g. number of whitelist mint slots used).
1214         // If there are multiple variables, please pack them into a uint64.
1215         uint64 aux;
1216     }
1217 
1218     // The tokenId of the next token to be minted.
1219     uint256 internal _currentIndex;
1220 
1221     // The number of tokens burned.
1222     uint256 internal _burnCounter;
1223 
1224     // Token name
1225     string private _name;
1226 
1227     // Token symbol
1228     string private _symbol;
1229 
1230     // Mapping from token ID to ownership details
1231     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
1232     mapping(uint256 => TokenOwnership) internal _ownerships;
1233 
1234     // Mapping owner address to address data
1235     mapping(address => AddressData) private _addressData;
1236 
1237     // Mapping from token ID to approved address
1238     mapping(uint256 => address) private _tokenApprovals;
1239 
1240     // Mapping from owner to operator approvals
1241     mapping(address => mapping(address => bool)) private _operatorApprovals;
1242 
1243     constructor(string memory name_, string memory symbol_) {
1244         _name = name_;
1245         _symbol = symbol_;
1246         _currentIndex = _startTokenId();
1247     }
1248 
1249     /**
1250      * To change the starting tokenId, please override this function.
1251      */
1252     function _startTokenId() internal view virtual returns (uint256) {
1253         return 0;
1254     }
1255 
1256     /**
1257      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
1258      */
1259     function totalSupply() public view returns (uint256) {
1260         // Counter underflow is impossible as _burnCounter cannot be incremented
1261         // more than _currentIndex - _startTokenId() times
1262         unchecked {
1263             return _currentIndex - _burnCounter - _startTokenId();
1264         }
1265     }
1266 
1267     /**
1268      * Returns the total amount of tokens minted in the contract.
1269      */
1270     function _totalMinted() internal view returns (uint256) {
1271         // Counter underflow is impossible as _currentIndex does not decrement,
1272         // and it is initialized to _startTokenId()
1273         unchecked {
1274             return _currentIndex - _startTokenId();
1275         }
1276     }
1277 
1278     /**
1279      * @dev See {IERC165-supportsInterface}.
1280      */
1281     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1282         return
1283             interfaceId == type(IERC721).interfaceId ||
1284             interfaceId == type(IERC721Metadata).interfaceId ||
1285             super.supportsInterface(interfaceId);
1286     }
1287 
1288     /**
1289      * @dev See {IERC721-balanceOf}.
1290      */
1291     function balanceOf(address owner) public view override returns (uint256) {
1292         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1293         return uint256(_addressData[owner].balance);
1294     }
1295 
1296     /**
1297      * Returns the number of tokens minted by `owner`.
1298      */
1299     function _numberMinted(address owner) internal view returns (uint256) {
1300         return uint256(_addressData[owner].numberMinted);
1301     }
1302 
1303     /**
1304      * Returns the number of tokens burned by or on behalf of `owner`.
1305      */
1306     function _numberBurned(address owner) internal view returns (uint256) {
1307         return uint256(_addressData[owner].numberBurned);
1308     }
1309 
1310     /**
1311      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1312      */
1313     function _getAux(address owner) internal view returns (uint64) {
1314         return _addressData[owner].aux;
1315     }
1316 
1317     /**
1318      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1319      * If there are multiple variables, please pack them into a uint64.
1320      */
1321     function _setAux(address owner, uint64 aux) internal {
1322         _addressData[owner].aux = aux;
1323     }
1324 
1325     /**
1326      * Gas spent here starts off proportional to the maximum mint batch size.
1327      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1328      */
1329     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1330         uint256 curr = tokenId;
1331 
1332         unchecked {
1333             if (_startTokenId() <= curr && curr < _currentIndex) {
1334                 TokenOwnership memory ownership = _ownerships[curr];
1335                 if (!ownership.burned) {
1336                     if (ownership.addr != address(0)) {
1337                         return ownership;
1338                     }
1339                     // Invariant:
1340                     // There will always be an ownership that has an address and is not burned
1341                     // before an ownership that does not have an address and is not burned.
1342                     // Hence, curr will not underflow.
1343                     while (true) {
1344                         curr--;
1345                         ownership = _ownerships[curr];
1346                         if (ownership.addr != address(0)) {
1347                             return ownership;
1348                         }
1349                     }
1350                 }
1351             }
1352         }
1353         revert OwnerQueryForNonexistentToken();
1354     }
1355 
1356     /**
1357      * @dev See {IERC721-ownerOf}.
1358      */
1359     function ownerOf(uint256 tokenId) public view override returns (address) {
1360         return _ownershipOf(tokenId).addr;
1361     }
1362 
1363     /**
1364      * @dev See {IERC721Metadata-name}.
1365      */
1366     function name() public view virtual override returns (string memory) {
1367         return _name;
1368     }
1369 
1370     /**
1371      * @dev See {IERC721Metadata-symbol}.
1372      */
1373     function symbol() public view virtual override returns (string memory) {
1374         return _symbol;
1375     }
1376 
1377     /**
1378      * @dev See {IERC721Metadata-tokenURI}.
1379      */
1380     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1381         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1382 
1383         string memory baseURI = _baseURI();
1384         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1385     }
1386 
1387     /**
1388      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1389      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1390      * by default, can be overriden in child contracts.
1391      */
1392     function _baseURI() internal view virtual returns (string memory) {
1393         return '';
1394     }
1395 
1396     /**
1397      * @dev See {IERC721-approve}.
1398      */
1399     function approve(address to, uint256 tokenId) public override {
1400         address owner = ERC721A.ownerOf(tokenId);
1401         if (to == owner) revert ApprovalToCurrentOwner();
1402 
1403         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1404             revert ApprovalCallerNotOwnerNorApproved();
1405         }
1406 
1407         _approve(to, tokenId, owner);
1408     }
1409 
1410     /**
1411      * @dev See {IERC721-getApproved}.
1412      */
1413     function getApproved(uint256 tokenId) public view override returns (address) {
1414         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1415 
1416         return _tokenApprovals[tokenId];
1417     }
1418 
1419     /**
1420      * @dev See {IERC721-setApprovalForAll}.
1421      */
1422     function setApprovalForAll(address operator, bool approved) public virtual override {
1423         if (operator == _msgSender()) revert ApproveToCaller();
1424 
1425         _operatorApprovals[_msgSender()][operator] = approved;
1426         emit ApprovalForAll(_msgSender(), operator, approved);
1427     }
1428 
1429     /**
1430      * @dev See {IERC721-isApprovedForAll}.
1431      */
1432     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1433         return _operatorApprovals[owner][operator];
1434     }
1435 
1436     /**
1437      * @dev See {IERC721-transferFrom}.
1438      */
1439     function transferFrom(
1440         address from,
1441         address to,
1442         uint256 tokenId
1443     ) public virtual override {
1444         _transfer(from, to, tokenId);
1445     }
1446 
1447     /**
1448      * @dev See {IERC721-safeTransferFrom}.
1449      */
1450     function safeTransferFrom(
1451         address from,
1452         address to,
1453         uint256 tokenId
1454     ) public virtual override {
1455         safeTransferFrom(from, to, tokenId, '');
1456     }
1457 
1458     /**
1459      * @dev See {IERC721-safeTransferFrom}.
1460      */
1461     function safeTransferFrom(
1462         address from,
1463         address to,
1464         uint256 tokenId,
1465         bytes memory _data
1466     ) public virtual override {
1467         _transfer(from, to, tokenId);
1468         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1469             revert TransferToNonERC721ReceiverImplementer();
1470         }
1471     }
1472 
1473     /**
1474      * @dev Returns whether `tokenId` exists.
1475      *
1476      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1477      *
1478      * Tokens start existing when they are minted (`_mint`),
1479      */
1480     function _exists(uint256 tokenId) internal view returns (bool) {
1481         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1482     }
1483 
1484     function _safeMint(address to, uint256 quantity) internal {
1485         _safeMint(to, quantity, '');
1486     }
1487 
1488     /**
1489      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1490      *
1491      * Requirements:
1492      *
1493      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1494      * - `quantity` must be greater than 0.
1495      *
1496      * Emits a {Transfer} event.
1497      */
1498     function _safeMint(
1499         address to,
1500         uint256 quantity,
1501         bytes memory _data
1502     ) internal {
1503         _mint(to, quantity, _data, true);
1504     }
1505 
1506     /**
1507      * @dev Mints `quantity` tokens and transfers them to `to`.
1508      *
1509      * Requirements:
1510      *
1511      * - `to` cannot be the zero address.
1512      * - `quantity` must be greater than 0.
1513      *
1514      * Emits a {Transfer} event.
1515      */
1516     function _mint(
1517         address to,
1518         uint256 quantity,
1519         bytes memory _data,
1520         bool safe
1521     ) internal {
1522         uint256 startTokenId = _currentIndex;
1523         if (to == address(0)) revert MintToZeroAddress();
1524         if (quantity == 0) revert MintZeroQuantity();
1525 
1526         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1527 
1528         // Overflows are incredibly unrealistic.
1529         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1530         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1531         unchecked {
1532             _addressData[to].balance += uint64(quantity);
1533             _addressData[to].numberMinted += uint64(quantity);
1534 
1535             _ownerships[startTokenId].addr = to;
1536             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1537 
1538             uint256 updatedIndex = startTokenId;
1539             uint256 end = updatedIndex + quantity;
1540 
1541             if (safe && to.isContract()) {
1542                 do {
1543                     emit Transfer(address(0), to, updatedIndex);
1544                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1545                         revert TransferToNonERC721ReceiverImplementer();
1546                     }
1547                 } while (updatedIndex != end);
1548                 // Reentrancy protection
1549                 if (_currentIndex != startTokenId) revert();
1550             } else {
1551                 do {
1552                     emit Transfer(address(0), to, updatedIndex++);
1553                 } while (updatedIndex != end);
1554             }
1555             _currentIndex = updatedIndex;
1556         }
1557         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1558     }
1559 
1560     function _transfer(
1561         address from,
1562         address to,
1563         uint256 tokenId
1564     ) private {
1565         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1566 
1567         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1568 
1569         bool isApprovedOrOwner = (_msgSender() == from ||
1570             isApprovedForAll(from, _msgSender()) ||
1571             getApproved(tokenId) == _msgSender());
1572 
1573         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1574         if (to == address(0)) revert TransferToZeroAddress();
1575 
1576         _beforeTokenTransfers(from, to, tokenId, 1);
1577 
1578         // Clear approvals from the previous owner
1579         _approve(address(0), tokenId, from);
1580 
1581         // Underflow of the sender's balance is impossible because we check for
1582         // ownership above and the recipient's balance can't realistically overflow.
1583         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1584         unchecked {
1585             _addressData[from].balance -= 1;
1586             _addressData[to].balance += 1;
1587 
1588             TokenOwnership storage currSlot = _ownerships[tokenId];
1589             currSlot.addr = to;
1590             currSlot.startTimestamp = uint64(block.timestamp);
1591 
1592             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1593             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1594             uint256 nextTokenId = tokenId + 1;
1595             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1596             if (nextSlot.addr == address(0)) {
1597                 // This will suffice for checking _exists(nextTokenId),
1598                 // as a burned slot cannot contain the zero address.
1599                 if (nextTokenId != _currentIndex) {
1600                     nextSlot.addr = from;
1601                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1602                 }
1603             }
1604         }
1605 
1606         emit Transfer(from, to, tokenId);
1607         _afterTokenTransfers(from, to, tokenId, 1);
1608     }
1609 
1610     /**
1611      * @dev This is equivalent to _burn(tokenId, false)
1612      */
1613     function _burn(uint256 tokenId) internal virtual {
1614         _burn(tokenId, false);
1615     }
1616 
1617     /**
1618      * @dev Destroys `tokenId`.
1619      * The approval is cleared when the token is burned.
1620      *
1621      * Requirements:
1622      *
1623      * - `tokenId` must exist.
1624      *
1625      * Emits a {Transfer} event.
1626      */
1627     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1628         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1629 
1630         address from = prevOwnership.addr;
1631 
1632         if (approvalCheck) {
1633             bool isApprovedOrOwner = (_msgSender() == from ||
1634                 isApprovedForAll(from, _msgSender()) ||
1635                 getApproved(tokenId) == _msgSender());
1636 
1637             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1638         }
1639 
1640         _beforeTokenTransfers(from, address(0), tokenId, 1);
1641 
1642         // Clear approvals from the previous owner
1643         _approve(address(0), tokenId, from);
1644 
1645         // Underflow of the sender's balance is impossible because we check for
1646         // ownership above and the recipient's balance can't realistically overflow.
1647         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1648         unchecked {
1649             AddressData storage addressData = _addressData[from];
1650             addressData.balance -= 1;
1651             addressData.numberBurned += 1;
1652 
1653             // Keep track of who burned the token, and the timestamp of burning.
1654             TokenOwnership storage currSlot = _ownerships[tokenId];
1655             currSlot.addr = from;
1656             currSlot.startTimestamp = uint64(block.timestamp);
1657             currSlot.burned = true;
1658 
1659             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1660             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1661             uint256 nextTokenId = tokenId + 1;
1662             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1663             if (nextSlot.addr == address(0)) {
1664                 // This will suffice for checking _exists(nextTokenId),
1665                 // as a burned slot cannot contain the zero address.
1666                 if (nextTokenId != _currentIndex) {
1667                     nextSlot.addr = from;
1668                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1669                 }
1670             }
1671         }
1672 
1673         emit Transfer(from, address(0), tokenId);
1674         _afterTokenTransfers(from, address(0), tokenId, 1);
1675 
1676         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1677         unchecked {
1678             _burnCounter++;
1679         }
1680     }
1681 
1682     /**
1683      * @dev Approve `to` to operate on `tokenId`
1684      *
1685      * Emits a {Approval} event.
1686      */
1687     function _approve(
1688         address to,
1689         uint256 tokenId,
1690         address owner
1691     ) private {
1692         _tokenApprovals[tokenId] = to;
1693         emit Approval(owner, to, tokenId);
1694     }
1695 
1696     /**
1697      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1698      *
1699      * @param from address representing the previous owner of the given token ID
1700      * @param to target address that will receive the tokens
1701      * @param tokenId uint256 ID of the token to be transferred
1702      * @param _data bytes optional data to send along with the call
1703      * @return bool whether the call correctly returned the expected magic value
1704      */
1705     function _checkContractOnERC721Received(
1706         address from,
1707         address to,
1708         uint256 tokenId,
1709         bytes memory _data
1710     ) private returns (bool) {
1711         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1712             return retval == IERC721Receiver(to).onERC721Received.selector;
1713         } catch (bytes memory reason) {
1714             if (reason.length == 0) {
1715                 revert TransferToNonERC721ReceiverImplementer();
1716             } else {
1717                 assembly {
1718                     revert(add(32, reason), mload(reason))
1719                 }
1720             }
1721         }
1722     }
1723 
1724     function _beforeTokenTransfers(
1725         address from,
1726         address to,
1727         uint256 startTokenId,
1728         uint256 quantity
1729     ) internal virtual {}
1730 
1731     function _afterTokenTransfers(
1732         address from,
1733         address to,
1734         uint256 startTokenId,
1735         uint256 quantity
1736     ) internal virtual {}
1737 }
1738 
1739 
1740 pragma solidity ^0.8.4;
1741 
1742 
1743 contract ODROIDS is ERC721A, Ownable {
1744     using Strings for uint256;
1745 
1746     string private baseURI;
1747 
1748     string public hiddenMetadataUri;
1749 
1750     uint256 public price = 0.016 ether;
1751 
1752     uint256 public maxPerTx = 3;
1753 
1754     uint256 public maxFreePerWallet = 3;
1755 
1756     uint256 public totalFree = 10000;
1757 
1758     uint256 public maxSupply = 10000;
1759 
1760     uint public nextId = 0;
1761 
1762     bool public mintEnabled = false;
1763 
1764     bool public revealed = true;
1765 
1766     mapping(address => uint256) private _mintedFreeAmount;
1767 
1768     constructor() ERC721A("Omega Droids", "O-DROIDS") {
1769         setHiddenMetadataUri("https://api2.0xd38.xyz/");
1770         setBaseURI("https://api2.0xd38.xyz/");
1771     }
1772 
1773     function mint(uint256 count) external payable {
1774       uint256 cost = price;
1775       bool isFree =
1776       ((totalSupply() + count < totalFree + 1) &&
1777       (_mintedFreeAmount[msg.sender] + count <= maxFreePerWallet));
1778 
1779       if (isFree) {
1780       cost = 0;
1781      }
1782 
1783      else {
1784       require(msg.value >= count * price, "Please send the exact amount.");
1785       require(totalSupply() + count <= maxSupply, "No more DROIDS");
1786       require(mintEnabled, "Minting is not live yet");
1787       require(count <= maxPerTx, "Max per TX reached.");
1788      }
1789 
1790       if (isFree) {
1791          _mintedFreeAmount[msg.sender] += count;
1792       }
1793 
1794      _safeMint(msg.sender, count);
1795      nextId += count;
1796     }
1797 
1798     function _baseURI() internal view virtual override returns (string memory) {
1799         return baseURI;
1800     }
1801 
1802     function tokenURI(uint256 tokenId)
1803         public
1804         view
1805         virtual
1806         override
1807         returns (string memory)
1808     {
1809         require(
1810             _exists(tokenId),
1811             "ERC721Metadata: URI query for nonexistent token"
1812         );
1813 
1814         if (revealed == false) {
1815          return string(abi.encodePacked(hiddenMetadataUri));
1816         }
1817     
1818         return string(abi.encodePacked(baseURI, tokenId.toString(), ".json"));
1819     }
1820 
1821     function setBaseURI(string memory uri) public onlyOwner {
1822         baseURI = uri;
1823     }
1824 
1825     function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1826      hiddenMetadataUri = _hiddenMetadataUri;
1827     }
1828 
1829     function setFreeAmount(uint256 amount) external onlyOwner {
1830         totalFree = amount;
1831     }
1832 
1833     function setPrice(uint256 _newPrice) external onlyOwner {
1834         price = _newPrice;
1835     }
1836 
1837     function setRevealed() external onlyOwner {
1838      revealed = !revealed;
1839     }
1840 
1841     function flipSale() external onlyOwner {
1842         mintEnabled = !mintEnabled;
1843     }
1844 
1845     function getNextId() public view returns(uint){
1846      return nextId;
1847     }
1848 
1849     function _startTokenId() internal pure override returns (uint256) {
1850         return 1;
1851     }
1852 
1853     function withdraw() external onlyOwner {
1854         (bool success, ) = payable(msg.sender).call{
1855             value: address(this).balance
1856         }("");
1857         require(success, "Transfer failed.");
1858     }
1859 
1860     function FREEMINTWL(address to, uint256 quantity)public onlyOwner{
1861     require(totalSupply() + quantity <= maxSupply, "reached max supply");
1862     _safeMint(to, quantity);
1863   }
1864 }