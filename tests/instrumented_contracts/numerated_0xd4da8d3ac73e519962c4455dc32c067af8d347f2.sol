1 // SPDX-License-Identifier: MIT
2 
3 /*
4 :'######:::::'###:::::'######:::'######::
5 '##... ##:::'## ##:::'##... ##:'##... ##:
6  ##:::..:::'##:. ##:: ##:::..:: ##:::..::
7 . ######::'##:::. ##: ##::::::: ##:::::::
8 :..... ##: #########: ##::::::: ##:::::::
9 '##::: ##: ##.... ##: ##::: ##: ##::: ##:
10 . ######:: ##:::: ##:. ######::. ######::
11 :......:::..:::::..:::......::::......:::
12 **/
13 
14 // Sketchy Ape Comic Club
15 
16 /*
17 The sketchiest comic apes on the blockchain, the Sketchy Ape Comic Club NFT Collection symbolizes 
18 the merging of the physical world and the digital. Each ape was hand drawn by the artist 
19 in separate layers and then ran through the HashLips Art Engine to generate 10 000 unique 
20 and very special apes.
21 **/
22 
23 // File: @openzeppelin/contracts/utils/Counters.sol
24 
25 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
26 
27 pragma solidity ^0.8.0;
28 
29 /**
30  * @title Counters
31  * @author Matt Condon (@shrugs)
32  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
33  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
34  *
35  * Include with `using Counters for Counters.Counter;`
36  */
37 library Counters {
38     struct Counter {
39         // This variable should never be directly accessed by users of the library: interactions must be restricted to
40         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
41         // this feature: see https://github.com/ethereum/solidity/issues/4637
42         uint256 _value; // default: 0
43     }
44 
45     function current(Counter storage counter) internal view returns (uint256) {
46         return counter._value;
47     }
48 
49     function increment(Counter storage counter) internal {
50         unchecked {
51             counter._value += 1;
52         }
53     }
54 
55     function decrement(Counter storage counter) internal {
56         uint256 value = counter._value;
57         require(value > 0, "Counter: decrement overflow");
58         unchecked {
59             counter._value = value - 1;
60         }
61     }
62 
63     function reset(Counter storage counter) internal {
64         counter._value = 0;
65     }
66 }
67 
68 // File: @openzeppelin/contracts/utils/Strings.sol
69 
70 
71 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
72 
73 pragma solidity ^0.8.0;
74 
75 /**
76  * @dev String operations.
77  */
78 library Strings {
79     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
80 
81     /**
82      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
83      */
84     function toString(uint256 value) internal pure returns (string memory) {
85         // Inspired by OraclizeAPI's implementation - MIT licence
86         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
87 
88         if (value == 0) {
89             return "0";
90         }
91         uint256 temp = value;
92         uint256 digits;
93         while (temp != 0) {
94             digits++;
95             temp /= 10;
96         }
97         bytes memory buffer = new bytes(digits);
98         while (value != 0) {
99             digits -= 1;
100             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
101             value /= 10;
102         }
103         return string(buffer);
104     }
105 
106     /**
107      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
108      */
109     function toHexString(uint256 value) internal pure returns (string memory) {
110         if (value == 0) {
111             return "0x00";
112         }
113         uint256 temp = value;
114         uint256 length = 0;
115         while (temp != 0) {
116             length++;
117             temp >>= 8;
118         }
119         return toHexString(value, length);
120     }
121 
122     /**
123      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
124      */
125     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
126         bytes memory buffer = new bytes(2 * length + 2);
127         buffer[0] = "0";
128         buffer[1] = "x";
129         for (uint256 i = 2 * length + 1; i > 1; --i) {
130             buffer[i] = _HEX_SYMBOLS[value & 0xf];
131             value >>= 4;
132         }
133         require(value == 0, "Strings: hex length insufficient");
134         return string(buffer);
135     }
136 }
137 
138 // File: @openzeppelin/contracts/utils/Context.sol
139 
140 
141 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
142 
143 pragma solidity ^0.8.0;
144 
145 /**
146  * @dev Provides information about the current execution context, including the
147  * sender of the transaction and its data. While these are generally available
148  * via msg.sender and msg.data, they should not be accessed in such a direct
149  * manner, since when dealing with meta-transactions the account sending and
150  * paying for execution may not be the actual sender (as far as an application
151  * is concerned).
152  *
153  * This contract is only required for intermediate, library-like contracts.
154  */
155 abstract contract Context {
156     function _msgSender() internal view virtual returns (address) {
157         return msg.sender;
158     }
159 
160     function _msgData() internal view virtual returns (bytes calldata) {
161         return msg.data;
162     }
163 }
164 
165 // File: @openzeppelin/contracts/access/Ownable.sol
166 
167 
168 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
169 
170 pragma solidity ^0.8.0;
171 
172 
173 /**
174  * @dev Contract module which provides a basic access control mechanism, where
175  * there is an account (an owner) that can be granted exclusive access to
176  * specific functions.
177  *
178  * By default, the owner account will be the one that deploys the contract. This
179  * can later be changed with {transferOwnership}.
180  *
181  * This module is used through inheritance. It will make available the modifier
182  * `onlyOwner`, which can be applied to your functions to restrict their use to
183  * the owner.
184  */
185 abstract contract Ownable is Context {
186     address private _owner;
187 
188     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
189 
190     /**
191      * @dev Initializes the contract setting the deployer as the initial owner.
192      */
193     constructor() {
194         _transferOwnership(_msgSender());
195     }
196 
197     /**
198      * @dev Returns the address of the current owner.
199      */
200     function owner() public view virtual returns (address) {
201         return _owner;
202     }
203 
204     /**
205      * @dev Throws if called by any account other than the owner.
206      */
207     modifier onlyOwner() {
208         require(owner() == _msgSender(), "Ownable: caller is not the owner");
209         _;
210     }
211 
212     /**
213      * @dev Leaves the contract without owner. It will not be possible to call
214      * `onlyOwner` functions anymore. Can only be called by the current owner.
215      *
216      * NOTE: Renouncing ownership will leave the contract without an owner,
217      * thereby removing any functionality that is only available to the owner.
218      */
219     function renounceOwnership() public virtual onlyOwner {
220         _transferOwnership(address(0));
221     }
222 
223     /**
224      * @dev Transfers ownership of the contract to a new account (`newOwner`).
225      * Can only be called by the current owner.
226      */
227     function transferOwnership(address newOwner) public virtual onlyOwner {
228         require(newOwner != address(0), "Ownable: new owner is the zero address");
229         _transferOwnership(newOwner);
230     }
231 
232     /**
233      * @dev Transfers ownership of the contract to a new account (`newOwner`).
234      * Internal function without access restriction.
235      */
236     function _transferOwnership(address newOwner) internal virtual {
237         address oldOwner = _owner;
238         _owner = newOwner;
239         emit OwnershipTransferred(oldOwner, newOwner);
240     }
241 }
242 
243 // File: @openzeppelin/contracts/utils/Address.sol
244 
245 
246 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
247 
248 pragma solidity ^0.8.0;
249 
250 /**
251  * @dev Collection of functions related to the address type
252  */
253 library Address {
254     /**
255      * @dev Returns true if `account` is a contract.
256      *
257      * [IMPORTANT]
258      * ====
259      * It is unsafe to assume that an address for which this function returns
260      * false is an externally-owned account (EOA) and not a contract.
261      *
262      * Among others, `isContract` will return false for the following
263      * types of addresses:
264      *
265      *  - an externally-owned account
266      *  - a contract in construction
267      *  - an address where a contract will be created
268      *  - an address where a contract lived, but was destroyed
269      * ====
270      */
271     function isContract(address account) internal view returns (bool) {
272         // This method relies on extcodesize, which returns 0 for contracts in
273         // construction, since the code is only stored at the end of the
274         // constructor execution.
275 
276         uint256 size;
277         assembly {
278             size := extcodesize(account)
279         }
280         return size > 0;
281     }
282 
283     /**
284      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
285      * `recipient`, forwarding all available gas and reverting on errors.
286      *
287      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
288      * of certain opcodes, possibly making contracts go over the 2300 gas limit
289      * imposed by `transfer`, making them unable to receive funds via
290      * `transfer`. {sendValue} removes this limitation.
291      *
292      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
293      *
294      * IMPORTANT: because control is transferred to `recipient`, care must be
295      * taken to not create reentrancy vulnerabilities. Consider using
296      * {ReentrancyGuard} or the
297      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
298      */
299     function sendValue(address payable recipient, uint256 amount) internal {
300         require(address(this).balance >= amount, "Address: insufficient balance");
301 
302         (bool success, ) = recipient.call{value: amount}("");
303         require(success, "Address: unable to send value, recipient may have reverted");
304     }
305 
306     /**
307      * @dev Performs a Solidity function call using a low level `call`. A
308      * plain `call` is an unsafe replacement for a function call: use this
309      * function instead.
310      *
311      * If `target` reverts with a revert reason, it is bubbled up by this
312      * function (like regular Solidity function calls).
313      *
314      * Returns the raw returned data. To convert to the expected return value,
315      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
316      *
317      * Requirements:
318      *
319      * - `target` must be a contract.
320      * - calling `target` with `data` must not revert.
321      *
322      * _Available since v3.1._
323      */
324     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
325         return functionCall(target, data, "Address: low-level call failed");
326     }
327 
328     /**
329      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
330      * `errorMessage` as a fallback revert reason when `target` reverts.
331      *
332      * _Available since v3.1._
333      */
334     function functionCall(
335         address target,
336         bytes memory data,
337         string memory errorMessage
338     ) internal returns (bytes memory) {
339         return functionCallWithValue(target, data, 0, errorMessage);
340     }
341 
342     /**
343      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
344      * but also transferring `value` wei to `target`.
345      *
346      * Requirements:
347      *
348      * - the calling contract must have an ETH balance of at least `value`.
349      * - the called Solidity function must be `payable`.
350      *
351      * _Available since v3.1._
352      */
353     function functionCallWithValue(
354         address target,
355         bytes memory data,
356         uint256 value
357     ) internal returns (bytes memory) {
358         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
359     }
360 
361     /**
362      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
363      * with `errorMessage` as a fallback revert reason when `target` reverts.
364      *
365      * _Available since v3.1._
366      */
367     function functionCallWithValue(
368         address target,
369         bytes memory data,
370         uint256 value,
371         string memory errorMessage
372     ) internal returns (bytes memory) {
373         require(address(this).balance >= value, "Address: insufficient balance for call");
374         require(isContract(target), "Address: call to non-contract");
375 
376         (bool success, bytes memory returndata) = target.call{value: value}(data);
377         return verifyCallResult(success, returndata, errorMessage);
378     }
379 
380     /**
381      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
382      * but performing a static call.
383      *
384      * _Available since v3.3._
385      */
386     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
387         return functionStaticCall(target, data, "Address: low-level static call failed");
388     }
389 
390     /**
391      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
392      * but performing a static call.
393      *
394      * _Available since v3.3._
395      */
396     function functionStaticCall(
397         address target,
398         bytes memory data,
399         string memory errorMessage
400     ) internal view returns (bytes memory) {
401         require(isContract(target), "Address: static call to non-contract");
402 
403         (bool success, bytes memory returndata) = target.staticcall(data);
404         return verifyCallResult(success, returndata, errorMessage);
405     }
406 
407     /**
408      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
409      * but performing a delegate call.
410      *
411      * _Available since v3.4._
412      */
413     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
414         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
415     }
416 
417     /**
418      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
419      * but performing a delegate call.
420      *
421      * _Available since v3.4._
422      */
423     function functionDelegateCall(
424         address target,
425         bytes memory data,
426         string memory errorMessage
427     ) internal returns (bytes memory) {
428         require(isContract(target), "Address: delegate call to non-contract");
429 
430         (bool success, bytes memory returndata) = target.delegatecall(data);
431         return verifyCallResult(success, returndata, errorMessage);
432     }
433 
434     /**
435      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
436      * revert reason using the provided one.
437      *
438      * _Available since v4.3._
439      */
440     function verifyCallResult(
441         bool success,
442         bytes memory returndata,
443         string memory errorMessage
444     ) internal pure returns (bytes memory) {
445         if (success) {
446             return returndata;
447         } else {
448             // Look for revert reason and bubble it up if present
449             if (returndata.length > 0) {
450                 // The easiest way to bubble the revert reason is using memory via assembly
451 
452                 assembly {
453                     let returndata_size := mload(returndata)
454                     revert(add(32, returndata), returndata_size)
455                 }
456             } else {
457                 revert(errorMessage);
458             }
459         }
460     }
461 }
462 
463 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
464 
465 
466 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
467 
468 pragma solidity ^0.8.0;
469 
470 /**
471  * @title ERC721 token receiver interface
472  * @dev Interface for any contract that wants to support safeTransfers
473  * from ERC721 asset contracts.
474  */
475 interface IERC721Receiver {
476     /**
477      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
478      * by `operator` from `from`, this function is called.
479      *
480      * It must return its Solidity selector to confirm the token transfer.
481      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
482      *
483      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
484      */
485     function onERC721Received(
486         address operator,
487         address from,
488         uint256 tokenId,
489         bytes calldata data
490     ) external returns (bytes4);
491 }
492 
493 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
494 
495 
496 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
497 
498 pragma solidity ^0.8.0;
499 
500 /**
501  * @dev Interface of the ERC165 standard, as defined in the
502  * https://eips.ethereum.org/EIPS/eip-165[EIP].
503  *
504  * Implementers can declare support of contract interfaces, which can then be
505  * queried by others ({ERC165Checker}).
506  *
507  * For an implementation, see {ERC165}.
508  */
509 interface IERC165 {
510     /**
511      * @dev Returns true if this contract implements the interface defined by
512      * `interfaceId`. See the corresponding
513      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
514      * to learn more about how these ids are created.
515      *
516      * This function call must use less than 30 000 gas.
517      */
518     function supportsInterface(bytes4 interfaceId) external view returns (bool);
519 }
520 
521 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
522 
523 
524 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
525 
526 pragma solidity ^0.8.0;
527 
528 
529 /**
530  * @dev Implementation of the {IERC165} interface.
531  *
532  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
533  * for the additional interface id that will be supported. For example:
534  *
535  * ```solidity
536  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
537  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
538  * }
539  * ```
540  *
541  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
542  */
543 abstract contract ERC165 is IERC165 {
544     /**
545      * @dev See {IERC165-supportsInterface}.
546      */
547     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
548         return interfaceId == type(IERC165).interfaceId;
549     }
550 }
551 
552 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
553 
554 
555 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
556 
557 pragma solidity ^0.8.0;
558 
559 
560 /**
561  * @dev Required interface of an ERC721 compliant contract.
562  */
563 interface IERC721 is IERC165 {
564     /**
565      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
566      */
567     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
568 
569     /**
570      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
571      */
572     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
573 
574     /**
575      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
576      */
577     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
578 
579     /**
580      * @dev Returns the number of tokens in ``owner``'s account.
581      */
582     function balanceOf(address owner) external view returns (uint256 balance);
583 
584     /**
585      * @dev Returns the owner of the `tokenId` token.
586      *
587      * Requirements:
588      *
589      * - `tokenId` must exist.
590      */
591     function ownerOf(uint256 tokenId) external view returns (address owner);
592 
593     /**
594      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
595      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
596      *
597      * Requirements:
598      *
599      * - `from` cannot be the zero address.
600      * - `to` cannot be the zero address.
601      * - `tokenId` token must exist and be owned by `from`.
602      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
603      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
604      *
605      * Emits a {Transfer} event.
606      */
607     function safeTransferFrom(
608         address from,
609         address to,
610         uint256 tokenId
611     ) external;
612 
613     /**
614      * @dev Transfers `tokenId` token from `from` to `to`.
615      *
616      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
617      *
618      * Requirements:
619      *
620      * - `from` cannot be the zero address.
621      * - `to` cannot be the zero address.
622      * - `tokenId` token must be owned by `from`.
623      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
624      *
625      * Emits a {Transfer} event.
626      */
627     function transferFrom(
628         address from,
629         address to,
630         uint256 tokenId
631     ) external;
632 
633     /**
634      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
635      * The approval is cleared when the token is transferred.
636      *
637      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
638      *
639      * Requirements:
640      *
641      * - The caller must own the token or be an approved operator.
642      * - `tokenId` must exist.
643      *
644      * Emits an {Approval} event.
645      */
646     function approve(address to, uint256 tokenId) external;
647 
648     /**
649      * @dev Returns the account approved for `tokenId` token.
650      *
651      * Requirements:
652      *
653      * - `tokenId` must exist.
654      */
655     function getApproved(uint256 tokenId) external view returns (address operator);
656 
657     /**
658      * @dev Approve or remove `operator` as an operator for the caller.
659      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
660      *
661      * Requirements:
662      *
663      * - The `operator` cannot be the caller.
664      *
665      * Emits an {ApprovalForAll} event.
666      */
667     function setApprovalForAll(address operator, bool _approved) external;
668 
669     /**
670      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
671      *
672      * See {setApprovalForAll}
673      */
674     function isApprovedForAll(address owner, address operator) external view returns (bool);
675 
676     /**
677      * @dev Safely transfers `tokenId` token from `from` to `to`.
678      *
679      * Requirements:
680      *
681      * - `from` cannot be the zero address.
682      * - `to` cannot be the zero address.
683      * - `tokenId` token must exist and be owned by `from`.
684      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
685      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
686      *
687      * Emits a {Transfer} event.
688      */
689     function safeTransferFrom(
690         address from,
691         address to,
692         uint256 tokenId,
693         bytes calldata data
694     ) external;
695 }
696 
697 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
698 
699 
700 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
701 
702 pragma solidity ^0.8.0;
703 
704 
705 /**
706  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
707  * @dev See https://eips.ethereum.org/EIPS/eip-721
708  */
709 interface IERC721Metadata is IERC721 {
710     /**
711      * @dev Returns the token collection name.
712      */
713     function name() external view returns (string memory);
714 
715     /**
716      * @dev Returns the token collection symbol.
717      */
718     function symbol() external view returns (string memory);
719 
720     /**
721      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
722      */
723     function tokenURI(uint256 tokenId) external view returns (string memory);
724 }
725 
726 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
727 
728 
729 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
730 
731 pragma solidity ^0.8.0;
732 
733 
734 
735 
736 
737 
738 
739 
740 /**
741  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
742  * the Metadata extension, but not including the Enumerable extension, which is available separately as
743  * {ERC721Enumerable}.
744  */
745 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
746     using Address for address;
747     using Strings for uint256;
748 
749     // Token name
750     string private _name;
751 
752     // Token symbol
753     string private _symbol;
754 
755     // Mapping from token ID to owner address
756     mapping(uint256 => address) private _owners;
757 
758     // Mapping owner address to token count
759     mapping(address => uint256) private _balances;
760 
761     // Mapping from token ID to approved address
762     mapping(uint256 => address) private _tokenApprovals;
763 
764     // Mapping from owner to operator approvals
765     mapping(address => mapping(address => bool)) private _operatorApprovals;
766 
767     /**
768      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
769      */
770     constructor(string memory name_, string memory symbol_) {
771         _name = name_;
772         _symbol = symbol_;
773     }
774 
775     /**
776      * @dev See {IERC165-supportsInterface}.
777      */
778     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
779         return
780             interfaceId == type(IERC721).interfaceId ||
781             interfaceId == type(IERC721Metadata).interfaceId ||
782             super.supportsInterface(interfaceId);
783     }
784 
785     /**
786      * @dev See {IERC721-balanceOf}.
787      */
788     function balanceOf(address owner) public view virtual override returns (uint256) {
789         require(owner != address(0), "ERC721: balance query for the zero address");
790         return _balances[owner];
791     }
792 
793     /**
794      * @dev See {IERC721-ownerOf}.
795      */
796     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
797         address owner = _owners[tokenId];
798         require(owner != address(0), "ERC721: owner query for nonexistent token");
799         return owner;
800     }
801 
802     /**
803      * @dev See {IERC721Metadata-name}.
804      */
805     function name() public view virtual override returns (string memory) {
806         return _name;
807     }
808 
809     /**
810      * @dev See {IERC721Metadata-symbol}.
811      */
812     function symbol() public view virtual override returns (string memory) {
813         return _symbol;
814     }
815 
816     /**
817      * @dev See {IERC721Metadata-tokenURI}.
818      */
819     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
820         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
821 
822         string memory baseURI = _baseURI();
823         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
824     }
825 
826     /**
827      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
828      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
829      * by default, can be overriden in child contracts.
830      */
831     function _baseURI() internal view virtual returns (string memory) {
832         return "";
833     }
834 
835     /**
836      * @dev See {IERC721-approve}.
837      */
838     function approve(address to, uint256 tokenId) public virtual override {
839         address owner = ERC721.ownerOf(tokenId);
840         require(to != owner, "ERC721: approval to current owner");
841 
842         require(
843             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
844             "ERC721: approve caller is not owner nor approved for all"
845         );
846 
847         _approve(to, tokenId);
848     }
849 
850     /**
851      * @dev See {IERC721-getApproved}.
852      */
853     function getApproved(uint256 tokenId) public view virtual override returns (address) {
854         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
855 
856         return _tokenApprovals[tokenId];
857     }
858 
859     /**
860      * @dev See {IERC721-setApprovalForAll}.
861      */
862     function setApprovalForAll(address operator, bool approved) public virtual override {
863         _setApprovalForAll(_msgSender(), operator, approved);
864     }
865 
866     /**
867      * @dev See {IERC721-isApprovedForAll}.
868      */
869     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
870         return _operatorApprovals[owner][operator];
871     }
872 
873     /**
874      * @dev See {IERC721-transferFrom}.
875      */
876     function transferFrom(
877         address from,
878         address to,
879         uint256 tokenId
880     ) public virtual override {
881         //solhint-disable-next-line max-line-length
882         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
883 
884         _transfer(from, to, tokenId);
885     }
886 
887     /**
888      * @dev See {IERC721-safeTransferFrom}.
889      */
890     function safeTransferFrom(
891         address from,
892         address to,
893         uint256 tokenId
894     ) public virtual override {
895         safeTransferFrom(from, to, tokenId, "");
896     }
897 
898     /**
899      * @dev See {IERC721-safeTransferFrom}.
900      */
901     function safeTransferFrom(
902         address from,
903         address to,
904         uint256 tokenId,
905         bytes memory _data
906     ) public virtual override {
907         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
908         _safeTransfer(from, to, tokenId, _data);
909     }
910 
911     /**
912      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
913      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
914      *
915      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
916      *
917      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
918      * implement alternative mechanisms to perform token transfer, such as signature-based.
919      *
920      * Requirements:
921      *
922      * - `from` cannot be the zero address.
923      * - `to` cannot be the zero address.
924      * - `tokenId` token must exist and be owned by `from`.
925      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
926      *
927      * Emits a {Transfer} event.
928      */
929     function _safeTransfer(
930         address from,
931         address to,
932         uint256 tokenId,
933         bytes memory _data
934     ) internal virtual {
935         _transfer(from, to, tokenId);
936         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
937     }
938 
939     /**
940      * @dev Returns whether `tokenId` exists.
941      *
942      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
943      *
944      * Tokens start existing when they are minted (`_mint`),
945      * and stop existing when they are burned (`_burn`).
946      */
947     function _exists(uint256 tokenId) internal view virtual returns (bool) {
948         return _owners[tokenId] != address(0);
949     }
950 
951     /**
952      * @dev Returns whether `spender` is allowed to manage `tokenId`.
953      *
954      * Requirements:
955      *
956      * - `tokenId` must exist.
957      */
958     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
959         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
960         address owner = ERC721.ownerOf(tokenId);
961         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
962     }
963 
964     /**
965      * @dev Safely mints `tokenId` and transfers it to `to`.
966      *
967      * Requirements:
968      *
969      * - `tokenId` must not exist.
970      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
971      *
972      * Emits a {Transfer} event.
973      */
974     function _safeMint(address to, uint256 tokenId) internal virtual {
975         _safeMint(to, tokenId, "");
976     }
977 
978     /**
979      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
980      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
981      */
982     function _safeMint(
983         address to,
984         uint256 tokenId,
985         bytes memory _data
986     ) internal virtual {
987         _mint(to, tokenId);
988         require(
989             _checkOnERC721Received(address(0), to, tokenId, _data),
990             "ERC721: transfer to non ERC721Receiver implementer"
991         );
992     }
993 
994     /**
995      * @dev Mints `tokenId` and transfers it to `to`.
996      *
997      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
998      *
999      * Requirements:
1000      *
1001      * - `tokenId` must not exist.
1002      * - `to` cannot be the zero address.
1003      *
1004      * Emits a {Transfer} event.
1005      */
1006     function _mint(address to, uint256 tokenId) internal virtual {
1007         require(to != address(0), "ERC721: mint to the zero address");
1008         require(!_exists(tokenId), "ERC721: token already minted");
1009 
1010         _beforeTokenTransfer(address(0), to, tokenId);
1011 
1012         _balances[to] += 1;
1013         _owners[tokenId] = to;
1014 
1015         emit Transfer(address(0), to, tokenId);
1016     }
1017 
1018     /**
1019      * @dev Destroys `tokenId`.
1020      * The approval is cleared when the token is burned.
1021      *
1022      * Requirements:
1023      *
1024      * - `tokenId` must exist.
1025      *
1026      * Emits a {Transfer} event.
1027      */
1028     function _burn(uint256 tokenId) internal virtual {
1029         address owner = ERC721.ownerOf(tokenId);
1030 
1031         _beforeTokenTransfer(owner, address(0), tokenId);
1032 
1033         // Clear approvals
1034         _approve(address(0), tokenId);
1035 
1036         _balances[owner] -= 1;
1037         delete _owners[tokenId];
1038 
1039         emit Transfer(owner, address(0), tokenId);
1040     }
1041 
1042     /**
1043      * @dev Transfers `tokenId` from `from` to `to`.
1044      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1045      *
1046      * Requirements:
1047      *
1048      * - `to` cannot be the zero address.
1049      * - `tokenId` token must be owned by `from`.
1050      *
1051      * Emits a {Transfer} event.
1052      */
1053     function _transfer(
1054         address from,
1055         address to,
1056         uint256 tokenId
1057     ) internal virtual {
1058         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1059         require(to != address(0), "ERC721: transfer to the zero address");
1060 
1061         _beforeTokenTransfer(from, to, tokenId);
1062 
1063         // Clear approvals from the previous owner
1064         _approve(address(0), tokenId);
1065 
1066         _balances[from] -= 1;
1067         _balances[to] += 1;
1068         _owners[tokenId] = to;
1069 
1070         emit Transfer(from, to, tokenId);
1071     }
1072 
1073     /**
1074      * @dev Approve `to` to operate on `tokenId`
1075      *
1076      * Emits a {Approval} event.
1077      */
1078     function _approve(address to, uint256 tokenId) internal virtual {
1079         _tokenApprovals[tokenId] = to;
1080         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1081     }
1082 
1083     /**
1084      * @dev Approve `operator` to operate on all of `owner` tokens
1085      *
1086      * Emits a {ApprovalForAll} event.
1087      */
1088     function _setApprovalForAll(
1089         address owner,
1090         address operator,
1091         bool approved
1092     ) internal virtual {
1093         require(owner != operator, "ERC721: approve to caller");
1094         _operatorApprovals[owner][operator] = approved;
1095         emit ApprovalForAll(owner, operator, approved);
1096     }
1097 
1098     /**
1099      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1100      * The call is not executed if the target address is not a contract.
1101      *
1102      * @param from address representing the previous owner of the given token ID
1103      * @param to target address that will receive the tokens
1104      * @param tokenId uint256 ID of the token to be transferred
1105      * @param _data bytes optional data to send along with the call
1106      * @return bool whether the call correctly returned the expected magic value
1107      */
1108     function _checkOnERC721Received(
1109         address from,
1110         address to,
1111         uint256 tokenId,
1112         bytes memory _data
1113     ) private returns (bool) {
1114         if (to.isContract()) {
1115             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1116                 return retval == IERC721Receiver.onERC721Received.selector;
1117             } catch (bytes memory reason) {
1118                 if (reason.length == 0) {
1119                     revert("ERC721: transfer to non ERC721Receiver implementer");
1120                 } else {
1121                     assembly {
1122                         revert(add(32, reason), mload(reason))
1123                     }
1124                 }
1125             }
1126         } else {
1127             return true;
1128         }
1129     }
1130 
1131     /**
1132      * @dev Hook that is called before any token transfer. This includes minting
1133      * and burning.
1134      *
1135      * Calling conditions:
1136      *
1137      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1138      * transferred to `to`.
1139      * - When `from` is zero, `tokenId` will be minted for `to`.
1140      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1141      * - `from` and `to` are never both zero.
1142      *
1143      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1144      */
1145     function _beforeTokenTransfer(
1146         address from,
1147         address to,
1148         uint256 tokenId
1149     ) internal virtual {}
1150 }
1151 
1152 // File: contracts/SACC.sol
1153 
1154 pragma solidity >=0.7.0 <0.9.0;
1155 
1156 
1157 contract SketchyApeComicClub is ERC721, Ownable {
1158   using Strings for uint256;
1159   using Counters for Counters.Counter;
1160 
1161   Counters.Counter private supply;
1162 
1163   string public uriPrefix = "";
1164   string public uriSuffix = ".json";
1165   string public hiddenMetadataUri;
1166   
1167   uint256 public maxSupply = 10000;
1168   uint256 public maxMintAmountPerTx = 3;
1169 
1170   bool public paused = true;
1171   bool public revealed = false;
1172 
1173   address public sabcAddress;
1174 
1175   constructor() ERC721("Sketchy Ape Comic Club", "SACC") {
1176     setHiddenMetadataUri("ipfs://QmSP6X4g4oPGb4m8XLdXxBEbms18KQ8HjG2Z9TcpSg1xjG/hidden.json");
1177     setsabcAddress(0xaDC28cac9c1d53cC7457b11CC9423903dc09DDDc);
1178   }
1179 
1180   modifier mintCompliance(uint256 _mintAmount) {
1181     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
1182     require(supply.current() + _mintAmount <= maxSupply, "Max supply exceeded!");
1183     _;
1184   }
1185 
1186   function totalSupply() public view returns (uint256) {
1187     return supply.current();
1188   }
1189 
1190   function mint(uint256 _mintAmount) public mintCompliance(_mintAmount) {
1191     require(!paused, "The contract is paused!");
1192     IERC721 token = IERC721(sabcAddress);
1193     uint256 ownedAmount = token.balanceOf(msg.sender);
1194     require(ownedAmount >= 1, "You don't own SABC NFTs");
1195 
1196     _mintLoop(msg.sender, _mintAmount);
1197   }
1198   
1199   function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
1200     _mintLoop(_receiver, _mintAmount);
1201   }
1202 
1203   function walletOfOwner(address _owner)
1204     public
1205     view
1206     returns (uint256[] memory)
1207   {
1208     uint256 ownerTokenCount = balanceOf(_owner);
1209     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1210     uint256 currentTokenId = 1;
1211     uint256 ownedTokenIndex = 0;
1212 
1213     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1214       address currentTokenOwner = ownerOf(currentTokenId);
1215 
1216       if (currentTokenOwner == _owner) {
1217         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1218 
1219         ownedTokenIndex++;
1220       }
1221 
1222       currentTokenId++;
1223     }
1224 
1225     return ownedTokenIds;
1226   }
1227 
1228   function tokenURI(uint256 _tokenId)
1229     public
1230     view
1231     virtual
1232     override
1233     returns (string memory)
1234   {
1235     require(
1236       _exists(_tokenId),
1237       "ERC721Metadata: URI query for nonexistent token"
1238     );
1239 
1240     if (revealed == false) {
1241       return hiddenMetadataUri;
1242     }
1243 
1244     string memory currentBaseURI = _baseURI();
1245     return bytes(currentBaseURI).length > 0
1246         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1247         : "";
1248   }
1249 
1250   function setsabcAddress(address _newAddress) public onlyOwner {
1251     sabcAddress = _newAddress;
1252   }
1253 
1254   function setRevealed(bool _state) public onlyOwner {
1255     revealed = _state;
1256   }
1257 
1258   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1259     maxMintAmountPerTx = _maxMintAmountPerTx;
1260   }
1261 
1262   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1263     hiddenMetadataUri = _hiddenMetadataUri;
1264   }
1265 
1266   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1267     uriPrefix = _uriPrefix;
1268   }
1269 
1270   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1271     uriSuffix = _uriSuffix;
1272   }
1273 
1274   function setPaused(bool _state) public onlyOwner {
1275     paused = _state;
1276   }
1277 
1278   function withdraw() public onlyOwner {
1279     // This will transfer the remaining contract balance to the owner.
1280     // Do not remove this otherwise you will not be able to withdraw the funds.
1281     // =============================================================================
1282     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1283     require(os);
1284     // =============================================================================
1285   }
1286 
1287   function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1288     for (uint256 i = 0; i < _mintAmount; i++) {
1289       supply.increment();
1290       _safeMint(_receiver, supply.current());
1291     }
1292   }
1293 
1294   function _baseURI() internal view virtual override returns (string memory) {
1295     return uriPrefix;
1296   }
1297 }