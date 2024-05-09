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
441 // File: moontopia.sol
442 
443 
444 pragma solidity 0.8.19;
445 
446 
447 
448  
449 interface IFactory{
450         function createPair(address tokenA, address tokenB) external returns (address pair);
451 }
452  
453 interface IRouter {
454     function factory() external pure returns (address);
455     function WETH() external pure returns (address);
456     function swapExactTokensForETHSupportingFeeOnTransferTokens(
457         uint amountIn,
458         uint amountOutMin,
459         address[] calldata path,
460         address to,
461         uint deadline) external;
462 }
463  
464  
465 contract Moontopia is IERC20, Ownable {
466     using Address for address payable;
467  
468     mapping (address => uint256) private _rOwned;
469     mapping (address => uint256) private _tOwned;
470     mapping (address => mapping (address => uint256)) private _allowances;
471     mapping (address => bool) private _isExcludedFromFee;
472     mapping (address => bool) private _isExcluded;
473  
474     address[] private _excluded;
475  
476     bool public swapEnabled;
477     bool private swapping;
478     bool public tradingEnabled;
479  
480     IRouter public router;
481     address public pair;
482     address public devWallet;
483     address public buybackWallet;
484  
485     uint8 private constant _decimals = 18;
486     uint256 private constant MAX = ~uint256(0);
487  
488     uint256 private _tTotal = 1_000_000_000 * 10**_decimals;
489     uint256 private _rTotal = (MAX - (MAX % _tTotal));
490  
491     uint256 public totalRfi;
492     uint256 public swapThreshold = 2_000_000 * 10**_decimals;
493     uint256 public maxTxAmount = 20_000_000 * 10**_decimals;
494     uint256 public maxWalletAmount = 20_000_000 * 10**_decimals;
495     uint256 public buyThreshold = 1_000_000 * 10**_decimals;
496     uint256 public startBlock;
497     uint256 public offlineBlocks = 5;
498  
499     uint256 public buyTax = 150; // 15% - For First 5 Blocks
500     uint256 public sellTax = 200; // 20%
501     uint256 public dynamicTax = 20; // 2%
502     uint256 public maxSellTax = 200; // 20%
503  
504     string private constant _name = "Moontopia";
505     string private constant _symbol = "TOPIA";
506  
507     struct TaxesPercentage {
508       uint256 rfi;
509       uint256 dev;
510       uint256 buyBack;
511     }
512  
513     TaxesPercentage public taxesPercentage = TaxesPercentage(35,30,35);
514  
515     struct valuesFromGetValues{
516       uint256 rAmount;
517       uint256 rTransferAmount;
518       uint256 rRfi;
519       uint256 rSwap;
520       uint256 tTransferAmount;
521       uint256 tRfi;
522       uint256 tSwap;
523     }
524  
525  
526     modifier lockTheSwap {
527         swapping = true;
528         _;
529         swapping = false;
530     }
531  
532     constructor (address _routerAddress, address _devWallet, address _buybackWallet) {
533  
534         IRouter _router = IRouter(_routerAddress);
535         address _pair = IFactory(_router.factory())
536             .createPair(address(this), _router.WETH());
537  
538         router = _router;
539         pair = _pair;
540  
541         excludeFromReward(pair);
542         excludeFromReward(address(0xdead));
543  
544         _rOwned[msg.sender] = _rTotal;
545         _isExcludedFromFee[msg.sender] = true;
546         _isExcludedFromFee[address(this)] = true;
547         _isExcludedFromFee[_devWallet]=true;
548         _isExcludedFromFee[_buybackWallet] = true;
549  
550         devWallet = _devWallet;
551         buybackWallet = _buybackWallet;
552  
553         emit Transfer(address(0), msg.sender, _tTotal);
554     }
555  
556     function name() public pure returns (string memory) {
557         return _name;
558     }
559     function symbol() public pure returns (string memory) {
560         return _symbol;
561     }
562     function decimals() public pure returns (uint8) {
563         return _decimals;
564     }
565  
566     function totalSupply() public view override returns (uint256) {
567         return _tTotal;
568     }
569  
570     function balanceOf(address account) public view override returns (uint256) {
571         if (_isExcluded[account]) return _tOwned[account];
572         return tokenFromReflection(_rOwned[account]);
573     }
574  
575     function transfer(address recipient, uint256 amount) public override returns (bool) {
576         _transfer(_msgSender(), recipient, amount);
577         return true;
578     }
579  
580     function allowance(address owner, address spender) public view override returns (uint256) {
581         return _allowances[owner][spender];
582     }
583  
584     function approve(address spender, uint256 amount) public override returns (bool) {
585         _approve(_msgSender(), spender, amount);
586         return true;
587     }
588  
589     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
590         _transfer(sender, recipient, amount);
591  
592         uint256 currentAllowance = _allowances[sender][_msgSender()];
593         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
594         _approve(sender, _msgSender(), currentAllowance - amount);
595  
596         return true;
597     }
598  
599     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
600         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
601         return true;
602     }
603  
604     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
605         uint256 currentAllowance = _allowances[_msgSender()][spender];
606         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
607         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
608  
609         return true;
610     }
611  
612     function isExcludedFromReward(address account) public view returns (bool) {
613         return _isExcluded[account];
614     }
615  
616     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
617         require(rAmount <= _rTotal, "Amount must be less than total reflections");
618         uint256 currentRate =  _getRate();
619         return rAmount/currentRate;
620     }
621  
622     function excludeFromReward(address account) public onlyOwner {
623         require(!_isExcluded[account], "Account is already excluded");
624         if(_rOwned[account] > 0) {
625             _tOwned[account] = tokenFromReflection(_rOwned[account]);
626         }
627         _isExcluded[account] = true;
628         _excluded.push(account);
629     }
630  
631     function includeInReward(address account) external onlyOwner {
632         require(_isExcluded[account], "Account is not excluded");
633         for (uint256 i = 0; i < _excluded.length; i++) {
634             if (_excluded[i] == account) {
635                 _excluded[i] = _excluded[_excluded.length - 1];
636                 _tOwned[account] = 0;
637                 _isExcluded[account] = false;
638                 _excluded.pop();
639                 break;
640             }
641         }
642     }
643  
644     function excludeFromFee(address account, bool status) public onlyOwner {
645         _isExcludedFromFee[account] = status;
646     }
647  
648     function isExcludedFromFee(address account) public view returns(bool) {
649         return _isExcludedFromFee[account];
650     }
651  
652     function setTaxesPercentage(uint256 _rfi, uint256 _dev, uint256 _buyback) public onlyOwner {
653         require(_rfi + _dev + _buyback == 100, "Total must be 100");
654         taxesPercentage = TaxesPercentage(_rfi, _dev, _buyback);
655     }
656  
657     function _reflectRfi(uint256 rRfi, uint256 tRfi) private {
658         _rTotal -=rRfi;
659         totalRfi +=tRfi;
660     }
661  
662     function _takeSwapFees(uint256 rValue, uint256 tValue) private {
663         if(_isExcluded[address(this)])
664         {
665             _tOwned[address(this)]+=tValue;
666         }
667         _rOwned[address(this)] +=rValue;
668     }
669  
670     function _getValues(uint256 tAmount, bool takeFee, bool isSell) private view returns (valuesFromGetValues memory to_return) {
671         to_return = _getTValues(tAmount, takeFee, isSell);
672         (to_return.rAmount, to_return.rTransferAmount, to_return.rRfi, to_return.rSwap) = _getRValues(to_return, tAmount, takeFee, _getRate());
673         return to_return;
674     }
675  
676     function _getTValues(uint256 tAmount, bool takeFee, bool isSell) private view returns (valuesFromGetValues memory s) {
677  
678         if(!takeFee) {
679           s.tTransferAmount = tAmount;
680           return s;
681         }
682  
683         uint256 tempTax = isSell ? sellTax : buyTax;
684         uint256 rfiTax = tempTax * taxesPercentage.rfi / 100;
685         uint256 swapTax = tempTax * (100 - taxesPercentage.rfi) / 100;
686         s.tRfi = tAmount * rfiTax / 1000;
687         s.tSwap = tAmount * swapTax / 1000;
688         s.tTransferAmount = tAmount - s.tRfi - s.tSwap;
689         return s;
690     }
691  
692     function _getRValues(valuesFromGetValues memory s, uint256 tAmount, bool takeFee, uint256 currentRate) private pure returns (uint256 rAmount, uint256 rTransferAmount, uint256 rRfi, uint256 rSwap) {
693         rAmount = tAmount*currentRate;
694  
695         if(!takeFee) {
696           return(rAmount, rAmount, 0,0);
697         }
698  
699         rRfi = s.tRfi*currentRate;
700         rSwap = s.tSwap*currentRate;
701         rTransferAmount =  rAmount-rRfi-rSwap;
702         return (rAmount, rTransferAmount, rRfi,rSwap);
703     }
704  
705     function _getRate() private view returns(uint256) {
706         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
707         return rSupply/tSupply;
708     }
709  
710     function _getCurrentSupply() private view returns(uint256, uint256) {
711         uint256 rSupply = _rTotal;
712         uint256 tSupply = _tTotal;
713         for (uint256 i = 0; i < _excluded.length; i++) {
714             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
715             rSupply = rSupply-_rOwned[_excluded[i]];
716             tSupply = tSupply-_tOwned[_excluded[i]];
717         }
718         if (rSupply < _rTotal/_tTotal) return (_rTotal, _tTotal);
719         return (rSupply, tSupply);
720     }
721  
722     function _approve(address owner, address spender, uint256 amount) private {
723         require(owner != address(0), "ERC20: approve from the zero address");
724         require(spender != address(0), "ERC20: approve to the zero address");
725         _allowances[owner][spender] = amount;
726         emit Approval(owner, spender, amount);
727     }
728  
729  
730     function _transfer(address from, address to, uint256 amount) private {
731         require(from != address(0), "ERC20: transfer from the zero address");
732         require(amount > 0, "Transfer amount must be greater than zero");
733         require(amount <= balanceOf(from),"You are trying to transfer more than your balance");
734  
735         if(buyTax != 0 && tradingEnabled){
736             if(startBlock + offlineBlocks < block.number) buyTax = 0;
737         }
738  
739         bool takeFee = false;
740  
741         if(!_isExcludedFromFee[from] && !_isExcludedFromFee[to]){
742             require(tradingEnabled ,"Liquidity has not been added yet");
743             require(amount <= maxTxAmount, "You are exceeding maxTxAmount");
744             if(to != pair) require(balanceOf(to) + amount <= maxWalletAmount, "You are exceeding maxWalletAmount");
745             takeFee = true;
746             if(from == pair && startBlock + offlineBlocks < block.number){
747                 takeFee = false;
748                 if(amount >= buyThreshold){
749                     if(sellTax >= dynamicTax) sellTax -= dynamicTax;
750                     else sellTax = 0;
751                 }
752             }
753         }
754  
755         bool canSwap = balanceOf(address(this)) >= swapThreshold;
756         if(!swapping && swapEnabled && canSwap && from != pair && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]){
757             swapTokensForFees(swapThreshold);
758         }
759  
760         _tokenTransfer(from, to, amount, takeFee);
761     }
762  
763  
764     //this method is responsible for taking all fee, if takeFee is true
765     function _tokenTransfer(address sender, address recipient, uint256 tAmount, bool takeFee) private {
766  
767         bool isSell = recipient == pair ? true : false;
768         valuesFromGetValues memory s = _getValues(tAmount, takeFee, isSell);
769  
770         if(isSell && takeFee && startBlock + offlineBlocks < block.number){
771             if(sellTax + dynamicTax > maxSellTax) sellTax = maxSellTax;
772             else sellTax += dynamicTax;
773         }
774  
775         if (_isExcluded[sender] ) {  //from excluded
776                 _tOwned[sender] = _tOwned[sender]-tAmount;
777         }
778         if (_isExcluded[recipient]) { //to excluded
779                 _tOwned[recipient] = _tOwned[recipient]+s.tTransferAmount;
780         }
781  
782         _rOwned[sender] = _rOwned[sender]-s.rAmount;
783         _rOwned[recipient] = _rOwned[recipient]+s.rTransferAmount;
784  
785         if(s.rRfi > 0 || s.tRfi > 0) _reflectRfi(s.rRfi, s.tRfi);
786         if(s.rSwap > 0 || s.tSwap > 0) _takeSwapFees(s.rSwap, s.tSwap);
787  
788         emit Transfer(sender, recipient, s.tTransferAmount);
789         emit Transfer(sender, address(this), s.tSwap);
790  
791     }
792  
793     function swapTokensForFees(uint256 tokens) private lockTheSwap{
794  
795         uint256 initialBalance = address(this).balance;
796  
797         swapTokensForETH(tokens);
798  
799         uint256 deltaBalance = address(this).balance - initialBalance;
800  
801         uint256 totalPercent = 100 - taxesPercentage.rfi;
802         if(totalPercent == 0) return;
803  
804         uint256 devAmt = deltaBalance * taxesPercentage.dev / totalPercent;
805         if(devAmt > 0) payable(devWallet).sendValue(devAmt);
806  
807         uint256 buybackAmt = deltaBalance - devAmt;
808         if(buybackAmt > 0) payable(buybackWallet).sendValue(buybackAmt);
809     }
810  
811     function swapTokensForETH(uint256 tokenAmount) private {
812         // generate the uniswap pair path of token -> weth
813         address[] memory path = new address[](2);
814         path[0] = address(this);
815         path[1] = router.WETH();
816  
817         _approve(address(this), address(router), tokenAmount);
818  
819         // make the swap
820         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
821             tokenAmount,
822             0, // accept any amount of ETH
823             path,
824             address(this),
825             block.timestamp
826         );
827     }
828  
829     function enableTrading() external onlyOwner{
830         tradingEnabled = true;
831         swapEnabled = true;
832         startBlock = block.number;
833     }
834  
835     function updateDevWallet(address newWallet) external onlyOwner{
836         devWallet = newWallet;
837         _isExcludedFromFee[devWallet] = true;
838     }
839  
840     function updateBuybackWallet(address newWallet) external onlyOwner{
841         buybackWallet = newWallet;
842         _isExcludedFromFee[buybackWallet] = true;
843     }
844  
845     function updateBuyThreshold(uint256 amount) external onlyOwner{
846         buyThreshold = amount * 10**_decimals;
847     }
848  
849     function updateMaxTx(uint256 amount) external onlyOwner{
850         maxTxAmount = amount * 10**_decimals;
851     }
852  
853     function updateMaxWallet(uint256 amount) external onlyOwner{
854         maxWalletAmount = amount * 10**_decimals;
855     }
856  
857     function updateSwapThreshold(uint256 amount) external onlyOwner{
858         swapThreshold = amount * 10**_decimals;
859     }
860  
861     function updateSwapEnabled(bool _enabled) external onlyOwner{
862         swapEnabled = _enabled;
863     }
864  
865     function updateRouterAndPair(address newRouter, address newPair) external onlyOwner{
866         //Thanks
867         router = IRouter(newRouter);
868         pair = newPair;
869     }
870  
871     function updateDynamicTax(uint256 amount) external onlyOwner{
872         dynamicTax = amount;
873     }
874  
875     function updateMaxSellTax(uint256 amount) external onlyOwner{
876         maxSellTax = amount;
877     }
878  
879     function rescueETH(uint256 weiAmount) external onlyOwner{
880         payable(msg.sender).transfer(weiAmount);
881     }
882  
883     function rescueTokens(address _tokenAddr, address _to, uint _amount) external onlyOwner {
884         IERC20(_tokenAddr).transfer(_to, _amount);
885     }
886  
887     receive() external payable{
888     }
889 }