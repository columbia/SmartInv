1 /**
2 ╭━╮╱╱╱╱╱╱╱╱╭╮╱╭━━━╮╱╭━━┳━━━┳━━━╮
3 ┃╋┣┳┳━┳┳━┳━┫╰╮┃╭━╮┣┳╋╮╮┃╭━╮┃╭━╮┃
4 ┃╭┫╭┫╋┣┫┻┫━┫╭┫┃┃┃┃┣┃╋┻╯┣╯╭╯┃╰━╯┃
5 ╰╯╰╯╰┳╯┣━┻━┻━╯┃┃┃┃┣┻┻━━╋╮╰╮┃╭━╮┃
6 ╱╱╱╱╱╰━╯╱╱╱╱╱╱┃╰━╯┃╱╱╱╱┃╰━╯┃╰━╯┃
7 */
8 
9 // SPDX-License-Identifier: MIT
10 
11 pragma solidity ^0.8.0;
12 
13 library Counters {
14     struct Counter {
15 
16         uint256 _value; // default: 0
17     }
18 
19     function current(Counter storage counter) internal view returns (uint256) {
20         return counter._value;
21     }
22 
23     function increment(Counter storage counter) internal {
24         unchecked {
25             counter._value += 1;
26         }
27     }
28 
29     function decrement(Counter storage counter) internal {
30         uint256 value = counter._value;
31         require(value > 0, "Counter:decrement overflow");
32         unchecked {
33             counter._value = value - 1;
34         }
35     }
36 
37     function reset(Counter storage counter) internal {
38         counter._value = 0;
39     }
40 }
41 
42 
43 pragma solidity ^0.8.0;
44 
45 /**
46  * @dev String operations.
47  */
48 library Strings {
49     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
50 
51     /**
52      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
53      */
54     function toString(uint256 value) internal pure returns (string memory) {
55         // Inspired by OraclizeAPI's implementation - MIT licence
56         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
57 
58         if (value == 0) {
59             return "0";
60         }
61         uint256 temp = value;
62         uint256 digits;
63         while (temp != 0) {
64             digits++;
65             temp /= 10;
66         }
67         bytes memory buffer = new bytes(digits);
68         while (value != 0) {
69             digits -= 1;
70             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
71             value /= 10;
72         }
73         return string(buffer);
74     }
75 
76     /**
77      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
78      */
79     function toHexString(uint256 value) internal pure returns (string memory) {
80         if (value == 0) {
81             return "0x00";
82         }
83         uint256 temp = value;
84         uint256 length = 0;
85         while (temp != 0) {
86             length++;
87             temp >>= 8;
88         }
89         return toHexString(value, length);
90     }
91 
92     /**
93      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
94      */
95     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
96         bytes memory buffer = new bytes(2 * length + 2);
97         buffer[0] = "0";
98         buffer[1] = "x";
99         for (uint256 i = 2 * length + 1; i > 1; --i) {
100             buffer[i] = _HEX_SYMBOLS[value & 0xf];
101             value >>= 4;
102         }
103         require(value == 0, "Strings: hex length insufficient");
104         return string(buffer);
105     }
106 }
107 
108 pragma solidity ^0.8.0;
109 
110 /**
111  * @dev Provides information about the current execution context, including the
112  * sender of the transaction and its data. While these are generally available
113  * via msg.sender and msg.data, they should not be accessed in such a direct
114  * manner, since when dealing with meta-transactions the account sending and
115  * paying for execution may not be the actual sender (as far as an application
116  * is concerned).
117  *
118  * This contract is only required for intermediate, library-like contracts.
119  */
120 abstract contract Context {
121     function _msgSender() internal view virtual returns (address) {
122         return msg.sender;
123     }
124 
125     function _msgData() internal view virtual returns (bytes calldata) {
126         return msg.data;
127     }
128 }
129 
130 
131 pragma solidity ^0.8.0;
132 
133 abstract contract Ownable is Context {
134     address private _owner;
135 
136     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
137 
138     /**
139      * @dev Initializes the contract setting the deployer as the initial owner.
140      */
141     constructor() {
142         _transferOwnership(_msgSender());
143     }
144 
145     /**
146      * @dev Returns the address of the current owner.
147      */
148     function owner() public view virtual returns (address) {
149         return _owner;
150     }
151 
152     /**
153      * @dev Throws if called by any account other than the owner.
154      */
155     modifier onlyOwner() {
156         require(owner() == _msgSender(), "Ownable: caller is not the owner");
157         _;
158     }
159 
160     /**
161      * @dev Leaves the contract without owner. It will not be possible to call
162      * `onlyOwner` functions anymore. Can only be called by the current owner.
163      *
164      * NOTE: Renouncing ownership will leave the contract without an owner,
165      * thereby removing any functionality that is only available to the owner.
166      */
167     function renounceOwnership() public virtual onlyOwner {
168         _transferOwnership(address(0));
169     }
170 
171     /**
172      * @dev Transfers ownership of the contract to a new account (`newOwner`).
173      * Can only be called by the current owner.
174      */
175     function transferOwnership(address newOwner) public virtual onlyOwner {
176         require(newOwner != address(0), "Ownable: new owner is the zero address");
177         _transferOwnership(newOwner);
178     }
179 
180     /**
181      * @dev Transfers ownership of the contract to a new account (`newOwner`).
182      * Internal function without access restriction.
183      */
184     function _transferOwnership(address newOwner) internal virtual {
185         address oldOwner = _owner;
186         _owner = newOwner;
187         emit OwnershipTransferred(oldOwner, newOwner);
188     }
189 }
190 
191 pragma solidity ^0.8.1;
192 
193 /**
194  * @dev Collection of functions related to the address type
195  */
196 library Address {
197     /**
198      * @dev Returns true if `account` is a contract.
199      *
200      * [IMPORTANT]
201      * ====
202      * It is unsafe to assume that an address for which this function returns
203      * false is an externally-owned account (EOA) and not a contract.
204      *
205      * Among others, `isContract` will return false for the following
206      * types of addresses:
207      *
208      *  - an externally-owned account
209      *  - a contract in construction
210      *  - an address where a contract will be created
211      *  - an address where a contract lived, but was destroyed
212      * ====
213      *
214      * [IMPORTANT]
215      * ====
216      * You shouldn't rely on `isContract` to protect against flash loan attacks!
217      *
218      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
219      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
220      * constructor.
221      * ====
222      */
223     function isContract(address account) internal view returns (bool) {
224         // This method relies on extcodesize/address.code.length, which returns 0
225         // for contracts in construction, since the code is only stored at the end
226         // of the constructor execution.
227 
228         return account.code.length > 0;
229     }
230 
231     /**
232      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
233      * `recipient`, forwarding all available gas and reverting on errors.
234      *
235      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
236      * of certain opcodes, possibly making contracts go over the 2300 gas limit
237      * imposed by `transfer`, making them unable to receive funds via
238      * `transfer`. {sendValue} removes this limitation.
239      *
240      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
241      *
242      * IMPORTANT: because control is transferred to `recipient`, care must be
243      * taken to not create reentrancy vulnerabilities. Consider using
244      * {ReentrancyGuard} or the
245      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
246      */
247     function sendValue(address payable recipient, uint256 amount) internal {
248         require(address(this).balance >= amount, "Address: insufficient balance");
249 
250         (bool success, ) = recipient.call{value: amount}("");
251         require(success, "Address: unable to send value, recipient may have reverted");
252     }
253 
254     /**
255      * @dev Performs a Solidity function call using a low level `call`. A
256      * plain `call` is an unsafe replacement for a function call: use this
257      * function instead.
258      *
259      * If `target` reverts with a revert reason, it is bubbled up by this
260      * function (like regular Solidity function calls).
261      *
262      * Returns the raw returned data. To convert to the expected return value,
263      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
264      *
265      * Requirements:
266      *
267      * - `target` must be a contract.
268      * - calling `target` with `data` must not revert.
269      *
270      * _Available since v3.1._
271      */
272     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
273         return functionCall(target, data, "Address: low-level call failed");
274     }
275 
276     /**
277      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
278      * `errorMessage` as a fallback revert reason when `target` reverts.
279      *
280      * _Available since v3.1._
281      */
282     function functionCall(
283         address target,
284         bytes memory data,
285         string memory errorMessage
286     ) internal returns (bytes memory) {
287         return functionCallWithValue(target, data, 0, errorMessage);
288     }
289 
290     /**
291      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
292      * but also transferring `value` wei to `target`.
293      *
294      * Requirements:
295      *
296      * - the calling contract must have an ETH balance of at least `value`.
297      * - the called Solidity function must be `payable`.
298      *
299      * _Available since v3.1._
300      */
301     function functionCallWithValue(
302         address target,
303         bytes memory data,
304         uint256 value
305     ) internal returns (bytes memory) {
306         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
307     }
308 
309     /**
310      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
311      * with `errorMessage` as a fallback revert reason when `target` reverts.
312      *
313      * _Available since v3.1._
314      */
315     function functionCallWithValue(
316         address target,
317         bytes memory data,
318         uint256 value,
319         string memory errorMessage
320     ) internal returns (bytes memory) {
321         require(address(this).balance >= value, "Address: insufficient balance for call");
322         require(isContract(target), "Address: call to non-contract");
323 
324         (bool success, bytes memory returndata) = target.call{value: value}(data);
325         return verifyCallResult(success, returndata, errorMessage);
326     }
327 
328     /**
329      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
330      * but performing a static call.
331      *
332      * _Available since v3.3._
333      */
334     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
335         return functionStaticCall(target, data, "Address: low-level static call failed");
336     }
337 
338     /**
339      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
340      * but performing a static call.
341      *
342      * _Available since v3.3._
343      */
344     function functionStaticCall(
345         address target,
346         bytes memory data,
347         string memory errorMessage
348     ) internal view returns (bytes memory) {
349         require(isContract(target), "Address: static call to non-contract");
350 
351         (bool success, bytes memory returndata) = target.staticcall(data);
352         return verifyCallResult(success, returndata, errorMessage);
353     }
354 
355     /**
356      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
357      * but performing a delegate call.
358      *
359      * _Available since v3.4._
360      */
361     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
362         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
363     }
364 
365     /**
366      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
367      * but performing a delegate call.
368      *
369      * _Available since v3.4._
370      */
371     function functionDelegateCall(
372         address target,
373         bytes memory data,
374         string memory errorMessage
375     ) internal returns (bytes memory) {
376         require(isContract(target), "Address: delegate call to non-contract");
377 
378         (bool success, bytes memory returndata) = target.delegatecall(data);
379         return verifyCallResult(success, returndata, errorMessage);
380     }
381 
382     /**
383      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
384      * revert reason using the provided one.
385      *
386      * _Available since v4.3._
387      */
388     function verifyCallResult(
389         bool success,
390         bytes memory returndata,
391         string memory errorMessage
392     ) internal pure returns (bytes memory) {
393         if (success) {
394             return returndata;
395         } else {
396             // Look for revert reason and bubble it up if present
397             if (returndata.length > 0) {
398                 // The easiest way to bubble the revert reason is using memory via assembly
399 
400                 assembly {
401                     let returndata_size := mload(returndata)
402                     revert(add(32, returndata), returndata_size)
403                 }
404             } else {
405                 revert(errorMessage);
406             }
407         }
408     }
409 }
410 
411 pragma solidity ^0.8.0;
412 
413 /**
414  * @title ERC721 token receiver interface
415  * @dev Interface for any contract that wants to support safeTransfers
416  * from ERC721 asset contracts.
417  */
418 interface IERC721Receiver {
419     /**
420      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
421      * by `operator` from `from`, this function is called.
422      *
423      * It must return its Solidity selector to confirm the token transfer.
424      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
425      *
426      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
427      */
428     function onERC721Received(
429         address operator,
430         address from,
431         uint256 tokenId,
432         bytes calldata data
433     ) external returns (bytes4);
434 }
435 
436 pragma solidity ^0.8.0;
437 
438 /**
439  * @dev Interface of the ERC165 standard, as defined in the
440  * https://eips.ethereum.org/EIPS/eip-165[EIP].
441  *
442  * Implementers can declare support of contract interfaces, which can then be
443  * queried by others ({ERC165Checker}).
444  *
445  * For an implementation, see {ERC165}.
446  */
447 interface IERC165 {
448     /**
449      * @dev Returns true if this contract implements the interface defined by
450      * `interfaceId`. See the corresponding
451      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
452      * to learn more about how these ids are created.
453      *
454      * This function call must use less than 30 000 gas.
455      */
456     function supportsInterface(bytes4 interfaceId) external view returns (bool);
457 }
458 
459 pragma solidity ^0.8.0;
460 
461 abstract contract ERC165 is IERC165 {
462     /**
463      * @dev See {IERC165-supportsInterface}.
464      */
465     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
466         return interfaceId == type(IERC165).interfaceId;
467     }
468 }
469 
470 pragma solidity ^0.8.0;
471 
472 interface IERC721 is IERC165 {
473     /**
474      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
475      */
476     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
477 
478     /**
479      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
480      */
481     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
482 
483     /**
484      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
485      */
486     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
487 
488     /**
489      * @dev Returns the number of tokens in ``owner``'s account.
490      */
491     function balanceOf(address owner) external view returns (uint256 balance);
492 
493     /**
494      * @dev Returns the owner of the `tokenId` token.
495      *
496      * Requirements:
497      *
498      * - `tokenId` must exist.
499      */
500     function ownerOf(uint256 tokenId) external view returns (address owner);
501 
502     function safeTransferFrom(
503         address from,
504         address to,
505         uint256 tokenId
506     ) external;
507 
508     function transferFrom(
509         address from,
510         address to,
511         uint256 tokenId
512     ) external;
513 
514     function approve(address to, uint256 tokenId) external;
515 
516     /**
517      * @dev Returns the account approved for `tokenId` token.
518      *
519      * Requirements:
520      *
521      * - `tokenId` must exist.
522      */
523     function getApproved(uint256 tokenId) external view returns (address operator);
524 
525     /**
526      * @dev Approve or remove `operator` as an operator for the caller.
527      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
528      *
529      * Requirements:
530      *
531      * - The `operator` cannot be the caller.
532      *
533      * Emits an {ApprovalForAll} event.
534      */
535     function setApprovalForAll(address operator, bool _approved) external;
536 
537     /**
538      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
539      *
540      * See {setApprovalForAll}
541      */
542     function isApprovedForAll(address owner, address operator) external view returns (bool);
543 
544     /**
545      * @dev Safely transfers `tokenId` token from `from` to `to`.
546      *
547      * Requirements:
548      *
549      * - `from` cannot be the zero address.
550      * - `to` cannot be the zero address.
551      * - `tokenId` token must exist and be owned by `from`.
552      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
553      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
554      *
555      * Emits a {Transfer} event.
556      */
557     function safeTransferFrom(
558         address from,
559         address to,
560         uint256 tokenId,
561         bytes calldata data
562     ) external;
563 }
564 
565 
566 pragma solidity ^0.8.0;
567 
568 
569 /**
570  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
571  * @dev See https://eips.ethereum.org/EIPS/eip-721
572  */
573 interface IERC721Enumerable is IERC721 {
574     /**
575      * @dev Returns the total amount of tokens stored by the contract.
576      */
577     function totalSupply() external view returns (uint256);
578 
579     /**
580      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
581      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
582      */
583     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
584 
585     /**
586      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
587      * Use along with {totalSupply} to enumerate all tokens.
588      */
589     function tokenByIndex(uint256 index) external view returns (uint256);
590 }
591 
592 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
593 
594 
595 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
596 
597 pragma solidity ^0.8.0;
598 
599 
600 /**
601  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
602  * @dev See https://eips.ethereum.org/EIPS/eip-721
603  */
604 interface IERC721Metadata is IERC721 {
605     /**
606      * @dev Returns the token collection name.
607      */
608     function name() external view returns (string memory);
609 
610     /**
611      * @dev Returns the token collection symbol.
612      */
613     function symbol() external view returns (string memory);
614 
615     /**
616      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
617      */
618     function tokenURI(uint256 tokenId) external view returns (string memory);
619 }
620 
621 
622 pragma solidity ^0.8.0;
623 
624 /**
625  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
626  * the Metadata extension, but not including the Enumerable extension, which is available separately as
627  * {ERC721Enumerable}.
628  */
629 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
630     using Address for address;
631     using Strings for uint256;
632 
633     // Token name
634     string private _name;
635 
636     // Token symbol
637     string private _symbol;
638 
639     // Mapping from token ID to owner address
640     mapping(uint256 => address) private _owners;
641 
642     // Mapping owner address to token count
643     mapping(address => uint256) private _balances;
644 
645     // Mapping from token ID to approved address
646     mapping(uint256 => address) private _tokenApprovals;
647 
648     // Mapping from owner to operator approvals
649     mapping(address => mapping(address => bool)) private _operatorApprovals;
650 
651     /**
652      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
653      */
654     constructor(string memory name_, string memory symbol_) {
655         _name = name_;
656         _symbol = symbol_;
657     }
658 
659     /**
660      * @dev See {IERC165-supportsInterface}.
661      */
662     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
663         return
664             interfaceId == type(IERC721).interfaceId ||
665             interfaceId == type(IERC721Metadata).interfaceId ||
666             super.supportsInterface(interfaceId);
667     }
668 
669     /**
670      * @dev See {IERC721-balanceOf}.
671      */
672     function balanceOf(address owner) public view virtual override returns (uint256) {
673         require(owner != address(0), "ERC721: balance query for the zero address");
674         return _balances[owner];
675     }
676 
677     /**
678      * @dev See {IERC721-ownerOf}.
679      */
680     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
681         address owner = _owners[tokenId];
682         require(owner != address(0), "ERC721: owner query for nonexistent token");
683         return owner;
684     }
685 
686     /**
687      * @dev See {IERC721Metadata-name}.
688      */
689     function name() public view virtual override returns (string memory) {
690         return _name;
691     }
692 
693     /**
694      * @dev See {IERC721Metadata-symbol}.
695      */
696     function symbol() public view virtual override returns (string memory) {
697         return _symbol;
698     }
699 
700     /**
701      * @dev See {IERC721Metadata-tokenURI}.
702      */
703     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
704         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
705 
706         string memory baseURI = _baseURI();
707         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
708     }
709 
710     /**
711      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
712      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
713      * by default, can be overriden in child contracts.
714      */
715     function _baseURI() internal view virtual returns (string memory) {
716         return "";
717     }
718 
719     /**
720      * @dev See {IERC721-approve}.
721      */
722     function approve(address to, uint256 tokenId) public virtual override {
723         address owner = ERC721.ownerOf(tokenId);
724         require(to != owner, "ERC721: approval to current owner");
725 
726         require(
727             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
728             "ERC721: approve caller is not owner nor approved for all"
729         );
730 
731         _approve(to, tokenId);
732     }
733 
734     /**
735      * @dev See {IERC721-getApproved}.
736      */
737     function getApproved(uint256 tokenId) public view virtual override returns (address) {
738         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
739 
740         return _tokenApprovals[tokenId];
741     }
742 
743     /**
744      * @dev See {IERC721-setApprovalForAll}.
745      */
746     function setApprovalForAll(address operator, bool approved) public virtual override {
747         _setApprovalForAll(_msgSender(), operator, approved);
748     }
749 
750     /**
751      * @dev See {IERC721-isApprovedForAll}.
752      */
753     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
754         return _operatorApprovals[owner][operator];
755     }
756 
757     /**
758      * @dev See {IERC721-transferFrom}.
759      */
760     function transferFrom(
761         address from,
762         address to,
763         uint256 tokenId
764     ) public virtual override {
765         //solhint-disable-next-line max-line-length
766         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
767 
768         _transfer(from, to, tokenId);
769     }
770 
771     /**
772      * @dev See {IERC721-safeTransferFrom}.
773      */
774     function safeTransferFrom(
775         address from,
776         address to,
777         uint256 tokenId
778     ) public virtual override {
779         safeTransferFrom(from, to, tokenId, "");
780     }
781 
782     /**
783      * @dev See {IERC721-safeTransferFrom}.
784      */
785     function safeTransferFrom(
786         address from,
787         address to,
788         uint256 tokenId,
789         bytes memory _data
790     ) public virtual override {
791         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
792         _safeTransfer(from, to, tokenId, _data);
793     }
794 
795     /**
796      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
797      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
798      *
799      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
800      *
801      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
802      * implement alternative mechanisms to perform token transfer, such as signature-based.
803      *
804      * Requirements:
805      *
806      * - `from` cannot be the zero address.
807      * - `to` cannot be the zero address.
808      * - `tokenId` token must exist and be owned by `from`.
809      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
810      *
811      * Emits a {Transfer} event.
812      */
813     function _safeTransfer(
814         address from,
815         address to,
816         uint256 tokenId,
817         bytes memory _data
818     ) internal virtual {
819         _transfer(from, to, tokenId);
820         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
821     }
822 
823     /**
824      * @dev Returns whether `tokenId` exists.
825      *
826      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
827      *
828      * Tokens start existing when they are minted (`_mint`),
829      * and stop existing when they are burned (`_burn`).
830      */
831     function _exists(uint256 tokenId) internal view virtual returns (bool) {
832         return _owners[tokenId] != address(0);
833     }
834 
835     /**
836      * @dev Returns whether `spender` is allowed to manage `tokenId`.
837      *
838      * Requirements:
839      *
840      * - `tokenId` must exist.
841      */
842     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
843         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
844         address owner = ERC721.ownerOf(tokenId);
845         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
846     }
847 
848     /**
849      * @dev Safely mints `tokenId` and transfers it to `to`.
850      *
851      * Requirements:
852      *
853      * - `tokenId` must not exist.
854      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
855      *
856      * Emits a {Transfer} event.
857      */
858     function _safeMint(address to, uint256 tokenId) internal virtual {
859         _safeMint(to, tokenId, "");
860     }
861 
862     /**
863      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
864      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
865      */
866     function _safeMint(
867         address to,
868         uint256 tokenId,
869         bytes memory _data
870     ) internal virtual {
871         _mint(to, tokenId);
872         require(
873             _checkOnERC721Received(address(0), to, tokenId, _data),
874             "ERC721: transfer to non ERC721Receiver implementer"
875         );
876     }
877 
878     /**
879      * @dev Mints `tokenId` and transfers it to `to`.
880      *
881      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
882      *
883      * Requirements:
884      *
885      * - `tokenId` must not exist.
886      * - `to` cannot be the zero address.
887      *
888      * Emits a {Transfer} event.
889      */
890     function _mint(address to, uint256 tokenId) internal virtual {
891         require(to != address(0), "ERC721: mint to the zero address");
892         require(!_exists(tokenId), "ERC721: token already minted");
893 
894         _beforeTokenTransfer(address(0), to, tokenId);
895 
896         _balances[to] += 1;
897         _owners[tokenId] = to;
898 
899         emit Transfer(address(0), to, tokenId);
900 
901         _afterTokenTransfer(address(0), to, tokenId);
902     }
903 
904     /**
905      * @dev Destroys `tokenId`.
906      * The approval is cleared when the token is burned.
907      *
908      * Requirements:
909      *
910      * - `tokenId` must exist.
911      *
912      * Emits a {Transfer} event.
913      */
914     function _burn(uint256 tokenId) internal virtual {
915         address owner = ERC721.ownerOf(tokenId);
916 
917         _beforeTokenTransfer(owner, address(0), tokenId);
918 
919         // Clear approvals
920         _approve(address(0), tokenId);
921 
922         _balances[owner] -= 1;
923         delete _owners[tokenId];
924 
925         emit Transfer(owner, address(0), tokenId);
926 
927         _afterTokenTransfer(owner, address(0), tokenId);
928     }
929 
930     /**
931      * @dev Transfers `tokenId` from `from` to `to`.
932      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
933      *
934      * Requirements:
935      *
936      * - `to` cannot be the zero address.
937      * - `tokenId` token must be owned by `from`.
938      *
939      * Emits a {Transfer} event.
940      */
941     function _transfer(
942         address from,
943         address to,
944         uint256 tokenId
945     ) internal virtual {
946         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
947         require(to != address(0), "ERC721: transfer to the zero address");
948 
949         _beforeTokenTransfer(from, to, tokenId);
950 
951         // Clear approvals from the previous owner
952         _approve(address(0), tokenId);
953 
954         _balances[from] -= 1;
955         _balances[to] += 1;
956         _owners[tokenId] = to;
957 
958         emit Transfer(from, to, tokenId);
959 
960         _afterTokenTransfer(from, to, tokenId);
961     }
962 
963     /**
964      * @dev Approve `to` to operate on `tokenId`
965      *
966      * Emits a {Approval} event.
967      */
968     function _approve(address to, uint256 tokenId) internal virtual {
969         _tokenApprovals[tokenId] = to;
970         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
971     }
972 
973     /**
974      * @dev Approve `operator` to operate on all of `owner` tokens
975      *
976      * Emits a {ApprovalForAll} event.
977      */
978     function _setApprovalForAll(
979         address owner,
980         address operator,
981         bool approved
982     ) internal virtual {
983         require(owner != operator, "ERC721: approve to caller");
984         _operatorApprovals[owner][operator] = approved;
985         emit ApprovalForAll(owner, operator, approved);
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
1021     function _beforeTokenTransfer(
1022         address from,
1023         address to,
1024         uint256 tokenId
1025     ) internal virtual {}
1026 
1027     /**
1028      * @dev Hook that is called after any transfer of tokens. This includes
1029      * minting and burning.
1030      *
1031      * Calling conditions:
1032      *
1033      * - when `from` and `to` are both non-zero.
1034      * - `from` and `to` are never both zero.
1035      *
1036      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1037      */
1038     function _afterTokenTransfer(
1039         address from,
1040         address to,
1041         uint256 tokenId
1042     ) internal virtual {}
1043 }
1044 
1045 
1046 pragma solidity ^0.8.0;
1047 
1048 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1049     // Mapping from owner to list of owned token IDs
1050     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1051 
1052     // Mapping from token ID to index of the owner tokens list
1053     mapping(uint256 => uint256) private _ownedTokensIndex;
1054 
1055     // Array with all token ids, used for enumeration
1056     uint256[] private _allTokens;
1057 
1058     // Mapping from token id to position in the allTokens array
1059     mapping(uint256 => uint256) private _allTokensIndex;
1060 
1061     /**
1062      * @dev See {IERC165-supportsInterface}.
1063      */
1064     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1065         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1066     }
1067 
1068     /**
1069      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1070      */
1071     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1072         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1073         return _ownedTokens[owner][index];
1074     }
1075 
1076     /**
1077      * @dev See {IERC721Enumerable-totalSupply}.
1078      */
1079     function totalSupply() public view virtual override returns (uint256) {
1080         return _allTokens.length;
1081     }
1082 
1083     /**
1084      * @dev See {IERC721Enumerable-tokenByIndex}.
1085      */
1086     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1087         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1088         return _allTokens[index];
1089     }
1090 
1091     function _beforeTokenTransfer(
1092         address from,
1093         address to,
1094         uint256 tokenId
1095     ) internal virtual override {
1096         super._beforeTokenTransfer(from, to, tokenId);
1097 
1098         if (from == address(0)) {
1099             _addTokenToAllTokensEnumeration(tokenId);
1100         } else if (from != to) {
1101             _removeTokenFromOwnerEnumeration(from, tokenId);
1102         }
1103         if (to == address(0)) {
1104             _removeTokenFromAllTokensEnumeration(tokenId);
1105         } else if (to != from) {
1106             _addTokenToOwnerEnumeration(to, tokenId);
1107         }
1108     }
1109 
1110     /**
1111      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1112      * @param to address representing the new owner of the given token ID
1113      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1114      */
1115     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1116         uint256 length = ERC721.balanceOf(to);
1117         _ownedTokens[to][length] = tokenId;
1118         _ownedTokensIndex[tokenId] = length;
1119     }
1120 
1121     /**
1122      * @dev Private function to add a token to this extension's token tracking data structures.
1123      * @param tokenId uint256 ID of the token to be added to the tokens list
1124      */
1125     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1126         _allTokensIndex[tokenId] = _allTokens.length;
1127         _allTokens.push(tokenId);
1128     }
1129 
1130     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1131         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1132         // then delete the last slot (swap and pop).
1133 
1134         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1135         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1136 
1137         // When the token to delete is the last token, the swap operation is unnecessary
1138         if (tokenIndex != lastTokenIndex) {
1139             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1140 
1141             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1142             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1143         }
1144 
1145         // This also deletes the contents at the last position of the array
1146         delete _ownedTokensIndex[tokenId];
1147         delete _ownedTokens[from][lastTokenIndex];
1148     }
1149 
1150     /**
1151      * @dev Private function to remove a token from this extension's token tracking data structures.
1152      * This has O(1) time complexity, but alters the order of the _allTokens array.
1153      * @param tokenId uint256 ID of the token to be removed from the tokens list
1154      */
1155     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1156         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1157         // then delete the last slot (swap and pop).
1158 
1159         uint256 lastTokenIndex = _allTokens.length - 1;
1160         uint256 tokenIndex = _allTokensIndex[tokenId];
1161 
1162         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1163         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1164         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1165         uint256 lastTokenId = _allTokens[lastTokenIndex];
1166 
1167         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1168         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1169 
1170         // This also deletes the contents at the last position of the array
1171         delete _allTokensIndex[tokenId];
1172         _allTokens.pop();
1173     }
1174 }
1175 
1176 
1177 pragma solidity ^0.8.4;
1178 
1179 error ApprovalCallerNotOwnerNorApproved();
1180 error ApprovalQueryForNonexistentToken();
1181 error ApproveToCaller();
1182 error ApprovalToCurrentOwner();
1183 error BalanceQueryForZeroAddress();
1184 error MintToZeroAddress();
1185 error MintZeroQuantity();
1186 error OwnerQueryForNonexistentToken();
1187 error TransferCallerNotOwnerNorApproved();
1188 error TransferFromIncorrectOwner();
1189 error TransferToNonERC721ReceiverImplementer();
1190 error TransferToZeroAddress();
1191 error URIQueryForNonexistentToken();
1192 
1193 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
1194     using Address for address;
1195     using Strings for uint256;
1196 
1197     // Compiler will pack this into a single 256bit word.
1198     struct TokenOwnership {
1199         // The address of the owner.
1200         address addr;
1201         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
1202         uint64 startTimestamp;
1203         // Whether the token has been burned.
1204         bool burned;
1205     }
1206 
1207     // Compiler will pack this into a single 256bit word.
1208     struct AddressData {
1209         // Realistically, 2**64-1 is more than enough.
1210         uint64 balance;
1211         // Keeps track of mint count with minimal overhead for tokenomics.
1212         uint64 numberMinted;
1213         // Keeps track of burn count with minimal overhead for tokenomics.
1214         uint64 numberBurned;
1215         // For miscellaneous variable(s) pertaining to the address
1216         // (e.g. number of whitelist mint slots used).
1217         // If there are multiple variables, please pack them into a uint64.
1218         uint64 aux;
1219     }
1220 
1221     // The tokenId of the next token to be minted.
1222     uint256 internal _currentIndex;
1223 
1224     // The number of tokens burned.
1225     uint256 internal _burnCounter;
1226 
1227     // Token name
1228     string private _name;
1229 
1230     // Token symbol
1231     string private _symbol;
1232 
1233     // Mapping from token ID to ownership details
1234     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
1235     mapping(uint256 => TokenOwnership) internal _ownerships;
1236 
1237     // Mapping owner address to address data
1238     mapping(address => AddressData) private _addressData;
1239 
1240     // Mapping from token ID to approved address
1241     mapping(uint256 => address) private _tokenApprovals;
1242 
1243     // Mapping from owner to operator approvals
1244     mapping(address => mapping(address => bool)) private _operatorApprovals;
1245 
1246     constructor(string memory name_, string memory symbol_) {
1247         _name = name_;
1248         _symbol = symbol_;
1249         _currentIndex = _startTokenId();
1250     }
1251 
1252     /**
1253      * To change the starting tokenId, please override this function.
1254      */
1255     function _startTokenId() internal view virtual returns (uint256) {
1256         return 0;
1257     }
1258 
1259     /**
1260      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
1261      */
1262     function totalSupply() public view returns (uint256) {
1263         // Counter underflow is impossible as _burnCounter cannot be incremented
1264         // more than _currentIndex - _startTokenId() times
1265         unchecked {
1266             return _currentIndex - _burnCounter - _startTokenId();
1267         }
1268     }
1269 
1270     /**
1271      * Returns the total amount of tokens minted in the contract.
1272      */
1273     function _totalMinted() internal view returns (uint256) {
1274         // Counter underflow is impossible as _currentIndex does not decrement,
1275         // and it is initialized to _startTokenId()
1276         unchecked {
1277             return _currentIndex - _startTokenId();
1278         }
1279     }
1280 
1281     /**
1282      * @dev See {IERC165-supportsInterface}.
1283      */
1284     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1285         return
1286             interfaceId == type(IERC721).interfaceId ||
1287             interfaceId == type(IERC721Metadata).interfaceId ||
1288             super.supportsInterface(interfaceId);
1289     }
1290 
1291     /**
1292      * @dev See {IERC721-balanceOf}.
1293      */
1294     function balanceOf(address owner) public view override returns (uint256) {
1295         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1296         return uint256(_addressData[owner].balance);
1297     }
1298 
1299     /**
1300      * Returns the number of tokens minted by `owner`.
1301      */
1302     function _numberMinted(address owner) internal view returns (uint256) {
1303         return uint256(_addressData[owner].numberMinted);
1304     }
1305 
1306     /**
1307      * Returns the number of tokens burned by or on behalf of `owner`.
1308      */
1309     function _numberBurned(address owner) internal view returns (uint256) {
1310         return uint256(_addressData[owner].numberBurned);
1311     }
1312 
1313     /**
1314      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1315      */
1316     function _getAux(address owner) internal view returns (uint64) {
1317         return _addressData[owner].aux;
1318     }
1319 
1320     /**
1321      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1322      * If there are multiple variables, please pack them into a uint64.
1323      */
1324     function _setAux(address owner, uint64 aux) internal {
1325         _addressData[owner].aux = aux;
1326     }
1327 
1328     /**
1329      * Gas spent here starts off proportional to the maximum mint batch size.
1330      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1331      */
1332     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1333         uint256 curr = tokenId;
1334 
1335         unchecked {
1336             if (_startTokenId() <= curr && curr < _currentIndex) {
1337                 TokenOwnership memory ownership = _ownerships[curr];
1338                 if (!ownership.burned) {
1339                     if (ownership.addr != address(0)) {
1340                         return ownership;
1341                     }
1342                     // Invariant:
1343                     // There will always be an ownership that has an address and is not burned
1344                     // before an ownership that does not have an address and is not burned.
1345                     // Hence, curr will not underflow.
1346                     while (true) {
1347                         curr--;
1348                         ownership = _ownerships[curr];
1349                         if (ownership.addr != address(0)) {
1350                             return ownership;
1351                         }
1352                     }
1353                 }
1354             }
1355         }
1356         revert OwnerQueryForNonexistentToken();
1357     }
1358 
1359     /**
1360      * @dev See {IERC721-ownerOf}.
1361      */
1362     function ownerOf(uint256 tokenId) public view override returns (address) {
1363         return _ownershipOf(tokenId).addr;
1364     }
1365 
1366     /**
1367      * @dev See {IERC721Metadata-name}.
1368      */
1369     function name() public view virtual override returns (string memory) {
1370         return _name;
1371     }
1372 
1373     /**
1374      * @dev See {IERC721Metadata-symbol}.
1375      */
1376     function symbol() public view virtual override returns (string memory) {
1377         return _symbol;
1378     }
1379 
1380     /**
1381      * @dev See {IERC721Metadata-tokenURI}.
1382      */
1383     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1384         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1385 
1386         string memory baseURI = _baseURI();
1387         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1388     }
1389 
1390     /**
1391      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1392      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1393      * by default, can be overriden in child contracts.
1394      */
1395     function _baseURI() internal view virtual returns (string memory) {
1396         return '';
1397     }
1398 
1399     /**
1400      * @dev See {IERC721-approve}.
1401      */
1402     function approve(address to, uint256 tokenId) public override {
1403         address owner = ERC721A.ownerOf(tokenId);
1404         if (to == owner) revert ApprovalToCurrentOwner();
1405 
1406         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1407             revert ApprovalCallerNotOwnerNorApproved();
1408         }
1409 
1410         _approve(to, tokenId, owner);
1411     }
1412 
1413     /**
1414      * @dev See {IERC721-getApproved}.
1415      */
1416     function getApproved(uint256 tokenId) public view override returns (address) {
1417         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1418 
1419         return _tokenApprovals[tokenId];
1420     }
1421 
1422     /**
1423      * @dev See {IERC721-setApprovalForAll}.
1424      */
1425     function setApprovalForAll(address operator, bool approved) public virtual override {
1426         if (operator == _msgSender()) revert ApproveToCaller();
1427 
1428         _operatorApprovals[_msgSender()][operator] = approved;
1429         emit ApprovalForAll(_msgSender(), operator, approved);
1430     }
1431 
1432     /**
1433      * @dev See {IERC721-isApprovedForAll}.
1434      */
1435     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1436         return _operatorApprovals[owner][operator];
1437     }
1438 
1439     /**
1440      * @dev See {IERC721-transferFrom}.
1441      */
1442     function transferFrom(
1443         address from,
1444         address to,
1445         uint256 tokenId
1446     ) public virtual override {
1447         _transfer(from, to, tokenId);
1448     }
1449 
1450     /**
1451      * @dev See {IERC721-safeTransferFrom}.
1452      */
1453     function safeTransferFrom(
1454         address from,
1455         address to,
1456         uint256 tokenId
1457     ) public virtual override {
1458         safeTransferFrom(from, to, tokenId, '');
1459     }
1460 
1461     /**
1462      * @dev See {IERC721-safeTransferFrom}.
1463      */
1464     function safeTransferFrom(
1465         address from,
1466         address to,
1467         uint256 tokenId,
1468         bytes memory _data
1469     ) public virtual override {
1470         _transfer(from, to, tokenId);
1471         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1472             revert TransferToNonERC721ReceiverImplementer();
1473         }
1474     }
1475 
1476     /**
1477      * @dev Returns whether `tokenId` exists.
1478      *
1479      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1480      *
1481      * Tokens start existing when they are minted (`_mint`),
1482      */
1483     function _exists(uint256 tokenId) internal view returns (bool) {
1484         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1485     }
1486 
1487     function _safeMint(address to, uint256 quantity) internal {
1488         _safeMint(to, quantity, '');
1489     }
1490 
1491     /**
1492      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1493      *
1494      * Requirements:
1495      *
1496      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1497      * - `quantity` must be greater than 0.
1498      *
1499      * Emits a {Transfer} event.
1500      */
1501     function _safeMint(
1502         address to,
1503         uint256 quantity,
1504         bytes memory _data
1505     ) internal {
1506         _mint(to, quantity, _data, true);
1507     }
1508 
1509     /**
1510      * @dev Mints `quantity` tokens and transfers them to `to`.
1511      *
1512      * Requirements:
1513      *
1514      * - `to` cannot be the zero address.
1515      * - `quantity` must be greater than 0.
1516      *
1517      * Emits a {Transfer} event.
1518      */
1519     function _mint(
1520         address to,
1521         uint256 quantity,
1522         bytes memory _data,
1523         bool safe
1524     ) internal {
1525         uint256 startTokenId = _currentIndex;
1526         if (to == address(0)) revert MintToZeroAddress();
1527         if (quantity == 0) revert MintZeroQuantity();
1528 
1529         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1530 
1531         // Overflows are incredibly unrealistic.
1532         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1533         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1534         unchecked {
1535             _addressData[to].balance += uint64(quantity);
1536             _addressData[to].numberMinted += uint64(quantity);
1537 
1538             _ownerships[startTokenId].addr = to;
1539             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1540 
1541             uint256 updatedIndex = startTokenId;
1542             uint256 end = updatedIndex + quantity;
1543 
1544             if (safe && to.isContract()) {
1545                 do {
1546                     emit Transfer(address(0), to, updatedIndex);
1547                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1548                         revert TransferToNonERC721ReceiverImplementer();
1549                     }
1550                 } while (updatedIndex != end);
1551                 // Reentrancy protection
1552                 if (_currentIndex != startTokenId) revert();
1553             } else {
1554                 do {
1555                     emit Transfer(address(0), to, updatedIndex++);
1556                 } while (updatedIndex != end);
1557             }
1558             _currentIndex = updatedIndex;
1559         }
1560         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1561     }
1562 
1563     function _transfer(
1564         address from,
1565         address to,
1566         uint256 tokenId
1567     ) private {
1568         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1569 
1570         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1571 
1572         bool isApprovedOrOwner = (_msgSender() == from ||
1573             isApprovedForAll(from, _msgSender()) ||
1574             getApproved(tokenId) == _msgSender());
1575 
1576         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1577         if (to == address(0)) revert TransferToZeroAddress();
1578 
1579         _beforeTokenTransfers(from, to, tokenId, 1);
1580 
1581         // Clear approvals from the previous owner
1582         _approve(address(0), tokenId, from);
1583 
1584         // Underflow of the sender's balance is impossible because we check for
1585         // ownership above and the recipient's balance can't realistically overflow.
1586         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1587         unchecked {
1588             _addressData[from].balance -= 1;
1589             _addressData[to].balance += 1;
1590 
1591             TokenOwnership storage currSlot = _ownerships[tokenId];
1592             currSlot.addr = to;
1593             currSlot.startTimestamp = uint64(block.timestamp);
1594 
1595             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1596             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1597             uint256 nextTokenId = tokenId + 1;
1598             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1599             if (nextSlot.addr == address(0)) {
1600                 // This will suffice for checking _exists(nextTokenId),
1601                 // as a burned slot cannot contain the zero address.
1602                 if (nextTokenId != _currentIndex) {
1603                     nextSlot.addr = from;
1604                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1605                 }
1606             }
1607         }
1608 
1609         emit Transfer(from, to, tokenId);
1610         _afterTokenTransfers(from, to, tokenId, 1);
1611     }
1612 
1613     /**
1614      * @dev This is equivalent to _burn(tokenId, false)
1615      */
1616     function _burn(uint256 tokenId) internal virtual {
1617         _burn(tokenId, false);
1618     }
1619 
1620     /**
1621      * @dev Destroys `tokenId`.
1622      * The approval is cleared when the token is burned.
1623      *
1624      * Requirements:
1625      *
1626      * - `tokenId` must exist.
1627      *
1628      * Emits a {Transfer} event.
1629      */
1630     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1631         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1632 
1633         address from = prevOwnership.addr;
1634 
1635         if (approvalCheck) {
1636             bool isApprovedOrOwner = (_msgSender() == from ||
1637                 isApprovedForAll(from, _msgSender()) ||
1638                 getApproved(tokenId) == _msgSender());
1639 
1640             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1641         }
1642 
1643         _beforeTokenTransfers(from, address(0), tokenId, 1);
1644 
1645         // Clear approvals from the previous owner
1646         _approve(address(0), tokenId, from);
1647 
1648         // Underflow of the sender's balance is impossible because we check for
1649         // ownership above and the recipient's balance can't realistically overflow.
1650         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1651         unchecked {
1652             AddressData storage addressData = _addressData[from];
1653             addressData.balance -= 1;
1654             addressData.numberBurned += 1;
1655 
1656             // Keep track of who burned the token, and the timestamp of burning.
1657             TokenOwnership storage currSlot = _ownerships[tokenId];
1658             currSlot.addr = from;
1659             currSlot.startTimestamp = uint64(block.timestamp);
1660             currSlot.burned = true;
1661 
1662             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1663             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1664             uint256 nextTokenId = tokenId + 1;
1665             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1666             if (nextSlot.addr == address(0)) {
1667                 // This will suffice for checking _exists(nextTokenId),
1668                 // as a burned slot cannot contain the zero address.
1669                 if (nextTokenId != _currentIndex) {
1670                     nextSlot.addr = from;
1671                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1672                 }
1673             }
1674         }
1675 
1676         emit Transfer(from, address(0), tokenId);
1677         _afterTokenTransfers(from, address(0), tokenId, 1);
1678 
1679         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1680         unchecked {
1681             _burnCounter++;
1682         }
1683     }
1684 
1685     /**
1686      * @dev Approve `to` to operate on `tokenId`
1687      *
1688      * Emits a {Approval} event.
1689      */
1690     function _approve(
1691         address to,
1692         uint256 tokenId,
1693         address owner
1694     ) private {
1695         _tokenApprovals[tokenId] = to;
1696         emit Approval(owner, to, tokenId);
1697     }
1698 
1699     /**
1700      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1701      *
1702      * @param from address representing the previous owner of the given token ID
1703      * @param to target address that will receive the tokens
1704      * @param tokenId uint256 ID of the token to be transferred
1705      * @param _data bytes optional data to send along with the call
1706      * @return bool whether the call correctly returned the expected magic value
1707      */
1708     function _checkContractOnERC721Received(
1709         address from,
1710         address to,
1711         uint256 tokenId,
1712         bytes memory _data
1713     ) private returns (bool) {
1714         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1715             return retval == IERC721Receiver(to).onERC721Received.selector;
1716         } catch (bytes memory reason) {
1717             if (reason.length == 0) {
1718                 revert TransferToNonERC721ReceiverImplementer();
1719             } else {
1720                 assembly {
1721                     revert(add(32, reason), mload(reason))
1722                 }
1723             }
1724         }
1725     }
1726 
1727     function _beforeTokenTransfers(
1728         address from,
1729         address to,
1730         uint256 startTokenId,
1731         uint256 quantity
1732     ) internal virtual {}
1733 
1734     function _afterTokenTransfers(
1735         address from,
1736         address to,
1737         uint256 startTokenId,
1738         uint256 quantity
1739     ) internal virtual {}
1740 }
1741 
1742 
1743 pragma solidity ^0.8.4;
1744 
1745 
1746 contract Project0xD38 is ERC721A, Ownable {
1747     using Strings for uint256;
1748 
1749     string private baseURI;
1750 
1751     string public hiddenMetadataUri;
1752 
1753     uint256 public price = 0.016 ether;
1754 
1755     uint256 public maxPerTx = 10;
1756 
1757     uint256 public maxFreePerWallet = 2;
1758 
1759     uint256 public totalFree = 8000;
1760 
1761     uint256 public maxSupply = 10000;
1762 
1763     uint public nextId = 0;
1764 
1765     bool public mintEnabled = false;
1766 
1767     bool public revealed = true;
1768 
1769     mapping(address => uint256) private _mintedFreeAmount;
1770 
1771     constructor() ERC721A("Project 0xD38", "0xD38") {
1772         setHiddenMetadataUri("https://api.0xd38.xyz/");
1773         setBaseURI("https://api.0xd38.xyz/");
1774     }
1775 
1776     function mint(uint256 count) external payable {
1777       uint256 cost = price;
1778       bool isFree =
1779       ((totalSupply() + count < totalFree + 1) &&
1780       (_mintedFreeAmount[msg.sender] + count <= maxFreePerWallet));
1781 
1782       if (isFree) {
1783       cost = 0;
1784      }
1785 
1786      else {
1787       require(msg.value >= count * price, "Please send the exact amount.");
1788       require(totalSupply() + count <= maxSupply, "No more 0xD38");
1789       require(mintEnabled, "Minting is not live yet");
1790       require(count <= maxPerTx, "Max per TX reached.");
1791      }
1792 
1793       if (isFree) {
1794          _mintedFreeAmount[msg.sender] += count;
1795       }
1796 
1797      _safeMint(msg.sender, count);
1798      nextId += count;
1799     }
1800 
1801     function _baseURI() internal view virtual override returns (string memory) {
1802         return baseURI;
1803     }
1804 
1805     function tokenURI(uint256 tokenId)
1806         public
1807         view
1808         virtual
1809         override
1810         returns (string memory)
1811     {
1812         require(
1813             _exists(tokenId),
1814             "ERC721Metadata: URI query for nonexistent token"
1815         );
1816 
1817         if (revealed == false) {
1818          return string(abi.encodePacked(hiddenMetadataUri));
1819         }
1820     
1821         return string(abi.encodePacked(baseURI, tokenId.toString(), ".json"));
1822     }
1823 
1824     function setBaseURI(string memory uri) public onlyOwner {
1825         baseURI = uri;
1826     }
1827 
1828     function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1829      hiddenMetadataUri = _hiddenMetadataUri;
1830     }
1831 
1832     function setFreeAmount(uint256 amount) external onlyOwner {
1833         totalFree = amount;
1834     }
1835 
1836     function setPrice(uint256 _newPrice) external onlyOwner {
1837         price = _newPrice;
1838     }
1839 
1840     function setRevealed() external onlyOwner {
1841      revealed = !revealed;
1842     }
1843 
1844     function flipSale() external onlyOwner {
1845         mintEnabled = !mintEnabled;
1846     }
1847 
1848     function getNextId() public view returns(uint){
1849      return nextId;
1850     }
1851 
1852     function _startTokenId() internal pure override returns (uint256) {
1853         return 1;
1854     }
1855 
1856     function withdraw() external onlyOwner {
1857         (bool success, ) = payable(msg.sender).call{
1858             value: address(this).balance
1859         }("");
1860         require(success, "Transfer failed.");
1861     }
1862 
1863     function WhitelistMint(address to, uint256 quantity)public onlyOwner{
1864     require(totalSupply() + quantity <= maxSupply, "reached max supply");
1865     _safeMint(to, quantity);
1866   }
1867 }