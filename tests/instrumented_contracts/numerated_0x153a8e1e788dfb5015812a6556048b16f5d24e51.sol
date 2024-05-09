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
156 // File: @openzeppelin/contracts/utils/Context.sol
157 
158 
159 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
160 
161 pragma solidity ^0.8.0;
162 
163 /**
164  * @dev Provides information about the current execution context, including the
165  * sender of the transaction and its data. While these are generally available
166  * via msg.sender and msg.data, they should not be accessed in such a direct
167  * manner, since when dealing with meta-transactions the account sending and
168  * paying for execution may not be the actual sender (as far as an application
169  * is concerned).
170  *
171  * This contract is only required for intermediate, library-like contracts.
172  */
173 abstract contract Context {
174     function _msgSender() internal view virtual returns (address) {
175         return msg.sender;
176     }
177 
178     function _msgData() internal view virtual returns (bytes calldata) {
179         return msg.data;
180     }
181 }
182 
183 // File: @openzeppelin/contracts/access/Ownable.sol
184 
185 
186 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
187 
188 pragma solidity ^0.8.0;
189 
190 
191 /**
192  * @dev Contract module which provides a basic access control mechanism, where
193  * there is an account (an owner) that can be granted exclusive access to
194  * specific functions.
195  *
196  * By default, the owner account will be the one that deploys the contract. This
197  * can later be changed with {transferOwnership}.
198  *
199  * This module is used through inheritance. It will make available the modifier
200  * `onlyOwner`, which can be applied to your functions to restrict their use to
201  * the owner.
202  */
203 abstract contract Ownable is Context {
204     address private _owner;
205 
206     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
207 
208     /**
209      * @dev Initializes the contract setting the deployer as the initial owner.
210      */
211     constructor() {
212         _transferOwnership(_msgSender());
213     }
214 
215     /**
216      * @dev Returns the address of the current owner.
217      */
218     function owner() public view virtual returns (address) {
219         return _owner;
220     }
221 
222     /**
223      * @dev Throws if called by any account other than the owner.
224      */
225     modifier onlyOwner() {
226         require(owner() == _msgSender(), "Ownable: caller is not the owner");
227         _;
228     }
229 
230     /**
231      * @dev Leaves the contract without owner. It will not be possible to call
232      * `onlyOwner` functions anymore. Can only be called by the current owner.
233      *
234      * NOTE: Renouncing ownership will leave the contract without an owner,
235      * thereby removing any functionality that is only available to the owner.
236      */
237     function renounceOwnership() public virtual onlyOwner {
238         _transferOwnership(address(0));
239     }
240 
241     /**
242      * @dev Transfers ownership of the contract to a new account (`newOwner`).
243      * Can only be called by the current owner.
244      */
245     function transferOwnership(address newOwner) public virtual onlyOwner {
246         require(newOwner != address(0), "Ownable: new owner is the zero address");
247         _transferOwnership(newOwner);
248     }
249 
250     /**
251      * @dev Transfers ownership of the contract to a new account (`newOwner`).
252      * Internal function without access restriction.
253      */
254     function _transferOwnership(address newOwner) internal virtual {
255         address oldOwner = _owner;
256         _owner = newOwner;
257         emit OwnershipTransferred(oldOwner, newOwner);
258     }
259 }
260 
261 // File: @openzeppelin/contracts/utils/Address.sol
262 
263 
264 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
265 
266 pragma solidity ^0.8.0;
267 
268 /**
269  * @dev Collection of functions related to the address type
270  */
271 library Address {
272     /**
273      * @dev Returns true if `account` is a contract.
274      *
275      * [IMPORTANT]
276      * ====
277      * It is unsafe to assume that an address for which this function returns
278      * false is an externally-owned account (EOA) and not a contract.
279      *
280      * Among others, `isContract` will return false for the following
281      * types of addresses:
282      *
283      *  - an externally-owned account
284      *  - a contract in construction
285      *  - an address where a contract will be created
286      *  - an address where a contract lived, but was destroyed
287      * ====
288      */
289     function isContract(address account) internal view returns (bool) {
290         // This method relies on extcodesize, which returns 0 for contracts in
291         // construction, since the code is only stored at the end of the
292         // constructor execution.
293 
294         uint256 size;
295         assembly {
296             size := extcodesize(account)
297         }
298         return size > 0;
299     }
300 
301     /**
302      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
303      * `recipient`, forwarding all available gas and reverting on errors.
304      *
305      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
306      * of certain opcodes, possibly making contracts go over the 2300 gas limit
307      * imposed by `transfer`, making them unable to receive funds via
308      * `transfer`. {sendValue} removes this limitation.
309      *
310      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
311      *
312      * IMPORTANT: because control is transferred to `recipient`, care must be
313      * taken to not create reentrancy vulnerabilities. Consider using
314      * {ReentrancyGuard} or the
315      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
316      */
317     function sendValue(address payable recipient, uint256 amount) internal {
318         require(address(this).balance >= amount, "Address: insufficient balance");
319 
320         (bool success, ) = recipient.call{value: amount}("");
321         require(success, "Address: unable to send value, recipient may have reverted");
322     }
323 
324     /**
325      * @dev Performs a Solidity function call using a low level `call`. A
326      * plain `call` is an unsafe replacement for a function call: use this
327      * function instead.
328      *
329      * If `target` reverts with a revert reason, it is bubbled up by this
330      * function (like regular Solidity function calls).
331      *
332      * Returns the raw returned data. To convert to the expected return value,
333      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
334      *
335      * Requirements:
336      *
337      * - `target` must be a contract.
338      * - calling `target` with `data` must not revert.
339      *
340      * _Available since v3.1._
341      */
342     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
343         return functionCall(target, data, "Address: low-level call failed");
344     }
345 
346     /**
347      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
348      * `errorMessage` as a fallback revert reason when `target` reverts.
349      *
350      * _Available since v3.1._
351      */
352     function functionCall(
353         address target,
354         bytes memory data,
355         string memory errorMessage
356     ) internal returns (bytes memory) {
357         return functionCallWithValue(target, data, 0, errorMessage);
358     }
359 
360     /**
361      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
362      * but also transferring `value` wei to `target`.
363      *
364      * Requirements:
365      *
366      * - the calling contract must have an ETH balance of at least `value`.
367      * - the called Solidity function must be `payable`.
368      *
369      * _Available since v3.1._
370      */
371     function functionCallWithValue(
372         address target,
373         bytes memory data,
374         uint256 value
375     ) internal returns (bytes memory) {
376         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
377     }
378 
379     /**
380      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
381      * with `errorMessage` as a fallback revert reason when `target` reverts.
382      *
383      * _Available since v3.1._
384      */
385     function functionCallWithValue(
386         address target,
387         bytes memory data,
388         uint256 value,
389         string memory errorMessage
390     ) internal returns (bytes memory) {
391         require(address(this).balance >= value, "Address: insufficient balance for call");
392         require(isContract(target), "Address: call to non-contract");
393 
394         (bool success, bytes memory returndata) = target.call{value: value}(data);
395         return verifyCallResult(success, returndata, errorMessage);
396     }
397 
398     /**
399      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
400      * but performing a static call.
401      *
402      * _Available since v3.3._
403      */
404     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
405         return functionStaticCall(target, data, "Address: low-level static call failed");
406     }
407 
408     /**
409      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
410      * but performing a static call.
411      *
412      * _Available since v3.3._
413      */
414     function functionStaticCall(
415         address target,
416         bytes memory data,
417         string memory errorMessage
418     ) internal view returns (bytes memory) {
419         require(isContract(target), "Address: static call to non-contract");
420 
421         (bool success, bytes memory returndata) = target.staticcall(data);
422         return verifyCallResult(success, returndata, errorMessage);
423     }
424 
425     /**
426      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
427      * but performing a delegate call.
428      *
429      * _Available since v3.4._
430      */
431     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
432         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
433     }
434 
435     /**
436      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
437      * but performing a delegate call.
438      *
439      * _Available since v3.4._
440      */
441     function functionDelegateCall(
442         address target,
443         bytes memory data,
444         string memory errorMessage
445     ) internal returns (bytes memory) {
446         require(isContract(target), "Address: delegate call to non-contract");
447 
448         (bool success, bytes memory returndata) = target.delegatecall(data);
449         return verifyCallResult(success, returndata, errorMessage);
450     }
451 
452     /**
453      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
454      * revert reason using the provided one.
455      *
456      * _Available since v4.3._
457      */
458     function verifyCallResult(
459         bool success,
460         bytes memory returndata,
461         string memory errorMessage
462     ) internal pure returns (bytes memory) {
463         if (success) {
464             return returndata;
465         } else {
466             // Look for revert reason and bubble it up if present
467             if (returndata.length > 0) {
468                 // The easiest way to bubble the revert reason is using memory via assembly
469 
470                 assembly {
471                     let returndata_size := mload(returndata)
472                     revert(add(32, returndata), returndata_size)
473                 }
474             } else {
475                 revert(errorMessage);
476             }
477         }
478     }
479 }
480 
481 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
482 
483 
484 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
485 
486 pragma solidity ^0.8.0;
487 
488 
489 
490 /**
491  * @title SafeERC20
492  * @dev Wrappers around ERC20 operations that throw on failure (when the token
493  * contract returns false). Tokens that return no value (and instead revert or
494  * throw on failure) are also supported, non-reverting calls are assumed to be
495  * successful.
496  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
497  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
498  */
499 library SafeERC20 {
500     using Address for address;
501 
502     function safeTransfer(
503         IERC20 token,
504         address to,
505         uint256 value
506     ) internal {
507         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
508     }
509 
510     function safeTransferFrom(
511         IERC20 token,
512         address from,
513         address to,
514         uint256 value
515     ) internal {
516         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
517     }
518 
519     /**
520      * @dev Deprecated. This function has issues similar to the ones found in
521      * {IERC20-approve}, and its usage is discouraged.
522      *
523      * Whenever possible, use {safeIncreaseAllowance} and
524      * {safeDecreaseAllowance} instead.
525      */
526     function safeApprove(
527         IERC20 token,
528         address spender,
529         uint256 value
530     ) internal {
531         // safeApprove should only be called when setting an initial allowance,
532         // or when resetting it to zero. To increase and decrease it, use
533         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
534         require(
535             (value == 0) || (token.allowance(address(this), spender) == 0),
536             "SafeERC20: approve from non-zero to non-zero allowance"
537         );
538         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
539     }
540 
541     function safeIncreaseAllowance(
542         IERC20 token,
543         address spender,
544         uint256 value
545     ) internal {
546         uint256 newAllowance = token.allowance(address(this), spender) + value;
547         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
548     }
549 
550     function safeDecreaseAllowance(
551         IERC20 token,
552         address spender,
553         uint256 value
554     ) internal {
555         unchecked {
556             uint256 oldAllowance = token.allowance(address(this), spender);
557             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
558             uint256 newAllowance = oldAllowance - value;
559             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
560         }
561     }
562 
563     /**
564      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
565      * on the return value: the return value is optional (but if data is returned, it must not be false).
566      * @param token The token targeted by the call.
567      * @param data The call data (encoded using abi.encode or one of its variants).
568      */
569     function _callOptionalReturn(IERC20 token, bytes memory data) private {
570         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
571         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
572         // the target address contains contract code and also asserts for success in the low-level call.
573 
574         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
575         if (returndata.length > 0) {
576             // Return data is optional
577             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
578         }
579     }
580 }
581 
582 // File: @openzeppelin/contracts/finance/PaymentSplitter.sol
583 
584 
585 // OpenZeppelin Contracts v4.4.1 (finance/PaymentSplitter.sol)
586 
587 pragma solidity ^0.8.0;
588 
589 
590 
591 
592 /**
593  * @title PaymentSplitter
594  * @dev This contract allows to split Ether payments among a group of accounts. The sender does not need to be aware
595  * that the Ether will be split in this way, since it is handled transparently by the contract.
596  *
597  * The split can be in equal parts or in any other arbitrary proportion. The way this is specified is by assigning each
598  * account to a number of shares. Of all the Ether that this contract receives, each account will then be able to claim
599  * an amount proportional to the percentage of total shares they were assigned.
600  *
601  * `PaymentSplitter` follows a _pull payment_ model. This means that payments are not automatically forwarded to the
602  * accounts but kept in this contract, and the actual transfer is triggered as a separate step by calling the {release}
603  * function.
604  *
605  * NOTE: This contract assumes that ERC20 tokens will behave similarly to native tokens (Ether). Rebasing tokens, and
606  * tokens that apply fees during transfers, are likely to not be supported as expected. If in doubt, we encourage you
607  * to run tests before sending real value to this contract.
608  */
609 contract PaymentSplitter is Context {
610     event PayeeAdded(address account, uint256 shares);
611     event PaymentReleased(address to, uint256 amount);
612     event ERC20PaymentReleased(IERC20 indexed token, address to, uint256 amount);
613     event PaymentReceived(address from, uint256 amount);
614 
615     uint256 private _totalShares;
616     uint256 private _totalReleased;
617 
618     mapping(address => uint256) private _shares;
619     mapping(address => uint256) private _released;
620     address[] private _payees;
621 
622     mapping(IERC20 => uint256) private _erc20TotalReleased;
623     mapping(IERC20 => mapping(address => uint256)) private _erc20Released;
624 
625     /**
626      * @dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at
627      * the matching position in the `shares` array.
628      *
629      * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no
630      * duplicates in `payees`.
631      */
632     constructor(address[] memory payees, uint256[] memory shares_) payable {
633         require(payees.length == shares_.length, "PaymentSplitter: payees and shares length mismatch");
634         require(payees.length > 0, "PaymentSplitter: no payees");
635 
636         for (uint256 i = 0; i < payees.length; i++) {
637             _addPayee(payees[i], shares_[i]);
638         }
639     }
640 
641     /**
642      * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully
643      * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
644      * reliability of the events, and not the actual splitting of Ether.
645      *
646      * To learn more about this see the Solidity documentation for
647      * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
648      * functions].
649      */
650     receive() external payable virtual {
651         emit PaymentReceived(_msgSender(), msg.value);
652     }
653 
654     /**
655      * @dev Getter for the total shares held by payees.
656      */
657     function totalShares() public view returns (uint256) {
658         return _totalShares;
659     }
660 
661     /**
662      * @dev Getter for the total amount of Ether already released.
663      */
664     function totalReleased() public view returns (uint256) {
665         return _totalReleased;
666     }
667 
668     /**
669      * @dev Getter for the total amount of `token` already released. `token` should be the address of an IERC20
670      * contract.
671      */
672     function totalReleased(IERC20 token) public view returns (uint256) {
673         return _erc20TotalReleased[token];
674     }
675 
676     /**
677      * @dev Getter for the amount of shares held by an account.
678      */
679     function shares(address account) public view returns (uint256) {
680         return _shares[account];
681     }
682 
683     /**
684      * @dev Getter for the amount of Ether already released to a payee.
685      */
686     function released(address account) public view returns (uint256) {
687         return _released[account];
688     }
689 
690     /**
691      * @dev Getter for the amount of `token` tokens already released to a payee. `token` should be the address of an
692      * IERC20 contract.
693      */
694     function released(IERC20 token, address account) public view returns (uint256) {
695         return _erc20Released[token][account];
696     }
697 
698     /**
699      * @dev Getter for the address of the payee number `index`.
700      */
701     function payee(uint256 index) public view returns (address) {
702         return _payees[index];
703     }
704 
705     /**
706      * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
707      * total shares and their previous withdrawals.
708      */
709     function release(address payable account) public virtual {
710         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
711 
712         uint256 totalReceived = address(this).balance + totalReleased();
713         uint256 payment = _pendingPayment(account, totalReceived, released(account));
714 
715         require(payment != 0, "PaymentSplitter: account is not due payment");
716 
717         _released[account] += payment;
718         _totalReleased += payment;
719 
720         Address.sendValue(account, payment);
721         emit PaymentReleased(account, payment);
722     }
723 
724     /**
725      * @dev Triggers a transfer to `account` of the amount of `token` tokens they are owed, according to their
726      * percentage of the total shares and their previous withdrawals. `token` must be the address of an IERC20
727      * contract.
728      */
729     function release(IERC20 token, address account) public virtual {
730         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
731 
732         uint256 totalReceived = token.balanceOf(address(this)) + totalReleased(token);
733         uint256 payment = _pendingPayment(account, totalReceived, released(token, account));
734 
735         require(payment != 0, "PaymentSplitter: account is not due payment");
736 
737         _erc20Released[token][account] += payment;
738         _erc20TotalReleased[token] += payment;
739 
740         SafeERC20.safeTransfer(token, account, payment);
741         emit ERC20PaymentReleased(token, account, payment);
742     }
743 
744     /**
745      * @dev internal logic for computing the pending payment of an `account` given the token historical balances and
746      * already released amounts.
747      */
748     function _pendingPayment(
749         address account,
750         uint256 totalReceived,
751         uint256 alreadyReleased
752     ) private view returns (uint256) {
753         return (totalReceived * _shares[account]) / _totalShares - alreadyReleased;
754     }
755 
756     /**
757      * @dev Add a new payee to the contract.
758      * @param account The address of the payee to add.
759      * @param shares_ The number of shares owned by the payee.
760      */
761     function _addPayee(address account, uint256 shares_) private {
762         require(account != address(0), "PaymentSplitter: account is the zero address");
763         require(shares_ > 0, "PaymentSplitter: shares are 0");
764         require(_shares[account] == 0, "PaymentSplitter: account already has shares");
765 
766         _payees.push(account);
767         _shares[account] = shares_;
768         _totalShares = _totalShares + shares_;
769         emit PayeeAdded(account, shares_);
770     }
771 }
772 
773 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
774 
775 
776 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
777 
778 pragma solidity ^0.8.0;
779 
780 /**
781  * @title ERC721 token receiver interface
782  * @dev Interface for any contract that wants to support safeTransfers
783  * from ERC721 asset contracts.
784  */
785 interface IERC721Receiver {
786     /**
787      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
788      * by `operator` from `from`, this function is called.
789      *
790      * It must return its Solidity selector to confirm the token transfer.
791      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
792      *
793      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
794      */
795     function onERC721Received(
796         address operator,
797         address from,
798         uint256 tokenId,
799         bytes calldata data
800     ) external returns (bytes4);
801 }
802 
803 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
804 
805 
806 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
807 
808 pragma solidity ^0.8.0;
809 
810 /**
811  * @dev Interface of the ERC165 standard, as defined in the
812  * https://eips.ethereum.org/EIPS/eip-165[EIP].
813  *
814  * Implementers can declare support of contract interfaces, which can then be
815  * queried by others ({ERC165Checker}).
816  *
817  * For an implementation, see {ERC165}.
818  */
819 interface IERC165 {
820     /**
821      * @dev Returns true if this contract implements the interface defined by
822      * `interfaceId`. See the corresponding
823      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
824      * to learn more about how these ids are created.
825      *
826      * This function call must use less than 30 000 gas.
827      */
828     function supportsInterface(bytes4 interfaceId) external view returns (bool);
829 }
830 
831 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
832 
833 
834 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
835 
836 pragma solidity ^0.8.0;
837 
838 
839 /**
840  * @dev Implementation of the {IERC165} interface.
841  *
842  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
843  * for the additional interface id that will be supported. For example:
844  *
845  * ```solidity
846  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
847  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
848  * }
849  * ```
850  *
851  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
852  */
853 abstract contract ERC165 is IERC165 {
854     /**
855      * @dev See {IERC165-supportsInterface}.
856      */
857     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
858         return interfaceId == type(IERC165).interfaceId;
859     }
860 }
861 
862 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
863 
864 
865 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
866 
867 pragma solidity ^0.8.0;
868 
869 
870 /**
871  * @dev Required interface of an ERC721 compliant contract.
872  */
873 interface IERC721 is IERC165 {
874     /**
875      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
876      */
877     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
878 
879     /**
880      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
881      */
882     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
883 
884     /**
885      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
886      */
887     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
888 
889     /**
890      * @dev Returns the number of tokens in ``owner``'s account.
891      */
892     function balanceOf(address owner) external view returns (uint256 balance);
893 
894     /**
895      * @dev Returns the owner of the `tokenId` token.
896      *
897      * Requirements:
898      *
899      * - `tokenId` must exist.
900      */
901     function ownerOf(uint256 tokenId) external view returns (address owner);
902 
903     /**
904      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
905      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
906      *
907      * Requirements:
908      *
909      * - `from` cannot be the zero address.
910      * - `to` cannot be the zero address.
911      * - `tokenId` token must exist and be owned by `from`.
912      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
913      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
914      *
915      * Emits a {Transfer} event.
916      */
917     function safeTransferFrom(
918         address from,
919         address to,
920         uint256 tokenId
921     ) external;
922 
923     /**
924      * @dev Transfers `tokenId` token from `from` to `to`.
925      *
926      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
927      *
928      * Requirements:
929      *
930      * - `from` cannot be the zero address.
931      * - `to` cannot be the zero address.
932      * - `tokenId` token must be owned by `from`.
933      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
934      *
935      * Emits a {Transfer} event.
936      */
937     function transferFrom(
938         address from,
939         address to,
940         uint256 tokenId
941     ) external;
942 
943     /**
944      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
945      * The approval is cleared when the token is transferred.
946      *
947      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
948      *
949      * Requirements:
950      *
951      * - The caller must own the token or be an approved operator.
952      * - `tokenId` must exist.
953      *
954      * Emits an {Approval} event.
955      */
956     function approve(address to, uint256 tokenId) external;
957 
958     /**
959      * @dev Returns the account approved for `tokenId` token.
960      *
961      * Requirements:
962      *
963      * - `tokenId` must exist.
964      */
965     function getApproved(uint256 tokenId) external view returns (address operator);
966 
967     /**
968      * @dev Approve or remove `operator` as an operator for the caller.
969      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
970      *
971      * Requirements:
972      *
973      * - The `operator` cannot be the caller.
974      *
975      * Emits an {ApprovalForAll} event.
976      */
977     function setApprovalForAll(address operator, bool _approved) external;
978 
979     /**
980      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
981      *
982      * See {setApprovalForAll}
983      */
984     function isApprovedForAll(address owner, address operator) external view returns (bool);
985 
986     /**
987      * @dev Safely transfers `tokenId` token from `from` to `to`.
988      *
989      * Requirements:
990      *
991      * - `from` cannot be the zero address.
992      * - `to` cannot be the zero address.
993      * - `tokenId` token must exist and be owned by `from`.
994      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
995      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
996      *
997      * Emits a {Transfer} event.
998      */
999     function safeTransferFrom(
1000         address from,
1001         address to,
1002         uint256 tokenId,
1003         bytes calldata data
1004     ) external;
1005 }
1006 
1007 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1008 
1009 
1010 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
1011 
1012 pragma solidity ^0.8.0;
1013 
1014 
1015 /**
1016  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1017  * @dev See https://eips.ethereum.org/EIPS/eip-721
1018  */
1019 interface IERC721Enumerable is IERC721 {
1020     /**
1021      * @dev Returns the total amount of tokens stored by the contract.
1022      */
1023     function totalSupply() external view returns (uint256);
1024 
1025     /**
1026      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1027      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1028      */
1029     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1030 
1031     /**
1032      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1033      * Use along with {totalSupply} to enumerate all tokens.
1034      */
1035     function tokenByIndex(uint256 index) external view returns (uint256);
1036 }
1037 
1038 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1039 
1040 
1041 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1042 
1043 pragma solidity ^0.8.0;
1044 
1045 
1046 /**
1047  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1048  * @dev See https://eips.ethereum.org/EIPS/eip-721
1049  */
1050 interface IERC721Metadata is IERC721 {
1051     /**
1052      * @dev Returns the token collection name.
1053      */
1054     function name() external view returns (string memory);
1055 
1056     /**
1057      * @dev Returns the token collection symbol.
1058      */
1059     function symbol() external view returns (string memory);
1060 
1061     /**
1062      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1063      */
1064     function tokenURI(uint256 tokenId) external view returns (string memory);
1065 }
1066 
1067 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/ERC721A.sol
1068 
1069 
1070 // Creator: Chiru Labs
1071 
1072 pragma solidity ^0.8.0;
1073 
1074 
1075 
1076 
1077 
1078 
1079 
1080 
1081 
1082 /**
1083  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1084  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1085  *
1086  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
1087  *
1088  * Does not support burning tokens to address(0).
1089  *
1090  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
1091  */
1092 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1093     using Address for address;
1094     using Strings for uint256;
1095 
1096     struct TokenOwnership {
1097         address addr;
1098         uint64 startTimestamp;
1099     }
1100 
1101     struct AddressData {
1102         uint128 balance;
1103         uint128 numberMinted;
1104     }
1105 
1106     uint256 internal currentIndex;
1107 
1108     // Token name
1109     string private _name;
1110 
1111     // Token symbol
1112     string private _symbol;
1113 
1114     // Mapping from token ID to ownership details
1115     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1116     mapping(uint256 => TokenOwnership) internal _ownerships;
1117 
1118     // Mapping owner address to address data
1119     mapping(address => AddressData) private _addressData;
1120 
1121     // Mapping from token ID to approved address
1122     mapping(uint256 => address) private _tokenApprovals;
1123 
1124     // Mapping from owner to operator approvals
1125     mapping(address => mapping(address => bool)) private _operatorApprovals;
1126 
1127     constructor(string memory name_, string memory symbol_) {
1128         _name = name_;
1129         _symbol = symbol_;
1130     }
1131 
1132     /**
1133      * @dev See {IERC721Enumerable-totalSupply}.
1134      */
1135     function totalSupply() public view override returns (uint256) {
1136         return currentIndex;
1137     }
1138 
1139     /**
1140      * @dev See {IERC721Enumerable-tokenByIndex}.
1141      */
1142     function tokenByIndex(uint256 index) public view override returns (uint256) {
1143         require(index < totalSupply(), 'ERC721A: global index out of bounds');
1144         return index;
1145     }
1146 
1147     /**
1148      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1149      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1150      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1151      */
1152     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1153         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
1154         uint256 numMintedSoFar = totalSupply();
1155         uint256 tokenIdsIdx;
1156         address currOwnershipAddr;
1157 
1158         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
1159         unchecked {
1160             for (uint256 i; i < numMintedSoFar; i++) {
1161                 TokenOwnership memory ownership = _ownerships[i];
1162                 if (ownership.addr != address(0)) {
1163                     currOwnershipAddr = ownership.addr;
1164                 }
1165                 if (currOwnershipAddr == owner) {
1166                     if (tokenIdsIdx == index) {
1167                         return i;
1168                     }
1169                     tokenIdsIdx++;
1170                 }
1171             }
1172         }
1173 
1174         revert('ERC721A: unable to get token of owner by index');
1175     }
1176 
1177     /**
1178      * @dev See {IERC165-supportsInterface}.
1179      */
1180     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1181         return
1182             interfaceId == type(IERC721).interfaceId ||
1183             interfaceId == type(IERC721Metadata).interfaceId ||
1184             interfaceId == type(IERC721Enumerable).interfaceId ||
1185             super.supportsInterface(interfaceId);
1186     }
1187 
1188     /**
1189      * @dev See {IERC721-balanceOf}.
1190      */
1191     function balanceOf(address owner) public view override returns (uint256) {
1192         require(owner != address(0), 'ERC721A: balance query for the zero address');
1193         return uint256(_addressData[owner].balance);
1194     }
1195 
1196     function _numberMinted(address owner) internal view returns (uint256) {
1197         require(owner != address(0), 'ERC721A: number minted query for the zero address');
1198         return uint256(_addressData[owner].numberMinted);
1199     }
1200 
1201     /**
1202      * Gas spent here starts off proportional to the maximum mint batch size.
1203      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1204      */
1205     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1206         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
1207 
1208         unchecked {
1209             for (uint256 curr = tokenId; curr >= 0; curr--) {
1210                 TokenOwnership memory ownership = _ownerships[curr];
1211                 if (ownership.addr != address(0)) {
1212                     return ownership;
1213                 }
1214             }
1215         }
1216 
1217         revert('ERC721A: unable to determine the owner of token');
1218     }
1219 
1220     /**
1221      * @dev See {IERC721-ownerOf}.
1222      */
1223     function ownerOf(uint256 tokenId) public view override returns (address) {
1224         return ownershipOf(tokenId).addr;
1225     }
1226 
1227     /**
1228      * @dev See {IERC721Metadata-name}.
1229      */
1230     function name() public view virtual override returns (string memory) {
1231         return _name;
1232     }
1233 
1234     /**
1235      * @dev See {IERC721Metadata-symbol}.
1236      */
1237     function symbol() public view virtual override returns (string memory) {
1238         return _symbol;
1239     }
1240 
1241     /**
1242      * @dev See {IERC721Metadata-tokenURI}.
1243      */
1244     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1245         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
1246 
1247         string memory baseURI = _baseURI();
1248         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1249     }
1250 
1251     /**
1252      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1253      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1254      * by default, can be overriden in child contracts.
1255      */
1256     function _baseURI() internal view virtual returns (string memory) {
1257         return '';
1258     }
1259 
1260     /**
1261      * @dev See {IERC721-approve}.
1262      */
1263     function approve(address to, uint256 tokenId) public override {
1264         address owner = ERC721A.ownerOf(tokenId);
1265         require(to != owner, 'ERC721A: approval to current owner');
1266 
1267         require(
1268             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1269             'ERC721A: approve caller is not owner nor approved for all'
1270         );
1271 
1272         _approve(to, tokenId, owner);
1273     }
1274 
1275     /**
1276      * @dev See {IERC721-getApproved}.
1277      */
1278     function getApproved(uint256 tokenId) public view override returns (address) {
1279         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
1280 
1281         return _tokenApprovals[tokenId];
1282     }
1283 
1284     /**
1285      * @dev See {IERC721-setApprovalForAll}.
1286      */
1287     function setApprovalForAll(address operator, bool approved) public override {
1288         require(operator != _msgSender(), 'ERC721A: approve to caller');
1289 
1290         _operatorApprovals[_msgSender()][operator] = approved;
1291         emit ApprovalForAll(_msgSender(), operator, approved);
1292     }
1293 
1294     /**
1295      * @dev See {IERC721-isApprovedForAll}.
1296      */
1297     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1298         return _operatorApprovals[owner][operator];
1299     }
1300 
1301     /**
1302      * @dev See {IERC721-transferFrom}.
1303      */
1304     function transferFrom(
1305         address from,
1306         address to,
1307         uint256 tokenId
1308     ) public virtual override {
1309         _transfer(from, to, tokenId);
1310     }
1311 
1312     /**
1313      * @dev See {IERC721-safeTransferFrom}.
1314      */
1315     function safeTransferFrom(
1316         address from,
1317         address to,
1318         uint256 tokenId
1319     ) public virtual override {
1320         safeTransferFrom(from, to, tokenId, '');
1321     }
1322 
1323     /**
1324      * @dev See {IERC721-safeTransferFrom}.
1325      */
1326     function safeTransferFrom(
1327         address from,
1328         address to,
1329         uint256 tokenId,
1330         bytes memory _data
1331     ) public override {
1332         _transfer(from, to, tokenId);
1333         require(
1334             _checkOnERC721Received(from, to, tokenId, _data),
1335             'ERC721A: transfer to non ERC721Receiver implementer'
1336         );
1337     }
1338 
1339     /**
1340      * @dev Returns whether `tokenId` exists.
1341      *
1342      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1343      *
1344      * Tokens start existing when they are minted (`_mint`),
1345      */
1346     function _exists(uint256 tokenId) internal view returns (bool) {
1347         return tokenId < currentIndex;
1348     }
1349 
1350     function _safeMint(address to, uint256 quantity) internal {
1351         _safeMint(to, quantity, '');
1352     }
1353 
1354     /**
1355      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1356      *
1357      * Requirements:
1358      *
1359      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1360      * - `quantity` must be greater than 0.
1361      *
1362      * Emits a {Transfer} event.
1363      */
1364     function _safeMint(
1365         address to,
1366         uint256 quantity,
1367         bytes memory _data
1368     ) internal {
1369         _mint(to, quantity, _data, true);
1370     }
1371 
1372     /**
1373      * @dev Mints `quantity` tokens and transfers them to `to`.
1374      *
1375      * Requirements:
1376      *
1377      * - `to` cannot be the zero address.
1378      * - `quantity` must be greater than 0.
1379      *
1380      * Emits a {Transfer} event.
1381      */
1382     function _mint(
1383         address to,
1384         uint256 quantity,
1385         bytes memory _data,
1386         bool safe
1387     ) internal {
1388         uint256 startTokenId = currentIndex;
1389         require(to != address(0), 'ERC721A: mint to the zero address');
1390         require(quantity != 0, 'ERC721A: quantity must be greater than 0');
1391 
1392         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1393 
1394         // Overflows are incredibly unrealistic.
1395         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1396         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1397         unchecked {
1398             _addressData[to].balance += uint128(quantity);
1399             _addressData[to].numberMinted += uint128(quantity);
1400 
1401             _ownerships[startTokenId].addr = to;
1402             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1403 
1404             uint256 updatedIndex = startTokenId;
1405 
1406             for (uint256 i; i < quantity; i++) {
1407                 emit Transfer(address(0), to, updatedIndex);
1408                 if (safe) {
1409                     require(
1410                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1411                         'ERC721A: transfer to non ERC721Receiver implementer'
1412                     );
1413                 }
1414 
1415                 updatedIndex++;
1416             }
1417 
1418             currentIndex = updatedIndex;
1419         }
1420 
1421         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1422     }
1423 
1424     /**
1425      * @dev Transfers `tokenId` from `from` to `to`.
1426      *
1427      * Requirements:
1428      *
1429      * - `to` cannot be the zero address.
1430      * - `tokenId` token must be owned by `from`.
1431      *
1432      * Emits a {Transfer} event.
1433      */
1434     function _transfer(
1435         address from,
1436         address to,
1437         uint256 tokenId
1438     ) private {
1439         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1440 
1441         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1442             getApproved(tokenId) == _msgSender() ||
1443             isApprovedForAll(prevOwnership.addr, _msgSender()));
1444 
1445         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1446 
1447         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1448         require(to != address(0), 'ERC721A: transfer to the zero address');
1449 
1450         _beforeTokenTransfers(from, to, tokenId, 1);
1451 
1452         // Clear approvals from the previous owner
1453         _approve(address(0), tokenId, prevOwnership.addr);
1454 
1455         // Underflow of the sender's balance is impossible because we check for
1456         // ownership above and the recipient's balance can't realistically overflow.
1457         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1458         unchecked {
1459             _addressData[from].balance -= 1;
1460             _addressData[to].balance += 1;
1461 
1462             _ownerships[tokenId].addr = to;
1463             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1464 
1465             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1466             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1467             uint256 nextTokenId = tokenId + 1;
1468             if (_ownerships[nextTokenId].addr == address(0)) {
1469                 if (_exists(nextTokenId)) {
1470                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1471                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1472                 }
1473             }
1474         }
1475 
1476         emit Transfer(from, to, tokenId);
1477         _afterTokenTransfers(from, to, tokenId, 1);
1478     }
1479 
1480     /**
1481      * @dev Approve `to` to operate on `tokenId`
1482      *
1483      * Emits a {Approval} event.
1484      */
1485     function _approve(
1486         address to,
1487         uint256 tokenId,
1488         address owner
1489     ) private {
1490         _tokenApprovals[tokenId] = to;
1491         emit Approval(owner, to, tokenId);
1492     }
1493 
1494     /**
1495      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1496      * The call is not executed if the target address is not a contract.
1497      *
1498      * @param from address representing the previous owner of the given token ID
1499      * @param to target address that will receive the tokens
1500      * @param tokenId uint256 ID of the token to be transferred
1501      * @param _data bytes optional data to send along with the call
1502      * @return bool whether the call correctly returned the expected magic value
1503      */
1504     function _checkOnERC721Received(
1505         address from,
1506         address to,
1507         uint256 tokenId,
1508         bytes memory _data
1509     ) private returns (bool) {
1510         if (to.isContract()) {
1511             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1512                 return retval == IERC721Receiver(to).onERC721Received.selector;
1513             } catch (bytes memory reason) {
1514                 if (reason.length == 0) {
1515                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1516                 } else {
1517                     assembly {
1518                         revert(add(32, reason), mload(reason))
1519                     }
1520                 }
1521             }
1522         } else {
1523             return true;
1524         }
1525     }
1526 
1527     /**
1528      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1529      *
1530      * startTokenId - the first token id to be transferred
1531      * quantity - the amount to be transferred
1532      *
1533      * Calling conditions:
1534      *
1535      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1536      * transferred to `to`.
1537      * - When `from` is zero, `tokenId` will be minted for `to`.
1538      */
1539     function _beforeTokenTransfers(
1540         address from,
1541         address to,
1542         uint256 startTokenId,
1543         uint256 quantity
1544     ) internal virtual {}
1545 
1546     /**
1547      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1548      * minting.
1549      *
1550      * startTokenId - the first token id to be transferred
1551      * quantity - the amount to be transferred
1552      *
1553      * Calling conditions:
1554      *
1555      * - when `from` and `to` are both non-zero.
1556      * - `from` and `to` are never both zero.
1557      */
1558     function _afterTokenTransfers(
1559         address from,
1560         address to,
1561         uint256 startTokenId,
1562         uint256 quantity
1563     ) internal virtual {}
1564 }
1565 
1566 // File: pixxo.sol
1567 
1568 //SPDX-License-Identifier: Unlicense
1569 pragma solidity ^0.8.0;
1570 
1571 
1572 
1573 
1574 
1575 contract Pixxo is ERC721A, PaymentSplitter, Ownable {
1576   using Strings for uint256;
1577   bool public saleIsActive = false;
1578   uint public pixxoPrice = 0.004 ether;
1579   uint public constant MAX_MINTS_PER_TX = 10;
1580   uint public constant MAX_MINT = 4439;
1581   uint public constant MAX_RESERVE_MINT = 5;
1582   string public ipfsBase = "ipfs://Qmc75xe6pzcvq1DDdAmdVtWup3R9Bx4F1N9wBR7Hgo7CXZ/";
1583   uint256[] private _ones = [1, 1, 1, 1, 1];
1584 
1585   constructor(address[] memory payees) ERC721A("Pixxo", "Pixxo") PaymentSplitter(payees, _ones) {
1586     require(payees.length == 5, "Need to split among 5.");
1587   }
1588 
1589   function claimReserve() public onlyOwner {
1590     require(totalSupply() == MAX_MINT, "Must wait until mint is over.");
1591     _safeMint(msg.sender, MAX_RESERVE_MINT);
1592   }
1593 
1594   function _baseURI() override internal view virtual returns (string memory) {
1595     return ipfsBase;
1596   }
1597 
1598   function setBaseURI(string memory uri) public onlyOwner {
1599     ipfsBase = uri;
1600   }
1601 
1602   function flipSaleState() public onlyOwner {
1603     saleIsActive = !saleIsActive;
1604   }
1605 
1606   function setPrice(uint256 _price) public onlyOwner{
1607     pixxoPrice = _price;
1608   }
1609 
1610   function mint(uint n) public payable {
1611     require(saleIsActive, "Sale must be active.");
1612     require(n > 0, "Must be positive.");
1613     require(n <= MAX_MINTS_PER_TX, "Exceeds max per transaction.");
1614     require(totalSupply() + n <= (MAX_MINT), "Purchase exceeds max supply.");
1615     require((n * pixxoPrice) <= msg.value, "Invalid Ether Amount.");
1616 
1617     _safeMint(msg.sender, n);
1618   }
1619 
1620   function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1621     require(_exists(_tokenId), "URI query for nonexistent token.");
1622     return string(abi.encodePacked(_baseURI(), _tokenId.toString(), ".json"));
1623   }
1624 }