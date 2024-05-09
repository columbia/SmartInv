1 // SPDX-License-Identifier: UNLICENSED
2 pragma solidity >=0.8.10 <0.9.0;
3 
4 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
5 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
6 /**
7  * @dev Interface of the ERC20 standard as defined in the EIP.
8  */
9 interface IERC20 {
10     /**
11      * @dev Returns the amount of tokens in existence.
12      */
13     function totalSupply() external view returns (uint256);
14 
15     /**
16      * @dev Returns the amount of tokens owned by `account`.
17      */
18     function balanceOf(address account) external view returns (uint256);
19 
20     /**
21      * @dev Moves `amount` tokens from the caller's account to `to`.
22      *
23      * Returns a boolean value indicating whether the operation succeeded.
24      *
25      * Emits a {Transfer} event.
26      */
27     function transfer(address to, uint256 amount) external returns (bool);
28 
29     /**
30      * @dev Returns the remaining number of tokens that `spender` will be
31      * allowed to spend on behalf of `owner` through {transferFrom}. This is
32      * zero by default.
33      *
34      * This value changes when {approve} or {transferFrom} are called.
35      */
36     function allowance(address owner, address spender) external view returns (uint256);
37 
38     /**
39      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
40      *
41      * Returns a boolean value indicating whether the operation succeeded.
42      *
43      * IMPORTANT: Beware that changing an allowance with this method brings the risk
44      * that someone may use both the old and the new allowance by unfortunate
45      * transaction ordering. One possible solution to mitigate this race
46      * condition is to first reduce the spender's allowance to 0 and set the
47      * desired value afterwards:
48      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
49      *
50      * Emits an {Approval} event.
51      */
52     function approve(address spender, uint256 amount) external returns (bool);
53 
54     /**
55      * @dev Moves `amount` tokens from `from` to `to` using the
56      * allowance mechanism. `amount` is then deducted from the caller's
57      * allowance.
58      *
59      * Returns a boolean value indicating whether the operation succeeded.
60      *
61      * Emits a {Transfer} event.
62      */
63     function transferFrom(
64         address from,
65         address to,
66         uint256 amount
67     ) external returns (bool);
68 
69     /**
70      * @dev Emitted when `value` tokens are moved from one account (`from`) to
71      * another (`to`).
72      *
73      * Note that `value` may be zero.
74      */
75     event Transfer(address indexed from, address indexed to, uint256 value);
76 
77     /**
78      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
79      * a call to {approve}. `value` is the new allowance.
80      */
81     event Approval(address indexed owner, address indexed spender, uint256 value);
82 }
83 
84 // File: @openzeppelin/contracts/utils/Strings.sol
85 
86 
87 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
88 
89 pragma solidity ^0.8.0;
90 
91 /**
92  * @dev String operations.
93  */
94 library Strings {
95     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
96 
97     /**
98      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
99      */
100     function toString(uint256 value) internal pure returns (string memory) {
101         // Inspired by OraclizeAPI's implementation - MIT licence
102         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
103 
104         if (value == 0) {
105             return "0";
106         }
107         uint256 temp = value;
108         uint256 digits;
109         while (temp != 0) {
110             digits++;
111             temp /= 10;
112         }
113         bytes memory buffer = new bytes(digits);
114         while (value != 0) {
115             digits -= 1;
116             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
117             value /= 10;
118         }
119         return string(buffer);
120     }
121 
122     /**
123      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
124      */
125     function toHexString(uint256 value) internal pure returns (string memory) {
126         if (value == 0) {
127             return "0x00";
128         }
129         uint256 temp = value;
130         uint256 length = 0;
131         while (temp != 0) {
132             length++;
133             temp >>= 8;
134         }
135         return toHexString(value, length);
136     }
137 
138     /**
139      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
140      */
141     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
142         bytes memory buffer = new bytes(2 * length + 2);
143         buffer[0] = "0";
144         buffer[1] = "x";
145         for (uint256 i = 2 * length + 1; i > 1; --i) {
146             buffer[i] = _HEX_SYMBOLS[value & 0xf];
147             value >>= 4;
148         }
149         require(value == 0, "Strings: hex length insufficient");
150         return string(buffer);
151     }
152 }
153 
154 // File: contracts/MerkleProof.sol
155 
156 
157 
158 pragma solidity ^0.8.9;
159 
160 
161 /**
162  * @dev These functions deal with verification of Merkle trees (hash trees),
163  */
164 library MerkleProof {
165     /**
166      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
167      * defined by `root`. For this, a `proof` must be provided, containing
168      * sibling hashes on the branch from the leaf to the root of the tree. Each
169      * pair of leaves and each pair of pre-images are assumed to be sorted.
170      */
171 
172     using Strings for uint256;
173 
174     function verify(bytes32[] memory proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
175         bytes32 computedHash = leaf;
176         for (uint256 i = 0; i < proof.length; i++) {
177             bytes32 proofElement = proof[i];
178             if (computedHash <= proofElement) {
179                 // Hash(current computed hash + current element of the proof)
180                 computedHash = keccak256(abi.encodePacked(i.toString(), computedHash, proofElement));
181             } else {
182                 // Hash(current element of the proof + current computed hash)
183                 computedHash = keccak256(abi.encodePacked(i.toString(), proofElement, computedHash));
184             }
185         }
186         // Check if the computed hash (root) is equal to the provided root
187         return computedHash == root;
188     }
189     
190 }
191 // File: @openzeppelin/contracts/utils/Address.sol
192 
193 
194 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
195 
196 pragma solidity ^0.8.1;
197 
198 /**
199  * @dev Collection of functions related to the address type
200  */
201 library Address {
202     /**
203      * @dev Returns true if `account` is a contract.
204      *
205      * [IMPORTANT]
206      * ====
207      * It is unsafe to assume that an address for which this function returns
208      * false is an externally-owned account (EOA) and not a contract.
209      *
210      * Among others, `isContract` will return false for the following
211      * types of addresses:
212      *
213      *  - an externally-owned account
214      *  - a contract in construction
215      *  - an address where a contract will be created
216      *  - an address where a contract lived, but was destroyed
217      * ====
218      *
219      * [IMPORTANT]
220      * ====
221      * You shouldn't rely on `isContract` to protect against flash loan attacks!
222      *
223      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
224      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
225      * constructor.
226      * ====
227      */
228     function isContract(address account) internal view returns (bool) {
229         // This method relies on extcodesize/address.code.length, which returns 0
230         // for contracts in construction, since the code is only stored at the end
231         // of the constructor execution.
232 
233         return account.code.length > 0;
234     }
235 
236     /**
237      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
238      * `recipient`, forwarding all available gas and reverting on errors.
239      *
240      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
241      * of certain opcodes, possibly making contracts go over the 2300 gas limit
242      * imposed by `transfer`, making them unable to receive funds via
243      * `transfer`. {sendValue} removes this limitation.
244      *
245      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
246      *
247      * IMPORTANT: because control is transferred to `recipient`, care must be
248      * taken to not create reentrancy vulnerabilities. Consider using
249      * {ReentrancyGuard} or the
250      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
251      */
252     function sendValue(address payable recipient, uint256 amount) internal {
253         require(address(this).balance >= amount, "Address: insufficient balance");
254 
255         (bool success, ) = recipient.call{value: amount}("");
256         require(success, "Address: unable to send value, recipient may have reverted");
257     }
258 
259     /**
260      * @dev Performs a Solidity function call using a low level `call`. A
261      * plain `call` is an unsafe replacement for a function call: use this
262      * function instead.
263      *
264      * If `target` reverts with a revert reason, it is bubbled up by this
265      * function (like regular Solidity function calls).
266      *
267      * Returns the raw returned data. To convert to the expected return value,
268      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
269      *
270      * Requirements:
271      *
272      * - `target` must be a contract.
273      * - calling `target` with `data` must not revert.
274      *
275      * _Available since v3.1._
276      */
277     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
278         return functionCall(target, data, "Address: low-level call failed");
279     }
280 
281     /**
282      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
283      * `errorMessage` as a fallback revert reason when `target` reverts.
284      *
285      * _Available since v3.1._
286      */
287     function functionCall(
288         address target,
289         bytes memory data,
290         string memory errorMessage
291     ) internal returns (bytes memory) {
292         return functionCallWithValue(target, data, 0, errorMessage);
293     }
294 
295     /**
296      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
297      * but also transferring `value` wei to `target`.
298      *
299      * Requirements:
300      *
301      * - the calling contract must have an ETH balance of at least `value`.
302      * - the called Solidity function must be `payable`.
303      *
304      * _Available since v3.1._
305      */
306     function functionCallWithValue(
307         address target,
308         bytes memory data,
309         uint256 value
310     ) internal returns (bytes memory) {
311         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
312     }
313 
314     /**
315      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
316      * with `errorMessage` as a fallback revert reason when `target` reverts.
317      *
318      * _Available since v3.1._
319      */
320     function functionCallWithValue(
321         address target,
322         bytes memory data,
323         uint256 value,
324         string memory errorMessage
325     ) internal returns (bytes memory) {
326         require(address(this).balance >= value, "Address: insufficient balance for call");
327         require(isContract(target), "Address: call to non-contract");
328 
329         (bool success, bytes memory returndata) = target.call{value: value}(data);
330         return verifyCallResult(success, returndata, errorMessage);
331     }
332 
333     /**
334      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
335      * but performing a static call.
336      *
337      * _Available since v3.3._
338      */
339     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
340         return functionStaticCall(target, data, "Address: low-level static call failed");
341     }
342 
343     /**
344      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
345      * but performing a static call.
346      *
347      * _Available since v3.3._
348      */
349     function functionStaticCall(
350         address target,
351         bytes memory data,
352         string memory errorMessage
353     ) internal view returns (bytes memory) {
354         require(isContract(target), "Address: static call to non-contract");
355 
356         (bool success, bytes memory returndata) = target.staticcall(data);
357         return verifyCallResult(success, returndata, errorMessage);
358     }
359 
360     /**
361      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
362      * but performing a delegate call.
363      *
364      * _Available since v3.4._
365      */
366     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
367         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
368     }
369 
370     /**
371      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
372      * but performing a delegate call.
373      *
374      * _Available since v3.4._
375      */
376     function functionDelegateCall(
377         address target,
378         bytes memory data,
379         string memory errorMessage
380     ) internal returns (bytes memory) {
381         require(isContract(target), "Address: delegate call to non-contract");
382 
383         (bool success, bytes memory returndata) = target.delegatecall(data);
384         return verifyCallResult(success, returndata, errorMessage);
385     }
386 
387     /**
388      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
389      * revert reason using the provided one.
390      *
391      * _Available since v4.3._
392      */
393     function verifyCallResult(
394         bool success,
395         bytes memory returndata,
396         string memory errorMessage
397     ) internal pure returns (bytes memory) {
398         if (success) {
399             return returndata;
400         } else {
401             // Look for revert reason and bubble it up if present
402             if (returndata.length > 0) {
403                 // The easiest way to bubble the revert reason is using memory via assembly
404 
405                 assembly {
406                     let returndata_size := mload(returndata)
407                     revert(add(32, returndata), returndata_size)
408                 }
409             } else {
410                 revert(errorMessage);
411             }
412         }
413     }
414 }
415 
416 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
417 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
418 /**
419  * @title ERC721 token receiver interface
420  * @dev Interface for any contract that wants to support safeTransfers
421  * from ERC721 asset contracts.
422  */
423 interface IERC721Receiver {
424     /**
425      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
426      * by `operator` from `from`, this function is called.
427      *
428      * It must return its Solidity selector to confirm the token transfer.
429      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
430      *
431      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
432      */
433     function onERC721Received(
434         address operator,
435         address from,
436         uint256 tokenId,
437         bytes calldata data
438     ) external returns (bytes4);
439 }
440 
441 // File: @openzeppelin/contracts/utils/Context.sol
442 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
443 /**
444  * @dev Provides information about the current execution context, including the
445  * sender of the transaction and its data. While these are generally available
446  * via msg.sender and msg.data, they should not be accessed in such a direct
447  * manner, since when dealing with meta-transactions the account sending and
448  * paying for execution may not be the actual sender (as far as an application
449  * is concerned).
450  *
451  * This contract is only required for intermediate, library-like contracts.
452  */
453 abstract contract Context {
454     function _msgSender() internal view virtual returns (address) {
455         return msg.sender;
456     }
457 
458     function _msgData() internal view virtual returns (bytes calldata) {
459         return msg.data;
460     }
461 }
462 
463 // File: @openzeppelin/contracts/access/Ownable.sol
464 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
465 /**
466  * @dev Contract module which provides a basic access control mechanism, where
467  * there is an account (an owner) that can be granted exclusive access to
468  * specific functions.
469  *
470  * By default, the owner account will be the one that deploys the contract. This
471  * can later be changed with {transferOwnership}.
472  *
473  * This module is used through inheritance. It will make available the modifier
474  * `onlyOwner`, which can be applied to your functions to restrict their use to
475  * the owner.
476  */
477 abstract contract Ownable is Context {
478     address private _owner;
479 
480     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
481 
482     /**
483      * @dev Initializes the contract setting the deployer as the initial owner.
484      */
485     constructor() {
486         _transferOwnership(_msgSender());
487     }
488 
489     /**
490      * @dev Returns the address of the current owner.
491      */
492     function owner() public view virtual returns (address) {
493         return _owner;
494     }
495 
496     /**
497      * @dev Throws if called by any account other than the owner.
498      */
499     modifier onlyOwner() {
500         require(owner() == _msgSender(), "Ownable: caller is not the owner");
501         _;
502     }
503 
504     /**
505      * @dev Leaves the contract without owner. It will not be possible to call
506      * `onlyOwner` functions anymore. Can only be called by the current owner.
507      *
508      * NOTE: Renouncing ownership will leave the contract without an owner,
509      * thereby removing any functionality that is only available to the owner.
510      */
511     function renounceOwnership() public virtual onlyOwner {
512         _transferOwnership(address(0));
513     }
514 
515     /**
516      * @dev Transfers ownership of the contract to a new account (`newOwner`).
517      * Can only be called by the current owner.
518      */
519     function transferOwnership(address newOwner) public virtual onlyOwner {
520         require(newOwner != address(0), "Ownable: new owner is the zero address");
521         _transferOwnership(newOwner);
522     }
523 
524     /**
525      * @dev Transfers ownership of the contract to a new account (`newOwner`).
526      * Internal function without access restriction.
527      */
528     function _transferOwnership(address newOwner) internal virtual {
529         address oldOwner = _owner;
530         _owner = newOwner;
531         emit OwnershipTransferred(oldOwner, newOwner);
532     }
533 }
534 
535 // File: @openzeppelin/contracts/security/Pausable.sol
536 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
537 
538 /**
539  * @dev Contract module which allows children to implement an emergency stop
540  * mechanism that can be triggered by an authorized account.
541  *
542  * This module is used through inheritance. It will make available the
543  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
544  * the functions of your contract. Note that they will not be pausable by
545  * simply including this module, only once the modifiers are put in place.
546  */
547 abstract contract Pausable is Context {
548     /**
549      * @dev Emitted when the pause is triggered by `account`.
550      */
551     event Paused(address account);
552 
553     /**
554      * @dev Emitted when the pause is lifted by `account`.
555      */
556     event Unpaused(address account);
557 
558     bool private _paused;
559 
560     /**
561      * @dev Initializes the contract in unpaused state.
562      */
563     constructor() {
564         _paused = false;
565     }
566 
567     /**
568      * @dev Returns true if the contract is paused, and false otherwise.
569      */
570     function paused() public view virtual returns (bool) {
571         return _paused;
572     }
573 
574     /**
575      * @dev Modifier to make a function callable only when the contract is not paused.
576      *
577      * Requirements:
578      *
579      * - The contract must not be paused.
580      */
581     modifier whenNotPaused() {
582         require(!paused(), "Pausable: paused");
583         _;
584     }
585 
586     /**
587      * @dev Modifier to make a function callable only when the contract is paused.
588      *
589      * Requirements:
590      *
591      * - The contract must be paused.
592      */
593     modifier whenPaused() {
594         require(paused(), "Pausable: not paused");
595         _;
596     }
597 
598     /**
599      * @dev Triggers stopped state.
600      *
601      * Requirements:
602      *
603      * - The contract must not be paused.
604      */
605     function _pause() internal virtual whenNotPaused {
606         _paused = true;
607         emit Paused(_msgSender());
608     }
609 
610     /**
611      * @dev Returns to normal state.
612      *
613      * Requirements:
614      *
615      * - The contract must be paused.
616      */
617     function _unpause() internal virtual whenPaused {
618         _paused = false;
619         emit Unpaused(_msgSender());
620     }
621 }
622 
623 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
624 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
625 
626 /**
627  * @dev Interface of the ERC165 standard, as defined in the
628  * https://eips.ethereum.org/EIPS/eip-165[EIP].
629  *
630  * Implementers can declare support of contract interfaces, which can then be
631  * queried by others ({ERC165Checker}).
632  *
633  * For an implementation, see {ERC165}.
634  */
635 interface IERC165 {
636     /**
637      * @dev Returns true if this contract implements the interface defined by
638      * `interfaceId`. See the corresponding
639      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
640      * to learn more about how these ids are created.
641      *
642      * This function call must use less than 30 000 gas.
643      */
644     function supportsInterface(bytes4 interfaceId) external view returns (bool);
645 }
646 
647 // File: contracts/PublicPrivateVoucherMinter.sol
648 
649 abstract contract PublicPrivateVoucherMinter is Ownable {    
650 
651     // event to log mint detail
652     event MinterCreated(address _address);
653     event PublicMint (address _address, uint256 _amount, uint256 _value);
654     event PrivateMint(address _address, uint256 id, uint256 _amount, uint256 _value);
655     event VoucherMint(address _address, uint256 id, uint256 _amount, uint256 _value);
656     event ProjectMint(address _address, uint256 _amount, string _reason);
657 
658 
659     struct MinterConfig {
660         bool isPublicMintActive;       // can call publicMint only when isPublicMintActive is true
661         bool isPrivateMintActive;      // can call privateMint only when isPrivateMintActive is true
662         bool isVoucherMintActive;      // can call voucherMint only when isVoucherMintActive is true
663         uint256 publicMintPrice;       // price for publicMint
664         uint256 privateMintPrice;      // price for privateMint
665         uint256 maxPublicMintAmount;   // maximum amount per publicMint transaction
666         uint256 maxPrivateMintAmount;  // maximum amount per privateMint transaction    
667         uint256 maxTotalSupply;        // maximum supply
668         uint256 maxPrivateMintSupply;  // maximum supply for private round    
669     }
670               
671     // Sale counter
672     uint256 public totalPublicSold;
673     uint256 public totalPrivateSold;    
674     uint256 public totalVoucherClaimed;
675     uint256 public totalVoucherIssued;
676     uint256 public totalProjectMint;
677 
678     address public beneficiary;
679     
680     bytes32 private _merkleRoot;
681     uint256 private _proofLength;
682     
683     // a mapping from voucher/whitelised Id to the amount used
684     mapping(uint256 => uint256) private _amountUsed;  
685     
686     // Operator
687     address private _operator; // address of operator who can set parameter of this contract
688         
689     MinterConfig public minterConfig;
690 
691     constructor (MinterConfig memory config, address payable _beneficiary) {
692         setMinterConfig(config);
693         setBeneficiary(_beneficiary);  
694         setOperator(_msgSender());      
695     }
696 
697     function setMinterConfig(MinterConfig memory config) public onlyOwner {        
698         minterConfig = config;
699     }
700 
701     /// @notice Recipient of revenues
702     function setBeneficiary(address payable _beneficiary) public onlyOwner {
703         require(_beneficiary != address(0), "Not the zero address");
704         beneficiary = _beneficiary;
705     }
706 
707     /** 
708     @dev Called by after all limited have been put in place; must perform all contract-specific sale logic, e.g.
709     ERC721 minting.
710     @param to The recipient of the item(s).
711     @param amount The number of items allowed to be purchased
712     **/
713     function _mintTo(address to, uint256 amount) internal virtual;
714 
715     function togglePublicMintActive() external onlyOwnerAndOperator {
716         require (minterConfig.publicMintPrice > 0, "Public Mint Price is zero");
717         minterConfig.isPublicMintActive = !minterConfig.isPublicMintActive;
718     }
719 
720     function togglePrivateMintActive() external onlyOwnerAndOperator {
721         require (minterConfig.privateMintPrice > 0, "Private Mint Price is zero");
722         minterConfig.isPrivateMintActive = !minterConfig.isPrivateMintActive;
723     }
724 
725     function toggleVoucherMintActive() external onlyOwnerAndOperator {
726         minterConfig.isVoucherMintActive = !minterConfig.isVoucherMintActive;
727     }
728 
729     function totalSold() external view returns (uint256) {
730         return totalPublicSold + totalPrivateSold + totalVoucherClaimed;
731     }
732 
733     // set maxTotalSupply
734     function setMaxTotalSupply(uint256 supply) external onlyOwnerAndOperator {
735         minterConfig.maxTotalSupply = supply;
736     }
737 
738     // set parameter for public mint 
739     function setPublicMintDetail(uint256 price, uint256 amount) external onlyOwnerAndOperator {
740         require(!minterConfig.isPublicMintActive, "Public mint is active");
741         minterConfig.publicMintPrice = price;
742         minterConfig.maxPublicMintAmount = amount;        
743     }
744 
745     // set parameter for private mint
746     function setPrivateMintDetail(uint256 price, uint256 amount, uint256 supply) external onlyOwnerAndOperator {
747         require(!minterConfig.isPrivateMintActive, "Private mint is active");
748         minterConfig.privateMintPrice = price;
749         minterConfig.maxPrivateMintAmount = amount;
750         minterConfig.maxPrivateMintSupply = supply;
751     }
752 
753     // set parameter for voucher/private mint
754     function setVoucherDetail(bytes32 merkleRoot, uint256 proofLength, uint256 voucherAmount) external onlyOwnerAndOperator {
755         _merkleRoot = merkleRoot;
756         _proofLength = proofLength;
757         totalVoucherIssued = voucherAmount;
758     }
759 
760     function publicMint(uint256 amount) public payable {
761         require(minterConfig.isPublicMintActive,"Public mint is closed");
762         require(amount > 0,"Amount is zero");
763         require(amount <= minterConfig.maxPublicMintAmount,"Amount is greater than maximum");        
764         require(totalProjectMint + totalPublicSold + totalPrivateSold + totalVoucherIssued + amount <= minterConfig.maxTotalSupply,"Exceed maxTotalSupply");
765         require(minterConfig.publicMintPrice * amount <= msg.value, "Insufficient fund");
766         
767         address to = _msgSender();
768 
769         _mintTo(to, amount);        
770         totalPublicSold += amount;        
771         emit PublicMint(to, amount, msg.value);
772     }
773 
774     function privateMint( uint256 amount,    
775                           uint256 whitelistedId, uint256 whitelistedAmount, bytes32[] calldata proof ) public payable {
776 
777         require(minterConfig.isPrivateMintActive,"Private mint is closed");
778 
779         address to = _msgSender();
780         bytes32 hash = keccak256(abi.encodePacked(whitelistedId, address(this), 'W',  to, whitelistedAmount));
781         require(proof.length == _proofLength,"Invalid whitelisted detail");
782         require(MerkleProof.verify(proof, _merkleRoot, hash),"Invalid whitelisted detail");
783         require(_amountUsed[whitelistedId] == 0, "Whielisted has been used");                
784         if (whitelistedAmount == 0) {            
785             require(amount <= minterConfig.maxPrivateMintAmount,"Amount is greater than maximum");                            
786         } else {
787             require(amount <= whitelistedAmount,"Amount is greater than maximum");                            
788         }
789         require(amount > 0,"Amount is zero");
790         require(totalPrivateSold + amount <= minterConfig.maxPrivateMintSupply,"Exceed maxPrivateMintSupply");
791         require(minterConfig.privateMintPrice * amount <= msg.value, "Insufficient fund");
792 
793         _mintTo(to, amount);                
794 
795         _amountUsed[whitelistedId] = amount;
796         totalPrivateSold += amount;  
797         emit PrivateMint(to, whitelistedId, amount, msg.value);   
798     }
799 
800     function voucherMint( uint256 amount,
801                           uint256 voucherId, uint256 voucherAmount, uint256 voucherPrice, bytes32[] calldata proof) public payable {
802 
803         require(minterConfig.isVoucherMintActive,"Voucher mint is closed");
804 
805         address to = _msgSender();
806         bytes32 hash = keccak256(abi.encodePacked(voucherId, address(this), 'V',  to, voucherAmount, voucherPrice));        
807         require(proof.length == _proofLength,"Invalid whitelisted detail");
808         require(MerkleProof.verify(proof, _merkleRoot, hash),"Invalid voucher detail");        
809         require(_amountUsed[voucherId] + amount <= voucherAmount,"Ammount is greater than voucher");                                
810         require(amount > 0,"Amount is zero");        
811         require(voucherPrice * amount <= msg.value, "Insufficient fund");        
812 
813         _mintTo(to, amount);        
814 
815         _amountUsed[voucherId] += amount;        
816         totalVoucherClaimed += amount;        
817         emit VoucherMint(to, voucherId, amount, msg.value);       
818     }
819 
820     function _projectMint(address to, uint256 amount, string memory reason) internal {
821         _mintTo(to, amount);
822         totalProjectMint += amount;
823         emit ProjectMint(to, amount, reason);
824     }    
825 
826     function getAmountUsed(uint256 voucherId) external view returns (uint256) {
827         return _amountUsed[voucherId];
828     }
829 
830     //////////////////////////////////////////////////////////////////////////////////////
831     // Function to withdraw fund from contract
832     /////
833     function withdraw() external onlyOwner {        
834         uint256 _balance = address(this).balance;        
835         Address.sendValue(payable(beneficiary), _balance);
836     }    
837 
838     function withdraw(uint256 balance) external onlyOwner {                    
839         Address.sendValue(payable(beneficiary), balance);
840     }    
841 
842     function transferERC20(IERC20 token) external onlyOwner {        
843         uint256 balance = token.balanceOf(address(this));
844         token.transfer(beneficiary, balance);        
845     }        
846 
847     function transferERC20(IERC20 token, uint256 amount) external onlyOwner {        
848         token.transfer(beneficiary, amount);        
849     }        
850 
851     function donate() external payable {
852         // thank you
853     }
854 
855     // set Operator
856     function setOperator(address operator) public onlyOwner {
857         require(operator != address(0), "Not the zero address");
858         _operator = operator;
859     }
860 
861     function minterStatus() public view returns (
862         bool isPublicMintActive_,
863         bool isPrivateMintActive_,
864         bool isVoucherMintActive_,      
865         uint256 publicMintPrice_,      
866         uint256 privateMintPrice_,
867         uint256 maxPublicMintAmount_,
868         uint256 maxPrivateMintAmount_,
869         uint256 maxTotalSupply_,  
870         uint256 maxPrivateMintSupply_,
871         uint256 totalPublicSold_,
872         uint256 totalPrivateSold_,
873         uint256 totalVoucherClaimed_,
874         uint256 totalVoucherIssued_,
875         uint256 totalProjectMint_
876     )
877     {
878         isPublicMintActive_   = minterConfig.isPublicMintActive;
879         isPrivateMintActive_  = minterConfig.isPrivateMintActive;
880         isVoucherMintActive_  = minterConfig.isVoucherMintActive;
881         publicMintPrice_      = minterConfig.publicMintPrice;
882         privateMintPrice_     = minterConfig.privateMintPrice;
883         maxPublicMintAmount_  = minterConfig.maxPublicMintAmount;
884         maxPrivateMintAmount_ = minterConfig.maxPrivateMintAmount;
885         maxTotalSupply_       = minterConfig.maxTotalSupply;
886         maxPrivateMintSupply_ = minterConfig.maxPrivateMintSupply;
887         totalPublicSold_      = totalPublicSold;
888         totalPrivateSold_     = totalPrivateSold;
889         totalVoucherClaimed_  = totalVoucherClaimed;
890         totalVoucherIssued_   = totalVoucherIssued;
891         totalProjectMint_     = totalProjectMint;
892     }
893 
894     /**
895      * @dev Throws if called by any account other than the operator.
896      */
897     modifier onlyOwnerAndOperator() {
898         require( _msgSender() == owner() || _msgSender() == _operator, "Caller is not the operator");
899         _;
900     }
901 
902 }
903 
904 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
905 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
906 /**
907  * @dev Required interface of an ERC721 compliant contract.
908  */
909 interface IERC721 is IERC165 {
910     /**
911      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
912      */
913     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
914 
915     /**
916      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
917      */
918     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
919 
920     /**
921      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
922      */
923     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
924 
925     /**
926      * @dev Returns the number of tokens in ``owner``'s account.
927      */
928     function balanceOf(address owner) external view returns (uint256 balance);
929 
930     /**
931      * @dev Returns the owner of the `tokenId` token.
932      *
933      * Requirements:
934      *
935      * - `tokenId` must exist.
936      */
937     function ownerOf(uint256 tokenId) external view returns (address owner);
938 
939     /**
940      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
941      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
942      *
943      * Requirements:
944      *
945      * - `from` cannot be the zero address.
946      * - `to` cannot be the zero address.
947      * - `tokenId` token must exist and be owned by `from`.
948      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
949      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
950      *
951      * Emits a {Transfer} event.
952      */
953     function safeTransferFrom(
954         address from,
955         address to,
956         uint256 tokenId
957     ) external;
958 
959     /**
960      * @dev Transfers `tokenId` token from `from` to `to`.
961      *
962      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
963      *
964      * Requirements:
965      *
966      * - `from` cannot be the zero address.
967      * - `to` cannot be the zero address.
968      * - `tokenId` token must be owned by `from`.
969      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
970      *
971      * Emits a {Transfer} event.
972      */
973     function transferFrom(
974         address from,
975         address to,
976         uint256 tokenId
977     ) external;
978 
979     /**
980      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
981      * The approval is cleared when the token is transferred.
982      *
983      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
984      *
985      * Requirements:
986      *
987      * - The caller must own the token or be an approved operator.
988      * - `tokenId` must exist.
989      *
990      * Emits an {Approval} event.
991      */
992     function approve(address to, uint256 tokenId) external;
993 
994     /**
995      * @dev Returns the account approved for `tokenId` token.
996      *
997      * Requirements:
998      *
999      * - `tokenId` must exist.
1000      */
1001     function getApproved(uint256 tokenId) external view returns (address operator);
1002 
1003     /**
1004      * @dev Approve or remove `operator` as an operator for the caller.
1005      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1006      *
1007      * Requirements:
1008      *
1009      * - The `operator` cannot be the caller.
1010      *
1011      * Emits an {ApprovalForAll} event.
1012      */
1013     function setApprovalForAll(address operator, bool _approved) external;
1014 
1015     /**
1016      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1017      *
1018      * See {setApprovalForAll}
1019      */
1020     function isApprovedForAll(address owner, address operator) external view returns (bool);
1021 
1022     /**
1023      * @dev Safely transfers `tokenId` token from `from` to `to`.
1024      *
1025      * Requirements:
1026      *
1027      * - `from` cannot be the zero address.
1028      * - `to` cannot be the zero address.
1029      * - `tokenId` token must exist and be owned by `from`.
1030      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1031      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1032      *
1033      * Emits a {Transfer} event.
1034      */
1035     function safeTransferFrom(
1036         address from,
1037         address to,
1038         uint256 tokenId,
1039         bytes calldata data
1040     ) external;
1041 }
1042 
1043 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1044 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
1045 
1046 /**
1047  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1048  * @dev See https://eips.ethereum.org/EIPS/eip-721
1049  */
1050 interface IERC721Enumerable is IERC721 {
1051     /**
1052      * @dev Returns the total amount of tokens stored by the contract.
1053      */
1054     function totalSupply() external view returns (uint256);
1055 
1056     /**
1057      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1058      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1059      */
1060     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1061 
1062     /**
1063      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1064      * Use along with {totalSupply} to enumerate all tokens.
1065      */
1066     function tokenByIndex(uint256 index) external view returns (uint256);
1067 }
1068 
1069 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1070 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1071 /**
1072  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1073  * @dev See https://eips.ethereum.org/EIPS/eip-721
1074  */
1075 interface IERC721Metadata is IERC721 {
1076     /**
1077      * @dev Returns the token collection name.
1078      */
1079     function name() external view returns (string memory);
1080 
1081     /**
1082      * @dev Returns the token collection symbol.
1083      */
1084     function symbol() external view returns (string memory);
1085 
1086     /**
1087      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1088      */
1089     function tokenURI(uint256 tokenId) external view returns (string memory);
1090 }
1091 
1092 // File: @openzeppelin/contracts/interfaces/IERC165.sol
1093 
1094 
1095 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC165.sol)
1096 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
1097 
1098 
1099 // OpenZeppelin Contracts (last updated v4.5.0) (interfaces/IERC2981.sol)
1100 /**
1101  * @dev Interface for the NFT Royalty Standard.
1102  *
1103  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
1104  * support for royalty payments across all NFT marketplaces and ecosystem participants.
1105  *
1106  * _Available since v4.5._
1107  */
1108 interface IERC2981 is IERC165 {
1109     /**
1110      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
1111      * exchange. The royalty amount is denominated and should be payed in that same unit of exchange.
1112      */
1113     function royaltyInfo(uint256 tokenId, uint256 salePrice)
1114         external
1115         view
1116         returns (address receiver, uint256 royaltyAmount);
1117 }
1118 
1119 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
1120 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1121 
1122 /**
1123  * @dev Implementation of the {IERC165} interface.
1124  *
1125  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1126  * for the additional interface id that will be supported. For example:
1127  *
1128  * ```solidity
1129  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1130  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1131  * }
1132  * ```
1133  *
1134  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1135  */
1136 abstract contract ERC165 is IERC165 {
1137     /**
1138      * @dev See {IERC165-supportsInterface}.
1139      */
1140     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1141         return interfaceId == type(IERC165).interfaceId;
1142     }
1143 }
1144 
1145 // File: contracts/ERC721S.sol
1146 
1147 /**
1148  * A modification of openzeppelin ERC721 for a small, sequential mint, non-burnable collection
1149  * that implement IERC721, IERC721Metadata, and IERCEnumberable.
1150  * The assumption for this contract are:
1151  *  - Token will be mint in sequential order
1152  *  - The total number of token can be pack in 2**32-1
1153  */
1154 
1155 contract ERC721S is Context, ERC165, IERC721, IERC721Metadata {
1156 
1157     using Address for address;
1158     using Strings for uint256;
1159 
1160     // Compiler will pack this into a single 256bit word.
1161     struct TokenDetail {
1162         // The address of the owner.
1163         address owner;              
1164         // Mapping from TokenID to index in _allToken list
1165         uint32  allTokensIndex;     
1166         // Mapping from TokenID to index in _ownedTokens list
1167         uint32  ownedTokensIndex;   
1168         // Reserved for other used;
1169         uint32  reserved;    
1170     }
1171     
1172     // Token name
1173     string private _name;
1174 
1175     // Token symbol
1176     string private _symbol;
1177 
1178     // Mapping from token ID to token Detail 
1179     mapping(uint256 => TokenDetail) private _tokenDetail;
1180 
1181     // Mapping from token ID to approved address
1182     mapping(uint256 => address) private _tokenApprovals;
1183 
1184     // Mapping from owner to operator approvals
1185     mapping(address => mapping(address => bool)) private _operatorApprovals;
1186 
1187     // Mapping from owner to list of owned token IDs
1188     mapping(address => uint32[]) private _ownedTokens;
1189 
1190     // Array with all token ids, used for enumeration
1191     uint32[] private _allTokens;
1192 
1193     // Id of the fist token minted
1194     uint32 private _currentIndex;
1195 
1196     /**
1197      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1198      */
1199     constructor(string memory name_, string memory symbol_) {
1200         _name = name_;
1201         _symbol = symbol_;
1202         _currentIndex = _startTokenId();
1203     }
1204 
1205     /**
1206      * To change the starting tokenId, please override this function.
1207      */
1208     function _startTokenId() internal view virtual returns (uint32) {
1209         return 1;
1210     }
1211 
1212     /**
1213      * Returns the total amount of tokens minted in the contract.
1214      */
1215     function _totalMinted() internal view returns (uint256) {
1216         // Counter underflow is impossible as _currentIndex does not decrement,
1217         // and it is initialized to _startTokenId()
1218         unchecked {
1219             return _currentIndex - _startTokenId();
1220         }
1221     }
1222 
1223     /**
1224      * Returns the total amount of tokens burned in the contract.
1225      */
1226     function _totalBurned() internal view returns (uint256) {
1227         unchecked {
1228             return _totalMinted() - _allTokens.length;
1229         }
1230     }
1231 
1232     /**
1233      * @dev See {IERC165-supportsInterface}.
1234      */
1235     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1236         return
1237             interfaceId == type(IERC721).interfaceId ||
1238             interfaceId == type(IERC721Metadata).interfaceId ||
1239             interfaceId == type(IERC721Enumerable).interfaceId || 
1240             super.supportsInterface(interfaceId);
1241     }
1242 
1243     /**
1244      * @dev See {IERC721-balanceOf}.
1245      */
1246     function balanceOf(address owner) public view virtual override returns (uint256) {
1247         require(owner != address(0), "ERC721: balance query for the zero address");
1248         return _ownedTokens[owner].length;
1249     }
1250 
1251     /**
1252      * @dev See {IERC721-ownerOf}.
1253      */
1254     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1255         address owner = _tokenDetail[tokenId].owner;
1256         require(owner != address(0), "ERC721: owner query for nonexistent token");
1257         return owner;
1258     }
1259 
1260     /**
1261      * @dev See {IERC721Metadata-name}.
1262      */
1263     function name() public view virtual override returns (string memory) {
1264         return _name;
1265     }
1266 
1267     /**
1268      * @dev See {IERC721Metadata-symbol}.
1269      */
1270     function symbol() public view virtual override returns (string memory) {
1271         return _symbol;
1272     }
1273 
1274     /**
1275      * @dev See {IERC721Metadata-tokenURI}.
1276      */
1277     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1278         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1279         string memory baseURI = _baseURI();
1280         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1281     }
1282 
1283     /**
1284      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1285      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1286      * by default, can be overridden in child contracts.
1287      */
1288     function _baseURI() internal view virtual returns (string memory) {
1289         return "";
1290     }
1291 
1292     /**
1293      * @dev See {IERC721-approve}.
1294      */
1295     function approve(address to, uint256 tokenId) public virtual override {
1296         address owner = ERC721S.ownerOf(tokenId);
1297         require(to != owner, "ERC721: approval to current owner");
1298         require(
1299             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1300             "ERC721: approve caller is not owner nor approved for all"
1301         );
1302         _approve(to, tokenId);
1303     }
1304 
1305     /**
1306      * @dev See {IERC721-getApproved}.
1307      */
1308     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1309         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1310         return _tokenApprovals[tokenId];
1311     }
1312 
1313     /**
1314      * @dev See {IERC721-setApprovalForAll}.
1315      */
1316     function setApprovalForAll(address operator, bool approved) public virtual override {
1317         _setApprovalForAll(_msgSender(), operator, approved);
1318     }
1319 
1320     /**
1321      * @dev See {IERC721-isApprovedForAll}.
1322      */
1323     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1324         return _operatorApprovals[owner][operator];
1325     }
1326 
1327     /**
1328      * @dev See {IERC721-transferFrom}.
1329      */
1330     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1331         //solhint-disable-next-line max-line-length
1332         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1333         _transfer(from, to, tokenId);
1334     }
1335 
1336     /**
1337      * @dev See {IERC721-safeTransferFrom}.
1338      */
1339     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1340         safeTransferFrom(from, to, tokenId, "");
1341     }
1342 
1343     /**
1344      * @dev See {IERC721-safeTransferFrom}.
1345      */
1346     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1347         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1348         _safeTransfer(from, to, tokenId, _data);
1349     }
1350 
1351     /**
1352      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1353      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1354      *
1355      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1356      *
1357      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1358      * implement alternative mechanisms to perform token transfer, such as signature-based.
1359      *
1360      * Requirements:
1361      *
1362      * - `from` cannot be the zero address.
1363      * - `to` cannot be the zero address.
1364      * - `tokenId` token must exist and be owned by `from`.
1365      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1366      *
1367      * Emits a {Transfer} event.
1368      */
1369     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1370         _transfer(from, to, tokenId);
1371         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1372     }
1373 
1374     /**
1375      * @dev Returns whether `tokenId` exists.
1376      *
1377      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1378      *
1379      * Tokens start existing when they are minted (`_mint`),
1380      * and stop existing when they are burned (`_burn`).
1381      */
1382     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1383         return _tokenDetail[tokenId].owner != address(0);
1384     }
1385 
1386     /**
1387      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1388      *
1389      * Requirements:
1390      *
1391      * - `tokenId` must exist.
1392      */
1393     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1394         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1395         address owner = ERC721S.ownerOf(tokenId);
1396         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1397     }
1398 
1399     /**
1400      * @dev Safely mints new token and transfers it to `to`.
1401      *
1402      * Requirements:
1403      *
1404      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1405      *
1406      * Emits a {Transfer} event.
1407      */
1408     function _safeMint(address to) internal virtual {
1409         _safeMint(to, "");
1410     }
1411 
1412     /**
1413      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1414      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1415      */
1416     function _safeMint(address to, bytes memory _data) internal virtual {
1417         uint256 tokenId = uint256(_currentIndex);
1418         _mint(to);
1419         require(
1420             _checkOnERC721Received(address(0), to, tokenId, _data),
1421             "ERC721: transfer to non ERC721Receiver implementer"
1422         );
1423     }
1424 
1425     /**
1426      * @dev Mints `tokenId` and transfers it to `to`.
1427      *
1428      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1429      *
1430      * Requirements:
1431      *
1432      * - `tokenId` must not exist.
1433      * - `to` cannot be the zero address.
1434      *
1435      * Emits a {Transfer} event.
1436      */
1437     function _mint(address to) internal virtual {
1438         require(to != address(0), "ERC721: mint to the zero address");
1439         
1440         uint32 tokenId = _currentIndex;
1441 
1442         _beforeTokenTransfer(address(0), to, tokenId);
1443 
1444         uint32[] storage toTokenList = _ownedTokens[to];
1445         TokenDetail storage tokenDetail = _tokenDetail[tokenId];
1446 
1447         tokenDetail.owner = to;        
1448         tokenDetail.ownedTokensIndex = uint32(toTokenList.length);
1449         tokenDetail.allTokensIndex = uint32(_allTokens.length);
1450 
1451         toTokenList.push(tokenId);
1452         _allTokens.push(tokenId);        
1453         
1454         _currentIndex += 1;
1455 
1456         emit Transfer(address(0), to, tokenId);
1457 
1458         _afterTokenTransfer(address(0), to, tokenId);
1459     }
1460 
1461     /**
1462      * @dev Destroys `tokenId`.
1463      * The approval is cleared when the token is burned.
1464      *
1465      * Requirements:
1466      *
1467      * - `tokenId` must exist.
1468      *
1469      * Emits a {Transfer} event.
1470      */
1471     function _burn(uint256 tokenId) internal virtual {
1472         address owner = ERC721S.ownerOf(tokenId);
1473 
1474         _beforeTokenTransfer(owner, address(0), tokenId);
1475 
1476         // Clear approvals
1477         _approve(address(0), tokenId);
1478 
1479         TokenDetail storage tokenDetail = _tokenDetail[tokenId];
1480         uint32[] storage fromTokenList = _ownedTokens[owner];
1481         
1482         // _removeTokenFromOwnerEnumeration(owner, tokenId);        
1483         uint32 tokenIndex = tokenDetail.ownedTokensIndex;
1484         uint32 lastToken = fromTokenList[fromTokenList.length - 1];
1485         if (lastToken != uint32(tokenId)) {
1486             fromTokenList[tokenIndex] = lastToken;
1487             _tokenDetail[lastToken].ownedTokensIndex = tokenIndex;
1488         }
1489         fromTokenList.pop();
1490         
1491         // _removeTokenFromALLTokensEnumeration
1492         uint32 lastAllToken = _allTokens[_allTokens.length - 1];
1493         uint32 allTokenIndex = tokenDetail.allTokensIndex;
1494         _allTokens[allTokenIndex] = lastAllToken;
1495 
1496         tokenDetail.owner  = address(0);       
1497         tokenDetail.allTokensIndex = 0;
1498         tokenDetail.ownedTokensIndex = 0;
1499         
1500         _allTokens.pop();
1501         
1502         emit Transfer(owner, address(0), tokenId);
1503 
1504         _afterTokenTransfer(owner, address(0), tokenId);
1505     }
1506 
1507     /**
1508      * @dev Transfers `tokenId` from `from` to `to`.
1509      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1510      *
1511      * Requirements:
1512      *
1513      * - `to` cannot be the zero address.
1514      * - `tokenId` token must be owned by `from`.
1515      *
1516      * Emits a {Transfer} event.
1517      */
1518     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1519         require(ERC721S.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1520         require(to != address(0), "ERC721: transfer to the zero address");
1521 
1522         _beforeTokenTransfer(from, to, tokenId);
1523 
1524         // Clear approvals from the previous owner
1525         _approve(address(0), tokenId);
1526 
1527         _tokenDetail[tokenId].owner = to;
1528     
1529         // _removeTokenFromOwnerEnumeration(from, tokenId);        
1530         uint32[] storage fromTokenList = _ownedTokens[from];
1531         TokenDetail storage tokenDetail = _tokenDetail[tokenId];
1532         uint32 tokenIndex = tokenDetail.ownedTokensIndex;
1533         uint32 lastToken = fromTokenList[fromTokenList.length - 1];
1534         fromTokenList[tokenIndex] = lastToken;
1535         _tokenDetail[lastToken].ownedTokensIndex = tokenIndex;
1536         fromTokenList.pop();
1537 
1538         // _addTokenToOwnerEnumeration(to, tokenId);
1539         uint32[] storage toTokenList = _ownedTokens[to];
1540         tokenDetail.ownedTokensIndex = uint32(toTokenList.length);
1541         toTokenList.push(uint32(tokenId));
1542         
1543         emit Transfer(from, to, tokenId);
1544 
1545         _afterTokenTransfer(from, to, tokenId);
1546     }
1547 
1548     /**
1549      * @dev Approve `to` to operate on `tokenId`
1550      *
1551      * Emits a {Approval} event.
1552      */
1553     function _approve(address to, uint256 tokenId) internal virtual {
1554         _tokenApprovals[tokenId] = to;
1555         emit Approval(ERC721S.ownerOf(tokenId), to, tokenId);
1556     }
1557 
1558     /**
1559      * @dev Approve `operator` to operate on all of `owner` tokens
1560      *
1561      * Emits a {ApprovalForAll} event.
1562      */
1563     function _setApprovalForAll(address owner, address operator, bool approved) internal virtual {
1564         require(owner != operator, "ERC721: approve to caller");
1565         _operatorApprovals[owner][operator] = approved;
1566         emit ApprovalForAll(owner, operator, approved);
1567     }
1568 
1569     /**
1570      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1571      * The call is not executed if the target address is not a contract.
1572      *
1573      * @param from address representing the previous owner of the given token ID
1574      * @param to target address that will receive the tokens
1575      * @param tokenId uint256 ID of the token to be transferred
1576      * @param _data bytes optional data to send along with the call
1577      * @return bool whether the call correctly returned the expected magic value
1578      */
1579     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data) private returns (bool) {
1580         if (to.isContract()) {
1581             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1582                 return retval == IERC721Receiver.onERC721Received.selector;
1583             } catch (bytes memory reason) {
1584                 if (reason.length == 0) {
1585                     revert("ERC721: transfer to non ERC721Receiver implementer");
1586                 } else {
1587                     assembly {
1588                         revert(add(32, reason), mload(reason))
1589                     }
1590                 }
1591             }
1592         } else {
1593             return true;
1594         }
1595     }
1596 
1597    /**
1598      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1599      */
1600     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual returns (uint256) {
1601         require(index < ERC721S.balanceOf(owner), "Owner index out of bounds");
1602         return uint256(_ownedTokens[owner][index]);
1603     }
1604 
1605     function ownedBy(address owner) external view returns (uint256[] memory) {        
1606         uint256 balance = balanceOf(owner);
1607         uint256[] memory tokens = new uint256[](balance);
1608         uint32[] storage ownedTokens = _ownedTokens[owner];
1609 
1610         for (uint256 i; i < balance; i++) {
1611             tokens[i] = uint256(ownedTokens[i]);
1612         }
1613                
1614         return tokens;
1615     }
1616 
1617 
1618     /**
1619      * @dev See {IERC721Enumerable-totalSupply}.
1620      */
1621     function totalSupply() public view virtual  returns (uint256) {
1622         return _allTokens.length;
1623     }
1624 
1625     /**
1626      * @dev See {IERC721Enumerable-tokenByIndex}.
1627      */
1628     function tokenByIndex(uint256 index) public view virtual  returns (uint256) {
1629         require(index < ERC721S.totalSupply(), "Global index out of bounds");
1630         return uint256(_allTokens[index]);
1631     }    
1632 
1633     /**
1634      * @dev Hook that is called after any transfer of tokens. This includes
1635      * minting and burning.
1636      *
1637      * Calling conditions:
1638      *
1639      * - when `from` and `to` are both non-zero.
1640      * - `from` and `to` are never both zero.
1641      *
1642      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1643      */
1644     function _afterTokenTransfer(address from, address to, uint256 tokenId) internal virtual {}
1645 
1646 
1647     /**
1648      * @dev Hook that is called before any token transfer. This includes minting
1649      * and burning.
1650      *
1651      * Calling conditions:
1652      *
1653      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1654      * transferred to `to`.
1655      * - When `from` is zero, `tokenId` will be minted for `to`.
1656      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1657      * - `from` and `to` are never both zero.
1658      *
1659      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1660      */
1661     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual {}
1662 
1663 }
1664 // File: @openzeppelin/contracts/token/common/ERC2981.sol
1665 // OpenZeppelin Contracts (last updated v4.5.0) (token/common/ERC2981.sol)
1666 
1667 
1668 /**
1669  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
1670  *
1671  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
1672  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
1673  *
1674  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
1675  * fee is specified in basis points by default.
1676  *
1677  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
1678  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
1679  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
1680  *
1681  * _Available since v4.5._
1682  */
1683 abstract contract ERC2981 is IERC2981, ERC165 {
1684     struct RoyaltyInfo {
1685         address receiver;
1686         uint96 royaltyFraction;
1687     }
1688 
1689     RoyaltyInfo private _defaultRoyaltyInfo;
1690     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
1691 
1692     /**
1693      * @dev See {IERC165-supportsInterface}.
1694      */
1695     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
1696         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
1697     }
1698 
1699     /**
1700      * @inheritdoc IERC2981
1701      */
1702     function royaltyInfo(uint256 _tokenId, uint256 _salePrice)
1703         external
1704         view
1705         virtual
1706         override
1707         returns (address, uint256)
1708     {
1709         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
1710 
1711         if (royalty.receiver == address(0)) {
1712             royalty = _defaultRoyaltyInfo;
1713         }
1714 
1715         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
1716 
1717         return (royalty.receiver, royaltyAmount);
1718     }
1719 
1720     /**
1721      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
1722      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
1723      * override.
1724      */
1725     function _feeDenominator() internal pure virtual returns (uint96) {
1726         return 10000;
1727     }
1728 
1729     /**
1730      * @dev Sets the royalty information that all ids in this contract will default to.
1731      *
1732      * Requirements:
1733      *
1734      * - `receiver` cannot be the zero address.
1735      * - `feeNumerator` cannot be greater than the fee denominator.
1736      */
1737     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
1738         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
1739         require(receiver != address(0), "ERC2981: invalid receiver");
1740 
1741         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
1742     }
1743 
1744     /**
1745      * @dev Removes default royalty information.
1746      */
1747     function _deleteDefaultRoyalty() internal virtual {
1748         delete _defaultRoyaltyInfo;
1749     }
1750 
1751     /**
1752      * @dev Sets the royalty information for a specific token id, overriding the global default.
1753      *
1754      * Requirements:
1755      *
1756      * - `tokenId` must be already minted.
1757      * - `receiver` cannot be the zero address.
1758      * - `feeNumerator` cannot be greater than the fee denominator.
1759      */
1760     function _setTokenRoyalty(
1761         uint256 tokenId,
1762         address receiver,
1763         uint96 feeNumerator
1764     ) internal virtual {
1765         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
1766         require(receiver != address(0), "ERC2981: Invalid parameters");
1767 
1768         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
1769     }
1770 
1771     /**
1772      * @dev Resets royalty information for the token id back to the global default.
1773      */
1774     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
1775         delete _tokenRoyaltyInfo[tokenId];
1776     }
1777 }
1778 
1779 // File: contracts/JCCGenesis.sol
1780 
1781 interface ITokenURI {
1782     function tokenURI(uint256 tokenId) external view returns (string memory);
1783 }
1784 
1785 interface IIsTokenLocked {
1786     function isTokenLocked(uint256 tokenId) external view returns (bool);
1787 }
1788 
1789 contract JCCGenesis is
1790     ERC721S,
1791     PublicPrivateVoucherMinter,
1792     ERC2981,
1793     Pausable
1794 {    
1795     using Strings for uint256;
1796 
1797     // Constants    
1798     bytes4 constant tokenURIInterface = bytes4(keccak256("tokenURI(uint256)"));
1799     bytes4 constant isTokenLockedInterface = bytes4(keccak256("isTokenLocked(uint256)"));
1800 
1801     // Variable
1802     uint256 public maxSupply = 555;
1803     
1804     string public baseURI;
1805     string public notRevealedURI = "https://assets.jokercharlie.com/jccgenesis/default.json";        
1806     string public baseExtension  = ".json";
1807 
1808     bool public revealed;    
1809 
1810     address public metadataContract;
1811     address public lockerContract;
1812     
1813     constructor (address payable beneficiary, address payable royaltyReceiver)
1814         ERC721S("Joker Charlie Club Genesis", "JCCGENESIS")            
1815         PublicPrivateVoucherMinter(
1816             PublicPrivateVoucherMinter.MinterConfig({
1817                 isPublicMintActive : false,      // can call publicMint only when isPublicMintActive is true
1818                 isPrivateMintActive: false,      // can call privateMint only when isPrivateMintActive is true
1819                 isVoucherMintActive: false,      // can call voucherMint only when isVoucherMintActive is true
1820                 publicMintPrice: 0.555 ether,    // price for publicMint
1821                 privateMintPrice: 0.555 ether,   // price for privateMint
1822                 maxPublicMintAmount:  2,         // maximum amount per publicMint transaction
1823                 maxPrivateMintAmount: 1,         // default maximum amount per privateMint transaction    
1824                 maxTotalSupply: 555,             // maximum supply 
1825                 maxPrivateMintSupply: 300        // maximum supply for previate mint
1826             }),
1827             beneficiary
1828         )
1829     {
1830         require(beneficiary != address(0), "Not the zero address");
1831         require(royaltyReceiver != address(0), "Not the zero address");
1832 
1833         // setting initial royalty fee
1834         _setDefaultRoyalty(royaltyReceiver, 1000);            
1835     }
1836 
1837     /* This function will be used to mint the NFT to team-member, advisory, treasury and giveaway purpose.
1838         These NFTs will be firstly mint to a segregated wallet for each corresponding purpose.
1839         After that it will be transfer to the final destination from each segregated wallet.           
1840     */
1841     function projectMint() external onlyOwner {
1842         require(totalProjectMint == 0, "Already mint");
1843         _projectMint(0xeeb50494D097d68D95C333aA1D038189D2BaE6bB,  33, "for team member"); // TokenId  1 to  33
1844         _projectMint(0x19d03a5E56240507934af26b194d38F76144815D,  30, "for advisor");     // TokenId 34 to  63
1845         _projectMint(0x52FF836e109fB4Df3931Ee367a25f04EdDE92A89,  17, "for giveaway");    // TokenId 64 to  80
1846         _projectMint(0x6dd041217aE648AE13b5DF1F60b1DE886FdFBEbf, 100, "for treasury");    // ToeknId 81 to 180
1847     }
1848 
1849     function setRoyaltyInfo(address receiver, uint96 feeBasisPoints) 
1850         external
1851         onlyOwner
1852     {
1853         require(receiver != address(0), "Not the zero address");
1854         _setDefaultRoyalty(receiver, feeBasisPoints);
1855     }
1856 
1857     function reveal() 
1858         external
1859         onlyOwner
1860     {
1861         revealed = true;
1862     }
1863 
1864     function pause() external onlyOwner {
1865         _pause();
1866     }
1867 
1868     function unpause() external onlyOwner {
1869         _unpause();
1870     }    
1871 
1872     function _mintTo(address to, uint256 amount) internal override
1873     {        
1874         // require(!paused(), "Mint is paused"); // Already checks in _beforeTokenTransfer
1875         require(totalSupply() + amount <= maxSupply, "Max supply limit exceed");
1876         for (uint256 i; i < amount; i++) {
1877             _safeMint(to);
1878         }
1879     }
1880 
1881     function supportsInterface(bytes4 interfaceId)
1882         public
1883         view
1884         override(ERC721S, ERC2981)
1885         returns (bool)
1886     {
1887         return ERC721S.supportsInterface(interfaceId) ||
1888             ERC2981.supportsInterface(interfaceId);
1889     }
1890 
1891 
1892     // TokenURI related functions    
1893 
1894     function setBaseTokenURI(string calldata uri)
1895         external
1896         onlyOwner
1897     {
1898         baseURI = uri;
1899     }
1900 
1901     function setNotRevealedURI(string calldata uri) 
1902         external
1903         onlyOwner
1904     {
1905         notRevealedURI = uri;
1906     }
1907 
1908     function setMetadataContract(address metadata) 
1909         external 
1910         onlyOwner 
1911     {
1912         if (metadata != address(0)) {
1913             require(ERC165(metadata).supportsInterface(tokenURIInterface), "tokenURI(uint256) not supported");                
1914         }
1915         metadataContract = metadata;
1916     }
1917 
1918     function _baseURI() internal view virtual override returns (string memory) {
1919         return baseURI;
1920     }
1921 
1922     function baseTokenURI(uint256 tokenId) public view returns (string memory) {
1923         string memory currentBaseURI = _baseURI();
1924         return bytes(currentBaseURI).length > 0
1925             ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1926             : "";
1927     }
1928 
1929     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1930         require(_exists(tokenId),"ERC721Metadata: URI query for nonexistent token");
1931         if (revealed == false) {
1932             return notRevealedURI;
1933         } else if (metadataContract != address(0)) {            
1934             return ITokenURI(metadataContract).tokenURI(tokenId);
1935         } else {
1936             return baseTokenURI(tokenId);
1937         }
1938     }
1939 
1940     // Locker relatd functions
1941     function setLockerContract(address locker) 
1942         external
1943         onlyOwner
1944     {
1945         if (locker != address(0)) {
1946             require(ERC165(locker).supportsInterface(isTokenLockedInterface), "isTokenLocked(uint256) not supported");                
1947         }
1948         lockerContract = locker;
1949     }
1950 
1951     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
1952         require(!paused(), "Contract is paused");
1953         if (lockerContract != address(0)) {
1954             require(!IIsTokenLocked(lockerContract).isTokenLocked(tokenId),"Token is locked");
1955         }
1956         super._beforeTokenTransfer(from, to, tokenId);        
1957     }
1958     
1959     /// @notice Transfers the ownership of multiple NFTs from one address to another address
1960     /// @param _from The current owner of the NFT
1961     /// @param _to The new owner
1962     /// @param _tokenIds The NFTs to transfer          
1963     /// @param _data Additional data with no specified format, sent in call to `_to`  
1964     function safeBatchTransferFrom(address _from, address _to, uint256[] memory _tokenIds, bytes memory _data) external {
1965         for (uint i; i < _tokenIds.length; i++) {
1966             safeTransferFrom(_from, _to, _tokenIds[i], _data);
1967         }
1968     }
1969     
1970     /// @notice Transfers the ownership of multiple NFTs from one address to another address
1971     /// @param _from The current owner of the NFT
1972     /// @param _to The new owner
1973     /// @param _tokenIds The NFTs to transfer  
1974     function safeBatchTransferFrom(address _from, address _to, uint256[] memory _tokenIds) external {
1975         for (uint i; i < _tokenIds.length; i++) {
1976             safeTransferFrom(_from, _to, _tokenIds[i]);
1977         }
1978     }
1979     
1980 }