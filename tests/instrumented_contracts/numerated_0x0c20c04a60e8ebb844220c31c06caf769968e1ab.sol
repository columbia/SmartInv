1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6 
7        ___
8        )_(                                            _
9        | |                                           [_ ]
10      .-'-'-.       _                               .-'. '-.
11     /-::_..-\    _[_]_                            /:;/ _.-'\
12     )_     _(   /_   _\      [-]                  |:._   .-|
13     |;::    |   )_``'_(    .-'-'-.       (-)      |:._     |
14     |;::    |   |;:   |    :-...-:     .-'-'-.    |:._     |
15     |;::    |   |;:   |    |;:   |     |-...-|    |:._     |
16     |;::-.._|   |;:.._|    |;:.._|     |;:.._|    |:._     |
17     `-.._..-'   `-...-'    `-...-'     `-...-'    `-.____.-' 
18 _________ _                 _______  _       _________ _______  _______          
19 \__   __/( (    /||\     /|(  ____ \( (    /|\__   __/(  ___  )(  ____ )|\     /|
20    ) (   |  \  ( || )   ( || (    \/|  \  ( |   ) (   | (   ) || (    )|( \   / )
21    | |   |   \ | || |   | || (__    |   \ | |   | |   | |   | || (____)| \ (_) / 
22    | |   | (\ \) |( (   ) )|  __)   | (\ \) |   | |   | |   | ||     __)  \   /  
23    | |   | | \   | \ \_/ / | (      | | \   |   | |   | |   | || (\ (      ) (   
24 ___) (___| )  \  |  \   /  | (____/\| )  \  |   | |   | (___) || ) \ \__   | |   
25 \_______/|/    )_)   \_/   (_______/|/    )_)   )_(   (_______)|/   \__/   \_/   
26 
27 */
28 
29 /**
30  * @dev Interface of the ERC165 standard, as defined in the
31  * https://eips.ethereum.org/EIPS/eip-165[EIP].
32  *
33  * Implementers can declare support of contract interfaces, which can then be
34  * queried by others ({ERC165Checker}).
35  *
36  * For an implementation, see {ERC165}.
37  */
38 interface IERC165 {
39     /**
40      * @dev Returns true if this contract implements the interface defined by
41      * `interfaceId`. See the corresponding
42      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
43      * to learn more about how these ids are created.
44      *
45      * This function call must use less than 30 000 gas.
46      */
47     function supportsInterface(bytes4 interfaceId) external view returns (bool);
48 }
49 
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
187 library Strings {
188     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
189 
190     /**
191      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
192      */
193     function toString(uint256 value) internal pure returns (string memory) {
194         // Inspired by OraclizeAPI's implementation - MIT licence
195         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
196 
197         if (value == 0) {
198             return "0";
199         }
200         uint256 temp = value;
201         uint256 digits;
202         while (temp != 0) {
203             digits++;
204             temp /= 10;
205         }
206         bytes memory buffer = new bytes(digits);
207         while (value != 0) {
208             digits -= 1;
209             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
210             value /= 10;
211         }
212         return string(buffer);
213     }
214 
215     /**
216      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
217      */
218     function toHexString(uint256 value) internal pure returns (string memory) {
219         if (value == 0) {
220             return "0x00";
221         }
222         uint256 temp = value;
223         uint256 length = 0;
224         while (temp != 0) {
225             length++;
226             temp >>= 8;
227         }
228         return toHexString(value, length);
229     }
230 
231     /**
232      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
233      */
234     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
235         bytes memory buffer = new bytes(2 * length + 2);
236         buffer[0] = "0";
237         buffer[1] = "x";
238         for (uint256 i = 2 * length + 1; i > 1; --i) {
239             buffer[i] = _HEX_SYMBOLS[value & 0xf];
240             value >>= 4;
241         }
242         require(value == 0, "Strings: hex length insufficient");
243         return string(buffer);
244     }
245 }
246 
247 /**
248  * @dev Provides information about the current execution context, including the
249  * sender of the transaction and its data. While these are generally available
250  * via msg.sender and msg.data, they should not be accessed in such a direct
251  * manner, since when dealing with meta-transactions the account sending and
252  * paying for execution may not be the actual sender (as far as an application
253  * is concerned).
254  *
255  * This contract is only required for intermediate, library-like contracts.
256  */
257 abstract contract Context {
258     function _msgSender() internal view virtual returns (address) {
259         return msg.sender;
260     }
261 
262     function _msgData() internal view virtual returns (bytes calldata) {
263         return msg.data;
264     }
265 }
266 
267 /**
268  * @title ERC721 token receiver interface
269  * @dev Interface for any contract that wants to support safeTransfers
270  * from ERC721 asset contracts.
271  */
272 interface IERC721Receiver {
273     /**
274      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
275      * by `operator` from `from`, this function is called.
276      *
277      * It must return its Solidity selector to confirm the token transfer.
278      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
279      *
280      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
281      */
282     function onERC721Received(
283         address operator,
284         address from,
285         uint256 tokenId,
286         bytes calldata data
287     ) external returns (bytes4);
288 }
289 
290 /**
291  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
292  * @dev See https://eips.ethereum.org/EIPS/eip-721
293  */
294 interface IERC721Metadata is IERC721 {
295     /**
296      * @dev Returns the token collection name.
297      */
298     function name() external view returns (string memory);
299 
300     /**
301      * @dev Returns the token collection symbol.
302      */
303     function symbol() external view returns (string memory);
304 
305     /**
306      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
307      */
308     function tokenURI(uint256 tokenId) external view returns (string memory);
309 }
310 
311 /**
312  * @dev Collection of functions related to the address type
313  */
314 library Address {
315     /**
316      * @dev Returns true if `account` is a contract.
317      *
318      * [IMPORTANT]
319      * ====
320      * It is unsafe to assume that an address for which this function returns
321      * false is an externally-owned account (EOA) and not a contract.
322      *
323      * Among others, `isContract` will return false for the following
324      * types of addresses:
325      *
326      *  - an externally-owned account
327      *  - a contract in construction
328      *  - an address where a contract will be created
329      *  - an address where a contract lived, but was destroyed
330      * ====
331      */
332     function isContract(address account) internal view returns (bool) {
333         // This method relies on extcodesize, which returns 0 for contracts in
334         // construction, since the code is only stored at the end of the
335         // constructor execution.
336 
337         uint256 size;
338         assembly {
339             size := extcodesize(account)
340         }
341         return size > 0;
342     }
343 
344     /**
345      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
346      * `recipient`, forwarding all available gas and reverting on errors.
347      *
348      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
349      * of certain opcodes, possibly making contracts go over the 2300 gas limit
350      * imposed by `transfer`, making them unable to receive funds via
351      * `transfer`. {sendValue} removes this limitation.
352      *
353      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
354      *
355      * IMPORTANT: because control is transferred to `recipient`, care must be
356      * taken to not create reentrancy vulnerabilities. Consider using
357      * {ReentrancyGuard} or the
358      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
359      */
360     function sendValue(address payable recipient, uint256 amount) internal {
361         require(address(this).balance >= amount, "Address: insufficient balance");
362 
363         (bool success, ) = recipient.call{value: amount}("");
364         require(success, "Address: unable to send value, recipient may have reverted");
365     }
366 
367     /**
368      * @dev Performs a Solidity function call using a low level `call`. A
369      * plain `call` is an unsafe replacement for a function call: use this
370      * function instead.
371      *
372      * If `target` reverts with a revert reason, it is bubbled up by this
373      * function (like regular Solidity function calls).
374      *
375      * Returns the raw returned data. To convert to the expected return value,
376      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
377      *
378      * Requirements:
379      *
380      * - `target` must be a contract.
381      * - calling `target` with `data` must not revert.
382      *
383      * _Available since v3.1._
384      */
385     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
386         return functionCall(target, data, "Address: low-level call failed");
387     }
388 
389     /**
390      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
391      * `errorMessage` as a fallback revert reason when `target` reverts.
392      *
393      * _Available since v3.1._
394      */
395     function functionCall(
396         address target,
397         bytes memory data,
398         string memory errorMessage
399     ) internal returns (bytes memory) {
400         return functionCallWithValue(target, data, 0, errorMessage);
401     }
402 
403     /**
404      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
405      * but also transferring `value` wei to `target`.
406      *
407      * Requirements:
408      *
409      * - the calling contract must have an ETH balance of at least `value`.
410      * - the called Solidity function must be `payable`.
411      *
412      * _Available since v3.1._
413      */
414     function functionCallWithValue(
415         address target,
416         bytes memory data,
417         uint256 value
418     ) internal returns (bytes memory) {
419         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
420     }
421 
422     /**
423      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
424      * with `errorMessage` as a fallback revert reason when `target` reverts.
425      *
426      * _Available since v3.1._
427      */
428     function functionCallWithValue(
429         address target,
430         bytes memory data,
431         uint256 value,
432         string memory errorMessage
433     ) internal returns (bytes memory) {
434         require(address(this).balance >= value, "Address: insufficient balance for call");
435         require(isContract(target), "Address: call to non-contract");
436 
437         (bool success, bytes memory returndata) = target.call{value: value}(data);
438         return verifyCallResult(success, returndata, errorMessage);
439     }
440 
441     /**
442      * @dev Same as {xref-Adadress-functionCall-address-bytes-}[`functionCall`],
443      * but performing a static call.
444      *
445      * _Available since v3.3._
446      */
447     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
448         return functionStaticCall(target, data, "Address: low-level static call failed");
449     }
450 
451     /**
452      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
453      * but performing a static call.
454      *
455      * _Available since v3.3._
456      */
457     function functionStaticCall(
458         address target,
459         bytes memory data,
460         string memory errorMessage
461     ) internal view returns (bytes memory) {
462         require(isContract(target), "Address: static call to non-contract");
463 
464         (bool success, bytes memory returndata) = target.staticcall(data);
465         return verifyCallResult(success, returndata, errorMessage);
466     }
467 
468     /**
469      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
470      * but performing a delegate call.
471      *
472      * _Available since v3.4._
473      */
474     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
475         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
476     }
477 
478     /**
479      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
480      * but performing a delegate call.
481      *
482      * _Available since v3.4._
483      */
484     function functionDelegateCall(
485         address target,
486         bytes memory data,
487         string memory errorMessage
488     ) internal returns (bytes memory) {
489         require(isContract(target), "Address: delegate call to non-contract");
490 
491         (bool success, bytes memory returndata) = target.delegatecall(data);
492         return verifyCallResult(success, returndata, errorMessage);
493     }
494 
495     /**
496      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
497      * revert reason using the provided one.
498      *
499      * _Available since v4.3._
500      */
501     function verifyCallResult(
502         bool success,
503         bytes memory returndata,
504         string memory errorMessage
505     ) internal pure returns (bytes memory) {
506         if (success) {
507             return returndata;
508         } else {
509             // Look for revert reason and bubble it up if present
510             if (returndata.length > 0) {
511                 // The easiest way to bubble the revert reason is using memory via assembly
512 
513                 assembly {
514                     let returndata_size := mload(returndata)
515                     revert(add(32, returndata), returndata_size)
516                 }
517             } else {
518                 revert(errorMessage);
519             }
520         }
521     }
522 }
523 
524 /**
525  * @dev Implementation of the {IERC165} interface.
526  *
527  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
528  * for the additional interface id that will be supported. For example:
529  *
530  * ```solidity
531  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
532  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
533  * }
534  * ```
535  *
536  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
537  */
538 abstract contract ERC165 is IERC165 {
539     /**
540      * @dev See {IERC165-supportsInterface}.
541      */
542     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
543         return interfaceId == type(IERC165).interfaceId;
544     }
545 }
546 
547 /**
548  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
549  * the Metadata extension, but not including the Enumerable extension, which is available separately as
550  * {ERC721Enumerable}.
551  */
552 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
553     using Address for address;
554     using Strings for uint256;
555 
556     // Token name
557     string private _name;
558 
559     // Token symbol
560     string private _symbol;
561 
562     // Mapping from token ID to owner address
563     mapping(uint256 => address) private _owners;
564 
565     // Mapping owner address to token count
566     mapping(address => uint256) private _balances;
567 
568     // Mapping from token ID to approved address
569     mapping(uint256 => address) private _tokenApprovals;
570 
571     // Mapping from owner to operator approvals
572     mapping(address => mapping(address => bool)) private _operatorApprovals;
573 
574     /**
575      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
576      */
577     constructor(string memory name_, string memory symbol_) {
578         _name = name_;
579         _symbol = symbol_;
580     }
581 
582     /**
583      * @dev See {IERC165-supportsInterface}.
584      */
585     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
586         return
587             interfaceId == type(IERC721).interfaceId ||
588             interfaceId == type(IERC721Metadata).interfaceId ||
589             super.supportsInterface(interfaceId);
590     }
591 
592     /**
593      * @dev See {IERC721-balanceOf}.
594      */
595     function balanceOf(address owner) public view virtual override returns (uint256) {
596         require(owner != address(0), "ERC721: balance query for the zero address");
597         return _balances[owner];
598     }
599 
600     /**
601      * @dev See {IERC721-ownerOf}.
602      */
603     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
604         address owner = _owners[tokenId];
605         require(owner != address(0), "ERC721: owner query for nonexistent token");
606         return owner;
607     }
608 
609     /**
610      * @dev See {IERC721Metadata-name}.
611      */
612     function name() public view virtual override returns (string memory) {
613         return _name;
614     }
615 
616     /**
617      * @dev See {IERC721Metadata-symbol}.
618      */
619     function symbol() public view virtual override returns (string memory) {
620         return _symbol;
621     }
622 
623     /**
624      * @dev See {IERC721Metadata-tokenURI}.
625      */
626     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
627         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
628 
629         string memory baseURI = _baseURI();
630         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
631     }
632 
633     /**
634      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
635      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
636      * by default, can be overriden in child contracts.
637      */
638     function _baseURI() internal view virtual returns (string memory) {
639         return "";
640     }
641 
642     /**
643      * @dev See {IERC721-approve}.
644      */
645     function approve(address to, uint256 tokenId) public virtual override {
646         address owner = ERC721.ownerOf(tokenId);
647         require(to != owner, "ERC721: approval to current owner");
648 
649         require(
650             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
651             "ERC721: approve caller is not owner nor approved for all"
652         );
653 
654         _approve(to, tokenId);
655     }
656 
657     /**
658      * @dev See {IERC721-getApproved}.
659      */
660     function getApproved(uint256 tokenId) public view virtual override returns (address) {
661         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
662 
663         return _tokenApprovals[tokenId];
664     }
665 
666     /**
667      * @dev See {IERC721-setApprovalForAll}.
668      */
669     function setApprovalForAll(address operator, bool approved) public virtual override {
670         require(operator != _msgSender(), "ERC721: approve to caller");
671 
672         _operatorApprovals[_msgSender()][operator] = approved;
673         emit ApprovalForAll(_msgSender(), operator, approved);
674     }
675 
676     /**
677      * @dev See {IERC721-isApprovedForAll}.
678      */
679     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
680         return _operatorApprovals[owner][operator];
681     }
682 
683     /**
684      * @dev See {IERC721-transferFrom}.
685      */
686     function transferFrom(
687         address from,
688         address to,
689         uint256 tokenId
690     ) public virtual override {
691         //solhint-disable-next-line max-line-length
692         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
693 
694         _transfer(from, to, tokenId);
695     }
696 
697     /**
698      * @dev See {IERC721-safeTransferFrom}.
699      */
700     function safeTransferFrom(
701         address from,
702         address to,
703         uint256 tokenId
704     ) public virtual override {
705         safeTransferFrom(from, to, tokenId, "");
706     }
707 
708     /**
709      * @dev See {IERC721-safeTransferFrom}.
710      */
711     function safeTransferFrom(
712         address from,
713         address to,
714         uint256 tokenId,
715         bytes memory _data
716     ) public virtual override {
717         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
718         _safeTransfer(from, to, tokenId, _data);
719     }
720 
721     /**
722      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
723      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
724      *
725      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
726      *
727      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
728      * implement alternative mechanisms to perform token transfer, such as signature-based.
729      *
730      * Requirements:
731      *
732      * - `from` cannot be the zero address.
733      * - `to` cannot be the zero address.
734      * - `tokenId` token must exist and be owned by `from`.
735      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
736      *
737      * Emits a {Transfer} event.
738      */
739     function _safeTransfer(
740         address from,
741         address to,
742         uint256 tokenId,
743         bytes memory _data
744     ) internal virtual {
745         _transfer(from, to, tokenId);
746         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
747     }
748 
749     /**
750      * @dev Returns whether `tokenId` exists.
751      *
752      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
753      *
754      * Tokens start existing when they are minted (`_mint`),
755      * and stop existing when they are burned (`_burn`).
756      */
757     function _exists(uint256 tokenId) internal view virtual returns (bool) {
758         return _owners[tokenId] != address(0);
759     }
760 
761     /**
762      * @dev Returns whether `spender` is allowed to manage `tokenId`.
763      *
764      * Requirements:
765      *
766      * - `tokenId` must exist.
767      */
768     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
769         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
770         address owner = ERC721.ownerOf(tokenId);
771         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
772     }
773 
774     /**
775      * @dev Safely mints `tokenId` and transfers it to `to`.
776      *
777      * Requirements:
778      *
779      * - `tokenId` must not exist.
780      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
781      *
782      * Emits a {Transfer} event.
783      */
784     function _safeMint(address to, uint256 tokenId) internal virtual {
785         _safeMint(to, tokenId, "");
786     }
787 
788     /**
789      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
790      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
791      */
792     function _safeMint(
793         address to,
794         uint256 tokenId,
795         bytes memory _data
796     ) internal virtual {
797         _mint(to, tokenId);
798         require(
799             _checkOnERC721Received(address(0), to, tokenId, _data),
800             "ERC721: transfer to non ERC721Receiver implementer"
801         );
802     }
803 
804     /**
805      * @dev Mints `tokenId` and transfers it to `to`.
806      *
807      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
808      *
809      * Requirements:
810      *
811      * - `tokenId` must not exist.
812      * - `to` cannot be the zero address.
813      *
814      * Emits a {Transfer} event.
815      */
816     function _mint(address to, uint256 tokenId) internal virtual {
817         require(to != address(0), "ERC721: mint to the zero address");
818         require(!_exists(tokenId), "ERC721: token already minted");
819 
820         _beforeTokenTransfer(address(0), to, tokenId);
821 
822         _balances[to] += 1;
823         _owners[tokenId] = to;
824 
825         emit Transfer(address(0), to, tokenId);
826     }
827 
828     /**
829      * @dev Destroys `tokenId`.
830      * The approval is cleared when the token is burned.
831      *
832      * Requirements:
833      *
834      * - `tokenId` must exist.
835      *
836      * Emits a {Transfer} event.
837      */
838     function _burn(uint256 tokenId) internal virtual {
839         address owner = ERC721.ownerOf(tokenId);
840 
841         _beforeTokenTransfer(owner, address(0), tokenId);
842 
843         // Clear approvals
844         _approve(address(0), tokenId);
845 
846         _balances[owner] -= 1;
847         delete _owners[tokenId];
848 
849         emit Transfer(owner, address(0), tokenId);
850     }
851 
852     /**
853      * @dev Transfers `tokenId` from `from` to `to`.
854      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
855      *
856      * Requirements:
857      *
858      * - `to` cannot be the zero address.
859      * - `tokenId` token must be owned by `from`.
860      *
861      * Emits a {Transfer} event.
862      */
863     function _transfer(
864         address from,
865         address to,
866         uint256 tokenId
867     ) internal virtual {
868         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
869         require(to != address(0), "ERC721: transfer to the zero address");
870 
871         _beforeTokenTransfer(from, to, tokenId);
872 
873         // Clear approvals from the previous owner
874         _approve(address(0), tokenId);
875 
876         _balances[from] -= 1;
877         _balances[to] += 1;
878         _owners[tokenId] = to;
879 
880         emit Transfer(from, to, tokenId);
881     }
882 
883     /**
884      * @dev Approve `to` to operate on `tokenId`
885      *
886      * Emits a {Approval} event.
887      */
888     function _approve(address to, uint256 tokenId) internal virtual {
889         _tokenApprovals[tokenId] = to;
890         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
891     }
892 
893     /**
894      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
895      * The call is not executed if the target address is not a contract.
896      *
897      * @param from address representing the previous owner of the given token ID
898      * @param to target address that will receive the tokens
899      * @param tokenId uint256 ID of the token to be transferred
900      * @param _data bytes optional data to send along with the call
901      * @return bool whether the call correctly returned the expected magic value
902      */
903     function _checkOnERC721Received(
904         address from,
905         address to,
906         uint256 tokenId,
907         bytes memory _data
908     ) private returns (bool) {
909         if (to.isContract()) {
910             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
911                 return retval == IERC721Receiver.onERC721Received.selector;
912             } catch (bytes memory reason) {
913                 if (reason.length == 0) {
914                     revert("ERC721: transfer to non ERC721Receiver implementer");
915                 } else {
916                     assembly {
917                         revert(add(32, reason), mload(reason))
918                     }
919                 }
920             }
921         } else {
922             return true;
923         }
924     }
925 
926     /**
927      * @dev Hook that is called before any token transfer. This includes minting
928      * and burning.
929      *
930      * Calling conditions:
931      *
932      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
933      * transferred to `to`.
934      * - When `from` is zero, `tokenId` will be minted for `to`.
935      * - When `to` is zero, ``from``'s `tokenId` will be burned.
936      * - `from` and `to` are never both zero.
937      *
938      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
939      */
940     function _beforeTokenTransfer(
941         address from,
942         address to,
943         uint256 tokenId
944     ) internal virtual {}
945 }
946 
947 /**
948  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
949  * @dev See https://eips.ethereum.org/EIPS/eip-721
950  */
951 interface IERC721Enumerable is IERC721 {
952     /**
953      * @dev Returns the total amount of tokens stored by the contract.
954      */
955     function totalSupply() external view returns (uint256);
956 
957     /**
958      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
959      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
960      */
961     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
962 
963     /**
964      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
965      * Use along with {totalSupply} to enumerate all tokens.
966      */
967     function tokenByIndex(uint256 index) external view returns (uint256);
968 }
969 
970 /**
971  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
972  * enumerability of all the token ids in the contract as well as all token ids owned by each
973  * account.
974  */
975 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
976     // Mapping from owner to list of owned token IDs
977     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
978 
979     // Mapping from token ID to index of the owner tokens list
980     mapping(uint256 => uint256) private _ownedTokensIndex;
981 
982     // Array with all token ids, used for enumeration
983     uint256[] private _allTokens;
984 
985     // Mapping from token id to position in the allTokens array
986     mapping(uint256 => uint256) private _allTokensIndex;
987 
988     /**
989      * @dev See {IERC165-supportsInterface}.
990      */
991     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
992         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
993     }
994 
995     /**
996      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
997      */
998     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
999         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1000         return _ownedTokens[owner][index];
1001     }
1002 
1003     /**
1004      * @dev See {IERC721Enumerable-totalSupply}.
1005      */
1006     function totalSupply() public view virtual override returns (uint256) {
1007         return _allTokens.length;
1008     }
1009 
1010     /**
1011      * @dev See {IERC721Enumerable-tokenByIndex}.
1012      */
1013     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1014         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1015         return _allTokens[index];
1016     }
1017 
1018     /**
1019      * @dev Hook that is called before any token transfer. This includes minting
1020      * and burning.
1021      *
1022      * Calling conditions:
1023      *
1024      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1025      * transferred to `to`.
1026      * - When `from` is zero, `tokenId` will be minted for `to`.
1027      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1028      * - `from` cannot be the zero address.
1029      * - `to` cannot be the zero address.
1030      *
1031      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1032      */
1033     function _beforeTokenTransfer(
1034         address from,
1035         address to,
1036         uint256 tokenId
1037     ) internal virtual override {
1038         super._beforeTokenTransfer(from, to, tokenId);
1039 
1040         if (from == address(0)) {
1041             _addTokenToAllTokensEnumeration(tokenId);
1042         } else if (from != to) {
1043             _removeTokenFromOwnerEnumeration(from, tokenId);
1044         }
1045         if (to == address(0)) {
1046             _removeTokenFromAllTokensEnumeration(tokenId);
1047         } else if (to != from) {
1048             _addTokenToOwnerEnumeration(to, tokenId);
1049         }
1050     }
1051 
1052     /**
1053      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1054      * @param to address representing the new owner of the given token ID
1055      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1056      */
1057     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1058         uint256 length = ERC721.balanceOf(to);
1059         _ownedTokens[to][length] = tokenId;
1060         _ownedTokensIndex[tokenId] = length;
1061     }
1062 
1063     /**
1064      * @dev Private function to add a token to this extension's token tracking data structures.
1065      * @param tokenId uint256 ID of the token to be added to the tokens list
1066      */
1067     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1068         _allTokensIndex[tokenId] = _allTokens.length;
1069         _allTokens.push(tokenId);
1070     }
1071 
1072     /**
1073      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1074      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1075      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1076      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1077      * @param from address representing the previous owner of the given token ID
1078      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1079      */
1080     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1081         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1082         // then delete the last slot (swap and pop).
1083 
1084         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1085         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1086 
1087         // When the token to delete is the last token, the swap operation is unnecessary
1088         if (tokenIndex != lastTokenIndex) {
1089             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1090 
1091             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1092             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1093         }
1094 
1095         // This also deletes the contents at the last position of the array
1096         delete _ownedTokensIndex[tokenId];
1097         delete _ownedTokens[from][lastTokenIndex];
1098     }
1099 
1100     /**
1101      * @dev Private function to remove a token from this extension's token tracking data structures.
1102      * This has O(1) time complexity, but alters the order of the _allTokens array.
1103      * @param tokenId uint256 ID of the token to be removed from the tokens list
1104      */
1105     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1106         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1107         // then delete the last slot (swap and pop).
1108 
1109         uint256 lastTokenIndex = _allTokens.length - 1;
1110         uint256 tokenIndex = _allTokensIndex[tokenId];
1111 
1112         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1113         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1114         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1115         uint256 lastTokenId = _allTokens[lastTokenIndex];
1116 
1117         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1118         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1119 
1120         // This also deletes the contents at the last position of the array
1121         delete _allTokensIndex[tokenId];
1122         _allTokens.pop();
1123     }
1124 }
1125 
1126 /**
1127  * @dev Contract module which provides a basic access control mechanism, where
1128  * there is an account (an owner) that can be granted exclusive access to
1129  * specific functions.
1130  *
1131  * By default, the owner account will be the one that deploys the contract. This
1132  * can later be changed with {transferOwnership}.
1133  *
1134  * This module is used through inheritance. It will make available the modifier
1135  * `onlyOwner`, which can be applied to your functions to restrict their use to
1136  * the owner.
1137  */
1138 abstract contract Ownable is Context {
1139     address private _owner;
1140 
1141     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1142 
1143     /**
1144      * @dev Initializes the contract setting the deployer as the initial owner.
1145      */
1146     constructor() {
1147         _setOwner(_msgSender());
1148     }
1149 
1150     /**
1151      * @dev Returns the address of the current owner.
1152      */
1153     function owner() public view virtual returns (address) {
1154         return _owner;
1155     }
1156 
1157     /**
1158      * @dev Throws if called by any account other than the owner.
1159      */
1160     modifier onlyOwner() {
1161         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1162         _;
1163     }
1164 
1165     /**
1166      * @dev Leaves the contract without owner. It will not be possible to call
1167      * `onlyOwner` functions anymore. Can only be called by the current owner.
1168      *
1169      * NOTE: Renouncing ownership will leave the contract without an owner,
1170      * thereby removing any functionality that is only available to the owner.
1171      */
1172     function renounceOwnership() public virtual onlyOwner {
1173         _setOwner(address(0));
1174     }
1175 
1176     /**
1177      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1178      * Can only be called by the current owner.
1179      */
1180     function transferOwnership(address newOwner) public virtual onlyOwner {
1181         require(newOwner != address(0), "Ownable: new owner is the zero address");
1182         _setOwner(newOwner);
1183     }
1184 
1185     function _setOwner(address newOwner) private {
1186         address oldOwner = _owner;
1187         _owner = newOwner;
1188         emit OwnershipTransferred(oldOwner, newOwner);
1189     }
1190 }
1191 
1192 contract InventoryNFT is ERC721Enumerable, Ownable {
1193     using Strings for uint256;
1194 
1195     uint256 public constant MAX_TOKENS = 7000;
1196     uint256 public constant PRICE = 0.00 ether;
1197     uint256 public constant MAX_PER_MINT = 10;
1198     uint256 public constant PRESALE_MAX_MINT = 10;
1199     uint256 public constant MAX_TOKENS_MINT = 30;
1200     uint256 public constant RESERVED_TOKENS = 300;
1201     address public constant founderAddress = 0xB3A88B3b682316Dcd1e45f60C6ECd012fe73a473;
1202     address public constant devAddress = 0x17a18727dB777776Ab5A3Bf686AA5fCfaf2b2738;
1203 
1204     uint256 public reservedClaimed;
1205 
1206     uint256 public numTokensMinted;
1207 
1208     string public baseTokenURI;
1209 
1210     bool public publicSaleStarted;
1211     bool public presaleStarted;
1212 
1213     mapping(address => bool) private _presaleEligible;
1214     mapping(address => uint256) private _totalClaimed;
1215 
1216     event BaseURIChanged(string baseURI);
1217     event PresaleMint(address minter, uint256 amountOfTokens);
1218     event PublicSaleMint(address minter, uint256 amountOfTokens);
1219 
1220     modifier whenPresaleStarted() {
1221         require(presaleStarted, "Presale has not started");
1222         _;
1223     }
1224 
1225     modifier whenPublicSaleStarted() {
1226         require(publicSaleStarted, "Public sale has not started");
1227         _;
1228     }
1229 
1230     constructor(string memory baseURI) ERC721("InventoryNFT", "INVENTORY") {
1231         baseTokenURI = baseURI;
1232     }
1233 
1234     function claimReserved(address recipient, uint256 amount) external onlyOwner {
1235         require(reservedClaimed != RESERVED_TOKENS, "Already have claimed all reserved tokens");
1236         require(reservedClaimed + amount <= RESERVED_TOKENS, "Minting would exceed max reserved tokens");
1237         require(recipient != address(0), "Cannot add null address");
1238         require(totalSupply() < MAX_TOKENS, "All tokens have been minted");
1239         require(totalSupply() + amount <= MAX_TOKENS, "Minting would exceed max supply");
1240 
1241         uint256 _nextTokenId = numTokensMinted + 1;
1242 
1243         for (uint256 i = 0; i < amount; i++) {
1244             _safeMint(recipient, _nextTokenId + i);
1245         }
1246         numTokensMinted += amount;
1247         reservedClaimed += amount;
1248     }
1249 
1250     function addToPresale(address[] calldata addresses) external onlyOwner {
1251         for (uint256 i = 0; i < addresses.length; i++) {
1252             require(addresses[i] != address(0), "Cannot add null address");
1253 
1254             _presaleEligible[addresses[i]] = true;
1255 
1256             _totalClaimed[addresses[i]] > 0 ? _totalClaimed[addresses[i]] : 0;
1257         }
1258     }
1259 
1260     function checkPresaleEligiblity(address addr) external view returns (bool) {
1261         return _presaleEligible[addr];
1262     }
1263 
1264     function amountClaimedBy(address owner) external view returns (uint256) {
1265         require(owner != address(0), "Cannot add null address");
1266 
1267         return _totalClaimed[owner];
1268     }
1269 
1270     function mintPresale(uint256 amountOfTokens) external payable whenPresaleStarted {
1271         require(_presaleEligible[msg.sender], "You are not eligible for the presale");
1272         require(totalSupply() < MAX_TOKENS, "All tokens have been minted");
1273         require(amountOfTokens <= PRESALE_MAX_MINT, "Cannot purchase this many tokens during presale");
1274         require(totalSupply() + amountOfTokens <= MAX_TOKENS, "Minting would exceed max supply");
1275         require(_totalClaimed[msg.sender] + amountOfTokens <= PRESALE_MAX_MINT, "Purchase exceeds max allowed");
1276         require(amountOfTokens > 0, "Must mint at least one token");
1277         require(PRICE * amountOfTokens == msg.value, "ETH amount is incorrect");
1278 
1279         for (uint256 i = 0; i < amountOfTokens; i++) {
1280             uint256 tokenId = numTokensMinted + 1;
1281 
1282             numTokensMinted += 1;
1283             _totalClaimed[msg.sender] += 1;
1284             _safeMint(msg.sender, tokenId);
1285         }
1286 
1287         emit PresaleMint(msg.sender, amountOfTokens);
1288     }
1289 
1290     function mint(uint256 amountOfTokens) external payable whenPublicSaleStarted {
1291         require(totalSupply() < MAX_TOKENS, "All tokens have been minted");
1292         require(amountOfTokens <= MAX_PER_MINT, "Cannot purchase this many tokens in a transaction");
1293         require(totalSupply() + amountOfTokens <= MAX_TOKENS, "Minting would exceed max supply");
1294         require(_totalClaimed[msg.sender] + amountOfTokens <= MAX_TOKENS_MINT, "Purchase exceeds max allowed per address");
1295         require(amountOfTokens > 0, "Must mint at least one token");
1296         require(PRICE * amountOfTokens == msg.value, "ETH amount is incorrect");
1297 
1298         for (uint256 i = 0; i < amountOfTokens; i++) {
1299             uint256 tokenId = numTokensMinted + 1;
1300 
1301             numTokensMinted += 1;
1302             _totalClaimed[msg.sender] += 1;
1303             _safeMint(msg.sender, tokenId);
1304         }
1305 
1306         emit PublicSaleMint(msg.sender, amountOfTokens);
1307     }
1308 
1309     function togglePresaleStarted() external onlyOwner {
1310         presaleStarted = !presaleStarted;
1311     }
1312 
1313     function togglePublicSaleStarted() external onlyOwner {
1314         publicSaleStarted = !publicSaleStarted;
1315     }
1316 
1317     function _baseURI() internal view virtual override returns (string memory) {
1318         return baseTokenURI;
1319     }
1320 
1321     function setBaseURI(string memory baseURI) public onlyOwner {
1322         baseTokenURI = baseURI;
1323         emit BaseURIChanged(baseURI);
1324     }
1325 
1326     function withdrawAll() public onlyOwner {
1327         uint256 balance = address(this).balance;
1328         require(balance > 0, "Insufficent balance");
1329         _widthdraw(devAddress, ((balance * 15) / 100));
1330         _widthdraw(founderAddress, address(this).balance);
1331     }
1332 
1333     function _widthdraw(address _address, uint256 _amount) private {
1334         (bool success, ) = _address.call{ value: _amount }("");
1335         require(success, "Failed to widthdraw Ether");
1336     }
1337 }