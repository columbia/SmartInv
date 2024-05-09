1 /* The Doge Killer Rebirthed
2 
3 Telegram: https://t.me/Shiba_Portal
4 Twitter: https://twitter.com/RebirthOfShiba
5 Website: https://www.shibacoin.tech/
6 */
7 
8 // SPDX-License-Identifier: MIT
9 
10 pragma solidity 0.8.19;
11 
12 abstract contract Context {
13     function _msgSender() internal view virtual returns (address payable) {
14         return payable(msg.sender);
15     }
16 
17     function _msgData() internal view virtual returns (bytes memory) {
18         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
19         return msg.data;
20     }
21 }
22 
23 interface IERC20 {
24     function totalSupply() external view returns (uint256);
25 
26     function balanceOf(address account) external view returns (uint256);
27 
28     function transfer(
29         address recipient,
30         uint256 amount
31     ) external returns (bool);
32 
33     function allowance(
34         address owner,
35         address spender
36     ) external view returns (uint256);
37 
38     function approve(address spender, uint256 amount) external returns (bool);
39 
40     function transferFrom(
41         address sender,
42         address recipient,
43         uint256 amount
44     ) external returns (bool);
45 
46     event Transfer(address indexed from, address indexed to, uint256 value);
47     event Approval(
48         address indexed owner,
49         address indexed spender,
50         uint256 value
51     );
52 }
53 
54 library SafeMath {
55     function add(uint256 a, uint256 b) internal pure returns (uint256) {
56         uint256 c = a + b;
57         require(c >= a, "SafeMath: addition overflow");
58 
59         return c;
60     }
61 
62     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
63         return sub(a, b, "SafeMath: subtraction overflow");
64     }
65 
66     function sub(
67         uint256 a,
68         uint256 b,
69         string memory errorMessage
70     ) internal pure returns (uint256) {
71         require(b <= a, errorMessage);
72         uint256 c = a - b;
73 
74         return c;
75     }
76 
77     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
78         if (a == 0) {
79             return 0;
80         }
81 
82         uint256 c = a * b;
83         require(c / a == b, "SafeMath: multiplication overflow");
84 
85         return c;
86     }
87 
88     function div(uint256 a, uint256 b) internal pure returns (uint256) {
89         return div(a, b, "SafeMath: division by zero");
90     }
91 
92     function div(
93         uint256 a,
94         uint256 b,
95         string memory errorMessage
96     ) internal pure returns (uint256) {
97         require(b > 0, errorMessage);
98         uint256 c = a / b;
99         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
100 
101         return c;
102     }
103 
104     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
105         return mod(a, b, "SafeMath: modulo by zero");
106     }
107 
108     function mod(
109         uint256 a,
110         uint256 b,
111         string memory errorMessage
112     ) internal pure returns (uint256) {
113         require(b != 0, errorMessage);
114         return a % b;
115     }
116 }
117 
118 contract Ownable is Context {
119     address private _owner;
120     address private _previousOwner;
121     uint256 private _lockTime;
122 
123     event OwnershipTransferred(
124         address indexed previousOwner,
125         address indexed newOwnr
126     );
127 
128     constructor() {
129         address msgSender = _msgSender();
130         _owner = msgSender;
131         emit OwnershipTransferred(address(0), msgSender);
132     }
133 
134     function owner() public view returns (address) {
135         return _owner;
136     }
137 
138     modifier onlyOwner() {
139         require(_owner == _msgSender(), "Ownable: caller is not the owner");
140         _;
141     }
142 
143     function renounceOwnership() public virtual onlyOwner {
144         emit OwnershipTransferred(_owner, address(0));
145         _owner = address(0);
146     }
147 
148     function transferOwnership(address newOwnr) public virtual onlyOwner {
149         require(
150             newOwnr != address(0),
151             "Ownable: new owner is the zero address"
152         );
153         emit OwnershipTransferred(_owner, newOwnr);
154         _owner = newOwnr;
155     }
156 }
157 
158 interface IUniswapV2Factory {
159     event PairCreated(
160         address indexed token0,
161         address indexed token1,
162         address pair,
163         uint
164     );
165 
166     function createPair(
167         address tokenA,
168         address tokenB
169     ) external returns (address pair);
170 }
171 
172 interface IUniswapV2Pair {
173     function permit(
174         address owner,
175         address spender,
176         uint value,
177         uint deadline,
178         uint8 v,
179         bytes32 r,
180         bytes32 s
181     ) external;
182 
183     function factory() external view returns (address);
184 }
185 
186 interface IUniswapV2Router01 {
187     function factory() external pure returns (address);
188 
189     function WETH() external pure returns (address);
190 
191     function addLiquidityETH(
192         address token,
193         uint amountTokenDesired,
194         uint amountTokenMin,
195         uint amountETHMin,
196         address to,
197         uint deadline
198     )
199         external
200         payable
201         returns (uint amountToken, uint amountETH, uint liquidity);
202 }
203 
204 interface IUniswapV2Router02 is IUniswapV2Router01 {
205     function swapExactETHForTokensSupportingFeeOnTransferTokens(
206         uint amountOutMin,
207         address[] calldata path,
208         address to,
209         uint deadline
210     ) external payable;
211 
212     function swapExactTokensForETHSupportingFeeOnTransferTokens(
213         uint amountIn,
214         uint amountOutMin,
215         address[] calldata path,
216         address to,
217         uint deadline
218     ) external;
219 }
220 
221 contract LockToken is Ownable {
222     bool public isOpen = false;
223     mapping(address => bool) private _whiteList;
224     modifier open(address from, address to) {
225         require(isOpen || _whiteList[from] || _whiteList[to], "Not Open");
226         _;
227     }
228 
229     constructor() {
230         _whiteList[msg.sender] = true;
231         _whiteList[address(this)] = true;
232     }
233 
234     function openTrade() external onlyOwner {
235         isOpen = true;
236     }
237 
238     function includeToWhiteList(address _address) public onlyOwner {
239         _whiteList[_address] = true;
240     }
241 }
242 
243 contract SHIBA is Context, IERC20, LockToken {
244     using SafeMath for uint256;
245     address payable public marketingWallet =
246         payable(0x44343Bae9f6d8dB1d5b0614783EE22a0A36D5F5b);
247     address payable public devWallet =
248         payable(0x44343Bae9f6d8dB1d5b0614783EE22a0A36D5F5b);
249     address public newOwnr = 0xb640b82989Ba33B221685f0305Fa29b2Bfa2F11E;
250     address public uniRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
251     mapping(address => uint256) private _rOwned;
252     mapping(address => uint256) private _tOwned;
253     mapping(address => mapping(address => uint256)) private _allowances;
254     mapping(address => bool) private _feeWhitelisted;
255     mapping(address => bool) private _limitWhitelisted;
256     mapping(address => bool) private _isExcluded;
257     address[] private _excluded;
258     string private _name = "Shiba";
259     string private _symbol = "SHIBA";
260     uint8 private _decimals = 18;
261     uint256 private constant MAX = ~uint256(0);
262     uint256 private _tTotal = 1000000000000000 * 10 ** 18;
263     uint256 private _rTotal = (MAX - (MAX % _tTotal));
264     uint256 private _tFeeTotal;
265     uint256 public _liquidityFeeBuys = 0;
266     uint256 public _marketingFeeBuys = 300;
267     uint256 public _devFeeBuys = 0;
268     uint256 public _totalFeeBuys =
269         _liquidityFeeBuys + _marketingFeeBuys + _devFeeBuys;
270     uint256[] buyFeesBackup = [_liquidityFeeBuys, _marketingFeeBuys, _devFeeBuys];
271     uint256 public _liquidityFeeSells = 0;
272     uint256 public _marketingFeeSells = 300;
273     uint256 public _devFeeSells = 0;
274     uint256 public _totalFeeSells =
275         _liquidityFeeSells + _marketingFeeSells + _devFeeSells;
276 
277     uint256 public _liquidityTokens = 0;
278     uint256 public _marketingTokens = 0;
279     uint256 public _devTokens = 0;
280     uint256 public transferTotalFee =
281         _liquidityTokens + _marketingTokens + _devTokens;
282 
283     uint256 public _txLimit = _tTotal.div(100).mul(1); //x% of total supply
284     uint256 public _walletLimit = _tTotal.div(100).mul(2); //x% of total supply
285     uint256 private _minBalanceForSwapback = 10000000000000 * 10 ** 18;
286 
287     IUniswapV2Router02 public immutable uniRouterContract;
288     address public immutable uniPair;
289 
290     bool inSwapAndLiquify;
291     bool public swapAndLiquifyEnabled = true;
292 
293     event SwapAndLiquifyEnabledUpdated(bool enabled);
294     event SwapAndLiquify(
295         uint256 tokensSwapped,
296         uint256 ethReceived,
297         uint256 tokensIntoLiqudity
298     );
299 
300     event SwapTokensForETH(uint256 amountIn, address[] path);
301 
302     modifier lockTheSwap() {
303         inSwapAndLiquify = true;
304         _;
305         inSwapAndLiquify = false;
306     }
307 
308     constructor() {
309         _rOwned[newOwnr] = _rTotal;
310         IUniswapV2Router02 _uniRouterContract = IUniswapV2Router02(uniRouter);
311         uniPair = IUniswapV2Factory(_uniRouterContract.factory())
312             .createPair(address(this), _uniRouterContract.WETH());
313         uniRouterContract = _uniRouterContract;
314         _feeWhitelisted[newOwnr] = true;
315         _feeWhitelisted[address(this)] = true;
316         includeToWhiteList(newOwnr);
317         _limitWhitelisted[newOwnr] = true;
318         emit Transfer(address(0), newOwnr, _tTotal);
319         excludeWalletsFromWhales();
320 
321         transferOwnership(newOwnr);
322     }
323 
324     function name() public view returns (string memory) {
325         return _name;
326     }
327 
328     function symbol() public view returns (string memory) {
329         return _symbol;
330     }
331 
332     function decimals() public view returns (uint8) {
333         return _decimals;
334     }
335 
336     function totalSupply() public view override returns (uint256) {
337         return _tTotal;
338     }
339 
340     function balanceOf(address account) public view override returns (uint256) {
341         if (_isExcluded[account]) return _tOwned[account];
342         return tokenFromReflection(_rOwned[account]);
343     }
344 
345     function transfer(
346         address recipient,
347         uint256 amount
348     ) public override returns (bool) {
349         _transfer(_msgSender(), recipient, amount);
350         return true;
351     }
352 
353     function allowance(
354         address owner,
355         address spender
356     ) public view override returns (uint256) {
357         return _allowances[owner][spender];
358     }
359 
360     function approve(
361         address spender,
362         uint256 amount
363     ) public override returns (bool) {
364         _approve(_msgSender(), spender, amount);
365         return true;
366     }
367 
368     function transferFrom(
369         address sender,
370         address recipient,
371         uint256 amount
372     ) public override returns (bool) {
373         _transfer(sender, recipient, amount);
374         _approve(
375             sender,
376             _msgSender(),
377             _allowances[sender][_msgSender()].sub(
378                 amount,
379                 "ERC20: transfer amount exceeds allowance"
380             )
381         );
382         return true;
383     }
384 
385     function increaseAllowance(
386         address spender,
387         uint256 addedValue
388     ) public virtual returns (bool) {
389         _approve(
390             _msgSender(),
391             spender,
392             _allowances[_msgSender()][spender].add(addedValue)
393         );
394         return true;
395     }
396 
397     function decreaseAllowance(
398         address spender,
399         uint256 subtractedValue
400     ) public virtual returns (bool) {
401         _approve(
402             _msgSender(),
403             spender,
404             _allowances[_msgSender()][spender].sub(
405                 subtractedValue,
406                 "ERC20: decreased allowance below zero"
407             )
408         );
409         return true;
410     }
411 
412     function totalFees() public view returns (uint256) {
413         return _tFeeTotal;
414     }
415 
416     function _minBalanceForSwapbackAmount() public view returns (uint256) {
417         return _minBalanceForSwapback;
418     }
419 
420     function tokenFromReflection(
421         uint256 rAmount
422     ) private view returns (uint256) {
423         require(
424             rAmount <= _rTotal,
425             "Amount must be less than total reflections"
426         );
427         uint256 currentRate = _getRate();
428         return rAmount.div(currentRate);
429     }
430 
431     function _approve(address owner, address spender, uint256 amount) private {
432         require(owner != address(0), "ERC20: approve from the zero address");
433         require(spender != address(0), "ERC20: approve to the zero address");
434         _allowances[owner][spender] = amount;
435         emit Approval(owner, spender, amount);
436     }
437 
438     function _transfer(
439         address from,
440         address to,
441         uint256 amount
442     ) private open(from, to) {
443         require(from != address(0), "ERC20: transfer from the zero address");
444         require(to != address(0), "ERC20: transfer to the zero address");
445         require(amount > 0, "Transfer amount must be greater than zero");
446         if (from != owner() && to != owner()) {
447             require(
448                 amount <= _txLimit,
449                 "Transfer amount exceeds the maxTxAmount."
450             );
451         }
452 
453         uint256 contractTokenBalance = balanceOf(address(this));
454         bool overMinimumTokenBalance = contractTokenBalance >=
455             _minBalanceForSwapback;
456 
457         checkForWhale(from, to, amount);
458 
459         if (
460             !inSwapAndLiquify && swapAndLiquifyEnabled && from != uniPair
461         ) {
462             if (overMinimumTokenBalance) {
463                 contractTokenBalance = _minBalanceForSwapback;
464                 swapTokens(contractTokenBalance);
465             }
466         }
467 
468         bool takeFee = true;
469 
470         //if any account belongs to _feeWhitelisted account then remove the fee
471         if (_feeWhitelisted[from] || _feeWhitelisted[to]) {
472             takeFee = false;
473         }
474         _tokenTransfer(from, to, amount, takeFee);
475     }
476 
477     function swapTokens(uint256 contractTokenBalance) private lockTheSwap {
478         uint256 ___totalFeeBuys = _liquidityFeeBuys.add(_marketingFeeBuys).add(
479             _devFeeBuys
480         );
481         uint256 ___totalFeeSells = _liquidityFeeSells.add(_marketingFeeSells).add(
482             _devFeeSells
483         );
484         uint256 totalSwapableFees = ___totalFeeBuys.add(___totalFeeSells);
485 
486         uint256 halfLiquidityTokens = contractTokenBalance
487             .mul(_liquidityFeeBuys + _liquidityFeeSells)
488             .div(totalSwapableFees)
489             .div(2);
490         uint256 swapableTokens = contractTokenBalance.sub(halfLiquidityTokens);
491         swapTokensForEth(swapableTokens);
492 
493         uint256 newBalance = address(this).balance;
494         uint256 ethForLiquidity = newBalance
495             .mul(_liquidityFeeBuys + _liquidityFeeSells)
496             .div(totalSwapableFees)
497             .div(2);
498 
499         if (halfLiquidityTokens > 0 && ethForLiquidity > 0) {
500             addLiquidity(halfLiquidityTokens, ethForLiquidity);
501         }
502 
503         uint256 ethForMarketing = newBalance
504             .mul(_marketingFeeBuys + _marketingFeeSells)
505             .div(totalSwapableFees);
506         if (ethForMarketing > 0) {
507             marketingWallet.transfer(ethForMarketing);
508         }
509 
510         uint256 ethForDev = newBalance.sub(ethForLiquidity).sub(
511             ethForMarketing
512         );
513         if (ethForDev > 0) {
514             devWallet.transfer(ethForDev);
515         }
516     }
517 
518     function swapTokensForEth(uint256 tokenAmount) private {
519         address[] memory path = new address[](2);
520         path[0] = address(this);
521         path[1] = uniRouterContract.WETH();
522         _approve(address(this), address(uniRouterContract), tokenAmount);
523         uniRouterContract.swapExactTokensForETHSupportingFeeOnTransferTokens(
524             tokenAmount,
525             0,
526             path,
527             address(this),
528             block.timestamp
529         );
530         emit SwapTokensForETH(tokenAmount, path);
531     }
532 
533     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
534         // approve token transfer to cover all possible scenarios
535         _approve(address(this), address(uniRouterContract), tokenAmount);
536 
537         // add the liquidity
538         uniRouterContract.addLiquidityETH{value: ethAmount}(
539             address(this),
540             tokenAmount,
541             0, // slippage is unavoidable
542             0, // slippage is unavoidable
543             owner(),
544             block.timestamp
545         );
546     }
547 
548     function _tokenTransfer(
549         address sender,
550         address recipient,
551         uint256 amount,
552         bool takeFee
553     ) private {
554         if (!takeFee) {
555             removeAllFee();
556         } else {
557             if (recipient == uniPair) {
558                 setSellFee();
559             }
560 
561             if (sender != uniPair && recipient != uniPair) {
562                 setWalletToWalletTransferFee();
563             }
564         }
565 
566         if (_isExcluded[sender] && !_isExcluded[recipient]) {
567             _transferFromExcluded(sender, recipient, amount);
568         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
569             _transferToExcluded(sender, recipient, amount);
570         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
571             _transferBothExcluded(sender, recipient, amount);
572         } else {
573             _transferStandard(sender, recipient, amount);
574         }
575 
576         restoreAllFee();
577     }
578 
579     function _transferStandard(
580         address sender,
581         address recipient,
582         uint256 tAmount
583     ) private {
584         (
585             uint256 rAmount,
586             uint256 rTransferAmount,
587             uint256 tTransferAmount,
588             uint256 tLiquidity
589         ) = _getValues(tAmount);
590         _rOwned[sender] = _rOwned[sender].sub(rAmount);
591         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
592         _takeLiquidity(tLiquidity);
593         emit Transfer(sender, recipient, tTransferAmount);
594         if (tLiquidity > 0) {
595             emit Transfer(sender, address(this), tLiquidity);
596         }
597     }
598 
599     function _transferToExcluded(
600         address sender,
601         address recipient,
602         uint256 tAmount
603     ) private {
604         (
605             uint256 rAmount,
606             uint256 rTransferAmount,
607             uint256 tTransferAmount,
608             uint256 tLiquidity
609         ) = _getValues(tAmount);
610         _rOwned[sender] = _rOwned[sender].sub(rAmount);
611         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
612         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
613         _takeLiquidity(tLiquidity);
614         emit Transfer(sender, recipient, tTransferAmount);
615         if (tLiquidity > 0) {
616             emit Transfer(sender, address(this), tLiquidity);
617         }
618     }
619 
620     function _transferFromExcluded(
621         address sender,
622         address recipient,
623         uint256 tAmount
624     ) private {
625         (
626             uint256 rAmount,
627             uint256 rTransferAmount,
628             uint256 tTransferAmount,
629             uint256 tLiquidity
630         ) = _getValues(tAmount);
631         _tOwned[sender] = _tOwned[sender].sub(tAmount);
632         _rOwned[sender] = _rOwned[sender].sub(rAmount);
633         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
634         _takeLiquidity(tLiquidity);
635         emit Transfer(sender, recipient, tTransferAmount);
636         if (tLiquidity > 0) {
637             emit Transfer(sender, address(this), tLiquidity);
638         }
639     }
640 
641     function _transferBothExcluded(
642         address sender,
643         address recipient,
644         uint256 tAmount
645     ) private {
646         (
647             uint256 rAmount,
648             uint256 rTransferAmount,
649             uint256 tTransferAmount,
650             uint256 tLiquidity
651         ) = _getValues(tAmount);
652         _tOwned[sender] = _tOwned[sender].sub(tAmount);
653         _rOwned[sender] = _rOwned[sender].sub(rAmount);
654         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
655         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
656         _takeLiquidity(tLiquidity);
657         emit Transfer(sender, recipient, tTransferAmount);
658         if (tLiquidity > 0) {
659             emit Transfer(sender, address(this), tLiquidity);
660         }
661     }
662 
663     function _getValues(
664         uint256 tAmount
665     ) private view returns (uint256, uint256, uint256, uint256) {
666         (uint256 tTransferAmount, uint256 tLiquidity) = _getTValues(tAmount);
667         (uint256 rAmount, uint256 rTransferAmount) = _getRValues(
668             tAmount,
669             tLiquidity,
670             _getRate()
671         );
672         return (rAmount, rTransferAmount, tTransferAmount, tLiquidity);
673     }
674 
675     function _getTValues(
676         uint256 tAmount
677     ) private view returns (uint256, uint256) {
678         uint256 tLiquidity = calculateLiquidityFee(tAmount);
679         uint256 tTransferAmount = tAmount.sub(tLiquidity);
680         return (tTransferAmount, tLiquidity);
681     }
682 
683     function _getRValues(
684         uint256 tAmount,
685         uint256 tLiquidity,
686         uint256 currentRate
687     ) private pure returns (uint256, uint256) {
688         uint256 rAmount = tAmount.mul(currentRate);
689         uint256 rLiquidity = tLiquidity.mul(currentRate);
690         uint256 rTransferAmount = rAmount.sub(rLiquidity);
691         return (rAmount, rTransferAmount);
692     }
693 
694     function _getRate() private view returns (uint256) {
695         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
696         return rSupply.div(tSupply);
697     }
698 
699     function _getCurrentSupply() private view returns (uint256, uint256) {
700         uint256 rSupply = _rTotal;
701         uint256 tSupply = _tTotal;
702         for (uint256 i = 0; i < _excluded.length; i++) {
703             if (
704                 _rOwned[_excluded[i]] > rSupply ||
705                 _tOwned[_excluded[i]] > tSupply
706             ) return (_rTotal, _tTotal);
707             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
708             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
709         }
710         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
711         return (rSupply, tSupply);
712     }
713 
714     function _takeLiquidity(uint256 tLiquidity) private {
715         uint256 currentRate = _getRate();
716         uint256 rLiquidity = tLiquidity.mul(currentRate);
717         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
718         if (_isExcluded[address(this)]) {
719             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
720         }
721     }
722 
723     function calculateLiquidityFee(
724         uint256 _amount
725     ) private view returns (uint256) {
726         uint256 fees = _liquidityFeeBuys.add(_marketingFeeBuys).add(_devFeeBuys);
727         return _amount.mul(fees).div(1000);
728     }
729 
730     function isExcludedFromFee(
731         address account
732     ) public view onlyOwner returns (bool) {
733         return _feeWhitelisted[account];
734     }
735 
736     function excludeFromFee(address account) public onlyOwner {
737         _feeWhitelisted[account] = true;
738     }
739 
740     function includeInFee(address account) public onlyOwner {
741         _feeWhitelisted[account] = false;
742     }
743 
744     function removeAllFee() private {
745         _liquidityFeeBuys = 0;
746         _marketingFeeBuys = 0;
747         _devFeeBuys = 0;
748     }
749 
750     function restoreAllFee() private {
751         _liquidityFeeBuys = buyFeesBackup[0];
752         _marketingFeeBuys = buyFeesBackup[1];
753         _devFeeBuys = buyFeesBackup[2];
754     }
755 
756     function setSellFee() private {
757         _liquidityFeeBuys = _liquidityFeeSells;
758         _marketingFeeBuys = _marketingFeeSells;
759         _devFeeBuys = _devFeeSells;
760     }
761 
762     function setWalletToWalletTransferFee() private {
763         _liquidityFeeBuys = _liquidityTokens;
764         _marketingFeeBuys = _marketingTokens;
765         _devFeeBuys = _devTokens;
766     }
767 
768     function _setBuyFees(
769         uint256 _liquidityFee,
770         uint256 _marketingFee,
771         uint256 _devFee
772     ) external onlyOwner {
773         _liquidityFeeBuys = _liquidityFee;
774         _marketingFeeBuys = _marketingFee;
775         _devFeeBuys = _devFee;
776         buyFeesBackup = [_liquidityFeeBuys, _marketingFeeBuys, _devFeeBuys];
777         uint256 totalFee = _liquidityFee.add(_marketingFee).add(_devFee);
778         _totalFeeBuys = _liquidityFeeBuys + _marketingFeeBuys + _devFeeBuys;
779         require(totalFee <= 700, "Too High Fee");
780     }
781 
782     function _setSellFees(
783         uint256 _liquidityFee,
784         uint256 _marketingFee,
785         uint256 _devFee
786     ) external onlyOwner {
787         _liquidityFeeSells = _liquidityFee;
788         _marketingFeeSells = _marketingFee;
789         _devFeeSells = _devFee;
790         uint256 totalFee = _liquidityFee.add(_marketingFee).add(_devFee);
791         _totalFeeSells = _liquidityFeeSells + _marketingFeeSells + _devFeeSells;
792         require(totalFee <= 700, "Too High Fee");
793     }
794 
795     function _setTransferFees(
796         uint256 _liquidityFee,
797         uint256 _marketingFee,
798         uint256 _devFee
799     ) external onlyOwner {
800         _liquidityTokens = _liquidityFee;
801         _marketingTokens = _marketingFee;
802         _devTokens = _devFee;
803         transferTotalFee = _liquidityTokens + _marketingTokens + _devTokens;
804         uint256 totalFee = _liquidityFee.add(_marketingFee).add(_devFee);
805         require(totalFee <= 100, "Too High Fee");
806     }
807 
808     function setMaxTxAmount(uint256 maxTxAmount) external onlyOwner {
809         _txLimit = maxTxAmount;
810         require(_txLimit >= _tTotal.div(5), "Too low limit");
811     }
812 
813     function setMinimumTokensBeforeSwap(
814         uint256 __minBalanceForSwapback
815     ) external onlyOwner {
816         _minBalanceForSwapback = __minBalanceForSwapback;
817     }
818 
819     function setMarketingWallet(address _marketingWallet) external onlyOwner {
820         marketingWallet = payable(_marketingWallet);
821     }
822 
823     function setDevAWallet(address _devWallet) external onlyOwner {
824         devWallet = payable(_devWallet);
825     }
826 
827     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
828         swapAndLiquifyEnabled = _enabled;
829         emit SwapAndLiquifyEnabledUpdated(_enabled);
830     }
831 
832     function excludeWalletsFromWhales() private {
833         _limitWhitelisted[owner()] = true;
834         _limitWhitelisted[address(this)] = true;
835         _limitWhitelisted[uniPair] = true;
836         _limitWhitelisted[devWallet] = true;
837         _limitWhitelisted[marketingWallet] = true;
838     }
839 
840     function checkForWhale(
841         address from,
842         address to,
843         uint256 amount
844     ) private view {
845         uint256 newBalance = balanceOf(to).add(amount);
846         if (!_limitWhitelisted[from] && !_limitWhitelisted[to]) {
847             require(
848                 newBalance <= _walletLimit,
849                 "Exceeding max tokens limit in the wallet"
850             );
851         }
852         if (from == uniPair && !_limitWhitelisted[to]) {
853             require(
854                 newBalance <= _walletLimit,
855                 "Exceeding max tokens limit in the wallet"
856             );
857         }
858     }
859 
860     function setExcludedFromWhale(
861         address account,
862         bool _enabled
863     ) public onlyOwner {
864         _limitWhitelisted[account] = _enabled;
865     }
866 
867     function setWalletMaxHoldingLimit(uint256 _amount) public onlyOwner {
868         _walletLimit = _amount;
869         require(
870             _walletLimit > _tTotal.div(100).mul(1),
871             "Too less limit"
872         ); //min 1%
873     }
874 
875     function rescueStuckBalance() public onlyOwner {
876         (bool success, ) = msg.sender.call{value: address(this).balance}("");
877         require(success, "Transfer failed.");
878     }
879 
880     function triggerSwapback() public {
881         uint256 allBalance = balanceOf(address(this));
882         swapTokens(allBalance);
883     }
884 
885     receive() external payable {}
886 }