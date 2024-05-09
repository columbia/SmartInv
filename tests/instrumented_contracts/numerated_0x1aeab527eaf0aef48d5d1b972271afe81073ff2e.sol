1 // File: Faith In Chivalry.sol
2 
3 
4 
5 pragma solidity ^0.8.0;
6 
7 library Counters {
8     struct Counter {
9 
10         uint256 _value; // default: 0
11     }
12 
13     function current(Counter storage counter) internal view returns (uint256) {
14         return counter._value;
15     }
16 
17     function increment(Counter storage counter) internal {
18         unchecked {
19             counter._value += 1;
20         }
21     }
22 
23     function decrement(Counter storage counter) internal {
24         uint256 value = counter._value;
25         require(value > 0, "Counter:decrement overflow");
26         unchecked {
27             counter._value = value - 1;
28         }
29     }
30 
31     function reset(Counter storage counter) internal {
32         counter._value = 0;
33     }
34 }
35 
36 
37 pragma solidity ^0.8.0;
38 
39 /**
40  * @dev String operations.
41  */
42 library Strings {
43     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
44 
45     /**
46      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
47      */
48     function toString(uint256 value) internal pure returns (string memory) {
49         // Inspired by OraclizeAPI's implementation - MIT licence
50         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
51 
52         if (value == 0) {
53             return "0";
54         }
55         uint256 temp = value;
56         uint256 digits;
57         while (temp != 0) {
58             digits++;
59             temp /= 10;
60         }
61         bytes memory buffer = new bytes(digits);
62         while (value != 0) {
63             digits -= 1;
64             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
65             value /= 10;
66         }
67         return string(buffer);
68     }
69 
70     /**
71      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
72      */
73     function toHexString(uint256 value) internal pure returns (string memory) {
74         if (value == 0) {
75             return "0x00";
76         }
77         uint256 temp = value;
78         uint256 length = 0;
79         while (temp != 0) {
80             length++;
81             temp >>= 8;
82         }
83         return toHexString(value, length);
84     }
85 
86     /**
87      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
88      */
89     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
90         bytes memory buffer = new bytes(2 * length + 2);
91         buffer[0] = "0";
92         buffer[1] = "x";
93         for (uint256 i = 2 * length + 1; i > 1; --i) {
94             buffer[i] = _HEX_SYMBOLS[value & 0xf];
95             value >>= 4;
96         }
97         require(value == 0, "Strings: hex length insufficient");
98         return string(buffer);
99     }
100 }
101 
102 pragma solidity ^0.8.0;
103 
104 /**
105  * @dev Provides information about the current execution context, including the
106  * sender of the transaction and its data. While these are generally available
107  * via msg.sender and msg.data, they should not be accessed in such a direct
108  * manner, since when dealing with meta-transactions the account sending and
109  * paying for execution may not be the actual sender (as far as an application
110  * is concerned).
111  *
112  * This contract is only required for intermediate, library-like contracts.
113  */
114 abstract contract Context {
115     function _msgSender() internal view virtual returns (address) {
116         return msg.sender;
117     }
118 
119     function _msgData() internal view virtual returns (bytes calldata) {
120         return msg.data;
121     }
122 }
123 
124 
125 pragma solidity ^0.8.0;
126 
127 abstract contract Ownable is Context {
128     address private _owner;
129 
130     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
131 
132     /**
133      * @dev Initializes the contract setting the deployer as the initial owner.
134      */
135     constructor() {
136         _transferOwnership(_msgSender());
137     }
138 
139     /**
140      * @dev Returns the address of the current owner.
141      */
142     function owner() public view virtual returns (address) {
143         return _owner;
144     }
145 
146     /**
147      * @dev Throws if called by any account other than the owner.
148      */
149     modifier onlyOwner() {
150         require(owner() == _msgSender(), "Ownable: caller is not the owner");
151         _;
152     }
153 
154     /**
155      * @dev Leaves the contract without owner. It will not be possible to call
156      * `onlyOwner` functions anymore. Can only be called by the current owner.
157      *
158      * NOTE: Renouncing ownership will leave the contract without an owner,
159      * thereby removing any functionality that is only available to the owner.
160      */
161     function renounceOwnership() public virtual onlyOwner {
162         _transferOwnership(address(0));
163     }
164 
165     /**
166      * @dev Transfers ownership of the contract to a new account (`newOwner`).
167      * Can only be called by the current owner.
168      */
169     function transferOwnership(address newOwner) public virtual onlyOwner {
170         require(newOwner != address(0), "Ownable: new owner is the zero address");
171         _transferOwnership(newOwner);
172     }
173 
174     /**
175      * @dev Transfers ownership of the contract to a new account (`newOwner`).
176      * Internal function without access restriction.
177      */
178     function _transferOwnership(address newOwner) internal virtual {
179         address oldOwner = _owner;
180         _owner = newOwner;
181         emit OwnershipTransferred(oldOwner, newOwner);
182     }
183 }
184 
185 pragma solidity ^0.8.1;
186 
187 /**
188  * @dev Collection of functions related to the address type
189  */
190 library Address {
191     /**
192      * @dev Returns true if `account` is a contract.
193      *
194      * [IMPORTANT]
195      * ====
196      * It is unsafe to assume that an address for which this function returns
197      * false is an externally-owned account (EOA) and not a contract.
198      *
199      * Among others, `isContract` will return false for the following
200      * types of addresses:
201      *
202      *  - an externally-owned account
203      *  - a contract in construction
204      *  - an address where a contract will be created
205      *  - an address where a contract lived, but was destroyed
206      * ====
207      *
208      * [IMPORTANT]
209      * ====
210      * You shouldn't rely on `isContract` to protect against flash loan attacks!
211      *
212      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
213      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
214      * constructor.
215      * ====
216      */
217     function isContract(address account) internal view returns (bool) {
218         // This method relies on extcodesize/address.code.length, which returns 0
219         // for contracts in construction, since the code is only stored at the end
220         // of the constructor execution.
221 
222         return account.code.length > 0;
223     }
224 
225     /**
226      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
227      * `recipient`, forwarding all available gas and reverting on errors.
228      *
229      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
230      * of certain opcodes, possibly making contracts go over the 2300 gas limit
231      * imposed by `transfer`, making them unable to receive funds via
232      * `transfer`. {sendValue} removes this limitation.
233      *
234      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
235      *
236      * IMPORTANT: because control is transferred to `recipient`, care must be
237      * taken to not create reentrancy vulnerabilities. Consider using
238      * {ReentrancyGuard} or the
239      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
240      */
241     function sendValue(address payable recipient, uint256 amount) internal {
242         require(address(this).balance >= amount, "Address: insufficient balance");
243 
244         (bool success, ) = recipient.call{value: amount}("");
245         require(success, "Address: unable to send value, recipient may have reverted");
246     }
247 
248     /**
249      * @dev Performs a Solidity function call using a low level `call`. A
250      * plain `call` is an unsafe replacement for a function call: use this
251      * function instead.
252      *
253      * If `target` reverts with a revert reason, it is bubbled up by this
254      * function (like regular Solidity function calls).
255      *
256      * Returns the raw returned data. To convert to the expected return value,
257      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
258      *
259      * Requirements:
260      *
261      * - `target` must be a contract.
262      * - calling `target` with `data` must not revert.
263      *
264      * _Available since v3.1._
265      */
266     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
267         return functionCall(target, data, "Address: low-level call failed");
268     }
269 
270     /**
271      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
272      * `errorMessage` as a fallback revert reason when `target` reverts.
273      *
274      * _Available since v3.1._
275      */
276     function functionCall(
277         address target,
278         bytes memory data,
279         string memory errorMessage
280     ) internal returns (bytes memory) {
281         return functionCallWithValue(target, data, 0, errorMessage);
282     }
283 
284     /**
285      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
286      * but also transferring `value` wei to `target`.
287      *
288      * Requirements:
289      *
290      * - the calling contract must have an ETH balance of at least `value`.
291      * - the called Solidity function must be `payable`.
292      *
293      * _Available since v3.1._
294      */
295     function functionCallWithValue(
296         address target,
297         bytes memory data,
298         uint256 value
299     ) internal returns (bytes memory) {
300         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
301     }
302 
303     /**
304      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
305      * with `errorMessage` as a fallback revert reason when `target` reverts.
306      *
307      * _Available since v3.1._
308      */
309     function functionCallWithValue(
310         address target,
311         bytes memory data,
312         uint256 value,
313         string memory errorMessage
314     ) internal returns (bytes memory) {
315         require(address(this).balance >= value, "Address: insufficient balance for call");
316         require(isContract(target), "Address: call to non-contract");
317 
318         (bool success, bytes memory returndata) = target.call{value: value}(data);
319         return verifyCallResult(success, returndata, errorMessage);
320     }
321 
322     /**
323      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
324      * but performing a static call.
325      *
326      * _Available since v3.3._
327      */
328     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
329         return functionStaticCall(target, data, "Address: low-level static call failed");
330     }
331 
332     /**
333      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
334      * but performing a static call.
335      *
336      * _Available since v3.3._
337      */
338     function functionStaticCall(
339         address target,
340         bytes memory data,
341         string memory errorMessage
342     ) internal view returns (bytes memory) {
343         require(isContract(target), "Address: static call to non-contract");
344 
345         (bool success, bytes memory returndata) = target.staticcall(data);
346         return verifyCallResult(success, returndata, errorMessage);
347     }
348 
349     /**
350      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
351      * but performing a delegate call.
352      *
353      * _Available since v3.4._
354      */
355     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
356         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
357     }
358 
359     /**
360      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
361      * but performing a delegate call.
362      *
363      * _Available since v3.4._
364      */
365     function functionDelegateCall(
366         address target,
367         bytes memory data,
368         string memory errorMessage
369     ) internal returns (bytes memory) {
370         require(isContract(target), "Address: delegate call to non-contract");
371 
372         (bool success, bytes memory returndata) = target.delegatecall(data);
373         return verifyCallResult(success, returndata, errorMessage);
374     }
375 
376     /**
377      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
378      * revert reason using the provided one.
379      *
380      * _Available since v4.3._
381      */
382     function verifyCallResult(
383         bool success,
384         bytes memory returndata,
385         string memory errorMessage
386     ) internal pure returns (bytes memory) {
387         if (success) {
388             return returndata;
389         } else {
390             // Look for revert reason and bubble it up if present
391             if (returndata.length > 0) {
392                 // The easiest way to bubble the revert reason is using memory via assembly
393 
394                 assembly {
395                     let returndata_size := mload(returndata)
396                     revert(add(32, returndata), returndata_size)
397                 }
398             } else {
399                 revert(errorMessage);
400             }
401         }
402     }
403 }
404 
405 pragma solidity ^0.8.0;
406 
407 /**
408  * @title ERC721 token receiver interface
409  * @dev Interface for any contract that wants to support safeTransfers
410  * from ERC721 asset contracts.
411  */
412 interface IERC721Receiver {
413     /**
414      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
415      * by `operator` from `from`, this function is called.
416      *
417      * It must return its Solidity selector to confirm the token transfer.
418      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
419      *
420      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
421      */
422     function onERC721Received(
423         address operator,
424         address from,
425         uint256 tokenId,
426         bytes calldata data
427     ) external returns (bytes4);
428 }
429 
430 pragma solidity ^0.8.0;
431 
432 /**
433  * @dev Interface of the ERC165 standard, as defined in the
434  * https://eips.ethereum.org/EIPS/eip-165[EIP].
435  *
436  * Implementers can declare support of contract interfaces, which can then be
437  * queried by others ({ERC165Checker}).
438  *
439  * For an implementation, see {ERC165}.
440  */
441 interface IERC165 {
442     /**
443      * @dev Returns true if this contract implements the interface defined by
444      * `interfaceId`. See the corresponding
445      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
446      * to learn more about how these ids are created.
447      *
448      * This function call must use less than 30 000 gas.
449      */
450     function supportsInterface(bytes4 interfaceId) external view returns (bool);
451 }
452 
453 pragma solidity ^0.8.0;
454 
455 abstract contract ERC165 is IERC165 {
456     /**
457      * @dev See {IERC165-supportsInterface}.
458      */
459     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
460         return interfaceId == type(IERC165).interfaceId;
461     }
462 }
463 
464 pragma solidity ^0.8.0;
465 
466 interface IERC721 is IERC165 {
467     /**
468      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
469      */
470     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
471 
472     /**
473      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
474      */
475     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
476 
477     /**
478      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
479      */
480     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
481 
482     /**
483      * @dev Returns the number of tokens in ``owner``'s account.
484      */
485     function balanceOf(address owner) external view returns (uint256 balance);
486 
487     /**
488      * @dev Returns the owner of the `tokenId` token.
489      *
490      * Requirements:
491      *
492      * - `tokenId` must exist.
493      */
494     function ownerOf(uint256 tokenId) external view returns (address owner);
495 
496     function safeTransferFrom(
497         address from,
498         address to,
499         uint256 tokenId
500     ) external;
501 
502     function transferFrom(
503         address from,
504         address to,
505         uint256 tokenId
506     ) external;
507 
508     function approve(address to, uint256 tokenId) external;
509 
510     /**
511      * @dev Returns the account approved for `tokenId` token.
512      *
513      * Requirements:
514      *
515      * - `tokenId` must exist.
516      */
517     function getApproved(uint256 tokenId) external view returns (address operator);
518 
519     /**
520      * @dev Approve or remove `operator` as an operator for the caller.
521      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
522      *
523      * Requirements:
524      *
525      * - The `operator` cannot be the caller.
526      *
527      * Emits an {ApprovalForAll} event.
528      */
529     function setApprovalForAll(address operator, bool _approved) external;
530 
531     /**
532      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
533      *
534      * See {setApprovalForAll}
535      */
536     function isApprovedForAll(address owner, address operator) external view returns (bool);
537 
538     /**
539      * @dev Safely transfers `tokenId` token from `from` to `to`.
540      *
541      * Requirements:
542      *
543      * - `from` cannot be the zero address.
544      * - `to` cannot be the zero address.
545      * - `tokenId` token must exist and be owned by `from`.
546      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
547      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
548      *
549      * Emits a {Transfer} event.
550      */
551     function safeTransferFrom(
552         address from,
553         address to,
554         uint256 tokenId,
555         bytes calldata data
556     ) external;
557 }
558 
559 
560 pragma solidity ^0.8.0;
561 
562 
563 /**
564  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
565  * @dev See https://eips.ethereum.org/EIPS/eip-721
566  */
567 interface IERC721Enumerable is IERC721 {
568     /**
569      * @dev Returns the total amount of tokens stored by the contract.
570      */
571     function totalSupply() external view returns (uint256);
572 
573     /**
574      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
575      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
576      */
577     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
578 
579     /**
580      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
581      * Use along with {totalSupply} to enumerate all tokens.
582      */
583     function tokenByIndex(uint256 index) external view returns (uint256);
584 }
585 
586 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
587 
588 
589 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
590 
591 pragma solidity ^0.8.0;
592 
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
615 
616 pragma solidity ^0.8.0;
617 
618 /**
619  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
620  * the Metadata extension, but not including the Enumerable extension, which is available separately as
621  * {ERC721Enumerable}.
622  */
623 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
624     using Address for address;
625     using Strings for uint256;
626 
627     // Token name
628     string private _name;
629 
630     // Token symbol
631     string private _symbol;
632 
633     // Mapping from token ID to owner address
634     mapping(uint256 => address) private _owners;
635 
636     // Mapping owner address to token count
637     mapping(address => uint256) private _balances;
638 
639     // Mapping from token ID to approved address
640     mapping(uint256 => address) private _tokenApprovals;
641 
642     // Mapping from owner to operator approvals
643     mapping(address => mapping(address => bool)) private _operatorApprovals;
644 
645     /**
646      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
647      */
648     constructor(string memory name_, string memory symbol_) {
649         _name = name_;
650         _symbol = symbol_;
651     }
652 
653     /**
654      * @dev See {IERC165-supportsInterface}.
655      */
656     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
657         return
658             interfaceId == type(IERC721).interfaceId ||
659             interfaceId == type(IERC721Metadata).interfaceId ||
660             super.supportsInterface(interfaceId);
661     }
662 
663     /**
664      * @dev See {IERC721-balanceOf}.
665      */
666     function balanceOf(address owner) public view virtual override returns (uint256) {
667         require(owner != address(0), "ERC721: balance query for the zero address");
668         return _balances[owner];
669     }
670 
671     /**
672      * @dev See {IERC721-ownerOf}.
673      */
674     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
675         address owner = _owners[tokenId];
676         require(owner != address(0), "ERC721: owner query for nonexistent token");
677         return owner;
678     }
679 
680     /**
681      * @dev See {IERC721Metadata-name}.
682      */
683     function name() public view virtual override returns (string memory) {
684         return _name;
685     }
686 
687     /**
688      * @dev See {IERC721Metadata-symbol}.
689      */
690     function symbol() public view virtual override returns (string memory) {
691         return _symbol;
692     }
693 
694     /**
695      * @dev See {IERC721Metadata-tokenURI}.
696      */
697     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
698         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
699 
700         string memory baseURI = _baseURI();
701         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
702     }
703 
704     /**
705      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
706      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
707      * by default, can be overriden in child contracts.
708      */
709     function _baseURI() internal view virtual returns (string memory) {
710         return "";
711     }
712 
713     /**
714      * @dev See {IERC721-approve}.
715      */
716     function approve(address to, uint256 tokenId) public virtual override {
717         address owner = ERC721.ownerOf(tokenId);
718         require(to != owner, "ERC721: approval to current owner");
719 
720         require(
721             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
722             "ERC721: approve caller is not owner nor approved for all"
723         );
724 
725         _approve(to, tokenId);
726     }
727 
728     /**
729      * @dev See {IERC721-getApproved}.
730      */
731     function getApproved(uint256 tokenId) public view virtual override returns (address) {
732         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
733 
734         return _tokenApprovals[tokenId];
735     }
736 
737     /**
738      * @dev See {IERC721-setApprovalForAll}.
739      */
740     function setApprovalForAll(address operator, bool approved) public virtual override {
741         _setApprovalForAll(_msgSender(), operator, approved);
742     }
743 
744     /**
745      * @dev See {IERC721-isApprovedForAll}.
746      */
747     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
748         return _operatorApprovals[owner][operator];
749     }
750 
751     /**
752      * @dev See {IERC721-transferFrom}.
753      */
754     function transferFrom(
755         address from,
756         address to,
757         uint256 tokenId
758     ) public virtual override {
759         //solhint-disable-next-line max-line-length
760         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
761 
762         _transfer(from, to, tokenId);
763     }
764 
765     /**
766      * @dev See {IERC721-safeTransferFrom}.
767      */
768     function safeTransferFrom(
769         address from,
770         address to,
771         uint256 tokenId
772     ) public virtual override {
773         safeTransferFrom(from, to, tokenId, "");
774     }
775 
776     /**
777      * @dev See {IERC721-safeTransferFrom}.
778      */
779     function safeTransferFrom(
780         address from,
781         address to,
782         uint256 tokenId,
783         bytes memory _data
784     ) public virtual override {
785         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
786         _safeTransfer(from, to, tokenId, _data);
787     }
788 
789     /**
790      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
791      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
792      *
793      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
794      *
795      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
796      * implement alternative mechanisms to perform token transfer, such as signature-based.
797      *
798      * Requirements:
799      *
800      * - `from` cannot be the zero address.
801      * - `to` cannot be the zero address.
802      * - `tokenId` token must exist and be owned by `from`.
803      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
804      *
805      * Emits a {Transfer} event.
806      */
807     function _safeTransfer(
808         address from,
809         address to,
810         uint256 tokenId,
811         bytes memory _data
812     ) internal virtual {
813         _transfer(from, to, tokenId);
814         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
815     }
816 
817     /**
818      * @dev Returns whether `tokenId` exists.
819      *
820      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
821      *
822      * Tokens start existing when they are minted (`_mint`),
823      * and stop existing when they are burned (`_burn`).
824      */
825     function _exists(uint256 tokenId) internal view virtual returns (bool) {
826         return _owners[tokenId] != address(0);
827     }
828 
829     /**
830      * @dev Returns whether `spender` is allowed to manage `tokenId`.
831      *
832      * Requirements:
833      *
834      * - `tokenId` must exist.
835      */
836     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
837         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
838         address owner = ERC721.ownerOf(tokenId);
839         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
840     }
841 
842     /**
843      * @dev Safely mints `tokenId` and transfers it to `to`.
844      *
845      * Requirements:
846      *
847      * - `tokenId` must not exist.
848      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
849      *
850      * Emits a {Transfer} event.
851      */
852     function _safeMint(address to, uint256 tokenId) internal virtual {
853         _safeMint(to, tokenId, "");
854     }
855 
856     /**
857      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
858      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
859      */
860     function _safeMint(
861         address to,
862         uint256 tokenId,
863         bytes memory _data
864     ) internal virtual {
865         _mint(to, tokenId);
866         require(
867             _checkOnERC721Received(address(0), to, tokenId, _data),
868             "ERC721: transfer to non ERC721Receiver implementer"
869         );
870     }
871 
872     /**
873      * @dev Mints `tokenId` and transfers it to `to`.
874      *
875      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
876      *
877      * Requirements:
878      *
879      * - `tokenId` must not exist.
880      * - `to` cannot be the zero address.
881      *
882      * Emits a {Transfer} event.
883      */
884     function _mint(address to, uint256 tokenId) internal virtual {
885         require(to != address(0), "ERC721: mint to the zero address");
886         require(!_exists(tokenId), "ERC721: token already minted");
887 
888         _beforeTokenTransfer(address(0), to, tokenId);
889 
890         _balances[to] += 1;
891         _owners[tokenId] = to;
892 
893         emit Transfer(address(0), to, tokenId);
894 
895         _afterTokenTransfer(address(0), to, tokenId);
896     }
897 
898     /**
899      * @dev Destroys `tokenId`.
900      * The approval is cleared when the token is burned.
901      *
902      * Requirements:
903      *
904      * - `tokenId` must exist.
905      *
906      * Emits a {Transfer} event.
907      */
908     function _burn(uint256 tokenId) internal virtual {
909         address owner = ERC721.ownerOf(tokenId);
910 
911         _beforeTokenTransfer(owner, address(0), tokenId);
912 
913         // Clear approvals
914         _approve(address(0), tokenId);
915 
916         _balances[owner] -= 1;
917         delete _owners[tokenId];
918 
919         emit Transfer(owner, address(0), tokenId);
920 
921         _afterTokenTransfer(owner, address(0), tokenId);
922     }
923 
924     /**
925      * @dev Transfers `tokenId` from `from` to `to`.
926      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
927      *
928      * Requirements:
929      *
930      * - `to` cannot be the zero address.
931      * - `tokenId` token must be owned by `from`.
932      *
933      * Emits a {Transfer} event.
934      */
935     function _transfer(
936         address from,
937         address to,
938         uint256 tokenId
939     ) internal virtual {
940         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
941         require(to != address(0), "ERC721: transfer to the zero address");
942 
943         _beforeTokenTransfer(from, to, tokenId);
944 
945         // Clear approvals from the previous owner
946         _approve(address(0), tokenId);
947 
948         _balances[from] -= 1;
949         _balances[to] += 1;
950         _owners[tokenId] = to;
951 
952         emit Transfer(from, to, tokenId);
953 
954         _afterTokenTransfer(from, to, tokenId);
955     }
956 
957     /**
958      * @dev Approve `to` to operate on `tokenId`
959      *
960      * Emits a {Approval} event.
961      */
962     function _approve(address to, uint256 tokenId) internal virtual {
963         _tokenApprovals[tokenId] = to;
964         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
965     }
966 
967     /**
968      * @dev Approve `operator` to operate on all of `owner` tokens
969      *
970      * Emits a {ApprovalForAll} event.
971      */
972     function _setApprovalForAll(
973         address owner,
974         address operator,
975         bool approved
976     ) internal virtual {
977         require(owner != operator, "ERC721: approve to caller");
978         _operatorApprovals[owner][operator] = approved;
979         emit ApprovalForAll(owner, operator, approved);
980     }
981 
982     /**
983      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
984      * The call is not executed if the target address is not a contract.
985      *
986      * @param from address representing the previous owner of the given token ID
987      * @param to target address that will receive the tokens
988      * @param tokenId uint256 ID of the token to be transferred
989      * @param _data bytes optional data to send along with the call
990      * @return bool whether the call correctly returned the expected magic value
991      */
992     function _checkOnERC721Received(
993         address from,
994         address to,
995         uint256 tokenId,
996         bytes memory _data
997     ) private returns (bool) {
998         if (to.isContract()) {
999             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1000                 return retval == IERC721Receiver.onERC721Received.selector;
1001             } catch (bytes memory reason) {
1002                 if (reason.length == 0) {
1003                     revert("ERC721: transfer to non ERC721Receiver implementer");
1004                 } else {
1005                     assembly {
1006                         revert(add(32, reason), mload(reason))
1007                     }
1008                 }
1009             }
1010         } else {
1011             return true;
1012         }
1013     }
1014 
1015     function _beforeTokenTransfer(
1016         address from,
1017         address to,
1018         uint256 tokenId
1019     ) internal virtual {}
1020 
1021     /**
1022      * @dev Hook that is called after any transfer of tokens. This includes
1023      * minting and burning.
1024      *
1025      * Calling conditions:
1026      *
1027      * - when `from` and `to` are both non-zero.
1028      * - `from` and `to` are never both zero.
1029      *
1030      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1031      */
1032     function _afterTokenTransfer(
1033         address from,
1034         address to,
1035         uint256 tokenId
1036     ) internal virtual {}
1037 }
1038 
1039 
1040 pragma solidity ^0.8.0;
1041 
1042 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1043     // Mapping from owner to list of owned token IDs
1044     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1045 
1046     // Mapping from token ID to index of the owner tokens list
1047     mapping(uint256 => uint256) private _ownedTokensIndex;
1048 
1049     // Array with all token ids, used for enumeration
1050     uint256[] private _allTokens;
1051 
1052     // Mapping from token id to position in the allTokens array
1053     mapping(uint256 => uint256) private _allTokensIndex;
1054 
1055     /**
1056      * @dev See {IERC165-supportsInterface}.
1057      */
1058     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1059         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1060     }
1061 
1062     /**
1063      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1064      */
1065     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1066         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1067         return _ownedTokens[owner][index];
1068     }
1069 
1070     /**
1071      * @dev See {IERC721Enumerable-totalSupply}.
1072      */
1073     function totalSupply() public view virtual override returns (uint256) {
1074         return _allTokens.length;
1075     }
1076 
1077     /**
1078      * @dev See {IERC721Enumerable-tokenByIndex}.
1079      */
1080     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1081         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1082         return _allTokens[index];
1083     }
1084 
1085     function _beforeTokenTransfer(
1086         address from,
1087         address to,
1088         uint256 tokenId
1089     ) internal virtual override {
1090         super._beforeTokenTransfer(from, to, tokenId);
1091 
1092         if (from == address(0)) {
1093             _addTokenToAllTokensEnumeration(tokenId);
1094         } else if (from != to) {
1095             _removeTokenFromOwnerEnumeration(from, tokenId);
1096         }
1097         if (to == address(0)) {
1098             _removeTokenFromAllTokensEnumeration(tokenId);
1099         } else if (to != from) {
1100             _addTokenToOwnerEnumeration(to, tokenId);
1101         }
1102     }
1103 
1104     /**
1105      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1106      * @param to address representing the new owner of the given token ID
1107      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1108      */
1109     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1110         uint256 length = ERC721.balanceOf(to);
1111         _ownedTokens[to][length] = tokenId;
1112         _ownedTokensIndex[tokenId] = length;
1113     }
1114 
1115     /**
1116      * @dev Private function to add a token to this extension's token tracking data structures.
1117      * @param tokenId uint256 ID of the token to be added to the tokens list
1118      */
1119     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1120         _allTokensIndex[tokenId] = _allTokens.length;
1121         _allTokens.push(tokenId);
1122     }
1123 
1124     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1125         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1126         // then delete the last slot (swap and pop).
1127 
1128         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1129         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1130 
1131         // When the token to delete is the last token, the swap operation is unnecessary
1132         if (tokenIndex != lastTokenIndex) {
1133             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1134 
1135             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1136             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1137         }
1138 
1139         // This also deletes the contents at the last position of the array
1140         delete _ownedTokensIndex[tokenId];
1141         delete _ownedTokens[from][lastTokenIndex];
1142     }
1143 
1144     /**
1145      * @dev Private function to remove a token from this extension's token tracking data structures.
1146      * This has O(1) time complexity, but alters the order of the _allTokens array.
1147      * @param tokenId uint256 ID of the token to be removed from the tokens list
1148      */
1149     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1150         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1151         // then delete the last slot (swap and pop).
1152 
1153         uint256 lastTokenIndex = _allTokens.length - 1;
1154         uint256 tokenIndex = _allTokensIndex[tokenId];
1155 
1156         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1157         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1158         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1159         uint256 lastTokenId = _allTokens[lastTokenIndex];
1160 
1161         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1162         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1163 
1164         // This also deletes the contents at the last position of the array
1165         delete _allTokensIndex[tokenId];
1166         _allTokens.pop();
1167     }
1168 }
1169 
1170 
1171 pragma solidity ^0.8.4;
1172 
1173 error ApprovalCallerNotOwnerNorApproved();
1174 error ApprovalQueryForNonexistentToken();
1175 error ApproveToCaller();
1176 error ApprovalToCurrentOwner();
1177 error BalanceQueryForZeroAddress();
1178 error MintToZeroAddress();
1179 error MintZeroQuantity();
1180 error OwnerQueryForNonexistentToken();
1181 error TransferCallerNotOwnerNorApproved();
1182 error TransferFromIncorrectOwner();
1183 error TransferToNonERC721ReceiverImplementer();
1184 error TransferToZeroAddress();
1185 error URIQueryForNonexistentToken();
1186 
1187 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
1188     using Address for address;
1189     using Strings for uint256;
1190 
1191     // Compiler will pack this into a single 256bit word.
1192     struct TokenOwnership {
1193         // The address of the owner.
1194         address addr;
1195         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
1196         uint64 startTimestamp;
1197         // Whether the token has been burned.
1198         bool burned;
1199     }
1200 
1201     // Compiler will pack this into a single 256bit word.
1202     struct AddressData {
1203         // Realistically, 2**64-1 is more than enough.
1204         uint64 balance;
1205         // Keeps track of mint count with minimal overhead for tokenomics.
1206         uint64 numberMinted;
1207         // Keeps track of burn count with minimal overhead for tokenomics.
1208         uint64 numberBurned;
1209         // For miscellaneous variable(s) pertaining to the address
1210         // (e.g. number of whitelist mint slots used).
1211         // If there are multiple variables, please pack them into a uint64.
1212         uint64 aux;
1213     }
1214 
1215     // The tokenId of the next token to be minted.
1216     uint256 internal _currentIndex;
1217 
1218     // The number of tokens burned.
1219     uint256 internal _burnCounter;
1220 
1221     // Token name
1222     string private _name;
1223 
1224     // Token symbol
1225     string private _symbol;
1226 
1227     // Mapping from token ID to ownership details
1228     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
1229     mapping(uint256 => TokenOwnership) internal _ownerships;
1230 
1231     // Mapping owner address to address data
1232     mapping(address => AddressData) private _addressData;
1233 
1234     // Mapping from token ID to approved address
1235     mapping(uint256 => address) private _tokenApprovals;
1236 
1237     // Mapping from owner to operator approvals
1238     mapping(address => mapping(address => bool)) private _operatorApprovals;
1239 
1240     constructor(string memory name_, string memory symbol_) {
1241         _name = name_;
1242         _symbol = symbol_;
1243         _currentIndex = _startTokenId();
1244     }
1245 
1246     /**
1247      * To change the starting tokenId, please override this function.
1248      */
1249     function _startTokenId() internal view virtual returns (uint256) {
1250         return 0;
1251     }
1252 
1253     /**
1254      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
1255      */
1256     function totalSupply() public view returns (uint256) {
1257         // Counter underflow is impossible as _burnCounter cannot be incremented
1258         // more than _currentIndex - _startTokenId() times
1259         unchecked {
1260             return _currentIndex - _burnCounter - _startTokenId();
1261         }
1262     }
1263 
1264     /**
1265      * Returns the total amount of tokens minted in the contract.
1266      */
1267     function _totalMinted() internal view returns (uint256) {
1268         // Counter underflow is impossible as _currentIndex does not decrement,
1269         // and it is initialized to _startTokenId()
1270         unchecked {
1271             return _currentIndex - _startTokenId();
1272         }
1273     }
1274 
1275     /**
1276      * @dev See {IERC165-supportsInterface}.
1277      */
1278     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1279         return
1280             interfaceId == type(IERC721).interfaceId ||
1281             interfaceId == type(IERC721Metadata).interfaceId ||
1282             super.supportsInterface(interfaceId);
1283     }
1284 
1285     /**
1286      * @dev See {IERC721-balanceOf}.
1287      */
1288     function balanceOf(address owner) public view override returns (uint256) {
1289         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1290         return uint256(_addressData[owner].balance);
1291     }
1292 
1293     /**
1294      * Returns the number of tokens minted by `owner`.
1295      */
1296     function _numberMinted(address owner) internal view returns (uint256) {
1297         return uint256(_addressData[owner].numberMinted);
1298     }
1299 
1300     /**
1301      * Returns the number of tokens burned by or on behalf of `owner`.
1302      */
1303     function _numberBurned(address owner) internal view returns (uint256) {
1304         return uint256(_addressData[owner].numberBurned);
1305     }
1306 
1307     /**
1308      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1309      */
1310     function _getAux(address owner) internal view returns (uint64) {
1311         return _addressData[owner].aux;
1312     }
1313 
1314     /**
1315      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1316      * If there are multiple variables, please pack them into a uint64.
1317      */
1318     function _setAux(address owner, uint64 aux) internal {
1319         _addressData[owner].aux = aux;
1320     }
1321 
1322     /**
1323      * Gas spent here starts off proportional to the maximum mint batch size.
1324      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1325      */
1326     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1327         uint256 curr = tokenId;
1328 
1329         unchecked {
1330             if (_startTokenId() <= curr && curr < _currentIndex) {
1331                 TokenOwnership memory ownership = _ownerships[curr];
1332                 if (!ownership.burned) {
1333                     if (ownership.addr != address(0)) {
1334                         return ownership;
1335                     }
1336                     // Invariant:
1337                     // There will always be an ownership that has an address and is not burned
1338                     // before an ownership that does not have an address and is not burned.
1339                     // Hence, curr will not underflow.
1340                     while (true) {
1341                         curr--;
1342                         ownership = _ownerships[curr];
1343                         if (ownership.addr != address(0)) {
1344                             return ownership;
1345                         }
1346                     }
1347                 }
1348             }
1349         }
1350         revert OwnerQueryForNonexistentToken();
1351     }
1352 
1353     /**
1354      * @dev See {IERC721-ownerOf}.
1355      */
1356     function ownerOf(uint256 tokenId) public view override returns (address) {
1357         return _ownershipOf(tokenId).addr;
1358     }
1359 
1360     /**
1361      * @dev See {IERC721Metadata-name}.
1362      */
1363     function name() public view virtual override returns (string memory) {
1364         return _name;
1365     }
1366 
1367     /**
1368      * @dev See {IERC721Metadata-symbol}.
1369      */
1370     function symbol() public view virtual override returns (string memory) {
1371         return _symbol;
1372     }
1373 
1374     /**
1375      * @dev See {IERC721Metadata-tokenURI}.
1376      */
1377     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1378         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1379 
1380         string memory baseURI = _baseURI();
1381         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1382     }
1383 
1384     /**
1385      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1386      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1387      * by default, can be overriden in child contracts.
1388      */
1389     function _baseURI() internal view virtual returns (string memory) {
1390         return '';
1391     }
1392 
1393     /**
1394      * @dev See {IERC721-approve}.
1395      */
1396     function approve(address to, uint256 tokenId) public override {
1397         address owner = ERC721A.ownerOf(tokenId);
1398         if (to == owner) revert ApprovalToCurrentOwner();
1399 
1400         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1401             revert ApprovalCallerNotOwnerNorApproved();
1402         }
1403 
1404         _approve(to, tokenId, owner);
1405     }
1406 
1407     /**
1408      * @dev See {IERC721-getApproved}.
1409      */
1410     function getApproved(uint256 tokenId) public view override returns (address) {
1411         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1412 
1413         return _tokenApprovals[tokenId];
1414     }
1415 
1416     /**
1417      * @dev See {IERC721-setApprovalForAll}.
1418      */
1419     function setApprovalForAll(address operator, bool approved) public virtual override {
1420         if (operator == _msgSender()) revert ApproveToCaller();
1421 
1422         _operatorApprovals[_msgSender()][operator] = approved;
1423         emit ApprovalForAll(_msgSender(), operator, approved);
1424     }
1425 
1426     /**
1427      * @dev See {IERC721-isApprovedForAll}.
1428      */
1429     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1430         return _operatorApprovals[owner][operator];
1431     }
1432 
1433     /**
1434      * @dev See {IERC721-transferFrom}.
1435      */
1436     function transferFrom(
1437         address from,
1438         address to,
1439         uint256 tokenId
1440     ) public virtual override {
1441         _transfer(from, to, tokenId);
1442     }
1443 
1444     /**
1445      * @dev See {IERC721-safeTransferFrom}.
1446      */
1447     function safeTransferFrom(
1448         address from,
1449         address to,
1450         uint256 tokenId
1451     ) public virtual override {
1452         safeTransferFrom(from, to, tokenId, '');
1453     }
1454 
1455     /**
1456      * @dev See {IERC721-safeTransferFrom}.
1457      */
1458     function safeTransferFrom(
1459         address from,
1460         address to,
1461         uint256 tokenId,
1462         bytes memory _data
1463     ) public virtual override {
1464         _transfer(from, to, tokenId);
1465         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1466             revert TransferToNonERC721ReceiverImplementer();
1467         }
1468     }
1469 
1470     /**
1471      * @dev Returns whether `tokenId` exists.
1472      *
1473      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1474      *
1475      * Tokens start existing when they are minted (`_mint`),
1476      */
1477     function _exists(uint256 tokenId) internal view returns (bool) {
1478         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1479     }
1480 
1481     function _safeMint(address to, uint256 quantity) internal {
1482         _safeMint(to, quantity, '');
1483     }
1484 
1485     /**
1486      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1487      *
1488      * Requirements:
1489      *
1490      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1491      * - `quantity` must be greater than 0.
1492      *
1493      * Emits a {Transfer} event.
1494      */
1495     function _safeMint(
1496         address to,
1497         uint256 quantity,
1498         bytes memory _data
1499     ) internal {
1500         _mint(to, quantity, _data, true);
1501     }
1502 
1503     /**
1504      * @dev Mints `quantity` tokens and transfers them to `to`.
1505      *
1506      * Requirements:
1507      *
1508      * - `to` cannot be the zero address.
1509      * - `quantity` must be greater than 0.
1510      *
1511      * Emits a {Transfer} event.
1512      */
1513     function _mint(
1514         address to,
1515         uint256 quantity,
1516         bytes memory _data,
1517         bool safe
1518     ) internal {
1519         uint256 startTokenId = _currentIndex;
1520         if (to == address(0)) revert MintToZeroAddress();
1521         if (quantity == 0) revert MintZeroQuantity();
1522 
1523         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1524 
1525         // Overflows are incredibly unrealistic.
1526         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1527         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1528         unchecked {
1529             _addressData[to].balance += uint64(quantity);
1530             _addressData[to].numberMinted += uint64(quantity);
1531 
1532             _ownerships[startTokenId].addr = to;
1533             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1534 
1535             uint256 updatedIndex = startTokenId;
1536             uint256 end = updatedIndex + quantity;
1537 
1538             if (safe && to.isContract()) {
1539                 do {
1540                     emit Transfer(address(0), to, updatedIndex);
1541                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1542                         revert TransferToNonERC721ReceiverImplementer();
1543                     }
1544                 } while (updatedIndex != end);
1545                 // Reentrancy protection
1546                 if (_currentIndex != startTokenId) revert();
1547             } else {
1548                 do {
1549                     emit Transfer(address(0), to, updatedIndex++);
1550                 } while (updatedIndex != end);
1551             }
1552             _currentIndex = updatedIndex;
1553         }
1554         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1555     }
1556 
1557     function _transfer(
1558         address from,
1559         address to,
1560         uint256 tokenId
1561     ) private {
1562         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1563 
1564         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1565 
1566         bool isApprovedOrOwner = (_msgSender() == from ||
1567             isApprovedForAll(from, _msgSender()) ||
1568             getApproved(tokenId) == _msgSender());
1569 
1570         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1571         if (to == address(0)) revert TransferToZeroAddress();
1572 
1573         _beforeTokenTransfers(from, to, tokenId, 1);
1574 
1575         // Clear approvals from the previous owner
1576         _approve(address(0), tokenId, from);
1577 
1578         // Underflow of the sender's balance is impossible because we check for
1579         // ownership above and the recipient's balance can't realistically overflow.
1580         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1581         unchecked {
1582             _addressData[from].balance -= 1;
1583             _addressData[to].balance += 1;
1584 
1585             TokenOwnership storage currSlot = _ownerships[tokenId];
1586             currSlot.addr = to;
1587             currSlot.startTimestamp = uint64(block.timestamp);
1588 
1589             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1590             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1591             uint256 nextTokenId = tokenId + 1;
1592             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1593             if (nextSlot.addr == address(0)) {
1594                 // This will suffice for checking _exists(nextTokenId),
1595                 // as a burned slot cannot contain the zero address.
1596                 if (nextTokenId != _currentIndex) {
1597                     nextSlot.addr = from;
1598                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1599                 }
1600             }
1601         }
1602 
1603         emit Transfer(from, to, tokenId);
1604         _afterTokenTransfers(from, to, tokenId, 1);
1605     }
1606 
1607     /**
1608      * @dev This is equivalent to _burn(tokenId, false)
1609      */
1610     function _burn(uint256 tokenId) internal virtual {
1611         _burn(tokenId, false);
1612     }
1613 
1614     /**
1615      * @dev Destroys `tokenId`.
1616      * The approval is cleared when the token is burned.
1617      *
1618      * Requirements:
1619      *
1620      * - `tokenId` must exist.
1621      *
1622      * Emits a {Transfer} event.
1623      */
1624     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1625         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1626 
1627         address from = prevOwnership.addr;
1628 
1629         if (approvalCheck) {
1630             bool isApprovedOrOwner = (_msgSender() == from ||
1631                 isApprovedForAll(from, _msgSender()) ||
1632                 getApproved(tokenId) == _msgSender());
1633 
1634             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1635         }
1636 
1637         _beforeTokenTransfers(from, address(0), tokenId, 1);
1638 
1639         // Clear approvals from the previous owner
1640         _approve(address(0), tokenId, from);
1641 
1642         // Underflow of the sender's balance is impossible because we check for
1643         // ownership above and the recipient's balance can't realistically overflow.
1644         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1645         unchecked {
1646             AddressData storage addressData = _addressData[from];
1647             addressData.balance -= 1;
1648             addressData.numberBurned += 1;
1649 
1650             // Keep track of who burned the token, and the timestamp of burning.
1651             TokenOwnership storage currSlot = _ownerships[tokenId];
1652             currSlot.addr = from;
1653             currSlot.startTimestamp = uint64(block.timestamp);
1654             currSlot.burned = true;
1655 
1656             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1657             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1658             uint256 nextTokenId = tokenId + 1;
1659             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1660             if (nextSlot.addr == address(0)) {
1661                 // This will suffice for checking _exists(nextTokenId),
1662                 // as a burned slot cannot contain the zero address.
1663                 if (nextTokenId != _currentIndex) {
1664                     nextSlot.addr = from;
1665                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1666                 }
1667             }
1668         }
1669 
1670         emit Transfer(from, address(0), tokenId);
1671         _afterTokenTransfers(from, address(0), tokenId, 1);
1672 
1673         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1674         unchecked {
1675             _burnCounter++;
1676         }
1677     }
1678 
1679     /**
1680      * @dev Approve `to` to operate on `tokenId`
1681      *
1682      * Emits a {Approval} event.
1683      */
1684     function _approve(
1685         address to,
1686         uint256 tokenId,
1687         address owner
1688     ) private {
1689         _tokenApprovals[tokenId] = to;
1690         emit Approval(owner, to, tokenId);
1691     }
1692 
1693     /**
1694      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1695      *
1696      * @param from address representing the previous owner of the given token ID
1697      * @param to target address that will receive the tokens
1698      * @param tokenId uint256 ID of the token to be transferred
1699      * @param _data bytes optional data to send along with the call
1700      * @return bool whether the call correctly returned the expected magic value
1701      */
1702     function _checkContractOnERC721Received(
1703         address from,
1704         address to,
1705         uint256 tokenId,
1706         bytes memory _data
1707     ) private returns (bool) {
1708         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1709             return retval == IERC721Receiver(to).onERC721Received.selector;
1710         } catch (bytes memory reason) {
1711             if (reason.length == 0) {
1712                 revert TransferToNonERC721ReceiverImplementer();
1713             } else {
1714                 assembly {
1715                     revert(add(32, reason), mload(reason))
1716                 }
1717             }
1718         }
1719     }
1720 
1721     function _beforeTokenTransfers(
1722         address from,
1723         address to,
1724         uint256 startTokenId,
1725         uint256 quantity
1726     ) internal virtual {}
1727 
1728     function _afterTokenTransfers(
1729         address from,
1730         address to,
1731         uint256 startTokenId,
1732         uint256 quantity
1733     ) internal virtual {}
1734 }
1735 
1736 
1737 pragma solidity ^0.8.4;
1738 
1739 
1740 contract FaithInChivalry is ERC721A, Ownable {
1741     using Strings for uint256;
1742 
1743     string private baseURI;
1744 
1745     string public hiddenMetadataUri;
1746 
1747     uint256 public price = 0.004 ether;
1748 
1749     uint256 public maxPerTx = 5;
1750 
1751     uint256 public maxFreePerWallet = 2;
1752 
1753     uint256 public totalFree = 1500;
1754 
1755     uint256 public maxSupply = 2000;
1756 
1757     uint public nextId = 0;
1758 
1759     bool public mintEnabled = false;
1760 
1761     bool public revealed = true;
1762 
1763     mapping(address => uint256) private _mintedFreeAmount;
1764 
1765     constructor() ERC721A("Faith In Chivalry", "FCY") {
1766         setHiddenMetadataUri("ipfs://Qmf2WDsGJd3SM6oU3CXTDTaJqzh4QcRpa6hPJ3Vk67xCVv//");
1767         setBaseURI("ipfs://Qmf2WDsGJd3SM6oU3CXTDTaJqzh4QcRpa6hPJ3Vk67xCVv//");
1768     }
1769 
1770     function mint(uint256 count) external payable {
1771       uint256 cost = price;
1772       bool isFree =
1773       ((totalSupply() + count < totalFree + 1) &&
1774       (_mintedFreeAmount[msg.sender] + count <= maxFreePerWallet));
1775 
1776       if (isFree) {
1777       cost = 0;
1778      }
1779 
1780      else {
1781       require(msg.value >= count * price, "Please send the exact amount.");
1782       require(totalSupply() + count <= maxSupply, "No more FCY");
1783       require(mintEnabled, "Minting is not live yet");
1784       require(count <= maxPerTx, "Max per TX reached.");
1785      }
1786 
1787       if (isFree) {
1788          _mintedFreeAmount[msg.sender] += count;
1789       }
1790 
1791      _safeMint(msg.sender, count);
1792      nextId += count;
1793     }
1794 
1795     function _baseURI() internal view virtual override returns (string memory) {
1796         return baseURI;
1797     }
1798 
1799     function tokenURI(uint256 tokenId)
1800         public
1801         view
1802         virtual
1803         override
1804         returns (string memory)
1805     {
1806         require(
1807             _exists(tokenId),
1808             "ERC721Metadata: URI query for nonexistent token"
1809         );
1810 
1811         if (revealed == false) {
1812          return string(abi.encodePacked(hiddenMetadataUri));
1813         }
1814     
1815         return string(abi.encodePacked(baseURI, tokenId.toString(), ".json"));
1816     }
1817 
1818     function setBaseURI(string memory uri) public onlyOwner {
1819         baseURI = uri;
1820     }
1821 
1822     function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1823      hiddenMetadataUri = _hiddenMetadataUri;
1824     }
1825 
1826     function setFreeAmount(uint256 amount) external onlyOwner {
1827         totalFree = amount;
1828     }
1829 
1830     function setPrice(uint256 _newPrice) external onlyOwner {
1831         price = _newPrice;
1832     }
1833 
1834     function setRevealed() external onlyOwner {
1835      revealed = !revealed;
1836     }
1837 
1838     function flipSale() external onlyOwner {
1839         mintEnabled = !mintEnabled;
1840     }
1841 
1842     function getNextId() public view returns(uint){
1843      return nextId;
1844     }
1845 
1846     function _startTokenId() internal pure override returns (uint256) {
1847         return 1;
1848     }
1849 
1850     function withdraw() external onlyOwner {
1851         (bool success, ) = payable(msg.sender).call{
1852             value: address(this).balance
1853         }("");
1854         require(success, "Transfer failed.");
1855     }
1856 
1857     function WhitelistMint(address to, uint256 quantity)public onlyOwner{
1858     require(totalSupply() + quantity <= maxSupply, "reached max supply");
1859     _safeMint(to, quantity);
1860   }
1861 }