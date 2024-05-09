1 // Sources flattened with hardhat v2.9.6 https://hardhat.org
2 
3 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.6.0
4 
5 
6 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Interface of the ERC20 standard as defined in the EIP.
12  */
13 interface IERC20 {
14     /**
15      * @dev Emitted when `value` tokens are moved from one account (`from`) to
16      * another (`to`).
17      *
18      * Note that `value` may be zero.
19      */
20     event Transfer(address indexed from, address indexed to, uint256 value);
21 
22     /**
23      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
24      * a call to {approve}. `value` is the new allowance.
25      */
26     event Approval(address indexed owner, address indexed spender, uint256 value);
27 
28     /**
29      * @dev Returns the amount of tokens in existence.
30      */
31     function totalSupply() external view returns (uint256);
32 
33     /**
34      * @dev Returns the amount of tokens owned by `account`.
35      */
36     function balanceOf(address account) external view returns (uint256);
37 
38     /**
39      * @dev Moves `amount` tokens from the caller's account to `to`.
40      *
41      * Returns a boolean value indicating whether the operation succeeded.
42      *
43      * Emits a {Transfer} event.
44      */
45     function transfer(address to, uint256 amount) external returns (bool);
46 
47     /**
48      * @dev Returns the remaining number of tokens that `spender` will be
49      * allowed to spend on behalf of `owner` through {transferFrom}. This is
50      * zero by default.
51      *
52      * This value changes when {approve} or {transferFrom} are called.
53      */
54     function allowance(address owner, address spender) external view returns (uint256);
55 
56     /**
57      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
58      *
59      * Returns a boolean value indicating whether the operation succeeded.
60      *
61      * IMPORTANT: Beware that changing an allowance with this method brings the risk
62      * that someone may use both the old and the new allowance by unfortunate
63      * transaction ordering. One possible solution to mitigate this race
64      * condition is to first reduce the spender's allowance to 0 and set the
65      * desired value afterwards:
66      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
67      *
68      * Emits an {Approval} event.
69      */
70     function approve(address spender, uint256 amount) external returns (bool);
71 
72     /**
73      * @dev Moves `amount` tokens from `from` to `to` using the
74      * allowance mechanism. `amount` is then deducted from the caller's
75      * allowance.
76      *
77      * Returns a boolean value indicating whether the operation succeeded.
78      *
79      * Emits a {Transfer} event.
80      */
81     function transferFrom(
82         address from,
83         address to,
84         uint256 amount
85     ) external returns (bool);
86 }
87 
88 
89 // File @openzeppelin/contracts/utils/Address.sol@v4.6.0
90 
91 
92 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
93 
94 pragma solidity ^0.8.1;
95 
96 /**
97  * @dev Collection of functions related to the address type
98  */
99 library Address {
100     /**
101      * @dev Returns true if `account` is a contract.
102      *
103      * [IMPORTANT]
104      * ====
105      * It is unsafe to assume that an address for which this function returns
106      * false is an externally-owned account (EOA) and not a contract.
107      *
108      * Among others, `isContract` will return false for the following
109      * types of addresses:
110      *
111      *  - an externally-owned account
112      *  - a contract in construction
113      *  - an address where a contract will be created
114      *  - an address where a contract lived, but was destroyed
115      * ====
116      *
117      * [IMPORTANT]
118      * ====
119      * You shouldn't rely on `isContract` to protect against flash loan attacks!
120      *
121      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
122      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
123      * constructor.
124      * ====
125      */
126     function isContract(address account) internal view returns (bool) {
127         // This method relies on extcodesize/address.code.length, which returns 0
128         // for contracts in construction, since the code is only stored at the end
129         // of the constructor execution.
130 
131         return account.code.length > 0;
132     }
133 
134     /**
135      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
136      * `recipient`, forwarding all available gas and reverting on errors.
137      *
138      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
139      * of certain opcodes, possibly making contracts go over the 2300 gas limit
140      * imposed by `transfer`, making them unable to receive funds via
141      * `transfer`. {sendValue} removes this limitation.
142      *
143      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
144      *
145      * IMPORTANT: because control is transferred to `recipient`, care must be
146      * taken to not create reentrancy vulnerabilities. Consider using
147      * {ReentrancyGuard} or the
148      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
149      */
150     function sendValue(address payable recipient, uint256 amount) internal {
151         require(address(this).balance >= amount, "Address: insufficient balance");
152 
153         (bool success, ) = recipient.call{value: amount}("");
154         require(success, "Address: unable to send value, recipient may have reverted");
155     }
156 
157     /**
158      * @dev Performs a Solidity function call using a low level `call`. A
159      * plain `call` is an unsafe replacement for a function call: use this
160      * function instead.
161      *
162      * If `target` reverts with a revert reason, it is bubbled up by this
163      * function (like regular Solidity function calls).
164      *
165      * Returns the raw returned data. To convert to the expected return value,
166      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
167      *
168      * Requirements:
169      *
170      * - `target` must be a contract.
171      * - calling `target` with `data` must not revert.
172      *
173      * _Available since v3.1._
174      */
175     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
176         return functionCall(target, data, "Address: low-level call failed");
177     }
178 
179     /**
180      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
181      * `errorMessage` as a fallback revert reason when `target` reverts.
182      *
183      * _Available since v3.1._
184      */
185     function functionCall(
186         address target,
187         bytes memory data,
188         string memory errorMessage
189     ) internal returns (bytes memory) {
190         return functionCallWithValue(target, data, 0, errorMessage);
191     }
192 
193     /**
194      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
195      * but also transferring `value` wei to `target`.
196      *
197      * Requirements:
198      *
199      * - the calling contract must have an ETH balance of at least `value`.
200      * - the called Solidity function must be `payable`.
201      *
202      * _Available since v3.1._
203      */
204     function functionCallWithValue(
205         address target,
206         bytes memory data,
207         uint256 value
208     ) internal returns (bytes memory) {
209         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
210     }
211 
212     /**
213      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
214      * with `errorMessage` as a fallback revert reason when `target` reverts.
215      *
216      * _Available since v3.1._
217      */
218     function functionCallWithValue(
219         address target,
220         bytes memory data,
221         uint256 value,
222         string memory errorMessage
223     ) internal returns (bytes memory) {
224         require(address(this).balance >= value, "Address: insufficient balance for call");
225         require(isContract(target), "Address: call to non-contract");
226 
227         (bool success, bytes memory returndata) = target.call{value: value}(data);
228         return verifyCallResult(success, returndata, errorMessage);
229     }
230 
231     /**
232      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
233      * but performing a static call.
234      *
235      * _Available since v3.3._
236      */
237     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
238         return functionStaticCall(target, data, "Address: low-level static call failed");
239     }
240 
241     /**
242      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
243      * but performing a static call.
244      *
245      * _Available since v3.3._
246      */
247     function functionStaticCall(
248         address target,
249         bytes memory data,
250         string memory errorMessage
251     ) internal view returns (bytes memory) {
252         require(isContract(target), "Address: static call to non-contract");
253 
254         (bool success, bytes memory returndata) = target.staticcall(data);
255         return verifyCallResult(success, returndata, errorMessage);
256     }
257 
258     /**
259      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
260      * but performing a delegate call.
261      *
262      * _Available since v3.4._
263      */
264     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
265         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
266     }
267 
268     /**
269      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
270      * but performing a delegate call.
271      *
272      * _Available since v3.4._
273      */
274     function functionDelegateCall(
275         address target,
276         bytes memory data,
277         string memory errorMessage
278     ) internal returns (bytes memory) {
279         require(isContract(target), "Address: delegate call to non-contract");
280 
281         (bool success, bytes memory returndata) = target.delegatecall(data);
282         return verifyCallResult(success, returndata, errorMessage);
283     }
284 
285     /**
286      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
287      * revert reason using the provided one.
288      *
289      * _Available since v4.3._
290      */
291     function verifyCallResult(
292         bool success,
293         bytes memory returndata,
294         string memory errorMessage
295     ) internal pure returns (bytes memory) {
296         if (success) {
297             return returndata;
298         } else {
299             // Look for revert reason and bubble it up if present
300             if (returndata.length > 0) {
301                 // The easiest way to bubble the revert reason is using memory via assembly
302 
303                 assembly {
304                     let returndata_size := mload(returndata)
305                     revert(add(32, returndata), returndata_size)
306                 }
307             } else {
308                 revert(errorMessage);
309             }
310         }
311     }
312 }
313 
314 
315 // File @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol@v4.6.0
316 
317 
318 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
319 
320 pragma solidity ^0.8.0;
321 
322 
323 /**
324  * @title SafeERC20
325  * @dev Wrappers around ERC20 operations that throw on failure (when the token
326  * contract returns false). Tokens that return no value (and instead revert or
327  * throw on failure) are also supported, non-reverting calls are assumed to be
328  * successful.
329  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
330  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
331  */
332 library SafeERC20 {
333     using Address for address;
334 
335     function safeTransfer(
336         IERC20 token,
337         address to,
338         uint256 value
339     ) internal {
340         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
341     }
342 
343     function safeTransferFrom(
344         IERC20 token,
345         address from,
346         address to,
347         uint256 value
348     ) internal {
349         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
350     }
351 
352     /**
353      * @dev Deprecated. This function has issues similar to the ones found in
354      * {IERC20-approve}, and its usage is discouraged.
355      *
356      * Whenever possible, use {safeIncreaseAllowance} and
357      * {safeDecreaseAllowance} instead.
358      */
359     function safeApprove(
360         IERC20 token,
361         address spender,
362         uint256 value
363     ) internal {
364         // safeApprove should only be called when setting an initial allowance,
365         // or when resetting it to zero. To increase and decrease it, use
366         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
367         require(
368             (value == 0) || (token.allowance(address(this), spender) == 0),
369             "SafeERC20: approve from non-zero to non-zero allowance"
370         );
371         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
372     }
373 
374     function safeIncreaseAllowance(
375         IERC20 token,
376         address spender,
377         uint256 value
378     ) internal {
379         uint256 newAllowance = token.allowance(address(this), spender) + value;
380         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
381     }
382 
383     function safeDecreaseAllowance(
384         IERC20 token,
385         address spender,
386         uint256 value
387     ) internal {
388         unchecked {
389             uint256 oldAllowance = token.allowance(address(this), spender);
390             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
391             uint256 newAllowance = oldAllowance - value;
392             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
393         }
394     }
395 
396     /**
397      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
398      * on the return value: the return value is optional (but if data is returned, it must not be false).
399      * @param token The token targeted by the call.
400      * @param data The call data (encoded using abi.encode or one of its variants).
401      */
402     function _callOptionalReturn(IERC20 token, bytes memory data) private {
403         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
404         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
405         // the target address contains contract code and also asserts for success in the low-level call.
406 
407         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
408         if (returndata.length > 0) {
409             // Return data is optional
410             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
411         }
412     }
413 }
414 
415 
416 // File @openzeppelin/contracts/utils/Context.sol@v4.6.0
417 
418 
419 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
420 
421 pragma solidity ^0.8.0;
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
443 
444 // File @openzeppelin/contracts/finance/PaymentSplitter.sol@v4.6.0
445 
446 
447 // OpenZeppelin Contracts v4.4.1 (finance/PaymentSplitter.sol)
448 
449 pragma solidity ^0.8.0;
450 
451 
452 
453 /**
454  * @title PaymentSplitter
455  * @dev This contract allows to split Ether payments among a group of accounts. The sender does not need to be aware
456  * that the Ether will be split in this way, since it is handled transparently by the contract.
457  *
458  * The split can be in equal parts or in any other arbitrary proportion. The way this is specified is by assigning each
459  * account to a number of shares. Of all the Ether that this contract receives, each account will then be able to claim
460  * an amount proportional to the percentage of total shares they were assigned.
461  *
462  * `PaymentSplitter` follows a _pull payment_ model. This means that payments are not automatically forwarded to the
463  * accounts but kept in this contract, and the actual transfer is triggered as a separate step by calling the {release}
464  * function.
465  *
466  * NOTE: This contract assumes that ERC20 tokens will behave similarly to native tokens (Ether). Rebasing tokens, and
467  * tokens that apply fees during transfers, are likely to not be supported as expected. If in doubt, we encourage you
468  * to run tests before sending real value to this contract.
469  */
470 contract PaymentSplitter is Context {
471     event PayeeAdded(address account, uint256 shares);
472     event PaymentReleased(address to, uint256 amount);
473     event ERC20PaymentReleased(IERC20 indexed token, address to, uint256 amount);
474     event PaymentReceived(address from, uint256 amount);
475 
476     uint256 private _totalShares;
477     uint256 private _totalReleased;
478 
479     mapping(address => uint256) private _shares;
480     mapping(address => uint256) private _released;
481     address[] private _payees;
482 
483     mapping(IERC20 => uint256) private _erc20TotalReleased;
484     mapping(IERC20 => mapping(address => uint256)) private _erc20Released;
485 
486     /**
487      * @dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at
488      * the matching position in the `shares` array.
489      *
490      * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no
491      * duplicates in `payees`.
492      */
493     constructor(address[] memory payees, uint256[] memory shares_) payable {
494         require(payees.length == shares_.length, "PaymentSplitter: payees and shares length mismatch");
495         require(payees.length > 0, "PaymentSplitter: no payees");
496 
497         for (uint256 i = 0; i < payees.length; i++) {
498             _addPayee(payees[i], shares_[i]);
499         }
500     }
501 
502     /**
503      * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully
504      * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
505      * reliability of the events, and not the actual splitting of Ether.
506      *
507      * To learn more about this see the Solidity documentation for
508      * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
509      * functions].
510      */
511     receive() external payable virtual {
512         emit PaymentReceived(_msgSender(), msg.value);
513     }
514 
515     /**
516      * @dev Getter for the total shares held by payees.
517      */
518     function totalShares() public view returns (uint256) {
519         return _totalShares;
520     }
521 
522     /**
523      * @dev Getter for the total amount of Ether already released.
524      */
525     function totalReleased() public view returns (uint256) {
526         return _totalReleased;
527     }
528 
529     /**
530      * @dev Getter for the total amount of `token` already released. `token` should be the address of an IERC20
531      * contract.
532      */
533     function totalReleased(IERC20 token) public view returns (uint256) {
534         return _erc20TotalReleased[token];
535     }
536 
537     /**
538      * @dev Getter for the amount of shares held by an account.
539      */
540     function shares(address account) public view returns (uint256) {
541         return _shares[account];
542     }
543 
544     /**
545      * @dev Getter for the amount of Ether already released to a payee.
546      */
547     function released(address account) public view returns (uint256) {
548         return _released[account];
549     }
550 
551     /**
552      * @dev Getter for the amount of `token` tokens already released to a payee. `token` should be the address of an
553      * IERC20 contract.
554      */
555     function released(IERC20 token, address account) public view returns (uint256) {
556         return _erc20Released[token][account];
557     }
558 
559     /**
560      * @dev Getter for the address of the payee number `index`.
561      */
562     function payee(uint256 index) public view returns (address) {
563         return _payees[index];
564     }
565 
566     /**
567      * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
568      * total shares and their previous withdrawals.
569      */
570     function release(address payable account) public virtual {
571         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
572 
573         uint256 totalReceived = address(this).balance + totalReleased();
574         uint256 payment = _pendingPayment(account, totalReceived, released(account));
575 
576         require(payment != 0, "PaymentSplitter: account is not due payment");
577 
578         _released[account] += payment;
579         _totalReleased += payment;
580 
581         Address.sendValue(account, payment);
582         emit PaymentReleased(account, payment);
583     }
584 
585     /**
586      * @dev Triggers a transfer to `account` of the amount of `token` tokens they are owed, according to their
587      * percentage of the total shares and their previous withdrawals. `token` must be the address of an IERC20
588      * contract.
589      */
590     function release(IERC20 token, address account) public virtual {
591         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
592 
593         uint256 totalReceived = token.balanceOf(address(this)) + totalReleased(token);
594         uint256 payment = _pendingPayment(account, totalReceived, released(token, account));
595 
596         require(payment != 0, "PaymentSplitter: account is not due payment");
597 
598         _erc20Released[token][account] += payment;
599         _erc20TotalReleased[token] += payment;
600 
601         SafeERC20.safeTransfer(token, account, payment);
602         emit ERC20PaymentReleased(token, account, payment);
603     }
604 
605     /**
606      * @dev internal logic for computing the pending payment of an `account` given the token historical balances and
607      * already released amounts.
608      */
609     function _pendingPayment(
610         address account,
611         uint256 totalReceived,
612         uint256 alreadyReleased
613     ) private view returns (uint256) {
614         return (totalReceived * _shares[account]) / _totalShares - alreadyReleased;
615     }
616 
617     /**
618      * @dev Add a new payee to the contract.
619      * @param account The address of the payee to add.
620      * @param shares_ The number of shares owned by the payee.
621      */
622     function _addPayee(address account, uint256 shares_) private {
623         require(account != address(0), "PaymentSplitter: account is the zero address");
624         require(shares_ > 0, "PaymentSplitter: shares are 0");
625         require(_shares[account] == 0, "PaymentSplitter: account already has shares");
626 
627         _payees.push(account);
628         _shares[account] = shares_;
629         _totalShares = _totalShares + shares_;
630         emit PayeeAdded(account, shares_);
631     }
632 }
633 
634 
635 // File @openzeppelin/contracts/security/Pausable.sol@v4.6.0
636 
637 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
638 
639 pragma solidity ^0.8.0;
640 
641 /**
642  * @dev Contract module which allows children to implement an emergency stop
643  * mechanism that can be triggered by an authorized account.
644  *
645  * This module is used through inheritance. It will make available the
646  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
647  * the functions of your contract. Note that they will not be pausable by
648  * simply including this module, only once the modifiers are put in place.
649  */
650 abstract contract Pausable is Context {
651     /**
652      * @dev Emitted when the pause is triggered by `account`.
653      */
654     event Paused(address account);
655 
656     /**
657      * @dev Emitted when the pause is lifted by `account`.
658      */
659     event Unpaused(address account);
660 
661     bool private _paused;
662 
663     /**
664      * @dev Initializes the contract in unpaused state.
665      */
666     constructor() {
667         _paused = false;
668     }
669 
670     /**
671      * @dev Returns true if the contract is paused, and false otherwise.
672      */
673     function paused() public view virtual returns (bool) {
674         return _paused;
675     }
676 
677     /**
678      * @dev Modifier to make a function callable only when the contract is not paused.
679      *
680      * Requirements:
681      *
682      * - The contract must not be paused.
683      */
684     modifier whenNotPaused() {
685         require(!paused(), "Pausable: paused");
686         _;
687     }
688 
689     /**
690      * @dev Modifier to make a function callable only when the contract is paused.
691      *
692      * Requirements:
693      *
694      * - The contract must be paused.
695      */
696     modifier whenPaused() {
697         require(paused(), "Pausable: not paused");
698         _;
699     }
700 
701     /**
702      * @dev Triggers stopped state.
703      *
704      * Requirements:
705      *
706      * - The contract must not be paused.
707      */
708     function _pause() internal virtual whenNotPaused {
709         _paused = true;
710         emit Paused(_msgSender());
711     }
712 
713     /**
714      * @dev Returns to normal state.
715      *
716      * Requirements:
717      *
718      * - The contract must be paused.
719      */
720     function _unpause() internal virtual whenPaused {
721         _paused = false;
722         emit Unpaused(_msgSender());
723     }
724 }
725 
726 
727 // File @openzeppelin/contracts/access/Ownable.sol@v4.6.0
728 
729 
730 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
731 
732 pragma solidity ^0.8.0;
733 
734 /**
735  * @dev Contract module which provides a basic access control mechanism, where
736  * there is an account (an owner) that can be granted exclusive access to
737  * specific functions.
738  *
739  * By default, the owner account will be the one that deploys the contract. This
740  * can later be changed with {transferOwnership}.
741  *
742  * This module is used through inheritance. It will make available the modifier
743  * `onlyOwner`, which can be applied to your functions to restrict their use to
744  * the owner.
745  */
746 abstract contract Ownable is Context {
747     address private _owner;
748 
749     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
750 
751     /**
752      * @dev Initializes the contract setting the deployer as the initial owner.
753      */
754     constructor() {
755         _transferOwnership(_msgSender());
756     }
757 
758     /**
759      * @dev Returns the address of the current owner.
760      */
761     function owner() public view virtual returns (address) {
762         return _owner;
763     }
764 
765     /**
766      * @dev Throws if called by any account other than the owner.
767      */
768     modifier onlyOwner() {
769         require(owner() == _msgSender(), "Ownable: caller is not the owner");
770         _;
771     }
772 
773     /**
774      * @dev Leaves the contract without owner. It will not be possible to call
775      * `onlyOwner` functions anymore. Can only be called by the current owner.
776      *
777      * NOTE: Renouncing ownership will leave the contract without an owner,
778      * thereby removing any functionality that is only available to the owner.
779      */
780     function renounceOwnership() public virtual onlyOwner {
781         _transferOwnership(address(0));
782     }
783 
784     /**
785      * @dev Transfers ownership of the contract to a new account (`newOwner`).
786      * Can only be called by the current owner.
787      */
788     function transferOwnership(address newOwner) public virtual onlyOwner {
789         require(newOwner != address(0), "Ownable: new owner is the zero address");
790         _transferOwnership(newOwner);
791     }
792 
793     /**
794      * @dev Transfers ownership of the contract to a new account (`newOwner`).
795      * Internal function without access restriction.
796      */
797     function _transferOwnership(address newOwner) internal virtual {
798         address oldOwner = _owner;
799         _owner = newOwner;
800         emit OwnershipTransferred(oldOwner, newOwner);
801     }
802 }
803 
804 
805 // File contracts/ICandyRobbers.sol
806 
807 //SPDX-License-Identifier: UNLICENSED
808 pragma solidity 0.8.13;
809 
810 interface ICandyRobbers {
811 
812     function mintTo(address _to, uint256 _quantity) external;
813 
814 }
815 
816 
817 // File contracts/CRFreemint.sol
818 
819 pragma solidity 0.8.13;
820 
821 
822 
823 
824 contract CRFreemint is Ownable, PaymentSplitter, Pausable {
825     
826 
827     ICandyRobbers immutable candyRobbers;
828 
829     uint256 public immutable price;
830     uint256 public immutable maxMintablePerTx;
831 
832 
833     bool public saleEnded;
834 
835     uint256 public immutable saleStart;
836 
837     mapping(address => bool) public freemintUsed;
838 
839     address[] private team_ = [0x9e9bc682f651c99BA0d7Eeb93eE64a2AD07CE112, 0x11412a492e7ab9F672c83e9586245cE6a70E4388];
840     uint256[] private teamShares_ = [97,3];
841 
842     constructor(ICandyRobbers _candyRobbers, uint256 _saleStart, uint256 _price, uint256 _maxMintableTx)
843         PaymentSplitter(team_, teamShares_)
844     {
845         candyRobbers = _candyRobbers;
846         saleStart = _saleStart;
847         price = _price;
848         maxMintablePerTx = _maxMintableTx;
849     }
850 
851     //Pause the contract in case of an emergency
852     function pause() external onlyOwner {
853         _pause();
854     }
855 
856     //Unpause the contract
857     function unpause() external onlyOwner {
858         _unpause();
859     }
860 
861     //End the sale forever
862     function endSale() external onlyOwner {
863         saleEnded = true;
864     }
865 
866     /**
867      * @dev Hash a the message needed to mint
868      * @param max The maximum of amount the address is allowed to mint
869      * @param sender The actual sender of the transactio 
870      */
871     function hashMessage(uint256 max, address sender)
872         private
873         pure
874         returns (bytes32)
875     {
876         return keccak256(abi.encode(max, sender));
877     }
878 
879     /**
880      * @dev Performs a freemint. Only one per wallet
881      * @
882      */
883     function freemint(
884     ) external whenNotPaused {
885         require(!saleEnded, "Sale is ended");
886         require(
887             saleStart > 0 && block.timestamp >= saleStart,
888             "Freemint is not started yet!"
889         );
890         require(
891             freemintUsed[msg.sender] == false,
892             "You can't mint more free NFTs!"
893         );
894 
895         freemintUsed[msg.sender] = true;
896 
897         //Max supply is verified in NFT contract
898         candyRobbers.mintTo(msg.sender, 1);
899     }
900 
901     function publicSaleMint(uint256 amount) external payable whenNotPaused {
902         require(!saleEnded, "Sale is ended");
903         require(
904             saleStart > 0 && block.timestamp >= saleStart,
905             "Public sale not started."
906         );
907         require(
908             amount <= maxMintablePerTx,
909             "Mint too large"
910         );
911         require(amount > 0, "You must mint at least one NFT.");
912         require(
913             msg.value >= price * amount,
914             "Insuficient funds"
915         );
916 
917         
918         //Max supply is verified in NFT contract
919         candyRobbers.mintTo(msg.sender, amount);
920     }
921 
922 
923 }