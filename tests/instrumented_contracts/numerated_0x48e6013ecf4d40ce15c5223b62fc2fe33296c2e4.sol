1 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.4/contracts/token/ERC20/IERC20.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
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
86 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.4/contracts/utils/Strings.sol
87 
88 
89 // OpenZeppelin Contracts v4.4.0 (utils/Strings.sol)
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
156 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.4/contracts/utils/Context.sol
157 
158 
159 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
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
183 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.4/contracts/access/Ownable.sol
184 
185 
186 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
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
261 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.4/contracts/utils/Address.sol
262 
263 
264 // OpenZeppelin Contracts v4.4.0 (utils/Address.sol)
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
481 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.4/contracts/token/ERC20/utils/SafeERC20.sol
482 
483 
484 // OpenZeppelin Contracts v4.4.0 (token/ERC20/utils/SafeERC20.sol)
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
582 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.4/contracts/finance/PaymentSplitter.sol
583 
584 
585 // OpenZeppelin Contracts v4.4.0 (finance/PaymentSplitter.sol)
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
773 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.4/contracts/token/ERC721/IERC721Receiver.sol
774 
775 
776 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721Receiver.sol)
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
803 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.4/contracts/utils/introspection/IERC165.sol
804 
805 
806 // OpenZeppelin Contracts v4.4.0 (utils/introspection/IERC165.sol)
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
831 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.4/contracts/utils/introspection/ERC165.sol
832 
833 
834 // OpenZeppelin Contracts v4.4.0 (utils/introspection/ERC165.sol)
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
862 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.4/contracts/token/ERC721/IERC721.sol
863 
864 
865 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721.sol)
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
1007 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.4/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1008 
1009 
1010 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/IERC721Enumerable.sol)
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
1038 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.4/contracts/token/ERC721/extensions/IERC721Metadata.sol
1039 
1040 
1041 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/IERC721Metadata.sol)
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
1067 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.4/contracts/token/ERC721/ERC721.sol
1068 
1069 
1070 // OpenZeppelin Contracts v4.4.0 (token/ERC721/ERC721.sol)
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
1081 /**
1082  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1083  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1084  * {ERC721Enumerable}.
1085  */
1086 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1087     using Address for address;
1088     using Strings for uint256;
1089 
1090     // Token name
1091     string private _name;
1092 
1093     // Token symbol
1094     string private _symbol;
1095 
1096     // Mapping from token ID to owner address
1097     mapping(uint256 => address) private _owners;
1098 
1099     // Mapping owner address to token count
1100     mapping(address => uint256) private _balances;
1101 
1102     // Mapping from token ID to approved address
1103     mapping(uint256 => address) private _tokenApprovals;
1104 
1105     // Mapping from owner to operator approvals
1106     mapping(address => mapping(address => bool)) private _operatorApprovals;
1107 
1108     /**
1109      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1110      */
1111     constructor(string memory name_, string memory symbol_) {
1112         _name = name_;
1113         _symbol = symbol_;
1114     }
1115 
1116     /**
1117      * @dev See {IERC165-supportsInterface}.
1118      */
1119     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1120         return
1121             interfaceId == type(IERC721).interfaceId ||
1122             interfaceId == type(IERC721Metadata).interfaceId ||
1123             super.supportsInterface(interfaceId);
1124     }
1125 
1126     /**
1127      * @dev See {IERC721-balanceOf}.
1128      */
1129     function balanceOf(address owner) public view virtual override returns (uint256) {
1130         require(owner != address(0), "ERC721: balance query for the zero address");
1131         return _balances[owner];
1132     }
1133 
1134     /**
1135      * @dev See {IERC721-ownerOf}.
1136      */
1137     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1138         address owner = _owners[tokenId];
1139         require(owner != address(0), "ERC721: owner query for nonexistent token");
1140         return owner;
1141     }
1142 
1143     /**
1144      * @dev See {IERC721Metadata-name}.
1145      */
1146     function name() public view virtual override returns (string memory) {
1147         return _name;
1148     }
1149 
1150     /**
1151      * @dev See {IERC721Metadata-symbol}.
1152      */
1153     function symbol() public view virtual override returns (string memory) {
1154         return _symbol;
1155     }
1156 
1157     /**
1158      * @dev See {IERC721Metadata-tokenURI}.
1159      */
1160     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1161         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1162 
1163         string memory baseURI = _baseURI();
1164         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1165     }
1166 
1167     /**
1168      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1169      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1170      * by default, can be overriden in child contracts.
1171      */
1172     function _baseURI() internal view virtual returns (string memory) {
1173         return "";
1174     }
1175 
1176     /**
1177      * @dev See {IERC721-approve}.
1178      */
1179     function approve(address to, uint256 tokenId) public virtual override {
1180         address owner = ERC721.ownerOf(tokenId);
1181         require(to != owner, "ERC721: approval to current owner");
1182 
1183         require(
1184             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1185             "ERC721: approve caller is not owner nor approved for all"
1186         );
1187 
1188         _approve(to, tokenId);
1189     }
1190 
1191     /**
1192      * @dev See {IERC721-getApproved}.
1193      */
1194     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1195         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1196 
1197         return _tokenApprovals[tokenId];
1198     }
1199 
1200     /**
1201      * @dev See {IERC721-setApprovalForAll}.
1202      */
1203     function setApprovalForAll(address operator, bool approved) public virtual override {
1204         _setApprovalForAll(_msgSender(), operator, approved);
1205     }
1206 
1207     /**
1208      * @dev See {IERC721-isApprovedForAll}.
1209      */
1210     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1211         return _operatorApprovals[owner][operator];
1212     }
1213 
1214     /**
1215      * @dev See {IERC721-transferFrom}.
1216      */
1217     function transferFrom(
1218         address from,
1219         address to,
1220         uint256 tokenId
1221     ) public virtual override {
1222         //solhint-disable-next-line max-line-length
1223         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1224 
1225         _transfer(from, to, tokenId);
1226     }
1227 
1228     /**
1229      * @dev See {IERC721-safeTransferFrom}.
1230      */
1231     function safeTransferFrom(
1232         address from,
1233         address to,
1234         uint256 tokenId
1235     ) public virtual override {
1236         safeTransferFrom(from, to, tokenId, "");
1237     }
1238 
1239     /**
1240      * @dev See {IERC721-safeTransferFrom}.
1241      */
1242     function safeTransferFrom(
1243         address from,
1244         address to,
1245         uint256 tokenId,
1246         bytes memory _data
1247     ) public virtual override {
1248         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1249         _safeTransfer(from, to, tokenId, _data);
1250     }
1251 
1252     /**
1253      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1254      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1255      *
1256      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1257      *
1258      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1259      * implement alternative mechanisms to perform token transfer, such as signature-based.
1260      *
1261      * Requirements:
1262      *
1263      * - `from` cannot be the zero address.
1264      * - `to` cannot be the zero address.
1265      * - `tokenId` token must exist and be owned by `from`.
1266      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1267      *
1268      * Emits a {Transfer} event.
1269      */
1270     function _safeTransfer(
1271         address from,
1272         address to,
1273         uint256 tokenId,
1274         bytes memory _data
1275     ) internal virtual {
1276         _transfer(from, to, tokenId);
1277         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1278     }
1279 
1280     /**
1281      * @dev Returns whether `tokenId` exists.
1282      *
1283      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1284      *
1285      * Tokens start existing when they are minted (`_mint`),
1286      * and stop existing when they are burned (`_burn`).
1287      */
1288     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1289         return _owners[tokenId] != address(0);
1290     }
1291 
1292     /**
1293      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1294      *
1295      * Requirements:
1296      *
1297      * - `tokenId` must exist.
1298      */
1299     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1300         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1301         address owner = ERC721.ownerOf(tokenId);
1302         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1303     }
1304 
1305     /**
1306      * @dev Safely mints `tokenId` and transfers it to `to`.
1307      *
1308      * Requirements:
1309      *
1310      * - `tokenId` must not exist.
1311      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1312      *
1313      * Emits a {Transfer} event.
1314      */
1315     function _safeMint(address to, uint256 tokenId) internal virtual {
1316         _safeMint(to, tokenId, "");
1317     }
1318 
1319     /**
1320      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1321      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1322      */
1323     function _safeMint(
1324         address to,
1325         uint256 tokenId,
1326         bytes memory _data
1327     ) internal virtual {
1328         _mint(to, tokenId);
1329         require(
1330             _checkOnERC721Received(address(0), to, tokenId, _data),
1331             "ERC721: transfer to non ERC721Receiver implementer"
1332         );
1333     }
1334 
1335     /**
1336      * @dev Mints `tokenId` and transfers it to `to`.
1337      *
1338      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1339      *
1340      * Requirements:
1341      *
1342      * - `tokenId` must not exist.
1343      * - `to` cannot be the zero address.
1344      *
1345      * Emits a {Transfer} event.
1346      */
1347     function _mint(address to, uint256 tokenId) internal virtual {
1348         require(to != address(0), "ERC721: mint to the zero address");
1349         require(!_exists(tokenId), "ERC721: token already minted");
1350 
1351         _beforeTokenTransfer(address(0), to, tokenId);
1352 
1353         _balances[to] += 1;
1354         _owners[tokenId] = to;
1355 
1356         emit Transfer(address(0), to, tokenId);
1357     }
1358 
1359     /**
1360      * @dev Destroys `tokenId`.
1361      * The approval is cleared when the token is burned.
1362      *
1363      * Requirements:
1364      *
1365      * - `tokenId` must exist.
1366      *
1367      * Emits a {Transfer} event.
1368      */
1369     function _burn(uint256 tokenId) internal virtual {
1370         address owner = ERC721.ownerOf(tokenId);
1371 
1372         _beforeTokenTransfer(owner, address(0), tokenId);
1373 
1374         // Clear approvals
1375         _approve(address(0), tokenId);
1376 
1377         _balances[owner] -= 1;
1378         delete _owners[tokenId];
1379 
1380         emit Transfer(owner, address(0), tokenId);
1381     }
1382 
1383     /**
1384      * @dev Transfers `tokenId` from `from` to `to`.
1385      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1386      *
1387      * Requirements:
1388      *
1389      * - `to` cannot be the zero address.
1390      * - `tokenId` token must be owned by `from`.
1391      *
1392      * Emits a {Transfer} event.
1393      */
1394     function _transfer(
1395         address from,
1396         address to,
1397         uint256 tokenId
1398     ) internal virtual {
1399         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1400         require(to != address(0), "ERC721: transfer to the zero address");
1401 
1402         _beforeTokenTransfer(from, to, tokenId);
1403 
1404         // Clear approvals from the previous owner
1405         _approve(address(0), tokenId);
1406 
1407         _balances[from] -= 1;
1408         _balances[to] += 1;
1409         _owners[tokenId] = to;
1410 
1411         emit Transfer(from, to, tokenId);
1412     }
1413 
1414     /**
1415      * @dev Approve `to` to operate on `tokenId`
1416      *
1417      * Emits a {Approval} event.
1418      */
1419     function _approve(address to, uint256 tokenId) internal virtual {
1420         _tokenApprovals[tokenId] = to;
1421         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1422     }
1423 
1424     /**
1425      * @dev Approve `operator` to operate on all of `owner` tokens
1426      *
1427      * Emits a {ApprovalForAll} event.
1428      */
1429     function _setApprovalForAll(
1430         address owner,
1431         address operator,
1432         bool approved
1433     ) internal virtual {
1434         require(owner != operator, "ERC721: approve to caller");
1435         _operatorApprovals[owner][operator] = approved;
1436         emit ApprovalForAll(owner, operator, approved);
1437     }
1438 
1439     /**
1440      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1441      * The call is not executed if the target address is not a contract.
1442      *
1443      * @param from address representing the previous owner of the given token ID
1444      * @param to target address that will receive the tokens
1445      * @param tokenId uint256 ID of the token to be transferred
1446      * @param _data bytes optional data to send along with the call
1447      * @return bool whether the call correctly returned the expected magic value
1448      */
1449     function _checkOnERC721Received(
1450         address from,
1451         address to,
1452         uint256 tokenId,
1453         bytes memory _data
1454     ) private returns (bool) {
1455         if (to.isContract()) {
1456             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1457                 return retval == IERC721Receiver.onERC721Received.selector;
1458             } catch (bytes memory reason) {
1459                 if (reason.length == 0) {
1460                     revert("ERC721: transfer to non ERC721Receiver implementer");
1461                 } else {
1462                     assembly {
1463                         revert(add(32, reason), mload(reason))
1464                     }
1465                 }
1466             }
1467         } else {
1468             return true;
1469         }
1470     }
1471 
1472     /**
1473      * @dev Hook that is called before any token transfer. This includes minting
1474      * and burning.
1475      *
1476      * Calling conditions:
1477      *
1478      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1479      * transferred to `to`.
1480      * - When `from` is zero, `tokenId` will be minted for `to`.
1481      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1482      * - `from` and `to` are never both zero.
1483      *
1484      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1485      */
1486     function _beforeTokenTransfer(
1487         address from,
1488         address to,
1489         uint256 tokenId
1490     ) internal virtual {}
1491 }
1492 
1493 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.4/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1494 
1495 
1496 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/ERC721Enumerable.sol)
1497 
1498 pragma solidity ^0.8.0;
1499 
1500 
1501 
1502 /**
1503  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1504  * enumerability of all the token ids in the contract as well as all token ids owned by each
1505  * account.
1506  */
1507 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1508     // Mapping from owner to list of owned token IDs
1509     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1510 
1511     // Mapping from token ID to index of the owner tokens list
1512     mapping(uint256 => uint256) private _ownedTokensIndex;
1513 
1514     // Array with all token ids, used for enumeration
1515     uint256[] private _allTokens;
1516 
1517     // Mapping from token id to position in the allTokens array
1518     mapping(uint256 => uint256) private _allTokensIndex;
1519 
1520     /**
1521      * @dev See {IERC165-supportsInterface}.
1522      */
1523     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1524         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1525     }
1526 
1527     /**
1528      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1529      */
1530     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1531         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1532         return _ownedTokens[owner][index];
1533     }
1534 
1535     /**
1536      * @dev See {IERC721Enumerable-totalSupply}.
1537      */
1538     function totalSupply() public view virtual override returns (uint256) {
1539         return _allTokens.length;
1540     }
1541 
1542     /**
1543      * @dev See {IERC721Enumerable-tokenByIndex}.
1544      */
1545     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1546         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1547         return _allTokens[index];
1548     }
1549 
1550     /**
1551      * @dev Hook that is called before any token transfer. This includes minting
1552      * and burning.
1553      *
1554      * Calling conditions:
1555      *
1556      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1557      * transferred to `to`.
1558      * - When `from` is zero, `tokenId` will be minted for `to`.
1559      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1560      * - `from` cannot be the zero address.
1561      * - `to` cannot be the zero address.
1562      *
1563      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1564      */
1565     function _beforeTokenTransfer(
1566         address from,
1567         address to,
1568         uint256 tokenId
1569     ) internal virtual override {
1570         super._beforeTokenTransfer(from, to, tokenId);
1571 
1572         if (from == address(0)) {
1573             _addTokenToAllTokensEnumeration(tokenId);
1574         } else if (from != to) {
1575             _removeTokenFromOwnerEnumeration(from, tokenId);
1576         }
1577         if (to == address(0)) {
1578             _removeTokenFromAllTokensEnumeration(tokenId);
1579         } else if (to != from) {
1580             _addTokenToOwnerEnumeration(to, tokenId);
1581         }
1582     }
1583 
1584     /**
1585      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1586      * @param to address representing the new owner of the given token ID
1587      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1588      */
1589     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1590         uint256 length = ERC721.balanceOf(to);
1591         _ownedTokens[to][length] = tokenId;
1592         _ownedTokensIndex[tokenId] = length;
1593     }
1594 
1595     /**
1596      * @dev Private function to add a token to this extension's token tracking data structures.
1597      * @param tokenId uint256 ID of the token to be added to the tokens list
1598      */
1599     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1600         _allTokensIndex[tokenId] = _allTokens.length;
1601         _allTokens.push(tokenId);
1602     }
1603 
1604     /**
1605      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1606      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1607      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1608      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1609      * @param from address representing the previous owner of the given token ID
1610      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1611      */
1612     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1613         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1614         // then delete the last slot (swap and pop).
1615 
1616         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1617         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1618 
1619         // When the token to delete is the last token, the swap operation is unnecessary
1620         if (tokenIndex != lastTokenIndex) {
1621             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1622 
1623             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1624             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1625         }
1626 
1627         // This also deletes the contents at the last position of the array
1628         delete _ownedTokensIndex[tokenId];
1629         delete _ownedTokens[from][lastTokenIndex];
1630     }
1631 
1632     /**
1633      * @dev Private function to remove a token from this extension's token tracking data structures.
1634      * This has O(1) time complexity, but alters the order of the _allTokens array.
1635      * @param tokenId uint256 ID of the token to be removed from the tokens list
1636      */
1637     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1638         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1639         // then delete the last slot (swap and pop).
1640 
1641         uint256 lastTokenIndex = _allTokens.length - 1;
1642         uint256 tokenIndex = _allTokensIndex[tokenId];
1643 
1644         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1645         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1646         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1647         uint256 lastTokenId = _allTokens[lastTokenIndex];
1648 
1649         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1650         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1651 
1652         // This also deletes the contents at the last position of the array
1653         delete _allTokensIndex[tokenId];
1654         _allTokens.pop();
1655     }
1656 }
1657 
1658 // File: DiamondDawgs/DiamondDawgs.sol
1659 
1660 
1661 
1662 pragma solidity 0.8.7;
1663 
1664 
1665 
1666 
1667 /// @title DIAMOND DAWGS
1668 /// @author Matt 
1669 contract DD is ERC721Enumerable {
1670     bool public swappingActive = false;
1671     uint256 public maxDawgsSupply = 6800;
1672     uint256 private tokenCount;
1673     uint256 public traitCount;
1674     uint256 private timeOutLength = 10;
1675     address public Owner;
1676     
1677     struct Token {
1678         uint256 baseAttributes;
1679         //Could be changed to a uint256 array for all traits for better gas
1680         mapping(uint256 => uint256) extraAttributes;
1681         string legacyURI;
1682         uint256 timeOut;
1683     }
1684     struct TraitType {
1685         string attributeName;
1686         string attributeURI;
1687         mapping(uint256 => string) breedOverride;
1688         string[] attributeValues;
1689         bool swappable;
1690         bool active;
1691     }
1692     mapping (uint256 => Token) public tokens;
1693     mapping (uint256 => TraitType) public traitTypes;
1694     
1695     address owner;
1696     TraitGeneration private traitGeneration;
1697     URIContract private uriContract;
1698     address contractOperator;
1699     
1700     modifier onlyOwner() {
1701         require(msg.sender == owner || msg.sender == contractOperator);
1702         _;
1703     }
1704     string[] private Signatures = ["None","Yes"];
1705     constructor(address _generationContract, address _uriContract, address _mintContract) ERC721("Diamond Dawgs", "DAWGS") {
1706         //SET MINT PRICE
1707         traitGeneration = TraitGeneration(_generationContract);
1708         uriContract = URIContract(_uriContract);
1709         contractOperator = _mintContract;
1710         owner = msg.sender;
1711         setAttribute(traitCount++, true, "Background", "", traitGeneration.getBackgrounds(),false);
1712         setAttribute(traitCount++, true, "Breed", "", traitGeneration.getBreeds(),false);
1713         setAttribute(traitCount++, true, "Eye", "", traitGeneration.getEyes(),false);
1714         setAttribute(traitCount++, true, "Mouth", "", traitGeneration.getMouths(),false);
1715         setAttribute(traitCount++, true, "Undershirt", "", traitGeneration.getUndershirts(),false);
1716         setAttribute(traitCount++, true, "Jersey", "", traitGeneration.getJerseys(),false);
1717         setAttribute(traitCount++, true, "Head", "", traitGeneration.getHeads(),false);
1718         setAttribute(traitCount++, true, "Accessory", "", traitGeneration.getAccessories(),false);
1719         setAttribute(traitCount++, true, "Signature", "", Signatures,false);
1720     }
1721     function getUriValues(uint256 attrI, uint256 valueI,uint256 breedI) public view returns (string memory, string memory, string memory, string memory, bool){
1722         string memory an = traitTypes[attrI].attributeName;
1723         string memory av = traitTypes[attrI].attributeValues[valueI];
1724         string memory au = traitTypes[attrI].attributeURI;
1725         string memory bo = traitTypes[attrI].breedOverride[breedI];
1726         bool ac = traitTypes[attrI].active;
1727         return (an, av, au, bo, ac);
1728     }
1729     function getExtraAttr(uint tokenId, uint256 attrI)public view returns(uint256){
1730         return tokens[tokenId].extraAttributes[attrI];
1731     }
1732     function getLegacyURI(uint tokenId) public view returns(string memory){
1733         return tokens[tokenId].legacyURI;
1734     }
1735     function setLegacyURI(uint tokenId, string memory legacyURI) public onlyOwner {
1736         tokens[tokenId].legacyURI = legacyURI;
1737     }
1738     function addAttValue(uint256 _attributeId, string[] memory _valueArray)public onlyOwner{
1739         traitTypes[_attributeId].attributeValues = _valueArray;
1740     }
1741     function addAttribute(bool active, string memory _traitName, string memory _traitURI, string[] memory _valueArray, bool _swappable) public onlyOwner{
1742         setAttribute(traitCount++, active, _traitName, _traitURI, _valueArray, _swappable);
1743     }
1744     function setAttribute(uint256 _traitId, bool active, string memory _traitName, string memory _traitURI, string[] memory _valueArray, bool _swappable) public onlyOwner {
1745         TraitType storage trait = traitTypes[_traitId];
1746         trait.active = active;
1747         trait.attributeName = _traitName;
1748         trait.attributeURI = _traitURI;
1749         if(_valueArray.length > 0){
1750             trait.attributeValues = _valueArray;
1751         }
1752         trait.swappable = _swappable;
1753     }
1754     function attrOverrideURI(uint _traitIndex, uint[] memory _indexArray, string[] memory _stringArray) public onlyOwner {
1755         for(uint i = 0; i < _indexArray.length; i++){
1756             traitTypes[_traitIndex].breedOverride[_indexArray[i]] = _stringArray[i];
1757         }
1758     }
1759     
1760     function generateToken(uint _tokenId) private {
1761         bytes32 pepper = bytes32(abi.encodePacked(Base64.uint2str(_tokenId),block.timestamp, block.difficulty));
1762         uint256[9] memory attributeIndexArray = traitGeneration.generateTraits(pepper);
1763         saveBaseAttributes(_tokenId, attributeIndexArray);
1764     }
1765     function saveBaseAttributes(uint256 _tokenId, uint256[9] memory attrArray) private {
1766         uint256 tokenBaseAtt = uint256(0x0);
1767         for(uint256 i = attrArray.length; i > 0; i--){
1768             uint256 ii = 256 - (i*8);
1769             tokenBaseAtt |= attrArray[i-1]<<ii;
1770         }
1771         tokens[_tokenId].baseAttributes = tokenBaseAtt;
1772     }
1773     function getBaseAttributues(uint256 _tokenId) public view returns(uint256[9] memory){
1774         uint256[9] memory baseAtt;
1775         uint256 baseAttr = tokens[_tokenId].baseAttributes;
1776         for(uint256 i = baseAtt.length; i > 0; i--){
1777             uint256 ii = 256 - (i*8);
1778             baseAtt[i-1] = uint256(uint8(baseAttr>>ii));
1779         }
1780         return baseAtt;
1781     }
1782     function editAttributeToToken(uint256 _tokenId, uint256 _attributeId, uint256 attributeValueId) public onlyOwner {
1783         if(_attributeId < 9){
1784             uint256[9] memory base = getBaseAttributues(_tokenId);
1785             base[_attributeId] = attributeValueId;
1786             saveBaseAttributes(_tokenId, base);
1787         } else {
1788             tokens[_tokenId].extraAttributes[_attributeId] = attributeValueId;
1789         }
1790     }
1791     function swapAttributes(uint256 _token1, uint256 _token2, uint256 attributeId) public {
1792         require(ownerOf(_token1) == msg.sender && ownerOf(_token2) == msg.sender, "Not owner of tokens");
1793         require(swappingActive == true && traitTypes[attributeId].swappable == true, "Swapping not active or unswappable attribute");
1794         require(traitTypes[attributeId].active == true, "Not a valid attribute");
1795         if(attributeId < 9){
1796             //BASE TRAIT SWAPPING
1797             uint256[9] memory base1 = getBaseAttributues(_token1);
1798             uint256[9] memory base2 = getBaseAttributues(_token2);
1799             uint256 tmp = base1[attributeId];
1800             base1[attributeId] = base2[attributeId];
1801             base2[attributeId] = tmp;
1802             saveBaseAttributes(_token1, base1);
1803             saveBaseAttributes(_token2, base2);
1804             
1805         } else {
1806             uint256 tmp = tokens[_token1].extraAttributes[attributeId];
1807             tokens[_token1].extraAttributes[attributeId] = tokens[_token2].extraAttributes[attributeId];
1808             tokens[_token2].extraAttributes[attributeId] = tmp;
1809         }
1810         uint256 tO = timeOutLength + block.number;
1811         tokens[_token1].timeOut = tO;
1812         tokens[_token2].timeOut = tO;
1813     }
1814     function safeTransferFrom(
1815         address from,
1816         address to,
1817         uint256 tokenId
1818     ) public virtual override {
1819         require(tokens[tokenId].timeOut < block.number);
1820         safeTransferFrom(from, to, tokenId, "");
1821     }
1822     
1823     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1824         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1825         string memory rtn = uriContract.formTokenURI(tokenId);
1826         return rtn;
1827     }
1828     function mint(uint _count, address _to) onlyOwner public {
1829         
1830         uint256 _tokenId = tokenCount;
1831         require(_tokenId + _count < maxDawgsSupply, "Max Dawgz Reached");
1832         for(uint i = 0; i < _count; i++){
1833             
1834             generateToken(_tokenId);
1835             _safeMint(_to, _tokenId);
1836             _tokenId++;
1837         }
1838         tokenCount = _tokenId;
1839     }
1840     function flipSwapping() public onlyOwner {
1841         swappingActive = !swappingActive;
1842     }
1843     function changeParams(uint256 _totalSupply, address _generationContract, address _uriContract, uint256 _timeOut, address _contractOperator) public onlyOwner {
1844         maxDawgsSupply = _totalSupply;
1845         traitGeneration = TraitGeneration(_generationContract);
1846         uriContract = URIContract(_uriContract);
1847         timeOutLength = _timeOut;
1848         contractOperator = _contractOperator;
1849     }
1850     
1851     function transferOwnership(address _newOwner) public onlyOwner {
1852         require(msg.sender == owner, "Not owner");
1853         owner = _newOwner;
1854     }
1855     function setTimeOut(uint256 _tokenId, uint256 _timeOut) public onlyOwner {
1856         tokens[_tokenId].timeOut = _timeOut;
1857     }
1858 }
1859 
1860 contract MintContract is Ownable, PaymentSplitter {
1861     bool public sale = false;
1862     bool public saleWhitelist = false;
1863     mapping(address => uint256) public whitelist;
1864     uint256 mintPrice;
1865     uint256 public maxPerTransaction = 7;
1866     address[] private _team = [
1867         0xdE221Ab3868fd89d46835b1bA896aF288ec8705b,
1868         0x12a49C53DEE28E10C392E57394FCACec4e3a3816,
1869         0x3765240be64aF984bC5bB3B6A2988e431d668f6B
1870     ];
1871     
1872     uint256[] private _teamShares = [
1873         93,
1874         6,
1875         1
1876     ];
1877     
1878     DD private dd;
1879     constructor(uint256 _mintPrice) PaymentSplitter(_team, _teamShares) {
1880         mintPrice = _mintPrice;
1881         //70000000000000000
1882     }
1883     function setDD(address _dd) public onlyOwner{
1884         dd = DD(_dd);
1885     }
1886     function flipWhitelistSale() public onlyOwner {
1887         saleWhitelist = !saleWhitelist;
1888     }
1889     function flipSale() public onlyOwner {
1890         sale = !sale;
1891     }
1892     
1893     function mint(uint256 _count) public payable {
1894         require(sale == true, "Normal Sale Not Active");
1895         require(_count <= maxPerTransaction, "Over maxPerTransaction");
1896         require(msg.value == mintPrice * _count, "Insuffcient Amount Sent");
1897         dd.mint(_count, msg.sender);
1898     }
1899     function mintWhitelist(uint256 _count) public payable{
1900         require(saleWhitelist == true, "Whitelist Sale Not Active");
1901         require(_count <= whitelist[msg.sender], "Over Whitelist Allowance");
1902         require(msg.value == mintPrice * _count, "Wrong Amount Sent");
1903         dd.mint(_count, msg.sender);
1904         whitelist[msg.sender] -= _count;
1905     }
1906     function mintAirdrop(address[] memory _to) public onlyOwner{
1907         for(uint i = 0; i < _to.length; i++){
1908             dd.mint(1, _to[i]);
1909         }
1910     }
1911     function changeParams(uint256 _mintPrice, uint256 _maxPerTransaction) public onlyOwner{
1912         mintPrice = _mintPrice;
1913         maxPerTransaction = _maxPerTransaction;
1914     }
1915     
1916     function addWhitelist(address[] memory _addressArray) public onlyOwner{
1917         for(uint256 i = 0; i < _addressArray.length; i++){
1918             whitelist[_addressArray[i]] = 3;
1919         }
1920     }
1921     
1922     function withdrawAll() external onlyOwner {
1923         for (uint256 i = 0; i < _team.length; i++) {
1924             address payable wallet = payable(_team[i]);
1925             release(wallet);
1926         }
1927     }
1928 }
1929 
1930 contract URIContract is Ownable {
1931     uint256 size = 800;
1932     
1933     
1934     string public description = "";
1935     string public earURI = "";
1936     string public placeholder = "https://diamonddawgs.s3.us-east-2.amazonaws.com/placeholder/placeholder.gif";
1937     DD private dd;
1938     
1939     function returnAttributeSVG(string memory _addTo, string memory _traitBaseURI, uint256 _valueIndex) public pure returns (string memory){
1940         return string(abi.encodePacked(_addTo, '<image href="' , _traitBaseURI , Base64.uint2str(_valueIndex), '.png" x="0" y="0" width="100%" height="100%"/>'));
1941     }
1942     function returnAttributeValue(string memory _addTo, string memory _attributeName, string memory _attributeValue) public pure returns (string memory){
1943         return string(abi.encodePacked(_addTo, '{"trait_type":"' , _attributeName ,'","value":"', _attributeValue ,'"}'));
1944     }
1945     struct TraitType {
1946         string attributeName;
1947         string attributeURI;
1948         mapping(uint256 => string) breedOverride;
1949         string[] attributeValues;
1950         bool swappable;
1951         bool active;
1952     }
1953     
1954     function contractParams(address _dd, string memory _description, uint _size, string memory _placeholder)public onlyOwner{
1955         dd = DD(_dd);
1956         description = _description;
1957         size = _size;
1958         placeholder = _placeholder;
1959     }
1960     function changeEarURI(string memory _earUri) public onlyOwner {
1961         earURI = _earUri;
1962     }
1963     
1964     function formTokenURI(uint256 tokenId) public view returns (string memory) {
1965         if(bytes(dd.getLegacyURI(tokenId)).length > 0){
1966             return(dd.getLegacyURI(tokenId));
1967         }
1968         string memory strAttributes = '"attributes":[';
1969         //string memory strImages = string(abi.encodePacked('<svg xmlns="http://www.w3.org/2000/svg" width="', Base64.uint2str(size) ,'" height="', Base64.uint2str(size) ,'">'));
1970         uint256[9] memory baseAtt = dd.getBaseAttributues(tokenId);
1971         for(uint256 i = 0; i < dd.traitCount(); i++){
1972 
1973             if(i < 9){
1974                 (string memory attributeName, string memory attributeValue, string memory attributeURI, string memory breedOverride, bool active) = dd.getUriValues(i, baseAtt[i], baseAtt[2]);
1975                 if(bytes(attributeValue).length > 0 && active == true){
1976                     //string memory uri = bytes(breedOverride).length > 0 ? breedOverride : attributeURI ;
1977                     //strImages = returnAttributeSVG(strImages, uri, baseAtt[i]);
1978                     strAttributes = returnAttributeValue(strAttributes, attributeName, attributeValue);
1979                     if(i!=8){
1980                         strAttributes = string(abi.encodePacked(strAttributes,','));
1981                     }
1982                 }
1983             } //else {
1984                 /*
1985                 uint256 extraAttribute = dd.getExtraAttr(tokenId, i);
1986                 //if(extraAttribute > 0){
1987                     (string memory attributeName, string memory attributeValue, string memory attributeURI, string memory breedOverride) = dd.getUriValues(i, extraAttribute, baseAtt[2]);
1988                     //string memory uri = bytes(breedOverride).length > 0 ? breedOverride : attributeURI ;
1989                     strImages = returnAttributeSVG(strImages, attributeURI, extraAttribute);
1990                     strAttributes = returnAttributeValue(strAttributes, attributeName, attributeValue);
1991                 //} 
1992                 */
1993             //}
1994         }
1995         
1996         //ADD EAR
1997         //strImages = returnAttributeSVG(strImages, earURI, baseAtt[2]);
1998         //
1999         //strImages = string(abi.encodePacked(strImages,'</svg>'));
2000         //string memory strImages = "";
2001         strAttributes = string(abi.encodePacked(strAttributes,']'));
2002        
2003         //string memory imageBase64 = string(abi.encodePacked('"data:image/svg+xml;base64,',Base64.encode(bytes(strImages)),'"'));
2004         string memory imageBase64 = string(abi.encodePacked('"',placeholder,'"'));
2005         string memory rtn = string(abi.encodePacked('{"name":"DAWG #',Base64.uint2str(tokenId),'","description":"',description,'","image":',imageBase64,',',strAttributes,'}'));
2006         return string(abi.encodePacked('data:application/json;base64,',Base64.encode(bytes(rtn))));
2007     }
2008     
2009 }
2010 
2011 contract TraitGeneration {
2012     //BACKGROUND    
2013     string[] private backgrounds =  ["Light Blue","Orange","Grey","Purple",
2014                                     "Army","Teal","Mint",
2015                                     "Stadium","LSD"];
2016 
2017     //BREEDS        
2018     string[] private breeds =   ["Light","Medium","Dark","Light Husky","Medium Husky",
2019                                 "Dark Husky","Blond Retriever","LSD Retriever","Gold",
2020                                 "Gold Husky","LSD"];
2021     
2022     //EYES
2023     string[] private eyes =  ["Normal","Red","Blue","Puppy Cry","Grey Sunglasses","Grey Shine Glasses","Yellow Glasses","Eyes Open","Big Blue eyes",
2024                             "Yellow Shine Glasses","Black Heart Glasses","Red Heart Glasses","Colorful Glasses","Stoned Eyes",
2025                             "LSD Glasses","Gold Heart Glasses"];
2026     //NEED TO CHANGE THESE
2027     string[] private mouths =  ["Frown","Smile","Spitting","Smile + Tounge","Bored","Bored + Tounge",
2028                                 "Gold Grills","Gold Grill + Bubble","Frown + Cigar","Frown + Tounge","Gold Grill + Tounge","Dip Smile","Cigar",
2029                                 "Spitting Seeds","Gold Dip Smile","Bubble"];
2030     
2031     //UNDERSHIRTS
2032     string[] internal undershirts =  ["None",
2033                                      "White","Red","Blue","Black","Navy","Brown","Green","Baby Blue","Orange","Purple"];
2034                             
2035     //BREEDS        
2036     string[] private jerseys =   ["Red and Navy Blue","White with Red Pinstripe","White and Black","Black and Baby Blue","Black and White","White and Navy Blue","White and Red","Black and Purple","Navy Blue and Baby Blue","Blue and White","Cream and Orange","White and Blue","Black and Yellow","White with Blue Pinstripes","Cream and Blue","Navy Blue and Red","Blue and Red","Brown with Yellow","Navy Blue with Yellow","Green and Yellow",
2037                                 "White with Navy Blue and Red Lining","White with Navy Blue pinstripes","Gold","Grey with Brown Pinstripes","Baby Blue and Red","LSD","Army","Floral",
2038                                 "Baby Blue with USA Neck","Baby Blue with Maroon Shoulders","White with Blue Pinstripes and Blue and Orange Shoulders","All Star","Tatoos"];
2039     
2040     string[] internal heads =  ["Grey Catcher Mask","Blue Catcher Mask","Red Catcher Mask","Hair-Fade","Hair-Afro","blue/blue/white flat bill","navy/navy/white flat bill","red/red/white flat bill","Backwards Red","Backwards Blue","Backwards Navy","Rally Cap Red","Rally Cap Blue","Rally Cap Navy","Red Helmet","Blue Helmet","Red Curved","Blue Curved","Black Curved","Orange Curved",
2041                             "Navy Catcher Mask","Hair-Dreads","black/black/white flat bill","brown/brow/yellow flat bill","green/yellow/white flat bill","navy/red/white flat bill","white/orange/black flat bill","Backwards Black","Rally Cap Black","Rally Cap Pastel","Black Helmet","Navy Helmet","Navy Blue Curved","Army Curved","LSD Curved",
2042                             "Gold Catcher Mask","Army Flat Bill","Gold Flat Bill","LSD Flat Bill","Gold Helmet","Gold Curved","Black Flat Bill with Glove","Black Flat Bill with Upside Down Glasses"];
2043     
2044     string[] internal accessories = ["None","Gold Chain","Black Chest Protector","Navy ChestProtector","Red Chest Protector","Freckles","Wood Baseball Bat",
2045                                     "Black Diamond Necklace","Eyeblack","Silver Diamond Necklace","Silver Slugger Baseball Bat","Gold Baseball Bat","Blue Chest Protector","Dog Tag Necklace","Little League Pins", 
2046                                     "Flip Glasses","Lazer Eyes","Diamond Pennant Necklace"];//ADD NONE TO IMAGES
2047     function random(bytes32 t, bytes32 _input, uint8 _mod) private pure returns (uint256) {
2048         return uint256(keccak256(abi.encodePacked(t, _input)))%_mod;
2049     }
2050     
2051     function useWeight(uint8[3] memory _split, uint8 _saltI,  bytes32 _pepper) private pure returns(uint8){
2052         uint8[3] memory _weights = [75,95,100];
2053         bytes32 salt = "308fd119edae5f1309aafade64147";
2054         uint256 ran1 = random(salt[_saltI], _pepper, 100);
2055         uint8 traitIndex;
2056         uint8 i;
2057         while (_weights[i] < ran1) {
2058             traitIndex += _split[i];
2059             i++;
2060         }
2061         uint256 ran2 = random(salt[_saltI + 2], _pepper, _split[i]);
2062         return uint8(traitIndex + ran2);
2063     }
2064     function useWeightTwo(uint8[2] memory _split, uint8 _saltI,  bytes32 _pepper) private pure returns(uint8){
2065         uint8[2] memory _weights = [50,100];
2066         bytes32 salt = "308fd119edae5f1309aafade64147";
2067         uint256 ran1 = random(salt[_saltI], _pepper, 100);
2068         uint8 traitIndex;
2069         uint8 i;
2070         while (_weights[i] < ran1) {
2071             traitIndex += _split[i];
2072             i++;
2073         }
2074         uint256 ran2 = random(salt[_saltI + 2], _pepper, _split[i]);
2075         return uint8(traitIndex + ran2);
2076     }
2077     function useWeightFour(uint8[4] memory _split, uint8 _saltI,  bytes32 _pepper) private pure returns(uint8){
2078         uint8[4] memory _weights = [30,70,95,101];
2079         bytes32 salt = "308fd119edae5f1309aafade64147bhs";
2080         uint256 ran1 = random(salt[_saltI], _pepper, 100);
2081         uint8 traitIndex;
2082         uint8 i;
2083         while (_weights[i] < ran1) {
2084             traitIndex += _split[i];
2085             i++;
2086         }
2087         uint256 ran2 = random(salt[_saltI + 1], _pepper, _split[i]);
2088         return uint8(traitIndex + ran2);
2089     }
2090     function generateTraits(bytes32 _pepper) public pure returns (uint256[9] memory) {
2091         
2092         
2093         uint8[3] memory bgSplit = [4,3,2];
2094         uint8[3] memory brSplit = [5,4,2];  
2095         uint8[3] memory eySplit = [9,5,2];  
2096         
2097         uint8[3] memory moSplit = [6,5,3];  
2098         uint8[2] memory unSplit = [1,10];  
2099         uint8[3] memory jeSplit = [20,8,5];  
2100         
2101         uint8[3] memory heSplit = [20,15,8]; 
2102         uint8[4] memory acSplit = [1,6,8,3]; 
2103         
2104         uint256[9] memory attributeIndexArray;
2105         attributeIndexArray[0] = useWeight(bgSplit, 0, _pepper);
2106         attributeIndexArray[1] = useWeight(brSplit, 2, _pepper);
2107         attributeIndexArray[2] = useWeight(eySplit, 4, _pepper);
2108         
2109         attributeIndexArray[3] = useWeight(moSplit, 6, _pepper);
2110         attributeIndexArray[4] = useWeightTwo(unSplit, 7, _pepper);
2111         attributeIndexArray[5] = useWeight(jeSplit, 8, _pepper);
2112         
2113         attributeIndexArray[6] = useWeight(heSplit, 12, _pepper);
2114         attributeIndexArray[7] = useWeightFour(acSplit, 3, _pepper);
2115         attributeIndexArray[8] = uint256(uint256(keccak256(abi.encodePacked(_pepper)))%2);
2116         
2117         return attributeIndexArray;
2118     }
2119     function getBackgrounds() public view returns (string[] memory){
2120         return backgrounds;
2121     }
2122     function getBreeds() public view returns (string[] memory){
2123         return breeds;
2124     }
2125     function getEyes() public view returns (string[] memory){
2126         return eyes;
2127     }
2128     function getMouths() public view returns (string[] memory){
2129         return mouths;
2130     }
2131     function getJerseys() public view returns (string[] memory){
2132         return jerseys;
2133     }
2134     function getUndershirts() public view returns (string[] memory){
2135         return undershirts;
2136     }
2137     function getHeads() public view returns (string[] memory){
2138         return heads;
2139     }
2140     function getAccessories() public view returns (string[] memory){
2141         return accessories;
2142     }
2143 }
2144 /// @title Base64
2145 /// @author Brecht Devos - <brecht@loopring.org>
2146 library Base64 {
2147     string internal constant TABLE_ENCODE = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
2148 
2149     function encode(bytes memory data) internal pure returns (string memory) {
2150         if (data.length == 0) return '';
2151 
2152         // load the table into memory
2153         string memory table = TABLE_ENCODE;
2154 
2155         // multiply by 4/3 rounded up
2156         uint256 encodedLen = 4 * ((data.length + 2) / 3);
2157 
2158         // add some extra buffer at the end required for the writing
2159         string memory result = new string(encodedLen + 32);
2160 
2161         assembly {
2162             // set the actual output length
2163             mstore(result, encodedLen)
2164 
2165             // prepare the lookup table
2166             let tablePtr := add(table, 1)
2167 
2168             // input ptr
2169             let dataPtr := data
2170             let endPtr := add(dataPtr, mload(data))
2171 
2172             // result ptr, jump over length
2173             let resultPtr := add(result, 32)
2174 
2175             // run over the input, 3 bytes at a time
2176             for {} lt(dataPtr, endPtr) {}
2177             {
2178                 // read 3 bytes
2179                 dataPtr := add(dataPtr, 3)
2180                 let input := mload(dataPtr)
2181 
2182                 // write 4 characters
2183                 mstore8(resultPtr, mload(add(tablePtr, and(shr(18, input), 0x3F))))
2184                 resultPtr := add(resultPtr, 1)
2185                 mstore8(resultPtr, mload(add(tablePtr, and(shr(12, input), 0x3F))))
2186                 resultPtr := add(resultPtr, 1)
2187                 mstore8(resultPtr, mload(add(tablePtr, and(shr( 6, input), 0x3F))))
2188                 resultPtr := add(resultPtr, 1)
2189                 mstore8(resultPtr, mload(add(tablePtr, and(        input,  0x3F))))
2190                 resultPtr := add(resultPtr, 1)
2191             }
2192 
2193             // padding with '='
2194             switch mod(mload(data), 3)
2195             case 1 { mstore(sub(resultPtr, 2), shl(240, 0x3d3d)) }
2196             case 2 { mstore(sub(resultPtr, 1), shl(248, 0x3d)) }
2197         }
2198 
2199         return result;
2200     }
2201     function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
2202         if (_i == 0) {
2203             return "0";
2204         }
2205         uint j = _i;
2206         uint len;
2207         while (j != 0) {
2208             len++;
2209             j /= 10;
2210         }
2211         bytes memory bstr = new bytes(len);
2212         uint k = len;
2213         while (_i != 0) {
2214             k = k-1;
2215             uint8 temp = (48 + uint8(_i - _i / 10 * 10));
2216             bytes1 b1 = bytes1(temp);
2217             bstr[k] = b1;
2218             _i /= 10;
2219         }
2220         return string(bstr);
2221     }
2222   
2223 }