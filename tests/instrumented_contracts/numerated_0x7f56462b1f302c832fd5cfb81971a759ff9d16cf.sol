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
196         _owner = 0xA1a1C6D8349D383BfF173255D7bA9Df1ba3aB800;
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
310 library EnumerableSet {
311 
312     struct Set {
313            bytes32[] _values;
314 
315               mapping (bytes32 => uint256) _indexes;
316     }
317 
318     
319     function _add(Set storage set, bytes32 value) private returns (bool) {
320         if (!_contains(set, value)) {
321             set._values.push(value);
322                           set._indexes[value] = set._values.length;
323             return true;
324         } else {
325             return false;
326         }
327     }
328 
329     
330     function _remove(Set storage set, bytes32 value) private returns (bool) {
331            uint256 valueIndex = set._indexes[value];
332 
333         if (valueIndex != 0) { 
334                             uint256 toDeleteIndex = valueIndex - 1;
335             uint256 lastIndex = set._values.length - 1;
336 
337                      bytes32 lastvalue = set._values[lastIndex];
338 
339                    set._values[toDeleteIndex] = lastvalue;
340                    set._indexes[lastvalue] = valueIndex; 
341 
342                    set._values.pop();
343 
344                    delete set._indexes[value];
345 
346             return true;
347         } else {
348             return false;
349         }
350     }
351 
352     
353     function _contains(Set storage set, bytes32 value) private view returns (bool) {
354         return set._indexes[value] != 0;
355     }
356 
357     
358     function _length(Set storage set) private view returns (uint256) {
359         return set._values.length;
360     }
361 
362     
363     function _at(Set storage set, uint256 index) private view returns (bytes32) {
364         require(set._values.length > index, "EnumerableSet: index out of bounds");
365         return set._values[index];
366     }
367 
368     
369     struct Bytes32Set {
370         Set _inner;
371     }
372 
373     
374     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
375         return _add(set._inner, value);
376     }
377 
378     
379     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
380         return _remove(set._inner, value);
381     }
382 
383     
384     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
385         return _contains(set._inner, value);
386     }
387 
388     
389     function length(Bytes32Set storage set) internal view returns (uint256) {
390         return _length(set._inner);
391     }  
392 
393 
394     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
395         return _at(set._inner, index);
396     }
397 
398 
399     struct AddressSet {
400         Set _inner;
401     }
402 
403     
404     function add(AddressSet storage set, address value) internal returns (bool) {
405         return _add(set._inner, bytes32(uint256(uint160(value))));
406     }
407 
408     
409     function remove(AddressSet storage set, address value) internal returns (bool) {
410         return _remove(set._inner, bytes32(uint256(uint160(value))));
411     }
412 
413     
414     function contains(AddressSet storage set, address value) internal view returns (bool) {
415         return _contains(set._inner, bytes32(uint256(uint160(value))));
416     }
417 
418     
419     function length(AddressSet storage set) internal view returns (uint256) {
420         return _length(set._inner);
421     }
422 
423     
424     function at(AddressSet storage set, uint256 index) internal view returns (address) {
425         return address(uint160(uint256(_at(set._inner, index))));
426     }
427 
428 
429     struct UintSet {
430         Set _inner;
431     }
432 
433     
434     function add(UintSet storage set, uint256 value) internal returns (bool) {
435         return _add(set._inner, bytes32(value));
436     }
437 
438     
439     function remove(UintSet storage set, uint256 value) internal returns (bool) {
440         return _remove(set._inner, bytes32(value));
441     }
442 
443     
444     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
445         return _contains(set._inner, bytes32(value));
446     }
447 
448     
449     function length(UintSet storage set) internal view returns (uint256) {
450         return _length(set._inner);
451     }
452   
453     
454     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
455         return uint256(_at(set._inner, index));
456     }
457 }
458 
459 
460 contract RubberDucky is IERC20, Ownable
461 {
462     using Address for address;
463     using EnumerableSet for EnumerableSet.AddressSet;
464 
465     mapping (address => uint256) public _balances;
466     mapping (address => mapping (address => uint256)) public _allowances;
467     mapping (address => uint256) public _sellLock;
468 
469 
470     EnumerableSet.AddressSet private _excluded;
471     EnumerableSet.AddressSet private _excludedFromSellLock;
472 
473     
474     string public constant _name = 'Rubber Ducky';
475     string public constant _symbol = 'DUCKY';
476     uint8 public constant _decimals = 18;
477     uint256 public constant InitialSupply= 100 * 10**6 * 10**_decimals;
478 
479     uint256 swapLimit = 100 * 10**3 * 10**_decimals; 
480     bool isSwapPegged = true;
481 
482     
483     uint16 public  BuyLimitDivider=100; // 1%
484     
485     uint16 public   BalanceLimitDivider=1000; // 0.1% just at the beginning, then 2%
486     
487     uint16 public  SellLimitDivider=100; // 1%
488     
489     uint16 public  MaxSellLockTime= 10 seconds;
490     
491     mapping (address => bool) isTeam;
492     
493     
494     address public constant UniswapRouter=0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
495     address public constant Dead = 0x000000000000000000000000000000000000dEaD;
496     address public devAddress;
497     
498     uint256 public _circulatingSupply =InitialSupply;
499     uint256 public  balanceLimit = _circulatingSupply;
500     uint256 public  sellLimit = _circulatingSupply;
501     uint256 public  buyLimit = _circulatingSupply;
502 
503     
504     uint8 public _buyTax;
505     uint8 public _sellTax;
506     uint8 public _transferTax;
507     uint8 public _liquidityTax;
508     uint8 public _marketingTax;
509     uint8 public _devTax;
510 
511     bool isTokenSwapManual = false;
512     bool public antisniper = false;
513 
514     address public _UniswapPairAddress;
515     IUniswapRouter02 public  _UniswapRouter;
516 
517     
518     modifier onlyTeam() {
519         require(_isTeam(msg.sender), "Caller not in Team");
520         _;
521     }
522 
523     modifier onlyDev() {
524         require(devAddress==msg.sender, "Caller not dev");
525         _;
526     }  
527     
528     function _isTeam(address addr) private view returns (bool){
529         return addr==owner()||isTeam[addr];
530     }
531 
532 
533     constructor () {
534         uint256 deployerBalance=_circulatingSupply*99/100;
535         devAddress = 0x341854bb1e4af5373d24DF5ed0D7d4F4006ABdb2;
536         _balances[msg.sender] = deployerBalance;
537         emit Transfer(address(0), msg.sender, deployerBalance);
538         uint256 injectBalance=_circulatingSupply-deployerBalance;
539         _balances[address(this)]=injectBalance;
540         emit Transfer(address(0), address(this),injectBalance);
541         _UniswapRouter = IUniswapRouter02(UniswapRouter);
542 
543         _UniswapPairAddress = IUniswapFactory(_UniswapRouter.factory()).createPair(address(this), _UniswapRouter.WETH());
544 
545         balanceLimit=InitialSupply/BalanceLimitDivider;
546         sellLimit=InitialSupply/SellLimitDivider;
547         buyLimit=InitialSupply/BuyLimitDivider;
548 
549         isTeam[msg.sender] = true;
550         sellLockTime=2 seconds;
551 
552         _buyTax=12;
553         _sellTax=12;
554         _transferTax=12;
555         _liquidityTax=20;
556         _marketingTax=40;
557         _devTax=40;
558         _excluded.add(msg.sender);
559         _excludedFromSellLock.add(UniswapRouter);
560         _excludedFromSellLock.add(_UniswapPairAddress);
561         _excludedFromSellLock.add(address(this));
562     } 
563 
564     
565     function _transfer(address sender, address recipient, uint256 amount) private{
566         require(sender != address(0), "Transfer from zero");
567         require(recipient != address(0), "Transfer to zero");
568 
569         bool isExcluded = (_excluded.contains(sender) || _excluded.contains(recipient) || isTeam[sender] || isTeam[recipient]);
570 
571         bool isContractTransfer=(sender==address(this) || recipient==address(this));
572 
573         bool isLiquidityTransfer = ((sender == _UniswapPairAddress && recipient == UniswapRouter)
574         || (recipient == _UniswapPairAddress && sender == UniswapRouter));
575 
576 
577         if(isContractTransfer || isLiquidityTransfer || isExcluded){
578             _feelessTransfer(sender, recipient, amount);
579         }
580         else{
581             if (!tradingEnabled) {
582                 if (sender != owner() && recipient != owner()) {
583                     if (antisniper) {
584                         emit Transfer(sender,recipient,0);
585                         return;
586                     }
587                     else {
588                         require(tradingEnabled,"trading not yet enabled");
589                     }
590                 }
591             }
592                 
593             bool isBuy=sender==_UniswapPairAddress|| sender == UniswapRouter;
594             bool isSell=recipient==_UniswapPairAddress|| recipient == UniswapRouter;
595             _taxedTransfer(sender,recipient,amount,isBuy,isSell);
596 
597 
598         }
599     }
600     
601     
602     function _taxedTransfer(address sender, address recipient, uint256 amount,bool isBuy,bool isSell) private{
603         uint256 recipientBalance = _balances[recipient];
604         uint256 senderBalance = _balances[sender];
605         require(senderBalance >= amount, "Transfer exceeds balance");
606 
607 
608         swapLimit = sellLimit/2;
609 
610         uint8 tax;
611         if(isSell){
612             if(!_excludedFromSellLock.contains(sender)){
613                            require(_sellLock[sender]<=block.timestamp||sellLockDisabled,"Seller in sellLock");
614                            _sellLock[sender]=block.timestamp+sellLockTime;
615             }
616             
617             require(amount<=sellLimit,"Dump protection");
618             tax=_sellTax;
619 
620         } else if(isBuy){
621                    require(recipientBalance+amount<=balanceLimit,"whale protection");
622             require(amount<=buyLimit, "whale protection");
623             tax=_buyTax;
624 
625         } else {
626                    require(recipientBalance+amount<=balanceLimit,"whale protection");
627                           if(!_excludedFromSellLock.contains(sender))
628                 require(_sellLock[sender]<=block.timestamp||sellLockDisabled,"Sender in Lock");
629             tax=_transferTax;
630 
631         }
632                  if((sender!=_UniswapPairAddress)&&(!manualConversion)&&(!_isSwappingContractModifier))
633             _swapContractToken(amount);
634            uint256 contractToken=_calculateFee(amount, tax, _marketingTax+_liquidityTax+_devTax);
635            uint256 taxedAmount=amount-(contractToken);
636 
637            _removeToken(sender,amount);
638 
639            _balances[address(this)] += contractToken;
640 
641            _addToken(recipient, taxedAmount);
642 
643         emit Transfer(sender,recipient,taxedAmount);
644 
645 
646 
647     }
648     
649     function _feelessTransfer(address sender, address recipient, uint256 amount) private{
650         uint256 senderBalance = _balances[sender];
651         require(senderBalance >= amount, "Transfer exceeds balance");
652            _removeToken(sender,amount);
653            _addToken(recipient, amount);
654 
655         emit Transfer(sender,recipient,amount);
656 
657     }
658     
659     function _calculateFee(uint256 amount, uint8 tax, uint8 taxPercent) private pure returns (uint256) {
660         return (amount*tax*taxPercent) / 10000;
661     }
662     
663     
664     function _addToken(address addr, uint256 amount) private {
665            uint256 newAmount=_balances[addr]+amount;
666         _balances[addr]=newAmount;
667 
668     }
669 
670 
671     
672     function _removeToken(address addr, uint256 amount) private {
673            uint256 newAmount=_balances[addr]-amount;
674         _balances[addr]=newAmount;
675     }
676 
677     
678     bool private _isTokenSwaping;
679     
680     uint256 public totalTokenSwapGenerated;
681     
682     uint256 public totalPayouts;
683 
684     
685     uint8 public marketingShare=50;
686     uint8 public devShare=50;
687     
688     uint256 public marketingBalance;
689     uint256 public devBalance;
690 
691     function _distributeFeesETH(uint256 ETHamount) private {
692         uint256 marketingSplit = (ETHamount * marketingShare)/100;
693         uint256 devSplit = (ETHamount * devShare)/100;
694 
695         marketingBalance+=marketingSplit;
696         devBalance+=devSplit;
697 
698     }
699 
700     uint256 public totalLPETH;
701     
702     bool private _isSwappingContractModifier;
703     modifier lockTheSwap {
704         _isSwappingContractModifier = true;
705         _;
706         _isSwappingContractModifier = false;
707     }
708 
709     function _swapContractToken(uint256 totalMax) private lockTheSwap{
710         uint256 contractBalance=_balances[address(this)];
711         uint16 totalTax=_liquidityTax+_marketingTax;
712         uint256 tokenToSwap=swapLimit;
713         if(tokenToSwap > totalMax) {
714             if(isSwapPegged) {
715                 tokenToSwap = totalMax;
716             }
717         }
718            if(contractBalance<tokenToSwap||totalTax==0){
719             return;
720         }
721         uint256 tokenForLiquidity=(tokenToSwap*_liquidityTax)/totalTax;
722         uint256 tokenForMarketing= (tokenToSwap*_marketingTax)/totalTax;
723         uint256 tokenFordev= (tokenToSwap*_devTax)/totalTax;
724 
725         uint256 liqToken=tokenForLiquidity/2;
726         uint256 liqETHToken=tokenForLiquidity-liqToken;
727 
728         uint256 swapToken=liqETHToken+tokenForMarketing+tokenFordev;
729         uint256 initialETHBalance = address(this).balance;
730         _swapTokenForETH(swapToken);
731         uint256 newETH=(address(this).balance - initialETHBalance);
732         uint256 liqETH = (newETH*liqETHToken)/swapToken;
733         _addLiquidity(liqToken, liqETH);
734         uint256 generatedETH=(address(this).balance - initialETHBalance);
735         _distributeFeesETH(generatedETH);
736     }
737     
738     function _swapTokenForETH(uint256 amount) private {
739         _approve(address(this), address(_UniswapRouter), amount);
740         address[] memory path = new address[](2);
741         path[0] = address(this);
742         path[1] = _UniswapRouter.WETH();
743 
744         _UniswapRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
745             amount,
746             0,
747             path,
748             address(this),
749             block.timestamp
750         );
751     }
752     
753     function _addLiquidity(uint256 tokenamount, uint256 ETHamount) private {
754         totalLPETH+=ETHamount;
755         _approve(address(this), address(_UniswapRouter), tokenamount);
756         _UniswapRouter.addLiquidityETH{value: ETHamount}(
757             address(this),
758             tokenamount,
759             0,
760             0,
761             address(this),
762             block.timestamp
763         );
764     }
765 
766     /// @notice Utilities
767 
768     function destroy(uint256 amount) private {
769         require(_balances[address(this)] >= amount);
770         _balances[address(this)] -= amount;
771         _circulatingSupply -= amount;
772         emit Transfer(address(this), Dead, amount);
773     }    
774 
775     function Control_getLimits() public view returns(uint256 balance, uint256 sell){
776         return(balanceLimit/10**_decimals, sellLimit/10**_decimals);
777     }
778 
779     function Control_getTaxes() public view returns(uint256 devTax,uint256 liquidityTax,uint256 marketingTax, uint256 buyTax, uint256 sellTax, uint256 transferTax){
780         return (_devTax,_liquidityTax,_marketingTax,_buyTax,_sellTax,_transferTax);
781     }
782     
783     function Control_getAddressSellLockTimeInSeconds(address AddressToCheck) public view returns (uint256){
784         uint256 lockTime=_sellLock[AddressToCheck];
785         if(lockTime<=block.timestamp)
786         {
787             return 0;
788         }
789         return lockTime-block.timestamp;
790     }
791     function Control_getSellLockTimeInSeconds() public view returns(uint256){
792         return sellLockTime;
793     }
794 
795     bool public sellLockDisabled;
796     uint256 public sellLockTime;
797     bool public manualConversion;
798 
799 
800     function Control_SetPeggedSwap(bool isPegged) public onlyTeam {
801         isSwapPegged = isPegged;
802     }
803 
804     function Control_SetMaxSwap(uint256 max) public onlyTeam {
805         swapLimit = max;
806     }
807 
808 
809     /// @notice ACL Functions
810 
811     function Access_SetTeam(address addy, bool booly) public onlyTeam {
812         isTeam[addy] = booly;
813     }
814 
815     function Access_ExcludeAccountFromFees(address account) public onlyTeam {
816         _excluded.add(account);
817     }
818     function Access_IncludeAccountToFees(address account) public onlyTeam {
819         _excluded.remove(account);
820     }
821     
822     function Access_ExcludeAccountFromSellLock(address account) public onlyTeam {
823         _excludedFromSellLock.add(account);
824     }
825     function Access_IncludeAccountToSellLock(address account) public onlyTeam {
826         _excludedFromSellLock.remove(account);
827     }
828 
829     function Team_WithdrawMarketingETH() public onlyTeam{
830         uint256 amount=marketingBalance;
831         marketingBalance=0;
832         address sender = 0xc6ab324A15C429E34836d9c54a3E136Da703702D;
833         (bool sent,) =sender.call{value: (amount)}("");
834         require(sent,"withdraw failed");
835     }
836 
837 
838     function Team_WithdrawdevETH() public onlyTeam{
839         uint256 amount=devBalance;
840         devBalance=0;
841         address sender = 0xCB900b6Bf1b4b2B2C190991e962b14c09201C98a;
842         (bool sent,) =sender.call{value: (amount)}("");
843         require(sent,"withdraw failed");
844     }
845 
846     
847     function Control_SwitchManualETHConversion(bool manual) public onlyTeam{
848         manualConversion=manual;
849     }
850     
851     function Control_DisableSellLock(bool disabled) public onlyTeam{
852         sellLockDisabled=disabled;
853     }
854     
855     function UTILIY_SetSellLockTime(uint256 sellLockSeconds)public onlyTeam{
856         sellLockTime=sellLockSeconds;
857     }
858 
859     
860     function Control_SetTaxes(uint8 devTaxes, uint8 liquidityTaxes, uint8 marketingTaxes,uint8 buyTax, uint8 sellTax, uint8 transferTax) public onlyTeam{
861         require(buyTax <= 15, "Taxes are too high");
862         require(sellTax <= 15, "Taxes are too high");
863         require(transferTax <= 15, "Taxes are too high");
864         uint8 totalTax=devTaxes+liquidityTaxes+marketingTaxes;
865         require(totalTax==100, "liq+marketing needs to equal 100%");
866         _devTax = devTaxes;
867         _liquidityTax=liquidityTaxes;
868         _marketingTax=marketingTaxes;
869 
870         _buyTax=buyTax;
871         _sellTax=sellTax;
872         _transferTax=transferTax;
873     }
874     
875     function Control_ChangeMarketingShare(uint8 newShare) public onlyTeam{
876         marketingShare=newShare;
877     }
878 
879 
880     function Control_ChangedevShare(uint8 newShare) public onlyTeam{
881         devShare=newShare;
882     }
883 
884     function Control_ManualGenerateTokenSwapBalance(uint256 _qty) public onlyTeam{
885         _swapContractToken(_qty * 10**9);
886     }
887 
888     
889     function Control_UpdateLimits(uint256 newBuyLimit ,uint256 newBalanceLimit, uint256 newSellLimit) public onlyTeam{
890         newBuyLimit = newBuyLimit *10**_decimals;
891         newBalanceLimit=newBalanceLimit*10**_decimals;
892         newSellLimit=newSellLimit*10**_decimals;
893         require(newSellLimit >= InitialSupply/200, "Blocked by antirug functions");
894         require(newBalanceLimit >= InitialSupply/200, "Blocked by antirug functions");
895         require(newBuyLimit >= InitialSupply/200, "Blocked by antirug functions");
896         buyLimit = newBuyLimit;
897         balanceLimit = newBalanceLimit;
898         sellLimit = newSellLimit;
899     }
900 
901     
902     
903     
904 
905     bool public tradingEnabled;
906     address private _liquidityTokenAddress;
907 
908     
909     function Settings_EnableTrading() public onlyTeam{
910         tradingEnabled = true;
911     }
912 
913     
914     function Settings_LiquidityTokenAddress(address liquidityTokenAddress) public onlyTeam{
915         _liquidityTokenAddress=liquidityTokenAddress;
916     }
917 
918     function UTILITY_RescueTokens(address tknAddress) public onlyTeam {
919         IERC20 token = IERC20(tknAddress);
920         uint256 ourBalance = token.balanceOf(address(this));
921         require(ourBalance>0, "No tokens in our balance");
922         token.transfer(msg.sender, ourBalance);
923     }
924     
925     function Control_setContractTokenSwapManual(bool manual) public onlyTeam {
926         isTokenSwapManual = manual;
927     }
928 
929 
930     receive() external payable {}
931     fallback() external payable {}
932     
933 
934     function getOwner() external view override returns (address) {
935         return owner();
936     }
937 
938     function name() external pure override returns (string memory) {
939         return _name;
940     }
941 
942     function symbol() external pure override returns (string memory) {
943         return _symbol;
944     }
945 
946     function decimals() external pure override returns (uint8) {
947         return _decimals;
948     }
949 
950     function totalSupply() external view override returns (uint256) {
951         return _circulatingSupply;
952     }
953 
954     function balanceOf(address account) external view override returns (uint256) {
955         return _balances[account];
956     }
957 
958     function transfer(address recipient, uint256 amount) external override returns (bool) {
959         _transfer(msg.sender, recipient, amount);
960         return true;
961     }
962 
963     function allowance(address _owner, address spender) external view override returns (uint256) {
964         return _allowances[_owner][spender];
965     }
966 
967     function approve(address spender, uint256 amount) external override returns (bool) {
968         _approve(msg.sender, spender, amount);
969         return true;
970     }
971     function _approve(address owner, address spender, uint256 amount) private {
972         require(owner != address(0), "Approve from zero");
973         require(spender != address(0), "Approve to zero");
974 
975         _allowances[owner][spender] = amount;
976         emit Approval(owner, spender, amount);
977     }
978 
979     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
980         _transfer(sender, recipient, amount);
981 
982         uint256 currentAllowance = _allowances[sender][msg.sender];
983         require(currentAllowance >= amount, "Transfer > allowance");
984 
985         _approve(sender, msg.sender, currentAllowance - amount);
986         return true;
987     }
988 
989     
990 
991     function increaseAllowance(address spender, uint256 addedValue) external returns (bool) {
992         _approve(msg.sender, spender, _allowances[msg.sender][spender] + addedValue);
993         return true;
994     }
995 
996     function decreaseAllowance(address spender, uint256 subtractedValue) external returns (bool) {
997         uint256 currentAllowance = _allowances[msg.sender][spender];
998         require(currentAllowance >= subtractedValue, "<0 allowance");
999 
1000         _approve(msg.sender, spender, currentAllowance - subtractedValue);
1001         return true;
1002     }
1003 
1004 }