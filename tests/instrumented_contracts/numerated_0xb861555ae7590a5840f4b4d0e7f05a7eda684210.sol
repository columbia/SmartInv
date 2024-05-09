1 /**
2  *Submitted for verification at Etherscan.io on 2021-12-31
3 */
4 
5 /**
6 ##,                                   ,##
7 '##,                                 ,##'
8  '##                                 ##'
9   ##               __,               ##
10   ##          __.-'   \              ##
11   ##    ___.-'__.--'\ |              ##,
12   ## .-' .-, (      | |        _     '##
13   ##/ / /""=\ \     | |       / \     ##,
14   '#| |_\   / /     | |      /   \    '##
15   / `-` 0 0 '-'`\   | |      | |  \   ,##
16   \_,   (__)  ,_/  / /       |  \  \  ##'
17    / /    \   \\  / /        |  |\  \ ## __
18   | /`.__.-'-._)|/ /         |  | \  \##`__)
19   \        ^    / /          |  |  | v## '--.
20    '._    '-'_.' / _.----.   |  |  l ,##  (_,'
21     '##'-,  ` `"""/       `'/|  | / ,##--,  )
22      '#/`        `         '    |'  ##'   `"
23       |                         /\_/#'
24  jgs  |              __.  .-,_.;###`
25      _|___/_..---'''`   _/  (###'
26  .-'`   ____,...---""```     `._
27 (   --''        __,.,---.    ',_)
28  `.,___,..---'``  / /    \     '._
29       |  |       ( (      `.  '-._)
30       |  /        \ \      \'-._)
31       | |          \ \      `"`
32       | |           \ \
33       | |    .-,     ) |
34       | |   ( (     / /
35       | |    \ '---' /
36       /  \    `-----`
37      | , /
38      |(_/\-,
39      \  ,_`)
40       `-._)
41 */
42 
43 // Sources flattened with hardhat v2.5.0 https://hardhat.org
44  
45 // File contracts/utils/introspection/IERC165.sol
46  
47 // SPDX-License-Identifier: MIT
48  
49 pragma solidity ^0.8.0;
50  
51 /**
52  * @dev Interface of the ERC165 standard, as defined in the
53  * https://eips.ethereum.org/EIPS/eip-165[EIP].
54  *
55  * Implementers can declare support of contract interfaces, which can then be
56  * queried by others ({ERC165Checker}).
57  *
58  * For an implementation, see {ERC165}.
59  */
60 interface IERC165 {
61     /**
62      * @dev Returns true if this contract implements the interface defined by
63      * `interfaceId`. See the corresponding
64      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
65      * to learn more about how these ids are created.
66      *
67      * This function call must use less than 30 000 gas.
68      */
69     function supportsInterface(bytes4 interfaceId) external view returns (bool);
70 }
71  
72  
73 // File contracts/token/ERC721/IERC721.sol
74  
75  
76  
77 pragma solidity ^0.8.0;
78  
79 /**
80  * @dev Required interface of an ERC721 compliant contract.
81  */
82 interface IERC721 is IERC165 {
83     /**
84      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
85      */
86     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
87  
88     /**
89      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
90      */
91     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
92  
93     /**
94      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
95      */
96     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
97  
98     /**
99      * @dev Returns the number of tokens in ``owner``'s account.
100      */
101     function balanceOf(address owner) external view returns (uint256 balance);
102  
103     /**
104      * @dev Returns the owner of the `tokenId` token.
105      *
106      * Requirements:
107      *
108      * - `tokenId` must exist.
109      */
110     function ownerOf(uint256 tokenId) external view returns (address owner);
111  
112     /**
113      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
114      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
115      *
116      * Requirements:
117      *
118      * - `from` cannot be the zero address.
119      * - `to` cannot be the zero address.
120      * - `tokenId` token must exist and be owned by `from`.
121      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
122      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
123      *
124      * Emits a {Transfer} event.
125      */
126     function safeTransferFrom(address from, address to, uint256 tokenId) external;
127  
128     /**
129      * @dev Transfers `tokenId` token from `from` to `to`.
130      *
131      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
132      *
133      * Requirements:
134      *
135      * - `from` cannot be the zero address.
136      * - `to` cannot be the zero address.
137      * - `tokenId` token must be owned by `from`.
138      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
139      *
140      * Emits a {Transfer} event.
141      */
142     function transferFrom(address from, address to, uint256 tokenId) external;
143  
144     /**
145      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
146      * The approval is cleared when the token is transferred.
147      *
148      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
149      *
150      * Requirements:
151      *
152      * - The caller must own the token or be an approved operator.
153      * - `tokenId` must exist.
154      *
155      * Emits an {Approval} event.
156      */
157     function approve(address to, uint256 tokenId) external;
158  
159     /**
160      * @dev Returns the account approved for `tokenId` token.
161      *
162      * Requirements:
163      *
164      * - `tokenId` must exist.
165      */
166     function getApproved(uint256 tokenId) external view returns (address operator);
167  
168     /**
169      * @dev Approve or remove `operator` as an operator for the caller.
170      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
171      *
172      * Requirements:
173      *
174      * - The `operator` cannot be the caller.
175      *
176      * Emits an {ApprovalForAll} event.
177      */
178     function setApprovalForAll(address operator, bool _approved) external;
179  
180     /**
181      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
182      *
183      * See {setApprovalForAll}
184      */
185     function isApprovedForAll(address owner, address operator) external view returns (bool);
186  
187     /**
188       * @dev Safely transfers `tokenId` token from `from` to `to`.
189       *
190       * Requirements:
191       *
192       * - `from` cannot be the zero address.
193       * - `to` cannot be the zero address.
194       * - `tokenId` token must exist and be owned by `from`.
195       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
196       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
197       *
198       * Emits a {Transfer} event.
199       */
200     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
201 }
202  
203  
204 // File contracts/token/ERC721/IERC721Receiver.sol
205  
206  
207  
208 pragma solidity ^0.8.0;
209  
210 /**
211  * @title ERC721 token receiver interface
212  * @dev Interface for any contract that wants to support safeTransfers
213  * from ERC721 asset contracts.
214  */
215 interface IERC721Receiver {
216     /**
217      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
218      * by `operator` from `from`, this function is called.
219      *
220      * It must return its Solidity selector to confirm the token transfer.
221      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
222      *
223      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
224      */
225     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
226 }
227  
228  
229 // File contracts/token/ERC721/extensions/IERC721Metadata.sol
230  
231  
232  
233 pragma solidity ^0.8.0;
234  
235 /**
236  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
237  * @dev See https://eips.ethereum.org/EIPS/eip-721
238  */
239 interface IERC721Metadata is IERC721 {
240  
241     /**
242      * @dev Returns the token collection name.
243      */
244     function name() external view returns (string memory);
245  
246     /**
247      * @dev Returns the token collection symbol.
248      */
249     function symbol() external view returns (string memory);
250  
251     /**
252      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
253      */
254     function tokenURI(uint256 tokenId) external view returns (string memory);
255 }
256  
257  
258 // File contracts/utils/Address.sol
259  
260  
261  
262 pragma solidity ^0.8.0;
263  
264 /**
265  * @dev Collection of functions related to the address type
266  */
267 library Address {
268     /**
269      * @dev Returns true if `account` is a contract.
270      *
271      * [IMPORTANT]
272      * ====
273      * It is unsafe to assume that an address for which this function returns
274      * false is an externally-owned account (EOA) and not a contract.
275      *
276      * Among others, `isContract` will return false for the following
277      * types of addresses:
278      *
279      *  - an externally-owned account
280      *  - a contract in construction
281      *  - an address where a contract will be created
282      *  - an address where a contract lived, but was destroyed
283      * ====
284      */
285     function isContract(address account) internal view returns (bool) {
286         // This method relies on extcodesize, which returns 0 for contracts in
287         // construction, since the code is only stored at the end of the
288         // constructor execution.
289  
290         uint256 size;
291         // solhint-disable-next-line no-inline-assembly
292         assembly { size := extcodesize(account) }
293         return size > 0;
294     }
295  
296     /**
297      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
298      * `recipient`, forwarding all available gas and reverting on errors.
299      *
300      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
301      * of certain opcodes, possibly making contracts go over the 2300 gas limit
302      * imposed by `transfer`, making them unable to receive funds via
303      * `transfer`. {sendValue} removes this limitation.
304      *
305      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
306      *
307      * IMPORTANT: because control is transferred to `recipient`, care must be
308      * taken to not create reentrancy vulnerabilities. Consider using
309      * {ReentrancyGuard} or the
310      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
311      */
312     function sendValue(address payable recipient, uint256 amount) internal {
313         require(address(this).balance >= amount, "Address: insufficient balance");
314  
315         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
316         (bool success, ) = recipient.call{ value: amount }("");
317         require(success, "Address: unable to send value, recipient may have reverted");
318     }
319  
320     /**
321      * @dev Performs a Solidity function call using a low level `call`. A
322      * plain`call` is an unsafe replacement for a function call: use this
323      * function instead.
324      *
325      * If `target` reverts with a revert reason, it is bubbled up by this
326      * function (like regular Solidity function calls).
327      *
328      * Returns the raw returned data. To convert to the expected return value,
329      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
330      *
331      * Requirements:
332      *
333      * - `target` must be a contract.
334      * - calling `target` with `data` must not revert.
335      *
336      * _Available since v3.1._
337      */
338     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
339       return functionCall(target, data, "Address: low-level call failed");
340     }
341  
342     /**
343      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
344      * `errorMessage` as a fallback revert reason when `target` reverts.
345      *
346      * _Available since v3.1._
347      */
348     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
349         return functionCallWithValue(target, data, 0, errorMessage);
350     }
351  
352     /**
353      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
354      * but also transferring `value` wei to `target`.
355      *
356      * Requirements:
357      *
358      * - the calling contract must have an ETH balance of at least `value`.
359      * - the called Solidity function must be `payable`.
360      *
361      * _Available since v3.1._
362      */
363     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
364         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
365     }
366  
367     /**
368      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
369      * with `errorMessage` as a fallback revert reason when `target` reverts.
370      *
371      * _Available since v3.1._
372      */
373     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
374         require(address(this).balance >= value, "Address: insufficient balance for call");
375         require(isContract(target), "Address: call to non-contract");
376  
377         // solhint-disable-next-line avoid-low-level-calls
378         (bool success, bytes memory returndata) = target.call{ value: value }(data);
379         return _verifyCallResult(success, returndata, errorMessage);
380     }
381  
382     /**
383      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
384      * but performing a static call.
385      *
386      * _Available since v3.3._
387      */
388     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
389         return functionStaticCall(target, data, "Address: low-level static call failed");
390     }
391  
392     /**
393      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
394      * but performing a static call.
395      *
396      * _Available since v3.3._
397      */
398     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
399         require(isContract(target), "Address: static call to non-contract");
400  
401         // solhint-disable-next-line avoid-low-level-calls
402         (bool success, bytes memory returndata) = target.staticcall(data);
403         return _verifyCallResult(success, returndata, errorMessage);
404     }
405  
406     /**
407      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
408      * but performing a delegate call.
409      *
410      * _Available since v3.4._
411      */
412     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
413         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
414     }
415  
416     /**
417      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
418      * but performing a delegate call.
419      *
420      * _Available since v3.4._
421      */
422     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
423         require(isContract(target), "Address: delegate call to non-contract");
424  
425         // solhint-disable-next-line avoid-low-level-calls
426         (bool success, bytes memory returndata) = target.delegatecall(data);
427         return _verifyCallResult(success, returndata, errorMessage);
428     }
429  
430     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
431         if (success) {
432             return returndata;
433         } else {
434             // Look for revert reason and bubble it up if present
435             if (returndata.length > 0) {
436                 // The easiest way to bubble the revert reason is using memory via assembly
437  
438                 // solhint-disable-next-line no-inline-assembly
439                 assembly {
440                     let returndata_size := mload(returndata)
441                     revert(add(32, returndata), returndata_size)
442                 }
443             } else {
444                 revert(errorMessage);
445             }
446         }
447     }
448 }
449  
450  
451 // File contracts/utils/Context.sol
452  
453  
454  
455 pragma solidity ^0.8.0;
456  
457 /*
458  * @dev Provides information about the current execution context, including the
459  * sender of the transaction and its data. While these are generally available
460  * via msg.sender and msg.data, they should not be accessed in such a direct
461  * manner, since when dealing with meta-transactions the account sending and
462  * paying for execution may not be the actual sender (as far as an application
463  * is concerned).
464  *
465  * This contract is only required for intermediate, library-like contracts.
466  */
467 abstract contract Context {
468     function _msgSender() internal view virtual returns (address) {
469         return msg.sender;
470     }
471  
472     function _msgData() internal view virtual returns (bytes calldata) {
473         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
474         return msg.data;
475     }
476 }
477  
478  
479 // File contracts/utils/Strings.sol
480  
481  
482  
483 pragma solidity ^0.8.0;
484  
485 /**
486  * @dev String operations.
487  */
488 library Strings {
489     bytes16 private constant alphabet = "0123456789abcdef";
490  
491     /**
492      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
493      */
494     function toString(uint256 value) internal pure returns (string memory) {
495         // Inspired by OraclizeAPI's implementation - MIT licence
496         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
497  
498         if (value == 0) {
499             return "0";
500         }
501         uint256 temp = value;
502         uint256 digits;
503         while (temp != 0) {
504             digits++;
505             temp /= 10;
506         }
507         bytes memory buffer = new bytes(digits);
508         while (value != 0) {
509             digits -= 1;
510             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
511             value /= 10;
512         }
513         return string(buffer);
514     }
515  
516     /**
517      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
518      */
519     function toHexString(uint256 value) internal pure returns (string memory) {
520         if (value == 0) {
521             return "0x00";
522         }
523         uint256 temp = value;
524         uint256 length = 0;
525         while (temp != 0) {
526             length++;
527             temp >>= 8;
528         }
529         return toHexString(value, length);
530     }
531  
532     /**
533      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
534      */
535     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
536         bytes memory buffer = new bytes(2 * length + 2);
537         buffer[0] = "0";
538         buffer[1] = "x";
539         for (uint256 i = 2 * length + 1; i > 1; --i) {
540             buffer[i] = alphabet[value & 0xf];
541             value >>= 4;
542         }
543         require(value == 0, "Strings: hex length insufficient");
544         return string(buffer);
545     }
546  
547 }
548  
549  
550 // File contracts/utils/introspection/ERC165.sol
551  
552  
553  
554 pragma solidity ^0.8.0;
555  
556 /**
557  * @dev Implementation of the {IERC165} interface.
558  *
559  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
560  * for the additional interface id that will be supported. For example:
561  *
562  * ```solidity
563  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
564  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
565  * }
566  * ```
567  *
568  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
569  */
570 abstract contract ERC165 is IERC165 {
571     /**
572      * @dev See {IERC165-supportsInterface}.
573      */
574     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
575         return interfaceId == type(IERC165).interfaceId;
576     }
577 }
578  
579  
580 // File contracts/token/ERC721/ERC721.sol
581  
582  
583  
584 pragma solidity ^0.8.0;
585  
586  
587  
588  
589  
590  
591  
592 /**
593  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
594  * the Metadata extension, but not including the Enumerable extension, which is available separately as
595  * {ERC721Enumerable}.
596  */
597 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
598     using Address for address;
599     using Strings for uint256;
600  
601     // Token name
602     string private _name;
603  
604     // Token symbol
605     string private _symbol;
606  
607     // Mapping from token ID to owner address
608     mapping (uint256 => address) private _owners;
609  
610     // Mapping owner address to token count
611     mapping (address => uint256) private _balances;
612  
613     // Mapping from token ID to approved address
614     mapping (uint256 => address) private _tokenApprovals;
615  
616     // Mapping from owner to operator approvals
617     mapping (address => mapping (address => bool)) private _operatorApprovals;
618  
619     /**
620      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
621      */
622     constructor (string memory name_, string memory symbol_) {
623         _name = name_;
624         _symbol = symbol_;
625     }
626  
627     /**
628      * @dev See {IERC165-supportsInterface}.
629      */
630     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
631         return interfaceId == type(IERC721).interfaceId
632             || interfaceId == type(IERC721Metadata).interfaceId
633             || super.supportsInterface(interfaceId);
634     }
635  
636     /**
637      * @dev See {IERC721-balanceOf}.
638      */
639     function balanceOf(address owner) public view virtual override returns (uint256) {
640         require(owner != address(0), "ERC721: balance query for the zero address");
641         return _balances[owner];
642     }
643  
644     /**
645      * @dev See {IERC721-ownerOf}.
646      */
647     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
648         address owner = _owners[tokenId];
649         require(owner != address(0), "ERC721: owner query for nonexistent token");
650         return owner;
651     }
652  
653     /**
654      * @dev See {IERC721Metadata-name}.
655      */
656     function name() public view virtual override returns (string memory) {
657         return _name;
658     }
659  
660     /**
661      * @dev See {IERC721Metadata-symbol}.
662      */
663     function symbol() public view virtual override returns (string memory) {
664         return _symbol;
665     }
666  
667     /**
668      * @dev See {IERC721Metadata-tokenURI}.
669      */
670     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
671         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
672  
673         string memory baseURI = _baseURI();
674         return bytes(baseURI).length > 0
675             ? string(abi.encodePacked(baseURI, tokenId.toString()))
676             : '';
677     }
678  
679     /**
680      * @dev Base URI for computing {tokenURI}. Empty by default, can be overriden
681      * in child contracts.
682      */
683     function _baseURI() internal view virtual returns (string memory) {
684         return "";
685     }
686  
687     /**
688      * @dev See {IERC721-approve}.
689      */
690     function approve(address to, uint256 tokenId) public virtual override {
691         address owner = ERC721.ownerOf(tokenId);
692         require(to != owner, "ERC721: approval to current owner");
693  
694         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
695             "ERC721: approve caller is not owner nor approved for all"
696         );
697  
698         _approve(to, tokenId);
699     }
700  
701     /**
702      * @dev See {IERC721-getApproved}.
703      */
704     function getApproved(uint256 tokenId) public view virtual override returns (address) {
705         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
706  
707         return _tokenApprovals[tokenId];
708     }
709  
710     /**
711      * @dev See {IERC721-setApprovalForAll}.
712      */
713     function setApprovalForAll(address operator, bool approved) public virtual override {
714         require(operator != _msgSender(), "ERC721: approve to caller");
715  
716         _operatorApprovals[_msgSender()][operator] = approved;
717         emit ApprovalForAll(_msgSender(), operator, approved);
718     }
719  
720     /**
721      * @dev See {IERC721-isApprovedForAll}.
722      */
723     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
724         return _operatorApprovals[owner][operator];
725     }
726  
727     /**
728      * @dev See {IERC721-transferFrom}.
729      */
730     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
731         //solhint-disable-next-line max-line-length
732         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
733  
734         _transfer(from, to, tokenId);
735     }
736  
737     /**
738      * @dev See {IERC721-safeTransferFrom}.
739      */
740     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
741         safeTransferFrom(from, to, tokenId, "");
742     }
743  
744     /**
745      * @dev See {IERC721-safeTransferFrom}.
746      */
747     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
748         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
749         _safeTransfer(from, to, tokenId, _data);
750     }
751  
752     /**
753      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
754      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
755      *
756      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
757      *
758      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
759      * implement alternative mechanisms to perform token transfer, such as signature-based.
760      *
761      * Requirements:
762      *
763      * - `from` cannot be the zero address.
764      * - `to` cannot be the zero address.
765      * - `tokenId` token must exist and be owned by `from`.
766      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
767      *
768      * Emits a {Transfer} event.
769      */
770     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
771         _transfer(from, to, tokenId);
772         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
773     }
774  
775     /**
776      * @dev Returns whether `tokenId` exists.
777      *
778      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
779      *
780      * Tokens start existing when they are minted (`_mint`),
781      * and stop existing when they are burned (`_burn`).
782      */
783     function _exists(uint256 tokenId) internal view virtual returns (bool) {
784         return _owners[tokenId] != address(0);
785     }
786  
787     /**
788      * @dev Returns whether `spender` is allowed to manage `tokenId`.
789      *
790      * Requirements:
791      *
792      * - `tokenId` must exist.
793      */
794     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
795         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
796         address owner = ERC721.ownerOf(tokenId);
797         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
798     }
799  
800     /**
801      * @dev Safely mints `tokenId` and transfers it to `to`.
802      *
803      * Requirements:
804      *
805      * - `tokenId` must not exist.
806      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
807      *
808      * Emits a {Transfer} event.
809      */
810     function _safeMint(address to, uint256 tokenId) internal virtual {
811         _safeMint(to, tokenId, "");
812     }
813  
814     /**
815      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
816      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
817      */
818     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
819         _mint(to, tokenId);
820         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
821     }
822  
823     /**
824      * @dev Mints `tokenId` and transfers it to `to`.
825      *
826      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
827      *
828      * Requirements:
829      *
830      * - `tokenId` must not exist.
831      * - `to` cannot be the zero address.
832      *
833      * Emits a {Transfer} event.
834      */
835     function _mint(address to, uint256 tokenId) internal virtual {
836         require(to != address(0), "ERC721: mint to the zero address");
837         require(!_exists(tokenId), "ERC721: token already minted");
838  
839         _beforeTokenTransfer(address(0), to, tokenId);
840  
841         _balances[to] += 1;
842         _owners[tokenId] = to;
843  
844         emit Transfer(address(0), to, tokenId);
845     }
846  
847     /**
848      * @dev Destroys `tokenId`.
849      * The approval is cleared when the token is burned.
850      *
851      * Requirements:
852      *
853      * - `tokenId` must exist.
854      *
855      * Emits a {Transfer} event.
856      */
857     function _burn(uint256 tokenId) internal virtual {
858         address owner = ERC721.ownerOf(tokenId);
859  
860         _beforeTokenTransfer(owner, address(0), tokenId);
861  
862         // Clear approvals
863         _approve(address(0), tokenId);
864  
865         _balances[owner] -= 1;
866         delete _owners[tokenId];
867  
868         emit Transfer(owner, address(0), tokenId);
869     }
870  
871     /**
872      * @dev Transfers `tokenId` from `from` to `to`.
873      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
874      *
875      * Requirements:
876      *
877      * - `to` cannot be the zero address.
878      * - `tokenId` token must be owned by `from`.
879      *
880      * Emits a {Transfer} event.
881      */
882     function _transfer(address from, address to, uint256 tokenId) internal virtual {
883         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
884         require(to != address(0), "ERC721: transfer to the zero address");
885  
886         _beforeTokenTransfer(from, to, tokenId);
887  
888         // Clear approvals from the previous owner
889         _approve(address(0), tokenId);
890  
891         _balances[from] -= 1;
892         _balances[to] += 1;
893         _owners[tokenId] = to;
894  
895         emit Transfer(from, to, tokenId);
896     }
897  
898     /**
899      * @dev Approve `to` to operate on `tokenId`
900      *
901      * Emits a {Approval} event.
902      */
903     function _approve(address to, uint256 tokenId) internal virtual {
904         _tokenApprovals[tokenId] = to;
905         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
906     }
907  
908     /**
909      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
910      * The call is not executed if the target address is not a contract.
911      *
912      * @param from address representing the previous owner of the given token ID
913      * @param to target address that will receive the tokens
914      * @param tokenId uint256 ID of the token to be transferred
915      * @param _data bytes optional data to send along with the call
916      * @return bool whether the call correctly returned the expected magic value
917      */
918     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
919         private returns (bool)
920     {
921         if (to.isContract()) {
922             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
923                 return retval == IERC721Receiver(to).onERC721Received.selector;
924             } catch (bytes memory reason) {
925                 if (reason.length == 0) {
926                     revert("ERC721: transfer to non ERC721Receiver implementer");
927                 } else {
928                     // solhint-disable-next-line no-inline-assembly
929                     assembly {
930                         revert(add(32, reason), mload(reason))
931                     }
932                 }
933             }
934         } else {
935             return true;
936         }
937     }
938  
939     /**
940      * @dev Hook that is called before any token transfer. This includes minting
941      * and burning.
942      *
943      * Calling conditions:
944      *
945      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
946      * transferred to `to`.
947      * - When `from` is zero, `tokenId` will be minted for `to`.
948      * - When `to` is zero, ``from``'s `tokenId` will be burned.
949      * - `from` cannot be the zero address.
950      * - `to` cannot be the zero address.
951      *
952      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
953      */
954     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
955 }
956  
957  
958 // File contracts/token/ERC721/extensions/ERC721URIStorage.sol
959  
960  
961  
962 pragma solidity ^0.8.0;
963  
964 /**
965  * @dev ERC721 token with storage based token URI management.
966  */
967 abstract contract ERC721URIStorage is ERC721 {
968     using Strings for uint256;
969  
970     // Optional mapping for token URIs
971     mapping (uint256 => string) private _tokenURIs;
972  
973     /**
974      * @dev See {IERC721Metadata-tokenURI}.
975      */
976     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
977         require(_exists(tokenId), "ERC721URIStorage: URI query for nonexistent token");
978  
979         string memory _tokenURI = _tokenURIs[tokenId];
980         string memory base = _baseURI();
981  
982         // If there is no base URI, return the token URI.
983         if (bytes(base).length == 0) {
984             return _tokenURI;
985         }
986         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
987         if (bytes(_tokenURI).length > 0) {
988             return string(abi.encodePacked(base, _tokenURI));
989         }
990  
991         return super.tokenURI(tokenId);
992     }
993  
994     /**
995      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
996      *
997      * Requirements:
998      *
999      * - `tokenId` must exist.
1000      */
1001     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1002         require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
1003         _tokenURIs[tokenId] = _tokenURI;
1004     }
1005  
1006     /**
1007      * @dev Destroys `tokenId`.
1008      * The approval is cleared when the token is burned.
1009      *
1010      * Requirements:
1011      *
1012      * - `tokenId` must exist.
1013      *
1014      * Emits a {Transfer} event.
1015      */
1016     function _burn(uint256 tokenId) internal virtual override {
1017         super._burn(tokenId);
1018  
1019         if (bytes(_tokenURIs[tokenId]).length != 0) {
1020             delete _tokenURIs[tokenId];
1021         }
1022     }
1023 }
1024  
1025  
1026 // File contracts/access/Ownable.sol
1027  
1028  
1029  
1030 pragma solidity ^0.8.0;
1031  
1032 /**
1033  * @dev Contract module which provides a basic access control mechanism, where
1034  * there is an account (an owner) that can be granted exclusive access to
1035  * specific functions.
1036  *
1037  * By default, the owner account will be the one that deploys the contract. This
1038  * can later be changed with {transferOwnership}.
1039  *
1040  * This module is used through inheritance. It will make available the modifier
1041  * `onlyOwner`, which can be applied to your functions to restrict their use to
1042  * the owner.
1043  */
1044 abstract contract Ownable is Context {
1045     address private _owner;
1046  
1047     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1048  
1049     /**
1050      * @dev Initializes the contract setting the deployer as the initial owner.
1051      */
1052     constructor () {
1053         address msgSender = _msgSender();
1054         _owner = msgSender;
1055         emit OwnershipTransferred(address(0), msgSender);
1056     }
1057  
1058     /**
1059      * @dev Returns the address of the current owner.
1060      */
1061     function owner() public view virtual returns (address) {
1062         return _owner;
1063     }
1064  
1065     /**
1066      * @dev Throws if called by any account other than the owner.
1067      */
1068     modifier onlyOwner() {
1069         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1070         _;
1071     }
1072  
1073     /**
1074      * @dev Leaves the contract without owner. It will not be possible to call
1075      * `onlyOwner` functions anymore. Can only be called by the current owner.
1076      *
1077      * NOTE: Renouncing ownership will leave the contract without an owner,
1078      * thereby removing any functionality that is only available to the owner.
1079      */
1080     function renounceOwnership() public virtual onlyOwner {
1081         emit OwnershipTransferred(_owner, address(0));
1082         _owner = address(0);
1083     }
1084  
1085     /**
1086      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1087      * Can only be called by the current owner.
1088      */
1089     function transferOwnership(address newOwner) public virtual onlyOwner {
1090         require(newOwner != address(0), "Ownable: new owner is the zero address");
1091         emit OwnershipTransferred(_owner, newOwner);
1092         _owner = newOwner;
1093     }
1094 }
1095  
1096 
1097 contract HAYC is ERC721URIStorage, Ownable {
1098 
1099     event MintHAYC (address indexed minter, uint256 startWith, uint256 times);
1100    
1101     
1102     uint256 public totalFreeHAYC;
1103     uint256 public totalPaidHAYC;
1104     uint256 public totalCount = 1500; 
1105     uint256 public maxBatch = 15; 
1106     uint256 public price = 40000000000000000; // 0.02 eth
1107     string public baseURI;
1108     bool public started;
1109     
1110     constructor(string memory name_, string memory symbol_, string memory baseURI_) ERC721(name_, symbol_) {
1111         baseURI = baseURI_;
1112     } 
1113 
1114     modifier mintEnabled() {
1115         require(started, "not started");
1116         _;
1117     }
1118  
1119     function totalFreeSupply() public view virtual returns (uint256) {
1120         return totalFreeHAYC;
1121        
1122     }
1123 
1124     function totalPaidSupply() public view virtual returns (uint256) {
1125         return totalPaidHAYC;
1126        
1127     }
1128  
1129     function _baseURI() internal view virtual override returns (string memory){
1130         return baseURI;
1131     }
1132  
1133     function setBaseURI(string memory _newURI) public onlyOwner {
1134         baseURI = _newURI;
1135     }
1136  
1137     function changePrice(uint256 _newPrice) public onlyOwner {
1138         price = _newPrice;
1139     }
1140 
1141     function getPrice() public view virtual returns (uint256) {
1142         return price;
1143     }
1144 
1145     function setTokenURI(uint256 _tokenId, string memory _tokenURI) public onlyOwner {
1146         _setTokenURI(_tokenId, _tokenURI);
1147     }
1148  
1149     function setNormalStart(bool _start) public onlyOwner {
1150         started = _start;
1151     }
1152  
1153     function mintHAYC(uint256 _times) payable public mintEnabled {
1154         require(_times >0 && _times <= maxBatch, "Incorrect number to mint");
1155         require(totalPaidHAYC + _times <= totalCount, "Too many HAYC");
1156         require(msg.value == _times * getPrice(), "Incorrect Value");
1157         payable(owner()).transfer(msg.value);
1158         emit MintHAYC(_msgSender(), totalPaidHAYC+1+1500, _times);
1159         for(uint256 i=0; i< _times; i++){
1160             _mint(_msgSender(), 1500 + 1 + totalPaidHAYC++);
1161         }
1162     }
1163 
1164 
1165     function mintFreeHAYC(uint256 _times) public mintEnabled {
1166         require(_times >0 && _times <= maxBatch, "Incorrect number to mint");
1167         require(totalFreeHAYC + _times <= totalCount, "Too many HAYC");
1168         emit MintHAYC(_msgSender(), totalFreeHAYC+1, _times);
1169         for(uint256 i=0; i< _times; i++){
1170             _mint(_msgSender(), 1 + totalFreeHAYC++);
1171         }
1172     }  
1173     
1174     function adminMint(uint256 _times) public onlyOwner {
1175         require(totalFreeHAYC + _times <= totalCount, "Too many HAYC");
1176         emit MintHAYC(_msgSender(), totalFreeHAYC+1, _times);
1177         for(uint256 i=0; i< _times; i++){
1178             _mint(_msgSender(), 1 + totalFreeHAYC++);
1179         }
1180     }
1181     
1182     
1183     function adminMintToAddress(address _addr) public onlyOwner {
1184         require(totalFreeHAYC + 1 <= totalCount, "Mint amount will exceed total collection amount.");
1185         emit MintHAYC(_addr, totalFreeHAYC+1, 1);
1186         _mint(_addr, 1 + totalFreeHAYC++);
1187     } 
1188     
1189     
1190 }