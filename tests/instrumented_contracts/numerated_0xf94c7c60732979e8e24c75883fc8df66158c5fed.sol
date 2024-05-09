1 // SPDX-License-Identifier: MIT
2 
3 /*
4 +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +
5 +                                                                                                                          +
6 +                                                                                                                          +
7 +                                                                     iiii  lllllll   1111111   55555555SEASON:ONE         +
8 +                                                                    i::::i l:::::l  1::::::1   5::::::::::::::::5         +
9 +                                                                     iiii  l:::::l 1:::::::1   5::::::::::::::::5         +
10 +                                                                           l:::::l 111:::::1   5:::::555555555555         +
11 +          aaaaaaaaaaaaavvvvvvv           vvvvvvvrrrrr   rrrrrrrrr  iiiiiii  l::::l    1::::1   5:::::5                    +
12 +          a::::::::::::av:::::v         v:::::v r::::rrr:::::::::r i:::::i  l::::l    1::::1   5:::::5                    +
13 +          aaaaaaaaa:::::av:::::v       v:::::v  r:::::::::::::::::r i::::i  l::::l    1::::1   5:::::5555555555           +
14 +                   a::::a v:::::v     v:::::v   rr::::::rrrrr::::::ri::::i  l::::l    1::::l   5:::::::::::::::5          +
15 +            aaaaaaa:::::a  v:::::v   v:::::v     r:::::r     r:::::ri::::i  l::::l    1::::l   555555555555:::::5         +
16 +          aa::::::::::::a   v:::::v v:::::v      r:::::r     rrrrrrri::::i  l::::l    1::::l               5:::::5        +
17 +         a::::aaaa::::::a    v:::::v:::::v       r:::::r            i::::i  l::::l    1::::l               5:::::5        +
18 +        a::::a    a:::::a     v:::::::::v        r:::::r            i::::i  l::::l    1::::l   5555555     5:::::5        +
19 +        a::::a    a:::::a      v:::::::v         r:::::r           i::::::il::::::l111::::::1115::::::55555::::::5        +
20 +        a:::::aaaa::::::a       v:::::v          r:::::r           i::::::il::::::l1::::::::::1 55:::::::::::::55         +
21 +         a::::::::::aa:::a       v:::v           r:::::r           i::::::il::::::l1::::::::::1   55:::::::::55           +
22 +          aaaaaaaaaa  aaaa        vvv            rrrrrrr           SEASON:ONEllllll111111111111     555555555             +
23 +                                                                                                                          +
24 +                                                                                                                          +
25 +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +
26 */
27 
28 // File: @openzeppelin/contracts/utils/Strings.sol
29 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
30 
31 pragma solidity ^0.8.0;
32 
33 /**
34  * @dev String operations.
35  */
36 library Strings {
37     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
38 
39     /**
40      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
41      */
42     function toString(uint256 value) internal pure returns (string memory) {
43         // Inspired by OraclizeAPI's implementation - MIT licence
44         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
45 
46         if (value == 0) {
47             return "0";
48         }
49         uint256 temp = value;
50         uint256 digits;
51         while (temp != 0) {
52             digits++;
53             temp /= 10;
54         }
55         bytes memory buffer = new bytes(digits);
56         while (value != 0) {
57             digits -= 1;
58             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
59             value /= 10;
60         }
61         return string(buffer);
62     }
63 
64     /**
65      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
66      */
67     function toHexString(uint256 value) internal pure returns (string memory) {
68         if (value == 0) {
69             return "0x00";
70         }
71         uint256 temp = value;
72         uint256 length = 0;
73         while (temp != 0) {
74             length++;
75             temp >>= 8;
76         }
77         return toHexString(value, length);
78     }
79 
80     /**
81      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
82      */
83     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
84         bytes memory buffer = new bytes(2 * length + 2);
85         buffer[0] = "0";
86         buffer[1] = "x";
87         for (uint256 i = 2 * length + 1; i > 1; --i) {
88             buffer[i] = _HEX_SYMBOLS[value & 0xf];
89             value >>= 4;
90         }
91         require(value == 0, "Strings: hex length insufficient");
92         return string(buffer);
93     }
94 }
95 
96 // File: @openzeppelin/contracts/utils/Context.sol
97 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
98 pragma solidity ^0.8.0;
99 /**
100  * @dev Provides information about the current execution context, including the
101  * sender of the transaction and its data. While these are generally available
102  * via msg.sender and msg.data, they should not be accessed in such a direct
103  * manner, since when dealing with meta-transactions the account sending and
104  * paying for execution may not be the actual sender (as far as an application
105  * is concerned).
106  *
107  * This contract is only required for intermediate, library-like contracts.
108  */
109 abstract contract Context {
110     function _msgSender() internal view virtual returns (address) {
111         return msg.sender;
112     }
113 
114     function _msgData() internal view virtual returns (bytes calldata) {
115         return msg.data;
116     }
117 }
118 
119 // File: @openzeppelin/contracts/access/Ownable.sol
120 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
121 pragma solidity ^0.8.0;
122 /**
123  * @dev Contract module which provides a basic access control mechanism, where
124  * there is an account (an owner) that can be granted exclusive access to
125  * specific functions.
126  *
127  * By default, the owner account will be the one that deploys the contract. This
128  * can later be changed with {transferOwnership}.
129  *
130  * This module is used through inheritance. It will make available the modifier
131  * `onlyOwner`, which can be applied to your functions to restrict their use to
132  * the owner.
133  */
134 abstract contract Ownable is Context {
135     address private _owner;
136 
137     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
138 
139     /**
140      * @dev Initializes the contract setting the deployer as the initial owner.
141      */
142     constructor() {
143         _transferOwnership(_msgSender());
144     }
145 
146     /**
147      * @dev Returns the address of the current owner.
148      */
149     function owner() public view virtual returns (address) {
150         return _owner;
151     }
152 
153     /**
154      * @dev Throws if called by any account other than the owner.
155      */
156     modifier onlyOwner() {
157         require(owner() == _msgSender(), "Ownable: caller is not the owner");
158         _;
159     }
160 
161     /**
162      * @dev Leaves the contract without owner. It will not be possible to call
163      * `onlyOwner` functions anymore. Can only be called by the current owner.
164      *
165      * NOTE: Renouncing ownership will leave the contract without an owner,
166      * thereby removing any functionality that is only available to the owner.
167      */
168     function renounceOwnership() public virtual onlyOwner {
169         _transferOwnership(address(0));
170     }
171 
172     /**
173      * @dev Transfers ownership of the contract to a new account (`newOwner`).
174      * Can only be called by the current owner.
175      */
176     function transferOwnership(address newOwner) public virtual onlyOwner {
177         require(newOwner != address(0), "Ownable: new owner is the zero address");
178         _transferOwnership(newOwner);
179     }
180 
181     /**
182      * @dev Transfers ownership of the contract to a new account (`newOwner`).
183      * Internal function without access restriction.
184      */
185     function _transferOwnership(address newOwner) internal virtual {
186         address oldOwner = _owner;
187         _owner = newOwner;
188         emit OwnershipTransferred(oldOwner, newOwner);
189     }
190 }
191 
192 // File: @openzeppelin/contracts/utils/Address.sol
193 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
194 pragma solidity ^0.8.1;
195 /**
196  * @dev Collection of functions related to the address type
197  */
198 library Address {
199     /**
200      * @dev Returns true if `account` is a contract.
201      *
202      * [IMPORTANT]
203      * ====
204      * It is unsafe to assume that an address for which this function returns
205      * false is an externally-owned account (EOA) and not a contract.
206      *
207      * Among others, `isContract` will return false for the following
208      * types of addresses:
209      *
210      *  - an externally-owned account
211      *  - a contract in construction
212      *  - an address where a contract will be created
213      *  - an address where a contract lived, but was destroyed
214      * ====
215      *
216      * [IMPORTANT]
217      * ====
218      * You shouldn't rely on `isContract` to protect against flash loan attacks!
219      *
220      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
221      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
222      * constructor.
223      * ====
224      */
225     function isContract(address account) internal view returns (bool) {
226         // This method relies on extcodesize/address.code.length, which returns 0
227         // for contracts in construction, since the code is only stored at the end
228         // of the constructor execution.
229 
230         return account.code.length > 0;
231     }
232 
233     /**
234      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
235      * `recipient`, forwarding all available gas and reverting on errors.
236      *
237      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
238      * of certain opcodes, possibly making contracts go over the 2300 gas limit
239      * imposed by `transfer`, making them unable to receive funds via
240      * `transfer`. {sendValue} removes this limitation.
241      *
242      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
243      *
244      * IMPORTANT: because control is transferred to `recipient`, care must be
245      * taken to not create reentrancy vulnerabilities. Consider using
246      * {ReentrancyGuard} or the
247      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
248      */
249     function sendValue(address payable recipient, uint256 amount) internal {
250         require(address(this).balance >= amount, "Address: insufficient balance");
251 
252         (bool success, ) = recipient.call{value: amount}("");
253         require(success, "Address: unable to send value, recipient may have reverted");
254     }
255 
256     /**
257      * @dev Performs a Solidity function call using a low level `call`. A
258      * plain `call` is an unsafe replacement for a function call: use this
259      * function instead.
260      *
261      * If `target` reverts with a revert reason, it is bubbled up by this
262      * function (like regular Solidity function calls).
263      *
264      * Returns the raw returned data. To convert to the expected return value,
265      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
266      *
267      * Requirements:
268      *
269      * - `target` must be a contract.
270      * - calling `target` with `data` must not revert.
271      *
272      * _Available since v3.1._
273      */
274     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
275         return functionCall(target, data, "Address: low-level call failed");
276     }
277 
278     /**
279      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
280      * `errorMessage` as a fallback revert reason when `target` reverts.
281      *
282      * _Available since v3.1._
283      */
284     function functionCall(
285         address target,
286         bytes memory data,
287         string memory errorMessage
288     ) internal returns (bytes memory) {
289         return functionCallWithValue(target, data, 0, errorMessage);
290     }
291 
292     /**
293      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
294      * but also transferring `value` wei to `target`.
295      *
296      * Requirements:
297      *
298      * - the calling contract must have an ETH balance of at least `value`.
299      * - the called Solidity function must be `payable`.
300      *
301      * _Available since v3.1._
302      */
303     function functionCallWithValue(
304         address target,
305         bytes memory data,
306         uint256 value
307     ) internal returns (bytes memory) {
308         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
309     }
310 
311     /**
312      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
313      * with `errorMessage` as a fallback revert reason when `target` reverts.
314      *
315      * _Available since v3.1._
316      */
317     function functionCallWithValue(
318         address target,
319         bytes memory data,
320         uint256 value,
321         string memory errorMessage
322     ) internal returns (bytes memory) {
323         require(address(this).balance >= value, "Address: insufficient balance for call");
324         require(isContract(target), "Address: call to non-contract");
325 
326         (bool success, bytes memory returndata) = target.call{value: value}(data);
327         return verifyCallResult(success, returndata, errorMessage);
328     }
329 
330     /**
331      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
332      * but performing a static call.
333      *
334      * _Available since v3.3._
335      */
336     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
337         return functionStaticCall(target, data, "Address: low-level static call failed");
338     }
339 
340     /**
341      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
342      * but performing a static call.
343      *
344      * _Available since v3.3._
345      */
346     function functionStaticCall(
347         address target,
348         bytes memory data,
349         string memory errorMessage
350     ) internal view returns (bytes memory) {
351         require(isContract(target), "Address: static call to non-contract");
352 
353         (bool success, bytes memory returndata) = target.staticcall(data);
354         return verifyCallResult(success, returndata, errorMessage);
355     }
356 
357     /**
358      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
359      * but performing a delegate call.
360      *
361      * _Available since v3.4._
362      */
363     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
364         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
365     }
366 
367     /**
368      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
369      * but performing a delegate call.
370      *
371      * _Available since v3.4._
372      */
373     function functionDelegateCall(
374         address target,
375         bytes memory data,
376         string memory errorMessage
377     ) internal returns (bytes memory) {
378         require(isContract(target), "Address: delegate call to non-contract");
379 
380         (bool success, bytes memory returndata) = target.delegatecall(data);
381         return verifyCallResult(success, returndata, errorMessage);
382     }
383 
384     /**
385      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
386      * revert reason using the provided one.
387      *
388      * _Available since v4.3._
389      */
390     function verifyCallResult(
391         bool success,
392         bytes memory returndata,
393         string memory errorMessage
394     ) internal pure returns (bytes memory) {
395         if (success) {
396             return returndata;
397         } else {
398             // Look for revert reason and bubble it up if present
399             if (returndata.length > 0) {
400                 // The easiest way to bubble the revert reason is using memory via assembly
401 
402                 assembly {
403                     let returndata_size := mload(returndata)
404                     revert(add(32, returndata), returndata_size)
405                 }
406             } else {
407                 revert(errorMessage);
408             }
409         }
410     }
411 }
412 
413 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
414 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
415 pragma solidity ^0.8.0;
416 /**
417  * @title ERC721 token receiver interface
418  * @dev Interface for any contract that wants to support safeTransfers
419  * from ERC721 asset contracts.
420  */
421 interface IERC721Receiver {
422     /**
423      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
424      * by `operator` from `from`, this function is called.
425      *
426      * It must return its Solidity selector to confirm the token transfer.
427      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
428      *
429      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
430      */
431     function onERC721Received(
432         address operator,
433         address from,
434         uint256 tokenId,
435         bytes calldata data
436     ) external returns (bytes4);
437 }
438 
439 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
440 
441 
442 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
443 
444 pragma solidity ^0.8.0;
445 
446 /**
447  * @dev Interface of the ERC165 standard, as defined in the
448  * https://eips.ethereum.org/EIPS/eip-165[EIP].
449  *
450  * Implementers can declare support of contract interfaces, which can then be
451  * queried by others ({ERC165Checker}).
452  *
453  * For an implementation, see {ERC165}.
454  */
455 interface IERC165 {
456     /**
457      * @dev Returns true if this contract implements the interface defined by
458      * `interfaceId`. See the corresponding
459      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
460      * to learn more about how these ids are created.
461      *
462      * This function call must use less than 30 000 gas.
463      */
464     function supportsInterface(bytes4 interfaceId) external view returns (bool);
465 }
466 
467 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
468 
469 
470 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
471 
472 pragma solidity ^0.8.0;
473 
474 
475 /**
476  * @dev Implementation of the {IERC165} interface.
477  *
478  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
479  * for the additional interface id that will be supported. For example:
480  *
481  * ```solidity
482  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
483  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
484  * }
485  * ```
486  *
487  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
488  */
489 abstract contract ERC165 is IERC165 {
490     /**
491      * @dev See {IERC165-supportsInterface}.
492      */
493     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
494         return interfaceId == type(IERC165).interfaceId;
495     }
496 }
497 
498 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
499 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
500 pragma solidity ^0.8.0;
501 /**
502  * @dev Required interface of an ERC721 compliant contract.
503  */
504 interface IERC721 is IERC165 {
505     /**
506      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
507      */
508     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
509 
510     /**
511      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
512      */
513     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
514 
515     /**
516      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
517      */
518     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
519 
520     /**
521      * @dev Returns the number of tokens in ``owner``'s account.
522      */
523     function balanceOf(address owner) external view returns (uint256 balance);
524 
525     /**
526      * @dev Returns the owner of the `tokenId` token.
527      *
528      * Requirements:
529      *
530      * - `tokenId` must exist.
531      */
532     function ownerOf(uint256 tokenId) external view returns (address owner);
533 
534     /**
535      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
536      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
537      *
538      * Requirements:
539      *
540      * - `from` cannot be the zero address.
541      * - `to` cannot be the zero address.
542      * - `tokenId` token must exist and be owned by `from`.
543      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
544      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
545      *
546      * Emits a {Transfer} event.
547      */
548     function safeTransferFrom(
549         address from,
550         address to,
551         uint256 tokenId
552     ) external;
553 
554     /**
555      * @dev Transfers `tokenId` token from `from` to `to`.
556      *
557      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
558      *
559      * Requirements:
560      *
561      * - `from` cannot be the zero address.
562      * - `to` cannot be the zero address.
563      * - `tokenId` token must be owned by `from`.
564      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
565      *
566      * Emits a {Transfer} event.
567      */
568     function transferFrom(
569         address from,
570         address to,
571         uint256 tokenId
572     ) external;
573 
574     /**
575      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
576      * The approval is cleared when the token is transferred.
577      *
578      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
579      *
580      * Requirements:
581      *
582      * - The caller must own the token or be an approved operator.
583      * - `tokenId` must exist.
584      *
585      * Emits an {Approval} event.
586      */
587     function approve(address to, uint256 tokenId) external;
588 
589     /**
590      * @dev Returns the account approved for `tokenId` token.
591      *
592      * Requirements:
593      *
594      * - `tokenId` must exist.
595      */
596     function getApproved(uint256 tokenId) external view returns (address operator);
597 
598     /**
599      * @dev Approve or remove `operator` as an operator for the caller.
600      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
601      *
602      * Requirements:
603      *
604      * - The `operator` cannot be the caller.
605      *
606      * Emits an {ApprovalForAll} event.
607      */
608     function setApprovalForAll(address operator, bool _approved) external;
609 
610     /**
611      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
612      *
613      * See {setApprovalForAll}
614      */
615     function isApprovedForAll(address owner, address operator) external view returns (bool);
616 
617     /**
618      * @dev Safely transfers `tokenId` token from `from` to `to`.
619      *
620      * Requirements:
621      *
622      * - `from` cannot be the zero address.
623      * - `to` cannot be the zero address.
624      * - `tokenId` token must exist and be owned by `from`.
625      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
626      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
627      *
628      * Emits a {Transfer} event.
629      */
630     function safeTransferFrom(
631         address from,
632         address to,
633         uint256 tokenId,
634         bytes calldata data
635     ) external;
636 }
637 
638 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
639 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
640 
641 pragma solidity ^0.8.0;
642 /**
643  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
644  * @dev See https://eips.ethereum.org/EIPS/eip-721
645  */
646 interface IERC721Metadata is IERC721 {
647     /**
648      * @dev Returns the token collection name.
649      */
650     function name() external view returns (string memory);
651 
652     /**
653      * @dev Returns the token collection symbol.
654      */
655     function symbol() external view returns (string memory);
656 
657     /**
658      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
659      */
660     function tokenURI(uint256 tokenId) external view returns (string memory);
661 }
662 
663 // File: erc721a/contracts/ERC721A.sol
664 // Creator: Chiru Labs
665 pragma solidity ^0.8.4;
666 
667 error ApprovalCallerNotOwnerNorApproved();
668 error ApprovalQueryForNonexistentToken();
669 error ApproveToCaller();
670 error ApprovalToCurrentOwner();
671 error BalanceQueryForZeroAddress();
672 error MintToZeroAddress();
673 error MintZeroQuantity();
674 error OwnerQueryForNonexistentToken();
675 error TransferCallerNotOwnerNorApproved();
676 error TransferFromIncorrectOwner();
677 error TransferToNonERC721ReceiverImplementer();
678 error TransferToZeroAddress();
679 error URIQueryForNonexistentToken();
680 
681 /**
682  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
683  * the Metadata extension. Built to optimize for lower gas during batch mints.
684  *
685  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
686  *
687  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
688  *
689  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
690  */
691 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
692 	using Address for address;
693 	using Strings for uint256;
694 
695 	// Compiler will pack this into a single 256bit word.
696 	struct TokenOwnership {
697 		// The address of the owner.
698 		address addr;
699 		// Keeps track of the start time of ownership with minimal overhead for tokenomics.
700 		uint64 startTimestamp;
701 		// Whether the token has been burned.
702 		bool burned;
703 	}
704 
705 	// Compiler will pack this into a single 256bit word.
706 	struct AddressData {
707 		// Realistically, 2**64-1 is more than enough.
708 		uint64 balance;
709 		// Keeps track of mint count with minimal overhead for tokenomics.
710 		uint64 numberMinted;
711 		// Keeps track of burn count with minimal overhead for tokenomics.
712 		uint64 numberBurned;
713 		// For miscellaneous variable(s) pertaining to the address
714 		// (e.g. number of whitelist mint slots used).
715 		// If there are multiple variables, please pack them into a uint64.
716 		uint64 aux;
717 	}
718 
719 	// The tokenId of the next token to be minted.
720 	uint256 internal _currentIndex;
721 
722 	// The number of tokens burned.
723 	uint256 internal _burnCounter;
724 
725 	// Token name
726 	string private _name;
727 
728 	// Token symbol
729 	string private _symbol;
730 
731 	// Mapping from token ID to ownership details
732 	// An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
733 	mapping(uint256 => TokenOwnership) internal _ownerships;
734 
735 	// Mapping owner address to address data
736 	mapping(address => AddressData) private _addressData;
737 
738 	// Mapping from token ID to approved address
739 	mapping(uint256 => address) private _tokenApprovals;
740 
741 	// Mapping from owner to operator approvals
742 	mapping(address => mapping(address => bool)) private _operatorApprovals;
743 
744 	constructor(string memory name_, string memory symbol_) {
745 		_name = name_;
746 		_symbol = symbol_;
747 		_currentIndex = _startTokenId();
748 	}
749 
750 	/**
751 	 * To change the starting tokenId, please override this function.
752 	 */
753 	function _startTokenId() internal view virtual returns (uint256) {
754 		return 1;
755 	}
756 
757 	/**
758 	 * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
759 	 */
760 	function totalSupply() public view returns (uint256) {
761 		// Counter underflow is impossible as _burnCounter cannot be incremented
762 		// more than _currentIndex - _startTokenId() times
763 		unchecked {
764 			return _currentIndex - _burnCounter - _startTokenId();
765 		}
766 	}
767 
768 	/**
769 	 * Returns the total amount of tokens minted in the contract.
770 	 */
771 	function _totalMinted() internal view returns (uint256) {
772 		// Counter underflow is impossible as _currentIndex does not decrement,
773 		// and it is initialized to _startTokenId()
774 		unchecked {
775 			return _currentIndex - _startTokenId();
776 		}
777 	}
778 
779 	/**
780 	 * @dev See {IERC165-supportsInterface}.
781 	 */
782 	function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
783 		return
784 			interfaceId == type(IERC721).interfaceId ||
785 			interfaceId == type(IERC721Metadata).interfaceId ||
786 			super.supportsInterface(interfaceId);
787 	}
788 
789 	/**
790 	 * @dev See {IERC721-balanceOf}.
791 	 */
792 	function balanceOf(address owner) public view override returns (uint256) {
793 		if (owner == address(0)) revert BalanceQueryForZeroAddress();
794 		return uint256(_addressData[owner].balance);
795 	}
796 
797 	/**
798 	 * Returns the number of tokens minted by `owner`.
799 	 */
800 	function _numberMinted(address owner) internal view returns (uint256) {
801 		return uint256(_addressData[owner].numberMinted);
802 	}
803 
804 	/**
805 	 * Returns the number of tokens burned by or on behalf of `owner`.
806 	 */
807 	function _numberBurned(address owner) internal view returns (uint256) {
808 		return uint256(_addressData[owner].numberBurned);
809 	}
810 
811 	/**
812 	 * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
813 	 */
814 	function _getAux(address owner) internal view returns (uint64) {
815 		return _addressData[owner].aux;
816 	}
817 
818 	/**
819 	 * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
820 	 * If there are multiple variables, please pack them into a uint64.
821 	 */
822 	function _setAux(address owner, uint64 aux) internal {
823 		_addressData[owner].aux = aux;
824 	}
825 
826 	/**
827 	 * Gas spent here starts off proportional to the maximum mint batch size.
828 	 * It gradually moves to O(1) as tokens get transferred around in the collection over time.
829 	 */
830 	function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
831 		uint256 curr = tokenId;
832 
833 		unchecked {
834 			if (_startTokenId() <= curr && curr < _currentIndex) {
835 				TokenOwnership memory ownership = _ownerships[curr];
836 				if (!ownership.burned) {
837 					if (ownership.addr != address(0)) {
838 						return ownership;
839 					}
840 					// Invariant:
841 					// There will always be an ownership that has an address and is not burned
842 					// before an ownership that does not have an address and is not burned.
843 					// Hence, curr will not underflow.
844 					while (true) {
845 						curr--;
846 						ownership = _ownerships[curr];
847 						if (ownership.addr != address(0)) {
848 							return ownership;
849 						}
850 					}
851 				}
852 			}
853 		}
854 		revert OwnerQueryForNonexistentToken();
855 	}
856 
857 	/**
858 	 * @dev See {IERC721-ownerOf}.
859 	 */
860 	function ownerOf(uint256 tokenId) public view override returns (address) {
861 		return _ownershipOf(tokenId).addr;
862 	}
863 
864 	/**
865 	 * @dev See {IERC721Metadata-name}.
866 	 */
867 	function name() public view virtual override returns (string memory) {
868 		return _name;
869 	}
870 
871 	/**
872 	 * @dev See {IERC721Metadata-symbol}.
873 	 */
874 	function symbol() public view virtual override returns (string memory) {
875 		return _symbol;
876 	}
877 
878 	/**
879 	 * @dev See {IERC721Metadata-tokenURI}.
880 	 */
881 	function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
882 		if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
883 
884 		string memory baseURI = _baseURI();
885 		return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
886 	}
887 
888 	/**
889 	 * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
890 	 * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
891 	 * by default, can be overriden in child contracts.
892 	 */
893 	function _baseURI() internal view virtual returns (string memory) {
894 		return '';
895 	}
896 
897 	/**
898 	 * @dev See {IERC721-approve}.
899 	 */
900 	function approve(address to, uint256 tokenId) public override {
901 		address owner = ERC721A.ownerOf(tokenId);
902 		if (to == owner) revert ApprovalToCurrentOwner();
903 
904 		if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
905 			revert ApprovalCallerNotOwnerNorApproved();
906 		}
907 
908 		_approve(to, tokenId, owner);
909 	}
910 
911 	/**
912 	 * @dev See {IERC721-getApproved}.
913 	 */
914 	function getApproved(uint256 tokenId) public view override returns (address) {
915 		if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
916 
917 		return _tokenApprovals[tokenId];
918 	}
919 
920 	/**
921 	 * @dev See {IERC721-setApprovalForAll}.
922 	 */
923 	function setApprovalForAll(address operator, bool approved) public virtual override {
924 		if (operator == _msgSender()) revert ApproveToCaller();
925 
926 		_operatorApprovals[_msgSender()][operator] = approved;
927 		emit ApprovalForAll(_msgSender(), operator, approved);
928 	}
929 
930 	/**
931 	 * @dev See {IERC721-isApprovedForAll}.
932 	 */
933 	function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
934 		return _operatorApprovals[owner][operator];
935 	}
936 
937 	/**
938 	 * @dev See {IERC721-transferFrom}.
939 	 */
940 	function transferFrom(
941 		address from,
942 		address to,
943 		uint256 tokenId
944 	) public virtual override {
945 		_transfer(from, to, tokenId);
946 	}
947 
948 	/**
949 	 * @dev See {IERC721-safeTransferFrom}.
950 	 */
951 	function safeTransferFrom(
952 		address from,
953 		address to,
954 		uint256 tokenId
955 	) public virtual override {
956 		safeTransferFrom(from, to, tokenId, '');
957 	}
958 
959 	/**
960 	 * @dev See {IERC721-safeTransferFrom}.
961 	 */
962 	function safeTransferFrom(
963 		address from,
964 		address to,
965 		uint256 tokenId,
966 		bytes memory _data
967 	) public virtual override {
968 		_transfer(from, to, tokenId);
969 		if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
970 			revert TransferToNonERC721ReceiverImplementer();
971 		}
972 	}
973 
974 	/**
975 	 * @dev Returns whether `tokenId` exists.
976 	 *
977 	 * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
978 	 *
979 	 * Tokens start existing when they are minted (`_mint`),
980 	 */
981 	function _exists(uint256 tokenId) internal view returns (bool) {
982 		return _startTokenId() <= tokenId && tokenId < _currentIndex &&
983 			!_ownerships[tokenId].burned;
984 	}
985 
986 	function _safeMint(address to, uint256 quantity) internal {
987 		_safeMint(to, quantity, '');
988 	}
989 
990 	/**
991 	 * @dev Safely mints `quantity` tokens and transfers them to `to`.
992 	 *
993 	 * Requirements:
994 	 *
995 	 * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
996 	 * - `quantity` must be greater than 0.
997 	 *
998 	 * Emits a {Transfer} event.
999 	 */
1000 	function _safeMint(
1001 		address to,
1002 		uint256 quantity,
1003 		bytes memory _data
1004 	) internal {
1005 		_mint(to, quantity, _data, true);
1006 	}
1007 
1008 	/**
1009 	 * @dev Mints `quantity` tokens and transfers them to `to`.
1010 	 *
1011 	 * Requirements:
1012 	 *
1013 	 * - `to` cannot be the zero address.
1014 	 * - `quantity` must be greater than 0.
1015 	 *
1016 	 * Emits a {Transfer} event.
1017 	 */
1018 	function _mint(
1019 		address to,
1020 		uint256 quantity,
1021 		bytes memory _data,
1022 		bool safe
1023 	) internal {
1024 		uint256 startTokenId = _currentIndex;
1025 		if (to == address(0)) revert MintToZeroAddress();
1026 		if (quantity == 0) revert MintZeroQuantity();
1027 
1028 		_beforeTokenTransfers(address(0), to, startTokenId, quantity);
1029 
1030 		// Overflows are incredibly unrealistic.
1031 		// balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1032 		// updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1033 		unchecked {
1034 			_addressData[to].balance += uint64(quantity);
1035 			_addressData[to].numberMinted += uint64(quantity);
1036 
1037 			_ownerships[startTokenId].addr = to;
1038 			_ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1039 
1040 			uint256 updatedIndex = startTokenId;
1041 			uint256 end = updatedIndex + quantity;
1042 
1043 			if (safe && to.isContract()) {
1044 				do {
1045 					emit Transfer(address(0), to, updatedIndex);
1046 					if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1047 						revert TransferToNonERC721ReceiverImplementer();
1048 					}
1049 				} while (updatedIndex != end);
1050 				// Reentrancy protection
1051 				if (_currentIndex != startTokenId) revert();
1052 			} else {
1053 				do {
1054 					emit Transfer(address(0), to, updatedIndex++);
1055 				} while (updatedIndex != end);
1056 			}
1057 			_currentIndex = updatedIndex;
1058 		}
1059 		_afterTokenTransfers(address(0), to, startTokenId, quantity);
1060 	}
1061 
1062 	/**
1063 	 * @dev Transfers `tokenId` from `from` to `to`.
1064 	 *
1065 	 * Requirements:
1066 	 *
1067 	 * - `to` cannot be the zero address.
1068 	 * - `tokenId` token must be owned by `from`.
1069 	 *
1070 	 * Emits a {Transfer} event.
1071 	 */
1072 	function _transfer(
1073 		address from,
1074 		address to,
1075 		uint256 tokenId
1076 	) private {
1077 		TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1078 
1079 		if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1080 
1081 		bool isApprovedOrOwner = (_msgSender() == from ||
1082 			isApprovedForAll(from, _msgSender()) ||
1083 			getApproved(tokenId) == _msgSender());
1084 
1085 		if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1086 		if (to == address(0)) revert TransferToZeroAddress();
1087 
1088 		_beforeTokenTransfers(from, to, tokenId, 1);
1089 
1090 		// Clear approvals from the previous owner
1091 		_approve(address(0), tokenId, from);
1092 
1093 		// Underflow of the sender's balance is impossible because we check for
1094 		// ownership above and the recipient's balance can't realistically overflow.
1095 		// Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1096 		unchecked {
1097 			_addressData[from].balance -= 1;
1098 			_addressData[to].balance += 1;
1099 
1100 			TokenOwnership storage currSlot = _ownerships[tokenId];
1101 			currSlot.addr = to;
1102 			currSlot.startTimestamp = uint64(block.timestamp);
1103 
1104 			// If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1105 			// Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1106 			uint256 nextTokenId = tokenId + 1;
1107 			TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1108 			if (nextSlot.addr == address(0)) {
1109 				// This will suffice for checking _exists(nextTokenId),
1110 				// as a burned slot cannot contain the zero address.
1111 				if (nextTokenId != _currentIndex) {
1112 					nextSlot.addr = from;
1113 					nextSlot.startTimestamp = prevOwnership.startTimestamp;
1114 				}
1115 			}
1116 		}
1117 
1118 		emit Transfer(from, to, tokenId);
1119 		_afterTokenTransfers(from, to, tokenId, 1);
1120 	}
1121 
1122 	/**
1123 	 * @dev This is equivalent to _burn(tokenId, false)
1124 	 */
1125 	function _burn(uint256 tokenId) internal virtual {
1126 		_burn(tokenId, false);
1127 	}
1128 
1129 	/**
1130 	 * @dev Destroys `tokenId`.
1131 	 * The approval is cleared when the token is burned.
1132 	 *
1133 	 * Requirements:
1134 	 *
1135 	 * - `tokenId` must exist.
1136 	 *
1137 	 * Emits a {Transfer} event.
1138 	 */
1139 	function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1140 		TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1141 
1142 		address from = prevOwnership.addr;
1143 
1144 		if (approvalCheck) {
1145 			bool isApprovedOrOwner = (_msgSender() == from ||
1146 				isApprovedForAll(from, _msgSender()) ||
1147 				getApproved(tokenId) == _msgSender());
1148 
1149 			if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1150 		}
1151 
1152 		_beforeTokenTransfers(from, address(0), tokenId, 1);
1153 
1154 		// Clear approvals from the previous owner
1155 		_approve(address(0), tokenId, from);
1156 
1157 		// Underflow of the sender's balance is impossible because we check for
1158 		// ownership above and the recipient's balance can't realistically overflow.
1159 		// Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1160 		unchecked {
1161 			AddressData storage addressData = _addressData[from];
1162 			addressData.balance -= 1;
1163 			addressData.numberBurned += 1;
1164 
1165 			// Keep track of who burned the token, and the timestamp of burning.
1166 			TokenOwnership storage currSlot = _ownerships[tokenId];
1167 			currSlot.addr = from;
1168 			currSlot.startTimestamp = uint64(block.timestamp);
1169 			currSlot.burned = true;
1170 
1171 			// If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1172 			// Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1173 			uint256 nextTokenId = tokenId + 1;
1174 			TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1175 			if (nextSlot.addr == address(0)) {
1176 				// This will suffice for checking _exists(nextTokenId),
1177 				// as a burned slot cannot contain the zero address.
1178 				if (nextTokenId != _currentIndex) {
1179 					nextSlot.addr = from;
1180 					nextSlot.startTimestamp = prevOwnership.startTimestamp;
1181 				}
1182 			}
1183 		}
1184 
1185 		emit Transfer(from, address(0), tokenId);
1186 		_afterTokenTransfers(from, address(0), tokenId, 1);
1187 
1188 		// Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1189 		unchecked {
1190 			_burnCounter++;
1191 		}
1192 	}
1193 
1194 	/**
1195 	 * @dev Approve `to` to operate on `tokenId`
1196 	 *
1197 	 * Emits a {Approval} event.
1198 	 */
1199 	function _approve(
1200 		address to,
1201 		uint256 tokenId,
1202 		address owner
1203 	) private {
1204 		_tokenApprovals[tokenId] = to;
1205 		emit Approval(owner, to, tokenId);
1206 	}
1207 
1208 	/**
1209 	 * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1210 	 *
1211 	 * @param from address representing the previous owner of the given token ID
1212 	 * @param to target address that will receive the tokens
1213 	 * @param tokenId uint256 ID of the token to be transferred
1214 	 * @param _data bytes optional data to send along with the call
1215 	 * @return bool whether the call correctly returned the expected magic value
1216 	 */
1217 	function _checkContractOnERC721Received(
1218 		address from,
1219 		address to,
1220 		uint256 tokenId,
1221 		bytes memory _data
1222 	) private returns (bool) {
1223 		try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1224 			return retval == IERC721Receiver(to).onERC721Received.selector;
1225 		} catch (bytes memory reason) {
1226 			if (reason.length == 0) {
1227 				revert TransferToNonERC721ReceiverImplementer();
1228 			} else {
1229 				assembly {
1230 					revert(add(32, reason), mload(reason))
1231 				}
1232 			}
1233 		}
1234 	}
1235 
1236 	/**
1237 	 * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1238 	 * And also called before burning one token.
1239 	 *
1240 	 * startTokenId - the first token id to be transferred
1241 	 * quantity - the amount to be transferred
1242 	 *
1243 	 * Calling conditions:
1244 	 *
1245 	 * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1246 	 * transferred to `to`.
1247 	 * - When `from` is zero, `tokenId` will be minted for `to`.
1248 	 * - When `to` is zero, `tokenId` will be burned by `from`.
1249 	 * - `from` and `to` are never both zero.
1250 	 */
1251 	function _beforeTokenTransfers(
1252 		address from,
1253 		address to,
1254 		uint256 startTokenId,
1255 		uint256 quantity
1256 	) internal virtual {}
1257 
1258 	/**
1259 	 * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1260 	 * minting.
1261 	 * And also called after one token has been burned.
1262 	 *
1263 	 * startTokenId - the first token id to be transferred
1264 	 * quantity - the amount to be transferred
1265 	 *
1266 	 * Calling conditions:
1267 	 *
1268 	 * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1269 	 * transferred to `to`.
1270 	 * - When `from` is zero, `tokenId` has been minted for `to`.
1271 	 * - When `to` is zero, `tokenId` has been burned by `from`.
1272 	 * - `from` and `to` are never both zero.
1273 	 */
1274 	function _afterTokenTransfers(
1275 		address from,
1276 		address to,
1277 		uint256 startTokenId,
1278 		uint256 quantity
1279 	) internal virtual {}
1280 }
1281 
1282 // File: avril15_s1.sol
1283 
1284 pragma solidity ^0.8.4;
1285 
1286 contract avril15_SeasonOne is ERC721A, Ownable {
1287 	uint256 maxSupply = 160;
1288 
1289 	string public baseURI = "ipfs://QmQrkhzQeVSLvFN9oUCJ4PJhkDfQPMfj8zmu5Nc2JCsqq6/";
1290 	bool public revealed = true;
1291 
1292 	constructor() ERC721A("avril15.eth season one", "AVRIL15_S1") {}
1293 
1294 	function ownerMint(uint256 quantity) external payable onlyOwner {
1295 		require(totalSupply() + quantity <= maxSupply, "Exceeded maxSupply of 160.");
1296 		_safeMint(msg.sender, quantity);
1297 	}
1298 
1299     function _baseURI() internal view override returns (string memory) {
1300 		return baseURI;
1301 	}
1302 
1303 	function changeBaseURI(string memory baseURI_) public onlyOwner {
1304 		baseURI = baseURI_;
1305 	}
1306 
1307     function changeRevealed(bool _revealed) public onlyOwner {
1308         revealed = _revealed;
1309     }
1310 
1311 	function tokenURI(uint256 tokenId) public view override returns (string memory) {
1312 		require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1313 
1314 		string memory baseURI_ = _baseURI();
1315 
1316 		if (revealed) {
1317 			return bytes(baseURI_).length > 0 ? string(abi.encodePacked(baseURI_, Strings.toString(tokenId), ".json")) : "";
1318 		} else {
1319 			return string(abi.encodePacked(baseURI_, "prereveal.json"));
1320 		}
1321 	}
1322 }