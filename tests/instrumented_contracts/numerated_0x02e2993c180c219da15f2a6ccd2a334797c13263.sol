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
175  * @dev Contract module that helps prevent reentrant calls to a function.
176  *
177  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
178  * available, which can be applied to functions to make sure there are no nested
179  * (reentrant) calls to them.
180  *
181  * Note that because there is a single `nonReentrant` guard, functions marked as
182  * `nonReentrant` may not call one another. This can be worked around by making
183  * those functions `private`, and then adding `external` `nonReentrant` entry
184  * points to them.
185  *
186  * TIP: If you would like to learn more about reentrancy and alternative ways
187  * to protect against it, check out our blog post
188  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
189  */
190 abstract contract ReentrancyGuard {
191     // Booleans are more expensive than uint256 or any type that takes up a full
192     // word because each write operation emits an extra SLOAD to first read the
193     // slot's contents, replace the bits taken up by the boolean, and then write
194     // back. This is the compiler's defense against contract upgrades and
195     // pointer aliasing, and it cannot be disabled.
196 
197     // The values being non-zero value makes deployment a bit more expensive,
198     // but in exchange the refund on every call to nonReentrant will be lower in
199     // amount. Since refunds are capped to a percentage of the total
200     // transaction's gas, it is best to keep them low in cases like this one, to
201     // increase the likelihood of the full refund coming into effect.
202     uint256 private constant _NOT_ENTERED = 1;
203     uint256 private constant _ENTERED = 2;
204 
205     uint256 private _status;
206 
207     constructor() {
208         _status = _NOT_ENTERED;
209     }
210 
211     /**
212      * @dev Prevents a contract from calling itself, directly or indirectly.
213      * Calling a `nonReentrant` function from another `nonReentrant`
214      * function is not supported. It is possible to prevent this from happening
215      * by making the `nonReentrant` function external, and make it call a
216      * `private` function that does the actual work.
217      */
218     modifier nonReentrant() {
219         // On the first call to nonReentrant, _notEntered will be true
220         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
221 
222         // Any calls to nonReentrant after this point will fail
223         _status = _ENTERED;
224 
225         _;
226 
227         // By storing the original value once again, a refund is triggered (see
228         // https://eips.ethereum.org/EIPS/eip-2200)
229         _status = _NOT_ENTERED;
230     }
231 }
232 
233 pragma solidity ^0.8.0;
234 
235 /**
236  * @dev Interface of the ERC165 standard, as defined in the
237  * https://eips.ethereum.org/EIPS/eip-165[EIP].
238  *
239  * Implementers can declare support of contract interfaces, which can then be
240  * queried by others ({ERC165Checker}).
241  *
242  * For an implementation, see {ERC165}.
243  */
244 interface IERC165 {
245     /**
246      * @dev Returns true if this contract implements the interface defined by
247      * `interfaceId`. See the corresponding
248      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
249      * to learn more about how these ids are created.
250      *
251      * This function call must use less than 30 000 gas.
252      */
253     function supportsInterface(bytes4 interfaceId) external view returns (bool);
254 }
255 
256 pragma solidity ^0.8.0;
257 
258 /**
259  * @dev Required interface of an ERC721 compliant contract.
260  */
261 interface IERC721 is IERC165 {
262     /**
263      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
264      */
265     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
266 
267     /**
268      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
269      */
270     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
271 
272     /**
273      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
274      */
275     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
276 
277     /**
278      * @dev Returns the number of tokens in ``owner``'s account.
279      */
280     function balanceOf(address owner) external view returns (uint256 balance);
281 
282     /**
283      * @dev Returns the owner of the `tokenId` token.
284      *
285      * Requirements:
286      *
287      * - `tokenId` must exist.
288      */
289     function ownerOf(uint256 tokenId) external view returns (address owner);
290 
291     /**
292      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
293      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
294      *
295      * Requirements:
296      *
297      * - `from` cannot be the zero address.
298      * - `to` cannot be the zero address.
299      * - `tokenId` token must exist and be owned by `from`.
300      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
301      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
302      *
303      * Emits a {Transfer} event.
304      */
305     function safeTransferFrom(
306         address from,
307         address to,
308         uint256 tokenId
309     ) external;
310 
311     /**
312      * @dev Transfers `tokenId` token from `from` to `to`.
313      *
314      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
315      *
316      * Requirements:
317      *
318      * - `from` cannot be the zero address.
319      * - `to` cannot be the zero address.
320      * - `tokenId` token must be owned by `from`.
321      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
322      *
323      * Emits a {Transfer} event.
324      */
325     function transferFrom(
326         address from,
327         address to,
328         uint256 tokenId
329     ) external;
330 
331     /**
332      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
333      * The approval is cleared when the token is transferred.
334      *
335      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
336      *
337      * Requirements:
338      *
339      * - The caller must own the token or be an approved operator.
340      * - `tokenId` must exist.
341      *
342      * Emits an {Approval} event.
343      */
344     function approve(address to, uint256 tokenId) external;
345 
346     /**
347      * @dev Returns the account approved for `tokenId` token.
348      *
349      * Requirements:
350      *
351      * - `tokenId` must exist.
352      */
353     function getApproved(uint256 tokenId) external view returns (address operator);
354 
355     /**
356      * @dev Approve or remove `operator` as an operator for the caller.
357      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
358      *
359      * Requirements:
360      *
361      * - The `operator` cannot be the caller.
362      *
363      * Emits an {ApprovalForAll} event.
364      */
365     function setApprovalForAll(address operator, bool _approved) external;
366 
367     /**
368      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
369      *
370      * See {setApprovalForAll}
371      */
372     function isApprovedForAll(address owner, address operator) external view returns (bool);
373 
374     /**
375      * @dev Safely transfers `tokenId` token from `from` to `to`.
376      *
377      * Requirements:
378      *
379      * - `from` cannot be the zero address.
380      * - `to` cannot be the zero address.
381      * - `tokenId` token must exist and be owned by `from`.
382      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
383      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
384      *
385      * Emits a {Transfer} event.
386      */
387     function safeTransferFrom(
388         address from,
389         address to,
390         uint256 tokenId,
391         bytes calldata data
392     ) external;
393 }
394 
395 pragma solidity ^0.8.0;
396 
397 /**
398  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
399  * @dev See https://eips.ethereum.org/EIPS/eip-721
400  */
401 interface IERC721Enumerable is IERC721 {
402     /**
403      * @dev Returns the total amount of tokens stored by the contract.
404      */
405     function totalSupply() external view returns (uint256);
406 
407     /**
408      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
409      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
410      */
411     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
412 
413     /**
414      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
415      * Use along with {totalSupply} to enumerate all tokens.
416      */
417     function tokenByIndex(uint256 index) external view returns (uint256);
418 }
419 
420 pragma solidity ^0.8.0;
421 
422 /**
423  * @title ERC721 token receiver interface
424  * @dev Interface for any contract that wants to support safeTransfers
425  * from ERC721 asset contracts.
426  */
427 interface IERC721Receiver {
428     /**
429      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
430      * by `operator` from `from`, this function is called.
431      *
432      * It must return its Solidity selector to confirm the token transfer.
433      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
434      *
435      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
436      */
437     function onERC721Received(
438         address operator,
439         address from,
440         uint256 tokenId,
441         bytes calldata data
442     ) external returns (bytes4);
443 }
444 
445 pragma solidity ^0.8.0;
446 
447 /**
448  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
449  * @dev See https://eips.ethereum.org/EIPS/eip-721
450  */
451 interface IERC721Metadata is IERC721 {
452     /**
453      * @dev Returns the token collection name.
454      */
455     function name() external view returns (string memory);
456 
457     /**
458      * @dev Returns the token collection symbol.
459      */
460     function symbol() external view returns (string memory);
461 
462     /**
463      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
464      */
465     function tokenURI(uint256 tokenId) external view returns (string memory);
466 }
467 
468 pragma solidity ^0.8.0;
469 
470 /**
471  * @dev Collection of functions related to the address type
472  */
473 library Address {
474     /**
475      * @dev Returns true if `account` is a contract.
476      *
477      * [IMPORTANT]
478      * ====
479      * It is unsafe to assume that an address for which this function returns
480      * false is an externally-owned account (EOA) and not a contract.
481      *
482      * Among others, `isContract` will return false for the following
483      * types of addresses:
484      *
485      *  - an externally-owned account
486      *  - a contract in construction
487      *  - an address where a contract will be created
488      *  - an address where a contract lived, but was destroyed
489      * ====
490      */
491     function isContract(address account) internal view returns (bool) {
492         // This method relies on extcodesize, which returns 0 for contracts in
493         // construction, since the code is only stored at the end of the
494         // constructor execution.
495 
496         uint256 size;
497         assembly {
498             size := extcodesize(account)
499         }
500         return size > 0;
501     }
502 
503     /**
504      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
505      * `recipient`, forwarding all available gas and reverting on errors.
506      *
507      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
508      * of certain opcodes, possibly making contracts go over the 2300 gas limit
509      * imposed by `transfer`, making them unable to receive funds via
510      * `transfer`. {sendValue} removes this limitation.
511      *
512      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
513      *
514      * IMPORTANT: because control is transferred to `recipient`, care must be
515      * taken to not create reentrancy vulnerabilities. Consider using
516      * {ReentrancyGuard} or the
517      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
518      */
519     function sendValue(address payable recipient, uint256 amount) internal {
520         require(address(this).balance >= amount, "Address: insufficient balance");
521 
522         (bool success, ) = recipient.call{value: amount}("");
523         require(success, "Address: unable to send value, recipient may have reverted");
524     }
525 
526     /**
527      * @dev Performs a Solidity function call using a low level `call`. A
528      * plain `call` is an unsafe replacement for a function call: use this
529      * function instead.
530      *
531      * If `target` reverts with a revert reason, it is bubbled up by this
532      * function (like regular Solidity function calls).
533      *
534      * Returns the raw returned data. To convert to the expected return value,
535      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
536      *
537      * Requirements:
538      *
539      * - `target` must be a contract.
540      * - calling `target` with `data` must not revert.
541      *
542      * _Available since v3.1._
543      */
544     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
545         return functionCall(target, data, "Address: low-level call failed");
546     }
547 
548     /**
549      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
550      * `errorMessage` as a fallback revert reason when `target` reverts.
551      *
552      * _Available since v3.1._
553      */
554     function functionCall(
555         address target,
556         bytes memory data,
557         string memory errorMessage
558     ) internal returns (bytes memory) {
559         return functionCallWithValue(target, data, 0, errorMessage);
560     }
561 
562     /**
563      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
564      * but also transferring `value` wei to `target`.
565      *
566      * Requirements:
567      *
568      * - the calling contract must have an ETH balance of at least `value`.
569      * - the called Solidity function must be `payable`.
570      *
571      * _Available since v3.1._
572      */
573     function functionCallWithValue(
574         address target,
575         bytes memory data,
576         uint256 value
577     ) internal returns (bytes memory) {
578         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
579     }
580 
581     /**
582      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
583      * with `errorMessage` as a fallback revert reason when `target` reverts.
584      *
585      * _Available since v3.1._
586      */
587     function functionCallWithValue(
588         address target,
589         bytes memory data,
590         uint256 value,
591         string memory errorMessage
592     ) internal returns (bytes memory) {
593         require(address(this).balance >= value, "Address: insufficient balance for call");
594         require(isContract(target), "Address: call to non-contract");
595 
596         (bool success, bytes memory returndata) = target.call{value: value}(data);
597         return verifyCallResult(success, returndata, errorMessage);
598     }
599 
600     /**
601      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
602      * but performing a static call.
603      *
604      * _Available since v3.3._
605      */
606     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
607         return functionStaticCall(target, data, "Address: low-level static call failed");
608     }
609 
610     /**
611      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
612      * but performing a static call.
613      *
614      * _Available since v3.3._
615      */
616     function functionStaticCall(
617         address target,
618         bytes memory data,
619         string memory errorMessage
620     ) internal view returns (bytes memory) {
621         require(isContract(target), "Address: static call to non-contract");
622 
623         (bool success, bytes memory returndata) = target.staticcall(data);
624         return verifyCallResult(success, returndata, errorMessage);
625     }
626 
627     /**
628      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
629      * but performing a delegate call.
630      *
631      * _Available since v3.4._
632      */
633     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
634         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
635     }
636 
637     /**
638      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
639      * but performing a delegate call.
640      *
641      * _Available since v3.4._
642      */
643     function functionDelegateCall(
644         address target,
645         bytes memory data,
646         string memory errorMessage
647     ) internal returns (bytes memory) {
648         require(isContract(target), "Address: delegate call to non-contract");
649 
650         (bool success, bytes memory returndata) = target.delegatecall(data);
651         return verifyCallResult(success, returndata, errorMessage);
652     }
653 
654     /**
655      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
656      * revert reason using the provided one.
657      *
658      * _Available since v4.3._
659      */
660     function verifyCallResult(
661         bool success,
662         bytes memory returndata,
663         string memory errorMessage
664     ) internal pure returns (bytes memory) {
665         if (success) {
666             return returndata;
667         } else {
668             // Look for revert reason and bubble it up if present
669             if (returndata.length > 0) {
670                 // The easiest way to bubble the revert reason is using memory via assembly
671 
672                 assembly {
673                     let returndata_size := mload(returndata)
674                     revert(add(32, returndata), returndata_size)
675                 }
676             } else {
677                 revert(errorMessage);
678             }
679         }
680     }
681 }
682 
683 pragma solidity ^0.8.0;
684 
685 /**
686  * @dev Implementation of the {IERC165} interface.
687  *
688  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
689  * for the additional interface id that will be supported. For example:
690  *
691  * ```solidity
692  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
693  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
694  * }
695  * ```
696  *
697  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
698  */
699 abstract contract ERC165 is IERC165 {
700     /**
701      * @dev See {IERC165-supportsInterface}.
702      */
703     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
704         return interfaceId == type(IERC165).interfaceId;
705     }
706 }
707 pragma solidity ^0.8.10;
708 
709 abstract contract ERC721P is Context, ERC165, IERC721, IERC721Metadata {
710     using Address for address;
711     string private _name;
712     string private _symbol;
713     address[] internal _owners;
714     mapping(uint256 => address) private _tokenApprovals;
715     mapping(address => mapping(address => bool)) private _operatorApprovals;
716     constructor(string memory name_, string memory symbol_) {
717         _name = name_;
718         _symbol = symbol_;
719     }
720     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
721         return
722         interfaceId == type(IERC721).interfaceId ||
723         interfaceId == type(IERC721Metadata).interfaceId ||
724         super.supportsInterface(interfaceId);
725     }
726     function balanceOf(address owner) public view virtual override returns (uint256) {
727         require(owner != address(0), "ERC721: balance query for the zero address");
728         uint count = 0;
729         uint length = _owners.length;
730         for( uint i = 0; i < length; ++i ){
731             if( owner == _owners[i] ){
732                 ++count;
733             }
734         }
735         delete length;
736         return count;
737     }
738     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
739         address owner = _owners[tokenId];
740         require(owner != address(0), "ERC721: owner query for nonexistent token");
741         return owner;
742     }
743     function name() public view virtual override returns (string memory) {
744         return _name;
745     }
746     function symbol() public view virtual override returns (string memory) {
747         return _symbol;
748     }
749     function approve(address to, uint256 tokenId) public virtual override {
750         address owner = ERC721P.ownerOf(tokenId);
751         require(to != owner, "ERC721: approval to current owner");
752 
753         require(
754             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
755             "ERC721: approve caller is not owner nor approved for all"
756         );
757 
758         _approve(to, tokenId);
759     }
760     function getApproved(uint256 tokenId) public view virtual override returns (address) {
761         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
762 
763         return _tokenApprovals[tokenId];
764     }
765     function setApprovalForAll(address operator, bool approved) public virtual override {
766         require(operator != _msgSender(), "ERC721: approve to caller");
767 
768         _operatorApprovals[_msgSender()][operator] = approved;
769         emit ApprovalForAll(_msgSender(), operator, approved);
770     }
771     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
772         return _operatorApprovals[owner][operator];
773     }
774     function transferFrom(
775         address from,
776         address to,
777         uint256 tokenId
778     ) public virtual override {
779         //solhint-disable-next-line max-line-length
780         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
781 
782         _transfer(from, to, tokenId);
783     }
784     function safeTransferFrom(
785         address from,
786         address to,
787         uint256 tokenId
788     ) public virtual override {
789         safeTransferFrom(from, to, tokenId, "");
790     }
791     function safeTransferFrom(
792         address from,
793         address to,
794         uint256 tokenId,
795         bytes memory _data
796     ) public virtual override {
797         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
798         _safeTransfer(from, to, tokenId, _data);
799     }
800     function _safeTransfer(
801         address from,
802         address to,
803         uint256 tokenId,
804         bytes memory _data
805     ) internal virtual {
806         _transfer(from, to, tokenId);
807         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
808     }
809     function _exists(uint256 tokenId) internal view virtual returns (bool) {
810         return tokenId < _owners.length && _owners[tokenId] != address(0);
811     }
812     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
813         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
814         address owner = ERC721P.ownerOf(tokenId);
815         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
816     }
817     function _safeMint(address to, uint256 tokenId) internal virtual {
818         _safeMint(to, tokenId, "");
819     }
820     function _safeMint(
821         address to,
822         uint256 tokenId,
823         bytes memory _data
824     ) internal virtual {
825         _mint(to, tokenId);
826         require(
827             _checkOnERC721Received(address(0), to, tokenId, _data),
828             "ERC721: transfer to non ERC721Receiver implementer"
829         );
830     }
831     function _mint(address to, uint256 tokenId) internal virtual {
832         require(to != address(0), "ERC721: mint to the zero address");
833         require(!_exists(tokenId), "ERC721: token already minted");
834 
835         _beforeTokenTransfer(address(0), to, tokenId);
836         _owners.push(to);
837 
838         emit Transfer(address(0), to, tokenId);
839     }
840     function _burn(uint256 tokenId) internal virtual {
841         address owner = ERC721P.ownerOf(tokenId);
842 
843         _beforeTokenTransfer(owner, address(0), tokenId);
844 
845         // Clear approvals
846         _approve(address(0), tokenId);
847         _owners[tokenId] = address(0);
848 
849         emit Transfer(owner, address(0), tokenId);
850     }
851     function _transfer(
852         address from,
853         address to,
854         uint256 tokenId
855     ) internal virtual {
856         require(ERC721P.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
857         require(to != address(0), "ERC721: transfer to the zero address");
858 
859         _beforeTokenTransfer(from, to, tokenId);
860 
861         // Clear approvals from the previous owner
862         _approve(address(0), tokenId);
863         _owners[tokenId] = to;
864 
865         emit Transfer(from, to, tokenId);
866     }
867     function _approve(address to, uint256 tokenId) internal virtual {
868         _tokenApprovals[tokenId] = to;
869         emit Approval(ERC721P.ownerOf(tokenId), to, tokenId);
870     }
871     function _checkOnERC721Received(
872         address from,
873         address to,
874         uint256 tokenId,
875         bytes memory _data
876     ) private returns (bool) {
877         if (to.isContract()) {
878             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
879                 return retval == IERC721Receiver.onERC721Received.selector;
880             } catch (bytes memory reason) {
881                 if (reason.length == 0) {
882                     revert("ERC721: transfer to non ERC721Receiver implementer");
883                 } else {
884                     assembly {
885                         revert(add(32, reason), mload(reason))
886                     }
887                 }
888             }
889         } else {
890             return true;
891         }
892     }
893     function _beforeTokenTransfer(
894         address from,
895         address to,
896         uint256 tokenId
897     ) internal virtual {}
898 }
899 
900 pragma solidity ^0.8.10;
901 
902 abstract contract ERC721Enum is ERC721P, IERC721Enumerable {
903     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721P) returns (bool) {
904         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
905     }
906     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256 tokenId) {
907         require(index < ERC721P.balanceOf(owner), "ERC721Enum: owner ioob");
908         uint count;
909         for( uint i; i < _owners.length; ++i ){
910             if( owner == _owners[i] ){
911                 if( count == index )
912                     return i;
913                 else
914                     ++count;
915             }
916         }
917         require(false, "ERC721Enum: owner ioob");
918     }
919     function tokensOfOwner(address owner) public view returns (uint256[] memory) {
920         require(0 < ERC721P.balanceOf(owner), "ERC721Enum: owner ioob");
921         uint256 tokenCount = balanceOf(owner);
922         uint256[] memory tokenIds = new uint256[](tokenCount);
923         for (uint256 i = 0; i < tokenCount; i++) {
924             tokenIds[i] = tokenOfOwnerByIndex(owner, i);
925         }
926         return tokenIds;
927     }
928     function totalSupply() public view virtual override returns (uint256) {
929         return _owners.length;
930     }
931     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
932         require(index < ERC721Enum.totalSupply(), "ERC721Enum: global ioob");
933         return index;
934     }
935 }
936 
937 pragma solidity ^0.8.0;
938 
939 /**
940  * @dev Contract module which allows children to implement an emergency stop
941  * mechanism that can be triggered by an authorized account.
942  *
943  * This module is used through inheritance. It will make available the
944  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
945  * the functions of your contract. Note that they will not be pausable by
946  * simply including this module, only once the modifiers are put in place.
947  */
948 abstract contract Pausable is Context {
949     /**
950      * @dev Emitted when the pause is triggered by `account`.
951      */
952     event Paused(address account);
953 
954     /**
955      * @dev Emitted when the pause is lifted by `account`.
956      */
957     event Unpaused(address account);
958 
959     bool private _paused;
960 
961     /**
962      * @dev Initializes the contract in unpaused state.
963      */
964     constructor() {
965         _paused = false;
966     }
967 
968     /**
969      * @dev Returns true if the contract is paused, and false otherwise.
970      */
971     function paused() public view virtual returns (bool) {
972         return _paused;
973     }
974 
975     /**
976      * @dev Modifier to make a function callable only when the contract is not paused.
977      *
978      * Requirements:
979      *
980      * - The contract must not be paused.
981      */
982     modifier whenNotPaused() {
983         require(!paused(), "Pausable: paused");
984         _;
985     }
986 
987     /**
988      * @dev Modifier to make a function callable only when the contract is paused.
989      *
990      * Requirements:
991      *
992      * - The contract must be paused.
993      */
994     modifier whenPaused() {
995         require(paused(), "Pausable: not paused");
996         _;
997     }
998 
999     /**
1000      * @dev Triggers stopped state.
1001      *
1002      * Requirements:
1003      *
1004      * - The contract must not be paused.
1005      */
1006     function _pause() internal virtual whenNotPaused {
1007         _paused = true;
1008         emit Paused(_msgSender());
1009     }
1010 
1011     /**
1012      * @dev Returns to normal state.
1013      *
1014      * Requirements:
1015      *
1016      * - The contract must be paused.
1017      */
1018     function _unpause() internal virtual whenPaused {
1019         _paused = false;
1020         emit Unpaused(_msgSender());
1021     }
1022 }
1023 
1024 pragma solidity ^0.8.10;
1025 
1026 interface IBloodTokenContract {
1027     function walletsBalances(address wallet) external view returns (uint256);
1028     function spend(address owner, uint256 amount) external;
1029 }
1030 
1031 contract BloodShedBearsTokenGenerator is ERC721Enum, Ownable, Pausable {
1032     using Strings for uint256;
1033 
1034     uint256 constant private maxSupply = 7000;
1035     uint256 private teamReserveAvailableMints = 100;
1036     uint256 private cost = 50000 ether;
1037     address public bloodTokenContract = 0x0000000000000000000000000000000000000000;
1038 
1039     string private baseURI;
1040 
1041     constructor(
1042         string memory _initBaseURI
1043     ) ERC721P("Bloodshed Bears TokenGenerator", "BSBTG") {
1044         setBaseURI(_initBaseURI);
1045         pause();
1046     }
1047 
1048     // internal
1049     function _baseURI() internal view virtual returns (string memory) {
1050         return baseURI;
1051     }
1052 
1053     function setBloodTokenContract(address contractAddress_) external onlyOwner {
1054         bloodTokenContract = contractAddress_;
1055     }
1056 
1057     function setCost(uint256 _newCost) external onlyOwner {
1058         cost = _newCost;
1059     }
1060 
1061     function mint(uint256 mintAmount_) external payable whenNotPaused {
1062         uint256 totalSupply = totalSupply();
1063 
1064         require(totalSupply + mintAmount_ <= maxSupply, "TOO MANY");
1065         require(IBloodTokenContract(bloodTokenContract).walletsBalances(msg.sender) >= mintAmount_ * cost, "NOT ENOUGH");
1066         IBloodTokenContract(bloodTokenContract).spend(msg.sender, mintAmount_ * cost);
1067 
1068         for (uint256 i = 0; i < mintAmount_; i++) {
1069             _safeMint(msg.sender, totalSupply + i);
1070         }
1071 
1072         delete totalSupply;
1073     }
1074 
1075     function tokenURI(uint256 _tokenId) external view virtual override returns (string memory) {
1076         require(_exists(_tokenId), "ERC721Metadata: Nonexistent token");
1077         string memory currentBaseURI = _baseURI();
1078         return bytes(currentBaseURI).length > 0	? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), ".json")) : "";
1079     }
1080 
1081     // admin minting
1082     function reserve(address _to, uint256 _reserveAmount) public onlyOwner {
1083         uint256 supply = totalSupply();
1084         require(
1085             _reserveAmount > 0 && _reserveAmount <= teamReserveAvailableMints,
1086             "Not enough reserve left for team"
1087         );
1088         for (uint256 i = 0; i < _reserveAmount; i++) {
1089             _safeMint(_to, supply + i);
1090         }
1091         teamReserveAvailableMints -= _reserveAmount;
1092     }
1093 
1094     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1095         baseURI = _newBaseURI;
1096     }
1097 
1098     function isOwnerOfBatch(uint256[] calldata tokenIds_, address address_) external view returns (bool) {
1099         bool ownership = true;
1100 
1101         for (uint256 i = 0; i < tokenIds_.length; ++i) {
1102             ownership = ownership && (ownerOf(tokenIds_[i]) == address_);
1103         }
1104 
1105         return ownership;
1106     }
1107 
1108     function pause() public onlyOwner {
1109         _pause();
1110     }
1111 
1112     function unpause() public onlyOwner {
1113         _unpause();
1114     }
1115 }