1 // Dependency file: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 // SPDX-License-Identifier: MIT
4 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
5 
6 // pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Interface of the ERC20 standard as defined in the EIP.
10  */
11 interface IERC20 {
12     /**
13      * @dev Returns the amount of tokens in existence.
14      */
15     function totalSupply() external view returns (uint256);
16 
17     /**
18      * @dev Returns the amount of tokens owned by `account`.
19      */
20     function balanceOf(address account) external view returns (uint256);
21 
22     /**
23      * @dev Moves `amount` tokens from the caller's account to `to`.
24      *
25      * Returns a boolean value indicating whether the operation succeeded.
26      *
27      * Emits a {Transfer} event.
28      */
29     function transfer(address to, uint256 amount) external returns (bool);
30 
31     /**
32      * @dev Returns the remaining number of tokens that `spender` will be
33      * allowed to spend on behalf of `owner` through {transferFrom}. This is
34      * zero by default.
35      *
36      * This value changes when {approve} or {transferFrom} are called.
37      */
38     function allowance(address owner, address spender) external view returns (uint256);
39 
40     /**
41      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
42      *
43      * Returns a boolean value indicating whether the operation succeeded.
44      *
45      * IMPORTANT: Beware that changing an allowance with this method brings the risk
46      * that someone may use both the old and the new allowance by unfortunate
47      * transaction ordering. One possible solution to mitigate this race
48      * condition is to first reduce the spender's allowance to 0 and set the
49      * desired value afterwards:
50      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
51      *
52      * Emits an {Approval} event.
53      */
54     function approve(address spender, uint256 amount) external returns (bool);
55 
56     /**
57      * @dev Moves `amount` tokens from `from` to `to` using the
58      * allowance mechanism. `amount` is then deducted from the caller's
59      * allowance.
60      *
61      * Returns a boolean value indicating whether the operation succeeded.
62      *
63      * Emits a {Transfer} event.
64      */
65     function transferFrom(
66         address from,
67         address to,
68         uint256 amount
69     ) external returns (bool);
70 
71     /**
72      * @dev Emitted when `value` tokens are moved from one account (`from`) to
73      * another (`to`).
74      *
75      * Note that `value` may be zero.
76      */
77     event Transfer(address indexed from, address indexed to, uint256 value);
78 
79     /**
80      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
81      * a call to {approve}. `value` is the new allowance.
82      */
83     event Approval(address indexed owner, address indexed spender, uint256 value);
84 }
85 
86 
87 // Dependency file: @openzeppelin/contracts/utils/introspection/IERC165.sol
88 
89 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
90 
91 // pragma solidity ^0.8.0;
92 
93 /**
94  * @dev Interface of the ERC165 standard, as defined in the
95  * https://eips.ethereum.org/EIPS/eip-165[EIP].
96  *
97  * Implementers can declare support of contract interfaces, which can then be
98  * queried by others ({ERC165Checker}).
99  *
100  * For an implementation, see {ERC165}.
101  */
102 interface IERC165 {
103     /**
104      * @dev Returns true if this contract implements the interface defined by
105      * `interfaceId`. See the corresponding
106      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
107      * to learn more about how these ids are created.
108      *
109      * This function call must use less than 30 000 gas.
110      */
111     function supportsInterface(bytes4 interfaceId) external view returns (bool);
112 }
113 
114 
115 // Dependency file: @openzeppelin/contracts/token/ERC721/IERC721.sol
116 
117 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
118 
119 // pragma solidity ^0.8.0;
120 
121 // import "@openzeppelin/contracts/utils/introspection/IERC165.sol";
122 
123 /**
124  * @dev Required interface of an ERC721 compliant contract.
125  */
126 interface IERC721 is IERC165 {
127     /**
128      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
129      */
130     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
131 
132     /**
133      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
134      */
135     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
136 
137     /**
138      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
139      */
140     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
141 
142     /**
143      * @dev Returns the number of tokens in ``owner``'s account.
144      */
145     function balanceOf(address owner) external view returns (uint256 balance);
146 
147     /**
148      * @dev Returns the owner of the `tokenId` token.
149      *
150      * Requirements:
151      *
152      * - `tokenId` must exist.
153      */
154     function ownerOf(uint256 tokenId) external view returns (address owner);
155 
156     /**
157      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
158      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
159      *
160      * Requirements:
161      *
162      * - `from` cannot be the zero address.
163      * - `to` cannot be the zero address.
164      * - `tokenId` token must exist and be owned by `from`.
165      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
166      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
167      *
168      * Emits a {Transfer} event.
169      */
170     function safeTransferFrom(
171         address from,
172         address to,
173         uint256 tokenId
174     ) external;
175 
176     /**
177      * @dev Transfers `tokenId` token from `from` to `to`.
178      *
179      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
180      *
181      * Requirements:
182      *
183      * - `from` cannot be the zero address.
184      * - `to` cannot be the zero address.
185      * - `tokenId` token must be owned by `from`.
186      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
187      *
188      * Emits a {Transfer} event.
189      */
190     function transferFrom(
191         address from,
192         address to,
193         uint256 tokenId
194     ) external;
195 
196     /**
197      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
198      * The approval is cleared when the token is transferred.
199      *
200      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
201      *
202      * Requirements:
203      *
204      * - The caller must own the token or be an approved operator.
205      * - `tokenId` must exist.
206      *
207      * Emits an {Approval} event.
208      */
209     function approve(address to, uint256 tokenId) external;
210 
211     /**
212      * @dev Returns the account approved for `tokenId` token.
213      *
214      * Requirements:
215      *
216      * - `tokenId` must exist.
217      */
218     function getApproved(uint256 tokenId) external view returns (address operator);
219 
220     /**
221      * @dev Approve or remove `operator` as an operator for the caller.
222      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
223      *
224      * Requirements:
225      *
226      * - The `operator` cannot be the caller.
227      *
228      * Emits an {ApprovalForAll} event.
229      */
230     function setApprovalForAll(address operator, bool _approved) external;
231 
232     /**
233      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
234      *
235      * See {setApprovalForAll}
236      */
237     function isApprovedForAll(address owner, address operator) external view returns (bool);
238 
239     /**
240      * @dev Safely transfers `tokenId` token from `from` to `to`.
241      *
242      * Requirements:
243      *
244      * - `from` cannot be the zero address.
245      * - `to` cannot be the zero address.
246      * - `tokenId` token must exist and be owned by `from`.
247      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
248      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
249      *
250      * Emits a {Transfer} event.
251      */
252     function safeTransferFrom(
253         address from,
254         address to,
255         uint256 tokenId,
256         bytes calldata data
257     ) external;
258 }
259 
260 
261 // Dependency file: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
262 
263 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
264 
265 // pragma solidity ^0.8.0;
266 
267 /**
268  * @title ERC721 token receiver interface
269  * @dev Interface for any contract that wants to support safeTransfers
270  * from ERC721 asset contracts.
271  */
272 interface IERC721Receiver {
273     /**
274      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
275      * by `operator` from `from`, this function is called.
276      *
277      * It must return its Solidity selector to confirm the token transfer.
278      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
279      *
280      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
281      */
282     function onERC721Received(
283         address operator,
284         address from,
285         uint256 tokenId,
286         bytes calldata data
287     ) external returns (bytes4);
288 }
289 
290 
291 // Dependency file: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
292 
293 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
294 
295 // pragma solidity ^0.8.0;
296 
297 // import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
298 
299 /**
300  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
301  * @dev See https://eips.ethereum.org/EIPS/eip-721
302  */
303 interface IERC721Metadata is IERC721 {
304     /**
305      * @dev Returns the token collection name.
306      */
307     function name() external view returns (string memory);
308 
309     /**
310      * @dev Returns the token collection symbol.
311      */
312     function symbol() external view returns (string memory);
313 
314     /**
315      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
316      */
317     function tokenURI(uint256 tokenId) external view returns (string memory);
318 }
319 
320 
321 // Dependency file: @openzeppelin/contracts/utils/Address.sol
322 
323 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
324 
325 // pragma solidity ^0.8.1;
326 
327 /**
328  * @dev Collection of functions related to the address type
329  */
330 library Address {
331     /**
332      * @dev Returns true if `account` is a contract.
333      *
334      * [IMPORTANT]
335      * ====
336      * It is unsafe to assume that an address for which this function returns
337      * false is an externally-owned account (EOA) and not a contract.
338      *
339      * Among others, `isContract` will return false for the following
340      * types of addresses:
341      *
342      *  - an externally-owned account
343      *  - a contract in construction
344      *  - an address where a contract will be created
345      *  - an address where a contract lived, but was destroyed
346      * ====
347      *
348      * [IMPORTANT]
349      * ====
350      * You shouldn't rely on `isContract` to protect against flash loan attacks!
351      *
352      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
353      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
354      * constructor.
355      * ====
356      */
357     function isContract(address account) internal view returns (bool) {
358         // This method relies on extcodesize/address.code.length, which returns 0
359         // for contracts in construction, since the code is only stored at the end
360         // of the constructor execution.
361 
362         return account.code.length > 0;
363     }
364 
365     /**
366      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
367      * `recipient`, forwarding all available gas and reverting on errors.
368      *
369      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
370      * of certain opcodes, possibly making contracts go over the 2300 gas limit
371      * imposed by `transfer`, making them unable to receive funds via
372      * `transfer`. {sendValue} removes this limitation.
373      *
374      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
375      *
376      * IMPORTANT: because control is transferred to `recipient`, care must be
377      * taken to not create reentrancy vulnerabilities. Consider using
378      * {ReentrancyGuard} or the
379      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
380      */
381     function sendValue(address payable recipient, uint256 amount) internal {
382         require(address(this).balance >= amount, "Address: insufficient balance");
383 
384         (bool success, ) = recipient.call{value: amount}("");
385         require(success, "Address: unable to send value, recipient may have reverted");
386     }
387 
388     /**
389      * @dev Performs a Solidity function call using a low level `call`. A
390      * plain `call` is an unsafe replacement for a function call: use this
391      * function instead.
392      *
393      * If `target` reverts with a revert reason, it is bubbled up by this
394      * function (like regular Solidity function calls).
395      *
396      * Returns the raw returned data. To convert to the expected return value,
397      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
398      *
399      * Requirements:
400      *
401      * - `target` must be a contract.
402      * - calling `target` with `data` must not revert.
403      *
404      * _Available since v3.1._
405      */
406     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
407         return functionCall(target, data, "Address: low-level call failed");
408     }
409 
410     /**
411      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
412      * `errorMessage` as a fallback revert reason when `target` reverts.
413      *
414      * _Available since v3.1._
415      */
416     function functionCall(
417         address target,
418         bytes memory data,
419         string memory errorMessage
420     ) internal returns (bytes memory) {
421         return functionCallWithValue(target, data, 0, errorMessage);
422     }
423 
424     /**
425      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
426      * but also transferring `value` wei to `target`.
427      *
428      * Requirements:
429      *
430      * - the calling contract must have an ETH balance of at least `value`.
431      * - the called Solidity function must be `payable`.
432      *
433      * _Available since v3.1._
434      */
435     function functionCallWithValue(
436         address target,
437         bytes memory data,
438         uint256 value
439     ) internal returns (bytes memory) {
440         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
441     }
442 
443     /**
444      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
445      * with `errorMessage` as a fallback revert reason when `target` reverts.
446      *
447      * _Available since v3.1._
448      */
449     function functionCallWithValue(
450         address target,
451         bytes memory data,
452         uint256 value,
453         string memory errorMessage
454     ) internal returns (bytes memory) {
455         require(address(this).balance >= value, "Address: insufficient balance for call");
456         require(isContract(target), "Address: call to non-contract");
457 
458         (bool success, bytes memory returndata) = target.call{value: value}(data);
459         return verifyCallResult(success, returndata, errorMessage);
460     }
461 
462     /**
463      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
464      * but performing a static call.
465      *
466      * _Available since v3.3._
467      */
468     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
469         return functionStaticCall(target, data, "Address: low-level static call failed");
470     }
471 
472     /**
473      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
474      * but performing a static call.
475      *
476      * _Available since v3.3._
477      */
478     function functionStaticCall(
479         address target,
480         bytes memory data,
481         string memory errorMessage
482     ) internal view returns (bytes memory) {
483         require(isContract(target), "Address: static call to non-contract");
484 
485         (bool success, bytes memory returndata) = target.staticcall(data);
486         return verifyCallResult(success, returndata, errorMessage);
487     }
488 
489     /**
490      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
491      * but performing a delegate call.
492      *
493      * _Available since v3.4._
494      */
495     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
496         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
497     }
498 
499     /**
500      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
501      * but performing a delegate call.
502      *
503      * _Available since v3.4._
504      */
505     function functionDelegateCall(
506         address target,
507         bytes memory data,
508         string memory errorMessage
509     ) internal returns (bytes memory) {
510         require(isContract(target), "Address: delegate call to non-contract");
511 
512         (bool success, bytes memory returndata) = target.delegatecall(data);
513         return verifyCallResult(success, returndata, errorMessage);
514     }
515 
516     /**
517      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
518      * revert reason using the provided one.
519      *
520      * _Available since v4.3._
521      */
522     function verifyCallResult(
523         bool success,
524         bytes memory returndata,
525         string memory errorMessage
526     ) internal pure returns (bytes memory) {
527         if (success) {
528             return returndata;
529         } else {
530             // Look for revert reason and bubble it up if present
531             if (returndata.length > 0) {
532                 // The easiest way to bubble the revert reason is using memory via assembly
533 
534                 assembly {
535                     let returndata_size := mload(returndata)
536                     revert(add(32, returndata), returndata_size)
537                 }
538             } else {
539                 revert(errorMessage);
540             }
541         }
542     }
543 }
544 
545 
546 // Dependency file: @openzeppelin/contracts/utils/Context.sol
547 
548 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
549 
550 // pragma solidity ^0.8.0;
551 
552 /**
553  * @dev Provides information about the current execution context, including the
554  * sender of the transaction and its data. While these are generally available
555  * via msg.sender and msg.data, they should not be accessed in such a direct
556  * manner, since when dealing with meta-transactions the account sending and
557  * paying for execution may not be the actual sender (as far as an application
558  * is concerned).
559  *
560  * This contract is only required for intermediate, library-like contracts.
561  */
562 abstract contract Context {
563     function _msgSender() internal view virtual returns (address) {
564         return msg.sender;
565     }
566 
567     function _msgData() internal view virtual returns (bytes calldata) {
568         return msg.data;
569     }
570 }
571 
572 
573 // Dependency file: @openzeppelin/contracts/utils/Strings.sol
574 
575 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
576 
577 // pragma solidity ^0.8.0;
578 
579 /**
580  * @dev String operations.
581  */
582 library Strings {
583     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
584 
585     /**
586      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
587      */
588     function toString(uint256 value) internal pure returns (string memory) {
589         // Inspired by OraclizeAPI's implementation - MIT licence
590         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
591 
592         if (value == 0) {
593             return "0";
594         }
595         uint256 temp = value;
596         uint256 digits;
597         while (temp != 0) {
598             digits++;
599             temp /= 10;
600         }
601         bytes memory buffer = new bytes(digits);
602         while (value != 0) {
603             digits -= 1;
604             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
605             value /= 10;
606         }
607         return string(buffer);
608     }
609 
610     /**
611      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
612      */
613     function toHexString(uint256 value) internal pure returns (string memory) {
614         if (value == 0) {
615             return "0x00";
616         }
617         uint256 temp = value;
618         uint256 length = 0;
619         while (temp != 0) {
620             length++;
621             temp >>= 8;
622         }
623         return toHexString(value, length);
624     }
625 
626     /**
627      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
628      */
629     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
630         bytes memory buffer = new bytes(2 * length + 2);
631         buffer[0] = "0";
632         buffer[1] = "x";
633         for (uint256 i = 2 * length + 1; i > 1; --i) {
634             buffer[i] = _HEX_SYMBOLS[value & 0xf];
635             value >>= 4;
636         }
637         require(value == 0, "Strings: hex length insufficient");
638         return string(buffer);
639     }
640 }
641 
642 
643 // Dependency file: @openzeppelin/contracts/utils/introspection/ERC165.sol
644 
645 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
646 
647 // pragma solidity ^0.8.0;
648 
649 // import "@openzeppelin/contracts/utils/introspection/IERC165.sol";
650 
651 /**
652  * @dev Implementation of the {IERC165} interface.
653  *
654  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
655  * for the additional interface id that will be supported. For example:
656  *
657  * ```solidity
658  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
659  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
660  * }
661  * ```
662  *
663  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
664  */
665 abstract contract ERC165 is IERC165 {
666     /**
667      * @dev See {IERC165-supportsInterface}.
668      */
669     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
670         return interfaceId == type(IERC165).interfaceId;
671     }
672 }
673 
674 
675 // Dependency file: @openzeppelin/contracts/token/ERC721/ERC721.sol
676 
677 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
678 
679 // pragma solidity ^0.8.0;
680 
681 // import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
682 // import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
683 // import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol";
684 // import "@openzeppelin/contracts/utils/Address.sol";
685 // import "@openzeppelin/contracts/utils/Context.sol";
686 // import "@openzeppelin/contracts/utils/Strings.sol";
687 // import "@openzeppelin/contracts/utils/introspection/ERC165.sol";
688 
689 /**
690  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
691  * the Metadata extension, but not including the Enumerable extension, which is available separately as
692  * {ERC721Enumerable}.
693  */
694 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
695     using Address for address;
696     using Strings for uint256;
697 
698     // Token name
699     string private _name;
700 
701     // Token symbol
702     string private _symbol;
703 
704     // Mapping from token ID to owner address
705     mapping(uint256 => address) private _owners;
706 
707     // Mapping owner address to token count
708     mapping(address => uint256) private _balances;
709 
710     // Mapping from token ID to approved address
711     mapping(uint256 => address) private _tokenApprovals;
712 
713     // Mapping from owner to operator approvals
714     mapping(address => mapping(address => bool)) private _operatorApprovals;
715 
716     /**
717      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
718      */
719     constructor(string memory name_, string memory symbol_) {
720         _name = name_;
721         _symbol = symbol_;
722     }
723 
724     /**
725      * @dev See {IERC165-supportsInterface}.
726      */
727     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
728         return
729             interfaceId == type(IERC721).interfaceId ||
730             interfaceId == type(IERC721Metadata).interfaceId ||
731             super.supportsInterface(interfaceId);
732     }
733 
734     /**
735      * @dev See {IERC721-balanceOf}.
736      */
737     function balanceOf(address owner) public view virtual override returns (uint256) {
738         require(owner != address(0), "ERC721: balance query for the zero address");
739         return _balances[owner];
740     }
741 
742     /**
743      * @dev See {IERC721-ownerOf}.
744      */
745     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
746         address owner = _owners[tokenId];
747         require(owner != address(0), "ERC721: owner query for nonexistent token");
748         return owner;
749     }
750 
751     /**
752      * @dev See {IERC721Metadata-name}.
753      */
754     function name() public view virtual override returns (string memory) {
755         return _name;
756     }
757 
758     /**
759      * @dev See {IERC721Metadata-symbol}.
760      */
761     function symbol() public view virtual override returns (string memory) {
762         return _symbol;
763     }
764 
765     /**
766      * @dev See {IERC721Metadata-tokenURI}.
767      */
768     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
769         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
770 
771         string memory baseURI = _baseURI();
772         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
773     }
774 
775     /**
776      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
777      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
778      * by default, can be overriden in child contracts.
779      */
780     function _baseURI() internal view virtual returns (string memory) {
781         return "";
782     }
783 
784     /**
785      * @dev See {IERC721-approve}.
786      */
787     function approve(address to, uint256 tokenId) public virtual override {
788         address owner = ERC721.ownerOf(tokenId);
789         require(to != owner, "ERC721: approval to current owner");
790 
791         require(
792             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
793             "ERC721: approve caller is not owner nor approved for all"
794         );
795 
796         _approve(to, tokenId);
797     }
798 
799     /**
800      * @dev See {IERC721-getApproved}.
801      */
802     function getApproved(uint256 tokenId) public view virtual override returns (address) {
803         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
804 
805         return _tokenApprovals[tokenId];
806     }
807 
808     /**
809      * @dev See {IERC721-setApprovalForAll}.
810      */
811     function setApprovalForAll(address operator, bool approved) public virtual override {
812         _setApprovalForAll(_msgSender(), operator, approved);
813     }
814 
815     /**
816      * @dev See {IERC721-isApprovedForAll}.
817      */
818     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
819         return _operatorApprovals[owner][operator];
820     }
821 
822     /**
823      * @dev See {IERC721-transferFrom}.
824      */
825     function transferFrom(
826         address from,
827         address to,
828         uint256 tokenId
829     ) public virtual override {
830         //solhint-disable-next-line max-line-length
831         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
832 
833         _transfer(from, to, tokenId);
834     }
835 
836     /**
837      * @dev See {IERC721-safeTransferFrom}.
838      */
839     function safeTransferFrom(
840         address from,
841         address to,
842         uint256 tokenId
843     ) public virtual override {
844         safeTransferFrom(from, to, tokenId, "");
845     }
846 
847     /**
848      * @dev See {IERC721-safeTransferFrom}.
849      */
850     function safeTransferFrom(
851         address from,
852         address to,
853         uint256 tokenId,
854         bytes memory _data
855     ) public virtual override {
856         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
857         _safeTransfer(from, to, tokenId, _data);
858     }
859 
860     /**
861      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
862      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
863      *
864      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
865      *
866      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
867      * implement alternative mechanisms to perform token transfer, such as signature-based.
868      *
869      * Requirements:
870      *
871      * - `from` cannot be the zero address.
872      * - `to` cannot be the zero address.
873      * - `tokenId` token must exist and be owned by `from`.
874      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
875      *
876      * Emits a {Transfer} event.
877      */
878     function _safeTransfer(
879         address from,
880         address to,
881         uint256 tokenId,
882         bytes memory _data
883     ) internal virtual {
884         _transfer(from, to, tokenId);
885         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
886     }
887 
888     /**
889      * @dev Returns whether `tokenId` exists.
890      *
891      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
892      *
893      * Tokens start existing when they are minted (`_mint`),
894      * and stop existing when they are burned (`_burn`).
895      */
896     function _exists(uint256 tokenId) internal view virtual returns (bool) {
897         return _owners[tokenId] != address(0);
898     }
899 
900     /**
901      * @dev Returns whether `spender` is allowed to manage `tokenId`.
902      *
903      * Requirements:
904      *
905      * - `tokenId` must exist.
906      */
907     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
908         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
909         address owner = ERC721.ownerOf(tokenId);
910         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
911     }
912 
913     /**
914      * @dev Safely mints `tokenId` and transfers it to `to`.
915      *
916      * Requirements:
917      *
918      * - `tokenId` must not exist.
919      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
920      *
921      * Emits a {Transfer} event.
922      */
923     function _safeMint(address to, uint256 tokenId) internal virtual {
924         _safeMint(to, tokenId, "");
925     }
926 
927     /**
928      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
929      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
930      */
931     function _safeMint(
932         address to,
933         uint256 tokenId,
934         bytes memory _data
935     ) internal virtual {
936         _mint(to, tokenId);
937         require(
938             _checkOnERC721Received(address(0), to, tokenId, _data),
939             "ERC721: transfer to non ERC721Receiver implementer"
940         );
941     }
942 
943     /**
944      * @dev Mints `tokenId` and transfers it to `to`.
945      *
946      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
947      *
948      * Requirements:
949      *
950      * - `tokenId` must not exist.
951      * - `to` cannot be the zero address.
952      *
953      * Emits a {Transfer} event.
954      */
955     function _mint(address to, uint256 tokenId) internal virtual {
956         require(to != address(0), "ERC721: mint to the zero address");
957         require(!_exists(tokenId), "ERC721: token already minted");
958 
959         _beforeTokenTransfer(address(0), to, tokenId);
960 
961         _balances[to] += 1;
962         _owners[tokenId] = to;
963 
964         emit Transfer(address(0), to, tokenId);
965 
966         _afterTokenTransfer(address(0), to, tokenId);
967     }
968 
969     /**
970      * @dev Destroys `tokenId`.
971      * The approval is cleared when the token is burned.
972      *
973      * Requirements:
974      *
975      * - `tokenId` must exist.
976      *
977      * Emits a {Transfer} event.
978      */
979     function _burn(uint256 tokenId) internal virtual {
980         address owner = ERC721.ownerOf(tokenId);
981 
982         _beforeTokenTransfer(owner, address(0), tokenId);
983 
984         // Clear approvals
985         _approve(address(0), tokenId);
986 
987         _balances[owner] -= 1;
988         delete _owners[tokenId];
989 
990         emit Transfer(owner, address(0), tokenId);
991 
992         _afterTokenTransfer(owner, address(0), tokenId);
993     }
994 
995     /**
996      * @dev Transfers `tokenId` from `from` to `to`.
997      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
998      *
999      * Requirements:
1000      *
1001      * - `to` cannot be the zero address.
1002      * - `tokenId` token must be owned by `from`.
1003      *
1004      * Emits a {Transfer} event.
1005      */
1006     function _transfer(
1007         address from,
1008         address to,
1009         uint256 tokenId
1010     ) internal virtual {
1011         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1012         require(to != address(0), "ERC721: transfer to the zero address");
1013 
1014         _beforeTokenTransfer(from, to, tokenId);
1015 
1016         // Clear approvals from the previous owner
1017         _approve(address(0), tokenId);
1018 
1019         _balances[from] -= 1;
1020         _balances[to] += 1;
1021         _owners[tokenId] = to;
1022 
1023         emit Transfer(from, to, tokenId);
1024 
1025         _afterTokenTransfer(from, to, tokenId);
1026     }
1027 
1028     /**
1029      * @dev Approve `to` to operate on `tokenId`
1030      *
1031      * Emits a {Approval} event.
1032      */
1033     function _approve(address to, uint256 tokenId) internal virtual {
1034         _tokenApprovals[tokenId] = to;
1035         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1036     }
1037 
1038     /**
1039      * @dev Approve `operator` to operate on all of `owner` tokens
1040      *
1041      * Emits a {ApprovalForAll} event.
1042      */
1043     function _setApprovalForAll(
1044         address owner,
1045         address operator,
1046         bool approved
1047     ) internal virtual {
1048         require(owner != operator, "ERC721: approve to caller");
1049         _operatorApprovals[owner][operator] = approved;
1050         emit ApprovalForAll(owner, operator, approved);
1051     }
1052 
1053     /**
1054      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1055      * The call is not executed if the target address is not a contract.
1056      *
1057      * @param from address representing the previous owner of the given token ID
1058      * @param to target address that will receive the tokens
1059      * @param tokenId uint256 ID of the token to be transferred
1060      * @param _data bytes optional data to send along with the call
1061      * @return bool whether the call correctly returned the expected magic value
1062      */
1063     function _checkOnERC721Received(
1064         address from,
1065         address to,
1066         uint256 tokenId,
1067         bytes memory _data
1068     ) private returns (bool) {
1069         if (to.isContract()) {
1070             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1071                 return retval == IERC721Receiver.onERC721Received.selector;
1072             } catch (bytes memory reason) {
1073                 if (reason.length == 0) {
1074                     revert("ERC721: transfer to non ERC721Receiver implementer");
1075                 } else {
1076                     assembly {
1077                         revert(add(32, reason), mload(reason))
1078                     }
1079                 }
1080             }
1081         } else {
1082             return true;
1083         }
1084     }
1085 
1086     /**
1087      * @dev Hook that is called before any token transfer. This includes minting
1088      * and burning.
1089      *
1090      * Calling conditions:
1091      *
1092      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1093      * transferred to `to`.
1094      * - When `from` is zero, `tokenId` will be minted for `to`.
1095      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1096      * - `from` and `to` are never both zero.
1097      *
1098      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1099      */
1100     function _beforeTokenTransfer(
1101         address from,
1102         address to,
1103         uint256 tokenId
1104     ) internal virtual {}
1105 
1106     /**
1107      * @dev Hook that is called after any transfer of tokens. This includes
1108      * minting and burning.
1109      *
1110      * Calling conditions:
1111      *
1112      * - when `from` and `to` are both non-zero.
1113      * - `from` and `to` are never both zero.
1114      *
1115      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1116      */
1117     function _afterTokenTransfer(
1118         address from,
1119         address to,
1120         uint256 tokenId
1121     ) internal virtual {}
1122 }
1123 
1124 
1125 // Dependency file: @openzeppelin/contracts/access/Ownable.sol
1126 
1127 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1128 
1129 // pragma solidity ^0.8.0;
1130 
1131 // import "@openzeppelin/contracts/utils/Context.sol";
1132 
1133 /**
1134  * @dev Contract module which provides a basic access control mechanism, where
1135  * there is an account (an owner) that can be granted exclusive access to
1136  * specific functions.
1137  *
1138  * By default, the owner account will be the one that deploys the contract. This
1139  * can later be changed with {transferOwnership}.
1140  *
1141  * This module is used through inheritance. It will make available the modifier
1142  * `onlyOwner`, which can be applied to your functions to restrict their use to
1143  * the owner.
1144  */
1145 abstract contract Ownable is Context {
1146     address private _owner;
1147 
1148     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1149 
1150     /**
1151      * @dev Initializes the contract setting the deployer as the initial owner.
1152      */
1153     constructor() {
1154         _transferOwnership(_msgSender());
1155     }
1156 
1157     /**
1158      * @dev Returns the address of the current owner.
1159      */
1160     function owner() public view virtual returns (address) {
1161         return _owner;
1162     }
1163 
1164     /**
1165      * @dev Throws if called by any account other than the owner.
1166      */
1167     modifier onlyOwner() {
1168         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1169         _;
1170     }
1171 
1172     /**
1173      * @dev Leaves the contract without owner. It will not be possible to call
1174      * `onlyOwner` functions anymore. Can only be called by the current owner.
1175      *
1176      * NOTE: Renouncing ownership will leave the contract without an owner,
1177      * thereby removing any functionality that is only available to the owner.
1178      */
1179     function renounceOwnership() public virtual onlyOwner {
1180         _transferOwnership(address(0));
1181     }
1182 
1183     /**
1184      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1185      * Can only be called by the current owner.
1186      */
1187     function transferOwnership(address newOwner) public virtual onlyOwner {
1188         require(newOwner != address(0), "Ownable: new owner is the zero address");
1189         _transferOwnership(newOwner);
1190     }
1191 
1192     /**
1193      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1194      * Internal function without access restriction.
1195      */
1196     function _transferOwnership(address newOwner) internal virtual {
1197         address oldOwner = _owner;
1198         _owner = newOwner;
1199         emit OwnershipTransferred(oldOwner, newOwner);
1200     }
1201 }
1202 
1203 
1204 // Dependency file: @openzeppelin/contracts/utils/Counters.sol
1205 
1206 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
1207 
1208 // pragma solidity ^0.8.0;
1209 
1210 /**
1211  * @title Counters
1212  * @author Matt Condon (@shrugs)
1213  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1214  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1215  *
1216  * Include with `using Counters for Counters.Counter;`
1217  */
1218 library Counters {
1219     struct Counter {
1220         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1221         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1222         // this feature: see https://github.com/ethereum/solidity/issues/4637
1223         uint256 _value; // default: 0
1224     }
1225 
1226     function current(Counter storage counter) internal view returns (uint256) {
1227         return counter._value;
1228     }
1229 
1230     function increment(Counter storage counter) internal {
1231         unchecked {
1232             counter._value += 1;
1233         }
1234     }
1235 
1236     function decrement(Counter storage counter) internal {
1237         uint256 value = counter._value;
1238         require(value > 0, "Counter: decrement overflow");
1239         unchecked {
1240             counter._value = value - 1;
1241         }
1242     }
1243 
1244     function reset(Counter storage counter) internal {
1245         counter._value = 0;
1246     }
1247 }
1248 
1249 
1250 // Dependency file: @openzeppelin/contracts/utils/math/SafeMath.sol
1251 
1252 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
1253 
1254 // pragma solidity ^0.8.0;
1255 
1256 // CAUTION
1257 // This version of SafeMath should only be used with Solidity 0.8 or later,
1258 // because it relies on the compiler's built in overflow checks.
1259 
1260 /**
1261  * @dev Wrappers over Solidity's arithmetic operations.
1262  *
1263  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
1264  * now has built in overflow checking.
1265  */
1266 library SafeMath {
1267     /**
1268      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1269      *
1270      * _Available since v3.4._
1271      */
1272     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1273         unchecked {
1274             uint256 c = a + b;
1275             if (c < a) return (false, 0);
1276             return (true, c);
1277         }
1278     }
1279 
1280     /**
1281      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1282      *
1283      * _Available since v3.4._
1284      */
1285     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1286         unchecked {
1287             if (b > a) return (false, 0);
1288             return (true, a - b);
1289         }
1290     }
1291 
1292     /**
1293      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1294      *
1295      * _Available since v3.4._
1296      */
1297     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1298         unchecked {
1299             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1300             // benefit is lost if 'b' is also tested.
1301             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1302             if (a == 0) return (true, 0);
1303             uint256 c = a * b;
1304             if (c / a != b) return (false, 0);
1305             return (true, c);
1306         }
1307     }
1308 
1309     /**
1310      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1311      *
1312      * _Available since v3.4._
1313      */
1314     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1315         unchecked {
1316             if (b == 0) return (false, 0);
1317             return (true, a / b);
1318         }
1319     }
1320 
1321     /**
1322      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1323      *
1324      * _Available since v3.4._
1325      */
1326     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1327         unchecked {
1328             if (b == 0) return (false, 0);
1329             return (true, a % b);
1330         }
1331     }
1332 
1333     /**
1334      * @dev Returns the addition of two unsigned integers, reverting on
1335      * overflow.
1336      *
1337      * Counterpart to Solidity's `+` operator.
1338      *
1339      * Requirements:
1340      *
1341      * - Addition cannot overflow.
1342      */
1343     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1344         return a + b;
1345     }
1346 
1347     /**
1348      * @dev Returns the subtraction of two unsigned integers, reverting on
1349      * overflow (when the result is negative).
1350      *
1351      * Counterpart to Solidity's `-` operator.
1352      *
1353      * Requirements:
1354      *
1355      * - Subtraction cannot overflow.
1356      */
1357     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1358         return a - b;
1359     }
1360 
1361     /**
1362      * @dev Returns the multiplication of two unsigned integers, reverting on
1363      * overflow.
1364      *
1365      * Counterpart to Solidity's `*` operator.
1366      *
1367      * Requirements:
1368      *
1369      * - Multiplication cannot overflow.
1370      */
1371     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1372         return a * b;
1373     }
1374 
1375     /**
1376      * @dev Returns the integer division of two unsigned integers, reverting on
1377      * division by zero. The result is rounded towards zero.
1378      *
1379      * Counterpart to Solidity's `/` operator.
1380      *
1381      * Requirements:
1382      *
1383      * - The divisor cannot be zero.
1384      */
1385     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1386         return a / b;
1387     }
1388 
1389     /**
1390      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1391      * reverting when dividing by zero.
1392      *
1393      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1394      * opcode (which leaves remaining gas untouched) while Solidity uses an
1395      * invalid opcode to revert (consuming all remaining gas).
1396      *
1397      * Requirements:
1398      *
1399      * - The divisor cannot be zero.
1400      */
1401     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1402         return a % b;
1403     }
1404 
1405     /**
1406      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1407      * overflow (when the result is negative).
1408      *
1409      * CAUTION: This function is deprecated because it requires allocating memory for the error
1410      * message unnecessarily. For custom revert reasons use {trySub}.
1411      *
1412      * Counterpart to Solidity's `-` operator.
1413      *
1414      * Requirements:
1415      *
1416      * - Subtraction cannot overflow.
1417      */
1418     function sub(
1419         uint256 a,
1420         uint256 b,
1421         string memory errorMessage
1422     ) internal pure returns (uint256) {
1423         unchecked {
1424             require(b <= a, errorMessage);
1425             return a - b;
1426         }
1427     }
1428 
1429     /**
1430      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1431      * division by zero. The result is rounded towards zero.
1432      *
1433      * Counterpart to Solidity's `/` operator. Note: this function uses a
1434      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1435      * uses an invalid opcode to revert (consuming all remaining gas).
1436      *
1437      * Requirements:
1438      *
1439      * - The divisor cannot be zero.
1440      */
1441     function div(
1442         uint256 a,
1443         uint256 b,
1444         string memory errorMessage
1445     ) internal pure returns (uint256) {
1446         unchecked {
1447             require(b > 0, errorMessage);
1448             return a / b;
1449         }
1450     }
1451 
1452     /**
1453      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1454      * reverting with custom message when dividing by zero.
1455      *
1456      * CAUTION: This function is deprecated because it requires allocating memory for the error
1457      * message unnecessarily. For custom revert reasons use {tryMod}.
1458      *
1459      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1460      * opcode (which leaves remaining gas untouched) while Solidity uses an
1461      * invalid opcode to revert (consuming all remaining gas).
1462      *
1463      * Requirements:
1464      *
1465      * - The divisor cannot be zero.
1466      */
1467     function mod(
1468         uint256 a,
1469         uint256 b,
1470         string memory errorMessage
1471     ) internal pure returns (uint256) {
1472         unchecked {
1473             require(b > 0, errorMessage);
1474             return a % b;
1475         }
1476     }
1477 }
1478 
1479 
1480 // Dependency file: src/common/meta-transactions/ContentMixin.sol
1481 
1482 
1483 // pragma solidity ^0.8.0;
1484 
1485 abstract contract ContextMixin {
1486     function msgSender()
1487         internal
1488         view
1489         returns (address payable sender)
1490     {
1491         if (msg.sender == address(this)) {
1492             bytes memory array = msg.data;
1493             uint256 index = msg.data.length;
1494             assembly {
1495                 // Load the 32 bytes word from memory with the address on the lower 20 bytes, and mask those.
1496                 sender := and(
1497                     mload(add(array, index)),
1498                     0xffffffffffffffffffffffffffffffffffffffff
1499                 )
1500             }
1501         } else {
1502             sender = payable(msg.sender);
1503         }
1504         return sender;
1505     }
1506 }
1507 
1508 
1509 // Dependency file: src/common/meta-transactions/Initializable.sol
1510 
1511 
1512 // pragma solidity ^0.8.0;
1513 
1514 contract Initializable {
1515     bool inited = false;
1516 
1517     modifier initializer() {
1518         require(!inited, "already inited");
1519         _;
1520         inited = true;
1521     }
1522 }
1523 
1524 
1525 // Dependency file: src/common/meta-transactions/EIP712Base.sol
1526 
1527 
1528 // pragma solidity ^0.8.0;
1529 
1530 // import {Initializable} from "src/common/meta-transactions/Initializable.sol";
1531 
1532 contract EIP712Base is Initializable {
1533     struct EIP712Domain {
1534         string name;
1535         string version;
1536         address verifyingContract;
1537         bytes32 salt;
1538     }
1539 
1540     string constant public ERC712_VERSION = "1";
1541 
1542     bytes32 internal constant EIP712_DOMAIN_TYPEHASH = keccak256(
1543         bytes(
1544             "EIP712Domain(string name,string version,address verifyingContract,bytes32 salt)"
1545         )
1546     );
1547     bytes32 internal domainSeperator;
1548 
1549     // supposed to be called once while initializing.
1550     // one of the contracts that inherits this contract follows proxy pattern
1551     // so it is not possible to do this in a constructor
1552     function _initializeEIP712(
1553         string memory name
1554     )
1555         internal
1556         initializer
1557     {
1558         _setDomainSeperator(name);
1559     }
1560 
1561     function _setDomainSeperator(string memory name) internal {
1562         domainSeperator = keccak256(
1563             abi.encode(
1564                 EIP712_DOMAIN_TYPEHASH,
1565                 keccak256(bytes(name)),
1566                 keccak256(bytes(ERC712_VERSION)),
1567                 address(this),
1568                 bytes32(getChainId())
1569             )
1570         );
1571     }
1572 
1573     function getDomainSeperator() public view returns (bytes32) {
1574         return domainSeperator;
1575     }
1576 
1577     function getChainId() public view returns (uint256) {
1578         uint256 id;
1579         assembly {
1580             id := chainid()
1581         }
1582         return id;
1583     }
1584 
1585     /**
1586      * Accept message hash and returns hash message in EIP712 compatible form
1587      * So that it can be used to recover signer from signature signed using EIP712 formatted data
1588      * https://eips.ethereum.org/EIPS/eip-712
1589      * "\\x19" makes the encoding deterministic
1590      * "\\x01" is the version byte to make it compatible to EIP-191
1591      */
1592     function toTypedMessageHash(bytes32 messageHash)
1593         internal
1594         view
1595         returns (bytes32)
1596     {
1597         return
1598             keccak256(
1599                 abi.encodePacked("\x19\x01", getDomainSeperator(), messageHash)
1600             );
1601     }
1602 }
1603 
1604 // Dependency file: src/common/meta-transactions/NativeMetaTransaction.sol
1605 
1606 
1607 // pragma solidity ^0.8.0;
1608 
1609 // import {SafeMath} from  "@openzeppelin/contracts/utils/math/SafeMath.sol";
1610 // import {EIP712Base} from "src/common/meta-transactions/EIP712Base.sol";
1611 
1612 contract NativeMetaTransaction is EIP712Base {
1613     using SafeMath for uint256;
1614     bytes32 private constant META_TRANSACTION_TYPEHASH = keccak256(
1615         bytes(
1616             "MetaTransaction(uint256 nonce,address from,bytes functionSignature)"
1617         )
1618     );
1619     event MetaTransactionExecuted(
1620         address userAddress,
1621         address payable relayerAddress,
1622         bytes functionSignature
1623     );
1624     mapping(address => uint256) nonces;
1625 
1626     /*
1627      * Meta transaction structure.
1628      * No point of including value field here as if user is doing value transfer then he has the funds to pay for gas
1629      * He should call the desired function directly in that case.
1630      */
1631     struct MetaTransaction {
1632         uint256 nonce;
1633         address from;
1634         bytes functionSignature;
1635     }
1636 
1637     function executeMetaTransaction(
1638         address userAddress,
1639         bytes memory functionSignature,
1640         bytes32 sigR,
1641         bytes32 sigS,
1642         uint8 sigV
1643     ) public payable returns (bytes memory) {
1644         MetaTransaction memory metaTx = MetaTransaction({
1645             nonce: nonces[userAddress],
1646             from: userAddress,
1647             functionSignature: functionSignature
1648         });
1649 
1650         require(
1651             verify(userAddress, metaTx, sigR, sigS, sigV),
1652             "Signer and signature do not match"
1653         );
1654 
1655         // increase nonce for user (to avoid re-use)
1656         nonces[userAddress] = nonces[userAddress].add(1);
1657 
1658         emit MetaTransactionExecuted(
1659             userAddress,
1660             payable(msg.sender),
1661             functionSignature
1662         );
1663 
1664         // Append userAddress and relayer address at the end to extract it from calling context
1665         (bool success, bytes memory returnData) = address(this).call(
1666             abi.encodePacked(functionSignature, userAddress)
1667         );
1668         require(success, "Function call not successful");
1669 
1670         return returnData;
1671     }
1672 
1673     function hashMetaTransaction(MetaTransaction memory metaTx)
1674         internal
1675         pure
1676         returns (bytes32)
1677     {
1678         return
1679             keccak256(
1680                 abi.encode(
1681                     META_TRANSACTION_TYPEHASH,
1682                     metaTx.nonce,
1683                     metaTx.from,
1684                     keccak256(metaTx.functionSignature)
1685                 )
1686             );
1687     }
1688 
1689     function getNonce(address user) public view returns (uint256 nonce) {
1690         nonce = nonces[user];
1691     }
1692 
1693     function verify(
1694         address signer,
1695         MetaTransaction memory metaTx,
1696         bytes32 sigR,
1697         bytes32 sigS,
1698         uint8 sigV
1699     ) internal view returns (bool) {
1700         require(signer != address(0), "NativeMetaTransaction: INVALID_SIGNER");
1701         return
1702             signer ==
1703             ecrecover(
1704                 toTypedMessageHash(hashMetaTransaction(metaTx)),
1705                 sigV,
1706                 sigR,
1707                 sigS
1708             );
1709     }
1710 }
1711 
1712 
1713 // Dependency file: src/PuliNFT.sol
1714 
1715 
1716 // pragma solidity ^0.8.0;
1717 
1718 // import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
1719 // import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
1720 // import "@openzeppelin/contracts/access/Ownable.sol";
1721 // import "@openzeppelin/contracts/utils/Counters.sol";
1722 // import "@openzeppelin/contracts/utils/Strings.sol";
1723 // import "@openzeppelin/contracts/utils/math/SafeMath.sol";
1724 
1725 // import "src/common/meta-transactions/ContentMixin.sol";
1726 // import "src/common/meta-transactions/NativeMetaTransaction.sol";
1727 
1728 contract OwnableDelegateProxy {}
1729 
1730 contract ProxyRegistry {
1731     mapping(address => OwnableDelegateProxy) public proxies;
1732 }
1733 
1734 abstract contract PuliNFT is
1735     ERC721,
1736     ContextMixin,
1737     NativeMetaTransaction,
1738     Ownable
1739 {
1740     address proxyRegistryAddress;
1741 
1742     struct WhiteListInfo {
1743         mapping(address => uint256) users;
1744         address[] userlist;
1745     }
1746 
1747     WhiteListInfo whitelist;
1748 
1749     mapping(address => uint256) price;
1750 
1751     uint256 public tokenIdCounter = 1;
1752     uint256 public totalSupply = 0;
1753     uint256 public maxSupply = 0;
1754 
1755     address public constant NATIVE = 0x0000000000000000000000000000000000000001;
1756 
1757     event SetWhiteList(address[] whitelistAddress, uint256 quantity);
1758 
1759     event SetPrice(address[] tokenAddress, uint256[] tokenPrice);
1760 
1761     event WhiteListMint(address indexed whitelistAddress, uint256 index);
1762     event Mint(address indexed publicAddress, uint256 index);
1763 
1764     constructor(
1765         string memory name_,
1766         string memory symbol_,
1767         address proxyAddress,
1768         uint256 _maxSupply
1769     ) ERC721(name_, symbol_) {
1770         proxyRegistryAddress = proxyAddress;
1771         _initializeEIP712(name_);
1772         maxSupply = _maxSupply;
1773     }
1774 
1775     function mintTo(address to) external onlyOwner {
1776         require(
1777             maxSupply == 0 || maxSupply > totalSupply,
1778             "Max supply exceeded"
1779         );
1780         uint256 currentTokenId = tokenIdCounter++;
1781         _safeMint(to, currentTokenId);
1782         totalSupply++;
1783         emit Mint(to, currentTokenId);
1784     }
1785 
1786     function setWhiteList(
1787         address[] memory whitelistAddress,
1788         uint256 quantity,
1789         address[] memory tokenAddress,
1790         uint256[] memory tokenPrice
1791     ) external onlyOwner {
1792         require(whitelistAddress.length > 0, "No addresses inputted");
1793         require(quantity > 0, "Invalid quantity, should be greater than 0");
1794 
1795         setPrice(tokenAddress, tokenPrice);
1796 
1797         for (
1798             uint256 address_index = 0;
1799             address_index < whitelistAddress.length;
1800             address_index++
1801         ) {
1802             whitelist.users[whitelistAddress[address_index]] = quantity;
1803         }
1804         whitelist.userlist = whitelistAddress;
1805         emit SetWhiteList(whitelistAddress, quantity);
1806     }
1807 
1808     function mint(uint256 quantity) public payable virtual {
1809         require((quantity + totalSupply) <= maxSupply, "Max supply exceeded");
1810 
1811         _checkPricing(address(NATIVE), quantity);
1812 
1813         _checkWhitelist(_msgSender(), quantity);
1814 
1815         totalSupply += quantity;
1816         for (uint256 index = 0; index < quantity; index++) {
1817             _safeMint(_msgSender(), tokenIdCounter);
1818             emit Mint(msg.sender, tokenIdCounter++);
1819         }
1820     }
1821 
1822     function mintByToken(IERC20 token, uint256 quantity) public virtual {
1823         require((quantity + totalSupply) <= maxSupply, "Max supply exceeded");
1824 
1825         require(price[address(token)] > 0, "Price is not set for minting");
1826 
1827         _checkWhitelist(_msgSender(), quantity);
1828 
1829         // Transfer IERC20 to contract
1830         uint256 _price = price[address(token)];
1831         bool success = token.transferFrom(
1832             msgSender(),
1833             address(this),
1834             quantity * _price
1835         );
1836         require(success, "Transfer failed");
1837 
1838         totalSupply += quantity;
1839         for (uint256 index = 0; index < quantity; index++) {
1840             _safeMint(_msgSender(), tokenIdCounter);
1841             emit Mint(msg.sender, tokenIdCounter++);
1842         }
1843     }
1844 
1845     function closeWhitelisting(
1846         address[] memory tokenAddress,
1847         uint256[] memory tokenPrice
1848     ) external onlyOwner {
1849         require(
1850             whitelist.userlist.length > 0,
1851             "Error cannot close, No Whitelist addresses added"
1852         );
1853         for (uint256 index = 0; index < whitelist.userlist.length; index++) {
1854             address currentUser = whitelist.userlist[index];
1855             whitelist.users[currentUser] = 0;
1856         }
1857         delete whitelist.userlist;
1858         setPrice(tokenAddress, tokenPrice);
1859     }
1860 
1861     function getPrice(address tokenAddress) external view returns (uint256) {
1862         require(tokenAddress > address(0), "Invalid address");
1863         require(price[address(tokenAddress)] > 0, "Price is not yet set");
1864         return price[tokenAddress];
1865     }
1866 
1867     function contractURI() external view virtual returns (string memory);
1868 
1869     function setPrice(
1870         address[] memory tokenAddress,
1871         uint256[] memory tokenPrice
1872     ) public onlyOwner {
1873         require(tokenAddress.length > 0, "Token address is empty");
1874         require(tokenPrice.length > 0, "Token price is empty");
1875         require(
1876             tokenPrice.length == tokenAddress.length,
1877             "Price and address does not match"
1878         );
1879 
1880         bool isNativeIncluded = false;
1881         for (uint256 index = 0; index < tokenAddress.length; index++) {
1882             if (tokenAddress[index] == address(NATIVE)) {
1883                 isNativeIncluded = true;
1884             }
1885         }
1886 
1887         require(
1888             isNativeIncluded,
1889             "Error, price does not contain native currency"
1890         );
1891 
1892         for (uint256 index = 0; index < tokenAddress.length; index++) {
1893             require(
1894                 tokenPrice[index] > 0,
1895                 "Invalid quantity, should be greater than 0"
1896             );
1897             price[address(tokenAddress[index])] = tokenPrice[index];
1898         }
1899         emit SetPrice(tokenAddress, tokenPrice);
1900     }
1901 
1902     function tokenURI(uint256 tokenId)
1903         public
1904         view
1905         override
1906         returns (string memory)
1907     {
1908         return
1909             string(
1910                 abi.encodePacked(
1911                     baseTokenURI(),
1912                     Strings.toString(tokenId),
1913                     ".json"
1914                 )
1915             );
1916     }
1917 
1918     function baseTokenURI() public view virtual returns (string memory);
1919 
1920     /**
1921      * Override isApprovedForAll to whitelist user's OpenSea proxy accounts to enable gas-less listings.
1922      */
1923     function isApprovedForAll(address owner, address operator)
1924         public
1925         view
1926         override
1927         returns (bool)
1928     {
1929         // Whitelist OpenSea proxy contract for easy trading.
1930         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1931         if (address(proxyRegistry.proxies(owner)) == operator) {
1932             return true;
1933         }
1934 
1935         return super.isApprovedForAll(owner, operator);
1936     }
1937 
1938     function _checkWhitelist(address user, uint256 quantity) private {
1939         if (whitelist.userlist.length > 0) {
1940             require(
1941                 whitelist.users[user] > 0,
1942                 "Current user is not whitelisted"
1943             );
1944             require(
1945                 quantity <= whitelist.users[user],
1946                 "Current user exceeds allowable mint"
1947             );
1948             whitelist.users[user] -= quantity;
1949         }
1950     }
1951 
1952     function _checkPricing(address tokenAddress, uint256 quantity)
1953         private
1954         view
1955     {
1956         require(
1957             price[address(tokenAddress)] > 0,
1958             "Price is not set for minting"
1959         );
1960         require(
1961             msg.value >= price[address(tokenAddress)] * quantity,
1962             "Insufficient amount, cannot mint"
1963         );
1964     }
1965 }
1966 
1967 
1968 // Dependency file: @openzeppelin/contracts/interfaces/IERC20.sol
1969 
1970 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC20.sol)
1971 
1972 // pragma solidity ^0.8.0;
1973 
1974 // import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
1975 
1976 
1977 // Dependency file: src/IPayroll.sol
1978 
1979 // pragma solidity ^0.8.0;
1980 
1981 // import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
1982 
1983 interface IPayroll {
1984     event PaymentReceived(address indexed sender, uint256 amount);
1985     event PaymentTokensReceived(
1986         address indexed sender,
1987         address token,
1988         uint256 amount
1989     );
1990     event PaymentReleased(address indexed sender, uint256 amount);
1991     event PaymentTokensReleased(
1992         address indexed sender,
1993         address token,
1994         uint256 amount
1995     );
1996 
1997     function receivePayment() external payable;
1998 
1999     function receivePayment(IERC20 token, uint256 amount) external;
2000 
2001     function releasePayment(uint256 amount) external payable;
2002 
2003     function releasePayment(IERC20 token, uint256 amount) external;
2004 }
2005 
2006 
2007 // Root file: src/PuliRunners.sol
2008 
2009 
2010 pragma solidity ^0.8.0;
2011 
2012 // import "src/PuliNFT.sol";
2013 // import "@openzeppelin/contracts/utils/Address.sol";
2014 // import "@openzeppelin/contracts/interfaces/IERC20.sol";
2015 // import "src/IPayroll.sol";
2016 
2017 contract PuliRunners is PuliNFT {
2018     event Withdraw(address indexed recepient, uint256 indexed amount);
2019     event WithdrawTokens(
2020         address indexed recepient,
2021         IERC20 indexed tokenAddress,
2022         uint256 indexed amount
2023     );
2024     event SetWithdrawalAddress(address indexed withdrawalAddress);
2025 
2026     address public withdrawalAddress;
2027 
2028     string public baseToken = "https://runners.pulitoken.net/metadata/";
2029 
2030     uint256 public constant maxSaleCount = 2000;
2031 
2032     constructor(address proxyAddress)
2033         PuliNFT("Puli Runners", "PRNR", proxyAddress, 2011)
2034     {
2035         withdrawalAddress = msg.sender;
2036     }
2037 
2038     function setBaseTokenURI(string memory _baseToken) external onlyOwner {
2039         baseToken = _baseToken;
2040     }
2041 
2042     function baseTokenURI() public view override returns (string memory) {
2043         return baseToken;
2044     }
2045 
2046     function contractURI() external view override returns (string memory) {
2047         return string(abi.encodePacked(baseTokenURI(), "contract.json"));
2048     }
2049 
2050     function setWithdrawalAddress(address _withdrawalAddress)
2051         external
2052         onlyOwner
2053     {
2054         require(_withdrawalAddress != address(0), "Invalid withdrawal address");
2055         withdrawalAddress = _withdrawalAddress;
2056         emit SetWithdrawalAddress(_withdrawalAddress);
2057     }
2058 
2059     function withdraw(address tokenAddress, uint256 amount)
2060         external
2061         payable
2062         onlyOwner
2063     {
2064         require(amount > 0, "Invalid amount");
2065         bool isContract = Address.isContract(withdrawalAddress);
2066         if (tokenAddress == NATIVE) {
2067             if (isContract) {
2068                 Address.functionCallWithValue(
2069                     withdrawalAddress,
2070                     abi.encodeWithSignature("receivePayment()"),
2071                     amount
2072                 );
2073             } else {
2074                 Address.sendValue(payable(withdrawalAddress), amount);
2075             }
2076             emit Withdraw(withdrawalAddress, amount);
2077             return;
2078         }
2079         IERC20 token = IERC20(tokenAddress);
2080         if (isContract) {
2081             bool success = token.approve(withdrawalAddress, amount);
2082             require(success, "Failed to approve withdrawal");
2083             IPayroll(withdrawalAddress).receivePayment(token, amount);
2084         } else {
2085             token.transfer(withdrawalAddress, amount);
2086         }
2087         emit WithdrawTokens(withdrawalAddress, token, amount);
2088     }
2089 
2090     function mint(uint256 quantity) public payable override {
2091         require(totalSupply + quantity <= maxSaleCount, "Max sale reached");
2092         super.mint(quantity);
2093     }
2094 
2095     function mintByToken(IERC20 token, uint256 quantity) public override {
2096         require(totalSupply + quantity <= maxSaleCount, "Max sale reached");
2097         super.mintByToken(token, quantity);
2098     }
2099 }