1 /**
2  *Submitted for verification at Etherscan.io on 2021-09-22
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2021-09-21
7 */
8 
9 // SPDX-License-Identifier: MIT
10 
11 pragma solidity ^0.8.0;
12 
13 /**
14  * @dev Provides information about the current execution context, including the
15  * sender of the transaction and its data. While these are generally available
16  * via msg.sender and msg.data, they should not be accessed in such a direct
17  * manner, since when dealing with meta-transactions the account sending and
18  * paying for execution may not be the actual sender (as far as an application
19  * is concerned).
20  *
21  * This contract is only required for intermediate, library-like contracts.
22  */
23 abstract contract Context {
24     function _msgSender() internal view virtual returns (address) {
25         return msg.sender;
26     }
27 
28     function _msgData() internal view virtual returns (bytes calldata) {
29         return msg.data;
30     }
31 }
32 pragma solidity ^0.8.0;
33 
34 /**
35  * @dev String operations.
36  */
37 library Strings {
38     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
39 
40     /**
41      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
42      */
43     function toString(uint256 value) internal pure returns (string memory) {
44         // Inspired by OraclizeAPI's implementation - MIT licence
45         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
46 
47         if (value == 0) {
48             return "0";
49         }
50         uint256 temp = value;
51         uint256 digits;
52         while (temp != 0) {
53             digits++;
54             temp /= 10;
55         }
56         bytes memory buffer = new bytes(digits);
57         while (value != 0) {
58             digits -= 1;
59             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
60             value /= 10;
61         }
62         return string(buffer);
63     }
64 
65     /**
66      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
67      */
68     function toHexString(uint256 value) internal pure returns (string memory) {
69         if (value == 0) {
70             return "0x00";
71         }
72         uint256 temp = value;
73         uint256 length = 0;
74         while (temp != 0) {
75             length++;
76             temp >>= 8;
77         }
78         return toHexString(value, length);
79     }
80 
81     /**
82      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
83      */
84     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
85         bytes memory buffer = new bytes(2 * length + 2);
86         buffer[0] = "0";
87         buffer[1] = "x";
88         for (uint256 i = 2 * length + 1; i > 1; --i) {
89             buffer[i] = _HEX_SYMBOLS[value & 0xf];
90             value >>= 4;
91         }
92         require(value == 0, "Strings: hex length insufficient");
93         return string(buffer);
94     }
95 }
96 pragma solidity ^0.8.0;
97 
98 /**
99  * @dev Collection of functions related to the address type
100  */
101 library Address {
102     /**
103      * @dev Returns true if `account` is a contract.
104      *
105      * [IMPORTANT]
106      * ====
107      * It is unsafe to assume that an address for which this function returns
108      * false is an externally-owned account (EOA) and not a contract.
109      *
110      * Among others, `isContract` will return false for the following
111      * types of addresses:
112      *
113      *  - an externally-owned account
114      *  - a contract in construction
115      *  - an address where a contract will be created
116      *  - an address where a contract lived, but was destroyed
117      * ====
118      */
119     function isContract(address account) internal view returns (bool) {
120         // This method relies on extcodesize, which returns 0 for contracts in
121         // construction, since the code is only stored at the end of the
122         // constructor execution.
123 
124         uint256 size;
125         assembly {
126             size := extcodesize(account)
127         }
128         return size > 0;
129     }
130 
131     /**
132      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
133      * `recipient`, forwarding all available gas and reverting on errors.
134      *
135      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
136      * of certain opcodes, possibly making contracts go over the 2300 gas limit
137      * imposed by `transfer`, making them unable to receive funds via
138      * `transfer`. {sendValue} removes this limitation.
139      *
140      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
141      *
142      * IMPORTANT: because control is transferred to `recipient`, care must be
143      * taken to not create reentrancy vulnerabilities. Consider using
144      * {ReentrancyGuard} or the
145      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
146      */
147     function sendValue(address payable recipient, uint256 amount) internal {
148         require(address(this).balance >= amount, "Address: insufficient balance");
149 
150         (bool success, ) = recipient.call{value: amount}("");
151         require(success, "Address: unable to send value, recipient may have reverted");
152     }
153 
154     /**
155      * @dev Performs a Solidity function call using a low level `call`. A
156      * plain `call` is an unsafe replacement for a function call: use this
157      * function instead.
158      *
159      * If `target` reverts with a revert reason, it is bubbled up by this
160      * function (like regular Solidity function calls).
161      *
162      * Returns the raw returned data. To convert to the expected return value,
163      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
164      *
165      * Requirements:
166      *
167      * - `target` must be a contract.
168      * - calling `target` with `data` must not revert.
169      *
170      * _Available since v3.1._
171      */
172     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
173         return functionCall(target, data, "Address: low-level call failed");
174     }
175 
176     /**
177      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
178      * `errorMessage` as a fallback revert reason when `target` reverts.
179      *
180      * _Available since v3.1._
181      */
182     function functionCall(
183         address target,
184         bytes memory data,
185         string memory errorMessage
186     ) internal returns (bytes memory) {
187         return functionCallWithValue(target, data, 0, errorMessage);
188     }
189 
190     /**
191      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
192      * but also transferring `value` wei to `target`.
193      *
194      * Requirements:
195      *
196      * - the calling contract must have an ETH balance of at least `value`.
197      * - the called Solidity function must be `payable`.
198      *
199      * _Available since v3.1._
200      */
201     function functionCallWithValue(
202         address target,
203         bytes memory data,
204         uint256 value
205     ) internal returns (bytes memory) {
206         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
207     }
208 
209     /**
210      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
211      * with `errorMessage` as a fallback revert reason when `target` reverts.
212      *
213      * _Available since v3.1._
214      */
215     function functionCallWithValue(
216         address target,
217         bytes memory data,
218         uint256 value,
219         string memory errorMessage
220     ) internal returns (bytes memory) {
221         require(address(this).balance >= value, "Address: insufficient balance for call");
222         require(isContract(target), "Address: call to non-contract");
223 
224         (bool success, bytes memory returndata) = target.call{value: value}(data);
225         return verifyCallResult(success, returndata, errorMessage);
226     }
227 
228     /**
229      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
230      * but performing a static call.
231      *
232      * _Available since v3.3._
233      */
234     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
235         return functionStaticCall(target, data, "Address: low-level static call failed");
236     }
237 
238     /**
239      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
240      * but performing a static call.
241      *
242      * _Available since v3.3._
243      */
244     function functionStaticCall(
245         address target,
246         bytes memory data,
247         string memory errorMessage
248     ) internal view returns (bytes memory) {
249         require(isContract(target), "Address: static call to non-contract");
250 
251         (bool success, bytes memory returndata) = target.staticcall(data);
252         return verifyCallResult(success, returndata, errorMessage);
253     }
254 
255     /**
256      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
257      * but performing a delegate call.
258      *
259      * _Available since v3.4._
260      */
261     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
262         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
263     }
264 
265     /**
266      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
267      * but performing a delegate call.
268      *
269      * _Available since v3.4._
270      */
271     function functionDelegateCall(
272         address target,
273         bytes memory data,
274         string memory errorMessage
275     ) internal returns (bytes memory) {
276         require(isContract(target), "Address: delegate call to non-contract");
277 
278         (bool success, bytes memory returndata) = target.delegatecall(data);
279         return verifyCallResult(success, returndata, errorMessage);
280     }
281 
282     /**
283      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
284      * revert reason using the provided one.
285      *
286      * _Available since v4.3._
287      */
288     function verifyCallResult(
289         bool success,
290         bytes memory returndata,
291         string memory errorMessage
292     ) internal pure returns (bytes memory) {
293         if (success) {
294             return returndata;
295         } else {
296             // Look for revert reason and bubble it up if present
297             if (returndata.length > 0) {
298                 // The easiest way to bubble the revert reason is using memory via assembly
299 
300                 assembly {
301                     let returndata_size := mload(returndata)
302                     revert(add(32, returndata), returndata_size)
303                 }
304             } else {
305                 revert(errorMessage);
306             }
307         }
308     }
309 }
310 pragma solidity ^0.8.0;
311 
312 /**
313  * @dev Interface of the ERC165 standard, as defined in the
314  * https://eips.ethereum.org/EIPS/eip-165[EIP].
315  *
316  * Implementers can declare support of contract interfaces, which can then be
317  * queried by others ({ERC165Checker}).
318  *
319  * For an implementation, see {ERC165}.
320  */
321 interface IERC165 {
322     /**
323      * @dev Returns true if this contract implements the interface defined by
324      * `interfaceId`. See the corresponding
325      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
326      * to learn more about how these ids are created.
327      *
328      * This function call must use less than 30 000 gas.
329      */
330     function supportsInterface(bytes4 interfaceId) external view returns (bool);
331 }
332 pragma solidity ^0.8.0;
333 
334 /**
335  * @title ERC721 token receiver interface
336  * @dev Interface for any contract that wants to support safeTransfers
337  * from ERC721 asset contracts.
338  */
339 interface IERC721Receiver {
340     /**
341      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
342      * by `operator` from `from`, this function is called.
343      *
344      * It must return its Solidity selector to confirm the token transfer.
345      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
346      *
347      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
348      */
349     function onERC721Received(
350         address operator,
351         address from,
352         uint256 tokenId,
353         bytes calldata data
354     ) external returns (bytes4);
355 }
356 pragma solidity ^0.8.0;
357 
358 
359 /**
360  * @dev Contract module which provides a basic access control mechanism, where
361  * there is an account (an owner) that can be granted exclusive access to
362  * specific functions.
363  *
364  * By default, the owner account will be the one that deploys the contract. This
365  * can later be changed with {transferOwnership}.
366  *
367  * This module is used through inheritance. It will make available the modifier
368  * `onlyOwner`, which can be applied to your functions to restrict their use to
369  * the owner.
370  */
371 abstract contract Ownable is Context {
372     address private _owner;
373 
374     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
375 
376     /**
377      * @dev Initializes the contract setting the deployer as the initial owner.
378      */
379     constructor() {
380         _setOwner(_msgSender());
381     }
382 
383     /**
384      * @dev Returns the address of the current owner.
385      */
386     function owner() public view virtual returns (address) {
387         return _owner;
388     }
389 
390     /**
391      * @dev Throws if called by any account other than the owner.
392      */
393     modifier onlyOwner() {
394         require(owner() == _msgSender(), "Ownable: caller is not the owner");
395         _;
396     }
397 
398     /**
399      * @dev Leaves the contract without owner. It will not be possible to call
400      * `onlyOwner` functions anymore. Can only be called by the current owner.
401      *
402      * NOTE: Renouncing ownership will leave the contract without an owner,
403      * thereby removing any functionality that is only available to the owner.
404      */
405     function renounceOwnership() public virtual onlyOwner {
406         _setOwner(address(0));
407     }
408 
409     /**
410      * @dev Transfers ownership of the contract to a new account (`newOwner`).
411      * Can only be called by the current owner.
412      */
413     function transferOwnership(address newOwner) public virtual onlyOwner {
414         require(newOwner != address(0), "Ownable: new owner is the zero address");
415         _setOwner(newOwner);
416     }
417 
418     function _setOwner(address newOwner) private {
419         address oldOwner = _owner;
420         _owner = newOwner;
421         emit OwnershipTransferred(oldOwner, newOwner);
422     }
423 }
424 pragma solidity ^0.8.0;
425 
426 
427 /**
428  * @dev Implementation of the {IERC165} interface.
429  *
430  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
431  * for the additional interface id that will be supported. For example:
432  *
433  * ```solidity
434  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
435  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
436  * }
437  * ```
438  *
439  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
440  */
441 abstract contract ERC165 is IERC165 {
442     /**
443      * @dev See {IERC165-supportsInterface}.
444      */
445     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
446         return interfaceId == type(IERC165).interfaceId;
447     }
448 }
449 pragma solidity ^0.8.0;
450 
451 
452 /**
453  * @dev Required interface of an ERC721 compliant contract.
454  */
455 interface IERC721 is IERC165 {
456     /**
457      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
458      */
459     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
460 
461     /**
462      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
463      */
464     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
465 
466     /**
467      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
468      */
469     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
470 
471     /**
472      * @dev Returns the number of tokens in ``owner``'s account.
473      */
474     function balanceOf(address owner) external view returns (uint256 balance);
475 
476     /**
477      * @dev Returns the owner of the `tokenId` token.
478      *
479      * Requirements:
480      *
481      * - `tokenId` must exist.
482      */
483     function ownerOf(uint256 tokenId) external view returns (address owner);
484 
485     /**
486      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
487      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
488      *
489      * Requirements:
490      *
491      * - `from` cannot be the zero address.
492      * - `to` cannot be the zero address.
493      * - `tokenId` token must exist and be owned by `from`.
494      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
495      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
496      *
497      * Emits a {Transfer} event.
498      */
499     function safeTransferFrom(
500         address from,
501         address to,
502         uint256 tokenId
503     ) external;
504 
505     /**
506      * @dev Transfers `tokenId` token from `from` to `to`.
507      *
508      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
509      *
510      * Requirements:
511      *
512      * - `from` cannot be the zero address.
513      * - `to` cannot be the zero address.
514      * - `tokenId` token must be owned by `from`.
515      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
516      *
517      * Emits a {Transfer} event.
518      */
519     function transferFrom(
520         address from,
521         address to,
522         uint256 tokenId
523     ) external;
524 
525     /**
526      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
527      * The approval is cleared when the token is transferred.
528      *
529      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
530      *
531      * Requirements:
532      *
533      * - The caller must own the token or be an approved operator.
534      * - `tokenId` must exist.
535      *
536      * Emits an {Approval} event.
537      */
538     function approve(address to, uint256 tokenId) external;
539 
540     /**
541      * @dev Returns the account approved for `tokenId` token.
542      *
543      * Requirements:
544      *
545      * - `tokenId` must exist.
546      */
547     function getApproved(uint256 tokenId) external view returns (address operator);
548 
549     /**
550      * @dev Approve or remove `operator` as an operator for the caller.
551      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
552      *
553      * Requirements:
554      *
555      * - The `operator` cannot be the caller.
556      *
557      * Emits an {ApprovalForAll} event.
558      */
559     function setApprovalForAll(address operator, bool _approved) external;
560 
561     /**
562      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
563      *
564      * See {setApprovalForAll}
565      */
566     function isApprovedForAll(address owner, address operator) external view returns (bool);
567 
568     /**
569      * @dev Safely transfers `tokenId` token from `from` to `to`.
570      *
571      * Requirements:
572      *
573      * - `from` cannot be the zero address.
574      * - `to` cannot be the zero address.
575      * - `tokenId` token must exist and be owned by `from`.
576      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
577      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
578      *
579      * Emits a {Transfer} event.
580      */
581     function safeTransferFrom(
582         address from,
583         address to,
584         uint256 tokenId,
585         bytes calldata data
586     ) external;
587 }
588 pragma solidity ^0.8.0;
589 
590 
591 /**
592  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
593  * @dev See https://eips.ethereum.org/EIPS/eip-721
594  */
595 interface IERC721Metadata is IERC721 {
596     /**
597      * @dev Returns the token collection name.
598      */
599     function name() external view returns (string memory);
600 
601     /**
602      * @dev Returns the token collection symbol.
603      */
604     function symbol() external view returns (string memory);
605 
606     /**
607      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
608      */
609     function tokenURI(uint256 tokenId) external view returns (string memory);
610 }
611 pragma solidity ^0.8.0;
612 
613 
614 /**
615  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
616  * the Metadata extension, but not including the Enumerable extension, which is available separately as
617  * {ERC721Enumerable}.
618  */
619 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
620     using Address for address;
621     using Strings for uint256;
622 
623     // Token name
624     string private _name;
625 
626     // Token symbol
627     string private _symbol;
628 
629     // Mapping from token ID to owner address
630     mapping(uint256 => address) private _owners;
631 
632     // Mapping owner address to token count
633     mapping(address => uint256) private _balances;
634 
635     // Mapping from token ID to approved address
636     mapping(uint256 => address) private _tokenApprovals;
637 
638     // Mapping from owner to operator approvals
639     mapping(address => mapping(address => bool)) private _operatorApprovals;
640 
641     /**
642      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
643      */
644     constructor(string memory name_, string memory symbol_) {
645         _name = name_;
646         _symbol = symbol_;
647     }
648 
649     /**
650      * @dev See {IERC165-supportsInterface}.
651      */
652     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
653         return
654             interfaceId == type(IERC721).interfaceId ||
655             interfaceId == type(IERC721Metadata).interfaceId ||
656             super.supportsInterface(interfaceId);
657     }
658 
659     /**
660      * @dev See {IERC721-balanceOf}.
661      */
662     function balanceOf(address owner) public view virtual override returns (uint256) {
663         require(owner != address(0), "ERC721: balance query for the zero address");
664         return _balances[owner];
665     }
666 
667     /**
668      * @dev See {IERC721-ownerOf}.
669      */
670     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
671         address owner = _owners[tokenId];
672         require(owner != address(0), "ERC721: owner query for nonexistent token");
673         return owner;
674     }
675 
676     /**
677      * @dev See {IERC721Metadata-name}.
678      */
679     function name() public view virtual override returns (string memory) {
680         return _name;
681     }
682 
683     /**
684      * @dev See {IERC721Metadata-symbol}.
685      */
686     function symbol() public view virtual override returns (string memory) {
687         return _symbol;
688     }
689 
690     /**
691      * @dev See {IERC721Metadata-tokenURI}.
692      */
693     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
694         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
695 
696         string memory baseURI = _baseURI();
697         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
698     }
699 
700     /**
701      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
702      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
703      * by default, can be overriden in child contracts.
704      */
705     function _baseURI() internal view virtual returns (string memory) {
706         return "";
707     }
708 
709     /**
710      * @dev See {IERC721-approve}.
711      */
712     function approve(address to, uint256 tokenId) public virtual override {
713         address owner = ERC721.ownerOf(tokenId);
714         require(to != owner, "ERC721: approval to current owner");
715 
716         require(
717             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
718             "ERC721: approve caller is not owner nor approved for all"
719         );
720 
721         _approve(to, tokenId);
722     }
723 
724     /**
725      * @dev See {IERC721-getApproved}.
726      */
727     function getApproved(uint256 tokenId) public view virtual override returns (address) {
728         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
729 
730         return _tokenApprovals[tokenId];
731     }
732 
733     /**
734      * @dev See {IERC721-setApprovalForAll}.
735      */
736     function setApprovalForAll(address operator, bool approved) public virtual override {
737         require(operator != _msgSender(), "ERC721: approve to caller");
738 
739         _operatorApprovals[_msgSender()][operator] = approved;
740         emit ApprovalForAll(_msgSender(), operator, approved);
741     }
742 
743     /**
744      * @dev See {IERC721-isApprovedForAll}.
745      */
746     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
747         return _operatorApprovals[owner][operator];
748     }
749 
750     /**
751      * @dev See {IERC721-transferFrom}.
752      */
753     function transferFrom(
754         address from,
755         address to,
756         uint256 tokenId
757     ) public virtual override {
758         //solhint-disable-next-line max-line-length
759         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
760 
761         _transfer(from, to, tokenId);
762     }
763 
764     /**
765      * @dev See {IERC721-safeTransferFrom}.
766      */
767     function safeTransferFrom(
768         address from,
769         address to,
770         uint256 tokenId
771     ) public virtual override {
772         safeTransferFrom(from, to, tokenId, "");
773     }
774 
775     /**
776      * @dev See {IERC721-safeTransferFrom}.
777      */
778     function safeTransferFrom(
779         address from,
780         address to,
781         uint256 tokenId,
782         bytes memory _data
783     ) public virtual override {
784         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
785         _safeTransfer(from, to, tokenId, _data);
786     }
787 
788     /**
789      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
790      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
791      *
792      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
793      *
794      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
795      * implement alternative mechanisms to perform token transfer, such as signature-based.
796      *
797      * Requirements:
798      *
799      * - `from` cannot be the zero address.
800      * - `to` cannot be the zero address.
801      * - `tokenId` token must exist and be owned by `from`.
802      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
803      *
804      * Emits a {Transfer} event.
805      */
806     function _safeTransfer(
807         address from,
808         address to,
809         uint256 tokenId,
810         bytes memory _data
811     ) internal virtual {
812         _transfer(from, to, tokenId);
813         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
814     }
815 
816     /**
817      * @dev Returns whether `tokenId` exists.
818      *
819      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
820      *
821      * Tokens start existing when they are minted (`_mint`),
822      * and stop existing when they are burned (`_burn`).
823      */
824     function _exists(uint256 tokenId) internal view virtual returns (bool) {
825         return _owners[tokenId] != address(0);
826     }
827 
828     /**
829      * @dev Returns whether `spender` is allowed to manage `tokenId`.
830      *
831      * Requirements:
832      *
833      * - `tokenId` must exist.
834      */
835     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
836         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
837         address owner = ERC721.ownerOf(tokenId);
838         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
839     }
840 
841     /**
842      * @dev Safely mints `tokenId` and transfers it to `to`.
843      *
844      * Requirements:
845      *
846      * - `tokenId` must not exist.
847      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
848      *
849      * Emits a {Transfer} event.
850      */
851     function _safeMint(address to, uint256 tokenId) internal virtual {
852         _safeMint(to, tokenId, "");
853     }
854 
855     /**
856      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
857      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
858      */
859     function _safeMint(
860         address to,
861         uint256 tokenId,
862         bytes memory _data
863     ) internal virtual {
864         _mint(to, tokenId);
865         require(
866             _checkOnERC721Received(address(0), to, tokenId, _data),
867             "ERC721: transfer to non ERC721Receiver implementer"
868         );
869     }
870 
871     /**
872      * @dev Mints `tokenId` and transfers it to `to`.
873      *
874      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
875      *
876      * Requirements:
877      *
878      * - `tokenId` must not exist.
879      * - `to` cannot be the zero address.
880      *
881      * Emits a {Transfer} event.
882      */
883     function _mint(address to, uint256 tokenId) internal virtual {
884         require(to != address(0), "ERC721: mint to the zero address");
885         require(!_exists(tokenId), "ERC721: token already minted");
886 
887         _beforeTokenTransfer(address(0), to, tokenId);
888 
889         _balances[to] += 1;
890         _owners[tokenId] = to;
891 
892         emit Transfer(address(0), to, tokenId);
893     }
894 
895     /**
896      * @dev Destroys `tokenId`.
897      * The approval is cleared when the token is burned.
898      *
899      * Requirements:
900      *
901      * - `tokenId` must exist.
902      *
903      * Emits a {Transfer} event.
904      */
905     function _burn(uint256 tokenId) internal virtual {
906         address owner = ERC721.ownerOf(tokenId);
907 
908         _beforeTokenTransfer(owner, address(0), tokenId);
909 
910         // Clear approvals
911         _approve(address(0), tokenId);
912 
913         _balances[owner] -= 1;
914         delete _owners[tokenId];
915 
916         emit Transfer(owner, address(0), tokenId);
917     }
918 
919     /**
920      * @dev Transfers `tokenId` from `from` to `to`.
921      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
922      *
923      * Requirements:
924      *
925      * - `to` cannot be the zero address.
926      * - `tokenId` token must be owned by `from`.
927      *
928      * Emits a {Transfer} event.
929      */
930     function _transfer(
931         address from,
932         address to,
933         uint256 tokenId
934     ) internal virtual {
935         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
936         require(to != address(0), "ERC721: transfer to the zero address");
937 
938         _beforeTokenTransfer(from, to, tokenId);
939 
940         // Clear approvals from the previous owner
941         _approve(address(0), tokenId);
942 
943         _balances[from] -= 1;
944         _balances[to] += 1;
945         _owners[tokenId] = to;
946 
947         emit Transfer(from, to, tokenId);
948     }
949 
950     /**
951      * @dev Approve `to` to operate on `tokenId`
952      *
953      * Emits a {Approval} event.
954      */
955     function _approve(address to, uint256 tokenId) internal virtual {
956         _tokenApprovals[tokenId] = to;
957         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
958     }
959 
960     /**
961      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
962      * The call is not executed if the target address is not a contract.
963      *
964      * @param from address representing the previous owner of the given token ID
965      * @param to target address that will receive the tokens
966      * @param tokenId uint256 ID of the token to be transferred
967      * @param _data bytes optional data to send along with the call
968      * @return bool whether the call correctly returned the expected magic value
969      */
970     function _checkOnERC721Received(
971         address from,
972         address to,
973         uint256 tokenId,
974         bytes memory _data
975     ) private returns (bool) {
976         if (to.isContract()) {
977             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
978                 return retval == IERC721Receiver.onERC721Received.selector;
979             } catch (bytes memory reason) {
980                 if (reason.length == 0) {
981                     revert("ERC721: transfer to non ERC721Receiver implementer");
982                 } else {
983                     assembly {
984                         revert(add(32, reason), mload(reason))
985                     }
986                 }
987             }
988         } else {
989             return true;
990         }
991     }
992 
993     /**
994      * @dev Hook that is called before any token transfer. This includes minting
995      * and burning.
996      *
997      * Calling conditions:
998      *
999      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1000      * transferred to `to`.
1001      * - When `from` is zero, `tokenId` will be minted for `to`.
1002      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1003      * - `from` and `to` are never both zero.
1004      *
1005      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1006      */
1007     function _beforeTokenTransfer(
1008         address from,
1009         address to,
1010         uint256 tokenId
1011     ) internal virtual {}
1012 }pragma solidity ^0.8.0;
1013 
1014 
1015 contract PowerPups is Ownable, ERC721 {
1016     uint constant tokenPrice = 0.05 ether;
1017     uint constant maxSupply = 10000;
1018     
1019     uint public totalSupply = 0;
1020     
1021     uint public sale_startTime = 1634763600;
1022     bool public pause_sale = false;
1023 
1024     string public baseURI;
1025 
1026     constructor() ERC721("Power Pups", "PP"){}
1027 
1028    function buy(uint _count) public payable{
1029         require(_count > 0, "mint at least one token");
1030         require(_count <= 20, "Max 20 Allowed.");
1031         require(totalSupply + _count <= maxSupply, "Not enough tokens left");
1032         require(msg.value == tokenPrice * _count, "incorrect ether amount");
1033         require(block.timestamp >= sale_startTime,"Sale not Started Yet.");
1034         require(pause_sale == false, "Sale is Paused.");
1035         
1036         for(uint i = 0; i < _count; i++)
1037             _safeMint(msg.sender, totalSupply + 1 + i);
1038             
1039             totalSupply += _count;
1040     }
1041 
1042     function sendGifts(address[] memory _wallets) public onlyOwner{
1043         require(totalSupply + _wallets.length <= maxSupply, "not enough tokens left");
1044         for(uint i = 0; i < _wallets.length; i++)
1045             _safeMint(_wallets[i], totalSupply + 1 + i);
1046         totalSupply += _wallets.length;
1047     }
1048 
1049     function setBaseUri(string memory _uri) external onlyOwner {
1050         baseURI = _uri;
1051     }
1052     function setPauseSale(bool temp) external onlyOwner {
1053         pause_sale = temp;
1054     }
1055     
1056     function _baseURI() internal view virtual override returns (string memory) {
1057         return baseURI;
1058     }
1059     function set_start_time(uint256 time) external onlyOwner{
1060         sale_startTime = time;
1061     }
1062 
1063     function withdraw() external onlyOwner {
1064         payable(owner()).transfer(address(this).balance);
1065     }
1066 }