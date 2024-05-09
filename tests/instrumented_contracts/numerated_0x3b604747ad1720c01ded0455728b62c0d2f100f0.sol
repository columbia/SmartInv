1 /**
2  * SPDX-License-Identifier: MIT
3  */ 
4  
5 // WAGMI GAMES - WE ARE ALL GOING TO MAKE IT - https://www.wagmigame.io/
6 
7 pragma solidity ^0.8.6;
8 
9 abstract contract ReentrancyGuard {
10     // Booleans are more expensive than uint256 or any type that takes up a full
11     // word because each write operation emits an extra SLOAD to first read the
12     // slot's contents, replace the bits taken up by the boolean, and then write
13     // back. This is the compiler's defense against contract upgrades and
14     // pointer aliasing, and it cannot be disabled.
15 
16     // The values being non-zero value makes deployment a bit more expensive,
17     // but in exchange the refund on every call to nonReentrant will be lower in
18     // amount. Since refunds are capped to a percentage of the total
19     // transaction's gas, it is best to keep them low in cases like this one, to
20     // increase the likelihood of the full refund coming into effect.
21     uint256 private constant _NOT_ENTERED = 1;
22     uint256 private constant _ENTERED = 2;
23 
24     uint256 private _status;
25 
26     constructor() {
27         _status = _NOT_ENTERED;
28     }
29 
30     /**
31      * @dev Prevents a contract from calling itself, directly or indirectly.
32      * Calling a `nonReentrant` function from another `nonReentrant`
33      * function is not supported. It is possible to prevent this from happening
34      * by making the `nonReentrant` function external, and making it call a
35      * `private` function that does the actual work.
36      */
37     modifier nonReentrant() {
38         // On the first call to nonReentrant, _notEntered will be true
39         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
40 
41         // Any calls to nonReentrant after this point will fail
42         _status = _ENTERED;
43 
44         _;
45 
46         // By storing the original value once again, a refund is triggered (see
47         // https://eips.ethereum.org/EIPS/eip-2200)
48         _status = _NOT_ENTERED;
49     }
50 }
51 
52 library SafeMath {
53 
54     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
55         uint256 c = a + b;
56         if (c < a) return (false, 0);
57         return (true, c);
58     }
59 
60     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
61         if (b > a) return (false, 0);
62         return (true, a - b);
63     }
64 
65     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
66         if (a == 0) return (true, 0);
67         uint256 c = a * b;
68         if (c / a != b) return (false, 0);
69         return (true, c);
70     }
71 
72 
73     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
74         if (b == 0) return (false, 0);
75         return (true, a / b);
76     }
77 
78     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
79         if (b == 0) return (false, 0);
80         return (true, a % b);
81     }
82 
83     function add(uint256 a, uint256 b) internal pure returns (uint256) {
84         uint256 c = a + b;
85         require(c >= a, "SafeMath: addition overflow");
86         return c;
87     }
88 
89     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
90         require(b <= a, "SafeMath: subtraction overflow");
91         return a - b;
92     }
93 
94 
95     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
96         if (a == 0) return 0;
97         uint256 c = a * b;
98         require(c / a == b, "SafeMath: multiplication overflow");
99         return c;
100     }
101 
102     function div(uint256 a, uint256 b) internal pure returns (uint256) {
103         require(b > 0, "SafeMath: division by zero");
104         return a / b;
105     }
106 
107     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
108         require(b > 0, "SafeMath: modulo by zero");
109         return a % b;
110     }
111 
112 
113     function sub(
114         uint256 a,
115         uint256 b,
116         string memory errorMessage
117     ) internal pure returns (uint256) {
118         require(b <= a, errorMessage);
119         return a - b;
120     }
121 
122  
123     function div(
124         uint256 a,
125         uint256 b,
126         string memory errorMessage
127     ) internal pure returns (uint256) {
128         require(b > 0, errorMessage);
129         return a / b;
130     }
131 
132     function mod(
133         uint256 a,
134         uint256 b,
135         string memory errorMessage
136     ) internal pure returns (uint256) {
137         require(b > 0, errorMessage);
138         return a % b;
139     }
140 }
141 
142 interface IERC20 {
143     function totalSupply() external view returns (uint256);
144     function balanceOf(address account) external view returns (uint256);
145     function transfer(address recipient, uint256 amount) external returns (bool);
146     function allowance(address owner, address spender) external view returns (uint256);
147     function approve(address spender, uint256 amount) external returns (bool);
148     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
149     event Transfer(address indexed from, address indexed to, uint256 value);
150     event Approval(address indexed owner, address indexed spender, uint256 value);
151 }
152 
153 interface IERC20Metadata is IERC20 {
154     function name() external view returns (string memory);
155     function symbol() external view returns (string memory);
156     function decimals() external view returns (uint8);
157 }
158 
159 abstract contract Context {
160     function _msgSender() internal view virtual returns (address) {return msg.sender;}
161     function _msgData() internal view virtual returns (bytes calldata) {this; return msg.data;}
162 }
163 
164 library Address {
165     function isContract(address account) internal view returns (bool) { 
166         uint256 size; assembly { size := extcodesize(account) } return size > 0;
167     }
168     function sendValue(address payable recipient, uint256 amount) internal {
169         require(address(this).balance >= amount, "Address: insufficient balance");(bool success, ) = recipient.call{ value: amount }("");
170         require(success, "Address: unable to send value, recipient may have reverted");
171     }
172     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
173         return functionCall(target, data, "Address: low-level call failed");
174         
175     }
176     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
177         return functionCallWithValue(target, data, 0, errorMessage);
178         
179     }
180     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
181         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
182         
183     }
184     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
185         require(address(this).balance >= value, "Address: insufficient balance for call");
186         require(isContract(target), "Address: call to non-contract");
187         (bool success, bytes memory returndata) = target.call{ value: value }(data);
188         return _verifyCallResult(success, returndata, errorMessage);
189     }
190     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
191         return functionStaticCall(target, data, "Address: low-level static call failed");
192     }
193     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
194         require(isContract(target), "Address: static call to non-contract");
195         (bool success, bytes memory returndata) = target.staticcall(data);
196         return _verifyCallResult(success, returndata, errorMessage);
197     }
198     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
199         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
200     }
201     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
202         require(isContract(target), "Address: delegate call to non-contract");
203         (bool success, bytes memory returndata) = target.delegatecall(data);
204         return _verifyCallResult(success, returndata, errorMessage);
205     }
206     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
207         if (success) { return returndata; } else {
208             if (returndata.length > 0) {
209                 assembly {
210                     let returndata_size := mload(returndata)
211                     revert(add(32, returndata), returndata_size)
212                 }
213             } else {revert(errorMessage);}
214         }
215     }
216 }
217 
218 abstract contract Ownable is Context {
219     address private _owner;
220 
221     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
222 
223     constructor () {
224         address msgSender = _msgSender();
225         _owner = msgSender;
226         emit OwnershipTransferred(address(0), msgSender);
227     }
228 
229     function owner() public view returns (address) {
230         return _owner;
231     }   
232     
233     modifier onlyOwner() {
234         require(_owner == _msgSender(), "Ownable: caller is not the owner");
235         _;
236     }
237     
238     function renounceOwnership() public virtual onlyOwner {
239         emit OwnershipTransferred(_owner, address(0));
240         _owner = address(0);
241     }
242 
243     function transferOwnership(address newOwner) public virtual onlyOwner {
244         require(newOwner != address(0), "Ownable: new owner is the zero address");
245         emit OwnershipTransferred(_owner, newOwner);
246         _owner = newOwner;
247     }
248 }
249 
250 interface IPancakeV2Factory {
251     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
252     function createPair(address tokenA, address tokenB) external returns (address pair);
253 }
254 
255 interface IPancakeV2Router {
256     function factory() external pure returns (address);
257     function WETH() external pure returns (address);
258     
259     function addLiquidity(
260         address tokenA,
261         address tokenB,
262         uint amountADesired,
263         uint amountBDesired,
264         uint amountAMin,
265         uint amountBMin,
266         address to,
267         uint deadline
268     ) external returns (uint amountA, uint amountB, uint liquidity);
269 
270     function addLiquidityETH(
271         address token,
272         uint amountTokenDesired,
273         uint amountTokenMin,
274         uint amountETHMin,
275         address to,
276         uint deadline
277     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
278 
279     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
280         uint amountIn,
281         uint amountOutMin,
282         address[] calldata path,
283         address to,
284         uint deadline
285     ) external;
286 
287     function swapExactETHForTokensSupportingFeeOnTransferTokens(
288         uint amountOutMin,
289         address[] calldata path,
290         address to,
291         uint deadline
292     ) external payable;
293 
294     function swapExactTokensForETHSupportingFeeOnTransferTokens(
295         uint amountIn,
296         uint amountOutMin,
297         address[] calldata path,
298         address to,
299         uint deadline
300     ) external;
301 }
302 
303 contract WAGMI is IERC20Metadata, Ownable, ReentrancyGuard {
304     using SafeMath for uint256;
305     using Address for address;
306     
307     address internal deadAddress = 0x000000000000000000000000000000000000dEaD;
308     
309     address public marketingWallet = 0x10b33D3CbcB6f674fc626bfd83a701D2422352E2;
310     address public devWallet = 0x8Da67EF3CA0D9a2e28EB32DDd323295A64d20AD3;
311     address public teamWallet = 0xf96cb8E903AE8AABf92c5668871e5ACE37316c64;
312     
313     string constant _name = "WAGMI GAMES";
314     string constant _symbol = "WAGMIGAMES";
315     uint8 constant _decimals = 18;
316     
317     uint256 private constant MAX = ~uint256(0);
318     uint256 internal constant _totalSupply = 2_200_000_000_000 * (10**18);
319     uint256 internal _reflectedSupply = (MAX - (MAX % _totalSupply));
320     
321     uint256 public collectedFeeTotal;
322   
323     uint256 public maxTxAmount = _totalSupply / 1000; // 0.1% of the total supply
324     uint256 public maxWalletBalance = _totalSupply / 50; // 2% of the total supply
325     
326     bool public takeFeeEnabled = true;
327     bool public tradingIsEnabled = true;
328     bool public isInPresale = false;
329     
330     bool private swapping;
331     bool public swapEnabled = true;
332     uint256 public swapTokensAtAmount = 100_000_000 * (10**18);
333 
334     bool public antiBotEnabled = false;
335     uint256 public antiBotFee = 990; // 99%
336     uint256 public _startTimeForSwap;
337     
338     uint256 private constant FEES_DIVISOR = 10**3;
339     
340     uint256 public rfiFee = 10; // 1%
341     uint256 public marketingFee = 30; // 3%
342     uint256 public devFee = 20; // 2%
343     uint256 public teamFee = 25; // 2.5%
344     uint256 public lpFee = 15; // 1.5%
345     uint256 private totalFee;
346     
347     // Total = 100% (1000)
348     uint256 public marketingPortionOfSwap = 500; // 50%
349     uint256 public devPortionOfSwap = 200; // 20%
350     uint256 public teamPortionOfSwap = 150; // 15%
351     uint256 public lpPortionOfSwap = 150; // 15%
352     
353     IPancakeV2Router public router;
354     address public pair;
355     
356     
357     mapping (address => uint256) internal _reflectedBalances;
358     mapping (address => uint256) internal _balances;
359     mapping (address => mapping (address => uint256)) internal _allowances;
360 
361     mapping(address => bool) public _isBlacklisted;
362     
363     mapping (address => bool) internal _isExcludedFromFee;
364     mapping (address => bool) internal _isExcludedFromRewards;
365     address[] private _excluded;
366     
367     event UpdatePancakeswapRouter(address indexed newAddress, address indexed oldAddress);
368     event ExcludeFromFees(address indexed account, bool isExcluded);
369     event ExcludeMultipleAccountsFromFees(address[] accounts, bool isExcluded);
370     
371     event MarketingWalletUpdated(address indexed newMarketingWallet, address indexed oldMarketingWallet);
372     event DevWalletUpdated(address indexed newDevWallet, address indexed oldDevWallet);
373     event TeamWalletUpdated(address indexed newTeamWallet, address indexed oldTeamWallet);
374     
375     event LiquidityAdded(uint256 tokenAmountSent, uint256 ethAmountSent, uint256 liquidity);
376     
377     event SwapTokensForETH(uint256 amountIn, address[] path);
378 
379     modifier zeroAddressCheck(address _theAddress) {
380         require(_theAddress != address(0), "Address cannot be the zero address");
381         _;
382     }
383     
384     constructor () {
385         _reflectedBalances[owner()] = _reflectedSupply;
386         
387         IPancakeV2Router _newPancakeRouter = IPancakeV2Router(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
388         pair = IPancakeV2Factory(_newPancakeRouter.factory()).createPair(address(this), _newPancakeRouter.WETH());
389         router = _newPancakeRouter;
390 
391         // set fees
392         totalFee = rfiFee.add(marketingFee).add(devFee).add(teamFee).add(lpFee);
393         
394         // exclude owner and this contract from fee
395         _isExcludedFromFee[owner()] = true;
396         _isExcludedFromFee[address(this)] = true;
397         
398         // exclude the owner and this contract from rewards
399         _exclude(owner());
400         _exclude(address(this));
401         
402         // exclude the pair address from rewards - we don't want to redistribute
403         _exclude(pair);
404         _exclude(deadAddress);
405         
406         _approve(owner(), address(router), ~uint256(0));
407         
408         emit Transfer(address(0), owner(), _totalSupply);
409     }
410     
411     receive() external payable { }
412     
413     function name() external pure override returns (string memory) {
414         return _name;
415     }
416 
417     function symbol() external pure override returns (string memory) {
418         return _symbol;
419     }
420 
421     function decimals() external pure override returns (uint8) {
422         return _decimals;
423     }
424 
425     function totalSupply() external pure override returns (uint256) {
426         return _totalSupply;
427     }
428     
429     function balanceOf(address account) public view override returns (uint256){
430         if (_isExcludedFromRewards[account]) return _balances[account];
431         return tokenFromReflection(_reflectedBalances[account]);
432         }
433         
434     function transfer(address recipient, uint256 amount) external override returns (bool){
435         _transfer(_msgSender(), recipient, amount);
436         return true;
437         }
438         
439     function allowance(address owner, address spender) external view override returns (uint256){
440         return _allowances[owner][spender];
441         }
442     
443     function approve(address spender, uint256 amount) external override returns (bool) {
444         _approve(_msgSender(), spender, amount);
445         return true;
446         }
447         
448     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool){
449         _transfer(sender, recipient, amount);
450         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
451         return true;
452         }
453         
454     function burn(uint256 amount) external nonReentrant {
455 
456         address sender = _msgSender();
457         require(sender != address(0), "ERC20: burn from the zero address");
458         require(sender != address(deadAddress), "ERC20: burn from the burn address");
459 
460         uint256 balance = balanceOf(sender);
461         require(balance >= amount, "ERC20: burn amount exceeds balance");
462 
463         uint256 reflectedAmount = amount.mul(_getCurrentRate());
464 
465         // remove the amount from the sender's balance first
466         _reflectedBalances[sender] = _reflectedBalances[sender].sub(reflectedAmount);
467         if (_isExcludedFromRewards[sender])
468             _balances[sender] = _balances[sender].sub(amount);
469 
470         _burnTokens( sender, amount, reflectedAmount );
471     }
472     
473     /**
474      * @dev "Soft" burns the specified amount of tokens by sending them 
475      * to the burn address
476      */
477     function _burnTokens(address sender, uint256 tBurn, uint256 rBurn) internal {
478 
479         /**
480          * @dev Do not reduce _totalSupply and/or _reflectedSupply. (soft) burning by sending
481          * tokens to the burn address (which should be excluded from rewards) is sufficient
482          * in RFI
483          */ 
484         _reflectedBalances[deadAddress] = _reflectedBalances[deadAddress].add(rBurn);
485         if (_isExcludedFromRewards[deadAddress])
486             _balances[deadAddress] = _balances[deadAddress].add(tBurn);
487 
488         /**
489          * @dev Emit the event so that the burn address balance is updated (on bscscan)
490          */
491         emit Transfer(sender, deadAddress, tBurn);
492     }
493     
494     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
495         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
496         return true;
497     }
498     
499     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
500         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
501         return true;
502     }
503     
504     function _approve(address owner, address spender, uint256 amount) internal {
505         require(owner != address(0), "BaseRfiToken: approve from the zero address");
506         require(spender != address(0), "BaseRfiToken: approve to the zero address");
507 
508         _allowances[owner][spender] = amount;
509         emit Approval(owner, spender, amount);
510     }
511     
512     
513      /**
514      * @dev Calculates and returns the reflected amount for the given amount with or without 
515      * the transfer fees (deductTransferFee true/false)
516      */
517     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) external view returns(uint256) {
518         require(tAmount <= _totalSupply, "Amount must be less than supply");
519         uint256 feesSum;
520         if (!deductTransferFee) {
521             (uint256 rAmount,,,,) = _getValues(tAmount,0);
522             return rAmount;
523         } else {
524             feesSum = totalFee;
525             (,uint256 rTransferAmount,,,) = _getValues(tAmount, feesSum);
526             return rTransferAmount;
527         }
528     }
529 
530     /**
531      * @dev Calculates and returns the amount of tokens corresponding to the given reflected amount.
532      */
533     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
534         require(rAmount <= _reflectedSupply, "Amount must be less than total reflections");
535         uint256 currentRate = _getCurrentRate();
536         return rAmount.div(currentRate);
537     }
538     
539     function excludeFromReward(address account) external onlyOwner() {
540         require(!_isExcludedFromRewards[account], "Account is not included");
541         _exclude(account);
542     }
543     
544     function _exclude(address account) private {
545         if(_reflectedBalances[account] > 0) {
546             _balances[account] = tokenFromReflection(_reflectedBalances[account]);
547         }
548         _isExcludedFromRewards[account] = true;
549         _excluded.push(account);
550     }
551 
552     function includeInReward(address account) external onlyOwner() {
553         require(_isExcludedFromRewards[account], "Account is not excluded");
554         for (uint256 i = 0; i < _excluded.length; i++) {
555             if (_excluded[i] == account) {
556                 _excluded[i] = _excluded[_excluded.length - 1];
557                 _balances[account] = 0;
558                 _isExcludedFromRewards[account] = false;
559                 _excluded.pop();
560                 break;
561             }
562         }
563     }
564     
565     function setExcludedFromFee(address account, bool value) external onlyOwner { 
566         _isExcludedFromFee[account] = value; 
567     }
568 
569     function _getValues(uint256 tAmount, uint256 feesSum) internal view returns (uint256, uint256, uint256, uint256, uint256) {
570         
571         uint256 tTotalFees = tAmount.mul(feesSum).div(FEES_DIVISOR);
572         uint256 tTransferAmount = tAmount.sub(tTotalFees);
573         uint256 currentRate = _getCurrentRate();
574         uint256 rAmount = tAmount.mul(currentRate);
575         uint256 rTotalFees = tTotalFees.mul(currentRate);
576         uint256 rTransferAmount = rAmount.sub(rTotalFees);
577         
578         return (rAmount, rTransferAmount, tAmount, tTransferAmount, currentRate);
579     }
580     
581     function _getCurrentRate() internal view returns(uint256) {
582         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
583         return rSupply.div(tSupply);
584     }
585     
586     function _getCurrentSupply() internal view returns(uint256, uint256) {
587         uint256 rSupply = _reflectedSupply;
588         uint256 tSupply = _totalSupply;
589 
590         /**
591          * The code below removes balances of addresses excluded from rewards from
592          * rSupply and tSupply, which effectively increases the % of transaction fees
593          * delivered to non-excluded holders
594          */    
595         for (uint256 i = 0; i < _excluded.length; i++) {
596             if (_reflectedBalances[_excluded[i]] > rSupply || _balances[_excluded[i]] > tSupply)
597             return (_reflectedSupply, _totalSupply);
598             rSupply = rSupply.sub(_reflectedBalances[_excluded[i]]);
599             tSupply = tSupply.sub(_balances[_excluded[i]]);
600         }
601         if (tSupply == 0 || rSupply < _reflectedSupply.div(_totalSupply)) return (_reflectedSupply, _totalSupply);
602         return (rSupply, tSupply);
603     }
604     
605     
606     /**
607      * @dev Redistributes the specified amount among the current holders via the reflect.finance
608      * algorithm, i.e. by updating the _reflectedSupply (_rSupply) which ultimately adjusts the
609      * current rate used by `tokenFromReflection` and, in turn, the value returns from `balanceOf`. 
610      * 
611      */
612     function _redistribute(uint256 amount, uint256 currentRate, uint256 fee) private {
613         uint256 tFee = amount.mul(fee).div(FEES_DIVISOR);
614         uint256 rFee = tFee.mul(currentRate);
615 
616         _reflectedSupply = _reflectedSupply.sub(rFee);
617         
618         collectedFeeTotal = collectedFeeTotal.add(tFee);
619     }
620     
621     function _burn(uint256 amount, uint256 currentRate, uint256 fee) private {
622         uint256 tBurn = amount.mul(fee).div(FEES_DIVISOR);
623         uint256 rBurn = tBurn.mul(currentRate);
624 
625         _burnTokens(address(this), tBurn, rBurn);
626         
627         collectedFeeTotal = collectedFeeTotal.add(tBurn);
628     }
629     
630      function isExcludedFromReward(address account) external view returns (bool) {
631         return _isExcludedFromRewards[account];
632     }
633     
634     function isExcludedFromFee(address account) public view returns(bool) { 
635         return _isExcludedFromFee[account]; 
636     }
637     
638 
639     function blacklistAddress(address account, bool value) external onlyOwner{
640         _isBlacklisted[account] = value;
641     }
642 
643     function setSwapEnabled(bool _enabled) external onlyOwner {
644         swapEnabled  = _enabled;
645     }
646     
647     function updateSwapTokensAt(uint256 _swaptokens) external onlyOwner {
648         swapTokensAtAmount = _swaptokens * (10**18);
649     }
650     
651     function updateWalletMax(uint256 _walletMax) external onlyOwner {
652         maxWalletBalance = _walletMax * (10**18);
653     }
654     
655     function updateTransactionMax(uint256 _txMax) external onlyOwner {
656         maxTxAmount = _txMax * (10**18);
657     }
658 
659     function updateFees(uint256 _rfi, uint256 _marketing, uint256 _dev, uint256 _team, uint256 _lp) external onlyOwner {
660        totalFee = _rfi.add(_marketing).add(_dev).add(_team).add(_lp); 
661        require(totalFee <= 100, "Total Fees cannot be greater than 10% (100)");
662 
663        rfiFee = _rfi;
664        marketingFee = _marketing;
665        devFee = _dev;
666        teamFee = _team;
667        lpFee = _lp;
668     }
669 
670    
671     function updateMarketingWallet(address newWallet) external onlyOwner zeroAddressCheck(newWallet) {
672         require(newWallet != marketingWallet, "The Marketing wallet is already this address");
673         emit MarketingWalletUpdated(newWallet, marketingWallet);
674         
675         marketingWallet = newWallet;
676     }
677     
678     function updateDevWallet(address newWallet) external onlyOwner zeroAddressCheck(newWallet) {
679         require(newWallet != devWallet, "The Dev wallet is already this address");
680         emit DevWalletUpdated(newWallet, devWallet);
681         
682         devWallet = newWallet;
683     }
684     
685     function updateTeamWallet(address newWallet) external onlyOwner zeroAddressCheck(newWallet) {
686         require(newWallet != teamWallet, "The Team wallet is already this address");
687         emit TeamWalletUpdated(newWallet, teamWallet);
688         
689         teamWallet = newWallet;
690     }
691     
692     function updatePortionsOfSwap(uint256 marketingPortion, uint256  devPortion, uint256 lpPortion, uint256 teamPortion) 
693     external onlyOwner {
694         
695         uint256 totalPortion = marketingPortion.add(devPortion).add(lpPortion).add(teamPortion);
696         require(totalPortion == 1000, "Total must be equal to 1000 (100%)");
697         
698         marketingPortionOfSwap = marketingPortion;
699         devPortionOfSwap = devPortion;
700         lpPortionOfSwap = lpPortion;
701         teamPortionOfSwap = teamPortion;
702     }
703     
704     function updateTradingIsEnabled(bool tradingStatus) external onlyOwner() {
705         tradingIsEnabled = tradingStatus;
706     }
707     
708     function updateRouterAddress(address newAddress) external onlyOwner {
709         require(newAddress != address(router), "The router already has that address");
710         emit UpdatePancakeswapRouter(newAddress, address(router));
711         
712         router = IPancakeV2Router(newAddress);   
713     }
714 
715     function toggleAntiBot(bool toggleStatus) external onlyOwner() {
716         antiBotEnabled = toggleStatus;
717         if(antiBotEnabled){
718             _startTimeForSwap = block.timestamp + 60;    
719         }    
720     }
721     
722     function _takeFee(uint256 amount, uint256 currentRate, uint256 fee, address recipient) private {
723         uint256 tAmount = amount.mul(fee).div(FEES_DIVISOR);
724         uint256 rAmount = tAmount.mul(currentRate);
725 
726         _reflectedBalances[recipient] = _reflectedBalances[recipient].add(rAmount);
727         if(_isExcludedFromRewards[recipient])
728             _balances[recipient] = _balances[recipient].add(tAmount);
729 
730         collectedFeeTotal = collectedFeeTotal.add(tAmount);
731     }
732     
733     function _transferTokens(address sender, address recipient, uint256 amount, bool takeFee) private {
734         
735         uint256 sumOfFees = totalFee;
736 
737         // antibot enabled
738         sumOfFees = antiBotEnabled && block.timestamp <= _startTimeForSwap ? antiBotFee : sumOfFees;
739 
740         // transfer between wallets
741         if(sender != pair && recipient != pair) {
742             sumOfFees = 0;
743         }
744         
745         if ( !takeFee ){ sumOfFees = 0; }
746         
747         processReflectedBal(sender, recipient, amount, sumOfFees);
748        
749     }
750     
751     function processReflectedBal (address sender, address recipient, uint256 amount, uint256 sumOfFees) private {
752         
753         (uint256 rAmount, uint256 rTransferAmount, uint256 tAmount, 
754         uint256 tTransferAmount, uint256 currentRate ) = _getValues(amount, sumOfFees);
755          
756         theReflection(sender, recipient, rAmount, rTransferAmount, tAmount, tTransferAmount); 
757         
758         _takeFees(amount, currentRate, sumOfFees);
759         
760         emit Transfer(sender, recipient, tTransferAmount);    
761     }
762     
763     function theReflection(address sender, address recipient, uint256 rAmount, uint256 rTransferAmount, uint256 tAmount, 
764         uint256 tTransferAmount) private {
765             
766         _reflectedBalances[sender] = _reflectedBalances[sender].sub(rAmount);
767         _reflectedBalances[recipient] = _reflectedBalances[recipient].add(rTransferAmount);
768         
769         /**
770          * Update the true/nominal balances for excluded accounts
771          */        
772         if (_isExcludedFromRewards[sender]) { _balances[sender] = _balances[sender].sub(tAmount); }
773         if (_isExcludedFromRewards[recipient] ) { _balances[recipient] = _balances[recipient].add(tTransferAmount); }
774     }
775     
776     
777     function _takeFees(uint256 amount, uint256 currentRate, uint256 sumOfFees) private {
778         if ( sumOfFees > 0 && !isInPresale ){
779             _redistribute( amount, currentRate, rfiFee );  // redistribute to holders
780             
781             uint256 otherFees = sumOfFees.sub(rfiFee);
782             _takeFee( amount, currentRate, otherFees, address(this));
783 
784         }
785     }
786     
787     function _transfer(address sender, address recipient, uint256 amount) private {
788         require(sender != address(0), "Token: transfer from the zero address");
789         require(recipient != address(0), "Token: transfer to the zero address");
790         require(sender != address(deadAddress), "Token: transfer from the burn address");
791         require(amount > 0, "Transfer amount must be greater than zero");
792         
793         require(tradingIsEnabled, "This account cannot send tokens until trading is enabled");
794 
795         require(!_isBlacklisted[sender] && !_isBlacklisted[recipient], "Blacklisted address");
796         
797         if (
798             sender != address(router) && //router -> pair is removing liquidity which shouldn't have max
799             !_isExcludedFromFee[recipient] && //no max for those excluded from fees
800             !_isExcludedFromFee[sender] 
801         ) {
802             require(amount <= maxTxAmount, "Transfer amount exceeds the Max Transaction Amount.");
803             
804         }
805         
806         if ( maxWalletBalance > 0 && !_isExcludedFromFee[recipient] && !_isExcludedFromFee[sender] && recipient != address(pair) ) {
807                 uint256 recipientBalance = balanceOf(recipient);
808                 require(recipientBalance + amount <= maxWalletBalance, "New balance would exceed the maxWalletBalance");
809             }
810             
811          // indicates whether or not fee should be deducted from the transfer
812         bool _isTakeFee = takeFeeEnabled;
813         if ( isInPresale ){ _isTakeFee = false; }
814         
815          // if any account belongs to _isExcludedFromFee account then remove the fee
816         if(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]) { 
817             _isTakeFee = false; 
818         }
819         
820         _beforeTokenTransfer(recipient);
821         _transferTokens(sender, recipient, amount, _isTakeFee);
822         
823     }
824     
825     function _beforeTokenTransfer(address recipient) private {
826             
827         if ( !isInPresale ){
828             uint256 contractTokenBalance = balanceOf(address(this));
829             // swap
830             bool canSwap = contractTokenBalance >= swapTokensAtAmount;
831             
832             if (!swapping && canSwap && swapEnabled && recipient == pair) {
833                 swapping = true;
834                 
835                 swapBack();
836                 
837                 swapping = false;
838             }
839             
840         }
841     }
842     
843     function swapBack() private nonReentrant {
844         uint256 splitLiquidityPortion = lpPortionOfSwap.div(2);
845         uint256 amountToLiquify = balanceOf(address(this)).mul(splitLiquidityPortion).div(FEES_DIVISOR);
846         uint256 amountToSwap = balanceOf(address(this)).sub(amountToLiquify);
847 
848         uint256 balanceBefore = address(this).balance;
849         
850         swapTokensForETH(amountToSwap);
851 
852         uint256 amountBNB = address(this).balance.sub(balanceBefore);
853         
854         uint256 amountBNBMarketing = amountBNB.mul(marketingPortionOfSwap).div(FEES_DIVISOR);
855         uint256 amountBNBDev = amountBNB.mul(devPortionOfSwap).div(FEES_DIVISOR);
856         uint256 amountBNBTeam = amountBNB.mul(teamPortionOfSwap).div(FEES_DIVISOR);
857         uint256 amountBNBLiquidity = amountBNB.mul(splitLiquidityPortion).div(FEES_DIVISOR);
858         
859           //Send to addresses
860         transferToAddress(payable(marketingWallet), amountBNBMarketing);
861         transferToAddress(payable(devWallet), amountBNBDev);
862         transferToAddress(payable(teamWallet), amountBNBTeam);
863         
864         // add liquidity
865         _addLiquidity(amountToLiquify, amountBNBLiquidity);
866     }
867     
868     function _addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
869         // approve token transfer to cover all possible scenarios
870         _approve(address(this), address(router), tokenAmount);
871 
872         // add the liquidity
873         (uint256 tokenAmountSent, uint256 ethAmountSent, uint256 liquidity) = router.addLiquidityETH{value: ethAmount}(
874             address(this),
875             tokenAmount,
876             0,
877             0,
878             owner(),
879             block.timestamp
880         );
881 
882         emit LiquidityAdded(tokenAmountSent, ethAmountSent, liquidity);
883     }
884     
885     function swapTokensForETH(uint256 tokenAmount) private {
886         // generate the uniswap pair path of token -> weth
887         address[] memory path = new address[](2);
888         path[0] = address(this);
889         path[1] = router.WETH();
890 
891         _approve(address(this), address(router), tokenAmount);
892 
893         // make the swap
894         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
895             tokenAmount,
896             0, // accept any amount of ETH
897             path,
898             address(this),
899             block.timestamp
900         );
901         
902         emit SwapTokensForETH(tokenAmount, path);
903     }
904     
905     function transferToAddress(address payable recipient, uint256 amount) private {
906         require(recipient != address(0), "Cannot transfer the ETH to a zero address");
907         recipient.transfer(amount);
908     }
909     
910     function TransferETH(address payable recipient, uint256 amount) external onlyOwner {
911         require(recipient != address(0), "Cannot withdraw the ETH balance to a zero address");
912         recipient.transfer(amount);
913     }
914     
915 }