1 /**
2 NecroDao SmartContract 
3 necrodao.com
4 */
5 
6 // SPDX-License-Identifier: MIT
7 pragma solidity ^0.8.15;
8 
9 abstract contract Context {
10     function _msgSender() internal view virtual returns (address) {
11         return msg.sender;
12     }
13 
14     function _msgData() internal view virtual returns (bytes memory) {
15         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
16         return msg.data;
17     }
18 }
19 
20 interface IUniswapV2Pair {
21     event Approval(
22         address indexed owner,
23         address indexed spender,
24         uint256 value
25     );
26     event Transfer(address indexed from, address indexed to, uint256 value);
27 
28     function name() external pure returns (string memory);
29 
30     function symbol() external pure returns (string memory);
31 
32     function decimals() external pure returns (uint8);
33 
34     function totalSupply() external view returns (uint256);
35 
36     function balanceOf(address owner) external view returns (uint256);
37 
38     function allowance(address owner, address spender)
39         external
40         view
41         returns (uint256);
42 
43     function approve(address spender, uint256 value) external returns (bool);
44 
45     function transfer(address to, uint256 value) external returns (bool);
46 
47     function transferFrom(
48         address from,
49         address to,
50         uint256 value
51     ) external returns (bool);
52 
53     function DOMAIN_SEPARATOR() external view returns (bytes32);
54 
55     function PERMIT_TYPEHASH() external pure returns (bytes32);
56 
57     function nonces(address owner) external view returns (uint256);
58 
59     function permit(
60         address owner,
61         address spender,
62         uint256 value,
63         uint256 deadline,
64         uint8 v,
65         bytes32 r,
66         bytes32 s
67     ) external;
68 
69     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
70     event Burn(
71         address indexed sender,
72         uint256 amount0,
73         uint256 amount1,
74         address indexed to
75     );
76     event Swap(
77         address indexed sender,
78         uint256 amount0In,
79         uint256 amount1In,
80         uint256 amount0Out,
81         uint256 amount1Out,
82         address indexed to
83     );
84     event Sync(uint112 reserve0, uint112 reserve1);
85 
86     function MINIMUM_LIQUIDITY() external pure returns (uint256);
87 
88     function factory() external view returns (address);
89 
90     function token0() external view returns (address);
91 
92     function token1() external view returns (address);
93 
94     function getReserves()
95         external
96         view
97         returns (
98             uint112 reserve0,
99             uint112 reserve1,
100             uint32 blockTimestampLast
101         );
102 
103     function price0CumulativeLast() external view returns (uint256);
104 
105     function price1CumulativeLast() external view returns (uint256);
106 
107     function kLast() external view returns (uint256);
108 
109     function mint(address to) external returns (uint256 liquidity);
110 
111     function burn(address to)
112         external
113         returns (uint256 amount0, uint256 amount1);
114 
115     function swap(
116         uint256 amount0Out,
117         uint256 amount1Out,
118         address to,
119         bytes calldata data
120     ) external;
121 
122     function skim(address to) external;
123 
124     function sync() external;
125 
126     function initialize(address, address) external;
127 }
128 
129 interface IUniswapV2Factory {
130     event PairCreated(
131         address indexed token0,
132         address indexed token1,
133         address pair,
134         uint256
135     );
136 
137     function feeTo() external view returns (address);
138 
139     function feeToSetter() external view returns (address);
140 
141     function getPair(address tokenA, address tokenB)
142         external
143         view
144         returns (address pair);
145 
146     function allPairs(uint256) external view returns (address pair);
147 
148     function allPairsLength() external view returns (uint256);
149 
150     function createPair(address tokenA, address tokenB)
151         external
152         returns (address pair);
153 
154     function setFeeTo(address) external;
155 
156     function setFeeToSetter(address) external;
157 }
158 
159 interface IERC20 {
160     function totalSupply() external view returns (uint256);
161 
162     function balanceOf(address account) external view returns (uint256);
163 
164     function transfer(address recipient, uint256 amount)
165         external
166         returns (bool);
167 
168     function allowance(address owner, address spender)
169         external
170         view
171         returns (uint256);
172 
173     function approve(address spender, uint256 amount) external returns (bool);
174 
175     function transferFrom(
176         address sender,
177         address recipient,
178         uint256 amount
179     ) external returns (bool);
180 
181     event Transfer(address indexed from, address indexed to, uint256 value);
182 
183     event Approval(
184         address indexed owner,
185         address indexed spender,
186         uint256 value
187     );
188 }
189 
190 interface IERC20Metadata is IERC20 {
191     function name() external view returns (string memory);
192 
193     function symbol() external view returns (string memory);
194 
195     function decimals() external view returns (uint8);
196 }
197 
198 contract ERC20 is Context, IERC20, IERC20Metadata {
199     using SafeMath for uint256;
200 
201     mapping(address => uint256) private _balances;
202 
203     mapping(address => mapping(address => uint256)) private _allowances;
204 
205     uint256 internal _totalSupply;
206 
207     string private _name;
208     string private _symbol;
209 
210     constructor(string memory name_, string memory symbol_) {
211         _name = name_;
212         _symbol = symbol_;
213     }
214 
215     function name() public view virtual override returns (string memory) {
216         return _name;
217     }
218 
219     function symbol() public view virtual override returns (string memory) {
220         return _symbol;
221     }
222 
223     function decimals() public view virtual override returns (uint8) {
224         return 18;
225     }
226 
227     function totalSupply() public view virtual override returns (uint256) {
228         return _totalSupply;
229     }
230 
231     function balanceOf(address account)
232         public
233         view
234         virtual
235         override
236         returns (uint256)
237     {
238         return _balances[account];
239     }
240 
241     function transfer(address recipient, uint256 amount)
242         public
243         virtual
244         override
245         returns (bool)
246     {
247         _transfer(_msgSender(), recipient, amount);
248         return true;
249     }
250 
251     function allowance(address owner, address spender)
252         public
253         view
254         virtual
255         override
256         returns (uint256)
257     {
258         return _allowances[owner][spender];
259     }
260 
261     function approve(address spender, uint256 amount)
262         public
263         virtual
264         override
265         returns (bool)
266     {
267         _approve(_msgSender(), spender, amount);
268         return true;
269     }
270 
271     function transferFrom(
272         address sender,
273         address recipient,
274         uint256 amount
275     ) public virtual override returns (bool) {
276         _transfer(sender, recipient, amount);
277         _approve(
278             sender,
279             _msgSender(),
280             _allowances[sender][_msgSender()].sub(
281                 amount,
282                 "ERC20: transfer amount exceeds allowance"
283             )
284         );
285         return true;
286     }
287 
288     function increaseAllowance(address spender, uint256 addedValue)
289         public
290         virtual
291         returns (bool)
292     {
293         _approve(
294             _msgSender(),
295             spender,
296             _allowances[_msgSender()][spender].add(addedValue)
297         );
298         return true;
299     }
300 
301     function decreaseAllowance(address spender, uint256 subtractedValue)
302         public
303         virtual
304         returns (bool)
305     {
306         _approve(
307             _msgSender(),
308             spender,
309             _allowances[_msgSender()][spender].sub(
310                 subtractedValue,
311                 "ERC20: decreased allowance below zero"
312             )
313         );
314         return true;
315     }
316 
317     function _transfer(
318         address sender,
319         address recipient,
320         uint256 amount
321     ) internal virtual {
322         require(sender != address(0), "ERC20: transfer from the zero address");
323         require(recipient != address(0), "ERC20: transfer to the zero address");
324 
325         _beforeTokenTransfer(sender, recipient, amount);
326 
327         _balances[sender] = _balances[sender].sub(
328             amount,
329             "ERC20: transfer amount exceeds balance"
330         );
331         _balances[recipient] = _balances[recipient].add(amount);
332         emit Transfer(sender, recipient, amount);
333     }
334 
335     function _mint(address account, uint256 amount) internal virtual {
336         require(account != address(0), "ERC20: mint to the zero address");
337 
338         _beforeTokenTransfer(address(0), account, amount);
339 
340         _totalSupply = _totalSupply.add(amount);
341         _balances[account] = _balances[account].add(amount);
342         emit Transfer(address(0), account, amount);
343     }
344 
345     function _burn(address account, uint256 amount) internal virtual {
346         require(account != address(0), "ERC20: burn from the zero address");
347 
348         _beforeTokenTransfer(account, address(0), amount);
349 
350         _balances[account] = _balances[account].sub(
351             amount,
352             "ERC20: burn amount exceeds balance"
353         );
354         _totalSupply = _totalSupply.sub(amount);
355         emit Transfer(account, address(0), amount);
356     }
357 
358     function _approve(
359         address owner,
360         address spender,
361         uint256 amount
362     ) internal virtual {
363         require(owner != address(0), "ERC20: approve from the zero address");
364         require(spender != address(0), "ERC20: approve to the zero address");
365 
366         _allowances[owner][spender] = amount;
367         emit Approval(owner, spender, amount);
368     }
369 
370     function _beforeTokenTransfer(
371         address from,
372         address to,
373         uint256 amount
374     ) internal virtual {}
375 }
376 
377 interface DividendPayingTokenOptionalInterface {
378     function withdrawableDividendOf(address _owner)
379         external
380         view
381         returns (uint256);
382 
383     function withdrawnDividendOf(address _owner)
384         external
385         view
386         returns (uint256);
387 
388     function accumulativeDividendOf(address _owner)
389         external
390         view
391         returns (uint256);
392 }
393 
394 interface DividendPayingTokenInterface {
395     function dividendOf(address _owner) external view returns (uint256);
396 
397     function distributeDividends() external payable;
398 
399     function withdrawDividend() external;
400 
401     event DividendsDistributed(address indexed from, uint256 weiAmount);
402 
403     event DividendWithdrawn(address indexed to, uint256 weiAmount);
404 }
405 
406 library SafeMath {
407     function add(uint256 a, uint256 b) internal pure returns (uint256) {
408         uint256 c = a + b;
409         require(c >= a, "SafeMath: addition overflow");
410 
411         return c;
412     }
413 
414     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
415         return sub(a, b, "SafeMath: subtraction overflow");
416     }
417 
418     function sub(
419         uint256 a,
420         uint256 b,
421         string memory errorMessage
422     ) internal pure returns (uint256) {
423         require(b <= a, errorMessage);
424         uint256 c = a - b;
425 
426         return c;
427     }
428 
429     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
430         if (a == 0) {
431             return 0;
432         }
433 
434         uint256 c = a * b;
435         require(c / a == b, "SafeMath: multiplication overflow");
436 
437         return c;
438     }
439 
440     function div(uint256 a, uint256 b) internal pure returns (uint256) {
441         return div(a, b, "SafeMath: division by zero");
442     }
443 
444     function div(
445         uint256 a,
446         uint256 b,
447         string memory errorMessage
448     ) internal pure returns (uint256) {
449         require(b > 0, errorMessage);
450         uint256 c = a / b;
451         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
452 
453         return c;
454     }
455 
456     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
457         return mod(a, b, "SafeMath: modulo by zero");
458     }
459 
460     function mod(
461         uint256 a,
462         uint256 b,
463         string memory errorMessage
464     ) internal pure returns (uint256) {
465         require(b != 0, errorMessage);
466         return a % b;
467     }
468 }
469 
470 contract Ownable is Context {
471     address private _owner;
472 
473     event OwnershipTransferred(
474         address indexed previousOwner,
475         address indexed newOwner
476     );
477 
478     constructor() {
479         address msgSender = _msgSender();
480         _owner = msgSender;
481         emit OwnershipTransferred(address(0), msgSender);
482     }
483 
484     function owner() public view returns (address) {
485         return _owner;
486     }
487 
488     modifier onlyOwner() {
489         require(_owner == _msgSender(), "Ownable: caller is not the owner");
490         _;
491     }
492 
493     function renounceOwnership() public virtual onlyOwner {
494         emit OwnershipTransferred(_owner, address(0));
495         _owner = address(0);
496     }
497 
498     function transferOwnership(address newOwner) public virtual onlyOwner {
499         require(
500             newOwner != address(0),
501             "Ownable: new owner is the zero address"
502         );
503         emit OwnershipTransferred(_owner, newOwner);
504         _owner = newOwner;
505     }
506 }
507 
508 library SafeMathInt {
509     int256 private constant MIN_INT256 = int256(1) << 255;
510     int256 private constant MAX_INT256 = ~(int256(1) << 255);
511 
512     function mul(int256 a, int256 b) internal pure returns (int256) {
513         int256 c = a * b;
514 
515         // Detect overflow when multiplying MIN_INT256 with -1
516         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
517         require((b == 0) || (c / b == a));
518         return c;
519     }
520 
521     function div(int256 a, int256 b) internal pure returns (int256) {
522         // Prevent overflow when dividing MIN_INT256 by -1
523         require(b != -1 || a != MIN_INT256);
524 
525         // Solidity already throws when dividing by 0.
526         return a / b;
527     }
528 
529     function sub(int256 a, int256 b) internal pure returns (int256) {
530         int256 c = a - b;
531         require((b >= 0 && c <= a) || (b < 0 && c > a));
532         return c;
533     }
534 
535     function add(int256 a, int256 b) internal pure returns (int256) {
536         int256 c = a + b;
537         require((b >= 0 && c >= a) || (b < 0 && c < a));
538         return c;
539     }
540 
541     function abs(int256 a) internal pure returns (int256) {
542         require(a != MIN_INT256);
543         return a < 0 ? -a : a;
544     }
545 
546     function toUint256Safe(int256 a) internal pure returns (uint256) {
547         require(a >= 0);
548         return uint256(a);
549     }
550 }
551 
552 library SafeMathUint {
553     function toInt256Safe(uint256 a) internal pure returns (int256) {
554         int256 b = int256(a);
555         require(b >= 0);
556         return b;
557     }
558 }
559 
560 interface IUniswapV2Router01 {
561     function factory() external pure returns (address);
562 
563     function WETH() external pure returns (address);
564 
565     function addLiquidity(
566         address tokenA,
567         address tokenB,
568         uint256 amountADesired,
569         uint256 amountBDesired,
570         uint256 amountAMin,
571         uint256 amountBMin,
572         address to,
573         uint256 deadline
574     )
575         external
576         returns (
577             uint256 amountA,
578             uint256 amountB,
579             uint256 liquidity
580         );
581 
582     function addLiquidityETH(
583         address token,
584         uint256 amountTokenDesired,
585         uint256 amountTokenMin,
586         uint256 amountETHMin,
587         address to,
588         uint256 deadline
589     )
590         external
591         payable
592         returns (
593             uint256 amountToken,
594             uint256 amountETH,
595             uint256 liquidity
596         );
597 
598     function removeLiquidity(
599         address tokenA,
600         address tokenB,
601         uint256 liquidity,
602         uint256 amountAMin,
603         uint256 amountBMin,
604         address to,
605         uint256 deadline
606     ) external returns (uint256 amountA, uint256 amountB);
607 
608     function removeLiquidityETH(
609         address token,
610         uint256 liquidity,
611         uint256 amountTokenMin,
612         uint256 amountETHMin,
613         address to,
614         uint256 deadline
615     ) external returns (uint256 amountToken, uint256 amountETH);
616 
617     function removeLiquidityWithPermit(
618         address tokenA,
619         address tokenB,
620         uint256 liquidity,
621         uint256 amountAMin,
622         uint256 amountBMin,
623         address to,
624         uint256 deadline,
625         bool approveMax,
626         uint8 v,
627         bytes32 r,
628         bytes32 s
629     ) external returns (uint256 amountA, uint256 amountB);
630 
631     function removeLiquidityETHWithPermit(
632         address token,
633         uint256 liquidity,
634         uint256 amountTokenMin,
635         uint256 amountETHMin,
636         address to,
637         uint256 deadline,
638         bool approveMax,
639         uint8 v,
640         bytes32 r,
641         bytes32 s
642     ) external returns (uint256 amountToken, uint256 amountETH);
643 
644     function swapExactTokensForTokens(
645         uint256 amountIn,
646         uint256 amountOutMin,
647         address[] calldata path,
648         address to,
649         uint256 deadline
650     ) external returns (uint256[] memory amounts);
651 
652     function swapTokensForExactTokens(
653         uint256 amountOut,
654         uint256 amountInMax,
655         address[] calldata path,
656         address to,
657         uint256 deadline
658     ) external returns (uint256[] memory amounts);
659 
660     function swapExactETHForTokens(
661         uint256 amountOutMin,
662         address[] calldata path,
663         address to,
664         uint256 deadline
665     ) external payable returns (uint256[] memory amounts);
666 
667     function swapTokensForExactETH(
668         uint256 amountOut,
669         uint256 amountInMax,
670         address[] calldata path,
671         address to,
672         uint256 deadline
673     ) external returns (uint256[] memory amounts);
674 
675     function swapExactTokensForETH(
676         uint256 amountIn,
677         uint256 amountOutMin,
678         address[] calldata path,
679         address to,
680         uint256 deadline
681     ) external returns (uint256[] memory amounts);
682 
683     function swapETHForExactTokens(
684         uint256 amountOut,
685         address[] calldata path,
686         address to,
687         uint256 deadline
688     ) external payable returns (uint256[] memory amounts);
689 
690     function quote(
691         uint256 amountA,
692         uint256 reserveA,
693         uint256 reserveB
694     ) external pure returns (uint256 amountB);
695 
696     function getAmountOut(
697         uint256 amountIn,
698         uint256 reserveIn,
699         uint256 reserveOut
700     ) external pure returns (uint256 amountOut);
701 
702     function getAmountIn(
703         uint256 amountOut,
704         uint256 reserveIn,
705         uint256 reserveOut
706     ) external pure returns (uint256 amountIn);
707 
708     function getAmountsOut(uint256 amountIn, address[] calldata path)
709         external
710         view
711         returns (uint256[] memory amounts);
712 
713     function getAmountsIn(uint256 amountOut, address[] calldata path)
714         external
715         view
716         returns (uint256[] memory amounts);
717 }
718 
719 interface IUniswapV2Router02 is IUniswapV2Router01 {
720     function removeLiquidityETHSupportingFeeOnTransferTokens(
721         address token,
722         uint256 liquidity,
723         uint256 amountTokenMin,
724         uint256 amountETHMin,
725         address to,
726         uint256 deadline
727     ) external returns (uint256 amountETH);
728 
729     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
730         address token,
731         uint256 liquidity,
732         uint256 amountTokenMin,
733         uint256 amountETHMin,
734         address to,
735         uint256 deadline,
736         bool approveMax,
737         uint8 v,
738         bytes32 r,
739         bytes32 s
740     ) external returns (uint256 amountETH);
741 
742     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
743         uint256 amountIn,
744         uint256 amountOutMin,
745         address[] calldata path,
746         address to,
747         uint256 deadline
748     ) external;
749 
750     function swapExactETHForTokensSupportingFeeOnTransferTokens(
751         uint256 amountOutMin,
752         address[] calldata path,
753         address to,
754         uint256 deadline
755     ) external payable;
756 
757     function swapExactTokensForETHSupportingFeeOnTransferTokens(
758         uint256 amountIn,
759         uint256 amountOutMin,
760         address[] calldata path,
761         address to,
762         uint256 deadline
763     ) external;
764 }
765 
766 contract DividendPayingToken is
767     ERC20,
768     DividendPayingTokenInterface,
769     DividendPayingTokenOptionalInterface
770 {
771     using SafeMath for uint256;
772     using SafeMathUint for uint256;
773     using SafeMathInt for int256;
774 
775     uint256 internal constant magnitude = 2**128;
776 
777     uint256 internal magnifiedDividendPerShare;
778 
779     mapping(address => int256) internal magnifiedDividendCorrections;
780     mapping(address => uint256) internal withdrawnDividends;
781 
782     uint256 public totalDividendsDistributed;
783 
784     constructor(string memory _name, string memory _symbol)
785         ERC20(_name, _symbol)
786     {}
787 
788     receive() external payable {
789         distributeDividends();
790     }
791 
792     function distributeDividends() public payable override {
793         require(totalSupply() > 0);
794 
795         if (msg.value > 0) {
796             magnifiedDividendPerShare = magnifiedDividendPerShare.add(
797                 (msg.value).mul(magnitude) / totalSupply()
798             );
799             emit DividendsDistributed(msg.sender, msg.value);
800 
801             totalDividendsDistributed = totalDividendsDistributed.add(
802                 msg.value
803             );
804         }
805     }
806 
807     function withdrawDividend() public virtual override {
808         _withdrawDividendOfUser(payable(msg.sender));
809     }
810 
811     function _withdrawDividendOfUser(address payable user)
812         internal
813         virtual
814         returns (uint256)
815     {
816         uint256 _withdrawableDividend = withdrawableDividendOf(user);
817         if (_withdrawableDividend > 0) {
818             withdrawnDividends[user] = withdrawnDividends[user].add(
819                 _withdrawableDividend
820             );
821             emit DividendWithdrawn(user, _withdrawableDividend);
822             (bool success, ) = user.call{
823                 value: _withdrawableDividend,
824                 gas: 3000
825             }("");
826 
827             if (!success) {
828                 withdrawnDividends[user] = withdrawnDividends[user].sub(
829                     _withdrawableDividend
830                 );
831                 return 0;
832             }
833 
834             return _withdrawableDividend;
835         }
836 
837         return 0;
838     }
839 
840     function dividendOf(address _owner) public view override returns (uint256) {
841         return withdrawableDividendOf(_owner);
842     }
843 
844     function withdrawableDividendOf(address _owner)
845         public
846         view
847         override
848         returns (uint256)
849     {
850         return accumulativeDividendOf(_owner).sub(withdrawnDividends[_owner]);
851     }
852 
853     function withdrawnDividendOf(address _owner)
854         public
855         view
856         override
857         returns (uint256)
858     {
859         return withdrawnDividends[_owner];
860     }
861 
862     function accumulativeDividendOf(address _owner)
863         public
864         view
865         override
866         returns (uint256)
867     {
868         return
869             magnifiedDividendPerShare
870                 .mul(balanceOf(_owner))
871                 .toInt256Safe()
872                 .add(magnifiedDividendCorrections[_owner])
873                 .toUint256Safe() / magnitude;
874     }
875 
876     function _transfer(
877         address from,
878         address to,
879         uint256 value
880     ) internal virtual override {
881         require(false);
882 
883         int256 _magCorrection = magnifiedDividendPerShare
884             .mul(value)
885             .toInt256Safe();
886         magnifiedDividendCorrections[from] = magnifiedDividendCorrections[from]
887             .add(_magCorrection);
888         magnifiedDividendCorrections[to] = magnifiedDividendCorrections[to].sub(
889             _magCorrection
890         );
891     }
892 
893     function _mint(address account, uint256 value) internal override {
894         super._mint(account, value);
895 
896         magnifiedDividendCorrections[account] = magnifiedDividendCorrections[
897             account
898         ].sub((magnifiedDividendPerShare.mul(value)).toInt256Safe());
899     }
900 
901     function _burn(address account, uint256 value) internal override {
902         super._burn(account, value);
903 
904         magnifiedDividendCorrections[account] = magnifiedDividendCorrections[
905             account
906         ].add((magnifiedDividendPerShare.mul(value)).toInt256Safe());
907     }
908 
909     function _setBalance(address account, uint256 newBalance) internal {
910         uint256 currentBalance = balanceOf(account);
911 
912         if (newBalance > currentBalance) {
913             uint256 mintAmount = newBalance.sub(currentBalance);
914             _mint(account, mintAmount);
915         } else if (newBalance < currentBalance) {
916             uint256 burnAmount = currentBalance.sub(newBalance);
917             _burn(account, burnAmount);
918         }
919     }
920 }
921 
922 contract NecroDao is ERC20, Ownable {
923     using SafeMath for uint256;
924 
925     IUniswapV2Router02 public uniswapV2Router;
926 
927     address public uniswapV2Pair;
928     address public DEAD = 0x000000000000000000000000000000000000dEaD;
929     bool private swapping;
930     bool private stakingEnabled = false;
931     bool public tradingEnabled = false;
932 
933     uint256 public sellAmount = 0;
934     uint256 public buyAmount = 0;
935 
936     uint256 private totalSellFees;
937     uint256 private totalBuyFees;
938 
939     NecroDaoDividendTracker public dividendTracker;
940 
941     address payable public marketingWallet;
942     address payable public devWallet;
943 
944     // Max tx, dividend threshold and tax variables
945     uint256 public maxWallet;
946     uint256 public swapTokensAtAmount;
947     uint256 public sellRewardsFee;
948     uint256 public sellDeadFees;
949     uint256 public sellMarketingFees;
950     uint256 public sellLiquidityFee;
951     uint256 public buyDeadFees;
952     uint256 public buyMarketingFees;
953     uint256 public buyLiquidityFee;
954     uint256 public buyRewardsFee;
955     uint256 public buyDevFee;
956     uint256 public sellDevFee;
957     uint256 public transferFee;
958 
959     bool public swapAndLiquifyEnabled = true;
960 
961     // gas for processing auto claim dividends 
962     uint256 public gasForProcessing = 300000;
963 
964     // exlcude from fees and max transaction amount
965     mapping(address => bool) private _isExcludedFromFees;
966 
967     mapping(address => bool) public automatedMarketMakerPairs;
968 
969     // staking variables
970     mapping(address => uint256) public stakingBonus;
971     mapping(address => uint256) public stakingUntilDate;
972     mapping(uint256 => uint256) public stakingAmounts;
973 
974     //for allowing specific address to trade while trading has not been enabled yet 
975     mapping(address => bool) private canTransferBeforeTradingIsEnabled;
976 
977     // Limit variables for bot protection
978     bool public limitsInEffect = true; //boolean used to turn limits on and off
979     uint256 private gasPriceLimit = 7 * 1 gwei; 
980     mapping(address => uint256) private _holderLastTransferBlock; // for 1 tx per block
981     mapping(address => uint256) private _holderLastTransferTimestamp; // for sell cooldown timer
982     uint256 public launchblock;
983     uint256 public cooldowntimer = 60; //default cooldown 60s
984 
985     event EnableAccountStaking(address indexed account, uint256 duration);
986     event UpdateStakingAmounts(uint256 duration, uint256 amount);
987 
988     event EnableSwapAndLiquify(bool enabled);
989     event EnableStaking(bool enabled);
990 
991     event SetPreSaleWallet(address wallet);
992 
993     event UpdateDividendTracker(
994         address indexed newAddress,
995         address indexed oldAddress
996     );
997 
998     event UpdateUniswapV2Router(
999         address indexed newAddress,
1000         address indexed oldAddress
1001     );
1002 
1003     event TradingEnabled();
1004 
1005     event UpdateFees(
1006         uint256 sellDeadFees,
1007         uint256 sellMarketingFees,
1008         uint256 sellLiquidityFee,
1009         uint256 sellRewardsFee,
1010         uint256 buyDeadFees,
1011         uint256 buyMarketingFees,
1012         uint256 buyLiquidityFee,
1013         uint256 buyRewardsFee,
1014         uint256 buyDevFee,
1015         uint256 sellDevFee
1016     );
1017 
1018     event UpdateTransferFee(uint256 transferFee);
1019 
1020     event Airdrop(address holder, uint256 amount);
1021 
1022     event ExcludeFromFees(address indexed account, bool isExcluded);
1023     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1024 
1025     event GasForProcessingUpdated(
1026         uint256 indexed newValue,
1027         uint256 indexed oldValue
1028     );
1029 
1030     event SwapAndLiquify(
1031         uint256 tokensSwapped,
1032         uint256 ethReceived,
1033         uint256 tokensIntoLiqudity
1034     );
1035 
1036     event SendDividends(uint256 amount, uint256 opAmount, bool success);
1037 
1038     event ProcessedDividendTracker(
1039         uint256 iterations,
1040         uint256 claims,
1041         uint256 lastProcessedIndex,
1042         bool indexed automatic,
1043         uint256 gas,
1044         address indexed processor
1045     );
1046 
1047     event UpdatePayoutToken(address token);
1048 
1049     constructor() ERC20("NecroDao", "NECRO") {
1050         marketingWallet = payable(0x79499DfB33e051f5eFF66C0D59E575BFb652CA22);
1051         devWallet = payable(0x79499DfB33e051f5eFF66C0D59E575BFb652CA22);
1052         address router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
1053 
1054         buyDeadFees = 1;
1055         sellDeadFees = 1;
1056         buyMarketingFees = 1;
1057         sellMarketingFees = 1;
1058         buyLiquidityFee = 2;
1059         sellLiquidityFee = 2;
1060         buyRewardsFee = 3;
1061         sellRewardsFee = 3;
1062         buyDevFee = 1;
1063         sellDevFee = 1;
1064         transferFee = 5;
1065 
1066         totalBuyFees = buyRewardsFee
1067             .add(buyLiquidityFee)
1068             .add(buyMarketingFees)
1069             .add(buyDevFee);
1070         totalSellFees = sellRewardsFee
1071             .add(sellLiquidityFee)
1072             .add(sellMarketingFees)
1073             .add(sellDevFee);
1074 
1075         dividendTracker = new NecroDaoDividendTracker(
1076             payable(this),
1077             router,
1078             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D,
1079             "NecroDaoTRACKER",
1080             "NECROTRACKER"
1081         );
1082 
1083         uniswapV2Router = IUniswapV2Router02(router);
1084         // Create a uniswap pair for this new token
1085         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(
1086                 address(this),
1087                 uniswapV2Router.WETH()
1088             );
1089 
1090         _setAutomatedMarketMakerPair(uniswapV2Pair, true);
1091 
1092         // exclude from receiving dividends
1093         dividendTracker.excludeFromDividends(address(dividendTracker));
1094         dividendTracker.excludeFromDividends(address(this));
1095         dividendTracker.excludeFromDividends(DEAD);
1096         dividendTracker.excludedFromDividends(address(0));
1097         dividendTracker.excludeFromDividends(router);
1098         dividendTracker.excludeFromDividends(marketingWallet);
1099         dividendTracker.excludeFromDividends(owner());
1100 
1101         // exclude from paying fees or having max transaction amount
1102         _isExcludedFromFees[address(this)] = true;
1103         _isExcludedFromFees[address(dividendTracker)] = true;
1104         _isExcludedFromFees[address(marketingWallet)] = true;
1105         _isExcludedFromFees[address(devWallet)] = true;
1106         _isExcludedFromFees[msg.sender] = true;
1107 
1108         uint256 totalTokenSupply = (100_000_000) * (10**18);
1109         _mint(owner(), totalTokenSupply); // only time internal mint function is ever called is to create supply
1110         maxWallet = totalTokenSupply / 200000; // 0.05%
1111         swapTokensAtAmount = totalTokenSupply / 200000; // 0.05%;
1112         canTransferBeforeTradingIsEnabled[owner()] = true;
1113         canTransferBeforeTradingIsEnabled[address(this)] = true;
1114     }
1115 
1116     function decimals() public view virtual override returns (uint8) {
1117         return 18;
1118     }
1119 
1120     receive() external payable {}
1121 
1122     function updateStakingAmounts(uint256 duration, uint256 bonus)
1123         public
1124         onlyOwner
1125     {
1126         require(stakingAmounts[duration] != bonus);
1127         require(bonus <= 100, "Staking bonus can't exceed 100");
1128         stakingAmounts[duration] = bonus;
1129         emit UpdateStakingAmounts(duration, bonus);
1130     }
1131 
1132     // writeable function to enable trading, can only enable, trading can never be disabled
1133     function enableTrading() external onlyOwner {
1134         require(!tradingEnabled);
1135         tradingEnabled = true;
1136         launchblock = block.number;
1137         emit TradingEnabled();
1138     }
1139     // use for pre sale wallet, adds all exclusions to it
1140     function setPresaleWallet(address wallet) external onlyOwner {
1141         canTransferBeforeTradingIsEnabled[wallet] = true;
1142         _isExcludedFromFees[wallet] = true;
1143         dividendTracker.excludeFromDividends(wallet);
1144         emit SetPreSaleWallet(wallet);
1145     }
1146     
1147     // exclude a wallet from fees 
1148     function setExcludeFees(address account, bool excluded) public onlyOwner {
1149         _isExcludedFromFees[account] = excluded;
1150         emit ExcludeFromFees(account, excluded);
1151     }
1152 
1153     // exclude from dividends (rewards)
1154     function setExcludeDividends(address account) public onlyOwner {
1155         dividendTracker.excludeFromDividends(account);
1156     }
1157 
1158     // include in dividends 
1159     function setIncludeDividends(address account) public onlyOwner {
1160         dividendTracker.includeFromDividends(account);
1161         dividendTracker.setBalance(account, getStakingBalance(account));
1162     }
1163 
1164     //allow a wallet to trade before trading enabled
1165     function setCanTransferBefore(address wallet, bool enable)
1166         external
1167         onlyOwner
1168     {
1169         canTransferBeforeTradingIsEnabled[wallet] = enable;
1170     }
1171 
1172     // turn limits on and off
1173     function setLimitsInEffect(bool value) external onlyOwner {
1174         limitsInEffect = value;
1175     }
1176 
1177     // set max GWEI
1178     function setGasPriceLimit(uint256 GWEI) external onlyOwner {
1179         require(GWEI >= 5, "can never be set below 5");
1180         gasPriceLimit = GWEI * 1 gwei;
1181     }
1182 
1183     // set cooldown timer, can only be between 0 and 300 seconds (5 mins max)
1184     function setcooldowntimer(uint256 value) external onlyOwner {
1185         require(value <= 300, "cooldown timer cannot exceed 5 minutes");
1186         cooldowntimer = value;
1187     }
1188 
1189     // set max wallet, can not be lower than 0.05% of supply
1190     function setmaxWallet(uint256 value) external onlyOwner {
1191         value = value * (10**18);
1192         require(value >= _totalSupply / 2000, "max wallet cannot be set to less than 0.05%");
1193         maxWallet = value;
1194     }
1195 
1196     
1197     function enableStaking(bool enable) public onlyOwner {
1198         require(stakingEnabled != enable);
1199         stakingEnabled = enable;
1200         emit EnableStaking(enable);
1201     }
1202 
1203     function stake(uint256 duration) public {
1204         require(stakingEnabled, "Staking is not enabled");
1205         require(stakingAmounts[duration] != 0, "Invalid staking duration");
1206         require(
1207             stakingUntilDate[_msgSender()] < block.timestamp.add(duration),
1208             "already staked for a longer duration"
1209         );
1210         stakingBonus[_msgSender()] = stakingAmounts[duration];
1211         stakingUntilDate[_msgSender()] = block.timestamp.add(duration);
1212         dividendTracker.setBalance(
1213             _msgSender(),
1214             getStakingBalance(_msgSender())
1215         );
1216         emit EnableAccountStaking(_msgSender(), duration);
1217     }
1218 
1219     // rewards threshold
1220     function setSwapTriggerAmount(uint256 amount) public onlyOwner {
1221         swapTokensAtAmount = amount * (10**18);
1222     }
1223 
1224     function enableSwapAndLiquify(bool enabled) public onlyOwner {
1225         require(swapAndLiquifyEnabled != enabled);
1226         swapAndLiquifyEnabled = enabled;
1227         emit EnableSwapAndLiquify(enabled);
1228     }
1229 
1230     function setAutomatedMarketMakerPair(address pair, bool value)
1231         public
1232         onlyOwner
1233     {
1234         _setAutomatedMarketMakerPair(pair, value);
1235     }
1236 
1237     function setAllowCustomTokens(bool allow) public onlyOwner {
1238         dividendTracker.setAllowCustomTokens(allow);
1239     }
1240 
1241     function setAllowAutoReinvest(bool allow) public onlyOwner {
1242         dividendTracker.setAllowAutoReinvest(allow);
1243     }
1244 
1245     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1246         automatedMarketMakerPairs[pair] = value;
1247 
1248         if (value) {
1249             dividendTracker.excludeFromDividends(pair);
1250         }
1251 
1252         emit SetAutomatedMarketMakerPair(pair, value);
1253     }
1254 
1255     function updateGasForProcessing(uint256 newValue) public onlyOwner {
1256         require(newValue >= 200000 && newValue <= 1000000);
1257         emit GasForProcessingUpdated(newValue, gasForProcessing);
1258         gasForProcessing = newValue;
1259     }
1260 
1261     function transferAdmin(address newOwner) public onlyOwner {
1262         dividendTracker.excludeFromDividends(newOwner);
1263         _isExcludedFromFees[newOwner] = true;
1264         transferOwnership(newOwner);
1265     }
1266 
1267     function updateTransferFee(uint256 newTransferFee) public onlyOwner {
1268         require (newTransferFee <= 5, "transfer fee cannot exceed 5%");
1269         transferFee = newTransferFee;
1270         emit UpdateTransferFee(transferFee);
1271     }
1272 
1273     function updateFees(
1274         uint256 deadBuy,
1275         uint256 deadSell,
1276         uint256 marketingBuy,
1277         uint256 marketingSell,
1278         uint256 liquidityBuy,
1279         uint256 liquiditySell,
1280         uint256 RewardsBuy,
1281         uint256 RewardsSell,
1282         uint256 devBuy,
1283         uint256 devSell
1284     ) public onlyOwner {
1285         buyDeadFees = deadBuy;
1286         buyMarketingFees = marketingBuy;
1287         buyLiquidityFee = liquidityBuy;
1288         buyRewardsFee = RewardsBuy;
1289         sellDeadFees = deadSell;
1290         sellMarketingFees = marketingSell;
1291         sellLiquidityFee = liquiditySell;
1292         sellRewardsFee = RewardsSell;
1293         buyDevFee = devBuy;
1294         sellDevFee = devSell;
1295 
1296         totalSellFees = sellRewardsFee
1297             .add(sellLiquidityFee)
1298             .add(sellMarketingFees)
1299             .add(sellDevFee);
1300 
1301         totalBuyFees = buyRewardsFee
1302             .add(buyLiquidityFee)
1303             .add(buyMarketingFees)
1304             .add(buyDevFee);
1305 
1306         require(totalSellFees <= 15 && totalBuyFees <= 15, "total fees cannot exceed 15% sell or buy");
1307 
1308         emit UpdateFees(
1309             sellDeadFees,
1310             sellMarketingFees,
1311             sellLiquidityFee,
1312             sellRewardsFee,
1313             buyDeadFees,
1314             buyMarketingFees,
1315             buyLiquidityFee,
1316             buyRewardsFee,
1317             buyDevFee,
1318             sellDevFee
1319         );
1320     }
1321 
1322     function getStakingInfo(address account)
1323         external
1324         view
1325         returns (uint256, uint256)
1326     {
1327         return (stakingUntilDate[account], stakingBonus[account]);
1328     }
1329 
1330     function getTotalDividendsDistributed() external view returns (uint256) {
1331         return dividendTracker.totalDividendsDistributed();
1332     }
1333 
1334     function isExcludedFromFees(address account) public view returns (bool) {
1335         return _isExcludedFromFees[account];
1336     }
1337 
1338     function withdrawableDividendOf(address account)
1339         public
1340         view
1341         returns (uint256)
1342     {
1343         return dividendTracker.withdrawableDividendOf(account);
1344     }
1345 
1346     function dividendTokenBalanceOf(address account)
1347         public
1348         view
1349         returns (uint256)
1350     {
1351         return dividendTracker.balanceOf(account);
1352     }
1353 
1354     function getAccountDividendsInfo(address account)
1355         external
1356         view
1357         returns (
1358             address,
1359             int256,
1360             int256,
1361             uint256,
1362             uint256,
1363             uint256
1364         )
1365     {
1366         return dividendTracker.getAccount(account);
1367     }
1368 
1369     function getAccountDividendsInfoAtIndex(uint256 index)
1370         external
1371         view
1372         returns (
1373             address,
1374             int256,
1375             int256,
1376             uint256,
1377             uint256,
1378             uint256
1379         )
1380     {
1381         return dividendTracker.getAccountAtIndex(index);
1382     }
1383 
1384     function processDividendTracker(uint256 gas) external {
1385         (
1386             uint256 iterations,
1387             uint256 claims,
1388             uint256 lastProcessedIndex
1389         ) = dividendTracker.process(gas);
1390         emit ProcessedDividendTracker(
1391             iterations,
1392             claims,
1393             lastProcessedIndex,
1394             false,
1395             gas,
1396             tx.origin
1397         );
1398     }
1399 
1400     function claim() external {
1401         dividendTracker.processAccount(payable(msg.sender), false);
1402     }
1403 
1404     function getLastProcessedIndex() external view returns (uint256) {
1405         return dividendTracker.getLastProcessedIndex();
1406     }
1407 
1408     function getNumberOfDividendTokenHolders() external view returns (uint256) {
1409         return dividendTracker.getNumberOfTokenHolders();
1410     }
1411 
1412     function setAutoClaim(bool value) external {
1413         dividendTracker.setAutoClaim(msg.sender, value);
1414     }
1415 
1416     function setReinvest(bool value) external {
1417         dividendTracker.setReinvest(msg.sender, value);
1418     }
1419 
1420     function setDividendsPaused(bool value) external onlyOwner {
1421         dividendTracker.setDividendsPaused(value);
1422     }
1423 
1424     function isExcludedFromAutoClaim(address account)
1425         external
1426         view
1427         returns (bool)
1428     {
1429         return dividendTracker.isExcludedFromAutoClaim(account);
1430     }
1431 
1432     function isReinvest(address account) external view returns (bool) {
1433         return dividendTracker.isReinvest(account);
1434     }
1435 
1436     function _transfer(
1437         address from,
1438         address to,
1439         uint256 amount
1440     ) internal override {
1441         require(from != address(0), "ERC20: transfer from the zero address");
1442         require(to != address(0), "ERC20: transfer to the zero address");
1443         uint256 RewardsFee;
1444         uint256 deadFees;
1445         uint256 marketingFees;
1446         uint256 liquidityFee;
1447         uint256 devFees;
1448 
1449         if (!canTransferBeforeTradingIsEnabled[from]) {
1450             require(tradingEnabled, "Trading has not yet been enabled");
1451         }
1452         if (amount == 0) {
1453             super._transfer(from, to, 0);
1454             return;
1455         } else if (
1456             !swapping && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]
1457         ) {
1458             bool isSelling = automatedMarketMakerPairs[to];
1459             bool isBuying = automatedMarketMakerPairs[from];
1460 
1461             if (!isBuying && !isSelling) {
1462                 uint256 tFees = amount.mul(transferFee).div(100);
1463                 amount = amount.sub(tFees);
1464                 super._transfer(from, address(this), tFees);
1465                 super._transfer(from, to, amount);
1466                 dividendTracker.setBalance(from, getStakingBalance(from));
1467                 dividendTracker.setBalance(to, getStakingBalance(to));
1468                 return;
1469             }
1470             
1471             else if (!isBuying && stakingEnabled) {
1472                 require(
1473                     stakingUntilDate[from] <= block.timestamp,
1474                     "Tokens are staked and locked!"
1475                 );
1476                 if (stakingUntilDate[from] != 0) {
1477                     stakingUntilDate[from] = 0;
1478                     stakingBonus[from] = 0;
1479                 }
1480             }
1481 
1482             else if (isSelling) {
1483                 RewardsFee = sellRewardsFee;
1484                 deadFees = sellDeadFees;
1485                 marketingFees = sellMarketingFees;
1486                 liquidityFee = sellLiquidityFee;
1487                 devFees = sellDevFee;
1488 
1489                 if (limitsInEffect) {
1490                 require(block.timestamp >= _holderLastTransferTimestamp[tx.origin] + cooldowntimer,
1491                         "cooldown period active");
1492                 _holderLastTransferTimestamp[tx.origin] = block.timestamp;
1493 
1494                 }
1495 
1496             } else if (isBuying) {
1497                 RewardsFee = buyRewardsFee;
1498                 deadFees = buyDeadFees;
1499                 marketingFees = buyMarketingFees;
1500                 liquidityFee = buyLiquidityFee;
1501                 devFees = buyDevFee;
1502 
1503                 if (limitsInEffect) {
1504                 require(block.number > launchblock + 2,"you shall not pass");
1505                 require(tx.gasprice <= gasPriceLimit,"Gas price exceeds limit.");
1506                 require(_holderLastTransferBlock[tx.origin] != block.number,"Too many TX in block");
1507                 _holderLastTransferBlock[tx.origin] = block.number;
1508             }
1509             
1510             uint256 contractBalanceRecipient = balanceOf(to);
1511             require(contractBalanceRecipient + amount <= maxWallet,
1512                     "Exceeds maximum wallet token amount." );
1513             }
1514 
1515             uint256 totalFees = RewardsFee
1516                 .add(liquidityFee + marketingFees + devFees);
1517 
1518             uint256 contractTokenBalance = balanceOf(address(this));
1519 
1520             bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1521 
1522             if (canSwap && !automatedMarketMakerPairs[from]) {
1523                 swapping = true;
1524 
1525                 if (swapAndLiquifyEnabled && liquidityFee > 0 && totalBuyFees > 0) {
1526                     uint256 totalBuySell = buyAmount.add(sellAmount);
1527                     uint256 swapAmountBought = contractTokenBalance
1528                         .mul(buyAmount)
1529                         .div(totalBuySell);
1530                     uint256 swapAmountSold = contractTokenBalance
1531                         .mul(sellAmount)
1532                         .div(totalBuySell);
1533 
1534                     uint256 swapBuyTokens = swapAmountBought
1535                         .mul(liquidityFee)
1536                         .div(totalBuyFees);
1537 
1538                     uint256 swapSellTokens = swapAmountSold
1539                         .mul(liquidityFee)
1540                         .div(totalSellFees);
1541 
1542                     uint256 swapTokens = swapSellTokens.add(swapBuyTokens);
1543 
1544                     swapAndLiquify(swapTokens);
1545                 }
1546 
1547                 uint256 remainingBalance = balanceOf(address(this));
1548                 swapAndSendDividends(remainingBalance);
1549                 buyAmount = 0;
1550                 sellAmount = 0;
1551                 swapping = false;
1552             }
1553 
1554             uint256 fees = amount.mul(totalFees).div(100);
1555             uint256 burntokens;
1556 
1557             if (deadFees > 0) {
1558             burntokens = amount.mul(deadFees) / 100;
1559             super._transfer(from, DEAD, burntokens);
1560             _totalSupply = _totalSupply.sub(burntokens);
1561 
1562             }
1563 
1564             amount = amount.sub(fees + burntokens);
1565 
1566             if (isSelling) {
1567                 sellAmount = sellAmount.add(fees);
1568             } else {
1569                 buyAmount = buyAmount.add(fees);
1570             }
1571 
1572             super._transfer(from, address(this), fees);
1573 
1574             uint256 gas = gasForProcessing;
1575 
1576             try dividendTracker.process(gas) returns (
1577                 uint256 iterations,
1578                 uint256 claims,
1579                 uint256 lastProcessedIndex
1580             ) {
1581                 emit ProcessedDividendTracker(
1582                     iterations,
1583                     claims,
1584                     lastProcessedIndex,
1585                     true,
1586                     gas,
1587                     tx.origin
1588                 );
1589             } catch {}
1590         }
1591 
1592         super._transfer(from, to, amount);
1593         dividendTracker.setBalance(from, getStakingBalance(from));
1594         dividendTracker.setBalance(to, getStakingBalance(to));
1595     }
1596 
1597     function getStakingBalance(address account) private view returns (uint256) {
1598         return
1599             stakingEnabled
1600                 ? balanceOf(account).mul(stakingBonus[account].add(100)).div(
1601                     100
1602                 )
1603                 : balanceOf(account);
1604     }
1605 
1606     function swapAndLiquify(uint256 tokens) private {
1607         uint256 half = tokens.div(2);
1608         uint256 otherHalf = tokens.sub(half);
1609         uint256 initialBalance = address(this).balance;
1610         swapTokensForEth(half); 
1611         uint256 newBalance = address(this).balance.sub(initialBalance);
1612         addLiquidity(otherHalf, newBalance);
1613         emit SwapAndLiquify(half, newBalance, otherHalf);
1614     }
1615 
1616     function swapTokensForEth(uint256 tokenAmount) private {
1617         address[] memory path = new address[](2);
1618         path[0] = address(this);
1619         path[1] = uniswapV2Router.WETH();
1620         _approve(address(this), address(uniswapV2Router), tokenAmount);
1621         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1622             tokenAmount,
1623             0, // accept any amount of ETH
1624             path,
1625             address(this),
1626             block.timestamp
1627         );
1628     }
1629 
1630     function updatePayoutToken(address token) public onlyOwner {
1631         dividendTracker.updatePayoutToken(token);
1632         emit UpdatePayoutToken(token);
1633     }
1634 
1635     function getPayoutToken() public view returns (address) {
1636         return dividendTracker.getPayoutToken();
1637     }
1638 
1639     function setMinimumTokenBalanceForAutoDividends(uint256 value)
1640         public
1641         onlyOwner
1642     {
1643         dividendTracker.setMinimumTokenBalanceForAutoDividends(value);
1644     }
1645 
1646     function setMinimumTokenBalanceForDividends(uint256 value)
1647         public
1648         onlyOwner
1649     {
1650         dividendTracker.setMinimumTokenBalanceForDividends(value);
1651     }
1652 
1653     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1654         // approve token transfer to cover all possible scenarios
1655         _approve(address(this), address(uniswapV2Router), tokenAmount);
1656 
1657         // add the liquidity
1658         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1659             address(this),
1660             tokenAmount,
1661             0, // slippage is unavoidable
1662             0, // slippage is unavoidable
1663             owner(),
1664             block.timestamp
1665         );
1666     }
1667 
1668     function forceSwapAndSendDividends(uint256 tokens) public onlyOwner {
1669         tokens = tokens * (10**18);
1670         uint256 totalAmount = buyAmount.add(sellAmount);
1671         uint256 fromBuy = tokens.mul(buyAmount).div(totalAmount);
1672         uint256 fromSell = tokens.mul(sellAmount).div(totalAmount);
1673 
1674         swapAndSendDividends(tokens);
1675 
1676         buyAmount = buyAmount.sub(fromBuy);
1677         sellAmount = sellAmount.sub(fromSell);
1678     }
1679 
1680     function swapAndSendDividends(uint256 tokens) private {
1681         if (tokens == 0) {
1682             return;
1683         }
1684         swapTokensForEth(tokens);
1685         uint256 totalAmount = buyAmount.add(sellAmount);
1686 
1687         bool success = true;
1688         bool successOp1 = true;
1689         bool successOp2 = true;
1690 
1691         uint256 dividends;
1692         uint256 dividendsFromBuy;
1693         uint256 dividendsFromSell;
1694 
1695         if (buyRewardsFee > 0) {
1696             dividendsFromBuy = address(this)
1697             .balance
1698             .mul(buyAmount)
1699             .div(totalAmount)
1700             .mul(buyRewardsFee)
1701             .div(buyRewardsFee + buyMarketingFees + buyDevFee);
1702         }
1703         if (sellRewardsFee > 0) {
1704             dividendsFromSell = address(this)
1705             .balance
1706             .mul(sellAmount)
1707             .div(totalAmount)
1708             .mul(sellRewardsFee)
1709             .div(sellRewardsFee + sellMarketingFees + sellDevFee);
1710         }
1711         dividends = dividendsFromBuy.add(dividendsFromSell);
1712 
1713         if (dividends > 0) {
1714             (success, ) = address(dividendTracker).call{value: dividends}("");
1715         }
1716         
1717         uint256 _completeFees = sellMarketingFees.add(sellDevFee) +
1718             buyMarketingFees.add(buyDevFee);
1719 
1720         uint256 feePortions;
1721         if (_completeFees > 0) {
1722             feePortions = address(this).balance.div(_completeFees);
1723         }
1724         uint256 marketingPayout = buyMarketingFees.add(sellMarketingFees) * feePortions;
1725         uint256 devPayout = buyDevFee.add(sellDevFee) * feePortions;
1726 
1727         if (marketingPayout > 0) {
1728             (successOp1, ) = address(marketingWallet).call{value: marketingPayout}("");
1729         }
1730         if (devPayout > 0) {
1731             (successOp2, ) = address(devWallet).call{value: devPayout}("");
1732         }
1733 
1734         emit SendDividends(
1735             dividends,
1736             marketingPayout + devPayout,
1737             success && successOp1 && successOp2
1738         );
1739     }
1740 
1741     function multiSend(
1742         address[] memory _contributors,
1743         uint256[] memory _balances
1744     ) public onlyOwner {
1745         require(
1746             _contributors.length == _balances.length,
1747             "Contributors and balances must be same size"
1748         );
1749         // Max 200 sends in bulk, uint8 in loop limited to 255
1750         require(
1751             _contributors.length <= 200,
1752             "Contributor list length must be <= 200"
1753         );
1754         uint256 sumOfBalances = 0;
1755         for (uint8 i = 0; i < _balances.length; i++) {
1756             sumOfBalances = sumOfBalances.add(_balances[i]);
1757         }
1758         require(
1759             balanceOf(msg.sender) >= sumOfBalances,
1760             "Account balance must be >= sum of balances. "
1761         );
1762         require(
1763             allowance(msg.sender, address(this)) >= sumOfBalances,
1764             "Contract allowance must be >= sum of balances. "
1765         );
1766         address contributor;
1767         uint256 origBalance;
1768         for (uint8 j; j < _contributors.length; j++) {
1769             contributor = _contributors[j];
1770             require(
1771                 contributor != address(0) &&
1772                     contributor != 0x000000000000000000000000000000000000dEaD,
1773                 "Cannot airdrop to a dead address"
1774             );
1775             origBalance = balanceOf(contributor);
1776             this.transferFrom(msg.sender, contributor, _balances[j]);
1777             require(
1778                 balanceOf(contributor) == origBalance + _balances[j],
1779                 "Contributor must recieve full balance of airdrop"
1780             );
1781             emit Airdrop(contributor, _balances[j]);
1782         }
1783     }
1784 
1785     function airdropToWallets(
1786         address[] memory airdropWallets,
1787         uint256[] memory amount
1788     ) external onlyOwner {
1789         require(airdropWallets.length == amount.length,"Arrays must be the same length");
1790         require(airdropWallets.length <= 200, "Wallets list length must be <= 200");
1791         for (uint256 i = 0; i < airdropWallets.length; i++) {
1792             address wallet = airdropWallets[i];
1793             uint256 airdropAmount = amount[i] * (10**18);
1794             super._transfer(msg.sender, wallet, airdropAmount);
1795             dividendTracker.setBalance(payable(wallet), balanceOf(wallet));
1796         }
1797     }
1798 }
1799 
1800 contract NecroDaoDividendTracker is DividendPayingToken, Ownable {
1801     using SafeMath for uint256;
1802     using SafeMathInt for int256;
1803     using IterableMapping for IterableMapping.Map;
1804 
1805     IterableMapping.Map private tokenHoldersMap;
1806     uint256 public lastProcessedIndex;
1807 
1808     mapping(address => bool) public excludedFromDividends;
1809     mapping(address => bool) public excludedFromAutoClaim;
1810     mapping(address => bool) public autoReinvest;
1811     address public defaultToken; // BUSD
1812     bool public allowCustomTokens;
1813     bool public allowAutoReinvest;
1814     bool public dividendsPaused = false;
1815 
1816     string private trackerName;
1817     string private trackerTicker;
1818 
1819     IUniswapV2Router02 public uniswapV2Router;
1820 
1821     NecroDao public NecroDaoContract;
1822 
1823     mapping(address => uint256) public lastClaimTimes;
1824 
1825     uint256 private minimumTokenBalanceForAutoDividends;
1826     uint256 private minimumTokenBalanceForDividends;
1827 
1828     event ExcludeFromDividends(address indexed account);
1829     event ClaimWaitUpdated(uint256 indexed newValue, uint256 indexed oldValue);
1830     event DividendReinvested(
1831         address indexed acount,
1832         uint256 value,
1833         bool indexed automatic
1834     );
1835     event Claim(
1836         address indexed account,
1837         uint256 amount,
1838         bool indexed automatic
1839     );
1840     event DividendsPaused(bool paused);
1841     event SetAllowCustomTokens(bool allow);
1842     event SetAllowAutoReinvest(bool allow);
1843 
1844     constructor(
1845         address payable mainContract,
1846         address router,
1847         address token,
1848         string memory _name,
1849         string memory _ticker
1850     ) DividendPayingToken(_name, _ticker) {
1851         trackerName = _name;
1852         trackerTicker = _ticker;
1853         defaultToken = token;
1854         NecroDaoContract = NecroDao(mainContract);
1855         minimumTokenBalanceForAutoDividends = 1000_000000000000000000; // 1000 tokens
1856         minimumTokenBalanceForDividends = minimumTokenBalanceForAutoDividends;
1857 
1858         uniswapV2Router = IUniswapV2Router02(router);
1859         allowCustomTokens = true;
1860         allowAutoReinvest = false;
1861     }
1862 
1863     function decimals() public view virtual override returns (uint8) {
1864         return 18;
1865     }
1866 
1867     function name() public view virtual override returns (string memory) {
1868         return trackerName;
1869     }
1870 
1871     function symbol() public view virtual override returns (string memory) {
1872         return trackerTicker;
1873     }
1874 
1875     function _transfer(
1876         address,
1877         address,
1878         uint256
1879     ) internal pure override {
1880         require(false, "NecroDao_Dividend_Tracker: No transfers allowed");
1881     }
1882 
1883     function withdrawDividend() public pure override {
1884         require(
1885             false,
1886             "NecroDao_Dividend_Tracker: withdrawDividend disabled. Use the 'claim' function on the main NecroDao contract."
1887         );
1888     }
1889 
1890     function isExcludedFromAutoClaim(address account)
1891         external
1892         view
1893         onlyOwner
1894         returns (bool)
1895     {
1896         return excludedFromAutoClaim[account];
1897     }
1898 
1899     function isReinvest(address account)
1900         external
1901         view
1902         onlyOwner
1903         returns (bool)
1904     {
1905         return autoReinvest[account];
1906     }
1907 
1908     function setAllowCustomTokens(bool allow) external onlyOwner {
1909         require(allowCustomTokens != allow);
1910         allowCustomTokens = allow;
1911         emit SetAllowCustomTokens(allow);
1912     }
1913 
1914     function setAllowAutoReinvest(bool allow) external onlyOwner {
1915         require(allowAutoReinvest != allow);
1916         allowAutoReinvest = allow;
1917         emit SetAllowAutoReinvest(allow);
1918     }
1919 
1920     function excludeFromDividends(address account) external onlyOwner {
1921         //require(!excludedFromDividends[account]);
1922         excludedFromDividends[account] = true;
1923 
1924         _setBalance(account, 0);
1925         tokenHoldersMap.remove(account);
1926 
1927         emit ExcludeFromDividends(account);
1928     }
1929 
1930     function includeFromDividends(address account) external onlyOwner {
1931         excludedFromDividends[account] = false;
1932     }
1933 
1934     function setAutoClaim(address account, bool value) external onlyOwner {
1935         excludedFromAutoClaim[account] = value;
1936     }
1937 
1938     function setReinvest(address account, bool value) external onlyOwner {
1939         autoReinvest[account] = value;
1940     }
1941 
1942     function setMinimumTokenBalanceForAutoDividends(uint256 value)
1943         external
1944         onlyOwner
1945     {
1946         minimumTokenBalanceForAutoDividends = value * (10**18);
1947     }
1948 
1949     function setMinimumTokenBalanceForDividends(uint256 value)
1950         external
1951         onlyOwner
1952     {
1953         minimumTokenBalanceForDividends = value * (10**18);
1954     }
1955 
1956     function setDividendsPaused(bool value) external onlyOwner {
1957         require(dividendsPaused != value);
1958         dividendsPaused = value;
1959         emit DividendsPaused(value);
1960     }
1961 
1962     function getLastProcessedIndex() external view returns (uint256) {
1963         return lastProcessedIndex;
1964     }
1965 
1966     function getNumberOfTokenHolders() external view returns (uint256) {
1967         return tokenHoldersMap.keys.length;
1968     }
1969 
1970     function getAccount(address _account)
1971         public
1972         view
1973         returns (
1974             address account,
1975             int256 index,
1976             int256 iterationsUntilProcessed,
1977             uint256 withdrawableDividends,
1978             uint256 totalDividends,
1979             uint256 lastClaimTime
1980         )
1981     {
1982         account = _account;
1983 
1984         index = tokenHoldersMap.getIndexOfKey(account);
1985 
1986         iterationsUntilProcessed = -1;
1987 
1988         if (index >= 0) {
1989             if (uint256(index) > lastProcessedIndex) {
1990                 iterationsUntilProcessed = index.sub(
1991                     int256(lastProcessedIndex)
1992                 );
1993             } else {
1994                 uint256 processesUntilEndOfArray = tokenHoldersMap.keys.length >
1995                     lastProcessedIndex
1996                     ? tokenHoldersMap.keys.length.sub(lastProcessedIndex)
1997                     : 0;
1998 
1999                 iterationsUntilProcessed = index.add(
2000                     int256(processesUntilEndOfArray)
2001                 );
2002             }
2003         }
2004 
2005         withdrawableDividends = withdrawableDividendOf(account);
2006         totalDividends = accumulativeDividendOf(account);
2007 
2008         lastClaimTime = lastClaimTimes[account];
2009     }
2010 
2011     function getAccountAtIndex(uint256 index)
2012         public
2013         view
2014         returns (
2015             address,
2016             int256,
2017             int256,
2018             uint256,
2019             uint256,
2020             uint256
2021         )
2022     {
2023         if (index >= tokenHoldersMap.size()) {
2024             return (
2025                 0x0000000000000000000000000000000000000000,
2026                 -1,
2027                 -1,
2028                 0,
2029                 0,
2030                 0
2031             );
2032         }
2033 
2034         address account = tokenHoldersMap.getKeyAtIndex(index);
2035 
2036         return getAccount(account);
2037     }
2038 
2039     function setBalance(address account, uint256 newBalance)
2040         external
2041         onlyOwner
2042     {
2043         if (excludedFromDividends[account]) {
2044             return;
2045         }
2046 
2047         if (newBalance < minimumTokenBalanceForDividends) {
2048             tokenHoldersMap.remove(account);
2049             _setBalance(account, 0);
2050 
2051             return;
2052         }
2053 
2054         _setBalance(account, newBalance);
2055 
2056         if (newBalance >= minimumTokenBalanceForAutoDividends) {
2057             tokenHoldersMap.set(account, newBalance);
2058         } else {
2059             tokenHoldersMap.remove(account);
2060         }
2061     }
2062 
2063     function process(uint256 gas)
2064         public
2065         returns (
2066             uint256,
2067             uint256,
2068             uint256
2069         )
2070     {
2071         uint256 numberOfTokenHolders = tokenHoldersMap.keys.length;
2072 
2073         if (numberOfTokenHolders == 0 || dividendsPaused) {
2074             return (0, 0, lastProcessedIndex);
2075         }
2076 
2077         uint256 _lastProcessedIndex = lastProcessedIndex;
2078 
2079         uint256 gasUsed = 0;
2080 
2081         uint256 gasLeft = gasleft();
2082 
2083         uint256 iterations = 0;
2084         uint256 claims = 0;
2085 
2086         while (gasUsed < gas && iterations < numberOfTokenHolders) {
2087             _lastProcessedIndex++;
2088 
2089             if (_lastProcessedIndex >= numberOfTokenHolders) {
2090                 _lastProcessedIndex = 0;
2091             }
2092 
2093             address account = tokenHoldersMap.keys[_lastProcessedIndex];
2094 
2095             if (!excludedFromAutoClaim[account]) {
2096                 if (processAccount(payable(account), true)) {
2097                     claims++;
2098                 }
2099             }
2100 
2101             iterations++;
2102 
2103             uint256 newGasLeft = gasleft();
2104 
2105             if (gasLeft > newGasLeft) {
2106                 gasUsed = gasUsed.add(gasLeft.sub(newGasLeft));
2107             }
2108 
2109             gasLeft = newGasLeft;
2110         }
2111 
2112         lastProcessedIndex = _lastProcessedIndex;
2113 
2114         return (iterations, claims, lastProcessedIndex);
2115     }
2116 
2117     function processAccount(address payable account, bool automatic)
2118         public
2119         onlyOwner
2120         returns (bool)
2121     {
2122         if (dividendsPaused) {
2123             return false;
2124         }
2125 
2126         bool reinvest = autoReinvest[account];
2127 
2128         if (automatic && reinvest && !allowAutoReinvest) {
2129             return false;
2130         }
2131 
2132         uint256 amount = reinvest
2133             ? _reinvestDividendOfUser(account)
2134             : _withdrawDividendOfUser(account);
2135 
2136         if (amount > 0) {
2137             lastClaimTimes[account] = block.timestamp;
2138             if (reinvest) {
2139                 emit DividendReinvested(account, amount, automatic);
2140             } else {
2141                 emit Claim(account, amount, automatic);
2142             }
2143             return true;
2144         }
2145 
2146         return false;
2147     }
2148 
2149     function updateUniswapV2Router(address newAddress) public onlyOwner {
2150         uniswapV2Router = IUniswapV2Router02(newAddress);
2151     }
2152 
2153     function updatePayoutToken(address token) public onlyOwner {
2154         defaultToken = token;
2155     }
2156 
2157     function getPayoutToken() public view returns (address) {
2158         return defaultToken;
2159     }
2160 
2161     function _reinvestDividendOfUser(address account)
2162         private
2163         returns (uint256)
2164     {
2165         uint256 _withdrawableDividend = withdrawableDividendOf(account);
2166         if (_withdrawableDividend > 0) {
2167             bool success;
2168 
2169             withdrawnDividends[account] = withdrawnDividends[account].add(
2170                 _withdrawableDividend
2171             );
2172 
2173             address[] memory path = new address[](2);
2174             path[0] = uniswapV2Router.WETH();
2175             path[1] = address(NecroDaoContract);
2176 
2177             uint256 prevBalance = NecroDaoContract.balanceOf(address(this));
2178 
2179             // make the swap
2180             try
2181                 uniswapV2Router
2182                     .swapExactETHForTokensSupportingFeeOnTransferTokens{
2183                     value: _withdrawableDividend
2184                 }(
2185                     0, // accept any amount of Tokens
2186                     path,
2187                     address(this),
2188                     block.timestamp
2189                 )
2190             {
2191                 uint256 received = NecroDaoContract
2192                     .balanceOf(address(this))
2193                     .sub(prevBalance);
2194                 if (received > 0) {
2195                     success = true;
2196                     NecroDaoContract.transfer(account, received);
2197                 } else {
2198                     success = false;
2199                 }
2200             } catch {
2201                 success = false;
2202             }
2203 
2204             if (!success) {
2205                 withdrawnDividends[account] = withdrawnDividends[account].sub(
2206                     _withdrawableDividend
2207                 );
2208                 return 0;
2209             }
2210 
2211             return _withdrawableDividend;
2212         }
2213 
2214         return 0;
2215     }
2216 
2217     function _withdrawDividendOfUser(address payable user)
2218         internal
2219         override
2220         returns (uint256)
2221     {
2222         uint256 _withdrawableDividend = withdrawableDividendOf(user);
2223         if (_withdrawableDividend > 0) {
2224             withdrawnDividends[user] = withdrawnDividends[user].add(
2225                 _withdrawableDividend
2226             );
2227 
2228             address tokenAddress = defaultToken;
2229             bool success;
2230 
2231             if (tokenAddress == address(0)) {
2232                 (success, ) = user.call{
2233                     value: _withdrawableDividend,
2234                     gas: 3000
2235                 }("");
2236             } else {
2237                 address[] memory path = new address[](2);
2238                 path[0] = uniswapV2Router.WETH();
2239                 path[1] = tokenAddress;
2240                 try
2241                     uniswapV2Router
2242                         .swapExactETHForTokensSupportingFeeOnTransferTokens{
2243                         value: _withdrawableDividend
2244                     }(
2245                         0, // accept any amount of Tokens
2246                         path,
2247                         user,
2248                         block.timestamp
2249                     )
2250                 {
2251                     success = true;
2252                 } catch {
2253                     success = false;
2254                 }
2255             }
2256 
2257             if (!success) {
2258                 withdrawnDividends[user] = withdrawnDividends[user].sub(
2259                     _withdrawableDividend
2260                 );
2261                 return 0;
2262             } else {
2263                 emit DividendWithdrawn(user, _withdrawableDividend);
2264             }
2265             return _withdrawableDividend;
2266         }
2267         return 0;
2268     }
2269 }
2270 
2271 library IterableMapping {
2272     // Iterable mapping from address to uint;
2273     struct Map {
2274         address[] keys;
2275         mapping(address => uint256) values;
2276         mapping(address => uint256) indexOf;
2277         mapping(address => bool) inserted;
2278     }
2279 
2280     function get(Map storage map, address key) internal view returns (uint256) {
2281         return map.values[key];
2282     }
2283 
2284     function getIndexOfKey(Map storage map, address key)
2285         internal
2286         view
2287         returns (int256)
2288     {
2289         if (!map.inserted[key]) {
2290             return -1;
2291         }
2292         return int256(map.indexOf[key]);
2293     }
2294 
2295     function getKeyAtIndex(Map storage map, uint256 index)
2296         internal
2297         view
2298         returns (address)
2299     {
2300         return map.keys[index];
2301     }
2302 
2303     function size(Map storage map) internal view returns (uint256) {
2304         return map.keys.length;
2305     }
2306 
2307     function set(
2308         Map storage map,
2309         address key,
2310         uint256 val
2311     ) internal {
2312         if (map.inserted[key]) {
2313             map.values[key] = val;
2314         } else {
2315             map.inserted[key] = true;
2316             map.values[key] = val;
2317             map.indexOf[key] = map.keys.length;
2318             map.keys.push(key);
2319         }
2320     }
2321 
2322     function remove(Map storage map, address key) internal {
2323         if (!map.inserted[key]) {
2324             return;
2325         }
2326 
2327         delete map.inserted[key];
2328         delete map.values[key];
2329 
2330         uint256 index = map.indexOf[key];
2331         uint256 lastIndex = map.keys.length - 1;
2332         address lastKey = map.keys[lastIndex];
2333 
2334         map.indexOf[lastKey] = index;
2335         delete map.indexOf[key];
2336 
2337         map.keys[index] = lastKey;
2338         map.keys.pop();
2339     }
2340 }