1 // SPDX-License-Identifier: MIT
2 
3        /* Developed by Advent Robots https://adventrobots.com/
4        
5        ** Flattened file, Containing all extensions.
6        ** Contract "Advent_Worlds" start at line 1353.
7   
8 
9         pragma solidity ^0.8.0;
10         OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
11         @dev String operations.*/
12 
13 
14         library Strings {
15             bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
16 
17             /**
18             * @dev Converts a `uint256` to its ASCII `string` decimal representation.
19             */
20             function toString(uint256 value) internal pure returns (string memory) {
21                 // Inspired by OraclizeAPI's implementation - MIT licence
22                 // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
23 
24                 if (value == 0) {
25                     return "0";
26                 }
27                 uint256 temp = value;
28                 uint256 digits;
29                 while (temp != 0) {
30                     digits++;
31                     temp /= 10;
32                 }
33                 bytes memory buffer = new bytes(digits);
34                 while (value != 0) {
35                     digits -= 1;
36                     buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
37                     value /= 10;
38                 }
39                 return string(buffer);
40             }
41 
42             /**
43             * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
44             */
45             function toHexString(uint256 value) internal pure returns (string memory) {
46                 if (value == 0) {
47                     return "0x00";
48                 }
49                 uint256 temp = value;
50                 uint256 length = 0;
51                 while (temp != 0) {
52                     length++;
53                     temp >>= 8;
54                 }
55                 return toHexString(value, length);
56             }
57 
58             /**
59             * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
60             */
61             function toHexString(uint256 value, uint256 length)
62                 internal
63                 pure
64                 returns (string memory)
65             {
66                 bytes memory buffer = new bytes(2 * length + 2);
67                 buffer[0] = "0";
68                 buffer[1] = "x";
69                 for (uint256 i = 2 * length + 1; i > 1; --i) {
70                     buffer[i] = _HEX_SYMBOLS[value & 0xf];
71                     value >>= 4;
72                 }
73                 require(value == 0, "Strings: hex length insufficient");
74                 return string(buffer);
75             }
76         }
77 
78         // File: gist-270e50cc401a88221663666c2f449393/Context.sol
79 
80 
81     pragma solidity ^0.8.0;
82 
83         /**
84         * @dev Provides information about the current execution context, including the
85         * sender of the transaction and its data. While these are generally available
86         * via msg.sender and msg.data, they should not be accessed in such a direct
87         * manner, since when dealing with meta-transactions the account sending and
88         * paying for execution may not be the actual sender (as far as an application
89         * is concerned).
90         *
91         * This contract is only required for intermediate, library-like contracts.
92         */
93         abstract contract Context {
94             function _msgSender() internal view virtual returns (address) {
95                 return msg.sender;
96             }
97 
98             function _msgData() internal view virtual returns (bytes calldata) {
99                 return msg.data;
100             }
101         }
102 
103         // File: gist-270e50cc401a88221663666c2f449393/Ownable.sol
104 
105 
106         pragma solidity ^0.8.0;
107 
108 
109         /**
110         * @dev Contract module which provides a basic access control mechanism, where
111         * there is an account (an owner) that can be granted exclusive access to
112         * specific functions.
113         *
114         * By default, the owner account will be the one that deploys the contract. This
115         * can later be changed with {transferOwnership}.
116         *
117         * This module is used through inheritance. It will make available the modifier
118         * `onlyOwner`, which can be applied to your functions to restrict their use to
119         * the owner.
120         */
121         abstract contract Ownable is Context {
122             address private _owner;
123 
124             event OwnershipTransferred(
125                 address indexed previousOwner,
126                 address indexed newOwner
127             );
128 
129             /**
130             * @dev Initializes the contract setting the deployer as the initial owner.
131             */
132             constructor() {
133                 _transferOwnership(_msgSender());
134             }
135 
136             /**
137             * @dev Returns the address of the current owner.
138             */
139             function owner() public view virtual returns (address) {
140                 return _owner;
141             }
142 
143             /**
144             * @dev Throws if called by any account other than the owner.
145             */
146             modifier onlyOwner() {
147                 require(owner() == _msgSender(), "Ownable: caller is not the owner");
148                 _;
149             }
150 
151             /**
152             * @dev Leaves the contract without owner. It will not be possible to call
153             * `onlyOwner` functions anymore. Can only be called by the current owner.
154             *
155             * NOTE: Renouncing ownership will leave the contract without an owner,
156             * thereby removing any functionality that is only available to the owner.
157             */
158             function renounceOwnership() public virtual onlyOwner {
159                 _transferOwnership(address(0));
160             }
161 
162             /**
163             * @dev Transfers ownership of the contract to a new account (`newOwner`).
164             * Can only be called by the current owner.
165             */
166             function transferOwnership(address newOwner) public virtual onlyOwner {
167                 require(
168                     newOwner != address(0),
169                     "Ownable: new owner is the zero address"
170                 );
171                 _transferOwnership(newOwner);
172             }
173 
174             /**
175             * @dev Transfers ownership of the contract to a new account (`newOwner`).
176             * Internal function without access restriction.
177             */
178             function _transferOwnership(address newOwner) internal virtual {
179                 address oldOwner = _owner;
180                 _owner = newOwner;
181                 emit OwnershipTransferred(oldOwner, newOwner);
182             }
183         }
184 
185         // File: gist-270e50cc401a88221663666c2f449393/Address.sol
186 
187 
188         // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
189 
190         pragma solidity ^0.8.1;
191 
192         /**
193         * @dev Collection of functions related to the address type
194         */
195         library Address {
196             /**
197             * @dev Returns true if `account` is a contract.
198             *
199             * [IMPORTANT]
200             * ====
201             * It is unsafe to assume that an address for which this function returns
202             * false is an externally-owned account (EOA) and not a contract.
203             *
204             * Among others, `isContract` will return false for the following
205             * types of addresses:
206             *
207             *  - an externally-owned account
208             *  - a contract in construction
209             *  - an address where a contract will be created
210             *  - an address where a contract lived, but was destroyed
211             * ====
212             *
213             * [IMPORTANT]
214             * ====
215             * You shouldn't rely on `isContract` to protect against flash loan attacks!
216             *
217             * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
218             * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
219             * constructor.
220             * ====
221             */
222             function isContract(address account) internal view returns (bool) {
223                 // This method relies on extcodesize/address.code.length, which returns 0
224                 // for contracts in construction, since the code is only stored at the end
225                 // of the constructor execution.
226 
227                 return account.code.length > 0;
228             }
229 
230             /**
231             * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
232             * `recipient`, forwarding all available gas and reverting on errors.
233             *
234             * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
235             * of certain opcodes, possibly making contracts go over the 2300 gas limit
236             * imposed by `transfer`, making them unable to receive funds via
237             * `transfer`. {sendValue} removes this limitation.
238             *
239             * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
240             *
241             * IMPORTANT: because control is transferred to `recipient`, care must be
242             * taken to not create reentrancy vulnerabilities. Consider using
243             * {ReentrancyGuard} or the
244             * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
245             */
246             function sendValue(address payable recipient, uint256 amount) internal {
247                 require(
248                     address(this).balance >= amount,
249                     "Address: insufficient balance"
250                 );
251 
252                 (bool success, ) = recipient.call{value: amount}("");
253                 require(
254                     success,
255                     "Address: unable to send value, recipient may have reverted"
256                 );
257             }
258 
259             /**
260             * @dev Performs a Solidity function call using a low level `call`. A
261             * plain `call` is an unsafe replacement for a function call: use this
262             * function instead.
263             *
264             * If `target` reverts with a revert reason, it is bubbled up by this
265             * function (like regular Solidity function calls).
266             *
267             * Returns the raw returned data. To convert to the expected return value,
268             * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
269             *
270             * Requirements:
271             *
272             * - `target` must be a contract.
273             * - calling `target` with `data` must not revert.
274             *
275             * _Available since v3.1._
276             */
277             function functionCall(address target, bytes memory data)
278                 internal
279                 returns (bytes memory)
280             {
281                 return functionCall(target, data, "Address: low-level call failed");
282             }
283 
284             /**
285             * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
286             * `errorMessage` as a fallback revert reason when `target` reverts.
287             *
288             * _Available since v3.1._
289             */
290             function functionCall(
291                 address target,
292                 bytes memory data,
293                 string memory errorMessage
294             ) internal returns (bytes memory) {
295                 return functionCallWithValue(target, data, 0, errorMessage);
296             }
297 
298             /**
299             * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
300             * but also transferring `value` wei to `target`.
301             *
302             * Requirements:
303             *
304             * - the calling contract must have an ETH balance of at least `value`.
305             * - the called Solidity function must be `payable`.
306             *
307             * _Available since v3.1._
308             */
309             function functionCallWithValue(
310                 address target,
311                 bytes memory data,
312                 uint256 value
313             ) internal returns (bytes memory) {
314                 return
315                     functionCallWithValue(
316                         target,
317                         data,
318                         value,
319                         "Address: low-level call with value failed"
320                     );
321             }
322 
323             /**
324             * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
325             * with `errorMessage` as a fallback revert reason when `target` reverts.
326             *
327             * _Available since v3.1._
328             */
329             function functionCallWithValue(
330                 address target,
331                 bytes memory data,
332                 uint256 value,
333                 string memory errorMessage
334             ) internal returns (bytes memory) {
335                 require(
336                     address(this).balance >= value,
337                     "Address: insufficient balance for call"
338                 );
339                 require(isContract(target), "Address: call to non-contract");
340 
341                 (bool success, bytes memory returndata) = target.call{value: value}(
342                     data
343                 );
344                 return verifyCallResult(success, returndata, errorMessage);
345             }
346 
347             /**
348             * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
349             * but performing a static call.
350             *
351             * _Available since v3.3._
352             */
353             function functionStaticCall(address target, bytes memory data)
354                 internal
355                 view
356                 returns (bytes memory)
357             {
358                 return
359                     functionStaticCall(
360                         target,
361                         data,
362                         "Address: low-level static call failed"
363                     );
364             }
365 
366             /**
367             * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
368             * but performing a static call.
369             *
370             * _Available since v3.3._
371             */
372             function functionStaticCall(
373                 address target,
374                 bytes memory data,
375                 string memory errorMessage
376             ) internal view returns (bytes memory) {
377                 require(isContract(target), "Address: static call to non-contract");
378 
379                 (bool success, bytes memory returndata) = target.staticcall(data);
380                 return verifyCallResult(success, returndata, errorMessage);
381             }
382 
383             /**
384             * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
385             * but performing a delegate call.
386             *
387             * _Available since v3.4._
388             */
389             function functionDelegateCall(address target, bytes memory data)
390                 internal
391                 returns (bytes memory)
392             {
393                 return
394                     functionDelegateCall(
395                         target,
396                         data,
397                         "Address: low-level delegate call failed"
398                     );
399             }
400 
401             /**
402             * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
403             * but performing a delegate call.
404             *
405             * _Available since v3.4._
406             */
407             function functionDelegateCall(
408                 address target,
409                 bytes memory data,
410                 string memory errorMessage
411             ) internal returns (bytes memory) {
412                 require(isContract(target), "Address: delegate call to non-contract");
413 
414                 (bool success, bytes memory returndata) = target.delegatecall(data);
415                 return verifyCallResult(success, returndata, errorMessage);
416             }
417 
418             /**
419             * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
420             * revert reason using the provided one.
421             *
422             * _Available since v4.3._
423             */
424             function verifyCallResult(
425                 bool success,
426                 bytes memory returndata,
427                 string memory errorMessage
428             ) internal pure returns (bytes memory) {
429                 if (success) {
430                     return returndata;
431                 } else {
432                     // Look for revert reason and bubble it up if present
433                     if (returndata.length > 0) {
434                         // The easiest way to bubble the revert reason is using memory via assembly
435 
436                         assembly {
437                             let returndata_size := mload(returndata)
438                             revert(add(32, returndata), returndata_size)
439                         }
440                     } else {
441                         revert(errorMessage);
442                     }
443                 }
444             }
445         }
446 
447         // File: gist-270e50cc401a88221663666c2f449393/IERC721Receiver.sol
448 
449 
450         // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
451 
452         pragma solidity ^0.8.0;
453 
454         /**
455         * @title ERC721 token receiver interface
456         * @dev Interface for any contract that wants to support safeTransfers
457         * from ERC721 asset contracts.
458         */
459         interface IERC721Receiver {
460             /**
461             * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
462             * by `operator` from `from`, this function is called.
463             *
464             * It must return its Solidity selector to confirm the token transfer.
465             * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
466             *
467             * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
468             */
469             function onERC721Received(
470                 address operator,
471                 address from,
472                 uint256 tokenId,
473                 bytes calldata data
474             ) external returns (bytes4);
475         }
476 
477         // File: gist-270e50cc401a88221663666c2f449393/IERC165.sol
478 
479 
480         // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
481 
482         pragma solidity ^0.8.0;
483 
484         /**
485         * @dev Interface of the ERC165 standard, as defined in the
486         * https://eips.ethereum.org/EIPS/eip-165[EIP].
487         *
488         * Implementers can declare support of contract interfaces, which can then be
489         * queried by others ({ERC165Checker}).
490         *
491         * For an implementation, see {ERC165}.
492         */
493         interface IERC165 {
494             /**
495             * @dev Returns true if this contract implements the interface defined by
496             * `interfaceId`. See the corresponding
497             * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
498             * to learn more about how these ids are created.
499             *
500             * This function call must use less than 30 000 gas.
501             */
502             function supportsInterface(bytes4 interfaceId) external view returns (bool);
503         }
504 
505         // File: gist-270e50cc401a88221663666c2f449393/ERC165.sol
506 
507 
508         // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
509 
510         pragma solidity ^0.8.0;
511 
512 
513         /**
514         * @dev Implementation of the {IERC165} interface.
515         *
516         * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
517         * for the additional interface id that will be supported. For example:
518         *
519         * ```solidity
520         * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
521         *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
522         * }
523         * ```
524         *
525         * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
526         */
527         abstract contract ERC165 is IERC165 {
528             /**
529             * @dev See {IERC165-supportsInterface}.
530             */
531             function supportsInterface(bytes4 interfaceId)
532                 public
533                 view
534                 virtual
535                 override
536                 returns (bool)
537             {
538                 return interfaceId == type(IERC165).interfaceId;
539             }
540         }
541 
542         // File: gist-270e50cc401a88221663666c2f449393/IERC721.sol
543 
544 
545         // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
546 
547         pragma solidity ^0.8.0;
548 
549 
550         /**
551         * @dev Required interface of an ERC721 compliant contract.
552         */
553         interface IERC721 is IERC165 {
554             /**
555             * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
556             */
557             event Transfer(
558                 address indexed from,
559                 address indexed to,
560                 uint256 indexed tokenId
561             );
562 
563             /**
564             * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
565             */
566             event Approval(
567                 address indexed owner,
568                 address indexed approved,
569                 uint256 indexed tokenId
570             );
571 
572             /**
573             * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
574             */
575             event ApprovalForAll(
576                 address indexed owner,
577                 address indexed operator,
578                 bool approved
579             );
580 
581             /**
582             * @dev Returns the number of tokens in ``owner``'s account.
583             */
584             function balanceOf(address owner) external view returns (uint256 balance);
585 
586             /**
587             * @dev Returns the owner of the `tokenId` token.
588             *
589             * Requirements:
590             *
591             * - `tokenId` must exist.
592             */
593             function ownerOf(uint256 tokenId) external view returns (address owner);
594 
595             /**
596             * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
597             * are aware of the ERC721 protocol to prevent tokens from being forever locked.
598             *
599             * Requirements:
600             *
601             * - `from` cannot be the zero address.
602             * - `to` cannot be the zero address.
603             * - `tokenId` token must exist and be owned by `from`.
604             * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
605             * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
606             *
607             * Emits a {Transfer} event.
608             */
609             function safeTransferFrom(
610                 address from,
611                 address to,
612                 uint256 tokenId
613             ) external;
614 
615             /**
616             * @dev Transfers `tokenId` token from `from` to `to`.
617             *
618             * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
619             *
620             * Requirements:
621             *
622             * - `from` cannot be the zero address.
623             * - `to` cannot be the zero address.
624             * - `tokenId` token must be owned by `from`.
625             * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
626             *
627             * Emits a {Transfer} event.
628             */
629             function transferFrom(
630                 address from,
631                 address to,
632                 uint256 tokenId
633             ) external;
634 
635             /**
636             * @dev Gives permission to `to` to transfer `tokenId` token to another account.
637             * The approval is cleared when the token is transferred.
638             *
639             * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
640             *
641             * Requirements:
642             *
643             * - The caller must own the token or be an approved operator.
644             * - `tokenId` must exist.
645             *
646             * Emits an {Approval} event.
647             */
648             function approve(address to, uint256 tokenId) external;
649 
650             /**
651             * @dev Returns the account approved for `tokenId` token.
652             *
653             * Requirements:
654             *
655             * - `tokenId` must exist.
656             */
657             function getApproved(uint256 tokenId)
658                 external
659                 view
660                 returns (address operator);
661 
662             /**
663             * @dev Approve or remove `operator` as an operator for the caller.
664             * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
665             *
666             * Requirements:
667             *
668             * - The `operator` cannot be the caller.
669             *
670             * Emits an {ApprovalForAll} event.
671             */
672             function setApprovalForAll(address operator, bool _approved) external;
673 
674             /**
675             * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
676             *
677             * See {setApprovalForAll}
678             */
679             function isApprovedForAll(address owner, address operator)
680                 external
681                 view
682                 returns (bool);
683 
684             /**
685             * @dev Safely transfers `tokenId` token from `from` to `to`.
686             *
687             * Requirements:
688             *
689             * - `from` cannot be the zero address.
690             * - `to` cannot be the zero address.
691             * - `tokenId` token must exist and be owned by `from`.
692             * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
693             * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
694             *
695             * Emits a {Transfer} event.
696             */
697             function safeTransferFrom(
698                 address from,
699                 address to,
700                 uint256 tokenId,
701                 bytes calldata data
702             ) external;
703         }
704 
705         // File: gist-270e50cc401a88221663666c2f449393/IERC721Enumerable.sol
706 
707 
708         // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
709 
710         pragma solidity ^0.8.0;
711 
712 
713         /**
714         * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
715         * @dev See https://eips.ethereum.org/EIPS/eip-721
716         */
717         interface IERC721Enumerable is IERC721 {
718             /**
719             * @dev Returns the total amount of tokens stored by the contract.
720             */
721             function totalSupply() external view returns (uint256);
722 
723             /**
724             * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
725             * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
726             */
727             function tokenOfOwnerByIndex(address owner, uint256 index)
728                 external
729                 view
730                 returns (uint256);
731 
732             /**
733             * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
734             * Use along with {totalSupply} to enumerate all tokens.
735             */
736             function tokenByIndex(uint256 index) external view returns (uint256);
737         }
738 
739         // File: gist-270e50cc401a88221663666c2f449393/IERC721Metadata.sol
740 
741 
742         // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
743 
744         pragma solidity ^0.8.0;
745 
746 
747         /**
748         * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
749         * @dev See https://eips.ethereum.org/EIPS/eip-721
750         */
751         interface IERC721Metadata is IERC721 {
752             /**
753             * @dev Returns the token collection name.
754             */
755             function name() external view returns (string memory);
756 
757             /**
758             * @dev Returns the token collection symbol.
759             */
760             function symbol() external view returns (string memory);
761 
762             /**
763             * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
764             */
765             function tokenURI(uint256 tokenId) external view returns (string memory);
766         }
767 
768         // File: gist-270e50cc401a88221663666c2f449393/ERC721A.sol
769 
770 
771         // Creator: Chiru Labs
772 
773         pragma solidity ^0.8.0;
774 
775 
776 
777 
778 
779 
780 
781 
782 
783         /**
784         * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
785         * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
786         *
787         * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
788         *
789         * Does not support burning tokens to address(0).
790         *
791         * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
792         */
793         contract ERC721A is
794             Context,
795             ERC165,
796             IERC721,
797             IERC721Metadata,
798             IERC721Enumerable
799         {
800             using Address for address;
801             using Strings for uint256;
802 
803             struct TokenOwnership {
804                 address addr;
805                 uint64 startTimestamp;
806             }
807 
808             struct AddressData {
809                 uint128 balance;
810                 uint128 numberMinted;
811             }
812 
813             uint256 internal currentIndex;
814 
815             // Token name
816             string private _name;
817 
818             // Token symbol
819             string private _symbol;
820 
821             // Mapping from token ID to ownership details
822             // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
823             mapping(uint256 => TokenOwnership) internal _ownerships;
824 
825             // Mapping owner address to address data
826             mapping(address => AddressData) private _addressData;
827 
828             // Mapping from token ID to approved address
829             mapping(uint256 => address) private _tokenApprovals;
830 
831             // Mapping from owner to operator approvals
832             mapping(address => mapping(address => bool)) private _operatorApprovals;
833 
834             constructor(string memory name_, string memory symbol_) {
835                 _name = name_;
836                 _symbol = symbol_;
837             }
838 
839             /**
840             * @dev See {IERC721Enumerable-totalSupply}.
841             */
842             function totalSupply() public view override returns (uint256) {
843                 return currentIndex;
844             }
845 
846             /**
847             * @dev See {IERC721Enumerable-tokenByIndex}.
848             */
849             function tokenByIndex(uint256 index)
850                 public
851                 view
852                 override
853                 returns (uint256)
854             {
855                 require(index < totalSupply(), "ERC721A: global index out of bounds");
856                 return index;
857             }
858 
859             /**
860             * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
861             * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
862             * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
863             */
864             function tokenOfOwnerByIndex(address owner, uint256 index)
865                 public
866                 view
867                 override
868                 returns (uint256)
869             {
870                 require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
871                 uint256 numMintedSoFar = totalSupply();
872                 uint256 tokenIdsIdx;
873                 address currOwnershipAddr;
874 
875                 // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
876                 unchecked {
877                     for (uint256 i; i < numMintedSoFar; i++) {
878                         TokenOwnership memory ownership = _ownerships[i];
879                         if (ownership.addr != address(0)) {
880                             currOwnershipAddr = ownership.addr;
881                         }
882                         if (currOwnershipAddr == owner) {
883                             if (tokenIdsIdx == index) {
884                                 return i;
885                             }
886                             tokenIdsIdx++;
887                         }
888                     }
889                 }
890 
891                 revert("ERC721A: unable to get token of owner by index");
892             }
893 
894             /**
895             * @dev See {IERC165-supportsInterface}.
896             */
897             function supportsInterface(bytes4 interfaceId)
898                 public
899                 view
900                 virtual
901                 override(ERC165, IERC165)
902                 returns (bool)
903             {
904                 return
905                     interfaceId == type(IERC721).interfaceId ||
906                     interfaceId == type(IERC721Metadata).interfaceId ||
907                     interfaceId == type(IERC721Enumerable).interfaceId ||
908                     super.supportsInterface(interfaceId);
909             }
910 
911             /**
912             * @dev See {IERC721-balanceOf}.
913             */
914             function balanceOf(address owner) public view override returns (uint256) {
915                 require(
916                     owner != address(0),
917                     "ERC721A: balance query for the zero address"
918                 );
919                 return uint256(_addressData[owner].balance);
920             }
921 
922             function _numberMinted(address owner) internal view returns (uint256) {
923                 require(
924                     owner != address(0),
925                     "ERC721A: number minted query for the zero address"
926                 );
927                 return uint256(_addressData[owner].numberMinted);
928             }
929 
930             /**
931             * Gas spent here starts off proportional to the maximum mint batch size.
932             * It gradually moves to O(1) as tokens get transferred around in the collection over time.
933             */
934             function ownershipOf(uint256 tokenId)
935                 internal
936                 view
937                 returns (TokenOwnership memory)
938             {
939                 require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
940 
941                 unchecked {
942                     for (uint256 curr = tokenId; curr >= 0; curr--) {
943                         TokenOwnership memory ownership = _ownerships[curr];
944                         if (ownership.addr != address(0)) {
945                             return ownership;
946                         }
947                     }
948                 }
949 
950                 revert("ERC721A: unable to determine the owner of token");
951             }
952 
953             /**
954             * @dev See {IERC721-ownerOf}.
955             */
956             function ownerOf(uint256 tokenId) public view override returns (address) {
957                 return ownershipOf(tokenId).addr;
958             }
959 
960             /**
961             * @dev See {IERC721Metadata-name}.
962             */
963             function name() public view virtual override returns (string memory) {
964                 return _name;
965             }
966 
967             /**
968             * @dev See {IERC721Metadata-symbol}.
969             */
970             function symbol() public view virtual override returns (string memory) {
971                 return _symbol;
972             }
973 
974             /**
975             * @dev See {IERC721Metadata-tokenURI}.
976             */
977             function tokenURI(uint256 tokenId)
978                 public
979                 view
980                 virtual
981                 override
982                 returns (string memory)
983             {
984                 require(
985                     _exists(tokenId),
986                     "ERC721Metadata: URI query for nonexistent token"
987                 );
988 
989                 string memory baseURI = _baseURI();
990                 return
991                     bytes(baseURI).length != 0
992                         ? string(abi.encodePacked(baseURI, tokenId.toString()))
993                         : "";
994             }
995 
996             /**
997             * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
998             * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
999             * by default, can be overriden in child contracts.
1000             */
1001             function _baseURI() internal view virtual returns (string memory) {
1002                 return "";
1003             }
1004 
1005             /**
1006             * @dev See {IERC721-approve}.
1007             */
1008             function approve(address to, uint256 tokenId) public override {
1009                 address owner = ERC721A.ownerOf(tokenId);
1010                 require(to != owner, "ERC721A: approval to current owner");
1011 
1012                 require(
1013                     _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1014                     "ERC721A: approve caller is not owner nor approved for all"
1015                 );
1016 
1017                 _approve(to, tokenId, owner);
1018             }
1019 
1020             /**
1021             * @dev See {IERC721-getApproved}.
1022             */
1023             function getApproved(uint256 tokenId)
1024                 public
1025                 view
1026                 override
1027                 returns (address)
1028             {
1029                 require(
1030                     _exists(tokenId),
1031                     "ERC721A: approved query for nonexistent token"
1032                 );
1033 
1034                 return _tokenApprovals[tokenId];
1035             }
1036 
1037             /**
1038             * @dev See {IERC721-setApprovalForAll}.
1039             */
1040             function setApprovalForAll(address operator, bool approved)
1041                 public
1042                 override
1043             {
1044                 require(operator != _msgSender(), "ERC721A: approve to caller");
1045 
1046                 _operatorApprovals[_msgSender()][operator] = approved;
1047                 emit ApprovalForAll(_msgSender(), operator, approved);
1048             }
1049 
1050             /**
1051             * @dev See {IERC721-isApprovedForAll}.
1052             */
1053             function isApprovedForAll(address owner, address operator)
1054                 public
1055                 view
1056                 virtual
1057                 override
1058                 returns (bool)
1059             {
1060                 return _operatorApprovals[owner][operator];
1061             }
1062 
1063             /**
1064             * @dev See {IERC721-transferFrom}.
1065             */
1066             function transferFrom(
1067                 address from,
1068                 address to,
1069                 uint256 tokenId
1070             ) public override {
1071                 _transfer(from, to, tokenId);
1072             }
1073 
1074             /**
1075             * @dev See {IERC721-safeTransferFrom}.
1076             */
1077             function safeTransferFrom(
1078                 address from,
1079                 address to,
1080                 uint256 tokenId
1081             ) public override {
1082                 safeTransferFrom(from, to, tokenId, "");
1083             }
1084 
1085             /**
1086             * @dev See {IERC721-safeTransferFrom}.
1087             */
1088             function safeTransferFrom(
1089                 address from,
1090                 address to,
1091                 uint256 tokenId,
1092                 bytes memory _data
1093             ) public override {
1094                 _transfer(from, to, tokenId);
1095                 require(
1096                     _checkOnERC721Received(from, to, tokenId, _data),
1097                     "ERC721A: transfer to non ERC721Receiver implementer"
1098                 );
1099             }
1100 
1101             /**
1102             * @dev Returns whether `tokenId` exists.
1103             *
1104             * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1105             *
1106             * Tokens start existing when they are minted (`_mint`),
1107             */
1108             function _exists(uint256 tokenId) internal view returns (bool) {
1109                 return tokenId < currentIndex;
1110             }
1111 
1112             function _safeMint(address to, uint256 quantity) internal {
1113                 _safeMint(to, quantity, "");
1114             }
1115 
1116             /**
1117             * @dev Safely mints `quantity` tokens and transfers them to `to`.
1118             *
1119             * Requirements:
1120             *
1121             * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1122             * - `quantity` must be greater than 0.
1123             *
1124             * Emits a {Transfer} event.
1125             */
1126             function _safeMint(
1127                 address to,
1128                 uint256 quantity,
1129                 bytes memory _data
1130             ) internal {
1131                 _mint(to, quantity, _data, true);
1132             }
1133 
1134             /**
1135             * @dev Mints `quantity` tokens and transfers them to `to`.
1136             *
1137             * Requirements:
1138             *
1139             * - `to` cannot be the zero address.
1140             * - `quantity` must be greater than 0.
1141             *
1142             * Emits a {Transfer} event.
1143             */
1144             function _mint(
1145                 address to,
1146                 uint256 quantity,
1147                 bytes memory _data,
1148                 bool safe
1149             ) internal {
1150                 uint256 startTokenId = currentIndex;
1151                 require(to != address(0), "ERC721A: mint to the zero address");
1152                 require(quantity != 0, "ERC721A: quantity must be greater than 0");
1153 
1154                 _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1155 
1156                 // Overflows are incredibly unrealistic.
1157                 // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1158                 // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1159                 unchecked {
1160                     _addressData[to].balance += uint128(quantity);
1161                     _addressData[to].numberMinted += uint128(quantity);
1162 
1163                     _ownerships[startTokenId].addr = to;
1164                     _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1165 
1166                     uint256 updatedIndex = startTokenId;
1167 
1168                     for (uint256 i; i < quantity; i++) {
1169                         emit Transfer(address(0), to, updatedIndex);
1170                         if (safe) {
1171                             require(
1172                                 _checkOnERC721Received(
1173                                     address(0),
1174                                     to,
1175                                     updatedIndex,
1176                                     _data
1177                                 ),
1178                                 "ERC721A: transfer to non ERC721Receiver implementer"
1179                             );
1180                         }
1181 
1182                         updatedIndex++;
1183                     }
1184 
1185                     currentIndex = updatedIndex;
1186                 }
1187 
1188                 _afterTokenTransfers(address(0), to, startTokenId, quantity);
1189             }
1190 
1191             /**
1192             * @dev Transfers `tokenId` from `from` to `to`.
1193             *
1194             * Requirements:
1195             *
1196             * - `to` cannot be the zero address.
1197             * - `tokenId` token must be owned by `from`.
1198             *
1199             * Emits a {Transfer} event.
1200             */
1201             function _transfer(
1202                 address from,
1203                 address to,
1204                 uint256 tokenId
1205             ) private {
1206                 TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1207 
1208                 bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1209                     getApproved(tokenId) == _msgSender() ||
1210                     isApprovedForAll(prevOwnership.addr, _msgSender()));
1211 
1212                 require(
1213                     isApprovedOrOwner,
1214                     "ERC721A: transfer caller is not owner nor approved"
1215                 );
1216 
1217                 require(
1218                     prevOwnership.addr == from,
1219                     "ERC721A: transfer from incorrect owner"
1220                 );
1221                 require(to != address(0), "ERC721A: transfer to the zero address");
1222 
1223                 _beforeTokenTransfers(from, to, tokenId, 1);
1224 
1225                 // Clear approvals from the previous owner
1226                 _approve(address(0), tokenId, prevOwnership.addr);
1227 
1228                 // Underflow of the sender's balance is impossible because we check for
1229                 // ownership above and the recipient's balance can't realistically overflow.
1230                 // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1231                 unchecked {
1232                     _addressData[from].balance -= 1;
1233                     _addressData[to].balance += 1;
1234 
1235                     _ownerships[tokenId].addr = to;
1236                     _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1237 
1238                     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1239                     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1240                     uint256 nextTokenId = tokenId + 1;
1241                     if (_ownerships[nextTokenId].addr == address(0)) {
1242                         if (_exists(nextTokenId)) {
1243                             _ownerships[nextTokenId].addr = prevOwnership.addr;
1244                             _ownerships[nextTokenId].startTimestamp = prevOwnership
1245                                 .startTimestamp;
1246                         }
1247                     }
1248                 }
1249 
1250                 emit Transfer(from, to, tokenId);
1251                 _afterTokenTransfers(from, to, tokenId, 1);
1252             }
1253 
1254             /**
1255             * @dev Approve `to` to operate on `tokenId`
1256             *
1257             * Emits a {Approval} event.
1258             */
1259             function _approve(
1260                 address to,
1261                 uint256 tokenId,
1262                 address owner
1263             ) private {
1264                 _tokenApprovals[tokenId] = to;
1265                 emit Approval(owner, to, tokenId);
1266             }
1267 
1268             /**
1269             * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1270             * The call is not executed if the target address is not a contract.
1271             *
1272             * @param from address representing the previous owner of the given token ID
1273             * @param to target address that will receive the tokens
1274             * @param tokenId uint256 ID of the token to be transferred
1275             * @param _data bytes optional data to send along with the call
1276             * @return bool whether the call correctly returned the expected magic value
1277             */
1278             function _checkOnERC721Received(
1279                 address from,
1280                 address to,
1281                 uint256 tokenId,
1282                 bytes memory _data
1283             ) private returns (bool) {
1284                 if (to.isContract()) {
1285                     try
1286                         IERC721Receiver(to).onERC721Received(
1287                             _msgSender(),
1288                             from,
1289                             tokenId,
1290                             _data
1291                         )
1292                     returns (bytes4 retval) {
1293                         return retval == IERC721Receiver(to).onERC721Received.selector;
1294                     } catch (bytes memory reason) {
1295                         if (reason.length == 0) {
1296                             revert(
1297                                 "ERC721A: transfer to non ERC721Receiver implementer"
1298                             );
1299                         } else {
1300                             assembly {
1301                                 revert(add(32, reason), mload(reason))
1302                             }
1303                         }
1304                     }
1305                 } else {
1306                     return true;
1307                 }
1308             }
1309 
1310             /**
1311             * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1312             *
1313             * startTokenId - the first token id to be transferred
1314             * quantity - the amount to be transferred
1315             *
1316             * Calling conditions:
1317             *
1318             * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1319             * transferred to `to`.
1320             * - When `from` is zero, `tokenId` will be minted for `to`.
1321             */
1322             function _beforeTokenTransfers(
1323                 address from,
1324                 address to,
1325                 uint256 startTokenId,
1326                 uint256 quantity
1327             ) internal virtual {}
1328 
1329             /**
1330             * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1331             * minting.
1332             *
1333             * startTokenId - the first token id to be transferred
1334             * quantity - the amount to be transferred
1335             *
1336             * Calling conditions:
1337             *
1338             * - when `from` and `to` are both non-zero.
1339             * - `from` and `to` are never both zero.
1340             */
1341             function _afterTokenTransfers(
1342                 address from,
1343                 address to,
1344                 uint256 startTokenId,
1345                 uint256 quantity
1346             ) internal virtual {}
1347         }
1348         // File: gist-270e50cc401a88221663666c2f449393/XrootDotDev.sol
1349 
1350         /*
1351 
1352         
1353         ************************************************************************
1354 
1355         Contract Advent_Worlds
1356             * Using  OpenZeppelin Contracts, utils/Strings.sol
1357             * Using  OpenZeppelin Contracts,  access/Ownable.sol
1358             * Using ERC-721A, Creator: Chiru Labs  */
1359 
1360     pragma solidity 0.8.13;
1361 
1362         contract Advent_Worlds is ERC721A, Ownable {
1363             using Strings for uint256;
1364 
1365             string public baseURI;
1366             string public baseExtension = ".json";
1367             string public notRevealedUri;
1368 
1369         // Max supply is 1111 NFTs
1370         // Max mint amount Per Tx is 3, and is modifiable functions
1371         // Max amount of NFTs an address can own is set to 3, It is also Modifiable
1372         // Cost is Modifiable
1373         // Public Supply is 1061 as 50 are reserved
1374             uint256 public cost = 0 ether;
1375             uint256 public maxSupply = 1111;
1376             uint256 public maxMintAmount = 3;
1377             uint256 public nftPerAddressLimit = 3;
1378        
1379        // Reserved Tokens Can minted once the rest of Supply is already minted    
1380             uint256 public ReservedNFT = 50;
1381 
1382        // Contract is pauseable
1383             bool public paused = false;
1384             bool public revealed = true;
1385 
1386         // Name and Symbol are not Modifiable once deployed.
1387         //BaseUri and Hidden MetaData URI Can be changed If required
1388             constructor(
1389                 string memory _name,
1390                 string memory _symbol,
1391                 string memory _initBaseURI,
1392                 string memory _initNotRevealedUri
1393             ) ERC721A(_name, _symbol) {
1394                 setBaseURI(_initBaseURI);
1395                 setNotRevealedURI(_initNotRevealedUri);
1396             }
1397 
1398         // internal Function 
1399             function _baseURI() internal view virtual override returns (string memory) {
1400                 return baseURI;
1401             }
1402 
1403     // public functions
1404         //Only whitelisted users can mint if onlyWhitelist is set to true.
1405         //public can mint after setonlywhitelist is set to false
1406             function mint(uint256 _mintAmount) public payable {
1407                 require(!paused, "Contract is paused");
1408                 uint256 supply = totalSupply();
1409                 require(_mintAmount > 0, "Mint amount must be greater than 0");
1410                 require(supply + _mintAmount <= maxSupply, "Mint amount must be equal to or below available tokens");
1411                  
1412                 if (msg.sender != owner()) {
1413                     require(supply + _mintAmount <= maxSupply - ReservedNFT, "Mint amount must be equal to or below available tokens");
1414                     require(msg.value >= cost * _mintAmount, "Insufficient balance");
1415                     uint256 ownerTokenCount = balanceOf(msg.sender);
1416                     require (ownerTokenCount < nftPerAddressLimit, "Mint amount is exceeding Perwallet Token limit");
1417                     require(_mintAmount <= maxMintAmount, "Mint amount is greater than max mint amount");
1418                 }
1419                 _safeMint(msg.sender, _mintAmount);   
1420             }
1421 
1422             function walletOfOwner(address _owner)
1423                 public
1424                 view
1425                 returns (uint256[] memory)
1426             {
1427                 uint256 ownerTokenCount = balanceOf(_owner);
1428                 uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1429                 for (uint256 i; i < ownerTokenCount; i++) {
1430                 tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1431                 }
1432                 return tokenIds;
1433             }
1434 
1435             function tokenURI(uint256 tokenId)
1436                 public
1437                 view
1438                 virtual
1439                 override
1440                 returns (string memory)
1441             {
1442                 require(
1443                 _exists(tokenId),
1444                 "ERC721Metadata: URI query for nonexistent token"
1445                 );
1446                 
1447                 if(revealed == false) {
1448                     return notRevealedUri;
1449                 }
1450 
1451                 string memory currentBaseURI = _baseURI();
1452                 return bytes(currentBaseURI).length > 0
1453                     ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1454                     : "";
1455             }
1456 
1457         //only owner funtions
1458             function reveal() public onlyOwner {
1459                 revealed = true;
1460             }
1461             
1462             function setNftPerAddressLimit(uint256 _limit) public onlyOwner {
1463                 nftPerAddressLimit = _limit;
1464             }
1465 
1466             function setCost(uint256 _newCost) public onlyOwner {
1467                 cost = _newCost;
1468             }
1469 
1470             function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
1471                 maxMintAmount = _newmaxMintAmount;
1472             }
1473             
1474             function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1475                 notRevealedUri = _notRevealedURI;
1476             }
1477 
1478             function setBaseURI(string memory _newBaseURI) public onlyOwner {
1479                 baseURI = _newBaseURI;
1480             }
1481 
1482             function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1483                 baseExtension = _newBaseExtension;
1484             }
1485 
1486             function pause(bool _state) public onlyOwner {
1487                 paused = _state;
1488             }
1489 
1490 
1491             function seReservedNFT(uint256 _newreserve) public onlyOwner {
1492                     ReservedNFT = _newreserve;
1493              }
1494             
1495 
1496             function withdraw() public payable onlyOwner {
1497                 (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1498                 require(os);
1499             }
1500             
1501             // to Airdrop tokens, Only owner Function
1502             function AirDrop(address _to, uint256 _mintAmount) public onlyOwner {
1503                 require(!paused);
1504                 require(_mintAmount > 0);
1505                 _safeMint(_to, _mintAmount);
1506                 }
1507             }