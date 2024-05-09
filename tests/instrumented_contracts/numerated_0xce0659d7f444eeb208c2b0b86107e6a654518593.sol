1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 library Counters {
6     struct Counter {
7 
8         uint256 _value; // default: 0
9     }
10 
11     function current(Counter storage counter) internal view returns (uint256) {
12         return counter._value;
13     }
14 
15     function increment(Counter storage counter) internal {
16         unchecked {
17             counter._value += 1;
18         }
19     }
20 
21     function decrement(Counter storage counter) internal {
22         uint256 value = counter._value;
23         require(value > 0, "Counter:decrement overflow");
24         unchecked {
25             counter._value = value - 1;
26         }
27     }
28 
29     function reset(Counter storage counter) internal {
30         counter._value = 0;
31     }
32 }
33 
34 
35 pragma solidity ^0.8.0;
36 
37 /**
38  * @dev String operations.
39  */
40 library Strings {
41     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
42 
43     /**
44      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
45      */
46     function toString(uint256 value) internal pure returns (string memory) {
47         // Inspired by OraclizeAPI's implementation - MIT licence
48         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
49 
50         if (value == 0) {
51             return "0";
52         }
53         uint256 temp = value;
54         uint256 digits;
55         while (temp != 0) {
56             digits++;
57             temp /= 10;
58         }
59         bytes memory buffer = new bytes(digits);
60         while (value != 0) {
61             digits -= 1;
62             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
63             value /= 10;
64         }
65         return string(buffer);
66     }
67 
68     /**
69      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
70      */
71     function toHexString(uint256 value) internal pure returns (string memory) {
72         if (value == 0) {
73             return "0x00";
74         }
75         uint256 temp = value;
76         uint256 length = 0;
77         while (temp != 0) {
78             length++;
79             temp >>= 8;
80         }
81         return toHexString(value, length);
82     }
83 
84     /**
85      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
86      */
87     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
88         bytes memory buffer = new bytes(2 * length + 2);
89         buffer[0] = "0";
90         buffer[1] = "x";
91         for (uint256 i = 2 * length + 1; i > 1; --i) {
92             buffer[i] = _HEX_SYMBOLS[value & 0xf];
93             value >>= 4;
94         }
95         require(value == 0, "Strings: hex length insufficient");
96         return string(buffer);
97     }
98 }
99 
100 pragma solidity ^0.8.0;
101 
102 /**
103  * @dev Provides information about the current execution context, including the
104  * sender of the transaction and its data. While these are generally available
105  * via msg.sender and msg.data, they should not be accessed in such a direct
106  * manner, since when dealing with meta-transactions the account sending and
107  * paying for execution may not be the actual sender (as far as an application
108  * is concerned).
109  *
110  * This contract is only required for intermediate, library-like contracts.
111  */
112 abstract contract Context {
113     function _msgSender() internal view virtual returns (address) {
114         return msg.sender;
115     }
116 
117     function _msgData() internal view virtual returns (bytes calldata) {
118         return msg.data;
119     }
120 }
121 
122 
123 pragma solidity ^0.8.0;
124 
125 abstract contract Ownable is Context {
126     address private _owner;
127 
128     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
129 
130     /**
131      * @dev Initializes the contract setting the deployer as the initial owner.
132      */
133     constructor() {
134         _transferOwnership(_msgSender());
135     }
136 
137     /**
138      * @dev Returns the address of the current owner.
139      */
140     function owner() public view virtual returns (address) {
141         return _owner;
142     }
143 
144     /**
145      * @dev Throws if called by any account other than the owner.
146      */
147     modifier onlyOwner() {
148         require(owner() == _msgSender(), "Ownable: caller is not the owner");
149         _;
150     }
151 
152     /**
153      * @dev Leaves the contract without owner. It will not be possible to call
154      * `onlyOwner` functions anymore. Can only be called by the current owner.
155      *
156      * NOTE: Renouncing ownership will leave the contract without an owner,
157      * thereby removing any functionality that is only available to the owner.
158      */
159     function renounceOwnership() public virtual onlyOwner {
160         _transferOwnership(address(0));
161     }
162 
163     /**
164      * @dev Transfers ownership of the contract to a new account (`newOwner`).
165      * Can only be called by the current owner.
166      */
167     function transferOwnership(address newOwner) public virtual onlyOwner {
168         require(newOwner != address(0), "Ownable: new owner is the zero address");
169         _transferOwnership(newOwner);
170     }
171 
172     /**
173      * @dev Transfers ownership of the contract to a new account (`newOwner`).
174      * Internal function without access restriction.
175      */
176     function _transferOwnership(address newOwner) internal virtual {
177         address oldOwner = _owner;
178         _owner = newOwner;
179         emit OwnershipTransferred(oldOwner, newOwner);
180     }
181 }
182 
183 pragma solidity ^0.8.1;
184 
185 /**
186  * @dev Collection of functions related to the address type
187  */
188 library Address {
189     /**
190      * @dev Returns true if `account` is a contract.
191      *
192      * [IMPORTANT]
193      * ====
194      * It is unsafe to assume that an address for which this function returns
195      * false is an externally-owned account (EOA) and not a contract.
196      *
197      * Among others, `isContract` will return false for the following
198      * types of addresses:
199      *
200      *  - an externally-owned account
201      *  - a contract in construction
202      *  - an address where a contract will be created
203      *  - an address where a contract lived, but was destroyed
204      * ====
205      *
206      * [IMPORTANT]
207      * ====
208      * You shouldn't rely on `isContract` to protect against flash loan attacks!
209      *
210      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
211      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
212      * constructor.
213      * ====
214      */
215     function isContract(address account) internal view returns (bool) {
216         // This method relies on extcodesize/address.code.length, which returns 0
217         // for contracts in construction, since the code is only stored at the end
218         // of the constructor execution.
219 
220         return account.code.length > 0;
221     }
222 
223     /**
224      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
225      * `recipient`, forwarding all available gas and reverting on errors.
226      *
227      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
228      * of certain opcodes, possibly making contracts go over the 2300 gas limit
229      * imposed by `transfer`, making them unable to receive funds via
230      * `transfer`. {sendValue} removes this limitation.
231      *
232      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
233      *
234      * IMPORTANT: because control is transferred to `recipient`, care must be
235      * taken to not create reentrancy vulnerabilities. Consider using
236      * {ReentrancyGuard} or the
237      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
238      */
239     function sendValue(address payable recipient, uint256 amount) internal {
240         require(address(this).balance >= amount, "Address: insufficient balance");
241 
242         (bool success, ) = recipient.call{value: amount}("");
243         require(success, "Address: unable to send value, recipient may have reverted");
244     }
245 
246     /**
247      * @dev Performs a Solidity function call using a low level `call`. A
248      * plain `call` is an unsafe replacement for a function call: use this
249      * function instead.
250      *
251      * If `target` reverts with a revert reason, it is bubbled up by this
252      * function (like regular Solidity function calls).
253      *
254      * Returns the raw returned data. To convert to the expected return value,
255      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
256      *
257      * Requirements:
258      *
259      * - `target` must be a contract.
260      * - calling `target` with `data` must not revert.
261      *
262      * _Available since v3.1._
263      */
264     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
265         return functionCall(target, data, "Address: low-level call failed");
266     }
267 
268     /**
269      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
270      * `errorMessage` as a fallback revert reason when `target` reverts.
271      *
272      * _Available since v3.1._
273      */
274     function functionCall(
275         address target,
276         bytes memory data,
277         string memory errorMessage
278     ) internal returns (bytes memory) {
279         return functionCallWithValue(target, data, 0, errorMessage);
280     }
281 
282     /**
283      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
284      * but also transferring `value` wei to `target`.
285      *
286      * Requirements:
287      *
288      * - the calling contract must have an ETH balance of at least `value`.
289      * - the called Solidity function must be `payable`.
290      *
291      * _Available since v3.1._
292      */
293     function functionCallWithValue(
294         address target,
295         bytes memory data,
296         uint256 value
297     ) internal returns (bytes memory) {
298         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
299     }
300 
301     /**
302      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
303      * with `errorMessage` as a fallback revert reason when `target` reverts.
304      *
305      * _Available since v3.1._
306      */
307     function functionCallWithValue(
308         address target,
309         bytes memory data,
310         uint256 value,
311         string memory errorMessage
312     ) internal returns (bytes memory) {
313         require(address(this).balance >= value, "Address: insufficient balance for call");
314         require(isContract(target), "Address: call to non-contract");
315 
316         (bool success, bytes memory returndata) = target.call{value: value}(data);
317         return verifyCallResult(success, returndata, errorMessage);
318     }
319 
320     /**
321      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
322      * but performing a static call.
323      *
324      * _Available since v3.3._
325      */
326     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
327         return functionStaticCall(target, data, "Address: low-level static call failed");
328     }
329 
330     /**
331      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
332      * but performing a static call.
333      *
334      * _Available since v3.3._
335      */
336     function functionStaticCall(
337         address target,
338         bytes memory data,
339         string memory errorMessage
340     ) internal view returns (bytes memory) {
341         require(isContract(target), "Address: static call to non-contract");
342 
343         (bool success, bytes memory returndata) = target.staticcall(data);
344         return verifyCallResult(success, returndata, errorMessage);
345     }
346 
347     /**
348      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
349      * but performing a delegate call.
350      *
351      * _Available since v3.4._
352      */
353     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
354         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
355     }
356 
357     /**
358      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
359      * but performing a delegate call.
360      *
361      * _Available since v3.4._
362      */
363     function functionDelegateCall(
364         address target,
365         bytes memory data,
366         string memory errorMessage
367     ) internal returns (bytes memory) {
368         require(isContract(target), "Address: delegate call to non-contract");
369 
370         (bool success, bytes memory returndata) = target.delegatecall(data);
371         return verifyCallResult(success, returndata, errorMessage);
372     }
373 
374     /**
375      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
376      * revert reason using the provided one.
377      *
378      * _Available since v4.3._
379      */
380     function verifyCallResult(
381         bool success,
382         bytes memory returndata,
383         string memory errorMessage
384     ) internal pure returns (bytes memory) {
385         if (success) {
386             return returndata;
387         } else {
388             // Look for revert reason and bubble it up if present
389             if (returndata.length > 0) {
390                 // The easiest way to bubble the revert reason is using memory via assembly
391 
392                 assembly {
393                     let returndata_size := mload(returndata)
394                     revert(add(32, returndata), returndata_size)
395                 }
396             } else {
397                 revert(errorMessage);
398             }
399         }
400     }
401 }
402 
403 pragma solidity ^0.8.0;
404 
405 /**
406  * @title ERC721 token receiver interface
407  * @dev Interface for any contract that wants to support safeTransfers
408  * from ERC721 asset contracts.
409  */
410 interface IERC721Receiver {
411     /**
412      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
413      * by `operator` from `from`, this function is called.
414      *
415      * It must return its Solidity selector to confirm the token transfer.
416      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
417      *
418      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
419      */
420     function onERC721Received(
421         address operator,
422         address from,
423         uint256 tokenId,
424         bytes calldata data
425     ) external returns (bytes4);
426 }
427 
428 pragma solidity ^0.8.0;
429 
430 /**
431  * @dev Interface of the ERC165 standard, as defined in the
432  * https://eips.ethereum.org/EIPS/eip-165[EIP].
433  *
434  * Implementers can declare support of contract interfaces, which can then be
435  * queried by others ({ERC165Checker}).
436  *
437  * For an implementation, see {ERC165}.
438  */
439 interface IERC165 {
440     /**
441      * @dev Returns true if this contract implements the interface defined by
442      * `interfaceId`. See the corresponding
443      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
444      * to learn more about how these ids are created.
445      *
446      * This function call must use less than 30 000 gas.
447      */
448     function supportsInterface(bytes4 interfaceId) external view returns (bool);
449 }
450 
451 pragma solidity ^0.8.0;
452 
453 abstract contract ERC165 is IERC165 {
454     /**
455      * @dev See {IERC165-supportsInterface}.
456      */
457     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
458         return interfaceId == type(IERC165).interfaceId;
459     }
460 }
461 
462 pragma solidity ^0.8.0;
463 
464 interface IERC721 is IERC165 {
465     /**
466      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
467      */
468     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
469 
470     /**
471      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
472      */
473     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
474 
475     /**
476      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
477      */
478     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
479 
480     /**
481      * @dev Returns the number of tokens in ``owner``'s account.
482      */
483     function balanceOf(address owner) external view returns (uint256 balance);
484 
485     /**
486      * @dev Returns the owner of the `tokenId` token.
487      *
488      * Requirements:
489      *
490      * - `tokenId` must exist.
491      */
492     function ownerOf(uint256 tokenId) external view returns (address owner);
493 
494     function safeTransferFrom(
495         address from,
496         address to,
497         uint256 tokenId
498     ) external;
499 
500     function transferFrom(
501         address from,
502         address to,
503         uint256 tokenId
504     ) external;
505 
506     function approve(address to, uint256 tokenId) external;
507 
508     /**
509      * @dev Returns the account approved for `tokenId` token.
510      *
511      * Requirements:
512      *
513      * - `tokenId` must exist.
514      */
515     function getApproved(uint256 tokenId) external view returns (address operator);
516 
517     /**
518      * @dev Approve or remove `operator` as an operator for the caller.
519      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
520      *
521      * Requirements:
522      *
523      * - The `operator` cannot be the caller.
524      *
525      * Emits an {ApprovalForAll} event.
526      */
527     function setApprovalForAll(address operator, bool _approved) external;
528 
529     /**
530      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
531      *
532      * See {setApprovalForAll}
533      */
534     function isApprovedForAll(address owner, address operator) external view returns (bool);
535 
536     /**
537      * @dev Safely transfers `tokenId` token from `from` to `to`.
538      *
539      * Requirements:
540      *
541      * - `from` cannot be the zero address.
542      * - `to` cannot be the zero address.
543      * - `tokenId` token must exist and be owned by `from`.
544      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
545      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
546      *
547      * Emits a {Transfer} event.
548      */
549     function safeTransferFrom(
550         address from,
551         address to,
552         uint256 tokenId,
553         bytes calldata data
554     ) external;
555 }
556 
557 
558 pragma solidity ^0.8.0;
559 
560 
561 /**
562  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
563  * @dev See https://eips.ethereum.org/EIPS/eip-721
564  */
565 interface IERC721Enumerable is IERC721 {
566     /**
567      * @dev Returns the total amount of tokens stored by the contract.
568      */
569     function totalSupply() external view returns (uint256);
570 
571     /**
572      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
573      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
574      */
575     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
576 
577     /**
578      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
579      * Use along with {totalSupply} to enumerate all tokens.
580      */
581     function tokenByIndex(uint256 index) external view returns (uint256);
582 }
583 
584 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
585 
586 
587 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
588 
589 pragma solidity ^0.8.0;
590 
591 
592 /**
593  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
594  * @dev See https://eips.ethereum.org/EIPS/eip-721
595  */
596 interface IERC721Metadata is IERC721 {
597     /**
598      * @dev Returns the token collection name.
599      */
600     function name() external view returns (string memory);
601 
602     /**
603      * @dev Returns the token collection symbol.
604      */
605     function symbol() external view returns (string memory);
606 
607     /**
608      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
609      */
610     function tokenURI(uint256 tokenId) external view returns (string memory);
611 }
612 
613 
614 pragma solidity ^0.8.0;
615 
616 /**
617  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
618  * the Metadata extension, but not including the Enumerable extension, which is available separately as
619  * {ERC721Enumerable}.
620  */
621 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
622     using Address for address;
623     using Strings for uint256;
624 
625     // Token name
626     string private _name;
627 
628     // Token symbol
629     string private _symbol;
630 
631     // Mapping from token ID to owner address
632     mapping(uint256 => address) private _owners;
633 
634     // Mapping owner address to token count
635     mapping(address => uint256) private _balances;
636 
637     // Mapping from token ID to approved address
638     mapping(uint256 => address) private _tokenApprovals;
639 
640     // Mapping from owner to operator approvals
641     mapping(address => mapping(address => bool)) private _operatorApprovals;
642 
643     /**
644      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
645      */
646     constructor(string memory name_, string memory symbol_) {
647         _name = name_;
648         _symbol = symbol_;
649     }
650 
651     /**
652      * @dev See {IERC165-supportsInterface}.
653      */
654     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
655         return
656             interfaceId == type(IERC721).interfaceId ||
657             interfaceId == type(IERC721Metadata).interfaceId ||
658             super.supportsInterface(interfaceId);
659     }
660 
661     /**
662      * @dev See {IERC721-balanceOf}.
663      */
664     function balanceOf(address owner) public view virtual override returns (uint256) {
665         require(owner != address(0), "ERC721: balance query for the zero address");
666         return _balances[owner];
667     }
668 
669     /**
670      * @dev See {IERC721-ownerOf}.
671      */
672     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
673         address owner = _owners[tokenId];
674         require(owner != address(0), "ERC721: owner query for nonexistent token");
675         return owner;
676     }
677 
678     /**
679      * @dev See {IERC721Metadata-name}.
680      */
681     function name() public view virtual override returns (string memory) {
682         return _name;
683     }
684 
685     /**
686      * @dev See {IERC721Metadata-symbol}.
687      */
688     function symbol() public view virtual override returns (string memory) {
689         return _symbol;
690     }
691 
692     /**
693      * @dev See {IERC721Metadata-tokenURI}.
694      */
695     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
696         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
697 
698         string memory baseURI = _baseURI();
699         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
700     }
701 
702     /**
703      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
704      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
705      * by default, can be overriden in child contracts.
706      */
707     function _baseURI() internal view virtual returns (string memory) {
708         return "";
709     }
710 
711     /**
712      * @dev See {IERC721-approve}.
713      */
714     function approve(address to, uint256 tokenId) public virtual override {
715         address owner = ERC721.ownerOf(tokenId);
716         require(to != owner, "ERC721: approval to current owner");
717 
718         require(
719             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
720             "ERC721: approve caller is not owner nor approved for all"
721         );
722 
723         _approve(to, tokenId);
724     }
725 
726     /**
727      * @dev See {IERC721-getApproved}.
728      */
729     function getApproved(uint256 tokenId) public view virtual override returns (address) {
730         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
731 
732         return _tokenApprovals[tokenId];
733     }
734 
735     /**
736      * @dev See {IERC721-setApprovalForAll}.
737      */
738     function setApprovalForAll(address operator, bool approved) public virtual override {
739         _setApprovalForAll(_msgSender(), operator, approved);
740     }
741 
742     /**
743      * @dev See {IERC721-isApprovedForAll}.
744      */
745     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
746         return _operatorApprovals[owner][operator];
747     }
748 
749     /**
750      * @dev See {IERC721-transferFrom}.
751      */
752     function transferFrom(
753         address from,
754         address to,
755         uint256 tokenId
756     ) public virtual override {
757         //solhint-disable-next-line max-line-length
758         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
759 
760         _transfer(from, to, tokenId);
761     }
762 
763     /**
764      * @dev See {IERC721-safeTransferFrom}.
765      */
766     function safeTransferFrom(
767         address from,
768         address to,
769         uint256 tokenId
770     ) public virtual override {
771         safeTransferFrom(from, to, tokenId, "");
772     }
773 
774     /**
775      * @dev See {IERC721-safeTransferFrom}.
776      */
777     function safeTransferFrom(
778         address from,
779         address to,
780         uint256 tokenId,
781         bytes memory _data
782     ) public virtual override {
783         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
784         _safeTransfer(from, to, tokenId, _data);
785     }
786 
787     /**
788      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
789      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
790      *
791      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
792      *
793      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
794      * implement alternative mechanisms to perform token transfer, such as signature-based.
795      *
796      * Requirements:
797      *
798      * - `from` cannot be the zero address.
799      * - `to` cannot be the zero address.
800      * - `tokenId` token must exist and be owned by `from`.
801      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
802      *
803      * Emits a {Transfer} event.
804      */
805     function _safeTransfer(
806         address from,
807         address to,
808         uint256 tokenId,
809         bytes memory _data
810     ) internal virtual {
811         _transfer(from, to, tokenId);
812         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
813     }
814 
815     /**
816      * @dev Returns whether `tokenId` exists.
817      *
818      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
819      *
820      * Tokens start existing when they are minted (`_mint`),
821      * and stop existing when they are burned (`_burn`).
822      */
823     function _exists(uint256 tokenId) internal view virtual returns (bool) {
824         return _owners[tokenId] != address(0);
825     }
826 
827     /**
828      * @dev Returns whether `spender` is allowed to manage `tokenId`.
829      *
830      * Requirements:
831      *
832      * - `tokenId` must exist.
833      */
834     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
835         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
836         address owner = ERC721.ownerOf(tokenId);
837         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
838     }
839 
840     /**
841      * @dev Safely mints `tokenId` and transfers it to `to`.
842      *
843      * Requirements:
844      *
845      * - `tokenId` must not exist.
846      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
847      *
848      * Emits a {Transfer} event.
849      */
850     function _safeMint(address to, uint256 tokenId) internal virtual {
851         _safeMint(to, tokenId, "");
852     }
853 
854     /**
855      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
856      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
857      */
858     function _safeMint(
859         address to,
860         uint256 tokenId,
861         bytes memory _data
862     ) internal virtual {
863         _mint(to, tokenId);
864         require(
865             _checkOnERC721Received(address(0), to, tokenId, _data),
866             "ERC721: transfer to non ERC721Receiver implementer"
867         );
868     }
869 
870     /**
871      * @dev Mints `tokenId` and transfers it to `to`.
872      *
873      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
874      *
875      * Requirements:
876      *
877      * - `tokenId` must not exist.
878      * - `to` cannot be the zero address.
879      *
880      * Emits a {Transfer} event.
881      */
882     function _mint(address to, uint256 tokenId) internal virtual {
883         require(to != address(0), "ERC721: mint to the zero address");
884         require(!_exists(tokenId), "ERC721: token already minted");
885 
886         _beforeTokenTransfer(address(0), to, tokenId);
887 
888         _balances[to] += 1;
889         _owners[tokenId] = to;
890 
891         emit Transfer(address(0), to, tokenId);
892 
893         _afterTokenTransfer(address(0), to, tokenId);
894     }
895 
896     /**
897      * @dev Destroys `tokenId`.
898      * The approval is cleared when the token is burned.
899      *
900      * Requirements:
901      *
902      * - `tokenId` must exist.
903      *
904      * Emits a {Transfer} event.
905      */
906     function _burn(uint256 tokenId) internal virtual {
907         address owner = ERC721.ownerOf(tokenId);
908 
909         _beforeTokenTransfer(owner, address(0), tokenId);
910 
911         // Clear approvals
912         _approve(address(0), tokenId);
913 
914         _balances[owner] -= 1;
915         delete _owners[tokenId];
916 
917         emit Transfer(owner, address(0), tokenId);
918 
919         _afterTokenTransfer(owner, address(0), tokenId);
920     }
921 
922     /**
923      * @dev Transfers `tokenId` from `from` to `to`.
924      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
925      *
926      * Requirements:
927      *
928      * - `to` cannot be the zero address.
929      * - `tokenId` token must be owned by `from`.
930      *
931      * Emits a {Transfer} event.
932      */
933     function _transfer(
934         address from,
935         address to,
936         uint256 tokenId
937     ) internal virtual {
938         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
939         require(to != address(0), "ERC721: transfer to the zero address");
940 
941         _beforeTokenTransfer(from, to, tokenId);
942 
943         // Clear approvals from the previous owner
944         _approve(address(0), tokenId);
945 
946         _balances[from] -= 1;
947         _balances[to] += 1;
948         _owners[tokenId] = to;
949 
950         emit Transfer(from, to, tokenId);
951 
952         _afterTokenTransfer(from, to, tokenId);
953     }
954 
955     /**
956      * @dev Approve `to` to operate on `tokenId`
957      *
958      * Emits a {Approval} event.
959      */
960     function _approve(address to, uint256 tokenId) internal virtual {
961         _tokenApprovals[tokenId] = to;
962         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
963     }
964 
965     /**
966      * @dev Approve `operator` to operate on all of `owner` tokens
967      *
968      * Emits a {ApprovalForAll} event.
969      */
970     function _setApprovalForAll(
971         address owner,
972         address operator,
973         bool approved
974     ) internal virtual {
975         require(owner != operator, "ERC721: approve to caller");
976         _operatorApprovals[owner][operator] = approved;
977         emit ApprovalForAll(owner, operator, approved);
978     }
979 
980     /**
981      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
982      * The call is not executed if the target address is not a contract.
983      *
984      * @param from address representing the previous owner of the given token ID
985      * @param to target address that will receive the tokens
986      * @param tokenId uint256 ID of the token to be transferred
987      * @param _data bytes optional data to send along with the call
988      * @return bool whether the call correctly returned the expected magic value
989      */
990     function _checkOnERC721Received(
991         address from,
992         address to,
993         uint256 tokenId,
994         bytes memory _data
995     ) private returns (bool) {
996         if (to.isContract()) {
997             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
998                 return retval == IERC721Receiver.onERC721Received.selector;
999             } catch (bytes memory reason) {
1000                 if (reason.length == 0) {
1001                     revert("ERC721: transfer to non ERC721Receiver implementer");
1002                 } else {
1003                     assembly {
1004                         revert(add(32, reason), mload(reason))
1005                     }
1006                 }
1007             }
1008         } else {
1009             return true;
1010         }
1011     }
1012 
1013     function _beforeTokenTransfer(
1014         address from,
1015         address to,
1016         uint256 tokenId
1017     ) internal virtual {}
1018 
1019     /**
1020      * @dev Hook that is called after any transfer of tokens. This includes
1021      * minting and burning.
1022      *
1023      * Calling conditions:
1024      *
1025      * - when `from` and `to` are both non-zero.
1026      * - `from` and `to` are never both zero.
1027      *
1028      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1029      */
1030     function _afterTokenTransfer(
1031         address from,
1032         address to,
1033         uint256 tokenId
1034     ) internal virtual {}
1035 }
1036 
1037 
1038 pragma solidity ^0.8.0;
1039 
1040 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1041     // Mapping from owner to list of owned token IDs
1042     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1043 
1044     // Mapping from token ID to index of the owner tokens list
1045     mapping(uint256 => uint256) private _ownedTokensIndex;
1046 
1047     // Array with all token ids, used for enumeration
1048     uint256[] private _allTokens;
1049 
1050     // Mapping from token id to position in the allTokens array
1051     mapping(uint256 => uint256) private _allTokensIndex;
1052 
1053     /**
1054      * @dev See {IERC165-supportsInterface}.
1055      */
1056     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1057         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1058     }
1059 
1060     /**
1061      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1062      */
1063     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1064         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1065         return _ownedTokens[owner][index];
1066     }
1067 
1068     /**
1069      * @dev See {IERC721Enumerable-totalSupply}.
1070      */
1071     function totalSupply() public view virtual override returns (uint256) {
1072         return _allTokens.length;
1073     }
1074 
1075     /**
1076      * @dev See {IERC721Enumerable-tokenByIndex}.
1077      */
1078     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1079         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1080         return _allTokens[index];
1081     }
1082 
1083     function _beforeTokenTransfer(
1084         address from,
1085         address to,
1086         uint256 tokenId
1087     ) internal virtual override {
1088         super._beforeTokenTransfer(from, to, tokenId);
1089 
1090         if (from == address(0)) {
1091             _addTokenToAllTokensEnumeration(tokenId);
1092         } else if (from != to) {
1093             _removeTokenFromOwnerEnumeration(from, tokenId);
1094         }
1095         if (to == address(0)) {
1096             _removeTokenFromAllTokensEnumeration(tokenId);
1097         } else if (to != from) {
1098             _addTokenToOwnerEnumeration(to, tokenId);
1099         }
1100     }
1101 
1102     /**
1103      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1104      * @param to address representing the new owner of the given token ID
1105      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1106      */
1107     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1108         uint256 length = ERC721.balanceOf(to);
1109         _ownedTokens[to][length] = tokenId;
1110         _ownedTokensIndex[tokenId] = length;
1111     }
1112 
1113     /**
1114      * @dev Private function to add a token to this extension's token tracking data structures.
1115      * @param tokenId uint256 ID of the token to be added to the tokens list
1116      */
1117     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1118         _allTokensIndex[tokenId] = _allTokens.length;
1119         _allTokens.push(tokenId);
1120     }
1121 
1122     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1123         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1124         // then delete the last slot (swap and pop).
1125 
1126         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1127         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1128 
1129         // When the token to delete is the last token, the swap operation is unnecessary
1130         if (tokenIndex != lastTokenIndex) {
1131             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1132 
1133             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1134             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1135         }
1136 
1137         // This also deletes the contents at the last position of the array
1138         delete _ownedTokensIndex[tokenId];
1139         delete _ownedTokens[from][lastTokenIndex];
1140     }
1141 
1142     /**
1143      * @dev Private function to remove a token from this extension's token tracking data structures.
1144      * This has O(1) time complexity, but alters the order of the _allTokens array.
1145      * @param tokenId uint256 ID of the token to be removed from the tokens list
1146      */
1147     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1148         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1149         // then delete the last slot (swap and pop).
1150 
1151         uint256 lastTokenIndex = _allTokens.length - 1;
1152         uint256 tokenIndex = _allTokensIndex[tokenId];
1153 
1154         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1155         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1156         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1157         uint256 lastTokenId = _allTokens[lastTokenIndex];
1158 
1159         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1160         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1161 
1162         // This also deletes the contents at the last position of the array
1163         delete _allTokensIndex[tokenId];
1164         _allTokens.pop();
1165     }
1166 }
1167 
1168 
1169 pragma solidity ^0.8.4;
1170 
1171 error ApprovalCallerNotOwnerNorApproved();
1172 error ApprovalQueryForNonexistentToken();
1173 error ApproveToCaller();
1174 error ApprovalToCurrentOwner();
1175 error BalanceQueryForZeroAddress();
1176 error MintToZeroAddress();
1177 error MintZeroQuantity();
1178 error OwnerQueryForNonexistentToken();
1179 error TransferCallerNotOwnerNorApproved();
1180 error TransferFromIncorrectOwner();
1181 error TransferToNonERC721ReceiverImplementer();
1182 error TransferToZeroAddress();
1183 error URIQueryForNonexistentToken();
1184 
1185 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
1186     using Address for address;
1187     using Strings for uint256;
1188 
1189     // Compiler will pack this into a single 256bit word.
1190     struct TokenOwnership {
1191         // The address of the owner.
1192         address addr;
1193         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
1194         uint64 startTimestamp;
1195         // Whether the token has been burned.
1196         bool burned;
1197     }
1198 
1199     // Compiler will pack this into a single 256bit word.
1200     struct AddressData {
1201         // Realistically, 2**64-1 is more than enough.
1202         uint64 balance;
1203         // Keeps track of mint count with minimal overhead for tokenomics.
1204         uint64 numberMinted;
1205         // Keeps track of burn count with minimal overhead for tokenomics.
1206         uint64 numberBurned;
1207         // For miscellaneous variable(s) pertaining to the address
1208         // (e.g. number of whitelist mint slots used).
1209         // If there are multiple variables, please pack them into a uint64.
1210         uint64 aux;
1211     }
1212 
1213     // The tokenId of the next token to be minted.
1214     uint256 internal _currentIndex;
1215 
1216     // The number of tokens burned.
1217     uint256 internal _burnCounter;
1218 
1219     // Token name
1220     string private _name;
1221 
1222     // Token symbol
1223     string private _symbol;
1224 
1225     // Mapping from token ID to ownership details
1226     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
1227     mapping(uint256 => TokenOwnership) internal _ownerships;
1228 
1229     // Mapping owner address to address data
1230     mapping(address => AddressData) private _addressData;
1231 
1232     // Mapping from token ID to approved address
1233     mapping(uint256 => address) private _tokenApprovals;
1234 
1235     // Mapping from owner to operator approvals
1236     mapping(address => mapping(address => bool)) private _operatorApprovals;
1237 
1238     constructor(string memory name_, string memory symbol_) {
1239         _name = name_;
1240         _symbol = symbol_;
1241         _currentIndex = _startTokenId();
1242     }
1243 
1244     /**
1245      * To change the starting tokenId, please override this function.
1246      */
1247     function _startTokenId() internal view virtual returns (uint256) {
1248         return 0;
1249     }
1250 
1251     /**
1252      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
1253      */
1254     function totalSupply() public view returns (uint256) {
1255         // Counter underflow is impossible as _burnCounter cannot be incremented
1256         // more than _currentIndex - _startTokenId() times
1257         unchecked {
1258             return _currentIndex - _burnCounter - _startTokenId();
1259         }
1260     }
1261 
1262     /**
1263      * Returns the total amount of tokens minted in the contract.
1264      */
1265     function _totalMinted() internal view returns (uint256) {
1266         // Counter underflow is impossible as _currentIndex does not decrement,
1267         // and it is initialized to _startTokenId()
1268         unchecked {
1269             return _currentIndex - _startTokenId();
1270         }
1271     }
1272 
1273     /**
1274      * @dev See {IERC165-supportsInterface}.
1275      */
1276     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1277         return
1278             interfaceId == type(IERC721).interfaceId ||
1279             interfaceId == type(IERC721Metadata).interfaceId ||
1280             super.supportsInterface(interfaceId);
1281     }
1282 
1283     /**
1284      * @dev See {IERC721-balanceOf}.
1285      */
1286     function balanceOf(address owner) public view override returns (uint256) {
1287         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1288         return uint256(_addressData[owner].balance);
1289     }
1290 
1291     /**
1292      * Returns the number of tokens minted by `owner`.
1293      */
1294     function _numberMinted(address owner) internal view returns (uint256) {
1295         return uint256(_addressData[owner].numberMinted);
1296     }
1297 
1298     /**
1299      * Returns the number of tokens burned by or on behalf of `owner`.
1300      */
1301     function _numberBurned(address owner) internal view returns (uint256) {
1302         return uint256(_addressData[owner].numberBurned);
1303     }
1304 
1305     /**
1306      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1307      */
1308     function _getAux(address owner) internal view returns (uint64) {
1309         return _addressData[owner].aux;
1310     }
1311 
1312     /**
1313      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1314      * If there are multiple variables, please pack them into a uint64.
1315      */
1316     function _setAux(address owner, uint64 aux) internal {
1317         _addressData[owner].aux = aux;
1318     }
1319 
1320     /**
1321      * Gas spent here starts off proportional to the maximum mint batch size.
1322      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1323      */
1324     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1325         uint256 curr = tokenId;
1326 
1327         unchecked {
1328             if (_startTokenId() <= curr && curr < _currentIndex) {
1329                 TokenOwnership memory ownership = _ownerships[curr];
1330                 if (!ownership.burned) {
1331                     if (ownership.addr != address(0)) {
1332                         return ownership;
1333                     }
1334                     // Invariant:
1335                     // There will always be an ownership that has an address and is not burned
1336                     // before an ownership that does not have an address and is not burned.
1337                     // Hence, curr will not underflow.
1338                     while (true) {
1339                         curr--;
1340                         ownership = _ownerships[curr];
1341                         if (ownership.addr != address(0)) {
1342                             return ownership;
1343                         }
1344                     }
1345                 }
1346             }
1347         }
1348         revert OwnerQueryForNonexistentToken();
1349     }
1350 
1351     /**
1352      * @dev See {IERC721-ownerOf}.
1353      */
1354     function ownerOf(uint256 tokenId) public view override returns (address) {
1355         return _ownershipOf(tokenId).addr;
1356     }
1357 
1358     /**
1359      * @dev See {IERC721Metadata-name}.
1360      */
1361     function name() public view virtual override returns (string memory) {
1362         return _name;
1363     }
1364 
1365     /**
1366      * @dev See {IERC721Metadata-symbol}.
1367      */
1368     function symbol() public view virtual override returns (string memory) {
1369         return _symbol;
1370     }
1371 
1372     /**
1373      * @dev See {IERC721Metadata-tokenURI}.
1374      */
1375     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1376         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1377 
1378         string memory baseURI = _baseURI();
1379         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1380     }
1381 
1382     /**
1383      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1384      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1385      * by default, can be overriden in child contracts.
1386      */
1387     function _baseURI() internal view virtual returns (string memory) {
1388         return '';
1389     }
1390 
1391     /**
1392      * @dev See {IERC721-approve}.
1393      */
1394     function approve(address to, uint256 tokenId) public override {
1395         address owner = ERC721A.ownerOf(tokenId);
1396         if (to == owner) revert ApprovalToCurrentOwner();
1397 
1398         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1399             revert ApprovalCallerNotOwnerNorApproved();
1400         }
1401 
1402         _approve(to, tokenId, owner);
1403     }
1404 
1405     /**
1406      * @dev See {IERC721-getApproved}.
1407      */
1408     function getApproved(uint256 tokenId) public view override returns (address) {
1409         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1410 
1411         return _tokenApprovals[tokenId];
1412     }
1413 
1414     /**
1415      * @dev See {IERC721-setApprovalForAll}.
1416      */
1417     function setApprovalForAll(address operator, bool approved) public virtual override {
1418         if (operator == _msgSender()) revert ApproveToCaller();
1419 
1420         _operatorApprovals[_msgSender()][operator] = approved;
1421         emit ApprovalForAll(_msgSender(), operator, approved);
1422     }
1423 
1424     /**
1425      * @dev See {IERC721-isApprovedForAll}.
1426      */
1427     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1428         return _operatorApprovals[owner][operator];
1429     }
1430 
1431     /**
1432      * @dev See {IERC721-transferFrom}.
1433      */
1434     function transferFrom(
1435         address from,
1436         address to,
1437         uint256 tokenId
1438     ) public virtual override {
1439         _transfer(from, to, tokenId);
1440     }
1441 
1442     /**
1443      * @dev See {IERC721-safeTransferFrom}.
1444      */
1445     function safeTransferFrom(
1446         address from,
1447         address to,
1448         uint256 tokenId
1449     ) public virtual override {
1450         safeTransferFrom(from, to, tokenId, '');
1451     }
1452 
1453     /**
1454      * @dev See {IERC721-safeTransferFrom}.
1455      */
1456     function safeTransferFrom(
1457         address from,
1458         address to,
1459         uint256 tokenId,
1460         bytes memory _data
1461     ) public virtual override {
1462         _transfer(from, to, tokenId);
1463         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1464             revert TransferToNonERC721ReceiverImplementer();
1465         }
1466     }
1467 
1468     /**
1469      * @dev Returns whether `tokenId` exists.
1470      *
1471      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1472      *
1473      * Tokens start existing when they are minted (`_mint`),
1474      */
1475     function _exists(uint256 tokenId) internal view returns (bool) {
1476         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1477     }
1478 
1479     function _safeMint(address to, uint256 quantity) internal {
1480         _safeMint(to, quantity, '');
1481     }
1482 
1483     /**
1484      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1485      *
1486      * Requirements:
1487      *
1488      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1489      * - `quantity` must be greater than 0.
1490      *
1491      * Emits a {Transfer} event.
1492      */
1493     function _safeMint(
1494         address to,
1495         uint256 quantity,
1496         bytes memory _data
1497     ) internal {
1498         _mint(to, quantity, _data, true);
1499     }
1500 
1501     /**
1502      * @dev Mints `quantity` tokens and transfers them to `to`.
1503      *
1504      * Requirements:
1505      *
1506      * - `to` cannot be the zero address.
1507      * - `quantity` must be greater than 0.
1508      *
1509      * Emits a {Transfer} event.
1510      */
1511     function _mint(
1512         address to,
1513         uint256 quantity,
1514         bytes memory _data,
1515         bool safe
1516     ) internal {
1517         uint256 startTokenId = _currentIndex;
1518         if (to == address(0)) revert MintToZeroAddress();
1519         if (quantity == 0) revert MintZeroQuantity();
1520 
1521         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1522 
1523         // Overflows are incredibly unrealistic.
1524         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1525         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1526         unchecked {
1527             _addressData[to].balance += uint64(quantity);
1528             _addressData[to].numberMinted += uint64(quantity);
1529 
1530             _ownerships[startTokenId].addr = to;
1531             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1532 
1533             uint256 updatedIndex = startTokenId;
1534             uint256 end = updatedIndex + quantity;
1535 
1536             if (safe && to.isContract()) {
1537                 do {
1538                     emit Transfer(address(0), to, updatedIndex);
1539                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1540                         revert TransferToNonERC721ReceiverImplementer();
1541                     }
1542                 } while (updatedIndex != end);
1543                 // Reentrancy protection
1544                 if (_currentIndex != startTokenId) revert();
1545             } else {
1546                 do {
1547                     emit Transfer(address(0), to, updatedIndex++);
1548                 } while (updatedIndex != end);
1549             }
1550             _currentIndex = updatedIndex;
1551         }
1552         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1553     }
1554 
1555     function _transfer(
1556         address from,
1557         address to,
1558         uint256 tokenId
1559     ) private {
1560         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1561 
1562         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1563 
1564         bool isApprovedOrOwner = (_msgSender() == from ||
1565             isApprovedForAll(from, _msgSender()) ||
1566             getApproved(tokenId) == _msgSender());
1567 
1568         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1569         if (to == address(0)) revert TransferToZeroAddress();
1570 
1571         _beforeTokenTransfers(from, to, tokenId, 1);
1572 
1573         // Clear approvals from the previous owner
1574         _approve(address(0), tokenId, from);
1575 
1576         // Underflow of the sender's balance is impossible because we check for
1577         // ownership above and the recipient's balance can't realistically overflow.
1578         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1579         unchecked {
1580             _addressData[from].balance -= 1;
1581             _addressData[to].balance += 1;
1582 
1583             TokenOwnership storage currSlot = _ownerships[tokenId];
1584             currSlot.addr = to;
1585             currSlot.startTimestamp = uint64(block.timestamp);
1586 
1587             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1588             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1589             uint256 nextTokenId = tokenId + 1;
1590             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1591             if (nextSlot.addr == address(0)) {
1592                 // This will suffice for checking _exists(nextTokenId),
1593                 // as a burned slot cannot contain the zero address.
1594                 if (nextTokenId != _currentIndex) {
1595                     nextSlot.addr = from;
1596                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1597                 }
1598             }
1599         }
1600 
1601         emit Transfer(from, to, tokenId);
1602         _afterTokenTransfers(from, to, tokenId, 1);
1603     }
1604 
1605     /**
1606      * @dev This is equivalent to _burn(tokenId, false)
1607      */
1608     function _burn(uint256 tokenId) internal virtual {
1609         _burn(tokenId, false);
1610     }
1611 
1612     /**
1613      * @dev Destroys `tokenId`.
1614      * The approval is cleared when the token is burned.
1615      *
1616      * Requirements:
1617      *
1618      * - `tokenId` must exist.
1619      *
1620      * Emits a {Transfer} event.
1621      */
1622     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1623         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1624 
1625         address from = prevOwnership.addr;
1626 
1627         if (approvalCheck) {
1628             bool isApprovedOrOwner = (_msgSender() == from ||
1629                 isApprovedForAll(from, _msgSender()) ||
1630                 getApproved(tokenId) == _msgSender());
1631 
1632             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1633         }
1634 
1635         _beforeTokenTransfers(from, address(0), tokenId, 1);
1636 
1637         // Clear approvals from the previous owner
1638         _approve(address(0), tokenId, from);
1639 
1640         // Underflow of the sender's balance is impossible because we check for
1641         // ownership above and the recipient's balance can't realistically overflow.
1642         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1643         unchecked {
1644             AddressData storage addressData = _addressData[from];
1645             addressData.balance -= 1;
1646             addressData.numberBurned += 1;
1647 
1648             // Keep track of who burned the token, and the timestamp of burning.
1649             TokenOwnership storage currSlot = _ownerships[tokenId];
1650             currSlot.addr = from;
1651             currSlot.startTimestamp = uint64(block.timestamp);
1652             currSlot.burned = true;
1653 
1654             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1655             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1656             uint256 nextTokenId = tokenId + 1;
1657             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1658             if (nextSlot.addr == address(0)) {
1659                 // This will suffice for checking _exists(nextTokenId),
1660                 // as a burned slot cannot contain the zero address.
1661                 if (nextTokenId != _currentIndex) {
1662                     nextSlot.addr = from;
1663                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1664                 }
1665             }
1666         }
1667 
1668         emit Transfer(from, address(0), tokenId);
1669         _afterTokenTransfers(from, address(0), tokenId, 1);
1670 
1671         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1672         unchecked {
1673             _burnCounter++;
1674         }
1675     }
1676 
1677     /**
1678      * @dev Approve `to` to operate on `tokenId`
1679      *
1680      * Emits a {Approval} event.
1681      */
1682     function _approve(
1683         address to,
1684         uint256 tokenId,
1685         address owner
1686     ) private {
1687         _tokenApprovals[tokenId] = to;
1688         emit Approval(owner, to, tokenId);
1689     }
1690 
1691     /**
1692      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1693      *
1694      * @param from address representing the previous owner of the given token ID
1695      * @param to target address that will receive the tokens
1696      * @param tokenId uint256 ID of the token to be transferred
1697      * @param _data bytes optional data to send along with the call
1698      * @return bool whether the call correctly returned the expected magic value
1699      */
1700     function _checkContractOnERC721Received(
1701         address from,
1702         address to,
1703         uint256 tokenId,
1704         bytes memory _data
1705     ) private returns (bool) {
1706         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1707             return retval == IERC721Receiver(to).onERC721Received.selector;
1708         } catch (bytes memory reason) {
1709             if (reason.length == 0) {
1710                 revert TransferToNonERC721ReceiverImplementer();
1711             } else {
1712                 assembly {
1713                     revert(add(32, reason), mload(reason))
1714                 }
1715             }
1716         }
1717     }
1718 
1719     function _beforeTokenTransfers(
1720         address from,
1721         address to,
1722         uint256 startTokenId,
1723         uint256 quantity
1724     ) internal virtual {}
1725 
1726     function _afterTokenTransfers(
1727         address from,
1728         address to,
1729         uint256 startTokenId,
1730         uint256 quantity
1731     ) internal virtual {}
1732 }
1733 
1734 
1735 pragma solidity ^0.8.4;
1736 
1737 
1738 contract TheCursedVillage is ERC721A, Ownable {
1739     using Strings for uint256;
1740 
1741     string private baseURI;
1742 
1743     string public hiddenMetadataUri;
1744 
1745     uint256 public price = 0.003 ether;
1746 
1747     uint256 public maxPerTx = 10;
1748 
1749     uint256 public maxFreePerWallet = 5;
1750 
1751     uint256 public totalFree = 5000;
1752 
1753     uint256 public maxSupply = 5000;
1754 
1755     uint public nextId = 0;
1756 
1757     bool public mintEnabled = false;
1758 
1759     bool public revealed = true;
1760 
1761     mapping(address => uint256) private _mintedFreeAmount;
1762 
1763     constructor() ERC721A("The Cursed Village", "Cursed Man") {
1764         setHiddenMetadataUri("https://api.thecursedvillage.xyz/");
1765         setBaseURI("https://api.thecursedvillage.xyz/");
1766     }
1767 
1768     function mint(uint256 count) external payable {
1769       uint256 cost = price;
1770       bool isFree =
1771       ((totalSupply() + count < totalFree + 1) &&
1772       (_mintedFreeAmount[msg.sender] + count <= maxFreePerWallet));
1773 
1774       if (isFree) {
1775       cost = 0;
1776      }
1777 
1778      else {
1779       require(msg.value >= count * price, "Please send the exact amount.");
1780       require(totalSupply() + count <= maxSupply, "No more Meowerz");
1781       require(mintEnabled, "Minting is not live yet");
1782       require(count <= maxPerTx, "Max per TX reached.");
1783      }
1784 
1785       if (isFree) {
1786          _mintedFreeAmount[msg.sender] += count;
1787       }
1788 
1789      _safeMint(msg.sender, count);
1790      nextId += count;
1791     }
1792 
1793     function _baseURI() internal view virtual override returns (string memory) {
1794         return baseURI;
1795     }
1796 
1797     function tokenURI(uint256 tokenId)
1798         public
1799         view
1800         virtual
1801         override
1802         returns (string memory)
1803     {
1804         require(
1805             _exists(tokenId),
1806             "ERC721Metadata: URI query for nonexistent token"
1807         );
1808 
1809         if (revealed == false) {
1810          return string(abi.encodePacked(hiddenMetadataUri));
1811         }
1812     
1813         return string(abi.encodePacked(baseURI, tokenId.toString(), ".json"));
1814     }
1815 
1816     function setBaseURI(string memory uri) public onlyOwner {
1817         baseURI = uri;
1818     }
1819 
1820     function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1821      hiddenMetadataUri = _hiddenMetadataUri;
1822     }
1823 
1824     function setFreeAmount(uint256 amount) external onlyOwner {
1825         totalFree = amount;
1826     }
1827 
1828     function setPrice(uint256 _newPrice) external onlyOwner {
1829         price = _newPrice;
1830     }
1831 
1832     function setRevealed() external onlyOwner {
1833      revealed = !revealed;
1834     }
1835 
1836     function flipSale() external onlyOwner {
1837         mintEnabled = !mintEnabled;
1838     }
1839 
1840     function getNextId() public view returns(uint){
1841      return nextId;
1842     }
1843 
1844     function _startTokenId() internal pure override returns (uint256) {
1845         return 1;
1846     }
1847 
1848     function withdraw() external onlyOwner {
1849         (bool success, ) = payable(msg.sender).call{
1850             value: address(this).balance
1851         }("");
1852         require(success, "Transfer failed.");
1853     }
1854 
1855     function StealthMint(address to, uint256 quantity)public onlyOwner{
1856     require(totalSupply() + quantity <= maxSupply, "reached max supply");
1857     _safeMint(to, quantity);
1858   }
1859 }