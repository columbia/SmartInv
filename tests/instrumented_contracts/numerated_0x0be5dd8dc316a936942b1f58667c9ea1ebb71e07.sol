1 // SPDX-License-Identifier: GPL-3.0
2 
3 // File: @openzeppelin/contracts/utils/Context.sol
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes calldata) {
23         return msg.data;
24     }
25 }
26 
27 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
28 pragma solidity ^0.8.0;
29 
30 /**
31  * @dev Interface of the ERC165 standard, as defined in the
32  * https://eips.ethereum.org/EIPS/eip-165[EIP].
33  *
34  * Implementers can declare support of contract interfaces, which can then be
35  * queried by others ({ERC165Checker}).
36  *
37  * For an implementation, see {ERC165}.
38  */
39 interface IERC165 {
40     /**
41      * @dev Returns true if this contract implements the interface defined by
42      * `interfaceId`. See the corresponding
43      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
44      * to learn more about how these ids are created.
45      *
46      * This function call must use less than 30 000 gas.
47      */
48     function supportsInterface(bytes4 interfaceId) external view returns (bool);
49 }
50 
51 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
52 pragma solidity ^0.8.0;
53 /**
54  * @dev Required interface of an ERC721 compliant contract.
55  */
56 interface IERC721 is IERC165 {
57     /**
58      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
59      */
60     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
61 
62     /**
63      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
64      */
65     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
66 
67     /**
68      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
69      */
70     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
71 
72     /**
73      * @dev Returns the number of tokens in ``owner``'s account.
74      */
75     function balanceOf(address owner) external view returns (uint256 balance);
76 
77     /**
78      * @dev Returns the owner of the `tokenId` token.
79      *
80      * Requirements:
81      *
82      * - `tokenId` must exist.
83      */
84     function ownerOf(uint256 tokenId) external view returns (address owner);
85 
86     /**
87      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
88      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
89      *
90      * Requirements:
91      *
92      * - `from` cannot be the zero address.
93      * - `to` cannot be the zero address.
94      * - `tokenId` token must exist and be owned by `from`.
95      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
96      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
97      *
98      * Emits a {Transfer} event.
99      */
100     function safeTransferFrom(
101         address from,
102         address to,
103         uint256 tokenId
104     ) external;
105 
106     /**
107      * @dev Transfers `tokenId` token from `from` to `to`.
108      *
109      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
110      *
111      * Requirements:
112      *
113      * - `from` cannot be the zero address.
114      * - `to` cannot be the zero address.
115      * - `tokenId` token must be owned by `from`.
116      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
117      *
118      * Emits a {Transfer} event.
119      */
120     function transferFrom(
121         address from,
122         address to,
123         uint256 tokenId
124     ) external;
125 
126     /**
127      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
128      * The approval is cleared when the token is transferred.
129      *
130      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
131      *
132      * Requirements:
133      *
134      * - The caller must own the token or be an approved operator.
135      * - `tokenId` must exist.
136      *
137      * Emits an {Approval} event.
138      */
139     function approve(address to, uint256 tokenId) external;
140 
141     /**
142      * @dev Returns the account approved for `tokenId` token.
143      *
144      * Requirements:
145      *
146      * - `tokenId` must exist.
147      */
148     function getApproved(uint256 tokenId) external view returns (address operator);
149 
150     /**
151      * @dev Approve or remove `operator` as an operator for the caller.
152      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
153      *
154      * Requirements:
155      *
156      * - The `operator` cannot be the caller.
157      *
158      * Emits an {ApprovalForAll} event.
159      */
160     function setApprovalForAll(address operator, bool _approved) external;
161 
162     /**
163      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
164      *
165      * See {setApprovalForAll}
166      */
167     function isApprovedForAll(address owner, address operator) external view returns (bool);
168 
169     /**
170      * @dev Safely transfers `tokenId` token from `from` to `to`.
171      *
172      * Requirements:
173      *
174      * - `from` cannot be the zero address.
175      * - `to` cannot be the zero address.
176      * - `tokenId` token must exist and be owned by `from`.
177      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
178      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
179      *
180      * Emits a {Transfer} event.
181      */
182     function safeTransferFrom(
183         address from,
184         address to,
185         uint256 tokenId,
186         bytes calldata data
187     ) external;
188 }
189 
190 
191 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
192 
193 
194 
195 pragma solidity ^0.8.0;
196 
197 
198 /**
199  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
200  * @dev See https://eips.ethereum.org/EIPS/eip-721
201  */
202 interface IERC721Enumerable is IERC721 {
203     /**
204      * @dev Returns the total amount of tokens stored by the contract.
205      */
206     function totalSupply() external view returns (uint256);
207 
208     /**
209      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
210      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
211      */
212     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
213 
214     /**
215      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
216      * Use along with {totalSupply} to enumerate all tokens.
217      */
218     function tokenByIndex(uint256 index) external view returns (uint256);
219 }
220 
221 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
222 
223 
224 
225 pragma solidity ^0.8.0;
226 
227 
228 /**
229  * @dev Implementation of the {IERC165} interface.
230  *
231  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
232  * for the additional interface id that will be supported. For example:
233  *
234  * ```solidity
235  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
236  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
237  * }
238  * ```
239  *
240  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
241  */
242 abstract contract ERC165 is IERC165 {
243     /**
244      * @dev See {IERC165-supportsInterface}.
245      */
246     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
247         return interfaceId == type(IERC165).interfaceId;
248     }
249 }
250 
251 // File: @openzeppelin/contracts/utils/Strings.sol
252 
253 
254 
255 pragma solidity ^0.8.0;
256 
257 /**
258  * @dev String operations.
259  */
260 library Strings {
261     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
262 
263     /**
264      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
265      */
266     function toString(uint256 value) internal pure returns (string memory) {
267         // Inspired by OraclizeAPI's implementation - MIT licence
268         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
269 
270         if (value == 0) {
271             return "0";
272         }
273         uint256 temp = value;
274         uint256 digits;
275         while (temp != 0) {
276             digits++;
277             temp /= 10;
278         }
279         bytes memory buffer = new bytes(digits);
280         while (value != 0) {
281             digits -= 1;
282             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
283             value /= 10;
284         }
285         return string(buffer);
286     }
287 
288     /**
289      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
290      */
291     function toHexString(uint256 value) internal pure returns (string memory) {
292         if (value == 0) {
293             return "0x00";
294         }
295         uint256 temp = value;
296         uint256 length = 0;
297         while (temp != 0) {
298             length++;
299             temp >>= 8;
300         }
301         return toHexString(value, length);
302     }
303 
304     /**
305      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
306      */
307     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
308         bytes memory buffer = new bytes(2 * length + 2);
309         buffer[0] = "0";
310         buffer[1] = "x";
311         for (uint256 i = 2 * length + 1; i > 1; --i) {
312             buffer[i] = _HEX_SYMBOLS[value & 0xf];
313             value >>= 4;
314         }
315         require(value == 0, "Strings: hex length insufficient");
316         return string(buffer);
317     }
318 }
319 
320 // File: @openzeppelin/contracts/utils/Address.sol
321 
322 
323 
324 pragma solidity ^0.8.0;
325 
326 /**
327  * @dev Collection of functions related to the address type
328  */
329 library Address {
330     /**
331      * @dev Returns true if `account` is a contract.
332      *
333      * [IMPORTANT]
334      * ====
335      * It is unsafe to assume that an address for which this function returns
336      * false is an externally-owned account (EOA) and not a contract.
337      *
338      * Among others, `isContract` will return false for the following
339      * types of addresses:
340      *
341      *  - an externally-owned account
342      *  - a contract in construction
343      *  - an address where a contract will be created
344      *  - an address where a contract lived, but was destroyed
345      * ====
346      */
347     function isContract(address account) internal view returns (bool) {
348         // This method relies on extcodesize, which returns 0 for contracts in
349         // construction, since the code is only stored at the end of the
350         // constructor execution.
351 
352         uint256 size;
353         assembly {
354             size := extcodesize(account)
355         }
356         return size > 0;
357     }
358 
359     /**
360      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
361      * `recipient`, forwarding all available gas and reverting on errors.
362      *
363      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
364      * of certain opcodes, possibly making contracts go over the 2300 gas limit
365      * imposed by `transfer`, making them unable to receive funds via
366      * `transfer`. {sendValue} removes this limitation.
367      *
368      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
369      *
370      * IMPORTANT: because control is transferred to `recipient`, care must be
371      * taken to not create reentrancy vulnerabilities. Consider using
372      * {ReentrancyGuard} or the
373      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
374      */
375     function sendValue(address payable recipient, uint256 amount) internal {
376         require(address(this).balance >= amount, "Address: insufficient balance");
377 
378         (bool success, ) = recipient.call{value: amount}("");
379         require(success, "Address: unable to send value, recipient may have reverted");
380     }
381 
382     /**
383      * @dev Performs a Solidity function call using a low level `call`. A
384      * plain `call` is an unsafe replacement for a function call: use this
385      * function instead.
386      *
387      * If `target` reverts with a revert reason, it is bubbled up by this
388      * function (like regular Solidity function calls).
389      *
390      * Returns the raw returned data. To convert to the expected return value,
391      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
392      *
393      * Requirements:
394      *
395      * - `target` must be a contract.
396      * - calling `target` with `data` must not revert.
397      *
398      * _Available since v3.1._
399      */
400     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
401         return functionCall(target, data, "Address: low-level call failed");
402     }
403 
404     /**
405      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
406      * `errorMessage` as a fallback revert reason when `target` reverts.
407      *
408      * _Available since v3.1._
409      */
410     function functionCall(
411         address target,
412         bytes memory data,
413         string memory errorMessage
414     ) internal returns (bytes memory) {
415         return functionCallWithValue(target, data, 0, errorMessage);
416     }
417 
418     /**
419      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
420      * but also transferring `value` wei to `target`.
421      *
422      * Requirements:
423      *
424      * - the calling contract must have an ETH balance of at least `value`.
425      * - the called Solidity function must be `payable`.
426      *
427      * _Available since v3.1._
428      */
429     function functionCallWithValue(
430         address target,
431         bytes memory data,
432         uint256 value
433     ) internal returns (bytes memory) {
434         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
435     }
436 
437     /**
438      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
439      * with `errorMessage` as a fallback revert reason when `target` reverts.
440      *
441      * _Available since v3.1._
442      */
443     function functionCallWithValue(
444         address target,
445         bytes memory data,
446         uint256 value,
447         string memory errorMessage
448     ) internal returns (bytes memory) {
449         require(address(this).balance >= value, "Address: insufficient balance for call");
450         require(isContract(target), "Address: call to non-contract");
451 
452         (bool success, bytes memory returndata) = target.call{value: value}(data);
453         return verifyCallResult(success, returndata, errorMessage);
454     }
455 
456     /**
457      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
458      * but performing a static call.
459      *
460      * _Available since v3.3._
461      */
462     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
463         return functionStaticCall(target, data, "Address: low-level static call failed");
464     }
465 
466     /**
467      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
468      * but performing a static call.
469      *
470      * _Available since v3.3._
471      */
472     function functionStaticCall(
473         address target,
474         bytes memory data,
475         string memory errorMessage
476     ) internal view returns (bytes memory) {
477         require(isContract(target), "Address: static call to non-contract");
478 
479         (bool success, bytes memory returndata) = target.staticcall(data);
480         return verifyCallResult(success, returndata, errorMessage);
481     }
482 
483     /**
484      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
485      * but performing a delegate call.
486      *
487      * _Available since v3.4._
488      */
489     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
490         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
491     }
492 
493     /**
494      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
495      * but performing a delegate call.
496      *
497      * _Available since v3.4._
498      */
499     function functionDelegateCall(
500         address target,
501         bytes memory data,
502         string memory errorMessage
503     ) internal returns (bytes memory) {
504         require(isContract(target), "Address: delegate call to non-contract");
505 
506         (bool success, bytes memory returndata) = target.delegatecall(data);
507         return verifyCallResult(success, returndata, errorMessage);
508     }
509 
510     /**
511      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
512      * revert reason using the provided one.
513      *
514      * _Available since v4.3._
515      */
516     function verifyCallResult(
517         bool success,
518         bytes memory returndata,
519         string memory errorMessage
520     ) internal pure returns (bytes memory) {
521         if (success) {
522             return returndata;
523         } else {
524             // Look for revert reason and bubble it up if present
525             if (returndata.length > 0) {
526                 // The easiest way to bubble the revert reason is using memory via assembly
527 
528                 assembly {
529                     let returndata_size := mload(returndata)
530                     revert(add(32, returndata), returndata_size)
531                 }
532             } else {
533                 revert(errorMessage);
534             }
535         }
536     }
537 }
538 
539 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
540 
541 
542 
543 pragma solidity ^0.8.0;
544 
545 
546 /**
547  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
548  * @dev See https://eips.ethereum.org/EIPS/eip-721
549  */
550 interface IERC721Metadata is IERC721 {
551     /**
552      * @dev Returns the token collection name.
553      */
554     function name() external view returns (string memory);
555 
556     /**
557      * @dev Returns the token collection symbol.
558      */
559     function symbol() external view returns (string memory);
560 
561     /**
562      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
563      */
564     function tokenURI(uint256 tokenId) external view returns (string memory);
565 }
566 
567 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
568 
569 
570 
571 pragma solidity ^0.8.0;
572 
573 /**
574  * @title ERC721 token receiver interface
575  * @dev Interface for any contract that wants to support safeTransfers
576  * from ERC721 asset contracts.
577  */
578 interface IERC721Receiver {
579     /**
580      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
581      * by `operator` from `from`, this function is called.
582      *
583      * It must return its Solidity selector to confirm the token transfer.
584      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
585      *
586      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
587      */
588     function onERC721Received(
589         address operator,
590         address from,
591         uint256 tokenId,
592         bytes calldata data
593     ) external returns (bytes4);
594 }
595 
596 
597 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
598 pragma solidity ^0.8.0;
599 /**
600  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
601  * the Metadata extension, but not including the Enumerable extension, which is available separately as
602  * {ERC721Enumerable}.
603  */
604 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
605     using Address for address;
606     using Strings for uint256;
607 
608     // Token name
609     string private _name;
610 
611     // Token symbol
612     string private _symbol;
613 
614     // Mapping from token ID to owner address
615     mapping(uint256 => address) private _owners;
616 
617     // Mapping owner address to token count
618     mapping(address => uint256) private _balances;
619 
620     // Mapping from token ID to approved address
621     mapping(uint256 => address) private _tokenApprovals;
622 
623     // Mapping from owner to operator approvals
624     mapping(address => mapping(address => bool)) private _operatorApprovals;
625 
626     /**
627      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
628      */
629     constructor(string memory name_, string memory symbol_) {
630         _name = name_;
631         _symbol = symbol_;
632     }
633 
634     /**
635      * @dev See {IERC165-supportsInterface}.
636      */
637     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
638         return
639             interfaceId == type(IERC721).interfaceId ||
640             interfaceId == type(IERC721Metadata).interfaceId ||
641             super.supportsInterface(interfaceId);
642     }
643 
644     /**
645      * @dev See {IERC721-balanceOf}.
646      */
647     function balanceOf(address owner) public view virtual override returns (uint256) {
648         require(owner != address(0), "ERC721: balance query for the zero address");
649         return _balances[owner];
650     }
651 
652     /**
653      * @dev See {IERC721-ownerOf}.
654      */
655     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
656         address owner = _owners[tokenId];
657         require(owner != address(0), "ERC721: owner query for nonexistent token");
658         return owner;
659     }
660 
661     /**
662      * @dev See {IERC721Metadata-name}.
663      */
664     function name() public view virtual override returns (string memory) {
665         return _name;
666     }
667 
668     /**
669      * @dev See {IERC721Metadata-symbol}.
670      */
671     function symbol() public view virtual override returns (string memory) {
672         return _symbol;
673     }
674 
675     /**
676      * @dev See {IERC721Metadata-tokenURI}.
677      */
678     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
679         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
680 
681         string memory baseURI = _baseURI();
682         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
683     }
684 
685     /**
686      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
687      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
688      * by default, can be overriden in child contracts.
689      */
690     function _baseURI() internal view virtual returns (string memory) {
691         return "";
692     }
693 
694     /**
695      * @dev See {IERC721-approve}.
696      */
697     function approve(address to, uint256 tokenId) public virtual override {
698         address owner = ERC721.ownerOf(tokenId);
699         require(to != owner, "ERC721: approval to current owner");
700 
701         require(
702             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
703             "ERC721: approve caller is not owner nor approved for all"
704         );
705 
706         _approve(to, tokenId);
707     }
708 
709     /**
710      * @dev See {IERC721-getApproved}.
711      */
712     function getApproved(uint256 tokenId) public view virtual override returns (address) {
713         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
714 
715         return _tokenApprovals[tokenId];
716     }
717 
718     /**
719      * @dev See {IERC721-setApprovalForAll}.
720      */
721     function setApprovalForAll(address operator, bool approved) public virtual override {
722         require(operator != _msgSender(), "ERC721: approve to caller");
723 
724         _operatorApprovals[_msgSender()][operator] = approved;
725         emit ApprovalForAll(_msgSender(), operator, approved);
726     }
727 
728     /**
729      * @dev See {IERC721-isApprovedForAll}.
730      */
731     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
732         return _operatorApprovals[owner][operator];
733     }
734 
735     /**
736      * @dev See {IERC721-transferFrom}.
737      */
738     function transferFrom(
739         address from,
740         address to,
741         uint256 tokenId
742     ) public virtual override {
743         //solhint-disable-next-line max-line-length
744         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
745 
746         _transfer(from, to, tokenId);
747     }
748 
749     /**
750      * @dev See {IERC721-safeTransferFrom}.
751      */
752     function safeTransferFrom(
753         address from,
754         address to,
755         uint256 tokenId
756     ) public virtual override {
757         safeTransferFrom(from, to, tokenId, "");
758     }
759 
760     /**
761      * @dev See {IERC721-safeTransferFrom}.
762      */
763     function safeTransferFrom(
764         address from,
765         address to,
766         uint256 tokenId,
767         bytes memory _data
768     ) public virtual override {
769         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
770         _safeTransfer(from, to, tokenId, _data);
771     }
772 
773     /**
774      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
775      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
776      *
777      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
778      *
779      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
780      * implement alternative mechanisms to perform token transfer, such as signature-based.
781      *
782      * Requirements:
783      *
784      * - `from` cannot be the zero address.
785      * - `to` cannot be the zero address.
786      * - `tokenId` token must exist and be owned by `from`.
787      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
788      *
789      * Emits a {Transfer} event.
790      */
791     function _safeTransfer(
792         address from,
793         address to,
794         uint256 tokenId,
795         bytes memory _data
796     ) internal virtual {
797         _transfer(from, to, tokenId);
798         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
799     }
800 
801     /**
802      * @dev Returns whether `tokenId` exists.
803      *
804      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
805      *
806      * Tokens start existing when they are minted (`_mint`),
807      * and stop existing when they are burned (`_burn`).
808      */
809     function _exists(uint256 tokenId) internal view virtual returns (bool) {
810         return _owners[tokenId] != address(0);
811     }
812 
813     /**
814      * @dev Returns whether `spender` is allowed to manage `tokenId`.
815      *
816      * Requirements:
817      *
818      * - `tokenId` must exist.
819      */
820     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
821         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
822         address owner = ERC721.ownerOf(tokenId);
823         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
824     }
825 
826     /**
827      * @dev Safely mints `tokenId` and transfers it to `to`.
828      *
829      * Requirements:
830      *
831      * - `tokenId` must not exist.
832      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
833      *
834      * Emits a {Transfer} event.
835      */
836     function _safeMint(address to, uint256 tokenId) internal virtual {
837         _safeMint(to, tokenId, "");
838     }
839 
840     /**
841      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
842      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
843      */
844     function _safeMint(
845         address to,
846         uint256 tokenId,
847         bytes memory _data
848     ) internal virtual {
849         _mint(to, tokenId);
850         require(
851             _checkOnERC721Received(address(0), to, tokenId, _data),
852             "ERC721: transfer to non ERC721Receiver implementer"
853         );
854     }
855 
856     /**
857      * @dev Mints `tokenId` and transfers it to `to`.
858      *
859      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
860      *
861      * Requirements:
862      *
863      * - `tokenId` must not exist.
864      * - `to` cannot be the zero address.
865      *
866      * Emits a {Transfer} event.
867      */
868     function _mint(address to, uint256 tokenId) internal virtual {
869         require(to != address(0), "ERC721: mint to the zero address");
870         require(!_exists(tokenId), "ERC721: token already minted");
871 
872         _beforeTokenTransfer(address(0), to, tokenId);
873 
874         _balances[to] += 1;
875         _owners[tokenId] = to;
876 
877         emit Transfer(address(0), to, tokenId);
878     }
879 
880     /**
881      * @dev Destroys `tokenId`.
882      * The approval is cleared when the token is burned.
883      *
884      * Requirements:
885      *
886      * - `tokenId` must exist.
887      *
888      * Emits a {Transfer} event.
889      */
890     function _burn(uint256 tokenId) internal virtual {
891         address owner = ERC721.ownerOf(tokenId);
892 
893         _beforeTokenTransfer(owner, address(0), tokenId);
894 
895         // Clear approvals
896         _approve(address(0), tokenId);
897 
898         _balances[owner] -= 1;
899         delete _owners[tokenId];
900 
901         emit Transfer(owner, address(0), tokenId);
902     }
903 
904     /**
905      * @dev Transfers `tokenId` from `from` to `to`.
906      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
907      *
908      * Requirements:
909      *
910      * - `to` cannot be the zero address.
911      * - `tokenId` token must be owned by `from`.
912      *
913      * Emits a {Transfer} event.
914      */
915     function _transfer(
916         address from,
917         address to,
918         uint256 tokenId
919     ) internal virtual {
920         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
921         require(to != address(0), "ERC721: transfer to the zero address");
922 
923         _beforeTokenTransfer(from, to, tokenId);
924 
925         // Clear approvals from the previous owner
926         _approve(address(0), tokenId);
927 
928         _balances[from] -= 1;
929         _balances[to] += 1;
930         _owners[tokenId] = to;
931 
932         emit Transfer(from, to, tokenId);
933     }
934 
935     /**
936      * @dev Approve `to` to operate on `tokenId`
937      *
938      * Emits a {Approval} event.
939      */
940     function _approve(address to, uint256 tokenId) internal virtual {
941         _tokenApprovals[tokenId] = to;
942         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
943     }
944 
945     /**
946      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
947      * The call is not executed if the target address is not a contract.
948      *
949      * @param from address representing the previous owner of the given token ID
950      * @param to target address that will receive the tokens
951      * @param tokenId uint256 ID of the token to be transferred
952      * @param _data bytes optional data to send along with the call
953      * @return bool whether the call correctly returned the expected magic value
954      */
955     function _checkOnERC721Received(
956         address from,
957         address to,
958         uint256 tokenId,
959         bytes memory _data
960     ) private returns (bool) {
961         if (to.isContract()) {
962             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
963                 return retval == IERC721Receiver.onERC721Received.selector;
964             } catch (bytes memory reason) {
965                 if (reason.length == 0) {
966                     revert("ERC721: transfer to non ERC721Receiver implementer");
967                 } else {
968                     assembly {
969                         revert(add(32, reason), mload(reason))
970                     }
971                 }
972             }
973         } else {
974             return true;
975         }
976     }
977 
978     /**
979      * @dev Hook that is called before any token transfer. This includes minting
980      * and burning.
981      *
982      * Calling conditions:
983      *
984      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
985      * transferred to `to`.
986      * - When `from` is zero, `tokenId` will be minted for `to`.
987      * - When `to` is zero, ``from``'s `tokenId` will be burned.
988      * - `from` and `to` are never both zero.
989      *
990      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
991      */
992     function _beforeTokenTransfer(
993         address from,
994         address to,
995         uint256 tokenId
996     ) internal virtual {}
997 }
998 
999 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1000 
1001 
1002 
1003 pragma solidity ^0.8.0;
1004 
1005 
1006 
1007 /**
1008  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1009  * enumerability of all the token ids in the contract as well as all token ids owned by each
1010  * account.
1011  */
1012 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1013     // Mapping from owner to list of owned token IDs
1014     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1015 
1016     // Mapping from token ID to index of the owner tokens list
1017     mapping(uint256 => uint256) private _ownedTokensIndex;
1018 
1019     // Array with all token ids, used for enumeration
1020     uint256[] private _allTokens;
1021 
1022     // Mapping from token id to position in the allTokens array
1023     mapping(uint256 => uint256) private _allTokensIndex;
1024 
1025     /**
1026      * @dev See {IERC165-supportsInterface}.
1027      */
1028     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1029         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1030     }
1031 
1032     /**
1033      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1034      */
1035     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1036         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1037         return _ownedTokens[owner][index];
1038     }
1039 
1040     /**
1041      * @dev See {IERC721Enumerable-totalSupply}.
1042      */
1043     function totalSupply() public view virtual override returns (uint256) {
1044         return _allTokens.length;
1045     }
1046 
1047     /**
1048      * @dev See {IERC721Enumerable-tokenByIndex}.
1049      */
1050     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1051         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1052         return _allTokens[index];
1053     }
1054 
1055     /**
1056      * @dev Hook that is called before any token transfer. This includes minting
1057      * and burning.
1058      *
1059      * Calling conditions:
1060      *
1061      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1062      * transferred to `to`.
1063      * - When `from` is zero, `tokenId` will be minted for `to`.
1064      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1065      * - `from` cannot be the zero address.
1066      * - `to` cannot be the zero address.
1067      *
1068      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1069      */
1070     function _beforeTokenTransfer(
1071         address from,
1072         address to,
1073         uint256 tokenId
1074     ) internal virtual override {
1075         super._beforeTokenTransfer(from, to, tokenId);
1076 
1077         if (from == address(0)) {
1078             _addTokenToAllTokensEnumeration(tokenId);
1079         } else if (from != to) {
1080             _removeTokenFromOwnerEnumeration(from, tokenId);
1081         }
1082         if (to == address(0)) {
1083             _removeTokenFromAllTokensEnumeration(tokenId);
1084         } else if (to != from) {
1085             _addTokenToOwnerEnumeration(to, tokenId);
1086         }
1087     }
1088 
1089     /**
1090      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1091      * @param to address representing the new owner of the given token ID
1092      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1093      */
1094     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1095         uint256 length = ERC721.balanceOf(to);
1096         _ownedTokens[to][length] = tokenId;
1097         _ownedTokensIndex[tokenId] = length;
1098     }
1099 
1100     /**
1101      * @dev Private function to add a token to this extension's token tracking data structures.
1102      * @param tokenId uint256 ID of the token to be added to the tokens list
1103      */
1104     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1105         _allTokensIndex[tokenId] = _allTokens.length;
1106         _allTokens.push(tokenId);
1107     }
1108 
1109     /**
1110      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1111      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1112      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1113      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1114      * @param from address representing the previous owner of the given token ID
1115      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1116      */
1117     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1118         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1119         // then delete the last slot (swap and pop).
1120 
1121         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1122         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1123 
1124         // When the token to delete is the last token, the swap operation is unnecessary
1125         if (tokenIndex != lastTokenIndex) {
1126             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1127 
1128             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1129             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1130         }
1131 
1132         // This also deletes the contents at the last position of the array
1133         delete _ownedTokensIndex[tokenId];
1134         delete _ownedTokens[from][lastTokenIndex];
1135     }
1136 
1137     /**
1138      * @dev Private function to remove a token from this extension's token tracking data structures.
1139      * This has O(1) time complexity, but alters the order of the _allTokens array.
1140      * @param tokenId uint256 ID of the token to be removed from the tokens list
1141      */
1142     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1143         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1144         // then delete the last slot (swap and pop).
1145 
1146         uint256 lastTokenIndex = _allTokens.length - 1;
1147         uint256 tokenIndex = _allTokensIndex[tokenId];
1148 
1149         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1150         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1151         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1152         uint256 lastTokenId = _allTokens[lastTokenIndex];
1153 
1154         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1155         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1156 
1157         // This also deletes the contents at the last position of the array
1158         delete _allTokensIndex[tokenId];
1159         _allTokens.pop();
1160     }
1161 }
1162 
1163 // File: @openzeppelin/contracts/access/Ownable.sol
1164 
1165 
1166 
1167 pragma solidity ^0.8.0;
1168 
1169 
1170 /**
1171  * @dev Contract module which provides a basic access control mechanism, where
1172  * there is an account (an owner) that can be granted exclusive access to
1173  * specific functions.
1174  *
1175  * By default, the owner account will be the one that deploys the contract. This
1176  * can later be changed with {transferOwnership}.
1177  *
1178  * This module is used through inheritance. It will make available the modifier
1179  * `onlyOwner`, which can be applied to your functions to restrict their use to
1180  * the owner.
1181  */
1182 abstract contract Ownable is Context {
1183     address private _owner;
1184 
1185     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1186 
1187     /**
1188      * @dev Initializes the contract setting the deployer as the initial owner.
1189      */
1190     constructor() {
1191         _setOwner(_msgSender());
1192     }
1193 
1194     /**
1195      * @dev Returns the address of the current owner.
1196      */
1197     function owner() public view virtual returns (address) {
1198         return _owner;
1199     }
1200 
1201     /**
1202      * @dev Throws if called by any account other than the owner.
1203      */
1204     modifier onlyOwner() {
1205         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1206         _;
1207     }
1208 
1209     /**
1210      * @dev Leaves the contract without owner. It will not be possible to call
1211      * `onlyOwner` functions anymore. Can only be called by the current owner.
1212      *
1213      * NOTE: Renouncing ownership will leave the contract without an owner,
1214      * thereby removing any functionality that is only available to the owner.
1215      */
1216     function renounceOwnership() public virtual onlyOwner {
1217         _setOwner(address(0));
1218     }
1219 
1220     /**
1221      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1222      * Can only be called by the current owner.
1223      */
1224     function transferOwnership(address newOwner) public virtual onlyOwner {
1225         require(newOwner != address(0), "Ownable: new owner is the zero address");
1226         _setOwner(newOwner);
1227     }
1228 
1229     function _setOwner(address newOwner) private {
1230         address oldOwner = _owner;
1231         _owner = newOwner;
1232         emit OwnershipTransferred(oldOwner, newOwner);
1233     }
1234 }
1235 
1236 pragma solidity ^0.8.0;
1237 
1238 contract Kishuverse is ERC721Enumerable, Ownable {
1239     using Strings for uint256;
1240     
1241     string public baseURI;
1242     string public baseExtension = ".json";
1243         uint256 public cost = 0.038 ether;
1244     uint256 public maxSupply = 8888;
1245     uint256 public maxMintAmount = 2;
1246     bool public paused = false;
1247     
1248     constructor(
1249         string memory _name,
1250         string memory _symbol,
1251         string memory _initBaseURI
1252         ) ERC721(_name, _symbol) {
1253             
1254             setBaseURI(_initBaseURI);
1255             mint(msg.sender, 2);
1256             maxMintAmount = 1;
1257             paused = true;
1258             
1259         }
1260         
1261         // internal
1262         function _baseURI() internal view virtual override returns (string memory) {
1263             return baseURI;
1264         }
1265         
1266         // public
1267         function mint(address _to, uint256 _mintAmount) public payable {
1268             uint256 supply = totalSupply();
1269             require(!paused);
1270             require(_mintAmount > 0);
1271             require(_mintAmount <= maxMintAmount);
1272             require(supply + _mintAmount <= maxSupply);
1273             
1274             if (msg.sender != owner()) {
1275             require(msg.value == cost * _mintAmount, "Need to send 0.038 ether!");
1276             }
1277             
1278             for (uint256 i = 1; i <= _mintAmount; i++) {
1279                 _safeMint(_to, supply + i);
1280             }
1281         }
1282         
1283         function walletOfOwner(address _owner)
1284         public
1285         view
1286         returns (uint256[] memory)
1287         {
1288             uint256 ownerTokenCount = balanceOf(_owner);
1289             uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1290             for (uint256 i; i < ownerTokenCount; i++) {
1291                 tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1292             }
1293             return tokenIds;
1294         }
1295     
1296         
1297         function tokenURI(uint256 tokenId)
1298         public
1299         view
1300         virtual
1301         override
1302         returns (string memory) {
1303             require(
1304                 _exists(tokenId),
1305                 "ERC721Metadata: URI query for nonexistent token"
1306                 );
1307                 
1308                 string memory currentBaseURI = _baseURI();
1309                 return
1310                 bytes(currentBaseURI).length > 0 
1311                 ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1312                 : "";
1313         }
1314         
1315         // only owner
1316         
1317         function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner() {
1318             maxMintAmount = _newmaxMintAmount;
1319         }
1320         
1321         function setBaseURI(string memory _newBaseURI) public onlyOwner() {
1322             baseURI = _newBaseURI;
1323         }
1324         
1325         function setBaseExtension(string memory _newBaseExtension) public onlyOwner() {
1326             baseExtension = _newBaseExtension;
1327         }
1328         
1329         function pause(bool _state) public onlyOwner() {
1330             paused = _state;
1331         }
1332         
1333         function withdraw() public payable onlyOwner() {
1334             require(payable(msg.sender).send(address(this).balance));
1335         }
1336 }