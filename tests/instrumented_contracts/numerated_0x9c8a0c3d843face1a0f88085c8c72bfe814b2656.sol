1 // SPDX-License-Identifier: GPL-3.0
2 // 
3 //                              __             
4 //                             /\ \__          
5 //   ___   _ __   __  __  _____\ \ ,_\   ___   
6 //  /'___\/\`'__\/\ \/\ \/\ '__`\ \ \/  / __`\ 
7 // /\ \__/\ \ \/ \ \ \_\ \ \ \L\ \ \ \_/\ \L\ \
8 // \ \____\\ \_\  \/`____ \ \ ,__/\ \__\ \____/
9 //  \/____/ \/_/   `/___/> \ \ \/  \/__/\/___/ 
10 //                    /\___/\ \_\              
11 //                    \/__/  \/_/              
12 //                            __                                     
13 //                           /\ \                                    
14 //   ___   __  __  _ __   ___\ \ \____    ___   _ __   ___     ____  
15 //  / __`\/\ \/\ \/\`'__\/ __`\ \ '__`\  / __`\/\`'__\/ __`\  /',__\ 
16 // /\ \L\ \ \ \_\ \ \ \//\ \L\ \ \ \L\ \/\ \L\ \ \ \//\ \L\ \/\__, `\
17 // \ \____/\ \____/\ \_\\ \____/\ \_,__/\ \____/\ \_\\ \____/\/\____/
18 //  \/___/  \/___/  \/_/ \/___/  \/___/  \/___/  \/_/ \/___/  \/___/ 
19 //                                                                   
20 //                                                                   
21 //                                              
22                                         
23 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
24 pragma solidity ^0.8.0;
25 /**
26  * @dev Interface of the ERC165 standard, as defined in the
27  * https://eips.ethereum.org/EIPS/eip-165[EIP].
28  *
29  * Implementers can declare support of contract interfaces, which can then be
30  * queried by others ({ERC165Checker}).
31  *
32  * For an implementation, see {ERC165}.
33  */
34 interface IERC165 {
35     /**
36      * @dev Returns true if this contract implements the interface defined by
37      * `interfaceId`. See the corresponding
38      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
39      * to learn more about how these ids are created.
40      *
41      * This function call must use less than 30 000 gas.
42      */
43     function supportsInterface(bytes4 interfaceId) external view returns (bool);
44 }
45 
46 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
47 pragma solidity ^0.8.0;
48 /**
49  * @dev Required interface of an ERC721 compliant contract.
50  */
51 interface IERC721 is IERC165 {
52     /**
53      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
54      */
55     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
56 
57     /**
58      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
59      */
60     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
61 
62     /**
63      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
64      */
65     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
66 
67     /**
68      * @dev Returns the number of tokens in ``owner``'s account.
69      */
70     function balanceOf(address owner) external view returns (uint256 balance);
71 
72     /**
73      * @dev Returns the owner of the `tokenId` token.
74      *
75      * Requirements:
76      *
77      * - `tokenId` must exist.
78      */
79     function ownerOf(uint256 tokenId) external view returns (address owner);
80 
81     /**
82      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
83      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
84      *
85      * Requirements:
86      *
87      * - `from` cannot be the zero address.
88      * - `to` cannot be the zero address.
89      * - `tokenId` token must exist and be owned by `from`.
90      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
91      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
92      *
93      * Emits a {Transfer} event.
94      */
95     function safeTransferFrom(
96         address from,
97         address to,
98         uint256 tokenId
99     ) external;
100 
101     /**
102      * @dev Transfers `tokenId` token from `from` to `to`.
103      *
104      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
105      *
106      * Requirements:
107      *
108      * - `from` cannot be the zero address.
109      * - `to` cannot be the zero address.
110      * - `tokenId` token must be owned by `from`.
111      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
112      *
113      * Emits a {Transfer} event.
114      */
115     function transferFrom(
116         address from,
117         address to,
118         uint256 tokenId
119     ) external;
120 
121     /**
122      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
123      * The approval is cleared when the token is transferred.
124      *
125      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
126      *
127      * Requirements:
128      *
129      * - The caller must own the token or be an approved operator.
130      * - `tokenId` must exist.
131      *
132      * Emits an {Approval} event.
133      */
134     function approve(address to, uint256 tokenId) external;
135 
136     /**
137      * @dev Returns the account approved for `tokenId` token.
138      *
139      * Requirements:
140      *
141      * - `tokenId` must exist.
142      */
143     function getApproved(uint256 tokenId) external view returns (address operator);
144 
145     /**
146      * @dev Approve or remove `operator` as an operator for the caller.
147      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
148      *
149      * Requirements:
150      *
151      * - The `operator` cannot be the caller.
152      *
153      * Emits an {ApprovalForAll} event.
154      */
155     function setApprovalForAll(address operator, bool _approved) external;
156 
157     /**
158      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
159      *
160      * See {setApprovalForAll}
161      */
162     function isApprovedForAll(address owner, address operator) external view returns (bool);
163 
164     /**
165      * @dev Safely transfers `tokenId` token from `from` to `to`.
166      *
167      * Requirements:
168      *
169      * - `from` cannot be the zero address.
170      * - `to` cannot be the zero address.
171      * - `tokenId` token must exist and be owned by `from`.
172      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
173      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
174      *
175      * Emits a {Transfer} event.
176      */
177     function safeTransferFrom(
178         address from,
179         address to,
180         uint256 tokenId,
181         bytes calldata data
182     ) external;
183 }
184 
185 
186 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
187 pragma solidity ^0.8.0;
188 /**
189  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
190  * @dev See https://eips.ethereum.org/EIPS/eip-721
191  */
192 interface IERC721Enumerable is IERC721 {
193     /**
194      * @dev Returns the total amount of tokens stored by the contract.
195      */
196     function totalSupply() external view returns (uint256);
197 
198     /**
199      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
200      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
201      */
202     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
203 
204     /**
205      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
206      * Use along with {totalSupply} to enumerate all tokens.
207      */
208     function tokenByIndex(uint256 index) external view returns (uint256);
209 }
210 
211 
212 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
213 pragma solidity ^0.8.0;
214 /**
215  * @dev Implementation of the {IERC165} interface.
216  *
217  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
218  * for the additional interface id that will be supported. For example:
219  *
220  * ```solidity
221  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
222  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
223  * }
224  * ```
225  *
226  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
227  */
228 abstract contract ERC165 is IERC165 {
229     /**
230      * @dev See {IERC165-supportsInterface}.
231      */
232     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
233         return interfaceId == type(IERC165).interfaceId;
234     }
235 }
236 
237 // File: @openzeppelin/contracts/utils/Strings.sol
238 
239 
240 
241 pragma solidity ^0.8.0;
242 
243 /**
244  * @dev String operations.
245  */
246 library Strings {
247     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
248 
249     /**
250      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
251      */
252     function toString(uint256 value) internal pure returns (string memory) {
253         // Inspired by OraclizeAPI's implementation - MIT licence
254         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
255 
256         if (value == 0) {
257             return "0";
258         }
259         uint256 temp = value;
260         uint256 digits;
261         while (temp != 0) {
262             digits++;
263             temp /= 10;
264         }
265         bytes memory buffer = new bytes(digits);
266         while (value != 0) {
267             digits -= 1;
268             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
269             value /= 10;
270         }
271         return string(buffer);
272     }
273 
274     /**
275      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
276      */
277     function toHexString(uint256 value) internal pure returns (string memory) {
278         if (value == 0) {
279             return "0x00";
280         }
281         uint256 temp = value;
282         uint256 length = 0;
283         while (temp != 0) {
284             length++;
285             temp >>= 8;
286         }
287         return toHexString(value, length);
288     }
289 
290     /**
291      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
292      */
293     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
294         bytes memory buffer = new bytes(2 * length + 2);
295         buffer[0] = "0";
296         buffer[1] = "x";
297         for (uint256 i = 2 * length + 1; i > 1; --i) {
298             buffer[i] = _HEX_SYMBOLS[value & 0xf];
299             value >>= 4;
300         }
301         require(value == 0, "Strings: hex length insufficient");
302         return string(buffer);
303     }
304 }
305 
306 // File: @openzeppelin/contracts/utils/Address.sol
307 
308 
309 
310 pragma solidity ^0.8.0;
311 
312 /**
313  * @dev Collection of functions related to the address type
314  */
315 library Address {
316     /**
317      * @dev Returns true if `account` is a contract.
318      *
319      * [IMPORTANT]
320      * ====
321      * It is unsafe to assume that an address for which this function returns
322      * false is an externally-owned account (EOA) and not a contract.
323      *
324      * Among others, `isContract` will return false for the following
325      * types of addresses:
326      *
327      *  - an externally-owned account
328      *  - a contract in construction
329      *  - an address where a contract will be created
330      *  - an address where a contract lived, but was destroyed
331      * ====
332      */
333     function isContract(address account) internal view returns (bool) {
334         // This method relies on extcodesize, which returns 0 for contracts in
335         // construction, since the code is only stored at the end of the
336         // constructor execution.
337 
338         uint256 size;
339         assembly {
340             size := extcodesize(account)
341         }
342         return size > 0;
343     }
344 
345     /**
346      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
347      * `recipient`, forwarding all available gas and reverting on errors.
348      *
349      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
350      * of certain opcodes, possibly making contracts go over the 2300 gas limit
351      * imposed by `transfer`, making them unable to receive funds via
352      * `transfer`. {sendValue} removes this limitation.
353      *
354      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
355      *
356      * IMPORTANT: because control is transferred to `recipient`, care must be
357      * taken to not create reentrancy vulnerabilities. Consider using
358      * {ReentrancyGuard} or the
359      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
360      */
361     function sendValue(address payable recipient, uint256 amount) internal {
362         require(address(this).balance >= amount, "Address: insufficient balance");
363 
364         (bool success, ) = recipient.call{value: amount}("");
365         require(success, "Address: unable to send value, recipient may have reverted");
366     }
367 
368     /**
369      * @dev Performs a Solidity function call using a low level `call`. A
370      * plain `call` is an unsafe replacement for a function call: use this
371      * function instead.
372      *
373      * If `target` reverts with a revert reason, it is bubbled up by this
374      * function (like regular Solidity function calls).
375      *
376      * Returns the raw returned data. To convert to the expected return value,
377      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
378      *
379      * Requirements:
380      *
381      * - `target` must be a contract.
382      * - calling `target` with `data` must not revert.
383      *
384      * _Available since v3.1._
385      */
386     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
387         return functionCall(target, data, "Address: low-level call failed");
388     }
389 
390     /**
391      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
392      * `errorMessage` as a fallback revert reason when `target` reverts.
393      *
394      * _Available since v3.1._
395      */
396     function functionCall(
397         address target,
398         bytes memory data,
399         string memory errorMessage
400     ) internal returns (bytes memory) {
401         return functionCallWithValue(target, data, 0, errorMessage);
402     }
403 
404     /**
405      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
406      * but also transferring `value` wei to `target`.
407      *
408      * Requirements:
409      *
410      * - the calling contract must have an ETH balance of at least `value`.
411      * - the called Solidity function must be `payable`.
412      *
413      * _Available since v3.1._
414      */
415     function functionCallWithValue(
416         address target,
417         bytes memory data,
418         uint256 value
419     ) internal returns (bytes memory) {
420         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
421     }
422 
423     /**
424      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
425      * with `errorMessage` as a fallback revert reason when `target` reverts.
426      *
427      * _Available since v3.1._
428      */
429     function functionCallWithValue(
430         address target,
431         bytes memory data,
432         uint256 value,
433         string memory errorMessage
434     ) internal returns (bytes memory) {
435         require(address(this).balance >= value, "Address: insufficient balance for call");
436         require(isContract(target), "Address: call to non-contract");
437 
438         (bool success, bytes memory returndata) = target.call{value: value}(data);
439         return verifyCallResult(success, returndata, errorMessage);
440     }
441 
442     /**
443      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
444      * but performing a static call.
445      *
446      * _Available since v3.3._
447      */
448     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
449         return functionStaticCall(target, data, "Address: low-level static call failed");
450     }
451 
452     /**
453      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
454      * but performing a static call.
455      *
456      * _Available since v3.3._
457      */
458     function functionStaticCall(
459         address target,
460         bytes memory data,
461         string memory errorMessage
462     ) internal view returns (bytes memory) {
463         require(isContract(target), "Address: static call to non-contract");
464 
465         (bool success, bytes memory returndata) = target.staticcall(data);
466         return verifyCallResult(success, returndata, errorMessage);
467     }
468 
469     /**
470      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
471      * but performing a delegate call.
472      *
473      * _Available since v3.4._
474      */
475     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
476         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
477     }
478 
479     /**
480      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
481      * but performing a delegate call.
482      *
483      * _Available since v3.4._
484      */
485     function functionDelegateCall(
486         address target,
487         bytes memory data,
488         string memory errorMessage
489     ) internal returns (bytes memory) {
490         require(isContract(target), "Address: delegate call to non-contract");
491 
492         (bool success, bytes memory returndata) = target.delegatecall(data);
493         return verifyCallResult(success, returndata, errorMessage);
494     }
495 
496     /**
497      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
498      * revert reason using the provided one.
499      *
500      * _Available since v4.3._
501      */
502     function verifyCallResult(
503         bool success,
504         bytes memory returndata,
505         string memory errorMessage
506     ) internal pure returns (bytes memory) {
507         if (success) {
508             return returndata;
509         } else {
510             // Look for revert reason and bubble it up if present
511             if (returndata.length > 0) {
512                 // The easiest way to bubble the revert reason is using memory via assembly
513 
514                 assembly {
515                     let returndata_size := mload(returndata)
516                     revert(add(32, returndata), returndata_size)
517                 }
518             } else {
519                 revert(errorMessage);
520             }
521         }
522     }
523 }
524 
525 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
526 
527 
528 
529 pragma solidity ^0.8.0;
530 
531 
532 /**
533  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
534  * @dev See https://eips.ethereum.org/EIPS/eip-721
535  */
536 interface IERC721Metadata is IERC721 {
537     /**
538      * @dev Returns the token collection name.
539      */
540     function name() external view returns (string memory);
541 
542     /**
543      * @dev Returns the token collection symbol.
544      */
545     function symbol() external view returns (string memory);
546 
547     /**
548      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
549      */
550     function tokenURI(uint256 tokenId) external view returns (string memory);
551 }
552 
553 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
554 
555 
556 
557 pragma solidity ^0.8.0;
558 
559 /**
560  * @title ERC721 token receiver interface
561  * @dev Interface for any contract that wants to support safeTransfers
562  * from ERC721 asset contracts.
563  */
564 interface IERC721Receiver {
565     /**
566      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
567      * by `operator` from `from`, this function is called.
568      *
569      * It must return its Solidity selector to confirm the token transfer.
570      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
571      *
572      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
573      */
574     function onERC721Received(
575         address operator,
576         address from,
577         uint256 tokenId,
578         bytes calldata data
579     ) external returns (bytes4);
580 }
581 
582 // File: @openzeppelin/contracts/utils/Context.sol
583 pragma solidity ^0.8.0;
584 /**
585  * @dev Provides information about the current execution context, including the
586  * sender of the transaction and its data. While these are generally available
587  * via msg.sender and msg.data, they should not be accessed in such a direct
588  * manner, since when dealing with meta-transactions the account sending and
589  * paying for execution may not be the actual sender (as far as an application
590  * is concerned).
591  *
592  * This contract is only required for intermediate, library-like contracts.
593  */
594 abstract contract Context {
595     function _msgSender() internal view virtual returns (address) {
596         return msg.sender;
597     }
598 
599     function _msgData() internal view virtual returns (bytes calldata) {
600         return msg.data;
601     }
602 }
603 
604 
605 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
606 pragma solidity ^0.8.0;
607 /**
608  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
609  * the Metadata extension, but not including the Enumerable extension, which is available separately as
610  * {ERC721Enumerable}.
611  */
612 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
613     using Address for address;
614     using Strings for uint256;
615 
616     // Token name
617     string private _name;
618 
619     // Token symbol
620     string private _symbol;
621 
622     // Mapping from token ID to owner address
623     mapping(uint256 => address) private _owners;
624 
625     // Mapping owner address to token count
626     mapping(address => uint256) private _balances;
627 
628     // Mapping from token ID to approved address
629     mapping(uint256 => address) private _tokenApprovals;
630 
631     // Mapping from owner to operator approvals
632     mapping(address => mapping(address => bool)) private _operatorApprovals;
633 
634     /**
635      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
636      */
637     constructor(string memory name_, string memory symbol_) {
638         _name = name_;
639         _symbol = symbol_;
640     }
641 
642     /**
643      * @dev See {IERC165-supportsInterface}.
644      */
645     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
646         return
647             interfaceId == type(IERC721).interfaceId ||
648             interfaceId == type(IERC721Metadata).interfaceId ||
649             super.supportsInterface(interfaceId);
650     }
651 
652     /**
653      * @dev See {IERC721-balanceOf}.
654      */
655     function balanceOf(address owner) public view virtual override returns (uint256) {
656         require(owner != address(0), "ERC721: balance query for the zero address");
657         return _balances[owner];
658     }
659 
660     /**
661      * @dev See {IERC721-ownerOf}.
662      */
663     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
664         address owner = _owners[tokenId];
665         require(owner != address(0), "ERC721: owner query for nonexistent token");
666         return owner;
667     }
668 
669     /**
670      * @dev See {IERC721Metadata-name}.
671      */
672     function name() public view virtual override returns (string memory) {
673         return _name;
674     }
675 
676     /**
677      * @dev See {IERC721Metadata-symbol}.
678      */
679     function symbol() public view virtual override returns (string memory) {
680         return _symbol;
681     }
682 
683     /**
684      * @dev See {IERC721Metadata-tokenURI}.
685      */
686     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
687         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
688 
689         string memory baseURI = _baseURI();
690         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
691     }
692 
693     /**
694      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
695      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
696      * by default, can be overriden in child contracts.
697      */
698     function _baseURI() internal view virtual returns (string memory) {
699         return "";
700     }
701 
702     /**
703      * @dev See {IERC721-approve}.
704      */
705     function approve(address to, uint256 tokenId) public virtual override {
706         address owner = ERC721.ownerOf(tokenId);
707         require(to != owner, "ERC721: approval to current owner");
708 
709         require(
710             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
711             "ERC721: approve caller is not owner nor approved for all"
712         );
713 
714         _approve(to, tokenId);
715     }
716 
717     /**
718      * @dev See {IERC721-getApproved}.
719      */
720     function getApproved(uint256 tokenId) public view virtual override returns (address) {
721         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
722 
723         return _tokenApprovals[tokenId];
724     }
725 
726     /**
727      * @dev See {IERC721-setApprovalForAll}.
728      */
729     function setApprovalForAll(address operator, bool approved) public virtual override {
730         require(operator != _msgSender(), "ERC721: approve to caller");
731 
732         _operatorApprovals[_msgSender()][operator] = approved;
733         emit ApprovalForAll(_msgSender(), operator, approved);
734     }
735 
736     /**
737      * @dev See {IERC721-isApprovedForAll}.
738      */
739     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
740         return _operatorApprovals[owner][operator];
741     }
742 
743     /**
744      * @dev See {IERC721-transferFrom}.
745      */
746     function transferFrom(
747         address from,
748         address to,
749         uint256 tokenId
750     ) public virtual override {
751         //solhint-disable-next-line max-line-length
752         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
753 
754         _transfer(from, to, tokenId);
755     }
756 
757     /**
758      * @dev See {IERC721-safeTransferFrom}.
759      */
760     function safeTransferFrom(
761         address from,
762         address to,
763         uint256 tokenId
764     ) public virtual override {
765         safeTransferFrom(from, to, tokenId, "");
766     }
767 
768     /**
769      * @dev See {IERC721-safeTransferFrom}.
770      */
771     function safeTransferFrom(
772         address from,
773         address to,
774         uint256 tokenId,
775         bytes memory _data
776     ) public virtual override {
777         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
778         _safeTransfer(from, to, tokenId, _data);
779     }
780 
781     /**
782      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
783      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
784      *
785      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
786      *
787      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
788      * implement alternative mechanisms to perform token transfer, such as signature-based.
789      *
790      * Requirements:
791      *
792      * - `from` cannot be the zero address.
793      * - `to` cannot be the zero address.
794      * - `tokenId` token must exist and be owned by `from`.
795      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
796      *
797      * Emits a {Transfer} event.
798      */
799     function _safeTransfer(
800         address from,
801         address to,
802         uint256 tokenId,
803         bytes memory _data
804     ) internal virtual {
805         _transfer(from, to, tokenId);
806         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
807     }
808 
809     /**
810      * @dev Returns whether `tokenId` exists.
811      *
812      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
813      *
814      * Tokens start existing when they are minted (`_mint`),
815      * and stop existing when they are burned (`_burn`).
816      */
817     function _exists(uint256 tokenId) internal view virtual returns (bool) {
818         return _owners[tokenId] != address(0);
819     }
820 
821     /**
822      * @dev Returns whether `spender` is allowed to manage `tokenId`.
823      *
824      * Requirements:
825      *
826      * - `tokenId` must exist.
827      */
828     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
829         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
830         address owner = ERC721.ownerOf(tokenId);
831         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
832     }
833 
834     /**
835      * @dev Safely mints `tokenId` and transfers it to `to`.
836      *
837      * Requirements:
838      *
839      * - `tokenId` must not exist.
840      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
841      *
842      * Emits a {Transfer} event.
843      */
844     function _safeMint(address to, uint256 tokenId) internal virtual {
845         _safeMint(to, tokenId, "");
846     }
847 
848     /**
849      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
850      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
851      */
852     function _safeMint(
853         address to,
854         uint256 tokenId,
855         bytes memory _data
856     ) internal virtual {
857         _mint(to, tokenId);
858         require(
859             _checkOnERC721Received(address(0), to, tokenId, _data),
860             "ERC721: transfer to non ERC721Receiver implementer"
861         );
862     }
863 
864     /**
865      * @dev Mints `tokenId` and transfers it to `to`.
866      *
867      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
868      *
869      * Requirements:
870      *
871      * - `tokenId` must not exist.
872      * - `to` cannot be the zero address.
873      *
874      * Emits a {Transfer} event.
875      */
876     function _mint(address to, uint256 tokenId) internal virtual {
877         require(to != address(0), "ERC721: mint to the zero address");
878         require(!_exists(tokenId), "ERC721: token already minted");
879 
880         _beforeTokenTransfer(address(0), to, tokenId);
881 
882         _balances[to] += 1;
883         _owners[tokenId] = to;
884 
885         emit Transfer(address(0), to, tokenId);
886     }
887 
888     /**
889      * @dev Destroys `tokenId`.
890      * The approval is cleared when the token is burned.
891      *
892      * Requirements:
893      *
894      * - `tokenId` must exist.
895      *
896      * Emits a {Transfer} event.
897      */
898     function _burn(uint256 tokenId) internal virtual {
899         address owner = ERC721.ownerOf(tokenId);
900 
901         _beforeTokenTransfer(owner, address(0), tokenId);
902 
903         // Clear approvals
904         _approve(address(0), tokenId);
905 
906         _balances[owner] -= 1;
907         delete _owners[tokenId];
908 
909         emit Transfer(owner, address(0), tokenId);
910     }
911 
912     /**
913      * @dev Transfers `tokenId` from `from` to `to`.
914      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
915      *
916      * Requirements:
917      *
918      * - `to` cannot be the zero address.
919      * - `tokenId` token must be owned by `from`.
920      *
921      * Emits a {Transfer} event.
922      */
923     function _transfer(
924         address from,
925         address to,
926         uint256 tokenId
927     ) internal virtual {
928         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
929         require(to != address(0), "ERC721: transfer to the zero address");
930 
931         _beforeTokenTransfer(from, to, tokenId);
932 
933         // Clear approvals from the previous owner
934         _approve(address(0), tokenId);
935 
936         _balances[from] -= 1;
937         _balances[to] += 1;
938         _owners[tokenId] = to;
939 
940         emit Transfer(from, to, tokenId);
941     }
942 
943     /**
944      * @dev Approve `to` to operate on `tokenId`
945      *
946      * Emits a {Approval} event.
947      */
948     function _approve(address to, uint256 tokenId) internal virtual {
949         _tokenApprovals[tokenId] = to;
950         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
951     }
952 
953     /**
954      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
955      * The call is not executed if the target address is not a contract.
956      *
957      * @param from address representing the previous owner of the given token ID
958      * @param to target address that will receive the tokens
959      * @param tokenId uint256 ID of the token to be transferred
960      * @param _data bytes optional data to send along with the call
961      * @return bool whether the call correctly returned the expected magic value
962      */
963     function _checkOnERC721Received(
964         address from,
965         address to,
966         uint256 tokenId,
967         bytes memory _data
968     ) private returns (bool) {
969         if (to.isContract()) {
970             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
971                 return retval == IERC721Receiver.onERC721Received.selector;
972             } catch (bytes memory reason) {
973                 if (reason.length == 0) {
974                     revert("ERC721: transfer to non ERC721Receiver implementer");
975                 } else {
976                     assembly {
977                         revert(add(32, reason), mload(reason))
978                     }
979                 }
980             }
981         } else {
982             return true;
983         }
984     }
985 
986     /**
987      * @dev Hook that is called before any token transfer. This includes minting
988      * and burning.
989      *
990      * Calling conditions:
991      *
992      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
993      * transferred to `to`.
994      * - When `from` is zero, `tokenId` will be minted for `to`.
995      * - When `to` is zero, ``from``'s `tokenId` will be burned.
996      * - `from` and `to` are never both zero.
997      *
998      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
999      */
1000     function _beforeTokenTransfer(
1001         address from,
1002         address to,
1003         uint256 tokenId
1004     ) internal virtual {}
1005 }
1006 
1007 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1008 
1009 
1010 
1011 pragma solidity ^0.8.0;
1012 
1013 
1014 
1015 /**
1016  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1017  * enumerability of all the token ids in the contract as well as all token ids owned by each
1018  * account.
1019  */
1020 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1021     // Mapping from owner to list of owned token IDs
1022     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1023 
1024     // Mapping from token ID to index of the owner tokens list
1025     mapping(uint256 => uint256) private _ownedTokensIndex;
1026 
1027     // Array with all token ids, used for enumeration
1028     uint256[] private _allTokens;
1029 
1030     // Mapping from token id to position in the allTokens array
1031     mapping(uint256 => uint256) private _allTokensIndex;
1032 
1033     /**
1034      * @dev See {IERC165-supportsInterface}.
1035      */
1036     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1037         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1038     }
1039 
1040     /**
1041      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1042      */
1043     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1044         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1045         return _ownedTokens[owner][index];
1046     }
1047 
1048     /**
1049      * @dev See {IERC721Enumerable-totalSupply}.
1050      */
1051     function totalSupply() public view virtual override returns (uint256) {
1052         return _allTokens.length;
1053     }
1054 
1055     /**
1056      * @dev See {IERC721Enumerable-tokenByIndex}.
1057      */
1058     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1059         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1060         return _allTokens[index];
1061     }
1062 
1063     /**
1064      * @dev Hook that is called before any token transfer. This includes minting
1065      * and burning.
1066      *
1067      * Calling conditions:
1068      *
1069      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1070      * transferred to `to`.
1071      * - When `from` is zero, `tokenId` will be minted for `to`.
1072      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1073      * - `from` cannot be the zero address.
1074      * - `to` cannot be the zero address.
1075      *
1076      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1077      */
1078     function _beforeTokenTransfer(
1079         address from,
1080         address to,
1081         uint256 tokenId
1082     ) internal virtual override {
1083         super._beforeTokenTransfer(from, to, tokenId);
1084 
1085         if (from == address(0)) {
1086             _addTokenToAllTokensEnumeration(tokenId);
1087         } else if (from != to) {
1088             _removeTokenFromOwnerEnumeration(from, tokenId);
1089         }
1090         if (to == address(0)) {
1091             _removeTokenFromAllTokensEnumeration(tokenId);
1092         } else if (to != from) {
1093             _addTokenToOwnerEnumeration(to, tokenId);
1094         }
1095     }
1096 
1097     /**
1098      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1099      * @param to address representing the new owner of the given token ID
1100      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1101      */
1102     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1103         uint256 length = ERC721.balanceOf(to);
1104         _ownedTokens[to][length] = tokenId;
1105         _ownedTokensIndex[tokenId] = length;
1106     }
1107 
1108     /**
1109      * @dev Private function to add a token to this extension's token tracking data structures.
1110      * @param tokenId uint256 ID of the token to be added to the tokens list
1111      */
1112     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1113         _allTokensIndex[tokenId] = _allTokens.length;
1114         _allTokens.push(tokenId);
1115     }
1116 
1117     /**
1118      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1119      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1120      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1121      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1122      * @param from address representing the previous owner of the given token ID
1123      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1124      */
1125     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1126         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1127         // then delete the last slot (swap and pop).
1128 
1129         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1130         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1131 
1132         // When the token to delete is the last token, the swap operation is unnecessary
1133         if (tokenIndex != lastTokenIndex) {
1134             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1135 
1136             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1137             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1138         }
1139 
1140         // This also deletes the contents at the last position of the array
1141         delete _ownedTokensIndex[tokenId];
1142         delete _ownedTokens[from][lastTokenIndex];
1143     }
1144 
1145     /**
1146      * @dev Private function to remove a token from this extension's token tracking data structures.
1147      * This has O(1) time complexity, but alters the order of the _allTokens array.
1148      * @param tokenId uint256 ID of the token to be removed from the tokens list
1149      */
1150     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1151         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1152         // then delete the last slot (swap and pop).
1153 
1154         uint256 lastTokenIndex = _allTokens.length - 1;
1155         uint256 tokenIndex = _allTokensIndex[tokenId];
1156 
1157         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1158         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1159         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1160         uint256 lastTokenId = _allTokens[lastTokenIndex];
1161 
1162         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1163         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1164 
1165         // This also deletes the contents at the last position of the array
1166         delete _allTokensIndex[tokenId];
1167         _allTokens.pop();
1168     }
1169 }
1170 
1171 
1172 // File: @openzeppelin/contracts/access/Ownable.sol
1173 pragma solidity ^0.8.0;
1174 /**
1175  * @dev Contract module which provides a basic access control mechanism, where
1176  * there is an account (an owner) that can be granted exclusive access to
1177  * specific functions.
1178  *
1179  * By default, the owner account will be the one that deploys the contract. This
1180  * can later be changed with {transferOwnership}.
1181  *
1182  * This module is used through inheritance. It will make available the modifier
1183  * `onlyOwner`, which can be applied to your functions to restrict their use to
1184  * the owner.
1185  */
1186 abstract contract Ownable is Context {
1187     address private _owner;
1188 
1189     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1190 
1191     /**
1192      * @dev Initializes the contract setting the deployer as the initial owner.
1193      */
1194     constructor() {
1195         _setOwner(_msgSender());
1196     }
1197 
1198     /**
1199      * @dev Returns the address of the current owner.
1200      */
1201     function owner() public view virtual returns (address) {
1202         return _owner;
1203     }
1204 
1205     /**
1206      * @dev Throws if called by any account other than the owner.
1207      */
1208     modifier onlyOwner() {
1209         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1210         _;
1211     }
1212 
1213     /**
1214      * @dev Leaves the contract without owner. It will not be possible to call
1215      * `onlyOwner` functions anymore. Can only be called by the current owner.
1216      *
1217      * NOTE: Renouncing ownership will leave the contract without an owner,
1218      * thereby removing any functionality that is only available to the owner.
1219      */
1220     function renounceOwnership() public virtual onlyOwner {
1221         _setOwner(address(0));
1222     }
1223 
1224     /**
1225      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1226      * Can only be called by the current owner.
1227      */
1228     function transferOwnership(address newOwner) public virtual onlyOwner {
1229         require(newOwner != address(0), "Ownable: new owner is the zero address");
1230         _setOwner(newOwner);
1231     }
1232 
1233     function _setOwner(address newOwner) private {
1234         address oldOwner = _owner;
1235         _owner = newOwner;
1236         emit OwnershipTransferred(oldOwner, newOwner);
1237     }
1238 }
1239 
1240 
1241 //
1242 // The Ouroboros Foundry - minting 1000 individual Crypto Ouroboros. From the digital artist Collie Pixels
1243 // https://crypto-ouroboros.com/
1244 // https://www.colliepixels.com/
1245 //
1246 // Much gratitude to HashLips!
1247 //
1248 
1249 pragma solidity ^0.8.0;
1250 
1251 
1252 
1253 contract OuroborosFoundry is ERC721Enumerable, Ownable {
1254   using Strings for uint256;
1255 
1256   string public baseURI = "https://crypto-ouroboros.com/metadata/";
1257   //string public baseURI;
1258   string public baseExtension = ".json";
1259   uint256 public cost = 0 ether;
1260   uint256 public maxSupply = 1000;
1261   uint256 public maxMintAmount = 20;
1262   bool public paused = false;
1263   mapping(address => bool) public whitelisted;
1264 
1265   constructor(
1266     string memory _name,
1267     string memory _symbol,
1268     string memory _initBaseURI
1269   ) ERC721(_name, _symbol) {
1270     setBaseURI(_initBaseURI);
1271     mint(msg.sender, 20);
1272   }
1273 
1274   // internal
1275   function _baseURI() internal view virtual override returns (string memory) {
1276     return baseURI;
1277   }
1278 
1279   // public
1280   function mint(address _to, uint256 _mintAmount) public payable {
1281     uint256 supply = totalSupply();
1282     require(!paused);
1283     require(_mintAmount > 0);
1284     require(_mintAmount <= maxMintAmount);
1285     require(supply + _mintAmount <= maxSupply);
1286 
1287     if (msg.sender != owner()) {
1288         if(whitelisted[msg.sender] != true) {
1289           require(msg.value >= cost * _mintAmount);
1290         }
1291     }
1292 
1293     for (uint256 i = 1; i <= _mintAmount; i++) {
1294       _safeMint(_to, supply + i);
1295     }
1296   }
1297 
1298   function walletOfOwner(address _owner)
1299     public
1300     view
1301     returns (uint256[] memory)
1302   {
1303     uint256 ownerTokenCount = balanceOf(_owner);
1304     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1305     for (uint256 i; i < ownerTokenCount; i++) {
1306       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1307     }
1308     return tokenIds;
1309   }
1310 
1311   function tokenURI(uint256 tokenId)
1312     public
1313     view
1314     virtual
1315     override
1316     returns (string memory)
1317   {
1318     require(
1319       _exists(tokenId),
1320       "ERC721Metadata: URI query for nonexistent token"
1321     );
1322 
1323     string memory currentBaseURI = _baseURI();
1324     return bytes(currentBaseURI).length > 0
1325         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1326         : "";
1327   }
1328 
1329   //only owner
1330   function setCost(uint256 _newCost) public onlyOwner() {
1331     cost = _newCost;
1332   }
1333 
1334   function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner() {
1335     maxMintAmount = _newmaxMintAmount;
1336   }
1337 
1338   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1339     baseURI = _newBaseURI;
1340   }
1341 
1342   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1343     baseExtension = _newBaseExtension;
1344   }
1345 
1346   function pause(bool _state) public onlyOwner {
1347     paused = _state;
1348   }
1349  
1350  function whitelistUser(address _user) public onlyOwner {
1351     whitelisted[_user] = true;
1352   }
1353  
1354   function removeWhitelistUser(address _user) public onlyOwner {
1355     whitelisted[_user] = false;
1356   }
1357 
1358   function withdraw() public payable onlyOwner {
1359     require(payable(msg.sender).send(address(this).balance));
1360   }
1361 }