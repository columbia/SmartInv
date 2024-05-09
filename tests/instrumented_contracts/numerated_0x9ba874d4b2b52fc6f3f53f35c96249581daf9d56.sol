1 // SPDX-License-Identifier: GPL-3.0
2 
3 pragma solidity ^0.8.0;
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
25 pragma solidity ^0.8.0;
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
93 pragma solidity ^0.8.0;
94 
95 /**
96  * @dev Contract module which allows children to implement an emergency stop
97  * mechanism that can be triggered by an authorized account.
98  *
99  * This module is used through inheritance. It will make available the
100  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
101  * the functions of your contract. Note that they will not be pausable by
102  * simply including this module, only once the modifiers are put in place.
103  */
104 abstract contract Pausable is Context {
105     /**
106      * @dev Emitted when the pause is triggered by `account`.
107      */
108     event Paused(address account);
109 
110     /**
111      * @dev Emitted when the pause is lifted by `account`.
112      */
113     event Unpaused(address account);
114 
115     bool private _paused;
116 
117     /**
118      * @dev Initializes the contract in unpaused state.
119      */
120     constructor() {
121         _paused = false;
122     }
123 
124     /**
125      * @dev Returns true if the contract is paused, and false otherwise.
126      */
127     function paused() public view virtual returns (bool) {
128         return _paused;
129     }
130 
131     /**
132      * @dev Modifier to make a function callable only when the contract is not paused.
133      *
134      * Requirements:
135      *
136      * - The contract must not be paused.
137      */
138     modifier whenNotPaused() {
139         require(!paused(), "Pausable: paused");
140         _;
141     }
142 
143     /**
144      * @dev Modifier to make a function callable only when the contract is paused.
145      *
146      * Requirements:
147      *
148      * - The contract must be paused.
149      */
150     modifier whenPaused() {
151         require(paused(), "Pausable: not paused");
152         _;
153     }
154 
155     /**
156      * @dev Triggers stopped state.
157      *
158      * Requirements:
159      *
160      * - The contract must not be paused.
161      */
162     function _pause() internal virtual whenNotPaused {
163         _paused = true;
164         emit Paused(_msgSender());
165     }
166 
167     /**
168      * @dev Returns to normal state.
169      *
170      * Requirements:
171      *
172      * - The contract must be paused.
173      */
174     function _unpause() internal virtual whenPaused {
175         _paused = false;
176         emit Unpaused(_msgSender());
177     }
178 }
179 
180 pragma solidity ^0.8.0;
181 
182 /**
183  * @dev String operations.
184  */
185 library Strings {
186     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
187 
188     /**
189      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
190      */
191     function toString(uint256 value) internal pure returns (string memory) {
192         // Inspired by OraclizeAPI's implementation - MIT licence
193         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
194 
195         if (value == 0) {
196             return "0";
197         }
198         uint256 temp = value;
199         uint256 digits;
200         while (temp != 0) {
201             digits++;
202             temp /= 10;
203         }
204         bytes memory buffer = new bytes(digits);
205         while (value != 0) {
206             digits -= 1;
207             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
208             value /= 10;
209         }
210         return string(buffer);
211     }
212 
213     /**
214      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
215      */
216     function toHexString(uint256 value) internal pure returns (string memory) {
217         if (value == 0) {
218             return "0x00";
219         }
220         uint256 temp = value;
221         uint256 length = 0;
222         while (temp != 0) {
223             length++;
224             temp >>= 8;
225         }
226         return toHexString(value, length);
227     }
228 
229     /**
230      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
231      */
232     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
233         bytes memory buffer = new bytes(2 * length + 2);
234         buffer[0] = "0";
235         buffer[1] = "x";
236         for (uint256 i = 2 * length + 1; i > 1; --i) {
237             buffer[i] = _HEX_SYMBOLS[value & 0xf];
238             value >>= 4;
239         }
240         require(value == 0, "Strings: hex length insufficient");
241         return string(buffer);
242     }
243 }
244 
245 pragma solidity ^0.8.0;
246 
247 /**
248  * @dev Interface of the ERC165 standard, as defined in the
249  * https://eips.ethereum.org/EIPS/eip-165[EIP].
250  *
251  * Implementers can declare support of contract interfaces, which can then be
252  * queried by others ({ERC165Checker}).
253  *
254  * For an implementation, see {ERC165}.
255  */
256 interface IERC165 {
257     /**
258      * @dev Returns true if this contract implements the interface defined by
259      * `interfaceId`. See the corresponding
260      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
261      * to learn more about how these ids are created.
262      *
263      * This function call must use less than 30 000 gas.
264      */
265     function supportsInterface(bytes4 interfaceId) external view returns (bool);
266 }
267 
268 pragma solidity ^0.8.0;
269 
270 /**
271  * @dev Required interface of an ERC721 compliant contract.
272  */
273 interface IERC721 is IERC165 {
274     /**
275      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
276      */
277     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
278 
279     /**
280      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
281      */
282     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
283 
284     /**
285      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
286      */
287     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
288 
289     /**
290      * @dev Returns the number of tokens in ``owner``'s account.
291      */
292     function balanceOf(address owner) external view returns (uint256 balance);
293 
294     /**
295      * @dev Returns the owner of the `tokenId` token.
296      *
297      * Requirements:
298      *
299      * - `tokenId` must exist.
300      */
301     function ownerOf(uint256 tokenId) external view returns (address owner);
302 
303     /**
304      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
305      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
306      *
307      * Requirements:
308      *
309      * - `from` cannot be the zero address.
310      * - `to` cannot be the zero address.
311      * - `tokenId` token must exist and be owned by `from`.
312      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
313      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
314      *
315      * Emits a {Transfer} event.
316      */
317     function safeTransferFrom(
318         address from,
319         address to,
320         uint256 tokenId
321     ) external;
322 
323     /**
324      * @dev Transfers `tokenId` token from `from` to `to`.
325      *
326      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
327      *
328      * Requirements:
329      *
330      * - `from` cannot be the zero address.
331      * - `to` cannot be the zero address.
332      * - `tokenId` token must be owned by `from`.
333      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
334      *
335      * Emits a {Transfer} event.
336      */
337     function transferFrom(
338         address from,
339         address to,
340         uint256 tokenId
341     ) external;
342 
343     /**
344      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
345      * The approval is cleared when the token is transferred.
346      *
347      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
348      *
349      * Requirements:
350      *
351      * - The caller must own the token or be an approved operator.
352      * - `tokenId` must exist.
353      *
354      * Emits an {Approval} event.
355      */
356     function approve(address to, uint256 tokenId) external;
357 
358     /**
359      * @dev Returns the account approved for `tokenId` token.
360      *
361      * Requirements:
362      *
363      * - `tokenId` must exist.
364      */
365     function getApproved(uint256 tokenId) external view returns (address operator);
366 
367     /**
368      * @dev Approve or remove `operator` as an operator for the caller.
369      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
370      *
371      * Requirements:
372      *
373      * - The `operator` cannot be the caller.
374      *
375      * Emits an {ApprovalForAll} event.
376      */
377     function setApprovalForAll(address operator, bool _approved) external;
378 
379     /**
380      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
381      *
382      * See {setApprovalForAll}
383      */
384     function isApprovedForAll(address owner, address operator) external view returns (bool);
385 
386     /**
387      * @dev Safely transfers `tokenId` token from `from` to `to`.
388      *
389      * Requirements:
390      *
391      * - `from` cannot be the zero address.
392      * - `to` cannot be the zero address.
393      * - `tokenId` token must exist and be owned by `from`.
394      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
395      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
396      *
397      * Emits a {Transfer} event.
398      */
399     function safeTransferFrom(
400         address from,
401         address to,
402         uint256 tokenId,
403         bytes calldata data
404     ) external;
405 }
406 
407 pragma solidity ^0.8.0;
408 
409 
410 /**
411  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
412  * @dev See https://eips.ethereum.org/EIPS/eip-721
413  */
414 interface IERC721Enumerable is IERC721 {
415     /**
416      * @dev Returns the total amount of tokens stored by the contract.
417      */
418     function totalSupply() external view returns (uint256);
419 
420     /**
421      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
422      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
423      */
424     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
425 
426     /**
427      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
428      * Use along with {totalSupply} to enumerate all tokens.
429      */
430     function tokenByIndex(uint256 index) external view returns (uint256);
431 }
432 
433 pragma solidity ^0.8.0;
434 
435 /**
436  * @title ERC721 token receiver interface
437  * @dev Interface for any contract that wants to support safeTransfers
438  * from ERC721 asset contracts.
439  */
440 interface IERC721Receiver {
441     /**
442      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
443      * by `operator` from `from`, this function is called.
444      *
445      * It must return its Solidity selector to confirm the token transfer.
446      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
447      *
448      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
449      */
450     function onERC721Received(
451         address operator,
452         address from,
453         uint256 tokenId,
454         bytes calldata data
455     ) external returns (bytes4);
456 }
457 
458 pragma solidity ^0.8.0;
459 
460 /**
461  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
462  * @dev See https://eips.ethereum.org/EIPS/eip-721
463  */
464 interface IERC721Metadata is IERC721 {
465     /**
466      * @dev Returns the token collection name.
467      */
468     function name() external view returns (string memory);
469 
470     /**
471      * @dev Returns the token collection symbol.
472      */
473     function symbol() external view returns (string memory);
474 
475     /**
476      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
477      */
478     function tokenURI(uint256 tokenId) external view returns (string memory);
479 }
480 
481 
482 pragma solidity ^0.8.0;
483 
484 /**
485  * @dev Collection of functions related to the address type
486  */
487 library Address {
488     /**
489      * @dev Returns true if `account` is a contract.
490      *
491      * [IMPORTANT]
492      * ====
493      * It is unsafe to assume that an address for which this function returns
494      * false is an externally-owned account (EOA) and not a contract.
495      *
496      * Among others, `isContract` will return false for the following
497      * types of addresses:
498      *
499      *  - an externally-owned account
500      *  - a contract in construction
501      *  - an address where a contract will be created
502      *  - an address where a contract lived, but was destroyed
503      * ====
504      */
505     function isContract(address account) internal view returns (bool) {
506         // This method relies on extcodesize, which returns 0 for contracts in
507         // construction, since the code is only stored at the end of the
508         // constructor execution.
509 
510         uint256 size;
511         assembly {
512             size := extcodesize(account)
513         }
514         return size > 0;
515     }
516 
517     /**
518      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
519      * `recipient`, forwarding all available gas and reverting on errors.
520      *
521      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
522      * of certain opcodes, possibly making contracts go over the 2300 gas limit
523      * imposed by `transfer`, making them unable to receive funds via
524      * `transfer`. {sendValue} removes this limitation.
525      *
526      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
527      *
528      * IMPORTANT: because control is transferred to `recipient`, care must be
529      * taken to not create reentrancy vulnerabilities. Consider using
530      * {ReentrancyGuard} or the
531      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
532      */
533     function sendValue(address payable recipient, uint256 amount) internal {
534         require(address(this).balance >= amount, "Address: insufficient balance");
535 
536         (bool success, ) = recipient.call{value: amount}("");
537         require(success, "Address: unable to send value, recipient may have reverted");
538     }
539 
540     /**
541      * @dev Performs a Solidity function call using a low level `call`. A
542      * plain `call` is an unsafe replacement for a function call: use this
543      * function instead.
544      *
545      * If `target` reverts with a revert reason, it is bubbled up by this
546      * function (like regular Solidity function calls).
547      *
548      * Returns the raw returned data. To convert to the expected return value,
549      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
550      *
551      * Requirements:
552      *
553      * - `target` must be a contract.
554      * - calling `target` with `data` must not revert.
555      *
556      * _Available since v3.1._
557      */
558     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
559         return functionCall(target, data, "Address: low-level call failed");
560     }
561 
562     /**
563      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
564      * `errorMessage` as a fallback revert reason when `target` reverts.
565      *
566      * _Available since v3.1._
567      */
568     function functionCall(
569         address target,
570         bytes memory data,
571         string memory errorMessage
572     ) internal returns (bytes memory) {
573         return functionCallWithValue(target, data, 0, errorMessage);
574     }
575 
576     /**
577      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
578      * but also transferring `value` wei to `target`.
579      *
580      * Requirements:
581      *
582      * - the calling contract must have an ETH balance of at least `value`.
583      * - the called Solidity function must be `payable`.
584      *
585      * _Available since v3.1._
586      */
587     function functionCallWithValue(
588         address target,
589         bytes memory data,
590         uint256 value
591     ) internal returns (bytes memory) {
592         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
593     }
594 
595     /**
596      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
597      * with `errorMessage` as a fallback revert reason when `target` reverts.
598      *
599      * _Available since v3.1._
600      */
601     function functionCallWithValue(
602         address target,
603         bytes memory data,
604         uint256 value,
605         string memory errorMessage
606     ) internal returns (bytes memory) {
607         require(address(this).balance >= value, "Address: insufficient balance for call");
608         require(isContract(target), "Address: call to non-contract");
609 
610         (bool success, bytes memory returndata) = target.call{value: value}(data);
611         return verifyCallResult(success, returndata, errorMessage);
612     }
613 
614     /**
615      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
616      * but performing a static call.
617      *
618      * _Available since v3.3._
619      */
620     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
621         return functionStaticCall(target, data, "Address: low-level static call failed");
622     }
623 
624     /**
625      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
626      * but performing a static call.
627      *
628      * _Available since v3.3._
629      */
630     function functionStaticCall(
631         address target,
632         bytes memory data,
633         string memory errorMessage
634     ) internal view returns (bytes memory) {
635         require(isContract(target), "Address: static call to non-contract");
636 
637         (bool success, bytes memory returndata) = target.staticcall(data);
638         return verifyCallResult(success, returndata, errorMessage);
639     }
640 
641     /**
642      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
643      * but performing a delegate call.
644      *
645      * _Available since v3.4._
646      */
647     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
648         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
649     }
650 
651     /**
652      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
653      * but performing a delegate call.
654      *
655      * _Available since v3.4._
656      */
657     function functionDelegateCall(
658         address target,
659         bytes memory data,
660         string memory errorMessage
661     ) internal returns (bytes memory) {
662         require(isContract(target), "Address: delegate call to non-contract");
663 
664         (bool success, bytes memory returndata) = target.delegatecall(data);
665         return verifyCallResult(success, returndata, errorMessage);
666     }
667 
668     /**
669      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
670      * revert reason using the provided one.
671      *
672      * _Available since v4.3._
673      */
674     function verifyCallResult(
675         bool success,
676         bytes memory returndata,
677         string memory errorMessage
678     ) internal pure returns (bytes memory) {
679         if (success) {
680             return returndata;
681         } else {
682             // Look for revert reason and bubble it up if present
683             if (returndata.length > 0) {
684                 // The easiest way to bubble the revert reason is using memory via assembly
685 
686                 assembly {
687                     let returndata_size := mload(returndata)
688                     revert(add(32, returndata), returndata_size)
689                 }
690             } else {
691                 revert(errorMessage);
692             }
693         }
694     }
695 }
696 
697 pragma solidity ^0.8.0;
698 
699 /**
700  * @dev Implementation of the {IERC165} interface.
701  *
702  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
703  * for the additional interface id that will be supported. For example:
704  *
705  * ```solidity
706  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
707  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
708  * }
709  * ```
710  *
711  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
712  */
713 abstract contract ERC165 is IERC165 {
714     /**
715      * @dev See {IERC165-supportsInterface}.
716      */
717     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
718         return interfaceId == type(IERC165).interfaceId;
719     }
720 }
721 pragma solidity ^0.8.10;
722 
723 abstract contract ERC721P is Context, ERC165, IERC721, IERC721Metadata {
724     using Address for address;
725     string private _name;
726     string private _symbol;
727     address[] internal _owners;
728     mapping(uint256 => address) private _tokenApprovals;
729     mapping(address => mapping(address => bool)) private _operatorApprovals;
730     constructor(string memory name_, string memory symbol_) {
731         _name = name_;
732         _symbol = symbol_;
733     }
734     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
735         return
736         interfaceId == type(IERC721).interfaceId ||
737         interfaceId == type(IERC721Metadata).interfaceId ||
738         super.supportsInterface(interfaceId);
739     }
740     function balanceOf(address owner) public view virtual override returns (uint256) {
741         require(owner != address(0), "ERC721: balance query for the zero address");
742         uint count = 0;
743         uint length = _owners.length;
744         for( uint i = 0; i < length; ++i ){
745             if( owner == _owners[i] ){
746                 ++count;
747             }
748         }
749         delete length;
750         return count;
751     }
752     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
753         address owner = _owners[tokenId];
754         require(owner != address(0), "ERC721: owner query for nonexistent token");
755         return owner;
756     }
757     function name() public view virtual override returns (string memory) {
758         return _name;
759     }
760     function symbol() public view virtual override returns (string memory) {
761         return _symbol;
762     }
763     function approve(address to, uint256 tokenId) public virtual override {
764         address owner = ERC721P.ownerOf(tokenId);
765         require(to != owner, "ERC721: approval to current owner");
766 
767         require(
768             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
769             "ERC721: approve caller is not owner nor approved for all"
770         );
771 
772         _approve(to, tokenId);
773     }
774     function getApproved(uint256 tokenId) public view virtual override returns (address) {
775         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
776 
777         return _tokenApprovals[tokenId];
778     }
779     function setApprovalForAll(address operator, bool approved) public virtual override {
780         require(operator != _msgSender(), "ERC721: approve to caller");
781 
782         _operatorApprovals[_msgSender()][operator] = approved;
783         emit ApprovalForAll(_msgSender(), operator, approved);
784     }
785     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
786         return _operatorApprovals[owner][operator];
787     }
788     function transferFrom(
789         address from,
790         address to,
791         uint256 tokenId
792     ) public virtual override {
793         //solhint-disable-next-line max-line-length
794         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
795 
796         _transfer(from, to, tokenId);
797     }
798     function safeTransferFrom(
799         address from,
800         address to,
801         uint256 tokenId
802     ) public virtual override {
803         safeTransferFrom(from, to, tokenId, "");
804     }
805     function safeTransferFrom(
806         address from,
807         address to,
808         uint256 tokenId,
809         bytes memory _data
810     ) public virtual override {
811         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
812         _safeTransfer(from, to, tokenId, _data);
813     }
814     function _safeTransfer(
815         address from,
816         address to,
817         uint256 tokenId,
818         bytes memory _data
819     ) internal virtual {
820         _transfer(from, to, tokenId);
821         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
822     }
823     function _exists(uint256 tokenId) internal view virtual returns (bool) {
824         return tokenId < _owners.length && _owners[tokenId] != address(0);
825     }
826     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
827         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
828         address owner = ERC721P.ownerOf(tokenId);
829         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
830     }
831     function _safeMint(address to, uint256 tokenId) internal virtual {
832         _safeMint(to, tokenId, "");
833     }
834     function _safeMint(
835         address to,
836         uint256 tokenId,
837         bytes memory _data
838     ) internal virtual {
839         _mint(to, tokenId);
840         require(
841             _checkOnERC721Received(address(0), to, tokenId, _data),
842             "ERC721: transfer to non ERC721Receiver implementer"
843         );
844     }
845     function _mint(address to, uint256 tokenId) internal virtual {
846         require(to != address(0), "ERC721: mint to the zero address");
847         require(!_exists(tokenId), "ERC721: token already minted");
848 
849         _beforeTokenTransfer(address(0), to, tokenId);
850         _owners.push(to);
851 
852         emit Transfer(address(0), to, tokenId);
853     }
854     function _burn(uint256 tokenId) internal virtual {
855         address owner = ERC721P.ownerOf(tokenId);
856 
857         _beforeTokenTransfer(owner, address(0), tokenId);
858 
859         // Clear approvals
860         _approve(address(0), tokenId);
861         _owners[tokenId] = address(0);
862 
863         emit Transfer(owner, address(0), tokenId);
864     }
865     function _transfer(
866         address from,
867         address to,
868         uint256 tokenId
869     ) internal virtual {
870         require(ERC721P.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
871         require(to != address(0), "ERC721: transfer to the zero address");
872 
873         _beforeTokenTransfer(from, to, tokenId);
874 
875         // Clear approvals from the previous owner
876         _approve(address(0), tokenId);
877         _owners[tokenId] = to;
878 
879         emit Transfer(from, to, tokenId);
880     }
881     function _approve(address to, uint256 tokenId) internal virtual {
882         _tokenApprovals[tokenId] = to;
883         emit Approval(ERC721P.ownerOf(tokenId), to, tokenId);
884     }
885     function _checkOnERC721Received(
886         address from,
887         address to,
888         uint256 tokenId,
889         bytes memory _data
890     ) private returns (bool) {
891         if (to.isContract()) {
892             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
893                 return retval == IERC721Receiver.onERC721Received.selector;
894             } catch (bytes memory reason) {
895                 if (reason.length == 0) {
896                     revert("ERC721: transfer to non ERC721Receiver implementer");
897                 } else {
898                     assembly {
899                         revert(add(32, reason), mload(reason))
900                     }
901                 }
902             }
903         } else {
904             return true;
905         }
906     }
907     function _beforeTokenTransfer(
908         address from,
909         address to,
910         uint256 tokenId
911     ) internal virtual {}
912 }
913 
914 pragma solidity ^0.8.10;
915 
916 abstract contract ERC721Enum is ERC721P, IERC721Enumerable {
917     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721P) returns (bool) {
918         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
919     }
920     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256 tokenId) {
921         require(index < ERC721P.balanceOf(owner), "ERC721Enum: owner ioob");
922         uint count;
923         for( uint i; i < _owners.length; ++i ){
924             if( owner == _owners[i] ){
925                 if( count == index )
926                     return i;
927                 else
928                     ++count;
929             }
930         }
931         require(false, "ERC721Enum: owner ioob");
932     }
933     function tokensOfOwner(address owner) public view returns (uint256[] memory) {
934         require(0 < ERC721P.balanceOf(owner), "ERC721Enum: owner ioob");
935         uint256 tokenCount = balanceOf(owner);
936         uint256[] memory tokenIds = new uint256[](tokenCount);
937         for (uint256 i = 0; i < tokenCount; i++) {
938             tokenIds[i] = tokenOfOwnerByIndex(owner, i);
939         }
940         return tokenIds;
941     }
942     function totalSupply() public view virtual override returns (uint256) {
943         return _owners.length;
944     }
945     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
946         require(index < ERC721Enum.totalSupply(), "ERC721Enum: global ioob");
947         return index;
948     }
949 }
950 
951 pragma solidity ^0.8.10;
952 
953 interface IProducer {
954     function ownerOf(uint256 _tokenId) external view returns(address);
955 }
956 
957 interface IERC20 {
958     function totalSupply() external view returns (uint256);
959     function balanceOf(address account) external view returns (uint256);
960     function allowance(address owner, address spender) external view returns (uint256);
961     function burn(address add, uint256 amount) external;
962 
963     function transfer(address recipient, uint256 amount) external returns (bool);
964     function approve(address spender, uint256 amount) external returns (bool);
965     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
966 }
967 
968 contract AngryBoarcats is ERC721Enum, Ownable, Pausable {
969     using Strings for uint256;
970 
971     mapping(uint256 => bool) _claimedBoars;
972     mapping(uint256 => bool) _claimedMeerkats;
973 
974     address public angryBoarsContractAddress;
975     address public angryMeerkatsContractAddress;
976     address public oinkTokenContractAddress;
977 
978     string private baseURI;
979     uint256 private ETHER = 10 ** 18;
980 
981     event ChangeName(uint256 _tokenId, string text);
982     event ChangeDescription(uint256 _tokenId, string text);
983 
984     uint256 public changeNamePrice = 100 ether;
985     uint256 public changeDescriptionPrice = 200 ether;
986     uint256 public symbiosisPrice = 450 ether;
987 
988     IProducer angryBoarsContractCaller;
989     IProducer angryMeerkatsContractCaller;
990     IERC20 oinkCaller;
991 
992     constructor(
993         string memory _name,
994         string memory _symbol,
995         string memory _initBaseURI,
996         address _angryBoarsContractAddress,
997         address _angryMeerkatsContractAddress,
998         address _oinkTokenContractAddress
999     ) ERC721P(_name, _symbol) {
1000         _pause();
1001         setBaseURI(_initBaseURI);
1002 
1003         angryBoarsContractAddress = _angryBoarsContractAddress;
1004         angryBoarsContractCaller = IProducer(_angryBoarsContractAddress);
1005 
1006         angryMeerkatsContractAddress = _angryMeerkatsContractAddress;
1007         angryMeerkatsContractCaller = IProducer(_angryMeerkatsContractAddress);
1008 
1009         oinkTokenContractAddress = _oinkTokenContractAddress;
1010         oinkCaller = IERC20(_oinkTokenContractAddress);
1011     }
1012 
1013     function isBoarClaimed (uint256 boar) public view returns (bool) {
1014         return _claimedBoars[boar];
1015     }
1016 
1017     function isMeerkatClaimed (uint256 boar) public view returns (bool) {
1018         return _claimedMeerkats[boar];
1019     }
1020 
1021     function updateChangeNamePrice(uint32 _value) external onlyOwner {
1022         changeNamePrice = _value * ETHER;
1023     }
1024 
1025     function updateChangeDescriptionPrice(uint32 _value) external onlyOwner {
1026         changeDescriptionPrice = _value * ETHER;
1027     }
1028 
1029     function updateSymbiosisPrice(uint32 _value) external onlyOwner {
1030         symbiosisPrice = _value * ETHER;
1031     }
1032 
1033     function setOinkAddress(address _address) external onlyOwner {
1034         oinkTokenContractAddress = _address;
1035         oinkCaller = IERC20(_address);
1036     }
1037 
1038     function setAngryBoarsAddress(address _address) external onlyOwner {
1039         angryBoarsContractAddress = _address;
1040         angryBoarsContractCaller = IProducer(_address);
1041     }
1042 
1043     function setMeerkatsAddress(address _address) external onlyOwner {
1044 
1045         angryMeerkatsContractAddress = _address;
1046         angryMeerkatsContractCaller = IProducer(_address);
1047     }
1048 
1049     function claimByIds(uint256[] memory angryBoarsIds, uint256[] memory angryMeerkatsIds, uint256 amount) external payable whenNotPaused {
1050         require(angryBoarsIds.length % 2 == 0 && angryMeerkatsIds.length % 2 == 0 && angryBoarsIds.length == angryMeerkatsIds.length, "Not enought boars and meerkats");
1051         require(amount == (symbiosisPrice * angryBoarsIds.length / 2), "Not enough $OINK");
1052 
1053         for (uint256  i = 0; i < angryBoarsIds.length; i++) {
1054             require(!isBoarClaimed(angryBoarsIds[i]), "The token has been already claimed");
1055             address angryBoarOwner = angryBoarsContractCaller.ownerOf(angryBoarsIds[i]);
1056             require(angryBoarOwner == msg.sender, "You do not own the token with the provided id");
1057         }
1058 
1059         for (uint256  i = 0; i < angryMeerkatsIds.length; i++) {
1060             require(!isMeerkatClaimed(angryMeerkatsIds[i]), "The token has been already claimed");
1061             address angryMeerkatOwner = angryMeerkatsContractCaller.ownerOf(angryMeerkatsIds[i]);
1062             require(angryMeerkatOwner == msg.sender, "You do not own the token with the provided id");
1063         }
1064 
1065         for (uint256  i = 0; i < angryBoarsIds.length; i++) {
1066             _claimedBoars[angryBoarsIds[i]] = true;
1067             _claimedMeerkats[angryMeerkatsIds[i]] = true;
1068         }
1069 
1070         oinkCaller.burn(msg.sender, amount);
1071 
1072         for (uint256  i = 0; i < (angryBoarsIds.length / 2); i++) {
1073             _safeMint(msg.sender, totalSupply());
1074         }
1075     }
1076 
1077     function claimByIdsOwner(uint256[] memory angryBoarsIds, uint256[] memory angryMeerkatsIds, uint256 amount) external payable onlyOwner {
1078         require(angryBoarsIds.length % 2 == 0 && angryMeerkatsIds.length % 2 == 0 && angryBoarsIds.length == angryMeerkatsIds.length, "Not enought boars and meerkats");
1079         require(amount == (symbiosisPrice * angryBoarsIds.length / 2), "Not enough $OINK");
1080 
1081         for (uint256  i = 0; i < angryBoarsIds.length; i++) {
1082             address angryBoarOwner = angryBoarsContractCaller.ownerOf(angryBoarsIds[i]);
1083             require(angryBoarOwner == msg.sender, "You do not own the token with the provided id");
1084             require(!isBoarClaimed(angryBoarsIds[i]), "The token has been already claimed");
1085         }
1086 
1087         for (uint256  i = 0; i < angryMeerkatsIds.length; i++) {
1088             address angryMeerkatOwner = angryMeerkatsContractCaller.ownerOf(angryMeerkatsIds[i]);
1089             require(angryMeerkatOwner == msg.sender, "You do not own the token with the provided id");
1090             require(!isMeerkatClaimed(angryMeerkatsIds[i]), "The token has been already claimed");
1091         }
1092 
1093         for (uint256  i = 0; i < angryBoarsIds.length; i++) {
1094             _claimedBoars[angryBoarsIds[i]] = true;
1095             _claimedMeerkats[angryMeerkatsIds[i]] = true;
1096         }
1097 
1098         oinkCaller.burn(msg.sender, amount);
1099 
1100         for (uint256  i = 0; i < (angryBoarsIds.length / 2); i++) {
1101             _safeMint(msg.sender, totalSupply());
1102         }
1103     }
1104 
1105     function changeName(uint256 _tokenId, string calldata _name, uint256 _amount) public payable whenNotPaused {
1106         address owner = ownerOf(_tokenId);
1107         require(owner == msg.sender, "You do not own the token with the provided id");
1108         require(_amount == changeNamePrice, "Not enough $OINK");
1109         oinkCaller.burn(msg.sender, _amount);
1110         emit ChangeName(_tokenId, _name);
1111     }
1112 
1113     function changeDescription(uint256 _tokenId, string calldata _description, uint256 _amount) public payable whenNotPaused {
1114         address owner = ownerOf(_tokenId);
1115         require(owner == msg.sender, "You do not own the token with the provided id");
1116         require(_amount == changeDescriptionPrice, "Not enough $OINK");
1117         oinkCaller.burn(msg.sender, _amount);
1118         emit ChangeDescription(_tokenId, _description);
1119     }
1120 
1121     // internal
1122     function _baseURI() internal view virtual returns (string memory) {
1123         return baseURI;
1124     }
1125 
1126     function tokenURI(uint256 _tokenId) external view virtual override returns (string memory) {
1127         require(_exists(_tokenId), "ERC721Metadata: Nonexistent token");
1128         string memory currentBaseURI = _baseURI();
1129         return bytes(currentBaseURI).length > 0	? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), ".json")) : "";
1130     }
1131 
1132     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1133         baseURI = _newBaseURI;
1134     }
1135 
1136     function pause() external onlyOwner {
1137         _pause();
1138     }
1139 
1140     function unpause() external onlyOwner {
1141         _unpause();
1142     }
1143 }