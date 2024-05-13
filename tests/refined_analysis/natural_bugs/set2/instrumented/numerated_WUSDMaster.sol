1 /**
2  *Submitted for verification at BscScan.com on 2021-08-03
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.8.0;
8 
9 /*
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes calldata) {
25         return msg.data;
26     }
27 }
28 
29 /**
30  * @dev Contract module which provides a basic access control mechanism, where
31  * there is an account (an owner) that can be granted exclusive access to
32  * specific functions.
33  *
34  * By default, the owner account will be the one that deploys the contract. This
35  * can later be changed with {transferOwnership}.
36  *
37  * This module is used through inheritance. It will make available the modifier
38  * `onlyOwner`, which can be applied to your functions to restrict their use to
39  * the owner.
40  */
41 abstract contract Ownable is Context {
42     address private _owner;
43 
44     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
45 
46     /**
47      * @dev Initializes the contract setting the deployer as the initial owner.
48      */
49     constructor() {
50         _setOwner(_msgSender());
51     }
52 
53     /**
54      * @dev Returns the address of the current owner.
55      */
56     function owner() public view virtual returns (address) {
57         return _owner;
58     }
59 
60     /**
61      * @dev Throws if called by any account other than the owner.
62      */
63     modifier onlyOwner() {
64         require(owner() == _msgSender(), "Ownable: caller is not the owner");
65         _;
66     }
67 
68     /**
69      * @dev Leaves the contract without owner. It will not be possible to call
70      * `onlyOwner` functions anymore. Can only be called by the current owner.
71      *
72      * NOTE: Renouncing ownership will leave the contract without an owner,
73      * thereby removing any functionality that is only available to the owner.
74      */
75     function renounceOwnership() public virtual onlyOwner {
76         _setOwner(address(0));
77     }
78 
79     /**
80      * @dev Transfers ownership of the contract to a new account (`newOwner`).
81      * Can only be called by the current owner.
82      */
83     function transferOwnership(address newOwner) public virtual onlyOwner {
84         require(newOwner != address(0), "Ownable: new owner is the zero address");
85         _setOwner(newOwner);
86     }
87 
88     function _setOwner(address newOwner) private {
89         address oldOwner = _owner;
90         _owner = newOwner;
91         emit OwnershipTransferred(oldOwner, newOwner);
92     }
93 }
94 
95 /**
96  * @dev Contract module which provides a basic access control mechanism, where
97  * there is an account (a withdrawer) that can be granted exclusive access to
98  * specific functions.
99  *
100  * By default, the withdrawer account will be the one that deploys the contract. This
101  * can later be changed with {transferWithdrawership}.
102  *
103  * This module is used through inheritance. It will make available the modifier
104  * `onlyWithdrawer`, which can be applied to your functions to restrict their use to
105  * the withdrawer.
106  */
107 abstract contract Withdrawable is Context, Ownable {
108 
109     /**
110      * @dev So here we seperate the rights of the classic ownership into 'owner' and 'withdrawer'
111      * this way the developer/owner stays the 'owner' and can make changes at any time
112      * but cannot withdraw anymore as soon as the 'withdrawer' gets changes (to the chef contract)
113      */
114     address private _withdrawer;
115 
116     event WithdrawershipTransferred(address indexed previousWithdrawer, address indexed newWithdrawer);
117 
118     /**
119      * @dev Initializes the contract setting the deployer as the initial withdrawer.
120      */
121     constructor () {
122         address msgSender = _msgSender();
123         _withdrawer = msgSender;
124         emit WithdrawershipTransferred(address(0), msgSender);
125     }
126 
127     /**
128      * @dev Returns the address of the current withdrawer.
129      */
130     function withdrawer() public view returns (address) {
131         return _withdrawer;
132     }
133 
134     /**
135      * @dev Throws if called by any account other than the withdrawer.
136      */
137     modifier onlyWithdrawer() {
138         require(_withdrawer == _msgSender(), "Withdrawable: caller is not the withdrawer");
139         _;
140     }
141 
142     /**
143      * @dev Transfers withdrawership of the contract to a new account (`newWithdrawer`).
144      * Can only be called by the current owner.
145      */
146     function transferWithdrawership(address newWithdrawer) public virtual onlyOwner {
147         require(newWithdrawer != address(0), "Withdrawable: new withdrawer is the zero address");
148         
149         emit WithdrawershipTransferred(_withdrawer, newWithdrawer);
150         _withdrawer = newWithdrawer;
151     }
152 }
153 
154 /**
155  * @dev Contract module that helps prevent reentrant calls to a function.
156  *
157  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
158  * available, which can be applied to functions to make sure there are no nested
159  * (reentrant) calls to them.
160  *
161  * Note that because there is a single `nonReentrant` guard, functions marked as
162  * `nonReentrant` may not call one another. This can be worked around by making
163  * those functions `private`, and then adding `external` `nonReentrant` entry
164  * points to them.
165  *
166  * TIP: If you would like to learn more about reentrancy and alternative ways
167  * to protect against it, check out our blog post
168  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
169  */
170 abstract contract ReentrancyGuard {
171     // Booleans are more expensive than uint256 or any type that takes up a full
172     // word because each write operation emits an extra SLOAD to first read the
173     // slot's contents, replace the bits taken up by the boolean, and then write
174     // back. This is the compiler's defense against contract upgrades and
175     // pointer aliasing, and it cannot be disabled.
176 
177     // The values being non-zero value makes deployment a bit more expensive,
178     // but in exchange the refund on every call to nonReentrant will be lower in
179     // amount. Since refunds are capped to a percentage of the total
180     // transaction's gas, it is best to keep them low in cases like this one, to
181     // increase the likelihood of the full refund coming into effect.
182     uint256 private constant _NOT_ENTERED = 1;
183     uint256 private constant _ENTERED = 2;
184 
185     uint256 private _status;
186 
187     constructor() {
188         _status = _NOT_ENTERED;
189     }
190 
191     /**
192      * @dev Prevents a contract from calling itself, directly or indirectly.
193      * Calling a `nonReentrant` function from another `nonReentrant`
194      * function is not supported. It is possible to prevent this from happening
195      * by making the `nonReentrant` function external, and make it call a
196      * `private` function that does the actual work.
197      */
198     modifier nonReentrant() {
199         // On the first call to nonReentrant, _notEntered will be true
200         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
201 
202         // Any calls to nonReentrant after this point will fail
203         _status = _ENTERED;
204 
205         _;
206 
207         // By storing the original value once again, a refund is triggered (see
208         // https://eips.ethereum.org/EIPS/eip-2200)
209         _status = _NOT_ENTERED;
210     }
211 }
212 
213 /**
214  * @dev Interface of the ERC20 standard as defined in the EIP.
215  */
216 interface IERC20 {
217     /**
218      * @dev Returns the amount of tokens in existence.
219      */
220     function totalSupply() external view returns (uint256);
221 
222     /**
223      * @dev Returns the amount of tokens owned by `account`.
224      */
225     function balanceOf(address account) external view returns (uint256);
226 
227     /**
228      * @dev Moves `amount` tokens from the caller's account to `recipient`.
229      *
230      * Returns a boolean value indicating whether the operation succeeded.
231      *
232      * Emits a {Transfer} event.
233      */
234     function transfer(address recipient, uint256 amount) external returns (bool);
235 
236     /**
237      * @dev Returns the remaining number of tokens that `spender` will be
238      * allowed to spend on behalf of `owner` through {transferFrom}. This is
239      * zero by default.
240      *
241      * This value changes when {approve} or {transferFrom} are called.
242      */
243     function allowance(address owner, address spender) external view returns (uint256);
244 
245     /**
246      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
247      *
248      * Returns a boolean value indicating whether the operation succeeded.
249      *
250      * IMPORTANT: Beware that changing an allowance with this method brings the risk
251      * that someone may use both the old and the new allowance by unfortunate
252      * transaction ordering. One possible solution to mitigate this race
253      * condition is to first reduce the spender's allowance to 0 and set the
254      * desired value afterwards:
255      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
256      *
257      * Emits an {Approval} event.
258      */
259     function approve(address spender, uint256 amount) external returns (bool);
260 
261     /**
262      * @dev Moves `amount` tokens from `sender` to `recipient` using the
263      * allowance mechanism. `amount` is then deducted from the caller's
264      * allowance.
265      *
266      * Returns a boolean value indicating whether the operation succeeded.
267      *
268      * Emits a {Transfer} event.
269      */
270     function transferFrom(
271         address sender,
272         address recipient,
273         uint256 amount
274     ) external returns (bool);
275 
276     /**
277      * @dev Emitted when `value` tokens are moved from one account (`from`) to
278      * another (`to`).
279      *
280      * Note that `value` may be zero.
281      */
282     event Transfer(address indexed from, address indexed to, uint256 value);
283 
284     /**
285      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
286      * a call to {approve}. `value` is the new allowance.
287      */
288     event Approval(address indexed owner, address indexed spender, uint256 value);
289 }
290 
291 /**
292  * @dev Collection of functions related to the address type
293  */
294 library Address {
295     /**
296      * @dev Returns true if `account` is a contract.
297      *
298      * [IMPORTANT]
299      * ====
300      * It is unsafe to assume that an address for which this function returns
301      * false is an externally-owned account (EOA) and not a contract.
302      *
303      * Among others, `isContract` will return false for the following
304      * types of addresses:
305      *
306      *  - an externally-owned account
307      *  - a contract in construction
308      *  - an address where a contract will be created
309      *  - an address where a contract lived, but was destroyed
310      * ====
311      */
312     function isContract(address account) internal view returns (bool) {
313         // This method relies on extcodesize, which returns 0 for contracts in
314         // construction, since the code is only stored at the end of the
315         // constructor execution.
316 
317         uint256 size;
318         assembly {
319             size := extcodesize(account)
320         }
321         return size > 0;
322     }
323 
324     /**
325      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
326      * `recipient`, forwarding all available gas and reverting on errors.
327      *
328      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
329      * of certain opcodes, possibly making contracts go over the 2300 gas limit
330      * imposed by `transfer`, making them unable to receive funds via
331      * `transfer`. {sendValue} removes this limitation.
332      *
333      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
334      *
335      * IMPORTANT: because control is transferred to `recipient`, care must be
336      * taken to not create reentrancy vulnerabilities. Consider using
337      * {ReentrancyGuard} or the
338      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
339      */
340     function sendValue(address payable recipient, uint256 amount) internal {
341         require(address(this).balance >= amount, "Address: insufficient balance");
342 
343         (bool success, ) = recipient.call{value: amount}("");
344         require(success, "Address: unable to send value, recipient may have reverted");
345     }
346 
347     /**
348      * @dev Performs a Solidity function call using a low level `call`. A
349      * plain `call` is an unsafe replacement for a function call: use this
350      * function instead.
351      *
352      * If `target` reverts with a revert reason, it is bubbled up by this
353      * function (like regular Solidity function calls).
354      *
355      * Returns the raw returned data. To convert to the expected return value,
356      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
357      *
358      * Requirements:
359      *
360      * - `target` must be a contract.
361      * - calling `target` with `data` must not revert.
362      *
363      * _Available since v3.1._
364      */
365     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
366         return functionCall(target, data, "Address: low-level call failed");
367     }
368 
369     /**
370      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
371      * `errorMessage` as a fallback revert reason when `target` reverts.
372      *
373      * _Available since v3.1._
374      */
375     function functionCall(
376         address target,
377         bytes memory data,
378         string memory errorMessage
379     ) internal returns (bytes memory) {
380         return functionCallWithValue(target, data, 0, errorMessage);
381     }
382 
383     /**
384      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
385      * but also transferring `value` wei to `target`.
386      *
387      * Requirements:
388      *
389      * - the calling contract must have an ETH balance of at least `value`.
390      * - the called Solidity function must be `payable`.
391      *
392      * _Available since v3.1._
393      */
394     function functionCallWithValue(
395         address target,
396         bytes memory data,
397         uint256 value
398     ) internal returns (bytes memory) {
399         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
400     }
401 
402     /**
403      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
404      * with `errorMessage` as a fallback revert reason when `target` reverts.
405      *
406      * _Available since v3.1._
407      */
408     function functionCallWithValue(
409         address target,
410         bytes memory data,
411         uint256 value,
412         string memory errorMessage
413     ) internal returns (bytes memory) {
414         require(address(this).balance >= value, "Address: insufficient balance for call");
415         require(isContract(target), "Address: call to non-contract");
416 
417         (bool success, bytes memory returndata) = target.call{value: value}(data);
418         return _verifyCallResult(success, returndata, errorMessage);
419     }
420 
421     /**
422      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
423      * but performing a static call.
424      *
425      * _Available since v3.3._
426      */
427     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
428         return functionStaticCall(target, data, "Address: low-level static call failed");
429     }
430 
431     /**
432      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
433      * but performing a static call.
434      *
435      * _Available since v3.3._
436      */
437     function functionStaticCall(
438         address target,
439         bytes memory data,
440         string memory errorMessage
441     ) internal view returns (bytes memory) {
442         require(isContract(target), "Address: static call to non-contract");
443 
444         (bool success, bytes memory returndata) = target.staticcall(data);
445         return _verifyCallResult(success, returndata, errorMessage);
446     }
447 
448     /**
449      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
450      * but performing a delegate call.
451      *
452      * _Available since v3.4._
453      */
454     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
455         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
456     }
457 
458     /**
459      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
460      * but performing a delegate call.
461      *
462      * _Available since v3.4._
463      */
464     function functionDelegateCall(
465         address target,
466         bytes memory data,
467         string memory errorMessage
468     ) internal returns (bytes memory) {
469         require(isContract(target), "Address: delegate call to non-contract");
470 
471         (bool success, bytes memory returndata) = target.delegatecall(data);
472         return _verifyCallResult(success, returndata, errorMessage);
473     }
474 
475     function _verifyCallResult(
476         bool success,
477         bytes memory returndata,
478         string memory errorMessage
479     ) private pure returns (bytes memory) {
480         if (success) {
481             return returndata;
482         } else {
483             // Look for revert reason and bubble it up if present
484             if (returndata.length > 0) {
485                 // The easiest way to bubble the revert reason is using memory via assembly
486 
487                 assembly {
488                     let returndata_size := mload(returndata)
489                     revert(add(32, returndata), returndata_size)
490                 }
491             } else {
492                 revert(errorMessage);
493             }
494         }
495     }
496 }
497 
498 /**
499  * @title SafeERC20
500  * @dev Wrappers around ERC20 operations that throw on failure (when the token
501  * contract returns false). Tokens that return no value (and instead revert or
502  * throw on failure) are also supported, non-reverting calls are assumed to be
503  * successful.
504  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
505  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
506  */
507 library SafeERC20 {
508     using Address for address;
509 
510     function safeTransfer(
511         IERC20 token,
512         address to,
513         uint256 value
514     ) internal {
515         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
516     }
517 
518     function safeTransferFrom(
519         IERC20 token,
520         address from,
521         address to,
522         uint256 value
523     ) internal {
524         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
525     }
526 
527     /**
528      * @dev Deprecated. This function has issues similar to the ones found in
529      * {IERC20-approve}, and its usage is discouraged.
530      *
531      * Whenever possible, use {safeIncreaseAllowance} and
532      * {safeDecreaseAllowance} instead.
533      */
534     function safeApprove(
535         IERC20 token,
536         address spender,
537         uint256 value
538     ) internal {
539         // safeApprove should only be called when setting an initial allowance,
540         // or when resetting it to zero. To increase and decrease it, use
541         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
542         require(
543             (value == 0) || (token.allowance(address(this), spender) == 0),
544             "SafeERC20: approve from non-zero to non-zero allowance"
545         );
546         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
547     }
548 
549     function safeIncreaseAllowance(
550         IERC20 token,
551         address spender,
552         uint256 value
553     ) internal {
554         uint256 newAllowance = token.allowance(address(this), spender) + value;
555         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
556     }
557 
558     function safeDecreaseAllowance(
559         IERC20 token,
560         address spender,
561         uint256 value
562     ) internal {
563         unchecked {
564             uint256 oldAllowance = token.allowance(address(this), spender);
565             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
566             uint256 newAllowance = oldAllowance - value;
567             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
568         }
569     }
570 
571     /**
572      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
573      * on the return value: the return value is optional (but if data is returned, it must not be false).
574      * @param token The token targeted by the call.
575      * @param data The call data (encoded using abi.encode or one of its variants).
576      */
577     function _callOptionalReturn(IERC20 token, bytes memory data) private {
578         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
579         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
580         // the target address contains contract code and also asserts for success in the low-level call.
581 
582         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
583         if (returndata.length > 0) {
584             // Return data is optional
585             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
586         }
587     }
588 }
589 
590 interface IWUSD is IERC20 {
591     function mint(address account, uint256 amount) external;
592     function burn(address account, uint256 amount) external;
593 }
594 
595 interface IWswapRouter {
596     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
597         uint amountIn,
598         uint amountOutMin,
599         address[] calldata path,
600         address to,
601         uint deadline
602     ) external;
603 }
604 
605 contract WUSDMaster is Ownable, Withdrawable, ReentrancyGuard {
606     using SafeERC20 for IERC20;
607     
608     IWUSD public immutable wusd;
609     IERC20 public usdt;
610     IERC20 public wex;
611     IWswapRouter public immutable wswapRouter;
612     address public treasury;
613     address public strategist;
614     
615     address[] public swapPath;
616     
617     uint public wexPermille = 100;
618     uint public treasuryPermille = 7;
619     uint public feePermille = 0;
620     
621     uint256 public maxStakeAmount;
622     
623     event Stake(address indexed user, uint256 amount);
624     event Redeem(address indexed user, uint256 amount);
625     event UsdtWithdrawn(uint256 amount);
626     event WexWithdrawn(uint256 amount);
627     event SwapPathChanged(address[] swapPath);
628     event WexPermilleChanged(uint256 wexPermille);
629     event TreasuryPermilleChanged(uint256 treasuryPermille);
630     event FeePermilleChanged(uint256 feePermille);
631     event TreasuryAddressChanged(address treasury);
632     event StrategistAddressChanged(address strategist);
633     event MaxStakeAmountChanged(uint256 maxStakeAmount);
634     
635     constructor(IWUSD _wusd, IERC20 _usdt, IERC20 _wex, IWswapRouter _wswapRouter, address _treasury, uint256 _maxStakeAmount) {
636         require(
637             address(_wusd) != address(0) &&
638             address(_usdt) != address(0) &&
639             address(_wex) != address(0) &&
640             address(_wswapRouter) != address(0) &&
641             _treasury != address(0),
642             "zero address in constructor"
643         );
644         wusd = _wusd;
645         usdt = _usdt;
646         wex = _wex;
647         wswapRouter = _wswapRouter;
648         treasury = _treasury;
649         swapPath = [address(usdt), address(wex)];
650         maxStakeAmount = _maxStakeAmount;
651     }
652     
653     function setSwapPath(address[] calldata _swapPath) external onlyOwner {
654         swapPath = _swapPath;
655         
656         emit SwapPathChanged(swapPath);
657     }
658     
659     function setWexPermille(uint _wexPermille) external onlyOwner {
660         require(_wexPermille <= 500, 'wexPermille too high!');
661         wexPermille = _wexPermille;
662         
663         emit WexPermilleChanged(wexPermille);
664     }
665     
666     function setTreasuryPermille(uint _treasuryPermille) external onlyOwner {
667         require(_treasuryPermille <= 50, 'treasuryPermille too high!');
668         treasuryPermille = _treasuryPermille;
669         
670         emit TreasuryPermilleChanged(treasuryPermille);
671     }
672     
673     function setFeePermille(uint _feePermille) external onlyOwner {
674         require(_feePermille <= 20, 'feePermille too high!');
675         feePermille = _feePermille;
676         
677         emit FeePermilleChanged(feePermille);
678     }
679     
680     function setTreasuryAddress(address _treasury) external onlyOwner {
681         treasury = _treasury;
682         
683         emit TreasuryAddressChanged(treasury);
684     }
685     
686     function setStrategistAddress(address _strategist) external onlyOwner {
687         strategist = _strategist;
688         
689         emit StrategistAddressChanged(strategist);
690     }
691     
692     function setMaxStakeAmount(uint256 _maxStakeAmount) external onlyOwner {
693         maxStakeAmount = _maxStakeAmount;
694         
695         emit MaxStakeAmountChanged(maxStakeAmount);
696     }
697     
698     function stake(uint256 amount) external nonReentrant {
699         require(amount <= maxStakeAmount, 'amount too high');
700         usdt.safeTransferFrom(msg.sender, address(this), amount);
701         if(feePermille > 0) {
702             uint256 feeAmount = amount * feePermille / 1000;
703             usdt.safeTransfer(treasury, feeAmount);
704             amount = amount - feeAmount;
705         }
706         uint256 wexAmount = amount * wexPermille / 1000;
707         usdt.approve(address(wswapRouter), wexAmount);
708         wswapRouter.swapExactTokensForTokensSupportingFeeOnTransferTokens(
709             wexAmount,
710             0,
711             swapPath,
712             address(this),
713             block.timestamp
714         );
715         wusd.mint(msg.sender, amount);
716         
717         emit Stake(msg.sender, amount);
718     }
719     
720     function redeem(uint256 amount) external nonReentrant {
721         uint256 usdtTransferAmount = amount * (1000 - wexPermille - treasuryPermille) / 1000;
722         uint256 usdtTreasuryAmount = amount * treasuryPermille / 1000;
723         uint256 wexTransferAmount = wex.balanceOf(address(this)) * amount / wusd.totalSupply();
724         wusd.burn(msg.sender, amount);
725         usdt.safeTransfer(treasury, usdtTreasuryAmount);
726         usdt.safeTransfer(msg.sender, usdtTransferAmount);
727         wex.safeTransfer(msg.sender, wexTransferAmount);
728         
729         emit Redeem(msg.sender, amount);
730     }
731     
732     function withdrawUsdt(uint256 amount) external onlyOwner {
733         require(strategist != address(0), 'strategist not set');
734         usdt.safeTransfer(strategist, amount);
735         
736         emit UsdtWithdrawn(amount);
737     }
738     
739     function withdrawWex(uint256 amount) external onlyWithdrawer {
740         wex.safeTransfer(msg.sender, amount);
741         
742         emit WexWithdrawn(amount);
743     }
744 }