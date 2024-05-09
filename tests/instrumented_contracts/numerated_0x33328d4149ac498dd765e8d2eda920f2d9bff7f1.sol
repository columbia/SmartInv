1 // File: @openzeppelin/contracts/utils/Counters.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @title Counters
10  * @author Matt Condon (@shrugs)
11  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
12  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
13  *
14  * Include with `using Counters for Counters.Counter;`
15  */
16 library Counters {
17     struct Counter {
18         // This variable should never be directly accessed by users of the library: interactions must be restricted to
19         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
20         // this feature: see https://github.com/ethereum/solidity/issues/4637
21         uint256 _value; // default: 0
22     }
23 
24     function current(Counter storage counter) internal view returns (uint256) {
25         return counter._value;
26     }
27 
28     function increment(Counter storage counter) internal {
29         unchecked {
30             counter._value += 1;
31         }
32     }
33 
34     function decrement(Counter storage counter) internal {
35         uint256 value = counter._value;
36         require(value > 0, "Counter: decrement overflow");
37         unchecked {
38             counter._value = value - 1;
39         }
40     }
41 
42     function reset(Counter storage counter) internal {
43         counter._value = 0;
44     }
45 }
46 
47 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
48 
49 
50 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
51 
52 pragma solidity ^0.8.0;
53 
54 /**
55  * @dev Interface of the ERC20 standard as defined in the EIP.
56  */
57 interface IERC20 {
58     /**
59      * @dev Returns the amount of tokens in existence.
60      */
61     function totalSupply() external view returns (uint256);
62 
63     /**
64      * @dev Returns the amount of tokens owned by `account`.
65      */
66     function balanceOf(address account) external view returns (uint256);
67 
68     /**
69      * @dev Moves `amount` tokens from the caller's account to `recipient`.
70      *
71      * Returns a boolean value indicating whether the operation succeeded.
72      *
73      * Emits a {Transfer} event.
74      */
75     function transfer(address recipient, uint256 amount) external returns (bool);
76 
77     /**
78      * @dev Returns the remaining number of tokens that `spender` will be
79      * allowed to spend on behalf of `owner` through {transferFrom}. This is
80      * zero by default.
81      *
82      * This value changes when {approve} or {transferFrom} are called.
83      */
84     function allowance(address owner, address spender) external view returns (uint256);
85 
86     /**
87      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
88      *
89      * Returns a boolean value indicating whether the operation succeeded.
90      *
91      * IMPORTANT: Beware that changing an allowance with this method brings the risk
92      * that someone may use both the old and the new allowance by unfortunate
93      * transaction ordering. One possible solution to mitigate this race
94      * condition is to first reduce the spender's allowance to 0 and set the
95      * desired value afterwards:
96      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
97      *
98      * Emits an {Approval} event.
99      */
100     function approve(address spender, uint256 amount) external returns (bool);
101 
102     /**
103      * @dev Moves `amount` tokens from `sender` to `recipient` using the
104      * allowance mechanism. `amount` is then deducted from the caller's
105      * allowance.
106      *
107      * Returns a boolean value indicating whether the operation succeeded.
108      *
109      * Emits a {Transfer} event.
110      */
111     function transferFrom(
112         address sender,
113         address recipient,
114         uint256 amount
115     ) external returns (bool);
116 
117     /**
118      * @dev Emitted when `value` tokens are moved from one account (`from`) to
119      * another (`to`).
120      *
121      * Note that `value` may be zero.
122      */
123     event Transfer(address indexed from, address indexed to, uint256 value);
124 
125     /**
126      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
127      * a call to {approve}. `value` is the new allowance.
128      */
129     event Approval(address indexed owner, address indexed spender, uint256 value);
130 }
131 
132 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
133 
134 
135 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/MerkleProof.sol)
136 
137 pragma solidity ^0.8.0;
138 
139 /**
140  * @dev These functions deal with verification of Merkle Trees proofs.
141  *
142  * The proofs can be generated using the JavaScript library
143  * https://github.com/miguelmota/merkletreejs[merkletreejs].
144  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
145  *
146  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
147  */
148 library MerkleProof {
149     /**
150      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
151      * defined by `root`. For this, a `proof` must be provided, containing
152      * sibling hashes on the branch from the leaf to the root of the tree. Each
153      * pair of leaves and each pair of pre-images are assumed to be sorted.
154      */
155     function verify(
156         bytes32[] memory proof,
157         bytes32 root,
158         bytes32 leaf
159     ) internal pure returns (bool) {
160         return processProof(proof, leaf) == root;
161     }
162 
163     /**
164      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
165      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
166      * hash matches the root of the tree. When processing the proof, the pairs
167      * of leafs & pre-images are assumed to be sorted.
168      *
169      * _Available since v4.4._
170      */
171     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
172         bytes32 computedHash = leaf;
173         for (uint256 i = 0; i < proof.length; i++) {
174             bytes32 proofElement = proof[i];
175             if (computedHash <= proofElement) {
176                 // Hash(current computed hash + current element of the proof)
177                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
178             } else {
179                 // Hash(current element of the proof + current computed hash)
180                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
181             }
182         }
183         return computedHash;
184     }
185 }
186 
187 // File: @openzeppelin/contracts/utils/Strings.sol
188 
189 
190 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
191 
192 pragma solidity ^0.8.0;
193 
194 /**
195  * @dev String operations.
196  */
197 library Strings {
198     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
199 
200     /**
201      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
202      */
203     function toString(uint256 value) internal pure returns (string memory) {
204         // Inspired by OraclizeAPI's implementation - MIT licence
205         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
206 
207         if (value == 0) {
208             return "0";
209         }
210         uint256 temp = value;
211         uint256 digits;
212         while (temp != 0) {
213             digits++;
214             temp /= 10;
215         }
216         bytes memory buffer = new bytes(digits);
217         while (value != 0) {
218             digits -= 1;
219             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
220             value /= 10;
221         }
222         return string(buffer);
223     }
224 
225     /**
226      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
227      */
228     function toHexString(uint256 value) internal pure returns (string memory) {
229         if (value == 0) {
230             return "0x00";
231         }
232         uint256 temp = value;
233         uint256 length = 0;
234         while (temp != 0) {
235             length++;
236             temp >>= 8;
237         }
238         return toHexString(value, length);
239     }
240 
241     /**
242      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
243      */
244     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
245         bytes memory buffer = new bytes(2 * length + 2);
246         buffer[0] = "0";
247         buffer[1] = "x";
248         for (uint256 i = 2 * length + 1; i > 1; --i) {
249             buffer[i] = _HEX_SYMBOLS[value & 0xf];
250             value >>= 4;
251         }
252         require(value == 0, "Strings: hex length insufficient");
253         return string(buffer);
254     }
255 }
256 
257 // File: @openzeppelin/contracts/utils/Context.sol
258 
259 
260 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
261 
262 pragma solidity ^0.8.0;
263 
264 /**
265  * @dev Provides information about the current execution context, including the
266  * sender of the transaction and its data. While these are generally available
267  * via msg.sender and msg.data, they should not be accessed in such a direct
268  * manner, since when dealing with meta-transactions the account sending and
269  * paying for execution may not be the actual sender (as far as an application
270  * is concerned).
271  *
272  * This contract is only required for intermediate, library-like contracts.
273  */
274 abstract contract Context {
275     function _msgSender() internal view virtual returns (address) {
276         return msg.sender;
277     }
278 
279     function _msgData() internal view virtual returns (bytes calldata) {
280         return msg.data;
281     }
282 }
283 
284 // File: @openzeppelin/contracts/access/Ownable.sol
285 
286 
287 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
288 
289 pragma solidity ^0.8.0;
290 
291 
292 /**
293  * @dev Contract module which provides a basic access control mechanism, where
294  * there is an account (an owner) that can be granted exclusive access to
295  * specific functions.
296  *
297  * By default, the owner account will be the one that deploys the contract. This
298  * can later be changed with {transferOwnership}.
299  *
300  * This module is used through inheritance. It will make available the modifier
301  * `onlyOwner`, which can be applied to your functions to restrict their use to
302  * the owner.
303  */
304 abstract contract Ownable is Context {
305     address private _owner;
306 
307     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
308 
309     /**
310      * @dev Initializes the contract setting the deployer as the initial owner.
311      */
312     constructor() {
313         _transferOwnership(_msgSender());
314     }
315 
316     /**
317      * @dev Returns the address of the current owner.
318      */
319     function owner() public view virtual returns (address) {
320         return _owner;
321     }
322 
323     /**
324      * @dev Throws if called by any account other than the owner.
325      */
326     modifier onlyOwner() {
327         require(owner() == _msgSender(), "Ownable: caller is not the owner");
328         _;
329     }
330 
331     /**
332      * @dev Leaves the contract without owner. It will not be possible to call
333      * `onlyOwner` functions anymore. Can only be called by the current owner.
334      *
335      * NOTE: Renouncing ownership will leave the contract without an owner,
336      * thereby removing any functionality that is only available to the owner.
337      */
338     function renounceOwnership() public virtual onlyOwner {
339         _transferOwnership(address(0));
340     }
341 
342     /**
343      * @dev Transfers ownership of the contract to a new account (`newOwner`).
344      * Can only be called by the current owner.
345      */
346     function transferOwnership(address newOwner) public virtual onlyOwner {
347         require(newOwner != address(0), "Ownable: new owner is the zero address");
348         _transferOwnership(newOwner);
349     }
350 
351     /**
352      * @dev Transfers ownership of the contract to a new account (`newOwner`).
353      * Internal function without access restriction.
354      */
355     function _transferOwnership(address newOwner) internal virtual {
356         address oldOwner = _owner;
357         _owner = newOwner;
358         emit OwnershipTransferred(oldOwner, newOwner);
359     }
360 }
361 
362 // File: @openzeppelin/contracts/utils/Address.sol
363 
364 
365 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
366 
367 pragma solidity ^0.8.0;
368 
369 /**
370  * @dev Collection of functions related to the address type
371  */
372 library Address {
373     /**
374      * @dev Returns true if `account` is a contract.
375      *
376      * [IMPORTANT]
377      * ====
378      * It is unsafe to assume that an address for which this function returns
379      * false is an externally-owned account (EOA) and not a contract.
380      *
381      * Among others, `isContract` will return false for the following
382      * types of addresses:
383      *
384      *  - an externally-owned account
385      *  - a contract in construction
386      *  - an address where a contract will be created
387      *  - an address where a contract lived, but was destroyed
388      * ====
389      */
390     function isContract(address account) internal view returns (bool) {
391         // This method relies on extcodesize, which returns 0 for contracts in
392         // construction, since the code is only stored at the end of the
393         // constructor execution.
394 
395         uint256 size;
396         assembly {
397             size := extcodesize(account)
398         }
399         return size > 0;
400     }
401 
402     /**
403      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
404      * `recipient`, forwarding all available gas and reverting on errors.
405      *
406      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
407      * of certain opcodes, possibly making contracts go over the 2300 gas limit
408      * imposed by `transfer`, making them unable to receive funds via
409      * `transfer`. {sendValue} removes this limitation.
410      *
411      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
412      *
413      * IMPORTANT: because control is transferred to `recipient`, care must be
414      * taken to not create reentrancy vulnerabilities. Consider using
415      * {ReentrancyGuard} or the
416      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
417      */
418     function sendValue(address payable recipient, uint256 amount) internal {
419         require(address(this).balance >= amount, "Address: insufficient balance");
420 
421         (bool success, ) = recipient.call{value: amount}("");
422         require(success, "Address: unable to send value, recipient may have reverted");
423     }
424 
425     /**
426      * @dev Performs a Solidity function call using a low level `call`. A
427      * plain `call` is an unsafe replacement for a function call: use this
428      * function instead.
429      *
430      * If `target` reverts with a revert reason, it is bubbled up by this
431      * function (like regular Solidity function calls).
432      *
433      * Returns the raw returned data. To convert to the expected return value,
434      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
435      *
436      * Requirements:
437      *
438      * - `target` must be a contract.
439      * - calling `target` with `data` must not revert.
440      *
441      * _Available since v3.1._
442      */
443     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
444         return functionCall(target, data, "Address: low-level call failed");
445     }
446 
447     /**
448      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
449      * `errorMessage` as a fallback revert reason when `target` reverts.
450      *
451      * _Available since v3.1._
452      */
453     function functionCall(
454         address target,
455         bytes memory data,
456         string memory errorMessage
457     ) internal returns (bytes memory) {
458         return functionCallWithValue(target, data, 0, errorMessage);
459     }
460 
461     /**
462      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
463      * but also transferring `value` wei to `target`.
464      *
465      * Requirements:
466      *
467      * - the calling contract must have an ETH balance of at least `value`.
468      * - the called Solidity function must be `payable`.
469      *
470      * _Available since v3.1._
471      */
472     function functionCallWithValue(
473         address target,
474         bytes memory data,
475         uint256 value
476     ) internal returns (bytes memory) {
477         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
478     }
479 
480     /**
481      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
482      * with `errorMessage` as a fallback revert reason when `target` reverts.
483      *
484      * _Available since v3.1._
485      */
486     function functionCallWithValue(
487         address target,
488         bytes memory data,
489         uint256 value,
490         string memory errorMessage
491     ) internal returns (bytes memory) {
492         require(address(this).balance >= value, "Address: insufficient balance for call");
493         require(isContract(target), "Address: call to non-contract");
494 
495         (bool success, bytes memory returndata) = target.call{value: value}(data);
496         return verifyCallResult(success, returndata, errorMessage);
497     }
498 
499     /**
500      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
501      * but performing a static call.
502      *
503      * _Available since v3.3._
504      */
505     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
506         return functionStaticCall(target, data, "Address: low-level static call failed");
507     }
508 
509     /**
510      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
511      * but performing a static call.
512      *
513      * _Available since v3.3._
514      */
515     function functionStaticCall(
516         address target,
517         bytes memory data,
518         string memory errorMessage
519     ) internal view returns (bytes memory) {
520         require(isContract(target), "Address: static call to non-contract");
521 
522         (bool success, bytes memory returndata) = target.staticcall(data);
523         return verifyCallResult(success, returndata, errorMessage);
524     }
525 
526     /**
527      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
528      * but performing a delegate call.
529      *
530      * _Available since v3.4._
531      */
532     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
533         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
534     }
535 
536     /**
537      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
538      * but performing a delegate call.
539      *
540      * _Available since v3.4._
541      */
542     function functionDelegateCall(
543         address target,
544         bytes memory data,
545         string memory errorMessage
546     ) internal returns (bytes memory) {
547         require(isContract(target), "Address: delegate call to non-contract");
548 
549         (bool success, bytes memory returndata) = target.delegatecall(data);
550         return verifyCallResult(success, returndata, errorMessage);
551     }
552 
553     /**
554      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
555      * revert reason using the provided one.
556      *
557      * _Available since v4.3._
558      */
559     function verifyCallResult(
560         bool success,
561         bytes memory returndata,
562         string memory errorMessage
563     ) internal pure returns (bytes memory) {
564         if (success) {
565             return returndata;
566         } else {
567             // Look for revert reason and bubble it up if present
568             if (returndata.length > 0) {
569                 // The easiest way to bubble the revert reason is using memory via assembly
570 
571                 assembly {
572                     let returndata_size := mload(returndata)
573                     revert(add(32, returndata), returndata_size)
574                 }
575             } else {
576                 revert(errorMessage);
577             }
578         }
579     }
580 }
581 
582 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
583 
584 
585 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
586 
587 pragma solidity ^0.8.0;
588 
589 
590 
591 /**
592  * @title SafeERC20
593  * @dev Wrappers around ERC20 operations that throw on failure (when the token
594  * contract returns false). Tokens that return no value (and instead revert or
595  * throw on failure) are also supported, non-reverting calls are assumed to be
596  * successful.
597  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
598  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
599  */
600 library SafeERC20 {
601     using Address for address;
602 
603     function safeTransfer(
604         IERC20 token,
605         address to,
606         uint256 value
607     ) internal {
608         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
609     }
610 
611     function safeTransferFrom(
612         IERC20 token,
613         address from,
614         address to,
615         uint256 value
616     ) internal {
617         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
618     }
619 
620     /**
621      * @dev Deprecated. This function has issues similar to the ones found in
622      * {IERC20-approve}, and its usage is discouraged.
623      *
624      * Whenever possible, use {safeIncreaseAllowance} and
625      * {safeDecreaseAllowance} instead.
626      */
627     function safeApprove(
628         IERC20 token,
629         address spender,
630         uint256 value
631     ) internal {
632         // safeApprove should only be called when setting an initial allowance,
633         // or when resetting it to zero. To increase and decrease it, use
634         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
635         require(
636             (value == 0) || (token.allowance(address(this), spender) == 0),
637             "SafeERC20: approve from non-zero to non-zero allowance"
638         );
639         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
640     }
641 
642     function safeIncreaseAllowance(
643         IERC20 token,
644         address spender,
645         uint256 value
646     ) internal {
647         uint256 newAllowance = token.allowance(address(this), spender) + value;
648         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
649     }
650 
651     function safeDecreaseAllowance(
652         IERC20 token,
653         address spender,
654         uint256 value
655     ) internal {
656         unchecked {
657             uint256 oldAllowance = token.allowance(address(this), spender);
658             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
659             uint256 newAllowance = oldAllowance - value;
660             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
661         }
662     }
663 
664     /**
665      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
666      * on the return value: the return value is optional (but if data is returned, it must not be false).
667      * @param token The token targeted by the call.
668      * @param data The call data (encoded using abi.encode or one of its variants).
669      */
670     function _callOptionalReturn(IERC20 token, bytes memory data) private {
671         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
672         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
673         // the target address contains contract code and also asserts for success in the low-level call.
674 
675         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
676         if (returndata.length > 0) {
677             // Return data is optional
678             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
679         }
680     }
681 }
682 
683 // File: @openzeppelin/contracts/finance/PaymentSplitter.sol
684 
685 
686 // OpenZeppelin Contracts v4.4.1 (finance/PaymentSplitter.sol)
687 
688 pragma solidity ^0.8.0;
689 
690 
691 
692 
693 /**
694  * @title PaymentSplitter
695  * @dev This contract allows to split Ether payments among a group of accounts. The sender does not need to be aware
696  * that the Ether will be split in this way, since it is handled transparently by the contract.
697  *
698  * The split can be in equal parts or in any other arbitrary proportion. The way this is specified is by assigning each
699  * account to a number of shares. Of all the Ether that this contract receives, each account will then be able to claim
700  * an amount proportional to the percentage of total shares they were assigned.
701  *
702  * `PaymentSplitter` follows a _pull payment_ model. This means that payments are not automatically forwarded to the
703  * accounts but kept in this contract, and the actual transfer is triggered as a separate step by calling the {release}
704  * function.
705  *
706  * NOTE: This contract assumes that ERC20 tokens will behave similarly to native tokens (Ether). Rebasing tokens, and
707  * tokens that apply fees during transfers, are likely to not be supported as expected. If in doubt, we encourage you
708  * to run tests before sending real value to this contract.
709  */
710 contract PaymentSplitter is Context {
711     event PayeeAdded(address account, uint256 shares);
712     event PaymentReleased(address to, uint256 amount);
713     event ERC20PaymentReleased(IERC20 indexed token, address to, uint256 amount);
714     event PaymentReceived(address from, uint256 amount);
715 
716     uint256 private _totalShares;
717     uint256 private _totalReleased;
718 
719     mapping(address => uint256) private _shares;
720     mapping(address => uint256) private _released;
721     address[] private _payees;
722 
723     mapping(IERC20 => uint256) private _erc20TotalReleased;
724     mapping(IERC20 => mapping(address => uint256)) private _erc20Released;
725 
726     /**
727      * @dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at
728      * the matching position in the `shares` array.
729      *
730      * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no
731      * duplicates in `payees`.
732      */
733     constructor(address[] memory payees, uint256[] memory shares_) payable {
734         require(payees.length == shares_.length, "PaymentSplitter: payees and shares length mismatch");
735         require(payees.length > 0, "PaymentSplitter: no payees");
736 
737         for (uint256 i = 0; i < payees.length; i++) {
738             _addPayee(payees[i], shares_[i]);
739         }
740     }
741 
742     /**
743      * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully
744      * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
745      * reliability of the events, and not the actual splitting of Ether.
746      *
747      * To learn more about this see the Solidity documentation for
748      * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
749      * functions].
750      */
751     receive() external payable virtual {
752         emit PaymentReceived(_msgSender(), msg.value);
753     }
754 
755     /**
756      * @dev Getter for the total shares held by payees.
757      */
758     function totalShares() public view returns (uint256) {
759         return _totalShares;
760     }
761 
762     /**
763      * @dev Getter for the total amount of Ether already released.
764      */
765     function totalReleased() public view returns (uint256) {
766         return _totalReleased;
767     }
768 
769     /**
770      * @dev Getter for the total amount of `token` already released. `token` should be the address of an IERC20
771      * contract.
772      */
773     function totalReleased(IERC20 token) public view returns (uint256) {
774         return _erc20TotalReleased[token];
775     }
776 
777     /**
778      * @dev Getter for the amount of shares held by an account.
779      */
780     function shares(address account) public view returns (uint256) {
781         return _shares[account];
782     }
783 
784     /**
785      * @dev Getter for the amount of Ether already released to a payee.
786      */
787     function released(address account) public view returns (uint256) {
788         return _released[account];
789     }
790 
791     /**
792      * @dev Getter for the amount of `token` tokens already released to a payee. `token` should be the address of an
793      * IERC20 contract.
794      */
795     function released(IERC20 token, address account) public view returns (uint256) {
796         return _erc20Released[token][account];
797     }
798 
799     /**
800      * @dev Getter for the address of the payee number `index`.
801      */
802     function payee(uint256 index) public view returns (address) {
803         return _payees[index];
804     }
805 
806     /**
807      * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
808      * total shares and their previous withdrawals.
809      */
810     function release(address payable account) public virtual {
811         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
812 
813         uint256 totalReceived = address(this).balance + totalReleased();
814         uint256 payment = _pendingPayment(account, totalReceived, released(account));
815 
816         require(payment != 0, "PaymentSplitter: account is not due payment");
817 
818         _released[account] += payment;
819         _totalReleased += payment;
820 
821         Address.sendValue(account, payment);
822         emit PaymentReleased(account, payment);
823     }
824 
825     /**
826      * @dev Triggers a transfer to `account` of the amount of `token` tokens they are owed, according to their
827      * percentage of the total shares and their previous withdrawals. `token` must be the address of an IERC20
828      * contract.
829      */
830     function release(IERC20 token, address account) public virtual {
831         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
832 
833         uint256 totalReceived = token.balanceOf(address(this)) + totalReleased(token);
834         uint256 payment = _pendingPayment(account, totalReceived, released(token, account));
835 
836         require(payment != 0, "PaymentSplitter: account is not due payment");
837 
838         _erc20Released[token][account] += payment;
839         _erc20TotalReleased[token] += payment;
840 
841         SafeERC20.safeTransfer(token, account, payment);
842         emit ERC20PaymentReleased(token, account, payment);
843     }
844 
845     /**
846      * @dev internal logic for computing the pending payment of an `account` given the token historical balances and
847      * already released amounts.
848      */
849     function _pendingPayment(
850         address account,
851         uint256 totalReceived,
852         uint256 alreadyReleased
853     ) private view returns (uint256) {
854         return (totalReceived * _shares[account]) / _totalShares - alreadyReleased;
855     }
856 
857     /**
858      * @dev Add a new payee to the contract.
859      * @param account The address of the payee to add.
860      * @param shares_ The number of shares owned by the payee.
861      */
862     function _addPayee(address account, uint256 shares_) private {
863         require(account != address(0), "PaymentSplitter: account is the zero address");
864         require(shares_ > 0, "PaymentSplitter: shares are 0");
865         require(_shares[account] == 0, "PaymentSplitter: account already has shares");
866 
867         _payees.push(account);
868         _shares[account] = shares_;
869         _totalShares = _totalShares + shares_;
870         emit PayeeAdded(account, shares_);
871     }
872 }
873 
874 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
875 
876 
877 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
878 
879 pragma solidity ^0.8.0;
880 
881 /**
882  * @title ERC721 token receiver interface
883  * @dev Interface for any contract that wants to support safeTransfers
884  * from ERC721 asset contracts.
885  */
886 interface IERC721Receiver {
887     /**
888      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
889      * by `operator` from `from`, this function is called.
890      *
891      * It must return its Solidity selector to confirm the token transfer.
892      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
893      *
894      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
895      */
896     function onERC721Received(
897         address operator,
898         address from,
899         uint256 tokenId,
900         bytes calldata data
901     ) external returns (bytes4);
902 }
903 
904 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
905 
906 
907 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
908 
909 pragma solidity ^0.8.0;
910 
911 /**
912  * @dev Interface of the ERC165 standard, as defined in the
913  * https://eips.ethereum.org/EIPS/eip-165[EIP].
914  *
915  * Implementers can declare support of contract interfaces, which can then be
916  * queried by others ({ERC165Checker}).
917  *
918  * For an implementation, see {ERC165}.
919  */
920 interface IERC165 {
921     /**
922      * @dev Returns true if this contract implements the interface defined by
923      * `interfaceId`. See the corresponding
924      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
925      * to learn more about how these ids are created.
926      *
927      * This function call must use less than 30 000 gas.
928      */
929     function supportsInterface(bytes4 interfaceId) external view returns (bool);
930 }
931 
932 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
933 
934 
935 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
936 
937 pragma solidity ^0.8.0;
938 
939 
940 /**
941  * @dev Implementation of the {IERC165} interface.
942  *
943  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
944  * for the additional interface id that will be supported. For example:
945  *
946  * ```solidity
947  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
948  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
949  * }
950  * ```
951  *
952  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
953  */
954 abstract contract ERC165 is IERC165 {
955     /**
956      * @dev See {IERC165-supportsInterface}.
957      */
958     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
959         return interfaceId == type(IERC165).interfaceId;
960     }
961 }
962 
963 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
964 
965 
966 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
967 
968 pragma solidity ^0.8.0;
969 
970 
971 /**
972  * @dev Required interface of an ERC721 compliant contract.
973  */
974 interface IERC721 is IERC165 {
975     /**
976      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
977      */
978     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
979 
980     /**
981      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
982      */
983     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
984 
985     /**
986      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
987      */
988     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
989 
990     /**
991      * @dev Returns the number of tokens in ``owner``'s account.
992      */
993     function balanceOf(address owner) external view returns (uint256 balance);
994 
995     /**
996      * @dev Returns the owner of the `tokenId` token.
997      *
998      * Requirements:
999      *
1000      * - `tokenId` must exist.
1001      */
1002     function ownerOf(uint256 tokenId) external view returns (address owner);
1003 
1004     /**
1005      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1006      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1007      *
1008      * Requirements:
1009      *
1010      * - `from` cannot be the zero address.
1011      * - `to` cannot be the zero address.
1012      * - `tokenId` token must exist and be owned by `from`.
1013      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1014      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1015      *
1016      * Emits a {Transfer} event.
1017      */
1018     function safeTransferFrom(
1019         address from,
1020         address to,
1021         uint256 tokenId
1022     ) external;
1023 
1024     /**
1025      * @dev Transfers `tokenId` token from `from` to `to`.
1026      *
1027      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1028      *
1029      * Requirements:
1030      *
1031      * - `from` cannot be the zero address.
1032      * - `to` cannot be the zero address.
1033      * - `tokenId` token must be owned by `from`.
1034      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1035      *
1036      * Emits a {Transfer} event.
1037      */
1038     function transferFrom(
1039         address from,
1040         address to,
1041         uint256 tokenId
1042     ) external;
1043 
1044     /**
1045      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1046      * The approval is cleared when the token is transferred.
1047      *
1048      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1049      *
1050      * Requirements:
1051      *
1052      * - The caller must own the token or be an approved operator.
1053      * - `tokenId` must exist.
1054      *
1055      * Emits an {Approval} event.
1056      */
1057     function approve(address to, uint256 tokenId) external;
1058 
1059     /**
1060      * @dev Returns the account approved for `tokenId` token.
1061      *
1062      * Requirements:
1063      *
1064      * - `tokenId` must exist.
1065      */
1066     function getApproved(uint256 tokenId) external view returns (address operator);
1067 
1068     /**
1069      * @dev Approve or remove `operator` as an operator for the caller.
1070      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1071      *
1072      * Requirements:
1073      *
1074      * - The `operator` cannot be the caller.
1075      *
1076      * Emits an {ApprovalForAll} event.
1077      */
1078     function setApprovalForAll(address operator, bool _approved) external;
1079 
1080     /**
1081      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1082      *
1083      * See {setApprovalForAll}
1084      */
1085     function isApprovedForAll(address owner, address operator) external view returns (bool);
1086 
1087     /**
1088      * @dev Safely transfers `tokenId` token from `from` to `to`.
1089      *
1090      * Requirements:
1091      *
1092      * - `from` cannot be the zero address.
1093      * - `to` cannot be the zero address.
1094      * - `tokenId` token must exist and be owned by `from`.
1095      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1096      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1097      *
1098      * Emits a {Transfer} event.
1099      */
1100     function safeTransferFrom(
1101         address from,
1102         address to,
1103         uint256 tokenId,
1104         bytes calldata data
1105     ) external;
1106 }
1107 
1108 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1109 
1110 
1111 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
1112 
1113 pragma solidity ^0.8.0;
1114 
1115 
1116 /**
1117  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1118  * @dev See https://eips.ethereum.org/EIPS/eip-721
1119  */
1120 interface IERC721Enumerable is IERC721 {
1121     /**
1122      * @dev Returns the total amount of tokens stored by the contract.
1123      */
1124     function totalSupply() external view returns (uint256);
1125 
1126     /**
1127      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1128      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1129      */
1130     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1131 
1132     /**
1133      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1134      * Use along with {totalSupply} to enumerate all tokens.
1135      */
1136     function tokenByIndex(uint256 index) external view returns (uint256);
1137 }
1138 
1139 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1140 
1141 
1142 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1143 
1144 pragma solidity ^0.8.0;
1145 
1146 
1147 /**
1148  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1149  * @dev See https://eips.ethereum.org/EIPS/eip-721
1150  */
1151 interface IERC721Metadata is IERC721 {
1152     /**
1153      * @dev Returns the token collection name.
1154      */
1155     function name() external view returns (string memory);
1156 
1157     /**
1158      * @dev Returns the token collection symbol.
1159      */
1160     function symbol() external view returns (string memory);
1161 
1162     /**
1163      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1164      */
1165     function tokenURI(uint256 tokenId) external view returns (string memory);
1166 }
1167 
1168 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1169 
1170 
1171 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
1172 
1173 pragma solidity ^0.8.0;
1174 
1175 
1176 
1177 
1178 
1179 
1180 
1181 
1182 /**
1183  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1184  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1185  * {ERC721Enumerable}.
1186  */
1187 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1188     using Address for address;
1189     using Strings for uint256;
1190 
1191     // Token name
1192     string private _name;
1193 
1194     // Token symbol
1195     string private _symbol;
1196 
1197     // Mapping from token ID to owner address
1198     mapping(uint256 => address) private _owners;
1199 
1200     // Mapping owner address to token count
1201     mapping(address => uint256) private _balances;
1202 
1203     // Mapping from token ID to approved address
1204     mapping(uint256 => address) private _tokenApprovals;
1205 
1206     // Mapping from owner to operator approvals
1207     mapping(address => mapping(address => bool)) private _operatorApprovals;
1208 
1209     /**
1210      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1211      */
1212     constructor(string memory name_, string memory symbol_) {
1213         _name = name_;
1214         _symbol = symbol_;
1215     }
1216 
1217     /**
1218      * @dev See {IERC165-supportsInterface}.
1219      */
1220     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1221         return
1222             interfaceId == type(IERC721).interfaceId ||
1223             interfaceId == type(IERC721Metadata).interfaceId ||
1224             super.supportsInterface(interfaceId);
1225     }
1226 
1227     /**
1228      * @dev See {IERC721-balanceOf}.
1229      */
1230     function balanceOf(address owner) public view virtual override returns (uint256) {
1231         require(owner != address(0), "ERC721: balance query for the zero address");
1232         return _balances[owner];
1233     }
1234 
1235     /**
1236      * @dev See {IERC721-ownerOf}.
1237      */
1238     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1239         address owner = _owners[tokenId];
1240         require(owner != address(0), "ERC721: owner query for nonexistent token");
1241         return owner;
1242     }
1243 
1244     /**
1245      * @dev See {IERC721Metadata-name}.
1246      */
1247     function name() public view virtual override returns (string memory) {
1248         return _name;
1249     }
1250 
1251     /**
1252      * @dev See {IERC721Metadata-symbol}.
1253      */
1254     function symbol() public view virtual override returns (string memory) {
1255         return _symbol;
1256     }
1257 
1258     /**
1259      * @dev See {IERC721Metadata-tokenURI}.
1260      */
1261     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1262         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1263 
1264         string memory baseURI = _baseURI();
1265         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1266     }
1267 
1268     /**
1269      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1270      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1271      * by default, can be overriden in child contracts.
1272      */
1273     function _baseURI() internal view virtual returns (string memory) {
1274         return "";
1275     }
1276 
1277     /**
1278      * @dev See {IERC721-approve}.
1279      */
1280     function approve(address to, uint256 tokenId) public virtual override {
1281         address owner = ERC721.ownerOf(tokenId);
1282         require(to != owner, "ERC721: approval to current owner");
1283 
1284         require(
1285             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1286             "ERC721: approve caller is not owner nor approved for all"
1287         );
1288 
1289         _approve(to, tokenId);
1290     }
1291 
1292     /**
1293      * @dev See {IERC721-getApproved}.
1294      */
1295     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1296         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1297 
1298         return _tokenApprovals[tokenId];
1299     }
1300 
1301     /**
1302      * @dev See {IERC721-setApprovalForAll}.
1303      */
1304     function setApprovalForAll(address operator, bool approved) public virtual override {
1305         _setApprovalForAll(_msgSender(), operator, approved);
1306     }
1307 
1308     /**
1309      * @dev See {IERC721-isApprovedForAll}.
1310      */
1311     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1312         return _operatorApprovals[owner][operator];
1313     }
1314 
1315     /**
1316      * @dev See {IERC721-transferFrom}.
1317      */
1318     function transferFrom(
1319         address from,
1320         address to,
1321         uint256 tokenId
1322     ) public virtual override {
1323         //solhint-disable-next-line max-line-length
1324         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1325 
1326         _transfer(from, to, tokenId);
1327     }
1328 
1329     /**
1330      * @dev See {IERC721-safeTransferFrom}.
1331      */
1332     function safeTransferFrom(
1333         address from,
1334         address to,
1335         uint256 tokenId
1336     ) public virtual override {
1337         safeTransferFrom(from, to, tokenId, "");
1338     }
1339 
1340     /**
1341      * @dev See {IERC721-safeTransferFrom}.
1342      */
1343     function safeTransferFrom(
1344         address from,
1345         address to,
1346         uint256 tokenId,
1347         bytes memory _data
1348     ) public virtual override {
1349         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1350         _safeTransfer(from, to, tokenId, _data);
1351     }
1352 
1353     /**
1354      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1355      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1356      *
1357      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1358      *
1359      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1360      * implement alternative mechanisms to perform token transfer, such as signature-based.
1361      *
1362      * Requirements:
1363      *
1364      * - `from` cannot be the zero address.
1365      * - `to` cannot be the zero address.
1366      * - `tokenId` token must exist and be owned by `from`.
1367      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1368      *
1369      * Emits a {Transfer} event.
1370      */
1371     function _safeTransfer(
1372         address from,
1373         address to,
1374         uint256 tokenId,
1375         bytes memory _data
1376     ) internal virtual {
1377         _transfer(from, to, tokenId);
1378         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1379     }
1380 
1381     /**
1382      * @dev Returns whether `tokenId` exists.
1383      *
1384      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1385      *
1386      * Tokens start existing when they are minted (`_mint`),
1387      * and stop existing when they are burned (`_burn`).
1388      */
1389     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1390         return _owners[tokenId] != address(0);
1391     }
1392 
1393     /**
1394      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1395      *
1396      * Requirements:
1397      *
1398      * - `tokenId` must exist.
1399      */
1400     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1401         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1402         address owner = ERC721.ownerOf(tokenId);
1403         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1404     }
1405 
1406     /**
1407      * @dev Safely mints `tokenId` and transfers it to `to`.
1408      *
1409      * Requirements:
1410      *
1411      * - `tokenId` must not exist.
1412      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1413      *
1414      * Emits a {Transfer} event.
1415      */
1416     function _safeMint(address to, uint256 tokenId) internal virtual {
1417         _safeMint(to, tokenId, "");
1418     }
1419 
1420     /**
1421      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1422      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1423      */
1424     function _safeMint(
1425         address to,
1426         uint256 tokenId,
1427         bytes memory _data
1428     ) internal virtual {
1429         _mint(to, tokenId);
1430         require(
1431             _checkOnERC721Received(address(0), to, tokenId, _data),
1432             "ERC721: transfer to non ERC721Receiver implementer"
1433         );
1434     }
1435 
1436     /**
1437      * @dev Mints `tokenId` and transfers it to `to`.
1438      *
1439      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1440      *
1441      * Requirements:
1442      *
1443      * - `tokenId` must not exist.
1444      * - `to` cannot be the zero address.
1445      *
1446      * Emits a {Transfer} event.
1447      */
1448     function _mint(address to, uint256 tokenId) internal virtual {
1449         require(to != address(0), "ERC721: mint to the zero address");
1450         require(!_exists(tokenId), "ERC721: token already minted");
1451 
1452         _beforeTokenTransfer(address(0), to, tokenId);
1453 
1454         _balances[to] += 1;
1455         _owners[tokenId] = to;
1456 
1457         emit Transfer(address(0), to, tokenId);
1458     }
1459 
1460     /**
1461      * @dev Destroys `tokenId`.
1462      * The approval is cleared when the token is burned.
1463      *
1464      * Requirements:
1465      *
1466      * - `tokenId` must exist.
1467      *
1468      * Emits a {Transfer} event.
1469      */
1470     function _burn(uint256 tokenId) internal virtual {
1471         address owner = ERC721.ownerOf(tokenId);
1472 
1473         _beforeTokenTransfer(owner, address(0), tokenId);
1474 
1475         // Clear approvals
1476         _approve(address(0), tokenId);
1477 
1478         _balances[owner] -= 1;
1479         delete _owners[tokenId];
1480 
1481         emit Transfer(owner, address(0), tokenId);
1482     }
1483 
1484     /**
1485      * @dev Transfers `tokenId` from `from` to `to`.
1486      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1487      *
1488      * Requirements:
1489      *
1490      * - `to` cannot be the zero address.
1491      * - `tokenId` token must be owned by `from`.
1492      *
1493      * Emits a {Transfer} event.
1494      */
1495     function _transfer(
1496         address from,
1497         address to,
1498         uint256 tokenId
1499     ) internal virtual {
1500         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1501         require(to != address(0), "ERC721: transfer to the zero address");
1502 
1503         _beforeTokenTransfer(from, to, tokenId);
1504 
1505         // Clear approvals from the previous owner
1506         _approve(address(0), tokenId);
1507 
1508         _balances[from] -= 1;
1509         _balances[to] += 1;
1510         _owners[tokenId] = to;
1511 
1512         emit Transfer(from, to, tokenId);
1513     }
1514 
1515     /**
1516      * @dev Approve `to` to operate on `tokenId`
1517      *
1518      * Emits a {Approval} event.
1519      */
1520     function _approve(address to, uint256 tokenId) internal virtual {
1521         _tokenApprovals[tokenId] = to;
1522         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1523     }
1524 
1525     /**
1526      * @dev Approve `operator` to operate on all of `owner` tokens
1527      *
1528      * Emits a {ApprovalForAll} event.
1529      */
1530     function _setApprovalForAll(
1531         address owner,
1532         address operator,
1533         bool approved
1534     ) internal virtual {
1535         require(owner != operator, "ERC721: approve to caller");
1536         _operatorApprovals[owner][operator] = approved;
1537         emit ApprovalForAll(owner, operator, approved);
1538     }
1539 
1540     /**
1541      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1542      * The call is not executed if the target address is not a contract.
1543      *
1544      * @param from address representing the previous owner of the given token ID
1545      * @param to target address that will receive the tokens
1546      * @param tokenId uint256 ID of the token to be transferred
1547      * @param _data bytes optional data to send along with the call
1548      * @return bool whether the call correctly returned the expected magic value
1549      */
1550     function _checkOnERC721Received(
1551         address from,
1552         address to,
1553         uint256 tokenId,
1554         bytes memory _data
1555     ) private returns (bool) {
1556         if (to.isContract()) {
1557             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1558                 return retval == IERC721Receiver.onERC721Received.selector;
1559             } catch (bytes memory reason) {
1560                 if (reason.length == 0) {
1561                     revert("ERC721: transfer to non ERC721Receiver implementer");
1562                 } else {
1563                     assembly {
1564                         revert(add(32, reason), mload(reason))
1565                     }
1566                 }
1567             }
1568         } else {
1569             return true;
1570         }
1571     }
1572 
1573     /**
1574      * @dev Hook that is called before any token transfer. This includes minting
1575      * and burning.
1576      *
1577      * Calling conditions:
1578      *
1579      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1580      * transferred to `to`.
1581      * - When `from` is zero, `tokenId` will be minted for `to`.
1582      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1583      * - `from` and `to` are never both zero.
1584      *
1585      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1586      */
1587     function _beforeTokenTransfer(
1588         address from,
1589         address to,
1590         uint256 tokenId
1591     ) internal virtual {}
1592 }
1593 
1594 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1595 
1596 
1597 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1598 
1599 pragma solidity ^0.8.0;
1600 
1601 
1602 
1603 /**
1604  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1605  * enumerability of all the token ids in the contract as well as all token ids owned by each
1606  * account.
1607  */
1608 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1609     // Mapping from owner to list of owned token IDs
1610     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1611 
1612     // Mapping from token ID to index of the owner tokens list
1613     mapping(uint256 => uint256) private _ownedTokensIndex;
1614 
1615     // Array with all token ids, used for enumeration
1616     uint256[] private _allTokens;
1617 
1618     // Mapping from token id to position in the allTokens array
1619     mapping(uint256 => uint256) private _allTokensIndex;
1620 
1621     /**
1622      * @dev See {IERC165-supportsInterface}.
1623      */
1624     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1625         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1626     }
1627 
1628     /**
1629      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1630      */
1631     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1632         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1633         return _ownedTokens[owner][index];
1634     }
1635 
1636     /**
1637      * @dev See {IERC721Enumerable-totalSupply}.
1638      */
1639     function totalSupply() public view virtual override returns (uint256) {
1640         return _allTokens.length;
1641     }
1642 
1643     /**
1644      * @dev See {IERC721Enumerable-tokenByIndex}.
1645      */
1646     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1647         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1648         return _allTokens[index];
1649     }
1650 
1651     /**
1652      * @dev Hook that is called before any token transfer. This includes minting
1653      * and burning.
1654      *
1655      * Calling conditions:
1656      *
1657      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1658      * transferred to `to`.
1659      * - When `from` is zero, `tokenId` will be minted for `to`.
1660      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1661      * - `from` cannot be the zero address.
1662      * - `to` cannot be the zero address.
1663      *
1664      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1665      */
1666     function _beforeTokenTransfer(
1667         address from,
1668         address to,
1669         uint256 tokenId
1670     ) internal virtual override {
1671         super._beforeTokenTransfer(from, to, tokenId);
1672 
1673         if (from == address(0)) {
1674             _addTokenToAllTokensEnumeration(tokenId);
1675         } else if (from != to) {
1676             _removeTokenFromOwnerEnumeration(from, tokenId);
1677         }
1678         if (to == address(0)) {
1679             _removeTokenFromAllTokensEnumeration(tokenId);
1680         } else if (to != from) {
1681             _addTokenToOwnerEnumeration(to, tokenId);
1682         }
1683     }
1684 
1685     /**
1686      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1687      * @param to address representing the new owner of the given token ID
1688      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1689      */
1690     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1691         uint256 length = ERC721.balanceOf(to);
1692         _ownedTokens[to][length] = tokenId;
1693         _ownedTokensIndex[tokenId] = length;
1694     }
1695 
1696     /**
1697      * @dev Private function to add a token to this extension's token tracking data structures.
1698      * @param tokenId uint256 ID of the token to be added to the tokens list
1699      */
1700     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1701         _allTokensIndex[tokenId] = _allTokens.length;
1702         _allTokens.push(tokenId);
1703     }
1704 
1705     /**
1706      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1707      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1708      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1709      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1710      * @param from address representing the previous owner of the given token ID
1711      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1712      */
1713     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1714         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1715         // then delete the last slot (swap and pop).
1716 
1717         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1718         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1719 
1720         // When the token to delete is the last token, the swap operation is unnecessary
1721         if (tokenIndex != lastTokenIndex) {
1722             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1723 
1724             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1725             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1726         }
1727 
1728         // This also deletes the contents at the last position of the array
1729         delete _ownedTokensIndex[tokenId];
1730         delete _ownedTokens[from][lastTokenIndex];
1731     }
1732 
1733     /**
1734      * @dev Private function to remove a token from this extension's token tracking data structures.
1735      * This has O(1) time complexity, but alters the order of the _allTokens array.
1736      * @param tokenId uint256 ID of the token to be removed from the tokens list
1737      */
1738     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1739         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1740         // then delete the last slot (swap and pop).
1741 
1742         uint256 lastTokenIndex = _allTokens.length - 1;
1743         uint256 tokenIndex = _allTokensIndex[tokenId];
1744 
1745         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1746         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1747         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1748         uint256 lastTokenId = _allTokens[lastTokenIndex];
1749 
1750         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1751         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1752 
1753         // This also deletes the contents at the last position of the array
1754         delete _allTokensIndex[tokenId];
1755         _allTokens.pop();
1756     }
1757 }
1758 
1759 // File: contracts/PioneerIndustries.sol
1760 
1761 
1762 
1763 pragma solidity ^0.8.4;
1764 
1765 
1766 
1767 
1768 
1769 
1770 contract PioneerIndustries is
1771     ERC721Enumerable,
1772     Ownable,
1773     PaymentSplitter
1774 {
1775     using Strings for uint256;
1776     using Counters for Counters.Counter;
1777 
1778     uint256 public maxSupply = 7030;
1779     uint256 public totalNFT;
1780 
1781     string public baseURI;
1782     string public notRevealedUri;
1783     string public baseExtension = ".json";
1784 
1785     bool public isBurnEnabled = false;
1786     bool public revealed = false;
1787 
1788     bool public paused = false;
1789     bool public presaleState = false;
1790     bool public publicState = false;
1791 
1792     mapping(address => uint256) public _nftMinted;
1793     mapping(address => uint256) public _whitelistClaimed;
1794 
1795     uint256 _publicPrice = 200000000000000000; //0.2 ETH
1796     uint256 _whitelistPrice = 180000000000000000; //0.18 ETH
1797 
1798     bytes32 public whitelistRoot;
1799 
1800     Counters.Counter private _tokenIds;
1801 
1802     uint256[] private _teamShares = [6, 94];
1803     address[] private _team = [
1804         0xd293f119eD1Cb766b6E4863e9B41c95C677fCFbe,
1805         0x268CeCa1AF6D2e0b5298A7f6187c8fA9Ea88de8B
1806     ];
1807 
1808     constructor()
1809         ERC721("Pioneer", "PIONEER")
1810         PaymentSplitter(_team, _teamShares)
1811     {}
1812 
1813     function changePauseState() public onlyOwner {
1814         paused = !paused;
1815     }
1816 
1817     function changePresaleState() public onlyOwner {
1818         presaleState = !presaleState;
1819     }
1820 
1821     function changePublicState() public onlyOwner {
1822         publicState = !publicState;
1823     }
1824 
1825     function setBaseURI(string calldata _tokenBaseURI) external onlyOwner {
1826         baseURI = _tokenBaseURI;
1827     }
1828 
1829     function _baseURI() internal view override returns (string memory) {
1830         return baseURI;
1831     }
1832 
1833     function reveal() public onlyOwner {
1834         revealed = true;
1835     }
1836 
1837     function setIsBurnEnabled(bool _isBurnEnabled) external onlyOwner {
1838         isBurnEnabled = _isBurnEnabled;
1839     }
1840 
1841 
1842     function giftMint(address[] calldata _addresses) external onlyOwner {
1843         require(
1844             totalNFT + _addresses.length <= maxSupply,
1845             "Pioneer Industries: max total supply exceeded"
1846         );
1847 
1848         uint256 _newItemId;
1849         for (uint256 ind = 0; ind < _addresses.length; ind++) {
1850             require(
1851                 _addresses[ind] != address(0),
1852                 "Pioneer Industries: recepient is the null address"
1853             );
1854             _tokenIds.increment();
1855             _newItemId = _tokenIds.current();
1856             _safeMint(_addresses[ind], _newItemId);
1857             totalNFT = totalNFT + 1;
1858         }
1859     }
1860 
1861     function presaleMint(uint256 _amount) external payable {
1862         require(presaleState, "Pioneer Industries: presale is OFF");
1863         require(!paused, "Pioneer Industries: contract is paused");
1864         require(
1865             _amount <= 3,
1866             "Pioneer Industries: You can't mint so much tokens"
1867         );
1868         require(
1869             _whitelistClaimed[msg.sender] + _amount <= 3,
1870             "Pioneer Industries: You can't mint so much tokens"
1871         );
1872 
1873         require(
1874             totalNFT + _amount <= maxSupply,
1875             "Pioneer Industries: max supply exceeded"
1876         );
1877         require(
1878             _whitelistPrice * _amount <= msg.value,
1879             "Pioneer Industries: Ether value sent is not correct"
1880         );
1881         uint256 _newItemId;
1882         for (uint256 ind = 0; ind < _amount; ind++) {
1883             _tokenIds.increment();
1884             _newItemId = _tokenIds.current();
1885             _safeMint(msg.sender, _newItemId);
1886             _whitelistClaimed[msg.sender] = _whitelistClaimed[msg.sender] + 1;
1887             totalNFT = totalNFT + 1;
1888             
1889         }
1890     }
1891 
1892     function publicMint(uint256 _amount) external payable {
1893         require(publicState, "Pioneer Industries: Public is OFF");
1894         require(_amount > 0, "Pioneer Industries: zero amount");
1895         require(
1896             totalNFT + _amount <= maxSupply,
1897             "Pioneer Industries: max supply exceeded"
1898         );
1899         require(
1900             _publicPrice * _amount <= msg.value,
1901             "Pioneer Industries: Ether value sent is not correct"
1902         );
1903         require(!paused, "Pioneer Industries: contract is paused");
1904         uint256 _newItemId;
1905         for (uint256 ind = 0; ind < _amount; ind++) {
1906             _tokenIds.increment();
1907             _newItemId = _tokenIds.current();
1908             _safeMint(msg.sender, _newItemId);
1909             totalNFT = totalNFT + 1;
1910         }
1911     }
1912 
1913     function tokenURI(uint256 tokenId)
1914         public
1915         view
1916         virtual
1917         override
1918         returns (string memory)
1919     {
1920         require(
1921             _exists(tokenId),
1922             "ERC721Metadata: URI query for nonexistent token"
1923         );
1924         if (revealed == false) {
1925             return notRevealedUri;
1926         }
1927 
1928         string memory currentBaseURI = _baseURI();
1929         return
1930             bytes(currentBaseURI).length > 0
1931                 ? string(
1932                     abi.encodePacked(
1933                         currentBaseURI,
1934                         tokenId.toString(),
1935                         baseExtension
1936                     )
1937                 )
1938                 : "";
1939     }
1940 
1941     function setBaseExtension(string memory _newBaseExtension)
1942         public
1943         onlyOwner
1944     {
1945         baseExtension = _newBaseExtension;
1946     }
1947 
1948     function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1949         notRevealedUri = _notRevealedURI;
1950     }
1951 
1952     function changeTotalSupply(uint256 _newSupply) public onlyOwner {
1953         maxSupply = _newSupply;
1954     }
1955 
1956     function changewhitelistRoot(bytes32 _whitelistRoot) public onlyOwner {
1957         whitelistRoot = _whitelistRoot;
1958     }
1959 
1960     function burn(uint256 tokenId) external {
1961         require(isBurnEnabled, "Pioneer Industries : burning disabled");
1962         require(
1963             _isApprovedOrOwner(msg.sender, tokenId),
1964             "Pioneer Industries : burn caller is not owner nor approved"
1965         );
1966         _burn(tokenId);
1967         totalNFT = totalNFT - 1;
1968     }
1969 
1970     function verifyWhitelist(address account, bytes32[] memory proof)
1971         internal
1972         view
1973         returns (bool)
1974     {
1975         bytes32 leaf = keccak256(abi.encodePacked(account));
1976         return MerkleProof.verify(proof, whitelistRoot, leaf);
1977     }
1978 }