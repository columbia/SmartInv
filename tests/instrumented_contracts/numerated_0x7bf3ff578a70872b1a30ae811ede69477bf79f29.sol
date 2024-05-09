1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.17;
3 
4 /**  
5 
6 
7    ____       _       _           
8   / ___| __ _| |_ ___| |__  _   _ 
9  | |  _ / _` | __/ __| '_ \| | | |
10  | |_| | (_| | |_\__ \ |_) | |_| |
11   \____|\__,_|\__|___/_.__/ \__, |
12                             |___/ 
13 
14 
15 
16 **/
17 
18 /// @author NFTprest (https://twitter.com/NFTprest)
19 
20 
21 
22 // File: @openzeppelin/contracts/utils/Address.sol
23 
24 
25 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
26 
27 pragma solidity ^0.8.1;
28 
29 /**
30  * @dev Collection of functions related to the address type
31  */
32 library Address {
33     /**
34      * @dev Returns true if `account` is a contract.
35      *
36      * [IMPORTANT]
37      * ====
38      * It is unsafe to assume that an address for which this function returns
39      * false is an externally-owned account (EOA) and not a contract.
40      *
41      * Among others, `isContract` will return false for the following
42      * types of addresses:
43      *
44      *  - an externally-owned account
45      *  - a contract in construction
46      *  - an address where a contract will be created
47      *  - an address where a contract lived, but was destroyed
48      * ====
49      *
50      * [IMPORTANT]
51      * ====
52      * You shouldn't rely on `isContract` to protect against flash loan attacks!
53      *
54      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
55      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
56      * constructor.
57      * ====
58      */
59     function isContract(address account) internal view returns (bool) {
60         // This method relies on extcodesize/address.code.length, which returns 0
61         // for contracts in construction, since the code is only stored at the end
62         // of the constructor execution.
63 
64         return account.code.length > 0;
65     }
66 
67     /**
68      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
69      * `recipient`, forwarding all available gas and reverting on errors.
70      *
71      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
72      * of certain opcodes, possibly making contracts go over the 2300 gas limit
73      * imposed by `transfer`, making them unable to receive funds via
74      * `transfer`. {sendValue} removes this limitation.
75      *
76      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
77      *
78      * IMPORTANT: because control is transferred to `recipient`, care must be
79      * taken to not create reentrancy vulnerabilities. Consider using
80      * {ReentrancyGuard} or the
81      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
82      */
83     function sendValue(address payable recipient, uint256 amount) internal {
84         require(address(this).balance >= amount, "Address: insufficient balance");
85 
86         (bool success, ) = recipient.call{value: amount}("");
87         require(success, "Address: unable to send value, recipient may have reverted");
88     }
89 
90     /**
91      * @dev Performs a Solidity function call using a low level `call`. A
92      * plain `call` is an unsafe replacement for a function call: use this
93      * function instead.
94      *
95      * If `target` reverts with a revert reason, it is bubbled up by this
96      * function (like regular Solidity function calls).
97      *
98      * Returns the raw returned data. To convert to the expected return value,
99      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
100      *
101      * Requirements:
102      *
103      * - `target` must be a contract.
104      * - calling `target` with `data` must not revert.
105      *
106      * _Available since v3.1._
107      */
108     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
109         return functionCall(target, data, "Address: low-level call failed");
110     }
111 
112     /**
113      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
114      * `errorMessage` as a fallback revert reason when `target` reverts.
115      *
116      * _Available since v3.1._
117      */
118     function functionCall(
119         address target,
120         bytes memory data,
121         string memory errorMessage
122     ) internal returns (bytes memory) {
123         return functionCallWithValue(target, data, 0, errorMessage);
124     }
125 
126     /**
127      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
128      * but also transferring `value` wei to `target`.
129      *
130      * Requirements:
131      *
132      * - the calling contract must have an ETH balance of at least `value`.
133      * - the called Solidity function must be `payable`.
134      *
135      * _Available since v3.1._
136      */
137     function functionCallWithValue(
138         address target,
139         bytes memory data,
140         uint256 value
141     ) internal returns (bytes memory) {
142         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
143     }
144 
145     /**
146      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
147      * with `errorMessage` as a fallback revert reason when `target` reverts.
148      *
149      * _Available since v3.1._
150      */
151     function functionCallWithValue(
152         address target,
153         bytes memory data,
154         uint256 value,
155         string memory errorMessage
156     ) internal returns (bytes memory) {
157         require(address(this).balance >= value, "Address: insufficient balance for call");
158         require(isContract(target), "Address: call to non-contract");
159 
160         (bool success, bytes memory returndata) = target.call{value: value}(data);
161         return verifyCallResult(success, returndata, errorMessage);
162     }
163 
164     /**
165      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
166      * but performing a static call.
167      *
168      * _Available since v3.3._
169      */
170     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
171         return functionStaticCall(target, data, "Address: low-level static call failed");
172     }
173 
174     /**
175      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
176      * but performing a static call.
177      *
178      * _Available since v3.3._
179      */
180     function functionStaticCall(
181         address target,
182         bytes memory data,
183         string memory errorMessage
184     ) internal view returns (bytes memory) {
185         require(isContract(target), "Address: static call to non-contract");
186 
187         (bool success, bytes memory returndata) = target.staticcall(data);
188         return verifyCallResult(success, returndata, errorMessage);
189     }
190 
191     /**
192      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
193      * but performing a delegate call.
194      *
195      * _Available since v3.4._
196      */
197     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
198         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
199     }
200 
201     /**
202      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
203      * but performing a delegate call.
204      *
205      * _Available since v3.4._
206      */
207     function functionDelegateCall(
208         address target,
209         bytes memory data,
210         string memory errorMessage
211     ) internal returns (bytes memory) {
212         require(isContract(target), "Address: delegate call to non-contract");
213 
214         (bool success, bytes memory returndata) = target.delegatecall(data);
215         return verifyCallResult(success, returndata, errorMessage);
216     }
217 
218     /**
219      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
220      * revert reason using the provided one.
221      *
222      * _Available since v4.3._
223      */
224     function verifyCallResult(
225         bool success,
226         bytes memory returndata,
227         string memory errorMessage
228     ) internal pure returns (bytes memory) {
229         if (success) {
230             return returndata;
231         } else {
232             // Look for revert reason and bubble it up if present
233             if (returndata.length > 0) {
234                 // The easiest way to bubble the revert reason is using memory via assembly
235                 /// @solidity memory-safe-assembly
236                 assembly {
237                     let returndata_size := mload(returndata)
238                     revert(add(32, returndata), returndata_size)
239                 }
240             } else {
241                 revert(errorMessage);
242             }
243         }
244     }
245 }
246 
247 // File: @openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol
248 
249 
250 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-IERC20Permit.sol)
251 
252 pragma solidity ^0.8.0;
253 
254 /**
255  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
256  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
257  *
258  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
259  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
260  * need to send a transaction, and thus is not required to hold Ether at all.
261  */
262 interface IERC20Permit {
263     /**
264      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
265      * given ``owner``'s signed approval.
266      *
267      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
268      * ordering also apply here.
269      *
270      * Emits an {Approval} event.
271      *
272      * Requirements:
273      *
274      * - `spender` cannot be the zero address.
275      * - `deadline` must be a timestamp in the future.
276      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
277      * over the EIP712-formatted function arguments.
278      * - the signature must use ``owner``'s current nonce (see {nonces}).
279      *
280      * For more information on the signature format, see the
281      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
282      * section].
283      */
284     function permit(
285         address owner,
286         address spender,
287         uint256 value,
288         uint256 deadline,
289         uint8 v,
290         bytes32 r,
291         bytes32 s
292     ) external;
293 
294     /**
295      * @dev Returns the current nonce for `owner`. This value must be
296      * included whenever a signature is generated for {permit}.
297      *
298      * Every successful call to {permit} increases ``owner``'s nonce by one. This
299      * prevents a signature from being used multiple times.
300      */
301     function nonces(address owner) external view returns (uint256);
302 
303     /**
304      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
305      */
306     // solhint-disable-next-line func-name-mixedcase
307     function DOMAIN_SEPARATOR() external view returns (bytes32);
308 }
309 
310 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
311 
312 
313 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
314 
315 pragma solidity ^0.8.0;
316 
317 /**
318  * @dev Interface of the ERC20 standard as defined in the EIP.
319  */
320 interface IERC20 {
321     /**
322      * @dev Emitted when `value` tokens are moved from one account (`from`) to
323      * another (`to`).
324      *
325      * Note that `value` may be zero.
326      */
327     event Transfer(address indexed from, address indexed to, uint256 value);
328 
329     /**
330      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
331      * a call to {approve}. `value` is the new allowance.
332      */
333     event Approval(address indexed owner, address indexed spender, uint256 value);
334 
335     /**
336      * @dev Returns the amount of tokens in existence.
337      */
338     function totalSupply() external view returns (uint256);
339 
340     /**
341      * @dev Returns the amount of tokens owned by `account`.
342      */
343     function balanceOf(address account) external view returns (uint256);
344 
345     /**
346      * @dev Moves `amount` tokens from the caller's account to `to`.
347      *
348      * Returns a boolean value indicating whether the operation succeeded.
349      *
350      * Emits a {Transfer} event.
351      */
352     function transfer(address to, uint256 amount) external returns (bool);
353 
354     /**
355      * @dev Returns the remaining number of tokens that `spender` will be
356      * allowed to spend on behalf of `owner` through {transferFrom}. This is
357      * zero by default.
358      *
359      * This value changes when {approve} or {transferFrom} are called.
360      */
361     function allowance(address owner, address spender) external view returns (uint256);
362 
363     /**
364      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
365      *
366      * Returns a boolean value indicating whether the operation succeeded.
367      *
368      * IMPORTANT: Beware that changing an allowance with this method brings the risk
369      * that someone may use both the old and the new allowance by unfortunate
370      * transaction ordering. One possible solution to mitigate this race
371      * condition is to first reduce the spender's allowance to 0 and set the
372      * desired value afterwards:
373      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
374      *
375      * Emits an {Approval} event.
376      */
377     function approve(address spender, uint256 amount) external returns (bool);
378 
379     /**
380      * @dev Moves `amount` tokens from `from` to `to` using the
381      * allowance mechanism. `amount` is then deducted from the caller's
382      * allowance.
383      *
384      * Returns a boolean value indicating whether the operation succeeded.
385      *
386      * Emits a {Transfer} event.
387      */
388     function transferFrom(
389         address from,
390         address to,
391         uint256 amount
392     ) external returns (bool);
393 }
394 
395 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
396 
397 
398 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/utils/SafeERC20.sol)
399 
400 pragma solidity ^0.8.0;
401 
402 
403 
404 
405 /**
406  * @title SafeERC20
407  * @dev Wrappers around ERC20 operations that throw on failure (when the token
408  * contract returns false). Tokens that return no value (and instead revert or
409  * throw on failure) are also supported, non-reverting calls are assumed to be
410  * successful.
411  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
412  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
413  */
414 library SafeERC20 {
415     using Address for address;
416 
417     function safeTransfer(
418         IERC20 token,
419         address to,
420         uint256 value
421     ) internal {
422         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
423     }
424 
425     function safeTransferFrom(
426         IERC20 token,
427         address from,
428         address to,
429         uint256 value
430     ) internal {
431         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
432     }
433 
434     /**
435      * @dev Deprecated. This function has issues similar to the ones found in
436      * {IERC20-approve}, and its usage is discouraged.
437      *
438      * Whenever possible, use {safeIncreaseAllowance} and
439      * {safeDecreaseAllowance} instead.
440      */
441     function safeApprove(
442         IERC20 token,
443         address spender,
444         uint256 value
445     ) internal {
446         // safeApprove should only be called when setting an initial allowance,
447         // or when resetting it to zero. To increase and decrease it, use
448         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
449         require(
450             (value == 0) || (token.allowance(address(this), spender) == 0),
451             "SafeERC20: approve from non-zero to non-zero allowance"
452         );
453         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
454     }
455 
456     function safeIncreaseAllowance(
457         IERC20 token,
458         address spender,
459         uint256 value
460     ) internal {
461         uint256 newAllowance = token.allowance(address(this), spender) + value;
462         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
463     }
464 
465     function safeDecreaseAllowance(
466         IERC20 token,
467         address spender,
468         uint256 value
469     ) internal {
470         unchecked {
471             uint256 oldAllowance = token.allowance(address(this), spender);
472             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
473             uint256 newAllowance = oldAllowance - value;
474             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
475         }
476     }
477 
478     function safePermit(
479         IERC20Permit token,
480         address owner,
481         address spender,
482         uint256 value,
483         uint256 deadline,
484         uint8 v,
485         bytes32 r,
486         bytes32 s
487     ) internal {
488         uint256 nonceBefore = token.nonces(owner);
489         token.permit(owner, spender, value, deadline, v, r, s);
490         uint256 nonceAfter = token.nonces(owner);
491         require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
492     }
493 
494     /**
495      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
496      * on the return value: the return value is optional (but if data is returned, it must not be false).
497      * @param token The token targeted by the call.
498      * @param data The call data (encoded using abi.encode or one of its variants).
499      */
500     function _callOptionalReturn(IERC20 token, bytes memory data) private {
501         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
502         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
503         // the target address contains contract code and also asserts for success in the low-level call.
504 
505         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
506         if (returndata.length > 0) {
507             // Return data is optional
508             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
509         }
510     }
511 }
512 
513 // File: @openzeppelin/contracts/utils/Context.sol
514 
515 
516 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
517 
518 pragma solidity ^0.8.0;
519 
520 /**
521  * @dev Provides information about the current execution context, including the
522  * sender of the transaction and its data. While these are generally available
523  * via msg.sender and msg.data, they should not be accessed in such a direct
524  * manner, since when dealing with meta-transactions the account sending and
525  * paying for execution may not be the actual sender (as far as an application
526  * is concerned).
527  *
528  * This contract is only required for intermediate, library-like contracts.
529  */
530 abstract contract Context {
531     function _msgSender() internal view virtual returns (address) {
532         return msg.sender;
533     }
534 
535     function _msgData() internal view virtual returns (bytes calldata) {
536         return msg.data;
537     }
538 }
539 
540 // File: @openzeppelin/contracts/finance/PaymentSplitter.sol
541 
542 
543 // OpenZeppelin Contracts (last updated v4.7.0) (finance/PaymentSplitter.sol)
544 
545 pragma solidity ^0.8.0;
546 
547 
548 
549 
550 /**
551  * @title PaymentSplitter
552  * @dev This contract allows to split Ether payments among a group of accounts. The sender does not need to be aware
553  * that the Ether will be split in this way, since it is handled transparently by the contract.
554  *
555  * The split can be in equal parts or in any other arbitrary proportion. The way this is specified is by assigning each
556  * account to a number of shares. Of all the Ether that this contract receives, each account will then be able to claim
557  * an amount proportional to the percentage of total shares they were assigned. The distribution of shares is set at the
558  * time of contract deployment and can't be updated thereafter.
559  *
560  * `PaymentSplitter` follows a _pull payment_ model. This means that payments are not automatically forwarded to the
561  * accounts but kept in this contract, and the actual transfer is triggered as a separate step by calling the {release}
562  * function.
563  *
564  * NOTE: This contract assumes that ERC20 tokens will behave similarly to native tokens (Ether). Rebasing tokens, and
565  * tokens that apply fees during transfers, are likely to not be supported as expected. If in doubt, we encourage you
566  * to run tests before sending real value to this contract.
567  */
568 contract PaymentSplitter is Context {
569     event PayeeAdded(address account, uint256 shares);
570     event PaymentReleased(address to, uint256 amount);
571     event ERC20PaymentReleased(IERC20 indexed token, address to, uint256 amount);
572     event PaymentReceived(address from, uint256 amount);
573 
574     uint256 private _totalShares;
575     uint256 private _totalReleased;
576 
577     mapping(address => uint256) private _shares;
578     mapping(address => uint256) private _released;
579     address[] private _payees;
580 
581     mapping(IERC20 => uint256) private _erc20TotalReleased;
582     mapping(IERC20 => mapping(address => uint256)) private _erc20Released;
583 
584     /**
585      * @dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at
586      * the matching position in the `shares` array.
587      *
588      * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no
589      * duplicates in `payees`.
590      */
591     constructor(address[] memory payees, uint256[] memory shares_) payable {
592         require(payees.length == shares_.length, "PaymentSplitter: payees and shares length mismatch");
593         require(payees.length > 0, "PaymentSplitter: no payees");
594 
595         for (uint256 i = 0; i < payees.length; i++) {
596             _addPayee(payees[i], shares_[i]);
597         }
598     }
599 
600     /**
601      * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully
602      * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
603      * reliability of the events, and not the actual splitting of Ether.
604      *
605      * To learn more about this see the Solidity documentation for
606      * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
607      * functions].
608      */
609     receive() external payable virtual {
610         emit PaymentReceived(_msgSender(), msg.value);
611     }
612 
613     /**
614      * @dev Getter for the total shares held by payees.
615      */
616     function totalShares() public view returns (uint256) {
617         return _totalShares;
618     }
619 
620     /**
621      * @dev Getter for the total amount of Ether already released.
622      */
623     function totalReleased() public view returns (uint256) {
624         return _totalReleased;
625     }
626 
627     /**
628      * @dev Getter for the total amount of `token` already released. `token` should be the address of an IERC20
629      * contract.
630      */
631     function totalReleased(IERC20 token) public view returns (uint256) {
632         return _erc20TotalReleased[token];
633     }
634 
635     /**
636      * @dev Getter for the amount of shares held by an account.
637      */
638     function shares(address account) public view returns (uint256) {
639         return _shares[account];
640     }
641 
642     /**
643      * @dev Getter for the amount of Ether already released to a payee.
644      */
645     function released(address account) public view returns (uint256) {
646         return _released[account];
647     }
648 
649     /**
650      * @dev Getter for the amount of `token` tokens already released to a payee. `token` should be the address of an
651      * IERC20 contract.
652      */
653     function released(IERC20 token, address account) public view returns (uint256) {
654         return _erc20Released[token][account];
655     }
656 
657     /**
658      * @dev Getter for the address of the payee number `index`.
659      */
660     function payee(uint256 index) public view returns (address) {
661         return _payees[index];
662     }
663 
664     /**
665      * @dev Getter for the amount of payee's releasable Ether.
666      */
667     function releasable(address account) public view returns (uint256) {
668         uint256 totalReceived = address(this).balance + totalReleased();
669         return _pendingPayment(account, totalReceived, released(account));
670     }
671 
672     /**
673      * @dev Getter for the amount of payee's releasable `token` tokens. `token` should be the address of an
674      * IERC20 contract.
675      */
676     function releasable(IERC20 token, address account) public view returns (uint256) {
677         uint256 totalReceived = token.balanceOf(address(this)) + totalReleased(token);
678         return _pendingPayment(account, totalReceived, released(token, account));
679     }
680 
681     /**
682      * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
683      * total shares and their previous withdrawals.
684      */
685     function release(address payable account) public virtual {
686         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
687 
688         uint256 payment = releasable(account);
689 
690         require(payment != 0, "PaymentSplitter: account is not due payment");
691 
692         _released[account] += payment;
693         _totalReleased += payment;
694 
695         Address.sendValue(account, payment);
696         emit PaymentReleased(account, payment);
697     }
698 
699     /**
700      * @dev Triggers a transfer to `account` of the amount of `token` tokens they are owed, according to their
701      * percentage of the total shares and their previous withdrawals. `token` must be the address of an IERC20
702      * contract.
703      */
704     function release(IERC20 token, address account) public virtual {
705         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
706 
707         uint256 payment = releasable(token, account);
708 
709         require(payment != 0, "PaymentSplitter: account is not due payment");
710 
711         _erc20Released[token][account] += payment;
712         _erc20TotalReleased[token] += payment;
713 
714         SafeERC20.safeTransfer(token, account, payment);
715         emit ERC20PaymentReleased(token, account, payment);
716     }
717 
718     /**
719      * @dev internal logic for computing the pending payment of an `account` given the token historical balances and
720      * already released amounts.
721      */
722     function _pendingPayment(
723         address account,
724         uint256 totalReceived,
725         uint256 alreadyReleased
726     ) private view returns (uint256) {
727         return (totalReceived * _shares[account]) / _totalShares - alreadyReleased;
728     }
729 
730     /**
731      * @dev Add a new payee to the contract.
732      * @param account The address of the payee to add.
733      * @param shares_ The number of shares owned by the payee.
734      */
735     function _addPayee(address account, uint256 shares_) private {
736         require(account != address(0), "PaymentSplitter: account is the zero address");
737         require(shares_ > 0, "PaymentSplitter: shares are 0");
738         require(_shares[account] == 0, "PaymentSplitter: account already has shares");
739 
740         _payees.push(account);
741         _shares[account] = shares_;
742         _totalShares = _totalShares + shares_;
743         emit PayeeAdded(account, shares_);
744     }
745 }
746 
747 // File: @openzeppelin/contracts/access/Ownable.sol
748 
749 
750 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
751 
752 pragma solidity ^0.8.0;
753 
754 
755 /**
756  * @dev Contract module which provides a basic access control mechanism, where
757  * there is an account (an owner) that can be granted exclusive access to
758  * specific functions.
759  *
760  * By default, the owner account will be the one that deploys the contract. This
761  * can later be changed with {transferOwnership}.
762  *
763  * This module is used through inheritance. It will make available the modifier
764  * `onlyOwner`, which can be applied to your functions to restrict their use to
765  * the owner.
766  */
767 abstract contract Ownable is Context {
768     address private _owner;
769 
770     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
771 
772     /**
773      * @dev Initializes the contract setting the deployer as the initial owner.
774      */
775     constructor() {
776         _transferOwnership(_msgSender());
777     }
778 
779     /**
780      * @dev Throws if called by any account other than the owner.
781      */
782     modifier onlyOwner() {
783         _checkOwner();
784         _;
785     }
786 
787     /**
788      * @dev Returns the address of the current owner.
789      */
790     function owner() public view virtual returns (address) {
791         return _owner;
792     }
793 
794     /**
795      * @dev Throws if the sender is not the owner.
796      */
797     function _checkOwner() internal view virtual {
798         require(owner() == _msgSender(), "Ownable: caller is not the owner");
799     }
800 
801     /**
802      * @dev Leaves the contract without owner. It will not be possible to call
803      * `onlyOwner` functions anymore. Can only be called by the current owner.
804      *
805      * NOTE: Renouncing ownership will leave the contract without an owner,
806      * thereby removing any functionality that is only available to the owner.
807      */
808     function renounceOwnership() public virtual onlyOwner {
809         _transferOwnership(address(0));
810     }
811 
812     /**
813      * @dev Transfers ownership of the contract to a new account (`newOwner`).
814      * Can only be called by the current owner.
815      */
816     function transferOwnership(address newOwner) public virtual onlyOwner {
817         require(newOwner != address(0), "Ownable: new owner is the zero address");
818         _transferOwnership(newOwner);
819     }
820 
821     /**
822      * @dev Transfers ownership of the contract to a new account (`newOwner`).
823      * Internal function without access restriction.
824      */
825     function _transferOwnership(address newOwner) internal virtual {
826         address oldOwner = _owner;
827         _owner = newOwner;
828         emit OwnershipTransferred(oldOwner, newOwner);
829     }
830 }
831 
832 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
833 
834 
835 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
836 
837 pragma solidity ^0.8.0;
838 
839 /**
840  * @dev These functions deal with verification of Merkle Tree proofs.
841  *
842  * The proofs can be generated using the JavaScript library
843  * https://github.com/miguelmota/merkletreejs[merkletreejs].
844  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
845  *
846  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
847  *
848  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
849  * hashing, or use a hash function other than keccak256 for hashing leaves.
850  * This is because the concatenation of a sorted pair of internal nodes in
851  * the merkle tree could be reinterpreted as a leaf value.
852  */
853 library MerkleProof {
854     /**
855      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
856      * defined by `root`. For this, a `proof` must be provided, containing
857      * sibling hashes on the branch from the leaf to the root of the tree. Each
858      * pair of leaves and each pair of pre-images are assumed to be sorted.
859      */
860     function verify(
861         bytes32[] memory proof,
862         bytes32 root,
863         bytes32 leaf
864     ) internal pure returns (bool) {
865         return processProof(proof, leaf) == root;
866     }
867 
868     /**
869      * @dev Calldata version of {verify}
870      *
871      * _Available since v4.7._
872      */
873     function verifyCalldata(
874         bytes32[] calldata proof,
875         bytes32 root,
876         bytes32 leaf
877     ) internal pure returns (bool) {
878         return processProofCalldata(proof, leaf) == root;
879     }
880 
881     /**
882      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
883      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
884      * hash matches the root of the tree. When processing the proof, the pairs
885      * of leafs & pre-images are assumed to be sorted.
886      *
887      * _Available since v4.4._
888      */
889     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
890         bytes32 computedHash = leaf;
891         for (uint256 i = 0; i < proof.length; i++) {
892             computedHash = _hashPair(computedHash, proof[i]);
893         }
894         return computedHash;
895     }
896 
897     /**
898      * @dev Calldata version of {processProof}
899      *
900      * _Available since v4.7._
901      */
902     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
903         bytes32 computedHash = leaf;
904         for (uint256 i = 0; i < proof.length; i++) {
905             computedHash = _hashPair(computedHash, proof[i]);
906         }
907         return computedHash;
908     }
909 
910     /**
911      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
912      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
913      *
914      * _Available since v4.7._
915      */
916     function multiProofVerify(
917         bytes32[] memory proof,
918         bool[] memory proofFlags,
919         bytes32 root,
920         bytes32[] memory leaves
921     ) internal pure returns (bool) {
922         return processMultiProof(proof, proofFlags, leaves) == root;
923     }
924 
925     /**
926      * @dev Calldata version of {multiProofVerify}
927      *
928      * _Available since v4.7._
929      */
930     function multiProofVerifyCalldata(
931         bytes32[] calldata proof,
932         bool[] calldata proofFlags,
933         bytes32 root,
934         bytes32[] memory leaves
935     ) internal pure returns (bool) {
936         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
937     }
938 
939     /**
940      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
941      * consuming from one or the other at each step according to the instructions given by
942      * `proofFlags`.
943      *
944      * _Available since v4.7._
945      */
946     function processMultiProof(
947         bytes32[] memory proof,
948         bool[] memory proofFlags,
949         bytes32[] memory leaves
950     ) internal pure returns (bytes32 merkleRoot) {
951         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
952         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
953         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
954         // the merkle tree.
955         uint256 leavesLen = leaves.length;
956         uint256 totalHashes = proofFlags.length;
957 
958         // Check proof validity.
959         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
960 
961         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
962         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
963         bytes32[] memory hashes = new bytes32[](totalHashes);
964         uint256 leafPos = 0;
965         uint256 hashPos = 0;
966         uint256 proofPos = 0;
967         // At each step, we compute the next hash using two values:
968         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
969         //   get the next hash.
970         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
971         //   `proof` array.
972         for (uint256 i = 0; i < totalHashes; i++) {
973             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
974             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
975             hashes[i] = _hashPair(a, b);
976         }
977 
978         if (totalHashes > 0) {
979             return hashes[totalHashes - 1];
980         } else if (leavesLen > 0) {
981             return leaves[0];
982         } else {
983             return proof[0];
984         }
985     }
986 
987     /**
988      * @dev Calldata version of {processMultiProof}
989      *
990      * _Available since v4.7._
991      */
992     function processMultiProofCalldata(
993         bytes32[] calldata proof,
994         bool[] calldata proofFlags,
995         bytes32[] memory leaves
996     ) internal pure returns (bytes32 merkleRoot) {
997         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
998         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
999         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1000         // the merkle tree.
1001         uint256 leavesLen = leaves.length;
1002         uint256 totalHashes = proofFlags.length;
1003 
1004         // Check proof validity.
1005         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1006 
1007         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1008         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1009         bytes32[] memory hashes = new bytes32[](totalHashes);
1010         uint256 leafPos = 0;
1011         uint256 hashPos = 0;
1012         uint256 proofPos = 0;
1013         // At each step, we compute the next hash using two values:
1014         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1015         //   get the next hash.
1016         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1017         //   `proof` array.
1018         for (uint256 i = 0; i < totalHashes; i++) {
1019             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1020             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
1021             hashes[i] = _hashPair(a, b);
1022         }
1023 
1024         if (totalHashes > 0) {
1025             return hashes[totalHashes - 1];
1026         } else if (leavesLen > 0) {
1027             return leaves[0];
1028         } else {
1029             return proof[0];
1030         }
1031     }
1032 
1033     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
1034         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
1035     }
1036 
1037     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1038         /// @solidity memory-safe-assembly
1039         assembly {
1040             mstore(0x00, a)
1041             mstore(0x20, b)
1042             value := keccak256(0x00, 0x40)
1043         }
1044     }
1045 }
1046 
1047 // File: IERC721A.sol
1048 
1049 
1050 // ERC721A Contracts v4.2.3
1051 // Creator: Chiru Labs
1052 
1053 pragma solidity ^0.8.4;
1054 
1055 /**
1056  * @dev Interface of ERC721A.
1057  */
1058 interface IERC721A {
1059     /**
1060      * The caller must own the token or be an approved operator.
1061      */
1062     error ApprovalCallerNotOwnerNorApproved();
1063 
1064     /**
1065      * The token does not exist.
1066      */
1067     error ApprovalQueryForNonexistentToken();
1068 
1069     /**
1070      * Cannot query the balance for the zero address.
1071      */
1072     error BalanceQueryForZeroAddress();
1073 
1074     /**
1075      * Cannot mint to the zero address.
1076      */
1077     error MintToZeroAddress();
1078 
1079     /**
1080      * The quantity of tokens minted must be more than zero.
1081      */
1082     error MintZeroQuantity();
1083 
1084     /**
1085      * The token does not exist.
1086      */
1087     error OwnerQueryForNonexistentToken();
1088 
1089     /**
1090      * The caller must own the token or be an approved operator.
1091      */
1092     error TransferCallerNotOwnerNorApproved();
1093 
1094     /**
1095      * The token must be owned by `from`.
1096      */
1097     error TransferFromIncorrectOwner();
1098 
1099     /**
1100      * Cannot safely transfer to a contract that does not implement the
1101      * ERC721Receiver interface.
1102      */
1103     error TransferToNonERC721ReceiverImplementer();
1104 
1105     /**
1106      * Cannot transfer to the zero address.
1107      */
1108     error TransferToZeroAddress();
1109 
1110     /**
1111      * The token does not exist.
1112      */
1113     error URIQueryForNonexistentToken();
1114 
1115     /**
1116      * The `quantity` minted with ERC2309 exceeds the safety limit.
1117      */
1118     error MintERC2309QuantityExceedsLimit();
1119 
1120     /**
1121      * The `extraData` cannot be set on an unintialized ownership slot.
1122      */
1123     error OwnershipNotInitializedForExtraData();
1124 
1125     // =============================================================
1126     //                            STRUCTS
1127     // =============================================================
1128 
1129     struct TokenOwnership {
1130         // The address of the owner.
1131         address addr;
1132         // Stores the start time of ownership with minimal overhead for tokenomics.
1133         uint64 startTimestamp;
1134         // Whether the token has been burned.
1135         bool burned;
1136         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
1137         uint24 extraData;
1138     }
1139 
1140     // =============================================================
1141     //                         TOKEN COUNTERS
1142     // =============================================================
1143 
1144     /**
1145      * @dev Returns the total number of tokens in existence.
1146      * Burned tokens will reduce the count.
1147      * To get the total number of tokens minted, please see {_totalMinted}.
1148      */
1149     function totalSupply() external view returns (uint256);
1150 
1151     // =============================================================
1152     //                            IERC165
1153     // =============================================================
1154 
1155     /**
1156      * @dev Returns true if this contract implements the interface defined by
1157      * `interfaceId`. See the corresponding
1158      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1159      * to learn more about how these ids are created.
1160      *
1161      * This function call must use less than 30000 gas.
1162      */
1163     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1164 
1165     // =============================================================
1166     //                            IERC721
1167     // =============================================================
1168 
1169     /**
1170      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1171      */
1172     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1173 
1174     /**
1175      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1176      */
1177     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1178 
1179     /**
1180      * @dev Emitted when `owner` enables or disables
1181      * (`approved`) `operator` to manage all of its assets.
1182      */
1183     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1184 
1185     /**
1186      * @dev Returns the number of tokens in `owner`'s account.
1187      */
1188     function balanceOf(address owner) external view returns (uint256 balance);
1189 
1190     /**
1191      * @dev Returns the owner of the `tokenId` token.
1192      *
1193      * Requirements:
1194      *
1195      * - `tokenId` must exist.
1196      */
1197     function ownerOf(uint256 tokenId) external view returns (address owner);
1198 
1199     /**
1200      * @dev Safely transfers `tokenId` token from `from` to `to`,
1201      * checking first that contract recipients are aware of the ERC721 protocol
1202      * to prevent tokens from being forever locked.
1203      *
1204      * Requirements:
1205      *
1206      * - `from` cannot be the zero address.
1207      * - `to` cannot be the zero address.
1208      * - `tokenId` token must exist and be owned by `from`.
1209      * - If the caller is not `from`, it must be have been allowed to move
1210      * this token by either {approve} or {setApprovalForAll}.
1211      * - If `to` refers to a smart contract, it must implement
1212      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1213      *
1214      * Emits a {Transfer} event.
1215      */
1216     function safeTransferFrom(
1217         address from,
1218         address to,
1219         uint256 tokenId,
1220         bytes calldata data
1221     ) external payable;
1222 
1223     /**
1224      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1225      */
1226     function safeTransferFrom(
1227         address from,
1228         address to,
1229         uint256 tokenId
1230     ) external payable;
1231 
1232     /**
1233      * @dev Transfers `tokenId` from `from` to `to`.
1234      *
1235      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
1236      * whenever possible.
1237      *
1238      * Requirements:
1239      *
1240      * - `from` cannot be the zero address.
1241      * - `to` cannot be the zero address.
1242      * - `tokenId` token must be owned by `from`.
1243      * - If the caller is not `from`, it must be approved to move this token
1244      * by either {approve} or {setApprovalForAll}.
1245      *
1246      * Emits a {Transfer} event.
1247      */
1248     function transferFrom(
1249         address from,
1250         address to,
1251         uint256 tokenId
1252     ) external payable;
1253 
1254     /**
1255      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1256      * The approval is cleared when the token is transferred.
1257      *
1258      * Only a single account can be approved at a time, so approving the
1259      * zero address clears previous approvals.
1260      *
1261      * Requirements:
1262      *
1263      * - The caller must own the token or be an approved operator.
1264      * - `tokenId` must exist.
1265      *
1266      * Emits an {Approval} event.
1267      */
1268     function approve(address to, uint256 tokenId) external payable;
1269 
1270     /**
1271      * @dev Approve or remove `operator` as an operator for the caller.
1272      * Operators can call {transferFrom} or {safeTransferFrom}
1273      * for any token owned by the caller.
1274      *
1275      * Requirements:
1276      *
1277      * - The `operator` cannot be the caller.
1278      *
1279      * Emits an {ApprovalForAll} event.
1280      */
1281     function setApprovalForAll(address operator, bool _approved) external;
1282 
1283     /**
1284      * @dev Returns the account approved for `tokenId` token.
1285      *
1286      * Requirements:
1287      *
1288      * - `tokenId` must exist.
1289      */
1290     function getApproved(uint256 tokenId) external view returns (address operator);
1291 
1292     /**
1293      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1294      *
1295      * See {setApprovalForAll}.
1296      */
1297     function isApprovedForAll(address owner, address operator) external view returns (bool);
1298 
1299     // =============================================================
1300     //                        IERC721Metadata
1301     // =============================================================
1302 
1303     /**
1304      * @dev Returns the token collection name.
1305      */
1306     function name() external view returns (string memory);
1307 
1308     /**
1309      * @dev Returns the token collection symbol.
1310      */
1311     function symbol() external view returns (string memory);
1312 
1313     /**
1314      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1315      */
1316     function tokenURI(uint256 tokenId) external view returns (string memory);
1317 
1318     // =============================================================
1319     //                           IERC2309
1320     // =============================================================
1321 
1322     /**
1323      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
1324      * (inclusive) is transferred from `from` to `to`, as defined in the
1325      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
1326      *
1327      * See {_mintERC2309} for more details.
1328      */
1329     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
1330 }
1331 // File: ERC721A.sol
1332 
1333 
1334 // ERC721A Contracts v4.2.3
1335 // Creator: Chiru Labs
1336 
1337 pragma solidity ^0.8.4;
1338 
1339 
1340 /**
1341  * @dev Interface of ERC721 token receiver.
1342  */
1343 interface ERC721A__IERC721Receiver {
1344     function onERC721Received(
1345         address operator,
1346         address from,
1347         uint256 tokenId,
1348         bytes calldata data
1349     ) external returns (bytes4);
1350 }
1351 
1352 /**
1353  * @title ERC721A
1354  *
1355  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
1356  * Non-Fungible Token Standard, including the Metadata extension.
1357  * Optimized for lower gas during batch mints.
1358  *
1359  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
1360  * starting from `_startTokenId()`.
1361  *
1362  * Assumptions:
1363  *
1364  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1365  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
1366  */
1367 contract ERC721A is IERC721A {
1368     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
1369     struct TokenApprovalRef {
1370         address value;
1371     }
1372 
1373     // =============================================================
1374     //                           CONSTANTS
1375     // =============================================================
1376 
1377     // Mask of an entry in packed address data.
1378     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
1379 
1380     // The bit position of `numberMinted` in packed address data.
1381     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
1382 
1383     // The bit position of `numberBurned` in packed address data.
1384     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
1385 
1386     // The bit position of `aux` in packed address data.
1387     uint256 private constant _BITPOS_AUX = 192;
1388 
1389     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1390     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1391 
1392     // The bit position of `startTimestamp` in packed ownership.
1393     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
1394 
1395     // The bit mask of the `burned` bit in packed ownership.
1396     uint256 private constant _BITMASK_BURNED = 1 << 224;
1397 
1398     // The bit position of the `nextInitialized` bit in packed ownership.
1399     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
1400 
1401     // The bit mask of the `nextInitialized` bit in packed ownership.
1402     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
1403 
1404     // The bit position of `extraData` in packed ownership.
1405     uint256 private constant _BITPOS_EXTRA_DATA = 232;
1406 
1407     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
1408     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
1409 
1410     // The mask of the lower 160 bits for addresses.
1411     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
1412 
1413     // The maximum `quantity` that can be minted with {_mintERC2309}.
1414     // This limit is to prevent overflows on the address data entries.
1415     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
1416     // is required to cause an overflow, which is unrealistic.
1417     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
1418 
1419     // The `Transfer` event signature is given by:
1420     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
1421     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
1422         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
1423 
1424     // =============================================================
1425     //                            STORAGE
1426     // =============================================================
1427 
1428     // The next token ID to be minted.
1429     uint256 private _currentIndex;
1430 
1431     // The number of tokens burned.
1432     uint256 private _burnCounter;
1433 
1434     // Token name
1435     string private _name;
1436 
1437     // Token symbol
1438     string private _symbol;
1439 
1440     // Mapping from token ID to ownership details
1441     // An empty struct value does not necessarily mean the token is unowned.
1442     // See {_packedOwnershipOf} implementation for details.
1443     //
1444     // Bits Layout:
1445     // - [0..159]   `addr`
1446     // - [160..223] `startTimestamp`
1447     // - [224]      `burned`
1448     // - [225]      `nextInitialized`
1449     // - [232..255] `extraData`
1450     mapping(uint256 => uint256) private _packedOwnerships;
1451 
1452     // Mapping owner address to address data.
1453     //
1454     // Bits Layout:
1455     // - [0..63]    `balance`
1456     // - [64..127]  `numberMinted`
1457     // - [128..191] `numberBurned`
1458     // - [192..255] `aux`
1459     mapping(address => uint256) private _packedAddressData;
1460 
1461     // Mapping from token ID to approved address.
1462     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1463 
1464     // Mapping from owner to operator approvals
1465     mapping(address => mapping(address => bool)) private _operatorApprovals;
1466 
1467     // =============================================================
1468     //                          CONSTRUCTOR
1469     // =============================================================
1470 
1471     constructor(string memory name_, string memory symbol_) {
1472         _name = name_;
1473         _symbol = symbol_;
1474         _currentIndex = _startTokenId();
1475     }
1476 
1477     // =============================================================
1478     //                   TOKEN COUNTING OPERATIONS
1479     // =============================================================
1480 
1481     /**
1482      * @dev Returns the starting token ID.
1483      * To change the starting token ID, please override this function.
1484      */
1485     function _startTokenId() internal view virtual returns (uint256) {
1486         return 0;
1487     }
1488 
1489     /**
1490      * @dev Returns the next token ID to be minted.
1491      */
1492     function _nextTokenId() internal view virtual returns (uint256) {
1493         return _currentIndex;
1494     }
1495 
1496     /**
1497      * @dev Returns the total number of tokens in existence.
1498      * Burned tokens will reduce the count.
1499      * To get the total number of tokens minted, please see {_totalMinted}.
1500      */
1501     function totalSupply() public view virtual override returns (uint256) {
1502         // Counter underflow is impossible as _burnCounter cannot be incremented
1503         // more than `_currentIndex - _startTokenId()` times.
1504         unchecked {
1505             return _currentIndex - _burnCounter - _startTokenId();
1506         }
1507     }
1508 
1509     /**
1510      * @dev Returns the total amount of tokens minted in the contract.
1511      */
1512     function _totalMinted() internal view virtual returns (uint256) {
1513         // Counter underflow is impossible as `_currentIndex` does not decrement,
1514         // and it is initialized to `_startTokenId()`.
1515         unchecked {
1516             return _currentIndex - _startTokenId();
1517         }
1518     }
1519 
1520     /**
1521      * @dev Returns the total number of tokens burned.
1522      */
1523     function _totalBurned() internal view virtual returns (uint256) {
1524         return _burnCounter;
1525     }
1526 
1527     // =============================================================
1528     //                    ADDRESS DATA OPERATIONS
1529     // =============================================================
1530 
1531     /**
1532      * @dev Returns the number of tokens in `owner`'s account.
1533      */
1534     function balanceOf(address owner) public view virtual override returns (uint256) {
1535         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1536         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1537     }
1538 
1539     /**
1540      * Returns the number of tokens minted by `owner`.
1541      */
1542     function _numberMinted(address owner) internal view returns (uint256) {
1543         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1544     }
1545 
1546     /**
1547      * Returns the number of tokens burned by or on behalf of `owner`.
1548      */
1549     function _numberBurned(address owner) internal view returns (uint256) {
1550         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1551     }
1552 
1553     /**
1554      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1555      */
1556     function _getAux(address owner) internal view returns (uint64) {
1557         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1558     }
1559 
1560     /**
1561      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1562      * If there are multiple variables, please pack them into a uint64.
1563      */
1564     function _setAux(address owner, uint64 aux) internal virtual {
1565         uint256 packed = _packedAddressData[owner];
1566         uint256 auxCasted;
1567         // Cast `aux` with assembly to avoid redundant masking.
1568         assembly {
1569             auxCasted := aux
1570         }
1571         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1572         _packedAddressData[owner] = packed;
1573     }
1574 
1575     // =============================================================
1576     //                            IERC165
1577     // =============================================================
1578 
1579     /**
1580      * @dev Returns true if this contract implements the interface defined by
1581      * `interfaceId`. See the corresponding
1582      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1583      * to learn more about how these ids are created.
1584      *
1585      * This function call must use less than 30000 gas.
1586      */
1587     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1588         // The interface IDs are constants representing the first 4 bytes
1589         // of the XOR of all function selectors in the interface.
1590         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1591         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1592         return
1593             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1594             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1595             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1596     }
1597 
1598     // =============================================================
1599     //                        IERC721Metadata
1600     // =============================================================
1601 
1602     /**
1603      * @dev Returns the token collection name.
1604      */
1605     function name() public view virtual override returns (string memory) {
1606         return _name;
1607     }
1608 
1609     /**
1610      * @dev Returns the token collection symbol.
1611      */
1612     function symbol() public view virtual override returns (string memory) {
1613         return _symbol;
1614     }
1615 
1616     /**
1617      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1618      */
1619     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1620         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1621 
1622         string memory baseURI = _baseURI();
1623         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1624     }
1625 
1626     /**
1627      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1628      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1629      * by default, it can be overridden in child contracts.
1630      */
1631     function _baseURI() internal view virtual returns (string memory) {
1632         return '';
1633     }
1634 
1635     // =============================================================
1636     //                     OWNERSHIPS OPERATIONS
1637     // =============================================================
1638 
1639     /**
1640      * @dev Returns the owner of the `tokenId` token.
1641      *
1642      * Requirements:
1643      *
1644      * - `tokenId` must exist.
1645      */
1646     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1647         return address(uint160(_packedOwnershipOf(tokenId)));
1648     }
1649 
1650     /**
1651      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1652      * It gradually moves to O(1) as tokens get transferred around over time.
1653      */
1654     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1655         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1656     }
1657 
1658     /**
1659      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1660      */
1661     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1662         return _unpackedOwnership(_packedOwnerships[index]);
1663     }
1664 
1665     /**
1666      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1667      */
1668     function _initializeOwnershipAt(uint256 index) internal virtual {
1669         if (_packedOwnerships[index] == 0) {
1670             _packedOwnerships[index] = _packedOwnershipOf(index);
1671         }
1672     }
1673 
1674     /**
1675      * Returns the packed ownership data of `tokenId`.
1676      */
1677     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1678         uint256 curr = tokenId;
1679 
1680         unchecked {
1681             if (_startTokenId() <= curr)
1682                 if (curr < _currentIndex) {
1683                     uint256 packed = _packedOwnerships[curr];
1684                     // If not burned.
1685                     if (packed & _BITMASK_BURNED == 0) {
1686                         // Invariant:
1687                         // There will always be an initialized ownership slot
1688                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1689                         // before an unintialized ownership slot
1690                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1691                         // Hence, `curr` will not underflow.
1692                         //
1693                         // We can directly compare the packed value.
1694                         // If the address is zero, packed will be zero.
1695                         while (packed == 0) {
1696                             packed = _packedOwnerships[--curr];
1697                         }
1698                         return packed;
1699                     }
1700                 }
1701         }
1702         revert OwnerQueryForNonexistentToken();
1703     }
1704 
1705     /**
1706      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1707      */
1708     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1709         ownership.addr = address(uint160(packed));
1710         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1711         ownership.burned = packed & _BITMASK_BURNED != 0;
1712         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1713     }
1714 
1715     /**
1716      * @dev Packs ownership data into a single uint256.
1717      */
1718     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1719         assembly {
1720             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1721             owner := and(owner, _BITMASK_ADDRESS)
1722             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1723             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1724         }
1725     }
1726 
1727     /**
1728      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1729      */
1730     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1731         // For branchless setting of the `nextInitialized` flag.
1732         assembly {
1733             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1734             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1735         }
1736     }
1737 
1738     // =============================================================
1739     //                      APPROVAL OPERATIONS
1740     // =============================================================
1741 
1742     /**
1743      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1744      * The approval is cleared when the token is transferred.
1745      *
1746      * Only a single account can be approved at a time, so approving the
1747      * zero address clears previous approvals.
1748      *
1749      * Requirements:
1750      *
1751      * - The caller must own the token or be an approved operator.
1752      * - `tokenId` must exist.
1753      *
1754      * Emits an {Approval} event.
1755      */
1756     function approve(address to, uint256 tokenId) public payable virtual override {
1757         address owner = ownerOf(tokenId);
1758 
1759         if (_msgSenderERC721A() != owner)
1760             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1761                 revert ApprovalCallerNotOwnerNorApproved();
1762             }
1763 
1764         _tokenApprovals[tokenId].value = to;
1765         emit Approval(owner, to, tokenId);
1766     }
1767 
1768     /**
1769      * @dev Returns the account approved for `tokenId` token.
1770      *
1771      * Requirements:
1772      *
1773      * - `tokenId` must exist.
1774      */
1775     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1776         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1777 
1778         return _tokenApprovals[tokenId].value;
1779     }
1780 
1781     /**
1782      * @dev Approve or remove `operator` as an operator for the caller.
1783      * Operators can call {transferFrom} or {safeTransferFrom}
1784      * for any token owned by the caller.
1785      *
1786      * Requirements:
1787      *
1788      * - The `operator` cannot be the caller.
1789      *
1790      * Emits an {ApprovalForAll} event.
1791      */
1792     function setApprovalForAll(address operator, bool approved) public virtual override {
1793         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1794         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1795     }
1796 
1797     /**
1798      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1799      *
1800      * See {setApprovalForAll}.
1801      */
1802     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1803         return _operatorApprovals[owner][operator];
1804     }
1805 
1806     /**
1807      * @dev Returns whether `tokenId` exists.
1808      *
1809      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1810      *
1811      * Tokens start existing when they are minted. See {_mint}.
1812      */
1813     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1814         return
1815             _startTokenId() <= tokenId &&
1816             tokenId < _currentIndex && // If within bounds,
1817             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1818     }
1819 
1820     /**
1821      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1822      */
1823     function _isSenderApprovedOrOwner(
1824         address approvedAddress,
1825         address owner,
1826         address msgSender
1827     ) private pure returns (bool result) {
1828         assembly {
1829             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1830             owner := and(owner, _BITMASK_ADDRESS)
1831             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1832             msgSender := and(msgSender, _BITMASK_ADDRESS)
1833             // `msgSender == owner || msgSender == approvedAddress`.
1834             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1835         }
1836     }
1837 
1838     /**
1839      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1840      */
1841     function _getApprovedSlotAndAddress(uint256 tokenId)
1842         private
1843         view
1844         returns (uint256 approvedAddressSlot, address approvedAddress)
1845     {
1846         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1847         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1848         assembly {
1849             approvedAddressSlot := tokenApproval.slot
1850             approvedAddress := sload(approvedAddressSlot)
1851         }
1852     }
1853 
1854     // =============================================================
1855     //                      TRANSFER OPERATIONS
1856     // =============================================================
1857 
1858     /**
1859      * @dev Transfers `tokenId` from `from` to `to`.
1860      *
1861      * Requirements:
1862      *
1863      * - `from` cannot be the zero address.
1864      * - `to` cannot be the zero address.
1865      * - `tokenId` token must be owned by `from`.
1866      * - If the caller is not `from`, it must be approved to move this token
1867      * by either {approve} or {setApprovalForAll}.
1868      *
1869      * Emits a {Transfer} event.
1870      */
1871     function transferFrom(
1872         address from,
1873         address to,
1874         uint256 tokenId
1875     ) public payable virtual override {
1876         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1877 
1878         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1879 
1880         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1881 
1882         // The nested ifs save around 20+ gas over a compound boolean condition.
1883         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1884             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1885 
1886         if (to == address(0)) revert TransferToZeroAddress();
1887 
1888         _beforeTokenTransfers(from, to, tokenId, 1);
1889 
1890         // Clear approvals from the previous owner.
1891         assembly {
1892             if approvedAddress {
1893                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1894                 sstore(approvedAddressSlot, 0)
1895             }
1896         }
1897 
1898         // Underflow of the sender's balance is impossible because we check for
1899         // ownership above and the recipient's balance can't realistically overflow.
1900         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1901         unchecked {
1902             // We can directly increment and decrement the balances.
1903             --_packedAddressData[from]; // Updates: `balance -= 1`.
1904             ++_packedAddressData[to]; // Updates: `balance += 1`.
1905 
1906             // Updates:
1907             // - `address` to the next owner.
1908             // - `startTimestamp` to the timestamp of transfering.
1909             // - `burned` to `false`.
1910             // - `nextInitialized` to `true`.
1911             _packedOwnerships[tokenId] = _packOwnershipData(
1912                 to,
1913                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1914             );
1915 
1916             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1917             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1918                 uint256 nextTokenId = tokenId + 1;
1919                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1920                 if (_packedOwnerships[nextTokenId] == 0) {
1921                     // If the next slot is within bounds.
1922                     if (nextTokenId != _currentIndex) {
1923                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1924                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1925                     }
1926                 }
1927             }
1928         }
1929 
1930         emit Transfer(from, to, tokenId);
1931         _afterTokenTransfers(from, to, tokenId, 1);
1932     }
1933 
1934     /**
1935      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1936      */
1937     function safeTransferFrom(
1938         address from,
1939         address to,
1940         uint256 tokenId
1941     ) public payable virtual override {
1942         safeTransferFrom(from, to, tokenId, '');
1943     }
1944 
1945     /**
1946      * @dev Safely transfers `tokenId` token from `from` to `to`.
1947      *
1948      * Requirements:
1949      *
1950      * - `from` cannot be the zero address.
1951      * - `to` cannot be the zero address.
1952      * - `tokenId` token must exist and be owned by `from`.
1953      * - If the caller is not `from`, it must be approved to move this token
1954      * by either {approve} or {setApprovalForAll}.
1955      * - If `to` refers to a smart contract, it must implement
1956      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1957      *
1958      * Emits a {Transfer} event.
1959      */
1960     function safeTransferFrom(
1961         address from,
1962         address to,
1963         uint256 tokenId,
1964         bytes memory _data
1965     ) public payable virtual override {
1966         transferFrom(from, to, tokenId);
1967         if (to.code.length != 0)
1968             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1969                 revert TransferToNonERC721ReceiverImplementer();
1970             }
1971     }
1972 
1973     /**
1974      * @dev Hook that is called before a set of serially-ordered token IDs
1975      * are about to be transferred. This includes minting.
1976      * And also called before burning one token.
1977      *
1978      * `startTokenId` - the first token ID to be transferred.
1979      * `quantity` - the amount to be transferred.
1980      *
1981      * Calling conditions:
1982      *
1983      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1984      * transferred to `to`.
1985      * - When `from` is zero, `tokenId` will be minted for `to`.
1986      * - When `to` is zero, `tokenId` will be burned by `from`.
1987      * - `from` and `to` are never both zero.
1988      */
1989     function _beforeTokenTransfers(
1990         address from,
1991         address to,
1992         uint256 startTokenId,
1993         uint256 quantity
1994     ) internal virtual {}
1995 
1996     /**
1997      * @dev Hook that is called after a set of serially-ordered token IDs
1998      * have been transferred. This includes minting.
1999      * And also called after one token has been burned.
2000      *
2001      * `startTokenId` - the first token ID to be transferred.
2002      * `quantity` - the amount to be transferred.
2003      *
2004      * Calling conditions:
2005      *
2006      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
2007      * transferred to `to`.
2008      * - When `from` is zero, `tokenId` has been minted for `to`.
2009      * - When `to` is zero, `tokenId` has been burned by `from`.
2010      * - `from` and `to` are never both zero.
2011      */
2012     function _afterTokenTransfers(
2013         address from,
2014         address to,
2015         uint256 startTokenId,
2016         uint256 quantity
2017     ) internal virtual {}
2018 
2019     /**
2020      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
2021      *
2022      * `from` - Previous owner of the given token ID.
2023      * `to` - Target address that will receive the token.
2024      * `tokenId` - Token ID to be transferred.
2025      * `_data` - Optional data to send along with the call.
2026      *
2027      * Returns whether the call correctly returned the expected magic value.
2028      */
2029     function _checkContractOnERC721Received(
2030         address from,
2031         address to,
2032         uint256 tokenId,
2033         bytes memory _data
2034     ) private returns (bool) {
2035         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
2036             bytes4 retval
2037         ) {
2038             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
2039         } catch (bytes memory reason) {
2040             if (reason.length == 0) {
2041                 revert TransferToNonERC721ReceiverImplementer();
2042             } else {
2043                 assembly {
2044                     revert(add(32, reason), mload(reason))
2045                 }
2046             }
2047         }
2048     }
2049 
2050     // =============================================================
2051     //                        MINT OPERATIONS
2052     // =============================================================
2053 
2054     /**
2055      * @dev Mints `quantity` tokens and transfers them to `to`.
2056      *
2057      * Requirements:
2058      *
2059      * - `to` cannot be the zero address.
2060      * - `quantity` must be greater than 0.
2061      *
2062      * Emits a {Transfer} event for each mint.
2063      */
2064     function _mint(address to, uint256 quantity) internal virtual {
2065         uint256 startTokenId = _currentIndex;
2066         if (quantity == 0) revert MintZeroQuantity();
2067 
2068         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2069 
2070         // Overflows are incredibly unrealistic.
2071         // `balance` and `numberMinted` have a maximum limit of 2**64.
2072         // `tokenId` has a maximum limit of 2**256.
2073         unchecked {
2074             // Updates:
2075             // - `balance += quantity`.
2076             // - `numberMinted += quantity`.
2077             //
2078             // We can directly add to the `balance` and `numberMinted`.
2079             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
2080 
2081             // Updates:
2082             // - `address` to the owner.
2083             // - `startTimestamp` to the timestamp of minting.
2084             // - `burned` to `false`.
2085             // - `nextInitialized` to `quantity == 1`.
2086             _packedOwnerships[startTokenId] = _packOwnershipData(
2087                 to,
2088                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2089             );
2090 
2091             uint256 toMasked;
2092             uint256 end = startTokenId + quantity;
2093 
2094             // Use assembly to loop and emit the `Transfer` event for gas savings.
2095             // The duplicated `log4` removes an extra check and reduces stack juggling.
2096             // The assembly, together with the surrounding Solidity code, have been
2097             // delicately arranged to nudge the compiler into producing optimized opcodes.
2098             assembly {
2099                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
2100                 toMasked := and(to, _BITMASK_ADDRESS)
2101                 // Emit the `Transfer` event.
2102                 log4(
2103                     0, // Start of data (0, since no data).
2104                     0, // End of data (0, since no data).
2105                     _TRANSFER_EVENT_SIGNATURE, // Signature.
2106                     0, // `address(0)`.
2107                     toMasked, // `to`.
2108                     startTokenId // `tokenId`.
2109                 )
2110 
2111                 // The `iszero(eq(,))` check ensures that large values of `quantity`
2112                 // that overflows uint256 will make the loop run out of gas.
2113                 // The compiler will optimize the `iszero` away for performance.
2114                 for {
2115                     let tokenId := add(startTokenId, 1)
2116                 } iszero(eq(tokenId, end)) {
2117                     tokenId := add(tokenId, 1)
2118                 } {
2119                     // Emit the `Transfer` event. Similar to above.
2120                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
2121                 }
2122             }
2123             if (toMasked == 0) revert MintToZeroAddress();
2124 
2125             _currentIndex = end;
2126         }
2127         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2128     }
2129 
2130     /**
2131      * @dev Mints `quantity` tokens and transfers them to `to`.
2132      *
2133      * This function is intended for efficient minting only during contract creation.
2134      *
2135      * It emits only one {ConsecutiveTransfer} as defined in
2136      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
2137      * instead of a sequence of {Transfer} event(s).
2138      *
2139      * Calling this function outside of contract creation WILL make your contract
2140      * non-compliant with the ERC721 standard.
2141      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
2142      * {ConsecutiveTransfer} event is only permissible during contract creation.
2143      *
2144      * Requirements:
2145      *
2146      * - `to` cannot be the zero address.
2147      * - `quantity` must be greater than 0.
2148      *
2149      * Emits a {ConsecutiveTransfer} event.
2150      */
2151     function _mintERC2309(address to, uint256 quantity) internal virtual {
2152         uint256 startTokenId = _currentIndex;
2153         if (to == address(0)) revert MintToZeroAddress();
2154         if (quantity == 0) revert MintZeroQuantity();
2155         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
2156 
2157         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2158 
2159         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
2160         unchecked {
2161             // Updates:
2162             // - `balance += quantity`.
2163             // - `numberMinted += quantity`.
2164             //
2165             // We can directly add to the `balance` and `numberMinted`.
2166             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
2167 
2168             // Updates:
2169             // - `address` to the owner.
2170             // - `startTimestamp` to the timestamp of minting.
2171             // - `burned` to `false`.
2172             // - `nextInitialized` to `quantity == 1`.
2173             _packedOwnerships[startTokenId] = _packOwnershipData(
2174                 to,
2175                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2176             );
2177 
2178             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
2179 
2180             _currentIndex = startTokenId + quantity;
2181         }
2182         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2183     }
2184 
2185     /**
2186      * @dev Safely mints `quantity` tokens and transfers them to `to`.
2187      *
2188      * Requirements:
2189      *
2190      * - If `to` refers to a smart contract, it must implement
2191      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
2192      * - `quantity` must be greater than 0.
2193      *
2194      * See {_mint}.
2195      *
2196      * Emits a {Transfer} event for each mint.
2197      */
2198     function _safeMint(
2199         address to,
2200         uint256 quantity,
2201         bytes memory _data
2202     ) internal virtual {
2203         _mint(to, quantity);
2204 
2205         unchecked {
2206             if (to.code.length != 0) {
2207                 uint256 end = _currentIndex;
2208                 uint256 index = end - quantity;
2209                 do {
2210                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
2211                         revert TransferToNonERC721ReceiverImplementer();
2212                     }
2213                 } while (index < end);
2214                 // Reentrancy protection.
2215                 if (_currentIndex != end) revert();
2216             }
2217         }
2218     }
2219 
2220     /**
2221      * @dev Equivalent to `_safeMint(to, quantity, '')`.
2222      */
2223     function _safeMint(address to, uint256 quantity) internal virtual {
2224         _safeMint(to, quantity, '');
2225     }
2226 
2227     // =============================================================
2228     //                        BURN OPERATIONS
2229     // =============================================================
2230 
2231     /**
2232      * @dev Equivalent to `_burn(tokenId, false)`.
2233      */
2234     function _burn(uint256 tokenId) internal virtual {
2235         _burn(tokenId, false);
2236     }
2237 
2238     /**
2239      * @dev Destroys `tokenId`.
2240      * The approval is cleared when the token is burned.
2241      *
2242      * Requirements:
2243      *
2244      * - `tokenId` must exist.
2245      *
2246      * Emits a {Transfer} event.
2247      */
2248     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
2249         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2250 
2251         address from = address(uint160(prevOwnershipPacked));
2252 
2253         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
2254 
2255         if (approvalCheck) {
2256             // The nested ifs save around 20+ gas over a compound boolean condition.
2257             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
2258                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
2259         }
2260 
2261         _beforeTokenTransfers(from, address(0), tokenId, 1);
2262 
2263         // Clear approvals from the previous owner.
2264         assembly {
2265             if approvedAddress {
2266                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2267                 sstore(approvedAddressSlot, 0)
2268             }
2269         }
2270 
2271         // Underflow of the sender's balance is impossible because we check for
2272         // ownership above and the recipient's balance can't realistically overflow.
2273         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2274         unchecked {
2275             // Updates:
2276             // - `balance -= 1`.
2277             // - `numberBurned += 1`.
2278             //
2279             // We can directly decrement the balance, and increment the number burned.
2280             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
2281             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
2282 
2283             // Updates:
2284             // - `address` to the last owner.
2285             // - `startTimestamp` to the timestamp of burning.
2286             // - `burned` to `true`.
2287             // - `nextInitialized` to `true`.
2288             _packedOwnerships[tokenId] = _packOwnershipData(
2289                 from,
2290                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
2291             );
2292 
2293             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2294             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2295                 uint256 nextTokenId = tokenId + 1;
2296                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2297                 if (_packedOwnerships[nextTokenId] == 0) {
2298                     // If the next slot is within bounds.
2299                     if (nextTokenId != _currentIndex) {
2300                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2301                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2302                     }
2303                 }
2304             }
2305         }
2306 
2307         emit Transfer(from, address(0), tokenId);
2308         _afterTokenTransfers(from, address(0), tokenId, 1);
2309 
2310         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2311         unchecked {
2312             _burnCounter++;
2313         }
2314     }
2315 
2316     // =============================================================
2317     //                     EXTRA DATA OPERATIONS
2318     // =============================================================
2319 
2320     /**
2321      * @dev Directly sets the extra data for the ownership data `index`.
2322      */
2323     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
2324         uint256 packed = _packedOwnerships[index];
2325         if (packed == 0) revert OwnershipNotInitializedForExtraData();
2326         uint256 extraDataCasted;
2327         // Cast `extraData` with assembly to avoid redundant masking.
2328         assembly {
2329             extraDataCasted := extraData
2330         }
2331         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
2332         _packedOwnerships[index] = packed;
2333     }
2334 
2335     /**
2336      * @dev Called during each token transfer to set the 24bit `extraData` field.
2337      * Intended to be overridden by the cosumer contract.
2338      *
2339      * `previousExtraData` - the value of `extraData` before transfer.
2340      *
2341      * Calling conditions:
2342      *
2343      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2344      * transferred to `to`.
2345      * - When `from` is zero, `tokenId` will be minted for `to`.
2346      * - When `to` is zero, `tokenId` will be burned by `from`.
2347      * - `from` and `to` are never both zero.
2348      */
2349     function _extraData(
2350         address from,
2351         address to,
2352         uint24 previousExtraData
2353     ) internal view virtual returns (uint24) {}
2354 
2355     /**
2356      * @dev Returns the next extra data for the packed ownership data.
2357      * The returned result is shifted into position.
2358      */
2359     function _nextExtraData(
2360         address from,
2361         address to,
2362         uint256 prevOwnershipPacked
2363     ) private view returns (uint256) {
2364         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
2365         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
2366     }
2367 
2368     // =============================================================
2369     //                       OTHER OPERATIONS
2370     // =============================================================
2371 
2372     /**
2373      * @dev Returns the message sender (defaults to `msg.sender`).
2374      *
2375      * If you are writing GSN compatible contracts, you need to override this function.
2376      */
2377     function _msgSenderERC721A() internal view virtual returns (address) {
2378         return msg.sender;
2379     }
2380 
2381     /**
2382      * @dev Converts a uint256 to its ASCII string decimal representation.
2383      */
2384     function _toString(uint256 value) internal pure virtual returns (string memory str) {
2385         assembly {
2386             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
2387             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
2388             // We will need 1 word for the trailing zeros padding, 1 word for the length,
2389             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
2390             let m := add(mload(0x40), 0xa0)
2391             // Update the free memory pointer to allocate.
2392             mstore(0x40, m)
2393             // Assign the `str` to the end.
2394             str := sub(m, 0x20)
2395             // Zeroize the slot after the string.
2396             mstore(str, 0)
2397 
2398             // Cache the end of the memory to calculate the length later.
2399             let end := str
2400 
2401             // We write the string from rightmost digit to leftmost digit.
2402             // The following is essentially a do-while loop that also handles the zero case.
2403             // prettier-ignore
2404             for { let temp := value } 1 {} {
2405                 str := sub(str, 1)
2406                 // Write the character to the pointer.
2407                 // The ASCII index of the '0' character is 48.
2408                 mstore8(str, add(48, mod(temp, 10)))
2409                 // Keep dividing `temp` until zero.
2410                 temp := div(temp, 10)
2411                 // prettier-ignore
2412                 if iszero(temp) { break }
2413             }
2414 
2415             let length := sub(end, str)
2416             // Move the pointer 32 bytes leftwards to make room for the length.
2417             str := sub(str, 0x20)
2418             // Store the length.
2419             mstore(str, length)
2420         }
2421     }
2422 }
2423 // File: GatsbyToolsPass.sol
2424 
2425 
2426 pragma solidity ^0.8.17;
2427 
2428 /**  
2429 
2430 
2431    ____       _       _           
2432   / ___| __ _| |_ ___| |__  _   _ 
2433  | |  _ / _` | __/ __| '_ \| | | |
2434  | |_| | (_| | |_\__ \ |_) | |_| |
2435   \____|\__,_|\__|___/_.__/ \__, |
2436                             |___/ 
2437 
2438 
2439 
2440 **/
2441 
2442 /// @author NFTprest (https://twitter.com/NFTprest)
2443 
2444 
2445 
2446 
2447 
2448 
2449 // File: contracts/GatsbyToolsPass.sol
2450 
2451 contract GatsbyToolsPass is ERC721A, PaymentSplitter, Ownable { 
2452     uint public maxSupply = 3950;
2453     uint public maxMintsPerWallet = 1;
2454     uint public price = .088 ether;
2455 
2456     bytes32 public merkleRoot;
2457 
2458     bool public mintOpen = false;
2459     bool public whitelistOnly = true;
2460     bool public allowBurn = false;
2461 
2462     string internal baseTokenURI = "ipfs://QmX8U753tWoyE72sGTmS27ZFCRwbn6jEou7zGPzW8TkRyH/";
2463 
2464 	address[] private addressList = [
2465         0xE4847F29a9c84a32eA23D34324F69228c0c89E58,
2466         0xEC4D6eCb87D3674bd65BA5e7079C63cB9f762E48
2467 	];
2468 
2469     // Out of 1,000,000 for 4 decimals
2470 	uint[] private shareList = [
2471         950000,
2472         50000
2473 	];
2474 
2475     constructor() ERC721A("Gatsby Tools Pass", "GTP") PaymentSplitter(addressList, shareList) {}
2476 
2477     function toggleMint() external onlyOwner {
2478         mintOpen = !mintOpen;
2479     }
2480 
2481     function toggleWhitelist() external onlyOwner {
2482         whitelistOnly = !whitelistOnly;
2483     }
2484 
2485     function toggleBurning() external onlyOwner {
2486         allowBurn = !allowBurn;
2487     }
2488     
2489     function setBaseTokenURI(string calldata _uri) external onlyOwner {
2490         baseTokenURI = _uri;
2491     }
2492 
2493     function setPrice(uint _price) external onlyOwner {
2494         price = _price;
2495     }
2496 
2497     function setMaxSupply(uint _maxSupply) external onlyOwner {
2498         maxSupply = _maxSupply;
2499     }
2500 
2501     function setMaxMintsPerWallet(uint _maxMintsPerWallet) external onlyOwner {
2502         maxMintsPerWallet = _maxMintsPerWallet;
2503     }
2504 
2505     function _baseURI() internal override view returns (string memory) {
2506         return baseTokenURI;
2507     }
2508 
2509     function setMerkleRoot(bytes32 _merkleRoot) external onlyOwner{
2510         merkleRoot = _merkleRoot;
2511     }
2512 
2513     function mintWhitelist(bytes32[] calldata _merkleProof) external payable {
2514         require(mintOpen, "Mint Not Open");
2515         require(MerkleProof.verifyCalldata(_merkleProof, merkleRoot,keccak256(abi.encodePacked(msg.sender))), "Proof invalid");
2516         require(msg.value >= price, "Not Enough Ether");
2517         require(_totalMinted() + 1 <= maxSupply, "Max Supply");
2518         require(_numberMinted(msg.sender) + 1 <= maxMintsPerWallet, "Out Of Mints");
2519         _mint(msg.sender, 1);
2520     }
2521 
2522     function mintPublic() external payable {
2523         require(mintOpen, "Mint Not Open");
2524         require(!whitelistOnly, "Only Whitelist");
2525         require(msg.value >= price, "Not Enough Ether");
2526         require(_totalMinted() + 1 <= maxSupply, "Max Supply");
2527         require(_numberMinted(msg.sender) + 1 <= maxMintsPerWallet, "Out Of Mints");
2528         _mint(msg.sender, 1);
2529     }
2530 
2531     function mintOwner(uint _amount) external onlyOwner {
2532         _mint(msg.sender, _amount);
2533     }
2534 
2535     function burn(uint256 tokenId) public virtual {
2536         require(allowBurn, "Not Allowed");
2537         _burn(tokenId, true);
2538     }
2539 
2540     function _startTokenId() internal override view virtual returns (uint256) {
2541         return 1;
2542     }
2543 
2544 }