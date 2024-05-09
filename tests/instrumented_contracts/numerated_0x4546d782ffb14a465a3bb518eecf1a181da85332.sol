1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.4;
3 
4 abstract contract Context {
5     function _msgSender() internal view virtual returns (address payable) {
6         return payable(msg.sender);
7     }
8 
9     function _msgData() internal view virtual returns (bytes memory) {
10         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
11         return msg.data;
12     }
13 }
14 
15 interface IERC20 {
16     function totalSupply() external view returns (uint256);
17 
18     function balanceOf(address account) external view returns (uint256);
19 
20     function transfer(address recipient, uint256 amount)
21         external
22         returns (bool);
23 
24     function allowance(address owner, address spender)
25         external
26         view
27         returns (uint256);
28 
29     function approve(address spender, uint256 amount) external returns (bool);
30 
31     function transferFrom(
32         address sender,
33         address recipient,
34         uint256 amount
35     ) external returns (bool);
36 
37     event Transfer(address indexed from, address indexed to, uint256 value);
38     event Approval(
39         address indexed owner,
40         address indexed spender,
41         uint256 value
42     );
43 }
44 
45 library SafeMath {
46     function add(uint256 a, uint256 b) internal pure returns (uint256) {
47         uint256 c = a + b;
48         require(c >= a, "SafeMath: addition overflow");
49 
50         return c;
51     }
52 
53     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
54         return sub(a, b, "SafeMath: subtraction overflow");
55     }
56 
57     function sub(
58         uint256 a,
59         uint256 b,
60         string memory errorMessage
61     ) internal pure returns (uint256) {
62         require(b <= a, errorMessage);
63         uint256 c = a - b;
64 
65         return c;
66     }
67 
68     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
69         if (a == 0) {
70             return 0;
71         }
72 
73         uint256 c = a * b;
74         require(c / a == b, "SafeMath: multiplication overflow");
75 
76         return c;
77     }
78 
79     function div(uint256 a, uint256 b) internal pure returns (uint256) {
80         return div(a, b, "SafeMath: division by zero");
81     }
82 
83     function div(
84         uint256 a,
85         uint256 b,
86         string memory errorMessage
87     ) internal pure returns (uint256) {
88         require(b > 0, errorMessage);
89         uint256 c = a / b;
90         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
91 
92         return c;
93     }
94 
95     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
96         return mod(a, b, "SafeMath: modulo by zero");
97     }
98 
99     function mod(
100         uint256 a,
101         uint256 b,
102         string memory errorMessage
103     ) internal pure returns (uint256) {
104         require(b != 0, errorMessage);
105         return a % b;
106     }
107 }
108 
109 library Address {
110     function isContract(address account) internal view returns (bool) {
111         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
112         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
113         // for accounts without code, i.e. `keccak256('')`
114         bytes32 codehash;
115         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
116         // solhint-disable-next-line no-inline-assembly
117         assembly {
118             codehash := extcodehash(account)
119         }
120         return (codehash != accountHash && codehash != 0x0);
121     }
122 
123     function sendValue(address payable recipient, uint256 amount) internal {
124         require(
125             address(this).balance >= amount,
126             "Address: insufficient balance"
127         );
128 
129         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
130         (bool success, ) = recipient.call{value: amount}("");
131         require(
132             success,
133             "Address: unable to send value, recipient may have reverted"
134         );
135     }
136 
137     function functionCall(address target, bytes memory data)
138         internal
139         returns (bytes memory)
140     {
141         return functionCall(target, data, "Address: low-level call failed");
142     }
143 
144     function functionCall(
145         address target,
146         bytes memory data,
147         string memory errorMessage
148     ) internal returns (bytes memory) {
149         return _functionCallWithValue(target, data, 0, errorMessage);
150     }
151 
152     function functionCallWithValue(
153         address target,
154         bytes memory data,
155         uint256 value
156     ) internal returns (bytes memory) {
157         return
158             functionCallWithValue(
159                 target,
160                 data,
161                 value,
162                 "Address: low-level call with value failed"
163             );
164     }
165 
166     function functionCallWithValue(
167         address target,
168         bytes memory data,
169         uint256 value,
170         string memory errorMessage
171     ) internal returns (bytes memory) {
172         require(
173             address(this).balance >= value,
174             "Address: insufficient balance for call"
175         );
176         return _functionCallWithValue(target, data, value, errorMessage);
177     }
178 
179     function _functionCallWithValue(
180         address target,
181         bytes memory data,
182         uint256 weiValue,
183         string memory errorMessage
184     ) private returns (bytes memory) {
185         require(isContract(target), "Address: call to non-contract");
186 
187         (bool success, bytes memory returndata) = target.call{value: weiValue}(
188             data
189         );
190         if (success) {
191             return returndata;
192         } else {
193             if (returndata.length > 0) {
194                 assembly {
195                     let returndata_size := mload(returndata)
196                     revert(add(32, returndata), returndata_size)
197                 }
198             } else {
199                 revert(errorMessage);
200             }
201         }
202     }
203 }
204 
205 contract Ownable is Context {
206     address private _owner;
207     address private _previousOwner;
208     uint256 private _lockTime;
209 
210     event OwnershipTransferred(
211         address indexed previousOwner,
212         address indexed newOwner
213     );
214 
215     constructor() {
216         address msgSender = _msgSender();
217         _owner = msgSender;
218         emit OwnershipTransferred(address(0), msgSender);
219     }
220 
221     function owner() public view returns (address) {
222         return _owner;
223     }
224 
225     modifier onlyOwner() {
226         require(_owner == _msgSender(), "Ownable: caller is not the owner");
227         _;
228     }
229 
230     function renounceOwnership() public virtual onlyOwner {
231         emit OwnershipTransferred(_owner, address(0));
232         _owner = address(0);
233     }
234 
235     function transferOwnership(address newOwner) public virtual onlyOwner {
236         require(
237             newOwner != address(0),
238             "Ownable: new owner is the zero address"
239         );
240         emit OwnershipTransferred(_owner, newOwner);
241         _owner = newOwner;
242     }
243 }
244 
245 // pragma solidity >=0.5.0;
246 
247 interface IUniswapV2Factory {
248     event PairCreated(
249         address indexed token0,
250         address indexed token1,
251         address pair,
252         uint256
253     );
254 
255     function feeTo() external view returns (address);
256 
257     function feeToSetter() external view returns (address);
258 
259     function getPair(address tokenA, address tokenB)
260         external
261         view
262         returns (address pair);
263 
264     function allPairs(uint256) external view returns (address pair);
265 
266     function allPairsLength() external view returns (uint256);
267 
268     function createPair(address tokenA, address tokenB)
269         external
270         returns (address pair);
271 
272     function setFeeTo(address) external;
273 
274     function setFeeToSetter(address) external;
275 }
276 
277 // pragma solidity >=0.5.0;
278 
279 interface IUniswapV2Pair {
280     event Approval(
281         address indexed owner,
282         address indexed spender,
283         uint256 value
284     );
285     event Transfer(address indexed from, address indexed to, uint256 value);
286 
287     function name() external pure returns (string memory);
288 
289     function symbol() external pure returns (string memory);
290 
291     function decimals() external pure returns (uint8);
292 
293     function totalSupply() external view returns (uint256);
294 
295     function balanceOf(address owner) external view returns (uint256);
296 
297     function allowance(address owner, address spender)
298         external
299         view
300         returns (uint256);
301 
302     function approve(address spender, uint256 value) external returns (bool);
303 
304     function transfer(address to, uint256 value) external returns (bool);
305 
306     function transferFrom(
307         address from,
308         address to,
309         uint256 value
310     ) external returns (bool);
311 
312     function DOMAIN_SEPARATOR() external view returns (bytes32);
313 
314     function PERMIT_TYPEHASH() external pure returns (bytes32);
315 
316     function nonces(address owner) external view returns (uint256);
317 
318     function permit(
319         address owner,
320         address spender,
321         uint256 value,
322         uint256 deadline,
323         uint8 v,
324         bytes32 r,
325         bytes32 s
326     ) external;
327 
328     event Burn(
329         address indexed sender,
330         uint256 amount0,
331         uint256 amount1,
332         address indexed to
333     );
334     event Swap(
335         address indexed sender,
336         uint256 amount0In,
337         uint256 amount1In,
338         uint256 amount0Out,
339         uint256 amount1Out,
340         address indexed to
341     );
342     event Sync(uint112 reserve0, uint112 reserve1);
343 
344     function MINIMUM_LIQUIDITY() external pure returns (uint256);
345 
346     function factory() external view returns (address);
347 
348     function token0() external view returns (address);
349 
350     function token1() external view returns (address);
351 
352     function getReserves()
353         external
354         view
355         returns (
356             uint112 reserve0,
357             uint112 reserve1,
358             uint32 blockTimestampLast
359         );
360 
361     function price0CumulativeLast() external view returns (uint256);
362 
363     function price1CumulativeLast() external view returns (uint256);
364 
365     function kLast() external view returns (uint256);
366 
367     function burn(address to)
368         external
369         returns (uint256 amount0, uint256 amount1);
370 
371     function swap(
372         uint256 amount0Out,
373         uint256 amount1Out,
374         address to,
375         bytes calldata data
376     ) external;
377 
378     function skim(address to) external;
379 
380     function sync() external;
381 
382     function initialize(address, address) external;
383 }
384 
385 // pragma solidity >=0.6.2;
386 
387 interface IUniswapV2Router01 {
388     function factory() external pure returns (address);
389 
390     function WETH() external pure returns (address);
391 
392     function addLiquidity(
393         address tokenA,
394         address tokenB,
395         uint256 amountADesired,
396         uint256 amountBDesired,
397         uint256 amountAMin,
398         uint256 amountBMin,
399         address to,
400         uint256 deadline
401     )
402         external
403         returns (
404             uint256 amountA,
405             uint256 amountB,
406             uint256 liquidity
407         );
408 
409     function addLiquidityETH(
410         address token,
411         uint256 amountTokenDesired,
412         uint256 amountTokenMin,
413         uint256 amountETHMin,
414         address to,
415         uint256 deadline
416     )
417         external
418         payable
419         returns (
420             uint256 amountToken,
421             uint256 amountETH,
422             uint256 liquidity
423         );
424 
425     function removeLiquidity(
426         address tokenA,
427         address tokenB,
428         uint256 liquidity,
429         uint256 amountAMin,
430         uint256 amountBMin,
431         address to,
432         uint256 deadline
433     ) external returns (uint256 amountA, uint256 amountB);
434 
435     function removeLiquidityETH(
436         address token,
437         uint256 liquidity,
438         uint256 amountTokenMin,
439         uint256 amountETHMin,
440         address to,
441         uint256 deadline
442     ) external returns (uint256 amountToken, uint256 amountETH);
443 
444     function removeLiquidityWithPermit(
445         address tokenA,
446         address tokenB,
447         uint256 liquidity,
448         uint256 amountAMin,
449         uint256 amountBMin,
450         address to,
451         uint256 deadline,
452         bool approveMax,
453         uint8 v,
454         bytes32 r,
455         bytes32 s
456     ) external returns (uint256 amountA, uint256 amountB);
457 
458     function removeLiquidityETHWithPermit(
459         address token,
460         uint256 liquidity,
461         uint256 amountTokenMin,
462         uint256 amountETHMin,
463         address to,
464         uint256 deadline,
465         bool approveMax,
466         uint8 v,
467         bytes32 r,
468         bytes32 s
469     ) external returns (uint256 amountToken, uint256 amountETH);
470 
471     function swapExactTokensForTokens(
472         uint256 amountIn,
473         uint256 amountOutMin,
474         address[] calldata path,
475         address to,
476         uint256 deadline
477     ) external returns (uint256[] memory amounts);
478 
479     function swapTokensForExactTokens(
480         uint256 amountOut,
481         uint256 amountInMax,
482         address[] calldata path,
483         address to,
484         uint256 deadline
485     ) external returns (uint256[] memory amounts);
486 
487     function swapExactETHForTokens(
488         uint256 amountOutMin,
489         address[] calldata path,
490         address to,
491         uint256 deadline
492     ) external payable returns (uint256[] memory amounts);
493 
494     function swapTokensForExactETH(
495         uint256 amountOut,
496         uint256 amountInMax,
497         address[] calldata path,
498         address to,
499         uint256 deadline
500     ) external returns (uint256[] memory amounts);
501 
502     function swapExactTokensForETH(
503         uint256 amountIn,
504         uint256 amountOutMin,
505         address[] calldata path,
506         address to,
507         uint256 deadline
508     ) external returns (uint256[] memory amounts);
509 
510     function swapETHForExactTokens(
511         uint256 amountOut,
512         address[] calldata path,
513         address to,
514         uint256 deadline
515     ) external payable returns (uint256[] memory amounts);
516 
517     function quote(
518         uint256 amountA,
519         uint256 reserveA,
520         uint256 reserveB
521     ) external pure returns (uint256 amountB);
522 
523     function getAmountOut(
524         uint256 amountIn,
525         uint256 reserveIn,
526         uint256 reserveOut
527     ) external pure returns (uint256 amountOut);
528 
529     function getAmountIn(
530         uint256 amountOut,
531         uint256 reserveIn,
532         uint256 reserveOut
533     ) external pure returns (uint256 amountIn);
534 
535     function getAmountsOut(uint256 amountIn, address[] calldata path)
536         external
537         view
538         returns (uint256[] memory amounts);
539 
540     function getAmountsIn(uint256 amountOut, address[] calldata path)
541         external
542         view
543         returns (uint256[] memory amounts);
544 }
545 
546 // pragma solidity >=0.6.2;
547 
548 interface IUniswapV2Router02 is IUniswapV2Router01 {
549     function removeLiquidityETHSupportingFeeOnTransferTokens(
550         address token,
551         uint256 liquidity,
552         uint256 amountTokenMin,
553         uint256 amountETHMin,
554         address to,
555         uint256 deadline
556     ) external returns (uint256 amountETH);
557 
558     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
559         address token,
560         uint256 liquidity,
561         uint256 amountTokenMin,
562         uint256 amountETHMin,
563         address to,
564         uint256 deadline,
565         bool approveMax,
566         uint8 v,
567         bytes32 r,
568         bytes32 s
569     ) external returns (uint256 amountETH);
570 
571     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
572         uint256 amountIn,
573         uint256 amountOutMin,
574         address[] calldata path,
575         address to,
576         uint256 deadline
577     ) external;
578 
579     function swapExactETHForTokensSupportingFeeOnTransferTokens(
580         uint256 amountOutMin,
581         address[] calldata path,
582         address to,
583         uint256 deadline
584     ) external payable;
585 
586     function swapExactTokensForETHSupportingFeeOnTransferTokens(
587         uint256 amountIn,
588         uint256 amountOutMin,
589         address[] calldata path,
590         address to,
591         uint256 deadline
592     ) external;
593 }
594 
595 contract Zero is Context, IERC20, Ownable {
596     using SafeMath for uint256;
597     using Address for address;
598 
599     address payable public marketingWallet;
600     address payable public raffleWallet;
601     mapping(address => uint256) private _rOwned;
602     mapping(address => uint256) private _tOwned;
603     mapping(address => mapping(address => uint256)) private _allowances;
604     mapping(address => bool) private _isBot;
605 
606     uint256 public launchedAt = 0;
607 
608     mapping(address => bool) private _isExcludedFromFee;
609     mapping(address => bool) private _isExcluded;
610     address[] private _excluded;
611 
612     uint8 private _decimals = 9;
613 
614     uint256 private constant MAX = ~uint256(0);
615     uint256 private _tTotal = 1000000000 * 10**_decimals;
616     uint256 private _rTotal = (MAX - (MAX % _tTotal));
617     uint256 private _tFeeTotal;
618 
619     string private _name = "Lelouch Lamperouge";
620     string private _symbol = "ZERO";
621 
622     uint256 private reflectionFee = 0;
623 
624     uint256 public liquidityFee = 2;
625     uint256 public marketingFee = 7;
626     uint256 public raffleFee = 2;
627     uint256 public totalFee = liquidityFee.add(marketingFee).add(raffleFee);
628     uint256 private currenttotalFee = totalFee;
629 
630     uint256 public swapThreshold = _tTotal.div(1000).mul(1); //0.1%
631 
632     IUniswapV2Router02 public uniswapV2Router;
633     address public uniswapV2Pair;
634 
635     bool inSwap;
636 
637     bool tradingOpen = false;
638     bool zeroBuyTaxmode = true;
639 
640     event SwapETHForTokens(uint256 amountIn, address[] path);
641 
642     event SwapTokensForETH(uint256 amountIn, address[] path);
643 
644     modifier lockTheSwap() {
645         inSwap = true;
646         _;
647         inSwap = false;
648     }
649 
650     constructor() {
651         _rOwned[_msgSender()] = _rTotal;
652         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
653             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
654         );
655         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
656             .createPair(address(this), _uniswapV2Router.WETH());
657 
658         uniswapV2Router = _uniswapV2Router;
659 
660         _isExcludedFromFee[owner()] = true;
661         _isExcludedFromFee[address(this)] = true;
662 
663         emit Transfer(address(0), _msgSender(), _tTotal);
664     }
665 
666     function openTrading() external onlyOwner {
667         require(!tradingOpen);
668         tradingOpen = true;
669         excludeFromReward(address(this));
670         excludeFromReward(uniswapV2Pair);
671         launchedAt = block.number;
672     }
673 
674     function setNewRouter(address newRouter) external onlyOwner {
675         IUniswapV2Router02 _newRouter = IUniswapV2Router02(newRouter);
676         address get_pair = IUniswapV2Factory(_newRouter.factory()).getPair(
677             address(this),
678             _newRouter.WETH()
679         );
680         if (get_pair == address(0)) {
681             uniswapV2Pair = IUniswapV2Factory(_newRouter.factory()).createPair(
682                 address(this),
683                 _newRouter.WETH()
684             );
685         } else {
686             uniswapV2Pair = get_pair;
687         }
688         uniswapV2Router = _newRouter;
689     }
690 
691     function name() public view returns (string memory) {
692         return _name;
693     }
694 
695     function symbol() public view returns (string memory) {
696         return _symbol;
697     }
698 
699     function decimals() public view returns (uint8) {
700         return _decimals;
701     }
702 
703     function totalSupply() public view override returns (uint256) {
704         return _tTotal;
705     }
706 
707     function balanceOf(address account) public view override returns (uint256) {
708         if (_isExcluded[account]) return _tOwned[account];
709         return tokenFromReflection(_rOwned[account]);
710     }
711 
712     function transfer(address recipient, uint256 amount)
713         public
714         override
715         returns (bool)
716     {
717         _transfer(_msgSender(), recipient, amount);
718         return true;
719     }
720 
721     function allowance(address owner, address spender)
722         public
723         view
724         override
725         returns (uint256)
726     {
727         return _allowances[owner][spender];
728     }
729 
730     function approve(address spender, uint256 amount)
731         public
732         override
733         returns (bool)
734     {
735         _approve(_msgSender(), spender, amount);
736         return true;
737     }
738 
739     function transferFrom(
740         address sender,
741         address recipient,
742         uint256 amount
743     ) public override returns (bool) {
744         _transfer(sender, recipient, amount);
745         _approve(
746             sender,
747             _msgSender(),
748             _allowances[sender][_msgSender()].sub(
749                 amount,
750                 "ERC20: transfer amount exceeds allowance"
751             )
752         );
753         return true;
754     }
755 
756     function increaseAllowance(address spender, uint256 addedValue)
757         public
758         virtual
759         returns (bool)
760     {
761         _approve(
762             _msgSender(),
763             spender,
764             _allowances[_msgSender()][spender].add(addedValue)
765         );
766         return true;
767     }
768 
769     function decreaseAllowance(address spender, uint256 subtractedValue)
770         public
771         virtual
772         returns (bool)
773     {
774         _approve(
775             _msgSender(),
776             spender,
777             _allowances[_msgSender()][spender].sub(
778                 subtractedValue,
779                 "ERC20: decreased allowance below zero"
780             )
781         );
782         return true;
783     }
784 
785     function isExcludedFromReward(address account) public view returns (bool) {
786         return _isExcluded[account];
787     }
788 
789     function zeroBuyingFeesMode() public view returns (bool) {
790         return zeroBuyTaxmode;
791     }
792 
793     function totalFees() public view returns (uint256) {
794         return totalFee;
795     }
796 
797     function deliver(uint256 tAmount) public {
798         address sender = _msgSender();
799         require(
800             !_isExcluded[sender],
801             "Excluded addresses cannot call this function"
802         );
803         (uint256 rAmount, , , , , ) = _getValues(tAmount);
804         _rOwned[sender] = _rOwned[sender].sub(rAmount);
805         _rTotal = _rTotal.sub(rAmount);
806         _tFeeTotal = _tFeeTotal.add(tAmount);
807     }
808 
809     function reflectionFromToken(uint256 tAmount, bool deductTransferFee)
810         public
811         view
812         returns (uint256)
813     {
814         require(tAmount <= _tTotal, "Amount must be less than supply");
815         if (!deductTransferFee) {
816             (uint256 rAmount, , , , , ) = _getValues(tAmount);
817             return rAmount;
818         } else {
819             (, uint256 rTransferAmount, , , , ) = _getValues(tAmount);
820             return rTransferAmount;
821         }
822     }
823 
824     function tokenFromReflection(uint256 rAmount)
825         public
826         view
827         returns (uint256)
828     {
829         require(
830             rAmount <= _rTotal,
831             "Amount must be less than total reflections"
832         );
833         uint256 currentRate = _getRate();
834         return rAmount.div(currentRate);
835     }
836 
837     function excludeFromReward(address account) public onlyOwner {
838         if (_rOwned[account] > 0) {
839             _tOwned[account] = tokenFromReflection(_rOwned[account]);
840         }
841         _isExcluded[account] = true;
842         _excluded.push(account);
843     }
844 
845     function includeInReward(address account) external onlyOwner {
846         require(_isExcluded[account], "Account is already excluded");
847         for (uint256 i = 0; i < _excluded.length; i++) {
848             if (_excluded[i] == account) {
849                 _excluded[i] = _excluded[_excluded.length - 1];
850                 _tOwned[account] = 0;
851                 _isExcluded[account] = false;
852                 _excluded.pop();
853                 break;
854             }
855         }
856     }
857 
858     function _approve(
859         address owner,
860         address spender,
861         uint256 amount
862     ) private {
863         require(owner != address(0), "ERC20: approve from the zero address");
864         require(spender != address(0), "ERC20: approve to the zero address");
865 
866         _allowances[owner][spender] = amount;
867         emit Approval(owner, spender, amount);
868     }
869 
870     function _transfer(
871         address from,
872         address to,
873         uint256 amount
874     ) private {
875         require(from != address(0), "ERC20: transfer from the zero address");
876         require(to != address(0), "ERC20: transfer to the zero address");
877         require(amount > 0, "Transfer amount must be greater than zero");
878         require(!_isBot[to], "You have no power here!");
879         require(!_isBot[from], "You have no power here!");
880         if (from != owner() && to != owner())
881             require(tradingOpen, "Trading not yet enabled.");
882 
883         //no fee on regular wallet transfers
884         bool takeFee = false;
885         if (
886             (from == uniswapV2Pair || to == uniswapV2Pair) &&
887             !(_isExcludedFromFee[from] || _isExcludedFromFee[to])
888         ) {
889             takeFee = true;
890         }
891 
892         currenttotalFee = totalFee;
893 
894         //buys on same block that trading begins are automatically set as bots
895         if (launchedAt == block.number) _isBot[to] = true;
896 
897         //no buy fees if zeroBuyTaxmode is true
898         if (zeroBuyTaxmode && from == uniswapV2Pair) currenttotalFee = 0;
899 
900         //sell
901         if (!inSwap && tradingOpen && to == uniswapV2Pair) {
902             //handle fees collected in the contract
903             uint256 contractTokenBalance = balanceOf(address(this));
904 
905             if (contractTokenBalance >= swapThreshold) {
906                 contractTokenBalance = swapThreshold;
907                 swapTokens(contractTokenBalance);
908             }
909         }
910         _tokenTransfer(from, to, amount, takeFee);
911     }
912 
913     function swapTokens(uint256 contractTokenBalance) private lockTheSwap {
914         //calculate fees and liquidity amounts
915         uint256 amountToLiquify = contractTokenBalance
916             .mul(liquidityFee)
917             .div(totalFee)
918             .div(2);
919 
920         uint256 amountToSwap = contractTokenBalance.sub(amountToLiquify);
921 
922         swapTokensForEth(amountToSwap);
923 
924         uint256 amountETH = address(this).balance;
925 
926         uint256 totalETHFee = totalFee.sub(liquidityFee.div(2));
927 
928         uint256 amountETHLiquidity = amountETH
929             .mul(liquidityFee)
930             .div(totalETHFee)
931             .div(2);
932 
933         uint256 amountETHraffle = amountETH.mul(raffleFee).div(totalETHFee);
934         uint256 amountETHMarketing = amountETH.mul(marketingFee).div(
935             totalETHFee
936         );
937 
938         //Send to marketing wallet and raffle wallet
939         uint256 contractETHBalance = address(this).balance;
940         if (contractETHBalance > 0) {
941             sendETHToFee(amountETHMarketing, marketingWallet);
942             sendETHToFee(amountETHraffle, raffleWallet);
943         }
944 
945         //add liquidity
946         if (amountToLiquify > 0) {
947             addLiquidity(amountToLiquify, amountETHLiquidity);
948         }
949     }
950 
951     function sendETHToFee(uint256 amount, address payable wallet) private {
952         wallet.transfer(amount);
953     }
954 
955     function swapTokensForEth(uint256 tokenAmount) private {
956         address[] memory path = new address[](2);
957         path[0] = address(this);
958         path[1] = uniswapV2Router.WETH();
959 
960         _approve(address(this), address(uniswapV2Router), tokenAmount);
961 
962         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
963             tokenAmount,
964             0,
965             path,
966             address(this),
967             block.timestamp
968         );
969 
970         emit SwapTokensForETH(tokenAmount, path);
971     }
972 
973     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
974         _approve(address(this), address(uniswapV2Router), tokenAmount);
975 
976         uniswapV2Router.addLiquidityETH{value: ethAmount}(
977             address(this),
978             tokenAmount,
979             0,
980             0,
981             owner(),
982             block.timestamp
983         );
984     }
985 
986     function _tokenTransfer(
987         address sender,
988         address recipient,
989         uint256 amount,
990         bool takeFee
991     ) private {
992         uint256 _previousReflectionFee = reflectionFee;
993         uint256 _previousTotalFee = currenttotalFee;
994         if (!takeFee) {
995             reflectionFee = 0;
996             currenttotalFee = 0;
997         }
998 
999         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1000             _transferFromExcluded(sender, recipient, amount);
1001         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1002             _transferToExcluded(sender, recipient, amount);
1003         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1004             _transferBothExcluded(sender, recipient, amount);
1005         } else {
1006             _transferStandard(sender, recipient, amount);
1007         }
1008 
1009         if (!takeFee) {
1010             reflectionFee = _previousReflectionFee;
1011             currenttotalFee = _previousTotalFee;
1012         }
1013     }
1014 
1015     function _transferStandard(
1016         address sender,
1017         address recipient,
1018         uint256 tAmount
1019     ) private {
1020         (
1021             uint256 rAmount,
1022             uint256 rTransferAmount,
1023             uint256 rFee,
1024             uint256 tTransferAmount,
1025             uint256 tFee,
1026             uint256 tLiquidity
1027         ) = _getValues(tAmount);
1028         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1029         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1030         _takeLiquidity(tLiquidity);
1031         _reflectFee(rFee, tFee);
1032         emit Transfer(sender, recipient, tTransferAmount);
1033     }
1034 
1035     function _transferToExcluded(
1036         address sender,
1037         address recipient,
1038         uint256 tAmount
1039     ) private {
1040         (
1041             uint256 rAmount,
1042             uint256 rTransferAmount,
1043             uint256 rFee,
1044             uint256 tTransferAmount,
1045             uint256 tFee,
1046             uint256 tLiquidity
1047         ) = _getValues(tAmount);
1048         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1049         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1050         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1051         _takeLiquidity(tLiquidity);
1052         _reflectFee(rFee, tFee);
1053         emit Transfer(sender, recipient, tTransferAmount);
1054     }
1055 
1056     function _transferFromExcluded(
1057         address sender,
1058         address recipient,
1059         uint256 tAmount
1060     ) private {
1061         (
1062             uint256 rAmount,
1063             uint256 rTransferAmount,
1064             uint256 rFee,
1065             uint256 tTransferAmount,
1066             uint256 tFee,
1067             uint256 tLiquidity
1068         ) = _getValues(tAmount);
1069         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1070         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1071         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1072         _takeLiquidity(tLiquidity);
1073         _reflectFee(rFee, tFee);
1074         emit Transfer(sender, recipient, tTransferAmount);
1075     }
1076 
1077     function _transferBothExcluded(
1078         address sender,
1079         address recipient,
1080         uint256 tAmount
1081     ) private {
1082         (
1083             uint256 rAmount,
1084             uint256 rTransferAmount,
1085             uint256 rFee,
1086             uint256 tTransferAmount,
1087             uint256 tFee,
1088             uint256 tLiquidity
1089         ) = _getValues(tAmount);
1090         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1091         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1092         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1093         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1094         _takeLiquidity(tLiquidity);
1095         _reflectFee(rFee, tFee);
1096         emit Transfer(sender, recipient, tTransferAmount);
1097     }
1098 
1099     function _reflectFee(uint256 rFee, uint256 tFee) private {
1100         _rTotal = _rTotal.sub(rFee);
1101         _tFeeTotal = _tFeeTotal.add(tFee);
1102     }
1103 
1104     function _getValues(uint256 tAmount)
1105         private
1106         view
1107         returns (
1108             uint256,
1109             uint256,
1110             uint256,
1111             uint256,
1112             uint256,
1113             uint256
1114         )
1115     {
1116         (
1117             uint256 tTransferAmount,
1118             uint256 tFee,
1119             uint256 tLiquidity
1120         ) = _getTValues(tAmount);
1121         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(
1122             tAmount,
1123             tFee,
1124             tLiquidity,
1125             _getRate()
1126         );
1127         return (
1128             rAmount,
1129             rTransferAmount,
1130             rFee,
1131             tTransferAmount,
1132             tFee,
1133             tLiquidity
1134         );
1135     }
1136 
1137     function _getTValues(uint256 tAmount)
1138         private
1139         view
1140         returns (
1141             uint256,
1142             uint256,
1143             uint256
1144         )
1145     {
1146         uint256 tFee = tAmount.mul(reflectionFee).div(100);
1147         uint256 tLiquidity = tAmount.mul(currenttotalFee).div(100);
1148         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
1149         return (tTransferAmount, tFee, tLiquidity);
1150     }
1151 
1152     function _getRValues(
1153         uint256 tAmount,
1154         uint256 tFee,
1155         uint256 tLiquidity,
1156         uint256 currentRate
1157     )
1158         private
1159         pure
1160         returns (
1161             uint256,
1162             uint256,
1163             uint256
1164         )
1165     {
1166         uint256 rAmount = tAmount.mul(currentRate);
1167         uint256 rFee = tFee.mul(currentRate);
1168         uint256 rLiquidity = tLiquidity.mul(currentRate);
1169         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
1170         return (rAmount, rTransferAmount, rFee);
1171     }
1172 
1173     function _getRate() private view returns (uint256) {
1174         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1175         return rSupply.div(tSupply);
1176     }
1177 
1178     function _getCurrentSupply() private view returns (uint256, uint256) {
1179         uint256 rSupply = _rTotal;
1180         uint256 tSupply = _tTotal;
1181         for (uint256 i = 0; i < _excluded.length; i++) {
1182             if (
1183                 _rOwned[_excluded[i]] > rSupply ||
1184                 _tOwned[_excluded[i]] > tSupply
1185             ) return (_rTotal, _tTotal);
1186             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1187             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1188         }
1189         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1190         return (rSupply, tSupply);
1191     }
1192 
1193     function _takeLiquidity(uint256 tLiquidity) private {
1194         uint256 currentRate = _getRate();
1195         uint256 rLiquidity = tLiquidity.mul(currentRate);
1196         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1197         if (_isExcluded[address(this)])
1198             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1199     }
1200 
1201     function excludeFromFee(address account) public onlyOwner {
1202         _isExcludedFromFee[account] = true;
1203     }
1204 
1205     function includeInFee(address account) public onlyOwner {
1206         _isExcludedFromFee[account] = false;
1207     }
1208 
1209     function setWallets(address _marketingWallet, address _raffleWallet)
1210         external
1211         onlyOwner
1212     {
1213         marketingWallet = payable(_marketingWallet);
1214         raffleWallet = payable(_raffleWallet);
1215     }
1216 
1217     function setFees(
1218         uint256 _reflectionFee,
1219         uint256 _liquidityFee,
1220         uint256 _raffleFee,
1221         uint256 _marketingFee,
1222         bool _buyTaxMode
1223     ) external onlyOwner {
1224         //calculate fees sum to ensure that it's an acceptable number
1225         uint256 feesSum = _reflectionFee +
1226             _liquidityFee +
1227             _raffleFee +
1228             _marketingFee;
1229 
1230         if (_buyTaxMode) {
1231             //if there are buying fees, max total fees can be 10%
1232             require(feesSum < 10);
1233         } else {
1234             //otherwise, if fees are applicable only on sells, max total can be up to 20%
1235             require(feesSum < 20);
1236         }
1237         reflectionFee = _reflectionFee;
1238         liquidityFee = _liquidityFee;
1239         raffleFee = _raffleFee;
1240         marketingFee = _marketingFee;
1241         totalFee = liquidityFee.add(marketingFee).add(raffleFee);
1242         zeroBuyTaxmode = _buyTaxMode;
1243     }
1244 
1245     function transferToAddressETH(address payable recipient, uint256 amount)
1246         private
1247     {
1248         recipient.transfer(amount);
1249     }
1250 
1251     function isBot(address account) public view returns (bool) {
1252         return _isBot[account];
1253     }
1254 
1255     function setBots(address[] calldata addresses, bool status)
1256         public
1257         onlyOwner
1258     {
1259         for (uint256 i; i < addresses.length; ++i) {
1260             //making sure that LP can not get blacklisted
1261             if (addresses[i] != uniswapV2Pair) _isBot[addresses[i]] = status;
1262         }
1263     }
1264 
1265     function withdrawETH(address payable receipient) public onlyOwner {
1266         receipient.transfer(address(this).balance);
1267     }
1268 
1269     receive() external payable {}
1270 }