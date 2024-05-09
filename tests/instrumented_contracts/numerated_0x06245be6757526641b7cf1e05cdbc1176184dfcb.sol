1 // Sources flattened with hardhat v2.4.0 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/Context.sol@v4.5.0
4 
5 // SPDX-License-Identifier: MIT
6 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Provides information about the current execution context, including the
12  * sender of the transaction and its data. While these are generally available
13  * via msg.sender and msg.data, they should not be accessed in such a direct
14  * manner, since when dealing with meta-transactions the account sending and
15  * paying for execution may not be the actual sender (as far as an application
16  * is concerned).
17  *
18  * This contract is only required for intermediate, library-like contracts.
19  */
20 abstract contract Context {
21     function _msgSender() internal view virtual returns (address) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal view virtual returns (bytes calldata) {
26         return msg.data;
27     }
28 }
29 
30 
31 // File @openzeppelin/contracts/access/Ownable.sol@v4.5.0
32 
33 
34 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
35 
36 pragma solidity ^0.8.0;
37 
38 /**
39  * @dev Contract module which provides a basic access control mechanism, where
40  * there is an account (an owner) that can be granted exclusive access to
41  * specific functions.
42  *
43  * By default, the owner account will be the one that deploys the contract. This
44  * can later be changed with {transferOwnership}.
45  *
46  * This module is used through inheritance. It will make available the modifier
47  * `onlyOwner`, which can be applied to your functions to restrict their use to
48  * the owner.
49  */
50 abstract contract Ownable is Context {
51     address private _owner;
52 
53     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
54 
55     /**
56      * @dev Initializes the contract setting the deployer as the initial owner.
57      */
58     constructor() {
59         _transferOwnership(_msgSender());
60     }
61 
62     /**
63      * @dev Returns the address of the current owner.
64      */
65     function owner() public view virtual returns (address) {
66         return _owner;
67     }
68 
69     /**
70      * @dev Throws if called by any account other than the owner.
71      */
72     modifier onlyOwner() {
73         require(owner() == _msgSender(), "Ownable: caller is not the owner");
74         _;
75     }
76 
77     /**
78      * @dev Leaves the contract without owner. It will not be possible to call
79      * `onlyOwner` functions anymore. Can only be called by the current owner.
80      *
81      * NOTE: Renouncing ownership will leave the contract without an owner,
82      * thereby removing any functionality that is only available to the owner.
83      */
84     function renounceOwnership() public virtual onlyOwner {
85         _transferOwnership(address(0));
86     }
87 
88     /**
89      * @dev Transfers ownership of the contract to a new account (`newOwner`).
90      * Can only be called by the current owner.
91      */
92     function transferOwnership(address newOwner) public virtual onlyOwner {
93         require(newOwner != address(0), "Ownable: new owner is the zero address");
94         _transferOwnership(newOwner);
95     }
96 
97     /**
98      * @dev Transfers ownership of the contract to a new account (`newOwner`).
99      * Internal function without access restriction.
100      */
101     function _transferOwnership(address newOwner) internal virtual {
102         address oldOwner = _owner;
103         _owner = newOwner;
104         emit OwnershipTransferred(oldOwner, newOwner);
105     }
106 }
107 
108 
109 // File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.5.0
110 
111 
112 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
113 
114 pragma solidity ^0.8.0;
115 
116 /**
117  * @dev Contract module that helps prevent reentrant calls to a function.
118  *
119  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
120  * available, which can be applied to functions to make sure there are no nested
121  * (reentrant) calls to them.
122  *
123  * Note that because there is a single `nonReentrant` guard, functions marked as
124  * `nonReentrant` may not call one another. This can be worked around by making
125  * those functions `private`, and then adding `external` `nonReentrant` entry
126  * points to them.
127  *
128  * TIP: If you would like to learn more about reentrancy and alternative ways
129  * to protect against it, check out our blog post
130  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
131  */
132 abstract contract ReentrancyGuard {
133     // Booleans are more expensive than uint256 or any type that takes up a full
134     // word because each write operation emits an extra SLOAD to first read the
135     // slot's contents, replace the bits taken up by the boolean, and then write
136     // back. This is the compiler's defense against contract upgrades and
137     // pointer aliasing, and it cannot be disabled.
138 
139     // The values being non-zero value makes deployment a bit more expensive,
140     // but in exchange the refund on every call to nonReentrant will be lower in
141     // amount. Since refunds are capped to a percentage of the total
142     // transaction's gas, it is best to keep them low in cases like this one, to
143     // increase the likelihood of the full refund coming into effect.
144     uint256 private constant _NOT_ENTERED = 1;
145     uint256 private constant _ENTERED = 2;
146 
147     uint256 private _status;
148 
149     constructor() {
150         _status = _NOT_ENTERED;
151     }
152 
153     /**
154      * @dev Prevents a contract from calling itself, directly or indirectly.
155      * Calling a `nonReentrant` function from another `nonReentrant`
156      * function is not supported. It is possible to prevent this from happening
157      * by making the `nonReentrant` function external, and making it call a
158      * `private` function that does the actual work.
159      */
160     modifier nonReentrant() {
161         // On the first call to nonReentrant, _notEntered will be true
162         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
163 
164         // Any calls to nonReentrant after this point will fail
165         _status = _ENTERED;
166 
167         _;
168 
169         // By storing the original value once again, a refund is triggered (see
170         // https://eips.ethereum.org/EIPS/eip-2200)
171         _status = _NOT_ENTERED;
172     }
173 }
174 
175 
176 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.5.0
177 
178 
179 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
180 
181 pragma solidity ^0.8.0;
182 
183 /**
184  * @dev Interface of the ERC20 standard as defined in the EIP.
185  */
186 interface IERC20 {
187     /**
188      * @dev Returns the amount of tokens in existence.
189      */
190     function totalSupply() external view returns (uint256);
191 
192     /**
193      * @dev Returns the amount of tokens owned by `account`.
194      */
195     function balanceOf(address account) external view returns (uint256);
196 
197     /**
198      * @dev Moves `amount` tokens from the caller's account to `to`.
199      *
200      * Returns a boolean value indicating whether the operation succeeded.
201      *
202      * Emits a {Transfer} event.
203      */
204     function transfer(address to, uint256 amount) external returns (bool);
205 
206     /**
207      * @dev Returns the remaining number of tokens that `spender` will be
208      * allowed to spend on behalf of `owner` through {transferFrom}. This is
209      * zero by default.
210      *
211      * This value changes when {approve} or {transferFrom} are called.
212      */
213     function allowance(address owner, address spender) external view returns (uint256);
214 
215     /**
216      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
217      *
218      * Returns a boolean value indicating whether the operation succeeded.
219      *
220      * IMPORTANT: Beware that changing an allowance with this method brings the risk
221      * that someone may use both the old and the new allowance by unfortunate
222      * transaction ordering. One possible solution to mitigate this race
223      * condition is to first reduce the spender's allowance to 0 and set the
224      * desired value afterwards:
225      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
226      *
227      * Emits an {Approval} event.
228      */
229     function approve(address spender, uint256 amount) external returns (bool);
230 
231     /**
232      * @dev Moves `amount` tokens from `from` to `to` using the
233      * allowance mechanism. `amount` is then deducted from the caller's
234      * allowance.
235      *
236      * Returns a boolean value indicating whether the operation succeeded.
237      *
238      * Emits a {Transfer} event.
239      */
240     function transferFrom(
241         address from,
242         address to,
243         uint256 amount
244     ) external returns (bool);
245 
246     /**
247      * @dev Emitted when `value` tokens are moved from one account (`from`) to
248      * another (`to`).
249      *
250      * Note that `value` may be zero.
251      */
252     event Transfer(address indexed from, address indexed to, uint256 value);
253 
254     /**
255      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
256      * a call to {approve}. `value` is the new allowance.
257      */
258     event Approval(address indexed owner, address indexed spender, uint256 value);
259 }
260 
261 
262 // File @openzeppelin/contracts/utils/Address.sol@v4.5.0
263 
264 
265 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
266 
267 pragma solidity ^0.8.1;
268 
269 /**
270  * @dev Collection of functions related to the address type
271  */
272 library Address {
273     /**
274      * @dev Returns true if `account` is a contract.
275      *
276      * [IMPORTANT]
277      * ====
278      * It is unsafe to assume that an address for which this function returns
279      * false is an externally-owned account (EOA) and not a contract.
280      *
281      * Among others, `isContract` will return false for the following
282      * types of addresses:
283      *
284      *  - an externally-owned account
285      *  - a contract in construction
286      *  - an address where a contract will be created
287      *  - an address where a contract lived, but was destroyed
288      * ====
289      *
290      * [IMPORTANT]
291      * ====
292      * You shouldn't rely on `isContract` to protect against flash loan attacks!
293      *
294      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
295      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
296      * constructor.
297      * ====
298      */
299     function isContract(address account) internal view returns (bool) {
300         // This method relies on extcodesize/address.code.length, which returns 0
301         // for contracts in construction, since the code is only stored at the end
302         // of the constructor execution.
303 
304         return account.code.length > 0;
305     }
306 
307     /**
308      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
309      * `recipient`, forwarding all available gas and reverting on errors.
310      *
311      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
312      * of certain opcodes, possibly making contracts go over the 2300 gas limit
313      * imposed by `transfer`, making them unable to receive funds via
314      * `transfer`. {sendValue} removes this limitation.
315      *
316      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
317      *
318      * IMPORTANT: because control is transferred to `recipient`, care must be
319      * taken to not create reentrancy vulnerabilities. Consider using
320      * {ReentrancyGuard} or the
321      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
322      */
323     function sendValue(address payable recipient, uint256 amount) internal {
324         require(address(this).balance >= amount, "Address: insufficient balance");
325 
326         (bool success, ) = recipient.call{value: amount}("");
327         require(success, "Address: unable to send value, recipient may have reverted");
328     }
329 
330     /**
331      * @dev Performs a Solidity function call using a low level `call`. A
332      * plain `call` is an unsafe replacement for a function call: use this
333      * function instead.
334      *
335      * If `target` reverts with a revert reason, it is bubbled up by this
336      * function (like regular Solidity function calls).
337      *
338      * Returns the raw returned data. To convert to the expected return value,
339      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
340      *
341      * Requirements:
342      *
343      * - `target` must be a contract.
344      * - calling `target` with `data` must not revert.
345      *
346      * _Available since v3.1._
347      */
348     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
349         return functionCall(target, data, "Address: low-level call failed");
350     }
351 
352     /**
353      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
354      * `errorMessage` as a fallback revert reason when `target` reverts.
355      *
356      * _Available since v3.1._
357      */
358     function functionCall(
359         address target,
360         bytes memory data,
361         string memory errorMessage
362     ) internal returns (bytes memory) {
363         return functionCallWithValue(target, data, 0, errorMessage);
364     }
365 
366     /**
367      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
368      * but also transferring `value` wei to `target`.
369      *
370      * Requirements:
371      *
372      * - the calling contract must have an ETH balance of at least `value`.
373      * - the called Solidity function must be `payable`.
374      *
375      * _Available since v3.1._
376      */
377     function functionCallWithValue(
378         address target,
379         bytes memory data,
380         uint256 value
381     ) internal returns (bytes memory) {
382         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
383     }
384 
385     /**
386      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
387      * with `errorMessage` as a fallback revert reason when `target` reverts.
388      *
389      * _Available since v3.1._
390      */
391     function functionCallWithValue(
392         address target,
393         bytes memory data,
394         uint256 value,
395         string memory errorMessage
396     ) internal returns (bytes memory) {
397         require(address(this).balance >= value, "Address: insufficient balance for call");
398         require(isContract(target), "Address: call to non-contract");
399 
400         (bool success, bytes memory returndata) = target.call{value: value}(data);
401         return verifyCallResult(success, returndata, errorMessage);
402     }
403 
404     /**
405      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
406      * but performing a static call.
407      *
408      * _Available since v3.3._
409      */
410     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
411         return functionStaticCall(target, data, "Address: low-level static call failed");
412     }
413 
414     /**
415      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
416      * but performing a static call.
417      *
418      * _Available since v3.3._
419      */
420     function functionStaticCall(
421         address target,
422         bytes memory data,
423         string memory errorMessage
424     ) internal view returns (bytes memory) {
425         require(isContract(target), "Address: static call to non-contract");
426 
427         (bool success, bytes memory returndata) = target.staticcall(data);
428         return verifyCallResult(success, returndata, errorMessage);
429     }
430 
431     /**
432      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
433      * but performing a delegate call.
434      *
435      * _Available since v3.4._
436      */
437     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
438         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
439     }
440 
441     /**
442      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
443      * but performing a delegate call.
444      *
445      * _Available since v3.4._
446      */
447     function functionDelegateCall(
448         address target,
449         bytes memory data,
450         string memory errorMessage
451     ) internal returns (bytes memory) {
452         require(isContract(target), "Address: delegate call to non-contract");
453 
454         (bool success, bytes memory returndata) = target.delegatecall(data);
455         return verifyCallResult(success, returndata, errorMessage);
456     }
457 
458     /**
459      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
460      * revert reason using the provided one.
461      *
462      * _Available since v4.3._
463      */
464     function verifyCallResult(
465         bool success,
466         bytes memory returndata,
467         string memory errorMessage
468     ) internal pure returns (bytes memory) {
469         if (success) {
470             return returndata;
471         } else {
472             // Look for revert reason and bubble it up if present
473             if (returndata.length > 0) {
474                 // The easiest way to bubble the revert reason is using memory via assembly
475 
476                 assembly {
477                     let returndata_size := mload(returndata)
478                     revert(add(32, returndata), returndata_size)
479                 }
480             } else {
481                 revert(errorMessage);
482             }
483         }
484     }
485 }
486 
487 
488 // File @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol@v4.5.0
489 
490 
491 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
492 
493 pragma solidity ^0.8.0;
494 
495 
496 /**
497  * @title SafeERC20
498  * @dev Wrappers around ERC20 operations that throw on failure (when the token
499  * contract returns false). Tokens that return no value (and instead revert or
500  * throw on failure) are also supported, non-reverting calls are assumed to be
501  * successful.
502  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
503  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
504  */
505 library SafeERC20 {
506     using Address for address;
507 
508     function safeTransfer(
509         IERC20 token,
510         address to,
511         uint256 value
512     ) internal {
513         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
514     }
515 
516     function safeTransferFrom(
517         IERC20 token,
518         address from,
519         address to,
520         uint256 value
521     ) internal {
522         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
523     }
524 
525     /**
526      * @dev Deprecated. This function has issues similar to the ones found in
527      * {IERC20-approve}, and its usage is discouraged.
528      *
529      * Whenever possible, use {safeIncreaseAllowance} and
530      * {safeDecreaseAllowance} instead.
531      */
532     function safeApprove(
533         IERC20 token,
534         address spender,
535         uint256 value
536     ) internal {
537         // safeApprove should only be called when setting an initial allowance,
538         // or when resetting it to zero. To increase and decrease it, use
539         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
540         require(
541             (value == 0) || (token.allowance(address(this), spender) == 0),
542             "SafeERC20: approve from non-zero to non-zero allowance"
543         );
544         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
545     }
546 
547     function safeIncreaseAllowance(
548         IERC20 token,
549         address spender,
550         uint256 value
551     ) internal {
552         uint256 newAllowance = token.allowance(address(this), spender) + value;
553         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
554     }
555 
556     function safeDecreaseAllowance(
557         IERC20 token,
558         address spender,
559         uint256 value
560     ) internal {
561         unchecked {
562             uint256 oldAllowance = token.allowance(address(this), spender);
563             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
564             uint256 newAllowance = oldAllowance - value;
565             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
566         }
567     }
568 
569     /**
570      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
571      * on the return value: the return value is optional (but if data is returned, it must not be false).
572      * @param token The token targeted by the call.
573      * @param data The call data (encoded using abi.encode or one of its variants).
574      */
575     function _callOptionalReturn(IERC20 token, bytes memory data) private {
576         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
577         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
578         // the target address contains contract code and also asserts for success in the low-level call.
579 
580         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
581         if (returndata.length > 0) {
582             // Return data is optional
583             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
584         }
585     }
586 }
587 
588 
589 // File @openzeppelin/contracts/finance/PaymentSplitter.sol@v4.5.0
590 
591 
592 // OpenZeppelin Contracts v4.4.1 (finance/PaymentSplitter.sol)
593 
594 pragma solidity ^0.8.0;
595 
596 
597 
598 /**
599  * @title PaymentSplitter
600  * @dev This contract allows to split Ether payments among a group of accounts. The sender does not need to be aware
601  * that the Ether will be split in this way, since it is handled transparently by the contract.
602  *
603  * The split can be in equal parts or in any other arbitrary proportion. The way this is specified is by assigning each
604  * account to a number of shares. Of all the Ether that this contract receives, each account will then be able to claim
605  * an amount proportional to the percentage of total shares they were assigned.
606  *
607  * `PaymentSplitter` follows a _pull payment_ model. This means that payments are not automatically forwarded to the
608  * accounts but kept in this contract, and the actual transfer is triggered as a separate step by calling the {release}
609  * function.
610  *
611  * NOTE: This contract assumes that ERC20 tokens will behave similarly to native tokens (Ether). Rebasing tokens, and
612  * tokens that apply fees during transfers, are likely to not be supported as expected. If in doubt, we encourage you
613  * to run tests before sending real value to this contract.
614  */
615 contract PaymentSplitter is Context {
616     event PayeeAdded(address account, uint256 shares);
617     event PaymentReleased(address to, uint256 amount);
618     event ERC20PaymentReleased(IERC20 indexed token, address to, uint256 amount);
619     event PaymentReceived(address from, uint256 amount);
620 
621     uint256 private _totalShares;
622     uint256 private _totalReleased;
623 
624     mapping(address => uint256) private _shares;
625     mapping(address => uint256) private _released;
626     address[] private _payees;
627 
628     mapping(IERC20 => uint256) private _erc20TotalReleased;
629     mapping(IERC20 => mapping(address => uint256)) private _erc20Released;
630 
631     /**
632      * @dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at
633      * the matching position in the `shares` array.
634      *
635      * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no
636      * duplicates in `payees`.
637      */
638     constructor(address[] memory payees, uint256[] memory shares_) payable {
639         require(payees.length == shares_.length, "PaymentSplitter: payees and shares length mismatch");
640         require(payees.length > 0, "PaymentSplitter: no payees");
641 
642         for (uint256 i = 0; i < payees.length; i++) {
643             _addPayee(payees[i], shares_[i]);
644         }
645     }
646 
647     /**
648      * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully
649      * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
650      * reliability of the events, and not the actual splitting of Ether.
651      *
652      * To learn more about this see the Solidity documentation for
653      * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
654      * functions].
655      */
656     receive() external payable virtual {
657         emit PaymentReceived(_msgSender(), msg.value);
658     }
659 
660     /**
661      * @dev Getter for the total shares held by payees.
662      */
663     function totalShares() public view returns (uint256) {
664         return _totalShares;
665     }
666 
667     /**
668      * @dev Getter for the total amount of Ether already released.
669      */
670     function totalReleased() public view returns (uint256) {
671         return _totalReleased;
672     }
673 
674     /**
675      * @dev Getter for the total amount of `token` already released. `token` should be the address of an IERC20
676      * contract.
677      */
678     function totalReleased(IERC20 token) public view returns (uint256) {
679         return _erc20TotalReleased[token];
680     }
681 
682     /**
683      * @dev Getter for the amount of shares held by an account.
684      */
685     function shares(address account) public view returns (uint256) {
686         return _shares[account];
687     }
688 
689     /**
690      * @dev Getter for the amount of Ether already released to a payee.
691      */
692     function released(address account) public view returns (uint256) {
693         return _released[account];
694     }
695 
696     /**
697      * @dev Getter for the amount of `token` tokens already released to a payee. `token` should be the address of an
698      * IERC20 contract.
699      */
700     function released(IERC20 token, address account) public view returns (uint256) {
701         return _erc20Released[token][account];
702     }
703 
704     /**
705      * @dev Getter for the address of the payee number `index`.
706      */
707     function payee(uint256 index) public view returns (address) {
708         return _payees[index];
709     }
710 
711     /**
712      * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
713      * total shares and their previous withdrawals.
714      */
715     function release(address payable account) public virtual {
716         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
717 
718         uint256 totalReceived = address(this).balance + totalReleased();
719         uint256 payment = _pendingPayment(account, totalReceived, released(account));
720 
721         require(payment != 0, "PaymentSplitter: account is not due payment");
722 
723         _released[account] += payment;
724         _totalReleased += payment;
725 
726         Address.sendValue(account, payment);
727         emit PaymentReleased(account, payment);
728     }
729 
730     /**
731      * @dev Triggers a transfer to `account` of the amount of `token` tokens they are owed, according to their
732      * percentage of the total shares and their previous withdrawals. `token` must be the address of an IERC20
733      * contract.
734      */
735     function release(IERC20 token, address account) public virtual {
736         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
737 
738         uint256 totalReceived = token.balanceOf(address(this)) + totalReleased(token);
739         uint256 payment = _pendingPayment(account, totalReceived, released(token, account));
740 
741         require(payment != 0, "PaymentSplitter: account is not due payment");
742 
743         _erc20Released[token][account] += payment;
744         _erc20TotalReleased[token] += payment;
745 
746         SafeERC20.safeTransfer(token, account, payment);
747         emit ERC20PaymentReleased(token, account, payment);
748     }
749 
750     /**
751      * @dev internal logic for computing the pending payment of an `account` given the token historical balances and
752      * already released amounts.
753      */
754     function _pendingPayment(
755         address account,
756         uint256 totalReceived,
757         uint256 alreadyReleased
758     ) private view returns (uint256) {
759         return (totalReceived * _shares[account]) / _totalShares - alreadyReleased;
760     }
761 
762     /**
763      * @dev Add a new payee to the contract.
764      * @param account The address of the payee to add.
765      * @param shares_ The number of shares owned by the payee.
766      */
767     function _addPayee(address account, uint256 shares_) private {
768         require(account != address(0), "PaymentSplitter: account is the zero address");
769         require(shares_ > 0, "PaymentSplitter: shares are 0");
770         require(_shares[account] == 0, "PaymentSplitter: account already has shares");
771 
772         _payees.push(account);
773         _shares[account] = shares_;
774         _totalShares = _totalShares + shares_;
775         emit PayeeAdded(account, shares_);
776     }
777 }
778 
779 
780 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.5.0
781 
782 
783 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
784 
785 pragma solidity ^0.8.0;
786 
787 /**
788  * @dev Interface of the ERC165 standard, as defined in the
789  * https://eips.ethereum.org/EIPS/eip-165[EIP].
790  *
791  * Implementers can declare support of contract interfaces, which can then be
792  * queried by others ({ERC165Checker}).
793  *
794  * For an implementation, see {ERC165}.
795  */
796 interface IERC165 {
797     /**
798      * @dev Returns true if this contract implements the interface defined by
799      * `interfaceId`. See the corresponding
800      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
801      * to learn more about how these ids are created.
802      *
803      * This function call must use less than 30 000 gas.
804      */
805     function supportsInterface(bytes4 interfaceId) external view returns (bool);
806 }
807 
808 
809 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.5.0
810 
811 
812 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
813 
814 pragma solidity ^0.8.0;
815 
816 /**
817  * @dev Required interface of an ERC721 compliant contract.
818  */
819 interface IERC721 is IERC165 {
820     /**
821      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
822      */
823     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
824 
825     /**
826      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
827      */
828     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
829 
830     /**
831      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
832      */
833     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
834 
835     /**
836      * @dev Returns the number of tokens in ``owner``'s account.
837      */
838     function balanceOf(address owner) external view returns (uint256 balance);
839 
840     /**
841      * @dev Returns the owner of the `tokenId` token.
842      *
843      * Requirements:
844      *
845      * - `tokenId` must exist.
846      */
847     function ownerOf(uint256 tokenId) external view returns (address owner);
848 
849     /**
850      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
851      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
852      *
853      * Requirements:
854      *
855      * - `from` cannot be the zero address.
856      * - `to` cannot be the zero address.
857      * - `tokenId` token must exist and be owned by `from`.
858      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
859      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
860      *
861      * Emits a {Transfer} event.
862      */
863     function safeTransferFrom(
864         address from,
865         address to,
866         uint256 tokenId
867     ) external;
868 
869     /**
870      * @dev Transfers `tokenId` token from `from` to `to`.
871      *
872      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
873      *
874      * Requirements:
875      *
876      * - `from` cannot be the zero address.
877      * - `to` cannot be the zero address.
878      * - `tokenId` token must be owned by `from`.
879      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
880      *
881      * Emits a {Transfer} event.
882      */
883     function transferFrom(
884         address from,
885         address to,
886         uint256 tokenId
887     ) external;
888 
889     /**
890      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
891      * The approval is cleared when the token is transferred.
892      *
893      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
894      *
895      * Requirements:
896      *
897      * - The caller must own the token or be an approved operator.
898      * - `tokenId` must exist.
899      *
900      * Emits an {Approval} event.
901      */
902     function approve(address to, uint256 tokenId) external;
903 
904     /**
905      * @dev Returns the account approved for `tokenId` token.
906      *
907      * Requirements:
908      *
909      * - `tokenId` must exist.
910      */
911     function getApproved(uint256 tokenId) external view returns (address operator);
912 
913     /**
914      * @dev Approve or remove `operator` as an operator for the caller.
915      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
916      *
917      * Requirements:
918      *
919      * - The `operator` cannot be the caller.
920      *
921      * Emits an {ApprovalForAll} event.
922      */
923     function setApprovalForAll(address operator, bool _approved) external;
924 
925     /**
926      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
927      *
928      * See {setApprovalForAll}
929      */
930     function isApprovedForAll(address owner, address operator) external view returns (bool);
931 
932     /**
933      * @dev Safely transfers `tokenId` token from `from` to `to`.
934      *
935      * Requirements:
936      *
937      * - `from` cannot be the zero address.
938      * - `to` cannot be the zero address.
939      * - `tokenId` token must exist and be owned by `from`.
940      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
941      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
942      *
943      * Emits a {Transfer} event.
944      */
945     function safeTransferFrom(
946         address from,
947         address to,
948         uint256 tokenId,
949         bytes calldata data
950     ) external;
951 }
952 
953 
954 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.5.0
955 
956 
957 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
958 
959 pragma solidity ^0.8.0;
960 
961 /**
962  * @title ERC721 token receiver interface
963  * @dev Interface for any contract that wants to support safeTransfers
964  * from ERC721 asset contracts.
965  */
966 interface IERC721Receiver {
967     /**
968      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
969      * by `operator` from `from`, this function is called.
970      *
971      * It must return its Solidity selector to confirm the token transfer.
972      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
973      *
974      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
975      */
976     function onERC721Received(
977         address operator,
978         address from,
979         uint256 tokenId,
980         bytes calldata data
981     ) external returns (bytes4);
982 }
983 
984 
985 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.5.0
986 
987 
988 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
989 
990 pragma solidity ^0.8.0;
991 
992 /**
993  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
994  * @dev See https://eips.ethereum.org/EIPS/eip-721
995  */
996 interface IERC721Metadata is IERC721 {
997     /**
998      * @dev Returns the token collection name.
999      */
1000     function name() external view returns (string memory);
1001 
1002     /**
1003      * @dev Returns the token collection symbol.
1004      */
1005     function symbol() external view returns (string memory);
1006 
1007     /**
1008      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1009      */
1010     function tokenURI(uint256 tokenId) external view returns (string memory);
1011 }
1012 
1013 
1014 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.5.0
1015 
1016 
1017 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
1018 
1019 pragma solidity ^0.8.0;
1020 
1021 /**
1022  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1023  * @dev See https://eips.ethereum.org/EIPS/eip-721
1024  */
1025 interface IERC721Enumerable is IERC721 {
1026     /**
1027      * @dev Returns the total amount of tokens stored by the contract.
1028      */
1029     function totalSupply() external view returns (uint256);
1030 
1031     /**
1032      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1033      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1034      */
1035     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1036 
1037     /**
1038      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1039      * Use along with {totalSupply} to enumerate all tokens.
1040      */
1041     function tokenByIndex(uint256 index) external view returns (uint256);
1042 }
1043 
1044 
1045 // File @openzeppelin/contracts/utils/Strings.sol@v4.5.0
1046 
1047 
1048 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
1049 
1050 pragma solidity ^0.8.0;
1051 
1052 /**
1053  * @dev String operations.
1054  */
1055 library Strings {
1056     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1057 
1058     /**
1059      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1060      */
1061     function toString(uint256 value) internal pure returns (string memory) {
1062         // Inspired by OraclizeAPI's implementation - MIT licence
1063         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1064 
1065         if (value == 0) {
1066             return "0";
1067         }
1068         uint256 temp = value;
1069         uint256 digits;
1070         while (temp != 0) {
1071             digits++;
1072             temp /= 10;
1073         }
1074         bytes memory buffer = new bytes(digits);
1075         while (value != 0) {
1076             digits -= 1;
1077             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1078             value /= 10;
1079         }
1080         return string(buffer);
1081     }
1082 
1083     /**
1084      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1085      */
1086     function toHexString(uint256 value) internal pure returns (string memory) {
1087         if (value == 0) {
1088             return "0x00";
1089         }
1090         uint256 temp = value;
1091         uint256 length = 0;
1092         while (temp != 0) {
1093             length++;
1094             temp >>= 8;
1095         }
1096         return toHexString(value, length);
1097     }
1098 
1099     /**
1100      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1101      */
1102     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1103         bytes memory buffer = new bytes(2 * length + 2);
1104         buffer[0] = "0";
1105         buffer[1] = "x";
1106         for (uint256 i = 2 * length + 1; i > 1; --i) {
1107             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1108             value >>= 4;
1109         }
1110         require(value == 0, "Strings: hex length insufficient");
1111         return string(buffer);
1112     }
1113 }
1114 
1115 
1116 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.5.0
1117 
1118 
1119 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1120 
1121 pragma solidity ^0.8.0;
1122 
1123 /**
1124  * @dev Implementation of the {IERC165} interface.
1125  *
1126  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1127  * for the additional interface id that will be supported. For example:
1128  *
1129  * ```solidity
1130  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1131  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1132  * }
1133  * ```
1134  *
1135  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1136  */
1137 abstract contract ERC165 is IERC165 {
1138     /**
1139      * @dev See {IERC165-supportsInterface}.
1140      */
1141     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1142         return interfaceId == type(IERC165).interfaceId;
1143     }
1144 }
1145 
1146 
1147 // File contracts/libs/ERC721A.sol
1148 
1149 
1150 // Creator: Chiru Labs
1151 
1152 pragma solidity ^0.8.4;
1153 
1154 
1155 
1156 
1157 
1158 
1159 
1160 
1161 error ApprovalCallerNotOwnerNorApproved();
1162 error ApprovalQueryForNonexistentToken();
1163 error ApproveToCaller();
1164 error ApprovalToCurrentOwner();
1165 error BalanceQueryForZeroAddress();
1166 error MintedQueryForZeroAddress();
1167 error BurnedQueryForZeroAddress();
1168 error AuxQueryForZeroAddress();
1169 error MintToZeroAddress();
1170 error MintZeroQuantity();
1171 error OwnerIndexOutOfBounds();
1172 error OwnerQueryForNonexistentToken();
1173 error TokenIndexOutOfBounds();
1174 error TransferCallerNotOwnerNorApproved();
1175 error TransferFromIncorrectOwner();
1176 error TransferToNonERC721ReceiverImplementer();
1177 error TransferToZeroAddress();
1178 error URIQueryForNonexistentToken();
1179 
1180 /**
1181  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1182  * the Metadata extension. Built to optimize for lower gas during batch mints.
1183  *
1184  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
1185  *
1186  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1187  *
1188  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
1189  */
1190 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
1191     using Address for address;
1192     using Strings for uint256;
1193 
1194     // Compiler will pack this into a single 256bit word.
1195     struct TokenOwnership {
1196         // The address of the owner.
1197         address addr;
1198         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
1199         uint64 startTimestamp;
1200         // Whether the token has been burned.
1201         bool burned;
1202     }
1203 
1204     // Compiler will pack this into a single 256bit word.
1205     struct AddressData {
1206         // Realistically, 2**64-1 is more than enough.
1207         uint64 balance;
1208         // Keeps track of mint count with minimal overhead for tokenomics.
1209         uint64 numberMinted;
1210         // Keeps track of burn count with minimal overhead for tokenomics.
1211         uint64 numberBurned;
1212         // For miscellaneous variable(s) pertaining to the address
1213         // (e.g. number of whitelist mint slots used).
1214         // If there are multiple variables, please pack them into a uint64.
1215         uint64 aux;
1216     }
1217 
1218     // The tokenId of the next token to be minted.
1219     uint256 internal _currentIndex;
1220 
1221     // The number of tokens burned.
1222     uint256 internal _burnCounter;
1223 
1224     // Token name
1225     string private _name;
1226 
1227     // Token symbol
1228     string private _symbol;
1229 
1230     // Mapping from token ID to ownership details
1231     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1232     mapping(uint256 => TokenOwnership) internal _ownerships;
1233 
1234     // Mapping owner address to address data
1235     mapping(address => AddressData) private _addressData;
1236 
1237     // Mapping from token ID to approved address
1238     mapping(uint256 => address) private _tokenApprovals;
1239 
1240     // Mapping from owner to operator approvals
1241     mapping(address => mapping(address => bool)) private _operatorApprovals;
1242 
1243     constructor(string memory name_, string memory symbol_) {
1244         _name = name_;
1245         _symbol = symbol_;
1246         _currentIndex = _startTokenId();
1247     }
1248 
1249     /**
1250      * To change the starting tokenId, please override this function.
1251      */
1252     function _startTokenId() internal view virtual returns (uint256) {
1253         return 0;
1254     }
1255 
1256     /**
1257      * @dev See {IERC721Enumerable-totalSupply}.
1258      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
1259      */
1260     function totalSupply() public view returns (uint256) {
1261         // Counter underflow is impossible as _burnCounter cannot be incremented
1262         // more than _currentIndex - _startTokenId() times
1263         unchecked {
1264             return _currentIndex - _burnCounter - _startTokenId();
1265         }
1266     }
1267 
1268     /**
1269      * Returns the total amount of tokens minted in the contract.
1270      */
1271     function _totalMinted() internal view returns (uint256) {
1272         // Counter underflow is impossible as _currentIndex does not decrement,
1273         // and it is initialized to _startTokenId()
1274         unchecked {
1275             return _currentIndex - _startTokenId();
1276         }
1277     }
1278 
1279     /**
1280      * @dev See {IERC165-supportsInterface}.
1281      */
1282     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1283         return
1284             interfaceId == type(IERC721).interfaceId ||
1285             interfaceId == type(IERC721Metadata).interfaceId ||
1286             super.supportsInterface(interfaceId);
1287     }
1288 
1289     /**
1290      * @dev See {IERC721-balanceOf}.
1291      */
1292     function balanceOf(address owner) public view override returns (uint256) {
1293         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1294         return uint256(_addressData[owner].balance);
1295     }
1296 
1297     /**
1298      * Returns the number of tokens minted by `owner`.
1299      */
1300     function _numberMinted(address owner) internal view returns (uint256) {
1301         if (owner == address(0)) revert MintedQueryForZeroAddress();
1302         return uint256(_addressData[owner].numberMinted);
1303     }
1304 
1305     /**
1306      * Returns the number of tokens burned by or on behalf of `owner`.
1307      */
1308     function _numberBurned(address owner) internal view returns (uint256) {
1309         if (owner == address(0)) revert BurnedQueryForZeroAddress();
1310         return uint256(_addressData[owner].numberBurned);
1311     }
1312 
1313     /**
1314      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1315      */
1316     function _getAux(address owner) internal view returns (uint64) {
1317         if (owner == address(0)) revert AuxQueryForZeroAddress();
1318         return _addressData[owner].aux;
1319     }
1320 
1321     /**
1322      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1323      * If there are multiple variables, please pack them into a uint64.
1324      */
1325     function _setAux(address owner, uint64 aux) internal {
1326         if (owner == address(0)) revert AuxQueryForZeroAddress();
1327         _addressData[owner].aux = aux;
1328     }
1329 
1330     /**
1331      * Gas spent here starts off proportional to the maximum mint batch size.
1332      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1333      */
1334     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1335         uint256 curr = tokenId;
1336 
1337         unchecked {
1338             if (_startTokenId() <= curr && curr < _currentIndex) {
1339                 TokenOwnership memory ownership = _ownerships[curr];
1340                 if (!ownership.burned) {
1341                     if (ownership.addr != address(0)) {
1342                         return ownership;
1343                     }
1344                     // Invariant:
1345                     // There will always be an ownership that has an address and is not burned
1346                     // before an ownership that does not have an address and is not burned.
1347                     // Hence, curr will not underflow.
1348                     while (true) {
1349                         curr--;
1350                         ownership = _ownerships[curr];
1351                         if (ownership.addr != address(0)) {
1352                             return ownership;
1353                         }
1354                     }
1355                 }
1356             }
1357         }
1358         revert OwnerQueryForNonexistentToken();
1359     }
1360 
1361     /**
1362      * @dev See {IERC721-ownerOf}.
1363      */
1364     function ownerOf(uint256 tokenId) public view override returns (address) {
1365         return ownershipOf(tokenId).addr;
1366     }
1367 
1368     /**
1369      * @dev See {IERC721Metadata-name}.
1370      */
1371     function name() public view virtual override returns (string memory) {
1372         return _name;
1373     }
1374 
1375     /**
1376      * @dev See {IERC721Metadata-symbol}.
1377      */
1378     function symbol() public view virtual override returns (string memory) {
1379         return _symbol;
1380     }
1381 
1382     /**
1383      * @dev See {IERC721Metadata-tokenURI}.
1384      */
1385     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1386         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1387 
1388         string memory baseURI = _baseURI();
1389         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1390     }
1391 
1392     /**
1393      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1394      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1395      * by default, can be overriden in child contracts.
1396      */
1397     function _baseURI() internal view virtual returns (string memory) {
1398         return '';
1399     }
1400 
1401     /**
1402      * @dev See {IERC721-approve}.
1403      */
1404     function approve(address to, uint256 tokenId) public override {
1405         address owner = ERC721A.ownerOf(tokenId);
1406         if (to == owner) revert ApprovalToCurrentOwner();
1407 
1408         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1409             revert ApprovalCallerNotOwnerNorApproved();
1410         }
1411 
1412         _approve(to, tokenId, owner);
1413     }
1414 
1415     /**
1416      * @dev See {IERC721-getApproved}.
1417      */
1418     function getApproved(uint256 tokenId) public view override returns (address) {
1419         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1420 
1421         return _tokenApprovals[tokenId];
1422     }
1423 
1424     /**
1425      * @dev See {IERC721-setApprovalForAll}.
1426      */
1427     function setApprovalForAll(address operator, bool approved) public override {
1428         if (operator == _msgSender()) revert ApproveToCaller();
1429 
1430         _operatorApprovals[_msgSender()][operator] = approved;
1431         emit ApprovalForAll(_msgSender(), operator, approved);
1432     }
1433 
1434     /**
1435      * @dev See {IERC721-isApprovedForAll}.
1436      */
1437     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1438         return _operatorApprovals[owner][operator];
1439     }
1440 
1441     /**
1442      * @dev See {IERC721-transferFrom}.
1443      */
1444     function transferFrom(
1445         address from,
1446         address to,
1447         uint256 tokenId
1448     ) public virtual override {
1449         _transfer(from, to, tokenId);
1450     }
1451 
1452     /**
1453      * @dev See {IERC721-safeTransferFrom}.
1454      */
1455     function safeTransferFrom(
1456         address from,
1457         address to,
1458         uint256 tokenId
1459     ) public virtual override {
1460         safeTransferFrom(from, to, tokenId, '');
1461     }
1462 
1463     /**
1464      * @dev See {IERC721-safeTransferFrom}.
1465      */
1466     function safeTransferFrom(
1467         address from,
1468         address to,
1469         uint256 tokenId,
1470         bytes memory _data
1471     ) public virtual override {
1472         _transfer(from, to, tokenId);
1473         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1474             revert TransferToNonERC721ReceiverImplementer();
1475         }
1476     }
1477 
1478     /**
1479      * @dev Returns whether `tokenId` exists.
1480      *
1481      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1482      *
1483      * Tokens start existing when they are minted (`_mint`),
1484      */
1485     function _exists(uint256 tokenId) internal view returns (bool) {
1486         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1487             !_ownerships[tokenId].burned;
1488     }
1489 
1490     function _safeMint(address to, uint256 quantity) internal {
1491         _safeMint(to, quantity, '');
1492     }
1493 
1494     /**
1495      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1496      *
1497      * Requirements:
1498      *
1499      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1500      * - `quantity` must be greater than 0.
1501      *
1502      * Emits a {Transfer} event.
1503      */
1504     function _safeMint(
1505         address to,
1506         uint256 quantity,
1507         bytes memory _data
1508     ) internal {
1509         _mint(to, quantity, _data, true);
1510     }
1511 
1512     /**
1513      * @dev Mints `quantity` tokens and transfers them to `to`.
1514      *
1515      * Requirements:
1516      *
1517      * - `to` cannot be the zero address.
1518      * - `quantity` must be greater than 0.
1519      *
1520      * Emits a {Transfer} event.
1521      */
1522     function _mint(
1523         address to,
1524         uint256 quantity,
1525         bytes memory _data,
1526         bool safe
1527     ) internal {
1528         uint256 startTokenId = _currentIndex;
1529         if (to == address(0)) revert MintToZeroAddress();
1530         if (quantity == 0) revert MintZeroQuantity();
1531 
1532         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1533 
1534         // Overflows are incredibly unrealistic.
1535         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1536         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1537         unchecked {
1538             _addressData[to].balance += uint64(quantity);
1539             _addressData[to].numberMinted += uint64(quantity);
1540 
1541             _ownerships[startTokenId].addr = to;
1542             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1543 
1544             uint256 updatedIndex = startTokenId;
1545             uint256 end = updatedIndex + quantity;
1546 
1547             if (safe && to.isContract()) {
1548                 do {
1549                     emit Transfer(address(0), to, updatedIndex);
1550                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1551                         revert TransferToNonERC721ReceiverImplementer();
1552                     }
1553                 } while (updatedIndex != end);
1554                 // Reentrancy protection
1555                 if (_currentIndex != startTokenId) revert();
1556             } else {
1557                 do {
1558                     emit Transfer(address(0), to, updatedIndex++);
1559                 } while (updatedIndex != end);
1560             }
1561             _currentIndex = updatedIndex;
1562         }
1563         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1564     }
1565 
1566     /**
1567      * @dev Transfers `tokenId` from `from` to `to`.
1568      *
1569      * Requirements:
1570      *
1571      * - `to` cannot be the zero address.
1572      * - `tokenId` token must be owned by `from`.
1573      *
1574      * Emits a {Transfer} event.
1575      */
1576     function _transfer(
1577         address from,
1578         address to,
1579         uint256 tokenId
1580     ) private {
1581         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1582 
1583         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1584             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1585             getApproved(tokenId) == _msgSender());
1586 
1587         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1588         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1589         if (to == address(0)) revert TransferToZeroAddress();
1590 
1591         _beforeTokenTransfers(from, to, tokenId, 1);
1592 
1593         // Clear approvals from the previous owner
1594         _approve(address(0), tokenId, prevOwnership.addr);
1595 
1596         // Underflow of the sender's balance is impossible because we check for
1597         // ownership above and the recipient's balance can't realistically overflow.
1598         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1599         unchecked {
1600             _addressData[from].balance -= 1;
1601             _addressData[to].balance += 1;
1602 
1603             _ownerships[tokenId].addr = to;
1604             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1605 
1606             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1607             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1608             uint256 nextTokenId = tokenId + 1;
1609             if (_ownerships[nextTokenId].addr == address(0)) {
1610                 // This will suffice for checking _exists(nextTokenId),
1611                 // as a burned slot cannot contain the zero address.
1612                 if (nextTokenId < _currentIndex) {
1613                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1614                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1615                 }
1616             }
1617         }
1618 
1619         emit Transfer(from, to, tokenId);
1620         _afterTokenTransfers(from, to, tokenId, 1);
1621     }
1622 
1623     /**
1624      * @dev Destroys `tokenId`.
1625      * The approval is cleared when the token is burned.
1626      *
1627      * Requirements:
1628      *
1629      * - `tokenId` must exist.
1630      *
1631      * Emits a {Transfer} event.
1632      */
1633     function _burn(uint256 tokenId) internal virtual {
1634         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1635 
1636         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1637 
1638         // Clear approvals from the previous owner
1639         _approve(address(0), tokenId, prevOwnership.addr);
1640 
1641         // Underflow of the sender's balance is impossible because we check for
1642         // ownership above and the recipient's balance can't realistically overflow.
1643         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1644         unchecked {
1645             _addressData[prevOwnership.addr].balance -= 1;
1646             _addressData[prevOwnership.addr].numberBurned += 1;
1647 
1648             // Keep track of who burned the token, and the timestamp of burning.
1649             _ownerships[tokenId].addr = prevOwnership.addr;
1650             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1651             _ownerships[tokenId].burned = true;
1652 
1653             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1654             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1655             uint256 nextTokenId = tokenId + 1;
1656             if (_ownerships[nextTokenId].addr == address(0)) {
1657                 // This will suffice for checking _exists(nextTokenId),
1658                 // as a burned slot cannot contain the zero address.
1659                 if (nextTokenId < _currentIndex) {
1660                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1661                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1662                 }
1663             }
1664         }
1665 
1666         emit Transfer(prevOwnership.addr, address(0), tokenId);
1667         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1668 
1669         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1670         unchecked {
1671             _burnCounter++;
1672         }
1673     }
1674 
1675     /**
1676      * @dev Approve `to` to operate on `tokenId`
1677      *
1678      * Emits a {Approval} event.
1679      */
1680     function _approve(
1681         address to,
1682         uint256 tokenId,
1683         address owner
1684     ) private {
1685         _tokenApprovals[tokenId] = to;
1686         emit Approval(owner, to, tokenId);
1687     }
1688 
1689     /**
1690      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1691      *
1692      * @param from address representing the previous owner of the given token ID
1693      * @param to target address that will receive the tokens
1694      * @param tokenId uint256 ID of the token to be transferred
1695      * @param _data bytes optional data to send along with the call
1696      * @return bool whether the call correctly returned the expected magic value
1697      */
1698     function _checkContractOnERC721Received(
1699         address from,
1700         address to,
1701         uint256 tokenId,
1702         bytes memory _data
1703     ) private returns (bool) {
1704         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1705             return retval == IERC721Receiver(to).onERC721Received.selector;
1706         } catch (bytes memory reason) {
1707             if (reason.length == 0) {
1708                 revert TransferToNonERC721ReceiverImplementer();
1709             } else {
1710                 assembly {
1711                     revert(add(32, reason), mload(reason))
1712                 }
1713             }
1714         }
1715     }
1716 
1717     /**
1718      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1719      * And also called before burning one token.
1720      *
1721      * startTokenId - the first token id to be transferred
1722      * quantity - the amount to be transferred
1723      *
1724      * Calling conditions:
1725      *
1726      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1727      * transferred to `to`.
1728      * - When `from` is zero, `tokenId` will be minted for `to`.
1729      * - When `to` is zero, `tokenId` will be burned by `from`.
1730      * - `from` and `to` are never both zero.
1731      */
1732     function _beforeTokenTransfers(
1733         address from,
1734         address to,
1735         uint256 startTokenId,
1736         uint256 quantity
1737     ) internal virtual {}
1738 
1739     /**
1740      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1741      * minting.
1742      * And also called after one token has been burned.
1743      *
1744      * startTokenId - the first token id to be transferred
1745      * quantity - the amount to be transferred
1746      *
1747      * Calling conditions:
1748      *
1749      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1750      * transferred to `to`.
1751      * - When `from` is zero, `tokenId` has been minted for `to`.
1752      * - When `to` is zero, `tokenId` has been burned by `from`.
1753      * - `from` and `to` are never both zero.
1754      */
1755     function _afterTokenTransfers(
1756         address from,
1757         address to,
1758         uint256 startTokenId,
1759         uint256 quantity
1760     ) internal virtual {}
1761 }
1762 
1763 
1764 // File contracts/libs/ECRecoverLib.sol
1765 
1766 
1767 pragma solidity <0.9.0;
1768 
1769 library ECRecoverLib {
1770     string private constant REQUIRED_SIG_HEADER = "\x19Ethereum Signed Message:\n32";
1771 
1772     struct ECDSAVariables {
1773         uint8 v;
1774         bytes32 r;
1775         bytes32 s;
1776     }
1777 
1778     function verifySig(
1779         ECDSAVariables memory self,
1780         address signer,
1781         bytes32 signerHash
1782     ) internal pure {
1783         require(
1784             signer ==
1785                 ecrecover(
1786                     keccak256(abi.encodePacked(REQUIRED_SIG_HEADER, signerHash)),
1787                     self.v,
1788                     self.r,
1789                     self.s
1790                 ),
1791             "Invalid Signature"
1792         );
1793     }
1794 }
1795 
1796 
1797 // File contracts/mf3rs.sol
1798 
1799 
1800 
1801 pragma solidity ^0.8.0;
1802 contract MF3RS is ERC721A, PaymentSplitter, Ownable {
1803 
1804     using ECRecoverLib for ECRecoverLib.ECDSAVariables;
1805 
1806     uint256 private constant _MAX_TOKENS = 10000;
1807     // 10,028 - 21 1/1s
1808 
1809     uint256 private constant _MAX_TOKENS_FOR_MFERS = 3004;
1810     uint256 private constant _MAX_TOKENS_PER_MFER = 10;
1811 
1812     uint256 private constant _MAX_TOKENS_PER_PUBLIC_MFER = 1;
1813 
1814     uint256 private constant _CROAKZ = 0;
1815     uint256 private constant _MFERS = 1;
1816 
1817     uint256 private constant _DEV_MINT = 0;
1818     uint256 private constant _MFERS_CAPPED_MINT = 1;
1819     uint256 private constant _MFERS_UNCAPPED_MINT = 2;
1820     uint256 private constant _PUBLIC_MINT = 3;
1821     uint256 private constant _CLOSED_MINT = 4;
1822 
1823     uint256 private mintPhase = 0;
1824     uint256 private numberOfMferMints = 0;
1825 
1826     bool private devMintLocked = false;
1827 
1828     mapping (address => uint256) private croakzMinted;
1829     mapping (address => uint256) private mfersMinted;
1830     mapping (address => uint256) private publicMinted;
1831 
1832     address signingAuth;
1833 
1834     constructor(
1835         string memory name_, string memory symbol_, 
1836         address[] memory payees, uint256[] memory shares_
1837     ) ERC721A(name_, symbol_) PaymentSplitter(payees, shares_) {}
1838 
1839     function setSigningAuth(address _signingAuth) external onlyOwner {
1840         signingAuth = _signingAuth;
1841     }
1842 
1843     function changeMintPhase(uint256 _mintPhase) public onlyOwner {
1844         require(_mintPhase > mintPhase, "No back-stepping!");
1845         require(_mintPhase <= _CLOSED_MINT, "Final phase is CLOSED");
1846         mintPhase = _mintPhase;
1847     }
1848 
1849     function getMintPhase() public view returns (uint256) {
1850         return mintPhase;
1851     }
1852 
1853     function numberMinted(address owner) public view returns (uint256) {
1854         return _numberMinted(owner);
1855     }
1856 
1857     function totalMinted() public view returns (uint256) {
1858         return _totalMinted();
1859     }
1860 
1861     // // metadata URI
1862     string private _baseTokenURI;
1863 
1864     function _baseURI() internal view virtual override returns (string memory) {
1865         return _baseTokenURI;
1866     }
1867 
1868     function setBaseURI(string calldata baseURI) external onlyOwner {
1869         _baseTokenURI = baseURI;
1870     }
1871 
1872     function exists(uint256 tokenId) public view returns (bool) {
1873         return _exists(tokenId);
1874     }
1875 
1876     modifier callerIsUser() {
1877         require(tx.origin == msg.sender, "No contracts!");
1878         _;
1879     }
1880 
1881     function publicMint(uint256 quantity) external callerIsUser {
1882         require(mintPhase == _PUBLIC_MINT, "Public mint not available");
1883         // overflow checks here
1884         require(_totalMinted() + quantity <= _MAX_TOKENS, "Cannot exceed max supply");
1885         
1886         unchecked { publicMinted[msg.sender] += quantity; }
1887         require(mfersMinted[msg.sender] <= _MAX_TOKENS_PER_PUBLIC_MFER, "Cannot exceed capped supply per public address");
1888 
1889         _safeMint(msg.sender, quantity);
1890     }
1891 
1892     function mint(uint256 quantity, uint256 project, uint256 held, ECRecoverLib.ECDSAVariables memory wlECDSA) external callerIsUser {
1893         require(mintPhase > _DEV_MINT, "Minting has not started");
1894         // overflow checks here
1895         require(_totalMinted() + quantity <= _MAX_TOKENS, "Cannot exceed max supply");
1896 
1897         // Prove to contract that sender was in snapshot
1898         bytes32 senderHash = keccak256(abi.encodePacked(msg.sender, project, held));
1899         wlECDSA.verifySig(signingAuth, senderHash);
1900 
1901         unchecked { 
1902             if(project == _CROAKZ) {
1903                 croakzMinted[msg.sender] += quantity;
1904                 require(croakzMinted[msg.sender] <= held, "1 CROAK = 1 MF3R!");
1905                 _safeMint(msg.sender, quantity);
1906             } else if(project == _MFERS) {
1907                 mfersMinted[msg.sender] += quantity;
1908                 require(mfersMinted[msg.sender] <= held, "1 MFER = 1 MF3R!");
1909                 numberOfMferMints += quantity;
1910                 if(mintPhase == _MFERS_CAPPED_MINT) {
1911                     require(numberOfMferMints <= _MAX_TOKENS_FOR_MFERS, "Cannot exceed capped supply for mfers");
1912                     require(mfersMinted[msg.sender] <= _MAX_TOKENS_PER_MFER, "Cannot exceed capped supply per mfer");
1913                 }
1914                 _safeMint(msg.sender, quantity);
1915             }
1916         }
1917     }
1918 
1919     // dev mint special 1/1s
1920     function mintSpecial(address [] memory recipients) external onlyOwner {        
1921         require(!devMintLocked, "Dev Mint Permanently Locked");
1922         unchecked { 
1923             for (uint256 i = 0; i < recipients.length; i++) {
1924                 _safeMint(recipients[i], 1);
1925             }
1926         }
1927     }
1928 
1929     function lockDevMint() external onlyOwner {
1930         devMintLocked = true;
1931     }
1932 }