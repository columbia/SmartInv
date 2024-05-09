1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
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
23      * @dev Moves `amount` tokens from the caller's account to `recipient`.
24      *
25      * Returns a boolean value indicating whether the operation succeeded.
26      *
27      * Emits a {Transfer} event.
28      */
29     function transfer(address recipient, uint256 amount) external returns (bool);
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
57      * @dev Moves `amount` tokens from `sender` to `recipient` using the
58      * allowance mechanism. `amount` is then deducted from the caller's
59      * allowance.
60      *
61      * Returns a boolean value indicating whether the operation succeeded.
62      *
63      * Emits a {Transfer} event.
64      */
65     function transferFrom(
66         address sender,
67         address recipient,
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
86 // File: @openzeppelin/contracts/utils/Strings.sol
87 
88 
89 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
90 
91 pragma solidity ^0.8.0;
92 
93 /**
94  * @dev String operations.
95  */
96 library Strings {
97     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
98 
99     /**
100      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
101      */
102     function toString(uint256 value) internal pure returns (string memory) {
103         // Inspired by OraclizeAPI's implementation - MIT licence
104         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
105 
106         if (value == 0) {
107             return "0";
108         }
109         uint256 temp = value;
110         uint256 digits;
111         while (temp != 0) {
112             digits++;
113             temp /= 10;
114         }
115         bytes memory buffer = new bytes(digits);
116         while (value != 0) {
117             digits -= 1;
118             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
119             value /= 10;
120         }
121         return string(buffer);
122     }
123 
124     /**
125      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
126      */
127     function toHexString(uint256 value) internal pure returns (string memory) {
128         if (value == 0) {
129             return "0x00";
130         }
131         uint256 temp = value;
132         uint256 length = 0;
133         while (temp != 0) {
134             length++;
135             temp >>= 8;
136         }
137         return toHexString(value, length);
138     }
139 
140     /**
141      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
142      */
143     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
144         bytes memory buffer = new bytes(2 * length + 2);
145         buffer[0] = "0";
146         buffer[1] = "x";
147         for (uint256 i = 2 * length + 1; i > 1; --i) {
148             buffer[i] = _HEX_SYMBOLS[value & 0xf];
149             value >>= 4;
150         }
151         require(value == 0, "Strings: hex length insufficient");
152         return string(buffer);
153     }
154 }
155 
156 // File: contracts/OpenSea.sol
157 
158 //SPDX-License-Identifier: MIT
159 pragma solidity ^0.8.7;
160 
161 contract OpenSea {
162     address private _proxyRegistry;
163 
164     function proxyRegistry() public view returns (address) {
165         return _proxyRegistry;
166     }
167 
168     function isOwnersOpenSeaProxy(address owner, address operator)
169         public
170         view
171         returns (bool)
172     {
173         address proxyRegistry_ = _proxyRegistry;
174 
175         if (proxyRegistry_ != address(0)) {
176             if (block.chainid == 1 || block.chainid == 4) {
177                 return
178                     address(ProxyRegistry(proxyRegistry_).proxies(owner)) ==
179                     operator;
180             } else if (block.chainid == 137 || block.chainid == 80001) {
181                 return proxyRegistry_ == operator;
182             }
183         }
184 
185         return false;
186     }
187 
188     function _setOpenSeaRegistry(address proxyRegistryAddress) internal {
189         _proxyRegistry = proxyRegistryAddress;
190     }
191 }
192 
193 contract OwnableDelegateProxy {}
194 
195 contract ProxyRegistry {
196     mapping(address => OwnableDelegateProxy) public proxies;
197 }
198 // File: @openzeppelin/contracts/utils/Address.sol
199 
200 
201 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
202 
203 pragma solidity ^0.8.0;
204 
205 /**
206  * @dev Collection of functions related to the address type
207  */
208 library Address {
209     /**
210      * @dev Returns true if `account` is a contract.
211      *
212      * [IMPORTANT]
213      * ====
214      * It is unsafe to assume that an address for which this function returns
215      * false is an externally-owned account (EOA) and not a contract.
216      *
217      * Among others, `isContract` will return false for the following
218      * types of addresses:
219      *
220      *  - an externally-owned account
221      *  - a contract in construction
222      *  - an address where a contract will be created
223      *  - an address where a contract lived, but was destroyed
224      * ====
225      */
226     function isContract(address account) internal view returns (bool) {
227         // This method relies on extcodesize, which returns 0 for contracts in
228         // construction, since the code is only stored at the end of the
229         // constructor execution.
230 
231         uint256 size;
232         assembly {
233             size := extcodesize(account)
234         }
235         return size > 0;
236     }
237 
238     /**
239      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
240      * `recipient`, forwarding all available gas and reverting on errors.
241      *
242      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
243      * of certain opcodes, possibly making contracts go over the 2300 gas limit
244      * imposed by `transfer`, making them unable to receive funds via
245      * `transfer`. {sendValue} removes this limitation.
246      *
247      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
248      *
249      * IMPORTANT: because control is transferred to `recipient`, care must be
250      * taken to not create reentrancy vulnerabilities. Consider using
251      * {ReentrancyGuard} or the
252      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
253      */
254     function sendValue(address payable recipient, uint256 amount) internal {
255         require(address(this).balance >= amount, "Address: insufficient balance");
256 
257         (bool success, ) = recipient.call{value: amount}("");
258         require(success, "Address: unable to send value, recipient may have reverted");
259     }
260 
261     /**
262      * @dev Performs a Solidity function call using a low level `call`. A
263      * plain `call` is an unsafe replacement for a function call: use this
264      * function instead.
265      *
266      * If `target` reverts with a revert reason, it is bubbled up by this
267      * function (like regular Solidity function calls).
268      *
269      * Returns the raw returned data. To convert to the expected return value,
270      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
271      *
272      * Requirements:
273      *
274      * - `target` must be a contract.
275      * - calling `target` with `data` must not revert.
276      *
277      * _Available since v3.1._
278      */
279     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
280         return functionCall(target, data, "Address: low-level call failed");
281     }
282 
283     /**
284      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
285      * `errorMessage` as a fallback revert reason when `target` reverts.
286      *
287      * _Available since v3.1._
288      */
289     function functionCall(
290         address target,
291         bytes memory data,
292         string memory errorMessage
293     ) internal returns (bytes memory) {
294         return functionCallWithValue(target, data, 0, errorMessage);
295     }
296 
297     /**
298      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
299      * but also transferring `value` wei to `target`.
300      *
301      * Requirements:
302      *
303      * - the calling contract must have an ETH balance of at least `value`.
304      * - the called Solidity function must be `payable`.
305      *
306      * _Available since v3.1._
307      */
308     function functionCallWithValue(
309         address target,
310         bytes memory data,
311         uint256 value
312     ) internal returns (bytes memory) {
313         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
314     }
315 
316     /**
317      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
318      * with `errorMessage` as a fallback revert reason when `target` reverts.
319      *
320      * _Available since v3.1._
321      */
322     function functionCallWithValue(
323         address target,
324         bytes memory data,
325         uint256 value,
326         string memory errorMessage
327     ) internal returns (bytes memory) {
328         require(address(this).balance >= value, "Address: insufficient balance for call");
329         require(isContract(target), "Address: call to non-contract");
330 
331         (bool success, bytes memory returndata) = target.call{value: value}(data);
332         return verifyCallResult(success, returndata, errorMessage);
333     }
334 
335     /**
336      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
337      * but performing a static call.
338      *
339      * _Available since v3.3._
340      */
341     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
342         return functionStaticCall(target, data, "Address: low-level static call failed");
343     }
344 
345     /**
346      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
347      * but performing a static call.
348      *
349      * _Available since v3.3._
350      */
351     function functionStaticCall(
352         address target,
353         bytes memory data,
354         string memory errorMessage
355     ) internal view returns (bytes memory) {
356         require(isContract(target), "Address: static call to non-contract");
357 
358         (bool success, bytes memory returndata) = target.staticcall(data);
359         return verifyCallResult(success, returndata, errorMessage);
360     }
361 
362     /**
363      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
364      * but performing a delegate call.
365      *
366      * _Available since v3.4._
367      */
368     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
369         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
370     }
371 
372     /**
373      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
374      * but performing a delegate call.
375      *
376      * _Available since v3.4._
377      */
378     function functionDelegateCall(
379         address target,
380         bytes memory data,
381         string memory errorMessage
382     ) internal returns (bytes memory) {
383         require(isContract(target), "Address: delegate call to non-contract");
384 
385         (bool success, bytes memory returndata) = target.delegatecall(data);
386         return verifyCallResult(success, returndata, errorMessage);
387     }
388 
389     /**
390      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
391      * revert reason using the provided one.
392      *
393      * _Available since v4.3._
394      */
395     function verifyCallResult(
396         bool success,
397         bytes memory returndata,
398         string memory errorMessage
399     ) internal pure returns (bytes memory) {
400         if (success) {
401             return returndata;
402         } else {
403             // Look for revert reason and bubble it up if present
404             if (returndata.length > 0) {
405                 // The easiest way to bubble the revert reason is using memory via assembly
406 
407                 assembly {
408                     let returndata_size := mload(returndata)
409                     revert(add(32, returndata), returndata_size)
410                 }
411             } else {
412                 revert(errorMessage);
413             }
414         }
415     }
416 }
417 
418 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
419 
420 
421 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
422 
423 pragma solidity ^0.8.0;
424 
425 
426 
427 /**
428  * @title SafeERC20
429  * @dev Wrappers around ERC20 operations that throw on failure (when the token
430  * contract returns false). Tokens that return no value (and instead revert or
431  * throw on failure) are also supported, non-reverting calls are assumed to be
432  * successful.
433  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
434  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
435  */
436 library SafeERC20 {
437     using Address for address;
438 
439     function safeTransfer(
440         IERC20 token,
441         address to,
442         uint256 value
443     ) internal {
444         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
445     }
446 
447     function safeTransferFrom(
448         IERC20 token,
449         address from,
450         address to,
451         uint256 value
452     ) internal {
453         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
454     }
455 
456     /**
457      * @dev Deprecated. This function has issues similar to the ones found in
458      * {IERC20-approve}, and its usage is discouraged.
459      *
460      * Whenever possible, use {safeIncreaseAllowance} and
461      * {safeDecreaseAllowance} instead.
462      */
463     function safeApprove(
464         IERC20 token,
465         address spender,
466         uint256 value
467     ) internal {
468         // safeApprove should only be called when setting an initial allowance,
469         // or when resetting it to zero. To increase and decrease it, use
470         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
471         require(
472             (value == 0) || (token.allowance(address(this), spender) == 0),
473             "SafeERC20: approve from non-zero to non-zero allowance"
474         );
475         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
476     }
477 
478     function safeIncreaseAllowance(
479         IERC20 token,
480         address spender,
481         uint256 value
482     ) internal {
483         uint256 newAllowance = token.allowance(address(this), spender) + value;
484         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
485     }
486 
487     function safeDecreaseAllowance(
488         IERC20 token,
489         address spender,
490         uint256 value
491     ) internal {
492         unchecked {
493             uint256 oldAllowance = token.allowance(address(this), spender);
494             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
495             uint256 newAllowance = oldAllowance - value;
496             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
497         }
498     }
499 
500     /**
501      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
502      * on the return value: the return value is optional (but if data is returned, it must not be false).
503      * @param token The token targeted by the call.
504      * @param data The call data (encoded using abi.encode or one of its variants).
505      */
506     function _callOptionalReturn(IERC20 token, bytes memory data) private {
507         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
508         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
509         // the target address contains contract code and also asserts for success in the low-level call.
510 
511         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
512         if (returndata.length > 0) {
513             // Return data is optional
514             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
515         }
516     }
517 }
518 
519 // File: @openzeppelin/contracts/utils/Context.sol
520 
521 
522 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
523 
524 pragma solidity ^0.8.0;
525 
526 /**
527  * @dev Provides information about the current execution context, including the
528  * sender of the transaction and its data. While these are generally available
529  * via msg.sender and msg.data, they should not be accessed in such a direct
530  * manner, since when dealing with meta-transactions the account sending and
531  * paying for execution may not be the actual sender (as far as an application
532  * is concerned).
533  *
534  * This contract is only required for intermediate, library-like contracts.
535  */
536 abstract contract Context {
537     function _msgSender() internal view virtual returns (address) {
538         return msg.sender;
539     }
540 
541     function _msgData() internal view virtual returns (bytes calldata) {
542         return msg.data;
543     }
544 }
545 
546 // File: @openzeppelin/contracts/finance/PaymentSplitter.sol
547 
548 
549 // OpenZeppelin Contracts v4.4.1 (finance/PaymentSplitter.sol)
550 
551 pragma solidity ^0.8.0;
552 
553 
554 
555 
556 /**
557  * @title PaymentSplitter
558  * @dev This contract allows to split Ether payments among a group of accounts. The sender does not need to be aware
559  * that the Ether will be split in this way, since it is handled transparently by the contract.
560  *
561  * The split can be in equal parts or in any other arbitrary proportion. The way this is specified is by assigning each
562  * account to a number of shares. Of all the Ether that this contract receives, each account will then be able to claim
563  * an amount proportional to the percentage of total shares they were assigned.
564  *
565  * `PaymentSplitter` follows a _pull payment_ model. This means that payments are not automatically forwarded to the
566  * accounts but kept in this contract, and the actual transfer is triggered as a separate step by calling the {release}
567  * function.
568  *
569  * NOTE: This contract assumes that ERC20 tokens will behave similarly to native tokens (Ether). Rebasing tokens, and
570  * tokens that apply fees during transfers, are likely to not be supported as expected. If in doubt, we encourage you
571  * to run tests before sending real value to this contract.
572  */
573 contract PaymentSplitter is Context {
574     event PayeeAdded(address account, uint256 shares);
575     event PaymentReleased(address to, uint256 amount);
576     event ERC20PaymentReleased(IERC20 indexed token, address to, uint256 amount);
577     event PaymentReceived(address from, uint256 amount);
578 
579     uint256 private _totalShares;
580     uint256 private _totalReleased;
581 
582     mapping(address => uint256) private _shares;
583     mapping(address => uint256) private _released;
584     address[] private _payees;
585 
586     mapping(IERC20 => uint256) private _erc20TotalReleased;
587     mapping(IERC20 => mapping(address => uint256)) private _erc20Released;
588 
589     /**
590      * @dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at
591      * the matching position in the `shares` array.
592      *
593      * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no
594      * duplicates in `payees`.
595      */
596     constructor(address[] memory payees, uint256[] memory shares_) payable {
597         require(payees.length == shares_.length, "PaymentSplitter: payees and shares length mismatch");
598         require(payees.length > 0, "PaymentSplitter: no payees");
599 
600         for (uint256 i = 0; i < payees.length; i++) {
601             _addPayee(payees[i], shares_[i]);
602         }
603     }
604 
605     /**
606      * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully
607      * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
608      * reliability of the events, and not the actual splitting of Ether.
609      *
610      * To learn more about this see the Solidity documentation for
611      * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
612      * functions].
613      */
614     receive() external payable virtual {
615         emit PaymentReceived(_msgSender(), msg.value);
616     }
617 
618     /**
619      * @dev Getter for the total shares held by payees.
620      */
621     function totalShares() public view returns (uint256) {
622         return _totalShares;
623     }
624 
625     /**
626      * @dev Getter for the total amount of Ether already released.
627      */
628     function totalReleased() public view returns (uint256) {
629         return _totalReleased;
630     }
631 
632     /**
633      * @dev Getter for the total amount of `token` already released. `token` should be the address of an IERC20
634      * contract.
635      */
636     function totalReleased(IERC20 token) public view returns (uint256) {
637         return _erc20TotalReleased[token];
638     }
639 
640     /**
641      * @dev Getter for the amount of shares held by an account.
642      */
643     function shares(address account) public view returns (uint256) {
644         return _shares[account];
645     }
646 
647     /**
648      * @dev Getter for the amount of Ether already released to a payee.
649      */
650     function released(address account) public view returns (uint256) {
651         return _released[account];
652     }
653 
654     /**
655      * @dev Getter for the amount of `token` tokens already released to a payee. `token` should be the address of an
656      * IERC20 contract.
657      */
658     function released(IERC20 token, address account) public view returns (uint256) {
659         return _erc20Released[token][account];
660     }
661 
662     /**
663      * @dev Getter for the address of the payee number `index`.
664      */
665     function payee(uint256 index) public view returns (address) {
666         return _payees[index];
667     }
668 
669     /**
670      * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
671      * total shares and their previous withdrawals.
672      */
673     function release(address payable account) public virtual {
674         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
675 
676         uint256 totalReceived = address(this).balance + totalReleased();
677         uint256 payment = _pendingPayment(account, totalReceived, released(account));
678 
679         require(payment != 0, "PaymentSplitter: account is not due payment");
680 
681         _released[account] += payment;
682         _totalReleased += payment;
683 
684         Address.sendValue(account, payment);
685         emit PaymentReleased(account, payment);
686     }
687 
688     /**
689      * @dev Triggers a transfer to `account` of the amount of `token` tokens they are owed, according to their
690      * percentage of the total shares and their previous withdrawals. `token` must be the address of an IERC20
691      * contract.
692      */
693     function release(IERC20 token, address account) public virtual {
694         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
695 
696         uint256 totalReceived = token.balanceOf(address(this)) + totalReleased(token);
697         uint256 payment = _pendingPayment(account, totalReceived, released(token, account));
698 
699         require(payment != 0, "PaymentSplitter: account is not due payment");
700 
701         _erc20Released[token][account] += payment;
702         _erc20TotalReleased[token] += payment;
703 
704         SafeERC20.safeTransfer(token, account, payment);
705         emit ERC20PaymentReleased(token, account, payment);
706     }
707 
708     /**
709      * @dev internal logic for computing the pending payment of an `account` given the token historical balances and
710      * already released amounts.
711      */
712     function _pendingPayment(
713         address account,
714         uint256 totalReceived,
715         uint256 alreadyReleased
716     ) private view returns (uint256) {
717         return (totalReceived * _shares[account]) / _totalShares - alreadyReleased;
718     }
719 
720     /**
721      * @dev Add a new payee to the contract.
722      * @param account The address of the payee to add.
723      * @param shares_ The number of shares owned by the payee.
724      */
725     function _addPayee(address account, uint256 shares_) private {
726         require(account != address(0), "PaymentSplitter: account is the zero address");
727         require(shares_ > 0, "PaymentSplitter: shares are 0");
728         require(_shares[account] == 0, "PaymentSplitter: account already has shares");
729 
730         _payees.push(account);
731         _shares[account] = shares_;
732         _totalShares = _totalShares + shares_;
733         emit PayeeAdded(account, shares_);
734     }
735 }
736 
737 // File: @openzeppelin/contracts/access/Ownable.sol
738 
739 
740 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
741 
742 pragma solidity ^0.8.0;
743 
744 
745 /**
746  * @dev Contract module which provides a basic access control mechanism, where
747  * there is an account (an owner) that can be granted exclusive access to
748  * specific functions.
749  *
750  * By default, the owner account will be the one that deploys the contract. This
751  * can later be changed with {transferOwnership}.
752  *
753  * This module is used through inheritance. It will make available the modifier
754  * `onlyOwner`, which can be applied to your functions to restrict their use to
755  * the owner.
756  */
757 abstract contract Ownable is Context {
758     address private _owner;
759 
760     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
761 
762     /**
763      * @dev Initializes the contract setting the deployer as the initial owner.
764      */
765     constructor() {
766         _transferOwnership(_msgSender());
767     }
768 
769     /**
770      * @dev Returns the address of the current owner.
771      */
772     function owner() public view virtual returns (address) {
773         return _owner;
774     }
775 
776     /**
777      * @dev Throws if called by any account other than the owner.
778      */
779     modifier onlyOwner() {
780         require(owner() == _msgSender(), "Ownable: caller is not the owner");
781         _;
782     }
783 
784     /**
785      * @dev Leaves the contract without owner. It will not be possible to call
786      * `onlyOwner` functions anymore. Can only be called by the current owner.
787      *
788      * NOTE: Renouncing ownership will leave the contract without an owner,
789      * thereby removing any functionality that is only available to the owner.
790      */
791     function renounceOwnership() public virtual onlyOwner {
792         _transferOwnership(address(0));
793     }
794 
795     /**
796      * @dev Transfers ownership of the contract to a new account (`newOwner`).
797      * Can only be called by the current owner.
798      */
799     function transferOwnership(address newOwner) public virtual onlyOwner {
800         require(newOwner != address(0), "Ownable: new owner is the zero address");
801         _transferOwnership(newOwner);
802     }
803 
804     /**
805      * @dev Transfers ownership of the contract to a new account (`newOwner`).
806      * Internal function without access restriction.
807      */
808     function _transferOwnership(address newOwner) internal virtual {
809         address oldOwner = _owner;
810         _owner = newOwner;
811         emit OwnershipTransferred(oldOwner, newOwner);
812     }
813 }
814 
815 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
816 
817 
818 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
819 
820 pragma solidity ^0.8.0;
821 
822 /**
823  * @title ERC721 token receiver interface
824  * @dev Interface for any contract that wants to support safeTransfers
825  * from ERC721 asset contracts.
826  */
827 interface IERC721Receiver {
828     /**
829      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
830      * by `operator` from `from`, this function is called.
831      *
832      * It must return its Solidity selector to confirm the token transfer.
833      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
834      *
835      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
836      */
837     function onERC721Received(
838         address operator,
839         address from,
840         uint256 tokenId,
841         bytes calldata data
842     ) external returns (bytes4);
843 }
844 
845 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
846 
847 
848 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
849 
850 pragma solidity ^0.8.0;
851 
852 /**
853  * @dev Interface of the ERC165 standard, as defined in the
854  * https://eips.ethereum.org/EIPS/eip-165[EIP].
855  *
856  * Implementers can declare support of contract interfaces, which can then be
857  * queried by others ({ERC165Checker}).
858  *
859  * For an implementation, see {ERC165}.
860  */
861 interface IERC165 {
862     /**
863      * @dev Returns true if this contract implements the interface defined by
864      * `interfaceId`. See the corresponding
865      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
866      * to learn more about how these ids are created.
867      *
868      * This function call must use less than 30 000 gas.
869      */
870     function supportsInterface(bytes4 interfaceId) external view returns (bool);
871 }
872 
873 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
874 
875 
876 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
877 
878 pragma solidity ^0.8.0;
879 
880 
881 /**
882  * @dev Implementation of the {IERC165} interface.
883  *
884  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
885  * for the additional interface id that will be supported. For example:
886  *
887  * ```solidity
888  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
889  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
890  * }
891  * ```
892  *
893  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
894  */
895 abstract contract ERC165 is IERC165 {
896     /**
897      * @dev See {IERC165-supportsInterface}.
898      */
899     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
900         return interfaceId == type(IERC165).interfaceId;
901     }
902 }
903 
904 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
905 
906 
907 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
908 
909 pragma solidity ^0.8.0;
910 
911 
912 /**
913  * @dev Required interface of an ERC721 compliant contract.
914  */
915 interface IERC721 is IERC165 {
916     /**
917      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
918      */
919     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
920 
921     /**
922      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
923      */
924     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
925 
926     /**
927      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
928      */
929     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
930 
931     /**
932      * @dev Returns the number of tokens in ``owner``'s account.
933      */
934     function balanceOf(address owner) external view returns (uint256 balance);
935 
936     /**
937      * @dev Returns the owner of the `tokenId` token.
938      *
939      * Requirements:
940      *
941      * - `tokenId` must exist.
942      */
943     function ownerOf(uint256 tokenId) external view returns (address owner);
944 
945     /**
946      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
947      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
948      *
949      * Requirements:
950      *
951      * - `from` cannot be the zero address.
952      * - `to` cannot be the zero address.
953      * - `tokenId` token must exist and be owned by `from`.
954      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
955      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
956      *
957      * Emits a {Transfer} event.
958      */
959     function safeTransferFrom(
960         address from,
961         address to,
962         uint256 tokenId
963     ) external;
964 
965     /**
966      * @dev Transfers `tokenId` token from `from` to `to`.
967      *
968      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
969      *
970      * Requirements:
971      *
972      * - `from` cannot be the zero address.
973      * - `to` cannot be the zero address.
974      * - `tokenId` token must be owned by `from`.
975      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
976      *
977      * Emits a {Transfer} event.
978      */
979     function transferFrom(
980         address from,
981         address to,
982         uint256 tokenId
983     ) external;
984 
985     /**
986      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
987      * The approval is cleared when the token is transferred.
988      *
989      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
990      *
991      * Requirements:
992      *
993      * - The caller must own the token or be an approved operator.
994      * - `tokenId` must exist.
995      *
996      * Emits an {Approval} event.
997      */
998     function approve(address to, uint256 tokenId) external;
999 
1000     /**
1001      * @dev Returns the account approved for `tokenId` token.
1002      *
1003      * Requirements:
1004      *
1005      * - `tokenId` must exist.
1006      */
1007     function getApproved(uint256 tokenId) external view returns (address operator);
1008 
1009     /**
1010      * @dev Approve or remove `operator` as an operator for the caller.
1011      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1012      *
1013      * Requirements:
1014      *
1015      * - The `operator` cannot be the caller.
1016      *
1017      * Emits an {ApprovalForAll} event.
1018      */
1019     function setApprovalForAll(address operator, bool _approved) external;
1020 
1021     /**
1022      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1023      *
1024      * See {setApprovalForAll}
1025      */
1026     function isApprovedForAll(address owner, address operator) external view returns (bool);
1027 
1028     /**
1029      * @dev Safely transfers `tokenId` token from `from` to `to`.
1030      *
1031      * Requirements:
1032      *
1033      * - `from` cannot be the zero address.
1034      * - `to` cannot be the zero address.
1035      * - `tokenId` token must exist and be owned by `from`.
1036      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1037      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1038      *
1039      * Emits a {Transfer} event.
1040      */
1041     function safeTransferFrom(
1042         address from,
1043         address to,
1044         uint256 tokenId,
1045         bytes calldata data
1046     ) external;
1047 }
1048 
1049 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1050 
1051 
1052 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
1053 
1054 pragma solidity ^0.8.0;
1055 
1056 
1057 /**
1058  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1059  * @dev See https://eips.ethereum.org/EIPS/eip-721
1060  */
1061 interface IERC721Enumerable is IERC721 {
1062     /**
1063      * @dev Returns the total amount of tokens stored by the contract.
1064      */
1065     function totalSupply() external view returns (uint256);
1066 
1067     /**
1068      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1069      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1070      */
1071     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1072 
1073     /**
1074      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1075      * Use along with {totalSupply} to enumerate all tokens.
1076      */
1077     function tokenByIndex(uint256 index) external view returns (uint256);
1078 }
1079 
1080 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1081 
1082 
1083 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1084 
1085 pragma solidity ^0.8.0;
1086 
1087 
1088 /**
1089  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1090  * @dev See https://eips.ethereum.org/EIPS/eip-721
1091  */
1092 interface IERC721Metadata is IERC721 {
1093     /**
1094      * @dev Returns the token collection name.
1095      */
1096     function name() external view returns (string memory);
1097 
1098     /**
1099      * @dev Returns the token collection symbol.
1100      */
1101     function symbol() external view returns (string memory);
1102 
1103     /**
1104      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1105      */
1106     function tokenURI(uint256 tokenId) external view returns (string memory);
1107 }
1108 
1109 // File: contracts/ERC721.sol
1110 
1111 
1112 
1113 pragma solidity ^0.8.7;
1114 
1115 
1116 
1117 
1118 
1119 
1120 
1121 abstract contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1122     using Address for address;
1123 
1124     string private _name;
1125     string private _symbol;
1126 
1127     // Mapping from token ID to owner address
1128     address[] internal _owners;
1129 
1130     mapping(uint256 => address) private _tokenApprovals;
1131     mapping(address => mapping(address => bool)) private _operatorApprovals;
1132 
1133     /**
1134      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1135      */
1136     constructor(string memory name_, string memory symbol_) {
1137         _name = name_;
1138         _symbol = symbol_;
1139         _owners.push(address(0));
1140     }
1141 
1142     /**
1143      * @dev See {IERC165-supportsInterface}.
1144      */
1145     function supportsInterface(bytes4 interfaceId)
1146         public
1147         view
1148         virtual
1149         override(ERC165, IERC165)
1150         returns (bool)
1151     {
1152         return
1153             interfaceId == type(IERC721).interfaceId ||
1154             interfaceId == type(IERC721Metadata).interfaceId ||
1155             super.supportsInterface(interfaceId);
1156     }
1157 
1158     /**
1159      * @dev See {IERC721-balanceOf}.
1160      */
1161     function balanceOf(address owner)
1162         public
1163         view
1164         virtual
1165         override
1166         returns (uint256)
1167     {
1168         require(
1169             owner != address(0),
1170             "ERC721: balance query for the zero address"
1171         );
1172 
1173         uint256 count;
1174         for (uint256 i; i < _owners.length; ++i) {
1175             if (owner == _owners[i]) ++count;
1176         }
1177         return count;
1178     }
1179 
1180     /**
1181      * @dev See {IERC721-ownerOf}.
1182      */
1183     function ownerOf(uint256 tokenId)
1184         public
1185         view
1186         virtual
1187         override
1188         returns (address)
1189     {
1190         address owner = _owners[tokenId];
1191         require(
1192             owner != address(0),
1193             "ERC721: owner query for nonexistent token"
1194         );
1195         return owner;
1196     }
1197 
1198     /**
1199      * @dev See {IERC721Metadata-name}.
1200      */
1201     function name() public view virtual override returns (string memory) {
1202         return _name;
1203     }
1204 
1205     /**
1206      * @dev See {IERC721Metadata-symbol}.
1207      */
1208     function symbol() public view virtual override returns (string memory) {
1209         return _symbol;
1210     }
1211 
1212     /**
1213      * @dev See {IERC721-approve}.
1214      */
1215     function approve(address to, uint256 tokenId) public virtual override {
1216         address owner = ERC721.ownerOf(tokenId);
1217         require(to != owner, "ERC721: approval to current owner");
1218 
1219         require(
1220             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1221             "ERC721: approve caller is not owner nor approved for all"
1222         );
1223 
1224         _approve(to, tokenId);
1225     }
1226 
1227     /**
1228      * @dev See {IERC721-getApproved}.
1229      */
1230     function getApproved(uint256 tokenId)
1231         public
1232         view
1233         virtual
1234         override
1235         returns (address)
1236     {
1237         require(
1238             _exists(tokenId),
1239             "ERC721: approved query for nonexistent token"
1240         );
1241 
1242         return _tokenApprovals[tokenId];
1243     }
1244 
1245     /**
1246      * @dev See {IERC721-setApprovalForAll}.
1247      */
1248     function setApprovalForAll(address operator, bool approved)
1249         public
1250         virtual
1251         override
1252     {
1253         require(operator != _msgSender(), "ERC721: approve to caller");
1254 
1255         _operatorApprovals[_msgSender()][operator] = approved;
1256         emit ApprovalForAll(_msgSender(), operator, approved);
1257     }
1258 
1259     /**
1260      * @dev See {IERC721-isApprovedForAll}.
1261      */
1262     function isApprovedForAll(address owner, address operator)
1263         public
1264         view
1265         virtual
1266         override
1267         returns (bool)
1268     {
1269         return _operatorApprovals[owner][operator];
1270     }
1271 
1272     /**
1273      * @dev See {IERC721-transferFrom}.
1274      */
1275     function transferFrom(
1276         address from,
1277         address to,
1278         uint256 tokenId
1279     ) public virtual override {
1280         //solhint-disable-next-line max-line-length
1281         require(
1282             _isApprovedOrOwner(_msgSender(), tokenId),
1283             "ERC721: transfer caller is not owner nor approved"
1284         );
1285 
1286         _transfer(from, to, tokenId);
1287     }
1288 
1289     /**
1290      * @dev See {IERC721-safeTransferFrom}.
1291      */
1292     function safeTransferFrom(
1293         address from,
1294         address to,
1295         uint256 tokenId
1296     ) public virtual override {
1297         safeTransferFrom(from, to, tokenId, "");
1298     }
1299 
1300     /**
1301      * @dev See {IERC721-safeTransferFrom}.
1302      */
1303     function safeTransferFrom(
1304         address from,
1305         address to,
1306         uint256 tokenId,
1307         bytes memory _data
1308     ) public virtual override {
1309         require(
1310             _isApprovedOrOwner(_msgSender(), tokenId),
1311             "ERC721: transfer caller is not owner nor approved"
1312         );
1313         _safeTransfer(from, to, tokenId, _data);
1314     }
1315 
1316     /**
1317      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1318      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1319      *
1320      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1321      *
1322      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1323      * implement alternative mechanisms to perform token transfer, such as signature-based.
1324      *
1325      * Requirements:
1326      *
1327      * - `from` cannot be the zero address.
1328      * - `to` cannot be the zero address.
1329      * - `tokenId` token must exist and be owned by `from`.
1330      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1331      *
1332      * Emits a {Transfer} event.
1333      */
1334     function _safeTransfer(
1335         address from,
1336         address to,
1337         uint256 tokenId,
1338         bytes memory _data
1339     ) internal virtual {
1340         _transfer(from, to, tokenId);
1341         require(
1342             _checkOnERC721Received(from, to, tokenId, _data),
1343             "ERC721: transfer to non ERC721Receiver implementer"
1344         );
1345     }
1346 
1347     /**
1348      * @dev Returns whether `tokenId` exists.
1349      *
1350      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1351      *
1352      * Tokens start existing when they are minted (`_mint`),
1353      * and stop existing when they are burned (`_burn`).
1354      */
1355     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1356         return tokenId < _owners.length && _owners[tokenId] != address(0);
1357     }
1358 
1359     /**
1360      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1361      *
1362      * Requirements:
1363      *
1364      * - `tokenId` must exist.
1365      */
1366     function _isApprovedOrOwner(address spender, uint256 tokenId)
1367         internal
1368         view
1369         virtual
1370         returns (bool)
1371     {
1372         require(
1373             _exists(tokenId),
1374             "ERC721: operator query for nonexistent token"
1375         );
1376         address owner = ERC721.ownerOf(tokenId);
1377         return (spender == owner ||
1378             getApproved(tokenId) == spender ||
1379             isApprovedForAll(owner, spender));
1380     }
1381 
1382     /**
1383      * @dev Safely mints `tokenId` and transfers it to `to`.
1384      *
1385      * Requirements:
1386      *
1387      * - `tokenId` must not exist.
1388      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1389      *
1390      * Emits a {Transfer} event.
1391      */
1392     function _safeMint(address to, uint256 tokenId) internal virtual {
1393         _safeMint(to, tokenId, "");
1394     }
1395 
1396     /**
1397      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1398      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1399      */
1400     function _safeMint(
1401         address to,
1402         uint256 tokenId,
1403         bytes memory _data
1404     ) internal virtual {
1405         _mint(to, tokenId);
1406         require(
1407             _checkOnERC721Received(address(0), to, tokenId, _data),
1408             "ERC721: transfer to non ERC721Receiver implementer"
1409         );
1410     }
1411 
1412     /**
1413      * @dev Mints `tokenId` and transfers it to `to`.
1414      *
1415      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1416      *
1417      * Requirements:
1418      *
1419      * - `tokenId` must not exist.
1420      * - `to` cannot be the zero address.
1421      *
1422      * Emits a {Transfer} event.
1423      */
1424     function _mint(address to, uint256 tokenId) internal virtual {
1425         require(to != address(0), "ERC721: mint to the zero address");
1426         require(!_exists(tokenId), "ERC721: token already minted");
1427 
1428         _beforeTokenTransfer(address(0), to, tokenId);
1429         _owners.push(to);
1430 
1431         emit Transfer(address(0), to, tokenId);
1432     }
1433 
1434     /**
1435      * @dev Destroys `tokenId`.
1436      * The approval is cleared when the token is burned.
1437      *
1438      * Requirements:
1439      *
1440      * - `tokenId` must exist.
1441      *
1442      * Emits a {Transfer} event.
1443      */
1444     function _burn(uint256 tokenId) internal virtual {
1445         address owner = ERC721.ownerOf(tokenId);
1446 
1447         _beforeTokenTransfer(owner, address(0), tokenId);
1448 
1449         // Clear approvals
1450         _approve(address(0), tokenId);
1451         _owners[tokenId] = address(0);
1452 
1453         emit Transfer(owner, address(0), tokenId);
1454     }
1455 
1456     /**
1457      * @dev Transfers `tokenId` from `from` to `to`.
1458      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1459      *
1460      * Requirements:
1461      *
1462      * - `to` cannot be the zero address.
1463      * - `tokenId` token must be owned by `from`.
1464      *
1465      * Emits a {Transfer} event.
1466      */
1467     function _transfer(
1468         address from,
1469         address to,
1470         uint256 tokenId
1471     ) internal virtual {
1472         require(
1473             ERC721.ownerOf(tokenId) == from,
1474             "ERC721: transfer of token that is not own"
1475         );
1476         require(to != address(0), "ERC721: transfer to the zero address");
1477 
1478         _beforeTokenTransfer(from, to, tokenId);
1479 
1480         // Clear approvals from the previous owner
1481         _approve(address(0), tokenId);
1482         _owners[tokenId] = to;
1483 
1484         emit Transfer(from, to, tokenId);
1485     }
1486 
1487     /**
1488      * @dev Approve `to` to operate on `tokenId`
1489      *
1490      * Emits a {Approval} event.
1491      */
1492     function _approve(address to, uint256 tokenId) internal virtual {
1493         _tokenApprovals[tokenId] = to;
1494         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1495     }
1496 
1497     /**
1498      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1499      * The call is not executed if the target address is not a contract.
1500      *
1501      * @param from address representing the previous owner of the given token ID
1502      * @param to target address that will receive the tokens
1503      * @param tokenId uint256 ID of the token to be transferred
1504      * @param _data bytes optional data to send along with the call
1505      * @return bool whether the call correctly returned the expected magic value
1506      */
1507     function _checkOnERC721Received(
1508         address from,
1509         address to,
1510         uint256 tokenId,
1511         bytes memory _data
1512     ) private returns (bool) {
1513         if (to.isContract()) {
1514             try
1515                 IERC721Receiver(to).onERC721Received(
1516                     _msgSender(),
1517                     from,
1518                     tokenId,
1519                     _data
1520                 )
1521             returns (bytes4 retval) {
1522                 return retval == IERC721Receiver.onERC721Received.selector;
1523             } catch (bytes memory reason) {
1524                 if (reason.length == 0) {
1525                     revert(
1526                         "ERC721: transfer to non ERC721Receiver implementer"
1527                     );
1528                 } else {
1529                     assembly {
1530                         revert(add(32, reason), mload(reason))
1531                     }
1532                 }
1533             }
1534         } else {
1535             return true;
1536         }
1537     }
1538 
1539     /**
1540      * @dev Hook that is called before any token transfer. This includes minting
1541      * and burning.
1542      *
1543      * Calling conditions:
1544      *
1545      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1546      * transferred to `to`.
1547      * - When `from` is zero, `tokenId` will be minted for `to`.
1548      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1549      * - `from` and `to` are never both zero.
1550      *
1551      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1552      */
1553     function _beforeTokenTransfer(
1554         address from,
1555         address to,
1556         uint256 tokenId
1557     ) internal virtual {}
1558 }
1559 // File: contracts/ERC721Enumerable.sol
1560 
1561 
1562 
1563 pragma solidity ^0.8.7;
1564 
1565 
1566 
1567 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1568     /**
1569      * @dev See {IERC165-supportsInterface}.
1570      */
1571     function supportsInterface(bytes4 interfaceId)
1572         public
1573         view
1574         virtual
1575         override(IERC165, ERC721)
1576         returns (bool)
1577     {
1578         return
1579             interfaceId == type(IERC721Enumerable).interfaceId ||
1580             super.supportsInterface(interfaceId);
1581     }
1582 
1583     /**
1584      * @dev See {IERC721Enumerable-totalSupply}.
1585      */
1586     function totalSupply() public view virtual override returns (uint256) {
1587         return _owners.length - 1;
1588     }
1589 
1590     /**
1591      * @dev See {IERC721Enumerable-tokenByIndex}.
1592      */
1593     function tokenByIndex(uint256 index)
1594         public
1595         view
1596         virtual
1597         override
1598         returns (uint256)
1599     {
1600         require(
1601             index < _owners.length,
1602             "ERC721Enumerable: global index out of bounds"
1603         );
1604         return index;
1605     }
1606 
1607     /**
1608      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1609      */
1610     function tokenOfOwnerByIndex(address owner, uint256 index)
1611         public
1612         view
1613         virtual
1614         override
1615         returns (uint256 tokenId)
1616     {
1617         require(
1618             index < balanceOf(owner),
1619             "ERC721Enumerable: owner index out of bounds"
1620         );
1621 
1622         uint256 count;
1623         for (uint256 i; i < _owners.length; i++) {
1624             if (owner == _owners[i]) {
1625                 if (count == index) return i;
1626                 else count++;
1627             }
1628         }
1629 
1630         revert("ERC721Enumerable: owner index out of bounds");
1631     }
1632 }
1633 // File: BoredSkulls.sol
1634 
1635 
1636 pragma solidity ^0.8.7;
1637 
1638 
1639 
1640 
1641 
1642 
1643 contract BoredSkullsYachtClub is ERC721Enumerable, OpenSea, Ownable, PaymentSplitter {
1644     using Strings for uint256;
1645 
1646     string private _baseTokenURI;
1647     string private _tokenURISuffix;
1648 
1649     uint256 public price = 15000000000000000; // 0.015 ETH
1650     uint256 public constant MAX_SUPPLY = 2666;
1651     uint256 public maxPerTx = 10;
1652 
1653     bool public started = false;
1654 
1655     constructor(
1656         address openSeaProxyRegistry,
1657         address[] memory _payees,
1658         uint256[] memory _shares
1659     ) ERC721("Bored Skulls Yacht Club", "BSYC") PaymentSplitter(_payees, _shares) {
1660         if (openSeaProxyRegistry != address(0)) {
1661             _setOpenSeaRegistry(openSeaProxyRegistry);
1662         }
1663     }
1664 
1665     function mint(uint256 count) public payable {
1666         require(started, "Minting not started");
1667         require(count <= maxPerTx, "Exceed max per transaction");
1668         uint256 supply = _owners.length;
1669         require(supply + count < MAX_SUPPLY, "Max supply reached");
1670         if (supply < 2001 && supply + count > 2001) {
1671             uint256 payCount = supply + count - 2001;
1672             require(payCount * price == msg.value, "Invalid funds provided.");
1673         } else if (supply >= 2001) {
1674             require(count * price == msg.value, "Invalid funds provided.");
1675         }
1676         for (uint256 i; i < count; i++) {
1677             _safeMint(msg.sender, supply++);
1678         }
1679     }
1680 
1681     function tokenURI(uint256 tokenId)
1682         external
1683         view
1684         virtual
1685         override
1686         returns (string memory)
1687     {
1688         require(
1689             _exists(tokenId),
1690             "ERC721Metadata: URI query for nonexistent token"
1691         );
1692         return
1693             string(
1694                 abi.encodePacked(
1695                     _baseTokenURI,
1696                     tokenId.toString(),
1697                     _tokenURISuffix
1698                 )
1699             );
1700     }
1701 
1702     function setBaseURI(string calldata _newBaseURI, string calldata _newSuffix)
1703         external
1704         onlyOwner
1705     {
1706         _baseTokenURI = _newBaseURI;
1707         _tokenURISuffix = _newSuffix;
1708     }
1709 
1710     function toggleStarted() external onlyOwner {
1711         started = !started;
1712     }
1713 
1714     function airdrop(uint256[] calldata quantity, address[] calldata recipient)
1715         external
1716         onlyOwner
1717     {
1718         require(
1719             quantity.length == recipient.length,
1720             "Quantity length is not equal to recipients"
1721         );
1722 
1723         uint256 totalQuantity = 0;
1724         for (uint256 i = 0; i < quantity.length; ++i) {
1725             totalQuantity += quantity[i];
1726         }
1727 
1728         uint256 supply = _owners.length;
1729         require(supply + totalQuantity <= MAX_SUPPLY, "Max supply reached");
1730 
1731         delete totalQuantity;
1732 
1733         for (uint256 i = 0; i < recipient.length; ++i) {
1734             for (uint256 j = 0; j < quantity[i]; ++j) {
1735                 _safeMint(recipient[i], supply++);
1736             }
1737         }
1738     }
1739 
1740     function isApprovedForAll(address owner, address operator)
1741         public
1742         view
1743         override
1744         returns (bool)
1745     {
1746         return
1747             super.isApprovedForAll(owner, operator) ||
1748             isOwnersOpenSeaProxy(owner, operator);
1749     }
1750 }