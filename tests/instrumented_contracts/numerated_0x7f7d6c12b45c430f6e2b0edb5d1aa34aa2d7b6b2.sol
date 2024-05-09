1 // File: @openzeppelin/contracts/utils/Address.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Collection of functions related to the address type
10  */
11 library Address {
12     /**
13      * @dev Returns true if `account` is a contract.
14      *
15      * [IMPORTANT]
16      * ====
17      * It is unsafe to assume that an address for which this function returns
18      * false is an externally-owned account (EOA) and not a contract.
19      *
20      * Among others, `isContract` will return false for the following
21      * types of addresses:
22      *
23      *  - an externally-owned account
24      *  - a contract in construction
25      *  - an address where a contract will be created
26      *  - an address where a contract lived, but was destroyed
27      * ====
28      */
29     function isContract(address account) internal view returns (bool) {
30         // This method relies on extcodesize, which returns 0 for contracts in
31         // construction, since the code is only stored at the end of the
32         // constructor execution.
33 
34         uint256 size;
35         assembly {
36             size := extcodesize(account)
37         }
38         return size > 0;
39     }
40 
41     /**
42      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
43      * `recipient`, forwarding all available gas and reverting on errors.
44      *
45      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
46      * of certain opcodes, possibly making contracts go over the 2300 gas limit
47      * imposed by `transfer`, making them unable to receive funds via
48      * `transfer`. {sendValue} removes this limitation.
49      *
50      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
51      *
52      * IMPORTANT: because control is transferred to `recipient`, care must be
53      * taken to not create reentrancy vulnerabilities. Consider using
54      * {ReentrancyGuard} or the
55      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
56      */
57     function sendValue(address payable recipient, uint256 amount) internal {
58         require(address(this).balance >= amount, "Address: insufficient balance");
59 
60         (bool success, ) = recipient.call{value: amount}("");
61         require(success, "Address: unable to send value, recipient may have reverted");
62     }
63 
64     /**
65      * @dev Performs a Solidity function call using a low level `call`. A
66      * plain `call` is an unsafe replacement for a function call: use this
67      * function instead.
68      *
69      * If `target` reverts with a revert reason, it is bubbled up by this
70      * function (like regular Solidity function calls).
71      *
72      * Returns the raw returned data. To convert to the expected return value,
73      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
74      *
75      * Requirements:
76      *
77      * - `target` must be a contract.
78      * - calling `target` with `data` must not revert.
79      *
80      * _Available since v3.1._
81      */
82     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
83         return functionCall(target, data, "Address: low-level call failed");
84     }
85 
86     /**
87      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
88      * `errorMessage` as a fallback revert reason when `target` reverts.
89      *
90      * _Available since v3.1._
91      */
92     function functionCall(
93         address target,
94         bytes memory data,
95         string memory errorMessage
96     ) internal returns (bytes memory) {
97         return functionCallWithValue(target, data, 0, errorMessage);
98     }
99 
100     /**
101      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
102      * but also transferring `value` wei to `target`.
103      *
104      * Requirements:
105      *
106      * - the calling contract must have an ETH balance of at least `value`.
107      * - the called Solidity function must be `payable`.
108      *
109      * _Available since v3.1._
110      */
111     function functionCallWithValue(
112         address target,
113         bytes memory data,
114         uint256 value
115     ) internal returns (bytes memory) {
116         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
117     }
118 
119     /**
120      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
121      * with `errorMessage` as a fallback revert reason when `target` reverts.
122      *
123      * _Available since v3.1._
124      */
125     function functionCallWithValue(
126         address target,
127         bytes memory data,
128         uint256 value,
129         string memory errorMessage
130     ) internal returns (bytes memory) {
131         require(address(this).balance >= value, "Address: insufficient balance for call");
132         require(isContract(target), "Address: call to non-contract");
133 
134         (bool success, bytes memory returndata) = target.call{value: value}(data);
135         return verifyCallResult(success, returndata, errorMessage);
136     }
137 
138     /**
139      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
140      * but performing a static call.
141      *
142      * _Available since v3.3._
143      */
144     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
145         return functionStaticCall(target, data, "Address: low-level static call failed");
146     }
147 
148     /**
149      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
150      * but performing a static call.
151      *
152      * _Available since v3.3._
153      */
154     function functionStaticCall(
155         address target,
156         bytes memory data,
157         string memory errorMessage
158     ) internal view returns (bytes memory) {
159         require(isContract(target), "Address: static call to non-contract");
160 
161         (bool success, bytes memory returndata) = target.staticcall(data);
162         return verifyCallResult(success, returndata, errorMessage);
163     }
164 
165     /**
166      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
167      * but performing a delegate call.
168      *
169      * _Available since v3.4._
170      */
171     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
172         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
173     }
174 
175     /**
176      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
177      * but performing a delegate call.
178      *
179      * _Available since v3.4._
180      */
181     function functionDelegateCall(
182         address target,
183         bytes memory data,
184         string memory errorMessage
185     ) internal returns (bytes memory) {
186         require(isContract(target), "Address: delegate call to non-contract");
187 
188         (bool success, bytes memory returndata) = target.delegatecall(data);
189         return verifyCallResult(success, returndata, errorMessage);
190     }
191 
192     /**
193      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
194      * revert reason using the provided one.
195      *
196      * _Available since v4.3._
197      */
198     function verifyCallResult(
199         bool success,
200         bytes memory returndata,
201         string memory errorMessage
202     ) internal pure returns (bytes memory) {
203         if (success) {
204             return returndata;
205         } else {
206             // Look for revert reason and bubble it up if present
207             if (returndata.length > 0) {
208                 // The easiest way to bubble the revert reason is using memory via assembly
209 
210                 assembly {
211                     let returndata_size := mload(returndata)
212                     revert(add(32, returndata), returndata_size)
213                 }
214             } else {
215                 revert(errorMessage);
216             }
217         }
218     }
219 }
220 
221 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
222 
223 
224 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
225 
226 pragma solidity ^0.8.0;
227 
228 /**
229  * @dev Interface of the ERC20 standard as defined in the EIP.
230  */
231 interface IERC20 {
232     /**
233      * @dev Returns the amount of tokens in existence.
234      */
235     function totalSupply() external view returns (uint256);
236 
237     /**
238      * @dev Returns the amount of tokens owned by `account`.
239      */
240     function balanceOf(address account) external view returns (uint256);
241 
242     /**
243      * @dev Moves `amount` tokens from the caller's account to `recipient`.
244      *
245      * Returns a boolean value indicating whether the operation succeeded.
246      *
247      * Emits a {Transfer} event.
248      */
249     function transfer(address recipient, uint256 amount) external returns (bool);
250 
251     /**
252      * @dev Returns the remaining number of tokens that `spender` will be
253      * allowed to spend on behalf of `owner` through {transferFrom}. This is
254      * zero by default.
255      *
256      * This value changes when {approve} or {transferFrom} are called.
257      */
258     function allowance(address owner, address spender) external view returns (uint256);
259 
260     /**
261      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
262      *
263      * Returns a boolean value indicating whether the operation succeeded.
264      *
265      * IMPORTANT: Beware that changing an allowance with this method brings the risk
266      * that someone may use both the old and the new allowance by unfortunate
267      * transaction ordering. One possible solution to mitigate this race
268      * condition is to first reduce the spender's allowance to 0 and set the
269      * desired value afterwards:
270      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
271      *
272      * Emits an {Approval} event.
273      */
274     function approve(address spender, uint256 amount) external returns (bool);
275 
276     /**
277      * @dev Moves `amount` tokens from `sender` to `recipient` using the
278      * allowance mechanism. `amount` is then deducted from the caller's
279      * allowance.
280      *
281      * Returns a boolean value indicating whether the operation succeeded.
282      *
283      * Emits a {Transfer} event.
284      */
285     function transferFrom(
286         address sender,
287         address recipient,
288         uint256 amount
289     ) external returns (bool);
290 
291     /**
292      * @dev Emitted when `value` tokens are moved from one account (`from`) to
293      * another (`to`).
294      *
295      * Note that `value` may be zero.
296      */
297     event Transfer(address indexed from, address indexed to, uint256 value);
298 
299     /**
300      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
301      * a call to {approve}. `value` is the new allowance.
302      */
303     event Approval(address indexed owner, address indexed spender, uint256 value);
304 }
305 
306 // File: github/RevelationOfTuring/zks_treasury/contracts/interface/ZksCore.sol
307 
308 
309 pragma solidity 0.8.7;
310 
311 
312 interface ZksCore {
313     function depositERC20(IERC20 _token, uint104 _amount, address _franklinAddr) external;
314 
315     function depositETH(address _franklinAddr) external payable;
316 }
317 
318 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
319 
320 
321 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
322 
323 pragma solidity ^0.8.0;
324 
325 
326 
327 /**
328  * @title SafeERC20
329  * @dev Wrappers around ERC20 operations that throw on failure (when the token
330  * contract returns false). Tokens that return no value (and instead revert or
331  * throw on failure) are also supported, non-reverting calls are assumed to be
332  * successful.
333  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
334  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
335  */
336 library SafeERC20 {
337     using Address for address;
338 
339     function safeTransfer(
340         IERC20 token,
341         address to,
342         uint256 value
343     ) internal {
344         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
345     }
346 
347     function safeTransferFrom(
348         IERC20 token,
349         address from,
350         address to,
351         uint256 value
352     ) internal {
353         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
354     }
355 
356     /**
357      * @dev Deprecated. This function has issues similar to the ones found in
358      * {IERC20-approve}, and its usage is discouraged.
359      *
360      * Whenever possible, use {safeIncreaseAllowance} and
361      * {safeDecreaseAllowance} instead.
362      */
363     function safeApprove(
364         IERC20 token,
365         address spender,
366         uint256 value
367     ) internal {
368         // safeApprove should only be called when setting an initial allowance,
369         // or when resetting it to zero. To increase and decrease it, use
370         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
371         require(
372             (value == 0) || (token.allowance(address(this), spender) == 0),
373             "SafeERC20: approve from non-zero to non-zero allowance"
374         );
375         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
376     }
377 
378     function safeIncreaseAllowance(
379         IERC20 token,
380         address spender,
381         uint256 value
382     ) internal {
383         uint256 newAllowance = token.allowance(address(this), spender) + value;
384         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
385     }
386 
387     function safeDecreaseAllowance(
388         IERC20 token,
389         address spender,
390         uint256 value
391     ) internal {
392         unchecked {
393             uint256 oldAllowance = token.allowance(address(this), spender);
394             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
395             uint256 newAllowance = oldAllowance - value;
396             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
397         }
398     }
399 
400     /**
401      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
402      * on the return value: the return value is optional (but if data is returned, it must not be false).
403      * @param token The token targeted by the call.
404      * @param data The call data (encoded using abi.encode or one of its variants).
405      */
406     function _callOptionalReturn(IERC20 token, bytes memory data) private {
407         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
408         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
409         // the target address contains contract code and also asserts for success in the low-level call.
410 
411         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
412         if (returndata.length > 0) {
413             // Return data is optional
414             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
415         }
416     }
417 }
418 
419 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
420 
421 
422 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
423 
424 pragma solidity ^0.8.0;
425 
426 /**
427  * @dev Contract module that helps prevent reentrant calls to a function.
428  *
429  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
430  * available, which can be applied to functions to make sure there are no nested
431  * (reentrant) calls to them.
432  *
433  * Note that because there is a single `nonReentrant` guard, functions marked as
434  * `nonReentrant` may not call one another. This can be worked around by making
435  * those functions `private`, and then adding `external` `nonReentrant` entry
436  * points to them.
437  *
438  * TIP: If you would like to learn more about reentrancy and alternative ways
439  * to protect against it, check out our blog post
440  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
441  */
442 abstract contract ReentrancyGuard {
443     // Booleans are more expensive than uint256 or any type that takes up a full
444     // word because each write operation emits an extra SLOAD to first read the
445     // slot's contents, replace the bits taken up by the boolean, and then write
446     // back. This is the compiler's defense against contract upgrades and
447     // pointer aliasing, and it cannot be disabled.
448 
449     // The values being non-zero value makes deployment a bit more expensive,
450     // but in exchange the refund on every call to nonReentrant will be lower in
451     // amount. Since refunds are capped to a percentage of the total
452     // transaction's gas, it is best to keep them low in cases like this one, to
453     // increase the likelihood of the full refund coming into effect.
454     uint256 private constant _NOT_ENTERED = 1;
455     uint256 private constant _ENTERED = 2;
456 
457     uint256 private _status;
458 
459     constructor() {
460         _status = _NOT_ENTERED;
461     }
462 
463     /**
464      * @dev Prevents a contract from calling itself, directly or indirectly.
465      * Calling a `nonReentrant` function from another `nonReentrant`
466      * function is not supported. It is possible to prevent this from happening
467      * by making the `nonReentrant` function external, and making it call a
468      * `private` function that does the actual work.
469      */
470     modifier nonReentrant() {
471         // On the first call to nonReentrant, _notEntered will be true
472         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
473 
474         // Any calls to nonReentrant after this point will fail
475         _status = _ENTERED;
476 
477         _;
478 
479         // By storing the original value once again, a refund is triggered (see
480         // https://eips.ethereum.org/EIPS/eip-2200)
481         _status = _NOT_ENTERED;
482     }
483 }
484 
485 // File: @openzeppelin/contracts/utils/Context.sol
486 
487 
488 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
489 
490 pragma solidity ^0.8.0;
491 
492 /**
493  * @dev Provides information about the current execution context, including the
494  * sender of the transaction and its data. While these are generally available
495  * via msg.sender and msg.data, they should not be accessed in such a direct
496  * manner, since when dealing with meta-transactions the account sending and
497  * paying for execution may not be the actual sender (as far as an application
498  * is concerned).
499  *
500  * This contract is only required for intermediate, library-like contracts.
501  */
502 abstract contract Context {
503     function _msgSender() internal view virtual returns (address) {
504         return msg.sender;
505     }
506 
507     function _msgData() internal view virtual returns (bytes calldata) {
508         return msg.data;
509     }
510 }
511 
512 // File: @openzeppelin/contracts/access/Ownable.sol
513 
514 
515 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
516 
517 pragma solidity ^0.8.0;
518 
519 
520 /**
521  * @dev Contract module which provides a basic access control mechanism, where
522  * there is an account (an owner) that can be granted exclusive access to
523  * specific functions.
524  *
525  * By default, the owner account will be the one that deploys the contract. This
526  * can later be changed with {transferOwnership}.
527  *
528  * This module is used through inheritance. It will make available the modifier
529  * `onlyOwner`, which can be applied to your functions to restrict their use to
530  * the owner.
531  */
532 abstract contract Ownable is Context {
533     address private _owner;
534 
535     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
536 
537     /**
538      * @dev Initializes the contract setting the deployer as the initial owner.
539      */
540     constructor() {
541         _transferOwnership(_msgSender());
542     }
543 
544     /**
545      * @dev Returns the address of the current owner.
546      */
547     function owner() public view virtual returns (address) {
548         return _owner;
549     }
550 
551     /**
552      * @dev Throws if called by any account other than the owner.
553      */
554     modifier onlyOwner() {
555         require(owner() == _msgSender(), "Ownable: caller is not the owner");
556         _;
557     }
558 
559     /**
560      * @dev Leaves the contract without owner. It will not be possible to call
561      * `onlyOwner` functions anymore. Can only be called by the current owner.
562      *
563      * NOTE: Renouncing ownership will leave the contract without an owner,
564      * thereby removing any functionality that is only available to the owner.
565      */
566     function renounceOwnership() public virtual onlyOwner {
567         _transferOwnership(address(0));
568     }
569 
570     /**
571      * @dev Transfers ownership of the contract to a new account (`newOwner`).
572      * Can only be called by the current owner.
573      */
574     function transferOwnership(address newOwner) public virtual onlyOwner {
575         require(newOwner != address(0), "Ownable: new owner is the zero address");
576         _transferOwnership(newOwner);
577     }
578 
579     /**
580      * @dev Transfers ownership of the contract to a new account (`newOwner`).
581      * Internal function without access restriction.
582      */
583     function _transferOwnership(address newOwner) internal virtual {
584         address oldOwner = _owner;
585         _owner = newOwner;
586         emit OwnershipTransferred(oldOwner, newOwner);
587     }
588 }
589 
590 // File: github/RevelationOfTuring/zks_treasury/contracts/ZksTreasury.sol
591 
592 
593 pragma solidity 0.8.7;
594 
595 
596 
597 
598 
599 
600 contract ZksTreasury is Ownable, ReentrancyGuard {
601     using SafeERC20 for IERC20;
602     event DepositETH(address indexed depositer, uint amount);
603 
604     ZksCore public zksCoreAddress;
605     address public receiverLayer2;
606     address public depositWorker;
607 
608     modifier onlyDepositWorker() {
609         require(depositWorker == msg.sender, "not deposit worker");
610         _;
611     }
612 
613     constructor(address receiverL2, address depositWorkerAddr, address zksCoreAddr){
614         receiverLayer2 = receiverL2;
615         depositWorker = depositWorkerAddr;
616         zksCoreAddress = ZksCore(zksCoreAddr);
617     }
618 
619     receive() external payable {
620         emit DepositETH(msg.sender, msg.value);
621     }
622 
623     // deposit eth locked in this contract to layer2
624     function depositEthToZksCore(uint amount) external onlyDepositWorker {
625         zksCoreAddress.depositETH{value : amount}(receiverLayer2);
626     }
627 
628     // deposit erc20 locked in this contract to layer2
629     function depositErc20ToZksCore(
630         address[] calldata tokenAddresses,
631         uint104[] calldata amounts
632     )
633     external
634     nonReentrant
635     onlyDepositWorker
636     {
637         require(tokenAddresses.length == amounts.length, "unmatched length");
638         for (uint i = 0; i < tokenAddresses.length; ++i) {
639             zksCoreAddress.depositERC20(IERC20(tokenAddresses[i]), amounts[i], receiverLayer2);
640         }
641     }
642 
643     // receiverLayer2 setter
644     function setReceiverLayer2(address newReceiverLayer2) external onlyOwner {
645         receiverLayer2 = newReceiverLayer2;
646     }
647 
648     // zksCoreAddress setter
649     function setZksCoreAddress(address newZksCoreAddress) external onlyOwner {
650         zksCoreAddress = ZksCore(newZksCoreAddress);
651     }
652 
653     // depositWorker setter
654     function setDepositWorker(address newDepositWorker) external onlyOwner {
655         depositWorker = newDepositWorker;
656     }
657 
658     // give erc20 approval to Zks core contract
659     function approveToZksCore(
660         address[] calldata tokenAddresses,
661         uint[] calldata allowances
662     )
663     external
664     nonReentrant
665     onlyOwner
666     {
667         require(tokenAddresses.length == allowances.length, "unmatched length");
668         for (uint i = 0; i < tokenAddresses.length; ++i) {
669             IERC20(tokenAddresses[i]).safeApprove(address(zksCoreAddress), allowances[i]);
670         }
671     }
672 
673     // for emergency
674     function emergencyWithdraw(address tokenAddress, uint amount) external onlyOwner nonReentrant {
675         if (tokenAddress != address(0)) {
676             // withdraw ERC20
677             IERC20(tokenAddress).safeTransfer(msg.sender, amount);
678             return;
679         }
680 
681         // withdraw eth
682         payable(msg.sender).transfer(amount);
683     }
684 }