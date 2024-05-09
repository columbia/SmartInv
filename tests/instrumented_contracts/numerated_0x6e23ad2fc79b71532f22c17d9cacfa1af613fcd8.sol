1 // SPDX-License-Identifier: MIT
2 // OpenZeppelin Contracts v4.4.0 (token/ERC721/ERC721.sol)
3 // MetaPiggyBanks.io
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev Interface of the ERC165 standard, as defined in the
9  * https://eips.ethereum.org/EIPS/eip-165[EIP].
10  *
11  * Implementers can declare support of contract interfaces, which can then be
12  * queried by others ({ERC165Checker}).
13  *
14  * For an implementation, see {ERC165}.
15  */
16 interface IERC165 {
17   /**
18    * @dev Returns true if this contract implements the interface defined by
19    * `interfaceId`. See the corresponding
20    * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
21    * to learn more about how these ids are created.
22    *
23    * This function call must use less than 30 000 gas.
24    */
25   function supportsInterface(bytes4 interfaceId) external view returns (bool);
26 }
27 
28 /**
29  * @dev Implementation of the {IERC165} interface.
30  *
31  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
32  * for the additional interface id that will be supported. For example:
33  *
34  * ```solidity
35  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
36  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
37  * }
38  * ```
39  *
40  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
41  */
42 abstract contract ERC165 is IERC165 {
43   /**
44    * @dev See {IERC165-supportsInterface}.
45    */
46   function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
47     return interfaceId == type(IERC165).interfaceId;
48   }
49 }
50 
51 /**
52  * @dev Required interface of an ERC721 compliant contract.
53  */
54 interface IERC721 is IERC165 {
55   /**
56    * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
57    */
58   event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
59 
60   /**
61    * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
62    */
63   event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
64 
65   /**
66    * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
67    */
68   event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
69 
70   /**
71    * @dev Returns the number of tokens in ``owner``'s account.
72    */
73   function balanceOf(address owner) external view returns (uint256 balance);
74 
75   /**
76    * @dev Returns the owner of the `tokenId` token.
77    *
78    * Requirements:
79    *
80    * - `tokenId` must exist.
81    */
82   function ownerOf(uint256 tokenId) external view returns (address owner);
83 
84   /**
85    * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
86    * are aware of the ERC721 protocol to prevent tokens from being forever locked.
87    *
88    * Requirements:
89    *
90    * - `from` cannot be the zero address.
91    * - `to` cannot be the zero address.
92    * - `tokenId` token must exist and be owned by `from`.
93    * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
94    * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
95    *
96    * Emits a {Transfer} event.
97    */
98   function safeTransferFrom(
99     address from,
100     address to,
101     uint256 tokenId
102   ) external;
103 
104   /**
105    * @dev Transfers `tokenId` token from `from` to `to`.
106    *
107    * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
108    *
109    * Requirements:
110    *
111    * - `from` cannot be the zero address.
112    * - `to` cannot be the zero address.
113    * - `tokenId` token must be owned by `from`.
114    * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
115    *
116    * Emits a {Transfer} event.
117    */
118   function transferFrom(
119     address from,
120     address to,
121     uint256 tokenId
122   ) external;
123 
124   /**
125    * @dev Gives permission to `to` to transfer `tokenId` token to another account.
126    * The approval is cleared when the token is transferred.
127    *
128    * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
129    *
130    * Requirements:
131    *
132    * - The caller must own the token or be an approved operator.
133    * - `tokenId` must exist.
134    *
135    * Emits an {Approval} event.
136    */
137   function approve(address to, uint256 tokenId) external;
138 
139   /**
140    * @dev Returns the account approved for `tokenId` token.
141    *
142    * Requirements:
143    *
144    * - `tokenId` must exist.
145    */
146   function getApproved(uint256 tokenId) external view returns (address operator);
147 
148   /**
149    * @dev Approve or remove `operator` as an operator for the caller.
150    * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
151    *
152    * Requirements:
153    *
154    * - The `operator` cannot be the caller.
155    *
156    * Emits an {ApprovalForAll} event.
157    */
158   function setApprovalForAll(address operator, bool _approved) external;
159 
160   /**
161    * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
162    *
163    * See {setApprovalForAll}
164    */
165   function isApprovedForAll(address owner, address operator) external view returns (bool);
166 
167   /**
168    * @dev Safely transfers `tokenId` token from `from` to `to`.
169    *
170    * Requirements:
171    *
172    * - `from` cannot be the zero address.
173    * - `to` cannot be the zero address.
174    * - `tokenId` token must exist and be owned by `from`.
175    * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
176    * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
177    *
178    * Emits a {Transfer} event.
179    */
180   function safeTransferFrom(
181     address from,
182     address to,
183     uint256 tokenId,
184     bytes calldata data
185   ) external;
186 }
187 
188 /**
189  * @title ERC721 token receiver interface
190  * @dev Interface for any contract that wants to support safeTransfers
191  * from ERC721 asset contracts.
192  */
193 interface IERC721Receiver {
194   /**
195    * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
196    * by `operator` from `from`, this function is called.
197    *
198    * It must return its Solidity selector to confirm the token transfer.
199    * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
200    *
201    * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
202    */
203   function onERC721Received(
204     address operator,
205     address from,
206     uint256 tokenId,
207     bytes calldata data
208   ) external returns (bytes4);
209 }
210 
211 /**
212  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
213  * @dev See https://eips.ethereum.org/EIPS/eip-721
214  */
215 interface IERC721Metadata is IERC721 {
216   /**
217    * @dev Returns the token collection name.
218    */
219   function name() external view returns (string memory);
220 
221   /**
222    * @dev Returns the token collection symbol.
223    */
224   function symbol() external view returns (string memory);
225 
226   /**
227    * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
228    */
229   function tokenURI(uint256 tokenId) external view returns (string memory);
230 }
231 
232 /**
233  * @dev Collection of functions related to the address type
234  */
235 library Address {
236   /**
237    * @dev Returns true if `account` is a contract.
238    *
239    * [IMPORTANT]
240    * ====
241    * It is unsafe to assume that an address for which this function returns
242    * false is an externally-owned account (EOA) and not a contract.
243    *
244    * Among others, `isContract` will return false for the following
245    * types of addresses:
246    *
247    *  - an externally-owned account
248    *  - a contract in construction
249    *  - an address where a contract will be created
250    *  - an address where a contract lived, but was destroyed
251    * ====
252    */
253   function isContract(address account) internal view returns (bool) {
254     // This method relies on extcodesize, which returns 0 for contracts in
255     // construction, since the code is only stored at the end of the
256     // constructor execution.
257 
258     uint256 size;
259     assembly {
260       size := extcodesize(account)
261     }
262     return size > 0;
263   }
264 
265   /**
266    * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
267    * `recipient`, forwarding all available gas and reverting on errors.
268    *
269    * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
270    * of certain opcodes, possibly making contracts go over the 2300 gas limit
271    * imposed by `transfer`, making them unable to receive funds via
272    * `transfer`. {sendValue} removes this limitation.
273    *
274    * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
275    *
276    * IMPORTANT: because control is transferred to `recipient`, care must be
277    * taken to not create reentrancy vulnerabilities. Consider using
278    * {ReentrancyGuard} or the
279    * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
280    */
281   function sendValue(address payable recipient, uint256 amount) internal {
282     require(address(this).balance >= amount, "Address: insufficient balance");
283 
284     (bool success, ) = recipient.call{value: amount}("");
285     require(success, "Address: unable to send value, recipient may have reverted");
286   }
287 
288   /**
289    * @dev Performs a Solidity function call using a low level `call`. A
290    * plain `call` is an unsafe replacement for a function call: use this
291    * function instead.
292    *
293    * If `target` reverts with a revert reason, it is bubbled up by this
294    * function (like regular Solidity function calls).
295    *
296    * Returns the raw returned data. To convert to the expected return value,
297    * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
298    *
299    * Requirements:
300    *
301    * - `target` must be a contract.
302    * - calling `target` with `data` must not revert.
303    *
304    * _Available since v3.1._
305    */
306   function functionCall(address target, bytes memory data) internal returns (bytes memory) {
307     return functionCall(target, data, "Address: low-level call failed");
308   }
309 
310   /**
311    * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
312    * `errorMessage` as a fallback revert reason when `target` reverts.
313    *
314    * _Available since v3.1._
315    */
316   function functionCall(
317     address target,
318     bytes memory data,
319     string memory errorMessage
320   ) internal returns (bytes memory) {
321     return functionCallWithValue(target, data, 0, errorMessage);
322   }
323 
324   /**
325    * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
326    * but also transferring `value` wei to `target`.
327    *
328    * Requirements:
329    *
330    * - the calling contract must have an ETH balance of at least `value`.
331    * - the called Solidity function must be `payable`.
332    *
333    * _Available since v3.1._
334    */
335   function functionCallWithValue(
336     address target,
337     bytes memory data,
338     uint256 value
339   ) internal returns (bytes memory) {
340     return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
341   }
342 
343   /**
344    * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
345    * with `errorMessage` as a fallback revert reason when `target` reverts.
346    *
347    * _Available since v3.1._
348    */
349   function functionCallWithValue(
350     address target,
351     bytes memory data,
352     uint256 value,
353     string memory errorMessage
354   ) internal returns (bytes memory) {
355     require(address(this).balance >= value, "Address: insufficient balance for call");
356     require(isContract(target), "Address: call to non-contract");
357 
358     (bool success, bytes memory returndata) = target.call{value: value}(data);
359     return verifyCallResult(success, returndata, errorMessage);
360   }
361 
362   /**
363    * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
364    * but performing a static call.
365    *
366    * _Available since v3.3._
367    */
368   function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
369     return functionStaticCall(target, data, "Address: low-level static call failed");
370   }
371 
372   /**
373    * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
374    * but performing a static call.
375    *
376    * _Available since v3.3._
377    */
378   function functionStaticCall(
379     address target,
380     bytes memory data,
381     string memory errorMessage
382   ) internal view returns (bytes memory) {
383     require(isContract(target), "Address: static call to non-contract");
384 
385     (bool success, bytes memory returndata) = target.staticcall(data);
386     return verifyCallResult(success, returndata, errorMessage);
387   }
388 
389   /**
390    * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
391    * but performing a delegate call.
392    *
393    * _Available since v3.4._
394    */
395   function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
396     return functionDelegateCall(target, data, "Address: low-level delegate call failed");
397   }
398 
399   /**
400    * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
401    * but performing a delegate call.
402    *
403    * _Available since v3.4._
404    */
405   function functionDelegateCall(
406     address target,
407     bytes memory data,
408     string memory errorMessage
409   ) internal returns (bytes memory) {
410     require(isContract(target), "Address: delegate call to non-contract");
411 
412     (bool success, bytes memory returndata) = target.delegatecall(data);
413     return verifyCallResult(success, returndata, errorMessage);
414   }
415 
416   /**
417    * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
418    * revert reason using the provided one.
419    *
420    * _Available since v4.3._
421    */
422   function verifyCallResult(
423     bool success,
424     bytes memory returndata,
425     string memory errorMessage
426   ) internal pure returns (bytes memory) {
427     if (success) {
428       return returndata;
429     } else {
430       // Look for revert reason and bubble it up if present
431       if (returndata.length > 0) {
432         // The easiest way to bubble the revert reason is using memory via assembly
433 
434         assembly {
435           let returndata_size := mload(returndata)
436           revert(add(32, returndata), returndata_size)
437         }
438       } else {
439         revert(errorMessage);
440       }
441     }
442   }
443 }
444 
445 /**
446  * @dev Provides information about the current execution context, including the
447  * sender of the transaction and its data. While these are generally available
448  * via msg.sender and msg.data, they should not be accessed in such a direct
449  * manner, since when dealing with meta-transactions the account sending and
450  * paying for execution may not be the actual sender (as far as an application
451  * is concerned).
452  *
453  * This contract is only required for intermediate, library-like contracts.
454  */
455 abstract contract Context {
456   function _msgSender() internal view virtual returns (address) {
457     return msg.sender;
458   }
459 
460   function _msgData() internal view virtual returns (bytes calldata) {
461     return msg.data;
462   }
463 }
464 
465 /**
466  * @dev String operations.
467  */
468 library Strings {
469   bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
470 
471   /**
472    * @dev Converts a `uint256` to its ASCII `string` decimal representation.
473    */
474   function toString(uint256 value) internal pure returns (string memory) {
475     // Inspired by OraclizeAPI's implementation - MIT licence
476     // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
477 
478     if (value == 0) {
479       return "0";
480     }
481     uint256 temp = value;
482     uint256 digits;
483     while (temp != 0) {
484       digits++;
485       temp /= 10;
486     }
487     bytes memory buffer = new bytes(digits);
488     while (value != 0) {
489       digits -= 1;
490       buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
491       value /= 10;
492     }
493     return string(buffer);
494   }
495 
496   /**
497    * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
498    */
499   function toHexString(uint256 value) internal pure returns (string memory) {
500     if (value == 0) {
501       return "0x00";
502     }
503     uint256 temp = value;
504     uint256 length = 0;
505     while (temp != 0) {
506       length++;
507       temp >>= 8;
508     }
509     return toHexString(value, length);
510   }
511 
512   /**
513    * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
514    */
515   function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
516     bytes memory buffer = new bytes(2 * length + 2);
517     buffer[0] = "0";
518     buffer[1] = "x";
519     for (uint256 i = 2 * length + 1; i > 1; --i) {
520       buffer[i] = _HEX_SYMBOLS[value & 0xf];
521       value >>= 4;
522     }
523     require(value == 0, "Strings: hex length insufficient");
524     return string(buffer);
525   }
526 }
527 
528 /**
529  * @title Counters
530  * @author Matt Condon (@shrugs)
531  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
532  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
533  *
534  * Include with `using Counters for Counters.Counter;`
535  */
536 library Counters {
537   struct Counter {
538     // This variable should never be directly accessed by users of the library: interactions must be restricted to
539     // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
540     // this feature: see https://github.com/ethereum/solidity/issues/4637
541     uint256 _value; // default: 0
542   }
543 
544   function current(Counter storage counter) internal view returns (uint256) {
545     return counter._value;
546   }
547 
548   function increment(Counter storage counter) internal {
549   unchecked {
550     counter._value += 1;
551   }
552   }
553 
554   function decrement(Counter storage counter) internal {
555     uint256 value = counter._value;
556     require(value > 0, "Counter: decrement overflow");
557   unchecked {
558     counter._value = value - 1;
559   }
560   }
561 
562   function reset(Counter storage counter) internal {
563     counter._value = 0;
564   }
565 }
566 
567 /**
568  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
569  * @dev See https://eips.ethereum.org/EIPS/eip-721
570  */
571 interface IERC721Enumerable is IERC721 {
572   /**
573    * @dev Returns the total amount of tokens stored by the contract.
574    */
575   function totalSupply() external view returns (uint256);
576 
577   /**
578    * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
579    * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
580    */
581   function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
582 
583   /**
584    * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
585    * Use along with {totalSupply} to enumerate all tokens.
586    */
587   function tokenByIndex(uint256 index) external view returns (uint256);
588 }
589 
590 /**
591  * @dev Contract module which provides a basic access control mechanism, where
592  * there is an account (an owner) that can be granted exclusive access to
593  * specific functions.
594  *
595  * By default, the owner account will be the one that deploys the contract. This
596  * can later be changed with {transferOwnership}.
597  *
598  * This module is used through inheritance. It will make available the modifier
599  * `onlyOwner`, which can be applied to your functions to restrict their use to
600  * the owner.
601  */
602 abstract contract Ownable is Context {
603   address private _owner;
604 
605   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
606 
607   /**
608    * @dev Initializes the contract setting the deployer as the initial owner.
609    */
610   constructor() {
611     _transferOwnership(_msgSender());
612   }
613 
614   /**
615    * @dev Returns the address of the current owner.
616    */
617   function owner() public view virtual returns (address) {
618     return _owner;
619   }
620 
621   /**
622    * @dev Throws if called by any account other than the owner.
623    */
624   modifier onlyOwner() {
625     require(owner() == _msgSender(), "Ownable: caller is not the owner");
626     _;
627   }
628 
629   /**
630    * @dev Leaves the contract without owner. It will not be possible to call
631    * `onlyOwner` functions anymore. Can only be called by the current owner.
632    *
633    * NOTE: Renouncing ownership will leave the contract without an owner,
634    * thereby removing any functionality that is only available to the owner.
635    */
636   function renounceOwnership() public virtual onlyOwner {
637     _transferOwnership(address(0));
638   }
639 
640   /**
641    * @dev Transfers ownership of the contract to a new account (`newOwner`).
642    * Can only be called by the current owner.
643    */
644   function transferOwnership(address newOwner) public virtual onlyOwner {
645     require(newOwner != address(0), "Ownable: new owner is the zero address");
646     _transferOwnership(newOwner);
647   }
648 
649   /**
650    * @dev Transfers ownership of the contract to a new account (`newOwner`).
651    * Internal function without access restriction.
652    */
653   function _transferOwnership(address newOwner) internal virtual {
654     address oldOwner = _owner;
655     _owner = newOwner;
656     emit OwnershipTransferred(oldOwner, newOwner);
657   }
658 }
659 
660 /**
661  * @dev These functions deal with verification of Merkle Trees proofs.
662  *
663  * The proofs can be generated using the JavaScript library
664  * https://github.com/miguelmota/merkletreejs[merkletreejs].
665  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
666  *
667  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
668  *
669  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
670  * hashing, or use a hash function other than keccak256 for hashing leaves.
671  * This is because the concatenation of a sorted pair of internal nodes in
672  * the merkle tree could be reinterpreted as a leaf value.
673  */
674 library MerkleProof {
675   /**
676    * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
677      * defined by `root`. For this, a `proof` must be provided, containing
678      * sibling hashes on the branch from the leaf to the root of the tree. Each
679      * pair of leaves and each pair of pre-images are assumed to be sorted.
680      */
681   function verify(
682     bytes32[] memory proof,
683     bytes32 root,
684     bytes32 leaf
685   ) internal pure returns (bool) {
686     return processProof(proof, leaf) == root;
687   }
688 
689   /**
690    * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
691      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
692      * hash matches the root of the tree. When processing the proof, the pairs
693      * of leafs & pre-images are assumed to be sorted.
694      *
695      * _Available since v4.4._
696      */
697   function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
698     bytes32 computedHash = leaf;
699     for (uint256 i = 0; i < proof.length; i++) {
700       bytes32 proofElement = proof[i];
701       if (computedHash <= proofElement) {
702         // Hash(current computed hash + current element of the proof)
703         computedHash = _efficientHash(computedHash, proofElement);
704       } else {
705         // Hash(current element of the proof + current computed hash)
706         computedHash = _efficientHash(proofElement, computedHash);
707       }
708     }
709     return computedHash;
710   }
711 
712   function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
713     assembly {
714       mstore(0x00, a)
715       mstore(0x20, b)
716       value := keccak256(0x00, 0x40)
717     }
718   }
719 }
720 
721 /**
722  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
723  * the Metadata extension, but not including the Enumerable extension, which is available separately as
724  * {ERC721Enumerable}.
725  */
726 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable, Ownable {
727   using Address for address;
728   using Strings for uint256;
729 
730   // Token name
731   string private _name;
732 
733   // Token symbol
734   string private _symbol;
735 
736   // Token base URI
737   string private _baseURI;
738 
739   // Mapping from token ID to owner address
740   mapping(uint256 => address) private _owners;
741 
742   // Mapping owner address to token count
743   mapping(address => uint256) private _balances;
744 
745   // Mapping from owner to list of owned token IDs
746   mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
747 
748   // Mapping from token ID to index of the owner tokens list
749   mapping(uint256 => uint256) private _ownedTokensIndex;
750 
751   // Array with all token ids, used for enumeration
752   uint256[] private _allTokens;
753 
754   // Mapping from token id to position in the allTokens array
755   mapping(uint256 => uint256) private _allTokensIndex;
756 
757   // Mapping from token ID to approved address
758   mapping(uint256 => address) private _tokenApprovals;
759 
760   // Mapping from owner to operator approvals
761   mapping(address => mapping(address => bool)) private _operatorApprovals;
762 
763   /**
764    * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
765    */
766   constructor(string memory name_, string memory symbol_, string memory baseURI_) {
767     _name = name_;
768     _symbol = symbol_;
769     _baseURI = baseURI_;
770   }
771 
772   /**
773    * @dev See {IERC165-supportsInterface}.
774    */
775   function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
776     return
777     interfaceId == type(IERC721).interfaceId ||
778     interfaceId == type(IERC721Metadata).interfaceId ||
779     interfaceId == type(IERC721Enumerable).interfaceId ||
780     super.supportsInterface(interfaceId);
781   }
782 
783   /**
784    * @dev See {IERC721-balanceOf}.
785    */
786   function balanceOf(address owner) public view virtual override returns (uint256) {
787     require(owner != address(0), "ERC721: balance query for the zero address");
788     return _balances[owner];
789   }
790 
791   /**
792    * @dev See {IERC721-ownerOf}.
793    */
794   function ownerOf(uint256 tokenId) public view virtual override returns (address) {
795     address owner = _owners[tokenId];
796     require(owner != address(0), "ERC721: owner query for nonexistent token");
797     return owner;
798   }
799 
800   /**
801    * @dev See {IERC721Metadata-name}.
802    */
803   function name() public view virtual override returns (string memory) {
804     return _name;
805   }
806 
807   /**
808    * @dev See {IERC721Metadata-symbol}.
809    */
810   function symbol() public view virtual override returns (string memory) {
811     return _symbol;
812   }
813 
814   /**
815    * @dev See {IERC721Metadata-tokenURI}.
816    */
817   function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
818     require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
819 
820     return bytes(_baseURI).length > 0 ? string(abi.encodePacked(_baseURI, tokenId.toString())) : "";
821   }
822 
823   /**
824    * @dev Set baseURI
825    */
826   function setBaseURI(string memory baseURI_) public virtual onlyOwner {
827     _baseURI = baseURI_;
828   }
829 
830   /**
831    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
832    */
833   function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
834     require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
835     return _ownedTokens[owner][index];
836   }
837 
838   /**
839    * @dev See {IERC721Enumerable-totalSupply}.
840    */
841   function totalSupply() public view virtual override returns (uint256) {
842     return _allTokens.length;
843   }
844 
845   /**
846    * @dev See {IERC721Enumerable-tokenByIndex}.
847    */
848   function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
849     require(index < ERC721.totalSupply(), "ERC721Enumerable: global index out of bounds");
850     return _allTokens[index];
851   }
852 
853   /**
854    * @dev See {IERC721-approve}.
855    */
856   function approve(address to, uint256 tokenId) public virtual override {
857     address owner = ERC721.ownerOf(tokenId);
858     require(to != owner, "ERC721: approval to current owner");
859 
860     require(
861       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
862       "ERC721: approve caller is not owner nor approved for all"
863     );
864 
865     _approve(to, tokenId);
866   }
867 
868   /**
869    * @dev See {IERC721-getApproved}.
870    */
871   function getApproved(uint256 tokenId) public view virtual override returns (address) {
872     require(_exists(tokenId), "ERC721: approved query for nonexistent token");
873 
874     return _tokenApprovals[tokenId];
875   }
876 
877   /**
878    * @dev See {IERC721-setApprovalForAll}.
879    */
880   function setApprovalForAll(address operator, bool approved) public virtual override {
881     _setApprovalForAll(_msgSender(), operator, approved);
882   }
883 
884   /**
885    * @dev See {IERC721-isApprovedForAll}.
886    */
887   function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
888     return _operatorApprovals[owner][operator];
889   }
890 
891   /**
892    * @dev See {IERC721-transferFrom}.
893    */
894   function transferFrom(
895     address from,
896     address to,
897     uint256 tokenId
898   ) public virtual override {
899     //solhint-disable-next-line max-line-length
900     require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
901 
902     _transfer(from, to, tokenId);
903   }
904 
905   /**
906    * @dev See {IERC721-safeTransferFrom}.
907    */
908   function safeTransferFrom(
909     address from,
910     address to,
911     uint256 tokenId
912   ) public virtual override {
913     safeTransferFrom(from, to, tokenId, "");
914   }
915 
916   /**
917    * @dev See {IERC721-safeTransferFrom}.
918    */
919   function safeTransferFrom(
920     address from,
921     address to,
922     uint256 tokenId,
923     bytes memory _data
924   ) public virtual override {
925     require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
926     _safeTransfer(from, to, tokenId, _data);
927   }
928 
929   /**
930    * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
931    * are aware of the ERC721 protocol to prevent tokens from being forever locked.
932    *
933    * `_data` is additional data, it has no specified format and it is sent in call to `to`.
934    *
935    * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
936    * implement alternative mechanisms to perform token transfer, such as signature-based.
937    *
938    * Requirements:
939    *
940    * - `from` cannot be the zero address.
941    * - `to` cannot be the zero address.
942    * - `tokenId` token must exist and be owned by `from`.
943    * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
944    *
945    * Emits a {Transfer} event.
946    */
947   function _safeTransfer(
948     address from,
949     address to,
950     uint256 tokenId,
951     bytes memory _data
952   ) internal virtual {
953     _transfer(from, to, tokenId);
954     require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
955   }
956 
957   /**
958    * @dev Returns whether `tokenId` exists.
959    *
960    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
961    *
962    * Tokens start existing when they are minted (`_mint`),
963    * and stop existing when they are burned (`_burn`).
964    */
965   function _exists(uint256 tokenId) internal view virtual returns (bool) {
966     return _owners[tokenId] != address(0);
967   }
968 
969   /**
970    * @dev Returns whether `spender` is allowed to manage `tokenId`.
971    *
972    * Requirements:
973    *
974    * - `tokenId` must exist.
975    */
976   function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
977     require(_exists(tokenId), "ERC721: operator query for nonexistent token");
978     address owner = ERC721.ownerOf(tokenId);
979     return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
980   }
981 
982   /**
983    * @dev Safely mints `tokenId` and transfers it to `to`.
984    *
985    * Requirements:
986    *
987    * - `tokenId` must not exist.
988    * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
989    *
990    * Emits a {Transfer} event.
991    */
992   function _safeMint(address to, uint256 tokenId) internal virtual {
993     _safeMint(to, tokenId, "");
994   }
995 
996   /**
997    * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
998    * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
999    */
1000   function _safeMint(
1001     address to,
1002     uint256 tokenId,
1003     bytes memory _data
1004   ) internal virtual {
1005     _mint(to, tokenId);
1006     require(
1007       _checkOnERC721Received(address(0), to, tokenId, _data),
1008       "ERC721: transfer to non ERC721Receiver implementer"
1009     );
1010   }
1011 
1012   /**
1013    * @dev Mints `tokenId` and transfers it to `to`.
1014    *
1015    * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1016    *
1017    * Requirements:
1018    *
1019    * - `tokenId` must not exist.
1020    * - `to` cannot be the zero address.
1021    *
1022    * Emits a {Transfer} event.
1023    */
1024   function _mint(address to, uint256 tokenId) internal virtual {
1025     require(to != address(0), "ERC721: mint to the zero address");
1026     require(!_exists(tokenId), "ERC721: token already minted");
1027 
1028     _beforeTokenTransfer(address(0), to, tokenId);
1029 
1030     _balances[to] += 1;
1031     _owners[tokenId] = to;
1032 
1033     emit Transfer(address(0), to, tokenId);
1034   }
1035 
1036   /**
1037    * @dev Destroys `tokenId`.
1038    * The approval is cleared when the token is burned.
1039    *
1040    * Requirements:
1041    *
1042    * - `tokenId` must exist.
1043    *
1044    * Emits a {Transfer} event.
1045    */
1046   function _burn(uint256 tokenId) internal virtual {
1047     address owner = ERC721.ownerOf(tokenId);
1048 
1049     _beforeTokenTransfer(owner, address(0), tokenId);
1050 
1051     // Clear approvals
1052     _approve(address(0), tokenId);
1053 
1054     _balances[owner] -= 1;
1055     delete _owners[tokenId];
1056 
1057     emit Transfer(owner, address(0), tokenId);
1058   }
1059 
1060   /**
1061    * @dev Transfers `tokenId` from `from` to `to`.
1062    *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1063    *
1064    * Requirements:
1065    *
1066    * - `to` cannot be the zero address.
1067    * - `tokenId` token must be owned by `from`.
1068    *
1069    * Emits a {Transfer} event.
1070    */
1071   function _transfer(
1072     address from,
1073     address to,
1074     uint256 tokenId
1075   ) internal virtual {
1076     require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1077     require(to != address(0), "ERC721: transfer to the zero address");
1078 
1079     _beforeTokenTransfer(from, to, tokenId);
1080 
1081     // Clear approvals from the previous owner
1082     _approve(address(0), tokenId);
1083 
1084     _balances[from] -= 1;
1085     _balances[to] += 1;
1086     _owners[tokenId] = to;
1087 
1088     emit Transfer(from, to, tokenId);
1089   }
1090 
1091   /**
1092    * @dev Approve `to` to operate on `tokenId`
1093    *
1094    * Emits a {Approval} event.
1095    */
1096   function _approve(address to, uint256 tokenId) internal virtual {
1097     _tokenApprovals[tokenId] = to;
1098     emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1099   }
1100 
1101   /**
1102    * @dev Approve `operator` to operate on all of `owner` tokens
1103    *
1104    * Emits a {ApprovalForAll} event.
1105    */
1106   function _setApprovalForAll(
1107     address owner,
1108     address operator,
1109     bool approved
1110   ) internal virtual {
1111     require(owner != operator, "ERC721: approve to caller");
1112     _operatorApprovals[owner][operator] = approved;
1113     emit ApprovalForAll(owner, operator, approved);
1114   }
1115 
1116   /**
1117    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1118    * The call is not executed if the target address is not a contract.
1119    *
1120    * @param from address representing the previous owner of the given token ID
1121    * @param to target address that will receive the tokens
1122    * @param tokenId uint256 ID of the token to be transferred
1123    * @param _data bytes optional data to send along with the call
1124    * @return bool whether the call correctly returned the expected magic value
1125    */
1126   function _checkOnERC721Received(
1127     address from,
1128     address to,
1129     uint256 tokenId,
1130     bytes memory _data
1131   ) private returns (bool) {
1132     if (to.isContract()) {
1133       try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1134         return retval == IERC721Receiver.onERC721Received.selector;
1135       } catch (bytes memory reason) {
1136         if (reason.length == 0) {
1137           revert("ERC721: transfer to non ERC721Receiver implementer");
1138         } else {
1139           assembly {
1140             revert(add(32, reason), mload(reason))
1141           }
1142         }
1143       }
1144     } else {
1145       return true;
1146     }
1147   }
1148 
1149   /**
1150    * @dev Hook that is called before any token transfer. This includes minting
1151    * and burning.
1152    *
1153    * Calling conditions:
1154    *
1155    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1156    * transferred to `to`.
1157    * - When `from` is zero, `tokenId` will be minted for `to`.
1158    * - When `to` is zero, ``from``'s `tokenId` will be burned.
1159    * - `from` cannot be the zero address.
1160    * - `to` cannot be the zero address.
1161    *
1162    * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1163    */
1164   function _beforeTokenTransfer(
1165     address from,
1166     address to,
1167     uint256 tokenId
1168   ) internal virtual {
1169     if (from == address(0)) {
1170       _addTokenToAllTokensEnumeration(tokenId);
1171     } else if (from != to) {
1172       _removeTokenFromOwnerEnumeration(from, tokenId);
1173     }
1174     if (to == address(0)) {
1175       _removeTokenFromAllTokensEnumeration(tokenId);
1176     } else if (to != from) {
1177       _addTokenToOwnerEnumeration(to, tokenId);
1178     }
1179   }
1180 
1181   /**
1182    * @dev Private function to add a token to this extension's ownership-tracking data structures.
1183    * @param to address representing the new owner of the given token ID
1184    * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1185    */
1186   function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1187     uint256 length = ERC721.balanceOf(to);
1188     _ownedTokens[to][length] = tokenId;
1189     _ownedTokensIndex[tokenId] = length;
1190   }
1191 
1192   /**
1193    * @dev Private function to add a token to this extension's token tracking data structures.
1194    * @param tokenId uint256 ID of the token to be added to the tokens list
1195    */
1196   function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1197     _allTokensIndex[tokenId] = _allTokens.length;
1198     _allTokens.push(tokenId);
1199   }
1200 
1201   /**
1202    * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1203    * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1204    * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1205    * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1206    * @param from address representing the previous owner of the given token ID
1207    * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1208    */
1209   function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1210     // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1211     // then delete the last slot (swap and pop).
1212 
1213     uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1214     uint256 tokenIndex = _ownedTokensIndex[tokenId];
1215 
1216     // When the token to delete is the last token, the swap operation is unnecessary
1217     if (tokenIndex != lastTokenIndex) {
1218       uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1219 
1220       _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1221       _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1222     }
1223 
1224     // This also deletes the contents at the last position of the array
1225     delete _ownedTokensIndex[tokenId];
1226     delete _ownedTokens[from][lastTokenIndex];
1227   }
1228 
1229   /**
1230    * @dev Private function to remove a token from this extension's token tracking data structures.
1231    * This has O(1) time complexity, but alters the order of the _allTokens array.
1232    * @param tokenId uint256 ID of the token to be removed from the tokens list
1233    */
1234   function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1235     // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1236     // then delete the last slot (swap and pop).
1237 
1238     uint256 lastTokenIndex = _allTokens.length - 1;
1239     uint256 tokenIndex = _allTokensIndex[tokenId];
1240 
1241     // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1242     // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1243     // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1244     uint256 lastTokenId = _allTokens[lastTokenIndex];
1245 
1246     _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1247     _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1248 
1249     // This also deletes the contents at the last position of the array
1250     delete _allTokensIndex[tokenId];
1251     _allTokens.pop();
1252   }
1253 }
1254 
1255 /**
1256  * @dev Interface of the ERC20 standard as defined in the EIP.
1257  */
1258 interface IERC20 {
1259   function balanceOf(address account) external view returns (uint256);
1260   function transfer(address to, uint256 amount) external returns (bool);
1261 }
1262 
1263 contract MetaPiggyBanks is ERC721("MetaPiggyBanks", "MPB", "https://metapiggybanks.io/api/metadata/") {
1264   using Counters for Counters.Counter;
1265 
1266   Counters.Counter private _tokenIds;
1267   Counters.Counter private _salesCounter;
1268 
1269   uint256 public publicMintStartAt = 1646780400;
1270   uint256 public whitelistMintStartAt = 1646773200;
1271 
1272   uint256 public maxSupply = 8888;
1273   uint256 public saleSupply = 800;
1274   uint256 public publicMintPrice = 0.0888 ether;
1275   uint256 public whitelistMintPrice = 0.0888 ether;
1276   uint256 public maxBatchMint = 2;
1277 
1278   bytes32 public merkleRoot = 0x0;
1279   uint256 public whitelistRound = 0;
1280   uint256 public whitelistLimitPerAccount = 2;
1281   mapping(uint256 => mapping(address => uint256)) public whitelistMinted;
1282 
1283   function setPublicMintStartAt(uint256 publicMintStartAt_) external onlyOwner {
1284     publicMintStartAt = publicMintStartAt_;
1285   }
1286 
1287   function setWhitelistMintStartAt(uint256 whitelistMintStartAt_) external onlyOwner {
1288     whitelistMintStartAt = whitelistMintStartAt_;
1289   }
1290 
1291   function setSaleSupply(uint256 saleSupply_) external onlyOwner {
1292     require(saleSupply_ <= maxSupply, "Sale supply can't be higher than max supply.");
1293     saleSupply = saleSupply_;
1294   }
1295 
1296   function setPublicMintPrice(uint256 publicMintPrice_) external onlyOwner {
1297     publicMintPrice = publicMintPrice_;
1298   }
1299 
1300   function setWhitelistMintPrice(uint256 whitelistMintPrice_) external onlyOwner {
1301     whitelistMintPrice = whitelistMintPrice_;
1302   }
1303 
1304   function setMaxBatchMint(uint256 maxBatchMint_) external onlyOwner {
1305     maxBatchMint = maxBatchMint_;
1306   }
1307 
1308   function setMerkleRoot(bytes32 merkleRoot_) external onlyOwner {
1309     merkleRoot = merkleRoot_;
1310   }
1311 
1312   function setWhitelistRound(uint256 whitelistRound_) external onlyOwner {
1313     whitelistRound = whitelistRound_;
1314   }
1315 
1316   function setWhitelistLimitPerAccount(uint256 whitelistLimitPerAccount_) external onlyOwner {
1317     whitelistLimitPerAccount = whitelistLimitPerAccount_;
1318   }
1319 
1320   function salesCounter() external view returns (uint256) {
1321     return _salesCounter.current();
1322   }
1323 
1324   function mint(address to) external payable returns (uint256) {
1325     require(block.timestamp >= publicMintStartAt, "Public mint not started yet.");
1326     require(_salesCounter.current() < saleSupply, "Sale supply reached.");
1327     require(msg.value >= publicMintPrice, "Insufficient funds.");
1328 
1329     _salesCounter.increment();
1330 
1331     return safeMint(to);
1332   }
1333 
1334   function batchMint(address to, uint256 amount) external payable returns (uint256[] memory) {
1335     require(block.timestamp >= publicMintStartAt, "Public mint not started yet.");
1336     require(_salesCounter.current() < saleSupply, "Sale supply reached.");
1337     require(_salesCounter.current() + amount <= saleSupply, "Not enough NFTs available for mint.");
1338     require(amount > 0 && amount <= maxBatchMint, "Invalid amount.");
1339     require(msg.value >= publicMintPrice * amount, "Insufficient funds.");
1340 
1341     uint256[] memory tokensMinted = new uint256[](amount);
1342 
1343     for (uint256 i = 0; i < amount; i++) {
1344       _salesCounter.increment();
1345       tokensMinted[i] = safeMint(to);
1346     }
1347 
1348     return tokensMinted;
1349   }
1350 
1351   function whitelistMint(bytes32[] calldata merkleProof, uint256 amount) external payable returns (uint256[] memory) {
1352     require(block.timestamp > whitelistMintStartAt, "Whitelist mint not started yet.");
1353     require(amount > 0, "Invalid amount.");
1354     require(_salesCounter.current() + amount <= saleSupply, "Not enough NFTs available for mint.");
1355     require(msg.value >= whitelistMintPrice * amount, "Insufficient funds.");
1356 
1357     bytes32 leaf = keccak256(abi.encodePacked(_msgSender()));
1358     require(MerkleProof.verify(merkleProof, merkleRoot, leaf), "Invalid proof.");
1359 
1360     require(whitelistMinted[whitelistRound][_msgSender()] + amount <= whitelistLimitPerAccount, "Limit per account exceeded.");
1361     whitelistMinted[whitelistRound][_msgSender()] = whitelistMinted[whitelistRound][_msgSender()] + amount;
1362 
1363     uint256[] memory tokensMinted = new uint256[](amount);
1364 
1365     for (uint256 i = 0; i < amount; i++) {
1366       _salesCounter.increment();
1367       tokensMinted[i] = safeMint(_msgSender());
1368     }
1369 
1370     return tokensMinted;
1371   }
1372 
1373   function teamMint(address to) external onlyOwner returns (uint256) {
1374     return safeMint(to);
1375   }
1376 
1377   function teamBatchMint(address to, uint256 amount) external onlyOwner returns (uint256[] memory) {
1378     require(amount > 0, "Invalid amount.");
1379 
1380     uint256[] memory tokensMinted = new uint256[](amount);
1381 
1382     for (uint256 i = 0; i < amount; i++) {
1383       tokensMinted[i] = safeMint(to);
1384     }
1385 
1386     return tokensMinted;
1387   }
1388 
1389   function safeMint(address to) private returns (uint256) {
1390     require(_tokenIds.current() < maxSupply, "Mint supply reached.");
1391 
1392     _tokenIds.increment();
1393 
1394     uint256 newId = _tokenIds.current();
1395     _safeMint(to, newId);
1396 
1397     return newId;
1398   }
1399 
1400   function withdraw() external payable onlyOwner {
1401     (bool payment, ) = payable(owner()).call{value: address(this).balance}("");
1402     require(payment);
1403   }
1404 
1405   function withdrawToken(address tokenAddress) external onlyOwner {
1406     IERC20 tokenContract = IERC20(tokenAddress);
1407     uint256 balance = tokenContract.balanceOf(address(this));
1408     require(balance > 0, "Insufficient funds.");
1409 
1410     tokenContract.transfer(owner(), balance);
1411   }
1412 }