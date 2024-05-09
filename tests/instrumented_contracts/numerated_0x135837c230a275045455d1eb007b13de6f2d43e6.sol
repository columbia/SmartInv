1 // SPDX-License-Identifier: MIT
2 
3 /**
4 ▌│█║▌║▌║   🎀  𝒩𝓊𝒹𝑒𝓈  🎀   ║▌║▌║█│▌
5 */
6 
7 pragma solidity ^0.8.0;
8 
9 library Counters {
10     struct Counter {
11 
12         uint256 _value; // default: 0
13     }
14 
15     function current(Counter storage counter) internal view returns (uint256) {
16         return counter._value;
17     }
18 
19     function increment(Counter storage counter) internal {
20         unchecked {
21             counter._value += 1;
22         }
23     }
24 
25     function decrement(Counter storage counter) internal {
26         uint256 value = counter._value;
27         require(value > 0, "Counter:decrement overflow");
28         unchecked {
29             counter._value = value - 1;
30         }
31     }
32 
33     function reset(Counter storage counter) internal {
34         counter._value = 0;
35     }
36 }
37 
38 
39 pragma solidity ^0.8.0;
40 
41 /**
42  * @dev String operations.
43  */
44 library Strings {
45     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
46 
47     /**
48      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
49      */
50     function toString(uint256 value) internal pure returns (string memory) {
51         // Inspired by OraclizeAPI's implementation - MIT licence
52         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
53 
54         if (value == 0) {
55             return "0";
56         }
57         uint256 temp = value;
58         uint256 digits;
59         while (temp != 0) {
60             digits++;
61             temp /= 10;
62         }
63         bytes memory buffer = new bytes(digits);
64         while (value != 0) {
65             digits -= 1;
66             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
67             value /= 10;
68         }
69         return string(buffer);
70     }
71 
72     /**
73      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
74      */
75     function toHexString(uint256 value) internal pure returns (string memory) {
76         if (value == 0) {
77             return "0x00";
78         }
79         uint256 temp = value;
80         uint256 length = 0;
81         while (temp != 0) {
82             length++;
83             temp >>= 8;
84         }
85         return toHexString(value, length);
86     }
87 
88     /**
89      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
90      */
91     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
92         bytes memory buffer = new bytes(2 * length + 2);
93         buffer[0] = "0";
94         buffer[1] = "x";
95         for (uint256 i = 2 * length + 1; i > 1; --i) {
96             buffer[i] = _HEX_SYMBOLS[value & 0xf];
97             value >>= 4;
98         }
99         require(value == 0, "Strings: hex length insufficient");
100         return string(buffer);
101     }
102 }
103 
104 pragma solidity ^0.8.0;
105 
106 /**
107  * @dev Provides information about the current execution context, including the
108  * sender of the transaction and its data. While these are generally available
109  * via msg.sender and msg.data, they should not be accessed in such a direct
110  * manner, since when dealing with meta-transactions the account sending and
111  * paying for execution may not be the actual sender (as far as an application
112  * is concerned).
113  *
114  * This contract is only required for intermediate, library-like contracts.
115  */
116 abstract contract Context {
117     function _msgSender() internal view virtual returns (address) {
118         return msg.sender;
119     }
120 
121     function _msgData() internal view virtual returns (bytes calldata) {
122         return msg.data;
123     }
124 }
125 
126 
127 pragma solidity ^0.8.0;
128 
129 abstract contract Ownable is Context {
130     address private _owner;
131 
132     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
133 
134     /**
135      * @dev Initializes the contract setting the deployer as the initial owner.
136      */
137     constructor() {
138         _transferOwnership(_msgSender());
139     }
140 
141     /**
142      * @dev Returns the address of the current owner.
143      */
144     function owner() public view virtual returns (address) {
145         return _owner;
146     }
147 
148     /**
149      * @dev Throws if called by any account other than the owner.
150      */
151     modifier onlyOwner() {
152         require(owner() == _msgSender(), "Ownable: caller is not the owner");
153         _;
154     }
155 
156     /**
157      * @dev Leaves the contract without owner. It will not be possible to call
158      * `onlyOwner` functions anymore. Can only be called by the current owner.
159      *
160      * NOTE: Renouncing ownership will leave the contract without an owner,
161      * thereby removing any functionality that is only available to the owner.
162      */
163     function renounceOwnership() public virtual onlyOwner {
164         _transferOwnership(address(0));
165     }
166 
167     /**
168      * @dev Transfers ownership of the contract to a new account (`newOwner`).
169      * Can only be called by the current owner.
170      */
171     function transferOwnership(address newOwner) public virtual onlyOwner {
172         require(newOwner != address(0), "Ownable: new owner is the zero address");
173         _transferOwnership(newOwner);
174     }
175 
176     /**
177      * @dev Transfers ownership of the contract to a new account (`newOwner`).
178      * Internal function without access restriction.
179      */
180     function _transferOwnership(address newOwner) internal virtual {
181         address oldOwner = _owner;
182         _owner = newOwner;
183         emit OwnershipTransferred(oldOwner, newOwner);
184     }
185 }
186 
187 pragma solidity ^0.8.1;
188 
189 /**
190  * @dev Collection of functions related to the address type
191  */
192 library Address {
193     /**
194      * @dev Returns true if `account` is a contract.
195      *
196      * [IMPORTANT]
197      * ====
198      * It is unsafe to assume that an address for which this function returns
199      * false is an externally-owned account (EOA) and not a contract.
200      *
201      * Among others, `isContract` will return false for the following
202      * types of addresses:
203      *
204      *  - an externally-owned account
205      *  - a contract in construction
206      *  - an address where a contract will be created
207      *  - an address where a contract lived, but was destroyed
208      * ====
209      *
210      * [IMPORTANT]
211      * ====
212      * You shouldn't rely on `isContract` to protect against flash loan attacks!
213      *
214      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
215      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
216      * constructor.
217      * ====
218      */
219     function isContract(address account) internal view returns (bool) {
220         // This method relies on extcodesize/address.code.length, which returns 0
221         // for contracts in construction, since the code is only stored at the end
222         // of the constructor execution.
223 
224         return account.code.length > 0;
225     }
226 
227     /**
228      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
229      * `recipient`, forwarding all available gas and reverting on errors.
230      *
231      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
232      * of certain opcodes, possibly making contracts go over the 2300 gas limit
233      * imposed by `transfer`, making them unable to receive funds via
234      * `transfer`. {sendValue} removes this limitation.
235      *
236      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
237      *
238      * IMPORTANT: because control is transferred to `recipient`, care must be
239      * taken to not create reentrancy vulnerabilities. Consider using
240      * {ReentrancyGuard} or the
241      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
242      */
243     function sendValue(address payable recipient, uint256 amount) internal {
244         require(address(this).balance >= amount, "Address: insufficient balance");
245 
246         (bool success, ) = recipient.call{value: amount}("");
247         require(success, "Address: unable to send value, recipient may have reverted");
248     }
249 
250     /**
251      * @dev Performs a Solidity function call using a low level `call`. A
252      * plain `call` is an unsafe replacement for a function call: use this
253      * function instead.
254      *
255      * If `target` reverts with a revert reason, it is bubbled up by this
256      * function (like regular Solidity function calls).
257      *
258      * Returns the raw returned data. To convert to the expected return value,
259      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
260      *
261      * Requirements:
262      *
263      * - `target` must be a contract.
264      * - calling `target` with `data` must not revert.
265      *
266      * _Available since v3.1._
267      */
268     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
269         return functionCall(target, data, "Address: low-level call failed");
270     }
271 
272     /**
273      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
274      * `errorMessage` as a fallback revert reason when `target` reverts.
275      *
276      * _Available since v3.1._
277      */
278     function functionCall(
279         address target,
280         bytes memory data,
281         string memory errorMessage
282     ) internal returns (bytes memory) {
283         return functionCallWithValue(target, data, 0, errorMessage);
284     }
285 
286     /**
287      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
288      * but also transferring `value` wei to `target`.
289      *
290      * Requirements:
291      *
292      * - the calling contract must have an ETH balance of at least `value`.
293      * - the called Solidity function must be `payable`.
294      *
295      * _Available since v3.1._
296      */
297     function functionCallWithValue(
298         address target,
299         bytes memory data,
300         uint256 value
301     ) internal returns (bytes memory) {
302         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
303     }
304 
305     /**
306      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
307      * with `errorMessage` as a fallback revert reason when `target` reverts.
308      *
309      * _Available since v3.1._
310      */
311     function functionCallWithValue(
312         address target,
313         bytes memory data,
314         uint256 value,
315         string memory errorMessage
316     ) internal returns (bytes memory) {
317         require(address(this).balance >= value, "Address: insufficient balance for call");
318         require(isContract(target), "Address: call to non-contract");
319 
320         (bool success, bytes memory returndata) = target.call{value: value}(data);
321         return verifyCallResult(success, returndata, errorMessage);
322     }
323 
324     /**
325      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
326      * but performing a static call.
327      *
328      * _Available since v3.3._
329      */
330     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
331         return functionStaticCall(target, data, "Address: low-level static call failed");
332     }
333 
334     /**
335      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
336      * but performing a static call.
337      *
338      * _Available since v3.3._
339      */
340     function functionStaticCall(
341         address target,
342         bytes memory data,
343         string memory errorMessage
344     ) internal view returns (bytes memory) {
345         require(isContract(target), "Address: static call to non-contract");
346 
347         (bool success, bytes memory returndata) = target.staticcall(data);
348         return verifyCallResult(success, returndata, errorMessage);
349     }
350 
351     /**
352      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
353      * but performing a delegate call.
354      *
355      * _Available since v3.4._
356      */
357     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
358         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
359     }
360 
361     /**
362      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
363      * but performing a delegate call.
364      *
365      * _Available since v3.4._
366      */
367     function functionDelegateCall(
368         address target,
369         bytes memory data,
370         string memory errorMessage
371     ) internal returns (bytes memory) {
372         require(isContract(target), "Address: delegate call to non-contract");
373 
374         (bool success, bytes memory returndata) = target.delegatecall(data);
375         return verifyCallResult(success, returndata, errorMessage);
376     }
377 
378     /**
379      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
380      * revert reason using the provided one.
381      *
382      * _Available since v4.3._
383      */
384     function verifyCallResult(
385         bool success,
386         bytes memory returndata,
387         string memory errorMessage
388     ) internal pure returns (bytes memory) {
389         if (success) {
390             return returndata;
391         } else {
392             // Look for revert reason and bubble it up if present
393             if (returndata.length > 0) {
394                 // The easiest way to bubble the revert reason is using memory via assembly
395 
396                 assembly {
397                     let returndata_size := mload(returndata)
398                     revert(add(32, returndata), returndata_size)
399                 }
400             } else {
401                 revert(errorMessage);
402             }
403         }
404     }
405 }
406 
407 pragma solidity ^0.8.0;
408 
409 /**
410  * @title ERC721 token receiver interface
411  * @dev Interface for any contract that wants to support safeTransfers
412  * from ERC721 asset contracts.
413  */
414 interface IERC721Receiver {
415     /**
416      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
417      * by `operator` from `from`, this function is called.
418      *
419      * It must return its Solidity selector to confirm the token transfer.
420      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
421      *
422      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
423      */
424     function onERC721Received(
425         address operator,
426         address from,
427         uint256 tokenId,
428         bytes calldata data
429     ) external returns (bytes4);
430 }
431 
432 pragma solidity ^0.8.0;
433 
434 /**
435  * @dev Interface of the ERC165 standard, as defined in the
436  * https://eips.ethereum.org/EIPS/eip-165[EIP].
437  *
438  * Implementers can declare support of contract interfaces, which can then be
439  * queried by others ({ERC165Checker}).
440  *
441  * For an implementation, see {ERC165}.
442  */
443 interface IERC165 {
444     /**
445      * @dev Returns true if this contract implements the interface defined by
446      * `interfaceId`. See the corresponding
447      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
448      * to learn more about how these ids are created.
449      *
450      * This function call must use less than 30 000 gas.
451      */
452     function supportsInterface(bytes4 interfaceId) external view returns (bool);
453 }
454 
455 pragma solidity ^0.8.0;
456 
457 abstract contract ERC165 is IERC165 {
458     /**
459      * @dev See {IERC165-supportsInterface}.
460      */
461     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
462         return interfaceId == type(IERC165).interfaceId;
463     }
464 }
465 
466 pragma solidity ^0.8.0;
467 
468 interface IERC721 is IERC165 {
469     /**
470      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
471      */
472     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
473 
474     /**
475      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
476      */
477     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
478 
479     /**
480      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
481      */
482     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
483 
484     /**
485      * @dev Returns the number of tokens in ``owner``'s account.
486      */
487     function balanceOf(address owner) external view returns (uint256 balance);
488 
489     /**
490      * @dev Returns the owner of the `tokenId` token.
491      *
492      * Requirements:
493      *
494      * - `tokenId` must exist.
495      */
496     function ownerOf(uint256 tokenId) external view returns (address owner);
497 
498     function safeTransferFrom(
499         address from,
500         address to,
501         uint256 tokenId
502     ) external;
503 
504     function transferFrom(
505         address from,
506         address to,
507         uint256 tokenId
508     ) external;
509 
510     function approve(address to, uint256 tokenId) external;
511 
512     /**
513      * @dev Returns the account approved for `tokenId` token.
514      *
515      * Requirements:
516      *
517      * - `tokenId` must exist.
518      */
519     function getApproved(uint256 tokenId) external view returns (address operator);
520 
521     /**
522      * @dev Approve or remove `operator` as an operator for the caller.
523      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
524      *
525      * Requirements:
526      *
527      * - The `operator` cannot be the caller.
528      *
529      * Emits an {ApprovalForAll} event.
530      */
531     function setApprovalForAll(address operator, bool _approved) external;
532 
533     /**
534      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
535      *
536      * See {setApprovalForAll}
537      */
538     function isApprovedForAll(address owner, address operator) external view returns (bool);
539 
540     /**
541      * @dev Safely transfers `tokenId` token from `from` to `to`.
542      *
543      * Requirements:
544      *
545      * - `from` cannot be the zero address.
546      * - `to` cannot be the zero address.
547      * - `tokenId` token must exist and be owned by `from`.
548      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
549      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
550      *
551      * Emits a {Transfer} event.
552      */
553     function safeTransferFrom(
554         address from,
555         address to,
556         uint256 tokenId,
557         bytes calldata data
558     ) external;
559 }
560 
561 
562 pragma solidity ^0.8.0;
563 
564 
565 /**
566  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
567  * @dev See https://eips.ethereum.org/EIPS/eip-721
568  */
569 interface IERC721Enumerable is IERC721 {
570     /**
571      * @dev Returns the total amount of tokens stored by the contract.
572      */
573     function totalSupply() external view returns (uint256);
574 
575     /**
576      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
577      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
578      */
579     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
580 
581     /**
582      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
583      * Use along with {totalSupply} to enumerate all tokens.
584      */
585     function tokenByIndex(uint256 index) external view returns (uint256);
586 }
587 
588 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
589 
590 
591 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
592 
593 pragma solidity ^0.8.0;
594 
595 
596 /**
597  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
598  * @dev See https://eips.ethereum.org/EIPS/eip-721
599  */
600 interface IERC721Metadata is IERC721 {
601     /**
602      * @dev Returns the token collection name.
603      */
604     function name() external view returns (string memory);
605 
606     /**
607      * @dev Returns the token collection symbol.
608      */
609     function symbol() external view returns (string memory);
610 
611     /**
612      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
613      */
614     function tokenURI(uint256 tokenId) external view returns (string memory);
615 }
616 
617 
618 pragma solidity ^0.8.0;
619 
620 /**
621  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
622  * the Metadata extension, but not including the Enumerable extension, which is available separately as
623  * {ERC721Enumerable}.
624  */
625 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
626     using Address for address;
627     using Strings for uint256;
628 
629     // Token name
630     string private _name;
631 
632     // Token symbol
633     string private _symbol;
634 
635     // Mapping from token ID to owner address
636     mapping(uint256 => address) private _owners;
637 
638     // Mapping owner address to token count
639     mapping(address => uint256) private _balances;
640 
641     // Mapping from token ID to approved address
642     mapping(uint256 => address) private _tokenApprovals;
643 
644     // Mapping from owner to operator approvals
645     mapping(address => mapping(address => bool)) private _operatorApprovals;
646 
647     /**
648      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
649      */
650     constructor(string memory name_, string memory symbol_) {
651         _name = name_;
652         _symbol = symbol_;
653     }
654 
655     /**
656      * @dev See {IERC165-supportsInterface}.
657      */
658     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
659         return
660             interfaceId == type(IERC721).interfaceId ||
661             interfaceId == type(IERC721Metadata).interfaceId ||
662             super.supportsInterface(interfaceId);
663     }
664 
665     /**
666      * @dev See {IERC721-balanceOf}.
667      */
668     function balanceOf(address owner) public view virtual override returns (uint256) {
669         require(owner != address(0), "ERC721: balance query for the zero address");
670         return _balances[owner];
671     }
672 
673     /**
674      * @dev See {IERC721-ownerOf}.
675      */
676     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
677         address owner = _owners[tokenId];
678         require(owner != address(0), "ERC721: owner query for nonexistent token");
679         return owner;
680     }
681 
682     /**
683      * @dev See {IERC721Metadata-name}.
684      */
685     function name() public view virtual override returns (string memory) {
686         return _name;
687     }
688 
689     /**
690      * @dev See {IERC721Metadata-symbol}.
691      */
692     function symbol() public view virtual override returns (string memory) {
693         return _symbol;
694     }
695 
696     /**
697      * @dev See {IERC721Metadata-tokenURI}.
698      */
699     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
700         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
701 
702         string memory baseURI = _baseURI();
703         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
704     }
705 
706     /**
707      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
708      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
709      * by default, can be overriden in child contracts.
710      */
711     function _baseURI() internal view virtual returns (string memory) {
712         return "";
713     }
714 
715     /**
716      * @dev See {IERC721-approve}.
717      */
718     function approve(address to, uint256 tokenId) public virtual override {
719         address owner = ERC721.ownerOf(tokenId);
720         require(to != owner, "ERC721: approval to current owner");
721 
722         require(
723             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
724             "ERC721: approve caller is not owner nor approved for all"
725         );
726 
727         _approve(to, tokenId);
728     }
729 
730     /**
731      * @dev See {IERC721-getApproved}.
732      */
733     function getApproved(uint256 tokenId) public view virtual override returns (address) {
734         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
735 
736         return _tokenApprovals[tokenId];
737     }
738 
739     /**
740      * @dev See {IERC721-setApprovalForAll}.
741      */
742     function setApprovalForAll(address operator, bool approved) public virtual override {
743         _setApprovalForAll(_msgSender(), operator, approved);
744     }
745 
746     /**
747      * @dev See {IERC721-isApprovedForAll}.
748      */
749     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
750         return _operatorApprovals[owner][operator];
751     }
752 
753     /**
754      * @dev See {IERC721-transferFrom}.
755      */
756     function transferFrom(
757         address from,
758         address to,
759         uint256 tokenId
760     ) public virtual override {
761         //solhint-disable-next-line max-line-length
762         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
763 
764         _transfer(from, to, tokenId);
765     }
766 
767     /**
768      * @dev See {IERC721-safeTransferFrom}.
769      */
770     function safeTransferFrom(
771         address from,
772         address to,
773         uint256 tokenId
774     ) public virtual override {
775         safeTransferFrom(from, to, tokenId, "");
776     }
777 
778     /**
779      * @dev See {IERC721-safeTransferFrom}.
780      */
781     function safeTransferFrom(
782         address from,
783         address to,
784         uint256 tokenId,
785         bytes memory _data
786     ) public virtual override {
787         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
788         _safeTransfer(from, to, tokenId, _data);
789     }
790 
791     /**
792      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
793      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
794      *
795      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
796      *
797      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
798      * implement alternative mechanisms to perform token transfer, such as signature-based.
799      *
800      * Requirements:
801      *
802      * - `from` cannot be the zero address.
803      * - `to` cannot be the zero address.
804      * - `tokenId` token must exist and be owned by `from`.
805      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
806      *
807      * Emits a {Transfer} event.
808      */
809     function _safeTransfer(
810         address from,
811         address to,
812         uint256 tokenId,
813         bytes memory _data
814     ) internal virtual {
815         _transfer(from, to, tokenId);
816         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
817     }
818 
819     /**
820      * @dev Returns whether `tokenId` exists.
821      *
822      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
823      *
824      * Tokens start existing when they are minted (`_mint`),
825      * and stop existing when they are burned (`_burn`).
826      */
827     function _exists(uint256 tokenId) internal view virtual returns (bool) {
828         return _owners[tokenId] != address(0);
829     }
830 
831     /**
832      * @dev Returns whether `spender` is allowed to manage `tokenId`.
833      *
834      * Requirements:
835      *
836      * - `tokenId` must exist.
837      */
838     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
839         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
840         address owner = ERC721.ownerOf(tokenId);
841         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
842     }
843 
844     /**
845      * @dev Safely mints `tokenId` and transfers it to `to`.
846      *
847      * Requirements:
848      *
849      * - `tokenId` must not exist.
850      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
851      *
852      * Emits a {Transfer} event.
853      */
854     function _safeMint(address to, uint256 tokenId) internal virtual {
855         _safeMint(to, tokenId, "");
856     }
857 
858     /**
859      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
860      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
861      */
862     function _safeMint(
863         address to,
864         uint256 tokenId,
865         bytes memory _data
866     ) internal virtual {
867         _mint(to, tokenId);
868         require(
869             _checkOnERC721Received(address(0), to, tokenId, _data),
870             "ERC721: transfer to non ERC721Receiver implementer"
871         );
872     }
873 
874     /**
875      * @dev Mints `tokenId` and transfers it to `to`.
876      *
877      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
878      *
879      * Requirements:
880      *
881      * - `tokenId` must not exist.
882      * - `to` cannot be the zero address.
883      *
884      * Emits a {Transfer} event.
885      */
886     function _mint(address to, uint256 tokenId) internal virtual {
887         require(to != address(0), "ERC721: mint to the zero address");
888         require(!_exists(tokenId), "ERC721: token already minted");
889 
890         _beforeTokenTransfer(address(0), to, tokenId);
891 
892         _balances[to] += 1;
893         _owners[tokenId] = to;
894 
895         emit Transfer(address(0), to, tokenId);
896 
897         _afterTokenTransfer(address(0), to, tokenId);
898     }
899 
900     /**
901      * @dev Destroys `tokenId`.
902      * The approval is cleared when the token is burned.
903      *
904      * Requirements:
905      *
906      * - `tokenId` must exist.
907      *
908      * Emits a {Transfer} event.
909      */
910     function _burn(uint256 tokenId) internal virtual {
911         address owner = ERC721.ownerOf(tokenId);
912 
913         _beforeTokenTransfer(owner, address(0), tokenId);
914 
915         // Clear approvals
916         _approve(address(0), tokenId);
917 
918         _balances[owner] -= 1;
919         delete _owners[tokenId];
920 
921         emit Transfer(owner, address(0), tokenId);
922 
923         _afterTokenTransfer(owner, address(0), tokenId);
924     }
925 
926     /**
927      * @dev Transfers `tokenId` from `from` to `to`.
928      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
929      *
930      * Requirements:
931      *
932      * - `to` cannot be the zero address.
933      * - `tokenId` token must be owned by `from`.
934      *
935      * Emits a {Transfer} event.
936      */
937     function _transfer(
938         address from,
939         address to,
940         uint256 tokenId
941     ) internal virtual {
942         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
943         require(to != address(0), "ERC721: transfer to the zero address");
944 
945         _beforeTokenTransfer(from, to, tokenId);
946 
947         // Clear approvals from the previous owner
948         _approve(address(0), tokenId);
949 
950         _balances[from] -= 1;
951         _balances[to] += 1;
952         _owners[tokenId] = to;
953 
954         emit Transfer(from, to, tokenId);
955 
956         _afterTokenTransfer(from, to, tokenId);
957     }
958 
959     /**
960      * @dev Approve `to` to operate on `tokenId`
961      *
962      * Emits a {Approval} event.
963      */
964     function _approve(address to, uint256 tokenId) internal virtual {
965         _tokenApprovals[tokenId] = to;
966         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
967     }
968 
969     /**
970      * @dev Approve `operator` to operate on all of `owner` tokens
971      *
972      * Emits a {ApprovalForAll} event.
973      */
974     function _setApprovalForAll(
975         address owner,
976         address operator,
977         bool approved
978     ) internal virtual {
979         require(owner != operator, "ERC721: approve to caller");
980         _operatorApprovals[owner][operator] = approved;
981         emit ApprovalForAll(owner, operator, approved);
982     }
983 
984     /**
985      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
986      * The call is not executed if the target address is not a contract.
987      *
988      * @param from address representing the previous owner of the given token ID
989      * @param to target address that will receive the tokens
990      * @param tokenId uint256 ID of the token to be transferred
991      * @param _data bytes optional data to send along with the call
992      * @return bool whether the call correctly returned the expected magic value
993      */
994     function _checkOnERC721Received(
995         address from,
996         address to,
997         uint256 tokenId,
998         bytes memory _data
999     ) private returns (bool) {
1000         if (to.isContract()) {
1001             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1002                 return retval == IERC721Receiver.onERC721Received.selector;
1003             } catch (bytes memory reason) {
1004                 if (reason.length == 0) {
1005                     revert("ERC721: transfer to non ERC721Receiver implementer");
1006                 } else {
1007                     assembly {
1008                         revert(add(32, reason), mload(reason))
1009                     }
1010                 }
1011             }
1012         } else {
1013             return true;
1014         }
1015     }
1016 
1017     function _beforeTokenTransfer(
1018         address from,
1019         address to,
1020         uint256 tokenId
1021     ) internal virtual {}
1022 
1023     /**
1024      * @dev Hook that is called after any transfer of tokens. This includes
1025      * minting and burning.
1026      *
1027      * Calling conditions:
1028      *
1029      * - when `from` and `to` are both non-zero.
1030      * - `from` and `to` are never both zero.
1031      *
1032      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1033      */
1034     function _afterTokenTransfer(
1035         address from,
1036         address to,
1037         uint256 tokenId
1038     ) internal virtual {}
1039 }
1040 
1041 
1042 pragma solidity ^0.8.0;
1043 
1044 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1045     // Mapping from owner to list of owned token IDs
1046     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1047 
1048     // Mapping from token ID to index of the owner tokens list
1049     mapping(uint256 => uint256) private _ownedTokensIndex;
1050 
1051     // Array with all token ids, used for enumeration
1052     uint256[] private _allTokens;
1053 
1054     // Mapping from token id to position in the allTokens array
1055     mapping(uint256 => uint256) private _allTokensIndex;
1056 
1057     /**
1058      * @dev See {IERC165-supportsInterface}.
1059      */
1060     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1061         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1062     }
1063 
1064     /**
1065      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1066      */
1067     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1068         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1069         return _ownedTokens[owner][index];
1070     }
1071 
1072     /**
1073      * @dev See {IERC721Enumerable-totalSupply}.
1074      */
1075     function totalSupply() public view virtual override returns (uint256) {
1076         return _allTokens.length;
1077     }
1078 
1079     /**
1080      * @dev See {IERC721Enumerable-tokenByIndex}.
1081      */
1082     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1083         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1084         return _allTokens[index];
1085     }
1086 
1087     function _beforeTokenTransfer(
1088         address from,
1089         address to,
1090         uint256 tokenId
1091     ) internal virtual override {
1092         super._beforeTokenTransfer(from, to, tokenId);
1093 
1094         if (from == address(0)) {
1095             _addTokenToAllTokensEnumeration(tokenId);
1096         } else if (from != to) {
1097             _removeTokenFromOwnerEnumeration(from, tokenId);
1098         }
1099         if (to == address(0)) {
1100             _removeTokenFromAllTokensEnumeration(tokenId);
1101         } else if (to != from) {
1102             _addTokenToOwnerEnumeration(to, tokenId);
1103         }
1104     }
1105 
1106     /**
1107      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1108      * @param to address representing the new owner of the given token ID
1109      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1110      */
1111     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1112         uint256 length = ERC721.balanceOf(to);
1113         _ownedTokens[to][length] = tokenId;
1114         _ownedTokensIndex[tokenId] = length;
1115     }
1116 
1117     /**
1118      * @dev Private function to add a token to this extension's token tracking data structures.
1119      * @param tokenId uint256 ID of the token to be added to the tokens list
1120      */
1121     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1122         _allTokensIndex[tokenId] = _allTokens.length;
1123         _allTokens.push(tokenId);
1124     }
1125 
1126     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1127         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1128         // then delete the last slot (swap and pop).
1129 
1130         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1131         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1132 
1133         // When the token to delete is the last token, the swap operation is unnecessary
1134         if (tokenIndex != lastTokenIndex) {
1135             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1136 
1137             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1138             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1139         }
1140 
1141         // This also deletes the contents at the last position of the array
1142         delete _ownedTokensIndex[tokenId];
1143         delete _ownedTokens[from][lastTokenIndex];
1144     }
1145 
1146     /**
1147      * @dev Private function to remove a token from this extension's token tracking data structures.
1148      * This has O(1) time complexity, but alters the order of the _allTokens array.
1149      * @param tokenId uint256 ID of the token to be removed from the tokens list
1150      */
1151     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1152         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1153         // then delete the last slot (swap and pop).
1154 
1155         uint256 lastTokenIndex = _allTokens.length - 1;
1156         uint256 tokenIndex = _allTokensIndex[tokenId];
1157 
1158         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1159         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1160         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1161         uint256 lastTokenId = _allTokens[lastTokenIndex];
1162 
1163         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1164         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1165 
1166         // This also deletes the contents at the last position of the array
1167         delete _allTokensIndex[tokenId];
1168         _allTokens.pop();
1169     }
1170 }
1171 
1172 
1173 pragma solidity ^0.8.4;
1174 
1175 error ApprovalCallerNotOwnerNorApproved();
1176 error ApprovalQueryForNonexistentToken();
1177 error ApproveToCaller();
1178 error ApprovalToCurrentOwner();
1179 error BalanceQueryForZeroAddress();
1180 error MintToZeroAddress();
1181 error MintZeroQuantity();
1182 error OwnerQueryForNonexistentToken();
1183 error TransferCallerNotOwnerNorApproved();
1184 error TransferFromIncorrectOwner();
1185 error TransferToNonERC721ReceiverImplementer();
1186 error TransferToZeroAddress();
1187 error URIQueryForNonexistentToken();
1188 
1189 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
1190     using Address for address;
1191     using Strings for uint256;
1192 
1193     // Compiler will pack this into a single 256bit word.
1194     struct TokenOwnership {
1195         // The address of the owner.
1196         address addr;
1197         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
1198         uint64 startTimestamp;
1199         // Whether the token has been burned.
1200         bool burned;
1201     }
1202 
1203     // Compiler will pack this into a single 256bit word.
1204     struct AddressData {
1205         // Realistically, 2**64-1 is more than enough.
1206         uint64 balance;
1207         // Keeps track of mint count with minimal overhead for tokenomics.
1208         uint64 numberMinted;
1209         // Keeps track of burn count with minimal overhead for tokenomics.
1210         uint64 numberBurned;
1211         // For miscellaneous variable(s) pertaining to the address
1212         // (e.g. number of whitelist mint slots used).
1213         // If there are multiple variables, please pack them into a uint64.
1214         uint64 aux;
1215     }
1216 
1217     // The tokenId of the next token to be minted.
1218     uint256 internal _currentIndex;
1219 
1220     // The number of tokens burned.
1221     uint256 internal _burnCounter;
1222 
1223     // Token name
1224     string private _name;
1225 
1226     // Token symbol
1227     string private _symbol;
1228 
1229     // Mapping from token ID to ownership details
1230     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
1231     mapping(uint256 => TokenOwnership) internal _ownerships;
1232 
1233     // Mapping owner address to address data
1234     mapping(address => AddressData) private _addressData;
1235 
1236     // Mapping from token ID to approved address
1237     mapping(uint256 => address) private _tokenApprovals;
1238 
1239     // Mapping from owner to operator approvals
1240     mapping(address => mapping(address => bool)) private _operatorApprovals;
1241 
1242     constructor(string memory name_, string memory symbol_) {
1243         _name = name_;
1244         _symbol = symbol_;
1245         _currentIndex = _startTokenId();
1246     }
1247 
1248     /**
1249      * To change the starting tokenId, please override this function.
1250      */
1251     function _startTokenId() internal view virtual returns (uint256) {
1252         return 0;
1253     }
1254 
1255     /**
1256      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
1257      */
1258     function totalSupply() public view returns (uint256) {
1259         // Counter underflow is impossible as _burnCounter cannot be incremented
1260         // more than _currentIndex - _startTokenId() times
1261         unchecked {
1262             return _currentIndex - _burnCounter - _startTokenId();
1263         }
1264     }
1265 
1266     /**
1267      * Returns the total amount of tokens minted in the contract.
1268      */
1269     function _totalMinted() internal view returns (uint256) {
1270         // Counter underflow is impossible as _currentIndex does not decrement,
1271         // and it is initialized to _startTokenId()
1272         unchecked {
1273             return _currentIndex - _startTokenId();
1274         }
1275     }
1276 
1277     /**
1278      * @dev See {IERC165-supportsInterface}.
1279      */
1280     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1281         return
1282             interfaceId == type(IERC721).interfaceId ||
1283             interfaceId == type(IERC721Metadata).interfaceId ||
1284             super.supportsInterface(interfaceId);
1285     }
1286 
1287     /**
1288      * @dev See {IERC721-balanceOf}.
1289      */
1290     function balanceOf(address owner) public view override returns (uint256) {
1291         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1292         return uint256(_addressData[owner].balance);
1293     }
1294 
1295     /**
1296      * Returns the number of tokens minted by `owner`.
1297      */
1298     function _numberMinted(address owner) internal view returns (uint256) {
1299         return uint256(_addressData[owner].numberMinted);
1300     }
1301 
1302     /**
1303      * Returns the number of tokens burned by or on behalf of `owner`.
1304      */
1305     function _numberBurned(address owner) internal view returns (uint256) {
1306         return uint256(_addressData[owner].numberBurned);
1307     }
1308 
1309     /**
1310      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1311      */
1312     function _getAux(address owner) internal view returns (uint64) {
1313         return _addressData[owner].aux;
1314     }
1315 
1316     /**
1317      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1318      * If there are multiple variables, please pack them into a uint64.
1319      */
1320     function _setAux(address owner, uint64 aux) internal {
1321         _addressData[owner].aux = aux;
1322     }
1323 
1324     /**
1325      * Gas spent here starts off proportional to the maximum mint batch size.
1326      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1327      */
1328     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1329         uint256 curr = tokenId;
1330 
1331         unchecked {
1332             if (_startTokenId() <= curr && curr < _currentIndex) {
1333                 TokenOwnership memory ownership = _ownerships[curr];
1334                 if (!ownership.burned) {
1335                     if (ownership.addr != address(0)) {
1336                         return ownership;
1337                     }
1338                     // Invariant:
1339                     // There will always be an ownership that has an address and is not burned
1340                     // before an ownership that does not have an address and is not burned.
1341                     // Hence, curr will not underflow.
1342                     while (true) {
1343                         curr--;
1344                         ownership = _ownerships[curr];
1345                         if (ownership.addr != address(0)) {
1346                             return ownership;
1347                         }
1348                     }
1349                 }
1350             }
1351         }
1352         revert OwnerQueryForNonexistentToken();
1353     }
1354 
1355     /**
1356      * @dev See {IERC721-ownerOf}.
1357      */
1358     function ownerOf(uint256 tokenId) public view override returns (address) {
1359         return _ownershipOf(tokenId).addr;
1360     }
1361 
1362     /**
1363      * @dev See {IERC721Metadata-name}.
1364      */
1365     function name() public view virtual override returns (string memory) {
1366         return _name;
1367     }
1368 
1369     /**
1370      * @dev See {IERC721Metadata-symbol}.
1371      */
1372     function symbol() public view virtual override returns (string memory) {
1373         return _symbol;
1374     }
1375 
1376     /**
1377      * @dev See {IERC721Metadata-tokenURI}.
1378      */
1379     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1380         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1381 
1382         string memory baseURI = _baseURI();
1383         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1384     }
1385 
1386     /**
1387      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1388      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1389      * by default, can be overriden in child contracts.
1390      */
1391     function _baseURI() internal view virtual returns (string memory) {
1392         return '';
1393     }
1394 
1395     /**
1396      * @dev See {IERC721-approve}.
1397      */
1398     function approve(address to, uint256 tokenId) public override {
1399         address owner = ERC721A.ownerOf(tokenId);
1400         if (to == owner) revert ApprovalToCurrentOwner();
1401 
1402         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1403             revert ApprovalCallerNotOwnerNorApproved();
1404         }
1405 
1406         _approve(to, tokenId, owner);
1407     }
1408 
1409     /**
1410      * @dev See {IERC721-getApproved}.
1411      */
1412     function getApproved(uint256 tokenId) public view override returns (address) {
1413         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1414 
1415         return _tokenApprovals[tokenId];
1416     }
1417 
1418     /**
1419      * @dev See {IERC721-setApprovalForAll}.
1420      */
1421     function setApprovalForAll(address operator, bool approved) public virtual override {
1422         if (operator == _msgSender()) revert ApproveToCaller();
1423 
1424         _operatorApprovals[_msgSender()][operator] = approved;
1425         emit ApprovalForAll(_msgSender(), operator, approved);
1426     }
1427 
1428     /**
1429      * @dev See {IERC721-isApprovedForAll}.
1430      */
1431     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1432         return _operatorApprovals[owner][operator];
1433     }
1434 
1435     /**
1436      * @dev See {IERC721-transferFrom}.
1437      */
1438     function transferFrom(
1439         address from,
1440         address to,
1441         uint256 tokenId
1442     ) public virtual override {
1443         _transfer(from, to, tokenId);
1444     }
1445 
1446     /**
1447      * @dev See {IERC721-safeTransferFrom}.
1448      */
1449     function safeTransferFrom(
1450         address from,
1451         address to,
1452         uint256 tokenId
1453     ) public virtual override {
1454         safeTransferFrom(from, to, tokenId, '');
1455     }
1456 
1457     /**
1458      * @dev See {IERC721-safeTransferFrom}.
1459      */
1460     function safeTransferFrom(
1461         address from,
1462         address to,
1463         uint256 tokenId,
1464         bytes memory _data
1465     ) public virtual override {
1466         _transfer(from, to, tokenId);
1467         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1468             revert TransferToNonERC721ReceiverImplementer();
1469         }
1470     }
1471 
1472     /**
1473      * @dev Returns whether `tokenId` exists.
1474      *
1475      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1476      *
1477      * Tokens start existing when they are minted (`_mint`),
1478      */
1479     function _exists(uint256 tokenId) internal view returns (bool) {
1480         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1481     }
1482 
1483     function _safeMint(address to, uint256 quantity) internal {
1484         _safeMint(to, quantity, '');
1485     }
1486 
1487     /**
1488      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1489      *
1490      * Requirements:
1491      *
1492      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1493      * - `quantity` must be greater than 0.
1494      *
1495      * Emits a {Transfer} event.
1496      */
1497     function _safeMint(
1498         address to,
1499         uint256 quantity,
1500         bytes memory _data
1501     ) internal {
1502         _mint(to, quantity, _data, true);
1503     }
1504 
1505     /**
1506      * @dev Mints `quantity` tokens and transfers them to `to`.
1507      *
1508      * Requirements:
1509      *
1510      * - `to` cannot be the zero address.
1511      * - `quantity` must be greater than 0.
1512      *
1513      * Emits a {Transfer} event.
1514      */
1515     function _mint(
1516         address to,
1517         uint256 quantity,
1518         bytes memory _data,
1519         bool safe
1520     ) internal {
1521         uint256 startTokenId = _currentIndex;
1522         if (to == address(0)) revert MintToZeroAddress();
1523         if (quantity == 0) revert MintZeroQuantity();
1524 
1525         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1526 
1527         // Overflows are incredibly unrealistic.
1528         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1529         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1530         unchecked {
1531             _addressData[to].balance += uint64(quantity);
1532             _addressData[to].numberMinted += uint64(quantity);
1533 
1534             _ownerships[startTokenId].addr = to;
1535             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1536 
1537             uint256 updatedIndex = startTokenId;
1538             uint256 end = updatedIndex + quantity;
1539 
1540             if (safe && to.isContract()) {
1541                 do {
1542                     emit Transfer(address(0), to, updatedIndex);
1543                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1544                         revert TransferToNonERC721ReceiverImplementer();
1545                     }
1546                 } while (updatedIndex != end);
1547                 // Reentrancy protection
1548                 if (_currentIndex != startTokenId) revert();
1549             } else {
1550                 do {
1551                     emit Transfer(address(0), to, updatedIndex++);
1552                 } while (updatedIndex != end);
1553             }
1554             _currentIndex = updatedIndex;
1555         }
1556         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1557     }
1558 
1559     function _transfer(
1560         address from,
1561         address to,
1562         uint256 tokenId
1563     ) private {
1564         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1565 
1566         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1567 
1568         bool isApprovedOrOwner = (_msgSender() == from ||
1569             isApprovedForAll(from, _msgSender()) ||
1570             getApproved(tokenId) == _msgSender());
1571 
1572         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1573         if (to == address(0)) revert TransferToZeroAddress();
1574 
1575         _beforeTokenTransfers(from, to, tokenId, 1);
1576 
1577         // Clear approvals from the previous owner
1578         _approve(address(0), tokenId, from);
1579 
1580         // Underflow of the sender's balance is impossible because we check for
1581         // ownership above and the recipient's balance can't realistically overflow.
1582         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1583         unchecked {
1584             _addressData[from].balance -= 1;
1585             _addressData[to].balance += 1;
1586 
1587             TokenOwnership storage currSlot = _ownerships[tokenId];
1588             currSlot.addr = to;
1589             currSlot.startTimestamp = uint64(block.timestamp);
1590 
1591             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1592             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1593             uint256 nextTokenId = tokenId + 1;
1594             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1595             if (nextSlot.addr == address(0)) {
1596                 // This will suffice for checking _exists(nextTokenId),
1597                 // as a burned slot cannot contain the zero address.
1598                 if (nextTokenId != _currentIndex) {
1599                     nextSlot.addr = from;
1600                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1601                 }
1602             }
1603         }
1604 
1605         emit Transfer(from, to, tokenId);
1606         _afterTokenTransfers(from, to, tokenId, 1);
1607     }
1608 
1609     /**
1610      * @dev This is equivalent to _burn(tokenId, false)
1611      */
1612     function _burn(uint256 tokenId) internal virtual {
1613         _burn(tokenId, false);
1614     }
1615 
1616     /**
1617      * @dev Destroys `tokenId`.
1618      * The approval is cleared when the token is burned.
1619      *
1620      * Requirements:
1621      *
1622      * - `tokenId` must exist.
1623      *
1624      * Emits a {Transfer} event.
1625      */
1626     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1627         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1628 
1629         address from = prevOwnership.addr;
1630 
1631         if (approvalCheck) {
1632             bool isApprovedOrOwner = (_msgSender() == from ||
1633                 isApprovedForAll(from, _msgSender()) ||
1634                 getApproved(tokenId) == _msgSender());
1635 
1636             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1637         }
1638 
1639         _beforeTokenTransfers(from, address(0), tokenId, 1);
1640 
1641         // Clear approvals from the previous owner
1642         _approve(address(0), tokenId, from);
1643 
1644         // Underflow of the sender's balance is impossible because we check for
1645         // ownership above and the recipient's balance can't realistically overflow.
1646         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1647         unchecked {
1648             AddressData storage addressData = _addressData[from];
1649             addressData.balance -= 1;
1650             addressData.numberBurned += 1;
1651 
1652             // Keep track of who burned the token, and the timestamp of burning.
1653             TokenOwnership storage currSlot = _ownerships[tokenId];
1654             currSlot.addr = from;
1655             currSlot.startTimestamp = uint64(block.timestamp);
1656             currSlot.burned = true;
1657 
1658             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1659             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1660             uint256 nextTokenId = tokenId + 1;
1661             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1662             if (nextSlot.addr == address(0)) {
1663                 // This will suffice for checking _exists(nextTokenId),
1664                 // as a burned slot cannot contain the zero address.
1665                 if (nextTokenId != _currentIndex) {
1666                     nextSlot.addr = from;
1667                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1668                 }
1669             }
1670         }
1671 
1672         emit Transfer(from, address(0), tokenId);
1673         _afterTokenTransfers(from, address(0), tokenId, 1);
1674 
1675         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1676         unchecked {
1677             _burnCounter++;
1678         }
1679     }
1680 
1681     /**
1682      * @dev Approve `to` to operate on `tokenId`
1683      *
1684      * Emits a {Approval} event.
1685      */
1686     function _approve(
1687         address to,
1688         uint256 tokenId,
1689         address owner
1690     ) private {
1691         _tokenApprovals[tokenId] = to;
1692         emit Approval(owner, to, tokenId);
1693     }
1694 
1695     /**
1696      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1697      *
1698      * @param from address representing the previous owner of the given token ID
1699      * @param to target address that will receive the tokens
1700      * @param tokenId uint256 ID of the token to be transferred
1701      * @param _data bytes optional data to send along with the call
1702      * @return bool whether the call correctly returned the expected magic value
1703      */
1704     function _checkContractOnERC721Received(
1705         address from,
1706         address to,
1707         uint256 tokenId,
1708         bytes memory _data
1709     ) private returns (bool) {
1710         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1711             return retval == IERC721Receiver(to).onERC721Received.selector;
1712         } catch (bytes memory reason) {
1713             if (reason.length == 0) {
1714                 revert TransferToNonERC721ReceiverImplementer();
1715             } else {
1716                 assembly {
1717                     revert(add(32, reason), mload(reason))
1718                 }
1719             }
1720         }
1721     }
1722 
1723     function _beforeTokenTransfers(
1724         address from,
1725         address to,
1726         uint256 startTokenId,
1727         uint256 quantity
1728     ) internal virtual {}
1729 
1730     function _afterTokenTransfers(
1731         address from,
1732         address to,
1733         uint256 startTokenId,
1734         uint256 quantity
1735     ) internal virtual {}
1736 }
1737 pragma solidity ^0.8.4;
1738 contract Nudes is ERC721A, Ownable {
1739     using Strings for uint256;
1740     string private baseURI;
1741     string public hiddenMetadataUri;
1742     uint256 public price = 0.005 ether;
1743     uint256 public maxPerTx = 10;
1744     uint256 public maxFreePerWallet = 2;
1745     uint256 public totalFree = 10000;
1746     uint256 public maxSupply = 10000;
1747     uint public nextId = 0;
1748     bool public mintEnabled = false;
1749     bool public revealed = true;
1750     mapping(address => uint256) private _mintedFreeAmount;
1751 
1752     constructor() ERC721A("Nudes", "NU") {
1753         setHiddenMetadataUri("https://api.nudes.beauty/");
1754         setBaseURI("https://api.nudes.beauty/");
1755     }
1756 
1757     function mint(uint256 count) external payable {
1758       uint256 cost = price;
1759       bool isFree =
1760       ((totalSupply() + count < totalFree + 1) &&
1761       (_mintedFreeAmount[msg.sender] + count <= maxFreePerWallet));
1762 
1763       if (isFree) {
1764       cost = 0;
1765      }
1766 
1767      else {
1768       require(msg.value >= count * price, "Please send the exact amount.");
1769       require(totalSupply() + count <= maxSupply, "No more nudes");
1770       require(mintEnabled, "Minting is not live yet");
1771       require(count <= maxPerTx, "Max per TX reached.");
1772      }
1773 
1774       if (isFree) {
1775          _mintedFreeAmount[msg.sender] += count;
1776       }
1777 
1778      _safeMint(msg.sender, count);
1779      nextId += count;
1780     }
1781 
1782     function _baseURI() internal view virtual override returns (string memory) {
1783         return baseURI;
1784     }
1785 
1786     function tokenURI(uint256 tokenId)
1787         public
1788         view
1789         virtual
1790         override
1791         returns (string memory)
1792     {
1793         require(
1794             _exists(tokenId),
1795             "ERC721Metadata: URI query for nonexistent token"
1796         );
1797 
1798         if (revealed == false) {
1799          return string(abi.encodePacked(hiddenMetadataUri));
1800         }
1801     
1802         return string(abi.encodePacked(baseURI, tokenId.toString(), ".json"));
1803     }
1804 
1805     function setBaseURI(string memory uri) public onlyOwner {
1806         baseURI = uri;
1807     }
1808 
1809     function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1810      hiddenMetadataUri = _hiddenMetadataUri;
1811     }
1812 
1813     function setFreeAmount(uint256 amount) external onlyOwner {
1814         totalFree = amount;
1815     }
1816 
1817     function setPrice(uint256 _newPrice) external onlyOwner {
1818         price = _newPrice;
1819     }
1820 
1821     function setRevealed() external onlyOwner {
1822      revealed = !revealed;
1823     }
1824 
1825     function flipSale() external onlyOwner {
1826         mintEnabled = !mintEnabled;
1827     }
1828 
1829     function getNextId() public view returns(uint){
1830      return nextId;
1831     }
1832 
1833     function _startTokenId() internal pure override returns (uint256) {
1834         return 1;
1835     }
1836 
1837     function withdraw() external onlyOwner {
1838         (bool success, ) = payable(msg.sender).call{
1839             value: address(this).balance
1840         }("");
1841         require(success, "Transfer failed.");
1842     }
1843 
1844     function FreeMintWL(address to, uint256 quantity)public onlyOwner{
1845     require(totalSupply() + quantity <= maxSupply, "reached max supply");
1846     _safeMint(to, quantity);
1847   }
1848 }