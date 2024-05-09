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
19 
20 /**
21  * @dev Provides information about the current execution context, including the
22  * sender of the transaction and its data. While these are generally available
23  * via msg.sender and msg.data, they should not be accessed in such a direct
24  * manner, since when dealing with meta-transactions the account sending and
25  * paying for execution may not be the actual sender (as far as an application
26  * is concerned).
27  *
28  * This contract is only required for intermediate, library-like contracts.
29  */
30 abstract contract Context {
31     function _msgSender() internal view virtual returns (address) {
32         return msg.sender;
33     }
34 
35     function _msgData() internal view virtual returns (bytes calldata) {
36         return msg.data;
37     }
38 }
39 
40 pragma solidity ^0.8.0;
41 
42 /**
43  * @dev Contract module which provides a basic access control mechanism, where
44  * there is an account (an owner) that can be granted exclusive access to
45  * specific functions.
46  *
47  * By default, the owner account will be the one that deploys the contract. This
48  * can later be changed with {transferOwnership}.
49  *
50  * This module is used through inheritance. It will make available the modifier
51  * `onlyOwner`, which can be applied to your functions to restrict their use to
52  * the owner.
53  */
54 abstract contract Ownable is Context {
55     address private _owner;
56 
57     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
58 
59     /**
60      * @dev Initializes the contract setting the deployer as the initial owner.
61      */
62     constructor() {
63         _setOwner(_msgSender());
64     }
65 
66     /**
67      * @dev Returns the address of the current owner.
68      */
69     function owner() public view virtual returns (address) {
70         return _owner;
71     }
72 
73     /**
74      * @dev Throws if called by any account other than the owner.
75      */
76     modifier onlyOwner() {
77         require(owner() == _msgSender(), "Ownable: caller is not the owner");
78         _;
79     }
80 
81     /**
82      * @dev Leaves the contract without owner. It will not be possible to call
83      * `onlyOwner` functions anymore. Can only be called by the current owner.
84      *
85      * NOTE: Renouncing ownership will leave the contract without an owner,
86      * thereby removing any functionality that is only available to the owner.
87      */
88     function renounceOwnership() public virtual onlyOwner {
89         _setOwner(address(0));
90     }
91 
92     /**
93      * @dev Transfers ownership of the contract to a new account (`newOwner`).
94      * Can only be called by the current owner.
95      */
96     function transferOwnership(address newOwner) public virtual onlyOwner {
97         require(newOwner != address(0), "Ownable: new owner is the zero address");
98         _setOwner(newOwner);
99     }
100 
101     function _setOwner(address newOwner) private {
102         address oldOwner = _owner;
103         _owner = newOwner;
104         emit OwnershipTransferred(oldOwner, newOwner);
105     }
106 }
107 
108 pragma solidity ^0.8.0;
109 
110 /**
111  * @dev String operations.
112  */
113 library Strings {
114     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
115 
116     /**
117      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
118      */
119     function toString(uint256 value) internal pure returns (string memory) {
120         // Inspired by OraclizeAPI's implementation - MIT licence
121         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
122 
123         if (value == 0) {
124             return "0";
125         }
126         uint256 temp = value;
127         uint256 digits;
128         while (temp != 0) {
129             digits++;
130             temp /= 10;
131         }
132         bytes memory buffer = new bytes(digits);
133         while (value != 0) {
134             digits -= 1;
135             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
136             value /= 10;
137         }
138         return string(buffer);
139     }
140 
141     /**
142      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
143      */
144     function toHexString(uint256 value) internal pure returns (string memory) {
145         if (value == 0) {
146             return "0x00";
147         }
148         uint256 temp = value;
149         uint256 length = 0;
150         while (temp != 0) {
151             length++;
152             temp >>= 8;
153         }
154         return toHexString(value, length);
155     }
156 
157     /**
158      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
159      */
160     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
161         bytes memory buffer = new bytes(2 * length + 2);
162         buffer[0] = "0";
163         buffer[1] = "x";
164         for (uint256 i = 2 * length + 1; i > 1; --i) {
165             buffer[i] = _HEX_SYMBOLS[value & 0xf];
166             value >>= 4;
167         }
168         require(value == 0, "Strings: hex length insufficient");
169         return string(buffer);
170     }
171 }
172 
173 pragma solidity ^0.8.0;
174 
175 /**
176  * @dev Contract module that helps prevent reentrant calls to a function.
177  *
178  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
179  * available, which can be applied to functions to make sure there are no nested
180  * (reentrant) calls to them.
181  *
182  * Note that because there is a single `nonReentrant` guard, functions marked as
183  * `nonReentrant` may not call one another. This can be worked around by making
184  * those functions `private`, and then adding `external` `nonReentrant` entry
185  * points to them.
186  *
187  * TIP: If you would like to learn more about reentrancy and alternative ways
188  * to protect against it, check out our blog post
189  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
190  */
191 abstract contract ReentrancyGuard {
192     // Booleans are more expensive than uint256 or any type that takes up a full
193     // word because each write operation emits an extra SLOAD to first read the
194     // slot's contents, replace the bits taken up by the boolean, and then write
195     // back. This is the compiler's defense against contract upgrades and
196     // pointer aliasing, and it cannot be disabled.
197 
198     // The values being non-zero value makes deployment a bit more expensive,
199     // but in exchange the refund on every call to nonReentrant will be lower in
200     // amount. Since refunds are capped to a percentage of the total
201     // transaction's gas, it is best to keep them low in cases like this one, to
202     // increase the likelihood of the full refund coming into effect.
203     uint256 private constant _NOT_ENTERED = 1;
204     uint256 private constant _ENTERED = 2;
205 
206     uint256 private _status;
207 
208     constructor() {
209         _status = _NOT_ENTERED;
210     }
211 
212     /**
213      * @dev Prevents a contract from calling itself, directly or indirectly.
214      * Calling a `nonReentrant` function from another `nonReentrant`
215      * function is not supported. It is possible to prevent this from happening
216      * by making the `nonReentrant` function external, and make it call a
217      * `private` function that does the actual work.
218      */
219     modifier nonReentrant() {
220         // On the first call to nonReentrant, _notEntered will be true
221         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
222 
223         // Any calls to nonReentrant after this point will fail
224         _status = _ENTERED;
225 
226         _;
227 
228         // By storing the original value once again, a refund is triggered (see
229         // https://eips.ethereum.org/EIPS/eip-2200)
230         _status = _NOT_ENTERED;
231     }
232 }
233 
234 pragma solidity ^0.8.0;
235 
236 /**
237  * @dev Interface of the ERC165 standard, as defined in the
238  * https://eips.ethereum.org/EIPS/eip-165[EIP].
239  *
240  * Implementers can declare support of contract interfaces, which can then be
241  * queried by others ({ERC165Checker}).
242  *
243  * For an implementation, see {ERC165}.
244  */
245 interface IERC165 {
246     /**
247      * @dev Returns true if this contract implements the interface defined by
248      * `interfaceId`. See the corresponding
249      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
250      * to learn more about how these ids are created.
251      *
252      * This function call must use less than 30 000 gas.
253      */
254     function supportsInterface(bytes4 interfaceId) external view returns (bool);
255 }
256 
257 pragma solidity ^0.8.0;
258 
259 /**
260  * @dev Required interface of an ERC721 compliant contract.
261  */
262 interface IERC721 is IERC165 {
263     /**
264      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
265      */
266     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
267 
268     /**
269      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
270      */
271     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
272 
273     /**
274      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
275      */
276     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
277 
278     /**
279      * @dev Returns the number of tokens in ``owner``'s account.
280      */
281     function balanceOf(address owner) external view returns (uint256 balance);
282 
283     /**
284      * @dev Returns the owner of the `tokenId` token.
285      *
286      * Requirements:
287      *
288      * - `tokenId` must exist.
289      */
290     function ownerOf(uint256 tokenId) external view returns (address owner);
291 
292     /**
293      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
294      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
295      *
296      * Requirements:
297      *
298      * - `from` cannot be the zero address.
299      * - `to` cannot be the zero address.
300      * - `tokenId` token must exist and be owned by `from`.
301      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
302      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
303      *
304      * Emits a {Transfer} event.
305      */
306     function safeTransferFrom(
307         address from,
308         address to,
309         uint256 tokenId
310     ) external;
311 
312     /**
313      * @dev Transfers `tokenId` token from `from` to `to`.
314      *
315      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
316      *
317      * Requirements:
318      *
319      * - `from` cannot be the zero address.
320      * - `to` cannot be the zero address.
321      * - `tokenId` token must be owned by `from`.
322      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
323      *
324      * Emits a {Transfer} event.
325      */
326     function transferFrom(
327         address from,
328         address to,
329         uint256 tokenId
330     ) external;
331 
332     /**
333      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
334      * The approval is cleared when the token is transferred.
335      *
336      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
337      *
338      * Requirements:
339      *
340      * - The caller must own the token or be an approved operator.
341      * - `tokenId` must exist.
342      *
343      * Emits an {Approval} event.
344      */
345     function approve(address to, uint256 tokenId) external;
346 
347     /**
348      * @dev Returns the account approved for `tokenId` token.
349      *
350      * Requirements:
351      *
352      * - `tokenId` must exist.
353      */
354     function getApproved(uint256 tokenId) external view returns (address operator);
355 
356     /**
357      * @dev Approve or remove `operator` as an operator for the caller.
358      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
359      *
360      * Requirements:
361      *
362      * - The `operator` cannot be the caller.
363      *
364      * Emits an {ApprovalForAll} event.
365      */
366     function setApprovalForAll(address operator, bool _approved) external;
367 
368     /**
369      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
370      *
371      * See {setApprovalForAll}
372      */
373     function isApprovedForAll(address owner, address operator) external view returns (bool);
374 
375     /**
376      * @dev Safely transfers `tokenId` token from `from` to `to`.
377      *
378      * Requirements:
379      *
380      * - `from` cannot be the zero address.
381      * - `to` cannot be the zero address.
382      * - `tokenId` token must exist and be owned by `from`.
383      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
384      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
385      *
386      * Emits a {Transfer} event.
387      */
388     function safeTransferFrom(
389         address from,
390         address to,
391         uint256 tokenId,
392         bytes calldata data
393     ) external;
394 }
395 
396 pragma solidity ^0.8.0;
397 
398 
399 /**
400  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
401  * @dev See https://eips.ethereum.org/EIPS/eip-721
402  */
403 interface IERC721Enumerable is IERC721 {
404     /**
405      * @dev Returns the total amount of tokens stored by the contract.
406      */
407     function totalSupply() external view returns (uint256);
408 
409     /**
410      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
411      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
412      */
413     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
414 
415     /**
416      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
417      * Use along with {totalSupply} to enumerate all tokens.
418      */
419     function tokenByIndex(uint256 index) external view returns (uint256);
420 }
421 
422 pragma solidity ^0.8.0;
423 
424 /**
425  * @title ERC721 token receiver interface
426  * @dev Interface for any contract that wants to support safeTransfers
427  * from ERC721 asset contracts.
428  */
429 interface IERC721Receiver {
430     /**
431      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
432      * by `operator` from `from`, this function is called.
433      *
434      * It must return its Solidity selector to confirm the token transfer.
435      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
436      *
437      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
438      */
439     function onERC721Received(
440         address operator,
441         address from,
442         uint256 tokenId,
443         bytes calldata data
444     ) external returns (bytes4);
445 }
446 
447 pragma solidity ^0.8.0;
448 
449 /**
450  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
451  * @dev See https://eips.ethereum.org/EIPS/eip-721
452  */
453 interface IERC721Metadata is IERC721 {
454     /**
455      * @dev Returns the token collection name.
456      */
457     function name() external view returns (string memory);
458 
459     /**
460      * @dev Returns the token collection symbol.
461      */
462     function symbol() external view returns (string memory);
463 
464     /**
465      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
466      */
467     function tokenURI(uint256 tokenId) external view returns (string memory);
468 }
469 
470 
471 pragma solidity ^0.8.0;
472 
473 /**
474  * @dev Collection of functions related to the address type
475  */
476 library Address {
477     /**
478      * @dev Returns true if `account` is a contract.
479      *
480      * [IMPORTANT]
481      * ====
482      * It is unsafe to assume that an address for which this function returns
483      * false is an externally-owned account (EOA) and not a contract.
484      *
485      * Among others, `isContract` will return false for the following
486      * types of addresses:
487      *
488      *  - an externally-owned account
489      *  - a contract in construction
490      *  - an address where a contract will be created
491      *  - an address where a contract lived, but was destroyed
492      * ====
493      */
494     function isContract(address account) internal view returns (bool) {
495         // This method relies on extcodesize, which returns 0 for contracts in
496         // construction, since the code is only stored at the end of the
497         // constructor execution.
498 
499         uint256 size;
500         assembly {
501             size := extcodesize(account)
502         }
503         return size > 0;
504     }
505 
506     /**
507      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
508      * `recipient`, forwarding all available gas and reverting on errors.
509      *
510      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
511      * of certain opcodes, possibly making contracts go over the 2300 gas limit
512      * imposed by `transfer`, making them unable to receive funds via
513      * `transfer`. {sendValue} removes this limitation.
514      *
515      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
516      *
517      * IMPORTANT: because control is transferred to `recipient`, care must be
518      * taken to not create reentrancy vulnerabilities. Consider using
519      * {ReentrancyGuard} or the
520      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
521      */
522     function sendValue(address payable recipient, uint256 amount) internal {
523         require(address(this).balance >= amount, "Address: insufficient balance");
524 
525         (bool success, ) = recipient.call{value: amount}("");
526         require(success, "Address: unable to send value, recipient may have reverted");
527     }
528 
529     /**
530      * @dev Performs a Solidity function call using a low level `call`. A
531      * plain `call` is an unsafe replacement for a function call: use this
532      * function instead.
533      *
534      * If `target` reverts with a revert reason, it is bubbled up by this
535      * function (like regular Solidity function calls).
536      *
537      * Returns the raw returned data. To convert to the expected return value,
538      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
539      *
540      * Requirements:
541      *
542      * - `target` must be a contract.
543      * - calling `target` with `data` must not revert.
544      *
545      * _Available since v3.1._
546      */
547     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
548         return functionCall(target, data, "Address: low-level call failed");
549     }
550 
551     /**
552      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
553      * `errorMessage` as a fallback revert reason when `target` reverts.
554      *
555      * _Available since v3.1._
556      */
557     function functionCall(
558         address target,
559         bytes memory data,
560         string memory errorMessage
561     ) internal returns (bytes memory) {
562         return functionCallWithValue(target, data, 0, errorMessage);
563     }
564 
565     /**
566      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
567      * but also transferring `value` wei to `target`.
568      *
569      * Requirements:
570      *
571      * - the calling contract must have an ETH balance of at least `value`.
572      * - the called Solidity function must be `payable`.
573      *
574      * _Available since v3.1._
575      */
576     function functionCallWithValue(
577         address target,
578         bytes memory data,
579         uint256 value
580     ) internal returns (bytes memory) {
581         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
582     }
583 
584     /**
585      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
586      * with `errorMessage` as a fallback revert reason when `target` reverts.
587      *
588      * _Available since v3.1._
589      */
590     function functionCallWithValue(
591         address target,
592         bytes memory data,
593         uint256 value,
594         string memory errorMessage
595     ) internal returns (bytes memory) {
596         require(address(this).balance >= value, "Address: insufficient balance for call");
597         require(isContract(target), "Address: call to non-contract");
598 
599         (bool success, bytes memory returndata) = target.call{value: value}(data);
600         return verifyCallResult(success, returndata, errorMessage);
601     }
602 
603     /**
604      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
605      * but performing a static call.
606      *
607      * _Available since v3.3._
608      */
609     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
610         return functionStaticCall(target, data, "Address: low-level static call failed");
611     }
612 
613     /**
614      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
615      * but performing a static call.
616      *
617      * _Available since v3.3._
618      */
619     function functionStaticCall(
620         address target,
621         bytes memory data,
622         string memory errorMessage
623     ) internal view returns (bytes memory) {
624         require(isContract(target), "Address: static call to non-contract");
625 
626         (bool success, bytes memory returndata) = target.staticcall(data);
627         return verifyCallResult(success, returndata, errorMessage);
628     }
629 
630     /**
631      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
632      * but performing a delegate call.
633      *
634      * _Available since v3.4._
635      */
636     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
637         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
638     }
639 
640     /**
641      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
642      * but performing a delegate call.
643      *
644      * _Available since v3.4._
645      */
646     function functionDelegateCall(
647         address target,
648         bytes memory data,
649         string memory errorMessage
650     ) internal returns (bytes memory) {
651         require(isContract(target), "Address: delegate call to non-contract");
652 
653         (bool success, bytes memory returndata) = target.delegatecall(data);
654         return verifyCallResult(success, returndata, errorMessage);
655     }
656 
657     /**
658      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
659      * revert reason using the provided one.
660      *
661      * _Available since v4.3._
662      */
663     function verifyCallResult(
664         bool success,
665         bytes memory returndata,
666         string memory errorMessage
667     ) internal pure returns (bytes memory) {
668         if (success) {
669             return returndata;
670         } else {
671             // Look for revert reason and bubble it up if present
672             if (returndata.length > 0) {
673                 // The easiest way to bubble the revert reason is using memory via assembly
674 
675                 assembly {
676                     let returndata_size := mload(returndata)
677                     revert(add(32, returndata), returndata_size)
678                 }
679             } else {
680                 revert(errorMessage);
681             }
682         }
683     }
684 }
685 
686 
687 pragma solidity ^0.8.0;
688 
689 /**
690  * @dev Implementation of the {IERC165} interface.
691  *
692  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
693  * for the additional interface id that will be supported. For example:
694  *
695  * ```solidity
696  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
697  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
698  * }
699  * ```
700  *
701  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
702  */
703 abstract contract ERC165 is IERC165 {
704     /**
705      * @dev See {IERC165-supportsInterface}.
706      */
707     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
708         return interfaceId == type(IERC165).interfaceId;
709     }
710 }
711 pragma solidity ^0.8.10;
712 
713 abstract contract ERC721P is Context, ERC165, IERC721, IERC721Metadata {
714     using Address for address;
715     string private _name;
716     string private _symbol;
717     address[] internal _owners;
718     mapping(uint256 => address) private _tokenApprovals;
719     mapping(address => mapping(address => bool)) private _operatorApprovals;
720     constructor(string memory name_, string memory symbol_) {
721         _name = name_;
722         _symbol = symbol_;
723     }
724     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
725         return
726         interfaceId == type(IERC721).interfaceId ||
727         interfaceId == type(IERC721Metadata).interfaceId ||
728         super.supportsInterface(interfaceId);
729     }
730     function balanceOf(address owner) public view virtual override returns (uint256) {
731         require(owner != address(0), "ERC721: balance query for the zero address");
732         uint count = 0;
733         uint length = _owners.length;
734         for( uint i = 0; i < length; ++i ){
735             if( owner == _owners[i] ){
736                 ++count;
737             }
738         }
739         delete length;
740         return count;
741     }
742     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
743         address owner = _owners[tokenId];
744         require(owner != address(0), "ERC721: owner query for nonexistent token");
745         return owner;
746     }
747     function name() public view virtual override returns (string memory) {
748         return _name;
749     }
750     function symbol() public view virtual override returns (string memory) {
751         return _symbol;
752     }
753     function approve(address to, uint256 tokenId) public virtual override {
754         address owner = ERC721P.ownerOf(tokenId);
755         require(to != owner, "ERC721: approval to current owner");
756 
757         require(
758             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
759             "ERC721: approve caller is not owner nor approved for all"
760         );
761 
762         _approve(to, tokenId);
763     }
764     function getApproved(uint256 tokenId) public view virtual override returns (address) {
765         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
766 
767         return _tokenApprovals[tokenId];
768     }
769     function setApprovalForAll(address operator, bool approved) public virtual override {
770         require(operator != _msgSender(), "ERC721: approve to caller");
771 
772         _operatorApprovals[_msgSender()][operator] = approved;
773         emit ApprovalForAll(_msgSender(), operator, approved);
774     }
775     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
776         return _operatorApprovals[owner][operator];
777     }
778     function transferFrom(
779         address from,
780         address to,
781         uint256 tokenId
782     ) public virtual override {
783         //solhint-disable-next-line max-line-length
784         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
785 
786         _transfer(from, to, tokenId);
787     }
788     function safeTransferFrom(
789         address from,
790         address to,
791         uint256 tokenId
792     ) public virtual override {
793         safeTransferFrom(from, to, tokenId, "");
794     }
795     function safeTransferFrom(
796         address from,
797         address to,
798         uint256 tokenId,
799         bytes memory _data
800     ) public virtual override {
801         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
802         _safeTransfer(from, to, tokenId, _data);
803     }
804     function _safeTransfer(
805         address from,
806         address to,
807         uint256 tokenId,
808         bytes memory _data
809     ) internal virtual {
810         _transfer(from, to, tokenId);
811         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
812     }
813     function _exists(uint256 tokenId) internal view virtual returns (bool) {
814         return tokenId < _owners.length && _owners[tokenId] != address(0);
815     }
816     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
817         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
818         address owner = ERC721P.ownerOf(tokenId);
819         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
820     }
821     function _safeMint(address to, uint256 tokenId) internal virtual {
822         _safeMint(to, tokenId, "");
823     }
824     function _safeMint(
825         address to,
826         uint256 tokenId,
827         bytes memory _data
828     ) internal virtual {
829         _mint(to, tokenId);
830         require(
831             _checkOnERC721Received(address(0), to, tokenId, _data),
832             "ERC721: transfer to non ERC721Receiver implementer"
833         );
834     }
835     function _mint(address to, uint256 tokenId) internal virtual {
836         require(to != address(0), "ERC721: mint to the zero address");
837         require(!_exists(tokenId), "ERC721: token already minted");
838 
839         _beforeTokenTransfer(address(0), to, tokenId);
840         _owners.push(to);
841 
842         emit Transfer(address(0), to, tokenId);
843     }
844     function _burn(uint256 tokenId) internal virtual {
845         address owner = ERC721P.ownerOf(tokenId);
846 
847         _beforeTokenTransfer(owner, address(0), tokenId);
848 
849         // Clear approvals
850         _approve(address(0), tokenId);
851         _owners[tokenId] = address(0);
852 
853         emit Transfer(owner, address(0), tokenId);
854     }
855     function _transfer(
856         address from,
857         address to,
858         uint256 tokenId
859     ) internal virtual {
860         require(ERC721P.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
861         require(to != address(0), "ERC721: transfer to the zero address");
862 
863         _beforeTokenTransfer(from, to, tokenId);
864 
865         // Clear approvals from the previous owner
866         _approve(address(0), tokenId);
867         _owners[tokenId] = to;
868 
869         emit Transfer(from, to, tokenId);
870     }
871     function _approve(address to, uint256 tokenId) internal virtual {
872         _tokenApprovals[tokenId] = to;
873         emit Approval(ERC721P.ownerOf(tokenId), to, tokenId);
874     }
875     function _checkOnERC721Received(
876         address from,
877         address to,
878         uint256 tokenId,
879         bytes memory _data
880     ) private returns (bool) {
881         if (to.isContract()) {
882             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
883                 return retval == IERC721Receiver.onERC721Received.selector;
884             } catch (bytes memory reason) {
885                 if (reason.length == 0) {
886                     revert("ERC721: transfer to non ERC721Receiver implementer");
887                 } else {
888                     assembly {
889                         revert(add(32, reason), mload(reason))
890                     }
891                 }
892             }
893         } else {
894             return true;
895         }
896     }
897     function _beforeTokenTransfer(
898         address from,
899         address to,
900         uint256 tokenId
901     ) internal virtual {}
902 }
903 
904 pragma solidity ^0.8.10;
905 
906 abstract contract ERC721Enum is ERC721P, IERC721Enumerable {
907     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721P) returns (bool) {
908         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
909     }
910     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256 tokenId) {
911         require(index < ERC721P.balanceOf(owner), "ERC721Enum: owner ioob");
912         uint count;
913         for( uint i; i < _owners.length; ++i ){
914             if( owner == _owners[i] ){
915                 if( count == index )
916                     return i;
917                 else
918                     ++count;
919             }
920         }
921         require(false, "ERC721Enum: owner ioob");
922     }
923     function tokensOfOwner(address owner) public view returns (uint256[] memory) {
924         require(0 < ERC721P.balanceOf(owner), "ERC721Enum: owner ioob");
925         uint256 tokenCount = balanceOf(owner);
926         uint256[] memory tokenIds = new uint256[](tokenCount);
927         for (uint256 i = 0; i < tokenCount; i++) {
928             tokenIds[i] = tokenOfOwnerByIndex(owner, i);
929         }
930         return tokenIds;
931     }
932     function totalSupply() public view virtual override returns (uint256) {
933         return _owners.length;
934     }
935     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
936         require(index < ERC721Enum.totalSupply(), "ERC721Enum: global ioob");
937         return index;
938     }
939 }
940 
941 pragma solidity ^0.8.0;
942 
943 interface LinkTokenInterface {
944     function allowance(address owner, address spender) external view returns (uint256 remaining);
945 
946     function approve(address spender, uint256 value) external returns (bool success);
947 
948     function balanceOf(address owner) external view returns (uint256 balance);
949 
950     function decimals() external view returns (uint8 decimalPlaces);
951 
952     function decreaseApproval(address spender, uint256 addedValue) external returns (bool success);
953 
954     function increaseApproval(address spender, uint256 subtractedValue) external;
955 
956     function name() external view returns (string memory tokenName);
957 
958     function symbol() external view returns (string memory tokenSymbol);
959 
960     function totalSupply() external view returns (uint256 totalTokensIssued);
961 
962     function transfer(address to, uint256 value) external returns (bool success);
963 
964     function transferAndCall(
965         address to,
966         uint256 value,
967         bytes calldata data
968     ) external returns (bool success);
969 
970     function transferFrom(
971         address from,
972         address to,
973         uint256 value
974     ) external returns (bool success);
975 }
976 
977 pragma solidity ^0.8.0;
978 
979 contract VRFRequestIDBase {
980     /**
981      * @notice returns the seed which is actually input to the VRF coordinator
982    *
983    * @dev To prevent repetition of VRF output due to repetition of the
984    * @dev user-supplied seed, that seed is combined in a hash with the
985    * @dev user-specific nonce, and the address of the consuming contract. The
986    * @dev risk of repetition is mostly mitigated by inclusion of a blockhash in
987    * @dev the final seed, but the nonce does protect against repetition in
988    * @dev requests which are included in a single block.
989    *
990    * @param _userSeed VRF seed input provided by user
991    * @param _requester Address of the requesting contract
992    * @param _nonce User-specific nonce at the time of the request
993    */
994     function makeVRFInputSeed(
995         bytes32 _keyHash,
996         uint256 _userSeed,
997         address _requester,
998         uint256 _nonce
999     ) internal pure returns (uint256) {
1000         return uint256(keccak256(abi.encode(_keyHash, _userSeed, _requester, _nonce)));
1001     }
1002 
1003     /**
1004      * @notice Returns the id for this request
1005    * @param _keyHash The serviceAgreement ID to be used for this request
1006    * @param _vRFInputSeed The seed to be passed directly to the VRF
1007    * @return The id for this request
1008    *
1009    * @dev Note that _vRFInputSeed is not the seed passed by the consuming
1010    * @dev contract, but the one generated by makeVRFInputSeed
1011    */
1012     function makeRequestId(bytes32 _keyHash, uint256 _vRFInputSeed) internal pure returns (bytes32) {
1013         return keccak256(abi.encodePacked(_keyHash, _vRFInputSeed));
1014     }
1015 }
1016 
1017 pragma solidity ^0.8.0;
1018 
1019 /** ****************************************************************************
1020  * @notice Interface for contracts using VRF randomness
1021  * *****************************************************************************
1022  * @dev PURPOSE
1023  *
1024  * @dev Reggie the Random Oracle (not his real job) wants to provide randomness
1025  * @dev to Vera the verifier in such a way that Vera can be sure he's not
1026  * @dev making his output up to suit himself. Reggie provides Vera a public key
1027  * @dev to which he knows the secret key. Each time Vera provides a seed to
1028  * @dev Reggie, he gives back a value which is computed completely
1029  * @dev deterministically from the seed and the secret key.
1030  *
1031  * @dev Reggie provides a proof by which Vera can verify that the output was
1032  * @dev correctly computed once Reggie tells it to her, but without that proof,
1033  * @dev the output is indistinguishable to her from a uniform random sample
1034  * @dev from the output space.
1035  *
1036  * @dev The purpose of this contract is to make it easy for unrelated contracts
1037  * @dev to talk to Vera the verifier about the work Reggie is doing, to provide
1038  * @dev simple access to a verifiable source of randomness.
1039  * *****************************************************************************
1040  * @dev USAGE
1041  *
1042  * @dev Calling contracts must inherit from VRFConsumerBase, and can
1043  * @dev initialize VRFConsumerBase's attributes in their constructor as
1044  * @dev shown:
1045  *
1046  * @dev   contract VRFConsumer {
1047  * @dev     constructor(<other arguments>, address _vrfCoordinator, address _link)
1048  * @dev       VRFConsumerBase(_vrfCoordinator, _link) public {
1049  * @dev         <initialization with other arguments goes here>
1050  * @dev       }
1051  * @dev   }
1052  *
1053  * @dev The oracle will have given you an ID for the VRF keypair they have
1054  * @dev committed to (let's call it keyHash), and have told you the minimum LINK
1055  * @dev price for VRF service. Make sure your contract has sufficient LINK, and
1056  * @dev call requestRandomness(keyHash, fee, seed), where seed is the input you
1057  * @dev want to generate randomness from.
1058  *
1059  * @dev Once the VRFCoordinator has received and validated the oracle's response
1060  * @dev to your request, it will call your contract's fulfillRandomness method.
1061  *
1062  * @dev The randomness argument to fulfillRandomness is the actual random value
1063  * @dev generated from your seed.
1064  *
1065  * @dev The requestId argument is generated from the keyHash and the seed by
1066  * @dev makeRequestId(keyHash, seed). If your contract could have concurrent
1067  * @dev requests open, you can use the requestId to track which seed is
1068  * @dev associated with which randomness. See VRFRequestIDBase.sol for more
1069  * @dev details. (See "SECURITY CONSIDERATIONS" for principles to keep in mind,
1070  * @dev if your contract could have multiple requests in flight simultaneously.)
1071  *
1072  * @dev Colliding `requestId`s are cryptographically impossible as long as seeds
1073  * @dev differ. (Which is critical to making unpredictable randomness! See the
1074  * @dev next section.)
1075  *
1076  * *****************************************************************************
1077  * @dev SECURITY CONSIDERATIONS
1078  *
1079  * @dev A method with the ability to call your fulfillRandomness method directly
1080  * @dev could spoof a VRF response with any random value, so it's critical that
1081  * @dev it cannot be directly called by anything other than this base contract
1082  * @dev (specifically, by the VRFConsumerBase.rawFulfillRandomness method).
1083  *
1084  * @dev For your users to trust that your contract's random behavior is free
1085  * @dev from malicious interference, it's best if you can write it so that all
1086  * @dev behaviors implied by a VRF response are executed *during* your
1087  * @dev fulfillRandomness method. If your contract must store the response (or
1088  * @dev anything derived from it) and use it later, you must ensure that any
1089  * @dev user-significant behavior which depends on that stored value cannot be
1090  * @dev manipulated by a subsequent VRF request.
1091  *
1092  * @dev Similarly, both miners and the VRF oracle itself have some influence
1093  * @dev over the order in which VRF responses appear on the blockchain, so if
1094  * @dev your contract could have multiple VRF requests in flight simultaneously,
1095  * @dev you must ensure that the order in which the VRF responses arrive cannot
1096  * @dev be used to manipulate your contract's user-significant behavior.
1097  *
1098  * @dev Since the ultimate input to the VRF is mixed with the block hash of the
1099  * @dev block in which the request is made, user-provided seeds have no impact
1100  * @dev on its economic security properties. They are only included for API
1101  * @dev compatability with previous versions of this contract.
1102  *
1103  * @dev Since the block hash of the block which contains the requestRandomness
1104  * @dev call is mixed into the input to the VRF *last*, a sufficiently powerful
1105  * @dev miner could, in principle, fork the blockchain to evict the block
1106  * @dev containing the request, forcing the request to be included in a
1107  * @dev different block with a different hash, and therefore a different input
1108  * @dev to the VRF. However, such an attack would incur a substantial economic
1109  * @dev cost. This cost scales with the number of blocks the VRF oracle waits
1110  * @dev until it calls responds to a request.
1111  */
1112 abstract contract VRFConsumerBase is VRFRequestIDBase {
1113     /**
1114      * @notice fulfillRandomness handles the VRF response. Your contract must
1115    * @notice implement it. See "SECURITY CONSIDERATIONS" above for important
1116    * @notice principles to keep in mind when implementing your fulfillRandomness
1117    * @notice method.
1118    *
1119    * @dev VRFConsumerBase expects its subcontracts to have a method with this
1120    * @dev signature, and will call it once it has verified the proof
1121    * @dev associated with the randomness. (It is triggered via a call to
1122    * @dev rawFulfillRandomness, below.)
1123    *
1124    * @param requestId The Id initially returned by requestRandomness
1125    * @param randomness the VRF output
1126    */
1127     function fulfillRandomness(bytes32 requestId, uint256 randomness) internal virtual;
1128 
1129     /**
1130      * @dev In order to keep backwards compatibility we have kept the user
1131    * seed field around. We remove the use of it because given that the blockhash
1132    * enters later, it overrides whatever randomness the used seed provides.
1133    * Given that it adds no security, and can easily lead to misunderstandings,
1134    * we have removed it from usage and can now provide a simpler API.
1135    */
1136     uint256 private constant USER_SEED_PLACEHOLDER = 0;
1137 
1138     /**
1139      * @notice requestRandomness initiates a request for VRF output given _seed
1140    *
1141    * @dev The fulfillRandomness method receives the output, once it's provided
1142    * @dev by the Oracle, and verified by the vrfCoordinator.
1143    *
1144    * @dev The _keyHash must already be registered with the VRFCoordinator, and
1145    * @dev the _fee must exceed the fee specified during registration of the
1146    * @dev _keyHash.
1147    *
1148    * @dev The _seed parameter is vestigial, and is kept only for API
1149    * @dev compatibility with older versions. It can't *hurt* to mix in some of
1150    * @dev your own randomness, here, but it's not necessary because the VRF
1151    * @dev oracle will mix the hash of the block containing your request into the
1152    * @dev VRF seed it ultimately uses.
1153    *
1154    * @param _keyHash ID of public key against which randomness is generated
1155    * @param _fee The amount of LINK to send with the request
1156    *
1157    * @return requestId unique ID for this request
1158    *
1159    * @dev The returned requestId can be used to distinguish responses to
1160    * @dev concurrent requests. It is passed as the first argument to
1161    * @dev fulfillRandomness.
1162    */
1163     function requestRandomness(bytes32 _keyHash, uint256 _fee) internal returns (bytes32 requestId) {
1164         LINK.transferAndCall(vrfCoordinator, _fee, abi.encode(_keyHash, USER_SEED_PLACEHOLDER));
1165         // This is the seed passed to VRFCoordinator. The oracle will mix this with
1166         // the hash of the block containing this request to obtain the seed/input
1167         // which is finally passed to the VRF cryptographic machinery.
1168         uint256 vRFSeed = makeVRFInputSeed(_keyHash, USER_SEED_PLACEHOLDER, address(this), nonces[_keyHash]);
1169         // nonces[_keyHash] must stay in sync with
1170         // VRFCoordinator.nonces[_keyHash][this], which was incremented by the above
1171         // successful LINK.transferAndCall (in VRFCoordinator.randomnessRequest).
1172         // This provides protection against the user repeating their input seed,
1173         // which would result in a predictable/duplicate output, if multiple such
1174         // requests appeared in the same block.
1175         nonces[_keyHash] = nonces[_keyHash] + 1;
1176         return makeRequestId(_keyHash, vRFSeed);
1177     }
1178 
1179     LinkTokenInterface internal immutable LINK;
1180     address private immutable vrfCoordinator;
1181 
1182     // Nonces for each VRF key from which randomness has been requested.
1183     //
1184     // Must stay in sync with VRFCoordinator[_keyHash][this]
1185     mapping(bytes32 => uint256) /* keyHash */ /* nonce */
1186     private nonces;
1187 
1188     /**
1189      * @param _vrfCoordinator address of VRFCoordinator contract
1190    * @param _link address of LINK token contract
1191    *
1192    * @dev https://docs.chain.link/docs/link-token-contracts
1193    */
1194     constructor(address _vrfCoordinator, address _link) {
1195         vrfCoordinator = _vrfCoordinator;
1196         LINK = LinkTokenInterface(_link);
1197     }
1198 
1199     // rawFulfillRandomness is called by VRFCoordinator when it receives a valid VRF
1200     // proof. rawFulfillRandomness then calls fulfillRandomness, after validating
1201     // the origin of the call
1202     function rawFulfillRandomness(bytes32 requestId, uint256 randomness) external {
1203         require(msg.sender == vrfCoordinator, "Only VRFCoordinator can fulfill");
1204         fulfillRandomness(requestId, randomness);
1205     }
1206 }
1207 
1208 pragma solidity ^0.8.0;
1209 
1210 /**
1211  * @dev Contract module which allows children to implement an emergency stop
1212  * mechanism that can be triggered by an authorized account.
1213  *
1214  * This module is used through inheritance. It will make available the
1215  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1216  * the functions of your contract. Note that they will not be pausable by
1217  * simply including this module, only once the modifiers are put in place.
1218  */
1219 abstract contract Pausable is Context {
1220     /**
1221      * @dev Emitted when the pause is triggered by `account`.
1222      */
1223     event Paused(address account);
1224 
1225     /**
1226      * @dev Emitted when the pause is lifted by `account`.
1227      */
1228     event Unpaused(address account);
1229 
1230     bool private _paused;
1231 
1232     /**
1233      * @dev Initializes the contract in unpaused state.
1234      */
1235     constructor() {
1236         _paused = false;
1237     }
1238 
1239     /**
1240      * @dev Returns true if the contract is paused, and false otherwise.
1241      */
1242     function paused() public view virtual returns (bool) {
1243         return _paused;
1244     }
1245 
1246     /**
1247      * @dev Modifier to make a function callable only when the contract is not paused.
1248      *
1249      * Requirements:
1250      *
1251      * - The contract must not be paused.
1252      */
1253     modifier whenNotPaused() {
1254         require(!paused(), "Pausable: paused");
1255         _;
1256     }
1257 
1258     /**
1259      * @dev Modifier to make a function callable only when the contract is paused.
1260      *
1261      * Requirements:
1262      *
1263      * - The contract must be paused.
1264      */
1265     modifier whenPaused() {
1266         require(paused(), "Pausable: not paused");
1267         _;
1268     }
1269 
1270     /**
1271      * @dev Triggers stopped state.
1272      *
1273      * Requirements:
1274      *
1275      * - The contract must not be paused.
1276      */
1277     function _pause() internal virtual whenNotPaused {
1278         _paused = true;
1279         emit Paused(_msgSender());
1280     }
1281 
1282     /**
1283      * @dev Returns to normal state.
1284      *
1285      * Requirements:
1286      *
1287      * - The contract must be paused.
1288      */
1289     function _unpause() internal virtual whenPaused {
1290         _paused = false;
1291         emit Unpaused(_msgSender());
1292     }
1293 }
1294 
1295 pragma solidity ^0.8.10;
1296 
1297 interface IBloodTokenContract {
1298     function walletsBalances(address wallet) external view returns (uint256);
1299     function spend(address owner, uint256 amount) external;
1300 }
1301 
1302 interface IGameStats {
1303     function setHousesLevels(uint256[] calldata tokenIds_, uint256[] calldata levels_) external;
1304 }
1305 
1306 contract BloodShedBearsTreeHouse is ERC721Enum, VRFConsumerBase, Ownable, Pausable {
1307     using Strings for uint256;
1308 
1309     //sale settings
1310     uint256 constant private maxSupply = 7000;
1311     uint256 private teamReserveAvailableMints = 100;
1312     uint256 private cost = 50000 ether;
1313     address public bloodTokenContract = 0x0000000000000000000000000000000000000000;
1314     address public gameStatsContract = 0x0000000000000000000000000000000000000000;
1315 
1316     string private baseURI;
1317 
1318     uint256 private vrfFee;
1319     bytes32 private vrfKeyHash;
1320 
1321     uint256 private seed;
1322 
1323     event SeedFulfilled();
1324 
1325     constructor(
1326         string memory initBaseURI_,
1327         address vrfCoordinatorAddr_,
1328         address linkTokenAddr_,
1329         bytes32 vrfKeyHash_,
1330         uint256 fee_
1331     )
1332     VRFConsumerBase(vrfCoordinatorAddr_, linkTokenAddr_)
1333     ERC721P("Bloodshed Bears TreeHouse", "BSBTH") {
1334         setBaseURI(initBaseURI_);
1335         vrfKeyHash = vrfKeyHash_;
1336         vrfFee = fee_;
1337        pause();
1338     }
1339 
1340     // internal
1341     function _baseURI() internal view virtual returns (string memory) {
1342         return baseURI;
1343     }
1344 
1345     function setBloodTokenContract(address contractAddress_) public onlyOwner {
1346         bloodTokenContract = contractAddress_;
1347     }
1348 
1349     function setGameStatsContract(address contractAddress_) public onlyOwner {
1350         gameStatsContract = contractAddress_;
1351     }
1352 
1353     function setCost(uint256 _newCost) external onlyOwner {
1354         cost = _newCost;
1355     }
1356 
1357     function mint(uint256 mintAmount_) external payable whenNotPaused {
1358         require(seed != 0, "Seed not set");
1359 
1360         uint256 totalSupply = totalSupply();
1361 
1362         require(totalSupply + mintAmount_ <= maxSupply, "TOO MANY");
1363         require(IBloodTokenContract(bloodTokenContract).walletsBalances(msg.sender) >= mintAmount_ * cost, "NOT ENOUGH");
1364 
1365         IBloodTokenContract(bloodTokenContract).spend(msg.sender, mintAmount_ * cost);
1366 
1367         uint256[] memory tokens = new uint256[](mintAmount_);
1368         uint256[] memory levels = new uint256[](mintAmount_);
1369 
1370         for (uint256 i = 0; i < mintAmount_; i++) {
1371             tokens[i] = totalSupply + i;
1372             levels[i] = generateHouseLevel(totalSupply + i) + 1;
1373             _safeMint(msg.sender, totalSupply + i);
1374         }
1375 
1376         IGameStats(gameStatsContract).setHousesLevels(tokens, levels);
1377 
1378         delete totalSupply;
1379         delete tokens;
1380         delete levels;
1381     }
1382 
1383     function tokenURI(uint256 _tokenId) external view virtual override returns (string memory) {
1384         require(_exists(_tokenId), "ERC721Metadata: Nonexistent token");
1385         string memory currentBaseURI = _baseURI();
1386 
1387         return bytes(currentBaseURI).length > 0	? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), ".json")) : "";
1388     }
1389 
1390     function reserve(address _to, uint256 _reserveAmount) public onlyOwner {
1391         require(seed != 0, "Seed not set");
1392         uint256 supply = totalSupply();
1393         require(
1394             _reserveAmount > 0 && _reserveAmount <= teamReserveAvailableMints,
1395             "Not enough reserve left for team"
1396         );
1397 
1398         uint256[] memory tokens = new uint256[](_reserveAmount);
1399         uint256[] memory levels = new uint256[](_reserveAmount);
1400         for (uint256 i = 0; i < _reserveAmount; i++) {
1401             tokens[i] = supply + i;
1402             levels[i] = generateHouseLevel(supply + i) + 1;
1403             _safeMint(_to, supply + i);
1404         }
1405 
1406         IGameStats(gameStatsContract).setHousesLevels(tokens, levels);
1407 
1408         teamReserveAvailableMints -= _reserveAmount;
1409 
1410         delete supply;
1411         delete tokens;
1412         delete levels;
1413     }
1414 
1415     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1416         baseURI = _newBaseURI;
1417     }
1418 
1419     function isOwnerOfBatch(uint256[] calldata tokenIds_, address address_) external view returns (bool) {
1420         bool ownership = true;
1421 
1422         for (uint256 i = 0; i < tokenIds_.length; ++i) {
1423             ownership = ownership && (ownerOf(tokenIds_[i]) == address_);
1424         }
1425 
1426         return ownership;
1427     }
1428 
1429     function generateHouseLevel(uint256 tokenId) public view returns (uint256) {
1430         return uint256(keccak256(abi.encodePacked(seed, tokenId, tx.origin, blockhash(block.number - 1), block.timestamp))) % 3;
1431     }
1432 
1433     function initSeedGeneration() public onlyOwner returns (bytes32 requestId) {
1434         require(LINK.balanceOf(address(this)) >= vrfFee, "Not enough LINK");
1435         return requestRandomness(vrfKeyHash, vrfFee);
1436     }
1437 
1438     function fulfillRandomness(bytes32, uint256 randomness) internal override {
1439         seed = randomness;
1440         emit SeedFulfilled();
1441     }
1442 
1443     function pause() public onlyOwner {
1444         _pause();
1445     }
1446 
1447     function unpause() public onlyOwner {
1448         _unpause();
1449     }
1450 
1451 }