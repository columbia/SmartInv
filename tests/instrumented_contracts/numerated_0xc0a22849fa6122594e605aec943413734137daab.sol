1 /**
2  * SPDX-License-Identifier: Unlicensed
3  * https://www.thevault.capital/
4  * https://twitter.com/TheVaultERC
5  * https://t.me/TheVaultERC
6  */
7 
8 pragma solidity 0.8.19;
9 
10 abstract contract Context {
11     function _msgSender() internal view virtual returns (address payable) {
12         return payable(msg.sender);
13     }
14 
15     function _msgData() internal view virtual returns (bytes memory) {
16         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
17         return msg.data;
18     }
19 }
20 
21 interface IERC20 {
22     function totalSupply() external view returns (uint256);
23 
24     function balanceOf(address account) external view returns (uint256);
25 
26     function transfer(
27         address recipient,
28         uint256 amount
29     ) external returns (bool);
30 
31     function allowance(
32         address owner,
33         address spender
34     ) external view returns (uint256);
35 
36     function approve(address spender, uint256 amount) external returns (bool);
37 
38     function transferFrom(
39         address sender,
40         address recipient,
41         uint256 amount
42     ) external returns (bool);
43 
44     event Transfer(address indexed from, address indexed to, uint256 value);
45     event Approval(
46         address indexed owner,
47         address indexed spender,
48         uint256 value
49     );
50 }
51 
52 library SafeMath {
53     function add(uint256 a, uint256 b) internal pure returns (uint256) {
54         uint256 c = a + b;
55         require(c >= a, "SafeMath: addition overflow");
56 
57         return c;
58     }
59 
60     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
61         return sub(a, b, "SafeMath: subtraction overflow");
62     }
63 
64     function sub(
65         uint256 a,
66         uint256 b,
67         string memory errorMessage
68     ) internal pure returns (uint256) {
69         require(b <= a, errorMessage);
70         uint256 c = a - b;
71 
72         return c;
73     }
74 
75     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
76         if (a == 0) {
77             return 0;
78         }
79 
80         uint256 c = a * b;
81         require(c / a == b, "SafeMath: multiplication overflow");
82 
83         return c;
84     }
85 
86     function div(uint256 a, uint256 b) internal pure returns (uint256) {
87         return div(a, b, "SafeMath: division by zero");
88     }
89 
90     function div(
91         uint256 a,
92         uint256 b,
93         string memory errorMessage
94     ) internal pure returns (uint256) {
95         require(b > 0, errorMessage);
96         uint256 c = a / b;
97         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
98 
99         return c;
100     }
101 
102     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
103         return mod(a, b, "SafeMath: modulo by zero");
104     }
105 
106     function mod(
107         uint256 a,
108         uint256 b,
109         string memory errorMessage
110     ) internal pure returns (uint256) {
111         require(b != 0, errorMessage);
112         return a % b;
113     }
114 }
115 
116 library Address {
117     function isContract(address account) internal view returns (bool) {
118         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
119         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
120         // for accounts without code, i.e. `keccak256('')`
121         bytes32 codehash;
122         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
123         // solhint-disable-next-line no-inline-assembly
124         assembly {
125             codehash := extcodehash(account)
126         }
127         return (codehash != accountHash && codehash != 0x0);
128     }
129 
130     function sendValue(address payable recipient, uint256 amount) internal {
131         require(
132             address(this).balance >= amount,
133             "Address: insufficient balance"
134         );
135 
136         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
137         (bool success, ) = recipient.call{value: amount}("");
138         require(
139             success,
140             "Address: unable to send value, recipient may have reverted"
141         );
142     }
143 
144     function functionCall(
145         address target,
146         bytes memory data
147     ) internal returns (bytes memory) {
148         return functionCall(target, data, "Address: low-level call failed");
149     }
150 
151     function functionCall(
152         address target,
153         bytes memory data,
154         string memory errorMessage
155     ) internal returns (bytes memory) {
156         return _functionCallWithValue(target, data, 0, errorMessage);
157     }
158 
159     function functionCallWithValue(
160         address target,
161         bytes memory data,
162         uint256 value
163     ) internal returns (bytes memory) {
164         return
165             functionCallWithValue(
166                 target,
167                 data,
168                 value,
169                 "Address: low-level call with value failed"
170             );
171     }
172 
173     function functionCallWithValue(
174         address target,
175         bytes memory data,
176         uint256 value,
177         string memory errorMessage
178     ) internal returns (bytes memory) {
179         require(
180             address(this).balance >= value,
181             "Address: insufficient balance for call"
182         );
183         return _functionCallWithValue(target, data, value, errorMessage);
184     }
185 
186     function _functionCallWithValue(
187         address target,
188         bytes memory data,
189         uint256 weiValue,
190         string memory errorMessage
191     ) private returns (bytes memory) {
192         require(isContract(target), "Address: call to non-contract");
193 
194         (bool success, bytes memory returndata) = target.call{value: weiValue}(
195             data
196         );
197         if (success) {
198             return returndata;
199         } else {
200             if (returndata.length > 0) {
201                 assembly {
202                     let returndata_size := mload(returndata)
203                     revert(add(32, returndata), returndata_size)
204                 }
205             } else {
206                 revert(errorMessage);
207             }
208         }
209     }
210 }
211 
212 contract Ownable is Context {
213     address private _owner;
214     address private _previousOwner;
215 
216     event OwnershipTransferred(
217         address indexed previousOwner,
218         address indexed newOwner
219     );
220 
221     constructor() {
222         address msgSender = _msgSender();
223         _owner = msgSender;
224         emit OwnershipTransferred(address(0), msgSender);
225     }
226 
227     function owner() public view returns (address) {
228         return _owner;
229     }
230 
231     modifier onlyOwner() {
232         require(_owner == _msgSender(), "Ownable: caller is not the owner");
233         _;
234     }
235 
236     function waiveOwnership() public virtual onlyOwner {
237         emit OwnershipTransferred(_owner, address(0));
238         _owner = address(0);
239     }
240 
241     function transferOwnership(address newOwner) public virtual onlyOwner {
242         require(
243             newOwner != address(0),
244             "Ownable: new owner is the zero address"
245         );
246         emit OwnershipTransferred(_owner, newOwner);
247         _owner = newOwner;
248     }
249 }
250 
251 interface IUniswapV2Factory {
252     event PairCreated(
253         address indexed token0,
254         address indexed token1,
255         address pair,
256         uint
257     );
258 
259     function feeTo() external view returns (address);
260 
261     function feeToSetter() external view returns (address);
262 
263     function getPair(
264         address tokenA,
265         address tokenB
266     ) external view returns (address pair);
267 
268     function allPairs(uint) external view returns (address pair);
269 
270     function allPairsLength() external view returns (uint);
271 
272     function createPair(
273         address tokenA,
274         address tokenB
275     ) external returns (address pair);
276 
277     function setFeeTo(address) external;
278 
279     function setFeeToSetter(address) external;
280 }
281 
282 interface IUniswapV2Pair {
283     event Approval(address indexed owner, address indexed spender, uint value);
284     event Transfer(address indexed from, address indexed to, uint value);
285 
286     function name() external pure returns (string memory);
287 
288     function symbol() external pure returns (string memory);
289 
290     function decimals() external pure returns (uint8);
291 
292     function totalSupply() external view returns (uint);
293 
294     function balanceOf(address owner) external view returns (uint);
295 
296     function allowance(
297         address owner,
298         address spender
299     ) external view returns (uint);
300 
301     function approve(address spender, uint value) external returns (bool);
302 
303     function transfer(address to, uint value) external returns (bool);
304 
305     function transferFrom(
306         address from,
307         address to,
308         uint value
309     ) external returns (bool);
310 
311     function DOMAIN_SEPARATOR() external view returns (bytes32);
312 
313     function PERMIT_TYPEHASH() external pure returns (bytes32);
314 
315     function nonces(address owner) external view returns (uint);
316 
317     function permit(
318         address owner,
319         address spender,
320         uint value,
321         uint deadline,
322         uint8 v,
323         bytes32 r,
324         bytes32 s
325     ) external;
326 
327     event Burn(
328         address indexed sender,
329         uint amount0,
330         uint amount1,
331         address indexed to
332     );
333     event Swap(
334         address indexed sender,
335         uint amount0In,
336         uint amount1In,
337         uint amount0Out,
338         uint amount1Out,
339         address indexed to
340     );
341     event Sync(uint112 reserve0, uint112 reserve1);
342 
343     function MINIMUM_LIQUIDITY() external pure returns (uint);
344 
345     function factory() external view returns (address);
346 
347     function token0() external view returns (address);
348 
349     function token1() external view returns (address);
350 
351     function getReserves()
352         external
353         view
354         returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
355 
356     function price0CumulativeLast() external view returns (uint);
357 
358     function price1CumulativeLast() external view returns (uint);
359 
360     function kLast() external view returns (uint);
361 
362     function burn(address to) external returns (uint amount0, uint amount1);
363 
364     function swap(
365         uint amount0Out,
366         uint amount1Out,
367         address to,
368         bytes calldata data
369     ) external;
370 
371     function skim(address to) external;
372 
373     function sync() external;
374 
375     function initialize(address, address) external;
376 }
377 
378 interface IUniswapV2Router01 {
379     function factory() external pure returns (address);
380 
381     function WETH() external pure returns (address);
382 
383     function addLiquidity(
384         address tokenA,
385         address tokenB,
386         uint amountADesired,
387         uint amountBDesired,
388         uint amountAMin,
389         uint amountBMin,
390         address to,
391         uint deadline
392     ) external returns (uint amountA, uint amountB, uint liquidity);
393 
394     function addLiquidityETH(
395         address token,
396         uint amountTokenDesired,
397         uint amountTokenMin,
398         uint amountETHMin,
399         address to,
400         uint deadline
401     )
402         external
403         payable
404         returns (uint amountToken, uint amountETH, uint liquidity);
405 
406     function removeLiquidity(
407         address tokenA,
408         address tokenB,
409         uint liquidity,
410         uint amountAMin,
411         uint amountBMin,
412         address to,
413         uint deadline
414     ) external returns (uint amountA, uint amountB);
415 
416     function removeLiquidityETH(
417         address token,
418         uint liquidity,
419         uint amountTokenMin,
420         uint amountETHMin,
421         address to,
422         uint deadline
423     ) external returns (uint amountToken, uint amountETH);
424 
425     function removeLiquidityWithPermit(
426         address tokenA,
427         address tokenB,
428         uint liquidity,
429         uint amountAMin,
430         uint amountBMin,
431         address to,
432         uint deadline,
433         bool approveMax,
434         uint8 v,
435         bytes32 r,
436         bytes32 s
437     ) external returns (uint amountA, uint amountB);
438 
439     function removeLiquidityETHWithPermit(
440         address token,
441         uint liquidity,
442         uint amountTokenMin,
443         uint amountETHMin,
444         address to,
445         uint deadline,
446         bool approveMax,
447         uint8 v,
448         bytes32 r,
449         bytes32 s
450     ) external returns (uint amountToken, uint amountETH);
451 
452     function swapExactTokensForTokens(
453         uint amountIn,
454         uint amountOutMin,
455         address[] calldata path,
456         address to,
457         uint deadline
458     ) external returns (uint[] memory amounts);
459 
460     function swapTokensForExactTokens(
461         uint amountOut,
462         uint amountInMax,
463         address[] calldata path,
464         address to,
465         uint deadline
466     ) external returns (uint[] memory amounts);
467 
468     function swapExactETHForTokens(
469         uint amountOutMin,
470         address[] calldata path,
471         address to,
472         uint deadline
473     ) external payable returns (uint[] memory amounts);
474 
475     function swapTokensForExactETH(
476         uint amountOut,
477         uint amountInMax,
478         address[] calldata path,
479         address to,
480         uint deadline
481     ) external returns (uint[] memory amounts);
482 
483     function swapExactTokensForETH(
484         uint amountIn,
485         uint amountOutMin,
486         address[] calldata path,
487         address to,
488         uint deadline
489     ) external returns (uint[] memory amounts);
490 
491     function swapETHForExactTokens(
492         uint amountOut,
493         address[] calldata path,
494         address to,
495         uint deadline
496     ) external payable returns (uint[] memory amounts);
497 
498     function quote(
499         uint amountA,
500         uint reserveA,
501         uint reserveB
502     ) external pure returns (uint amountB);
503 
504     function getAmountOut(
505         uint amountIn,
506         uint reserveIn,
507         uint reserveOut
508     ) external pure returns (uint amountOut);
509 
510     function getAmountIn(
511         uint amountOut,
512         uint reserveIn,
513         uint reserveOut
514     ) external pure returns (uint amountIn);
515 
516     function getAmountsOut(
517         uint amountIn,
518         address[] calldata path
519     ) external view returns (uint[] memory amounts);
520 
521     function getAmountsIn(
522         uint amountOut,
523         address[] calldata path
524     ) external view returns (uint[] memory amounts);
525 }
526 
527 interface IUniswapV2Router02 is IUniswapV2Router01 {
528     function removeLiquidityETHSupportingFeeOnTransferTokens(
529         address token,
530         uint liquidity,
531         uint amountTokenMin,
532         uint amountETHMin,
533         address to,
534         uint deadline
535     ) external returns (uint amountETH);
536 
537     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
538         address token,
539         uint liquidity,
540         uint amountTokenMin,
541         uint amountETHMin,
542         address to,
543         uint deadline,
544         bool approveMax,
545         uint8 v,
546         bytes32 r,
547         bytes32 s
548     ) external returns (uint amountETH);
549 
550     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
551         uint amountIn,
552         uint amountOutMin,
553         address[] calldata path,
554         address to,
555         uint deadline
556     ) external;
557 
558     function swapExactETHForTokensSupportingFeeOnTransferTokens(
559         uint amountOutMin,
560         address[] calldata path,
561         address to,
562         uint deadline
563     ) external payable;
564 
565     function swapExactTokensForETHSupportingFeeOnTransferTokens(
566         uint amountIn,
567         uint amountOutMin,
568         address[] calldata path,
569         address to,
570         uint deadline
571     ) external;
572 }
573 
574 contract TheVault is Context, IERC20, Ownable {
575     using SafeMath for uint256;
576     using Address for address;
577 
578     uint256 public totalBurned = 0;
579     uint256 public ethSentFromVault = 0;
580 
581     string private _name = "The Vault";
582     string private _symbol = "VAULT";
583     uint8 private _decimals = 18;
584     mapping(address => uint256) _balances;
585     mapping(address => mapping(address => uint256)) private _allowances;
586 
587     address payable private devMarketingWallet;
588 
589     address public immutable deadAddress =
590         0x000000000000000000000000000000000000dEaD;
591     IUniswapV2Router02 public uniswapV2Router;
592     address public uniswapPair;
593 
594     uint256 public _liquidityShares = 0;
595     uint256 public _devShares = 1;
596     uint256 public _vaultShares = 1;
597 
598     uint256 public _taxOnBuy = 20;
599     uint256 public _taxOnSell = 90;
600     uint256 public _totalDistributionShrs;
601 
602     bool public _tradingOpen = false;
603     bool public _checkWalletLimit = true;
604     mapping(address => bool) public _checkExcludedFromFees;
605     mapping(address => bool) public _checkWalletLimitExcept;
606     mapping(address => bool) public _checkTxLimitExcept;
607     mapping(address => bool) public _checkMarketPair;
608 
609     uint256 private _totalSupply = 1000 * 10 ** 18;
610     uint256 public maxTxAmount = (_totalSupply * 10) / 1000;
611     uint256 public walletMax = (_totalSupply * 10) / 1000;
612 
613     bool inSwapAndLiquify;
614     bool public swapAndLiquifyEnabled = true;
615     bool public swapAndLiquifyByLimitOnly = false;
616     uint256 private minimumTokensBeforeSwap = (_totalSupply * 5) / 10000;
617 
618     event ExchangedOnVault(
619         address account,
620         uint256 burnAmount,
621         uint256 ethRecievedAmount
622     );
623 
624     event SwapAndLiquifyEnabledUpdated(bool enabled);
625     event SwapAndLiquify(
626         uint256 tokensSwapped,
627         uint256 ethReceived,
628         uint256 tokensIntoLiqudity
629     );
630 
631     event SwapETHForTokens(uint256 amountIn, address[] path);
632 
633     event SwapTokensForETH(uint256 amountIn, address[] path);
634 
635     modifier lockTheSwap() {
636         inSwapAndLiquify = true;
637         _;
638         inSwapAndLiquify = false;
639     }
640 
641     constructor() {
642         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
643             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
644         );
645 
646         uniswapPair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(
647             address(this),
648             _uniswapV2Router.WETH()
649         );
650 
651         uniswapV2Router = _uniswapV2Router;
652         _allowances[address(this)][address(uniswapV2Router)] = _totalSupply;
653 
654         devMarketingWallet = payable(msg.sender);
655 
656         _checkExcludedFromFees[owner()] = true;
657         _checkExcludedFromFees[address(this)] = true;
658         _checkExcludedFromFees[devMarketingWallet] = true;
659 
660         _totalDistributionShrs = _liquidityShares.add(_devShares).add(
661             _vaultShares
662         );
663 
664         _checkWalletLimitExcept[owner()] = true;
665         _checkWalletLimitExcept[devMarketingWallet] = true;
666         _checkWalletLimitExcept[address(uniswapPair)] = true;
667         _checkWalletLimitExcept[address(this)] = true;
668 
669         _checkTxLimitExcept[owner()] = true;
670         _checkTxLimitExcept[address(this)] = true;
671         _checkTxLimitExcept[devMarketingWallet] = true;
672 
673         _checkMarketPair[address(uniswapPair)] = true;
674 
675         _balances[_msgSender()] = _totalSupply;
676         emit Transfer(address(0), _msgSender(), _totalSupply);
677     }
678 
679     function name() public view returns (string memory) {
680         return _name;
681     }
682 
683     function symbol() public view returns (string memory) {
684         return _symbol;
685     }
686 
687     function decimals() public view returns (uint8) {
688         return _decimals;
689     }
690 
691     function totalSupply() public view override returns (uint256) {
692         return _totalSupply;
693     }
694 
695     function balanceOf(address account) public view override returns (uint256) {
696         return _balances[account];
697     }
698 
699     function allowance(
700         address owner,
701         address spender
702     ) public view override returns (uint256) {
703         return _allowances[owner][spender];
704     }
705 
706     function increaseAllowance(
707         address spender,
708         uint256 addedValue
709     ) public virtual returns (bool) {
710         _approve(
711             _msgSender(),
712             spender,
713             _allowances[_msgSender()][spender].add(addedValue)
714         );
715         return true;
716     }
717 
718     function decreaseAllowance(
719         address spender,
720         uint256 subtractedValue
721     ) public virtual returns (bool) {
722         _approve(
723             _msgSender(),
724             spender,
725             _allowances[_msgSender()][spender].sub(
726                 subtractedValue,
727                 "ERC20: decreased allowance below zero"
728             )
729         );
730         return true;
731     }
732 
733     function approve(
734         address spender,
735         uint256 amount
736     ) public override returns (bool) {
737         _approve(_msgSender(), spender, amount);
738         return true;
739     }
740 
741     function _approve(
742         address owner,
743         address spender,
744         uint256 amount
745     ) internal virtual {
746         require(owner != address(0), "ERC20: approve from the zero address");
747         require(spender != address(0), "ERC20: approve to the zero address");
748 
749         _allowances[owner][spender] = amount;
750         emit Approval(owner, spender, amount);
751     }
752 
753     function _addMarketPair(address account) public onlyOwner {
754         _checkMarketPair[account] = true;
755     }
756 
757     function _set_checkTxLimitExcept(
758         address holder,
759         bool exempt
760     ) external onlyOwner {
761         _checkTxLimitExcept[holder] = exempt;
762     }
763 
764     function _set_checkExcludedFromFees(
765         address account,
766         bool newValue
767     ) public onlyOwner {
768         _checkExcludedFromFees[account] = newValue;
769     }
770 
771     function makeItLive() external onlyOwner {
772         _tradingOpen = true;
773     }
774 
775     function _setBuyFee(uint256 newTax) external onlyOwner {
776         _taxOnBuy = newTax;
777     }
778 
779     function _setSellFee(uint256 newTax) external onlyOwner {
780         _taxOnSell = newTax;
781     }
782 
783     function setDistributionSettings(
784         uint256 newLiquidityShare,
785         uint256 newDevShare,
786         uint256 newBurnShare
787     ) external onlyOwner {
788         _liquidityShares = newLiquidityShare;
789         _devShares = newDevShare;
790         _vaultShares = newBurnShare;
791 
792         _totalDistributionShrs = _liquidityShares.add(_devShares).add(
793             _vaultShares
794         );
795     }
796 
797     function _setMaxTxAmount(uint256 maxTxAmount) external onlyOwner {
798         require(maxTxAmount >= 5, "Max tx should be at least .5%");
799         maxTxAmount = (_totalSupply * maxTxAmount) / 1000;
800     }
801 
802     function enableDisableWalletLimit(bool newValue) external onlyOwner {
803         _checkWalletLimit = newValue;
804     }
805 
806     function set_checkWalletLimitExcept(
807         address holder,
808         bool exempt
809     ) external onlyOwner {
810         _checkWalletLimitExcept[holder] = exempt;
811     }
812 
813     function setWalletMax(uint256 maxWalletAmount) external onlyOwner {
814         require(maxWalletAmount >= 5, "Max wallet should be at least .5%");
815         walletMax = (_totalSupply * maxWalletAmount) / 1000;
816     }
817 
818     function setNumTokensBeforeSwap(uint256 newLimit) external onlyOwner {
819         minimumTokensBeforeSwap = newLimit;
820     }
821 
822     function setDevMarketingWallet(address newAddress) external onlyOwner {
823         devMarketingWallet = payable(newAddress);
824     }
825 
826     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
827         swapAndLiquifyEnabled = _enabled;
828         emit SwapAndLiquifyEnabledUpdated(_enabled);
829     }
830 
831     function setSwapAndLiquifyByLimitOnly(bool newValue) public onlyOwner {
832         swapAndLiquifyByLimitOnly = newValue;
833     }
834 
835     function getCirculatingSupply() public view returns (uint256) {
836         return _totalSupply.sub(balanceOf(deadAddress));
837     }
838 
839     function transferToAddressETH(
840         address payable recipient,
841         uint256 amount
842     ) private {
843         recipient.transfer(amount);
844     }
845 
846     //to recieve ETH from uniswapV2Router when swapping
847     receive() external payable {}
848 
849     function _burn(address account, uint256 amount) internal virtual {
850         require(account != address(0), "ERC20: burn from the zero address");
851 
852         uint256 accountBalance = _balances[account];
853 
854         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
855 
856         unchecked {
857             _balances[account] = accountBalance - amount;
858         }
859         _totalSupply -= amount;
860 
861         emit Transfer(account, address(0), amount);
862     }
863     
864     function getEthOut(uint256 amount) public view returns (uint256 value) {
865         uint256 contractEtherBalance = address(this).balance;
866         uint256 currentSupply = _totalSupply.sub(balanceOf(deadAddress));
867         value = amount.mul(contractEtherBalance).div(currentSupply);
868     }
869 
870     /// @dev burns tokens and receive eth based on the total contract balance and the total supply
871     /// @param amount of tokens to burn
872     function useTheVault(uint256 amount) public returns (bool) {
873         require(balanceOf(_msgSender()) >= amount, "not enough funds to swap");
874 
875         uint256 ethAmount = getEthOut(amount);
876 
877         require(
878             address(this).balance >= ethAmount,
879             "not enough funds in contract"
880         );
881 
882         _burn(_msgSender(), amount);
883         transferToAddressETH(_msgSender(), ethAmount);
884 
885         ethSentFromVault += ethAmount;
886         totalBurned += amount;
887 
888         emit ExchangedOnVault(_msgSender(), amount, ethAmount);
889         return true;
890     }
891 
892     function transfer(
893         address recipient,
894         uint256 amount
895     ) public override returns (bool) {
896         _transfer(_msgSender(), recipient, amount);
897         return true;
898     }
899 
900     function transferFrom(
901         address sender,
902         address recipient,
903         uint256 amount
904     ) public override returns (bool) {
905         _transfer(sender, recipient, amount);
906         _approve(
907             sender,
908             _msgSender(),
909             _allowances[sender][_msgSender()].sub(
910                 amount,
911                 "ERC20: transfer amount exceeds allowance"
912             )
913         );
914         return true;
915     }
916 
917     function _transfer(
918         address sender,
919         address recipient,
920         uint256 amount
921     ) internal virtual {
922         require(sender != address(0), "ERC20: transfer from the zero address");
923         require(recipient != address(0), "ERC20: transfer to the zero address");
924 
925         if (inSwapAndLiquify) {
926             _basicTransfer(sender, recipient, amount);
927         } else {
928 
929             if (!_tradingOpen) {
930                 require(
931                     _checkExcludedFromFees[sender] ||
932                         _checkExcludedFromFees[recipient],
933                     "Trading is not enabled"
934                 );
935             }
936 
937             if (!_checkTxLimitExcept[sender] && !_checkTxLimitExcept[recipient]) {
938                 require(
939                     amount <= maxTxAmount,
940                     "Transfer amount exceeds the maxTxAmount."
941                 );
942             }
943 
944             uint256 contractTokenBalance = balanceOf(address(this));
945             bool overMinimumTokenBalance = contractTokenBalance >=
946                 minimumTokensBeforeSwap;
947 
948             if (
949                 overMinimumTokenBalance &&
950                 !inSwapAndLiquify &&
951                 !_checkMarketPair[sender] &&
952                 swapAndLiquifyEnabled
953             ) {
954                 if (swapAndLiquifyByLimitOnly)
955                     contractTokenBalance = minimumTokensBeforeSwap;
956                 swapAndLiquify(contractTokenBalance);
957             }
958 
959             _balances[sender] = _balances[sender].sub(
960                 amount,
961                 "Insufficient Balance"
962             );
963 
964             uint256 finalAmount = (_checkExcludedFromFees[sender] ||
965                 _checkExcludedFromFees[recipient])
966                 ? amount
967                 : takeFee(sender, recipient, amount);
968 
969             if (_checkWalletLimit && !_checkWalletLimitExcept[recipient])
970                 require(balanceOf(recipient).add(finalAmount) <= walletMax);
971 
972             _balances[recipient] = _balances[recipient].add(finalAmount);
973 
974             emit Transfer(sender, recipient, finalAmount);
975         }
976     }
977 
978     function _basicTransfer(
979         address sender,
980         address recipient,
981         uint256 amount
982     ) internal returns (bool) {
983         _balances[sender] = _balances[sender].sub(
984             amount,
985             "Insufficient Balance"
986         );
987         _balances[recipient] = _balances[recipient].add(amount);
988         emit Transfer(sender, recipient, amount);
989         return true;
990     }
991 
992     function swapAndLiquify(uint256 tAmount) private lockTheSwap {
993         uint256 ethBalanceBeforeSwap = address(this).balance;
994         uint256 tokensForLP = tAmount
995             .mul(_liquidityShares)
996             .div(_totalDistributionShrs)
997             .div(2);
998         uint256 tokensForSwap = tAmount.sub(tokensForLP);
999 
1000         swapTokensForEth(tokensForSwap);
1001         uint256 amountReceived = address(this).balance.sub(
1002             ethBalanceBeforeSwap
1003         );
1004 
1005         uint256 totalETHFee = _totalDistributionShrs.sub(
1006             _liquidityShares.div(2)
1007         );
1008 
1009         uint256 amountETHLiquidity = amountReceived
1010             .mul(_liquidityShares)
1011             .div(totalETHFee)
1012             .div(2);
1013         uint256 amountETHBurn = amountReceived.mul(_vaultShares).div(
1014             totalETHFee
1015         );
1016         uint256 amountETHDev = amountReceived.sub(amountETHLiquidity).sub(
1017             amountETHBurn
1018         );
1019 
1020         if (amountETHDev > 0)
1021             transferToAddressETH(devMarketingWallet, amountETHDev);
1022 
1023         if (amountETHLiquidity > 0 && tokensForLP > 0)
1024             addLiquidity(tokensForLP, amountETHLiquidity);
1025     }
1026 
1027     function swapTokensForEth(uint256 tokenAmount) private {
1028         // generate the uniswap pair path of token -> weth
1029         address[] memory path = new address[](2);
1030         path[0] = address(this);
1031         path[1] = uniswapV2Router.WETH();
1032 
1033         _approve(address(this), address(uniswapV2Router), tokenAmount);
1034 
1035         // make the swap
1036         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1037             tokenAmount,
1038             0, // accept any amount of ETH
1039             path,
1040             address(this), // The contract
1041             block.timestamp
1042         );
1043 
1044         emit SwapTokensForETH(tokenAmount, path);
1045     }
1046 
1047     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1048         // approve token transfer to cover all possible scenarios
1049         _approve(address(this), address(uniswapV2Router), tokenAmount);
1050 
1051         // add the liquidity
1052         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1053             address(this),
1054             tokenAmount,
1055             0, // slippage is unavoidable
1056             0, // slippage is unavoidable
1057             owner(),
1058             block.timestamp
1059         );
1060     }
1061 
1062     function takeFee(
1063         address sender,
1064         address recipient,
1065         uint256 amount
1066     ) internal returns (uint256) {
1067         uint256 feeAmount = 0;
1068 
1069         if (_checkMarketPair[sender]) {
1070             feeAmount = amount.mul(_taxOnBuy).div(100);
1071         } else if (_checkMarketPair[recipient]) {
1072             feeAmount = amount.mul(_taxOnSell).div(100);
1073         }
1074 
1075         if (feeAmount > 0) {
1076             _balances[address(this)] = _balances[address(this)].add(feeAmount);
1077             emit Transfer(sender, address(this), feeAmount);
1078         }
1079 
1080         return amount.sub(feeAmount);
1081     }
1082 
1083     function getStats()
1084         public
1085         view
1086         returns (uint256, uint256, uint256, uint256)
1087     {
1088         return (
1089             totalBurned,
1090             ethSentFromVault,
1091             address(this).balance,
1092             getVaultTokenValue()
1093         );
1094     }
1095 
1096     function getVaultTokenValue() public view returns (uint256) {
1097         uint256 contractEtherBalance = address(this).balance;
1098         uint256 currentSupply = _totalSupply.sub(balanceOf(deadAddress)).div(10 ** 18);
1099         uint256 ratio = contractEtherBalance.div(currentSupply);
1100         return ratio;
1101     }
1102 }