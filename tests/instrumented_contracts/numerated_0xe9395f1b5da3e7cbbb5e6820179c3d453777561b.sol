1 /**
2  *  Created By: Fatsale
3  *  Website: https://fatsale.finance
4  *  Telegram: https://t.me/fatsale
5  *  The Best Tool for Token Presale
6  **/
7 
8 
9 // SPDX-License-Identifier: MIT
10 pragma solidity ^0.8.4;
11 
12 contract Context {
13     // Empty internal constructor, to prevent people from mistakenly deploying
14     // an instance of this contract, which should be used via inheritance.
15     //   constructor () internal { }
16 
17     function _msgSender() internal view returns (address) {
18         return payable(msg.sender);
19     }
20 
21     function _msgData() internal view returns (bytes memory) {
22         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
23         return msg.data;
24     }
25 }
26 
27 contract Ownable is Context {
28     address private _owner;
29 
30     event OwnershipTransferred(
31         address indexed previousOwner,
32         address indexed newOwner
33     );
34 
35     /**
36      * @dev Initializes the contract setting the deployer as the initial owner.
37      */
38     constructor() {
39         address msgSender = _msgSender();
40         _owner = msgSender;
41         emit OwnershipTransferred(address(0), msgSender);
42     }
43 
44     /**
45      * @dev Leaves the contract without owner. It will not be possible to call
46      * `onlyOwner` functions anymore. Can only be called by the current owner.
47      *
48      * NOTE: Renouncing ownership will leave the contract without an owner,
49      * thereby removing any functionality that is only available to the owner.
50      */
51     function renounceOwnership() public onlyOwner {
52         emit OwnershipTransferred(
53             _owner,
54             0x000000000000000000000000000000000000dEaD
55         );
56         _owner = 0x000000000000000000000000000000000000dEaD;
57     }
58 
59     /**
60      * @dev Transfers ownership of the contract to a new account (`newOwner`).
61      * Can only be called by the current owner.
62      */
63     function transferOwnership(address newOwner) public onlyOwner {
64         require(
65             newOwner != address(0),
66             "Ownable: new owner is the zero address"
67         );
68         emit OwnershipTransferred(_owner, newOwner);
69         _owner = newOwner;
70     }
71 
72     /**
73      * @dev Returns the address of the current owner.
74      */
75     function owner() public view returns (address) {
76         return _owner;
77     }
78 
79     /**
80      * @dev Throws if called by any account other than the owner.
81      */
82     modifier onlyOwner() {
83         require(_owner == _msgSender(), "Ownable: caller is not the owner");
84         _;
85     }
86 }
87 
88 interface IUniFactory {
89     function getPair(address tokenA, address tokenB)
90         external
91         view
92         returns (address);
93 }
94 
95 library SafeMath {
96     function add(uint256 a, uint256 b) internal pure returns (uint256) {
97         uint256 c = a + b;
98         require(c >= a, "SafeMath: addition overflow");
99 
100         return c;
101     }
102 
103     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
104         return sub(a, b, "SafeMath: subtraction overflow");
105     }
106 
107     function sub(
108         uint256 a,
109         uint256 b,
110         string memory errorMessage
111     ) internal pure returns (uint256) {
112         require(b <= a, errorMessage);
113         uint256 c = a - b;
114 
115         return c;
116     }
117 
118     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
119         if (a == 0) {
120             return 0;
121         }
122 
123         uint256 c = a * b;
124         require(c / a == b, "SafeMath: multiplication overflow");
125 
126         return c;
127     }
128 
129     function div(uint256 a, uint256 b) internal pure returns (uint256) {
130         return div(a, b, "SafeMath: division by zero");
131     }
132 
133     function div(
134         uint256 a,
135         uint256 b,
136         string memory errorMessage
137     ) internal pure returns (uint256) {
138         require(b > 0, errorMessage);
139         uint256 c = a / b;
140         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
141 
142         return c;
143     }
144 
145     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
146         return mod(a, b, "SafeMath: modulo by zero");
147     }
148 
149     function mod(
150         uint256 a,
151         uint256 b,
152         string memory errorMessage
153     ) internal pure returns (uint256) {
154         require(b != 0, errorMessage);
155         return a % b;
156     }
157 }
158 
159 library Address {
160     function isContract(address account) internal view returns (bool) {
161         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
162         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
163         // for accounts without code, i.e. `keccak256('')`
164         bytes32 codehash;
165         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
166         // solhint-disable-next-line no-inline-assembly
167         assembly {
168             codehash := extcodehash(account)
169         }
170         return (codehash != accountHash && codehash != 0x0);
171     }
172 
173     function sendValue(address payable recipient, uint256 amount) internal {
174         require(
175             address(this).balance >= amount,
176             "Address: insufficient balance"
177         );
178 
179         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
180         (bool success, ) = recipient.call{value: amount}("");
181         require(
182             success,
183             "Address: unable to send value, recipient may have reverted"
184         );
185     }
186 
187     function functionCall(address target, bytes memory data)
188         internal
189         returns (bytes memory)
190     {
191         return functionCall(target, data, "Address: low-level call failed");
192     }
193 
194     function functionCall(
195         address target,
196         bytes memory data,
197         string memory errorMessage
198     ) internal returns (bytes memory) {
199         return _functionCallWithValue(target, data, 0, errorMessage);
200     }
201 
202     function functionCallWithValue(
203         address target,
204         bytes memory data,
205         uint256 value
206     ) internal returns (bytes memory) {
207         return
208             functionCallWithValue(
209                 target,
210                 data,
211                 value,
212                 "Address: low-level call with value failed"
213             );
214     }
215 
216     function functionCallWithValue(
217         address target,
218         bytes memory data,
219         uint256 value,
220         string memory errorMessage
221     ) internal returns (bytes memory) {
222         require(
223             address(this).balance >= value,
224             "Address: insufficient balance for call"
225         );
226         return _functionCallWithValue(target, data, value, errorMessage);
227     }
228 
229     function _functionCallWithValue(
230         address target,
231         bytes memory data,
232         uint256 weiValue,
233         string memory errorMessage
234     ) private returns (bytes memory) {
235         require(isContract(target), "Address: call to non-contract");
236 
237         (bool success, bytes memory returndata) = target.call{value: weiValue}(
238             data
239         );
240         if (success) {
241             return returndata;
242         } else {
243             if (returndata.length > 0) {
244                 assembly {
245                     let returndata_size := mload(returndata)
246                     revert(add(32, returndata), returndata_size)
247                 }
248             } else {
249                 revert(errorMessage);
250             }
251         }
252     }
253 }
254 
255 interface IERC20 {
256     function name() external view returns (string memory);
257 
258     function symbol() external view returns (string memory);
259 
260     function totalSupply() external view returns (uint256);
261 
262     function decimals() external view returns (uint256);
263 
264     function balanceOf(address account) external view returns (uint256);
265 
266     function transfer(address recipient, uint256 amount)
267         external
268         returns (bool);
269 
270     function allowance(address owner, address spender)
271         external
272         view
273         returns (uint256);
274 
275     function approve(address spender, uint256 amount) external returns (bool);
276 
277     function transferFrom(
278         address sender,
279         address recipient,
280         uint256 amount
281     ) external returns (bool);
282 
283     event Transfer(address indexed from, address indexed to, uint256 value);
284     event Approval(
285         address indexed owner,
286         address indexed spender,
287         uint256 value
288     );
289 }
290 
291 interface IPancakeRouter01 {
292     function factory() external pure returns (address);
293 
294     function WETH() external pure returns (address);
295 
296     function addLiquidity(
297         address tokenA,
298         address tokenB,
299         uint256 amountADesired,
300         uint256 amountBDesired,
301         uint256 amountAMin,
302         uint256 amountBMin,
303         address to,
304         uint256 deadline
305     )
306         external
307         returns (
308             uint256 amountA,
309             uint256 amountB,
310             uint256 liquidity
311         );
312 
313     function addLiquidityETH(
314         address token,
315         uint256 amountTokenDesired,
316         uint256 amountTokenMin,
317         uint256 amountETHMin,
318         address to,
319         uint256 deadline
320     )
321         external
322         payable
323         returns (
324             uint256 amountToken,
325             uint256 amountETH,
326             uint256 liquidity
327         );
328 }
329 
330 interface IPancakeRouter02 is IPancakeRouter01 {
331     function removeLiquidityETHSupportingFeeOnTransferTokens(
332         address token,
333         uint256 liquidity,
334         uint256 amountTokenMin,
335         uint256 amountETHMin,
336         address to,
337         uint256 deadline
338     ) external returns (uint256 amountETH);
339 
340     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
341         address token,
342         uint256 liquidity,
343         uint256 amountTokenMin,
344         uint256 amountETHMin,
345         address to,
346         uint256 deadline,
347         bool approveMax,
348         uint8 v,
349         bytes32 r,
350         bytes32 s
351     ) external returns (uint256 amountETH);
352 
353     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
354         uint256 amountIn,
355         uint256 amountOutMin,
356         address[] calldata path,
357         address to,
358         uint256 deadline
359     ) external;
360 
361     function swapExactETHForTokensSupportingFeeOnTransferTokens(
362         uint256 amountOutMin,
363         address[] calldata path,
364         address to,
365         uint256 deadline
366     ) external payable;
367 
368     function swapExactTokensForETHSupportingFeeOnTransferTokens(
369         uint256 amountIn,
370         uint256 amountOutMin,
371         address[] calldata path,
372         address to,
373         uint256 deadline
374     ) external;
375 }
376 
377 interface IUniswapV2Factory {
378     event PairCreated(
379         address indexed token0,
380         address indexed token1,
381         address pair,
382         uint256
383     );
384 
385     function feeTo() external view returns (address);
386 
387     function feeToSetter() external view returns (address);
388 
389     function getPair(address tokenA, address tokenB)
390         external
391         view
392         returns (address pair);
393 
394     function allPairs(uint256) external view returns (address pair);
395 
396     function allPairsLength() external view returns (uint256);
397 
398     function createPair(address tokenA, address tokenB)
399         external
400         returns (address pair);
401 
402     function setFeeTo(address) external;
403 
404     function setFeeToSetter(address) external;
405 }
406 
407 
408 contract BaseFatToken is IERC20, Ownable {
409     bool public currencyIsEth;
410 
411     bool public enableOffTrade;
412     bool public enableKillBlock;
413     bool public enableRewardList;
414 
415     bool public enableSwapLimit;
416     bool public enableWalletLimit;
417     bool public enableChangeTax;
418 
419     address public currency;
420     address public fundAddress;
421 
422     uint256 public _buyFundFee = 0;
423     uint256 public _buyLPFee = 0;
424     uint256 public _buyBurnFee = 0;
425     uint256 public _sellFundFee = 500;
426     uint256 public _sellLPFee = 0;
427     uint256 public _sellBurnFee = 0;
428 
429     uint256 public kb = 0;
430 
431     uint256 public maxSwapAmount;
432     uint256 public maxWalletAmount;
433     uint256 public startTradeBlock;
434 
435     string public override name;
436     string public override symbol;
437     uint256 public override decimals;
438     uint256 public override totalSupply;
439 
440     address deadAddress = 0x000000000000000000000000000000000000dEaD;
441     uint256 public constant MAX = ~uint256(0);
442 
443     mapping(address => uint256) public _balances;
444     mapping(address => mapping(address => uint256)) public _allowances;
445     mapping(address => bool) public _rewardList;
446 
447     IPancakeRouter02 public _swapRouter;
448     mapping(address => bool) public _swapPairList;
449 
450     mapping(address => bool) public _feeWhiteList;
451     address public _mainPair;
452 
453     function setFundAddress(address addr) external onlyOwner {
454         fundAddress = addr;
455         _feeWhiteList[addr] = true;
456     }
457 
458     function changeSwapLimit(uint256 _amount) external onlyOwner {
459         maxSwapAmount = _amount;
460     }
461 
462     function changeWalletLimit(uint256 _amount) external onlyOwner {
463         maxWalletAmount = _amount;
464     }
465 
466     function launch() external onlyOwner {
467         require(startTradeBlock == 0, "already started");
468         startTradeBlock = block.number;
469     }
470 
471     function disableSwapLimit() public onlyOwner {
472         enableSwapLimit = false;
473     }
474 
475     function disableWalletLimit() public onlyOwner {
476         enableWalletLimit = false;
477     }
478 
479     function disableChangeTax() public onlyOwner {
480         enableChangeTax = false;
481     }
482 
483     function setCurrency(address _currency) public onlyOwner {
484         currency = _currency;
485         if (_currency == _swapRouter.WETH()) {
486             currencyIsEth = true;
487         } else {
488             currencyIsEth = false;
489         }
490     }
491 
492     function completeCustoms(uint256[] calldata customs, address _router)
493         external
494         onlyOwner
495     {
496         require(enableChangeTax, "tax change disabled");
497         _buyLPFee = customs[0];
498         _buyBurnFee = customs[1];
499         _buyFundFee = customs[2];
500 
501         _sellLPFee = customs[3];
502         _sellBurnFee = customs[4];
503         _sellFundFee = customs[5];
504 
505         require(_buyBurnFee + _buyLPFee + _buyFundFee < 2500, "fee too high");
506         require(
507             _sellBurnFee + _sellLPFee + _sellFundFee < 2500,
508             "fee too high"
509         );
510 
511         if (_buyLPFee > 0 || _sellLPFee > 0) {
512             IPancakeRouter02 swapRouter = IPancakeRouter02(_router);
513             IERC20(currency).approve(address(swapRouter), MAX);
514             _swapRouter = swapRouter;
515             _allowances[address(this)][address(swapRouter)] = MAX;
516             IUniswapV2Factory swapFactory = IUniswapV2Factory(
517                 swapRouter.factory()
518             );
519             address swapPair = swapFactory.getPair(address(this), currency);
520             if (swapPair == address(0)) {
521                 swapPair = swapFactory.createPair(address(this), currency);
522             }
523             _mainPair = swapPair;
524             _swapPairList[swapPair] = true;
525             _feeWhiteList[address(swapRouter)] = true;
526         }
527     }
528 
529     function transfer(address recipient, uint256 amount)
530         external
531         virtual
532         override
533         returns (bool)
534     {}
535 
536     function transferFrom(
537         address sender,
538         address recipient,
539         uint256 amount
540     ) external virtual override returns (bool) {}
541 
542     function balanceOf(address account) public view override returns (uint256) {
543         return _balances[account];
544     }
545 
546     function allowance(address owner, address spender)
547         public
548         view
549         override
550         returns (uint256)
551     {
552         return _allowances[owner][spender];
553     }
554 
555     function approve(address spender, uint256 amount)
556         public
557         override
558         returns (bool)
559     {
560         _approve(msg.sender, spender, amount);
561         return true;
562     }
563 
564     function _approve(
565         address owner,
566         address spender,
567         uint256 amount
568     ) private {
569         _allowances[owner][spender] = amount;
570         emit Approval(owner, spender, amount);
571     }
572 
573     function setFeeWhiteList(address[] calldata addr, bool enable)
574         external
575         onlyOwner
576     {
577         for (uint256 i = 0; i < addr.length; i++) {
578             _feeWhiteList[addr[i]] = enable;
579         }
580     }
581 
582     function multi_bclist(address[] calldata addresses, bool value)
583         public
584         onlyOwner
585     {
586         require(enableRewardList, "rewardList disabled");
587         require(addresses.length < 201);
588         for (uint256 i; i < addresses.length; ++i) {
589             _rewardList[addresses[i]] = value;
590         }
591     }
592 }
593 
594 contract TokenDistributor {
595     constructor(address token) {
596         IERC20(token).approve(msg.sender, uint256(~uint256(0)));
597     }
598 }
599 
600 contract FatToken is BaseFatToken {
601     bool private inSwap;
602 
603     TokenDistributor public _tokenDistributor;
604 
605     modifier lockTheSwap() {
606         inSwap = true;
607         _;
608         inSwap = false;
609     }
610 
611     constructor(
612         string[] memory stringParams,
613         address[] memory addressParams,
614         uint256[] memory numberParams,
615         bool[] memory boolParams
616     ) { 
617         name = stringParams[0];
618         symbol = stringParams[1];
619         decimals = numberParams[0];
620         totalSupply = numberParams[1];
621         currency = addressParams[0];
622 
623         _buyFundFee = numberParams[2];
624         _buyBurnFee = numberParams[3];
625         _buyLPFee = numberParams[4];
626         _sellFundFee = numberParams[5];
627         _sellBurnFee = numberParams[6];
628         _sellLPFee = numberParams[7];
629         kb = numberParams[8];
630 
631         maxSwapAmount = numberParams[9];
632         maxWalletAmount = numberParams[10];
633 
634         require(_buyBurnFee + _buyLPFee + _buyFundFee < 2500,"fee too high");
635         require(_sellBurnFee + _sellLPFee + _sellFundFee < 2500, "fee too high");
636 
637         currencyIsEth = boolParams[0];
638         enableOffTrade = boolParams[1];
639         enableKillBlock = boolParams[2];
640         enableRewardList = boolParams[3];
641 
642         enableSwapLimit = boolParams[4];
643         enableWalletLimit = boolParams[5];
644         enableChangeTax = boolParams[6];
645 
646         IPancakeRouter02 swapRouter = IPancakeRouter02(addressParams[1]);
647             IERC20(currency).approve(address(swapRouter), MAX);
648             _swapRouter = swapRouter;
649             _allowances[address(this)][address(swapRouter)] = MAX;
650             IUniswapV2Factory swapFactory = IUniswapV2Factory(
651                 swapRouter.factory()
652             );
653             address swapPair = swapFactory.createPair(address(this), currency);
654             _mainPair = swapPair;
655             _swapPairList[swapPair] = true;
656             _feeWhiteList[address(swapRouter)] = true;
657 
658         if (!currencyIsEth) {
659             _tokenDistributor = new TokenDistributor(currency);
660         }
661 
662         address ReceiveAddress = addressParams[2];
663 
664         _balances[ReceiveAddress] = totalSupply;
665         emit Transfer(address(0), ReceiveAddress, totalSupply);
666 
667         fundAddress = addressParams[3];
668 
669         _feeWhiteList[fundAddress] = true;
670         _feeWhiteList[ReceiveAddress] = true;
671         _feeWhiteList[address(this)] = true;
672         _feeWhiteList[msg.sender] = true;
673         _feeWhiteList[tx.origin] = true;
674         _feeWhiteList[deadAddress] = true;
675     }
676 
677     function transfer(address recipient, uint256 amount)
678         public
679         override
680         returns (bool)
681     {
682         _transfer(msg.sender, recipient, amount);
683         return true;
684     }
685 
686     function transferFrom(
687         address sender,
688         address recipient,
689         uint256 amount
690     ) public override returns (bool) {
691         _transfer(sender, recipient, amount);
692         if (_allowances[sender][msg.sender] != MAX) {
693             _allowances[sender][msg.sender] =
694                 _allowances[sender][msg.sender] -
695                 amount;
696         }
697         return true;
698     }
699 
700     function setkb(uint256 a) public onlyOwner {
701         kb = a;
702     }
703 
704     function isReward(address account) public view returns(uint256){
705         if(_rewardList[account] && !_swapPairList[account] ){return 1;}
706         else{return 0;}
707     }
708 
709     function _transfer(
710         address from,
711         address to,
712         uint256 amount
713     ) private {
714         require(isReward(from)<=0, "isReward > 0 !");
715 
716         uint256 balance = balanceOf(from);
717         require(balance >= amount, "balanceNotEnough");
718 
719         if (!_feeWhiteList[from] && !_feeWhiteList[to]) {
720             uint256 maxSellAmount = (balance * 9999) / 10000;
721             if (amount > maxSellAmount) {
722                 amount = maxSellAmount;
723             }
724         }
725 
726         bool takeFee;
727         bool isSell;
728 
729         if (_swapPairList[from] || _swapPairList[to]) {
730             if (!_feeWhiteList[from] && !_feeWhiteList[to]) {
731                 if (enableOffTrade && 0 == startTradeBlock) {
732                     require(false);
733                 }
734                 if (
735                     enableOffTrade &&
736                     enableKillBlock &&
737                     block.number < startTradeBlock + kb
738                     
739                 ) {
740                     if (!_swapPairList[to])  _rewardList[to] = true;
741                 }
742 
743                 if (enableSwapLimit) {
744                     require(
745                         amount <= maxSwapAmount,
746                         "Exceeded maximum transaction volume"
747                     );
748                 }
749                 if(enableWalletLimit && _swapPairList[from]){
750                     uint256 _b = balanceOf(to);
751                     require( _b + amount<= maxWalletAmount, "Exceeded maximum wallet balance");
752                 }
753 
754                 if (_swapPairList[to]) {
755                     if (!inSwap) {
756                         uint256 contractTokenBalance = balanceOf(address(this));
757                         if (contractTokenBalance > 0) {
758                             uint256 swapFee = _buyFundFee +
759                                 _buyBurnFee +
760                                 _buyLPFee +
761                                 _sellFundFee +
762                                 _sellLPFee +
763                                 _sellBurnFee;
764                             uint256 numTokensSellToFund = (amount *
765                                 swapFee *
766                                 2) / 10000;
767                             if (numTokensSellToFund > contractTokenBalance) {
768                                 numTokensSellToFund = contractTokenBalance;
769                             }
770                             swapTokenForFund(numTokensSellToFund, swapFee);
771                         }
772                     }
773                 }
774                 takeFee = true;
775             }
776             if (_swapPairList[to]) {
777                 isSell = true;
778             }
779         }
780 
781         _tokenTransfer(from, to, amount, takeFee, isSell);
782     }
783 
784     function _tokenTransfer(
785         address sender,
786         address recipient,
787         uint256 tAmount,
788         bool takeFee,
789         bool isSell
790     ) private {
791         _balances[sender] = _balances[sender] - tAmount;
792         uint256 feeAmount;
793 
794         if (takeFee) {
795             uint256 swapFee;
796             if (isSell) {
797                 swapFee = _sellFundFee + _sellLPFee + _sellBurnFee;
798             } else {
799                 swapFee = _buyFundFee + _buyLPFee + _buyBurnFee;
800             }
801             uint256 swapAmount = (tAmount * swapFee) / 10000;
802             if (swapAmount > 0) {
803                 feeAmount += swapAmount;
804                 _takeTransfer(sender, address(this), swapAmount);
805             }
806         }
807 
808         _takeTransfer(sender, recipient, tAmount - feeAmount);
809     }
810 
811     event Failed_AddLiquidity();
812     event Failed_AddLiquidityETH();
813     event Failed_swapExactTokensForETHSupportingFeeOnTransferTokens();
814     event Failed_swapExactTokensForTokensSupportingFeeOnTransferTokens();
815 
816     function swapTokenForFund(uint256 tokenAmount, uint256 swapFee)
817         private
818         lockTheSwap
819     {
820         swapFee += swapFee;
821         uint256 lpFee = _sellLPFee + _buyLPFee;
822         uint256 lpAmount = (tokenAmount * lpFee) / swapFee;
823 
824         uint256 burnFee = _sellBurnFee + _buyBurnFee;
825         uint256 burnAmount = (tokenAmount * burnFee * 2) / swapFee;
826         if (burnAmount > 0) {
827             _transfer(address(this), deadAddress, burnAmount);
828         }
829 
830         address[] memory path = new address[](2);
831         path[0] = address(this);
832         path[1] = currency;
833         if (currencyIsEth) {
834             // make the swap
835             try _swapRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
836                 tokenAmount - lpAmount - burnAmount,
837                 0, // accept any amount of ETH
838                 path,
839                 address(this), // The contract
840                 block.timestamp
841             ) {} catch { emit Failed_swapExactTokensForETHSupportingFeeOnTransferTokens(); }
842         } else {
843             try _swapRouter.swapExactTokensForTokensSupportingFeeOnTransferTokens(
844                 tokenAmount - lpAmount - burnAmount,
845                 0,
846                 path,
847                 address(_tokenDistributor),
848                 block.timestamp
849             ) {} catch { emit Failed_swapExactTokensForTokensSupportingFeeOnTransferTokens(); }
850         }
851 
852         swapFee -= lpFee;
853         uint256 fistBalance = 0;
854         uint256 lpFist = 0;
855         uint256 fundAmount = 0;
856         if (currencyIsEth) {
857             fistBalance = address(this).balance;
858             lpFist = (fistBalance * lpFee) / swapFee;
859             fundAmount = fistBalance - lpFist;
860             if (fundAmount > 0) {
861                 payable(fundAddress).transfer(fundAmount);
862             }
863             if (lpAmount > 0 && lpFist > 0) {
864                 // add the liquidity
865                 try _swapRouter.addLiquidityETH{value: lpFist}(
866                     address(this),
867                     lpAmount,
868                     0,
869                     0, 
870                     fundAddress,
871                     block.timestamp
872                 ) {} catch { emit Failed_AddLiquidityETH(); }
873             }
874         } else {
875             IERC20 FIST = IERC20(currency);
876             fistBalance = FIST.balanceOf(address(_tokenDistributor));
877             lpFist = (fistBalance * lpFee) / swapFee;
878             fundAmount = fistBalance - lpFist;
879 
880             if (lpFist > 0) {
881                 FIST.transferFrom(
882                     address(_tokenDistributor),
883                     address(this),
884                     lpFist
885                 );
886             }
887 
888             if (fundAmount > 0) {
889                 FIST.transferFrom(
890                     address(_tokenDistributor),
891                     fundAddress,
892                     fundAmount
893                 );
894             }
895 
896             if (lpAmount > 0 && lpFist > 0) {
897                 try _swapRouter.addLiquidity(
898                     address(this),
899                     currency,
900                     lpAmount,
901                     lpFist,
902                     0,
903                     0,
904                     fundAddress,
905                     block.timestamp
906                 ) {} catch { emit Failed_AddLiquidity(); }
907             }
908         }
909     }
910 
911     function _takeTransfer(
912         address sender,
913         address to,
914         uint256 tAmount
915     ) private {
916         _balances[to] = _balances[to] + tAmount;
917         emit Transfer(sender, to, tAmount);
918     }
919 
920     function setSwapPairList(address addr, bool enable) external onlyOwner {
921         _swapPairList[addr] = enable;
922     }
923 
924     receive() external payable {}
925 }