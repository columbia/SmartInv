1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.2;
3 
4 /**
5  * @dev Interface of the ERC165 standard, as defined in the
6  * https://eips.ethereum.org/EIPS/eip-165[EIP].
7  *
8  * Implementers can declare support of contract interfaces, which can then be
9  * queried by others ({ERC165Checker}).
10  *
11  * For an implementation, see {ERC165}.
12  */
13 interface IERC165 {
14     /**
15      * @dev Returns true if this contract implements the interface defined by
16      * `interfaceId`. See the corresponding
17      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
18      * to learn more about how these ids are created.
19      *
20      * This function call must use less than 30 000 gas.
21      */
22     function supportsInterface(bytes4 interfaceId) external view returns (bool);
23 }
24 
25 /**
26  * @dev Required interface of an ERC721 compliant contract.
27  */
28 interface IERC721 is IERC165 {
29     /**
30      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
31      */
32     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
33 
34     /**
35      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
36      */
37     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
38 
39     /**
40      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
41      */
42     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
43 
44     /**
45      * @dev Returns the number of tokens in ``owner``'s account.
46      */
47     function balanceOf(address owner) external view returns (uint256 balance);
48 
49     /**
50      * @dev Returns the owner of the `tokenId` token.
51      *
52      * Requirements:
53      *
54      * - `tokenId` must exist.
55      */
56     function ownerOf(uint256 tokenId) external view returns (address owner);
57 
58     /**
59      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
60      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
61      *
62      * Requirements:
63      *
64      * - `from` cannot be the zero address.
65      * - `to` cannot be the zero address.
66      * - `tokenId` token must exist and be owned by `from`.
67      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
68      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
69      *
70      * Emits a {Transfer} event.
71      */
72     function safeTransferFrom(
73         address from,
74         address to,
75         uint256 tokenId
76     ) external;
77 
78     /**
79      * @dev Transfers `tokenId` token from `from` to `to`.
80      *
81      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
82      *
83      * Requirements:
84      *
85      * - `from` cannot be the zero address.
86      * - `to` cannot be the zero address.
87      * - `tokenId` token must be owned by `from`.
88      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
89      *
90      * Emits a {Transfer} event.
91      */
92     function transferFrom(
93         address from,
94         address to,
95         uint256 tokenId
96     ) external;
97 
98     /**
99      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
100      * The approval is cleared when the token is transferred.
101      *
102      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
103      *
104      * Requirements:
105      *
106      * - The caller must own the token or be an approved operator.
107      * - `tokenId` must exist.
108      *
109      * Emits an {Approval} event.
110      */
111     function approve(address to, uint256 tokenId) external;
112 
113     /**
114      * @dev Returns the account approved for `tokenId` token.
115      *
116      * Requirements:
117      *
118      * - `tokenId` must exist.
119      */
120     function getApproved(uint256 tokenId) external view returns (address operator);
121 
122     /**
123      * @dev Approve or remove `operator` as an operator for the caller.
124      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
125      *
126      * Requirements:
127      *
128      * - The `operator` cannot be the caller.
129      *
130      * Emits an {ApprovalForAll} event.
131      */
132     function setApprovalForAll(address operator, bool _approved) external;
133 
134     /**
135      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
136      *
137      * See {setApprovalForAll}
138      */
139     function isApprovedForAll(address owner, address operator) external view returns (bool);
140 
141     /**
142      * @dev Safely transfers `tokenId` token from `from` to `to`.
143      *
144      * Requirements:
145      *
146      * - `from` cannot be the zero address.
147      * - `to` cannot be the zero address.
148      * - `tokenId` token must exist and be owned by `from`.
149      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
150      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
151      *
152      * Emits a {Transfer} event.
153      */
154     function safeTransferFrom(
155         address from,
156         address to,
157         uint256 tokenId,
158         bytes calldata data
159     ) external;
160 }
161 
162 /**
163  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
164  * @dev See https://eips.ethereum.org/EIPS/eip-721
165  */
166 interface IERC721Enumerable is IERC721 {
167     /**
168      * @dev Returns the total amount of tokens stored by the contract.
169      */
170     function totalSupply() external view returns (uint256);
171 
172     /**
173      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
174      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
175      */
176     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
177 
178     /**
179      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
180      * Use along with {totalSupply} to enumerate all tokens.
181      */
182     function tokenByIndex(uint256 index) external view returns (uint256);
183 }
184 
185 /**
186  * @dev Implementation of the {IERC165} interface.
187  *
188  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
189  * for the additional interface id that will be supported. For example:
190  *
191  * ```solidity
192  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
193  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
194  * }
195  * ```
196  *
197  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
198  */
199 abstract contract ERC165 is IERC165 {
200     /**
201      * @dev See {IERC165-supportsInterface}.
202      */
203     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
204         return interfaceId == type(IERC165).interfaceId;
205     }
206 }
207 
208 /**
209  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
210  * @dev See https://eips.ethereum.org/EIPS/eip-721
211  */
212 interface IERC721Metadata is IERC721 {
213     /**
214      * @dev Returns the token collection name.
215      */
216     function name() external view returns (string memory);
217 
218     /**
219      * @dev Returns the token collection symbol.
220      */
221     function symbol() external view returns (string memory);
222 
223     /**
224      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
225      */
226     function tokenURI(uint256 tokenId) external view returns (string memory);
227 }
228 
229 /**
230  * @title ERC721 token receiver interface
231  * @dev Interface for any contract that wants to support safeTransfers
232  * from ERC721 asset contracts.
233  */
234 interface IERC721Receiver {
235     /**
236      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
237      * by `operator` from `from`, this function is called.
238      *
239      * It must return its Solidity selector to confirm the token transfer.
240      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
241      *
242      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
243      */
244     function onERC721Received(
245         address operator,
246         address from,
247         uint256 tokenId,
248         bytes calldata data
249     ) external returns (bytes4);
250 }
251 
252 /**
253  * @dev Collection of functions related to the address type
254  */
255 library Address {
256     /**
257      * @dev Returns true if `account` is a contract.
258      *
259      * [IMPORTANT]
260      * ====
261      * It is unsafe to assume that an address for which this function returns
262      * false is an externally-owned account (EOA) and not a contract.
263      *
264      * Among others, `isContract` will return false for the following
265      * types of addresses:
266      *
267      *  - an externally-owned account
268      *  - a contract in construction
269      *  - an address where a contract will be created
270      *  - an address where a contract lived, but was destroyed
271      * ====
272      */
273     function isContract(address account) internal view returns (bool) {
274         // This method relies on extcodesize, which returns 0 for contracts in
275         // construction, since the code is only stored at the end of the
276         // constructor execution.
277 
278         uint256 size;
279         assembly {
280             size := extcodesize(account)
281         }
282         return size > 0;
283     }
284 
285     /**
286      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
287      * `recipient`, forwarding all available gas and reverting on errors.
288      *
289      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
290      * of certain opcodes, possibly making contracts go over the 2300 gas limit
291      * imposed by `transfer`, making them unable to receive funds via
292      * `transfer`. {sendValue} removes this limitation.
293      *
294      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
295      *
296      * IMPORTANT: because control is transferred to `recipient`, care must be
297      * taken to not create reentrancy vulnerabilities. Consider using
298      * {ReentrancyGuard} or the
299      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
300      */
301     function sendValue(address payable recipient, uint256 amount) internal {
302         require(address(this).balance >= amount, "Address: insufficient balance");
303 
304         (bool success, ) = recipient.call{value: amount}("");
305         require(success, "Address: unable to send value, recipient may have reverted");
306     }
307 
308     /**
309      * @dev Performs a Solidity function call using a low level `call`. A
310      * plain `call` is an unsafe replacement for a function call: use this
311      * function instead.
312      *
313      * If `target` reverts with a revert reason, it is bubbled up by this
314      * function (like regular Solidity function calls).
315      *
316      * Returns the raw returned data. To convert to the expected return value,
317      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
318      *
319      * Requirements:
320      *
321      * - `target` must be a contract.
322      * - calling `target` with `data` must not revert.
323      *
324      * _Available since v3.1._
325      */
326     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
327         return functionCall(target, data, "Address: low-level call failed");
328     }
329 
330     /**
331      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
332      * `errorMessage` as a fallback revert reason when `target` reverts.
333      *
334      * _Available since v3.1._
335      */
336     function functionCall(
337         address target,
338         bytes memory data,
339         string memory errorMessage
340     ) internal returns (bytes memory) {
341         return functionCallWithValue(target, data, 0, errorMessage);
342     }
343 
344     /**
345      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
346      * but also transferring `value` wei to `target`.
347      *
348      * Requirements:
349      *
350      * - the calling contract must have an ETH balance of at least `value`.
351      * - the called Solidity function must be `payable`.
352      *
353      * _Available since v3.1._
354      */
355     function functionCallWithValue(
356         address target,
357         bytes memory data,
358         uint256 value
359     ) internal returns (bytes memory) {
360         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
361     }
362 
363     /**
364      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
365      * with `errorMessage` as a fallback revert reason when `target` reverts.
366      *
367      * _Available since v3.1._
368      */
369     function functionCallWithValue(
370         address target,
371         bytes memory data,
372         uint256 value,
373         string memory errorMessage
374     ) internal returns (bytes memory) {
375         require(address(this).balance >= value, "Address: insufficient balance for call");
376         require(isContract(target), "Address: call to non-contract");
377 
378         (bool success, bytes memory returndata) = target.call{value: value}(data);
379         return verifyCallResult(success, returndata, errorMessage);
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
398     function functionStaticCall(
399         address target,
400         bytes memory data,
401         string memory errorMessage
402     ) internal view returns (bytes memory) {
403         require(isContract(target), "Address: static call to non-contract");
404 
405         (bool success, bytes memory returndata) = target.staticcall(data);
406         return verifyCallResult(success, returndata, errorMessage);
407     }
408 
409     /**
410      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
411      * but performing a delegate call.
412      *
413      * _Available since v3.4._
414      */
415     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
416         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
417     }
418 
419     /**
420      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
421      * but performing a delegate call.
422      *
423      * _Available since v3.4._
424      */
425     function functionDelegateCall(
426         address target,
427         bytes memory data,
428         string memory errorMessage
429     ) internal returns (bytes memory) {
430         require(isContract(target), "Address: delegate call to non-contract");
431 
432         (bool success, bytes memory returndata) = target.delegatecall(data);
433         return verifyCallResult(success, returndata, errorMessage);
434     }
435 
436     /**
437      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
438      * revert reason using the provided one.
439      *
440      * _Available since v4.3._
441      */
442     function verifyCallResult(
443         bool success,
444         bytes memory returndata,
445         string memory errorMessage
446     ) internal pure returns (bytes memory) {
447         if (success) {
448             return returndata;
449         } else {
450             // Look for revert reason and bubble it up if present
451             if (returndata.length > 0) {
452                 // The easiest way to bubble the revert reason is using memory via assembly
453 
454                 assembly {
455                     let returndata_size := mload(returndata)
456                     revert(add(32, returndata), returndata_size)
457                 }
458             } else {
459                 revert(errorMessage);
460             }
461         }
462     }
463 }
464 
465 /**
466  * @dev Provides information about the current execution context, including the
467  * sender of the transaction and its data. While these are generally available
468  * via msg.sender and msg.data, they should not be accessed in such a direct
469  * manner, since when dealing with meta-transactions the account sending and
470  * paying for execution may not be the actual sender (as far as an application
471  * is concerned).
472  *
473  * This contract is only required for intermediate, library-like contracts.
474  */
475 abstract contract Context {
476     function _msgSender() internal view virtual returns (address) {
477         return msg.sender;
478     }
479 
480     function _msgData() internal view virtual returns (bytes calldata) {
481         return msg.data;
482     }
483 }
484 
485 /**
486  * @dev String operations.
487  */
488 library Strings {
489     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
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
540             buffer[i] = _HEX_SYMBOLS[value & 0xf];
541             value >>= 4;
542         }
543         require(value == 0, "Strings: hex length insufficient");
544         return string(buffer);
545     }
546 }
547 
548 /**
549  * @dev Contract module which provides a basic access control mechanism, where
550  * there is an account (an owner) that can be granted exclusive access to
551  * specific functions.
552  *
553  * By default, the owner account will be the one that deploys the contract. This
554  * can later be changed with {transferOwnership}.
555  *
556  * This module is used through inheritance. It will make available the modifier
557  * `onlyOwner`, which can be applied to your functions to restrict their use to
558  * the owner.
559  */
560 abstract contract Ownable is Context {
561     address private _owner;
562 
563     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
564 
565     /**
566      * @dev Initializes the contract setting the deployer as the initial owner.
567      */
568     constructor() {
569         _transferOwnership(_msgSender());
570     }
571 
572     /**
573      * @dev Returns the address of the current owner.
574      */
575     function owner() public view virtual returns (address) {
576         return _owner;
577     }
578 
579     /**
580      * @dev Throws if called by any account other than the owner.
581      */
582     modifier onlyOwner() {
583         require(owner() == _msgSender(), "Ownable: caller is not the owner");
584         _;
585     }
586 
587     /**
588      * @dev Leaves the contract without owner. It will not be possible to call
589      * `onlyOwner` functions anymore. Can only be called by the current owner.
590      *
591      * NOTE: Renouncing ownership will leave the contract without an owner,
592      * thereby removing any functionality that is only available to the owner.
593      */
594     function renounceOwnership() public virtual onlyOwner {
595         _transferOwnership(address(0));
596     }
597 
598     /**
599      * @dev Transfers ownership of the contract to a new account (`newOwner`).
600      * Can only be called by the current owner.
601      */
602     function transferOwnership(address newOwner) public virtual onlyOwner {
603         require(newOwner != address(0), "Ownable: new owner is the zero address");
604         _transferOwnership(newOwner);
605     }
606 
607     /**
608      * @dev Transfers ownership of the contract to a new account (`newOwner`).
609      * Internal function without access restriction.
610      */
611     function _transferOwnership(address newOwner) internal virtual {
612         address oldOwner = _owner;
613         _owner = newOwner;
614         emit OwnershipTransferred(oldOwner, newOwner);
615     }
616 }
617 
618 /**
619  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
620  * the Metadata extension, but not including the Enumerable extension, which is available separately as
621  * {ERC721Enumerable}.
622  */
623 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
624     using Address for address;
625     using Strings for uint256;
626 
627     // Token name
628     string private _name;
629 
630     // Token symbol
631     string private _symbol;
632 
633     // Mapping from token ID to owner address
634     mapping(uint256 => address) private _owners;
635 
636     // Mapping owner address to token count
637     mapping(address => uint256) private _balances;
638 
639     // Mapping from token ID to approved address
640     mapping(uint256 => address) private _tokenApprovals;
641 
642     // Mapping from owner to operator approvals
643     mapping(address => mapping(address => bool)) private _operatorApprovals;
644 
645     /**
646      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
647      */
648     constructor(string memory name_, string memory symbol_) {
649         _name = name_;
650         _symbol = symbol_;
651     }
652 
653     /**
654      * @dev See {IERC165-supportsInterface}.
655      */
656     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
657         return
658             interfaceId == type(IERC721).interfaceId ||
659             interfaceId == type(IERC721Metadata).interfaceId ||
660             super.supportsInterface(interfaceId);
661     }
662 
663     /**
664      * @dev See {IERC721-balanceOf}.
665      */
666     function balanceOf(address owner) public view virtual override returns (uint256) {
667         require(owner != address(0), "ERC721: balance query for the zero address");
668         return _balances[owner];
669     }
670 
671     /**
672      * @dev See {IERC721-ownerOf}.
673      */
674     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
675         address owner = _owners[tokenId];
676         require(owner != address(0), "ERC721: owner query for nonexistent token");
677         return owner;
678     }
679 
680     /**
681      * @dev See {IERC721Metadata-name}.
682      */
683     function name() public view virtual override returns (string memory) {
684         return _name;
685     }
686 
687     /**
688      * @dev See {IERC721Metadata-symbol}.
689      */
690     function symbol() public view virtual override returns (string memory) {
691         return _symbol;
692     }
693 
694     /**
695      * @dev See {IERC721Metadata-tokenURI}.
696      */
697     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
698         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
699 
700         string memory baseURI = _baseURI();
701         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
702     }
703 
704     /**
705      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
706      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
707      * by default, can be overriden in child contracts.
708      */
709     function _baseURI() internal view virtual returns (string memory) {
710         return "";
711     }
712 
713     /**
714      * @dev See {IERC721-approve}.
715      */
716     function approve(address to, uint256 tokenId) public virtual override {
717         address owner = ERC721.ownerOf(tokenId);
718         require(to != owner, "ERC721: approval to current owner");
719 
720         require(
721             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
722             "ERC721: approve caller is not owner nor approved for all"
723         );
724 
725         _approve(to, tokenId);
726     }
727 
728     /**
729      * @dev See {IERC721-getApproved}.
730      */
731     function getApproved(uint256 tokenId) public view virtual override returns (address) {
732         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
733 
734         return _tokenApprovals[tokenId];
735     }
736 
737     /**
738      * @dev See {IERC721-setApprovalForAll}.
739      */
740     function setApprovalForAll(address operator, bool approved) public virtual override {
741         _setApprovalForAll(_msgSender(), operator, approved);
742     }
743 
744     /**
745      * @dev See {IERC721-isApprovedForAll}.
746      */
747     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
748         return _operatorApprovals[owner][operator];
749     }
750 
751     /**
752      * @dev See {IERC721-transferFrom}.
753      */
754     function transferFrom(
755         address from,
756         address to,
757         uint256 tokenId
758     ) public virtual override {
759         //solhint-disable-next-line max-line-length
760         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
761 
762         _transfer(from, to, tokenId);
763     }
764 
765     /**
766      * @dev See {IERC721-safeTransferFrom}.
767      */
768     function safeTransferFrom(
769         address from,
770         address to,
771         uint256 tokenId
772     ) public virtual override {
773         safeTransferFrom(from, to, tokenId, "");
774     }
775 
776     /**
777      * @dev See {IERC721-safeTransferFrom}.
778      */
779     function safeTransferFrom(
780         address from,
781         address to,
782         uint256 tokenId,
783         bytes memory _data
784     ) public virtual override {
785         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
786         _safeTransfer(from, to, tokenId, _data);
787     }
788 
789     /**
790      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
791      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
792      *
793      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
794      *
795      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
796      * implement alternative mechanisms to perform token transfer, such as signature-based.
797      *
798      * Requirements:
799      *
800      * - `from` cannot be the zero address.
801      * - `to` cannot be the zero address.
802      * - `tokenId` token must exist and be owned by `from`.
803      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
804      *
805      * Emits a {Transfer} event.
806      */
807     function _safeTransfer(
808         address from,
809         address to,
810         uint256 tokenId,
811         bytes memory _data
812     ) internal virtual {
813         _transfer(from, to, tokenId);
814         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
815     }
816 
817     /**
818      * @dev Returns whether `tokenId` exists.
819      *
820      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
821      *
822      * Tokens start existing when they are minted (`_mint`),
823      * and stop existing when they are burned (`_burn`).
824      */
825     function _exists(uint256 tokenId) internal view virtual returns (bool) {
826         return _owners[tokenId] != address(0);
827     }
828 
829     /**
830      * @dev Returns whether `spender` is allowed to manage `tokenId`.
831      *
832      * Requirements:
833      *
834      * - `tokenId` must exist.
835      */
836     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
837         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
838         address owner = ERC721.ownerOf(tokenId);
839         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
840     }
841 
842     /**
843      * @dev Safely mints `tokenId` and transfers it to `to`.
844      *
845      * Requirements:
846      *
847      * - `tokenId` must not exist.
848      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
849      *
850      * Emits a {Transfer} event.
851      */
852     function _safeMint(address to, uint256 tokenId) internal virtual {
853         _safeMint(to, tokenId, "");
854     }
855 
856     /**
857      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
858      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
859      */
860     function _safeMint(
861         address to,
862         uint256 tokenId,
863         bytes memory _data
864     ) internal virtual {
865         _mint(to, tokenId);
866         require(
867             _checkOnERC721Received(address(0), to, tokenId, _data),
868             "ERC721: transfer to non ERC721Receiver implementer"
869         );
870     }
871 
872     /**
873      * @dev Mints `tokenId` and transfers it to `to`.
874      *
875      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
876      *
877      * Requirements:
878      *
879      * - `tokenId` must not exist.
880      * - `to` cannot be the zero address.
881      *
882      * Emits a {Transfer} event.
883      */
884     function _mint(address to, uint256 tokenId) internal virtual {
885         require(to != address(0), "ERC721: mint to the zero address");
886         require(!_exists(tokenId), "ERC721: token already minted");
887 
888         _beforeTokenTransfer(address(0), to, tokenId);
889 
890         _balances[to] += 1;
891         _owners[tokenId] = to;
892 
893         emit Transfer(address(0), to, tokenId);
894     }
895 
896     /**
897      * @dev Destroys `tokenId`.
898      * The approval is cleared when the token is burned.
899      *
900      * Requirements:
901      *
902      * - `tokenId` must exist.
903      *
904      * Emits a {Transfer} event.
905      */
906     function _burn(uint256 tokenId) internal virtual {
907         address owner = ERC721.ownerOf(tokenId);
908 
909         _beforeTokenTransfer(owner, address(0), tokenId);
910 
911         // Clear approvals
912         _approve(address(0), tokenId);
913 
914         _balances[owner] -= 1;
915         delete _owners[tokenId];
916 
917         emit Transfer(owner, address(0), tokenId);
918     }
919 
920     /**
921      * @dev Transfers `tokenId` from `from` to `to`.
922      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
923      *
924      * Requirements:
925      *
926      * - `to` cannot be the zero address.
927      * - `tokenId` token must be owned by `from`.
928      *
929      * Emits a {Transfer} event.
930      */
931     function _transfer(
932         address from,
933         address to,
934         uint256 tokenId
935     ) internal virtual {
936         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
937         require(to != address(0), "ERC721: transfer to the zero address");
938 
939         _beforeTokenTransfer(from, to, tokenId);
940 
941         // Clear approvals from the previous owner
942         _approve(address(0), tokenId);
943 
944         _balances[from] -= 1;
945         _balances[to] += 1;
946         _owners[tokenId] = to;
947 
948         emit Transfer(from, to, tokenId);
949     }
950 
951     /**
952      * @dev Approve `to` to operate on `tokenId`
953      *
954      * Emits a {Approval} event.
955      */
956     function _approve(address to, uint256 tokenId) internal virtual {
957         _tokenApprovals[tokenId] = to;
958         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
959     }
960 
961     /**
962      * @dev Approve `operator` to operate on all of `owner` tokens
963      *
964      * Emits a {ApprovalForAll} event.
965      */
966     function _setApprovalForAll(
967         address owner,
968         address operator,
969         bool approved
970     ) internal virtual {
971         require(owner != operator, "ERC721: approve to caller");
972         _operatorApprovals[owner][operator] = approved;
973         emit ApprovalForAll(owner, operator, approved);
974     }
975 
976     /**
977      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
978      * The call is not executed if the target address is not a contract.
979      *
980      * @param from address representing the previous owner of the given token ID
981      * @param to target address that will receive the tokens
982      * @param tokenId uint256 ID of the token to be transferred
983      * @param _data bytes optional data to send along with the call
984      * @return bool whether the call correctly returned the expected magic value
985      */
986     function _checkOnERC721Received(
987         address from,
988         address to,
989         uint256 tokenId,
990         bytes memory _data
991     ) private returns (bool) {
992         if (to.isContract()) {
993             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
994                 return retval == IERC721Receiver.onERC721Received.selector;
995             } catch (bytes memory reason) {
996                 if (reason.length == 0) {
997                     revert("ERC721: transfer to non ERC721Receiver implementer");
998                 } else {
999                     assembly {
1000                         revert(add(32, reason), mload(reason))
1001                     }
1002                 }
1003             }
1004         } else {
1005             return true;
1006         }
1007     }
1008 
1009     /**
1010      * @dev Hook that is called before any token transfer. This includes minting
1011      * and burning.
1012      *
1013      * Calling conditions:
1014      *
1015      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1016      * transferred to `to`.
1017      * - When `from` is zero, `tokenId` will be minted for `to`.
1018      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1019      * - `from` and `to` are never both zero.
1020      *
1021      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1022      */
1023     function _beforeTokenTransfer(
1024         address from,
1025         address to,
1026         uint256 tokenId
1027     ) internal virtual {}
1028 }
1029 
1030 /**
1031  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1032  * enumerability of all the token ids in the contract as well as all token ids owned by each
1033  * account.
1034  */
1035 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1036     // Mapping from owner to list of owned token IDs
1037     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1038 
1039     // Mapping from token ID to index of the owner tokens list
1040     mapping(uint256 => uint256) private _ownedTokensIndex;
1041 
1042     // Array with all token ids, used for enumeration
1043     uint256[] private _allTokens;
1044 
1045     // Mapping from token id to position in the allTokens array
1046     mapping(uint256 => uint256) private _allTokensIndex;
1047 
1048     /**
1049      * @dev See {IERC165-supportsInterface}.
1050      */
1051     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1052         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1053     }
1054 
1055     /**
1056      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1057      */
1058     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1059         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1060         return _ownedTokens[owner][index];
1061     }
1062 
1063     /**
1064      * @dev See {IERC721Enumerable-totalSupply}.
1065      */
1066     function totalSupply() public view virtual override returns (uint256) {
1067         return _allTokens.length;
1068     }
1069 
1070     /**
1071      * @dev See {IERC721Enumerable-tokenByIndex}.
1072      */
1073     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1074         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1075         return _allTokens[index];
1076     }
1077 
1078     /**
1079      * @dev Hook that is called before any token transfer. This includes minting
1080      * and burning.
1081      *
1082      * Calling conditions:
1083      *
1084      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1085      * transferred to `to`.
1086      * - When `from` is zero, `tokenId` will be minted for `to`.
1087      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1088      * - `from` cannot be the zero address.
1089      * - `to` cannot be the zero address.
1090      *
1091      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1092      */
1093     function _beforeTokenTransfer(
1094         address from,
1095         address to,
1096         uint256 tokenId
1097     ) internal virtual override {
1098         super._beforeTokenTransfer(from, to, tokenId);
1099 
1100         if (from == address(0)) {
1101             _addTokenToAllTokensEnumeration(tokenId);
1102         } else if (from != to) {
1103             _removeTokenFromOwnerEnumeration(from, tokenId);
1104         }
1105         if (to == address(0)) {
1106             _removeTokenFromAllTokensEnumeration(tokenId);
1107         } else if (to != from) {
1108             _addTokenToOwnerEnumeration(to, tokenId);
1109         }
1110     }
1111 
1112     /**
1113      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1114      * @param to address representing the new owner of the given token ID
1115      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1116      */
1117     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1118         uint256 length = ERC721.balanceOf(to);
1119         _ownedTokens[to][length] = tokenId;
1120         _ownedTokensIndex[tokenId] = length;
1121     }
1122 
1123     /**
1124      * @dev Private function to add a token to this extension's token tracking data structures.
1125      * @param tokenId uint256 ID of the token to be added to the tokens list
1126      */
1127     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1128         _allTokensIndex[tokenId] = _allTokens.length;
1129         _allTokens.push(tokenId);
1130     }
1131 
1132     /**
1133      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1134      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1135      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1136      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1137      * @param from address representing the previous owner of the given token ID
1138      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1139      */
1140     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1141         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1142         // then delete the last slot (swap and pop).
1143 
1144         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1145         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1146 
1147         // When the token to delete is the last token, the swap operation is unnecessary
1148         if (tokenIndex != lastTokenIndex) {
1149             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1150 
1151             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1152             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1153         }
1154 
1155         // This also deletes the contents at the last position of the array
1156         delete _ownedTokensIndex[tokenId];
1157         delete _ownedTokens[from][lastTokenIndex];
1158     }
1159 
1160     /**
1161      * @dev Private function to remove a token from this extension's token tracking data structures.
1162      * This has O(1) time complexity, but alters the order of the _allTokens array.
1163      * @param tokenId uint256 ID of the token to be removed from the tokens list
1164      */
1165     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1166         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1167         // then delete the last slot (swap and pop).
1168 
1169         uint256 lastTokenIndex = _allTokens.length - 1;
1170         uint256 tokenIndex = _allTokensIndex[tokenId];
1171 
1172         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1173         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1174         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1175         uint256 lastTokenId = _allTokens[lastTokenIndex];
1176 
1177         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1178         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1179 
1180         // This also deletes the contents at the last position of the array
1181         delete _allTokensIndex[tokenId];
1182         _allTokens.pop();
1183     }
1184 }
1185 
1186 /**
1187  * @dev Contract module that helps prevent reentrant calls to a function.
1188  *
1189  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1190  * available, which can be applied to functions to make sure there are no nested
1191  * (reentrant) calls to them.
1192  *
1193  * Note that because there is a single `nonReentrant` guard, functions marked as
1194  * `nonReentrant` may not call one another. This can be worked around by making
1195  * those functions `private`, and then adding `external` `nonReentrant` entry
1196  * points to them.
1197  *
1198  * TIP: If you would like to learn more about reentrancy and alternative ways
1199  * to protect against it, check out our blog post
1200  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1201  */
1202 abstract contract ReentrancyGuard {
1203     // Booleans are more expensive than uint256 or any type that takes up a full
1204     // word because each write operation emits an extra SLOAD to first read the
1205     // slot's contents, replace the bits taken up by the boolean, and then write
1206     // back. This is the compiler's defense against contract upgrades and
1207     // pointer aliasing, and it cannot be disabled.
1208 
1209     // The values being non-zero value makes deployment a bit more expensive,
1210     // but in exchange the refund on every call to nonReentrant will be lower in
1211     // amount. Since refunds are capped to a percentage of the total
1212     // transaction's gas, it is best to keep them low in cases like this one, to
1213     // increase the likelihood of the full refund coming into effect.
1214     uint256 private constant _NOT_ENTERED = 1;
1215     uint256 private constant _ENTERED = 2;
1216 
1217     uint256 private _status;
1218 
1219     constructor() {
1220         _status = _NOT_ENTERED;
1221     }
1222 
1223     /**
1224      * @dev Prevents a contract from calling itself, directly or indirectly.
1225      * Calling a `nonReentrant` function from another `nonReentrant`
1226      * function is not supported. It is possible to prevent this from happening
1227      * by making the `nonReentrant` function external, and making it call a
1228      * `private` function that does the actual work.
1229      */
1230     modifier nonReentrant() {
1231         // On the first call to nonReentrant, _notEntered will be true
1232         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1233 
1234         // Any calls to nonReentrant after this point will fail
1235         _status = _ENTERED;
1236 
1237         _;
1238 
1239         // By storing the original value once again, a refund is triggered (see
1240         // https://eips.ethereum.org/EIPS/eip-2200)
1241         _status = _NOT_ENTERED;
1242     }
1243 }
1244 
1245 contract ALIToken is ERC721, Ownable, ERC721Enumerable, ReentrancyGuard {
1246     using Strings for uint256;
1247 
1248     constructor() ERC721("alinft-official", "ALI") {}
1249     
1250     string private baseURI;
1251     string private blindURI;
1252     uint256 constant private MAX_NFT = 10000;
1253     uint256 public WHITE_ONE_COUNT;
1254     uint256 public WHITE_TWO_COUNT;
1255     uint256 public _oneListCount;
1256     uint256 public _twoListCount;
1257     uint256 public listPrice = 100000000000000000;  // 0.1 ETH
1258     uint256 public publicPrice = 150000000000000000; // 0.15 ETH
1259     address private root = 0xA6c28f11002435EA015309Ca1b5DaDc533Be22fB;
1260     bool public isActive;
1261     bool public reveal;
1262     uint256 public ONE_TIME;
1263     uint256 public TWO_TIME;
1264     uint256 public PUBLIC_TIME;
1265     uint256 public END_TIME;
1266     mapping (address => uint256) private _nftMintCount;
1267     mapping (uint256 => uint256) private _allowCount;
1268     mapping(uint256 => mapping(address => bool)) private _whiteList;
1269 
1270     function oneCount(uint256 _num) public onlyOwner {
1271         WHITE_ONE_COUNT = _num;
1272     }
1273 
1274     function twoCount(uint256 _num) public onlyOwner {
1275         WHITE_TWO_COUNT = _num;
1276     }
1277 
1278     function activeNow() public onlyOwner {
1279         isActive = true;
1280     }
1281 
1282     function revealNow() public onlyOwner {
1283         reveal = true;
1284     }
1285 
1286     function onetime(uint256 _time) public onlyOwner(){
1287         ONE_TIME = _time;
1288     }
1289 
1290     function twotime(uint256 _time) public onlyOwner(){
1291         TWO_TIME = _time;
1292     }
1293 
1294     function publictime(uint256 _time) public onlyOwner(){
1295         PUBLIC_TIME = _time;
1296     }
1297 
1298     function endtime(uint256 _time) public onlyOwner(){
1299         END_TIME = _time;
1300     }
1301 
1302     function mintCount(address _address) public view returns(uint256){
1303         return _nftMintCount[_address];
1304     }
1305 
1306     function allowCount(uint256 _edition) public view returns(uint256){
1307         return _allowCount[_edition];
1308     }
1309 
1310     function white(address _address) public view returns(uint256){
1311         if(_whiteList[1][_address]){
1312             return 1;
1313         }else if(_whiteList[2][_address]){
1314             return 2;
1315         }else{
1316             return 3;
1317         }
1318     }
1319 
1320     function setWhite(address[] memory _address,uint256[] memory _edition) public onlyOwner {
1321         require(_address.length == _edition.length, "Should have same length");
1322         for(uint256 i = 0; i < _address.length;i++){
1323             if(_edition[i] == 1){
1324                 require(_oneListCount + 1 <= WHITE_ONE_COUNT,"Cannot list above limit");
1325                 _oneListCount++;
1326             }
1327             if(_edition[i] == 2){
1328                 require(_twoListCount + 1 <= WHITE_TWO_COUNT,"Cannot list above limit");
1329                 _twoListCount++;
1330             }
1331             _whiteList[_edition[i]][_address[i]] = true;
1332         }
1333     }
1334 
1335     modifier mintCheck(uint256 num){
1336         require(tx.origin == msg.sender,"CONTRACTS_NOT_ALLOWED_TO_MINT");
1337         require(isActive, "Contract is not active");
1338         require(totalSupply() + num <= MAX_NFT, "Purchase would exceed max public supply of NFTs");
1339         address _address = msg.sender;
1340         uint256 time = block.timestamp;
1341         if(_whiteList[1][_address] && time >= ONE_TIME && time < PUBLIC_TIME){
1342             require(_nftMintCount[_address] + num <= 2, "Cannot mint above limit");
1343             require(msg.value == listPrice * num, "Ether value sent is not correct");
1344         }else if(_whiteList[2][_address] && time >= TWO_TIME && time < PUBLIC_TIME){
1345             require(_nftMintCount[_address] + num <= 1, "Cannot mint above limit");
1346             require(msg.value == listPrice * num, "Ether value sent is not correct");
1347         }else if(_whiteList[1][_address] == false && _whiteList[2][_address] == false && time >= PUBLIC_TIME && time < END_TIME){
1348             require(_nftMintCount[_address] + num <= 1, "Cannot mint above limit");
1349             require(msg.value == publicPrice * num, "Ether value sent is not correct");
1350         }else{
1351             revert("mint error");
1352         }
1353         _;
1354     }
1355 
1356     function mintNFT(uint256 num) external payable mintCheck(num) nonReentrant {
1357         address _address = msg.sender;
1358         (bool success, ) = payable(root).call{value: msg.value}("");
1359         require(success, "Failed to withdraw payment");
1360         for(uint256 i = 0; i < num;i++){
1361              uint256 tokenId = _randMod();
1362              _safeMint(_address, tokenId);
1363              _nftMintCount[_address]++;
1364              if(_whiteList[1][_address]){
1365                 _allowCount[1]++;
1366             }else if(_whiteList[2][_address]){
1367                 _allowCount[2]++;
1368             }else{
1369                 _allowCount[3]++;
1370             }
1371         }
1372     }
1373 
1374     function setURI(string memory _blindURI, string memory _URI) external onlyOwner {
1375         blindURI = _blindURI;
1376         baseURI = _URI;
1377     }
1378 
1379     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1380         require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
1381         if (!reveal) {
1382             return string(abi.encodePacked(blindURI, _tokenId.toString()));
1383         } else {
1384             return string(abi.encodePacked(baseURI, _tokenId.toString()));
1385         }
1386     }
1387 
1388     function _beforeTokenTransfer(address from, address to, uint256 tokenId)
1389         internal
1390         override(ERC721, ERC721Enumerable)
1391     {
1392         super._beforeTokenTransfer(from, to, tokenId);
1393     }
1394 
1395     function supportsInterface(bytes4 interfaceId)
1396         public
1397         view
1398         override(ERC721, ERC721Enumerable)
1399         returns (bool)
1400     {
1401         return super.supportsInterface(interfaceId);
1402     }
1403  
1404     uint[MAX_NFT] public indices;
1405     uint nonce;
1406     function _randMod() private returns (uint) {
1407         uint totalSize = MAX_NFT - nonce;
1408         uint index = uint(keccak256(abi.encodePacked(nonce, msg.sender, block.difficulty, block.timestamp))) % totalSize;
1409         uint value = 0;
1410         if (indices[index] != 0) {
1411             value = indices[index];
1412         } else {
1413             value = index;
1414         }
1415  
1416         if (indices[totalSize - 1] == 0) {
1417             indices[index] = totalSize - 1;
1418         } else {
1419             indices[index] = indices[totalSize - 1];
1420         }
1421         nonce++;
1422         return value+1;
1423     }
1424 }