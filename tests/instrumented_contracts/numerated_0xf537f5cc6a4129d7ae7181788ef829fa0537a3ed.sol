1 // SPDX-License-Identifier: GPL-3.0
2 // File: @openzeppelin/contracts/utils/Strings.sol
3 
4 
5 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev String operations.
11  */
12 library Strings {
13     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
14 
15     /**
16      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
17      */
18     function toString(uint256 value) internal pure returns (string memory) {
19         // Inspired by OraclizeAPI's implementation - MIT licence
20         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
21 
22         if (value == 0) {
23             return "0";
24         }
25         uint256 temp = value;
26         uint256 digits;
27         while (temp != 0) {
28             digits++;
29             temp /= 10;
30         }
31         bytes memory buffer = new bytes(digits);
32         while (value != 0) {
33             digits -= 1;
34             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
35             value /= 10;
36         }
37         return string(buffer);
38     }
39 
40     /**
41      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
42      */
43     function toHexString(uint256 value) internal pure returns (string memory) {
44         if (value == 0) {
45             return "0x00";
46         }
47         uint256 temp = value;
48         uint256 length = 0;
49         while (temp != 0) {
50             length++;
51             temp >>= 8;
52         }
53         return toHexString(value, length);
54     }
55 
56     /**
57      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
58      */
59     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
60         bytes memory buffer = new bytes(2 * length + 2);
61         buffer[0] = "0";
62         buffer[1] = "x";
63         for (uint256 i = 2 * length + 1; i > 1; --i) {
64             buffer[i] = _HEX_SYMBOLS[value & 0xf];
65             value >>= 4;
66         }
67         require(value == 0, "Strings: hex length insufficient");
68         return string(buffer);
69     }
70 }
71 
72 
73 // File: @openzeppelin/contracts/utils/Address.sol
74 
75 
76 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
77 
78 pragma solidity ^0.8.1;
79 
80 /**
81  * @dev Collection of functions related to the address type
82  */
83 library Address {
84     /**
85      * @dev Returns true if `account` is a contract.
86      *
87      * [IMPORTANT]
88      * ====
89      * It is unsafe to assume that an address for which this function returns
90      * false is an externally-owned account (EOA) and not a contract.
91      *
92      * Among others, `isContract` will return false for the following
93      * types of addresses:
94      *
95      *  - an externally-owned account
96      *  - a contract in construction
97      *  - an address where a contract will be created
98      *  - an address where a contract lived, but was destroyed
99      * ====
100      *
101      * [IMPORTANT]
102      * ====
103      * You shouldn't rely on `isContract` to protect against flash loan attacks!
104      *
105      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
106      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
107      * constructor.
108      * ====
109      */
110     function isContract(address account) internal view returns (bool) {
111         // This method relies on extcodesize/address.code.length, which returns 0
112         // for contracts in construction, since the code is only stored at the end
113         // of the constructor execution.
114 
115         return account.code.length > 0;
116     }
117 
118     /**
119      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
120      * `recipient`, forwarding all available gas and reverting on errors.
121      *
122      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
123      * of certain opcodes, possibly making contracts go over the 2300 gas limit
124      * imposed by `transfer`, making them unable to receive funds via
125      * `transfer`. {sendValue} removes this limitation.
126      *
127      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
128      *
129      * IMPORTANT: because control is transferred to `recipient`, care must be
130      * taken to not create reentrancy vulnerabilities. Consider using
131      * {ReentrancyGuard} or the
132      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
133      */
134     function sendValue(address payable recipient, uint256 amount) internal {
135         require(address(this).balance >= amount, "Address: insufficient balance");
136 
137         (bool success, ) = recipient.call{value: amount}("");
138         require(success, "Address: unable to send value, recipient may have reverted");
139     }
140 
141     /**
142      * @dev Performs a Solidity function call using a low level `call`. A
143      * plain `call` is an unsafe replacement for a function call: use this
144      * function instead.
145      *
146      * If `target` reverts with a revert reason, it is bubbled up by this
147      * function (like regular Solidity function calls).
148      *
149      * Returns the raw returned data. To convert to the expected return value,
150      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
151      *
152      * Requirements:
153      *
154      * - `target` must be a contract.
155      * - calling `target` with `data` must not revert.
156      *
157      * _Available since v3.1._
158      */
159     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
160         return functionCall(target, data, "Address: low-level call failed");
161     }
162 
163     /**
164      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
165      * `errorMessage` as a fallback revert reason when `target` reverts.
166      *
167      * _Available since v3.1._
168      */
169     function functionCall(
170         address target,
171         bytes memory data,
172         string memory errorMessage
173     ) internal returns (bytes memory) {
174         return functionCallWithValue(target, data, 0, errorMessage);
175     }
176 
177     /**
178      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
179      * but also transferring `value` wei to `target`.
180      *
181      * Requirements:
182      *
183      * - the calling contract must have an ETH balance of at least `value`.
184      * - the called Solidity function must be `payable`.
185      *
186      * _Available since v3.1._
187      */
188     function functionCallWithValue(
189         address target,
190         bytes memory data,
191         uint256 value
192     ) internal returns (bytes memory) {
193         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
194     }
195 
196     /**
197      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
198      * with `errorMessage` as a fallback revert reason when `target` reverts.
199      *
200      * _Available since v3.1._
201      */
202     function functionCallWithValue(
203         address target,
204         bytes memory data,
205         uint256 value,
206         string memory errorMessage
207     ) internal returns (bytes memory) {
208         require(address(this).balance >= value, "Address: insufficient balance for call");
209         require(isContract(target), "Address: call to non-contract");
210 
211         (bool success, bytes memory returndata) = target.call{value: value}(data);
212         return verifyCallResult(success, returndata, errorMessage);
213     }
214 
215     /**
216      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
217      * but performing a static call.
218      *
219      * _Available since v3.3._
220      */
221     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
222         return functionStaticCall(target, data, "Address: low-level static call failed");
223     }
224 
225     /**
226      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
227      * but performing a static call.
228      *
229      * _Available since v3.3._
230      */
231     function functionStaticCall(
232         address target,
233         bytes memory data,
234         string memory errorMessage
235     ) internal view returns (bytes memory) {
236         require(isContract(target), "Address: static call to non-contract");
237 
238         (bool success, bytes memory returndata) = target.staticcall(data);
239         return verifyCallResult(success, returndata, errorMessage);
240     }
241 
242     /**
243      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
244      * but performing a delegate call.
245      *
246      * _Available since v3.4._
247      */
248     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
249         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
250     }
251 
252     /**
253      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
254      * but performing a delegate call.
255      *
256      * _Available since v3.4._
257      */
258     function functionDelegateCall(
259         address target,
260         bytes memory data,
261         string memory errorMessage
262     ) internal returns (bytes memory) {
263         require(isContract(target), "Address: delegate call to non-contract");
264 
265         (bool success, bytes memory returndata) = target.delegatecall(data);
266         return verifyCallResult(success, returndata, errorMessage);
267     }
268 
269     /**
270      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
271      * revert reason using the provided one.
272      *
273      * _Available since v4.3._
274      */
275     function verifyCallResult(
276         bool success,
277         bytes memory returndata,
278         string memory errorMessage
279     ) internal pure returns (bytes memory) {
280         if (success) {
281             return returndata;
282         } else {
283             // Look for revert reason and bubble it up if present
284             if (returndata.length > 0) {
285                 // The easiest way to bubble the revert reason is using memory via assembly
286 
287                 assembly {
288                     let returndata_size := mload(returndata)
289                     revert(add(32, returndata), returndata_size)
290                 }
291             } else {
292                 revert(errorMessage);
293             }
294         }
295     }
296 }
297 
298 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
299 
300 
301 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
302 
303 pragma solidity ^0.8.0;
304 
305 /**
306  * @title ERC721 token receiver interface
307  * @dev Interface for any contract that wants to support safeTransfers
308  * from ERC721 asset contracts.
309  */
310 interface IERC721Receiver {
311     /**
312      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
313      * by `operator` from `from`, this function is called.
314      *
315      * It must return its Solidity selector to confirm the token transfer.
316      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
317      *
318      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
319      */
320     function onERC721Received(
321         address operator,
322         address from,
323         uint256 tokenId,
324         bytes calldata data
325     ) external returns (bytes4);
326 }
327 
328 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
329 
330 
331 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
332 
333 pragma solidity ^0.8.0;
334 
335 /**
336  * @dev Interface of the ERC165 standard, as defined in the
337  * https://eips.ethereum.org/EIPS/eip-165[EIP].
338  *
339  * Implementers can declare support of contract interfaces, which can then be
340  * queried by others ({ERC165Checker}).
341  *
342  * For an implementation, see {ERC165}.
343  */
344 interface IERC165 {
345     /**
346      * @dev Returns true if this contract implements the interface defined by
347      * `interfaceId`. See the corresponding
348      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
349      * to learn more about how these ids are created.
350      *
351      * This function call must use less than 30 000 gas.
352      */
353     function supportsInterface(bytes4 interfaceId) external view returns (bool);
354 }
355 
356 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
357 
358 
359 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
360 
361 pragma solidity ^0.8.0;
362 
363 
364 /**
365  * @dev Implementation of the {IERC165} interface.
366  *
367  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
368  * for the additional interface id that will be supported. For example:
369  *
370  * ```solidity
371  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
372  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
373  * }
374  * ```
375  *
376  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
377  */
378 abstract contract ERC165 is IERC165 {
379     /**
380      * @dev See {IERC165-supportsInterface}.
381      */
382     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
383         return interfaceId == type(IERC165).interfaceId;
384     }
385 }
386 
387 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
388 
389 
390 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
391 
392 pragma solidity ^0.8.0;
393 
394 
395 /**
396  * @dev Required interface of an ERC721 compliant contract.
397  */
398 interface IERC721 is IERC165 {
399     /**
400      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
401      */
402     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
403 
404     /**
405      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
406      */
407     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
408 
409     /**
410      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
411      */
412     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
413 
414     /**
415      * @dev Returns the number of tokens in ``owner``'s account.
416      */
417     function balanceOf(address owner) external view returns (uint256 balance);
418 
419     /**
420      * @dev Returns the owner of the `tokenId` token.
421      *
422      * Requirements:
423      *
424      * - `tokenId` must exist.
425      */
426     function ownerOf(uint256 tokenId) external view returns (address owner);
427 
428     /**
429      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
430      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
431      *
432      * Requirements:
433      *
434      * - `from` cannot be the zero address.
435      * - `to` cannot be the zero address.
436      * - `tokenId` token must exist and be owned by `from`.
437      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
438      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
439      *
440      * Emits a {Transfer} event.
441      */
442     function safeTransferFrom(
443         address from,
444         address to,
445         uint256 tokenId
446     ) external;
447 
448     /**
449      * @dev Transfers `tokenId` token from `from` to `to`.
450      *
451      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
452      *
453      * Requirements:
454      *
455      * - `from` cannot be the zero address.
456      * - `to` cannot be the zero address.
457      * - `tokenId` token must be owned by `from`.
458      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
459      *
460      * Emits a {Transfer} event.
461      */
462     function transferFrom(
463         address from,
464         address to,
465         uint256 tokenId
466     ) external;
467 
468     /**
469      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
470      * The approval is cleared when the token is transferred.
471      *
472      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
473      *
474      * Requirements:
475      *
476      * - The caller must own the token or be an approved operator.
477      * - `tokenId` must exist.
478      *
479      * Emits an {Approval} event.
480      */
481     function approve(address to, uint256 tokenId) external;
482 
483     /**
484      * @dev Returns the account approved for `tokenId` token.
485      *
486      * Requirements:
487      *
488      * - `tokenId` must exist.
489      */
490     function getApproved(uint256 tokenId) external view returns (address operator);
491 
492     /**
493      * @dev Approve or remove `operator` as an operator for the caller.
494      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
495      *
496      * Requirements:
497      *
498      * - The `operator` cannot be the caller.
499      *
500      * Emits an {ApprovalForAll} event.
501      */
502     function setApprovalForAll(address operator, bool _approved) external;
503 
504     /**
505      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
506      *
507      * See {setApprovalForAll}
508      */
509     function isApprovedForAll(address owner, address operator) external view returns (bool);
510 
511     /**
512      * @dev Safely transfers `tokenId` token from `from` to `to`.
513      *
514      * Requirements:
515      *
516      * - `from` cannot be the zero address.
517      * - `to` cannot be the zero address.
518      * - `tokenId` token must exist and be owned by `from`.
519      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
520      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
521      *
522      * Emits a {Transfer} event.
523      */
524     function safeTransferFrom(
525         address from,
526         address to,
527         uint256 tokenId,
528         bytes calldata data
529     ) external;
530 }
531 
532 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
533 
534 
535 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
536 
537 pragma solidity ^0.8.0;
538 
539 
540 /**
541  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
542  * @dev See https://eips.ethereum.org/EIPS/eip-721
543  */
544 interface IERC721Metadata is IERC721 {
545     /**
546      * @dev Returns the token collection name.
547      */
548     function name() external view returns (string memory);
549 
550     /**
551      * @dev Returns the token collection symbol.
552      */
553     function symbol() external view returns (string memory);
554 
555     /**
556      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
557      */
558     function tokenURI(uint256 tokenId) external view returns (string memory);
559 }
560 
561 // File: SMSC.sol
562 
563 
564 
565 pragma solidity ^0.8.4;
566 
567 interface IERC20 {
568     function totalSupply() external view returns (uint256);
569 
570     function decimals() external view returns (uint8);
571 
572     function symbol() external view returns (string memory);
573 
574     function name() external view returns (string memory);
575 
576     function getOwner() external view returns (address);
577 
578     function balanceOf(address account) external view returns (uint256);
579 
580     function transfer(address recipient, uint256 amount) external returns (bool);
581 
582     function allowance(address _owner, address spender) external view returns (uint256);
583 
584     function approve(address spender, uint256 amount) external returns (bool);
585 
586     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
587 
588     event Transfer(address indexed from, address indexed to, uint256 value);
589 
590     event Approval(address indexed owner, address indexed spender, uint256 value);
591 }
592 
593 
594 
595 error TransferToNonERC721ReceiverImplementer();
596 
597 contract Ownable {
598     address public owner;
599 
600     constructor() {
601         owner = msg.sender;
602     }
603 
604     // ownership
605     modifier onlyOwner() {
606         require(msg.sender == owner, "ERROR! Access denied");
607         _;
608     }
609 
610     function transferOwnership(address _newOwner) external onlyOwner {
611         owner = _newOwner;
612     }
613 
614     function renounceOwnership() external onlyOwner {
615         owner = address(0);
616     }
617 }
618 
619 contract LazyHorseNFT is IERC721, Ownable {
620     using Address for address;
621     using Strings for uint256;
622 
623     string private _name = "Lazy Horse Race Club";
624     string private _symbol = "Lazy Horse";
625 
626     uint16 public pubsaleSupply = 10000;
627     uint16 public limitPerAddress = 100;
628     uint public totalSupply;
629 
630     bool public revealed;
631 
632     bool public presaleOpen;
633     bool public pubsaleOpen;
634 
635     uint public presaleCost = 0.03 ether;
636     uint256 public cost = 0.05 ether;
637     uint256 internal _currentIndex = 1;
638 
639     mapping(address => uint256) private _balances;
640     mapping(uint256 => address) public ownership;
641     mapping(address => uint256) public addressMints;
642 
643     string public baseURI;
644     string public norevealedURI;
645     string public baseExtension;
646 
647     mapping(uint256 => address) private _tokenApprovals;
648     mapping(address => mapping(address => bool)) private _operatorApprovals;
649 
650     modifier onlyTokenOwner(uint256 tokenId) {
651         require(
652             ownerOf(tokenId) == msg.sender,
653             "ERROR! You must be the token owner"
654         );
655         _;
656     }
657 
658     function name() public view returns (string memory) {
659         return _name;
660     }
661 
662     function symbol() public view returns (string memory) {
663         return _symbol;
664     }
665 
666     function approve(address to, uint256 tokenId) public virtual override {
667         address owner = ownerOf(tokenId);
668         require(to != owner, "ERC721: approval to current owner");
669 
670         require(
671             msg.sender == owner || isApprovedForAll(owner, msg.sender),
672             "ERC721: approve caller is not owner nor approved for all"
673         );
674 
675         _approve(to, tokenId);
676     }
677 
678     function getApproved(uint256 tokenId)
679         public
680         view
681         virtual
682         override
683         returns (address)
684     {
685         require(
686             tokenId <= totalSupply,
687             "ERC721: approved query for nonexistent token"
688         );
689 
690         return _tokenApprovals[tokenId];
691     }
692 
693     function setApprovalForAll(address operator, bool approved)
694         public
695         virtual
696         override
697     {
698         _setApprovalForAll(msg.sender, operator, approved);
699     }
700 
701     function isApprovedForAll(address owner, address operator)
702         public
703         view
704         virtual
705         override
706         returns (bool)
707     {
708         return _operatorApprovals[owner][operator];
709     }
710 
711     function _approve(address to, uint256 tokenId) internal virtual {
712         _tokenApprovals[tokenId] = to;
713         emit Approval(ownerOf(tokenId), to, tokenId);
714     }
715 
716     function _setApprovalForAll(
717         address owner,
718         address operator,
719         bool approved
720     ) internal virtual {
721         require(owner != operator, "ERC721: approve to caller");
722         _operatorApprovals[owner][operator] = approved;
723         emit ApprovalForAll(owner, operator, approved);
724     }
725 
726     function setCost(uint256 _cost) external onlyOwner {
727         cost = _cost;
728     }
729 
730     function setLimitPerAddress(uint8 _limit) external onlyOwner {
731         limitPerAddress = _limit;
732     }
733 
734     function startPresale() external onlyOwner {
735         presaleOpen = true;
736         pubsaleOpen = false;
737     }
738 
739     function endPresale() external onlyOwner {
740         presaleOpen = false;
741     }
742 
743     function startPubsale() external onlyOwner {
744         pubsaleOpen = true;
745         presaleOpen = false;
746     }
747 
748     function endPubsale() external onlyOwner {
749         pubsaleOpen = false;
750     }
751 
752     function balanceOf(address owner) public view override returns (uint256) {
753         return _balances[owner];
754     }
755 
756     function ownerOf(uint256 tokenId) public view override returns (address) {
757         if (tokenId >= _currentIndex) {
758             return address(0);
759         }
760 
761         uint256 id = tokenId;
762         while (id > 1 && ownership[id] == address(0)) {
763             id -= 1;
764         }
765         return ownership[id];
766     }
767 
768     function mint(uint256 amount) external payable {
769         require(
770             addressMints[msg.sender] + amount <= limitPerAddress,
771             "ERROR: NFT limit"
772         );
773         require(pubsaleOpen || presaleOpen, "Sale is not open");
774         require(totalSupply + amount <= pubsaleSupply, "Invalid amount");
775 
776         uint _cost = presaleOpen? presaleCost : cost;
777 
778         uint256 totalCost = _cost * amount;
779         require(msg.value >= totalCost, "Insufficient payment");
780 
781         if (msg.value > totalCost) {
782             payable(msg.sender).transfer(msg.value - totalCost);
783         }
784 
785         for (uint256 i = 0; i < amount; i += 1) {
786             emit Transfer(address(0), msg.sender, _currentIndex + i);
787         }
788 
789         ownership[_currentIndex] = msg.sender;
790         _mint(msg.sender, amount);
791 
792         totalSupply += amount;
793     }
794 
795     function premint(uint256 amount, address to) external onlyOwner {
796 
797         for (uint256 i = 0; i < amount; i += 1) {
798             emit Transfer(address(0), to, _currentIndex + i);
799         }
800 
801         ownership[_currentIndex] = to;
802         _mint(to, amount);
803 
804         totalSupply += amount;
805     }
806 
807     function _mint(address to, uint256 amount) internal {
808         _balances[to] += amount;
809         addressMints[to] += amount;
810         _currentIndex += amount;
811     }
812 
813     function transferFrom(
814         address from,
815         address to,
816         uint256 tokenId
817     ) public override {
818         _transfer(from, to, tokenId);
819     }
820 
821     function safeTransferFrom(
822         address from,
823         address to,
824         uint256 tokenId
825     ) public override {
826         safeTransferFrom(from, to, tokenId, "");
827     }
828 
829     function safeTransferFrom(
830         address from,
831         address to,
832         uint256 tokenId,
833         bytes memory _data
834     ) public override {
835         _transfer(from, to, tokenId);
836 
837         if (!_checkOnERC721Received(from, to, tokenId, _data)) {
838             revert TransferToNonERC721ReceiverImplementer();
839         }
840     }
841 
842     function _transfer(
843         address from,
844         address to,
845         uint256 tokenId
846     ) internal {
847         address preOwner = ownerOf(tokenId);
848 
849         require(from != to, "You cannot transfer to yourself");
850         require(from == preOwner, "Invalid from address");
851         require(
852             msg.sender == preOwner ||
853                 isApprovedForAll(preOwner, msg.sender) ||
854                 getApproved(tokenId) == msg.sender,
855             "Access denied"
856         );
857 
858         _approve(address(0), tokenId);
859 
860         ownership[tokenId] = to;
861 
862         uint256 nextId = tokenId + 1;
863 
864         if (ownership[nextId] == address(0) && nextId < _currentIndex) {
865             ownership[nextId] = preOwner;
866         }
867 
868         _balances[preOwner] -= 1;
869         _balances[to] += 1;
870 
871         emit Transfer(from, to, tokenId);
872     }
873 
874     function tokenURI(uint256 tokenId) public view returns (string memory) {
875         require(
876             tokenId <= totalSupply,
877             "ERC721Metadata: URI query for nonexistent token"
878         );
879 
880         if (revealed == false) {
881             return norevealedURI;
882         }
883 
884         string memory currentBaseURI = baseURI;
885         return
886             bytes(currentBaseURI).length > 0
887                 ? string(
888                     abi.encodePacked(
889                         currentBaseURI,
890                         tokenId.toString(),
891                         baseExtension
892                     )
893                 )
894                 : "";
895     }
896 
897     function setBaseURI(string memory _baseURI) external onlyOwner {
898         baseURI = _baseURI;
899     }
900 
901     function setUnrevealedURI(string memory _uri) external onlyOwner {
902         norevealedURI = _uri;
903     }
904 
905     function setBaseExtension(string memory _ext) external onlyOwner {
906         baseExtension = _ext;
907     }
908 
909     function setPubsaleSupply(uint16 _amount) external onlyOwner {
910         pubsaleSupply = _amount;
911     }
912 
913     function reveal() external onlyOwner {
914         revealed = true;
915     }
916 
917     function supportsInterface(bytes4 interfaceId)
918         public
919         view
920         virtual
921         override(IERC165)
922         returns (bool)
923     {
924         return
925             interfaceId == type(IERC721).interfaceId ||
926             interfaceId == type(IERC721Metadata).interfaceId ||
927             interfaceId == type(IERC165).interfaceId;
928     }
929 
930     function _checkOnERC721Received(
931         address from,
932         address to,
933         uint256 tokenId,
934         bytes memory _data
935     ) private returns (bool) {
936         if (to.isContract()) {
937             try
938                 IERC721Receiver(to).onERC721Received(
939                     msg.sender,
940                     from,
941                     tokenId,
942                     _data
943                 )
944             returns (bytes4 retval) {
945                 return retval == IERC721Receiver(to).onERC721Received.selector;
946             } catch (bytes memory reason) {
947                 if (reason.length == 0) {
948                     revert TransferToNonERC721ReceiverImplementer();
949                 } else {
950                     assembly {
951                         revert(add(32, reason), mload(reason))
952                     }
953                 }
954             }
955         } else {
956             return true;
957         }
958     }
959 
960     function withdraw(address payable to) external onlyOwner {
961         Address.sendValue(to, address(this).balance);
962     }
963 
964     function recoverToken(address token, address to) external onlyOwner {
965         IERC20(token).transfer(to, IERC20(token).balanceOf(address(this)));
966     }
967 }