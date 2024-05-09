1 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol
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
86 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol
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
156 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol
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
183 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
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
261 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol
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
288      *
289      * [IMPORTANT]
290      * ====
291      * You shouldn't rely on `isContract` to protect against flash loan attacks!
292      *
293      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
294      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
295      * constructor.
296      * ====
297      */
298     function isContract(address account) internal view returns (bool) {
299         // This method relies on extcodesize/address.code.length, which returns 0
300         // for contracts in construction, since the code is only stored at the end
301         // of the constructor execution.
302 
303         return account.code.length > 0;
304     }
305 
306     /**
307      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
308      * `recipient`, forwarding all available gas and reverting on errors.
309      *
310      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
311      * of certain opcodes, possibly making contracts go over the 2300 gas limit
312      * imposed by `transfer`, making them unable to receive funds via
313      * `transfer`. {sendValue} removes this limitation.
314      *
315      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
316      *
317      * IMPORTANT: because control is transferred to `recipient`, care must be
318      * taken to not create reentrancy vulnerabilities. Consider using
319      * {ReentrancyGuard} or the
320      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
321      */
322     function sendValue(address payable recipient, uint256 amount) internal {
323         require(address(this).balance >= amount, "Address: insufficient balance");
324 
325         (bool success, ) = recipient.call{value: amount}("");
326         require(success, "Address: unable to send value, recipient may have reverted");
327     }
328 
329     /**
330      * @dev Performs a Solidity function call using a low level `call`. A
331      * plain `call` is an unsafe replacement for a function call: use this
332      * function instead.
333      *
334      * If `target` reverts with a revert reason, it is bubbled up by this
335      * function (like regular Solidity function calls).
336      *
337      * Returns the raw returned data. To convert to the expected return value,
338      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
339      *
340      * Requirements:
341      *
342      * - `target` must be a contract.
343      * - calling `target` with `data` must not revert.
344      *
345      * _Available since v3.1._
346      */
347     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
348         return functionCall(target, data, "Address: low-level call failed");
349     }
350 
351     /**
352      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
353      * `errorMessage` as a fallback revert reason when `target` reverts.
354      *
355      * _Available since v3.1._
356      */
357     function functionCall(
358         address target,
359         bytes memory data,
360         string memory errorMessage
361     ) internal returns (bytes memory) {
362         return functionCallWithValue(target, data, 0, errorMessage);
363     }
364 
365     /**
366      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
367      * but also transferring `value` wei to `target`.
368      *
369      * Requirements:
370      *
371      * - the calling contract must have an ETH balance of at least `value`.
372      * - the called Solidity function must be `payable`.
373      *
374      * _Available since v3.1._
375      */
376     function functionCallWithValue(
377         address target,
378         bytes memory data,
379         uint256 value
380     ) internal returns (bytes memory) {
381         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
382     }
383 
384     /**
385      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
386      * with `errorMessage` as a fallback revert reason when `target` reverts.
387      *
388      * _Available since v3.1._
389      */
390     function functionCallWithValue(
391         address target,
392         bytes memory data,
393         uint256 value,
394         string memory errorMessage
395     ) internal returns (bytes memory) {
396         require(address(this).balance >= value, "Address: insufficient balance for call");
397         require(isContract(target), "Address: call to non-contract");
398 
399         (bool success, bytes memory returndata) = target.call{value: value}(data);
400         return verifyCallResult(success, returndata, errorMessage);
401     }
402 
403     /**
404      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
405      * but performing a static call.
406      *
407      * _Available since v3.3._
408      */
409     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
410         return functionStaticCall(target, data, "Address: low-level static call failed");
411     }
412 
413     /**
414      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
415      * but performing a static call.
416      *
417      * _Available since v3.3._
418      */
419     function functionStaticCall(
420         address target,
421         bytes memory data,
422         string memory errorMessage
423     ) internal view returns (bytes memory) {
424         require(isContract(target), "Address: static call to non-contract");
425 
426         (bool success, bytes memory returndata) = target.staticcall(data);
427         return verifyCallResult(success, returndata, errorMessage);
428     }
429 
430     /**
431      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
432      * but performing a delegate call.
433      *
434      * _Available since v3.4._
435      */
436     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
437         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
438     }
439 
440     /**
441      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
442      * but performing a delegate call.
443      *
444      * _Available since v3.4._
445      */
446     function functionDelegateCall(
447         address target,
448         bytes memory data,
449         string memory errorMessage
450     ) internal returns (bytes memory) {
451         require(isContract(target), "Address: delegate call to non-contract");
452 
453         (bool success, bytes memory returndata) = target.delegatecall(data);
454         return verifyCallResult(success, returndata, errorMessage);
455     }
456 
457     /**
458      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
459      * revert reason using the provided one.
460      *
461      * _Available since v4.3._
462      */
463     function verifyCallResult(
464         bool success,
465         bytes memory returndata,
466         string memory errorMessage
467     ) internal pure returns (bytes memory) {
468         if (success) {
469             return returndata;
470         } else {
471             // Look for revert reason and bubble it up if present
472             if (returndata.length > 0) {
473                 // The easiest way to bubble the revert reason is using memory via assembly
474 
475                 assembly {
476                     let returndata_size := mload(returndata)
477                     revert(add(32, returndata), returndata_size)
478                 }
479             } else {
480                 revert(errorMessage);
481             }
482         }
483     }
484 }
485 
486 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/utils/SafeERC20.sol
487 
488 
489 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
490 
491 pragma solidity ^0.8.0;
492 
493 
494 
495 /**
496  * @title SafeERC20
497  * @dev Wrappers around ERC20 operations that throw on failure (when the token
498  * contract returns false). Tokens that return no value (and instead revert or
499  * throw on failure) are also supported, non-reverting calls are assumed to be
500  * successful.
501  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
502  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
503  */
504 library SafeERC20 {
505     using Address for address;
506 
507     function safeTransfer(
508         IERC20 token,
509         address to,
510         uint256 value
511     ) internal {
512         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
513     }
514 
515     function safeTransferFrom(
516         IERC20 token,
517         address from,
518         address to,
519         uint256 value
520     ) internal {
521         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
522     }
523 
524     /**
525      * @dev Deprecated. This function has issues similar to the ones found in
526      * {IERC20-approve}, and its usage is discouraged.
527      *
528      * Whenever possible, use {safeIncreaseAllowance} and
529      * {safeDecreaseAllowance} instead.
530      */
531     function safeApprove(
532         IERC20 token,
533         address spender,
534         uint256 value
535     ) internal {
536         // safeApprove should only be called when setting an initial allowance,
537         // or when resetting it to zero. To increase and decrease it, use
538         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
539         require(
540             (value == 0) || (token.allowance(address(this), spender) == 0),
541             "SafeERC20: approve from non-zero to non-zero allowance"
542         );
543         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
544     }
545 
546     function safeIncreaseAllowance(
547         IERC20 token,
548         address spender,
549         uint256 value
550     ) internal {
551         uint256 newAllowance = token.allowance(address(this), spender) + value;
552         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
553     }
554 
555     function safeDecreaseAllowance(
556         IERC20 token,
557         address spender,
558         uint256 value
559     ) internal {
560         unchecked {
561             uint256 oldAllowance = token.allowance(address(this), spender);
562             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
563             uint256 newAllowance = oldAllowance - value;
564             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
565         }
566     }
567 
568     /**
569      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
570      * on the return value: the return value is optional (but if data is returned, it must not be false).
571      * @param token The token targeted by the call.
572      * @param data The call data (encoded using abi.encode or one of its variants).
573      */
574     function _callOptionalReturn(IERC20 token, bytes memory data) private {
575         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
576         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
577         // the target address contains contract code and also asserts for success in the low-level call.
578 
579         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
580         if (returndata.length > 0) {
581             // Return data is optional
582             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
583         }
584     }
585 }
586 
587 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/finance/PaymentSplitter.sol
588 
589 
590 // OpenZeppelin Contracts v4.4.1 (finance/PaymentSplitter.sol)
591 
592 pragma solidity ^0.8.0;
593 
594 
595 
596 
597 /**
598  * @title PaymentSplitter
599  * @dev This contract allows to split Ether payments among a group of accounts. The sender does not need to be aware
600  * that the Ether will be split in this way, since it is handled transparently by the contract.
601  *
602  * The split can be in equal parts or in any other arbitrary proportion. The way this is specified is by assigning each
603  * account to a number of shares. Of all the Ether that this contract receives, each account will then be able to claim
604  * an amount proportional to the percentage of total shares they were assigned.
605  *
606  * `PaymentSplitter` follows a _pull payment_ model. This means that payments are not automatically forwarded to the
607  * accounts but kept in this contract, and the actual transfer is triggered as a separate step by calling the {release}
608  * function.
609  *
610  * NOTE: This contract assumes that ERC20 tokens will behave similarly to native tokens (Ether). Rebasing tokens, and
611  * tokens that apply fees during transfers, are likely to not be supported as expected. If in doubt, we encourage you
612  * to run tests before sending real value to this contract.
613  */
614 contract PaymentSplitter is Context {
615     event PayeeAdded(address account, uint256 shares);
616     event PaymentReleased(address to, uint256 amount);
617     event ERC20PaymentReleased(IERC20 indexed token, address to, uint256 amount);
618     event PaymentReceived(address from, uint256 amount);
619 
620     uint256 private _totalShares;
621     uint256 private _totalReleased;
622 
623     mapping(address => uint256) private _shares;
624     mapping(address => uint256) private _released;
625     address[] private _payees;
626 
627     mapping(IERC20 => uint256) private _erc20TotalReleased;
628     mapping(IERC20 => mapping(address => uint256)) private _erc20Released;
629 
630     /**
631      * @dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at
632      * the matching position in the `shares` array.
633      *
634      * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no
635      * duplicates in `payees`.
636      */
637     constructor(address[] memory payees, uint256[] memory shares_) payable {
638         require(payees.length == shares_.length, "PaymentSplitter: payees and shares length mismatch");
639         require(payees.length > 0, "PaymentSplitter: no payees");
640 
641         for (uint256 i = 0; i < payees.length; i++) {
642             _addPayee(payees[i], shares_[i]);
643         }
644     }
645 
646     /**
647      * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully
648      * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
649      * reliability of the events, and not the actual splitting of Ether.
650      *
651      * To learn more about this see the Solidity documentation for
652      * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
653      * functions].
654      */
655     receive() external payable virtual {
656         emit PaymentReceived(_msgSender(), msg.value);
657     }
658 
659     /**
660      * @dev Getter for the total shares held by payees.
661      */
662     function totalShares() public view returns (uint256) {
663         return _totalShares;
664     }
665 
666     /**
667      * @dev Getter for the total amount of Ether already released.
668      */
669     function totalReleased() public view returns (uint256) {
670         return _totalReleased;
671     }
672 
673     /**
674      * @dev Getter for the total amount of `token` already released. `token` should be the address of an IERC20
675      * contract.
676      */
677     function totalReleased(IERC20 token) public view returns (uint256) {
678         return _erc20TotalReleased[token];
679     }
680 
681     /**
682      * @dev Getter for the amount of shares held by an account.
683      */
684     function shares(address account) public view returns (uint256) {
685         return _shares[account];
686     }
687 
688     /**
689      * @dev Getter for the amount of Ether already released to a payee.
690      */
691     function released(address account) public view returns (uint256) {
692         return _released[account];
693     }
694 
695     /**
696      * @dev Getter for the amount of `token` tokens already released to a payee. `token` should be the address of an
697      * IERC20 contract.
698      */
699     function released(IERC20 token, address account) public view returns (uint256) {
700         return _erc20Released[token][account];
701     }
702 
703     /**
704      * @dev Getter for the address of the payee number `index`.
705      */
706     function payee(uint256 index) public view returns (address) {
707         return _payees[index];
708     }
709 
710     /**
711      * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
712      * total shares and their previous withdrawals.
713      */
714     function release(address payable account) public virtual {
715         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
716 
717         uint256 totalReceived = address(this).balance + totalReleased();
718         uint256 payment = _pendingPayment(account, totalReceived, released(account));
719 
720         require(payment != 0, "PaymentSplitter: account is not due payment");
721 
722         _released[account] += payment;
723         _totalReleased += payment;
724 
725         Address.sendValue(account, payment);
726         emit PaymentReleased(account, payment);
727     }
728 
729     /**
730      * @dev Triggers a transfer to `account` of the amount of `token` tokens they are owed, according to their
731      * percentage of the total shares and their previous withdrawals. `token` must be the address of an IERC20
732      * contract.
733      */
734     function release(IERC20 token, address account) public virtual {
735         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
736 
737         uint256 totalReceived = token.balanceOf(address(this)) + totalReleased(token);
738         uint256 payment = _pendingPayment(account, totalReceived, released(token, account));
739 
740         require(payment != 0, "PaymentSplitter: account is not due payment");
741 
742         _erc20Released[token][account] += payment;
743         _erc20TotalReleased[token] += payment;
744 
745         SafeERC20.safeTransfer(token, account, payment);
746         emit ERC20PaymentReleased(token, account, payment);
747     }
748 
749     /**
750      * @dev internal logic for computing the pending payment of an `account` given the token historical balances and
751      * already released amounts.
752      */
753     function _pendingPayment(
754         address account,
755         uint256 totalReceived,
756         uint256 alreadyReleased
757     ) private view returns (uint256) {
758         return (totalReceived * _shares[account]) / _totalShares - alreadyReleased;
759     }
760 
761     /**
762      * @dev Add a new payee to the contract.
763      * @param account The address of the payee to add.
764      * @param shares_ The number of shares owned by the payee.
765      */
766     function _addPayee(address account, uint256 shares_) private {
767         require(account != address(0), "PaymentSplitter: account is the zero address");
768         require(shares_ > 0, "PaymentSplitter: shares are 0");
769         require(_shares[account] == 0, "PaymentSplitter: account already has shares");
770 
771         _payees.push(account);
772         _shares[account] = shares_;
773         _totalShares = _totalShares + shares_;
774         emit PayeeAdded(account, shares_);
775     }
776 }
777 
778 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721Receiver.sol
779 
780 
781 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
782 
783 pragma solidity ^0.8.0;
784 
785 /**
786  * @title ERC721 token receiver interface
787  * @dev Interface for any contract that wants to support safeTransfers
788  * from ERC721 asset contracts.
789  */
790 interface IERC721Receiver {
791     /**
792      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
793      * by `operator` from `from`, this function is called.
794      *
795      * It must return its Solidity selector to confirm the token transfer.
796      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
797      *
798      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
799      */
800     function onERC721Received(
801         address operator,
802         address from,
803         uint256 tokenId,
804         bytes calldata data
805     ) external returns (bytes4);
806 }
807 
808 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/IERC165.sol
809 
810 
811 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
812 
813 pragma solidity ^0.8.0;
814 
815 /**
816  * @dev Interface of the ERC165 standard, as defined in the
817  * https://eips.ethereum.org/EIPS/eip-165[EIP].
818  *
819  * Implementers can declare support of contract interfaces, which can then be
820  * queried by others ({ERC165Checker}).
821  *
822  * For an implementation, see {ERC165}.
823  */
824 interface IERC165 {
825     /**
826      * @dev Returns true if this contract implements the interface defined by
827      * `interfaceId`. See the corresponding
828      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
829      * to learn more about how these ids are created.
830      *
831      * This function call must use less than 30 000 gas.
832      */
833     function supportsInterface(bytes4 interfaceId) external view returns (bool);
834 }
835 
836 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/ERC165.sol
837 
838 
839 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
840 
841 pragma solidity ^0.8.0;
842 
843 
844 /**
845  * @dev Implementation of the {IERC165} interface.
846  *
847  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
848  * for the additional interface id that will be supported. For example:
849  *
850  * ```solidity
851  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
852  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
853  * }
854  * ```
855  *
856  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
857  */
858 abstract contract ERC165 is IERC165 {
859     /**
860      * @dev See {IERC165-supportsInterface}.
861      */
862     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
863         return interfaceId == type(IERC165).interfaceId;
864     }
865 }
866 
867 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721.sol
868 
869 
870 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
871 
872 pragma solidity ^0.8.0;
873 
874 
875 /**
876  * @dev Required interface of an ERC721 compliant contract.
877  */
878 interface IERC721 is IERC165 {
879     /**
880      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
881      */
882     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
883 
884     /**
885      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
886      */
887     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
888 
889     /**
890      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
891      */
892     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
893 
894     /**
895      * @dev Returns the number of tokens in ``owner``'s account.
896      */
897     function balanceOf(address owner) external view returns (uint256 balance);
898 
899     /**
900      * @dev Returns the owner of the `tokenId` token.
901      *
902      * Requirements:
903      *
904      * - `tokenId` must exist.
905      */
906     function ownerOf(uint256 tokenId) external view returns (address owner);
907 
908     /**
909      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
910      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
911      *
912      * Requirements:
913      *
914      * - `from` cannot be the zero address.
915      * - `to` cannot be the zero address.
916      * - `tokenId` token must exist and be owned by `from`.
917      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
918      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
919      *
920      * Emits a {Transfer} event.
921      */
922     function safeTransferFrom(
923         address from,
924         address to,
925         uint256 tokenId
926     ) external;
927 
928     /**
929      * @dev Transfers `tokenId` token from `from` to `to`.
930      *
931      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
932      *
933      * Requirements:
934      *
935      * - `from` cannot be the zero address.
936      * - `to` cannot be the zero address.
937      * - `tokenId` token must be owned by `from`.
938      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
939      *
940      * Emits a {Transfer} event.
941      */
942     function transferFrom(
943         address from,
944         address to,
945         uint256 tokenId
946     ) external;
947 
948     /**
949      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
950      * The approval is cleared when the token is transferred.
951      *
952      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
953      *
954      * Requirements:
955      *
956      * - The caller must own the token or be an approved operator.
957      * - `tokenId` must exist.
958      *
959      * Emits an {Approval} event.
960      */
961     function approve(address to, uint256 tokenId) external;
962 
963     /**
964      * @dev Returns the account approved for `tokenId` token.
965      *
966      * Requirements:
967      *
968      * - `tokenId` must exist.
969      */
970     function getApproved(uint256 tokenId) external view returns (address operator);
971 
972     /**
973      * @dev Approve or remove `operator` as an operator for the caller.
974      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
975      *
976      * Requirements:
977      *
978      * - The `operator` cannot be the caller.
979      *
980      * Emits an {ApprovalForAll} event.
981      */
982     function setApprovalForAll(address operator, bool _approved) external;
983 
984     /**
985      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
986      *
987      * See {setApprovalForAll}
988      */
989     function isApprovedForAll(address owner, address operator) external view returns (bool);
990 
991     /**
992      * @dev Safely transfers `tokenId` token from `from` to `to`.
993      *
994      * Requirements:
995      *
996      * - `from` cannot be the zero address.
997      * - `to` cannot be the zero address.
998      * - `tokenId` token must exist and be owned by `from`.
999      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1000      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1001      *
1002      * Emits a {Transfer} event.
1003      */
1004     function safeTransferFrom(
1005         address from,
1006         address to,
1007         uint256 tokenId,
1008         bytes calldata data
1009     ) external;
1010 }
1011 
1012 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/IERC721Metadata.sol
1013 
1014 
1015 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1016 
1017 pragma solidity ^0.8.0;
1018 
1019 
1020 /**
1021  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1022  * @dev See https://eips.ethereum.org/EIPS/eip-721
1023  */
1024 interface IERC721Metadata is IERC721 {
1025     /**
1026      * @dev Returns the token collection name.
1027      */
1028     function name() external view returns (string memory);
1029 
1030     /**
1031      * @dev Returns the token collection symbol.
1032      */
1033     function symbol() external view returns (string memory);
1034 
1035     /**
1036      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1037      */
1038     function tokenURI(uint256 tokenId) external view returns (string memory);
1039 }
1040 
1041 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol
1042 
1043 
1044 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
1045 
1046 pragma solidity ^0.8.0;
1047 
1048 
1049 
1050 
1051 
1052 
1053 
1054 
1055 /**
1056  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1057  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1058  * {ERC721Enumerable}.
1059  */
1060 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1061     using Address for address;
1062     using Strings for uint256;
1063 
1064     // Token name
1065     string private _name;
1066 
1067     // Token symbol
1068     string private _symbol;
1069 
1070     // Mapping from token ID to owner address
1071     mapping(uint256 => address) private _owners;
1072 
1073     // Mapping owner address to token count
1074     mapping(address => uint256) private _balances;
1075 
1076     // Mapping from token ID to approved address
1077     mapping(uint256 => address) private _tokenApprovals;
1078 
1079     // Mapping from owner to operator approvals
1080     mapping(address => mapping(address => bool)) private _operatorApprovals;
1081 
1082     /**
1083      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1084      */
1085     constructor(string memory name_, string memory symbol_) {
1086         _name = name_;
1087         _symbol = symbol_;
1088     }
1089 
1090     /**
1091      * @dev See {IERC165-supportsInterface}.
1092      */
1093     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1094         return
1095             interfaceId == type(IERC721).interfaceId ||
1096             interfaceId == type(IERC721Metadata).interfaceId ||
1097             super.supportsInterface(interfaceId);
1098     }
1099 
1100     /**
1101      * @dev See {IERC721-balanceOf}.
1102      */
1103     function balanceOf(address owner) public view virtual override returns (uint256) {
1104         require(owner != address(0), "ERC721: balance query for the zero address");
1105         return _balances[owner];
1106     }
1107 
1108     /**
1109      * @dev See {IERC721-ownerOf}.
1110      */
1111     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1112         address owner = _owners[tokenId];
1113         require(owner != address(0), "ERC721: owner query for nonexistent token");
1114         return owner;
1115     }
1116 
1117     /**
1118      * @dev See {IERC721Metadata-name}.
1119      */
1120     function name() public view virtual override returns (string memory) {
1121         return _name;
1122     }
1123 
1124     /**
1125      * @dev See {IERC721Metadata-symbol}.
1126      */
1127     function symbol() public view virtual override returns (string memory) {
1128         return _symbol;
1129     }
1130 
1131     /**
1132      * @dev See {IERC721Metadata-tokenURI}.
1133      */
1134     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1135         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1136 
1137         string memory baseURI = _baseURI();
1138         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1139     }
1140 
1141     /**
1142      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1143      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1144      * by default, can be overriden in child contracts.
1145      */
1146     function _baseURI() internal view virtual returns (string memory) {
1147         return "";
1148     }
1149 
1150     /**
1151      * @dev See {IERC721-approve}.
1152      */
1153     function approve(address to, uint256 tokenId) public virtual override {
1154         address owner = ERC721.ownerOf(tokenId);
1155         require(to != owner, "ERC721: approval to current owner");
1156 
1157         require(
1158             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1159             "ERC721: approve caller is not owner nor approved for all"
1160         );
1161 
1162         _approve(to, tokenId);
1163     }
1164 
1165     /**
1166      * @dev See {IERC721-getApproved}.
1167      */
1168     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1169         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1170 
1171         return _tokenApprovals[tokenId];
1172     }
1173 
1174     /**
1175      * @dev See {IERC721-setApprovalForAll}.
1176      */
1177     function setApprovalForAll(address operator, bool approved) public virtual override {
1178         _setApprovalForAll(_msgSender(), operator, approved);
1179     }
1180 
1181     /**
1182      * @dev See {IERC721-isApprovedForAll}.
1183      */
1184     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1185         return _operatorApprovals[owner][operator];
1186     }
1187 
1188     /**
1189      * @dev See {IERC721-transferFrom}.
1190      */
1191     function transferFrom(
1192         address from,
1193         address to,
1194         uint256 tokenId
1195     ) public virtual override {
1196         //solhint-disable-next-line max-line-length
1197         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1198 
1199         _transfer(from, to, tokenId);
1200     }
1201 
1202     /**
1203      * @dev See {IERC721-safeTransferFrom}.
1204      */
1205     function safeTransferFrom(
1206         address from,
1207         address to,
1208         uint256 tokenId
1209     ) public virtual override {
1210         safeTransferFrom(from, to, tokenId, "");
1211     }
1212 
1213     /**
1214      * @dev See {IERC721-safeTransferFrom}.
1215      */
1216     function safeTransferFrom(
1217         address from,
1218         address to,
1219         uint256 tokenId,
1220         bytes memory _data
1221     ) public virtual override {
1222         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1223         _safeTransfer(from, to, tokenId, _data);
1224     }
1225 
1226     /**
1227      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1228      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1229      *
1230      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1231      *
1232      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1233      * implement alternative mechanisms to perform token transfer, such as signature-based.
1234      *
1235      * Requirements:
1236      *
1237      * - `from` cannot be the zero address.
1238      * - `to` cannot be the zero address.
1239      * - `tokenId` token must exist and be owned by `from`.
1240      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1241      *
1242      * Emits a {Transfer} event.
1243      */
1244     function _safeTransfer(
1245         address from,
1246         address to,
1247         uint256 tokenId,
1248         bytes memory _data
1249     ) internal virtual {
1250         _transfer(from, to, tokenId);
1251         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1252     }
1253 
1254     /**
1255      * @dev Returns whether `tokenId` exists.
1256      *
1257      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1258      *
1259      * Tokens start existing when they are minted (`_mint`),
1260      * and stop existing when they are burned (`_burn`).
1261      */
1262     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1263         return _owners[tokenId] != address(0);
1264     }
1265 
1266     /**
1267      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1268      *
1269      * Requirements:
1270      *
1271      * - `tokenId` must exist.
1272      */
1273     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1274         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1275         address owner = ERC721.ownerOf(tokenId);
1276         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1277     }
1278 
1279     /**
1280      * @dev Safely mints `tokenId` and transfers it to `to`.
1281      *
1282      * Requirements:
1283      *
1284      * - `tokenId` must not exist.
1285      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1286      *
1287      * Emits a {Transfer} event.
1288      */
1289     function _safeMint(address to, uint256 tokenId) internal virtual {
1290         _safeMint(to, tokenId, "");
1291     }
1292 
1293     /**
1294      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1295      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1296      */
1297     function _safeMint(
1298         address to,
1299         uint256 tokenId,
1300         bytes memory _data
1301     ) internal virtual {
1302         _mint(to, tokenId);
1303         require(
1304             _checkOnERC721Received(address(0), to, tokenId, _data),
1305             "ERC721: transfer to non ERC721Receiver implementer"
1306         );
1307     }
1308 
1309     /**
1310      * @dev Mints `tokenId` and transfers it to `to`.
1311      *
1312      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1313      *
1314      * Requirements:
1315      *
1316      * - `tokenId` must not exist.
1317      * - `to` cannot be the zero address.
1318      *
1319      * Emits a {Transfer} event.
1320      */
1321     function _mint(address to, uint256 tokenId) internal virtual {
1322         require(to != address(0), "ERC721: mint to the zero address");
1323         require(!_exists(tokenId), "ERC721: token already minted");
1324 
1325         _beforeTokenTransfer(address(0), to, tokenId);
1326 
1327         _balances[to] += 1;
1328         _owners[tokenId] = to;
1329 
1330         emit Transfer(address(0), to, tokenId);
1331 
1332         _afterTokenTransfer(address(0), to, tokenId);
1333     }
1334 
1335     /**
1336      * @dev Destroys `tokenId`.
1337      * The approval is cleared when the token is burned.
1338      *
1339      * Requirements:
1340      *
1341      * - `tokenId` must exist.
1342      *
1343      * Emits a {Transfer} event.
1344      */
1345     function _burn(uint256 tokenId) internal virtual {
1346         address owner = ERC721.ownerOf(tokenId);
1347 
1348         _beforeTokenTransfer(owner, address(0), tokenId);
1349 
1350         // Clear approvals
1351         _approve(address(0), tokenId);
1352 
1353         _balances[owner] -= 1;
1354         delete _owners[tokenId];
1355 
1356         emit Transfer(owner, address(0), tokenId);
1357 
1358         _afterTokenTransfer(owner, address(0), tokenId);
1359     }
1360 
1361     /**
1362      * @dev Transfers `tokenId` from `from` to `to`.
1363      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1364      *
1365      * Requirements:
1366      *
1367      * - `to` cannot be the zero address.
1368      * - `tokenId` token must be owned by `from`.
1369      *
1370      * Emits a {Transfer} event.
1371      */
1372     function _transfer(
1373         address from,
1374         address to,
1375         uint256 tokenId
1376     ) internal virtual {
1377         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1378         require(to != address(0), "ERC721: transfer to the zero address");
1379 
1380         _beforeTokenTransfer(from, to, tokenId);
1381 
1382         // Clear approvals from the previous owner
1383         _approve(address(0), tokenId);
1384 
1385         _balances[from] -= 1;
1386         _balances[to] += 1;
1387         _owners[tokenId] = to;
1388 
1389         emit Transfer(from, to, tokenId);
1390 
1391         _afterTokenTransfer(from, to, tokenId);
1392     }
1393 
1394     /**
1395      * @dev Approve `to` to operate on `tokenId`
1396      *
1397      * Emits a {Approval} event.
1398      */
1399     function _approve(address to, uint256 tokenId) internal virtual {
1400         _tokenApprovals[tokenId] = to;
1401         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1402     }
1403 
1404     /**
1405      * @dev Approve `operator` to operate on all of `owner` tokens
1406      *
1407      * Emits a {ApprovalForAll} event.
1408      */
1409     function _setApprovalForAll(
1410         address owner,
1411         address operator,
1412         bool approved
1413     ) internal virtual {
1414         require(owner != operator, "ERC721: approve to caller");
1415         _operatorApprovals[owner][operator] = approved;
1416         emit ApprovalForAll(owner, operator, approved);
1417     }
1418 
1419     /**
1420      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1421      * The call is not executed if the target address is not a contract.
1422      *
1423      * @param from address representing the previous owner of the given token ID
1424      * @param to target address that will receive the tokens
1425      * @param tokenId uint256 ID of the token to be transferred
1426      * @param _data bytes optional data to send along with the call
1427      * @return bool whether the call correctly returned the expected magic value
1428      */
1429     function _checkOnERC721Received(
1430         address from,
1431         address to,
1432         uint256 tokenId,
1433         bytes memory _data
1434     ) private returns (bool) {
1435         if (to.isContract()) {
1436             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1437                 return retval == IERC721Receiver.onERC721Received.selector;
1438             } catch (bytes memory reason) {
1439                 if (reason.length == 0) {
1440                     revert("ERC721: transfer to non ERC721Receiver implementer");
1441                 } else {
1442                     assembly {
1443                         revert(add(32, reason), mload(reason))
1444                     }
1445                 }
1446             }
1447         } else {
1448             return true;
1449         }
1450     }
1451 
1452     /**
1453      * @dev Hook that is called before any token transfer. This includes minting
1454      * and burning.
1455      *
1456      * Calling conditions:
1457      *
1458      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1459      * transferred to `to`.
1460      * - When `from` is zero, `tokenId` will be minted for `to`.
1461      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1462      * - `from` and `to` are never both zero.
1463      *
1464      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1465      */
1466     function _beforeTokenTransfer(
1467         address from,
1468         address to,
1469         uint256 tokenId
1470     ) internal virtual {}
1471 
1472     /**
1473      * @dev Hook that is called after any transfer of tokens. This includes
1474      * minting and burning.
1475      *
1476      * Calling conditions:
1477      *
1478      * - when `from` and `to` are both non-zero.
1479      * - `from` and `to` are never both zero.
1480      *
1481      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1482      */
1483     function _afterTokenTransfer(
1484         address from,
1485         address to,
1486         uint256 tokenId
1487     ) internal virtual {}
1488 }
1489 
1490 // File: SombreroDonkeys/SombreroDonkeys.sol
1491 
1492 
1493 
1494 pragma solidity 0.8.7;
1495 
1496 
1497 
1498 
1499 contract SombreroDonkeys is ERC721, Ownable, PaymentSplitter {
1500 
1501     address[] private _team = [
1502         0xa24c32eAB894F8B35D65c6E0D08CC8cC6eD47d94, 
1503         0x98Ec77e2E8F663Bc93FDdB58a4B157e64B6D3c42,
1504         0x7f56b8062a743A7D09acE0126Bf4158890B01dBa,
1505         0x261d087bAb4F55Ed72D50e6253aee783690213e4,
1506         0xb13556dcAD8081A105c703f5B82E37ae19838Cf8
1507         ];
1508     
1509     uint256[] private _teamShares = [
1510         10,
1511         43,
1512         7,
1513         33,
1514         7
1515         ];
1516     
1517     uint public mintPrice;
1518     uint256 public maxSupply = 2700;
1519     uint public maxPerTransaction = 10;
1520     uint public tokenCount = 0;
1521     mapping(address => uint256) public Whitelist;
1522     bool public saleActive;
1523     bool public whitelistActive;
1524     bool public revealed;
1525     
1526     string public baseURI;
1527     
1528     constructor(uint _mintPrice) ERC721("Sombrero Donkeys", "SD") PaymentSplitter(_team, _teamShares) {
1529         //SET MINT PRICE
1530         mintPrice = _mintPrice;
1531         //50000000000000000
1532     }
1533     
1534     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1535         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1536         
1537         string memory base = _baseURI();
1538         if(!revealed){
1539             return bytes(base).length > 0 ? string(abi.encodePacked(base)) : "";
1540         }
1541         return bytes(base).length > 0 ? string(abi.encodePacked(base, uint2str(tokenId))) : "";
1542     }
1543     
1544     function _baseURI() internal view virtual override returns (string memory) {
1545         return baseURI;
1546     }
1547     
1548     function _setBaseURI(string memory _newBaseURI) public onlyOwner {
1549         baseURI = _newBaseURI;
1550     }
1551     function flipRevealed() public onlyOwner {
1552         revealed = !revealed;
1553     }
1554     
1555   	function setTotalSupply(uint _totalSupply) public onlyOwner{
1556   	    maxSupply = _totalSupply;
1557   	}
1558     
1559     function Mint(uint _count) public payable {
1560         
1561         require(saleActive == true || (whitelistActive == true && Whitelist[msg.sender] >= _count), "Normal Sale Not Active");
1562         require(_count <= maxPerTransaction, "Over maxPerTransaction");
1563         require(msg.value == mintPrice * _count, "Insuffcient Amount Sent");
1564         
1565         require(tokenCount + _count < maxSupply, "At Max Supply");
1566         
1567         
1568         for(uint i = 0; i < _count; i++){
1569             require(!super._exists(tokenCount), "Token ID Exists");
1570             _safeMint(msg.sender, tokenCount);
1571             tokenCount++;
1572         }
1573         if(Whitelist[msg.sender] > 0){
1574             Whitelist[msg.sender] = 0;
1575         }
1576     }
1577     function ownerMint(uint _count, address _to)public onlyOwner {
1578         require(tokenCount + _count < maxSupply, "At Max Supply");
1579         for(uint i = 0; i < _count; i++){
1580             require(!super._exists(tokenCount), "Token ID Exists");
1581             _safeMint(_to,tokenCount);
1582             tokenCount++;
1583         }
1584     }
1585     function addToWhitelist(address[] memory _address)public onlyOwner {
1586         for(uint i  = 0; i < _address.length; i++){
1587             Whitelist[_address[i]] = 1;
1588         }
1589     }
1590     function totalSupply() external view returns (uint256) {
1591         return tokenCount;
1592     }
1593     
1594     function flipWhitelist() public onlyOwner {
1595         whitelistActive = !whitelistActive;
1596     }
1597 
1598     function flipRegularSale() public onlyOwner {
1599         saleActive = !saleActive;
1600     }
1601     
1602     function setMintPrice(uint256 _mintPrice) external onlyOwner {
1603         mintPrice = _mintPrice;
1604     }
1605     
1606     function withdrawAll() external onlyOwner {
1607         for (uint256 i = 0; i < _team.length; i++) {
1608             address payable wallet = payable(_team[i]);
1609             release(wallet);
1610         }
1611     }
1612     
1613     function uint2str(uint _i) private pure returns (string memory _uintAsString) {
1614         if (_i == 0) {
1615             return "0";
1616         }
1617         uint j = _i;
1618         uint len;
1619         while (j != 0) {
1620             len++;
1621             j /= 10;
1622         }
1623         bytes memory bstr = new bytes(len);
1624         uint k = len;
1625         while (_i != 0) {
1626             k = k-1;
1627             uint8 temp = (48 + uint8(_i - _i / 10 * 10));
1628             bytes1 b1 = bytes1(temp);
1629             bstr[k] = b1;
1630             _i /= 10;
1631         }
1632         return string(bstr);
1633     }
1634 }