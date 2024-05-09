1 /**
2  *             __   __  __   __  _______  __   __  _______  ___ 
3  *            |  |_|  ||  | |  ||       ||  | |  ||  _    ||   |
4  *            |       ||  | |  ||  _____||  | |  || |_|   ||   |
5  *            |       ||  |_|  || |_____ |  |_|  ||       ||   |
6  *            |       ||       ||_____  ||       ||  _   | |   |
7  *            | ||_|| ||       | _____| ||       || |_|   ||   |
8  *            |_|   |_||_______||_______||_______||_______||___|
9  * MUSUBI
10  * https://t.me/musubi_token
11  * musubitoken.com
12  * twitter.com/MusubiToken
13  * 
14  * MUSUBI is a meme token with a twist!  
15  * MUSUBI has no sale limitations, which benefits whales and minnows alike, and an innovative dynamic reflection tax rate which increases proportionate to the size of the sell.
16  * 
17  * TOKENOMICS:
18  * 1,000,000,000,000 token supply
19  * FIRST TWO MINUTES: 3,000,000,000 max buy / 45-second buy cooldown (these limitations are lifted automatically two minutes post-launch)
20  * 15-second cooldown to sell after a buy, in order to limit bot behavior. NO OTHER COOLDOWNS, NO COOLDOWNS BETWEEN SELLS
21  * No buy or sell token limits. Whales are welcome!
22  * 10% total tax on buy
23  * Fee on sells is dynamic, relative to price impact, minimum of 10% fee and maximum of 40% fee, with NO SELL LIMIT.
24  * No team tokens, no presale
25  * A unique approach to resolving the huge dumps after long pumps that have plagued every NotInu fork
26  * 
27  * 
28 SPDX-License-Identifier: UNLICENSED 
29 */
30 pragma solidity ^0.8.4;
31 
32 abstract contract Context {
33     function _msgSender() internal view virtual returns (address) {
34         return msg.sender;
35     }
36 }
37 
38 interface IERC20 {
39     function totalSupply() external view returns (uint256);
40     function balanceOf(address account) external view returns (uint256);
41     function transfer(address recipient, uint256 amount) external returns (bool);
42     function allowance(address owner, address spender) external view returns (uint256);
43     function approve(address spender, uint256 amount) external returns (bool);
44     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
45     event Transfer(address indexed from, address indexed to, uint256 value);
46     event Approval(address indexed owner, address indexed spender, uint256 value);
47 }
48 
49 library SafeMath {
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a + b;
52         require(c >= a, "SafeMath: addition overflow");
53         return c;
54     }
55 
56     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
57         return sub(a, b, "SafeMath: subtraction overflow");
58     }
59 
60     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
61         require(b <= a, errorMessage);
62         uint256 c = a - b;
63         return c;
64     }
65 
66     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
67         if(a == 0) {
68             return 0;
69         }
70         uint256 c = a * b;
71         require(c / a == b, "SafeMath: multiplication overflow");
72         return c;
73     }
74 
75     function div(uint256 a, uint256 b) internal pure returns (uint256) {
76         return div(a, b, "SafeMath: division by zero");
77     }
78 
79     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
80         require(b > 0, errorMessage);
81         uint256 c = a / b;
82         return c;
83     }
84 
85     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
86         return mod(a, b, "SafeMath: modulo by zero");
87     }
88 
89     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
90         require(b != 0, errorMessage);
91         return a % b;
92     }
93 }
94 
95 contract Ownable is Context {
96     address private _owner;
97     address private _previousOwner;
98     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
99 
100     constructor () {
101         address msgSender = _msgSender();
102         _owner = msgSender;
103         emit OwnershipTransferred(address(0), msgSender);
104     }
105 
106     function owner() public view returns (address) {
107         return _owner;
108     }
109 
110     modifier onlyOwner() {
111         require(_owner == _msgSender(), "Ownable: caller is not the owner");
112         _;
113     }
114 
115     function renounceOwnership() public virtual onlyOwner {
116         emit OwnershipTransferred(_owner, address(0));
117         _owner = address(0);
118     }
119 
120 }  
121 
122 interface IUniswapV2Factory {
123     function createPair(address tokenA, address tokenB) external returns (address pair);
124 }
125 
126 interface IUniswapV2Router02 {
127     function swapExactTokensForETHSupportingFeeOnTransferTokens(
128         uint amountIn,
129         uint amountOutMin,
130         address[] calldata path,
131         address to,
132         uint deadline
133     ) external;
134     function factory() external pure returns (address);
135     function WETH() external pure returns (address);
136     function addLiquidityETH(
137         address token,
138         uint amountTokenDesired,
139         uint amountTokenMin,
140         uint amountETHMin,
141         address to,
142         uint deadline
143     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
144 }
145 
146 contract MUSUBI is Context, IERC20, Ownable {
147     using SafeMath for uint256;
148     mapping (address => uint256) private _rOwned;
149     mapping (address => uint256) private _tOwned;
150     mapping (address => mapping (address => uint256)) private _allowances;
151     mapping (address => bool) private _isExcludedFromFee;
152     mapping (address => User) private cooldown;
153     uint256 private constant MAX = ~uint256(0);
154     uint256 private constant _tTotal = 1e12 * 10**9;
155     uint256 private _rTotal = (MAX - (MAX % _tTotal));
156     uint256 private _tFeeTotal;
157     string private constant _name = unicode"Musubi";
158     string private constant _symbol = unicode"MUSUBI";
159     uint8 private constant _decimals = 9;
160     uint256 private _taxFee = 6;
161     uint256 private _teamFee = 4;
162     uint256 private _feeRate = 5;
163     uint256 private _feeMultiplier = 1000;
164     uint256 private _launchTime;
165     uint256 private _previousTaxFee = _taxFee;
166     uint256 private _previousteamFee = _teamFee;
167     uint256 private _maxBuyAmount;
168     address payable private _FeeAddress;
169     address payable private _marketingWalletAddress;
170     IUniswapV2Router02 private uniswapV2Router;
171     address private uniswapV2Pair;
172     bool private tradingOpen;
173     bool private _cooldownEnabled = true;
174     bool private inSwap = false;
175     bool private _useImpactFeeSetter = true;
176     uint256 private buyLimitEnd;
177     struct User {
178         uint256 buy;
179         uint256 sell;
180         bool exists;
181     }
182 
183     event MaxBuyAmountUpdated(uint _maxBuyAmount);
184     event CooldownEnabledUpdated(bool _cooldown);
185     event FeeMultiplierUpdated(uint _multiplier);
186     event FeeRateUpdated(uint _rate);
187 
188     modifier lockTheSwap {
189         inSwap = true;
190         _;
191         inSwap = false;
192     }
193     constructor (address payable FeeAddress, address payable marketingWalletAddress) {
194         _FeeAddress = FeeAddress;
195         _marketingWalletAddress = marketingWalletAddress;
196         _rOwned[_msgSender()] = _rTotal;
197         _isExcludedFromFee[owner()] = true;
198         _isExcludedFromFee[address(this)] = true;
199         _isExcludedFromFee[FeeAddress] = true;
200         _isExcludedFromFee[marketingWalletAddress] = true;
201         emit Transfer(address(0), _msgSender(), _tTotal);
202     }
203 
204     function name() public pure returns (string memory) {
205         return _name;
206     }
207 
208     function symbol() public pure returns (string memory) {
209         return _symbol;
210     }
211 
212     function decimals() public pure returns (uint8) {
213         return _decimals;
214     }
215 
216     function totalSupply() public pure override returns (uint256) {
217         return _tTotal;
218     }
219 
220     function balanceOf(address account) public view override returns (uint256) {
221         return tokenFromReflection(_rOwned[account]);
222     }
223 
224     function transfer(address recipient, uint256 amount) public override returns (bool) {
225         _transfer(_msgSender(), recipient, amount);
226         return true;
227     }
228 
229     function allowance(address owner, address spender) public view override returns (uint256) {
230         return _allowances[owner][spender];
231     }
232 
233     function approve(address spender, uint256 amount) public override returns (bool) {
234         _approve(_msgSender(), spender, amount);
235         return true;
236     }
237 
238     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
239         _transfer(sender, recipient, amount);
240         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
241         return true;
242     }
243 
244     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
245         require(rAmount <= _rTotal, "Amount must be less than total reflections");
246         uint256 currentRate =  _getRate();
247         return rAmount.div(currentRate);
248     }
249 
250     function removeAllFee() private {
251         if(_taxFee == 0 && _teamFee == 0) return;
252         _previousTaxFee = _taxFee;
253         _previousteamFee = _teamFee;
254         _taxFee = 0;
255         _teamFee = 0;
256     }
257     
258     function restoreAllFee() private {
259         _taxFee = _previousTaxFee;
260         _teamFee = _previousteamFee;
261     }
262 
263     function setFee(uint256 impactFee) private {
264         uint256 _impactFee = 10;
265         if(impactFee < 10) {
266             _impactFee = 10;
267         } else if(impactFee > 40) {
268             _impactFee = 40;
269         } else {
270             _impactFee = impactFee;
271         }
272         if(_impactFee.mod(2) != 0) {
273             _impactFee++;
274         }
275         _taxFee = (_impactFee.mul(6)).div(10);
276         _teamFee = (_impactFee.mul(4)).div(10);
277     }
278 
279     function _approve(address owner, address spender, uint256 amount) private {
280         require(owner != address(0), "ERC20: approve from the zero address");
281         require(spender != address(0), "ERC20: approve to the zero address");
282         _allowances[owner][spender] = amount;
283         emit Approval(owner, spender, amount);
284     }
285 
286     function _transfer(address from, address to, uint256 amount) private {
287         require(from != address(0), "ERC20: transfer from the zero address");
288         require(to != address(0), "ERC20: transfer to the zero address");
289         require(amount > 0, "Transfer amount must be greater than zero");
290 
291         if(from != owner() && to != owner()) {
292             if(_cooldownEnabled) {
293                 if(!cooldown[msg.sender].exists) {
294                     cooldown[msg.sender] = User(0,0,true);
295                 }
296             }
297 
298             // buy
299             if(from == uniswapV2Pair && to != address(uniswapV2Router) && !_isExcludedFromFee[to]) {
300                 require(tradingOpen, "Trading not yet enabled.");
301                 _taxFee = 6;
302                 _teamFee = 4;
303                 if(_cooldownEnabled) {
304                     if(buyLimitEnd > block.timestamp) {
305                         require(amount <= _maxBuyAmount);
306                         require(cooldown[to].buy < block.timestamp, "Your buy cooldown has not expired.");
307                         cooldown[to].buy = block.timestamp + (45 seconds);
308                     }
309                 }
310                 if(_cooldownEnabled) {
311                     cooldown[to].sell = block.timestamp + (15 seconds);
312                 }
313             }
314             uint256 contractTokenBalance = balanceOf(address(this));
315 
316             // sell
317             if(!inSwap && from != uniswapV2Pair && tradingOpen) {
318 
319                 if(_cooldownEnabled) {
320                     require(cooldown[from].sell < block.timestamp, "Your sell cooldown has not expired.");
321                 }
322 
323                 if(_useImpactFeeSetter) {
324                     uint256 feeBasis = amount.mul(_feeMultiplier);
325                     feeBasis = feeBasis.div(balanceOf(uniswapV2Pair).add(amount));
326                     setFee(feeBasis);
327                 }
328 
329                 if(contractTokenBalance > 0) {
330                     if(contractTokenBalance > balanceOf(uniswapV2Pair).mul(_feeRate).div(100)) {
331                         contractTokenBalance = balanceOf(uniswapV2Pair).mul(_feeRate).div(100);
332                     }
333                     swapTokensForEth(contractTokenBalance);
334                 }
335                 uint256 contractETHBalance = address(this).balance;
336                 if(contractETHBalance > 0) {
337                     sendETHToFee(address(this).balance);
338                 }
339             }
340         }
341         bool takeFee = true;
342 
343         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
344             takeFee = false;
345         }
346         
347         _tokenTransfer(from,to,amount,takeFee);
348     }
349 
350     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
351         address[] memory path = new address[](2);
352         path[0] = address(this);
353         path[1] = uniswapV2Router.WETH();
354         _approve(address(this), address(uniswapV2Router), tokenAmount);
355         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
356             tokenAmount,
357             0,
358             path,
359             address(this),
360             block.timestamp
361         );
362     }
363         
364     function sendETHToFee(uint256 amount) private {
365         _FeeAddress.transfer(amount.div(2));
366         _marketingWalletAddress.transfer(amount.div(2));
367     }
368     
369     function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
370         if(!takeFee)
371             removeAllFee();
372         _transferStandard(sender, recipient, amount);
373         if(!takeFee)
374             restoreAllFee();
375     }
376 
377     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
378         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
379         _rOwned[sender] = _rOwned[sender].sub(rAmount);
380         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
381 
382         _takeTeam(tTeam);
383         _reflectFee(rFee, tFee);
384         emit Transfer(sender, recipient, tTransferAmount);
385     }
386 
387     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
388         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _taxFee, _teamFee);
389         uint256 currentRate =  _getRate();
390         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
391         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
392     }
393 
394     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
395         uint256 tFee = tAmount.mul(taxFee).div(100);
396         uint256 tTeam = tAmount.mul(TeamFee).div(100);
397         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
398         return (tTransferAmount, tFee, tTeam);
399     }
400 
401     function _getRate() private view returns(uint256) {
402         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
403         return rSupply.div(tSupply);
404     }
405 
406     function _getCurrentSupply() private view returns(uint256, uint256) {
407         uint256 rSupply = _rTotal;
408         uint256 tSupply = _tTotal;
409         if(rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
410         return (rSupply, tSupply);
411     }
412 
413     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
414         uint256 rAmount = tAmount.mul(currentRate);
415         uint256 rFee = tFee.mul(currentRate);
416         uint256 rTeam = tTeam.mul(currentRate);
417         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
418         return (rAmount, rTransferAmount, rFee);
419     }
420 
421     function _takeTeam(uint256 tTeam) private {
422         uint256 currentRate =  _getRate();
423         uint256 rTeam = tTeam.mul(currentRate);
424 
425         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
426     }
427 
428     function _reflectFee(uint256 rFee, uint256 tFee) private {
429         _rTotal = _rTotal.sub(rFee);
430         _tFeeTotal = _tFeeTotal.add(tFee);
431     }
432 
433     receive() external payable {}
434     
435     function addLiquidity() external onlyOwner() {
436         require(!tradingOpen,"trading is already open");
437         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
438         uniswapV2Router = _uniswapV2Router;
439         _approve(address(this), address(uniswapV2Router), _tTotal);
440         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
441         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
442         _maxBuyAmount = 3000000000 * 10**9;
443         _launchTime = block.timestamp;
444         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
445     }
446 
447     function openTrading() public onlyOwner {
448         tradingOpen = true;
449         buyLimitEnd = block.timestamp + (120 seconds);
450     }
451 
452     function manualswap() external {
453         require(_msgSender() == _FeeAddress);
454         uint256 contractBalance = balanceOf(address(this));
455         swapTokensForEth(contractBalance);
456     }
457     
458     function manualsend() external {
459         require(_msgSender() == _FeeAddress);
460         uint256 contractETHBalance = address(this).balance;
461         sendETHToFee(contractETHBalance);
462     }
463 
464     // fallback in case contract is not releasing tokens fast enough
465     function setFeeRate(uint256 rate) external {
466         require(_msgSender() == _FeeAddress);
467         require(rate < 51, "Rate can't exceed 50%");
468         _feeRate = rate;
469         emit FeeRateUpdated(_feeRate);
470     }
471 
472     function setCooldownEnabled(bool onoff) external onlyOwner() {
473         _cooldownEnabled = onoff;
474         emit CooldownEnabledUpdated(_cooldownEnabled);
475     }
476 
477     function thisBalance() public view returns (uint) {
478         return balanceOf(address(this));
479     }
480 
481     function cooldownEnabled() public view returns (bool) {
482         return _cooldownEnabled;
483     }
484 
485     function timeToBuy(address buyer) public view returns (uint) {
486         return block.timestamp - cooldown[buyer].buy;
487     }
488 
489     function timeToSell(address buyer) public view returns (uint) {
490         return block.timestamp - cooldown[buyer].sell;
491     }
492 
493     function amountInPool() public view returns (uint) {
494         return balanceOf(uniswapV2Pair);
495     }
496 }