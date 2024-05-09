1 // SPDX-License-Identifier: Unlicensed
2 
3 pragma solidity 0.8.19;
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address payable) {
7         return payable(msg.sender);
8     }
9 
10     function _msgData() internal view virtual returns (bytes memory) {
11         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
12         return msg.data;
13     }
14 }
15 
16 interface IERC20 {
17     function totalSupply() external view returns (uint256);
18 
19     function balanceOf(address account) external view returns (uint256);
20 
21     function transfer(
22         address recipient,
23         uint256 amount
24     ) external returns (bool);
25 
26     function allowance(
27         address owner,
28         address spender
29     ) external view returns (uint256);
30 
31     function approve(address spender, uint256 amount) external returns (bool);
32 
33     function transferFrom(
34         address sender,
35         address recipient,
36         uint256 amount
37     ) external returns (bool);
38 
39     event Transfer(address indexed from, address indexed to, uint256 value);
40     event Approval(
41         address indexed owner,
42         address indexed spender,
43         uint256 value
44     );
45 }
46 
47 library SafeMath {
48     function add(uint256 a, uint256 b) internal pure returns (uint256) {
49         uint256 c = a + b;
50         require(c >= a, "SafeMath: addition overflow");
51 
52         return c;
53     }
54 
55     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
56         return sub(a, b, "SafeMath: subtraction overflow");
57     }
58 
59     function sub(
60         uint256 a,
61         uint256 b,
62         string memory errorMessage
63     ) internal pure returns (uint256) {
64         require(b <= a, errorMessage);
65         uint256 c = a - b;
66 
67         return c;
68     }
69 
70     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
71         if (a == 0) {
72             return 0;
73         }
74 
75         uint256 c = a * b;
76         require(c / a == b, "SafeMath: multiplication overflow");
77 
78         return c;
79     }
80 
81     function div(uint256 a, uint256 b) internal pure returns (uint256) {
82         return div(a, b, "SafeMath: division by zero");
83     }
84 
85     function div(
86         uint256 a,
87         uint256 b,
88         string memory errorMessage
89     ) internal pure returns (uint256) {
90         require(b > 0, errorMessage);
91         uint256 c = a / b;
92         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
93 
94         return c;
95     }
96 
97     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
98         return mod(a, b, "SafeMath: modulo by zero");
99     }
100 
101     function mod(
102         uint256 a,
103         uint256 b,
104         string memory errorMessage
105     ) internal pure returns (uint256) {
106         require(b != 0, errorMessage);
107         return a % b;
108     }
109 }
110 
111 library Address {
112     function isContract(address account) internal view returns (bool) {
113         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
114         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
115         // for accounts without code, i.e. `keccak256('')`
116         bytes32 codehash;
117         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
118         // solhint-disable-next-line no-inline-assembly
119         assembly {
120             codehash := extcodehash(account)
121         }
122         return (codehash != accountHash && codehash != 0x0);
123     }
124 
125     function sendValue(address payable recipient, uint256 amount) internal {
126         require(
127             address(this).balance >= amount,
128             "Address: insufficient balance"
129         );
130 
131         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
132         (bool success, ) = recipient.call{value: amount}("");
133         require(
134             success,
135             "Address: unable to send value, recipient may have reverted"
136         );
137     }
138 
139     function functionCall(
140         address target,
141         bytes memory data
142     ) internal returns (bytes memory) {
143         return functionCall(target, data, "Address: low-level call failed");
144     }
145 
146     function functionCall(
147         address target,
148         bytes memory data,
149         string memory errorMessage
150     ) internal returns (bytes memory) {
151         return _functionCallWithValue(target, data, 0, errorMessage);
152     }
153 
154     function functionCallWithValue(
155         address target,
156         bytes memory data,
157         uint256 value
158     ) internal returns (bytes memory) {
159         return
160             functionCallWithValue(
161                 target,
162                 data,
163                 value,
164                 "Address: low-level call with value failed"
165             );
166     }
167 
168     function functionCallWithValue(
169         address target,
170         bytes memory data,
171         uint256 value,
172         string memory errorMessage
173     ) internal returns (bytes memory) {
174         require(
175             address(this).balance >= value,
176             "Address: insufficient balance for call"
177         );
178         return _functionCallWithValue(target, data, value, errorMessage);
179     }
180 
181     function _functionCallWithValue(
182         address target,
183         bytes memory data,
184         uint256 weiValue,
185         string memory errorMessage
186     ) private returns (bytes memory) {
187         require(isContract(target), "Address: call to non-contract");
188 
189         (bool success, bytes memory returndata) = target.call{value: weiValue}(
190             data
191         );
192         if (success) {
193             return returndata;
194         } else {
195             if (returndata.length > 0) {
196                 assembly {
197                     let returndata_size := mload(returndata)
198                     revert(add(32, returndata), returndata_size)
199                 }
200             } else {
201                 revert(errorMessage);
202             }
203         }
204     }
205 }
206 
207 contract Ownable is Context {
208     address private _owner;
209     address private _previousOwner;
210 
211     event OwnershipTransferred(
212         address indexed previousOwner,
213         address indexed newOwner
214     );
215 
216     constructor() {
217         address msgSender = _msgSender();
218         _owner = msgSender;
219         emit OwnershipTransferred(address(0), msgSender);
220     }
221 
222     function owner() public view returns (address) {
223         return _owner;
224     }
225 
226     modifier onlyOwner() {
227         require(_owner == _msgSender(), "Ownable: caller is not the owner");
228         _;
229     }
230 
231     function waiveOwnership() public virtual onlyOwner {
232         emit OwnershipTransferred(_owner, address(0));
233         _owner = address(0);
234     }
235 
236     function transferOwnership(address newOwner) public virtual onlyOwner {
237         require(
238             newOwner != address(0),
239             "Ownable: new owner is the zero address"
240         );
241         emit OwnershipTransferred(_owner, newOwner);
242         _owner = newOwner;
243     }
244 }
245 
246 interface IUniswapV2Factory {
247     event PairCreated(
248         address indexed token0,
249         address indexed token1,
250         address pair,
251         uint
252     );
253 
254     function feeTo() external view returns (address);
255 
256     function feeToSetter() external view returns (address);
257 
258     function getPair(
259         address tokenA,
260         address tokenB
261     ) external view returns (address pair);
262 
263     function allPairs(uint) external view returns (address pair);
264 
265     function allPairsLength() external view returns (uint);
266 
267     function createPair(
268         address tokenA,
269         address tokenB
270     ) external returns (address pair);
271 
272     function setFeeTo(address) external;
273 
274     function setFeeToSetter(address) external;
275 }
276 
277 interface IUniswapV2Pair {
278     event Approval(address indexed owner, address indexed spender, uint value);
279     event Transfer(address indexed from, address indexed to, uint value);
280 
281     function name() external pure returns (string memory);
282 
283     function symbol() external pure returns (string memory);
284 
285     function decimals() external pure returns (uint8);
286 
287     function totalSupply() external view returns (uint);
288 
289     function balanceOf(address owner) external view returns (uint);
290 
291     function allowance(
292         address owner,
293         address spender
294     ) external view returns (uint);
295 
296     function approve(address spender, uint value) external returns (bool);
297 
298     function transfer(address to, uint value) external returns (bool);
299 
300     function transferFrom(
301         address from,
302         address to,
303         uint value
304     ) external returns (bool);
305 
306     function DOMAIN_SEPARATOR() external view returns (bytes32);
307 
308     function PERMIT_TYPEHASH() external pure returns (bytes32);
309 
310     function nonces(address owner) external view returns (uint);
311 
312     function permit(
313         address owner,
314         address spender,
315         uint value,
316         uint deadline,
317         uint8 v,
318         bytes32 r,
319         bytes32 s
320     ) external;
321 
322     event Burn(
323         address indexed sender,
324         uint amount0,
325         uint amount1,
326         address indexed to
327     );
328     event Swap(
329         address indexed sender,
330         uint amount0In,
331         uint amount1In,
332         uint amount0Out,
333         uint amount1Out,
334         address indexed to
335     );
336     event Sync(uint112 reserve0, uint112 reserve1);
337 
338     function MINIMUM_LIQUIDITY() external pure returns (uint);
339 
340     function factory() external view returns (address);
341 
342     function token0() external view returns (address);
343 
344     function token1() external view returns (address);
345 
346     function getReserves()
347         external
348         view
349         returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
350 
351     function price0CumulativeLast() external view returns (uint);
352 
353     function price1CumulativeLast() external view returns (uint);
354 
355     function kLast() external view returns (uint);
356 
357     function burn(address to) external returns (uint amount0, uint amount1);
358 
359     function swap(
360         uint amount0Out,
361         uint amount1Out,
362         address to,
363         bytes calldata data
364     ) external;
365 
366     function skim(address to) external;
367 
368     function sync() external;
369 
370     function initialize(address, address) external;
371 }
372 
373 interface IUniswapV2Router01 {
374     function factory() external pure returns (address);
375 
376     function WETH() external pure returns (address);
377 
378     function addLiquidity(
379         address tokenA,
380         address tokenB,
381         uint amountADesired,
382         uint amountBDesired,
383         uint amountAMin,
384         uint amountBMin,
385         address to,
386         uint deadline
387     ) external returns (uint amountA, uint amountB, uint liquidity);
388 
389     function addLiquidityETH(
390         address token,
391         uint amountTokenDesired,
392         uint amountTokenMin,
393         uint amountETHMin,
394         address to,
395         uint deadline
396     )
397         external
398         payable
399         returns (uint amountToken, uint amountETH, uint liquidity);
400 
401     function removeLiquidity(
402         address tokenA,
403         address tokenB,
404         uint liquidity,
405         uint amountAMin,
406         uint amountBMin,
407         address to,
408         uint deadline
409     ) external returns (uint amountA, uint amountB);
410 
411     function removeLiquidityETH(
412         address token,
413         uint liquidity,
414         uint amountTokenMin,
415         uint amountETHMin,
416         address to,
417         uint deadline
418     ) external returns (uint amountToken, uint amountETH);
419 
420     function removeLiquidityWithPermit(
421         address tokenA,
422         address tokenB,
423         uint liquidity,
424         uint amountAMin,
425         uint amountBMin,
426         address to,
427         uint deadline,
428         bool approveMax,
429         uint8 v,
430         bytes32 r,
431         bytes32 s
432     ) external returns (uint amountA, uint amountB);
433 
434     function removeLiquidityETHWithPermit(
435         address token,
436         uint liquidity,
437         uint amountTokenMin,
438         uint amountETHMin,
439         address to,
440         uint deadline,
441         bool approveMax,
442         uint8 v,
443         bytes32 r,
444         bytes32 s
445     ) external returns (uint amountToken, uint amountETH);
446 
447     function swapExactTokensForTokens(
448         uint amountIn,
449         uint amountOutMin,
450         address[] calldata path,
451         address to,
452         uint deadline
453     ) external returns (uint[] memory amounts);
454 
455     function swapTokensForExactTokens(
456         uint amountOut,
457         uint amountInMax,
458         address[] calldata path,
459         address to,
460         uint deadline
461     ) external returns (uint[] memory amounts);
462 
463     function swapExactETHForTokens(
464         uint amountOutMin,
465         address[] calldata path,
466         address to,
467         uint deadline
468     ) external payable returns (uint[] memory amounts);
469 
470     function swapTokensForExactETH(
471         uint amountOut,
472         uint amountInMax,
473         address[] calldata path,
474         address to,
475         uint deadline
476     ) external returns (uint[] memory amounts);
477 
478     function swapExactTokensForETH(
479         uint amountIn,
480         uint amountOutMin,
481         address[] calldata path,
482         address to,
483         uint deadline
484     ) external returns (uint[] memory amounts);
485 
486     function swapETHForExactTokens(
487         uint amountOut,
488         address[] calldata path,
489         address to,
490         uint deadline
491     ) external payable returns (uint[] memory amounts);
492 
493     function quote(
494         uint amountA,
495         uint reserveA,
496         uint reserveB
497     ) external pure returns (uint amountB);
498 
499     function getAmountOut(
500         uint amountIn,
501         uint reserveIn,
502         uint reserveOut
503     ) external pure returns (uint amountOut);
504 
505     function getAmountIn(
506         uint amountOut,
507         uint reserveIn,
508         uint reserveOut
509     ) external pure returns (uint amountIn);
510 
511     function getAmountsOut(
512         uint amountIn,
513         address[] calldata path
514     ) external view returns (uint[] memory amounts);
515 
516     function getAmountsIn(
517         uint amountOut,
518         address[] calldata path
519     ) external view returns (uint[] memory amounts);
520 }
521 
522 interface IUniswapV2Router02 is IUniswapV2Router01 {
523     function removeLiquidityETHSupportingFeeOnTransferTokens(
524         address token,
525         uint liquidity,
526         uint amountTokenMin,
527         uint amountETHMin,
528         address to,
529         uint deadline
530     ) external returns (uint amountETH);
531 
532     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
533         address token,
534         uint liquidity,
535         uint amountTokenMin,
536         uint amountETHMin,
537         address to,
538         uint deadline,
539         bool approveMax,
540         uint8 v,
541         bytes32 r,
542         bytes32 s
543     ) external returns (uint amountETH);
544 
545     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
546         uint amountIn,
547         uint amountOutMin,
548         address[] calldata path,
549         address to,
550         uint deadline
551     ) external;
552 
553     function swapExactETHForTokensSupportingFeeOnTransferTokens(
554         uint amountOutMin,
555         address[] calldata path,
556         address to,
557         uint deadline
558     ) external payable;
559 
560     function swapExactTokensForETHSupportingFeeOnTransferTokens(
561         uint amountIn,
562         uint amountOutMin,
563         address[] calldata path,
564         address to,
565         uint deadline
566     ) external;
567 }
568 
569 contract Scorch is Context, IERC20, Ownable {
570     using SafeMath for uint256;
571 
572     uint256 public totalBurned = 0;
573     uint256 public totalBurnRewards = 0;
574 
575     uint256 public burnCapDivisor = 10;
576     uint256 public burnSub1EthCap = 100000000000000000;
577 
578     string private _name = "Scorch";
579     string private _symbol = "OTC";
580     uint8 private _decimals = 18;
581     mapping(address => uint256) _balances;
582     mapping(address => mapping(address => uint256)) private _allowances;
583 
584     address payable private devMarketingWallet =
585         payable(0xAd844b2EfB384Eb2fbE795F99B3c5dE22c5446fD);
586     address public immutable deadAddress =
587         0x000000000000000000000000000000000000dEaD;
588 
589     uint256 public _buyDevFees = 1;
590     uint256 public _buyBurnFees = 3;
591 
592     uint256 public _sellDevFees = 1;
593     uint256 public _sellBurnFees = 3;
594 
595     uint256 public _devShares = 1;
596     uint256 public _burnShares = 3;
597 
598     uint256 public _totalTaxIfBuying = 4;
599     uint256 public _totalTaxIfSelling = 4;
600     uint256 public _totalDistributionShares = 4;
601 
602     uint256 public percentForLPBurn = 25;
603     bool public lpBurnEnabled = true;
604     uint256 public lpBurnFrequency = 3600 seconds;
605     uint256 public lastLpBurnTime;
606 
607     // Fees / MaxWallet / TxLimit exemption mappings
608 
609     mapping(address => bool) public checkExcludedFromFees;
610     mapping(address => bool) public checkMarketPair;
611 
612     // Supply / Max Tx tokenomics
613 
614     uint256 private _totalSupply = 10000000 * 10 ** 18;
615     uint256 private minimumTokensBeforeSwap = (_totalSupply * 20) / 10000;
616 
617     IUniswapV2Router02 public uniswapV2Router;
618     address public uniswapPair;
619 
620     // Swap and liquify flags (for taxes)
621 
622     bool private inSwapAndLiquify;
623     bool public swapAndLiquifyEnabled = true;
624     bool public swapAndLiquifyByLimitOnly = false;
625 
626     // events & modifiers
627 
628     event BurnedTokensForEth(
629         address account,
630         uint256 burnAmount,
631         uint256 ethRecievedAmount
632     );
633 
634     event SwapAndLiquifyEnabledUpdated(bool enabled);
635     event SwapAndLiquify(
636         uint256 tokensSwapped,
637         uint256 ethReceived,
638         uint256 tokensIntoLiqudity
639     );
640 
641     event SwapETHForTokens(uint256 amountIn, address[] path);
642 
643     event SwapTokensForETH(uint256 amountIn, address[] path);
644 
645     modifier lockTheSwap() {
646         inSwapAndLiquify = true;
647         _;
648         inSwapAndLiquify = false;
649     }
650 
651     constructor() {
652         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
653             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
654         );
655 
656         uniswapPair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(
657             address(this),
658             _uniswapV2Router.WETH()
659         );
660 
661         uniswapV2Router = _uniswapV2Router;
662         _allowances[address(this)][address(uniswapV2Router)] = _totalSupply;
663 
664         checkExcludedFromFees[owner()] = true;
665         checkExcludedFromFees[address(this)] = true;
666 
667         _totalTaxIfBuying = _buyDevFees.add(_buyBurnFees);
668         _totalTaxIfSelling = _sellDevFees.add(_sellBurnFees);
669         _totalDistributionShares = _devShares.add(_burnShares);
670 
671         checkMarketPair[address(uniswapPair)] = true;
672 
673         _balances[_msgSender()] = _totalSupply;
674         emit Transfer(address(0), _msgSender(), _totalSupply);
675     }
676 
677     function _burn(address account, uint256 amount) internal virtual {
678         require(account != address(0), "ERC20: burn from the zero address");
679 
680         uint256 accountBalance = _balances[account];
681         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
682         unchecked {
683             _balances[account] = accountBalance - amount;
684         }
685         _totalSupply -= amount;
686 
687         emit Transfer(account, address(0), amount);
688     }
689 
690     function name() public view returns (string memory) {
691         return _name;
692     }
693 
694     function symbol() public view returns (string memory) {
695         return _symbol;
696     }
697 
698     function decimals() public view returns (uint8) {
699         return _decimals;
700     }
701 
702     function totalSupply() public view override returns (uint256) {
703         return _totalSupply;
704     }
705 
706     function balanceOf(address account) public view override returns (uint256) {
707         return _balances[account];
708     }
709 
710     function allowance(
711         address owner,
712         address spender
713     ) public view override returns (uint256) {
714         return _allowances[owner][spender];
715     }
716 
717     function increaseAllowance(
718         address spender,
719         uint256 addedValue
720     ) public virtual returns (bool) {
721         _approve(
722             _msgSender(),
723             spender,
724             _allowances[_msgSender()][spender].add(addedValue)
725         );
726         return true;
727     }
728 
729     function decreaseAllowance(
730         address spender,
731         uint256 subtractedValue
732     ) public virtual returns (bool) {
733         _approve(
734             _msgSender(),
735             spender,
736             _allowances[_msgSender()][spender].sub(
737                 subtractedValue,
738                 "ERC20: decreased allowance below zero"
739             )
740         );
741         return true;
742     }
743 
744     function approve(
745         address spender,
746         uint256 amount
747     ) public override returns (bool) {
748         _approve(_msgSender(), spender, amount);
749         return true;
750     }
751 
752     function _approve(
753         address owner,
754         address spender,
755         uint256 amount
756     ) internal virtual {
757         require(owner != address(0), "ERC20: approve from the zero address");
758         require(spender != address(0), "ERC20: approve to the zero address");
759 
760         _allowances[owner][spender] = amount;
761         emit Approval(owner, spender, amount);
762     }
763 
764     function addMarketPair(address account) public onlyOwner {
765         checkMarketPair[account] = true;
766     }
767 
768     function setcheckExcludedFromFees(
769         address account,
770         bool newValue
771     ) public onlyOwner {
772         checkExcludedFromFees[account] = newValue;
773     }
774 
775     function setBuyFee(
776         uint256 newDevTax,
777         uint256 newBurnTax
778     ) external onlyOwner {
779         _buyDevFees = newDevTax;
780         _buyBurnFees = newBurnTax;
781 
782         _totalTaxIfBuying = _buyDevFees.add(_buyBurnFees);
783         require(
784             _totalTaxIfBuying <= 5,
785             "Total buy fees cannot be more than 5%"
786         );
787     }
788 
789     function setSellFee(
790         uint256 newDevTax,
791         uint256 newBurnTax
792     ) external onlyOwner {
793         _sellDevFees = newDevTax;
794         _sellBurnFees = newBurnTax;
795 
796         _totalTaxIfSelling = _sellDevFees.add(_sellBurnFees);
797         require(
798             _totalTaxIfSelling <= 5,
799             "Total sell fees cannot be more than 5%"
800         );
801     }
802 
803     function setDistributionSettings(
804         uint256 newDevShare,
805         uint256 newBurnShare
806     ) external onlyOwner {
807         _devShares = newDevShare;
808         _burnShares = newBurnShare;
809 
810         _totalDistributionShares = _devShares.add(_burnShares);
811     }
812 
813     function setNumTokensBeforeSwap(uint256 newLimit) external onlyOwner {
814         minimumTokensBeforeSwap =  (newLimit * totalSupply()) / 10000;
815     }
816 
817     function setDevMarketingWallet(address newAddress) external onlyOwner {
818         devMarketingWallet = payable(newAddress);
819     }
820 
821     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
822         swapAndLiquifyEnabled = _enabled;
823         emit SwapAndLiquifyEnabledUpdated(_enabled);
824     }
825 
826     function setSwapAndLiquifyByLimitOnly(bool newValue) public onlyOwner {
827         swapAndLiquifyByLimitOnly = newValue;
828     }
829 
830     function getCirculatingSupply() public view returns (uint256) {
831         return _totalSupply.sub(balanceOf(deadAddress));
832     }
833 
834     function transferToAddressETH(
835         address payable recipient,
836         uint256 amount
837     ) private {
838         recipient.transfer(amount);
839     }
840 
841     //to recieve ETH from uniswapV2Router when swapping
842     receive() external payable {}
843 
844     // msg.sender burns tokens and recieve uniswap rate TAX FREE, instead of selling.
845     function scorch(uint256 amount) public returns (bool) {
846         require(balanceOf(_msgSender()) >= amount, "not enough funds to burn");
847 
848         address[] memory path = new address[](2);
849         path[0] = address(this);
850         path[1] = uniswapV2Router.WETH();
851 
852         uint[] memory a = uniswapV2Router.getAmountsOut(amount, path);
853 
854         uint256 cap;
855         if (address(this).balance <= 1 ether) {
856             cap = burnSub1EthCap;
857         } else {
858             cap = address(this).balance / burnCapDivisor;
859         }
860 
861         require(a[a.length - 1] <= cap, "amount greater than cap");
862         require(
863             address(this).balance >= a[a.length - 1],
864             "not enough funds in contract"
865         );
866 
867         transferToAddressETH(_msgSender(), a[a.length - 1]);
868         _burn(_msgSender(), amount);
869 
870         totalBurnRewards += a[a.length - 1];
871         totalBurned += amount;
872 
873         emit BurnedTokensForEth(_msgSender(), amount, a[a.length - 1]);
874         return true;
875     }
876 
877     /// @notice A read function that returns the amount of eth received if you burned X amount of tokens
878     /// @param amount The amount of tokens you want to burn
879     function getEthOut(uint256 amount) public view returns (uint256) {
880         address[] memory path = new address[](2);
881         path[0] = address(this);
882         path[1] = uniswapV2Router.WETH();
883 
884         uint[] memory a = uniswapV2Router.getAmountsOut(amount, path);
885 
886         return a[a.length - 1];
887     }
888 
889     function transfer(
890         address recipient,
891         uint256 amount
892     ) public override returns (bool) {
893         _transfer(_msgSender(), recipient, amount);
894         return true;
895     }
896 
897     function transferFrom(
898         address sender,
899         address recipient,
900         uint256 amount
901     ) public override returns (bool) {
902         _transfer(sender, recipient, amount);
903         _approve(
904             sender,
905             _msgSender(),
906             _allowances[sender][_msgSender()].sub(
907                 amount,
908                 "ERC20: transfer amount exceeds allowance"
909             )
910         );
911         return true;
912     }
913 
914     function _transfer(
915         address sender,
916         address recipient,
917         uint256 amount
918     ) internal virtual {
919         require(sender != address(0), "ERC20: transfer from the zero address");
920         require(recipient != address(0), "ERC20: transfer to the zero address");
921 
922         if (inSwapAndLiquify) {
923             _basicTransfer(sender, recipient, amount);
924         } else {
925             uint256 contractTokenBalance = balanceOf(address(this));
926             bool overMinimumTokenBalance = contractTokenBalance >=
927                 minimumTokensBeforeSwap;
928 
929             if (
930                 overMinimumTokenBalance &&
931                 !inSwapAndLiquify &&
932                 !checkMarketPair[sender] &&
933                 swapAndLiquifyEnabled
934             ) {
935                 if (swapAndLiquifyByLimitOnly)
936                     contractTokenBalance = minimumTokensBeforeSwap;
937                 swapAndLiquify(contractTokenBalance);
938             }
939 
940             if (
941                 !inSwapAndLiquify &&
942                 checkMarketPair[recipient] &&
943                 lpBurnEnabled &&
944                 block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
945                 !checkExcludedFromFees[sender]
946             ) {
947                 autoBurnLiquidityPairTokens();
948             }
949 
950             _balances[sender] = _balances[sender].sub(
951                 amount,
952                 "Insufficient Balance"
953             );
954 
955             uint256 finalAmount = (checkExcludedFromFees[sender] ||
956                 checkExcludedFromFees[recipient])
957                 ? amount
958                 : takeFee(sender, recipient, amount);
959 
960             _balances[recipient] = _balances[recipient].add(finalAmount);
961 
962             emit Transfer(sender, recipient, finalAmount);
963         }
964     }
965 
966     function _basicTransfer(
967         address sender,
968         address recipient,
969         uint256 amount
970     ) internal returns (bool) {
971         _balances[sender] = _balances[sender].sub(
972             amount,
973             "Insufficient Balance"
974         );
975         _balances[recipient] = _balances[recipient].add(amount);
976         emit Transfer(sender, recipient, amount);
977         return true;
978     }
979 
980     function swapAndLiquify(uint256 tAmount) private lockTheSwap {
981         uint256 ethBalanceBeforeSwap = address(this).balance;
982         uint256 tokensForSwap = tAmount;
983 
984         swapTokensForEth(tokensForSwap);
985         uint256 amountReceived = address(this).balance.sub(
986             ethBalanceBeforeSwap
987         );
988 
989         uint256 amountETHBurn = amountReceived.mul(_burnShares).div(
990             _totalDistributionShares
991         );
992         uint256 amountETHDev = amountReceived.sub(amountETHBurn);
993 
994         if (amountETHDev > 0)
995             transferToAddressETH(devMarketingWallet, amountETHDev);
996     }
997 
998     function swapTokensForEth(uint256 tokenAmount) private {
999         // generate the uniswap pair path of token -> weth
1000         address[] memory path = new address[](2);
1001         path[0] = address(this);
1002         path[1] = uniswapV2Router.WETH();
1003 
1004         _approve(address(this), address(uniswapV2Router), tokenAmount);
1005 
1006         // make the swap
1007         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1008             tokenAmount,
1009             0, // accept any amount of ETH
1010             path,
1011             address(this), // The contract
1012             block.timestamp
1013         );
1014 
1015         emit SwapTokensForETH(tokenAmount, path);
1016     }
1017 
1018     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1019         // approve token transfer to cover all possible scenarios
1020         _approve(address(this), address(uniswapV2Router), tokenAmount);
1021 
1022         // add the liquidity
1023         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1024             address(this),
1025             tokenAmount,
1026             0, // slippage is unavoidable
1027             0, // slippage is unavoidable
1028             owner(),
1029             block.timestamp
1030         );
1031     }
1032 
1033     function takeFee(
1034         address sender,
1035         address recipient,
1036         uint256 amount
1037     ) internal returns (uint256) {
1038         uint256 feeAmount = 0;
1039 
1040         if (checkMarketPair[sender]) {
1041             feeAmount = amount.mul(_totalTaxIfBuying).div(100);
1042         } else if (checkMarketPair[recipient]) {
1043             feeAmount = amount.mul(_totalTaxIfSelling).div(100);
1044         }
1045 
1046         if (feeAmount > 0) {
1047             _balances[address(this)] = _balances[address(this)].add(feeAmount);
1048             emit Transfer(sender, address(this), feeAmount);
1049         }
1050 
1051         return amount.sub(feeAmount);
1052     }
1053 
1054     function getStats() public view returns (uint256, uint256, uint256) {
1055         return (totalBurned, totalBurnRewards, address(this).balance);
1056     }
1057 
1058     function autoBurnLiquidityPairTokens() internal returns (bool) {
1059         lastLpBurnTime = block.timestamp;
1060 
1061         // get balance of liquidity pair
1062         uint256 liquidityPairBalance = balanceOf(uniswapPair);
1063 
1064         // calculate amount to burn
1065         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1066             10000
1067         );
1068 
1069         // pull tokens from uniswap liquidity and burn them
1070         if (amountToBurn > 0) {
1071             _burn(uniswapPair, amountToBurn);
1072             totalBurned += amountToBurn; 
1073         }
1074 
1075         //sync price since this is not in a swap transaction!
1076         IUniswapV2Pair pair = IUniswapV2Pair(uniswapPair);
1077         pair.sync();
1078         return true;
1079     }
1080 }