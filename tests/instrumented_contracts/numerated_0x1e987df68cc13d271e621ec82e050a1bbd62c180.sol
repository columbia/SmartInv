1 /**
2  * SPDX-License-Identifier: MIT
3  */ 
4  
5 // Wagmi - WE ARE ALL GOING TO MAKE IT
6 
7 pragma solidity ^0.8.6;
8 
9 library SafeMath {
10 
11     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
12         uint256 c = a + b;
13         if (c < a) return (false, 0);
14         return (true, c);
15     }
16 
17     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
18         if (b > a) return (false, 0);
19         return (true, a - b);
20     }
21 
22     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
23         if (a == 0) return (true, 0);
24         uint256 c = a * b;
25         if (c / a != b) return (false, 0);
26         return (true, c);
27     }
28 
29 
30     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
31         if (b == 0) return (false, 0);
32         return (true, a / b);
33     }
34 
35     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
36         if (b == 0) return (false, 0);
37         return (true, a % b);
38     }
39 
40     function add(uint256 a, uint256 b) internal pure returns (uint256) {
41         uint256 c = a + b;
42         require(c >= a, "SafeMath: addition overflow");
43         return c;
44     }
45 
46     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47         require(b <= a, "SafeMath: subtraction overflow");
48         return a - b;
49     }
50 
51 
52     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
53         if (a == 0) return 0;
54         uint256 c = a * b;
55         require(c / a == b, "SafeMath: multiplication overflow");
56         return c;
57     }
58 
59     function div(uint256 a, uint256 b) internal pure returns (uint256) {
60         require(b > 0, "SafeMath: division by zero");
61         return a / b;
62     }
63 
64     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
65         require(b > 0, "SafeMath: modulo by zero");
66         return a % b;
67     }
68 
69 
70     function sub(
71         uint256 a,
72         uint256 b,
73         string memory errorMessage
74     ) internal pure returns (uint256) {
75         require(b <= a, errorMessage);
76         return a - b;
77     }
78 
79  
80     function div(
81         uint256 a,
82         uint256 b,
83         string memory errorMessage
84     ) internal pure returns (uint256) {
85         require(b > 0, errorMessage);
86         return a / b;
87     }
88 
89     function mod(
90         uint256 a,
91         uint256 b,
92         string memory errorMessage
93     ) internal pure returns (uint256) {
94         require(b > 0, errorMessage);
95         return a % b;
96     }
97 }
98 
99 interface IERC20 {
100     function totalSupply() external view returns (uint256);
101     function balanceOf(address account) external view returns (uint256);
102     function transfer(address recipient, uint256 amount) external returns (bool);
103     function allowance(address owner, address spender) external view returns (uint256);
104     function approve(address spender, uint256 amount) external returns (bool);
105     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
106     event Transfer(address indexed from, address indexed to, uint256 value);
107     event Approval(address indexed owner, address indexed spender, uint256 value);
108 }
109 
110 interface IERC20Metadata is IERC20 {
111     function name() external view returns (string memory);
112     function symbol() external view returns (string memory);
113     function decimals() external view returns (uint8);
114 }
115 
116 abstract contract Context {
117     function _msgSender() internal view virtual returns (address) {return msg.sender;}
118     function _msgData() internal view virtual returns (bytes calldata) {this; return msg.data;}
119 }
120 
121 library Address {
122     function isContract(address account) internal view returns (bool) { 
123         uint256 size; assembly { size := extcodesize(account) } return size > 0;
124     }
125     function sendValue(address payable recipient, uint256 amount) internal {
126         require(address(this).balance >= amount, "Address: insufficient balance");(bool success, ) = recipient.call{ value: amount }("");
127         require(success, "Address: unable to send value, recipient may have reverted");
128     }
129     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
130         return functionCall(target, data, "Address: low-level call failed");
131         
132     }
133     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
134         return functionCallWithValue(target, data, 0, errorMessage);
135         
136     }
137     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
138         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
139         
140     }
141     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
142         require(address(this).balance >= value, "Address: insufficient balance for call");
143         require(isContract(target), "Address: call to non-contract");
144         (bool success, bytes memory returndata) = target.call{ value: value }(data);
145         return _verifyCallResult(success, returndata, errorMessage);
146     }
147     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
148         return functionStaticCall(target, data, "Address: low-level static call failed");
149     }
150     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
151         require(isContract(target), "Address: static call to non-contract");
152         (bool success, bytes memory returndata) = target.staticcall(data);
153         return _verifyCallResult(success, returndata, errorMessage);
154     }
155     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
156         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
157     }
158     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
159         require(isContract(target), "Address: delegate call to non-contract");
160         (bool success, bytes memory returndata) = target.delegatecall(data);
161         return _verifyCallResult(success, returndata, errorMessage);
162     }
163     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
164         if (success) { return returndata; } else {
165             if (returndata.length > 0) {
166                 assembly {
167                     let returndata_size := mload(returndata)
168                     revert(add(32, returndata), returndata_size)
169                 }
170             } else {revert(errorMessage);}
171         }
172     }
173 }
174 
175 abstract contract Ownable is Context {
176     address private _owner;
177     address private _previousOwner;
178     uint256 private _lockTime;
179 
180     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
181 
182     constructor () {
183         address msgSender = _msgSender();
184         _owner = msgSender;
185         emit OwnershipTransferred(address(0), msgSender);
186     }
187 
188     function owner() public view returns (address) {
189         return _owner;
190     }   
191     
192     modifier onlyOwner() {
193         require(_owner == _msgSender(), "Ownable: caller is not the owner");
194         _;
195     }
196     
197     function renounceOwnership() public virtual onlyOwner {
198         emit OwnershipTransferred(_owner, address(0));
199         _owner = address(0);
200     }
201 
202     function transferOwnership(address newOwner) public virtual onlyOwner {
203         require(newOwner != address(0), "Ownable: new owner is the zero address");
204         emit OwnershipTransferred(_owner, newOwner);
205         _owner = newOwner;
206     }
207 
208     function getUnlockTime() public view returns (uint256) {
209         return _lockTime;
210     }
211     
212     function getTime() public view returns (uint256) {
213         return block.timestamp;
214     }
215 
216     function lock(uint256 time) public virtual onlyOwner {
217         _previousOwner = _owner;
218         _owner = address(0);
219         _lockTime = block.timestamp + time;
220         emit OwnershipTransferred(_owner, address(0));
221     }
222     
223     function unlock() public virtual {
224         require(_previousOwner == msg.sender, "You don't have permission to unlock");
225         require(block.timestamp > _lockTime , "Contract is locked until 7 days");
226         emit OwnershipTransferred(_owner, _previousOwner);
227         _owner = _previousOwner;
228     }
229 }
230 
231 interface IPancakeV2Factory {
232     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
233     function createPair(address tokenA, address tokenB) external returns (address pair);
234 }
235 
236 interface IPancakeV2Router {
237     function factory() external pure returns (address);
238     function WETH() external pure returns (address);
239     
240     function addLiquidity(
241         address tokenA,
242         address tokenB,
243         uint amountADesired,
244         uint amountBDesired,
245         uint amountAMin,
246         uint amountBMin,
247         address to,
248         uint deadline
249     ) external returns (uint amountA, uint amountB, uint liquidity);
250 
251     function addLiquidityETH(
252         address token,
253         uint amountTokenDesired,
254         uint amountTokenMin,
255         uint amountETHMin,
256         address to,
257         uint deadline
258     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
259 
260     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
261         uint amountIn,
262         uint amountOutMin,
263         address[] calldata path,
264         address to,
265         uint deadline
266     ) external;
267 
268     function swapExactETHForTokensSupportingFeeOnTransferTokens(
269         uint amountOutMin,
270         address[] calldata path,
271         address to,
272         uint deadline
273     ) external payable;
274 
275     function swapExactTokensForETHSupportingFeeOnTransferTokens(
276         uint amountIn,
277         uint amountOutMin,
278         address[] calldata path,
279         address to,
280         uint deadline
281     ) external;
282 }
283 
284 contract WAGMI is IERC20Metadata, Ownable {
285     using SafeMath for uint256;
286     using Address for address;
287     
288     address internal deadAddress = 0x000000000000000000000000000000000000dEaD;
289     address public presaleAddress = address(0);
290     
291     address public marketingWallet = 0x10b33D3CbcB6f674fc626bfd83a701D2422352E2;
292     address public devWallet = 0x8Da67EF3CA0D9a2e28EB32DDd323295A64d20AD3;
293     address public teamWallet = 0xf96cb8E903AE8AABf92c5668871e5ACE37316c64;
294     
295     string constant _name = "WAGMI";
296     string constant _symbol = "WAGMI";
297     uint8 constant _decimals = 18;
298     
299     uint256 private constant MAX = ~uint256(0);
300     uint256 internal constant _totalSupply = 1000000000000 * (10**18);
301     uint256 internal _reflectedSupply = (MAX - (MAX % _totalSupply));
302     
303     uint256 public collectedFeeTotal;
304   
305     uint256 public maxTxAmount = _totalSupply / 1000; // 0.5% of the total supply
306     uint256 public maxWalletBalance = _totalSupply / 50; // 2% of the total supply
307     
308     bool public takeFeeEnabled = true;
309     bool public tradingIsEnabled = true;
310     bool public isInPresale = false;
311     
312     bool private swapping;
313     bool public swapEnabled = true;
314     uint256 public swapTokensAtAmount = 10000000 * (10**18);
315 
316     bool public antiBotEnabled = false;
317     uint256 public antiBotFee = 990; // 99%
318     uint256 public _startTimeForSwap;
319     
320     uint256 internal FEES_DIVISOR = 10**3;
321     
322     uint256 public rfiFee = 10; // 1%
323     uint256 public marketingFee = 30; // 3%
324     uint256 public devFee = 20; // 2%
325     uint256 public teamFee = 25; // 2.5%
326     uint256 public lpFee = 15; // 1.5%
327     uint256 public totalFee = rfiFee.add(marketingFee).add(devFee).add(teamFee).add(lpFee);
328     
329     // Total = 100% (1000)
330     uint256 public marketingPortionOfSwap = 500; // 50%
331     uint256 public devPortionOfSwap = 200; // 20%
332     uint256 public teamPortionOfSwap = 150; // 15%
333     uint256 public lpPortionOfSwap = 150; // 15%
334     
335     IPancakeV2Router public router;
336     address public pair;
337     
338     
339     mapping (address => uint256) internal _reflectedBalances;
340     mapping (address => uint256) internal _balances;
341     mapping (address => mapping (address => uint256)) internal _allowances;
342 
343     mapping(address => bool) public _isBlacklisted;
344     
345     mapping (address => bool) internal _isExcludedFromFee;
346     mapping (address => bool) internal _isExcludedFromRewards;
347     address[] private _excluded;
348     
349     event UpdatePancakeswapRouter(address indexed newAddress, address indexed oldAddress);
350     event ExcludeFromFees(address indexed account, bool isExcluded);
351     event ExcludeMultipleAccountsFromFees(address[] accounts, bool isExcluded);
352     
353     event MarketingWalletUpdated(address indexed newMarketingWallet, address indexed oldMarketingWallet);
354     event DevWalletUpdated(address indexed newDevWallet, address indexed oldDevWallet);
355     event TeamWalletUpdated(address indexed newTeamWallet, address indexed oldTeamWallet);
356     
357     event LiquidityAdded(uint256 tokenAmountSent, uint256 ethAmountSent, uint256 liquidity);
358     
359     event SwapTokensForETH(
360         uint256 amountIn,
361         address[] path
362     );
363     
364     constructor () {
365         _reflectedBalances[owner()] = _reflectedSupply;
366         
367         IPancakeV2Router _newPancakeRouter = IPancakeV2Router(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
368         pair = IPancakeV2Factory(_newPancakeRouter.factory()).createPair(address(this), _newPancakeRouter.WETH());
369         router = _newPancakeRouter;
370         
371         // exclude owner and this contract from fee
372         _isExcludedFromFee[owner()] = true;
373         _isExcludedFromFee[address(this)] = true;
374         
375         // exclude the owner and this contract from rewards
376         _exclude(owner());
377         _exclude(address(this));
378         
379         // exclude the pair address from rewards - we don't want to redistribute
380         _exclude(pair);
381         _exclude(deadAddress);
382         
383         _approve(owner(), address(router), ~uint256(0));
384         
385         emit Transfer(address(0), owner(), _totalSupply);
386     }
387     
388     receive() external payable { }
389     
390     function name() external pure override returns (string memory) {
391         return _name;
392     }
393 
394     function symbol() external pure override returns (string memory) {
395         return _symbol;
396     }
397 
398     function decimals() external pure override returns (uint8) {
399         return _decimals;
400     }
401 
402     function totalSupply() external pure override returns (uint256) {
403         return _totalSupply;
404     }
405     
406     function balanceOf(address account) public view override returns (uint256){
407         if (_isExcludedFromRewards[account]) return _balances[account];
408         return tokenFromReflection(_reflectedBalances[account]);
409         }
410         
411     function transfer(address recipient, uint256 amount) external override returns (bool){
412         _transfer(_msgSender(), recipient, amount);
413         return true;
414         }
415         
416     function allowance(address owner, address spender) external view override returns (uint256){
417         return _allowances[owner][spender];
418         }
419     
420     function approve(address spender, uint256 amount) external override returns (bool) {
421         _approve(_msgSender(), spender, amount);
422         return true;
423         }
424         
425     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool){
426         _transfer(sender, recipient, amount);
427         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
428         return true;
429         }
430         
431     function burn(uint256 amount) external {
432 
433         address sender = _msgSender();
434         require(sender != address(0), "ERC20: burn from the zero address");
435         require(sender != address(deadAddress), "ERC20: burn from the burn address");
436 
437         uint256 balance = balanceOf(sender);
438         require(balance >= amount, "ERC20: burn amount exceeds balance");
439 
440         uint256 reflectedAmount = amount.mul(_getCurrentRate());
441 
442         // remove the amount from the sender's balance first
443         _reflectedBalances[sender] = _reflectedBalances[sender].sub(reflectedAmount);
444         if (_isExcludedFromRewards[sender])
445             _balances[sender] = _balances[sender].sub(amount);
446 
447         _burnTokens( sender, amount, reflectedAmount );
448     }
449     
450     /**
451      * @dev "Soft" burns the specified amount of tokens by sending them 
452      * to the burn address
453      */
454     function _burnTokens(address sender, uint256 tBurn, uint256 rBurn) internal {
455 
456         /**
457          * @dev Do not reduce _totalSupply and/or _reflectedSupply. (soft) burning by sending
458          * tokens to the burn address (which should be excluded from rewards) is sufficient
459          * in RFI
460          */ 
461         _reflectedBalances[deadAddress] = _reflectedBalances[deadAddress].add(rBurn);
462         if (_isExcludedFromRewards[deadAddress])
463             _balances[deadAddress] = _balances[deadAddress].add(tBurn);
464 
465         /**
466          * @dev Emit the event so that the burn address balance is updated (on bscscan)
467          */
468         emit Transfer(sender, deadAddress, tBurn);
469     }
470     
471     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
472         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
473         return true;
474     }
475     
476     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
477         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
478         return true;
479     }
480     
481     function _approve(address owner, address spender, uint256 amount) internal {
482         require(owner != address(0), "BaseRfiToken: approve from the zero address");
483         require(spender != address(0), "BaseRfiToken: approve to the zero address");
484 
485         _allowances[owner][spender] = amount;
486         emit Approval(owner, spender, amount);
487     }
488     
489     
490      /**
491      * @dev Calculates and returns the reflected amount for the given amount with or without 
492      * the transfer fees (deductTransferFee true/false)
493      */
494     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) external view returns(uint256) {
495         require(tAmount <= _totalSupply, "Amount must be less than supply");
496         uint256 feesSum;
497         if (!deductTransferFee) {
498             (uint256 rAmount,,,,) = _getValues(tAmount,0);
499             return rAmount;
500         } else {
501             feesSum = totalFee;
502             (,uint256 rTransferAmount,,,) = _getValues(tAmount, feesSum);
503             return rTransferAmount;
504         }
505     }
506 
507     /**
508      * @dev Calculates and returns the amount of tokens corresponding to the given reflected amount.
509      */
510     function tokenFromReflection(uint256 rAmount) internal view returns(uint256) {
511         require(rAmount <= _reflectedSupply, "Amount must be less than total reflections");
512         uint256 currentRate = _getCurrentRate();
513         return rAmount.div(currentRate);
514     }
515     
516     function excludeFromReward(address account) external onlyOwner() {
517         require(!_isExcludedFromRewards[account], "Account is not included");
518         _exclude(account);
519     }
520     
521     function _exclude(address account) internal {
522         if(_reflectedBalances[account] > 0) {
523             _balances[account] = tokenFromReflection(_reflectedBalances[account]);
524         }
525         _isExcludedFromRewards[account] = true;
526         _excluded.push(account);
527     }
528 
529     function includeInReward(address account) external onlyOwner() {
530         require(_isExcludedFromRewards[account], "Account is not excluded");
531         for (uint256 i = 0; i < _excluded.length; i++) {
532             if (_excluded[i] == account) {
533                 _excluded[i] = _excluded[_excluded.length - 1];
534                 _balances[account] = 0;
535                 _isExcludedFromRewards[account] = false;
536                 _excluded.pop();
537                 break;
538             }
539         }
540     }
541     
542     function setExcludedFromFee(address account, bool value) external onlyOwner { 
543         _isExcludedFromFee[account] = value; 
544     }
545 
546     function _getValues(uint256 tAmount, uint256 feesSum) internal view returns (uint256, uint256, uint256, uint256, uint256) {
547         
548         uint256 tTotalFees = tAmount.mul(feesSum).div(FEES_DIVISOR);
549         uint256 tTransferAmount = tAmount.sub(tTotalFees);
550         uint256 currentRate = _getCurrentRate();
551         uint256 rAmount = tAmount.mul(currentRate);
552         uint256 rTotalFees = tTotalFees.mul(currentRate);
553         uint256 rTransferAmount = rAmount.sub(rTotalFees);
554         
555         return (rAmount, rTransferAmount, tAmount, tTransferAmount, currentRate);
556     }
557     
558     function _getCurrentRate() internal view returns(uint256) {
559         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
560         return rSupply.div(tSupply);
561     }
562     
563     function _getCurrentSupply() internal view returns(uint256, uint256) {
564         uint256 rSupply = _reflectedSupply;
565         uint256 tSupply = _totalSupply;
566 
567         /**
568          * The code below removes balances of addresses excluded from rewards from
569          * rSupply and tSupply, which effectively increases the % of transaction fees
570          * delivered to non-excluded holders
571          */    
572         for (uint256 i = 0; i < _excluded.length; i++) {
573             if (_reflectedBalances[_excluded[i]] > rSupply || _balances[_excluded[i]] > tSupply)
574             return (_reflectedSupply, _totalSupply);
575             rSupply = rSupply.sub(_reflectedBalances[_excluded[i]]);
576             tSupply = tSupply.sub(_balances[_excluded[i]]);
577         }
578         if (tSupply == 0 || rSupply < _reflectedSupply.div(_totalSupply)) return (_reflectedSupply, _totalSupply);
579         return (rSupply, tSupply);
580     }
581     
582     
583     /**
584      * @dev Redistributes the specified amount among the current holders via the reflect.finance
585      * algorithm, i.e. by updating the _reflectedSupply (_rSupply) which ultimately adjusts the
586      * current rate used by `tokenFromReflection` and, in turn, the value returns from `balanceOf`. 
587      * 
588      */
589     function _redistribute(uint256 amount, uint256 currentRate, uint256 fee) internal {
590         uint256 tFee = amount.mul(fee).div(FEES_DIVISOR);
591         uint256 rFee = tFee.mul(currentRate);
592 
593         _reflectedSupply = _reflectedSupply.sub(rFee);
594         
595         collectedFeeTotal = collectedFeeTotal.add(tFee);
596     }
597     
598     function _burn(uint256 amount, uint256 currentRate, uint256 fee) private {
599         uint256 tBurn = amount.mul(fee).div(FEES_DIVISOR);
600         uint256 rBurn = tBurn.mul(currentRate);
601 
602         _burnTokens(address(this), tBurn, rBurn);
603         
604         collectedFeeTotal = collectedFeeTotal.add(tBurn);
605     }
606 
607     function totalCollectedFees() external view returns (uint256) {
608         return collectedFeeTotal;
609     }
610     
611      function isExcludedFromReward(address account) external view returns (bool) {
612         return _isExcludedFromRewards[account];
613     }
614     
615     function isExcludedFromFee(address account) public view returns(bool) { 
616         return _isExcludedFromFee[account]; 
617     }
618     
619     function whitelistDxSale(address _presaleAddress, address _routerAddress) external onlyOwner {
620   	    presaleAddress = _presaleAddress;
621   	    
622         _exclude(_presaleAddress);
623         _isExcludedFromFee[_presaleAddress] = true;
624 
625         _exclude(_routerAddress);
626         _isExcludedFromFee[_routerAddress] = true;
627   	}
628 
629     function blacklistAddress(address account, bool value) external onlyOwner{
630         _isBlacklisted[account] = value;
631     }
632  
633     function prepareForPreSale() external onlyOwner {
634         takeFeeEnabled = false;
635         swapEnabled = false;
636         isInPresale = true;
637         maxTxAmount = _totalSupply;
638         maxWalletBalance = _totalSupply;
639     }
640     
641     function afterPreSale() external onlyOwner {
642         takeFeeEnabled = true;
643         swapEnabled = true;
644         isInPresale = false;
645         maxTxAmount = _totalSupply / 1000;
646         maxWalletBalance = _totalSupply / 50;
647     }
648     
649     function setSwapEnabled(bool _enabled) external onlyOwner {
650         swapEnabled  = _enabled;
651     }
652     
653     function updateSwapTokensAt(uint256 _swaptokens) external onlyOwner {
654         swapTokensAtAmount = _swaptokens * (10**18);
655     }
656     
657     function updateWalletMax(uint256 _walletMax) external onlyOwner {
658         maxWalletBalance = _walletMax * (10**18);
659     }
660     
661     function updateTransactionMax(uint256 _txMax) external onlyOwner {
662         maxTxAmount = _txMax * (10**18);
663     }
664     
665     function calcTotalFees() private {
666         totalFee = rfiFee.add(marketingFee).add(devFee).add(teamFee).add(lpFee);
667     }
668     
669     function updateRfiFee(uint256 newFee) external onlyOwner {
670         rfiFee = newFee;
671         calcTotalFees();
672     }
673     
674     function updateMarketingFee(uint256 newFee) external onlyOwner {
675         marketingFee = newFee;
676         calcTotalFees();
677     }
678     
679     function updateDevFee(uint256 newFee) external onlyOwner {
680         devFee = newFee;
681         calcTotalFees();
682     }
683     
684     function updateTeamFee(uint256 newFee) external onlyOwner {
685         teamFee = newFee;
686         calcTotalFees();
687     }
688     
689     function updateLpFee(uint256 newFee) external onlyOwner {
690         lpFee = newFee;
691         calcTotalFees();
692     }
693     
694     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
695         require(newMarketingWallet != marketingWallet, "The Marketing wallet is already this address");
696         emit MarketingWalletUpdated(newMarketingWallet, marketingWallet);
697         
698         marketingWallet = newMarketingWallet;
699     }
700     
701     function updateDevWallet(address newDevWallet) external onlyOwner {
702         require(newDevWallet != devWallet, "The Dev wallet is already this address");
703         emit DevWalletUpdated(newDevWallet, devWallet);
704         
705         devWallet = newDevWallet;
706     }
707     
708     function updateTeamWallet(address newTeamWallet) external onlyOwner {
709         require(newTeamWallet != teamWallet, "The Team wallet is already this address");
710         emit TeamWalletUpdated(newTeamWallet, teamWallet);
711         
712         teamWallet = newTeamWallet;
713     }
714     
715     function updatePortionsOfSwap(uint256 marketingPortion, uint256  devPortion, uint256 lpPortion, uint256 teamPortion) 
716     external onlyOwner {
717         
718         uint256 totalPortion = marketingPortion.add(devPortion).add(lpPortion).add(teamPortion);
719         require(totalPortion == 1000, "Total must be equal to 1000 (100%)");
720         
721         marketingPortionOfSwap = marketingPortion;
722         devPortionOfSwap = devPortion;
723         lpPortionOfSwap = lpPortion;
724         teamPortionOfSwap = teamPortion;
725     }
726     
727     function setFeesDivisor(uint256 divisor) external onlyOwner() {
728         FEES_DIVISOR = divisor;
729     }
730     
731     function updateTradingIsEnabled(bool tradingStatus) external onlyOwner() {
732         tradingIsEnabled = tradingStatus;
733     }
734     
735     function updateRouterAddress(address newAddress) external onlyOwner {
736         require(newAddress != address(router), "The router already has that address");
737         emit UpdatePancakeswapRouter(newAddress, address(router));
738         
739         router = IPancakeV2Router(newAddress);   
740     }
741 
742     function toggleAntiBot(bool toggleStatus) external onlyOwner() {
743         antiBotEnabled = toggleStatus;
744         if(antiBotEnabled){
745             _startTimeForSwap = block.timestamp + 60;    
746         }    
747     }
748     
749     function _takeFee(uint256 amount, uint256 currentRate, uint256 fee, address recipient) private {
750         uint256 tAmount = amount.mul(fee).div(FEES_DIVISOR);
751         uint256 rAmount = tAmount.mul(currentRate);
752 
753         _reflectedBalances[recipient] = _reflectedBalances[recipient].add(rAmount);
754         if(_isExcludedFromRewards[recipient])
755             _balances[recipient] = _balances[recipient].add(tAmount);
756 
757         collectedFeeTotal = collectedFeeTotal.add(tAmount);
758     }
759     
760     function _transferTokens(address sender, address recipient, uint256 amount, bool takeFee) private {
761         
762         uint256 sumOfFees = totalFee;
763         sumOfFees = antiBotEnabled && block.timestamp <= _startTimeForSwap ? antiBotFee : sumOfFees;
764         
765         if ( !takeFee ){ sumOfFees = 0; }
766         
767         processReflectedBal(sender, recipient, amount, sumOfFees);
768        
769     }
770     
771     function processReflectedBal (address sender, address recipient, uint256 amount, uint256 sumOfFees) private {
772         
773         (uint256 rAmount, uint256 rTransferAmount, uint256 tAmount, 
774         uint256 tTransferAmount, uint256 currentRate ) = _getValues(amount, sumOfFees);
775          
776         theReflection(sender, recipient, rAmount, rTransferAmount, tAmount, tTransferAmount); 
777         
778         _takeFees(amount, currentRate, sumOfFees);
779         
780         emit Transfer(sender, recipient, tTransferAmount);    
781     }
782     
783     function theReflection(address sender, address recipient, uint256 rAmount, uint256 rTransferAmount, uint256 tAmount, 
784         uint256 tTransferAmount) private {
785             
786         _reflectedBalances[sender] = _reflectedBalances[sender].sub(rAmount);
787         _reflectedBalances[recipient] = _reflectedBalances[recipient].add(rTransferAmount);
788         
789         /**
790          * Update the true/nominal balances for excluded accounts
791          */        
792         if (_isExcludedFromRewards[sender]) { _balances[sender] = _balances[sender].sub(tAmount); }
793         if (_isExcludedFromRewards[recipient] ) { _balances[recipient] = _balances[recipient].add(tTransferAmount); }
794     }
795     
796     
797     function _takeFees(uint256 amount, uint256 currentRate, uint256 sumOfFees) private {
798         if ( sumOfFees > 0 && !isInPresale ){
799             _redistribute( amount, currentRate, rfiFee );  // redistribute to holders
800             
801             uint256 otherFees = sumOfFees.sub(rfiFee);
802             _takeFee( amount, currentRate, otherFees, address(this));
803 
804         }
805     }
806     
807     function _transfer(address sender, address recipient, uint256 amount) private {
808         require(sender != address(0), "Token: transfer from the zero address");
809         require(recipient != address(0), "Token: transfer to the zero address");
810         require(sender != address(deadAddress), "Token: transfer from the burn address");
811         require(amount > 0, "Transfer amount must be greater than zero");
812         
813         require(tradingIsEnabled, "This account cannot send tokens until trading is enabled");
814 
815         require(!_isBlacklisted[sender] && !_isBlacklisted[recipient], "Blacklisted address");
816         
817         if (
818             sender != address(router) && //router -> pair is removing liquidity which shouldn't have max
819             !_isExcludedFromFee[recipient] && //no max for those excluded from fees
820             !_isExcludedFromFee[sender] 
821         ) {
822             require(amount <= maxTxAmount, "Transfer amount exceeds the Max Transaction Amount.");
823             
824         }
825         
826         if ( maxWalletBalance > 0 && !_isExcludedFromFee[recipient] && !_isExcludedFromFee[sender] && recipient != address(pair) ) {
827                 uint256 recipientBalance = balanceOf(recipient);
828                 require(recipientBalance + amount <= maxWalletBalance, "New balance would exceed the maxWalletBalance");
829             }
830             
831          // indicates whether or not fee should be deducted from the transfer
832         bool _isTakeFee = takeFeeEnabled;
833         if ( isInPresale ){ _isTakeFee = false; }
834         
835          // if any account belongs to _isExcludedFromFee account then remove the fee
836         if(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]) { 
837             _isTakeFee = false; 
838         }
839         
840         _beforeTokenTransfer(recipient);
841         _transferTokens(sender, recipient, amount, _isTakeFee);
842         
843     }
844     
845     function _beforeTokenTransfer(address recipient) private {
846             
847         if ( !isInPresale ){
848             uint256 contractTokenBalance = balanceOf(address(this));
849             // swap
850             bool canSwap = contractTokenBalance >= swapTokensAtAmount;
851             
852             if (!swapping && canSwap && swapEnabled && recipient == pair) {
853                 swapping = true;
854                 
855                 swapBack();
856                 
857                 swapping = false;
858             }
859             
860         }
861     }
862     
863     function swapBack() internal {
864         uint256 splitLiquidityPortion = lpPortionOfSwap.div(2);
865         uint256 amountToLiquify = balanceOf(address(this)).mul(splitLiquidityPortion).div(FEES_DIVISOR);
866         uint256 amountToSwap = balanceOf(address(this)).sub(amountToLiquify);
867 
868         uint256 balanceBefore = address(this).balance;
869         
870         swapTokensForETH(amountToSwap);
871 
872         uint256 amountBNB = address(this).balance.sub(balanceBefore);
873         
874         uint256 amountBNBMarketing = amountBNB.mul(marketingPortionOfSwap).div(FEES_DIVISOR);
875         uint256 amountBNBDev = amountBNB.mul(devPortionOfSwap).div(FEES_DIVISOR);
876         uint256 amountBNBTeam = amountBNB.mul(teamPortionOfSwap).div(FEES_DIVISOR);
877         uint256 amountBNBLiquidity = amountBNB.mul(splitLiquidityPortion).div(FEES_DIVISOR);
878         
879           //Send to addresses
880         transferToAddress(payable(marketingWallet), amountBNBMarketing);
881         transferToAddress(payable(devWallet), amountBNBDev);
882         transferToAddress(payable(teamWallet), amountBNBTeam);
883         
884         // add liquidity
885         _addLiquidity(amountToLiquify, amountBNBLiquidity);
886     }
887     
888     function _addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
889         // approve token transfer to cover all possible scenarios
890         _approve(address(this), address(router), tokenAmount);
891 
892         // add the liquidity
893         (uint256 tokenAmountSent, uint256 ethAmountSent, uint256 liquidity) = router.addLiquidityETH{value: ethAmount}(
894             address(this),
895             tokenAmount,
896             0,
897             0,
898             owner(),
899             block.timestamp
900         );
901 
902         emit LiquidityAdded(tokenAmountSent, ethAmountSent, liquidity);
903     }
904     
905     function swapTokensForETH(uint256 tokenAmount) private {
906         // generate the uniswap pair path of token -> weth
907         address[] memory path = new address[](2);
908         path[0] = address(this);
909         path[1] = router.WETH();
910 
911         _approve(address(this), address(router), tokenAmount);
912 
913         // make the swap
914         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
915             tokenAmount,
916             0, // accept any amount of ETH
917             path,
918             address(this),
919             block.timestamp
920         );
921         
922         emit SwapTokensForETH(tokenAmount, path);
923     }
924     
925     function transferToAddress(address payable recipient, uint256 amount) private {
926         recipient.transfer(amount);
927     }
928     
929     function TransferETH(address payable recipient, uint256 amount) external onlyOwner {
930         require(recipient != address(0), "Cannot withdraw the ETH balance to the zero address");
931         recipient.transfer(amount);
932     }
933     
934 }