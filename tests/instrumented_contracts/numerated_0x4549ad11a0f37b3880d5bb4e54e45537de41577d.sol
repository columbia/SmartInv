1 // SPDX-License-Identifier: MIT LICENSE
2 
3 pragma solidity 0.8.9;
4 
5 interface IKongIsland {
6     function addManyToKongIslandAndPack(address account, uint16[] calldata tokenIds)
7         external;
8 
9     function randomKongOwner(uint256 seed) external view returns (address);
10 }
11 
12 interface ITraits {
13     function tokenURI(uint256 tokenId) external view returns (string memory);
14 }
15 
16 interface IFOOD{
17     function burn(address account, uint256 amount) external;
18     function mint(address account, uint256 amount) external;
19 }
20 
21 interface IKONGS {
22     // struct to store each token's traits
23     struct KaijuKong {
24         bool isKaiju;
25         uint8 background;
26         uint8 species;
27         uint8 companion;
28         uint8 fur;
29         uint8 hat;
30         uint8 face;
31         uint8 weapons;
32         uint8 accessories;        
33         uint8 kingScore;
34     }
35 
36     function getPaidTokens() external view returns (uint256);
37 
38     function getTokenTraits(uint256 tokenId)
39         external
40         view
41         returns (KaijuKong memory);
42 }
43 
44 
45 library Address {
46     /**
47      * @dev Returns true if `account` is a contract.
48      *
49      * [IMPORTANT]
50      * ====
51      * It is unsafe to assume that an address for which this function returns
52      * false is an externally-owned account (EOA) and not a contract.
53      *
54      * Among others, `isContract` will return false for the following
55      * types of addresses:
56      *
57      *  - an externally-owned account
58      *  - a contract in construction
59      *  - an address where a contract will be created
60      *  - an address where a contract lived, but was destroyed
61      * ====
62      */
63     function isContract(address account) internal view returns (bool) {
64         // This method relies on extcodesize, which returns 0 for contracts in
65         // construction, since the code is only stored at the end of the
66         // constructor execution.
67 
68         uint256 size;
69         assembly {
70             size := extcodesize(account)
71         }
72         return size > 0;
73     }
74 
75     /**
76      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
77      * `recipient`, forwarding all available gas and reverting on errors.
78      *
79      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
80      * of certain opcodes, possibly making contracts go over the 2300 gas limit
81      * imposed by `transfer`, making them unable to receive funds via
82      * `transfer`. {sendValue} removes this limitation.
83      *
84      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
85      *
86      * IMPORTANT: because control is transferred to `recipient`, care must be
87      * taken to not create reentrancy vulnerabilities. Consider using
88      * {ReentrancyGuard} or the
89      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
90      */
91     function sendValue(address payable recipient, uint256 amount) internal {
92         require(address(this).balance >= amount, "Address: insufficient balance");
93 
94         (bool success, ) = recipient.call{value: amount}("");
95         require(success, "Address: unable to send value, recipient may have reverted");
96     }
97 
98     /**
99      * @dev Performs a Solidity function call using a low level `call`. A
100      * plain `call` is an unsafe replacement for a function call: use this
101      * function instead.
102      *
103      * If `target` reverts with a revert reason, it is bubbled up by this
104      * function (like regular Solidity function calls).
105      *
106      * Returns the raw returned data. To convert to the expected return value,
107      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
108      *
109      * Requirements:
110      *
111      * - `target` must be a contract.
112      * - calling `target` with `data` must not revert.
113      *
114      * _Available since v3.1._
115      */
116     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
117         return functionCall(target, data, "Address: low-level call failed");
118     }
119 
120     /**
121      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
122      * `errorMessage` as a fallback revert reason when `target` reverts.
123      *
124      * _Available since v3.1._
125      */
126     function functionCall(
127         address target,
128         bytes memory data,
129         string memory errorMessage
130     ) internal returns (bytes memory) {
131         return functionCallWithValue(target, data, 0, errorMessage);
132     }
133 
134     /**
135      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
136      * but also transferring `value` wei to `target`.
137      *
138      * Requirements:
139      *
140      * - the calling contract must have an ETH balance of at least `value`.
141      * - the called Solidity function must be `payable`.
142      *
143      * _Available since v3.1._
144      */
145     function functionCallWithValue(
146         address target,
147         bytes memory data,
148         uint256 value
149     ) internal returns (bytes memory) {
150         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
151     }
152 
153     /**
154      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
155      * with `errorMessage` as a fallback revert reason when `target` reverts.
156      *
157      * _Available since v3.1._
158      */
159     function functionCallWithValue(
160         address target,
161         bytes memory data,
162         uint256 value,
163         string memory errorMessage
164     ) internal returns (bytes memory) {
165         require(address(this).balance >= value, "Address: insufficient balance for call");
166         require(isContract(target), "Address: call to non-contract");
167 
168         (bool success, bytes memory returndata) = target.call{value: value}(data);
169         return verifyCallResult(success, returndata, errorMessage);
170     }
171 
172     /**
173      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
174      * but performing a static call.
175      *
176      * _Available since v3.3._
177      */
178     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
179         return functionStaticCall(target, data, "Address: low-level static call failed");
180     }
181 
182     /**
183      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
184      * but performing a static call.
185      *
186      * _Available since v3.3._
187      */
188     function functionStaticCall(
189         address target,
190         bytes memory data,
191         string memory errorMessage
192     ) internal view returns (bytes memory) {
193         require(isContract(target), "Address: static call to non-contract");
194 
195         (bool success, bytes memory returndata) = target.staticcall(data);
196         return verifyCallResult(success, returndata, errorMessage);
197     }
198 
199     /**
200      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
201      * but performing a delegate call.
202      *
203      * _Available since v3.4._
204      */
205     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
206         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
207     }
208 
209     /**
210      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
211      * but performing a delegate call.
212      *
213      * _Available since v3.4._
214      */
215     function functionDelegateCall(
216         address target,
217         bytes memory data,
218         string memory errorMessage
219     ) internal returns (bytes memory) {
220         require(isContract(target), "Address: delegate call to non-contract");
221 
222         (bool success, bytes memory returndata) = target.delegatecall(data);
223         return verifyCallResult(success, returndata, errorMessage);
224     }
225 
226     /**
227      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
228      * revert reason using the provided one.
229      *
230      * _Available since v4.3._
231      */
232     function verifyCallResult(
233         bool success,
234         bytes memory returndata,
235         string memory errorMessage
236     ) internal pure returns (bytes memory) {
237         if (success) {
238             return returndata;
239         } else {
240             // Look for revert reason and bubble it up if present
241             if (returndata.length > 0) {
242                 // The easiest way to bubble the revert reason is using memory via assembly
243 
244                 assembly {
245                     let returndata_size := mload(returndata)
246                     revert(add(32, returndata), returndata_size)
247                 }
248             } else {
249                 revert(errorMessage);
250             }
251         }
252     }
253 }
254 
255 
256 abstract contract Context {
257     function _msgSender() internal view virtual returns (address) {
258         return msg.sender;
259     }
260 
261     function _msgData() internal view virtual returns (bytes calldata) {
262         return msg.data;
263     }
264 }
265 
266 
267 interface IERC165 {
268     /**
269      * @dev Returns true if this contract implements the interface defined by
270      * `interfaceId`. See the corresponding
271      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
272      * to learn more about how these ids are created.
273      *
274      * This function call must use less than 30 000 gas.
275      */
276     function supportsInterface(bytes4 interfaceId) external view returns (bool);
277 }
278 
279 
280 interface IERC721Receiver {
281     /**
282      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
283      * by `operator` from `from`, this function is called.
284      *
285      * It must return its Solidity selector to confirm the token transfer.
286      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
287      *
288      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
289      */
290     function onERC721Received(
291         address operator,
292         address from,
293         uint256 tokenId,
294         bytes calldata data
295     ) external returns (bytes4);
296 }
297 
298 
299 library Strings {
300     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
301 
302     /**
303      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
304      */
305     function toString(uint256 value) internal pure returns (string memory) {
306         // Inspired by OraclizeAPI's implementation - MIT licence
307         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
308 
309         if (value == 0) {
310             return "0";
311         }
312         uint256 temp = value;
313         uint256 digits;
314         while (temp != 0) {
315             digits++;
316             temp /= 10;
317         }
318         bytes memory buffer = new bytes(digits);
319         while (value != 0) {
320             digits -= 1;
321             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
322             value /= 10;
323         }
324         return string(buffer);
325     }
326 
327     /**
328      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
329      */
330     function toHexString(uint256 value) internal pure returns (string memory) {
331         if (value == 0) {
332             return "0x00";
333         }
334         uint256 temp = value;
335         uint256 length = 0;
336         while (temp != 0) {
337             length++;
338             temp >>= 8;
339         }
340         return toHexString(value, length);
341     }
342 
343     /**
344      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
345      */
346     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
347         bytes memory buffer = new bytes(2 * length + 2);
348         buffer[0] = "0";
349         buffer[1] = "x";
350         for (uint256 i = 2 * length + 1; i > 1; --i) {
351             buffer[i] = _HEX_SYMBOLS[value & 0xf];
352             value >>= 4;
353         }
354         require(value == 0, "Strings: hex length insufficient");
355         return string(buffer);
356     }
357 }
358 
359 
360 abstract contract ERC165 is IERC165 {
361     /**
362      * @dev See {IERC165-supportsInterface}.
363      */
364     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
365         return interfaceId == type(IERC165).interfaceId;
366     }
367 }
368 
369 
370 
371 interface IERC721 is IERC165 {
372     /**
373      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
374      */
375     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
376 
377     /**
378      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
379      */
380     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
381 
382     /**
383      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
384      */
385     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
386 
387     /**
388      * @dev Returns the number of tokens in ``owner``'s account.
389      */
390     function balanceOf(address owner) external view returns (uint256 balance);
391 
392     /**
393      * @dev Returns the owner of the `tokenId` token.
394      *
395      * Requirements:
396      *
397      * - `tokenId` must exist.
398      */
399     function ownerOf(uint256 tokenId) external view returns (address owner);
400 
401     /**
402      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
403      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
404      *
405      * Requirements:
406      *
407      * - `from` cannot be the zero address.
408      * - `to` cannot be the zero address.
409      * - `tokenId` token must exist and be owned by `from`.
410      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
411      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
412      *
413      * Emits a {Transfer} event.
414      */
415     function safeTransferFrom(
416         address from,
417         address to,
418         uint256 tokenId
419     ) external;
420 
421     /**
422      * @dev Transfers `tokenId` token from `from` to `to`.
423      *
424      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
425      *
426      * Requirements:
427      *
428      * - `from` cannot be the zero address.
429      * - `to` cannot be the zero address.
430      * - `tokenId` token must be owned by `from`.
431      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
432      *
433      * Emits a {Transfer} event.
434      */
435     function transferFrom(
436         address from,
437         address to,
438         uint256 tokenId
439     ) external;
440 
441     /**
442      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
443      * The approval is cleared when the token is transferred.
444      *
445      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
446      *
447      * Requirements:
448      *
449      * - The caller must own the token or be an approved operator.
450      * - `tokenId` must exist.
451      *
452      * Emits an {Approval} event.
453      */
454     function approve(address to, uint256 tokenId) external;
455 
456     /**
457      * @dev Returns the account approved for `tokenId` token.
458      *
459      * Requirements:
460      *
461      * - `tokenId` must exist.
462      */
463     function getApproved(uint256 tokenId) external view returns (address operator);
464 
465     /**
466      * @dev Approve or remove `operator` as an operator for the caller.
467      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
468      *
469      * Requirements:
470      *
471      * - The `operator` cannot be the caller.
472      *
473      * Emits an {ApprovalForAll} event.
474      */
475     function setApprovalForAll(address operator, bool _approved) external;
476 
477     /**
478      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
479      *
480      * See {setApprovalForAll}
481      */
482     function isApprovedForAll(address owner, address operator) external view returns (bool);
483 
484     /**
485      * @dev Safely transfers `tokenId` token from `from` to `to`.
486      *
487      * Requirements:
488      *
489      * - `from` cannot be the zero address.
490      * - `to` cannot be the zero address.
491      * - `tokenId` token must exist and be owned by `from`.
492      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
493      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
494      *
495      * Emits a {Transfer} event.
496      */
497     function safeTransferFrom(
498         address from,
499         address to,
500         uint256 tokenId,
501         bytes calldata data
502     ) external;
503 }
504 
505 abstract contract Ownable is Context {
506     address private _owner;
507 
508     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
509 
510     /**
511      * @dev Initializes the contract setting the deployer as the initial owner.
512      */
513     constructor() {
514         _setOwner(_msgSender());
515     }
516 
517     /**
518      * @dev Returns the address of the current owner.
519      */
520     function owner() public view virtual returns (address) {
521         return _owner;
522     }
523 
524     /**
525      * @dev Throws if called by any account other than the owner.
526      */
527     modifier onlyOwner() {
528         require(owner() == _msgSender(), "Ownable: caller is not the owner");
529         _;
530     }
531 
532     /**
533      * @dev Leaves the contract without owner. It will not be possible to call
534      * `onlyOwner` functions anymore. Can only be called by the current owner.
535      *
536      * NOTE: Renouncing ownership will leave the contract without an owner,
537      * thereby removing any functionality that is only available to the owner.
538      */
539     function renounceOwnership() public virtual onlyOwner {
540         _setOwner(address(0));
541     }
542 
543     /**
544      * @dev Transfers ownership of the contract to a new account (`newOwner`).
545      * Can only be called by the current owner.
546      */
547     function transferOwnership(address newOwner) public virtual onlyOwner {
548         require(newOwner != address(0), "Ownable: new owner is the zero address");
549         _setOwner(newOwner);
550     }
551 
552     function _setOwner(address newOwner) private {
553         address oldOwner = _owner;
554         _owner = newOwner;
555         emit OwnershipTransferred(oldOwner, newOwner);
556     }
557 }
558 
559 
560 abstract contract Pausable is Context {
561     /**
562      * @dev Emitted when the pause is triggered by `account`.
563      */
564     event Paused(address account);
565 
566     /**
567      * @dev Emitted when the pause is lifted by `account`.
568      */
569     event Unpaused(address account);
570 
571     bool private _paused;
572 
573     /**
574      * @dev Initializes the contract in unpaused state.
575      */
576     constructor() {
577         _paused = false;
578     }
579 
580     /**
581      * @dev Returns true if the contract is paused, and false otherwise.
582      */
583     function paused() public view virtual returns (bool) {
584         return _paused;
585     }
586 
587     /**
588      * @dev Modifier to make a function callable only when the contract is not paused.
589      *
590      * Requirements:
591      *
592      * - The contract must not be paused.
593      */
594     modifier whenNotPaused() {
595         require(!paused(), "Pausable: paused");
596         _;
597     }
598 
599     /**
600      * @dev Modifier to make a function callable only when the contract is paused.
601      *
602      * Requirements:
603      *
604      * - The contract must be paused.
605      */
606     modifier whenPaused() {
607         require(paused(), "Pausable: not paused");
608         _;
609     }
610 
611     /**
612      * @dev Triggers stopped state.
613      *
614      * Requirements:
615      *
616      * - The contract must not be paused.
617      */
618     function _pause() internal virtual whenNotPaused {
619         _paused = true;
620         emit Paused(_msgSender());
621     }
622 
623     /**
624      * @dev Returns to normal state.
625      *
626      * Requirements:
627      *
628      * - The contract must be paused.
629      */
630     function _unpause() internal virtual whenPaused {
631         _paused = false;
632         emit Unpaused(_msgSender());
633     }
634 }
635 
636 interface IERC721Enumerable is IERC721 {
637     /**
638      * @dev Returns the total amount of tokens stored by the contract.
639      */
640     function totalSupply() external view returns (uint256);
641 
642     /**
643      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
644      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
645      */
646     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
647 
648     /**
649      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
650      * Use along with {totalSupply} to enumerate all tokens.
651      */
652     function tokenByIndex(uint256 index) external view returns (uint256);
653 }
654 
655 interface IERC721Metadata is IERC721 {
656     /**
657      * @dev Returns the token collection name.
658      */
659     function name() external view returns (string memory);
660 
661     /**
662      * @dev Returns the token collection symbol.
663      */
664     function symbol() external view returns (string memory);
665 
666     /**
667      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
668      */
669     function tokenURI(uint256 tokenId) external view returns (string memory);
670 }
671 
672 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
673     using Address for address;
674     using Strings for uint256;
675 
676     // Token name
677     string private _name;
678 
679     // Token symbol
680     string private _symbol;
681 
682     // Mapping from token ID to owner address
683     mapping(uint256 => address) private _owners;
684 
685     // Mapping owner address to token count
686     mapping(address => uint256) private _balances;
687 
688     // Mapping from token ID to approved address
689     mapping(uint256 => address) private _tokenApprovals;
690 
691     // Mapping from owner to operator approvals
692     mapping(address => mapping(address => bool)) private _operatorApprovals;
693 
694     /**
695      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
696      */
697     constructor(string memory name_, string memory symbol_) {
698         _name = name_;
699         _symbol = symbol_;
700     }
701 
702     /**
703      * @dev See {IERC165-supportsInterface}.
704      */
705     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
706         return
707             interfaceId == type(IERC721).interfaceId ||
708             interfaceId == type(IERC721Metadata).interfaceId ||
709             super.supportsInterface(interfaceId);
710     }
711 
712     /**
713      * @dev See {IERC721-balanceOf}.
714      */
715     function balanceOf(address owner) public view virtual override returns (uint256) {
716         require(owner != address(0), "ERC721: balance query for the zero address");
717         return _balances[owner];
718     }
719 
720     /**
721      * @dev See {IERC721-ownerOf}.
722      */
723     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
724         address owner = _owners[tokenId];
725         require(owner != address(0), "ERC721: owner query for nonexistent token");
726         return owner;
727     }
728 
729     /**
730      * @dev See {IERC721Metadata-name}.
731      */
732     function name() public view virtual override returns (string memory) {
733         return _name;
734     }
735 
736     /**
737      * @dev See {IERC721Metadata-symbol}.
738      */
739     function symbol() public view virtual override returns (string memory) {
740         return _symbol;
741     }
742 
743     /**
744      * @dev See {IERC721Metadata-tokenURI}.
745      */
746     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
747         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
748 
749         string memory baseURI = _baseURI();
750         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
751     }
752 
753     /**
754      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
755      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
756      * by default, can be overriden in child contracts.
757      */
758     function _baseURI() internal view virtual returns (string memory) {
759         return "";
760     }
761 
762     /**
763      * @dev See {IERC721-approve}.
764      */
765     function approve(address to, uint256 tokenId) public virtual override {
766         address owner = ERC721.ownerOf(tokenId);
767         require(to != owner, "ERC721: approval to current owner");
768 
769         require(
770             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
771             "ERC721: approve caller is not owner nor approved for all"
772         );
773 
774         _approve(to, tokenId);
775     }
776 
777     /**
778      * @dev See {IERC721-getApproved}.
779      */
780     function getApproved(uint256 tokenId) public view virtual override returns (address) {
781         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
782 
783         return _tokenApprovals[tokenId];
784     }
785 
786     /**
787      * @dev See {IERC721-setApprovalForAll}.
788      */
789     function setApprovalForAll(address operator, bool approved) public virtual override {
790         require(operator != _msgSender(), "ERC721: approve to caller");
791 
792         _operatorApprovals[_msgSender()][operator] = approved;
793         emit ApprovalForAll(_msgSender(), operator, approved);
794     }
795 
796     /**
797      * @dev See {IERC721-isApprovedForAll}.
798      */
799     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
800         return _operatorApprovals[owner][operator];
801     }
802 
803     /**
804      * @dev See {IERC721-transferFrom}.
805      */
806     function transferFrom(
807         address from,
808         address to,
809         uint256 tokenId
810     ) public virtual override {
811         //solhint-disable-next-line max-line-length
812         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
813 
814         _transfer(from, to, tokenId);
815     }
816 
817     /**
818      * @dev See {IERC721-safeTransferFrom}.
819      */
820     function safeTransferFrom(
821         address from,
822         address to,
823         uint256 tokenId
824     ) public virtual override {
825         safeTransferFrom(from, to, tokenId, "");
826     }
827 
828     /**
829      * @dev See {IERC721-safeTransferFrom}.
830      */
831     function safeTransferFrom(
832         address from,
833         address to,
834         uint256 tokenId,
835         bytes memory _data
836     ) public virtual override {
837         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
838         _safeTransfer(from, to, tokenId, _data);
839     }
840 
841     /**
842      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
843      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
844      *
845      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
846      *
847      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
848      * implement alternative mechanisms to perform token transfer, such as signature-based.
849      *
850      * Requirements:
851      *
852      * - `from` cannot be the zero address.
853      * - `to` cannot be the zero address.
854      * - `tokenId` token must exist and be owned by `from`.
855      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
856      *
857      * Emits a {Transfer} event.
858      */
859     function _safeTransfer(
860         address from,
861         address to,
862         uint256 tokenId,
863         bytes memory _data
864     ) internal virtual {
865         _transfer(from, to, tokenId);
866         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
867     }
868 
869     /**
870      * @dev Returns whether `tokenId` exists.
871      *
872      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
873      *
874      * Tokens start existing when they are minted (`_mint`),
875      * and stop existing when they are burned (`_burn`).
876      */
877     function _exists(uint256 tokenId) internal view virtual returns (bool) {
878         return _owners[tokenId] != address(0);
879     }
880 
881     /**
882      * @dev Returns whether `spender` is allowed to manage `tokenId`.
883      *
884      * Requirements:
885      *
886      * - `tokenId` must exist.
887      */
888     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
889         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
890         address owner = ERC721.ownerOf(tokenId);
891         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
892     }
893 
894     /**
895      * @dev Safely mints `tokenId` and transfers it to `to`.
896      *
897      * Requirements:
898      *
899      * - `tokenId` must not exist.
900      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
901      *
902      * Emits a {Transfer} event.
903      */
904     function _safeMint(address to, uint256 tokenId) internal virtual {
905         _safeMint(to, tokenId, "");
906     }
907 
908     /**
909      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
910      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
911      */
912     function _safeMint(
913         address to,
914         uint256 tokenId,
915         bytes memory _data
916     ) internal virtual {
917         _mint(to, tokenId);
918         require(
919             _checkOnERC721Received(address(0), to, tokenId, _data),
920             "ERC721: transfer to non ERC721Receiver implementer"
921         );
922     }
923 
924     /**
925      * @dev Mints `tokenId` and transfers it to `to`.
926      *
927      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
928      *
929      * Requirements:
930      *
931      * - `tokenId` must not exist.
932      * - `to` cannot be the zero address.
933      *
934      * Emits a {Transfer} event.
935      */
936     function _mint(address to, uint256 tokenId) internal virtual {
937         require(to != address(0), "ERC721: mint to the zero address");
938         require(!_exists(tokenId), "ERC721: token already minted");
939 
940         _beforeTokenTransfer(address(0), to, tokenId);
941 
942         _balances[to] += 1;
943         _owners[tokenId] = to;
944 
945         emit Transfer(address(0), to, tokenId);
946     }
947 
948     /**
949      * @dev Destroys `tokenId`.
950      * The approval is cleared when the token is burned.
951      *
952      * Requirements:
953      *
954      * - `tokenId` must exist.
955      *
956      * Emits a {Transfer} event.
957      */
958     function _burn(uint256 tokenId) internal virtual {
959         address owner = ERC721.ownerOf(tokenId);
960 
961         _beforeTokenTransfer(owner, address(0), tokenId);
962 
963         // Clear approvals
964         _approve(address(0), tokenId);
965 
966         _balances[owner] -= 1;
967         delete _owners[tokenId];
968 
969         emit Transfer(owner, address(0), tokenId);
970     }
971 
972     /**
973      * @dev Transfers `tokenId` from `from` to `to`.
974      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
975      *
976      * Requirements:
977      *
978      * - `to` cannot be the zero address.
979      * - `tokenId` token must be owned by `from`.
980      *
981      * Emits a {Transfer} event.
982      */
983     function _transfer(
984         address from,
985         address to,
986         uint256 tokenId
987     ) internal virtual {
988         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
989         require(to != address(0), "ERC721: transfer to the zero address");
990 
991         _beforeTokenTransfer(from, to, tokenId);
992 
993         // Clear approvals from the previous owner
994         _approve(address(0), tokenId);
995 
996         _balances[from] -= 1;
997         _balances[to] += 1;
998         _owners[tokenId] = to;
999 
1000         emit Transfer(from, to, tokenId);
1001     }
1002 
1003     /**
1004      * @dev Approve `to` to operate on `tokenId`
1005      *
1006      * Emits a {Approval} event.
1007      */
1008     function _approve(address to, uint256 tokenId) internal virtual {
1009         _tokenApprovals[tokenId] = to;
1010         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1011     }
1012 
1013     /**
1014      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1015      * The call is not executed if the target address is not a contract.
1016      *
1017      * @param from address representing the previous owner of the given token ID
1018      * @param to target address that will receive the tokens
1019      * @param tokenId uint256 ID of the token to be transferred
1020      * @param _data bytes optional data to send along with the call
1021      * @return bool whether the call correctly returned the expected magic value
1022      */
1023     function _checkOnERC721Received(
1024         address from,
1025         address to,
1026         uint256 tokenId,
1027         bytes memory _data
1028     ) private returns (bool) {
1029         if (to.isContract()) {
1030             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1031                 return retval == IERC721Receiver.onERC721Received.selector;
1032             } catch (bytes memory reason) {
1033                 if (reason.length == 0) {
1034                     revert("ERC721: transfer to non ERC721Receiver implementer");
1035                 } else {
1036                     assembly {
1037                         revert(add(32, reason), mload(reason))
1038                     }
1039                 }
1040             }
1041         } else {
1042             return true;
1043         }
1044     }
1045 
1046     /**
1047      * @dev Hook that is called before any token transfer. This includes minting
1048      * and burning.
1049      *
1050      * Calling conditions:
1051      *
1052      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1053      * transferred to `to`.
1054      * - When `from` is zero, `tokenId` will be minted for `to`.
1055      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1056      * - `from` and `to` are never both zero.
1057      *
1058      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1059      */
1060     function _beforeTokenTransfer(
1061         address from,
1062         address to,
1063         uint256 tokenId
1064     ) internal virtual {}
1065 }
1066 
1067 
1068 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1069     // Mapping from owner to list of owned token IDs
1070     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1071 
1072     // Mapping from token ID to index of the owner tokens list
1073     mapping(uint256 => uint256) private _ownedTokensIndex;
1074 
1075     // Array with all token ids, used for enumeration
1076     uint256[] private _allTokens;
1077 
1078     // Mapping from token id to position in the allTokens array
1079     mapping(uint256 => uint256) private _allTokensIndex;
1080 
1081 
1082     /**
1083      * @dev See {IERC165-supportsInterface}.
1084      */
1085     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1086         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1087     }
1088 
1089     /**
1090      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1091      */
1092     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1093         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1094         return _ownedTokens[owner][index];
1095     }
1096 
1097     /**
1098      * @dev See {IERC721Enumerable-totalSupply}.
1099      */
1100     function totalSupply() public view virtual override returns (uint256) {
1101         return _allTokens.length;
1102     }
1103 
1104     /**
1105      * @dev See {IERC721Enumerable-tokenByIndex}.
1106      */
1107     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1108         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1109         return _allTokens[index];
1110     }
1111 
1112     /**
1113      * @dev Hook that is called before any token transfer. This includes minting
1114      * and burning.
1115      *
1116      * Calling conditions:
1117      *
1118      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1119      * transferred to `to`.
1120      * - When `from` is zero, `tokenId` will be minted for `to`.
1121      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1122      * - `from` cannot be the zero address.
1123      * - `to` cannot be the zero address.
1124      *
1125      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1126      */
1127     function _beforeTokenTransfer(
1128         address from,
1129         address to,
1130         uint256 tokenId
1131     ) internal virtual override {
1132         super._beforeTokenTransfer(from, to, tokenId);
1133 
1134         if (from == address(0)) {
1135             _addTokenToAllTokensEnumeration(tokenId);
1136         } else if (from != to) {
1137             _removeTokenFromOwnerEnumeration(from, tokenId);
1138         }
1139         if (to == address(0)) {
1140             _removeTokenFromAllTokensEnumeration(tokenId);
1141         } else if (to != from) {
1142             _addTokenToOwnerEnumeration(to, tokenId);
1143         }
1144     }
1145 
1146     /**
1147      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1148      * @param to address representing the new owner of the given token ID
1149      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1150      */
1151     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1152         uint256 length = ERC721.balanceOf(to);
1153         _ownedTokens[to][length] = tokenId;
1154         _ownedTokensIndex[tokenId] = length;
1155     }
1156 
1157     /**
1158      * @dev Private function to add a token to this extension's token tracking data structures.
1159      * @param tokenId uint256 ID of the token to be added to the tokens list
1160      */
1161     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1162         _allTokensIndex[tokenId] = _allTokens.length;
1163         _allTokens.push(tokenId);
1164     }
1165 
1166     /**
1167      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1168      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1169      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1170      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1171      * @param from address representing the previous owner of the given token ID
1172      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1173      */
1174     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1175         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1176         // then delete the last slot (swap and pop).
1177 
1178         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1179         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1180 
1181         // When the token to delete is the last token, the swap operation is unnecessary
1182         if (tokenIndex != lastTokenIndex) {
1183             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1184 
1185             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1186             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1187         }
1188 
1189         // This also deletes the contents at the last position of the array
1190         delete _ownedTokensIndex[tokenId];
1191         delete _ownedTokens[from][lastTokenIndex];
1192     }
1193 
1194     /**
1195      * @dev Private function to remove a token from this extension's token tracking data structures.
1196      * This has O(1) time complexity, but alters the order of the _allTokens array.
1197      * @param tokenId uint256 ID of the token to be removed from the tokens list
1198      */
1199     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1200         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1201         // then delete the last slot (swap and pop).
1202 
1203         uint256 lastTokenIndex = _allTokens.length - 1;
1204         uint256 tokenIndex = _allTokensIndex[tokenId];
1205 
1206         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1207         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1208         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1209         uint256 lastTokenId = _allTokens[lastTokenIndex];
1210 
1211         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1212         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1213 
1214         // This also deletes the contents at the last position of the array
1215         delete _allTokensIndex[tokenId];
1216         _allTokens.pop();
1217     }
1218 }
1219 
1220 
1221 contract KONGS is IKONGS, ERC721Enumerable, Ownable, Pausable {
1222     uint256 public MINT_PRICE = .02 ether;
1223     uint256 public MAX_TOKENS;
1224     uint256 public PAID_TOKENS;
1225     uint16 public minted;
1226     uint256 reserved;
1227     uint256 reserveLimit;
1228     uint256 nonReserved;
1229 
1230     struct whitelist{
1231         uint256 amount;
1232         }
1233 
1234     mapping (address => whitelist) whitelisted;
1235     mapping (address => whitelist) reservedMinters;
1236     bool whitelistMode;
1237 
1238  
1239     mapping(uint256 => uint256) private mintBlock;
1240     mapping(uint256 => KaijuKong) private tokenTraits;
1241     uint8[][19] public rarities;
1242     uint8[][19] public aliases;
1243     // reference to the KongIsland for choosing random Kong thieves
1244     IKongIsland public kongIsland;
1245     // reference to $FOOD for burning on mint
1246     IFOOD public food;
1247     // reference to Traits
1248     ITraits public traits;
1249 
1250 
1251     /**
1252      * instantiates contract and rarity tables
1253      */
1254     constructor(
1255         address _food,
1256         address _traits,
1257         uint256 _maxTokens,
1258         uint256 _reserved
1259     ) ERC721("Kong Game", "KGAME") {
1260         food = IFOOD(_food);
1261         traits = ITraits(_traits);
1262         MAX_TOKENS = _maxTokens;
1263         PAID_TOKENS = _maxTokens / 5;
1264         nonReserved = _reserved;
1265         reserveLimit = _reserved;
1266         rarities[0] = [255, 200, 150, 100, 50];
1267         aliases[0] = [0, 1, 2, 3, 4];
1268         rarities[1] = [255,200,160,130,96,63];
1269         aliases[1] = [0,1,3,3,2,0];
1270         rarities[2] = [255,72,52,12,6];
1271         aliases[2] = [0,1,2,1,0];
1272         rarities[3] = [255];
1273         aliases[3] = [0];
1274 
1275         rarities[4] = [255];
1276         aliases[4] = [0];
1277         rarities[5] = [255];
1278         aliases[5] = [0];
1279         rarities[6] = [255];
1280         aliases[6] = [0];
1281         rarities[7] = [255];
1282         aliases[7] = [0];
1283         rarities[8] = [255];
1284         aliases[8] = [0];
1285         rarities[9] = [255];
1286         aliases[9] = [0];
1287         rarities[10] = [255];
1288         aliases[10] = [0];
1289         rarities[11] = [255];
1290         aliases[11] = [0];
1291         rarities[12] = [255];
1292         aliases[12] = [0];
1293 
1294         rarities[13] = [255,165,51,43,18,5];
1295         aliases[13] = [0,1,1,3,4,0];
1296 
1297 
1298         rarities[14] = [255,37,15];
1299         aliases[14] = [0,1,0];
1300 
1301         rarities[15] = [255,57,23];
1302         aliases[15] = [0,1,0];
1303 
1304         rarities[16] = [255,70];
1305         aliases[16] = [0,1];
1306 
1307 
1308         rarities[17] = [255,37,15];
1309         aliases[17] = [0,1,0];
1310 
1311         rarities[18] = [255,165,51,43,18,5];
1312         aliases[18] = [0,1,2,3,4,0];
1313     }
1314 
1315     /** EXTERNAL */
1316     function mint(uint256 amount) external payable whenNotPaused {
1317     require(amount <= 5, "Maxmimum 5 mints at a time");
1318     require(tx.origin == _msgSender(), "Only EOA");
1319     require(minted + amount <= MAX_TOKENS, "All tokens minted");
1320     if(whitelistMode){require(amount <= whitelisted[_msgSender()].amount, "Whitelisted can mint maximum of 3");}
1321     if (minted < PAID_TOKENS) {
1322       require(minted + amount <= PAID_TOKENS, "All tokens on-sale already sold");
1323       require(amount * MINT_PRICE >= msg.value, "Invalid payment amount");
1324     } else {
1325       require(msg.value == 0);
1326     }
1327     uint256 totalFOODCost = 0;
1328     uint256 seed;
1329         for (uint256 i = 0; i < amount; i++) {
1330             minted++;
1331             nonReserved++;
1332             if(whitelistMode){whitelisted[ _msgSender()].amount--;}
1333 	        mintBlock[nonReserved] = block.number;
1334             seed = random(nonReserved);
1335             generate(nonReserved, seed);
1336             address recipient = selectRecipient(seed);
1337             totalFOODCost += mintCost(nonReserved);
1338             _safeMint(recipient, nonReserved);
1339         }
1340         if (totalFOODCost > 0) food.burn(_msgSender(), totalFOODCost);
1341     }
1342 
1343     function reservedMint(uint256 amount) external {
1344     require(amount <= 5, "Maxmimum 5 mints at a time");
1345     require(amount <= reservedMinters[msg.sender].amount);
1346     uint256 seed;
1347         for (uint256 i = 0; i < amount; i++) {
1348             minted++;
1349             reserved++;
1350 	        mintBlock[reserved] = block.number;
1351             seed = random(reserved);
1352             generate(reserved, seed);
1353             _safeMint(msg.sender,reserved);
1354         }
1355     }
1356 
1357   function mintCost(uint256 tokenId) public view returns (uint256) {
1358     if (tokenId <= PAID_TOKENS) return 0;
1359     if (tokenId <= MAX_TOKENS * 2 / 5) return 20000 ether;
1360     if (tokenId <= MAX_TOKENS * 3 / 5) return 40000 ether;
1361     if (tokenId <= MAX_TOKENS * 4 / 5) return 80000 ether;
1362     return 100000 ether;
1363   }
1364 
1365     function transferFrom(
1366         address from,
1367         address to,
1368         uint256 tokenId
1369     ) public virtual override {
1370         if (_msgSender() != address(kongIsland)) {
1371             require(
1372                 _isApprovedOrOwner(_msgSender(), tokenId),
1373                 "ERC721: transfer caller is not owner nor approved"
1374             );
1375         }
1376         _transfer(from, to, tokenId);
1377     }
1378 
1379     /** INTERNAL */
1380 
1381     function generate(uint256 tokenId, uint256 seed)
1382         internal
1383         returns (KaijuKong memory t)
1384     {
1385         t = selectTraits(seed);
1386         tokenTraits[tokenId] = t;
1387         return t;
1388     }
1389 
1390     /**
1391      * uses A.J. Walker's Alias algorithm for O(1) rarity table lookup
1392      * ensuring O(1) instead of O(n) reduces mint cost by more than 50%
1393      * probability & alias tables are generated off-chain beforehand
1394      * @param seed portion of the 256 bit seed to remove trait correlation
1395      * @param traitType the trait type to select a trait for
1396      * @return the ID of the randomly selected trait
1397      */
1398     function selectTrait(uint16 seed, uint8 traitType)
1399         internal
1400         view
1401         returns (uint8)
1402     {
1403         uint8 trait = uint8(seed) % uint8(rarities[traitType].length);
1404         if (seed >> 9 < rarities[traitType][trait]) return trait;
1405         return aliases[traitType][trait];
1406     }
1407 
1408     /**
1409      * the first 20% (ETH purchases) go to the minter
1410      * the remaining 80% have a 10% chance to be given to a random staked Kong
1411      * @param seed a random value to select a recipient from
1412      * @return the address of the recipient (either the minter or the Kong thief's owner)
1413      */
1414 
1415      
1416   function selectRecipient(uint256 seed) internal view returns (address) {
1417     if (minted <= PAID_TOKENS || minted < 30000 && ((seed >> 245) % 10) != 0 || minted >30000 && ((seed >> 245) % 10) >=2) return _msgSender(); // top 10 bits haven't been used
1418     address thief = kongIsland.randomKongOwner(seed >> 144); // 144 bits reserved for trait selection
1419     if (thief == address(0x0)) return _msgSender();
1420     return thief;
1421   }
1422 
1423     /**
1424      * selects the species and all of its traits based on the seed value
1425      * @param seed a pseudorandom 256 bit number to derive traits from
1426      * @return t -  a struct of randomly selected traits
1427      */
1428     function selectTraits(uint256 seed)
1429         internal
1430         view
1431         returns (KaijuKong memory t)
1432     {
1433         t.isKaiju = (seed & 0xFFFF) % 10 != 0;
1434         uint8 shift = t.isKaiju ? 0 : 9;
1435         seed >>= 16;
1436         t.background = selectTrait(uint16(seed & 0xFFFF), 0);
1437         seed >>= 16;
1438         t.species = selectTrait(uint16(seed & 0xFFFF), 1 + shift);
1439         seed >>= 16;
1440         t.companion = selectTrait(uint16(seed & 0xFFFF), 2 + shift);
1441         seed >>= 16;
1442         t.kingScore = selectTrait(uint16(seed & 0xFFFF), 9 + shift);
1443         seed >>= 16;
1444         t.hat = selectTrait(uint16(seed & 0xFFFF), 5 + shift);
1445         seed >>= 16;
1446         t.face = selectTrait(uint16(seed & 0xFFFF), 6 + shift);
1447         seed >>= 16;
1448         t.weapons = selectTrait(uint16(seed & 0xFFFF), 7 + shift);
1449         seed >>= 16;
1450         t.accessories = selectTrait(uint16(seed & 0xFFFF), 8 + shift);
1451         seed >>= 16;
1452         t.fur = t.kingScore;
1453     }
1454 
1455     function structToHash(KaijuKong memory s) internal pure returns (uint256) {
1456         return
1457             uint256(
1458                 bytes32(
1459                     abi.encodePacked(
1460                         s.isKaiju,
1461                         s.background,
1462                         s.species,
1463                         s.companion,
1464                         s.fur,
1465                         s.hat,
1466                         s.face,
1467                         s.weapons,
1468                         s.accessories,
1469                         s.kingScore
1470                     )
1471                 )
1472             );
1473     }
1474 
1475   function random(uint256 seed) internal view returns (uint256) {
1476     return uint256(keccak256(abi.encodePacked(
1477       tx.origin,
1478       blockhash(block.number - 1),
1479       block.timestamp,
1480       seed
1481     )));
1482   }
1483 
1484     /** READ */
1485 
1486     function getTokenTraits(uint256 tokenId)
1487         external
1488         view
1489         override
1490         returns (KaijuKong memory)
1491     {
1492         require(mintBlock[tokenId] + 1 < block.number);
1493         return tokenTraits[tokenId];
1494     }
1495 
1496     function getPaidTokens() external view override returns (uint256) {
1497         return PAID_TOKENS;
1498     }
1499 
1500     function isKaiju(uint256 tokenId) external view returns (bool){
1501         require(mintBlock[tokenId] + 1 < block.number);
1502         return(tokenTraits[tokenId].isKaiju);
1503     }
1504 
1505     function KingScore(uint256 tokenId) external view returns (uint8) {
1506         require(mintBlock[tokenId] + 1 < block.number);
1507         return(tokenTraits[tokenId].kingScore);
1508     }
1509 
1510     function getIDsOwnedby(address _address) external view returns(uint256[] memory) {
1511         uint256[] memory tokensOwned = new uint256[](balanceOf(_address));
1512         for(uint256 i = 0; i < tokensOwned.length; i++) {
1513             tokensOwned[i] = tokenOfOwnerByIndex(_address, i);
1514         }
1515         return tokensOwned;
1516     }
1517 
1518     /** ADMIN */
1519 
1520     function setKongIsland(address _KongIsland) external onlyOwner {
1521         kongIsland = IKongIsland(_KongIsland);
1522     }
1523 
1524     function addToWhitelist(address _whitelisted) external onlyOwner {
1525         whitelisted[_whitelisted].amount = 3;
1526     }
1527 
1528     function bulkWhitelist(address[] calldata _whitelisted) external onlyOwner {
1529         for (uint256 i = 0; i < _whitelisted.length; i++) {
1530         whitelisted[_whitelisted[i]].amount = 3;
1531         }
1532     }
1533 
1534     function addToReservedMinters(address _reserved, uint256 _amount) external onlyOwner {
1535         reservedMinters[_reserved].amount = _amount;
1536     }
1537 
1538     function bulkWhitelist(address[] calldata _reserved,uint256[] calldata _amount) external onlyOwner {
1539         for (uint256 i = 0; i < _reserved.length; i++) {
1540         reservedMinters[_reserved[i]].amount = _amount[i];
1541         }
1542     }
1543 
1544     function withdraw() external onlyOwner {
1545         payable(owner()).transfer(address(this).balance);
1546     }
1547 
1548     function whitelistMinting(bool _whitelistMode)external onlyOwner {
1549         whitelistMode = _whitelistMode;
1550     }
1551 
1552     function setPaidTokens(uint256 _paidTokens) external onlyOwner {
1553         PAID_TOKENS = _paidTokens;
1554     }
1555 
1556     function setPaused(bool _paused) external onlyOwner {
1557         if (_paused) _pause();
1558         else _unpause();
1559     }
1560 
1561   function setMintPrice(uint256 mintprice) external onlyOwner{
1562         MINT_PRICE = mintprice;
1563     }
1564 
1565   function updateFoodContract(address _food) external onlyOwner {
1566         food = IFOOD(_food);
1567     }
1568 
1569     /** RENDER */
1570 
1571   function tokenURI(uint256 tokenId) public view override returns (string memory) {
1572     require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1573     require(mintBlock[tokenId] + 1 < block.number);
1574     return traits.tokenURI(tokenId);
1575   }
1576 
1577 }