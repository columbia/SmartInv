1 // SPDX-License-Identifier: BUSL-1.1
2 
3 pragma solidity 0.8.6;
4 
5 
6 
7 // Part: IBetaBank
8 
9 interface IBetaBank {
10   /// @dev Returns the address of BToken of the given underlying token, or 0 if not exists.
11   function bTokens(address _underlying) external view returns (address);
12 
13   /// @dev Returns the address of the underlying of the given BToken, or 0 if not exists.
14   function underlyings(address _bToken) external view returns (address);
15 
16   /// @dev Returns the address of the oracle contract.
17   function oracle() external view returns (address);
18 
19   /// @dev Returns the address of the config contract.
20   function config() external view returns (address);
21 
22   /// @dev Returns the interest rate model smart contract.
23   function interestModel() external view returns (address);
24 
25   /// @dev Returns the position's collateral token and AmToken.
26   function getPositionTokens(address _owner, uint _pid)
27     external
28     view
29     returns (address _collateral, address _bToken);
30 
31   /// @dev Returns the debt of the given position. Can't be view as it needs to call accrue.
32   function fetchPositionDebt(address _owner, uint _pid) external returns (uint);
33 
34   /// @dev Returns the LTV of the given position. Can't be view as it needs to call accrue.
35   function fetchPositionLTV(address _owner, uint _pid) external returns (uint);
36 
37   /// @dev Opens a new position in the Beta smart contract.
38   function open(
39     address _owner,
40     address _underlying,
41     address _collateral
42   ) external returns (uint pid);
43 
44   /// @dev Borrows tokens on the given position.
45   function borrow(
46     address _owner,
47     uint _pid,
48     uint _amount
49   ) external;
50 
51   /// @dev Repays tokens on the given position.
52   function repay(
53     address _owner,
54     uint _pid,
55     uint _amount
56   ) external;
57 
58   /// @dev Puts more collateral to the given position.
59   function put(
60     address _owner,
61     uint _pid,
62     uint _amount
63   ) external;
64 
65   /// @dev Takes some collateral out of the position.
66   function take(
67     address _owner,
68     uint _pid,
69     uint _amount
70   ) external;
71 
72   /// @dev Liquidates the given position.
73   function liquidate(
74     address _owner,
75     uint _pid,
76     uint _amount
77   ) external;
78 }
79 
80 // Part: IWETH
81 
82 interface IWETH {
83   function deposit() external payable;
84 
85   function withdraw(uint wad) external;
86 
87   function approve(address guy, uint wad) external returns (bool);
88 }
89 
90 // Part: OpenZeppelin/openzeppelin-contracts@4.2.0/Address
91 
92 /**
93  * @dev Collection of functions related to the address type
94  */
95 library Address {
96     /**
97      * @dev Returns true if `account` is a contract.
98      *
99      * [IMPORTANT]
100      * ====
101      * It is unsafe to assume that an address for which this function returns
102      * false is an externally-owned account (EOA) and not a contract.
103      *
104      * Among others, `isContract` will return false for the following
105      * types of addresses:
106      *
107      *  - an externally-owned account
108      *  - a contract in construction
109      *  - an address where a contract will be created
110      *  - an address where a contract lived, but was destroyed
111      * ====
112      */
113     function isContract(address account) internal view returns (bool) {
114         // This method relies on extcodesize, which returns 0 for contracts in
115         // construction, since the code is only stored at the end of the
116         // constructor execution.
117 
118         uint256 size;
119         assembly {
120             size := extcodesize(account)
121         }
122         return size > 0;
123     }
124 
125     /**
126      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
127      * `recipient`, forwarding all available gas and reverting on errors.
128      *
129      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
130      * of certain opcodes, possibly making contracts go over the 2300 gas limit
131      * imposed by `transfer`, making them unable to receive funds via
132      * `transfer`. {sendValue} removes this limitation.
133      *
134      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
135      *
136      * IMPORTANT: because control is transferred to `recipient`, care must be
137      * taken to not create reentrancy vulnerabilities. Consider using
138      * {ReentrancyGuard} or the
139      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
140      */
141     function sendValue(address payable recipient, uint256 amount) internal {
142         require(address(this).balance >= amount, "Address: insufficient balance");
143 
144         (bool success, ) = recipient.call{value: amount}("");
145         require(success, "Address: unable to send value, recipient may have reverted");
146     }
147 
148     /**
149      * @dev Performs a Solidity function call using a low level `call`. A
150      * plain `call` is an unsafe replacement for a function call: use this
151      * function instead.
152      *
153      * If `target` reverts with a revert reason, it is bubbled up by this
154      * function (like regular Solidity function calls).
155      *
156      * Returns the raw returned data. To convert to the expected return value,
157      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
158      *
159      * Requirements:
160      *
161      * - `target` must be a contract.
162      * - calling `target` with `data` must not revert.
163      *
164      * _Available since v3.1._
165      */
166     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
167         return functionCall(target, data, "Address: low-level call failed");
168     }
169 
170     /**
171      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
172      * `errorMessage` as a fallback revert reason when `target` reverts.
173      *
174      * _Available since v3.1._
175      */
176     function functionCall(
177         address target,
178         bytes memory data,
179         string memory errorMessage
180     ) internal returns (bytes memory) {
181         return functionCallWithValue(target, data, 0, errorMessage);
182     }
183 
184     /**
185      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
186      * but also transferring `value` wei to `target`.
187      *
188      * Requirements:
189      *
190      * - the calling contract must have an ETH balance of at least `value`.
191      * - the called Solidity function must be `payable`.
192      *
193      * _Available since v3.1._
194      */
195     function functionCallWithValue(
196         address target,
197         bytes memory data,
198         uint256 value
199     ) internal returns (bytes memory) {
200         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
201     }
202 
203     /**
204      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
205      * with `errorMessage` as a fallback revert reason when `target` reverts.
206      *
207      * _Available since v3.1._
208      */
209     function functionCallWithValue(
210         address target,
211         bytes memory data,
212         uint256 value,
213         string memory errorMessage
214     ) internal returns (bytes memory) {
215         require(address(this).balance >= value, "Address: insufficient balance for call");
216         require(isContract(target), "Address: call to non-contract");
217 
218         (bool success, bytes memory returndata) = target.call{value: value}(data);
219         return _verifyCallResult(success, returndata, errorMessage);
220     }
221 
222     /**
223      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
224      * but performing a static call.
225      *
226      * _Available since v3.3._
227      */
228     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
229         return functionStaticCall(target, data, "Address: low-level static call failed");
230     }
231 
232     /**
233      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
234      * but performing a static call.
235      *
236      * _Available since v3.3._
237      */
238     function functionStaticCall(
239         address target,
240         bytes memory data,
241         string memory errorMessage
242     ) internal view returns (bytes memory) {
243         require(isContract(target), "Address: static call to non-contract");
244 
245         (bool success, bytes memory returndata) = target.staticcall(data);
246         return _verifyCallResult(success, returndata, errorMessage);
247     }
248 
249     /**
250      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
251      * but performing a delegate call.
252      *
253      * _Available since v3.4._
254      */
255     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
256         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
257     }
258 
259     /**
260      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
261      * but performing a delegate call.
262      *
263      * _Available since v3.4._
264      */
265     function functionDelegateCall(
266         address target,
267         bytes memory data,
268         string memory errorMessage
269     ) internal returns (bytes memory) {
270         require(isContract(target), "Address: delegate call to non-contract");
271 
272         (bool success, bytes memory returndata) = target.delegatecall(data);
273         return _verifyCallResult(success, returndata, errorMessage);
274     }
275 
276     function _verifyCallResult(
277         bool success,
278         bytes memory returndata,
279         string memory errorMessage
280     ) private pure returns (bytes memory) {
281         if (success) {
282             return returndata;
283         } else {
284             // Look for revert reason and bubble it up if present
285             if (returndata.length > 0) {
286                 // The easiest way to bubble the revert reason is using memory via assembly
287 
288                 assembly {
289                     let returndata_size := mload(returndata)
290                     revert(add(32, returndata), returndata_size)
291                 }
292             } else {
293                 revert(errorMessage);
294             }
295         }
296     }
297 }
298 
299 // Part: OpenZeppelin/openzeppelin-contracts@4.2.0/Context
300 
301 /*
302  * @dev Provides information about the current execution context, including the
303  * sender of the transaction and its data. While these are generally available
304  * via msg.sender and msg.data, they should not be accessed in such a direct
305  * manner, since when dealing with meta-transactions the account sending and
306  * paying for execution may not be the actual sender (as far as an application
307  * is concerned).
308  *
309  * This contract is only required for intermediate, library-like contracts.
310  */
311 abstract contract Context {
312     function _msgSender() internal view virtual returns (address) {
313         return msg.sender;
314     }
315 
316     function _msgData() internal view virtual returns (bytes calldata) {
317         return msg.data;
318     }
319 }
320 
321 // Part: OpenZeppelin/openzeppelin-contracts@4.2.0/IERC20
322 
323 /**
324  * @dev Interface of the ERC20 standard as defined in the EIP.
325  */
326 interface IERC20 {
327     /**
328      * @dev Returns the amount of tokens in existence.
329      */
330     function totalSupply() external view returns (uint256);
331 
332     /**
333      * @dev Returns the amount of tokens owned by `account`.
334      */
335     function balanceOf(address account) external view returns (uint256);
336 
337     /**
338      * @dev Moves `amount` tokens from the caller's account to `recipient`.
339      *
340      * Returns a boolean value indicating whether the operation succeeded.
341      *
342      * Emits a {Transfer} event.
343      */
344     function transfer(address recipient, uint256 amount) external returns (bool);
345 
346     /**
347      * @dev Returns the remaining number of tokens that `spender` will be
348      * allowed to spend on behalf of `owner` through {transferFrom}. This is
349      * zero by default.
350      *
351      * This value changes when {approve} or {transferFrom} are called.
352      */
353     function allowance(address owner, address spender) external view returns (uint256);
354 
355     /**
356      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
357      *
358      * Returns a boolean value indicating whether the operation succeeded.
359      *
360      * IMPORTANT: Beware that changing an allowance with this method brings the risk
361      * that someone may use both the old and the new allowance by unfortunate
362      * transaction ordering. One possible solution to mitigate this race
363      * condition is to first reduce the spender's allowance to 0 and set the
364      * desired value afterwards:
365      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
366      *
367      * Emits an {Approval} event.
368      */
369     function approve(address spender, uint256 amount) external returns (bool);
370 
371     /**
372      * @dev Moves `amount` tokens from `sender` to `recipient` using the
373      * allowance mechanism. `amount` is then deducted from the caller's
374      * allowance.
375      *
376      * Returns a boolean value indicating whether the operation succeeded.
377      *
378      * Emits a {Transfer} event.
379      */
380     function transferFrom(
381         address sender,
382         address recipient,
383         uint256 amount
384     ) external returns (bool);
385 
386     /**
387      * @dev Emitted when `value` tokens are moved from one account (`from`) to
388      * another (`to`).
389      *
390      * Note that `value` may be zero.
391      */
392     event Transfer(address indexed from, address indexed to, uint256 value);
393 
394     /**
395      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
396      * a call to {approve}. `value` is the new allowance.
397      */
398     event Approval(address indexed owner, address indexed spender, uint256 value);
399 }
400 
401 // Part: OpenZeppelin/openzeppelin-contracts@4.2.0/Math
402 
403 /**
404  * @dev Standard math utilities missing in the Solidity language.
405  */
406 library Math {
407     /**
408      * @dev Returns the largest of two numbers.
409      */
410     function max(uint256 a, uint256 b) internal pure returns (uint256) {
411         return a >= b ? a : b;
412     }
413 
414     /**
415      * @dev Returns the smallest of two numbers.
416      */
417     function min(uint256 a, uint256 b) internal pure returns (uint256) {
418         return a < b ? a : b;
419     }
420 
421     /**
422      * @dev Returns the average of two numbers. The result is rounded towards
423      * zero.
424      */
425     function average(uint256 a, uint256 b) internal pure returns (uint256) {
426         // (a + b) / 2 can overflow, so we distribute.
427         return (a / 2) + (b / 2) + (((a % 2) + (b % 2)) / 2);
428     }
429 
430     /**
431      * @dev Returns the ceiling of the division of two numbers.
432      *
433      * This differs from standard division with `/` in that it rounds up instead
434      * of rounding down.
435      */
436     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
437         // (a + b - 1) / b can overflow on addition, so we distribute.
438         return a / b + (a % b == 0 ? 0 : 1);
439     }
440 }
441 
442 // Part: OpenZeppelin/openzeppelin-contracts@4.2.0/SafeERC20
443 
444 /**
445  * @title SafeERC20
446  * @dev Wrappers around ERC20 operations that throw on failure (when the token
447  * contract returns false). Tokens that return no value (and instead revert or
448  * throw on failure) are also supported, non-reverting calls are assumed to be
449  * successful.
450  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
451  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
452  */
453 library SafeERC20 {
454     using Address for address;
455 
456     function safeTransfer(
457         IERC20 token,
458         address to,
459         uint256 value
460     ) internal {
461         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
462     }
463 
464     function safeTransferFrom(
465         IERC20 token,
466         address from,
467         address to,
468         uint256 value
469     ) internal {
470         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
471     }
472 
473     /**
474      * @dev Deprecated. This function has issues similar to the ones found in
475      * {IERC20-approve}, and its usage is discouraged.
476      *
477      * Whenever possible, use {safeIncreaseAllowance} and
478      * {safeDecreaseAllowance} instead.
479      */
480     function safeApprove(
481         IERC20 token,
482         address spender,
483         uint256 value
484     ) internal {
485         // safeApprove should only be called when setting an initial allowance,
486         // or when resetting it to zero. To increase and decrease it, use
487         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
488         require(
489             (value == 0) || (token.allowance(address(this), spender) == 0),
490             "SafeERC20: approve from non-zero to non-zero allowance"
491         );
492         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
493     }
494 
495     function safeIncreaseAllowance(
496         IERC20 token,
497         address spender,
498         uint256 value
499     ) internal {
500         uint256 newAllowance = token.allowance(address(this), spender) + value;
501         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
502     }
503 
504     function safeDecreaseAllowance(
505         IERC20 token,
506         address spender,
507         uint256 value
508     ) internal {
509         unchecked {
510             uint256 oldAllowance = token.allowance(address(this), spender);
511             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
512             uint256 newAllowance = oldAllowance - value;
513             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
514         }
515     }
516 
517     /**
518      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
519      * on the return value: the return value is optional (but if data is returned, it must not be false).
520      * @param token The token targeted by the call.
521      * @param data The call data (encoded using abi.encode or one of its variants).
522      */
523     function _callOptionalReturn(IERC20 token, bytes memory data) private {
524         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
525         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
526         // the target address contains contract code and also asserts for success in the low-level call.
527 
528         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
529         if (returndata.length > 0) {
530             // Return data is optional
531             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
532         }
533     }
534 }
535 
536 // Part: OpenZeppelin/openzeppelin-contracts@4.2.0/Ownable
537 
538 /**
539  * @dev Contract module which provides a basic access control mechanism, where
540  * there is an account (an owner) that can be granted exclusive access to
541  * specific functions.
542  *
543  * By default, the owner account will be the one that deploys the contract. This
544  * can later be changed with {transferOwnership}.
545  *
546  * This module is used through inheritance. It will make available the modifier
547  * `onlyOwner`, which can be applied to your functions to restrict their use to
548  * the owner.
549  */
550 abstract contract Ownable is Context {
551     address private _owner;
552 
553     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
554 
555     /**
556      * @dev Initializes the contract setting the deployer as the initial owner.
557      */
558     constructor() {
559         _setOwner(_msgSender());
560     }
561 
562     /**
563      * @dev Returns the address of the current owner.
564      */
565     function owner() public view virtual returns (address) {
566         return _owner;
567     }
568 
569     /**
570      * @dev Throws if called by any account other than the owner.
571      */
572     modifier onlyOwner() {
573         require(owner() == _msgSender(), "Ownable: caller is not the owner");
574         _;
575     }
576 
577     /**
578      * @dev Leaves the contract without owner. It will not be possible to call
579      * `onlyOwner` functions anymore. Can only be called by the current owner.
580      *
581      * NOTE: Renouncing ownership will leave the contract without an owner,
582      * thereby removing any functionality that is only available to the owner.
583      */
584     function renounceOwnership() public virtual onlyOwner {
585         _setOwner(address(0));
586     }
587 
588     /**
589      * @dev Transfers ownership of the contract to a new account (`newOwner`).
590      * Can only be called by the current owner.
591      */
592     function transferOwnership(address newOwner) public virtual onlyOwner {
593         require(newOwner != address(0), "Ownable: new owner is the zero address");
594         _setOwner(newOwner);
595     }
596 
597     function _setOwner(address newOwner) private {
598         address oldOwner = _owner;
599         _owner = newOwner;
600         emit OwnershipTransferred(oldOwner, newOwner);
601     }
602 }
603 
604 // Part: BetaRunnerBase
605 
606 contract BetaRunnerBase is Ownable {
607   using SafeERC20 for IERC20;
608 
609   address public immutable betaBank;
610   address public immutable weth;
611 
612   modifier onlyEOA() {
613     require(msg.sender == tx.origin, 'BetaRunnerBase/not-eoa');
614     _;
615   }
616 
617   constructor(address _betaBank, address _weth) {
618     address bweth = IBetaBank(_betaBank).bTokens(_weth);
619     require(bweth != address(0), 'BetaRunnerBase/no-bweth');
620     IERC20(_weth).safeApprove(_betaBank, type(uint).max);
621     IERC20(_weth).safeApprove(bweth, type(uint).max);
622     betaBank = _betaBank;
623     weth = _weth;
624   }
625 
626   function _borrow(
627     address _owner,
628     uint _pid,
629     address _underlying,
630     address _collateral,
631     uint _amountBorrow,
632     uint _amountCollateral
633   ) internal {
634     if (_pid == type(uint).max) {
635       _pid = IBetaBank(betaBank).open(_owner, _underlying, _collateral);
636     } else {
637       (address collateral, address bToken) = IBetaBank(betaBank).getPositionTokens(_owner, _pid);
638       require(_collateral == collateral, '_borrow/collateral-not-_collateral');
639       require(_underlying == IBetaBank(betaBank).underlyings(bToken), '_borrow/bad-underlying');
640     }
641     _approve(_collateral, betaBank, _amountCollateral);
642     IBetaBank(betaBank).put(_owner, _pid, _amountCollateral);
643     IBetaBank(betaBank).borrow(_owner, _pid, _amountBorrow);
644   }
645 
646   function _repay(
647     address _owner,
648     uint _pid,
649     address _underlying,
650     address _collateral,
651     uint _amountRepay,
652     uint _amountCollateral
653   ) internal {
654     (address collateral, address bToken) = IBetaBank(betaBank).getPositionTokens(_owner, _pid);
655     require(_collateral == collateral, '_repay/collateral-not-_collateral');
656     require(_underlying == IBetaBank(betaBank).underlyings(bToken), '_repay/bad-underlying');
657     _approve(_underlying, bToken, _amountRepay);
658     IBetaBank(betaBank).repay(_owner, _pid, _amountRepay);
659     IBetaBank(betaBank).take(_owner, _pid, _amountCollateral);
660   }
661 
662   function _transferIn(
663     address _token,
664     address _from,
665     uint _amount
666   ) internal {
667     if (_token == weth) {
668       require(_from == msg.sender, '_transferIn/not-from-sender');
669       require(_amount <= msg.value, '_transferIn/insufficient-eth-amount');
670       IWETH(weth).deposit{value: _amount}();
671       if (msg.value > _amount) {
672         (bool success, ) = _from.call{value: msg.value - _amount}(new bytes(0));
673         require(success, '_transferIn/eth-transfer-failed');
674       }
675     } else {
676       IERC20(_token).safeTransferFrom(_from, address(this), _amount);
677     }
678   }
679 
680   function _transferOut(
681     address _token,
682     address _to,
683     uint _amount
684   ) internal {
685     if (_token == weth) {
686       IWETH(weth).withdraw(_amount);
687       (bool success, ) = _to.call{value: _amount}(new bytes(0));
688       require(success, '_transferOut/eth-transfer-failed');
689     } else {
690       IERC20(_token).safeTransfer(_to, _amount);
691     }
692   }
693 
694   /// @dev Approves infinite on the given token for the given spender if current approval is insufficient.
695   function _approve(
696     address _token,
697     address _spender,
698     uint _minAmount
699   ) internal {
700     uint current = IERC20(_token).allowance(address(this), _spender);
701     if (current < _minAmount) {
702       if (current != 0) {
703         IERC20(_token).safeApprove(_spender, 0);
704       }
705       IERC20(_token).safeApprove(_spender, type(uint).max);
706     }
707   }
708 
709   /// @dev Caps repay amount by current position's debt.
710   function _capRepay(
711     address _owner,
712     uint _pid,
713     uint _amountRepay
714   ) internal returns (uint) {
715     return Math.min(_amountRepay, IBetaBank(betaBank).fetchPositionDebt(_owner, _pid));
716   }
717 
718   /// @dev Recovers lost tokens for whatever reason by the owner.
719   function recover(address _token, uint _amount) external onlyOwner {
720     if (_amount == type(uint).max) {
721       _amount = IERC20(_token).balanceOf(address(this));
722     }
723     IERC20(_token).safeTransfer(msg.sender, _amount);
724   }
725 
726   /// @dev Recovers lost ETH for whatever reason by the owner.
727   function recoverETH(uint _amount) external onlyOwner {
728     if (_amount == type(uint).max) {
729       _amount = address(this).balance;
730     }
731     (bool success, ) = msg.sender.call{value: _amount}(new bytes(0));
732     require(success, 'recoverETH/eth-transfer-failed');
733   }
734 
735   /// @dev Override Ownable.sol renounceOwnership to prevent accidental call
736   function renounceOwnership() public override onlyOwner {
737     revert('renounceOwnership/disabled');
738   }
739 
740   receive() external payable {
741     require(msg.sender == weth, 'receive/not-weth');
742   }
743 }
744 
745 // File: BetaRunnerLending.sol
746 
747 contract BetaRunnerLending is BetaRunnerBase {
748   constructor(address _betaBank, address _weth) BetaRunnerBase(_betaBank, _weth) {}
749 
750   /// @dev Borrows the asset using the given collateral.
751   function borrow(
752     uint _pid,
753     address _underlying,
754     address _collateral,
755     uint _amountBorrow,
756     uint _amountPut
757   ) external payable onlyEOA {
758     _transferIn(_collateral, msg.sender, _amountPut);
759     _borrow(msg.sender, _pid, _underlying, _collateral, _amountBorrow, _amountPut);
760     _transferOut(_underlying, msg.sender, _amountBorrow);
761   }
762 
763   /// @dev Repays the debt and takes collateral for owner.
764   function repay(
765     uint _pid,
766     address _underlying,
767     address _collateral,
768     uint _amountRepay,
769     uint _amountTake
770   ) external payable onlyEOA {
771     _amountRepay = _capRepay(msg.sender, _pid, _amountRepay);
772     _transferIn(_underlying, msg.sender, _amountRepay);
773     _repay(msg.sender, _pid, _underlying, _collateral, _amountRepay, _amountTake);
774     _transferOut(_collateral, msg.sender, _amountTake);
775   }
776 }
