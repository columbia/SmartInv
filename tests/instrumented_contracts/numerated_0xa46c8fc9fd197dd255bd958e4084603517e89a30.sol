1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
3 
4 
5 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Interface of the ERC20 standard as defined in the EIP.
11  */
12 interface IERC20 {
13     /**
14      * @dev Returns the amount of tokens in existence.
15      */
16     function totalSupply() external view returns (uint256);
17 
18     /**
19      * @dev Returns the amount of tokens owned by `account`.
20      */
21     function balanceOf(address account) external view returns (uint256);
22 
23     /**
24      * @dev Moves `amount` tokens from the caller's account to `recipient`.
25      *
26      * Returns a boolean value indicating whether the operation succeeded.
27      *
28      * Emits a {Transfer} event.
29      */
30     function transfer(address recipient, uint256 amount) external returns (bool);
31 
32     /**
33      * @dev Returns the remaining number of tokens that `spender` will be
34      * allowed to spend on behalf of `owner` through {transferFrom}. This is
35      * zero by default.
36      *
37      * This value changes when {approve} or {transferFrom} are called.
38      */
39     function allowance(address owner, address spender) external view returns (uint256);
40 
41     /**
42      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
43      *
44      * Returns a boolean value indicating whether the operation succeeded.
45      *
46      * IMPORTANT: Beware that changing an allowance with this method brings the risk
47      * that someone may use both the old and the new allowance by unfortunate
48      * transaction ordering. One possible solution to mitigate this race
49      * condition is to first reduce the spender's allowance to 0 and set the
50      * desired value afterwards:
51      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
52      *
53      * Emits an {Approval} event.
54      */
55     function approve(address spender, uint256 amount) external returns (bool);
56 
57     /**
58      * @dev Moves `amount` tokens from `sender` to `recipient` using the
59      * allowance mechanism. `amount` is then deducted from the caller's
60      * allowance.
61      *
62      * Returns a boolean value indicating whether the operation succeeded.
63      *
64      * Emits a {Transfer} event.
65      */
66     function transferFrom(
67         address sender,
68         address recipient,
69         uint256 amount
70     ) external returns (bool);
71 
72     /**
73      * @dev Emitted when `value` tokens are moved from one account (`from`) to
74      * another (`to`).
75      *
76      * Note that `value` may be zero.
77      */
78     event Transfer(address indexed from, address indexed to, uint256 value);
79 
80     /**
81      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
82      * a call to {approve}. `value` is the new allowance.
83      */
84     event Approval(address indexed owner, address indexed spender, uint256 value);
85 }
86 
87 // File: @openzeppelin/contracts/utils/Counters.sol
88 
89 
90 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
91 
92 pragma solidity ^0.8.0;
93 
94 /**
95  * @title Counters
96  * @author Matt Condon (@shrugs)
97  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
98  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
99  *
100  * Include with `using Counters for Counters.Counter;`
101  */
102 library Counters {
103     struct Counter {
104         // This variable should never be directly accessed by users of the library: interactions must be restricted to
105         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
106         // this feature: see https://github.com/ethereum/solidity/issues/4637
107         uint256 _value; // default: 0
108     }
109 
110     function current(Counter storage counter) internal view returns (uint256) {
111         return counter._value;
112     }
113 
114     function increment(Counter storage counter) internal {
115         unchecked {
116             counter._value += 1;
117         }
118     }
119 
120     function decrement(Counter storage counter) internal {
121         uint256 value = counter._value;
122         require(value > 0, "Counter: decrement overflow");
123         unchecked {
124             counter._value = value - 1;
125         }
126     }
127 
128     function reset(Counter storage counter) internal {
129         counter._value = 0;
130     }
131 }
132 
133 // File: @openzeppelin/contracts/utils/Strings.sol
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
203 // File: @openzeppelin/contracts/utils/Context.sol
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
230 // File: @openzeppelin/contracts/access/Ownable.sol
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
308 // File: contracts/EWP/Pausable.sol
309 
310 
311 pragma solidity ^0.8.4;
312 
313 
314 /**
315  * @title Pausable
316  * @dev Base contract which allows children to implement an emergency stop mechanism.
317  */
318 contract Pausable is Ownable {
319     event Pause();
320     event Unpause();
321 
322     bool public paused = false;
323 
324     /**
325      * @dev Modifier to make a function callable only when the contract is not paused.
326      */
327     modifier whenNotPaused() {
328         require(!paused, "Transaction is not available");
329         _;
330     }
331 
332     /**
333      * @dev Modifier to make a function callable only when the contract is paused.
334      */
335     modifier whenPaused() {
336         require(paused, "Transaction is available");
337         _;
338     }
339 
340     /**
341      * @dev called by the owner to pause, triggers stopped state
342      */
343     function pause() public onlyOwner whenNotPaused {
344         paused = true;
345         emit Pause();
346     }
347 
348     /**
349      * @dev called by the owner to unpause, returns to normal state
350      */
351     function unpause() public onlyOwner whenPaused {
352         paused = false;
353         emit Unpause();
354     }
355 }
356 // File: @openzeppelin/contracts/utils/Address.sol
357 
358 
359 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
360 
361 pragma solidity ^0.8.0;
362 
363 /**
364  * @dev Collection of functions related to the address type
365  */
366 library Address {
367     /**
368      * @dev Returns true if `account` is a contract.
369      *
370      * [IMPORTANT]
371      * ====
372      * It is unsafe to assume that an address for which this function returns
373      * false is an externally-owned account (EOA) and not a contract.
374      *
375      * Among others, `isContract` will return false for the following
376      * types of addresses:
377      *
378      *  - an externally-owned account
379      *  - a contract in construction
380      *  - an address where a contract will be created
381      *  - an address where a contract lived, but was destroyed
382      * ====
383      */
384     function isContract(address account) internal view returns (bool) {
385         // This method relies on extcodesize, which returns 0 for contracts in
386         // construction, since the code is only stored at the end of the
387         // constructor execution.
388 
389         uint256 size;
390         assembly {
391             size := extcodesize(account)
392         }
393         return size > 0;
394     }
395 
396     /**
397      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
398      * `recipient`, forwarding all available gas and reverting on errors.
399      *
400      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
401      * of certain opcodes, possibly making contracts go over the 2300 gas limit
402      * imposed by `transfer`, making them unable to receive funds via
403      * `transfer`. {sendValue} removes this limitation.
404      *
405      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
406      *
407      * IMPORTANT: because control is transferred to `recipient`, care must be
408      * taken to not create reentrancy vulnerabilities. Consider using
409      * {ReentrancyGuard} or the
410      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
411      */
412     function sendValue(address payable recipient, uint256 amount) internal {
413         require(address(this).balance >= amount, "Address: insufficient balance");
414 
415         (bool success, ) = recipient.call{value: amount}("");
416         require(success, "Address: unable to send value, recipient may have reverted");
417     }
418 
419     /**
420      * @dev Performs a Solidity function call using a low level `call`. A
421      * plain `call` is an unsafe replacement for a function call: use this
422      * function instead.
423      *
424      * If `target` reverts with a revert reason, it is bubbled up by this
425      * function (like regular Solidity function calls).
426      *
427      * Returns the raw returned data. To convert to the expected return value,
428      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
429      *
430      * Requirements:
431      *
432      * - `target` must be a contract.
433      * - calling `target` with `data` must not revert.
434      *
435      * _Available since v3.1._
436      */
437     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
438         return functionCall(target, data, "Address: low-level call failed");
439     }
440 
441     /**
442      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
443      * `errorMessage` as a fallback revert reason when `target` reverts.
444      *
445      * _Available since v3.1._
446      */
447     function functionCall(
448         address target,
449         bytes memory data,
450         string memory errorMessage
451     ) internal returns (bytes memory) {
452         return functionCallWithValue(target, data, 0, errorMessage);
453     }
454 
455     /**
456      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
457      * but also transferring `value` wei to `target`.
458      *
459      * Requirements:
460      *
461      * - the calling contract must have an ETH balance of at least `value`.
462      * - the called Solidity function must be `payable`.
463      *
464      * _Available since v3.1._
465      */
466     function functionCallWithValue(
467         address target,
468         bytes memory data,
469         uint256 value
470     ) internal returns (bytes memory) {
471         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
472     }
473 
474     /**
475      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
476      * with `errorMessage` as a fallback revert reason when `target` reverts.
477      *
478      * _Available since v3.1._
479      */
480     function functionCallWithValue(
481         address target,
482         bytes memory data,
483         uint256 value,
484         string memory errorMessage
485     ) internal returns (bytes memory) {
486         require(address(this).balance >= value, "Address: insufficient balance for call");
487         require(isContract(target), "Address: call to non-contract");
488 
489         (bool success, bytes memory returndata) = target.call{value: value}(data);
490         return verifyCallResult(success, returndata, errorMessage);
491     }
492 
493     /**
494      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
495      * but performing a static call.
496      *
497      * _Available since v3.3._
498      */
499     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
500         return functionStaticCall(target, data, "Address: low-level static call failed");
501     }
502 
503     /**
504      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
505      * but performing a static call.
506      *
507      * _Available since v3.3._
508      */
509     function functionStaticCall(
510         address target,
511         bytes memory data,
512         string memory errorMessage
513     ) internal view returns (bytes memory) {
514         require(isContract(target), "Address: static call to non-contract");
515 
516         (bool success, bytes memory returndata) = target.staticcall(data);
517         return verifyCallResult(success, returndata, errorMessage);
518     }
519 
520     /**
521      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
522      * but performing a delegate call.
523      *
524      * _Available since v3.4._
525      */
526     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
527         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
528     }
529 
530     /**
531      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
532      * but performing a delegate call.
533      *
534      * _Available since v3.4._
535      */
536     function functionDelegateCall(
537         address target,
538         bytes memory data,
539         string memory errorMessage
540     ) internal returns (bytes memory) {
541         require(isContract(target), "Address: delegate call to non-contract");
542 
543         (bool success, bytes memory returndata) = target.delegatecall(data);
544         return verifyCallResult(success, returndata, errorMessage);
545     }
546 
547     /**
548      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
549      * revert reason using the provided one.
550      *
551      * _Available since v4.3._
552      */
553     function verifyCallResult(
554         bool success,
555         bytes memory returndata,
556         string memory errorMessage
557     ) internal pure returns (bytes memory) {
558         if (success) {
559             return returndata;
560         } else {
561             // Look for revert reason and bubble it up if present
562             if (returndata.length > 0) {
563                 // The easiest way to bubble the revert reason is using memory via assembly
564 
565                 assembly {
566                     let returndata_size := mload(returndata)
567                     revert(add(32, returndata), returndata_size)
568                 }
569             } else {
570                 revert(errorMessage);
571             }
572         }
573     }
574 }
575 
576 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
577 
578 
579 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
580 
581 pragma solidity ^0.8.0;
582 
583 
584 
585 /**
586  * @title SafeERC20
587  * @dev Wrappers around ERC20 operations that throw on failure (when the token
588  * contract returns false). Tokens that return no value (and instead revert or
589  * throw on failure) are also supported, non-reverting calls are assumed to be
590  * successful.
591  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
592  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
593  */
594 library SafeERC20 {
595     using Address for address;
596 
597     function safeTransfer(
598         IERC20 token,
599         address to,
600         uint256 value
601     ) internal {
602         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
603     }
604 
605     function safeTransferFrom(
606         IERC20 token,
607         address from,
608         address to,
609         uint256 value
610     ) internal {
611         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
612     }
613 
614     /**
615      * @dev Deprecated. This function has issues similar to the ones found in
616      * {IERC20-approve}, and its usage is discouraged.
617      *
618      * Whenever possible, use {safeIncreaseAllowance} and
619      * {safeDecreaseAllowance} instead.
620      */
621     function safeApprove(
622         IERC20 token,
623         address spender,
624         uint256 value
625     ) internal {
626         // safeApprove should only be called when setting an initial allowance,
627         // or when resetting it to zero. To increase and decrease it, use
628         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
629         require(
630             (value == 0) || (token.allowance(address(this), spender) == 0),
631             "SafeERC20: approve from non-zero to non-zero allowance"
632         );
633         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
634     }
635 
636     function safeIncreaseAllowance(
637         IERC20 token,
638         address spender,
639         uint256 value
640     ) internal {
641         uint256 newAllowance = token.allowance(address(this), spender) + value;
642         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
643     }
644 
645     function safeDecreaseAllowance(
646         IERC20 token,
647         address spender,
648         uint256 value
649     ) internal {
650         unchecked {
651             uint256 oldAllowance = token.allowance(address(this), spender);
652             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
653             uint256 newAllowance = oldAllowance - value;
654             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
655         }
656     }
657 
658     /**
659      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
660      * on the return value: the return value is optional (but if data is returned, it must not be false).
661      * @param token The token targeted by the call.
662      * @param data The call data (encoded using abi.encode or one of its variants).
663      */
664     function _callOptionalReturn(IERC20 token, bytes memory data) private {
665         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
666         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
667         // the target address contains contract code and also asserts for success in the low-level call.
668 
669         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
670         if (returndata.length > 0) {
671             // Return data is optional
672             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
673         }
674     }
675 }
676 
677 // File: @openzeppelin/contracts/finance/PaymentSplitter.sol
678 
679 
680 // OpenZeppelin Contracts v4.4.1 (finance/PaymentSplitter.sol)
681 
682 pragma solidity ^0.8.0;
683 
684 
685 
686 
687 /**
688  * @title PaymentSplitter
689  * @dev This contract allows to split Ether payments among a group of accounts. The sender does not need to be aware
690  * that the Ether will be split in this way, since it is handled transparently by the contract.
691  *
692  * The split can be in equal parts or in any other arbitrary proportion. The way this is specified is by assigning each
693  * account to a number of shares. Of all the Ether that this contract receives, each account will then be able to claim
694  * an amount proportional to the percentage of total shares they were assigned.
695  *
696  * `PaymentSplitter` follows a _pull payment_ model. This means that payments are not automatically forwarded to the
697  * accounts but kept in this contract, and the actual transfer is triggered as a separate step by calling the {release}
698  * function.
699  *
700  * NOTE: This contract assumes that ERC20 tokens will behave similarly to native tokens (Ether). Rebasing tokens, and
701  * tokens that apply fees during transfers, are likely to not be supported as expected. If in doubt, we encourage you
702  * to run tests before sending real value to this contract.
703  */
704 contract PaymentSplitter is Context {
705     event PayeeAdded(address account, uint256 shares);
706     event PaymentReleased(address to, uint256 amount);
707     event ERC20PaymentReleased(IERC20 indexed token, address to, uint256 amount);
708     event PaymentReceived(address from, uint256 amount);
709 
710     uint256 private _totalShares;
711     uint256 private _totalReleased;
712 
713     mapping(address => uint256) private _shares;
714     mapping(address => uint256) private _released;
715     address[] private _payees;
716 
717     mapping(IERC20 => uint256) private _erc20TotalReleased;
718     mapping(IERC20 => mapping(address => uint256)) private _erc20Released;
719 
720     /**
721      * @dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at
722      * the matching position in the `shares` array.
723      *
724      * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no
725      * duplicates in `payees`.
726      */
727     constructor(address[] memory payees, uint256[] memory shares_) payable {
728         require(payees.length == shares_.length, "PaymentSplitter: payees and shares length mismatch");
729         require(payees.length > 0, "PaymentSplitter: no payees");
730 
731         for (uint256 i = 0; i < payees.length; i++) {
732             _addPayee(payees[i], shares_[i]);
733         }
734     }
735 
736     /**
737      * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully
738      * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
739      * reliability of the events, and not the actual splitting of Ether.
740      *
741      * To learn more about this see the Solidity documentation for
742      * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
743      * functions].
744      */
745     receive() external payable virtual {
746         emit PaymentReceived(_msgSender(), msg.value);
747     }
748 
749     /**
750      * @dev Getter for the total shares held by payees.
751      */
752     function totalShares() public view returns (uint256) {
753         return _totalShares;
754     }
755 
756     /**
757      * @dev Getter for the total amount of Ether already released.
758      */
759     function totalReleased() public view returns (uint256) {
760         return _totalReleased;
761     }
762 
763     /**
764      * @dev Getter for the total amount of `token` already released. `token` should be the address of an IERC20
765      * contract.
766      */
767     function totalReleased(IERC20 token) public view returns (uint256) {
768         return _erc20TotalReleased[token];
769     }
770 
771     /**
772      * @dev Getter for the amount of shares held by an account.
773      */
774     function shares(address account) public view returns (uint256) {
775         return _shares[account];
776     }
777 
778     /**
779      * @dev Getter for the amount of Ether already released to a payee.
780      */
781     function released(address account) public view returns (uint256) {
782         return _released[account];
783     }
784 
785     /**
786      * @dev Getter for the amount of `token` tokens already released to a payee. `token` should be the address of an
787      * IERC20 contract.
788      */
789     function released(IERC20 token, address account) public view returns (uint256) {
790         return _erc20Released[token][account];
791     }
792 
793     /**
794      * @dev Getter for the address of the payee number `index`.
795      */
796     function payee(uint256 index) public view returns (address) {
797         return _payees[index];
798     }
799 
800     /**
801      * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
802      * total shares and their previous withdrawals.
803      */
804     function release(address payable account) public virtual {
805         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
806 
807         uint256 totalReceived = address(this).balance + totalReleased();
808         uint256 payment = _pendingPayment(account, totalReceived, released(account));
809 
810         require(payment != 0, "PaymentSplitter: account is not due payment");
811 
812         _released[account] += payment;
813         _totalReleased += payment;
814 
815         Address.sendValue(account, payment);
816         emit PaymentReleased(account, payment);
817     }
818 
819     /**
820      * @dev Triggers a transfer to `account` of the amount of `token` tokens they are owed, according to their
821      * percentage of the total shares and their previous withdrawals. `token` must be the address of an IERC20
822      * contract.
823      */
824     function release(IERC20 token, address account) public virtual {
825         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
826 
827         uint256 totalReceived = token.balanceOf(address(this)) + totalReleased(token);
828         uint256 payment = _pendingPayment(account, totalReceived, released(token, account));
829 
830         require(payment != 0, "PaymentSplitter: account is not due payment");
831 
832         _erc20Released[token][account] += payment;
833         _erc20TotalReleased[token] += payment;
834 
835         SafeERC20.safeTransfer(token, account, payment);
836         emit ERC20PaymentReleased(token, account, payment);
837     }
838 
839     /**
840      * @dev internal logic for computing the pending payment of an `account` given the token historical balances and
841      * already released amounts.
842      */
843     function _pendingPayment(
844         address account,
845         uint256 totalReceived,
846         uint256 alreadyReleased
847     ) private view returns (uint256) {
848         return (totalReceived * _shares[account]) / _totalShares - alreadyReleased;
849     }
850 
851     /**
852      * @dev Add a new payee to the contract.
853      * @param account The address of the payee to add.
854      * @param shares_ The number of shares owned by the payee.
855      */
856     function _addPayee(address account, uint256 shares_) private {
857         require(account != address(0), "PaymentSplitter: account is the zero address");
858         require(shares_ > 0, "PaymentSplitter: shares are 0");
859         require(_shares[account] == 0, "PaymentSplitter: account already has shares");
860 
861         _payees.push(account);
862         _shares[account] = shares_;
863         _totalShares = _totalShares + shares_;
864         emit PayeeAdded(account, shares_);
865     }
866 }
867 
868 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
869 
870 
871 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
872 
873 pragma solidity ^0.8.0;
874 
875 /**
876  * @title ERC721 token receiver interface
877  * @dev Interface for any contract that wants to support safeTransfers
878  * from ERC721 asset contracts.
879  */
880 interface IERC721Receiver {
881     /**
882      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
883      * by `operator` from `from`, this function is called.
884      *
885      * It must return its Solidity selector to confirm the token transfer.
886      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
887      *
888      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
889      */
890     function onERC721Received(
891         address operator,
892         address from,
893         uint256 tokenId,
894         bytes calldata data
895     ) external returns (bytes4);
896 }
897 
898 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
899 
900 
901 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
902 
903 pragma solidity ^0.8.0;
904 
905 /**
906  * @dev Interface of the ERC165 standard, as defined in the
907  * https://eips.ethereum.org/EIPS/eip-165[EIP].
908  *
909  * Implementers can declare support of contract interfaces, which can then be
910  * queried by others ({ERC165Checker}).
911  *
912  * For an implementation, see {ERC165}.
913  */
914 interface IERC165 {
915     /**
916      * @dev Returns true if this contract implements the interface defined by
917      * `interfaceId`. See the corresponding
918      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
919      * to learn more about how these ids are created.
920      *
921      * This function call must use less than 30 000 gas.
922      */
923     function supportsInterface(bytes4 interfaceId) external view returns (bool);
924 }
925 
926 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
927 
928 
929 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
930 
931 pragma solidity ^0.8.0;
932 
933 
934 /**
935  * @dev Implementation of the {IERC165} interface.
936  *
937  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
938  * for the additional interface id that will be supported. For example:
939  *
940  * ```solidity
941  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
942  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
943  * }
944  * ```
945  *
946  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
947  */
948 abstract contract ERC165 is IERC165 {
949     /**
950      * @dev See {IERC165-supportsInterface}.
951      */
952     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
953         return interfaceId == type(IERC165).interfaceId;
954     }
955 }
956 
957 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
958 
959 
960 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
961 
962 pragma solidity ^0.8.0;
963 
964 
965 /**
966  * @dev Required interface of an ERC721 compliant contract.
967  */
968 interface IERC721 is IERC165 {
969     /**
970      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
971      */
972     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
973 
974     /**
975      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
976      */
977     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
978 
979     /**
980      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
981      */
982     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
983 
984     /**
985      * @dev Returns the number of tokens in ``owner``'s account.
986      */
987     function balanceOf(address owner) external view returns (uint256 balance);
988 
989     /**
990      * @dev Returns the owner of the `tokenId` token.
991      *
992      * Requirements:
993      *
994      * - `tokenId` must exist.
995      */
996     function ownerOf(uint256 tokenId) external view returns (address owner);
997 
998     /**
999      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1000      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1001      *
1002      * Requirements:
1003      *
1004      * - `from` cannot be the zero address.
1005      * - `to` cannot be the zero address.
1006      * - `tokenId` token must exist and be owned by `from`.
1007      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1008      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1009      *
1010      * Emits a {Transfer} event.
1011      */
1012     function safeTransferFrom(
1013         address from,
1014         address to,
1015         uint256 tokenId
1016     ) external;
1017 
1018     /**
1019      * @dev Transfers `tokenId` token from `from` to `to`.
1020      *
1021      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1022      *
1023      * Requirements:
1024      *
1025      * - `from` cannot be the zero address.
1026      * - `to` cannot be the zero address.
1027      * - `tokenId` token must be owned by `from`.
1028      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1029      *
1030      * Emits a {Transfer} event.
1031      */
1032     function transferFrom(
1033         address from,
1034         address to,
1035         uint256 tokenId
1036     ) external;
1037 
1038     /**
1039      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1040      * The approval is cleared when the token is transferred.
1041      *
1042      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1043      *
1044      * Requirements:
1045      *
1046      * - The caller must own the token or be an approved operator.
1047      * - `tokenId` must exist.
1048      *
1049      * Emits an {Approval} event.
1050      */
1051     function approve(address to, uint256 tokenId) external;
1052 
1053     /**
1054      * @dev Returns the account approved for `tokenId` token.
1055      *
1056      * Requirements:
1057      *
1058      * - `tokenId` must exist.
1059      */
1060     function getApproved(uint256 tokenId) external view returns (address operator);
1061 
1062     /**
1063      * @dev Approve or remove `operator` as an operator for the caller.
1064      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1065      *
1066      * Requirements:
1067      *
1068      * - The `operator` cannot be the caller.
1069      *
1070      * Emits an {ApprovalForAll} event.
1071      */
1072     function setApprovalForAll(address operator, bool _approved) external;
1073 
1074     /**
1075      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1076      *
1077      * See {setApprovalForAll}
1078      */
1079     function isApprovedForAll(address owner, address operator) external view returns (bool);
1080 
1081     /**
1082      * @dev Safely transfers `tokenId` token from `from` to `to`.
1083      *
1084      * Requirements:
1085      *
1086      * - `from` cannot be the zero address.
1087      * - `to` cannot be the zero address.
1088      * - `tokenId` token must exist and be owned by `from`.
1089      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1090      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1091      *
1092      * Emits a {Transfer} event.
1093      */
1094     function safeTransferFrom(
1095         address from,
1096         address to,
1097         uint256 tokenId,
1098         bytes calldata data
1099     ) external;
1100 }
1101 
1102 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1103 
1104 
1105 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
1106 
1107 pragma solidity ^0.8.0;
1108 
1109 
1110 /**
1111  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1112  * @dev See https://eips.ethereum.org/EIPS/eip-721
1113  */
1114 interface IERC721Enumerable is IERC721 {
1115     /**
1116      * @dev Returns the total amount of tokens stored by the contract.
1117      */
1118     function totalSupply() external view returns (uint256);
1119 
1120     /**
1121      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1122      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1123      */
1124     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1125 
1126     /**
1127      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1128      * Use along with {totalSupply} to enumerate all tokens.
1129      */
1130     function tokenByIndex(uint256 index) external view returns (uint256);
1131 }
1132 
1133 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1134 
1135 
1136 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1137 
1138 pragma solidity ^0.8.0;
1139 
1140 
1141 /**
1142  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1143  * @dev See https://eips.ethereum.org/EIPS/eip-721
1144  */
1145 interface IERC721Metadata is IERC721 {
1146     /**
1147      * @dev Returns the token collection name.
1148      */
1149     function name() external view returns (string memory);
1150 
1151     /**
1152      * @dev Returns the token collection symbol.
1153      */
1154     function symbol() external view returns (string memory);
1155 
1156     /**
1157      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1158      */
1159     function tokenURI(uint256 tokenId) external view returns (string memory);
1160 }
1161 
1162 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1163 
1164 
1165 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
1166 
1167 pragma solidity ^0.8.0;
1168 
1169 
1170 
1171 
1172 
1173 
1174 
1175 
1176 /**
1177  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1178  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1179  * {ERC721Enumerable}.
1180  */
1181 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1182     using Address for address;
1183     using Strings for uint256;
1184 
1185     // Token name
1186     string private _name;
1187 
1188     // Token symbol
1189     string private _symbol;
1190 
1191     // Mapping from token ID to owner address
1192     mapping(uint256 => address) private _owners;
1193 
1194     // Mapping owner address to token count
1195     mapping(address => uint256) private _balances;
1196 
1197     // Mapping from token ID to approved address
1198     mapping(uint256 => address) private _tokenApprovals;
1199 
1200     // Mapping from owner to operator approvals
1201     mapping(address => mapping(address => bool)) private _operatorApprovals;
1202 
1203     /**
1204      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1205      */
1206     constructor(string memory name_, string memory symbol_) {
1207         _name = name_;
1208         _symbol = symbol_;
1209     }
1210 
1211     /**
1212      * @dev See {IERC165-supportsInterface}.
1213      */
1214     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1215         return
1216             interfaceId == type(IERC721).interfaceId ||
1217             interfaceId == type(IERC721Metadata).interfaceId ||
1218             super.supportsInterface(interfaceId);
1219     }
1220 
1221     /**
1222      * @dev See {IERC721-balanceOf}.
1223      */
1224     function balanceOf(address owner) public view virtual override returns (uint256) {
1225         require(owner != address(0), "ERC721: balance query for the zero address");
1226         return _balances[owner];
1227     }
1228 
1229     /**
1230      * @dev See {IERC721-ownerOf}.
1231      */
1232     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1233         address owner = _owners[tokenId];
1234         require(owner != address(0), "ERC721: owner query for nonexistent token");
1235         return owner;
1236     }
1237 
1238     /**
1239      * @dev See {IERC721Metadata-name}.
1240      */
1241     function name() public view virtual override returns (string memory) {
1242         return _name;
1243     }
1244 
1245     /**
1246      * @dev See {IERC721Metadata-symbol}.
1247      */
1248     function symbol() public view virtual override returns (string memory) {
1249         return _symbol;
1250     }
1251 
1252     /**
1253      * @dev See {IERC721Metadata-tokenURI}.
1254      */
1255     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1256         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1257 
1258         string memory baseURI = _baseURI();
1259         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1260     }
1261 
1262     /**
1263      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1264      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1265      * by default, can be overriden in child contracts.
1266      */
1267     function _baseURI() internal view virtual returns (string memory) {
1268         return "";
1269     }
1270 
1271     /**
1272      * @dev See {IERC721-approve}.
1273      */
1274     function approve(address to, uint256 tokenId) public virtual override {
1275         address owner = ERC721.ownerOf(tokenId);
1276         require(to != owner, "ERC721: approval to current owner");
1277 
1278         require(
1279             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1280             "ERC721: approve caller is not owner nor approved for all"
1281         );
1282 
1283         _approve(to, tokenId);
1284     }
1285 
1286     /**
1287      * @dev See {IERC721-getApproved}.
1288      */
1289     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1290         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1291 
1292         return _tokenApprovals[tokenId];
1293     }
1294 
1295     /**
1296      * @dev See {IERC721-setApprovalForAll}.
1297      */
1298     function setApprovalForAll(address operator, bool approved) public virtual override {
1299         _setApprovalForAll(_msgSender(), operator, approved);
1300     }
1301 
1302     /**
1303      * @dev See {IERC721-isApprovedForAll}.
1304      */
1305     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1306         return _operatorApprovals[owner][operator];
1307     }
1308 
1309     /**
1310      * @dev See {IERC721-transferFrom}.
1311      */
1312     function transferFrom(
1313         address from,
1314         address to,
1315         uint256 tokenId
1316     ) public virtual override {
1317         //solhint-disable-next-line max-line-length
1318         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1319 
1320         _transfer(from, to, tokenId);
1321     }
1322 
1323     /**
1324      * @dev See {IERC721-safeTransferFrom}.
1325      */
1326     function safeTransferFrom(
1327         address from,
1328         address to,
1329         uint256 tokenId
1330     ) public virtual override {
1331         safeTransferFrom(from, to, tokenId, "");
1332     }
1333 
1334     /**
1335      * @dev See {IERC721-safeTransferFrom}.
1336      */
1337     function safeTransferFrom(
1338         address from,
1339         address to,
1340         uint256 tokenId,
1341         bytes memory _data
1342     ) public virtual override {
1343         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1344         _safeTransfer(from, to, tokenId, _data);
1345     }
1346 
1347     /**
1348      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1349      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1350      *
1351      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1352      *
1353      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1354      * implement alternative mechanisms to perform token transfer, such as signature-based.
1355      *
1356      * Requirements:
1357      *
1358      * - `from` cannot be the zero address.
1359      * - `to` cannot be the zero address.
1360      * - `tokenId` token must exist and be owned by `from`.
1361      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1362      *
1363      * Emits a {Transfer} event.
1364      */
1365     function _safeTransfer(
1366         address from,
1367         address to,
1368         uint256 tokenId,
1369         bytes memory _data
1370     ) internal virtual {
1371         _transfer(from, to, tokenId);
1372         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1373     }
1374 
1375     /**
1376      * @dev Returns whether `tokenId` exists.
1377      *
1378      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1379      *
1380      * Tokens start existing when they are minted (`_mint`),
1381      * and stop existing when they are burned (`_burn`).
1382      */
1383     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1384         return _owners[tokenId] != address(0);
1385     }
1386 
1387     /**
1388      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1389      *
1390      * Requirements:
1391      *
1392      * - `tokenId` must exist.
1393      */
1394     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1395         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1396         address owner = ERC721.ownerOf(tokenId);
1397         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1398     }
1399 
1400     /**
1401      * @dev Safely mints `tokenId` and transfers it to `to`.
1402      *
1403      * Requirements:
1404      *
1405      * - `tokenId` must not exist.
1406      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1407      *
1408      * Emits a {Transfer} event.
1409      */
1410     function _safeMint(address to, uint256 tokenId) internal virtual {
1411         _safeMint(to, tokenId, "");
1412     }
1413 
1414     /**
1415      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1416      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1417      */
1418     function _safeMint(
1419         address to,
1420         uint256 tokenId,
1421         bytes memory _data
1422     ) internal virtual {
1423         _mint(to, tokenId);
1424         require(
1425             _checkOnERC721Received(address(0), to, tokenId, _data),
1426             "ERC721: transfer to non ERC721Receiver implementer"
1427         );
1428     }
1429 
1430     /**
1431      * @dev Mints `tokenId` and transfers it to `to`.
1432      *
1433      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1434      *
1435      * Requirements:
1436      *
1437      * - `tokenId` must not exist.
1438      * - `to` cannot be the zero address.
1439      *
1440      * Emits a {Transfer} event.
1441      */
1442     function _mint(address to, uint256 tokenId) internal virtual {
1443         require(to != address(0), "ERC721: mint to the zero address");
1444         require(!_exists(tokenId), "ERC721: token already minted");
1445 
1446         _beforeTokenTransfer(address(0), to, tokenId);
1447 
1448         _balances[to] += 1;
1449         _owners[tokenId] = to;
1450 
1451         emit Transfer(address(0), to, tokenId);
1452     }
1453 
1454     /**
1455      * @dev Destroys `tokenId`.
1456      * The approval is cleared when the token is burned.
1457      *
1458      * Requirements:
1459      *
1460      * - `tokenId` must exist.
1461      *
1462      * Emits a {Transfer} event.
1463      */
1464     function _burn(uint256 tokenId) internal virtual {
1465         address owner = ERC721.ownerOf(tokenId);
1466 
1467         _beforeTokenTransfer(owner, address(0), tokenId);
1468 
1469         // Clear approvals
1470         _approve(address(0), tokenId);
1471 
1472         _balances[owner] -= 1;
1473         delete _owners[tokenId];
1474 
1475         emit Transfer(owner, address(0), tokenId);
1476     }
1477 
1478     /**
1479      * @dev Transfers `tokenId` from `from` to `to`.
1480      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1481      *
1482      * Requirements:
1483      *
1484      * - `to` cannot be the zero address.
1485      * - `tokenId` token must be owned by `from`.
1486      *
1487      * Emits a {Transfer} event.
1488      */
1489     function _transfer(
1490         address from,
1491         address to,
1492         uint256 tokenId
1493     ) internal virtual {
1494         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1495         require(to != address(0), "ERC721: transfer to the zero address");
1496 
1497         _beforeTokenTransfer(from, to, tokenId);
1498 
1499         // Clear approvals from the previous owner
1500         _approve(address(0), tokenId);
1501 
1502         _balances[from] -= 1;
1503         _balances[to] += 1;
1504         _owners[tokenId] = to;
1505 
1506         emit Transfer(from, to, tokenId);
1507     }
1508 
1509     /**
1510      * @dev Approve `to` to operate on `tokenId`
1511      *
1512      * Emits a {Approval} event.
1513      */
1514     function _approve(address to, uint256 tokenId) internal virtual {
1515         _tokenApprovals[tokenId] = to;
1516         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1517     }
1518 
1519     /**
1520      * @dev Approve `operator` to operate on all of `owner` tokens
1521      *
1522      * Emits a {ApprovalForAll} event.
1523      */
1524     function _setApprovalForAll(
1525         address owner,
1526         address operator,
1527         bool approved
1528     ) internal virtual {
1529         require(owner != operator, "ERC721: approve to caller");
1530         _operatorApprovals[owner][operator] = approved;
1531         emit ApprovalForAll(owner, operator, approved);
1532     }
1533 
1534     /**
1535      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1536      * The call is not executed if the target address is not a contract.
1537      *
1538      * @param from address representing the previous owner of the given token ID
1539      * @param to target address that will receive the tokens
1540      * @param tokenId uint256 ID of the token to be transferred
1541      * @param _data bytes optional data to send along with the call
1542      * @return bool whether the call correctly returned the expected magic value
1543      */
1544     function _checkOnERC721Received(
1545         address from,
1546         address to,
1547         uint256 tokenId,
1548         bytes memory _data
1549     ) private returns (bool) {
1550         if (to.isContract()) {
1551             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1552                 return retval == IERC721Receiver.onERC721Received.selector;
1553             } catch (bytes memory reason) {
1554                 if (reason.length == 0) {
1555                     revert("ERC721: transfer to non ERC721Receiver implementer");
1556                 } else {
1557                     assembly {
1558                         revert(add(32, reason), mload(reason))
1559                     }
1560                 }
1561             }
1562         } else {
1563             return true;
1564         }
1565     }
1566 
1567     /**
1568      * @dev Hook that is called before any token transfer. This includes minting
1569      * and burning.
1570      *
1571      * Calling conditions:
1572      *
1573      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1574      * transferred to `to`.
1575      * - When `from` is zero, `tokenId` will be minted for `to`.
1576      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1577      * - `from` and `to` are never both zero.
1578      *
1579      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1580      */
1581     function _beforeTokenTransfer(
1582         address from,
1583         address to,
1584         uint256 tokenId
1585     ) internal virtual {}
1586 }
1587 
1588 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1589 
1590 
1591 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1592 
1593 pragma solidity ^0.8.0;
1594 
1595 
1596 
1597 /**
1598  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1599  * enumerability of all the token ids in the contract as well as all token ids owned by each
1600  * account.
1601  */
1602 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1603     // Mapping from owner to list of owned token IDs
1604     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1605 
1606     // Mapping from token ID to index of the owner tokens list
1607     mapping(uint256 => uint256) private _ownedTokensIndex;
1608 
1609     // Array with all token ids, used for enumeration
1610     uint256[] private _allTokens;
1611 
1612     // Mapping from token id to position in the allTokens array
1613     mapping(uint256 => uint256) private _allTokensIndex;
1614 
1615     /**
1616      * @dev See {IERC165-supportsInterface}.
1617      */
1618     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1619         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1620     }
1621 
1622     /**
1623      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1624      */
1625     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1626         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1627         return _ownedTokens[owner][index];
1628     }
1629 
1630     /**
1631      * @dev See {IERC721Enumerable-totalSupply}.
1632      */
1633     function totalSupply() public view virtual override returns (uint256) {
1634         return _allTokens.length;
1635     }
1636 
1637     /**
1638      * @dev See {IERC721Enumerable-tokenByIndex}.
1639      */
1640     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1641         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1642         return _allTokens[index];
1643     }
1644 
1645     /**
1646      * @dev Hook that is called before any token transfer. This includes minting
1647      * and burning.
1648      *
1649      * Calling conditions:
1650      *
1651      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1652      * transferred to `to`.
1653      * - When `from` is zero, `tokenId` will be minted for `to`.
1654      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1655      * - `from` cannot be the zero address.
1656      * - `to` cannot be the zero address.
1657      *
1658      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1659      */
1660     function _beforeTokenTransfer(
1661         address from,
1662         address to,
1663         uint256 tokenId
1664     ) internal virtual override {
1665         super._beforeTokenTransfer(from, to, tokenId);
1666 
1667         if (from == address(0)) {
1668             _addTokenToAllTokensEnumeration(tokenId);
1669         } else if (from != to) {
1670             _removeTokenFromOwnerEnumeration(from, tokenId);
1671         }
1672         if (to == address(0)) {
1673             _removeTokenFromAllTokensEnumeration(tokenId);
1674         } else if (to != from) {
1675             _addTokenToOwnerEnumeration(to, tokenId);
1676         }
1677     }
1678 
1679     /**
1680      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1681      * @param to address representing the new owner of the given token ID
1682      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1683      */
1684     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1685         uint256 length = ERC721.balanceOf(to);
1686         _ownedTokens[to][length] = tokenId;
1687         _ownedTokensIndex[tokenId] = length;
1688     }
1689 
1690     /**
1691      * @dev Private function to add a token to this extension's token tracking data structures.
1692      * @param tokenId uint256 ID of the token to be added to the tokens list
1693      */
1694     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1695         _allTokensIndex[tokenId] = _allTokens.length;
1696         _allTokens.push(tokenId);
1697     }
1698 
1699     /**
1700      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1701      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1702      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1703      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1704      * @param from address representing the previous owner of the given token ID
1705      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1706      */
1707     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1708         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1709         // then delete the last slot (swap and pop).
1710 
1711         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1712         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1713 
1714         // When the token to delete is the last token, the swap operation is unnecessary
1715         if (tokenIndex != lastTokenIndex) {
1716             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1717 
1718             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1719             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1720         }
1721 
1722         // This also deletes the contents at the last position of the array
1723         delete _ownedTokensIndex[tokenId];
1724         delete _ownedTokens[from][lastTokenIndex];
1725     }
1726 
1727     /**
1728      * @dev Private function to remove a token from this extension's token tracking data structures.
1729      * This has O(1) time complexity, but alters the order of the _allTokens array.
1730      * @param tokenId uint256 ID of the token to be removed from the tokens list
1731      */
1732     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1733         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1734         // then delete the last slot (swap and pop).
1735 
1736         uint256 lastTokenIndex = _allTokens.length - 1;
1737         uint256 tokenIndex = _allTokensIndex[tokenId];
1738 
1739         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1740         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1741         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1742         uint256 lastTokenId = _allTokens[lastTokenIndex];
1743 
1744         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1745         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1746 
1747         // This also deletes the contents at the last position of the array
1748         delete _allTokensIndex[tokenId];
1749         _allTokens.pop();
1750     }
1751 }
1752 
1753 // File: contracts/EWP/EmpowerWomenPlanet.sol
1754 
1755 
1756 pragma solidity ^0.8.4;
1757 
1758 
1759 
1760 
1761 
1762 
1763 contract EmpowerWomenPlanet is ERC721Enumerable, Pausable, PaymentSplitter {
1764     using Counters for Counters.Counter;
1765 
1766     uint256 public maxTotalSupply = 8888;
1767     uint256 public maxGiftSupply = 333;
1768     uint256 public price = 200000000000000000;
1769     uint256 public maxCount = 5; 
1770     uint256 public giftCount;
1771     uint256 public presaleCount;
1772     uint256 public totalNFT;
1773     bool public isBurnEnabled;
1774     string public baseURI;
1775     Counters.Counter private _tokenIds;
1776     uint256[] private _teamShares = [4, 6, 90];
1777     address[] private _team = [
1778         0x43879Fc71422bf0940334a0A37c029B75C7fEb90,     //dev
1779         0xC2A29502a69C7cCF804514FEf6c647B86069D40c,     //cofounder
1780         0xbFc8802A7238CA2593f6acF1A7eA04F4c76a8c00    //founder
1781     ];
1782     mapping(address => bool) private _presaleList;
1783     mapping(address => uint256) public _presaleClaimed;
1784     mapping(address => uint256) public _giftClaimed;
1785     mapping(address => uint256) public _saleClaimed;
1786     mapping(address => uint256) public _totalClaimed;
1787 
1788     enum WorkflowStatus {
1789         CheckOnPresale,
1790         Presale,
1791         Sale,
1792         SoldOut
1793     }
1794     WorkflowStatus public workflow;
1795     event ChangePresaleConfig(
1796         bool _isChanged
1797     );
1798     event ChangeSaleConfig(bool _isChanged);
1799     event ChangeIsBurnEnabled(bool _isBurnEnabled);
1800     event ChangeBaseURI(string _baseURI);
1801     event GiftMint(address indexed _recipient, uint256 _amount);
1802     event PresaleMint(address indexed _minter, uint256 _amount);
1803     event SaleMint(address indexed _minter, uint256 _amount);
1804     event WorkflowStatusChange(
1805         WorkflowStatus previousStatus,
1806         WorkflowStatus newStatus
1807     );
1808 
1809     constructor()
1810         ERC721("Empower Women Planet", "EWP")
1811         PaymentSplitter(_team, _teamShares)
1812     {}
1813 
1814     function setBaseURI(string calldata _tokenBaseURI) external onlyOwner {
1815         baseURI = _tokenBaseURI;
1816         emit ChangeBaseURI(_tokenBaseURI);
1817     }
1818 
1819     function _baseURI() internal view override returns (string memory) {
1820         return baseURI;
1821     }
1822 
1823     function addToPresaleList(address[] calldata _addresses)
1824         external
1825         onlyOwner
1826     {
1827         for (uint256 ind = 0; ind < _addresses.length; ind++) {
1828             require(
1829                 _addresses[ind] != address(0),
1830                 "Empower Women Planet: Can't add a zero address"
1831             );
1832             if (_presaleList[_addresses[ind]] == false) {
1833                 _presaleList[_addresses[ind]] = true;
1834             }
1835         }
1836     }
1837 
1838     function isOnPresaleList(address _address) external view returns (bool) {
1839         return _presaleList[_address];
1840     }
1841 
1842     function removeFromPresaleList(address[] calldata _addresses)
1843         external
1844         onlyOwner
1845     {
1846         for (uint256 ind = 0; ind < _addresses.length; ind++) {
1847             require(
1848                 _addresses[ind] != address(0),
1849                 "Empower Women Planet: Can't remove a zero address"
1850             );
1851             if (_presaleList[_addresses[ind]] == true) {
1852                 _presaleList[_addresses[ind]] = false;
1853             }
1854         }
1855     }
1856 
1857     function setUpPresale() external onlyOwner {
1858         require(
1859             workflow == WorkflowStatus.CheckOnPresale,
1860             "Empower Women Planet: Unauthorized Transaction"
1861         );
1862         emit ChangePresaleConfig(true);
1863         workflow = WorkflowStatus.Presale;
1864         emit WorkflowStatusChange(
1865             WorkflowStatus.CheckOnPresale,
1866             WorkflowStatus.Presale
1867         );
1868     }
1869 
1870     function setUpSale() external onlyOwner {
1871         require(
1872             workflow == WorkflowStatus.Presale,
1873             "Empower Women Planet: Unauthorized Transaction"
1874         );
1875         emit ChangePresaleConfig(false);
1876         emit ChangeSaleConfig(true);
1877         workflow = WorkflowStatus.Sale;
1878         emit WorkflowStatusChange(WorkflowStatus.Presale, WorkflowStatus.Sale);
1879     }
1880 
1881     function getPrice() public view returns (uint256) {
1882         return price;
1883     }
1884 
1885     function setPrice(uint256 _amount) external onlyOwner {
1886         price = _amount;
1887     }
1888 
1889     function getMaxCount() public view returns (uint256) {
1890         return maxCount;
1891     }
1892 
1893     function setMaxCount(uint256 _amount) external onlyOwner {
1894         maxCount = _amount;
1895     }
1896 
1897     function setIsBurnEnabled(bool _isBurnEnabled) external onlyOwner {
1898         isBurnEnabled = _isBurnEnabled;
1899         emit ChangeIsBurnEnabled(_isBurnEnabled);
1900     }
1901 
1902     function giftMint(address[] calldata _addresses)
1903         external
1904         onlyOwner
1905         whenNotPaused
1906     {
1907         require(
1908             totalNFT + _addresses.length <= maxTotalSupply,
1909             "Empower Women Planet: max total supply exceeded"
1910         );
1911 
1912         require(
1913             giftCount + _addresses.length <= maxGiftSupply,
1914             "Empower Women Planet: max gift supply exceeded"
1915         );
1916 
1917         uint256 _newItemId;
1918         for (uint256 ind = 0; ind < _addresses.length; ind++) {
1919             require(
1920                 _addresses[ind] != address(0),
1921                 "Empower Women Planet: recepient is the null address"
1922             );
1923             _tokenIds.increment();
1924             _newItemId = _tokenIds.current();
1925             _safeMint(_addresses[ind], _newItemId);
1926             _giftClaimed[_addresses[ind]] = _giftClaimed[_addresses[ind]] + 1;
1927             _totalClaimed[_addresses[ind]] = _totalClaimed[_addresses[ind]] + 1;
1928             totalNFT = totalNFT + 1;
1929             giftCount = giftCount + 1;
1930         }
1931     }
1932 
1933 
1934     function Mint(address _address, uint256 _amount)
1935         external
1936         onlyOwner
1937         whenNotPaused
1938     {
1939         require(
1940             totalNFT + _amount <= maxTotalSupply,
1941             "Empower Women Planet: max total supply exceeded"
1942         );
1943         
1944         require(
1945                 _address != address(0),
1946                 "Empower Women Planet: recepient is the null address"
1947             );
1948 
1949         uint256 _newItemId;
1950         for (uint256 ind = 0; ind < _amount; ind++) {
1951 
1952             _tokenIds.increment();
1953             _newItemId = _tokenIds.current();
1954             _safeMint(_address, _newItemId);
1955             _totalClaimed[_address] = _totalClaimed[_address] + 1;
1956             totalNFT = totalNFT + 1;
1957         }
1958     }
1959 
1960     function presaleMint(uint256 _amount) internal {
1961         require(workflow == WorkflowStatus.Presale,
1962             "Empower Women Planet: Presale is ended"
1963         );
1964         require(
1965             _presaleList[msg.sender] == true,
1966             " Caller is not on the presale list"
1967         );
1968         uint256 _maxCount = getMaxCount();
1969         require(
1970             _presaleClaimed[msg.sender] + _amount <= _maxCount,
1971             "Empower Women Planet: Can only mint 2 tokens per adress"
1972         );
1973         require(
1974             totalNFT + _amount <= maxTotalSupply,
1975             "Empower Women Planet: max supply exceeded"
1976         );
1977         uint256 _price = getPrice();
1978         require(
1979             _price * _amount <= msg.value,
1980             "Empower Women Planet: Ether value sent is not correct"
1981         );
1982         uint256 _newItemId;
1983         for (uint256 ind = 0; ind < _amount; ind++) {
1984             _tokenIds.increment();
1985             _newItemId = _tokenIds.current();
1986             _safeMint(msg.sender, _newItemId);
1987             _presaleClaimed[msg.sender] = _presaleClaimed[msg.sender] + _amount;
1988             _totalClaimed[msg.sender] = _totalClaimed[msg.sender] + _amount;
1989             totalNFT = totalNFT + 1;
1990             presaleCount = presaleCount + 1;
1991         }
1992         emit PresaleMint(msg.sender, _amount);
1993     }
1994 
1995     function saleMint(uint256 _amount) internal {
1996         require(_amount > 0, "Empower Women Planet: zero amount");
1997         require(workflow == WorkflowStatus.Sale, "Empower Women Planet: sale is not active");
1998         uint256 _maxCount = getMaxCount();
1999         require(
2000             _saleClaimed[msg.sender] + _amount <=  _maxCount,
2001             "Empower Women Planet:  Can only mint 5 tokens per adress"
2002         );
2003         require(
2004             totalNFT + _amount <= maxTotalSupply,
2005             "Empower Women Planet: max supply exceeded"
2006         );
2007         uint256 _price = getPrice();
2008         require(
2009             _price * _amount <= msg.value,
2010             "Empower Women Planet: Ether value sent is not correct"
2011         );
2012         uint256 _newItemId;
2013         for (uint256 ind = 0; ind < _amount; ind++) {
2014             _tokenIds.increment();
2015             _newItemId = _tokenIds.current();
2016             _safeMint(msg.sender, _newItemId);
2017             _saleClaimed[msg.sender] = _saleClaimed[msg.sender] + _amount;
2018             _totalClaimed[msg.sender] = _totalClaimed[msg.sender] + _amount;
2019             totalNFT = totalNFT + 1;
2020         }
2021         emit SaleMint(msg.sender, _amount);
2022     }
2023 
2024     function mainMint(uint256 _amount) external payable whenNotPaused {
2025         require(
2026             workflow != WorkflowStatus.SoldOut,
2027             "Empower Women Planet: sold out"
2028         );
2029         require(
2030             workflow != WorkflowStatus.CheckOnPresale,
2031             "Empower Women Planet: presale not started"
2032         );
2033         if (
2034             workflow == WorkflowStatus.Presale
2035         ) {
2036             presaleMint(_amount);
2037         } else {
2038             saleMint(_amount);
2039         }
2040         if (totalNFT + _amount == maxTotalSupply) {
2041             workflow = WorkflowStatus.SoldOut;
2042             emit WorkflowStatusChange(
2043                 WorkflowStatus.Sale,
2044                 WorkflowStatus.SoldOut
2045             );
2046         }
2047     }
2048 
2049     function burn(uint256 tokenId) external {
2050         require(isBurnEnabled, "Empower Women Planet: burning disabled");
2051         require(
2052             _isApprovedOrOwner(msg.sender, tokenId),
2053             "Empower Women Planet: burn caller is not owner nor approved"
2054         );
2055         _burn(tokenId);
2056         totalNFT = totalNFT - 1;
2057     }
2058 
2059     function getWorkflowStatus() public view returns (uint256) {
2060         uint256 _status;
2061         if (workflow == WorkflowStatus.CheckOnPresale) {
2062             _status = 1;
2063         }
2064         if (workflow == WorkflowStatus.Presale) {
2065             _status = 2;
2066         }
2067         if (workflow == WorkflowStatus.Sale) {
2068             _status = 3;
2069         }
2070         if (workflow == WorkflowStatus.SoldOut) {
2071             _status = 4;
2072         }
2073         return _status;
2074     }
2075 
2076      function walletOfOwner(address _owner)
2077         public
2078         view
2079         returns (uint256[] memory)
2080     {
2081         uint256 tokenCount = balanceOf(_owner);
2082 
2083         uint256[] memory tokensId = new uint256[](tokenCount);
2084         for (uint256 i; i < tokenCount; i++) {
2085             tokensId[i] = tokenOfOwnerByIndex(_owner, i);
2086         }
2087         return tokensId;
2088     }
2089     
2090     function withdrawAll() external onlyOwner {
2091         for (uint256 i = 0; i < _team.length; i++) {
2092             address payable wallet = payable(_team[i]);
2093             release(wallet);
2094         }
2095     }
2096 }