1 // SPDX-License-Identifier: MIT
2 /*
3 +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +
4 +                                                                                                                          +
5 +                                                                                                                          +
6 +                                                                     iiii  lllllll   1111111   55555555SEASON:TWO         +
7 +                                                                    i::::i l:::::l  1::::::1   5::::::::::::::::5         +
8 +                                                                     iiii  l:::::l 1:::::::1   5::::::::::::::::5         +
9 +                                                                           l:::::l 111:::::1   5:::::555555555555         +
10 +          aaaaaaaaaaaaavvvvvvv           vvvvvvvrrrrr   rrrrrrrrr  iiiiiii  l::::l    1::::1   5:::::5                    +
11 +          a::::::::::::av:::::v         v:::::v r::::rrr:::::::::r i:::::i  l::::l    1::::1   5:::::5                    +
12 +          aaaaaaaaa:::::av:::::v       v:::::v  r:::::::::::::::::r i::::i  l::::l    1::::1   5:::::5555555555           +
13 +                   a::::a v:::::v     v:::::v   rr::::::rrrrr::::::ri::::i  l::::l    1::::l   5:::::::::::::::5          +
14 +            aaaaaaa:::::a  v:::::v   v:::::v     r:::::r     r:::::ri::::i  l::::l    1::::l   555555555555:::::5         +
15 +          aa::::::::::::a   v:::::v v:::::v      r:::::r     rrrrrrri::::i  l::::l    1::::l               5:::::5        +
16 +         a::::aaaa::::::a    v:::::v:::::v       r:::::r            i::::i  l::::l    1::::l               5:::::5        +
17 +        a::::a    a:::::a     v:::::::::v        r:::::r            i::::i  l::::l    1::::l   5555555     5:::::5        +
18 +        a::::a    a:::::a      v:::::::v         r:::::r           i::::::il::::::l111::::::1115::::::55555::::::5        +
19 +        a:::::aaaa::::::a       v:::::v          r:::::r           i::::::il::::::l1::::::::::1 55:::::::::::::55         +
20 +         a::::::::::aa:::a       v:::v           r:::::r           i::::::il::::::l1::::::::::1   55:::::::::55           +
21 +          aaaaaaaaaa  aaaa        vvv            rrrrrrr           SEASON:TWOllllll111111111111     555555555             +
22 +                                                                                                                          +
23 +                                                                                                                          +
24 +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +
25 */
26 
27 // File: @openzeppelin/contracts/utils/Strings.sol
28 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
29 
30 pragma solidity ^0.8.0;
31 
32 /**
33  * @dev String operations.
34  */
35 library Strings {
36     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
37 
38     /**
39      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
40      */
41     function toString(uint256 value) internal pure returns (string memory) {
42         // Inspired by OraclizeAPI's implementation - MIT licence
43         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
44 
45         if (value == 0) {
46             return "0";
47         }
48         uint256 temp = value;
49         uint256 digits;
50         while (temp != 0) {
51             digits++;
52             temp /= 10;
53         }
54         bytes memory buffer = new bytes(digits);
55         while (value != 0) {
56             digits -= 1;
57             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
58             value /= 10;
59         }
60         return string(buffer);
61     }
62 
63     /**
64      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
65      */
66     function toHexString(uint256 value) internal pure returns (string memory) {
67         if (value == 0) {
68             return "0x00";
69         }
70         uint256 temp = value;
71         uint256 length = 0;
72         while (temp != 0) {
73             length++;
74             temp >>= 8;
75         }
76         return toHexString(value, length);
77     }
78 
79     /**
80      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
81      */
82     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
83         bytes memory buffer = new bytes(2 * length + 2);
84         buffer[0] = "0";
85         buffer[1] = "x";
86         for (uint256 i = 2 * length + 1; i > 1; --i) {
87             buffer[i] = _HEX_SYMBOLS[value & 0xf];
88             value >>= 4;
89         }
90         require(value == 0, "Strings: hex length insufficient");
91         return string(buffer);
92     }
93 }
94 
95 // File: @openzeppelin/contracts/utils/Context.sol
96 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
97 pragma solidity ^0.8.0;
98 /**
99  * @dev Provides information about the current execution context, including the
100  * sender of the transaction and its data. While these are generally available
101  * via msg.sender and msg.data, they should not be accessed in such a direct
102  * manner, since when dealing with meta-transactions the account sending and
103  * paying for execution may not be the actual sender (as far as an application
104  * is concerned).
105  *
106  * This contract is only required for intermediate, library-like contracts.
107  */
108 abstract contract Context {
109     function _msgSender() internal view virtual returns (address) {
110         return msg.sender;
111     }
112 
113     function _msgData() internal view virtual returns (bytes calldata) {
114         return msg.data;
115     }
116 }
117 
118 // File: @openzeppelin/contracts/access/Ownable.sol
119 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
120 pragma solidity ^0.8.0;
121 /**
122  * @dev Contract module which provides a basic access control mechanism, where
123  * there is an account (an owner) that can be granted exclusive access to
124  * specific functions.
125  *
126  * By default, the owner account will be the one that deploys the contract. This
127  * can later be changed with {transferOwnership}.
128  *
129  * This module is used through inheritance. It will make available the modifier
130  * `onlyOwner`, which can be applied to your functions to restrict their use to
131  * the owner.
132  */
133 abstract contract Ownable is Context {
134     address private _owner;
135 
136     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
137 
138     /**
139      * @dev Initializes the contract setting the deployer as the initial owner.
140      */
141     constructor() {
142         _transferOwnership(_msgSender());
143     }
144 
145     /**
146      * @dev Returns the address of the current owner.
147      */
148     function owner() public view virtual returns (address) {
149         return _owner;
150     }
151 
152     /**
153      * @dev Throws if called by any account other than the owner.
154      */
155     modifier onlyOwner() {
156         require(owner() == _msgSender(), "Ownable: caller is not the owner");
157         _;
158     }
159 
160     /**
161      * @dev Leaves the contract without owner. It will not be possible to call
162      * `onlyOwner` functions anymore. Can only be called by the current owner.
163      *
164      * NOTE: Renouncing ownership will leave the contract without an owner,
165      * thereby removing any functionality that is only available to the owner.
166      */
167     function renounceOwnership() public virtual onlyOwner {
168         _transferOwnership(address(0));
169     }
170 
171     /**
172      * @dev Transfers ownership of the contract to a new account (`newOwner`).
173      * Can only be called by the current owner.
174      */
175     function transferOwnership(address newOwner) public virtual onlyOwner {
176         require(newOwner != address(0), "Ownable: new owner is the zero address");
177         _transferOwnership(newOwner);
178     }
179 
180     /**
181      * @dev Transfers ownership of the contract to a new account (`newOwner`).
182      * Internal function without access restriction.
183      */
184     function _transferOwnership(address newOwner) internal virtual {
185         address oldOwner = _owner;
186         _owner = newOwner;
187         emit OwnershipTransferred(oldOwner, newOwner);
188     }
189 }
190 
191 // File: @openzeppelin/contracts/utils/Address.sol
192 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
193 pragma solidity ^0.8.1;
194 /**
195  * @dev Collection of functions related to the address type
196  */
197 library Address {
198     /**
199      * @dev Returns true if `account` is a contract.
200      *
201      * [IMPORTANT]
202      * ====
203      * It is unsafe to assume that an address for which this function returns
204      * false is an externally-owned account (EOA) and not a contract.
205      *
206      * Among others, `isContract` will return false for the following
207      * types of addresses:
208      *
209      *  - an externally-owned account
210      *  - a contract in construction
211      *  - an address where a contract will be created
212      *  - an address where a contract lived, but was destroyed
213      * ====
214      *
215      * [IMPORTANT]
216      * ====
217      * You shouldn't rely on `isContract` to protect against flash loan attacks!
218      *
219      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
220      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
221      * constructor.
222      * ====
223      */
224     function isContract(address account) internal view returns (bool) {
225         // This method relies on extcodesize/address.code.length, which returns 0
226         // for contracts in construction, since the code is only stored at the end
227         // of the constructor execution.
228 
229         return account.code.length > 0;
230     }
231 
232     /**
233      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
234      * `recipient`, forwarding all available gas and reverting on errors.
235      *
236      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
237      * of certain opcodes, possibly making contracts go over the 2300 gas limit
238      * imposed by `transfer`, making them unable to receive funds via
239      * `transfer`. {sendValue} removes this limitation.
240      *
241      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
242      *
243      * IMPORTANT: because control is transferred to `recipient`, care must be
244      * taken to not create reentrancy vulnerabilities. Consider using
245      * {ReentrancyGuard} or the
246      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
247      */
248     function sendValue(address payable recipient, uint256 amount) internal {
249         require(address(this).balance >= amount, "Address: insufficient balance");
250 
251         (bool success, ) = recipient.call{value: amount}("");
252         require(success, "Address: unable to send value, recipient may have reverted");
253     }
254 
255     /**
256      * @dev Performs a Solidity function call using a low level `call`. A
257      * plain `call` is an unsafe replacement for a function call: use this
258      * function instead.
259      *
260      * If `target` reverts with a revert reason, it is bubbled up by this
261      * function (like regular Solidity function calls).
262      *
263      * Returns the raw returned data. To convert to the expected return value,
264      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
265      *
266      * Requirements:
267      *
268      * - `target` must be a contract.
269      * - calling `target` with `data` must not revert.
270      *
271      * _Available since v3.1._
272      */
273     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
274         return functionCall(target, data, "Address: low-level call failed");
275     }
276 
277     /**
278      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
279      * `errorMessage` as a fallback revert reason when `target` reverts.
280      *
281      * _Available since v3.1._
282      */
283     function functionCall(
284         address target,
285         bytes memory data,
286         string memory errorMessage
287     ) internal returns (bytes memory) {
288         return functionCallWithValue(target, data, 0, errorMessage);
289     }
290 
291     /**
292      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
293      * but also transferring `value` wei to `target`.
294      *
295      * Requirements:
296      *
297      * - the calling contract must have an ETH balance of at least `value`.
298      * - the called Solidity function must be `payable`.
299      *
300      * _Available since v3.1._
301      */
302     function functionCallWithValue(
303         address target,
304         bytes memory data,
305         uint256 value
306     ) internal returns (bytes memory) {
307         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
308     }
309 
310     /**
311      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
312      * with `errorMessage` as a fallback revert reason when `target` reverts.
313      *
314      * _Available since v3.1._
315      */
316     function functionCallWithValue(
317         address target,
318         bytes memory data,
319         uint256 value,
320         string memory errorMessage
321     ) internal returns (bytes memory) {
322         require(address(this).balance >= value, "Address: insufficient balance for call");
323         require(isContract(target), "Address: call to non-contract");
324 
325         (bool success, bytes memory returndata) = target.call{value: value}(data);
326         return verifyCallResult(success, returndata, errorMessage);
327     }
328 
329     /**
330      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
331      * but performing a static call.
332      *
333      * _Available since v3.3._
334      */
335     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
336         return functionStaticCall(target, data, "Address: low-level static call failed");
337     }
338 
339     /**
340      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
341      * but performing a static call.
342      *
343      * _Available since v3.3._
344      */
345     function functionStaticCall(
346         address target,
347         bytes memory data,
348         string memory errorMessage
349     ) internal view returns (bytes memory) {
350         require(isContract(target), "Address: static call to non-contract");
351 
352         (bool success, bytes memory returndata) = target.staticcall(data);
353         return verifyCallResult(success, returndata, errorMessage);
354     }
355 
356     /**
357      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
358      * but performing a delegate call.
359      *
360      * _Available since v3.4._
361      */
362     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
363         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
364     }
365 
366     /**
367      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
368      * but performing a delegate call.
369      *
370      * _Available since v3.4._
371      */
372     function functionDelegateCall(
373         address target,
374         bytes memory data,
375         string memory errorMessage
376     ) internal returns (bytes memory) {
377         require(isContract(target), "Address: delegate call to non-contract");
378 
379         (bool success, bytes memory returndata) = target.delegatecall(data);
380         return verifyCallResult(success, returndata, errorMessage);
381     }
382 
383     /**
384      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
385      * revert reason using the provided one.
386      *
387      * _Available since v4.3._
388      */
389     function verifyCallResult(
390         bool success,
391         bytes memory returndata,
392         string memory errorMessage
393     ) internal pure returns (bytes memory) {
394         if (success) {
395             return returndata;
396         } else {
397             // Look for revert reason and bubble it up if present
398             if (returndata.length > 0) {
399                 // The easiest way to bubble the revert reason is using memory via assembly
400 
401                 assembly {
402                     let returndata_size := mload(returndata)
403                     revert(add(32, returndata), returndata_size)
404                 }
405             } else {
406                 revert(errorMessage);
407             }
408         }
409     }
410 }
411 
412 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
413 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
414 pragma solidity ^0.8.0;
415 /**
416  * @title ERC721 token receiver interface
417  * @dev Interface for any contract that wants to support safeTransfers
418  * from ERC721 asset contracts.
419  */
420 interface IERC721Receiver {
421     /**
422      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
423      * by `operator` from `from`, this function is called.
424      *
425      * It must return its Solidity selector to confirm the token transfer.
426      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
427      *
428      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
429      */
430     function onERC721Received(
431         address operator,
432         address from,
433         uint256 tokenId,
434         bytes calldata data
435     ) external returns (bytes4);
436 }
437 
438 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
439 
440 
441 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
442 
443 pragma solidity ^0.8.0;
444 
445 /**
446  * @dev Interface of the ERC165 standard, as defined in the
447  * https://eips.ethereum.org/EIPS/eip-165[EIP].
448  *
449  * Implementers can declare support of contract interfaces, which can then be
450  * queried by others ({ERC165Checker}).
451  *
452  * For an implementation, see {ERC165}.
453  */
454 interface IERC165 {
455     /**
456      * @dev Returns true if this contract implements the interface defined by
457      * `interfaceId`. See the corresponding
458      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
459      * to learn more about how these ids are created.
460      *
461      * This function call must use less than 30 000 gas.
462      */
463     function supportsInterface(bytes4 interfaceId) external view returns (bool);
464 }
465 
466 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
467 
468 
469 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
470 
471 pragma solidity ^0.8.0;
472 
473 
474 /**
475  * @dev Implementation of the {IERC165} interface.
476  *
477  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
478  * for the additional interface id that will be supported. For example:
479  *
480  * ```solidity
481  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
482  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
483  * }
484  * ```
485  *
486  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
487  */
488 abstract contract ERC165 is IERC165 {
489     /**
490      * @dev See {IERC165-supportsInterface}.
491      */
492     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
493         return interfaceId == type(IERC165).interfaceId;
494     }
495 }
496 
497 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
498 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
499 pragma solidity ^0.8.0;
500 /**
501  * @dev Required interface of an ERC721 compliant contract.
502  */
503 interface IERC721 is IERC165 {
504     /**
505      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
506      */
507     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
508 
509     /**
510      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
511      */
512     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
513 
514     /**
515      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
516      */
517     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
518 
519     /**
520      * @dev Returns the number of tokens in ``owner``'s account.
521      */
522     function balanceOf(address owner) external view returns (uint256 balance);
523 
524     /**
525      * @dev Returns the owner of the `tokenId` token.
526      *
527      * Requirements:
528      *
529      * - `tokenId` must exist.
530      */
531     function ownerOf(uint256 tokenId) external view returns (address owner);
532 
533     /**
534      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
535      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
536      *
537      * Requirements:
538      *
539      * - `from` cannot be the zero address.
540      * - `to` cannot be the zero address.
541      * - `tokenId` token must exist and be owned by `from`.
542      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
543      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
544      *
545      * Emits a {Transfer} event.
546      */
547     function safeTransferFrom(
548         address from,
549         address to,
550         uint256 tokenId
551     ) external;
552 
553     /**
554      * @dev Transfers `tokenId` token from `from` to `to`.
555      *
556      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
557      *
558      * Requirements:
559      *
560      * - `from` cannot be the zero address.
561      * - `to` cannot be the zero address.
562      * - `tokenId` token must be owned by `from`.
563      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
564      *
565      * Emits a {Transfer} event.
566      */
567     function transferFrom(
568         address from,
569         address to,
570         uint256 tokenId
571     ) external;
572 
573     /**
574      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
575      * The approval is cleared when the token is transferred.
576      *
577      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
578      *
579      * Requirements:
580      *
581      * - The caller must own the token or be an approved operator.
582      * - `tokenId` must exist.
583      *
584      * Emits an {Approval} event.
585      */
586     function approve(address to, uint256 tokenId) external;
587 
588     /**
589      * @dev Returns the account approved for `tokenId` token.
590      *
591      * Requirements:
592      *
593      * - `tokenId` must exist.
594      */
595     function getApproved(uint256 tokenId) external view returns (address operator);
596 
597     /**
598      * @dev Approve or remove `operator` as an operator for the caller.
599      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
600      *
601      * Requirements:
602      *
603      * - The `operator` cannot be the caller.
604      *
605      * Emits an {ApprovalForAll} event.
606      */
607     function setApprovalForAll(address operator, bool _approved) external;
608 
609     /**
610      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
611      *
612      * See {setApprovalForAll}
613      */
614     function isApprovedForAll(address owner, address operator) external view returns (bool);
615 
616     /**
617      * @dev Safely transfers `tokenId` token from `from` to `to`.
618      *
619      * Requirements:
620      *
621      * - `from` cannot be the zero address.
622      * - `to` cannot be the zero address.
623      * - `tokenId` token must exist and be owned by `from`.
624      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
625      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
626      *
627      * Emits a {Transfer} event.
628      */
629     function safeTransferFrom(
630         address from,
631         address to,
632         uint256 tokenId,
633         bytes calldata data
634     ) external;
635 }
636 
637 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
638 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
639 
640 pragma solidity ^0.8.0;
641 /**
642  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
643  * @dev See https://eips.ethereum.org/EIPS/eip-721
644  */
645 interface IERC721Metadata is IERC721 {
646     /**
647      * @dev Returns the token collection name.
648      */
649     function name() external view returns (string memory);
650 
651     /**
652      * @dev Returns the token collection symbol.
653      */
654     function symbol() external view returns (string memory);
655 
656     /**
657      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
658      */
659     function tokenURI(uint256 tokenId) external view returns (string memory);
660 }
661 
662 // File: erc721a/contracts/ERC721A.sol
663 // Creator: Chiru Labs
664 pragma solidity ^0.8.4;
665 
666 error ApprovalCallerNotOwnerNorApproved();
667 error ApprovalQueryForNonexistentToken();
668 error ApproveToCaller();
669 error ApprovalToCurrentOwner();
670 error BalanceQueryForZeroAddress();
671 error MintToZeroAddress();
672 error MintZeroQuantity();
673 error OwnerQueryForNonexistentToken();
674 error TransferCallerNotOwnerNorApproved();
675 error TransferFromIncorrectOwner();
676 error TransferToNonERC721ReceiverImplementer();
677 error TransferToZeroAddress();
678 error URIQueryForNonexistentToken();
679 
680 /**
681  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
682  * the Metadata extension. Built to optimize for lower gas during batch mints.
683  *
684  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
685  *
686  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
687  *
688  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
689  */
690 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
691 	using Address for address;
692 	using Strings for uint256;
693 
694 	// Compiler will pack this into a single 256bit word.
695 	struct TokenOwnership {
696 		// The address of the owner.
697 		address addr;
698 		// Keeps track of the start time of ownership with minimal overhead for tokenomics.
699 		uint64 startTimestamp;
700 		// Whether the token has been burned.
701 		bool burned;
702 	}
703 
704 	// Compiler will pack this into a single 256bit word.
705 	struct AddressData {
706 		// Realistically, 2**64-1 is more than enough.
707 		uint64 balance;
708 		// Keeps track of mint count with minimal overhead for tokenomics.
709 		uint64 numberMinted;
710 		// Keeps track of burn count with minimal overhead for tokenomics.
711 		uint64 numberBurned;
712 		// For miscellaneous variable(s) pertaining to the address
713 		// (e.g. number of whitelist mint slots used).
714 		// If there are multiple variables, please pack them into a uint64.
715 		uint64 aux;
716 	}
717 
718 	// The tokenId of the next token to be minted.
719 	uint256 internal _currentIndex;
720 
721 	// The number of tokens burned.
722 	uint256 internal _burnCounter;
723 
724 	// Token name
725 	string private _name;
726 
727 	// Token symbol
728 	string private _symbol;
729 
730 	// Mapping from token ID to ownership details
731 	// An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
732 	mapping(uint256 => TokenOwnership) internal _ownerships;
733 
734 	// Mapping owner address to address data
735 	mapping(address => AddressData) private _addressData;
736 
737 	// Mapping from token ID to approved address
738 	mapping(uint256 => address) private _tokenApprovals;
739 
740 	// Mapping from owner to operator approvals
741 	mapping(address => mapping(address => bool)) private _operatorApprovals;
742 
743 	constructor(string memory name_, string memory symbol_) {
744 		_name = name_;
745 		_symbol = symbol_;
746 		_currentIndex = _startTokenId();
747 	}
748 
749 	/**
750 	 * To change the starting tokenId, please override this function.
751 	 */
752 	function _startTokenId() internal view virtual returns (uint256) {
753 		return 1;
754 	}
755 
756 	/**
757 	 * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
758 	 */
759 	function totalSupply() public view returns (uint256) {
760 		// Counter underflow is impossible as _burnCounter cannot be incremented
761 		// more than _currentIndex - _startTokenId() times
762 		unchecked {
763 			return _currentIndex - _burnCounter - _startTokenId();
764 		}
765 	}
766 
767 	/**
768 	 * Returns the total amount of tokens minted in the contract.
769 	 */
770 	function _totalMinted() internal view returns (uint256) {
771 		// Counter underflow is impossible as _currentIndex does not decrement,
772 		// and it is initialized to _startTokenId()
773 		unchecked {
774 			return _currentIndex - _startTokenId();
775 		}
776 	}
777 
778 	/**
779 	 * @dev See {IERC165-supportsInterface}.
780 	 */
781 	function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
782 		return
783 			interfaceId == type(IERC721).interfaceId ||
784 			interfaceId == type(IERC721Metadata).interfaceId ||
785 			super.supportsInterface(interfaceId);
786 	}
787 
788 	/**
789 	 * @dev See {IERC721-balanceOf}.
790 	 */
791 	function balanceOf(address owner) public view override returns (uint256) {
792 		if (owner == address(0)) revert BalanceQueryForZeroAddress();
793 		return uint256(_addressData[owner].balance);
794 	}
795 
796 	/**
797 	 * Returns the number of tokens minted by `owner`.
798 	 */
799 	function _numberMinted(address owner) internal view returns (uint256) {
800 		return uint256(_addressData[owner].numberMinted);
801 	}
802 
803 	/**
804 	 * Returns the number of tokens burned by or on behalf of `owner`.
805 	 */
806 	function _numberBurned(address owner) internal view returns (uint256) {
807 		return uint256(_addressData[owner].numberBurned);
808 	}
809 
810 	/**
811 	 * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
812 	 */
813 	function _getAux(address owner) internal view returns (uint64) {
814 		return _addressData[owner].aux;
815 	}
816 
817 	/**
818 	 * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
819 	 * If there are multiple variables, please pack them into a uint64.
820 	 */
821 	function _setAux(address owner, uint64 aux) internal {
822 		_addressData[owner].aux = aux;
823 	}
824 
825 	/**
826 	 * Gas spent here starts off proportional to the maximum mint batch size.
827 	 * It gradually moves to O(1) as tokens get transferred around in the collection over time.
828 	 */
829 	function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
830 		uint256 curr = tokenId;
831 
832 		unchecked {
833 			if (_startTokenId() <= curr && curr < _currentIndex) {
834 				TokenOwnership memory ownership = _ownerships[curr];
835 				if (!ownership.burned) {
836 					if (ownership.addr != address(0)) {
837 						return ownership;
838 					}
839 					// Invariant:
840 					// There will always be an ownership that has an address and is not burned
841 					// before an ownership that does not have an address and is not burned.
842 					// Hence, curr will not underflow.
843 					while (true) {
844 						curr--;
845 						ownership = _ownerships[curr];
846 						if (ownership.addr != address(0)) {
847 							return ownership;
848 						}
849 					}
850 				}
851 			}
852 		}
853 		revert OwnerQueryForNonexistentToken();
854 	}
855 
856 	/**
857 	 * @dev See {IERC721-ownerOf}.
858 	 */
859 	function ownerOf(uint256 tokenId) public view override returns (address) {
860 		return _ownershipOf(tokenId).addr;
861 	}
862 
863 	/**
864 	 * @dev See {IERC721Metadata-name}.
865 	 */
866 	function name() public view virtual override returns (string memory) {
867 		return _name;
868 	}
869 
870 	/**
871 	 * @dev See {IERC721Metadata-symbol}.
872 	 */
873 	function symbol() public view virtual override returns (string memory) {
874 		return _symbol;
875 	}
876 
877 	/**
878 	 * @dev See {IERC721Metadata-tokenURI}.
879 	 */
880 	function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
881 		if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
882 
883 		string memory baseURI = _baseURI();
884 		return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
885 	}
886 
887 	/**
888 	 * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
889 	 * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
890 	 * by default, can be overriden in child contracts.
891 	 */
892 	function _baseURI() internal view virtual returns (string memory) {
893 		return '';
894 	}
895 
896 	/**
897 	 * @dev See {IERC721-approve}.
898 	 */
899 	function approve(address to, uint256 tokenId) public override {
900 		address owner = ERC721A.ownerOf(tokenId);
901 		if (to == owner) revert ApprovalToCurrentOwner();
902 
903 		if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
904 			revert ApprovalCallerNotOwnerNorApproved();
905 		}
906 
907 		_approve(to, tokenId, owner);
908 	}
909 
910 	/**
911 	 * @dev See {IERC721-getApproved}.
912 	 */
913 	function getApproved(uint256 tokenId) public view override returns (address) {
914 		if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
915 
916 		return _tokenApprovals[tokenId];
917 	}
918 
919 	/**
920 	 * @dev See {IERC721-setApprovalForAll}.
921 	 */
922 	function setApprovalForAll(address operator, bool approved) public virtual override {
923 		if (operator == _msgSender()) revert ApproveToCaller();
924 
925 		_operatorApprovals[_msgSender()][operator] = approved;
926 		emit ApprovalForAll(_msgSender(), operator, approved);
927 	}
928 
929 	/**
930 	 * @dev See {IERC721-isApprovedForAll}.
931 	 */
932 	function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
933 		return _operatorApprovals[owner][operator];
934 	}
935 
936 	/**
937 	 * @dev See {IERC721-transferFrom}.
938 	 */
939 	function transferFrom(
940 		address from,
941 		address to,
942 		uint256 tokenId
943 	) public virtual override {
944 		_transfer(from, to, tokenId);
945 	}
946 
947 	/**
948 	 * @dev See {IERC721-safeTransferFrom}.
949 	 */
950 	function safeTransferFrom(
951 		address from,
952 		address to,
953 		uint256 tokenId
954 	) public virtual override {
955 		safeTransferFrom(from, to, tokenId, '');
956 	}
957 
958 	/**
959 	 * @dev See {IERC721-safeTransferFrom}.
960 	 */
961 	function safeTransferFrom(
962 		address from,
963 		address to,
964 		uint256 tokenId,
965 		bytes memory _data
966 	) public virtual override {
967 		_transfer(from, to, tokenId);
968 		if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
969 			revert TransferToNonERC721ReceiverImplementer();
970 		}
971 	}
972 
973 	/**
974 	 * @dev Returns whether `tokenId` exists.
975 	 *
976 	 * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
977 	 *
978 	 * Tokens start existing when they are minted (`_mint`),
979 	 */
980 	function _exists(uint256 tokenId) internal view returns (bool) {
981 		return _startTokenId() <= tokenId && tokenId < _currentIndex &&
982 			!_ownerships[tokenId].burned;
983 	}
984 
985 	function _safeMint(address to, uint256 quantity) internal {
986 		_safeMint(to, quantity, '');
987 	}
988 
989 	/**
990 	 * @dev Safely mints `quantity` tokens and transfers them to `to`.
991 	 *
992 	 * Requirements:
993 	 *
994 	 * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
995 	 * - `quantity` must be greater than 0.
996 	 *
997 	 * Emits a {Transfer} event.
998 	 */
999 	function _safeMint(
1000 		address to,
1001 		uint256 quantity,
1002 		bytes memory _data
1003 	) internal {
1004 		_mint(to, quantity, _data, true);
1005 	}
1006 
1007 	/**
1008 	 * @dev Mints `quantity` tokens and transfers them to `to`.
1009 	 *
1010 	 * Requirements:
1011 	 *
1012 	 * - `to` cannot be the zero address.
1013 	 * - `quantity` must be greater than 0.
1014 	 *
1015 	 * Emits a {Transfer} event.
1016 	 */
1017 	function _mint(
1018 		address to,
1019 		uint256 quantity,
1020 		bytes memory _data,
1021 		bool safe
1022 	) internal {
1023 		uint256 startTokenId = _currentIndex;
1024 		if (to == address(0)) revert MintToZeroAddress();
1025 		if (quantity == 0) revert MintZeroQuantity();
1026 
1027 		_beforeTokenTransfers(address(0), to, startTokenId, quantity);
1028 
1029 		// Overflows are incredibly unrealistic.
1030 		// balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1031 		// updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1032 		unchecked {
1033 			_addressData[to].balance += uint64(quantity);
1034 			_addressData[to].numberMinted += uint64(quantity);
1035 
1036 			_ownerships[startTokenId].addr = to;
1037 			_ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1038 
1039 			uint256 updatedIndex = startTokenId;
1040 			uint256 end = updatedIndex + quantity;
1041 
1042 			if (safe && to.isContract()) {
1043 				do {
1044 					emit Transfer(address(0), to, updatedIndex);
1045 					if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1046 						revert TransferToNonERC721ReceiverImplementer();
1047 					}
1048 				} while (updatedIndex != end);
1049 				// Reentrancy protection
1050 				if (_currentIndex != startTokenId) revert();
1051 			} else {
1052 				do {
1053 					emit Transfer(address(0), to, updatedIndex++);
1054 				} while (updatedIndex != end);
1055 			}
1056 			_currentIndex = updatedIndex;
1057 		}
1058 		_afterTokenTransfers(address(0), to, startTokenId, quantity);
1059 	}
1060 
1061 	/**
1062 	 * @dev Transfers `tokenId` from `from` to `to`.
1063 	 *
1064 	 * Requirements:
1065 	 *
1066 	 * - `to` cannot be the zero address.
1067 	 * - `tokenId` token must be owned by `from`.
1068 	 *
1069 	 * Emits a {Transfer} event.
1070 	 */
1071 	function _transfer(
1072 		address from,
1073 		address to,
1074 		uint256 tokenId
1075 	) private {
1076 		TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1077 
1078 		if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1079 
1080 		bool isApprovedOrOwner = (_msgSender() == from ||
1081 			isApprovedForAll(from, _msgSender()) ||
1082 			getApproved(tokenId) == _msgSender());
1083 
1084 		if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1085 		if (to == address(0)) revert TransferToZeroAddress();
1086 
1087 		_beforeTokenTransfers(from, to, tokenId, 1);
1088 
1089 		// Clear approvals from the previous owner
1090 		_approve(address(0), tokenId, from);
1091 
1092 		// Underflow of the sender's balance is impossible because we check for
1093 		// ownership above and the recipient's balance can't realistically overflow.
1094 		// Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1095 		unchecked {
1096 			_addressData[from].balance -= 1;
1097 			_addressData[to].balance += 1;
1098 
1099 			TokenOwnership storage currSlot = _ownerships[tokenId];
1100 			currSlot.addr = to;
1101 			currSlot.startTimestamp = uint64(block.timestamp);
1102 
1103 			// If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1104 			// Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1105 			uint256 nextTokenId = tokenId + 1;
1106 			TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1107 			if (nextSlot.addr == address(0)) {
1108 				// This will suffice for checking _exists(nextTokenId),
1109 				// as a burned slot cannot contain the zero address.
1110 				if (nextTokenId != _currentIndex) {
1111 					nextSlot.addr = from;
1112 					nextSlot.startTimestamp = prevOwnership.startTimestamp;
1113 				}
1114 			}
1115 		}
1116 
1117 		emit Transfer(from, to, tokenId);
1118 		_afterTokenTransfers(from, to, tokenId, 1);
1119 	}
1120 
1121 	/**
1122 	 * @dev This is equivalent to _burn(tokenId, false)
1123 	 */
1124 	function _burn(uint256 tokenId) internal virtual {
1125 		_burn(tokenId, false);
1126 	}
1127 
1128 	/**
1129 	 * @dev Destroys `tokenId`.
1130 	 * The approval is cleared when the token is burned.
1131 	 *
1132 	 * Requirements:
1133 	 *
1134 	 * - `tokenId` must exist.
1135 	 *
1136 	 * Emits a {Transfer} event.
1137 	 */
1138 	function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1139 		TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1140 
1141 		address from = prevOwnership.addr;
1142 
1143 		if (approvalCheck) {
1144 			bool isApprovedOrOwner = (_msgSender() == from ||
1145 				isApprovedForAll(from, _msgSender()) ||
1146 				getApproved(tokenId) == _msgSender());
1147 
1148 			if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1149 		}
1150 
1151 		_beforeTokenTransfers(from, address(0), tokenId, 1);
1152 
1153 		// Clear approvals from the previous owner
1154 		_approve(address(0), tokenId, from);
1155 
1156 		// Underflow of the sender's balance is impossible because we check for
1157 		// ownership above and the recipient's balance can't realistically overflow.
1158 		// Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1159 		unchecked {
1160 			AddressData storage addressData = _addressData[from];
1161 			addressData.balance -= 1;
1162 			addressData.numberBurned += 1;
1163 
1164 			// Keep track of who burned the token, and the timestamp of burning.
1165 			TokenOwnership storage currSlot = _ownerships[tokenId];
1166 			currSlot.addr = from;
1167 			currSlot.startTimestamp = uint64(block.timestamp);
1168 			currSlot.burned = true;
1169 
1170 			// If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1171 			// Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1172 			uint256 nextTokenId = tokenId + 1;
1173 			TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1174 			if (nextSlot.addr == address(0)) {
1175 				// This will suffice for checking _exists(nextTokenId),
1176 				// as a burned slot cannot contain the zero address.
1177 				if (nextTokenId != _currentIndex) {
1178 					nextSlot.addr = from;
1179 					nextSlot.startTimestamp = prevOwnership.startTimestamp;
1180 				}
1181 			}
1182 		}
1183 
1184 		emit Transfer(from, address(0), tokenId);
1185 		_afterTokenTransfers(from, address(0), tokenId, 1);
1186 
1187 		// Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1188 		unchecked {
1189 			_burnCounter++;
1190 		}
1191 	}
1192 
1193 	/**
1194 	 * @dev Approve `to` to operate on `tokenId`
1195 	 *
1196 	 * Emits a {Approval} event.
1197 	 */
1198 	function _approve(
1199 		address to,
1200 		uint256 tokenId,
1201 		address owner
1202 	) private {
1203 		_tokenApprovals[tokenId] = to;
1204 		emit Approval(owner, to, tokenId);
1205 	}
1206 
1207 	/**
1208 	 * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1209 	 *
1210 	 * @param from address representing the previous owner of the given token ID
1211 	 * @param to target address that will receive the tokens
1212 	 * @param tokenId uint256 ID of the token to be transferred
1213 	 * @param _data bytes optional data to send along with the call
1214 	 * @return bool whether the call correctly returned the expected magic value
1215 	 */
1216 	function _checkContractOnERC721Received(
1217 		address from,
1218 		address to,
1219 		uint256 tokenId,
1220 		bytes memory _data
1221 	) private returns (bool) {
1222 		try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1223 			return retval == IERC721Receiver(to).onERC721Received.selector;
1224 		} catch (bytes memory reason) {
1225 			if (reason.length == 0) {
1226 				revert TransferToNonERC721ReceiverImplementer();
1227 			} else {
1228 				assembly {
1229 					revert(add(32, reason), mload(reason))
1230 				}
1231 			}
1232 		}
1233 	}
1234 
1235 	/**
1236 	 * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1237 	 * And also called before burning one token.
1238 	 *
1239 	 * startTokenId - the first token id to be transferred
1240 	 * quantity - the amount to be transferred
1241 	 *
1242 	 * Calling conditions:
1243 	 *
1244 	 * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1245 	 * transferred to `to`.
1246 	 * - When `from` is zero, `tokenId` will be minted for `to`.
1247 	 * - When `to` is zero, `tokenId` will be burned by `from`.
1248 	 * - `from` and `to` are never both zero.
1249 	 */
1250 	function _beforeTokenTransfers(
1251 		address from,
1252 		address to,
1253 		uint256 startTokenId,
1254 		uint256 quantity
1255 	) internal virtual {}
1256 
1257 	/**
1258 	 * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1259 	 * minting.
1260 	 * And also called after one token has been burned.
1261 	 *
1262 	 * startTokenId - the first token id to be transferred
1263 	 * quantity - the amount to be transferred
1264 	 *
1265 	 * Calling conditions:
1266 	 *
1267 	 * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1268 	 * transferred to `to`.
1269 	 * - When `from` is zero, `tokenId` has been minted for `to`.
1270 	 * - When `to` is zero, `tokenId` has been burned by `from`.
1271 	 * - `from` and `to` are never both zero.
1272 	 */
1273 	function _afterTokenTransfers(
1274 		address from,
1275 		address to,
1276 		uint256 startTokenId,
1277 		uint256 quantity
1278 	) internal virtual {}
1279 }
1280 
1281 // File: avril15_s1.sol
1282 pragma solidity ^0.8.4;
1283 
1284 contract Avril15_SeasonTwo is ERC721A, Ownable {
1285 	uint256 maxSupply = 360;
1286 
1287 	string public baseURI = "ipfs://QmTCsiZXQFxXLjW6Q7XjSLdFRoS392EMWzpq985NGcJsFa/";
1288 	bool public revealed = true;
1289 	bool public _frozenMeta;
1290 
1291 	constructor() ERC721A("Avril15 Season Two", "AVRIL15_S2") {
1292 		_frozenMeta = false;
1293 	}
1294 
1295 	// WARNING! This function allows the owner of the contract to PERMANENTLY freeze the metadata.
1296 	function freezeMetadata() public onlyOwner {
1297         _frozenMeta = true;
1298     }
1299 
1300 	function ownerMint(uint256 quantity) external payable onlyOwner {
1301 		require(totalSupply() + quantity <= maxSupply, "Exceeded maxSupply of 360.");
1302 		_safeMint(msg.sender, quantity);
1303 	}
1304 
1305     function _baseURI() internal view override returns (string memory) {
1306 		return baseURI;
1307 	}
1308 
1309 	function changeBaseURI(string memory baseURI_) public onlyOwner {
1310 		require(!_frozenMeta, "Uri frozen");
1311 		baseURI = baseURI_;
1312 	}
1313 
1314     function changeRevealed(bool _revealed) public onlyOwner {
1315         revealed = _revealed;
1316     }
1317 
1318 	function tokenURI(uint256 tokenId) public view override returns (string memory) {
1319 		require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1320 
1321 		string memory baseURI_ = _baseURI();
1322 
1323 		if (revealed) {
1324 			return bytes(baseURI_).length > 0 ? string(abi.encodePacked(baseURI_, Strings.toString(tokenId), ".json")) : "";
1325 		} else {
1326 			return string(abi.encodePacked(baseURI_, "prereveal.json"));
1327 		}
1328 		
1329 	}
1330 }