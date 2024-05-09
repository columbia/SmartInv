1 // SPDX-License-Identifier: GPL-3.0
2 //  _  ____  _ _  __ _  _ _____  __    __  ___    ____  _  __  _ __  _  
3 // | |/ /  \| | |/ _] || |_   _/' _/  /__\| __|  / _/ || |/  \| |  \| | 
4 // |   <| | ' | | [/\ >< | | | `._`. | \/ | _|  | \_| >< | /\ | | | ' | 
5 // |_|\_\_|\__|_|\__/_||_| |_| |___/  \__/|_|    \__/_||_|_||_|_|_|\__| 
6 //  Website: https://www.knightsofchain.com
7 //  Discord: https://discord.gg/vnhHUxg9WJ
8 //  Twitter: https://twitter.com/Knightsofchain
9 //  
10 //  9,9999 Knights living on the Ethereum Blockchain, charged with protecting the NFT Realm.
11 //  
12 //
13 // Launched by NFTRealm.io 
14 // SPDX-License-Identifier: GPL-3.0
15 
16 
17 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
18 pragma solidity ^0.8.0;
19 /**
20  * @dev Interface of the ERC165 standard, as defined in the
21  * https://eips.ethereum.org/EIPS/eip-165[EIP].
22  *
23  * Implementers can declare support of contract interfaces, which can then be
24  * queried by others ({ERC165Checker}).
25  *
26  * For an implementation, see {ERC165}.
27  */
28 interface IERC165 {
29     /**
30      * @dev Returns true if this contract implements the interface defined by
31      * `interfaceId`. See the corresponding
32      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
33      * to learn more about how these ids are created.
34      *
35      * This function call must use less than 30 000 gas.
36      */
37     function supportsInterface(bytes4 interfaceId) external view returns (bool);
38 }
39 
40 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
41 pragma solidity ^0.8.0;
42 /**
43  * @dev Required interface of an ERC721 compliant contract.
44  */
45 interface IERC721 is IERC165 {
46     /**
47      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
48      */
49     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
50 
51     /**
52      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
53      */
54     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
55 
56     /**
57      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
58      */
59     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
60 
61     /**
62      * @dev Returns the number of tokens in ``owner``'s account.
63      */
64     function balanceOf(address owner) external view returns (uint256 balance);
65 
66     /**
67      * @dev Returns the owner of the `tokenId` token.
68      *
69      * Requirements:
70      *
71      * - `tokenId` must exist.
72      */
73     function ownerOf(uint256 tokenId) external view returns (address owner);
74 
75     /**
76      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
77      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
78      *
79      * Requirements:
80      *
81      * - `from` cannot be the zero address.
82      * - `to` cannot be the zero address.
83      * - `tokenId` token must exist and be owned by `from`.
84      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
85      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
86      *
87      * Emits a {Transfer} event.
88      */
89     function safeTransferFrom(
90         address from,
91         address to,
92         uint256 tokenId
93     ) external;
94 
95     /**
96      * @dev Transfers `tokenId` token from `from` to `to`.
97      *
98      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
99      *
100      * Requirements:
101      *
102      * - `from` cannot be the zero address.
103      * - `to` cannot be the zero address.
104      * - `tokenId` token must be owned by `from`.
105      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
106      *
107      * Emits a {Transfer} event.
108      */
109     function transferFrom(
110         address from,
111         address to,
112         uint256 tokenId
113     ) external;
114 
115     /**
116      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
117      * The approval is cleared when the token is transferred.
118      *
119      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
120      *
121      * Requirements:
122      *
123      * - The caller must own the token or be an approved operator.
124      * - `tokenId` must exist.
125      *
126      * Emits an {Approval} event.
127      */
128     function approve(address to, uint256 tokenId) external;
129 
130     /**
131      * @dev Returns the account approved for `tokenId` token.
132      *
133      * Requirements:
134      *
135      * - `tokenId` must exist.
136      */
137     function getApproved(uint256 tokenId) external view returns (address operator);
138 
139     /**
140      * @dev Approve or remove `operator` as an operator for the caller.
141      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
142      *
143      * Requirements:
144      *
145      * - The `operator` cannot be the caller.
146      *
147      * Emits an {ApprovalForAll} event.
148      */
149     function setApprovalForAll(address operator, bool _approved) external;
150 
151     /**
152      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
153      *
154      * See {setApprovalForAll}
155      */
156     function isApprovedForAll(address owner, address operator) external view returns (bool);
157 
158     /**
159      * @dev Safely transfers `tokenId` token from `from` to `to`.
160      *
161      * Requirements:
162      *
163      * - `from` cannot be the zero address.
164      * - `to` cannot be the zero address.
165      * - `tokenId` token must exist and be owned by `from`.
166      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
167      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
168      *
169      * Emits a {Transfer} event.
170      */
171     function safeTransferFrom(
172         address from,
173         address to,
174         uint256 tokenId,
175         bytes calldata data
176     ) external;
177 }
178 
179 
180 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
181 pragma solidity ^0.8.0;
182 /**
183  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
184  * @dev See https://eips.ethereum.org/EIPS/eip-721
185  */
186 interface IERC721Enumerable is IERC721 {
187     /**
188      * @dev Returns the total amount of tokens stored by the contract.
189      */
190     function totalSupply() external view returns (uint256);
191 
192     /**
193      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
194      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
195      */
196     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
197 
198     /**
199      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
200      * Use along with {totalSupply} to enumerate all tokens.
201      */
202     function tokenByIndex(uint256 index) external view returns (uint256);
203 }
204 
205 
206 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
207 pragma solidity ^0.8.0;
208 /**
209  * @dev Implementation of the {IERC165} interface.
210  *
211  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
212  * for the additional interface id that will be supported. For example:
213  *
214  * ```solidity
215  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
216  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
217  * }
218  * ```
219  *
220  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
221  */
222 abstract contract ERC165 is IERC165 {
223     /**
224      * @dev See {IERC165-supportsInterface}.
225      */
226     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
227         return interfaceId == type(IERC165).interfaceId;
228     }
229 }
230 
231 // File: @openzeppelin/contracts/utils/Strings.sol
232 
233 
234 
235 pragma solidity ^0.8.0;
236 
237 /**
238  * @dev String operations.
239  */
240 library Strings {
241     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
242 
243     /**
244      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
245      */
246     function toString(uint256 value) internal pure returns (string memory) {
247         // Inspired by OraclizeAPI's implementation - MIT licence
248         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
249 
250         if (value == 0) {
251             return "0";
252         }
253         uint256 temp = value;
254         uint256 digits;
255         while (temp != 0) {
256             digits++;
257             temp /= 10;
258         }
259         bytes memory buffer = new bytes(digits);
260         while (value != 0) {
261             digits -= 1;
262             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
263             value /= 10;
264         }
265         return string(buffer);
266     }
267 
268     /**
269      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
270      */
271     function toHexString(uint256 value) internal pure returns (string memory) {
272         if (value == 0) {
273             return "0x00";
274         }
275         uint256 temp = value;
276         uint256 length = 0;
277         while (temp != 0) {
278             length++;
279             temp >>= 8;
280         }
281         return toHexString(value, length);
282     }
283 
284     /**
285      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
286      */
287     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
288         bytes memory buffer = new bytes(2 * length + 2);
289         buffer[0] = "0";
290         buffer[1] = "x";
291         for (uint256 i = 2 * length + 1; i > 1; --i) {
292             buffer[i] = _HEX_SYMBOLS[value & 0xf];
293             value >>= 4;
294         }
295         require(value == 0, "Strings: hex length insufficient");
296         return string(buffer);
297     }
298 }
299 
300 // File: @openzeppelin/contracts/utils/Address.sol
301 
302 
303 
304 pragma solidity ^0.8.0;
305 
306 /**
307  * @dev Collection of functions related to the address type
308  */
309 library Address {
310     /**
311      * @dev Returns true if `account` is a contract.
312      *
313      * [IMPORTANT]
314      * ====
315      * It is unsafe to assume that an address for which this function returns
316      * false is an externally-owned account (EOA) and not a contract.
317      *
318      * Among others, `isContract` will return false for the following
319      * types of addresses:
320      *
321      *  - an externally-owned account
322      *  - a contract in construction
323      *  - an address where a contract will be created
324      *  - an address where a contract lived, but was destroyed
325      * ====
326      */
327     function isContract(address account) internal view returns (bool) {
328         // This method relies on extcodesize, which returns 0 for contracts in
329         // construction, since the code is only stored at the end of the
330         // constructor execution.
331 
332         uint256 size;
333         assembly {
334             size := extcodesize(account)
335         }
336         return size > 0;
337     }
338 
339     /**
340      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
341      * `recipient`, forwarding all available gas and reverting on errors.
342      *
343      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
344      * of certain opcodes, possibly making contracts go over the 2300 gas limit
345      * imposed by `transfer`, making them unable to receive funds via
346      * `transfer`. {sendValue} removes this limitation.
347      *
348      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
349      *
350      * IMPORTANT: because control is transferred to `recipient`, care must be
351      * taken to not create reentrancy vulnerabilities. Consider using
352      * {ReentrancyGuard} or the
353      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
354      */
355     function sendValue(address payable recipient, uint256 amount) internal {
356         require(address(this).balance >= amount, "Address: insufficient balance");
357 
358         (bool success, ) = recipient.call{value: amount}("");
359         require(success, "Address: unable to send value, recipient may have reverted");
360     }
361 
362     /**
363      * @dev Performs a Solidity function call using a low level `call`. A
364      * plain `call` is an unsafe replacement for a function call: use this
365      * function instead.
366      *
367      * If `target` reverts with a revert reason, it is bubbled up by this
368      * function (like regular Solidity function calls).
369      *
370      * Returns the raw returned data. To convert to the expected return value,
371      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
372      *
373      * Requirements:
374      *
375      * - `target` must be a contract.
376      * - calling `target` with `data` must not revert.
377      *
378      * _Available since v3.1._
379      */
380     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
381         return functionCall(target, data, "Address: low-level call failed");
382     }
383 
384     /**
385      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
386      * `errorMessage` as a fallback revert reason when `target` reverts.
387      *
388      * _Available since v3.1._
389      */
390     function functionCall(
391         address target,
392         bytes memory data,
393         string memory errorMessage
394     ) internal returns (bytes memory) {
395         return functionCallWithValue(target, data, 0, errorMessage);
396     }
397 
398     /**
399      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
400      * but also transferring `value` wei to `target`.
401      *
402      * Requirements:
403      *
404      * - the calling contract must have an ETH balance of at least `value`.
405      * - the called Solidity function must be `payable`.
406      *
407      * _Available since v3.1._
408      */
409     function functionCallWithValue(
410         address target,
411         bytes memory data,
412         uint256 value
413     ) internal returns (bytes memory) {
414         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
415     }
416 
417     /**
418      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
419      * with `errorMessage` as a fallback revert reason when `target` reverts.
420      *
421      * _Available since v3.1._
422      */
423     function functionCallWithValue(
424         address target,
425         bytes memory data,
426         uint256 value,
427         string memory errorMessage
428     ) internal returns (bytes memory) {
429         require(address(this).balance >= value, "Address: insufficient balance for call");
430         require(isContract(target), "Address: call to non-contract");
431 
432         (bool success, bytes memory returndata) = target.call{value: value}(data);
433         return verifyCallResult(success, returndata, errorMessage);
434     }
435 
436     /**
437      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
438      * but performing a static call.
439      *
440      * _Available since v3.3._
441      */
442     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
443         return functionStaticCall(target, data, "Address: low-level static call failed");
444     }
445 
446     /**
447      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
448      * but performing a static call.
449      *
450      * _Available since v3.3._
451      */
452     function functionStaticCall(
453         address target,
454         bytes memory data,
455         string memory errorMessage
456     ) internal view returns (bytes memory) {
457         require(isContract(target), "Address: static call to non-contract");
458 
459         (bool success, bytes memory returndata) = target.staticcall(data);
460         return verifyCallResult(success, returndata, errorMessage);
461     }
462 
463     /**
464      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
465      * but performing a delegate call.
466      *
467      * _Available since v3.4._
468      */
469     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
470         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
471     }
472 
473     /**
474      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
475      * but performing a delegate call.
476      *
477      * _Available since v3.4._
478      */
479     function functionDelegateCall(
480         address target,
481         bytes memory data,
482         string memory errorMessage
483     ) internal returns (bytes memory) {
484         require(isContract(target), "Address: delegate call to non-contract");
485 
486         (bool success, bytes memory returndata) = target.delegatecall(data);
487         return verifyCallResult(success, returndata, errorMessage);
488     }
489 
490     /**
491      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
492      * revert reason using the provided one.
493      *
494      * _Available since v4.3._
495      */
496     function verifyCallResult(
497         bool success,
498         bytes memory returndata,
499         string memory errorMessage
500     ) internal pure returns (bytes memory) {
501         if (success) {
502             return returndata;
503         } else {
504             // Look for revert reason and bubble it up if present
505             if (returndata.length > 0) {
506                 // The easiest way to bubble the revert reason is using memory via assembly
507 
508                 assembly {
509                     let returndata_size := mload(returndata)
510                     revert(add(32, returndata), returndata_size)
511                 }
512             } else {
513                 revert(errorMessage);
514             }
515         }
516     }
517 }
518 
519 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
520 
521 
522 
523 pragma solidity ^0.8.0;
524 
525 
526 /**
527  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
528  * @dev See https://eips.ethereum.org/EIPS/eip-721
529  */
530 interface IERC721Metadata is IERC721 {
531     /**
532      * @dev Returns the token collection name.
533      */
534     function name() external view returns (string memory);
535 
536     /**
537      * @dev Returns the token collection symbol.
538      */
539     function symbol() external view returns (string memory);
540 
541     /**
542      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
543      */
544     function tokenURI(uint256 tokenId) external view returns (string memory);
545 }
546 
547 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
548 
549 
550 
551 pragma solidity ^0.8.0;
552 
553 /**
554  * @title ERC721 token receiver interface
555  * @dev Interface for any contract that wants to support safeTransfers
556  * from ERC721 asset contracts.
557  */
558 interface IERC721Receiver {
559     /**
560      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
561      * by `operator` from `from`, this function is called.
562      *
563      * It must return its Solidity selector to confirm the token transfer.
564      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
565      *
566      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
567      */
568     function onERC721Received(
569         address operator,
570         address from,
571         uint256 tokenId,
572         bytes calldata data
573     ) external returns (bytes4);
574 }
575 
576 // File: @openzeppelin/contracts/utils/Context.sol
577 pragma solidity ^0.8.0;
578 /**
579  * @dev Provides information about the current execution context, including the
580  * sender of the transaction and its data. While these are generally available
581  * via msg.sender and msg.data, they should not be accessed in such a direct
582  * manner, since when dealing with meta-transactions the account sending and
583  * paying for execution may not be the actual sender (as far as an application
584  * is concerned).
585  *
586  * This contract is only required for intermediate, library-like contracts.
587  */
588 abstract contract Context {
589     function _msgSender() internal view virtual returns (address) {
590         return msg.sender;
591     }
592 
593     function _msgData() internal view virtual returns (bytes calldata) {
594         return msg.data;
595     }
596 }
597 
598 // File: @openzeppelin/contracts/utils/Math.sol
599 pragma solidity ^0.8.0;
600 
601 library SafeMath {
602 
603     function add(uint256 a, uint256 b) internal pure returns (uint256) {
604         uint256 c = a + b;
605         require(c >= a, "SafeMath: addition overflow");
606 
607         return c;
608     }
609 
610     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
611         return sub(a, b, "SafeMath: subtraction overflow");
612     }
613 
614     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
615         require(b <= a, errorMessage);
616         uint256 c = a - b;
617 
618         return c;
619     }
620 
621     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
622         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
623         // benefit is lost if 'b' is also tested.
624         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
625         if (a == 0) {
626             return 0;
627         }
628 
629         uint256 c = a * b;
630         require(c / a == b, "SafeMath: multiplication overflow");
631 
632         return c;
633     }
634 
635     function div(uint256 a, uint256 b) internal pure returns (uint256) {
636         return div(a, b, "SafeMath: division by zero");
637     }
638 
639     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
640         // Solidity only automatically asserts when dividing by 0
641         require(b > 0, errorMessage);
642         uint256 c = a / b;
643         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
644 
645         return c;
646     }
647 
648     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
649         return mod(a, b, "SafeMath: modulo by zero");
650     }
651 
652     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
653         require(b != 0, errorMessage);
654         return a % b;
655     }
656 }
657 
658 
659 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
660 pragma solidity ^0.8.0;
661 /**
662  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
663  * the Metadata extension, but not including the Enumerable extension, which is available separately as
664  * {ERC721Enumerable}.
665  */
666 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
667     using Address for address;
668     using Strings for uint256;
669 
670     // Token name
671     string private _name;
672 
673     // Token symbol
674     string private _symbol;
675 
676     // Mapping from token ID to owner address
677     mapping(uint256 => address) private _owners;
678 
679     // Mapping owner address to token count
680     mapping(address => uint256) private _balances;
681 
682     // Mapping from token ID to approved address
683     mapping(uint256 => address) private _tokenApprovals;
684 
685     // Mapping from owner to operator approvals
686     mapping(address => mapping(address => bool)) private _operatorApprovals;
687 
688     /**
689      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
690      */
691     constructor(string memory name_, string memory symbol_) {
692         _name = name_;
693         _symbol = symbol_;
694     }
695 
696     /**
697      * @dev See {IERC165-supportsInterface}.
698      */
699     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
700         return
701             interfaceId == type(IERC721).interfaceId ||
702             interfaceId == type(IERC721Metadata).interfaceId ||
703             super.supportsInterface(interfaceId);
704     }
705 
706     /**
707      * @dev See {IERC721-balanceOf}.
708      */
709     function balanceOf(address owner) public view virtual override returns (uint256) {
710         require(owner != address(0), "ERC721: balance query for the zero address");
711         return _balances[owner];
712     }
713 
714     /**
715      * @dev See {IERC721-ownerOf}.
716      */
717     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
718         address owner = _owners[tokenId];
719         require(owner != address(0), "ERC721: owner query for nonexistent token");
720         return owner;
721     }
722 
723     /**
724      * @dev See {IERC721Metadata-name}.
725      */
726     function name() public view virtual override returns (string memory) {
727         return _name;
728     }
729 
730     /**
731      * @dev See {IERC721Metadata-symbol}.
732      */
733     function symbol() public view virtual override returns (string memory) {
734         return _symbol;
735     }
736 
737     /**
738      * @dev See {IERC721Metadata-tokenURI}.
739      */
740     function tokenURI(uint256 tokenId) external view virtual override returns (string memory) {
741         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
742 
743         string memory baseURI = _baseURI();
744         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
745     }
746 
747     /**
748      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
749      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
750      * by default, can be overriden in child contracts.
751      */
752     function _baseURI() internal view virtual returns (string memory) {
753         return "";
754     }
755 
756     /**
757      * @dev See {IERC721-approve}.
758      */
759     function approve(address to, uint256 tokenId) public virtual override {
760         address owner = ERC721.ownerOf(tokenId);
761         require(to != owner, "ERC721: approval to current owner");
762 
763         require(
764             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
765             "ERC721: approve caller is not owner nor approved for all"
766         );
767 
768         _approve(to, tokenId);
769     }
770 
771     /**
772      * @dev See {IERC721-getApproved}.
773      */
774     function getApproved(uint256 tokenId) public view virtual override returns (address) {
775         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
776 
777         return _tokenApprovals[tokenId];
778     }
779 
780     /**
781      * @dev See {IERC721-setApprovalForAll}.
782      */
783     function setApprovalForAll(address operator, bool approved) public virtual override {
784         require(operator != _msgSender(), "ERC721: approve to caller");
785 
786         _operatorApprovals[_msgSender()][operator] = approved;
787         emit ApprovalForAll(_msgSender(), operator, approved);
788     }
789 
790     /**
791      * @dev See {IERC721-isApprovedForAll}.
792      */
793     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
794         return _operatorApprovals[owner][operator];
795     }
796 
797     /**
798      * @dev See {IERC721-transferFrom}.
799      */
800     function transferFrom(
801         address from,
802         address to,
803         uint256 tokenId
804     ) public virtual override {
805         //solhint-disable-next-line max-line-length
806         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
807 
808         _transfer(from, to, tokenId);
809     }
810 
811     /**
812      * @dev See {IERC721-safeTransferFrom}.
813      */
814     function safeTransferFrom(
815         address from,
816         address to,
817         uint256 tokenId
818     ) public virtual override {
819         safeTransferFrom(from, to, tokenId, "");
820     }
821 
822     /**
823      * @dev See {IERC721-safeTransferFrom}.
824      */
825     function safeTransferFrom(
826         address from,
827         address to,
828         uint256 tokenId,
829         bytes memory _data
830     ) public virtual override {
831         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
832         _safeTransfer(from, to, tokenId, _data);
833     }
834 
835     /**
836      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
837      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
838      *
839      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
840      *
841      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
842      * implement alternative mechanisms to perform token transfer, such as signature-based.
843      *
844      * Requirements:
845      *
846      * - `from` cannot be the zero address.
847      * - `to` cannot be the zero address.
848      * - `tokenId` token must exist and be owned by `from`.
849      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
850      *
851      * Emits a {Transfer} event.
852      */
853     function _safeTransfer(
854         address from,
855         address to,
856         uint256 tokenId,
857         bytes memory _data
858     ) internal virtual {
859         _transfer(from, to, tokenId);
860         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
861     }
862 
863     /**
864      * @dev Returns whether `tokenId` exists.
865      *
866      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
867      *
868      * Tokens start existing when they are minted (`_mint`),
869      * and stop existing when they are burned (`_burn`).
870      */
871     function _exists(uint256 tokenId) internal view virtual returns (bool) {
872         return _owners[tokenId] != address(0);
873     }
874 
875     /**
876      * @dev Returns whether `spender` is allowed to manage `tokenId`.
877      *
878      * Requirements:
879      *
880      * - `tokenId` must exist.
881      */
882     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
883         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
884         address owner = ERC721.ownerOf(tokenId);
885         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
886     }
887 
888     /**
889      * @dev Safely mints `tokenId` and transfers it to `to`.
890      *
891      * Requirements:
892      *
893      * - `tokenId` must not exist.
894      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
895      *
896      * Emits a {Transfer} event.
897      */
898     function _safeMint(address to, uint256 tokenId) internal virtual {
899         _safeMint(to, tokenId, "");
900     }
901 
902     /**
903      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
904      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
905      */
906     function _safeMint(
907         address to,
908         uint256 tokenId,
909         bytes memory _data
910     ) internal virtual {
911         _mint(to, tokenId);
912         require(
913             _checkOnERC721Received(address(0), to, tokenId, _data),
914             "ERC721: transfer to non ERC721Receiver implementer"
915         );
916     }
917 
918     /**
919      * @dev Mints `tokenId` and transfers it to `to`.
920      *
921      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
922      *
923      * Requirements:
924      *
925      * - `tokenId` must not exist.
926      * - `to` cannot be the zero address.
927      *
928      * Emits a {Transfer} event.
929      */
930     function _mint(address to, uint256 tokenId) internal virtual {
931         require(to != address(0), "ERC721: mint to the zero address");
932         require(!_exists(tokenId), "ERC721: token already minted");
933 
934         _beforeTokenTransfer(address(0), to, tokenId);
935 
936         _balances[to] += 1;
937         _owners[tokenId] = to;
938 
939         emit Transfer(address(0), to, tokenId);
940     }
941 
942     /**
943      * @dev Destroys `tokenId`.
944      * The approval is cleared when the token is burned.
945      *
946      * Requirements:
947      *
948      * - `tokenId` must exist.
949      *
950      * Emits a {Transfer} event.
951      */
952     function _burn(uint256 tokenId) internal virtual {
953         address owner = ERC721.ownerOf(tokenId);
954 
955         _beforeTokenTransfer(owner, address(0), tokenId);
956 
957         // Clear approvals
958         _approve(address(0), tokenId);
959 
960         _balances[owner] -= 1;
961         delete _owners[tokenId];
962 
963         emit Transfer(owner, address(0), tokenId);
964     }
965 
966     /**
967      * @dev Transfers `tokenId` from `from` to `to`.
968      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
969      *
970      * Requirements:
971      *
972      * - `to` cannot be the zero address.
973      * - `tokenId` token must be owned by `from`.
974      *
975      * Emits a {Transfer} event.
976      */
977     function _transfer(
978         address from,
979         address to,
980         uint256 tokenId
981     ) internal virtual {
982         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
983         require(to != address(0), "ERC721: transfer to the zero address");
984 
985         _beforeTokenTransfer(from, to, tokenId);
986 
987         // Clear approvals from the previous owner
988         _approve(address(0), tokenId);
989 
990         _balances[from] -= 1;
991         _balances[to] += 1;
992         _owners[tokenId] = to;
993 
994         emit Transfer(from, to, tokenId);
995     }
996 
997     /**
998      * @dev Approve `to` to operate on `tokenId`
999      *
1000      * Emits a {Approval} event.
1001      */
1002     function _approve(address to, uint256 tokenId) internal virtual {
1003         _tokenApprovals[tokenId] = to;
1004         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1005     }
1006 
1007     /**
1008      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1009      * The call is not executed if the target address is not a contract.
1010      *
1011      * @param from address representing the previous owner of the given token ID
1012      * @param to target address that will receive the tokens
1013      * @param tokenId uint256 ID of the token to be transferred
1014      * @param _data bytes optional data to send along with the call
1015      * @return bool whether the call correctly returned the expected magic value
1016      */
1017     function _checkOnERC721Received(
1018         address from,
1019         address to,
1020         uint256 tokenId,
1021         bytes memory _data
1022     ) private returns (bool) {
1023         if (to.isContract()) {
1024             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1025                 return retval == IERC721Receiver.onERC721Received.selector;
1026             } catch (bytes memory reason) {
1027                 if (reason.length == 0) {
1028                     revert("ERC721: transfer to non ERC721Receiver implementer");
1029                 } else {
1030                     assembly {
1031                         revert(add(32, reason), mload(reason))
1032                     }
1033                 }
1034             }
1035         } else {
1036             return true;
1037         }
1038     }
1039 
1040     /**
1041      * @dev Hook that is called before any token transfer. This includes minting
1042      * and burning.
1043      *
1044      * Calling conditions:
1045      *
1046      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1047      * transferred to `to`.
1048      * - When `from` is zero, `tokenId` will be minted for `to`.
1049      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1050      * - `from` and `to` are never both zero.
1051      *
1052      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1053      */
1054     function _beforeTokenTransfer(
1055         address from,
1056         address to,
1057         uint256 tokenId
1058     ) internal virtual {}
1059 }
1060 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1061 
1062 pragma solidity ^0.8.0;
1063 
1064 /**
1065  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1066  * enumerability of all the token ids in the contract as well as all token ids owned by each
1067  * account.
1068  */
1069 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1070     // Mapping from owner to list of owned token IDs
1071     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1072 
1073     // Mapping from token ID to index of the owner tokens list
1074     mapping(uint256 => uint256) private _ownedTokensIndex;
1075 
1076     // Array with all token ids, used for enumeration
1077     uint256[] private _allTokens;
1078 
1079     // Mapping from token id to position in the allTokens array
1080     mapping(uint256 => uint256) private _allTokensIndex;
1081 
1082     /**
1083      * @dev See {IERC165-supportsInterface}.
1084      */
1085     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1086         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1087     }
1088 
1089     /**
1090      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1091      */
1092     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1093         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1094         return _ownedTokens[owner][index];
1095     }
1096 
1097     /**
1098      * @dev See {IERC721Enumerable-totalSupply}.
1099      */
1100     function totalSupply() public view virtual override returns (uint256) {
1101         return _allTokens.length;
1102     }
1103 
1104     /**
1105      * @dev See {IERC721Enumerable-tokenByIndex}.
1106      */
1107     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1108         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1109         return _allTokens[index];
1110     }
1111 
1112     /**
1113      * @dev Hook that is called before any token transfer. This includes minting
1114      * and burning.
1115      *
1116      * Calling conditions:
1117      *
1118      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1119      * transferred to `to`.
1120      * - When `from` is zero, `tokenId` will be minted for `to`.
1121      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1122      * - `from` cannot be the zero address.
1123      * - `to` cannot be the zero address.
1124      *
1125      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1126      */
1127     function _beforeTokenTransfer(
1128         address from,
1129         address to,
1130         uint256 tokenId
1131     ) internal virtual override {
1132         super._beforeTokenTransfer(from, to, tokenId);
1133 
1134         if (from == address(0)) {
1135             _addTokenToAllTokensEnumeration(tokenId);
1136         } else if (from != to) {
1137             _removeTokenFromOwnerEnumeration(from, tokenId);
1138         }
1139         if (to == address(0)) {
1140             _removeTokenFromAllTokensEnumeration(tokenId);
1141         } else if (to != from) {
1142             _addTokenToOwnerEnumeration(to, tokenId);
1143         }
1144     }
1145 
1146     /**
1147      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1148      * @param to address representing the new owner of the given token ID
1149      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1150      */
1151     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1152         uint256 length = ERC721.balanceOf(to);
1153         _ownedTokens[to][length] = tokenId;
1154         _ownedTokensIndex[tokenId] = length;
1155     }
1156 
1157     /**
1158      * @dev Private function to add a token to this extension's token tracking data structures.
1159      * @param tokenId uint256 ID of the token to be added to the tokens list
1160      */
1161     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1162         _allTokensIndex[tokenId] = _allTokens.length;
1163         _allTokens.push(tokenId);
1164     }
1165 
1166     /**
1167      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1168      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1169      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1170      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1171      * @param from address representing the previous owner of the given token ID
1172      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1173      */
1174     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1175         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1176         // then delete the last slot (swap and pop).
1177 
1178         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1179         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1180 
1181         // When the token to delete is the last token, the swap operation is unnecessary
1182         if (tokenIndex != lastTokenIndex) {
1183             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1184 
1185             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1186             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1187         }
1188 
1189         // This also deletes the contents at the last position of the array
1190         delete _ownedTokensIndex[tokenId];
1191         delete _ownedTokens[from][lastTokenIndex];
1192     }
1193 
1194     /**
1195      * @dev Private function to remove a token from this extension's token tracking data structures.
1196      * This has O(1) time complexity, but alters the order of the _allTokens array.
1197      * @param tokenId uint256 ID of the token to be removed from the tokens list
1198      */
1199     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1200         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1201         // then delete the last slot (swap and pop).
1202 
1203         uint256 lastTokenIndex = _allTokens.length - 1;
1204         uint256 tokenIndex = _allTokensIndex[tokenId];
1205 
1206         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1207         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1208         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1209         uint256 lastTokenId = _allTokens[lastTokenIndex];
1210 
1211         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1212         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1213 
1214         // This also deletes the contents at the last position of the array
1215         delete _allTokensIndex[tokenId];
1216         _allTokens.pop();
1217     }
1218 }
1219 
1220 
1221 // File: @openzeppelin/contracts/access/Ownable.sol
1222 pragma solidity ^0.8.0;
1223 /**
1224  * @dev Contract module which provides a basic access control mechanism, where
1225  * there is an account (an owner) that can be granted exclusive access to
1226  * specific functions.
1227  *
1228  * By default, the owner account will be the one that deploys the contract. This
1229  * can later be changed with {transferOwnership}.
1230  *
1231  * This module is used through inheritance. It will make available the modifier
1232  * `onlyOwner`, which can be applied to your functions to restrict their use to
1233  * the owner.
1234  */
1235 abstract contract Ownable is Context {
1236     address private _owner;
1237 
1238     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1239 
1240     /**
1241      * @dev Initializes the contract setting the deployer as the initial owner.
1242      */
1243     constructor() {
1244         _setOwner(_msgSender());
1245     }
1246 
1247     /**
1248      * @dev Returns the address of the current owner.
1249      */
1250     function owner() public view virtual returns (address) {
1251         return _owner;
1252     }
1253 
1254     /**
1255      * @dev Throws if called by any account other than the owner.
1256      */
1257     modifier onlyOwner() {
1258         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1259         _;
1260     }
1261 
1262     /**
1263      * @dev Leaves the contract without owner. It will not be possible to call
1264      * `onlyOwner` functions anymore. Can only be called by the current owner.
1265      *
1266      * NOTE: Renouncing ownership will leave the contract without an owner,
1267      * thereby removing any functionality that is only available to the owner.
1268      */
1269     function renounceOwnership() public virtual onlyOwner {
1270         _setOwner(address(0));
1271     }
1272 
1273     /**
1274      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1275      * Can only be called by the current owner.
1276      */
1277     function transferOwnership(address newOwner) public virtual onlyOwner {
1278         require(newOwner != address(0), "Ownable: new owner is the zero address");
1279         _setOwner(newOwner);
1280     }
1281 
1282     function _setOwner(address newOwner) private {
1283         address oldOwner = _owner;
1284         _owner = newOwner;
1285         emit OwnershipTransferred(oldOwner, newOwner);
1286     }
1287 }
1288 
1289 
1290 pragma solidity >=0.7.0 <0.9.0;
1291 
1292 contract KnightsOfChain is ERC721Enumerable, Ownable {
1293   using Strings for uint256;
1294   using SafeMath for uint256;
1295 
1296   string private baseURI;
1297   uint256 public cost = 0.10 ether;
1298   uint256 public maxSupply = 9999;
1299   uint256 public maxMintAmount = 2;
1300   uint256 public nftPerAddressLimit = 2;
1301   uint256 public nftGiveawayLimit = 1;
1302   bool public paused = false;
1303   bool public revealed = false;
1304   bool public onlyWhitelisted = true;
1305 
1306   mapping(address => uint256) public addressMintedBalance;
1307   mapping(address=>bool) public whitelistedAddresses;
1308   mapping(address=>bool) public giveawayAddresses;
1309 
1310   constructor(
1311     string memory _name,
1312     string memory _symbol
1313   ) ERC721(_name, _symbol) {
1314   }
1315 
1316   function _baseURI() internal view virtual override returns (string memory) {
1317     return baseURI;
1318   }
1319 
1320   function mint(uint256 _mintAmount) external payable {
1321     require(!paused, "the contract is paused");
1322     uint256 supply = totalSupply();
1323     uint256 differCost = cost;
1324 
1325     require(_mintAmount > 0, "Need to mint at least 1 NFT");
1326     require(_mintAmount <= maxMintAmount, "Maximum mint amount per session exceeded - please try again.");
1327     require(supply.add(_mintAmount) <= maxSupply, "All NFTs have been minted.");
1328 
1329     if (msg.sender != owner()) {
1330 
1331         uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1332         require(ownerMintedCount.add(_mintAmount) <= nftPerAddressLimit, "You have reached the maximum number of NFTs allowed.");
1333         
1334         if(onlyWhitelisted) {
1335             require(isWhitelisted(msg.sender), "This wallet ID has not been whitelisted");
1336            
1337         }
1338 
1339         if(giveawayList(msg.sender) ){
1340             require(_mintAmount <= nftGiveawayLimit, "We only offer 1 free giveaway per address.");
1341             giveawayAddresses[msg.sender] = false;
1342             differCost = 0;
1343         }
1344 
1345         uint256 totalCost = differCost.mul(_mintAmount);
1346         require(msg.value >= totalCost, "insufficient funds");
1347         //return dust eth to the sender
1348         if(msg.value > totalCost){
1349           uint256 dustEth = msg.value - totalCost;
1350           (bool success,) = msg.sender.call{value: dustEth}("");
1351           require(success);
1352         }
1353     }
1354 
1355     addressMintedBalance[msg.sender] = addressMintedBalance[msg.sender].add(_mintAmount);
1356     
1357     for (uint256 i = 1; i <= _mintAmount; i++) {
1358       _safeMint(msg.sender, supply.add(i));
1359     }
1360 
1361   }
1362   
1363 
1364   
1365   
1366   function isWhitelisted(address _user) public view returns (bool) {
1367       return whitelistedAddresses[_user];
1368   }
1369   
1370   function giveawayList(address _user) public view returns (bool) {
1371       return giveawayAddresses[_user];
1372   }
1373 
1374   function walletOfOwner(address _owner)
1375     public
1376     view
1377     returns (uint256[] memory)
1378   {
1379     uint256 ownerTokenCount = balanceOf(_owner);
1380     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1381     for (uint256 i; i < ownerTokenCount; i++) {
1382       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1383     }
1384     return tokenIds;
1385   }
1386 
1387   function tokenURI(uint256 tokenId)
1388     external
1389     view
1390     virtual
1391     override
1392     returns (string memory)
1393   {
1394     require(
1395       _exists(tokenId),
1396       "ERC721Metadata: URI query for nonexistent token"
1397     );
1398     
1399     if(revealed == false) {
1400         
1401         return "ipfs://QmRrYSUH8TZUvkPqxXyMcpAcnLNb6sYtPLbmMp3TtnZMU9/hidden.json";
1402     }
1403 
1404     string memory currentBaseURI = _baseURI();
1405     return bytes(currentBaseURI).length > 0
1406         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), ".json"))
1407         : "";
1408   }
1409 
1410   //only owner
1411   function reveal() external onlyOwner {
1412       revealed = true;
1413   }
1414   
1415   function setNftPerAddressLimit(uint256 _limit) external onlyOwner {
1416     nftPerAddressLimit = _limit;
1417   }
1418   
1419   function setCost(uint256 _newCost) external onlyOwner {
1420     cost = _newCost;
1421   }
1422 
1423   function setmaxMintAmount(uint256 _newmaxMintAmount) external onlyOwner {
1424     maxMintAmount = _newmaxMintAmount;
1425   }
1426 
1427   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1428     baseURI = _newBaseURI;
1429   }
1430 
1431   function pause() external onlyOwner {
1432     paused = !paused;
1433   }
1434   
1435   function setOnlyWhitelisted() external onlyOwner {
1436     onlyWhitelisted = !onlyWhitelisted;
1437   }
1438   
1439   function addWhitelistUsers(address[] calldata _users) external onlyOwner {
1440     for(uint i=0; i<_users.length; i++){
1441         whitelistedAddresses[_users[i]] = true;
1442     }
1443   }
1444   
1445   function addGiveawayUsers(address[] calldata _users) external onlyOwner {
1446     for (uint i = 0; i < _users.length; i++) {
1447       giveawayAddresses[_users[i]] = true;
1448     }
1449   }
1450 
1451  
1452   function withdraw() external payable onlyOwner {
1453     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1454     require(os);
1455   }
1456 }