1 /**
2 * Alpha Chad Protocol - $ACP
3 * LOCKED & RENOUNCED
4 * 0% BUY TAX
5 * THE TIMER STARTS AFTER THE LAUNCH
6 * 24 HOURS AFTER, THE SELL TAX GOES TO 0%
7 * USE OF TAXES - BUYBACKS
8 
9 * Alpha Chad Protocol - $ACP
10 * $ACP TAXES EXPLAINED (READ THIS CAREFULLY):
11 
12 There is a 0% buy tax. Therefore, you only pay taxes when you sell. 
13 An alpha chad doesn’t care to bother to sell fast anyway. 
14 ⬇️ 
15 * Sell within   1 hour  : 12% Sell Tax 
16 * Sell within   2 hours :  6% Sell Tax 
17 * Sell within   3 hours :  5% Sell Tax 
18 * Sell within   4 hours :  4% Sell Tax 
19 * Sell within   8 hours :  3% Sell Tax 
20 * Sell within  16 hours :  2% Sell Tax
21 * Sell within  24 hours :  1% Sell Tax
22 * Standard tax after 24 hours :  0% Sell Tax
23 
24 * Totalsupply     (100%):   21.000.000
25 * Max wallet        (2%):      420.000
26 * Max transaction   (2%):      420.000
27 Socials:
28 Website: https://alphachadprotocol.xyz/
29 Twitter: https://twitter.com/alphachadpro
30 TG: https://t.me/AlphaChadProtocol
31 Medium: https://alphachadpro.medium.com/bridge-swap-defi-yield-aggregator-41af3339190c
32 */
33 // SPDX-License-Identifier: MIT
34 pragma solidity ^0.8.7;
35 
36 interface IERC20 {
37     function totalSupply() external view returns (uint256);
38 
39     function balanceOf(address account) external view returns (uint256);
40 
41     function transfer(address recipient, uint256 amount) external returns (bool);
42 
43     function allowance(address owner, address spender) external view returns (uint256);
44 
45     function approve(address spender, uint256 amount) external returns (bool);
46 
47     function transferFrom(
48         address sender,
49         address recipient,
50         uint256 amount
51     ) external returns (bool);
52 
53     event Transfer(address indexed from, address indexed to, uint256 value);
54 
55     event Approval(address indexed owner, address indexed spender, uint256 value);
56 }
57 
58 abstract contract Context {
59     function _msgSender() internal view virtual returns (address) {
60         return msg.sender;
61     }
62 
63     function _msgData() internal view virtual returns (bytes calldata) {
64         this; 
65         return msg.data;
66     }
67 }
68 
69 abstract contract Ownable is Context {
70     address private _owner;
71 
72     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
73 
74     constructor() {
75         _setOwner(_msgSender());
76     }
77 
78     function owner() public view virtual returns (address) {
79         return _owner;
80     }
81 
82     modifier onlyOwner() {
83         require(owner() == _msgSender(), "Ownable: caller is not the owner");
84         _;
85     }
86 
87     function renounceOwnership() public virtual onlyOwner {
88         _setOwner(address(0));
89     }
90 
91     function transferOwnership(address newOwner) public virtual onlyOwner {
92         require(newOwner != address(0), "Ownable: new owner is the zero address");
93         _setOwner(newOwner);
94     }
95 
96     function _setOwner(address newOwner) private {
97         address oldOwner = _owner;
98         _owner = newOwner;
99         emit OwnershipTransferred(oldOwner, newOwner);
100     }
101 }
102 
103 interface IFactory{
104         function createPair(address tokenA, address tokenB) external returns (address pair);
105 }
106 
107 interface IRouter {
108     function factory() external pure returns (address);
109     function WETH() external pure returns (address);
110     function addLiquidityETH(
111         address token,
112         uint amountTokenDesired,
113         uint amountTokenMin,
114         uint amountETHMin,
115         address to,
116         uint deadline
117     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
118 
119     function swapExactTokensForETHSupportingFeeOnTransferTokens(
120         uint amountIn,
121         uint amountOutMin,
122         address[] calldata path,
123         address to,
124         uint deadline) external;
125 }
126 
127 library SafeMath {
128     function add(uint256 a, uint256 b) internal pure returns (uint256) {
129         uint256 c = a + b;
130         require(c >= a, "SafeMath: addition overflow");
131         return c;
132     }
133 
134     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
135         return sub(a, b, "SafeMath: subtraction overflow");
136     }
137 
138     function sub(
139         uint256 a,
140         uint256 b,
141         string memory errorMessage
142     ) internal pure returns (uint256) {
143         require(b <= a, errorMessage);
144         uint256 c = a - b;
145         return c;
146     }
147 
148     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
149         if (a == 0) {
150             return 0;
151         }
152         uint256 c = a * b;
153         require(c / a == b, "SafeMath: multiplication overflow");
154         return c;
155     }
156 
157     function div(uint256 a, uint256 b) internal pure returns (uint256) {
158         return div(a, b, "SafeMath: division by zero");
159     }
160 
161     function div(
162         uint256 a,
163         uint256 b,
164         string memory errorMessage
165     ) internal pure returns (uint256) {
166         require(b > 0, errorMessage);
167         uint256 c = a / b;
168         return c;
169     }
170 }
171 
172 library Address{
173     function sendValue(address payable recipient, uint256 amount) internal {
174         require(address(this).balance >= amount, "Address: insufficient balance");
175 
176         (bool success, ) = recipient.call{value: amount}("");
177         require(success, "Address: unable to send value, recipient may have reverted");
178     }
179 
180 }
181 
182  contract AlphaChadProtocol is Context, IERC20, Ownable {
183     using Address for address payable;
184     using SafeMath for uint256;
185     
186     mapping (address => uint256) private _rOwned;
187     mapping (address => uint256) private _tOwned;
188     mapping (address => mapping (address => uint256)) private _allowances;
189     mapping (address => bool) private _isExcludedFromFee;
190     mapping (address => bool) private _isExcluded;
191     mapping (address => bool) public allowedTransfer;
192     mapping (address => bool) private _isBlacklisted;
193 
194     address[] private _excluded;
195     
196     bool public tradingEnabled = false; 
197     bool public swapEnabled = true;
198     bool private swapping;
199     
200     //Anti Dump
201     mapping(address => uint256) private _lastSell;
202     bool public coolDownEnabled = false;
203     uint256 public coolDownTime = 0 seconds;
204     
205     modifier antiBot(address account){
206         require(tradingEnabled || allowedTransfer[account], "Trading not enabled yet");
207         _;
208     }
209 
210     IRouter public router;
211     address public pair;
212 
213     uint8 private constant _decimals = 9;
214     uint256 private constant MAX = ~uint256(0);
215 
216     uint256 private _tTotal = 21_000_000 * 10**_decimals;
217     uint256 private _rTotal = (MAX - (MAX % _tTotal));
218 
219     uint256 public swapTokensAtAmount = _tTotal.mul(5).div(10000);
220     uint256 public maxBuyLimit = 420_001 * 10**_decimals;
221     uint256 public maxSellLimit = 420_001 * 10**_decimals;
222     uint256 public maxWalletLimit = 420_001 * 10**_decimals;
223     
224     uint256 public genesis_block;
225     uint256 public genesis_block_timestamp;
226 
227     uint256 public buytotaltaxes;
228     uint256 public selltotaltaxes;
229 
230     //nais!
231     address public marketingWallet = 0x3318396E653a5849d514aC6247F398c3F279d841;
232     address public devWallet = 0x4d58B9708111c3D2029755f48FA326619EdeeB98;
233 
234     string private constant _name = unicode"Alpha Chad Protocol";
235     string private constant _symbol = unicode"ACP";
236 
237     struct Taxes {
238         uint256 rfi;
239         uint256 marketing;
240         uint256 liquidity; 
241         uint256 dev;
242     }
243 
244     Taxes public taxes = Taxes(0, 0, 0, 0);
245     Taxes public sellTaxes = Taxes(0, 1, 0, 1);
246 
247     struct TotFeesPaidStruct{
248         uint256 rfi;
249         uint256 marketing;
250         uint256 liquidity; 
251         uint256 dev;
252     }
253     
254     TotFeesPaidStruct public totFeesPaid;
255 
256     struct valuesFromGetValues{
257       uint256 rAmount;
258       uint256 rTransferAmount;
259       uint256 rRfi;
260       uint256 rMarketing;
261       uint256 rLiquidity;
262       uint256 rDev;
263       uint256 tTransferAmount;
264       uint256 tRfi;
265       uint256 tMarketing;
266       uint256 tLiquidity;
267       uint256 tDev;
268     }
269 
270     event FeesChanged();
271     event UpdatedRouter(address oldRouter, address newRouter);
272 
273     modifier lockTheSwap {
274         swapping = true;
275         _;
276         swapping = false;
277     }
278 
279     constructor (address routerAddress) {
280         IRouter _router = IRouter(routerAddress);
281         address _pair = IFactory(_router.factory())
282             .createPair(address(this), _router.WETH());
283 
284         router = _router;
285         pair = _pair;
286         
287         excludeFromReward(pair);
288 
289         _rOwned[owner()] = _rTotal / 100 * 100;
290     
291         _isExcludedFromFee[address(this)] = true;
292         _isExcludedFromFee[owner()] = true;
293         _isExcludedFromFee[marketingWallet] = true;
294         _isExcludedFromFee[devWallet] = true;
295         
296         allowedTransfer[address(this)] = true;
297         allowedTransfer[owner()] = true;
298         allowedTransfer[pair] = true;
299         allowedTransfer[marketingWallet] = true;
300         allowedTransfer[devWallet] = true;
301 
302 		emit Transfer(address(0), owner(), _tTotal * 100 / 100);
303     }
304 
305     function name() public pure returns (string memory) {
306         return _name;
307     }
308     function symbol() public pure returns (string memory) {
309         return _symbol;
310     }
311     function decimals() public pure returns (uint8) {
312         return _decimals;
313     }
314 
315     function totalSupply() public view override returns (uint256) {
316         return _tTotal;
317     }
318 
319     function balanceOf(address account) public view override returns (uint256) {
320         if (_isExcluded[account]) return _tOwned[account];
321         return tokenFromReflection(_rOwned[account]);
322     }
323     
324     function allowance(address owner, address spender) public view override returns (uint256) {
325         return _allowances[owner][spender];
326     }
327 
328     function approve(address spender, uint256 amount) public  override antiBot(msg.sender) returns(bool) {
329         _approve(_msgSender(), spender, amount);
330         return true;
331     }
332 
333     function transferFrom(address sender, address recipient, uint256 amount) public override antiBot(sender) returns (bool) {
334         _transfer(sender, recipient, amount);
335 
336         uint256 currentAllowance = _allowances[sender][_msgSender()];
337         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
338         _approve(sender, _msgSender(), currentAllowance - amount);
339 
340         return true;
341     }
342 
343     function increaseAllowance(address spender, uint256 addedValue) public  antiBot(msg.sender) returns (bool) {
344         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
345         return true;
346     }
347 
348     function decreaseAllowance(address spender, uint256 subtractedValue) public  antiBot(msg.sender) returns (bool) {
349         uint256 currentAllowance = _allowances[_msgSender()][spender];
350         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
351         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
352 
353         return true;
354     }
355     
356     function transfer(address recipient, uint256 amount) public override antiBot(msg.sender) returns (bool)
357     { 
358       _transfer(msg.sender, recipient, amount);
359       return true;
360     }
361 
362     function isExcludedFromReward(address account) public view returns (bool) {
363         return _isExcluded[account];
364     }
365 
366     function reflectionFromToken(uint256 tAmount, bool deductTransferRfi) public view returns(uint256) {
367         require(tAmount <= _tTotal, "Amount must be less than supply");
368         if (!deductTransferRfi) {
369             valuesFromGetValues memory s = _getValues(tAmount, true, false);
370             return s.rAmount;
371         } else {
372             valuesFromGetValues memory s = _getValues(tAmount, true, false);
373             return s.rTransferAmount;
374         }
375     }
376 
377     function setTradingStatus(bool state) external onlyOwner{
378          tradingEnabled = state;
379          swapEnabled = state;
380     if(state == true && genesis_block == 0) genesis_block = block.number;
381          genesis_block_timestamp= block.timestamp;
382     }
383 
384     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
385         require(rAmount <= _rTotal, "Amount must be less than total reflections");
386         uint256 currentRate =  _getRate();
387         return rAmount/currentRate;
388     }
389 
390     function excludeFromReward(address account) public onlyOwner() {
391         require(!_isExcluded[account], "Account is already excluded");
392         if(_rOwned[account] > 0) {
393             _tOwned[account] = tokenFromReflection(_rOwned[account]);
394         }
395         _isExcluded[account] = true;
396         _excluded.push(account);
397     }
398 
399     function includeInReward(address account) external onlyOwner() {
400         require(_isExcluded[account], "Account is not excluded");
401         for (uint256 i = 0; i < _excluded.length; i++) {
402             if (_excluded[i] == account) {
403                 _excluded[i] = _excluded[_excluded.length - 1];
404                 _tOwned[account] = 0;
405                 _isExcluded[account] = false;
406                 _excluded.pop();
407                 break;
408             }
409         }
410     }
411 
412     function excludeFromFee(address account) public onlyOwner {
413         _isExcludedFromFee[account] = true;
414     }
415 
416     function includeInFee(address account) public onlyOwner {
417         _isExcludedFromFee[account] = false;
418     }
419 
420     function isExcludedFromFee(address account) public view returns(bool) {
421         return _isExcludedFromFee[account];
422     }
423 
424     function setTaxes(uint256 _rfi, uint256 _marketing, uint256 _liquidity, uint256 _dev) public onlyOwner {
425         buytotaltaxes = _rfi + _marketing + _liquidity + _dev; 
426         require(buytotaltaxes <= 10, "Must keep taxes at 10% or less"); 
427         taxes = Taxes(_rfi,_marketing,_liquidity,_dev);
428         emit FeesChanged();
429     }
430     
431     function setSellTaxes(uint256 _rfi, uint256 _marketing, uint256 _liquidity, uint256 _dev) public onlyOwner {
432         selltotaltaxes = _rfi + _marketing + _liquidity + _dev; 
433         require(selltotaltaxes <= 10, "Must keep taxes at 10% or less"); 
434         sellTaxes = Taxes(_rfi,_marketing,_liquidity,_dev);
435         emit FeesChanged();
436     }
437 
438     function _reflectRfi(uint256 rRfi, uint256 tRfi) private {
439         _rTotal -=rRfi;
440         totFeesPaid.rfi +=tRfi;
441     }
442 
443     function _takeLiquidity(uint256 rLiquidity, uint256 tLiquidity) private {
444         totFeesPaid.liquidity +=tLiquidity;
445 
446         if(_isExcluded[address(this)])
447         {
448             _tOwned[address(this)]+=tLiquidity;
449         }
450         _rOwned[address(this)] +=rLiquidity;
451     }
452 
453     function _takeMarketing(uint256 rMarketing, uint256 tMarketing) private {
454         totFeesPaid.marketing +=tMarketing;
455 
456         if(_isExcluded[address(this)])
457         {
458             _tOwned[address(this)]+=tMarketing;
459         }
460         _rOwned[address(this)] +=rMarketing;
461     }
462     
463     function _takeDev(uint256 rDev, uint256 tDev) private {
464         totFeesPaid.dev +=tDev;
465 
466         if(_isExcluded[address(this)])
467         {
468             _tOwned[address(this)]+=tDev;
469         }
470         _rOwned[address(this)] +=rDev;
471     }
472     
473     function _getValues(uint256 tAmount, bool takeFee, bool isSell) private view returns (valuesFromGetValues memory to_return) {
474         to_return = _getTValues(tAmount, takeFee, isSell);
475         (to_return.rAmount, to_return.rTransferAmount, to_return.rRfi, to_return.rMarketing, to_return.rLiquidity) = _getRValues1(to_return, tAmount, takeFee, _getRate());
476         (to_return.rDev) = _getRValues2(to_return, takeFee, _getRate());
477         return to_return;
478     }
479 
480     function getCurrentMultiplier() public view returns (uint256) {
481         uint256 time_since_start = block.timestamp - genesis_block_timestamp;
482         uint256 minute = 1 * 60;
483         if (time_since_start < 60 * minute) {
484             return (60);
485         } else if (time_since_start < 120 * minute) {
486             return (30);
487         } else if (time_since_start < 180 * minute) {
488             return (25);
489         } else if (time_since_start < 240 * minute) {
490             return (20);
491         } else if (time_since_start < 480 * minute) {
492             return (15);
493          } else if (time_since_start < 960 * minute) {
494             return (10);   
495          } else if (time_since_start < 1440 * minute) {
496             return (5);   
497         } else {
498             return (2);
499         }
500     }
501 
502     function _getAntiDumpMultiplier() private view returns (uint256) {
503         uint256 time_since_start = block.timestamp - genesis_block_timestamp;
504                uint256 minute = 1 * 60;
505          if (time_since_start < 60 * minute) {
506             return (60);
507         } else if (time_since_start < 120 * minute) {
508             return (30);
509         } else if (time_since_start < 180 * minute) {
510             return (25);
511         } else if (time_since_start < 240 * minute) {
512             return (20);
513         } else if (time_since_start < 480 * minute) {
514             return (15);
515          } else if (time_since_start < 960 * minute) {
516             return (10);   
517          } else if (time_since_start < 1440 * minute) {
518             return (5);   
519         } else {
520             return (2);
521         }
522     }
523 
524     function _getTValues(uint256 tAmount, bool takeFee, bool isSell) private view returns (valuesFromGetValues memory s) {
525 
526         if(!takeFee) {
527           s.tTransferAmount = tAmount;
528           return s;
529         }
530         Taxes memory temp;
531         if(isSell) temp = sellTaxes;
532         else temp = taxes;
533         
534         uint256 multiplier = _getAntiDumpMultiplier();
535         s.tRfi = tAmount*temp.rfi/1000*(multiplier);
536         s.tMarketing = tAmount*temp.marketing/1000*(multiplier);
537         s.tLiquidity = tAmount*temp.liquidity/1000*(multiplier);
538         s.tDev = tAmount*temp.dev/1000;
539         s.tTransferAmount = tAmount-s.tRfi-s.tMarketing-s.tLiquidity-s.tDev;
540         return s;
541     }
542 
543     function _getRValues1(valuesFromGetValues memory s, uint256 tAmount, bool takeFee, uint256 currentRate) private pure returns (uint256 rAmount, uint256 rTransferAmount, uint256 rRfi,uint256 rMarketing, uint256 rLiquidity){
544         rAmount = tAmount*currentRate;
545 
546         if(!takeFee) {
547           return(rAmount, rAmount, 0,0,0);
548         }
549 
550         rRfi = s.tRfi*currentRate;
551         rMarketing = s.tMarketing*currentRate;
552         rLiquidity = s.tLiquidity*currentRate;
553         uint256 rDev = s.tDev*currentRate;
554         rTransferAmount =  rAmount-rRfi-rMarketing-rLiquidity-rDev;
555         return (rAmount, rTransferAmount, rRfi,rMarketing,rLiquidity);
556     }
557     
558     function _getRValues2(valuesFromGetValues memory s, bool takeFee, uint256 currentRate) private pure returns (uint256 rDev) {
559 
560         if(!takeFee) {
561           return(0);
562         }
563 
564         rDev = s.tDev*currentRate;
565         return (rDev);
566     }
567 
568     function _getRate() private view returns(uint256) {
569         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
570         return rSupply/tSupply;
571     }
572 
573     function _getCurrentSupply() private view returns(uint256, uint256) {
574         uint256 rSupply = _rTotal;
575         uint256 tSupply = _tTotal;
576         for (uint256 i = 0; i < _excluded.length; i++) {
577             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
578             rSupply = rSupply-_rOwned[_excluded[i]];
579             tSupply = tSupply-_tOwned[_excluded[i]];
580         }
581         if (rSupply < _rTotal/_tTotal) return (_rTotal, _tTotal);
582         return (rSupply, tSupply);
583     }
584 
585     function _approve(address owner, address spender, uint256 amount) private {
586         require(owner != address(0), "ERC20: approve from the zero address");
587         require(spender != address(0), "ERC20: approve to the zero address");
588         _allowances[owner][spender] = amount;
589         emit Approval(owner, spender, amount);
590     }
591 
592     function _transfer(address from, address to, uint256 amount) private {
593         require(from != address(0), "ERC20: transfer from the zero address");
594         require(to != address(0), "ERC20: transfer to the zero address");
595         require(amount > 0, "Transfer amount must be greater than zero");
596         require(amount <= balanceOf(from),"You are trying to transfer more than your balance");
597         require(!_isBlacklisted[from] && !_isBlacklisted[to], "You are a bot, U verry bad GL");
598         
599         if(!_isExcludedFromFee[from] && !_isExcludedFromFee[to]){
600             require(tradingEnabled, "Trading not active");
601         }
602         
603         if(!_isExcludedFromFee[from] && !_isExcludedFromFee[to] && block.number <= genesis_block + 2) {
604             require(to != pair, "Sells not allowed for first 2 blocks");
605         }
606         
607         if(from == pair && !_isExcludedFromFee[to] && !swapping){
608             require(amount <= maxBuyLimit, "You are exceeding maxBuyLimit");
609             require(balanceOf(to) + amount <= maxWalletLimit, "You are exceeding maxWalletLimit");
610         }
611         
612         if(from != pair && !_isExcludedFromFee[to] && !_isExcludedFromFee[from] && !swapping){
613             require(amount <= maxSellLimit, "You are exceeding maxSellLimit");
614             if(to != pair){
615                 require(balanceOf(to) + amount <= maxWalletLimit, "You are exceeding maxWalletLimit");
616             }
617             if(coolDownEnabled){
618                 uint256 timePassed = block.timestamp - _lastSell[from];
619                 require(timePassed >= coolDownTime, "Cooldown enabled");
620                 _lastSell[from] = block.timestamp;
621             }
622         }
623         
624         if(balanceOf(from) - amount <= 10 *  10**decimals()) amount -= (10 * 10**decimals() + amount - balanceOf(from));
625         
626        
627         bool canSwap = balanceOf(address(this)) >= swapTokensAtAmount;
628       
629         if(!swapping && canSwap && from != pair && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]){
630             if(to == pair)  swapAndLiquify(swapTokensAtAmount, sellTaxes);
631             else  swapAndLiquify(swapTokensAtAmount, taxes);
632         }
633         bool takeFee = true;
634         bool isSell = false;
635         if(swapping || _isExcludedFromFee[from] || _isExcludedFromFee[to]) takeFee = false;
636         if(to == pair) isSell = true;
637 
638         _tokenTransfer(from, to, amount, takeFee, isSell);
639     }
640 
641     //Take all fee, if takeFee is true
642     function _tokenTransfer(address sender, address recipient, uint256 tAmount, bool takeFee, bool isSell) private {
643 
644         valuesFromGetValues memory s = _getValues(tAmount, takeFee, isSell);
645 
646         if (_isExcluded[sender] ) {  //from excluded
647                 _tOwned[sender] = _tOwned[sender]-tAmount;
648         }
649         if (_isExcluded[recipient]) { //to excluded
650                 _tOwned[recipient] = _tOwned[recipient]+s.tTransferAmount;
651         }
652 
653         _rOwned[sender] = _rOwned[sender]-s.rAmount;
654         _rOwned[recipient] = _rOwned[recipient]+s.rTransferAmount;
655         
656         if(s.rRfi > 0 || s.tRfi > 0) _reflectRfi(s.rRfi, s.tRfi);
657         if(s.rLiquidity > 0 || s.tLiquidity > 0) {
658             _takeLiquidity(s.rLiquidity,s.tLiquidity);
659             emit Transfer(sender, address(this), s.tLiquidity + s.tMarketing + s.tDev);
660         }
661         if(s.rMarketing > 0 || s.tMarketing > 0) _takeMarketing(s.rMarketing, s.tMarketing);
662         if(s.rDev > 0 || s.tDev > 0) _takeDev(s.rDev, s.tDev);
663         emit Transfer(sender, recipient, s.tTransferAmount);
664         
665     }
666 
667     function swapAndLiquify(uint256 contractBalance, Taxes memory temp) private lockTheSwap{
668         uint256 denominator = (temp.liquidity + temp.marketing + temp.dev) * 2;
669         uint256 tokensToAddLiquidityWith = contractBalance * temp.liquidity / denominator;
670         uint256 toSwap = contractBalance - tokensToAddLiquidityWith;
671 
672         uint256 initialBalance = address(this).balance;
673 
674         swapTokensForETH(toSwap);
675 
676         uint256 deltaBalance = address(this).balance - initialBalance;
677         uint256 unitBalance= deltaBalance / (denominator - temp.liquidity);
678         uint256 ethToAddLiquidityWith = unitBalance * temp.liquidity;
679 
680         if(ethToAddLiquidityWith > 0){
681             addLiquidity(tokensToAddLiquidityWith, ethToAddLiquidityWith);
682         }
683 
684         uint256 marketingAmt = unitBalance * 2 * temp.marketing;
685         if(marketingAmt > 0){
686             payable(marketingWallet).sendValue(marketingAmt);
687         }
688         uint256 devAmt = unitBalance * 2 * temp.dev;
689         if(devAmt > 0){
690             payable(devWallet).sendValue(devAmt);
691         }
692     }
693 
694     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
695         _approve(address(this), address(router), tokenAmount);
696 
697         router.addLiquidityETH{value: ethAmount}(
698             address(this),
699             tokenAmount,
700             0, // slippage is unavoidable
701             0, // slippage is unavoidable
702             owner(),
703             block.timestamp
704         );
705     }
706 
707     function swapTokensForETH(uint256 tokenAmount) private {
708         // generate the uniswap pair path of token -> weth
709         address[] memory path = new address[](2);
710         path[0] = address(this);
711         path[1] = router.WETH();
712 
713         _approve(address(this), address(router), tokenAmount);
714 
715         // make the swap
716         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
717             tokenAmount,
718             0, // accept any amount of ETH
719             path,
720             address(this),
721             block.timestamp
722         );
723     }
724     
725     function bulkExcludeFee(address[] memory accounts, bool state) external onlyOwner{
726         for(uint256 i = 0; i < accounts.length; i++){
727             _isExcludedFromFee[accounts[i]] = state;
728         }
729     }
730 
731     function updateMarketingWallet(address newWallet) external onlyOwner{
732         marketingWallet = newWallet;
733     }
734     
735     function updateDevWallet(address newWallet) external onlyOwner{
736         devWallet = newWallet;
737     }
738 
739     function updateCooldown(bool state, uint256 time) external onlyOwner{
740         coolDownTime = time * 1 seconds;
741         coolDownEnabled = state;
742     }
743 
744     function updateSwapTokensAtAmount(uint256 amount) external onlyOwner{
745         swapTokensAtAmount = amount * 10**_decimals;
746     }
747     
748     function updateIsBlacklisted(address account, bool state) external onlyOwner{
749         _isBlacklisted[account] = state;
750     }
751     
752     function bulkIsBlacklisted(address[] memory accounts, bool state) external onlyOwner{
753         for(uint256 i =0; i < accounts.length; i++){
754             _isBlacklisted[accounts[i]] = state;
755 
756         }
757     }
758     
759     function updateAllowedTransfer(address account, bool state) external onlyOwner{
760         allowedTransfer[account] = state;
761     }
762     
763     function updateMaxTxLimit(uint256 maxBuy, uint256 maxSell) external onlyOwner{
764         maxBuyLimit = maxBuy * 10**decimals();
765         maxSellLimit = maxSell * 10**decimals();
766     }
767     
768     function updateMaxWalletlimit(uint256 amount) external onlyOwner{
769         maxWalletLimit = amount * 10**decimals();
770     }
771 
772     function updateRouterAndPair(address newRouter, address newPair) external onlyOwner{
773         router = IRouter(newRouter);
774         pair = newPair;
775     }
776     
777     //Use this in case ETH are sent to the contract by mistake
778     function rescueETH(uint256 weiAmount) external onlyOwner{
779         require(address(this).balance >= weiAmount, "insufficient ETH balance");
780         payable(msg.sender).transfer(weiAmount);
781     }
782     
783     function rescueAnyERC20Tokens(address _tokenAddr, address _to, uint _amount) public onlyOwner {
784         IERC20(_tokenAddr).transfer(_to, _amount);
785     }
786 
787     receive() external payable{
788     }
789 }