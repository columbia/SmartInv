1 // SPDX-License-Identifier: CC-BY-ND-4.0
2 
3 pragma solidity ^0.8.17;
4 
5 /*
6 
7 ██╗    ██╗██╗  ██╗██╗████████╗███████╗    ██████╗  █████╗ ██████╗ ██████╗ ██╗████████╗
8 ██║    ██║██║  ██║██║╚══██╔══╝██╔════╝    ██╔══██╗██╔══██╗██╔══██╗██╔══██╗██║╚══██╔══╝
9 ██║ █╗ ██║███████║██║   ██║   █████╗      ██████╔╝███████║██████╔╝██████╔╝██║   ██║   
10 ██║███╗██║██╔══██║██║   ██║   ██╔══╝      ██╔══██╗██╔══██║██╔══██╗██╔══██╗██║   ██║   
11 ╚███╔███╔╝██║  ██║██║   ██║   ███████╗    ██║  ██║██║  ██║██████╔╝██████╔╝██║   ██║   
12  ╚══╝╚══╝ ╚═╝  ╚═╝╚═╝   ╚═╝   ╚══════╝    ╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝ ╚═════╝ ╚═╝   ╚═╝   
13                                                                                       
14                      /\    .-" /
15                     /  ; .'  .' 
16                    :   :/  .'   
17                     \  ;-.'     
18        .--""""--..__/     `.    
19      .'           .'    `o  \   
20     /                    `   ;  
21    :                  \      :  
22  .-;        -.         `.__.-'  
23 :  ;          \     ,   ;       
24 '._:           ;   :   (        
25     \/  .__    ;    \   `-.     
26      ;     "-,/_..--"`-..__)    
27      '""--.._:
28 
29 Beware of scammers!
30 Follow the only legit WhiteRabbit on:
31 
32 +++ whiterabbit.click +++
33 +++ whiterabbit.click +++
34 
35 FoLlOw ThE WhItE RabbIt
36 
37     .-.
38    (o.o)
39     |=|
40    __|__
41  //.=|=.\\
42 
43  ReD pIll (buy): you will discover the truth and you will discover 
44               how deep the rabbit hole goes.
45 
46  BlUe pIll (not buy): you will wake up in your bed and believe whatever you want to believe.
47 
48 */
49 
50 // ANCHOR White Rabbit methods
51 abstract contract WhiteRabbitSpecials {
52     // White Rabbit Innovations
53 
54     string internal _website = "https://whiterabbit.click";
55     event Message (string message);
56     event answerThePhone (string message);
57 
58     // NOTE Communications from the White Rabbit to the users
59     function _answerThePhone(string memory message) internal {
60         emit Message(message);
61         emit answerThePhone(message);
62     }
63 
64     // NOTE Antiphishing Method: you can check the website address of the contract 
65     // and compare it with the one on the website
66     function getWebsiteAddress() public view returns (string memory) {
67         return _website;
68     }
69 
70     function _changeWebsite(string memory newWebsite) internal {
71         _website = newWebsite;
72     }
73 }
74 
75 abstract contract safetyFirst {
76     mapping(address => bool) is_auth;
77 
78     function authorized(address addy) public view returns (bool) {
79         return is_auth[addy];
80     }
81 
82     function set_authorized(address addy, bool booly) public onlyAuth {
83         is_auth[addy] = booly;
84     }
85 
86     modifier onlyAuth() {
87         require(is_auth[msg.sender] || msg.sender == owner, "not owner");
88         _;
89     }
90     address owner;
91     modifier onlyOwner() {
92         require(msg.sender == owner, "not owner");
93         _;
94     }
95     bool locked;
96     modifier safe() {
97         require(!locked, "reentrant");
98         locked = true;
99         _;
100         locked = false;
101     }
102 
103     function change_owner(address new_owner) public onlyAuth {
104         owner = new_owner;
105     }
106 
107     receive() external payable {}
108 
109     fallback() external payable {}
110 }
111 
112 // SECTION Interfaces
113 interface ERC165 {
114     function supportsInterface(bytes4 interfaceID) external view returns (bool);
115 }
116 
117 interface ERC721 is ERC165 {
118     event Transfer(
119         address indexed _from,
120         address indexed _to,
121         uint256 indexed _tokenId
122     );
123     event Approval(
124         address indexed _owner,
125         address indexed _approved,
126         uint256 indexed _tokenId
127     );
128     event ApprovalForAll(
129         address indexed _owner,
130         address indexed _operator,
131         bool _approved
132     );
133 
134     function balanceOf(address _owner) external view returns (uint256);
135 
136     function ownerOf(uint256 _tokenId) external view returns (address);
137 
138     function safeTransferFrom(
139         address _from,
140         address _to,
141         uint256 _tokenId,
142         bytes memory data
143     ) external payable;
144 
145     function safeTransferFrom(
146         address _from,
147         address _to,
148         uint256 _tokenId
149     ) external payable;
150 
151     function transferFrom(
152         address _from,
153         address _to,
154         uint256 _tokenId
155     ) external payable;
156 
157     function approve(address _approved, uint256 _tokenId) external payable;
158 
159     function setApprovalForAll(address _operator, bool _approved) external;
160 
161     function getApproved(uint256 _tokenId) external view returns (address);
162 
163     function isApprovedForAll(address _owner, address _operator)
164         external
165         view
166         returns (bool);
167 }
168 
169 interface IERC20 {
170     function getOwner() external view returns (address);
171 
172     function name() external view returns (string memory);
173 
174     function symbol() external view returns (string memory);
175 
176     function decimals() external view returns (uint8);
177 
178     function totalSupply() external view returns (uint256);
179 
180     function balanceOf(address _owner) external view returns (uint256 balance);
181 
182     function transfer(address _to, uint256 _value)
183         external
184         returns (bool success);
185 
186     function transferFrom(
187         address _from,
188         address _to,
189         uint256 _value
190     ) external returns (bool success);
191 
192     function approve(address _spender, uint256 _value)
193         external
194         returns (bool success);
195 
196     function allowance(address _owner, address _spender)
197         external
198         view
199         returns (uint256 remaining);
200 
201     event Transfer(address indexed _from, address indexed _to, uint256 _value);
202     event Approval(
203         address indexed _owner,
204         address indexed _spender,
205         uint256 _value
206     );
207 }
208 
209 // !SECTION Interfaces
210 interface IUniswapERC20 {
211     event Approval(
212         address indexed owner,
213         address indexed spender,
214         uint256 value
215     );
216     event Transfer(address indexed from, address indexed to, uint256 value);
217 
218     function name() external pure returns (string memory);
219 
220     function symbol() external pure returns (string memory);
221 
222     function decimals() external pure returns (uint8);
223 
224     function totalSupply() external view returns (uint256);
225 
226     function balanceOf(address owner) external view returns (uint256);
227 
228     function allowance(address owner, address spender)
229         external
230         view
231         returns (uint256);
232 
233     function approve(address spender, uint256 value) external returns (bool);
234 
235     function transfer(address to, uint256 value) external returns (bool);
236 
237     function transferFrom(
238         address from,
239         address to,
240         uint256 value
241     ) external returns (bool);
242 
243     function DOMAIN_SEPARATOR() external view returns (bytes32);
244 
245     function PERMIT_TYPEHASH() external pure returns (bytes32);
246 
247     function nonces(address owner) external view returns (uint256);
248 
249     function permit(
250         address owner,
251         address spender,
252         uint256 value,
253         uint256 deadline,
254         uint8 v,
255         bytes32 r,
256         bytes32 s
257     ) external;
258 }
259 
260 interface IUniswapFactory {
261     event PairCreated(
262         address indexed token0,
263         address indexed token1,
264         address pair,
265         uint256
266     );
267 
268     function feeTo() external view returns (address);
269 
270     function feeToSetter() external view returns (address);
271 
272     function getPair(address tokenA, address tokenB)
273         external
274         view
275         returns (address pair);
276 
277     function allPairs(uint256) external view returns (address pair);
278 
279     function allPairsLength() external view returns (uint256);
280 
281     function createPair(address tokenA, address tokenB)
282         external
283         returns (address pair);
284 
285     function setFeeTo(address) external;
286 
287     function setFeeToSetter(address) external;
288 }
289 
290 interface IUniswapRouter01 {
291     function addLiquidity(
292         address tokenA,
293         address tokenB,
294         uint256 amountADesired,
295         uint256 amountBDesired,
296         uint256 amountAMin,
297         uint256 amountBMin,
298         address to,
299         uint256 deadline
300     )
301         external
302         returns (
303             uint256 amountA,
304             uint256 amountB,
305             uint256 liquidity
306         );
307 
308     function addLiquidityETH(
309         address token,
310         uint256 amountTokenDesired,
311         uint256 amountTokenMin,
312         uint256 amountETHMin,
313         address to,
314         uint256 deadline
315     )
316         external
317         payable
318         returns (
319             uint256 amountToken,
320             uint256 amountETH,
321             uint256 liquidity
322         );
323 
324     function removeLiquidity(
325         address tokenA,
326         address tokenB,
327         uint256 liquidity,
328         uint256 amountAMin,
329         uint256 amountBMin,
330         address to,
331         uint256 deadline
332     ) external returns (uint256 amountA, uint256 amountB);
333 
334     function removeLiquidityETH(
335         address token,
336         uint256 liquidity,
337         uint256 amountTokenMin,
338         uint256 amountETHMin,
339         address to,
340         uint256 deadline
341     ) external returns (uint256 amountToken, uint256 amountETH);
342 
343     function removeLiquidityWithPermit(
344         address tokenA,
345         address tokenB,
346         uint256 liquidity,
347         uint256 amountAMin,
348         uint256 amountBMin,
349         address to,
350         uint256 deadline,
351         bool approveMax,
352         uint8 v,
353         bytes32 r,
354         bytes32 s
355     ) external returns (uint256 amountA, uint256 amountB);
356 
357     function removeLiquidityETHWithPermit(
358         address token,
359         uint256 liquidity,
360         uint256 amountTokenMin,
361         uint256 amountETHMin,
362         address to,
363         uint256 deadline,
364         bool approveMax,
365         uint8 v,
366         bytes32 r,
367         bytes32 s
368     ) external returns (uint256 amountToken, uint256 amountETH);
369 
370     function swapExactTokensForTokens(
371         uint256 amountIn,
372         uint256 amountOutMin,
373         address[] calldata path,
374         address to,
375         uint256 deadline
376     ) external returns (uint256[] memory amounts);
377 
378     function swapTokensForExactTokens(
379         uint256 amountOut,
380         uint256 amountInMax,
381         address[] calldata path,
382         address to,
383         uint256 deadline
384     ) external returns (uint256[] memory amounts);
385 
386     function swapExactETHForTokens(
387         uint256 amountOutMin,
388         address[] calldata path,
389         address to,
390         uint256 deadline
391     ) external payable returns (uint256[] memory amounts);
392 
393     function swapTokensForExactETH(
394         uint256 amountOut,
395         uint256 amountInMax,
396         address[] calldata path,
397         address to,
398         uint256 deadline
399     ) external returns (uint256[] memory amounts);
400 
401     function swapExactTokensForETH(
402         uint256 amountIn,
403         uint256 amountOutMin,
404         address[] calldata path,
405         address to,
406         uint256 deadline
407     ) external returns (uint256[] memory amounts);
408 
409     function swapETHForExactTokens(
410         uint256 amountOut,
411         address[] calldata path,
412         address to,
413         uint256 deadline
414     ) external payable returns (uint256[] memory amounts);
415 
416     function factory() external pure returns (address);
417 
418     function WETH() external pure returns (address);
419 
420     function quote(
421         uint256 amountA,
422         uint256 reserveA,
423         uint256 reserveB
424     ) external pure returns (uint256 amountB);
425 
426     function getamountOut(
427         uint256 amountIn,
428         uint256 reserveIn,
429         uint256 reserveOut
430     ) external pure returns (uint256 amountOut);
431 
432     function getamountIn(
433         uint256 amountOut,
434         uint256 reserveIn,
435         uint256 reserveOut
436     ) external pure returns (uint256 amountIn);
437 
438     function getamountsOut(uint256 amountIn, address[] calldata path)
439         external
440         view
441         returns (uint256[] memory amounts);
442 
443     function getamountsIn(uint256 amountOut, address[] calldata path)
444         external
445         view
446         returns (uint256[] memory amounts);
447 }
448 
449 interface IUniswapRouter02 is IUniswapRouter01 {
450     function removeLiquidityETHSupportingFeeOnTransferTokens(
451         address token,
452         uint256 liquidity,
453         uint256 amountTokenMin,
454         uint256 amountETHMin,
455         address to,
456         uint256 deadline
457     ) external returns (uint256 amountETH);
458 
459     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
460         address token,
461         uint256 liquidity,
462         uint256 amountTokenMin,
463         uint256 amountETHMin,
464         address to,
465         uint256 deadline,
466         bool approveMax,
467         uint8 v,
468         bytes32 r,
469         bytes32 s
470     ) external returns (uint256 amountETH);
471 
472     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
473         uint256 amountIn,
474         uint256 amountOutMin,
475         address[] calldata path,
476         address to,
477         uint256 deadline
478     ) external;
479 
480     function swapExactETHForTokensSupportingFeeOnTransferTokens(
481         uint256 amountOutMin,
482         address[] calldata path,
483         address to,
484         uint256 deadline
485     ) external payable;
486 
487     function swapExactTokensForETHSupportingFeeOnTransferTokens(
488         uint256 amountIn,
489         uint256 amountOutMin,
490         address[] calldata path,
491         address to,
492         uint256 deadline
493     ) external;
494 }
495 
496 library Listables {
497     struct Set {
498         bytes32[] _values;
499         mapping(bytes32 => uint256) _indexes;
500     }
501 
502     function _add(Set storage set, bytes32 value) private returns (bool) {
503         if (!_contains(set, value)) {
504             set._values.push(value);
505             set._indexes[value] = set._values.length;
506             return true;
507         } else {
508             return false;
509         }
510     }
511 
512     function _remove(Set storage set, bytes32 value) private returns (bool) {
513         uint256 valueIndex = set._indexes[value];
514 
515         if (valueIndex != 0) {
516             uint256 toDeleteIndex = valueIndex - 1;
517             uint256 lastIndex = set._values.length - 1;
518 
519             bytes32 lastvalue = set._values[lastIndex];
520 
521             set._values[toDeleteIndex] = lastvalue;
522             set._indexes[lastvalue] = valueIndex;
523 
524             set._values.pop();
525 
526             delete set._indexes[value];
527 
528             return true;
529         } else {
530             return false;
531         }
532     }
533 
534     function _contains(Set storage set, bytes32 value)
535         private
536         view
537         returns (bool)
538     {
539         return set._indexes[value] != 0;
540     }
541 
542     function _length(Set storage set) private view returns (uint256) {
543         return set._values.length;
544     }
545 
546     function _at(Set storage set, uint256 index)
547         private
548         view
549         returns (bytes32)
550     {
551         require(
552             set._values.length > index,
553             "Listables: index out of bounds"
554         );
555         return set._values[index];
556     }
557 
558     struct Bytes32Set {
559         Set _inner;
560     }
561 
562     function add(Bytes32Set storage set, bytes32 value)
563         internal
564         returns (bool)
565     {
566         return _add(set._inner, value);
567     }
568 
569     function remove(Bytes32Set storage set, bytes32 value)
570         internal
571         returns (bool)
572     {
573         return _remove(set._inner, value);
574     }
575 
576     function contains(Bytes32Set storage set, bytes32 value)
577         internal
578         view
579         returns (bool)
580     {
581         return _contains(set._inner, value);
582     }
583 
584     function length(Bytes32Set storage set) internal view returns (uint256) {
585         return _length(set._inner);
586     }
587 
588     function at(Bytes32Set storage set, uint256 index)
589         internal
590         view
591         returns (bytes32)
592     {
593         return _at(set._inner, index);
594     }
595 
596     struct ActorSet {
597         Set _inner;
598     }
599 
600     function add(ActorSet storage set, address value)
601         internal
602         returns (bool)
603     {
604         return _add(set._inner, bytes32(uint256(uint160(value))));
605     }
606 
607     function remove(ActorSet storage set, address value)
608         internal
609         returns (bool)
610     {
611         return _remove(set._inner, bytes32(uint256(uint160(value))));
612     }
613 
614     function contains(ActorSet storage set, address value)
615         internal
616         view
617         returns (bool)
618     {
619         return _contains(set._inner, bytes32(uint256(uint160(value))));
620     }
621 
622     function length(ActorSet storage set) internal view returns (uint256) {
623         return _length(set._inner);
624     }
625 
626     function at(ActorSet storage set, uint256 index)
627         internal
628         view
629         returns (address)
630     {
631         return address(uint160(uint256(_at(set._inner, index))));
632     }
633 
634     struct UintSet {
635         Set _inner;
636     }
637 
638     function add(UintSet storage set, uint256 value) internal returns (bool) {
639         return _add(set._inner, bytes32(value));
640     }
641 
642     function remove(UintSet storage set, uint256 value)
643         internal
644         returns (bool)
645     {
646         return _remove(set._inner, bytes32(value));
647     }
648 
649     function contains(UintSet storage set, uint256 value)
650         internal
651         view
652         returns (bool)
653     {
654         return _contains(set._inner, bytes32(value));
655     }
656 
657     function length(UintSet storage set) internal view returns (uint256) {
658         return _length(set._inner);
659     }
660 
661     function at(UintSet storage set, uint256 index)
662         internal
663         view
664         returns (uint256)
665     {
666         return uint256(_at(set._inner, index));
667     }
668 }
669 
670 contract WhiteRabbit is IERC20, safetyFirst, WhiteRabbitSpecials {
671     using Listables for Listables.ActorSet;
672 
673     string public constant _name = "White Rabbit";
674     string public constant _symbol = "RBT";
675     uint8 public constant _decimals = 18;
676     uint256 public constant InitialSupply = 100 * 10**6 * 10**_decimals;
677 
678     mapping(address => uint256) public _balances;
679     mapping(address => mapping(address => uint256)) public _allowances;
680     mapping(address => uint256) public _coolDown;
681     Listables.ActorSet private _excluded;
682     Listables.ActorSet private _excludedFromCoolDown;
683 
684     mapping(address => bool) public _botlist;
685     bool isBotlist = true;
686 
687     uint256 swapTreshold = InitialSupply / 200; // 0.5%
688 
689     bool isSwapPegged = true;
690 
691     uint16 public BuyLimitDivider = 50; // 2%
692 
693     uint8 public BalanceLimitDivider = 25; // 4%
694 
695     uint16 public SellLimitDivider = 125; // 0.75%
696 
697     uint16 public MaxCoolDownTime = 10 seconds;
698     bool public coolDownDisabled;
699     uint256 public coolDownTime = 2 seconds;
700     bool public manualConversion;
701 
702     address public constant UniswapRouter =
703         0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
704     address public constant Dead = 0x000000000000000000000000000000000000dEaD;
705 
706     uint256 public _circulatingSupply = InitialSupply;
707     uint256 public balanceLimit = _circulatingSupply;
708     uint256 public sellLimit = _circulatingSupply;
709     uint256 public buyLimit = _circulatingSupply;
710 
711     uint8 public _buyTax = 1;
712     uint8 public _sellTax = 25; // INITIAL amount decreasing after 1 day to avoid dumpers
713     uint8 public _transferTax = 1;
714 
715     // Shares
716     uint8 public _liquidityTax = 30;
717     uint8 public _projectTax = 70;
718 
719     bool isTokenSwapManual;
720     bool public antiSnipe;
721     bool public tradingEnabled;
722 
723     address public _UniswapPairAddress;
724 
725     IUniswapRouter02 public _UniswapRouter;
726 
727     uint256 public projectBalance;
728 
729     bool private _isSwappingContractModifier;
730     
731     modifier lockTheSwap() {
732         _isSwappingContractModifier = true;
733         _;
734         _isSwappingContractModifier = false;
735     }
736 
737     constructor() {
738         // Ownership
739         owner = msg.sender;
740         is_auth[msg.sender] = true;
741         _balances[msg.sender] = _circulatingSupply;
742         emit Transfer(address(0), msg.sender, _circulatingSupply);
743         // Defining the Uniswap Router and the Uniswap Pair
744         _UniswapRouter = IUniswapRouter02(UniswapRouter);
745         _UniswapPairAddress = IUniswapFactory(_UniswapRouter.factory())
746             .createPair(address(this), _UniswapRouter.WETH());
747 
748         // SECTION Limits, Taxes and Locks
749         // Limits
750         balanceLimit = InitialSupply / BalanceLimitDivider;
751         sellLimit = InitialSupply / SellLimitDivider;
752         buyLimit = InitialSupply / BuyLimitDivider;
753         // !SECTION Limits, Taxes and Locks
754 
755         // SECTION Exclusions
756         _excluded.add(msg.sender);
757         _excludedFromCoolDown.add(UniswapRouter);
758         _excludedFromCoolDown.add(_UniswapPairAddress);
759         _excludedFromCoolDown.add(address(this));
760         // !SECTION Exclusions
761     }
762 
763     // NOTE Public transfer method
764     function _transfer(
765         address sender,
766         address recipient,
767         uint256 amount
768     ) private {
769         require(sender != address(0), "Transfer from zero");
770 
771         // Botlist check
772         if (isBotlist) {
773             require(
774                 !_botlist[sender] && !_botlist[recipient],
775                 "Botlisted!"
776             );
777         }
778 
779         // Check if the transfer is to be excluded from cooldown and taxes
780         bool isExcluded = (_excluded.contains(sender) ||
781             _excluded.contains(recipient) ||
782             is_auth[sender] ||
783             is_auth[recipient]);
784 
785         bool isContractTransfer = (sender == address(this) ||
786             recipient == address(this));
787 
788         bool isLiquidityTransfer = ((sender == _UniswapPairAddress &&
789             recipient == UniswapRouter) ||
790             (recipient == _UniswapPairAddress && sender == UniswapRouter));
791         if (
792             isContractTransfer || isLiquidityTransfer || isExcluded
793         ) {
794             _whitelistTransfer(sender, recipient, amount);
795         } else {
796             // If not, check if trading is enabled
797             if (!tradingEnabled) {
798                 // except for the owner
799                 if (sender != owner && recipient != owner) {
800                     // and apply anti-snipe if enabled
801                     if (antiSnipe) {
802                         emit Transfer(sender, recipient, 0);
803                         return;
804                     } else {
805                         // or revert if not
806                         require(tradingEnabled, "trading not yet enabled");
807                     }
808                 }
809             }
810 
811             // If trading is enabled, check if the transfer is a buy or a sell
812             bool isBuy = sender == _UniswapPairAddress ||
813                 sender == UniswapRouter;
814             bool isSell = recipient == _UniswapPairAddress ||
815                 recipient == UniswapRouter;
816             // and initiate the transfer accordingly
817             _normalTransfer(sender, recipient, amount, isBuy, isSell);
818 
819         }
820     }
821 
822     // NOTE Transfer method for everyone
823     function _normalTransfer(
824         address sender,
825         address recipient,
826         uint256 amount,
827         bool isBuy,
828         bool isSell
829     ) private {
830         // Read the balances of the recipient locally to save gas as is used twice
831         uint256 recipientBalance = _balances[recipient];
832         // Apply the requirements
833         require(_balances[sender] >= amount, "Transfer exceeds balance");
834         // Prepare the tax variable
835         uint8 tax;
836         // Apply the cooldown for sells
837         if (isSell) {
838             if (!_excludedFromCoolDown.contains(sender)) {
839                 require(
840                     _coolDown[sender] <= block.timestamp || coolDownDisabled,
841                     "Seller in coolDown"
842                 );
843                 _coolDown[sender] = block.timestamp + coolDownTime;
844             }
845             // Sell limit check
846             require(amount <= sellLimit, "Dump protection");
847             tax = _sellTax;
848         } else if (isBuy) {
849             // Balance limit check
850             require(
851                 recipientBalance + amount <= balanceLimit,
852                 "whale protection"
853             );
854             // Buy limit check
855             require(amount <= buyLimit, "whale protection");
856             tax = _buyTax;
857         } else {
858             require(
859                 // Balance limit check for transfers
860                 recipientBalance + amount <= balanceLimit,
861                 "whale protection"
862             );
863             // Update the cooldown for the sender if not excluded
864             if (!_excludedFromCoolDown.contains(sender))
865                 require(
866                     _coolDown[sender] <= block.timestamp || coolDownDisabled,
867                     "Sender in Lock"
868                 );
869             tax = _transferTax;
870         }
871 
872         // Check if the transaction is fit for token swapping
873         if (
874             (sender != _UniswapPairAddress) &&
875             (!manualConversion) &&
876             (!_isSwappingContractModifier)
877         ) _swapContractToken(amount);
878 
879         // Calculating the taxed amount
880         uint256 contractToken = _calculateFee(
881             amount,
882             tax,
883             _liquidityTax + _projectTax 
884         );
885         // Refactoring the various amounts
886         uint256 taxedAmount = amount - (contractToken);
887         _removeToken(sender, amount);
888         _balances[address(this)] += contractToken;
889         _addToken(recipient, taxedAmount);
890         // Emitting the transfer event
891         emit Transfer(sender, recipient, taxedAmount);
892     }
893 
894     function _whitelistTransfer(
895         address sender,
896         address recipient,
897         uint256 amount
898     ) private {
899         // Basic checks
900         require(_balances[sender] >= amount, "Transfer exceeds balance");
901         // Plain transfer
902         _removeToken(sender, amount);
903         _addToken(recipient, amount);
904         // Emitting the transfer event
905         emit Transfer(sender, recipient, amount);
906     }
907 
908     // NOTE To fully support decimal operations, we custom calculate the fees
909     function _calculateFee(
910         uint256 amount,
911         uint8 tax,
912         uint8 taxPercent
913     ) private pure returns (uint256) {
914         return (amount * tax * taxPercent) / 10000;
915     }
916 
917     function _addToken(address addr, uint256 amount) private {
918         uint256 newAmount = _balances[addr] + amount;
919         _balances[addr] = newAmount;
920     }
921 
922     function _removeToken(address addr, uint256 amount) private {
923         uint256 newAmount = _balances[addr] - amount;
924         _balances[addr] = newAmount;
925     }
926 
927     // SECTION Swapping taxes and adding liquidity
928 
929     // NOTE Swap tokens on sells to create liquidity
930     function _swapContractToken(uint256 totalMax) private lockTheSwap {
931         uint256 contractBalance = _balances[address(this)];
932         // Do not swap if the contract balance is lower than the swap treshold
933         if (contractBalance < swapTreshold) {
934             return;
935         }
936 
937         // Calculate the amount of tokens to swap
938         uint16 totalTax = _liquidityTax;
939         uint256 tokenToSwap = swapTreshold;
940         // Avoid swapping more than the total max of the transaction
941         if (swapTreshold > totalMax) {
942             if (isSwapPegged) {
943                 tokenToSwap = totalMax;
944             }
945         }
946         // Avoid swapping if there are no liquidity fees to generate
947         if (totalTax == 0) {
948             return;
949         }
950 
951         // Calculate the amount of tokens to work on for liquidity and project
952         uint256 tokenForLiquidity = (tokenToSwap * _liquidityTax) / totalTax;
953         uint256 tokenForProject = (tokenToSwap * _projectTax) / totalTax;
954         // Divide the liquidity tokens in half to add liquidity
955         uint256 liqToken = tokenForLiquidity / 2;
956         uint256 liqETHToken = tokenForLiquidity - liqToken;
957         // Calculate the amount of ETH to swap
958         uint256 swapToken = liqETHToken +
959             tokenForProject;
960         // Swap the tokens for ETH
961         uint256 initialETHBalance = address(this).balance;
962         _swapTokenForETH(swapToken);
963         // Calculate the amount of ETH generated and the amount of ETH to add liquidity with
964         uint256 newETH = (address(this).balance - initialETHBalance);
965         uint256 liqETH = (newETH * liqETHToken) / swapToken;
966         // Add liquidity
967         _addLiquidity(liqToken, liqETH);
968         // Add the project ETH to the project balance
969         uint256 generatedETH = (address(this).balance - initialETHBalance);
970         projectBalance += generatedETH;
971     }
972 
973     // NOTE Basic swap function for swapping tokens on Uniswap-v2 compatible routers
974     function _swapTokenForETH(uint256 amount) private {
975         // Preapprove the router to spend the tokens
976         _approve(address(this), address(_UniswapRouter), amount);
977 
978         address[] memory path = new address[](2);
979         path[0] = address(this);
980         path[1] = _UniswapRouter.WETH();
981 
982         _UniswapRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
983             amount,
984             0,
985             path,
986             address(this),
987             block.timestamp
988         );
989     }
990 
991     // NOTE Basic add liquidity function for adding liquidity on Uniswap-v2 compatible routers
992     function _addLiquidity(uint256 tokenamount, uint256 ETHamount) private {
993         // Approve the router to spend the tokens
994         _approve(address(this), address(_UniswapRouter), tokenamount);
995 
996         _UniswapRouter.addLiquidityETH{value: ETHamount}(
997             address(this),
998             tokenamount,
999             0,
1000             0,
1001             address(this),
1002             block.timestamp
1003         );
1004     }
1005     // !SECTION Swapping taxes and adding liquidity
1006 
1007     /// SECTION Utility functions
1008 
1009     function getLimits()
1010         public
1011         view
1012         returns (uint256 balance, uint256 sell)
1013     {
1014         return (balanceLimit, sellLimit);
1015     }
1016 
1017     function getTaxes()
1018         public
1019         view
1020         returns (
1021             uint256 projectShare,
1022             uint256 liquidityShare,
1023             uint256 buyTax,
1024             uint256 sellTax,
1025             uint256 transferTax
1026         )
1027     {
1028         return (
1029             _projectTax,
1030             _liquidityTax,
1031             _buyTax,
1032             _sellTax,
1033             _transferTax
1034         );
1035     }
1036 
1037     // NOTE The actual cooldown time
1038     function getCoolDownTimeInSeconds() public view returns (uint256) {
1039         return coolDownTime;
1040     }
1041 
1042     // NOTE Pegged swap means that the contract won't dump when the swap treshold is reached
1043     function SetPeggedSwap(bool isPegged) public onlyAuth {
1044         isSwapPegged = isPegged;
1045     }
1046 
1047     // NOTE The token amount that triggers swap on sells
1048     function SetSwapTreshold(uint256 max) public onlyAuth {
1049         swapTreshold = max;
1050     }
1051     // !SECTION Utility functions
1052 
1053     function BotlistAddress(address addy, bool booly) public onlyAuth {
1054         _botlist[addy] = booly;
1055     }
1056 
1057     function ExcludeAccountFromFees(address account) public onlyAuth {
1058         _excluded.add(account);
1059     }
1060 
1061     function IncludeAccountToFees(address account) public onlyAuth {
1062         _excluded.remove(account);
1063     }
1064 
1065     function ExcludeAccountFromCoolDown(address account) public onlyAuth {
1066         _excludedFromCoolDown.add(account);
1067     }
1068 
1069     function IncludeAccountToCoolDown(address account) public onlyAuth {
1070         _excludedFromCoolDown.remove(account);
1071     }
1072 
1073     function WithdrawProjectETH() public onlyAuth {
1074         uint256 amount = projectBalance;
1075         projectBalance = 0;
1076         address sender = msg.sender;
1077         (bool sent, ) = sender.call{value: (amount)}("");
1078         require(sent, "withdraw failed");
1079     }
1080 
1081     function SwitchManualETHConversion(bool manual) public onlyAuth {
1082         manualConversion = manual;
1083     }
1084 
1085     function DisableCoolDown(bool disabled) public onlyAuth {
1086         coolDownDisabled = disabled;
1087     }
1088 
1089     function SetCoolDownTime(uint256 coolDownSeconds) public onlyAuth {
1090         coolDownTime = coolDownSeconds;
1091     }
1092 
1093     function SetTaxes(
1094         uint8 projectTaxes,
1095         uint8 liquidityTaxes,
1096         uint8 buyTax,
1097         uint8 sellTax,
1098         uint8 transferTax
1099     ) public onlyAuth {
1100         uint8 totalTax =
1101             projectTaxes +
1102             liquidityTaxes;
1103         require(totalTax == 100, "Project + Liquidity taxes needs to equal 100%");
1104         _projectTax = projectTaxes;
1105         _liquidityTax = liquidityTaxes;
1106 
1107         _buyTax = buyTax;
1108         _sellTax = sellTax;
1109         _transferTax = transferTax;
1110     }
1111 
1112     function ManualGenerateTokenSwapBalance(uint256 _qty)
1113         public
1114         onlyAuth
1115     {
1116         _swapContractToken(_qty * 10**9);
1117     }
1118 
1119     function UpdateLimits(uint256 newBalanceLimit, uint256 newSellLimit)
1120         public
1121         onlyAuth
1122     {
1123         newBalanceLimit = newBalanceLimit * 10**_decimals;
1124         newSellLimit = newSellLimit * 10**_decimals;
1125         balanceLimit = newBalanceLimit;
1126         sellLimit = newSellLimit;
1127     }
1128 
1129     function EnableTrading(bool booly) public onlyAuth {
1130         tradingEnabled = booly;
1131     }
1132 
1133     function LiquidityTokenAddress(address liquidityTokenAddress)
1134         public
1135         onlyAuth
1136     {
1137         _UniswapPairAddress = liquidityTokenAddress;
1138     }
1139 
1140     function RescueTokens(address tknAddress) public onlyAuth {
1141         IERC20 token = IERC20(tknAddress);
1142         uint256 ourBalance = token.balanceOf(address(this));
1143         require(ourBalance > 0, "No tokens in our balance");
1144         token.transfer(msg.sender, ourBalance);
1145     }
1146 
1147     function setBotlistEnabled(bool isBotlistEnabled)
1148         public
1149         onlyAuth
1150     {
1151         isBotlist = isBotlistEnabled;
1152     }
1153 
1154     function setContractTokenSwapManual(bool manual) public onlyAuth {
1155         isTokenSwapManual = manual;
1156     }
1157 
1158     function setBotlistedAddress(address toBotlist)
1159         public
1160         onlyAuth
1161     {
1162         _botlist[toBotlist] = true;
1163     }
1164 
1165     function removeBotlistedAddress(address toRemove)
1166         public
1167         onlyAuth
1168     {
1169         _botlist[toRemove] = false;
1170     }
1171 
1172     function AvoidLocks() public onlyAuth {
1173         (bool sent, ) = msg.sender.call{value: (address(this).balance)}("");
1174         require(sent);
1175     }
1176 
1177     function getOwner() external view override returns (address) {
1178         return owner;
1179     }
1180 
1181     function name() external pure override returns (string memory) {
1182         return _name;
1183     }
1184 
1185     function symbol() external pure override returns (string memory) {
1186         return _symbol;
1187     }
1188 
1189     function decimals() external pure override returns (uint8) {
1190         return _decimals;
1191     }
1192 
1193     function totalSupply() external view override returns (uint256) {
1194         return _circulatingSupply;
1195     }
1196 
1197     function balanceOf(address account)
1198         external
1199         view
1200         override
1201         returns (uint256)
1202     {
1203         return _balances[account];
1204     }
1205 
1206     function transfer(address recipient, uint256 amount)
1207         external
1208         override
1209         returns (bool)
1210     {
1211         _transfer(msg.sender, recipient, amount);
1212         return true;
1213     }
1214 
1215     function allowance(address _owner, address spender)
1216         external
1217         view
1218         override
1219         returns (uint256)
1220     {
1221         return _allowances[_owner][spender];
1222     }
1223 
1224     function approve(address spender, uint256 amount)
1225         external
1226         override
1227         returns (bool)
1228     {
1229         _approve(msg.sender, spender, amount);
1230         return true;
1231     }
1232 
1233     function _approve(
1234         address _owner,
1235         address spender,
1236         uint256 amount
1237     ) private {
1238         require(_owner != address(0), "Approve from zero");
1239         require(spender != address(0), "Approve to zero");
1240 
1241         _allowances[_owner][spender] = amount;
1242         emit Approval(_owner, spender, amount);
1243     }
1244 
1245     function transferFrom(
1246         address sender,
1247         address recipient,
1248         uint256 amount
1249     ) external override returns (bool) {
1250         _transfer(sender, recipient, amount);
1251 
1252         uint256 currentAllowance = _allowances[sender][msg.sender];
1253         require(currentAllowance >= amount, "Transfer > allowance");
1254 
1255         _approve(sender, msg.sender, currentAllowance - amount);
1256         return true;
1257     }
1258 
1259     function increaseAllowance(address spender, uint256 addedValue)
1260         external
1261         returns (bool)
1262     {
1263         _approve(
1264             msg.sender,
1265             spender,
1266             _allowances[msg.sender][spender] + addedValue
1267         );
1268         return true;
1269     }
1270 
1271     function decreaseAllowance(address spender, uint256 subtractedValue)
1272         external
1273         returns (bool)
1274     {
1275         uint256 currentAllowance = _allowances[msg.sender][spender];
1276         require(currentAllowance >= subtractedValue, "<0 allowance");
1277 
1278         _approve(msg.sender, spender, currentAllowance - subtractedValue);
1279         return true;
1280     }
1281 
1282     // White Rabbit Derivations
1283 
1284     function messageFromTeam(string memory message) public onlyAuth {
1285         _answerThePhone(message);
1286     }
1287 
1288     function changeWebsite(string memory newWebsite) public onlyAuth {
1289         _changeWebsite(newWebsite);
1290     }
1291 
1292 }