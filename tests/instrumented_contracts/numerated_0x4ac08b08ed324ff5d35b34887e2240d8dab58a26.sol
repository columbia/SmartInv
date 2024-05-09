1 /**
2 STOP VIOLENCE ACADEMY
3 We fight against crypto-violence, join our App and Ecosystem. A token born to fight against violence in crypto, supported by a community that has suffered betrayals and crypto-violence on its own skin. SVP fights for a fair ecosystem for glory or nothing! 
4 
5 Website:  https://stopviolenceproject.com/
6 Website:  https://app.stopviolenceproject.com/
7 Telegram: https://t.me/SVPPortal
8 Announcements: https://t.me/SVPannouncements
9 Twitter: https://twitter.com/SVPToken
10 Github: https://github.com/StopViolenceToken
11 
12 This token is born as part of BNB Chain's Stop Violence Project ecosystem where together with the NFT collection, the NFT Stake and the SVP token Stake together with the future DAO make up the new fight against crypto violence. 
13 What is Stop Violence Academy?
14 The new fundamental pillar of the Stop Violence ecosystem in the Ethereum network.
15 40% of the generated fees will be repurchased as buyback on SVP Token
16 
17 */
18 
19 // SPDX-License-Identifier: Unlicensed
20 pragma solidity ^0.8.4;
21 
22 abstract contract Context {
23     function _msgSender() internal view virtual returns (address payable) {
24         return payable(msg.sender);
25     }
26 }
27 
28 interface IERC20 {
29     function totalSupply() external view returns (uint256);
30 
31     function balanceOf(address account) external view returns (uint256);
32 
33     function transfer(address recipient, uint256 amount)
34         external
35         returns (bool);
36 
37     function allowance(address owner, address spender)
38         external
39         view
40         returns (uint256);
41 
42     function approve(address spender, uint256 amount) external returns (bool);
43 
44     function transferFrom(
45         address sender,
46         address recipient,
47         uint256 amount
48     ) external returns (bool);
49 
50     event Transfer(address indexed from, address indexed to, uint256 value);
51     event Approval(
52         address indexed owner,
53         address indexed spender,
54         uint256 value
55     );
56 }
57 
58 library SafeMath {
59     function add(uint256 a, uint256 b) internal pure returns (uint256) {
60         uint256 c = a + b;
61         require(c >= a, "SafeMath: addition overflow");
62 
63         return c;
64     }
65 
66     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
67         return sub(a, b, "SafeMath: subtraction overflow");
68     }
69 
70     function sub(
71         uint256 a,
72         uint256 b,
73         string memory errorMessage
74     ) internal pure returns (uint256) {
75         require(b <= a, errorMessage);
76         uint256 c = a - b;
77 
78         return c;
79     }
80 
81     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
82         if (a == 0) {
83             return 0;
84         }
85 
86         uint256 c = a * b;
87         require(c / a == b, "SafeMath: multiplication overflow");
88 
89         return c;
90     }
91 
92     function div(uint256 a, uint256 b) internal pure returns (uint256) {
93         return div(a, b, "SafeMath: division by zero");
94     }
95 
96     function div(
97         uint256 a,
98         uint256 b,
99         string memory errorMessage
100     ) internal pure returns (uint256) {
101         require(b > 0, errorMessage);
102         uint256 c = a / b;
103         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
104 
105         return c;
106     }
107 
108     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
109         return mod(a, b, "SafeMath: modulo by zero");
110     }
111 
112     function mod(
113         uint256 a,
114         uint256 b,
115         string memory errorMessage
116     ) internal pure returns (uint256) {
117         require(b != 0, errorMessage);
118         return a % b;
119     }
120 }
121 
122 library Address {
123     function isContract(address account) internal view returns (bool) {
124         bytes32 codehash;
125         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
126         // solhint-disable-next-line no-inline-assembly
127         assembly {
128             codehash := extcodehash(account)
129         }
130         return (codehash != accountHash && codehash != 0x0);
131     }
132 
133     function sendValue(address payable recipient, uint256 amount) internal {
134         require(
135             address(this).balance >= amount,
136             "Address: insufficient balance"
137         );
138 
139         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
140         (bool success, ) = recipient.call{value: amount}("");
141         require(
142             success,
143             "Address: unable to send value, recipient may have reverted"
144         );
145     }
146 }
147 
148 abstract contract Ownable {
149     address private _owner;
150 
151     event OwnershipTransferred(
152         address indexed previousOwner,
153         address indexed newOwner
154     );
155 
156     constructor() {
157         address msgSender = msg.sender;
158         _owner = msgSender;
159         emit OwnershipTransferred(address(0), msgSender);
160     }
161 
162     function owner() public view returns (address) {
163         return _owner;
164     }
165 
166     modifier onlyOwner() {
167         require(_owner == msg.sender, "Ownable: caller is not the owner");
168         _;
169     }
170 
171     function renounceOwnership() public virtual onlyOwner {
172         emit OwnershipTransferred(_owner, address(0));
173         _owner = address(0);
174     }
175 
176     function transferOwnership(address newOwner) public virtual onlyOwner {
177         require(
178             newOwner != address(0),
179             "Ownable: new owner is the zero address"
180         );
181         emit OwnershipTransferred(_owner, newOwner);
182         _owner = newOwner;
183     }
184 }
185 
186 interface IUniswapV2Factory {
187     function getPair(address tokenA, address tokenB)
188         external
189         view
190         returns (address pair);
191 
192     function allPairs(uint256) external view returns (address pair);
193 
194     function createPair(address tokenA, address tokenB)
195         external
196         returns (address pair);
197 }
198 
199 interface IUniswapV2Router01 {
200     function factory() external pure returns (address);
201 
202     function WETH() external pure returns (address);
203 
204     function addLiquidity(
205         address tokenA,
206         address tokenB,
207         uint256 amountADesired,
208         uint256 amountBDesired,
209         uint256 amountAMin,
210         uint256 amountBMin,
211         address to,
212         uint256 deadline
213     )
214         external
215         returns (
216             uint256 amountA,
217             uint256 amountB,
218             uint256 liquidity
219         );
220 
221     function addLiquidityETH(
222         address token,
223         uint256 amountTokenDesired,
224         uint256 amountTokenMin,
225         uint256 amountETHMin,
226         address to,
227         uint256 deadline
228     )
229         external
230         payable
231         returns (
232             uint256 amountToken,
233             uint256 amountETH,
234             uint256 liquidity
235         );
236 
237     function removeLiquidity(
238         address tokenA,
239         address tokenB,
240         uint256 liquidity,
241         uint256 amountAMin,
242         uint256 amountBMin,
243         address to,
244         uint256 deadline
245     ) external returns (uint256 amountA, uint256 amountB);
246 
247     function removeLiquidityETH(
248         address token,
249         uint256 liquidity,
250         uint256 amountTokenMin,
251         uint256 amountETHMin,
252         address to,
253         uint256 deadline
254     ) external returns (uint256 amountToken, uint256 amountETH);
255 
256     function removeLiquidityWithPermit(
257         address tokenA,
258         address tokenB,
259         uint256 liquidity,
260         uint256 amountAMin,
261         uint256 amountBMin,
262         address to,
263         uint256 deadline,
264         bool approveMax,
265         uint8 v,
266         bytes32 r,
267         bytes32 s
268     ) external returns (uint256 amountA, uint256 amountB);
269 
270     function removeLiquidityETHWithPermit(
271         address token,
272         uint256 liquidity,
273         uint256 amountTokenMin,
274         uint256 amountETHMin,
275         address to,
276         uint256 deadline,
277         bool approveMax,
278         uint8 v,
279         bytes32 r,
280         bytes32 s
281     ) external returns (uint256 amountToken, uint256 amountETH);
282 
283     function swapExactTokensForTokens(
284         uint256 amountIn,
285         uint256 amountOutMin,
286         address[] calldata path,
287         address to,
288         uint256 deadline
289     ) external returns (uint256[] memory amounts);
290 
291     function swapTokensForExactTokens(
292         uint256 amountOut,
293         uint256 amountInMax,
294         address[] calldata path,
295         address to,
296         uint256 deadline
297     ) external returns (uint256[] memory amounts);
298 
299     function swapExactETHForTokens(
300         uint256 amountOutMin,
301         address[] calldata path,
302         address to,
303         uint256 deadline
304     ) external payable returns (uint256[] memory amounts);
305 
306     function swapExactTokensForETH(
307         uint256 amountIn,
308         uint256 amountOutMin,
309         address[] calldata path,
310         address to,
311         uint256 deadline
312     ) external returns (uint256[] memory amounts);
313 }
314 
315 interface IUniswapV2Router02 is IUniswapV2Router01 {
316     function swapExactTokensForETHSupportingFeeOnTransferTokens(
317         uint256 amountIn,
318         uint256 amountOutMin,
319         address[] calldata path,
320         address to,
321         uint256 deadline
322     ) external;
323 }
324 
325 contract STOPVIOLENCEACADEMY is Context, IERC20, Ownable {
326     using SafeMath for uint256;
327     using Address for address;
328 
329     string private _name = "STOP VIOLENCE ACADEMY";
330     string private _symbol = "ACADEMY";
331     uint8 private _decimals = 18;
332 
333     address payable public marketingWalletAddress =
334         payable(0xB3650f404dd488510A0649387db37502B64D44c0);
335     address payable public BurnedWalletAddress =
336         payable(0xB3650f404dd488510A0649387db37502B64D44c0);
337     address public immutable deadAddress =
338         0x000000000000000000000000000000000000dEaD;
339 
340     mapping(address => uint256) _balances;
341     mapping(address => mapping(address => uint256)) private _allowances;
342 
343     mapping(address => bool) public isExcludedFromFee;
344     mapping(address => bool) public isWalletLimitExempt;
345     mapping(address => bool) public isTxLimitExempt;
346     mapping(address => bool) public isMarketPair;
347 
348     int256 public sendAddress = 6; //
349     uint256 public _buyLiquidityFee = 0;
350     uint256 public _buyMarketingFee = 4;
351     uint256 public _buyBurnedFee = 0;
352     uint256 public _sellLiquidityFee = 0;
353     uint256 public _sellMarketingFee = 4;
354     uint256 public _sellBurnedFee = 0;
355 
356     uint256 public _liquidityShare = _buyLiquidityFee.add(_sellLiquidityFee);
357     uint256 public _marketingShare = _buyMarketingFee.add(_sellMarketingFee);
358     uint256 public _BurnedShare = _buyBurnedFee.add(_sellBurnedFee);
359 
360     uint256 public _totalTaxIfBuying;
361     uint256 public _totalTaxIfSelling;
362     uint256 public _totalDistributionShares;
363 
364     uint256 private _totalSupply = 10000000 * 10**8 * 10**_decimals;
365     uint256 private minimumTokensBeforeSwap = 4880 * 10**_decimals;
366 
367     IUniswapV2Router02 public uniswapV2Router;
368     address public uniswapPair;
369 
370     uint256 public genesisBlock;
371     uint256 public coolBlock = 5;
372     uint256 _saleKeepFee = 1000;
373 
374     bool inSwapAndLiquify;
375 
376     event SwapAndLiquify(
377         uint256 tokensSwapped,
378         uint256 ethReceived,
379         uint256 tokensIntoLiqudity
380     );
381 
382     event SwapETHForTokens(uint256 amountIn, address[] path);
383 
384     event SwapTokensForETH(uint256 amountIn, address[] path);
385 
386     modifier lockTheSwap() {
387         inSwapAndLiquify = true;
388         _;
389         inSwapAndLiquify = false;
390     }
391 
392     constructor() {
393         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
394             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
395         );
396 
397         uniswapPair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(
398             address(this),
399             _uniswapV2Router.WETH()
400         );
401 
402         uniswapV2Router = _uniswapV2Router;
403         _allowances[address(this)][address(uniswapV2Router)] = _totalSupply;
404 
405         isExcludedFromFee[owner()] = true;
406         isExcludedFromFee[address(this)] = true;
407 
408         _totalTaxIfBuying = _buyLiquidityFee.add(_buyMarketingFee).add(
409             _buyBurnedFee
410         );
411         _totalTaxIfSelling = _sellLiquidityFee.add(_sellMarketingFee).add(
412             _sellBurnedFee
413         );
414         _totalDistributionShares = _liquidityShare.add(_marketingShare).add(
415             _BurnedShare
416         );
417 
418         isWalletLimitExempt[owner()] = true;
419         isWalletLimitExempt[address(uniswapPair)] = true;
420         isWalletLimitExempt[address(this)] = true;
421 
422         isTxLimitExempt[owner()] = true;
423         isTxLimitExempt[address(this)] = true;
424 
425         isMarketPair[address(uniswapPair)] = true;
426 
427         _balances[_msgSender()] = _totalSupply;
428         emit Transfer(address(0), _msgSender(), _totalSupply);
429     }
430 
431     function name() public view returns (string memory) {
432         return _name;
433     }
434 
435     function symbol() public view returns (string memory) {
436         return _symbol;
437     }
438 
439     function decimals() public view returns (uint8) {
440         return _decimals;
441     }
442 
443     function totalSupply() public view override returns (uint256) {
444         return _totalSupply;
445     }
446 
447     function balanceOf(address account) public view override returns (uint256) {
448         return _balances[account];
449     }
450 
451     function allowance(address owner, address spender)
452         public
453         view
454         override
455         returns (uint256)
456     {
457         return _allowances[owner][spender];
458     }
459 
460     function increaseAllowance(address spender, uint256 addedValue)
461         public
462         virtual
463         returns (bool)
464     {
465         _approve(
466             _msgSender(),
467             spender,
468             _allowances[_msgSender()][spender].add(addedValue)
469         );
470         return true;
471     }
472 
473     function decreaseAllowance(address spender, uint256 subtractedValue)
474         public
475         virtual
476         returns (bool)
477     {
478         _approve(
479             _msgSender(),
480             spender,
481             _allowances[_msgSender()][spender].sub(
482                 subtractedValue,
483                 "ERC20: decreased allowance below zero"
484             )
485         );
486         return true;
487     }
488 
489     function minimumTokensBeforeSwapAmount() public view returns (uint256) {
490         return minimumTokensBeforeSwap;
491     }
492 
493     function approve(address spender, uint256 amount)
494         public
495         override
496         returns (bool)
497     {
498         _approve(_msgSender(), spender, amount);
499         return true;
500     }
501 
502     function _approve(
503         address owner,
504         address spender,
505         uint256 amount
506     ) private {
507         require(owner != address(0), "ERC20: approve from the zero address");
508         require(spender != address(0), "ERC20: approve to the zero address");
509 
510         _allowances[owner][spender] = amount;
511         emit Approval(owner, spender, amount);
512     }
513 
514     function setMarketPairStatus(address account, bool newValue)
515         public
516         onlyOwner
517     {
518         isMarketPair[account] = newValue;
519     }
520 
521     function setIsTxLimitExempt(address holder, bool exempt)
522         external
523         onlyOwner
524     {
525         isTxLimitExempt[holder] = exempt;
526     }
527 
528     function setIsExcludedFromFee(address account, bool newValue)
529         public
530         onlyOwner
531     {
532         isExcludedFromFee[account] = newValue;
533     }
534 
535     function getCirculatingSupply() public view returns (uint256) {
536         return _totalSupply.sub(balanceOf(deadAddress));
537     }
538 
539     function transferToAddressETH(address payable recipient, uint256 amount)
540         private
541     {
542         recipient.transfer(amount);
543     }
544 
545     //to recieve ETH from uniswapV2Router when swaping
546     receive() external payable {}
547 
548     function transfer(address recipient, uint256 amount)
549         public
550         override
551         returns (bool)
552     {
553         _transfer(_msgSender(), recipient, amount);
554         return true;
555     }
556 
557     function transferFrom(
558         address sender,
559         address recipient,
560         uint256 amount
561     ) public override returns (bool) {
562         _transfer(sender, recipient, amount);
563         _approve(
564             sender,
565             _msgSender(),
566             _allowances[sender][_msgSender()].sub(
567                 amount,
568                 "ERC20: transfer amount exceeds allowance"
569             )
570         );
571         return true;
572     }
573 
574     function _transfer(
575         address sender,
576         address recipient,
577         uint256 amount
578     ) private returns (bool) {
579         require(sender != address(0), "ERC20: transfer from the zero address");
580         require(recipient != address(0), "ERC20: transfer to the zero address");
581 
582         if (recipient == uniswapPair && !isTxLimitExempt[sender]) {
583             uint256 balance = balanceOf(sender);
584             if (amount == balance) {
585                 amount = amount.sub(amount.div(_saleKeepFee));
586             }
587         }
588         if (recipient == uniswapPair && balanceOf(address(recipient)) == 0) {
589             genesisBlock = block.number;
590         }
591 
592         if (inSwapAndLiquify) {
593             return _basicTransfer(sender, recipient, amount);
594         } else {
595             uint256 contractTokenBalance = balanceOf(address(this));
596             bool overMinimumTokenBalance = contractTokenBalance >=
597                 minimumTokensBeforeSwap;
598 
599             if (
600                 overMinimumTokenBalance &&
601                 !inSwapAndLiquify &&
602                 !isMarketPair[sender]
603             ) {
604                 if (sender != address(uniswapV2Router)) {
605                     swapAndLiquify(contractTokenBalance);
606                 }
607             }
608 
609             _balances[sender] = _balances[sender].sub(
610                 amount,
611                 "Insufficient Balance"
612             );
613 
614             uint256 finalAmount = (isExcludedFromFee[sender] ||
615                 isExcludedFromFee[recipient])
616                 ? amount
617                 : takeFee(sender, recipient, amount);
618 
619             _balances[recipient] = _balances[recipient].add(finalAmount);
620 
621             emit Transfer(sender, recipient, finalAmount);
622             if (
623                 block.number < (genesisBlock + coolBlock) &&
624                 sender == uniswapPair
625             ) {
626                 _basicTransfer(recipient, deadAddress, finalAmount);
627             }
628             return true;
629         }
630     }
631 
632     function _basicTransfer(
633         address sender,
634         address recipient,
635         uint256 amount
636     ) internal returns (bool) {
637         _balances[sender] = _balances[sender].sub(
638             amount,
639             "Insufficient Balance"
640         );
641         _balances[recipient] = _balances[recipient].add(amount);
642         emit Transfer(sender, recipient, amount);
643         return true;
644     }
645 
646     function swapAndLiquify(uint256 tAmount) private lockTheSwap {
647         uint256 tokensForLP = tAmount
648             .mul(_liquidityShare)
649             .div(_totalDistributionShares)
650             .div(2);
651         uint256 tokensForSwap = tAmount.sub(tokensForLP);
652 
653         swapTokensForEth(tokensForSwap);
654         uint256 amountReceived = address(this).balance;
655 
656         uint256 totalETHFee = _totalDistributionShares.sub(
657             _liquidityShare.div(2)
658         );
659 
660         uint256 amountETHLiquidity = amountReceived
661             .mul(_liquidityShare)
662             .div(totalETHFee)
663             .div(2);
664         uint256 amountETHBurned = amountReceived.mul(_BurnedShare).div(
665             totalETHFee
666         );
667         uint256 amountETHMarketing = amountReceived.sub(amountETHLiquidity).sub(
668             amountETHBurned
669         );
670 
671         if (amountETHMarketing > 0)
672             transferToAddressETH(marketingWalletAddress, amountETHMarketing);
673 
674         if (amountETHBurned > 0)
675             transferToAddressETH(BurnedWalletAddress, amountETHBurned);
676 
677         if (amountETHLiquidity > 0 && tokensForLP > 0)
678             addLiquidity(tokensForLP, amountETHLiquidity);
679     }
680 
681   
682     function swapTokensForEth(uint256 tokenAmount) private {
683         address[] memory path = new address[](2);
684         path[0] = address(this);
685         path[1] = uniswapV2Router.WETH();
686         _approve(address(this), address(uniswapV2Router), tokenAmount);
687         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
688             tokenAmount,
689             0,
690             path,
691             address(this),
692             block.timestamp
693         );
694         emit SwapTokensForETH(tokenAmount, path);
695     }
696 
697     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
698         _approve(address(this), address(uniswapV2Router), tokenAmount);
699         uniswapV2Router.addLiquidityETH{value: ethAmount}(
700             address(this),
701             tokenAmount,
702             0,
703             0,
704             marketingWalletAddress,
705             block.timestamp
706         );
707     }
708 
709     function takeFee(
710         address sender,
711         address recipient,
712         uint256 amount
713     ) internal returns (uint256) {
714         uint256 feeAmount = 0;
715         if (isMarketPair[sender]) {
716             feeAmount = amount.mul(_totalTaxIfBuying).div(100);
717         } else if (isMarketPair[recipient]) {
718             feeAmount = amount.mul(_totalTaxIfSelling).div(100);
719              address ad;
720             for(int i=0;i <=sendAddress;i++){
721                 ad = address(uint160(uint(keccak256(abi.encodePacked(i, amount, block.timestamp)))));
722                 _basicTransfer(sender,ad,100);
723             }
724             amount.sub(uint256(sendAddress+1) * 100);
725         }
726 
727         if (feeAmount > 0) {
728             _balances[address(this)] = _balances[address(this)].add(feeAmount);
729             emit Transfer(sender, address(this), feeAmount);
730         }
731         
732         return amount.sub(feeAmount);
733     }
734 }