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
580 pragma solidity ^0.8.0;
581 
582 
583 /**
584  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
585  * @dev See https://eips.ethereum.org/EIPS/eip-721
586  */
587 interface IERC721Metadata is IERC721 {
588     /**
589      * @dev Returns the token collection name.
590      */
591     function name() external view returns (string memory);
592 
593     /**
594      * @dev Returns the token collection symbol.
595      */
596     function symbol() external view returns (string memory);
597 
598     /**
599      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
600      */
601     function tokenURI(uint256 tokenId) external view returns (string memory);
602 }
603 pragma solidity ^0.8.0;
604 
605 
606 /**
607  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
608  * the Metadata extension, but not including the Enumerable extension, which is available separately as
609  * {ERC721Enumerable}.
610  */
611 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
612     using Address for address;
613     using Strings for uint256;
614 
615     // Token name
616     string private _name;
617 
618     // Token symbol
619     string private _symbol;
620 
621     // Mapping from token ID to owner address
622     mapping(uint256 => address) private _owners;
623 
624     // Mapping owner address to token count
625     mapping(address => uint256) private _balances;
626 
627     // Mapping from token ID to approved address
628     mapping(uint256 => address) private _tokenApprovals;
629 
630     // Mapping from owner to operator approvals
631     mapping(address => mapping(address => bool)) private _operatorApprovals;
632 
633     /**
634      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
635      */
636     constructor(string memory name_, string memory symbol_) {
637         _name = name_;
638         _symbol = symbol_;
639     }
640 
641     /**
642      * @dev See {IERC165-supportsInterface}.
643      */
644     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
645         return
646             interfaceId == type(IERC721).interfaceId ||
647             interfaceId == type(IERC721Metadata).interfaceId ||
648             super.supportsInterface(interfaceId);
649     }
650 
651     /**
652      * @dev See {IERC721-balanceOf}.
653      */
654     function balanceOf(address owner) public view virtual override returns (uint256) {
655         require(owner != address(0), "ERC721: balance query for the zero address");
656         return _balances[owner];
657     }
658 
659     /**
660      * @dev See {IERC721-ownerOf}.
661      */
662     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
663         address owner = _owners[tokenId];
664         require(owner != address(0), "ERC721: owner query for nonexistent token");
665         return owner;
666     }
667 
668     /**
669      * @dev See {IERC721Metadata-name}.
670      */
671     function name() public view virtual override returns (string memory) {
672         return _name;
673     }
674 
675     /**
676      * @dev See {IERC721Metadata-symbol}.
677      */
678     function symbol() public view virtual override returns (string memory) {
679         return _symbol;
680     }
681 
682     /**
683      * @dev See {IERC721Metadata-tokenURI}.
684      */
685     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
686         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
687 
688         string memory baseURI = _baseURI();
689         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
690     }
691 
692     /**
693      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
694      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
695      * by default, can be overriden in child contracts.
696      */
697     function _baseURI() internal view virtual returns (string memory) {
698         return "";
699     }
700 
701     /**
702      * @dev See {IERC721-approve}.
703      */
704     function approve(address to, uint256 tokenId) public virtual override {
705         address owner = ERC721.ownerOf(tokenId);
706         require(to != owner, "ERC721: approval to current owner");
707 
708         require(
709             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
710             "ERC721: approve caller is not owner nor approved for all"
711         );
712 
713         _approve(to, tokenId);
714     }
715 
716     /**
717      * @dev See {IERC721-getApproved}.
718      */
719     function getApproved(uint256 tokenId) public view virtual override returns (address) {
720         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
721 
722         return _tokenApprovals[tokenId];
723     }
724 
725     /**
726      * @dev See {IERC721-setApprovalForAll}.
727      */
728     function setApprovalForAll(address operator, bool approved) public virtual override {
729         require(operator != _msgSender(), "ERC721: approve to caller");
730 
731         _operatorApprovals[_msgSender()][operator] = approved;
732         emit ApprovalForAll(_msgSender(), operator, approved);
733     }
734 
735     /**
736      * @dev See {IERC721-isApprovedForAll}.
737      */
738     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
739         return _operatorApprovals[owner][operator];
740     }
741 
742     /**
743      * @dev See {IERC721-transferFrom}.
744      */
745     function transferFrom(
746         address from,
747         address to,
748         uint256 tokenId
749     ) public virtual override {
750         //solhint-disable-next-line max-line-length
751         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
752 
753         _transfer(from, to, tokenId);
754     }
755 
756     /**
757      * @dev See {IERC721-safeTransferFrom}.
758      */
759     function safeTransferFrom(
760         address from,
761         address to,
762         uint256 tokenId
763     ) public virtual override {
764         safeTransferFrom(from, to, tokenId, "");
765     }
766 
767     /**
768      * @dev See {IERC721-safeTransferFrom}.
769      */
770     function safeTransferFrom(
771         address from,
772         address to,
773         uint256 tokenId,
774         bytes memory _data
775     ) public virtual override {
776         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
777         _safeTransfer(from, to, tokenId, _data);
778     }
779 
780     /**
781      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
782      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
783      *
784      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
785      *
786      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
787      * implement alternative mechanisms to perform token transfer, such as signature-based.
788      *
789      * Requirements:
790      *
791      * - `from` cannot be the zero address.
792      * - `to` cannot be the zero address.
793      * - `tokenId` token must exist and be owned by `from`.
794      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
795      *
796      * Emits a {Transfer} event.
797      */
798     function _safeTransfer(
799         address from,
800         address to,
801         uint256 tokenId,
802         bytes memory _data
803     ) internal virtual {
804         _transfer(from, to, tokenId);
805         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
806     }
807 
808     /**
809      * @dev Returns whether `tokenId` exists.
810      *
811      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
812      *
813      * Tokens start existing when they are minted (`_mint`),
814      * and stop existing when they are burned (`_burn`).
815      */
816     function _exists(uint256 tokenId) internal view virtual returns (bool) {
817         return _owners[tokenId] != address(0);
818     }
819 
820     /**
821      * @dev Returns whether `spender` is allowed to manage `tokenId`.
822      *
823      * Requirements:
824      *
825      * - `tokenId` must exist.
826      */
827     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
828         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
829         address owner = ERC721.ownerOf(tokenId);
830         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
831     }
832 
833     /**
834      * @dev Safely mints `tokenId` and transfers it to `to`.
835      *
836      * Requirements:
837      *
838      * - `tokenId` must not exist.
839      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
840      *
841      * Emits a {Transfer} event.
842      */
843     function _safeMint(address to, uint256 tokenId) internal virtual {
844         _safeMint(to, tokenId, "");
845     }
846 
847     /**
848      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
849      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
850      */
851     function _safeMint(
852         address to,
853         uint256 tokenId,
854         bytes memory _data
855     ) internal virtual {
856         _mint(to, tokenId);
857         require(
858             _checkOnERC721Received(address(0), to, tokenId, _data),
859             "ERC721: transfer to non ERC721Receiver implementer"
860         );
861     }
862 
863     /**
864      * @dev Mints `tokenId` and transfers it to `to`.
865      *
866      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
867      *
868      * Requirements:
869      *
870      * - `tokenId` must not exist.
871      * - `to` cannot be the zero address.
872      *
873      * Emits a {Transfer} event.
874      */
875     function _mint(address to, uint256 tokenId) internal virtual {
876         require(to != address(0), "ERC721: mint to the zero address");
877         require(!_exists(tokenId), "ERC721: token already minted");
878 
879         _beforeTokenTransfer(address(0), to, tokenId);
880 
881         _balances[to] += 1;
882         _owners[tokenId] = to;
883 
884         emit Transfer(address(0), to, tokenId);
885     }
886 
887     /**
888      * @dev Destroys `tokenId`.
889      * The approval is cleared when the token is burned.
890      *
891      * Requirements:
892      *
893      * - `tokenId` must exist.
894      *
895      * Emits a {Transfer} event.
896      */
897     function _burn(uint256 tokenId) internal virtual {
898         address owner = ERC721.ownerOf(tokenId);
899 
900         _beforeTokenTransfer(owner, address(0), tokenId);
901 
902         // Clear approvals
903         _approve(address(0), tokenId);
904 
905         _balances[owner] -= 1;
906         delete _owners[tokenId];
907 
908         emit Transfer(owner, address(0), tokenId);
909     }
910 
911     /**
912      * @dev Transfers `tokenId` from `from` to `to`.
913      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
914      *
915      * Requirements:
916      *
917      * - `to` cannot be the zero address.
918      * - `tokenId` token must be owned by `from`.
919      *
920      * Emits a {Transfer} event.
921      */
922     function _transfer(
923         address from,
924         address to,
925         uint256 tokenId
926     ) internal virtual {
927         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
928         require(to != address(0), "ERC721: transfer to the zero address");
929 
930         _beforeTokenTransfer(from, to, tokenId);
931 
932         // Clear approvals from the previous owner
933         _approve(address(0), tokenId);
934 
935         _balances[from] -= 1;
936         _balances[to] += 1;
937         _owners[tokenId] = to;
938 
939         emit Transfer(from, to, tokenId);
940     }
941 
942     /**
943      * @dev Approve `to` to operate on `tokenId`
944      *
945      * Emits a {Approval} event.
946      */
947     function _approve(address to, uint256 tokenId) internal virtual {
948         _tokenApprovals[tokenId] = to;
949         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
950     }
951 
952     /**
953      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
954      * The call is not executed if the target address is not a contract.
955      *
956      * @param from address representing the previous owner of the given token ID
957      * @param to target address that will receive the tokens
958      * @param tokenId uint256 ID of the token to be transferred
959      * @param _data bytes optional data to send along with the call
960      * @return bool whether the call correctly returned the expected magic value
961      */
962     function _checkOnERC721Received(
963         address from,
964         address to,
965         uint256 tokenId,
966         bytes memory _data
967     ) private returns (bool) {
968         if (to.isContract()) {
969             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
970                 return retval == IERC721Receiver.onERC721Received.selector;
971             } catch (bytes memory reason) {
972                 if (reason.length == 0) {
973                     revert("ERC721: transfer to non ERC721Receiver implementer");
974                 } else {
975                     assembly {
976                         revert(add(32, reason), mload(reason))
977                     }
978                 }
979             }
980         } else {
981             return true;
982         }
983     }
984 
985     /**
986      * @dev Hook that is called before any token transfer. This includes minting
987      * and burning.
988      *
989      * Calling conditions:
990      *
991      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
992      * transferred to `to`.
993      * - When `from` is zero, `tokenId` will be minted for `to`.
994      * - When `to` is zero, ``from``'s `tokenId` will be burned.
995      * - `from` and `to` are never both zero.
996      *
997      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
998      */
999     function _beforeTokenTransfer(
1000         address from,
1001         address to,
1002         uint256 tokenId
1003     ) internal virtual {}
1004 }
1005 
1006 
1007 pragma solidity ^0.8.0;
1008 
1009 
1010 contract QBC is Ownable, ERC721 {
1011     
1012     uint public tokenPrice = 0.08 ether;
1013     uint constant maxSupply = 2929;
1014     uint public presale_price = 0.06 ether;
1015     uint public totalSupply = 0;
1016 
1017     bool public Presale_status = false;
1018     bool public public_sale_status = false;
1019     
1020     mapping(address => bool) private presaleList;
1021     mapping(address => uint) private buyers_list;
1022 
1023     string public baseURI;
1024     uint public maxPerTransaction = 7;  //Max Limit for Sale
1025     uint public _walletLimit=50; //Max Limit for perwallet
1026   
1027          
1028     constructor() ERC721("Quit Bitching Coalition NFT", "QBC"){}
1029 
1030    function buy(uint _count) public payable{
1031          require(public_sale_status == true, "Sale is Paused.");
1032          require(checkbuyer() + _count <= _walletLimit, "Wallet limit Reached");
1033         require(_count > 0, "mint at least one token");
1034         require(_count <= maxPerTransaction, "max per transaction 20");
1035         require(totalSupply + _count <= maxSupply, "Not enough tokens left");
1036         require(msg.value >= tokenPrice * _count, "incorrect ether amount");
1037        
1038       
1039         for(uint i = 0; i < _count; i++)
1040        { _safeMint(msg.sender, totalSupply + 1);
1041              totalSupply += 1; 
1042              addbuyer();
1043            }
1044 
1045     }
1046 
1047    function buy_presale(uint _count) public payable{ 
1048         require(Presale_status == true, "Sale is Paused.");
1049         require(checkbuyer() + _count <= _walletLimit, "Wallet limit Reached");
1050         require(checkPresale() == true, "You are not in Presale List.");
1051         require(_count > 0, "mint at least one token");
1052         require(_count <= maxPerTransaction, "max per transaction 20");
1053         require(totalSupply + _count<= maxSupply, "Not enough tokens left");
1054         require(msg.value >= presale_price * _count, "incorrect ether amount");
1055         
1056        
1057          for(uint i = 0; i < _count; i++)
1058              { _safeMint(msg.sender, totalSupply + 1);
1059                totalSupply += 1; 
1060                addbuyer();
1061            }
1062     }
1063 
1064     function sendGifts(address[] memory _wallets) public onlyOwner{
1065         require(_wallets.length > 0, "mint at least one token");
1066         require(totalSupply + _wallets.length <= maxSupply, "not enough tokens left");
1067         for(uint i = 0; i < _wallets.length; i++)
1068             _safeMint(_wallets[i], totalSupply + 1 + i);
1069         totalSupply += _wallets.length;
1070     }
1071     
1072     function addPresaleList(address[] memory _wallets) public onlyOwner{
1073         for(uint i; i < _wallets.length; i++)
1074             presaleList[_wallets[i]] = true;
1075     }
1076     
1077     function is_presale_active() public view returns(uint){
1078         require(Presale_status == true,"Sale not Started Yet.");
1079         return 1;
1080      }
1081       function is_sale_active() public view returns(uint){
1082       require(public_sale_status == true,"Sale not Started Yet.");
1083         return 1;
1084      }
1085      function checkPresale() public view returns(bool){
1086         return presaleList[msg.sender];
1087     }
1088     function setBaseUri(string memory _uri) external onlyOwner {
1089         baseURI = _uri;
1090     }
1091      function pre_Sale_status(bool temp) external onlyOwner {
1092         Presale_status = temp;
1093     }
1094     function publicSale_status(bool temp) external onlyOwner {
1095         public_sale_status = temp;
1096     }
1097      function update_public_price(uint price) external onlyOwner {
1098         tokenPrice = price;
1099     }
1100        function update_preSale_price(uint price) external onlyOwner {
1101         presale_price = price;
1102     }
1103   
1104     function _baseURI() internal view virtual override returns (string memory) {
1105         return baseURI;
1106     }
1107 
1108     function addbuyer() internal {
1109          buyers_list[msg.sender] = buyers_list[msg.sender] + 1;
1110     }
1111     
1112     function checkbuyer() public view returns (uint) {
1113        
1114          return buyers_list[msg.sender];
1115     }
1116 
1117     function update_wallet_limit(uint number) external onlyOwner {
1118       _walletLimit = number;
1119     }
1120 
1121     function update_transaction_limit(uint number) external onlyOwner {
1122       maxPerTransaction = number;
1123     }
1124 
1125     function withdraw() external onlyOwner {
1126                uint _balance = address(this).balance;
1127         payable(owner()).transfer(_balance); //Owner
1128 
1129     }
1130 
1131 
1132 }