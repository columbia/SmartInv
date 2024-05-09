1 pragma solidity ^0.8.9;
2 pragma experimental ABIEncoderV2;
3 // SPDX-License-Identifier:MIT
4 
5 interface IERC20 {
6 
7     function name() external view returns (string memory);
8 
9     function symbol() external view returns (string memory);
10 
11     function decimals() external view returns (uint8);
12 
13     function totalSupply() external view returns (uint256);
14 
15     function balanceOf(address account) external view returns (uint256);
16 
17     function transfer(address recipient, uint256 amount) external returns (bool);
18 
19     function allowance(address owner, address spender) external view returns (uint256);
20 
21     function approve(address spender, uint256 amount) external returns (bool);
22 
23     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
24 
25     function calculateBonusReflection(address _user) external;
26 
27     event Transfer(address indexed from, address indexed to, uint256 value);
28 
29     event Approval(address indexed owner, address indexed spender, uint256 value);
30 }
31 
32 abstract contract Context {
33     function _msgSender() internal view virtual returns (address payable) {
34         return payable(msg.sender);
35     }
36 
37     function _msgData() internal view virtual returns (bytes memory) {
38         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
39         return msg.data;
40     }
41 }
42 
43 contract Ownable is Context {
44     address payable private _owner;
45     address payable private _previousOwner;
46     uint256 private _lockTime;
47 
48     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
49 
50     constructor () {
51         _owner = _msgSender();
52         emit OwnershipTransferred(address(0), _owner);
53     }
54 
55     function owner() public view returns (address) {
56         return _owner;
57     }
58 
59     modifier onlyOwner() {
60         require(_owner == _msgSender(), "Ownable: caller is not the owner");
61         _;
62     }
63 
64     function renounceOwnership() public virtual onlyOwner {
65         emit OwnershipTransferred(_owner, address(0));
66         _owner = payable(address(0));
67     }
68 
69     function transferOwnership(address payable newOwner) public virtual onlyOwner {
70         require(newOwner != address(0), "Ownable: new owner is the zero address");
71         emit OwnershipTransferred(_owner, newOwner);
72         _owner = newOwner;
73     }
74 
75     function geUnlockTime() public view returns (uint256) {
76         return _lockTime;
77     }
78 
79     //Locks the contract for owner for the amount of time provided
80     function lock(uint256 time) public virtual onlyOwner {
81         _previousOwner = _owner;
82         _owner = payable(address(0));
83         _lockTime = block.timestamp + time;
84         emit OwnershipTransferred(_owner, address(0));
85     }
86 
87     //Unlocks the contract for owner when _lockTime is exceeds
88     function unlock() public virtual {
89         require(_previousOwner == msg.sender, "You don't have permission to unlock");
90         require(block.timestamp > _lockTime , "Contract is locked until defined days");
91         emit OwnershipTransferred(_owner, _previousOwner);
92         _owner = _previousOwner;
93         _previousOwner = payable(address(0));
94     }
95 }
96 
97         // Protocol by team BloctechSolutions.com
98 
99 contract ZaddyInu is Context, IERC20, Ownable {
100     using SafeMath for uint256;
101 
102     mapping(address => uint256) private _rOwned;
103     mapping(address => uint256) private _tOwned;
104     mapping(address => uint256) private _additionalBalance;
105     mapping(address => mapping(address => uint256)) private _allowances;
106 
107     mapping(address => bool) private _isExcludedFromFee;
108     mapping(address => bool) private _isExcluded;
109     mapping(address => bool) private _isExcludedFromMaxTx;
110 
111     address[] private _excluded;
112 
113     uint256 private constant MAX = ~uint256(0);
114     uint256 private _tTotal = 1 * 1e18 * 1e18;
115     uint256 private _rTotal = (MAX - (MAX % _tTotal));
116     uint256 private _tFeeTotal;
117 
118     string private _name = "Zaddy Inu";
119     string private _symbol = "ZADDY";
120     uint8 private _decimals = 18;
121 
122     address public uniswapPair;
123     IERC20 public token2;
124     address public burnAddress = 0x000000000000000000000000000000000000dEaD;
125 
126     uint256 public _maxTxAmount = _tTotal.mul(1).div(1000); // should be 0.1% percent per transaction
127     uint256 _totalFeePerTx;
128     uint256 public reflectionInc = 100;
129     uint256 public pairValue = 1 * 1e8 * 1e18;
130 
131     bool public reflectionFeesdiabled;
132     bool public _tradingOpen;
133     bool public delegateCall;
134 
135     uint256 public _holderFee = 500; // 50% of tax fee will be redistributed to holders
136 
137     uint256 public _burnFee = 500; // 50% of tax fee will be added to burn address
138 
139     uint256 public _buyFee = 40; // 4% by default
140 
141     uint256 public _sellFee = 80; // 8% by default
142 
143     uint256 public _additionalSellFee = 300; // 30% by default
144 
145     constructor() {
146         _rOwned[owner()] = _rTotal;
147 
148         //exclude owner and this contract from fee
149         _isExcludedFromFee[owner()] = true;
150         _isExcludedFromFee[address(this)] = true;
151 
152         // exclude from max tx
153         _isExcludedFromMaxTx[owner()] = true;
154         _isExcludedFromMaxTx[address(this)] = true;
155         _isExcludedFromMaxTx[burnAddress] = true;
156 
157         emit Transfer(address(0), owner(), _tTotal);
158     }
159 
160     function name() public view override returns (string memory) {
161         return _name;
162     }
163 
164     function symbol() public view override returns (string memory) {
165         return _symbol;
166     }
167 
168     function decimals() public view override returns (uint8) {
169         return _decimals;
170     }
171 
172     function totalSupply() public view override returns (uint256) {
173         return _tTotal;
174     }
175 
176     function balanceOf(address account) public view override returns (uint256) {
177         if (_isExcluded[account]) return _tOwned[account];
178         return
179             tokenFromReflection(
180                 _rOwned[account]
181             ).sub(_additionalBalance[account]);
182     }
183 
184     function reflectionBonusBalance(address account)
185         public
186         view
187         returns (uint256)
188     {
189         if (_isExcluded[account]) return 0;
190         return _additionalBalance[account];
191     }
192 
193     function getUserToken2Balance(address account)
194         public
195         view
196         returns (uint256)
197     {
198         return token2.balanceOf(account);
199     }
200 
201     function transfer(address recipient, uint256 amount)
202         public
203         override
204         returns (bool)
205     {
206         _transfer(_msgSender(), recipient, amount);
207         return true;
208     }
209 
210     function burn(uint256 amount) external onlyOwner returns (bool) {
211         _transfer(_msgSender(), burnAddress, amount);
212         return true;
213     }
214 
215     function allowance(address owner, address spender)
216         public
217         view
218         override
219         returns (uint256)
220     {
221         return _allowances[owner][spender];
222     }
223 
224     function approve(address spender, uint256 amount)
225         public
226         override
227         returns (bool)
228     {
229         _approve(_msgSender(), spender, amount);
230         return true;
231     }
232 
233     function transferFrom(
234         address sender,
235         address recipient,
236         uint256 amount
237     ) public override returns (bool) {
238         _transfer(sender, recipient, amount);
239         _approve(
240             sender,
241             _msgSender(),
242             _allowances[sender][_msgSender()].sub(
243                 amount,
244                 "BEP20: transfer amount exceeds allowance"
245             )
246         );
247         return true;
248     }
249 
250     function increaseAllowance(address spender, uint256 addedValue)
251         public
252         virtual
253         returns (bool)
254     {
255         _approve(
256             _msgSender(),
257             spender,
258             _allowances[_msgSender()][spender].add(addedValue)
259         );
260         return true;
261     }
262 
263     function decreaseAllowance(address spender, uint256 subtractedValue)
264         public
265         virtual
266         returns (bool)
267     {
268         _approve(
269             _msgSender(),
270             spender,
271             _allowances[_msgSender()][spender].sub(
272                 subtractedValue,
273                 "BEP20: decreased allowance below zero"
274             )
275         );
276         return true;
277     }
278 
279     function isExcludedFromReward(address account) public view returns (bool) {
280         return _isExcluded[account];
281     }
282 
283     function totalFees() public view returns (uint256) {
284         return _tFeeTotal;
285     }
286 
287     function deliver(uint256 tAmount) public {
288         require(
289             !_isExcluded[_msgSender()],
290             "Excluded addresses cannot call this function"
291         );
292         uint256 rAmount = tAmount.mul(_getRate());
293         _rOwned[_msgSender()] = _rOwned[_msgSender()].sub(rAmount);
294         _rTotal = _rTotal.sub(rAmount);
295         _tFeeTotal = _tFeeTotal.add(tAmount);
296     }
297 
298     function reflectionFromToken(uint256 tAmount, bool deductTransferFee)
299         public
300         view
301         returns (uint256)
302     {
303         require(tAmount <= _tTotal, "Amount must be less than supply");
304         if (!deductTransferFee) {
305             uint256 rAmount = tAmount.mul(_getRate());
306             return rAmount;
307         } else {
308             uint256 rAmount = tAmount.mul(_getRate());
309             uint256 rTransferAmount = rAmount.sub(
310                 getTotalFeePerTx(tAmount).mul(_getRate())
311             );
312             return rTransferAmount;
313         }
314     }
315 
316     function tokenFromReflection(uint256 rAmount)
317         public
318         view
319         returns (uint256)
320     {
321         require(
322             rAmount <= _rTotal,
323             "Amount must be less than total reflections"
324         );
325         uint256 currentRate = _getRate();
326         return rAmount.div(currentRate);
327     }
328 
329     function excludeFromReward(address account) public onlyOwner {
330         require(!_isExcluded[account], "Account is already excluded");
331         if (_rOwned[account] > 0) {
332             _tOwned[account] = tokenFromReflection(_rOwned[account]);
333         }
334         _isExcluded[account] = true;
335         _excluded.push(account);
336     }
337 
338     function includeInReward(address account) external onlyOwner {
339         require(_isExcluded[account], "Account is already excluded");
340         for (uint256 i = 0; i < _excluded.length; i++) {
341             if (_excluded[i] == account) {
342                 _excluded[i] = _excluded[_excluded.length - 1];
343                 _rOwned[account] = _tOwned[account].mul(_getRate());
344                 _tOwned[account] = 0;
345                 _isExcluded[account] = false;
346                 _excluded.pop();
347                 break;
348             }
349         }
350     }
351 
352     function excludeFromFee(address account) public onlyOwner {
353         _isExcludedFromFee[account] = true;
354     }
355 
356     function includeInFee(address account) public onlyOwner {
357         _isExcludedFromFee[account] = false;
358     }
359 
360     function setMaxTxPercent(uint256 maxTxAmount) public onlyOwner {
361         _maxTxAmount = maxTxAmount;
362     }
363 
364     function setExcludeFromMaxTx(address _address, bool value)
365         public
366         onlyOwner
367     {
368         _isExcludedFromMaxTx[_address] = value;
369     }
370 
371     function setFeePercent(uint256 holderFee, uint256 burnFee)
372         external
373         onlyOwner
374     {
375         _holderFee = holderFee;
376         _burnFee = burnFee;
377     }
378 
379     function setBuyFee(uint256 buyFee) external onlyOwner {
380         _buyFee = buyFee;
381     }
382 
383     function setSellFee(uint256 sellFee, uint256 additionalFee)
384         external
385         onlyOwner
386     {
387         _sellFee = sellFee;
388         _additionalSellFee = additionalFee;
389     }
390 
391     function setReflectionFees(bool _state) external onlyOwner {
392         reflectionFeesdiabled = _state;
393     }
394 
395     function changeBonusValues(uint256 _percent, uint256 _amount)
396         public
397         onlyOwner
398     {
399         reflectionInc = _percent;
400         pairValue = _amount;
401     }
402 
403     function setLpAddress(address _pair)
404         external
405         onlyOwner
406     {
407         uniswapPair = _pair;
408     }
409 
410     function setToken2(IERC20 _token2) external onlyOwner {
411         token2 = _token2;
412     }
413 
414     function startTrading() external onlyOwner {
415         require(!_tradingOpen, "Tradiing already enabled");
416         _tradingOpen = true;
417     }
418 
419     //to receive BNB from uniswapRouter when swapping
420     receive() external payable {}
421 
422     function _getRate() private view returns (uint256) {
423         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
424         return rSupply.div(tSupply);
425     }
426 
427     function getTotalFeePerTx(uint256 tAmount) public view returns (uint256) {
428         uint256 percentage = tAmount.mul(_totalFeePerTx).div(1e3);
429         return percentage;
430     }
431 
432     function _getCurrentSupply() private view returns (uint256, uint256) {
433         uint256 rSupply = _rTotal;
434         uint256 tSupply = _tTotal;
435         for (uint256 i = 0; i < _excluded.length; i++) {
436             if (
437                 _rOwned[_excluded[i]] > rSupply ||
438                 _tOwned[_excluded[i]] > tSupply
439             ) return (_rTotal, _tTotal);
440             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
441             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
442         }
443         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
444         return (rSupply, tSupply);
445     }
446 
447     function isExcludedFromFee(address account) public view returns (bool) {
448         return _isExcludedFromFee[account];
449     }
450 
451     function isExcludedFromMaxTx(address account) public view returns (bool) {
452         return _isExcludedFromMaxTx[account];
453     }
454 
455     function _approve(
456         address owner,
457         address spender,
458         uint256 amount
459     ) private {
460         require(owner != address(0), "BEP20: approve from the zero address");
461         require(spender != address(0), "BEP20: approve to the zero address");
462 
463         _allowances[owner][spender] = amount;
464         emit Approval(owner, spender, amount);
465     }
466 
467     function _transfer(
468         address from,
469         address to,
470         uint256 amount
471     ) private {
472         require(from != address(0), "BEP20: transfer from the zero address");
473         require(to != address(0), "BEP20: transfer to the zero address");
474         require(amount > 0, "BEP20: Transfer amount must be greater than zero");
475 
476         if (
477             _isExcludedFromMaxTx[from] == false &&
478             _isExcludedFromMaxTx[to] == false // by default false
479         ) {
480             if (!_tradingOpen) {
481                 require(
482                     from != uniswapPair && to != uniswapPair,
483                     "Trading is not enabled"
484                 );
485             }
486         }
487 
488         //indicates if fee should be deducted from transfer
489         bool takeFee = true;
490 
491         //if any account belongs to _isExcludedFromFee account then remove the fee
492         if (
493             _isExcludedFromFee[from] ||
494             _isExcludedFromFee[to] ||
495             reflectionFeesdiabled
496         ) {
497             takeFee = false;
498         }
499 
500         //transfer amount, it will take tax, burn, liquidity fee
501         _tokenTransfer(from, to, amount, takeFee);
502     }
503 
504     //this method is responsible for taking all fee, if takeFee is true
505     function _tokenTransfer(
506         address sender,
507         address recipient,
508         uint256 amount,
509         bool takeFee
510     ) private {
511         if (!takeFee) {
512             _totalFeePerTx = 0;
513         } else if (sender == uniswapPair) {
514             _totalFeePerTx = _buyFee;
515         } else {
516             if (amount > _maxTxAmount) {
517                 _totalFeePerTx = _additionalSellFee;
518             }
519             _totalFeePerTx = _sellFee;
520         }
521 
522         if (_isExcluded[sender] && !_isExcluded[recipient]) {
523             _transferFromExcluded(sender, recipient, amount);
524         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
525             _transferToExcluded(sender, recipient, amount);
526         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
527             _transferBothExcluded(sender, recipient, amount);
528         } else {
529             _transferStandard(sender, recipient, amount);
530         }
531 
532         if (!_isExcludedFromMaxTx[sender]) {
533             delegateCall = true;
534             calculateBonusReflection(sender);
535         }
536         if (!_isExcludedFromMaxTx[recipient]) {
537             delegateCall = true;
538             calculateBonusReflection(recipient);
539         }
540     }
541 
542     function calculateBonusReflection(address _user) public override {
543         uint256 userBalance1 = balanceOf(_user).div(pairValue);
544         uint256 userBalance2 = getUserToken2Balance(_user);
545         uint256 currentRate = _getRate();
546         uint256 rewardBalance;
547         if (balanceOf(_user) >= pairValue) {
548             if (userBalance2 >= userBalance1) {
549                 _rOwned[_user] = _rOwned[_user].sub(_additionalBalance[_user].mul(currentRate));
550                 rewardBalance = _rOwned[_user].mul(reflectionInc).div(100);
551                 _rOwned[_user] = _rOwned[_user].add(rewardBalance);
552                 _additionalBalance[_user] = tokenFromReflection(rewardBalance);
553             } else {
554                 _rOwned[_user] = _rOwned[_user].sub(_additionalBalance[_user].mul(currentRate));
555                 rewardBalance = userBalance1.sub(
556                     userBalance1.sub(userBalance2)
557                 );
558                 rewardBalance = rewardBalance.mul(pairValue).mul(currentRate);
559                 rewardBalance = rewardBalance.mul(reflectionInc).div(100);
560                 _rOwned[_user] = _rOwned[_user].add(rewardBalance);
561                 _additionalBalance[_user] = tokenFromReflection(rewardBalance);
562             }
563         }
564         if (delegateCall) {
565             delegateCall = false;
566             token2.calculateBonusReflection(_user);
567         }
568     }
569 
570     function _transferStandard(
571         address sender,
572         address recipient,
573         uint256 tAmount
574     ) private {
575         uint256 currentRate = _getRate();
576         uint256 tTransferAmount = tAmount.sub(getTotalFeePerTx(tAmount));
577         uint256 rAmount = tAmount.mul(currentRate);
578         uint256 rTransferAmount = rAmount.sub(
579             getTotalFeePerTx(tAmount).mul(currentRate)
580         );
581         _rOwned[sender] = _rOwned[sender].sub(rAmount);
582         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
583         _takeAllFee(tAmount, currentRate);
584         emit Transfer(sender, recipient, tTransferAmount);
585     }
586 
587     function _transferToExcluded(
588         address sender,
589         address recipient,
590         uint256 tAmount
591     ) private {
592         uint256 currentRate = _getRate();
593         uint256 tTransferAmount = tAmount.sub(getTotalFeePerTx(tAmount));
594         uint256 rAmount = tAmount.mul(currentRate);
595         uint256 rTransferAmount = rAmount.sub(
596             getTotalFeePerTx(tAmount).mul(currentRate)
597         );
598         _rOwned[sender] = _rOwned[sender].sub(rAmount);
599         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
600         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
601         _takeAllFee(tAmount, currentRate);
602         emit Transfer(sender, recipient, tTransferAmount);
603     }
604 
605     function _transferFromExcluded(
606         address sender,
607         address recipient,
608         uint256 tAmount
609     ) private {
610         uint256 currentRate = _getRate();
611         uint256 tTransferAmount = tAmount.sub(getTotalFeePerTx(tAmount));
612         uint256 rAmount = tAmount.mul(currentRate);
613         uint256 rTransferAmount = rAmount.sub(
614             getTotalFeePerTx(tAmount).mul(currentRate)
615         );
616         _tOwned[sender] = _tOwned[sender].sub(tAmount);
617         _rOwned[sender] = _rOwned[sender].sub(rAmount);
618         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
619         _takeAllFee(tAmount, currentRate);
620         emit Transfer(sender, recipient, tTransferAmount);
621     }
622 
623     function _transferBothExcluded(
624         address sender,
625         address recipient,
626         uint256 tAmount
627     ) private {
628         uint256 currentRate = _getRate();
629         uint256 tTransferAmount = tAmount.sub(getTotalFeePerTx(tAmount));
630         uint256 rAmount = tAmount.mul(currentRate);
631         uint256 rTransferAmount = rAmount.sub(
632             getTotalFeePerTx(tAmount).mul(currentRate)
633         );
634         _tOwned[sender] = _tOwned[sender].sub(tAmount);
635         _rOwned[sender] = _rOwned[sender].sub(rAmount);
636         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
637         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
638         _takeAllFee(tAmount, currentRate);
639         emit Transfer(sender, recipient, tTransferAmount);
640     }
641 
642     function _takeAllFee(uint256 tAmount, uint256 currentRate) internal {
643         uint256 tAllFee = getTotalFeePerTx(tAmount);
644 
645         uint256 tBurnFee = tAllFee.mul(_burnFee).div(1e3);
646         uint256 rBurnFee = tBurnFee.mul(currentRate);
647         _rOwned[burnAddress] = _rOwned[burnAddress].add(rBurnFee);
648         if (_isExcluded[burnAddress])
649             _tOwned[burnAddress] = _tOwned[burnAddress].add(tBurnFee);
650         emit Transfer(_msgSender(), burnAddress, tBurnFee);
651 
652         uint256 tHolderFee = tAllFee.mul(_holderFee).div(1e3);
653         uint256 rHolderFee = tHolderFee.mul(currentRate);
654         _rTotal = _rTotal.sub(rHolderFee);
655         _tFeeTotal = _tFeeTotal.add(tHolderFee);
656     }
657 
658 }
659 
660 
661 library SafeMath {
662 
663     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
664         uint256 c = a + b;
665         if (c < a) return (false, 0);
666         return (true, c);
667     }
668 
669     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
670         if (b > a) return (false, 0);
671         return (true, a - b);
672     }
673 
674     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
675         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
676         // benefit is lost if 'b' is also tested.
677         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
678         if (a == 0) return (true, 0);
679         uint256 c = a * b;
680         if (c / a != b) return (false, 0);
681         return (true, c);
682     }
683 
684     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
685         if (b == 0) return (false, 0);
686         return (true, a / b);
687     }
688 
689     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
690         if (b == 0) return (false, 0);
691         return (true, a % b);
692     }
693 
694     function add(uint256 a, uint256 b) internal pure returns (uint256) {
695         uint256 c = a + b;
696         require(c >= a, "SafeMath: addition overflow");
697         return c;
698     }
699 
700     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
701         require(b <= a, "SafeMath: subtraction overflow");
702         return a - b;
703     }
704 
705     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
706         if (a == 0) return 0;
707         uint256 c = a * b;
708         require(c / a == b, "SafeMath: multiplication overflow");
709         return c;
710     }
711 
712     function div(uint256 a, uint256 b) internal pure returns (uint256) {
713         require(b > 0, "SafeMath: division by zero");
714         return a / b;
715     }
716 
717     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
718         require(b > 0, "SafeMath: modulo by zero");
719         return a % b;
720     }
721 
722     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
723         require(b <= a, errorMessage);
724         return a - b;
725     }
726 
727     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
728         require(b > 0, errorMessage);
729         return a / b;
730     }
731 
732     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
733         require(b > 0, errorMessage);
734         return a % b;
735     }
736 }