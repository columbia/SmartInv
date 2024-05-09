1 // SPDX-License-Identifier: MIT
2 // File: contracts/bouncywizardswtf.sol
3 
4 
5 
6 //
7 // █████████████████████████████████████████████████████████████████████████████████████████████████████████████
8 // █▄─▄─▀█─▄▄─█▄─██─▄█▄─▀█▄─▄█─▄▄▄─█▄─█─▄█▄─█▀▀▀█─▄█▄─▄█░▄▄░▄██▀▄─██▄─▄▄▀█▄─▄▄▀█─▄▄▄▄█████▄─█▀▀▀█─▄█─▄─▄─█▄─▄▄─█
9 // ██─▄─▀█─██─██─██─███─█▄▀─██─███▀██▄─▄███─█─█─█─███─███▀▄█▀██─▀─███─▄─▄██─██─█▄▄▄▄─█░░███─█─█─█─████─████─▄███
10 // ▀▄▄▄▄▀▀▄▄▄▄▀▀▄▄▄▄▀▀▄▄▄▀▀▄▄▀▄▄▄▄▄▀▀▄▄▄▀▀▀▄▄▄▀▄▄▄▀▀▄▄▄▀▄▄▄▄▄▀▄▄▀▄▄▀▄▄▀▄▄▀▄▄▄▄▀▀▄▄▄▄▄▀▄▄▀▀▀▄▄▄▀▄▄▄▀▀▀▄▄▄▀▀▄▄▄▀▀▀
11 
12 /**
13     !Disclaimer!
14     These contracts have been used to create tutorials,
15     and was created for the purpose to teach people
16     how to create smart contracts on the blockchain.
17     please review this code on your own before using any of
18     the following code for production.
19     HashLips will not be liable in any way if for the use 
20     of the code. That being said, the code has been tested 
21     to the best of the developers' knowledge to work as intended.
22 */
23 
24 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
25 pragma solidity ^0.8.0;
26 /**
27  * @dev Interface of the ERC165 standard, as defined in the
28  * https://eips.ethereum.org/EIPS/eip-165[EIP].
29  *
30  * Implementers can declare support of contract interfaces, which can then be
31  * queried by others ({ERC165Checker}).
32  *
33  * For an implementation, see {ERC165}.
34  */
35 interface IERC165 {
36     /**
37      * @dev Returns true if this contract implements the interface defined by
38      * `interfaceId`. See the corresponding
39      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
40      * to learn more about how these ids are created.
41      *
42      * This function call must use less than 30 000 gas.
43      */
44     function supportsInterface(bytes4 interfaceId) external view returns (bool);
45 }
46 
47 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
48 pragma solidity ^0.8.0;
49 /**
50  * @dev Required interface of an ERC721 compliant contract.
51  */
52 interface IERC721 is IERC165 {
53     /**
54      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
55      */
56     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
57 
58     /**
59      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
60      */
61     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
62 
63     /**
64      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
65      */
66     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
67 
68     /**
69      * @dev Returns the number of tokens in ``owner``'s account.
70      */
71     function balanceOf(address owner) external view returns (uint256 balance);
72 
73     /**
74      * @dev Returns the owner of the `tokenId` token.
75      *
76      * Requirements:
77      *
78      * - `tokenId` must exist.
79      */
80     function ownerOf(uint256 tokenId) external view returns (address owner);
81 
82     /**
83      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
84      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
85      *
86      * Requirements:
87      *
88      * - `from` cannot be the zero address.
89      * - `to` cannot be the zero address.
90      * - `tokenId` token must exist and be owned by `from`.
91      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
92      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
93      *
94      * Emits a {Transfer} event.
95      */
96     function safeTransferFrom(
97         address from,
98         address to,
99         uint256 tokenId
100     ) external;
101 
102     /**
103      * @dev Transfers `tokenId` token from `from` to `to`.
104      *
105      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
106      *
107      * Requirements:
108      *
109      * - `from` cannot be the zero address.
110      * - `to` cannot be the zero address.
111      * - `tokenId` token must be owned by `from`.
112      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
113      *
114      * Emits a {Transfer} event.
115      */
116     function transferFrom(
117         address from,
118         address to,
119         uint256 tokenId
120     ) external;
121 
122     /**
123      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
124      * The approval is cleared when the token is transferred.
125      *
126      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
127      *
128      * Requirements:
129      *
130      * - The caller must own the token or be an approved operator.
131      * - `tokenId` must exist.
132      *
133      * Emits an {Approval} event.
134      */
135     function approve(address to, uint256 tokenId) external;
136 
137     /**
138      * @dev Returns the account approved for `tokenId` token.
139      *
140      * Requirements:
141      *
142      * - `tokenId` must exist.
143      */
144     function getApproved(uint256 tokenId) external view returns (address operator);
145 
146     /**
147      * @dev Approve or remove `operator` as an operator for the caller.
148      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
149      *
150      * Requirements:
151      *
152      * - The `operator` cannot be the caller.
153      *
154      * Emits an {ApprovalForAll} event.
155      */
156     function setApprovalForAll(address operator, bool _approved) external;
157 
158     /**
159      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
160      *
161      * See {setApprovalForAll}
162      */
163     function isApprovedForAll(address owner, address operator) external view returns (bool);
164 
165     /**
166      * @dev Safely transfers `tokenId` token from `from` to `to`.
167      *
168      * Requirements:
169      *
170      * - `from` cannot be the zero address.
171      * - `to` cannot be the zero address.
172      * - `tokenId` token must exist and be owned by `from`.
173      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
174      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
175      *
176      * Emits a {Transfer} event.
177      */
178     function safeTransferFrom(
179         address from,
180         address to,
181         uint256 tokenId,
182         bytes calldata data
183     ) external;
184 }
185 
186 
187 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
188 pragma solidity ^0.8.0;
189 /**
190  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
191  * @dev See https://eips.ethereum.org/EIPS/eip-721
192  */
193 interface IERC721Enumerable is IERC721 {
194     /**
195      * @dev Returns the total amount of tokens stored by the contract.
196      */
197     function totalSupply() external view returns (uint256);
198 
199     /**
200      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
201      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
202      */
203     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
204 
205     /**
206      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
207      * Use along with {totalSupply} to enumerate all tokens.
208      */
209     function tokenByIndex(uint256 index) external view returns (uint256);
210 }
211 
212 
213 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
214 pragma solidity ^0.8.0;
215 /**
216  * @dev Implementation of the {IERC165} interface.
217  *
218  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
219  * for the additional interface id that will be supported. For example:
220  *
221  * ```solidity
222  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
223  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
224  * }
225  * ```
226  *
227  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
228  */
229 abstract contract ERC165 is IERC165 {
230     /**
231      * @dev See {IERC165-supportsInterface}.
232      */
233     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
234         return interfaceId == type(IERC165).interfaceId;
235     }
236 }
237 
238 // File: @openzeppelin/contracts/utils/Strings.sol
239 
240 
241 
242 pragma solidity ^0.8.0;
243 
244 /**
245  * @dev String operations.
246  */
247 library Strings {
248     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
249 
250     /**
251      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
252      */
253     function toString(uint256 value) internal pure returns (string memory) {
254         // Inspired by OraclizeAPI's implementation - MIT licence
255         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
256 
257         if (value == 0) {
258             return "0";
259         }
260         uint256 temp = value;
261         uint256 digits;
262         while (temp != 0) {
263             digits++;
264             temp /= 10;
265         }
266         bytes memory buffer = new bytes(digits);
267         while (value != 0) {
268             digits -= 1;
269             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
270             value /= 10;
271         }
272         return string(buffer);
273     }
274 
275     /**
276      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
277      */
278     function toHexString(uint256 value) internal pure returns (string memory) {
279         if (value == 0) {
280             return "0x00";
281         }
282         uint256 temp = value;
283         uint256 length = 0;
284         while (temp != 0) {
285             length++;
286             temp >>= 8;
287         }
288         return toHexString(value, length);
289     }
290 
291     /**
292      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
293      */
294     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
295         bytes memory buffer = new bytes(2 * length + 2);
296         buffer[0] = "0";
297         buffer[1] = "x";
298         for (uint256 i = 2 * length + 1; i > 1; --i) {
299             buffer[i] = _HEX_SYMBOLS[value & 0xf];
300             value >>= 4;
301         }
302         require(value == 0, "Strings: hex length insufficient");
303         return string(buffer);
304     }
305 }
306 
307 // File: @openzeppelin/contracts/utils/Address.sol
308 
309 
310 
311 pragma solidity ^0.8.0;
312 
313 /**
314  * @dev Collection of functions related to the address type
315  */
316 library Address {
317     /**
318      * @dev Returns true if `account` is a contract.
319      *
320      * [IMPORTANT]
321      * ====
322      * It is unsafe to assume that an address for which this function returns
323      * false is an externally-owned account (EOA) and not a contract.
324      *
325      * Among others, `isContract` will return false for the following
326      * types of addresses:
327      *
328      *  - an externally-owned account
329      *  - a contract in construction
330      *  - an address where a contract will be created
331      *  - an address where a contract lived, but was destroyed
332      * ====
333      */
334     function isContract(address account) internal view returns (bool) {
335         // This method relies on extcodesize, which returns 0 for contracts in
336         // construction, since the code is only stored at the end of the
337         // constructor execution.
338 
339         uint256 size;
340         assembly {
341             size := extcodesize(account)
342         }
343         return size > 0;
344     }
345 
346     /**
347      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
348      * `recipient`, forwarding all available gas and reverting on errors.
349      *
350      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
351      * of certain opcodes, possibly making contracts go over the 2300 gas limit
352      * imposed by `transfer`, making them unable to receive funds via
353      * `transfer`. {sendValue} removes this limitation.
354      *
355      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
356      *
357      * IMPORTANT: because control is transferred to `recipient`, care must be
358      * taken to not create reentrancy vulnerabilities. Consider using
359      * {ReentrancyGuard} or the
360      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
361      */
362     function sendValue(address payable recipient, uint256 amount) internal {
363         require(address(this).balance >= amount, "Address: insufficient balance");
364 
365         (bool success, ) = recipient.call{value: amount}("");
366         require(success, "Address: unable to send value, recipient may have reverted");
367     }
368 
369     /**
370      * @dev Performs a Solidity function call using a low level `call`. A
371      * plain `call` is an unsafe replacement for a function call: use this
372      * function instead.
373      *
374      * If `target` reverts with a revert reason, it is bubbled up by this
375      * function (like regular Solidity function calls).
376      *
377      * Returns the raw returned data. To convert to the expected return value,
378      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
379      *
380      * Requirements:
381      *
382      * - `target` must be a contract.
383      * - calling `target` with `data` must not revert.
384      *
385      * _Available since v3.1._
386      */
387     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
388         return functionCall(target, data, "Address: low-level call failed");
389     }
390 
391     /**
392      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
393      * `errorMessage` as a fallback revert reason when `target` reverts.
394      *
395      * _Available since v3.1._
396      */
397     function functionCall(
398         address target,
399         bytes memory data,
400         string memory errorMessage
401     ) internal returns (bytes memory) {
402         return functionCallWithValue(target, data, 0, errorMessage);
403     }
404 
405     /**
406      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
407      * but also transferring `value` wei to `target`.
408      *
409      * Requirements:
410      *
411      * - the calling contract must have an ETH balance of at least `value`.
412      * - the called Solidity function must be `payable`.
413      *
414      * _Available since v3.1._
415      */
416     function functionCallWithValue(
417         address target,
418         bytes memory data,
419         uint256 value
420     ) internal returns (bytes memory) {
421         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
422     }
423 
424     /**
425      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
426      * with `errorMessage` as a fallback revert reason when `target` reverts.
427      *
428      * _Available since v3.1._
429      */
430     function functionCallWithValue(
431         address target,
432         bytes memory data,
433         uint256 value,
434         string memory errorMessage
435     ) internal returns (bytes memory) {
436         require(address(this).balance >= value, "Address: insufficient balance for call");
437         require(isContract(target), "Address: call to non-contract");
438 
439         (bool success, bytes memory returndata) = target.call{value: value}(data);
440         return verifyCallResult(success, returndata, errorMessage);
441     }
442 
443     /**
444      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
445      * but performing a static call.
446      *
447      * _Available since v3.3._
448      */
449     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
450         return functionStaticCall(target, data, "Address: low-level static call failed");
451     }
452 
453     /**
454      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
455      * but performing a static call.
456      *
457      * _Available since v3.3._
458      */
459     function functionStaticCall(
460         address target,
461         bytes memory data,
462         string memory errorMessage
463     ) internal view returns (bytes memory) {
464         require(isContract(target), "Address: static call to non-contract");
465 
466         (bool success, bytes memory returndata) = target.staticcall(data);
467         return verifyCallResult(success, returndata, errorMessage);
468     }
469 
470     /**
471      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
472      * but performing a delegate call.
473      *
474      * _Available since v3.4._
475      */
476     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
477         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
478     }
479 
480     /**
481      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
482      * but performing a delegate call.
483      *
484      * _Available since v3.4._
485      */
486     function functionDelegateCall(
487         address target,
488         bytes memory data,
489         string memory errorMessage
490     ) internal returns (bytes memory) {
491         require(isContract(target), "Address: delegate call to non-contract");
492 
493         (bool success, bytes memory returndata) = target.delegatecall(data);
494         return verifyCallResult(success, returndata, errorMessage);
495     }
496 
497     /**
498      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
499      * revert reason using the provided one.
500      *
501      * _Available since v4.3._
502      */
503     function verifyCallResult(
504         bool success,
505         bytes memory returndata,
506         string memory errorMessage
507     ) internal pure returns (bytes memory) {
508         if (success) {
509             return returndata;
510         } else {
511             // Look for revert reason and bubble it up if present
512             if (returndata.length > 0) {
513                 // The easiest way to bubble the revert reason is using memory via assembly
514 
515                 assembly {
516                     let returndata_size := mload(returndata)
517                     revert(add(32, returndata), returndata_size)
518                 }
519             } else {
520                 revert(errorMessage);
521             }
522         }
523     }
524 }
525 
526 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
527 
528 
529 
530 pragma solidity ^0.8.0;
531 
532 
533 /**
534  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
535  * @dev See https://eips.ethereum.org/EIPS/eip-721
536  */
537 interface IERC721Metadata is IERC721 {
538     /**
539      * @dev Returns the token collection name.
540      */
541     function name() external view returns (string memory);
542 
543     /**
544      * @dev Returns the token collection symbol.
545      */
546     function symbol() external view returns (string memory);
547 
548     /**
549      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
550      */
551     function tokenURI(uint256 tokenId) external view returns (string memory);
552 }
553 
554 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
555 
556 
557 
558 pragma solidity ^0.8.0;
559 
560 /**
561  * @title ERC721 token receiver interface
562  * @dev Interface for any contract that wants to support safeTransfers
563  * from ERC721 asset contracts.
564  */
565 interface IERC721Receiver {
566     /**
567      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
568      * by `operator` from `from`, this function is called.
569      *
570      * It must return its Solidity selector to confirm the token transfer.
571      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
572      *
573      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
574      */
575     function onERC721Received(
576         address operator,
577         address from,
578         uint256 tokenId,
579         bytes calldata data
580     ) external returns (bytes4);
581 }
582 
583 // File: @openzeppelin/contracts/utils/Context.sol
584 pragma solidity ^0.8.0;
585 /**
586  * @dev Provides information about the current execution context, including the
587  * sender of the transaction and its data. While these are generally available
588  * via msg.sender and msg.data, they should not be accessed in such a direct
589  * manner, since when dealing with meta-transactions the account sending and
590  * paying for execution may not be the actual sender (as far as an application
591  * is concerned).
592  *
593  * This contract is only required for intermediate, library-like contracts.
594  */
595 abstract contract Context {
596     function _msgSender() internal view virtual returns (address) {
597         return msg.sender;
598     }
599 
600     function _msgData() internal view virtual returns (bytes calldata) {
601         return msg.data;
602     }
603 }
604 
605 
606 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
607 pragma solidity ^0.8.0;
608 /**
609  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
610  * the Metadata extension, but not including the Enumerable extension, which is available separately as
611  * {ERC721Enumerable}.
612  */
613 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
614     using Address for address;
615     using Strings for uint256;
616 
617     // Token name
618     string private _name;
619 
620     // Token symbol
621     string private _symbol;
622 
623     // Mapping from token ID to owner address
624     mapping(uint256 => address) private _owners;
625 
626     // Mapping owner address to token count
627     mapping(address => uint256) private _balances;
628 
629     // Mapping from token ID to approved address
630     mapping(uint256 => address) private _tokenApprovals;
631 
632     // Mapping from owner to operator approvals
633     mapping(address => mapping(address => bool)) private _operatorApprovals;
634 
635     /**
636      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
637      */
638     constructor(string memory name_, string memory symbol_) {
639         _name = name_;
640         _symbol = symbol_;
641     }
642 
643     /**
644      * @dev See {IERC165-supportsInterface}.
645      */
646     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
647         return
648             interfaceId == type(IERC721).interfaceId ||
649             interfaceId == type(IERC721Metadata).interfaceId ||
650             super.supportsInterface(interfaceId);
651     }
652 
653     /**
654      * @dev See {IERC721-balanceOf}.
655      */
656     function balanceOf(address owner) public view virtual override returns (uint256) {
657         require(owner != address(0), "ERC721: balance query for the zero address");
658         return _balances[owner];
659     }
660 
661     /**
662      * @dev See {IERC721-ownerOf}.
663      */
664     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
665         address owner = _owners[tokenId];
666         require(owner != address(0), "ERC721: owner query for nonexistent token");
667         return owner;
668     }
669 
670     /**
671      * @dev See {IERC721Metadata-name}.
672      */
673     function name() public view virtual override returns (string memory) {
674         return _name;
675     }
676 
677     /**
678      * @dev See {IERC721Metadata-symbol}.
679      */
680     function symbol() public view virtual override returns (string memory) {
681         return _symbol;
682     }
683 
684     /**
685      * @dev See {IERC721Metadata-tokenURI}.
686      */
687     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
688         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
689 
690         string memory baseURI = _baseURI();
691         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
692     }
693 
694     /**
695      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
696      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
697      * by default, can be overriden in child contracts.
698      */
699     function _baseURI() internal view virtual returns (string memory) {
700         return "";
701     }
702 
703     /**
704      * @dev See {IERC721-approve}.
705      */
706     function approve(address to, uint256 tokenId) public virtual override {
707         address owner = ERC721.ownerOf(tokenId);
708         require(to != owner, "ERC721: approval to current owner");
709 
710         require(
711             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
712             "ERC721: approve caller is not owner nor approved for all"
713         );
714 
715         _approve(to, tokenId);
716     }
717 
718     /**
719      * @dev See {IERC721-getApproved}.
720      */
721     function getApproved(uint256 tokenId) public view virtual override returns (address) {
722         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
723 
724         return _tokenApprovals[tokenId];
725     }
726 
727     /**
728      * @dev See {IERC721-setApprovalForAll}.
729      */
730     function setApprovalForAll(address operator, bool approved) public virtual override {
731         require(operator != _msgSender(), "ERC721: approve to caller");
732 
733         _operatorApprovals[_msgSender()][operator] = approved;
734         emit ApprovalForAll(_msgSender(), operator, approved);
735     }
736 
737     /**
738      * @dev See {IERC721-isApprovedForAll}.
739      */
740     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
741         return _operatorApprovals[owner][operator];
742     }
743 
744     /**
745      * @dev See {IERC721-transferFrom}.
746      */
747     function transferFrom(
748         address from,
749         address to,
750         uint256 tokenId
751     ) public virtual override {
752         //solhint-disable-next-line max-line-length
753         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
754 
755         _transfer(from, to, tokenId);
756     }
757 
758     /**
759      * @dev See {IERC721-safeTransferFrom}.
760      */
761     function safeTransferFrom(
762         address from,
763         address to,
764         uint256 tokenId
765     ) public virtual override {
766         safeTransferFrom(from, to, tokenId, "");
767     }
768 
769     /**
770      * @dev See {IERC721-safeTransferFrom}.
771      */
772     function safeTransferFrom(
773         address from,
774         address to,
775         uint256 tokenId,
776         bytes memory _data
777     ) public virtual override {
778         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
779         _safeTransfer(from, to, tokenId, _data);
780     }
781 
782     /**
783      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
784      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
785      *
786      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
787      *
788      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
789      * implement alternative mechanisms to perform token transfer, such as signature-based.
790      *
791      * Requirements:
792      *
793      * - `from` cannot be the zero address.
794      * - `to` cannot be the zero address.
795      * - `tokenId` token must exist and be owned by `from`.
796      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
797      *
798      * Emits a {Transfer} event.
799      */
800     function _safeTransfer(
801         address from,
802         address to,
803         uint256 tokenId,
804         bytes memory _data
805     ) internal virtual {
806         _transfer(from, to, tokenId);
807         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
808     }
809 
810     /**
811      * @dev Returns whether `tokenId` exists.
812      *
813      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
814      *
815      * Tokens start existing when they are minted (`_mint`),
816      * and stop existing when they are burned (`_burn`).
817      */
818     function _exists(uint256 tokenId) internal view virtual returns (bool) {
819         return _owners[tokenId] != address(0);
820     }
821 
822     /**
823      * @dev Returns whether `spender` is allowed to manage `tokenId`.
824      *
825      * Requirements:
826      *
827      * - `tokenId` must exist.
828      */
829     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
830         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
831         address owner = ERC721.ownerOf(tokenId);
832         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
833     }
834 
835     /**
836      * @dev Safely mints `tokenId` and transfers it to `to`.
837      *
838      * Requirements:
839      *
840      * - `tokenId` must not exist.
841      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
842      *
843      * Emits a {Transfer} event.
844      */
845     function _safeMint(address to, uint256 tokenId) internal virtual {
846         _safeMint(to, tokenId, "");
847     }
848 
849     /**
850      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
851      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
852      */
853     function _safeMint(
854         address to,
855         uint256 tokenId,
856         bytes memory _data
857     ) internal virtual {
858         _mint(to, tokenId);
859         require(
860             _checkOnERC721Received(address(0), to, tokenId, _data),
861             "ERC721: transfer to non ERC721Receiver implementer"
862         );
863     }
864 
865     /**
866      * @dev Mints `tokenId` and transfers it to `to`.
867      *
868      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
869      *
870      * Requirements:
871      *
872      * - `tokenId` must not exist.
873      * - `to` cannot be the zero address.
874      *
875      * Emits a {Transfer} event.
876      */
877     function _mint(address to, uint256 tokenId) internal virtual {
878         require(to != address(0), "ERC721: mint to the zero address");
879         require(!_exists(tokenId), "ERC721: token already minted");
880 
881         _beforeTokenTransfer(address(0), to, tokenId);
882 
883         _balances[to] += 1;
884         _owners[tokenId] = to;
885 
886         emit Transfer(address(0), to, tokenId);
887     }
888 
889     /**
890      * @dev Destroys `tokenId`.
891      * The approval is cleared when the token is burned.
892      *
893      * Requirements:
894      *
895      * - `tokenId` must exist.
896      *
897      * Emits a {Transfer} event.
898      */
899     function _burn(uint256 tokenId) internal virtual {
900         address owner = ERC721.ownerOf(tokenId);
901 
902         _beforeTokenTransfer(owner, address(0), tokenId);
903 
904         // Clear approvals
905         _approve(address(0), tokenId);
906 
907         _balances[owner] -= 1;
908         delete _owners[tokenId];
909 
910         emit Transfer(owner, address(0), tokenId);
911     }
912 
913     /**
914      * @dev Transfers `tokenId` from `from` to `to`.
915      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
916      *
917      * Requirements:
918      *
919      * - `to` cannot be the zero address.
920      * - `tokenId` token must be owned by `from`.
921      *
922      * Emits a {Transfer} event.
923      */
924     function _transfer(
925         address from,
926         address to,
927         uint256 tokenId
928     ) internal virtual {
929         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
930         require(to != address(0), "ERC721: transfer to the zero address");
931 
932         _beforeTokenTransfer(from, to, tokenId);
933 
934         // Clear approvals from the previous owner
935         _approve(address(0), tokenId);
936 
937         _balances[from] -= 1;
938         _balances[to] += 1;
939         _owners[tokenId] = to;
940 
941         emit Transfer(from, to, tokenId);
942     }
943 
944     /**
945      * @dev Approve `to` to operate on `tokenId`
946      *
947      * Emits a {Approval} event.
948      */
949     function _approve(address to, uint256 tokenId) internal virtual {
950         _tokenApprovals[tokenId] = to;
951         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
952     }
953 
954     /**
955      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
956      * The call is not executed if the target address is not a contract.
957      *
958      * @param from address representing the previous owner of the given token ID
959      * @param to target address that will receive the tokens
960      * @param tokenId uint256 ID of the token to be transferred
961      * @param _data bytes optional data to send along with the call
962      * @return bool whether the call correctly returned the expected magic value
963      */
964     function _checkOnERC721Received(
965         address from,
966         address to,
967         uint256 tokenId,
968         bytes memory _data
969     ) private returns (bool) {
970         if (to.isContract()) {
971             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
972                 return retval == IERC721Receiver.onERC721Received.selector;
973             } catch (bytes memory reason) {
974                 if (reason.length == 0) {
975                     revert("ERC721: transfer to non ERC721Receiver implementer");
976                 } else {
977                     assembly {
978                         revert(add(32, reason), mload(reason))
979                     }
980                 }
981             }
982         } else {
983             return true;
984         }
985     }
986 
987     /**
988      * @dev Hook that is called before any token transfer. This includes minting
989      * and burning.
990      *
991      * Calling conditions:
992      *
993      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
994      * transferred to `to`.
995      * - When `from` is zero, `tokenId` will be minted for `to`.
996      * - When `to` is zero, ``from``'s `tokenId` will be burned.
997      * - `from` and `to` are never both zero.
998      *
999      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1000      */
1001     function _beforeTokenTransfer(
1002         address from,
1003         address to,
1004         uint256 tokenId
1005     ) internal virtual {}
1006 }
1007 
1008 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1009 
1010 
1011 
1012 pragma solidity ^0.8.0;
1013 
1014 
1015 
1016 /**
1017  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1018  * enumerability of all the token ids in the contract as well as all token ids owned by each
1019  * account.
1020  */
1021 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1022     // Mapping from owner to list of owned token IDs
1023     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1024 
1025     // Mapping from token ID to index of the owner tokens list
1026     mapping(uint256 => uint256) private _ownedTokensIndex;
1027 
1028     // Array with all token ids, used for enumeration
1029     uint256[] private _allTokens;
1030 
1031     // Mapping from token id to position in the allTokens array
1032     mapping(uint256 => uint256) private _allTokensIndex;
1033 
1034     /**
1035      * @dev See {IERC165-supportsInterface}.
1036      */
1037     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1038         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1039     }
1040 
1041     /**
1042      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1043      */
1044     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1045         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1046         return _ownedTokens[owner][index];
1047     }
1048 
1049     /**
1050      * @dev See {IERC721Enumerable-totalSupply}.
1051      */
1052     function totalSupply() public view virtual override returns (uint256) {
1053         return _allTokens.length;
1054     }
1055 
1056     /**
1057      * @dev See {IERC721Enumerable-tokenByIndex}.
1058      */
1059     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1060         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1061         return _allTokens[index];
1062     }
1063 
1064     /**
1065      * @dev Hook that is called before any token transfer. This includes minting
1066      * and burning.
1067      *
1068      * Calling conditions:
1069      *
1070      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1071      * transferred to `to`.
1072      * - When `from` is zero, `tokenId` will be minted for `to`.
1073      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1074      * - `from` cannot be the zero address.
1075      * - `to` cannot be the zero address.
1076      *
1077      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1078      */
1079     function _beforeTokenTransfer(
1080         address from,
1081         address to,
1082         uint256 tokenId
1083     ) internal virtual override {
1084         super._beforeTokenTransfer(from, to, tokenId);
1085 
1086         if (from == address(0)) {
1087             _addTokenToAllTokensEnumeration(tokenId);
1088         } else if (from != to) {
1089             _removeTokenFromOwnerEnumeration(from, tokenId);
1090         }
1091         if (to == address(0)) {
1092             _removeTokenFromAllTokensEnumeration(tokenId);
1093         } else if (to != from) {
1094             _addTokenToOwnerEnumeration(to, tokenId);
1095         }
1096     }
1097 
1098     /**
1099      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1100      * @param to address representing the new owner of the given token ID
1101      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1102      */
1103     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1104         uint256 length = ERC721.balanceOf(to);
1105         _ownedTokens[to][length] = tokenId;
1106         _ownedTokensIndex[tokenId] = length;
1107     }
1108 
1109     /**
1110      * @dev Private function to add a token to this extension's token tracking data structures.
1111      * @param tokenId uint256 ID of the token to be added to the tokens list
1112      */
1113     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1114         _allTokensIndex[tokenId] = _allTokens.length;
1115         _allTokens.push(tokenId);
1116     }
1117 
1118     /**
1119      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1120      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1121      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1122      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1123      * @param from address representing the previous owner of the given token ID
1124      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1125      */
1126     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1127         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1128         // then delete the last slot (swap and pop).
1129 
1130         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1131         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1132 
1133         // When the token to delete is the last token, the swap operation is unnecessary
1134         if (tokenIndex != lastTokenIndex) {
1135             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1136 
1137             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1138             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1139         }
1140 
1141         // This also deletes the contents at the last position of the array
1142         delete _ownedTokensIndex[tokenId];
1143         delete _ownedTokens[from][lastTokenIndex];
1144     }
1145 
1146     /**
1147      * @dev Private function to remove a token from this extension's token tracking data structures.
1148      * This has O(1) time complexity, but alters the order of the _allTokens array.
1149      * @param tokenId uint256 ID of the token to be removed from the tokens list
1150      */
1151     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1152         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1153         // then delete the last slot (swap and pop).
1154 
1155         uint256 lastTokenIndex = _allTokens.length - 1;
1156         uint256 tokenIndex = _allTokensIndex[tokenId];
1157 
1158         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1159         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1160         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1161         uint256 lastTokenId = _allTokens[lastTokenIndex];
1162 
1163         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1164         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1165 
1166         // This also deletes the contents at the last position of the array
1167         delete _allTokensIndex[tokenId];
1168         _allTokens.pop();
1169     }
1170 }
1171 
1172 
1173 // File: @openzeppelin/contracts/access/Ownable.sol
1174 pragma solidity ^0.8.0;
1175 /**
1176  * @dev Contract module which provides a basic access control mechanism, where
1177  * there is an account (an owner) that can be granted exclusive access to
1178  * specific functions.
1179  *
1180  * By default, the owner account will be the one that deploys the contract. This
1181  * can later be changed with {transferOwnership}.
1182  *
1183  * This module is used through inheritance. It will make available the modifier
1184  * `onlyOwner`, which can be applied to your functions to restrict their use to
1185  * the owner.
1186  */
1187 abstract contract Ownable is Context {
1188     address private _owner;
1189 
1190     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1191 
1192     /**
1193      * @dev Initializes the contract setting the deployer as the initial owner.
1194      */
1195     constructor() {
1196         _setOwner(_msgSender());
1197     }
1198 
1199     /**
1200      * @dev Returns the address of the current owner.
1201      */
1202     function owner() public view virtual returns (address) {
1203         return _owner;
1204     }
1205 
1206     /**
1207      * @dev Throws if called by any account other than the owner.
1208      */
1209     modifier onlyOwner() {
1210         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1211         _;
1212     }
1213 
1214     /**
1215      * @dev Leaves the contract without owner. It will not be possible to call
1216      * `onlyOwner` functions anymore. Can only be called by the current owner.
1217      *
1218      * NOTE: Renouncing ownership will leave the contract without an owner,
1219      * thereby removing any functionality that is only available to the owner.
1220      */
1221     function renounceOwnership() public virtual onlyOwner {
1222         _setOwner(address(0));
1223     }
1224 
1225     /**
1226      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1227      * Can only be called by the current owner.
1228      */
1229     function transferOwnership(address newOwner) public virtual onlyOwner {
1230         require(newOwner != address(0), "Ownable: new owner is the zero address");
1231         _setOwner(newOwner);
1232     }
1233 
1234     function _setOwner(address newOwner) private {
1235         address oldOwner = _owner;
1236         _owner = newOwner;
1237         emit OwnershipTransferred(oldOwner, newOwner);
1238     }
1239 }
1240 
1241 pragma solidity >=0.7.0 <0.9.0;
1242 
1243 contract bouncywizardswtf is ERC721Enumerable, Ownable {
1244   using Strings for uint256;
1245 
1246   string baseURI;
1247   string public baseExtension = ".json";
1248   uint256 public cost = 0 ether;
1249   uint256 public maxSupply = 5555;
1250   uint256 public maxMintAmount = 2;
1251   bool public paused = true;
1252   bool public revealed = true;
1253 
1254   constructor(
1255     string memory _name,
1256     string memory _symbol,
1257     string memory _initBaseURI
1258   ) ERC721(_name, _symbol) {
1259     setBaseURI(_initBaseURI);
1260   }
1261 
1262   // internal
1263   function _baseURI() internal view virtual override returns (string memory) {
1264     return baseURI;
1265   }
1266 
1267   // public
1268   function mint(uint256 _mintAmount) public payable {
1269     uint256 supply = totalSupply();
1270     require(!paused);
1271     require(_mintAmount > 0);
1272     require(_mintAmount <= maxMintAmount);
1273     require(supply + _mintAmount <= maxSupply);
1274 
1275     if (msg.sender != owner()) {
1276       require(msg.value >= cost * _mintAmount);
1277     }
1278 
1279     for (uint256 i = 1; i <= _mintAmount; i++) {
1280       _safeMint(msg.sender, supply + i);
1281     }
1282   }
1283 
1284   function walletOfOwner(address _owner)
1285     public
1286     view
1287     returns (uint256[] memory)
1288   {
1289     uint256 ownerTokenCount = balanceOf(_owner);
1290     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1291     for (uint256 i; i < ownerTokenCount; i++) {
1292       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1293     }
1294     return tokenIds;
1295   }
1296 
1297   function tokenURI(uint256 tokenId)
1298     public
1299     view
1300     virtual
1301     override
1302     returns (string memory)
1303   {
1304     require(
1305       _exists(tokenId),
1306       "ERC721Metadata: URI query for nonexistent token"
1307     );
1308     
1309 
1310     string memory currentBaseURI = _baseURI();
1311     return bytes(currentBaseURI).length > 0
1312         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1313         : "";
1314   }
1315 
1316   //only owner
1317   function reveal() public onlyOwner {
1318       revealed = true;
1319   }
1320   
1321   function setCost(uint256 _newCost) public onlyOwner {
1322     cost = _newCost;
1323   }
1324 
1325   function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
1326     maxMintAmount = _newmaxMintAmount;
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
1342     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1343     require(os);
1344   }
1345 }