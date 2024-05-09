1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.16;
4 
5 interface IERC20 {
6     function totalSupply() external view returns (uint256);
7 
8     function balanceOf(address account) external view returns (uint256);
9 
10     function transfer(
11         address recipient,
12         uint256 amount
13     ) external returns (bool);
14 
15     function allowance(
16         address owner,
17         address spender
18     ) external view returns (uint256);
19 
20     function approve(address spender, uint256 amount) external returns (bool);
21 
22     function transferFrom(
23         address sender,
24         address recipient,
25         uint256 amount
26     ) external returns (bool);
27 
28     event Transfer(address indexed from, address indexed to, uint256 value);
29     event Approval(
30         address indexed owner,
31         address indexed spender,
32         uint256 value
33     );
34 }
35 
36 interface Token {
37     function transferFrom(address, address, uint) external returns (bool);
38 
39     function transfer(address, uint) external returns (bool);
40 }
41 
42 interface IUniswapV2Factory {
43     function createPair(
44         address tokenA,
45         address tokenB
46     ) external returns (address pair);
47 }
48 
49 interface IUniswapV2Router02 {
50     function swapExactTokensForETCSupportingFeeOnTransferTokens(
51         uint256 amountIn,
52         uint256 amountOutMin,
53         address[] calldata path,
54         address to,
55         uint256 deadline
56     ) external payable;
57 
58     function swapExactTokensForAVAXSupportingFeeOnTransferTokens(
59         uint256 amountIn,
60         uint256 amountOutMin,
61         address[] calldata path,
62         address to,
63         uint256 deadline
64     ) external payable;
65 
66     function swapExactTokensForROSESupportingFeeOnTransferTokens(
67         uint256 amountIn,
68         uint256 amountOutMin,
69         address[] calldata path,
70         address to,
71         uint256 deadline
72     ) external payable;
73 
74     function swapExactTokensForETHSupportingFeeOnTransferTokens(
75         uint256 amountIn,
76         uint256 amountOutMin,
77         address[] calldata path,
78         address to,
79         uint256 deadline
80     ) external;
81 
82     function swapExactETHForTokens(
83         uint256 amountOutMin,
84         address[] calldata path,
85         address to,
86         uint256 deadline
87     ) external payable returns (uint256[] memory amounts);
88 
89     function addLiquidityETH(
90         address token,
91         uint256 amountTokenDesired,
92         uint256 amountTokenMin,
93         uint256 amountETHMin,
94         address to,
95         uint256 deadline
96     )
97         external
98         payable
99         returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
100 
101     function factory() external pure returns (address);
102 
103     function WETH() external pure returns (address);
104 
105     function WETC() external pure returns (address);
106 
107     function WHT() external pure returns (address);
108 
109     function WROSE() external pure returns (address);
110 
111     function WAVAX() external pure returns (address);
112 }
113 
114 contract Ownable {
115     address private _owner;
116 
117     constructor() {
118         _owner = msg.sender;
119         emit OwnershipTransferred(address(0), msg.sender);
120     }
121 
122     function owner() public view returns (address) {
123         return _owner;
124     }
125 
126     modifier onlyOwner() {
127         require(_owner == msg.sender, "Caller is not the owner");
128         _;
129     }
130 
131     function renounceOwnership() public virtual onlyOwner {
132         emit OwnershipTransferred(_owner, address(0));
133         _owner = address(0);
134     }
135 
136     event OwnershipTransferred(
137         address indexed previousOwner,
138         address indexed newOwner
139     );
140 
141     function transferOwnership(address newOwner) public virtual onlyOwner {
142         require(
143             newOwner != address(0x0),
144             "call the renounceOwnership for zero address"
145         );
146 
147         emit OwnershipTransferred(_owner, newOwner);
148         _owner = newOwner;
149     }
150 }
151 
152 abstract contract BaseToken {
153     event TokenCreated(
154         address indexed owner,
155         address indexed token,
156         string tokenType,
157         uint256 version
158     );
159 }
160 
161 abstract contract CoinscopeBuyback {
162     address public constant COINSCOPE_ADDRESS =
163         0xD41C4805A9A3128f9F7A7074Da25965371Ba50d5;
164 
165     IUniswapV2Router02 public constant BSC_PANCAKE_ROUTER =
166         IUniswapV2Router02(0x10ED43C718714eb63d5aA57B78B54704E256024E);
167 
168     event CoinscopeBuybackRejectedSwapBalance();
169     event CoinscopeBuybackApproved(
170         uint256 amountToken,
171         uint256 amountETH,
172         uint256 liquidity,
173         uint256 ownerAmountReceiveed
174     );
175     event CoinscopeBuybackRejectedLiquidity();
176     event CoinscopeBuybackRejectedSwap();
177 
178     function coinscopeBuyback(
179         address recepient,
180         address platformFeeReceiver,
181         uint8 feeShare
182     ) internal {
183         if (block.chainid != 56 || address(this).balance == 0 || feeShare > 100)
184             return;
185 
186         address[] memory path = new address[](2);
187         path[0] = BSC_PANCAKE_ROUTER.WETH();
188         path[1] = COINSCOPE_ADDRESS;
189 
190         uint256 swapAmount = (address(this).balance * feeShare) / 100;
191 
192         try
193             BSC_PANCAKE_ROUTER.swapExactETHForTokens{value: swapAmount}(
194                 0,
195                 path,
196                 address(this),
197                 block.timestamp
198             )
199         returns (uint256[] memory amounts) {
200             uint256 coinscopeBalance = amounts[amounts.length - 1];
201 
202             if (coinscopeBalance == 0) {
203                 emit CoinscopeBuybackRejectedSwapBalance();
204                 return;
205             }
206 
207             uint256 ownerTokens = coinscopeBalance / 100;
208 
209             IERC20 coinscopeToken = IERC20(COINSCOPE_ADDRESS);
210 
211             require(
212                 coinscopeToken.transfer(recepient, ownerTokens),
213                 "Coinscope tokens should transferred to owner"
214             );
215 
216             coinscopeBalance = coinscopeToken.balanceOf(address(this));
217 
218             require(
219                 coinscopeToken.approve(
220                     address(BSC_PANCAKE_ROUTER),
221                     coinscopeBalance
222                 ),
223                 "Coinscope allowance should be approved"
224             );
225 
226             try
227                 BSC_PANCAKE_ROUTER.addLiquidityETH{
228                     value: address(this).balance
229                 }(
230                     COINSCOPE_ADDRESS,
231                     coinscopeBalance,
232                     0,
233                     0,
234                     platformFeeReceiver,
235                     block.timestamp
236                 )
237             returns (
238                 uint256 amountToken,
239                 uint256 amountETH,
240                 uint256 liquidity
241             ) {
242                 emit CoinscopeBuybackApproved(
243                     amountToken,
244                     amountETH,
245                     liquidity,
246                     ownerTokens
247                 );
248             } catch {
249                 emit CoinscopeBuybackRejectedLiquidity();
250             }
251         } catch {
252             emit CoinscopeBuybackRejectedSwap();
253         }
254     }
255 }
256 
257 contract Redis is IERC20, Ownable, BaseToken, CoinscopeBuyback {
258     uint256 public constant VERSION = 1;
259 
260     mapping(address => uint256) private rOwned;
261     mapping(address => mapping(address => uint256)) private _allowances;
262     mapping(address => bool) private _isExcludedFromFee;
263 
264     uint256 private constant MAX = ~uint256(0);
265     uint256 private immutable tTotal;
266     uint256 private rTotal;
267 
268     uint16 public reflectionTax;
269     uint16 public treasuryTax;
270 
271     string private _name;
272     string private _symbol;
273     uint8 private immutable _decimals;
274 
275     address payable public treasuryAddress;
276 
277     IUniswapV2Router02 public uniswapV2Router;
278     address public immutable uniswapV2Pair;
279 
280     bool private inSwap = false;
281     bool public swapEnabled = true;
282 
283     event UpdatedTreasuryWallet(address indexed account);
284     event ChangedFees(uint16 reflectionTax, uint16 treasuryTax);
285     event ChangedSwapEnable(bool enable);
286     event ExcludedAccountsFromFees(address[] accounts, bool excluded);
287     event WithdrawedTokens(
288         address indexed token,
289         address indexed to,
290         uint amount
291     );
292     event SwapError(uint256 amount);
293     event Reflected(address sender, uint256 amount);
294 
295     modifier lockTheSwap() {
296         inSwap = true;
297         _;
298         inSwap = false;
299     }
300 
301     constructor(
302         string memory name_,
303         string memory symbol_,
304         uint8 decimals_,
305         uint256 totalSupply_,
306         address router_,
307         address treasuryAddress_,
308         uint16 reflectionTax_,
309         uint16 treasuryTax_,
310         address feeReceiver,
311         uint8 feeShare
312     ) payable {
313         require(
314             treasuryAddress_ != address(0x0),
315             "treasury address cannot be zero"
316         );
317 
318         require(decimals_ != 0, "decimals should not be zero");
319         validateFees(reflectionTax_, treasuryTax_);
320 
321         _name = name_;
322         _symbol = symbol_;
323         _decimals = decimals_;
324 
325         tTotal = totalSupply_;
326         rTotal = (MAX - (MAX % totalSupply_));
327 
328         rOwned[msg.sender] = rTotal;
329 
330         uniswapV2Router = IUniswapV2Router02(router_);
331 
332         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(
333             address(this),
334             getNativeCurrency()
335         );
336 
337         treasuryAddress = payable(treasuryAddress_);
338 
339         reflectionTax = reflectionTax_;
340         treasuryTax = treasuryTax_;
341 
342         _isExcludedFromFee[owner()] = true;
343         _isExcludedFromFee[address(this)] = true;
344         _isExcludedFromFee[treasuryAddress_] = true;
345 
346         emit Transfer(address(0x0), msg.sender, totalSupply_);
347 
348         emit TokenCreated(owner(), address(this), "redis", VERSION);
349 
350         if (feeReceiver == address(0x0)) return;
351 
352         coinscopeBuyback(owner(), feeReceiver, feeShare);
353         payable(feeReceiver).transfer(address(this).balance);
354     }
355 
356     function getNativeCurrency() internal view returns (address) {
357         if (block.chainid == 61) {
358             //etc
359             return uniswapV2Router.WETC();
360         } else if (block.chainid == 128) {
361             //heco chain
362             return uniswapV2Router.WHT();
363         } else if (block.chainid == 42262) {
364             //oasis
365             return uniswapV2Router.WROSE();
366         } else if (block.chainid == 43114 || block.chainid == 43113) {
367             //avalance
368             return uniswapV2Router.WAVAX();
369         } else {
370             return uniswapV2Router.WETH();
371         }
372     }
373 
374     function name() public view returns (string memory) {
375         return _name;
376     }
377 
378     function symbol() public view returns (string memory) {
379         return _symbol;
380     }
381 
382     function decimals() public view returns (uint8) {
383         return _decimals;
384     }
385 
386     function totalSupply() public view override returns (uint256) {
387         return tTotal;
388     }
389 
390     function balanceOf(address account) public view override returns (uint256) {
391         return tokenFromReflection(rOwned[account]);
392     }
393 
394     function transfer(
395         address recipient,
396         uint256 amount
397     ) public override returns (bool) {
398         _transfer(msg.sender, recipient, amount);
399         return true;
400     }
401 
402     function allowance(
403         address account,
404         address spender
405     ) public view override returns (uint256) {
406         return _allowances[account][spender];
407     }
408 
409     function approve(
410         address spender,
411         uint256 amount
412     ) public override returns (bool) {
413         _approve(msg.sender, spender, amount);
414         return true;
415     }
416 
417     function transferFrom(
418         address sender,
419         address recipient,
420         uint256 amount
421     ) public override returns (bool) {
422         uint256 senderAllowance = _allowances[sender][msg.sender];
423 
424         require(senderAllowance >= amount, "insufficient allowance");
425 
426         _approve(sender, msg.sender, senderAllowance - amount);
427 
428         _transfer(sender, recipient, amount);
429 
430         return true;
431     }
432 
433     function tokenFromReflection(
434         uint256 rAmount
435     ) private view returns (uint256) {
436         require(
437             rAmount <= rTotal,
438             "Amount must be less than total reflections"
439         );
440         uint256 currentRate = _getRate();
441         return rAmount / currentRate;
442     }
443 
444     function _approve(
445         address account,
446         address spender,
447         uint256 amount
448     ) private {
449         require(account != address(0), "ERC20: approve from the zero address");
450         require(spender != address(0), "ERC20: approve to the zero address");
451         _allowances[account][spender] = amount;
452         emit Approval(account, spender, amount);
453     }
454 
455     function _transfer(address from, address to, uint256 amount) private {
456         require(from != address(0), "ERC20: transfer from the zero address");
457         require(to != address(0), "ERC20: transfer to the zero address");
458         require(amount > 0, "Transfer amount must be greater than zero");
459 
460         if (
461             from != owner() &&
462             to != owner() &&
463             !inSwap &&
464             from != uniswapV2Pair &&
465             swapEnabled
466         ) {
467             uint256 contractTokenBalance = balanceOf(address(this));
468 
469             if (contractTokenBalance > 0)
470                 swapTokensForEth(contractTokenBalance);
471         }
472 
473         _transferStandard(from, to, amount);
474     }
475 
476     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
477         address[] memory path = new address[](2);
478         path[0] = address(this);
479         path[1] = getNativeCurrency();
480 
481         _approve(address(this), address(uniswapV2Router), tokenAmount);
482 
483         if (block.chainid == 61) {
484             //etc
485             try
486                 uniswapV2Router
487                     .swapExactTokensForETCSupportingFeeOnTransferTokens(
488                         tokenAmount,
489                         0, // accept any amount of ETH
490                         path,
491                         treasuryAddress,
492                         block.timestamp
493                     )
494             {} catch {
495                 emit SwapError(tokenAmount);
496             }
497         } else if (block.chainid == 42262) {
498             //oasis
499             try
500                 uniswapV2Router
501                     .swapExactTokensForROSESupportingFeeOnTransferTokens(
502                         tokenAmount,
503                         0, // accept any amount of ETH
504                         path,
505                         treasuryAddress,
506                         block.timestamp
507                     )
508             {} catch {
509                 emit SwapError(tokenAmount);
510             }
511         } else if (block.chainid == 43114 || block.chainid == 43113) {
512             //avalance
513             try
514                 uniswapV2Router
515                     .swapExactTokensForAVAXSupportingFeeOnTransferTokens(
516                         tokenAmount,
517                         0, // accept any amount of ETH
518                         path,
519                         treasuryAddress,
520                         block.timestamp
521                     )
522             {} catch {
523                 emit SwapError(tokenAmount);
524             }
525         } else {
526             try
527                 uniswapV2Router
528                     .swapExactTokensForETHSupportingFeeOnTransferTokens(
529                         tokenAmount,
530                         0, // accept any amount of ETH
531                         path,
532                         treasuryAddress,
533                         block.timestamp
534                     )
535             {} catch {
536                 emit SwapError(tokenAmount);
537             }
538         }
539     }
540 
541     function withdrawETH() external onlyOwner {
542         treasuryAddress.transfer(address(this).balance);
543     }
544 
545     function withdrawTokens(
546         address token,
547         address to,
548         uint amount
549     ) external onlyOwner {
550         require(IERC20(token).transfer(to, amount), "transfer rejected");
551 
552         emit WithdrawedTokens(token, to, amount);
553     }
554 
555     function setTreasuryAddress(address payable account) external onlyOwner {
556         require(account != address(0x0), "treasury address cannot be zero");
557 
558         treasuryAddress = account;
559         _isExcludedFromFee[account] = true;
560 
561         emit UpdatedTreasuryWallet(account);
562     }
563 
564     function _transferStandard(
565         address sender,
566         address recipient,
567         uint256 tAmount
568     ) private {
569         bool takeFee = !_isExcludedFromFee[sender] &&
570             !_isExcludedFromFee[recipient] &&
571             (sender == uniswapV2Pair || recipient == uniswapV2Pair) &&
572             !inSwap;
573 
574         (
575             uint256 rAmount,
576             uint256 rTransferAmount,
577             uint256 rReflection,
578             uint256 rTreasury,
579             uint256 tTransferAmount,
580             uint256 tReflection,
581             uint256 tTreasury
582         ) = _getValues(takeFee, tAmount);
583 
584         rOwned[sender] = rOwned[sender] - rAmount;
585         rOwned[recipient] = rOwned[recipient] + rTransferAmount;
586 
587         emit Transfer(sender, recipient, tTransferAmount);
588 
589         if (rTreasury > 0) {
590             rOwned[address(this)] = rOwned[address(this)] + rTreasury;
591             emit Transfer(sender, address(this), tTreasury);
592         }
593 
594         if (rReflection > 0) {
595             rTotal = rTotal - rReflection;
596             emit Reflected(sender, tReflection);
597         }
598     }
599 
600     receive() external payable {}
601 
602     function _getValues(
603         bool takeFees,
604         uint256 tAmount
605     )
606         private
607         view
608         returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256)
609     {
610         (
611             uint256 tTransferAmount,
612             uint256 tReflection,
613             uint256 tTreasury
614         ) = _getTValues(takeFees, tAmount);
615 
616         (
617             uint256 rAmount,
618             uint256 rTransferAmount,
619             uint256 rReflection,
620             uint256 rTreasury
621         ) = _getRValues(tAmount, tReflection, tTreasury);
622 
623         return (
624             rAmount,
625             rTransferAmount,
626             rReflection,
627             rTreasury,
628             tTransferAmount,
629             tReflection,
630             tTreasury
631         );
632     }
633 
634     function _getTValues(
635         bool takeFees,
636         uint256 tAmount
637     ) private view returns (uint256, uint256, uint256) {
638         if (!takeFees) return (tAmount, 0, 0);
639 
640         uint256 tReflection = (tAmount * reflectionTax) / 100;
641         uint256 tTreasury = (tAmount * treasuryTax) / 100;
642         uint256 tTransferAmount = tAmount - tReflection - tTreasury;
643         return (tTransferAmount, tReflection, tTreasury);
644     }
645 
646     function _getRValues(
647         uint256 tAmount,
648         uint256 tReflection,
649         uint256 tTreasury
650     ) private view returns (uint256, uint256, uint256, uint256) {
651         uint256 rate = _getRate();
652 
653         uint256 rAmount = tAmount * rate;
654         uint256 rReflection = tReflection * rate;
655         uint256 rTreasury = tTreasury * rate;
656         uint256 rTransferAmount = rAmount - rReflection - rTreasury;
657 
658         return (rAmount, rTransferAmount, rReflection, rTreasury);
659     }
660 
661     function _getRate() private view returns (uint256) {
662         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
663         return rSupply / tSupply;
664     }
665 
666     function _getCurrentSupply() private view returns (uint256, uint256) {
667         uint256 rSupply = rTotal;
668         uint256 tSupply = tTotal;
669         if (rSupply < rTotal / tTotal) return (rTotal, tTotal);
670         return (rSupply, tSupply);
671     }
672 
673     function manualSwap() external onlyOwner {
674         swapTokensForEth(balanceOf(address(this)));
675     }
676 
677     function setFee(
678         uint16 reflectionTax_,
679         uint16 treasuryTax_
680     ) public onlyOwner {
681         validateFees(reflectionTax_, treasuryTax_);
682 
683         reflectionTax = reflectionTax_;
684         treasuryTax = treasuryTax_;
685 
686         emit ChangedFees(reflectionTax_, treasuryTax_);
687     }
688 
689     function validateFees(
690         uint16 reflectionTax_,
691         uint16 treasuryTax_
692     ) internal pure {
693         require(
694             reflectionTax_ + treasuryTax_ <= 20,
695             "Fees cannot be greater than 20%"
696         );
697     }
698 
699     function toggleSwap(bool enable) external onlyOwner {
700         swapEnabled = enable;
701 
702         emit ChangedSwapEnable(enable);
703     }
704 
705     function excludeMultipleAccountsFromFees(
706         address[] calldata accounts,
707         bool excluded
708     ) external onlyOwner {
709         for (uint256 i = 0; i < accounts.length; i++) {
710             _isExcludedFromFee[accounts[i]] = excluded;
711         }
712 
713         emit ExcludedAccountsFromFees(accounts, excluded);
714     }
715 
716     function getExcludedFromFee(address account) external view returns (bool) {
717         return _isExcludedFromFee[account];
718     }
719 }