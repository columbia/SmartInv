1 /*
2 
3 4% Reflections Token
4 
5 ⭐️Twitter: https://twitter.com/everstarerc
6 Telegram:
7 ⭐️https://t.me/EverStarERC
8 Website:
9 ⭐️https://everstarerc.xyz/
10 
11 */
12 
13 pragma solidity ^0.8.9;
14 
15 
16 
17 abstract contract Context {
18 
19     function _msgSender() internal view virtual returns (address) {
20 
21         return msg.sender;
22 
23     }
24 
25 }
26 
27 
28 
29 interface IERC20 {
30 
31     function totalSupply() external view returns (uint256);
32 
33 
34 
35     function balanceOf(address account) external view returns (uint256);
36 
37 
38 
39     function transfer(address recipient, uint256 amount) external returns (bool);
40 
41 
42 
43     function allowance(address owner, address spender) external view returns (uint256);
44 
45 
46 
47     function approve(address spender, uint256 amount) external returns (bool);
48 
49 
50 
51     function transferFrom(
52 
53         address sender,
54 
55         address recipient,
56 
57         uint256 amount
58 
59     ) external returns (bool);
60 
61 
62 
63     event Transfer(address indexed from, address indexed to, uint256 value);
64 
65     event Approval(
66 
67         address indexed owner,
68 
69         address indexed spender,
70 
71         uint256 value
72 
73     );
74 
75 }
76 
77 
78 
79 contract Ownable is Context {
80 
81     address private _owner;
82 
83     address private _previousOwner;
84 
85     event OwnershipTransferred(
86 
87         address indexed previousOwner,
88 
89         address indexed newOwner
90 
91     );
92 
93 
94 
95     constructor() {
96 
97         address msgSender = _msgSender();
98 
99         _owner = msgSender;
100 
101         emit OwnershipTransferred(address(0), msgSender);
102 
103     }
104 
105 
106 
107     function owner() public view returns (address) {
108 
109         return _owner;
110 
111     }
112 
113 
114 
115     modifier onlyOwner() {
116 
117         require(_owner == _msgSender(), "Ownable: caller is not the owner");
118 
119         _;
120 
121     }
122 
123 
124 
125     function renounceOwnership() public virtual onlyOwner {
126 
127         emit OwnershipTransferred(_owner, address(0));
128 
129         _owner = address(0);
130 
131     }
132 
133 
134 
135     function transferOwnership(address newOwner) public virtual onlyOwner {
136 
137         require(newOwner != address(0), "Ownable: new owner is the zero address");
138 
139         emit OwnershipTransferred(_owner, newOwner);
140 
141         _owner = newOwner;
142 
143     }
144 
145 
146 
147 }
148 
149 
150 
151 library SafeMath {
152 
153     function add(uint256 a, uint256 b) internal pure returns (uint256) {
154 
155         uint256 c = a + b;
156 
157         require(c >= a, "SafeMath: addition overflow");
158 
159         return c;
160 
161     }
162 
163 
164 
165     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
166 
167         return sub(a, b, "SafeMath: subtraction overflow");
168 
169     }
170 
171 
172 
173     function sub(
174 
175         uint256 a,
176 
177         uint256 b,
178 
179         string memory errorMessage
180 
181     ) internal pure returns (uint256) {
182 
183         require(b <= a, errorMessage);
184 
185         uint256 c = a - b;
186 
187         return c;
188 
189     }
190 
191  
192 
193     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
194 
195         if (a == 0) {
196 
197             return 0;
198 
199         }
200 
201         uint256 c = a * b;
202 
203         require(c / a == b, "SafeMath: multiplication overflow");
204 
205         return c;
206 
207     }
208 
209 
210 
211     function div(uint256 a, uint256 b) internal pure returns (uint256) {
212 
213         return div(a, b, "SafeMath: division by zero");
214 
215     }
216 
217 
218 
219     function div(
220 
221         uint256 a,
222 
223         uint256 b,
224 
225         string memory errorMessage
226 
227     ) internal pure returns (uint256) {
228 
229         require(b > 0, errorMessage);
230 
231         uint256 c = a / b;
232 
233         return c;
234 
235     }
236 
237 }
238 
239 
240 
241 interface IUniswapV2Factory {
242 
243     function createPair(address tokenA, address tokenB)
244 
245         external
246 
247         returns (address pair);
248 
249 }
250 
251 
252 
253 interface IUniswapV2Router02 {
254 
255     function swapExactTokensForETHSupportingFeeOnTransferTokens(
256 
257         uint256 amountIn,
258 
259         uint256 amountOutMin,
260 
261         address[] calldata path,
262 
263         address to,
264 
265         uint256 deadline
266 
267     ) external;
268 
269 
270 
271     function factory() external pure returns (address);
272 
273 
274 
275     function WETH() external pure returns (address);
276 
277 
278 
279     function addLiquidityETH(
280 
281         address token,
282 
283         uint256 amountTokenDesired,
284 
285         uint256 amountTokenMin,
286 
287         uint256 amountETHMin,
288 
289         address to,
290 
291         uint256 deadline
292 
293     )
294 
295         external
296 
297         payable
298 
299         returns (
300 
301             uint256 amountToken,
302 
303             uint256 amountETH,
304 
305             uint256 liquidity
306 
307         );
308 
309 }
310 
311 
312 
313 contract everstar is Context, IERC20, Ownable {
314 
315 
316 
317     using SafeMath for uint256;
318 
319 
320 
321     string private constant _name = "Everstar";
322 
323     string private constant _symbol = "EVERSTAR";
324 
325     uint8 private constant _decimals = 9;
326 
327 
328 
329     mapping(address => uint256) private _rOwned;
330 
331     mapping(address => uint256) private _tOwned;
332 
333     mapping(address => mapping(address => uint256)) private _allowances;
334 
335     mapping(address => bool) private _isExcludedFromFee;
336 
337     uint256 private constant MAX = ~uint256(0);
338 
339     uint256 private constant _tTotal = 1000000000 * 10**9;
340 
341     uint256 private _rTotal = (MAX - (MAX % _tTotal));
342 
343     uint256 private _tFeeTotal;
344 
345     uint256 private _redisFeeOnBuy = 4;
346 
347     uint256 private _taxFeeOnBuy = 16;
348 
349     uint256 private _redisFeeOnSell = 4;
350 
351     uint256 private _taxFeeOnSell = 36;
352 
353 
354 
355     //Original Fee
356 
357     uint256 private _redisFee = _redisFeeOnSell;
358 
359     uint256 private _taxFee = _taxFeeOnSell;
360 
361 
362 
363     uint256 private _previousredisFee = _redisFee;
364 
365     uint256 private _previoustaxFee = _taxFee;
366 
367 
368 
369     mapping(address => bool) public bots; mapping (address => uint256) public _buyMap;
370 
371     address payable private _developmentAddress = payable(0xF2F5958ab737CC986f3c798AB9933E6A1e84A8e1);
372 
373     address payable private _marketingAddress = payable(0xF2F5958ab737CC986f3c798AB9933E6A1e84A8e1);
374 
375 
376 
377     IUniswapV2Router02 public uniswapV2Router;
378 
379     address public uniswapV2Pair;
380 
381 
382 
383     bool private tradingOpen = true;
384 
385     bool private inSwap = false;
386 
387     bool private swapEnabled = true;
388 
389 
390 
391     uint256 public _maxTxAmount = 20000000 * 10**9;
392 
393     uint256 public _maxWalletSize = 20000000 * 10**9;
394 
395     uint256 public _swapTokensAtAmount = 10000 * 10**9;
396 
397 
398 
399     event MaxTxAmountUpdated(uint256 _maxTxAmount);
400 
401     modifier lockTheSwap {
402 
403         inSwap = true;
404 
405         _;
406 
407         inSwap = false;
408 
409     }
410 
411 
412 
413     constructor() {
414 
415 
416 
417         _rOwned[_msgSender()] = _rTotal;
418 
419 
420 
421         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//
422 
423         uniswapV2Router = _uniswapV2Router;
424 
425         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
426 
427             .createPair(address(this), _uniswapV2Router.WETH());
428 
429 
430 
431         _isExcludedFromFee[owner()] = true;
432 
433         _isExcludedFromFee[address(this)] = true;
434 
435         _isExcludedFromFee[_developmentAddress] = true;
436 
437         _isExcludedFromFee[_marketingAddress] = true;
438 
439 
440 
441         emit Transfer(address(0), _msgSender(), _tTotal);
442 
443     }
444 
445 
446 
447     function name() public pure returns (string memory) {
448 
449         return _name;
450 
451     }
452 
453 
454 
455     function symbol() public pure returns (string memory) {
456 
457         return _symbol;
458 
459     }
460 
461 
462 
463     function decimals() public pure returns (uint8) {
464 
465         return _decimals;
466 
467     }
468 
469 
470 
471     function totalSupply() public pure override returns (uint256) {
472 
473         return _tTotal;
474 
475     }
476 
477 
478 
479     function balanceOf(address account) public view override returns (uint256) {
480 
481         return tokenFromReflection(_rOwned[account]);
482 
483     }
484 
485 
486 
487     function transfer(address recipient, uint256 amount)
488 
489         public
490 
491         override
492 
493         returns (bool)
494 
495     {
496 
497         _transfer(_msgSender(), recipient, amount);
498 
499         return true;
500 
501     }
502 
503 
504 
505     function allowance(address owner, address spender)
506 
507         public
508 
509         view
510 
511         override
512 
513         returns (uint256)
514 
515     {
516 
517         return _allowances[owner][spender];
518 
519     }
520 
521 
522 
523     function approve(address spender, uint256 amount)
524 
525         public
526 
527         override
528 
529         returns (bool)
530 
531     {
532 
533         _approve(_msgSender(), spender, amount);
534 
535         return true;
536 
537     }
538 
539 
540 
541     function transferFrom(
542 
543         address sender,
544 
545         address recipient,
546 
547         uint256 amount
548 
549     ) public override returns (bool) {
550 
551         _transfer(sender, recipient, amount);
552 
553         _approve(
554 
555             sender,
556 
557             _msgSender(),
558 
559             _allowances[sender][_msgSender()].sub(
560 
561                 amount,
562 
563                 "ERC20: transfer amount exceeds allowance"
564 
565             )
566 
567         );
568 
569         return true;
570 
571     }
572 
573 
574 
575     function tokenFromReflection(uint256 rAmount)
576 
577         private
578 
579         view
580 
581         returns (uint256)
582 
583     {
584 
585         require(
586 
587             rAmount <= _rTotal,
588 
589             "Amount must be less than total reflections"
590 
591         );
592 
593         uint256 currentRate = _getRate();
594 
595         return rAmount.div(currentRate);
596 
597     }
598 
599 
600 
601     function removeAllFee() private {
602 
603         if (_redisFee == 0 && _taxFee == 0) return;
604 
605 
606 
607         _previousredisFee = _redisFee;
608 
609         _previoustaxFee = _taxFee;
610 
611 
612 
613         _redisFee = 0;
614 
615         _taxFee = 0;
616 
617     }
618 
619 
620 
621     function restoreAllFee() private {
622 
623         _redisFee = _previousredisFee;
624 
625         _taxFee = _previoustaxFee;
626 
627     }
628 
629 
630 
631     function _approve(
632 
633         address owner,
634 
635         address spender,
636 
637         uint256 amount
638 
639     ) private {
640 
641         require(owner != address(0), "ERC20: approve from the zero address");
642 
643         require(spender != address(0), "ERC20: approve to the zero address");
644 
645         _allowances[owner][spender] = amount;
646 
647         emit Approval(owner, spender, amount);
648 
649     }
650 
651 
652 
653     function _transfer(
654 
655         address from,
656 
657         address to,
658 
659         uint256 amount
660 
661     ) private {
662 
663         require(from != address(0), "ERC20: transfer from the zero address");
664 
665         require(to != address(0), "ERC20: transfer to the zero address");
666 
667         require(amount > 0, "Transfer amount must be greater than zero");
668 
669 
670 
671         if (from != owner() && to != owner()) {
672 
673 
674 
675             //Trade start check
676 
677             if (!tradingOpen) {
678 
679                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
680 
681             }
682 
683 
684 
685             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
686 
687             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
688 
689 
690 
691             if(to != uniswapV2Pair) {
692 
693                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
694 
695             }
696 
697 
698 
699             uint256 contractTokenBalance = balanceOf(address(this));
700 
701             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
702 
703 
704 
705             if(contractTokenBalance >= _maxTxAmount)
706 
707             {
708 
709                 contractTokenBalance = _maxTxAmount;
710 
711             }
712 
713 
714 
715             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
716 
717                 swapTokensForEth(contractTokenBalance);
718 
719                 uint256 contractETHBalance = address(this).balance;
720 
721                 if (contractETHBalance > 0) {
722 
723                     sendETHToFee(address(this).balance);
724 
725                 }
726 
727             }
728 
729         }
730 
731 
732 
733         bool takeFee = true;
734 
735 
736 
737         //Transfer Tokens
738 
739         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
740 
741             takeFee = false;
742 
743         } else {
744 
745 
746 
747             //Set Fee for Buys
748 
749             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
750 
751                 _redisFee = _redisFeeOnBuy;
752 
753                 _taxFee = _taxFeeOnBuy;
754 
755             }
756 
757 
758 
759             //Set Fee for Sells
760 
761             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
762 
763                 _redisFee = _redisFeeOnSell;
764 
765                 _taxFee = _taxFeeOnSell;
766 
767             }
768 
769 
770 
771         }
772 
773 
774 
775         _tokenTransfer(from, to, amount, takeFee);
776 
777     }
778 
779 
780 
781     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
782 
783         address[] memory path = new address[](2);
784 
785         path[0] = address(this);
786 
787         path[1] = uniswapV2Router.WETH();
788 
789         _approve(address(this), address(uniswapV2Router), tokenAmount);
790 
791         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
792 
793             tokenAmount,
794 
795             0,
796 
797             path,
798 
799             address(this),
800 
801             block.timestamp
802 
803         );
804 
805     }
806 
807 
808 
809     function sendETHToFee(uint256 amount) private {
810 
811         _marketingAddress.transfer(amount);
812 
813     }
814 
815 
816 
817     function setTrading(bool _tradingOpen) public onlyOwner {
818 
819         tradingOpen = _tradingOpen;
820 
821     }
822 
823 
824 
825     function manualswap() external {
826 
827         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
828 
829         uint256 contractBalance = balanceOf(address(this));
830 
831         swapTokensForEth(contractBalance);
832 
833     }
834 
835 
836 
837     function manualsend() external {
838 
839         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
840 
841         uint256 contractETHBalance = address(this).balance;
842 
843         sendETHToFee(contractETHBalance);
844 
845     }
846 
847 
848 
849     function blockBots(address[] memory bots_) public onlyOwner {
850 
851         for (uint256 i = 0; i < bots_.length; i++) {
852 
853             bots[bots_[i]] = true;
854 
855         }
856 
857     }
858 
859 
860 
861     function unblockBot(address notbot) public onlyOwner {
862 
863         bots[notbot] = false;
864 
865     }
866 
867 
868 
869     function _tokenTransfer(
870 
871         address sender,
872 
873         address recipient,
874 
875         uint256 amount,
876 
877         bool takeFee
878 
879     ) private {
880 
881         if (!takeFee) removeAllFee();
882 
883         _transferStandard(sender, recipient, amount);
884 
885         if (!takeFee) restoreAllFee();
886 
887     }
888 
889 
890 
891     function _transferStandard(
892 
893         address sender,
894 
895         address recipient,
896 
897         uint256 tAmount
898 
899     ) private {
900 
901         (
902 
903             uint256 rAmount,
904 
905             uint256 rTransferAmount,
906 
907             uint256 rFee,
908 
909             uint256 tTransferAmount,
910 
911             uint256 tFee,
912 
913             uint256 tTeam
914 
915         ) = _getValues(tAmount);
916 
917         _rOwned[sender] = _rOwned[sender].sub(rAmount);
918 
919         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
920 
921         _takeTeam(tTeam);
922 
923         _reflectFee(rFee, tFee);
924 
925         emit Transfer(sender, recipient, tTransferAmount);
926 
927     }
928 
929 
930 
931     function _takeTeam(uint256 tTeam) private {
932 
933         uint256 currentRate = _getRate();
934 
935         uint256 rTeam = tTeam.mul(currentRate);
936 
937         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
938 
939     }
940 
941 
942 
943     function _reflectFee(uint256 rFee, uint256 tFee) private {
944 
945         _rTotal = _rTotal.sub(rFee);
946 
947         _tFeeTotal = _tFeeTotal.add(tFee);
948 
949     }
950 
951 
952 
953     receive() external payable {}
954 
955 
956 
957     function _getValues(uint256 tAmount)
958 
959         private
960 
961         view
962 
963         returns (
964 
965             uint256,
966 
967             uint256,
968 
969             uint256,
970 
971             uint256,
972 
973             uint256,
974 
975             uint256
976 
977         )
978 
979     {
980 
981         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
982 
983             _getTValues(tAmount, _redisFee, _taxFee);
984 
985         uint256 currentRate = _getRate();
986 
987         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
988 
989             _getRValues(tAmount, tFee, tTeam, currentRate);
990 
991         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
992 
993     }
994 
995 
996 
997     function _getTValues(
998 
999         uint256 tAmount,
1000 
1001         uint256 redisFee,
1002 
1003         uint256 taxFee
1004 
1005     )
1006 
1007         private
1008 
1009         pure
1010 
1011         returns (
1012 
1013             uint256,
1014 
1015             uint256,
1016 
1017             uint256
1018 
1019         )
1020 
1021     {
1022 
1023         uint256 tFee = tAmount.mul(redisFee).div(100);
1024 
1025         uint256 tTeam = tAmount.mul(taxFee).div(100);
1026 
1027         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
1028 
1029         return (tTransferAmount, tFee, tTeam);
1030 
1031     }
1032 
1033 
1034 
1035     function _getRValues(
1036 
1037         uint256 tAmount,
1038 
1039         uint256 tFee,
1040 
1041         uint256 tTeam,
1042 
1043         uint256 currentRate
1044 
1045     )
1046 
1047         private
1048 
1049         pure
1050 
1051         returns (
1052 
1053             uint256,
1054 
1055             uint256,
1056 
1057             uint256
1058 
1059         )
1060 
1061     {
1062 
1063         uint256 rAmount = tAmount.mul(currentRate);
1064 
1065         uint256 rFee = tFee.mul(currentRate);
1066 
1067         uint256 rTeam = tTeam.mul(currentRate);
1068 
1069         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
1070 
1071         return (rAmount, rTransferAmount, rFee);
1072 
1073     }
1074 
1075 
1076 
1077     function _getRate() private view returns (uint256) {
1078 
1079         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1080 
1081         return rSupply.div(tSupply);
1082 
1083     }
1084 
1085 
1086 
1087     function _getCurrentSupply() private view returns (uint256, uint256) {
1088 
1089         uint256 rSupply = _rTotal;
1090 
1091         uint256 tSupply = _tTotal;
1092 
1093         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1094 
1095         return (rSupply, tSupply);
1096 
1097     }
1098 
1099 
1100 
1101     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
1102 
1103         _redisFeeOnBuy = redisFeeOnBuy;
1104 
1105         _redisFeeOnSell = redisFeeOnSell;
1106 
1107         _taxFeeOnBuy = taxFeeOnBuy;
1108 
1109         _taxFeeOnSell = taxFeeOnSell;
1110 
1111     }
1112 
1113 
1114 
1115     //Set minimum tokens required to swap.
1116 
1117     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
1118 
1119         _swapTokensAtAmount = swapTokensAtAmount;
1120 
1121     }
1122 
1123 
1124 
1125     //Set minimum tokens required to swap.
1126 
1127     function toggleSwap(bool _swapEnabled) public onlyOwner {
1128 
1129         swapEnabled = _swapEnabled;
1130 
1131     }
1132 
1133 
1134 
1135     //Set maximum transaction
1136 
1137     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
1138 
1139         _maxTxAmount = maxTxAmount;
1140 
1141     }
1142 
1143 
1144 
1145     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
1146 
1147         _maxWalletSize = maxWalletSize;
1148 
1149     }
1150 
1151 
1152 
1153     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
1154 
1155         for(uint256 i = 0; i < accounts.length; i++) {
1156 
1157             _isExcludedFromFee[accounts[i]] = excluded;
1158 
1159         }
1160 
1161     }
1162 
1163 
1164 
1165 }