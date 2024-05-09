1 // SPDX-License-Identifier: GPL-3.0
2 
3 //                                                                               
4 //   `.........`// ///  -////////--///:`      ::::: ...........       ----           -:::::::.      
5 //     :////////  /////-.:////////--////.      :////`///////////`      ////`         `:///////:`     
6 // -:://::::---- `////////:````````-////.      /////`////:::::://::   `////`      `////:-----:////`  
7 // :////-         /////:::.        -////-      /////`////.    `///:.:::////:::::-.`////-     :////`  
8 // :////-         /////`           -////-     `/////`////.    `///:./////////////-`////.     :////`  
9 // :////-         /////`           -:///::::::://///`////.    `///:``..////-..`````////.     :////`  
10 // :////:........`/////                :////////////`////-....-///:   `////.      `////-`````:////`  
11 // ````://///////`/////                .---:::://///`///////////-``    ////.       ...:///////:...   
12 //     -:::::::::`.....                ```````./////`/////::::::       :///.````      -:::::::-      
13 //         ``....``````            -////////////:-..`////.    .---`    ..-///////:                   
14 //         ///////////:            -////////////`    ....     :///`       :::////:                   
15 //         ////////////::-   `......-.``````````              ////.           ..........``           
16 //         ////-     .////   .///////.   :////`      :///-`:::////::::::.    .////////////`          
17 //         ////-     .////   `----:://::.:////`      ////:./////////////- -:::///:::::::::`          
18 //         ////.     .////   `-----:////.:////.     `/////```.////-..```` /////.``````               
19 //         ////.     .////   -//////////.:////.     `/////    :///.       `..-////////:              
20 //         ////.     `////`////-----////.:////.     `/////    :///.          `:::://///:--`          
21 //         ////.     `////`///:.....////.:////-`````./////    :///-`````  `````````..:////`          
22 //         -:::`     `:::: ..://////////..---////////////:    ..-////////`/////////////--.`          
23 //                           .::::::::::.    :://////////:       ::://///`::::::::::::-      
24 
25 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
26 pragma solidity ^0.8.0;
27 /**
28  * @dev Interface of the ERC165 standard, as defined in the
29  * https://eips.ethereum.org/EIPS/eip-165[EIP].
30  *
31  * Implementers can declare support of contract interfaces, which can then be
32  * queried by others ({ERC165Checker}).
33  *
34  * For an implementation, see {ERC165}.
35  */
36 interface IERC165 {
37     /**
38      * @dev Returns true if this contract implements the interface defined by
39      * `interfaceId`. See the corresponding
40      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
41      * to learn more about how these ids are created.
42      *
43      * This function call must use less than 30 000 gas.
44      */
45     function supportsInterface(bytes4 interfaceId) external view returns (bool);
46 }
47 
48 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
49 pragma solidity ^0.8.0;
50 /**
51  * @dev Required interface of an ERC721 compliant contract.
52  */
53 interface IERC721 is IERC165 {
54     /**
55      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
56      */
57     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
58 
59     /**
60      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
61      */
62     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
63 
64     /**
65      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
66      */
67     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
68 
69     /**
70      * @dev Returns the number of tokens in ``owner``'s account.
71      */
72     function balanceOf(address owner) external view returns (uint256 balance);
73 
74     /**
75      * @dev Returns the owner of the `tokenId` token.
76      *
77      * Requirements:
78      *
79      * - `tokenId` must exist.
80      */
81     function ownerOf(uint256 tokenId) external view returns (address owner);
82 
83     /**
84      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
85      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
86      *
87      * Requirements:
88      *
89      * - `from` cannot be the zero address.
90      * - `to` cannot be the zero address.
91      * - `tokenId` token must exist and be owned by `from`.
92      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
93      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
94      *
95      * Emits a {Transfer} event.
96      */
97     function safeTransferFrom(
98         address from,
99         address to,
100         uint256 tokenId
101     ) external;
102 
103     /**
104      * @dev Transfers `tokenId` token from `from` to `to`.
105      *
106      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
107      *
108      * Requirements:
109      *
110      * - `from` cannot be the zero address.
111      * - `to` cannot be the zero address.
112      * - `tokenId` token must be owned by `from`.
113      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
114      *
115      * Emits a {Transfer} event.
116      */
117     function transferFrom(
118         address from,
119         address to,
120         uint256 tokenId
121     ) external;
122 
123     /**
124      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
125      * The approval is cleared when the token is transferred.
126      *
127      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
128      *
129      * Requirements:
130      *
131      * - The caller must own the token or be an approved operator.
132      * - `tokenId` must exist.
133      *
134      * Emits an {Approval} event.
135      */
136     function approve(address to, uint256 tokenId) external;
137 
138     /**
139      * @dev Returns the account approved for `tokenId` token.
140      *
141      * Requirements:
142      *
143      * - `tokenId` must exist.
144      */
145     function getApproved(uint256 tokenId) external view returns (address operator);
146 
147     /**
148      * @dev Approve or remove `operator` as an operator for the caller.
149      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
150      *
151      * Requirements:
152      *
153      * - The `operator` cannot be the caller.
154      *
155      * Emits an {ApprovalForAll} event.
156      */
157     function setApprovalForAll(address operator, bool _approved) external;
158 
159     /**
160      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
161      *
162      * See {setApprovalForAll}
163      */
164     function isApprovedForAll(address owner, address operator) external view returns (bool);
165 
166     /**
167      * @dev Safely transfers `tokenId` token from `from` to `to`.
168      *
169      * Requirements:
170      *
171      * - `from` cannot be the zero address.
172      * - `to` cannot be the zero address.
173      * - `tokenId` token must exist and be owned by `from`.
174      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
175      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
176      *
177      * Emits a {Transfer} event.
178      */
179     function safeTransferFrom(
180         address from,
181         address to,
182         uint256 tokenId,
183         bytes calldata data
184     ) external;
185 }
186 
187 
188 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
189 pragma solidity ^0.8.0;
190 /**
191  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
192  * @dev See https://eips.ethereum.org/EIPS/eip-721
193  */
194 interface IERC721Enumerable is IERC721 {
195     /**
196      * @dev Returns the total amount of tokens stored by the contract.
197      */
198     function totalSupply() external view returns (uint256);
199 
200     /**
201      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
202      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
203      */
204     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
205 
206     /**
207      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
208      * Use along with {totalSupply} to enumerate all tokens.
209      */
210     function tokenByIndex(uint256 index) external view returns (uint256);
211 }
212 
213 
214 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
215 pragma solidity ^0.8.0;
216 /**
217  * @dev Implementation of the {IERC165} interface.
218  *
219  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
220  * for the additional interface id that will be supported. For example:
221  *
222  * ```solidity
223  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
224  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
225  * }
226  * ```
227  *
228  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
229  */
230 abstract contract ERC165 is IERC165 {
231     /**
232      * @dev See {IERC165-supportsInterface}.
233      */
234     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
235         return interfaceId == type(IERC165).interfaceId;
236     }
237 }
238 
239 // File: @openzeppelin/contracts/utils/Strings.sol
240 
241 
242 
243 pragma solidity ^0.8.0;
244 
245 /**
246  * @dev String operations.
247  */
248 library Strings {
249     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
250 
251     /**
252      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
253      */
254     function toString(uint256 value) internal pure returns (string memory) {
255         // Inspired by OraclizeAPI's implementation - MIT licence
256         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
257 
258         if (value == 0) {
259             return "0";
260         }
261         uint256 temp = value;
262         uint256 digits;
263         while (temp != 0) {
264             digits++;
265             temp /= 10;
266         }
267         bytes memory buffer = new bytes(digits);
268         while (value != 0) {
269             digits -= 1;
270             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
271             value /= 10;
272         }
273         return string(buffer);
274     }
275 
276     /**
277      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
278      */
279     function toHexString(uint256 value) internal pure returns (string memory) {
280         if (value == 0) {
281             return "0x00";
282         }
283         uint256 temp = value;
284         uint256 length = 0;
285         while (temp != 0) {
286             length++;
287             temp >>= 8;
288         }
289         return toHexString(value, length);
290     }
291 
292     /**
293      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
294      */
295     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
296         bytes memory buffer = new bytes(2 * length + 2);
297         buffer[0] = "0";
298         buffer[1] = "x";
299         for (uint256 i = 2 * length + 1; i > 1; --i) {
300             buffer[i] = _HEX_SYMBOLS[value & 0xf];
301             value >>= 4;
302         }
303         require(value == 0, "Strings: hex length insufficient");
304         return string(buffer);
305     }
306 }
307 
308 // File: @openzeppelin/contracts/utils/Address.sol
309 
310 
311 
312 pragma solidity ^0.8.0;
313 
314 /**
315  * @dev Collection of functions related to the address type
316  */
317 library Address {
318     /**
319      * @dev Returns true if `account` is a contract.
320      *
321      * [IMPORTANT]
322      * ====
323      * It is unsafe to assume that an address for which this function returns
324      * false is an externally-owned account (EOA) and not a contract.
325      *
326      * Among others, `isContract` will return false for the following
327      * types of addresses:
328      *
329      *  - an externally-owned account
330      *  - a contract in construction
331      *  - an address where a contract will be created
332      *  - an address where a contract lived, but was destroyed
333      * ====
334      */
335     function isContract(address account) internal view returns (bool) {
336         // This method relies on extcodesize, which returns 0 for contracts in
337         // construction, since the code is only stored at the end of the
338         // constructor execution.
339 
340         uint256 size;
341         assembly {
342             size := extcodesize(account)
343         }
344         return size > 0;
345     }
346 
347     /**
348      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
349      * `recipient`, forwarding all available gas and reverting on errors.
350      *
351      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
352      * of certain opcodes, possibly making contracts go over the 2300 gas limit
353      * imposed by `transfer`, making them unable to receive funds via
354      * `transfer`. {sendValue} removes this limitation.
355      *
356      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
357      *
358      * IMPORTANT: because control is transferred to `recipient`, care must be
359      * taken to not create reentrancy vulnerabilities. Consider using
360      * {ReentrancyGuard} or the
361      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
362      */
363     function sendValue(address payable recipient, uint256 amount) internal {
364         require(address(this).balance >= amount, "Address: insufficient balance");
365 
366         (bool success, ) = recipient.call{value: amount}("");
367         require(success, "Address: unable to send value, recipient may have reverted");
368     }
369 
370     /**
371      * @dev Performs a Solidity function call using a low level `call`. A
372      * plain `call` is an unsafe replacement for a function call: use this
373      * function instead.
374      *
375      * If `target` reverts with a revert reason, it is bubbled up by this
376      * function (like regular Solidity function calls).
377      *
378      * Returns the raw returned data. To convert to the expected return value,
379      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
380      *
381      * Requirements:
382      *
383      * - `target` must be a contract.
384      * - calling `target` with `data` must not revert.
385      *
386      * _Available since v3.1._
387      */
388     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
389         return functionCall(target, data, "Address: low-level call failed");
390     }
391 
392     /**
393      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
394      * `errorMessage` as a fallback revert reason when `target` reverts.
395      *
396      * _Available since v3.1._
397      */
398     function functionCall(
399         address target,
400         bytes memory data,
401         string memory errorMessage
402     ) internal returns (bytes memory) {
403         return functionCallWithValue(target, data, 0, errorMessage);
404     }
405 
406     /**
407      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
408      * but also transferring `value` wei to `target`.
409      *
410      * Requirements:
411      *
412      * - the calling contract must have an ETH balance of at least `value`.
413      * - the called Solidity function must be `payable`.
414      *
415      * _Available since v3.1._
416      */
417     function functionCallWithValue(
418         address target,
419         bytes memory data,
420         uint256 value
421     ) internal returns (bytes memory) {
422         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
423     }
424 
425     /**
426      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
427      * with `errorMessage` as a fallback revert reason when `target` reverts.
428      *
429      * _Available since v3.1._
430      */
431     function functionCallWithValue(
432         address target,
433         bytes memory data,
434         uint256 value,
435         string memory errorMessage
436     ) internal returns (bytes memory) {
437         require(address(this).balance >= value, "Address: insufficient balance for call");
438         require(isContract(target), "Address: call to non-contract");
439 
440         (bool success, bytes memory returndata) = target.call{value: value}(data);
441         return verifyCallResult(success, returndata, errorMessage);
442     }
443 
444     /**
445      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
446      * but performing a static call.
447      *
448      * _Available since v3.3._
449      */
450     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
451         return functionStaticCall(target, data, "Address: low-level static call failed");
452     }
453 
454     /**
455      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
456      * but performing a static call.
457      *
458      * _Available since v3.3._
459      */
460     function functionStaticCall(
461         address target,
462         bytes memory data,
463         string memory errorMessage
464     ) internal view returns (bytes memory) {
465         require(isContract(target), "Address: static call to non-contract");
466 
467         (bool success, bytes memory returndata) = target.staticcall(data);
468         return verifyCallResult(success, returndata, errorMessage);
469     }
470 
471     /**
472      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
473      * but performing a delegate call.
474      *
475      * _Available since v3.4._
476      */
477     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
478         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
479     }
480 
481     /**
482      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
483      * but performing a delegate call.
484      *
485      * _Available since v3.4._
486      */
487     function functionDelegateCall(
488         address target,
489         bytes memory data,
490         string memory errorMessage
491     ) internal returns (bytes memory) {
492         require(isContract(target), "Address: delegate call to non-contract");
493 
494         (bool success, bytes memory returndata) = target.delegatecall(data);
495         return verifyCallResult(success, returndata, errorMessage);
496     }
497 
498     /**
499      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
500      * revert reason using the provided one.
501      *
502      * _Available since v4.3._
503      */
504     function verifyCallResult(
505         bool success,
506         bytes memory returndata,
507         string memory errorMessage
508     ) internal pure returns (bytes memory) {
509         if (success) {
510             return returndata;
511         } else {
512             // Look for revert reason and bubble it up if present
513             if (returndata.length > 0) {
514                 // The easiest way to bubble the revert reason is using memory via assembly
515 
516                 assembly {
517                     let returndata_size := mload(returndata)
518                     revert(add(32, returndata), returndata_size)
519                 }
520             } else {
521                 revert(errorMessage);
522             }
523         }
524     }
525 }
526 
527 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
528 
529 
530 
531 pragma solidity ^0.8.0;
532 
533 
534 /**
535  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
536  * @dev See https://eips.ethereum.org/EIPS/eip-721
537  */
538 interface IERC721Metadata is IERC721 {
539     /**
540      * @dev Returns the token collection name.
541      */
542     function name() external view returns (string memory);
543 
544     /**
545      * @dev Returns the token collection symbol.
546      */
547     function symbol() external view returns (string memory);
548 
549     /**
550      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
551      */
552     function tokenURI(uint256 tokenId) external view returns (string memory);
553 }
554 
555 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
556 
557 
558 
559 pragma solidity ^0.8.0;
560 
561 /**
562  * @title ERC721 token receiver interface
563  * @dev Interface for any contract that wants to support safeTransfers
564  * from ERC721 asset contracts.
565  */
566 interface IERC721Receiver {
567     /**
568      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
569      * by `operator` from `from`, this function is called.
570      *
571      * It must return its Solidity selector to confirm the token transfer.
572      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
573      *
574      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
575      */
576     function onERC721Received(
577         address operator,
578         address from,
579         uint256 tokenId,
580         bytes calldata data
581     ) external returns (bytes4);
582 }
583 
584 // File: @openzeppelin/contracts/utils/Context.sol
585 pragma solidity ^0.8.0;
586 /**
587  * @dev Provides information about the current execution context, including the
588  * sender of the transaction and its data. While these are generally available
589  * via msg.sender and msg.data, they should not be accessed in such a direct
590  * manner, since when dealing with meta-transactions the account sending and
591  * paying for execution may not be the actual sender (as far as an application
592  * is concerned).
593  *
594  * This contract is only required for intermediate, library-like contracts.
595  */
596 abstract contract Context {
597     function _msgSender() internal view virtual returns (address) {
598         return msg.sender;
599     }
600 
601     function _msgData() internal view virtual returns (bytes calldata) {
602         return msg.data;
603     }
604 }
605 
606 
607 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
608 pragma solidity ^0.8.0;
609 /**
610  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
611  * the Metadata extension, but not including the Enumerable extension, which is available separately as
612  * {ERC721Enumerable}.
613  */
614 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
615     using Address for address;
616     using Strings for uint256;
617 
618     // Token name
619     string private _name;
620 
621     // Token symbol
622     string private _symbol;
623 
624     // Mapping from token ID to owner address
625     mapping(uint256 => address) private _owners;
626 
627     // Mapping owner address to token count
628     mapping(address => uint256) private _balances;
629 
630     // Mapping from token ID to approved address
631     mapping(uint256 => address) private _tokenApprovals;
632 
633     // Mapping from owner to operator approvals
634     mapping(address => mapping(address => bool)) private _operatorApprovals;
635 
636     /**
637      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
638      */
639     constructor(string memory name_, string memory symbol_) {
640         _name = name_;
641         _symbol = symbol_;
642     }
643 
644     /**
645      * @dev See {IERC165-supportsInterface}.
646      */
647     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
648         return
649             interfaceId == type(IERC721).interfaceId ||
650             interfaceId == type(IERC721Metadata).interfaceId ||
651             super.supportsInterface(interfaceId);
652     }
653 
654     /**
655      * @dev See {IERC721-balanceOf}.
656      */
657     function balanceOf(address owner) public view virtual override returns (uint256) {
658         require(owner != address(0), "ERC721: balance query for the zero address");
659         return _balances[owner];
660     }
661 
662     /**
663      * @dev See {IERC721-ownerOf}.
664      */
665     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
666         address owner = _owners[tokenId];
667         require(owner != address(0), "ERC721: owner query for nonexistent token");
668         return owner;
669     }
670 
671     /**
672      * @dev See {IERC721Metadata-name}.
673      */
674     function name() public view virtual override returns (string memory) {
675         return _name;
676     }
677 
678     /**
679      * @dev See {IERC721Metadata-symbol}.
680      */
681     function symbol() public view virtual override returns (string memory) {
682         return _symbol;
683     }
684 
685     /**
686      * @dev See {IERC721Metadata-tokenURI}.
687      */
688     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
689         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
690 
691         string memory baseURI = _baseURI();
692         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
693     }
694 
695     /**
696      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
697      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
698      * by default, can be overriden in child contracts.
699      */
700     function _baseURI() internal view virtual returns (string memory) {
701         return "";
702     }
703 
704     /**
705      * @dev See {IERC721-approve}.
706      */
707     function approve(address to, uint256 tokenId) public virtual override {
708         address owner = ERC721.ownerOf(tokenId);
709         require(to != owner, "ERC721: approval to current owner");
710 
711         require(
712             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
713             "ERC721: approve caller is not owner nor approved for all"
714         );
715 
716         _approve(to, tokenId);
717     }
718 
719     /**
720      * @dev See {IERC721-getApproved}.
721      */
722     function getApproved(uint256 tokenId) public view virtual override returns (address) {
723         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
724 
725         return _tokenApprovals[tokenId];
726     }
727 
728     /**
729      * @dev See {IERC721-setApprovalForAll}.
730      */
731     function setApprovalForAll(address operator, bool approved) public virtual override {
732         require(operator != _msgSender(), "ERC721: approve to caller");
733 
734         _operatorApprovals[_msgSender()][operator] = approved;
735         emit ApprovalForAll(_msgSender(), operator, approved);
736     }
737 
738     /**
739      * @dev See {IERC721-isApprovedForAll}.
740      */
741     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
742         return _operatorApprovals[owner][operator];
743     }
744 
745     /**
746      * @dev See {IERC721-transferFrom}.
747      */
748     function transferFrom(
749         address from,
750         address to,
751         uint256 tokenId
752     ) public virtual override {
753         //solhint-disable-next-line max-line-length
754         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
755 
756         _transfer(from, to, tokenId);
757     }
758 
759     /**
760      * @dev See {IERC721-safeTransferFrom}.
761      */
762     function safeTransferFrom(
763         address from,
764         address to,
765         uint256 tokenId
766     ) public virtual override {
767         safeTransferFrom(from, to, tokenId, "");
768     }
769 
770     /**
771      * @dev See {IERC721-safeTransferFrom}.
772      */
773     function safeTransferFrom(
774         address from,
775         address to,
776         uint256 tokenId,
777         bytes memory _data
778     ) public virtual override {
779         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
780         _safeTransfer(from, to, tokenId, _data);
781     }
782 
783     /**
784      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
785      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
786      *
787      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
788      *
789      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
790      * implement alternative mechanisms to perform token transfer, such as signature-based.
791      *
792      * Requirements:
793      *
794      * - `from` cannot be the zero address.
795      * - `to` cannot be the zero address.
796      * - `tokenId` token must exist and be owned by `from`.
797      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
798      *
799      * Emits a {Transfer} event.
800      */
801     function _safeTransfer(
802         address from,
803         address to,
804         uint256 tokenId,
805         bytes memory _data
806     ) internal virtual {
807         _transfer(from, to, tokenId);
808         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
809     }
810 
811     /**
812      * @dev Returns whether `tokenId` exists.
813      *
814      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
815      *
816      * Tokens start existing when they are minted (`_mint`),
817      * and stop existing when they are burned (`_burn`).
818      */
819     function _exists(uint256 tokenId) internal view virtual returns (bool) {
820         return _owners[tokenId] != address(0);
821     }
822 
823     /**
824      * @dev Returns whether `spender` is allowed to manage `tokenId`.
825      *
826      * Requirements:
827      *
828      * - `tokenId` must exist.
829      */
830     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
831         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
832         address owner = ERC721.ownerOf(tokenId);
833         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
834     }
835 
836     /**
837      * @dev Safely mints `tokenId` and transfers it to `to`.
838      *
839      * Requirements:
840      *
841      * - `tokenId` must not exist.
842      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
843      *
844      * Emits a {Transfer} event.
845      */
846     function _safeMint(address to, uint256 tokenId) internal virtual {
847         _safeMint(to, tokenId, "");
848     }
849 
850     /**
851      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
852      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
853      */
854     function _safeMint(
855         address to,
856         uint256 tokenId,
857         bytes memory _data
858     ) internal virtual {
859         _mint(to, tokenId);
860         require(
861             _checkOnERC721Received(address(0), to, tokenId, _data),
862             "ERC721: transfer to non ERC721Receiver implementer"
863         );
864     }
865 
866     /**
867      * @dev Mints `tokenId` and transfers it to `to`.
868      *
869      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
870      *
871      * Requirements:
872      *
873      * - `tokenId` must not exist.
874      * - `to` cannot be the zero address.
875      *
876      * Emits a {Transfer} event.
877      */
878     function _mint(address to, uint256 tokenId) internal virtual {
879         require(to != address(0), "ERC721: mint to the zero address");
880         require(!_exists(tokenId), "ERC721: token already minted");
881 
882         _beforeTokenTransfer(address(0), to, tokenId);
883 
884         _balances[to] += 1;
885         _owners[tokenId] = to;
886 
887         emit Transfer(address(0), to, tokenId);
888     }
889 
890     /**
891      * @dev Destroys `tokenId`.
892      * The approval is cleared when the token is burned.
893      *
894      * Requirements:
895      *
896      * - `tokenId` must exist.
897      *
898      * Emits a {Transfer} event.
899      */
900     function _burn(uint256 tokenId) internal virtual {
901         address owner = ERC721.ownerOf(tokenId);
902 
903         _beforeTokenTransfer(owner, address(0), tokenId);
904 
905         // Clear approvals
906         _approve(address(0), tokenId);
907 
908         _balances[owner] -= 1;
909         delete _owners[tokenId];
910 
911         emit Transfer(owner, address(0), tokenId);
912     }
913 
914     /**
915      * @dev Transfers `tokenId` from `from` to `to`.
916      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
917      *
918      * Requirements:
919      *
920      * - `to` cannot be the zero address.
921      * - `tokenId` token must be owned by `from`.
922      *
923      * Emits a {Transfer} event.
924      */
925     function _transfer(
926         address from,
927         address to,
928         uint256 tokenId
929     ) internal virtual {
930         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
931         require(to != address(0), "ERC721: transfer to the zero address");
932 
933         _beforeTokenTransfer(from, to, tokenId);
934 
935         // Clear approvals from the previous owner
936         _approve(address(0), tokenId);
937 
938         _balances[from] -= 1;
939         _balances[to] += 1;
940         _owners[tokenId] = to;
941 
942         emit Transfer(from, to, tokenId);
943     }
944 
945     /**
946      * @dev Approve `to` to operate on `tokenId`
947      *
948      * Emits a {Approval} event.
949      */
950     function _approve(address to, uint256 tokenId) internal virtual {
951         _tokenApprovals[tokenId] = to;
952         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
953     }
954 
955     /**
956      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
957      * The call is not executed if the target address is not a contract.
958      *
959      * @param from address representing the previous owner of the given token ID
960      * @param to target address that will receive the tokens
961      * @param tokenId uint256 ID of the token to be transferred
962      * @param _data bytes optional data to send along with the call
963      * @return bool whether the call correctly returned the expected magic value
964      */
965     function _checkOnERC721Received(
966         address from,
967         address to,
968         uint256 tokenId,
969         bytes memory _data
970     ) private returns (bool) {
971         if (to.isContract()) {
972             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
973                 return retval == IERC721Receiver.onERC721Received.selector;
974             } catch (bytes memory reason) {
975                 if (reason.length == 0) {
976                     revert("ERC721: transfer to non ERC721Receiver implementer");
977                 } else {
978                     assembly {
979                         revert(add(32, reason), mload(reason))
980                     }
981                 }
982             }
983         } else {
984             return true;
985         }
986     }
987 
988     /**
989      * @dev Hook that is called before any token transfer. This includes minting
990      * and burning.
991      *
992      * Calling conditions:
993      *
994      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
995      * transferred to `to`.
996      * - When `from` is zero, `tokenId` will be minted for `to`.
997      * - When `to` is zero, ``from``'s `tokenId` will be burned.
998      * - `from` and `to` are never both zero.
999      *
1000      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1001      */
1002     function _beforeTokenTransfer(
1003         address from,
1004         address to,
1005         uint256 tokenId
1006     ) internal virtual {}
1007 }
1008 
1009 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1010 
1011 
1012 
1013 pragma solidity ^0.8.0;
1014 
1015 
1016 
1017 /**
1018  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1019  * enumerability of all the token ids in the contract as well as all token ids owned by each
1020  * account.
1021  */
1022 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1023     // Mapping from owner to list of owned token IDs
1024     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1025 
1026     // Mapping from token ID to index of the owner tokens list
1027     mapping(uint256 => uint256) private _ownedTokensIndex;
1028 
1029     // Array with all token ids, used for enumeration
1030     uint256[] private _allTokens;
1031 
1032     // Mapping from token id to position in the allTokens array
1033     mapping(uint256 => uint256) private _allTokensIndex;
1034 
1035     /**
1036      * @dev See {IERC165-supportsInterface}.
1037      */
1038     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1039         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1040     }
1041 
1042     /**
1043      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1044      */
1045     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1046         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1047         return _ownedTokens[owner][index];
1048     }
1049 
1050     /**
1051      * @dev See {IERC721Enumerable-totalSupply}.
1052      */
1053     function totalSupply() public view virtual override returns (uint256) {
1054         return _allTokens.length;
1055     }
1056 
1057     /**
1058      * @dev See {IERC721Enumerable-tokenByIndex}.
1059      */
1060     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1061         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1062         return _allTokens[index];
1063     }
1064 
1065     /**
1066      * @dev Hook that is called before any token transfer. This includes minting
1067      * and burning.
1068      *
1069      * Calling conditions:
1070      *
1071      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1072      * transferred to `to`.
1073      * - When `from` is zero, `tokenId` will be minted for `to`.
1074      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1075      * - `from` cannot be the zero address.
1076      * - `to` cannot be the zero address.
1077      *
1078      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1079      */
1080     function _beforeTokenTransfer(
1081         address from,
1082         address to,
1083         uint256 tokenId
1084     ) internal virtual override {
1085         super._beforeTokenTransfer(from, to, tokenId);
1086 
1087         if (from == address(0)) {
1088             _addTokenToAllTokensEnumeration(tokenId);
1089         } else if (from != to) {
1090             _removeTokenFromOwnerEnumeration(from, tokenId);
1091         }
1092         if (to == address(0)) {
1093             _removeTokenFromAllTokensEnumeration(tokenId);
1094         } else if (to != from) {
1095             _addTokenToOwnerEnumeration(to, tokenId);
1096         }
1097     }
1098 
1099     /**
1100      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1101      * @param to address representing the new owner of the given token ID
1102      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1103      */
1104     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1105         uint256 length = ERC721.balanceOf(to);
1106         _ownedTokens[to][length] = tokenId;
1107         _ownedTokensIndex[tokenId] = length;
1108     }
1109 
1110     /**
1111      * @dev Private function to add a token to this extension's token tracking data structures.
1112      * @param tokenId uint256 ID of the token to be added to the tokens list
1113      */
1114     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1115         _allTokensIndex[tokenId] = _allTokens.length;
1116         _allTokens.push(tokenId);
1117     }
1118 
1119     /**
1120      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1121      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1122      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1123      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1124      * @param from address representing the previous owner of the given token ID
1125      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1126      */
1127     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1128         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1129         // then delete the last slot (swap and pop).
1130 
1131         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1132         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1133 
1134         // When the token to delete is the last token, the swap operation is unnecessary
1135         if (tokenIndex != lastTokenIndex) {
1136             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1137 
1138             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1139             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1140         }
1141 
1142         // This also deletes the contents at the last position of the array
1143         delete _ownedTokensIndex[tokenId];
1144         delete _ownedTokens[from][lastTokenIndex];
1145     }
1146 
1147     /**
1148      * @dev Private function to remove a token from this extension's token tracking data structures.
1149      * This has O(1) time complexity, but alters the order of the _allTokens array.
1150      * @param tokenId uint256 ID of the token to be removed from the tokens list
1151      */
1152     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1153         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1154         // then delete the last slot (swap and pop).
1155 
1156         uint256 lastTokenIndex = _allTokens.length - 1;
1157         uint256 tokenIndex = _allTokensIndex[tokenId];
1158 
1159         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1160         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1161         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1162         uint256 lastTokenId = _allTokens[lastTokenIndex];
1163 
1164         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1165         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1166 
1167         // This also deletes the contents at the last position of the array
1168         delete _allTokensIndex[tokenId];
1169         _allTokens.pop();
1170     }
1171 }
1172 
1173 
1174 // File: @openzeppelin/contracts/access/Ownable.sol
1175 pragma solidity ^0.8.0;
1176 /**
1177  * @dev Contract module which provides a basic access control mechanism, where
1178  * there is an account (an owner) that can be granted exclusive access to
1179  * specific functions.
1180  *
1181  * By default, the owner account will be the one that deploys the contract. This
1182  * can later be changed with {transferOwnership}.
1183  *
1184  * This module is used through inheritance. It will make available the modifier
1185  * `onlyOwner`, which can be applied to your functions to restrict their use to
1186  * the owner.
1187  */
1188 abstract contract Ownable is Context {
1189     address private _owner;
1190 
1191     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1192 
1193     /**
1194      * @dev Initializes the contract setting the deployer as the initial owner.
1195      */
1196     constructor() {
1197         _setOwner(_msgSender());
1198     }
1199 
1200     /**
1201      * @dev Returns the address of the current owner.
1202      */
1203     function owner() public view virtual returns (address) {
1204         return _owner;
1205     }
1206 
1207     /**
1208      * @dev Throws if called by any account other than the owner.
1209      */
1210     modifier onlyOwner() {
1211         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1212         _;
1213     }
1214 
1215     /**
1216      * @dev Leaves the contract without owner. It will not be possible to call
1217      * `onlyOwner` functions anymore. Can only be called by the current owner.
1218      *
1219      * NOTE: Renouncing ownership will leave the contract without an owner,
1220      * thereby removing any functionality that is only available to the owner.
1221      */
1222     function renounceOwnership() public virtual onlyOwner {
1223         _setOwner(address(0));
1224     }
1225 
1226     /**
1227      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1228      * Can only be called by the current owner.
1229      */
1230     function transferOwnership(address newOwner) public virtual onlyOwner {
1231         require(newOwner != address(0), "Ownable: new owner is the zero address");
1232         _setOwner(newOwner);
1233     }
1234 
1235     function _setOwner(address newOwner) private {
1236         address oldOwner = _owner;
1237         _owner = newOwner;
1238         emit OwnershipTransferred(oldOwner, newOwner);
1239     }
1240 }
1241 
1242 
1243 
1244 pragma solidity >=0.7.0 <0.9.0;
1245 
1246 contract Cryptonauts is ERC721Enumerable, Ownable {
1247   using Strings for uint256;
1248 
1249   string public baseURI;
1250   string public baseExtension = ".json";
1251   string public notRevealedUri;
1252   uint256 public cost = 0.01 ether;
1253   uint256 public maxSupply = 9691;
1254   uint256 public maxMintAmount = 10;
1255   uint256 public nftPerAddressLimit = 10;
1256   bool public paused = true;
1257   bool public revealed = false;
1258   bool public onlyWhitelisted = true;
1259   address[] public whitelistedAddresses;
1260   mapping(address => uint256) public addressMintedBalance;
1261 
1262   constructor(
1263     string memory _name,
1264     string memory _symbol,
1265     string memory _initBaseURI,
1266     string memory _initNotRevealedUri
1267   ) ERC721(_name, _symbol) {
1268     setBaseURI(_initBaseURI);
1269     setNotRevealedURI(_initNotRevealedUri);
1270   }
1271 
1272   // internal
1273   function _baseURI() internal view virtual override returns (string memory) {
1274     return baseURI;
1275   }
1276 
1277   // public
1278   function mint(uint256 _mintAmount) public payable {
1279     require(!paused, "the contract is paused");
1280     uint256 supply = totalSupply();
1281     require(_mintAmount > 0, "need to mint at least 1 NFT");
1282     require(_mintAmount <= maxMintAmount, "max mint amount per session exceeded");
1283     require(supply + _mintAmount <= maxSupply, "max NFT limit exceeded");
1284 
1285     if (msg.sender != owner()) {
1286         if(onlyWhitelisted == true) {
1287             require(isWhitelisted(msg.sender), "user is not whitelisted");
1288             uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1289             require(ownerMintedCount + _mintAmount <= nftPerAddressLimit, "max NFT per address exceeded");
1290         }
1291         require(msg.value >= cost * _mintAmount, "insufficient funds");
1292     }
1293 
1294     for (uint256 i = 1; i <= _mintAmount; i++) {
1295       addressMintedBalance[msg.sender]++;
1296       _safeMint(msg.sender, supply + i);
1297     }
1298   }
1299   
1300   function isWhitelisted(address _user) public view returns (bool) {
1301     for (uint i = 0; i < whitelistedAddresses.length; i++) {
1302       if (whitelistedAddresses[i] == _user) {
1303           return true;
1304       }
1305     }
1306     return false;
1307   }
1308 
1309   function walletOfOwner(address _owner)
1310     public
1311     view
1312     returns (uint256[] memory)
1313   {
1314     uint256 ownerTokenCount = balanceOf(_owner);
1315     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1316     for (uint256 i; i < ownerTokenCount; i++) {
1317       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1318     }
1319     return tokenIds;
1320   }
1321 
1322   function tokenURI(uint256 tokenId)
1323     public
1324     view
1325     virtual
1326     override
1327     returns (string memory)
1328   {
1329     require(
1330       _exists(tokenId),
1331       "ERC721Metadata: URI query for nonexistent token"
1332     );
1333     
1334     if(revealed == false) {
1335         return notRevealedUri;
1336     }
1337 
1338     string memory currentBaseURI = _baseURI();
1339     return bytes(currentBaseURI).length > 0
1340         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1341         : "";
1342   }
1343 
1344   //only owner
1345   function reveal() public onlyOwner() {
1346       revealed = true;
1347   }
1348   
1349   function setNftPerAddressLimit(uint256 _limit) public onlyOwner() {
1350     nftPerAddressLimit = _limit;
1351   }
1352   
1353   function setCost(uint256 _newCost) public onlyOwner() {
1354     cost = _newCost;
1355   }
1356 
1357   function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner() {
1358     maxMintAmount = _newmaxMintAmount;
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
1369   function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1370     notRevealedUri = _notRevealedURI;
1371   }
1372 
1373   function pause(bool _state) public onlyOwner {
1374     paused = _state;
1375   }
1376   
1377   function setOnlyWhitelisted(bool _state) public onlyOwner {
1378     onlyWhitelisted = _state;
1379   }
1380   
1381   function whitelistUsers(address[] calldata _users) public onlyOwner {
1382     delete whitelistedAddresses;
1383     whitelistedAddresses = _users;
1384   }
1385  
1386   function withdraw() public payable onlyOwner {
1387     (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
1388     require(success);
1389   }
1390 }