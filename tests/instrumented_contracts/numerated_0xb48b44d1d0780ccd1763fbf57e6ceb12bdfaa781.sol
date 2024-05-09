1 // SPDX-License-Identifier: MIT
2 
3 // Amended by Jobuii
4 
5 /**
6     !Disclaimer!
7     
8     Please be aware that this smart contract is part of an experiment to
9     see how the blockchain can handle this kind of logic. The developer
10     will not be responsible or liable for all loss or damage whatsoever
11     caused by you participating in any way in the experimental code,
12     whether putting money into the contract or using the code for your
13     own project.
14     
15     You acknowledge the funds in the contract will be seen as donations to 
16     participate and the rewards are seen as a gift for saying thank you. 
17     
18     If you live in a country that prohibits you from participating 
19     in this kind of experiment, then please refrain from doing so. 
20     Make sure you fully understand the code and what the logic does before 
21     interacting with it.
22     
23     We are not financial advisors. In order to make the best financial 
24     decision that suits your own needs, you must conduct your own research 
25     and seek the advice of a licensed financial advisor if necessary.
26 */
27 
28 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
29 
30 pragma solidity ^0.8.0;
31 
32 /**
33  * @dev Interface of the ERC165 standard, as defined in the
34  * https://eips.ethereum.org/EIPS/eip-165[EIP].
35  *
36  * Implementers can declare support of contract interfaces, which can then be
37  * queried by others ({ERC165Checker}).
38  *
39  * For an implementation, see {ERC165}.
40  */
41  
42 interface IERC165 {
43     /**
44      * @dev Returns true if this contract implements the interface defined by
45      * `interfaceId`. See the corresponding
46      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
47      * to learn more about how these ids are created.
48      *
49      * This function call must use less than 30 000 gas.
50      */
51     function supportsInterface(bytes4 interfaceId) external view returns (bool);
52 }
53 
54 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
55 
56 pragma solidity ^0.8.0;
57 
58 /**
59  * @dev Required interface of an ERC721 compliant contract.
60  */
61  
62 interface IERC721 is IERC165 {
63     /**
64      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
65      */
66     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
67 
68     /**
69      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
70      */
71     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
72 
73     /**
74      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
75      */
76     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
77 
78     /**
79      * @dev Returns the number of tokens in ``owner``'s account.
80      */
81     function balanceOf(address owner) external view returns (uint256 balance);
82 
83     /**
84      * @dev Returns the owner of the `tokenId` token.
85      *
86      * Requirements:
87      *
88      * - `tokenId` must exist.
89      */
90     function ownerOf(uint256 tokenId) external view returns (address owner);
91 
92     /**
93      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
94      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
95      *
96      * Requirements:
97      *
98      * - `from` cannot be the zero address.
99      * - `to` cannot be the zero address.
100      * - `tokenId` token must exist and be owned by `from`.
101      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
102      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
103      *
104      * Emits a {Transfer} event.
105      */
106     function safeTransferFrom(
107         address from,
108         address to,
109         uint256 tokenId
110     ) external;
111 
112     /**
113      * @dev Transfers `tokenId` token from `from` to `to`.
114      *
115      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
116      *
117      * Requirements:
118      *
119      * - `from` cannot be the zero address.
120      * - `to` cannot be the zero address.
121      * - `tokenId` token must be owned by `from`.
122      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
123      *
124      * Emits a {Transfer} event.
125      */
126     function transferFrom(
127         address from,
128         address to,
129         uint256 tokenId
130     ) external;
131 
132     /**
133      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
134      * The approval is cleared when the token is transferred.
135      *
136      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
137      *
138      * Requirements:
139      *
140      * - The caller must own the token or be an approved operator.
141      * - `tokenId` must exist.
142      *
143      * Emits an {Approval} event.
144      */
145     function approve(address to, uint256 tokenId) external;
146 
147     /**
148      * @dev Returns the account approved for `tokenId` token.
149      *
150      * Requirements:
151      *
152      * - `tokenId` must exist.
153      */
154     function getApproved(uint256 tokenId) external view returns (address operator);
155 
156     /**
157      * @dev Approve or remove `operator` as an operator for the caller.
158      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
159      *
160      * Requirements:
161      *
162      * - The `operator` cannot be the caller.
163      *
164      * Emits an {ApprovalForAll} event.
165      */
166     function setApprovalForAll(address operator, bool _approved) external;
167 
168     /**
169      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
170      *
171      * See {setApprovalForAll}
172      */
173     function isApprovedForAll(address owner, address operator) external view returns (bool);
174 
175     /**
176      * @dev Safely transfers `tokenId` token from `from` to `to`.
177      *
178      * Requirements:
179      *
180      * - `from` cannot be the zero address.
181      * - `to` cannot be the zero address.
182      * - `tokenId` token must exist and be owned by `from`.
183      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
184      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
185      *
186      * Emits a {Transfer} event.
187      */
188     function safeTransferFrom(
189         address from,
190         address to,
191         uint256 tokenId,
192         bytes calldata data
193     ) external;
194 }
195 
196 
197 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
198 
199 pragma solidity ^0.8.0;
200 
201 /**
202  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
203  * @dev See https://eips.ethereum.org/EIPS/eip-721
204  */
205 interface IERC721Enumerable is IERC721 {
206     /**
207      * @dev Returns the total amount of tokens stored by the contract.
208      */
209     function totalSupply() external view returns (uint256);
210 
211     /**
212      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
213      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
214      */
215     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
216 
217     /**
218      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
219      * Use along with {totalSupply} to enumerate all tokens.
220      */
221     function tokenByIndex(uint256 index) external view returns (uint256);
222 }
223 
224 
225 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
226 pragma solidity ^0.8.0;
227 /**
228  * @dev Implementation of the {IERC165} interface.
229  *
230  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
231  * for the additional interface id that will be supported. For example:
232  *
233  * ```solidity
234  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
235  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
236  * }
237  * ```
238  *
239  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
240  */
241 abstract contract ERC165 is IERC165 {
242     /**
243      * @dev See {IERC165-supportsInterface}.
244      */
245     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
246         return interfaceId == type(IERC165).interfaceId;
247     }
248 }
249 
250 // File: @openzeppelin/contracts/utils/Strings.sol
251 
252 
253 
254 pragma solidity ^0.8.0;
255 
256 /**
257  * @dev String operations.
258  */
259 library Strings {
260     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
261 
262     /**
263      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
264      */
265     function toString(uint256 value) internal pure returns (string memory) {
266         // Inspired by OraclizeAPI's implementation - MIT licence
267         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
268 
269         if (value == 0) {
270             return "0";
271         }
272         uint256 temp = value;
273         uint256 digits;
274         while (temp != 0) {
275             digits++;
276             temp /= 10;
277         }
278         bytes memory buffer = new bytes(digits);
279         while (value != 0) {
280             digits -= 1;
281             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
282             value /= 10;
283         }
284         return string(buffer);
285     }
286 
287     /**
288      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
289      */
290     function toHexString(uint256 value) internal pure returns (string memory) {
291         if (value == 0) {
292             return "0x00";
293         }
294         uint256 temp = value;
295         uint256 length = 0;
296         while (temp != 0) {
297             length++;
298             temp >>= 8;
299         }
300         return toHexString(value, length);
301     }
302 
303     /**
304      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
305      */
306     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
307         bytes memory buffer = new bytes(2 * length + 2);
308         buffer[0] = "0";
309         buffer[1] = "x";
310         for (uint256 i = 2 * length + 1; i > 1; --i) {
311             buffer[i] = _HEX_SYMBOLS[value & 0xf];
312             value >>= 4;
313         }
314         require(value == 0, "Strings: hex length insufficient");
315         return string(buffer);
316     }
317 }
318 
319 // File: @openzeppelin/contracts/utils/Address.sol
320 
321 
322 
323 pragma solidity ^0.8.0;
324 
325 /**
326  * @dev Collection of functions related to the address type
327  */
328 library Address {
329     /**
330      * @dev Returns true if `account` is a contract.
331      *
332      * [IMPORTANT]
333      * ====
334      * It is unsafe to assume that an address for which this function returns
335      * false is an externally-owned account (EOA) and not a contract.
336      *
337      * Among others, `isContract` will return false for the following
338      * types of addresses:
339      *
340      *  - an externally-owned account
341      *  - a contract in construction
342      *  - an address where a contract will be created
343      *  - an address where a contract lived, but was destroyed
344      * ====
345      */
346     function isContract(address account) internal view returns (bool) {
347         // This method relies on extcodesize, which returns 0 for contracts in
348         // construction, since the code is only stored at the end of the
349         // constructor execution.
350 
351         uint256 size;
352         assembly {
353             size := extcodesize(account)
354         }
355         return size > 0;
356     }
357 
358     /**
359      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
360      * `recipient`, forwarding all available gas and reverting on errors.
361      *
362      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
363      * of certain opcodes, possibly making contracts go over the 2300 gas limit
364      * imposed by `transfer`, making them unable to receive funds via
365      * `transfer`. {sendValue} removes this limitation.
366      *
367      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
368      *
369      * IMPORTANT: because control is transferred to `recipient`, care must be
370      * taken to not create reentrancy vulnerabilities. Consider using
371      * {ReentrancyGuard} or the
372      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
373      */
374     function sendValue(address payable recipient, uint256 amount) internal {
375         require(address(this).balance >= amount, "Address: insufficient balance");
376 
377         (bool success, ) = recipient.call{value: amount}("");
378         require(success, "Address: unable to send value, recipient may have reverted");
379     }
380 
381     /**
382      * @dev Performs a Solidity function call using a low level `call`. A
383      * plain `call` is an unsafe replacement for a function call: use this
384      * function instead.
385      *
386      * If `target` reverts with a revert reason, it is bubbled up by this
387      * function (like regular Solidity function calls).
388      *
389      * Returns the raw returned data. To convert to the expected return value,
390      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
391      *
392      * Requirements:
393      *
394      * - `target` must be a contract.
395      * - calling `target` with `data` must not revert.
396      *
397      * _Available since v3.1._
398      */
399     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
400         return functionCall(target, data, "Address: low-level call failed");
401     }
402 
403     /**
404      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
405      * `errorMessage` as a fallback revert reason when `target` reverts.
406      *
407      * _Available since v3.1._
408      */
409     function functionCall(
410         address target,
411         bytes memory data,
412         string memory errorMessage
413     ) internal returns (bytes memory) {
414         return functionCallWithValue(target, data, 0, errorMessage);
415     }
416 
417     /**
418      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
419      * but also transferring `value` wei to `target`.
420      *
421      * Requirements:
422      *
423      * - the calling contract must have an ETH balance of at least `value`.
424      * - the called Solidity function must be `payable`.
425      *
426      * _Available since v3.1._
427      */
428     function functionCallWithValue(
429         address target,
430         bytes memory data,
431         uint256 value
432     ) internal returns (bytes memory) {
433         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
434     }
435 
436     /**
437      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
438      * with `errorMessage` as a fallback revert reason when `target` reverts.
439      *
440      * _Available since v3.1._
441      */
442     function functionCallWithValue(
443         address target,
444         bytes memory data,
445         uint256 value,
446         string memory errorMessage
447     ) internal returns (bytes memory) {
448         require(address(this).balance >= value, "Address: insufficient balance for call");
449         require(isContract(target), "Address: call to non-contract");
450 
451         (bool success, bytes memory returndata) = target.call{value: value}(data);
452         return verifyCallResult(success, returndata, errorMessage);
453     }
454 
455     /**
456      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
457      * but performing a static call.
458      *
459      * _Available since v3.3._
460      */
461     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
462         return functionStaticCall(target, data, "Address: low-level static call failed");
463     }
464 
465     /**
466      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
467      * but performing a static call.
468      *
469      * _Available since v3.3._
470      */
471     function functionStaticCall(
472         address target,
473         bytes memory data,
474         string memory errorMessage
475     ) internal view returns (bytes memory) {
476         require(isContract(target), "Address: static call to non-contract");
477 
478         (bool success, bytes memory returndata) = target.staticcall(data);
479         return verifyCallResult(success, returndata, errorMessage);
480     }
481 
482     /**
483      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
484      * but performing a delegate call.
485      *
486      * _Available since v3.4._
487      */
488     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
489         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
490     }
491 
492     /**
493      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
494      * but performing a delegate call.
495      *
496      * _Available since v3.4._
497      */
498     function functionDelegateCall(
499         address target,
500         bytes memory data,
501         string memory errorMessage
502     ) internal returns (bytes memory) {
503         require(isContract(target), "Address: delegate call to non-contract");
504 
505         (bool success, bytes memory returndata) = target.delegatecall(data);
506         return verifyCallResult(success, returndata, errorMessage);
507     }
508 
509     /**
510      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
511      * revert reason using the provided one.
512      *
513      * _Available since v4.3._
514      */
515     function verifyCallResult(
516         bool success,
517         bytes memory returndata,
518         string memory errorMessage
519     ) internal pure returns (bytes memory) {
520         if (success) {
521             return returndata;
522         } else {
523             // Look for revert reason and bubble it up if present
524             if (returndata.length > 0) {
525                 // The easiest way to bubble the revert reason is using memory via assembly
526 
527                 assembly {
528                     let returndata_size := mload(returndata)
529                     revert(add(32, returndata), returndata_size)
530                 }
531             } else {
532                 revert(errorMessage);
533             }
534         }
535     }
536 }
537 
538 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
539 
540 
541 
542 pragma solidity ^0.8.0;
543 
544 
545 /**
546  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
547  * @dev See https://eips.ethereum.org/EIPS/eip-721
548  */
549 interface IERC721Metadata is IERC721 {
550     /**
551      * @dev Returns the token collection name.
552      */
553     function name() external view returns (string memory);
554 
555     /**
556      * @dev Returns the token collection symbol.
557      */
558     function symbol() external view returns (string memory);
559 
560     /**
561      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
562      */
563     function tokenURI(uint256 tokenId) external view returns (string memory);
564 }
565 
566 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
567 
568 
569 
570 pragma solidity ^0.8.0;
571 
572 /**
573  * @title ERC721 token receiver interface
574  * @dev Interface for any contract that wants to support safeTransfers
575  * from ERC721 asset contracts.
576  */
577 interface IERC721Receiver {
578     /**
579      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
580      * by `operator` from `from`, this function is called.
581      *
582      * It must return its Solidity selector to confirm the token transfer.
583      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
584      *
585      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
586      */
587     function onERC721Received(
588         address operator,
589         address from,
590         uint256 tokenId,
591         bytes calldata data
592     ) external returns (bytes4);
593 }
594 
595 // File: @openzeppelin/contracts/utils/Context.sol
596 pragma solidity ^0.8.0;
597 /**
598  * @dev Provides information about the current execution context, including the
599  * sender of the transaction and its data. While these are generally available
600  * via msg.sender and msg.data, they should not be accessed in such a direct
601  * manner, since when dealing with meta-transactions the account sending and
602  * paying for execution may not be the actual sender (as far as an application
603  * is concerned).
604  *
605  * This contract is only required for intermediate, library-like contracts.
606  */
607 abstract contract Context {
608     function _msgSender() internal view virtual returns (address) {
609         return msg.sender;
610     }
611 
612     function _msgData() internal view virtual returns (bytes calldata) {
613         return msg.data;
614     }
615 }
616 
617 
618 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
619 pragma solidity ^0.8.0;
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
743         require(operator != _msgSender(), "ERC721: approve to caller");
744 
745         _operatorApprovals[_msgSender()][operator] = approved;
746         emit ApprovalForAll(_msgSender(), operator, approved);
747     }
748 
749     /**
750      * @dev See {IERC721-isApprovedForAll}.
751      */
752     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
753         return _operatorApprovals[owner][operator];
754     }
755 
756     /**
757      * @dev See {IERC721-transferFrom}.
758      */
759     function transferFrom(
760         address from,
761         address to,
762         uint256 tokenId
763     ) public virtual override {
764         //solhint-disable-next-line max-line-length
765         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
766 
767         _transfer(from, to, tokenId);
768     }
769 
770     /**
771      * @dev See {IERC721-safeTransferFrom}.
772      */
773     function safeTransferFrom(
774         address from,
775         address to,
776         uint256 tokenId
777     ) public virtual override {
778         safeTransferFrom(from, to, tokenId, "");
779     }
780 
781     /**
782      * @dev See {IERC721-safeTransferFrom}.
783      */
784     function safeTransferFrom(
785         address from,
786         address to,
787         uint256 tokenId,
788         bytes memory _data
789     ) public virtual override {
790         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
791         _safeTransfer(from, to, tokenId, _data);
792     }
793 
794     /**
795      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
796      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
797      *
798      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
799      *
800      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
801      * implement alternative mechanisms to perform token transfer, such as signature-based.
802      *
803      * Requirements:
804      *
805      * - `from` cannot be the zero address.
806      * - `to` cannot be the zero address.
807      * - `tokenId` token must exist and be owned by `from`.
808      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
809      *
810      * Emits a {Transfer} event.
811      */
812     function _safeTransfer(
813         address from,
814         address to,
815         uint256 tokenId,
816         bytes memory _data
817     ) internal virtual {
818         _transfer(from, to, tokenId);
819         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
820     }
821 
822     /**
823      * @dev Returns whether `tokenId` exists.
824      *
825      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
826      *
827      * Tokens start existing when they are minted (`_mint`),
828      * and stop existing when they are burned (`_burn`).
829      */
830     function _exists(uint256 tokenId) internal view virtual returns (bool) {
831         return _owners[tokenId] != address(0);
832     }
833 
834     /**
835      * @dev Returns whether `spender` is allowed to manage `tokenId`.
836      *
837      * Requirements:
838      *
839      * - `tokenId` must exist.
840      */
841     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
842         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
843         address owner = ERC721.ownerOf(tokenId);
844         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
845     }
846 
847     /**
848      * @dev Safely mints `tokenId` and transfers it to `to`.
849      *
850      * Requirements:
851      *
852      * - `tokenId` must not exist.
853      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
854      *
855      * Emits a {Transfer} event.
856      */
857     function _safeMint(address to, uint256 tokenId) internal virtual {
858         _safeMint(to, tokenId, "");
859     }
860 
861     /**
862      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
863      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
864      */
865     function _safeMint(
866         address to,
867         uint256 tokenId,
868         bytes memory _data
869     ) internal virtual {
870         _mint(to, tokenId);
871         require(
872             _checkOnERC721Received(address(0), to, tokenId, _data),
873             "ERC721: transfer to non ERC721Receiver implementer"
874         );
875     }
876 
877     /**
878      * @dev Mints `tokenId` and transfers it to `to`.
879      *
880      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
881      *
882      * Requirements:
883      *
884      * - `tokenId` must not exist.
885      * - `to` cannot be the zero address.
886      *
887      * Emits a {Transfer} event.
888      */
889     function _mint(address to, uint256 tokenId) internal virtual {
890         require(to != address(0), "ERC721: mint to the zero address");
891         require(!_exists(tokenId), "ERC721: token already minted");
892 
893         _beforeTokenTransfer(address(0), to, tokenId);
894 
895         _balances[to] += 1;
896         _owners[tokenId] = to;
897 
898         emit Transfer(address(0), to, tokenId);
899     }
900 
901     /**
902      * @dev Destroys `tokenId`.
903      * The approval is cleared when the token is burned.
904      *
905      * Requirements:
906      *
907      * - `tokenId` must exist.
908      *
909      * Emits a {Transfer} event.
910      */
911     function _burn(uint256 tokenId) internal virtual {
912         address owner = ERC721.ownerOf(tokenId);
913 
914         _beforeTokenTransfer(owner, address(0), tokenId);
915 
916         // Clear approvals
917         _approve(address(0), tokenId);
918 
919         _balances[owner] -= 1;
920         delete _owners[tokenId];
921 
922         emit Transfer(owner, address(0), tokenId);
923     }
924 
925     /**
926      * @dev Transfers `tokenId` from `from` to `to`.
927      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
928      *
929      * Requirements:
930      *
931      * - `to` cannot be the zero address.
932      * - `tokenId` token must be owned by `from`.
933      *
934      * Emits a {Transfer} event.
935      */
936     function _transfer(
937         address from,
938         address to,
939         uint256 tokenId
940     ) internal virtual {
941         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
942         require(to != address(0), "ERC721: transfer to the zero address");
943 
944         _beforeTokenTransfer(from, to, tokenId);
945 
946         // Clear approvals from the previous owner
947         _approve(address(0), tokenId);
948 
949         _balances[from] -= 1;
950         _balances[to] += 1;
951         _owners[tokenId] = to;
952 
953         emit Transfer(from, to, tokenId);
954     }
955 
956     /**
957      * @dev Approve `to` to operate on `tokenId`
958      *
959      * Emits a {Approval} event.
960      */
961     function _approve(address to, uint256 tokenId) internal virtual {
962         _tokenApprovals[tokenId] = to;
963         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
964     }
965 
966     /**
967      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
968      * The call is not executed if the target address is not a contract.
969      *
970      * @param from address representing the previous owner of the given token ID
971      * @param to target address that will receive the tokens
972      * @param tokenId uint256 ID of the token to be transferred
973      * @param _data bytes optional data to send along with the call
974      * @return bool whether the call correctly returned the expected magic value
975      */
976     function _checkOnERC721Received(
977         address from,
978         address to,
979         uint256 tokenId,
980         bytes memory _data
981     ) private returns (bool) {
982         if (to.isContract()) {
983             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
984                 return retval == IERC721Receiver.onERC721Received.selector;
985             } catch (bytes memory reason) {
986                 if (reason.length == 0) {
987                     revert("ERC721: transfer to non ERC721Receiver implementer");
988                 } else {
989                     assembly {
990                         revert(add(32, reason), mload(reason))
991                     }
992                 }
993             }
994         } else {
995             return true;
996         }
997     }
998 
999     /**
1000      * @dev Hook that is called before any token transfer. This includes minting
1001      * and burning.
1002      *
1003      * Calling conditions:
1004      *
1005      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1006      * transferred to `to`.
1007      * - When `from` is zero, `tokenId` will be minted for `to`.
1008      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1009      * - `from` and `to` are never both zero.
1010      *
1011      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1012      */
1013     function _beforeTokenTransfer(
1014         address from,
1015         address to,
1016         uint256 tokenId
1017     ) internal virtual {}
1018 }
1019 
1020 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1021 
1022 
1023 
1024 pragma solidity ^0.8.0;
1025 
1026 
1027 
1028 /**
1029  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1030  * enumerability of all the token ids in the contract as well as all token ids owned by each
1031  * account.
1032  */
1033 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1034     // Mapping from owner to list of owned token IDs
1035     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1036 
1037     // Mapping from token ID to index of the owner tokens list
1038     mapping(uint256 => uint256) private _ownedTokensIndex;
1039 
1040     // Array with all token ids, used for enumeration
1041     uint256[] private _allTokens;
1042 
1043     // Mapping from token id to position in the allTokens array
1044     mapping(uint256 => uint256) private _allTokensIndex;
1045 
1046     /**
1047      * @dev See {IERC165-supportsInterface}.
1048      */
1049     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1050         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1051     }
1052 
1053     /**
1054      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1055      */
1056     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1057         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1058         return _ownedTokens[owner][index];
1059     }
1060 
1061     /**
1062      * @dev See {IERC721Enumerable-totalSupply}.
1063      */
1064     function totalSupply() public view virtual override returns (uint256) {
1065         return _allTokens.length;
1066     }
1067 
1068     /**
1069      * @dev See {IERC721Enumerable-tokenByIndex}.
1070      */
1071     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1072         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1073         return _allTokens[index];
1074     }
1075 
1076     /**
1077      * @dev Hook that is called before any token transfer. This includes minting
1078      * and burning.
1079      *
1080      * Calling conditions:
1081      *
1082      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1083      * transferred to `to`.
1084      * - When `from` is zero, `tokenId` will be minted for `to`.
1085      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1086      * - `from` cannot be the zero address.
1087      * - `to` cannot be the zero address.
1088      *
1089      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1090      */
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
1130     /**
1131      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1132      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1133      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1134      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1135      * @param from address representing the previous owner of the given token ID
1136      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1137      */
1138     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1139         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1140         // then delete the last slot (swap and pop).
1141 
1142         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1143         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1144 
1145         // When the token to delete is the last token, the swap operation is unnecessary
1146         if (tokenIndex != lastTokenIndex) {
1147             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1148 
1149             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1150             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1151         }
1152 
1153         // This also deletes the contents at the last position of the array
1154         delete _ownedTokensIndex[tokenId];
1155         delete _ownedTokens[from][lastTokenIndex];
1156     }
1157 
1158     /**
1159      * @dev Private function to remove a token from this extension's token tracking data structures.
1160      * This has O(1) time complexity, but alters the order of the _allTokens array.
1161      * @param tokenId uint256 ID of the token to be removed from the tokens list
1162      */
1163     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1164         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1165         // then delete the last slot (swap and pop).
1166 
1167         uint256 lastTokenIndex = _allTokens.length - 1;
1168         uint256 tokenIndex = _allTokensIndex[tokenId];
1169 
1170         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1171         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1172         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1173         uint256 lastTokenId = _allTokens[lastTokenIndex];
1174 
1175         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1176         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1177 
1178         // This also deletes the contents at the last position of the array
1179         delete _allTokensIndex[tokenId];
1180         _allTokens.pop();
1181     }
1182 }
1183 
1184 
1185 // File: @openzeppelin/contracts/access/Ownable.sol
1186 pragma solidity ^0.8.0;
1187 /**
1188  * @dev Contract module which provides a basic access control mechanism, where
1189  * there is an account (an owner) that can be granted exclusive access to
1190  * specific functions.
1191  *
1192  * By default, the owner account will be the one that deploys the contract. This
1193  * can later be changed with {transferOwnership}.
1194  *
1195  * This module is used through inheritance. It will make available the modifier
1196  * `onlyOwner`, which can be applied to your functions to restrict their use to
1197  * the owner.
1198  */
1199 abstract contract Ownable is Context {
1200     address private _owner;
1201 
1202     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1203 
1204     /**
1205      * @dev Initializes the contract setting the deployer as the initial owner.
1206      */
1207     constructor() {
1208         _setOwner(_msgSender());
1209     }
1210 
1211     /**
1212      * @dev Returns the address of the current owner.
1213      */
1214     function owner() public view virtual returns (address) {
1215         return _owner;
1216     }
1217 
1218     /**
1219      * @dev Throws if called by any account other than the owner.
1220      */
1221     modifier onlyOwner() {
1222         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1223         _;
1224     }
1225 
1226     /**
1227      * @dev Leaves the contract without owner. It will not be possible to call
1228      * `onlyOwner` functions anymore. Can only be called by the current owner.
1229      *
1230      * NOTE: Renouncing ownership will leave the contract without an owner,
1231      * thereby removing any functionality that is only available to the owner.
1232      */
1233     function renounceOwnership() public virtual onlyOwner {
1234         _setOwner(address(0));
1235     }
1236 
1237     /**
1238      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1239      * Can only be called by the current owner.
1240      */
1241     function transferOwnership(address newOwner) public virtual onlyOwner {
1242         require(newOwner != address(0), "Ownable: new owner is the zero address");
1243         _setOwner(newOwner);
1244     }
1245 
1246     function _setOwner(address newOwner) private {
1247         address oldOwner = _owner;
1248         _owner = newOwner;
1249         emit OwnershipTransferred(oldOwner, newOwner);
1250     }
1251 }
1252 
1253 pragma solidity >=0.7.0 <0.9.0;
1254 
1255 contract CryptoBrewery is ERC721Enumerable, Ownable {
1256   using Strings for uint256;
1257 
1258   string baseURI;
1259   string public baseExtension = ".json";
1260   uint256 public cost = 0.08 ether;
1261   uint256 public maxSupply = 555;
1262   uint256 public maxMintAmount = 2;
1263   uint256 public headStart = block.timestamp + 5 days;
1264   bool public paused = true;
1265   bool public revealed = false;
1266   string public notRevealedUri;
1267  
1268   
1269   constructor(
1270     string memory _initBaseURI,
1271     string memory _initNotRevealedUri
1272   ) ERC721("CryptoBrewery", "CBEER") {
1273     setBaseURI(_initBaseURI);
1274     setNotRevealedURI(_initNotRevealedUri);
1275   }
1276 
1277   // internal
1278   function _baseURI() internal view virtual override returns (string memory) {
1279     return baseURI;
1280   }
1281 
1282   // public
1283   function mint() public payable {
1284     uint256 supply = totalSupply();
1285     require(!paused, "Contract is paused!");
1286     require(supply + 1 <= maxSupply, "Max supply reached!");
1287     require(msg.sender != owner(), "Owner can not mint!");
1288     require(msg.value >= cost, "Not enough funds!");
1289     require(balanceOf(msg.sender) < maxMintAmount, "You have exceeded your max mint amount!");
1290     
1291     address payable giftAddress = payable(msg.sender);
1292     uint256 giftValue;
1293     
1294     if(supply > 0) {
1295         giftAddress = payable(ownerOf(randomNum(supply, block.timestamp, supply + 1) + 1));
1296         giftValue = supply + 1 == maxSupply ? address(this).balance * 7 / 100 : msg.value * 10 / 100;
1297     }
1298     
1299     _safeMint(msg.sender, supply + 1);
1300 
1301     if(supply > 0) {
1302         (bool success, ) = payable(giftAddress).call{value: giftValue}("");
1303         require(success, "Could not send value!");
1304     }
1305   }
1306 
1307   function walletOfOwner(address _owner)
1308     public
1309     view
1310     returns (uint256[] memory)
1311   {
1312     uint256 ownerTokenCount = balanceOf(_owner);
1313     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1314     for (uint256 i; i < ownerTokenCount; i++) {
1315       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1316     }
1317     return tokenIds;
1318   }
1319   
1320   function randomNum(uint256 _mod, uint256 _seed, uint256 _salt) public view returns(uint256) {
1321       uint256 num = uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender, _seed, _salt))) % _mod;
1322       return num;
1323   }
1324 
1325   function tokenURI(uint256 tokenId)
1326     public
1327     view
1328     virtual
1329     override
1330     returns (string memory)
1331   {
1332     require(
1333       _exists(tokenId),
1334       "ERC721Metadata: URI query for nonexistent token"
1335     );
1336     
1337     if(revealed == false) {
1338         return notRevealedUri;
1339     }
1340 
1341     string memory currentBaseURI = _baseURI();
1342     return bytes(currentBaseURI).length > 0
1343         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1344         : "";
1345   }
1346 
1347   //only owner
1348   function reveal() public onlyOwner() {
1349       revealed = true;
1350   }
1351   
1352   //only owner
1353   function setCost(uint256 _newCost) public onlyOwner() {
1354     cost = _newCost;
1355   }
1356 
1357   function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1358     notRevealedUri = _notRevealedURI;
1359   }
1360 
1361   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1362     baseURI = _newBaseURI;
1363   }
1364 
1365   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1366     baseExtension = _newBaseExtension;
1367   }
1368 
1369   function pause(bool _state) public onlyOwner {
1370     paused = _state;
1371   }
1372 
1373   function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner() {
1374     maxMintAmount = _newmaxMintAmount;
1375   }
1376   
1377   function withdraw() public payable onlyOwner {
1378     uint256 supply = totalSupply();
1379     require(supply == maxSupply || block.timestamp >= headStart, "Can not withdraw yet.");
1380     (bool s, ) = payable(msg.sender).call{value: address(this).balance}("");
1381     require(s);
1382   }
1383 }