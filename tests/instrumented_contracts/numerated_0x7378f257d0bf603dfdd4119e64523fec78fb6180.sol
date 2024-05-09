1 // SPDX-License-Identifier: MIT
2 
3 
4 
5 
6 
7 // Fucking contract by Detention Brothers
8 // 
9 // 
10 // This is not a normal collection! this is fucking reality!
11 // Created by a fucking prison!
12 // These are our fucking faces!
13 // We are screwed .. fuck you!
14 // 
15 // 2022 fucking NFT
16 // Fucking Free mint
17 // max 2 for fucking transactions
18 //
19 //A message to Bored, Moon, Azuki, Punk and all the other big names .. fuck you! Our faces will fuck you! We don't have social networks or promoters but we'll get to the top and piss on your head!
20 //
21 
22 
23 
24 
25 /**
26     !Disclaimer!
27     These contracts have been used to create tutorials,
28     and was created for the purpose to teach people
29     how to create smart contracts on the blockchain.
30     please review this code on your own before using any of
31     the following code for production.
32     HashLips will not be liable in any way if for the use 
33     of the code. That being said, the code has been tested 
34     to the best of the developers' knowledge to work as intended.
35 */
36 
37 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
38 pragma solidity ^0.8.0;
39 /**
40  * @dev Interface of the ERC165 standard, as defined in the
41  * https://eips.ethereum.org/EIPS/eip-165[EIP].
42  *
43  * Implementers can declare support of contract interfaces, which can then be
44  * queried by others ({ERC165Checker}).
45  *
46  * For an implementation, see {ERC165}.
47  */
48 interface IERC165 {
49     /**
50      * @dev Returns true if this contract implements the interface defined by
51      * `interfaceId`. See the corresponding
52      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
53      * to learn more about how these ids are created.
54      *
55      * This function call must use less than 30 000 gas.
56      */
57     function supportsInterface(bytes4 interfaceId) external view returns (bool);
58 }
59 
60 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
61 pragma solidity ^0.8.0;
62 /**
63  * @dev Required interface of an ERC721 compliant contract.
64  */
65 interface IERC721 is IERC165 {
66     /**
67      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
68      */
69     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
70 
71     /**
72      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
73      */
74     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
75 
76     /**
77      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
78      */
79     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
80 
81     /**
82      * @dev Returns the number of tokens in ``owner``'s account.
83      */
84     function balanceOf(address owner) external view returns (uint256 balance);
85 
86     /**
87      * @dev Returns the owner of the `tokenId` token.
88      *
89      * Requirements:
90      *
91      * - `tokenId` must exist.
92      */
93     function ownerOf(uint256 tokenId) external view returns (address owner);
94 
95     /**
96      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
97      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
98      *
99      * Requirements:
100      *
101      * - `from` cannot be the zero address.
102      * - `to` cannot be the zero address.
103      * - `tokenId` token must exist and be owned by `from`.
104      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
105      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
106      *
107      * Emits a {Transfer} event.
108      */
109     function safeTransferFrom(
110         address from,
111         address to,
112         uint256 tokenId
113     ) external;
114 
115     /**
116      * @dev Transfers `tokenId` token from `from` to `to`.
117      *
118      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
119      *
120      * Requirements:
121      *
122      * - `from` cannot be the zero address.
123      * - `to` cannot be the zero address.
124      * - `tokenId` token must be owned by `from`.
125      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
126      *
127      * Emits a {Transfer} event.
128      */
129     function transferFrom(
130         address from,
131         address to,
132         uint256 tokenId
133     ) external;
134 
135     /**
136      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
137      * The approval is cleared when the token is transferred.
138      *
139      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
140      *
141      * Requirements:
142      *
143      * - The caller must own the token or be an approved operator.
144      * - `tokenId` must exist.
145      *
146      * Emits an {Approval} event.
147      */
148     function approve(address to, uint256 tokenId) external;
149 
150     /**
151      * @dev Returns the account approved for `tokenId` token.
152      *
153      * Requirements:
154      *
155      * - `tokenId` must exist.
156      */
157     function getApproved(uint256 tokenId) external view returns (address operator);
158 
159     /**
160      * @dev Approve or remove `operator` as an operator for the caller.
161      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
162      *
163      * Requirements:
164      *
165      * - The `operator` cannot be the caller.
166      *
167      * Emits an {ApprovalForAll} event.
168      */
169     function setApprovalForAll(address operator, bool _approved) external;
170 
171     /**
172      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
173      *
174      * See {setApprovalForAll}
175      */
176     function isApprovedForAll(address owner, address operator) external view returns (bool);
177 
178     /**
179      * @dev Safely transfers `tokenId` token from `from` to `to`.
180      *
181      * Requirements:
182      *
183      * - `from` cannot be the zero address.
184      * - `to` cannot be the zero address.
185      * - `tokenId` token must exist and be owned by `from`.
186      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
187      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
188      *
189      * Emits a {Transfer} event.
190      */
191     function safeTransferFrom(
192         address from,
193         address to,
194         uint256 tokenId,
195         bytes calldata data
196     ) external;
197 }
198 
199 
200 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
201 pragma solidity ^0.8.0;
202 /**
203  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
204  * @dev See https://eips.ethereum.org/EIPS/eip-721
205  */
206 interface IERC721Enumerable is IERC721 {
207     /**
208      * @dev Returns the total amount of tokens stored by the contract.
209      */
210     function totalSupply() external view returns (uint256);
211 
212     /**
213      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
214      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
215      */
216     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
217 
218     /**
219      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
220      * Use along with {totalSupply} to enumerate all tokens.
221      */
222     function tokenByIndex(uint256 index) external view returns (uint256);
223 }
224 
225 
226 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
227 pragma solidity ^0.8.0;
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
596 // File: @openzeppelin/contracts/utils/Context.sol
597 pragma solidity ^0.8.0;
598 /**
599  * @dev Provides information about the current execution context, including the
600  * sender of the transaction and its data. While these are generally available
601  * via msg.sender and msg.data, they should not be accessed in such a direct
602  * manner, since when dealing with meta-transactions the account sending and
603  * paying for execution may not be the actual sender (as far as an application
604  * is concerned).
605  *
606  * This contract is only required for intermediate, library-like contracts.
607  */
608 abstract contract Context {
609     function _msgSender() internal view virtual returns (address) {
610         return msg.sender;
611     }
612 
613     function _msgData() internal view virtual returns (bytes calldata) {
614         return msg.data;
615     }
616 }
617 
618 
619 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
620 pragma solidity ^0.8.0;
621 /**
622  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
623  * the Metadata extension, but not including the Enumerable extension, which is available separately as
624  * {ERC721Enumerable}.
625  */
626 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
627     using Address for address;
628     using Strings for uint256;
629 
630     // Token name
631     string private _name;
632 
633     // Token symbol
634     string private _symbol;
635 
636     // Mapping from token ID to owner address
637     mapping(uint256 => address) private _owners;
638 
639     // Mapping owner address to token count
640     mapping(address => uint256) private _balances;
641 
642     // Mapping from token ID to approved address
643     mapping(uint256 => address) private _tokenApprovals;
644 
645     // Mapping from owner to operator approvals
646     mapping(address => mapping(address => bool)) private _operatorApprovals;
647 
648     /**
649      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
650      */
651     constructor(string memory name_, string memory symbol_) {
652         _name = name_;
653         _symbol = symbol_;
654     }
655 
656     /**
657      * @dev See {IERC165-supportsInterface}.
658      */
659     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
660         return
661             interfaceId == type(IERC721).interfaceId ||
662             interfaceId == type(IERC721Metadata).interfaceId ||
663             super.supportsInterface(interfaceId);
664     }
665 
666     /**
667      * @dev See {IERC721-balanceOf}.
668      */
669     function balanceOf(address owner) public view virtual override returns (uint256) {
670         require(owner != address(0), "ERC721: balance query for the zero address");
671         return _balances[owner];
672     }
673 
674     /**
675      * @dev See {IERC721-ownerOf}.
676      */
677     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
678         address owner = _owners[tokenId];
679         require(owner != address(0), "ERC721: owner query for nonexistent token");
680         return owner;
681     }
682 
683     /**
684      * @dev See {IERC721Metadata-name}.
685      */
686     function name() public view virtual override returns (string memory) {
687         return _name;
688     }
689 
690     /**
691      * @dev See {IERC721Metadata-symbol}.
692      */
693     function symbol() public view virtual override returns (string memory) {
694         return _symbol;
695     }
696 
697     /**
698      * @dev See {IERC721Metadata-tokenURI}.
699      */
700     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
701         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
702 
703         string memory baseURI = _baseURI();
704         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
705     }
706 
707     /**
708      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
709      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
710      * by default, can be overriden in child contracts.
711      */
712     function _baseURI() internal view virtual returns (string memory) {
713         return "";
714     }
715 
716     /**
717      * @dev See {IERC721-approve}.
718      */
719     function approve(address to, uint256 tokenId) public virtual override {
720         address owner = ERC721.ownerOf(tokenId);
721         require(to != owner, "ERC721: approval to current owner");
722 
723         require(
724             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
725             "ERC721: approve caller is not owner nor approved for all"
726         );
727 
728         _approve(to, tokenId);
729     }
730 
731     /**
732      * @dev See {IERC721-getApproved}.
733      */
734     function getApproved(uint256 tokenId) public view virtual override returns (address) {
735         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
736 
737         return _tokenApprovals[tokenId];
738     }
739 
740     /**
741      * @dev See {IERC721-setApprovalForAll}.
742      */
743     function setApprovalForAll(address operator, bool approved) public virtual override {
744         require(operator != _msgSender(), "ERC721: approve to caller");
745 
746         _operatorApprovals[_msgSender()][operator] = approved;
747         emit ApprovalForAll(_msgSender(), operator, approved);
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
900     }
901 
902     /**
903      * @dev Destroys `tokenId`.
904      * The approval is cleared when the token is burned.
905      *
906      * Requirements:
907      *
908      * - `tokenId` must exist.
909      *
910      * Emits a {Transfer} event.
911      */
912     function _burn(uint256 tokenId) internal virtual {
913         address owner = ERC721.ownerOf(tokenId);
914 
915         _beforeTokenTransfer(owner, address(0), tokenId);
916 
917         // Clear approvals
918         _approve(address(0), tokenId);
919 
920         _balances[owner] -= 1;
921         delete _owners[tokenId];
922 
923         emit Transfer(owner, address(0), tokenId);
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
942         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
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
955     }
956 
957     /**
958      * @dev Approve `to` to operate on `tokenId`
959      *
960      * Emits a {Approval} event.
961      */
962     function _approve(address to, uint256 tokenId) internal virtual {
963         _tokenApprovals[tokenId] = to;
964         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
965     }
966 
967     /**
968      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
969      * The call is not executed if the target address is not a contract.
970      *
971      * @param from address representing the previous owner of the given token ID
972      * @param to target address that will receive the tokens
973      * @param tokenId uint256 ID of the token to be transferred
974      * @param _data bytes optional data to send along with the call
975      * @return bool whether the call correctly returned the expected magic value
976      */
977     function _checkOnERC721Received(
978         address from,
979         address to,
980         uint256 tokenId,
981         bytes memory _data
982     ) private returns (bool) {
983         if (to.isContract()) {
984             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
985                 return retval == IERC721Receiver.onERC721Received.selector;
986             } catch (bytes memory reason) {
987                 if (reason.length == 0) {
988                     revert("ERC721: transfer to non ERC721Receiver implementer");
989                 } else {
990                     assembly {
991                         revert(add(32, reason), mload(reason))
992                     }
993                 }
994             }
995         } else {
996             return true;
997         }
998     }
999 
1000     /**
1001      * @dev Hook that is called before any token transfer. This includes minting
1002      * and burning.
1003      *
1004      * Calling conditions:
1005      *
1006      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1007      * transferred to `to`.
1008      * - When `from` is zero, `tokenId` will be minted for `to`.
1009      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1010      * - `from` and `to` are never both zero.
1011      *
1012      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1013      */
1014     function _beforeTokenTransfer(
1015         address from,
1016         address to,
1017         uint256 tokenId
1018     ) internal virtual {}
1019 }
1020 
1021 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1022 
1023 
1024 
1025 pragma solidity ^0.8.0;
1026 
1027 
1028 
1029 /**
1030  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1031  * enumerability of all the token ids in the contract as well as all token ids owned by each
1032  * account.
1033  */
1034 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1035     // Mapping from owner to list of owned token IDs
1036     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1037 
1038     // Mapping from token ID to index of the owner tokens list
1039     mapping(uint256 => uint256) private _ownedTokensIndex;
1040 
1041     // Array with all token ids, used for enumeration
1042     uint256[] private _allTokens;
1043 
1044     // Mapping from token id to position in the allTokens array
1045     mapping(uint256 => uint256) private _allTokensIndex;
1046 
1047     /**
1048      * @dev See {IERC165-supportsInterface}.
1049      */
1050     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1051         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1052     }
1053 
1054     /**
1055      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1056      */
1057     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1058         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1059         return _ownedTokens[owner][index];
1060     }
1061 
1062     /**
1063      * @dev See {IERC721Enumerable-totalSupply}.
1064      */
1065     function totalSupply() public view virtual override returns (uint256) {
1066         return _allTokens.length;
1067     }
1068 
1069     /**
1070      * @dev See {IERC721Enumerable-tokenByIndex}.
1071      */
1072     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1073         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1074         return _allTokens[index];
1075     }
1076 
1077     /**
1078      * @dev Hook that is called before any token transfer. This includes minting
1079      * and burning.
1080      *
1081      * Calling conditions:
1082      *
1083      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1084      * transferred to `to`.
1085      * - When `from` is zero, `tokenId` will be minted for `to`.
1086      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1087      * - `from` cannot be the zero address.
1088      * - `to` cannot be the zero address.
1089      *
1090      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1091      */
1092     function _beforeTokenTransfer(
1093         address from,
1094         address to,
1095         uint256 tokenId
1096     ) internal virtual override {
1097         super._beforeTokenTransfer(from, to, tokenId);
1098 
1099         if (from == address(0)) {
1100             _addTokenToAllTokensEnumeration(tokenId);
1101         } else if (from != to) {
1102             _removeTokenFromOwnerEnumeration(from, tokenId);
1103         }
1104         if (to == address(0)) {
1105             _removeTokenFromAllTokensEnumeration(tokenId);
1106         } else if (to != from) {
1107             _addTokenToOwnerEnumeration(to, tokenId);
1108         }
1109     }
1110 
1111     /**
1112      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1113      * @param to address representing the new owner of the given token ID
1114      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1115      */
1116     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1117         uint256 length = ERC721.balanceOf(to);
1118         _ownedTokens[to][length] = tokenId;
1119         _ownedTokensIndex[tokenId] = length;
1120     }
1121 
1122     /**
1123      * @dev Private function to add a token to this extension's token tracking data structures.
1124      * @param tokenId uint256 ID of the token to be added to the tokens list
1125      */
1126     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1127         _allTokensIndex[tokenId] = _allTokens.length;
1128         _allTokens.push(tokenId);
1129     }
1130 
1131     /**
1132      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1133      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1134      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1135      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1136      * @param from address representing the previous owner of the given token ID
1137      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1138      */
1139     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1140         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1141         // then delete the last slot (swap and pop).
1142 
1143         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1144         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1145 
1146         // When the token to delete is the last token, the swap operation is unnecessary
1147         if (tokenIndex != lastTokenIndex) {
1148             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1149 
1150             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1151             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1152         }
1153 
1154         // This also deletes the contents at the last position of the array
1155         delete _ownedTokensIndex[tokenId];
1156         delete _ownedTokens[from][lastTokenIndex];
1157     }
1158 
1159     /**
1160      * @dev Private function to remove a token from this extension's token tracking data structures.
1161      * This has O(1) time complexity, but alters the order of the _allTokens array.
1162      * @param tokenId uint256 ID of the token to be removed from the tokens list
1163      */
1164     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1165         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1166         // then delete the last slot (swap and pop).
1167 
1168         uint256 lastTokenIndex = _allTokens.length - 1;
1169         uint256 tokenIndex = _allTokensIndex[tokenId];
1170 
1171         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1172         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1173         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1174         uint256 lastTokenId = _allTokens[lastTokenIndex];
1175 
1176         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1177         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1178 
1179         // This also deletes the contents at the last position of the array
1180         delete _allTokensIndex[tokenId];
1181         _allTokens.pop();
1182     }
1183 }
1184 
1185 
1186 // File: @openzeppelin/contracts/access/Ownable.sol
1187 pragma solidity ^0.8.0;
1188 /**
1189  * @dev Contract module which provides a basic access control mechanism, where
1190  * there is an account (an owner) that can be granted exclusive access to
1191  * specific functions.
1192  *
1193  * By default, the owner account will be the one that deploys the contract. This
1194  * can later be changed with {transferOwnership}.
1195  *
1196  * This module is used through inheritance. It will make available the modifier
1197  * `onlyOwner`, which can be applied to your functions to restrict their use to
1198  * the owner.
1199  */
1200 abstract contract Ownable is Context {
1201     address private _owner;
1202 
1203     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1204 
1205     /**
1206      * @dev Initializes the contract setting the deployer as the initial owner.
1207      */
1208     constructor() {
1209         _setOwner(_msgSender());
1210     }
1211 
1212     /**
1213      * @dev Returns the address of the current owner.
1214      */
1215     function owner() public view virtual returns (address) {
1216         return _owner;
1217     }
1218 
1219     /**
1220      * @dev Throws if called by any account other than the owner.
1221      */
1222     modifier onlyOwner() {
1223         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1224         _;
1225     }
1226 
1227     /**
1228      * @dev Leaves the contract without owner. It will not be possible to call
1229      * `onlyOwner` functions anymore. Can only be called by the current owner.
1230      *
1231      * NOTE: Renouncing ownership will leave the contract without an owner,
1232      * thereby removing any functionality that is only available to the owner.
1233      */
1234     function renounceOwnership() public virtual onlyOwner {
1235         _setOwner(address(0));
1236     }
1237 
1238     /**
1239      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1240      * Can only be called by the current owner.
1241      */
1242     function transferOwnership(address newOwner) public virtual onlyOwner {
1243         require(newOwner != address(0), "Ownable: new owner is the zero address");
1244         _setOwner(newOwner);
1245     }
1246 
1247     function _setOwner(address newOwner) private {
1248         address oldOwner = _owner;
1249         _owner = newOwner;
1250         emit OwnershipTransferred(oldOwner, newOwner);
1251     }
1252 }
1253 
1254 pragma solidity >=0.7.0 <0.9.0;
1255 
1256 contract DetentionBrothers is ERC721Enumerable, Ownable {
1257   using Strings for uint256;
1258 
1259   string baseURI;
1260   string public baseExtension = ".json";
1261   uint256 public cost = 0 ether;
1262   uint256 public maxSupply = 2022;
1263   uint256 public maxMintAmount = 2;
1264   bool public paused = false;
1265   bool public revealed = false;
1266   string public notRevealedUri;
1267 
1268   constructor(
1269     string memory _name,
1270     string memory _symbol,
1271     string memory _initBaseURI,
1272     string memory _initNotRevealedUri
1273   ) ERC721(_name, _symbol) {
1274     setBaseURI(_initBaseURI);
1275     setNotRevealedURI(_initNotRevealedUri);
1276   }
1277 
1278   // internal
1279   function _baseURI() internal view virtual override returns (string memory) {
1280     return baseURI;
1281   }
1282 
1283   // public
1284   function mint(uint256 _mintAmount) public payable {
1285     uint256 supply = totalSupply();
1286     require(!paused);
1287     require(_mintAmount > 0);
1288     require(_mintAmount <= maxMintAmount);
1289     require(supply + _mintAmount <= maxSupply);
1290 
1291     if (msg.sender != owner()) {
1292       require(msg.value >= cost * _mintAmount);
1293     }
1294 
1295     for (uint256 i = 1; i <= _mintAmount; i++) {
1296       _safeMint(msg.sender, supply + i);
1297     }
1298   }
1299 
1300   function walletOfOwner(address _owner)
1301     public
1302     view
1303     returns (uint256[] memory)
1304   {
1305     uint256 ownerTokenCount = balanceOf(_owner);
1306     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1307     for (uint256 i; i < ownerTokenCount; i++) {
1308       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1309     }
1310     return tokenIds;
1311   }
1312 
1313   function tokenURI(uint256 tokenId)
1314     public
1315     view
1316     virtual
1317     override
1318     returns (string memory)
1319   {
1320     require(
1321       _exists(tokenId),
1322       "ERC721Metadata: URI query for nonexistent token"
1323     );
1324     
1325     if(revealed == false) {
1326         return notRevealedUri;
1327     }
1328 
1329     string memory currentBaseURI = _baseURI();
1330     return bytes(currentBaseURI).length > 0
1331         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1332         : "";
1333   }
1334 
1335   //only owner
1336   function reveal() public onlyOwner {
1337       revealed = true;
1338   }
1339   
1340   function setCost(uint256 _newCost) public onlyOwner {
1341     cost = _newCost;
1342   }
1343 
1344   function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
1345     maxMintAmount = _newmaxMintAmount;
1346   }
1347   
1348   function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1349     notRevealedUri = _notRevealedURI;
1350   }
1351 
1352   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1353     baseURI = _newBaseURI;
1354   }
1355 
1356   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1357     baseExtension = _newBaseExtension;
1358   }
1359 
1360   function pause(bool _state) public onlyOwner {
1361     paused = _state;
1362   }
1363  
1364   function withdraw() public payable onlyOwner {
1365     // This will pay Detention Brothers 5% of the initial sale.
1366     // You can remove this if you want, or keep it in to support  and his channel.
1367     // =============================================================================
1368     (bool hs, ) = payable(0x4Ad20E0252172fc46316035cDA4D327D0c40976D).call{value: address(this).balance * 5 / 100}("");
1369     require(hs);
1370     // =============================================================================
1371     
1372     // This will payout the owner 95% of the contract balance.
1373     // Do not remove this otherwise you will not be able to withdraw the funds.
1374     // =============================================================================
1375     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1376     require(os);
1377     // =============================================================================
1378   }
1379 }