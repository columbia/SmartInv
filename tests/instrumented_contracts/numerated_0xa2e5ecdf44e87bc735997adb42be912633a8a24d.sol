1 // File: @openzeppelin/contracts/utils/Address.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.9.0) (utils/Address.sol)
5 
6 pragma solidity ^0.8.1;
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
27      *
28      * Furthermore, `isContract` will also return true if the target contract within
29      * the same transaction is already scheduled for destruction by `SELFDESTRUCT`,
30      * which only has an effect at the end of a transaction.
31      * ====
32      *
33      * [IMPORTANT]
34      * ====
35      * You shouldn't rely on `isContract` to protect against flash loan attacks!
36      *
37      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
38      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
39      * constructor.
40      * ====
41      */
42     function isContract(address account) internal view returns (bool) {
43         // This method relies on extcodesize/address.code.length, which returns 0
44         // for contracts in construction, since the code is only stored at the end
45         // of the constructor execution.
46 
47         return account.code.length > 0;
48     }
49 
50     /**
51      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
52      * `recipient`, forwarding all available gas and reverting on errors.
53      *
54      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
55      * of certain opcodes, possibly making contracts go over the 2300 gas limit
56      * imposed by `transfer`, making them unable to receive funds via
57      * `transfer`. {sendValue} removes this limitation.
58      *
59      * https://consensys.net/diligence/blog/2019/09/stop-using-soliditys-transfer-now/[Learn more].
60      *
61      * IMPORTANT: because control is transferred to `recipient`, care must be
62      * taken to not create reentrancy vulnerabilities. Consider using
63      * {ReentrancyGuard} or the
64      * https://solidity.readthedocs.io/en/v0.8.0/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
65      */
66     function sendValue(address payable recipient, uint256 amount) internal {
67         require(address(this).balance >= amount, "Address: insufficient balance");
68 
69         (bool success, ) = recipient.call{value: amount}("");
70         require(success, "Address: unable to send value, recipient may have reverted");
71     }
72 
73     /**
74      * @dev Performs a Solidity function call using a low level `call`. A
75      * plain `call` is an unsafe replacement for a function call: use this
76      * function instead.
77      *
78      * If `target` reverts with a revert reason, it is bubbled up by this
79      * function (like regular Solidity function calls).
80      *
81      * Returns the raw returned data. To convert to the expected return value,
82      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
83      *
84      * Requirements:
85      *
86      * - `target` must be a contract.
87      * - calling `target` with `data` must not revert.
88      *
89      * _Available since v3.1._
90      */
91     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
92         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
93     }
94 
95     /**
96      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
97      * `errorMessage` as a fallback revert reason when `target` reverts.
98      *
99      * _Available since v3.1._
100      */
101     function functionCall(
102         address target,
103         bytes memory data,
104         string memory errorMessage
105     ) internal returns (bytes memory) {
106         return functionCallWithValue(target, data, 0, errorMessage);
107     }
108 
109     /**
110      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
111      * but also transferring `value` wei to `target`.
112      *
113      * Requirements:
114      *
115      * - the calling contract must have an ETH balance of at least `value`.
116      * - the called Solidity function must be `payable`.
117      *
118      * _Available since v3.1._
119      */
120     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
121         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
122     }
123 
124     /**
125      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
126      * with `errorMessage` as a fallback revert reason when `target` reverts.
127      *
128      * _Available since v3.1._
129      */
130     function functionCallWithValue(
131         address target,
132         bytes memory data,
133         uint256 value,
134         string memory errorMessage
135     ) internal returns (bytes memory) {
136         require(address(this).balance >= value, "Address: insufficient balance for call");
137         (bool success, bytes memory returndata) = target.call{value: value}(data);
138         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
139     }
140 
141     /**
142      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
143      * but performing a static call.
144      *
145      * _Available since v3.3._
146      */
147     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
148         return functionStaticCall(target, data, "Address: low-level static call failed");
149     }
150 
151     /**
152      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
153      * but performing a static call.
154      *
155      * _Available since v3.3._
156      */
157     function functionStaticCall(
158         address target,
159         bytes memory data,
160         string memory errorMessage
161     ) internal view returns (bytes memory) {
162         (bool success, bytes memory returndata) = target.staticcall(data);
163         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
164     }
165 
166     /**
167      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
168      * but performing a delegate call.
169      *
170      * _Available since v3.4._
171      */
172     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
173         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
174     }
175 
176     /**
177      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
178      * but performing a delegate call.
179      *
180      * _Available since v3.4._
181      */
182     function functionDelegateCall(
183         address target,
184         bytes memory data,
185         string memory errorMessage
186     ) internal returns (bytes memory) {
187         (bool success, bytes memory returndata) = target.delegatecall(data);
188         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
189     }
190 
191     /**
192      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
193      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
194      *
195      * _Available since v4.8._
196      */
197     function verifyCallResultFromTarget(
198         address target,
199         bool success,
200         bytes memory returndata,
201         string memory errorMessage
202     ) internal view returns (bytes memory) {
203         if (success) {
204             if (returndata.length == 0) {
205                 // only check isContract if the call was successful and the return data is empty
206                 // otherwise we already know that it was a contract
207                 require(isContract(target), "Address: call to non-contract");
208             }
209             return returndata;
210         } else {
211             _revert(returndata, errorMessage);
212         }
213     }
214 
215     /**
216      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
217      * revert reason or using the provided one.
218      *
219      * _Available since v4.3._
220      */
221     function verifyCallResult(
222         bool success,
223         bytes memory returndata,
224         string memory errorMessage
225     ) internal pure returns (bytes memory) {
226         if (success) {
227             return returndata;
228         } else {
229             _revert(returndata, errorMessage);
230         }
231     }
232 
233     function _revert(bytes memory returndata, string memory errorMessage) private pure {
234         // Look for revert reason and bubble it up if present
235         if (returndata.length > 0) {
236             // The easiest way to bubble the revert reason is using memory via assembly
237             /// @solidity memory-safe-assembly
238             assembly {
239                 let returndata_size := mload(returndata)
240                 revert(add(32, returndata), returndata_size)
241             }
242         } else {
243             revert(errorMessage);
244         }
245     }
246 }
247 
248 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
249 
250 
251 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)
252 
253 pragma solidity ^0.8.0;
254 
255 /**
256  * @dev Interface of the ERC20 standard as defined in the EIP.
257  */
258 interface IERC20 {
259     /**
260      * @dev Emitted when `value` tokens are moved from one account (`from`) to
261      * another (`to`).
262      *
263      * Note that `value` may be zero.
264      */
265     event Transfer(address indexed from, address indexed to, uint256 value);
266 
267     /**
268      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
269      * a call to {approve}. `value` is the new allowance.
270      */
271     event Approval(address indexed owner, address indexed spender, uint256 value);
272 
273     /**
274      * @dev Returns the amount of tokens in existence.
275      */
276     function totalSupply() external view returns (uint256);
277 
278     /**
279      * @dev Returns the amount of tokens owned by `account`.
280      */
281     function balanceOf(address account) external view returns (uint256);
282 
283     /**
284      * @dev Moves `amount` tokens from the caller's account to `to`.
285      *
286      * Returns a boolean value indicating whether the operation succeeded.
287      *
288      * Emits a {Transfer} event.
289      */
290     function transfer(address to, uint256 amount) external returns (bool);
291 
292     /**
293      * @dev Returns the remaining number of tokens that `spender` will be
294      * allowed to spend on behalf of `owner` through {transferFrom}. This is
295      * zero by default.
296      *
297      * This value changes when {approve} or {transferFrom} are called.
298      */
299     function allowance(address owner, address spender) external view returns (uint256);
300 
301     /**
302      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
303      *
304      * Returns a boolean value indicating whether the operation succeeded.
305      *
306      * IMPORTANT: Beware that changing an allowance with this method brings the risk
307      * that someone may use both the old and the new allowance by unfortunate
308      * transaction ordering. One possible solution to mitigate this race
309      * condition is to first reduce the spender's allowance to 0 and set the
310      * desired value afterwards:
311      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
312      *
313      * Emits an {Approval} event.
314      */
315     function approve(address spender, uint256 amount) external returns (bool);
316 
317     /**
318      * @dev Moves `amount` tokens from `from` to `to` using the
319      * allowance mechanism. `amount` is then deducted from the caller's
320      * allowance.
321      *
322      * Returns a boolean value indicating whether the operation succeeded.
323      *
324      * Emits a {Transfer} event.
325      */
326     function transferFrom(address from, address to, uint256 amount) external returns (bool);
327 }
328 
329 // File: @openzeppelin/contracts/utils/Context.sol
330 
331 
332 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
333 
334 pragma solidity ^0.8.0;
335 
336 /**
337  * @dev Provides information about the current execution context, including the
338  * sender of the transaction and its data. While these are generally available
339  * via msg.sender and msg.data, they should not be accessed in such a direct
340  * manner, since when dealing with meta-transactions the account sending and
341  * paying for execution may not be the actual sender (as far as an application
342  * is concerned).
343  *
344  * This contract is only required for intermediate, library-like contracts.
345  */
346 abstract contract Context {
347     function _msgSender() internal view virtual returns (address) {
348         return msg.sender;
349     }
350 
351     function _msgData() internal view virtual returns (bytes calldata) {
352         return msg.data;
353     }
354 }
355 
356 // File: @openzeppelin/contracts/access/Ownable.sol
357 
358 
359 // OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)
360 
361 pragma solidity ^0.8.0;
362 
363 
364 /**
365  * @dev Contract module which provides a basic access control mechanism, where
366  * there is an account (an owner) that can be granted exclusive access to
367  * specific functions.
368  *
369  * By default, the owner account will be the one that deploys the contract. This
370  * can later be changed with {transferOwnership}.
371  *
372  * This module is used through inheritance. It will make available the modifier
373  * `onlyOwner`, which can be applied to your functions to restrict their use to
374  * the owner.
375  */
376 abstract contract Ownable is Context {
377     address private _owner;
378 
379     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
380 
381     /**
382      * @dev Initializes the contract setting the deployer as the initial owner.
383      */
384     constructor() {
385         _transferOwnership(_msgSender());
386     }
387 
388     /**
389      * @dev Throws if called by any account other than the owner.
390      */
391     modifier onlyOwner() {
392         _checkOwner();
393         _;
394     }
395 
396     /**
397      * @dev Returns the address of the current owner.
398      */
399     function owner() public view virtual returns (address) {
400         return _owner;
401     }
402 
403     /**
404      * @dev Throws if the sender is not the owner.
405      */
406     function _checkOwner() internal view virtual {
407         require(owner() == _msgSender(), "Ownable: caller is not the owner");
408     }
409 
410     /**
411      * @dev Leaves the contract without owner. It will not be possible to call
412      * `onlyOwner` functions. Can only be called by the current owner.
413      *
414      * NOTE: Renouncing ownership will leave the contract without an owner,
415      * thereby disabling any functionality that is only available to the owner.
416      */
417     function renounceOwnership() public virtual onlyOwner {
418         _transferOwnership(address(0));
419     }
420 
421     /**
422      * @dev Transfers ownership of the contract to a new account (`newOwner`).
423      * Can only be called by the current owner.
424      */
425     function transferOwnership(address newOwner) public virtual onlyOwner {
426         require(newOwner != address(0), "Ownable: new owner is the zero address");
427         _transferOwnership(newOwner);
428     }
429 
430     /**
431      * @dev Transfers ownership of the contract to a new account (`newOwner`).
432      * Internal function without access restriction.
433      */
434     function _transferOwnership(address newOwner) internal virtual {
435         address oldOwner = _owner;
436         _owner = newOwner;
437         emit OwnershipTransferred(oldOwner, newOwner);
438     }
439 }
440 
441 // File: Supernova.sol
442 
443 
444 
445 /*
446 Supernova features groundbreaking tokenomics that ensure stability through dynamic taxes, blackhole burns, and reflections.
447 
448 https://www.supernovatoken.net/
449 https://twitter.com/supernova_erc
450 https://t.me/supernovatoken
451 https://coinmarketcap.com/community/profile/SupernovaToken/
452 https://supernovatoken.gitbook.io/introduction-to-supernova/
453 */
454 
455 pragma solidity 0.8.19;
456 
457 
458 
459 
460 interface IFactory{
461         function createPair(address tokenA, address tokenB) external returns (address pair);
462 }
463  
464 interface IRouter {
465     function factory() external pure returns (address);
466     function WETH() external pure returns (address);
467     function swapExactTokensForETHSupportingFeeOnTransferTokens(
468         uint amountIn,
469         uint amountOutMin,
470         address[] calldata path,
471         address to,
472         uint deadline) external;
473     function addLiquidityETH(
474         address token,
475         uint amountTokenDesired,
476         uint amountTokenMin,
477         uint amountETHMin,
478         address to,
479         uint deadline
480     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
481 }
482  
483 contract Supernova is IERC20, Ownable {
484     using Address for address payable;
485  
486     mapping (address => uint256) private _rOwned;
487     mapping (address => uint256) private _tOwned;
488     mapping (address => uint256) public normalBalance;
489     mapping (address => mapping (address => uint256)) private _allowances;
490     mapping (address => bool) private _isExcludedFromFee;
491     mapping (address => bool) private _isExcluded;
492  
493     address[] private _excluded;
494  
495     bool public swapEnabled;
496     bool private swapping;
497     bool public tradingEnabled;
498  
499     IRouter public router;
500     address public pair;
501     address public devWallet;
502     address public buybackWallet;
503  
504     uint8 private constant _decimals = 18;
505     uint256 private constant MAX = ~uint256(0);
506  
507     uint256 private _tTotal = 1_000_000_000 * 10**_decimals;
508     uint256 private _rTotal = (MAX - (MAX % _tTotal));
509  
510     uint256 public totalRfi;
511     uint256 public swapThreshold = 500_000 * 10**_decimals;
512     uint256 public constant MAX_TX_AMOUNT = 20_000_000 * 10**_decimals; // can't be changed
513     uint256 public constant MAX_WALLET_AMOUNT = 20_000_000 * 10**_decimals; // can't be changed
514     uint256 public buyThreshold = 1_000_000 * 10**_decimals;
515     uint256 public startBlock;
516     uint256 public offlineBlocks = 5;
517  
518     uint256 public buyTax = 150; // 15%
519     uint256 public sellTax = 200; // 20%
520     uint256 public dynamicTax = 20; // 2%
521     uint256 public constant MAX_SELL_TAX = 200; // 20%
522  
523     string private constant _name = "Supernova";
524     string private constant _symbol = "NOVA";
525  
526     struct TaxesPercentage {
527       uint256 rfi;
528       uint256 dev;
529       uint256 buyBack;
530       uint256 lp;
531     }
532  
533     TaxesPercentage public taxesPercentage = TaxesPercentage(35,30,30,5);
534  
535     struct valuesFromGetValues{
536       uint256 rAmount;
537       uint256 rTransferAmount;
538       uint256 rRfi;
539       uint256 rSwap;
540       uint256 tTransferAmount;
541       uint256 tRfi;
542       uint256 tSwap;
543     }
544  
545  
546     modifier lockTheSwap {
547         swapping = true;
548         _;
549         swapping = false;
550     }
551  
552     constructor (address _routerAddress, address _devWallet, address _buybackWallet) {
553  
554         IRouter _router = IRouter(_routerAddress);
555         address _pair = IFactory(_router.factory())
556             .createPair(address(this), _router.WETH());
557  
558         router = _router;
559         pair = _pair;
560  
561         excludeFromReward(pair);
562  
563         _rOwned[msg.sender] = _rTotal;
564         normalBalance[msg.sender] = _tTotal;
565         _isExcludedFromFee[msg.sender] = true;
566         _isExcludedFromFee[address(this)] = true;
567         _isExcludedFromFee[_devWallet]=true;
568         _isExcludedFromFee[_buybackWallet] = true;
569  
570         devWallet = _devWallet;
571         buybackWallet = _buybackWallet;
572  
573         emit Transfer(address(0), msg.sender, _tTotal);
574     }
575  
576     function name() public pure returns (string memory) {
577         return _name;
578     }
579     function symbol() public pure returns (string memory) {
580         return _symbol;
581     }
582     function decimals() public pure returns (uint8) {
583         return _decimals;
584     }
585  
586     function totalSupply() public view override returns (uint256) {
587         return _tTotal;
588     }
589  
590     function balanceOf(address account) public view override returns (uint256) {
591         if (_isExcluded[account]) return _tOwned[account];
592         return tokenFromReflection(_rOwned[account]);
593     }
594  
595     function transfer(address recipient, uint256 amount) public override returns (bool) {
596         _transfer(_msgSender(), recipient, amount);
597         return true;
598     }
599  
600     function allowance(address owner, address spender) public view override returns (uint256) {
601         return _allowances[owner][spender];
602     }
603  
604     function approve(address spender, uint256 amount) public override returns (bool) {
605         _approve(_msgSender(), spender, amount);
606         return true;
607     }
608  
609     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
610         _transfer(sender, recipient, amount);
611  
612         uint256 currentAllowance = _allowances[sender][_msgSender()];
613         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
614         _approve(sender, _msgSender(), currentAllowance - amount);
615  
616         return true;
617     }
618  
619     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
620         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
621         return true;
622     }
623  
624     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
625         uint256 currentAllowance = _allowances[_msgSender()][spender];
626         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
627         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
628  
629         return true;
630     }
631  
632     function isExcludedFromReward(address account) public view returns (bool) {
633         return _isExcluded[account];
634     }
635  
636     function getCirculatingSupply() external view returns(uint256){
637         uint256 deadBalance = balanceOf(address(0xdead));
638         uint256 zeroBalance = balanceOf(address(0));
639         return totalSupply() - deadBalance - zeroBalance;
640     }
641  
642     function getTotAmountBurned() external view returns(uint256){
643         uint256 deadBalance = balanceOf(address(0xdead));
644         uint256 zeroBalance = balanceOf(address(0));
645         return deadBalance + zeroBalance;
646     }
647  
648     function getReflectionEarned(address user) external view returns(uint256) {
649         if(balanceOf(user) >= normalBalance[user]) return balanceOf(user) - normalBalance[user];
650         else return 0;
651     }
652  
653     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
654         require(rAmount <= _rTotal, "Amount must be less than total reflections");
655         uint256 currentRate =  _getRate();
656         return rAmount/currentRate;
657     }
658  
659     function excludeFromReward(address account) public onlyOwner {
660         require(!_isExcluded[account], "Account is already excluded");
661         if(_rOwned[account] > 0) {
662             _tOwned[account] = tokenFromReflection(_rOwned[account]);
663         }
664         _isExcluded[account] = true;
665         _excluded.push(account);
666     }
667  
668     function includeInReward(address account) external onlyOwner {
669         require(_isExcluded[account], "Account is not excluded");
670         for (uint256 i = 0; i < _excluded.length; i++) {
671             if (_excluded[i] == account) {
672                 _excluded[i] = _excluded[_excluded.length - 1];
673                 _tOwned[account] = 0;
674                 _isExcluded[account] = false;
675                 _excluded.pop();
676                 break;
677             }
678         }
679     }
680  
681     function excludeFromFee(address account, bool status) public onlyOwner {
682         _isExcludedFromFee[account] = status;
683     }
684  
685     function isExcludedFromFee(address account) public view returns(bool) {
686         return _isExcludedFromFee[account];
687     }
688  
689     function setTaxesPercentage(uint256 _rfi, uint256 _dev, uint256 _buyback, uint256 _lp) public onlyOwner {
690         require(_rfi + _dev + _buyback + _lp == 100, "Total must be 100");
691         taxesPercentage = TaxesPercentage(_rfi, _dev, _buyback, _lp);
692     }
693  
694     function _reflectRfi(uint256 rRfi, uint256 tRfi) private {
695         _rTotal -=rRfi;
696         totalRfi +=tRfi;
697     }
698  
699     function _takeSwapFees(uint256 rValue, uint256 tValue) private {
700         if(_isExcluded[address(this)])
701         {
702             _tOwned[address(this)]+=tValue;
703         }
704         _rOwned[address(this)] +=rValue;
705     }
706  
707     function _getValues(uint256 tAmount, bool takeFee, bool isSell) private view returns (valuesFromGetValues memory to_return) {
708         to_return = _getTValues(tAmount, takeFee, isSell);
709         (to_return.rAmount, to_return.rTransferAmount, to_return.rRfi, to_return.rSwap) = _getRValues(to_return, tAmount, takeFee, _getRate());
710         return to_return;
711     }
712  
713     function _getTValues(uint256 tAmount, bool takeFee, bool isSell) private view returns (valuesFromGetValues memory s) {
714  
715         if(!takeFee) {
716           s.tTransferAmount = tAmount;
717           return s;
718         }
719  
720         uint256 tempTax = isSell ? sellTax : buyTax;
721         uint256 rfiTax = tempTax * taxesPercentage.rfi / 100;
722         uint256 swapTax = tempTax * (100 - taxesPercentage.rfi) / 100;
723         s.tRfi = tAmount * rfiTax / 1000;
724         s.tSwap = tAmount * swapTax / 1000;
725         s.tTransferAmount = tAmount - s.tRfi - s.tSwap;
726         return s;
727     }
728  
729     function _getRValues(valuesFromGetValues memory s, uint256 tAmount, bool takeFee, uint256 currentRate) private pure returns (uint256 rAmount, uint256 rTransferAmount, uint256 rRfi, uint256 rSwap) {
730         rAmount = tAmount*currentRate;
731  
732         if(!takeFee) {
733           return(rAmount, rAmount, 0,0);
734         }
735  
736         rRfi = s.tRfi*currentRate;
737         rSwap = s.tSwap*currentRate;
738         rTransferAmount =  rAmount-rRfi-rSwap;
739         return (rAmount, rTransferAmount, rRfi,rSwap);
740     }
741  
742     function _getRate() private view returns(uint256) {
743         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
744         return rSupply/tSupply;
745     }
746  
747     function _getCurrentSupply() private view returns(uint256, uint256) {
748         uint256 rSupply = _rTotal;
749         uint256 tSupply = _tTotal;
750         for (uint256 i = 0; i < _excluded.length; i++) {
751             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
752             rSupply = rSupply-_rOwned[_excluded[i]];
753             tSupply = tSupply-_tOwned[_excluded[i]];
754         }
755         if (rSupply < _rTotal/_tTotal) return (_rTotal, _tTotal);
756         return (rSupply, tSupply);
757     }
758  
759     function _approve(address owner, address spender, uint256 amount) private {
760         require(owner != address(0), "ERC20: approve from the zero address");
761         require(spender != address(0), "ERC20: approve to the zero address");
762         _allowances[owner][spender] = amount;
763         emit Approval(owner, spender, amount);
764     }
765  
766  
767     function _transfer(address from, address to, uint256 amount) private {
768         require(from != address(0), "ERC20: transfer from the zero address");
769         require(amount > 0, "Transfer amount must be greater than zero");
770         require(amount <= balanceOf(from),"You are trying to transfer more than your balance");
771  
772         if(buyTax != 10 && tradingEnabled){
773             if(startBlock + offlineBlocks < block.number) buyTax = 10;
774         }
775  
776         bool takeFee = false;
777  
778         if(!_isExcludedFromFee[from] && !_isExcludedFromFee[to]){
779             require(tradingEnabled ,"Liquidity has not been added yet");
780             require(amount <= MAX_TX_AMOUNT, "You are exceeding MAX_TX_AMOUNT");
781             if(to != pair) require(balanceOf(to) + amount <= MAX_WALLET_AMOUNT, "You are exceeding MAX_WALLET_AMOUNT");
782             takeFee = true;
783             if(from == pair && startBlock + offlineBlocks < block.number){
784                 if(amount >= buyThreshold){
785                     if(sellTax >= dynamicTax) sellTax -= dynamicTax;
786                     else sellTax = 0;
787                 }
788             }
789         }
790  
791         bool canSwap = balanceOf(address(this)) >= swapThreshold;
792         if(!swapping && taxesPercentage.rfi != 100 && swapEnabled && canSwap && from != pair && takeFee){
793             swapAndLiquify(swapThreshold);
794         }
795  
796         _tokenTransfer(from, to, amount, takeFee);
797     }
798  
799  
800     //this method is responsible for taking all fee, if takeFee is true
801     function _tokenTransfer(address sender, address recipient, uint256 tAmount, bool takeFee) private {
802  
803         bool isSell = recipient == pair ? true : false;
804         valuesFromGetValues memory s = _getValues(tAmount, takeFee, isSell);
805  
806         if(isSell && takeFee && startBlock + offlineBlocks < block.number){
807             if(sellTax + dynamicTax > MAX_SELL_TAX) sellTax = MAX_SELL_TAX;
808             else sellTax += dynamicTax;
809         }
810  
811         if (_isExcluded[sender] ) {  //from excluded
812                 _tOwned[sender] = _tOwned[sender]-tAmount;
813         }
814         if (_isExcluded[recipient]) { //to excluded
815                 _tOwned[recipient] = _tOwned[recipient]+s.tTransferAmount;
816         }
817  
818         _rOwned[sender] = _rOwned[sender]-s.rAmount;
819         _rOwned[recipient] = _rOwned[recipient]+s.rTransferAmount;
820         normalBalance[recipient] += s.tTransferAmount;
821         normalBalance[sender] -= s.tTransferAmount;
822         normalBalance[address(this)] += s.tSwap;
823  
824         if(s.rRfi > 0 || s.tRfi > 0) _reflectRfi(s.rRfi, s.tRfi);
825         if(s.rSwap > 0 || s.tSwap > 0) _takeSwapFees(s.rSwap, s.tSwap);
826  
827  
828         emit Transfer(sender, recipient, s.tTransferAmount);
829         if(s.tSwap > 0) emit Transfer(sender, address(this), s.tSwap);
830  
831     }
832  
833     function swapAndLiquify(uint256 tokens) private lockTheSwap{
834         uint256 denominator = (100 - taxesPercentage.rfi) * 2;
835         uint256 tokensToAddLiquidityWith = tokens * taxesPercentage.lp / denominator;
836         uint256 toSwap = tokens - tokensToAddLiquidityWith;
837  
838         uint256 initialBalance = address(this).balance;
839  
840         swapTokensForETH(toSwap);
841  
842         uint256 deltaBalance = address(this).balance - initialBalance;
843         uint256 unitBalance= deltaBalance / (denominator - taxesPercentage.lp);
844         uint256 ethToAddLiquidityWith = unitBalance * taxesPercentage.lp;
845  
846         if(ethToAddLiquidityWith > 0){
847             // Add liquidity to uniswap
848             addLiquidity(tokensToAddLiquidityWith, ethToAddLiquidityWith);
849         }
850  
851         uint256 devAmt = unitBalance * 2 * taxesPercentage.dev;
852         if(devAmt > 0){
853             payable(devWallet).sendValue(devAmt);
854         }
855  
856         uint256 buybackAmt = unitBalance * 2 * taxesPercentage.buyBack;
857         if(buybackAmt > 0){
858             payable(buybackWallet).sendValue(buybackAmt);
859         }
860     }
861  
862     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
863         // approve token transfer to cover all possible scenarios
864         _approve(address(this), address(router), tokenAmount);
865  
866         // add the liquidity
867         router.addLiquidityETH{value: ethAmount}(
868             address(this),
869             tokenAmount,
870             0, // slippage is unavoidable
871             0, // slippage is unavoidable
872             devWallet,
873             block.timestamp
874         );
875     }
876  
877     function swapTokensForETH(uint256 tokenAmount) private {
878         // generate the uniswap pair path of token -> weth
879         address[] memory path = new address[](2);
880         path[0] = address(this);
881         path[1] = router.WETH();
882  
883         _approve(address(this), address(router), tokenAmount);
884  
885         // make the swap
886         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
887             tokenAmount,
888             0, // accept any amount of ETH
889             path,
890             address(this),
891             block.timestamp
892         );
893     }
894  
895     function enableTrading() external onlyOwner{
896         require(!tradingEnabled, "Already live");
897         tradingEnabled = true;
898         swapEnabled = true;
899         startBlock = block.number;
900     }
901  
902     function updateDevWallet(address newWallet) external onlyOwner{
903         devWallet = newWallet;
904         _isExcludedFromFee[devWallet] = true;
905     }
906  
907     function updateBuybackWallet(address newWallet) external onlyOwner{
908         buybackWallet = newWallet;
909         _isExcludedFromFee[buybackWallet] = true;
910     }
911  
912     function updateBuyThreshold(uint256 amount) external onlyOwner{
913         buyThreshold = amount * 10**_decimals;
914     }
915  
916     function updateSwapThreshold(uint256 amount) external onlyOwner{
917         swapThreshold = amount * 10**_decimals;
918     }
919  
920     function updateSwapEnabled(bool _enabled) external onlyOwner{
921         swapEnabled = _enabled;
922     }
923  
924     function updateRouterAndPair(address newRouter, address newPair) external onlyOwner{
925         router = IRouter(newRouter);
926         pair = newPair;
927     }
928  
929     function updateDynamicTax(uint256 amount) external onlyOwner{
930         dynamicTax = amount;
931     }
932  
933     function rescueETH(uint256 weiAmount) external onlyOwner{
934         payable(msg.sender).transfer(weiAmount);
935     }
936  
937     function rescueTokens(address _tokenAddr, address _to, uint _amount) external onlyOwner {
938         IERC20(_tokenAddr).transfer(_to, _amount);
939     }
940  
941     receive() external payable{
942     }
943 }