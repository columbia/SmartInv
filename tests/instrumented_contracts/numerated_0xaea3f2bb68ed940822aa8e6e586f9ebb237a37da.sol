1 /**
2  *Submitted for verification at Etherscan.io on 2021-08-21
3 */
4 
5 // SPDX-License-Identifier: MIT
6 pragma solidity 0.8.4;
7 
8 //Interfaces
9 
10 interface IAccessControl {
11     function hasRole(bytes32 role, address account) external view returns (bool);
12 
13     function getRoleAdmin(bytes32 role) external view returns (bytes32);
14 
15     function grantRole(bytes32 role, address account) external;
16 
17     function revokeRole(bytes32 role, address account) external;
18 
19     function renounceRole(bytes32 role, address account) external;
20 }
21 
22 interface IERC165 {
23     /**
24      * @dev Returns true if this contract implements the interface defined by
25      * `interfaceId`. See the corresponding
26      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
27      * to learn more about how these ids are created.
28      *
29      * This function call must use less than 30 000 gas.
30      */
31     function supportsInterface(bytes4 interfaceId) external view returns (bool);
32 }
33 
34 interface IERC721 is IERC165 {
35     /**
36      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
37      */
38     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
39 
40     /**
41      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
42      */
43     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
44 
45     /**
46      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
47      */
48     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
49 
50     /**
51      * @dev Returns the number of tokens in ``owner``'s account.
52      */
53     function balanceOf(address owner) external view returns (uint256 balance);
54 
55     /**
56      * @dev Returns the owner of the `tokenId` token.
57      *
58      * Requirements:
59      *
60      * - `tokenId` must exist.
61      */
62     function ownerOf(uint256 tokenId) external view returns (address owner);
63 
64     /**
65      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
66      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
67      *
68      * Requirements:
69      *
70      * - `from` cannot be the zero address.
71      * - `to` cannot be the zero address.
72      * - `tokenId` token must exist and be owned by `from`.
73      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
74      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
75      *
76      * Emits a {Transfer} event.
77      */
78     function safeTransferFrom(
79         address from,
80         address to,
81         uint256 tokenId
82     ) external;
83 
84     /**
85      * @dev Transfers `tokenId` token from `from` to `to`.
86      *
87      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
88      *
89      * Requirements:
90      *
91      * - `from` cannot be the zero address.
92      * - `to` cannot be the zero address.
93      * - `tokenId` token must be owned by `from`.
94      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
95      *
96      * Emits a {Transfer} event.
97      */
98     function transferFrom(
99         address from,
100         address to,
101         uint256 tokenId
102     ) external;
103 
104     /**
105      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
106      * The approval is cleared when the token is transferred.
107      *
108      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
109      *
110      * Requirements:
111      *
112      * - The caller must own the token or be an approved operator.
113      * - `tokenId` must exist.
114      *
115      * Emits an {Approval} event.
116      */
117     function approve(address to, uint256 tokenId) external;
118 
119     /**
120      * @dev Returns the account approved for `tokenId` token.
121      *
122      * Requirements:
123      *
124      * - `tokenId` must exist.
125      */
126     function getApproved(uint256 tokenId) external view returns (address operator);
127 
128     /**
129      * @dev Approve or remove `operator` as an operator for the caller.
130      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
131      *
132      * Requirements:
133      *
134      * - The `operator` cannot be the caller.
135      *
136      * Emits an {ApprovalForAll} event.
137      */
138     function setApprovalForAll(address operator, bool _approved) external;
139 
140     /**
141      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
142      *
143      * See {setApprovalForAll}
144      */
145     function isApprovedForAll(address owner, address operator) external view returns (bool);
146 
147     /**
148      * @dev Safely transfers `tokenId` token from `from` to `to`.
149      *
150      * Requirements:
151      *
152      * - `from` cannot be the zero address.
153      * - `to` cannot be the zero address.
154      * - `tokenId` token must exist and be owned by `from`.
155      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
156      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
157      *
158      * Emits a {Transfer} event.
159      */
160     function safeTransferFrom(
161         address from,
162         address to,
163         uint256 tokenId,
164         bytes calldata data
165     ) external;
166 }
167 
168 interface IERC721Receiver {
169     /**
170      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
171      * by `operator` from `from`, this function is called.
172      *
173      * It must return its Solidity selector to confirm the token transfer.
174      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
175      *
176      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
177      */
178     function onERC721Received(
179         address operator,
180         address from,
181         uint256 tokenId,
182         bytes calldata data
183     ) external returns (bytes4);
184 }
185 
186 interface IERC721Metadata is IERC721 {
187     /**
188      * @dev Returns the token collection name.
189      */
190     function name() external view returns (string memory);
191 
192     /**
193      * @dev Returns the token collection symbol.
194      */
195     function symbol() external view returns (string memory);
196 
197     /**
198      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
199      */
200     function tokenURI(uint256 tokenId) external view returns (string memory);
201 }
202 
203 interface IERC721Enumerable is IERC721 {
204     /**
205      * @dev Returns the total amount of tokens stored by the contract.
206      */
207     function totalSupply() external view returns (uint256);
208 
209     /**
210      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
211      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
212      */
213     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
214 
215     /**
216      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
217      * Use along with {totalSupply} to enumerate all tokens.
218      */
219     function tokenByIndex(uint256 index) external view returns (uint256);
220 }
221 
222 //libraries
223 
224 library Address {
225     /**
226      * @dev Returns true if `account` is a contract.
227      *
228      * [IMPORTANT]
229      * ====
230      * It is unsafe to assume that an address for which this function returns
231      * false is an externally-owned account (EOA) and not a contract.
232      *
233      * Among others, `isContract` will return false for the following
234      * types of addresses:
235      *
236      *  - an externally-owned account
237      *  - a contract in construction
238      *  - an address where a contract will be created
239      *  - an address where a contract lived, but was destroyed
240      * ====
241      */
242     function isContract(address account) internal view returns (bool) {
243         // This method relies on extcodesize, which returns 0 for contracts in
244         // construction, since the code is only stored at the end of the
245         // constructor execution.
246 
247         uint256 size;
248         assembly {
249             size := extcodesize(account)
250         }
251         return size > 0;
252     }
253 
254     /**
255      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
256      * `recipient`, forwarding all available gas and reverting on errors.
257      *
258      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
259      * of certain opcodes, possibly making contracts go over the 2300 gas limit
260      * imposed by `transfer`, making them unable to receive funds via
261      * `transfer`. {sendValue} removes this limitation.
262      *
263      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
264      *
265      * IMPORTANT: because control is transferred to `recipient`, care must be
266      * taken to not create reentrancy vulnerabilities. Consider using
267      * {ReentrancyGuard} or the
268      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
269      */
270     function sendValue(address payable recipient, uint256 amount) internal {
271         require(address(this).balance >= amount, "Address: insufficient balance");
272 
273         (bool success, ) = recipient.call{value: amount}("");
274         require(success, "Address: unable to send value, recipient may have reverted");
275     }
276 
277     /**
278      * @dev Performs a Solidity function call using a low level `call`. A
279      * plain `call` is an unsafe replacement for a function call: use this
280      * function instead.
281      *
282      * If `target` reverts with a revert reason, it is bubbled up by this
283      * function (like regular Solidity function calls).
284      *
285      * Returns the raw returned data. To convert to the expected return value,
286      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
287      *
288      * Requirements:
289      *
290      * - `target` must be a contract.
291      * - calling `target` with `data` must not revert.
292      *
293      * _Available since v3.1._
294      */
295     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
296         return functionCall(target, data, "Address: low-level call failed");
297     }
298 
299     /**
300      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
301      * `errorMessage` as a fallback revert reason when `target` reverts.
302      *
303      * _Available since v3.1._
304      */
305     function functionCall(
306         address target,
307         bytes memory data,
308         string memory errorMessage
309     ) internal returns (bytes memory) {
310         return functionCallWithValue(target, data, 0, errorMessage);
311     }
312 
313     /**
314      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
315      * but also transferring `value` wei to `target`.
316      *
317      * Requirements:
318      *
319      * - the calling contract must have an ETH balance of at least `value`.
320      * - the called Solidity function must be `payable`.
321      *
322      * _Available since v3.1._
323      */
324     function functionCallWithValue(
325         address target,
326         bytes memory data,
327         uint256 value
328     ) internal returns (bytes memory) {
329         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
330     }
331 
332     /**
333      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
334      * with `errorMessage` as a fallback revert reason when `target` reverts.
335      *
336      * _Available since v3.1._
337      */
338     function functionCallWithValue(
339         address target,
340         bytes memory data,
341         uint256 value,
342         string memory errorMessage
343     ) internal returns (bytes memory) {
344         require(address(this).balance >= value, "Address: insufficient balance for call");
345         require(isContract(target), "Address: call to non-contract");
346 
347         (bool success, bytes memory returndata) = target.call{value: value}(data);
348         return _verifyCallResult(success, returndata, errorMessage);
349     }
350 
351     /**
352      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
353      * but performing a static call.
354      *
355      * _Available since v3.3._
356      */
357     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
358         return functionStaticCall(target, data, "Address: low-level static call failed");
359     }
360 
361     /**
362      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
363      * but performing a static call.
364      *
365      * _Available since v3.3._
366      */
367     function functionStaticCall(
368         address target,
369         bytes memory data,
370         string memory errorMessage
371     ) internal view returns (bytes memory) {
372         require(isContract(target), "Address: static call to non-contract");
373 
374         (bool success, bytes memory returndata) = target.staticcall(data);
375         return _verifyCallResult(success, returndata, errorMessage);
376     }
377 
378     /**
379      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
380      * but performing a delegate call.
381      *
382      * _Available since v3.4._
383      */
384     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
385         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
386     }
387 
388     /**
389      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
390      * but performing a delegate call.
391      *
392      * _Available since v3.4._
393      */
394     function functionDelegateCall(
395         address target,
396         bytes memory data,
397         string memory errorMessage
398     ) internal returns (bytes memory) {
399         require(isContract(target), "Address: delegate call to non-contract");
400 
401         (bool success, bytes memory returndata) = target.delegatecall(data);
402         return _verifyCallResult(success, returndata, errorMessage);
403     }
404 
405     function _verifyCallResult(
406         bool success,
407         bytes memory returndata,
408         string memory errorMessage
409     ) private pure returns (bytes memory) {
410         if (success) {
411             return returndata;
412         } else {
413             // Look for revert reason and bubble it up if present
414             if (returndata.length > 0) {
415                 // The easiest way to bubble the revert reason is using memory via assembly
416 
417                 assembly {
418                     let returndata_size := mload(returndata)
419                     revert(add(32, returndata), returndata_size)
420                 }
421             } else {
422                 revert(errorMessage);
423             }
424         }
425     }
426 }
427 
428 library Math {
429     /**
430      * @dev Returns the largest of two numbers.
431      */
432     function max(uint256 a, uint256 b) internal pure returns (uint256) {
433         return a >= b ? a : b;
434     }
435 
436     /**
437      * @dev Returns the smallest of two numbers.
438      */
439     function min(uint256 a, uint256 b) internal pure returns (uint256) {
440         return a < b ? a : b;
441     }
442 
443     /**
444      * @dev Returns the average of two numbers. The result is rounded towards
445      * zero.
446      */
447     function average(uint256 a, uint256 b) internal pure returns (uint256) {
448         // (a + b) / 2 can overflow, so we distribute.
449         return (a / 2) + (b / 2) + (((a % 2) + (b % 2)) / 2);
450     }
451 
452     /**
453      * @dev Returns the ceiling of the division of two numbers.
454      *
455      * This differs from standard division with `/` in that it rounds up instead
456      * of rounding down.
457      */
458     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
459         // (a + b - 1) / b can overflow on addition, so we distribute.
460         return a / b + (a % b == 0 ? 0 : 1);
461     }
462 }
463 
464 library Counters {
465     struct Counter {
466         // This variable should never be directly accessed by users of the library: interactions must be restricted to
467         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
468         // this feature: see https://github.com/ethereum/solidity/issues/4637
469         uint256 _value; // default: 0
470     }
471 
472     function current(Counter storage counter) internal view returns (uint256) {
473         return counter._value;
474     }
475 
476     function increment(Counter storage counter) internal {
477         unchecked {
478             counter._value += 1;
479         }
480     }
481 
482     function decrement(Counter storage counter) internal {
483         uint256 value = counter._value;
484         require(value > 0, "Counter: decrement overflow");
485         unchecked {
486             counter._value = value - 1;
487         }
488     }
489 
490     function reset(Counter storage counter) internal {
491         counter._value = 0;
492     }
493 }
494 
495 library Strings {
496     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
497 
498     /**
499      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
500      */
501     function toString(uint256 value) internal pure returns (string memory) {
502         // Inspired by OraclizeAPI's implementation - MIT licence
503         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
504 
505         if (value == 0) {
506             return "0";
507         }
508         uint256 temp = value;
509         uint256 digits;
510         while (temp != 0) {
511             digits++;
512             temp /= 10;
513         }
514         bytes memory buffer = new bytes(digits);
515         while (value != 0) {
516             digits -= 1;
517             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
518             value /= 10;
519         }
520         return string(buffer);
521     }
522 
523     /**
524      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
525      */
526     function toHexString(uint256 value) internal pure returns (string memory) {
527         if (value == 0) {
528             return "0x00";
529         }
530         uint256 temp = value;
531         uint256 length = 0;
532         while (temp != 0) {
533             length++;
534             temp >>= 8;
535         }
536         return toHexString(value, length);
537     }
538 
539     /**
540      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
541      */
542     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
543         bytes memory buffer = new bytes(2 * length + 2);
544         buffer[0] = "0";
545         buffer[1] = "x";
546         for (uint256 i = 2 * length + 1; i > 1; --i) {
547             buffer[i] = _HEX_SYMBOLS[value & 0xf];
548             value >>= 4;
549         }
550         require(value == 0, "Strings: hex length insufficient");
551         return string(buffer);
552     }
553 }
554 
555 //contracts
556 
557 abstract contract Context {
558     function _msgSender() internal view virtual returns (address) {
559         return msg.sender;
560     }
561 
562     function _msgData() internal view virtual returns (bytes calldata) {
563         return msg.data;
564     }
565 }
566 
567 abstract contract ERC165 is IERC165 {
568     /**
569      * @dev See {IERC165-supportsInterface}.
570      */
571     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
572         return interfaceId == type(IERC165).interfaceId;
573     }
574 }
575 
576 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
577     using Address for address;
578     using Strings for uint256;
579 
580     // Token name
581     string private _name;
582 
583     // Token symbol
584     string private _symbol;
585 
586     // Mapping from token ID to owner address
587     mapping(uint256 => address) private _owners;
588 
589     // Mapping owner address to token count
590     mapping(address => uint256) private _balances;
591 
592     // Mapping from token ID to approved address
593     mapping(uint256 => address) private _tokenApprovals;
594 
595     // Mapping from owner to operator approvals
596     mapping(address => mapping(address => bool)) private _operatorApprovals;
597 
598     /**
599      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
600      */
601     constructor(string memory name_, string memory symbol_) {
602         _name = name_;
603         _symbol = symbol_;
604     }
605 
606     /**
607      * @dev See {IERC165-supportsInterface}.
608      */
609     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
610         return
611             interfaceId == type(IERC721).interfaceId ||
612             interfaceId == type(IERC721Metadata).interfaceId ||
613             super.supportsInterface(interfaceId);
614     }
615 
616     /**
617      * @dev See {IERC721-balanceOf}.
618      */
619     function balanceOf(address owner) public view virtual override returns (uint256) {
620         require(owner != address(0), "ERC721: balance query for the zero address");
621         return _balances[owner];
622     }
623 
624     /**
625      * @dev See {IERC721-ownerOf}.
626      */
627     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
628         address owner = _owners[tokenId];
629         require(owner != address(0), "ERC721: owner query for nonexistent token");
630         return owner;
631     }
632 
633     /**
634      * @dev See {IERC721Metadata-name}.
635      */
636     function name() public view virtual override returns (string memory) {
637         return _name;
638     }
639 
640     /**
641      * @dev See {IERC721Metadata-symbol}.
642      */
643     function symbol() public view virtual override returns (string memory) {
644         return _symbol;
645     }
646 
647     /**
648      * @dev See {IERC721Metadata-tokenURI}.
649      */
650     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
651         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
652 
653         string memory baseURI = _baseURI();
654         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
655     }
656 
657     /**
658      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
659      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
660      * by default, can be overriden in child contracts.
661      */
662     function _baseURI() internal view virtual returns (string memory) {
663         return "";
664     }
665 
666     /**
667      * @dev See {IERC721-approve}.
668      */
669     function approve(address to, uint256 tokenId) public virtual override {
670         address owner = ERC721.ownerOf(tokenId);
671         require(to != owner, "ERC721: approval to current owner");
672 
673         require(
674             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
675             "ERC721: approve caller is not owner nor approved for all"
676         );
677 
678         _approve(to, tokenId);
679     }
680 
681     /**
682      * @dev See {IERC721-getApproved}.
683      */
684     function getApproved(uint256 tokenId) public view virtual override returns (address) {
685         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
686 
687         return _tokenApprovals[tokenId];
688     }
689 
690     /**
691      * @dev See {IERC721-setApprovalForAll}.
692      */
693     function setApprovalForAll(address operator, bool approved) public virtual override {
694         require(operator != _msgSender(), "ERC721: approve to caller");
695 
696         _operatorApprovals[_msgSender()][operator] = approved;
697         emit ApprovalForAll(_msgSender(), operator, approved);
698     }
699 
700     /**
701      * @dev See {IERC721-isApprovedForAll}.
702      */
703     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
704         return _operatorApprovals[owner][operator];
705     }
706 
707     /**
708      * @dev See {IERC721-transferFrom}.
709      */
710     function transferFrom(
711         address from,
712         address to,
713         uint256 tokenId
714     ) public virtual override {
715         //solhint-disable-next-line max-line-length
716         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
717 
718         _transfer(from, to, tokenId);
719     }
720 
721     /**
722      * @dev See {IERC721-safeTransferFrom}.
723      */
724     function safeTransferFrom(
725         address from,
726         address to,
727         uint256 tokenId
728     ) public virtual override {
729         safeTransferFrom(from, to, tokenId, "");
730     }
731 
732     /**
733      * @dev See {IERC721-safeTransferFrom}.
734      */
735     function safeTransferFrom(
736         address from,
737         address to,
738         uint256 tokenId,
739         bytes memory _data
740     ) public virtual override {
741         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
742         _safeTransfer(from, to, tokenId, _data);
743     }
744 
745     /**
746      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
747      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
748      *
749      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
750      *
751      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
752      * implement alternative mechanisms to perform token transfer, such as signature-based.
753      *
754      * Requirements:
755      *
756      * - `from` cannot be the zero address.
757      * - `to` cannot be the zero address.
758      * - `tokenId` token must exist and be owned by `from`.
759      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
760      *
761      * Emits a {Transfer} event.
762      */
763     function _safeTransfer(
764         address from,
765         address to,
766         uint256 tokenId,
767         bytes memory _data
768     ) internal virtual {
769         _transfer(from, to, tokenId);
770         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
771     }
772 
773     /**
774      * @dev Returns whether `tokenId` exists.
775      *
776      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
777      *
778      * Tokens start existing when they are minted (`_mint`),
779      * and stop existing when they are burned (`_burn`).
780      */
781     function _exists(uint256 tokenId) internal view virtual returns (bool) {
782         return _owners[tokenId] != address(0);
783     }
784 
785     /**
786      * @dev Returns whether `spender` is allowed to manage `tokenId`.
787      *
788      * Requirements:
789      *
790      * - `tokenId` must exist.
791      */
792     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
793         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
794         address owner = ERC721.ownerOf(tokenId);
795         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
796     }
797 
798     /**
799      * @dev Safely mints `tokenId` and transfers it to `to`.
800      *
801      * Requirements:
802      *
803      * - `tokenId` must not exist.
804      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
805      *
806      * Emits a {Transfer} event.
807      */
808     function _safeMint(address to, uint256 tokenId) internal virtual {
809         _safeMint(to, tokenId, "");
810     }
811 
812     /**
813      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
814      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
815      */
816     function _safeMint(
817         address to,
818         uint256 tokenId,
819         bytes memory _data
820     ) internal virtual {
821         _mint(to, tokenId);
822         require(
823             _checkOnERC721Received(address(0), to, tokenId, _data),
824             "ERC721: transfer to non ERC721Receiver implementer"
825         );
826     }
827 
828     /**
829      * @dev Mints `tokenId` and transfers it to `to`.
830      *
831      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
832      *
833      * Requirements:
834      *
835      * - `tokenId` must not exist.
836      * - `to` cannot be the zero address.
837      *
838      * Emits a {Transfer} event.
839      */
840     function _mint(address to, uint256 tokenId) internal virtual {
841         require(to != address(0), "ERC721: mint to the zero address");
842         require(!_exists(tokenId), "ERC721: token already minted");
843 
844         _beforeTokenTransfer(address(0), to, tokenId);
845 
846         _balances[to] += 1;
847         _owners[tokenId] = to;
848 
849         emit Transfer(address(0), to, tokenId);
850     }
851 
852     /**
853      * @dev Destroys `tokenId`.
854      * The approval is cleared when the token is burned.
855      *
856      * Requirements:
857      *
858      * - `tokenId` must exist.
859      *
860      * Emits a {Transfer} event.
861      */
862     function _burn(uint256 tokenId) internal virtual {
863         address owner = ERC721.ownerOf(tokenId);
864 
865         _beforeTokenTransfer(owner, address(0), tokenId);
866 
867         // Clear approvals
868         _approve(address(0), tokenId);
869 
870         _balances[owner] -= 1;
871         delete _owners[tokenId];
872 
873         emit Transfer(owner, address(0), tokenId);
874     }
875 
876     /**
877      * @dev Transfers `tokenId` from `from` to `to`.
878      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
879      *
880      * Requirements:
881      *
882      * - `to` cannot be the zero address.
883      * - `tokenId` token must be owned by `from`.
884      *
885      * Emits a {Transfer} event.
886      */
887     function _transfer(
888         address from,
889         address to,
890         uint256 tokenId
891     ) internal virtual {
892         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
893         require(to != address(0), "ERC721: transfer to the zero address");
894 
895         _beforeTokenTransfer(from, to, tokenId);
896 
897         // Clear approvals from the previous owner
898         _approve(address(0), tokenId);
899 
900         _balances[from] -= 1;
901         _balances[to] += 1;
902         _owners[tokenId] = to;
903 
904         emit Transfer(from, to, tokenId);
905     }
906 
907     /**
908      * @dev Approve `to` to operate on `tokenId`
909      *
910      * Emits a {Approval} event.
911      */
912     function _approve(address to, uint256 tokenId) internal virtual {
913         _tokenApprovals[tokenId] = to;
914         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
915     }
916 
917     /**
918      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
919      * The call is not executed if the target address is not a contract.
920      *
921      * @param from address representing the previous owner of the given token ID
922      * @param to target address that will receive the tokens
923      * @param tokenId uint256 ID of the token to be transferred
924      * @param _data bytes optional data to send along with the call
925      * @return bool whether the call correctly returned the expected magic value
926      */
927     function _checkOnERC721Received(
928         address from,
929         address to,
930         uint256 tokenId,
931         bytes memory _data
932     ) private returns (bool) {
933         if (to.isContract()) {
934             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
935                 return retval == IERC721Receiver(to).onERC721Received.selector;
936             } catch (bytes memory reason) {
937                 if (reason.length == 0) {
938                     revert("ERC721: transfer to non ERC721Receiver implementer");
939                 } else {
940                     assembly {
941                         revert(add(32, reason), mload(reason))
942                     }
943                 }
944             }
945         } else {
946             return true;
947         }
948     }
949 
950     /**
951      * @dev Hook that is called before any token transfer. This includes minting
952      * and burning.
953      *
954      * Calling conditions:
955      *
956      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
957      * transferred to `to`.
958      * - When `from` is zero, `tokenId` will be minted for `to`.
959      * - When `to` is zero, ``from``'s `tokenId` will be burned.
960      * - `from` and `to` are never both zero.
961      *
962      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
963      */
964     function _beforeTokenTransfer(
965         address from,
966         address to,
967         uint256 tokenId
968     ) internal virtual {}
969 }
970 
971 abstract contract ERC721Burnable is Context, ERC721 {
972     /**
973      * @dev Burns `tokenId`. See {ERC721-_burn}.
974      *
975      * Requirements:
976      *
977      * - The caller must own `tokenId` or be an approved operator.
978      */
979     function burn(uint256 tokenId) public virtual {
980         //solhint-disable-next-line max-line-length
981         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721Burnable: caller is not owner nor approved");
982         _burn(tokenId);
983     }
984 }
985 
986 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
987     // Mapping from owner to list of owned token IDs
988     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
989 
990     // Mapping from token ID to index of the owner tokens list
991     mapping(uint256 => uint256) private _ownedTokensIndex;
992 
993     // Array with all token ids, used for enumeration
994     uint256[] private _allTokens;
995 
996     // Mapping from token id to position in the allTokens array
997     mapping(uint256 => uint256) private _allTokensIndex;
998 
999     /**
1000      * @dev See {IERC165-supportsInterface}.
1001      */
1002     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1003         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1004     }
1005 
1006     /**
1007      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1008      */
1009     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1010         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1011         return _ownedTokens[owner][index];
1012     }
1013 
1014     /**
1015      * @dev See {IERC721Enumerable-totalSupply}.
1016      */
1017     function totalSupply() public view virtual override returns (uint256) {
1018         return _allTokens.length;
1019     }
1020 
1021     /**
1022      * @dev See {IERC721Enumerable-tokenByIndex}.
1023      */
1024     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1025         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1026         return _allTokens[index];
1027     }
1028 
1029     /**
1030      * @dev Hook that is called before any token transfer. This includes minting
1031      * and burning.
1032      *
1033      * Calling conditions:
1034      *
1035      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1036      * transferred to `to`.
1037      * - When `from` is zero, `tokenId` will be minted for `to`.
1038      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1039      * - `from` cannot be the zero address.
1040      * - `to` cannot be the zero address.
1041      *
1042      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1043      */
1044     function _beforeTokenTransfer(
1045         address from,
1046         address to,
1047         uint256 tokenId
1048     ) internal virtual override {
1049         super._beforeTokenTransfer(from, to, tokenId);
1050 
1051         if (from == address(0)) {
1052             _addTokenToAllTokensEnumeration(tokenId);
1053         } else if (from != to) {
1054             _removeTokenFromOwnerEnumeration(from, tokenId);
1055         }
1056         if (to == address(0)) {
1057             _removeTokenFromAllTokensEnumeration(tokenId);
1058         } else if (to != from) {
1059             _addTokenToOwnerEnumeration(to, tokenId);
1060         }
1061     }
1062 
1063     /**
1064      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1065      * @param to address representing the new owner of the given token ID
1066      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1067      */
1068     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1069         uint256 length = ERC721.balanceOf(to);
1070         _ownedTokens[to][length] = tokenId;
1071         _ownedTokensIndex[tokenId] = length;
1072     }
1073 
1074     /**
1075      * @dev Private function to add a token to this extension's token tracking data structures.
1076      * @param tokenId uint256 ID of the token to be added to the tokens list
1077      */
1078     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1079         _allTokensIndex[tokenId] = _allTokens.length;
1080         _allTokens.push(tokenId);
1081     }
1082 
1083     /**
1084      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1085      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1086      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1087      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1088      * @param from address representing the previous owner of the given token ID
1089      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1090      */
1091     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1092         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1093         // then delete the last slot (swap and pop).
1094 
1095         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1096         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1097 
1098         // When the token to delete is the last token, the swap operation is unnecessary
1099         if (tokenIndex != lastTokenIndex) {
1100             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1101 
1102             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1103             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1104         }
1105 
1106         // This also deletes the contents at the last position of the array
1107         delete _ownedTokensIndex[tokenId];
1108         delete _ownedTokens[from][lastTokenIndex];
1109     }
1110 
1111     /**
1112      * @dev Private function to remove a token from this extension's token tracking data structures.
1113      * This has O(1) time complexity, but alters the order of the _allTokens array.
1114      * @param tokenId uint256 ID of the token to be removed from the tokens list
1115      */
1116     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1117         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1118         // then delete the last slot (swap and pop).
1119 
1120         uint256 lastTokenIndex = _allTokens.length - 1;
1121         uint256 tokenIndex = _allTokensIndex[tokenId];
1122 
1123         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1124         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1125         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1126         uint256 lastTokenId = _allTokens[lastTokenIndex];
1127 
1128         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1129         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1130 
1131         // This also deletes the contents at the last position of the array
1132         delete _allTokensIndex[tokenId];
1133         _allTokens.pop();
1134     }
1135 }
1136 
1137 abstract contract AccessControl is Context, IAccessControl, ERC165 {
1138     struct RoleData {
1139         mapping(address => bool) members;
1140         bytes32 adminRole;
1141     }
1142 
1143     mapping(bytes32 => RoleData) private _roles;
1144 
1145     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1146 
1147     /**
1148      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
1149      *
1150      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
1151      * {RoleAdminChanged} not being emitted signaling this.
1152      *
1153      * _Available since v3.1._
1154      */
1155     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
1156 
1157     /**
1158      * @dev Emitted when `account` is granted `role`.
1159      *
1160      * `sender` is the account that originated the contract call, an admin role
1161      * bearer except when using {_setupRole}.
1162      */
1163     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
1164 
1165     /**
1166      * @dev Emitted when `account` is revoked `role`.
1167      *
1168      * `sender` is the account that originated the contract call:
1169      *   - if using `revokeRole`, it is the admin role bearer
1170      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
1171      */
1172     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
1173 
1174     /**
1175      * @dev Modifier that checks that an account has a specific role. Reverts
1176      * with a standardized message including the required role.
1177      *
1178      * The format of the revert reason is given by the following regular expression:
1179      *
1180      *  /^AccessControl: account (0x[0-9a-f]{20}) is missing role (0x[0-9a-f]{32})$/
1181      *
1182      * _Available since v4.1._
1183      */
1184     modifier onlyRole(bytes32 role) {
1185         _checkRole(role, _msgSender());
1186         _;
1187     }
1188 
1189     /**
1190      * @dev See {IERC165-supportsInterface}.
1191      */
1192     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1193         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
1194     }
1195 
1196     /**
1197      * @dev Returns `true` if `account` has been granted `role`.
1198      */
1199     function hasRole(bytes32 role, address account) public view override returns (bool) {
1200         return _roles[role].members[account];
1201     }
1202 
1203     /**
1204      * @dev Revert with a standard message if `account` is missing `role`.
1205      *
1206      * The format of the revert reason is given by the following regular expression:
1207      *
1208      *  /^AccessControl: account (0x[0-9a-f]{20}) is missing role (0x[0-9a-f]{32})$/
1209      */
1210     function _checkRole(bytes32 role, address account) internal view {
1211         if (!hasRole(role, account)) {
1212             revert(
1213                 string(
1214                     abi.encodePacked(
1215                         "AccessControl: account ",
1216                         Strings.toHexString(uint160(account), 20),
1217                         " is missing role ",
1218                         Strings.toHexString(uint256(role), 32)
1219                     )
1220                 )
1221             );
1222         }
1223     }
1224 
1225     /**
1226      * @dev Returns the admin role that controls `role`. See {grantRole} and
1227      * {revokeRole}.
1228      *
1229      * To change a role's admin, use {_setRoleAdmin}.
1230      */
1231     function getRoleAdmin(bytes32 role) public view override returns (bytes32) {
1232         return _roles[role].adminRole;
1233     }
1234 
1235     /**
1236      * @dev Grants `role` to `account`.
1237      *
1238      * If `account` had not been already granted `role`, emits a {RoleGranted}
1239      * event.
1240      *
1241      * Requirements:
1242      *
1243      * - the caller must have ``role``'s admin role.
1244      */
1245     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1246         _grantRole(role, account);
1247     }
1248 
1249     /**
1250      * @dev Revokes `role` from `account`.
1251      *
1252      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1253      *
1254      * Requirements:
1255      *
1256      * - the caller must have ``role``'s admin role.
1257      */
1258     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1259         _revokeRole(role, account);
1260     }
1261 
1262     /**
1263      * @dev Revokes `role` from the calling account.
1264      *
1265      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1266      * purpose is to provide a mechanism for accounts to lose their privileges
1267      * if they are compromised (such as when a trusted device is misplaced).
1268      *
1269      * If the calling account had been granted `role`, emits a {RoleRevoked}
1270      * event.
1271      *
1272      * Requirements:
1273      *
1274      * - the caller must be `account`.
1275      */
1276     function renounceRole(bytes32 role, address account) public virtual override {
1277         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1278 
1279         _revokeRole(role, account);
1280     }
1281 
1282     /**
1283      * @dev Grants `role` to `account`.
1284      *
1285      * If `account` had not been already granted `role`, emits a {RoleGranted}
1286      * event. Note that unlike {grantRole}, this function doesn't perform any
1287      * checks on the calling account.
1288      *
1289      * [WARNING]
1290      * ====
1291      * This function should only be called from the constructor when setting
1292      * up the initial roles for the system.
1293      *
1294      * Using this function in any other way is effectively circumventing the admin
1295      * system imposed by {AccessControl}.
1296      * ====
1297      */
1298     function _setupRole(bytes32 role, address account) internal virtual {
1299         _grantRole(role, account);
1300     }
1301 
1302     /**
1303      * @dev Sets `adminRole` as ``role``'s admin role.
1304      *
1305      * Emits a {RoleAdminChanged} event.
1306      */
1307     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1308         emit RoleAdminChanged(role, getRoleAdmin(role), adminRole);
1309         _roles[role].adminRole = adminRole;
1310     }
1311 
1312     function _grantRole(bytes32 role, address account) private {
1313         if (!hasRole(role, account)) {
1314             _roles[role].members[account] = true;
1315             emit RoleGranted(role, account, _msgSender());
1316         }
1317     }
1318 
1319     function _revokeRole(bytes32 role, address account) private {
1320         if (hasRole(role, account)) {
1321             _roles[role].members[account] = false;
1322             emit RoleRevoked(role, account, _msgSender());
1323         }
1324     }
1325 }
1326 
1327 abstract contract Ownable is Context {
1328     address private _owner;
1329 
1330     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1331 
1332     /**
1333      * @dev Initializes the contract setting the deployer as the initial owner.
1334      */
1335     constructor() {
1336         _setOwner(_msgSender());
1337     }
1338 
1339     /**
1340      * @dev Returns the address of the current owner.
1341      */
1342     function owner() public view virtual returns (address) {
1343         return _owner;
1344     }
1345 
1346     /**
1347      * @dev Throws if called by any account other than the owner.
1348      */
1349     modifier onlyOwner() {
1350         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1351         _;
1352     }
1353 
1354     /**
1355      * @dev Leaves the contract without owner. It will not be possible to call
1356      * `onlyOwner` functions anymore. Can only be called by the current owner.
1357      *
1358      * NOTE: Renouncing ownership will leave the contract without an owner,
1359      * thereby removing any functionality that is only available to the owner.
1360      */
1361     function renounceOwnership() public virtual onlyOwner {
1362         _setOwner(address(0));
1363     }
1364 
1365     /**
1366      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1367      * Can only be called by the current owner.
1368      */
1369     function transferOwnership(address newOwner) public virtual onlyOwner {
1370         require(newOwner != address(0), "Ownable: new owner is the zero address");
1371         _setOwner(newOwner);
1372     }
1373 
1374     function _setOwner(address newOwner) private {
1375         address oldOwner = _owner;
1376         _owner = newOwner;
1377         emit OwnershipTransferred(oldOwner, newOwner);
1378     }
1379 }
1380 
1381 abstract contract Pausable is Context {
1382     /**
1383      * @dev Emitted when the pause is triggered by `account`.
1384      */
1385     event Paused(address account);
1386 
1387     /**
1388      * @dev Emitted when the pause is lifted by `account`.
1389      */
1390     event Unpaused(address account);
1391 
1392     bool private _paused;
1393 
1394     /**
1395      * @dev Initializes the contract in unpaused state.
1396      */
1397     constructor () {
1398         _paused = false;
1399     }
1400 
1401     /**
1402      * @dev Returns true if the contract is paused, and false otherwise.
1403      */
1404     function paused() public view virtual returns (bool) {
1405         return _paused;
1406     }
1407 
1408     /**
1409      * @dev Modifier to make a function callable only when the contract is not paused.
1410      *
1411      * Requirements:
1412      *
1413      * - The contract must not be paused.
1414      */
1415     modifier whenNotPaused() {
1416         require(!paused(), "Pausable: paused");
1417         _;
1418     }
1419 
1420     /**
1421      * @dev Modifier to make a function callable only when the contract is paused.
1422      *
1423      * Requirements:
1424      *
1425      * - The contract must be paused.
1426      */
1427     modifier whenPaused() {
1428         require(paused(), "Pausable: not paused");
1429         _;
1430     }
1431 
1432     /**
1433      * @dev Triggers stopped state.
1434      *
1435      * Requirements:
1436      *
1437      * - The contract must not be paused.
1438      */
1439     function _pause() internal virtual whenNotPaused {
1440         _paused = true;
1441         emit Paused(_msgSender());
1442     }
1443 
1444     /**
1445      * @dev Returns to normal state.
1446      *
1447      * Requirements:
1448      *
1449      * - The contract must be paused.
1450      */
1451     function _unpause() internal virtual whenPaused {
1452         _paused = false;
1453         emit Unpaused(_msgSender());
1454     }
1455 }
1456 
1457 abstract contract ReentrancyGuard {
1458     // Booleans are more expensive than uint256 or any type that takes up a full
1459     // word because each write operation emits an extra SLOAD to first read the
1460     // slot's contents, replace the bits taken up by the boolean, and then write
1461     // back. This is the compiler's defense against contract upgrades and
1462     // pointer aliasing, and it cannot be disabled.
1463 
1464     // The values being non-zero value makes deployment a bit more expensive,
1465     // but in exchange the refund on every call to nonReentrant will be lower in
1466     // amount. Since refunds are capped to a percentage of the total
1467     // transaction's gas, it is best to keep them low in cases like this one, to
1468     // increase the likelihood of the full refund coming into effect.
1469     uint256 private constant _NOT_ENTERED = 1;
1470     uint256 private constant _ENTERED = 2;
1471 
1472     uint256 private _status;
1473 
1474     constructor () {
1475         _status = _NOT_ENTERED;
1476     }
1477 
1478     /**
1479      * @dev Prevents a contract from calling itself, directly or indirectly.
1480      * Calling a `nonReentrant` function from another `nonReentrant`
1481      * function is not supported. It is possible to prevent this from happening
1482      * by making the `nonReentrant` function external, and make it call a
1483      * `private` function that does the actual work.
1484      */
1485     modifier nonReentrant() {
1486         // On the first call to nonReentrant, _notEntered will be true
1487         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1488 
1489         // Any calls to nonReentrant after this point will fail
1490         _status = _ENTERED;
1491 
1492         _;
1493 
1494         // By storing the original value once again, a refund is triggered (see
1495         // https://eips.ethereum.org/EIPS/eip-2200)
1496         _status = _NOT_ENTERED;
1497     }
1498 }
1499 
1500 //Token
1501 
1502 contract Rithm is ERC721Enumerable, ERC721Burnable, Ownable, AccessControl {
1503     
1504     using Counters for Counters.Counter;
1505 
1506     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
1507     bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
1508 
1509     Counters.Counter private _tokenIdTracker;
1510 
1511     uint256 private maxMint;
1512     string private baseTokenURI;
1513 
1514     constructor(
1515         string memory _uri,
1516         string memory _contractName,
1517         string memory _tokenSymbol,
1518         uint256 _maxMint
1519     ) ERC721(_contractName, _tokenSymbol) {
1520         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
1521 
1522         maxMint = _maxMint;
1523         baseTokenURI = _uri;
1524     }
1525 
1526     function mint(address to) public {
1527         require(hasRole(MINTER_ROLE, _msgSender()), "Must have minter role to mint");
1528         require(_tokenIdTracker.current() < maxMint, "Max mint reached");
1529 
1530         _mint(to, _tokenIdTracker.current());
1531 
1532         _tokenIdTracker.increment();
1533     }
1534 
1535     function canMint(uint256 quantity) external view returns (bool) {
1536         return (_tokenIdTracker.current() + quantity) <= maxMint;
1537     }
1538 
1539     function _baseURI() internal view override returns (string memory) {
1540         return baseTokenURI;
1541     }
1542 
1543     function setBaseURI(string calldata uri) public onlyOwner() {
1544         baseTokenURI = uri;
1545     }
1546 
1547     function _beforeTokenTransfer(
1548         address from,
1549         address to,
1550         uint256 tokenId
1551     ) internal virtual override(ERC721, ERC721Enumerable) {
1552         super._beforeTokenTransfer(from, to, tokenId);
1553     }
1554 
1555     function supportsInterface(bytes4 interfaceId)
1556         public
1557         view
1558         virtual
1559         override(AccessControl, ERC721, ERC721Enumerable)
1560         returns (bool)
1561     {
1562         return super.supportsInterface(interfaceId);
1563     }
1564 }
1565 
1566 contract RithmDrop is Ownable, Pausable, ReentrancyGuard {
1567     
1568     Rithm private token;
1569 
1570     address private wallet;
1571     uint256 private price;
1572     uint8 private saleState;
1573     mapping(address => bool) public whitelist; 
1574     uint256 constant MAX_MINT_PER_ORDER = 1;
1575     uint256 constant public_sale_start = 1632016800; 
1576 
1577     constructor(
1578         Rithm _token,
1579         uint256 _price
1580     ) Ownable() {
1581         token = _token;
1582         price = _price;
1583 
1584         _pause();
1585     }
1586 
1587     function mint(uint256 quantity) external payable whenNotPaused() nonReentrant() {
1588         require(msg.value >= price * quantity, "RithmDrop: Insufficient value");
1589         require(quantity <= MAX_MINT_PER_ORDER || block.timestamp>=public_sale_start, "RithmDrop: Exceeds order limit");
1590         require(token.canMint(quantity), "RithmDrop: Exceeds total");
1591         require(whitelist[msg.sender] || block.timestamp>=public_sale_start, "Not whitelisted");
1592         whitelist[msg.sender] = false;
1593 
1594         for (uint256 i = 0; i < quantity; i++) {
1595             token.mint(_msgSender());
1596         }
1597     }
1598 
1599     function ownerMint(uint256 quantity) external onlyOwner() {
1600         require(token.canMint(quantity), "RithmDrop: Exceeds total");
1601 
1602         for (uint256 i = 0; i < quantity; i++) {
1603             token.mint(_msgSender());
1604         }
1605     }
1606 
1607     function mintGiveaways(address[] calldata addresses) external onlyOwner() {
1608         require(token.canMint(addresses.length), "RithmDrop: Exceeds total");
1609 
1610         for (uint256 i = 0; i < addresses.length; i++) {
1611             token.mint(addresses[i]);
1612         }
1613     }
1614 
1615     function withdraw(uint256 _amount, address _withdraw_address) external onlyOwner() {
1616         payable(_withdraw_address).transfer(_amount);
1617     }
1618     
1619     function flipAddressWhitelist(address[] calldata addrs) external onlyOwner()  {
1620         for (uint256 i = 0; i < addrs.length; i++) {
1621             whitelist[addrs[i]] = !whitelist[addrs[i]];
1622         }
1623     }
1624     
1625     
1626     function isWhitelisted(address _address) external view returns (bool) {
1627         return whitelist[_address];
1628     }
1629 
1630     function pause() external whenNotPaused() onlyOwner() {
1631         _pause();
1632     }
1633 
1634     function unpause() external whenPaused() onlyOwner() {
1635         _unpause();
1636     }
1637 }