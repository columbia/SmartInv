1 // SPDX-License-Identifier: GPL-3.0
2 
3 /**
4 
5  $$$$$$\                                $$\                       $$$$$$$\                      $$\                 
6 $$  __$$\                               $$ |                      $$  __$$\                     $$ |                
7 $$ /  $$ |$$\   $$\  $$$$$$\   $$$$$$$\ $$ |  $$\ $$\   $$\       $$ |  $$ |$$\   $$\  $$$$$$$\ $$ |  $$\  $$$$$$$\ 
8 $$ |  $$ |$$ |  $$ | \____$$\ $$  _____|$$ | $$  |$$ |  $$ |      $$ |  $$ |$$ |  $$ |$$  _____|$$ | $$  |$$  _____|
9 $$ |  $$ |$$ |  $$ | $$$$$$$ |$$ /      $$$$$$  / $$ |  $$ |      $$ |  $$ |$$ |  $$ |$$ /      $$$$$$  / \$$$$$$\  
10 $$ $$\$$ |$$ |  $$ |$$  __$$ |$$ |      $$  _$$<  $$ |  $$ |      $$ |  $$ |$$ |  $$ |$$ |      $$  _$$<   \____$$\ 
11 \$$$$$$ / \$$$$$$  |\$$$$$$$ |\$$$$$$$\ $$ | \$$\ \$$$$$$$ |      $$$$$$$  |\$$$$$$  |\$$$$$$$\ $$ | \$$\ $$$$$$$  |
12  \___$$$\  \______/  \_______| \_______|\__|  \__| \____$$ |      \_______/  \______/  \_______|\__|  \__|\_______/ 
13      \___|                                        $$\   $$ |                                                        
14                                                   \$$$$$$  |                                                        
15                                                    \______/                                                         
16 
17 */
18 
19 /**
20     !Disclaimer!
21     Please review this code on your own before using any of
22     the following code for production.
23     
24 */
25 
26 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
27 pragma solidity ^0.8.0;
28 /**
29  * @dev Interface of the ERC165 standard, as defined in the
30  * https://eips.ethereum.org/EIPS/eip-165[EIP].
31  *
32  * Implementers can declare support of contract interfaces, which can then be
33  * queried by others ({ERC165Checker}).
34  *
35  * For an implementation, see {ERC165}.
36  */
37 interface IERC165 {
38     /**
39      * @dev Returns true if this contract implements the interface defined by
40      * `interfaceId`. See the corresponding
41      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
42      * to learn more about how these ids are created.
43      *
44      * This function call must use less than 30 000 gas.
45      */
46     function supportsInterface(bytes4 interfaceId) external view returns (bool);
47 }
48 
49 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
50 pragma solidity ^0.8.0;
51 /**
52  * @dev Required interface of an ERC721 compliant contract.
53  */
54 interface IERC721 is IERC165 {
55     /**
56      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
57      */
58     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
59 
60     /**
61      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
62      */
63     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
64 
65     /**
66      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
67      */
68     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
69 
70     /**
71      * @dev Returns the number of tokens in ``owner``'s account.
72      */
73     function balanceOf(address owner) external view returns (uint256 balance);
74 
75     /**
76      * @dev Returns the owner of the `tokenId` token.
77      *
78      * Requirements:
79      *
80      * - `tokenId` must exist.
81      */
82     function ownerOf(uint256 tokenId) external view returns (address owner);
83 
84     /**
85      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
86      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
87      *
88      * Requirements:
89      *
90      * - `from` cannot be the zero address.
91      * - `to` cannot be the zero address.
92      * - `tokenId` token must exist and be owned by `from`.
93      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
94      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
95      *
96      * Emits a {Transfer} event.
97      */
98     function safeTransferFrom(
99         address from,
100         address to,
101         uint256 tokenId
102     ) external;
103 
104     /**
105      * @dev Transfers `tokenId` token from `from` to `to`.
106      *
107      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
108      *
109      * Requirements:
110      *
111      * - `from` cannot be the zero address.
112      * - `to` cannot be the zero address.
113      * - `tokenId` token must be owned by `from`.
114      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
115      *
116      * Emits a {Transfer} event.
117      */
118     function transferFrom(
119         address from,
120         address to,
121         uint256 tokenId
122     ) external;
123 
124     /**
125      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
126      * The approval is cleared when the token is transferred.
127      *
128      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
129      *
130      * Requirements:
131      *
132      * - The caller must own the token or be an approved operator.
133      * - `tokenId` must exist.
134      *
135      * Emits an {Approval} event.
136      */
137     function approve(address to, uint256 tokenId) external;
138 
139     /**
140      * @dev Returns the account approved for `tokenId` token.
141      *
142      * Requirements:
143      *
144      * - `tokenId` must exist.
145      */
146     function getApproved(uint256 tokenId) external view returns (address operator);
147 
148     /**
149      * @dev Approve or remove `operator` as an operator for the caller.
150      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
151      *
152      * Requirements:
153      *
154      * - The `operator` cannot be the caller.
155      *
156      * Emits an {ApprovalForAll} event.
157      */
158     function setApprovalForAll(address operator, bool _approved) external;
159 
160     /**
161      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
162      *
163      * See {setApprovalForAll}
164      */
165     function isApprovedForAll(address owner, address operator) external view returns (bool);
166 
167     /**
168      * @dev Safely transfers `tokenId` token from `from` to `to`.
169      *
170      * Requirements:
171      *
172      * - `from` cannot be the zero address.
173      * - `to` cannot be the zero address.
174      * - `tokenId` token must exist and be owned by `from`.
175      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
176      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
177      *
178      * Emits a {Transfer} event.
179      */
180     function safeTransferFrom(
181         address from,
182         address to,
183         uint256 tokenId,
184         bytes calldata data
185     ) external;
186 }
187 
188 
189 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
190 pragma solidity ^0.8.0;
191 /**
192  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
193  * @dev See https://eips.ethereum.org/EIPS/eip-721
194  */
195 interface IERC721Enumerable is IERC721 {
196     /**
197      * @dev Returns the total amount of tokens stored by the contract.
198      */
199     function totalSupply() external view returns (uint256);
200 
201     /**
202      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
203      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
204      */
205     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
206 
207     /**
208      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
209      * Use along with {totalSupply} to enumerate all tokens.
210      */
211     function tokenByIndex(uint256 index) external view returns (uint256);
212 }
213 
214 
215 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
216 pragma solidity ^0.8.0;
217 /**
218  * @dev Implementation of the {IERC165} interface.
219  *
220  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
221  * for the additional interface id that will be supported. For example:
222  *
223  * ```solidity
224  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
225  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
226  * }
227  * ```
228  *
229  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
230  */
231 abstract contract ERC165 is IERC165 {
232     /**
233      * @dev See {IERC165-supportsInterface}.
234      */
235     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
236         return interfaceId == type(IERC165).interfaceId;
237     }
238 }
239 
240 // File: @openzeppelin/contracts/utils/Strings.sol
241 
242 
243 
244 pragma solidity ^0.8.0;
245 
246 /**
247  * @dev String operations.
248  */
249 library Strings {
250     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
251 
252     /**
253      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
254      */
255     function toString(uint256 value) internal pure returns (string memory) {
256         // Inspired by OraclizeAPI's implementation - MIT licence
257         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
258 
259         if (value == 0) {
260             return "0";
261         }
262         uint256 temp = value;
263         uint256 digits;
264         while (temp != 0) {
265             digits++;
266             temp /= 10;
267         }
268         bytes memory buffer = new bytes(digits);
269         while (value != 0) {
270             digits -= 1;
271             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
272             value /= 10;
273         }
274         return string(buffer);
275     }
276 
277     /**
278      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
279      */
280     function toHexString(uint256 value) internal pure returns (string memory) {
281         if (value == 0) {
282             return "0x00";
283         }
284         uint256 temp = value;
285         uint256 length = 0;
286         while (temp != 0) {
287             length++;
288             temp >>= 8;
289         }
290         return toHexString(value, length);
291     }
292 
293     /**
294      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
295      */
296     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
297         bytes memory buffer = new bytes(2 * length + 2);
298         buffer[0] = "0";
299         buffer[1] = "x";
300         for (uint256 i = 2 * length + 1; i > 1; --i) {
301             buffer[i] = _HEX_SYMBOLS[value & 0xf];
302             value >>= 4;
303         }
304         require(value == 0, "Strings: hex length insufficient");
305         return string(buffer);
306     }
307 }
308 
309 // File: @openzeppelin/contracts/utils/Address.sol
310 
311 
312 
313 pragma solidity ^0.8.0;
314 
315 /**
316  * @dev Collection of functions related to the address type
317  */
318 library Address {
319     /**
320      * @dev Returns true if `account` is a contract.
321      *
322      * [IMPORTANT]
323      * ====
324      * It is unsafe to assume that an address for which this function returns
325      * false is an externally-owned account (EOA) and not a contract.
326      *
327      * Among others, `isContract` will return false for the following
328      * types of addresses:
329      *
330      *  - an externally-owned account
331      *  - a contract in construction
332      *  - an address where a contract will be created
333      *  - an address where a contract lived, but was destroyed
334      * ====
335      */
336     function isContract(address account) internal view returns (bool) {
337         // This method relies on extcodesize, which returns 0 for contracts in
338         // construction, since the code is only stored at the end of the
339         // constructor execution.
340 
341         uint256 size;
342         assembly {
343             size := extcodesize(account)
344         }
345         return size > 0;
346     }
347 
348     /**
349      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
350      * `recipient`, forwarding all available gas and reverting on errors.
351      *
352      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
353      * of certain opcodes, possibly making contracts go over the 2300 gas limit
354      * imposed by `transfer`, making them unable to receive funds via
355      * `transfer`. {sendValue} removes this limitation.
356      *
357      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
358      *
359      * IMPORTANT: because control is transferred to `recipient`, care must be
360      * taken to not create reentrancy vulnerabilities. Consider using
361      * {ReentrancyGuard} or the
362      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
363      */
364     function sendValue(address payable recipient, uint256 amount) internal {
365         require(address(this).balance >= amount, "Address: insufficient balance");
366 
367         (bool success, ) = recipient.call{value: amount}("");
368         require(success, "Address: unable to send value, recipient may have reverted");
369     }
370 
371     /**
372      * @dev Performs a Solidity function call using a low level `call`. A
373      * plain `call` is an unsafe replacement for a function call: use this
374      * function instead.
375      *
376      * If `target` reverts with a revert reason, it is bubbled up by this
377      * function (like regular Solidity function calls).
378      *
379      * Returns the raw returned data. To convert to the expected return value,
380      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
381      *
382      * Requirements:
383      *
384      * - `target` must be a contract.
385      * - calling `target` with `data` must not revert.
386      *
387      * _Available since v3.1._
388      */
389     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
390         return functionCall(target, data, "Address: low-level call failed");
391     }
392 
393     /**
394      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
395      * `errorMessage` as a fallback revert reason when `target` reverts.
396      *
397      * _Available since v3.1._
398      */
399     function functionCall(
400         address target,
401         bytes memory data,
402         string memory errorMessage
403     ) internal returns (bytes memory) {
404         return functionCallWithValue(target, data, 0, errorMessage);
405     }
406 
407     /**
408      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
409      * but also transferring `value` wei to `target`.
410      *
411      * Requirements:
412      *
413      * - the calling contract must have an ETH balance of at least `value`.
414      * - the called Solidity function must be `payable`.
415      *
416      * _Available since v3.1._
417      */
418     function functionCallWithValue(
419         address target,
420         bytes memory data,
421         uint256 value
422     ) internal returns (bytes memory) {
423         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
424     }
425 
426     /**
427      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
428      * with `errorMessage` as a fallback revert reason when `target` reverts.
429      *
430      * _Available since v3.1._
431      */
432     function functionCallWithValue(
433         address target,
434         bytes memory data,
435         uint256 value,
436         string memory errorMessage
437     ) internal returns (bytes memory) {
438         require(address(this).balance >= value, "Address: insufficient balance for call");
439         require(isContract(target), "Address: call to non-contract");
440 
441         (bool success, bytes memory returndata) = target.call{value: value}(data);
442         return verifyCallResult(success, returndata, errorMessage);
443     }
444 
445     /**
446      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
447      * but performing a static call.
448      *
449      * _Available since v3.3._
450      */
451     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
452         return functionStaticCall(target, data, "Address: low-level static call failed");
453     }
454 
455     /**
456      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
457      * but performing a static call.
458      *
459      * _Available since v3.3._
460      */
461     function functionStaticCall(
462         address target,
463         bytes memory data,
464         string memory errorMessage
465     ) internal view returns (bytes memory) {
466         require(isContract(target), "Address: static call to non-contract");
467 
468         (bool success, bytes memory returndata) = target.staticcall(data);
469         return verifyCallResult(success, returndata, errorMessage);
470     }
471 
472     /**
473      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
474      * but performing a delegate call.
475      *
476      * _Available since v3.4._
477      */
478     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
479         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
480     }
481 
482     /**
483      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
484      * but performing a delegate call.
485      *
486      * _Available since v3.4._
487      */
488     function functionDelegateCall(
489         address target,
490         bytes memory data,
491         string memory errorMessage
492     ) internal returns (bytes memory) {
493         require(isContract(target), "Address: delegate call to non-contract");
494 
495         (bool success, bytes memory returndata) = target.delegatecall(data);
496         return verifyCallResult(success, returndata, errorMessage);
497     }
498 
499     /**
500      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
501      * revert reason using the provided one.
502      *
503      * _Available since v4.3._
504      */
505     function verifyCallResult(
506         bool success,
507         bytes memory returndata,
508         string memory errorMessage
509     ) internal pure returns (bytes memory) {
510         if (success) {
511             return returndata;
512         } else {
513             // Look for revert reason and bubble it up if present
514             if (returndata.length > 0) {
515                 // The easiest way to bubble the revert reason is using memory via assembly
516 
517                 assembly {
518                     let returndata_size := mload(returndata)
519                     revert(add(32, returndata), returndata_size)
520                 }
521             } else {
522                 revert(errorMessage);
523             }
524         }
525     }
526 }
527 
528 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
529 
530 
531 
532 pragma solidity ^0.8.0;
533 
534 
535 /**
536  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
537  * @dev See https://eips.ethereum.org/EIPS/eip-721
538  */
539 interface IERC721Metadata is IERC721 {
540     /**
541      * @dev Returns the token collection name.
542      */
543     function name() external view returns (string memory);
544 
545     /**
546      * @dev Returns the token collection symbol.
547      */
548     function symbol() external view returns (string memory);
549 
550     /**
551      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
552      */
553     function tokenURI(uint256 tokenId) external view returns (string memory);
554 }
555 
556 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
557 
558 
559 
560 pragma solidity ^0.8.0;
561 
562 /**
563  * @title ERC721 token receiver interface
564  * @dev Interface for any contract that wants to support safeTransfers
565  * from ERC721 asset contracts.
566  */
567 interface IERC721Receiver {
568     /**
569      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
570      * by `operator` from `from`, this function is called.
571      *
572      * It must return its Solidity selector to confirm the token transfer.
573      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
574      *
575      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
576      */
577     function onERC721Received(
578         address operator,
579         address from,
580         uint256 tokenId,
581         bytes calldata data
582     ) external returns (bytes4);
583 }
584 
585 // File: @openzeppelin/contracts/utils/Context.sol
586 pragma solidity ^0.8.0;
587 /**
588  * @dev Provides information about the current execution context, including the
589  * sender of the transaction and its data. While these are generally available
590  * via msg.sender and msg.data, they should not be accessed in such a direct
591  * manner, since when dealing with meta-transactions the account sending and
592  * paying for execution may not be the actual sender (as far as an application
593  * is concerned).
594  *
595  * This contract is only required for intermediate, library-like contracts.
596  */
597 abstract contract Context {
598     function _msgSender() internal view virtual returns (address) {
599         return msg.sender;
600     }
601 
602     function _msgData() internal view virtual returns (bytes calldata) {
603         return msg.data;
604     }
605 }
606 
607 
608 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
609 pragma solidity ^0.8.0;
610 /**
611  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
612  * the Metadata extension, but not including the Enumerable extension, which is available separately as
613  * {ERC721Enumerable}.
614  */
615 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
616     using Address for address;
617     using Strings for uint256;
618 
619     // Token name
620     string private _name;
621 
622     // Token symbol
623     string private _symbol;
624 
625     // Mapping from token ID to owner address
626     mapping(uint256 => address) private _owners;
627 
628     // Mapping owner address to token count
629     mapping(address => uint256) private _balances;
630 
631     // Mapping from token ID to approved address
632     mapping(uint256 => address) private _tokenApprovals;
633 
634     // Mapping from owner to operator approvals
635     mapping(address => mapping(address => bool)) private _operatorApprovals;
636 
637     /**
638      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
639      */
640     constructor(string memory name_, string memory symbol_) {
641         _name = name_;
642         _symbol = symbol_;
643     }
644 
645     /**
646      * @dev See {IERC165-supportsInterface}.
647      */
648     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
649         return
650             interfaceId == type(IERC721).interfaceId ||
651             interfaceId == type(IERC721Metadata).interfaceId ||
652             super.supportsInterface(interfaceId);
653     }
654 
655     /**
656      * @dev See {IERC721-balanceOf}.
657      */
658     function balanceOf(address owner) public view virtual override returns (uint256) {
659         require(owner != address(0), "ERC721: balance query for the zero address");
660         return _balances[owner];
661     }
662 
663     /**
664      * @dev See {IERC721-ownerOf}.
665      */
666     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
667         address owner = _owners[tokenId];
668         require(owner != address(0), "ERC721: owner query for nonexistent token");
669         return owner;
670     }
671 
672     /**
673      * @dev See {IERC721Metadata-name}.
674      */
675     function name() public view virtual override returns (string memory) {
676         return _name;
677     }
678 
679     /**
680      * @dev See {IERC721Metadata-symbol}.
681      */
682     function symbol() public view virtual override returns (string memory) {
683         return _symbol;
684     }
685 
686     /**
687      * @dev See {IERC721Metadata-tokenURI}.
688      */
689     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
690         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
691 
692         string memory baseURI = _baseURI();
693         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
694     }
695 
696     /**
697      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
698      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
699      * by default, can be overriden in child contracts.
700      */
701     function _baseURI() internal view virtual returns (string memory) {
702         return "";
703     }
704 
705     /**
706      * @dev See {IERC721-approve}.
707      */
708     function approve(address to, uint256 tokenId) public virtual override {
709         address owner = ERC721.ownerOf(tokenId);
710         require(to != owner, "ERC721: approval to current owner");
711 
712         require(
713             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
714             "ERC721: approve caller is not owner nor approved for all"
715         );
716 
717         _approve(to, tokenId);
718     }
719 
720     /**
721      * @dev See {IERC721-getApproved}.
722      */
723     function getApproved(uint256 tokenId) public view virtual override returns (address) {
724         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
725 
726         return _tokenApprovals[tokenId];
727     }
728 
729     /**
730      * @dev See {IERC721-setApprovalForAll}.
731      */
732     function setApprovalForAll(address operator, bool approved) public virtual override {
733         require(operator != _msgSender(), "ERC721: approve to caller");
734 
735         _operatorApprovals[_msgSender()][operator] = approved;
736         emit ApprovalForAll(_msgSender(), operator, approved);
737     }
738 
739     /**
740      * @dev See {IERC721-isApprovedForAll}.
741      */
742     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
743         return _operatorApprovals[owner][operator];
744     }
745 
746     /**
747      * @dev See {IERC721-transferFrom}.
748      */
749     function transferFrom(
750         address from,
751         address to,
752         uint256 tokenId
753     ) public virtual override {
754         //solhint-disable-next-line max-line-length
755         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
756 
757         _transfer(from, to, tokenId);
758     }
759 
760     /**
761      * @dev See {IERC721-safeTransferFrom}.
762      */
763     function safeTransferFrom(
764         address from,
765         address to,
766         uint256 tokenId
767     ) public virtual override {
768         safeTransferFrom(from, to, tokenId, "");
769     }
770 
771     /**
772      * @dev See {IERC721-safeTransferFrom}.
773      */
774     function safeTransferFrom(
775         address from,
776         address to,
777         uint256 tokenId,
778         bytes memory _data
779     ) public virtual override {
780         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
781         _safeTransfer(from, to, tokenId, _data);
782     }
783 
784     /**
785      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
786      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
787      *
788      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
789      *
790      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
791      * implement alternative mechanisms to perform token transfer, such as signature-based.
792      *
793      * Requirements:
794      *
795      * - `from` cannot be the zero address.
796      * - `to` cannot be the zero address.
797      * - `tokenId` token must exist and be owned by `from`.
798      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
799      *
800      * Emits a {Transfer} event.
801      */
802     function _safeTransfer(
803         address from,
804         address to,
805         uint256 tokenId,
806         bytes memory _data
807     ) internal virtual {
808         _transfer(from, to, tokenId);
809         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
810     }
811 
812     /**
813      * @dev Returns whether `tokenId` exists.
814      *
815      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
816      *
817      * Tokens start existing when they are minted (`_mint`),
818      * and stop existing when they are burned (`_burn`).
819      */
820     function _exists(uint256 tokenId) internal view virtual returns (bool) {
821         return _owners[tokenId] != address(0);
822     }
823 
824     /**
825      * @dev Returns whether `spender` is allowed to manage `tokenId`.
826      *
827      * Requirements:
828      *
829      * - `tokenId` must exist.
830      */
831     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
832         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
833         address owner = ERC721.ownerOf(tokenId);
834         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
835     }
836 
837     /**
838      * @dev Safely mints `tokenId` and transfers it to `to`.
839      *
840      * Requirements:
841      *
842      * - `tokenId` must not exist.
843      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
844      *
845      * Emits a {Transfer} event.
846      */
847     function _safeMint(address to, uint256 tokenId) internal virtual {
848         _safeMint(to, tokenId, "");
849     }
850 
851     /**
852      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
853      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
854      */
855     function _safeMint(
856         address to,
857         uint256 tokenId,
858         bytes memory _data
859     ) internal virtual {
860         _mint(to, tokenId);
861         require(
862             _checkOnERC721Received(address(0), to, tokenId, _data),
863             "ERC721: transfer to non ERC721Receiver implementer"
864         );
865     }
866 
867     /**
868      * @dev Mints `tokenId` and transfers it to `to`.
869      *
870      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
871      *
872      * Requirements:
873      *
874      * - `tokenId` must not exist.
875      * - `to` cannot be the zero address.
876      *
877      * Emits a {Transfer} event.
878      */
879     function _mint(address to, uint256 tokenId) internal virtual {
880         require(to != address(0), "ERC721: mint to the zero address");
881         require(!_exists(tokenId), "ERC721: token already minted");
882 
883         _beforeTokenTransfer(address(0), to, tokenId);
884 
885         _balances[to] += 1;
886         _owners[tokenId] = to;
887 
888         emit Transfer(address(0), to, tokenId);
889     }
890 
891     /**
892      * @dev Destroys `tokenId`.
893      * The approval is cleared when the token is burned.
894      *
895      * Requirements:
896      *
897      * - `tokenId` must exist.
898      *
899      * Emits a {Transfer} event.
900      */
901     function _burn(uint256 tokenId) internal virtual {
902         address owner = ERC721.ownerOf(tokenId);
903 
904         _beforeTokenTransfer(owner, address(0), tokenId);
905 
906         // Clear approvals
907         _approve(address(0), tokenId);
908 
909         _balances[owner] -= 1;
910         delete _owners[tokenId];
911 
912         emit Transfer(owner, address(0), tokenId);
913     }
914 
915     /**
916      * @dev Transfers `tokenId` from `from` to `to`.
917      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
918      *
919      * Requirements:
920      *
921      * - `to` cannot be the zero address.
922      * - `tokenId` token must be owned by `from`.
923      *
924      * Emits a {Transfer} event.
925      */
926     function _transfer(
927         address from,
928         address to,
929         uint256 tokenId
930     ) internal virtual {
931         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
932         require(to != address(0), "ERC721: transfer to the zero address");
933 
934         _beforeTokenTransfer(from, to, tokenId);
935 
936         // Clear approvals from the previous owner
937         _approve(address(0), tokenId);
938 
939         _balances[from] -= 1;
940         _balances[to] += 1;
941         _owners[tokenId] = to;
942 
943         emit Transfer(from, to, tokenId);
944     }
945 
946     /**
947      * @dev Approve `to` to operate on `tokenId`
948      *
949      * Emits a {Approval} event.
950      */
951     function _approve(address to, uint256 tokenId) internal virtual {
952         _tokenApprovals[tokenId] = to;
953         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
954     }
955 
956     /**
957      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
958      * The call is not executed if the target address is not a contract.
959      *
960      * @param from address representing the previous owner of the given token ID
961      * @param to target address that will receive the tokens
962      * @param tokenId uint256 ID of the token to be transferred
963      * @param _data bytes optional data to send along with the call
964      * @return bool whether the call correctly returned the expected magic value
965      */
966     function _checkOnERC721Received(
967         address from,
968         address to,
969         uint256 tokenId,
970         bytes memory _data
971     ) private returns (bool) {
972         if (to.isContract()) {
973             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
974                 return retval == IERC721Receiver.onERC721Received.selector;
975             } catch (bytes memory reason) {
976                 if (reason.length == 0) {
977                     revert("ERC721: transfer to non ERC721Receiver implementer");
978                 } else {
979                     assembly {
980                         revert(add(32, reason), mload(reason))
981                     }
982                 }
983             }
984         } else {
985             return true;
986         }
987     }
988 
989     /**
990      * @dev Hook that is called before any token transfer. This includes minting
991      * and burning.
992      *
993      * Calling conditions:
994      *
995      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
996      * transferred to `to`.
997      * - When `from` is zero, `tokenId` will be minted for `to`.
998      * - When `to` is zero, ``from``'s `tokenId` will be burned.
999      * - `from` and `to` are never both zero.
1000      *
1001      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1002      */
1003     function _beforeTokenTransfer(
1004         address from,
1005         address to,
1006         uint256 tokenId
1007     ) internal virtual {}
1008 }
1009 
1010 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1011 
1012 
1013 
1014 pragma solidity ^0.8.0;
1015 
1016 
1017 
1018 /**
1019  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1020  * enumerability of all the token ids in the contract as well as all token ids owned by each
1021  * account.
1022  */
1023 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1024     // Mapping from owner to list of owned token IDs
1025     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1026 
1027     // Mapping from token ID to index of the owner tokens list
1028     mapping(uint256 => uint256) private _ownedTokensIndex;
1029 
1030     // Array with all token ids, used for enumeration
1031     uint256[] private _allTokens;
1032 
1033     // Mapping from token id to position in the allTokens array
1034     mapping(uint256 => uint256) private _allTokensIndex;
1035 
1036     /**
1037      * @dev See {IERC165-supportsInterface}.
1038      */
1039     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1040         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1041     }
1042 
1043     /**
1044      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1045      */
1046     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1047         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1048         return _ownedTokens[owner][index];
1049     }
1050 
1051     /**
1052      * @dev See {IERC721Enumerable-totalSupply}.
1053      */
1054     function totalSupply() public view virtual override returns (uint256) {
1055         return _allTokens.length;
1056     }
1057 
1058     /**
1059      * @dev See {IERC721Enumerable-tokenByIndex}.
1060      */
1061     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1062         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1063         return _allTokens[index];
1064     }
1065 
1066     /**
1067      * @dev Hook that is called before any token transfer. This includes minting
1068      * and burning.
1069      *
1070      * Calling conditions:
1071      *
1072      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1073      * transferred to `to`.
1074      * - When `from` is zero, `tokenId` will be minted for `to`.
1075      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1076      * - `from` cannot be the zero address.
1077      * - `to` cannot be the zero address.
1078      *
1079      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1080      */
1081     function _beforeTokenTransfer(
1082         address from,
1083         address to,
1084         uint256 tokenId
1085     ) internal virtual override {
1086         super._beforeTokenTransfer(from, to, tokenId);
1087 
1088         if (from == address(0)) {
1089             _addTokenToAllTokensEnumeration(tokenId);
1090         } else if (from != to) {
1091             _removeTokenFromOwnerEnumeration(from, tokenId);
1092         }
1093         if (to == address(0)) {
1094             _removeTokenFromAllTokensEnumeration(tokenId);
1095         } else if (to != from) {
1096             _addTokenToOwnerEnumeration(to, tokenId);
1097         }
1098     }
1099 
1100     /**
1101      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1102      * @param to address representing the new owner of the given token ID
1103      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1104      */
1105     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1106         uint256 length = ERC721.balanceOf(to);
1107         _ownedTokens[to][length] = tokenId;
1108         _ownedTokensIndex[tokenId] = length;
1109     }
1110 
1111     /**
1112      * @dev Private function to add a token to this extension's token tracking data structures.
1113      * @param tokenId uint256 ID of the token to be added to the tokens list
1114      */
1115     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1116         _allTokensIndex[tokenId] = _allTokens.length;
1117         _allTokens.push(tokenId);
1118     }
1119 
1120     /**
1121      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1122      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1123      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1124      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1125      * @param from address representing the previous owner of the given token ID
1126      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1127      */
1128     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1129         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1130         // then delete the last slot (swap and pop).
1131 
1132         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1133         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1134 
1135         // When the token to delete is the last token, the swap operation is unnecessary
1136         if (tokenIndex != lastTokenIndex) {
1137             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1138 
1139             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1140             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1141         }
1142 
1143         // This also deletes the contents at the last position of the array
1144         delete _ownedTokensIndex[tokenId];
1145         delete _ownedTokens[from][lastTokenIndex];
1146     }
1147 
1148     /**
1149      * @dev Private function to remove a token from this extension's token tracking data structures.
1150      * This has O(1) time complexity, but alters the order of the _allTokens array.
1151      * @param tokenId uint256 ID of the token to be removed from the tokens list
1152      */
1153     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1154         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1155         // then delete the last slot (swap and pop).
1156 
1157         uint256 lastTokenIndex = _allTokens.length - 1;
1158         uint256 tokenIndex = _allTokensIndex[tokenId];
1159 
1160         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1161         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1162         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1163         uint256 lastTokenId = _allTokens[lastTokenIndex];
1164 
1165         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1166         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1167 
1168         // This also deletes the contents at the last position of the array
1169         delete _allTokensIndex[tokenId];
1170         _allTokens.pop();
1171     }
1172 }
1173 
1174 
1175 // File: @openzeppelin/contracts/access/Ownable.sol
1176 pragma solidity ^0.8.0;
1177 /**
1178  * @dev Contract module which provides a basic access control mechanism, where
1179  * there is an account (an owner) that can be granted exclusive access to
1180  * specific functions.
1181  *
1182  * By default, the owner account will be the one that deploys the contract. This
1183  * can later be changed with {transferOwnership}.
1184  *
1185  * This module is used through inheritance. It will make available the modifier
1186  * `onlyOwner`, which can be applied to your functions to restrict their use to
1187  * the owner.
1188  */
1189 abstract contract Ownable is Context {
1190     address private _owner;
1191 
1192     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1193 
1194     /**
1195      * @dev Initializes the contract setting the deployer as the initial owner.
1196      */
1197     constructor() {
1198         _setOwner(_msgSender());
1199     }
1200 
1201     /**
1202      * @dev Returns the address of the current owner.
1203      */
1204     function owner() public view virtual returns (address) {
1205         return _owner;
1206     }
1207 
1208     /**
1209      * @dev Throws if called by any account other than the owner.
1210      */
1211     modifier onlyOwner() {
1212         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1213         _;
1214     }
1215 
1216     /**
1217      * @dev Leaves the contract without owner. It will not be possible to call
1218      * `onlyOwner` functions anymore. Can only be called by the current owner.
1219      *
1220      * NOTE: Renouncing ownership will leave the contract without an owner,
1221      * thereby removing any functionality that is only available to the owner.
1222      */
1223     function renounceOwnership() public virtual onlyOwner {
1224         _setOwner(address(0));
1225     }
1226 
1227     /**
1228      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1229      * Can only be called by the current owner.
1230      */
1231     function transferOwnership(address newOwner) public virtual onlyOwner {
1232         require(newOwner != address(0), "Ownable: new owner is the zero address");
1233         _setOwner(newOwner);
1234     }
1235 
1236     function _setOwner(address newOwner) private {
1237         address oldOwner = _owner;
1238         _owner = newOwner;
1239         emit OwnershipTransferred(oldOwner, newOwner);
1240     }
1241 }
1242 pragma solidity >=0.7.0 <0.9.0;
1243 
1244 contract QuackyDucksContract is ERC721Enumerable, Ownable {
1245   using Strings for uint256;
1246 
1247   string public baseURI;
1248   string public baseExtension = ".json";
1249   string public notRevealedUri;
1250   uint256 public cost = 0.06 ether;
1251   uint256 public maxSupply = 8888;
1252   uint256 public maxMintAmount = 5;
1253   uint256 public nftPerAddressLimit = 5;
1254   bool public paused = true;
1255   bool public revealed = false;
1256   mapping(address => uint256) public addressMintedBalance;
1257 
1258 
1259   constructor(
1260     string memory _name,
1261     string memory _symbol,
1262     string memory _initBaseURI,
1263     string memory _initNotRevealedUri
1264   ) ERC721(_name, _symbol) {
1265     setBaseURI(_initBaseURI);
1266     setNotRevealedURI(_initNotRevealedUri);
1267   }
1268 
1269   
1270    
1271   function _baseURI() internal view virtual override returns (string memory) {
1272     return baseURI;
1273   }
1274 
1275 
1276   // public
1277 function mint(uint256 _mintAmount ) public payable {
1278 
1279     require(!paused, "the contract is paused");
1280     uint256 supply = totalSupply();
1281     require(_mintAmount > 0, "need to mint at least 1 NFT"); 
1282 
1283     require(supply + _mintAmount <= maxSupply, "max NFT limit exceeded");
1284      if (msg.sender != owner()) {
1285         require(_mintAmount <= maxMintAmount, "max mint amount per session exceeded");
1286     
1287         uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1288         require(ownerMintedCount + _mintAmount <= nftPerAddressLimit, "max NFT per address exceeded");
1289         require(msg.value >= cost * _mintAmount, "insufficient funds");
1290     }
1291     for (uint256 i = 1; i <= _mintAmount; i++) {
1292       addressMintedBalance[msg.sender]++;
1293       _safeMint(msg.sender, supply + i);
1294     }
1295   }
1296   
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
1323     if(revealed == false) {
1324         return notRevealedUri;
1325     }
1326 
1327     string memory currentBaseURI = _baseURI();
1328     return bytes(currentBaseURI).length > 0
1329         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1330         : "";
1331   }
1332 
1333   //only owner
1334   function reveal() public onlyOwner {
1335       revealed = true;
1336   }
1337   
1338   function setNftPerAddressLimit(uint256 _limit) public onlyOwner {
1339     nftPerAddressLimit = _limit;
1340   }
1341   
1342   function setCost(uint256 _newCost) public onlyOwner {
1343     cost = _newCost;
1344   }
1345 
1346   function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
1347     maxMintAmount = _newmaxMintAmount;
1348   }
1349 
1350   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1351     baseURI = _newBaseURI;
1352   }
1353 
1354   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1355     baseExtension = _newBaseExtension;
1356   }
1357   
1358   function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1359     notRevealedUri = _notRevealedURI;
1360   }
1361 
1362   function pause(bool _state) public onlyOwner {
1363     paused = _state;
1364   }
1365   
1366  
1367   function withdraw() public payable onlyOwner {
1368     
1369     // This will payout the owner the contract balance.
1370     // Do not remove this otherwise you will not be able to withdraw the funds.
1371     // =============================================================================
1372     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1373     require(os);
1374     // =============================================================================
1375   }
1376 }