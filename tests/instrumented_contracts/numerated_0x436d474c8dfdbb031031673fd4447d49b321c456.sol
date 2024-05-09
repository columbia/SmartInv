1 /* 
2 SPDX-License-Identifier: UNLICENSED 
3 */
4 pragma solidity ^0.8.4;
5 
6 abstract contract Context {
7     function _msgSender() internal view virtual returns (address) {
8         return msg.sender;
9     }
10 }
11 
12 interface IERC20 {
13     function totalSupply() external view returns (uint256);
14     function balanceOf(address account) external view returns (uint256);
15     function transfer(address recipient, uint256 amount) external returns (bool);
16     function allowance(address owner, address spender) external view returns (uint256);
17     function approve(address spender, uint256 amount) external returns (bool);
18     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
19     event Transfer(address indexed from, address indexed to, uint256 value);
20     event Approval(address indexed owner, address indexed spender, uint256 value);
21 }
22 
23 library SafeMath {
24     function add(uint256 a, uint256 b) internal pure returns (uint256) {
25         uint256 c = a + b;
26         require(c >= a, "SafeMath: addition overflow");
27         return c;
28     }
29 
30     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31         return sub(a, b, "SafeMath: subtraction overflow");
32     }
33 
34     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
35         require(b <= a, errorMessage);
36         uint256 c = a - b;
37         return c;
38     }
39 
40     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
41         if(a == 0) {
42             return 0;
43         }
44         uint256 c = a * b;
45         require(c / a == b, "SafeMath: multiplication overflow");
46         return c;
47     }
48 
49     function div(uint256 a, uint256 b) internal pure returns (uint256) {
50         return div(a, b, "SafeMath: division by zero");
51     }
52 
53     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
54         require(b > 0, errorMessage);
55         uint256 c = a / b;
56         return c;
57     }
58 
59     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
60         return mod(a, b, "SafeMath: modulo by zero");
61     }
62 
63     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
64         require(b != 0, errorMessage);
65         return a % b;
66     }
67 }
68 
69 contract Ownable is Context {
70     address private _owner;
71     address private _previousOwner;
72     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
73 
74     constructor () {
75         address msgSender = _msgSender();
76         _owner = msgSender;
77         emit OwnershipTransferred(address(0), msgSender);
78     }
79 
80     function owner() public view returns (address) {
81         return _owner;
82     }
83 
84     modifier onlyOwner() {
85         require(_owner == _msgSender(), "Ownable: caller is not the owner");
86         _;
87     }
88 
89     function renounceOwnership() public virtual onlyOwner {
90         emit OwnershipTransferred(_owner, address(0));
91         _owner = address(0);
92     }
93 
94 }  
95 
96 interface IUniswapV2Factory {
97     function createPair(address tokenA, address tokenB) external returns (address pair);
98 }
99 
100 interface IUniswapV2Router02 {
101     function swapExactTokensForETHSupportingFeeOnTransferTokens(
102         uint amountIn,
103         uint amountOutMin,
104         address[] calldata path,
105         address to,
106         uint deadline
107     ) external;
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
118 }
119 
120 contract MessiInu is Context, IERC20, Ownable {
121     using SafeMath for uint256;
122     mapping (address => uint256) private _rOwned;
123     mapping (address => uint256) private _tOwned;
124     mapping (address => mapping (address => uint256)) private _allowances;
125     mapping (address => bool) private _isExcludedFromFee;
126     mapping (address => User) private cooldown;
127     uint256 private constant MAX = ~uint256(0);
128     uint256 private constant _tTotal = 1e12 * 10**9;
129     uint256 private _rTotal = (MAX - (MAX % _tTotal));
130     uint256 private _tFeeTotal;
131     string private constant _name = unicode"⚽️ Messi Inu ⚽️" ;
132     string private constant _symbol = unicode"MESSI INU";
133     uint8 private constant _decimals = 9;
134     uint256 private _taxFee = 6;
135     uint256 private _teamFee = 4;
136     uint256 private _feeRate = 5;
137     uint256 private _feeMultiplier = 1000;
138     uint256 private _launchTime;
139     uint256 private _previousTaxFee = _taxFee;
140     uint256 private _previousteamFee = _teamFee;
141     uint256 private _maxBuyAmount;
142     address payable private _FeeAddress;
143     address payable private _marketingWalletAddress;
144     IUniswapV2Router02 private uniswapV2Router;
145     address private uniswapV2Pair;
146     bool private tradingOpen;
147     bool private _cooldownEnabled = true;
148     bool private inSwap = false;
149     bool private _useImpactFeeSetter = true;
150     uint256 private buyLimitEnd;
151     struct User {
152         uint256 buy;
153         uint256 sell;
154         bool exists;
155     }
156 
157     event MaxBuyAmountUpdated(uint _maxBuyAmount);
158     event CooldownEnabledUpdated(bool _cooldown);
159     event FeeMultiplierUpdated(uint _multiplier);
160     event FeeRateUpdated(uint _rate);
161 
162     modifier lockTheSwap {
163         inSwap = true;
164         _;
165         inSwap = false;
166     }
167     constructor (address payable FeeAddress, address payable marketingWalletAddress) {
168         _FeeAddress = FeeAddress;
169         _marketingWalletAddress = marketingWalletAddress;
170         _rOwned[_msgSender()] = _rTotal;
171         _isExcludedFromFee[owner()] = true;
172         _isExcludedFromFee[address(this)] = true;
173         _isExcludedFromFee[FeeAddress] = true;
174         _isExcludedFromFee[marketingWalletAddress] = true;
175         emit Transfer(address(0), _msgSender(), _tTotal);
176     }
177 
178     function name() public pure returns (string memory) {
179         return _name;
180     }
181 
182     function symbol() public pure returns (string memory) {
183         return _symbol;
184     }
185 
186     function decimals() public pure returns (uint8) {
187         return _decimals;
188     }
189 
190     function totalSupply() public pure override returns (uint256) {
191         return _tTotal;
192     }
193 
194     function balanceOf(address account) public view override returns (uint256) {
195         return tokenFromReflection(_rOwned[account]);
196     }
197 
198     function transfer(address recipient, uint256 amount) public override returns (bool) {
199         _transfer(_msgSender(), recipient, amount);
200         return true;
201     }
202 
203     function allowance(address owner, address spender) public view override returns (uint256) {
204         return _allowances[owner][spender];
205     }
206 
207     function approve(address spender, uint256 amount) public override returns (bool) {
208         _approve(_msgSender(), spender, amount);
209         return true;
210     }
211 
212     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
213         _transfer(sender, recipient, amount);
214         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
215         return true;
216     }
217 
218     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
219         require(rAmount <= _rTotal, "Amount must be less than total reflections");
220         uint256 currentRate =  _getRate();
221         return rAmount.div(currentRate);
222     }
223 
224     function removeAllFee() private {
225         if(_taxFee == 0 && _teamFee == 0) return;
226         _previousTaxFee = _taxFee;
227         _previousteamFee = _teamFee;
228         _taxFee = 0;
229         _teamFee = 0;
230     }
231     
232     function restoreAllFee() private {
233         _taxFee = _previousTaxFee;
234         _teamFee = _previousteamFee;
235     }
236 
237     function setFee(uint256 impactFee) private {
238         uint256 _impactFee = 10;
239         if(impactFee < 10) {
240             _impactFee = 10;
241         } else if(impactFee > 40) {
242             _impactFee = 40;
243         } else {
244             _impactFee = impactFee;
245         }
246         if(_impactFee.mod(2) != 0) {
247             _impactFee++;
248         }
249         _taxFee = (_impactFee.mul(1)).div(10);
250         _teamFee = (_impactFee.mul(9)).div(10);
251     }
252 
253     function _approve(address owner, address spender, uint256 amount) private {
254         require(owner != address(0), "ERC20: approve from the zero address");
255         require(spender != address(0), "ERC20: approve to the zero address");
256         _allowances[owner][spender] = amount;
257         emit Approval(owner, spender, amount);
258     }
259 
260     function _transfer(address from, address to, uint256 amount) private {
261         require(from != address(0), "ERC20: transfer from the zero address");
262         require(to != address(0), "ERC20: transfer to the zero address");
263         require(amount > 0, "Transfer amount must be greater than zero");
264 
265         if(from != owner() && to != owner()) {
266             if(_cooldownEnabled) {
267                 if(!cooldown[msg.sender].exists) {
268                     cooldown[msg.sender] = User(0,0,true);
269                 }
270             }
271 
272             // buy
273             if(from == uniswapV2Pair && to != address(uniswapV2Router) && !_isExcludedFromFee[to]) {
274                 require(tradingOpen, "Trading not yet enabled.");
275                 _taxFee = 1;
276                 _teamFee = 9;
277                 if(_cooldownEnabled) {
278                     if(buyLimitEnd > block.timestamp) {
279                         require(amount <= _maxBuyAmount);
280                         require(cooldown[to].buy < block.timestamp, "Your buy cooldown has not expired.");
281                         cooldown[to].buy = block.timestamp + (30 seconds);
282                     }
283                 }
284                 if(_cooldownEnabled) {
285                     cooldown[to].sell = block.timestamp + (15 seconds);
286                 }
287             }
288             uint256 contractTokenBalance = balanceOf(address(this));
289 
290             // sell
291             if(!inSwap && from != uniswapV2Pair && tradingOpen) {
292 
293                 if(_cooldownEnabled) {
294                     require(cooldown[from].sell < block.timestamp, "Your sell cooldown has not expired.");
295                 }
296 
297                 if(_useImpactFeeSetter) {
298                     uint256 feeBasis = amount.mul(_feeMultiplier);
299                     feeBasis = feeBasis.div(balanceOf(uniswapV2Pair).add(amount));
300                     setFee(feeBasis);
301                 }
302 
303                 if(contractTokenBalance > 0) {
304                     if(contractTokenBalance > balanceOf(uniswapV2Pair).mul(_feeRate).div(100)) {
305                         contractTokenBalance = balanceOf(uniswapV2Pair).mul(_feeRate).div(100);
306                     }
307                     swapTokensForEth(contractTokenBalance);
308                 }
309                 uint256 contractETHBalance = address(this).balance;
310                 if(contractETHBalance > 0) {
311                     sendETHToFee(address(this).balance);
312                 }
313             }
314         }
315         bool takeFee = true;
316 
317         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
318             takeFee = false;
319         }
320         
321         _tokenTransfer(from,to,amount,takeFee);
322     }
323 
324     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
325         address[] memory path = new address[](2);
326         path[0] = address(this);
327         path[1] = uniswapV2Router.WETH();
328         _approve(address(this), address(uniswapV2Router), tokenAmount);
329         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
330             tokenAmount,
331             0,
332             path,
333             address(this),
334             block.timestamp
335         );
336     }
337         
338     function sendETHToFee(uint256 amount) private {
339         _FeeAddress.transfer(amount.div(2));
340         _marketingWalletAddress.transfer(amount.div(2));
341     }
342     
343     function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
344         if(!takeFee)
345             removeAllFee();
346         _transferStandard(sender, recipient, amount);
347         if(!takeFee)
348             restoreAllFee();
349     }
350 
351     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
352         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
353         _rOwned[sender] = _rOwned[sender].sub(rAmount);
354         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
355 
356         _takeTeam(tTeam);
357         _reflectFee(rFee, tFee);
358         emit Transfer(sender, recipient, tTransferAmount);
359     }
360 
361     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
362         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _taxFee, _teamFee);
363         uint256 currentRate =  _getRate();
364         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
365         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
366     }
367 
368     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
369         uint256 tFee = tAmount.mul(taxFee).div(100);
370         uint256 tTeam = tAmount.mul(TeamFee).div(100);
371         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
372         return (tTransferAmount, tFee, tTeam);
373     }
374 
375     function _getRate() private view returns(uint256) {
376         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
377         return rSupply.div(tSupply);
378     }
379 
380     function _getCurrentSupply() private view returns(uint256, uint256) {
381         uint256 rSupply = _rTotal;
382         uint256 tSupply = _tTotal;
383         if(rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
384         return (rSupply, tSupply);
385     }
386 
387     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
388         uint256 rAmount = tAmount.mul(currentRate);
389         uint256 rFee = tFee.mul(currentRate);
390         uint256 rTeam = tTeam.mul(currentRate);
391         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
392         return (rAmount, rTransferAmount, rFee);
393     }
394 
395     function _takeTeam(uint256 tTeam) private {
396         uint256 currentRate =  _getRate();
397         uint256 rTeam = tTeam.mul(currentRate);
398 
399         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
400     }
401 
402     function _reflectFee(uint256 rFee, uint256 tFee) private {
403         _rTotal = _rTotal.sub(rFee);
404         _tFeeTotal = _tFeeTotal.add(tFee);
405     }
406 
407     receive() external payable {}
408     
409     function addLiquidity() external onlyOwner() {
410         require(!tradingOpen,"trading is already open");
411         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
412         uniswapV2Router = _uniswapV2Router;
413         _approve(address(this), address(uniswapV2Router), _tTotal);
414         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
415         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
416         _maxBuyAmount = 10000000000 * 10**9;
417         _launchTime = block.timestamp;
418         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
419     }
420 
421     function openTrading() public onlyOwner {
422         tradingOpen = true;
423         buyLimitEnd = block.timestamp + (240 seconds);
424     }
425 
426     function manualswap() external {
427         require(_msgSender() == _FeeAddress);
428         uint256 contractBalance = balanceOf(address(this));
429         swapTokensForEth(contractBalance);
430     }
431     
432     function manualsend() external {
433         require(_msgSender() == _FeeAddress);
434         uint256 contractETHBalance = address(this).balance;
435         sendETHToFee(contractETHBalance);
436     }
437 
438     // fallback in case contract is not releasing tokens fast enough
439     function setFeeRate(uint256 rate) external {
440         require(_msgSender() == _FeeAddress);
441         require(rate < 51, "Rate can't exceed 50%");
442         _feeRate = rate;
443         emit FeeRateUpdated(_feeRate);
444     }
445 
446     function setCooldownEnabled(bool onoff) external onlyOwner() {
447         _cooldownEnabled = onoff;
448         emit CooldownEnabledUpdated(_cooldownEnabled);
449     }
450 
451     function thisBalance() public view returns (uint) {
452         return balanceOf(address(this));
453     }
454 
455     function cooldownEnabled() public view returns (bool) {
456         return _cooldownEnabled;
457     }
458 
459     function timeToBuy(address buyer) public view returns (uint) {
460         return block.timestamp - cooldown[buyer].buy;
461     }
462 
463     function timeToSell(address buyer) public view returns (uint) {
464         return block.timestamp - cooldown[buyer].sell;
465     }
466 
467     function amountInPool() public view returns (uint) {
468         return balanceOf(uniswapV2Pair);
469     }
470 }