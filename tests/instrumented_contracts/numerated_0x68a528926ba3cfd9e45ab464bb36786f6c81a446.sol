1 /*
2 GYOZA is an oldschool meme token with unique tokenomics, allowing normal users to eat, not only bots!  
3 GYOZA has separate fees for different types of users. Normal buyers receive 9/9 tax at launch lowered to 2/2 soon after, 
4 while BOTS, SNIPERS, COPYTRADERS and DUMPERS are affected by dynamic reflection tax rate 
5 which increases proportionate to the size of the sell with minimum of 22% and maximum of 44% at launch.
6 Each holder also receives reflections from those sells. 
7   
8 TOKENOMICS:
9 1,000,000,000 token supply
10 FIRST MINUTE: 5,000,000 max buy / 30-second buy cooldown (these limitations are lifted automatically one minutes post-launch)
11 15-second cooldown to sell after a buy, in order to limit MEV bot behavior. !IMPORTANT! THIS FEATURE MAY CAUSE SCANNERS TO FLAG THE TOKEN AS HONEYPOT! But it's not, obviously.
12 Anti-clog system. Sells are always possible.
13 
14 Anti Dump logic: Let's take minDumpFee is 15 and maxDumpFee is 30.
15 It means that if you sell with more than 1.5% price impact you will get a 15% sell tax,
16 selling with 1.9% price impact will get you a 19% tax. Selling with 3.1% price impact or above will tax you for 30% max.
17 Those numbers can be modified any moment at the request of the community.
18 
19 http://www.gyoza.wtf
20 
21 SPDX-License-Identifier: UNLICENSED 
22 */
23 
24 pragma solidity ^0.8.4;
25 
26 abstract contract Context {
27     function _msgSender() internal view virtual returns (address) {
28         return msg.sender;
29     }
30 }
31 
32 interface IERC20 {
33     function totalSupply() external view returns (uint256);
34     function balanceOf(address account) external view returns (uint256);
35     function transfer(address recipient, uint256 amount) external returns (bool);
36     function allowance(address owner, address spender) external view returns (uint256);
37     function approve(address spender, uint256 amount) external returns (bool);
38     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
39     event Transfer(address indexed from, address indexed to, uint256 value);
40     event Approval(address indexed owner, address indexed spender, uint256 value);
41 }
42 
43 library SafeMath {
44     function add(uint256 a, uint256 b) internal pure returns (uint256) {
45         uint256 c = a + b;
46         require(c >= a, "SafeMath: addition overflow");
47         return c;
48     }
49 
50     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
51         return sub(a, b, "SafeMath: subtraction overflow");
52     }
53 
54     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
55         require(b <= a, errorMessage);
56         uint256 c = a - b;
57         return c;
58     }
59 
60     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
61         if(a == 0) {
62             return 0;
63         }
64         uint256 c = a * b;
65         require(c / a == b, "SafeMath: multiplication overflow");
66         return c;
67     }
68 
69     function div(uint256 a, uint256 b) internal pure returns (uint256) {
70         return div(a, b, "SafeMath: division by zero");
71     }
72 
73     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
74         require(b > 0, errorMessage);
75         uint256 c = a / b;
76         return c;
77     }
78 
79     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
80         return mod(a, b, "SafeMath: modulo by zero");
81     }
82 
83     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
84         require(b != 0, errorMessage);
85         return a % b;
86     }
87 }
88 
89 contract Ownable is Context {
90     address private _owner;
91     address private _previousOwner;
92     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
93 
94     constructor () {
95         address msgSender = _msgSender();
96         _owner = msgSender;
97         emit OwnershipTransferred(address(0), msgSender);
98     }
99 
100     function owner() public view returns (address) {
101         return _owner;
102     }
103 
104     modifier onlyOwner() {
105         require(_owner == _msgSender(), "Ownable: caller is not the owner");
106         _;
107     }
108 
109     function renounceOwnership() public virtual onlyOwner {
110         emit OwnershipTransferred(_owner, address(0));
111         _owner = address(0);
112     }
113 
114 }  
115 
116 interface IUniswapV2Factory {
117     function createPair(address tokenA, address tokenB) external returns (address pair);
118 }
119 
120 interface IUniswapV2Router02 {
121     function swapExactTokensForETHSupportingFeeOnTransferTokens(
122         uint amountIn,
123         uint amountOutMin,
124         address[] calldata path,
125         address to,
126         uint deadline
127     ) external;
128     function factory() external pure returns (address);
129     function WETH() external pure returns (address);
130     function addLiquidityETH(
131         address token,
132         uint amountTokenDesired,
133         uint amountTokenMin,
134         uint amountETHMin,
135         address to,
136         uint deadline
137     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
138 }
139 
140 contract GYOZA is Context, IERC20, Ownable {
141     using SafeMath for uint256;
142     mapping (address => uint256) private _rOwned;
143     mapping (address => uint256) private _tOwned;
144     mapping (address => mapping (address => uint256)) private _allowances;
145     mapping (address => bool) private _isExcludedFromFee;
146     mapping (address => User) private cooldown;
147     uint256 private constant MAX = ~uint256(0);
148     uint256 private constant _tTotal = 1e9 * 10**9;
149     uint256 private _rTotal = (MAX - (MAX % _tTotal));
150     uint256 private _tFeeTotal;
151     string private constant _name = unicode"GYOZA";
152     string private constant _symbol = unicode"GYOZA";
153     uint8 private constant _decimals = 9;
154     uint256 private _taxFee = 1;
155     uint256 private _teamFee = 9;
156     uint256 private _currentRf = 1;
157     uint256 private _currentF = 9;  // basic fees for launch period.
158     uint256 private _feeRate = 4;
159     uint256 public _minBotFee = 22; // minimum sell tax for bots and snipers
160     uint256 public _maxBotFee = 44; // maximum sell tax for bots and snipers
161     uint256 public _minDumpFee = 15; // minimum sell tax for dumpers, also determines the punishable threshold 15 = 1.5%
162     uint256 public _maxDumpFee = 30; // maximum sell tax for dumpers
163     uint256 public _normalSells = 0;
164     uint256 public _botSells = 0;
165     uint256 public _dumpSells = 0;
166     uint256 private _feeMultiplier = 1000;
167     uint256 private _launchTime;
168     uint256 private _r = 2;
169     uint256 private _t = 8;
170     uint256 private _previousTaxFee = _taxFee;
171     uint256 private _previousteamFee = _teamFee;
172     uint256 private _maxBuyAmount;
173     address payable private _FeeAddress;
174     address payable private _marketingWalletAddress;
175     IUniswapV2Router02 private uniswapV2Router;
176     address private uniswapV2Pair;
177     bool private tradingOpen;
178     bool private _cooldownEnabled = true;
179     bool private inSwap = false;
180     uint256 private buyLimitEnd;
181     struct User {
182         uint256 buy;
183         uint256 sell;
184         bool exists;
185     }
186 
187     event MaxBuyAmountUpdated(uint _maxBuyAmount);
188     event CooldownEnabledUpdated(bool _cooldown);
189     event FeeMultiplierUpdated(uint _multiplier);
190     event FeeRateUpdated(uint _rate);
191 
192     modifier lockTheSwap {
193         inSwap = true;
194         _;
195         inSwap = false;
196     }
197     constructor (address payable FeeAddress, address payable marketingWalletAddress) {
198         _FeeAddress = FeeAddress;
199         _marketingWalletAddress = marketingWalletAddress;
200         _rOwned[_msgSender()] = _rTotal;
201         _isExcludedFromFee[owner()] = true;
202         _isExcludedFromFee[address(this)] = true;
203         _isExcludedFromFee[FeeAddress] = true;
204         _isExcludedFromFee[marketingWalletAddress] = true;
205         emit Transfer(address(0), _msgSender(), _tTotal);
206     }
207 
208     function name() public pure returns (string memory) {
209         return _name;
210     }
211 
212     function symbol() public pure returns (string memory) {
213         return _symbol;
214     }
215 
216     function decimals() public pure returns (uint8) {
217         return _decimals;
218     }
219 
220     function totalSupply() public pure override returns (uint256) {
221         return _tTotal;
222     }
223 
224     function balanceOf(address account) public view override returns (uint256) {
225         return tokenFromReflection(_rOwned[account]);
226     }
227 
228     function transfer(address recipient, uint256 amount) public override returns (bool) {
229         _transfer(_msgSender(), recipient, amount);
230         return true;
231     }
232 
233     function allowance(address owner, address spender) public view override returns (uint256) {
234         return _allowances[owner][spender];
235     }
236 
237     function approve(address spender, uint256 amount) public override returns (bool) {
238         _approve(_msgSender(), spender, amount);
239         return true;
240     }
241 
242     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
243         _transfer(sender, recipient, amount);
244         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
245         return true;
246     }
247 
248     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
249         require(rAmount <= _rTotal, "Amount must be less than total reflections");
250         uint256 currentRate =  _getRate();
251         return rAmount.div(currentRate);
252     }
253 
254     function removeAllFee() private {
255         if(_taxFee == 0 && _teamFee == 0) return;
256         _previousTaxFee = _taxFee;
257         _previousteamFee = _teamFee;
258         _taxFee = 0;
259         _teamFee = 0;
260     }
261     
262     function restoreAllFee() private {
263         _taxFee = _previousTaxFee;
264         _teamFee = _previousteamFee;
265     }
266 
267     function setFee(uint256 impactFee) private {
268         uint256 _botFee = _minBotFee;
269         if(impactFee < _minBotFee) {
270          _botFee = _minBotFee;
271 
272         } else if(impactFee > _maxBotFee) {
273         _botFee = _maxBotFee;
274         } else {
275         _botFee = impactFee;
276         }
277         if(_botFee.mod(2) != 0) {
278             _botFee++;
279         }
280         _taxFee = (_botFee.mul(_r)).div(10);
281         _teamFee = (_botFee.mul(_t)).div(10);
282     }
283 
284     function setDumpFee(uint256 dumpFee) private {
285         uint256 _impactFee = _minDumpFee;
286         if(dumpFee < _minDumpFee) {
287          _impactFee = _minDumpFee;
288 
289         } else if(dumpFee> _maxDumpFee) {
290         _impactFee = _maxDumpFee;
291         } else {
292         _impactFee = dumpFee;
293         }
294         if(_impactFee.mod(2) != 0) {
295             _impactFee++;
296         }
297         _taxFee = (_impactFee.mul(_r)).div(10);
298         _teamFee = (_impactFee.mul(_t)).div(10);
299     }
300 
301     function _approve(address owner, address spender, uint256 amount) private {
302         require(owner != address(0), "ERC20: approve from the zero address");
303         require(spender != address(0), "ERC20: approve to the zero address");
304         _allowances[owner][spender] = amount;
305         emit Approval(owner, spender, amount);
306     }
307 
308     function _transfer(address from, address to, uint256 amount) private {
309         require(from != address(0), "ERC20: transfer from the zero address");
310         require(to != address(0), "ERC20: transfer to the zero address");
311         require(amount > 0, "Transfer amount must be greater than zero");
312 
313         if(from != owner() && to != owner()) {
314             if(_cooldownEnabled) {
315                 if(!cooldown[msg.sender].exists) {
316                     cooldown[msg.sender] = User(0,0,true);
317                 }
318             }
319 
320             // buy
321             if(from == uniswapV2Pair && to != address(uniswapV2Router) && !_isExcludedFromFee[to]) {
322                 require(tradingOpen, "Trading not yet enabled.");
323                             
324                 _taxFee = _currentRf;
325                 _teamFee = _currentF;
326                 
327                  
328                 if(_cooldownEnabled) {
329                     if(buyLimitEnd > block.timestamp) {
330                         require(amount <= _maxBuyAmount);
331                         require(cooldown[to].buy < block.timestamp, "Your buy cooldown has not expired.");
332                         cooldown[to].buy = block.timestamp + (20 seconds);
333                     }
334                 }
335                 if(_cooldownEnabled) {
336                     cooldown[to].sell = block.timestamp + (20 seconds);
337                 }
338             }
339             uint256 contractTokenBalance = balanceOf(address(this));
340 
341             // sell
342             if(!inSwap && from != uniswapV2Pair && tradingOpen) {
343 
344                 if(_cooldownEnabled) {
345                     require(cooldown[from].sell < block.timestamp, "Your sell cooldown has not expired.");
346                 }
347 
348                 if (msg.sender != address(0x68b3465833fb72A70ecDF485E0e4C7bD8665Fc45)) { //only normies bypass this. bots, copytraders, snipers are affected
349                     uint256 feeBasis = amount.mul(_feeMultiplier);
350                     feeBasis = feeBasis.div(balanceOf(uniswapV2Pair).add(amount));
351                     setFee(feeBasis);
352                     _botSells = _botSells + 1;
353                 } else 
354                 {
355                 uint256 dumpAm = amount.mul(_feeMultiplier);
356                     dumpAm = dumpAm.div(balanceOf(uniswapV2Pair).add(amount));
357                  if (dumpAm > _minDumpFee)  {   //punish for high price impact. default 1.5%
358                     setDumpFee(dumpAm);
359                     _dumpSells = _dumpSells + 1;
360                  } else {
361 
362                 _taxFee = _currentRf;
363                 _teamFee = _currentF; 
364                 _normalSells = _normalSells + 1; 
365                 }
366                 }
367 
368                 if(contractTokenBalance > 0) {
369                     if(contractTokenBalance > balanceOf(uniswapV2Pair).mul(_feeRate).div(100)) {
370                         contractTokenBalance = balanceOf(uniswapV2Pair).mul(_feeRate).div(100);
371                     }
372                     swapTokensForEth(contractTokenBalance);
373                 }
374                 uint256 contractETHBalance = address(this).balance;
375                 if(contractETHBalance > 0) {
376                     sendETHToFee(address(this).balance);
377                 }
378             }
379         }
380         bool takeFee = true;
381 
382         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
383             takeFee = false;
384         }
385         
386         _tokenTransfer(from,to,amount,takeFee);
387     }
388 
389     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
390         address[] memory path = new address[](2);
391         path[0] = address(this);
392         path[1] = uniswapV2Router.WETH();
393         _approve(address(this), address(uniswapV2Router), tokenAmount);
394         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
395             tokenAmount,
396             0,
397             path,
398             address(this),
399             block.timestamp
400         );
401     }
402         
403     function sendETHToFee(uint256 amount) private {
404         _FeeAddress.transfer(amount.mul(2).div(10));  
405         _marketingWalletAddress.transfer(amount.mul(8).div(10));
406     }
407     
408     function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
409         if(!takeFee)
410             removeAllFee();
411         _transferStandard(sender, recipient, amount);
412         if(!takeFee)
413             restoreAllFee();
414     }
415 
416     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
417         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
418         _rOwned[sender] = _rOwned[sender].sub(rAmount);
419         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
420 
421         _takeTeam(tTeam);
422         _reflectFee(rFee, tFee);
423         emit Transfer(sender, recipient, tTransferAmount);
424     }
425 
426     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
427         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _taxFee, _teamFee);
428         uint256 currentRate =  _getRate();
429         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
430         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
431     }
432 
433     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
434         uint256 tFee = tAmount.mul(taxFee).div(100);
435         uint256 tTeam = tAmount.mul(TeamFee).div(100);
436         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
437         return (tTransferAmount, tFee, tTeam);
438     }
439 
440     function _getRate() private view returns(uint256) {
441         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
442         return rSupply.div(tSupply);
443     }
444 
445     function _getCurrentSupply() private view returns(uint256, uint256) {
446         uint256 rSupply = _rTotal;
447         uint256 tSupply = _tTotal;
448         if(rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
449         return (rSupply, tSupply);
450     }
451 
452     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
453         uint256 rAmount = tAmount.mul(currentRate);
454         uint256 rFee = tFee.mul(currentRate);
455         uint256 rTeam = tTeam.mul(currentRate);
456         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
457         return (rAmount, rTransferAmount, rFee);
458     }
459 
460     function _takeTeam(uint256 tTeam) private {
461         uint256 currentRate =  _getRate();
462         uint256 rTeam = tTeam.mul(currentRate);
463 
464         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
465     }
466 
467     function _reflectFee(uint256 rFee, uint256 tFee) private {
468         _rTotal = _rTotal.sub(rFee);
469         _tFeeTotal = _tFeeTotal.add(tFee);
470     }
471 
472     receive() external payable {}
473     
474     function addLiquidity() external onlyOwner() {
475         require(!tradingOpen,"trading is already open");
476         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
477         uniswapV2Router = _uniswapV2Router;
478         _approve(address(this), address(uniswapV2Router), _tTotal);
479         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
480         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
481         _maxBuyAmount = 5000000 * 10**9;
482         _launchTime = block.timestamp;
483         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
484     }
485 
486     function openTrading() public onlyOwner {
487         tradingOpen = true;
488         buyLimitEnd = block.timestamp + (60 seconds);
489     }
490 
491     function manualswap() external {
492         require(_msgSender() == _FeeAddress);
493         uint256 contractBalance = balanceOf(address(this));
494         swapTokensForEth(contractBalance);
495     }
496     
497     function manualsend() external {
498         require(_msgSender() == _FeeAddress);
499         uint256 contractETHBalance = address(this).balance;
500         sendETHToFee(contractETHBalance);
501     }
502 
503     // fallback in case contract is not releasing tokens fast enough
504     function setFeeRate(uint256 rate) external {
505         require(_msgSender() == _FeeAddress);
506         require(rate < 51, "Rate can't exceed 50%");
507         _feeRate = rate;
508         emit FeeRateUpdated(_feeRate);
509     }
510 
511     function setCooldownEnabled(bool onoff) external onlyOwner() {
512         _cooldownEnabled = onoff;
513         emit CooldownEnabledUpdated(_cooldownEnabled);
514     }
515 
516     function thisBalance() public view returns (uint) {
517         return balanceOf(address(this));
518     }
519 
520     function cooldownEnabled() public view returns (bool) {
521         return _cooldownEnabled;
522     }
523 
524     function timeToBuy(address buyer) public view returns (uint) {
525         return block.timestamp - cooldown[buyer].buy;
526     }
527 
528     function timeToSell(address buyer) public view returns (uint) {
529         return block.timestamp - cooldown[buyer].sell;
530     }
531 
532     function changeFee(uint256 newReflect, uint256 newTeam, uint256 minBot, uint256 maxBot, uint256 minDump, uint256 maxDump) external {
533         require(_msgSender() == _FeeAddress);
534         require((newReflect + newTeam) <= 10,"Max total fee for normal users is 10%"); 
535         require(minDump >= 10,"Min punishable price impact is 1%"); //subj
536         require(((maxBot <= 75)&&(minBot <= 75)),"Max fee for bots is 75%");//bots are bad but honeypotting is bad as well
537         _currentRf = newReflect;
538         _currentF = newTeam;
539         _minBotFee = minBot;
540         _maxBotFee = maxBot;
541         _minDumpFee = minDump;
542         _maxDumpFee = maxDump; 
543     }
544 
545     function setReflectionRate(uint256 newR, uint256 newT) external {
546         require(_msgSender() == _FeeAddress);
547         require((newR + newT) == 10,"Less or more can damage the contract.");  //safety measure
548         _r = newR;
549         _t = newT;
550    }
551     
552 }