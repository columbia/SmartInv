1 // Sources flattened with hardhat v2.6.0 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.2.0
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Interface of the ERC165 standard, as defined in the
11  * https://eips.ethereum.org/EIPS/eip-165[EIP].
12  *
13  * Implementers can declare support of contract interfaces, which can then be
14  * queried by others ({ERC165Checker}).
15  *
16  * For an implementation, see {ERC165}.
17  */
18 interface IERC165 {
19     /**
20      * @dev Returns true if this contract implements the interface defined by
21      * `interfaceId`. See the corresponding
22      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
23      * to learn more about how these ids are created.
24      *
25      * This function call must use less than 30 000 gas.
26      */
27     function supportsInterface(bytes4 interfaceId) external view returns (bool);
28 }
29 
30 
31 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.2.0
32 
33 
34 pragma solidity ^0.8.0;
35 
36 /**
37  * @dev Required interface of an ERC721 compliant contract.
38  */
39 interface IERC721 is IERC165 {
40     /**
41      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
42      */
43     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
44 
45     /**
46      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
47      */
48     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
49 
50     /**
51      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
52      */
53     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
54 
55     /**
56      * @dev Returns the number of tokens in ``owner``'s account.
57      */
58     function balanceOf(address owner) external view returns (uint256 balance);
59 
60     /**
61      * @dev Returns the owner of the `tokenId` token.
62      *
63      * Requirements:
64      *
65      * - `tokenId` must exist.
66      */
67     function ownerOf(uint256 tokenId) external view returns (address owner);
68 
69     /**
70      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
71      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
72      *
73      * Requirements:
74      *
75      * - `from` cannot be the zero address.
76      * - `to` cannot be the zero address.
77      * - `tokenId` token must exist and be owned by `from`.
78      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
79      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
80      *
81      * Emits a {Transfer} event.
82      */
83     function safeTransferFrom(
84         address from,
85         address to,
86         uint256 tokenId
87     ) external;
88 
89     /**
90      * @dev Transfers `tokenId` token from `from` to `to`.
91      *
92      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
93      *
94      * Requirements:
95      *
96      * - `from` cannot be the zero address.
97      * - `to` cannot be the zero address.
98      * - `tokenId` token must be owned by `from`.
99      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
100      *
101      * Emits a {Transfer} event.
102      */
103     function transferFrom(
104         address from,
105         address to,
106         uint256 tokenId
107     ) external;
108 
109     /**
110      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
111      * The approval is cleared when the token is transferred.
112      *
113      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
114      *
115      * Requirements:
116      *
117      * - The caller must own the token or be an approved operator.
118      * - `tokenId` must exist.
119      *
120      * Emits an {Approval} event.
121      */
122     function approve(address to, uint256 tokenId) external;
123 
124     /**
125      * @dev Returns the account approved for `tokenId` token.
126      *
127      * Requirements:
128      *
129      * - `tokenId` must exist.
130      */
131     function getApproved(uint256 tokenId) external view returns (address operator);
132 
133     /**
134      * @dev Approve or remove `operator` as an operator for the caller.
135      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
136      *
137      * Requirements:
138      *
139      * - The `operator` cannot be the caller.
140      *
141      * Emits an {ApprovalForAll} event.
142      */
143     function setApprovalForAll(address operator, bool _approved) external;
144 
145     /**
146      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
147      *
148      * See {setApprovalForAll}
149      */
150     function isApprovedForAll(address owner, address operator) external view returns (bool);
151 
152     /**
153      * @dev Safely transfers `tokenId` token from `from` to `to`.
154      *
155      * Requirements:
156      *
157      * - `from` cannot be the zero address.
158      * - `to` cannot be the zero address.
159      * - `tokenId` token must exist and be owned by `from`.
160      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
161      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
162      *
163      * Emits a {Transfer} event.
164      */
165     function safeTransferFrom(
166         address from,
167         address to,
168         uint256 tokenId,
169         bytes calldata data
170     ) external;
171 }
172 
173 
174 // File contracts/nodes/IMCCNode.sol
175 
176 pragma solidity ^0.8.4;
177 
178 interface IMCCNode is IERC721 {
179   function mainToken() external view returns (address);
180 
181   function stableToken() external view returns (address);
182 
183   function tokenMintedAt(uint256 tokenId) external view returns (uint256);
184 
185   function tokenLastTransferredAt(uint256 tokenId)
186     external
187     view
188     returns (uint256);
189 
190   function pricePaidUSD18(uint256 tokenId) external view returns (uint256);
191 
192   function tokenPerDayReturn(uint256 tokenId) external view returns (uint256);
193 
194   function mint(uint256[] memory tierId, uint256[] memory amount)
195     external
196     payable;
197 }
198 
199 
200 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.2.0
201 
202 
203 pragma solidity ^0.8.0;
204 
205 /**
206  * @dev Interface of the ERC20 standard as defined in the EIP.
207  */
208 interface IERC20 {
209     /**
210      * @dev Returns the amount of tokens in existence.
211      */
212     function totalSupply() external view returns (uint256);
213 
214     /**
215      * @dev Returns the amount of tokens owned by `account`.
216      */
217     function balanceOf(address account) external view returns (uint256);
218 
219     /**
220      * @dev Moves `amount` tokens from the caller's account to `recipient`.
221      *
222      * Returns a boolean value indicating whether the operation succeeded.
223      *
224      * Emits a {Transfer} event.
225      */
226     function transfer(address recipient, uint256 amount) external returns (bool);
227 
228     /**
229      * @dev Returns the remaining number of tokens that `spender` will be
230      * allowed to spend on behalf of `owner` through {transferFrom}. This is
231      * zero by default.
232      *
233      * This value changes when {approve} or {transferFrom} are called.
234      */
235     function allowance(address owner, address spender) external view returns (uint256);
236 
237     /**
238      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
239      *
240      * Returns a boolean value indicating whether the operation succeeded.
241      *
242      * IMPORTANT: Beware that changing an allowance with this method brings the risk
243      * that someone may use both the old and the new allowance by unfortunate
244      * transaction ordering. One possible solution to mitigate this race
245      * condition is to first reduce the spender's allowance to 0 and set the
246      * desired value afterwards:
247      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
248      *
249      * Emits an {Approval} event.
250      */
251     function approve(address spender, uint256 amount) external returns (bool);
252 
253     /**
254      * @dev Moves `amount` tokens from `sender` to `recipient` using the
255      * allowance mechanism. `amount` is then deducted from the caller's
256      * allowance.
257      *
258      * Returns a boolean value indicating whether the operation succeeded.
259      *
260      * Emits a {Transfer} event.
261      */
262     function transferFrom(
263         address sender,
264         address recipient,
265         uint256 amount
266     ) external returns (bool);
267 
268     /**
269      * @dev Emitted when `value` tokens are moved from one account (`from`) to
270      * another (`to`).
271      *
272      * Note that `value` may be zero.
273      */
274     event Transfer(address indexed from, address indexed to, uint256 value);
275 
276     /**
277      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
278      * a call to {approve}. `value` is the new allowance.
279      */
280     event Approval(address indexed owner, address indexed spender, uint256 value);
281 }
282 
283 
284 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.2.0
285 
286 
287 pragma solidity ^0.8.0;
288 
289 /**
290  * @title ERC721 token receiver interface
291  * @dev Interface for any contract that wants to support safeTransfers
292  * from ERC721 asset contracts.
293  */
294 interface IERC721Receiver {
295     /**
296      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
297      * by `operator` from `from`, this function is called.
298      *
299      * It must return its Solidity selector to confirm the token transfer.
300      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
301      *
302      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
303      */
304     function onERC721Received(
305         address operator,
306         address from,
307         uint256 tokenId,
308         bytes calldata data
309     ) external returns (bytes4);
310 }
311 
312 
313 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.2.0
314 
315 
316 pragma solidity ^0.8.0;
317 
318 /**
319  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
320  * @dev See https://eips.ethereum.org/EIPS/eip-721
321  */
322 interface IERC721Metadata is IERC721 {
323     /**
324      * @dev Returns the token collection name.
325      */
326     function name() external view returns (string memory);
327 
328     /**
329      * @dev Returns the token collection symbol.
330      */
331     function symbol() external view returns (string memory);
332 
333     /**
334      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
335      */
336     function tokenURI(uint256 tokenId) external view returns (string memory);
337 }
338 
339 
340 // File @openzeppelin/contracts/utils/Address.sol@v4.2.0
341 
342 
343 pragma solidity ^0.8.0;
344 
345 /**
346  * @dev Collection of functions related to the address type
347  */
348 library Address {
349     /**
350      * @dev Returns true if `account` is a contract.
351      *
352      * [IMPORTANT]
353      * ====
354      * It is unsafe to assume that an address for which this function returns
355      * false is an externally-owned account (EOA) and not a contract.
356      *
357      * Among others, `isContract` will return false for the following
358      * types of addresses:
359      *
360      *  - an externally-owned account
361      *  - a contract in construction
362      *  - an address where a contract will be created
363      *  - an address where a contract lived, but was destroyed
364      * ====
365      */
366     function isContract(address account) internal view returns (bool) {
367         // This method relies on extcodesize, which returns 0 for contracts in
368         // construction, since the code is only stored at the end of the
369         // constructor execution.
370 
371         uint256 size;
372         assembly {
373             size := extcodesize(account)
374         }
375         return size > 0;
376     }
377 
378     /**
379      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
380      * `recipient`, forwarding all available gas and reverting on errors.
381      *
382      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
383      * of certain opcodes, possibly making contracts go over the 2300 gas limit
384      * imposed by `transfer`, making them unable to receive funds via
385      * `transfer`. {sendValue} removes this limitation.
386      *
387      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
388      *
389      * IMPORTANT: because control is transferred to `recipient`, care must be
390      * taken to not create reentrancy vulnerabilities. Consider using
391      * {ReentrancyGuard} or the
392      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
393      */
394     function sendValue(address payable recipient, uint256 amount) internal {
395         require(address(this).balance >= amount, "Address: insufficient balance");
396 
397         (bool success, ) = recipient.call{value: amount}("");
398         require(success, "Address: unable to send value, recipient may have reverted");
399     }
400 
401     /**
402      * @dev Performs a Solidity function call using a low level `call`. A
403      * plain `call` is an unsafe replacement for a function call: use this
404      * function instead.
405      *
406      * If `target` reverts with a revert reason, it is bubbled up by this
407      * function (like regular Solidity function calls).
408      *
409      * Returns the raw returned data. To convert to the expected return value,
410      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
411      *
412      * Requirements:
413      *
414      * - `target` must be a contract.
415      * - calling `target` with `data` must not revert.
416      *
417      * _Available since v3.1._
418      */
419     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
420         return functionCall(target, data, "Address: low-level call failed");
421     }
422 
423     /**
424      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
425      * `errorMessage` as a fallback revert reason when `target` reverts.
426      *
427      * _Available since v3.1._
428      */
429     function functionCall(
430         address target,
431         bytes memory data,
432         string memory errorMessage
433     ) internal returns (bytes memory) {
434         return functionCallWithValue(target, data, 0, errorMessage);
435     }
436 
437     /**
438      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
439      * but also transferring `value` wei to `target`.
440      *
441      * Requirements:
442      *
443      * - the calling contract must have an ETH balance of at least `value`.
444      * - the called Solidity function must be `payable`.
445      *
446      * _Available since v3.1._
447      */
448     function functionCallWithValue(
449         address target,
450         bytes memory data,
451         uint256 value
452     ) internal returns (bytes memory) {
453         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
454     }
455 
456     /**
457      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
458      * with `errorMessage` as a fallback revert reason when `target` reverts.
459      *
460      * _Available since v3.1._
461      */
462     function functionCallWithValue(
463         address target,
464         bytes memory data,
465         uint256 value,
466         string memory errorMessage
467     ) internal returns (bytes memory) {
468         require(address(this).balance >= value, "Address: insufficient balance for call");
469         require(isContract(target), "Address: call to non-contract");
470 
471         (bool success, bytes memory returndata) = target.call{value: value}(data);
472         return _verifyCallResult(success, returndata, errorMessage);
473     }
474 
475     /**
476      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
477      * but performing a static call.
478      *
479      * _Available since v3.3._
480      */
481     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
482         return functionStaticCall(target, data, "Address: low-level static call failed");
483     }
484 
485     /**
486      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
487      * but performing a static call.
488      *
489      * _Available since v3.3._
490      */
491     function functionStaticCall(
492         address target,
493         bytes memory data,
494         string memory errorMessage
495     ) internal view returns (bytes memory) {
496         require(isContract(target), "Address: static call to non-contract");
497 
498         (bool success, bytes memory returndata) = target.staticcall(data);
499         return _verifyCallResult(success, returndata, errorMessage);
500     }
501 
502     /**
503      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
504      * but performing a delegate call.
505      *
506      * _Available since v3.4._
507      */
508     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
509         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
510     }
511 
512     /**
513      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
514      * but performing a delegate call.
515      *
516      * _Available since v3.4._
517      */
518     function functionDelegateCall(
519         address target,
520         bytes memory data,
521         string memory errorMessage
522     ) internal returns (bytes memory) {
523         require(isContract(target), "Address: delegate call to non-contract");
524 
525         (bool success, bytes memory returndata) = target.delegatecall(data);
526         return _verifyCallResult(success, returndata, errorMessage);
527     }
528 
529     function _verifyCallResult(
530         bool success,
531         bytes memory returndata,
532         string memory errorMessage
533     ) private pure returns (bytes memory) {
534         if (success) {
535             return returndata;
536         } else {
537             // Look for revert reason and bubble it up if present
538             if (returndata.length > 0) {
539                 // The easiest way to bubble the revert reason is using memory via assembly
540 
541                 assembly {
542                     let returndata_size := mload(returndata)
543                     revert(add(32, returndata), returndata_size)
544                 }
545             } else {
546                 revert(errorMessage);
547             }
548         }
549     }
550 }
551 
552 
553 // File @openzeppelin/contracts/utils/Context.sol@v4.2.0
554 
555 
556 pragma solidity ^0.8.0;
557 
558 /*
559  * @dev Provides information about the current execution context, including the
560  * sender of the transaction and its data. While these are generally available
561  * via msg.sender and msg.data, they should not be accessed in such a direct
562  * manner, since when dealing with meta-transactions the account sending and
563  * paying for execution may not be the actual sender (as far as an application
564  * is concerned).
565  *
566  * This contract is only required for intermediate, library-like contracts.
567  */
568 abstract contract Context {
569     function _msgSender() internal view virtual returns (address) {
570         return msg.sender;
571     }
572 
573     function _msgData() internal view virtual returns (bytes calldata) {
574         return msg.data;
575     }
576 }
577 
578 
579 // File @openzeppelin/contracts/utils/Strings.sol@v4.2.0
580 
581 
582 pragma solidity ^0.8.0;
583 
584 /**
585  * @dev String operations.
586  */
587 library Strings {
588     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
589 
590     /**
591      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
592      */
593     function toString(uint256 value) internal pure returns (string memory) {
594         // Inspired by OraclizeAPI's implementation - MIT licence
595         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
596 
597         if (value == 0) {
598             return "0";
599         }
600         uint256 temp = value;
601         uint256 digits;
602         while (temp != 0) {
603             digits++;
604             temp /= 10;
605         }
606         bytes memory buffer = new bytes(digits);
607         while (value != 0) {
608             digits -= 1;
609             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
610             value /= 10;
611         }
612         return string(buffer);
613     }
614 
615     /**
616      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
617      */
618     function toHexString(uint256 value) internal pure returns (string memory) {
619         if (value == 0) {
620             return "0x00";
621         }
622         uint256 temp = value;
623         uint256 length = 0;
624         while (temp != 0) {
625             length++;
626             temp >>= 8;
627         }
628         return toHexString(value, length);
629     }
630 
631     /**
632      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
633      */
634     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
635         bytes memory buffer = new bytes(2 * length + 2);
636         buffer[0] = "0";
637         buffer[1] = "x";
638         for (uint256 i = 2 * length + 1; i > 1; --i) {
639             buffer[i] = _HEX_SYMBOLS[value & 0xf];
640             value >>= 4;
641         }
642         require(value == 0, "Strings: hex length insufficient");
643         return string(buffer);
644     }
645 }
646 
647 
648 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.2.0
649 
650 
651 pragma solidity ^0.8.0;
652 
653 /**
654  * @dev Implementation of the {IERC165} interface.
655  *
656  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
657  * for the additional interface id that will be supported. For example:
658  *
659  * ```solidity
660  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
661  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
662  * }
663  * ```
664  *
665  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
666  */
667 abstract contract ERC165 is IERC165 {
668     /**
669      * @dev See {IERC165-supportsInterface}.
670      */
671     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
672         return interfaceId == type(IERC165).interfaceId;
673     }
674 }
675 
676 
677 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.2.0
678 
679 
680 pragma solidity ^0.8.0;
681 
682 
683 
684 
685 
686 
687 
688 /**
689  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
690  * the Metadata extension, but not including the Enumerable extension, which is available separately as
691  * {ERC721Enumerable}.
692  */
693 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
694     using Address for address;
695     using Strings for uint256;
696 
697     // Token name
698     string private _name;
699 
700     // Token symbol
701     string private _symbol;
702 
703     // Mapping from token ID to owner address
704     mapping(uint256 => address) private _owners;
705 
706     // Mapping owner address to token count
707     mapping(address => uint256) private _balances;
708 
709     // Mapping from token ID to approved address
710     mapping(uint256 => address) private _tokenApprovals;
711 
712     // Mapping from owner to operator approvals
713     mapping(address => mapping(address => bool)) private _operatorApprovals;
714 
715     /**
716      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
717      */
718     constructor(string memory name_, string memory symbol_) {
719         _name = name_;
720         _symbol = symbol_;
721     }
722 
723     /**
724      * @dev See {IERC165-supportsInterface}.
725      */
726     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
727         return
728             interfaceId == type(IERC721).interfaceId ||
729             interfaceId == type(IERC721Metadata).interfaceId ||
730             super.supportsInterface(interfaceId);
731     }
732 
733     /**
734      * @dev See {IERC721-balanceOf}.
735      */
736     function balanceOf(address owner) public view virtual override returns (uint256) {
737         require(owner != address(0), "ERC721: balance query for the zero address");
738         return _balances[owner];
739     }
740 
741     /**
742      * @dev See {IERC721-ownerOf}.
743      */
744     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
745         address owner = _owners[tokenId];
746         require(owner != address(0), "ERC721: owner query for nonexistent token");
747         return owner;
748     }
749 
750     /**
751      * @dev See {IERC721Metadata-name}.
752      */
753     function name() public view virtual override returns (string memory) {
754         return _name;
755     }
756 
757     /**
758      * @dev See {IERC721Metadata-symbol}.
759      */
760     function symbol() public view virtual override returns (string memory) {
761         return _symbol;
762     }
763 
764     /**
765      * @dev See {IERC721Metadata-tokenURI}.
766      */
767     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
768         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
769 
770         string memory baseURI = _baseURI();
771         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
772     }
773 
774     /**
775      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
776      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
777      * by default, can be overriden in child contracts.
778      */
779     function _baseURI() internal view virtual returns (string memory) {
780         return "";
781     }
782 
783     /**
784      * @dev See {IERC721-approve}.
785      */
786     function approve(address to, uint256 tokenId) public virtual override {
787         address owner = ERC721.ownerOf(tokenId);
788         require(to != owner, "ERC721: approval to current owner");
789 
790         require(
791             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
792             "ERC721: approve caller is not owner nor approved for all"
793         );
794 
795         _approve(to, tokenId);
796     }
797 
798     /**
799      * @dev See {IERC721-getApproved}.
800      */
801     function getApproved(uint256 tokenId) public view virtual override returns (address) {
802         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
803 
804         return _tokenApprovals[tokenId];
805     }
806 
807     /**
808      * @dev See {IERC721-setApprovalForAll}.
809      */
810     function setApprovalForAll(address operator, bool approved) public virtual override {
811         require(operator != _msgSender(), "ERC721: approve to caller");
812 
813         _operatorApprovals[_msgSender()][operator] = approved;
814         emit ApprovalForAll(_msgSender(), operator, approved);
815     }
816 
817     /**
818      * @dev See {IERC721-isApprovedForAll}.
819      */
820     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
821         return _operatorApprovals[owner][operator];
822     }
823 
824     /**
825      * @dev See {IERC721-transferFrom}.
826      */
827     function transferFrom(
828         address from,
829         address to,
830         uint256 tokenId
831     ) public virtual override {
832         //solhint-disable-next-line max-line-length
833         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
834 
835         _transfer(from, to, tokenId);
836     }
837 
838     /**
839      * @dev See {IERC721-safeTransferFrom}.
840      */
841     function safeTransferFrom(
842         address from,
843         address to,
844         uint256 tokenId
845     ) public virtual override {
846         safeTransferFrom(from, to, tokenId, "");
847     }
848 
849     /**
850      * @dev See {IERC721-safeTransferFrom}.
851      */
852     function safeTransferFrom(
853         address from,
854         address to,
855         uint256 tokenId,
856         bytes memory _data
857     ) public virtual override {
858         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
859         _safeTransfer(from, to, tokenId, _data);
860     }
861 
862     /**
863      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
864      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
865      *
866      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
867      *
868      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
869      * implement alternative mechanisms to perform token transfer, such as signature-based.
870      *
871      * Requirements:
872      *
873      * - `from` cannot be the zero address.
874      * - `to` cannot be the zero address.
875      * - `tokenId` token must exist and be owned by `from`.
876      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
877      *
878      * Emits a {Transfer} event.
879      */
880     function _safeTransfer(
881         address from,
882         address to,
883         uint256 tokenId,
884         bytes memory _data
885     ) internal virtual {
886         _transfer(from, to, tokenId);
887         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
888     }
889 
890     /**
891      * @dev Returns whether `tokenId` exists.
892      *
893      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
894      *
895      * Tokens start existing when they are minted (`_mint`),
896      * and stop existing when they are burned (`_burn`).
897      */
898     function _exists(uint256 tokenId) internal view virtual returns (bool) {
899         return _owners[tokenId] != address(0);
900     }
901 
902     /**
903      * @dev Returns whether `spender` is allowed to manage `tokenId`.
904      *
905      * Requirements:
906      *
907      * - `tokenId` must exist.
908      */
909     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
910         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
911         address owner = ERC721.ownerOf(tokenId);
912         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
913     }
914 
915     /**
916      * @dev Safely mints `tokenId` and transfers it to `to`.
917      *
918      * Requirements:
919      *
920      * - `tokenId` must not exist.
921      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
922      *
923      * Emits a {Transfer} event.
924      */
925     function _safeMint(address to, uint256 tokenId) internal virtual {
926         _safeMint(to, tokenId, "");
927     }
928 
929     /**
930      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
931      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
932      */
933     function _safeMint(
934         address to,
935         uint256 tokenId,
936         bytes memory _data
937     ) internal virtual {
938         _mint(to, tokenId);
939         require(
940             _checkOnERC721Received(address(0), to, tokenId, _data),
941             "ERC721: transfer to non ERC721Receiver implementer"
942         );
943     }
944 
945     /**
946      * @dev Mints `tokenId` and transfers it to `to`.
947      *
948      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
949      *
950      * Requirements:
951      *
952      * - `tokenId` must not exist.
953      * - `to` cannot be the zero address.
954      *
955      * Emits a {Transfer} event.
956      */
957     function _mint(address to, uint256 tokenId) internal virtual {
958         require(to != address(0), "ERC721: mint to the zero address");
959         require(!_exists(tokenId), "ERC721: token already minted");
960 
961         _beforeTokenTransfer(address(0), to, tokenId);
962 
963         _balances[to] += 1;
964         _owners[tokenId] = to;
965 
966         emit Transfer(address(0), to, tokenId);
967     }
968 
969     /**
970      * @dev Destroys `tokenId`.
971      * The approval is cleared when the token is burned.
972      *
973      * Requirements:
974      *
975      * - `tokenId` must exist.
976      *
977      * Emits a {Transfer} event.
978      */
979     function _burn(uint256 tokenId) internal virtual {
980         address owner = ERC721.ownerOf(tokenId);
981 
982         _beforeTokenTransfer(owner, address(0), tokenId);
983 
984         // Clear approvals
985         _approve(address(0), tokenId);
986 
987         _balances[owner] -= 1;
988         delete _owners[tokenId];
989 
990         emit Transfer(owner, address(0), tokenId);
991     }
992 
993     /**
994      * @dev Transfers `tokenId` from `from` to `to`.
995      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
996      *
997      * Requirements:
998      *
999      * - `to` cannot be the zero address.
1000      * - `tokenId` token must be owned by `from`.
1001      *
1002      * Emits a {Transfer} event.
1003      */
1004     function _transfer(
1005         address from,
1006         address to,
1007         uint256 tokenId
1008     ) internal virtual {
1009         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1010         require(to != address(0), "ERC721: transfer to the zero address");
1011 
1012         _beforeTokenTransfer(from, to, tokenId);
1013 
1014         // Clear approvals from the previous owner
1015         _approve(address(0), tokenId);
1016 
1017         _balances[from] -= 1;
1018         _balances[to] += 1;
1019         _owners[tokenId] = to;
1020 
1021         emit Transfer(from, to, tokenId);
1022     }
1023 
1024     /**
1025      * @dev Approve `to` to operate on `tokenId`
1026      *
1027      * Emits a {Approval} event.
1028      */
1029     function _approve(address to, uint256 tokenId) internal virtual {
1030         _tokenApprovals[tokenId] = to;
1031         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1032     }
1033 
1034     /**
1035      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1036      * The call is not executed if the target address is not a contract.
1037      *
1038      * @param from address representing the previous owner of the given token ID
1039      * @param to target address that will receive the tokens
1040      * @param tokenId uint256 ID of the token to be transferred
1041      * @param _data bytes optional data to send along with the call
1042      * @return bool whether the call correctly returned the expected magic value
1043      */
1044     function _checkOnERC721Received(
1045         address from,
1046         address to,
1047         uint256 tokenId,
1048         bytes memory _data
1049     ) private returns (bool) {
1050         if (to.isContract()) {
1051             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1052                 return retval == IERC721Receiver(to).onERC721Received.selector;
1053             } catch (bytes memory reason) {
1054                 if (reason.length == 0) {
1055                     revert("ERC721: transfer to non ERC721Receiver implementer");
1056                 } else {
1057                     assembly {
1058                         revert(add(32, reason), mload(reason))
1059                     }
1060                 }
1061             }
1062         } else {
1063             return true;
1064         }
1065     }
1066 
1067     /**
1068      * @dev Hook that is called before any token transfer. This includes minting
1069      * and burning.
1070      *
1071      * Calling conditions:
1072      *
1073      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1074      * transferred to `to`.
1075      * - When `from` is zero, `tokenId` will be minted for `to`.
1076      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1077      * - `from` and `to` are never both zero.
1078      *
1079      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1080      */
1081     function _beforeTokenTransfer(
1082         address from,
1083         address to,
1084         uint256 tokenId
1085     ) internal virtual {}
1086 }
1087 
1088 
1089 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol@v4.2.0
1090 
1091 
1092 pragma solidity ^0.8.0;
1093 
1094 
1095 /**
1096  * @title ERC721 Burnable Token
1097  * @dev ERC721 Token that can be irreversibly burned (destroyed).
1098  */
1099 abstract contract ERC721Burnable is Context, ERC721 {
1100     /**
1101      * @dev Burns `tokenId`. See {ERC721-_burn}.
1102      *
1103      * Requirements:
1104      *
1105      * - The caller must own `tokenId` or be an approved operator.
1106      */
1107     function burn(uint256 tokenId) public virtual {
1108         //solhint-disable-next-line max-line-length
1109         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721Burnable: caller is not owner nor approved");
1110         _burn(tokenId);
1111     }
1112 }
1113 
1114 
1115 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.2.0
1116 
1117 
1118 pragma solidity ^0.8.0;
1119 
1120 /**
1121  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1122  * @dev See https://eips.ethereum.org/EIPS/eip-721
1123  */
1124 interface IERC721Enumerable is IERC721 {
1125     /**
1126      * @dev Returns the total amount of tokens stored by the contract.
1127      */
1128     function totalSupply() external view returns (uint256);
1129 
1130     /**
1131      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1132      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1133      */
1134     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1135 
1136     /**
1137      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1138      * Use along with {totalSupply} to enumerate all tokens.
1139      */
1140     function tokenByIndex(uint256 index) external view returns (uint256);
1141 }
1142 
1143 
1144 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol@v4.2.0
1145 
1146 
1147 pragma solidity ^0.8.0;
1148 
1149 
1150 /**
1151  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1152  * enumerability of all the token ids in the contract as well as all token ids owned by each
1153  * account.
1154  */
1155 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1156     // Mapping from owner to list of owned token IDs
1157     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1158 
1159     // Mapping from token ID to index of the owner tokens list
1160     mapping(uint256 => uint256) private _ownedTokensIndex;
1161 
1162     // Array with all token ids, used for enumeration
1163     uint256[] private _allTokens;
1164 
1165     // Mapping from token id to position in the allTokens array
1166     mapping(uint256 => uint256) private _allTokensIndex;
1167 
1168     /**
1169      * @dev See {IERC165-supportsInterface}.
1170      */
1171     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1172         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1173     }
1174 
1175     /**
1176      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1177      */
1178     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1179         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1180         return _ownedTokens[owner][index];
1181     }
1182 
1183     /**
1184      * @dev See {IERC721Enumerable-totalSupply}.
1185      */
1186     function totalSupply() public view virtual override returns (uint256) {
1187         return _allTokens.length;
1188     }
1189 
1190     /**
1191      * @dev See {IERC721Enumerable-tokenByIndex}.
1192      */
1193     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1194         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1195         return _allTokens[index];
1196     }
1197 
1198     /**
1199      * @dev Hook that is called before any token transfer. This includes minting
1200      * and burning.
1201      *
1202      * Calling conditions:
1203      *
1204      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1205      * transferred to `to`.
1206      * - When `from` is zero, `tokenId` will be minted for `to`.
1207      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1208      * - `from` cannot be the zero address.
1209      * - `to` cannot be the zero address.
1210      *
1211      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1212      */
1213     function _beforeTokenTransfer(
1214         address from,
1215         address to,
1216         uint256 tokenId
1217     ) internal virtual override {
1218         super._beforeTokenTransfer(from, to, tokenId);
1219 
1220         if (from == address(0)) {
1221             _addTokenToAllTokensEnumeration(tokenId);
1222         } else if (from != to) {
1223             _removeTokenFromOwnerEnumeration(from, tokenId);
1224         }
1225         if (to == address(0)) {
1226             _removeTokenFromAllTokensEnumeration(tokenId);
1227         } else if (to != from) {
1228             _addTokenToOwnerEnumeration(to, tokenId);
1229         }
1230     }
1231 
1232     /**
1233      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1234      * @param to address representing the new owner of the given token ID
1235      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1236      */
1237     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1238         uint256 length = ERC721.balanceOf(to);
1239         _ownedTokens[to][length] = tokenId;
1240         _ownedTokensIndex[tokenId] = length;
1241     }
1242 
1243     /**
1244      * @dev Private function to add a token to this extension's token tracking data structures.
1245      * @param tokenId uint256 ID of the token to be added to the tokens list
1246      */
1247     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1248         _allTokensIndex[tokenId] = _allTokens.length;
1249         _allTokens.push(tokenId);
1250     }
1251 
1252     /**
1253      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1254      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1255      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1256      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1257      * @param from address representing the previous owner of the given token ID
1258      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1259      */
1260     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1261         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1262         // then delete the last slot (swap and pop).
1263 
1264         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1265         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1266 
1267         // When the token to delete is the last token, the swap operation is unnecessary
1268         if (tokenIndex != lastTokenIndex) {
1269             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1270 
1271             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1272             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1273         }
1274 
1275         // This also deletes the contents at the last position of the array
1276         delete _ownedTokensIndex[tokenId];
1277         delete _ownedTokens[from][lastTokenIndex];
1278     }
1279 
1280     /**
1281      * @dev Private function to remove a token from this extension's token tracking data structures.
1282      * This has O(1) time complexity, but alters the order of the _allTokens array.
1283      * @param tokenId uint256 ID of the token to be removed from the tokens list
1284      */
1285     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1286         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1287         // then delete the last slot (swap and pop).
1288 
1289         uint256 lastTokenIndex = _allTokens.length - 1;
1290         uint256 tokenIndex = _allTokensIndex[tokenId];
1291 
1292         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1293         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1294         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1295         uint256 lastTokenId = _allTokens[lastTokenIndex];
1296 
1297         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1298         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1299 
1300         // This also deletes the contents at the last position of the array
1301         delete _allTokensIndex[tokenId];
1302         _allTokens.pop();
1303     }
1304 }
1305 
1306 
1307 // File @openzeppelin/contracts/security/Pausable.sol@v4.2.0
1308 
1309 pragma solidity ^0.8.0;
1310 
1311 /**
1312  * @dev Contract module which allows children to implement an emergency stop
1313  * mechanism that can be triggered by an authorized account.
1314  *
1315  * This module is used through inheritance. It will make available the
1316  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1317  * the functions of your contract. Note that they will not be pausable by
1318  * simply including this module, only once the modifiers are put in place.
1319  */
1320 abstract contract Pausable is Context {
1321     /**
1322      * @dev Emitted when the pause is triggered by `account`.
1323      */
1324     event Paused(address account);
1325 
1326     /**
1327      * @dev Emitted when the pause is lifted by `account`.
1328      */
1329     event Unpaused(address account);
1330 
1331     bool private _paused;
1332 
1333     /**
1334      * @dev Initializes the contract in unpaused state.
1335      */
1336     constructor() {
1337         _paused = false;
1338     }
1339 
1340     /**
1341      * @dev Returns true if the contract is paused, and false otherwise.
1342      */
1343     function paused() public view virtual returns (bool) {
1344         return _paused;
1345     }
1346 
1347     /**
1348      * @dev Modifier to make a function callable only when the contract is not paused.
1349      *
1350      * Requirements:
1351      *
1352      * - The contract must not be paused.
1353      */
1354     modifier whenNotPaused() {
1355         require(!paused(), "Pausable: paused");
1356         _;
1357     }
1358 
1359     /**
1360      * @dev Modifier to make a function callable only when the contract is paused.
1361      *
1362      * Requirements:
1363      *
1364      * - The contract must be paused.
1365      */
1366     modifier whenPaused() {
1367         require(paused(), "Pausable: not paused");
1368         _;
1369     }
1370 
1371     /**
1372      * @dev Triggers stopped state.
1373      *
1374      * Requirements:
1375      *
1376      * - The contract must not be paused.
1377      */
1378     function _pause() internal virtual whenNotPaused {
1379         _paused = true;
1380         emit Paused(_msgSender());
1381     }
1382 
1383     /**
1384      * @dev Returns to normal state.
1385      *
1386      * Requirements:
1387      *
1388      * - The contract must be paused.
1389      */
1390     function _unpause() internal virtual whenPaused {
1391         _paused = false;
1392         emit Unpaused(_msgSender());
1393     }
1394 }
1395 
1396 
1397 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol@v4.2.0
1398 
1399 
1400 pragma solidity ^0.8.0;
1401 
1402 
1403 /**
1404  * @dev ERC721 token with pausable token transfers, minting and burning.
1405  *
1406  * Useful for scenarios such as preventing trades until the end of an evaluation
1407  * period, or having an emergency switch for freezing all token transfers in the
1408  * event of a large bug.
1409  */
1410 abstract contract ERC721Pausable is ERC721, Pausable {
1411     /**
1412      * @dev See {ERC721-_beforeTokenTransfer}.
1413      *
1414      * Requirements:
1415      *
1416      * - the contract must not be paused.
1417      */
1418     function _beforeTokenTransfer(
1419         address from,
1420         address to,
1421         uint256 tokenId
1422     ) internal virtual override {
1423         super._beforeTokenTransfer(from, to, tokenId);
1424 
1425         require(!paused(), "ERC721Pausable: token transfer while paused");
1426     }
1427 }
1428 
1429 
1430 // File @openzeppelin/contracts/access/Ownable.sol@v4.2.0
1431 
1432 
1433 pragma solidity ^0.8.0;
1434 
1435 /**
1436  * @dev Contract module which provides a basic access control mechanism, where
1437  * there is an account (an owner) that can be granted exclusive access to
1438  * specific functions.
1439  *
1440  * By default, the owner account will be the one that deploys the contract. This
1441  * can later be changed with {transferOwnership}.
1442  *
1443  * This module is used through inheritance. It will make available the modifier
1444  * `onlyOwner`, which can be applied to your functions to restrict their use to
1445  * the owner.
1446  */
1447 abstract contract Ownable is Context {
1448     address private _owner;
1449 
1450     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1451 
1452     /**
1453      * @dev Initializes the contract setting the deployer as the initial owner.
1454      */
1455     constructor() {
1456         _setOwner(_msgSender());
1457     }
1458 
1459     /**
1460      * @dev Returns the address of the current owner.
1461      */
1462     function owner() public view virtual returns (address) {
1463         return _owner;
1464     }
1465 
1466     /**
1467      * @dev Throws if called by any account other than the owner.
1468      */
1469     modifier onlyOwner() {
1470         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1471         _;
1472     }
1473 
1474     /**
1475      * @dev Leaves the contract without owner. It will not be possible to call
1476      * `onlyOwner` functions anymore. Can only be called by the current owner.
1477      *
1478      * NOTE: Renouncing ownership will leave the contract without an owner,
1479      * thereby removing any functionality that is only available to the owner.
1480      */
1481     function renounceOwnership() public virtual onlyOwner {
1482         _setOwner(address(0));
1483     }
1484 
1485     /**
1486      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1487      * Can only be called by the current owner.
1488      */
1489     function transferOwnership(address newOwner) public virtual onlyOwner {
1490         require(newOwner != address(0), "Ownable: new owner is the zero address");
1491         _setOwner(newOwner);
1492     }
1493 
1494     function _setOwner(address newOwner) private {
1495         address oldOwner = _owner;
1496         _owner = newOwner;
1497         emit OwnershipTransferred(oldOwner, newOwner);
1498     }
1499 }
1500 
1501 
1502 // File @openzeppelin/contracts/utils/Counters.sol@v4.2.0
1503 
1504 
1505 pragma solidity ^0.8.0;
1506 
1507 /**
1508  * @title Counters
1509  * @author Matt Condon (@shrugs)
1510  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1511  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1512  *
1513  * Include with `using Counters for Counters.Counter;`
1514  */
1515 library Counters {
1516     struct Counter {
1517         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1518         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1519         // this feature: see https://github.com/ethereum/solidity/issues/4637
1520         uint256 _value; // default: 0
1521     }
1522 
1523     function current(Counter storage counter) internal view returns (uint256) {
1524         return counter._value;
1525     }
1526 
1527     function increment(Counter storage counter) internal {
1528         unchecked {
1529             counter._value += 1;
1530         }
1531     }
1532 
1533     function decrement(Counter storage counter) internal {
1534         uint256 value = counter._value;
1535         require(value > 0, "Counter: decrement overflow");
1536         unchecked {
1537             counter._value = value - 1;
1538         }
1539     }
1540 
1541     function reset(Counter storage counter) internal {
1542         counter._value = 0;
1543     }
1544 }
1545 
1546 
1547 // File @openzeppelin/contracts/utils/math/SafeMath.sol@v4.2.0
1548 
1549 
1550 pragma solidity ^0.8.0;
1551 
1552 // CAUTION
1553 // This version of SafeMath should only be used with Solidity 0.8 or later,
1554 // because it relies on the compiler's built in overflow checks.
1555 
1556 /**
1557  * @dev Wrappers over Solidity's arithmetic operations.
1558  *
1559  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
1560  * now has built in overflow checking.
1561  */
1562 library SafeMath {
1563     /**
1564      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1565      *
1566      * _Available since v3.4._
1567      */
1568     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1569         unchecked {
1570             uint256 c = a + b;
1571             if (c < a) return (false, 0);
1572             return (true, c);
1573         }
1574     }
1575 
1576     /**
1577      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1578      *
1579      * _Available since v3.4._
1580      */
1581     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1582         unchecked {
1583             if (b > a) return (false, 0);
1584             return (true, a - b);
1585         }
1586     }
1587 
1588     /**
1589      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1590      *
1591      * _Available since v3.4._
1592      */
1593     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1594         unchecked {
1595             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1596             // benefit is lost if 'b' is also tested.
1597             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1598             if (a == 0) return (true, 0);
1599             uint256 c = a * b;
1600             if (c / a != b) return (false, 0);
1601             return (true, c);
1602         }
1603     }
1604 
1605     /**
1606      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1607      *
1608      * _Available since v3.4._
1609      */
1610     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1611         unchecked {
1612             if (b == 0) return (false, 0);
1613             return (true, a / b);
1614         }
1615     }
1616 
1617     /**
1618      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1619      *
1620      * _Available since v3.4._
1621      */
1622     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1623         unchecked {
1624             if (b == 0) return (false, 0);
1625             return (true, a % b);
1626         }
1627     }
1628 
1629     /**
1630      * @dev Returns the addition of two unsigned integers, reverting on
1631      * overflow.
1632      *
1633      * Counterpart to Solidity's `+` operator.
1634      *
1635      * Requirements:
1636      *
1637      * - Addition cannot overflow.
1638      */
1639     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1640         return a + b;
1641     }
1642 
1643     /**
1644      * @dev Returns the subtraction of two unsigned integers, reverting on
1645      * overflow (when the result is negative).
1646      *
1647      * Counterpart to Solidity's `-` operator.
1648      *
1649      * Requirements:
1650      *
1651      * - Subtraction cannot overflow.
1652      */
1653     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1654         return a - b;
1655     }
1656 
1657     /**
1658      * @dev Returns the multiplication of two unsigned integers, reverting on
1659      * overflow.
1660      *
1661      * Counterpart to Solidity's `*` operator.
1662      *
1663      * Requirements:
1664      *
1665      * - Multiplication cannot overflow.
1666      */
1667     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1668         return a * b;
1669     }
1670 
1671     /**
1672      * @dev Returns the integer division of two unsigned integers, reverting on
1673      * division by zero. The result is rounded towards zero.
1674      *
1675      * Counterpart to Solidity's `/` operator.
1676      *
1677      * Requirements:
1678      *
1679      * - The divisor cannot be zero.
1680      */
1681     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1682         return a / b;
1683     }
1684 
1685     /**
1686      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1687      * reverting when dividing by zero.
1688      *
1689      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1690      * opcode (which leaves remaining gas untouched) while Solidity uses an
1691      * invalid opcode to revert (consuming all remaining gas).
1692      *
1693      * Requirements:
1694      *
1695      * - The divisor cannot be zero.
1696      */
1697     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1698         return a % b;
1699     }
1700 
1701     /**
1702      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1703      * overflow (when the result is negative).
1704      *
1705      * CAUTION: This function is deprecated because it requires allocating memory for the error
1706      * message unnecessarily. For custom revert reasons use {trySub}.
1707      *
1708      * Counterpart to Solidity's `-` operator.
1709      *
1710      * Requirements:
1711      *
1712      * - Subtraction cannot overflow.
1713      */
1714     function sub(
1715         uint256 a,
1716         uint256 b,
1717         string memory errorMessage
1718     ) internal pure returns (uint256) {
1719         unchecked {
1720             require(b <= a, errorMessage);
1721             return a - b;
1722         }
1723     }
1724 
1725     /**
1726      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1727      * division by zero. The result is rounded towards zero.
1728      *
1729      * Counterpart to Solidity's `/` operator. Note: this function uses a
1730      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1731      * uses an invalid opcode to revert (consuming all remaining gas).
1732      *
1733      * Requirements:
1734      *
1735      * - The divisor cannot be zero.
1736      */
1737     function div(
1738         uint256 a,
1739         uint256 b,
1740         string memory errorMessage
1741     ) internal pure returns (uint256) {
1742         unchecked {
1743             require(b > 0, errorMessage);
1744             return a / b;
1745         }
1746     }
1747 
1748     /**
1749      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1750      * reverting with custom message when dividing by zero.
1751      *
1752      * CAUTION: This function is deprecated because it requires allocating memory for the error
1753      * message unnecessarily. For custom revert reasons use {tryMod}.
1754      *
1755      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1756      * opcode (which leaves remaining gas untouched) while Solidity uses an
1757      * invalid opcode to revert (consuming all remaining gas).
1758      *
1759      * Requirements:
1760      *
1761      * - The divisor cannot be zero.
1762      */
1763     function mod(
1764         uint256 a,
1765         uint256 b,
1766         string memory errorMessage
1767     ) internal pure returns (uint256) {
1768         unchecked {
1769             require(b > 0, errorMessage);
1770             return a % b;
1771         }
1772     }
1773 }
1774 
1775 
1776 // File contracts/nodes/IDexUtils.sol
1777 
1778 pragma solidity ^0.8.4;
1779 
1780 interface IDexUtils {
1781   function getMainPriceViaNativePair(address token)
1782     external
1783     view
1784     returns (uint256);
1785 }
1786 
1787 
1788 // File contracts/nodes/MCCNode.sol
1789 
1790 pragma solidity ^0.8.4;
1791 
1792 
1793 interface IERC20Decimals is IERC20 {
1794   function decimals() external view returns (uint8);
1795 }
1796 
1797 /**
1798  * MultiChainCapital Nodes
1799  */
1800 contract MCCNode is
1801   IMCCNode,
1802   Ownable,
1803   ERC721Burnable,
1804   ERC721Enumerable,
1805   ERC721Pausable
1806 {
1807   using SafeMath for uint256;
1808   using Strings for uint256;
1809   using Counters for Counters.Counter;
1810 
1811   uint16 public constant PERCENT_DENOMENATOR = 10000;
1812 
1813   struct Tier {
1814     uint256 id;
1815     string name;
1816     uint256 tokenPrice; // price excluding decimals
1817     uint256 stablePrice; // price excluding decimals
1818     uint256 dailyReturnPercent; // see PERCENT_DENOMENATOR, 1% = 100
1819   }
1820 
1821   Counters.Counter private _tokenIds;
1822 
1823   // Base token uri
1824   string private baseTokenURI; // baseTokenURI can point to IPFS folder like https://ipfs.io/ipfs/{cid}/ while
1825 
1826   address public override mainToken;
1827   address public override stableToken;
1828   IDexUtils dexUtils;
1829 
1830   // Payment address
1831   address public paymentAddress = 0xed528FC31f2575312Ec3336E0F6ec9812B534937;
1832 
1833   // Royalties address
1834   address public royaltyAddress = 0xed528FC31f2575312Ec3336E0F6ec9812B534937;
1835 
1836   // Royalties basis points (percentage using 2 decimals - 10000 = 100, 5000 = 50, 0 = 0)
1837   uint256 private royaltyBasisPoints = 300; // 3%
1838 
1839   // Token info
1840   string public constant TOKEN_NAME = 'MultiNode';
1841   string public constant TOKEN_SYMBOL = 'mNODE';
1842 
1843   // Public sale params
1844   uint256 public publicSaleStartTime;
1845   bool public publicSaleActive;
1846 
1847   uint256 public numTiers;
1848   mapping(uint256 => Tier) public allTiers;
1849 
1850   mapping(uint256 => Tier) public tokenTier;
1851   mapping(uint256 => uint256) public override tokenMintedAt;
1852   mapping(uint256 => uint256) public override tokenLastTransferredAt;
1853   mapping(uint256 => uint256) public override pricePaidUSD18;
1854   mapping(uint256 => uint256) public override tokenPerDayReturn; // the amount of mainToken to reward per day, locked at mint time
1855 
1856   mapping(uint256 => uint256) public tierCounts;
1857 
1858   event PublicSaleStart(uint256 indexed _saleStartTime);
1859   event PublicSalePaused(uint256 indexed _timeElapsed);
1860   event PublicSaleActive(bool indexed _publicSaleActive);
1861   event RoyaltyBasisPoints(uint256 indexed _royaltyBasisPoints);
1862 
1863   // Public sale active modifier
1864   modifier whenPublicSaleActive() {
1865     require(publicSaleActive, 'Public sale is not active');
1866     _;
1867   }
1868 
1869   // Public sale not active modifier
1870   modifier whenPublicSaleNotActive() {
1871     require(
1872       !publicSaleActive && publicSaleStartTime == 0,
1873       'Public sale is already active'
1874     );
1875     _;
1876   }
1877 
1878   // Owner or public sale active modifier
1879   modifier whenOwnerOrPublicSaleActive() {
1880     require(
1881       owner() == _msgSender() || publicSaleActive,
1882       'Public sale is not active'
1883     );
1884     _;
1885   }
1886 
1887   // -- Constructor --//
1888   constructor(
1889     string memory _baseTokenURI,
1890     address _mainToken,
1891     address _stableToken,
1892     address _dexUtils
1893   ) ERC721(TOKEN_NAME, TOKEN_SYMBOL) {
1894     baseTokenURI = _baseTokenURI;
1895     mainToken = _mainToken;
1896     stableToken = _stableToken;
1897     dexUtils = IDexUtils(_dexUtils);
1898 
1899     Tier[5] memory initTiers = [
1900       Tier({
1901         id: 1,
1902         name: 'Presidential',
1903         tokenPrice: 108_300_000,
1904         stablePrice: 5000,
1905         dailyReturnPercent: 100
1906       }),
1907       Tier({
1908         id: 2,
1909         name: 'Director',
1910         tokenPrice: 54_100_000,
1911         stablePrice: 2500,
1912         dailyReturnPercent: 80
1913       }),
1914       Tier({
1915         id: 3,
1916         name: 'Executive',
1917         tokenPrice: 21_700_000,
1918         stablePrice: 1000,
1919         dailyReturnPercent: 65
1920       }),
1921       Tier({
1922         id: 4,
1923         name: 'Banker',
1924         tokenPrice: 10_800_000,
1925         stablePrice: 500,
1926         dailyReturnPercent: 58
1927       }),
1928       Tier({
1929         id: 5,
1930         name: 'Analyst',
1931         tokenPrice: 5_400_000,
1932         stablePrice: 250,
1933         dailyReturnPercent: 50
1934       })
1935     ];
1936 
1937     numTiers = initTiers.length;
1938     for (uint256 i = 0; i < initTiers.length; i++) {
1939       Tier memory tier = initTiers[i];
1940       allTiers[tier.id] = tier;
1941     }
1942   }
1943 
1944   // -- External Functions -- //
1945   function getDexUtils() external view returns (address) {
1946     return address(dexUtils);
1947   }
1948 
1949   // Start public sale
1950   function startPublicSale() external onlyOwner whenPublicSaleNotActive {
1951     publicSaleStartTime = block.timestamp;
1952     publicSaleActive = true;
1953     emit PublicSaleStart(publicSaleStartTime);
1954   }
1955 
1956   // Set this value to the block.timestamp you'd like to reset to
1957   // Created as a way to fast foward in time for tier timing unit tests
1958   // Can also be used if needing to pause and restart public sale from original start time (returned in startPublicSale() above)
1959   function setPublicSaleStartTime(uint256 _publicSaleStartTime)
1960     external
1961     onlyOwner
1962   {
1963     publicSaleStartTime = _publicSaleStartTime;
1964     emit PublicSaleStart(publicSaleStartTime);
1965   }
1966 
1967   // Toggle public sale
1968   function togglePublicSaleActive() external onlyOwner {
1969     publicSaleActive = !publicSaleActive;
1970     emit PublicSaleActive(publicSaleActive);
1971   }
1972 
1973   // Pause public sale
1974   function pausePublicSale() external onlyOwner whenPublicSaleActive {
1975     publicSaleActive = false;
1976     emit PublicSalePaused(getElapsedSaleTime());
1977   }
1978 
1979   // Get all tiers
1980   function getAllTiers() external view returns (Tier[] memory) {
1981     Tier[] memory tiers = new Tier[](numTiers);
1982     for (uint256 i = 1; i < numTiers + 1; i++) {
1983       tiers[i - 1] = allTiers[i];
1984     }
1985     return tiers;
1986   }
1987 
1988   // Support royalty info - See {EIP-2981}: https://eips.ethereum.org/EIPS/eip-2981
1989   function royaltyInfo(uint256, uint256 _salePrice)
1990     external
1991     view
1992     returns (address receiver, uint256 royaltyAmount)
1993   {
1994     return (
1995       royaltyAddress,
1996       (_salePrice.mul(royaltyBasisPoints)).div(PERCENT_DENOMENATOR)
1997     );
1998   }
1999 
2000   //-- Public Functions --//
2001 
2002   // Get elapsed sale time
2003   function getElapsedSaleTime() public view returns (uint256) {
2004     return
2005       publicSaleStartTime > 0 ? block.timestamp.sub(publicSaleStartTime) : 0;
2006   }
2007 
2008   // Mint token - requires tier and amount
2009   function mint(uint256[] memory _tierIds, uint256[] memory _amounts)
2010     public
2011     payable
2012     override
2013     whenOwnerOrPublicSaleActive
2014   {
2015     require(
2016       _tierIds.length == _amounts.length,
2017       'Tier and amounts per tier should be the same'
2018     );
2019 
2020     for (uint256 _i = 0; _i < _tierIds.length; _i++) {
2021       uint256 _tierId = _tierIds[_i];
2022       uint256 _amount = _amounts[_i];
2023 
2024       Tier memory tier = allTiers[_tierId];
2025 
2026       require(tier.id == _tierId, 'Invalid tier');
2027 
2028       // Must mint at least one
2029       require(_amount > 0, 'Must mint at least one');
2030 
2031       // Get current address total balance
2032       uint256 currentTotalAmount = super.balanceOf(_msgSender());
2033 
2034       // Loop over all tokens for address and get current tier count
2035       uint256 currentTierAmount = 0;
2036       for (uint256 _j = 0; _j < currentTotalAmount; _j++) {
2037         uint256 tokenId = super.tokenOfOwnerByIndex(_msgSender(), _j);
2038         Tier memory _tokenTier = tokenTier[tokenId];
2039         if (_tokenTier.id == tier.id) {
2040           currentTierAmount++;
2041         }
2042       }
2043 
2044       // Pay for nodes
2045       payToMint(tier.id, _amount);
2046 
2047       for (uint256 i = 0; i < _amount; i++) {
2048         _tokenIds.increment();
2049 
2050         // Safe mint
2051         _safeMint(_msgSender(), _tokenIds.current());
2052 
2053         (uint256 mainPriceUSD18, uint256 pricePaid) = _getTotalPaidUSD18(
2054           tier.id
2055         );
2056         pricePaidUSD18[_tokenIds.current()] = pricePaid;
2057 
2058         tokenPerDayReturn[_tokenIds.current()] = getPerDayReturnFromTier(
2059           tier.id,
2060           mainPriceUSD18
2061         );
2062 
2063         // Attribute token id with tier
2064         tokenTier[_tokenIds.current()] = tier;
2065 
2066         // Store minted at timestamp by token id
2067         tokenMintedAt[_tokenIds.current()] = block.timestamp;
2068 
2069         // Increment tier counter
2070         tierCounts[tier.id] = tierCounts[tier.id].add(1);
2071       }
2072 
2073       // Return unused value
2074       if (msg.value > 0) {
2075         Address.sendValue(payable(_msgSender()), msg.value);
2076       }
2077     }
2078   }
2079 
2080   function payToMint(uint256 _tierId, uint256 amount)
2081     internal
2082     whenOwnerOrPublicSaleActive
2083   {
2084     bool isOwner = owner() == _msgSender();
2085     if (isOwner) {
2086       return;
2087     }
2088 
2089     Tier memory tier = allTiers[_tierId];
2090 
2091     IERC20Decimals main = IERC20Decimals(mainToken);
2092     IERC20Decimals stable = IERC20Decimals(stableToken);
2093 
2094     uint256 totalMainTokenPrice = tier.tokenPrice.mul(10**main.decimals()).mul(
2095       amount
2096     );
2097     uint256 totalStablePrice = tier.stablePrice.mul(10**stable.decimals()).mul(
2098       amount
2099     );
2100 
2101     require(
2102       main.balanceOf(msg.sender) >= totalMainTokenPrice,
2103       'not enough main token balance to mint'
2104     );
2105     require(
2106       stable.balanceOf(msg.sender) >= totalStablePrice,
2107       'not enough stable token balance to mint'
2108     );
2109 
2110     main.transferFrom(msg.sender, paymentAddress, totalMainTokenPrice);
2111     stable.transferFrom(msg.sender, paymentAddress, totalStablePrice);
2112   }
2113 
2114   function setPaymentAddress(address _address) external onlyOwner {
2115     paymentAddress = _address;
2116   }
2117 
2118   // Set royalty wallet address
2119   function setRoyaltyAddress(address _address) external onlyOwner {
2120     royaltyAddress = _address;
2121   }
2122 
2123   function setMainToken(address _mainToken) external onlyOwner {
2124     mainToken = _mainToken;
2125   }
2126 
2127   function setStableToken(address _stableToken) external onlyOwner {
2128     stableToken = _stableToken;
2129   }
2130 
2131   // Set royalty basis points
2132   function setRoyaltyBasisPoints(uint256 _basisPoints) external onlyOwner {
2133     royaltyBasisPoints = _basisPoints;
2134     emit RoyaltyBasisPoints(_basisPoints);
2135   }
2136 
2137   // Set base URI
2138   function setBaseURI(string memory _uri) external onlyOwner {
2139     baseTokenURI = _uri;
2140   }
2141 
2142   function setDexUtils(address _newUtils) external onlyOwner {
2143     dexUtils = IDexUtils(_newUtils);
2144   }
2145 
2146   function addOrUpdateTier(
2147     uint256 id,
2148     string memory name,
2149     uint256 tokenPrice,
2150     uint256 stablePrice,
2151     uint256 dailyReturnPercent
2152   ) external onlyOwner {
2153     Tier storage tier = allTiers[id];
2154 
2155     // check if tier exists and add to number of tiers if new tier
2156     if (tier.tokenPrice == 0 && tier.stablePrice == 0) {
2157       numTiers++;
2158     }
2159     tier.name = name;
2160     tier.tokenPrice = tokenPrice;
2161     tier.stablePrice = stablePrice;
2162     tier.dailyReturnPercent = dailyReturnPercent;
2163   }
2164 
2165   function updateNodePerDayReturn(uint256 tokenId, uint256 amount)
2166     external
2167     onlyOwner
2168   {
2169     tokenPerDayReturn[tokenId] = amount;
2170   }
2171 
2172   function getPerDayReturnFromTier(uint256 tierId, uint256 mainPriceUSD18)
2173     public
2174     view
2175     returns (uint256)
2176   {
2177     Tier memory tier = allTiers[tierId];
2178     IERC20Decimals main = IERC20Decimals(mainToken);
2179     (, uint256 totalUSDPaid18) = _getTotalPaidUSD18(tierId);
2180     uint256 perDayUSDRewards18 = totalUSDPaid18
2181       .mul(tier.dailyReturnPercent)
2182       .div(PERCENT_DENOMENATOR);
2183     return perDayUSDRewards18.mul(10**main.decimals()).div(mainPriceUSD18);
2184   }
2185 
2186   function _getTotalPaidUSD18(uint256 tierId)
2187     internal
2188     view
2189     returns (uint256, uint256)
2190   {
2191     Tier memory tier = allTiers[tierId];
2192     IERC20Decimals main = IERC20Decimals(mainToken);
2193     IERC20Decimals stable = IERC20Decimals(stableToken);
2194     uint256 mainIncDecimals = tier.tokenPrice.mul(10**main.decimals());
2195     uint256 stableIncDecimals = tier.stablePrice.mul(10**stable.decimals());
2196     uint256 mainPriceUSD18 = dexUtils.getMainPriceViaNativePair(mainToken);
2197     uint256 mainUSDPaid18 = mainPriceUSD18
2198       .mul(mainIncDecimals.mul(10**18).div(10**main.decimals()))
2199       .div(10**18);
2200     return (
2201       mainPriceUSD18,
2202       mainUSDPaid18.add(
2203         stableIncDecimals.mul(10**18).div(10**stable.decimals())
2204       )
2205     );
2206   }
2207 
2208   function tokenURI(uint256 _tokenId)
2209     public
2210     view
2211     virtual
2212     override
2213     returns (string memory)
2214   {
2215     require(_exists(_tokenId), 'Nonexistent token');
2216 
2217     return string(abi.encodePacked(_baseURI(), _tokenId.toString(), '.json'));
2218   }
2219 
2220   // Contract metadata URI - Support for OpenSea: https://docs.opensea.io/docs/contract-level-metadata
2221   function contractURI() public view returns (string memory) {
2222     return string(abi.encodePacked(_baseURI(), 'contract.json'));
2223   }
2224 
2225   // Override supportsInterface - See {IERC165-supportsInterface}
2226   function supportsInterface(bytes4 _interfaceId)
2227     public
2228     view
2229     virtual
2230     override(ERC721, ERC721Enumerable, IERC165)
2231     returns (bool)
2232   {
2233     return super.supportsInterface(_interfaceId);
2234   }
2235 
2236   // Pauses all token transfers - See {ERC721Pausable}
2237   function pause() public virtual onlyOwner {
2238     _pause();
2239   }
2240 
2241   // Unpauses all token transfers - See {ERC721Pausable}
2242   function unpause() public virtual onlyOwner {
2243     _unpause();
2244   }
2245 
2246   //-- Internal Functions --//
2247 
2248   // Get base URI
2249   function _baseURI() internal view override returns (string memory) {
2250     return baseTokenURI;
2251   }
2252 
2253   // Before all token transfer
2254   function _beforeTokenTransfer(
2255     address _from,
2256     address _to,
2257     uint256 _tokenId
2258   ) internal virtual override(ERC721, ERC721Enumerable, ERC721Pausable) {
2259     // Store token last transfer timestamp by id
2260     tokenLastTransferredAt[_tokenId] = block.timestamp;
2261 
2262     // TODO: update tracker of from/to owned tokenIds
2263 
2264     super._beforeTokenTransfer(_from, _to, _tokenId);
2265   }
2266 }