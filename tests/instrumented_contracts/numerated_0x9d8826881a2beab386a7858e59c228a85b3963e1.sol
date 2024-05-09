1 // SPDX-License-Identifier: GPL-3.0
2 
3 /*
4  ______     __                            __           __                      __
5 |_   _ \   [  |                          |  ]         [  |                    |  ]
6   | |_) |   | |    .--.     .--.     .--.| |   .--.    | |--.    .---.    .--.| |
7   |  __'.   | |  / .'`\ \ / .'`\ \ / /'`\' |  ( (`\]   | .-. |  / /__\\ / /'`\' |
8  _| |__) |  | |  | \__. | | \__. | | \__/  |   `'.'.   | | | |  | \__., | \__/  |
9 |_______/  [___]  '.__.'   '.__.'   '.__.;__] [\__) ) [___]|__]  '.__.'  '.__.;__]
10                       ________
11                       ___  __ )_____ ______ _________________
12                       __  __  |_  _ \_  __ `/__  ___/__  ___/
13                       _  /_/ / /  __// /_/ / _  /    _(__  )
14                       /_____/  \___/ \__,_/  /_/     /____/
15 */
16 
17 pragma solidity ^0.8.0;
18 
19 /**
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
39 pragma solidity ^0.8.0;
40 
41 /**
42  * @dev Contract module which provides a basic access control mechanism, where
43  * there is an account (an owner) that can be granted exclusive access to
44  * specific functions.
45  *
46  * By default, the owner account will be the one that deploys the contract. This
47  * can later be changed with {transferOwnership}.
48  *
49  * This module is used through inheritance. It will make available the modifier
50  * `onlyOwner`, which can be applied to your functions to restrict their use to
51  * the owner.
52  */
53 abstract contract Ownable is Context {
54     address private _owner;
55 
56     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
57 
58     /**
59      * @dev Initializes the contract setting the deployer as the initial owner.
60      */
61     constructor() {
62         _setOwner(_msgSender());
63     }
64 
65     /**
66      * @dev Returns the address of the current owner.
67      */
68     function owner() public view virtual returns (address) {
69         return _owner;
70     }
71 
72     /**
73      * @dev Throws if called by any account other than the owner.
74      */
75     modifier onlyOwner() {
76         require(owner() == _msgSender(), "Ownable: caller is not the owner");
77         _;
78     }
79 
80     /**
81      * @dev Leaves the contract without owner. It will not be possible to call
82      * `onlyOwner` functions anymore. Can only be called by the current owner.
83      *
84      * NOTE: Renouncing ownership will leave the contract without an owner,
85      * thereby removing any functionality that is only available to the owner.
86      */
87     function renounceOwnership() public virtual onlyOwner {
88         _setOwner(address(0));
89     }
90 
91     /**
92      * @dev Transfers ownership of the contract to a new account (`newOwner`).
93      * Can only be called by the current owner.
94      */
95     function transferOwnership(address newOwner) public virtual onlyOwner {
96         require(newOwner != address(0), "Ownable: new owner is the zero address");
97         _setOwner(newOwner);
98     }
99 
100     function _setOwner(address newOwner) private {
101         address oldOwner = _owner;
102         _owner = newOwner;
103         emit OwnershipTransferred(oldOwner, newOwner);
104     }
105 }
106 
107 pragma solidity ^0.8.0;
108 
109 /**
110  * @dev String operations.
111  */
112 library Strings {
113     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
114 
115     /**
116      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
117      */
118     function toString(uint256 value) internal pure returns (string memory) {
119         // Inspired by OraclizeAPI's implementation - MIT licence
120         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
121 
122         if (value == 0) {
123             return "0";
124         }
125         uint256 temp = value;
126         uint256 digits;
127         while (temp != 0) {
128             digits++;
129             temp /= 10;
130         }
131         bytes memory buffer = new bytes(digits);
132         while (value != 0) {
133             digits -= 1;
134             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
135             value /= 10;
136         }
137         return string(buffer);
138     }
139 
140     /**
141      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
142      */
143     function toHexString(uint256 value) internal pure returns (string memory) {
144         if (value == 0) {
145             return "0x00";
146         }
147         uint256 temp = value;
148         uint256 length = 0;
149         while (temp != 0) {
150             length++;
151             temp >>= 8;
152         }
153         return toHexString(value, length);
154     }
155 
156     /**
157      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
158      */
159     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
160         bytes memory buffer = new bytes(2 * length + 2);
161         buffer[0] = "0";
162         buffer[1] = "x";
163         for (uint256 i = 2 * length + 1; i > 1; --i) {
164             buffer[i] = _HEX_SYMBOLS[value & 0xf];
165             value >>= 4;
166         }
167         require(value == 0, "Strings: hex length insufficient");
168         return string(buffer);
169     }
170 }
171 
172 pragma solidity ^0.8.0;
173 
174 /**
175  * @dev Interface of the ERC165 standard, as defined in the
176  * https://eips.ethereum.org/EIPS/eip-165[EIP].
177  *
178  * Implementers can declare support of contract interfaces, which can then be
179  * queried by others ({ERC165Checker}).
180  *
181  * For an implementation, see {ERC165}.
182  */
183 interface IERC165 {
184     /**
185      * @dev Returns true if this contract implements the interface defined by
186      * `interfaceId`. See the corresponding
187      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
188      * to learn more about how these ids are created.
189      *
190      * This function call must use less than 30 000 gas.
191      */
192     function supportsInterface(bytes4 interfaceId) external view returns (bool);
193 }
194 
195 pragma solidity ^0.8.0;
196 
197 /**
198  * @dev Required interface of an ERC721 compliant contract.
199  */
200 interface IERC721 is IERC165 {
201     /**
202      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
203      */
204     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
205 
206     /**
207      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
208      */
209     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
210 
211     /**
212      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
213      */
214     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
215 
216     /**
217      * @dev Returns the number of tokens in ``owner``'s account.
218      */
219     function balanceOf(address owner) external view returns (uint256 balance);
220 
221     /**
222      * @dev Returns the owner of the `tokenId` token.
223      *
224      * Requirements:
225      *
226      * - `tokenId` must exist.
227      */
228     function ownerOf(uint256 tokenId) external view returns (address owner);
229 
230     /**
231      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
232      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
233      *
234      * Requirements:
235      *
236      * - `from` cannot be the zero address.
237      * - `to` cannot be the zero address.
238      * - `tokenId` token must exist and be owned by `from`.
239      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
240      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
241      *
242      * Emits a {Transfer} event.
243      */
244     function safeTransferFrom(
245         address from,
246         address to,
247         uint256 tokenId
248     ) external;
249 
250     /**
251      * @dev Transfers `tokenId` token from `from` to `to`.
252      *
253      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
254      *
255      * Requirements:
256      *
257      * - `from` cannot be the zero address.
258      * - `to` cannot be the zero address.
259      * - `tokenId` token must be owned by `from`.
260      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
261      *
262      * Emits a {Transfer} event.
263      */
264     function transferFrom(
265         address from,
266         address to,
267         uint256 tokenId
268     ) external;
269 
270     /**
271      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
272      * The approval is cleared when the token is transferred.
273      *
274      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
275      *
276      * Requirements:
277      *
278      * - The caller must own the token or be an approved operator.
279      * - `tokenId` must exist.
280      *
281      * Emits an {Approval} event.
282      */
283     function approve(address to, uint256 tokenId) external;
284 
285     /**
286      * @dev Returns the account approved for `tokenId` token.
287      *
288      * Requirements:
289      *
290      * - `tokenId` must exist.
291      */
292     function getApproved(uint256 tokenId) external view returns (address operator);
293 
294     /**
295      * @dev Approve or remove `operator` as an operator for the caller.
296      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
297      *
298      * Requirements:
299      *
300      * - The `operator` cannot be the caller.
301      *
302      * Emits an {ApprovalForAll} event.
303      */
304     function setApprovalForAll(address operator, bool _approved) external;
305 
306     /**
307      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
308      *
309      * See {setApprovalForAll}
310      */
311     function isApprovedForAll(address owner, address operator) external view returns (bool);
312 
313     /**
314      * @dev Safely transfers `tokenId` token from `from` to `to`.
315      *
316      * Requirements:
317      *
318      * - `from` cannot be the zero address.
319      * - `to` cannot be the zero address.
320      * - `tokenId` token must exist and be owned by `from`.
321      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
322      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
323      *
324      * Emits a {Transfer} event.
325      */
326     function safeTransferFrom(
327         address from,
328         address to,
329         uint256 tokenId,
330         bytes calldata data
331     ) external;
332 }
333 
334 pragma solidity ^0.8.0;
335 
336 
337 /**
338  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
339  * @dev See https://eips.ethereum.org/EIPS/eip-721
340  */
341 interface IERC721Enumerable is IERC721 {
342     /**
343      * @dev Returns the total amount of tokens stored by the contract.
344      */
345     function totalSupply() external view returns (uint256);
346 
347     /**
348      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
349      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
350      */
351     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
352 
353     /**
354      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
355      * Use along with {totalSupply} to enumerate all tokens.
356      */
357     function tokenByIndex(uint256 index) external view returns (uint256);
358 }
359 
360 pragma solidity ^0.8.0;
361 
362 /**
363  * @title ERC721 token receiver interface
364  * @dev Interface for any contract that wants to support safeTransfers
365  * from ERC721 asset contracts.
366  */
367 interface IERC721Receiver {
368     /**
369      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
370      * by `operator` from `from`, this function is called.
371      *
372      * It must return its Solidity selector to confirm the token transfer.
373      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
374      *
375      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
376      */
377     function onERC721Received(
378         address operator,
379         address from,
380         uint256 tokenId,
381         bytes calldata data
382     ) external returns (bytes4);
383 }
384 
385 pragma solidity ^0.8.0;
386 
387 /**
388  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
389  * @dev See https://eips.ethereum.org/EIPS/eip-721
390  */
391 interface IERC721Metadata is IERC721 {
392     /**
393      * @dev Returns the token collection name.
394      */
395     function name() external view returns (string memory);
396 
397     /**
398      * @dev Returns the token collection symbol.
399      */
400     function symbol() external view returns (string memory);
401 
402     /**
403      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
404      */
405     function tokenURI(uint256 tokenId) external view returns (string memory);
406 }
407 
408 
409 pragma solidity ^0.8.0;
410 
411 /**
412  * @dev Collection of functions related to the address type
413  */
414 library Address {
415     /**
416      * @dev Returns true if `account` is a contract.
417      *
418      * [IMPORTANT]
419      * ====
420      * It is unsafe to assume that an address for which this function returns
421      * false is an externally-owned account (EOA) and not a contract.
422      *
423      * Among others, `isContract` will return false for the following
424      * types of addresses:
425      *
426      *  - an externally-owned account
427      *  - a contract in construction
428      *  - an address where a contract will be created
429      *  - an address where a contract lived, but was destroyed
430      * ====
431      */
432     function isContract(address account) internal view returns (bool) {
433         // This method relies on extcodesize, which returns 0 for contracts in
434         // construction, since the code is only stored at the end of the
435         // constructor execution.
436 
437         uint256 size;
438         assembly {
439             size := extcodesize(account)
440         }
441         return size > 0;
442     }
443 
444     /**
445      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
446      * `recipient`, forwarding all available gas and reverting on errors.
447      *
448      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
449      * of certain opcodes, possibly making contracts go over the 2300 gas limit
450      * imposed by `transfer`, making them unable to receive funds via
451      * `transfer`. {sendValue} removes this limitation.
452      *
453      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
454      *
455      * IMPORTANT: because control is transferred to `recipient`, care must be
456      * taken to not create reentrancy vulnerabilities. Consider using
457      * {ReentrancyGuard} or the
458      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
459      */
460     function sendValue(address payable recipient, uint256 amount) internal {
461         require(address(this).balance >= amount, "Address: insufficient balance");
462 
463         (bool success, ) = recipient.call{value: amount}("");
464         require(success, "Address: unable to send value, recipient may have reverted");
465     }
466 
467     /**
468      * @dev Performs a Solidity function call using a low level `call`. A
469      * plain `call` is an unsafe replacement for a function call: use this
470      * function instead.
471      *
472      * If `target` reverts with a revert reason, it is bubbled up by this
473      * function (like regular Solidity function calls).
474      *
475      * Returns the raw returned data. To convert to the expected return value,
476      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
477      *
478      * Requirements:
479      *
480      * - `target` must be a contract.
481      * - calling `target` with `data` must not revert.
482      *
483      * _Available since v3.1._
484      */
485     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
486         return functionCall(target, data, "Address: low-level call failed");
487     }
488 
489     /**
490      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
491      * `errorMessage` as a fallback revert reason when `target` reverts.
492      *
493      * _Available since v3.1._
494      */
495     function functionCall(
496         address target,
497         bytes memory data,
498         string memory errorMessage
499     ) internal returns (bytes memory) {
500         return functionCallWithValue(target, data, 0, errorMessage);
501     }
502 
503     /**
504      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
505      * but also transferring `value` wei to `target`.
506      *
507      * Requirements:
508      *
509      * - the calling contract must have an ETH balance of at least `value`.
510      * - the called Solidity function must be `payable`.
511      *
512      * _Available since v3.1._
513      */
514     function functionCallWithValue(
515         address target,
516         bytes memory data,
517         uint256 value
518     ) internal returns (bytes memory) {
519         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
520     }
521 
522     /**
523      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
524      * with `errorMessage` as a fallback revert reason when `target` reverts.
525      *
526      * _Available since v3.1._
527      */
528     function functionCallWithValue(
529         address target,
530         bytes memory data,
531         uint256 value,
532         string memory errorMessage
533     ) internal returns (bytes memory) {
534         require(address(this).balance >= value, "Address: insufficient balance for call");
535         require(isContract(target), "Address: call to non-contract");
536 
537         (bool success, bytes memory returndata) = target.call{value: value}(data);
538         return verifyCallResult(success, returndata, errorMessage);
539     }
540 
541     /**
542      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
543      * but performing a static call.
544      *
545      * _Available since v3.3._
546      */
547     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
548         return functionStaticCall(target, data, "Address: low-level static call failed");
549     }
550 
551     /**
552      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
553      * but performing a static call.
554      *
555      * _Available since v3.3._
556      */
557     function functionStaticCall(
558         address target,
559         bytes memory data,
560         string memory errorMessage
561     ) internal view returns (bytes memory) {
562         require(isContract(target), "Address: static call to non-contract");
563 
564         (bool success, bytes memory returndata) = target.staticcall(data);
565         return verifyCallResult(success, returndata, errorMessage);
566     }
567 
568     /**
569      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
570      * but performing a delegate call.
571      *
572      * _Available since v3.4._
573      */
574     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
575         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
576     }
577 
578     /**
579      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
580      * but performing a delegate call.
581      *
582      * _Available since v3.4._
583      */
584     function functionDelegateCall(
585         address target,
586         bytes memory data,
587         string memory errorMessage
588     ) internal returns (bytes memory) {
589         require(isContract(target), "Address: delegate call to non-contract");
590 
591         (bool success, bytes memory returndata) = target.delegatecall(data);
592         return verifyCallResult(success, returndata, errorMessage);
593     }
594 
595     /**
596      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
597      * revert reason using the provided one.
598      *
599      * _Available since v4.3._
600      */
601     function verifyCallResult(
602         bool success,
603         bytes memory returndata,
604         string memory errorMessage
605     ) internal pure returns (bytes memory) {
606         if (success) {
607             return returndata;
608         } else {
609             // Look for revert reason and bubble it up if present
610             if (returndata.length > 0) {
611                 // The easiest way to bubble the revert reason is using memory via assembly
612 
613                 assembly {
614                     let returndata_size := mload(returndata)
615                     revert(add(32, returndata), returndata_size)
616                 }
617             } else {
618                 revert(errorMessage);
619             }
620         }
621     }
622 }
623 
624 
625 pragma solidity ^0.8.0;
626 
627 /**
628  * @dev Implementation of the {IERC165} interface.
629  *
630  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
631  * for the additional interface id that will be supported. For example:
632  *
633  * ```solidity
634  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
635  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
636  * }
637  * ```
638  *
639  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
640  */
641 abstract contract ERC165 is IERC165 {
642     /**
643      * @dev See {IERC165-supportsInterface}.
644      */
645     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
646         return interfaceId == type(IERC165).interfaceId;
647     }
648 }
649 pragma solidity ^0.8.10;
650 
651 abstract contract ERC721P is Context, ERC165, IERC721, IERC721Metadata {
652     using Address for address;
653     string private _name;
654     string private _symbol;
655     address[] internal _owners;
656     mapping(uint256 => address) private _tokenApprovals;
657     mapping(address => mapping(address => bool)) private _operatorApprovals;
658     constructor(string memory name_, string memory symbol_) {
659         _name = name_;
660         _symbol = symbol_;
661     }
662     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
663         return
664         interfaceId == type(IERC721).interfaceId ||
665         interfaceId == type(IERC721Metadata).interfaceId ||
666         super.supportsInterface(interfaceId);
667     }
668     function balanceOf(address owner) public view virtual override returns (uint256) {
669         require(owner != address(0), "ERC721: balance query for the zero address");
670         uint count = 0;
671         uint length = _owners.length;
672         for( uint i = 0; i < length; ++i ){
673             if( owner == _owners[i] ){
674                 ++count;
675             }
676         }
677         delete length;
678         return count;
679     }
680     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
681         address owner = _owners[tokenId];
682         require(owner != address(0), "ERC721: owner query for nonexistent token");
683         return owner;
684     }
685     function name() public view virtual override returns (string memory) {
686         return _name;
687     }
688     function symbol() public view virtual override returns (string memory) {
689         return _symbol;
690     }
691     function approve(address to, uint256 tokenId) public virtual override {
692         address owner = ERC721P.ownerOf(tokenId);
693         require(to != owner, "ERC721: approval to current owner");
694 
695         require(
696             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
697             "ERC721: approve caller is not owner nor approved for all"
698         );
699 
700         _approve(to, tokenId);
701     }
702     function getApproved(uint256 tokenId) public view virtual override returns (address) {
703         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
704 
705         return _tokenApprovals[tokenId];
706     }
707     function setApprovalForAll(address operator, bool approved) public virtual override {
708         require(operator != _msgSender(), "ERC721: approve to caller");
709 
710         _operatorApprovals[_msgSender()][operator] = approved;
711         emit ApprovalForAll(_msgSender(), operator, approved);
712     }
713     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
714         return _operatorApprovals[owner][operator];
715     }
716     function transferFrom(
717         address from,
718         address to,
719         uint256 tokenId
720     ) public virtual override {
721         //solhint-disable-next-line max-line-length
722         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
723 
724         _transfer(from, to, tokenId);
725     }
726     function safeTransferFrom(
727         address from,
728         address to,
729         uint256 tokenId
730     ) public virtual override {
731         safeTransferFrom(from, to, tokenId, "");
732     }
733     function safeTransferFrom(
734         address from,
735         address to,
736         uint256 tokenId,
737         bytes memory _data
738     ) public virtual override {
739         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
740         _safeTransfer(from, to, tokenId, _data);
741     }
742     function _safeTransfer(
743         address from,
744         address to,
745         uint256 tokenId,
746         bytes memory _data
747     ) internal virtual {
748         _transfer(from, to, tokenId);
749         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
750     }
751     function _exists(uint256 tokenId) internal view virtual returns (bool) {
752         return tokenId < _owners.length && _owners[tokenId] != address(0);
753     }
754     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
755         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
756         address owner = ERC721P.ownerOf(tokenId);
757         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
758     }
759     function _safeMint(address to, uint256 tokenId) internal virtual {
760         _safeMint(to, tokenId, "");
761     }
762     function _safeMint(
763         address to,
764         uint256 tokenId,
765         bytes memory _data
766     ) internal virtual {
767         _mint(to, tokenId);
768         require(
769             _checkOnERC721Received(address(0), to, tokenId, _data),
770             "ERC721: transfer to non ERC721Receiver implementer"
771         );
772     }
773     function _mint(address to, uint256 tokenId) internal virtual {
774         require(to != address(0), "ERC721: mint to the zero address");
775         require(!_exists(tokenId), "ERC721: token already minted");
776 
777         _beforeTokenTransfer(address(0), to, tokenId);
778         _owners.push(to);
779 
780         emit Transfer(address(0), to, tokenId);
781     }
782     function _burn(uint256 tokenId) internal virtual {
783         address owner = ERC721P.ownerOf(tokenId);
784 
785         _beforeTokenTransfer(owner, address(0), tokenId);
786 
787         // Clear approvals
788         _approve(address(0), tokenId);
789         _owners[tokenId] = address(0);
790 
791         emit Transfer(owner, address(0), tokenId);
792     }
793     function _transfer(
794         address from,
795         address to,
796         uint256 tokenId
797     ) internal virtual {
798         require(ERC721P.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
799         require(to != address(0), "ERC721: transfer to the zero address");
800 
801         _beforeTokenTransfer(from, to, tokenId);
802 
803         // Clear approvals from the previous owner
804         _approve(address(0), tokenId);
805         _owners[tokenId] = to;
806 
807         emit Transfer(from, to, tokenId);
808     }
809     function _approve(address to, uint256 tokenId) internal virtual {
810         _tokenApprovals[tokenId] = to;
811         emit Approval(ERC721P.ownerOf(tokenId), to, tokenId);
812     }
813     function _checkOnERC721Received(
814         address from,
815         address to,
816         uint256 tokenId,
817         bytes memory _data
818     ) private returns (bool) {
819         if (to.isContract()) {
820             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
821                 return retval == IERC721Receiver.onERC721Received.selector;
822             } catch (bytes memory reason) {
823                 if (reason.length == 0) {
824                     revert("ERC721: transfer to non ERC721Receiver implementer");
825                 } else {
826                     assembly {
827                         revert(add(32, reason), mload(reason))
828                     }
829                 }
830             }
831         } else {
832             return true;
833         }
834     }
835     function _beforeTokenTransfer(
836         address from,
837         address to,
838         uint256 tokenId
839     ) internal virtual {}
840 }
841 
842 pragma solidity ^0.8.10;
843 
844 abstract contract ERC721Enum is ERC721P, IERC721Enumerable {
845     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721P) returns (bool) {
846         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
847     }
848     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256 tokenId) {
849         require(index < ERC721P.balanceOf(owner), "ERC721Enum: owner ioob");
850         uint count;
851         for( uint i; i < _owners.length; ++i ){
852             if( owner == _owners[i] ){
853                 if( count == index )
854                     return i;
855                 else
856                     ++count;
857             }
858         }
859         require(false, "ERC721Enum: owner ioob");
860     }
861     function tokensOfOwner(address owner) public view returns (uint256[] memory) {
862         require(0 < ERC721P.balanceOf(owner), "ERC721Enum: owner ioob");
863         uint256 tokenCount = balanceOf(owner);
864         uint256[] memory tokenIds = new uint256[](tokenCount);
865         for (uint256 i = 0; i < tokenCount; i++) {
866             tokenIds[i] = tokenOfOwnerByIndex(owner, i);
867         }
868         return tokenIds;
869     }
870     function totalSupply() public view virtual override returns (uint256) {
871         return _owners.length;
872     }
873     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
874         require(index < ERC721Enum.totalSupply(), "ERC721Enum: global ioob");
875         return index;
876     }
877 }
878 
879 pragma solidity ^0.8.0;
880 
881 /**
882  * @dev These functions deal with verification of Merkle Trees proofs.
883  *
884  * The proofs can be generated using the JavaScript library
885  * https://github.com/miguelmota/merkletreejs[merkletreejs].
886  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
887  *
888  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
889  */
890 library MerkleProof {
891     /**
892      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
893      * defined by `root`. For this, a `proof` must be provided, containing
894      * sibling hashes on the branch from the leaf to the root of the tree. Each
895      * pair of leaves and each pair of pre-images are assumed to be sorted.
896      */
897     function verify(
898         bytes32[] memory proof,
899         bytes32 root,
900         bytes32 leaf
901     ) internal pure returns (bool) {
902         return processProof(proof, leaf) == root;
903     }
904 
905     /**
906      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
907      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
908      * hash matches the root of the tree. When processing the proof, the pairs
909      * of leafs & pre-images are assumed to be sorted.
910      *
911      * _Available since v4.4._
912      */
913     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
914         bytes32 computedHash = leaf;
915         for (uint256 i = 0; i < proof.length; i++) {
916             bytes32 proofElement = proof[i];
917             if (computedHash <= proofElement) {
918                 // Hash(current computed hash + current element of the proof)
919                 computedHash = _efficientHash(computedHash, proofElement);
920             } else {
921                 // Hash(current element of the proof + current computed hash)
922                 computedHash = _efficientHash(proofElement, computedHash);
923             }
924         }
925         return computedHash;
926     }
927 
928     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
929         assembly {
930             mstore(0x00, a)
931             mstore(0x20, b)
932             value := keccak256(0x00, 0x40)
933         }
934     }
935 }
936 
937 pragma solidity ^0.8.10;
938 
939 interface IERC1155 {
940     function balanceOf(address account, uint256 id) external view returns (uint256);
941     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids) external view returns (uint256[] memory);
942 }
943 
944 contract BloodShedBearsGen0 is ERC721Enum, Ownable {
945     using Strings for uint256;
946 
947     uint256 constant public MAX_SUPPLY = 7000;
948     uint256 constant public PASS_MINT_LIMIT = 5;
949     uint256 constant public WHITELIST_LIMIT = 3;
950     uint256 constant public PUBLIC_MINT_LIMIT = 5;
951     uint256 public TEAM_RESERVE_AVAILABLE_MINTS = 100;
952     uint256 public COST = 0.07 ether;
953 
954     bool public isMintPassMintActive;
955     bool public isWhiteListActive;
956     bool public isSaleActive;
957 
958     bytes32 public merkleTreeRoot;
959 
960     mapping(address => uint256) public presaleWhitelistMints;
961     mapping(address => uint256) public mintPassPaidMints;
962     mapping(address => uint256) public mintPassFreeMints;
963 
964     string public baseURI;
965 
966     address public mintPassAddress = 0x0000000000000000000000000000000000000000;
967 
968     constructor(
969         string memory name_,
970         string memory symbol_,
971         string memory initBaseURI_,
972         address mintPassAddress_
973     ) ERC721P(name_, symbol_) {
974         mintPassAddress = mintPassAddress_;
975         setBaseURI(initBaseURI_);
976     }
977 
978     // internal
979     function _baseURI() internal view virtual returns (string memory) {
980         return baseURI;
981     }
982 
983     function setMintPassContract(address _contractAddress) external onlyOwner {
984         mintPassAddress = _contractAddress;
985     }
986 
987     function setCost(uint256 cost_) external onlyOwner {
988         COST = cost_;
989     }
990 
991     function flipMintPassMintState() external onlyOwner {
992         isMintPassMintActive = !isMintPassMintActive;
993     }
994 
995     function flipWhitelistState() external onlyOwner {
996         isWhiteListActive = !isWhiteListActive;
997     }
998 
999     function flipSaleState() external onlyOwner {
1000         isSaleActive = !isSaleActive;
1001     }
1002 
1003     function setMerkleTreeRoot(bytes32 merkleTreeRoot_) external onlyOwner {
1004         merkleTreeRoot = merkleTreeRoot_;
1005     }
1006 
1007     function mint(uint256 mintAmount_, bytes32[] calldata proof) external payable {
1008 
1009         require(isSaleActive || isWhiteListActive || isMintPassMintActive, "INACTIVE");
1010         require(mintAmount_ > 0, "WHY");
1011         uint256 totalSupply = totalSupply();
1012 
1013         if (isMintPassMintActive) {
1014             uint256 passBalance = IERC1155(mintPassAddress).balanceOf(msg.sender, 0);
1015 
1016             require(passBalance > 0, "NO MINT PASS");
1017 
1018             uint256 availableFreeMints = passBalance - mintPassFreeMints[msg.sender];
1019             uint256 availablePaidMints = passBalance * PASS_MINT_LIMIT - passBalance - mintPassPaidMints[msg.sender];
1020             require(mintAmount_ <= availableFreeMints + availablePaidMints, "TOO MANY");
1021             require(mintAmount_ <= availableFreeMints || (msg.value >= COST * (mintAmount_ - availableFreeMints)), "NOT ENOUGH");
1022 
1023             if (mintAmount_ >= availableFreeMints) {
1024                 mintPassFreeMints[msg.sender] += availableFreeMints;
1025             } else {
1026                 mintPassFreeMints[msg.sender] += mintAmount_;
1027             }
1028 
1029             if (mintAmount_ > availableFreeMints) {
1030                 mintPassPaidMints[msg.sender] += (mintAmount_ - availableFreeMints);
1031             }
1032 
1033             delete passBalance;
1034             delete availableFreeMints;
1035             delete availablePaidMints;
1036 
1037         } else if (isWhiteListActive) {
1038             require(
1039                 _verify(_leaf(msg.sender), proof) || IERC1155(mintPassAddress).balanceOf(msg.sender, 0) > 0,
1040                 "NOT WL"
1041             );
1042 
1043             uint256 availableMints = WHITELIST_LIMIT - presaleWhitelistMints[msg.sender];
1044 
1045             require(mintAmount_ <= availableMints, "TOO MANY");
1046             require(totalSupply + mintAmount_ <= MAX_SUPPLY, "TOO MANY");
1047             require(msg.value >= COST * mintAmount_ , "NOT ENOUGH");
1048 
1049             presaleWhitelistMints[msg.sender] += mintAmount_;
1050 
1051         } else {
1052             require(mintAmount_ <= PUBLIC_MINT_LIMIT, "WRONG AMOUNT" );
1053             require(totalSupply + mintAmount_ <= MAX_SUPPLY, "TOO MANY" );
1054             require(msg.value >= COST * mintAmount_);
1055         }
1056 
1057         for (uint256 i = 0; i < mintAmount_; i++) {
1058             _safeMint(msg.sender, totalSupply + i);
1059         }
1060 
1061         delete totalSupply;
1062     }
1063 
1064     function _leaf(address account) internal pure returns (bytes32) {
1065         return keccak256(abi.encodePacked(account));
1066     }
1067 
1068     function _verify(bytes32 _leafNode, bytes32[] memory proof) internal view returns (bool) {
1069         return MerkleProof.verify(proof, merkleTreeRoot, _leafNode);
1070     }
1071 
1072     function withdraw() external onlyOwner {
1073         require(payable(msg.sender).send(address(this).balance));
1074     }
1075 
1076     function isOwnerOfBatch(uint256[] calldata tokenIds_, address address_) external view returns (bool) {
1077         bool ownership = true;
1078 
1079         for (uint256 i = 0; i < tokenIds_.length; ++i) {
1080             ownership = ownership && (ownerOf(tokenIds_[i]) == address_);
1081         }
1082 
1083         return ownership;
1084     }
1085 
1086     // admin minting
1087     function reserve(address _to, uint256 _reserveAmount) external onlyOwner {
1088         uint256 supply = totalSupply();
1089         require(
1090             _reserveAmount > 0 && _reserveAmount <= TEAM_RESERVE_AVAILABLE_MINTS,
1091             "Not enough reserve left for team"
1092         );
1093         for (uint256 i = 0; i < _reserveAmount; i++) {
1094             _safeMint(_to, supply + i);
1095         }
1096         TEAM_RESERVE_AVAILABLE_MINTS -= _reserveAmount;
1097     }
1098 
1099     function tokenURI(uint256 _tokenId) external view virtual override returns (string memory) {
1100         require(_exists(_tokenId), "ERC721Metadata: Nonexistent token");
1101         string memory currentBaseURI = _baseURI();
1102         return bytes(currentBaseURI).length > 0	? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), ".json")) : "";
1103     }
1104 
1105     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1106         baseURI = _newBaseURI;
1107     }
1108 }