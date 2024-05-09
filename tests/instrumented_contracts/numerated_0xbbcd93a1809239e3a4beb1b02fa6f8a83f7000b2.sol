1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.11;
3 
4 interface IERC20 {
5     function totalSupply() external view returns (uint256);
6 
7     function balanceOf(address account) external view returns (uint256);
8 
9     function transfer(address to, uint256 amount) external returns (bool);
10 
11     function allowance(address owner, address spender)
12         external
13         view
14         returns (uint256);
15 
16     function approve(address spender, uint256 amount) external returns (bool);
17 
18     function transferFrom(
19         address from,
20         address to,
21         uint256 amount
22     ) external returns (bool);
23 
24     event Transfer(address indexed from, address indexed to, uint256 value);
25     event Approval(
26         address indexed owner,
27         address indexed spender,
28         uint256 value
29     );
30 }
31 
32 interface IERC20Metadata is IERC20 {
33     function name() external view returns (string memory);
34 
35     function symbol() external view returns (string memory);
36 
37     function decimals() external view returns (uint8);
38 }
39 
40 abstract contract Context {
41     function _msgSender() internal view virtual returns (address) {
42         return msg.sender;
43     }
44 
45     function _msgData() internal view virtual returns (bytes calldata) {
46         return msg.data;
47     }
48 }
49 
50 contract ERC20 is Context, IERC20, IERC20Metadata {
51     mapping(address => uint256) private _balances;
52 
53     mapping(address => mapping(address => uint256)) private _allowances;
54 
55     uint256 private _totalSupply;
56 
57     string private _name;
58     string private _symbol;
59 
60     constructor(string memory name_, string memory symbol_) {
61         _name = name_;
62         _symbol = symbol_;
63     }
64 
65     function name() public view virtual override returns (string memory) {
66         return _name;
67     }
68 
69     function symbol() public view virtual override returns (string memory) {
70         return _symbol;
71     }
72 
73     function decimals() public view virtual override returns (uint8) {
74         return 18;
75     }
76 
77     function totalSupply() public view virtual override returns (uint256) {
78         return _totalSupply;
79     }
80 
81     function balanceOf(address account)
82         public
83         view
84         virtual
85         override
86         returns (uint256)
87     {
88         return _balances[account];
89     }
90 
91     function transfer(address to, uint256 amount)
92         public
93         virtual
94         override
95         returns (bool)
96     {
97         address owner = _msgSender();
98         _transfer(owner, to, amount);
99         return true;
100     }
101 
102     function allowance(address owner, address spender)
103         public
104         view
105         virtual
106         override
107         returns (uint256)
108     {
109         return _allowances[owner][spender];
110     }
111 
112     function approve(address spender, uint256 amount)
113         public
114         virtual
115         override
116         returns (bool)
117     {
118         address owner = _msgSender();
119         _approve(owner, spender, amount);
120         return true;
121     }
122 
123     function transferFrom(
124         address from,
125         address to,
126         uint256 amount
127     ) public virtual override returns (bool) {
128         address spender = _msgSender();
129         _spendAllowance(from, spender, amount);
130         _transfer(from, to, amount);
131         return true;
132     }
133 
134     function increaseAllowance(address spender, uint256 addedValue)
135         public
136         virtual
137         returns (bool)
138     {
139         address owner = _msgSender();
140         _approve(owner, spender, _allowances[owner][spender] + addedValue);
141         return true;
142     }
143 
144     function decreaseAllowance(address spender, uint256 subtractedValue)
145         public
146         virtual
147         returns (bool)
148     {
149         address owner = _msgSender();
150         uint256 currentAllowance = _allowances[owner][spender];
151         require(
152             currentAllowance >= subtractedValue,
153             "ERC20: decreased allowance below zero"
154         );
155         unchecked {
156             _approve(owner, spender, currentAllowance - subtractedValue);
157         }
158 
159         return true;
160     }
161 
162     function _transfer(
163         address from,
164         address to,
165         uint256 amount
166     ) internal virtual {
167         require(from != address(0), "ERC20: transfer from the zero address");
168         require(to != address(0), "ERC20: transfer to the zero address");
169 
170         _beforeTokenTransfer(from, to, amount);
171 
172         uint256 fromBalance = _balances[from];
173         require(
174             fromBalance >= amount,
175             "ERC20: transfer amount exceeds balance"
176         );
177         unchecked {
178             _balances[from] = fromBalance - amount;
179         }
180         _balances[to] += amount;
181 
182         emit Transfer(from, to, amount);
183 
184         _afterTokenTransfer(from, to, amount);
185     }
186 
187     function _mint(address account, uint256 amount) internal virtual {
188         require(account != address(0), "ERC20: mint to the zero address");
189 
190         _beforeTokenTransfer(address(0), account, amount);
191 
192         _totalSupply += amount;
193         _balances[account] += amount;
194         emit Transfer(address(0), account, amount);
195 
196         _afterTokenTransfer(address(0), account, amount);
197     }
198 
199     function _burn(address account, uint256 amount) internal virtual {
200         require(account != address(0), "ERC20: burn from the zero address");
201 
202         _beforeTokenTransfer(account, address(0), amount);
203 
204         uint256 accountBalance = _balances[account];
205         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
206         unchecked {
207             _balances[account] = accountBalance - amount;
208         }
209         _totalSupply -= amount;
210 
211         emit Transfer(account, address(0), amount);
212 
213         _afterTokenTransfer(account, address(0), amount);
214     }
215 
216     function _approve(
217         address owner,
218         address spender,
219         uint256 amount
220     ) internal virtual {
221         require(owner != address(0), "ERC20: approve from the zero address");
222         require(spender != address(0), "ERC20: approve to the zero address");
223 
224         _allowances[owner][spender] = amount;
225         emit Approval(owner, spender, amount);
226     }
227 
228     function _spendAllowance(
229         address owner,
230         address spender,
231         uint256 amount
232     ) internal virtual {
233         uint256 currentAllowance = allowance(owner, spender);
234         if (currentAllowance != type(uint256).max) {
235             require(
236                 currentAllowance >= amount,
237                 "ERC20: insufficient allowance"
238             );
239             unchecked {
240                 _approve(owner, spender, currentAllowance - amount);
241             }
242         }
243     }
244 
245     function _beforeTokenTransfer(
246         address from,
247         address to,
248         uint256 amount
249     ) internal virtual {}
250 
251     function _afterTokenTransfer(
252         address from,
253         address to,
254         uint256 amount
255     ) internal virtual {}
256 }
257 
258 library SafeMath {
259     function tryAdd(uint256 a, uint256 b)
260         internal
261         pure
262         returns (bool, uint256)
263     {
264         unchecked {
265             uint256 c = a + b;
266             if (c < a) return (false, 0);
267             return (true, c);
268         }
269     }
270 
271     function trySub(uint256 a, uint256 b)
272         internal
273         pure
274         returns (bool, uint256)
275     {
276         unchecked {
277             if (b > a) return (false, 0);
278             return (true, a - b);
279         }
280     }
281 
282     function tryMul(uint256 a, uint256 b)
283         internal
284         pure
285         returns (bool, uint256)
286     {
287         unchecked {
288             if (a == 0) return (true, 0);
289             uint256 c = a * b;
290             if (c / a != b) return (false, 0);
291             return (true, c);
292         }
293     }
294 
295     function tryDiv(uint256 a, uint256 b)
296         internal
297         pure
298         returns (bool, uint256)
299     {
300         unchecked {
301             if (b == 0) return (false, 0);
302             return (true, a / b);
303         }
304     }
305 
306     function tryMod(uint256 a, uint256 b)
307         internal
308         pure
309         returns (bool, uint256)
310     {
311         unchecked {
312             if (b == 0) return (false, 0);
313             return (true, a % b);
314         }
315     }
316 
317     function add(uint256 a, uint256 b) internal pure returns (uint256) {
318         return a + b;
319     }
320 
321     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
322         return a - b;
323     }
324 
325     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
326         return a * b;
327     }
328 
329     function div(uint256 a, uint256 b) internal pure returns (uint256) {
330         return a / b;
331     }
332 
333     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
334         return a % b;
335     }
336 
337     function sub(
338         uint256 a,
339         uint256 b,
340         string memory errorMessage
341     ) internal pure returns (uint256) {
342         unchecked {
343             require(b <= a, errorMessage);
344             return a - b;
345         }
346     }
347 
348     function div(
349         uint256 a,
350         uint256 b,
351         string memory errorMessage
352     ) internal pure returns (uint256) {
353         unchecked {
354             require(b > 0, errorMessage);
355             return a / b;
356         }
357     }
358 
359     function mod(
360         uint256 a,
361         uint256 b,
362         string memory errorMessage
363     ) internal pure returns (uint256) {
364         unchecked {
365             require(b > 0, errorMessage);
366             return a % b;
367         }
368     }
369 }
370 
371 library Counters {
372     struct Counter {
373         uint256 _value;
374     }
375 
376     function current(Counter storage counter) internal view returns (uint256) {
377         return counter._value;
378     }
379 
380     function increment(Counter storage counter) internal {
381         unchecked {
382             counter._value += 1;
383         }
384     }
385 
386     function decrement(Counter storage counter) internal {
387         uint256 value = counter._value;
388         require(value > 0, "Counter: decrement overflow");
389         unchecked {
390             counter._value = value - 1;
391         }
392     }
393 
394     function reset(Counter storage counter) internal {
395         counter._value = 0;
396     }
397 }
398 
399 contract Ownable {
400     address private _owner;
401     address private _previousOwner;
402     event OwnershipTransferred(
403         address indexed previousOwner,
404         address indexed newOwner
405     );
406 
407     constructor() {
408         _owner = msg.sender;
409         emit OwnershipTransferred(address(0), _owner);
410     }
411 
412     function owner() public view returns (address) {
413         return _owner;
414     }
415 
416     modifier onlyOwner() {
417         require(_owner == msg.sender, "Ownable: caller is not the owner");
418         _;
419     }
420 
421     function renounceOwnership() public virtual onlyOwner {
422         emit OwnershipTransferred(_owner, address(0));
423         _owner = address(0);
424     }
425 }
426 
427 interface IUniswapV2Router02 {
428     function swapExactTokensForETHSupportingFeeOnTransferTokens(
429         uint256 amountIn,
430         uint256 amountOutMin,
431         address[] calldata path,
432         address to,
433         uint256 deadline
434     ) external;
435 
436     function swapExactETHForTokensSupportingFeeOnTransferTokens(
437         uint256 amountOutMin,
438         address[] calldata path,
439         address to,
440         uint256 deadline
441     ) external payable;
442 
443     function factory() external pure returns (address);
444 
445     function WETH() external pure returns (address);
446 
447     function addLiquidityETH(
448         address token,
449         uint256 amountTokenDesired,
450         uint256 amountTokenMin,
451         uint256 amountETHMin,
452         address to,
453         uint256 deadline
454     )
455         external
456         payable
457         returns (
458             uint256 amountToken,
459             uint256 amountETH,
460             uint256 liquidity
461         );
462 }
463 
464 interface IUniswapV2Factory {
465     function createPair(address tokenA, address tokenB)
466         external
467         returns (address pair);
468 }
469 
470 library SignedSafeMath {
471     function mul(int256 a, int256 b) internal pure returns (int256) {
472         return a * b;
473     }
474 
475     function div(int256 a, int256 b) internal pure returns (int256) {
476         return a / b;
477     }
478 
479     function sub(int256 a, int256 b) internal pure returns (int256) {
480         return a - b;
481     }
482 
483     function add(int256 a, int256 b) internal pure returns (int256) {
484         return a + b;
485     }
486 }
487 
488 library SafeCast {
489     function toUint224(uint256 value) internal pure returns (uint224) {
490         require(
491             value <= type(uint224).max,
492             "SafeCast: value doesn't fit in 224 bits"
493         );
494         return uint224(value);
495     }
496 
497     function toUint128(uint256 value) internal pure returns (uint128) {
498         require(
499             value <= type(uint128).max,
500             "SafeCast: value doesn't fit in 128 bits"
501         );
502         return uint128(value);
503     }
504 
505     function toUint96(uint256 value) internal pure returns (uint96) {
506         require(
507             value <= type(uint96).max,
508             "SafeCast: value doesn't fit in 96 bits"
509         );
510         return uint96(value);
511     }
512 
513     function toUint64(uint256 value) internal pure returns (uint64) {
514         require(
515             value <= type(uint64).max,
516             "SafeCast: value doesn't fit in 64 bits"
517         );
518         return uint64(value);
519     }
520 
521     function toUint32(uint256 value) internal pure returns (uint32) {
522         require(
523             value <= type(uint32).max,
524             "SafeCast: value doesn't fit in 32 bits"
525         );
526         return uint32(value);
527     }
528 
529     function toUint16(uint256 value) internal pure returns (uint16) {
530         require(
531             value <= type(uint16).max,
532             "SafeCast: value doesn't fit in 16 bits"
533         );
534         return uint16(value);
535     }
536 
537     function toUint8(uint256 value) internal pure returns (uint8) {
538         require(
539             value <= type(uint8).max,
540             "SafeCast: value doesn't fit in 8 bits"
541         );
542         return uint8(value);
543     }
544 
545     function toUint256(int256 value) internal pure returns (uint256) {
546         require(value >= 0, "SafeCast: value must be positive");
547         return uint256(value);
548     }
549 
550     function toInt128(int256 value) internal pure returns (int128) {
551         require(
552             value >= type(int128).min && value <= type(int128).max,
553             "SafeCast: value doesn't fit in 128 bits"
554         );
555         return int128(value);
556     }
557 
558     function toInt64(int256 value) internal pure returns (int64) {
559         require(
560             value >= type(int64).min && value <= type(int64).max,
561             "SafeCast: value doesn't fit in 64 bits"
562         );
563         return int64(value);
564     }
565 
566     function toInt32(int256 value) internal pure returns (int32) {
567         require(
568             value >= type(int32).min && value <= type(int32).max,
569             "SafeCast: value doesn't fit in 32 bits"
570         );
571         return int32(value);
572     }
573 
574     function toInt16(int256 value) internal pure returns (int16) {
575         require(
576             value >= type(int16).min && value <= type(int16).max,
577             "SafeCast: value doesn't fit in 16 bits"
578         );
579         return int16(value);
580     }
581 
582     function toInt8(int256 value) internal pure returns (int8) {
583         require(
584             value >= type(int8).min && value <= type(int8).max,
585             "SafeCast: value doesn't fit in 8 bits"
586         );
587         return int8(value);
588     }
589 
590     function toInt256(uint256 value) internal pure returns (int256) {
591         require(
592             value <= uint256(type(int256).max),
593             "SafeCast: value doesn't fit in an int256"
594         );
595         return int256(value);
596     }
597 }
598 
599 interface DividendPayingTokenInterface {
600     function dividendOf(address _owner) external view returns (uint256);
601 
602     function distributeDividends() external payable;
603 
604     function withdrawDividend() external;
605 
606     event DividendsDistributed(address indexed from, uint256 weiAmount);
607     event DividendWithdrawn(
608         address indexed to,
609         uint256 weiAmount,
610         address received
611     );
612 }
613 
614 interface DividendPayingTokenOptionalInterface {
615     function withdrawableDividendOf(address _owner)
616         external
617         view
618         returns (uint256);
619 
620     function withdrawnDividendOf(address _owner)
621         external
622         view
623         returns (uint256);
624 
625     function accumulativeDividendOf(address _owner)
626         external
627         view
628         returns (uint256);
629 }
630 
631 abstract contract DividendPayingToken is
632     ERC20,
633     DividendPayingTokenInterface,
634     DividendPayingTokenOptionalInterface
635 {
636     using SafeMath for uint256;
637     using SignedSafeMath for int256;
638     using SafeCast for uint256;
639     using SafeCast for int256;
640     uint256 internal constant magnitude = 2**128;
641 
642     uint256 internal magnifiedDividendPerShare;
643 
644     mapping(address => int256) internal magnifiedDividendCorrections;
645     mapping(address => uint256) internal withdrawnDividends;
646 
647     uint256 public totalDividendsDistributed;
648 
649     constructor(string memory _name, string memory _symbol)
650         ERC20(_name, _symbol)
651     {}
652 
653     receive() external payable {
654         distributeDividends();
655     }
656 
657     function distributeDividends() public payable override {
658         require(totalSupply() > 0);
659 
660         if (msg.value > 0) {
661             magnifiedDividendPerShare = magnifiedDividendPerShare.add(
662                 (msg.value).mul(magnitude) / totalSupply()
663             );
664             emit DividendsDistributed(msg.sender, msg.value);
665 
666             totalDividendsDistributed = totalDividendsDistributed.add(
667                 msg.value
668             );
669         }
670     }
671 
672     function withdrawDividend() public virtual override {
673         _withdrawDividendOfUser(payable(msg.sender), payable(msg.sender));
674     }
675 
676     function _withdrawDividendOfUser(address payable user, address payable to)
677         internal
678         returns (uint256)
679     {
680         uint256 _withdrawableDividend = withdrawableDividendOf(user);
681         if (_withdrawableDividend > 0) {
682             withdrawnDividends[user] = withdrawnDividends[user].add(
683                 _withdrawableDividend
684             );
685             emit DividendWithdrawn(user, _withdrawableDividend, to);
686             (bool success, ) = to.call{value: _withdrawableDividend}("");
687 
688             if (!success) {
689                 withdrawnDividends[user] = withdrawnDividends[user].sub(
690                     _withdrawableDividend
691                 );
692                 return 0;
693             }
694 
695             return _withdrawableDividend;
696         }
697 
698         return 0;
699     }
700 
701     function dividendOf(address _owner) public view override returns (uint256) {
702         return withdrawableDividendOf(_owner);
703     }
704 
705     function withdrawableDividendOf(address _owner)
706         public
707         view
708         override
709         returns (uint256)
710     {
711         return accumulativeDividendOf(_owner).sub(withdrawnDividends[_owner]);
712     }
713 
714     function withdrawnDividendOf(address _owner)
715         public
716         view
717         override
718         returns (uint256)
719     {
720         return withdrawnDividends[_owner];
721     }
722 
723     function accumulativeDividendOf(address _owner)
724         public
725         view
726         override
727         returns (uint256)
728     {
729         return
730             magnifiedDividendPerShare
731                 .mul(balanceOf(_owner))
732                 .toInt256()
733                 .add(magnifiedDividendCorrections[_owner])
734                 .toUint256() / magnitude;
735     }
736 
737     function _mint(address account, uint256 value) internal override {
738         super._mint(account, value);
739 
740         magnifiedDividendCorrections[account] = magnifiedDividendCorrections[
741             account
742         ].sub((magnifiedDividendPerShare.mul(value)).toInt256());
743     }
744 
745     function _burn(address account, uint256 value) internal override {
746         super._burn(account, value);
747         magnifiedDividendCorrections[account] = magnifiedDividendCorrections[
748             account
749         ].add((magnifiedDividendPerShare.mul(value)).toInt256());
750     }
751 
752     function _setBalance(address account, uint256 newBalance) internal {
753         uint256 currentBalance = balanceOf(account);
754 
755         if (newBalance > currentBalance) {
756             uint256 mintAmount = newBalance.sub(currentBalance);
757             _mint(account, mintAmount);
758         } else if (newBalance < currentBalance) {
759             uint256 burnAmount = currentBalance.sub(newBalance);
760             _burn(account, burnAmount);
761         }
762     }
763 
764     function getAccount(address _account)
765         public
766         view
767         returns (uint256 _withdrawableDividends, uint256 _withdrawnDividends)
768     {
769         _withdrawableDividends = withdrawableDividendOf(_account);
770         _withdrawnDividends = withdrawnDividends[_account];
771     }
772 }
773 
774 contract DiamondDividendTracker is DividendPayingToken, Ownable {
775     using SafeMath for uint256;
776     using Counters for Counters.Counter;
777 
778     Counters.Counter private tokenHoldersCount;
779     mapping(address => bool) private tokenHoldersMap;
780 
781     mapping(address => bool) public excludedFromDividends;
782 
783     uint256 public immutable minimumTokenBalanceForDividends;
784 
785     event ExcludeFromDividends(address indexed account);
786 
787     constructor()
788         DividendPayingToken(
789             "Diamond_Dividend_Tracker",
790             "Diamond_Dividend_Tracker"
791         )
792     {
793         minimumTokenBalanceForDividends = 10000 * 10**18;
794     }
795 
796     function decimals() public view virtual override returns (uint8) {
797         return 18;
798     }
799 
800     function _approve(
801         address,
802         address,
803         uint256
804     ) internal pure override {
805         require(false, "Diamond_Dividend_Tracker: No approvals allowed");
806     }
807 
808     function _transfer(
809         address,
810         address,
811         uint256
812     ) internal pure override {
813         require(false, "Diamond_Dividend_Tracker: No transfers allowed");
814     }
815 
816     function withdrawDividend() public pure override {
817         require(
818             false,
819             "Diamond_Dividend_Tracker: withdrawDividend disabled. Use the 'claim' function on the main Diamond contract."
820         );
821     }
822 
823     function excludeFromDividends(address account) external onlyOwner {
824         excludedFromDividends[account] = true;
825 
826         _setBalance(account, 0);
827 
828         if (tokenHoldersMap[account] == true) {
829             tokenHoldersMap[account] = false;
830             tokenHoldersCount.decrement();
831         }
832 
833         emit ExcludeFromDividends(account);
834     }
835 
836     function includeFromDividends(address account, uint256 balance)
837         external
838         onlyOwner
839     {
840         excludedFromDividends[account] = false;
841 
842         if (balance >= minimumTokenBalanceForDividends) {
843             _setBalance(account, balance);
844 
845             if (tokenHoldersMap[account] == false) {
846                 tokenHoldersMap[account] = true;
847                 tokenHoldersCount.increment();
848             }
849         }
850 
851         emit ExcludeFromDividends(account);
852     }
853 
854     function isExcludeFromDividends(address account)
855         external
856         view
857         onlyOwner
858         returns (bool)
859     {
860         return excludedFromDividends[account];
861     }
862 
863     function getNumberOfTokenHolders() external view returns (uint256) {
864         return tokenHoldersCount.current();
865     }
866 
867     function setBalance(address payable account, uint256 newBalance)
868         external
869         onlyOwner
870     {
871         if (excludedFromDividends[account]) {
872             return;
873         }
874 
875         if (newBalance >= minimumTokenBalanceForDividends) {
876             _setBalance(account, newBalance);
877 
878             if (tokenHoldersMap[account] == false) {
879                 tokenHoldersMap[account] = true;
880                 tokenHoldersCount.increment();
881             }
882         } else {
883             _setBalance(account, 0);
884 
885             if (tokenHoldersMap[account] == true) {
886                 tokenHoldersMap[account] = false;
887                 tokenHoldersCount.decrement();
888             }
889         }
890     }
891 
892     function processAccount(address account, address toAccount)
893         public
894         onlyOwner
895         returns (uint256)
896     {
897         uint256 amount = _withdrawDividendOfUser(
898             payable(account),
899             payable(toAccount)
900         );
901         return amount;
902     }
903 }
904 
905 contract Diamond is ERC20, Ownable {
906     using SafeMath for uint256;
907     using Counters for Counters.Counter;
908 
909     string private constant _name = "Diamond";
910     string private constant _symbol = "DIAMONDS";
911     uint8 private constant _decimals = 18;
912     uint256 private constant _tTotal = 1e12 * 10**18;
913 
914     IUniswapV2Router02 private uniswapV2Router =
915         IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
916     bool private tradingOpen = false;
917     uint256 private launchBlock = 0;
918     address private uniswapV2Pair;
919 
920     IERC20 private MyBagsInstance;
921     uint256 private minimumMyBagsToken = 1e8 * 10**18;
922     uint256 private privateSaleTimestamp;
923     uint256 private publicSaleTimestamp;
924 
925     mapping(address => bool) private automatedMarketMakerPairs;
926     mapping(address => bool) public isExcludeFromFee;
927     mapping(address => bool) public isBot;
928 
929     uint256 private walletLimitPercentage = 50;
930     mapping(address => bool) public isExludeFromWalletLimit;
931 
932     uint256 private baseBuyTax = 10;
933     uint256 public baseSellTax = 5;
934     uint256 public sellPercentageOfHolding = 20;
935     uint256 public minutesIntervalPerSell = 7200 minutes;
936     mapping(address => uint256) public initialSellTimestamp;
937 
938     uint256 private autoLP = 27;
939     uint256 private devFee = 40;
940     uint256 private marketingFee = 33;
941 
942     uint256 public minContractTokensToSwap = 2e9 * 10**18;
943     bool public swapAll = false;
944 
945     struct MinutesRangeTax {
946         uint256 from;
947         uint256 to;
948         uint256 tax;
949     }
950 
951     mapping(address => uint256) public initialBuyTimestamp;
952     mapping(uint8 => MinutesRangeTax) public minutesRangeTaxes;
953     uint8 public maxIndexMinutesRange;
954 
955     address private devWalletAddress;
956     address private marketingWalletAddress;
957 
958     DiamondDividendTracker public dividendTracker;
959     uint256 minimumTokenBalanceForDividends = 10000 * 10**18;
960     mapping(address => uint256) public lastTransfer;
961 
962     uint256 public pendingTokensForReward;
963     uint256 public minRewardTokensToSwap = 10000 * 10**18;
964 
965     uint256 public pendingEthReward;
966 
967     struct ClaimedEth {
968         uint256 ethAmount;
969         uint256 tokenAmount;
970         uint256 timestamp;
971     }
972 
973     Counters.Counter private claimedHistoryIds;
974 
975     mapping(uint256 => ClaimedEth) private claimedEthMap;
976     mapping(address => uint256[]) private userClaimedIds;
977 
978     event BuyFees(address from, address to, uint256 amountTokens);
979     event SellFees(address from, address to, uint256 amountTokens);
980     event AddLiquidity(uint256 amountTokens, uint256 amountEth);
981     event SwapTokensForEth(uint256 sentTokens, uint256 receivedEth);
982     event SwapEthForTokens(uint256 sentEth, uint256 receivedTokens);
983     event DistributeFees(uint256 devEth, uint256 remarketingEth);
984     event AddRewardPool(uint256 _ethAmount);
985 
986     event SendDividends(uint256 amount);
987 
988     event DividendClaimed(
989         uint256 ethAmount,
990         uint256 tokenAmount,
991         address account
992     );
993 
994     constructor(
995         address _devWalletAddress,
996         address _marketingWalletAddress,
997         address _myBagsTokenAddress
998     ) ERC20(_name, _symbol) {
999         devWalletAddress = _devWalletAddress;
1000         marketingWalletAddress = _marketingWalletAddress;
1001 
1002         MyBagsInstance = IERC20(_myBagsTokenAddress);
1003 
1004         isExcludeFromFee[owner()] = true;
1005         isExcludeFromFee[address(this)] = true;
1006         isExludeFromWalletLimit[owner()] = true;
1007         isExludeFromWalletLimit[address(this)] = true;
1008         isExludeFromWalletLimit[address(uniswapV2Router)] = true;
1009 
1010         dividendTracker = new DiamondDividendTracker();
1011         dividendTracker.excludeFromDividends(address(dividendTracker));
1012         dividendTracker.excludeFromDividends(address(this));
1013         dividendTracker.excludeFromDividends(owner());
1014         dividendTracker.excludeFromDividends(address(uniswapV2Router));
1015         minutesRangeTaxes[1].from = 0 minutes;
1016         minutesRangeTaxes[1].to = 7200 minutes;
1017         minutesRangeTaxes[1].tax = 30;
1018         minutesRangeTaxes[2].from = 7200 minutes;
1019         minutesRangeTaxes[2].to = 14400 minutes;
1020         minutesRangeTaxes[2].tax = 25;
1021         minutesRangeTaxes[3].from = 14400 minutes;
1022         minutesRangeTaxes[3].to = 21600 minutes;
1023         minutesRangeTaxes[3].tax = 20;
1024         minutesRangeTaxes[4].from = 21600 minutes;
1025         minutesRangeTaxes[4].to = 28800 minutes;
1026         minutesRangeTaxes[4].tax = 15;
1027 
1028         maxIndexMinutesRange = 4;
1029 
1030         _mint(owner(), _tTotal);
1031     }
1032 
1033     function openTrading(uint256 _launchTime, uint256 _minutesForPrivateSale)
1034         external
1035         onlyOwner
1036     {
1037         require(!tradingOpen, "Diamond: Trading is already open");
1038         require(_launchTime > block.timestamp, "Diamond: Invalid timestamp");
1039         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(
1040                 address(this),
1041                 uniswapV2Router.WETH()
1042             );
1043 
1044         automatedMarketMakerPairs[uniswapV2Pair] = true;
1045         dividendTracker.excludeFromDividends(uniswapV2Pair);
1046 
1047         addLiquidity(balanceOf(address(this)), address(this).balance);
1048         IERC20(uniswapV2Pair).approve(
1049             address(uniswapV2Router),
1050             type(uint256).max
1051         );
1052 
1053         tradingOpen = true;
1054         privateSaleTimestamp = _launchTime;
1055         publicSaleTimestamp = _launchTime.add(
1056             _minutesForPrivateSale.mul(1 minutes)
1057         );
1058         launchBlock = block.number;
1059     }
1060 
1061     function manualSwap() external onlyOwner {
1062         uint256 totalTokens = balanceOf(address(this)).sub(
1063             pendingTokensForReward
1064         );
1065 
1066         swapTokensForEth(totalTokens);
1067     }
1068 
1069     function manualSend() external onlyOwner {
1070         uint256 totalEth = address(this).balance.sub(pendingEthReward);
1071 
1072         uint256 devFeesToSend = totalEth.mul(devFee).div(
1073             uint256(100).sub(autoLP)
1074         );
1075         uint256 marketingFeesToSend = totalEth.mul(marketingFee).div(
1076             uint256(100).sub(autoLP)
1077         );
1078         uint256 remainingEthForFees = totalEth.sub(devFeesToSend).sub(
1079             marketingFeesToSend
1080         );
1081         devFeesToSend = devFeesToSend.add(remainingEthForFees);
1082 
1083         sendEthToWallets(devFeesToSend, marketingFeesToSend);
1084     }
1085 
1086     function getTax(address _ad) public view returns (uint256) {
1087         uint256 tax = baseSellTax;
1088 
1089         for (uint8 x = 1; x <= maxIndexMinutesRange; x++) {
1090             if (
1091                 (initialBuyTimestamp[_ad] + minutesRangeTaxes[x].from <=
1092                     block.timestamp &&
1093                     initialBuyTimestamp[_ad] + minutesRangeTaxes[x].to >=
1094                     block.timestamp)
1095             ) {
1096                 tax = minutesRangeTaxes[x].tax;
1097                 return tax;
1098             }
1099         }
1100 
1101         return tax;
1102     }
1103 
1104     function getTotalDividendsDistributed() external view returns (uint256) {
1105         return dividendTracker.totalDividendsDistributed();
1106     }
1107 
1108     function withdrawableDividendOf(address _account)
1109         public
1110         view
1111         returns (uint256)
1112     {
1113         return dividendTracker.withdrawableDividendOf(_account);
1114     }
1115 
1116     function dividendTokenBalanceOf(address _account)
1117         public
1118         view
1119         returns (uint256)
1120     {
1121         return dividendTracker.balanceOf(_account);
1122     }
1123 
1124     function claim() external {
1125         _claim(payable(msg.sender), false);
1126     }
1127 
1128     function reinvest() external {
1129         _claim(payable(msg.sender), true);
1130     }
1131 
1132     function _claim(address payable _account, bool _reinvest) private {
1133         uint256 withdrawableAmount = dividendTracker.withdrawableDividendOf(
1134             _account
1135         );
1136         require(
1137             withdrawableAmount > 0,
1138             "Diamond: Claimer has no withdrawable dividend"
1139         );
1140         uint256 ethAmount;
1141         uint256 tokenAmount;
1142 
1143         if (!_reinvest) {
1144             ethAmount = dividendTracker.processAccount(_account, _account);
1145         } else {
1146             ethAmount = dividendTracker.processAccount(_account, address(this));
1147             if (ethAmount > 0) {
1148                 tokenAmount = swapEthForTokens(ethAmount, _account);
1149             }
1150         }
1151         if (ethAmount > 0) {
1152             claimedHistoryIds.increment();
1153             uint256 hId = claimedHistoryIds.current();
1154             claimedEthMap[hId].ethAmount = ethAmount;
1155             claimedEthMap[hId].tokenAmount = tokenAmount;
1156             claimedEthMap[hId].timestamp = block.timestamp;
1157 
1158             userClaimedIds[_account].push(hId);
1159 
1160             emit DividendClaimed(ethAmount, tokenAmount, _account);
1161         }
1162     }
1163 
1164     function getNumberOfDividendTokenHolders() external view returns (uint256) {
1165         return dividendTracker.getNumberOfTokenHolders();
1166     }
1167 
1168     function getAccount(address _account)
1169         public
1170         view
1171         returns (
1172             uint256 withdrawableDividends,
1173             uint256 withdrawnDividends,
1174             uint256 balance
1175         )
1176     {
1177         (withdrawableDividends, withdrawnDividends) = dividendTracker
1178             .getAccount(_account);
1179         return (withdrawableDividends, withdrawnDividends, balanceOf(_account));
1180     }
1181 
1182     function decimals() public view virtual override returns (uint8) {
1183         return _decimals;
1184     }
1185 
1186     function _transfer(
1187         address _from,
1188         address _to,
1189         uint256 _amount
1190     ) internal virtual override {
1191         require(!isBot[_from] && !isBot[_to]);
1192 
1193         uint256 transferAmount = _amount;
1194         uint256 prevWalletLimit = walletLimitPercentage;
1195         if (
1196             tradingOpen &&
1197             (automatedMarketMakerPairs[_from] ||
1198                 automatedMarketMakerPairs[_to]) &&
1199             !isExcludeFromFee[_from] &&
1200             !isExcludeFromFee[_to]
1201         ) {
1202             require(
1203                 privateSaleTimestamp <= block.timestamp,
1204                 "Diamond: Private and public sale is not open"
1205             );
1206             if (
1207                 privateSaleTimestamp <= block.timestamp &&
1208                 publicSaleTimestamp > block.timestamp
1209             ) {
1210                 walletLimitPercentage = 10;
1211                 require(
1212                     MyBagsInstance.balanceOf(_to) >= minimumMyBagsToken,
1213                     "Diamond: Not enough $MyBagsToken"
1214                 );
1215             }
1216             transferAmount = takeFees(_from, _to, _amount);
1217         }
1218         if (initialBuyTimestamp[_to] == 0) {
1219             initialBuyTimestamp[_to] = block.timestamp;
1220         }
1221         if (!automatedMarketMakerPairs[_to] && !isExludeFromWalletLimit[_to]) {
1222             uint256 addressBalance = balanceOf(_to).add(transferAmount);
1223             require(
1224                 addressBalance <=
1225                     totalSupply().mul(walletLimitPercentage).div(10000),
1226                 "Diamond: Wallet balance limit reached"
1227             );
1228         }
1229 
1230         super._transfer(_from, _to, transferAmount);
1231         walletLimitPercentage = prevWalletLimit;
1232         if (!dividendTracker.isExcludeFromDividends(_from)) {
1233             try
1234                 dividendTracker.setBalance(payable(_from), balanceOf(_from))
1235             {} catch {}
1236         }
1237         if (!dividendTracker.isExcludeFromDividends(_to)) {
1238             try
1239                 dividendTracker.setBalance(payable(_to), balanceOf(_to))
1240             {} catch {}
1241         }
1242     }
1243 
1244     function _setAutomatedMarketMakerPair(address _pair, bool _value) private {
1245         require(
1246             automatedMarketMakerPairs[_pair] != _value,
1247             "Diamond: Automated market maker pair is already set to that value"
1248         );
1249         automatedMarketMakerPairs[_pair] = _value;
1250 
1251         if (_value) {
1252             dividendTracker.excludeFromDividends(_pair);
1253         }
1254     }
1255 
1256     function setMinimumMyBagsToken(uint256 _minimumMyBagsToken)
1257         external
1258         onlyOwner
1259     {
1260         minimumMyBagsToken = _minimumMyBagsToken;
1261     }
1262 
1263     function setExcludeFromFee(address _address, bool _isExludeFromFee)
1264         external
1265         onlyOwner
1266     {
1267         isExcludeFromFee[_address] = _isExludeFromFee;
1268     }
1269 
1270     function setExludeFromDividends(
1271         address _address,
1272         bool _isExludeFromDividends
1273     ) external onlyOwner {
1274         if (_isExludeFromDividends) {
1275             dividendTracker.excludeFromDividends(_address);
1276         } else {
1277             dividendTracker.includeFromDividends(_address, balanceOf(_address));
1278         }
1279     }
1280 
1281     function setExludeFromWalletLimit(
1282         address _address,
1283         bool _isExludeFromWalletLimit
1284     ) external onlyOwner {
1285         isExludeFromWalletLimit[_address] = _isExludeFromWalletLimit;
1286     }
1287 
1288     function setWalletLimitPercentage(uint256 _percentage) external onlyOwner {
1289         walletLimitPercentage = _percentage;
1290     }
1291 
1292     function setTaxes(
1293         uint256 _baseBuyTax,
1294         uint256 _baseSellTax,
1295         uint256 _autoLP,
1296         uint256 _devFee,
1297         uint256 _marketingFee
1298     ) external onlyOwner {
1299         require(_baseBuyTax <= 10 && baseSellTax <= 5);
1300 
1301         baseBuyTax = _baseBuyTax;
1302         baseSellTax = _baseSellTax;
1303         autoLP = _autoLP;
1304         devFee = _devFee;
1305         marketingFee = _marketingFee;
1306     }
1307 
1308     function setMinContractTokensToSwap(uint256 _numToken) public onlyOwner {
1309         minContractTokensToSwap = _numToken;
1310     }
1311 
1312     function setMinRewardTokensToSwap(uint256 _numToken) public onlyOwner {
1313         minRewardTokensToSwap = _numToken;
1314     }
1315 
1316     function setSwapAll(bool _isWapAll) public onlyOwner {
1317         swapAll = _isWapAll;
1318     }
1319 
1320     function setMinutesRangeTax(
1321         uint8 _index,
1322         uint256 _from,
1323         uint256 _to,
1324         uint256 _tax
1325     ) external onlyOwner {
1326         minutesRangeTaxes[_index].from = _from.mul(1 minutes);
1327         minutesRangeTaxes[_index].to = _to.mul(1 minutes);
1328         minutesRangeTaxes[_index].tax = _tax;
1329     }
1330 
1331     function setMaxIndexMinutesRange(uint8 _maxIndex) external onlyOwner {
1332         maxIndexMinutesRange = _maxIndex;
1333     }
1334 
1335     function setPercentageOfHolding(
1336         uint256 _sellPercentageOfHolding,
1337         uint256 _minutesIntervalPerSell
1338     ) external onlyOwner {
1339         sellPercentageOfHolding = _sellPercentageOfHolding;
1340         minutesIntervalPerSell = _minutesIntervalPerSell.mul(1 minutes);
1341     }
1342 
1343     function setBots(address[] calldata _bots) public onlyOwner {
1344         for (uint256 i = 0; i < _bots.length; i++) {
1345             if (
1346                 _bots[i] != uniswapV2Pair &&
1347                 _bots[i] != address(uniswapV2Router)
1348             ) {
1349                 isBot[_bots[i]] = true;
1350             }
1351         }
1352     }
1353 
1354     function setWalletAddress(address _devWallet, address _marketingWallet)
1355         external
1356         onlyOwner
1357     {
1358         devWalletAddress = _devWallet;
1359         marketingWalletAddress = _marketingWallet;
1360     }
1361 
1362     function takeFees(
1363         address _from,
1364         address _to,
1365         uint256 _amount
1366     ) private returns (uint256) {
1367         uint256 fees;
1368         uint256 remainingAmount;
1369         require(
1370             automatedMarketMakerPairs[_from] || automatedMarketMakerPairs[_to],
1371             "Diamond: No market makers found"
1372         );
1373 
1374         if (automatedMarketMakerPairs[_from]) {
1375             fees = _amount.mul(baseBuyTax).div(100);
1376             remainingAmount = _amount.sub(fees);
1377 
1378             super._transfer(_from, address(this), fees);
1379 
1380             emit BuyFees(_from, address(this), fees);
1381         } else {
1382             uint256 totalSellTax;
1383             if (isExcludeByInitialSell(_from, _amount)) {
1384                 totalSellTax = baseSellTax;
1385             } else {
1386                 totalSellTax = getTax(_from);
1387             }
1388 
1389             fees = _amount.mul(totalSellTax).div(100);
1390             uint256 rewardTokens = _amount
1391                 .mul(totalSellTax.sub(baseSellTax))
1392                 .div(100);
1393             pendingTokensForReward = pendingTokensForReward.add(rewardTokens);
1394 
1395             remainingAmount = _amount.sub(fees);
1396 
1397             super._transfer(_from, address(this), fees);
1398             uint256 tokensToSwap = balanceOf(address(this)).sub(
1399                 pendingTokensForReward
1400             );
1401 
1402             if (tokensToSwap > minContractTokensToSwap) {
1403                 if (!swapAll) {
1404                     tokensToSwap = minContractTokensToSwap;
1405                 }
1406 
1407                 distributeTokensEth(tokensToSwap);
1408             }
1409             if (pendingTokensForReward > minRewardTokensToSwap) {
1410                 swapAndSendDividends(pendingTokensForReward);
1411             }
1412 
1413             emit SellFees(_from, address(this), fees);
1414         }
1415 
1416         return remainingAmount;
1417     }
1418 
1419     function distributeTokensEth(uint256 _tokenAmount) private {
1420         uint256 tokensForLiquidity = _tokenAmount.mul(autoLP).div(100);
1421 
1422         uint256 halfLiquidity = tokensForLiquidity.div(2);
1423         uint256 tokensForSwap = _tokenAmount.sub(halfLiquidity);
1424 
1425         uint256 totalEth = swapTokensForEth(tokensForSwap);
1426 
1427         uint256 ethForAddLP = totalEth.mul(autoLP).div(100);
1428         uint256 devFeesToSend = totalEth.mul(devFee).div(100);
1429         uint256 marketingFeesToSend = totalEth.mul(marketingFee).div(100);
1430         uint256 remainingEthForFees = totalEth
1431             .sub(ethForAddLP)
1432             .sub(devFeesToSend)
1433             .sub(marketingFeesToSend);
1434         devFeesToSend = devFeesToSend.add(remainingEthForFees);
1435 
1436         sendEthToWallets(devFeesToSend, marketingFeesToSend);
1437 
1438         if (halfLiquidity > 0 && ethForAddLP > 0) {
1439             addLiquidity(halfLiquidity, ethForAddLP);
1440         }
1441     }
1442 
1443     function sendEthToWallets(uint256 _devFees, uint256 _marketingFees)
1444         private
1445     {
1446         if (_devFees > 0) {
1447             payable(devWalletAddress).transfer(_devFees);
1448         }
1449         if (_marketingFees > 0) {
1450             payable(marketingWalletAddress).transfer(_marketingFees);
1451         }
1452         emit DistributeFees(_devFees, _marketingFees);
1453     }
1454 
1455     function swapTokensForEth(uint256 _tokenAmount) private returns (uint256) {
1456         uint256 initialEthBalance = address(this).balance;
1457         address[] memory path = new address[](2);
1458         path[0] = address(this);
1459         path[1] = uniswapV2Router.WETH();
1460         _approve(address(this), address(uniswapV2Router), _tokenAmount);
1461         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1462             _tokenAmount,
1463             0,
1464             path,
1465             address(this),
1466             block.timestamp
1467         );
1468 
1469         uint256 receivedEth = address(this).balance.sub(initialEthBalance);
1470 
1471         emit SwapTokensForEth(_tokenAmount, receivedEth);
1472         return receivedEth;
1473     }
1474 
1475     function swapEthForTokens(uint256 _ethAmount, address _to)
1476         private
1477         returns (uint256)
1478     {
1479         uint256 initialTokenBalance = balanceOf(address(this));
1480         address[] memory path = new address[](2);
1481         path[0] = uniswapV2Router.WETH();
1482         path[1] = address(this);
1483 
1484         uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{
1485             value: _ethAmount
1486         }(0, path, _to, block.timestamp);
1487 
1488         uint256 receivedTokens = balanceOf(address(this)).sub(
1489             initialTokenBalance
1490         );
1491 
1492         emit SwapEthForTokens(_ethAmount, receivedTokens);
1493         return receivedTokens;
1494     }
1495 
1496     function addLiquidity(uint256 _tokenAmount, uint256 _ethAmount) private {
1497         _approve(address(this), address(uniswapV2Router), _tokenAmount);
1498         uniswapV2Router.addLiquidityETH{value: _ethAmount}(
1499             address(this),
1500             _tokenAmount,
1501             0,
1502             0,
1503             owner(),
1504             block.timestamp
1505         );
1506         emit AddLiquidity(_tokenAmount, _ethAmount);
1507     }
1508 
1509     function swapAndSendDividends(uint256 _tokenAmount) private {
1510         uint256 dividends = swapTokensForEth(_tokenAmount);
1511 
1512         pendingTokensForReward = pendingTokensForReward.sub(_tokenAmount);
1513         uint256 totalEthToSend = dividends.add(pendingEthReward);
1514 
1515         (bool success, ) = address(dividendTracker).call{value: totalEthToSend}(
1516             ""
1517         );
1518 
1519         if (success) {
1520             emit SendDividends(dividends);
1521         } else {
1522             pendingEthReward = pendingEthReward.add(dividends);
1523         }
1524     }
1525 
1526     function isExcludeByInitialSell(address _ad, uint256 _tokenAmount)
1527         private
1528         returns (bool)
1529     {
1530         if (
1531             initialSellTimestamp[_ad] + minutesIntervalPerSell <=
1532             block.timestamp
1533         ) {
1534             initialSellTimestamp[_ad] = block.timestamp;
1535             if (
1536                 _tokenAmount <=
1537                 balanceOf(_ad).mul(sellPercentageOfHolding).div(100)
1538             ) {
1539                 return true;
1540             }
1541         }
1542 
1543         return false;
1544     }
1545 
1546     function availableContractTokenBalance() public view returns (uint256) {
1547         return balanceOf(address(this)).sub(pendingTokensForReward);
1548     }
1549 
1550     function getHistory(
1551         address _account,
1552         uint256 _limit,
1553         uint256 _pageNumber
1554     ) external view returns (ClaimedEth[] memory) {
1555         require(_limit > 0 && _pageNumber > 0, "Diamond: Invalid arguments");
1556         uint256 userClaimedCount = userClaimedIds[_account].length;
1557         uint256 end = _pageNumber * _limit;
1558         uint256 start = end - _limit;
1559         require(start < userClaimedCount, "Diamond: Out of range");
1560         uint256 limit = _limit;
1561         if (end > userClaimedCount) {
1562             end = userClaimedCount;
1563             limit = userClaimedCount % _limit;
1564         }
1565 
1566         ClaimedEth[] memory myClaimedEth = new ClaimedEth[](limit);
1567         uint256 currentIndex = 0;
1568         for (uint256 i = start; i < end; i++) {
1569             uint256 hId = userClaimedIds[_account][i];
1570             myClaimedEth[currentIndex] = claimedEthMap[hId];
1571             currentIndex += 1;
1572         }
1573         return myClaimedEth;
1574     }
1575 
1576     function getHistoryCount(address _account) external view returns (uint256) {
1577         return userClaimedIds[_account].length;
1578     }
1579 
1580     receive() external payable {}
1581 }