1 /**
2  * SPDX-License-Identifier: MIT
3  */ 
4  
5 // TG: https://t.me/okapiportal
6 // Twitter: @okapi_eth
7 // Medium: https://medium.com/@okapiETH
8 // Web: http://okapitoken.com
9 
10 pragma solidity ^0.8.6;
11 
12 abstract contract ReentrancyGuard {
13     // Booleans are more expensive than uint256 or any type that takes up a full
14     // word because each write operation emits an extra SLOAD to first read the
15     // slot's contents, replace the bits taken up by the boolean, and then write
16     // back. This is the compiler's defense against contract upgrades and
17     // pointer aliasing, and it cannot be disabled.
18 
19     // The values being non-zero value makes deployment a bit more expensive,
20     // but in exchange the refund on every call to nonReentrant will be lower in
21     // amount. Since refunds are capped to a percentage of the total
22     // transaction's gas, it is best to keep them low in cases like this one, to
23     // increase the likelihood of the full refund coming into effect.
24     uint256 private constant _NOT_ENTERED = 1;
25     uint256 private constant _ENTERED = 2;
26 
27     uint256 private _status;
28 
29     constructor() {
30         _status = _NOT_ENTERED;
31     }
32 
33     /**
34      * @dev Prevents a contract from calling itself, directly or indirectly.
35      * Calling a `nonReentrant` function from another `nonReentrant`
36      * function is not supported. It is possible to prevent this from happening
37      * by making the `nonReentrant` function external, and making it call a
38      * `private` function that does the actual work.
39      */
40     modifier nonReentrant() {
41         // On the first call to nonReentrant, _notEntered will be true
42         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
43 
44         // Any calls to nonReentrant after this point will fail
45         _status = _ENTERED;
46 
47         _;
48 
49         // By storing the original value once again, a refund is triggered (see
50         // https://eips.ethereum.org/EIPS/eip-2200)
51         _status = _NOT_ENTERED;
52     }
53 }
54 
55 library SafeMath {
56 
57     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
58         uint256 c = a + b;
59         if (c < a) return (false, 0);
60         return (true, c);
61     }
62 
63     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
64         if (b > a) return (false, 0);
65         return (true, a - b);
66     }
67 
68     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
69         if (a == 0) return (true, 0);
70         uint256 c = a * b;
71         if (c / a != b) return (false, 0);
72         return (true, c);
73     }
74 
75 
76     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
77         if (b == 0) return (false, 0);
78         return (true, a / b);
79     }
80 
81     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
82         if (b == 0) return (false, 0);
83         return (true, a % b);
84     }
85 
86     function add(uint256 a, uint256 b) internal pure returns (uint256) {
87         uint256 c = a + b;
88         require(c >= a, "SafeMath: addition overflow");
89         return c;
90     }
91 
92     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
93         require(b <= a, "SafeMath: subtraction overflow");
94         return a - b;
95     }
96 
97 
98     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
99         if (a == 0) return 0;
100         uint256 c = a * b;
101         require(c / a == b, "SafeMath: multiplication overflow");
102         return c;
103     }
104 
105     function div(uint256 a, uint256 b) internal pure returns (uint256) {
106         require(b > 0, "SafeMath: division by zero");
107         return a / b;
108     }
109 
110     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
111         require(b > 0, "SafeMath: modulo by zero");
112         return a % b;
113     }
114 
115 
116     function sub(
117         uint256 a,
118         uint256 b,
119         string memory errorMessage
120     ) internal pure returns (uint256) {
121         require(b <= a, errorMessage);
122         return a - b;
123     }
124 
125  
126     function div(
127         uint256 a,
128         uint256 b,
129         string memory errorMessage
130     ) internal pure returns (uint256) {
131         require(b > 0, errorMessage);
132         return a / b;
133     }
134 
135     function mod(
136         uint256 a,
137         uint256 b,
138         string memory errorMessage
139     ) internal pure returns (uint256) {
140         require(b > 0, errorMessage);
141         return a % b;
142     }
143 }
144 
145 interface IERC20 {
146     function totalSupply() external view returns (uint256);
147     function balanceOf(address account) external view returns (uint256);
148     function transfer(address recipient, uint256 amount) external returns (bool);
149     function allowance(address owner, address spender) external view returns (uint256);
150     function approve(address spender, uint256 amount) external returns (bool);
151     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
152     event Transfer(address indexed from, address indexed to, uint256 value);
153     event Approval(address indexed owner, address indexed spender, uint256 value);
154 }
155 
156 interface IERC20Metadata is IERC20 {
157     function name() external view returns (string memory);
158     function symbol() external view returns (string memory);
159     function decimals() external view returns (uint8);
160 }
161 
162 abstract contract Context {
163     function _msgSender() internal view virtual returns (address) {return msg.sender;}
164     function _msgData() internal view virtual returns (bytes calldata) {this; return msg.data;}
165 }
166 
167 library Address {
168     function isContract(address account) internal view returns (bool) { 
169         uint256 size; assembly { size := extcodesize(account) } return size > 0;
170     }
171     function sendValue(address payable recipient, uint256 amount) internal {
172         require(address(this).balance >= amount, "Address: insufficient balance");(bool success, ) = recipient.call{ value: amount }("");
173         require(success, "Address: unable to send value, recipient may have reverted");
174     }
175     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
176         return functionCall(target, data, "Address: low-level call failed");
177         
178     }
179     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
180         return functionCallWithValue(target, data, 0, errorMessage);
181         
182     }
183     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
184         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
185         
186     }
187     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
188         require(address(this).balance >= value, "Address: insufficient balance for call");
189         require(isContract(target), "Address: call to non-contract");
190         (bool success, bytes memory returndata) = target.call{ value: value }(data);
191         return _verifyCallResult(success, returndata, errorMessage);
192     }
193     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
194         return functionStaticCall(target, data, "Address: low-level static call failed");
195     }
196     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
197         require(isContract(target), "Address: static call to non-contract");
198         (bool success, bytes memory returndata) = target.staticcall(data);
199         return _verifyCallResult(success, returndata, errorMessage);
200     }
201     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
202         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
203     }
204     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
205         require(isContract(target), "Address: delegate call to non-contract");
206         (bool success, bytes memory returndata) = target.delegatecall(data);
207         return _verifyCallResult(success, returndata, errorMessage);
208     }
209     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
210         if (success) { return returndata; } else {
211             if (returndata.length > 0) {
212                 assembly {
213                     let returndata_size := mload(returndata)
214                     revert(add(32, returndata), returndata_size)
215                 }
216             } else {revert(errorMessage);}
217         }
218     }
219 }
220 
221 abstract contract Ownable is Context {
222     address private _owner;
223 
224     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
225 
226     constructor () {
227         address msgSender = _msgSender();
228         _owner = msgSender;
229         emit OwnershipTransferred(address(0), msgSender);
230     }
231 
232     function owner() public view returns (address) {
233         return _owner;
234     }   
235     
236     modifier onlyOwner() {
237         require(_owner == _msgSender(), "Ownable: caller is not the owner");
238         _;
239     }
240     
241     function renounceOwnership() public virtual onlyOwner {
242         emit OwnershipTransferred(_owner, address(0));
243         _owner = address(0);
244     }
245 
246     function transferOwnership(address newOwner) public virtual onlyOwner {
247         require(newOwner != address(0), "Ownable: new owner is the zero address");
248         emit OwnershipTransferred(_owner, newOwner);
249         _owner = newOwner;
250     }
251 }
252 
253 interface IPancakeV2Factory {
254     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
255     function createPair(address tokenA, address tokenB) external returns (address pair);
256 }
257 
258 interface IPancakeV2Router {
259     function factory() external pure returns (address);
260     function WETH() external pure returns (address);
261     
262     function addLiquidity(
263         address tokenA,
264         address tokenB,
265         uint amountADesired,
266         uint amountBDesired,
267         uint amountAMin,
268         uint amountBMin,
269         address to,
270         uint deadline
271     ) external returns (uint amountA, uint amountB, uint liquidity);
272 
273     function addLiquidityETH(
274         address token,
275         uint amountTokenDesired,
276         uint amountTokenMin,
277         uint amountETHMin,
278         address to,
279         uint deadline
280     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
281 
282     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
283         uint amountIn,
284         uint amountOutMin,
285         address[] calldata path,
286         address to,
287         uint deadline
288     ) external;
289 
290     function swapExactETHForTokensSupportingFeeOnTransferTokens(
291         uint amountOutMin,
292         address[] calldata path,
293         address to,
294         uint deadline
295     ) external payable;
296 
297     function swapExactTokensForETHSupportingFeeOnTransferTokens(
298         uint amountIn,
299         uint amountOutMin,
300         address[] calldata path,
301         address to,
302         uint deadline
303     ) external;
304 }
305 
306 contract OKAPI is IERC20Metadata, Ownable, ReentrancyGuard {
307     using SafeMath for uint256;
308     using Address for address;
309     
310     address internal deadAddress = 0x000000000000000000000000000000000000dEaD;
311     
312     address public marketingWallet = 0xBDB65749dE8C4641621aA63D19cAA24C3768a013;
313     address public endowmentWallet = 0x3ab2579A25915A6EC41B88CFe5d5f19D6241e4dD;
314     
315     string constant _name = "OKAPI";
316     string constant _symbol = "OKAPI";
317     uint8 constant _decimals = 18;
318     
319     uint256 private constant MAX = ~uint256(0);
320     uint256 internal constant _totalSupply = 10_000_000 * (10**18);
321     uint256 internal _reflectedSupply = (MAX - (MAX % _totalSupply));
322     
323     uint256 public collectedFeeTotal;
324   
325     uint256 public maxTxAmount = _totalSupply / 1000; // 0.1% of the total supply
326     uint256 public maxWalletBalance = _totalSupply / 50; // 2% of the total supply
327     
328     bool public takeFeeEnabled = true;
329     bool public tradingIsEnabled = true;
330     bool public isInPresale = false;
331     
332     bool private swapping;
333     bool public swapEnabled = true;
334     uint256 public swapTokensAtAmount = 100_000 * (10**18);
335 
336     bool public antiBotEnabled = false;
337     uint256 public antiBotFee = 990; // 99%
338     uint256 public _startTimeForSwap;
339     
340     uint256 private constant FEES_DIVISOR = 10**3;
341     
342     uint256 public marketingFee = 12; // 1.2%
343     uint256 public endowmentFee = 12; // 1.2%
344     uint256 public lpFee = 5; // 0.5%
345     uint256 private totalFee;
346     
347     // Total = 100% (1000)
348     uint256 public marketingPortionOfSwap = 500; // 50%
349     uint256 public endowmentPortionOfSwap = 300; // 30%
350     uint256 public lpPortionOfSwap = 200; // 20%
351     
352     IPancakeV2Router public router;
353     address public pair;
354     
355     
356     mapping (address => uint256) internal _reflectedBalances;
357     mapping (address => uint256) internal _balances;
358     mapping (address => mapping (address => uint256)) internal _allowances;
359 
360     mapping(address => bool) public _isBlacklisted;
361     
362     mapping (address => bool) internal _isExcludedFromFee;
363     mapping (address => bool) internal _isExcludedFromRewards;
364     address[] private _excluded;
365     
366     event UpdatePancakeswapRouter(address indexed newAddress, address indexed oldAddress);
367     event ExcludeFromFees(address indexed account, bool isExcluded);
368     event ExcludeMultipleAccountsFromFees(address[] accounts, bool isExcluded);
369     
370     event MarketingWalletUpdated(address indexed newMarketingWallet, address indexed oldMarketingWallet);
371     event EndowmentWalletUpdated(address indexed newEndowmentWallet, address indexed oldEndowmentWallet);
372     
373     event LiquidityAdded(uint256 tokenAmountSent, uint256 ethAmountSent, uint256 liquidity);
374     
375     event SwapTokensForETH(uint256 amountIn, address[] path);
376 
377     modifier zeroAddressCheck(address _theAddress) {
378         require(_theAddress != address(0), "Address cannot be the zero address");
379         _;
380     }
381     
382     constructor () {
383         _reflectedBalances[owner()] = _reflectedSupply;
384         
385         IPancakeV2Router _newPancakeRouter = IPancakeV2Router(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
386         pair = IPancakeV2Factory(_newPancakeRouter.factory()).createPair(address(this), _newPancakeRouter.WETH());
387         router = _newPancakeRouter;
388 
389         // set fees
390         totalFee = marketingFee.add(endowmentFee).add(lpFee);
391         
392         // exclude owner and this contract from fee
393         _isExcludedFromFee[owner()] = true;
394         _isExcludedFromFee[address(this)] = true;
395         
396         // exclude the owner and this contract from rewards
397         _exclude(owner());
398         _exclude(address(this));
399         
400         // exclude the pair address from rewards - we don't want to redistribute
401         _exclude(pair);
402         _exclude(deadAddress);
403         
404         _approve(owner(), address(router), ~uint256(0));
405         
406         emit Transfer(address(0), owner(), _totalSupply);
407     }
408     
409     receive() external payable { }
410     
411     function name() external pure override returns (string memory) {
412         return _name;
413     }
414 
415     function symbol() external pure override returns (string memory) {
416         return _symbol;
417     }
418 
419     function decimals() external pure override returns (uint8) {
420         return _decimals;
421     }
422 
423     function totalSupply() external pure override returns (uint256) {
424         return _totalSupply;
425     }
426     
427     function balanceOf(address account) public view override returns (uint256){
428         if (_isExcludedFromRewards[account]) return _balances[account];
429         return tokenFromReflection(_reflectedBalances[account]);
430         }
431         
432     function transfer(address recipient, uint256 amount) external override returns (bool){
433         _transfer(_msgSender(), recipient, amount);
434         return true;
435         }
436         
437     function allowance(address owner, address spender) external view override returns (uint256){
438         return _allowances[owner][spender];
439         }
440     
441     function approve(address spender, uint256 amount) external override returns (bool) {
442         _approve(_msgSender(), spender, amount);
443         return true;
444         }
445         
446     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool){
447         _transfer(sender, recipient, amount);
448         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
449         return true;
450         }
451         
452     function burn(uint256 amount) external nonReentrant {
453 
454         address sender = _msgSender();
455         require(sender != address(0), "ERC20: burn from the zero address");
456         require(sender != address(deadAddress), "ERC20: burn from the burn address");
457 
458         uint256 balance = balanceOf(sender);
459         require(balance >= amount, "ERC20: burn amount exceeds balance");
460 
461         uint256 reflectedAmount = amount.mul(_getCurrentRate());
462 
463         // remove the amount from the sender's balance first
464         _reflectedBalances[sender] = _reflectedBalances[sender].sub(reflectedAmount);
465         if (_isExcludedFromRewards[sender])
466             _balances[sender] = _balances[sender].sub(amount);
467 
468         _burnTokens( sender, amount, reflectedAmount );
469     }
470     
471     /**
472      * @dev "Soft" burns the specified amount of tokens by sending them 
473      * to the burn address
474      */
475     function _burnTokens(address sender, uint256 tBurn, uint256 rBurn) internal {
476 
477         /**
478          * @dev Do not reduce _totalSupply and/or _reflectedSupply. (soft) burning by sending
479          * tokens to the burn address (which should be excluded from rewards) is sufficient
480          * in RFI
481          */ 
482         _reflectedBalances[deadAddress] = _reflectedBalances[deadAddress].add(rBurn);
483         if (_isExcludedFromRewards[deadAddress])
484             _balances[deadAddress] = _balances[deadAddress].add(tBurn);
485 
486         /**
487          * @dev Emit the event so that the burn address balance is updated (on bscscan)
488          */
489         emit Transfer(sender, deadAddress, tBurn);
490     }
491     
492     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
493         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
494         return true;
495     }
496     
497     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
498         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
499         return true;
500     }
501     
502     function _approve(address owner, address spender, uint256 amount) internal {
503         require(owner != address(0), "BaseRfiToken: approve from the zero address");
504         require(spender != address(0), "BaseRfiToken: approve to the zero address");
505 
506         _allowances[owner][spender] = amount;
507         emit Approval(owner, spender, amount);
508     }
509     
510     
511      /**
512      * @dev Calculates and returns the reflected amount for the given amount with or without 
513      * the transfer fees (deductTransferFee true/false)
514      */
515     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) external view returns(uint256) {
516         require(tAmount <= _totalSupply, "Amount must be less than supply");
517         uint256 feesSum;
518         if (!deductTransferFee) {
519             (uint256 rAmount,,,,) = _getValues(tAmount,0);
520             return rAmount;
521         } else {
522             feesSum = totalFee;
523             (,uint256 rTransferAmount,,,) = _getValues(tAmount, feesSum);
524             return rTransferAmount;
525         }
526     }
527 
528     /**
529      * @dev Calculates and returns the amount of tokens corresponding to the given reflected amount.
530      */
531     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
532         require(rAmount <= _reflectedSupply, "Amount must be less than total reflections");
533         uint256 currentRate = _getCurrentRate();
534         return rAmount.div(currentRate);
535     }
536     
537     function excludeFromReward(address account) external onlyOwner() {
538         require(!_isExcludedFromRewards[account], "Account is not included");
539         _exclude(account);
540     }
541     
542     function _exclude(address account) private {
543         if(_reflectedBalances[account] > 0) {
544             _balances[account] = tokenFromReflection(_reflectedBalances[account]);
545         }
546         _isExcludedFromRewards[account] = true;
547         _excluded.push(account);
548     }
549 
550     function includeInReward(address account) external onlyOwner() {
551         require(_isExcludedFromRewards[account], "Account is not excluded");
552         for (uint256 i = 0; i < _excluded.length; i++) {
553             if (_excluded[i] == account) {
554                 _excluded[i] = _excluded[_excluded.length - 1];
555                 _balances[account] = 0;
556                 _isExcludedFromRewards[account] = false;
557                 _excluded.pop();
558                 break;
559             }
560         }
561     }
562     
563     function setExcludedFromFee(address account, bool value) external onlyOwner { 
564         _isExcludedFromFee[account] = value; 
565     }
566 
567     function _getValues(uint256 tAmount, uint256 feesSum) internal view returns (uint256, uint256, uint256, uint256, uint256) {
568         
569         uint256 tTotalFees = tAmount.mul(feesSum).div(FEES_DIVISOR);
570         uint256 tTransferAmount = tAmount.sub(tTotalFees);
571         uint256 currentRate = _getCurrentRate();
572         uint256 rAmount = tAmount.mul(currentRate);
573         uint256 rTotalFees = tTotalFees.mul(currentRate);
574         uint256 rTransferAmount = rAmount.sub(rTotalFees);
575         
576         return (rAmount, rTransferAmount, tAmount, tTransferAmount, currentRate);
577     }
578     
579     function _getCurrentRate() internal view returns(uint256) {
580         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
581         return rSupply.div(tSupply);
582     }
583     
584     function _getCurrentSupply() internal view returns(uint256, uint256) {
585         uint256 rSupply = _reflectedSupply;
586         uint256 tSupply = _totalSupply;
587 
588         /**
589          * The code below removes balances of addresses excluded from rewards from
590          * rSupply and tSupply, which effectively increases the % of transaction fees
591          * delivered to non-excluded holders
592          */    
593         for (uint256 i = 0; i < _excluded.length; i++) {
594             if (_reflectedBalances[_excluded[i]] > rSupply || _balances[_excluded[i]] > tSupply)
595             return (_reflectedSupply, _totalSupply);
596             rSupply = rSupply.sub(_reflectedBalances[_excluded[i]]);
597             tSupply = tSupply.sub(_balances[_excluded[i]]);
598         }
599         if (tSupply == 0 || rSupply < _reflectedSupply.div(_totalSupply)) return (_reflectedSupply, _totalSupply);
600         return (rSupply, tSupply);
601     }
602     
603     
604     /**
605      * @dev Redistributes the specified amount among the current holders via the reflect.finance
606      * algorithm, i.e. by updating the _reflectedSupply (_rSupply) which ultimately adjusts the
607      * current rate used by `tokenFromReflection` and, in turn, the value returns from `balanceOf`. 
608      * 
609      */
610     function _redistribute(uint256 amount, uint256 currentRate, uint256 fee) private {
611         uint256 tFee = amount.mul(fee).div(FEES_DIVISOR);
612         uint256 rFee = tFee.mul(currentRate);
613 
614         _reflectedSupply = _reflectedSupply.sub(rFee);
615         
616         collectedFeeTotal = collectedFeeTotal.add(tFee);
617     }
618     
619     function _burn(uint256 amount, uint256 currentRate, uint256 fee) private {
620         uint256 tBurn = amount.mul(fee).div(FEES_DIVISOR);
621         uint256 rBurn = tBurn.mul(currentRate);
622 
623         _burnTokens(address(this), tBurn, rBurn);
624         
625         collectedFeeTotal = collectedFeeTotal.add(tBurn);
626     }
627     
628      function isExcludedFromReward(address account) external view returns (bool) {
629         return _isExcludedFromRewards[account];
630     }
631     
632     function isExcludedFromFee(address account) public view returns(bool) { 
633         return _isExcludedFromFee[account]; 
634     }
635     
636 
637     function blacklistAddress(address account, bool value) external onlyOwner{
638         _isBlacklisted[account] = value;
639     }
640 
641     function setSwapEnabled(bool _enabled) external onlyOwner {
642         swapEnabled  = _enabled;
643     }
644     
645     function updateSwapTokensAt(uint256 _swaptokens) external onlyOwner {
646         swapTokensAtAmount = _swaptokens * (10**18);
647     }
648     
649     function updateWalletMax(uint256 _walletMax) external onlyOwner {
650         maxWalletBalance = _walletMax * (10**18);
651     }
652     
653     function updateTransactionMax(uint256 _txMax) external onlyOwner {
654         maxTxAmount = _txMax * (10**18);
655     }
656 
657     function updateFees( uint256 _marketing, uint256 _endowment, uint256 _lp) external onlyOwner {
658        totalFee = _marketing.add(_endowment).add(_lp); 
659        require(totalFee <= 100, "Total Fees cannot be greater than 10% (100)");
660 
661        marketingFee = _marketing;
662        endowmentFee = _endowment;
663        lpFee = _lp;
664     }
665 
666    
667     function updateMarketingWallet(address newWallet) external onlyOwner zeroAddressCheck(newWallet) {
668         require(newWallet != marketingWallet, "The Marketing wallet is already this address");
669         emit MarketingWalletUpdated(newWallet, marketingWallet);
670         
671         marketingWallet = newWallet;
672     }
673     
674     function updateEndowmentWallet(address newWallet) external onlyOwner zeroAddressCheck(newWallet) {
675         require(newWallet != endowmentWallet, "The Endowment wallet is already this address");
676         emit EndowmentWalletUpdated(newWallet, endowmentWallet);
677         
678         endowmentWallet = newWallet;
679     }
680 
681     
682     function updatePortionsOfSwap(uint256 marketingPortion, uint256  endowmentPortion, uint256 lpPortion) 
683     external onlyOwner {
684         
685         uint256 totalPortion = marketingPortion.add(endowmentPortion).add(lpPortion);
686         require(totalPortion == 1000, "Total must be equal to 1000 (100%)");
687         
688         marketingPortionOfSwap = marketingPortion;
689         endowmentPortionOfSwap = endowmentPortion;
690         lpPortionOfSwap = lpPortion;
691     }
692     
693     function updateTradingIsEnabled(bool tradingStatus) external onlyOwner() {
694         tradingIsEnabled = tradingStatus;
695     }
696     
697     function updateRouterAddress(address newAddress) external onlyOwner {
698         require(newAddress != address(router), "The router already has that address");
699         emit UpdatePancakeswapRouter(newAddress, address(router));
700         
701         router = IPancakeV2Router(newAddress);   
702     }
703 
704     function toggleAntiBot(bool toggleStatus) external onlyOwner() {
705         antiBotEnabled = toggleStatus;
706         if(antiBotEnabled){
707             _startTimeForSwap = block.timestamp + 5;    
708         }    
709     }
710     
711     function _takeFee(uint256 amount, uint256 currentRate, uint256 fee, address recipient) private {
712         uint256 tAmount = amount.mul(fee).div(FEES_DIVISOR);
713         uint256 rAmount = tAmount.mul(currentRate);
714 
715         _reflectedBalances[recipient] = _reflectedBalances[recipient].add(rAmount);
716         if(_isExcludedFromRewards[recipient])
717             _balances[recipient] = _balances[recipient].add(tAmount);
718     }
719     
720     function _transferTokens(address sender, address recipient, uint256 amount, bool takeFee) private {
721         
722         uint256 sumOfFees = totalFee;
723 
724         // antibot enabled
725         sumOfFees = antiBotEnabled && block.timestamp <= _startTimeForSwap ? antiBotFee : sumOfFees;
726 
727         // transfer between wallets
728         if(sender != pair && recipient != pair) {
729             sumOfFees = 0;
730         }
731         
732         if ( !takeFee ){ sumOfFees = 0; }
733         
734         processReflectedBal(sender, recipient, amount, sumOfFees);
735        
736     }
737     
738     function processReflectedBal (address sender, address recipient, uint256 amount, uint256 sumOfFees) private {
739         
740         (uint256 rAmount, uint256 rTransferAmount, uint256 tAmount, 
741         uint256 tTransferAmount, uint256 currentRate ) = _getValues(amount, sumOfFees);
742          
743         theReflection(sender, recipient, rAmount, rTransferAmount, tAmount, tTransferAmount); 
744         
745         _takeFees(amount, currentRate, sumOfFees);
746         
747         emit Transfer(sender, recipient, tTransferAmount);    
748     }
749     
750     function theReflection(address sender, address recipient, uint256 rAmount, uint256 rTransferAmount, uint256 tAmount, 
751         uint256 tTransferAmount) private {
752             
753         _reflectedBalances[sender] = _reflectedBalances[sender].sub(rAmount);
754         _reflectedBalances[recipient] = _reflectedBalances[recipient].add(rTransferAmount);
755         
756         /**
757          * Update the true/nominal balances for excluded accounts
758          */        
759         if (_isExcludedFromRewards[sender]) { _balances[sender] = _balances[sender].sub(tAmount); }
760         if (_isExcludedFromRewards[recipient] ) { _balances[recipient] = _balances[recipient].add(tTransferAmount); }
761     }
762     
763     
764     function _takeFees(uint256 amount, uint256 currentRate, uint256 sumOfFees) private {
765         if ( sumOfFees > 0 && !isInPresale ){
766             _takeFee( amount, currentRate, sumOfFees, address(this));
767         }
768     }
769     
770     function _transfer(address sender, address recipient, uint256 amount) private {
771         require(sender != address(0), "Token: transfer from the zero address");
772         require(recipient != address(0), "Token: transfer to the zero address");
773         require(sender != address(deadAddress), "Token: transfer from the burn address");
774         require(amount > 0, "Transfer amount must be greater than zero");
775         
776         require(tradingIsEnabled, "This account cannot send tokens until trading is enabled");
777 
778         require(!_isBlacklisted[sender] && !_isBlacklisted[recipient], "Blacklisted address");
779         
780         if (
781             sender != address(router) && //router -> pair is removing liquidity which shouldn't have max
782             !_isExcludedFromFee[recipient] && //no max for those excluded from fees
783             !_isExcludedFromFee[sender] 
784         ) {
785             require(amount <= maxTxAmount, "Transfer amount exceeds the Max Transaction Amount.");
786             
787         }
788         
789         if ( maxWalletBalance > 0 && !_isExcludedFromFee[recipient] && !_isExcludedFromFee[sender] && recipient != address(pair) ) {
790                 uint256 recipientBalance = balanceOf(recipient);
791                 require(recipientBalance + amount <= maxWalletBalance, "New balance would exceed the maxWalletBalance");
792             }
793             
794          // indicates whether or not fee should be deducted from the transfer
795         bool _isTakeFee = takeFeeEnabled;
796         if ( isInPresale ){ _isTakeFee = false; }
797         
798          // if any account belongs to _isExcludedFromFee account then remove the fee
799         if(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]) { 
800             _isTakeFee = false; 
801         }
802         
803         _beforeTokenTransfer(recipient);
804         _transferTokens(sender, recipient, amount, _isTakeFee);
805         
806     }
807     
808     function _beforeTokenTransfer(address recipient) private {
809             
810         if ( !isInPresale ){
811             uint256 contractTokenBalance = balanceOf(address(this));
812             // swap
813             bool canSwap = contractTokenBalance >= swapTokensAtAmount;
814             
815             if (!swapping && canSwap && swapEnabled && recipient == pair) {
816                 swapping = true;
817                 
818                 swapBack();
819                 
820                 swapping = false;
821             }
822             
823         }
824     }
825     
826     function swapBack() private nonReentrant {
827         uint256 splitLiquidityPortion = lpPortionOfSwap.div(2);
828         uint256 amountToLiquify = balanceOf(address(this)).mul(splitLiquidityPortion).div(FEES_DIVISOR);
829         uint256 amountToSwap = balanceOf(address(this)).sub(amountToLiquify);
830 
831         uint256 balanceBefore = address(this).balance;
832         
833         swapTokensForETH(amountToSwap);
834 
835         uint256 amountBNB = address(this).balance.sub(balanceBefore);
836         
837         uint256 amountBNBMarketing = amountBNB.mul(marketingPortionOfSwap).div(FEES_DIVISOR);
838         uint256 amountBNBEndowment = amountBNB.mul(endowmentPortionOfSwap).div(FEES_DIVISOR);
839         uint256 amountBNBLiquidity = amountBNB.mul(splitLiquidityPortion).div(FEES_DIVISOR);
840         
841           //Send to addresses
842         transferToAddress(payable(marketingWallet), amountBNBMarketing);
843         transferToAddress(payable(endowmentWallet), amountBNBEndowment);
844         
845         // add liquidity
846         _addLiquidity(amountToLiquify, amountBNBLiquidity);
847     }
848     
849     function _addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
850         // approve token transfer to cover all possible scenarios
851         _approve(address(this), address(router), tokenAmount);
852 
853         // add the liquidity
854         (uint256 tokenAmountSent, uint256 ethAmountSent, uint256 liquidity) = router.addLiquidityETH{value: ethAmount}(
855             address(this),
856             tokenAmount,
857             0,
858             0,
859             owner(),
860             block.timestamp
861         );
862 
863         emit LiquidityAdded(tokenAmountSent, ethAmountSent, liquidity);
864     }
865     
866     function swapTokensForETH(uint256 tokenAmount) private {
867         // generate the uniswap pair path of token -> weth
868         address[] memory path = new address[](2);
869         path[0] = address(this);
870         path[1] = router.WETH();
871 
872         _approve(address(this), address(router), tokenAmount);
873 
874         // make the swap
875         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
876             tokenAmount,
877             0, // accept any amount of ETH
878             path,
879             address(this),
880             block.timestamp
881         );
882         
883         emit SwapTokensForETH(tokenAmount, path);
884     }
885     
886     function transferToAddress(address payable recipient, uint256 amount) private {
887         require(recipient != address(0), "Cannot transfer the ETH to a zero address");
888         recipient.transfer(amount);
889     }
890     
891     function TransferETH(address payable recipient, uint256 amount) external onlyOwner {
892         require(recipient != address(0), "Cannot withdraw the ETH balance to a zero address");
893         recipient.transfer(amount);
894     }
895     
896 }