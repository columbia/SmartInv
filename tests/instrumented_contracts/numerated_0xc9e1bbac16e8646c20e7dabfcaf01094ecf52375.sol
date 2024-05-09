1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes calldata) {
21         return msg.data;
22     }
23 }
24 pragma solidity ^0.8.0;
25 
26 /**
27  * @dev String operations.
28  */
29 library Strings {
30     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
31 
32     /**
33      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
34      */
35     function toString(uint256 value) internal pure returns (string memory) {
36         // Inspired by OraclizeAPI's implementation - MIT licence
37         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
38 
39         if (value == 0) {
40             return "0";
41         }
42         uint256 temp = value;
43         uint256 digits;
44         while (temp != 0) {
45             digits++;
46             temp /= 10;
47         }
48         bytes memory buffer = new bytes(digits);
49         while (value != 0) {
50             digits -= 1;
51             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
52             value /= 10;
53         }
54         return string(buffer);
55     }
56 
57     /**
58      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
59      */
60     function toHexString(uint256 value) internal pure returns (string memory) {
61         if (value == 0) {
62             return "0x00";
63         }
64         uint256 temp = value;
65         uint256 length = 0;
66         while (temp != 0) {
67             length++;
68             temp >>= 8;
69         }
70         return toHexString(value, length);
71     }
72 
73     /**
74      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
75      */
76     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
77         bytes memory buffer = new bytes(2 * length + 2);
78         buffer[0] = "0";
79         buffer[1] = "x";
80         for (uint256 i = 2 * length + 1; i > 1; --i) {
81             buffer[i] = _HEX_SYMBOLS[value & 0xf];
82             value >>= 4;
83         }
84         require(value == 0, "Strings: hex length insufficient");
85         return string(buffer);
86     }
87 }
88 pragma solidity ^0.8.0;
89 
90 /**
91  * @dev Collection of functions related to the address type
92  */
93 library Address {
94     /**
95      * @dev Returns true if `account` is a contract.
96      *
97      * [IMPORTANT]
98      * ====
99      * It is unsafe to assume that an address for which this function returns
100      * false is an externally-owned account (EOA) and not a contract.
101      *
102      * Among others, `isContract` will return false for the following
103      * types of addresses:
104      *
105      *  - an externally-owned account
106      *  - a contract in construction
107      *  - an address where a contract will be created
108      *  - an address where a contract lived, but was destroyed
109      * ====
110      */
111     function isContract(address account) internal view returns (bool) {
112         // This method relies on extcodesize, which returns 0 for contracts in
113         // construction, since the code is only stored at the end of the
114         // constructor execution.
115 
116         uint256 size;
117         assembly {
118             size := extcodesize(account)
119         }
120         return size > 0;
121     }
122 
123     /**
124      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
125      * `recipient`, forwarding all available gas and reverting on errors.
126      *
127      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
128      * of certain opcodes, possibly making contracts go over the 2300 gas limit
129      * imposed by `transfer`, making them unable to receive funds via
130      * `transfer`. {sendValue} removes this limitation.
131      *
132      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
133      *
134      * IMPORTANT: because control is transferred to `recipient`, care must be
135      * taken to not create reentrancy vulnerabilities. Consider using
136      * {ReentrancyGuard} or the
137      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
138      */
139     function sendValue(address payable recipient, uint256 amount) internal {
140         require(address(this).balance >= amount, "Address: insufficient balance");
141 
142         (bool success, ) = recipient.call{value: amount}("");
143         require(success, "Address: unable to send value, recipient may have reverted");
144     }
145 
146     /**
147      * @dev Performs a Solidity function call using a low level `call`. A
148      * plain `call` is an unsafe replacement for a function call: use this
149      * function instead.
150      *
151      * If `target` reverts with a revert reason, it is bubbled up by this
152      * function (like regular Solidity function calls).
153      *
154      * Returns the raw returned data. To convert to the expected return value,
155      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
156      *
157      * Requirements:
158      *
159      * - `target` must be a contract.
160      * - calling `target` with `data` must not revert.
161      *
162      * _Available since v3.1._
163      */
164     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
165         return functionCall(target, data, "Address: low-level call failed");
166     }
167 
168     /**
169      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
170      * `errorMessage` as a fallback revert reason when `target` reverts.
171      *
172      * _Available since v3.1._
173      */
174     function functionCall(
175         address target,
176         bytes memory data,
177         string memory errorMessage
178     ) internal returns (bytes memory) {
179         return functionCallWithValue(target, data, 0, errorMessage);
180     }
181 
182     /**
183      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
184      * but also transferring `value` wei to `target`.
185      *
186      * Requirements:
187      *
188      * - the calling contract must have an ETH balance of at least `value`.
189      * - the called Solidity function must be `payable`.
190      *
191      * _Available since v3.1._
192      */
193     function functionCallWithValue(
194         address target,
195         bytes memory data,
196         uint256 value
197     ) internal returns (bytes memory) {
198         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
199     }
200 
201     /**
202      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
203      * with `errorMessage` as a fallback revert reason when `target` reverts.
204      *
205      * _Available since v3.1._
206      */
207     function functionCallWithValue(
208         address target,
209         bytes memory data,
210         uint256 value,
211         string memory errorMessage
212     ) internal returns (bytes memory) {
213         require(address(this).balance >= value, "Address: insufficient balance for call");
214         require(isContract(target), "Address: call to non-contract");
215 
216         (bool success, bytes memory returndata) = target.call{value: value}(data);
217         return verifyCallResult(success, returndata, errorMessage);
218     }
219 
220     /**
221      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
222      * but performing a static call.
223      *
224      * _Available since v3.3._
225      */
226     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
227         return functionStaticCall(target, data, "Address: low-level static call failed");
228     }
229 
230     /**
231      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
232      * but performing a static call.
233      *
234      * _Available since v3.3._
235      */
236     function functionStaticCall(
237         address target,
238         bytes memory data,
239         string memory errorMessage
240     ) internal view returns (bytes memory) {
241         require(isContract(target), "Address: static call to non-contract");
242 
243         (bool success, bytes memory returndata) = target.staticcall(data);
244         return verifyCallResult(success, returndata, errorMessage);
245     }
246 
247     /**
248      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
249      * but performing a delegate call.
250      *
251      * _Available since v3.4._
252      */
253     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
254         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
255     }
256 
257     /**
258      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
259      * but performing a delegate call.
260      *
261      * _Available since v3.4._
262      */
263     function functionDelegateCall(
264         address target,
265         bytes memory data,
266         string memory errorMessage
267     ) internal returns (bytes memory) {
268         require(isContract(target), "Address: delegate call to non-contract");
269 
270         (bool success, bytes memory returndata) = target.delegatecall(data);
271         return verifyCallResult(success, returndata, errorMessage);
272     }
273 
274     /**
275      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
276      * revert reason using the provided one.
277      *
278      * _Available since v4.3._
279      */
280     function verifyCallResult(
281         bool success,
282         bytes memory returndata,
283         string memory errorMessage
284     ) internal pure returns (bytes memory) {
285         if (success) {
286             return returndata;
287         } else {
288             // Look for revert reason and bubble it up if present
289             if (returndata.length > 0) {
290                 // The easiest way to bubble the revert reason is using memory via assembly
291 
292                 assembly {
293                     let returndata_size := mload(returndata)
294                     revert(add(32, returndata), returndata_size)
295                 }
296             } else {
297                 revert(errorMessage);
298             }
299         }
300     }
301 }
302 pragma solidity ^0.8.0;
303 
304 /**
305  * @dev Interface of the ERC165 standard, as defined in the
306  * https://eips.ethereum.org/EIPS/eip-165[EIP].
307  *
308  * Implementers can declare support of contract interfaces, which can then be
309  * queried by others ({ERC165Checker}).
310  *
311  * For an implementation, see {ERC165}.
312  */
313 interface IERC165 {
314     /**
315      * @dev Returns true if this contract implements the interface defined by
316      * `interfaceId`. See the corresponding
317      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
318      * to learn more about how these ids are created.
319      *
320      * This function call must use less than 30 000 gas.
321      */
322     function supportsInterface(bytes4 interfaceId) external view returns (bool);
323 }
324 pragma solidity ^0.8.0;
325 
326 /**
327  * @title ERC721 token receiver interface
328  * @dev Interface for any contract that wants to support safeTransfers
329  * from ERC721 asset contracts.
330  */
331 interface IERC721Receiver {
332     /**
333      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
334      * by `operator` from `from`, this function is called.
335      *
336      * It must return its Solidity selector to confirm the token transfer.
337      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
338      *
339      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
340      */
341     function onERC721Received(
342         address operator,
343         address from,
344         uint256 tokenId,
345         bytes calldata data
346     ) external returns (bytes4);
347 }
348 pragma solidity ^0.8.0;
349 
350 
351 /**
352  * @dev Contract module which provides a basic access control mechanism, where
353  * there is an account (an owner) that can be granted exclusive access to
354  * specific functions.
355  *
356  * By default, the owner account will be the one that deploys the contract. This
357  * can later be changed with {transferOwnership}.
358  *
359  * This module is used through inheritance. It will make available the modifier
360  * `onlyOwner`, which can be applied to your functions to restrict their use to
361  * the owner.
362  */
363 abstract contract Ownable is Context {
364     address private _owner;
365 
366     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
367 
368     /**
369      * @dev Initializes the contract setting the deployer as the initial owner.
370      */
371     constructor() {
372         _setOwner(_msgSender());
373     }
374 
375     /**
376      * @dev Returns the address of the current owner.
377      */
378     function owner() public view virtual returns (address) {
379         return _owner;
380     }
381 
382     /**
383      * @dev Throws if called by any account other than the owner.
384      */
385     modifier onlyOwner() {
386         require(owner() == _msgSender(), "Ownable: caller is not the owner");
387         _;
388     }
389 
390     /**
391      * @dev Leaves the contract without owner. It will not be possible to call
392      * `onlyOwner` functions anymore. Can only be called by the current owner.
393      *
394      * NOTE: Renouncing ownership will leave the contract without an owner,
395      * thereby removing any functionality that is only available to the owner.
396      */
397     function renounceOwnership() public virtual onlyOwner {
398         _setOwner(address(0));
399     }
400 
401     /**
402      * @dev Transfers ownership of the contract to a new account (`newOwner`).
403      * Can only be called by the current owner.
404      */
405     function transferOwnership(address newOwner) public virtual onlyOwner {
406         require(newOwner != address(0), "Ownable: new owner is the zero address");
407         _setOwner(newOwner);
408     }
409 
410     function _setOwner(address newOwner) private {
411         address oldOwner = _owner;
412         _owner = newOwner;
413         emit OwnershipTransferred(oldOwner, newOwner);
414     }
415 }
416 pragma solidity ^0.8.0;
417 
418 
419 /**
420  * @dev Implementation of the {IERC165} interface.
421  *
422  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
423  * for the additional interface id that will be supported. For example:
424  *
425  * ```solidity
426  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
427  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
428  * }
429  * ```
430  *
431  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
432  */
433 abstract contract ERC165 is IERC165 {
434     /**
435      * @dev See {IERC165-supportsInterface}.
436      */
437     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
438         return interfaceId == type(IERC165).interfaceId;
439     }
440 }
441 pragma solidity ^0.8.0;
442 
443 
444 /**
445  * @dev Required interface of an ERC721 compliant contract.
446  */
447 interface IERC721 is IERC165 {
448     /**
449      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
450      */
451     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
452 
453     /**
454      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
455      */
456     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
457 
458     /**
459      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
460      */
461     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
462 
463     /**
464      * @dev Returns the number of tokens in ``owner``'s account.
465      */
466     function balanceOf(address owner) external view returns (uint256 balance);
467 
468     /**
469      * @dev Returns the owner of the `tokenId` token.
470      *
471      * Requirements:
472      *
473      * - `tokenId` must exist.
474      */
475     function ownerOf(uint256 tokenId) external view returns (address owner);
476 
477     /**
478      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
479      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
480      *
481      * Requirements:
482      *
483      * - `from` cannot be the zero address.
484      * - `to` cannot be the zero address.
485      * - `tokenId` token must exist and be owned by `from`.
486      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
487      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
488      *
489      * Emits a {Transfer} event.
490      */
491     function safeTransferFrom(
492         address from,
493         address to,
494         uint256 tokenId
495     ) external;
496 
497     /**
498      * @dev Transfers `tokenId` token from `from` to `to`.
499      *
500      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
501      *
502      * Requirements:
503      *
504      * - `from` cannot be the zero address.
505      * - `to` cannot be the zero address.
506      * - `tokenId` token must be owned by `from`.
507      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
508      *
509      * Emits a {Transfer} event.
510      */
511     function transferFrom(
512         address from,
513         address to,
514         uint256 tokenId
515     ) external;
516 
517     /**
518      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
519      * The approval is cleared when the token is transferred.
520      *
521      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
522      *
523      * Requirements:
524      *
525      * - The caller must own the token or be an approved operator.
526      * - `tokenId` must exist.
527      *
528      * Emits an {Approval} event.
529      */
530     function approve(address to, uint256 tokenId) external;
531 
532     /**
533      * @dev Returns the account approved for `tokenId` token.
534      *
535      * Requirements:
536      *
537      * - `tokenId` must exist.
538      */
539     function getApproved(uint256 tokenId) external view returns (address operator);
540 
541     /**
542      * @dev Approve or remove `operator` as an operator for the caller.
543      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
544      *
545      * Requirements:
546      *
547      * - The `operator` cannot be the caller.
548      *
549      * Emits an {ApprovalForAll} event.
550      */
551     function setApprovalForAll(address operator, bool _approved) external;
552 
553     /**
554      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
555      *
556      * See {setApprovalForAll}
557      */
558     function isApprovedForAll(address owner, address operator) external view returns (bool);
559 
560     /**
561      * @dev Safely transfers `tokenId` token from `from` to `to`.
562      *
563      * Requirements:
564      *
565      * - `from` cannot be the zero address.
566      * - `to` cannot be the zero address.
567      * - `tokenId` token must exist and be owned by `from`.
568      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
569      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
570      *
571      * Emits a {Transfer} event.
572      */
573     function safeTransferFrom(
574         address from,
575         address to,
576         uint256 tokenId,
577         bytes calldata data
578     ) external;
579 }
580 
581 
582 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
583 
584 pragma solidity ^0.8.0;
585 
586 /**
587  * @dev Interface of the ERC20 standard as defined in the EIP.
588  */
589 interface IERC20 {
590 
591     /**
592      * @dev Returns the amount of tokens owned by `account`.
593      */
594     function balanceOf(address account) external view returns (uint256);
595 }
596 
597 pragma solidity ^0.8.0;
598 
599 
600 /**
601  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
602  * @dev See https://eips.ethereum.org/EIPS/eip-721
603  */
604 interface IERC721Metadata is IERC721 {
605     /**
606      * @dev Returns the token collection name.
607      */
608     function name() external view returns (string memory);
609 
610     /**
611      * @dev Returns the token collection symbol.
612      */
613     function symbol() external view returns (string memory);
614 
615     /**
616      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
617      */
618     function tokenURI(uint256 tokenId) external view returns (string memory);
619 }
620 pragma solidity ^0.8.0;
621 
622 
623 /**
624  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
625  * the Metadata extension, but not including the Enumerable extension, which is available separately as
626  * {ERC721Enumerable}.
627  */
628 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
629     using Address for address;
630     using Strings for uint256;
631 
632     // Token name
633     string private _name;
634 
635     // Token symbol
636     string private _symbol;
637 
638     // Mapping from token ID to owner address
639     mapping(uint256 => address) private _owners;
640 
641     // Mapping owner address to token count
642     mapping(address => uint256) private _balances;
643 
644     // Mapping from token ID to approved address
645     mapping(uint256 => address) private _tokenApprovals;
646 
647     // Mapping from owner to operator approvals
648     mapping(address => mapping(address => bool)) private _operatorApprovals;
649 
650     /**
651      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
652      */
653     constructor(string memory name_, string memory symbol_) {
654         _name = name_;
655         _symbol = symbol_;
656     }
657 
658     /**
659      * @dev See {IERC165-supportsInterface}.
660      */
661     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
662         return
663             interfaceId == type(IERC721).interfaceId ||
664             interfaceId == type(IERC721Metadata).interfaceId ||
665             super.supportsInterface(interfaceId);
666     }
667 
668     /**
669      * @dev See {IERC721-balanceOf}.
670      */
671     function balanceOf(address owner) public view virtual override returns (uint256) {
672         require(owner != address(0), "ERC721: balance query for the zero address");
673         return _balances[owner];
674     }
675 
676     /**
677      * @dev See {IERC721-ownerOf}.
678      */
679     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
680         address owner = _owners[tokenId];
681         require(owner != address(0), "ERC721: owner query for nonexistent token");
682         return owner;
683     }
684 
685     /**
686      * @dev See {IERC721Metadata-name}.
687      */
688     function name() public view virtual override returns (string memory) {
689         return _name;
690     }
691 
692     /**
693      * @dev See {IERC721Metadata-symbol}.
694      */
695     function symbol() public view virtual override returns (string memory) {
696         return _symbol;
697     }
698 
699     /**
700      * @dev See {IERC721Metadata-tokenURI}.
701      */
702     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
703         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
704 
705         string memory baseURI = _baseURI();
706         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
707     }
708 
709     /**
710      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
711      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
712      * by default, can be overriden in child contracts.
713      */
714     function _baseURI() internal view virtual returns (string memory) {
715         return "";
716     }
717 
718     /**
719      * @dev See {IERC721-approve}.
720      */
721     function approve(address to, uint256 tokenId) public virtual override {
722         address owner = ERC721.ownerOf(tokenId);
723         require(to != owner, "ERC721: approval to current owner");
724 
725         require(
726             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
727             "ERC721: approve caller is not owner nor approved for all"
728         );
729 
730         _approve(to, tokenId);
731     }
732 
733     /**
734      * @dev See {IERC721-getApproved}.
735      */
736     function getApproved(uint256 tokenId) public view virtual override returns (address) {
737         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
738 
739         return _tokenApprovals[tokenId];
740     }
741 
742     /**
743      * @dev See {IERC721-setApprovalForAll}.
744      */
745     function setApprovalForAll(address operator, bool approved) public virtual override {
746         require(operator != _msgSender(), "ERC721: approve to caller");
747 
748         _operatorApprovals[_msgSender()][operator] = approved;
749         emit ApprovalForAll(_msgSender(), operator, approved);
750     }
751 
752     /**
753      * @dev See {IERC721-isApprovedForAll}.
754      */
755     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
756         return _operatorApprovals[owner][operator];
757     }
758 
759     /**
760      * @dev See {IERC721-transferFrom}.
761      */
762     function transferFrom(
763         address from,
764         address to,
765         uint256 tokenId
766     ) public virtual override {
767         //solhint-disable-next-line max-line-length
768         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
769 
770         _transfer(from, to, tokenId);
771     }
772 
773     /**
774      * @dev See {IERC721-safeTransferFrom}.
775      */
776     function safeTransferFrom(
777         address from,
778         address to,
779         uint256 tokenId
780     ) public virtual override {
781         safeTransferFrom(from, to, tokenId, "");
782     }
783 
784     /**
785      * @dev See {IERC721-safeTransferFrom}.
786      */
787     function safeTransferFrom(
788         address from,
789         address to,
790         uint256 tokenId,
791         bytes memory _data
792     ) public virtual override {
793         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
794         _safeTransfer(from, to, tokenId, _data);
795     }
796 
797     /**
798      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
799      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
800      *
801      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
802      *
803      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
804      * implement alternative mechanisms to perform token transfer, such as signature-based.
805      *
806      * Requirements:
807      *
808      * - `from` cannot be the zero address.
809      * - `to` cannot be the zero address.
810      * - `tokenId` token must exist and be owned by `from`.
811      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
812      *
813      * Emits a {Transfer} event.
814      */
815     function _safeTransfer(
816         address from,
817         address to,
818         uint256 tokenId,
819         bytes memory _data
820     ) internal virtual {
821         _transfer(from, to, tokenId);
822         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
823     }
824 
825     /**
826      * @dev Returns whether `tokenId` exists.
827      *
828      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
829      *
830      * Tokens start existing when they are minted (`_mint`),
831      * and stop existing when they are burned (`_burn`).
832      */
833     function _exists(uint256 tokenId) internal view virtual returns (bool) {
834         return _owners[tokenId] != address(0);
835     }
836 
837     /**
838      * @dev Returns whether `spender` is allowed to manage `tokenId`.
839      *
840      * Requirements:
841      *
842      * - `tokenId` must exist.
843      */
844     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
845         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
846         address owner = ERC721.ownerOf(tokenId);
847         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
848     }
849 
850     /**
851      * @dev Safely mints `tokenId` and transfers it to `to`.
852      *
853      * Requirements:
854      *
855      * - `tokenId` must not exist.
856      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
857      *
858      * Emits a {Transfer} event.
859      */
860     function _safeMint(address to, uint256 tokenId) internal virtual {
861         _safeMint(to, tokenId, "");
862     }
863 
864     /**
865      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
866      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
867      */
868     function _safeMint(
869         address to,
870         uint256 tokenId,
871         bytes memory _data
872     ) internal virtual {
873         _mint(to, tokenId);
874         require(
875             _checkOnERC721Received(address(0), to, tokenId, _data),
876             "ERC721: transfer to non ERC721Receiver implementer"
877         );
878     }
879 
880     /**
881      * @dev Mints `tokenId` and transfers it to `to`.
882      *
883      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
884      *
885      * Requirements:
886      *
887      * - `tokenId` must not exist.
888      * - `to` cannot be the zero address.
889      *
890      * Emits a {Transfer} event.
891      */
892     function _mint(address to, uint256 tokenId) internal virtual {
893         require(to != address(0), "ERC721: mint to the zero address");
894         require(!_exists(tokenId), "ERC721: token already minted");
895 
896         _beforeTokenTransfer(address(0), to, tokenId);
897 
898         _balances[to] += 1;
899         _owners[tokenId] = to;
900 
901         emit Transfer(address(0), to, tokenId);
902     }
903 
904     /**
905      * @dev Destroys `tokenId`.
906      * The approval is cleared when the token is burned.
907      *
908      * Requirements:
909      *
910      * - `tokenId` must exist.
911      *
912      * Emits a {Transfer} event.
913      */
914     function _burn(uint256 tokenId) internal virtual {
915         address owner = ERC721.ownerOf(tokenId);
916 
917         _beforeTokenTransfer(owner, address(0), tokenId);
918 
919         // Clear approvals
920         _approve(address(0), tokenId);
921 
922         _balances[owner] -= 1;
923         delete _owners[tokenId];
924 
925         emit Transfer(owner, address(0), tokenId);
926     }
927 
928     /**
929      * @dev Transfers `tokenId` from `from` to `to`.
930      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
931      *
932      * Requirements:
933      *
934      * - `to` cannot be the zero address.
935      * - `tokenId` token must be owned by `from`.
936      *
937      * Emits a {Transfer} event.
938      */
939     function _transfer(
940         address from,
941         address to,
942         uint256 tokenId
943     ) internal virtual {
944         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
945         require(to != address(0), "ERC721: transfer to the zero address");
946 
947         _beforeTokenTransfer(from, to, tokenId);
948 
949         // Clear approvals from the previous owner
950         _approve(address(0), tokenId);
951 
952         _balances[from] -= 1;
953         _balances[to] += 1;
954         _owners[tokenId] = to;
955 
956         emit Transfer(from, to, tokenId);
957     }
958 
959     /**
960      * @dev Approve `to` to operate on `tokenId`
961      *
962      * Emits a {Approval} event.
963      */
964     function _approve(address to, uint256 tokenId) internal virtual {
965         _tokenApprovals[tokenId] = to;
966         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
967     }
968 
969     /**
970      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
971      * The call is not executed if the target address is not a contract.
972      *
973      * @param from address representing the previous owner of the given token ID
974      * @param to target address that will receive the tokens
975      * @param tokenId uint256 ID of the token to be transferred
976      * @param _data bytes optional data to send along with the call
977      * @return bool whether the call correctly returned the expected magic value
978      */
979     function _checkOnERC721Received(
980         address from,
981         address to,
982         uint256 tokenId,
983         bytes memory _data
984     ) private returns (bool) {
985         if (to.isContract()) {
986             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
987                 return retval == IERC721Receiver.onERC721Received.selector;
988             } catch (bytes memory reason) {
989                 if (reason.length == 0) {
990                     revert("ERC721: transfer to non ERC721Receiver implementer");
991                 } else {
992                     assembly {
993                         revert(add(32, reason), mload(reason))
994                     }
995                 }
996             }
997         } else {
998             return true;
999         }
1000     }
1001 
1002     /**
1003      * @dev Hook that is called before any token transfer. This includes minting
1004      * and burning.
1005      *
1006      * Calling conditions:
1007      *
1008      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1009      * transferred to `to`.
1010      * - When `from` is zero, `tokenId` will be minted for `to`.
1011      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1012      * - `from` and `to` are never both zero.
1013      *
1014      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1015      */
1016     function _beforeTokenTransfer(
1017         address from,
1018         address to,
1019         uint256 tokenId
1020     ) internal virtual {}
1021 }
1022 
1023 
1024 pragma solidity ^0.8.0;
1025 
1026 
1027 contract AnimoonPotion is Ownable, ERC721 {
1028     
1029 
1030     uint constant maxSupply = 1000;
1031     uint public totalSupply = 0;
1032     bool public public_sale_status = false;
1033     uint public minimumrequired = 2;
1034     string public baseURI;
1035     uint public maxPerTransaction = 1;  //Max Limit for Sale
1036     uint public maxPerWallet = 1; //Max Limit perwallet
1037          
1038     constructor() ERC721("Animoon Potion", "Potion"){}
1039 
1040    function buy(uint _count) public payable {
1041          require(public_sale_status == true, "Sale is Paused.");
1042         require(_count == 1, "mint at least one token");
1043          require(checknftholder(msg.sender) >= minimumrequired, "You do not have enough Animoon nfts");
1044         require(balanceOf(msg.sender) < 1, "you already minted");
1045         require(totalSupply + _count <= maxSupply, "Not enough tokens left");
1046         
1047         for(uint i = 0; i < _count; i++)
1048             _safeMint(msg.sender, totalSupply + 1 + i);
1049         totalSupply += _count;
1050     }
1051 
1052 
1053     function sendGifts(address[] memory _wallets) public onlyOwner{
1054         require(_wallets.length > 0, "mint at least one token");
1055         require(_wallets.length <= maxPerTransaction, "max per transaction 20");
1056         require(totalSupply + _wallets.length <= maxSupply, "not enough tokens left");
1057         for(uint i = 0; i < _wallets.length; i++)
1058             _safeMint(_wallets[i], totalSupply + 1 + i);
1059         totalSupply += _wallets.length;
1060     }
1061 
1062     function setBaseUri(string memory _uri) external onlyOwner {
1063         baseURI = _uri;
1064     }
1065 
1066     function publicSale_status(bool temp) external onlyOwner {
1067         public_sale_status = temp;
1068     }
1069     function _baseURI() internal view virtual override returns (string memory) {
1070         return baseURI;
1071     }
1072    function withdraw() external onlyOwner {
1073         payable(owner()).transfer(address(this).balance);
1074     }
1075 
1076  function checknftholder(address recnft) public view returns(uint) {
1077     address othercontractadd = 0x988a3e9834f1a4977e6F727E18EA167089349bA2;
1078     IERC20 tokenob = IERC20(othercontractadd);
1079     return tokenob.balanceOf(recnft);
1080   }
1081 
1082 }