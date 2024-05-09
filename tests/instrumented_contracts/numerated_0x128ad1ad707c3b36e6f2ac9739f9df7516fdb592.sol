1 // SPDX-License-Identifier: CC-BY-ND-4.0
2 
3 /* alfa.society:
4 
5 - https://www.alfasociety.io/
6 - https://twitter.com/alfasocietyERC
7 - https://t.me/AlfaSociety
8 
9 */
10 
11 pragma solidity ^0.8.17;
12 
13 // ANCHOR alfa.society methods
14 abstract contract alfaSpecials {
15     // alfa.society Innovations
16 
17     string internal _website = "https://www.alfasociety.io/";
18     event Message (string message);
19     event answerThePhone (string message);
20 
21     // NOTE Communications from the the society to the users
22     function _answerThePhone(string memory message) internal {
23         emit Message(message);
24         emit answerThePhone(message);
25     }
26 
27     // NOTE Antiphishing Method: you can check the website address of the contract 
28     // and compare it with the one on the website
29     function getWebsiteAddress() public view returns (string memory) {
30         return _website;
31     }
32 
33     function _changeWebsite(string memory newWebsite) internal {
34         _website = newWebsite;
35     }
36 }
37 
38 abstract contract safetyFirst {
39     mapping(address => bool) is_auth;
40 
41     function authorized(address addy) public view returns (bool) {
42         return is_auth[addy];
43     }
44 
45     function set_authorized(address addy, bool booly) public onlyAuth {
46         is_auth[addy] = booly;
47     }
48 
49     modifier onlyAuth() {
50         require(is_auth[msg.sender] || msg.sender == owner, "not owner");
51         _;
52     }
53     address owner;
54     modifier onlyOwner() {
55         require(msg.sender == owner, "not owner");
56         _;
57     }
58     bool locked;
59     modifier safe() {
60         require(!locked, "reentrant");
61         locked = true;
62         _;
63         locked = false;
64     }
65 
66     function change_owner(address new_owner) public onlyAuth {
67         owner = new_owner;
68     }
69 
70     receive() external payable {}
71 
72     fallback() external payable {}
73 }
74 
75 // SECTION Interfaces
76 interface ERC165 {
77     function supportsInterface(bytes4 interfaceID) external view returns (bool);
78 }
79 
80 interface ERC721 is ERC165 {
81     event Transfer(
82         address indexed _from,
83         address indexed _to,
84         uint256 indexed _tokenId
85     );
86     event Approval(
87         address indexed _owner,
88         address indexed _approved,
89         uint256 indexed _tokenId
90     );
91     event ApprovalForAll(
92         address indexed _owner,
93         address indexed _operator,
94         bool _approved
95     );
96 
97     function balanceOf(address _owner) external view returns (uint256);
98 
99     function ownerOf(uint256 _tokenId) external view returns (address);
100 
101     function safeTransferFrom(
102         address _from,
103         address _to,
104         uint256 _tokenId,
105         bytes memory data
106     ) external payable;
107 
108     function safeTransferFrom(
109         address _from,
110         address _to,
111         uint256 _tokenId
112     ) external payable;
113 
114     function transferFrom(
115         address _from,
116         address _to,
117         uint256 _tokenId
118     ) external payable;
119 
120     function approve(address _approved, uint256 _tokenId) external payable;
121 
122     function setApprovalForAll(address _operator, bool _approved) external;
123 
124     function getApproved(uint256 _tokenId) external view returns (address);
125 
126     function isApprovedForAll(address _owner, address _operator)
127         external
128         view
129         returns (bool);
130 }
131 
132 interface IERC20 {
133     function getOwner() external view returns (address);
134 
135     function name() external view returns (string memory);
136 
137     function symbol() external view returns (string memory);
138 
139     function decimals() external view returns (uint8);
140 
141     function totalSupply() external view returns (uint256);
142 
143     function balanceOf(address _owner) external view returns (uint256 balance);
144 
145     function transfer(address _to, uint256 _value)
146         external
147         returns (bool success);
148 
149     function transferFrom(
150         address _from,
151         address _to,
152         uint256 _value
153     ) external returns (bool success);
154 
155     function approve(address _spender, uint256 _value)
156         external
157         returns (bool success);
158 
159     function allowance(address _owner, address _spender)
160         external
161         view
162         returns (uint256 remaining);
163 
164     event Transfer(address indexed _from, address indexed _to, uint256 _value);
165     event Approval(
166         address indexed _owner,
167         address indexed _spender,
168         uint256 _value
169     );
170 }
171 
172 // !SECTION Interfaces
173 interface IUniswapERC20 {
174     event Approval(
175         address indexed owner,
176         address indexed spender,
177         uint256 value
178     );
179     event Transfer(address indexed from, address indexed to, uint256 value);
180 
181     function name() external pure returns (string memory);
182 
183     function symbol() external pure returns (string memory);
184 
185     function decimals() external pure returns (uint8);
186 
187     function totalSupply() external view returns (uint256);
188 
189     function balanceOf(address owner) external view returns (uint256);
190 
191     function allowance(address owner, address spender)
192         external
193         view
194         returns (uint256);
195 
196     function approve(address spender, uint256 value) external returns (bool);
197 
198     function transfer(address to, uint256 value) external returns (bool);
199 
200     function transferFrom(
201         address from,
202         address to,
203         uint256 value
204     ) external returns (bool);
205 
206     function DOMAIN_SEPARATOR() external view returns (bytes32);
207 
208     function PERMIT_TYPEHASH() external pure returns (bytes32);
209 
210     function nonces(address owner) external view returns (uint256);
211 
212     function permit(
213         address owner,
214         address spender,
215         uint256 value,
216         uint256 deadline,
217         uint8 v,
218         bytes32 r,
219         bytes32 s
220     ) external;
221 }
222 
223 interface IUniswapFactory {
224     event PairCreated(
225         address indexed token0,
226         address indexed token1,
227         address pair,
228         uint256
229     );
230 
231     function feeTo() external view returns (address);
232 
233     function feeToSetter() external view returns (address);
234 
235     function getPair(address tokenA, address tokenB)
236         external
237         view
238         returns (address pair);
239 
240     function allPairs(uint256) external view returns (address pair);
241 
242     function allPairsLength() external view returns (uint256);
243 
244     function createPair(address tokenA, address tokenB)
245         external
246         returns (address pair);
247 
248     function setFeeTo(address) external;
249 
250     function setFeeToSetter(address) external;
251 }
252 
253 interface IUniswapRouter01 {
254     function addLiquidity(
255         address tokenA,
256         address tokenB,
257         uint256 amountADesired,
258         uint256 amountBDesired,
259         uint256 amountAMin,
260         uint256 amountBMin,
261         address to,
262         uint256 deadline
263     )
264         external
265         returns (
266             uint256 amountA,
267             uint256 amountB,
268             uint256 liquidity
269         );
270 
271     function addLiquidityETH(
272         address token,
273         uint256 amountTokenDesired,
274         uint256 amountTokenMin,
275         uint256 amountETHMin,
276         address to,
277         uint256 deadline
278     )
279         external
280         payable
281         returns (
282             uint256 amountToken,
283             uint256 amountETH,
284             uint256 liquidity
285         );
286 
287     function removeLiquidity(
288         address tokenA,
289         address tokenB,
290         uint256 liquidity,
291         uint256 amountAMin,
292         uint256 amountBMin,
293         address to,
294         uint256 deadline
295     ) external returns (uint256 amountA, uint256 amountB);
296 
297     function removeLiquidityETH(
298         address token,
299         uint256 liquidity,
300         uint256 amountTokenMin,
301         uint256 amountETHMin,
302         address to,
303         uint256 deadline
304     ) external returns (uint256 amountToken, uint256 amountETH);
305 
306     function removeLiquidityWithPermit(
307         address tokenA,
308         address tokenB,
309         uint256 liquidity,
310         uint256 amountAMin,
311         uint256 amountBMin,
312         address to,
313         uint256 deadline,
314         bool approveMax,
315         uint8 v,
316         bytes32 r,
317         bytes32 s
318     ) external returns (uint256 amountA, uint256 amountB);
319 
320     function removeLiquidityETHWithPermit(
321         address token,
322         uint256 liquidity,
323         uint256 amountTokenMin,
324         uint256 amountETHMin,
325         address to,
326         uint256 deadline,
327         bool approveMax,
328         uint8 v,
329         bytes32 r,
330         bytes32 s
331     ) external returns (uint256 amountToken, uint256 amountETH);
332 
333     function swapExactTokensForTokens(
334         uint256 amountIn,
335         uint256 amountOutMin,
336         address[] calldata path,
337         address to,
338         uint256 deadline
339     ) external returns (uint256[] memory amounts);
340 
341     function swapTokensForExactTokens(
342         uint256 amountOut,
343         uint256 amountInMax,
344         address[] calldata path,
345         address to,
346         uint256 deadline
347     ) external returns (uint256[] memory amounts);
348 
349     function swapExactETHForTokens(
350         uint256 amountOutMin,
351         address[] calldata path,
352         address to,
353         uint256 deadline
354     ) external payable returns (uint256[] memory amounts);
355 
356     function swapTokensForExactETH(
357         uint256 amountOut,
358         uint256 amountInMax,
359         address[] calldata path,
360         address to,
361         uint256 deadline
362     ) external returns (uint256[] memory amounts);
363 
364     function swapExactTokensForETH(
365         uint256 amountIn,
366         uint256 amountOutMin,
367         address[] calldata path,
368         address to,
369         uint256 deadline
370     ) external returns (uint256[] memory amounts);
371 
372     function swapETHForExactTokens(
373         uint256 amountOut,
374         address[] calldata path,
375         address to,
376         uint256 deadline
377     ) external payable returns (uint256[] memory amounts);
378 
379     function factory() external pure returns (address);
380 
381     function WETH() external pure returns (address);
382 
383     function quote(
384         uint256 amountA,
385         uint256 reserveA,
386         uint256 reserveB
387     ) external pure returns (uint256 amountB);
388 
389     function getamountOut(
390         uint256 amountIn,
391         uint256 reserveIn,
392         uint256 reserveOut
393     ) external pure returns (uint256 amountOut);
394 
395     function getamountIn(
396         uint256 amountOut,
397         uint256 reserveIn,
398         uint256 reserveOut
399     ) external pure returns (uint256 amountIn);
400 
401     function getamountsOut(uint256 amountIn, address[] calldata path)
402         external
403         view
404         returns (uint256[] memory amounts);
405 
406     function getamountsIn(uint256 amountOut, address[] calldata path)
407         external
408         view
409         returns (uint256[] memory amounts);
410 }
411 
412 interface IUniswapRouter02 is IUniswapRouter01 {
413     function removeLiquidityETHSupportingFeeOnTransferTokens(
414         address token,
415         uint256 liquidity,
416         uint256 amountTokenMin,
417         uint256 amountETHMin,
418         address to,
419         uint256 deadline
420     ) external returns (uint256 amountETH);
421 
422     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
423         address token,
424         uint256 liquidity,
425         uint256 amountTokenMin,
426         uint256 amountETHMin,
427         address to,
428         uint256 deadline,
429         bool approveMax,
430         uint8 v,
431         bytes32 r,
432         bytes32 s
433     ) external returns (uint256 amountETH);
434 
435     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
436         uint256 amountIn,
437         uint256 amountOutMin,
438         address[] calldata path,
439         address to,
440         uint256 deadline
441     ) external;
442 
443     function swapExactETHForTokensSupportingFeeOnTransferTokens(
444         uint256 amountOutMin,
445         address[] calldata path,
446         address to,
447         uint256 deadline
448     ) external payable;
449 
450     function swapExactTokensForETHSupportingFeeOnTransferTokens(
451         uint256 amountIn,
452         uint256 amountOutMin,
453         address[] calldata path,
454         address to,
455         uint256 deadline
456     ) external;
457 }
458 
459 library Listables {
460     struct Set {
461         bytes32[] _values;
462         mapping(bytes32 => uint256) _indexes;
463     }
464 
465     function _add(Set storage set, bytes32 value) private returns (bool) {
466         if (!_contains(set, value)) {
467             set._values.push(value);
468             set._indexes[value] = set._values.length;
469             return true;
470         } else {
471             return false;
472         }
473     }
474 
475     function _remove(Set storage set, bytes32 value) private returns (bool) {
476         uint256 valueIndex = set._indexes[value];
477 
478         if (valueIndex != 0) {
479             uint256 toDeleteIndex = valueIndex - 1;
480             uint256 lastIndex = set._values.length - 1;
481 
482             bytes32 lastvalue = set._values[lastIndex];
483 
484             set._values[toDeleteIndex] = lastvalue;
485             set._indexes[lastvalue] = valueIndex;
486 
487             set._values.pop();
488 
489             delete set._indexes[value];
490 
491             return true;
492         } else {
493             return false;
494         }
495     }
496 
497     function _contains(Set storage set, bytes32 value)
498         private
499         view
500         returns (bool)
501     {
502         return set._indexes[value] != 0;
503     }
504 
505     function _length(Set storage set) private view returns (uint256) {
506         return set._values.length;
507     }
508 
509     function _at(Set storage set, uint256 index)
510         private
511         view
512         returns (bytes32)
513     {
514         require(
515             set._values.length > index,
516             "Listables: index out of bounds"
517         );
518         return set._values[index];
519     }
520 
521     struct Bytes32Set {
522         Set _inner;
523     }
524 
525     function add(Bytes32Set storage set, bytes32 value)
526         internal
527         returns (bool)
528     {
529         return _add(set._inner, value);
530     }
531 
532     function remove(Bytes32Set storage set, bytes32 value)
533         internal
534         returns (bool)
535     {
536         return _remove(set._inner, value);
537     }
538 
539     function contains(Bytes32Set storage set, bytes32 value)
540         internal
541         view
542         returns (bool)
543     {
544         return _contains(set._inner, value);
545     }
546 
547     function length(Bytes32Set storage set) internal view returns (uint256) {
548         return _length(set._inner);
549     }
550 
551     function at(Bytes32Set storage set, uint256 index)
552         internal
553         view
554         returns (bytes32)
555     {
556         return _at(set._inner, index);
557     }
558 
559     struct ActorSet {
560         Set _inner;
561     }
562 
563     function add(ActorSet storage set, address value)
564         internal
565         returns (bool)
566     {
567         return _add(set._inner, bytes32(uint256(uint160(value))));
568     }
569 
570     function remove(ActorSet storage set, address value)
571         internal
572         returns (bool)
573     {
574         return _remove(set._inner, bytes32(uint256(uint160(value))));
575     }
576 
577     function contains(ActorSet storage set, address value)
578         internal
579         view
580         returns (bool)
581     {
582         return _contains(set._inner, bytes32(uint256(uint160(value))));
583     }
584 
585     function length(ActorSet storage set) internal view returns (uint256) {
586         return _length(set._inner);
587     }
588 
589     function at(ActorSet storage set, uint256 index)
590         internal
591         view
592         returns (address)
593     {
594         return address(uint160(uint256(_at(set._inner, index))));
595     }
596 
597     struct UintSet {
598         Set _inner;
599     }
600 
601     function add(UintSet storage set, uint256 value) internal returns (bool) {
602         return _add(set._inner, bytes32(value));
603     }
604 
605     function remove(UintSet storage set, uint256 value)
606         internal
607         returns (bool)
608     {
609         return _remove(set._inner, bytes32(value));
610     }
611 
612     function contains(UintSet storage set, uint256 value)
613         internal
614         view
615         returns (bool)
616     {
617         return _contains(set._inner, bytes32(value));
618     }
619 
620     function length(UintSet storage set) internal view returns (uint256) {
621         return _length(set._inner);
622     }
623 
624     function at(UintSet storage set, uint256 index)
625         internal
626         view
627         returns (uint256)
628     {
629         return uint256(_at(set._inner, index));
630     }
631 }
632 
633 contract alfav3 is IERC20, safetyFirst, alfaSpecials {
634     using Listables for Listables.ActorSet;
635 
636     string public constant _name = "alfa.society";
637     string public constant _symbol = "ALFA";
638     uint8 public constant _decimals = 18;
639     uint256 public constant InitialSupply = 100 * 10**6 * 10**_decimals;
640 
641     mapping(address => uint256) public _balances;
642     mapping(address => mapping(address => uint256)) public _allowances;
643     mapping(address => uint256) public _coolDown;
644     Listables.ActorSet private _excluded;
645     Listables.ActorSet private _excludedFromCoolDown;
646 
647     mapping(address => bool) public _botlist;
648     bool isBotlist = true;
649 
650     uint256 swapTreshold = InitialSupply / 200; // 0.5%
651 
652     bool isSwapPegged = true;
653 
654     uint16 public BuyLimitDivider = 50; // 2%
655 
656     uint8 public BalanceLimitDivider = 25; // 4%
657 
658     uint16 public SellLimitDivider = 125; // 0.75%
659 
660     uint16 public MaxCoolDownTime = 10 seconds;
661     bool public coolDownDisabled;
662     uint256 public coolDownTime = 2 seconds;
663     bool public manualConversion;
664 
665     address public constant UniswapRouter =
666         0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
667     address public constant Dead = 0x000000000000000000000000000000000000dEaD;
668 
669     uint256 public _circulatingSupply = InitialSupply;
670     uint256 public balanceLimit = _circulatingSupply;
671     uint256 public sellLimit = _circulatingSupply;
672     uint256 public buyLimit = _circulatingSupply;
673 
674     uint8 public _buyTax = 10;
675     uint8 public _sellTax = 20; // INITIAL amount decreasing after 1 day to avoid dumpers
676     uint8 public _transferTax = 10;
677 
678     // Shares
679     uint8 public _liquidityTax = 10;
680     uint8 public _projectTax = 90;
681 
682     bool isTokenSwapManual;
683     bool public antiSnipe;
684     bool public tradingEnabled;
685 
686     address public _UniswapPairAddress;
687 
688     IUniswapRouter02 public _UniswapRouter;
689 
690     uint256 public projectBalance;
691 
692     bool private _isSwappingContractModifier;
693     
694     modifier lockTheSwap() {
695         _isSwappingContractModifier = true;
696         _;
697         _isSwappingContractModifier = false;
698     }
699 
700     constructor() {
701         // Ownership
702         owner = msg.sender;
703         is_auth[msg.sender] = true;
704         _balances[msg.sender] = _circulatingSupply;
705         emit Transfer(address(0), msg.sender, _circulatingSupply);
706         // Defining the Uniswap Router and the Uniswap Pair
707         _UniswapRouter = IUniswapRouter02(UniswapRouter);
708         _UniswapPairAddress = IUniswapFactory(_UniswapRouter.factory())
709             .createPair(address(this), _UniswapRouter.WETH());
710 
711         // SECTION Limits, Taxes and Locks
712         // Limits
713         balanceLimit = InitialSupply / BalanceLimitDivider;
714         sellLimit = InitialSupply / SellLimitDivider;
715         buyLimit = InitialSupply / BuyLimitDivider;
716         // !SECTION Limits, Taxes and Locks
717 
718         // SECTION Exclusions
719         _excluded.add(msg.sender);
720         _excludedFromCoolDown.add(UniswapRouter);
721         _excludedFromCoolDown.add(_UniswapPairAddress);
722         _excludedFromCoolDown.add(address(this));
723         // !SECTION Exclusions
724     }
725 
726     // NOTE Public transfer method
727     function _transfer(
728         address sender,
729         address recipient,
730         uint256 amount
731     ) private {
732         require(sender != address(0), "Transfer from zero");
733 
734         // Botlist check
735         if (isBotlist) {
736             require(
737                 !_botlist[sender] && !_botlist[recipient],
738                 "Botlisted!"
739             );
740         }
741 
742         // Check if the transfer is to be excluded from cooldown and taxes
743         bool isExcluded = (_excluded.contains(sender) ||
744             _excluded.contains(recipient) ||
745             is_auth[sender] ||
746             is_auth[recipient]);
747 
748         bool isContractTransfer = (sender == address(this) ||
749             recipient == address(this));
750 
751         bool isLiquidityTransfer = ((sender == _UniswapPairAddress &&
752             recipient == UniswapRouter) ||
753             (recipient == _UniswapPairAddress && sender == UniswapRouter));
754         if (
755             isContractTransfer || isLiquidityTransfer || isExcluded
756         ) {
757             _whitelistTransfer(sender, recipient, amount);
758         } else {
759             // If not, check if trading is enabled
760             if (!tradingEnabled) {
761                 // except for the owner
762                 if (sender != owner && recipient != owner) {
763                     // and apply anti-snipe if enabled
764                     if (antiSnipe) {
765                         emit Transfer(sender, recipient, 0);
766                         return;
767                     } else {
768                         // or revert if not
769                         require(tradingEnabled, "trading not yet enabled");
770                     }
771                 }
772             }
773 
774             // If trading is enabled, check if the transfer is a buy or a sell
775             bool isBuy = sender == _UniswapPairAddress ||
776                 sender == UniswapRouter;
777             bool isSell = recipient == _UniswapPairAddress ||
778                 recipient == UniswapRouter;
779             // and initiate the transfer accordingly
780             _normalTransfer(sender, recipient, amount, isBuy, isSell);
781 
782         }
783     }
784 
785     // NOTE Transfer method for everyone
786     function _normalTransfer(
787         address sender,
788         address recipient,
789         uint256 amount,
790         bool isBuy,
791         bool isSell
792     ) private {
793         // Read the balances of the recipient locally to save gas as is used twice
794         uint256 recipientBalance = _balances[recipient];
795         // Apply the requirements
796         require(_balances[sender] >= amount, "Transfer exceeds balance");
797         // Prepare the tax variable
798         uint8 tax;
799         // Apply the cooldown for sells
800         if (isSell) {
801             if (!_excludedFromCoolDown.contains(sender)) {
802                 require(
803                     _coolDown[sender] <= block.timestamp || coolDownDisabled,
804                     "Seller in coolDown"
805                 );
806                 _coolDown[sender] = block.timestamp + coolDownTime;
807             }
808             // Sell limit check
809             require(amount <= sellLimit, "Dump protection");
810             tax = _sellTax;
811         } else if (isBuy) {
812             // Balance limit check
813             require(
814                 recipientBalance + amount <= balanceLimit,
815                 "whale protection"
816             );
817             // Buy limit check
818             require(amount <= buyLimit, "whale protection");
819             tax = _buyTax;
820         } else {
821             require(
822                 // Balance limit check for transfers
823                 recipientBalance + amount <= balanceLimit,
824                 "whale protection"
825             );
826             // Update the cooldown for the sender if not excluded
827             if (!_excludedFromCoolDown.contains(sender))
828                 require(
829                     _coolDown[sender] <= block.timestamp || coolDownDisabled,
830                     "Sender in Lock"
831                 );
832             tax = _transferTax;
833         }
834 
835         // Check if the transaction is fit for token swapping
836         if (
837             (sender != _UniswapPairAddress) &&
838             (!manualConversion) &&
839             (!_isSwappingContractModifier)
840         ) _swapContractToken(amount);
841 
842         // Calculating the taxed amount
843         uint256 contractToken = _calculateFee(
844             amount,
845             tax,
846             _liquidityTax + _projectTax 
847         );
848         // Refactoring the various amounts
849         uint256 taxedAmount = amount - (contractToken);
850         _removeToken(sender, amount);
851         _balances[address(this)] += contractToken;
852         _addToken(recipient, taxedAmount);
853         // Emitting the transfer event
854         emit Transfer(sender, recipient, taxedAmount);
855     }
856 
857     function _whitelistTransfer(
858         address sender,
859         address recipient,
860         uint256 amount
861     ) private {
862         // Basic checks
863         require(_balances[sender] >= amount, "Transfer exceeds balance");
864         // Plain transfer
865         _removeToken(sender, amount);
866         _addToken(recipient, amount);
867         // Emitting the transfer event
868         emit Transfer(sender, recipient, amount);
869     }
870 
871     // NOTE To fully support decimal operations, we custom calculate the fees
872     function _calculateFee(
873         uint256 amount,
874         uint8 tax,
875         uint8 taxPercent
876     ) private pure returns (uint256) {
877         return (amount * tax * taxPercent) / 10000;
878     }
879 
880     function _addToken(address addr, uint256 amount) private {
881         uint256 newAmount = _balances[addr] + amount;
882         _balances[addr] = newAmount;
883     }
884 
885     function _removeToken(address addr, uint256 amount) private {
886         uint256 newAmount = _balances[addr] - amount;
887         _balances[addr] = newAmount;
888     }
889 
890     // SECTION Swapping taxes and adding liquidity
891 
892     // NOTE Swap tokens on sells to create liquidity
893     function _swapContractToken(uint256 totalMax) private lockTheSwap {
894         uint256 contractBalance = _balances[address(this)];
895         // Do not swap if the contract balance is lower than the swap treshold
896         if (contractBalance < swapTreshold) {
897             return;
898         }
899 
900         // Calculate the amount of tokens to swap
901         uint16 totalTax = _liquidityTax;
902         uint256 tokenToSwap = swapTreshold;
903         // Avoid swapping more than the total max of the transaction
904         if (swapTreshold > totalMax) {
905             if (isSwapPegged) {
906                 tokenToSwap = totalMax;
907             }
908         }
909         // Avoid swapping if there are no liquidity fees to generate
910         if (totalTax == 0) {
911             return;
912         }
913 
914         // Calculate the amount of tokens to work on for liquidity and project
915         uint256 tokenForLiquidity = (tokenToSwap * _liquidityTax) / totalTax;
916         uint256 tokenForProject = (tokenToSwap * _projectTax) / totalTax;
917         // Divide the liquidity tokens in half to add liquidity
918         uint256 liqToken = tokenForLiquidity / 2;
919         uint256 liqETHToken = tokenForLiquidity - liqToken;
920         // Calculate the amount of ETH to swap
921         uint256 swapToken = liqETHToken +
922             tokenForProject;
923         // Swap the tokens for ETH
924         uint256 initialETHBalance = address(this).balance;
925         _swapTokenForETH(swapToken);
926         // Calculate the amount of ETH generated and the amount of ETH to add liquidity with
927         uint256 newETH = (address(this).balance - initialETHBalance);
928         uint256 liqETH = (newETH * liqETHToken) / swapToken;
929         // Add liquidity
930         _addLiquidity(liqToken, liqETH);
931         // Add the project ETH to the project balance
932         uint256 generatedETH = (address(this).balance - initialETHBalance);
933         projectBalance += generatedETH;
934     }
935 
936     // NOTE Basic swap function for swapping tokens on Uniswap-v2 compatible routers
937     function _swapTokenForETH(uint256 amount) private {
938         // Preapprove the router to spend the tokens
939         _approve(address(this), address(_UniswapRouter), amount);
940 
941         address[] memory path = new address[](2);
942         path[0] = address(this);
943         path[1] = _UniswapRouter.WETH();
944 
945         _UniswapRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
946             amount,
947             0,
948             path,
949             address(this),
950             block.timestamp
951         );
952     }
953 
954     // NOTE Basic add liquidity function for adding liquidity on Uniswap-v2 compatible routers
955     function _addLiquidity(uint256 tokenamount, uint256 ETHamount) private {
956         // Approve the router to spend the tokens
957         _approve(address(this), address(_UniswapRouter), tokenamount);
958 
959         _UniswapRouter.addLiquidityETH{value: ETHamount}(
960             address(this),
961             tokenamount,
962             0,
963             0,
964             address(this),
965             block.timestamp
966         );
967     }
968     // !SECTION Swapping taxes and adding liquidity
969 
970     /// SECTION Utility functions
971 
972     function getLimits()
973         public
974         view
975         returns (uint256 balance, uint256 sell)
976     {
977         return (balanceLimit, sellLimit);
978     }
979 
980     function getTaxes()
981         public
982         view
983         returns (
984             uint256 projectShare,
985             uint256 liquidityShare,
986             uint256 buyTax,
987             uint256 sellTax,
988             uint256 transferTax
989         )
990     {
991         return (
992             _projectTax,
993             _liquidityTax,
994             _buyTax,
995             _sellTax,
996             _transferTax
997         );
998     }
999 
1000     // NOTE The actual cooldown time
1001     function getCoolDownTimeInSeconds() public view returns (uint256) {
1002         return coolDownTime;
1003     }
1004 
1005     // NOTE Pegged swap means that the contract won't dump when the swap treshold is reached
1006     function SetPeggedSwap(bool isPegged) public onlyAuth {
1007         isSwapPegged = isPegged;
1008     }
1009 
1010     // NOTE The token amount that triggers swap on sells
1011     function SetSwapTreshold(uint256 max) public onlyAuth {
1012         swapTreshold = max;
1013     }
1014     // !SECTION Utility functions
1015 
1016     function BotlistAddress(address addy, bool booly) public onlyAuth {
1017         _botlist[addy] = booly;
1018     }
1019 
1020     function ExcludeAccountFromFees(address account) public onlyAuth {
1021         _excluded.add(account);
1022     }
1023 
1024     function IncludeAccountToFees(address account) public onlyAuth {
1025         _excluded.remove(account);
1026     }
1027 
1028     function ExcludeAccountFromCoolDown(address account) public onlyAuth {
1029         _excludedFromCoolDown.add(account);
1030     }
1031 
1032     function IncludeAccountToCoolDown(address account) public onlyAuth {
1033         _excludedFromCoolDown.remove(account);
1034     }
1035 
1036     function WithdrawProjectETH() public onlyAuth {
1037         uint256 amount = projectBalance;
1038         projectBalance = 0;
1039         address sender = msg.sender;
1040         (bool sent, ) = sender.call{value: (amount)}("");
1041         require(sent, "withdraw failed");
1042     }
1043 
1044     function SwitchManualETHConversion(bool manual) public onlyAuth {
1045         manualConversion = manual;
1046     }
1047 
1048     function DisableCoolDown(bool disabled) public onlyAuth {
1049         coolDownDisabled = disabled;
1050     }
1051 
1052     function SetCoolDownTime(uint256 coolDownSeconds) public onlyAuth {
1053         coolDownTime = coolDownSeconds;
1054     }
1055 
1056     function SetTaxes(
1057         uint8 projectTaxes,
1058         uint8 liquidityTaxes,
1059         uint8 buyTax,
1060         uint8 sellTax,
1061         uint8 transferTax
1062     ) public onlyAuth {
1063         uint8 totalTax =
1064             projectTaxes +
1065             liquidityTaxes;
1066         require(totalTax == 100, "Project + Liquidity taxes needs to equal 100%");
1067         _projectTax = projectTaxes;
1068         _liquidityTax = liquidityTaxes;
1069 
1070         _buyTax = buyTax;
1071         _sellTax = sellTax;
1072         _transferTax = transferTax;
1073     }
1074 
1075     function ManualGenerateTokenSwapBalance(uint256 _qty)
1076         public
1077         onlyAuth
1078     {
1079         _swapContractToken(_qty * 10**9);
1080     }
1081 
1082     function UpdateLimits(uint256 newBalanceLimit, uint256 newSellLimit)
1083         public
1084         onlyAuth
1085     {
1086         newBalanceLimit = newBalanceLimit * 10**_decimals;
1087         newSellLimit = newSellLimit * 10**_decimals;
1088         balanceLimit = newBalanceLimit;
1089         sellLimit = newSellLimit;
1090     }
1091 
1092     function EnableTrading(bool booly) public onlyAuth {
1093         tradingEnabled = booly;
1094     }
1095 
1096     function LiquidityTokenAddress(address liquidityTokenAddress)
1097         public
1098         onlyAuth
1099     {
1100         _UniswapPairAddress = liquidityTokenAddress;
1101     }
1102 
1103     function RescueTokens(address tknAddress) public onlyAuth {
1104         IERC20 token = IERC20(tknAddress);
1105         uint256 ourBalance = token.balanceOf(address(this));
1106         require(ourBalance > 0, "No tokens in our balance");
1107         token.transfer(msg.sender, ourBalance);
1108     }
1109 
1110     function setBotlistEnabled(bool isBotlistEnabled)
1111         public
1112         onlyAuth
1113     {
1114         isBotlist = isBotlistEnabled;
1115     }
1116 
1117     function setContractTokenSwapManual(bool manual) public onlyAuth {
1118         isTokenSwapManual = manual;
1119     }
1120 
1121     function setBotlistedAddress(address toBotlist)
1122         public
1123         onlyAuth
1124     {
1125         _botlist[toBotlist] = true;
1126     }
1127 
1128     function removeBotlistedAddress(address toRemove)
1129         public
1130         onlyAuth
1131     {
1132         _botlist[toRemove] = false;
1133     }
1134 
1135     function AvoidLocks() public onlyAuth {
1136         (bool sent, ) = msg.sender.call{value: (address(this).balance)}("");
1137         require(sent);
1138     }
1139 
1140     function getOwner() external view override returns (address) {
1141         return owner;
1142     }
1143 
1144     function name() external pure override returns (string memory) {
1145         return _name;
1146     }
1147 
1148     function symbol() external pure override returns (string memory) {
1149         return _symbol;
1150     }
1151 
1152     function decimals() external pure override returns (uint8) {
1153         return _decimals;
1154     }
1155 
1156     function totalSupply() external view override returns (uint256) {
1157         return _circulatingSupply;
1158     }
1159 
1160     function balanceOf(address account)
1161         external
1162         view
1163         override
1164         returns (uint256)
1165     {
1166         return _balances[account];
1167     }
1168 
1169     function transfer(address recipient, uint256 amount)
1170         external
1171         override
1172         returns (bool)
1173     {
1174         _transfer(msg.sender, recipient, amount);
1175         return true;
1176     }
1177 
1178     function allowance(address _owner, address spender)
1179         external
1180         view
1181         override
1182         returns (uint256)
1183     {
1184         return _allowances[_owner][spender];
1185     }
1186 
1187     function approve(address spender, uint256 amount)
1188         external
1189         override
1190         returns (bool)
1191     {
1192         _approve(msg.sender, spender, amount);
1193         return true;
1194     }
1195 
1196     function _approve(
1197         address _owner,
1198         address spender,
1199         uint256 amount
1200     ) private {
1201         require(_owner != address(0), "Approve from zero");
1202         require(spender != address(0), "Approve to zero");
1203 
1204         _allowances[_owner][spender] = amount;
1205         emit Approval(_owner, spender, amount);
1206     }
1207 
1208     function transferFrom(
1209         address sender,
1210         address recipient,
1211         uint256 amount
1212     ) external override returns (bool) {
1213         _transfer(sender, recipient, amount);
1214 
1215         uint256 currentAllowance = _allowances[sender][msg.sender];
1216         require(currentAllowance >= amount, "Transfer > allowance");
1217 
1218         _approve(sender, msg.sender, currentAllowance - amount);
1219         return true;
1220     }
1221 
1222     function increaseAllowance(address spender, uint256 addedValue)
1223         external
1224         returns (bool)
1225     {
1226         _approve(
1227             msg.sender,
1228             spender,
1229             _allowances[msg.sender][spender] + addedValue
1230         );
1231         return true;
1232     }
1233 
1234     function decreaseAllowance(address spender, uint256 subtractedValue)
1235         external
1236         returns (bool)
1237     {
1238         uint256 currentAllowance = _allowances[msg.sender][spender];
1239         require(currentAllowance >= subtractedValue, "<0 allowance");
1240 
1241         _approve(msg.sender, spender, currentAllowance - subtractedValue);
1242         return true;
1243     }
1244 
1245     // alfa.society Derivations
1246 
1247     function messageFromTeam(string memory message) public onlyAuth {
1248         _answerThePhone(message);
1249     }
1250 
1251     function changeWebsite(string memory newWebsite) public onlyAuth {
1252         _changeWebsite(newWebsite);
1253     }
1254 
1255 }