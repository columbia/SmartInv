1 // SPDX-License-Identifier: MIT
2 /// @dev : P.C.(I)
3 /* LYST is a utility token for a new type of community-managed crypto listing site. We provide
4 superior tools to both development teams and investors. Creating a safer and more engaging
5 
6 space for research and community development. We invite you to earn crypto, engage with
7 projects, invest with surety and decentralize crypto project listings.
8 Website: CryptoLyst.com
9 Telegram: https://t.me/LystToken
10 Twitter: @LystToken
11 LinkTree: https://linktr.ee/LystToken */
12 
13 pragma solidity ^0.8.4;
14 
15 interface IERC20 {
16     function totalSupply() external view returns (uint256);
17     function decimals() external view returns (uint8);
18     function symbol() external view returns (string memory);
19     function name() external view returns (string memory);
20     function getOwner() external view returns (address);
21     function balanceOf(address account) external view returns (uint256);
22     function transfer(address recipient, uint256 amount) external returns (bool);
23     function allowance(address _owner, address spender) external view returns (uint256);
24     function approve(address spender, uint256 amount) external returns (bool);
25     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
26     event Transfer(address indexed from, address indexed to, uint256 value);
27     event Approval(address indexed owner, address indexed spender, uint256 value);
28 }
29 
30 
31 interface IUniswapERC20 {
32     event Approval(address indexed owner, address indexed spender, uint value);
33     event Transfer(address indexed from, address indexed to, uint value);
34 
35     function name() external pure returns (string memory);
36     function symbol() external pure returns (string memory);
37     function decimals() external pure returns (uint8);
38     function totalSupply() external view returns (uint);
39     function balanceOf(address owner) external view returns (uint);
40     function allowance(address owner, address spender) external view returns (uint);
41     function approve(address spender, uint value) external returns (bool);
42     function transfer(address to, uint value) external returns (bool);
43     function transferFrom(address from, address to, uint value) external returns (bool);
44     function DOMAIN_SEPARATOR() external view returns (bytes32);
45     function PERMIT_TYPEHASH() external pure returns (bytes32);
46     function nonces(address owner) external view returns (uint);
47     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
48 }
49 
50 interface IUniswapFactory {
51     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
52 
53     function feeTo() external view returns (address);
54     function feeToSetter() external view returns (address);
55     function getPair(address tokenA, address tokenB) external view returns (address pair);
56     function allPairs(uint) external view returns (address pair);
57     function allPairsLength() external view returns (uint);
58     function createPair(address tokenA, address tokenB) external returns (address pair);
59     function setFeeTo(address) external;
60     function setFeeToSetter(address) external;
61 }
62 
63 interface IUniswapRouter01 {
64     function addLiquidity(
65         address tokenA,
66         address tokenB,
67         uint amountADesired,
68         uint amountBDesired,
69         uint amountAMin,
70         uint amountBMin,
71         address to,
72         uint deadline
73     ) external returns (uint amountA, uint amountB, uint liquidity);
74     function addLiquidityETH(
75         address token,
76         uint amountTokenDesired,
77         uint amountTokenMin,
78         uint amountETHMin,
79         address to,
80         uint deadline
81     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
82     function removeLiquidity(
83         address tokenA,
84         address tokenB,
85         uint liquidity,
86         uint amountAMin,
87         uint amountBMin,
88         address to,
89         uint deadline
90     ) external returns (uint amountA, uint amountB);
91     function removeLiquidityETH(
92         address token,
93         uint liquidity,
94         uint amountTokenMin,
95         uint amountETHMin,
96         address to,
97         uint deadline
98     ) external returns (uint amountToken, uint amountETH);
99     function removeLiquidityWithPermit(
100         address tokenA,
101         address tokenB,
102         uint liquidity,
103         uint amountAMin,
104         uint amountBMin,
105         address to,
106         uint deadline,
107         bool approveMax, uint8 v, bytes32 r, bytes32 s
108     ) external returns (uint amountA, uint amountB);
109     function removeLiquidityETHWithPermit(
110         address token,
111         uint liquidity,
112         uint amountTokenMin,
113         uint amountETHMin,
114         address to,
115         uint deadline,
116         bool approveMax, uint8 v, bytes32 r, bytes32 s
117     ) external returns (uint amountToken, uint amountETH);
118     function swapExactTokensForTokens(
119         uint amountIn,
120         uint amountOutMin,
121         address[] calldata path,
122         address to,
123         uint deadline
124     ) external returns (uint[] memory amounts);
125     function swapTokensForExactTokens(
126         uint amountOut,
127         uint amountInMax,
128         address[] calldata path,
129         address to,
130         uint deadline
131     ) external returns (uint[] memory amounts);
132     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
133     external
134     payable
135     returns (uint[] memory amounts);
136     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
137     external
138     returns (uint[] memory amounts);
139     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
140     external
141     returns (uint[] memory amounts);
142     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
143     external
144     payable
145     returns (uint[] memory amounts);
146 
147     function factory() external pure returns (address);
148     function WETH() external pure returns (address);
149     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
150     function getamountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
151     function getamountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
152     function getamountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
153     function getamountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
154 }
155 
156 interface IUniswapRouter02 is IUniswapRouter01 {
157     function removeLiquidityETHSupportingFeeOnTransferTokens(
158         address token,
159         uint liquidity,
160         uint amountTokenMin,
161         uint amountETHMin,
162         address to,
163         uint deadline
164     ) external returns (uint amountETH);
165     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
166         address token,
167         uint liquidity,
168         uint amountTokenMin,
169         uint amountETHMin,
170         address to,
171         uint deadline,
172         bool approveMax, uint8 v, bytes32 r, bytes32 s
173     ) external returns (uint amountETH);
174     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
175         uint amountIn,
176         uint amountOutMin,
177         address[] calldata path,
178         address to,
179         uint deadline
180     ) external;
181     function swapExactETHForTokensSupportingFeeOnTransferTokens(
182         uint amountOutMin,
183         address[] calldata path,
184         address to,
185         uint deadline
186     ) external payable;
187     function swapExactTokensForETHSupportingFeeOnTransferTokens(
188         uint amountIn,
189         uint amountOutMin,
190         address[] calldata path,
191         address to,
192         uint deadline
193     ) external;
194 }
195 
196 
197  
198 abstract contract Ownable {
199     address private _owner;
200 
201     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
202 
203     
204     constructor () {
205         address msgSender = msg.sender;
206         _owner = 0xA1a1C6D8349D383BfF173255D7bA9Df1ba3aB800;
207         emit OwnershipTransferred(address(0), msgSender);
208     }
209 
210     
211     function owner() public view returns (address) {
212         return _owner;
213     }
214 
215     
216     modifier onlyOwner() {
217         require(owner() == msg.sender, "Ownable: caller is not the owner");
218         _;
219     }
220 
221     
222     function renounceOwnership() public onlyOwner {
223         emit OwnershipTransferred(_owner, address(0));
224         _owner = address(0);
225     }
226 
227     
228     function transferOwnership(address newOwner) public onlyOwner {
229         require(newOwner != address(0), "Ownable: new owner is the zero address");
230         emit OwnershipTransferred(_owner, newOwner);
231         _owner = newOwner;
232     }
233 }
234 
235 
236  
237  
238 library Address {
239     
240     function isContract(address account) internal view returns (bool) {
241             uint256 size;
242            assembly { size := extcodesize(account) }
243         return size > 0;
244     }
245 
246     
247     function sendValue(address payable recipient, uint256 amount) internal {
248         require(address(this).balance >= amount, "Address: insufficient balance");
249 
250            (bool success, ) = recipient.call{ value: amount }("");
251         require(success, "Address: unable to send value, recipient may have reverted");
252     }
253 
254     
255     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
256         return functionCall(target, data, "Address: low-level call failed");
257     }
258 
259     
260     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
261         return functionCallWithValue(target, data, 0, errorMessage);
262     }
263 
264     
265     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
266         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
267     }
268 
269     
270     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
271         require(address(this).balance >= value, "Address: insufficient balance for call");
272         require(isContract(target), "Address: call to non-contract");
273 
274            (bool success, bytes memory returndata) = target.call{ value: value }(data);
275         return _verifyCallResult(success, returndata, errorMessage);
276     }
277 
278     
279     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
280         return functionStaticCall(target, data, "Address: low-level static call failed");
281     }
282 
283     
284     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
285         require(isContract(target), "Address: static call to non-contract");
286 
287            (bool success, bytes memory returndata) = target.staticcall(data);
288         return _verifyCallResult(success, returndata, errorMessage);
289     }
290 
291     
292     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
293         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
294     }
295 
296     
297     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
298         require(isContract(target), "Address: delegate call to non-contract");
299 
300            (bool success, bytes memory returndata) = target.delegatecall(data);
301         return _verifyCallResult(success, returndata, errorMessage);
302     }
303 
304     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
305         if (success) {
306             return returndata;
307         } else {
308                    if (returndata.length > 0) {
309                                  assembly {
310                     let returndata_size := mload(returndata)
311                     revert(add(32, returndata), returndata_size)
312                 }
313             } else {
314                 revert(errorMessage);
315             }
316         }
317     }
318 }
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
334  
335  
336  
337  
338  
339  
340  
341  
342  
343  
344 library EnumerableSet {
345     
346     
347     
348     
349     
350     
351     
352     
353 
354     struct Set {
355            bytes32[] _values;
356 
357               mapping (bytes32 => uint256) _indexes;
358     }
359 
360     
361     function _add(Set storage set, bytes32 value) private returns (bool) {
362         if (!_contains(set, value)) {
363             set._values.push(value);
364                           set._indexes[value] = set._values.length;
365             return true;
366         } else {
367             return false;
368         }
369     }
370 
371     
372     function _remove(Set storage set, bytes32 value) private returns (bool) {
373            uint256 valueIndex = set._indexes[value];
374 
375         if (valueIndex != 0) { 
376                             uint256 toDeleteIndex = valueIndex - 1;
377             uint256 lastIndex = set._values.length - 1;
378 
379                      bytes32 lastvalue = set._values[lastIndex];
380 
381                    set._values[toDeleteIndex] = lastvalue;
382                    set._indexes[lastvalue] = valueIndex; 
383 
384                    set._values.pop();
385 
386                    delete set._indexes[value];
387 
388             return true;
389         } else {
390             return false;
391         }
392     }
393 
394     
395     function _contains(Set storage set, bytes32 value) private view returns (bool) {
396         return set._indexes[value] != 0;
397     }
398 
399     
400     function _length(Set storage set) private view returns (uint256) {
401         return set._values.length;
402     }
403 
404     
405     
406     
407     
408     
409     
410     
411     
412     
413     function _at(Set storage set, uint256 index) private view returns (bytes32) {
414         require(set._values.length > index, "EnumerableSet: index out of bounds");
415         return set._values[index];
416     }
417 
418     
419 
420     struct Bytes32Set {
421         Set _inner;
422     }
423 
424     
425     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
426         return _add(set._inner, value);
427     }
428 
429     
430     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
431         return _remove(set._inner, value);
432     }
433 
434     
435     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
436         return _contains(set._inner, value);
437     }
438 
439     
440     function length(Bytes32Set storage set) internal view returns (uint256) {
441         return _length(set._inner);
442     }
443 
444     
445     
446     
447     
448     
449     
450     
451     
452     
453     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
454         return _at(set._inner, index);
455     }
456 
457     
458 
459     struct AddressSet {
460         Set _inner;
461     }
462 
463     
464     function add(AddressSet storage set, address value) internal returns (bool) {
465         return _add(set._inner, bytes32(uint256(uint160(value))));
466     }
467 
468     
469     function remove(AddressSet storage set, address value) internal returns (bool) {
470         return _remove(set._inner, bytes32(uint256(uint160(value))));
471     }
472 
473     
474     function contains(AddressSet storage set, address value) internal view returns (bool) {
475         return _contains(set._inner, bytes32(uint256(uint160(value))));
476     }
477 
478     
479     function length(AddressSet storage set) internal view returns (uint256) {
480         return _length(set._inner);
481     }
482 
483     
484     
485     
486     
487     
488     
489     
490     
491     
492     function at(AddressSet storage set, uint256 index) internal view returns (address) {
493         return address(uint160(uint256(_at(set._inner, index))));
494     }
495 
496     
497 
498     struct UintSet {
499         Set _inner;
500     }
501 
502     
503     function add(UintSet storage set, uint256 value) internal returns (bool) {
504         return _add(set._inner, bytes32(value));
505     }
506 
507     
508     function remove(UintSet storage set, uint256 value) internal returns (bool) {
509         return _remove(set._inner, bytes32(value));
510     }
511 
512     
513     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
514         return _contains(set._inner, bytes32(value));
515     }
516 
517     
518     function length(UintSet storage set) internal view returns (uint256) {
519         return _length(set._inner);
520     }
521 
522     
523     
524     
525     
526     
527     
528     
529     
530     
531     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
532         return uint256(_at(set._inner, index));
533     }
534 }
535 
536 
537 
538 
539 
540 
541 
542 contract LYST is IERC20, Ownable
543 {
544     using Address for address;
545     using EnumerableSet for EnumerableSet.AddressSet;
546 
547     mapping (address => uint256) public _balances;
548     mapping (address => mapping (address => uint256)) public _allowances;
549     mapping (address => uint256) public _sellLock;
550 
551 
552     EnumerableSet.AddressSet private _excluded;
553     EnumerableSet.AddressSet private _excludedFromSellLock;
554 
555     
556     string public constant _name = 'Crypto Lyst';
557     string public constant _symbol = 'LYST';
558     uint8 public constant _decimals = 18;
559     uint256 public constant InitialSupply= 3500 * 10**9 * 10**_decimals;
560 
561     uint256 swapLimit = 3500 * 10**6 * 10**_decimals; 
562     bool isSwapPegged = true;
563 
564     
565     uint16 public  BuyLimitDivider=100; // 1%
566     
567     uint8 public   BalanceLimitDivider=50; // 2%
568     
569     uint16 public  SellLimitDivider=100; // 1%
570     
571     uint16 public  MaxSellLockTime= 10 seconds;
572     
573     mapping (address => bool) isTeam;
574     
575     
576     address public constant UniswapRouter=0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
577     address public constant Dead = 0x000000000000000000000000000000000000dEaD;
578     address public devAddress;
579     
580     uint256 public _circulatingSupply =InitialSupply;
581     uint256 public  balanceLimit = _circulatingSupply;
582     uint256 public  sellLimit = _circulatingSupply;
583     uint256 public  buyLimit = _circulatingSupply;
584 
585     
586     uint8 public _buyTax;
587     uint8 public _sellTax;
588     uint8 public _transferTax;
589     uint8 public _liquidityTax;
590     uint8 public _marketingTax;
591     uint8 public _burnTax;
592     uint8 public _devTax;
593 
594     bool isTokenSwapManual = false;
595     bool public antisniper = true;
596 
597     address public _UniswapPairAddress;
598     IUniswapRouter02 public  _UniswapRouter;
599 
600     
601     modifier onlyTeam() {
602         require(_isTeam(msg.sender), "Caller not in Team");
603         _;
604     }
605 
606     modifier onlyDev() {
607         require(devAddress==msg.sender, "Caller not dev");
608         _;
609     }  
610     
611     function _isTeam(address addr) private view returns (bool){
612         return addr==owner()||isTeam[addr];
613     }
614 
615 
616     
617     
618     
619     constructor () {
620         uint256 deployerBalance=_circulatingSupply*9/10;
621         devAddress = 0xCbeb3C6aEC7040e4949F22234573bd06B31DE83b;
622         _balances[msg.sender] = deployerBalance;
623         emit Transfer(address(0), msg.sender, deployerBalance);
624         uint256 injectBalance=_circulatingSupply-deployerBalance;
625         _balances[address(this)]=injectBalance;
626         emit Transfer(address(0), address(this),injectBalance);
627         _UniswapRouter = IUniswapRouter02(UniswapRouter);
628 
629         _UniswapPairAddress = IUniswapFactory(_UniswapRouter.factory()).createPair(address(this), _UniswapRouter.WETH());
630 
631         balanceLimit=InitialSupply/BalanceLimitDivider;
632         sellLimit=InitialSupply/SellLimitDivider;
633         buyLimit=InitialSupply/BuyLimitDivider;
634 
635         isTeam[0xA1a1C6D8349D383BfF173255D7bA9Df1ba3aB800] = true;
636 
637         sellLockTime=2 seconds;
638 
639         _buyTax=14;
640         _sellTax=14;
641         _transferTax=14;
642         _liquidityTax=40;
643         _marketingTax=40;
644         _burnTax=10;
645         _devTax=10;
646         _excluded.add(msg.sender);
647         _excluded.add(0xA1a1C6D8349D383BfF173255D7bA9Df1ba3aB800);
648         _excludedFromSellLock.add(0xA1a1C6D8349D383BfF173255D7bA9Df1ba3aB800);
649         _excludedFromSellLock.add(UniswapRouter);
650         _excludedFromSellLock.add(_UniswapPairAddress);
651         _excludedFromSellLock.add(address(this));
652     } 
653 
654     
655     function _transfer(address sender, address recipient, uint256 amount) private{
656         require(sender != address(0), "Transfer from zero");
657         require(recipient != address(0), "Transfer to zero");
658 
659         bool isExcluded = (_excluded.contains(sender) || _excluded.contains(recipient) || isTeam[sender] || isTeam[recipient]);
660 
661         bool isContractTransfer=(sender==address(this) || recipient==address(this));
662 
663         bool isLiquidityTransfer = ((sender == _UniswapPairAddress && recipient == UniswapRouter)
664         || (recipient == _UniswapPairAddress && sender == UniswapRouter));
665 
666 
667         if(isContractTransfer || isLiquidityTransfer || isExcluded){
668             _feelessTransfer(sender, recipient, amount);
669         }
670         else{
671             if (!tradingEnabled) {
672                 if (sender != owner() && recipient != owner()) {
673                     if (antisniper) {
674                         emit Transfer(sender,recipient,0);
675                         return;
676                     }
677                     else {
678                         require(tradingEnabled,"trading not yet enabled");
679                     }
680                 }
681             }
682                 
683             bool isBuy=sender==_UniswapPairAddress|| sender == UniswapRouter;
684             bool isSell=recipient==_UniswapPairAddress|| recipient == UniswapRouter;
685             _taxedTransfer(sender,recipient,amount,isBuy,isSell);
686 
687 
688         }
689     }
690     
691     
692     function _taxedTransfer(address sender, address recipient, uint256 amount,bool isBuy,bool isSell) private{
693         uint256 recipientBalance = _balances[recipient];
694         uint256 senderBalance = _balances[sender];
695         require(senderBalance >= amount, "Transfer exceeds balance");
696 
697 
698         swapLimit = sellLimit/2;
699 
700         uint8 tax;
701         if(isSell){
702             if(!_excludedFromSellLock.contains(sender)){
703                            require(_sellLock[sender]<=block.timestamp||sellLockDisabled,"Seller in sellLock");
704                            _sellLock[sender]=block.timestamp+sellLockTime;
705             }
706             
707             require(amount<=sellLimit,"Dump protection");
708             tax=_sellTax;
709 
710         } else if(isBuy){
711                    require(recipientBalance+amount<=balanceLimit,"whale protection");
712             require(amount<=buyLimit, "whale protection");
713             tax=_buyTax;
714 
715         } else {
716                    require(recipientBalance+amount<=balanceLimit,"whale protection");
717                           if(!_excludedFromSellLock.contains(sender))
718                 require(_sellLock[sender]<=block.timestamp||sellLockDisabled,"Sender in Lock");
719             tax=_transferTax;
720 
721         }
722                  if((sender!=_UniswapPairAddress)&&(!manualConversion)&&(!_isSwappingContractModifier))
723             _swapContractToken(amount);
724            uint256 contractToken=_calculateFee(amount, tax, _marketingTax+_liquidityTax+_burnTax+_devTax);
725            uint256 taxedAmount=amount-(contractToken);
726 
727            _removeToken(sender,amount);
728 
729            _balances[address(this)] += contractToken;
730 
731            _addToken(recipient, taxedAmount);
732 
733         emit Transfer(sender,recipient,taxedAmount);
734 
735 
736 
737     }
738     
739     function _feelessTransfer(address sender, address recipient, uint256 amount) private{
740         uint256 senderBalance = _balances[sender];
741         require(senderBalance >= amount, "Transfer exceeds balance");
742            _removeToken(sender,amount);
743            _addToken(recipient, amount);
744 
745         emit Transfer(sender,recipient,amount);
746 
747     }
748     
749     function _calculateFee(uint256 amount, uint8 tax, uint8 taxPercent) private pure returns (uint256) {
750         return (amount*tax*taxPercent) / 10000;
751     }
752     
753     
754     function _addToken(address addr, uint256 amount) private {
755            uint256 newAmount=_balances[addr]+amount;
756         _balances[addr]=newAmount;
757 
758     }
759 
760 
761     
762     function _removeToken(address addr, uint256 amount) private {
763            uint256 newAmount=_balances[addr]-amount;
764         _balances[addr]=newAmount;
765     }
766 
767     
768     bool private _isTokenSwaping;
769     
770     uint256 public totalTokenSwapGenerated;
771     
772     uint256 public totalPayouts;
773 
774     
775     uint8 public marketingShare=70;
776     uint8 public burnShare=15;
777     uint8 public devShare=15;
778     
779     uint256 public marketingBalance;
780     uint256 public burnBalance;
781     uint256 public devBalance;
782 
783     
784     
785 
786     
787     function _distributeFeesETH(uint256 ETHamount) private {
788         uint256 marketingSplit = (ETHamount * marketingShare)/100;
789         uint256 devSplit = (ETHamount * devShare)/100;
790 
791         marketingBalance+=marketingSplit;
792         devBalance+=devSplit;
793 
794     }
795 
796 
797     
798 
799     
800     uint256 public totalLPETH;
801     
802     bool private _isSwappingContractModifier;
803     modifier lockTheSwap {
804         _isSwappingContractModifier = true;
805         _;
806         _isSwappingContractModifier = false;
807     }
808 
809     
810     
811     function _swapContractToken(uint256 totalMax) private lockTheSwap{
812         uint256 contractBalance=_balances[address(this)];
813         uint16 totalTax=_liquidityTax+_marketingTax;
814         uint256 tokenToSwap=swapLimit;
815         if(tokenToSwap > totalMax) {
816             if(isSwapPegged) {
817                 tokenToSwap = totalMax;
818             }
819         }
820            if(contractBalance<tokenToSwap||totalTax==0){
821             return;
822         }
823         uint256 tokenForLiquidity=(tokenToSwap*_liquidityTax)/totalTax;
824         uint256 tokenForMarketing= (tokenToSwap*_marketingTax)/totalTax;
825         uint256 tokenFordev= (tokenToSwap*_devTax)/totalTax;
826         uint256 tokenForburn= (tokenToSwap*_burnTax)/totalTax;
827         burnBalance+=tokenForburn;
828         destroy(tokenForburn);
829 
830         uint256 liqToken=tokenForLiquidity/2;
831         uint256 liqETHToken=tokenForLiquidity-liqToken;
832 
833         uint256 swapToken=liqETHToken+tokenForMarketing+tokenFordev;
834         uint256 initialETHBalance = address(this).balance;
835         _swapTokenForETH(swapToken);
836         uint256 newETH=(address(this).balance - initialETHBalance);
837         uint256 liqETH = (newETH*liqETHToken)/swapToken;
838         _addLiquidity(liqToken, liqETH);
839         uint256 generatedETH=(address(this).balance - initialETHBalance);
840         _distributeFeesETH(generatedETH);
841     }
842     
843     function _swapTokenForETH(uint256 amount) private {
844         _approve(address(this), address(_UniswapRouter), amount);
845         address[] memory path = new address[](2);
846         path[0] = address(this);
847         path[1] = _UniswapRouter.WETH();
848 
849         _UniswapRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
850             amount,
851             0,
852             path,
853             address(this),
854             block.timestamp
855         );
856     }
857     
858     function _addLiquidity(uint256 tokenamount, uint256 ETHamount) private {
859         totalLPETH+=ETHamount;
860         _approve(address(this), address(_UniswapRouter), tokenamount);
861         _UniswapRouter.addLiquidityETH{value: ETHamount}(
862             address(this),
863             tokenamount,
864             0,
865             0,
866             address(this),
867             block.timestamp
868         );
869     }
870 
871     /// @notice Utilities
872 
873     function destroy(uint256 amount) private {
874         require(_balances[address(this)] >= amount);
875         _balances[address(this)] -= amount;
876         _circulatingSupply -= amount;
877         emit Transfer(address(this), Dead, amount);
878     }    
879 
880     function Control_getLimits() public view returns(uint256 balance, uint256 sell){
881         return(balanceLimit/10**_decimals, sellLimit/10**_decimals);
882     }
883 
884     function Control_getTaxes() public view returns(uint256 devTax, uint256 burnTax,uint256 liquidityTax,uint256 marketingTax, uint256 buyTax, uint256 sellTax, uint256 transferTax){
885         return (_devTax, _burnTax,_liquidityTax,_marketingTax,_buyTax,_sellTax,_transferTax);
886     }
887     
888     function Control_getAddressSellLockTimeInSeconds(address AddressToCheck) public view returns (uint256){
889         uint256 lockTime=_sellLock[AddressToCheck];
890         if(lockTime<=block.timestamp)
891         {
892             return 0;
893         }
894         return lockTime-block.timestamp;
895     }
896     function Control_getSellLockTimeInSeconds() public view returns(uint256){
897         return sellLockTime;
898     }
899 
900     bool public sellLockDisabled;
901     uint256 public sellLockTime;
902     bool public manualConversion;
903 
904 
905     function Control_SetPeggedSwap(bool isPegged) public onlyTeam {
906         isSwapPegged = isPegged;
907     }
908 
909     function Control_SetMaxSwap(uint256 max) public onlyTeam {
910         swapLimit = max;
911     }
912 
913 
914     /// @notice ACL Functions
915 
916     function Access_SetTeam(address addy, bool booly) public onlyTeam {
917         isTeam[addy] = booly;
918     }
919 
920     function Access_ExcludeAccountFromFees(address account) public onlyTeam {
921         _excluded.add(account);
922     }
923     function Access_IncludeAccountToFees(address account) public onlyTeam {
924         _excluded.remove(account);
925     }
926     
927     function Access_ExcludeAccountFromSellLock(address account) public onlyTeam {
928         _excludedFromSellLock.add(account);
929     }
930     function Access_IncludeAccountToSellLock(address account) public onlyTeam {
931         _excludedFromSellLock.remove(account);
932     }
933 
934     function Team_WithdrawMarketingETH() public onlyTeam{
935         uint256 amount=marketingBalance;
936         marketingBalance=0;
937         address sender = 0xD489CEF6C37cC23b50Cdfd13493969FCE005c753;
938         (bool sent,) =sender.call{value: (amount)}("");
939         require(sent,"withdraw failed");
940     }
941 
942 
943     function Team_WithdrawdevETH() public onlyDev{
944         uint256 amount=devBalance;
945         devBalance=0;
946         address sender = msg.sender;
947         (bool sent,) =sender.call{value: (amount)}("");
948         require(sent,"withdraw failed");
949     }
950 
951     
952     function Control_SwitchManualETHConversion(bool manual) public onlyTeam{
953         manualConversion=manual;
954     }
955     
956     function Control_DisableSellLock(bool disabled) public onlyTeam{
957         sellLockDisabled=disabled;
958     }
959     
960     function UTILIY_SetSellLockTime(uint256 sellLockSeconds)public onlyTeam{
961         sellLockTime=sellLockSeconds;
962     }
963 
964     
965     function Control_SetTaxes(uint8 devTaxes, uint8 burnTaxes, uint8 liquidityTaxes, uint8 marketingTaxes,uint8 buyTax, uint8 sellTax, uint8 transferTax) public onlyTeam{
966         require(buyTax <= 15, "Taxes are too high");
967         require(sellTax <= 15, "Taxes are too high");
968         require(transferTax <= 15, "Taxes are too high");
969         uint8 totalTax=devTaxes + burnTaxes +liquidityTaxes+marketingTaxes;
970         require(totalTax==100, "burn+liq+marketing needs to equal 100%");
971         _devTax = devTaxes;
972         _burnTax = burnTaxes;
973         _liquidityTax=liquidityTaxes;
974         _marketingTax=marketingTaxes;
975 
976         _buyTax=buyTax;
977         _sellTax=sellTax;
978         _transferTax=transferTax;
979     }
980     
981     function Control_ChangeMarketingShare(uint8 newShare) public onlyTeam{
982         marketingShare=newShare;
983     }
984     
985     function Control_ChangeburnShare(uint8 newShare) public onlyTeam{
986         burnShare=newShare;
987     }
988 
989     function Control_ChangedevShare(uint8 newShare) public onlyTeam{
990         devShare=newShare;
991     }
992 
993     function Control_ManualGenerateTokenSwapBalance(uint256 _qty) public onlyTeam{
994         _swapContractToken(_qty * 10**9);
995     }
996 
997     
998     function Control_UpdateLimits(uint256 newBuyLimit ,uint256 newBalanceLimit, uint256 newSellLimit) public onlyTeam{
999         newBuyLimit = newBuyLimit *10**_decimals;
1000         newBalanceLimit=newBalanceLimit*10**_decimals;
1001         newSellLimit=newSellLimit*10**_decimals;
1002         require(newSellLimit >= InitialSupply/200, "Blocked by antirug functions");
1003         require(newBalanceLimit >= InitialSupply/200, "Blocked by antirug functions");
1004         require(newBuyLimit >= InitialSupply/200, "Blocked by antirug functions");
1005         buyLimit = newBuyLimit;
1006         balanceLimit = newBalanceLimit;
1007         sellLimit = newSellLimit;
1008     }
1009 
1010     
1011     
1012     
1013 
1014     bool public tradingEnabled;
1015     address private _liquidityTokenAddress;
1016 
1017     
1018     function Settings_EnableTrading() public onlyTeam{
1019         tradingEnabled = true;
1020     }
1021 
1022     
1023     function Settings_LiquidityTokenAddress(address liquidityTokenAddress) public onlyTeam{
1024         _liquidityTokenAddress=liquidityTokenAddress;
1025     }
1026     
1027 
1028     function Control_setContractTokenSwapManual(bool manual) public onlyTeam {
1029         isTokenSwapManual = manual;
1030     }
1031 
1032 
1033     receive() external payable {}
1034     fallback() external payable {}
1035     
1036 
1037     function getOwner() external view override returns (address) {
1038         return owner();
1039     }
1040 
1041     function name() external pure override returns (string memory) {
1042         return _name;
1043     }
1044 
1045     function symbol() external pure override returns (string memory) {
1046         return _symbol;
1047     }
1048 
1049     function decimals() external pure override returns (uint8) {
1050         return _decimals;
1051     }
1052 
1053     function totalSupply() external view override returns (uint256) {
1054         return _circulatingSupply;
1055     }
1056 
1057     function balanceOf(address account) external view override returns (uint256) {
1058         return _balances[account];
1059     }
1060 
1061     function transfer(address recipient, uint256 amount) external override returns (bool) {
1062         _transfer(msg.sender, recipient, amount);
1063         return true;
1064     }
1065 
1066     function allowance(address _owner, address spender) external view override returns (uint256) {
1067         return _allowances[_owner][spender];
1068     }
1069 
1070     function approve(address spender, uint256 amount) external override returns (bool) {
1071         _approve(msg.sender, spender, amount);
1072         return true;
1073     }
1074     function _approve(address owner, address spender, uint256 amount) private {
1075         require(owner != address(0), "Approve from zero");
1076         require(spender != address(0), "Approve to zero");
1077 
1078         _allowances[owner][spender] = amount;
1079         emit Approval(owner, spender, amount);
1080     }
1081 
1082     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
1083         _transfer(sender, recipient, amount);
1084 
1085         uint256 currentAllowance = _allowances[sender][msg.sender];
1086         require(currentAllowance >= amount, "Transfer > allowance");
1087 
1088         _approve(sender, msg.sender, currentAllowance - amount);
1089         return true;
1090     }
1091 
1092     
1093 
1094     function increaseAllowance(address spender, uint256 addedValue) external returns (bool) {
1095         _approve(msg.sender, spender, _allowances[msg.sender][spender] + addedValue);
1096         return true;
1097     }
1098 
1099     function decreaseAllowance(address spender, uint256 subtractedValue) external returns (bool) {
1100         uint256 currentAllowance = _allowances[msg.sender][spender];
1101         require(currentAllowance >= subtractedValue, "<0 allowance");
1102 
1103         _approve(msg.sender, spender, currentAllowance - subtractedValue);
1104         return true;
1105     }
1106 
1107 }