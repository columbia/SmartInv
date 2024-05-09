1 // SPDX-License-Identifier: UNLICENSED
2 pragma solidity >=0.8.0 <0.9.0;
3 
4 // ===============================================
5 //          TERMS AND CONDITIONS
6 //        https://www.anma.io/legal
7 // ===============================================
8 
9 /*
10     HIDEKI TSUKAMOTO | ANOMALOUS MATERIALS | 15.08.2021
11 ______________.___.__________  ___ _______________________ 
12 \_   ___ \__  |   |\______   \/   |   \_   _____|______   \
13 /    \  \//   |   | |     ___/    ~    \    __)_ |       _/
14 \     \___\____   | |    |   \    Y    /        \|    |   \
15  \______  / ______| |____|    \___|_  /_______  /|____|_  /
16         \/\/                        \/        \/        \/ 
17 */
18 
19 /*
20  * @dev Provides information about the current execution context, including the
21  * sender of the transaction and its data. While these are generally available
22  * via msg.sender and msg.data, they should not be accessed in such a direct
23  * manner, since when dealing with meta-transactions the account sending and
24  * paying for execution may not be the actual sender (as far as an application
25  * is concerned).
26  *
27  * This contract is only required for intermediate, library-like contracts.
28  */
29 abstract contract Context {
30     function _msgSender() internal view virtual returns (address) {
31         return msg.sender;
32     }
33 
34     function _msgData() internal view virtual returns (bytes calldata) {
35         return msg.data;
36     }
37 }
38 
39 
40 /**
41  * @dev Contract module which provides a basic access control mechanism, where
42  * there is an account (an owner) that can be granted exclusive access to
43  * specific functions.
44  *
45  * By default, the owner account will be the one that deploys the contract. This
46  * can later be changed with {transferOwnership}.
47  *
48  * This module is used through inheritance. It will make available the modifier
49  * `onlyOwner`, which can be applied to your functions to restrict their use to
50  * the owner.
51  */
52 abstract contract Ownable is Context {
53     address private _owner;
54 
55     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
56 
57     /**
58      * @dev Initializes the contract setting the deployer as the initial owner.
59      */
60     constructor() {
61         _setOwner(_msgSender());
62     }
63 
64     /**
65      * @dev Returns the address of the current owner.
66      */
67     function owner() public view virtual returns (address) {
68         return _owner;
69     }
70 
71     /**
72      * @dev Throws if called by any account other than the owner.
73      */
74     modifier onlyOwner() {
75         require(owner() == _msgSender(), "Ownable: caller is not the owner");
76         _;
77     }
78 
79     /**
80      * @dev Leaves the contract without owner. It will not be possible to call
81      * `onlyOwner` functions anymore. Can only be called by the current owner.
82      *
83      * NOTE: Renouncing ownership will leave the contract without an owner,
84      * thereby removing any functionality that is only available to the owner.
85      */
86     function renounceOwnership() public virtual onlyOwner {
87         _setOwner(address(0));
88     }
89 
90     /**
91      * @dev Transfers ownership of the contract to a new account (`newOwner`).
92      * Can only be called by the current owner.
93      */
94     function transferOwnership(address newOwner) public virtual onlyOwner {
95         require(newOwner != address(0), "Ownable: new owner is the zero address");
96         _setOwner(newOwner);
97     }
98 
99     function _setOwner(address newOwner) private {
100         address oldOwner = _owner;
101         _owner = newOwner;
102         emit OwnershipTransferred(oldOwner, newOwner);
103     }
104 }
105 
106 /**
107  * @dev Interface of the ERC165 standard, as defined in the
108  * https://eips.ethereum.org/EIPS/eip-165[EIP].
109  *
110  * Implementers can declare support of contract interfaces, which can then be
111  * queried by others ({ERC165Checker}).
112  *
113  * For an implementation, see {ERC165}.
114  */
115 interface IERC165 {
116     /**
117      * @dev Returns true if this contract implements the interface defined by
118      * `interfaceId`. See the corresponding
119      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
120      * to learn more about how these ids are created.
121      *
122      * This function call must use less than 30 000 gas.
123      */
124     function supportsInterface(bytes4 interfaceId) external view returns (bool);
125 }
126 
127 
128 /**
129  * @dev Required interface of an ERC721 compliant contract.
130  */
131 interface IERC721 is IERC165 {
132     /**
133      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
134      */
135     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
136 
137     /**
138      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
139      */
140     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
141 
142     /**
143      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
144      */
145     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
146 
147     /**
148      * @dev Returns the number of tokens in ``owner``'s account.
149      */
150     function balanceOf(address owner) external view returns (uint256 balance);
151 
152     /**
153      * @dev Returns the owner of the `tokenId` token.
154      *
155      * Requirements:
156      *
157      * - `tokenId` must exist.
158      */
159     function ownerOf(uint256 tokenId) external view returns (address owner);
160 
161     /**
162      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
163      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
164      *
165      * Requirements:
166      *
167      * - `from` cannot be the zero address.
168      * - `to` cannot be the zero address.
169      * - `tokenId` token must exist and be owned by `from`.
170      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
171      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
172      *
173      * Emits a {Transfer} event.
174      */
175     function safeTransferFrom(
176         address from,
177         address to,
178         uint256 tokenId
179     ) external;
180 
181     /**
182      * @dev Transfers `tokenId` token from `from` to `to`.
183      *
184      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
185      *
186      * Requirements:
187      *
188      * - `from` cannot be the zero address.
189      * - `to` cannot be the zero address.
190      * - `tokenId` token must be owned by `from`.
191      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
192      *
193      * Emits a {Transfer} event.
194      */
195     function transferFrom(
196         address from,
197         address to,
198         uint256 tokenId
199     ) external;
200 
201     /**
202      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
203      * The approval is cleared when the token is transferred.
204      *
205      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
206      *
207      * Requirements:
208      *
209      * - The caller must own the token or be an approved operator.
210      * - `tokenId` must exist.
211      *
212      * Emits an {Approval} event.
213      */
214     function approve(address to, uint256 tokenId) external;
215 
216     /**
217      * @dev Returns the account approved for `tokenId` token.
218      *
219      * Requirements:
220      *
221      * - `tokenId` must exist.
222      */
223     function getApproved(uint256 tokenId) external view returns (address operator);
224 
225     /**
226      * @dev Approve or remove `operator` as an operator for the caller.
227      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
228      *
229      * Requirements:
230      *
231      * - The `operator` cannot be the caller.
232      *
233      * Emits an {ApprovalForAll} event.
234      */
235     function setApprovalForAll(address operator, bool _approved) external;
236 
237     /**
238      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
239      *
240      * See {setApprovalForAll}
241      */
242     function isApprovedForAll(address owner, address operator) external view returns (bool);
243 
244     /**
245      * @dev Safely transfers `tokenId` token from `from` to `to`.
246      *
247      * Requirements:
248      *
249      * - `from` cannot be the zero address.
250      * - `to` cannot be the zero address.
251      * - `tokenId` token must exist and be owned by `from`.
252      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
253      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
254      *
255      * Emits a {Transfer} event.
256      */
257     function safeTransferFrom(
258         address from,
259         address to,
260         uint256 tokenId,
261         bytes calldata data
262     ) external;
263 }
264 
265 /**
266  * @dev Implementation of the {IERC165} interface.
267  *
268  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
269  * for the additional interface id that will be supported. For example:
270  *
271  * ```solidity
272  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
273  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
274  * }
275  * ```
276  *
277  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
278  */
279 abstract contract ERC165 is IERC165 {
280     /**
281      * @dev See {IERC165-supportsInterface}.
282      */
283     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
284         return interfaceId == type(IERC165).interfaceId;
285     }
286 }
287 
288 /**
289  * @title ERC721 token receiver interface
290  * @dev Interface for any contract that wants to support safeTransfers
291  * from ERC721 asset contracts.
292  */
293 interface IERC721Receiver {
294     /**
295      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
296      * by `operator` from `from`, this function is called.
297      *
298      * It must return its Solidity selector to confirm the token transfer.
299      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
300      *
301      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
302      */
303     function onERC721Received(
304         address operator,
305         address from,
306         uint256 tokenId,
307         bytes calldata data
308     ) external returns (bytes4);
309 }
310 
311 /**
312  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
313  * @dev See https://eips.ethereum.org/EIPS/eip-721
314  */
315 interface IERC721Metadata is IERC721 {
316     /**
317      * @dev Returns the token collection name.
318      */
319     function name() external view returns (string memory);
320 
321     /**
322      * @dev Returns the token collection symbol.
323      */
324     function symbol() external view returns (string memory);
325 
326     /**
327      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
328      */
329     function tokenURI(uint256 tokenId) external view returns (string memory);
330 }
331 /**
332  * @dev Collection of functions related to the address type
333  */
334 library Address {
335     /**
336      * @dev Returns true if `account` is a contract.
337      *
338      * [IMPORTANT]
339      * ====
340      * It is unsafe to assume that an address for which this function returns
341      * false is an externally-owned account (EOA) and not a contract.
342      *
343      * Among others, `isContract` will return false for the following
344      * types of addresses:
345      *
346      *  - an externally-owned account
347      *  - a contract in construction
348      *  - an address where a contract will be created
349      *  - an address where a contract lived, but was destroyed
350      * ====
351      */
352     function isContract(address account) internal view returns (bool) {
353         // This method relies on extcodesize, which returns 0 for contracts in
354         // construction, since the code is only stored at the end of the
355         // constructor execution.
356 
357         uint256 size;
358         assembly {
359             size := extcodesize(account)
360         }
361         return size > 0;
362     }
363 
364     /**
365      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
366      * `recipient`, forwarding all available gas and reverting on errors.
367      *
368      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
369      * of certain opcodes, possibly making contracts go over the 2300 gas limit
370      * imposed by `transfer`, making them unable to receive funds via
371      * `transfer`. {sendValue} removes this limitation.
372      *
373      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
374      *
375      * IMPORTANT: because control is transferred to `recipient`, care must be
376      * taken to not create reentrancy vulnerabilities. Consider using
377      * {ReentrancyGuard} or the
378      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
379      */
380     function sendValue(address payable recipient, uint256 amount) internal {
381         require(address(this).balance >= amount, "Address: insufficient balance");
382 
383         (bool success, ) = recipient.call{value: amount}("");
384         require(success, "Address: unable to send value, recipient may have reverted");
385     }
386 
387     /**
388      * @dev Performs a Solidity function call using a low level `call`. A
389      * plain `call` is an unsafe replacement for a function call: use this
390      * function instead.
391      *
392      * If `target` reverts with a revert reason, it is bubbled up by this
393      * function (like regular Solidity function calls).
394      *
395      * Returns the raw returned data. To convert to the expected return value,
396      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
397      *
398      * Requirements:
399      *
400      * - `target` must be a contract.
401      * - calling `target` with `data` must not revert.
402      *
403      * _Available since v3.1._
404      */
405     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
406         return functionCall(target, data, "Address: low-level call failed");
407     }
408 
409     /**
410      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
411      * `errorMessage` as a fallback revert reason when `target` reverts.
412      *
413      * _Available since v3.1._
414      */
415     function functionCall(
416         address target,
417         bytes memory data,
418         string memory errorMessage
419     ) internal returns (bytes memory) {
420         return functionCallWithValue(target, data, 0, errorMessage);
421     }
422 
423     /**
424      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
425      * but also transferring `value` wei to `target`.
426      *
427      * Requirements:
428      *
429      * - the calling contract must have an ETH balance of at least `value`.
430      * - the called Solidity function must be `payable`.
431      *
432      * _Available since v3.1._
433      */
434     function functionCallWithValue(
435         address target,
436         bytes memory data,
437         uint256 value
438     ) internal returns (bytes memory) {
439         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
440     }
441 
442     /**
443      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
444      * with `errorMessage` as a fallback revert reason when `target` reverts.
445      *
446      * _Available since v3.1._
447      */
448     function functionCallWithValue(
449         address target,
450         bytes memory data,
451         uint256 value,
452         string memory errorMessage
453     ) internal returns (bytes memory) {
454         require(address(this).balance >= value, "Address: insufficient balance for call");
455         require(isContract(target), "Address: call to non-contract");
456 
457         (bool success, bytes memory returndata) = target.call{value: value}(data);
458         return _verifyCallResult(success, returndata, errorMessage);
459     }
460 
461     /**
462      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
463      * but performing a static call.
464      *
465      * _Available since v3.3._
466      */
467     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
468         return functionStaticCall(target, data, "Address: low-level static call failed");
469     }
470 
471     /**
472      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
473      * but performing a static call.
474      *
475      * _Available since v3.3._
476      */
477     function functionStaticCall(
478         address target,
479         bytes memory data,
480         string memory errorMessage
481     ) internal view returns (bytes memory) {
482         require(isContract(target), "Address: static call to non-contract");
483 
484         (bool success, bytes memory returndata) = target.staticcall(data);
485         return _verifyCallResult(success, returndata, errorMessage);
486     }
487 
488     /**
489      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
490      * but performing a delegate call.
491      *
492      * _Available since v3.4._
493      */
494     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
495         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
496     }
497 
498     /**
499      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
500      * but performing a delegate call.
501      *
502      * _Available since v3.4._
503      */
504     function functionDelegateCall(
505         address target,
506         bytes memory data,
507         string memory errorMessage
508     ) internal returns (bytes memory) {
509         require(isContract(target), "Address: delegate call to non-contract");
510 
511         (bool success, bytes memory returndata) = target.delegatecall(data);
512         return _verifyCallResult(success, returndata, errorMessage);
513     }
514 
515     function _verifyCallResult(
516         bool success,
517         bytes memory returndata,
518         string memory errorMessage
519     ) private pure returns (bytes memory) {
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
538 
539 /**
540  * @dev String operations.
541  */
542 library Strings {
543     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
544 
545     /**
546      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
547      */
548     function toString(uint256 value) internal pure returns (string memory) {
549         // Inspired by OraclizeAPI's implementation - MIT licence
550         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
551 
552         if (value == 0) {
553             return "0";
554         }
555         uint256 temp = value;
556         uint256 digits;
557         while (temp != 0) {
558             digits++;
559             temp /= 10;
560         }
561         bytes memory buffer = new bytes(digits);
562         while (value != 0) {
563             digits -= 1;
564             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
565             value /= 10;
566         }
567         return string(buffer);
568     }
569 
570     /**
571      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
572      */
573     function toHexString(uint256 value) internal pure returns (string memory) {
574         if (value == 0) {
575             return "0x00";
576         }
577         uint256 temp = value;
578         uint256 length = 0;
579         while (temp != 0) {
580             length++;
581             temp >>= 8;
582         }
583         return toHexString(value, length);
584     }
585 
586     /**
587      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
588      */
589     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
590         bytes memory buffer = new bytes(2 * length + 2);
591         buffer[0] = "0";
592         buffer[1] = "x";
593         for (uint256 i = 2 * length + 1; i > 1; --i) {
594             buffer[i] = _HEX_SYMBOLS[value & 0xf];
595             value >>= 4;
596         }
597         require(value == 0, "Strings: hex length insufficient");
598         return string(buffer);
599     }
600 }
601 
602 
603 
604 /**
605  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
606  * the Metadata extension, but not including the Enumerable extension, which is available separately as
607  * {ERC721Enumerable}.
608  */
609 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
610     using Address for address;
611     using Strings for uint256;
612 
613     // Token name
614     string private _name;
615 
616     // Token symbol
617     string private _symbol;
618 
619     // Mapping from token ID to owner address
620     mapping(uint256 => address) private _owners;
621 
622     // Mapping owner address to token count
623     mapping(address => uint256) private _balances;
624 
625     // Mapping from token ID to approved address
626     mapping(uint256 => address) private _tokenApprovals;
627 
628     // Mapping from owner to operator approvals
629     mapping(address => mapping(address => bool)) private _operatorApprovals;
630 
631     /**
632      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
633      */
634     constructor(string memory name_, string memory symbol_) {
635         _name = name_;
636         _symbol = symbol_;
637     }
638 
639     /**
640      * @dev See {IERC165-supportsInterface}.
641      */
642     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
643         return
644             interfaceId == type(IERC721).interfaceId ||
645             interfaceId == type(IERC721Metadata).interfaceId ||
646             super.supportsInterface(interfaceId);
647     }
648 
649     /**
650      * @dev See {IERC721-balanceOf}.
651      */
652     function balanceOf(address owner) public view virtual override returns (uint256) {
653         require(owner != address(0), "ERC721: balance query for the zero address");
654         return _balances[owner];
655     }
656 
657     /**
658      * @dev See {IERC721-ownerOf}.
659      */
660     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
661         address owner = _owners[tokenId];
662         require(owner != address(0), "ERC721: owner query for nonexistent token");
663         return owner;
664     }
665 
666     /**
667      * @dev See {IERC721Metadata-name}.
668      */
669     function name() public view virtual override returns (string memory) {
670         return _name;
671     }
672 
673     /**
674      * @dev See {IERC721Metadata-symbol}.
675      */
676     function symbol() public view virtual override returns (string memory) {
677         return _symbol;
678     }
679 
680     /**
681      * @dev See {IERC721Metadata-tokenURI}.
682      */
683     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
684         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
685 
686         string memory baseURI = _baseURI();
687         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
688     }
689 
690     /**
691      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
692      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
693      * by default, can be overriden in child contracts.
694      */
695     function _baseURI() internal view virtual returns (string memory) {
696         return "";
697     }
698 
699     /**
700      * @dev See {IERC721-approve}.
701      */
702     function approve(address to, uint256 tokenId) public virtual override {
703         address owner = ERC721.ownerOf(tokenId);
704         require(to != owner, "ERC721: approval to current owner");
705 
706         require(
707             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
708             "ERC721: approve caller is not owner nor approved for all"
709         );
710 
711         _approve(to, tokenId);
712     }
713 
714     /**
715      * @dev See {IERC721-getApproved}.
716      */
717     function getApproved(uint256 tokenId) public view virtual override returns (address) {
718         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
719 
720         return _tokenApprovals[tokenId];
721     }
722 
723     /**
724      * @dev See {IERC721-setApprovalForAll}.
725      */
726     function setApprovalForAll(address operator, bool approved) public virtual override {
727         require(operator != _msgSender(), "ERC721: approve to caller");
728 
729         _operatorApprovals[_msgSender()][operator] = approved;
730         emit ApprovalForAll(_msgSender(), operator, approved);
731     }
732 
733     /**
734      * @dev See {IERC721-isApprovedForAll}.
735      */
736     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
737         return _operatorApprovals[owner][operator];
738     }
739 
740     /**
741      * @dev See {IERC721-transferFrom}.
742      */
743     function transferFrom(
744         address from,
745         address to,
746         uint256 tokenId
747     ) public virtual override {
748         //solhint-disable-next-line max-line-length
749         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
750 
751         _transfer(from, to, tokenId);
752     }
753 
754     /**
755      * @dev See {IERC721-safeTransferFrom}.
756      */
757     function safeTransferFrom(
758         address from,
759         address to,
760         uint256 tokenId
761     ) public virtual override {
762         safeTransferFrom(from, to, tokenId, "");
763     }
764 
765     /**
766      * @dev See {IERC721-safeTransferFrom}.
767      */
768     function safeTransferFrom(
769         address from,
770         address to,
771         uint256 tokenId,
772         bytes memory _data
773     ) public virtual override {
774         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
775         _safeTransfer(from, to, tokenId, _data);
776     }
777 
778     /**
779      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
780      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
781      *
782      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
783      *
784      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
785      * implement alternative mechanisms to perform token transfer, such as signature-based.
786      *
787      * Requirements:
788      *
789      * - `from` cannot be the zero address.
790      * - `to` cannot be the zero address.
791      * - `tokenId` token must exist and be owned by `from`.
792      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
793      *
794      * Emits a {Transfer} event.
795      */
796     function _safeTransfer(
797         address from,
798         address to,
799         uint256 tokenId,
800         bytes memory _data
801     ) internal virtual {
802         _transfer(from, to, tokenId);
803         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
804     }
805 
806     /**
807      * @dev Returns whether `tokenId` exists.
808      *
809      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
810      *
811      * Tokens start existing when they are minted (`_mint`),
812      * and stop existing when they are burned (`_burn`).
813      */
814     function _exists(uint256 tokenId) internal view virtual returns (bool) {
815         return _owners[tokenId] != address(0);
816     }
817 
818     /**
819      * @dev Returns whether `spender` is allowed to manage `tokenId`.
820      *
821      * Requirements:
822      *
823      * - `tokenId` must exist.
824      */
825     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
826         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
827         address owner = ERC721.ownerOf(tokenId);
828         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
829     }
830 
831     /**
832      * @dev Safely mints `tokenId` and transfers it to `to`.
833      *
834      * Requirements:
835      *
836      * - `tokenId` must not exist.
837      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
838      *
839      * Emits a {Transfer} event.
840      */
841     function _safeMint(address to, uint256 tokenId) internal virtual {
842         _safeMint(to, tokenId, "");
843     }
844 
845     /**
846      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
847      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
848      */
849     function _safeMint(
850         address to,
851         uint256 tokenId,
852         bytes memory _data
853     ) internal virtual {
854         _mint(to, tokenId);
855         require(
856             _checkOnERC721Received(address(0), to, tokenId, _data),
857             "ERC721: transfer to non ERC721Receiver implementer"
858         );
859     }
860 
861     /**
862      * @dev Mints `tokenId` and transfers it to `to`.
863      *
864      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
865      *
866      * Requirements:
867      *
868      * - `tokenId` must not exist.
869      * - `to` cannot be the zero address.
870      *
871      * Emits a {Transfer} event.
872      */
873     function _mint(address to, uint256 tokenId) internal virtual {
874         require(to != address(0), "ERC721: mint to the zero address");
875         require(!_exists(tokenId), "ERC721: token already minted");
876 
877         _beforeTokenTransfer(address(0), to, tokenId);
878 
879         _balances[to] += 1;
880         _owners[tokenId] = to;
881 
882         emit Transfer(address(0), to, tokenId);
883     }
884 
885     /**
886      * @dev Destroys `tokenId`.
887      * The approval is cleared when the token is burned.
888      *
889      * Requirements:
890      *
891      * - `tokenId` must exist.
892      *
893      * Emits a {Transfer} event.
894      */
895     function _burn(uint256 tokenId) internal virtual {
896         address owner = ERC721.ownerOf(tokenId);
897 
898         _beforeTokenTransfer(owner, address(0), tokenId);
899 
900         // Clear approvals
901         _approve(address(0), tokenId);
902 
903         _balances[owner] -= 1;
904         delete _owners[tokenId];
905 
906         emit Transfer(owner, address(0), tokenId);
907     }
908 
909     /**
910      * @dev Transfers `tokenId` from `from` to `to`.
911      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
912      *
913      * Requirements:
914      *
915      * - `to` cannot be the zero address.
916      * - `tokenId` token must be owned by `from`.
917      *
918      * Emits a {Transfer} event.
919      */
920     function _transfer(
921         address from,
922         address to,
923         uint256 tokenId
924     ) internal virtual {
925         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
926         require(to != address(0), "ERC721: transfer to the zero address");
927 
928         _beforeTokenTransfer(from, to, tokenId);
929 
930         // Clear approvals from the previous owner
931         _approve(address(0), tokenId);
932 
933         _balances[from] -= 1;
934         _balances[to] += 1;
935         _owners[tokenId] = to;
936 
937         emit Transfer(from, to, tokenId);
938     }
939 
940     /**
941      * @dev Approve `to` to operate on `tokenId`
942      *
943      * Emits a {Approval} event.
944      */
945     function _approve(address to, uint256 tokenId) internal virtual {
946         _tokenApprovals[tokenId] = to;
947         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
948     }
949 
950     /**
951      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
952      * The call is not executed if the target address is not a contract.
953      *
954      * @param from address representing the previous owner of the given token ID
955      * @param to target address that will receive the tokens
956      * @param tokenId uint256 ID of the token to be transferred
957      * @param _data bytes optional data to send along with the call
958      * @return bool whether the call correctly returned the expected magic value
959      */
960     function _checkOnERC721Received(
961         address from,
962         address to,
963         uint256 tokenId,
964         bytes memory _data
965     ) private returns (bool) {
966         if (to.isContract()) {
967             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
968                 return retval == IERC721Receiver(to).onERC721Received.selector;
969             } catch (bytes memory reason) {
970                 if (reason.length == 0) {
971                     revert("ERC721: transfer to non ERC721Receiver implementer");
972                 } else {
973                     assembly {
974                         revert(add(32, reason), mload(reason))
975                     }
976                 }
977             }
978         } else {
979             return true;
980         }
981     }
982 
983     /**
984      * @dev Hook that is called before any token transfer. This includes minting
985      * and burning.
986      *
987      * Calling conditions:
988      *
989      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
990      * transferred to `to`.
991      * - When `from` is zero, `tokenId` will be minted for `to`.
992      * - When `to` is zero, ``from``'s `tokenId` will be burned.
993      * - `from` and `to` are never both zero.
994      *
995      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
996      */
997     function _beforeTokenTransfer(
998         address from,
999         address to,
1000         uint256 tokenId
1001     ) internal virtual {}
1002 }
1003 
1004 /**
1005  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1006  * @dev See https://eips.ethereum.org/EIPS/eip-721
1007  */
1008 interface IERC721Enumerable is IERC721 {
1009     /**
1010      * @dev Returns the total amount of tokens stored by the contract.
1011      */
1012     function totalSupply() external view returns (uint256);
1013 
1014     /**
1015      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1016      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1017      */
1018     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1019 
1020     /**
1021      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1022      * Use along with {totalSupply} to enumerate all tokens.
1023      */
1024     function tokenByIndex(uint256 index) external view returns (uint256);
1025 }
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
1184 struct CypherAttributes
1185 {
1186     uint colorset;
1187     int decay;
1188     int chaos;
1189     int utilRand;
1190     int numChannels;
1191     int[8] density;
1192     int[8] intricacy;
1193 }
1194 
1195 
1196 struct StringBuilder
1197 {
1198     bytes data;
1199 }
1200 
1201 library SB
1202 {
1203     function create(uint256 capacity)
1204         internal pure returns(StringBuilder memory)
1205     {
1206         return StringBuilder(new bytes(capacity + 32));
1207     }
1208 
1209     function resize(StringBuilder memory sb, uint256 newCapacity) 
1210         internal view
1211     {
1212         StringBuilder memory newSb = create(newCapacity);
1213         
1214         assembly 
1215         {
1216             let data := mload(sb)
1217             let newData := mload(newSb)
1218             let size := mload(add(data, 32)) // get used byte count
1219             let bytesToCopy := add(size, 32) // copy the used bytes, plus the size field in first 32 bytes
1220             
1221             pop(staticcall(
1222                 gas(), 
1223                 0x4, 
1224                 add(data, 32), 
1225                 bytesToCopy, 
1226                 add(newData, 32), 
1227                 bytesToCopy))
1228         }
1229         
1230         sb.data = newSb.data;
1231     }
1232 
1233     function resizeIfNeeded(StringBuilder memory sb, uint256 spaceNeeded) 
1234         internal view
1235     {
1236         uint capacity;
1237         uint size;
1238         assembly
1239         {
1240             let data := mload(sb)
1241             capacity := sub(mload(data), 32)
1242             size := mload(add(data, 32))
1243         }
1244 
1245         uint remaining = capacity - size;
1246         if (remaining >= spaceNeeded)
1247         {
1248             return;
1249         }
1250 
1251         uint newCapacity = capacity << 1;
1252         uint newRemaining = newCapacity - size;
1253         if (newRemaining >= spaceNeeded)
1254         {
1255             resize(sb, newCapacity);
1256         }
1257         else
1258         {
1259             newCapacity = spaceNeeded + size;
1260             resize(sb, newCapacity);
1261         }
1262     }
1263     
1264     function getString(StringBuilder memory sb) 
1265         internal pure returns(string memory) 
1266     {
1267         string memory ret;
1268         assembly 
1269         {
1270             let data := mload(sb)
1271             ret := add(data, 32)
1272         }
1273         return ret;
1274     }
1275 
1276     function writeStr(StringBuilder memory sb, string memory str) 
1277         internal view
1278     {
1279         resizeIfNeeded(sb, bytes(str).length);
1280 
1281         assembly 
1282         {
1283             let data := mload(sb)
1284             let size := mload(add(data, 32))
1285             pop(staticcall(gas(), 0x4, add(str, 32), mload(str), add(size, add(data, 64)), mload(str)))
1286             mstore(add(data, 32), add(size, mload(str)))
1287         }
1288     }
1289 
1290     function concat(StringBuilder memory dst, StringBuilder memory src) 
1291         internal view
1292     {
1293         string memory asString;
1294         assembly
1295         {
1296             let srcData := mload(src)
1297             asString := add(srcData, 32)
1298         }
1299 
1300         writeStr(dst, asString);
1301     }
1302 
1303     function writeUint(StringBuilder memory sb, uint u) 
1304         internal view
1305     {
1306         if (u > 0)
1307         {
1308             uint len;
1309             uint size;
1310             
1311             assembly
1312             {
1313                 // get length string will be
1314                 len := 0
1315                 
1316                 for {let val := u} gt(val, 0) {val := div(val,  10) len := add(len, 1)}
1317                 {
1318                 }
1319 
1320                 // get bytes currently used
1321                 let data := mload(sb)
1322                 size := mload(add(data, 32))
1323             }
1324             
1325             // make sure there's room
1326             resizeIfNeeded(sb, len);
1327             
1328             assembly
1329             {
1330                 let data := mload(sb)
1331 
1332                 for {let i := 0 let val := u} lt(i, len) {i := add(i, 1) val := div(val, 10)}
1333                 {
1334                     // sb.data[64 + size + (len - i - 1)] = (val % 10) + 48
1335                     mstore8(add(data, add(63, add(size, sub(len, i)))), add(mod(val, 10), 48))
1336                 }
1337             
1338                 size := add(size, len)
1339             
1340                 mstore(add(data, 32), size)
1341             }
1342         }
1343         else
1344         {
1345             uint size;
1346             assembly
1347             {
1348                 let data := mload(sb)
1349                 size := mload(add(data, 32))
1350             }
1351             // make sure there's room
1352             resizeIfNeeded(sb, 1);
1353             
1354             assembly
1355             {
1356                 let data := mload(sb)
1357                 mstore(add(data, 32), add(size, 1))
1358                 mstore8(add(data, add(64, size)), 48)
1359             }
1360         }
1361     }
1362     
1363     function writeInt(StringBuilder memory sb, int i) 
1364         internal view
1365     {
1366         if (i < 0)
1367         {
1368             // write the - sign
1369             uint size;
1370             assembly
1371             {
1372                 let data := mload(sb)
1373                 size := mload(add(data, 32))
1374             }
1375             resizeIfNeeded(sb, 1);
1376             
1377             assembly
1378             {
1379                 let data := mload(sb)
1380                 mstore(add(data, 32), add(size, 1))
1381                 mstore8(add(data, add(64, size)), 45)
1382             }
1383 
1384             // now the digits can be written as a uint
1385             i *= -1;
1386         }
1387         writeUint(sb, uint(i));
1388     }
1389 
1390     function writeRgb(StringBuilder memory sb, uint256 col) 
1391         internal view
1392     {
1393         resizeIfNeeded(sb, 6);
1394 
1395         string[16] memory nibbles = [
1396             "0", "1", "2", "3", "4", "5", "6", "7", 
1397             "8", "9", "a", "b", "c", "d", "e", "f"];
1398 
1399         string memory asStr = string(abi.encodePacked(
1400             nibbles[(col >> 20) & 0xf],
1401             nibbles[(col >> 16) & 0xf],
1402             nibbles[(col >> 12) & 0xf],
1403             nibbles[(col >> 8) & 0xf],
1404             nibbles[(col >> 4) & 0xf],
1405             nibbles[col & 0xf]
1406         ));
1407 
1408         writeStr(sb, asStr);
1409     }
1410 }
1411 
1412 
1413 struct Rand
1414 {
1415     uint256 value;
1416 }
1417 
1418 library Random
1419 {
1420     function create(uint256 srand) 
1421         internal pure returns(Rand memory) 
1422     {
1423         Rand memory rand = Rand({value: srand});
1424         return rand;
1425     }
1426     
1427     function value(Rand memory rand) 
1428         internal pure returns(uint256) 
1429     {
1430         rand.value = uint256(keccak256(abi.encodePacked(rand.value)));
1431         return rand.value;
1432     }
1433     
1434     // (max inclusive)
1435     function range(Rand memory rand, int256 min, int256 max) 
1436         internal pure returns(int256) 
1437     {
1438         if (min <= max)
1439         {
1440             uint256 span = uint256(max - min);
1441 
1442             return int256(value(rand) % (span + 1)) + min;
1443         }
1444         else
1445         {
1446             return range(rand, max, min);
1447         }
1448     }
1449 }
1450 
1451 contract CypherDrawing is Ownable
1452 {   
1453     int constant FONT_SIZE = 4;
1454 
1455     uint8[1024] private curve;
1456     int8[1024] private noiseTable;
1457     uint24[256][5] private gradients;
1458 
1459     function setCurve(uint8[1024] memory newCurve) 
1460         public onlyOwner
1461     {
1462         curve = newCurve;
1463     }
1464 
1465     function setNoiseTable(int8[1024] memory newNoiseTable) 
1466         public onlyOwner
1467     {
1468         noiseTable = newNoiseTable;
1469     }
1470 
1471     function setGradients(uint24[256][5] memory newGradients)
1472         public onlyOwner
1473     {
1474         gradients = newGradients;
1475     }
1476 
1477     function getAttributes(bytes32 hash)
1478         public view returns (CypherAttributes memory)
1479     {
1480         Rand memory rand = Random.create(uint256(hash));
1481         CypherAttributes memory attributes = createAttributes(rand);
1482         return attributes;
1483     }
1484 
1485     function generate(bytes32 hash) 
1486         public view returns(string memory)
1487     {
1488         StringBuilder memory b = SB.create(128 * 1024);
1489 
1490         SB.writeStr(b, "<svg viewBox='0 0 640 640' xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink'>"
1491             
1492             "<style>"
1493             "text{"
1494                 "font-size:");
1495         SB.writeInt(b, FONT_SIZE);
1496         SB.writeStr(b, "px;"
1497                 "font-family: monospace;"
1498                 "fill: #cccccc;"
1499             "}"
1500             "</style>"
1501 
1502             "<defs>"
1503                 "<filter id='glow'>"
1504                     "<feGaussianBlur stdDeviation='3.0' result='coloredBlur'/>"
1505                     "<feComponentTransfer in='coloredBlur' result='coloredBlur'>"
1506                         "<feFuncA type='linear' slope='0.70'/>"
1507                     "</feComponentTransfer>"
1508                     "<feMerge>"
1509                         "<feMergeNode in='coloredBlur'/>"
1510                         "<feMergeNode in='SourceGraphic'/>"
1511                     "</feMerge>"
1512                 "</filter>"
1513             "</defs>"
1514 
1515             "<rect width='640' height='640' fill='#090809'/>"              
1516             
1517             "<g id='cypher' shape-rendering='geometricPrecision' filter='url(#glow)'>");
1518         
1519         Rand memory rand = Random.create(uint256(hash));
1520         CypherAttributes memory attributes = createAttributes(rand);
1521         draw(b, attributes, rand);
1522             
1523         SB.writeStr(b, "</g>"
1524             
1525             "</svg>");
1526 
1527         return SB.getString(b);
1528     }
1529 
1530     struct Ring
1531     {
1532         uint id;
1533         int arcs;
1534         int span;
1535         int inner;
1536         int outer;
1537     }
1538 
1539     struct SegmentData
1540     {
1541         uint ringId;
1542         uint segId;
1543         int inner;
1544         int outer;
1545         int thick;
1546         int start;
1547         int fin;
1548         EdgeType edge;
1549         FillType fill;
1550         SpanType innerSpanType;
1551         PadType padInner;
1552         SpanType outerSpanType;
1553         PadType padOuter;
1554         uint colour;
1555     }
1556 
1557     enum SpanType
1558     {
1559         None,
1560         Arc,
1561         Cap,
1562         Ang,
1563         Brk,
1564         Dotted
1565     }
1566 
1567     enum Variant
1568     {
1569         None,
1570         Inner,
1571         Outer,
1572         Double,
1573         Max
1574     }
1575 
1576     enum EdgeType
1577     {
1578         None,
1579         Simple
1580     }
1581 
1582     enum FillType
1583     {
1584         None,
1585         Block,
1586         Hollow,
1587         Text,
1588         Increment, 
1589         Comp
1590     }
1591 
1592     enum PadType
1593     {
1594         None,
1595         Single
1596     }
1597 
1598     
1599     function clamp(int num)
1600         private pure returns(int)
1601     {
1602         return clamp(num, 0, 31);
1603     }
1604     
1605     function clamp(int num, int min, int max)
1606         private pure returns(int)
1607     {
1608         return num <= min ? min : num >= max ? max : num;
1609     }
1610 
1611     function noise(Rand memory rand) 
1612         private view returns(int)
1613     {
1614         return noiseTable[uint(Random.range(rand, 0, 1023))];
1615     }
1616 
1617     function createAttributes(Rand memory rand) 
1618         private view returns(CypherAttributes memory)
1619     {
1620         int weighted = int8(curve[uint(Random.range(rand, 0, 1023))]);
1621         
1622         CypherAttributes memory attributes;
1623         attributes.colorset = (uint(weighted < int(8) ? int(8) : weighted) - 8)/6;
1624         attributes.decay = 32 - clamp(weighted + noise(rand));
1625         attributes.chaos = 32 - clamp(weighted + noise(rand));
1626         attributes.utilRand = Random.range(rand, 0, 1023);
1627         attributes.numChannels = 4 + (clamp(weighted + noise(rand), 0, 32) >> 3);
1628         
1629         int count = 0;
1630         while(true)
1631         {
1632             uint idx = uint(Random.range(rand, 0, 7));
1633 
1634             if(count == attributes.numChannels)
1635             { 
1636                 break;
1637             }
1638             else if(attributes.density[idx]==1)
1639             {
1640                 continue;
1641             } 
1642             else 
1643             {
1644                 attributes.density[idx]=1;
1645                 count++;
1646             }
1647         }
1648 
1649         for (uint i = 0; i < 8; ++i)
1650         {
1651             attributes.intricacy[i] = clamp(weighted + noise(rand));
1652         }
1653 
1654         return attributes;
1655     }
1656 
1657     function getSegmentColour(
1658         CypherAttributes memory atr, 
1659         Ring memory ring, 
1660         Rand memory rand) 
1661         private view returns(uint24)
1662     {
1663         int array_offset    = atr.utilRand % 256;
1664         int grad_noise      = Random.range(rand, 0, 30);
1665         int colour_index    = (array_offset + ring.inner + grad_noise) % 256;
1666         return gradients[atr.colorset][uint(colour_index)];
1667     }
1668 
1669     function draw(
1670         StringBuilder memory b, 
1671         CypherAttributes memory atr, 
1672         Rand memory rand) 
1673         private view
1674     {
1675         Ring[16] memory rings = createRings(rand);
1676 
1677         // frame
1678         for(uint i=0; i<16; ++i)
1679         {
1680             SB.writeStr(b, "<circle cx='320' cy='320' fill='none' stroke-width='0.1' stroke-opacity='15%' stroke='#");
1681             SB.writeRgb(b, gradients[atr.colorset][uint(rings[i].inner)-1]);
1682             SB.writeStr(b, "' r='");
1683             SB.writeInt(b, rings[i].inner);
1684             SB.writeStr(b, "'/>");
1685         }
1686 
1687         // defs & ring
1688         // defs added as we go, ring must be deferred
1689         SB.writeStr(b, "<defs>");
1690         StringBuilder memory ringSvg = SB.create(4096);
1691         for(uint i=0; i<16; i++)
1692         {
1693             uint channelIndex = (i >> 1);
1694             if(atr.density[channelIndex] == 0) continue;
1695 
1696             int span = rings[i].span;
1697 
1698             uint segs = 8 >> uint(Random.range(rand, 1, 2));
1699 
1700             int[] memory sections = new int[](segs);
1701             
1702             for(uint g=0; g<segs; g++)
1703             {
1704                 sections[g] = 1;
1705             }
1706 
1707             {
1708                 int increments = int(span)-int(segs);
1709                 for(int s=0; s<increments; s++)
1710                 {  
1711                     sections[uint(Random.range(rand, 0, int(segs) - 1))]++;
1712                 }
1713             }
1714 
1715             int progress = int(span);
1716 
1717             // template
1718             SB.writeStr(b, "<g id='variant_r");
1719             SB.writeUint(b, rings[i].id);
1720             SB.writeStr(b, "_v0'>");
1721             for(uint t=0; t<segs; t++)
1722             {
1723                 progress -= int(sections[t]); // TODO make sure everything with subtractions happens with ints
1724 
1725                 SegmentData memory segmentData;
1726                 segmentData.ringId = i;
1727                 segmentData.segId = t;
1728                 segmentData.inner = rings[i].inner;
1729                 segmentData.outer = rings[i].outer;
1730                 segmentData.thick = rings[i].outer - int(rings[i].inner);
1731                 segmentData.start = progress * 5;
1732                 segmentData.fin = sections[t] * 5;
1733                 segmentData.edge = EdgeType(rings[i].inner % 2);
1734                 {
1735                     int maxIntricacy = atr.intricacy[channelIndex] >> 3;
1736                     segmentData.fill = FillType(Random.range(rand, 2, 2+maxIntricacy));
1737                     segmentData.innerSpanType = SpanType(Random.range(rand, 2, 2+maxIntricacy));
1738                     segmentData.outerSpanType = SpanType(Random.range(rand, 2, 2+maxIntricacy));
1739                 }
1740                 segmentData.padInner = PadType(rings[i].outer % 2);
1741                 segmentData.padOuter = PadType(rings[i].outer % 2);
1742                 segmentData.colour = getSegmentColour(atr, rings[i], rand);
1743 
1744                 if (Random.range(rand, 0, 10) > 7)
1745                 {
1746                     segmentData.colour = (segmentData.colour & 0xfefefe) >> 1;
1747                 }
1748 
1749                 drawSegment(
1750                     b, 
1751                     segmentData,
1752                     rand);
1753             }
1754             SB.writeStr(b, "</g>");
1755 
1756             // arc
1757             SB.writeStr(ringSvg, "<g id='r");
1758             SB.writeUint(ringSvg, i);
1759             SB.writeStr(ringSvg, "'>");
1760             for (uint j = 0; j < uint(rings[i].arcs); j++)
1761             {            
1762                 if (Random.range(rand, 0, 64) < atr.decay)
1763                 {
1764                     continue;  //THIS HAS THE EFFECT I WAS LOOKING FOR.
1765                 }
1766                 
1767                 int chaosAddition = Random.range(rand, 0, 720);
1768 
1769                 int angle = atr.chaos < Random.range(rand, 0, 64) ? rings[i].span : chaosAddition;
1770 
1771                 int rotation = (angle * int(j)) * 5;
1772 
1773                 SB.writeStr(ringSvg, "<g id='r");
1774                 SB.writeUint(ringSvg, i);
1775                 SB.writeStr(ringSvg, "a");
1776                 SB.writeUint(ringSvg, j);
1777                 SB.writeStr(ringSvg, "' transform='rotate(");
1778                 SB.writeInt(ringSvg, rotation);
1779                 SB.writeStr(ringSvg, " 320 320)'><use xlink:href='#variant_r");
1780                 SB.writeUint(ringSvg, i);
1781                 SB.writeStr(ringSvg, "_v0'/> </g>");
1782             }
1783             
1784             uint shifted = 8 << uint(Random.range(rand, 0, 4));
1785 
1786             SB.writeStr(ringSvg, "<animateTransform attributeName='transform' attributeType='XML' type='rotate' from='0 320 320' to='");
1787             if (Random.range(rand, 0, 10) > 8)
1788             {
1789                 SB.writeStr(ringSvg, "-");
1790             }
1791             SB.writeStr(ringSvg, "360 320 320' dur='");
1792             SB.writeUint(ringSvg, shifted);
1793             SB.writeStr(ringSvg, "s' begin='1s' repeatCount='indefinite'/></g>");
1794         }
1795 
1796         SB.writeStr(b, "</defs>");
1797         SB.concat(b, ringSvg);
1798     }
1799 
1800     function createRings(Rand memory rand) 
1801         private pure returns(Ring[16] memory)
1802     {
1803         uint8[8] memory chf = [0, 0, 0, 0, 0, 0, 0, 0];
1804 
1805         for(uint i=0; i<24; i++)
1806         {
1807             chf[uint(Random.range(rand, 0, 7))]++;
1808         }
1809 
1810         int[16] memory radii = [int(5), 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5];
1811 
1812         for(uint j=0; j<chf.length; j++) 
1813         {
1814             int total = int8(chf[j]);
1815 
1816             for(int i=0; i<total; i++) 
1817             {
1818                 uint lower = j*2;
1819                 uint upper = (j*2)+3;
1820                 uint index = uint(Random.range(rand, int(lower), int(upper)));
1821 
1822                 int adv = Random.range(rand, i, total);
1823 
1824                 radii[index % 16]+=(adv*5);
1825 
1826                 total-=adv;
1827             }
1828         }
1829 
1830         Ring[16] memory rings;
1831 
1832         uint8[5] memory increments =  [12, 18, 24, 36, 72];
1833         int progress = 60;
1834 
1835         for(uint i=0; i<16; i++)
1836         {
1837             uint idxInc            = uint(Random.range(rand, 0, int(increments.length)-1));
1838             int increment           = int8(increments[idxInc]);
1839             int pad                 = 1;
1840             int thisRingThickness = radii[i];
1841 
1842             
1843             int innerRadius        = progress+pad;
1844             int outerRadius        = int(innerRadius+thisRingThickness) - int(pad);
1845 
1846             progress += thisRingThickness;
1847 
1848             int numArcs  = 72/increment;
1849         
1850             rings[i] = Ring(
1851             {
1852                 id          : i,
1853                 arcs        : numArcs,
1854                 span        : increment,
1855                 inner       : innerRadius,
1856                 outer       : outerRadius
1857             });
1858         }
1859 
1860         return rings;
1861     }
1862 
1863     function drawSpan(
1864         StringBuilder memory b,
1865         SpanType spanType, 
1866         int start, 
1867         int fin, 
1868         int radius, 
1869         PadType pad, 
1870         Variant variant,
1871         uint col,
1872         Rand memory rand) 
1873         private view
1874     {
1875         if (spanType == SpanType.Arc)
1876         {
1877             arc(b, start, fin, radius, pad, col, rand);
1878         }
1879         else if (spanType == SpanType.Dotted)
1880         {
1881             dotted(b, start, fin, radius, pad, col, rand);
1882         }
1883         else if (spanType == SpanType.Cap)
1884         {
1885             cap(b, start, fin, radius, pad, col, rand);
1886         }
1887         else if (spanType == SpanType.Ang)
1888         {
1889             ang(b, start, fin, radius, pad, variant, col, rand);
1890         }
1891         else if (spanType == SpanType.Brk)
1892         {
1893             brk(b, start, fin, radius, pad, variant, col, rand);
1894         }
1895     }
1896 
1897     function drawSegment(
1898         StringBuilder memory b, 
1899         SegmentData memory segmentData,
1900         Rand memory rand) 
1901         private view
1902     {
1903         SB.writeStr(b, "<g id='r");
1904         SB.writeUint(b, segmentData.ringId);
1905         SB.writeStr(b, "v0s");
1906         SB.writeUint(b, segmentData.segId);
1907         SB.writeStr(b, "'>");
1908 
1909         //draw the inner span
1910         drawSpan(
1911             b,
1912             segmentData.innerSpanType, 
1913             segmentData.start, 
1914             segmentData.fin, 
1915             segmentData.inner, 
1916             segmentData.padInner, 
1917             Variant.Inner, 
1918             segmentData.colour,
1919             rand);
1920 
1921         //draw the outer span
1922         drawSpan(
1923             b,
1924             segmentData.outerSpanType, 
1925             segmentData.start, 
1926             segmentData.fin, 
1927             segmentData.outer, 
1928             segmentData.padOuter, 
1929             Variant.Outer, 
1930             segmentData.colour,
1931             rand);
1932 
1933         //draw the edges (matching)
1934         if (segmentData.edge == EdgeType.Simple)
1935         {
1936             simple(
1937                 b, 
1938                 segmentData.start, 
1939                 segmentData.fin, 
1940                 segmentData.outer, 
1941                 segmentData.padOuter, 
1942                 segmentData.thick, 
1943                 segmentData.colour,
1944                 rand);
1945         }
1946 
1947         int radius = segmentData.inner + ((segmentData.outer-segmentData.inner) / 2);
1948 
1949         if (segmentData.fill == FillType.Block)
1950         {
1951             blck(
1952                 b, 
1953                 segmentData.start, 
1954                 segmentData.fin, 
1955                 radius, 
1956                 segmentData.padOuter, 
1957                 segmentData.thick, 
1958                 segmentData.colour, 
1959                 rand);
1960         }
1961         else if (segmentData.fill == FillType.Increment)
1962         {
1963             inc(
1964                 b, 
1965                 segmentData.start, 
1966                 segmentData.fin, 
1967                 radius, 
1968                 segmentData.padOuter, 
1969                 segmentData.thick, 
1970                 segmentData.colour, 
1971                 rand);
1972         }
1973         else if (segmentData.fill == FillType.Text)
1974         {
1975             if (!(segmentData.thick < 5 || segmentData.fin < 30))
1976             {
1977                 text(
1978                     b, 
1979                     segmentData.start, 
1980                     segmentData.fin, 
1981                     segmentData.inner, 
1982                     segmentData.colour, 
1983                     rand);                    
1984             }
1985         }
1986         else if (segmentData.fill == FillType.Hollow)
1987         {
1988             hollow(
1989                 b, 
1990                 segmentData.start, 
1991                 segmentData.fin, 
1992                 segmentData.inner, 
1993                 segmentData.padOuter, 
1994                 segmentData.thick, 
1995                 segmentData.colour,
1996                 rand);
1997         }
1998         else if (segmentData.fill == FillType.Comp)
1999         {
2000             blck(
2001                 b, 
2002                 segmentData.start, 
2003                 segmentData.fin, 
2004                 radius, 
2005                 segmentData.padOuter, 
2006                 segmentData.thick, 
2007                 segmentData.colour, 
2008                 rand);
2009 
2010             inc(
2011                 b, 
2012                 segmentData.start, 
2013                 segmentData.fin, 
2014                 radius, 
2015                 segmentData.padOuter, 
2016                 segmentData.thick, 
2017                 segmentData.colour, 
2018                 rand);
2019 
2020             hollow(
2021                 b, 
2022                 segmentData.start, 
2023                 segmentData.fin, 
2024                 segmentData.inner, 
2025                 segmentData.padOuter, 
2026                 segmentData.thick, 
2027                 segmentData.colour,
2028                 rand);
2029 
2030             if (!(segmentData.thick < 5 || segmentData.fin < 30))
2031             {
2032                 text(
2033                     b,
2034                     segmentData.start, 
2035                     segmentData.fin, 
2036                     segmentData.inner, 
2037                     segmentData.colour, 
2038                     rand);
2039             }
2040         }
2041 
2042         SB.writeStr(b, "</g>");
2043     }
2044     
2045     /*fill types*/
2046 
2047     function hollow(
2048         StringBuilder memory b,
2049         int start, 
2050         int fin, 
2051         int radius, 
2052         PadType pad, 
2053         int thickness, 
2054         uint col,
2055         Rand memory rand) 
2056         view private
2057     {
2058         int padding     = pad == PadType.Single ? int(2) : int(0);
2059         int angleStart = start+padding;
2060         int angleEnd   = fin-(padding*2);
2061         int innerRad   = radius + padding;
2062         int outerRad   = radius + (thickness-padding);
2063         int centreRad  = 320 + innerRad;
2064         int len         = centreRad + thickness - (padding*2);
2065 
2066         SB.writeStr(b, "<g transform='rotate(");
2067         SB.writeInt(b, angleStart);
2068         SB.writeStr(b, " 320 320)'><line y1='320' x1='");
2069         SB.writeInt(b, centreRad);
2070         SB.writeStr(b, "' y2='320' x2='");
2071         SB.writeInt(b, len);
2072         SB.writeStr(b, "'  stroke='#");
2073         SB.writeRgb(b, col);
2074         SB.writeStr(b, "' stroke-width='");
2075         SB.writeStr(b, randomStrokeWidth(rand));
2076         SB.writeStr(b, "'/><circle r='");
2077         SB.writeInt(b, innerRad);
2078         SB.writeStr(b, "' cx='320' cy='320' fill='none' pathLength='360' stroke='#");
2079         SB.writeRgb(b, col);
2080         SB.writeStr(b, "' stroke-width='");
2081         SB.writeStr(b, randomStrokeWidth(rand));
2082         SB.writeStr(b, "' stroke-dasharray='");
2083         SB.writeInt(b, angleEnd);
2084         SB.writeStr(b, " 360'/><circle r='");
2085         SB.writeInt(b, outerRad);
2086         SB.writeStr(b, "' cx='320' cy='320' fill='none' pathLength='360' stroke='#");
2087         SB.writeRgb(b, col);
2088         SB.writeStr(b, "' stroke-width='");
2089         SB.writeStr(b, randomStrokeWidth(rand));
2090         SB.writeStr(b, "' stroke-dasharray='");
2091         SB.writeInt(b, angleEnd);
2092         SB.writeStr(b, " 360'/><g transform='rotate(");
2093         SB.writeInt(b, angleEnd);
2094         SB.writeStr(b, " 320 320)'><line y1='320' x1='");
2095         SB.writeInt(b, centreRad);
2096         SB.writeStr(b, "' y2='320' x2='");
2097         SB.writeInt(b, len);
2098         SB.writeStr(b, "'  stroke='#");
2099         SB.writeRgb(b, col);
2100         SB.writeStr(b, "' stroke-width='");
2101         SB.writeStr(b, randomStrokeWidth(rand));
2102         SB.writeStr(b, "'/></g></g>");
2103     }
2104 
2105     function randomStrokeWidth(Rand memory rand) 
2106         private pure returns(string memory)
2107     {
2108         return Random.range(rand, 0, 9) > 6 ? "0.6" : "0.3";
2109     }
2110 
2111     function text(
2112         StringBuilder memory b,
2113         int start, 
2114         int fin, 
2115         int radius, 
2116         uint col, 
2117         Rand memory rand) 
2118         view private
2119     {
2120         int padding     = 2;
2121         int angleStart = start - padding;
2122         uint textId = Random.value(rand);
2123         
2124         string[12] memory sym = ["0.421", "0.36", "0.73","0.421", "0.36", "0.73","0.421", "0.36", "0.73", "+", "^", "_"];
2125 
2126         string memory chars = sym[uint(Random.range(rand, 0, int(sym.length)-1))];
2127 
2128         radius += FONT_SIZE + padding;
2129 
2130         SB.writeStr(b, "<g transform='rotate(");
2131         SB.writeInt(b, angleStart-180+fin);
2132         SB.writeStr(b, " 320 320)'><path id='text_path_");
2133         SB.writeUint(b, textId);
2134         SB.writeStr(b, "' d='M");
2135         SB.writeInt(b, 320-radius);
2136         SB.writeStr(b, ", 320 a1, 1 0 0, 0 ");
2137         SB.writeInt(b, radius*2);
2138         SB.writeStr(b, ", 0' pathLength='100' fill='none' stroke-width='0' stroke='red'/><text x='0%' style='fill:#");
2139         SB.writeRgb(b, col);
2140         SB.writeStr(b, ";'><textPath href='#text_path_");
2141         SB.writeUint(b, textId);
2142         SB.writeStr(b, "' pointer-events='none'>");
2143         SB.writeStr(b, chars);
2144         SB.writeStr(b, "</textPath></text></g>");
2145     }
2146 
2147     function inc(
2148         StringBuilder memory b,
2149         int start, 
2150         int fin, 
2151         int radius, 
2152         PadType pad, 
2153         int thickness, 
2154         uint col, 
2155         Rand memory rand) 
2156         view private
2157     {
2158         int padding     = (pad == PadType.Single) ? int(4) : int(0);
2159         int angleStart = start + padding / 2;
2160         int angleEnd   = fin - (padding);
2161         int stroke      = thickness - padding;
2162 
2163         uint incId = Random.value(rand);
2164 
2165         SB.writeStr(b, "<g transform='rotate(");
2166         SB.writeInt(b, angleStart);
2167         SB.writeStr(b, " 320 320)'><clipPath id='inc_cutter_");
2168         SB.writeUint(b, incId);
2169         SB.writeStr(b, "'><rect x='0' y='0' width='640' height='320' stroke='black' fill='none' transform='rotate(");
2170         SB.writeInt(b, angleEnd);
2171         SB.writeStr(b, ", 320, 320)' /></clipPath><path d='M");
2172         SB.writeInt(b, 320-radius);
2173         SB.writeStr(b, ", 320 a1, 1 0 0, 0 ");
2174         SB.writeInt(b, radius*2);
2175         SB.writeStr(b, ", 0' pathLength='100' fill='none' stroke-width='");
2176         SB.writeInt(b, stroke);
2177         SB.writeStr(b, "' stroke-opacity='0.4' stroke='#");
2178         SB.writeRgb(b, col);
2179         SB.writeStr(b, "' stroke-dasharray='0.05 1' clip-path='url(#inc_cutter_");
2180         SB.writeUint(b, incId);
2181         SB.writeStr(b, ")'/></g>");
2182     }
2183 
2184     function blck(
2185         StringBuilder memory b,
2186         int start, 
2187         int /*fin*/, 
2188         int radius, 
2189         PadType pad, 
2190         int thickness, 
2191         uint col, 
2192         Rand memory rand) 
2193         view private
2194     {
2195         int padding     = (pad == PadType.Single) ? int(4) : int(0);
2196         int angleStart = start + padding / 2;
2197         int stroke      = thickness - padding;
2198         int opac        = Random.range(rand, 2, 8);
2199 
2200 
2201         SB.writeStr(b, "<g transform='rotate(");
2202         SB.writeInt(b, angleStart);
2203         SB.writeStr(b, " 320 320)'><circle r='");
2204         SB.writeInt(b, radius);
2205         SB.writeStr(b, "' cx='320' cy='320' fill='none' pathLength='359' stroke='#");
2206         SB.writeRgb(b, col);
2207         SB.writeStr(b, "' stroke-opacity='");
2208         SB.writeInt(b, opac);
2209         SB.writeStr(b, "%' stroke-width='");
2210         SB.writeInt(b, stroke);
2211         SB.writeStr(b, "' stroke-dasharray='");
2212         SB.writeInt(b, angleStart);
2213         SB.writeStr(b, " ");
2214         SB.writeInt(b, 360 - angleStart);
2215         SB.writeStr(b, "'/></g>");
2216     }
2217 
2218     /*edge types*/
2219 
2220     function simple(
2221         StringBuilder memory b,
2222         int start, 
2223         int fin, 
2224         int radius, 
2225         PadType pad, 
2226         int len, 
2227         uint col,
2228         Rand memory rand) 
2229         view private
2230     {
2231         int padding = (pad == PadType.Single) ? int(1) : int(0);
2232         int angleStart = start + padding;
2233         int angleEnd = fin - (padding * 2);
2234         int centreRad = 320 + radius;
2235         int edgeLength = centreRad - len;
2236 
2237         SB.writeStr(b, "<g transform='rotate(");
2238         SB.writeInt(b, angleStart);
2239         SB.writeStr(b, " 320 320)'><line y1='320' x1='");
2240         SB.writeInt(b, centreRad);
2241         SB.writeStr(b, "' y2='320' x2='");
2242         SB.writeInt(b, edgeLength);
2243         SB.writeStr(b, "'  stroke='#");
2244         SB.writeRgb(b, col);
2245         SB.writeStr(b, "' stroke-width='");
2246         SB.writeStr(b, randomStrokeWidth(rand));
2247         SB.writeStr(b, "'/><g transform='rotate(");
2248         SB.writeInt(b, angleEnd);
2249         SB.writeStr(b, " 320 320)'><line y1='320' x1='");
2250         SB.writeInt(b, centreRad);
2251         SB.writeStr(b, "' y2='320' x2='");
2252         SB.writeInt(b, edgeLength);
2253         SB.writeStr(b, "'  stroke='#");
2254         SB.writeRgb(b, col);
2255         SB.writeStr(b, "' stroke-width='");
2256         SB.writeStr(b, randomStrokeWidth(rand));
2257         SB.writeStr(b, "'/></g></g>");
2258     }
2259 
2260     /*spans*/
2261 
2262     function brk(
2263         StringBuilder memory b,
2264         int start, 
2265         int fin, 
2266         int radius, 
2267         PadType pad, 
2268         Variant variant, 
2269         uint col, 
2270         Rand memory rand) 
2271         view private
2272     {
2273         int padding     = (pad == PadType.Single) ? int(1) : int(0);
2274         int angleStart = start + padding;
2275         int angleEnd   = fin - (padding * 2);
2276         int centreRad  = 320 + radius;
2277         int brkSize    = 2;
2278         int brkOffset = (variant == Variant.Inner) ? centreRad + brkSize : centreRad - brkSize;
2279 
2280         //uint brkId = Rand.next(rand);
2281 
2282         SB.writeStr(b, "<g><circle r='");
2283         SB.writeInt(b, radius);
2284         SB.writeStr(b, "' cx='320' cy='320' fill='none' pathLength='359' stroke='#");
2285         SB.writeRgb(b, col);
2286         SB.writeStr(b, "' stroke-width='");
2287         SB.writeStr(b, randomStrokeWidth(rand));
2288         SB.writeStr(b, "' stroke-dasharray='");
2289         SB.writeInt(b, angleStart);
2290         SB.writeStr(b, " ");
2291         SB.writeInt(b, 360 - angleStart);
2292         SB.writeStr(b, "'/><line y1='320' x1='");
2293         SB.writeInt(b, centreRad);
2294         SB.writeStr(b, "' y2='320' x2='");
2295         SB.writeInt(b, brkOffset);
2296         SB.writeStr(b, "' stroke='#");
2297         SB.writeRgb(b, col);
2298         SB.writeStr(b, "' stroke-width='");
2299         SB.writeStr(b, randomStrokeWidth(rand));
2300         SB.writeStr(b, "'/><g transform='rotate(");
2301         SB.writeInt(b, angleEnd);
2302         SB.writeStr(b, " 320 320)'><line y1='320' x1='");
2303         SB.writeInt(b, centreRad);
2304         SB.writeStr(b, "' y2='320' x2='");
2305         SB.writeInt(b, brkOffset);
2306         SB.writeStr(b, "' stroke='#");
2307         SB.writeRgb(b, col);
2308         SB.writeStr(b, "' stroke-width='");
2309         SB.writeStr(b, randomStrokeWidth(rand));
2310         SB.writeStr(b, "'/></g></g>");
2311     }
2312 
2313    function ang(
2314        StringBuilder memory b,
2315        int start, 
2316        int fin, 
2317        int radius, 
2318        PadType pad, 
2319        Variant variant, 
2320        uint col,
2321        Rand memory rand) 
2322        view private
2323    {
2324         int padding = (pad == PadType.Single) ? int(1) : int(0);
2325         int angleStart = start + padding;
2326         int angleEnd = fin - (padding * 2);
2327         int angsSize = 2;
2328         int centreRad = 320 + radius;
2329         int centreAng = (variant == Variant.Inner) ? centreRad + angsSize : centreRad - angsSize;
2330         int opac = Random.range(rand, 10, 100);
2331         
2332         SB.writeStr(b, "<g transform='rotate(");
2333         SB.writeInt(b, angleStart);
2334         SB.writeStr(b, " 320 320)'><circle r='");
2335         SB.writeInt(b, radius);
2336         SB.writeStr(b, "' cx='320' cy='320' fill='none' pathLength='360' stroke='#");
2337         SB.writeRgb(b, col);
2338         SB.writeStr(b, "'  stroke-opacity='");
2339         SB.writeInt(b, opac);
2340         SB.writeStr(b, "%' stroke-width='");
2341         SB.writeStr(b, randomStrokeWidth(rand));
2342         SB.writeStr(b, "' stroke-dasharray= '");
2343         SB.writeInt(b, angleEnd);
2344         SB.writeStr(b, " 360'/><polyline points='");
2345         SB.writeInt(b, centreAng);
2346         SB.writeStr(b, ", 320  ");
2347         SB.writeInt(b, centreRad);
2348         SB.writeStr(b, ", 320 ");
2349         SB.writeInt(b, centreRad);
2350         SB.writeStr(b, ", ");
2351         SB.writeInt(b, 320+angsSize);
2352         SB.writeStr(b, "' stroke-width='");
2353         SB.writeStr(b, randomStrokeWidth(rand));
2354         SB.writeStr(b, "' stroke='#");
2355         SB.writeRgb(b, col);
2356         SB.writeStr(b, "' fill='none'/><g transform='rotate(");
2357         SB.writeInt(b, angleEnd);
2358         SB.writeStr(b, " 320 320)'><polyline points='");
2359         SB.writeInt(b, centreAng);
2360         SB.writeStr(b, ", 320 ");
2361         SB.writeInt(b, centreRad);
2362         SB.writeStr(b, ", 320 ");
2363         SB.writeInt(b, centreRad);
2364         SB.writeStr(b, ", ");
2365         SB.writeInt(b, 320-angsSize);
2366         SB.writeStr(b, "' stroke-width='");
2367         SB.writeStr(b, randomStrokeWidth(rand));
2368         SB.writeStr(b, "' stroke='#");
2369         SB.writeRgb(b, col);
2370         SB.writeStr(b, "' fill='none'/></g></g>");
2371    }
2372 
2373    function cap(
2374        StringBuilder memory b,
2375        int start, 
2376        int fin, 
2377        int radius, 
2378        PadType pad, 
2379        uint col,
2380        Rand memory rand) 
2381        view private
2382    {
2383         int padding = (pad == PadType.Single) ? int(1) : int(0);
2384         int angleStart = start + padding;
2385         int angleEnd = fin - (padding * 2);
2386         int gap = angleEnd - 2;
2387         
2388 
2389         SB.writeStr(b, "<g transform='rotate(");
2390         SB.writeInt(b, angleStart);
2391         SB.writeStr(b, " 320 320)'><circle r='");
2392         SB.writeInt(b, radius);
2393         SB.writeStr(b, "' cx='320' cy='320' fill='none' pathLength='360' stroke-opacity='20%' stroke='#");
2394         SB.writeRgb(b, col);
2395         SB.writeStr(b, "' stroke-width='");
2396         SB.writeStr(b, randomStrokeWidth(rand));
2397         SB.writeStr(b, "' stroke-dasharray='");
2398         SB.writeInt(b, angleEnd);
2399         SB.writeStr(b, " 360'/><circle r='");
2400         SB.writeInt(b, radius);
2401         SB.writeStr(b, "' cx='320' cy='320' fill='none' pathLength='360' stroke='#");
2402         SB.writeRgb(b, col);
2403         SB.writeStr(b, "' stroke-width='");
2404         SB.writeStr(b, randomStrokeWidth(rand));
2405         SB.writeStr(b, "' stroke-dasharray='1 ");
2406         SB.writeInt(b, gap);
2407         SB.writeStr(b, " 1 360'/></g>");
2408    }
2409 
2410    function dotted(
2411        StringBuilder memory b,
2412        int start, 
2413        int fin, 
2414        int radius, 
2415        PadType pad, 
2416        uint col, 
2417        Rand memory rand) 
2418        view private
2419    {
2420         int padding     = (pad == PadType.Single) ? int(1) : int(0);
2421         int angleStart = start + padding;
2422         int angleEnd   = fin - (padding * 2);
2423         int gap = angleEnd - 2;
2424         int opac = Random.range(rand, 10, 100);
2425 
2426         uint dotId = Random.value(rand);
2427 
2428         SB.writeStr(b, "<g transform='rotate(");
2429         SB.writeInt(b, angleStart);
2430         SB.writeStr(b, " 320 320)'><clipPath id='dot_cutter_");
2431         SB.writeUint(b, dotId);
2432         SB.writeStr(b, "'><rect x='0' y='0' width='640' height='320' stroke='black' fill='none' transform='rotate(");
2433         SB.writeInt(b, angleEnd);
2434         SB.writeStr(b, ", 320, 320)' /></clipPath><path d='M");
2435         SB.writeInt(b, 320-radius);
2436         SB.writeStr(b, ", 320 a1, 1 0 0, 0 ");
2437         SB.writeInt(b, radius*2);
2438         SB.writeStr(b, ", 0' pathLength='100' fill='none' stroke-opacity='");
2439         SB.writeInt(b, opac);
2440         SB.writeStr(b, "%' stroke-width='0.4' stroke='#");
2441         SB.writeRgb(b, col);
2442         SB.writeStr(b, "' stroke-dasharray='0.25 0.25' clip-path='url(#dot_cutter_");
2443         SB.writeUint(b, dotId);
2444         SB.writeStr(b, ")'/><circle r='");
2445         SB.writeInt(b, radius);
2446         SB.writeStr(b, "' cx='320' cy='320' fill='none' pathLength='359' stroke='#");
2447         SB.writeRgb(b, col);
2448         SB.writeStr(b, "' stroke-width='0.4' stroke-dasharray='1 ");
2449         SB.writeInt(b, gap);
2450         SB.writeStr(b, " 1 360'/></g>");
2451    }
2452 
2453    function arc(
2454        StringBuilder memory b, 
2455        int start, 
2456        int /*fin*/, 
2457        int radius, 
2458        PadType pad, 
2459        uint col, 
2460        Rand memory rand) 
2461        view private
2462    {
2463         int padding     = (pad == PadType.Single) ? int(1) : int(0);
2464         int angleStart = start + padding;
2465 
2466         SB.writeStr(b, "<g><circle r='");
2467         SB.writeInt(b, radius);
2468         SB.writeStr(b, "' cx='320' cy='320' fill='none' pathLength='359' stroke='#");
2469         SB.writeRgb(b, col);
2470         SB.writeStr(b, "' stroke-width='");
2471         SB.writeStr(b, randomStrokeWidth(rand));
2472         SB.writeStr(b, "' stroke-dasharray='");
2473         SB.writeInt(b, angleStart);
2474         SB.writeStr(b, " ");
2475         SB.writeInt(b, 360 - angleStart);
2476         SB.writeStr(b, "'/></g>");
2477    }
2478 }
2479 
2480 contract CypherMetadata is Ownable
2481 {   
2482     using Strings for uint256;
2483 
2484     CypherDrawing _drawing;
2485     string private _imageBaseUri;
2486 
2487     constructor(
2488         CypherDrawing drawing,
2489         string memory imageBaseUri)
2490     {
2491         _drawing = drawing;
2492         _imageBaseUri = imageBaseUri;
2493     }
2494 
2495     function tokenURI(
2496         uint256 tokenId, 
2497         bytes32 hash,
2498         uint256 generation,
2499         bool isFirstTokenInGeneration) 
2500         public view returns(string memory) 
2501     {
2502         return string(abi.encodePacked("data:application/json;utf8,{"
2503             "\"image\":\"data:image/svg+xml;utf8,",
2504             _drawing.generate(hash), "\",",
2505             _commonMetadata(tokenId, hash, generation, isFirstTokenInGeneration),
2506             "}"));
2507     }
2508 
2509     function metadata(
2510         uint256 tokenId,
2511         bytes32 hash, 
2512         uint256 generation,
2513         bool isFirstTokenInGeneration)
2514         public view returns(string memory)
2515     {
2516         string memory imageUri = bytes(_imageBaseUri).length > 0 ? string(abi.encodePacked(_imageBaseUri, tokenId.toString())) : "";
2517 
2518         return string(abi.encodePacked("{"
2519             "\"external_url\": \"", imageUri, "\",",
2520             "\"image\": \"", imageUri, "\",",
2521             _commonMetadata(tokenId, hash, generation, isFirstTokenInGeneration),
2522             "}"));
2523     }
2524 
2525     function setDrawing(CypherDrawing drawing)
2526         public onlyOwner
2527     {
2528         _drawing = drawing;
2529     }
2530 
2531     function setImageBaseUri(string memory imageBaseUri)
2532         public onlyOwner
2533     {
2534         _imageBaseUri = imageBaseUri;
2535     }
2536 
2537     function _commonMetadata(
2538         uint256 tokenId, 
2539         bytes32 hash, 
2540         uint256 generation,
2541         bool isFirstTokenInGeneration)
2542         private view returns(string memory)
2543     {
2544         CypherAttributes memory attributes = _drawing.getAttributes(hash);
2545         
2546         int overall = 0;
2547         for (uint i = 0; i < 8; ++i)
2548         {
2549             overall += attributes.density[i] * attributes.intricacy[i];
2550         }
2551         overall >>= 3;
2552 
2553         StringBuilder memory b = SB.create(2048);
2554         
2555         SB.writeStr(b, "\"description\": \"Cypher is a generative art project by Hideki Tsukamoto comprised of 1024 tokens calculated and drawn via smart-contract, by the Ethereum Virtual Machine. Cypher is part one of the 'Apex' series.\","
2556             "\"name\": \"Cypher #"); 
2557         SB.writeUint(b, tokenId);
2558         SB.writeStr(b, "\","
2559             "\"background_color\": \"1a181b\","
2560             "\"attributes\": [");
2561         if (tokenId == 0)
2562         {
2563             SB.writeStr(b, "{"
2564                 "\"trait_type\": \"Edition\","
2565                 "\"value\": \"Genesis\""
2566                 "},");
2567         }
2568         else if (tokenId == 1)
2569         {
2570             SB.writeStr(b, "{"
2571                 "\"trait_type\": \"Edition\","
2572                 "\"value\": \"Primary\""
2573                 "},");
2574         }
2575         else if (tokenId == 2)
2576         {
2577             SB.writeStr(b, "{"
2578                 "\"trait_type\": \"Edition\","
2579                 "\"value\": \"Secondary\""
2580                 "},");
2581         }
2582         else if (tokenId == 3)
2583         {
2584             SB.writeStr(b, "{"
2585                 "\"trait_type\": \"Edition\","
2586                 "\"value\": \"Tertiary\""
2587                 "},");
2588         }
2589         if (isFirstTokenInGeneration)
2590         {
2591             SB.writeStr(b, "{"
2592                 "\"trait_type\": \"Edition\","
2593                 "\"value\": \"Generation Genesis\""
2594                 "},");
2595         }
2596         SB.writeStr(b, "{"
2597             "\"trait_type\": \"Generation\"," 
2598             "\"value\": \"");
2599         SB.writeUint(b, generation);
2600         SB.writeStr(b, "\"},"
2601             "{"
2602                 "\"trait_type\": \"Intricacy\","
2603                 "\"value\":\"");
2604         SB.writeStr(b, _attributeValueString_0_32(overall));
2605         SB.writeStr(b, "\"},"
2606             "{"
2607                 "\"trait_type\": \"Intricacy Value\","
2608                 "\"max_value\": 32,"
2609                 "\"value\":");
2610         SB.writeInt(b, overall);
2611         SB.writeStr(b, "},"
2612             "{"
2613                 "\"trait_type\": \"Chaos\","
2614                 "\"value\":\"");
2615         SB.writeStr(b, _attributeValueString_0_32(attributes.chaos));
2616         SB.writeStr(b, "\"},"
2617             "{"
2618                 "\"trait_type\": \"Chaos Value\","
2619                 "\"max_value\": 32,"
2620                 "\"value\":");
2621         SB.writeInt(b, attributes.chaos);
2622         SB.writeStr(b, "},"
2623             "{"
2624                 "\"trait_type\": \"Channels\","
2625                 "\"value\":\"");
2626         SB.writeStr(b, _attributeValueString_0_8(attributes.numChannels));
2627         SB.writeStr(b, "\"},"
2628             "{"
2629                 "\"trait_type\": \"Channels Value\","
2630                 "\"max_value\": 8,"
2631                 "\"value\":");
2632         SB.writeInt(b, attributes.numChannels);
2633         SB.writeStr(b, "},"
2634             "{"
2635                 "\"trait_type\": \"Decay\","
2636                 "\"value\":\"");
2637         SB.writeStr(b, _attributeValueString_0_32(attributes.decay));
2638         SB.writeStr(b, "\"},"
2639             "{"
2640                 "\"trait_type\": \"Decay Value\","
2641                 "\"max_value\": 32,"
2642                 "\"value\":");
2643         SB.writeInt(b, attributes.decay);
2644         SB.writeStr(b, "},"
2645             "{"
2646                 "\"trait_type\": \"Level\","
2647                 "\"value\":\"");
2648         SB.writeUint(b, attributes.colorset + 1);
2649         SB.writeStr(b, "\"},"
2650             "{"
2651                 "\"trait_type\": \"Level Value\","
2652                 "\"max_value\": 5,"
2653                 "\"value\":");
2654         SB.writeUint(b, attributes.colorset + 1);
2655         SB.writeStr(b, "}"
2656             "]");
2657 
2658         return SB.getString(b);
2659     }
2660 
2661     function _attributeValueString_0_32(int256 value)
2662         private pure returns(string memory)
2663     {
2664         if (value == 0)
2665         {
2666             return "Void";
2667         }
2668         else if (value <= 2)
2669         {
2670             return "Marginal";
2671         }
2672         else if (value <= 8)
2673         {
2674             return "Low";
2675         }
2676         else if (value <= 23)
2677         {
2678             return "Average";
2679         }
2680         else if (value <= 29)
2681         {
2682             return "High";
2683         }
2684         else if (value <= 31)
2685         {
2686             return "Super";
2687         }
2688         else
2689         {
2690             return "Extreme";
2691         }
2692     }
2693 
2694     function _attributeValueString_0_8(int256 value) 
2695         private pure returns(string memory)
2696     {
2697         if (value == 0)
2698         {
2699             return "Void";
2700         }
2701         else if (value <= 1)
2702         {
2703             return "Marginal";
2704         }
2705         else if (value <= 2)
2706         {
2707             return "Low";
2708         }
2709         else if (value <= 5)
2710         {
2711             return "Average";
2712         }
2713         else if (value <= 6)
2714         {
2715             return "High";
2716         }
2717         else if (value <= 7)
2718         {
2719             return "Super";
2720         }
2721         else
2722         {
2723             return "Extreme";
2724         }
2725     }
2726 }
2727 
2728 
2729 
2730 contract Cypher is ERC721Enumerable, Ownable
2731 {
2732     uint256 private _maxTokenInvocations;
2733     uint256 private _reservedInvocations;
2734     uint256 private _auctionStartBlock;
2735     uint256 private _auctionEndBlock;
2736     uint256 private _initialFee;
2737     uint256 private _initialDuration;
2738     uint256 private _maxHalvings;
2739     address payable private _recipient;
2740     CypherDrawing private _drawing;
2741     CypherMetadata private _metadata;
2742     mapping(uint256 => bytes32) private _hashes;
2743     mapping(uint256 => uint256) private _generation;
2744     bool _isLocked;
2745 
2746     struct ConstructorArgs
2747     {
2748         string name;
2749         string symbol;
2750         uint256 maxTokenInvocations;
2751         uint256 reservedInvocations;
2752         uint256 auctionStartBlock;
2753         uint256 initialFee;
2754         uint256 initialDuration;
2755         uint256 maxHalvings;
2756         address payable recipient;
2757         CypherDrawing drawing;
2758         CypherMetadata meta;
2759     }
2760 
2761     constructor(
2762         ConstructorArgs memory args)
2763         ERC721(args.name, args.symbol)
2764     {
2765         _maxTokenInvocations = args.maxTokenInvocations;
2766         _reservedInvocations = args.reservedInvocations;
2767         _auctionStartBlock = args.auctionStartBlock;
2768         _initialFee = args.initialFee;
2769         _initialDuration = args.initialDuration;
2770         _maxHalvings = args.maxHalvings;
2771         _recipient = args.recipient;
2772         _drawing = args.drawing;
2773         _metadata = args.meta;
2774 
2775         // minting #0
2776         bytes32 hash = keccak256(
2777             abi.encodePacked(uint(0),
2778                             blockhash(block.number - 1)));
2779 
2780         _hashes[0] = hash;
2781         _generation[0] = 0;
2782         _safeMint(msg.sender, 0);
2783     }
2784 
2785     modifier isUnlocked() 
2786     {
2787         require(!_isLocked, "Contract is locked");
2788         _;
2789     }
2790 
2791     function lock() public onlyOwner
2792     {
2793         _isLocked = true;
2794     }
2795 
2796     function setMaxTokenInvocations(uint256 maxTokenInvocations)
2797         public onlyOwner isUnlocked
2798     {
2799         _maxTokenInvocations = maxTokenInvocations;
2800     }
2801 
2802     function setReservedInvocations(uint256 reservedInvocations)
2803         public onlyOwner isUnlocked
2804     {
2805         _reservedInvocations = reservedInvocations;
2806     }
2807 
2808     function setAuctionStartBlock(uint256 auctionStartBlock)
2809         public onlyOwner isUnlocked
2810     {
2811         _auctionStartBlock = auctionStartBlock;
2812     }
2813 
2814     function setInitialFee(uint256 initialFee)
2815         public onlyOwner isUnlocked
2816     {
2817         _initialFee = initialFee;
2818     }
2819 
2820     function setInitialDuration(uint256 initialDuration)
2821         public onlyOwner isUnlocked
2822     {
2823         _initialDuration = initialDuration;
2824     }
2825 
2826     function setMaxHalvings(uint256 maxHalvings)
2827         public onlyOwner isUnlocked
2828     {
2829         _maxHalvings = maxHalvings;
2830     }
2831 
2832     function setRecipient(address payable recipient)
2833         public onlyOwner
2834     {
2835         _recipient = recipient;
2836     }
2837 
2838     function setDrawingContract(CypherDrawing drawing)
2839         public onlyOwner isUnlocked
2840     {
2841         _drawing = drawing;
2842     }
2843 
2844     function setMetadataContract(CypherMetadata meta)
2845         public onlyOwner
2846     {
2847         _metadata = meta;
2848     }
2849 
2850     function getInfo()
2851         public view returns(
2852             bool hasStarted,
2853             bool hasEnded,
2854             uint256 blocksUntilAuctionStart,
2855             uint256 currentGeneration,
2856             uint256 currentFee,
2857             uint256 blocksUntilNextHalving,
2858             uint256 currentInvocationCount,
2859             uint256 maxTokenInvocations)
2860     {
2861         uint256 nextBlock = block.number + 1;
2862         if (nextBlock >= _auctionStartBlock)
2863         {
2864             hasStarted = _auctionStartBlock != 0;
2865 
2866             blocksUntilAuctionStart = 0;
2867         }
2868         else
2869         {
2870             hasStarted = false;
2871 
2872             blocksUntilAuctionStart = _auctionStartBlock - nextBlock;
2873         }
2874 
2875         if (_auctionEndBlock == 0)
2876         {
2877             hasEnded = false;
2878 
2879             (currentGeneration, 
2880             currentFee, 
2881             blocksUntilNextHalving) = _getAuctionState(nextBlock);
2882         }
2883         else
2884         {
2885             hasEnded = true;
2886 
2887             (currentGeneration, 
2888             currentFee, ) = _getAuctionState(_auctionEndBlock);
2889             blocksUntilNextHalving = 0;
2890         }
2891 
2892         currentInvocationCount = totalSupply();
2893         maxTokenInvocations = _maxTokenInvocations;
2894     }
2895 
2896     function purchase() 
2897         public payable returns (uint256 tokenId)
2898     {
2899         require(_auctionStartBlock > 0 && block.number >= _auctionStartBlock, 
2900                 "auction hasn't started yet");
2901 
2902         uint256 totalInvocations = totalSupply();
2903         uint256 invocationsRemaining = _maxTokenInvocations - totalInvocations;
2904         
2905         require(invocationsRemaining > _reservedInvocations ||
2906             (invocationsRemaining > 0 && msg.sender == owner()), 
2907             "max token invocations reached");
2908 
2909         uint256 blockNumber = block.number;
2910         if (_auctionEndBlock != 0)
2911         {
2912             blockNumber = _auctionEndBlock;
2913         }
2914         else if (invocationsRemaining == (_reservedInvocations + 1))
2915         {
2916             _auctionEndBlock = block.number;
2917         }
2918 
2919         uint256 generation;
2920         uint256 fee;
2921         (generation, fee, ) = _getAuctionState(blockNumber);
2922 
2923         require(msg.value == fee, "value doesn't equal cost");
2924         
2925         (bool success, ) = _recipient.call{value:msg.value}("");
2926         require(success, "Transfer failed.");
2927         
2928         tokenId = totalInvocations;
2929         bytes32 hash = keccak256(
2930             abi.encodePacked(tokenId, 
2931                             blockhash(block.number - 1),
2932                             tokenId > 0 ? _hashes[tokenId - 1] : bytes32(0)));
2933         
2934         _hashes[tokenId] = hash;
2935         _generation[tokenId] = generation;
2936         _safeMint(msg.sender, tokenId);
2937         
2938         return tokenId;
2939     }
2940  
2941     function metadata(uint256 tokenId)
2942         public view returns (string memory)
2943     {
2944         require(_exists(tokenId), "token not minted");
2945 
2946         return _metadata.metadata( 
2947             tokenId, 
2948             _hashes[tokenId],
2949             _generation[tokenId],
2950             _isFirstTokenInGeneration(tokenId));
2951     }
2952 
2953     function generate(uint256 tokenId) 
2954         public view returns (string memory)
2955     { 
2956         require(_exists(tokenId), "token not minted");
2957         return _drawing.generate(_hashes[tokenId]);
2958     }
2959 
2960     function tokenURI(uint256 tokenId) public view virtual override 
2961         returns (string memory) 
2962     {
2963         require(_exists(tokenId), "token not minted");
2964 
2965         return _metadata.tokenURI(
2966             tokenId, 
2967             _hashes[tokenId],
2968             _generation[tokenId],
2969             _isFirstTokenInGeneration(tokenId));
2970     }
2971 
2972     function _getAuctionState(uint256 blockNumber) private view returns (
2973         uint256 currentGeneration, 
2974         uint256 currentFee, 
2975         uint256 blocksUntilNextHalving)
2976     {
2977         if (_auctionStartBlock == 0)
2978         {
2979             return (0, _initialFee, 0);
2980         }
2981         
2982         if (blockNumber < _auctionStartBlock)
2983         {
2984             uint256 firstHalving = _auctionStartBlock + _initialDuration;
2985             return (0, _initialFee, firstHalving - blockNumber);
2986         }
2987 
2988         uint256 generation = 0;
2989         uint256 fee = _initialFee;
2990         uint256 duration = _initialDuration;
2991         uint256 nextHalving = _auctionStartBlock + duration;
2992 
2993         for (uint256 i = 0; i < _maxHalvings; ++i)
2994         {
2995             if (blockNumber < nextHalving)
2996             {
2997                 return (generation, fee, nextHalving - blockNumber);
2998             }
2999 
3000             ++generation;
3001             fee >>= 1;
3002             duration <<= 1;
3003             nextHalving += duration;
3004         }
3005 
3006         return (generation, fee, 0);
3007     }
3008 
3009     function _isFirstTokenInGeneration(uint256 tokenId)
3010         private view returns(bool)
3011     {
3012         if (tokenId > 0)
3013         {
3014             return _generation[tokenId] != _generation[tokenId - 1];
3015         }
3016 
3017         return true;
3018     }
3019 }