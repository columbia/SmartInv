1 // File: contracts/AwooModels.sol
2 
3 
4 
5 pragma solidity 0.8.12;
6 
7 struct AccrualDetails{
8     address ContractAddress;
9     uint256[] TokenIds;
10     uint256[] Accruals;
11     uint256 TotalAccrued;
12 }
13 
14 struct ClaimDetails{
15     address ContractAddress;
16     uint32[] TokenIds;
17 }
18 
19 struct SupportedContractDetails{
20     address ContractAddress;
21     uint256 BaseRate;
22     bool Active;
23 }
24 // File: contracts/IAwooClaimingV2.sol
25 
26 
27 
28 pragma solidity 0.8.12;
29 
30 
31 interface IAwooClaimingV2{
32     function overrideTokenAccrualBaseRate(address contractAddress, uint32 tokenId, uint256 newBaseRate) external;
33     function claim(address holder, ClaimDetails[] calldata requestedClaims) external;
34 }
35 // File: @openzeppelin/contracts@4.4.1/token/ERC20/IERC20.sol
36 
37 
38 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
39 
40 pragma solidity ^0.8.0;
41 
42 /**
43  * @dev Interface of the ERC20 standard as defined in the EIP.
44  */
45 interface IERC20 {
46     /**
47      * @dev Returns the amount of tokens in existence.
48      */
49     function totalSupply() external view returns (uint256);
50 
51     /**
52      * @dev Returns the amount of tokens owned by `account`.
53      */
54     function balanceOf(address account) external view returns (uint256);
55 
56     /**
57      * @dev Moves `amount` tokens from the caller's account to `recipient`.
58      *
59      * Returns a boolean value indicating whether the operation succeeded.
60      *
61      * Emits a {Transfer} event.
62      */
63     function transfer(address recipient, uint256 amount) external returns (bool);
64 
65     /**
66      * @dev Returns the remaining number of tokens that `spender` will be
67      * allowed to spend on behalf of `owner` through {transferFrom}. This is
68      * zero by default.
69      *
70      * This value changes when {approve} or {transferFrom} are called.
71      */
72     function allowance(address owner, address spender) external view returns (uint256);
73 
74     /**
75      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
76      *
77      * Returns a boolean value indicating whether the operation succeeded.
78      *
79      * IMPORTANT: Beware that changing an allowance with this method brings the risk
80      * that someone may use both the old and the new allowance by unfortunate
81      * transaction ordering. One possible solution to mitigate this race
82      * condition is to first reduce the spender's allowance to 0 and set the
83      * desired value afterwards:
84      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
85      *
86      * Emits an {Approval} event.
87      */
88     function approve(address spender, uint256 amount) external returns (bool);
89 
90     /**
91      * @dev Moves `amount` tokens from `sender` to `recipient` using the
92      * allowance mechanism. `amount` is then deducted from the caller's
93      * allowance.
94      *
95      * Returns a boolean value indicating whether the operation succeeded.
96      *
97      * Emits a {Transfer} event.
98      */
99     function transferFrom(
100         address sender,
101         address recipient,
102         uint256 amount
103     ) external returns (bool);
104 
105     /**
106      * @dev Emitted when `value` tokens are moved from one account (`from`) to
107      * another (`to`).
108      *
109      * Note that `value` may be zero.
110      */
111     event Transfer(address indexed from, address indexed to, uint256 value);
112 
113     /**
114      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
115      * a call to {approve}. `value` is the new allowance.
116      */
117     event Approval(address indexed owner, address indexed spender, uint256 value);
118 }
119 
120 // File: contracts/IAwooToken.sol
121 
122 
123 
124 pragma solidity 0.8.12;
125 
126 
127 interface IAwooToken is IERC20 {
128     function increaseVirtualBalance(address account, uint256 amount) external;
129     function mint(address account, uint256 amount) external;
130     function balanceOfVirtual(address account) external view returns(uint256);
131     function spendVirtualAwoo(bytes32 hash, bytes memory sig, string calldata nonce, address account, uint256 amount) external;
132 }
133 // File: @openzeppelin/contracts@4.4.1/utils/Strings.sol
134 
135 
136 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
137 
138 pragma solidity ^0.8.0;
139 
140 /**
141  * @dev String operations.
142  */
143 library Strings {
144     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
145 
146     /**
147      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
148      */
149     function toString(uint256 value) internal pure returns (string memory) {
150         // Inspired by OraclizeAPI's implementation - MIT licence
151         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
152 
153         if (value == 0) {
154             return "0";
155         }
156         uint256 temp = value;
157         uint256 digits;
158         while (temp != 0) {
159             digits++;
160             temp /= 10;
161         }
162         bytes memory buffer = new bytes(digits);
163         while (value != 0) {
164             digits -= 1;
165             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
166             value /= 10;
167         }
168         return string(buffer);
169     }
170 
171     /**
172      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
173      */
174     function toHexString(uint256 value) internal pure returns (string memory) {
175         if (value == 0) {
176             return "0x00";
177         }
178         uint256 temp = value;
179         uint256 length = 0;
180         while (temp != 0) {
181             length++;
182             temp >>= 8;
183         }
184         return toHexString(value, length);
185     }
186 
187     /**
188      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
189      */
190     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
191         bytes memory buffer = new bytes(2 * length + 2);
192         buffer[0] = "0";
193         buffer[1] = "x";
194         for (uint256 i = 2 * length + 1; i > 1; --i) {
195             buffer[i] = _HEX_SYMBOLS[value & 0xf];
196             value >>= 4;
197         }
198         require(value == 0, "Strings: hex length insufficient");
199         return string(buffer);
200     }
201 }
202 
203 // File: @openzeppelin/contracts@4.4.1/utils/Context.sol
204 
205 
206 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
207 
208 pragma solidity ^0.8.0;
209 
210 /**
211  * @dev Provides information about the current execution context, including the
212  * sender of the transaction and its data. While these are generally available
213  * via msg.sender and msg.data, they should not be accessed in such a direct
214  * manner, since when dealing with meta-transactions the account sending and
215  * paying for execution may not be the actual sender (as far as an application
216  * is concerned).
217  *
218  * This contract is only required for intermediate, library-like contracts.
219  */
220 abstract contract Context {
221     function _msgSender() internal view virtual returns (address) {
222         return msg.sender;
223     }
224 
225     function _msgData() internal view virtual returns (bytes calldata) {
226         return msg.data;
227     }
228 }
229 
230 // File: @openzeppelin/contracts@4.4.1/access/Ownable.sol
231 
232 
233 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
234 
235 pragma solidity ^0.8.0;
236 
237 
238 /**
239  * @dev Contract module which provides a basic access control mechanism, where
240  * there is an account (an owner) that can be granted exclusive access to
241  * specific functions.
242  *
243  * By default, the owner account will be the one that deploys the contract. This
244  * can later be changed with {transferOwnership}.
245  *
246  * This module is used through inheritance. It will make available the modifier
247  * `onlyOwner`, which can be applied to your functions to restrict their use to
248  * the owner.
249  */
250 abstract contract Ownable is Context {
251     address private _owner;
252 
253     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
254 
255     /**
256      * @dev Initializes the contract setting the deployer as the initial owner.
257      */
258     constructor() {
259         _transferOwnership(_msgSender());
260     }
261 
262     /**
263      * @dev Returns the address of the current owner.
264      */
265     function owner() public view virtual returns (address) {
266         return _owner;
267     }
268 
269     /**
270      * @dev Throws if called by any account other than the owner.
271      */
272     modifier onlyOwner() {
273         require(owner() == _msgSender(), "Ownable: caller is not the owner");
274         _;
275     }
276 
277     /**
278      * @dev Leaves the contract without owner. It will not be possible to call
279      * `onlyOwner` functions anymore. Can only be called by the current owner.
280      *
281      * NOTE: Renouncing ownership will leave the contract without an owner,
282      * thereby removing any functionality that is only available to the owner.
283      */
284     function renounceOwnership() public virtual onlyOwner {
285         _transferOwnership(address(0));
286     }
287 
288     /**
289      * @dev Transfers ownership of the contract to a new account (`newOwner`).
290      * Can only be called by the current owner.
291      */
292     function transferOwnership(address newOwner) public virtual onlyOwner {
293         require(newOwner != address(0), "Ownable: new owner is the zero address");
294         _transferOwnership(newOwner);
295     }
296 
297     /**
298      * @dev Transfers ownership of the contract to a new account (`newOwner`).
299      * Internal function without access restriction.
300      */
301     function _transferOwnership(address newOwner) internal virtual {
302         address oldOwner = _owner;
303         _owner = newOwner;
304         emit OwnershipTransferred(oldOwner, newOwner);
305     }
306 }
307 
308 // File: contracts/OwnerAdminGuard.sol
309 
310 
311 
312 pragma solidity 0.8.12;
313 
314 
315 contract OwnerAdminGuard is Ownable {
316     address[2] private _admins;
317     bool private _adminsSet;
318 
319     /// @notice Allows the owner to specify two addresses allowed to administer this contract
320     /// @param admins A 2 item array of addresses
321     function setAdmins(address[2] calldata admins) public {
322         require(admins[0] != address(0) && admins[1] != address(0), "Invalid admin address");
323         _admins = admins;
324         _adminsSet = true;
325     }
326 
327     function _isOwnerOrAdmin(address addr) internal virtual view returns(bool){
328         return addr == owner() || (
329             _adminsSet && (
330                 addr == _admins[0] || addr == _admins[1]
331             )
332         );
333     }
334 
335     modifier onlyOwnerOrAdmin() {
336         require(_isOwnerOrAdmin(msg.sender), "Not an owner or admin");
337         _;
338     }
339 }
340 // File: contracts/AuthorizedCallerGuard.sol
341 
342 
343 
344 pragma solidity 0.8.12;
345 
346 
347 contract AuthorizedCallerGuard is OwnerAdminGuard {
348 
349     /// @dev Keeps track of which contracts are explicitly allowed to interact with certain super contract functionality
350     mapping(address => bool) public authorizedContracts;
351 
352     event AuthorizedContractAdded(address contractAddress, address addedBy);
353     event AuthorizedContractRemoved(address contractAddress, address removedBy);
354 
355     /// @notice Allows the owner or an admin to authorize another contract to override token accruals on an individual token level
356     /// @param contractAddress The authorized contract address
357     function addAuthorizedContract(address contractAddress) public onlyOwnerOrAdmin {
358         require(_isContract(contractAddress), "Invalid contractAddress");
359         authorizedContracts[contractAddress] = true;
360         emit AuthorizedContractAdded(contractAddress, _msgSender());
361     }
362 
363     /// @notice Allows the owner or an admin to remove an authorized contract
364     /// @param contractAddress The contract address which should have its authorization revoked
365     function removeAuthorizedContract(address contractAddress) public onlyOwnerOrAdmin {
366         authorizedContracts[contractAddress] = false;
367         emit AuthorizedContractRemoved(contractAddress, _msgSender());
368     }
369 
370     /// @dev Derived from @openzeppelin/contracts/utils/Address.sol
371     function _isContract(address account) internal virtual view returns (bool) {
372         if(account == address(0)) return false;
373         // This method relies on extcodesize, which returns 0 for contracts in
374         // construction, since the code is only stored at the end of the
375         // constructor execution.
376         uint256 size;
377         assembly {
378             size := extcodesize(account)
379         }
380         return size > 0;
381     }
382 
383     function _isAuthorizedContract(address addr) internal virtual view returns(bool){
384         return authorizedContracts[addr];
385     }
386 
387     modifier onlyAuthorizedCaller() {
388         require(_isOwnerOrAdmin(_msgSender()) || _isAuthorizedContract(_msgSender()), "Sender is not authorized");
389         _;
390     }
391 
392     modifier onlyAuthorizedContract() {
393         require(_isAuthorizedContract(_msgSender()), "Sender is not authorized");
394         _;
395     }
396 
397 }
398 // File: @openzeppelin/contracts@4.4.1/utils/Address.sol
399 
400 
401 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
402 
403 pragma solidity ^0.8.0;
404 
405 /**
406  * @dev Collection of functions related to the address type
407  */
408 library Address {
409     /**
410      * @dev Returns true if `account` is a contract.
411      *
412      * [IMPORTANT]
413      * ====
414      * It is unsafe to assume that an address for which this function returns
415      * false is an externally-owned account (EOA) and not a contract.
416      *
417      * Among others, `isContract` will return false for the following
418      * types of addresses:
419      *
420      *  - an externally-owned account
421      *  - a contract in construction
422      *  - an address where a contract will be created
423      *  - an address where a contract lived, but was destroyed
424      * ====
425      */
426     function isContract(address account) internal view returns (bool) {
427         // This method relies on extcodesize, which returns 0 for contracts in
428         // construction, since the code is only stored at the end of the
429         // constructor execution.
430 
431         uint256 size;
432         assembly {
433             size := extcodesize(account)
434         }
435         return size > 0;
436     }
437 
438     /**
439      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
440      * `recipient`, forwarding all available gas and reverting on errors.
441      *
442      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
443      * of certain opcodes, possibly making contracts go over the 2300 gas limit
444      * imposed by `transfer`, making them unable to receive funds via
445      * `transfer`. {sendValue} removes this limitation.
446      *
447      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
448      *
449      * IMPORTANT: because control is transferred to `recipient`, care must be
450      * taken to not create reentrancy vulnerabilities. Consider using
451      * {ReentrancyGuard} or the
452      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
453      */
454     function sendValue(address payable recipient, uint256 amount) internal {
455         require(address(this).balance >= amount, "Address: insufficient balance");
456 
457         (bool success, ) = recipient.call{value: amount}("");
458         require(success, "Address: unable to send value, recipient may have reverted");
459     }
460 
461     /**
462      * @dev Performs a Solidity function call using a low level `call`. A
463      * plain `call` is an unsafe replacement for a function call: use this
464      * function instead.
465      *
466      * If `target` reverts with a revert reason, it is bubbled up by this
467      * function (like regular Solidity function calls).
468      *
469      * Returns the raw returned data. To convert to the expected return value,
470      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
471      *
472      * Requirements:
473      *
474      * - `target` must be a contract.
475      * - calling `target` with `data` must not revert.
476      *
477      * _Available since v3.1._
478      */
479     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
480         return functionCall(target, data, "Address: low-level call failed");
481     }
482 
483     /**
484      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
485      * `errorMessage` as a fallback revert reason when `target` reverts.
486      *
487      * _Available since v3.1._
488      */
489     function functionCall(
490         address target,
491         bytes memory data,
492         string memory errorMessage
493     ) internal returns (bytes memory) {
494         return functionCallWithValue(target, data, 0, errorMessage);
495     }
496 
497     /**
498      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
499      * but also transferring `value` wei to `target`.
500      *
501      * Requirements:
502      *
503      * - the calling contract must have an ETH balance of at least `value`.
504      * - the called Solidity function must be `payable`.
505      *
506      * _Available since v3.1._
507      */
508     function functionCallWithValue(
509         address target,
510         bytes memory data,
511         uint256 value
512     ) internal returns (bytes memory) {
513         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
514     }
515 
516     /**
517      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
518      * with `errorMessage` as a fallback revert reason when `target` reverts.
519      *
520      * _Available since v3.1._
521      */
522     function functionCallWithValue(
523         address target,
524         bytes memory data,
525         uint256 value,
526         string memory errorMessage
527     ) internal returns (bytes memory) {
528         require(address(this).balance >= value, "Address: insufficient balance for call");
529         require(isContract(target), "Address: call to non-contract");
530 
531         (bool success, bytes memory returndata) = target.call{value: value}(data);
532         return verifyCallResult(success, returndata, errorMessage);
533     }
534 
535     /**
536      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
537      * but performing a static call.
538      *
539      * _Available since v3.3._
540      */
541     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
542         return functionStaticCall(target, data, "Address: low-level static call failed");
543     }
544 
545     /**
546      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
547      * but performing a static call.
548      *
549      * _Available since v3.3._
550      */
551     function functionStaticCall(
552         address target,
553         bytes memory data,
554         string memory errorMessage
555     ) internal view returns (bytes memory) {
556         require(isContract(target), "Address: static call to non-contract");
557 
558         (bool success, bytes memory returndata) = target.staticcall(data);
559         return verifyCallResult(success, returndata, errorMessage);
560     }
561 
562     /**
563      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
564      * but performing a delegate call.
565      *
566      * _Available since v3.4._
567      */
568     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
569         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
570     }
571 
572     /**
573      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
574      * but performing a delegate call.
575      *
576      * _Available since v3.4._
577      */
578     function functionDelegateCall(
579         address target,
580         bytes memory data,
581         string memory errorMessage
582     ) internal returns (bytes memory) {
583         require(isContract(target), "Address: delegate call to non-contract");
584 
585         (bool success, bytes memory returndata) = target.delegatecall(data);
586         return verifyCallResult(success, returndata, errorMessage);
587     }
588 
589     /**
590      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
591      * revert reason using the provided one.
592      *
593      * _Available since v4.3._
594      */
595     function verifyCallResult(
596         bool success,
597         bytes memory returndata,
598         string memory errorMessage
599     ) internal pure returns (bytes memory) {
600         if (success) {
601             return returndata;
602         } else {
603             // Look for revert reason and bubble it up if present
604             if (returndata.length > 0) {
605                 // The easiest way to bubble the revert reason is using memory via assembly
606 
607                 assembly {
608                     let returndata_size := mload(returndata)
609                     revert(add(32, returndata), returndata_size)
610                 }
611             } else {
612                 revert(errorMessage);
613             }
614         }
615     }
616 }
617 
618 // File: @openzeppelin/contracts@4.4.1/token/ERC721/IERC721Receiver.sol
619 
620 
621 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
622 
623 pragma solidity ^0.8.0;
624 
625 /**
626  * @title ERC721 token receiver interface
627  * @dev Interface for any contract that wants to support safeTransfers
628  * from ERC721 asset contracts.
629  */
630 interface IERC721Receiver {
631     /**
632      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
633      * by `operator` from `from`, this function is called.
634      *
635      * It must return its Solidity selector to confirm the token transfer.
636      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
637      *
638      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
639      */
640     function onERC721Received(
641         address operator,
642         address from,
643         uint256 tokenId,
644         bytes calldata data
645     ) external returns (bytes4);
646 }
647 
648 // File: @openzeppelin/contracts@4.4.1/utils/introspection/IERC165.sol
649 
650 
651 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
652 
653 pragma solidity ^0.8.0;
654 
655 /**
656  * @dev Interface of the ERC165 standard, as defined in the
657  * https://eips.ethereum.org/EIPS/eip-165[EIP].
658  *
659  * Implementers can declare support of contract interfaces, which can then be
660  * queried by others ({ERC165Checker}).
661  *
662  * For an implementation, see {ERC165}.
663  */
664 interface IERC165 {
665     /**
666      * @dev Returns true if this contract implements the interface defined by
667      * `interfaceId`. See the corresponding
668      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
669      * to learn more about how these ids are created.
670      *
671      * This function call must use less than 30 000 gas.
672      */
673     function supportsInterface(bytes4 interfaceId) external view returns (bool);
674 }
675 
676 // File: @openzeppelin/contracts@4.4.1/token/ERC1155/IERC1155Receiver.sol
677 
678 
679 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/IERC1155Receiver.sol)
680 
681 pragma solidity ^0.8.0;
682 
683 
684 /**
685  * @dev _Available since v3.1._
686  */
687 interface IERC1155Receiver is IERC165 {
688     /**
689         @dev Handles the receipt of a single ERC1155 token type. This function is
690         called at the end of a `safeTransferFrom` after the balance has been updated.
691         To accept the transfer, this must return
692         `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
693         (i.e. 0xf23a6e61, or its own function selector).
694         @param operator The address which initiated the transfer (i.e. msg.sender)
695         @param from The address which previously owned the token
696         @param id The ID of the token being transferred
697         @param value The amount of tokens being transferred
698         @param data Additional data with no specified format
699         @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
700     */
701     function onERC1155Received(
702         address operator,
703         address from,
704         uint256 id,
705         uint256 value,
706         bytes calldata data
707     ) external returns (bytes4);
708 
709     /**
710         @dev Handles the receipt of a multiple ERC1155 token types. This function
711         is called at the end of a `safeBatchTransferFrom` after the balances have
712         been updated. To accept the transfer(s), this must return
713         `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
714         (i.e. 0xbc197c81, or its own function selector).
715         @param operator The address which initiated the batch transfer (i.e. msg.sender)
716         @param from The address which previously owned the token
717         @param ids An array containing ids of each token being transferred (order and length must match values array)
718         @param values An array containing amounts of each token being transferred (order and length must match ids array)
719         @param data Additional data with no specified format
720         @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
721     */
722     function onERC1155BatchReceived(
723         address operator,
724         address from,
725         uint256[] calldata ids,
726         uint256[] calldata values,
727         bytes calldata data
728     ) external returns (bytes4);
729 }
730 
731 // File: @openzeppelin/contracts@4.4.1/token/ERC1155/IERC1155.sol
732 
733 
734 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/IERC1155.sol)
735 
736 pragma solidity ^0.8.0;
737 
738 
739 /**
740  * @dev Required interface of an ERC1155 compliant contract, as defined in the
741  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
742  *
743  * _Available since v3.1._
744  */
745 interface IERC1155 is IERC165 {
746     /**
747      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
748      */
749     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
750 
751     /**
752      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
753      * transfers.
754      */
755     event TransferBatch(
756         address indexed operator,
757         address indexed from,
758         address indexed to,
759         uint256[] ids,
760         uint256[] values
761     );
762 
763     /**
764      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
765      * `approved`.
766      */
767     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
768 
769     /**
770      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
771      *
772      * If an {URI} event was emitted for `id`, the standard
773      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
774      * returned by {IERC1155MetadataURI-uri}.
775      */
776     event URI(string value, uint256 indexed id);
777 
778     /**
779      * @dev Returns the amount of tokens of token type `id` owned by `account`.
780      *
781      * Requirements:
782      *
783      * - `account` cannot be the zero address.
784      */
785     function balanceOf(address account, uint256 id) external view returns (uint256);
786 
787     /**
788      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
789      *
790      * Requirements:
791      *
792      * - `accounts` and `ids` must have the same length.
793      */
794     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
795         external
796         view
797         returns (uint256[] memory);
798 
799     /**
800      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
801      *
802      * Emits an {ApprovalForAll} event.
803      *
804      * Requirements:
805      *
806      * - `operator` cannot be the caller.
807      */
808     function setApprovalForAll(address operator, bool approved) external;
809 
810     /**
811      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
812      *
813      * See {setApprovalForAll}.
814      */
815     function isApprovedForAll(address account, address operator) external view returns (bool);
816 
817     /**
818      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
819      *
820      * Emits a {TransferSingle} event.
821      *
822      * Requirements:
823      *
824      * - `to` cannot be the zero address.
825      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
826      * - `from` must have a balance of tokens of type `id` of at least `amount`.
827      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
828      * acceptance magic value.
829      */
830     function safeTransferFrom(
831         address from,
832         address to,
833         uint256 id,
834         uint256 amount,
835         bytes calldata data
836     ) external;
837 
838     /**
839      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
840      *
841      * Emits a {TransferBatch} event.
842      *
843      * Requirements:
844      *
845      * - `ids` and `amounts` must have the same length.
846      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
847      * acceptance magic value.
848      */
849     function safeBatchTransferFrom(
850         address from,
851         address to,
852         uint256[] calldata ids,
853         uint256[] calldata amounts,
854         bytes calldata data
855     ) external;
856 }
857 
858 // File: contracts/IAwooMintableCollection.sol
859 
860 
861 
862 pragma solidity 0.8.12;
863 
864 
865 interface IAwooMintableCollection is IERC1155 {
866     struct TokenDetail { bool SoftLimit; bool Active; }
867     struct TokenCount { uint256 TokenId; uint256 Count; }
868 
869     function supportsInterface(bytes4 interfaceId) external view returns (bool);
870     function mint(address to, uint256 id, uint256 qty) external;
871     function mintBatch(address to, uint256[] memory ids, uint256[] memory quantities) external;
872     function burn(address from, uint256 id, uint256 qty) external;
873     function tokensOfOwner(address owner) external view returns (TokenCount[] memory);
874     function totalMinted(uint256 id) external view returns(uint256);
875     function totalSupply(uint256 id) external view returns (uint256);
876     function exists(uint256 id) external view returns (bool);
877     function addToken(TokenDetail calldata tokenDetail, string memory tokenUri) external returns(uint256);
878     function setTokenUri(uint256 id, string memory tokenUri) external;
879     function setTokenActive(uint256 id, bool active) external;
880     function setBaseUri(string memory baseUri) external;
881 }
882 // File: @openzeppelin/contracts@4.4.1/token/ERC1155/extensions/IERC1155MetadataURI.sol
883 
884 
885 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/IERC1155MetadataURI.sol)
886 
887 pragma solidity ^0.8.0;
888 
889 
890 /**
891  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
892  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
893  *
894  * _Available since v3.1._
895  */
896 interface IERC1155MetadataURI is IERC1155 {
897     /**
898      * @dev Returns the URI for token type `id`.
899      *
900      * If the `\{id\}` substring is present in the URI, it must be replaced by
901      * clients with the actual token type ID.
902      */
903     function uri(uint256 id) external view returns (string memory);
904 }
905 
906 // File: @openzeppelin/contracts@4.4.1/utils/introspection/ERC165.sol
907 
908 
909 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
910 
911 pragma solidity ^0.8.0;
912 
913 
914 /**
915  * @dev Implementation of the {IERC165} interface.
916  *
917  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
918  * for the additional interface id that will be supported. For example:
919  *
920  * ```solidity
921  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
922  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
923  * }
924  * ```
925  *
926  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
927  */
928 abstract contract ERC165 is IERC165 {
929     /**
930      * @dev See {IERC165-supportsInterface}.
931      */
932     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
933         return interfaceId == type(IERC165).interfaceId;
934     }
935 }
936 
937 // File: @openzeppelin/contracts@4.4.1/token/ERC1155/ERC1155.sol
938 
939 
940 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/ERC1155.sol)
941 
942 pragma solidity ^0.8.0;
943 
944 
945 
946 
947 
948 
949 
950 /**
951  * @dev Implementation of the basic standard multi-token.
952  * See https://eips.ethereum.org/EIPS/eip-1155
953  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
954  *
955  * _Available since v3.1._
956  */
957 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
958     using Address for address;
959 
960     // Mapping from token ID to account balances
961     mapping(uint256 => mapping(address => uint256)) private _balances;
962 
963     // Mapping from account to operator approvals
964     mapping(address => mapping(address => bool)) private _operatorApprovals;
965 
966     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
967     string private _uri;
968 
969     /**
970      * @dev See {_setURI}.
971      */
972     constructor(string memory uri_) {
973         _setURI(uri_);
974     }
975 
976     /**
977      * @dev See {IERC165-supportsInterface}.
978      */
979     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
980         return
981             interfaceId == type(IERC1155).interfaceId ||
982             interfaceId == type(IERC1155MetadataURI).interfaceId ||
983             super.supportsInterface(interfaceId);
984     }
985 
986     /**
987      * @dev See {IERC1155MetadataURI-uri}.
988      *
989      * This implementation returns the same URI for *all* token types. It relies
990      * on the token type ID substitution mechanism
991      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
992      *
993      * Clients calling this function must replace the `\{id\}` substring with the
994      * actual token type ID.
995      */
996     function uri(uint256) public view virtual override returns (string memory) {
997         return _uri;
998     }
999 
1000     /**
1001      * @dev See {IERC1155-balanceOf}.
1002      *
1003      * Requirements:
1004      *
1005      * - `account` cannot be the zero address.
1006      */
1007     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
1008         require(account != address(0), "ERC1155: balance query for the zero address");
1009         return _balances[id][account];
1010     }
1011 
1012     /**
1013      * @dev See {IERC1155-balanceOfBatch}.
1014      *
1015      * Requirements:
1016      *
1017      * - `accounts` and `ids` must have the same length.
1018      */
1019     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
1020         public
1021         view
1022         virtual
1023         override
1024         returns (uint256[] memory)
1025     {
1026         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
1027 
1028         uint256[] memory batchBalances = new uint256[](accounts.length);
1029 
1030         for (uint256 i = 0; i < accounts.length; ++i) {
1031             batchBalances[i] = balanceOf(accounts[i], ids[i]);
1032         }
1033 
1034         return batchBalances;
1035     }
1036 
1037     /**
1038      * @dev See {IERC1155-setApprovalForAll}.
1039      */
1040     function setApprovalForAll(address operator, bool approved) public virtual override {
1041         _setApprovalForAll(_msgSender(), operator, approved);
1042     }
1043 
1044     /**
1045      * @dev See {IERC1155-isApprovedForAll}.
1046      */
1047     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
1048         return _operatorApprovals[account][operator];
1049     }
1050 
1051     /**
1052      * @dev See {IERC1155-safeTransferFrom}.
1053      */
1054     function safeTransferFrom(
1055         address from,
1056         address to,
1057         uint256 id,
1058         uint256 amount,
1059         bytes memory data
1060     ) public virtual override {
1061         require(
1062             from == _msgSender() || isApprovedForAll(from, _msgSender()),
1063             "ERC1155: caller is not owner nor approved"
1064         );
1065         _safeTransferFrom(from, to, id, amount, data);
1066     }
1067 
1068     /**
1069      * @dev See {IERC1155-safeBatchTransferFrom}.
1070      */
1071     function safeBatchTransferFrom(
1072         address from,
1073         address to,
1074         uint256[] memory ids,
1075         uint256[] memory amounts,
1076         bytes memory data
1077     ) public virtual override {
1078         require(
1079             from == _msgSender() || isApprovedForAll(from, _msgSender()),
1080             "ERC1155: transfer caller is not owner nor approved"
1081         );
1082         _safeBatchTransferFrom(from, to, ids, amounts, data);
1083     }
1084 
1085     /**
1086      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
1087      *
1088      * Emits a {TransferSingle} event.
1089      *
1090      * Requirements:
1091      *
1092      * - `to` cannot be the zero address.
1093      * - `from` must have a balance of tokens of type `id` of at least `amount`.
1094      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1095      * acceptance magic value.
1096      */
1097     function _safeTransferFrom(
1098         address from,
1099         address to,
1100         uint256 id,
1101         uint256 amount,
1102         bytes memory data
1103     ) internal virtual {
1104         require(to != address(0), "ERC1155: transfer to the zero address");
1105 
1106         address operator = _msgSender();
1107 
1108         _beforeTokenTransfer(operator, from, to, _asSingletonArray(id), _asSingletonArray(amount), data);
1109 
1110         uint256 fromBalance = _balances[id][from];
1111         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
1112         unchecked {
1113             _balances[id][from] = fromBalance - amount;
1114         }
1115         _balances[id][to] += amount;
1116 
1117         emit TransferSingle(operator, from, to, id, amount);
1118 
1119         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
1120     }
1121 
1122     /**
1123      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
1124      *
1125      * Emits a {TransferBatch} event.
1126      *
1127      * Requirements:
1128      *
1129      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1130      * acceptance magic value.
1131      */
1132     function _safeBatchTransferFrom(
1133         address from,
1134         address to,
1135         uint256[] memory ids,
1136         uint256[] memory amounts,
1137         bytes memory data
1138     ) internal virtual {
1139         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1140         require(to != address(0), "ERC1155: transfer to the zero address");
1141 
1142         address operator = _msgSender();
1143 
1144         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
1145 
1146         for (uint256 i = 0; i < ids.length; ++i) {
1147             uint256 id = ids[i];
1148             uint256 amount = amounts[i];
1149 
1150             uint256 fromBalance = _balances[id][from];
1151             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
1152             unchecked {
1153                 _balances[id][from] = fromBalance - amount;
1154             }
1155             _balances[id][to] += amount;
1156         }
1157 
1158         emit TransferBatch(operator, from, to, ids, amounts);
1159 
1160         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
1161     }
1162 
1163     /**
1164      * @dev Sets a new URI for all token types, by relying on the token type ID
1165      * substitution mechanism
1166      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
1167      *
1168      * By this mechanism, any occurrence of the `\{id\}` substring in either the
1169      * URI or any of the amounts in the JSON file at said URI will be replaced by
1170      * clients with the token type ID.
1171      *
1172      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
1173      * interpreted by clients as
1174      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
1175      * for token type ID 0x4cce0.
1176      *
1177      * See {uri}.
1178      *
1179      * Because these URIs cannot be meaningfully represented by the {URI} event,
1180      * this function emits no events.
1181      */
1182     function _setURI(string memory newuri) internal virtual {
1183         _uri = newuri;
1184     }
1185 
1186     /**
1187      * @dev Creates `amount` tokens of token type `id`, and assigns them to `to`.
1188      *
1189      * Emits a {TransferSingle} event.
1190      *
1191      * Requirements:
1192      *
1193      * - `to` cannot be the zero address.
1194      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1195      * acceptance magic value.
1196      */
1197     function _mint(
1198         address to,
1199         uint256 id,
1200         uint256 amount,
1201         bytes memory data
1202     ) internal virtual {
1203         require(to != address(0), "ERC1155: mint to the zero address");
1204 
1205         address operator = _msgSender();
1206 
1207         _beforeTokenTransfer(operator, address(0), to, _asSingletonArray(id), _asSingletonArray(amount), data);
1208 
1209         _balances[id][to] += amount;
1210         emit TransferSingle(operator, address(0), to, id, amount);
1211 
1212         _doSafeTransferAcceptanceCheck(operator, address(0), to, id, amount, data);
1213     }
1214 
1215     /**
1216      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
1217      *
1218      * Requirements:
1219      *
1220      * - `ids` and `amounts` must have the same length.
1221      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1222      * acceptance magic value.
1223      */
1224     function _mintBatch(
1225         address to,
1226         uint256[] memory ids,
1227         uint256[] memory amounts,
1228         bytes memory data
1229     ) internal virtual {
1230         require(to != address(0), "ERC1155: mint to the zero address");
1231         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1232 
1233         address operator = _msgSender();
1234 
1235         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
1236 
1237         for (uint256 i = 0; i < ids.length; i++) {
1238             _balances[ids[i]][to] += amounts[i];
1239         }
1240 
1241         emit TransferBatch(operator, address(0), to, ids, amounts);
1242 
1243         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
1244     }
1245 
1246     /**
1247      * @dev Destroys `amount` tokens of token type `id` from `from`
1248      *
1249      * Requirements:
1250      *
1251      * - `from` cannot be the zero address.
1252      * - `from` must have at least `amount` tokens of token type `id`.
1253      */
1254     function _burn(
1255         address from,
1256         uint256 id,
1257         uint256 amount
1258     ) internal virtual {
1259         require(from != address(0), "ERC1155: burn from the zero address");
1260 
1261         address operator = _msgSender();
1262 
1263         _beforeTokenTransfer(operator, from, address(0), _asSingletonArray(id), _asSingletonArray(amount), "");
1264 
1265         uint256 fromBalance = _balances[id][from];
1266         require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1267         unchecked {
1268             _balances[id][from] = fromBalance - amount;
1269         }
1270 
1271         emit TransferSingle(operator, from, address(0), id, amount);
1272     }
1273 
1274     /**
1275      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
1276      *
1277      * Requirements:
1278      *
1279      * - `ids` and `amounts` must have the same length.
1280      */
1281     function _burnBatch(
1282         address from,
1283         uint256[] memory ids,
1284         uint256[] memory amounts
1285     ) internal virtual {
1286         require(from != address(0), "ERC1155: burn from the zero address");
1287         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1288 
1289         address operator = _msgSender();
1290 
1291         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
1292 
1293         for (uint256 i = 0; i < ids.length; i++) {
1294             uint256 id = ids[i];
1295             uint256 amount = amounts[i];
1296 
1297             uint256 fromBalance = _balances[id][from];
1298             require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1299             unchecked {
1300                 _balances[id][from] = fromBalance - amount;
1301             }
1302         }
1303 
1304         emit TransferBatch(operator, from, address(0), ids, amounts);
1305     }
1306 
1307     /**
1308      * @dev Approve `operator` to operate on all of `owner` tokens
1309      *
1310      * Emits a {ApprovalForAll} event.
1311      */
1312     function _setApprovalForAll(
1313         address owner,
1314         address operator,
1315         bool approved
1316     ) internal virtual {
1317         require(owner != operator, "ERC1155: setting approval status for self");
1318         _operatorApprovals[owner][operator] = approved;
1319         emit ApprovalForAll(owner, operator, approved);
1320     }
1321 
1322     /**
1323      * @dev Hook that is called before any token transfer. This includes minting
1324      * and burning, as well as batched variants.
1325      *
1326      * The same hook is called on both single and batched variants. For single
1327      * transfers, the length of the `id` and `amount` arrays will be 1.
1328      *
1329      * Calling conditions (for each `id` and `amount` pair):
1330      *
1331      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1332      * of token type `id` will be  transferred to `to`.
1333      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1334      * for `to`.
1335      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1336      * will be burned.
1337      * - `from` and `to` are never both zero.
1338      * - `ids` and `amounts` have the same, non-zero length.
1339      *
1340      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1341      */
1342     function _beforeTokenTransfer(
1343         address operator,
1344         address from,
1345         address to,
1346         uint256[] memory ids,
1347         uint256[] memory amounts,
1348         bytes memory data
1349     ) internal virtual {}
1350 
1351     function _doSafeTransferAcceptanceCheck(
1352         address operator,
1353         address from,
1354         address to,
1355         uint256 id,
1356         uint256 amount,
1357         bytes memory data
1358     ) private {
1359         if (to.isContract()) {
1360             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
1361                 if (response != IERC1155Receiver.onERC1155Received.selector) {
1362                     revert("ERC1155: ERC1155Receiver rejected tokens");
1363                 }
1364             } catch Error(string memory reason) {
1365                 revert(reason);
1366             } catch {
1367                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1368             }
1369         }
1370     }
1371 
1372     function _doSafeBatchTransferAcceptanceCheck(
1373         address operator,
1374         address from,
1375         address to,
1376         uint256[] memory ids,
1377         uint256[] memory amounts,
1378         bytes memory data
1379     ) private {
1380         if (to.isContract()) {
1381             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
1382                 bytes4 response
1383             ) {
1384                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
1385                     revert("ERC1155: ERC1155Receiver rejected tokens");
1386                 }
1387             } catch Error(string memory reason) {
1388                 revert(reason);
1389             } catch {
1390                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1391             }
1392         }
1393     }
1394 
1395     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
1396         uint256[] memory array = new uint256[](1);
1397         array[0] = element;
1398 
1399         return array;
1400     }
1401 }
1402 
1403 // File: @openzeppelin/contracts@4.4.1/token/ERC1155/extensions/ERC1155Supply.sol
1404 
1405 
1406 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/ERC1155Supply.sol)
1407 
1408 pragma solidity ^0.8.0;
1409 
1410 
1411 /**
1412  * @dev Extension of ERC1155 that adds tracking of total supply per id.
1413  *
1414  * Useful for scenarios where Fungible and Non-fungible tokens have to be
1415  * clearly identified. Note: While a totalSupply of 1 might mean the
1416  * corresponding is an NFT, there is no guarantees that no other token with the
1417  * same id are not going to be minted.
1418  */
1419 abstract contract ERC1155Supply is ERC1155 {
1420     mapping(uint256 => uint256) private _totalSupply;
1421 
1422     /**
1423      * @dev Total amount of tokens in with a given id.
1424      */
1425     function totalSupply(uint256 id) public view virtual returns (uint256) {
1426         return _totalSupply[id];
1427     }
1428 
1429     /**
1430      * @dev Indicates whether any token exist with a given id, or not.
1431      */
1432     function exists(uint256 id) public view virtual returns (bool) {
1433         return ERC1155Supply.totalSupply(id) > 0;
1434     }
1435 
1436     /**
1437      * @dev See {ERC1155-_beforeTokenTransfer}.
1438      */
1439     function _beforeTokenTransfer(
1440         address operator,
1441         address from,
1442         address to,
1443         uint256[] memory ids,
1444         uint256[] memory amounts,
1445         bytes memory data
1446     ) internal virtual override {
1447         super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
1448 
1449         if (from == address(0)) {
1450             for (uint256 i = 0; i < ids.length; ++i) {
1451                 _totalSupply[ids[i]] += amounts[i];
1452             }
1453         }
1454 
1455         if (to == address(0)) {
1456             for (uint256 i = 0; i < ids.length; ++i) {
1457                 _totalSupply[ids[i]] -= amounts[i];
1458             }
1459         }
1460     }
1461 }
1462 
1463 // File: contracts/AwooCollection.sol
1464 
1465 
1466 
1467 pragma solidity 0.8.12;
1468 
1469 
1470 
1471 
1472 
1473 contract AwooCollection is IAwooMintableCollection, ERC1155Supply, AuthorizedCallerGuard {
1474     using Strings for uint256;
1475 
1476     string public constant name = "Awoo Items";
1477     string public constant symbol = "AWOOI";
1478 
1479     uint16 public currentTokenId;
1480     bool public isActive;
1481 
1482     /// @notice Maps the tokenId of a specific mintable item to the details that define that item
1483     mapping(uint256 => TokenDetail) public tokenDetails;
1484 
1485     /// @notice Keeps track of the number of tokens that were burned to support "Soft" limits
1486     /// @dev Soft limits are the number of tokens available at any given time, so if 1 is burned, another can be minted
1487     mapping(uint256 => uint256) public tokenBurnCounts;
1488 
1489     /// @dev Allows us to have token-specific metadata uris that will override the baseUri
1490     mapping(uint256 => string) private _tokenUris;
1491 
1492     event TokenUriUpdated(uint256 indexed id, string newUri, address updatedBy);
1493     
1494     constructor(address awooStoreAddress, string memory baseUri) ERC1155(baseUri){
1495         // Allow the Awoo Store contract to interact with this contract to faciliate minting and burning
1496         addAuthorizedContract(awooStoreAddress);
1497     }
1498 
1499     /// @dev See {IERC165-supportsInterface}.
1500     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC1155, IAwooMintableCollection) returns (bool) {
1501         return super.supportsInterface(interfaceId) ||
1502             interfaceId == type(IAwooMintableCollection).interfaceId ||
1503             interfaceId == type(IERC1155).interfaceId ||
1504             interfaceId == ERC1155Supply.totalSupply.selector ||
1505             interfaceId == ERC1155Supply.exists.selector;
1506     }
1507 
1508     /// @notice Allows authorized contracts to mints tokens to the specified recipient
1509     /// @param to The recipient address
1510     /// @param id The Id of the specific token to mint
1511     /// @param qty The number of specified tokens that should be minted
1512     function mint(address to, uint256 id, uint256 qty
1513     ) external whenActive onlyAuthorizedContract {
1514         _mint(to, id, qty, "");
1515     }
1516 
1517     /// @notice Allows authorized contracts to mint multiple different tokens to the specified recipient
1518     /// @param to The recipient address
1519     /// @param ids The Ids of the specific tokens to mint
1520     /// @param quantities The number of each of the specified tokens that should be minted
1521     function mintBatch(address to, uint256[] memory ids, uint256[] memory quantities
1522     ) external whenActive onlyAuthorizedContract {
1523         _mintBatch(to, ids, quantities, "");
1524     }
1525 
1526     /// @notice Burns the specified number of tokens.
1527     /// @notice Only the holder or an approved operator is authorized to burn
1528     /// @notice Operator approvals must have been explicitly allowed by the token holder
1529     /// @param from The account from which the specified tokens will be burned
1530     /// @param id The Id of the tokens that will be burned
1531     /// @param qty The number of specified tokens that will be burned
1532     function burn(address from, uint256 id, uint256 qty) external {
1533         require(exists(id), "Query for non-existent id");
1534         require(from == _msgSender() || isApprovedForAll(from, _msgSender()), "Not owner or approved");
1535         _burn(from, id, qty);
1536     }
1537 
1538     /// @notice Burns the specified number of each of the specified tokens.
1539     /// @notice Only the holder or an approved operator is authorized to burn
1540     /// @notice Operator approvals must have been explicitly allowed by the token holder
1541     /// @param from The account from which the specified tokens will be burned
1542     /// @param ids The Ids of the tokens that will be burned
1543     /// @param quantities The number of each of the specified tokens that will be burned
1544     function burnBatch(address from, uint256[] memory ids, uint256[] memory quantities) external {
1545         require(from == _msgSender() || isApprovedForAll(from, _msgSender()), "Not owner or approved");
1546         
1547         for(uint256 i; i < ids.length; i++){
1548             require(exists(ids[i]), "Query for non-existent id");
1549         }
1550         
1551         _burnBatch(from, ids, quantities);
1552     }
1553 
1554     /// @notice Returns the metadata uri for the specified token
1555     /// @dev By default, token-specific uris are given preference
1556     /// @param id The id of the token for which the uri should be returned
1557     /// @return A uri string
1558     function uri(uint256 id) public view override returns (string memory) {
1559         require(exists(id), "Query for non-existent id");
1560         return bytes(_tokenUris[id]).length > 0 ? _tokenUris[id] : string.concat(ERC1155.uri(id), id.toString(), ".json");
1561     }
1562 
1563     /// @notice Returns the number of each token held by the specified owner address
1564     /// @param owner The address of the token owner/holder
1565     /// @return An array of Tuple(uint256,uint256) indicating the number of tokens held
1566     function tokensOfOwner(address owner) external view returns (TokenCount[] memory) {
1567         TokenCount[] memory ownerTokenCounts = new TokenCount[](currentTokenId);
1568         
1569         for(uint256 i = 1; i <= currentTokenId; i++){
1570             uint256 count = balanceOf(owner, i);
1571             ownerTokenCounts[i-1] = TokenCount(i, count);
1572         }
1573         return ownerTokenCounts;
1574     }
1575 
1576     /// @notice Returns the total number of tokens minted for the specified token id
1577     /// @dev For tokens that have a soft limit, the number of burned tokens is included
1578     /// so the result is based on the total number of tokens minted, regardless of whether
1579     /// or not they were subsequently burned
1580     /// @param id The id of the token to query
1581     /// @return A uint256 value indicating the total number of tokens minted and burned for the specified token id 
1582     function totalMinted(uint256 id) isValidTokenId(id) external view returns(uint256) {
1583         TokenDetail memory tokenDetail = tokenDetails[id];
1584         
1585         if(tokenDetail.SoftLimit){
1586             return ERC1155Supply.totalSupply(id);
1587         }
1588         else {
1589             return (ERC1155Supply.totalSupply(id) + tokenBurnCounts[id]);
1590         }        
1591     }
1592 
1593     /// @notice Returns the current number of tokens that were minted and not burned
1594     /// @param id The id of the token to query
1595     /// @return A uint256 value indicating the number of tokens which have not been burned
1596     function totalSupply(uint256 id) public view virtual override(ERC1155Supply,IAwooMintableCollection) returns (uint256) {
1597         return ERC1155Supply.totalSupply(id);
1598     }
1599 
1600     /// @notice Determines whether or not the specified token id is valid and at least 1 has been minted
1601     /// @param id The id of the token to validate
1602     /// @return A boolean value indicating the existence of the specified token id
1603     function exists(uint256 id) public view virtual override(ERC1155Supply,IAwooMintableCollection) returns (bool) {
1604         return ERC1155Supply.exists(id);
1605     }
1606 
1607     /// @notice Allows authorized individuals or contracts to add new tokens that can be minted    
1608     /// @param tokenDetail An object describing the token being added
1609     /// @param tokenUri The specific uri to use for the token being added
1610     /// @return A uint256 value representing the id of the token
1611     function addToken(TokenDetail calldata tokenDetail, string memory tokenUri) external isAuthorized returns(uint256){
1612         currentTokenId++;
1613         if(bytes(tokenUri).length > 0) {
1614             _tokenUris[currentTokenId] = tokenUri;
1615         }
1616         tokenDetails[currentTokenId] = tokenDetail;
1617         return currentTokenId;
1618     }
1619 
1620     /// @notice Allows authorized individuals or contracts to set the base metadata uri
1621     /// @dev It is assumed that the baseUri value will end with /
1622     /// @param baseUri The uri to use as the base for all tokens that don't have a token-specific uri
1623     function setBaseUri(string memory baseUri) external isAuthorized {
1624         _setURI(baseUri);
1625     }
1626 
1627     /// @notice Allows authorized individuals or contracts to set the base metadata uri on a per token level
1628     /// @param id The id of the token
1629     /// @param tokenUri The uri to use for the specified token id
1630     function setTokenUri(uint256 id, string memory tokenUri) external isAuthorized isValidTokenId(id) {        
1631         _tokenUris[id] = tokenUri;
1632         emit TokenUriUpdated(id, tokenUri, _msgSender());
1633     }
1634 
1635     /// @notice Allows authorized individuals or contracts to activate/deactivate minting of the specified token id
1636     /// @param id The id of the token
1637     /// @param active A boolean value indicating whether or not minting is allowed for this token
1638     function setTokenActive(uint256 id, bool active) external isAuthorized isValidTokenId(id) {
1639         tokenDetails[id].Active = active;
1640     }
1641 
1642     /// @notice Allows authorized individuals to activate/deactivate minting of all tokens
1643     /// @param active A boolean value indicating whether or not minting is allowed
1644     function setActive(bool active) external onlyOwnerOrAdmin {
1645         isActive = active;
1646     }
1647 
1648     function rescueEth() external onlyOwner {
1649         require(payable(owner()).send(address(this).balance));
1650     }
1651 
1652     /// @dev Hook to allows us to count the burned tokens even if they're just transferred to the zero address
1653     function _beforeTokenTransfer(address operator, address from, address to, uint256[] memory ids,
1654         uint256[] memory amounts, bytes memory data
1655     ) internal virtual override {
1656         super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
1657 
1658         if (to == address(0)) {
1659             for (uint256 i = 0; i < ids.length; ++i) {
1660                 tokenBurnCounts[ids[i]] += amounts[i];
1661             }
1662         }
1663     }
1664 
1665     modifier whenActive(){
1666         require(isActive, "Minting inactive");
1667         _;
1668     }
1669 
1670     modifier isValidTokenId(uint256 id) {
1671         require(id <= currentTokenId, "Invalid tokenId");
1672         _;
1673     }
1674 
1675     modifier isValidTokenIds(uint256[] memory ids){
1676         for(uint256 i = 0; i < ids.length; i++){
1677             require(ids[i] <= currentTokenId, "Invalid tokenId");
1678         }
1679         _;
1680     }
1681 
1682     modifier isAuthorized() {
1683         require(_isAuthorizedContract(_msgSender()) || _isOwnerOrAdmin(_msgSender()), "Unauthorized");
1684         _;
1685     }
1686 
1687 }
1688 // File: @openzeppelin/contracts@4.4.1/token/ERC721/IERC721.sol
1689 
1690 
1691 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
1692 
1693 pragma solidity ^0.8.0;
1694 
1695 
1696 /**
1697  * @dev Required interface of an ERC721 compliant contract.
1698  */
1699 interface IERC721 is IERC165 {
1700     /**
1701      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1702      */
1703     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1704 
1705     /**
1706      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1707      */
1708     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1709 
1710     /**
1711      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1712      */
1713     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1714 
1715     /**
1716      * @dev Returns the number of tokens in ``owner``'s account.
1717      */
1718     function balanceOf(address owner) external view returns (uint256 balance);
1719 
1720     /**
1721      * @dev Returns the owner of the `tokenId` token.
1722      *
1723      * Requirements:
1724      *
1725      * - `tokenId` must exist.
1726      */
1727     function ownerOf(uint256 tokenId) external view returns (address owner);
1728 
1729     /**
1730      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1731      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1732      *
1733      * Requirements:
1734      *
1735      * - `from` cannot be the zero address.
1736      * - `to` cannot be the zero address.
1737      * - `tokenId` token must exist and be owned by `from`.
1738      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1739      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1740      *
1741      * Emits a {Transfer} event.
1742      */
1743     function safeTransferFrom(
1744         address from,
1745         address to,
1746         uint256 tokenId
1747     ) external;
1748 
1749     /**
1750      * @dev Transfers `tokenId` token from `from` to `to`.
1751      *
1752      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1753      *
1754      * Requirements:
1755      *
1756      * - `from` cannot be the zero address.
1757      * - `to` cannot be the zero address.
1758      * - `tokenId` token must be owned by `from`.
1759      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1760      *
1761      * Emits a {Transfer} event.
1762      */
1763     function transferFrom(
1764         address from,
1765         address to,
1766         uint256 tokenId
1767     ) external;
1768 
1769     /**
1770      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1771      * The approval is cleared when the token is transferred.
1772      *
1773      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1774      *
1775      * Requirements:
1776      *
1777      * - The caller must own the token or be an approved operator.
1778      * - `tokenId` must exist.
1779      *
1780      * Emits an {Approval} event.
1781      */
1782     function approve(address to, uint256 tokenId) external;
1783 
1784     /**
1785      * @dev Returns the account approved for `tokenId` token.
1786      *
1787      * Requirements:
1788      *
1789      * - `tokenId` must exist.
1790      */
1791     function getApproved(uint256 tokenId) external view returns (address operator);
1792 
1793     /**
1794      * @dev Approve or remove `operator` as an operator for the caller.
1795      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1796      *
1797      * Requirements:
1798      *
1799      * - The `operator` cannot be the caller.
1800      *
1801      * Emits an {ApprovalForAll} event.
1802      */
1803     function setApprovalForAll(address operator, bool _approved) external;
1804 
1805     /**
1806      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1807      *
1808      * See {setApprovalForAll}
1809      */
1810     function isApprovedForAll(address owner, address operator) external view returns (bool);
1811 
1812     /**
1813      * @dev Safely transfers `tokenId` token from `from` to `to`.
1814      *
1815      * Requirements:
1816      *
1817      * - `from` cannot be the zero address.
1818      * - `to` cannot be the zero address.
1819      * - `tokenId` token must exist and be owned by `from`.
1820      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1821      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1822      *
1823      * Emits a {Transfer} event.
1824      */
1825     function safeTransferFrom(
1826         address from,
1827         address to,
1828         uint256 tokenId,
1829         bytes calldata data
1830     ) external;
1831 }
1832 
1833 // File: @openzeppelin/contracts@4.4.1/token/ERC721/extensions/IERC721Metadata.sol
1834 
1835 
1836 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1837 
1838 pragma solidity ^0.8.0;
1839 
1840 
1841 /**
1842  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1843  * @dev See https://eips.ethereum.org/EIPS/eip-721
1844  */
1845 interface IERC721Metadata is IERC721 {
1846     /**
1847      * @dev Returns the token collection name.
1848      */
1849     function name() external view returns (string memory);
1850 
1851     /**
1852      * @dev Returns the token collection symbol.
1853      */
1854     function symbol() external view returns (string memory);
1855 
1856     /**
1857      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1858      */
1859     function tokenURI(uint256 tokenId) external view returns (string memory);
1860 }
1861 
1862 // File: @openzeppelin/contracts@4.4.1/token/ERC721/ERC721.sol
1863 
1864 
1865 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
1866 
1867 pragma solidity ^0.8.0;
1868 
1869 
1870 
1871 
1872 
1873 
1874 
1875 
1876 /**
1877  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1878  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1879  * {ERC721Enumerable}.
1880  */
1881 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1882     using Address for address;
1883     using Strings for uint256;
1884 
1885     // Token name
1886     string private _name;
1887 
1888     // Token symbol
1889     string private _symbol;
1890 
1891     // Mapping from token ID to owner address
1892     mapping(uint256 => address) private _owners;
1893 
1894     // Mapping owner address to token count
1895     mapping(address => uint256) private _balances;
1896 
1897     // Mapping from token ID to approved address
1898     mapping(uint256 => address) private _tokenApprovals;
1899 
1900     // Mapping from owner to operator approvals
1901     mapping(address => mapping(address => bool)) private _operatorApprovals;
1902 
1903     /**
1904      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1905      */
1906     constructor(string memory name_, string memory symbol_) {
1907         _name = name_;
1908         _symbol = symbol_;
1909     }
1910 
1911     /**
1912      * @dev See {IERC165-supportsInterface}.
1913      */
1914     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1915         return
1916             interfaceId == type(IERC721).interfaceId ||
1917             interfaceId == type(IERC721Metadata).interfaceId ||
1918             super.supportsInterface(interfaceId);
1919     }
1920 
1921     /**
1922      * @dev See {IERC721-balanceOf}.
1923      */
1924     function balanceOf(address owner) public view virtual override returns (uint256) {
1925         require(owner != address(0), "ERC721: balance query for the zero address");
1926         return _balances[owner];
1927     }
1928 
1929     /**
1930      * @dev See {IERC721-ownerOf}.
1931      */
1932     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1933         address owner = _owners[tokenId];
1934         require(owner != address(0), "ERC721: owner query for nonexistent token");
1935         return owner;
1936     }
1937 
1938     /**
1939      * @dev See {IERC721Metadata-name}.
1940      */
1941     function name() public view virtual override returns (string memory) {
1942         return _name;
1943     }
1944 
1945     /**
1946      * @dev See {IERC721Metadata-symbol}.
1947      */
1948     function symbol() public view virtual override returns (string memory) {
1949         return _symbol;
1950     }
1951 
1952     /**
1953      * @dev See {IERC721Metadata-tokenURI}.
1954      */
1955     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1956         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1957 
1958         string memory baseURI = _baseURI();
1959         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1960     }
1961 
1962     /**
1963      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1964      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1965      * by default, can be overriden in child contracts.
1966      */
1967     function _baseURI() internal view virtual returns (string memory) {
1968         return "";
1969     }
1970 
1971     /**
1972      * @dev See {IERC721-approve}.
1973      */
1974     function approve(address to, uint256 tokenId) public virtual override {
1975         address owner = ERC721.ownerOf(tokenId);
1976         require(to != owner, "ERC721: approval to current owner");
1977 
1978         require(
1979             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1980             "ERC721: approve caller is not owner nor approved for all"
1981         );
1982 
1983         _approve(to, tokenId);
1984     }
1985 
1986     /**
1987      * @dev See {IERC721-getApproved}.
1988      */
1989     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1990         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1991 
1992         return _tokenApprovals[tokenId];
1993     }
1994 
1995     /**
1996      * @dev See {IERC721-setApprovalForAll}.
1997      */
1998     function setApprovalForAll(address operator, bool approved) public virtual override {
1999         _setApprovalForAll(_msgSender(), operator, approved);
2000     }
2001 
2002     /**
2003      * @dev See {IERC721-isApprovedForAll}.
2004      */
2005     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
2006         return _operatorApprovals[owner][operator];
2007     }
2008 
2009     /**
2010      * @dev See {IERC721-transferFrom}.
2011      */
2012     function transferFrom(
2013         address from,
2014         address to,
2015         uint256 tokenId
2016     ) public virtual override {
2017         //solhint-disable-next-line max-line-length
2018         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
2019 
2020         _transfer(from, to, tokenId);
2021     }
2022 
2023     /**
2024      * @dev See {IERC721-safeTransferFrom}.
2025      */
2026     function safeTransferFrom(
2027         address from,
2028         address to,
2029         uint256 tokenId
2030     ) public virtual override {
2031         safeTransferFrom(from, to, tokenId, "");
2032     }
2033 
2034     /**
2035      * @dev See {IERC721-safeTransferFrom}.
2036      */
2037     function safeTransferFrom(
2038         address from,
2039         address to,
2040         uint256 tokenId,
2041         bytes memory _data
2042     ) public virtual override {
2043         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
2044         _safeTransfer(from, to, tokenId, _data);
2045     }
2046 
2047     /**
2048      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
2049      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
2050      *
2051      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
2052      *
2053      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
2054      * implement alternative mechanisms to perform token transfer, such as signature-based.
2055      *
2056      * Requirements:
2057      *
2058      * - `from` cannot be the zero address.
2059      * - `to` cannot be the zero address.
2060      * - `tokenId` token must exist and be owned by `from`.
2061      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2062      *
2063      * Emits a {Transfer} event.
2064      */
2065     function _safeTransfer(
2066         address from,
2067         address to,
2068         uint256 tokenId,
2069         bytes memory _data
2070     ) internal virtual {
2071         _transfer(from, to, tokenId);
2072         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
2073     }
2074 
2075     /**
2076      * @dev Returns whether `tokenId` exists.
2077      *
2078      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
2079      *
2080      * Tokens start existing when they are minted (`_mint`),
2081      * and stop existing when they are burned (`_burn`).
2082      */
2083     function _exists(uint256 tokenId) internal view virtual returns (bool) {
2084         return _owners[tokenId] != address(0);
2085     }
2086 
2087     /**
2088      * @dev Returns whether `spender` is allowed to manage `tokenId`.
2089      *
2090      * Requirements:
2091      *
2092      * - `tokenId` must exist.
2093      */
2094     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
2095         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
2096         address owner = ERC721.ownerOf(tokenId);
2097         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
2098     }
2099 
2100     /**
2101      * @dev Safely mints `tokenId` and transfers it to `to`.
2102      *
2103      * Requirements:
2104      *
2105      * - `tokenId` must not exist.
2106      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2107      *
2108      * Emits a {Transfer} event.
2109      */
2110     function _safeMint(address to, uint256 tokenId) internal virtual {
2111         _safeMint(to, tokenId, "");
2112     }
2113 
2114     /**
2115      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
2116      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
2117      */
2118     function _safeMint(
2119         address to,
2120         uint256 tokenId,
2121         bytes memory _data
2122     ) internal virtual {
2123         _mint(to, tokenId);
2124         require(
2125             _checkOnERC721Received(address(0), to, tokenId, _data),
2126             "ERC721: transfer to non ERC721Receiver implementer"
2127         );
2128     }
2129 
2130     /**
2131      * @dev Mints `tokenId` and transfers it to `to`.
2132      *
2133      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
2134      *
2135      * Requirements:
2136      *
2137      * - `tokenId` must not exist.
2138      * - `to` cannot be the zero address.
2139      *
2140      * Emits a {Transfer} event.
2141      */
2142     function _mint(address to, uint256 tokenId) internal virtual {
2143         require(to != address(0), "ERC721: mint to the zero address");
2144         require(!_exists(tokenId), "ERC721: token already minted");
2145 
2146         _beforeTokenTransfer(address(0), to, tokenId);
2147 
2148         _balances[to] += 1;
2149         _owners[tokenId] = to;
2150 
2151         emit Transfer(address(0), to, tokenId);
2152     }
2153 
2154     /**
2155      * @dev Destroys `tokenId`.
2156      * The approval is cleared when the token is burned.
2157      *
2158      * Requirements:
2159      *
2160      * - `tokenId` must exist.
2161      *
2162      * Emits a {Transfer} event.
2163      */
2164     function _burn(uint256 tokenId) internal virtual {
2165         address owner = ERC721.ownerOf(tokenId);
2166 
2167         _beforeTokenTransfer(owner, address(0), tokenId);
2168 
2169         // Clear approvals
2170         _approve(address(0), tokenId);
2171 
2172         _balances[owner] -= 1;
2173         delete _owners[tokenId];
2174 
2175         emit Transfer(owner, address(0), tokenId);
2176     }
2177 
2178     /**
2179      * @dev Transfers `tokenId` from `from` to `to`.
2180      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
2181      *
2182      * Requirements:
2183      *
2184      * - `to` cannot be the zero address.
2185      * - `tokenId` token must be owned by `from`.
2186      *
2187      * Emits a {Transfer} event.
2188      */
2189     function _transfer(
2190         address from,
2191         address to,
2192         uint256 tokenId
2193     ) internal virtual {
2194         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
2195         require(to != address(0), "ERC721: transfer to the zero address");
2196 
2197         _beforeTokenTransfer(from, to, tokenId);
2198 
2199         // Clear approvals from the previous owner
2200         _approve(address(0), tokenId);
2201 
2202         _balances[from] -= 1;
2203         _balances[to] += 1;
2204         _owners[tokenId] = to;
2205 
2206         emit Transfer(from, to, tokenId);
2207     }
2208 
2209     /**
2210      * @dev Approve `to` to operate on `tokenId`
2211      *
2212      * Emits a {Approval} event.
2213      */
2214     function _approve(address to, uint256 tokenId) internal virtual {
2215         _tokenApprovals[tokenId] = to;
2216         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
2217     }
2218 
2219     /**
2220      * @dev Approve `operator` to operate on all of `owner` tokens
2221      *
2222      * Emits a {ApprovalForAll} event.
2223      */
2224     function _setApprovalForAll(
2225         address owner,
2226         address operator,
2227         bool approved
2228     ) internal virtual {
2229         require(owner != operator, "ERC721: approve to caller");
2230         _operatorApprovals[owner][operator] = approved;
2231         emit ApprovalForAll(owner, operator, approved);
2232     }
2233 
2234     /**
2235      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
2236      * The call is not executed if the target address is not a contract.
2237      *
2238      * @param from address representing the previous owner of the given token ID
2239      * @param to target address that will receive the tokens
2240      * @param tokenId uint256 ID of the token to be transferred
2241      * @param _data bytes optional data to send along with the call
2242      * @return bool whether the call correctly returned the expected magic value
2243      */
2244     function _checkOnERC721Received(
2245         address from,
2246         address to,
2247         uint256 tokenId,
2248         bytes memory _data
2249     ) private returns (bool) {
2250         if (to.isContract()) {
2251             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
2252                 return retval == IERC721Receiver.onERC721Received.selector;
2253             } catch (bytes memory reason) {
2254                 if (reason.length == 0) {
2255                     revert("ERC721: transfer to non ERC721Receiver implementer");
2256                 } else {
2257                     assembly {
2258                         revert(add(32, reason), mload(reason))
2259                     }
2260                 }
2261             }
2262         } else {
2263             return true;
2264         }
2265     }
2266 
2267     /**
2268      * @dev Hook that is called before any token transfer. This includes minting
2269      * and burning.
2270      *
2271      * Calling conditions:
2272      *
2273      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2274      * transferred to `to`.
2275      * - When `from` is zero, `tokenId` will be minted for `to`.
2276      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2277      * - `from` and `to` are never both zero.
2278      *
2279      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2280      */
2281     function _beforeTokenTransfer(
2282         address from,
2283         address to,
2284         uint256 tokenId
2285     ) internal virtual {}
2286 }
2287 
2288 // File: @openzeppelin/contracts@4.4.1/token/ERC721/extensions/IERC721Enumerable.sol
2289 
2290 
2291 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
2292 
2293 pragma solidity ^0.8.0;
2294 
2295 
2296 /**
2297  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
2298  * @dev See https://eips.ethereum.org/EIPS/eip-721
2299  */
2300 interface IERC721Enumerable is IERC721 {
2301     /**
2302      * @dev Returns the total amount of tokens stored by the contract.
2303      */
2304     function totalSupply() external view returns (uint256);
2305 
2306     /**
2307      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
2308      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
2309      */
2310     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
2311 
2312     /**
2313      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
2314      * Use along with {totalSupply} to enumerate all tokens.
2315      */
2316     function tokenByIndex(uint256 index) external view returns (uint256);
2317 }
2318 
2319 // File: @openzeppelin/contracts@4.4.1/token/ERC721/extensions/ERC721Enumerable.sol
2320 
2321 
2322 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
2323 
2324 pragma solidity ^0.8.0;
2325 
2326 
2327 
2328 /**
2329  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
2330  * enumerability of all the token ids in the contract as well as all token ids owned by each
2331  * account.
2332  */
2333 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
2334     // Mapping from owner to list of owned token IDs
2335     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
2336 
2337     // Mapping from token ID to index of the owner tokens list
2338     mapping(uint256 => uint256) private _ownedTokensIndex;
2339 
2340     // Array with all token ids, used for enumeration
2341     uint256[] private _allTokens;
2342 
2343     // Mapping from token id to position in the allTokens array
2344     mapping(uint256 => uint256) private _allTokensIndex;
2345 
2346     /**
2347      * @dev See {IERC165-supportsInterface}.
2348      */
2349     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
2350         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
2351     }
2352 
2353     /**
2354      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
2355      */
2356     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
2357         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
2358         return _ownedTokens[owner][index];
2359     }
2360 
2361     /**
2362      * @dev See {IERC721Enumerable-totalSupply}.
2363      */
2364     function totalSupply() public view virtual override returns (uint256) {
2365         return _allTokens.length;
2366     }
2367 
2368     /**
2369      * @dev See {IERC721Enumerable-tokenByIndex}.
2370      */
2371     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
2372         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
2373         return _allTokens[index];
2374     }
2375 
2376     /**
2377      * @dev Hook that is called before any token transfer. This includes minting
2378      * and burning.
2379      *
2380      * Calling conditions:
2381      *
2382      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2383      * transferred to `to`.
2384      * - When `from` is zero, `tokenId` will be minted for `to`.
2385      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2386      * - `from` cannot be the zero address.
2387      * - `to` cannot be the zero address.
2388      *
2389      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2390      */
2391     function _beforeTokenTransfer(
2392         address from,
2393         address to,
2394         uint256 tokenId
2395     ) internal virtual override {
2396         super._beforeTokenTransfer(from, to, tokenId);
2397 
2398         if (from == address(0)) {
2399             _addTokenToAllTokensEnumeration(tokenId);
2400         } else if (from != to) {
2401             _removeTokenFromOwnerEnumeration(from, tokenId);
2402         }
2403         if (to == address(0)) {
2404             _removeTokenFromAllTokensEnumeration(tokenId);
2405         } else if (to != from) {
2406             _addTokenToOwnerEnumeration(to, tokenId);
2407         }
2408     }
2409 
2410     /**
2411      * @dev Private function to add a token to this extension's ownership-tracking data structures.
2412      * @param to address representing the new owner of the given token ID
2413      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
2414      */
2415     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
2416         uint256 length = ERC721.balanceOf(to);
2417         _ownedTokens[to][length] = tokenId;
2418         _ownedTokensIndex[tokenId] = length;
2419     }
2420 
2421     /**
2422      * @dev Private function to add a token to this extension's token tracking data structures.
2423      * @param tokenId uint256 ID of the token to be added to the tokens list
2424      */
2425     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
2426         _allTokensIndex[tokenId] = _allTokens.length;
2427         _allTokens.push(tokenId);
2428     }
2429 
2430     /**
2431      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
2432      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
2433      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
2434      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
2435      * @param from address representing the previous owner of the given token ID
2436      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
2437      */
2438     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
2439         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
2440         // then delete the last slot (swap and pop).
2441 
2442         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
2443         uint256 tokenIndex = _ownedTokensIndex[tokenId];
2444 
2445         // When the token to delete is the last token, the swap operation is unnecessary
2446         if (tokenIndex != lastTokenIndex) {
2447             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
2448 
2449             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
2450             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
2451         }
2452 
2453         // This also deletes the contents at the last position of the array
2454         delete _ownedTokensIndex[tokenId];
2455         delete _ownedTokens[from][lastTokenIndex];
2456     }
2457 
2458     /**
2459      * @dev Private function to remove a token from this extension's token tracking data structures.
2460      * This has O(1) time complexity, but alters the order of the _allTokens array.
2461      * @param tokenId uint256 ID of the token to be removed from the tokens list
2462      */
2463     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
2464         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
2465         // then delete the last slot (swap and pop).
2466 
2467         uint256 lastTokenIndex = _allTokens.length - 1;
2468         uint256 tokenIndex = _allTokensIndex[tokenId];
2469 
2470         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
2471         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
2472         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
2473         uint256 lastTokenId = _allTokens[lastTokenIndex];
2474 
2475         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
2476         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
2477 
2478         // This also deletes the contents at the last position of the array
2479         delete _allTokensIndex[tokenId];
2480         _allTokens.pop();
2481     }
2482 }
2483 
2484 // File: contracts/AwooStoreV2.sol
2485 
2486 
2487 
2488 pragma solidity 0.8.12;
2489 
2490 
2491 
2492 
2493 
2494 
2495 
2496 
2497 
2498 
2499 
2500 contract AwooStoreV2 is OwnerAdminGuard {
2501     struct AwooSpendApproval {
2502         bytes32 Hash;
2503         bytes Sig;
2504         string Nonce;
2505     }
2506 
2507     enum PaymentType {
2508         AWOO,
2509         ETHER,
2510         AWOO_AND_ETHER,
2511         FREE
2512     }
2513 
2514     struct UpgradeDetail {
2515         uint8 ApplicableCollectionId;
2516         bool UpgradeItem;
2517         bool Stackable;
2518         uint256 UpgradeBaseAccrualRate;
2519     }
2520 
2521     struct ItemDetail {
2522         uint16 TotalAvailable;
2523         uint16 PerAddressLimit;
2524         uint16 PerTransactionLimit;
2525         PaymentType PmtType;
2526         bool Burnable;
2527         bool NonMintable;
2528         bool Active;
2529         IAwooMintableCollection.TokenDetail TokenDetails;
2530         UpgradeDetail UpgradeDetails;
2531         string MetadataUri;
2532         uint256 TokenId;
2533         uint256 EtherPrice;
2534         uint256 AWOOPrice;
2535     }
2536 
2537     address payable public withdrawAddress;
2538     IAwooToken public awooContract;
2539     IAwooClaimingV2 public awooClaimingContract;
2540     IAwooMintableCollection public awooMintableCollectionContract;
2541 
2542     bool public storeActive;
2543 
2544     /// @dev Helps us track the supported ERC721Enumerable contracts so we can refer to them by their
2545     /// "id" to save a bit of gas
2546     uint8 public collectionCount;
2547 
2548     /// @dev Helps us track the available items so we can refer to them by their "id" to save a bit of gas
2549     uint16 public itemCount;
2550 
2551     /// @notice Maps the supported ERC721Enumerable contracts to their Ids
2552     mapping(uint8 => address) public collectionIdAddressMap;
2553 
2554     /// @notice Maps the available items to their Ids
2555     mapping(uint16 => ItemDetail) public itemIdDetailMap;
2556 
2557     /// @notice Maps the number of purchased (not minted) items
2558     mapping(uint16 => uint256) public purchasedItemCount;
2559 
2560     /// @notice Maps item ownership counts
2561     // owner => (itemId, count).  This is only relevant for items that weren't minted
2562     mapping(address => mapping(uint16 => uint256))
2563         public ownedItemCountsByOwner;
2564 
2565     /// @notice Keeps track of how many of each token has been minted by a particular address
2566     // owner => (itemId, count)
2567     mapping(address => mapping(uint16 => uint256))
2568         public mintedItemCountsByAddress;
2569 
2570     /// @notice Keeps track of "upgrade" item applications
2571     // itemId => (collectionId, applicationTokenIds)
2572     mapping(uint16 => mapping(uint8 => uint256[])) public itemApplications;
2573 
2574     /// @notice Keeps track of "upgrade" items by the collection that they were applied to
2575     // collectionId => (tokenId, (itemId => count))
2576     mapping(uint8 => mapping(uint32 => mapping(uint16 => uint256)))
2577         public tokenAppliedItemCountsByCollection;
2578 
2579     /// @notice A method that tells us that an "upgrade" item was applied so we can do some cool stuff
2580     event UpgradeItemApplied(
2581         uint16 itemId,
2582         address applicationCollectionAddress,
2583         uint256 appliedToTokenId
2584     );
2585     // ;)
2586     event NonMintableItemUsed(uint16 itemId, address usedBy, uint256 qty);
2587     event ItemPurchased(uint16 itemId, address purchasedBy, uint256 qty);
2588 
2589     constructor(
2590         address payable withdrawAddr,
2591         IAwooToken awooTokenContract,
2592         IAwooClaimingV2 claimingContract
2593     ) {
2594         require(withdrawAddr != address(0), "Invalid address");
2595 
2596         withdrawAddress = withdrawAddr;
2597         awooContract = awooTokenContract;
2598         awooClaimingContract = claimingContract;
2599     }
2600 
2601     /// @notice Allows the specified item to be minted with AWOO
2602     /// @param itemId The id of the item to mint
2603     /// @param qty The number of items to mint
2604     /// @param approval An object containing the signed message details authorizing us to spend the holders AWOO
2605     /// @param requestedClaims An optional array of ClaimDetails so we can automagically claim the necessary
2606     /// amount of AWOO, as specified through NFC
2607     function mintWithAwoo(
2608         uint16 itemId,
2609         uint256 qty,
2610         AwooSpendApproval calldata approval,
2611         ClaimDetails[] calldata requestedClaims
2612     ) public whenStoreActive nonZeroQuantity(qty) {
2613         ItemDetail memory item = _validateItem(itemId, PaymentType.AWOO);
2614         require(!item.NonMintable, "Specified item is not mintable");
2615 
2616         _validateRequestedQuantity(itemId, item, qty);
2617         _ensureAvailablity(item, itemId, qty);
2618 
2619         _claimAwoo(requestedClaims);
2620         awooContract.spendVirtualAwoo(
2621             approval.Hash,
2622             approval.Sig,
2623             approval.Nonce,
2624             _msgSender(),
2625             qty * item.AWOOPrice
2626         );
2627         awooMintableCollectionContract.mint(_msgSender(), item.TokenId, qty);
2628         mintedItemCountsByAddress[_msgSender()][itemId] += qty;
2629     }
2630 
2631     /// @notice Allows the specified item to be minted with Ether
2632     /// @param itemId The id of the item to mint
2633     /// @param qty The number of items to mint
2634     function mintWithEth(uint16 itemId, uint256 qty)
2635         public
2636         payable
2637         whenStoreActive
2638         nonZeroQuantity(qty)
2639     {
2640         ItemDetail memory item = _validateItem(itemId, PaymentType.ETHER);
2641         require(!item.NonMintable, "Specified item is not mintable");
2642 
2643         _validateRequestedQuantity(itemId, item, qty);
2644         _ensureAvailablity(item, itemId, qty);
2645         _validateEtherValue(item, qty);
2646 
2647         awooMintableCollectionContract.mint(_msgSender(), item.TokenId, qty);
2648         mintedItemCountsByAddress[_msgSender()][itemId] += qty;
2649     }
2650 
2651     /// @notice Allows the specified item to be minted with both AWOO and Ether, if the item supports that
2652     /// @param itemId The id of the item to mint
2653     /// @param qty The number of items to mint
2654     /// @param approval An object containing the signed message details authorizing us to spend the holders AWOO
2655     /// @param requestedClaims An optional array of ClaimDetails so we can automagically claim the necessary
2656     /// amount of AWOO, as specified through NFC
2657     function mintWithEthAndAwoo(
2658         uint16 itemId,
2659         uint256 qty,
2660         AwooSpendApproval calldata approval,
2661         ClaimDetails[] calldata requestedClaims
2662     ) public payable whenStoreActive nonZeroQuantity(qty) {
2663         ItemDetail memory item = _validateItem(
2664             itemId,
2665             PaymentType.AWOO_AND_ETHER
2666         );
2667         require(!item.NonMintable, "Specified item is not mintable");
2668         _validateRequestedQuantity(itemId, item, qty);
2669         _ensureAvailablity(item, itemId, qty);
2670         _validateEtherValue(item, qty);
2671 
2672         _claimAwoo(requestedClaims);
2673         awooContract.spendVirtualAwoo(
2674             approval.Hash,
2675             approval.Sig,
2676             approval.Nonce,
2677             _msgSender(),
2678             qty * item.AWOOPrice
2679         );
2680 
2681         awooMintableCollectionContract.mint(_msgSender(), item.TokenId, qty);
2682         mintedItemCountsByAddress[_msgSender()][itemId] += qty;
2683     }
2684 
2685     /// @notice Allows the specified item to be purchased with AWOO
2686     /// @param itemId The id of the item to purchase
2687     /// @param qty The number of items to purchase
2688     /// @param approval An object containing the signed message details authorizing us to spend the holders AWOO
2689     /// @param requestedClaims An optional array of ClaimDetails so we can automagically claim the necessary
2690     /// amount of AWOO, as specified through NFC
2691     function purchaseWithAwoo(
2692         uint16 itemId,
2693         uint256 qty,
2694         AwooSpendApproval calldata approval,
2695         ClaimDetails[] calldata requestedClaims
2696     ) public whenStoreActive nonZeroQuantity(qty) {
2697         ItemDetail memory item = _validateItem(itemId, PaymentType.AWOO);
2698         _validateRequestedQuantity(itemId, item, qty);
2699         _ensureAvailablity(item, itemId, qty);
2700 
2701         _claimAwoo(requestedClaims);
2702         awooContract.spendVirtualAwoo(
2703             approval.Hash,
2704             approval.Sig,
2705             approval.Nonce,
2706             _msgSender(),
2707             qty * item.AWOOPrice
2708         );
2709 
2710         purchasedItemCount[itemId] += qty;
2711         ownedItemCountsByOwner[_msgSender()][itemId] += qty;
2712         emit ItemPurchased(itemId, _msgSender(), qty);
2713     }
2714 
2715     /// @notice Allows the specified item to be purchased with Ether
2716     /// @param itemId The id of the item to purchase
2717     /// @param qty The numbers of items to purchase
2718     function purchaseWithEth(uint16 itemId, uint256 qty)
2719         public
2720         payable
2721         whenStoreActive
2722         nonZeroQuantity(qty)
2723     {
2724         ItemDetail memory item = _validateItem(itemId, PaymentType.ETHER);
2725         _validateRequestedQuantity(itemId, item, qty);
2726         _ensureAvailablity(item, itemId, qty);
2727         _validateEtherValue(item, qty);
2728 
2729         purchasedItemCount[itemId] += qty;
2730         ownedItemCountsByOwner[_msgSender()][itemId] += qty;
2731         emit ItemPurchased(itemId, _msgSender(), qty);
2732     }
2733 
2734     /// @notice Allows the specified item to be purchased with AWOO and Ether, if the item allows it
2735     /// @param itemId The id of the item to purchase
2736     /// @param qty The number of items to purchase
2737     /// @param approval An object containing the signed message details authorizing us to spend the holders AWOO
2738     /// @param requestedClaims An optional array of ClaimDetails so we can automagically claim the necessary
2739     /// amount of AWOO, as specified through NFC
2740     function purchaseWithEthAndAwoo(
2741         uint16 itemId,
2742         uint256 qty,
2743         AwooSpendApproval calldata approval,
2744         ClaimDetails[] calldata requestedClaims
2745     ) public payable whenStoreActive nonZeroQuantity(qty) {
2746         ItemDetail memory item = _validateItem(
2747             itemId,
2748             PaymentType.AWOO_AND_ETHER
2749         );
2750         _validateRequestedQuantity(itemId, item, qty);
2751         _ensureAvailablity(item, itemId, qty);
2752         _validateEtherValue(item, qty);
2753 
2754         _claimAwoo(requestedClaims);
2755         awooContract.spendVirtualAwoo(
2756             approval.Hash,
2757             approval.Sig,
2758             approval.Nonce,
2759             _msgSender(),
2760             qty * item.AWOOPrice
2761         );
2762 
2763         purchasedItemCount[itemId] += qty;
2764         ownedItemCountsByOwner[_msgSender()][itemId] += qty;
2765         emit ItemPurchased(itemId, _msgSender(), qty);
2766     }
2767 
2768     /// @notice Allows the specified item to be purchased with AWOO and applied to the specified tokens
2769     /// @param itemId The id of the item to purchase
2770     /// @param approval An object containing the signed message details authorizing us to spend the holders AWOO
2771     /// @param requestedClaims An optional array of ClaimDetails so we can automagically claim the necessary
2772     /// amount of AWOO, as specified through NFC
2773     /// @param applicationTokenIds An array of supported token ids to apply the purchased items to
2774     function purchaseAndApplyWithAwoo(
2775         uint16 itemId,
2776         AwooSpendApproval calldata approval,
2777         ClaimDetails[] calldata requestedClaims,
2778         uint32[] calldata applicationTokenIds
2779     ) public whenStoreActive {
2780         ItemDetail memory item = _validateItem(itemId, PaymentType.AWOO);
2781         _validateRequestedQuantity(itemId, item, applicationTokenIds.length);
2782         _ensureAvailablity(item, itemId, applicationTokenIds.length);
2783 
2784         _claimAwoo(requestedClaims);
2785         awooContract.spendVirtualAwoo(
2786             approval.Hash,
2787             approval.Sig,
2788             approval.Nonce,
2789             _msgSender(),
2790             applicationTokenIds.length * item.AWOOPrice
2791         );
2792 
2793         purchasedItemCount[itemId] += applicationTokenIds.length;
2794         _applyItem(itemId, applicationTokenIds);
2795     }
2796 
2797     /// @notice Allows the specified item to be purchased with Ether and applied to the specified tokens
2798     /// @param itemId The id of the item to purchase
2799     /// @param applicationTokenIds An array of supported token ids to apply the purchased items to
2800     function purchaseAndApplyWithEth(
2801         uint16 itemId,
2802         uint32[] calldata applicationTokenIds
2803     ) public payable whenStoreActive {
2804         ItemDetail memory item = _validateItem(itemId, PaymentType.ETHER);
2805         _validateRequestedQuantity(itemId, item, applicationTokenIds.length);
2806         _validateEtherValue(item, applicationTokenIds.length);
2807         _ensureAvailablity(item, itemId, applicationTokenIds.length);
2808 
2809         purchasedItemCount[itemId] += applicationTokenIds.length;
2810         _applyItem(itemId, applicationTokenIds);
2811     }
2812 
2813     /// @notice Allows the specified item to be purchased with AWOO and Ether and applied
2814     /// @param itemId The id of the item to purchase
2815     /// @param approval An object containing the signed message details authorizing us to spend the holders AWOO
2816     /// @param requestedClaims An optional array of ClaimDetails so we can automagically claim the necessary
2817     /// amount of AWOO, as specified through NFC
2818     /// @param applicationTokenIds An array of supported token ids to apply the purchased items to
2819     function purchaseAndApplyWithEthAndAwoo(
2820         uint16 itemId,
2821         AwooSpendApproval calldata approval,
2822         ClaimDetails[] calldata requestedClaims,
2823         uint32[] calldata applicationTokenIds
2824     ) public payable whenStoreActive {
2825         ItemDetail memory item = _validateItem(
2826             itemId,
2827             PaymentType.AWOO_AND_ETHER
2828         );
2829         _validateRequestedQuantity(itemId, item, applicationTokenIds.length);
2830         _validateEtherValue(item, applicationTokenIds.length);
2831         _ensureAvailablity(item, itemId, applicationTokenIds.length);
2832 
2833         _claimAwoo(requestedClaims);
2834         awooContract.spendVirtualAwoo(
2835             approval.Hash,
2836             approval.Sig,
2837             approval.Nonce,
2838             _msgSender(),
2839             applicationTokenIds.length * item.AWOOPrice
2840         );
2841 
2842         purchasedItemCount[itemId] += applicationTokenIds.length;
2843         _applyItem(itemId, applicationTokenIds);
2844     }
2845 
2846     // TODO: Add the free mint/purchase functionality (V2)
2847 
2848     /// @notice Applies the specified item to the list of "upgradeable" tokens
2849     /// @param itemId The id of the item to apply
2850     /// @param applicationTokenIds An array of token ids to which the specified item will be applied
2851     function applyOwnedItem(
2852         uint16 itemId,
2853         uint32[] calldata applicationTokenIds
2854     ) public whenStoreActive {
2855         ItemDetail memory item = _getItem(itemId);
2856         require(
2857             applicationTokenIds.length <=
2858                 ownedItemCountsByOwner[_msgSender()][itemId],
2859             "Exceeds owned quantity"
2860         );
2861 
2862         for (uint256 i; i < applicationTokenIds.length; i++) {
2863             _applyItem(item, itemId, applicationTokenIds[i]);
2864         }
2865 
2866         if (item.Burnable) {
2867             ownedItemCountsByOwner[_msgSender()][itemId] -= applicationTokenIds
2868                 .length;
2869         }
2870     }
2871 
2872     /// @notice Allows the holder of a non-mintable item to "use" it for something (TBA) cool
2873     /// @param itemId The id of the item to use
2874     /// @param qty The number of items to use
2875     function useOwnedItem(uint16 itemId, uint256 qty)
2876         public
2877         whenStoreActive
2878         nonZeroQuantity(qty)
2879     {
2880         ItemDetail memory item = _getItem(itemId);
2881         require(item.Active, "Inactive item");
2882         require(
2883             qty <= ownedItemCountsByOwner[_msgSender()][itemId],
2884             "Exceeds owned quantity"
2885         );
2886 
2887         if (item.Burnable) {
2888             ownedItemCountsByOwner[_msgSender()][itemId] -= qty;
2889         }
2890 
2891         emit NonMintableItemUsed(itemId, _msgSender(), qty);
2892     }
2893 
2894     /// @notice Applies the specified item to the list of "upgradeable" tokens, and burns the item if applicable
2895     /// @dev Tokens can only be burned if the holder has explicitly allowed us to do so
2896     /// @param itemId The id of the item to apply
2897     /// @param applicationTokenIds An array of token ids to which the specified item will be applied
2898     function applyMintedItem(
2899         uint16 itemId,
2900         uint32[] calldata applicationTokenIds
2901     ) public whenStoreActive {
2902         ItemDetail memory item = _getItem(itemId);
2903         require(!item.NonMintable, "Specified item is not mintable");
2904         require(
2905             applicationTokenIds.length <=
2906                 awooMintableCollectionContract.balanceOf(
2907                     _msgSender(),
2908                     item.TokenId
2909                 ),
2910             "Invalid application qty"
2911         );
2912 
2913         for (uint256 i; i < applicationTokenIds.length; i++) {
2914             _applyItem(item, itemId, applicationTokenIds[i]);
2915         }
2916 
2917         if (item.Burnable) {
2918             awooMintableCollectionContract.burn(
2919                 _msgSender(),
2920                 item.TokenId,
2921                 applicationTokenIds.length
2922             );
2923         }
2924     }
2925 
2926     function _applyItem(uint16 itemId, uint32[] calldata applicationTokenIds)
2927         private
2928     {
2929         ItemDetail memory item = _getItem(itemId);
2930         for (uint256 i; i < applicationTokenIds.length; i++) {
2931             _applyItem(item, itemId, applicationTokenIds[i]);
2932         }
2933     }
2934 
2935     function _applyItem(
2936         ItemDetail memory item,
2937         uint16 itemId,
2938         uint32 applicationTokenId
2939     ) private {
2940         require(item.UpgradeDetails.UpgradeItem, "Item cannot be applied");
2941         require(item.Active, "Inactive item");
2942         address collectionAddress = collectionIdAddressMap[
2943             item.UpgradeDetails.ApplicableCollectionId
2944         ];
2945         // Items can only be applied to "upgradable" tokens held by the same account
2946         require(
2947             _msgSender() ==
2948                 ERC721Enumerable(collectionAddress).ownerOf(applicationTokenId),
2949             "Invalid application tokenId"
2950         );
2951 
2952         // Don't allow the item to be applied mutiple times to the same token unless the item is stackable
2953         if (!item.UpgradeDetails.Stackable) {
2954             require(
2955                 tokenAppliedItemCountsByCollection[
2956                     item.UpgradeDetails.ApplicableCollectionId
2957                 ][applicationTokenId][itemId] == 0,
2958                 "Specified item already applied"
2959             );
2960         }
2961 
2962         // If the item should change the base AWOO accrual rate of the item that it is being applied to, do that
2963         // now
2964         if (item.UpgradeDetails.UpgradeBaseAccrualRate > 0) {
2965             awooClaimingContract.overrideTokenAccrualBaseRate(
2966                 collectionAddress,
2967                 applicationTokenId,
2968                 item.UpgradeDetails.UpgradeBaseAccrualRate
2969             );
2970         }
2971 
2972         tokenAppliedItemCountsByCollection[
2973             item.UpgradeDetails.ApplicableCollectionId
2974         ][applicationTokenId][itemId] += 1;
2975         itemApplications[itemId][item.UpgradeDetails.ApplicableCollectionId]
2976             .push(applicationTokenId);
2977 
2978         // Tell NFC that we applied this upgrade so it can do some fun stuff
2979         emit UpgradeItemApplied(itemId, collectionAddress, applicationTokenId);
2980     }
2981 
2982     function _claimAwoo(ClaimDetails[] calldata requestedClaims) private {
2983         if (requestedClaims.length > 0) {
2984             awooClaimingContract.claim(_msgSender(), requestedClaims);
2985         }
2986     }
2987 
2988     function getItemApplications(uint16 itemId, uint8 applicableCollectionId)
2989         external
2990         view
2991         returns (uint256 count, uint256[] memory appliedToTokenIds)
2992     {
2993         count = itemApplications[itemId][applicableCollectionId].length;
2994         appliedToTokenIds = itemApplications[itemId][applicableCollectionId];
2995     }
2996 
2997     /// @notice Allows authorized individuals to add supported ERC721Enumerable collections
2998     function addCollection(address collectionAddress)
2999         external
3000         onlyOwnerOrAdmin
3001         returns (uint8 collectionId)
3002     {
3003         collectionId = ++collectionCount;
3004         collectionIdAddressMap[collectionId] = collectionAddress;
3005     }
3006 
3007     /// @notice Allows authorized individuals to remove supported ERC721Enumerable collections
3008     function removeCollection(uint8 collectionId) external onlyOwnerOrAdmin {
3009         require(collectionId <= collectionCount, "Invalid collectionId");
3010         delete collectionIdAddressMap[collectionId];
3011         collectionCount--;
3012     }
3013 
3014     /// @notice Allows authorized individuals to add new items
3015     function addItem(ItemDetail memory item, uint16 purchasedQty)
3016         external
3017         onlyOwnerOrAdmin
3018         returns (uint16)
3019     {
3020         _validateItem(item);
3021 
3022         if (!item.NonMintable && item.TokenId == 0) {
3023             uint256 tokenId = awooMintableCollectionContract.addToken(
3024                 item.TokenDetails,
3025                 item.MetadataUri
3026             );
3027             item.TokenId = tokenId;
3028         }
3029 
3030         itemIdDetailMap[++itemCount] = item;
3031         purchasedItemCount[itemCount] = purchasedQty;
3032         return itemCount;
3033     }
3034 
3035     /// @notice Allows authorized individuals to update an existing item
3036     function updateItem(
3037         uint16 itemId,
3038         ItemDetail memory newItem
3039     ) external onlyOwnerOrAdmin {
3040         _validateItem(newItem);
3041         ItemDetail memory existingItem = _getItem(itemId);
3042         require(
3043             existingItem.NonMintable == newItem.NonMintable,
3044             "Item mintability cannot change"
3045         );
3046         require(
3047             newItem.TotalAvailable <= _availableQty(existingItem, itemId),
3048             "Total exceeds available quantity"
3049         );
3050 
3051         if (!existingItem.NonMintable) {
3052             newItem.TokenId = existingItem.TokenId;
3053 
3054             if (
3055                 bytes(newItem.MetadataUri).length !=
3056                 bytes(existingItem.MetadataUri).length ||
3057                 keccak256(abi.encodePacked(newItem.MetadataUri)) !=
3058                 keccak256(abi.encodePacked(existingItem.MetadataUri))
3059             ) {
3060                 awooMintableCollectionContract.setTokenUri(
3061                     existingItem.TokenId,
3062                     newItem.MetadataUri
3063                 );
3064             }
3065 
3066             if (newItem.Active != existingItem.Active) {
3067                 awooMintableCollectionContract.setTokenActive(
3068                     existingItem.TokenId,
3069                     newItem.Active
3070                 );
3071             }
3072         }
3073 
3074         itemIdDetailMap[itemId] = newItem;
3075     }
3076 
3077     function _validateRequestedQuantity(
3078         uint16 itemId,
3079         ItemDetail memory item,
3080         uint256 requestedQty
3081     ) private view {
3082         require(
3083             _isWithinTransactionLimit(item, requestedQty),
3084             "Exceeds transaction limit"
3085         );
3086         require(
3087             _isWithinAddressLimit(itemId, item, requestedQty, _msgSender()),
3088             "Exceeds address limit"
3089         );
3090     }
3091 
3092     function _ensureAvailablity(
3093         ItemDetail memory item,
3094         uint16 itemId,
3095         uint256 requestedQty
3096     ) private view {
3097         require(
3098             requestedQty <= _availableQty(item, itemId),
3099             "Exceeds available quantity"
3100         );
3101     }
3102 
3103     function availableQty(uint16 itemId) public view returns (uint256) {
3104         ItemDetail memory item = _getItem(itemId);
3105         return _availableQty(item, itemId);
3106     }
3107 
3108     function _availableQty(ItemDetail memory item, uint16 itemId)
3109         private
3110         view
3111         returns (uint256)
3112     {
3113         uint256 mintedCount;
3114 
3115         // If the item is mintable, get the minted quantity from the ERC-1155 contract.
3116         // The minted count includes the quantity that was burned if the item does not have a soft limit
3117         if (!item.NonMintable) {
3118             mintedCount = awooMintableCollectionContract.totalMinted(
3119                 item.TokenId
3120             );
3121         }
3122         return item.TotalAvailable - mintedCount - purchasedItemCount[itemId];
3123     }
3124 
3125     /// @notice Determines if the requested quantity is within the per-transaction limit defined by this item
3126     function _isWithinTransactionLimit(
3127         ItemDetail memory item,
3128         uint256 requestedQty
3129     ) private pure returns (bool) {
3130         if (item.PerTransactionLimit > 0) {
3131             return requestedQty <= item.PerTransactionLimit;
3132         }
3133         return true;
3134     }
3135 
3136     /// @notice Determines if the requested quantity is within the per-address limit defined by this item
3137     function _isWithinAddressLimit(
3138         uint16 itemId,
3139         ItemDetail memory item,
3140         uint256 requestedQty,
3141         address recipient
3142     ) private view returns (bool) {
3143         if (item.PerAddressLimit > 0) {
3144             uint256 tokenCountByOwner = item.NonMintable
3145                 ? ownedItemCountsByOwner[recipient][itemId]
3146                 : ownedItemCountsByOwner[recipient][itemId] +
3147                     mintedItemCountsByAddress[recipient][itemId];
3148 
3149             return tokenCountByOwner + requestedQty <= item.PerAddressLimit;
3150         }
3151         return true;
3152     }
3153 
3154     /// @notice Returns an array of tokenIds and application counts to indicate how many of the specified items
3155     /// were applied to the specified tokenIds
3156     function checkItemTokenApplicationStatus(
3157         uint8 collectionId,
3158         uint16 itemId,
3159         uint256[] calldata tokenIds
3160     ) external view returns (uint256[] memory, uint256[] memory) {
3161         uint256[] memory checkedTokenIds = new uint256[](tokenIds.length);
3162         uint256[] memory applicationCounts = new uint256[](tokenIds.length);
3163 
3164         for (uint256 i; i < tokenIds.length; i++) {
3165             uint32 tokenId = uint32(tokenIds[i]);
3166 
3167             checkedTokenIds[i] = tokenId;
3168             applicationCounts[i] = tokenAppliedItemCountsByCollection[
3169                 collectionId
3170             ][tokenId][itemId];
3171         }
3172 
3173         return (checkedTokenIds, applicationCounts);
3174     }
3175 
3176     function _validateEtherValue(ItemDetail memory item, uint256 qty) private {
3177         require(msg.value == item.EtherPrice * qty, "Incorrect amount");
3178     }
3179 
3180     function _getItem(uint16 itemId)
3181         private
3182         view
3183         returns (ItemDetail memory item)
3184     {
3185         require(itemId <= itemCount, "Invalid itemId");
3186         item = itemIdDetailMap[itemId];
3187     }
3188 
3189     function _validateItem(uint16 itemId, PaymentType paymentType)
3190         private
3191         view
3192         returns (ItemDetail memory item)
3193     {
3194         item = _getItem(itemId);
3195         require(item.Active, "Inactive item");
3196         require(item.PmtType == paymentType, "Invalid item for payment type");
3197     }
3198 
3199     function _validateItem(ItemDetail memory item) private view {
3200         require(item.TotalAvailable > 0, "Total available cannot be zero");
3201         require(
3202             !(item.UpgradeDetails.Stackable && item.PerAddressLimit == 1),
3203             "Invalid per-address limit"
3204         );
3205 
3206         if (!item.NonMintable) {
3207             require(
3208                 bytes(item.MetadataUri).length > 0,
3209                 "Item requires a metadata uri"
3210             );
3211         }
3212 
3213         if (item.UpgradeDetails.UpgradeItem) {
3214             require(
3215                 item.UpgradeDetails.ApplicableCollectionId <= collectionCount,
3216                 "Invalid applicableCollectionId"
3217             );
3218         } else {
3219             require(
3220                 item.UpgradeDetails.ApplicableCollectionId == 0,
3221                 "Invalid applicableCollectionId"
3222             );
3223         }
3224 
3225         if (item.PmtType == PaymentType.ETHER) {
3226             require(item.EtherPrice > 0, "Invalid ether price");
3227             require(item.AWOOPrice == 0, "Invalid AWOO price");
3228         } else if (item.PmtType == PaymentType.AWOO) {
3229             require(item.EtherPrice == 0, "Invalid ether price");
3230             require(
3231                 item.AWOOPrice == ((item.AWOOPrice / 1e18) * 1e18),
3232                 "Invalid AWOO price"
3233             );
3234         } else if (item.PmtType == PaymentType.AWOO_AND_ETHER) {
3235             require(item.EtherPrice > 0, "Invalid ether price");
3236             require(
3237                 item.AWOOPrice == ((item.AWOOPrice / 1e18) * 1e18),
3238                 "Invalid AWOO price"
3239             );
3240         }
3241         // free
3242         else {
3243             revert("Not implemented, yet");
3244         }
3245     }
3246 
3247     /// @notice Allows authorized individuals to swap out claiming contract
3248     function setAwooClaimingContract(IAwooClaimingV2 awooClaiming)
3249         external
3250         onlyOwnerOrAdmin
3251     {
3252         awooClaimingContract = IAwooClaimingV2(awooClaiming);
3253     }
3254 
3255     /// @notice Allows authorized individuals to swap out the ERC-1155 collection contract, if absolutely necessary
3256     function setAwooCollection(IAwooMintableCollection awooCollectionContract)
3257         external
3258         onlyOwnerOrAdmin
3259     {
3260         awooMintableCollectionContract = awooCollectionContract;
3261     }
3262 
3263     /// @notice Allows authorized individuals to swap out the ERC-20 AWOO contract, if absolutely necessary
3264     function setAwooTokenContract(IAwooToken awooTokenContract)
3265         external
3266         onlyOwnerOrAdmin
3267     {
3268         awooContract = awooTokenContract;
3269     }
3270 
3271     /// @notice Allows authorized individuals to activate/deactivate this contract
3272     function setActive(bool active) external onlyOwnerOrAdmin {
3273         if (active) {
3274             require(
3275                 address(awooMintableCollectionContract) != address(0),
3276                 "Awoo collection has not been set"
3277             );
3278         }
3279         storeActive = active;
3280     }
3281 
3282     /// @notice Allows authorized individuals to activate/deactivate specific items
3283     function setItemActive(uint16 itemId, bool isActive)
3284         external
3285         onlyOwnerOrAdmin
3286     {
3287         require(itemId > 0 && itemId <= itemCount, "Invalid Item Id");
3288 
3289         itemIdDetailMap[itemId].Active = isActive;
3290     }
3291 
3292     /// @notice Allows authorized individuals to specify which address Ether and other arbitrary ERC-20 tokens
3293     /// should be sent to during withdraw
3294     function setWithdrawAddress(address payable addr)
3295         external
3296         onlyOwnerOrAdmin
3297     {
3298         require(addr != address(0), "Invalid address");
3299         withdrawAddress = addr;
3300     }
3301 
3302     function withdraw(uint256 amount) external onlyOwnerOrAdmin {
3303         require(amount <= address(this).balance, "Amount exceeds balance");
3304         require(payable(withdrawAddress).send(amount), "Sending failed");
3305     }
3306 
3307     /// @dev Any random ERC-20 tokens sent to this contract will be locked forever, unless we rescue them
3308     function rescueArbitraryERC20(IERC20 token) external {
3309         uint256 balance = token.balanceOf(address(this));
3310 
3311         require(balance > 0, "Contract has no balance");
3312         require(
3313             token.transfer(payable(withdrawAddress), balance),
3314             "Transfer failed"
3315         );
3316     }
3317 
3318     modifier nonZeroQuantity(uint256 qty) {
3319         require(qty > 0, "Quantity cannot be zero");
3320         _;
3321     }
3322 
3323     modifier whenStoreActive() {
3324         require(storeActive, "Awoo Store is not active");
3325         _;
3326     }
3327 }