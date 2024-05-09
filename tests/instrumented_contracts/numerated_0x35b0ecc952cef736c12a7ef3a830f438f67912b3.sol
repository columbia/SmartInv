1 pragma solidity ^0.8.10;
2 
3 // SPDX-License-Identifier: GPL-3.0
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
24 
25 
26 
27 /**
28  * @dev Contract module which provides a basic access control mechanism, where
29  * there is an account (an owner) that can be granted exclusive access to
30  * specific functions.
31  *
32  * By default, the owner account will be the one that deploys the contract. This
33  * can later be changed with {transferOwnership}.
34  *
35  * This module is used through inheritance. It will make available the modifier
36  * `onlyOwner`, which can be applied to your functions to restrict their use to
37  * the owner.
38  */
39 abstract contract Ownable is Context {
40     address private _owner;
41 
42     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
43 
44     /**
45      * @dev Initializes the contract setting the deployer as the initial owner.
46      */
47     constructor() {
48         _setOwner(_msgSender());
49     }
50 
51     /**
52      * @dev Returns the address of the current owner.
53      */
54     function owner() public view virtual returns (address) {
55         return _owner;
56     }
57 
58     /**
59      * @dev Throws if called by any account other than the owner.
60      */
61     modifier onlyOwner() {
62         require(owner() == _msgSender(), "Ownable: caller is not the owner");
63         _;
64     }
65 
66     /**
67      * @dev Leaves the contract without owner. It will not be possible to call
68      * `onlyOwner` functions anymore. Can only be called by the current owner.
69      *
70      * NOTE: Renouncing ownership will leave the contract without an owner,
71      * thereby removing any functionality that is only available to the owner.
72      */
73     function renounceOwnership() public virtual onlyOwner {
74         _setOwner(address(0));
75     }
76 
77     /**
78      * @dev Transfers ownership of the contract to a new account (`newOwner`).
79      * Can only be called by the current owner.
80      */
81     function transferOwnership(address newOwner) public virtual onlyOwner {
82         require(newOwner != address(0), "Ownable: new owner is the zero address");
83         _setOwner(newOwner);
84     }
85 
86     function _setOwner(address newOwner) private {
87         address oldOwner = _owner;
88         _owner = newOwner;
89         emit OwnershipTransferred(oldOwner, newOwner);
90     }
91 }
92 
93 
94 
95 /**
96  * @dev String operations.
97  */
98 library Strings {
99     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
100 
101     /**
102      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
103      */
104     function toString(uint256 value) internal pure returns (string memory) {
105         // Inspired by OraclizeAPI's implementation - MIT licence
106         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
107 
108         if (value == 0) {
109             return "0";
110         }
111         uint256 temp = value;
112         uint256 digits;
113         while (temp != 0) {
114             digits++;
115             temp /= 10;
116         }
117         bytes memory buffer = new bytes(digits);
118         while (value != 0) {
119             digits -= 1;
120             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
121             value /= 10;
122         }
123         return string(buffer);
124     }
125 
126     /**
127      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
128      */
129     function toHexString(uint256 value) internal pure returns (string memory) {
130         if (value == 0) {
131             return "0x00";
132         }
133         uint256 temp = value;
134         uint256 length = 0;
135         while (temp != 0) {
136             length++;
137             temp >>= 8;
138         }
139         return toHexString(value, length);
140     }
141 
142     /**
143      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
144      */
145     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
146         bytes memory buffer = new bytes(2 * length + 2);
147         buffer[0] = "0";
148         buffer[1] = "x";
149         for (uint256 i = 2 * length + 1; i > 1; --i) {
150             buffer[i] = _HEX_SYMBOLS[value & 0xf];
151             value >>= 4;
152         }
153         require(value == 0, "Strings: hex length insufficient");
154         return string(buffer);
155     }
156 }
157 
158 
159 
160 /**
161  * @dev Contract module that helps prevent reentrant calls to a function.
162  *
163  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
164  * available, which can be applied to functions to make sure there are no nested
165  * (reentrant) calls to them.
166  *
167  * Note that because there is a single `nonReentrant` guard, functions marked as
168  * `nonReentrant` may not call one another. This can be worked around by making
169  * those functions `private`, and then adding `external` `nonReentrant` entry
170  * points to them.
171  *
172  * TIP: If you would like to learn more about reentrancy and alternative ways
173  * to protect against it, check out our blog post
174  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
175  */
176 abstract contract ReentrancyGuard {
177     // Booleans are more expensive than uint256 or any type that takes up a full
178     // word because each write operation emits an extra SLOAD to first read the
179     // slot's contents, replace the bits taken up by the boolean, and then write
180     // back. This is the compiler's defense against contract upgrades and
181     // pointer aliasing, and it cannot be disabled.
182 
183     // The values being non-zero value makes deployment a bit more expensive,
184     // but in exchange the refund on every call to nonReentrant will be lower in
185     // amount. Since refunds are capped to a percentage of the total
186     // transaction's gas, it is best to keep them low in cases like this one, to
187     // increase the likelihood of the full refund coming into effect.
188     uint256 private constant _NOT_ENTERED = 1;
189     uint256 private constant _ENTERED = 2;
190 
191     uint256 private _status;
192 
193     constructor() {
194         _status = _NOT_ENTERED;
195     }
196 
197     /**
198      * @dev Prevents a contract from calling itself, directly or indirectly.
199      * Calling a `nonReentrant` function from another `nonReentrant`
200      * function is not supported. It is possible to prevent this from happening
201      * by making the `nonReentrant` function external, and make it call a
202      * `private` function that does the actual work.
203      */
204     modifier nonReentrant() {
205         // On the first call to nonReentrant, _notEntered will be true
206         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
207 
208         // Any calls to nonReentrant after this point will fail
209         _status = _ENTERED;
210 
211         _;
212 
213         // By storing the original value once again, a refund is triggered (see
214         // https://eips.ethereum.org/EIPS/eip-2200)
215         _status = _NOT_ENTERED;
216     }
217 }
218 
219 
220 
221 /**
222  * @dev Interface of the ERC165 standard, as defined in the
223  * https://eips.ethereum.org/EIPS/eip-165[EIP].
224  *
225  * Implementers can declare support of contract interfaces, which can then be
226  * queried by others ({ERC165Checker}).
227  *
228  * For an implementation, see {ERC165}.
229  */
230 interface IERC165 {
231     /**
232      * @dev Returns true if this contract implements the interface defined by
233      * `interfaceId`. See the corresponding
234      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
235      * to learn more about how these ids are created.
236      *
237      * This function call must use less than 30 000 gas.
238      */
239     function supportsInterface(bytes4 interfaceId) external view returns (bool);
240 }
241 
242 
243 
244 /**
245  * @dev Required interface of an ERC721 compliant contract.
246  */
247 interface IERC721 is IERC165 {
248     /**
249      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
250      */
251     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
252 
253     /**
254      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
255      */
256     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
257 
258     /**
259      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
260      */
261     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
262 
263     /**
264      * @dev Returns the number of tokens in ``owner``'s account.
265      */
266     function balanceOf(address owner) external view returns (uint256 balance);
267 
268     /**
269      * @dev Returns the owner of the `tokenId` token.
270      *
271      * Requirements:
272      *
273      * - `tokenId` must exist.
274      */
275     function ownerOf(uint256 tokenId) external view returns (address owner);
276 
277     /**
278      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
279      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
280      *
281      * Requirements:
282      *
283      * - `from` cannot be the zero address.
284      * - `to` cannot be the zero address.
285      * - `tokenId` token must exist and be owned by `from`.
286      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
287      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
288      *
289      * Emits a {Transfer} event.
290      */
291     function safeTransferFrom(
292         address from,
293         address to,
294         uint256 tokenId
295     ) external;
296 
297     /**
298      * @dev Transfers `tokenId` token from `from` to `to`.
299      *
300      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
301      *
302      * Requirements:
303      *
304      * - `from` cannot be the zero address.
305      * - `to` cannot be the zero address.
306      * - `tokenId` token must be owned by `from`.
307      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
308      *
309      * Emits a {Transfer} event.
310      */
311     function transferFrom(
312         address from,
313         address to,
314         uint256 tokenId
315     ) external;
316 
317     /**
318      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
319      * The approval is cleared when the token is transferred.
320      *
321      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
322      *
323      * Requirements:
324      *
325      * - The caller must own the token or be an approved operator.
326      * - `tokenId` must exist.
327      *
328      * Emits an {Approval} event.
329      */
330     function approve(address to, uint256 tokenId) external;
331 
332     /**
333      * @dev Returns the account approved for `tokenId` token.
334      *
335      * Requirements:
336      *
337      * - `tokenId` must exist.
338      */
339     function getApproved(uint256 tokenId) external view returns (address operator);
340 
341     /**
342      * @dev Approve or remove `operator` as an operator for the caller.
343      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
344      *
345      * Requirements:
346      *
347      * - The `operator` cannot be the caller.
348      *
349      * Emits an {ApprovalForAll} event.
350      */
351     function setApprovalForAll(address operator, bool _approved) external;
352 
353     /**
354      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
355      *
356      * See {setApprovalForAll}
357      */
358     function isApprovedForAll(address owner, address operator) external view returns (bool);
359 
360     /**
361      * @dev Safely transfers `tokenId` token from `from` to `to`.
362      *
363      * Requirements:
364      *
365      * - `from` cannot be the zero address.
366      * - `to` cannot be the zero address.
367      * - `tokenId` token must exist and be owned by `from`.
368      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
369      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
370      *
371      * Emits a {Transfer} event.
372      */
373     function safeTransferFrom(
374         address from,
375         address to,
376         uint256 tokenId,
377         bytes calldata data
378     ) external;
379 }
380 
381 
382 
383 
384 /**
385  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
386  * @dev See https://eips.ethereum.org/EIPS/eip-721
387  */
388 interface IERC721Enumerable is IERC721 {
389     /**
390      * @dev Returns the total amount of tokens stored by the contract.
391      */
392     function totalSupply() external view returns (uint256);
393 
394     /**
395      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
396      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
397      */
398     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
399 
400     /**
401      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
402      * Use along with {totalSupply} to enumerate all tokens.
403      */
404     function tokenByIndex(uint256 index) external view returns (uint256);
405 }
406 
407 
408 
409 /**
410  * @title ERC721 token receiver interface
411  * @dev Interface for any contract that wants to support safeTransfers
412  * from ERC721 asset contracts.
413  */
414 interface IERC721Receiver {
415     /**
416      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
417      * by `operator` from `from`, this function is called.
418      *
419      * It must return its Solidity selector to confirm the token transfer.
420      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
421      *
422      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
423      */
424     function onERC721Received(
425         address operator,
426         address from,
427         uint256 tokenId,
428         bytes calldata data
429     ) external returns (bytes4);
430 }
431 
432 
433 
434 /**
435  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
436  * @dev See https://eips.ethereum.org/EIPS/eip-721
437  */
438 interface IERC721Metadata is IERC721 {
439     /**
440      * @dev Returns the token collection name.
441      */
442     function name() external view returns (string memory);
443 
444     /**
445      * @dev Returns the token collection symbol.
446      */
447     function symbol() external view returns (string memory);
448 
449     /**
450      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
451      */
452     function tokenURI(uint256 tokenId) external view returns (string memory);
453 }
454 
455 
456 
457 
458 /**
459  * @dev Collection of functions related to the address type
460  */
461 library Address {
462     /**
463      * @dev Returns true if `account` is a contract.
464      *
465      * [IMPORTANT]
466      * ====
467      * It is unsafe to assume that an address for which this function returns
468      * false is an externally-owned account (EOA) and not a contract.
469      *
470      * Among others, `isContract` will return false for the following
471      * types of addresses:
472      *
473      *  - an externally-owned account
474      *  - a contract in construction
475      *  - an address where a contract will be created
476      *  - an address where a contract lived, but was destroyed
477      * ====
478      */
479     function isContract(address account) internal view returns (bool) {
480         // This method relies on extcodesize, which returns 0 for contracts in
481         // construction, since the code is only stored at the end of the
482         // constructor execution.
483 
484         uint256 size;
485         assembly {
486             size := extcodesize(account)
487         }
488         return size > 0;
489     }
490 
491     /**
492      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
493      * `recipient`, forwarding all available gas and reverting on errors.
494      *
495      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
496      * of certain opcodes, possibly making contracts go over the 2300 gas limit
497      * imposed by `transfer`, making them unable to receive funds via
498      * `transfer`. {sendValue} removes this limitation.
499      *
500      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
501      *
502      * IMPORTANT: because control is transferred to `recipient`, care must be
503      * taken to not create reentrancy vulnerabilities. Consider using
504      * {ReentrancyGuard} or the
505      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
506      */
507     function sendValue(address payable recipient, uint256 amount) internal {
508         require(address(this).balance >= amount, "Address: insufficient balance");
509 
510         (bool success, ) = recipient.call{value: amount}("");
511         require(success, "Address: unable to send value, recipient may have reverted");
512     }
513 
514     /**
515      * @dev Performs a Solidity function call using a low level `call`. A
516      * plain `call` is an unsafe replacement for a function call: use this
517      * function instead.
518      *
519      * If `target` reverts with a revert reason, it is bubbled up by this
520      * function (like regular Solidity function calls).
521      *
522      * Returns the raw returned data. To convert to the expected return value,
523      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
524      *
525      * Requirements:
526      *
527      * - `target` must be a contract.
528      * - calling `target` with `data` must not revert.
529      *
530      * _Available since v3.1._
531      */
532     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
533         return functionCall(target, data, "Address: low-level call failed");
534     }
535 
536     /**
537      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
538      * `errorMessage` as a fallback revert reason when `target` reverts.
539      *
540      * _Available since v3.1._
541      */
542     function functionCall(
543         address target,
544         bytes memory data,
545         string memory errorMessage
546     ) internal returns (bytes memory) {
547         return functionCallWithValue(target, data, 0, errorMessage);
548     }
549 
550     /**
551      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
552      * but also transferring `value` wei to `target`.
553      *
554      * Requirements:
555      *
556      * - the calling contract must have an ETH balance of at least `value`.
557      * - the called Solidity function must be `payable`.
558      *
559      * _Available since v3.1._
560      */
561     function functionCallWithValue(
562         address target,
563         bytes memory data,
564         uint256 value
565     ) internal returns (bytes memory) {
566         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
567     }
568 
569     /**
570      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
571      * with `errorMessage` as a fallback revert reason when `target` reverts.
572      *
573      * _Available since v3.1._
574      */
575     function functionCallWithValue(
576         address target,
577         bytes memory data,
578         uint256 value,
579         string memory errorMessage
580     ) internal returns (bytes memory) {
581         require(address(this).balance >= value, "Address: insufficient balance for call");
582         require(isContract(target), "Address: call to non-contract");
583 
584         (bool success, bytes memory returndata) = target.call{value: value}(data);
585         return verifyCallResult(success, returndata, errorMessage);
586     }
587 
588     /**
589      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
590      * but performing a static call.
591      *
592      * _Available since v3.3._
593      */
594     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
595         return functionStaticCall(target, data, "Address: low-level static call failed");
596     }
597 
598     /**
599      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
600      * but performing a static call.
601      *
602      * _Available since v3.3._
603      */
604     function functionStaticCall(
605         address target,
606         bytes memory data,
607         string memory errorMessage
608     ) internal view returns (bytes memory) {
609         require(isContract(target), "Address: static call to non-contract");
610 
611         (bool success, bytes memory returndata) = target.staticcall(data);
612         return verifyCallResult(success, returndata, errorMessage);
613     }
614 
615     /**
616      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
617      * but performing a delegate call.
618      *
619      * _Available since v3.4._
620      */
621     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
622         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
623     }
624 
625     /**
626      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
627      * but performing a delegate call.
628      *
629      * _Available since v3.4._
630      */
631     function functionDelegateCall(
632         address target,
633         bytes memory data,
634         string memory errorMessage
635     ) internal returns (bytes memory) {
636         require(isContract(target), "Address: delegate call to non-contract");
637 
638         (bool success, bytes memory returndata) = target.delegatecall(data);
639         return verifyCallResult(success, returndata, errorMessage);
640     }
641 
642     /**
643      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
644      * revert reason using the provided one.
645      *
646      * _Available since v4.3._
647      */
648     function verifyCallResult(
649         bool success,
650         bytes memory returndata,
651         string memory errorMessage
652     ) internal pure returns (bytes memory) {
653         if (success) {
654             return returndata;
655         } else {
656             // Look for revert reason and bubble it up if present
657             if (returndata.length > 0) {
658                 // The easiest way to bubble the revert reason is using memory via assembly
659 
660                 assembly {
661                     let returndata_size := mload(returndata)
662                     revert(add(32, returndata), returndata_size)
663                 }
664             } else {
665                 revert(errorMessage);
666             }
667         }
668     }
669 }
670 
671 
672 
673 
674 /**
675  * @dev Implementation of the {IERC165} interface.
676  *
677  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
678  * for the additional interface id that will be supported. For example:
679  *
680  * ```solidity
681  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
682  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
683  * }
684  * ```
685  *
686  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
687  */
688 abstract contract ERC165 is IERC165 {
689     /**
690      * @dev See {IERC165-supportsInterface}.
691      */
692     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
693         return interfaceId == type(IERC165).interfaceId;
694     }
695 }
696 
697 
698 abstract contract ERC721P is Context, ERC165, IERC721, IERC721Metadata {
699     using Address for address;
700     string private _name;
701     string private _symbol;
702     address[] internal _owners;
703     mapping(uint256 => address) private _tokenApprovals;
704     mapping(address => mapping(address => bool)) private _operatorApprovals;
705     constructor(string memory name_, string memory symbol_) {
706         _name = name_;
707         _symbol = symbol_;
708     }
709     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
710         return
711         interfaceId == type(IERC721).interfaceId ||
712         interfaceId == type(IERC721Metadata).interfaceId ||
713         super.supportsInterface(interfaceId);
714     }
715     function balanceOf(address owner) public view virtual override returns (uint256) {
716         require(owner != address(0), "ERC721: balance query for the zero address");
717         uint count = 0;
718         uint length = _owners.length;
719         for( uint i = 0; i < length; ++i ){
720             if( owner == _owners[i] ){
721                 ++count;
722             }
723         }
724         delete length;
725         return count;
726     }
727     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
728         address owner = _owners[tokenId];
729         require(owner != address(0), "ERC721: owner query for nonexistent token");
730         return owner;
731     }
732     function name() public view virtual override returns (string memory) {
733         return _name;
734     }
735     function symbol() public view virtual override returns (string memory) {
736         return _symbol;
737     }
738     function approve(address to, uint256 tokenId) public virtual override {
739         address owner = ERC721P.ownerOf(tokenId);
740         require(to != owner, "ERC721: approval to current owner");
741 
742         require(
743             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
744             "ERC721: approve caller is not owner nor approved for all"
745         );
746 
747         _approve(to, tokenId);
748     }
749     function getApproved(uint256 tokenId) public view virtual override returns (address) {
750         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
751 
752         return _tokenApprovals[tokenId];
753     }
754     function setApprovalForAll(address operator, bool approved) public virtual override {
755         require(operator != _msgSender(), "ERC721: approve to caller");
756 
757         _operatorApprovals[_msgSender()][operator] = approved;
758         emit ApprovalForAll(_msgSender(), operator, approved);
759     }
760     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
761         return _operatorApprovals[owner][operator];
762     }
763     function transferFrom(
764         address from,
765         address to,
766         uint256 tokenId
767     ) public virtual override {
768         //solhint-disable-next-line max-line-length
769         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
770 
771         _transfer(from, to, tokenId);
772     }
773     function safeTransferFrom(
774         address from,
775         address to,
776         uint256 tokenId
777     ) public virtual override {
778         safeTransferFrom(from, to, tokenId, "");
779     }
780     function safeTransferFrom(
781         address from,
782         address to,
783         uint256 tokenId,
784         bytes memory _data
785     ) public virtual override {
786         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
787         _safeTransfer(from, to, tokenId, _data);
788     }
789     function _safeTransfer(
790         address from,
791         address to,
792         uint256 tokenId,
793         bytes memory _data
794     ) internal virtual {
795         _transfer(from, to, tokenId);
796         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
797     }
798     function _exists(uint256 tokenId) internal view virtual returns (bool) {
799         return tokenId < _owners.length && _owners[tokenId] != address(0);
800     }
801     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
802         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
803         address owner = ERC721P.ownerOf(tokenId);
804         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
805     }
806     function _safeMint(address to, uint256 tokenId) internal virtual {
807         _safeMint(to, tokenId, "");
808     }
809     function _safeMint(
810         address to,
811         uint256 tokenId,
812         bytes memory _data
813     ) internal virtual {
814         _mint(to, tokenId);
815         require(
816             _checkOnERC721Received(address(0), to, tokenId, _data),
817             "ERC721: transfer to non ERC721Receiver implementer"
818         );
819     }
820     function _mint(address to, uint256 tokenId) internal virtual {
821         require(to != address(0), "ERC721: mint to the zero address");
822         require(!_exists(tokenId), "ERC721: token already minted");
823 
824         _beforeTokenTransfer(address(0), to, tokenId);
825         _owners.push(to);
826 
827         emit Transfer(address(0), to, tokenId);
828     }
829     function _burn(uint256 tokenId) internal virtual {
830         address owner = ERC721P.ownerOf(tokenId);
831 
832         _beforeTokenTransfer(owner, address(0), tokenId);
833 
834         // Clear approvals
835         _approve(address(0), tokenId);
836         _owners[tokenId] = address(0);
837 
838         emit Transfer(owner, address(0), tokenId);
839     }
840     function _transfer(
841         address from,
842         address to,
843         uint256 tokenId
844     ) internal virtual {
845         require(ERC721P.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
846         require(to != address(0), "ERC721: transfer to the zero address");
847 
848         _beforeTokenTransfer(from, to, tokenId);
849 
850         // Clear approvals from the previous owner
851         _approve(address(0), tokenId);
852         _owners[tokenId] = to;
853 
854         emit Transfer(from, to, tokenId);
855     }
856     function _approve(address to, uint256 tokenId) internal virtual {
857         _tokenApprovals[tokenId] = to;
858         emit Approval(ERC721P.ownerOf(tokenId), to, tokenId);
859     }
860     function _checkOnERC721Received(
861         address from,
862         address to,
863         uint256 tokenId,
864         bytes memory _data
865     ) private returns (bool) {
866         if (to.isContract()) {
867             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
868                 return retval == IERC721Receiver.onERC721Received.selector;
869             } catch (bytes memory reason) {
870                 if (reason.length == 0) {
871                     revert("ERC721: transfer to non ERC721Receiver implementer");
872                 } else {
873                     assembly {
874                         revert(add(32, reason), mload(reason))
875                     }
876                 }
877             }
878         } else {
879             return true;
880         }
881     }
882     function _beforeTokenTransfer(
883         address from,
884         address to,
885         uint256 tokenId
886     ) internal virtual {}
887 }
888 
889 
890 
891 abstract contract ERC721Enum is ERC721P, IERC721Enumerable {
892     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721P) returns (bool) {
893         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
894     }
895     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256 tokenId) {
896         require(index < ERC721P.balanceOf(owner), "ERC721Enum: owner ioob");
897         uint count;
898         for( uint i; i < _owners.length; ++i ){
899             if( owner == _owners[i] ){
900                 if( count == index )
901                     return i;
902                 else
903                     ++count;
904             }
905         }
906         require(false, "ERC721Enum: owner ioob");
907     }
908     function tokensOfOwner(address owner) public view returns (uint256[] memory) {
909         require(0 < ERC721P.balanceOf(owner), "ERC721Enum: owner ioob");
910         uint256 tokenCount = balanceOf(owner);
911         uint256[] memory tokenIds = new uint256[](tokenCount);
912         for (uint256 i = 0; i < tokenCount; i++) {
913             tokenIds[i] = tokenOfOwnerByIndex(owner, i);
914         }
915         return tokenIds;
916     }
917     function totalSupply() public view virtual override returns (uint256) {
918         return _owners.length;
919     }
920     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
921         require(index < ERC721Enum.totalSupply(), "ERC721Enum: global ioob");
922         return index;
923     }
924 }
925 
926 contract YokaiKingdom is ERC721Enum, Ownable, ReentrancyGuard {
927     using Strings for uint256;
928 
929     // sale settings
930     // set aside 30 for team mint
931     // mint out first index to display and edit store front
932     uint256 private MAX_SUPPLY = 8859;
933     uint256 private TEAM_SUPPLY = 29;
934     uint256 private MAX_PRESALE_MINT = 2;
935     uint256 private PRICE = 0.0888 ether;
936     uint256 private MAX_SALE_MINT = 2;
937 
938     bool public isPresaleActive = false;
939     bool public isSaleActive = false;
940 
941     //presale settings
942     //mapping(address => bool) public presaleWhitelist;
943     mapping(address => uint8) public presaleWhitelistMints;
944 
945     bytes32 merkleRoot;
946 
947     string private baseURI;
948 
949     constructor() ERC721P('Yokai Kingdom', 'YOKAI') {}
950 
951     // internal
952     function _baseURI() internal view virtual returns (string memory) {
953         return baseURI;
954     }
955 
956     function _publicSupply() internal view virtual returns (uint256) {
957         return MAX_SUPPLY;
958     }
959 
960     // external
961     function isWhitelisted (bytes32[] calldata _merkleProof) external view returns (bool) {
962         bytes32 node = keccak256(abi.encodePacked(msg.sender));
963         return verify(node, _merkleProof);
964     }
965 
966     function setMerkleRoot(bytes32 _merkle) public onlyOwner {
967         merkleRoot = _merkle;
968     }
969 
970     function flipPresaleState() external onlyOwner {
971         isPresaleActive = !isPresaleActive;
972     }
973 
974     function flipSaleState() external onlyOwner {
975         isSaleActive = !isSaleActive;
976     }
977 
978     function mintAsOwner(uint256 _mintAmount) external onlyOwner {
979         require(_mintAmount > 0, "Minted amount should be positive" );
980         uint256 totalSupply = totalSupply();
981 
982         require(totalSupply + _mintAmount <= (_publicSupply() + TEAM_SUPPLY), "The requested amount exceeds the remaining supply" );
983 
984         for (uint256 i = 0; i < _mintAmount; i++) {
985             _safeMint(msg.sender, totalSupply + i);
986         }
987     }
988 
989     function mint(uint256 _mintAmount) external payable nonReentrant {
990         require(isSaleActive, "Sale is not active");
991         require(_mintAmount > 0, "Minted amount should be positive" );
992         require(_mintAmount <= MAX_SALE_MINT, "Minted amount exceeds sale limit" );
993 
994         uint256 totalSupply = totalSupply();
995 
996         require(totalSupply + _mintAmount <= _publicSupply(), "The requested amount exceeds the remaining supply" );
997         require(msg.value >= PRICE * _mintAmount , "Wrong msg.value");
998 
999         for (uint256 i = 0; i < _mintAmount; i++) {
1000             _safeMint(msg.sender, totalSupply + i);
1001         }
1002     }
1003 
1004     function mintPresale(uint256 _mintAmount, bytes32[] calldata _merkleProof) external payable nonReentrant {
1005         require(isPresaleActive, "Presale is not active");
1006         //require(presaleWhitelist[msg.sender], "Caller is not whitelisted");
1007         // Verify the merkle proof
1008         bytes32 node = keccak256(abi.encodePacked(msg.sender));
1009         require(verify(node, _merkleProof), "Incorrect merkle");
1010 
1011         uint256 totalSupply = totalSupply();
1012         uint256 availableMints = MAX_PRESALE_MINT - presaleWhitelistMints[msg.sender];
1013 
1014         require(_mintAmount <= availableMints, "Too many mints requested");
1015         require(totalSupply + _mintAmount <= _publicSupply(), "The requested amount exceeds the remaining supply");
1016         require(msg.value >= PRICE * _mintAmount , "Wrong msg.value provided");
1017 
1018         presaleWhitelistMints[msg.sender] += uint8(_mintAmount);
1019 
1020         for(uint256 i = 0; i < _mintAmount; i++){
1021             _safeMint(msg.sender, totalSupply + i);
1022         }
1023     }
1024 
1025     function verify(bytes32 leaf, bytes32[] memory proof) internal view returns (bool) {
1026       bytes32 computedHash = leaf;
1027 
1028       for (uint256 i = 0; i < proof.length; i++) {
1029         bytes32 proofElement = proof[i];
1030 
1031         if (computedHash <= proofElement) {
1032           // Hash(current computed hash + current element of the proof)
1033           computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
1034         } else {
1035           // Hash(current element of the proof + current computed hash)
1036           computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
1037         }
1038       }
1039 
1040       // Check if the computed hash (root) is equal to the provided root
1041       return computedHash == merkleRoot;
1042     }
1043 
1044     function withdraw() external onlyOwner {
1045         require(payable(msg.sender).send(address(this).balance));
1046     }
1047 
1048     function setPrice(uint256 _newPrice) external onlyOwner {
1049         PRICE = _newPrice;
1050     }
1051 
1052     function setMaxMintAmount(uint256 _newMaxMintAmount) external onlyOwner {
1053         MAX_SALE_MINT = _newMaxMintAmount;
1054     }
1055 
1056     function setMaxTeamMintAmount(uint256 _newMaxMintAmount) external onlyOwner {
1057         TEAM_SUPPLY = _newMaxMintAmount;
1058     }
1059 
1060     function setMaxSupply(uint256 _maxSupply) external onlyOwner {
1061         MAX_SUPPLY = _maxSupply;
1062     }
1063 
1064     function setMaxPresaleMint(uint256 _maxPresaleMint) external onlyOwner {
1065         MAX_PRESALE_MINT = _maxPresaleMint;
1066     }
1067 
1068     function tokenURI(uint256 _tokenId) external view virtual override returns (string memory) {
1069         require(_exists(_tokenId), "ERC721Metadata: Nonexistent token");
1070         string memory currentBaseURI = _baseURI();
1071         return bytes(currentBaseURI).length > 0	? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), ".json")) : "";
1072     }
1073 
1074     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1075         baseURI = _newBaseURI;
1076     }
1077 
1078     function transferFrom(address _from, address _to, uint256 _tokenId) public override {
1079         ERC721P.transferFrom(_from, _to, _tokenId);
1080     }
1081 
1082     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes memory _data) public override {
1083         ERC721P.safeTransferFrom(_from, _to, _tokenId, _data);
1084     }
1085 }