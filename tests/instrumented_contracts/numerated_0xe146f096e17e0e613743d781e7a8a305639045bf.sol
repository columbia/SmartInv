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
308 // File: @openzeppelin/contracts/utils/Address.sol
309 
310 
311 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
312 
313 pragma solidity ^0.8.0;
314 
315 /**
316  * @dev Collection of functions related to the address type
317  */
318 library Address {
319     /**
320      * @dev Returns true if `account` is a contract.
321      *
322      * [IMPORTANT]
323      * ====
324      * It is unsafe to assume that an address for which this function returns
325      * false is an externally-owned account (EOA) and not a contract.
326      *
327      * Among others, `isContract` will return false for the following
328      * types of addresses:
329      *
330      *  - an externally-owned account
331      *  - a contract in construction
332      *  - an address where a contract will be created
333      *  - an address where a contract lived, but was destroyed
334      * ====
335      */
336     function isContract(address account) internal view returns (bool) {
337         // This method relies on extcodesize, which returns 0 for contracts in
338         // construction, since the code is only stored at the end of the
339         // constructor execution.
340 
341         uint256 size;
342         assembly {
343             size := extcodesize(account)
344         }
345         return size > 0;
346     }
347 
348     /**
349      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
350      * `recipient`, forwarding all available gas and reverting on errors.
351      *
352      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
353      * of certain opcodes, possibly making contracts go over the 2300 gas limit
354      * imposed by `transfer`, making them unable to receive funds via
355      * `transfer`. {sendValue} removes this limitation.
356      *
357      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
358      *
359      * IMPORTANT: because control is transferred to `recipient`, care must be
360      * taken to not create reentrancy vulnerabilities. Consider using
361      * {ReentrancyGuard} or the
362      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
363      */
364     function sendValue(address payable recipient, uint256 amount) internal {
365         require(address(this).balance >= amount, "Address: insufficient balance");
366 
367         (bool success, ) = recipient.call{value: amount}("");
368         require(success, "Address: unable to send value, recipient may have reverted");
369     }
370 
371     /**
372      * @dev Performs a Solidity function call using a low level `call`. A
373      * plain `call` is an unsafe replacement for a function call: use this
374      * function instead.
375      *
376      * If `target` reverts with a revert reason, it is bubbled up by this
377      * function (like regular Solidity function calls).
378      *
379      * Returns the raw returned data. To convert to the expected return value,
380      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
381      *
382      * Requirements:
383      *
384      * - `target` must be a contract.
385      * - calling `target` with `data` must not revert.
386      *
387      * _Available since v3.1._
388      */
389     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
390         return functionCall(target, data, "Address: low-level call failed");
391     }
392 
393     /**
394      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
395      * `errorMessage` as a fallback revert reason when `target` reverts.
396      *
397      * _Available since v3.1._
398      */
399     function functionCall(
400         address target,
401         bytes memory data,
402         string memory errorMessage
403     ) internal returns (bytes memory) {
404         return functionCallWithValue(target, data, 0, errorMessage);
405     }
406 
407     /**
408      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
409      * but also transferring `value` wei to `target`.
410      *
411      * Requirements:
412      *
413      * - the calling contract must have an ETH balance of at least `value`.
414      * - the called Solidity function must be `payable`.
415      *
416      * _Available since v3.1._
417      */
418     function functionCallWithValue(
419         address target,
420         bytes memory data,
421         uint256 value
422     ) internal returns (bytes memory) {
423         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
424     }
425 
426     /**
427      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
428      * with `errorMessage` as a fallback revert reason when `target` reverts.
429      *
430      * _Available since v3.1._
431      */
432     function functionCallWithValue(
433         address target,
434         bytes memory data,
435         uint256 value,
436         string memory errorMessage
437     ) internal returns (bytes memory) {
438         require(address(this).balance >= value, "Address: insufficient balance for call");
439         require(isContract(target), "Address: call to non-contract");
440 
441         (bool success, bytes memory returndata) = target.call{value: value}(data);
442         return verifyCallResult(success, returndata, errorMessage);
443     }
444 
445     /**
446      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
447      * but performing a static call.
448      *
449      * _Available since v3.3._
450      */
451     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
452         return functionStaticCall(target, data, "Address: low-level static call failed");
453     }
454 
455     /**
456      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
457      * but performing a static call.
458      *
459      * _Available since v3.3._
460      */
461     function functionStaticCall(
462         address target,
463         bytes memory data,
464         string memory errorMessage
465     ) internal view returns (bytes memory) {
466         require(isContract(target), "Address: static call to non-contract");
467 
468         (bool success, bytes memory returndata) = target.staticcall(data);
469         return verifyCallResult(success, returndata, errorMessage);
470     }
471 
472     /**
473      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
474      * but performing a delegate call.
475      *
476      * _Available since v3.4._
477      */
478     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
479         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
480     }
481 
482     /**
483      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
484      * but performing a delegate call.
485      *
486      * _Available since v3.4._
487      */
488     function functionDelegateCall(
489         address target,
490         bytes memory data,
491         string memory errorMessage
492     ) internal returns (bytes memory) {
493         require(isContract(target), "Address: delegate call to non-contract");
494 
495         (bool success, bytes memory returndata) = target.delegatecall(data);
496         return verifyCallResult(success, returndata, errorMessage);
497     }
498 
499     /**
500      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
501      * revert reason using the provided one.
502      *
503      * _Available since v4.3._
504      */
505     function verifyCallResult(
506         bool success,
507         bytes memory returndata,
508         string memory errorMessage
509     ) internal pure returns (bytes memory) {
510         if (success) {
511             return returndata;
512         } else {
513             // Look for revert reason and bubble it up if present
514             if (returndata.length > 0) {
515                 // The easiest way to bubble the revert reason is using memory via assembly
516 
517                 assembly {
518                     let returndata_size := mload(returndata)
519                     revert(add(32, returndata), returndata_size)
520                 }
521             } else {
522                 revert(errorMessage);
523             }
524         }
525     }
526 }
527 
528 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
529 
530 
531 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
532 
533 pragma solidity ^0.8.0;
534 
535 
536 
537 /**
538  * @title SafeERC20
539  * @dev Wrappers around ERC20 operations that throw on failure (when the token
540  * contract returns false). Tokens that return no value (and instead revert or
541  * throw on failure) are also supported, non-reverting calls are assumed to be
542  * successful.
543  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
544  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
545  */
546 library SafeERC20 {
547     using Address for address;
548 
549     function safeTransfer(
550         IERC20 token,
551         address to,
552         uint256 value
553     ) internal {
554         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
555     }
556 
557     function safeTransferFrom(
558         IERC20 token,
559         address from,
560         address to,
561         uint256 value
562     ) internal {
563         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
564     }
565 
566     /**
567      * @dev Deprecated. This function has issues similar to the ones found in
568      * {IERC20-approve}, and its usage is discouraged.
569      *
570      * Whenever possible, use {safeIncreaseAllowance} and
571      * {safeDecreaseAllowance} instead.
572      */
573     function safeApprove(
574         IERC20 token,
575         address spender,
576         uint256 value
577     ) internal {
578         // safeApprove should only be called when setting an initial allowance,
579         // or when resetting it to zero. To increase and decrease it, use
580         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
581         require(
582             (value == 0) || (token.allowance(address(this), spender) == 0),
583             "SafeERC20: approve from non-zero to non-zero allowance"
584         );
585         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
586     }
587 
588     function safeIncreaseAllowance(
589         IERC20 token,
590         address spender,
591         uint256 value
592     ) internal {
593         uint256 newAllowance = token.allowance(address(this), spender) + value;
594         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
595     }
596 
597     function safeDecreaseAllowance(
598         IERC20 token,
599         address spender,
600         uint256 value
601     ) internal {
602         unchecked {
603             uint256 oldAllowance = token.allowance(address(this), spender);
604             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
605             uint256 newAllowance = oldAllowance - value;
606             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
607         }
608     }
609 
610     /**
611      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
612      * on the return value: the return value is optional (but if data is returned, it must not be false).
613      * @param token The token targeted by the call.
614      * @param data The call data (encoded using abi.encode or one of its variants).
615      */
616     function _callOptionalReturn(IERC20 token, bytes memory data) private {
617         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
618         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
619         // the target address contains contract code and also asserts for success in the low-level call.
620 
621         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
622         if (returndata.length > 0) {
623             // Return data is optional
624             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
625         }
626     }
627 }
628 
629 // File: @openzeppelin/contracts/finance/PaymentSplitter.sol
630 
631 
632 // OpenZeppelin Contracts v4.4.1 (finance/PaymentSplitter.sol)
633 
634 pragma solidity ^0.8.0;
635 
636 
637 
638 
639 /**
640  * @title PaymentSplitter
641  * @dev This contract allows to split Ether payments among a group of accounts. The sender does not need to be aware
642  * that the Ether will be split in this way, since it is handled transparently by the contract.
643  *
644  * The split can be in equal parts or in any other arbitrary proportion. The way this is specified is by assigning each
645  * account to a number of shares. Of all the Ether that this contract receives, each account will then be able to claim
646  * an amount proportional to the percentage of total shares they were assigned.
647  *
648  * `PaymentSplitter` follows a _pull payment_ model. This means that payments are not automatically forwarded to the
649  * accounts but kept in this contract, and the actual transfer is triggered as a separate step by calling the {release}
650  * function.
651  *
652  * NOTE: This contract assumes that ERC20 tokens will behave similarly to native tokens (Ether). Rebasing tokens, and
653  * tokens that apply fees during transfers, are likely to not be supported as expected. If in doubt, we encourage you
654  * to run tests before sending real value to this contract.
655  */
656 contract PaymentSplitter is Context {
657     event PayeeAdded(address account, uint256 shares);
658     event PaymentReleased(address to, uint256 amount);
659     event ERC20PaymentReleased(IERC20 indexed token, address to, uint256 amount);
660     event PaymentReceived(address from, uint256 amount);
661 
662     uint256 private _totalShares;
663     uint256 private _totalReleased;
664 
665     mapping(address => uint256) private _shares;
666     mapping(address => uint256) private _released;
667     address[] private _payees;
668 
669     mapping(IERC20 => uint256) private _erc20TotalReleased;
670     mapping(IERC20 => mapping(address => uint256)) private _erc20Released;
671 
672     /**
673      * @dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at
674      * the matching position in the `shares` array.
675      *
676      * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no
677      * duplicates in `payees`.
678      */
679     constructor(address[] memory payees, uint256[] memory shares_) payable {
680         require(payees.length == shares_.length, "PaymentSplitter: payees and shares length mismatch");
681         require(payees.length > 0, "PaymentSplitter: no payees");
682 
683         for (uint256 i = 0; i < payees.length; i++) {
684             _addPayee(payees[i], shares_[i]);
685         }
686     }
687 
688     /**
689      * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully
690      * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
691      * reliability of the events, and not the actual splitting of Ether.
692      *
693      * To learn more about this see the Solidity documentation for
694      * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
695      * functions].
696      */
697     receive() external payable virtual {
698         emit PaymentReceived(_msgSender(), msg.value);
699     }
700 
701     /**
702      * @dev Getter for the total shares held by payees.
703      */
704     function totalShares() public view returns (uint256) {
705         return _totalShares;
706     }
707 
708     /**
709      * @dev Getter for the total amount of Ether already released.
710      */
711     function totalReleased() public view returns (uint256) {
712         return _totalReleased;
713     }
714 
715     /**
716      * @dev Getter for the total amount of `token` already released. `token` should be the address of an IERC20
717      * contract.
718      */
719     function totalReleased(IERC20 token) public view returns (uint256) {
720         return _erc20TotalReleased[token];
721     }
722 
723     /**
724      * @dev Getter for the amount of shares held by an account.
725      */
726     function shares(address account) public view returns (uint256) {
727         return _shares[account];
728     }
729 
730     /**
731      * @dev Getter for the amount of Ether already released to a payee.
732      */
733     function released(address account) public view returns (uint256) {
734         return _released[account];
735     }
736 
737     /**
738      * @dev Getter for the amount of `token` tokens already released to a payee. `token` should be the address of an
739      * IERC20 contract.
740      */
741     function released(IERC20 token, address account) public view returns (uint256) {
742         return _erc20Released[token][account];
743     }
744 
745     /**
746      * @dev Getter for the address of the payee number `index`.
747      */
748     function payee(uint256 index) public view returns (address) {
749         return _payees[index];
750     }
751 
752     /**
753      * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
754      * total shares and their previous withdrawals.
755      */
756     function release(address payable account) public virtual {
757         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
758 
759         uint256 totalReceived = address(this).balance + totalReleased();
760         uint256 payment = _pendingPayment(account, totalReceived, released(account));
761 
762         require(payment != 0, "PaymentSplitter: account is not due payment");
763 
764         _released[account] += payment;
765         _totalReleased += payment;
766 
767         Address.sendValue(account, payment);
768         emit PaymentReleased(account, payment);
769     }
770 
771     /**
772      * @dev Triggers a transfer to `account` of the amount of `token` tokens they are owed, according to their
773      * percentage of the total shares and their previous withdrawals. `token` must be the address of an IERC20
774      * contract.
775      */
776     function release(IERC20 token, address account) public virtual {
777         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
778 
779         uint256 totalReceived = token.balanceOf(address(this)) + totalReleased(token);
780         uint256 payment = _pendingPayment(account, totalReceived, released(token, account));
781 
782         require(payment != 0, "PaymentSplitter: account is not due payment");
783 
784         _erc20Released[token][account] += payment;
785         _erc20TotalReleased[token] += payment;
786 
787         SafeERC20.safeTransfer(token, account, payment);
788         emit ERC20PaymentReleased(token, account, payment);
789     }
790 
791     /**
792      * @dev internal logic for computing the pending payment of an `account` given the token historical balances and
793      * already released amounts.
794      */
795     function _pendingPayment(
796         address account,
797         uint256 totalReceived,
798         uint256 alreadyReleased
799     ) private view returns (uint256) {
800         return (totalReceived * _shares[account]) / _totalShares - alreadyReleased;
801     }
802 
803     /**
804      * @dev Add a new payee to the contract.
805      * @param account The address of the payee to add.
806      * @param shares_ The number of shares owned by the payee.
807      */
808     function _addPayee(address account, uint256 shares_) private {
809         require(account != address(0), "PaymentSplitter: account is the zero address");
810         require(shares_ > 0, "PaymentSplitter: shares are 0");
811         require(_shares[account] == 0, "PaymentSplitter: account already has shares");
812 
813         _payees.push(account);
814         _shares[account] = shares_;
815         _totalShares = _totalShares + shares_;
816         emit PayeeAdded(account, shares_);
817     }
818 }
819 
820 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
821 
822 
823 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
824 
825 pragma solidity ^0.8.0;
826 
827 /**
828  * @title ERC721 token receiver interface
829  * @dev Interface for any contract that wants to support safeTransfers
830  * from ERC721 asset contracts.
831  */
832 interface IERC721Receiver {
833     /**
834      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
835      * by `operator` from `from`, this function is called.
836      *
837      * It must return its Solidity selector to confirm the token transfer.
838      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
839      *
840      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
841      */
842     function onERC721Received(
843         address operator,
844         address from,
845         uint256 tokenId,
846         bytes calldata data
847     ) external returns (bytes4);
848 }
849 
850 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
851 
852 
853 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
854 
855 pragma solidity ^0.8.0;
856 
857 /**
858  * @dev Interface of the ERC165 standard, as defined in the
859  * https://eips.ethereum.org/EIPS/eip-165[EIP].
860  *
861  * Implementers can declare support of contract interfaces, which can then be
862  * queried by others ({ERC165Checker}).
863  *
864  * For an implementation, see {ERC165}.
865  */
866 interface IERC165 {
867     /**
868      * @dev Returns true if this contract implements the interface defined by
869      * `interfaceId`. See the corresponding
870      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
871      * to learn more about how these ids are created.
872      *
873      * This function call must use less than 30 000 gas.
874      */
875     function supportsInterface(bytes4 interfaceId) external view returns (bool);
876 }
877 
878 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
879 
880 
881 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
882 
883 pragma solidity ^0.8.0;
884 
885 
886 /**
887  * @dev Implementation of the {IERC165} interface.
888  *
889  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
890  * for the additional interface id that will be supported. For example:
891  *
892  * ```solidity
893  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
894  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
895  * }
896  * ```
897  *
898  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
899  */
900 abstract contract ERC165 is IERC165 {
901     /**
902      * @dev See {IERC165-supportsInterface}.
903      */
904     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
905         return interfaceId == type(IERC165).interfaceId;
906     }
907 }
908 
909 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
910 
911 
912 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
913 
914 pragma solidity ^0.8.0;
915 
916 
917 /**
918  * @dev Required interface of an ERC721 compliant contract.
919  */
920 interface IERC721 is IERC165 {
921     /**
922      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
923      */
924     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
925 
926     /**
927      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
928      */
929     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
930 
931     /**
932      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
933      */
934     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
935 
936     /**
937      * @dev Returns the number of tokens in ``owner``'s account.
938      */
939     function balanceOf(address owner) external view returns (uint256 balance);
940 
941     /**
942      * @dev Returns the owner of the `tokenId` token.
943      *
944      * Requirements:
945      *
946      * - `tokenId` must exist.
947      */
948     function ownerOf(uint256 tokenId) external view returns (address owner);
949 
950     /**
951      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
952      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
953      *
954      * Requirements:
955      *
956      * - `from` cannot be the zero address.
957      * - `to` cannot be the zero address.
958      * - `tokenId` token must exist and be owned by `from`.
959      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
960      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
961      *
962      * Emits a {Transfer} event.
963      */
964     function safeTransferFrom(
965         address from,
966         address to,
967         uint256 tokenId
968     ) external;
969 
970     /**
971      * @dev Transfers `tokenId` token from `from` to `to`.
972      *
973      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
974      *
975      * Requirements:
976      *
977      * - `from` cannot be the zero address.
978      * - `to` cannot be the zero address.
979      * - `tokenId` token must be owned by `from`.
980      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
981      *
982      * Emits a {Transfer} event.
983      */
984     function transferFrom(
985         address from,
986         address to,
987         uint256 tokenId
988     ) external;
989 
990     /**
991      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
992      * The approval is cleared when the token is transferred.
993      *
994      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
995      *
996      * Requirements:
997      *
998      * - The caller must own the token or be an approved operator.
999      * - `tokenId` must exist.
1000      *
1001      * Emits an {Approval} event.
1002      */
1003     function approve(address to, uint256 tokenId) external;
1004 
1005     /**
1006      * @dev Returns the account approved for `tokenId` token.
1007      *
1008      * Requirements:
1009      *
1010      * - `tokenId` must exist.
1011      */
1012     function getApproved(uint256 tokenId) external view returns (address operator);
1013 
1014     /**
1015      * @dev Approve or remove `operator` as an operator for the caller.
1016      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1017      *
1018      * Requirements:
1019      *
1020      * - The `operator` cannot be the caller.
1021      *
1022      * Emits an {ApprovalForAll} event.
1023      */
1024     function setApprovalForAll(address operator, bool _approved) external;
1025 
1026     /**
1027      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1028      *
1029      * See {setApprovalForAll}
1030      */
1031     function isApprovedForAll(address owner, address operator) external view returns (bool);
1032 
1033     /**
1034      * @dev Safely transfers `tokenId` token from `from` to `to`.
1035      *
1036      * Requirements:
1037      *
1038      * - `from` cannot be the zero address.
1039      * - `to` cannot be the zero address.
1040      * - `tokenId` token must exist and be owned by `from`.
1041      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1042      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1043      *
1044      * Emits a {Transfer} event.
1045      */
1046     function safeTransferFrom(
1047         address from,
1048         address to,
1049         uint256 tokenId,
1050         bytes calldata data
1051     ) external;
1052 }
1053 
1054 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1055 
1056 
1057 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1058 
1059 pragma solidity ^0.8.0;
1060 
1061 
1062 /**
1063  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1064  * @dev See https://eips.ethereum.org/EIPS/eip-721
1065  */
1066 interface IERC721Metadata is IERC721 {
1067     /**
1068      * @dev Returns the token collection name.
1069      */
1070     function name() external view returns (string memory);
1071 
1072     /**
1073      * @dev Returns the token collection symbol.
1074      */
1075     function symbol() external view returns (string memory);
1076 
1077     /**
1078      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1079      */
1080     function tokenURI(uint256 tokenId) external view returns (string memory);
1081 }
1082 
1083 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1084 
1085 
1086 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
1087 
1088 pragma solidity ^0.8.0;
1089 
1090 
1091 
1092 
1093 
1094 
1095 
1096 
1097 /**
1098  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1099  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1100  * {ERC721Enumerable}.
1101  */
1102 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1103     using Address for address;
1104     using Strings for uint256;
1105 
1106     // Token name
1107     string private _name;
1108 
1109     // Token symbol
1110     string private _symbol;
1111 
1112     // Mapping from token ID to owner address
1113     mapping(uint256 => address) private _owners;
1114 
1115     // Mapping owner address to token count
1116     mapping(address => uint256) private _balances;
1117 
1118     // Mapping from token ID to approved address
1119     mapping(uint256 => address) private _tokenApprovals;
1120 
1121     // Mapping from owner to operator approvals
1122     mapping(address => mapping(address => bool)) private _operatorApprovals;
1123 
1124     /**
1125      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1126      */
1127     constructor(string memory name_, string memory symbol_) {
1128         _name = name_;
1129         _symbol = symbol_;
1130     }
1131 
1132     /**
1133      * @dev See {IERC165-supportsInterface}.
1134      */
1135     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1136         return
1137             interfaceId == type(IERC721).interfaceId ||
1138             interfaceId == type(IERC721Metadata).interfaceId ||
1139             super.supportsInterface(interfaceId);
1140     }
1141 
1142     /**
1143      * @dev See {IERC721-balanceOf}.
1144      */
1145     function balanceOf(address owner) public view virtual override returns (uint256) {
1146         require(owner != address(0), "ERC721: balance query for the zero address");
1147         return _balances[owner];
1148     }
1149 
1150     /**
1151      * @dev See {IERC721-ownerOf}.
1152      */
1153     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1154         address owner = _owners[tokenId];
1155         require(owner != address(0), "ERC721: owner query for nonexistent token");
1156         return owner;
1157     }
1158 
1159     /**
1160      * @dev See {IERC721Metadata-name}.
1161      */
1162     function name() public view virtual override returns (string memory) {
1163         return _name;
1164     }
1165 
1166     /**
1167      * @dev See {IERC721Metadata-symbol}.
1168      */
1169     function symbol() public view virtual override returns (string memory) {
1170         return _symbol;
1171     }
1172 
1173     /**
1174      * @dev See {IERC721Metadata-tokenURI}.
1175      */
1176     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1177         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1178 
1179         string memory baseURI = _baseURI();
1180         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1181     }
1182 
1183     /**
1184      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1185      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1186      * by default, can be overriden in child contracts.
1187      */
1188     function _baseURI() internal view virtual returns (string memory) {
1189         return "";
1190     }
1191 
1192     /**
1193      * @dev See {IERC721-approve}.
1194      */
1195     function approve(address to, uint256 tokenId) public virtual override {
1196         address owner = ERC721.ownerOf(tokenId);
1197         require(to != owner, "ERC721: approval to current owner");
1198 
1199         require(
1200             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1201             "ERC721: approve caller is not owner nor approved for all"
1202         );
1203 
1204         _approve(to, tokenId);
1205     }
1206 
1207     /**
1208      * @dev See {IERC721-getApproved}.
1209      */
1210     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1211         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1212 
1213         return _tokenApprovals[tokenId];
1214     }
1215 
1216     /**
1217      * @dev See {IERC721-setApprovalForAll}.
1218      */
1219     function setApprovalForAll(address operator, bool approved) public virtual override {
1220         _setApprovalForAll(_msgSender(), operator, approved);
1221     }
1222 
1223     /**
1224      * @dev See {IERC721-isApprovedForAll}.
1225      */
1226     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1227         return _operatorApprovals[owner][operator];
1228     }
1229 
1230     /**
1231      * @dev See {IERC721-transferFrom}.
1232      */
1233     function transferFrom(
1234         address from,
1235         address to,
1236         uint256 tokenId
1237     ) public virtual override {
1238         //solhint-disable-next-line max-line-length
1239         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1240 
1241         _transfer(from, to, tokenId);
1242     }
1243 
1244     /**
1245      * @dev See {IERC721-safeTransferFrom}.
1246      */
1247     function safeTransferFrom(
1248         address from,
1249         address to,
1250         uint256 tokenId
1251     ) public virtual override {
1252         safeTransferFrom(from, to, tokenId, "");
1253     }
1254 
1255     /**
1256      * @dev See {IERC721-safeTransferFrom}.
1257      */
1258     function safeTransferFrom(
1259         address from,
1260         address to,
1261         uint256 tokenId,
1262         bytes memory _data
1263     ) public virtual override {
1264         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1265         _safeTransfer(from, to, tokenId, _data);
1266     }
1267 
1268     /**
1269      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1270      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1271      *
1272      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1273      *
1274      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1275      * implement alternative mechanisms to perform token transfer, such as signature-based.
1276      *
1277      * Requirements:
1278      *
1279      * - `from` cannot be the zero address.
1280      * - `to` cannot be the zero address.
1281      * - `tokenId` token must exist and be owned by `from`.
1282      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1283      *
1284      * Emits a {Transfer} event.
1285      */
1286     function _safeTransfer(
1287         address from,
1288         address to,
1289         uint256 tokenId,
1290         bytes memory _data
1291     ) internal virtual {
1292         _transfer(from, to, tokenId);
1293         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1294     }
1295 
1296     /**
1297      * @dev Returns whether `tokenId` exists.
1298      *
1299      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1300      *
1301      * Tokens start existing when they are minted (`_mint`),
1302      * and stop existing when they are burned (`_burn`).
1303      */
1304     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1305         return _owners[tokenId] != address(0);
1306     }
1307 
1308     /**
1309      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1310      *
1311      * Requirements:
1312      *
1313      * - `tokenId` must exist.
1314      */
1315     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1316         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1317         address owner = ERC721.ownerOf(tokenId);
1318         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1319     }
1320 
1321     /**
1322      * @dev Safely mints `tokenId` and transfers it to `to`.
1323      *
1324      * Requirements:
1325      *
1326      * - `tokenId` must not exist.
1327      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1328      *
1329      * Emits a {Transfer} event.
1330      */
1331     function _safeMint(address to, uint256 tokenId) internal virtual {
1332         _safeMint(to, tokenId, "");
1333     }
1334 
1335     /**
1336      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1337      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1338      */
1339     function _safeMint(
1340         address to,
1341         uint256 tokenId,
1342         bytes memory _data
1343     ) internal virtual {
1344         _mint(to, tokenId);
1345         require(
1346             _checkOnERC721Received(address(0), to, tokenId, _data),
1347             "ERC721: transfer to non ERC721Receiver implementer"
1348         );
1349     }
1350 
1351     /**
1352      * @dev Mints `tokenId` and transfers it to `to`.
1353      *
1354      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1355      *
1356      * Requirements:
1357      *
1358      * - `tokenId` must not exist.
1359      * - `to` cannot be the zero address.
1360      *
1361      * Emits a {Transfer} event.
1362      */
1363     function _mint(address to, uint256 tokenId) internal virtual {
1364         require(to != address(0), "ERC721: mint to the zero address");
1365         require(!_exists(tokenId), "ERC721: token already minted");
1366 
1367         _beforeTokenTransfer(address(0), to, tokenId);
1368 
1369         _balances[to] += 1;
1370         _owners[tokenId] = to;
1371 
1372         emit Transfer(address(0), to, tokenId);
1373     }
1374 
1375     /**
1376      * @dev Destroys `tokenId`.
1377      * The approval is cleared when the token is burned.
1378      *
1379      * Requirements:
1380      *
1381      * - `tokenId` must exist.
1382      *
1383      * Emits a {Transfer} event.
1384      */
1385     function _burn(uint256 tokenId) internal virtual {
1386         address owner = ERC721.ownerOf(tokenId);
1387 
1388         _beforeTokenTransfer(owner, address(0), tokenId);
1389 
1390         // Clear approvals
1391         _approve(address(0), tokenId);
1392 
1393         _balances[owner] -= 1;
1394         delete _owners[tokenId];
1395 
1396         emit Transfer(owner, address(0), tokenId);
1397     }
1398 
1399     /**
1400      * @dev Transfers `tokenId` from `from` to `to`.
1401      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1402      *
1403      * Requirements:
1404      *
1405      * - `to` cannot be the zero address.
1406      * - `tokenId` token must be owned by `from`.
1407      *
1408      * Emits a {Transfer} event.
1409      */
1410     function _transfer(
1411         address from,
1412         address to,
1413         uint256 tokenId
1414     ) internal virtual {
1415         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1416         require(to != address(0), "ERC721: transfer to the zero address");
1417 
1418         _beforeTokenTransfer(from, to, tokenId);
1419 
1420         // Clear approvals from the previous owner
1421         _approve(address(0), tokenId);
1422 
1423         _balances[from] -= 1;
1424         _balances[to] += 1;
1425         _owners[tokenId] = to;
1426 
1427         emit Transfer(from, to, tokenId);
1428     }
1429 
1430     /**
1431      * @dev Approve `to` to operate on `tokenId`
1432      *
1433      * Emits a {Approval} event.
1434      */
1435     function _approve(address to, uint256 tokenId) internal virtual {
1436         _tokenApprovals[tokenId] = to;
1437         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1438     }
1439 
1440     /**
1441      * @dev Approve `operator` to operate on all of `owner` tokens
1442      *
1443      * Emits a {ApprovalForAll} event.
1444      */
1445     function _setApprovalForAll(
1446         address owner,
1447         address operator,
1448         bool approved
1449     ) internal virtual {
1450         require(owner != operator, "ERC721: approve to caller");
1451         _operatorApprovals[owner][operator] = approved;
1452         emit ApprovalForAll(owner, operator, approved);
1453     }
1454 
1455     /**
1456      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1457      * The call is not executed if the target address is not a contract.
1458      *
1459      * @param from address representing the previous owner of the given token ID
1460      * @param to target address that will receive the tokens
1461      * @param tokenId uint256 ID of the token to be transferred
1462      * @param _data bytes optional data to send along with the call
1463      * @return bool whether the call correctly returned the expected magic value
1464      */
1465     function _checkOnERC721Received(
1466         address from,
1467         address to,
1468         uint256 tokenId,
1469         bytes memory _data
1470     ) private returns (bool) {
1471         if (to.isContract()) {
1472             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1473                 return retval == IERC721Receiver.onERC721Received.selector;
1474             } catch (bytes memory reason) {
1475                 if (reason.length == 0) {
1476                     revert("ERC721: transfer to non ERC721Receiver implementer");
1477                 } else {
1478                     assembly {
1479                         revert(add(32, reason), mload(reason))
1480                     }
1481                 }
1482             }
1483         } else {
1484             return true;
1485         }
1486     }
1487 
1488     /**
1489      * @dev Hook that is called before any token transfer. This includes minting
1490      * and burning.
1491      *
1492      * Calling conditions:
1493      *
1494      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1495      * transferred to `to`.
1496      * - When `from` is zero, `tokenId` will be minted for `to`.
1497      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1498      * - `from` and `to` are never both zero.
1499      *
1500      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1501      */
1502     function _beforeTokenTransfer(
1503         address from,
1504         address to,
1505         uint256 tokenId
1506     ) internal virtual {}
1507 }
1508 
1509 // File: contracts/ParrotsNFT.sol
1510 
1511 
1512 
1513 pragma solidity ^0.8.0;
1514 
1515 
1516 
1517 
1518 
1519 pragma solidity ^0.8.0;
1520 
1521 contract ParrotsNFT is Ownable, ERC721, PaymentSplitter {
1522 
1523     using Strings for uint256;
1524 
1525     using Counters for Counters.Counter;
1526     Counters.Counter private supply;
1527 
1528     string private baseURI = "";
1529     string public baseExtension = ".json";
1530     uint256 public preSaleCost = 0.12 ether;
1531     uint256 public cost = 0.15 ether;
1532     uint16 public maxSupply = 5555;
1533     uint8 public maxMintAmountFreemint = 150;
1534     uint16 public maxMintAmountPresale = 250;
1535     uint16 public maxMintAmount = 5555;
1536     uint8 public nftPerAddressLimit = 3;
1537     bool public preSaleState = false;
1538     bool public publicSaleState = false;
1539     mapping(address => bool) public whitelistedAddresses;
1540     mapping(address => bool) public freemintAddresses;
1541     mapping(address => uint256) public balances;
1542     uint256[] private _teamShares = [19, 15, 15, 15, 15, 9, 6, 3, 1, 1, 1];
1543     address[] private _team = [
1544         0x69b59DF9e946a67056c34D15392d5356cf8B1d09,
1545         0x8367E283CC671a823E7918230240ff49307709c8,
1546         0x0dB5583d46fe7c4127C59A3A8e913f413A310053,
1547         0x71510C98974778961dd80425d6b384763a8141BB,
1548         0x239F9BdD1859D46eD2e0B11BC5FDAaaE5C26fAC5,
1549         0xd26ED430d45c87d844359b367302C895C96929f1,
1550         0x3C73AF9F2Adf8CD99169d69C68Eb3542e8877B57,
1551         0x8302C108798A2856eCfb8eF32ed174CC396f1039,
1552         0x933F384a22e57870303669C452192D0ecb293afc,
1553         0x5F887298a09BfA7Cd9E588f17bf9A6eBb85e12bd,
1554         0x4d7cF77Db9Ac4A4E681eca2766Ca27168bDf5ce9
1555     ];
1556 
1557     address[] private _freemint = [
1558         0x6856c4185242B75baAA0460a28B1AaE3f7Cbd1ff,
1559         0x4bFfFe2c5785dD8938A8bEe1e28ce1Ab22Efb811,
1560         0xBA2a47e7dF7A1E327d90327d1C944dB2d016fceF,
1561         0x1e4c6b29CAd7F218cBd8493a84588850D06D9B8C,
1562         0x1B7bbf042fBDFaE039e62e6758D3e281AF9d4120,
1563         0x710b35F5D18f05BcB4356F13070b45309842E49c,
1564         0x9D4F0BA16699eB345B564800d6F97c72fB44C6a0,
1565         0xD4d14F60d0E99E7a69683CdD8da9255Bb3d792Cf,
1566         0x31524Ce745E00a945f192076a2DB282fa3b41050,
1567         0x69b59DF9e946a67056c34D15392d5356cf8B1d09,
1568         0x2906C780E7a6F098D1569Da398c71DD1769CCDdA,
1569         0xF71c62934A6927eeEeC0fbf7E72167e4336C5616,
1570         0x7A195e1D1d09e9A3bfB3e3bE4e2D3B1462f7c6c8,
1571         0x48336131b2D83C606E7fD38fADe515c3dCfF469B,
1572         0x64519f5f85e8dA14c6aAdFc45521a5c0d183dd40,
1573         0xeA85C23e6e6632f87236C369c06Da876225cE213,
1574         0xA9AA2CCC9dFc392d9F63f1E7C093C065dd0E8326,
1575         0x6C87651e920C3482912d35FefE410E266C311e8B,
1576         0xC873C17DC72df930d5E6A79854Aef1FB028Ee4a1,
1577         0x931ad0C26ed6e55775918D8319D17022732D5eD0,
1578         0xae1c7cfD49DF5e74ebC4C5aeF72bD29A388E5F9c,
1579         0xBddeF6A10475918434E8Dc4530D7BfEdfB9C4B76,
1580         0x5ad876757E6D7Ea79B84B4c3d4Cc3d8882C091dB,
1581         0x09931a7D5AD71c89F04bd25297fd33892318D70b,
1582         0xb700Bc75930662c78bFd6f4E11CfE428eA2fAf17,
1583         0x0bF91b43047Ed6B14464EE4D6732391A9dbe7be8,
1584         0x6766dD8174720D28f7Cd71Ce42fF3bFc363892f4,
1585         0x5Eb281686277dE80Ef8156a3965f6Be79aC8c51d,
1586         0xe6Ae3EecE57E315Ee5CA2B81fF059C4Ea8A6CCe2,
1587         0x60c727D4447849D5611c4fd08f024E00ee7F8Ebf,
1588         0xA7251941f230Cf552F0C972123a89108537E3Da5,
1589         0x279793Ca6773DB3cf073D3931150cA1b3bAe542D,
1590         0xb5B20e842839cfbE543c3811ae91fB089A110E78,
1591         0x29AEfCB1690745b8f80163f7f56100C4D2Dc6783,
1592         0xf7147ba5865A58f87859072436d63f1C758E0064,
1593         0x042C617d92366B0900A9cFBf6757ecfE69945Fa0,
1594         0x3b2deb1FB5AB574f1ca121FA520860ddAA11d736,
1595         0xE521959C73d3680A321D271F98bBAa57DC1af411,
1596         0x7E34c4564EdB5477f07eCCe29b4A1329441a63b5,
1597         0x5feFDb8E576BDA70f63E8e8EdaAc7426C67C6B5a,
1598         0x96a38bA834f116CbC67E7473CbBdECEAdbBf813a,
1599         0xe900Fbe2F280e608774Aeb5A28031960e420ED77,
1600         0x4EC913743a90b7B9Cf36d2907F0b12b3E36bb8bF,
1601         0xD8f47B07648F43cbCac55bb0BddBC46605290077,
1602         0xcACfB66c905BBE26518bEb93710bD4eb3f1D43e8,
1603         0x82DBa121A74a4Ce1aac6afB88622BB87937FF6Db,
1604         0xe2f81a3E16af0115665660153f24DD7C6C97064B,
1605         0x417C2408475318d6253AC8BfB8d495259c3D9b1d,
1606         0x4245c65e9b5F1Fc16A76Ca6C31c0d34C736dc4d9,
1607         0xc7349d553951D82Bcb3C9864B8CDb60729e5eaf6,
1608         0xC3E81f8f2104fB6cA80f81f7fD8AD804E513a604,
1609         0x42B6Bf95c9Baa73c82504a965a8714Df90DDFDf9,
1610         0x2DD5f56Db86A9eE0aE5c564A0c99e38DDeB23cd6,
1611         0x934c3b2ddA3EB34Dc624316DA52A72e022622f8e,
1612         0x37F9bC8FFBB43C4A30a939c7Be94A9eeB266B6DC,
1613         0x08519937699B3fA307d981125479043DA2D48bb2,
1614         0x5f4101f13c232b5bD65bED11842186C1A7203924,
1615         0xB6443a75c2a7E95Bf64DCfCa24D7dd431036c4e3,
1616         0x96A939F94383f3f7028EAe3A9AB94F66d3d7541C,
1617         0xbdE95Edb2305f9270A5e3bb778EAe03d14b68CCa,
1618         0xD378Ca5fffAa6701c2aE9a71120D702cc303c7E5,
1619         0x0d4Bb1849E8D669F170515887A7C143DD3F33310,
1620         0x6a565970C37ec3d9A6b7169bE0e419e91d173c8F,
1621         0xC428141B2eeCB2c901e2208b61E87D664473154a,
1622         0x2FbAaEEB80D2bCc8B2e36D6CaD8e31921337ED50,
1623         0xe08e347676C52C8818b76e46D71956b84B4e2F42,
1624         0x27F76D1361A76531f95D9b38DA8Cf9463056B8ce,
1625         0xE47D699fF0D480dC953069FBC023757dE70052F9,
1626         0xf3058AB3e0fBd58853B7e14eAB9041Ee849e7a61,
1627         0x235461b7cB87CBa28a91F5E2feF3CCEd0e2C8213,
1628         0xbD6fF0686654dfd73763292Cd7BEa075aF62D373,
1629         0x0f04fE8682e84dD0aB01e04728B00F65D6e994f8,
1630         0x0e8D6f2d576462bEe696D9B4cD759943518a4a86,
1631         0x74C3a7320c24af6833F685e8f424051a6c6c6A70,
1632         0x888FAfab68b701400289EF5A7496488af5C3A0e7,
1633         0x25A0Ef64bdE79eC315013B0971765EBa7f4b5C38,
1634         0xA7ba82817614e6d45Be6d3C0adB0F282Cc58654B,
1635         0x3D88B72b75e05Dcf6fD3FdB29C986887EC7BBe23,
1636         0x9D57E8FC7198a9afe31f7Cbffd350fd7a6ae6928,
1637         0xA055A40E9a298F7F073E8D50A1874ECD6dC17876,
1638         0xA65Bea89ac1aBaC7A135aeB477833f8054b9aC2b,
1639         0xD1dfA3c5794C4cE2E0AF0bf400C6FCd59E63c18D,
1640         0x1Bb44f56BC21226F9e7142e26Edfac41D2209B56,
1641         0x971D16aa905E02FA4FD305030F4a68aB940F870c,
1642         0xDb58e63662d4985e47b82Fc66482362C9b615495,
1643         0x6974535d3408a989d9D6f7a6ec62A50767715a2E,
1644         0x8642214d3cb4Eb38EE618Be37f78DD74a3093869,
1645         0xED8c6b13e9e8e9937923c9197946FBF743DA9652,
1646         0x3253BBBAcB15cC5994f2fcb04e323337060B4486,
1647         0xbC0C5acb5a65CA9deD3BdD2B0F0F36F71cD7Dd7C,
1648         0x850081ce7386e6163E3f1bdcCA75d5CFE00aD0c9,
1649         0x979E98f34d082CBeee90C7eF8C1dF5942d4f4A33,
1650         0x9342B1556AbDEB2a11580C3dbe0F6C4b73908034,
1651         0x97B9F5264Ab6350ff5D0f721510B6De061e9B8Fc,
1652         0x74A84160255ca66fE8689c1C9C286506Bf40Dd86,
1653         0xd3532Ee9a985635f505106df24ed961925995C17,
1654         0x9493dfe3588f3eBCD30E5129224d186320a44E80,
1655         0xd88948b7a22E239492a56790F9c1c1418Ab56235,
1656         0x8277c5a6c1dEe6B59B34Cf184c751f47348462Dd,
1657         0xbBeb83FFa7b1Cd7C4FB1542B0C41102891846feE,
1658         0xeFD785f5B4a08C2997E97976E313988d9f5bcD23,
1659         0xD2179324C4f053A4ce0Ef8dB264b51DC0ae36F28,
1660         0xF1a47b921c8af2dF1aF1938d4AE971f9f30A53D1,
1661         0x7766004e6D3FcbB85E0E926055435192D3efD32a,
1662         0x8C8A4e818184F701A32561d6Ccfff05DBE931D1a,
1663         0xD5e4fCeac7a6d3E815e93300e6a98232E99F1d16,
1664         0xD09bED30d34B679B2ae788827405e093E4CDB79f,
1665         0x8A2947e6c510Dc460837D064DB39e2f8cb47761C,
1666         0xD593cDeaE037babFE7a1D1bE264AD3ff682eC323,
1667         0x766967Fb94F2D63ebA81683AB64f3a3aF0939F5E,
1668         0x899AAFb2fa96f91839388C481f0CCB4a559B1B54,
1669         0xd6e4E1266162a8AB3DEF49290F0f223c55617a42,
1670         0x5d4647B9f465c7914884D9a3df7C185ED29857cF,
1671         0x3a9514c5320b61e77716388a5fd1DDfD5943A7FF,
1672         0x2b51F9Dc94089851C322fa073a609290f4a9028c,
1673         0xD09B06295c0DDC1DdE40e2D89D23D586Ed0C5f62,
1674         0x0d771F90dB99D1AF85caC5478e6048b62ede161F,
1675         0xEA54ee7226c4e2660d51aD5e2fB8740D857DEfc2,
1676         0xcA249F0bC7D5CC77A6AED5FE676ede528C97e592,
1677         0x7d6f8CB7544a4b4F685e4583eB738A416eF3E1B2,
1678         0x1cf4Fb976C31f8b429bBf8840b223B53365727C3
1679     ];
1680 
1681     address[] private _whitelist = [
1682         0xAD518777148D88Bd58D00E002fc8E45b5f446B7e,
1683         0x5CB33CCD52B77713F50e9d948Ae7726393E27382,
1684         0x51B71d2064d14dA817F2fC549a732CED8B7Cf8C9,
1685         0xfe35510eFB0F99e6821794d666b2a5569A5c7B24,
1686         0xf22E7577cE33A8b245B0EDeA5ed6889349c1a299,
1687         0x850889f786f41201e174c01442Dfcb6f71cF1378,
1688         0x87f8b399a61542da8dec4fd72d356D8355Af29C8,
1689         0x443896193d2d59CB7890Fcc7bE97388579480Dbf,
1690         0x89D19A0476333ae014994985769DD0567d38078D,
1691         0x9Ae83525AD39a614929E90185cfA3A7c10a7241F,
1692         0x455bdb872450C5D001AE7AbD514F1528B3e1200d,
1693         0xFC677f5562EECE9199CA05766d12e6CAcecd2846,
1694         0xca215e6Ef56BE6e243d496b890669559e40cc6eF,
1695         0xBe53473c8EF51c16f67AaB8C04a6D78D727DA1C9,
1696         0xBFe4E6714A4AA3c2e6C3654A10ddAf799f96de61,
1697         0x8D339dF2EdDD662cc27c830fbEf7Ab21194f7Ef4,
1698         0x6A1126Be17657AD3121a8350d78C09aBE13aCB99,
1699         0x33EbF6b1c5292330299441Bbf684b29d245D39D1,
1700         0x3E68E0717157480573204793D965A9E98E28B29f,
1701         0xAC81e6377EA7532239fCc30258C5d0fb95017c8F,
1702         0xCEF02b86e9d4dE6c154d01e1762462f215aDcBc0,
1703         0xEa54D4752Ff06f5dd56b351791E382449eEc1E4F,
1704         0x4Bc8B9a2c943c7e4aDdb1C593A14a297049607c7,
1705         0x66b1e927C3d35cbF4de05A29DcD76aE4D8947081,
1706         0x0F9AD89E821596eFcE28F55dEaBF1504d071f6eE,
1707         0x8beb8308fdf9744b69ea6E9990A9242d9E2c9874,
1708         0xb323f5141b4f90e6F601A1D049B0aA8390C1D069,
1709         0x22602754F5a7b2D298534D20Ff36E574d67854C6,
1710         0x3Dd40EF3461209737A3a55f52994213ED29826bf,
1711         0xA9E604C2C839499013c87136b24ABe734a213046,
1712         0xe3cB79Cf7ce8e7D5cB32dBf19df9Fc4f0b421995,
1713         0x0492b87512e07f4B69e179fEabAD98AB510aa5cB,
1714         0xCb6a27E8D0cCd5be971c65Bde697d31A911611Ac,
1715         0x758773d0E8Fb8F3bcc67847993059a54230bf6a2,
1716         0x314aD4E3Cd27f1300a51F70730B49794b21070B8,
1717         0xbb76799edbbfEDd6f8462140e7378f80D2C48B50,
1718         0x1C1E34C4E56d5b132b03247dA2CCeFE3d68c37cf,
1719         0x62aBD07411EB52D1Ed14cAa8e1A8987DA97b9BA0,
1720         0x226d1e6C589A2642A24C93B4F35f06426970e30C,
1721         0xD4398284DFD4301E4Ce6ED2cdbdc1E0Dc933e685,
1722         0xFB3cC3462310F26f50389EA21A3c3d0922f7E863,
1723         0xDa0A3C890603aE8248DF00BdfEcC49A94cE2dAc2,
1724         0xe4c2e41c3EE59D892585461e45bFf994B2310765,
1725         0xa60F1eEee54A2BD05e24fdE3f4c396F187c8D7DE,
1726         0xBA6D29e8Bb5A0ECcE868226bfCf4e466200bba27,
1727         0x730aF5B6d20548Ec8199DDD89A0876CAC4410563,
1728         0xC067d3834aE5C04BADC4Fb5924A7A5B317aC619b,
1729         0xCAFB7E50C67D1dC7229f892911178103fc4f0D03,
1730         0x66EC9B0683196DC6540970c061a15d61a2F3EdBF,
1731         0x3A5baFBC2dEec20d9977d1c8727BE83D55B9B8c9,
1732         0xF094e8A8F287E475f89f6dDF0cc28B5EB5EF1A8f,
1733         0x8Ac1bEFa7da1442ba11FacF2031361Cc6B5a643e,
1734         0x1AFb681A858cf655C6bC26EAA1aBb20FC2F279bF,
1735         0x69e3FAbDafaCF06aeE60a060c20475A4CF14f541,
1736         0x4C05dd7BAeae9F1c8d3985313BC7F0f080a37407,
1737         0x40DceDe97eBcb9db0CC4218C68057CE25e3b592C,
1738         0x719F0D394811D33fE88618FD4728de90706560B2,
1739         0x58627455B304F2073278Cc0D891D0da50e5d8008,
1740         0x0Fc68e59523dC0ebd99Db79a8FF2B51121652F0a,
1741         0x6Ca4a7F0c4C9D4d096796Ba1C753b37a8049390C,
1742         0xd8e20d5B3Ec873A346133479d45d7D9E989FE3f9,
1743         0x79c310EE0852a36EC5981def2420409d35923Cad,
1744         0x91eb8604FBEF0550a072611A313B68A38e9dfc3D,
1745         0x5341d0CEfe00d0DCe0543Fb458EfC9c477107E81,
1746         0x3c45eb68d1EF52214Bb17EC54b4b66610d67728a,
1747         0x896Ad41070f6d80011f09910D51851363EcdbA65,
1748         0x27527Ee841Ded49B34cf12351611652E730235fA,
1749         0x9fa18039D85271dAB21770374a16d4790dd28a89,
1750         0x564a7735cC6A043B806537173b002310b695F750,
1751         0x8d0F673FF0c87CDBa47D917e3CcA80e34207Bf54,
1752         0x89d8Fb263106dbAFE032690208733DBfF241771D,
1753         0xb827b5bbF83e22D2a058E606D239fC653462B593,
1754         0xE92F757D958B819FD5A044060522b038bA0D7A1f,
1755         0xF8883a39c6D6016253f61158A1Fe2c0679DA85Aa,
1756         0xc744BF3d4FB1b4A64C438e26100886fa1954Bd72,
1757         0xcf8CA4C3D3F1da9e61B1c92aaA46F84a71Ac7656,
1758         0x37e305B9d84AEbcAda6b44c5F55304CA61125011,
1759         0xC2137B2c22056485969b2b0BeA8F69002718cC74,
1760         0x461f2eD4F2972afD2577A0653ac9273F15df3041,
1761         0x1dAaA5625D90693DE5a27912f0FF3d2632F3079e,
1762         0x5c311deC2654c785F3c78fBb8673CAFf7493FEd8,
1763         0x2170919562d76304FE00e4fBBf5Fe2697043d205,
1764         0x7A0Fb93698C8A8Df1e6Dd5A82c55987773AE470c,
1765         0xFE62b81D19B45503529deC828D9258C8490207cf,
1766         0xEFB76D7d278Df4f5C4032e3920546e869cce1cd5,
1767         0xbad3695FCc025d4099BE6B72a94f51Ee522C7Ef9,
1768         0x2529526b89d3b748B649063262d91647437eEFeD,
1769         0x354d88273e0CbE4b66f3207b2b2050b519e606fe,
1770         0x4073250477EECcC3c7B8aF062AD775B914d6972E,
1771         0x0a7006c5a571167a1C1cdbb0a26C75637925C198,
1772         0x3A07242f26692CfA6bE526Cd0dda219E62e8a8F4,
1773         0x0De56aB94C36E31a367587e8Aa82FaBc55201423,
1774         0x87378D624fcD561D4E02e73Ca63d1cfD13D0854e,
1775         0x6bf7AdD154a848bD5BdedB5E4b056766e3829BE4,
1776         0xAeEd8dC4a12Dd8AcCa316B1a56073A3C98ada27b,
1777         0x2Bbc02C32192774c1ecCE9727b2f616Ed85AaD7E,
1778         0xe38E9F948b6e9a4adA2Eaf7Fe0cD23CCd51c5d3c,
1779         0xeb1564adF9B890527F280bBB939A3e022f24A81B,
1780         0x2fe22DC7b037Bb53feA9B75Cea374408D6bBbf78,
1781         0x5825b1250486834c96a03ac71C8E6b7dfEB72e4b,
1782         0xaED348aD21F2E72a906D918F28c07249546998Fb,
1783         0x41CD8891C2BdaD4dEeb9A1e777F29E5c9De492F1,
1784         0x625d8200cEBA526930892A884F34d534E82354e8,
1785         0xFE9504715B3599744CBC575186a21ab22378Ce43,
1786         0xA8Bb476B21D934F943AA9b22e5bD1147e1d0bE14,
1787         0xbB808992c2CB13420ebFf643293a5c68FDCF2FF8,
1788         0x6C26f980BE8935F8450a903BFcefCAC50fb77d4E,
1789         0x4f9a719420C66efdFF57178bC9D5D2bD6fdf4639,
1790         0xF5F580Ac0865Cfc8570dF0907706f3AB7C483322,
1791         0x67bB5c7C768296AD815D0d8109C027CF614B27f2,
1792         0x889AA6bbE9B87187B78bC34550F76036271BEe8a,
1793         0x03069364429c1815ac520F68277d12c7C9e9b45C,
1794         0x77C54036Cd9d353006Ec366A98920E6570efF59a,
1795         0x6F205746fF97969eFbD709b973649d3f18820dd9,
1796         0x8Dd1270731b48bd907b15554Df4dE4a33D21a1d4,
1797         0x75D0D29DF0B918538dA4Bb55Ed1A93866C8fc685,
1798         0xBC645D9c7C90c995e5dea19382a89768E8168816,
1799         0xBFbD5F6dFb06866ac458Fa2efFCE8B9Ad5FF1bc5,
1800         0x97d0cFE152797911Fae057A681Fe58E73739F9c7,
1801         0x2ceBa06d249BBfA20894e2092b77dD86dB0A9302,
1802         0x7d007D3574522Af5f17F7ddab6885585690BeA6F,
1803         0xC49ed8051843eebd2d78618E48B734D09e710dA5,
1804         0x89A6f301E1909575D4d50436f05C877502B92585,
1805         0x3788EEc9934868329A0D92713CccBA5e1f9D9f4c,
1806         0x34F92BF9290726955332B7E0730946813Ac9d3fa,
1807         0x553F49Ca80aD5E78b563A05E4D28Fdd1fB44B00b,
1808         0x1d73A4A30AE85f5101DfBb4127747D34850F5c3c,
1809         0x9c52f4afe7983705c4D0018E544D5837caf0c049,
1810         0x97Df17A92a8306fa97c6a772327ae955Cc410ca9,
1811         0x3a187B5285e0cBAC774A335b5315A64B4A9173c3,
1812         0xaBAEFebc2a98Dc02c0fa6D7F88CFf5368c1bFEE7,
1813         0xda862466999c1BB7D6d38B9c5457BC5627b80BdC,
1814         0xDF5405E5d59e3421f4735eFE49b63f0C1Ec25Cf9,
1815         0x72Dd867f119E044E31e6BD52E1fa6B7605dad4A4,
1816         0xf69eA0522Ac7022A029BC03a283725AC6B75d0C7,
1817         0x399f1C2A3771eAE1B9D53a5fa8209834868e8caC,
1818         0x0AF35D19326BB11a0d99bb4b430DB864Ab857C14,
1819         0x4397c6ab5896C8D8B21707b030e93e7037b8643d,
1820         0x631b2323d11ab1f3f5E09A0f695680379D488bd2,
1821         0xABA746cAa87c9Ab74B69C609a4F69Cc0120fc832,
1822         0xd4972F305F31a701aB5f3882043464388166912C,
1823         0x38def4f28d0071a7D9b207e6f461a67E21B8a1de,
1824         0x101F8df4E312Aa4f6ebb24241705F15716506963,
1825         0x5cD39D7dB616E60B56F1593b44A9dEAdbcBc2ccE,
1826         0x86aB8922f09923de21ECBB2e7c62d6b869772833,
1827         0x1765E68365FDb0935f9522093919950B8Ca98710,
1828         0x01df827543dc9dD766B2492e29eF1a985645Ba47,
1829         0x6e70A7cDc413DBEbf957bB5FD16C61B6665c8Bae,
1830         0x240A14190554E158f4e561BCEaD6465038b71f46,
1831         0xe2bAc6B98eCa59106f4A5bF4B5F96F299456aaf0,
1832         0xC1AfB128b3EFc6D0fA8068CE608EcEC3Fdcf5Bbf,
1833         0x178980bebd6A5AbcDA83cb45A9a9B9604995047d,
1834         0xB066d0D76c21db10e0D583E0D945Efc1128fA0b1,
1835         0x15BA99dfBb8E8E2b3ab57EF23e20e93E0ca658F1,
1836         0x8109d2849592202D07790557cD95F17310099562,
1837         0x5E3F84E3b1d2896e1Ac3D7d08B1f1106d0d3b209,
1838         0x4ACec241ea60c06D6Ab6722eBeF98725DEc3825B,
1839         0x8822354E02e5AdA352883f4D766FC6171e5e453c,
1840         0x8de855B819b9D720f52479e92FF746721BB22f86,
1841         0xd81E746EC71Fe9A095958C69100261D73C4718b6,
1842         0x65372ce086f71dBF2942B123A61b18c4D1040e2E,
1843         0xA0A828934E6E503EfFa076193c83abD9bAD4EC2F,
1844         0x583F3d3a013F3c46882BD0c7c73135Fb73632756,
1845         0xD9DC731cAF241ACC7daAc1510046BF31bDd5772f,
1846         0x6F413B49673d2f918cdE926256AB1b7191a87287,
1847         0x40a525edb28F6e9A1C52d310faD4201145862C3F,
1848         0x6Ea9823d35D0Da30bc0e801C61d9B9101061D8bf,
1849         0xB482Fd5076eCd520cdEd29881BD656183D2d7064,
1850         0x8c9BbD383eDC0dC7B207Cb3EDeA4E2D1a47507F7,
1851         0x27d56763f4E73956E5ce834d6E6c7710aA3521d3,
1852         0xB721bBDa1a7e2608CF66bCf3b3b513103cF69DF9,
1853         0x3D7ddb051eFb0846Abab9adA0168d5eCcAd7239D,
1854         0x4C566F07BD8C55Dc63caadC7dd272d3FBeF13c31,
1855         0x1072DD569516864dD3800C75a4A980A1Eb30Dc63,
1856         0xd58B7F2722371aa92C929272094c3A65482c0429,
1857         0xA942B1AF9CAbc692E8a5D80624AbB9f5e282514B,
1858         0xDDeB9f48ef957C3EAc8b2D9756979Ef5471bc05f,
1859         0x70d860cb44D51B54062AC1f72d07B32e5843e550,
1860         0x6276a59FA36661e817ee213b00dbB07F3405032a,
1861         0x805AA254d2bA27d7C086C482DDD9c78288C87963,
1862         0x19E11fa7a09fA2e5a2d6bbbFf3019aEBEfF56434,
1863         0x0b46e106B4C1A3e34A4873a46Af4154d7446D175,
1864         0x4baCf4cbdd730Da5E2d2e777971AD7508eD08C32,
1865         0x877d5e75368ee1311623Fd1cFfC83Fe0582719fA,
1866         0x543eD6291570356c650b6bA64d31B9dB036f0AD1,
1867         0xeBf8da1268d9510c01E9b3eA362771625863Aa41,
1868         0x22fbCf63F259cc6E54E58DdDC162d50EaaB0d034,
1869         0xB9fB6F62Fd54a0425ca448b564151b1B9D74BA2a,
1870         0xC1B21238311f98737A81F247bED51F4455C4c1De,
1871         0xfD808AD0B0942488E8De71Cf202AB9F55ADb2A2D,
1872         0x7EF0d352F7A77c0dF51dEF796e63a008234a7cdA,
1873         0x40FE266804031663dc7ec4cE4eA549A9De132a82,
1874         0x333F0Ffde35190B5781765499282c429F12d82b4,
1875         0x8B71Fd26Ed10A14f496965C4aFC65563A08FbC35,
1876         0x674d6a5ba766E6D43d907bB91c7bc88214D5E78c,
1877         0x83c672932d131989d642C28AAe4341F06aEe9090,
1878         0xee72B38f98Bd65811e26b2D239ec94d30C1F9457,
1879         0x0C5c79bF4fc8f85935932eeDD085c879d5cFE89D,
1880         0x5C9a49A19C0Ed8aeE4e5c560989A126Fe01568AC,
1881         0x9D89Ef8993101ade6ea898004D1a59f83fc9abf8,
1882         0x2e0dBE68B6302b8eCd423A153b938879147EE80B,
1883         0x6202A837D7E9F8443c0dD422b2cC1B124ffB1b27,
1884         0x0fb122228d710Ea0d49d914ed702660663c6b81f,
1885         0xeB5A0709188E324D5C93b2048c8E8EF54D31cAC1,
1886         0x061DB8B26D26a8AaB4bE7beA45A095EbC51da269,
1887         0x4ee4BdA6892769d6E2f653e1BcA2B667EFc7116c,
1888         0x43A1e818131aa25eAf855563Bfa53d6972d98A49,
1889         0x635b1d201Edd1c2ef315959136d3e6B0741c2573,
1890         0xBC7831bb8aF4430C59fcf8C89F652F4ADAEE82f3,
1891         0xd760aDbE1E1F33A7714585A4cB866634F127fD7E,
1892         0xB49FE211c2A96796cd13E363d837A8Cb347222Ec,
1893         0xE5c02961BD96181Ed6dE8415f9C6E766da6e62FE,
1894         0x18c1C3Cfb7BA9c5506fE5D3BE705DcFC87E96AaC,
1895         0xF438C974979a742Ca33e76702d6257E6606c93bd,
1896         0xA89fb3E1aC5Fbf850e035140E0E03f7eb663E3a1,
1897         0xDDfB4aE2d6b5cD791f0F34a2589745d333cdc0b6,
1898         0x77f68e3750Ff8949B6F60aE99285dd8C54796a0F,
1899         0x5F6A5E189e66AB884716Dda3Bb1eCd512926c52A,
1900         0x33E37c3dED2347fBDCca7d06149819Bb5Adc8948,
1901         0x1893aDea7c33df16aF0EDa122a24576ea27B5E58,
1902         0x275DB603d79E3438082d16b31A89f6D86ce886b9,
1903         0xBA42c5361fc138E62448B1c16cb0c56405d36f8A,
1904         0xD5d52FE39b4FE64782924cfEb36F655293C1cd21,
1905         0x93690461768e7bFec1Dc72e341fC702D5690d8cd,
1906         0x6a565970C37ec3d9A6b7169bE0e419e91d173c8F,
1907         0x382a21b40a36Eeaf94d7d6bff8ACaf55cA0937f5,
1908         0x909E3d07fc00C46326263739db6053676d17E964,
1909         0x5987a436cA03940F3F42a06bCDDFC268F6f7ACC1
1910     ];
1911 
1912     constructor() ERC721("Parrots` Fight Club Official", "PFC") PaymentSplitter(_team, _teamShares) {
1913         _addFreemintUsers(_freemint);
1914         _addwhitelistUsers(_whitelist);
1915     }
1916 
1917     modifier minimumMintAmount(uint256 _mintAmount) {
1918         require(_mintAmount > 0, "need to mint at least 1 NFT");
1919         _;
1920     }
1921 
1922     // INTERNAL
1923     function _baseURI() internal view virtual override returns (string memory) {
1924         return baseURI;
1925     }
1926 
1927     function totalSupply() public view returns(uint256) {
1928         return supply.current();
1929     }
1930 
1931     function freemintValidations(uint256 _mintAmount) internal view {
1932         require(isFreemint(msg.sender), "user is not in freemint list");
1933         require(_mintAmount <= maxMintAmountFreemint, "max mint amount pre transaction exceeded");
1934         require(balances[msg.sender] < 1, "you have already minted");
1935     }
1936 
1937     function presaleValidations(uint256 _mintAmount) internal {
1938         require(isWhitelisted(msg.sender), "user is not whitelisted");
1939         require(msg.value >= preSaleCost * _mintAmount, "insufficient funds");
1940         require(_mintAmount <= maxMintAmountPresale, "max mint amount per transaction exceeded");
1941         require(balances[msg.sender] < 1, "you have already minted");
1942     }
1943 
1944     function publicsaleValidations(uint256 _ownerMintedCount, uint256 _mintAmount) internal {
1945         require(_ownerMintedCount + _mintAmount <= nftPerAddressLimit,"max NFT per address exceeded");
1946         require(msg.value >= cost * _mintAmount, "insufficient funds");
1947         require(_mintAmount <= maxMintAmount,"max mint amount per transaction exceeded");
1948     }
1949 
1950     //MINT
1951     function mint(uint256 _mintAmount) public payable minimumMintAmount(_mintAmount) {
1952         require(supply.current() + _mintAmount <= maxSupply, "max NFT limit exceeded");
1953         require(preSaleState == true || publicSaleState == true, "sale not started");
1954         uint ownerMintedCount = balanceOf(msg.sender);
1955 
1956         if (preSaleState) {
1957             if (isWhitelisted(msg.sender)) {
1958                 presaleValidations(_mintAmount);
1959             }
1960             else {
1961                 freemintValidations(_mintAmount);
1962             }
1963         }
1964         else {
1965             publicsaleValidations(ownerMintedCount, _mintAmount);
1966         }
1967 
1968         for (uint256 i = 0; i < _mintAmount; i++) {
1969             balances[msg.sender] += 1;
1970             _safeMint(msg.sender, supply.current());
1971             supply.increment();
1972         }
1973     }
1974 
1975     //PUBLIC VIEWS
1976     function getCurrentCost() public view returns (uint256) {
1977         if (publicSaleState == true) {
1978             return cost;
1979         }
1980         else if (preSaleState == true) {
1981             if (isWhitelisted(msg.sender)) {
1982                 return preSaleCost;
1983             }
1984             else {
1985                 return 0;
1986             }
1987         }
1988         else {
1989             return 0;
1990         }
1991     }
1992 
1993     function walletOfOwner(address _owner) public view returns (uint256[] memory) {
1994         uint256 ownerTokenCount = balanceOf(_owner);
1995         uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1996         uint256 currentTokenId = 0;
1997         uint256 ownedTokenIndex = 0;
1998 
1999         while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
2000             address currentTokenOwner = ownerOf(currentTokenId);
2001 
2002             if (currentTokenOwner == _owner) {
2003                 ownedTokenIds[ownedTokenIndex] = currentTokenId;
2004 
2005                 ownedTokenIndex++;
2006             }
2007 
2008             currentTokenId++;
2009         }
2010 
2011         return ownedTokenIds;
2012     }
2013 
2014     function isWhitelisted(address _user) public view returns (bool) {
2015         return whitelistedAddresses[_user];
2016     }
2017 
2018     function isFreemint(address _user) public view returns (bool) {
2019         return freemintAddresses[_user];
2020     }
2021 
2022     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2023         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
2024 
2025         string memory currentBaseURI = _baseURI();
2026         return bytes(currentBaseURI).length > 0 ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension)) : "";
2027     }
2028 
2029     //ONLY OWNER VIEWS
2030     function getMintState() public view returns (string memory) {
2031         if (preSaleState) {
2032             return "preSale";
2033         }
2034         else if (publicSaleState) {
2035             return "publicSale";
2036         }
2037         else {
2038             return "";
2039         }
2040     }
2041 
2042     //ONLY OWNER SETTERS
2043     function setBaseURI(string memory _newBaseURI) public onlyOwner {
2044         baseURI = _newBaseURI;
2045     }
2046 
2047     function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
2048         baseExtension = _newBaseExtension;
2049     }
2050 
2051     function _activatePreSale() public onlyOwner {
2052         preSaleState = true;
2053         publicSaleState = false;
2054     }
2055 
2056     function _activatePublicSale() public onlyOwner {
2057         preSaleState = false;
2058         publicSaleState = true;
2059     }
2060 
2061     function _addwhitelistUsers(address[] memory addresses) public onlyOwner {
2062         for (uint256 i = 0; i < addresses.length; i++) {
2063             whitelistedAddresses[addresses[i]] = true;
2064         }
2065     }
2066 
2067     function _addFreemintUsers(address[] memory addresses) public onlyOwner {
2068         for (uint i = 0; i < addresses.length; i++) {
2069             freemintAddresses[addresses[i]] = true;
2070         }
2071     }
2072 
2073     function _withdrawForAll() public onlyOwner {
2074         for (uint i = 0; i < _team.length; i++) {
2075             release(payable(_team[i]));
2076         }
2077     }
2078 }