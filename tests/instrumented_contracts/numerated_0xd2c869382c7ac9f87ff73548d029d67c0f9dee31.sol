1 /**
2 
3 ██╗    ██╗ █████╗  ██████╗ ██╗███████╗██████╗  ██████╗ ████████╗
4 ██║    ██║██╔══██╗██╔════╝ ██║██╔════╝██╔══██╗██╔═══██╗╚══██╔══╝
5 ██║ █╗ ██║███████║██║  ███╗██║█████╗  ██████╔╝██║   ██║   ██║   
6 ██║███╗██║██╔══██║██║   ██║██║██╔══╝  ██╔══██╗██║   ██║   ██║   
7 ╚███╔███╔╝██║  ██║╚██████╔╝██║███████╗██████╔╝╚██████╔╝   ██║   
8  ╚══╝╚══╝ ╚═╝  ╚═╝ ╚═════╝ ╚═╝╚══════╝╚═════╝  ╚═════╝    ╚═╝   
9 
10 Bringing Sniping, Tracking, Trading, Copy Trading and more directly to your Messaging Apps.
11 
12 Bot: t.me/wagiebot
13 Website: wagiebot.com
14 Twitter: twitter.com/0xWagieBot
15 Portal: t.me/wagiebotportal
16 
17 In active development since February 2023 and Stealth Launched on July 10th 2023. Full Development logs available.
18 
19 */
20 
21 // SPDX-License-Identifier: Unlicensed
22 
23 pragma solidity ^0.8.18;
24 
25 abstract contract Context {
26     function _msgSender() internal view virtual returns (address payable) {
27         return payable(msg.sender);
28     }
29 
30     function _msgData() internal view virtual returns (bytes memory) {
31         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
32         return msg.data;
33     }
34 }
35 
36 interface IERC20 {
37     function totalSupply() external view returns (uint256);
38 
39     function balanceOf(address account) external view returns (uint256);
40 
41     function transfer(
42         address recipient,
43         uint256 amount
44     ) external returns (bool);
45 
46     function allowance(
47         address owner,
48         address spender
49     ) external view returns (uint256);
50 
51     function approve(address spender, uint256 amount) external returns (bool);
52 
53     function transferFrom(
54         address sender,
55         address recipient,
56         uint256 amount
57     ) external returns (bool);
58 
59     event Transfer(address indexed from, address indexed to, uint256 value);
60     event Approval(
61         address indexed owner,
62         address indexed spender,
63         uint256 value
64     );
65 }
66 
67 library SafeMath {
68     function add(uint256 a, uint256 b) internal pure returns (uint256) {
69         uint256 c = a + b;
70         require(c >= a, "SafeMath: addition overflow");
71 
72         return c;
73     }
74 
75     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
76         return sub(a, b, "SafeMath: subtraction overflow");
77     }
78 
79     function sub(
80         uint256 a,
81         uint256 b,
82         string memory errorMessage
83     ) internal pure returns (uint256) {
84         require(b <= a, errorMessage);
85         uint256 c = a - b;
86 
87         return c;
88     }
89 
90     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
91         if (a == 0) {
92             return 0;
93         }
94 
95         uint256 c = a * b;
96         require(c / a == b, "SafeMath: multiplication overflow");
97 
98         return c;
99     }
100 
101     function div(uint256 a, uint256 b) internal pure returns (uint256) {
102         return div(a, b, "SafeMath: division by zero");
103     }
104 
105     function div(
106         uint256 a,
107         uint256 b,
108         string memory errorMessage
109     ) internal pure returns (uint256) {
110         require(b > 0, errorMessage);
111         uint256 c = a / b;
112         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
113 
114         return c;
115     }
116 
117     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
118         return mod(a, b, "SafeMath: modulo by zero");
119     }
120 
121     function mod(
122         uint256 a,
123         uint256 b,
124         string memory errorMessage
125     ) internal pure returns (uint256) {
126         require(b != 0, errorMessage);
127         return a % b;
128     }
129 }
130 
131 library Address {
132     function isContract(address account) internal view returns (bool) {
133         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
134         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
135         // for accounts without code, i.e. `keccak256('')`
136         bytes32 codehash;
137         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
138         // solhint-disable-next-line no-inline-assembly
139         assembly {
140             codehash := extcodehash(account)
141         }
142         return (codehash != accountHash && codehash != 0x0);
143     }
144 
145     function sendValue(address payable recipient, uint256 amount) internal {
146         require(
147             address(this).balance >= amount,
148             "Address: insufficient balance"
149         );
150 
151         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
152         (bool success, ) = recipient.call{value: amount}("");
153         require(
154             success,
155             "Address: unable to send value, recipient may have reverted"
156         );
157     }
158 
159     function functionCall(
160         address target,
161         bytes memory data
162     ) internal returns (bytes memory) {
163         return functionCall(target, data, "Address: low-level call failed");
164     }
165 
166     function functionCall(
167         address target,
168         bytes memory data,
169         string memory errorMessage
170     ) internal returns (bytes memory) {
171         return _functionCallWithValue(target, data, 0, errorMessage);
172     }
173 
174     function functionCallWithValue(
175         address target,
176         bytes memory data,
177         uint256 value
178     ) internal returns (bytes memory) {
179         return
180             functionCallWithValue(
181                 target,
182                 data,
183                 value,
184                 "Address: low-level call with value failed"
185             );
186     }
187 
188     function functionCallWithValue(
189         address target,
190         bytes memory data,
191         uint256 value,
192         string memory errorMessage
193     ) internal returns (bytes memory) {
194         require(
195             address(this).balance >= value,
196             "Address: insufficient balance for call"
197         );
198         return _functionCallWithValue(target, data, value, errorMessage);
199     }
200 
201     function _functionCallWithValue(
202         address target,
203         bytes memory data,
204         uint256 weiValue,
205         string memory errorMessage
206     ) private returns (bytes memory) {
207         require(isContract(target), "Address: call to non-contract");
208 
209         (bool success, bytes memory returndata) = target.call{value: weiValue}(
210             data
211         );
212         if (success) {
213             return returndata;
214         } else {
215             if (returndata.length > 0) {
216                 assembly {
217                     let returndata_size := mload(returndata)
218                     revert(add(32, returndata), returndata_size)
219                 }
220             } else {
221                 revert(errorMessage);
222             }
223         }
224     }
225 }
226 
227 contract Ownable is Context {
228     address private _owner;
229     address private _previousOwner;
230     uint256 private _lockTime;
231 
232     event OwnershipTransferred(
233         address indexed previousOwner,
234         address indexed newOwner
235     );
236 
237     constructor() {
238         address msgSender = _msgSender();
239         _owner = msgSender;
240         emit OwnershipTransferred(address(0), msgSender);
241     }
242 
243     function owner() public view returns (address) {
244         return _owner;
245     }
246 
247     modifier onlyOwner() {
248         require(_owner == _msgSender(), "Ownable: caller is not the owner");
249         _;
250     }
251 
252     function renounceOwnership() public virtual onlyOwner {
253         emit OwnershipTransferred(_owner, address(0));
254         _owner = address(0);
255     }
256 
257     function transferOwnership(address newOwner) public virtual onlyOwner {
258         require(
259             newOwner != address(0),
260             "Ownable: new owner is the zero address"
261         );
262         emit OwnershipTransferred(_owner, newOwner);
263         _owner = newOwner;
264     }
265 }
266 
267 // pragma solidity >=0.5.0;
268 
269 interface IUniswapV2Factory {
270     event PairCreated(
271         address indexed token0,
272         address indexed token1,
273         address pair,
274         uint
275     );
276 
277     function feeTo() external view returns (address);
278 
279     function feeToSetter() external view returns (address);
280 
281     function getPair(
282         address tokenA,
283         address tokenB
284     ) external view returns (address pair);
285 
286     function allPairs(uint) external view returns (address pair);
287 
288     function allPairsLength() external view returns (uint);
289 
290     function createPair(
291         address tokenA,
292         address tokenB
293     ) external returns (address pair);
294 
295     function setFeeTo(address) external;
296 
297     function setFeeToSetter(address) external;
298 }
299 
300 // pragma solidity >=0.5.0;
301 
302 interface IUniswapV2Pair {
303     event Approval(address indexed owner, address indexed spender, uint value);
304     event Transfer(address indexed from, address indexed to, uint value);
305 
306     function name() external pure returns (string memory);
307 
308     function symbol() external pure returns (string memory);
309 
310     function decimals() external pure returns (uint8);
311 
312     function totalSupply() external view returns (uint);
313 
314     function balanceOf(address owner) external view returns (uint);
315 
316     function allowance(
317         address owner,
318         address spender
319     ) external view returns (uint);
320 
321     function approve(address spender, uint value) external returns (bool);
322 
323     function transfer(address to, uint value) external returns (bool);
324 
325     function transferFrom(
326         address from,
327         address to,
328         uint value
329     ) external returns (bool);
330 
331     function DOMAIN_SEPARATOR() external view returns (bytes32);
332 
333     function PERMIT_TYPEHASH() external pure returns (bytes32);
334 
335     function nonces(address owner) external view returns (uint);
336 
337     function permit(
338         address owner,
339         address spender,
340         uint value,
341         uint deadline,
342         uint8 v,
343         bytes32 r,
344         bytes32 s
345     ) external;
346 
347     event Burn(
348         address indexed sender,
349         uint amount0,
350         uint amount1,
351         address indexed to
352     );
353     event Swap(
354         address indexed sender,
355         uint amount0In,
356         uint amount1In,
357         uint amount0Out,
358         uint amount1Out,
359         address indexed to
360     );
361     event Sync(uint112 reserve0, uint112 reserve1);
362 
363     function MINIMUM_LIQUIDITY() external pure returns (uint);
364 
365     function factory() external view returns (address);
366 
367     function token0() external view returns (address);
368 
369     function token1() external view returns (address);
370 
371     function getReserves()
372         external
373         view
374         returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
375 
376     function price0CumulativeLast() external view returns (uint);
377 
378     function price1CumulativeLast() external view returns (uint);
379 
380     function kLast() external view returns (uint);
381 
382     function burn(address to) external returns (uint amount0, uint amount1);
383 
384     function swap(
385         uint amount0Out,
386         uint amount1Out,
387         address to,
388         bytes calldata data
389     ) external;
390 
391     function skim(address to) external;
392 
393     function sync() external;
394 
395     function initialize(address, address) external;
396 }
397 
398 // pragma solidity >=0.6.2;
399 
400 interface IUniswapV2Router01 {
401     function factory() external pure returns (address);
402 
403     function WETH() external pure returns (address);
404 
405     function addLiquidity(
406         address tokenA,
407         address tokenB,
408         uint amountADesired,
409         uint amountBDesired,
410         uint amountAMin,
411         uint amountBMin,
412         address to,
413         uint deadline
414     ) external returns (uint amountA, uint amountB, uint liquidity);
415 
416     function addLiquidityETH(
417         address token,
418         uint amountTokenDesired,
419         uint amountTokenMin,
420         uint amountETHMin,
421         address to,
422         uint deadline
423     )
424         external
425         payable
426         returns (uint amountToken, uint amountETH, uint liquidity);
427 
428     function removeLiquidity(
429         address tokenA,
430         address tokenB,
431         uint liquidity,
432         uint amountAMin,
433         uint amountBMin,
434         address to,
435         uint deadline
436     ) external returns (uint amountA, uint amountB);
437 
438     function removeLiquidityETH(
439         address token,
440         uint liquidity,
441         uint amountTokenMin,
442         uint amountETHMin,
443         address to,
444         uint deadline
445     ) external returns (uint amountToken, uint amountETH);
446 
447     function removeLiquidityWithPermit(
448         address tokenA,
449         address tokenB,
450         uint liquidity,
451         uint amountAMin,
452         uint amountBMin,
453         address to,
454         uint deadline,
455         bool approveMax,
456         uint8 v,
457         bytes32 r,
458         bytes32 s
459     ) external returns (uint amountA, uint amountB);
460 
461     function removeLiquidityETHWithPermit(
462         address token,
463         uint liquidity,
464         uint amountTokenMin,
465         uint amountETHMin,
466         address to,
467         uint deadline,
468         bool approveMax,
469         uint8 v,
470         bytes32 r,
471         bytes32 s
472     ) external returns (uint amountToken, uint amountETH);
473 
474     function swapExactTokensForTokens(
475         uint amountIn,
476         uint amountOutMin,
477         address[] calldata path,
478         address to,
479         uint deadline
480     ) external returns (uint[] memory amounts);
481 
482     function swapTokensForExactTokens(
483         uint amountOut,
484         uint amountInMax,
485         address[] calldata path,
486         address to,
487         uint deadline
488     ) external returns (uint[] memory amounts);
489 
490     function swapExactETHForTokens(
491         uint amountOutMin,
492         address[] calldata path,
493         address to,
494         uint deadline
495     ) external payable returns (uint[] memory amounts);
496 
497     function swapTokensForExactETH(
498         uint amountOut,
499         uint amountInMax,
500         address[] calldata path,
501         address to,
502         uint deadline
503     ) external returns (uint[] memory amounts);
504 
505     function swapExactTokensForETH(
506         uint amountIn,
507         uint amountOutMin,
508         address[] calldata path,
509         address to,
510         uint deadline
511     ) external returns (uint[] memory amounts);
512 
513     function swapETHForExactTokens(
514         uint amountOut,
515         address[] calldata path,
516         address to,
517         uint deadline
518     ) external payable returns (uint[] memory amounts);
519 
520     function quote(
521         uint amountA,
522         uint reserveA,
523         uint reserveB
524     ) external pure returns (uint amountB);
525 
526     function getAmountOut(
527         uint amountIn,
528         uint reserveIn,
529         uint reserveOut
530     ) external pure returns (uint amountOut);
531 
532     function getAmountIn(
533         uint amountOut,
534         uint reserveIn,
535         uint reserveOut
536     ) external pure returns (uint amountIn);
537 
538     function getAmountsOut(
539         uint amountIn,
540         address[] calldata path
541     ) external view returns (uint[] memory amounts);
542 
543     function getAmountsIn(
544         uint amountOut,
545         address[] calldata path
546     ) external view returns (uint[] memory amounts);
547 }
548 
549 // pragma solidity >=0.6.2;
550 
551 interface IUniswapV2Router02 is IUniswapV2Router01 {
552     function removeLiquidityETHSupportingFeeOnTransferTokens(
553         address token,
554         uint liquidity,
555         uint amountTokenMin,
556         uint amountETHMin,
557         address to,
558         uint deadline
559     ) external returns (uint amountETH);
560 
561     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
562         address token,
563         uint liquidity,
564         uint amountTokenMin,
565         uint amountETHMin,
566         address to,
567         uint deadline,
568         bool approveMax,
569         uint8 v,
570         bytes32 r,
571         bytes32 s
572     ) external returns (uint amountETH);
573 
574     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
575         uint amountIn,
576         uint amountOutMin,
577         address[] calldata path,
578         address to,
579         uint deadline
580     ) external;
581 
582     function swapExactETHForTokensSupportingFeeOnTransferTokens(
583         uint amountOutMin,
584         address[] calldata path,
585         address to,
586         uint deadline
587     ) external payable;
588 
589     function swapExactTokensForETHSupportingFeeOnTransferTokens(
590         uint amountIn,
591         uint amountOutMin,
592         address[] calldata path,
593         address to,
594         uint deadline
595     ) external;
596 }
597 
598 contract WagieBot is Context, IERC20, Ownable {
599     using SafeMath for uint256;
600     using Address for address;
601 
602     address payable public developmentAddress =
603         payable(0xfEe18884A9ABd2CdDc4fe80310C306836B66C37F); // Development Address
604     address public immutable deadAddress =
605         0x000000000000000000000000000000000000dEaD;
606     mapping(address => uint256) private _rOwned;
607     mapping(address => uint256) private _tOwned;
608     mapping(address => mapping(address => uint256)) private _allowances;
609     mapping(address => bool) private _isSniper;
610     address[] private _confirmedSnipers;
611 
612     mapping(address => bool) private _isExcludedFromFee;
613     mapping(address => bool) private _isExcluded;
614     address[] private _excluded;
615 
616     uint256 public constant MAX = ~uint256(0);
617     uint256 private _tTotal = 10_000_000 * 10 ** 9;
618     uint256 private _rTotal = (MAX - (MAX % _tTotal));
619     uint256 private _tFeeTotal;
620 
621     string private _name = "WagieBot";
622     string private _symbol = "WagieBot";
623     uint8 private _decimals = 9;
624     uint256 public maxWallet = 200_000 * 10 ** 9;
625     uint256 public _taxFee;
626     uint256 private _previousTaxFee = _taxFee;
627 
628     uint256 public _liquidityFee;
629     uint256 private _previousLiquidityFee = _liquidityFee;
630 
631     uint256 public _developmentFee;
632     uint256 private _previousDevelopmentFee = _developmentFee;
633 
634     uint256 private _feeRate = 2;
635     uint256 launchTime;
636 
637     IUniswapV2Router02 public uniswapV2Router;
638     address public uniswapV2Pair;
639 
640     bool inSwapAndLiquify;
641 
642     bool tradingOpen = false;
643 
644     event SwapETHForTokens(uint256 amountIn, address[] path);
645 
646     event SwapTokensForETH(uint256 amountIn, address[] path);
647 
648     modifier lockTheSwap() {
649         inSwapAndLiquify = true;
650         _;
651         inSwapAndLiquify = false;
652     }
653 
654     constructor() {
655         _rOwned[_msgSender()] = _rTotal;
656         emit Transfer(address(0), _msgSender(), _tTotal);
657     }
658 
659     function initContract() external onlyOwner {
660         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
661             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
662         );
663         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
664             .createPair(address(this), _uniswapV2Router.WETH());
665 
666         uniswapV2Router = _uniswapV2Router;
667 
668         _isExcludedFromFee[owner()] = true;
669         _isExcludedFromFee[address(this)] = true;
670 
671         developmentAddress = payable(
672             0xfEe18884A9ABd2CdDc4fe80310C306836B66C37F
673         );
674     }
675 
676     function openTrading() external onlyOwner {
677         _liquidityFee = 0;
678         _taxFee = 0;
679         _developmentFee = 4;
680         tradingOpen = true;
681         launchTime = block.timestamp;
682     }
683 
684     function name() public view returns (string memory) {
685         return _name;
686     }
687 
688     function symbol() public view returns (string memory) {
689         return _symbol;
690     }
691 
692     function decimals() public view returns (uint8) {
693         return _decimals;
694     }
695 
696     function totalSupply() public view override returns (uint256) {
697         return _tTotal;
698     }
699 
700     function balanceOf(address account) public view override returns (uint256) {
701         if (_isExcluded[account]) return _tOwned[account];
702         return tokenFromReflection(_rOwned[account]);
703     }
704 
705     function transfer(
706         address recipient,
707         uint256 amount
708     ) public override returns (bool) {
709         _transfer(_msgSender(), recipient, amount);
710         return true;
711     }
712 
713     function allowance(
714         address owner,
715         address spender
716     ) public view override returns (uint256) {
717         return _allowances[owner][spender];
718     }
719 
720     function approve(
721         address spender,
722         uint256 amount
723     ) public override returns (bool) {
724         _approve(_msgSender(), spender, amount);
725         return true;
726     }
727 
728     function transferFrom(
729         address sender,
730         address recipient,
731         uint256 amount
732     ) public override returns (bool) {
733         _transfer(sender, recipient, amount);
734         _approve(
735             sender,
736             _msgSender(),
737             _allowances[sender][_msgSender()].sub(
738                 amount,
739                 "ERC20: transfer amount exceeds allowance"
740             )
741         );
742         return true;
743     }
744 
745     function increaseAllowance(
746         address spender,
747         uint256 addedValue
748     ) public virtual returns (bool) {
749         _approve(
750             _msgSender(),
751             spender,
752             _allowances[_msgSender()][spender].add(addedValue)
753         );
754         return true;
755     }
756 
757     function decreaseAllowance(
758         address spender,
759         uint256 subtractedValue
760     ) public virtual returns (bool) {
761         _approve(
762             _msgSender(),
763             spender,
764             _allowances[_msgSender()][spender].sub(
765                 subtractedValue,
766                 "ERC20: decreased allowance below zero"
767             )
768         );
769         return true;
770     }
771 
772     function isExcludedFromReward(address account) public view returns (bool) {
773         return _isExcluded[account];
774     }
775 
776     function totalFees() public view returns (uint256) {
777         return _tFeeTotal;
778     }
779 
780     function deliver(uint256 tAmount) public {
781         address sender = _msgSender();
782         require(
783             !_isExcluded[sender],
784             "Excluded addresses cannot call this function"
785         );
786         (uint256 rAmount, , , , , , ) = _getValues(tAmount);
787         _rOwned[sender] = _rOwned[sender].sub(rAmount);
788         _rTotal = _rTotal.sub(rAmount);
789         _tFeeTotal = _tFeeTotal.add(tAmount);
790     }
791 
792     function reflectionFromToken(
793         uint256 tAmount,
794         bool deductTransferFee
795     ) public view returns (uint256) {
796         require(tAmount <= _tTotal, "Amount must be less than supply");
797         if (!deductTransferFee) {
798             (uint256 rAmount, , , , , , ) = _getValues(tAmount);
799             return rAmount;
800         } else {
801             (, uint256 rTransferAmount, , , , , ) = _getValues(tAmount);
802             return rTransferAmount;
803         }
804     }
805 
806     function tokenFromReflection(
807         uint256 rAmount
808     ) public view returns (uint256) {
809         require(
810             rAmount <= _rTotal,
811             "Amount must be less than total reflections"
812         );
813         uint256 currentRate = _getRate();
814         return rAmount.div(currentRate);
815     }
816 
817     function excludeFromReward(address account) public onlyOwner {
818         require(!_isExcluded[account], "Account is already excluded");
819         if (_rOwned[account] > 0) {
820             _tOwned[account] = tokenFromReflection(_rOwned[account]);
821         }
822         _isExcluded[account] = true;
823         _excluded.push(account);
824     }
825 
826     function includeInReward(address account) external onlyOwner {
827         require(_isExcluded[account], "Account is already excluded");
828         for (uint256 i = 0; i < _excluded.length; i++) {
829             if (_excluded[i] == account) {
830                 _excluded[i] = _excluded[_excluded.length - 1];
831                 _tOwned[account] = 0;
832                 _isExcluded[account] = false;
833                 _excluded.pop();
834                 break;
835             }
836         }
837     }
838 
839     function _approve(address owner, address spender, uint256 amount) private {
840         require(owner != address(0), "ERC20: approve from the zero address");
841         require(spender != address(0), "ERC20: approve to the zero address");
842 
843         _allowances[owner][spender] = amount;
844         emit Approval(owner, spender, amount);
845     }
846 
847     function _transfer(address from, address to, uint256 amount) private {
848         require(from != address(0), "ERC20: transfer from the zero address");
849         require(to != address(0), "ERC20: transfer to the zero address");
850         require(amount > 0, "Transfer amount must be greater than zero");
851         require(!_isSniper[to], "You have no power here!");
852         require(!_isSniper[msg.sender], "You have no power here!");
853 
854         // buy
855         if (
856             from == uniswapV2Pair &&
857             to != address(uniswapV2Router) &&
858             !_isExcludedFromFee[to]
859         ) {
860             require(tradingOpen, "Trading not yet enabled.");
861 
862             //antibot
863             if (block.timestamp == launchTime) {
864                 _isSniper[to] = true;
865                 _confirmedSnipers.push(to);
866             }
867         }
868 
869         uint256 contractTokenBalance = balanceOf(address(this));
870 
871         //sell
872 
873         if (!inSwapAndLiquify && tradingOpen && to == uniswapV2Pair) {
874             if (contractTokenBalance > 0) {
875                 if (
876                     contractTokenBalance >
877                     balanceOf(uniswapV2Pair).mul(_feeRate).div(100)
878                 ) {
879                     contractTokenBalance = balanceOf(uniswapV2Pair)
880                         .mul(_feeRate)
881                         .div(100);
882                 }
883                 swapTokens(contractTokenBalance);
884             }
885         }
886 
887         bool takeFee = false;
888 
889         //take fee only on swaps
890         if (
891             (from == uniswapV2Pair || to == uniswapV2Pair) &&
892             !(_isExcludedFromFee[from] || _isExcludedFromFee[to])
893         ) {
894             takeFee = true;
895         }
896 
897         _tokenTransfer(from, to, amount, takeFee);
898     }
899 
900     function swapTokens(uint256 contractTokenBalance) private lockTheSwap {
901         swapTokensForEth(contractTokenBalance);
902 
903         //Send to Development address
904         uint256 contractETHBalance = address(this).balance;
905         if (contractETHBalance > 0) {
906             sendETHToFee(address(this).balance);
907         }
908     }
909 
910     function sendETHToFee(uint256 amount) private {
911         developmentAddress.transfer(amount);
912     }
913 
914     function swapTokensForEth(uint256 tokenAmount) private {
915         // generate the uniswap pair path of token -> weth
916         address[] memory path = new address[](2);
917         path[0] = address(this);
918         path[1] = uniswapV2Router.WETH();
919 
920         _approve(address(this), address(uniswapV2Router), tokenAmount);
921 
922         // make the swap
923         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
924             tokenAmount,
925             0, // accept any amount of ETH
926             path,
927             address(this), // The contract
928             block.timestamp
929         );
930 
931         emit SwapTokensForETH(tokenAmount, path);
932     }
933 
934     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
935         // approve token transfer to cover all possible scenarios
936         _approve(address(this), address(uniswapV2Router), tokenAmount);
937 
938         // add the liquidity
939         uniswapV2Router.addLiquidityETH{value: ethAmount}(
940             address(this),
941             tokenAmount,
942             0, // slippage is unavoidable
943             0, // slippage is unavoidable
944             owner(),
945             block.timestamp
946         );
947     }
948 
949     function _tokenTransfer(
950         address sender,
951         address recipient,
952         uint256 amount,
953         bool takeFee
954     ) private {
955         if (!takeFee) removeAllFee();
956 
957         if (_isExcluded[sender] && !_isExcluded[recipient]) {
958             _transferFromExcluded(sender, recipient, amount);
959         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
960             _transferToExcluded(sender, recipient, amount);
961         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
962             _transferBothExcluded(sender, recipient, amount);
963         } else {
964             _transferStandard(sender, recipient, amount);
965         }
966 
967         if (!takeFee) restoreAllFee();
968     }
969 
970     function _transferStandard(
971         address sender,
972         address recipient,
973         uint256 tAmount
974     ) private {
975         (
976             uint256 rAmount,
977             uint256 rTransferAmount,
978             uint256 rFee,
979             uint256 tTransferAmount,
980             uint256 tFee,
981             uint256 tLiquidity,
982             uint256 tDevelopment
983         ) = _getValues(tAmount);
984 
985         uint256 currBalance = balanceOf(recipient);
986 
987         uint256 newBalance = currBalance.add(tTransferAmount);
988 
989         if (newBalance > maxWallet && recipient != address(uniswapV2Pair)) {
990             revert("Transfer amount exceeds the Max Wallet amount.");
991         }
992 
993         _rOwned[sender] = _rOwned[sender].sub(rAmount);
994         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
995         _takeLiquidity(tLiquidity);
996         _reflectFee(rFee, tFee);
997         _takeDevelopment(sender, tDevelopment);
998         emit Transfer(sender, recipient, tTransferAmount);
999     }
1000 
1001     function _transferToExcluded(
1002         address sender,
1003         address recipient,
1004         uint256 tAmount
1005     ) private {
1006         (
1007             uint256 rAmount,
1008             uint256 rTransferAmount,
1009             uint256 rFee,
1010             uint256 tTransferAmount,
1011             uint256 tFee,
1012             uint256 tLiquidity,
1013             uint256 tDevelopment
1014         ) = _getValues(tAmount);
1015 
1016         uint256 currBalance = balanceOf(recipient);
1017 
1018         uint256 newBalance = currBalance.add(tTransferAmount);
1019 
1020         if (newBalance > maxWallet && recipient != address(uniswapV2Pair)) {
1021             revert("Transfer amount exceeds the Max Wallet amount.");
1022         }
1023 
1024         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1025         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1026         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1027         _takeLiquidity(tLiquidity);
1028         _reflectFee(rFee, tFee);
1029         _takeDevelopment(sender, tDevelopment);
1030         emit Transfer(sender, recipient, tTransferAmount);
1031     }
1032 
1033     function _transferFromExcluded(
1034         address sender,
1035         address recipient,
1036         uint256 tAmount
1037     ) private {
1038         (
1039             uint256 rAmount,
1040             uint256 rTransferAmount,
1041             uint256 rFee,
1042             uint256 tTransferAmount,
1043             uint256 tFee,
1044             uint256 tLiquidity,
1045             uint256 tDevelopment
1046         ) = _getValues(tAmount);
1047 
1048         uint256 currBalance = balanceOf(recipient);
1049 
1050         uint256 newBalance = currBalance.add(tTransferAmount);
1051 
1052         if (newBalance > maxWallet && recipient != address(uniswapV2Pair)) {
1053             revert("Transfer amount exceeds the Max Wallet amount.");
1054         }
1055 
1056         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1057         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1058         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1059         _takeLiquidity(tLiquidity);
1060         _reflectFee(rFee, tFee);
1061         _takeDevelopment(sender, tDevelopment);
1062         emit Transfer(sender, recipient, tTransferAmount);
1063     }
1064 
1065     function _transferBothExcluded(
1066         address sender,
1067         address recipient,
1068         uint256 tAmount
1069     ) private {
1070         (
1071             uint256 rAmount,
1072             uint256 rTransferAmount,
1073             uint256 rFee,
1074             uint256 tTransferAmount,
1075             uint256 tFee,
1076             uint256 tLiquidity,
1077             uint256 tDevelopment
1078         ) = _getValues(tAmount);
1079 
1080         uint256 currBalance = balanceOf(recipient);
1081 
1082         uint256 newBalance = currBalance.add(tTransferAmount);
1083 
1084         if (newBalance > maxWallet && recipient != address(uniswapV2Pair)) {
1085             revert("Transfer amount exceeds the Max Wallet amount.");
1086         }
1087 
1088         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1089         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1090         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1091         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1092         _takeLiquidity(tLiquidity);
1093         _reflectFee(rFee, tFee);
1094         _takeDevelopment(sender, tDevelopment);
1095         emit Transfer(sender, recipient, tTransferAmount);
1096     }
1097 
1098     function _reflectFee(uint256 rFee, uint256 tFee) private {
1099         _rTotal = _rTotal.sub(rFee);
1100         _tFeeTotal = _tFeeTotal.add(tFee);
1101     }
1102 
1103     function _getValues(
1104         uint256 tAmount
1105     )
1106         private
1107         view
1108         returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256)
1109     {
1110         (
1111             uint256 tTransferAmount,
1112             uint256 tFee,
1113             uint256 tLiquidity,
1114             uint256 tDevelopment
1115         ) = _getTValues(tAmount);
1116         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(
1117             tAmount,
1118             tFee,
1119             tLiquidity,
1120             tDevelopment,
1121             _getRate()
1122         );
1123         return (
1124             rAmount,
1125             rTransferAmount,
1126             rFee,
1127             tTransferAmount,
1128             tFee,
1129             tLiquidity,
1130             tDevelopment
1131         );
1132     }
1133 
1134     function _getTValues(
1135         uint256 tAmount
1136     ) private view returns (uint256, uint256, uint256, uint256) {
1137         uint256 tFee = calculateTaxFee(tAmount);
1138         uint256 tLiquidity = calculateLiquidityFee(tAmount);
1139         uint256 tDevelopment = calculateDevelopmentFee(tAmount);
1140         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
1141         return (tTransferAmount, tFee, tLiquidity, tDevelopment);
1142     }
1143 
1144     function _getRValues(
1145         uint256 tAmount,
1146         uint256 tFee,
1147         uint256 tLiquidity,
1148         uint256 tDevelopment,
1149         uint256 currentRate
1150     ) private pure returns (uint256, uint256, uint256) {
1151         uint256 rAmount = tAmount.mul(currentRate);
1152         uint256 rFee = tFee.mul(currentRate);
1153         uint256 rLiquidity = tLiquidity.mul(currentRate);
1154         uint256 rDevelopment = tDevelopment.mul(currentRate);
1155         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity).sub(
1156             rDevelopment
1157         );
1158         return (rAmount, rTransferAmount, rFee);
1159     }
1160 
1161     function _getRate() private view returns (uint256) {
1162         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1163         return rSupply.div(tSupply);
1164     }
1165 
1166     function _getCurrentSupply() private view returns (uint256, uint256) {
1167         uint256 rSupply = _rTotal;
1168         uint256 tSupply = _tTotal;
1169         for (uint256 i = 0; i < _excluded.length; i++) {
1170             if (
1171                 _rOwned[_excluded[i]] > rSupply ||
1172                 _tOwned[_excluded[i]] > tSupply
1173             ) return (_rTotal, _tTotal);
1174             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1175             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1176         }
1177         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1178         return (rSupply, tSupply);
1179     }
1180 
1181     function _takeLiquidity(uint256 tLiquidity) private {
1182         uint256 currentRate = _getRate();
1183         uint256 rLiquidity = tLiquidity.mul(currentRate);
1184         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1185         if (_isExcluded[address(this)])
1186             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1187     }
1188 
1189     function _takeDevelopment(address sender, uint256 tDevelopment) internal {
1190         uint256 currentRate = _getRate();
1191         uint256 rLiquidity = tDevelopment * currentRate;
1192         _rOwned[address(this)] = _rOwned[address(this)] + rLiquidity;
1193         if (_isExcluded[address(this)])
1194             _tOwned[address(this)] = _tOwned[address(this)] + tDevelopment;
1195         emit Transfer(sender, address(this), tDevelopment); // Transparency is the key to success.
1196     }
1197 
1198     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1199         return _amount.mul(_taxFee).div(10 ** 2);
1200     }
1201 
1202     function calculateLiquidityFee(
1203         uint256 _amount
1204     ) private view returns (uint256) {
1205         return _amount.mul(_liquidityFee).div(10 ** 2);
1206     }
1207 
1208     function calculateDevelopmentFee(
1209         uint256 _amount
1210     ) private view returns (uint256) {
1211         return _amount.mul(_developmentFee).div(10 ** 2);
1212     }
1213 
1214     function removeAllFee() private {
1215         if (_taxFee == 0 && _liquidityFee == 0 && _developmentFee == 0) return;
1216 
1217         _previousTaxFee = _taxFee;
1218         _previousLiquidityFee = _liquidityFee;
1219         _previousDevelopmentFee = _developmentFee;
1220         _taxFee = 0;
1221         _liquidityFee = 0;
1222         _developmentFee = 0;
1223     }
1224 
1225     function restoreAllFee() private {
1226         _taxFee = _previousTaxFee;
1227         _liquidityFee = _previousLiquidityFee;
1228         _developmentFee = _previousDevelopmentFee;
1229     }
1230 
1231     function isExcludedFromFee(address account) public view returns (bool) {
1232         return _isExcludedFromFee[account];
1233     }
1234 
1235     function excludeFromFee(address account) public onlyOwner {
1236         _isExcludedFromFee[account] = true;
1237     }
1238 
1239     function includeInFee(address account) public onlyOwner {
1240         _isExcludedFromFee[account] = false;
1241     }
1242 
1243     function setTaxFeePercent(uint256 taxFee) external onlyOwner {
1244         _taxFee = taxFee;
1245     }
1246 
1247     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner {
1248         _liquidityFee = liquidityFee;
1249     }
1250 
1251     function setDevelopmentFeePercent(
1252         uint256 developmentFee
1253     ) external onlyOwner {
1254         _developmentFee = developmentFee;
1255     }
1256 
1257     function setDevelopmentAddress(
1258         address _developmentAddress
1259     ) external onlyOwner {
1260         developmentAddress = payable(_developmentAddress);
1261     }
1262 
1263     function transferToAddressETH(
1264         address payable recipient,
1265         uint256 amount
1266     ) private {
1267         recipient.transfer(amount);
1268     }
1269 
1270     function isRemovedSniper(address account) public view returns (bool) {
1271         return _isSniper[account];
1272     }
1273 
1274     function _removeSniper(address account) external onlyOwner {
1275         require(
1276             account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D,
1277             "We cannot blacklist Uniswap"
1278         );
1279         require(!_isSniper[account], "Account is already blacklisted");
1280         _isSniper[account] = true;
1281         _confirmedSnipers.push(account);
1282     }
1283 
1284     function _amnestySniper(address account) external onlyOwner {
1285         require(_isSniper[account], "Account is not blacklisted");
1286         for (uint256 i = 0; i < _confirmedSnipers.length; i++) {
1287             if (_confirmedSnipers[i] == account) {
1288                 _confirmedSnipers[i] = _confirmedSnipers[
1289                     _confirmedSnipers.length - 1
1290                 ];
1291                 _isSniper[account] = false;
1292                 _confirmedSnipers.pop();
1293                 break;
1294             }
1295         }
1296     }
1297 
1298     function setFeeRate(uint256 rate) external onlyOwner {
1299         _feeRate = rate;
1300     }
1301 
1302     //to recieve ETH from uniswapV2Router when swaping
1303     receive() external payable {}
1304 }