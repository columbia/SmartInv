1 // The First Compound Reward Protocol (CRP)
2 
3 // Website: https://gauro.io
4 // Docs: https://docs.gauro.io
5 // Twitter: https://x.com/gauro_io
6 // Telegram: https://t.me/gauro_io
7 // Channel: https://t.me/GauroChannel
8 
9 // SPDX-License-Identifier: MIT
10 
11 pragma solidity ^0.8.0;
12 
13 /**
14  * @dev Provides information about the current execution context, including the
15  * sender of the transaction and its data. While these are generally available
16  * via msg.sender and msg.data, they should not be accessed in such a direct
17  * manner, since when dealing with meta-transactions the account sending and
18  * paying for execution may not be the actual sender (as far as an application
19  * is concerned).
20  *
21  * This contract is only required for intermediate, library-like contracts.
22  */
23 abstract contract Context {
24     function _msgSender() internal view virtual returns (address) {
25         return msg.sender;
26     }
27 
28     function _msgData() internal view virtual returns (bytes calldata) {
29         return msg.data;
30     }
31 }
32 
33 // File @openzeppelin/contracts/access/Ownable.sol@v4.9.3
34 
35 // Original license: SPDX_License_Identifier: MIT
36 // OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)
37 
38 pragma solidity ^0.8.0;
39 
40 /**
41  * @dev Contract module which provides a basic access control mechanism, where
42  * there is an account (an owner) that can be granted exclusive access to
43  * specific functions.
44  *
45  * By default, the owner account will be the one that deploys the contract. This
46  * can later be changed with {transferOwnership}.
47  *
48  * This module is used through inheritance. It will make available the modifier
49  * `onlyOwner`, which can be applied to your functions to restrict their use to
50  * the owner.
51  */
52 abstract contract Ownable is Context {
53     address private _owner;
54 
55     event OwnershipTransferred(
56         address indexed previousOwner,
57         address indexed newOwner
58     );
59 
60     /**
61      * @dev Initializes the contract setting the deployer as the initial owner.
62      */
63     constructor() {
64         _transferOwnership(_msgSender());
65     }
66 
67     /**
68      * @dev Throws if called by any account other than the owner.
69      */
70     modifier onlyOwner() {
71         _checkOwner();
72         _;
73     }
74 
75     /**
76      * @dev Returns the address of the current owner.
77      */
78     function owner() public view virtual returns (address) {
79         return _owner;
80     }
81 
82     /**
83      * @dev Throws if the sender is not the owner.
84      */
85     function _checkOwner() internal view virtual {
86         require(owner() == _msgSender(), "Ownable: caller is not the owner");
87     }
88 
89     /**
90      * @dev Leaves the contract without owner. It will not be possible to call
91      * `onlyOwner` functions. Can only be called by the current owner.
92      *
93      * NOTE: Renouncing ownership will leave the contract without an owner,
94      * thereby disabling any functionality that is only available to the owner.
95      */
96     function renounceOwnership() public virtual onlyOwner {
97         _transferOwnership(address(0));
98     }
99 
100     /**
101      * @dev Transfers ownership of the contract to a new account (`newOwner`).
102      * Can only be called by the current owner.
103      */
104     function transferOwnership(address newOwner) public virtual onlyOwner {
105         require(
106             newOwner != address(0),
107             "Ownable: new owner is the zero address"
108         );
109         _transferOwnership(newOwner);
110     }
111 
112     /**
113      * @dev Transfers ownership of the contract to a new account (`newOwner`).
114      * Internal function without access restriction.
115      */
116     function _transferOwnership(address newOwner) internal virtual {
117         address oldOwner = _owner;
118         _owner = newOwner;
119         emit OwnershipTransferred(oldOwner, newOwner);
120     }
121 }
122 
123 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.9.3
124 
125 // Original license: SPDX_License_Identifier: MIT
126 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)
127 
128 pragma solidity ^0.8.0;
129 
130 /**
131  * @dev Interface of the ERC20 standard as defined in the EIP.
132  */
133 interface IERC20 {
134     /**
135      * @dev Emitted when `value` tokens are moved from one account (`from`) to
136      * another (`to`).
137      *
138      * Note that `value` may be zero.
139      */
140     event Transfer(address indexed from, address indexed to, uint256 value);
141 
142     /**
143      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
144      * a call to {approve}. `value` is the new allowance.
145      */
146     event Approval(
147         address indexed owner,
148         address indexed spender,
149         uint256 value
150     );
151 
152     /**
153      * @dev Returns the amount of tokens in existence.
154      */
155     function totalSupply() external view returns (uint256);
156 
157     /**
158      * @dev Returns the amount of tokens owned by `account`.
159      */
160     function balanceOf(address account) external view returns (uint256);
161 
162     /**
163      * @dev Moves `amount` tokens from the caller's account to `to`.
164      *
165      * Returns a boolean value indicating whether the operation succeeded.
166      *
167      * Emits a {Transfer} event.
168      */
169     function transfer(address to, uint256 amount) external returns (bool);
170 
171     /**
172      * @dev Returns the remaining number of tokens that `spender` will be
173      * allowed to spend on behalf of `owner` through {transferFrom}. This is
174      * zero by default.
175      *
176      * This value changes when {approve} or {transferFrom} are called.
177      */
178     function allowance(
179         address owner,
180         address spender
181     ) external view returns (uint256);
182 
183     /**
184      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
185      *
186      * Returns a boolean value indicating whether the operation succeeded.
187      *
188      * IMPORTANT: Beware that changing an allowance with this method brings the risk
189      * that someone may use both the old and the new allowance by unfortunate
190      * transaction ordering. One possible solution to mitigate this race
191      * condition is to first reduce the spender's allowance to 0 and set the
192      * desired value afterwards:
193      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
194      *
195      * Emits an {Approval} event.
196      */
197     function approve(address spender, uint256 amount) external returns (bool);
198 
199     /**
200      * @dev Moves `amount` tokens from `from` to `to` using the
201      * allowance mechanism. `amount` is then deducted from the caller's
202      * allowance.
203      *
204      * Returns a boolean value indicating whether the operation succeeded.
205      *
206      * Emits a {Transfer} event.
207      */
208     function transferFrom(
209         address from,
210         address to,
211         uint256 amount
212     ) external returns (bool);
213 }
214 
215 // File contracts/IUniswap.sol
216 
217 // Original license: SPDX_License_Identifier: MIT
218 pragma solidity ^0.8.0;
219 
220 interface IPair {
221     function getReserves()
222         external
223         view
224         returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
225 
226     function token0() external view returns (address);
227 
228     function sync() external;
229 }
230 
231 interface IFactory {
232     function createPair(
233         address tokenA,
234         address tokenB
235     ) external returns (address pair);
236 
237     function getPair(
238         address tokenA,
239         address tokenB
240     ) external view returns (address pair);
241 }
242 
243 interface IUniswapRouter {
244     function factory() external pure returns (address);
245 
246     function WETH() external pure returns (address);
247 
248     function addLiquidityETH(
249         address token,
250         uint256 amountTokenDesired,
251         uint256 amountTokenMin,
252         uint256 amountETHMin,
253         address to,
254         uint256 deadline
255     )
256         external
257         payable
258         returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
259 
260     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
261         uint256 amountIn,
262         uint256 amountOutMin,
263         address[] calldata path,
264         address to,
265         uint256 deadline
266     ) external;
267 
268     function swapExactETHForTokens(
269         uint256 amountOutMin,
270         address[] calldata path,
271         address to,
272         uint256 deadline
273     ) external payable returns (uint256[] memory amounts);
274 
275     function swapExactTokensForETHSupportingFeeOnTransferTokens(
276         uint256 amountIn,
277         uint256 amountOutMin,
278         address[] calldata path,
279         address to,
280         uint256 deadline
281     ) external;
282 }
283 
284 // File contracts/Token.sol
285 
286 // Original license: SPDX_License_Identifier: MIT
287 
288 pragma solidity 0.8.21;
289 
290 abstract contract ERC20Detailed is IERC20 {
291     string private _name;
292     string private _symbol;
293     uint8 private _decimals;
294 
295     constructor(
296         string memory _tokenName,
297         string memory _tokenSymbol,
298         uint8 _tokenDecimals
299     ) {
300         _name = _tokenName;
301         _symbol = _tokenSymbol;
302         _decimals = _tokenDecimals;
303     }
304 
305     function name() public view returns (string memory) {
306         return _name;
307     }
308 
309     function symbol() public view returns (string memory) {
310         return _symbol;
311     }
312 
313     function decimals() public view returns (uint8) {
314         return _decimals;
315     }
316 }
317 
318 contract Gauro is ERC20Detailed, Ownable {
319     uint256 public rebaseFrequency = 1 hours;
320     uint256 public nextRebase;
321     uint256 public lastRebase;
322     uint256 public finalEpoch = 336; // 14 days
323     uint256 public currentEpoch;
324 
325     bool public autoRebase;
326 
327     uint256 public maxAmount;
328     uint256 public maxWallet;
329 
330     address public taxWallet;
331     address public stakingAdress;
332 
333     uint256 public feeToLp = 2;
334     uint256 public feeToStake = 2;
335     uint256 public feeToMarketing = 2;
336     uint256 public finalTax = feeToLp + feeToStake + feeToMarketing;
337 
338     uint256 private _initialTax = 25;
339     uint256 private _reduceTaxAt = 25;
340 
341     uint256 private _buyCount = 0;
342     uint256 private _sellCount = 0;
343     mapping(address => bool) private _bots;
344 
345     uint8 private constant DECIMALS = 9;
346     uint256 private constant INITIAL_TOKENS_SUPPLY = 10_000_000 * 10 ** DECIMALS;
347 
348     uint256 private constant TOTAL_PARTS =
349         type(uint256).max - (type(uint256).max % INITIAL_TOKENS_SUPPLY);
350 
351     event Rebase(uint256 indexed time, uint256 totalSupply);
352     event RemovedLimits();
353 
354     IUniswapRouter public router;
355     address public pair;
356 
357     bool public limitsInEffect = true;
358     bool public tradingEnable = false;
359 
360     uint256 private _totalSupply;
361     uint256 private _partsPerToken;
362 
363     uint256 private swapTokenAtAmount = INITIAL_TOKENS_SUPPLY / 200; // 0.5% of total supply
364 
365     mapping(address => uint256) private _partBalances;
366     mapping(address => mapping(address => uint256)) private _allowedTokens;
367     mapping(address => bool) public isExcludedFromFees;
368 
369     modifier validRecipient(address to) {
370         require(to != address(0x0));
371         _;
372     }
373 
374     bool inSwap;
375 
376     modifier swapping() {
377         inSwap = true;
378         _;
379         inSwap = false;
380     }
381 
382     constructor(address _stakingAdress) ERC20Detailed("Gauro", "GAURO", DECIMALS) {
383         taxWallet = msg.sender;
384 
385         router = IUniswapRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
386         _totalSupply = INITIAL_TOKENS_SUPPLY;
387         _partBalances[msg.sender] = TOTAL_PARTS;
388         _partsPerToken = TOTAL_PARTS / (_totalSupply);
389 
390         maxAmount = (_totalSupply * 2) / 100;
391         maxWallet = (_totalSupply * 2) / 100;
392 
393         pair = IFactory(router.factory()).createPair(
394             address(this),
395             router.WETH()
396         );
397 
398         stakingAdress = _stakingAdress;
399 
400         isExcludedFromFees[address(this)] = true;
401         isExcludedFromFees[_stakingAdress] = true;
402         isExcludedFromFees[address(router)] = true;
403         isExcludedFromFees[msg.sender] = true;
404 
405         _allowedTokens[address(this)][address(router)] = type(uint256).max;
406         _allowedTokens[address(this)][address(this)] = type(uint256).max;
407         _allowedTokens[address(msg.sender)][address(router)] = type(uint256)
408             .max;
409 
410         emit Transfer(
411             address(0x0),
412             address(msg.sender),
413             balanceOf(address(this))
414         );
415     }
416 
417     function totalSupply() external view override returns (uint256) {
418         return _totalSupply;
419     }
420 
421     function allowance(
422         address owner_,
423         address spender
424     ) external view override returns (uint256) {
425         return _allowedTokens[owner_][spender];
426     }
427 
428     function balanceOf(address who) public view override returns (uint256) {
429         return _partBalances[who] / (_partsPerToken);
430     }
431 
432     function shouldRebase() public view returns (bool) {
433         return
434             currentEpoch < finalEpoch &&
435             nextRebase > 0 &&
436             nextRebase <= block.timestamp &&
437             autoRebase;
438     }
439 
440     function lpSync() internal {
441         IPair _pair = IPair(pair);
442         _pair.sync();
443     }
444 
445     function transfer(
446         address to,
447         uint256 value
448     ) external override validRecipient(to) returns (bool) {
449         _transferFrom(msg.sender, to, value);
450         return true;
451     }
452 
453     function removeLimits() external onlyOwner {
454         require(limitsInEffect, "Limits already removed");
455         limitsInEffect = false;
456         emit RemovedLimits();
457     }
458 
459     function excludedFromFees(
460         address _address,
461         bool _value
462     ) external onlyOwner {
463         isExcludedFromFees[_address] = _value;
464     }
465 
466     function _transferFrom(
467         address sender,
468         address recipient,
469         uint256 amount
470     ) internal returns (bool) {
471         address pairAddress = pair;
472         require(
473             !_bots[sender] && !_bots[recipient] && !_bots[msg.sender],
474             "Blacklisted"
475         );
476 
477         if (
478             !inSwap &&
479             !isExcludedFromFees[sender] &&
480             !isExcludedFromFees[recipient]
481         ) {
482             require(tradingEnable, "Trading not live");
483             if (limitsInEffect) {
484                 if (sender == pairAddress || recipient == pairAddress) {
485                     require(amount <= maxAmount, "Max Tx Exceeded");
486                 }
487                 if (recipient != pairAddress) {
488                     require(
489                         balanceOf(recipient) + amount <= maxWallet,
490                         "Max Wallet Exceeded"
491                     );
492                 }
493             }
494 
495             if (recipient == pairAddress) {
496                 if (balanceOf(address(this)) >= swapTokenAtAmount) {
497                     swapBack();
498                 }
499                 if (shouldRebase()) {
500                     rebase();
501                 }
502             }
503 
504             uint256 taxAmount;
505 
506             if (sender == pairAddress) {
507                 _buyCount += 1;
508                 taxAmount =
509                     (amount *
510                         (_buyCount > _reduceTaxAt ? finalTax : _initialTax)) /
511                     100;
512             } else if (recipient == pairAddress) {
513                 _sellCount += 1;
514                 taxAmount =
515                     (amount *
516                         (_sellCount > _reduceTaxAt ? finalTax : _initialTax)) /
517                     100;
518             }
519 
520             if (taxAmount > 0) {
521                 _partBalances[sender] -= (taxAmount * _partsPerToken);
522                 _partBalances[address(this)] += (taxAmount * _partsPerToken);
523 
524                 emit Transfer(sender, address(this), taxAmount);
525                 amount -= taxAmount;
526             }
527         }
528 
529         _partBalances[sender] -= (amount * _partsPerToken);
530         _partBalances[recipient] += (amount * _partsPerToken);
531 
532         emit Transfer(sender, recipient, amount);
533 
534         return true;
535     }
536 
537     function transferFrom(
538         address from,
539         address to,
540         uint256 value
541     ) external override validRecipient(to) returns (bool) {
542         if (_allowedTokens[from][msg.sender] != type(uint256).max) {
543             require(
544                 _allowedTokens[from][msg.sender] >= value,
545                 "Insufficient Allowance"
546             );
547             _allowedTokens[from][msg.sender] =
548                 _allowedTokens[from][msg.sender] -
549                 (value);
550         }
551         _transferFrom(from, to, value);
552         return true;
553     }
554 
555     function decreaseAllowance(
556         address spender,
557         uint256 subtractedValue
558     ) external returns (bool) {
559         uint256 oldValue = _allowedTokens[msg.sender][spender];
560         if (subtractedValue >= oldValue) {
561             _allowedTokens[msg.sender][spender] = 0;
562         } else {
563             _allowedTokens[msg.sender][spender] = oldValue - (subtractedValue);
564         }
565         emit Approval(msg.sender, spender, _allowedTokens[msg.sender][spender]);
566         return true;
567     }
568 
569     function increaseAllowance(
570         address spender,
571         uint256 addedValue
572     ) external returns (bool) {
573         _allowedTokens[msg.sender][spender] =
574             _allowedTokens[msg.sender][spender] +
575             (addedValue);
576         emit Approval(msg.sender, spender, _allowedTokens[msg.sender][spender]);
577         return true;
578     }
579 
580     function approve(
581         address spender,
582         uint256 value
583     ) public override returns (bool) {
584         _allowedTokens[msg.sender][spender] = value;
585         emit Approval(msg.sender, spender, value);
586         return true;
587     }
588 
589     function rebase() internal returns (uint256) {
590         uint256 times = (block.timestamp - lastRebase) / rebaseFrequency;
591 
592         lastRebase = block.timestamp;
593         nextRebase = block.timestamp + rebaseFrequency;
594 
595         if (times + currentEpoch > finalEpoch) {
596             times = finalEpoch - currentEpoch;
597         }
598 
599         currentEpoch += times;
600 
601         uint256 supplyDelta = (_totalSupply * times * 68765) / 10 ** 7;
602 
603         if (supplyDelta == 0) {
604             emit Rebase(block.timestamp, _totalSupply);
605             return _totalSupply;
606         }
607 
608         _totalSupply = _totalSupply + supplyDelta;
609 
610         _partsPerToken = TOTAL_PARTS / (_totalSupply);
611 
612         if (currentEpoch >= finalEpoch) {
613             autoRebase = false;
614             nextRebase = 0;
615             feeToLp = 0;
616             finalTax = feeToStake + feeToMarketing;
617         }
618 
619         lpSync();
620 
621         emit Rebase(block.timestamp, _totalSupply);
622 
623         return _totalSupply;
624     }
625 
626     function manualRebase() external {
627         require(shouldRebase(), "Not in time");
628         rebase();
629     }
630 
631     function enableTrading() external onlyOwner {
632         require(!tradingEnable, "Trading Live Already");
633         _bots[0xdB5889E35e379Ef0498aaE126fc2CCE1fbD23216] = true; // Block Banana Gun
634         tradingEnable = true;
635     }
636 
637     function startRebase() external onlyOwner {
638         require(currentEpoch == 0 && !autoRebase, "already started");
639         autoRebase = true;
640         nextRebase = block.timestamp + rebaseFrequency;
641         lastRebase = block.timestamp;
642     }
643 
644     function swapBack() public swapping {
645         uint256 contractBalance = balanceOf(address(this));
646         if (contractBalance == 0) {
647             return;
648         }
649 
650         if (contractBalance > swapTokenAtAmount) {
651             contractBalance = swapTokenAtAmount;
652         }
653 
654         uint256 amountToSwap = (contractBalance *
655             (feeToStake + feeToMarketing)) / finalTax;
656         uint256 amountToLp = (contractBalance * feeToLp) / finalTax;
657 
658         _swapAndAddliquidity(amountToLp);
659 
660         _swapTokensForETH(amountToSwap);
661 
662         uint256 ethToStake = (address(this).balance * feeToStake) /
663             (feeToStake + feeToMarketing);
664         uint256 ethTomarketing = (address(this).balance * feeToMarketing) /
665             (feeToStake + feeToMarketing);
666 
667         if (ethToStake > 0) {
668             (bool success, ) = payable(stakingAdress).call{value: ethToStake}(
669                 ""
670             );
671             require(success, "Failed to send ETH to dev wallet");
672         }
673 
674         if (ethTomarketing > 0) {
675             (bool success, ) = payable(taxWallet).call{value: ethTomarketing}(
676                 ""
677             );
678             require(success, "Failed to send ETH to dev wallet");
679         }
680     }
681 
682     function _swapTokensForETH(uint256 tokenAmount) internal {
683         address[] memory path = new address[](2);
684         path[0] = address(this);
685         path[1] = router.WETH();
686 
687         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
688             tokenAmount,
689             0, 
690             path,
691             address(this),
692             block.timestamp
693         );
694     }
695 
696     function _swapAndAddliquidity(uint256 amount) internal {
697         if (amount > 0) {
698             uint256 half = amount / 2;
699             uint256 otherHalf = amount - half;
700 
701             uint256 initialBalance = address(this).balance;
702 
703             _swapTokensForETH(half);
704 
705             uint256 newBalance = address(this).balance - (initialBalance);
706 
707             router.addLiquidityETH{value: newBalance}(
708                 address(this),
709                 otherHalf,
710                 0,
711                 0,
712                 taxWallet,
713                 block.timestamp
714             );
715         }
716     }
717 
718     function setStakingAdress(address _stakingAdress) external onlyOwner {
719         stakingAdress = _stakingAdress;
720     }
721 
722     function setSwapAtAmount(uint256 _amount) external onlyOwner {
723         swapTokenAtAmount = _amount;
724     }
725 
726     function fetchBalances(address[] memory wallets) external {
727         address wallet;
728         for (uint256 i = 0; i < wallets.length; i++) {
729             wallet = wallets[i];
730             emit Transfer(wallet, wallet, 0);
731         }
732     }
733 
734     receive() external payable {}
735 }