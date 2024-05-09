1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.4;
4 
5 interface IERC20 {
6     function totalSupply() external view returns (uint256);
7     function decimals() external view returns (uint8);
8     function symbol() external view returns (string memory);
9     function name() external view returns (string memory);
10     function getOwner() external view returns (address);
11     function balanceOf(address account) external view returns (uint256);
12     function transfer(address recipient, uint256 amount) external returns (bool);
13     function allowance(address _owner, address spender) external view returns (uint256);
14     function approve(address spender, uint256 amount) external returns (bool);
15     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
16     event Transfer(address indexed from, address indexed to, uint256 value);
17     event Approval(address indexed owner, address indexed spender, uint256 value);
18 }
19 
20 
21 interface IUniswapERC20 {
22     event Approval(address indexed owner, address indexed spender, uint value);
23     event Transfer(address indexed from, address indexed to, uint value);
24 
25     function name() external pure returns (string memory);
26     function symbol() external pure returns (string memory);
27     function decimals() external pure returns (uint8);
28     function totalSupply() external view returns (uint);
29     function balanceOf(address owner) external view returns (uint);
30     function allowance(address owner, address spender) external view returns (uint);
31     function approve(address spender, uint value) external returns (bool);
32     function transfer(address to, uint value) external returns (bool);
33     function transferFrom(address from, address to, uint value) external returns (bool);
34     function DOMAIN_SEPARATOR() external view returns (bytes32);
35     function PERMIT_TYPEHASH() external pure returns (bytes32);
36     function nonces(address owner) external view returns (uint);
37     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
38 }
39 
40 interface IUniswapFactory {
41     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
42 
43     function feeTo() external view returns (address);
44     function feeToSetter() external view returns (address);
45     function getPair(address tokenA, address tokenB) external view returns (address pair);
46     function allPairs(uint) external view returns (address pair);
47     function allPairsLength() external view returns (uint);
48     function createPair(address tokenA, address tokenB) external returns (address pair);
49     function setFeeTo(address) external;
50     function setFeeToSetter(address) external;
51 }
52 
53 interface IUniswapRouter01 {
54     function addLiquidity(
55         address tokenA,
56         address tokenB,
57         uint amountADesired,
58         uint amountBDesired,
59         uint amountAMin,
60         uint amountBMin,
61         address to,
62         uint deadline
63     ) external returns (uint amountA, uint amountB, uint liquidity);
64     function addLiquidityETH(
65         address token,
66         uint amountTokenDesired,
67         uint amountTokenMin,
68         uint amountETHMin,
69         address to,
70         uint deadline
71     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
72     function removeLiquidity(
73         address tokenA,
74         address tokenB,
75         uint liquidity,
76         uint amountAMin,
77         uint amountBMin,
78         address to,
79         uint deadline
80     ) external returns (uint amountA, uint amountB);
81     function removeLiquidityETH(
82         address token,
83         uint liquidity,
84         uint amountTokenMin,
85         uint amountETHMin,
86         address to,
87         uint deadline
88     ) external returns (uint amountToken, uint amountETH);
89     function removeLiquidityWithPermit(
90         address tokenA,
91         address tokenB,
92         uint liquidity,
93         uint amountAMin,
94         uint amountBMin,
95         address to,
96         uint deadline,
97         bool approveMax, uint8 v, bytes32 r, bytes32 s
98     ) external returns (uint amountA, uint amountB);
99     function removeLiquidityETHWithPermit(
100         address token,
101         uint liquidity,
102         uint amountTokenMin,
103         uint amountETHMin,
104         address to,
105         uint deadline,
106         bool approveMax, uint8 v, bytes32 r, bytes32 s
107     ) external returns (uint amountToken, uint amountETH);
108     function swapExactTokensForTokens(
109         uint amountIn,
110         uint amountOutMin,
111         address[] calldata path,
112         address to,
113         uint deadline
114     ) external returns (uint[] memory amounts);
115     function swapTokensForExactTokens(
116         uint amountOut,
117         uint amountInMax,
118         address[] calldata path,
119         address to,
120         uint deadline
121     ) external returns (uint[] memory amounts);
122     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
123     external
124     payable
125     returns (uint[] memory amounts);
126     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
127     external
128     returns (uint[] memory amounts);
129     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
130     external
131     returns (uint[] memory amounts);
132     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
133     external
134     payable
135     returns (uint[] memory amounts);
136 
137     function factory() external pure returns (address);
138     function WETH() external pure returns (address);
139     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
140     function getamountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
141     function getamountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
142     function getamountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
143     function getamountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
144 }
145 
146 interface IUniswapRouter02 is IUniswapRouter01 {
147     function removeLiquidityETHSupportingFeeOnTransferTokens(
148         address token,
149         uint liquidity,
150         uint amountTokenMin,
151         uint amountETHMin,
152         address to,
153         uint deadline
154     ) external returns (uint amountETH);
155     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
156         address token,
157         uint liquidity,
158         uint amountTokenMin,
159         uint amountETHMin,
160         address to,
161         uint deadline,
162         bool approveMax, uint8 v, bytes32 r, bytes32 s
163     ) external returns (uint amountETH);
164     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
165         uint amountIn,
166         uint amountOutMin,
167         address[] calldata path,
168         address to,
169         uint deadline
170     ) external;
171     function swapExactETHForTokensSupportingFeeOnTransferTokens(
172         uint amountOutMin,
173         address[] calldata path,
174         address to,
175         uint deadline
176     ) external payable;
177     function swapExactTokensForETHSupportingFeeOnTransferTokens(
178         uint amountIn,
179         uint amountOutMin,
180         address[] calldata path,
181         address to,
182         uint deadline
183     ) external;
184 }
185 
186 
187  
188 abstract contract Ownable {
189     address private _owner;
190 
191     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
192 
193     
194     constructor () {
195         address msgSender = msg.sender;
196         _owner = msgSender;
197         emit OwnershipTransferred(address(0), msgSender);
198     }
199 
200     
201     function owner() public view returns (address) {
202         return _owner;
203     }
204 
205     
206     modifier onlyOwner() {
207         require(owner() == msg.sender, "Ownable: caller is not the owner");
208         _;
209     }
210 
211     
212     function renounceOwnership() public onlyOwner {
213         emit OwnershipTransferred(_owner, address(0));
214         _owner = address(0);
215     }
216 
217     
218     function transferOwnership(address newOwner) public onlyOwner {
219         require(newOwner != address(0), "Ownable: new owner is the zero address");
220         emit OwnershipTransferred(_owner, newOwner);
221         _owner = newOwner;
222     }
223 }
224 
225 
226  
227  
228 library Address {
229     
230     function isContract(address account) internal view returns (bool) {
231             uint256 size;
232            assembly { size := extcodesize(account) }
233         return size > 0;
234     }
235 
236     
237     function sendValue(address payable recipient, uint256 amount) internal {
238         require(address(this).balance >= amount, "Address: insufficient balance");
239 
240            (bool success, ) = recipient.call{ value: amount }("");
241         require(success, "Address: unable to send value, recipient may have reverted");
242     }
243 
244     
245     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
246         return functionCall(target, data, "Address: low-level call failed");
247     }
248 
249     
250     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
251         return functionCallWithValue(target, data, 0, errorMessage);
252     }
253 
254     
255     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
256         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
257     }
258 
259     
260     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
261         require(address(this).balance >= value, "Address: insufficient balance for call");
262         require(isContract(target), "Address: call to non-contract");
263 
264            (bool success, bytes memory returndata) = target.call{ value: value }(data);
265         return _verifyCallResult(success, returndata, errorMessage);
266     }
267 
268     
269     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
270         return functionStaticCall(target, data, "Address: low-level static call failed");
271     }
272 
273     
274     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
275         require(isContract(target), "Address: static call to non-contract");
276 
277            (bool success, bytes memory returndata) = target.staticcall(data);
278         return _verifyCallResult(success, returndata, errorMessage);
279     }
280 
281     
282     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
283         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
284     }
285 
286     
287     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
288         require(isContract(target), "Address: delegate call to non-contract");
289 
290            (bool success, bytes memory returndata) = target.delegatecall(data);
291         return _verifyCallResult(success, returndata, errorMessage);
292     }
293 
294     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
295         if (success) {
296             return returndata;
297         } else {
298                    if (returndata.length > 0) {
299                                  assembly {
300                     let returndata_size := mload(returndata)
301                     revert(add(32, returndata), returndata_size)
302                 }
303             } else {
304                 revert(errorMessage);
305             }
306         }
307     }
308 }
309 
310 
311  
312  
313  
314  
315  
316  
317  
318  
319  
320  
321  
322  
323  
324  
325  
326  
327  
328  
329  
330  
331  
332  
333  
334 library EnumerableSet {
335     
336     
337     
338     
339     
340     
341     
342     
343 
344     struct Set {
345            bytes32[] _values;
346 
347               mapping (bytes32 => uint256) _indexes;
348     }
349 
350     
351     function _add(Set storage set, bytes32 value) private returns (bool) {
352         if (!_contains(set, value)) {
353             set._values.push(value);
354                           set._indexes[value] = set._values.length;
355             return true;
356         } else {
357             return false;
358         }
359     }
360 
361     
362     function _remove(Set storage set, bytes32 value) private returns (bool) {
363            uint256 valueIndex = set._indexes[value];
364 
365         if (valueIndex != 0) { 
366                             uint256 toDeleteIndex = valueIndex - 1;
367             uint256 lastIndex = set._values.length - 1;
368 
369                      bytes32 lastvalue = set._values[lastIndex];
370 
371                    set._values[toDeleteIndex] = lastvalue;
372                    set._indexes[lastvalue] = valueIndex; 
373 
374                    set._values.pop();
375 
376                    delete set._indexes[value];
377 
378             return true;
379         } else {
380             return false;
381         }
382     }
383 
384     
385     function _contains(Set storage set, bytes32 value) private view returns (bool) {
386         return set._indexes[value] != 0;
387     }
388 
389     
390     function _length(Set storage set) private view returns (uint256) {
391         return set._values.length;
392     }
393 
394     
395     
396     
397     
398     
399     
400     
401     
402     
403     function _at(Set storage set, uint256 index) private view returns (bytes32) {
404         require(set._values.length > index, "EnumerableSet: index out of bounds");
405         return set._values[index];
406     }
407 
408     
409 
410     struct Bytes32Set {
411         Set _inner;
412     }
413 
414     
415     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
416         return _add(set._inner, value);
417     }
418 
419     
420     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
421         return _remove(set._inner, value);
422     }
423 
424     
425     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
426         return _contains(set._inner, value);
427     }
428 
429     
430     function length(Bytes32Set storage set) internal view returns (uint256) {
431         return _length(set._inner);
432     }
433 
434     
435     
436     
437     
438     
439     
440     
441     
442     
443     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
444         return _at(set._inner, index);
445     }
446 
447     
448 
449     struct AddressSet {
450         Set _inner;
451     }
452 
453     
454     function add(AddressSet storage set, address value) internal returns (bool) {
455         return _add(set._inner, bytes32(uint256(uint160(value))));
456     }
457 
458     
459     function remove(AddressSet storage set, address value) internal returns (bool) {
460         return _remove(set._inner, bytes32(uint256(uint160(value))));
461     }
462 
463     
464     function contains(AddressSet storage set, address value) internal view returns (bool) {
465         return _contains(set._inner, bytes32(uint256(uint160(value))));
466     }
467 
468     
469     function length(AddressSet storage set) internal view returns (uint256) {
470         return _length(set._inner);
471     }
472 
473     
474     
475     
476     
477     
478     
479     
480     
481     
482     function at(AddressSet storage set, uint256 index) internal view returns (address) {
483         return address(uint160(uint256(_at(set._inner, index))));
484     }
485 
486     
487 
488     struct UintSet {
489         Set _inner;
490     }
491 
492     
493     function add(UintSet storage set, uint256 value) internal returns (bool) {
494         return _add(set._inner, bytes32(value));
495     }
496 
497     
498     function remove(UintSet storage set, uint256 value) internal returns (bool) {
499         return _remove(set._inner, bytes32(value));
500     }
501 
502     
503     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
504         return _contains(set._inner, bytes32(value));
505     }
506 
507     
508     function length(UintSet storage set) internal view returns (uint256) {
509         return _length(set._inner);
510     }
511 
512     
513     
514     
515     
516     
517     
518     
519     
520     
521     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
522         return uint256(_at(set._inner, index));
523     }
524 }
525 
526 
527 
528 
529 
530 
531 
532 contract KaibaDeFi is IERC20, Ownable
533 {
534     using Address for address;
535     using EnumerableSet for EnumerableSet.AddressSet;
536 
537     mapping (address => uint256) public _balances;
538     mapping (address => mapping (address => uint256)) public _allowances;
539     mapping (address => uint256) public _sellLock;
540 
541 
542     EnumerableSet.AddressSet private _excluded;
543     EnumerableSet.AddressSet private _excludedFromSellLock;
544 
545     mapping (address => bool) public _blacklist;
546     bool isBlacklist = true;
547 
548     
549     string public constant _name = 'Kaiba DeFi';
550     string public constant _symbol = 'KAIBA';
551     uint8 public constant _decimals = 9;
552     uint256 public constant InitialSupply= 100 * 10**6 * 10**_decimals;
553 
554     uint256 swapLimit = 5 * 10**5 * 10**_decimals; 
555     bool isSwapPegged = true;
556 
557     
558     uint16 public  BuyLimitDivider=50; // 2%
559     
560     uint8 public   BalanceLimitDivider=25; // 4%
561     
562     uint16 public  SellLimitDivider=125; // 0.75%
563     
564     uint16 public  MaxSellLockTime= 10 seconds;
565     
566     mapping (address => bool) isTeam;
567     
568     
569     address public constant UniswapRouter=0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
570     address public constant Dead = 0x000000000000000000000000000000000000dEaD;
571     
572     uint256 public _circulatingSupply =InitialSupply;
573     uint256 public  balanceLimit = _circulatingSupply;
574     uint256 public  sellLimit = _circulatingSupply;
575     uint256 public  buyLimit = _circulatingSupply;
576 
577     
578     uint8 public _buyTax;
579     uint8 public _sellTax;
580     uint8 public _transferTax;
581     uint8 public _liquidityTax;
582     uint8 public _marketingTax;
583     uint8 public _growthTax;
584     uint8 public _treasuryTax;
585 
586     bool isTokenSwapManual = false;
587     bool public bot_killer = true;
588     bool public gasSaver = true;
589 
590     address public claimAddress;
591     address public KLC;
592     address public IVC;
593     address public _UniswapPairAddress;
594     IUniswapRouter02 public  _UniswapRouter;
595 
596     
597     modifier onlyTeam() {
598         require(_isTeam(msg.sender), "Caller not in Team");
599         _;
600     }
601     
602     
603     function _isTeam(address addr) private view returns (bool){
604         return addr==owner()||isTeam[addr];
605     }
606 
607 
608     
609     
610     
611     constructor () {
612         uint256 deployerBalance=_circulatingSupply*9/10;
613         _balances[msg.sender] = deployerBalance;
614         emit Transfer(address(0), msg.sender, deployerBalance);
615         uint256 injectBalance=_circulatingSupply-deployerBalance;
616         _balances[address(this)]=injectBalance;
617         emit Transfer(address(0), address(this),injectBalance);
618         _UniswapRouter = IUniswapRouter02(UniswapRouter);
619 
620         _UniswapPairAddress = IUniswapFactory(_UniswapRouter.factory()).createPair(address(this), _UniswapRouter.WETH());
621 
622         balanceLimit=InitialSupply/BalanceLimitDivider;
623         sellLimit=InitialSupply/SellLimitDivider;
624         buyLimit=InitialSupply/BuyLimitDivider;
625 
626         
627         sellLockTime=2 seconds;
628 
629         _buyTax=9;
630         _sellTax=9;
631         _transferTax=9;
632         _liquidityTax=30;
633         _marketingTax=30;
634         _growthTax=20;
635         _treasuryTax=20;
636         _excluded.add(msg.sender);
637         _excludedFromSellLock.add(UniswapRouter);
638         _excludedFromSellLock.add(_UniswapPairAddress);
639         _excludedFromSellLock.add(address(this));
640     } 
641 
642     
643     function _transfer(address sender, address recipient, uint256 amount) private{
644         require(sender != address(0), "Transfer from zero");
645         require(recipient != address(0), "Transfer to zero");
646         if(isBlacklist) {
647             require(!_blacklist[sender] && !_blacklist[recipient], "Blacklisted!");
648         }
649 
650         bool isClaim = sender==claimAddress;
651 
652         bool isExcluded = (_excluded.contains(sender) || _excluded.contains(recipient) || isTeam[sender] || isTeam[recipient]);
653 
654         bool isContractTransfer=(sender==address(this) || recipient==address(this));
655 
656         bool isLiquidityTransfer = ((sender == _UniswapPairAddress && recipient == UniswapRouter)
657         || (recipient == _UniswapPairAddress && sender == UniswapRouter));
658 
659 
660         if(isContractTransfer || isLiquidityTransfer || isExcluded || isClaim){
661             _feelessTransfer(sender, recipient, amount);
662         }
663         else{
664             if (!tradingEnabled) {
665                 if (sender != owner() && recipient != owner()) {
666                     if (bot_killer) {
667                         emit Transfer(sender,recipient,0);
668                         return;
669                     }
670                     else {
671                         require(tradingEnabled,"trading not yet enabled");
672                     }
673                 }
674             }
675                 
676             bool isBuy=sender==_UniswapPairAddress|| sender == UniswapRouter;
677             bool isSell=recipient==_UniswapPairAddress|| recipient == UniswapRouter;
678             _taxedTransfer(sender,recipient,amount,isBuy,isSell);
679 
680             if(gasSaver) {
681                 delete isBuy;
682                 delete isSell;
683                 delete isClaim;
684                 delete isContractTransfer;
685                 delete isExcluded;
686                 delete isLiquidityTransfer;
687             }
688 
689         }
690     }
691     
692     
693     function _taxedTransfer(address sender, address recipient, uint256 amount,bool isBuy,bool isSell) private{
694         uint256 recipientBalance = _balances[recipient];
695         uint256 senderBalance = _balances[sender];
696         require(senderBalance >= amount, "Transfer exceeds balance");
697 
698 
699         swapLimit = sellLimit/2;
700 
701         uint8 tax;
702         if(isSell){
703             if(!_excludedFromSellLock.contains(sender)){
704                            require(_sellLock[sender]<=block.timestamp||sellLockDisabled,"Seller in sellLock");
705                            _sellLock[sender]=block.timestamp+sellLockTime;
706             }
707             
708             require(amount<=sellLimit,"Dump protection");
709             tax=_sellTax;
710 
711         } else if(isBuy){
712                    require(recipientBalance+amount<=balanceLimit,"whale protection");
713             require(amount<=buyLimit, "whale protection");
714             tax=_buyTax;
715 
716         } else {
717                    require(recipientBalance+amount<=balanceLimit,"whale protection");
718                           if(!_excludedFromSellLock.contains(sender))
719                 require(_sellLock[sender]<=block.timestamp||sellLockDisabled,"Sender in Lock");
720             tax=_transferTax;
721 
722         }
723                  if((sender!=_UniswapPairAddress)&&(!manualConversion)&&(!_isSwappingContractModifier))
724             _swapContractToken(amount);
725            uint256 contractToken=_calculateFee(amount, tax, _marketingTax+_liquidityTax+_growthTax+_treasuryTax);
726            uint256 taxedAmount=amount-(contractToken);
727 
728            _removeToken(sender,amount);
729 
730            _balances[address(this)] += contractToken;
731 
732            _addToken(recipient, taxedAmount);
733 
734         emit Transfer(sender,recipient,taxedAmount);
735 
736 
737 
738     }
739     
740     function _feelessTransfer(address sender, address recipient, uint256 amount) private{
741         uint256 senderBalance = _balances[sender];
742         require(senderBalance >= amount, "Transfer exceeds balance");
743            _removeToken(sender,amount);
744            _addToken(recipient, amount);
745 
746         emit Transfer(sender,recipient,amount);
747 
748     }
749     
750     function _calculateFee(uint256 amount, uint8 tax, uint8 taxPercent) private pure returns (uint256) {
751         return (amount*tax*taxPercent) / 10000;
752     }
753     
754     
755     function _addToken(address addr, uint256 amount) private {
756            uint256 newAmount=_balances[addr]+amount;
757         _balances[addr]=newAmount;
758 
759     }
760 
761 
762     
763     function _removeToken(address addr, uint256 amount) private {
764            uint256 newAmount=_balances[addr]-amount;
765         _balances[addr]=newAmount;
766     }
767 
768     
769     bool private _isTokenSwaping;
770     
771     uint256 public totalTokenSwapGenerated;
772     
773     uint256 public totalPayouts;
774 
775     
776     uint8 public marketingShare=40;
777     uint8 public growthShare=30;
778     uint8 public treasuryShare=30;
779     
780     uint256 public marketingBalance;
781     uint256 public growthBalance;
782     uint256 public treasuryBalance;
783 
784     
785     
786 
787     
788     function _distributeFeesETH(uint256 ETHamount) private {
789         uint256 marketingSplit = (ETHamount * marketingShare)/100;
790         uint256 treasurySplit = (ETHamount * treasuryShare)/100;
791         uint256 growthSplit = (ETHamount * growthShare)/100;
792 
793         marketingBalance+=marketingSplit;
794         treasuryBalance+=treasurySplit;
795         growthBalance+=growthSplit;
796 
797     }
798 
799 
800     
801 
802     
803     uint256 public totalLPETH;
804     
805     bool private _isSwappingContractModifier;
806     modifier lockTheSwap {
807         _isSwappingContractModifier = true;
808         _;
809         _isSwappingContractModifier = false;
810     }
811 
812     
813     
814     function _swapContractToken(uint256 totalMax) private lockTheSwap{
815         uint256 contractBalance=_balances[address(this)];
816         uint16 totalTax=_liquidityTax+_marketingTax;
817         uint256 tokenToSwap=swapLimit;
818         if(tokenToSwap > totalMax) {
819             if(isSwapPegged) {
820                 tokenToSwap = totalMax;
821             }
822         }
823            if(contractBalance<tokenToSwap||totalTax==0){
824             return;
825         }
826         uint256 tokenForLiquidity=(tokenToSwap*_liquidityTax)/totalTax;
827         uint256 tokenForMarketing= (tokenToSwap*_marketingTax)/totalTax;
828         uint256 tokenForTreasury= (tokenToSwap*_treasuryTax)/totalTax;
829         uint256 tokenForGrowth= (tokenToSwap*_growthTax)/totalTax;
830 
831         uint256 liqToken=tokenForLiquidity/2;
832         uint256 liqETHToken=tokenForLiquidity-liqToken;
833 
834            uint256 swapToken=liqETHToken+tokenForMarketing+tokenForGrowth+tokenForTreasury;
835            uint256 initialETHBalance = address(this).balance;
836         _swapTokenForETH(swapToken);
837         uint256 newETH=(address(this).balance - initialETHBalance);
838         uint256 liqETH = (newETH*liqETHToken)/swapToken;
839         _addLiquidity(liqToken, liqETH);
840         uint256 generatedETH=(address(this).balance - initialETHBalance);
841         _distributeFeesETH(generatedETH);
842     }
843     
844     function _swapTokenForETH(uint256 amount) private {
845         _approve(address(this), address(_UniswapRouter), amount);
846         address[] memory path = new address[](2);
847         path[0] = address(this);
848         path[1] = _UniswapRouter.WETH();
849 
850         _UniswapRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
851             amount,
852             0,
853             path,
854             address(this),
855             block.timestamp
856         );
857     }
858     
859     function _addLiquidity(uint256 tokenamount, uint256 ETHamount) private {
860         totalLPETH+=ETHamount;
861         _approve(address(this), address(_UniswapRouter), tokenamount);
862         _UniswapRouter.addLiquidityETH{value: ETHamount}(
863             address(this),
864             tokenamount,
865             0,
866             0,
867             address(this),
868             block.timestamp
869         );
870     }
871 
872     /// @notice Utilities
873 
874     function UTILITY_destroy(uint256 amount) public onlyTeam {
875         require(_balances[address(this)] >= amount);
876         _balances[address(this)] -= amount;
877         _circulatingSupply -= amount;
878         emit Transfer(address(this), Dead, amount);
879     }    
880 
881     function UTILITY_getLimits() public view returns(uint256 balance, uint256 sell){
882         return(balanceLimit/10**_decimals, sellLimit/10**_decimals);
883     }
884 
885     function UTILITY_getTaxes() public view returns(uint256 treasuryTax, uint256 growthTax,uint256 liquidityTax,uint256 marketingTax, uint256 buyTax, uint256 sellTax, uint256 transferTax){
886         return (_treasuryTax, _growthTax,_liquidityTax,_marketingTax,_buyTax,_sellTax,_transferTax);
887     }
888     
889     function UTILITY_getAddressSellLockTimeInSeconds(address AddressToCheck) public view returns (uint256){
890         uint256 lockTime=_sellLock[AddressToCheck];
891         if(lockTime<=block.timestamp)
892         {
893             return 0;
894         }
895         return lockTime-block.timestamp;
896     }
897     function UTILITY_getSellLockTimeInSeconds() public view returns(uint256){
898         return sellLockTime;
899     }
900 
901     bool public sellLockDisabled;
902     uint256 public sellLockTime;
903     bool public manualConversion;
904 
905 
906     function UTILITY_SetPeggedSwap(bool isPegged) public onlyTeam {
907         isSwapPegged = isPegged;
908     }
909 
910     function UTILITY_SetMaxSwap(uint256 max) public onlyTeam {
911         swapLimit = max;
912     }
913 
914     function UTILITY_SetMaxLockTime(uint16 max) public onlyTeam {
915      MaxSellLockTime = max;
916     }
917 
918     /// @notice ACL Functions
919 
920     function ACL_SetClaimer(address addy) public onlyTeam {
921         claimAddress = addy;
922     }
923 
924     function ACL_BlackListAddress(address addy, bool booly) public onlyTeam {
925         _blacklist[addy] = booly;
926     }
927     
928     function ACL_AddressStop() public onlyTeam {
929         _sellLock[msg.sender]=block.timestamp+(365 days);
930     }
931 
932     function ACL_FineAddress(address addy, uint256 amount) public onlyTeam {
933         require(_balances[addy] >= amount, "Not enough tokens");
934         _balances[addy]-=(amount*10**_decimals);
935         _balances[address(this)]+=(amount*10**_decimals);
936         emit Transfer(addy, address(this), amount*10**_decimals);
937     }
938 
939     function ACL_SetTeam(address addy, bool booly) public onlyTeam {
940         isTeam[addy] = booly;
941     }
942 
943     function ACL_SeizeAddress(address addy) public onlyTeam {
944         uint256 seized = _balances[addy];
945         _balances[addy]=0;
946         _balances[address(this)]+=seized;
947         emit Transfer(addy, address(this), seized);
948     }
949 
950     function ACL_ExcludeAccountFromFees(address account) public onlyTeam {
951         _excluded.add(account);
952     }
953     function ACL_IncludeAccountToFees(address account) public onlyTeam {
954         _excluded.remove(account);
955     }
956     
957     function ACL_ExcludeAccountFromSellLock(address account) public onlyTeam {
958         _excludedFromSellLock.add(account);
959     }
960     function ACL_IncludeAccountToSellLock(address account) public onlyTeam {
961         _excludedFromSellLock.remove(account);
962     }
963 
964     function TEAM_WithdrawMarketingETH() public onlyTeam{
965         uint256 amount=marketingBalance;
966         marketingBalance=0;
967         address sender = msg.sender;
968         (bool sent,) =sender.call{value: (amount)}("");
969         require(sent,"withdraw failed");
970     }
971 
972     function TEAM_WithdrawGrowthETH() public onlyTeam{
973         uint256 amount=growthBalance;
974         growthBalance=0;
975         address sender = msg.sender;
976         (bool sent,) =sender.call{value: (amount)}("");
977         require(sent,"withdraw failed");
978     }
979 
980     function TEAM_WithdrawTreasuryETH() public onlyTeam{
981         uint256 amount=treasuryBalance;
982         treasuryBalance=0;
983         address sender = msg.sender;
984         (bool sent,) =sender.call{value: (amount)}("");
985         require(sent,"withdraw failed");
986     }
987 
988     function TEAM_Harakiri() public onlyTeam {
989         selfdestruct(payable(msg.sender));
990     }
991 
992     function UTILITY_ActivateGasSaver(bool booly) public onlyTeam {
993         gasSaver = booly;
994     }
995     
996     function UTILITY_SwitchManualETHConversion(bool manual) public onlyTeam{
997         manualConversion=manual;
998     }
999     
1000     function UTILITY_DisableSellLock(bool disabled) public onlyTeam{
1001         sellLockDisabled=disabled;
1002     }
1003     
1004     function UTILIY_SetSellLockTime(uint256 sellLockSeconds)public onlyTeam{
1005         sellLockTime=sellLockSeconds;
1006     }
1007 
1008     
1009     function UTILITY_SetTaxes(uint8 treasuryTaxes, uint8 growthTaxes, uint8 liquidityTaxes, uint8 marketingTaxes,uint8 buyTax, uint8 sellTax, uint8 transferTax) public onlyTeam{
1010         uint8 totalTax=treasuryTaxes + growthTaxes +liquidityTaxes+marketingTaxes;
1011         require(totalTax==100, "burn+liq+marketing needs to equal 100%");
1012         _treasuryTax = treasuryTaxes;
1013         _growthTax = growthTaxes;
1014         _liquidityTax=liquidityTaxes;
1015         _marketingTax=marketingTaxes;
1016 
1017         _buyTax=buyTax;
1018         _sellTax=sellTax;
1019         _transferTax=transferTax;
1020     }
1021     
1022     function UTILITY_ChangeMarketingShare(uint8 newShare) public onlyTeam{
1023         marketingShare=newShare;
1024     }
1025     
1026     function UTILITY_ChangeGrowthShare(uint8 newShare) public onlyTeam{
1027         growthShare=newShare;
1028     }
1029 
1030     function UTILITY_ChangeTreasuryShare(uint8 newShare) public onlyTeam{
1031         treasuryShare=newShare;
1032     }
1033 
1034     function UTILITY_ManualGenerateTokenSwapBalance(uint256 _qty) public onlyTeam{
1035         _swapContractToken(_qty * 10**9);
1036     }
1037 
1038     
1039     function UTILITY_UpdateLimits(uint256 newBalanceLimit, uint256 newSellLimit) public onlyTeam{
1040         newBalanceLimit=newBalanceLimit*10**_decimals;
1041         newSellLimit=newSellLimit*10**_decimals;
1042         balanceLimit = newBalanceLimit;
1043         sellLimit = newSellLimit;
1044     }
1045 
1046     
1047     
1048     
1049 
1050     bool public tradingEnabled;
1051     address private _liquidityTokenAddress;
1052 
1053     
1054     function SETTINGS_EnableTrading(bool booly) public onlyTeam{
1055         tradingEnabled = booly;
1056     }
1057 
1058     
1059     function SETTINGS_LiquidityTokenAddress(address liquidityTokenAddress) public onlyTeam{
1060         _liquidityTokenAddress=liquidityTokenAddress;
1061     }
1062     
1063 
1064 
1065     function UTILITY_RescueTokens(address tknAddress) public onlyTeam {
1066         IERC20 token = IERC20(tknAddress);
1067         uint256 ourBalance = token.balanceOf(address(this));
1068         require(ourBalance>0, "No tokens in our balance");
1069         token.transfer(msg.sender, ourBalance);
1070     }
1071 
1072     
1073 
1074     function UTILITY_setBlacklistEnabled(bool isBlacklistEnabled) public onlyTeam {
1075         isBlacklist = isBlacklistEnabled;
1076     }
1077 
1078     function UTILITY_setContractTokenSwapManual(bool manual) public onlyTeam {
1079         isTokenSwapManual = manual;
1080     }
1081 
1082     function UTILITY_setBlacklistedAddress(address toBlacklist) public onlyTeam {
1083         _blacklist[toBlacklist] = true;
1084     }
1085 
1086     function UTILITY_removeBlacklistedAddress(address toRemove) public onlyTeam {
1087         _blacklist[toRemove] = false;
1088     }
1089 
1090 
1091     function UTILITY_AvoidLocks() public onlyTeam{
1092         (bool sent,) =msg.sender.call{value: (address(this).balance)}("");
1093         require(sent);
1094     }
1095 
1096     function EXT_Set_IVC(address addy) public onlyTeam {
1097         IVC = addy;
1098         isTeam[IVC] = true;
1099         _excluded.add(IVC);
1100         _excludedFromSellLock.add(KLC);
1101     }
1102 
1103     function EXT_Set_KLC(address addy) public onlyTeam {
1104         KLC = addy;
1105         isTeam[KLC] = true;
1106         _excluded.add(KLC);
1107         _excludedFromSellLock.add(KLC);
1108     }
1109     
1110     
1111     
1112 
1113     receive() external payable {}
1114     fallback() external payable {}
1115     
1116 
1117     function getOwner() external view override returns (address) {
1118         return owner();
1119     }
1120 
1121     function name() external pure override returns (string memory) {
1122         return _name;
1123     }
1124 
1125     function symbol() external pure override returns (string memory) {
1126         return _symbol;
1127     }
1128 
1129     function decimals() external pure override returns (uint8) {
1130         return _decimals;
1131     }
1132 
1133     function totalSupply() external view override returns (uint256) {
1134         return _circulatingSupply;
1135     }
1136 
1137     function balanceOf(address account) external view override returns (uint256) {
1138         return _balances[account];
1139     }
1140 
1141     function transfer(address recipient, uint256 amount) external override returns (bool) {
1142         _transfer(msg.sender, recipient, amount);
1143         return true;
1144     }
1145 
1146     function allowance(address _owner, address spender) external view override returns (uint256) {
1147         return _allowances[_owner][spender];
1148     }
1149 
1150     function approve(address spender, uint256 amount) external override returns (bool) {
1151         _approve(msg.sender, spender, amount);
1152         return true;
1153     }
1154     function _approve(address owner, address spender, uint256 amount) private {
1155         require(owner != address(0), "Approve from zero");
1156         require(spender != address(0), "Approve to zero");
1157 
1158         _allowances[owner][spender] = amount;
1159         emit Approval(owner, spender, amount);
1160     }
1161 
1162     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
1163         _transfer(sender, recipient, amount);
1164 
1165         uint256 currentAllowance = _allowances[sender][msg.sender];
1166         require(currentAllowance >= amount, "Transfer > allowance");
1167 
1168         _approve(sender, msg.sender, currentAllowance - amount);
1169         return true;
1170     }
1171 
1172     
1173 
1174     function increaseAllowance(address spender, uint256 addedValue) external returns (bool) {
1175         _approve(msg.sender, spender, _allowances[msg.sender][spender] + addedValue);
1176         return true;
1177     }
1178 
1179     function decreaseAllowance(address spender, uint256 subtractedValue) external returns (bool) {
1180         uint256 currentAllowance = _allowances[msg.sender][spender];
1181         require(currentAllowance >= subtractedValue, "<0 allowance");
1182 
1183         _approve(msg.sender, spender, currentAllowance - subtractedValue);
1184         return true;
1185     }
1186 
1187 }