1 // Sources flattened with hardhat v2.6.1 https://hardhat.org
2 
3 // File contracts/utils/Address.sol
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Collection of functions related to the address type
11  */
12 library Address {
13     /**
14      * @dev Returns true if `account` is a contract.
15      *
16      * [IMPORTANT]
17      * ====
18      * It is unsafe to assume that an address for which this function returns
19      * false is an externally-owned account (EOA) and not a contract.
20      *
21      * Among others, `isContract` will return false for the following
22      * types of addresses:
23      *
24      *  - an externally-owned account
25      *  - a contract in construction
26      *  - an address where a contract will be created
27      *  - an address where a contract lived, but was destroyed
28      * ====
29      */
30     function isContract(address account) internal view returns (bool) {
31         // This method relies on extcodesize, which returns 0 for contracts in
32         // construction, since the code is only stored at the end of the
33         // constructor execution.
34 
35         uint256 size;
36         // solhint-disable-next-line no-inline-assembly
37         assembly { size := extcodesize(account) }
38         return size > 0;
39     }
40 
41     /**
42      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
43      * `recipient`, forwarding all available gas and reverting on errors.
44      *
45      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
46      * of certain opcodes, possibly making contracts go over the 2300 gas limit
47      * imposed by `transfer`, making them unable to receive funds via
48      * `transfer`. {sendValue} removes this limitation.
49      *
50      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
51      *
52      * IMPORTANT: because control is transferred to `recipient`, care must be
53      * taken to not create reentrancy vulnerabilities. Consider using
54      * {ReentrancyGuard} or the
55      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
56      */
57     function sendValue(address payable recipient, uint256 amount) internal {
58         require(address(this).balance >= amount, "Address: insufficient balance");
59 
60         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
61         (bool success, ) = recipient.call{ value: amount }("");
62         require(success, "Address: unable to send value, recipient may have reverted");
63     }
64 
65     /**
66      * @dev Performs a Solidity function call using a low level `call`. A
67      * plain`call` is an unsafe replacement for a function call: use this
68      * function instead.
69      *
70      * If `target` reverts with a revert reason, it is bubbled up by this
71      * function (like regular Solidity function calls).
72      *
73      * Returns the raw returned data. To convert to the expected return value,
74      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
75      *
76      * Requirements:
77      *
78      * - `target` must be a contract.
79      * - calling `target` with `data` must not revert.
80      *
81      * _Available since v3.1._
82      */
83     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
84       return functionCall(target, data, "Address: low-level call failed");
85     }
86 
87     /**
88      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
89      * `errorMessage` as a fallback revert reason when `target` reverts.
90      *
91      * _Available since v3.1._
92      */
93     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
94         return functionCallWithValue(target, data, 0, errorMessage);
95     }
96 
97     /**
98      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
99      * but also transferring `value` wei to `target`.
100      *
101      * Requirements:
102      *
103      * - the calling contract must have an ETH balance of at least `value`.
104      * - the called Solidity function must be `payable`.
105      *
106      * _Available since v3.1._
107      */
108     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
109         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
110     }
111 
112     /**
113      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
114      * with `errorMessage` as a fallback revert reason when `target` reverts.
115      *
116      * _Available since v3.1._
117      */
118     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
119         require(address(this).balance >= value, "Address: insufficient balance for call");
120         require(isContract(target), "Address: call to non-contract");
121 
122         // solhint-disable-next-line avoid-low-level-calls
123         (bool success, bytes memory returndata) = target.call{ value: value }(data);
124         return _verifyCallResult(success, returndata, errorMessage);
125     }
126 
127     /**
128      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
129      * but performing a static call.
130      *
131      * _Available since v3.3._
132      */
133     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
134         return functionStaticCall(target, data, "Address: low-level static call failed");
135     }
136 
137     /**
138      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
139      * but performing a static call.
140      *
141      * _Available since v3.3._
142      */
143     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
144         require(isContract(target), "Address: static call to non-contract");
145 
146         // solhint-disable-next-line avoid-low-level-calls
147         (bool success, bytes memory returndata) = target.staticcall(data);
148         return _verifyCallResult(success, returndata, errorMessage);
149     }
150 
151     /**
152      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
153      * but performing a delegate call.
154      *
155      * _Available since v3.4._
156      */
157     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
158         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
159     }
160 
161     /**
162      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
163      * but performing a delegate call.
164      *
165      * _Available since v3.4._
166      */
167     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
168         require(isContract(target), "Address: delegate call to non-contract");
169 
170         // solhint-disable-next-line avoid-low-level-calls
171         (bool success, bytes memory returndata) = target.delegatecall(data);
172         return _verifyCallResult(success, returndata, errorMessage);
173     }
174 
175     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
176         if (success) {
177             return returndata;
178         } else {
179             // Look for revert reason and bubble it up if present
180             if (returndata.length > 0) {
181                 // The easiest way to bubble the revert reason is using memory via assembly
182 
183                 // solhint-disable-next-line no-inline-assembly
184                 assembly {
185                     let returndata_size := mload(returndata)
186                     revert(add(32, returndata), returndata_size)
187                 }
188             } else {
189                 revert(errorMessage);
190             }
191         }
192     }
193 }
194 
195 
196 // File contracts/utils/Context.sol
197 
198 pragma solidity ^0.8.0;
199 
200 /*
201  * @dev Provides information about the current execution context, including the
202  * sender of the transaction and its data. While these are generally available
203  * via msg.sender and msg.data, they should not be accessed in such a direct
204  * manner, since when dealing with meta-transactions the account sending and
205  * paying for execution may not be the actual sender (as far as an application
206  * is concerned).
207  *
208  * This contract is only required for intermediate, library-like contracts.
209  */
210 abstract contract Context {
211     function _msgSender() internal view virtual returns (address) {
212         return msg.sender;
213     }
214 
215     function _msgData() internal view virtual returns (bytes calldata) {
216         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
217         return msg.data;
218     }
219 }
220 
221 
222 // File contracts/utils/Strings.sol
223 
224 pragma solidity ^0.8.0;
225 
226 /**
227  * @dev String operations.
228  */
229 library Strings {
230     bytes16 private constant alphabet = "0123456789abcdef";
231 
232     /**
233      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
234      */
235     function toString(uint256 value) internal pure returns (string memory) {
236         // Inspired by OraclizeAPI's implementation - MIT licence
237         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
238 
239         if (value == 0) {
240             return "0";
241         }
242         uint256 temp = value;
243         uint256 digits;
244         while (temp != 0) {
245             digits++;
246             temp /= 10;
247         }
248         bytes memory buffer = new bytes(digits);
249         while (value != 0) {
250             digits -= 1;
251             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
252             value /= 10;
253         }
254         return string(buffer);
255     }
256 
257     /**
258      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
259      */
260     function toHexString(uint256 value) internal pure returns (string memory) {
261         if (value == 0) {
262             return "0x00";
263         }
264         uint256 temp = value;
265         uint256 length = 0;
266         while (temp != 0) {
267             length++;
268             temp >>= 8;
269         }
270         return toHexString(value, length);
271     }
272 
273     /**
274      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
275      */
276     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
277         bytes memory buffer = new bytes(2 * length + 2);
278         buffer[0] = "0";
279         buffer[1] = "x";
280         for (uint256 i = 2 * length + 1; i > 1; --i) {
281             buffer[i] = alphabet[value & 0xf];
282             value >>= 4;
283         }
284         require(value == 0, "Strings: hex length insufficient");
285         return string(buffer);
286     }
287 
288 }
289 
290 
291 // File contracts/utils/introspection/IERC165.sol
292 
293 pragma solidity ^0.8.0;
294 
295 /**
296  * @dev Interface of the ERC165 standard, as defined in the
297  * https://eips.ethereum.org/EIPS/eip-165[EIP].
298  *
299  * Implementers can declare support of contract interfaces, which can then be
300  * queried by others ({ERC165Checker}).
301  *
302  * For an implementation, see {ERC165}.
303  */
304 interface IERC165 {
305     /**
306      * @dev Returns true if this contract implements the interface defined by
307      * `interfaceId`. See the corresponding
308      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
309      * to learn more about how these ids are created.
310      *
311      * This function call must use less than 30 000 gas.
312      */
313     function supportsInterface(bytes4 interfaceId) external view returns (bool);
314 }
315 
316 
317 // File contracts/tokens/IERC721.sol
318 
319 pragma solidity ^0.8.0;
320 
321 /**
322  * @dev Required interface of an ERC721 compliant contract.
323  */
324 interface IERC721 is IERC165 {
325     /**
326      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
327      */
328     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
329 
330     /**
331      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
332      */
333     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
334 
335     /**
336      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
337      */
338     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
339 
340     /**
341      * @dev Returns the number of tokens in ``owner``'s account.
342      */
343     function balanceOf(address owner) external view returns (uint256 balance);
344 
345     /**
346      * @dev Returns the owner of the `tokenId` token.
347      *
348      * Requirements:
349      *
350      * - `tokenId` must exist.
351      */
352     function ownerOf(uint256 tokenId) external view returns (address owner);
353 
354     /**
355      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
356      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
357      *
358      * Requirements:
359      *
360      * - `from` cannot be the zero address.
361      * - `to` cannot be the zero address.
362      * - `tokenId` token must exist and be owned by `from`.
363      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
364      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
365      *
366      * Emits a {Transfer} event.
367      */
368     function safeTransferFrom(
369         address from,
370         address to,
371         uint256 tokenId
372     ) external;
373 
374     /**
375      * @dev Transfers `tokenId` token from `from` to `to`.
376      *
377      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
378      *
379      * Requirements:
380      *
381      * - `from` cannot be the zero address.
382      * - `to` cannot be the zero address.
383      * - `tokenId` token must be owned by `from`.
384      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
385      *
386      * Emits a {Transfer} event.
387      */
388     function transferFrom(
389         address from,
390         address to,
391         uint256 tokenId
392     ) external;
393 
394     /**
395      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
396      * The approval is cleared when the token is transferred.
397      *
398      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
399      *
400      * Requirements:
401      *
402      * - The caller must own the token or be an approved operator.
403      * - `tokenId` must exist.
404      *
405      * Emits an {Approval} event.
406      */
407     function approve(address to, uint256 tokenId) external;
408 
409     /**
410      * @dev Returns the account approved for `tokenId` token.
411      *
412      * Requirements:
413      *
414      * - `tokenId` must exist.
415      */
416     function getApproved(uint256 tokenId) external view returns (address operator);
417 
418     /**
419      * @dev Approve or remove `operator` as an operator for the caller.
420      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
421      *
422      * Requirements:
423      *
424      * - The `operator` cannot be the caller.
425      *
426      * Emits an {ApprovalForAll} event.
427      */
428     function setApprovalForAll(address operator, bool _approved) external;
429 
430     /**
431      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
432      *
433      * See {setApprovalForAll}
434      */
435     function isApprovedForAll(address owner, address operator) external view returns (bool);
436 
437     /**
438      * @dev Safely transfers `tokenId` token from `from` to `to`.
439      *
440      * Requirements:
441      *
442      * - `from` cannot be the zero address.
443      * - `to` cannot be the zero address.
444      * - `tokenId` token must exist and be owned by `from`.
445      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
446      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
447      *
448      * Emits a {Transfer} event.
449      */
450     function safeTransferFrom(
451         address from,
452         address to,
453         uint256 tokenId,
454         bytes calldata data
455     ) external;
456 }
457 
458 
459 // File contracts/tokens/IERC721Metadata.sol
460 
461 pragma solidity ^0.8.0;
462 
463 /**
464  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
465  * @dev See https://eips.ethereum.org/EIPS/eip-721
466  */
467 interface IERC721Metadata is IERC721 {
468     /**
469      * @dev Returns the token collection name.
470      */
471     function name() external view returns (string memory);
472 
473     /**
474      * @dev Returns the token collection symbol.
475      */
476     function symbol() external view returns (string memory);
477 
478     /**
479      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
480      */
481     function tokenURI(uint256 tokenId) external view returns (string memory);
482 }
483 
484 
485 // File contracts/tokens/IERC721Enumerable.sol
486 
487 pragma solidity ^0.8.0;
488 
489 /**
490  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
491  * @dev See https://eips.ethereum.org/EIPS/eip-721
492  */
493 interface IERC721Enumerable is IERC721 {
494 
495     /**
496      * @dev Returns the total amount of tokens stored by the contract.
497      */
498     function totalSupply() external view returns (uint256);
499 
500     /**
501      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
502      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
503      */
504     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
505 
506     /**
507      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
508      * Use along with {totalSupply} to enumerate all tokens.
509      */
510     function tokenByIndex(uint256 index) external view returns (uint256);
511 }
512 
513 
514 // File contracts/tokens/IERC721Receiver.sol
515 
516 pragma solidity ^0.8.0;
517 
518 /**
519  * @title ERC721 token receiver interface
520  * @dev Interface for any contract that wants to support safeTransfers
521  * from ERC721 asset contracts.
522  */
523 interface IERC721Receiver {
524     /**
525      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
526      * by `operator` from `from`, this function is called.
527      *
528      * It must return its Solidity selector to confirm the token transfer.
529      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
530      *
531      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
532      */
533     function onERC721Received(
534         address operator,
535         address from,
536         uint256 tokenId,
537         bytes calldata data
538     ) external returns (bytes4);
539 }
540 
541 
542 // File contracts/utils/introspection/ERC165.sol
543 
544 pragma solidity ^0.8.0;
545 
546 /**
547  * @dev Implementation of the {IERC165} interface.
548  *
549  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
550  * for the additional interface id that will be supported. For example:
551  *
552  * ```solidity
553  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
554  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
555  * }
556  * ```
557  *
558  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
559  */
560 abstract contract ERC165 is IERC165 {
561     /**
562      * @dev See {IERC165-supportsInterface}.
563      */
564     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
565         return interfaceId == type(IERC165).interfaceId;
566     }
567 }
568 
569 
570 // File contracts/tokens/ERC721Holder.sol
571 
572 pragma solidity ^0.8.0;
573 
574 /**
575  * @dev Implementation of the {IERC721Receiver} interface.
576  *
577  * Accepts all token transfers.
578  * Make sure the contract is able to use its token with {IERC721-safeTransferFrom}, {IERC721-approve} or {IERC721-setApprovalForAll}.
579  */
580 contract ERC721Holder is IERC721Receiver {
581     /**
582      * @dev See {IERC721Receiver-onERC721Received}.
583      *
584      * Always returns `IERC721Receiver.onERC721Received.selector`.
585      */
586     function onERC721Received(
587         address,
588         address,
589         uint256,
590         bytes memory
591     ) public virtual override returns (bytes4) {
592         return this.onERC721Received.selector;
593     }
594 }
595 
596 
597 // File contracts/tokens/ERC721.sol
598 
599 
600 pragma solidity ^0.8.0;
601 
602 
603 /**
604  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
605  * the Metadata extension, but not including the Enumerable extension, which is available separately as
606  * {ERC721Enumerable}.
607  */
608 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, ERC721Holder {
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
1003 
1004 // File contracts/tokens/ERC721Enumerable.sol
1005 
1006 pragma solidity ^0.8.0;
1007 
1008 
1009 /**
1010  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1011  * enumerability of all the token ids in the contract as well as all token ids owned by each
1012  * account.
1013  */
1014 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1015     // Mapping from owner to list of owned token IDs
1016     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1017 
1018     // Mapping from token ID to index of the owner tokens list
1019     mapping(uint256 => uint256) private _ownedTokensIndex;
1020 
1021     // Array with all token ids, used for enumeration
1022     uint256[] private _allTokens;
1023 
1024     // Mapping from token id to position in the allTokens array
1025     mapping(uint256 => uint256) private _allTokensIndex;
1026 
1027     /**
1028      * @dev See {IERC165-supportsInterface}.
1029      */
1030     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1031         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1032     }
1033 
1034     /**
1035      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1036      */
1037     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1038         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1039         return _ownedTokens[owner][index];
1040     }
1041 
1042     /**
1043      * @dev See {IERC721Enumerable-totalSupply}.
1044      */
1045     function totalSupply() public view virtual override returns (uint256) {
1046         return _allTokens.length;
1047     }
1048 
1049     /**
1050      * @dev See {IERC721Enumerable-tokenByIndex}.
1051      */
1052     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1053         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1054         return _allTokens[index];
1055     }
1056 
1057     /**
1058      * @dev Hook that is called before any token transfer. This includes minting
1059      * and burning.
1060      *
1061      * Calling conditions:
1062      *
1063      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1064      * transferred to `to`.
1065      * - When `from` is zero, `tokenId` will be minted for `to`.
1066      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1067      * - `from` cannot be the zero address.
1068      * - `to` cannot be the zero address.
1069      *
1070      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1071      */
1072     function _beforeTokenTransfer(
1073         address from,
1074         address to,
1075         uint256 tokenId
1076     ) internal virtual override {
1077         super._beforeTokenTransfer(from, to, tokenId);
1078 
1079         if (from == address(0)) {
1080             _addTokenToAllTokensEnumeration(tokenId);
1081         } else if (from != to) {
1082             _removeTokenFromOwnerEnumeration(from, tokenId);
1083         }
1084         if (to == address(0)) {
1085             _removeTokenFromAllTokensEnumeration(tokenId);
1086         } else if (to != from) {
1087             _addTokenToOwnerEnumeration(to, tokenId);
1088         }
1089     }
1090 
1091     /**
1092      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1093      * @param to address representing the new owner of the given token ID
1094      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1095      */
1096     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1097         uint256 length = ERC721.balanceOf(to);
1098         _ownedTokens[to][length] = tokenId;
1099         _ownedTokensIndex[tokenId] = length;
1100     }
1101 
1102     /**
1103      * @dev Private function to add a token to this extension's token tracking data structures.
1104      * @param tokenId uint256 ID of the token to be added to the tokens list
1105      */
1106     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1107         _allTokensIndex[tokenId] = _allTokens.length;
1108         _allTokens.push(tokenId);
1109     }
1110 
1111     /**
1112      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1113      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1114      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1115      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1116      * @param from address representing the previous owner of the given token ID
1117      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1118      */
1119     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1120         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1121         // then delete the last slot (swap and pop).
1122 
1123         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1124         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1125 
1126         // When the token to delete is the last token, the swap operation is unnecessary
1127         if (tokenIndex != lastTokenIndex) {
1128             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1129 
1130             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1131             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1132         }
1133 
1134         // This also deletes the contents at the last position of the array
1135         delete _ownedTokensIndex[tokenId];
1136         delete _ownedTokens[from][lastTokenIndex];
1137     }
1138 
1139     /**
1140      * @dev Private function to remove a token from this extension's token tracking data structures.
1141      * This has O(1) time complexity, but alters the order of the _allTokens array.
1142      * @param tokenId uint256 ID of the token to be removed from the tokens list
1143      */
1144     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1145         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1146         // then delete the last slot (swap and pop).
1147 
1148         uint256 lastTokenIndex = _allTokens.length - 1;
1149         uint256 tokenIndex = _allTokensIndex[tokenId];
1150 
1151         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1152         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1153         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1154         uint256 lastTokenId = _allTokens[lastTokenIndex];
1155 
1156         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1157         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1158 
1159         // This also deletes the contents at the last position of the array
1160         delete _allTokensIndex[tokenId];
1161         _allTokens.pop();
1162     }
1163 }
1164 
1165 
1166 // File contracts/tokens/IERC20.sol
1167 
1168 pragma solidity ^0.8.0;
1169 
1170 /**
1171  * @dev Interface of the ERC20 standard as defined in the EIP.
1172  */
1173 interface IERC20 {
1174     /**
1175      * @dev Returns the amount of tokens in existence.
1176      */
1177     function totalSupply() external view returns (uint256);
1178 
1179     /**
1180      * @dev Returns the amount of tokens owned by `account`.
1181      */
1182     function balanceOf(address account) external view returns (uint256);
1183 
1184     /**
1185      * @dev Moves `amount` tokens from the caller's account to `recipient`.
1186      *
1187      * Returns a boolean value indicating whether the operation succeeded.
1188      *
1189      * Emits a {Transfer} event.
1190      */
1191     function transfer(address recipient, uint256 amount) external returns (bool);
1192 
1193     /**
1194      * @dev Returns the remaining number of tokens that `spender` will be
1195      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1196      * zero by default.
1197      *
1198      * This value changes when {approve} or {transferFrom} are called.
1199      */
1200     function allowance(address owner, address spender) external view returns (uint256);
1201 
1202     /**
1203      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1204      *
1205      * Returns a boolean value indicating whether the operation succeeded.
1206      *
1207      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1208      * that someone may use both the old and the new allowance by unfortunate
1209      * transaction ordering. One possible solution to mitigate this race
1210      * condition is to first reduce the spender's allowance to 0 and set the
1211      * desired value afterwards:
1212      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1213      *
1214      * Emits an {Approval} event.
1215      */
1216     function approve(address spender, uint256 amount) external returns (bool);
1217 
1218     /**
1219      * @dev Moves `amount` tokens from `sender` to `recipient` using the
1220      * allowance mechanism. `amount` is then deducted from the caller's
1221      * allowance.
1222      *
1223      * Returns a boolean value indicating whether the operation succeeded.
1224      *
1225      * Emits a {Transfer} event.
1226      */
1227     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
1228 
1229     /**
1230      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1231      * another (`to`).
1232      *
1233      * Note that `value` may be zero.
1234      */
1235     event Transfer(address indexed from, address indexed to, uint256 value);
1236 
1237     /**
1238      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1239      * a call to {approve}. `value` is the new allowance.
1240      */
1241     event Approval(address indexed owner, address indexed spender, uint256 value);
1242 }
1243 
1244 
1245 // File contracts/utils/Ownable.sol
1246 
1247 pragma solidity ^0.8.0;
1248 
1249 /**
1250  * @dev Contract module which provides a basic access control mechanism, where
1251  * there is an account (an owner) that can be granted exclusive access to
1252  * specific functions.
1253  *
1254  * By default, the owner account will be the one that deploys the contract. This
1255  * can later be changed with {transferOwnership}.
1256  *
1257  * This module is used through inheritance. It will make available the modifier
1258  * `onlyOwner`, which can be applied to your functions to restrict their use to
1259  * the owner.
1260  */
1261 abstract contract Ownable is Context {
1262     address private _owner;
1263 
1264     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1265 
1266     /**
1267      * @dev Initializes the contract setting the deployer as the initial owner.
1268      */
1269     constructor() {
1270         address msgSender = _msgSender();
1271         _owner = msgSender;
1272         emit OwnershipTransferred(address(0), msgSender);
1273     }
1274 
1275     /**
1276      * @dev Returns the address of the current owner.
1277      */
1278     function owner() public view virtual returns (address) {
1279         return _owner;
1280     }
1281 
1282     /**
1283      * @dev Throws if called by any account other than the owner.
1284      */
1285     modifier onlyOwner() {
1286         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1287         _;
1288     }
1289 
1290     /**
1291      * @dev Leaves the contract without owner. It will not be possible to call
1292      * `onlyOwner` functions anymore. Can only be called by the current owner.
1293      *
1294      * NOTE: Renouncing ownership will leave the contract without an owner,
1295      * thereby removing any functionality that is only available to the owner.
1296      */
1297     function renounceOwnership() public virtual onlyOwner {
1298         emit OwnershipTransferred(_owner, address(0));
1299         _owner = address(0);
1300     }
1301 
1302     /**
1303      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1304      * Can only be called by the current owner.
1305      */
1306     function transferOwnership(address newOwner) public virtual onlyOwner {
1307         require(newOwner != address(0), "Ownable: new owner is the zero address");
1308         emit OwnershipTransferred(_owner, newOwner);
1309         _owner = newOwner;
1310     }
1311 }
1312 
1313 
1314 // File contracts/uwucrew.sol
1315 
1316 pragma solidity ^0.8.0;
1317 
1318 /*
1319                   &(,    @%(,.                   @%(,.    &(*                   
1320      (%/,        @%(/,   @((*,       @#(*.       @%((,,  @%(/*        &#*,      
1321      @#(*.       @%(/*   @%((..     @&(((,.     @&((/*   @%(*.       @&(/,      
1322       @#(/.,, *&&#(//     @&(((///((((((((((//(((((((     @%(/.,, .&&#((//      
1323        @@%(((((((#%%         @@&%#%%&&   @@&%#%%&&&        @@&((((((((#%        
1324             %@(                                                 ,@@             
1325                      (/          ,       #(.     ,     .    ,                   
1326                  /&(%@@@%/   @((&@&   @##  @/,  &&,. @&*.  @(/                  
1327                  @%.         @**      @//%&&#    /&,/(#%&,#(/                   
1328                   @&(/(##(   @/*       @#*(##(    .@#/  @@((                    
1329                                                                                 
1330                                                               
1331                              ,@     .(                                          
1332                          & ,@@#  (@@@@ ,( ,.       %#                           
1333                            @  ,,.@,                   @,                        
1334                        @  .,/                             @                     
1335                      (  .             @                 ,    #                  
1336                    @,  .   *         %                    @    %                
1337                  ,,,@     @              ,                 &    ,               
1338                 *,,,     .        @   , .    @              %   ,,@             
1339                 %,,&    ,/  #     ,@. , .    (@         &   @   *,,@            
1340                *,,,,    ,,  @     *.@  ...   @.#, &     /   *  ,,,,,            
1341               @,,,,,@   ,@@       @.../, &   *...@,* @  @  @, .,&,,,@           
1342               *,/.,,,&  ,@*& ((    .....,*(   *...#@ @ @, %&, ,,@,,,@           
1343               ,,@,@ ,,.@ ,@  @  @  @......@.@.%,.@.@@,@@@@,,,,,@,,,,@           
1344               ,,&,,,  .,@(. &(  @  @@.........#&@#  *   @@#,,,@,,,,,*           
1345              .,,/,,,  ,.#   (#&%(. ............ ##(##@  .%,(,@*@,,,,            
1346              .,,,,,,. @,,..@,%(#@ ............. ((# #  (@,,,,,%@.%,#            
1347              *,..#,.,%..,,,.........................,,,,,,,@,,@.@&,@            
1348              #,,@@, .,@%.............................,,,,..,,,*..*,@            
1349              @,,&&,  .(@..................................@, ..@,,,*            
1350              @,,#(.   /#@.............,/,..................  @,,,,,.            
1351             @@ @#(    &##@......./////&@@@&////@.........@   %,,,,,             
1352            ##, ###(.  &###@.......@/@/****(@////........@&   ,,,,@,/            
1353           @*# &###@.  @#####@........@******@.........@%# &  ,@,,/,,@           
1354          @,#@ ####&   @&#####%(/.................../###@@.  &,#@,,%*,*          
1355         %,##@ #####,  #&########@,@.............@######@/*  @(#@,,*@*,,&        
1356        ,,/#.# @###&%   (########@,,,,,,#@@@,,,,&#######@    @###(,,@ #,,/       
1357      @,,,#  .*  ##(&,   %###@##@@,,,,,,,,,,,,,,&&@@####%..  %####,,,@  &, *     
1358     @,,,&  # ,,@ .##@*   @&&&&&&,,,,,,,,,,,,,,,@@&&&&&&  ,% @#####,, @     @    
1359    ,,,,@  @  ,,*#(@ @(,@  .&&&@,,,,,,,,,,,,,,,,,@&&&&&&  , (@&&&&&@*  @   * ,   
1360  @,,,,   @*@&&&&&&&&.,@,,,&  @,,,,,,,,,,,...,,@&&&&&&&@@ (, @@ &@ @&@  @    &, 
1361 */
1362 
1363 
1364 
1365 interface SaleContract { 
1366   function loadSale(uint256 saleCount, uint256 swapCount, uint256 lpCount) external;
1367 }
1368 
1369 contract uwucrew is Ownable, ERC721Enumerable {
1370   address public saleContract;
1371   address public extraContract;
1372 
1373   uint256 public immutable MAX_UWU;
1374   
1375   string public UWU_PROVENANCE = "";
1376   string public baseURI;
1377 
1378   mapping(uint256 => uint256) public lastTransferTimestamp;
1379   mapping(address => uint256) private pastCumulativeHODL;
1380 
1381   constructor(string memory _name, string memory _symbol, uint256 maxSupply) Ownable() ERC721(_name, _symbol) {
1382     MAX_UWU = maxSupply;
1383   }
1384 
1385   function mint(address to, uint256 tokenId) public virtual {
1386     require(msg.sender == saleContract || msg.sender == extraContract, "Nice try lol");
1387     _safeMint(to, tokenId);
1388   }
1389 
1390   function prepareSale(address _saleContract) public onlyOwner {
1391     require(saleContract == address(0));
1392     saleContract = _saleContract;
1393   }
1394 
1395   // Extra contract for helping BSC users bridge over.
1396   function setExtraContract(address _extraContract) public onlyOwner {
1397     require(extraContract == address(0));
1398     extraContract = _extraContract;
1399   }
1400 
1401   function renounceMinting() public onlyOwner {
1402     saleContract = address(0);
1403     extraContract = address(0);
1404   }
1405 
1406   /**
1407     * uwu for the team.
1408     */
1409   function reserveUWUS() public onlyOwner {        
1410     uint supply = totalSupply();
1411     for (uint256 i = 0; i < 50; i++) {
1412       _safeMint(msg.sender, supply + i);
1413     }
1414   }
1415 
1416   /*     
1417   * Set provenance once it's calculated
1418   */
1419   function setProvenanceHash(string memory provenanceHash) public onlyOwner {
1420     UWU_PROVENANCE = provenanceHash;
1421   }
1422 
1423   function setBaseURI(string memory newURI) public onlyOwner {
1424     baseURI = newURI;
1425   }
1426 
1427   function _safeMint(address to, uint256 tokenId) internal virtual override {
1428     // Ensure no matter what that someone cannot mint > supply.
1429     require(tokenId < MAX_UWU, "Max supply");
1430     super._safeMint(to, tokenId);
1431   }
1432 
1433   function _baseURI() internal view virtual override returns (string memory) {
1434     return baseURI;
1435   }
1436 
1437   function _beforeTokenTransfer(
1438       address from,
1439       address to,
1440       uint256 tokenId
1441   ) internal virtual override {
1442     super._beforeTokenTransfer(from, to, tokenId);
1443 
1444     uint256 timeHodld = block.timestamp - lastTransferTimestamp[tokenId];
1445     if (from != address(0)) {
1446       pastCumulativeHODL[from] += timeHodld;
1447     }
1448     lastTransferTimestamp[tokenId] = block.timestamp;
1449   }
1450 
1451   function cumulativeHODL(address user) public view returns (uint256) {
1452     uint256 _cumulativeHODL = pastCumulativeHODL[user];
1453     uint256 bal = balanceOf(user);
1454     for (uint256 i = 0; i < bal; i++) {
1455       uint256 tokenId = tokenOfOwnerByIndex(user, i);
1456       uint256 timeHodld = block.timestamp - lastTransferTimestamp[tokenId];
1457       _cumulativeHODL += timeHodld;
1458     }
1459     return _cumulativeHODL;
1460   }
1461 }