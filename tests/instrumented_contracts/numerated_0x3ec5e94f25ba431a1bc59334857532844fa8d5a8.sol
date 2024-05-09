1 // File: Haoyu.sol
2 
3 /**
4 
5  “The universe is big, its vast and complicated, and ridiculous. 
6 
7  And sometimes, very rarely, impossible things just happen and we call them miracles. 
8 
9  And that's the theory. Nine hundred years, never seen one yet, but this would do me.”
10 
11 
12 
13  Haoyu ~ Vast Universe
14 
15 
16 
17 https://twitter.com/Haoyu_HAO
18 
19 
20 
21 
22 
23 */
24 
25 
26 pragma solidity ^0.8.9;
27 
28 
29 
30 abstract contract Context {
31 
32     function _msgSender() internal view virtual returns (address) {
33 
34         return msg.sender;
35 
36     }
37 
38 }
39 
40 
41 
42 interface IERC20 {
43 
44     function totalSupply() external view returns (uint256);
45 
46 
47 
48     function balanceOf(address account) external view returns (uint256);
49 
50 
51 
52     function transfer(address recipient, uint256 amount) external returns (bool);
53 
54 
55 
56     function allowance(address owner, address spender) external view returns (uint256);
57 
58 
59 
60     function approve(address spender, uint256 amount) external returns (bool);
61 
62 
63 
64     function transferFrom(
65 
66         address sender,
67 
68         address recipient,
69 
70         uint256 amount
71 
72     ) external returns (bool);
73 
74 
75 
76     event Transfer(address indexed from, address indexed to, uint256 value);
77 
78     event Approval(
79 
80         address indexed owner,
81 
82         address indexed spender,
83 
84         uint256 value
85 
86     );
87 
88 }
89 
90 
91 
92 contract Ownable is Context {
93 
94     address private _owner;
95 
96     address private _previousOwner;
97 
98     event OwnershipTransferred(
99 
100         address indexed previousOwner,
101 
102         address indexed newOwner
103 
104     );
105 
106 
107 
108     constructor() {
109 
110         address msgSender = _msgSender();
111 
112         _owner = msgSender;
113 
114         emit OwnershipTransferred(address(0), msgSender);
115 
116     }
117 
118 
119 
120     function owner() public view returns (address) {
121 
122         return _owner;
123 
124     }
125 
126 
127 
128     modifier onlyOwner() {
129 
130         require(_owner == _msgSender(), "Ownable: caller is not the owner");
131 
132         _;
133 
134     }
135 
136 
137 
138     function renounceOwnership() public virtual onlyOwner {
139 
140         emit OwnershipTransferred(_owner, address(0));
141 
142         _owner = address(0);
143 
144     }
145 
146 
147 
148     function transferOwnership(address newOwner) public virtual onlyOwner {
149 
150         require(newOwner != address(0), "Ownable: new owner is the zero address");
151 
152         emit OwnershipTransferred(_owner, newOwner);
153 
154         _owner = newOwner;
155 
156     }
157 
158 
159 
160 }
161 
162 
163 
164 library SafeMath {
165 
166     function add(uint256 a, uint256 b) internal pure returns (uint256) {
167 
168         uint256 c = a + b;
169 
170         require(c >= a, "SafeMath: addition overflow");
171 
172         return c;
173 
174     }
175 
176 
177 
178     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
179 
180         return sub(a, b, "SafeMath: subtraction overflow");
181 
182     }
183 
184 
185 
186     function sub(
187 
188         uint256 a,
189 
190         uint256 b,
191 
192         string memory errorMessage
193 
194     ) internal pure returns (uint256) {
195 
196         require(b <= a, errorMessage);
197 
198         uint256 c = a - b;
199 
200         return c;
201 
202     }
203 
204 
205 
206     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
207 
208         if (a == 0) {
209 
210             return 0;
211 
212         }
213 
214         uint256 c = a * b;
215 
216         require(c / a == b, "SafeMath: multiplication overflow");
217 
218         return c;
219 
220     }
221 
222 
223 
224     function div(uint256 a, uint256 b) internal pure returns (uint256) {
225 
226         return div(a, b, "SafeMath: division by zero");
227 
228     }
229 
230 
231 
232     function div(
233 
234         uint256 a,
235 
236         uint256 b,
237 
238         string memory errorMessage
239 
240     ) internal pure returns (uint256) {
241 
242         require(b > 0, errorMessage);
243 
244         uint256 c = a / b;
245 
246         return c;
247 
248     }
249 
250 }
251 
252 
253 
254 interface IUniswapV2Factory {
255 
256     function createPair(address tokenA, address tokenB)
257 
258         external
259 
260         returns (address pair);
261 
262 }
263 
264 
265 
266 interface IUniswapV2Router02 {
267 
268     function swapExactTokensForETHSupportingFeeOnTransferTokens(
269 
270         uint256 amountIn,
271 
272         uint256 amountOutMin,
273 
274         address[] calldata path,
275 
276         address to,
277 
278         uint256 deadline
279 
280     ) external;
281 
282 
283 
284     function factory() external pure returns (address);
285 
286 
287 
288     function WETH() external pure returns (address);
289 
290 
291 
292     function addLiquidityETH(
293 
294         address token,
295 
296         uint256 amountTokenDesired,
297 
298         uint256 amountTokenMin,
299 
300         uint256 amountETHMin,
301 
302         address to,
303 
304         uint256 deadline
305 
306     )
307 
308         external
309 
310         payable
311 
312         returns (
313 
314             uint256 amountToken,
315 
316             uint256 amountETH,
317 
318             uint256 liquidity
319 
320         );
321 
322 }
323 
324 
325 
326 contract Haoyu is Context, IERC20, Ownable {
327 
328 
329 
330     using SafeMath for uint256;
331 
332 
333 
334     string private constant _name = "Haoyu";
335 
336     string private constant _symbol = "HAO";
337 
338     uint8 private constant _decimals = 9;
339 
340 
341 
342     mapping(address => uint256) private _rOwned;
343 
344     mapping(address => uint256) private _tOwned;
345 
346     mapping(address => mapping(address => uint256)) private _allowances;
347 
348     mapping(address => bool) private _isExcludedFromFee;
349 
350     uint256 private constant MAX = ~uint256(0);
351 
352     uint256 private constant _tTotal = 1000000000 * 10**9;
353 
354     uint256 private _rTotal = (MAX - (MAX % _tTotal));
355 
356     uint256 private _tFeeTotal;
357 
358     uint256 private _redisFeeOnBuy = 0;
359 
360     uint256 private _taxFeeOnBuy = 5;
361 
362     uint256 private _redisFeeOnSell = 0;
363 
364     uint256 private _taxFeeOnSell = 5;
365 
366 
367 
368     //Original Fee
369 
370     uint256 private _redisFee = _redisFeeOnSell;
371 
372     uint256 private _taxFee = _taxFeeOnSell;
373 
374 
375 
376     uint256 private _previousredisFee = _redisFee;
377 
378     uint256 private _previoustaxFee = _taxFee;
379 
380 
381 
382     mapping(address => bool) public bots; mapping (address => uint256) public _buyMap;
383 
384     address payable private _developmentAddress = payable(0xd67d363182E44B2849F2A98570b7Ad03f1baf19b);
385 
386     address payable private _marketingAddress = payable(0xd67d363182E44B2849F2A98570b7Ad03f1baf19b);
387 
388 
389 
390     IUniswapV2Router02 public uniswapV2Router;
391 
392     address public uniswapV2Pair;
393 
394 
395 
396     bool private tradingOpen = true;
397 
398     bool private inSwap = false;
399 
400     bool private swapEnabled = true;
401 
402 
403 
404     uint256 public _maxTxAmount = 20000000 * 10**9;
405 
406     uint256 public _maxWalletSize = 20000000 * 10**9;
407 
408     uint256 public _swapTokensAtAmount = 10000 * 10**9;
409 
410 
411 
412     event MaxTxAmountUpdated(uint256 _maxTxAmount);
413 
414     modifier lockTheSwap {
415 
416         inSwap = true;
417 
418         _;
419 
420         inSwap = false;
421 
422     }
423 
424 
425 
426     constructor() {
427 
428 
429 
430         _rOwned[_msgSender()] = _rTotal;
431 
432 
433 
434         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//
435 
436         uniswapV2Router = _uniswapV2Router;
437 
438         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
439 
440             .createPair(address(this), _uniswapV2Router.WETH());
441 
442 
443 
444         _isExcludedFromFee[owner()] = true;
445 
446         _isExcludedFromFee[address(this)] = true;
447 
448         _isExcludedFromFee[_developmentAddress] = true;
449 
450         _isExcludedFromFee[_marketingAddress] = true;
451 
452 
453 
454         emit Transfer(address(0), _msgSender(), _tTotal);
455 
456     }
457 
458 
459 
460     function name() public pure returns (string memory) {
461 
462         return _name;
463 
464     }
465 
466 
467 
468     function symbol() public pure returns (string memory) {
469 
470         return _symbol;
471 
472     }
473 
474 
475 
476     function decimals() public pure returns (uint8) {
477 
478         return _decimals;
479 
480     }
481 
482 
483 
484     function totalSupply() public pure override returns (uint256) {
485 
486         return _tTotal;
487 
488     }
489 
490 
491 
492     function balanceOf(address account) public view override returns (uint256) {
493 
494         return tokenFromReflection(_rOwned[account]);
495 
496     }
497 
498 
499 
500     function transfer(address recipient, uint256 amount)
501 
502         public
503 
504         override
505 
506         returns (bool)
507 
508     {
509 
510         _transfer(_msgSender(), recipient, amount);
511 
512         return true;
513 
514     }
515 
516 
517 
518     function allowance(address owner, address spender)
519 
520         public
521 
522         view
523 
524         override
525 
526         returns (uint256)
527 
528     {
529 
530         return _allowances[owner][spender];
531 
532     }
533 
534 
535 
536     function approve(address spender, uint256 amount)
537 
538         public
539 
540         override
541 
542         returns (bool)
543 
544     {
545 
546         _approve(_msgSender(), spender, amount);
547 
548         return true;
549 
550     }
551 
552 
553 
554     function transferFrom(
555 
556         address sender,
557 
558         address recipient,
559 
560         uint256 amount
561 
562     ) public override returns (bool) {
563 
564         _transfer(sender, recipient, amount);
565 
566         _approve(
567 
568             sender,
569 
570             _msgSender(),
571 
572             _allowances[sender][_msgSender()].sub(
573 
574                 amount,
575 
576                 "ERC20: transfer amount exceeds allowance"
577 
578             )
579 
580         );
581 
582         return true;
583 
584     }
585 
586 
587 
588     function tokenFromReflection(uint256 rAmount)
589 
590         private
591 
592         view
593 
594         returns (uint256)
595 
596     {
597 
598         require(
599 
600             rAmount <= _rTotal,
601 
602             "Amount must be less than total reflections"
603 
604         );
605 
606         uint256 currentRate = _getRate();
607 
608         return rAmount.div(currentRate);
609 
610     }
611 
612 
613 
614     function removeAllFee() private {
615 
616         if (_redisFee == 0 && _taxFee == 0) return;
617 
618 
619 
620         _previousredisFee = _redisFee;
621 
622         _previoustaxFee = _taxFee;
623 
624 
625 
626         _redisFee = 0;
627 
628         _taxFee = 0;
629 
630     }
631 
632 
633 
634     function restoreAllFee() private {
635 
636         _redisFee = _previousredisFee;
637 
638         _taxFee = _previoustaxFee;
639 
640     }
641 
642 
643 
644     function _approve(
645 
646         address owner,
647 
648         address spender,
649 
650         uint256 amount
651 
652     ) private {
653 
654         require(owner != address(0), "ERC20: approve from the zero address");
655 
656         require(spender != address(0), "ERC20: approve to the zero address");
657 
658         _allowances[owner][spender] = amount;
659 
660         emit Approval(owner, spender, amount);
661 
662     }
663 
664 
665 
666     function _transfer(
667 
668         address from,
669 
670         address to,
671 
672         uint256 amount
673 
674     ) private {
675 
676         require(from != address(0), "ERC20: transfer from the zero address");
677 
678         require(to != address(0), "ERC20: transfer to the zero address");
679 
680         require(amount > 0, "Transfer amount must be greater than zero");
681 
682 
683 
684         if (from != owner() && to != owner()) {
685 
686 
687 
688             //Trade start check
689 
690             if (!tradingOpen) {
691 
692                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
693 
694             }
695 
696 
697 
698             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
699 
700             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
701 
702 
703 
704             if(to != uniswapV2Pair) {
705 
706                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
707 
708             }
709 
710 
711 
712             uint256 contractTokenBalance = balanceOf(address(this));
713 
714             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
715 
716 
717 
718             if(contractTokenBalance >= _maxTxAmount)
719 
720             {
721 
722                 contractTokenBalance = _maxTxAmount;
723 
724             }
725 
726 
727 
728             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
729 
730                 swapTokensForEth(contractTokenBalance);
731 
732                 uint256 contractETHBalance = address(this).balance;
733 
734                 if (contractETHBalance > 0) {
735 
736                     sendETHToFee(address(this).balance);
737 
738                 }
739 
740             }
741 
742         }
743 
744 
745 
746         bool takeFee = true;
747 
748 
749 
750         //Transfer Tokens
751 
752         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
753 
754             takeFee = false;
755 
756         } else {
757 
758 
759 
760             //Set Fee for Buys
761 
762             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
763 
764                 _redisFee = _redisFeeOnBuy;
765 
766                 _taxFee = _taxFeeOnBuy;
767 
768             }
769 
770 
771 
772             //Set Fee for Sells
773 
774             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
775 
776                 _redisFee = _redisFeeOnSell;
777 
778                 _taxFee = _taxFeeOnSell;
779 
780             }
781 
782 
783 
784         }
785 
786 
787 
788         _tokenTransfer(from, to, amount, takeFee);
789 
790     }
791 
792 
793 
794     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
795 
796         address[] memory path = new address[](2);
797 
798         path[0] = address(this);
799 
800         path[1] = uniswapV2Router.WETH();
801 
802         _approve(address(this), address(uniswapV2Router), tokenAmount);
803 
804         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
805 
806             tokenAmount,
807 
808             0,
809 
810             path,
811 
812             address(this),
813 
814             block.timestamp
815 
816         );
817 
818     }
819 
820 
821 
822     function sendETHToFee(uint256 amount) private {
823 
824         _marketingAddress.transfer(amount);
825 
826     }
827 
828 
829 
830     function setTrading(bool _tradingOpen) public onlyOwner {
831 
832         tradingOpen = _tradingOpen;
833 
834     }
835 
836 
837 
838     function manualswap() external {
839 
840         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
841 
842         uint256 contractBalance = balanceOf(address(this));
843 
844         swapTokensForEth(contractBalance);
845 
846     }
847 
848 
849 
850     function manualsend() external {
851 
852         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
853 
854         uint256 contractETHBalance = address(this).balance;
855 
856         sendETHToFee(contractETHBalance);
857 
858     }
859 
860 
861 
862     function blockBots(address[] memory bots_) public onlyOwner {
863 
864         for (uint256 i = 0; i < bots_.length; i++) {
865 
866             bots[bots_[i]] = true;
867 
868         }
869 
870     }
871 
872 
873 
874     function unblockBot(address notbot) public onlyOwner {
875 
876         bots[notbot] = false;
877 
878     }
879 
880 
881 
882     function _tokenTransfer(
883 
884         address sender,
885 
886         address recipient,
887 
888         uint256 amount,
889 
890         bool takeFee
891 
892     ) private {
893 
894         if (!takeFee) removeAllFee();
895 
896         _transferStandard(sender, recipient, amount);
897 
898         if (!takeFee) restoreAllFee();
899 
900     }
901 
902 
903 
904     function _transferStandard(
905 
906         address sender,
907 
908         address recipient,
909 
910         uint256 tAmount
911 
912     ) private {
913 
914         (
915 
916             uint256 rAmount,
917 
918             uint256 rTransferAmount,
919 
920             uint256 rFee,
921 
922             uint256 tTransferAmount,
923 
924             uint256 tFee,
925 
926             uint256 tTeam
927 
928         ) = _getValues(tAmount);
929 
930         _rOwned[sender] = _rOwned[sender].sub(rAmount);
931 
932         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
933 
934         _takeTeam(tTeam);
935 
936         _reflectFee(rFee, tFee);
937 
938         emit Transfer(sender, recipient, tTransferAmount);
939 
940     }
941 
942 
943 
944     function _takeTeam(uint256 tTeam) private {
945 
946         uint256 currentRate = _getRate();
947 
948         uint256 rTeam = tTeam.mul(currentRate);
949 
950         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
951 
952     }
953 
954 
955 
956     function _reflectFee(uint256 rFee, uint256 tFee) private {
957 
958         _rTotal = _rTotal.sub(rFee);
959 
960         _tFeeTotal = _tFeeTotal.add(tFee);
961 
962     }
963 
964 
965 
966     receive() external payable {}
967 
968 
969 
970     function _getValues(uint256 tAmount)
971 
972         private
973 
974         view
975 
976         returns (
977 
978             uint256,
979 
980             uint256,
981 
982             uint256,
983 
984             uint256,
985 
986             uint256,
987 
988             uint256
989 
990         )
991 
992     {
993 
994         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
995 
996             _getTValues(tAmount, _redisFee, _taxFee);
997 
998         uint256 currentRate = _getRate();
999 
1000         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
1001 
1002             _getRValues(tAmount, tFee, tTeam, currentRate);
1003 
1004         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
1005 
1006     }
1007 
1008 
1009 
1010     function _getTValues(
1011 
1012         uint256 tAmount,
1013 
1014         uint256 redisFee,
1015 
1016         uint256 taxFee
1017 
1018     )
1019 
1020         private
1021 
1022         pure
1023 
1024         returns (
1025 
1026             uint256,
1027 
1028             uint256,
1029 
1030             uint256
1031 
1032         )
1033 
1034     {
1035 
1036         uint256 tFee = tAmount.mul(redisFee).div(100);
1037 
1038         uint256 tTeam = tAmount.mul(taxFee).div(100);
1039 
1040         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
1041 
1042         return (tTransferAmount, tFee, tTeam);
1043 
1044     }
1045 
1046 
1047 
1048     function _getRValues(
1049 
1050         uint256 tAmount,
1051 
1052         uint256 tFee,
1053 
1054         uint256 tTeam,
1055 
1056         uint256 currentRate
1057 
1058     )
1059 
1060         private
1061 
1062         pure
1063 
1064         returns (
1065 
1066             uint256,
1067 
1068             uint256,
1069 
1070             uint256
1071 
1072         )
1073 
1074     {
1075 
1076         uint256 rAmount = tAmount.mul(currentRate);
1077 
1078         uint256 rFee = tFee.mul(currentRate);
1079 
1080         uint256 rTeam = tTeam.mul(currentRate);
1081 
1082         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
1083 
1084         return (rAmount, rTransferAmount, rFee);
1085 
1086     }
1087 
1088 
1089 
1090     function _getRate() private view returns (uint256) {
1091 
1092         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1093 
1094         return rSupply.div(tSupply);
1095 
1096     }
1097 
1098 
1099 
1100     function _getCurrentSupply() private view returns (uint256, uint256) {
1101 
1102         uint256 rSupply = _rTotal;
1103 
1104         uint256 tSupply = _tTotal;
1105 
1106         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1107 
1108         return (rSupply, tSupply);
1109 
1110     }
1111 
1112 
1113 
1114     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
1115 
1116         _redisFeeOnBuy = redisFeeOnBuy;
1117 
1118         _redisFeeOnSell = redisFeeOnSell;
1119 
1120         _taxFeeOnBuy = taxFeeOnBuy;
1121 
1122         _taxFeeOnSell = taxFeeOnSell;
1123 
1124     }
1125 
1126 
1127 
1128     //Set minimum tokens required to swap.
1129 
1130     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
1131 
1132         _swapTokensAtAmount = swapTokensAtAmount;
1133 
1134     }
1135 
1136 
1137 
1138     //Set minimum tokens required to swap.
1139 
1140     function toggleSwap(bool _swapEnabled) public onlyOwner {
1141 
1142         swapEnabled = _swapEnabled;
1143 
1144     }
1145 
1146 
1147 
1148     //Set maximum transaction
1149 
1150     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
1151 
1152         _maxTxAmount = maxTxAmount;
1153 
1154     }
1155 
1156 
1157 
1158     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
1159 
1160         _maxWalletSize = maxWalletSize;
1161 
1162     }
1163 
1164 
1165 
1166     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
1167 
1168         for(uint256 i = 0; i < accounts.length; i++) {
1169 
1170             _isExcludedFromFee[accounts[i]] = excluded;
1171 
1172         }
1173 
1174     }
1175 
1176 
1177 
1178 }