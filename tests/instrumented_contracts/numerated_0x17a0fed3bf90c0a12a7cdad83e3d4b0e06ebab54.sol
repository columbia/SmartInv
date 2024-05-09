1 // SPDX-License-Identifier: GPL-3.0
2 
3 /*
4                                                         ,----,
5                             ,--,     ,----..          ,/   .`|           ____
6                           ,--.'|    /   /   \       ,`   .'  :         ,'  , `.
7                        ,--,  | :   /   .     :    ;    ;     /      ,-+-,.' _ |
8                     ,---.'|  : '  .   /   ;.  \ .'___,/    ,'    ,-+-. ;   , ||
9                     |   | : _' | .   ;   /  ` ; |    :     |    ,--.'|'   |  ;|
10                     :   : |.'  | ;   |  ; \ ; | ;    |.';  ;   |   |  ,', |  ':t
11                     |   ' '  ; : |   :  | ; | ' `----'  |  |   |   | /  | |  ||
12                     '   |  .'. | .   |  ' ' ' :     '   :  ;   '   | :  | :  |,
13                     |   | :  | ' '   ;  \; /  |     |   |  '   ;   . |  ; |--'
14                     '   : |  : ;  \   \  ',  /      '   :  |   |   : |  | ,
15                     |   | '  ,/    ;   :    /       ;   |.'    |   : '  |/
16                     ;   : ;--'      \   \ .'        '---'      ;   | |`-'
17                     |   ,/           `---`                     |   ;/
18                     '---'                                      '---'
19 */
20 
21 pragma solidity ^0.8.0;
22 
23 /**
24  * @dev Provides information about the current execution context, including the
25  * sender of the transaction and its data. While these are generally available
26  * via msg.sender and msg.data, they should not be accessed in such a direct
27  * manner, since when dealing with meta-transactions the account sending and
28  * paying for execution may not be the actual sender (as far as an application
29  * is concerned).
30  *
31  * This contract is only required for intermediate, library-like contracts.
32  */
33 abstract contract Context {
34     function _msgSender() internal view virtual returns (address) {
35         return msg.sender;
36     }
37 
38     function _msgData() internal view virtual returns (bytes calldata) {
39         return msg.data;
40     }
41 }
42 
43 pragma solidity ^0.8.0;
44 
45 /**
46  * @dev Contract module which provides a basic access control mechanism, where
47  * there is an account (an owner) that can be granted exclusive access to
48  * specific functions.
49  *
50  * By default, the owner account will be the one that deploys the contract. This
51  * can later be changed with {transferOwnership}.
52  *
53  * This module is used through inheritance. It will make available the modifier
54  * `onlyOwner`, which can be applied to your functions to restrict their use to
55  * the owner.
56  */
57 abstract contract Ownable is Context {
58     address private _owner;
59 
60     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
61 
62     /**
63      * @dev Initializes the contract setting the deployer as the initial owner.
64      */
65     constructor() {
66         _setOwner(_msgSender());
67     }
68 
69     /**
70      * @dev Returns the address of the current owner.
71      */
72     function owner() public view virtual returns (address) {
73         return _owner;
74     }
75 
76     /**
77      * @dev Throws if called by any account other than the owner.
78      */
79     modifier onlyOwner() {
80         require(owner() == _msgSender(), "Ownable: caller is not the owner");
81         _;
82     }
83 
84     /**
85      * @dev Leaves the contract without owner. It will not be possible to call
86      * `onlyOwner` functions anymore. Can only be called by the current owner.
87      *
88      * NOTE: Renouncing ownership will leave the contract without an owner,
89      * thereby removing any functionality that is only available to the owner.
90      */
91     function renounceOwnership() public virtual onlyOwner {
92         _setOwner(address(0));
93     }
94 
95     /**
96      * @dev Transfers ownership of the contract to a new account (`newOwner`).
97      * Can only be called by the current owner.
98      */
99     function transferOwnership(address newOwner) public virtual onlyOwner {
100         require(newOwner != address(0), "Ownable: new owner is the zero address");
101         _setOwner(newOwner);
102     }
103 
104     function _setOwner(address newOwner) private {
105         address oldOwner = _owner;
106         _owner = newOwner;
107         emit OwnershipTransferred(oldOwner, newOwner);
108     }
109 }
110 
111 pragma solidity ^0.8.0;
112 
113 /**
114  * @dev String operations.
115  */
116 library Strings {
117     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
118 
119     /**
120      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
121      */
122     function toString(uint256 value) internal pure returns (string memory) {
123         // Inspired by OraclizeAPI's implementation - MIT licence
124         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
125 
126         if (value == 0) {
127             return "0";
128         }
129         uint256 temp = value;
130         uint256 digits;
131         while (temp != 0) {
132             digits++;
133             temp /= 10;
134         }
135         bytes memory buffer = new bytes(digits);
136         while (value != 0) {
137             digits -= 1;
138             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
139             value /= 10;
140         }
141         return string(buffer);
142     }
143 
144     /**
145      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
146      */
147     function toHexString(uint256 value) internal pure returns (string memory) {
148         if (value == 0) {
149             return "0x00";
150         }
151         uint256 temp = value;
152         uint256 length = 0;
153         while (temp != 0) {
154             length++;
155             temp >>= 8;
156         }
157         return toHexString(value, length);
158     }
159 
160     /**
161      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
162      */
163     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
164         bytes memory buffer = new bytes(2 * length + 2);
165         buffer[0] = "0";
166         buffer[1] = "x";
167         for (uint256 i = 2 * length + 1; i > 1; --i) {
168             buffer[i] = _HEX_SYMBOLS[value & 0xf];
169             value >>= 4;
170         }
171         require(value == 0, "Strings: hex length insufficient");
172         return string(buffer);
173     }
174 }
175 
176 pragma solidity ^0.8.0;
177 
178 /**
179  * @dev Interface of the ERC165 standard, as defined in the
180  * https://eips.ethereum.org/EIPS/eip-165[EIP].
181  *
182  * Implementers can declare support of contract interfaces, which can then be
183  * queried by others ({ERC165Checker}).
184  *
185  * For an implementation, see {ERC165}.
186  */
187 interface IERC165 {
188     /**
189      * @dev Returns true if this contract implements the interface defined by
190      * `interfaceId`. See the corresponding
191      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
192      * to learn more about how these ids are created.
193      *
194      * This function call must use less than 30 000 gas.
195      */
196     function supportsInterface(bytes4 interfaceId) external view returns (bool);
197 }
198 
199 pragma solidity ^0.8.0;
200 
201 /**
202  * @dev Required interface of an ERC721 compliant contract.
203  */
204 interface IERC721 is IERC165 {
205     /**
206      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
207      */
208     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
209 
210     /**
211      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
212      */
213     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
214 
215     /**
216      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
217      */
218     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
219 
220     /**
221      * @dev Returns the number of tokens in ``owner``'s account.
222      */
223     function balanceOf(address owner) external view returns (uint256 balance);
224 
225     /**
226      * @dev Returns the owner of the `tokenId` token.
227      *
228      * Requirements:
229      *
230      * - `tokenId` must exist.
231      */
232     function ownerOf(uint256 tokenId) external view returns (address owner);
233 
234     /**
235      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
236      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
237      *
238      * Requirements:
239      *
240      * - `from` cannot be the zero address.
241      * - `to` cannot be the zero address.
242      * - `tokenId` token must exist and be owned by `from`.
243      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
244      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
245      *
246      * Emits a {Transfer} event.
247      */
248     function safeTransferFrom(
249         address from,
250         address to,
251         uint256 tokenId
252     ) external;
253 
254     /**
255      * @dev Transfers `tokenId` token from `from` to `to`.
256      *
257      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
258      *
259      * Requirements:
260      *
261      * - `from` cannot be the zero address.
262      * - `to` cannot be the zero address.
263      * - `tokenId` token must be owned by `from`.
264      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
265      *
266      * Emits a {Transfer} event.
267      */
268     function transferFrom(
269         address from,
270         address to,
271         uint256 tokenId
272     ) external;
273 
274     /**
275      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
276      * The approval is cleared when the token is transferred.
277      *
278      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
279      *
280      * Requirements:
281      *
282      * - The caller must own the token or be an approved operator.
283      * - `tokenId` must exist.
284      *
285      * Emits an {Approval} event.
286      */
287     function approve(address to, uint256 tokenId) external;
288 
289     /**
290      * @dev Returns the account approved for `tokenId` token.
291      *
292      * Requirements:
293      *
294      * - `tokenId` must exist.
295      */
296     function getApproved(uint256 tokenId) external view returns (address operator);
297 
298     /**
299      * @dev Approve or remove `operator` as an operator for the caller.
300      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
301      *
302      * Requirements:
303      *
304      * - The `operator` cannot be the caller.
305      *
306      * Emits an {ApprovalForAll} event.
307      */
308     function setApprovalForAll(address operator, bool _approved) external;
309 
310     /**
311      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
312      *
313      * See {setApprovalForAll}
314      */
315     function isApprovedForAll(address owner, address operator) external view returns (bool);
316 
317     /**
318      * @dev Safely transfers `tokenId` token from `from` to `to`.
319      *
320      * Requirements:
321      *
322      * - `from` cannot be the zero address.
323      * - `to` cannot be the zero address.
324      * - `tokenId` token must exist and be owned by `from`.
325      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
326      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
327      *
328      * Emits a {Transfer} event.
329      */
330     function safeTransferFrom(
331         address from,
332         address to,
333         uint256 tokenId,
334         bytes calldata data
335     ) external;
336 }
337 
338 pragma solidity ^0.8.0;
339 
340 
341 /**
342  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
343  * @dev See https://eips.ethereum.org/EIPS/eip-721
344  */
345 interface IERC721Enumerable is IERC721 {
346     /**
347      * @dev Returns the total amount of tokens stored by the contract.
348      */
349     function totalSupply() external view returns (uint256);
350 
351     /**
352      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
353      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
354      */
355     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
356 
357     /**
358      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
359      * Use along with {totalSupply} to enumerate all tokens.
360      */
361     function tokenByIndex(uint256 index) external view returns (uint256);
362 }
363 
364 pragma solidity ^0.8.0;
365 
366 /**
367  * @title ERC721 token receiver interface
368  * @dev Interface for any contract that wants to support safeTransfers
369  * from ERC721 asset contracts.
370  */
371 interface IERC721Receiver {
372     /**
373      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
374      * by `operator` from `from`, this function is called.
375      *
376      * It must return its Solidity selector to confirm the token transfer.
377      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
378      *
379      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
380      */
381     function onERC721Received(
382         address operator,
383         address from,
384         uint256 tokenId,
385         bytes calldata data
386     ) external returns (bytes4);
387 }
388 
389 pragma solidity ^0.8.0;
390 
391 /**
392  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
393  * @dev See https://eips.ethereum.org/EIPS/eip-721
394  */
395 interface IERC721Metadata is IERC721 {
396     /**
397      * @dev Returns the token collection name.
398      */
399     function name() external view returns (string memory);
400 
401     /**
402      * @dev Returns the token collection symbol.
403      */
404     function symbol() external view returns (string memory);
405 
406     /**
407      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
408      */
409     function tokenURI(uint256 tokenId) external view returns (string memory);
410 }
411 
412 
413 pragma solidity ^0.8.0;
414 
415 /**
416  * @dev Collection of functions related to the address type
417  */
418 library Address {
419     /**
420      * @dev Returns true if `account` is a contract.
421      *
422      * [IMPORTANT]
423      * ====
424      * It is unsafe to assume that an address for which this function returns
425      * false is an externally-owned account (EOA) and not a contract.
426      *
427      * Among others, `isContract` will return false for the following
428      * types of addresses:
429      *
430      *  - an externally-owned account
431      *  - a contract in construction
432      *  - an address where a contract will be created
433      *  - an address where a contract lived, but was destroyed
434      * ====
435      */
436     function isContract(address account) internal view returns (bool) {
437         // This method relies on extcodesize, which returns 0 for contracts in
438         // construction, since the code is only stored at the end of the
439         // constructor execution.
440 
441         uint256 size;
442         assembly {
443             size := extcodesize(account)
444         }
445         return size > 0;
446     }
447 
448     /**
449      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
450      * `recipient`, forwarding all available gas and reverting on errors.
451      *
452      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
453      * of certain opcodes, possibly making contracts go over the 2300 gas limit
454      * imposed by `transfer`, making them unable to receive funds via
455      * `transfer`. {sendValue} removes this limitation.
456      *
457      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
458      *
459      * IMPORTANT: because control is transferred to `recipient`, care must be
460      * taken to not create reentrancy vulnerabilities. Consider using
461      * {ReentrancyGuard} or the
462      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
463      */
464     function sendValue(address payable recipient, uint256 amount) internal {
465         require(address(this).balance >= amount, "Address: insufficient balance");
466 
467         (bool success, ) = recipient.call{value: amount}("");
468         require(success, "Address: unable to send value, recipient may have reverted");
469     }
470 
471     /**
472      * @dev Performs a Solidity function call using a low level `call`. A
473      * plain `call` is an unsafe replacement for a function call: use this
474      * function instead.
475      *
476      * If `target` reverts with a revert reason, it is bubbled up by this
477      * function (like regular Solidity function calls).
478      *
479      * Returns the raw returned data. To convert to the expected return value,
480      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
481      *
482      * Requirements:
483      *
484      * - `target` must be a contract.
485      * - calling `target` with `data` must not revert.
486      *
487      * _Available since v3.1._
488      */
489     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
490         return functionCall(target, data, "Address: low-level call failed");
491     }
492 
493     /**
494      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
495      * `errorMessage` as a fallback revert reason when `target` reverts.
496      *
497      * _Available since v3.1._
498      */
499     function functionCall(
500         address target,
501         bytes memory data,
502         string memory errorMessage
503     ) internal returns (bytes memory) {
504         return functionCallWithValue(target, data, 0, errorMessage);
505     }
506 
507     /**
508      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
509      * but also transferring `value` wei to `target`.
510      *
511      * Requirements:
512      *
513      * - the calling contract must have an ETH balance of at least `value`.
514      * - the called Solidity function must be `payable`.
515      *
516      * _Available since v3.1._
517      */
518     function functionCallWithValue(
519         address target,
520         bytes memory data,
521         uint256 value
522     ) internal returns (bytes memory) {
523         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
524     }
525 
526     /**
527      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
528      * with `errorMessage` as a fallback revert reason when `target` reverts.
529      *
530      * _Available since v3.1._
531      */
532     function functionCallWithValue(
533         address target,
534         bytes memory data,
535         uint256 value,
536         string memory errorMessage
537     ) internal returns (bytes memory) {
538         require(address(this).balance >= value, "Address: insufficient balance for call");
539         require(isContract(target), "Address: call to non-contract");
540 
541         (bool success, bytes memory returndata) = target.call{value: value}(data);
542         return verifyCallResult(success, returndata, errorMessage);
543     }
544 
545     /**
546      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
547      * but performing a static call.
548      *
549      * _Available since v3.3._
550      */
551     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
552         return functionStaticCall(target, data, "Address: low-level static call failed");
553     }
554 
555     /**
556      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
557      * but performing a static call.
558      *
559      * _Available since v3.3._
560      */
561     function functionStaticCall(
562         address target,
563         bytes memory data,
564         string memory errorMessage
565     ) internal view returns (bytes memory) {
566         require(isContract(target), "Address: static call to non-contract");
567 
568         (bool success, bytes memory returndata) = target.staticcall(data);
569         return verifyCallResult(success, returndata, errorMessage);
570     }
571 
572     /**
573      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
574      * but performing a delegate call.
575      *
576      * _Available since v3.4._
577      */
578     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
579         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
580     }
581 
582     /**
583      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
584      * but performing a delegate call.
585      *
586      * _Available since v3.4._
587      */
588     function functionDelegateCall(
589         address target,
590         bytes memory data,
591         string memory errorMessage
592     ) internal returns (bytes memory) {
593         require(isContract(target), "Address: delegate call to non-contract");
594 
595         (bool success, bytes memory returndata) = target.delegatecall(data);
596         return verifyCallResult(success, returndata, errorMessage);
597     }
598 
599     /**
600      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
601      * revert reason using the provided one.
602      *
603      * _Available since v4.3._
604      */
605     function verifyCallResult(
606         bool success,
607         bytes memory returndata,
608         string memory errorMessage
609     ) internal pure returns (bytes memory) {
610         if (success) {
611             return returndata;
612         } else {
613             // Look for revert reason and bubble it up if present
614             if (returndata.length > 0) {
615                 // The easiest way to bubble the revert reason is using memory via assembly
616 
617                 assembly {
618                     let returndata_size := mload(returndata)
619                     revert(add(32, returndata), returndata_size)
620                 }
621             } else {
622                 revert(errorMessage);
623             }
624         }
625     }
626 }
627 
628 
629 pragma solidity ^0.8.0;
630 
631 /**
632  * @dev Implementation of the {IERC165} interface.
633  *
634  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
635  * for the additional interface id that will be supported. For example:
636  *
637  * ```solidity
638  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
639  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
640  * }
641  * ```
642  *
643  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
644  */
645 abstract contract ERC165 is IERC165 {
646     /**
647      * @dev See {IERC165-supportsInterface}.
648      */
649     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
650         return interfaceId == type(IERC165).interfaceId;
651     }
652 }
653 
654 pragma solidity ^0.8.10;
655 
656 abstract contract ERC721P is Context, ERC165, IERC721, IERC721Metadata {
657     using Address for address;
658     string private _name;
659     string private _symbol;
660     address[] internal _owners;
661     mapping(uint256 => address) private _tokenApprovals;
662     mapping(address => mapping(address => bool)) private _operatorApprovals;
663     constructor(string memory name_, string memory symbol_) {
664         _name = name_;
665         _symbol = symbol_;
666     }
667     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
668         return
669         interfaceId == type(IERC721).interfaceId ||
670         interfaceId == type(IERC721Metadata).interfaceId ||
671         super.supportsInterface(interfaceId);
672     }
673     function balanceOf(address owner) public view virtual override returns (uint256) {
674         require(owner != address(0), "ERC721: balance query for the zero address");
675         uint count = 0;
676         uint length = _owners.length;
677         for( uint i = 0; i < length; ++i ){
678             if( owner == _owners[i] ){
679                 ++count;
680             }
681         }
682         delete length;
683         return count;
684     }
685     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
686         address owner = _owners[tokenId];
687         require(owner != address(0), "ERC721: owner query for nonexistent token");
688         return owner;
689     }
690     function name() public view virtual override returns (string memory) {
691         return _name;
692     }
693     function symbol() public view virtual override returns (string memory) {
694         return _symbol;
695     }
696     function approve(address to, uint256 tokenId) public virtual override {
697         address owner = ERC721P.ownerOf(tokenId);
698         require(to != owner, "ERC721: approval to current owner");
699 
700         require(
701             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
702             "ERC721: approve caller is not owner nor approved for all"
703         );
704 
705         _approve(to, tokenId);
706     }
707     function getApproved(uint256 tokenId) public view virtual override returns (address) {
708         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
709 
710         return _tokenApprovals[tokenId];
711     }
712     function setApprovalForAll(address operator, bool approved) public virtual override {
713         require(operator != _msgSender(), "ERC721: approve to caller");
714 
715         _operatorApprovals[_msgSender()][operator] = approved;
716         emit ApprovalForAll(_msgSender(), operator, approved);
717     }
718     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
719         return _operatorApprovals[owner][operator];
720     }
721     function transferFrom(
722         address from,
723         address to,
724         uint256 tokenId
725     ) public virtual override {
726         //solhint-disable-next-line max-line-length
727         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
728 
729         _transfer(from, to, tokenId);
730     }
731     function safeTransferFrom(
732         address from,
733         address to,
734         uint256 tokenId
735     ) public virtual override {
736         safeTransferFrom(from, to, tokenId, "");
737     }
738     function safeTransferFrom(
739         address from,
740         address to,
741         uint256 tokenId,
742         bytes memory _data
743     ) public virtual override {
744         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
745         _safeTransfer(from, to, tokenId, _data);
746     }
747     function _safeTransfer(
748         address from,
749         address to,
750         uint256 tokenId,
751         bytes memory _data
752     ) internal virtual {
753         _transfer(from, to, tokenId);
754         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
755     }
756     function _exists(uint256 tokenId) internal view virtual returns (bool) {
757         return tokenId < _owners.length && _owners[tokenId] != address(0);
758     }
759     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
760         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
761         address owner = ERC721P.ownerOf(tokenId);
762         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
763     }
764     function _safeMint(address to, uint256 tokenId) internal virtual {
765         _safeMint(to, tokenId, "");
766     }
767     function _safeMint(
768         address to,
769         uint256 tokenId,
770         bytes memory _data
771     ) internal virtual {
772         _mint(to, tokenId);
773         require(
774             _checkOnERC721Received(address(0), to, tokenId, _data),
775             "ERC721: transfer to non ERC721Receiver implementer"
776         );
777     }
778     function _mint(address to, uint256 tokenId) internal virtual {
779         require(to != address(0), "ERC721: mint to the zero address");
780         require(!_exists(tokenId), "ERC721: token already minted");
781 
782         _beforeTokenTransfer(address(0), to, tokenId);
783         _owners.push(to);
784 
785         emit Transfer(address(0), to, tokenId);
786     }
787     function _burn(uint256 tokenId) internal virtual {
788         address owner = ERC721P.ownerOf(tokenId);
789 
790         _beforeTokenTransfer(owner, address(0), tokenId);
791 
792         // Clear approvals
793         _approve(address(0), tokenId);
794         _owners[tokenId] = address(0);
795 
796         emit Transfer(owner, address(0), tokenId);
797     }
798     function _transfer(
799         address from,
800         address to,
801         uint256 tokenId
802     ) internal virtual {
803         require(ERC721P.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
804         require(to != address(0), "ERC721: transfer to the zero address");
805 
806         _beforeTokenTransfer(from, to, tokenId);
807 
808         // Clear approvals from the previous owner
809         _approve(address(0), tokenId);
810         _owners[tokenId] = to;
811 
812         emit Transfer(from, to, tokenId);
813     }
814     function _approve(address to, uint256 tokenId) internal virtual {
815         _tokenApprovals[tokenId] = to;
816         emit Approval(ERC721P.ownerOf(tokenId), to, tokenId);
817     }
818     function _checkOnERC721Received(
819         address from,
820         address to,
821         uint256 tokenId,
822         bytes memory _data
823     ) private returns (bool) {
824         if (to.isContract()) {
825             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
826                 return retval == IERC721Receiver.onERC721Received.selector;
827             } catch (bytes memory reason) {
828                 if (reason.length == 0) {
829                     revert("ERC721: transfer to non ERC721Receiver implementer");
830                 } else {
831                     assembly {
832                         revert(add(32, reason), mload(reason))
833                     }
834                 }
835             }
836         } else {
837             return true;
838         }
839     }
840     function _beforeTokenTransfer(
841         address from,
842         address to,
843         uint256 tokenId
844     ) internal virtual {}
845 }
846 
847 pragma solidity ^0.8.10;
848 
849 abstract contract ERC721Enum is ERC721P, IERC721Enumerable {
850     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721P) returns (bool) {
851         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
852     }
853     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256 tokenId) {
854         require(index < ERC721P.balanceOf(owner), "ERC721Enum: owner ioob");
855         uint count;
856         for( uint i; i < _owners.length; ++i ){
857             if( owner == _owners[i] ){
858                 if( count == index )
859                     return i;
860                 else
861                     ++count;
862             }
863         }
864         require(false, "ERC721Enum: owner ioob");
865     }
866     function tokensOfOwner(address owner) public view returns (uint256[] memory) {
867         require(0 < ERC721P.balanceOf(owner), "ERC721Enum: owner ioob");
868         uint256 tokenCount = balanceOf(owner);
869         uint256[] memory tokenIds = new uint256[](tokenCount);
870         for (uint256 i = 0; i < tokenCount; i++) {
871             tokenIds[i] = tokenOfOwnerByIndex(owner, i);
872         }
873         return tokenIds;
874     }
875     function totalSupply() public view virtual override returns (uint256) {
876         return _owners.length;
877     }
878     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
879         require(index < ERC721Enum.totalSupply(), "ERC721Enum: global ioob");
880         return index;
881     }
882 }
883 
884 pragma solidity ^0.8.0;
885 
886 /**
887  * @dev Contract module which allows children to implement an emergency stop
888  * mechanism that can be triggered by an authorized account.
889  *
890  * This module is used through inheritance. It will make available the
891  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
892  * the functions of your contract. Note that they will not be pausable by
893  * simply including this module, only once the modifiers are put in place.
894  */
895 abstract contract Pausable is Context {
896     /**
897      * @dev Emitted when the pause is triggered by `account`.
898      */
899     event Paused(address account);
900 
901     /**
902      * @dev Emitted when the pause is lifted by `account`.
903      */
904     event Unpaused(address account);
905 
906     bool private _paused;
907 
908     /**
909      * @dev Initializes the contract in unpaused state.
910      */
911     constructor() {
912         _paused = false;
913     }
914 
915     /**
916      * @dev Returns true if the contract is paused, and false otherwise.
917      */
918     function paused() public view virtual returns (bool) {
919         return _paused;
920     }
921 
922     /**
923      * @dev Modifier to make a function callable only when the contract is not paused.
924      *
925      * Requirements:
926      *
927      * - The contract must not be paused.
928      */
929     modifier whenNotPaused() {
930         require(!paused(), "Pausable: paused");
931         _;
932     }
933 
934     /**
935      * @dev Modifier to make a function callable only when the contract is paused.
936      *
937      * Requirements:
938      *
939      * - The contract must be paused.
940      */
941     modifier whenPaused() {
942         require(paused(), "Pausable: not paused");
943         _;
944     }
945 
946     /**
947      * @dev Triggers stopped state.
948      *
949      * Requirements:
950      *
951      * - The contract must not be paused.
952      */
953     function _pause() internal virtual whenNotPaused {
954         _paused = true;
955         emit Paused(_msgSender());
956     }
957 
958     /**
959      * @dev Returns to normal state.
960      *
961      * Requirements:
962      *
963      * - The contract must be paused.
964      */
965     function _unpause() internal virtual whenPaused {
966         _paused = false;
967         emit Unpaused(_msgSender());
968     }
969 }
970 
971 pragma solidity ^0.8.0;
972 
973 /**
974  * @dev Library for managing
975  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
976  * types.
977  *
978  * Sets have the following properties:
979  *
980  * - Elements are added, removed, and checked for existence in constant time
981  * (O(1)).
982  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
983  *
984  * ```
985  * contract Example {
986  *     // Add the library methods
987  *     using EnumerableSet for EnumerableSet.AddressSet;
988  *
989  *     // Declare a set state variable
990  *     EnumerableSet.AddressSet private mySet;
991  * }
992  * ```
993  *
994  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
995  * and `uint256` (`UintSet`) are supported.
996  */
997 library EnumerableSet {
998     // To implement this library for multiple types with as little code
999     // repetition as possible, we write it in terms of a generic Set type with
1000     // bytes32 values.
1001     // The Set implementation uses private functions, and user-facing
1002     // implementations (such as AddressSet) are just wrappers around the
1003     // underlying Set.
1004     // This means that we can only create new EnumerableSets for types that fit
1005     // in bytes32.
1006 
1007     struct Set {
1008         // Storage of set values
1009         bytes32[] _values;
1010         // Position of the value in the `values` array, plus 1 because index 0
1011         // means a value is not in the set.
1012         mapping(bytes32 => uint256) _indexes;
1013     }
1014 
1015     /**
1016      * @dev Add a value to a set. O(1).
1017      *
1018      * Returns true if the value was added to the set, that is if it was not
1019      * already present.
1020      */
1021     function _add(Set storage set, bytes32 value) private returns (bool) {
1022         if (!_contains(set, value)) {
1023             set._values.push(value);
1024             // The value is stored at length-1, but we add 1 to all indexes
1025             // and use 0 as a sentinel value
1026             set._indexes[value] = set._values.length;
1027             return true;
1028         } else {
1029             return false;
1030         }
1031     }
1032 
1033     /**
1034      * @dev Removes a value from a set. O(1).
1035      *
1036      * Returns true if the value was removed from the set, that is if it was
1037      * present.
1038      */
1039     function _remove(Set storage set, bytes32 value) private returns (bool) {
1040         // We read and store the value's index to prevent multiple reads from the same storage slot
1041         uint256 valueIndex = set._indexes[value];
1042 
1043         if (valueIndex != 0) {
1044             // Equivalent to contains(set, value)
1045             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
1046             // the array, and then remove the last element (sometimes called as 'swap and pop').
1047             // This modifies the order of the array, as noted in {at}.
1048 
1049             uint256 toDeleteIndex = valueIndex - 1;
1050             uint256 lastIndex = set._values.length - 1;
1051 
1052             if (lastIndex != toDeleteIndex) {
1053                 bytes32 lastvalue = set._values[lastIndex];
1054 
1055                 // Move the last value to the index where the value to delete is
1056                 set._values[toDeleteIndex] = lastvalue;
1057                 // Update the index for the moved value
1058                 set._indexes[lastvalue] = valueIndex; // Replace lastvalue's index to valueIndex
1059             }
1060 
1061             // Delete the slot where the moved value was stored
1062             set._values.pop();
1063 
1064             // Delete the index for the deleted slot
1065             delete set._indexes[value];
1066 
1067             return true;
1068         } else {
1069             return false;
1070         }
1071     }
1072 
1073     /**
1074      * @dev Returns true if the value is in the set. O(1).
1075      */
1076     function _contains(Set storage set, bytes32 value) private view returns (bool) {
1077         return set._indexes[value] != 0;
1078     }
1079 
1080     /**
1081      * @dev Returns the number of values on the set. O(1).
1082      */
1083     function _length(Set storage set) private view returns (uint256) {
1084         return set._values.length;
1085     }
1086 
1087     /**
1088      * @dev Returns the value stored at position `index` in the set. O(1).
1089      *
1090      * Note that there are no guarantees on the ordering of values inside the
1091      * array, and it may change when more values are added or removed.
1092      *
1093      * Requirements:
1094      *
1095      * - `index` must be strictly less than {length}.
1096      */
1097     function _at(Set storage set, uint256 index) private view returns (bytes32) {
1098         return set._values[index];
1099     }
1100 
1101     /**
1102      * @dev Return the entire set in an array
1103      *
1104      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
1105      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
1106      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
1107      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
1108      */
1109     function _values(Set storage set) private view returns (bytes32[] memory) {
1110         return set._values;
1111     }
1112 
1113     // Bytes32Set
1114 
1115     struct Bytes32Set {
1116         Set _inner;
1117     }
1118 
1119     /**
1120      * @dev Add a value to a set. O(1).
1121      *
1122      * Returns true if the value was added to the set, that is if it was not
1123      * already present.
1124      */
1125     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
1126         return _add(set._inner, value);
1127     }
1128 
1129     /**
1130      * @dev Removes a value from a set. O(1).
1131      *
1132      * Returns true if the value was removed from the set, that is if it was
1133      * present.
1134      */
1135     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
1136         return _remove(set._inner, value);
1137     }
1138 
1139     /**
1140      * @dev Returns true if the value is in the set. O(1).
1141      */
1142     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
1143         return _contains(set._inner, value);
1144     }
1145 
1146     /**
1147      * @dev Returns the number of values in the set. O(1).
1148      */
1149     function length(Bytes32Set storage set) internal view returns (uint256) {
1150         return _length(set._inner);
1151     }
1152 
1153     /**
1154      * @dev Returns the value stored at position `index` in the set. O(1).
1155      *
1156      * Note that there are no guarantees on the ordering of values inside the
1157      * array, and it may change when more values are added or removed.
1158      *
1159      * Requirements:
1160      *
1161      * - `index` must be strictly less than {length}.
1162      */
1163     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
1164         return _at(set._inner, index);
1165     }
1166 
1167     /**
1168      * @dev Return the entire set in an array
1169      *
1170      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
1171      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
1172      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
1173      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
1174      */
1175     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
1176         return _values(set._inner);
1177     }
1178 
1179     // AddressSet
1180 
1181     struct AddressSet {
1182         Set _inner;
1183     }
1184 
1185     /**
1186      * @dev Add a value to a set. O(1).
1187      *
1188      * Returns true if the value was added to the set, that is if it was not
1189      * already present.
1190      */
1191     function add(AddressSet storage set, address value) internal returns (bool) {
1192         return _add(set._inner, bytes32(uint256(uint160(value))));
1193     }
1194 
1195     /**
1196      * @dev Removes a value from a set. O(1).
1197      *
1198      * Returns true if the value was removed from the set, that is if it was
1199      * present.
1200      */
1201     function remove(AddressSet storage set, address value) internal returns (bool) {
1202         return _remove(set._inner, bytes32(uint256(uint160(value))));
1203     }
1204 
1205     /**
1206      * @dev Returns true if the value is in the set. O(1).
1207      */
1208     function contains(AddressSet storage set, address value) internal view returns (bool) {
1209         return _contains(set._inner, bytes32(uint256(uint160(value))));
1210     }
1211 
1212     /**
1213      * @dev Returns the number of values in the set. O(1).
1214      */
1215     function length(AddressSet storage set) internal view returns (uint256) {
1216         return _length(set._inner);
1217     }
1218 
1219     /**
1220      * @dev Returns the value stored at position `index` in the set. O(1).
1221      *
1222      * Note that there are no guarantees on the ordering of values inside the
1223      * array, and it may change when more values are added or removed.
1224      *
1225      * Requirements:
1226      *
1227      * - `index` must be strictly less than {length}.
1228      */
1229     function at(AddressSet storage set, uint256 index) internal view returns (address) {
1230         return address(uint160(uint256(_at(set._inner, index))));
1231     }
1232 
1233     /**
1234      * @dev Return the entire set in an array
1235      *
1236      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
1237      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
1238      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
1239      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
1240      */
1241     function values(AddressSet storage set) internal view returns (address[] memory) {
1242         bytes32[] memory store = _values(set._inner);
1243         address[] memory result;
1244 
1245         assembly {
1246             result := store
1247         }
1248 
1249         return result;
1250     }
1251 
1252     // UintSet
1253 
1254     struct UintSet {
1255         Set _inner;
1256     }
1257 
1258     /**
1259      * @dev Add a value to a set. O(1).
1260      *
1261      * Returns true if the value was added to the set, that is if it was not
1262      * already present.
1263      */
1264     function add(UintSet storage set, uint256 value) internal returns (bool) {
1265         return _add(set._inner, bytes32(value));
1266     }
1267 
1268     /**
1269      * @dev Removes a value from a set. O(1).
1270      *
1271      * Returns true if the value was removed from the set, that is if it was
1272      * present.
1273      */
1274     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1275         return _remove(set._inner, bytes32(value));
1276     }
1277 
1278     /**
1279      * @dev Returns true if the value is in the set. O(1).
1280      */
1281     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1282         return _contains(set._inner, bytes32(value));
1283     }
1284 
1285     /**
1286      * @dev Returns the number of values on the set. O(1).
1287      */
1288     function length(UintSet storage set) internal view returns (uint256) {
1289         return _length(set._inner);
1290     }
1291 
1292     /**
1293      * @dev Returns the value stored at position `index` in the set. O(1).
1294      *
1295      * Note that there are no guarantees on the ordering of values inside the
1296      * array, and it may change when more values are added or removed.
1297      *
1298      * Requirements:
1299      *
1300      * - `index` must be strictly less than {length}.
1301      */
1302     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1303         return uint256(_at(set._inner, index));
1304     }
1305 
1306     /**
1307      * @dev Return the entire set in an array
1308      *
1309      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
1310      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
1311      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
1312      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
1313      */
1314     function values(UintSet storage set) internal view returns (uint256[] memory) {
1315         bytes32[] memory store = _values(set._inner);
1316         uint256[] memory result;
1317 
1318         assembly {
1319             result := store
1320         }
1321 
1322         return result;
1323     }
1324 }
1325 
1326 pragma solidity ^0.8.10;
1327 
1328 interface IBoostWatcher {
1329     function watchBooster(address _collection, uint256[] calldata _tokenIds, uint256[] calldata _startDates) external;
1330 }
1331 
1332 interface IERC20 {
1333     function totalSupply() external view returns (uint256);
1334     function balanceOf(address account) external view returns (uint256);
1335     function allowance(address owner, address spender) external view returns (uint256);
1336     function burn(address add, uint256 amount) external;
1337     function transfer(address recipient, uint256 amount) external returns (bool);
1338     function approve(address spender, uint256 amount) external returns (bool);
1339     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
1340 }
1341 
1342 contract HumansOfTheMetaverseRealEstate is ERC721Enum, Ownable, Pausable {
1343     using EnumerableSet for EnumerableSet.UintSet;
1344     using EnumerableSet for EnumerableSet.AddressSet;
1345     using Strings for uint256;
1346 
1347     uint8 bonusPercentage = 20;
1348 
1349     // business logic constants
1350     uint16 private constant LAND = 1;
1351     uint256 private constant ETHER = 1e18;
1352 
1353     string private baseURI;
1354     address public tokenAddress;
1355 
1356     struct Coordinate {
1357         int32 layer;
1358         int256 x;
1359         int256 y;
1360     }
1361 
1362     struct LayerConfiguration {
1363         bool lock;
1364         int32 layer;
1365         uint256 length;
1366         mapping(uint16 => uint32) typesPricing; // real estate prices will be dependent on the layer they are in
1367         mapping(uint256 => uint256) rangePricing;
1368     }
1369 
1370     EnumerableSet.AddressSet collections;
1371     EnumerableSet.AddressSet allowedRealEstateModifiers;
1372 
1373     mapping(int32 => LayerConfiguration) layerConfigurationMap;
1374 
1375     mapping(bytes32 => uint8) buildingEnrolmentSlotsMapping; // layer + buildingType => Enrolment
1376 
1377     mapping(bytes32 => bool) realEstateOccupancyMapping; // layer + x + y => bool
1378 
1379     mapping(bytes32 => bool) humanEnrolmentMapping; // address + tokenId => layer + x + y
1380 
1381     mapping(uint256 => EnumerableSet.UintSet) tokenEnrolmentEmployeesMapping;
1382     mapping(uint256 => uint64) tokensTypeMapping;
1383     mapping(uint256 => Coordinate) tokensCoordinates;
1384 
1385     // events
1386     event RealEstateMinted(uint256[] tokenIds, Coordinate[] coordinates, address caller);
1387     event RealEstateChanges(uint256[] tokenIds, uint16[] realEstateTypes, address caller);
1388     event RealEstateEnrolment(uint256[] tokenIds, uint256 office, uint256 timestamp, address caller, address collection);
1389     event RealEstateEnrolmentRetrieval(uint256[] tokenIds, uint256 office, uint256 timestamp, address caller, address collection);
1390 
1391 
1392     constructor(
1393         string memory _name,
1394         string memory _symbol,
1395         string memory _initBaseURI,
1396         address[] memory _collectionAddresses,
1397         address _tokenAddress
1398     ) ERC721P(_name, _symbol) {
1399         _pause();
1400         setBaseURI(_initBaseURI);
1401 
1402         for (uint8 i = 0; i < _collectionAddresses.length; ++i) {
1403             collections.add(_collectionAddresses[i]);
1404         }
1405 
1406         tokenAddress = _tokenAddress;
1407     }
1408 
1409     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1410         baseURI = _newBaseURI;
1411     }
1412 
1413     function pause() external onlyOwner {
1414         _pause();
1415     }
1416 
1417     function unpause() external onlyOwner {
1418         _unpause();
1419     }
1420 
1421     function setTokenAddress(address _address) external onlyOwner {
1422         tokenAddress = _address;
1423     }
1424 
1425     function addAllowedModifiers(address[] calldata _modifierAddresses) external onlyOwner {
1426         for (uint8 i = 0; i < _modifierAddresses.length; ++i) {
1427             allowedRealEstateModifiers.add(_modifierAddresses[i]);
1428         }
1429     }
1430 
1431     function removeAllowedModifiers(address[] calldata _modifierAddresses) external onlyOwner {
1432         for (uint8 i = 0; i < _modifierAddresses.length; ++i) {
1433             allowedRealEstateModifiers.remove(_modifierAddresses[i]);
1434         }
1435     }
1436 
1437     function addCollection(address _collection) external onlyOwner {
1438         collections.add(_collection);
1439     }
1440 
1441     function removeCollection(address _collection) external onlyOwner {
1442         require(collections.contains(_collection), "Specified address not found");
1443         collections.remove(_collection);
1444     }
1445 
1446     function setOfficeBoost(uint8 _boost) external onlyOwner {
1447         bonusPercentage = _boost;
1448     }
1449 
1450     function withdrawTokens() external onlyOwner {
1451         IERC20(tokenAddress).transfer(msg.sender, IERC20(tokenAddress).balanceOf(address(this)));
1452     }
1453 
1454     function setLayerConfiguration(
1455         int32 _layer,
1456         uint256 _length,
1457         uint16[] calldata _realEstateTypes,
1458         uint32[] calldata _realEstatePrices,
1459         uint8[] calldata _slots,
1460         uint256[] calldata _landPrices
1461     ) external onlyOwner {
1462         require(
1463             _realEstateTypes.length == _realEstatePrices.length
1464             && _realEstatePrices.length == _slots.length
1465             && _landPrices.length == _length / 2,
1466             "Incorrect input"
1467         );
1468 
1469         LayerConfiguration storage layerConfiguration = layerConfigurationMap[_layer];
1470         layerConfiguration.layer = _layer;
1471         layerConfiguration.length = _length;
1472 
1473         for (uint8 i = 0; i < _realEstateTypes.length; ++i) {
1474             layerConfiguration.typesPricing[_realEstateTypes[i]] = _realEstatePrices[i];
1475             buildingEnrolmentSlotsMapping[
1476             keccak256(abi.encode(_layer, _realEstateTypes[i]))
1477             ] = _slots[i];
1478         }
1479 
1480         for(uint256 i = 0; i < _length / 2; ++i) {
1481             layerConfiguration.rangePricing[i * 2] = _landPrices[i];
1482         }
1483     }
1484 
1485     function setLayerLock(int32 _layer, bool _lock) external onlyOwner {
1486         LayerConfiguration storage layerConfiguration = _getLayerConfiguration(_layer);
1487         layerConfiguration.lock = _lock;
1488     }
1489 
1490     function setLayerLength(int32 _layer, uint256 _length, uint256[] calldata _additionalPrices) external onlyOwner {
1491         LayerConfiguration storage layerConfiguration = _getLayerConfiguration(_layer);
1492 
1493         require(_additionalPrices.length == (_length / 2 - layerConfiguration.length / 2), "Incorrect input");
1494 
1495         for(uint256 i = layerConfiguration.length / 2; i < _length / 2; ++i) {
1496             layerConfiguration.rangePricing[i * 2] = _additionalPrices[i - layerConfiguration.length / 2];
1497         }
1498 
1499         layerConfiguration.length = _length;
1500 
1501     }
1502 
1503     function setLayerLandPricing(int32 _layer, uint256[] calldata prices) external onlyOwner {
1504         LayerConfiguration storage layerConfiguration = _getLayerConfiguration(_layer);
1505 
1506         require(prices.length == layerConfiguration.length / 2, "Incorrect input");
1507 
1508         for (uint256 i = 0; i < layerConfiguration.length / 2; ++i) {
1509             layerConfiguration.rangePricing[i * 2] = prices[i];
1510         }
1511 
1512     }
1513 
1514     function setLayerTypesPricing(
1515         int32 _layer,
1516         uint16[] calldata realEstateTypes,
1517         uint32[] calldata realEstatePrices
1518     ) external onlyOwner {
1519         require(realEstateTypes.length == realEstatePrices.length, "Incorrect input");
1520         LayerConfiguration storage layerConfiguration = _getLayerConfiguration(_layer);
1521 
1522         for (uint16 i = 0; i < realEstateTypes.length; ++i) {
1523             layerConfiguration.typesPricing[realEstateTypes[i]] = realEstatePrices[i];
1524         }
1525     }
1526 
1527     function removeLayerTypesPricing(int32 _layer, uint16[] calldata realEstateTypes) external onlyOwner {
1528         LayerConfiguration storage layerConfiguration = _getLayerConfiguration(_layer);
1529         for (uint256 i = 0; i < realEstateTypes.length; ++i) {
1530             delete layerConfiguration.typesPricing[realEstateTypes[i]];
1531             delete buildingEnrolmentSlotsMapping[keccak256(abi.encode(_layer, realEstateTypes[i]))];
1532         }
1533     }
1534 
1535     function setLayerRealEstateTypeEnrolmentConfig(int32 _layer, uint16[] calldata _realEstateTypes, uint8[] calldata _slots) external onlyOwner {
1536         require(_realEstateTypes.length == _slots.length, "Incorrect input");
1537         for (uint64 i = 0; i < _realEstateTypes.length; ++i) {
1538             buildingEnrolmentSlotsMapping[keccak256(abi.encode(_layer, _realEstateTypes[i]))] = _slots[i];
1539         }
1540     }
1541 
1542     function _baseURI() internal view virtual returns (string memory) {
1543         return baseURI;
1544     }
1545 
1546     function _getLayerConfiguration(int32 _layer) internal view returns (LayerConfiguration storage) {
1547         LayerConfiguration storage layerConfiguration = layerConfigurationMap[_layer];
1548         require(layerConfiguration.length != uint256(0), "There is no configuration for provided layer");
1549 
1550         return layerConfiguration;
1551     }
1552 
1553     function _abs(int256 x) internal pure returns(uint256) {
1554         return x >= 0 ? uint256(x) : uint256(-x);
1555     }
1556 
1557     function buyLand(Coordinate[] memory _coordinates) external whenNotPaused payable {
1558         uint256 price = calculateLandPrice(_coordinates);
1559 
1560         uint256[] memory tokenIds = occupyLand(_coordinates);
1561 
1562         IERC20(tokenAddress).transferFrom(msg.sender, address(this), price *  ETHER);
1563 
1564         emit RealEstateMinted(tokenIds, _coordinates, msg.sender);
1565 
1566         delete price;
1567         delete tokenIds;
1568     }
1569 
1570     function changeRealEstate(uint256[] calldata _tokenIds, uint16[] calldata _realEstateNewTypes) external whenNotPaused payable {
1571         require(_tokenIds.length == _realEstateNewTypes.length, "Incorrect input dat");
1572 
1573         validateTokensToBeChanged(_tokenIds, _realEstateNewTypes);
1574 
1575         uint256 price = calculateRealEstatePrice(_tokenIds, _realEstateNewTypes);
1576 
1577         for (uint64 i = 0; i < _tokenIds.length; ++i) {
1578             tokensTypeMapping[_tokenIds[i]] = _realEstateNewTypes[i];
1579         }
1580 
1581         IERC20(tokenAddress).transferFrom(msg.sender, address(this), price * ETHER);
1582 
1583         emit RealEstateChanges(_tokenIds, _realEstateNewTypes, msg.sender);
1584 
1585         delete price;
1586     }
1587 
1588     function externalChangeRealEstate(uint256[] calldata _tokenIds, uint16[] calldata _realEstateNewTypes, address owner, uint256 amount) external whenNotPaused {
1589         require(allowedRealEstateModifiers.contains(msg.sender), "Not an allowed real estate changer");
1590         require(_tokenIds.length == _realEstateNewTypes.length, "Incorrect input data");
1591 
1592         validateTokensToBeChanged(_tokenIds, _realEstateNewTypes);
1593 
1594         for (uint64 i = 0; i < _tokenIds.length; ++i) {
1595             tokensTypeMapping[_tokenIds[i]] = _realEstateNewTypes[i];
1596         }
1597 
1598         IERC20(tokenAddress).transferFrom(owner, address(this),  amount * ETHER);
1599 
1600         emit RealEstateChanges(_tokenIds, _realEstateNewTypes, owner);
1601     }
1602 
1603     function validateTokensToBeChanged(uint256[] calldata _tokenIds, uint16[] calldata _realEstateNewTypes) internal view {
1604 
1605         for (uint64 i = 0; i < _tokenIds.length; ++i) {
1606             if (tokensTypeMapping[_tokenIds[i]] == _realEstateNewTypes[i]) {
1607                 revert("Operation not allowed");
1608             }
1609 
1610             require(msg.sender == ownerOf(_tokenIds[i]), "Not the owner of the real estate piece");
1611         }
1612     }
1613 
1614     function calculateLandPrice(Coordinate[] memory _coordinates) public view returns(uint256) {
1615         validateCoordinates(_coordinates);
1616         uint256 price = 0;
1617 
1618         for(uint128 i = 0; i < _coordinates.length; ++i) {
1619             Coordinate memory coordinate = _coordinates[i];
1620             LayerConfiguration storage layerConfiguration = _getLayerConfiguration(coordinate.layer);
1621 
1622             uint256 landPriceIndex = uint256(_abs(coordinate.x) + _abs(coordinate.y));
1623 
1624             landPriceIndex = landPriceIndex % 2 == 1 ? landPriceIndex - 1 : landPriceIndex;
1625 
1626             price += layerConfiguration.rangePricing[landPriceIndex];
1627         }
1628 
1629         return price;
1630     }
1631 
1632     function calculateRealEstatePrice(uint256[] calldata _tokenIds, uint16[] calldata _realEstateTypes) public view returns(uint256) {
1633         uint256 price = 0;
1634 
1635         for(uint128 i = 0; i < _tokenIds.length; ++i) {
1636 
1637             LayerConfiguration storage layerConfiguration = _getLayerConfiguration(tokensCoordinates[_tokenIds[i]].layer);
1638 
1639             uint256 realEstatePrice = layerConfiguration.typesPricing[_realEstateTypes[i]];
1640 
1641             require(realEstatePrice != uint32(0), "Unsupported building type");
1642 
1643             price += realEstatePrice;
1644 
1645         }
1646 
1647         return price;
1648     }
1649 
1650     function validateCoordinates(Coordinate[] memory _coordinates) public view {
1651         for (uint256 i = 0; i < _coordinates.length; ++i) {
1652             Coordinate memory coordinate = _coordinates[i];
1653             LayerConfiguration storage layerConfiguration = _getLayerConfiguration(coordinate.layer);
1654 
1655             require(
1656                 _abs(coordinate.x) < layerConfiguration.length / 2
1657                 && _abs(coordinate.y) < layerConfiguration.length / 2
1658                 && !realEstateOccupancyMapping[keccak256(abi.encode(coordinate.x, coordinate.y, coordinate.layer))],
1659                 "Coordinates invalid"
1660             );
1661         }
1662     }
1663 
1664     function enrollInOffice(uint256[] calldata _workers, uint256 _office, address _collection) external whenNotPaused {
1665 
1666         require(collections.contains(_collection), "Not amongst enrollable collections");
1667         require(ownerOf(_office) == msg.sender, "Not the owner of the office");
1668 
1669         if (
1670             buildingEnrolmentSlotsMapping[keccak256(abi.encode(tokensCoordinates[_office].layer, tokensTypeMapping[_office]))]
1671             - tokenEnrolmentEmployeesMapping[_office].length()
1672             < _workers.length
1673         ) {
1674             revert("The office does not have enough slots available");
1675         }
1676 
1677         for (uint8 i = 0; i < _workers.length; ++i) {
1678             require(IERC721(_collection).ownerOf(_workers[i]) == msg.sender, "Not the owner of the humans");
1679             require(!humanEnrolmentMapping[keccak256(abi.encode(_collection, _workers[i]))], "Human already enrolled");
1680             tokenEnrolmentEmployeesMapping[_office].add(_workers[i]);
1681             humanEnrolmentMapping[keccak256(abi.encode(_collection, _workers[i]))] = true;
1682         }
1683 
1684         uint256 value = block.timestamp;
1685 
1686         notifyYielder(value, _collection, _workers);
1687 
1688         emit RealEstateEnrolment(_workers, _office, value, msg.sender, _collection);
1689 
1690         delete value;
1691 
1692     }
1693 
1694     function retrieveHuman(uint256[] calldata _workers, uint256 _office, address _collection) external whenNotPaused {
1695         require(collections.contains(_collection));
1696         require(ownerOf(_office) == msg.sender);
1697 
1698         for (uint8 i = 0; i < _workers.length; ++i) {
1699             require(IERC721(_collection).ownerOf(_workers[i]) == msg.sender);
1700             require(humanEnrolmentMapping[keccak256(abi.encode(_collection, _workers[i]))], "Human not enrolled");
1701             require(tokenEnrolmentEmployeesMapping[_office].contains(_workers[i]), "Human not enrolled in specified office");
1702             tokenEnrolmentEmployeesMapping[_office].remove(_workers[i]);
1703             humanEnrolmentMapping[keccak256(abi.encode(_collection, _workers[i]))] = false;
1704         }
1705 
1706         notifyYielder(0, _collection, _workers);
1707 
1708         emit RealEstateEnrolmentRetrieval(_workers, _office, 0, msg.sender, _collection);
1709     }
1710 
1711     function notifyYielder(uint256 value, address _collection, uint256[] calldata tokens) internal {
1712         uint256[] memory startDates = new uint256[](tokens.length);
1713         for (uint8 i = 0; i < startDates.length; ++i) {
1714             startDates[i] = value;
1715         }
1716 
1717         IBoostWatcher(tokenAddress).watchBooster(_collection, tokens, startDates);
1718 
1719         delete startDates;
1720     }
1721 
1722     function lockCoordinates(Coordinate[] memory _coordinates) external onlyOwner {
1723         validateCoordinates(_coordinates);
1724 
1725         for (uint64 i = 0; i < _coordinates.length; ++i) {
1726             if (!realEstateOccupancyMapping[keccak256(abi.encode(_coordinates[i].x, _coordinates[i].y, _coordinates[i].layer))]) {
1727                 realEstateOccupancyMapping[keccak256(abi.encode(_coordinates[i].x, _coordinates[i].y, _coordinates[i].layer))] = true;
1728             }
1729         }
1730 
1731     }
1732 
1733     function unlockCoordinates(Coordinate[] memory _coordinates) external onlyOwner {
1734         for (uint64 i = 0; i < _coordinates.length; ++i) {
1735             if (realEstateOccupancyMapping[keccak256(abi.encode(_coordinates[i].x, _coordinates[i].y, _coordinates[i].layer))]) {
1736                 realEstateOccupancyMapping[keccak256(abi.encode(_coordinates[i].x, _coordinates[i].y, _coordinates[i].layer))] = false;
1737             }
1738         }
1739 
1740     }
1741 
1742     function reserveCoordinates(Coordinate[] memory _coordinates) external onlyOwner {
1743         validateCoordinates(_coordinates);
1744 
1745         uint256[] memory tokenIds = occupyLand(_coordinates);
1746 
1747         for (uint64 i = 0; i < _coordinates.length; ++i) {
1748             if (!realEstateOccupancyMapping[keccak256(abi.encode(_coordinates[i].x, _coordinates[i].y, _coordinates[i].layer))]) {
1749                 realEstateOccupancyMapping[keccak256(abi.encode(_coordinates[i].x, _coordinates[i].y, _coordinates[i].layer))] = true;
1750             }
1751         }
1752 
1753         emit RealEstateMinted(tokenIds, _coordinates, msg.sender);
1754     }
1755 
1756     function occupyLand(Coordinate[] memory _coordinates) internal returns(uint256[] memory ){
1757         uint256[] memory tokenIds = new uint256[](_coordinates.length);
1758         uint256 totalSupply = totalSupply();
1759 
1760         for (uint256 i = 0; i < _coordinates.length; ++i) {
1761             tokenIds[i] = totalSupply + i;
1762             tokensTypeMapping[totalSupply + i] = LAND;
1763             tokensCoordinates[totalSupply + i] = _coordinates[i];
1764             realEstateOccupancyMapping[keccak256(abi.encode(_coordinates[i].x, _coordinates[i].y, _coordinates[i].layer))] = true;
1765             _safeMint(msg.sender, totalSupply + i);
1766         }
1767 
1768         return tokenIds;
1769     }
1770 
1771     // backend
1772 
1773     function getTokensType(uint256[] calldata _tokenIds) public view returns(uint256[] memory) {
1774         uint256[] memory types = new uint256[](_tokenIds.length);
1775         for (uint64 i = 0; i < _tokenIds.length; ++i) {
1776             types[i] = tokensTypeMapping[_tokenIds[i]];
1777         }
1778 
1779         return types;
1780     }
1781 
1782     function getTokensCoordinates(uint256[] calldata _tokenIds) public view returns(Coordinate[] memory) {
1783         Coordinate[] memory coordinates = new Coordinate[](_tokenIds.length);
1784         for (uint64 i = 0; i < _tokenIds.length; ++i) {
1785             coordinates[i] = tokensCoordinates[_tokenIds[i]];
1786         }
1787 
1788         return coordinates;
1789     }
1790 
1791     function getTokensEnrolments(uint256[] calldata _tokenIds) public view returns(uint256[][] memory) {
1792         uint256[][] memory enrolments = new uint256[][](_tokenIds.length);
1793         for (uint64 i = 0; i < _tokenIds.length; ++i) {
1794             enrolments[_tokenIds[i]] = new uint256[](tokenEnrolmentEmployeesMapping[_tokenIds[i]].length());
1795 
1796             for (uint8 j = 0; j < tokenEnrolmentEmployeesMapping[_tokenIds[i]].length(); ++i) {
1797                 enrolments[_tokenIds[i]][j] = tokenEnrolmentEmployeesMapping[_tokenIds[i]].at(j);
1798             }
1799         }
1800 
1801         return enrolments;
1802     }
1803 
1804     function getTokensOwners(uint256[] calldata _tokenIds) external view returns(address[] memory) {
1805         address[] memory addresses = new address[](_tokenIds.length);
1806 
1807         for(uint64 i = 0; i < _tokenIds.length; ++i) {
1808             addresses[i] = ownerOf(_tokenIds[i]);
1809         }
1810 
1811         return addresses;
1812     }
1813 
1814     // overrides
1815 
1816     function tokenURI(uint256 _tokenId) external view virtual override returns (string memory) {
1817         require(_exists(_tokenId), "ERC721Metadata: Nonexistent token");
1818         string memory currentBaseURI = _baseURI();
1819         return bytes(currentBaseURI).length > 0	? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), ".json")) : "";
1820     }
1821 
1822     // boosting
1823 
1824     function computeAmount(uint256 amount) external view returns(uint256) {
1825         return amount + amount * bonusPercentage / 100;
1826     }
1827 
1828 }