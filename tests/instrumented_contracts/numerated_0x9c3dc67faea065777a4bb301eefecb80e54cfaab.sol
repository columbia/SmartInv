1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
4 
5 
6 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/MerkleProof.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev These functions deal with verification of Merkle Trees proofs.
12  *
13  * The proofs can be generated using the JavaScript library
14  * https://github.com/miguelmota/merkletreejs[merkletreejs].
15  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
16  *
17  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
18  */
19 library MerkleProof {
20     /**
21      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
22      * defined by `root`. For this, a `proof` must be provided, containing
23      * sibling hashes on the branch from the leaf to the root of the tree. Each
24      * pair of leaves and each pair of pre-images are assumed to be sorted.
25      */
26     function verify(
27         bytes32[] memory proof,
28         bytes32 root,
29         bytes32 leaf
30     ) internal pure returns (bool) {
31         return processProof(proof, leaf) == root;
32     }
33 
34     /**
35      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
36      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
37      * hash matches the root of the tree. When processing the proof, the pairs
38      * of leafs & pre-images are assumed to be sorted.
39      *
40      * _Available since v4.4._
41      */
42     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
43         bytes32 computedHash = leaf;
44         for (uint256 i = 0; i < proof.length; i++) {
45             bytes32 proofElement = proof[i];
46             if (computedHash <= proofElement) {
47                 // Hash(current computed hash + current element of the proof)
48                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
49             } else {
50                 // Hash(current element of the proof + current computed hash)
51                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
52             }
53         }
54         return computedHash;
55     }
56 }
57 
58 // File: @openzeppelin/contracts/utils/Context.sol
59 
60 
61 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
62 
63 pragma solidity ^0.8.0;
64 
65 /**
66  * @dev Provides information about the current execution context, including the
67  * sender of the transaction and its data. While these are generally available
68  * via msg.sender and msg.data, they should not be accessed in such a direct
69  * manner, since when dealing with meta-transactions the account sending and
70  * paying for execution may not be the actual sender (as far as an application
71  * is concerned).
72  *
73  * This contract is only required for intermediate, library-like contracts.
74  */
75 abstract contract Context {
76     function _msgSender() internal view virtual returns (address) {
77         return msg.sender;
78     }
79 
80     function _msgData() internal view virtual returns (bytes calldata) {
81         return msg.data;
82     }
83 }
84 
85 // File: @openzeppelin/contracts/utils/Address.sol
86 
87 
88 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
89 
90 pragma solidity ^0.8.0;
91 
92 /**
93  * @dev Collection of functions related to the address type
94  */
95 library Address {
96     /**
97      * @dev Returns true if `account` is a contract.
98      *
99      * [IMPORTANT]
100      * ====
101      * It is unsafe to assume that an address for which this function returns
102      * false is an externally-owned account (EOA) and not a contract.
103      *
104      * Among others, `isContract` will return false for the following
105      * types of addresses:
106      *
107      *  - an externally-owned account
108      *  - a contract in construction
109      *  - an address where a contract will be created
110      *  - an address where a contract lived, but was destroyed
111      * ====
112      */
113     function isContract(address account) internal view returns (bool) {
114         // This method relies on extcodesize, which returns 0 for contracts in
115         // construction, since the code is only stored at the end of the
116         // constructor execution.
117 
118         uint256 size;
119         assembly {
120             size := extcodesize(account)
121         }
122         return size > 0;
123     }
124 
125     /**
126      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
127      * `recipient`, forwarding all available gas and reverting on errors.
128      *
129      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
130      * of certain opcodes, possibly making contracts go over the 2300 gas limit
131      * imposed by `transfer`, making them unable to receive funds via
132      * `transfer`. {sendValue} removes this limitation.
133      *
134      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
135      *
136      * IMPORTANT: because control is transferred to `recipient`, care must be
137      * taken to not create reentrancy vulnerabilities. Consider using
138      * {ReentrancyGuard} or the
139      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
140      */
141     function sendValue(address payable recipient, uint256 amount) internal {
142         require(address(this).balance >= amount, "Address: insufficient balance");
143 
144         (bool success, ) = recipient.call{value: amount}("");
145         require(success, "Address: unable to send value, recipient may have reverted");
146     }
147 
148     /**
149      * @dev Performs a Solidity function call using a low level `call`. A
150      * plain `call` is an unsafe replacement for a function call: use this
151      * function instead.
152      *
153      * If `target` reverts with a revert reason, it is bubbled up by this
154      * function (like regular Solidity function calls).
155      *
156      * Returns the raw returned data. To convert to the expected return value,
157      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
158      *
159      * Requirements:
160      *
161      * - `target` must be a contract.
162      * - calling `target` with `data` must not revert.
163      *
164      * _Available since v3.1._
165      */
166     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
167         return functionCall(target, data, "Address: low-level call failed");
168     }
169 
170     /**
171      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
172      * `errorMessage` as a fallback revert reason when `target` reverts.
173      *
174      * _Available since v3.1._
175      */
176     function functionCall(
177         address target,
178         bytes memory data,
179         string memory errorMessage
180     ) internal returns (bytes memory) {
181         return functionCallWithValue(target, data, 0, errorMessage);
182     }
183 
184     /**
185      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
186      * but also transferring `value` wei to `target`.
187      *
188      * Requirements:
189      *
190      * - the calling contract must have an ETH balance of at least `value`.
191      * - the called Solidity function must be `payable`.
192      *
193      * _Available since v3.1._
194      */
195     function functionCallWithValue(
196         address target,
197         bytes memory data,
198         uint256 value
199     ) internal returns (bytes memory) {
200         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
201     }
202 
203     /**
204      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
205      * with `errorMessage` as a fallback revert reason when `target` reverts.
206      *
207      * _Available since v3.1._
208      */
209     function functionCallWithValue(
210         address target,
211         bytes memory data,
212         uint256 value,
213         string memory errorMessage
214     ) internal returns (bytes memory) {
215         require(address(this).balance >= value, "Address: insufficient balance for call");
216         require(isContract(target), "Address: call to non-contract");
217 
218         (bool success, bytes memory returndata) = target.call{value: value}(data);
219         return verifyCallResult(success, returndata, errorMessage);
220     }
221 
222     /**
223      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
224      * but performing a static call.
225      *
226      * _Available since v3.3._
227      */
228     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
229         return functionStaticCall(target, data, "Address: low-level static call failed");
230     }
231 
232     /**
233      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
234      * but performing a static call.
235      *
236      * _Available since v3.3._
237      */
238     function functionStaticCall(
239         address target,
240         bytes memory data,
241         string memory errorMessage
242     ) internal view returns (bytes memory) {
243         require(isContract(target), "Address: static call to non-contract");
244 
245         (bool success, bytes memory returndata) = target.staticcall(data);
246         return verifyCallResult(success, returndata, errorMessage);
247     }
248 
249     /**
250      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
251      * but performing a delegate call.
252      *
253      * _Available since v3.4._
254      */
255     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
256         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
257     }
258 
259     /**
260      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
261      * but performing a delegate call.
262      *
263      * _Available since v3.4._
264      */
265     function functionDelegateCall(
266         address target,
267         bytes memory data,
268         string memory errorMessage
269     ) internal returns (bytes memory) {
270         require(isContract(target), "Address: delegate call to non-contract");
271 
272         (bool success, bytes memory returndata) = target.delegatecall(data);
273         return verifyCallResult(success, returndata, errorMessage);
274     }
275 
276     /**
277      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
278      * revert reason using the provided one.
279      *
280      * _Available since v4.3._
281      */
282     function verifyCallResult(
283         bool success,
284         bytes memory returndata,
285         string memory errorMessage
286     ) internal pure returns (bytes memory) {
287         if (success) {
288             return returndata;
289         } else {
290             // Look for revert reason and bubble it up if present
291             if (returndata.length > 0) {
292                 // The easiest way to bubble the revert reason is using memory via assembly
293 
294                 assembly {
295                     let returndata_size := mload(returndata)
296                     revert(add(32, returndata), returndata_size)
297                 }
298             } else {
299                 revert(errorMessage);
300             }
301         }
302     }
303 }
304 
305 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
306 
307 
308 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
309 
310 pragma solidity ^0.8.0;
311 
312 /**
313  * @dev Interface of the ERC20 standard as defined in the EIP.
314  */
315 interface IERC20 {
316     /**
317      * @dev Returns the amount of tokens in existence.
318      */
319     function totalSupply() external view returns (uint256);
320 
321     /**
322      * @dev Returns the amount of tokens owned by `account`.
323      */
324     function balanceOf(address account) external view returns (uint256);
325 
326     /**
327      * @dev Moves `amount` tokens from the caller's account to `to`.
328      *
329      * Returns a boolean value indicating whether the operation succeeded.
330      *
331      * Emits a {Transfer} event.
332      */
333     function transfer(address to, uint256 amount) external returns (bool);
334 
335     /**
336      * @dev Returns the remaining number of tokens that `spender` will be
337      * allowed to spend on behalf of `owner` through {transferFrom}. This is
338      * zero by default.
339      *
340      * This value changes when {approve} or {transferFrom} are called.
341      */
342     function allowance(address owner, address spender) external view returns (uint256);
343 
344     /**
345      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
346      *
347      * Returns a boolean value indicating whether the operation succeeded.
348      *
349      * IMPORTANT: Beware that changing an allowance with this method brings the risk
350      * that someone may use both the old and the new allowance by unfortunate
351      * transaction ordering. One possible solution to mitigate this race
352      * condition is to first reduce the spender's allowance to 0 and set the
353      * desired value afterwards:
354      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
355      *
356      * Emits an {Approval} event.
357      */
358     function approve(address spender, uint256 amount) external returns (bool);
359 
360     /**
361      * @dev Moves `amount` tokens from `from` to `to` using the
362      * allowance mechanism. `amount` is then deducted from the caller's
363      * allowance.
364      *
365      * Returns a boolean value indicating whether the operation succeeded.
366      *
367      * Emits a {Transfer} event.
368      */
369     function transferFrom(
370         address from,
371         address to,
372         uint256 amount
373     ) external returns (bool);
374 
375     /**
376      * @dev Emitted when `value` tokens are moved from one account (`from`) to
377      * another (`to`).
378      *
379      * Note that `value` may be zero.
380      */
381     event Transfer(address indexed from, address indexed to, uint256 value);
382 
383     /**
384      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
385      * a call to {approve}. `value` is the new allowance.
386      */
387     event Approval(address indexed owner, address indexed spender, uint256 value);
388 }
389 
390 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
391 
392 
393 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
394 
395 pragma solidity ^0.8.0;
396 
397 
398 
399 /**
400  * @title SafeERC20
401  * @dev Wrappers around ERC20 operations that throw on failure (when the token
402  * contract returns false). Tokens that return no value (and instead revert or
403  * throw on failure) are also supported, non-reverting calls are assumed to be
404  * successful.
405  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
406  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
407  */
408 library SafeERC20 {
409     using Address for address;
410 
411     function safeTransfer(
412         IERC20 token,
413         address to,
414         uint256 value
415     ) internal {
416         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
417     }
418 
419     function safeTransferFrom(
420         IERC20 token,
421         address from,
422         address to,
423         uint256 value
424     ) internal {
425         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
426     }
427 
428     /**
429      * @dev Deprecated. This function has issues similar to the ones found in
430      * {IERC20-approve}, and its usage is discouraged.
431      *
432      * Whenever possible, use {safeIncreaseAllowance} and
433      * {safeDecreaseAllowance} instead.
434      */
435     function safeApprove(
436         IERC20 token,
437         address spender,
438         uint256 value
439     ) internal {
440         // safeApprove should only be called when setting an initial allowance,
441         // or when resetting it to zero. To increase and decrease it, use
442         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
443         require(
444             (value == 0) || (token.allowance(address(this), spender) == 0),
445             "SafeERC20: approve from non-zero to non-zero allowance"
446         );
447         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
448     }
449 
450     function safeIncreaseAllowance(
451         IERC20 token,
452         address spender,
453         uint256 value
454     ) internal {
455         uint256 newAllowance = token.allowance(address(this), spender) + value;
456         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
457     }
458 
459     function safeDecreaseAllowance(
460         IERC20 token,
461         address spender,
462         uint256 value
463     ) internal {
464         unchecked {
465             uint256 oldAllowance = token.allowance(address(this), spender);
466             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
467             uint256 newAllowance = oldAllowance - value;
468             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
469         }
470     }
471 
472     /**
473      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
474      * on the return value: the return value is optional (but if data is returned, it must not be false).
475      * @param token The token targeted by the call.
476      * @param data The call data (encoded using abi.encode or one of its variants).
477      */
478     function _callOptionalReturn(IERC20 token, bytes memory data) private {
479         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
480         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
481         // the target address contains contract code and also asserts for success in the low-level call.
482 
483         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
484         if (returndata.length > 0) {
485             // Return data is optional
486             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
487         }
488     }
489 }
490 
491 // File: @openzeppelin/contracts/finance/PaymentSplitter.sol
492 
493 
494 // OpenZeppelin Contracts v4.4.1 (finance/PaymentSplitter.sol)
495 
496 pragma solidity ^0.8.0;
497 
498 
499 
500 
501 /**
502  * @title PaymentSplitter
503  * @dev This contract allows to split Ether payments among a group of accounts. The sender does not need to be aware
504  * that the Ether will be split in this way, since it is handled transparently by the contract.
505  *
506  * The split can be in equal parts or in any other arbitrary proportion. The way this is specified is by assigning each
507  * account to a number of shares. Of all the Ether that this contract receives, each account will then be able to claim
508  * an amount proportional to the percentage of total shares they were assigned.
509  *
510  * `PaymentSplitter` follows a _pull payment_ model. This means that payments are not automatically forwarded to the
511  * accounts but kept in this contract, and the actual transfer is triggered as a separate step by calling the {release}
512  * function.
513  *
514  * NOTE: This contract assumes that ERC20 tokens will behave similarly to native tokens (Ether). Rebasing tokens, and
515  * tokens that apply fees during transfers, are likely to not be supported as expected. If in doubt, we encourage you
516  * to run tests before sending real value to this contract.
517  */
518 contract PaymentSplitter is Context {
519     event PayeeAdded(address account, uint256 shares);
520     event PaymentReleased(address to, uint256 amount);
521     event ERC20PaymentReleased(IERC20 indexed token, address to, uint256 amount);
522     event PaymentReceived(address from, uint256 amount);
523 
524     uint256 private _totalShares;
525     uint256 private _totalReleased;
526 
527     mapping(address => uint256) private _shares;
528     mapping(address => uint256) private _released;
529     address[] private _payees;
530 
531     mapping(IERC20 => uint256) private _erc20TotalReleased;
532     mapping(IERC20 => mapping(address => uint256)) private _erc20Released;
533 
534     /**
535      * @dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at
536      * the matching position in the `shares` array.
537      *
538      * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no
539      * duplicates in `payees`.
540      */
541     constructor(address[] memory payees, uint256[] memory shares_) payable {
542         require(payees.length == shares_.length, "PaymentSplitter: payees and shares length mismatch");
543         require(payees.length > 0, "PaymentSplitter: no payees");
544 
545         for (uint256 i = 0; i < payees.length; i++) {
546             _addPayee(payees[i], shares_[i]);
547         }
548     }
549 
550     /**
551      * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully
552      * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
553      * reliability of the events, and not the actual splitting of Ether.
554      *
555      * To learn more about this see the Solidity documentation for
556      * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
557      * functions].
558      */
559     receive() external payable virtual {
560         emit PaymentReceived(_msgSender(), msg.value);
561     }
562 
563     /**
564      * @dev Getter for the total shares held by payees.
565      */
566     function totalShares() public view returns (uint256) {
567         return _totalShares;
568     }
569 
570     /**
571      * @dev Getter for the total amount of Ether already released.
572      */
573     function totalReleased() public view returns (uint256) {
574         return _totalReleased;
575     }
576 
577     /**
578      * @dev Getter for the total amount of `token` already released. `token` should be the address of an IERC20
579      * contract.
580      */
581     function totalReleased(IERC20 token) public view returns (uint256) {
582         return _erc20TotalReleased[token];
583     }
584 
585     /**
586      * @dev Getter for the amount of shares held by an account.
587      */
588     function shares(address account) public view returns (uint256) {
589         return _shares[account];
590     }
591 
592     /**
593      * @dev Getter for the amount of Ether already released to a payee.
594      */
595     function released(address account) public view returns (uint256) {
596         return _released[account];
597     }
598 
599     /**
600      * @dev Getter for the amount of `token` tokens already released to a payee. `token` should be the address of an
601      * IERC20 contract.
602      */
603     function released(IERC20 token, address account) public view returns (uint256) {
604         return _erc20Released[token][account];
605     }
606 
607     /**
608      * @dev Getter for the address of the payee number `index`.
609      */
610     function payee(uint256 index) public view returns (address) {
611         return _payees[index];
612     }
613 
614     /**
615      * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
616      * total shares and their previous withdrawals.
617      */
618     function release(address payable account) public virtual {
619         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
620 
621         uint256 totalReceived = address(this).balance + totalReleased();
622         uint256 payment = _pendingPayment(account, totalReceived, released(account));
623 
624         require(payment != 0, "PaymentSplitter: account is not due payment");
625 
626         _released[account] += payment;
627         _totalReleased += payment;
628 
629         Address.sendValue(account, payment);
630         emit PaymentReleased(account, payment);
631     }
632 
633     /**
634      * @dev Triggers a transfer to `account` of the amount of `token` tokens they are owed, according to their
635      * percentage of the total shares and their previous withdrawals. `token` must be the address of an IERC20
636      * contract.
637      */
638     function release(IERC20 token, address account) public virtual {
639         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
640 
641         uint256 totalReceived = token.balanceOf(address(this)) + totalReleased(token);
642         uint256 payment = _pendingPayment(account, totalReceived, released(token, account));
643 
644         require(payment != 0, "PaymentSplitter: account is not due payment");
645 
646         _erc20Released[token][account] += payment;
647         _erc20TotalReleased[token] += payment;
648 
649         SafeERC20.safeTransfer(token, account, payment);
650         emit ERC20PaymentReleased(token, account, payment);
651     }
652 
653     /**
654      * @dev internal logic for computing the pending payment of an `account` given the token historical balances and
655      * already released amounts.
656      */
657     function _pendingPayment(
658         address account,
659         uint256 totalReceived,
660         uint256 alreadyReleased
661     ) private view returns (uint256) {
662         return (totalReceived * _shares[account]) / _totalShares - alreadyReleased;
663     }
664 
665     /**
666      * @dev Add a new payee to the contract.
667      * @param account The address of the payee to add.
668      * @param shares_ The number of shares owned by the payee.
669      */
670     function _addPayee(address account, uint256 shares_) private {
671         require(account != address(0), "PaymentSplitter: account is the zero address");
672         require(shares_ > 0, "PaymentSplitter: shares are 0");
673         require(_shares[account] == 0, "PaymentSplitter: account already has shares");
674 
675         _payees.push(account);
676         _shares[account] = shares_;
677         _totalShares = _totalShares + shares_;
678         emit PayeeAdded(account, shares_);
679     }
680 }
681 
682 // File: ERC1155.sol
683 
684 
685 pragma solidity >=0.8.0;
686 
687 /// @notice Minimalist and gas efficient standard ERC1155 implementation.
688 /// @author Solmate (https://github.com/Rari-Capital/solmate/blob/main/src/tokens/ERC1155.sol)
689 abstract contract ERC1155 {
690     /*///////////////////////////////////////////////////////////////
691                                 EVENTS
692     //////////////////////////////////////////////////////////////*/
693 
694     event TransferSingle(
695         address indexed operator,
696         address indexed from,
697         address indexed to,
698         uint256 id,
699         uint256 amount
700     );
701 
702     event TransferBatch(
703         address indexed operator,
704         address indexed from,
705         address indexed to,
706         uint256[] ids,
707         uint256[] amounts
708     );
709 
710     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
711 
712     event URI(string value, uint256 indexed id);
713 
714     /*///////////////////////////////////////////////////////////////
715                             ERC1155 STORAGE
716     //////////////////////////////////////////////////////////////*/
717 
718     mapping(address => mapping(uint256 => uint256)) public balanceOf;
719 
720     mapping(address => mapping(address => bool)) public isApprovedForAll;
721 
722     /*///////////////////////////////////////////////////////////////
723                              METADATA LOGIC
724     //////////////////////////////////////////////////////////////*/
725 
726     function uri(uint256 id) public view virtual returns (string memory);
727 
728     /*///////////////////////////////////////////////////////////////
729                              ERC1155 LOGIC
730     //////////////////////////////////////////////////////////////*/
731 
732     function setApprovalForAll(address operator, bool approved) public virtual {
733         isApprovedForAll[msg.sender][operator] = approved;
734 
735         emit ApprovalForAll(msg.sender, operator, approved);
736     }
737 
738     function safeTransferFrom(
739         address from,
740         address to,
741         uint256 id,
742         uint256 amount,
743         bytes memory data
744     ) public virtual {
745         require(msg.sender == from || isApprovedForAll[from][msg.sender], "NOT_AUTHORIZED");
746 
747         balanceOf[from][id] -= amount;
748         balanceOf[to][id] += amount;
749 
750         emit TransferSingle(msg.sender, from, to, id, amount);
751 
752         require(
753             to.code.length == 0
754                 ? to != address(0)
755                 : ERC1155TokenReceiver(to).onERC1155Received(msg.sender, from, id, amount, data) ==
756                     ERC1155TokenReceiver.onERC1155Received.selector,
757             "UNSAFE_RECIPIENT"
758         );
759     }
760 
761     function safeBatchTransferFrom(
762         address from,
763         address to,
764         uint256[] memory ids,
765         uint256[] memory amounts,
766         bytes memory data
767     ) public virtual {
768         uint256 idsLength = ids.length; // Saves MLOADs.
769 
770         require(idsLength == amounts.length, "LENGTH_MISMATCH");
771 
772         require(msg.sender == from || isApprovedForAll[from][msg.sender], "NOT_AUTHORIZED");
773 
774         // Storing these outside the loop saves ~15 gas per iteration.
775         uint256 id;
776         uint256 amount;
777 
778         for (uint256 i = 0; i < idsLength; ) {
779             id = ids[i];
780             amount = amounts[i];
781 
782             balanceOf[from][id] -= amount;
783             balanceOf[to][id] += amount;
784 
785             // An array can't have a total length
786             // larger than the max uint256 value.
787             unchecked {
788                 ++i;
789             }
790         }
791 
792         emit TransferBatch(msg.sender, from, to, ids, amounts);
793 
794         require(
795             to.code.length == 0
796                 ? to != address(0)
797                 : ERC1155TokenReceiver(to).onERC1155BatchReceived(msg.sender, from, ids, amounts, data) ==
798                     ERC1155TokenReceiver.onERC1155BatchReceived.selector,
799             "UNSAFE_RECIPIENT"
800         );
801     }
802 
803     function balanceOfBatch(address[] memory owners, uint256[] memory ids)
804         public
805         view
806         virtual
807         returns (uint256[] memory balances)
808     {
809         uint256 ownersLength = owners.length; // Saves MLOADs.
810 
811         require(ownersLength == ids.length, "LENGTH_MISMATCH");
812 
813         balances = new uint256[](ownersLength);
814 
815         // Unchecked because the only math done is incrementing
816         // the array index counter which cannot possibly overflow.
817         unchecked {
818             for (uint256 i = 0; i < ownersLength; ++i) {
819                 balances[i] = balanceOf[owners[i]][ids[i]];
820             }
821         }
822     }
823 
824     /*///////////////////////////////////////////////////////////////
825                               ERC165 LOGIC
826     //////////////////////////////////////////////////////////////*/
827 
828     function supportsInterface(bytes4 interfaceId) public view virtual returns (bool) {
829         return
830             interfaceId == 0x01ffc9a7 || // ERC165 Interface ID for ERC165
831             interfaceId == 0xd9b67a26 || // ERC165 Interface ID for ERC1155
832             interfaceId == 0x0e89341c; // ERC165 Interface ID for ERC1155MetadataURI
833     }
834 
835     /*///////////////////////////////////////////////////////////////
836                         INTERNAL MINT/BURN LOGIC
837     //////////////////////////////////////////////////////////////*/
838 
839     function _mint(
840         address to,
841         uint256 id,
842         uint256 amount,
843         bytes memory data
844     ) internal {
845         balanceOf[to][id] += amount;
846 
847         emit TransferSingle(msg.sender, address(0), to, id, amount);
848 
849         require(
850             to.code.length == 0
851                 ? to != address(0)
852                 : ERC1155TokenReceiver(to).onERC1155Received(msg.sender, address(0), id, amount, data) ==
853                     ERC1155TokenReceiver.onERC1155Received.selector,
854             "UNSAFE_RECIPIENT"
855         );
856     }
857 
858     function _batchMint(
859         address to,
860         uint256[] memory ids,
861         uint256[] memory amounts,
862         bytes memory data
863     ) internal {
864         uint256 idsLength = ids.length; // Saves MLOADs.
865 
866         require(idsLength == amounts.length, "LENGTH_MISMATCH");
867 
868         for (uint256 i = 0; i < idsLength; ) {
869             balanceOf[to][ids[i]] += amounts[i];
870 
871             // An array can't have a total length
872             // larger than the max uint256 value.
873             unchecked {
874                 ++i;
875             }
876         }
877 
878         emit TransferBatch(msg.sender, address(0), to, ids, amounts);
879 
880         require(
881             to.code.length == 0
882                 ? to != address(0)
883                 : ERC1155TokenReceiver(to).onERC1155BatchReceived(msg.sender, address(0), ids, amounts, data) ==
884                     ERC1155TokenReceiver.onERC1155BatchReceived.selector,
885             "UNSAFE_RECIPIENT"
886         );
887     }
888 
889     function _batchBurn(
890         address from,
891         uint256[] memory ids,
892         uint256[] memory amounts
893     ) internal {
894         uint256 idsLength = ids.length; // Saves MLOADs.
895 
896         require(idsLength == amounts.length, "LENGTH_MISMATCH");
897 
898         for (uint256 i = 0; i < idsLength; ) {
899             balanceOf[from][ids[i]] -= amounts[i];
900 
901             // An array can't have a total length
902             // larger than the max uint256 value.
903             unchecked {
904                 ++i;
905             }
906         }
907 
908         emit TransferBatch(msg.sender, from, address(0), ids, amounts);
909     }
910 
911     function _burn(
912         address from,
913         uint256 id,
914         uint256 amount
915     ) internal {
916         balanceOf[from][id] -= amount;
917 
918         emit TransferSingle(msg.sender, from, address(0), id, amount);
919     }
920 }
921 
922 /// @notice A generic interface for a contract which properly accepts ERC1155 tokens.
923 /// @author Solmate (https://github.com/Rari-Capital/solmate/blob/main/src/tokens/ERC1155.sol)
924 interface ERC1155TokenReceiver {
925     function onERC1155Received(
926         address operator,
927         address from,
928         uint256 id,
929         uint256 amount,
930         bytes calldata data
931     ) external returns (bytes4);
932 
933     function onERC1155BatchReceived(
934         address operator,
935         address from,
936         uint256[] calldata ids,
937         uint256[] calldata amounts,
938         bytes calldata data
939     ) external returns (bytes4);
940 }
941 
942 // File: SpacegatePass.sol
943 pragma solidity ^0.8.9;
944 
945 /*
946 * @title ERC1155 Contract for SpacegatePass
947 *
948 * @author tony-stark.eth | What The Commit https://what-the-commit.com
949 */
950 contract SpacegatePass is ERC1155, PaymentSplitter {
951     string public name_;
952     string public symbol_;
953 
954     bool public publicSaleIsOpen;
955     bool public allowlistIsOpen;
956 
957     uint8 private constant tokenId = 0;
958 
959     uint256 public constant mintPrice = 0.2 ether;
960 
961     uint256 public constant maxSupply = 2000;
962     uint256 public currentSupply = 0;
963 
964     string public baseURI = "ipfs://QmY6GYY7ZcbZpBEkM5uXb2C9Kp7vYgYRJDznkHZMpwUrXC";
965 
966     bytes32 private merkleRoot;
967     address public owner;
968 
969     /// @notice Mapping of addresses who have claimed tokens
970     mapping(address => uint256) public hasClaimed;
971 
972     /// @notice Thrown if address has already claimed
973     error AlreadyClaimed();
974     /// @notice Thrown if address/amount are not part of Merkle tree
975     error NotInMerkle();
976     /// @notice Thrown if bad price
977     error PaymentNotCorrect();
978     error NotOwner();
979     error MintExceedsMaxSupply();
980     error TooManyMintsPerTransaction();
981     error PublicSaleNotStarted();
982     error AllowlistSaleNotStarted();
983 
984     constructor(
985         address[] memory payees,
986         uint256[] memory shares_
987     ) ERC1155() PaymentSplitter(payees, shares_) {
988         owner = msg.sender;
989         name_ = "Spacegate Pass";
990         symbol_ = "SGP";
991     }
992 
993     function name() public view returns (string memory) {
994         return name_;
995     }
996 
997     function symbol() public view returns (string memory) {
998         return symbol_;
999     }
1000 
1001     function uri(uint256 id) override public view virtual returns (string memory) {
1002         return baseURI;
1003     }
1004 
1005     function claim(
1006         address to,
1007         uint256 proofAmount,
1008         uint256 mintAmount,
1009         bytes32[] calldata proof
1010     ) external payable {
1011         if (!allowlistIsOpen) revert AllowlistSaleNotStarted();
1012         if (currentSupply + mintAmount > maxSupply) revert MintExceedsMaxSupply();
1013         // Throw if address has already claimed tokens
1014         if (hasClaimed[to] + mintAmount > proofAmount) revert AlreadyClaimed();
1015         if (msg.value != mintPrice * mintAmount) revert PaymentNotCorrect();
1016 
1017         // Verify merkle proof, or revert if not in tree
1018         bytes32 leaf = keccak256(abi.encodePacked(to, proofAmount));
1019         bool isValidLeaf = MerkleProof.verify(proof, merkleRoot, leaf);
1020         if (!isValidLeaf) revert NotInMerkle();
1021 
1022         // Set address to claimed
1023         hasClaimed[to] += mintAmount;
1024 
1025         // Mint tokens to address
1026         _mint(to, tokenId, mintAmount, "");
1027         currentSupply += mintAmount;
1028     }
1029 
1030     function publicMint() external payable {
1031         if (!publicSaleIsOpen) revert PublicSaleNotStarted();
1032         if (currentSupply + 1 > maxSupply) revert MintExceedsMaxSupply();
1033         if (msg.value != mintPrice) revert PaymentNotCorrect();
1034 
1035         _mint(msg.sender, tokenId, 1, "");
1036         currentSupply += 1;
1037     }
1038 
1039     /// ============ Owner Functions ============
1040 
1041     modifier onlyOwner() {
1042         if (msg.sender != owner) revert NotOwner();
1043 
1044         _;
1045     }
1046 
1047     function setOwner(address newOwner) external onlyOwner {
1048         owner = newOwner;
1049     }
1050 
1051     function setMerkleRoot(bytes32 _merkleRoot) external onlyOwner {
1052         merkleRoot = _merkleRoot;
1053     }
1054 
1055     function setBaseURI(string memory _baseURI) external onlyOwner {
1056         baseURI = _baseURI;
1057     }
1058 
1059     function setBools(bool allowlist, bool publicSale) external onlyOwner {
1060         allowlistIsOpen = allowlist;
1061         publicSaleIsOpen = publicSale;
1062     }
1063 
1064     function ownerMint(address to, uint256 amount) external onlyOwner {
1065         if (currentSupply + amount > maxSupply) revert MintExceedsMaxSupply();
1066         _mint(to, tokenId, amount, "");
1067         currentSupply += amount;
1068     }
1069 }