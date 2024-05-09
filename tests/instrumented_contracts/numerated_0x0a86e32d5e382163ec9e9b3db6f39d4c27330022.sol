1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 //Written by Blockchainguy.net
6 //tg: @sherazmanzoor
7 
8 /**
9  * @dev Provides information about the current execution context, including the
10  * sender of the transaction and its data. While these are generally available
11  * via msg.sender and msg.data, they should not be accessed in such a direct
12  * manner, since when dealing with meta-transactions the account sending and
13  * paying for execution may not be the actual sender (as far as an application
14  * is concerned).
15  *
16  * This contract is only required for intermediate, library-like contracts.
17  */
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes calldata) {
24         return msg.data;
25     }
26 }
27 pragma solidity ^0.8.0;
28 
29 /**
30  * @dev String operations.
31  */
32 library Strings {
33     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
34 
35     /**
36      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
37      */
38     function toString(uint256 value) internal pure returns (string memory) {
39         // Inspired by OraclizeAPI's implementation - MIT licence
40         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
41 
42         if (value == 0) {
43             return "0";
44         }
45         uint256 temp = value;
46         uint256 digits;
47         while (temp != 0) {
48             digits++;
49             temp /= 10;
50         }
51         bytes memory buffer = new bytes(digits);
52         while (value != 0) {
53             digits -= 1;
54             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
55             value /= 10;
56         }
57         return string(buffer);
58     }
59 
60     /**
61      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
62      */
63     function toHexString(uint256 value) internal pure returns (string memory) {
64         if (value == 0) {
65             return "0x00";
66         }
67         uint256 temp = value;
68         uint256 length = 0;
69         while (temp != 0) {
70             length++;
71             temp >>= 8;
72         }
73         return toHexString(value, length);
74     }
75 
76     /**
77      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
78      */
79     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
80         bytes memory buffer = new bytes(2 * length + 2);
81         buffer[0] = "0";
82         buffer[1] = "x";
83         for (uint256 i = 2 * length + 1; i > 1; --i) {
84             buffer[i] = _HEX_SYMBOLS[value & 0xf];
85             value >>= 4;
86         }
87         require(value == 0, "Strings: hex length insufficient");
88         return string(buffer);
89     }
90 }
91 pragma solidity ^0.8.0;
92 
93 /**
94  * @dev Collection of functions related to the address type
95  */
96 library Address {
97     /**
98      * @dev Returns true if `account` is a contract.
99      *
100      * [IMPORTANT]
101      * ====
102      * It is unsafe to assume that an address for which this function returns
103      * false is an externally-owned account (EOA) and not a contract.
104      *
105      * Among others, `isContract` will return false for the following
106      * types of addresses:
107      *
108      *  - an externally-owned account
109      *  - a contract in construction
110      *  - an address where a contract will be created
111      *  - an address where a contract lived, but was destroyed
112      * ====
113      */
114     function isContract(address account) internal view returns (bool) {
115         // This method relies on extcodesize, which returns 0 for contracts in
116         // construction, since the code is only stored at the end of the
117         // constructor execution.
118 
119         uint256 size;
120         assembly {
121             size := extcodesize(account)
122         }
123         return size > 0;
124     }
125 
126     /**
127      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
128      * `recipient`, forwarding all available gas and reverting on errors.
129      *
130      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
131      * of certain opcodes, possibly making contracts go over the 2300 gas limit
132      * imposed by `transfer`, making them unable to receive funds via
133      * `transfer`. {sendValue} removes this limitation.
134      *
135      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
136      *
137      * IMPORTANT: because control is transferred to `recipient`, care must be
138      * taken to not create reentrancy vulnerabilities. Consider using
139      * {ReentrancyGuard} or the
140      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
141      */
142     function sendValue(address payable recipient, uint256 amount) internal {
143         require(address(this).balance >= amount, "Address: insufficient balance");
144 
145         (bool success, ) = recipient.call{value: amount}("");
146         require(success, "Address: unable to send value, recipient may have reverted");
147     }
148 
149     /**
150      * @dev Performs a Solidity function call using a low level `call`. A
151      * plain `call` is an unsafe replacement for a function call: use this
152      * function instead.
153      *
154      * If `target` reverts with a revert reason, it is bubbled up by this
155      * function (like regular Solidity function calls).
156      *
157      * Returns the raw returned data. To convert to the expected return value,
158      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
159      *
160      * Requirements:
161      *
162      * - `target` must be a contract.
163      * - calling `target` with `data` must not revert.
164      *
165      * _Available since v3.1._
166      */
167     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
168         return functionCall(target, data, "Address: low-level call failed");
169     }
170 
171     /**
172      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
173      * `errorMessage` as a fallback revert reason when `target` reverts.
174      *
175      * _Available since v3.1._
176      */
177     function functionCall(
178         address target,
179         bytes memory data,
180         string memory errorMessage
181     ) internal returns (bytes memory) {
182         return functionCallWithValue(target, data, 0, errorMessage);
183     }
184 
185     /**
186      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
187      * but also transferring `value` wei to `target`.
188      *
189      * Requirements:
190      *
191      * - the calling contract must have an ETH balance of at least `value`.
192      * - the called Solidity function must be `payable`.
193      *
194      * _Available since v3.1._
195      */
196     function functionCallWithValue(
197         address target,
198         bytes memory data,
199         uint256 value
200     ) internal returns (bytes memory) {
201         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
202     }
203 
204     /**
205      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
206      * with `errorMessage` as a fallback revert reason when `target` reverts.
207      *
208      * _Available since v3.1._
209      */
210     function functionCallWithValue(
211         address target,
212         bytes memory data,
213         uint256 value,
214         string memory errorMessage
215     ) internal returns (bytes memory) {
216         require(address(this).balance >= value, "Address: insufficient balance for call");
217         require(isContract(target), "Address: call to non-contract");
218 
219         (bool success, bytes memory returndata) = target.call{value: value}(data);
220         return verifyCallResult(success, returndata, errorMessage);
221     }
222 
223     /**
224      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
225      * but performing a static call.
226      *
227      * _Available since v3.3._
228      */
229     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
230         return functionStaticCall(target, data, "Address: low-level static call failed");
231     }
232 
233     /**
234      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
235      * but performing a static call.
236      *
237      * _Available since v3.3._
238      */
239     function functionStaticCall(
240         address target,
241         bytes memory data,
242         string memory errorMessage
243     ) internal view returns (bytes memory) {
244         require(isContract(target), "Address: static call to non-contract");
245 
246         (bool success, bytes memory returndata) = target.staticcall(data);
247         return verifyCallResult(success, returndata, errorMessage);
248     }
249 
250     /**
251      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
252      * but performing a delegate call.
253      *
254      * _Available since v3.4._
255      */
256     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
257         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
258     }
259 
260     /**
261      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
262      * but performing a delegate call.
263      *
264      * _Available since v3.4._
265      */
266     function functionDelegateCall(
267         address target,
268         bytes memory data,
269         string memory errorMessage
270     ) internal returns (bytes memory) {
271         require(isContract(target), "Address: delegate call to non-contract");
272 
273         (bool success, bytes memory returndata) = target.delegatecall(data);
274         return verifyCallResult(success, returndata, errorMessage);
275     }
276 
277     /**
278      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
279      * revert reason using the provided one.
280      *
281      * _Available since v4.3._
282      */
283     function verifyCallResult(
284         bool success,
285         bytes memory returndata,
286         string memory errorMessage
287     ) internal pure returns (bytes memory) {
288         if (success) {
289             return returndata;
290         } else {
291             // Look for revert reason and bubble it up if present
292             if (returndata.length > 0) {
293                 // The easiest way to bubble the revert reason is using memory via assembly
294 
295                 assembly {
296                     let returndata_size := mload(returndata)
297                     revert(add(32, returndata), returndata_size)
298                 }
299             } else {
300                 revert(errorMessage);
301             }
302         }
303     }
304 }
305 pragma solidity ^0.8.0;
306 
307 /**
308  * @dev Interface of the ERC165 standard, as defined in the
309  * https://eips.ethereum.org/EIPS/eip-165[EIP].
310  *
311  * Implementers can declare support of contract interfaces, which can then be
312  * queried by others ({ERC165Checker}).
313  *
314  * For an implementation, see {ERC165}.
315  */
316 interface IERC165 {
317     /**
318      * @dev Returns true if this contract implements the interface defined by
319      * `interfaceId`. See the corresponding
320      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
321      * to learn more about how these ids are created.
322      *
323      * This function call must use less than 30 000 gas.
324      */
325     function supportsInterface(bytes4 interfaceId) external view returns (bool);
326 }
327 pragma solidity ^0.8.0;
328 
329 /**
330  * @title ERC721 token receiver interface
331  * @dev Interface for any contract that wants to support safeTransfers
332  * from ERC721 asset contracts.
333  */
334 interface IERC721Receiver {
335     /**
336      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
337      * by `operator` from `from`, this function is called.
338      *
339      * It must return its Solidity selector to confirm the token transfer.
340      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
341      *
342      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
343      */
344     function onERC721Received(
345         address operator,
346         address from,
347         uint256 tokenId,
348         bytes calldata data
349     ) external returns (bytes4);
350 }
351 pragma solidity ^0.8.0;
352 
353 
354 /**
355  * @dev Contract module which provides a basic access control mechanism, where
356  * there is an account (an owner) that can be granted exclusive access to
357  * specific functions.
358  *
359  * By default, the owner account will be the one that deploys the contract. This
360  * can later be changed with {transferOwnership}.
361  *
362  * This module is used through inheritance. It will make available the modifier
363  * `onlyOwner`, which can be applied to your functions to restrict their use to
364  * the owner.
365  */
366 abstract contract Ownable is Context {
367     address private _owner;
368 
369     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
370 
371     /**
372      * @dev Initializes the contract setting the deployer as the initial owner.
373      */
374     constructor() {
375         _setOwner(_msgSender());
376     }
377 
378     /**
379      * @dev Returns the address of the current owner.
380      */
381     function owner() public view virtual returns (address) {
382         return _owner;
383     }
384 
385     /**
386      * @dev Throws if called by any account other than the owner.
387      */
388     modifier onlyOwner() {
389         require(owner() == _msgSender(), "Ownable: caller is not the owner");
390         _;
391     }
392 
393     /**
394      * @dev Leaves the contract without owner. It will not be possible to call
395      * `onlyOwner` functions anymore. Can only be called by the current owner.
396      *
397      * NOTE: Renouncing ownership will leave the contract without an owner,
398      * thereby removing any functionality that is only available to the owner.
399      */
400     function renounceOwnership() public virtual onlyOwner {
401         _setOwner(address(0));
402     }
403 
404     /**
405      * @dev Transfers ownership of the contract to a new account (`newOwner`).
406      * Can only be called by the current owner.
407      */
408     function transferOwnership(address newOwner) public virtual onlyOwner {
409         require(newOwner != address(0), "Ownable: new owner is the zero address");
410         _setOwner(newOwner);
411     }
412 
413     function _setOwner(address newOwner) private {
414         address oldOwner = _owner;
415         _owner = newOwner;
416         emit OwnershipTransferred(oldOwner, newOwner);
417     }
418 }
419 pragma solidity ^0.8.0;
420 
421 
422 /**
423  * @dev Implementation of the {IERC165} interface.
424  *
425  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
426  * for the additional interface id that will be supported. For example:
427  *
428  * ```solidity
429  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
430  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
431  * }
432  * ```
433  *
434  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
435  */
436 abstract contract ERC165 is IERC165 {
437     /**
438      * @dev See {IERC165-supportsInterface}.
439      */
440     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
441         return interfaceId == type(IERC165).interfaceId;
442     }
443 }
444 pragma solidity ^0.8.0;
445 
446 
447 /**
448  * @dev Required interface of an ERC721 compliant contract.
449  */
450 interface IERC721 is IERC165 {
451     /**
452      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
453      */
454     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
455 
456     /**
457      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
458      */
459     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
460 
461     /**
462      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
463      */
464     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
465 
466     /**
467      * @dev Returns the number of tokens in ``owner``'s account.
468      */
469     function balanceOf(address owner) external view returns (uint256 balance);
470 
471     /**
472      * @dev Returns the owner of the `tokenId` token.
473      *
474      * Requirements:
475      *
476      * - `tokenId` must exist.
477      */
478     function ownerOf(uint256 tokenId) external view returns (address owner);
479 
480     /**
481      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
482      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
483      *
484      * Requirements:
485      *
486      * - `from` cannot be the zero address.
487      * - `to` cannot be the zero address.
488      * - `tokenId` token must exist and be owned by `from`.
489      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
490      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
491      *
492      * Emits a {Transfer} event.
493      */
494     function safeTransferFrom(
495         address from,
496         address to,
497         uint256 tokenId
498     ) external;
499 
500     /**
501      * @dev Transfers `tokenId` token from `from` to `to`.
502      *
503      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
504      *
505      * Requirements:
506      *
507      * - `from` cannot be the zero address.
508      * - `to` cannot be the zero address.
509      * - `tokenId` token must be owned by `from`.
510      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
511      *
512      * Emits a {Transfer} event.
513      */
514     function transferFrom(
515         address from,
516         address to,
517         uint256 tokenId
518     ) external;
519 
520     /**
521      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
522      * The approval is cleared when the token is transferred.
523      *
524      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
525      *
526      * Requirements:
527      *
528      * - The caller must own the token or be an approved operator.
529      * - `tokenId` must exist.
530      *
531      * Emits an {Approval} event.
532      */
533     function approve(address to, uint256 tokenId) external;
534 
535     /**
536      * @dev Returns the account approved for `tokenId` token.
537      *
538      * Requirements:
539      *
540      * - `tokenId` must exist.
541      */
542     function getApproved(uint256 tokenId) external view returns (address operator);
543 
544     /**
545      * @dev Approve or remove `operator` as an operator for the caller.
546      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
547      *
548      * Requirements:
549      *
550      * - The `operator` cannot be the caller.
551      *
552      * Emits an {ApprovalForAll} event.
553      */
554     function setApprovalForAll(address operator, bool _approved) external;
555 
556     /**
557      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
558      *
559      * See {setApprovalForAll}
560      */
561     function isApprovedForAll(address owner, address operator) external view returns (bool);
562 
563     /**
564      * @dev Safely transfers `tokenId` token from `from` to `to`.
565      *
566      * Requirements:
567      *
568      * - `from` cannot be the zero address.
569      * - `to` cannot be the zero address.
570      * - `tokenId` token must exist and be owned by `from`.
571      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
572      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
573      *
574      * Emits a {Transfer} event.
575      */
576     function safeTransferFrom(
577         address from,
578         address to,
579         uint256 tokenId,
580         bytes calldata data
581     ) external;
582 }
583 pragma solidity ^0.8.0;
584 
585 
586 /**
587  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
588  * @dev See https://eips.ethereum.org/EIPS/eip-721
589  */
590 interface IERC721Metadata is IERC721 {
591     /**
592      * @dev Returns the token collection name.
593      */
594     function name() external view returns (string memory);
595 
596     /**
597      * @dev Returns the token collection symbol.
598      */
599     function symbol() external view returns (string memory);
600 
601     /**
602      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
603      */
604     function tokenURI(uint256 tokenId) external view returns (string memory);
605 }
606 pragma solidity ^0.8.0;
607 
608 
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
1007 }pragma solidity ^0.8.0;
1008 
1009 
1010 contract TheGreatBrainsClub is Ownable, ERC721 {
1011     uint constant tokenPrice = 0.07 ether;
1012     uint constant maxSupply = 10000;
1013     
1014     uint public totalSupply = 0;
1015     
1016     uint public sale_startTime = 1634497200;
1017     uint public nft_reveal_time = 1634605200;
1018     
1019     bool public pause_sale = false;
1020 
1021 
1022     string public baseURI;
1023     
1024 
1025     constructor() ERC721("The Great Brains Club", "GBC"){}
1026 
1027    function buy(uint _count) public payable{
1028         require(_count > 0, "mint at least one token");
1029         require(_count <= 20, "Max 20 Allowed.");
1030         require(totalSupply + _count <= maxSupply, "Not enough tokens left");
1031         require(msg.value == tokenPrice * _count, "incorrect ether amount");
1032         require(block.timestamp >= sale_startTime,"Sale not Started Yet.");
1033         require(pause_sale == false, "Sale is Paused.");
1034 
1035         
1036         for(uint i = 0; i < _count; i++)
1037             _safeMint(msg.sender, totalSupply + 1 + i);
1038             
1039             totalSupply += _count;
1040     }
1041 
1042 
1043     function sendGifts(address[] memory _wallets) public onlyOwner{
1044         require(totalSupply + _wallets.length <= maxSupply, "not enough tokens left");
1045         for(uint i = 0; i < _wallets.length; i++)
1046             _safeMint(_wallets[i], totalSupply + 1 + i);
1047         totalSupply += _wallets.length;
1048     }
1049     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1050         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1051         if(block.timestamp <= nft_reveal_time){
1052             return "https://gateway.pinata.cloud/ipfs/Qmc2qBUHHkTH1egg3FaY6qYaeBZ3GkAWkgsecjKjMRWNs2";
1053         }
1054         
1055         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, Strings.toString(tokenId))) : "";
1056     }
1057 
1058 
1059     function update_reveal_time(uint time) external onlyOwner{
1060         nft_reveal_time = time;
1061     }
1062     
1063 
1064     function setBaseUri(string memory _uri) external onlyOwner {
1065         baseURI = _uri;
1066     }
1067     function setPauseSale(bool temp) external onlyOwner {
1068         pause_sale = temp;
1069     }
1070     
1071     function _baseURI() internal view virtual override returns (string memory) {
1072         return baseURI;
1073     }
1074     function set_start_time(uint256 time) external onlyOwner{
1075         sale_startTime = time;
1076     }
1077 
1078     function withdraw() external onlyOwner {
1079         payable(owner()).transfer(address(this).balance);
1080     }
1081 }