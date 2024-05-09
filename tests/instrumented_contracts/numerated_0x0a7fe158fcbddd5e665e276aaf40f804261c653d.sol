1 // File: Neuralink.sol
2 
3 
4 
5 pragma solidity ^0.8.9;
6 
7 
8 
9 abstract contract Context {
10 
11     function _msgSender() internal view virtual returns (address) {
12 
13         return msg.sender;
14 
15     }
16 
17 }
18 
19 
20 
21 interface IERC20 {
22 
23     function totalSupply() external view returns (uint256);
24 
25 
26 
27     function balanceOf(address account) external view returns (uint256);
28 
29 
30 
31     function transfer(address recipient, uint256 amount) external returns (bool);
32 
33 
34 
35     function allowance(address owner, address spender) external view returns (uint256);
36 
37 
38 
39     function approve(address spender, uint256 amount) external returns (bool);
40 
41 
42 
43     function transferFrom(
44 
45         address sender,
46 
47         address recipient,
48 
49         uint256 amount
50 
51     ) external returns (bool);
52 
53 
54 
55     event Transfer(address indexed from, address indexed to, uint256 value);
56 
57     event Approval(
58 
59         address indexed owner,
60 
61         address indexed spender,
62 
63         uint256 value
64 
65     );
66 
67 }
68 
69 
70 
71 contract Ownable is Context {
72 
73     address private _owner;
74 
75     address private _previousOwner;
76 
77     event OwnershipTransferred(
78 
79         address indexed previousOwner,
80 
81         address indexed newOwner
82 
83     );
84 
85 
86 
87     constructor() {
88 
89         address msgSender = _msgSender();
90 
91         _owner = msgSender;
92 
93         emit OwnershipTransferred(address(0), msgSender);
94 
95     }
96 
97 
98 
99     function owner() public view returns (address) {
100 
101         return _owner;
102 
103     }
104 
105 
106 
107     modifier onlyOwner() {
108 
109         require(_owner == _msgSender(), "Ownable: caller is not the owner");
110 
111         _;
112 
113     }
114 
115 
116 
117     function renounceOwnership() public virtual onlyOwner {
118 
119         emit OwnershipTransferred(_owner, address(0));
120 
121         _owner = address(0);
122 
123     }
124 
125 
126 
127     function transferOwnership(address newOwner) public virtual onlyOwner {
128 
129         require(newOwner != address(0), "Ownable: new owner is the zero address");
130 
131         emit OwnershipTransferred(_owner, newOwner);
132 
133         _owner = newOwner;
134 
135     }
136 
137 
138 
139 }
140 
141 
142 
143 library SafeMath {
144 
145     function add(uint256 a, uint256 b) internal pure returns (uint256) {
146 
147         uint256 c = a + b;
148 
149         require(c >= a, "SafeMath: addition overflow");
150 
151         return c;
152 
153     }
154 
155 
156 
157     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
158 
159         return sub(a, b, "SafeMath: subtraction overflow");
160 
161     }
162 
163 
164 
165     function sub(
166 
167         uint256 a,
168 
169         uint256 b,
170 
171         string memory errorMessage
172 
173     ) internal pure returns (uint256) {
174 
175         require(b <= a, errorMessage);
176 
177         uint256 c = a - b;
178 
179         return c;
180 
181     }
182 
183 
184 
185     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
186 
187         if (a == 0) {
188 
189             return 0;
190 
191         }
192 
193         uint256 c = a * b;
194 
195         require(c / a == b, "SafeMath: multiplication overflow");
196 
197         return c;
198 
199     }
200 
201 
202 
203     function div(uint256 a, uint256 b) internal pure returns (uint256) {
204 
205         return div(a, b, "SafeMath: division by zero");
206 
207     }
208 
209 
210 
211     function div(
212 
213         uint256 a,
214 
215         uint256 b,
216 
217         string memory errorMessage
218 
219     ) internal pure returns (uint256) {
220 
221         require(b > 0, errorMessage);
222 
223         uint256 c = a / b;
224 
225         return c;
226 
227     }
228 
229 }
230 
231 
232 
233 interface IUniswapV2Factory {
234 
235     function createPair(address tokenA, address tokenB)
236 
237         external
238 
239         returns (address pair);
240 
241 }
242 
243 
244 
245 interface IUniswapV2Router02 {
246 
247     function swapExactTokensForETHSupportingFeeOnTransferTokens(
248 
249         uint256 amountIn,
250 
251         uint256 amountOutMin,
252 
253         address[] calldata path,
254 
255         address to,
256 
257         uint256 deadline
258 
259     ) external;
260 
261 
262 
263     function factory() external pure returns (address);
264 
265 
266 
267     function WETH() external pure returns (address);
268 
269 
270 
271     function addLiquidityETH(
272 
273         address token,
274 
275         uint256 amountTokenDesired,
276 
277         uint256 amountTokenMin,
278 
279         uint256 amountETHMin,
280 
281         address to,
282 
283         uint256 deadline
284 
285     )
286 
287         external
288 
289         payable
290 
291         returns (
292 
293             uint256 amountToken,
294 
295             uint256 amountETH,
296 
297             uint256 liquidity
298 
299         );
300 
301 }
302 
303 
304 
305 contract Neuralink is Context, IERC20, Ownable {
306 
307 
308 
309     using SafeMath for uint256;
310 
311 
312 
313     string private constant _name = "Neuralink";
314 
315     string private constant _symbol = "Neuralink";
316 
317     uint8 private constant _decimals = 9;
318 
319 
320 
321     mapping(address => uint256) private _rOwned;
322 
323     mapping(address => uint256) private _tOwned;
324 
325     mapping(address => mapping(address => uint256)) private _allowances;
326 
327     mapping(address => bool) private _isExcludedFromFee;
328 
329     uint256 private constant MAX = ~uint256(0);
330 
331     uint256 private constant _tTotal = 1000000000 * 10**9;
332 
333     uint256 private _rTotal = (MAX - (MAX % _tTotal));
334 
335     uint256 private _tFeeTotal;
336 
337     uint256 private _redisFeeOnBuy = 3;
338 
339     uint256 private _taxFeeOnBuy = 4;
340 
341     uint256 private _redisFeeOnSell = 3;
342 
343     uint256 private _taxFeeOnSell = 4;
344 
345 
346 
347     //Original Fee
348 
349     uint256 private _redisFee = _redisFeeOnSell;
350 
351     uint256 private _taxFee = _taxFeeOnSell;
352 
353 
354 
355     uint256 private _previousredisFee = _redisFee;
356 
357     uint256 private _previoustaxFee = _taxFee;
358 
359 
360 
361     mapping(address => bool) public bots; mapping (address => uint256) public _buyMap;
362 
363     address payable private _developmentAddress = payable(0xe3eCCBE502C15dE05296F6899e35845177ccAAB4);
364 
365     address payable private _marketingAddress = payable(0xe3eCCBE502C15dE05296F6899e35845177ccAAB4);
366 
367 
368 
369     IUniswapV2Router02 public uniswapV2Router;
370 
371     address public uniswapV2Pair;
372 
373 
374 
375     bool private tradingOpen = true;
376 
377     bool private inSwap = false;
378 
379     bool private swapEnabled = true;
380 
381 
382 
383     uint256 public _maxTxAmount = 20000000 * 10**9;
384 
385     uint256 public _maxWalletSize = 20000000 * 10**9;
386 
387     uint256 public _swapTokensAtAmount = 10000 * 10**9;
388 
389 
390 
391     event MaxTxAmountUpdated(uint256 _maxTxAmount);
392 
393     modifier lockTheSwap {
394 
395         inSwap = true;
396 
397         _;
398 
399         inSwap = false;
400 
401     }
402 
403 
404 
405     constructor() {
406 
407 
408 
409         _rOwned[_msgSender()] = _rTotal;
410 
411 
412 
413         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//
414 
415         uniswapV2Router = _uniswapV2Router;
416 
417         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
418 
419             .createPair(address(this), _uniswapV2Router.WETH());
420 
421 
422 
423         _isExcludedFromFee[owner()] = true;
424 
425         _isExcludedFromFee[address(this)] = true;
426 
427         _isExcludedFromFee[_developmentAddress] = true;
428 
429         _isExcludedFromFee[_marketingAddress] = true;
430 
431 
432 
433         emit Transfer(address(0), _msgSender(), _tTotal);
434 
435     }
436 
437 
438 
439     function name() public pure returns (string memory) {
440 
441         return _name;
442 
443     }
444 
445 
446 
447     function symbol() public pure returns (string memory) {
448 
449         return _symbol;
450 
451     }
452 
453 
454 
455     function decimals() public pure returns (uint8) {
456 
457         return _decimals;
458 
459     }
460 
461 
462 
463     function totalSupply() public pure override returns (uint256) {
464 
465         return _tTotal;
466 
467     }
468 
469 
470 
471     function balanceOf(address account) public view override returns (uint256) {
472 
473         return tokenFromReflection(_rOwned[account]);
474 
475     }
476 
477 
478 
479     function transfer(address recipient, uint256 amount)
480 
481         public
482 
483         override
484 
485         returns (bool)
486 
487     {
488 
489         _transfer(_msgSender(), recipient, amount);
490 
491         return true;
492 
493     }
494 
495 
496 
497     function allowance(address owner, address spender)
498 
499         public
500 
501         view
502 
503         override
504 
505         returns (uint256)
506 
507     {
508 
509         return _allowances[owner][spender];
510 
511     }
512 
513 
514 
515     function approve(address spender, uint256 amount)
516 
517         public
518 
519         override
520 
521         returns (bool)
522 
523     {
524 
525         _approve(_msgSender(), spender, amount);
526 
527         return true;
528 
529     }
530 
531 
532 
533     function transferFrom(
534 
535         address sender,
536 
537         address recipient,
538 
539         uint256 amount
540 
541     ) public override returns (bool) {
542 
543         _transfer(sender, recipient, amount);
544 
545         _approve(
546 
547             sender,
548 
549             _msgSender(),
550 
551             _allowances[sender][_msgSender()].sub(
552 
553                 amount,
554 
555                 "ERC20: transfer amount exceeds allowance"
556 
557             )
558 
559         );
560 
561         return true;
562 
563     }
564 
565 
566 
567     function tokenFromReflection(uint256 rAmount)
568 
569         private
570 
571         view
572 
573         returns (uint256)
574 
575     {
576 
577         require(
578 
579             rAmount <= _rTotal,
580 
581             "Amount must be less than total reflections"
582 
583         );
584 
585         uint256 currentRate = _getRate();
586 
587         return rAmount.div(currentRate);
588 
589     }
590 
591 
592 
593     function removeAllFee() private {
594 
595         if (_redisFee == 0 && _taxFee == 0) return;
596 
597 
598 
599         _previousredisFee = _redisFee;
600 
601         _previoustaxFee = _taxFee;
602 
603 
604 
605         _redisFee = 0;
606 
607         _taxFee = 0;
608 
609     }
610 
611 
612 
613     function restoreAllFee() private {
614 
615         _redisFee = _previousredisFee;
616 
617         _taxFee = _previoustaxFee;
618 
619     }
620 
621 
622 
623     function _approve(
624 
625         address owner,
626 
627         address spender,
628 
629         uint256 amount
630 
631     ) private {
632 
633         require(owner != address(0), "ERC20: approve from the zero address");
634 
635         require(spender != address(0), "ERC20: approve to the zero address");
636 
637         _allowances[owner][spender] = amount;
638 
639         emit Approval(owner, spender, amount);
640 
641     }
642 
643 
644 
645     function _transfer(
646 
647         address from,
648 
649         address to,
650 
651         uint256 amount
652 
653     ) private {
654 
655         require(from != address(0), "ERC20: transfer from the zero address");
656 
657         require(to != address(0), "ERC20: transfer to the zero address");
658 
659         require(amount > 0, "Transfer amount must be greater than zero");
660 
661 
662 
663         if (from != owner() && to != owner()) {
664 
665 
666 
667             //Trade start check
668 
669             if (!tradingOpen) {
670 
671                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
672 
673             }
674 
675 
676 
677             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
678 
679             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
680 
681 
682 
683             if(to != uniswapV2Pair) {
684 
685                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
686 
687             }
688 
689 
690 
691             uint256 contractTokenBalance = balanceOf(address(this));
692 
693             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
694 
695 
696 
697             if(contractTokenBalance >= _maxTxAmount)
698 
699             {
700 
701                 contractTokenBalance = _maxTxAmount;
702 
703             }
704 
705 
706 
707             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
708 
709                 swapTokensForEth(contractTokenBalance);
710 
711                 uint256 contractETHBalance = address(this).balance;
712 
713                 if (contractETHBalance > 0) {
714 
715                     sendETHToFee(address(this).balance);
716 
717                 }
718 
719             }
720 
721         }
722 
723 
724 
725         bool takeFee = true;
726 
727 
728 
729         //Transfer Tokens
730 
731         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
732 
733             takeFee = false;
734 
735         } else {
736 
737 
738 
739             //Set Fee for Buys
740 
741             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
742 
743                 _redisFee = _redisFeeOnBuy;
744 
745                 _taxFee = _taxFeeOnBuy;
746 
747             }
748 
749 
750 
751             //Set Fee for Sells
752 
753             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
754 
755                 _redisFee = _redisFeeOnSell;
756 
757                 _taxFee = _taxFeeOnSell;
758 
759             }
760 
761 
762 
763         }
764 
765 
766 
767         _tokenTransfer(from, to, amount, takeFee);
768 
769     }
770 
771 
772 
773     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
774 
775         address[] memory path = new address[](2);
776 
777         path[0] = address(this);
778 
779         path[1] = uniswapV2Router.WETH();
780 
781         _approve(address(this), address(uniswapV2Router), tokenAmount);
782 
783         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
784 
785             tokenAmount,
786 
787             0,
788 
789             path,
790 
791             address(this),
792 
793             block.timestamp
794 
795         );
796 
797     }
798 
799 
800 
801     function sendETHToFee(uint256 amount) private {
802 
803         _marketingAddress.transfer(amount);
804 
805     }
806 
807 
808 
809     function setTrading(bool _tradingOpen) public onlyOwner {
810 
811         tradingOpen = _tradingOpen;
812 
813     }
814 
815 
816 
817     function manualswap() external {
818 
819         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
820 
821         uint256 contractBalance = balanceOf(address(this));
822 
823         swapTokensForEth(contractBalance);
824 
825     }
826 
827 
828 
829     function manualsend() external {
830 
831         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
832 
833         uint256 contractETHBalance = address(this).balance;
834 
835         sendETHToFee(contractETHBalance);
836 
837     }
838 
839 
840 
841     function blockBots(address[] memory bots_) public onlyOwner {
842 
843         for (uint256 i = 0; i < bots_.length; i++) {
844 
845             bots[bots_[i]] = true;
846 
847         }
848 
849     }
850 
851 
852 
853     function unblockBot(address notbot) public onlyOwner {
854 
855         bots[notbot] = false;
856 
857     }
858 
859 
860 
861     function _tokenTransfer(
862 
863         address sender,
864 
865         address recipient,
866 
867         uint256 amount,
868 
869         bool takeFee
870 
871     ) private {
872 
873         if (!takeFee) removeAllFee();
874 
875         _transferStandard(sender, recipient, amount);
876 
877         if (!takeFee) restoreAllFee();
878 
879     }
880 
881 
882 
883     function _transferStandard(
884 
885         address sender,
886 
887         address recipient,
888 
889         uint256 tAmount
890 
891     ) private {
892 
893         (
894 
895             uint256 rAmount,
896 
897             uint256 rTransferAmount,
898 
899             uint256 rFee,
900 
901             uint256 tTransferAmount,
902 
903             uint256 tFee,
904 
905             uint256 tTeam
906 
907         ) = _getValues(tAmount);
908 
909         _rOwned[sender] = _rOwned[sender].sub(rAmount);
910 
911         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
912 
913         _takeTeam(tTeam);
914 
915         _reflectFee(rFee, tFee);
916 
917         emit Transfer(sender, recipient, tTransferAmount);
918 
919     }
920 
921 
922 
923     function _takeTeam(uint256 tTeam) private {
924 
925         uint256 currentRate = _getRate();
926 
927         uint256 rTeam = tTeam.mul(currentRate);
928 
929         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
930 
931     }
932 
933 
934 
935     function _reflectFee(uint256 rFee, uint256 tFee) private {
936 
937         _rTotal = _rTotal.sub(rFee);
938 
939         _tFeeTotal = _tFeeTotal.add(tFee);
940 
941     }
942 
943 
944 
945     receive() external payable {}
946 
947 
948 
949     function _getValues(uint256 tAmount)
950 
951         private
952 
953         view
954 
955         returns (
956 
957             uint256,
958 
959             uint256,
960 
961             uint256,
962 
963             uint256,
964 
965             uint256,
966 
967             uint256
968 
969         )
970 
971     {
972 
973         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
974 
975             _getTValues(tAmount, _redisFee, _taxFee);
976 
977         uint256 currentRate = _getRate();
978 
979         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
980 
981             _getRValues(tAmount, tFee, tTeam, currentRate);
982 
983         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
984 
985     }
986 
987 
988 
989     function _getTValues(
990 
991         uint256 tAmount,
992 
993         uint256 redisFee,
994 
995         uint256 taxFee
996 
997     )
998 
999         private
1000 
1001         pure
1002 
1003         returns (
1004 
1005             uint256,
1006 
1007             uint256,
1008 
1009             uint256
1010 
1011         )
1012 
1013     {
1014 
1015         uint256 tFee = tAmount.mul(redisFee).div(100);
1016 
1017         uint256 tTeam = tAmount.mul(taxFee).div(100);
1018 
1019         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
1020 
1021         return (tTransferAmount, tFee, tTeam);
1022 
1023     }
1024 
1025 
1026 
1027     function _getRValues(
1028 
1029         uint256 tAmount,
1030 
1031         uint256 tFee,
1032 
1033         uint256 tTeam,
1034 
1035         uint256 currentRate
1036 
1037     )
1038 
1039         private
1040 
1041         pure
1042 
1043         returns (
1044 
1045             uint256,
1046 
1047             uint256,
1048 
1049             uint256
1050 
1051         )
1052 
1053     {
1054 
1055         uint256 rAmount = tAmount.mul(currentRate);
1056 
1057         uint256 rFee = tFee.mul(currentRate);
1058 
1059         uint256 rTeam = tTeam.mul(currentRate);
1060 
1061         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
1062 
1063         return (rAmount, rTransferAmount, rFee);
1064 
1065     }
1066 
1067 
1068 
1069     function _getRate() private view returns (uint256) {
1070 
1071         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1072 
1073         return rSupply.div(tSupply);
1074 
1075     }
1076 
1077 
1078 
1079     function _getCurrentSupply() private view returns (uint256, uint256) {
1080 
1081         uint256 rSupply = _rTotal;
1082 
1083         uint256 tSupply = _tTotal;
1084 
1085         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1086 
1087         return (rSupply, tSupply);
1088 
1089     }
1090 
1091 
1092 
1093     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
1094 
1095         _redisFeeOnBuy = redisFeeOnBuy;
1096 
1097         _redisFeeOnSell = redisFeeOnSell;
1098 
1099         _taxFeeOnBuy = taxFeeOnBuy;
1100 
1101         _taxFeeOnSell = taxFeeOnSell;
1102 
1103     }
1104 
1105 
1106 
1107     //Set minimum tokens required to swap.
1108 
1109     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
1110 
1111         _swapTokensAtAmount = swapTokensAtAmount;
1112 
1113     }
1114 
1115 
1116 
1117     //Set minimum tokens required to swap.
1118 
1119     function toggleSwap(bool _swapEnabled) public onlyOwner {
1120 
1121         swapEnabled = _swapEnabled;
1122 
1123     }
1124 
1125 
1126 
1127     //Set maximum transaction
1128 
1129     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
1130 
1131         _maxTxAmount = maxTxAmount;
1132 
1133     }
1134 
1135 
1136 
1137     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
1138 
1139         _maxWalletSize = maxWalletSize;
1140 
1141     }
1142 
1143 
1144 
1145     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
1146 
1147         for(uint256 i = 0; i < accounts.length; i++) {
1148 
1149             _isExcludedFromFee[accounts[i]] = excluded;
1150 
1151         }
1152 
1153     }
1154 
1155 
1156 
1157 }