1 // SPDX-License-Identifier: MIT
2 
3 // discord.gg/weiner
4 /**
5      __     __     ______     __     __   __     ______     ______        ______   __     ______     __  __    
6    /\ \  _ \ \   /\  ___\   /\ \   /\ "-.\ \   /\  ___\   /\  == \      /\  ___\ /\ \   /\  ___\   /\ \_\ \   
7   \ \ \/ ".\ \  \ \  __\   \ \ \  \ \ \-.  \  \ \  __\   \ \  __<      \ \  __\ \ \ \  \ \___  \  \ \  __ \  
8   \ \__/".~\_\  \ \_____\  \ \_\  \ \_\\"\_\  \ \_____\  \ \_\ \_\     \ \_\    \ \_\  \/\_____\  \ \_\ \_\ 
9   \/_/   \/_/   \/_____/   \/_/   \/_/ \/_/   \/_____/   \/_/ /_/      \/_/     \/_/   \/_____/   \/_/\/_/ 
10     
11     
12 */
13 
14 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
15 pragma solidity ^0.8.0;
16 /**
17  * @dev Interface of the ERC165 standard, as defined in the
18  * https://eips.ethereum.org/EIPS/eip-165[EIP].
19  *
20  * Implementers can declare support of contract interfaces, which can then be
21  * queried by others ({ERC165Checker}).
22  *
23  * For an implementation, see {ERC165}.
24  */
25 interface IERC165 {
26     /**
27      * @dev Returns true if this contract implements the interface defined by
28      * `interfaceId`. See the corresponding
29      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
30      * to learn more about how these ids are created.
31      *
32      * This function call must use less than 30 000 gas.
33      */
34     function supportsInterface(bytes4 interfaceId) external view returns (bool);
35 }
36 
37 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
38 pragma solidity ^0.8.0;
39 /**
40  * @dev Required interface of an ERC721 compliant contract.
41  */
42 interface IERC721 is IERC165 {
43     /**
44      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
45      */
46     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
47 
48     /**
49      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
50      */
51     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
52 
53     /**
54      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
55      */
56     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
57 
58     /**
59      * @dev Returns the number of tokens in ``owner``'s account.
60      */
61     function balanceOf(address owner) external view returns (uint256 balance);
62 
63     /**
64      * @dev Returns the owner of the `tokenId` token.
65      *
66      * Requirements:
67      *
68      * - `tokenId` must exist.
69      */
70     function ownerOf(uint256 tokenId) external view returns (address owner);
71 
72     /**
73      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
74      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
75      *
76      * Requirements:
77      *
78      * - `from` cannot be the zero address.
79      * - `to` cannot be the zero address.
80      * - `tokenId` token must exist and be owned by `from`.
81      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
82      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
83      *
84      * Emits a {Transfer} event.
85      */
86     function safeTransferFrom(
87         address from,
88         address to,
89         uint256 tokenId
90     ) external;
91 
92     /**
93      * @dev Transfers `tokenId` token from `from` to `to`.
94      *
95      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
96      *
97      * Requirements:
98      *
99      * - `from` cannot be the zero address.
100      * - `to` cannot be the zero address.
101      * - `tokenId` token must be owned by `from`.
102      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
103      *
104      * Emits a {Transfer} event.
105      */
106     function transferFrom(
107         address from,
108         address to,
109         uint256 tokenId
110     ) external;
111 
112     /**
113      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
114      * The approval is cleared when the token is transferred.
115      *
116      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
117      *
118      * Requirements:
119      *
120      * - The caller must own the token or be an approved operator.
121      * - `tokenId` must exist.
122      *
123      * Emits an {Approval} event.
124      */
125     function approve(address to, uint256 tokenId) external;
126 
127     /**
128      * @dev Returns the account approved for `tokenId` token.
129      *
130      * Requirements:
131      *
132      * - `tokenId` must exist.
133      */
134     function getApproved(uint256 tokenId) external view returns (address operator);
135 
136     /**
137      * @dev Approve or remove `operator` as an operator for the caller.
138      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
139      *
140      * Requirements:
141      *
142      * - The `operator` cannot be the caller.
143      *
144      * Emits an {ApprovalForAll} event.
145      */
146     function setApprovalForAll(address operator, bool _approved) external;
147 
148     /**
149      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
150      *
151      * See {setApprovalForAll}
152      */
153     function isApprovedForAll(address owner, address operator) external view returns (bool);
154 
155     /**
156      * @dev Safely transfers `tokenId` token from `from` to `to`.
157      *
158      * Requirements:
159      *
160      * - `from` cannot be the zero address.
161      * - `to` cannot be the zero address.
162      * - `tokenId` token must exist and be owned by `from`.
163      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
164      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
165      *
166      * Emits a {Transfer} event.
167      */
168     function safeTransferFrom(
169         address from,
170         address to,
171         uint256 tokenId,
172         bytes calldata data
173     ) external;
174 }
175 
176 
177 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
178 pragma solidity ^0.8.0;
179 /**
180  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
181  * @dev See https://eips.ethereum.org/EIPS/eip-721
182  */
183 interface IERC721Enumerable is IERC721 {
184     /**
185      * @dev Returns the total amount of tokens stored by the contract.
186      */
187     function totalSupply() external view returns (uint256);
188 
189     /**
190      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
191      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
192      */
193     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
194 
195     /**
196      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
197      * Use along with {totalSupply} to enumerate all tokens.
198      */
199     function tokenByIndex(uint256 index) external view returns (uint256);
200 }
201 
202 
203 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
204 pragma solidity ^0.8.0;
205 /**
206  * @dev Implementation of the {IERC165} interface.
207  *
208  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
209  * for the additional interface id that will be supported. For example:
210  *
211  * ```solidity
212  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
213  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
214  * }
215  * ```
216  *
217  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
218  */
219 abstract contract ERC165 is IERC165 {
220     /**
221      * @dev See {IERC165-supportsInterface}.
222      */
223     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
224         return interfaceId == type(IERC165).interfaceId;
225     }
226 }
227 
228 // File: @openzeppelin/contracts/utils/Strings.sol
229 
230 
231 
232 pragma solidity ^0.8.0;
233 
234 /**
235  * @dev String operations.
236  */
237 library Strings {
238     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
239 
240     /**
241      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
242      */
243     function toString(uint256 value) internal pure returns (string memory) {
244         // Inspired by OraclizeAPI's implementation - MIT licence
245         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
246 
247         if (value == 0) {
248             return "0";
249         }
250         uint256 temp = value;
251         uint256 digits;
252         while (temp != 0) {
253             digits++;
254             temp /= 10;
255         }
256         bytes memory buffer = new bytes(digits);
257         while (value != 0) {
258             digits -= 1;
259             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
260             value /= 10;
261         }
262         return string(buffer);
263     }
264 
265     /**
266      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
267      */
268     function toHexString(uint256 value) internal pure returns (string memory) {
269         if (value == 0) {
270             return "0x00";
271         }
272         uint256 temp = value;
273         uint256 length = 0;
274         while (temp != 0) {
275             length++;
276             temp >>= 8;
277         }
278         return toHexString(value, length);
279     }
280 
281     /**
282      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
283      */
284     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
285         bytes memory buffer = new bytes(2 * length + 2);
286         buffer[0] = "0";
287         buffer[1] = "x";
288         for (uint256 i = 2 * length + 1; i > 1; --i) {
289             buffer[i] = _HEX_SYMBOLS[value & 0xf];
290             value >>= 4;
291         }
292         require(value == 0, "Strings: hex length insufficient");
293         return string(buffer);
294     }
295 }
296 
297 // File: @openzeppelin/contracts/utils/Address.sol
298 
299 
300 
301 pragma solidity ^0.8.0;
302 
303 /**
304  * @dev Collection of functions related to the address type
305  */
306 library Address {
307     /**
308      * @dev Returns true if `account` is a contract.
309      *
310      * [IMPORTANT]
311      * ====
312      * It is unsafe to assume that an address for which this function returns
313      * false is an externally-owned account (EOA) and not a contract.
314      *
315      * Among others, `isContract` will return false for the following
316      * types of addresses:
317      *
318      *  - an externally-owned account
319      *  - a contract in construction
320      *  - an address where a contract will be created
321      *  - an address where a contract lived, but was destroyed
322      * ====
323      */
324     function isContract(address account) internal view returns (bool) {
325         // This method relies on extcodesize, which returns 0 for contracts in
326         // construction, since the code is only stored at the end of the
327         // constructor execution.
328 
329         uint256 size;
330         assembly {
331             size := extcodesize(account)
332         }
333         return size > 0;
334     }
335 
336     /**
337      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
338      * `recipient`, forwarding all available gas and reverting on errors.
339      *
340      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
341      * of certain opcodes, possibly making contracts go over the 2300 gas limit
342      * imposed by `transfer`, making them unable to receive funds via
343      * `transfer`. {sendValue} removes this limitation.
344      *
345      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
346      *
347      * IMPORTANT: because control is transferred to `recipient`, care must be
348      * taken to not create reentrancy vulnerabilities. Consider using
349      * {ReentrancyGuard} or the
350      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
351      */
352     function sendValue(address payable recipient, uint256 amount) internal {
353         require(address(this).balance >= amount, "Address: insufficient balance");
354 
355         (bool success, ) = recipient.call{value: amount}("");
356         require(success, "Address: unable to send value, recipient may have reverted");
357     }
358 
359     /**
360      * @dev Performs a Solidity function call using a low level `call`. A
361      * plain `call` is an unsafe replacement for a function call: use this
362      * function instead.
363      *
364      * If `target` reverts with a revert reason, it is bubbled up by this
365      * function (like regular Solidity function calls).
366      *
367      * Returns the raw returned data. To convert to the expected return value,
368      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
369      *
370      * Requirements:
371      *
372      * - `target` must be a contract.
373      * - calling `target` with `data` must not revert.
374      *
375      * _Available since v3.1._
376      */
377     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
378         return functionCall(target, data, "Address: low-level call failed");
379     }
380 
381     /**
382      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
383      * `errorMessage` as a fallback revert reason when `target` reverts.
384      *
385      * _Available since v3.1._
386      */
387     function functionCall(
388         address target,
389         bytes memory data,
390         string memory errorMessage
391     ) internal returns (bytes memory) {
392         return functionCallWithValue(target, data, 0, errorMessage);
393     }
394 
395     /**
396      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
397      * but also transferring `value` wei to `target`.
398      *
399      * Requirements:
400      *
401      * - the calling contract must have an ETH balance of at least `value`.
402      * - the called Solidity function must be `payable`.
403      *
404      * _Available since v3.1._
405      */
406     function functionCallWithValue(
407         address target,
408         bytes memory data,
409         uint256 value
410     ) internal returns (bytes memory) {
411         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
412     }
413 
414     /**
415      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
416      * with `errorMessage` as a fallback revert reason when `target` reverts.
417      *
418      * _Available since v3.1._
419      */
420     function functionCallWithValue(
421         address target,
422         bytes memory data,
423         uint256 value,
424         string memory errorMessage
425     ) internal returns (bytes memory) {
426         require(address(this).balance >= value, "Address: insufficient balance for call");
427         require(isContract(target), "Address: call to non-contract");
428 
429         (bool success, bytes memory returndata) = target.call{value: value}(data);
430         return verifyCallResult(success, returndata, errorMessage);
431     }
432 
433     /**
434      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
435      * but performing a static call.
436      *
437      * _Available since v3.3._
438      */
439     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
440         return functionStaticCall(target, data, "Address: low-level static call failed");
441     }
442 
443     /**
444      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
445      * but performing a static call.
446      *
447      * _Available since v3.3._
448      */
449     function functionStaticCall(
450         address target,
451         bytes memory data,
452         string memory errorMessage
453     ) internal view returns (bytes memory) {
454         require(isContract(target), "Address: static call to non-contract");
455 
456         (bool success, bytes memory returndata) = target.staticcall(data);
457         return verifyCallResult(success, returndata, errorMessage);
458     }
459 
460     /**
461      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
462      * but performing a delegate call.
463      *
464      * _Available since v3.4._
465      */
466     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
467         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
468     }
469 
470     /**
471      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
472      * but performing a delegate call.
473      *
474      * _Available since v3.4._
475      */
476     function functionDelegateCall(
477         address target,
478         bytes memory data,
479         string memory errorMessage
480     ) internal returns (bytes memory) {
481         require(isContract(target), "Address: delegate call to non-contract");
482 
483         (bool success, bytes memory returndata) = target.delegatecall(data);
484         return verifyCallResult(success, returndata, errorMessage);
485     }
486 
487     /**
488      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
489      * revert reason using the provided one.
490      *
491      * _Available since v4.3._
492      */
493     function verifyCallResult(
494         bool success,
495         bytes memory returndata,
496         string memory errorMessage
497     ) internal pure returns (bytes memory) {
498         if (success) {
499             return returndata;
500         } else {
501             // Look for revert reason and bubble it up if present
502             if (returndata.length > 0) {
503                 // The easiest way to bubble the revert reason is using memory via assembly
504 
505                 assembly {
506                     let returndata_size := mload(returndata)
507                     revert(add(32, returndata), returndata_size)
508                 }
509             } else {
510                 revert(errorMessage);
511             }
512         }
513     }
514 }
515 
516 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
517 
518 
519 
520 pragma solidity ^0.8.0;
521 
522 
523 /**
524  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
525  * @dev See https://eips.ethereum.org/EIPS/eip-721
526  */
527 interface IERC721Metadata is IERC721 {
528     /**
529      * @dev Returns the token collection name.
530      */
531     function name() external view returns (string memory);
532 
533     /**
534      * @dev Returns the token collection symbol.
535      */
536     function symbol() external view returns (string memory);
537 
538     /**
539      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
540      */
541     function tokenURI(uint256 tokenId) external view returns (string memory);
542 }
543 
544 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
545 
546 
547 
548 pragma solidity ^0.8.0;
549 
550 /**
551  * @title ERC721 token receiver interface
552  * @dev Interface for any contract that wants to support safeTransfers
553  * from ERC721 asset contracts.
554  */
555 interface IERC721Receiver {
556     /**
557      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
558      * by `operator` from `from`, this function is called.
559      *
560      * It must return its Solidity selector to confirm the token transfer.
561      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
562      *
563      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
564      */
565     function onERC721Received(
566         address operator,
567         address from,
568         uint256 tokenId,
569         bytes calldata data
570     ) external returns (bytes4);
571 }
572 
573 // File: @openzeppelin/contracts/utils/Context.sol
574 pragma solidity ^0.8.0;
575 /**
576  * @dev Provides information about the current execution context, including the
577  * sender of the transaction and its data. While these are generally available
578  * via msg.sender and msg.data, they should not be accessed in such a direct
579  * manner, since when dealing with meta-transactions the account sending and
580  * paying for execution may not be the actual sender (as far as an application
581  * is concerned).
582  *
583  * This contract is only required for intermediate, library-like contracts.
584  */
585 abstract contract Context {
586     function _msgSender() internal view virtual returns (address) {
587         return msg.sender;
588     }
589 
590     function _msgData() internal view virtual returns (bytes calldata) {
591         return msg.data;
592     }
593 }
594 
595 
596 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
597 pragma solidity ^0.8.0;
598 /**
599  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
600  * the Metadata extension, but not including the Enumerable extension, which is available separately as
601  * {ERC721Enumerable}.
602  */
603 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
604     using Address for address;
605     using Strings for uint256;
606 
607     // Token name
608     string private _name;
609 
610     // Token symbol
611     string private _symbol;
612 
613     // Mapping from token ID to owner address
614     mapping(uint256 => address) private _owners;
615 
616     // Mapping owner address to token count
617     mapping(address => uint256) private _balances;
618 
619     // Mapping from token ID to approved address
620     mapping(uint256 => address) private _tokenApprovals;
621 
622     // Mapping from owner to operator approvals
623     mapping(address => mapping(address => bool)) private _operatorApprovals;
624 
625     /**
626      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
627      */
628     constructor(string memory name_, string memory symbol_) {
629         _name = name_;
630         _symbol = symbol_;
631     }
632 
633     /**
634      * @dev See {IERC165-supportsInterface}.
635      */
636     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
637         return
638             interfaceId == type(IERC721).interfaceId ||
639             interfaceId == type(IERC721Metadata).interfaceId ||
640             super.supportsInterface(interfaceId);
641     }
642 
643     /**
644      * @dev See {IERC721-balanceOf}.
645      */
646     function balanceOf(address owner) public view virtual override returns (uint256) {
647         require(owner != address(0), "ERC721: balance query for the zero address");
648         return _balances[owner];
649     }
650 
651     /**
652      * @dev See {IERC721-ownerOf}.
653      */
654     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
655         address owner = _owners[tokenId];
656         require(owner != address(0), "ERC721: owner query for nonexistent token");
657         return owner;
658     }
659 
660     /**
661      * @dev See {IERC721Metadata-name}.
662      */
663     function name() public view virtual override returns (string memory) {
664         return _name;
665     }
666 
667     /**
668      * @dev See {IERC721Metadata-symbol}.
669      */
670     function symbol() public view virtual override returns (string memory) {
671         return _symbol;
672     }
673 
674     /**
675      * @dev See {IERC721Metadata-tokenURI}.
676      */
677     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
678         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
679 
680         string memory baseURI = _baseURI();
681         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
682     }
683 
684     /**
685      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
686      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
687      * by default, can be overriden in child contracts.
688      */
689     function _baseURI() internal view virtual returns (string memory) {
690         return "";
691     }
692 
693     /**
694      * @dev See {IERC721-approve}.
695      */
696     function approve(address to, uint256 tokenId) public virtual override {
697         address owner = ERC721.ownerOf(tokenId);
698         require(to != owner, "ERC721: approval to current owner");
699 
700         require(
701             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
702             "ERC721: approve caller is not owner nor approved for all"
703         );
704 
705         _approve(to, tokenId);
706     }
707 
708     /**
709      * @dev See {IERC721-getApproved}.
710      */
711     function getApproved(uint256 tokenId) public view virtual override returns (address) {
712         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
713 
714         return _tokenApprovals[tokenId];
715     }
716 
717     /**
718      * @dev See {IERC721-setApprovalForAll}.
719      */
720     function setApprovalForAll(address operator, bool approved) public virtual override {
721         require(operator != _msgSender(), "ERC721: approve to caller");
722 
723         _operatorApprovals[_msgSender()][operator] = approved;
724         emit ApprovalForAll(_msgSender(), operator, approved);
725     }
726 
727     /**
728      * @dev See {IERC721-isApprovedForAll}.
729      */
730     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
731         return _operatorApprovals[owner][operator];
732     }
733 
734     /**
735      * @dev See {IERC721-transferFrom}.
736      */
737     function transferFrom(
738         address from,
739         address to,
740         uint256 tokenId
741     ) public virtual override {
742         //solhint-disable-next-line max-line-length
743         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
744 
745         _transfer(from, to, tokenId);
746     }
747 
748     /**
749      * @dev See {IERC721-safeTransferFrom}.
750      */
751     function safeTransferFrom(
752         address from,
753         address to,
754         uint256 tokenId
755     ) public virtual override {
756         safeTransferFrom(from, to, tokenId, "");
757     }
758 
759     /**
760      * @dev See {IERC721-safeTransferFrom}.
761      */
762     function safeTransferFrom(
763         address from,
764         address to,
765         uint256 tokenId,
766         bytes memory _data
767     ) public virtual override {
768         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
769         _safeTransfer(from, to, tokenId, _data);
770     }
771 
772     /**
773      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
774      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
775      *
776      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
777      *
778      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
779      * implement alternative mechanisms to perform token transfer, such as signature-based.
780      *
781      * Requirements:
782      *
783      * - `from` cannot be the zero address.
784      * - `to` cannot be the zero address.
785      * - `tokenId` token must exist and be owned by `from`.
786      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
787      *
788      * Emits a {Transfer} event.
789      */
790     function _safeTransfer(
791         address from,
792         address to,
793         uint256 tokenId,
794         bytes memory _data
795     ) internal virtual {
796         _transfer(from, to, tokenId);
797         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
798     }
799 
800     /**
801      * @dev Returns whether `tokenId` exists.
802      *
803      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
804      *
805      * Tokens start existing when they are minted (`_mint`),
806      * and stop existing when they are burned (`_burn`).
807      */
808     function _exists(uint256 tokenId) internal view virtual returns (bool) {
809         return _owners[tokenId] != address(0);
810     }
811 
812     /**
813      * @dev Returns whether `spender` is allowed to manage `tokenId`.
814      *
815      * Requirements:
816      *
817      * - `tokenId` must exist.
818      */
819     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
820         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
821         address owner = ERC721.ownerOf(tokenId);
822         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
823     }
824 
825     /**
826      * @dev Safely mints `tokenId` and transfers it to `to`.
827      *
828      * Requirements:
829      *
830      * - `tokenId` must not exist.
831      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
832      *
833      * Emits a {Transfer} event.
834      */
835     function _safeMint(address to, uint256 tokenId) internal virtual {
836         _safeMint(to, tokenId, "");
837     }
838 
839     /**
840      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
841      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
842      */
843     function _safeMint(
844         address to,
845         uint256 tokenId,
846         bytes memory _data
847     ) internal virtual {
848         _mint(to, tokenId);
849         require(
850             _checkOnERC721Received(address(0), to, tokenId, _data),
851             "ERC721: transfer to non ERC721Receiver implementer"
852         );
853     }
854 
855     /**
856      * @dev Mints `tokenId` and transfers it to `to`.
857      *
858      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
859      *
860      * Requirements:
861      *
862      * - `tokenId` must not exist.
863      * - `to` cannot be the zero address.
864      *
865      * Emits a {Transfer} event.
866      */
867     function _mint(address to, uint256 tokenId) internal virtual {
868         require(to != address(0), "ERC721: mint to the zero address");
869         require(!_exists(tokenId), "ERC721: token already minted");
870 
871         _beforeTokenTransfer(address(0), to, tokenId);
872 
873         _balances[to] += 1;
874         _owners[tokenId] = to;
875 
876         emit Transfer(address(0), to, tokenId);
877     }
878 
879     /**
880      * @dev Destroys `tokenId`.
881      * The approval is cleared when the token is burned.
882      *
883      * Requirements:
884      *
885      * - `tokenId` must exist.
886      *
887      * Emits a {Transfer} event.
888      */
889     function _burn(uint256 tokenId) internal virtual {
890         address owner = ERC721.ownerOf(tokenId);
891 
892         _beforeTokenTransfer(owner, address(0), tokenId);
893 
894         // Clear approvals
895         _approve(address(0), tokenId);
896 
897         _balances[owner] -= 1;
898         delete _owners[tokenId];
899 
900         emit Transfer(owner, address(0), tokenId);
901     }
902 
903     /**
904      * @dev Transfers `tokenId` from `from` to `to`.
905      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
906      *
907      * Requirements:
908      *
909      * - `to` cannot be the zero address.
910      * - `tokenId` token must be owned by `from`.
911      *
912      * Emits a {Transfer} event.
913      */
914     function _transfer(
915         address from,
916         address to,
917         uint256 tokenId
918     ) internal virtual {
919         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
920         require(to != address(0), "ERC721: transfer to the zero address");
921 
922         _beforeTokenTransfer(from, to, tokenId);
923 
924         // Clear approvals from the previous owner
925         _approve(address(0), tokenId);
926 
927         _balances[from] -= 1;
928         _balances[to] += 1;
929         _owners[tokenId] = to;
930 
931         emit Transfer(from, to, tokenId);
932     }
933 
934     /**
935      * @dev Approve `to` to operate on `tokenId`
936      *
937      * Emits a {Approval} event.
938      */
939     function _approve(address to, uint256 tokenId) internal virtual {
940         _tokenApprovals[tokenId] = to;
941         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
942     }
943 
944     /**
945      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
946      * The call is not executed if the target address is not a contract.
947      *
948      * @param from address representing the previous owner of the given token ID
949      * @param to target address that will receive the tokens
950      * @param tokenId uint256 ID of the token to be transferred
951      * @param _data bytes optional data to send along with the call
952      * @return bool whether the call correctly returned the expected magic value
953      */
954     function _checkOnERC721Received(
955         address from,
956         address to,
957         uint256 tokenId,
958         bytes memory _data
959     ) private returns (bool) {
960         if (to.isContract()) {
961             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
962                 return retval == IERC721Receiver.onERC721Received.selector;
963             } catch (bytes memory reason) {
964                 if (reason.length == 0) {
965                     revert("ERC721: transfer to non ERC721Receiver implementer");
966                 } else {
967                     assembly {
968                         revert(add(32, reason), mload(reason))
969                     }
970                 }
971             }
972         } else {
973             return true;
974         }
975     }
976 
977     /**
978      * @dev Hook that is called before any token transfer. This includes minting
979      * and burning.
980      *
981      * Calling conditions:
982      *
983      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
984      * transferred to `to`.
985      * - When `from` is zero, `tokenId` will be minted for `to`.
986      * - When `to` is zero, ``from``'s `tokenId` will be burned.
987      * - `from` and `to` are never both zero.
988      *
989      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
990      */
991     function _beforeTokenTransfer(
992         address from,
993         address to,
994         uint256 tokenId
995     ) internal virtual {}
996 }
997 
998 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
999 
1000 
1001 
1002 pragma solidity ^0.8.0;
1003 
1004 
1005 
1006 /**
1007  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1008  * enumerability of all the token ids in the contract as well as all token ids owned by each
1009  * account.
1010  */
1011 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1012     // Mapping from owner to list of owned token IDs
1013     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1014 
1015     // Mapping from token ID to index of the owner tokens list
1016     mapping(uint256 => uint256) private _ownedTokensIndex;
1017 
1018     // Array with all token ids, used for enumeration
1019     uint256[] private _allTokens;
1020 
1021     // Mapping from token id to position in the allTokens array
1022     mapping(uint256 => uint256) private _allTokensIndex;
1023 
1024     /**
1025      * @dev See {IERC165-supportsInterface}.
1026      */
1027     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1028         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1029     }
1030 
1031     /**
1032      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1033      */
1034     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1035         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1036         return _ownedTokens[owner][index];
1037     }
1038 
1039     /**
1040      * @dev See {IERC721Enumerable-totalSupply}.
1041      */
1042     function totalSupply() public view virtual override returns (uint256) {
1043         return _allTokens.length;
1044     }
1045 
1046     /**
1047      * @dev See {IERC721Enumerable-tokenByIndex}.
1048      */
1049     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1050         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1051         return _allTokens[index];
1052     }
1053 
1054     /**
1055      * @dev Hook that is called before any token transfer. This includes minting
1056      * and burning.
1057      *
1058      * Calling conditions:
1059      *
1060      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1061      * transferred to `to`.
1062      * - When `from` is zero, `tokenId` will be minted for `to`.
1063      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1064      * - `from` cannot be the zero address.
1065      * - `to` cannot be the zero address.
1066      *
1067      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1068      */
1069     function _beforeTokenTransfer(
1070         address from,
1071         address to,
1072         uint256 tokenId
1073     ) internal virtual override {
1074         super._beforeTokenTransfer(from, to, tokenId);
1075 
1076         if (from == address(0)) {
1077             _addTokenToAllTokensEnumeration(tokenId);
1078         } else if (from != to) {
1079             _removeTokenFromOwnerEnumeration(from, tokenId);
1080         }
1081         if (to == address(0)) {
1082             _removeTokenFromAllTokensEnumeration(tokenId);
1083         } else if (to != from) {
1084             _addTokenToOwnerEnumeration(to, tokenId);
1085         }
1086     }
1087 
1088     /**
1089      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1090      * @param to address representing the new owner of the given token ID
1091      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1092      */
1093     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1094         uint256 length = ERC721.balanceOf(to);
1095         _ownedTokens[to][length] = tokenId;
1096         _ownedTokensIndex[tokenId] = length;
1097     }
1098 
1099     /**
1100      * @dev Private function to add a token to this extension's token tracking data structures.
1101      * @param tokenId uint256 ID of the token to be added to the tokens list
1102      */
1103     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1104         _allTokensIndex[tokenId] = _allTokens.length;
1105         _allTokens.push(tokenId);
1106     }
1107 
1108     /**
1109      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1110      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1111      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1112      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1113      * @param from address representing the previous owner of the given token ID
1114      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1115      */
1116     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1117         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1118         // then delete the last slot (swap and pop).
1119 
1120         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1121         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1122 
1123         // When the token to delete is the last token, the swap operation is unnecessary
1124         if (tokenIndex != lastTokenIndex) {
1125             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1126 
1127             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1128             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1129         }
1130 
1131         // This also deletes the contents at the last position of the array
1132         delete _ownedTokensIndex[tokenId];
1133         delete _ownedTokens[from][lastTokenIndex];
1134     }
1135 
1136     /**
1137      * @dev Private function to remove a token from this extension's token tracking data structures.
1138      * This has O(1) time complexity, but alters the order of the _allTokens array.
1139      * @param tokenId uint256 ID of the token to be removed from the tokens list
1140      */
1141     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1142         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1143         // then delete the last slot (swap and pop).
1144 
1145         uint256 lastTokenIndex = _allTokens.length - 1;
1146         uint256 tokenIndex = _allTokensIndex[tokenId];
1147 
1148         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1149         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1150         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1151         uint256 lastTokenId = _allTokens[lastTokenIndex];
1152 
1153         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1154         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1155 
1156         // This also deletes the contents at the last position of the array
1157         delete _allTokensIndex[tokenId];
1158         _allTokens.pop();
1159     }
1160 }
1161 
1162 
1163 // File: @openzeppelin/contracts/access/Ownable.sol
1164 pragma solidity ^0.8.0;
1165 /**
1166  * @dev Contract module which provides a basic access control mechanism, where
1167  * there is an account (an owner) that can be granted exclusive access to
1168  * specific functions.
1169  *
1170  * By default, the owner account will be the one that deploys the contract. This
1171  * can later be changed with {transferOwnership}.
1172  *
1173  * This module is used through inheritance. It will make available the modifier
1174  * `onlyOwner`, which can be applied to your functions to restrict their use to
1175  * the owner.
1176  */
1177 abstract contract Ownable is Context {
1178     address private _owner;
1179 
1180     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1181 
1182     /**
1183      * @dev Initializes the contract setting the deployer as the initial owner.
1184      */
1185     constructor() {
1186         _setOwner(_msgSender());
1187     }
1188 
1189     /**
1190      * @dev Returns the address of the current owner.
1191      */
1192     function owner() public view virtual returns (address) {
1193         return _owner;
1194     }
1195 
1196     /**
1197      * @dev Throws if called by any account other than the owner.
1198      */
1199     modifier onlyOwner() {
1200         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1201         _;
1202     }
1203 
1204     /**
1205      * @dev Leaves the contract without owner. It will not be possible to call
1206      * `onlyOwner` functions anymore. Can only be called by the current owner.
1207      *
1208      * NOTE: Renouncing ownership will leave the contract without an owner,
1209      * thereby removing any functionality that is only available to the owner.
1210      */
1211     function renounceOwnership() public virtual onlyOwner {
1212         _setOwner(address(0));
1213     }
1214 
1215     /**
1216      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1217      * Can only be called by the current owner.
1218      */
1219     function transferOwnership(address newOwner) public virtual onlyOwner {
1220         require(newOwner != address(0), "Ownable: new owner is the zero address");
1221         _setOwner(newOwner);
1222     }
1223 
1224     function _setOwner(address newOwner) private {
1225         address oldOwner = _owner;
1226         _owner = newOwner;
1227         emit OwnershipTransferred(oldOwner, newOwner);
1228     }
1229 }
1230 
1231 pragma solidity >=0.7.0 <0.9.0;
1232 
1233 contract WeinerFish is ERC721Enumerable, Ownable {
1234   using Strings for uint256;
1235 
1236   string baseURI;
1237   string public baseExtension = ".json";
1238   uint256 public cost = 0.03 ether;
1239   uint256 public maxSupply = 6969;
1240   uint256 public maxMintAmount = 10;
1241   bool public paused = true;
1242   bool public revealed = false;
1243   string public notRevealedUri;
1244 
1245   constructor(
1246     string memory _name,
1247     string memory _symbol,
1248     string memory _initBaseURI,
1249     string memory _initNotRevealedUri
1250   ) ERC721(_name, _symbol) {
1251     setBaseURI(_initBaseURI);
1252     setNotRevealedURI(_initNotRevealedUri);
1253   }
1254 
1255   // internal
1256   function _baseURI() internal view virtual override returns (string memory) {
1257     return baseURI;
1258   }
1259 
1260   // public
1261   function mint(uint256 _mintAmount) public payable {
1262     uint256 supply = totalSupply();
1263     require(!paused);
1264     require(_mintAmount > 0);
1265     require(_mintAmount <= maxMintAmount);
1266     require(supply + _mintAmount <= maxSupply);
1267 
1268     if (msg.sender != owner()) {
1269       require(msg.value >= cost * _mintAmount);
1270     }
1271 
1272     for (uint256 i = 1; i <= _mintAmount; i++) {
1273       _safeMint(msg.sender, supply + i);
1274     }
1275   }
1276 
1277   function walletOfOwner(address _owner)
1278     public
1279     view
1280     returns (uint256[] memory)
1281   {
1282     uint256 ownerTokenCount = balanceOf(_owner);
1283     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1284     for (uint256 i; i < ownerTokenCount; i++) {
1285       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1286     }
1287     return tokenIds;
1288   }
1289 
1290   function tokenURI(uint256 tokenId)
1291     public
1292     view
1293     virtual
1294     override
1295     returns (string memory)
1296   {
1297     require(
1298       _exists(tokenId),
1299       "ERC721Metadata: URI query for nonexistent token"
1300     );
1301     
1302     if(revealed == false) {
1303         return notRevealedUri;
1304     }
1305 
1306     string memory currentBaseURI = _baseURI();
1307     return bytes(currentBaseURI).length > 0
1308         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1309         : "";
1310   }
1311 
1312   //only owner
1313   function reveal() public onlyOwner() {
1314       revealed = true;
1315   }
1316   
1317   function setCost(uint256 _newCost) public onlyOwner() {
1318     cost = _newCost;
1319   }
1320 
1321   function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner() {
1322     maxMintAmount = _newmaxMintAmount;
1323   }
1324   
1325   function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1326     notRevealedUri = _notRevealedURI;
1327   }
1328 
1329   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1330     baseURI = _newBaseURI;
1331   }
1332 
1333   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1334     baseExtension = _newBaseExtension;
1335   }
1336 
1337   function pause(bool _state) public onlyOwner {
1338     paused = _state;
1339   }
1340  
1341   function withdraw() public payable onlyOwner {
1342     (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
1343     require(success);
1344   }
1345 }