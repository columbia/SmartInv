1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
5 
6 pragma solidity ^0.8.0;
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
86 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
87 
88 
89 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
90 
91 pragma solidity ^0.8.0;
92 
93 /**
94  * @dev These functions deal with verification of Merkle Trees proofs.
95  *
96  * The proofs can be generated using the JavaScript library
97  * https://github.com/miguelmota/merkletreejs[merkletreejs].
98  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
99  *
100  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
101  */
102 library MerkleProof {
103     /**
104      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
105      * defined by `root`. For this, a `proof` must be provided, containing
106      * sibling hashes on the branch from the leaf to the root of the tree. Each
107      * pair of leaves and each pair of pre-images are assumed to be sorted.
108      */
109     function verify(
110         bytes32[] memory proof,
111         bytes32 root,
112         bytes32 leaf
113     ) internal pure returns (bool) {
114         return processProof(proof, leaf) == root;
115     }
116 
117     /**
118      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
119      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
120      * hash matches the root of the tree. When processing the proof, the pairs
121      * of leafs & pre-images are assumed to be sorted.
122      *
123      * _Available since v4.4._
124      */
125     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
126         bytes32 computedHash = leaf;
127         for (uint256 i = 0; i < proof.length; i++) {
128             bytes32 proofElement = proof[i];
129             if (computedHash <= proofElement) {
130                 // Hash(current computed hash + current element of the proof)
131                 computedHash = _efficientHash(computedHash, proofElement);
132             } else {
133                 // Hash(current element of the proof + current computed hash)
134                 computedHash = _efficientHash(proofElement, computedHash);
135             }
136         }
137         return computedHash;
138     }
139 
140     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
141         assembly {
142             mstore(0x00, a)
143             mstore(0x20, b)
144             value := keccak256(0x00, 0x40)
145         }
146     }
147 }
148 
149 // File: @openzeppelin/contracts/utils/Context.sol
150 
151 
152 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
153 
154 pragma solidity ^0.8.0;
155 
156 /**
157  * @dev Provides information about the current execution context, including the
158  * sender of the transaction and its data. While these are generally available
159  * via msg.sender and msg.data, they should not be accessed in such a direct
160  * manner, since when dealing with meta-transactions the account sending and
161  * paying for execution may not be the actual sender (as far as an application
162  * is concerned).
163  *
164  * This contract is only required for intermediate, library-like contracts.
165  */
166 abstract contract Context {
167     function _msgSender() internal view virtual returns (address) {
168         return msg.sender;
169     }
170 
171     function _msgData() internal view virtual returns (bytes calldata) {
172         return msg.data;
173     }
174 }
175 
176 // File: @openzeppelin/contracts/access/Ownable.sol
177 
178 
179 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
180 
181 pragma solidity ^0.8.0;
182 
183 
184 /**
185  * @dev Contract module which provides a basic access control mechanism, where
186  * there is an account (an owner) that can be granted exclusive access to
187  * specific functions.
188  *
189  * By default, the owner account will be the one that deploys the contract. This
190  * can later be changed with {transferOwnership}.
191  *
192  * This module is used through inheritance. It will make available the modifier
193  * `onlyOwner`, which can be applied to your functions to restrict their use to
194  * the owner.
195  */
196 abstract contract Ownable is Context {
197     address private _owner;
198 
199     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
200 
201     /**
202      * @dev Initializes the contract setting the deployer as the initial owner.
203      */
204     constructor() {
205         _transferOwnership(_msgSender());
206     }
207 
208     /**
209      * @dev Returns the address of the current owner.
210      */
211     function owner() public view virtual returns (address) {
212         return _owner;
213     }
214 
215     /**
216      * @dev Throws if called by any account other than the owner.
217      */
218     modifier onlyOwner() {
219         require(owner() == _msgSender(), "Ownable: caller is not the owner");
220         _;
221     }
222 
223     /**
224      * @dev Leaves the contract without owner. It will not be possible to call
225      * `onlyOwner` functions anymore. Can only be called by the current owner.
226      *
227      * NOTE: Renouncing ownership will leave the contract without an owner,
228      * thereby removing any functionality that is only available to the owner.
229      */
230     function renounceOwnership() public virtual onlyOwner {
231         _transferOwnership(address(0));
232     }
233 
234     /**
235      * @dev Transfers ownership of the contract to a new account (`newOwner`).
236      * Can only be called by the current owner.
237      */
238     function transferOwnership(address newOwner) public virtual onlyOwner {
239         require(newOwner != address(0), "Ownable: new owner is the zero address");
240         _transferOwnership(newOwner);
241     }
242 
243     /**
244      * @dev Transfers ownership of the contract to a new account (`newOwner`).
245      * Internal function without access restriction.
246      */
247     function _transferOwnership(address newOwner) internal virtual {
248         address oldOwner = _owner;
249         _owner = newOwner;
250         emit OwnershipTransferred(oldOwner, newOwner);
251     }
252 }
253 
254 // File: @openzeppelin/contracts/utils/Address.sol
255 
256 
257 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
258 
259 pragma solidity ^0.8.0;
260 
261 /**
262  * @dev Collection of functions related to the address type
263  */
264 library Address {
265     /**
266      * @dev Returns true if `account` is a contract.
267      *
268      * [IMPORTANT]
269      * ====
270      * It is unsafe to assume that an address for which this function returns
271      * false is an externally-owned account (EOA) and not a contract.
272      *
273      * Among others, `isContract` will return false for the following
274      * types of addresses:
275      *
276      *  - an externally-owned account
277      *  - a contract in construction
278      *  - an address where a contract will be created
279      *  - an address where a contract lived, but was destroyed
280      * ====
281      */
282     function isContract(address account) internal view returns (bool) {
283         // This method relies on extcodesize, which returns 0 for contracts in
284         // construction, since the code is only stored at the end of the
285         // constructor execution.
286 
287         uint256 size;
288         assembly {
289             size := extcodesize(account)
290         }
291         return size > 0;
292     }
293 
294     /**
295      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
296      * `recipient`, forwarding all available gas and reverting on errors.
297      *
298      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
299      * of certain opcodes, possibly making contracts go over the 2300 gas limit
300      * imposed by `transfer`, making them unable to receive funds via
301      * `transfer`. {sendValue} removes this limitation.
302      *
303      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
304      *
305      * IMPORTANT: because control is transferred to `recipient`, care must be
306      * taken to not create reentrancy vulnerabilities. Consider using
307      * {ReentrancyGuard} or the
308      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
309      */
310     function sendValue(address payable recipient, uint256 amount) internal {
311         require(address(this).balance >= amount, "Address: insufficient balance");
312 
313         (bool success, ) = recipient.call{value: amount}("");
314         require(success, "Address: unable to send value, recipient may have reverted");
315     }
316 
317     /**
318      * @dev Performs a Solidity function call using a low level `call`. A
319      * plain `call` is an unsafe replacement for a function call: use this
320      * function instead.
321      *
322      * If `target` reverts with a revert reason, it is bubbled up by this
323      * function (like regular Solidity function calls).
324      *
325      * Returns the raw returned data. To convert to the expected return value,
326      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
327      *
328      * Requirements:
329      *
330      * - `target` must be a contract.
331      * - calling `target` with `data` must not revert.
332      *
333      * _Available since v3.1._
334      */
335     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
336         return functionCall(target, data, "Address: low-level call failed");
337     }
338 
339     /**
340      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
341      * `errorMessage` as a fallback revert reason when `target` reverts.
342      *
343      * _Available since v3.1._
344      */
345     function functionCall(
346         address target,
347         bytes memory data,
348         string memory errorMessage
349     ) internal returns (bytes memory) {
350         return functionCallWithValue(target, data, 0, errorMessage);
351     }
352 
353     /**
354      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
355      * but also transferring `value` wei to `target`.
356      *
357      * Requirements:
358      *
359      * - the calling contract must have an ETH balance of at least `value`.
360      * - the called Solidity function must be `payable`.
361      *
362      * _Available since v3.1._
363      */
364     function functionCallWithValue(
365         address target,
366         bytes memory data,
367         uint256 value
368     ) internal returns (bytes memory) {
369         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
370     }
371 
372     /**
373      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
374      * with `errorMessage` as a fallback revert reason when `target` reverts.
375      *
376      * _Available since v3.1._
377      */
378     function functionCallWithValue(
379         address target,
380         bytes memory data,
381         uint256 value,
382         string memory errorMessage
383     ) internal returns (bytes memory) {
384         require(address(this).balance >= value, "Address: insufficient balance for call");
385         require(isContract(target), "Address: call to non-contract");
386 
387         (bool success, bytes memory returndata) = target.call{value: value}(data);
388         return verifyCallResult(success, returndata, errorMessage);
389     }
390 
391     /**
392      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
393      * but performing a static call.
394      *
395      * _Available since v3.3._
396      */
397     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
398         return functionStaticCall(target, data, "Address: low-level static call failed");
399     }
400 
401     /**
402      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
403      * but performing a static call.
404      *
405      * _Available since v3.3._
406      */
407     function functionStaticCall(
408         address target,
409         bytes memory data,
410         string memory errorMessage
411     ) internal view returns (bytes memory) {
412         require(isContract(target), "Address: static call to non-contract");
413 
414         (bool success, bytes memory returndata) = target.staticcall(data);
415         return verifyCallResult(success, returndata, errorMessage);
416     }
417 
418     /**
419      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
420      * but performing a delegate call.
421      *
422      * _Available since v3.4._
423      */
424     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
425         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
426     }
427 
428     /**
429      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
430      * but performing a delegate call.
431      *
432      * _Available since v3.4._
433      */
434     function functionDelegateCall(
435         address target,
436         bytes memory data,
437         string memory errorMessage
438     ) internal returns (bytes memory) {
439         require(isContract(target), "Address: delegate call to non-contract");
440 
441         (bool success, bytes memory returndata) = target.delegatecall(data);
442         return verifyCallResult(success, returndata, errorMessage);
443     }
444 
445     /**
446      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
447      * revert reason using the provided one.
448      *
449      * _Available since v4.3._
450      */
451     function verifyCallResult(
452         bool success,
453         bytes memory returndata,
454         string memory errorMessage
455     ) internal pure returns (bytes memory) {
456         if (success) {
457             return returndata;
458         } else {
459             // Look for revert reason and bubble it up if present
460             if (returndata.length > 0) {
461                 // The easiest way to bubble the revert reason is using memory via assembly
462 
463                 assembly {
464                     let returndata_size := mload(returndata)
465                     revert(add(32, returndata), returndata_size)
466                 }
467             } else {
468                 revert(errorMessage);
469             }
470         }
471     }
472 }
473 
474 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
475 
476 
477 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
478 
479 pragma solidity ^0.8.0;
480 
481 
482 
483 /**
484  * @title SafeERC20
485  * @dev Wrappers around ERC20 operations that throw on failure (when the token
486  * contract returns false). Tokens that return no value (and instead revert or
487  * throw on failure) are also supported, non-reverting calls are assumed to be
488  * successful.
489  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
490  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
491  */
492 library SafeERC20 {
493     using Address for address;
494 
495     function safeTransfer(
496         IERC20 token,
497         address to,
498         uint256 value
499     ) internal {
500         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
501     }
502 
503     function safeTransferFrom(
504         IERC20 token,
505         address from,
506         address to,
507         uint256 value
508     ) internal {
509         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
510     }
511 
512     /**
513      * @dev Deprecated. This function has issues similar to the ones found in
514      * {IERC20-approve}, and its usage is discouraged.
515      *
516      * Whenever possible, use {safeIncreaseAllowance} and
517      * {safeDecreaseAllowance} instead.
518      */
519     function safeApprove(
520         IERC20 token,
521         address spender,
522         uint256 value
523     ) internal {
524         // safeApprove should only be called when setting an initial allowance,
525         // or when resetting it to zero. To increase and decrease it, use
526         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
527         require(
528             (value == 0) || (token.allowance(address(this), spender) == 0),
529             "SafeERC20: approve from non-zero to non-zero allowance"
530         );
531         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
532     }
533 
534     function safeIncreaseAllowance(
535         IERC20 token,
536         address spender,
537         uint256 value
538     ) internal {
539         uint256 newAllowance = token.allowance(address(this), spender) + value;
540         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
541     }
542 
543     function safeDecreaseAllowance(
544         IERC20 token,
545         address spender,
546         uint256 value
547     ) internal {
548         unchecked {
549             uint256 oldAllowance = token.allowance(address(this), spender);
550             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
551             uint256 newAllowance = oldAllowance - value;
552             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
553         }
554     }
555 
556     /**
557      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
558      * on the return value: the return value is optional (but if data is returned, it must not be false).
559      * @param token The token targeted by the call.
560      * @param data The call data (encoded using abi.encode or one of its variants).
561      */
562     function _callOptionalReturn(IERC20 token, bytes memory data) private {
563         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
564         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
565         // the target address contains contract code and also asserts for success in the low-level call.
566 
567         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
568         if (returndata.length > 0) {
569             // Return data is optional
570             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
571         }
572     }
573 }
574 
575 // File: @openzeppelin/contracts/finance/PaymentSplitter.sol
576 
577 
578 // OpenZeppelin Contracts v4.4.1 (finance/PaymentSplitter.sol)
579 
580 pragma solidity ^0.8.0;
581 
582 
583 
584 
585 /**
586  * @title PaymentSplitter
587  * @dev This contract allows to split Ether payments among a group of accounts. The sender does not need to be aware
588  * that the Ether will be split in this way, since it is handled transparently by the contract.
589  *
590  * The split can be in equal parts or in any other arbitrary proportion. The way this is specified is by assigning each
591  * account to a number of shares. Of all the Ether that this contract receives, each account will then be able to claim
592  * an amount proportional to the percentage of total shares they were assigned.
593  *
594  * `PaymentSplitter` follows a _pull payment_ model. This means that payments are not automatically forwarded to the
595  * accounts but kept in this contract, and the actual transfer is triggered as a separate step by calling the {release}
596  * function.
597  *
598  * NOTE: This contract assumes that ERC20 tokens will behave similarly to native tokens (Ether). Rebasing tokens, and
599  * tokens that apply fees during transfers, are likely to not be supported as expected. If in doubt, we encourage you
600  * to run tests before sending real value to this contract.
601  */
602 contract PaymentSplitter is Context {
603     event PayeeAdded(address account, uint256 shares);
604     event PaymentReleased(address to, uint256 amount);
605     event ERC20PaymentReleased(IERC20 indexed token, address to, uint256 amount);
606     event PaymentReceived(address from, uint256 amount);
607 
608     uint256 private _totalShares;
609     uint256 private _totalReleased;
610 
611     mapping(address => uint256) private _shares;
612     mapping(address => uint256) private _released;
613     address[] private _payees;
614 
615     mapping(IERC20 => uint256) private _erc20TotalReleased;
616     mapping(IERC20 => mapping(address => uint256)) private _erc20Released;
617 
618     /**
619      * @dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at
620      * the matching position in the `shares` array.
621      *
622      * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no
623      * duplicates in `payees`.
624      */
625     constructor(address[] memory payees, uint256[] memory shares_) payable {
626         require(payees.length == shares_.length, "PaymentSplitter: payees and shares length mismatch");
627         require(payees.length > 0, "PaymentSplitter: no payees");
628 
629         for (uint256 i = 0; i < payees.length; i++) {
630             _addPayee(payees[i], shares_[i]);
631         }
632     }
633 
634     /**
635      * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully
636      * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
637      * reliability of the events, and not the actual splitting of Ether.
638      *
639      * To learn more about this see the Solidity documentation for
640      * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
641      * functions].
642      */
643     receive() external payable virtual {
644         emit PaymentReceived(_msgSender(), msg.value);
645     }
646 
647     /**
648      * @dev Getter for the total shares held by payees.
649      */
650     function totalShares() public view returns (uint256) {
651         return _totalShares;
652     }
653 
654     /**
655      * @dev Getter for the total amount of Ether already released.
656      */
657     function totalReleased() public view returns (uint256) {
658         return _totalReleased;
659     }
660 
661     /**
662      * @dev Getter for the total amount of `token` already released. `token` should be the address of an IERC20
663      * contract.
664      */
665     function totalReleased(IERC20 token) public view returns (uint256) {
666         return _erc20TotalReleased[token];
667     }
668 
669     /**
670      * @dev Getter for the amount of shares held by an account.
671      */
672     function shares(address account) public view returns (uint256) {
673         return _shares[account];
674     }
675 
676     /**
677      * @dev Getter for the amount of Ether already released to a payee.
678      */
679     function released(address account) public view returns (uint256) {
680         return _released[account];
681     }
682 
683     /**
684      * @dev Getter for the amount of `token` tokens already released to a payee. `token` should be the address of an
685      * IERC20 contract.
686      */
687     function released(IERC20 token, address account) public view returns (uint256) {
688         return _erc20Released[token][account];
689     }
690 
691     /**
692      * @dev Getter for the address of the payee number `index`.
693      */
694     function payee(uint256 index) public view returns (address) {
695         return _payees[index];
696     }
697 
698     /**
699      * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
700      * total shares and their previous withdrawals.
701      */
702     function release(address payable account) public virtual {
703         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
704 
705         uint256 totalReceived = address(this).balance + totalReleased();
706         uint256 payment = _pendingPayment(account, totalReceived, released(account));
707 
708         require(payment != 0, "PaymentSplitter: account is not due payment");
709 
710         _released[account] += payment;
711         _totalReleased += payment;
712 
713         Address.sendValue(account, payment);
714         emit PaymentReleased(account, payment);
715     }
716 
717     /**
718      * @dev Triggers a transfer to `account` of the amount of `token` tokens they are owed, according to their
719      * percentage of the total shares and their previous withdrawals. `token` must be the address of an IERC20
720      * contract.
721      */
722     function release(IERC20 token, address account) public virtual {
723         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
724 
725         uint256 totalReceived = token.balanceOf(address(this)) + totalReleased(token);
726         uint256 payment = _pendingPayment(account, totalReceived, released(token, account));
727 
728         require(payment != 0, "PaymentSplitter: account is not due payment");
729 
730         _erc20Released[token][account] += payment;
731         _erc20TotalReleased[token] += payment;
732 
733         SafeERC20.safeTransfer(token, account, payment);
734         emit ERC20PaymentReleased(token, account, payment);
735     }
736 
737     /**
738      * @dev internal logic for computing the pending payment of an `account` given the token historical balances and
739      * already released amounts.
740      */
741     function _pendingPayment(
742         address account,
743         uint256 totalReceived,
744         uint256 alreadyReleased
745     ) private view returns (uint256) {
746         return (totalReceived * _shares[account]) / _totalShares - alreadyReleased;
747     }
748 
749     /**
750      * @dev Add a new payee to the contract.
751      * @param account The address of the payee to add.
752      * @param shares_ The number of shares owned by the payee.
753      */
754     function _addPayee(address account, uint256 shares_) private {
755         require(account != address(0), "PaymentSplitter: account is the zero address");
756         require(shares_ > 0, "PaymentSplitter: shares are 0");
757         require(_shares[account] == 0, "PaymentSplitter: account already has shares");
758 
759         _payees.push(account);
760         _shares[account] = shares_;
761         _totalShares = _totalShares + shares_;
762         emit PayeeAdded(account, shares_);
763     }
764 }
765 
766 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
767 
768 
769 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
770 
771 pragma solidity ^0.8.0;
772 
773 /**
774  * @title ERC721 token receiver interface
775  * @dev Interface for any contract that wants to support safeTransfers
776  * from ERC721 asset contracts.
777  */
778 interface IERC721Receiver {
779     /**
780      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
781      * by `operator` from `from`, this function is called.
782      *
783      * It must return its Solidity selector to confirm the token transfer.
784      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
785      *
786      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
787      */
788     function onERC721Received(
789         address operator,
790         address from,
791         uint256 tokenId,
792         bytes calldata data
793     ) external returns (bytes4);
794 }
795 
796 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
797 
798 
799 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
800 
801 pragma solidity ^0.8.0;
802 
803 /**
804  * @dev Interface of the ERC165 standard, as defined in the
805  * https://eips.ethereum.org/EIPS/eip-165[EIP].
806  *
807  * Implementers can declare support of contract interfaces, which can then be
808  * queried by others ({ERC165Checker}).
809  *
810  * For an implementation, see {ERC165}.
811  */
812 interface IERC165 {
813     /**
814      * @dev Returns true if this contract implements the interface defined by
815      * `interfaceId`. See the corresponding
816      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
817      * to learn more about how these ids are created.
818      *
819      * This function call must use less than 30 000 gas.
820      */
821     function supportsInterface(bytes4 interfaceId) external view returns (bool);
822 }
823 
824 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
825 
826 
827 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
828 
829 pragma solidity ^0.8.0;
830 
831 
832 /**
833  * @dev Implementation of the {IERC165} interface.
834  *
835  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
836  * for the additional interface id that will be supported. For example:
837  *
838  * ```solidity
839  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
840  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
841  * }
842  * ```
843  *
844  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
845  */
846 abstract contract ERC165 is IERC165 {
847     /**
848      * @dev See {IERC165-supportsInterface}.
849      */
850     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
851         return interfaceId == type(IERC165).interfaceId;
852     }
853 }
854 
855 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
856 
857 
858 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
859 
860 pragma solidity ^0.8.0;
861 
862 
863 /**
864  * @dev Required interface of an ERC721 compliant contract.
865  */
866 interface IERC721 is IERC165 {
867     /**
868      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
869      */
870     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
871 
872     /**
873      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
874      */
875     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
876 
877     /**
878      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
879      */
880     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
881 
882     /**
883      * @dev Returns the number of tokens in ``owner``'s account.
884      */
885     function balanceOf(address owner) external view returns (uint256 balance);
886 
887     /**
888      * @dev Returns the owner of the `tokenId` token.
889      *
890      * Requirements:
891      *
892      * - `tokenId` must exist.
893      */
894     function ownerOf(uint256 tokenId) external view returns (address owner);
895 
896     /**
897      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
898      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
899      *
900      * Requirements:
901      *
902      * - `from` cannot be the zero address.
903      * - `to` cannot be the zero address.
904      * - `tokenId` token must exist and be owned by `from`.
905      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
906      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
907      *
908      * Emits a {Transfer} event.
909      */
910     function safeTransferFrom(
911         address from,
912         address to,
913         uint256 tokenId
914     ) external;
915 
916     /**
917      * @dev Transfers `tokenId` token from `from` to `to`.
918      *
919      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
920      *
921      * Requirements:
922      *
923      * - `from` cannot be the zero address.
924      * - `to` cannot be the zero address.
925      * - `tokenId` token must be owned by `from`.
926      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
927      *
928      * Emits a {Transfer} event.
929      */
930     function transferFrom(
931         address from,
932         address to,
933         uint256 tokenId
934     ) external;
935 
936     /**
937      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
938      * The approval is cleared when the token is transferred.
939      *
940      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
941      *
942      * Requirements:
943      *
944      * - The caller must own the token or be an approved operator.
945      * - `tokenId` must exist.
946      *
947      * Emits an {Approval} event.
948      */
949     function approve(address to, uint256 tokenId) external;
950 
951     /**
952      * @dev Returns the account approved for `tokenId` token.
953      *
954      * Requirements:
955      *
956      * - `tokenId` must exist.
957      */
958     function getApproved(uint256 tokenId) external view returns (address operator);
959 
960     /**
961      * @dev Approve or remove `operator` as an operator for the caller.
962      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
963      *
964      * Requirements:
965      *
966      * - The `operator` cannot be the caller.
967      *
968      * Emits an {ApprovalForAll} event.
969      */
970     function setApprovalForAll(address operator, bool _approved) external;
971 
972     /**
973      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
974      *
975      * See {setApprovalForAll}
976      */
977     function isApprovedForAll(address owner, address operator) external view returns (bool);
978 
979     /**
980      * @dev Safely transfers `tokenId` token from `from` to `to`.
981      *
982      * Requirements:
983      *
984      * - `from` cannot be the zero address.
985      * - `to` cannot be the zero address.
986      * - `tokenId` token must exist and be owned by `from`.
987      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
988      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
989      *
990      * Emits a {Transfer} event.
991      */
992     function safeTransferFrom(
993         address from,
994         address to,
995         uint256 tokenId,
996         bytes calldata data
997     ) external;
998 }
999 
1000 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1001 
1002 
1003 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
1004 
1005 pragma solidity ^0.8.0;
1006 
1007 
1008 /**
1009  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1010  * @dev See https://eips.ethereum.org/EIPS/eip-721
1011  */
1012 interface IERC721Enumerable is IERC721 {
1013     /**
1014      * @dev Returns the total amount of tokens stored by the contract.
1015      */
1016     function totalSupply() external view returns (uint256);
1017 
1018     /**
1019      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1020      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1021      */
1022     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1023 
1024     /**
1025      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1026      * Use along with {totalSupply} to enumerate all tokens.
1027      */
1028     function tokenByIndex(uint256 index) external view returns (uint256);
1029 }
1030 
1031 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1032 
1033 
1034 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1035 
1036 pragma solidity ^0.8.0;
1037 
1038 
1039 /**
1040  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1041  * @dev See https://eips.ethereum.org/EIPS/eip-721
1042  */
1043 interface IERC721Metadata is IERC721 {
1044     /**
1045      * @dev Returns the token collection name.
1046      */
1047     function name() external view returns (string memory);
1048 
1049     /**
1050      * @dev Returns the token collection symbol.
1051      */
1052     function symbol() external view returns (string memory);
1053 
1054     /**
1055      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1056      */
1057     function tokenURI(uint256 tokenId) external view returns (string memory);
1058 }
1059 
1060 // File: @openzeppelin/contracts/utils/Strings.sol
1061 
1062 
1063 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
1064 
1065 pragma solidity ^0.8.0;
1066 
1067 /**
1068  * @dev String operations.
1069  */
1070 library Strings {
1071     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1072 
1073     /**
1074      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1075      */
1076     function toString(uint256 value) internal pure returns (string memory) {
1077         // Inspired by OraclizeAPI's implementation - MIT licence
1078         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1079 
1080         if (value == 0) {
1081             return "0";
1082         }
1083         uint256 temp = value;
1084         uint256 digits;
1085         while (temp != 0) {
1086             digits++;
1087             temp /= 10;
1088         }
1089         bytes memory buffer = new bytes(digits);
1090         while (value != 0) {
1091             digits -= 1;
1092             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1093             value /= 10;
1094         }
1095         return string(buffer);
1096     }
1097 
1098     /**
1099      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1100      */
1101     function toHexString(uint256 value) internal pure returns (string memory) {
1102         if (value == 0) {
1103             return "0x00";
1104         }
1105         uint256 temp = value;
1106         uint256 length = 0;
1107         while (temp != 0) {
1108             length++;
1109             temp >>= 8;
1110         }
1111         return toHexString(value, length);
1112     }
1113 
1114     /**
1115      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1116      */
1117     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1118         bytes memory buffer = new bytes(2 * length + 2);
1119         buffer[0] = "0";
1120         buffer[1] = "x";
1121         for (uint256 i = 2 * length + 1; i > 1; --i) {
1122             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1123             value >>= 4;
1124         }
1125         require(value == 0, "Strings: hex length insufficient");
1126         return string(buffer);
1127     }
1128 }
1129 
1130 // File: contracts/ERC721A.sol
1131 
1132 
1133 // Creator: Chiru Labs
1134 // commit e03a377 - 2/26/2022
1135 pragma solidity ^0.8.4;
1136 
1137 
1138 
1139 
1140 
1141 
1142 
1143 
1144 
1145 error ApprovalCallerNotOwnerNorApproved();
1146 error ApprovalQueryForNonexistentToken();
1147 error ApproveToCaller();
1148 error ApprovalToCurrentOwner();
1149 error BalanceQueryForZeroAddress();
1150 error MintedQueryForZeroAddress();
1151 error BurnedQueryForZeroAddress();
1152 error AuxQueryForZeroAddress();
1153 error MintToZeroAddress();
1154 error MintZeroQuantity();
1155 error OwnerIndexOutOfBounds();
1156 error OwnerQueryForNonexistentToken();
1157 error TokenIndexOutOfBounds();
1158 error TransferCallerNotOwnerNorApproved();
1159 error TransferFromIncorrectOwner();
1160 error TransferToNonERC721ReceiverImplementer();
1161 error TransferToZeroAddress();
1162 error URIQueryForNonexistentToken();
1163 
1164 /**
1165  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1166  * the Metadata extension. Built to optimize for lower gas during batch mints.
1167  *
1168  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
1169  *
1170  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1171  *
1172  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
1173  */
1174 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
1175     using Address for address;
1176     using Strings for uint256;
1177 
1178     // Compiler will pack this into a single 256bit word.
1179     struct TokenOwnership {
1180         // The address of the owner.
1181         address addr;
1182         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
1183         uint64 startTimestamp;
1184         // Whether the token has been burned.
1185         bool burned;
1186     }
1187 
1188     // Compiler will pack this into a single 256bit word.
1189     struct AddressData {
1190         // Realistically, 2**64-1 is more than enough.
1191         uint64 balance;
1192         // Keeps track of mint count with minimal overhead for tokenomics.
1193         uint64 numberMinted;
1194         // Keeps track of burn count with minimal overhead for tokenomics.
1195         uint64 numberBurned;
1196         // For miscellaneous variable(s) pertaining to the address
1197         // (e.g. number of whitelist mint slots used).
1198         // If there are multiple variables, please pack them into a uint64.
1199         uint64 aux;
1200     }
1201 
1202     // The tokenId of the next token to be minted.
1203     uint256 internal _currentIndex;
1204 
1205     // The number of tokens burned.
1206     uint256 internal _burnCounter;
1207 
1208     // Token name
1209     string private _name;
1210 
1211     // Token symbol
1212     string private _symbol;
1213 
1214     // Mapping from token ID to ownership details
1215     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1216     mapping(uint256 => TokenOwnership) internal _ownerships;
1217 
1218     // Mapping owner address to address data
1219     mapping(address => AddressData) private _addressData;
1220 
1221     // Mapping from token ID to approved address
1222     mapping(uint256 => address) private _tokenApprovals;
1223 
1224     // Mapping from owner to operator approvals
1225     mapping(address => mapping(address => bool)) private _operatorApprovals;
1226 
1227     constructor(string memory name_, string memory symbol_)  {
1228         _name = name_;
1229         _symbol = symbol_;
1230         _currentIndex = _startTokenId();
1231     }
1232 
1233     /**
1234      * To change the starting tokenId, please override this function.
1235      */
1236     function _startTokenId() internal view virtual returns (uint256) {
1237         return 0;
1238     }
1239 
1240     /**
1241      * @dev See {IERC721Enumerable-totalSupply}.
1242      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
1243      */
1244     function totalSupply() public view returns (uint256) {
1245         // Counter underflow is impossible as _burnCounter cannot be incremented
1246         // more than _currentIndex - _startTokenId() times
1247         unchecked {
1248             return _currentIndex - _burnCounter - _startTokenId();
1249         }
1250     }
1251 
1252     /**
1253      * Returns the total amount of tokens minted in the contract.
1254      */
1255     function _totalMinted() internal view returns (uint256) {
1256         // Counter underflow is impossible as _currentIndex does not decrement,
1257         // and it is initialized to _startTokenId()
1258         unchecked {
1259             return _currentIndex - _startTokenId();
1260         }
1261     }
1262 
1263     /**
1264      * @dev See {IERC165-supportsInterface}.
1265      */
1266     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1267         return
1268             interfaceId == type(IERC721).interfaceId ||
1269             interfaceId == type(IERC721Metadata).interfaceId ||
1270             super.supportsInterface(interfaceId);
1271     }
1272 
1273     /**
1274      * @dev See {IERC721-balanceOf}.
1275      */
1276     function balanceOf(address owner) public view override returns (uint256) {
1277         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1278         return uint256(_addressData[owner].balance);
1279     }
1280 
1281     /**
1282      * Returns the number of tokens minted by `owner`.
1283      */
1284     function _numberMinted(address owner) internal view returns (uint256) {
1285         if (owner == address(0)) revert MintedQueryForZeroAddress();
1286         return uint256(_addressData[owner].numberMinted);
1287     }
1288 
1289     /**
1290      * Returns the number of tokens burned by or on behalf of `owner`.
1291      */
1292     function _numberBurned(address owner) internal view returns (uint256) {
1293         if (owner == address(0)) revert BurnedQueryForZeroAddress();
1294         return uint256(_addressData[owner].numberBurned);
1295     }
1296 
1297     /**
1298      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1299      */
1300     function _getAux(address owner) internal view returns (uint64) {
1301         if (owner == address(0)) revert AuxQueryForZeroAddress();
1302         return _addressData[owner].aux;
1303     }
1304 
1305     /**
1306      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1307      * If there are multiple variables, please pack them into a uint64.
1308      */
1309     function _setAux(address owner, uint64 aux) internal {
1310         if (owner == address(0)) revert AuxQueryForZeroAddress();
1311         _addressData[owner].aux = aux;
1312     }
1313 
1314     /**
1315      * Gas spent here starts off proportional to the maximum mint batch size.
1316      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1317      */
1318     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1319         uint256 curr = tokenId;
1320 
1321         unchecked {
1322             if (_startTokenId() <= curr && curr < _currentIndex) {
1323                 TokenOwnership memory ownership = _ownerships[curr];
1324                 if (!ownership.burned) {
1325                     if (ownership.addr != address(0)) {
1326                         return ownership;
1327                     }
1328                     // Invariant:
1329                     // There will always be an ownership that has an address and is not burned
1330                     // before an ownership that does not have an address and is not burned.
1331                     // Hence, curr will not underflow.
1332                     while (true) {
1333                         curr--;
1334                         ownership = _ownerships[curr];
1335                         if (ownership.addr != address(0)) {
1336                             return ownership;
1337                         }
1338                     }
1339                 }
1340             }
1341         }
1342         revert OwnerQueryForNonexistentToken();
1343     }
1344 
1345     /**
1346      * @dev See {IERC721-ownerOf}.
1347      */
1348     function ownerOf(uint256 tokenId) public view override returns (address) {
1349         return ownershipOf(tokenId).addr;
1350     }
1351 
1352     /**
1353      * @dev See {IERC721Metadata-name}.
1354      */
1355     function name() public view virtual override returns (string memory) {
1356         return _name;
1357     }
1358 
1359     /**
1360      * @dev See {IERC721Metadata-symbol}.
1361      */
1362     function symbol() public view virtual override returns (string memory) {
1363         return _symbol;
1364     }
1365 
1366     /**
1367      * @dev See {IERC721Metadata-tokenURI}.
1368      */
1369     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1370         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1371 
1372         string memory baseURI = _baseURI();
1373         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1374     }
1375 
1376     /**
1377      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1378      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1379      * by default, can be overriden in child contracts.
1380      */
1381     function _baseURI() internal view virtual returns (string memory) {
1382         return '';
1383     }
1384 
1385     /**
1386      * @dev See {IERC721-approve}.
1387      */
1388     function approve(address to, uint256 tokenId) public override {
1389         address owner = ERC721A.ownerOf(tokenId);
1390         if (to == owner) revert ApprovalToCurrentOwner();
1391 
1392         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1393             revert ApprovalCallerNotOwnerNorApproved();
1394         }
1395 
1396         _approve(to, tokenId, owner);
1397     }
1398 
1399     /**
1400      * @dev See {IERC721-getApproved}.
1401      */
1402     function getApproved(uint256 tokenId) public view override returns (address) {
1403         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1404 
1405         return _tokenApprovals[tokenId];
1406     }
1407 
1408     /**
1409      * @dev See {IERC721-setApprovalForAll}.
1410      */
1411     function setApprovalForAll(address operator, bool approved) public override {
1412         if (operator == _msgSender()) revert ApproveToCaller();
1413 
1414         _operatorApprovals[_msgSender()][operator] = approved;
1415         emit ApprovalForAll(_msgSender(), operator, approved);
1416     }
1417 
1418     /**
1419      * @dev See {IERC721-isApprovedForAll}.
1420      */
1421     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1422         return _operatorApprovals[owner][operator];
1423     }
1424 
1425     /**
1426      * @dev See {IERC721-transferFrom}.
1427      */
1428     function transferFrom(
1429         address from,
1430         address to,
1431         uint256 tokenId
1432     ) public virtual override {
1433         _transfer(from, to, tokenId);
1434     }
1435 
1436     /**
1437      * @dev See {IERC721-safeTransferFrom}.
1438      */
1439     function safeTransferFrom(
1440         address from,
1441         address to,
1442         uint256 tokenId
1443     ) public virtual override {
1444         safeTransferFrom(from, to, tokenId, '');
1445     }
1446 
1447     /**
1448      * @dev See {IERC721-safeTransferFrom}.
1449      */
1450     function safeTransferFrom(
1451         address from,
1452         address to,
1453         uint256 tokenId,
1454         bytes memory _data
1455     ) public virtual override {
1456         _transfer(from, to, tokenId);
1457         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1458             revert TransferToNonERC721ReceiverImplementer();
1459         }
1460     }
1461 
1462     /**
1463      * @dev Returns whether `tokenId` exists.
1464      *
1465      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1466      *
1467      * Tokens start existing when they are minted (`_mint`),
1468      */
1469     function _exists(uint256 tokenId) internal view returns (bool) {
1470         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1471             !_ownerships[tokenId].burned;
1472     }
1473 
1474     function _safeMint(address to, uint256 quantity) internal {
1475         _safeMint(to, quantity, '');
1476     }
1477 
1478     /**
1479      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1480      *
1481      * Requirements:
1482      *
1483      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1484      * - `quantity` must be greater than 0.
1485      *
1486      * Emits a {Transfer} event.
1487      */
1488     function _safeMint(
1489         address to,
1490         uint256 quantity,
1491         bytes memory _data
1492     ) internal {
1493         _mint(to, quantity, _data, true);
1494     }
1495 
1496     /**
1497      * @dev Mints `quantity` tokens and transfers them to `to`.
1498      *
1499      * Requirements:
1500      *
1501      * - `to` cannot be the zero address.
1502      * - `quantity` must be greater than 0.
1503      *
1504      * Emits a {Transfer} event.
1505      */
1506     function _mint(
1507         address to,
1508         uint256 quantity,
1509         bytes memory _data,
1510         bool safe
1511     ) internal {
1512         uint256 startTokenId = _currentIndex;
1513         if (to == address(0)) revert MintToZeroAddress();
1514         if (quantity == 0) revert MintZeroQuantity();
1515 
1516         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1517 
1518         // Overflows are incredibly unrealistic.
1519         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1520         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1521         unchecked {
1522             _addressData[to].balance += uint64(quantity);
1523             _addressData[to].numberMinted += uint64(quantity);
1524 
1525             _ownerships[startTokenId].addr = to;
1526             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1527 
1528             uint256 updatedIndex = startTokenId;
1529             uint256 end = updatedIndex + quantity;
1530 
1531             if (safe && to.isContract()) {
1532                 do {
1533                     emit Transfer(address(0), to, updatedIndex);
1534                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1535                         revert TransferToNonERC721ReceiverImplementer();
1536                     }
1537                 } while (updatedIndex != end);
1538                 // Reentrancy protection
1539                 if (_currentIndex != startTokenId) revert();
1540             } else {
1541                 do {
1542                     emit Transfer(address(0), to, updatedIndex++);
1543                 } while (updatedIndex != end);
1544             }
1545             _currentIndex = updatedIndex;
1546         }
1547         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1548     }
1549 
1550     /**
1551      * @dev Transfers `tokenId` from `from` to `to`.
1552      *
1553      * Requirements:
1554      *
1555      * - `to` cannot be the zero address.
1556      * - `tokenId` token must be owned by `from`.
1557      *
1558      * Emits a {Transfer} event.
1559      */
1560     function _transfer(
1561         address from,
1562         address to,
1563         uint256 tokenId
1564     ) private {
1565         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1566 
1567         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1568             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1569             getApproved(tokenId) == _msgSender());
1570 
1571         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1572         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1573         if (to == address(0)) revert TransferToZeroAddress();
1574 
1575         _beforeTokenTransfers(from, to, tokenId, 1);
1576 
1577         // Clear approvals from the previous owner
1578         _approve(address(0), tokenId, prevOwnership.addr);
1579 
1580         // Underflow of the sender's balance is impossible because we check for
1581         // ownership above and the recipient's balance can't realistically overflow.
1582         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1583         unchecked {
1584             _addressData[from].balance -= 1;
1585             _addressData[to].balance += 1;
1586 
1587             _ownerships[tokenId].addr = to;
1588             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1589 
1590             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1591             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1592             uint256 nextTokenId = tokenId + 1;
1593             if (_ownerships[nextTokenId].addr == address(0)) {
1594                 // This will suffice for checking _exists(nextTokenId),
1595                 // as a burned slot cannot contain the zero address.
1596                 if (nextTokenId < _currentIndex) {
1597                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1598                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1599                 }
1600             }
1601         }
1602 
1603         emit Transfer(from, to, tokenId);
1604         _afterTokenTransfers(from, to, tokenId, 1);
1605     }
1606 
1607     /**
1608      * @dev Destroys `tokenId`.
1609      * The approval is cleared when the token is burned.
1610      *
1611      * Requirements:
1612      *
1613      * - `tokenId` must exist.
1614      *
1615      * Emits a {Transfer} event.
1616      */
1617     function _burn(uint256 tokenId) internal virtual {
1618         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1619 
1620         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1621 
1622         // Clear approvals from the previous owner
1623         _approve(address(0), tokenId, prevOwnership.addr);
1624 
1625         // Underflow of the sender's balance is impossible because we check for
1626         // ownership above and the recipient's balance can't realistically overflow.
1627         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1628         unchecked {
1629             _addressData[prevOwnership.addr].balance -= 1;
1630             _addressData[prevOwnership.addr].numberBurned += 1;
1631 
1632             // Keep track of who burned the token, and the timestamp of burning.
1633             _ownerships[tokenId].addr = prevOwnership.addr;
1634             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1635             _ownerships[tokenId].burned = true;
1636 
1637             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1638             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1639             uint256 nextTokenId = tokenId + 1;
1640             if (_ownerships[nextTokenId].addr == address(0)) {
1641                 // This will suffice for checking _exists(nextTokenId),
1642                 // as a burned slot cannot contain the zero address.
1643                 if (nextTokenId < _currentIndex) {
1644                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1645                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1646                 }
1647             }
1648         }
1649 
1650         emit Transfer(prevOwnership.addr, address(0), tokenId);
1651         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1652 
1653         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1654         unchecked {
1655             _burnCounter++;
1656         }
1657     }
1658 
1659     /**
1660      * @dev Approve `to` to operate on `tokenId`
1661      *
1662      * Emits a {Approval} event.
1663      */
1664     function _approve(
1665         address to,
1666         uint256 tokenId,
1667         address owner
1668     ) private {
1669         _tokenApprovals[tokenId] = to;
1670         emit Approval(owner, to, tokenId);
1671     }
1672 
1673     /**
1674      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1675      *
1676      * @param from address representing the previous owner of the given token ID
1677      * @param to target address that will receive the tokens
1678      * @param tokenId uint256 ID of the token to be transferred
1679      * @param _data bytes optional data to send along with the call
1680      * @return bool whether the call correctly returned the expected magic value
1681      */
1682     function _checkContractOnERC721Received(
1683         address from,
1684         address to,
1685         uint256 tokenId,
1686         bytes memory _data
1687     ) private returns (bool) {
1688         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1689             return retval == IERC721Receiver(to).onERC721Received.selector;
1690         } catch (bytes memory reason) {
1691             if (reason.length == 0) {
1692                 revert TransferToNonERC721ReceiverImplementer();
1693             } else {
1694                 assembly {
1695                     revert(add(32, reason), mload(reason))
1696                 }
1697             }
1698         }
1699     }
1700 
1701     /**
1702      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1703      * And also called before burning one token.
1704      *
1705      * startTokenId - the first token id to be transferred
1706      * quantity - the amount to be transferred
1707      *
1708      * Calling conditions:
1709      *
1710      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1711      * transferred to `to`.
1712      * - When `from` is zero, `tokenId` will be minted for `to`.
1713      * - When `to` is zero, `tokenId` will be burned by `from`.
1714      * - `from` and `to` are never both zero.
1715      */
1716     function _beforeTokenTransfers(
1717         address from,
1718         address to,
1719         uint256 startTokenId,
1720         uint256 quantity
1721     ) internal virtual {}
1722 
1723     /**
1724      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1725      * minting.
1726      * And also called after one token has been burned.
1727      *
1728      * startTokenId - the first token id to be transferred
1729      * quantity - the amount to be transferred
1730      *
1731      * Calling conditions:
1732      *
1733      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1734      * transferred to `to`.
1735      * - When `from` is zero, `tokenId` has been minted for `to`.
1736      * - When `to` is zero, `tokenId` has been burned by `from`.
1737      * - `from` and `to` are never both zero.
1738      */
1739     function _afterTokenTransfers(
1740         address from,
1741         address to,
1742         uint256 startTokenId,
1743         uint256 quantity
1744     ) internal virtual {}
1745 }
1746 // File: contracts/FamilyTees.sol
1747 
1748 
1749 // Authored by NoahN w/ Metavate ✌️
1750 pragma solidity ^0.8.11;
1751 
1752 
1753 
1754 
1755 
1756 
1757 
1758 contract FamilyTees is ERC721A, Ownable, PaymentSplitter{ 
1759   	using Strings for uint256;
1760 
1761     uint256 public cost = 0.05 ether;
1762     uint256 public discountCost = 0.04 ether;
1763     uint256 public maxSupply = 3333;
1764 
1765     bool public sale = false;
1766 	bool public presale = false;
1767 
1768 	string public baseURI;
1769 
1770 	bytes32 public merkleRoot;
1771 
1772 	address private admin = 0x8DFdD0FF4661abd44B06b1204C6334eACc8575af;
1773     
1774 	mapping(address => bool) public discountContracts;
1775 
1776 	constructor(string memory _name, string memory _symbol, address[] memory recipients, uint256[] memory split)
1777     ERC721A(_name, _symbol)
1778 	PaymentSplitter(recipients, split){
1779     }
1780 
1781 	modifier onlyTeam {
1782         require(msg.sender == owner() || msg.sender == admin, "Not team" );
1783         _;
1784     }
1785 
1786     function mint(uint256 mintQty) public payable {
1787         require(sale, "Sale");
1788         require(mintQty * cost == msg.value, "ETH value");
1789         require(mintQty < 11, "Too many");
1790         require(mintQty + totalSupply() <= maxSupply, "Max supply");
1791         require(tx.origin == msg.sender, "From contract");
1792         
1793         _safeMint(msg.sender, mintQty);
1794     }
1795 
1796 	function presaleMint(uint256 mintQty, bytes32[] calldata _merkleProof) public payable {
1797         require(presale, "Presale");
1798         require(mintQty * discountCost == msg.value, "ETH value");
1799         require(mintQty < 11, "Too many");
1800         require(mintQty + totalSupply() <= maxSupply, "Max supply");
1801         require(MerkleProof.verify(_merkleProof, merkleRoot, keccak256(abi.encodePacked(msg.sender))), "Whitelist");
1802         require(tx.origin == msg.sender, "Sender");
1803 
1804         _safeMint(msg.sender, mintQty);
1805     }
1806 
1807 	function presaleMint(uint256 mintQty, address discountAddress, uint256 tokenId) public payable {
1808         require(presale, "Presale");
1809         require(discountContracts[discountAddress], "Not partner");
1810         require(IERC721(discountAddress).ownerOf(tokenId) == msg.sender, "Not owner");
1811         require(mintQty * discountCost == msg.value, "ETH value");
1812         require(mintQty < 11, "Too many");
1813         require(mintQty + totalSupply() <= maxSupply, "Max supply");
1814         require(tx.origin == msg.sender, "Sender");
1815         
1816         _safeMint(msg.sender, mintQty);
1817     }
1818 
1819 	function devMint(uint256 quantity, address recipient) external onlyTeam{    	
1820         require(quantity + totalSupply() <= maxSupply, "Max supply");
1821        	_safeMint(recipient, quantity);
1822 	}
1823 
1824 	function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1825     	require(_exists(tokenId), "ERC721Metadata: Nonexistent token");
1826     	string memory currentBaseURI = _baseURI();
1827     	return bytes(currentBaseURI).length > 0	? string(abi.encodePacked(currentBaseURI, tokenId.toString(), ".json")) : "";
1828 	}
1829 	
1830 	function setDiscountContracts(address[] memory contracts, bool onoroff) public onlyTeam {
1831 		for(uint i = 0; i < contracts.length; ++i){
1832     	    discountContracts[contracts[i]] = onoroff;
1833     	}	
1834 	}
1835 
1836 	function setBaseURI(string memory _newBaseURI) public onlyTeam {
1837 	    baseURI = _newBaseURI;
1838 	}
1839 
1840 	function toggleSale() public onlyTeam {
1841 	    sale = !sale;
1842 	}
1843 
1844 	function togglePresale() public onlyTeam {
1845 		presale  = !presale;
1846 	}
1847 	
1848 	function _baseURI() internal view virtual override returns (string memory) {
1849 	    return baseURI;
1850 	}
1851     
1852     function updateMerkleRoot(bytes32 _merkleRoot) public onlyTeam{
1853 	    merkleRoot = _merkleRoot;
1854 	}
1855 
1856 	function _startTokenId() internal view virtual override returns (uint256) {
1857         return 1;
1858     }
1859 
1860 	fallback() payable external {}
1861 }