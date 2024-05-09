1 //SPDX-License-Identifier: MIT
2 pragma solidity 0.8.14;
3 
4 /**
5  * @dev These functions deal with verification of Merkle Trees proofs.
6  *
7  * The proofs can be generated using the JavaScript library
8  * https://github.com/miguelmota/merkletreejs[merkletreejs].
9  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
10  *
11  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
12  */
13 library MerkleProof {
14     /**
15      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
16      * defined by `root`. For this, a `proof` must be provided, containing
17      * sibling hashes on the branch from the leaf to the root of the tree. Each
18      * pair of leaves and each pair of pre-images are assumed to be sorted.
19      */
20     function verify(
21         bytes32[] memory proof,
22         bytes32 root,
23         bytes32 leaf
24     ) internal pure returns (bool) {
25         return processProof(proof, leaf) == root;
26     }
27 
28     /**
29      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
30      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
31      * hash matches the root of the tree. When processing the proof, the pairs
32      * of leafs & pre-images are assumed to be sorted.
33      *
34      * _Available since v4.4._
35      */
36     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
37         bytes32 computedHash = leaf;
38         for (uint256 i = 0; i < proof.length; i++) {
39             bytes32 proofElement = proof[i];
40             if (computedHash <= proofElement) {
41                 // Hash(current computed hash + current element of the proof)
42                 computedHash = _efficientHash(computedHash, proofElement);
43             } else {
44                 // Hash(current element of the proof + current computed hash)
45                 computedHash = _efficientHash(proofElement, computedHash);
46             }
47         }
48         return computedHash;
49     }
50 
51     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
52         assembly {
53             mstore(0x00, a)
54             mstore(0x20, b)
55             value := keccak256(0x00, 0x40)
56         }
57     }
58 }
59 
60 /**
61  * @dev Interface of the ERC165 standard, as defined in the
62  * https://eips.ethereum.org/EIPS/eip-165[EIP].
63  *
64  * Implementers can declare support of contract interfaces, which can then be
65  * queried by others ({ERC165Checker}).
66  *
67  * For an implementation, see {ERC165}.
68  */
69 interface IERC165 {
70     /**
71      * @dev Returns true if this contract implements the interface defined by
72      * `interfaceId`. See the corresponding
73      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
74      * to learn more about how these ids are created.
75      *
76      * This function call must use less than 30 000 gas.
77      */
78     function supportsInterface(bytes4 interfaceId) external view returns (bool);
79 }
80 
81 /**
82  * @dev Implementation of the {IERC165} interface.
83  *
84  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
85  * for the additional interface id that will be supported. For example:
86  *
87  * ```solidity
88  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
89  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
90  * }
91  * ```
92  *
93  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
94  */
95 abstract contract ERC165 is IERC165 {
96     /**
97      * @dev See {IERC165-supportsInterface}.
98      */
99     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
100         return interfaceId == type(IERC165).interfaceId;
101     }
102 }
103 
104 /**
105  * @dev Required interface of an ERC721 compliant contract.
106  */
107 interface IERC721 is IERC165 {
108     /**
109      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
110      */
111     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
112 
113     /**
114      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
115      */
116     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
117 
118     /**
119      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
120      */
121     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
122 
123     /**
124      * @dev Returns the number of tokens in ``owner``'s account.
125      */
126     function balanceOf(address owner) external view returns (uint256 balance);
127 
128     /**
129      * @dev Returns the owner of the `tokenId` token.
130      *
131      * Requirements:
132      *
133      * - `tokenId` must exist.
134      */
135     function ownerOf(uint256 tokenId) external view returns (address owner);
136 
137     /**
138      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
139      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
140      *
141      * Requirements:
142      *
143      * - `from` cannot be the zero address.
144      * - `to` cannot be the zero address.
145      * - `tokenId` token must exist and be owned by `from`.
146      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
147      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
148      *
149      * Emits a {Transfer} event.
150      */
151     function safeTransferFrom(
152         address from,
153         address to,
154         uint256 tokenId
155     ) external;
156 
157     /**
158      * @dev Transfers `tokenId` token from `from` to `to`.
159      *
160      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
161      *
162      * Requirements:
163      *
164      * - `from` cannot be the zero address.
165      * - `to` cannot be the zero address.
166      * - `tokenId` token must be owned by `from`.
167      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
168      *
169      * Emits a {Transfer} event.
170      */
171     function transferFrom(
172         address from,
173         address to,
174         uint256 tokenId
175     ) external;
176 
177     /**
178      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
179      * The approval is cleared when the token is transferred.
180      *
181      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
182      *
183      * Requirements:
184      *
185      * - The caller must own the token or be an approved operator.
186      * - `tokenId` must exist.
187      *
188      * Emits an {Approval} event.
189      */
190     function approve(address to, uint256 tokenId) external;
191 
192     /**
193      * @dev Returns the account approved for `tokenId` token.
194      *
195      * Requirements:
196      *
197      * - `tokenId` must exist.
198      */
199     function getApproved(uint256 tokenId) external view returns (address operator);
200 
201     /**
202      * @dev Approve or remove `operator` as an operator for the caller.
203      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
204      *
205      * Requirements:
206      *
207      * - The `operator` cannot be the caller.
208      *
209      * Emits an {ApprovalForAll} event.
210      */
211     function setApprovalForAll(address operator, bool _approved) external;
212 
213     /**
214      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
215      *
216      * See {setApprovalForAll}
217      */
218     function isApprovedForAll(address owner, address operator) external view returns (bool);
219 
220     /**
221      * @dev Safely transfers `tokenId` token from `from` to `to`.
222      *
223      * Requirements:
224      *
225      * - `from` cannot be the zero address.
226      * - `to` cannot be the zero address.
227      * - `tokenId` token must exist and be owned by `from`.
228      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
229      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
230      *
231      * Emits a {Transfer} event.
232      */
233     function safeTransferFrom(
234         address from,
235         address to,
236         uint256 tokenId,
237         bytes calldata data
238     ) external;
239 }
240 
241 /**
242  * @title ERC721 token receiver interface
243  * @dev Interface for any contract that wants to support safeTransfers
244  * from ERC721 asset contracts.
245  */
246 interface IERC721Receiver {
247     /**
248      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
249      * by `operator` from `from`, this function is called.
250      *
251      * It must return its Solidity selector to confirm the token transfer.
252      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
253      *
254      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
255      */
256     function onERC721Received(
257         address operator,
258         address from,
259         uint256 tokenId,
260         bytes calldata data
261     ) external returns (bytes4);
262 }
263 
264 
265 /**
266  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
267  * @dev See https://eips.ethereum.org/EIPS/eip-721
268  */
269 interface IERC721Metadata is IERC721 {
270     /**
271      * @dev Returns the token collection name.
272      */
273     function name() external view returns (string memory);
274 
275     /**
276      * @dev Returns the token collection symbol.
277      */
278     function symbol() external view returns (string memory);
279 
280     /**
281      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
282      */
283     function tokenURI(uint256 tokenId) external view returns (string memory);
284 }
285 
286 library Address {
287 
288     /**
289      * @dev Returns true if `account` is a contract.
290      *
291      * [IMPORTANT]
292      * ====
293      * It is unsafe to assume that an address for which this function returns
294      * false is an externally-owned account (EOA) and not a contract.
295      *
296      * Among others, `isContract` will return false for the following
297      * types of addresses:
298      *
299      *  - an externally-owned account
300      *  - a contract in construction
301      *  - an address where a contract will be created
302      *  - an address where a contract lived, but was destroyed
303      * ====
304      */
305     function isContract(address account) internal view returns (bool) {
306         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
307         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
308         // for accounts without code, i.e. `keccak256('')`
309         bytes32 codehash;
310         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
311         // solhint-disable-next-line no-inline-assembly
312         assembly { codehash := extcodehash(account) }
313         return (codehash != accountHash && codehash != 0x0);
314     }
315 
316     /**
317      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
318      * `recipient`, forwarding all available gas and reverting on errors.
319      *
320      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
321      * of certain opcodes, possibly making contracts go over the 2300 gas limit
322      * imposed by `transfer`, making them unable to receive funds via
323      * `transfer`. {sendValue} removes this limitation.
324      *
325      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
326      *
327      * IMPORTANT: because control is transferred to `recipient`, care must be
328      * taken to not create reentrancy vulnerabilities. Consider using
329      * {ReentrancyGuard} or the
330      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
331      */
332     function sendValue(address payable recipient, uint256 amount) internal {
333         require(address(this).balance >= amount, "Address: insufficient balance");
334 
335         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
336         (bool success, ) = recipient.call{ value: amount }("");
337         require(success, "Address: unable to send value, recipient may have reverted");
338     }
339 
340     /**
341      * @dev Performs a Solidity function call using a low level `call`. A
342      * plain`call` is an unsafe replacement for a function call: use this
343      * function instead.
344      *
345      * If `target` reverts with a revert reason, it is bubbled up by this
346      * function (like regular Solidity function calls).
347      *
348      * Returns the raw returned data. To convert to the expected return value,
349      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
350      *
351      * Requirements:
352      *
353      * - `target` must be a contract.
354      * - calling `target` with `data` must not revert.
355      *
356      * _Available since v3.1._
357      */
358     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
359         return functionCall(target, data, "Address: low-level call failed");
360     }
361 
362     /**
363      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
364      * `errorMessage` as a fallback revert reason when `target` reverts.
365      *
366      * _Available since v3.1._
367      */
368     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
369         return _functionCallWithValue(target, data, 0, errorMessage);
370     }
371 
372     /**
373      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
374      * but also transferring `value` wei to `target`.
375      *
376      * Requirements:
377      *
378      * - the calling contract must have an ETH balance of at least `value`.
379      * - the called Solidity function must be `payable`.
380      *
381      * _Available since v3.1._
382      */
383     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
384         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
385     }
386 
387     /**
388      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
389      * with `errorMessage` as a fallback revert reason when `target` reverts.
390      *
391      * _Available since v3.1._
392      */
393     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
394         require(address(this).balance >= value, "Address: insufficient balance for call");
395         return _functionCallWithValue(target, data, value, errorMessage);
396     }
397 
398     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
399         require(isContract(target), "Address: call to non-contract");
400 
401         // solhint-disable-next-line avoid-low-level-calls
402         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
403         if (success) {
404             return returndata;
405         } else {
406             // Look for revert reason and bubble it up if present
407             if (returndata.length > 0) {
408                 // The easiest way to bubble the revert reason is using memory via assembly
409 
410                 // solhint-disable-next-line no-inline-assembly
411                 assembly {
412                     let returndata_size := mload(returndata)
413                     revert(add(32, returndata), returndata_size)
414                 }
415             } else {
416                 revert(errorMessage);
417             }
418         }
419     }
420 
421 }
422 
423 /**
424  * @dev Provides information about the current execution context, including the
425  * sender of the transaction and its data. While these are generally available
426  * via msg.sender and msg.data, they should not be accessed in such a direct
427  * manner, since when dealing with meta-transactions the account sending and
428  * paying for execution may not be the actual sender (as far as an application
429  * is concerned).
430  *
431  * This contract is only required for intermediate, library-like contracts.
432  */
433 abstract contract Context {
434     function _msgSender() internal view virtual returns (address) {
435         return msg.sender;
436     }
437 
438     function _msgData() internal view virtual returns (bytes calldata) {
439         return msg.data;
440     }
441 }
442 
443 library SafeMath {
444     /**
445      * @dev Returns the addition of two unsigned integers, reverting on
446      * overflow.
447      *
448      * Counterpart to Solidity's `+` operator.
449      *
450      * Requirements:
451      *
452      * - Addition cannot overflow.
453      */
454     function add(uint256 a, uint256 b) internal pure returns (uint256) {
455         uint256 c = a + b;
456         require(c >= a, "SafeMath: addition overflow");
457 
458         return c;
459     }
460 
461     /**
462      * @dev Returns the subtraction of two unsigned integers, reverting on
463      * overflow (when the result is negative).
464      *
465      * Counterpart to Solidity's `-` operator.
466      *
467      * Requirements:
468      *
469      * - Subtraction cannot overflow.
470      */
471     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
472         return sub(a, b, "SafeMath: subtraction overflow");
473     }
474 
475     /**
476      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
477      * overflow (when the result is negative).
478      *
479      * Counterpart to Solidity's `-` operator.
480      *
481      * Requirements:
482      *
483      * - Subtraction cannot overflow.
484      */
485     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
486         require(b <= a, errorMessage);
487         uint256 c = a - b;
488 
489         return c;
490     }
491 
492     /**
493      * @dev Returns the multiplication of two unsigned integers, reverting on
494      * overflow.
495      *
496      * Counterpart to Solidity's `*` operator.
497      *
498      * Requirements:
499      *
500      * - Multiplication cannot overflow.
501      */
502     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
503         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
504         // benefit is lost if 'b' is also tested.
505         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
506         if (a == 0) {
507             return 0;
508         }
509 
510         uint256 c = a * b;
511         require(c / a == b, "SafeMath: multiplication overflow");
512 
513         return c;
514     }
515 
516     /**
517      * @dev Returns the integer division of two unsigned integers. Reverts on
518      * division by zero. The result is rounded towards zero.
519      *
520      * Counterpart to Solidity's `/` operator. Note: this function uses a
521      * `revert` opcode (which leaves remaining gas untouched) while Solidity
522      * uses an invalid opcode to revert (consuming all remaining gas).
523      *
524      * Requirements:
525      *
526      * - The divisor cannot be zero.
527      */
528     function div(uint256 a, uint256 b) internal pure returns (uint256) {
529         return div(a, b, "SafeMath: division by zero");
530     }
531 
532     /**
533      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
534      * division by zero. The result is rounded towards zero.
535      *
536      * Counterpart to Solidity's `/` operator. Note: this function uses a
537      * `revert` opcode (which leaves remaining gas untouched) while Solidity
538      * uses an invalid opcode to revert (consuming all remaining gas).
539      *
540      * Requirements:
541      *
542      * - The divisor cannot be zero.
543      */
544     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
545         require(b > 0, errorMessage);
546         uint256 c = a / b;
547         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
548 
549         return c;
550     }
551 
552     /**
553      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
554      * Reverts when dividing by zero.
555      *
556      * Counterpart to Solidity's `%` operator. This function uses a `revert`
557      * opcode (which leaves remaining gas untouched) while Solidity uses an
558      * invalid opcode to revert (consuming all remaining gas).
559      *
560      * Requirements:
561      *
562      * - The divisor cannot be zero.
563      */
564     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
565         return mod(a, b, "SafeMath: modulo by zero");
566     }
567 
568     /**
569      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
570      * Reverts with custom message when dividing by zero.
571      *
572      * Counterpart to Solidity's `%` operator. This function uses a `revert`
573      * opcode (which leaves remaining gas untouched) while Solidity uses an
574      * invalid opcode to revert (consuming all remaining gas).
575      *
576      * Requirements:
577      *
578      * - The divisor cannot be zero.
579      */
580     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
581         require(b != 0, errorMessage);
582         return a % b;
583     }
584 }
585 
586 interface IERC20 {
587 
588     function totalSupply() external view returns (uint256);
589     
590     function symbol() external view returns(string memory);
591     
592     function name() external view returns(string memory);
593 
594     /**
595      * @dev Returns the amount of tokens owned by `account`.
596      */
597     function balanceOf(address account) external view returns (uint256);
598     
599     /**
600      * @dev Returns the number of decimal places
601      */
602     function decimals() external view returns (uint8);
603 
604     /**
605      * @dev Moves `amount` tokens from the caller's account to `recipient`.
606      *
607      * Returns a boolean value indicating whether the operation succeeded.
608      *
609      * Emits a {Transfer} event.
610      */
611     function transfer(address recipient, uint256 amount) external returns (bool);
612 
613     /**
614      * @dev Returns the remaining number of tokens that `spender` will be
615      * allowed to spend on behalf of `owner` through {transferFrom}. This is
616      * zero by default.
617      *
618      * This value changes when {approve} or {transferFrom} are called.
619      */
620     function allowance(address owner, address spender) external view returns (uint256);
621 
622     /**
623      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
624      *
625      * Returns a boolean value indicating whether the operation succeeded.
626      *
627      * IMPORTANT: Beware that changing an allowance with this method brings the risk
628      * that someone may use both the old and the new allowance by unfortunate
629      * transaction ordering. One possible solution to mitigate this race
630      * condition is to first reduce the spender's allowance to 0 and set the
631      * desired value afterwards:
632      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
633      *
634      * Emits an {Approval} event.
635      */
636     function approve(address spender, uint256 amount) external returns (bool);
637 
638     /**
639      * @dev Moves `amount` tokens from `sender` to `recipient` using the
640      * allowance mechanism. `amount` is then deducted from the caller's
641      * allowance.
642      *
643      * Returns a boolean value indicating whether the operation succeeded.
644      *
645      * Emits a {Transfer} event.
646      */
647     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
648 
649     /**
650      * @dev Emitted when `value` tokens are moved from one account (`from`) to
651      * another (`to`).
652      *
653      * Note that `value` may be zero.
654      */
655     event Transfer(address indexed from, address indexed to, uint256 value);
656 
657     /**
658      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
659      * a call to {approve}. `value` is the new allowance.
660      */
661     event Approval(address indexed owner, address indexed spender, uint256 value);
662 }
663 
664 contract Ownable {
665 
666     address private owner;
667     
668     // event for EVM logging
669     event OwnerSet(address indexed oldOwner, address indexed newOwner);
670     
671     // modifier to check if caller is owner
672     modifier onlyOwner() {
673         // If the first argument of 'require' evaluates to 'false', execution terminates and all
674         // changes to the state and to Ether balances are reverted.
675         // This used to consume all gas in old EVM versions, but not anymore.
676         // It is often a good idea to use 'require' to check if functions are called correctly.
677         // As a second argument, you can also provide an explanation about what went wrong.
678         require(msg.sender == owner, "Caller is not owner");
679         _;
680     }
681     
682     /**
683      * @dev Set contract deployer as owner
684      */
685     constructor() {
686         owner = msg.sender; // 'msg.sender' is sender of current call, contract deployer for a constructor
687         emit OwnerSet(address(0), owner);
688     }
689 
690     /**
691      * @dev Change owner
692      * @param newOwner address of new owner
693      */
694     function changeOwner(address newOwner) public onlyOwner {
695         emit OwnerSet(owner, newOwner);
696         owner = newOwner;
697     }
698 
699     /**
700      * @dev Return owner address 
701      * @return address of owner
702      */
703     function getOwner() external view returns (address) {
704         return owner;
705     }
706 }
707 
708 contract IECWolves is Context, ERC165, IERC721, IERC721Metadata, Ownable {
709 
710     using Address for address;
711     using SafeMath for uint256;
712 
713     // Token name
714     string private constant _name = "IEC Wolves";
715 
716     // Token symbol
717     string private constant _symbol = "IEC WOLVES";
718 
719     // total number of NFTs Minted
720     uint256 public _totalSupply;
721 
722     // max supply cap
723     uint256 public MAX_SUPPLY = 10_000;
724 
725     // Mapping from token ID to owner address
726     mapping(uint256 => address) private _owners;
727 
728     // Mapping owner address to token count
729     mapping(address => uint256) private _balances;
730 
731     // Mapping from token ID to approved address
732     mapping(uint256 => address) private _tokenApprovals;
733 
734     // Mapping from owner to operator approvals
735     mapping(address => mapping(address => bool)) private _operatorApprovals;
736 
737     // Mapping from tokenID to excluded rewards
738     mapping(uint256 => uint256) private totalExcluded;
739 
740     // total dividends percentage denominator
741     uint256 private constant percentageDenom = 10000;
742 
743     // total rewards received
744     uint256 public totalRewards;
745 
746     // precision factor
747     uint256 private PRECISION = 10**18;
748 
749     /**
750         Mapping From tokenID to Rank
751         Rank 0 = Bronze
752         Rank 1 = Silver
753         Rank 2 = Gold
754         Rank 3 = Executive
755         Rank 4 = VIP
756      */
757     mapping ( uint256 => uint256 ) public getRank;
758 
759     // Ranks
760     struct Rank {
761         uint256 total;
762         uint256 max;
763         uint256 cost;
764         uint256 dividends;
765         uint256 dividendPercentage;
766     }
767     mapping ( uint256 => Rank ) public ranks;
768 
769     // Max rank
770     uint256 public constant MAX_RANK = 4;
771 
772     // Payment Recipient
773     address payable public paymentReceiver;
774 
775     // max holdings per wallet post mint
776     uint256 private constant MAX_HOLDINGS = 25;
777 
778     // Merkle Proof Root For White list
779     bytes32 public merkleRoot;
780 
781     // cost for minting NFT
782     uint256 public cost = 10**18;
783 
784     // base URI
785     string private baseURI = "https://opensea.mypinata.cloud/ipfs/Qma54XdskCs7yKRJPwZeAeJsRfC1eKHTkejTE9WFYBGjkr";
786     string private ending = "";
787 
788     // Reward Token
789     IERC20 public token;
790 
791     // Enable Trading
792     bool public tradingEnabled = false;
793     bool public massRankUpgradeEnabled = true;
794     bool public whitelistEnabled = true;
795 
796     constructor(address payable paymentReceiver_){
797         ranks[0] = Rank({
798             total: 0,
799             max: 10000,
800             cost: 0,
801             dividends: 0,
802             dividendPercentage: 1250
803         });
804         ranks[1] = Rank({
805             total: 0,
806             max: 3000,
807             cost: 10**17,
808             dividends: 0,
809             dividendPercentage: 1875
810         });
811         ranks[2] = Rank({
812             total: 0,
813             max: 1500,
814             cost: 2 * 10**17,
815             dividends: 0,
816             dividendPercentage: 1875
817         });
818         ranks[3] = Rank({
819             total: 0,
820             max: 1000,
821             cost: 4 * 10**17,
822             dividends: 0,
823             dividendPercentage: 2500
824         });
825         ranks[4] = Rank({
826             total: 0,
827             max: 500,
828             cost: 8 * 10**17,
829             dividends: 0,
830             dividendPercentage: 2500
831         });
832 
833         paymentReceiver = paymentReceiver_;
834     }
835 
836 
837     ////////////////////////////////////////////////
838     ///////////   RESTRICTED FUNCTIONS   ///////////
839     ////////////////////////////////////////////////
840 
841     function massUpgrade(uint256[] calldata tokenIds, uint256[] calldata newRanks) external onlyOwner {
842         require(
843             massRankUpgradeEnabled,
844             'D'
845         );
846         
847         uint length = tokenIds.length;
848         require(length == newRanks.length, 'M');
849 
850         for (uint i = 0; i < length;) {
851             require(
852                 getRank[tokenIds[i]] == 0 && newRanks[i] > 0,
853                 'F'
854             );
855             getRank[tokenIds[i]] = newRanks[i];
856             ranks[newRanks[i]].total++;
857             ranks[0].total--;
858             totalExcluded[tokenIds[i]] = getCumulativeDividends(tokenIds[i]);
859             unchecked { ++i; }
860         }
861     }
862 
863     function setRewardToken(address token_) external onlyOwner {
864         token = IERC20(token_);
865     }
866 
867     function disableMassRankUpgrades() external onlyOwner {
868         massRankUpgradeEnabled = false;
869     }
870 
871     function enableTrading() external onlyOwner {
872         tradingEnabled = true;
873     }
874 
875     function disableTrading() external onlyOwner {
876         tradingEnabled = false;
877     }
878 
879     function disableWhitelist() external onlyOwner {
880         whitelistEnabled = false;
881     }
882 
883     function withdraw() external onlyOwner {
884         (bool s,) = payable(paymentReceiver).call{value: address(this).balance}("");
885         require(s);
886     }
887 
888     function withdrawToken(address token_) external onlyOwner {
889         require(token_ != address(token), 'Cannot withdraw IEC Tokens');
890         IERC20(token_).transfer(msg.sender, IERC20(token_).balanceOf(address(this)));
891     }
892 
893     function setCost(uint256 newCost) external onlyOwner {
894         cost = newCost;
895     }
896 
897     function setBaseURI(string calldata newURI) external onlyOwner {
898         baseURI = newURI;
899     }
900 
901     function setURIExtention(string calldata newExtention) external onlyOwner {
902         ending = newExtention;
903     }
904 
905     function setPaymentReceiver(address payable newReceiver) external onlyOwner {
906         paymentReceiver = newReceiver;
907     }
908 
909     function setUpgradeCost(uint256 rank, uint256 newCost) external onlyOwner {
910         require(
911             rank < MAX_RANK,
912             'Max rank'
913         );
914         ranks[rank].cost = newCost;
915     }
916 
917     function setRewardDistribution(
918         uint bronzeP,
919         uint silverP,
920         uint goldP,
921         uint execP,
922         uint vipP
923     ) external onlyOwner {
924         require(
925             bronzeP + silverP + goldP + execP + vipP == percentageDenom,
926             'Invalid Percentages'
927         );
928         ranks[0].dividendPercentage = bronzeP;
929         ranks[1].dividendPercentage = silverP;
930         ranks[2].dividendPercentage = goldP;
931         ranks[3].dividendPercentage = execP;
932         ranks[4].dividendPercentage = vipP;
933     }
934 
935     function setMerkleRoot(bytes32 root) external onlyOwner {
936         merkleRoot = root;
937     }
938 
939     function capCollectionAtSupply() external onlyOwner {
940         MAX_SUPPLY = _totalSupply;
941     }
942 
943     ////////////////////////////////////////////////
944     ///////////     PUBLIC FUNCTIONS     ///////////
945     ////////////////////////////////////////////////
946 
947 
948     function upgrade(uint256 tokenId, uint256 newRank) external payable {
949         require(
950             !massRankUpgradeEnabled,
951             'Mass Rank Upgrades Are Still Enabled'
952         );
953         require(
954             _isApprovedOrOwner(_msgSender(), tokenId), 
955             "Caller Not Owner Nor Approved"
956         );
957         require(
958             newRank <= MAX_RANK,
959             'Max Rank Exceeded'
960         );
961         // current token rank
962         uint currentRank = getRank[tokenId];
963         require(
964             currentRank < newRank,
965             'Cannot Rank Backwards'
966         );
967         require(
968             ranks[newRank].total < ranks[newRank].max,
969             'Max NFTs In Rank'
970         );
971 
972         // calculate cost to upgrade
973         uint costToUpgrade = 0;
974         for (uint i = currentRank; i < newRank; i++) {
975             costToUpgrade += ranks[i + 1].cost;
976         }
977         require(
978             msg.value >= costToUpgrade,
979             'Insufficient Value Sent'
980         );
981 
982         // claim pending rewards for token ID
983         _claimRewards(_msgSender(), tokenId);
984 
985         // decrement old rank total
986         ranks[currentRank].total--;
987 
988         // increment new rank total
989         ranks[newRank].total++;
990 
991         // increment tokenId Rank
992         getRank[tokenId] = newRank;
993 
994         // reset total excluded for new rank
995         totalExcluded[tokenId] = getCumulativeDividends(tokenId);
996     }
997 
998     /** 
999      * Mints `numberOfMints` NFTs To Caller
1000      */
1001     function mint(uint256 numberOfMints) external payable {
1002         require(
1003             tradingEnabled,
1004             'Trading Not Enabled'
1005         );
1006         require(
1007             !whitelistEnabled,
1008             'White list is enabled'
1009         );
1010 
1011         require(numberOfMints > 0, 'Invalid Input');
1012         require(cost * numberOfMints <= msg.value, 'Incorrect Value Sent');
1013 
1014         for (uint i = 0; i < numberOfMints; i++) {
1015             _safeMint(msg.sender, _totalSupply);
1016         }
1017 
1018         require(
1019             _balances[msg.sender] <= MAX_HOLDINGS,
1020             'Max Holdings Exceeded'
1021         );
1022     }
1023 
1024     /** 
1025      * Mints `numberOfMints` NFTs To Caller if Caller is whitelisted
1026      */
1027     function whitelistMint(uint256 numberOfMints, bytes32[] calldata proof) external payable {
1028         require(
1029             tradingEnabled,
1030             'Trading Not Enabled'
1031         );
1032         require(
1033             whitelistEnabled,
1034             'White list is disabled'
1035         );
1036         require(
1037             MerkleProof.verify(
1038                 proof,
1039                 merkleRoot,
1040                 toBytes32(_msgSender())
1041             ) == true,
1042             "User Is Not Whitelisted"
1043         );
1044 
1045         require(numberOfMints > 0, 'Invalid Input');
1046         require(cost * numberOfMints <= msg.value, 'Incorrect Value Sent');
1047 
1048         for (uint i = 0; i < numberOfMints; i++) {
1049             _safeMint(msg.sender, _totalSupply);
1050         }
1051 
1052         require(
1053             _balances[msg.sender] <= MAX_HOLDINGS,
1054             'Max Holdings Exceeded'
1055         );
1056         
1057     }
1058 
1059     function batchClaim(uint256[] calldata tokenIds) external {
1060         
1061         // define length prior to save gas
1062         uint length = tokenIds.length;
1063         require(
1064             length > 0,
1065             'Zero Length'
1066         );
1067 
1068         // save gas by declaring early
1069         uint totalPending = 0;
1070         uint currentID = 0;
1071         address sender = _msgSender();
1072 
1073         // loop through IDs, accruing pending rewards and resetting pending rewards
1074         for (uint i = 0; i < length;) {
1075             // current ID in list
1076             currentID = tokenIds[i];
1077             // require ID is owned by sender
1078             require(_isApprovedOrOwner(sender, currentID), "caller not owner nor approved");
1079             // add value to total pending
1080             totalPending += pendingRewards(currentID);
1081             // reset total excluded - resetting rewards
1082             totalExcluded[currentID] = getCumulativeDividends(currentID);
1083             // increment loop
1084             unchecked { ++i; }
1085         }
1086 
1087         // total available balance
1088         uint bal = token.balanceOf(address(this));
1089 
1090         // avoid round off error
1091         if (totalPending > bal) {
1092             totalPending = bal;
1093         }
1094 
1095         // return if no rewards
1096         if (totalPending == 0) {
1097             return;
1098         }
1099 
1100         // transfer reward to user
1101         require(
1102             token.transfer(sender, totalPending),
1103             'Failure On Token Transfer'
1104         );
1105     }
1106 
1107     function claimRewards(uint256 tokenId) external {
1108         require(_isApprovedOrOwner(_msgSender(), tokenId), "caller not owner nor approved");
1109         _claimRewards(_owners[tokenId], tokenId);
1110     }
1111 
1112     function giveRewards(uint amount) external {
1113         if (massRankUpgradeEnabled) {
1114             return;
1115         }
1116 
1117         // transfer in rewards
1118         uint before = token.balanceOf(address(this));
1119         require(
1120             token.transferFrom(
1121                 msg.sender,
1122                 address(this),
1123                 amount
1124             ),
1125             'Failure On Token Transfer'
1126         );
1127         uint After = token.balanceOf(address(this));
1128         // ensure tokens were received
1129         require(
1130             After > before,
1131             'Zero Received'
1132         );
1133         uint received = After - before;
1134 
1135         // increment total rewards
1136         totalRewards += received;
1137 
1138         // fetch distributions
1139         (uint bp, uint sp, uint gp, uint ep, uint vp) = _fetchDistributionPercentages();
1140 
1141         // roll over if zero
1142         if (ranks[4].total == 0) {
1143             bp += vp / 4;
1144             sp += vp / 4;
1145             gp += vp / 4;
1146             ep += vp / 4;
1147             vp = 0;
1148         }
1149         if (ranks[3].total == 0) {
1150             bp += ep / 3;
1151             sp += ep / 3;
1152             gp += ep / 3;
1153             ep = 0;
1154         }
1155         if (ranks[2].total == 0) {
1156             bp += gp / 2;
1157             sp += gp / 2;
1158             gp = 0;
1159         }
1160         if (ranks[1].total == 0) {
1161             bp += sp;
1162             sp = 0;
1163         }
1164 
1165         // split up amounts for each sector
1166         uint forBronze = received.mul(bp).div(percentageDenom);
1167         uint forSilver = received.mul(sp).div(percentageDenom);
1168         uint forGold = received.mul(gp).div(percentageDenom);
1169         uint forExec = received.mul(ep).div(percentageDenom);
1170         uint forVIP = received.mul(vp).div(percentageDenom);
1171 
1172         // Increment Dividend Rewards
1173         if (ranks[4].total > 0) {
1174             ranks[4].dividends += forVIP.mul(PRECISION).div(ranks[4].total);
1175         }
1176         if (ranks[3].total > 0) {
1177             ranks[3].dividends += forExec.mul(PRECISION).div(ranks[3].total);
1178         }
1179         if (ranks[2].total > 0) {
1180             ranks[2].dividends += forGold.mul(PRECISION).div(ranks[2].total);
1181         }
1182         if (ranks[1].total > 0) {
1183             ranks[1].dividends += forSilver.mul(PRECISION).div(ranks[1].total);
1184         }
1185         if (ranks[0].total > 0) {
1186             ranks[0].dividends += forBronze.mul(PRECISION).div(ranks[0].total);
1187         }
1188         
1189     }
1190 
1191     function _fetchDistributionPercentages() internal view returns (uint, uint, uint, uint, uint) {
1192         return (
1193             ranks[0].dividendPercentage, 
1194             ranks[1].dividendPercentage, 
1195             ranks[2].dividendPercentage,
1196             ranks[3].dividendPercentage,
1197             ranks[4].dividendPercentage
1198         );
1199     }
1200 
1201     function toBytes32(address addr) pure internal returns (bytes32) {
1202         return bytes32(uint256(uint160(addr)));
1203     }
1204 
1205     receive() external payable {}
1206 
1207     /**
1208      * @dev See {IERC721-approve}.
1209      */
1210     function approve(address to, uint256 tokenId) public override {
1211         address wpowner = ownerOf(tokenId);
1212         require(to != wpowner, "ERC721: approval to current owner");
1213 
1214         require(
1215             _msgSender() == wpowner || isApprovedForAll(wpowner, _msgSender()),
1216             "ERC721: not approved or owner"
1217         );
1218 
1219         _approve(to, tokenId);
1220     }
1221 
1222     /**
1223      * @dev See {IERC721-setApprovalForAll}.
1224      */
1225     function setApprovalForAll(address _operator, bool approved) public override {
1226         _setApprovalForAll(_msgSender(), _operator, approved);
1227     }
1228 
1229     /**
1230      * @dev See {IERC721-transferFrom}.
1231      */
1232     function transferFrom(
1233         address from,
1234         address to,
1235         uint256 tokenId
1236     ) public override {
1237         require(_isApprovedOrOwner(_msgSender(), tokenId), "caller not owner nor approved");
1238         _transfer(from, to, tokenId);
1239     }
1240 
1241     /**
1242      * @dev See {IERC721-safeTransferFrom}.
1243      */
1244     function safeTransferFrom(
1245         address from,
1246         address to,
1247         uint256 tokenId
1248     ) public override {
1249         safeTransferFrom(from, to, tokenId, "");
1250     }
1251 
1252     /**
1253      * @dev See {IERC721-safeTransferFrom}.
1254      */
1255     function safeTransferFrom(
1256         address from,
1257         address to,
1258         uint256 tokenId,
1259         bytes memory _data
1260     ) public override {
1261         require(_isApprovedOrOwner(_msgSender(), tokenId), "caller not owner nor approved");
1262         _safeTransfer(from, to, tokenId, _data);
1263     }
1264 
1265 
1266     ////////////////////////////////////////////////
1267     ///////////     READ FUNCTIONS       ///////////
1268     ////////////////////////////////////////////////
1269 
1270     function totalSupply() external view returns (uint256) {
1271         return _totalSupply;
1272     }
1273 
1274     function getIDsByOwner(address owner) external view returns (uint256[] memory) {
1275         uint256[] memory ids = new uint256[](balanceOf(owner));
1276         if (owner == address(0)) { return ids; }
1277         if (balanceOf(owner) == 0) { return ids; }
1278         uint256 count = 0;
1279         for (uint i = 0; i < _totalSupply;) {
1280             if (_owners[i] == owner) {
1281                 ids[count] = i;
1282                 count++;
1283             }
1284             unchecked { ++i; }
1285         }
1286         return ids;
1287     }
1288 
1289     /**
1290      * @dev See {IERC165-supportsInterface}.
1291      */
1292     function supportsInterface(bytes4 interfaceId) public view override(ERC165, IERC165) returns (bool) {
1293         return
1294             interfaceId == type(IERC721).interfaceId ||
1295             interfaceId == type(IERC721Metadata).interfaceId ||
1296             super.supportsInterface(interfaceId);
1297     }
1298 
1299     /**
1300      * @dev See {IERC721-balanceOf}.
1301      */
1302     function balanceOf(address wpowner) public view override returns (uint256) {
1303         require(wpowner != address(0), "query for the zero address");
1304         return _balances[wpowner];
1305     }
1306 
1307     /**
1308      * @dev See {IERC721-ownerOf}.
1309      */
1310     function ownerOf(uint256 tokenId) public view override returns (address) {
1311         address wpowner = _owners[tokenId];
1312         require(wpowner != address(0), "query for nonexistent token");
1313         return wpowner;
1314     }
1315 
1316     /**
1317      * @dev See {IERC721Metadata-name}.
1318      */
1319     function name() public pure override returns (string memory) {
1320         return _name;
1321     }
1322 
1323     /**
1324      * @dev See {IERC721Metadata-symbol}.
1325      */
1326     function symbol() public pure override returns (string memory) {
1327         return _symbol;
1328     }
1329 
1330     /**
1331      * @dev See {IERC721Metadata-tokenURI}.
1332      */
1333     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1334         require(_exists(tokenId), "nonexistent token");
1335 
1336         string memory fHalf = string.concat(baseURI, uint2str(getRank[tokenId]));
1337         string memory sHalf = string.concat(fHalf, '-');
1338         string memory tHalf = string.concat(sHalf, uint2str(tokenId));
1339         return string.concat(tHalf, ending);
1340     }
1341 
1342     /**
1343         Converts A Uint Into a String
1344     */
1345     function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
1346         if (_i == 0) {
1347             return "0";
1348         }
1349         uint j = _i;
1350         uint len;
1351         while (j != 0) {
1352             len++;
1353             j /= 10;
1354         }
1355         bytes memory bstr = new bytes(len);
1356         uint k = len;
1357         while (_i != 0) {
1358             k = k-1;
1359             uint8 temp = (48 + uint8(_i - _i / 10 * 10));
1360             bytes1 b1 = bytes1(temp);
1361             bstr[k] = b1;
1362             _i /= 10;
1363         }
1364         return string(bstr);
1365     }
1366 
1367     /**
1368      * @dev See {IERC721-getApproved}.
1369      */
1370     function getApproved(uint256 tokenId) public view override returns (address) {
1371         require(_exists(tokenId), "ERC721: query for nonexistent token");
1372 
1373         return _tokenApprovals[tokenId];
1374     }
1375 
1376     /**
1377      * @dev See {IERC721-isApprovedForAll}.
1378      */
1379     function isApprovedForAll(address wpowner, address _operator) public view override returns (bool) {
1380         return _operatorApprovals[wpowner][_operator];
1381     }
1382 
1383     /**
1384         Pending IEC Rewards For `tokenId`
1385      */
1386     function pendingRewards(uint256 tokenId) public view returns (uint256) {
1387 
1388         uint256 tokenIDDividends = getCumulativeDividends(tokenId);
1389         uint256 tokenIDExcluded = totalExcluded[tokenId];
1390 
1391         if(tokenIDDividends <= tokenIDExcluded){ return 0; }
1392 
1393         return tokenIDDividends - tokenIDExcluded;
1394     }
1395 
1396     /**
1397         Cumulative Dividends For A Number Of Tokens
1398      */
1399     function getCumulativeDividends(uint256 tokenId) internal view returns (uint256) {
1400         return ranks[getRank[tokenId]].dividends.div(PRECISION);
1401     }
1402 
1403     /**
1404      * @dev Returns whether `tokenId` exists.
1405      *
1406      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1407      *
1408      * Tokens start existing when they are minted
1409      */
1410     function _exists(uint256 tokenId) internal view returns (bool) {
1411         return _owners[tokenId] != address(0);
1412     }
1413 
1414     /**
1415      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1416      *
1417      * Requirements:
1418      *
1419      * - `tokenId` must exist.
1420      */
1421     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
1422         require(_exists(tokenId), "ERC721: nonexistent token");
1423         address wpowner = ownerOf(tokenId);
1424         return (spender == wpowner || getApproved(tokenId) == spender || isApprovedForAll(wpowner, spender));
1425     }
1426 
1427     ////////////////////////////////////////////////
1428     ///////////    INTERNAL FUNCTIONS    ///////////
1429     ////////////////////////////////////////////////
1430 
1431 
1432     /**
1433      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1434      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1435      */
1436     function _safeMint(
1437         address to,
1438         uint256 tokenId
1439     ) internal {
1440         _mint(to, tokenId);
1441         require(
1442             _checkOnERC721Received(address(0), to, tokenId, ""),
1443             "ERC721: transfer to non ERC721Receiver implementer"
1444         );
1445     }
1446 
1447     /**
1448      * @dev Mints `tokenId` and transfers it to `to`.
1449      *
1450      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1451      *
1452      * Requirements:
1453      *
1454      * - `tokenId` must not exist.
1455      * - `to` cannot be the zero address.
1456      *
1457      * Emits a {Transfer} event.
1458      */
1459     function _mint(address to, uint256 tokenId) internal {
1460         require(!_exists(tokenId), "ERC721: token already minted");
1461         require(_totalSupply < MAX_SUPPLY, 'All NFTs Have Been Minted');
1462 
1463         _balances[to] += 1;
1464         _owners[tokenId] = to;
1465         _totalSupply += 1;
1466         ranks[0].total++;
1467         totalExcluded[tokenId] = getCumulativeDividends(tokenId);
1468 
1469         emit Transfer(address(0), to, tokenId);
1470     }
1471 
1472     /**
1473      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1474      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1475      *
1476      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1477      *
1478      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1479      * implement alternative mechanisms to perform token transfer, such as signature-based.
1480      *
1481      * Requirements:
1482      *
1483      * - `from` cannot be the zero address.
1484      * - `to` cannot be the zero address.
1485      * - `tokenId` token must exist and be owned by `from`.
1486      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1487      *
1488      * Emits a {Transfer} event.
1489      */
1490     function _safeTransfer(
1491         address from,
1492         address to,
1493         uint256 tokenId,
1494         bytes memory _data
1495     ) internal {
1496         _transfer(from, to, tokenId);
1497         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: non ERC721Receiver implementer");
1498     }
1499 
1500 
1501     /**
1502      * @dev Transfers `tokenId` from `from` to `to`.
1503      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1504      *
1505      * Requirements:
1506      *
1507      * - `to` cannot be the zero address.
1508      * - `tokenId` token must be owned by `from`.
1509      *
1510      * Emits a {Transfer} event.
1511      */
1512     function _transfer(
1513         address from,
1514         address to,
1515         uint256 tokenId
1516     ) internal {
1517         require(ownerOf(tokenId) == from, "Incorrect owner");
1518         require(to != address(0), "zero address");
1519         require(balanceOf(from) > 0, 'Zero Balance');
1520 
1521         // Clear approvals from the previous owner
1522         _approve(address(0), tokenId);
1523 
1524         // claim rewards for tokenId
1525         _claimRewards(from, tokenId);
1526 
1527         // Allocate balances
1528         _balances[from] -= 1;
1529         _balances[to] += 1;
1530         _owners[tokenId] = to;
1531 
1532         // emit transfer
1533         emit Transfer(from, to, tokenId);
1534     }
1535 
1536     /**
1537         Claims IEC Reward For User
1538      */
1539     function _claimRewards(address owner, uint256 tokenId) internal {
1540 
1541         // fetch pending rewards
1542         uint pending = pendingRewards(tokenId);
1543         uint bal = token.balanceOf(address(this));
1544 
1545         // avoid round off error
1546         if (pending > bal) {
1547             pending = bal;
1548         }
1549 
1550         // return if no rewards
1551         if (pending == 0) {
1552             return;
1553         }
1554         
1555         // reset total rewards
1556         totalExcluded[tokenId] = getCumulativeDividends(tokenId);
1557 
1558         // transfer reward to user
1559         require(
1560             token.transfer(owner, pending),
1561             'Failure On Token Transfer'
1562         );
1563     }
1564 
1565     /**
1566      * @dev Approve `to` to operate on `tokenId`
1567      *
1568      * Emits a {Approval} event.
1569      */
1570     function _approve(address to, uint256 tokenId) internal {
1571         _tokenApprovals[tokenId] = to;
1572         emit Approval(ownerOf(tokenId), to, tokenId);
1573     }
1574 
1575     /**
1576      * @dev Approve `operator` to operate on all of `owner` tokens
1577      *
1578      * Emits a {ApprovalForAll} event.
1579      */
1580     function _setApprovalForAll(
1581         address wpowner,
1582         address _operator,
1583         bool approved
1584     ) internal {
1585         require(wpowner != _operator, "ERC721: approve to caller");
1586         _operatorApprovals[wpowner][_operator] = approved;
1587         emit ApprovalForAll(wpowner, _operator, approved);
1588     }
1589 
1590     function onReceivedRetval() public pure returns (bytes4) {
1591         return IERC721Receiver.onERC721Received.selector;
1592     }
1593 
1594     /**
1595      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1596      * The call is not executed if the target address is not a contract.
1597      *
1598      * @param from address representing the previous owner of the given token ID
1599      * @param to target address that will receive the tokens
1600      * @param tokenId uint256 ID of the token to be transferred
1601      * @param _data bytes optional data to send along with the call
1602      * @return bool whether the call correctly returned the expected magic value
1603      */
1604     function _checkOnERC721Received(
1605         address from,
1606         address to,
1607         uint256 tokenId,
1608         bytes memory _data
1609     ) private returns (bool) {
1610         if (to.isContract()) {
1611             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1612                 return retval == IERC721Receiver.onERC721Received.selector;
1613             } catch (bytes memory reason) {
1614                 if (reason.length == 0) {
1615                     revert("ERC721: non ERC721Receiver implementer");
1616                 } else {
1617                     assembly {
1618                         revert(add(32, reason), mload(reason))
1619                     }
1620                 }
1621             }
1622         } else {
1623             return true;
1624         }
1625     }
1626 }