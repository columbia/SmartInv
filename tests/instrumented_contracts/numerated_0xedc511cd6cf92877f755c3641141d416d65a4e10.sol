1 /**
2  *Submitted for verification at Etherscan.io on 2022-03-20
3 */
4 
5 // SPDX-License-Identifier: GNU
6 pragma solidity ^0.8.4;
7 
8 interface IERC20 {
9   function totalSupply() external view returns (uint256);
10 
11   function decimals() external view returns (uint8);
12 
13   function symbol() external view returns (string memory);
14 
15   function name() external view returns (string memory);
16 
17   function getowner() external view returns (address);
18 
19   function balanceOf(address account) external view returns (uint256);
20 
21   function transfer(address recipient, uint256 amount) external returns (bool);
22 
23   function allowance(address _owner, address spender)
24     external
25     view
26     returns (uint256);
27 
28   function approve(address spender, uint256 amount) external returns (bool);
29 
30   function transferFrom(
31     address sender,
32     address recipient,
33     uint256 amount
34   ) external returns (bool);
35 
36   event Transfer(address indexed from, address indexed to, uint256 value);
37   event Approval(address indexed owner, address indexed spender, uint256 value);
38 }
39 
40 interface IUniswapERC20 {
41   event Approval(address indexed owner, address indexed spender, uint256 value);
42   event Transfer(address indexed from, address indexed to, uint256 value);
43 
44   function name() external pure returns (string memory);
45 
46   function symbol() external pure returns (string memory);
47 
48   function decimals() external pure returns (uint8);
49 
50   function totalSupply() external view returns (uint256);
51 
52   function balanceOf(address owner) external view returns (uint256);
53 
54   function allowance(address owner, address spender)
55     external
56     view
57     returns (uint256);
58 
59   function approve(address spender, uint256 value) external returns (bool);
60 
61   function transfer(address to, uint256 value) external returns (bool);
62 
63   function transferFrom(
64     address from,
65     address to,
66     uint256 value
67   ) external returns (bool);
68 
69   function DOMAIN_SEPARATOR() external view returns (bytes32);
70 
71   function PERMIT_TYPEHASH() external pure returns (bytes32);
72 
73   function nonces(address owner) external view returns (uint256);
74 
75   function permit(
76     address owner,
77     address spender,
78     uint256 value,
79     uint256 deadline,
80     uint8 v,
81     bytes32 r,
82     bytes32 s
83   ) external;
84 }
85 
86 interface IUniswapFactory {
87   event PairCreated(
88     address indexed token0,
89     address indexed token1,
90     address pair,
91     uint256
92   );
93 
94   function feeTo() external view returns (address);
95 
96   function feeToSetter() external view returns (address);
97 
98   function getPair(address tokenA, address tokenB)
99     external
100     view
101     returns (address pair);
102 
103   function allPairs(uint256) external view returns (address pair);
104 
105   function allPairsLength() external view returns (uint256);
106 
107   function createPair(address tokenA, address tokenB)
108     external
109     returns (address pair);
110 
111   function setFeeTo(address) external;
112 
113   function setFeeToSetter(address) external;
114 }
115 
116 interface IUniswapRouter01 {
117   function addLiquidity(
118     address tokenA,
119     address tokenB,
120     uint256 amountADesired,
121     uint256 amountBDesired,
122     uint256 amountAMin,
123     uint256 amountBMin,
124     address to,
125     uint256 deadline
126   )
127     external
128     returns (
129       uint256 amountA,
130       uint256 amountB,
131       uint256 liquidity
132     );
133 
134   function addLiquidityETH(
135     address token,
136     uint256 amountTokenDesired,
137     uint256 amountTokenMin,
138     uint256 amountETHMin,
139     address to,
140     uint256 deadline
141   )
142     external
143     payable
144     returns (
145       uint256 amountToken,
146       uint256 amountETH,
147       uint256 liquidity
148     );
149 
150   function removeLiquidity(
151     address tokenA,
152     address tokenB,
153     uint256 liquidity,
154     uint256 amountAMin,
155     uint256 amountBMin,
156     address to,
157     uint256 deadline
158   ) external returns (uint256 amountA, uint256 amountB);
159 
160   function removeLiquidityETH(
161     address token,
162     uint256 liquidity,
163     uint256 amountTokenMin,
164     uint256 amountETHMin,
165     address to,
166     uint256 deadline
167   ) external returns (uint256 amountToken, uint256 amountETH);
168 
169   function removeLiquidityWithPermit(
170     address tokenA,
171     address tokenB,
172     uint256 liquidity,
173     uint256 amountAMin,
174     uint256 amountBMin,
175     address to,
176     uint256 deadline,
177     bool approveMax,
178     uint8 v,
179     bytes32 r,
180     bytes32 s
181   ) external returns (uint256 amountA, uint256 amountB);
182 
183   function removeLiquidityETHWithPermit(
184     address token,
185     uint256 liquidity,
186     uint256 amountTokenMin,
187     uint256 amountETHMin,
188     address to,
189     uint256 deadline,
190     bool approveMax,
191     uint8 v,
192     bytes32 r,
193     bytes32 s
194   ) external returns (uint256 amountToken, uint256 amountETH);
195 
196   function swapExactTokensForTokens(
197     uint256 amountIn,
198     uint256 amountOutMin,
199     address[] calldata path,
200     address to,
201     uint256 deadline
202   ) external returns (uint256[] memory amounts);
203 
204   function swapTokensForExactTokens(
205     uint256 amountOut,
206     uint256 amountInMax,
207     address[] calldata path,
208     address to,
209     uint256 deadline
210   ) external returns (uint256[] memory amounts);
211 
212   function swapExactETHForTokens(
213     uint256 amountOutMin,
214     address[] calldata path,
215     address to,
216     uint256 deadline
217   ) external payable returns (uint256[] memory amounts);
218 
219   function swapTokensForExactETH(
220     uint256 amountOut,
221     uint256 amountInMax,
222     address[] calldata path,
223     address to,
224     uint256 deadline
225   ) external returns (uint256[] memory amounts);
226 
227   function swapExactTokensForETH(
228     uint256 amountIn,
229     uint256 amountOutMin,
230     address[] calldata path,
231     address to,
232     uint256 deadline
233   ) external returns (uint256[] memory amounts);
234 
235   function swapETHForExactTokens(
236     uint256 amountOut,
237     address[] calldata path,
238     address to,
239     uint256 deadline
240   ) external payable returns (uint256[] memory amounts);
241 
242   function factory() external pure returns (address);
243 
244   function WETH() external pure returns (address);
245 
246   function quote(
247     uint256 amountA,
248     uint256 reserveA,
249     uint256 reserveB
250   ) external pure returns (uint256 amountB);
251 
252   function getamountOut(
253     uint256 amountIn,
254     uint256 reserveIn,
255     uint256 reserveOut
256   ) external pure returns (uint256 amountOut);
257 
258   function getamountIn(
259     uint256 amountOut,
260     uint256 reserveIn,
261     uint256 reserveOut
262   ) external pure returns (uint256 amountIn);
263 
264   function getamountsOut(uint256 amountIn, address[] calldata path)
265     external
266     view
267     returns (uint256[] memory amounts);
268 
269   function getamountsIn(uint256 amountOut, address[] calldata path)
270     external
271     view
272     returns (uint256[] memory amounts);
273 }
274 
275 interface IUniswapRouter02 is IUniswapRouter01 {
276   function removeLiquidityETHSupportingFeeOnTransferTokens(
277     address token,
278     uint256 liquidity,
279     uint256 amountTokenMin,
280     uint256 amountETHMin,
281     address to,
282     uint256 deadline
283   ) external returns (uint256 amountETH);
284 
285   function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
286     address token,
287     uint256 liquidity,
288     uint256 amountTokenMin,
289     uint256 amountETHMin,
290     address to,
291     uint256 deadline,
292     bool approveMax,
293     uint8 v,
294     bytes32 r,
295     bytes32 s
296   ) external returns (uint256 amountETH);
297 
298   function swapExactTokensForTokensSupportingFeeOnTransferTokens(
299     uint256 amountIn,
300     uint256 amountOutMin,
301     address[] calldata path,
302     address to,
303     uint256 deadline
304   ) external;
305 
306   function swapExactETHForTokensSupportingFeeOnTransferTokens(
307     uint256 amountOutMin,
308     address[] calldata path,
309     address to,
310     uint256 deadline
311   ) external payable;
312 
313   function swapExactTokensForETHSupportingFeeOnTransferTokens(
314     uint256 amountIn,
315     uint256 amountOutMin,
316     address[] calldata path,
317     address to,
318     uint256 deadline
319   ) external;
320 }
321 
322 contract protected {
323 
324     mapping (address => bool) is_auth;
325 
326     function authorized(address addy) public view returns(bool) {
327         return is_auth[addy];
328     }
329 
330     function set_authorized(address addy, bool booly) public onlyAuth {
331         is_auth[addy] = booly;
332     }
333 
334     modifier onlyAuth() {
335         require( is_auth[msg.sender] || msg.sender==owner, "not owner");
336         _;
337     }
338 
339     address owner;
340     modifier onlyowner {
341         require(msg.sender==owner, "not owner");
342         _;
343     }
344 
345     bool locked;
346     modifier safe() {
347         require(!locked, "reentrant");
348         locked = true;
349         _;
350         locked = false;
351     }
352 }
353 
354 
355 interface IUniswapV2Pair {
356   event Approval(address indexed owner, address indexed spender, uint value);
357   event Transfer(address indexed from, address indexed to, uint value);
358 
359   function name() external pure returns (string memory);
360   function symbol() external pure returns (string memory);
361   function decimals() external pure returns (uint8);
362   function totalSupply() external view returns (uint);
363   function balanceOf(address owner) external view returns (uint);
364   function allowance(address owner, address spender) external view returns (uint);
365 
366   function approve(address spender, uint value) external returns (bool);
367   function transfer(address to, uint value) external returns (bool);
368   function transferFrom(address from, address to, uint value) external returns (bool);
369 
370   function DOMAIN_SEPARATOR() external view returns (bytes32);
371   function PERMIT_TYPEHASH() external pure returns (bytes32);
372   function nonces(address owner) external view returns (uint);
373 
374   function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
375 
376   event Mint(address indexed sender, uint amount0, uint amount1);
377   event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
378   event Swap(
379       address indexed sender,
380       uint amount0In,
381       uint amount1In,
382       uint amount0Out,
383       uint amount1Out,
384       address indexed to
385   );
386   event Sync(uint112 reserve0, uint112 reserve1);
387 
388   function MINIMUM_LIQUIDITY() external pure returns (uint);
389   function factory() external view returns (address);
390   function token0() external view returns (address);
391   function token1() external view returns (address);
392   function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
393   function price0CumulativeLast() external view returns (uint);
394   function price1CumulativeLast() external view returns (uint);
395   function kLast() external view returns (uint);
396 
397   function mint(address to) external returns (uint liquidity);
398   function burn(address to) external returns (uint amount0, uint amount1);
399   function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
400   function skim(address to) external;
401   function sync() external;
402 }
403 
404 contract smart {
405     address router_address = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
406     IUniswapRouter02 router = IUniswapRouter02(router_address);
407 
408     function create_weth_pair(address token) private returns (address, IUniswapV2Pair) {
409        address pair_address = IUniswapFactory(router.factory()).createPair(token, router.WETH());
410        return (pair_address, IUniswapV2Pair(pair_address));
411     }
412 
413     function get_weth_reserve(address pair_address) private  view returns(uint, uint) {
414         IUniswapV2Pair pair = IUniswapV2Pair(pair_address);
415         uint112 token_reserve;
416         uint112 native_reserve;
417         uint32 last_timestamp;
418         (token_reserve, native_reserve, last_timestamp) = pair.getReserves();
419         return (token_reserve, native_reserve);
420     }
421 
422     function get_weth_price_impact(address token, uint amount, bool sell) public view returns(uint) {
423         address pair_address = IUniswapFactory(router.factory()).getPair(token, router.WETH());
424         (uint res_token, uint res_weth) = get_weth_reserve(pair_address);
425         uint impact;
426         if(sell) {
427             impact = (amount * 100) / res_token;
428         } else {
429             impact = (amount * 100) / res_weth;
430         }
431         return impact;
432     }
433 }
434 
435 contract charge is IERC20, protected, smart {
436 
437   mapping(address => uint256) private _balances;
438   mapping(address => mapping(address => uint256)) private _allowances;
439   mapping(address => uint256) private _sellLock;
440   
441   // Exclusions
442   mapping(address => bool) isBalanceFree;
443   mapping(address => bool) isMarketMakerTaxFree;
444   mapping(address => bool) isMarketingTaxFree;
445   mapping(address => bool) isRewardTaxFree;
446   mapping(address => bool) isAuthorized;
447   mapping(address => bool) isWhitelisted;
448   mapping (address => bool)  private _excluded;
449   mapping (address => bool)  private _whiteList;
450   mapping (address => bool)  private _excludedFromSellLock;
451   mapping (address => bool)  private _excludedFromDistributing;
452   uint excludedAmount;
453   mapping(address => bool) public _blacklist;
454   mapping(address => bool) public isOpen;
455   bool isBlacklist = true;
456   string private constant _name = "Charge";
457   string private constant _symbol = "CHRG";
458   uint8 private constant _decimals = 9;
459   uint256 public constant InitialSupply = 100 * 10**9 * 10**_decimals;
460   uint8 public constant BalanceLimitDivider = 25;
461   uint16 public constant SellLimitDivider = 200;
462   uint16 public constant MaxSellLockTime = 120 seconds;
463   mapping(uint8 => mapping(address => bool)) public is_claimable;
464   address public constant UniswapRouterAddy =
465     0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
466   address public constant Dead = 0x000000000000000000000000000000000000dEaD;
467   address public rewardWallet_one =0x48727b7f64Badb9fe12fCdf95b20A0ee681a065D;
468   address public rewardWallet_two = 0x3584584b89352A40998652f1EF2Ee3878AD2fdFc;
469   address public marketingWallet = 0xDB2471b955E0Ee21f2D91Bd2B07d57a2f52B0d56;
470   address public marketMakerWallet = 0xa1E89769eA01919D61530360b2210E656DD263A0;
471   bool blacklist_enabled = true;
472   mapping(address => uint8) is_slot;
473   uint256 private _circulatingSupply = InitialSupply;
474   uint256 public balanceLimit = _circulatingSupply;
475   uint256 public sellLimit = _circulatingSupply;
476   uint256 public qtyTokenToSwap = (sellLimit * 10) / 100;
477   uint256 public swapTreshold = qtyTokenToSwap;
478   uint256 public portionLimit;
479   bool manualTokenToSwap = false;
480   uint256 manualQtyTokenToSwap = (sellLimit * 10) / 100;
481   bool sellAll = false;
482   bool sellPeg = true;
483   bool botKiller = true;
484   uint8 public constant MaxTax = 25;
485   uint8 private _buyTax;
486   uint8 private _sellTax;
487   uint8 private _portionTax;
488   uint8 private _transferTax;
489   uint8 private _marketMakerTax;
490   uint8 private _liquidityTax;
491   uint8 private _marketingTax;
492   uint8 private _stakeTax_one;
493   uint8 private _stakeTax_two;
494 
495   uint8 public impactTreshold;
496   bool public enabledImpactTreshold;
497 
498   address private _UniswapPairAddress;
499   IUniswapRouter02 private _UniswapRouter;
500 
501 
502   constructor() {
503     uint256 deployerBalance = _circulatingSupply;
504     _balances[msg.sender] = deployerBalance;
505     emit Transfer(address(0), msg.sender, deployerBalance);
506 
507     _UniswapRouter = IUniswapRouter02(UniswapRouterAddy);
508 
509     _UniswapPairAddress = IUniswapFactory(_UniswapRouter.factory()).createPair(
510       address(this),
511       _UniswapRouter.WETH()
512     );
513 
514     _excludedFromSellLock[rewardWallet_one] = true;
515     _excludedFromSellLock[rewardWallet_two] = true;
516     _excludedFromSellLock[marketingWallet] = true;
517     _excludedFromSellLock[marketMakerWallet] = true;
518     _excludedFromDistributing[0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D] = true;
519 
520     balanceLimit = InitialSupply / BalanceLimitDivider;
521     sellLimit = InitialSupply / SellLimitDivider;
522 
523     sellLockTime = 90 seconds;
524 
525     _buyTax = 0;
526     _sellTax = 15;
527     _portionTax = 20;
528     _transferTax = 15;
529 
530     _liquidityTax = 1;
531     _marketingTax = 20;
532     _marketMakerTax = 19;
533     _stakeTax_one =30;
534     _stakeTax_two =30;
535 
536     impactTreshold = 2;
537     portionLimit = 20;
538 
539     _excluded[msg.sender] = true;
540 
541     _excludedFromDistributing[address(_UniswapRouter)] = true;
542     _excludedFromDistributing[_UniswapPairAddress] = true;
543     _excludedFromDistributing[address(this)] = true;
544     _excludedFromDistributing[0x000000000000000000000000000000000000dEaD] = true;
545 
546     owner = msg.sender;
547     is_auth[owner] = true;
548   }
549 
550  function _transfer(address sender, address recipient, uint256 amount) private{
551         require(sender != address(0), "Transfer from zero");
552         require(recipient != address(0), "Transfer to zero");
553         if(isBlacklist) {
554             require(!_blacklist[sender] && !_blacklist[recipient], "Blacklisted!");
555         }
556 
557 
558         bool isExcluded = (_excluded[sender] || _excluded[recipient] || is_auth[sender] || is_auth[recipient]);
559 
560         bool isContractTransfer=(sender==address(this) || recipient==address(this));
561 
562         bool isLiquidityTransfer = ((sender == _UniswapPairAddress && recipient == UniswapRouterAddy)
563         || (recipient == _UniswapPairAddress && sender == UniswapRouterAddy));
564 
565         bool swapped = false;
566         if(isContractTransfer || isLiquidityTransfer || isExcluded ){
567             _feelessTransfer(sender, recipient, amount,  is_slot[sender]);
568             swapped = true;
569         }
570       
571       if(!swapped) {
572         if (!tradingEnabled) {
573                 bool isBuy1=sender==_UniswapPairAddress|| sender == UniswapRouterAddy;
574                 bool isSell1=recipient==_UniswapPairAddress|| recipient == UniswapRouterAddy;
575                   
576                   if (isOpen[sender] ||isOpen[recipient]||isOpen[msg.sender]) {
577                     _taxedTransfer(sender,recipient,amount,isBuy1,isSell1);}
578                   else{
579                           require(tradingEnabled,"trading not yet enabled");
580                   }
581             }
582             
583             else{     
584               bool isBuy=sender==_UniswapPairAddress|| sender == UniswapRouterAddy;
585               bool isSell=recipient==_UniswapPairAddress|| recipient == UniswapRouterAddy;
586               _taxedTransfer(sender,recipient,amount,isBuy,isSell);}
587         }
588       }
589 
590   
591 
592   function get_paid(address addy) public view returns(uint) {
593         uint8 slot = is_slot[addy];
594         return (profitPerShare[(slot*1)] * _balances[addy]);
595   }
596 
597 
598   function _taxedTransfer(
599     address sender,
600     address recipient,
601     uint256 amount,
602     bool isBuy,
603     bool isSell
604   ) private {
605     uint8 slot = is_slot[sender];
606     uint256 recipientBalance = _balances[recipient];
607     uint256 senderBalance = _balances[sender];
608     require(senderBalance >= amount, "Transfer exceeds balance");
609     uint8 tax;
610 
611     uint8 impact = uint8(get_weth_price_impact(address(this), amount, isSell));
612 
613     if (isSell) {
614       if (!_excludedFromSellLock[sender]) {
615         require(
616           _sellLock[sender] <= block.timestamp || sellLockDisabled,
617           "Seller in sellLock"
618         );
619 
620         _sellLock[sender] = block.timestamp + sellLockTime;
621       }
622 
623       require(amount <= sellLimit, "Dump protection");
624       uint availableSupply = InitialSupply - _balances[Dead] - _balances[address(this)];
625       uint portionControl = (availableSupply/1000) * portionLimit;
626       if(amount >= portionControl) {
627         tax = _portionTax;
628       } else {
629         tax = _sellTax;
630         if(enabledImpactTreshold) {
631             if(impact > impactTreshold) {
632                 tax = tax + ((3 * impact)/2 - impactTreshold  );
633             }
634         }
635       }
636     } else if (isBuy) { 
637 	 if (!_excludedFromSellLock[sender]) {
638         require(
639           _sellLock[sender] <= block.timestamp || sellLockDisabled,
640           "Seller in sellLock"
641         );
642 
643         _sellLock[sender] = block.timestamp + sellLockTime;
644       }
645       require(amount <= sellLimit, "Dump protection");
646       if (!isBalanceFree[recipient]) {
647         require(recipientBalance + amount <= balanceLimit, "whale protection");
648       }
649       tax = _buyTax;
650     } else {
651       if (!isBalanceFree[recipient]) {
652         require(recipientBalance + amount <= balanceLimit, "whale protection");
653       }
654       require(recipientBalance + amount <= balanceLimit, "whale protection");
655 
656       if (!_excludedFromSellLock[sender])
657         require(
658           _sellLock[sender] <= block.timestamp || sellLockDisabled,
659           "Sender in Lock"
660         ); 
661       tax = _transferTax;
662     }
663 
664     if (
665       (sender != _UniswapPairAddress) &&
666       (!manualConversion) &&
667       (!_isSwappingContractModifier) &&
668       isSell
669     ) {
670       if (_balances[address(this)] >= swapTreshold) {
671         _swapContractToken(amount);
672       }
673     }
674     uint8 actualmarketMakerTax = 0;
675     uint8 actualMarketingTax = 0;
676     if (!isMarketingTaxFree[sender]) {
677       actualMarketingTax = _marketingTax;
678     }
679     if (!isMarketMakerTaxFree[sender]) {
680       actualmarketMakerTax = _marketMakerTax;
681     }
682     uint8 stakeTax;
683     if (slot == 0) {
684       stakeTax = _stakeTax_one;
685     } else if (slot == 1) {
686       stakeTax = _stakeTax_two;
687     }
688 
689     uint256 contractToken = _calculateFee(
690       amount,
691       tax,
692         _liquidityTax +
693         actualMarketingTax +
694         actualmarketMakerTax +
695         _stakeTax_one +
696         _stakeTax_two
697     );
698     uint256 taxedAmount = amount - (contractToken);
699 
700     _removeToken(sender, amount, slot);
701 
702     _balances[address(this)] += contractToken;
703 
704     _addToken(recipient, taxedAmount, slot);
705 
706     emit Transfer(sender, recipient, taxedAmount);
707   }
708 
709   function _feelessTransfer(
710     address sender,
711     address recipient,
712     uint256 amount,
713     uint8 slot
714   ) private {
715     uint256 senderBalance = _balances[sender];
716     require(senderBalance >= amount, "Transfer exceeds balance");
717 
718     _removeToken(sender, amount, slot);
719 
720     _addToken(recipient, amount, slot);
721 
722     emit Transfer(sender, recipient, amount);
723   }
724 
725   function _calculateFee(
726     uint256 amount,
727     uint8 tax,
728     uint8 taxPercent
729   ) private pure returns (uint256) {
730     return (amount * tax * taxPercent) / 10000;
731   }
732 
733   bool private _isWithdrawing;
734   uint256 private constant DistributionMultiplier = 2**64;
735   mapping(uint8 => uint256) public profitPerShare;
736   uint256 public totalDistributingReward;
737   uint256 public oneDistributingReward;
738   uint256 public twoDistributingReward;
739   uint256 public totalPayouts;
740   uint256 public marketingBalance;
741   uint256 public marketMakerBalance;
742   mapping(uint8 => uint256) rewardBalance;
743   mapping(address => mapping(uint256 => uint256)) private alreadyPaidShares;
744   mapping(address => uint256) private toERCaid;
745 
746   function isExcludedFromDistributing(address addr) public view returns (bool) {
747     return _excludedFromDistributing[addr];
748   }
749 
750   function _getTotalShares() public view returns (uint256) {
751     uint256 shares = _circulatingSupply;
752     shares -=  excludedAmount;
753     return shares;
754   }
755 
756   function _addToken(
757     address addr,
758     uint256 amount,
759     uint8 slot
760   ) private {
761     uint256 newAmount = _balances[addr] + amount;
762 
763     if (_excludedFromDistributing[addr]) {
764       _balances[addr] = newAmount;
765       return;
766     }
767 
768     uint256 payment = _newDividentsOf(addr, slot);
769 
770     alreadyPaidShares[addr][slot] = profitPerShare[slot] * newAmount;
771 
772     toERCaid[addr] += payment;
773 
774     _balances[addr] = newAmount;
775   }
776 
777   function _removeToken(
778     address addr,
779     uint256 amount,
780     uint8 slot
781   ) private {
782     uint256 newAmount = _balances[addr] - amount;
783 
784     if (_excludedFromDistributing[addr]) {
785       _balances[addr] = newAmount;
786       return;
787     }
788 
789     uint256 payment = _newDividentsOf(addr, slot);
790 
791     _balances[addr] = newAmount;
792 
793     alreadyPaidShares[addr][slot] = profitPerShare[slot] * newAmount;
794 
795     toERCaid[addr] += payment;
796   }
797 
798   function _newDividentsOf(address staker, uint8 slot)
799     private
800     view
801     returns (uint256)
802   {
803     uint256 fullPayout = profitPerShare[slot] * _balances[staker];
804 
805     if (fullPayout < alreadyPaidShares[staker][slot]) return 0;
806     return
807       (fullPayout - alreadyPaidShares[staker][slot]) / DistributionMultiplier;
808   }
809 
810   function _distributeStake(uint256 ETHamount) private {
811     uint256 marketingSplit = (ETHamount * _marketingTax) / 100;
812     uint256 marketMakerSplit = (ETHamount * _marketMakerTax) / 100;
813     uint256 amount_one = (ETHamount * _stakeTax_one) / 100;
814     uint256 amount_two = (ETHamount * _stakeTax_two) / 100;
815     marketingBalance += marketingSplit;
816     marketMakerBalance += marketMakerSplit;
817 
818     if (amount_one > 0) {
819       totalDistributingReward += amount_one;
820       oneDistributingReward += amount_one;
821       uint256 totalShares = _getTotalShares();
822       if (totalShares == 0) {
823         marketingBalance += amount_one;
824       } else {
825         profitPerShare[0] += ((amount_one * DistributionMultiplier) /
826           totalShares);
827         rewardBalance[0] += amount_one;
828       }
829     }
830 
831     if (amount_two > 0) {
832       totalDistributingReward += amount_two;
833       twoDistributingReward += amount_two;
834       uint256 totalShares = _getTotalShares();
835       if (totalShares == 0) {
836         marketingBalance += amount_two;
837       } else {
838         profitPerShare[1] += ((amount_two * DistributionMultiplier) /
839           totalShares);
840         rewardBalance[1] += amount_two;
841       }
842     }
843 
844   }
845 
846   event OnWithdrawFarmedToken(uint256 amount, address recipient);
847 
848   ///@dev Claim tokens correspondant to a slot, if enabled
849   function claimFarmedToken(
850     address addr,
851     address tkn,
852     uint8 slot
853   ) private {
854     if (slot == 1) {
855       require(isAuthorized[addr], "You cant retrieve it");
856     }
857     require(!_isWithdrawing);
858     require(is_claimable[slot][tkn], "Not enabled");
859     _isWithdrawing = true;
860     uint256 amount;
861     if (_excludedFromDistributing[addr]) {
862       amount = toERCaid[addr];
863       toERCaid[addr] = 0;
864     } else {
865       uint256 newAmount = _newDividentsOf(addr, slot);
866 
867       alreadyPaidShares[addr][slot] = profitPerShare[slot] * _balances[addr];
868 
869       amount = toERCaid[addr] + newAmount;
870       toERCaid[addr] = 0;
871     }
872     if (amount == 0) {
873       _isWithdrawing = false;
874       return;
875     }
876     totalPayouts += amount;
877     address[] memory path = new address[](2);
878     path[0] = _UniswapRouter.WETH();
879     path[1] = tkn;
880     _UniswapRouter.swapExactETHForTokensSupportingFeeOnTransferTokens{
881       value: amount
882     }(0, path, addr, block.timestamp);
883 
884     emit OnWithdrawFarmedToken(amount, addr);
885     _isWithdrawing = false;
886   }
887 
888   uint256 public totalLPETH;
889   bool private _isSwappingContractModifier;
890   modifier lockTheSwap() {
891     _isSwappingContractModifier = true;
892     _;
893     _isSwappingContractModifier = false;
894   }
895 
896   function _swapContractToken(uint256 sellAmount)
897     private
898     lockTheSwap
899   {
900     uint256 contractBalance = _balances[address(this)];
901     uint16 totalTax = _liquidityTax +  _stakeTax_one + _stakeTax_two;
902 
903     uint256 tokenToSwap = (sellLimit * 10) / 100;
904     if (manualTokenToSwap) {
905       tokenToSwap = manualQtyTokenToSwap;
906     } 
907 
908     bool prevSellPeg = sellPeg;
909     if (sellPeg) {
910       if (tokenToSwap > sellAmount) {
911         tokenToSwap = sellAmount / 2;
912       }
913     }
914     sellPeg = prevSellPeg;
915     if (sellAll) {
916     tokenToSwap = contractBalance - 1;
917   }
918     
919 
920     if (contractBalance < tokenToSwap || totalTax == 0) {
921       return;
922     }
923 
924     uint256 tokenForLiquidity = (tokenToSwap * _liquidityTax) / totalTax;
925     uint256 tokenForMarketing = (tokenToSwap * _marketingTax) / totalTax;
926     uint256 tokenForMarketMaker = (tokenToSwap * _marketMakerTax) / totalTax;
927     uint256 swapToken = tokenForLiquidity +
928       tokenForMarketing +
929       tokenForMarketMaker;
930     // Avoid solidity imprecisions
931     if (swapToken >= tokenToSwap) {
932       tokenForMarketMaker -= (tokenToSwap - (swapToken));
933     }
934 
935     uint256 liqToken = tokenForLiquidity / 2;
936     uint256 liqETHToken = tokenForLiquidity - liqToken;
937 
938     swapToken = liqETHToken + tokenForMarketing + tokenForMarketMaker;
939 
940     uint256 initialETHBalance = address(this).balance;
941     _swapTokenForETH(swapToken);
942     uint256 newETH = (address(this).balance - initialETHBalance);
943 
944     uint256 liqETH = (newETH * liqETHToken) / swapToken;
945     _addLiquidity(liqToken, liqETH);
946 
947     _distributeStake(address(this).balance - initialETHBalance);
948   }
949 
950   function _swapTokenForETH(uint256 amount) private {
951     _approve(address(this), address(_UniswapRouter), amount);
952     address[] memory path = new address[](2);
953     path[0] = address(this);
954     path[1] = _UniswapRouter.WETH();
955     _UniswapRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
956       amount,
957       0,
958       path,
959       address(this),
960       block.timestamp
961     );
962   }
963 
964   function _addLiquidity(uint256 tokenamount, uint256 ETHamount) private {
965     totalLPETH += ETHamount;
966     _approve(address(this), address(_UniswapRouter), tokenamount);
967     _UniswapRouter.addLiquidityETH{value: ETHamount}(
968       address(this),
969       tokenamount,
970       0,
971       0,
972       address(this),
973       block.timestamp
974     );
975   }
976 
977   function getLimits() public view returns (uint256 balance, uint256 sell) {
978     return (balanceLimit / 10**_decimals, sellLimit / 10**_decimals);
979   }
980 
981   function getTaxes()
982     public
983     view
984     returns (
985       uint256 marketingTax,
986       uint256 marketMakerTax,
987       uint256 liquidityTax,
988       uint256 stakeTax_one,
989         uint256 stakeTax_two,
990  uint256 buyTax,
991       uint256 sellTax,
992       uint256 transferTax
993     )
994   {
995     return (
996       _marketingTax,
997       _marketMakerTax,
998       _liquidityTax,
999       _stakeTax_one,
1000       _stakeTax_two,
1001       _buyTax,
1002       _sellTax,
1003       _transferTax
1004     );
1005   }
1006 
1007   function getWhitelistedStatus(address AddressToCheck)
1008     public
1009     view
1010     returns (bool)
1011   {
1012     return _whiteList[AddressToCheck];
1013   }
1014 
1015   function getAddressSellLockTimeInSeconds(address AddressToCheck)
1016     public
1017     view
1018     returns (uint256)
1019   {
1020     uint256 lockTime = _sellLock[AddressToCheck];
1021     if (lockTime <= block.timestamp) {
1022       return 0;
1023     }
1024     return lockTime - block.timestamp;
1025   }
1026 
1027   function getSellLockTimeInSeconds() public view returns (uint256) {
1028     return sellLockTime;
1029   }
1030 
1031   ///@dev Reset cooldown for an address
1032   function AddressResetSellLock() public {
1033     _sellLock[msg.sender] = block.timestamp + sellLockTime;
1034   }
1035 
1036   ///@dev Retrieve slot 1
1037   function FarmedTokenWithdrawSlotOne(address tkn) public {
1038     claimFarmedToken(msg.sender, tkn, 0);
1039   }
1040 
1041   
1042   ///@dev Retrieve slot 2
1043   function FarmedTokenWithdrawSlotTwo(address tkn) public {
1044     claimFarmedToken(msg.sender, tkn, 1);
1045   }
1046 
1047   function getDividends(address addr, uint8 slot)
1048     public
1049     view
1050     returns (uint256)
1051   {
1052     if (_excludedFromDistributing[addr]) return toERCaid[addr];
1053     return _newDividentsOf(addr, slot) + toERCaid[addr];
1054   }
1055 
1056   bool public sellLockDisabled;
1057   uint256 public sellLockTime;
1058   bool public manualConversion;
1059  
1060   ///@dev Airdrop tokens
1061   function airdropAddresses(
1062     address[] memory addys,
1063     address token,
1064     uint256 qty
1065   ) public onlyAuth {
1066     uint256 single_drop = qty / addys.length;
1067     IERC20 airtoken = IERC20(token);
1068     bool sent;
1069     for (uint256 i; i <= (addys.length - 1); i++) {
1070       sent = airtoken.transfer(addys[i], single_drop);
1071       require(sent);
1072       sent = false;
1073     }
1074   }
1075 
1076   ///@dev Airdrop a N of addresses
1077   function airdropAddressesNative(address[] memory addys)
1078     public
1079     payable
1080     onlyAuth
1081   {
1082     uint256 qty = msg.value;
1083     uint256 single_drop = qty / addys.length;
1084     bool sent;
1085     for (uint256 i; i <= (addys.length - 1); i++) {
1086       sent = payable(addys[i]).send(single_drop);
1087       require(sent);
1088       sent = false;
1089     }
1090   }
1091 
1092   ///@dev Enable pools for a token
1093   function ControlEnabledClaims(
1094     uint8 slot,
1095     address tkn,
1096     bool booly
1097   ) public onlyAuth {
1098     is_claimable[slot][tkn] = booly;
1099   }
1100 
1101   ///@dev Rekt all the snipers
1102   function ControlBotKiller(bool booly) public onlyAuth {
1103     botKiller = booly;
1104   }
1105 
1106   ///@dev Minimum tokens to sell
1107   function ControlSetSwapTreshold(uint256 treshold) public onlyAuth {
1108     swapTreshold = treshold * 10**_decimals;
1109   }
1110 
1111   ///@dev Exclude from distribution
1112   function ControlExcludeFromDistributing(address addr, uint8 slot)
1113     public
1114     onlyAuth
1115   {
1116     require(_excludedFromDistributing[addr]);
1117     uint256 newDividents = _newDividentsOf(addr, slot);
1118     alreadyPaidShares[addr][slot] = _balances[addr] * profitPerShare[slot];
1119     toERCaid[addr] += newDividents;
1120     _excludedFromDistributing[addr] = true;
1121     excludedAmount += _balances[addr];
1122   }
1123 
1124   ///@dev Include into distribution
1125   function ControlIncludeToDistributing(address addr, uint8 slot)
1126     public
1127     onlyAuth
1128   {
1129     require(_excludedFromDistributing[addr]);
1130     _excludedFromDistributing[addr] = false;
1131     excludedAmount -= _balances[addr];
1132 
1133     alreadyPaidShares[addr][slot] = _balances[addr] * profitPerShare[slot];
1134   }
1135 
1136   ///@dev Take out the marketing balance
1137   function ControlWithdrawMarketingETH() public onlyAuth {
1138     uint256 amount = marketingBalance;
1139     marketingBalance = 0;
1140     (bool sent, ) = marketingWallet.call{value: (amount)}("");
1141     require(sent, "withdraw failed");
1142   }
1143 
1144   ///@dev Peg sells to the tx
1145   function ControlSwapSetSellPeg(bool setter) public onlyAuth {
1146     sellPeg = setter;
1147   }
1148 
1149   ///@dev Set marketing tax free or not
1150   function ControlSetMarketingTaxFree(address addy, bool booly)
1151     public
1152     onlyAuth
1153   {
1154     isMarketingTaxFree[addy] = booly;
1155   }
1156 
1157   ///@dev Set an address into or out marketmaker fee
1158   function ControlSetMarketMakerTaxFree(address addy, bool booly)
1159     public
1160     onlyAuth
1161   {
1162     isMarketMakerTaxFree[addy] = booly;
1163   }
1164 
1165   ///@dev Disable tax reward for address
1166   function ControlSetRewardTaxFree(address addy, bool booly) public onlyAuth {
1167     isRewardTaxFree[addy] = booly;
1168   }
1169 
1170   ///@dev Disable address balance limit
1171   function ControlSetBalanceFree(address addy, bool booly) public onlyAuth {
1172     isBalanceFree[addy] = booly;
1173   }
1174 
1175   ///@dev Enable or disable manual sell
1176   function ControlSwapSetManualLiqSell(bool setter) public onlyAuth {
1177     manualTokenToSwap = setter;
1178   }
1179 
1180   ///@dev Turn sells into manual
1181   function ControlSwapSetManualLiqSellTokens(uint256 amount) public onlyAuth {
1182     require(amount > 1 && amount < 100000000, "Values between 1 and 100000000");
1183     manualQtyTokenToSwap = amount * 10**_decimals;
1184   }
1185 
1186   ///@dev Disable auto sells
1187   function ControlSwapSwitchManualETHConversion(bool manual) public onlyAuth {
1188     manualConversion = manual;
1189   }
1190 
1191   ///@dev Set cooldown on or off (ONCE)
1192   function ControlDisableSellLock(bool disabled) public onlyAuth {
1193     sellLockDisabled = disabled;
1194   }
1195 
1196   ///@dev Set cooldown
1197   function ControlSetSellLockTime(uint256 sellLockSeconds) public onlyAuth {
1198     require(sellLockSeconds <= MaxSellLockTime, "Sell Lock time too high");
1199     sellLockTime = sellLockSeconds;
1200   }
1201 
1202 
1203   ///@dev Set taxes
1204   function ControlSetTaxes(
1205     uint8 buyTax,
1206     uint8 sellTax,
1207     uint8 portionTax,
1208     uint8 transferTax
1209   ) public onlyAuth {
1210     require(
1211       buyTax <= MaxTax && sellTax <= MaxTax && transferTax <= MaxTax,
1212       "taxes higher than max tax"
1213     );
1214 
1215     _buyTax = buyTax;
1216     _sellTax = sellTax;
1217     _portionTax = portionTax;
1218     _transferTax = transferTax;
1219   }
1220 
1221   function ControlSetShares(
1222     uint8 marketingTaxes,
1223     uint8 marketMakerTaxes,
1224     uint8 liquidityTaxes,
1225     uint8 stakeTaxes_one,
1226     uint8 stakeTaxes_two) public onlyAuth {
1227 
1228      uint8 totalTax = marketingTaxes +
1229       marketMakerTaxes +
1230       liquidityTaxes +
1231       stakeTaxes_one +
1232       stakeTaxes_two;
1233     require(totalTax == 100, "total taxes needs to equal 100%");
1234 
1235     require(marketingTaxes <= 55, "Max 55%");
1236     require(marketMakerTaxes <= 55, "Max 45%");
1237     require(stakeTaxes_one <= 55, "Max 45%");
1238     require(stakeTaxes_two <= 55, "Max 45%");
1239 
1240     _marketingTax = marketingTaxes;
1241     _marketMakerTax = marketMakerTaxes;
1242     _liquidityTax = liquidityTaxes;
1243     _stakeTax_one = stakeTaxes_one;
1244     _stakeTax_two = stakeTaxes_two;
1245   }
1246 function SetPortionLimit(uint256 _portionlimit) public onlyAuth { 
1247 	 portionLimit = _portionlimit ;
1248   }
1249   ///@dev Manually sell and create LP
1250   function ControlCreateLPandETH() public onlyAuth {
1251     _swapContractToken(192919291929192919291929192919291929);
1252   }
1253 
1254   ///@dev Manually sell all tokens gathered
1255   function ControlSellAllTokens() public onlyAuth {
1256     sellAll = true;
1257     _swapContractToken(192919291929192919291929192919291929);
1258     sellAll = false;
1259   }
1260 
1261   ///@dev Free from fees
1262   function ControlExcludeAccountFromFees(address account) public onlyAuth {
1263     _excluded[account] = true;
1264   }
1265 
1266   ///@dev Include in fees
1267   function ControlIncludeAccountToFees(address account) public onlyAuth {
1268     _excluded[account] = true;
1269   }
1270 
1271   ///@dev Exclude from cooldown
1272   function ControlExcludeAccountFromSellLock(address account) public onlyAuth {
1273     _excludedFromSellLock[account] = true;
1274   }
1275 
1276   ///@dev Enable cooldown
1277   function ControlIncludeAccountToSellLock(address account) public onlyAuth {
1278     _excludedFromSellLock[account] = true;
1279   }
1280 
1281   ///@dev Enable or disable pool 2 for an address
1282   function ControlIncludeAccountToSubset(address account, bool booly)
1283     public
1284     onlyAuth
1285   {
1286     isAuthorized[account] = booly;
1287   }
1288 
1289   ///@dev Control all the tx, buy and sell limits
1290   function ControlUpdateLimits(uint256 newBalanceLimit, uint256 newSellLimit)
1291     public
1292     onlyAuth
1293   {
1294     newBalanceLimit = newBalanceLimit * 10**_decimals;
1295     newSellLimit = newSellLimit * 10**_decimals;
1296 
1297    
1298     balanceLimit = newBalanceLimit;
1299     sellLimit = newSellLimit;
1300   }
1301 
1302   bool public tradingEnabled;
1303   address private _liquidityTokenAddress;
1304 
1305 
1306   function setMarketingWallet(address addy) public onlyAuth {
1307     marketingWallet = addy;
1308     _excludedFromSellLock[marketingWallet] = true;
1309   }
1310   function setMarketMakingWallet(address addy) public onlyAuth {
1311     marketMakerWallet = addy;
1312     _excludedFromSellLock[marketMakerWallet] = true;
1313   }
1314     function setSlotOneWallet(address addy) public onlyAuth {
1315     rewardWallet_one = addy;
1316     _excludedFromSellLock[rewardWallet_one] = true;
1317   }
1318     function setSlotTwoWallet(address addy) public onlyAuth {
1319     rewardWallet_two = addy;
1320     _excludedFromSellLock[rewardWallet_two] = true;
1321   }
1322 
1323   ///@dev Start/stop trading
1324   function SetupEnableTrading(bool booly) public onlyAuth {
1325     tradingEnabled = booly;
1326   }
1327 
1328   ///@dev Define a new liquidity pair
1329   function SetupLiquidityTokenAddress(address liquidityTokenAddress)
1330     public
1331     onlyAuth
1332   {
1333     _liquidityTokenAddress = liquidityTokenAddress;
1334   }
1335 
1336   ///@dev Add to WL
1337   function SetupAddToWhitelist(address addressToAdd) public onlyAuth {
1338     _whiteList[addressToAdd] = true;
1339   }
1340 
1341   ///@dev Remove from whitelist
1342   function SetupRemoveFromWhitelist(address addressToRemove) public onlyAuth {
1343     _whiteList[addressToRemove] = false;
1344   }
1345 
1346   ///@dev Take back tokens stuck into the contract
1347   function rescueTokens(address tknAddress) public onlyAuth {
1348     IERC20 token = IERC20(tknAddress);
1349     uint256 ourBalance = token.balanceOf(address(this));
1350     require(ourBalance > 0, "No tokens in our balance");
1351     token.transfer(msg.sender, ourBalance);
1352   }
1353 
1354   ///@dev Disable PERMANENTLY blacklist functions
1355   function disableBlacklist() public onlyAuth {
1356     isBlacklist = false;
1357   }
1358 
1359   ///@dev Blacklist someone
1360   function setBlacklistedAddress(address toBlacklist) public onlyAuth {
1361     _blacklist[toBlacklist] = true;
1362   }
1363 
1364   ///@dev Remove from blacklist
1365   function removeBlacklistedAddress(address toRemove) public onlyAuth {
1366     _blacklist[toRemove] = false;
1367   }
1368 
1369   ///@dev Block or unblock an address
1370  /* function setisOpen(address addy, bool booly) public onlyAuth {
1371     isOpen[addy] = booly;
1372   }*/
1373     function setisOpenArry(address[] calldata addy, bool[] calldata booly) public onlyAuth {
1374         for(uint256 i; i < addy.length; i++){
1375             isOpen[addy[i]] = booly[i];
1376         }
1377         }
1378 
1379   function setImpactTreshold(uint8 inty) public onlyAuth {
1380       impactTreshold = inty;
1381   }
1382 
1383   function enableImpactTreshold(bool booly) public onlyAuth {
1384       enabledImpactTreshold = booly;
1385   }
1386 
1387   ///@dev Remove the balance remaining in the contract
1388   function ControlRemoveRemainingETH() public onlyAuth {
1389     (bool sent, ) = owner.call{value: (address(this).balance)}("");
1390     require(sent);
1391   }
1392 
1393   receive() external payable {}
1394 
1395   fallback() external payable {}
1396 
1397   function getowner() external view override returns (address) {
1398     return owner;
1399   }
1400 
1401   function name() external pure override returns (string memory) {
1402     return _name;
1403   }
1404 
1405   function symbol() external pure override returns (string memory) {
1406     return _symbol;
1407   }
1408 
1409   function decimals() external pure override returns (uint8) {
1410     return _decimals;
1411   }
1412 
1413   function totalSupply() external view override returns (uint256) {
1414     return _circulatingSupply;
1415   }
1416 
1417   function balanceOf(address account) external view override returns (uint256) {
1418     return _balances[account];
1419   }
1420 
1421   function transfer(address recipient, uint256 amount)
1422     external
1423     override
1424     returns (bool)
1425   {
1426     _transfer(msg.sender, recipient, amount);
1427     return true;
1428   }
1429 
1430   function allowance(address _owner, address spender)
1431     external
1432     view
1433     override
1434     returns (uint256)
1435   {
1436     return _allowances[_owner][spender];
1437   }
1438 
1439   function approve(address spender, uint256 amount)
1440     external
1441     override
1442     returns (bool)
1443   {
1444     _approve(msg.sender, spender, amount);
1445     return true;
1446   }
1447 
1448   function _approve(
1449     address _owner,
1450     address spender,
1451     uint256 amount
1452   ) private {
1453     require(_owner != address(0), "Approve from zero");
1454     require(spender != address(0), "Approve to zero");
1455     _allowances[_owner][spender] = amount;
1456     emit Approval(_owner, spender, amount);
1457   }
1458 
1459   function transferFrom(
1460     address sender,
1461     address recipient,
1462     uint256 amount
1463   ) external override returns (bool) {
1464     _transfer(sender, recipient, amount);
1465     uint256 currentAllowance = _allowances[sender][msg.sender];
1466     require(currentAllowance >= amount, "Transfer > allowance");
1467     _approve(sender, msg.sender, currentAllowance - amount);
1468     return true;
1469   }
1470 
1471   function increaseAllowance(address spender, uint256 addedValue)
1472     external
1473     returns (bool)
1474   {
1475     _approve(
1476       msg.sender,
1477       spender,
1478       _allowances[msg.sender][spender] + addedValue
1479     );
1480     return true;
1481   }
1482 
1483   function decreaseAllowance(address spender, uint256 subtractedValue)
1484     external
1485     returns (bool)
1486   {
1487     uint256 currentAllowance = _allowances[msg.sender][spender];
1488     require(currentAllowance >= subtractedValue, "<0 allowance");
1489     _approve(msg.sender, spender, currentAllowance - subtractedValue);
1490     return true;
1491   }
1492 
1493 }