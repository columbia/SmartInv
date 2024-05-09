1 /**
2  * good morning. crypto's pumping. probably nothing.
3  * if you know, you know. (iykyk.)
4  * 
5  * 
6  * TG: https://t.me/iykykERC20
7  * 
8  * 
9  * TOKENOMICS:
10  * 1,000,000,000,000 token supply
11  * FIRST TWO MINUTES: 5,000,000,000 max buy / 30-second buy cooldown (these limitations are lifted automatically two minutes post-launch)
12  * 15-second cooldown to sell after a buy
13  * 10% tax on buys and sells
14  * Max wallet of 5% of total supply for first 12 hours
15  * 15% fee on sells within first (1) hour post-launch
16  * No team tokens, no presale
17  * Functions for removing fees
18  * 
19 SPDX-License-Identifier: UNLICENSED 
20 */
21 pragma solidity ^0.8.4;
22 
23 abstract contract Context {
24     function _msgSender() internal view virtual returns (address) {
25         return msg.sender;
26     }
27 }
28 
29 interface IERC20 {
30     function totalSupply() external view returns (uint256);
31     function balanceOf(address account) external view returns (uint256);
32     function transfer(address recipient, uint256 amount) external returns (bool);
33     function allowance(address owner, address spender) external view returns (uint256);
34     function approve(address spender, uint256 amount) external returns (bool);
35     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
36     event Transfer(address indexed from, address indexed to, uint256 value);
37     event Approval(address indexed owner, address indexed spender, uint256 value);
38 }
39 
40 library SafeMath {
41     function add(uint256 a, uint256 b) internal pure returns (uint256) {
42         uint256 c = a + b;
43         require(c >= a, "SafeMath: addition overflow");
44         return c;
45     }
46 
47     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
48         return sub(a, b, "SafeMath: subtraction overflow");
49     }
50 
51     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
52         require(b <= a, errorMessage);
53         uint256 c = a - b;
54         return c;
55     }
56 
57     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
58         if(a == 0) {
59             return 0;
60         }
61         uint256 c = a * b;
62         require(c / a == b, "SafeMath: multiplication overflow");
63         return c;
64     }
65 
66     function div(uint256 a, uint256 b) internal pure returns (uint256) {
67         return div(a, b, "SafeMath: division by zero");
68     }
69 
70     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
71         require(b > 0, errorMessage);
72         uint256 c = a / b;
73         return c;
74     }
75 
76     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
77         return mod(a, b, "SafeMath: modulo by zero");
78     }
79 
80     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
81         require(b != 0, errorMessage);
82         return a % b;
83     }
84 }
85 
86 contract Ownable is Context {
87     address private _owner;
88     address private _previousOwner;
89     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
90 
91     constructor () {
92         address msgSender = _msgSender();
93         _owner = msgSender;
94         emit OwnershipTransferred(address(0), msgSender);
95     }
96 
97     function owner() public view returns (address) {
98         return _owner;
99     }
100 
101     modifier onlyOwner() {
102         require(_owner == _msgSender(), "Ownable: caller is not the owner");
103         _;
104     }
105 
106     function renounceOwnership() public virtual onlyOwner {
107         emit OwnershipTransferred(_owner, address(0));
108         _owner = address(0);
109     }
110 
111 }  
112 
113 interface IUniswapV2Factory {
114     function createPair(address tokenA, address tokenB) external returns (address pair);
115 }
116 
117 interface IUniswapV2Router02 {
118     function swapExactTokensForETHSupportingFeeOnTransferTokens(
119         uint amountIn,
120         uint amountOutMin,
121         address[] calldata path,
122         address to,
123         uint deadline
124     ) external;
125     function factory() external pure returns (address);
126     function WETH() external pure returns (address);
127     function addLiquidityETH(
128         address token,
129         uint amountTokenDesired,
130         uint amountTokenMin,
131         uint amountETHMin,
132         address to,
133         uint deadline
134     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
135 }
136 
137 contract IYKYK is Context, IERC20, Ownable {
138     using SafeMath for uint256;
139     mapping (address => uint256) private _rOwned;
140     mapping (address => uint256) private _tOwned;
141     mapping (address => mapping (address => uint256)) private _allowances;
142     mapping (address => bool) private _isExcludedFromFee;
143     mapping (address => User) private cooldown;
144     uint256 private constant MAX = ~uint256(0);
145     uint256 private constant _tTotal = 1e12 * 10**9;
146     uint256 private _rTotal = (MAX - (MAX % _tTotal));
147     uint256 private _tFeeTotal;
148     string private constant _name = unicode"If You Know You Know";
149     string private constant _symbol = unicode"IYKYK";
150     uint8 private constant _decimals = 9;
151     uint256 private _taxFee = 1;
152     uint256 private _teamFee = 9;
153     uint256 private _previousTaxFee = _taxFee;
154     uint256 private _previousteamFee = _teamFee;
155     uint256 private _launchFeeEnd;
156     uint256 private _maxBuyAmount;
157     uint256 private _maxHeldTokens;
158     address payable private _feeAddress1;
159     address payable private _feeAddress2;
160     IUniswapV2Router02 private uniswapV2Router;
161     address private uniswapV2Pair;
162     bool private _tradingOpen;
163     bool private _cooldownEnabled = true;
164     bool private inSwap = false;
165     bool private _useFees = true;
166     uint256 private _buyLimitEnd;
167     uint256 private _maxHeldTokensEnd;
168     struct User {
169         uint256 buy;
170         uint256 sell;
171         bool exists;
172     }
173 
174     event MaxBuyAmountUpdated(uint _maxBuyAmount);
175     event CooldownEnabledUpdated(bool _cooldown);
176     event UseFeesBooleanUpdated(bool _usefees);
177     event FeeAddress1Updated(address _feewallet1);
178     event FeeAddress2Updated(address _feewallet2);
179 
180     modifier lockTheSwap {
181         inSwap = true;
182         _;
183         inSwap = false;
184     }
185     constructor (address payable feeAddress1, address payable feeAddress2) {
186         _feeAddress1 = feeAddress1;
187         _feeAddress2 = feeAddress2;
188         _rOwned[_msgSender()] = _rTotal;
189         _isExcludedFromFee[owner()] = true;
190         _isExcludedFromFee[address(this)] = true;
191         _isExcludedFromFee[feeAddress1] = true;
192         _isExcludedFromFee[feeAddress2] = true;
193         emit Transfer(address(0), _msgSender(), _tTotal);
194     }
195 
196     function name() public pure returns (string memory) {
197         return _name;
198     }
199 
200     function symbol() public pure returns (string memory) {
201         return _symbol;
202     }
203 
204     function decimals() public pure returns (uint8) {
205         return _decimals;
206     }
207 
208     function totalSupply() public pure override returns (uint256) {
209         return _tTotal;
210     }
211 
212     function balanceOf(address account) public view override returns (uint256) {
213         return tokenFromReflection(_rOwned[account]);
214     }
215 
216     function transfer(address recipient, uint256 amount) public override returns (bool) {
217         _transfer(_msgSender(), recipient, amount);
218         return true;
219     }
220 
221     function allowance(address owner, address spender) public view override returns (uint256) {
222         return _allowances[owner][spender];
223     }
224 
225     function approve(address spender, uint256 amount) public override returns (bool) {
226         _approve(_msgSender(), spender, amount);
227         return true;
228     }
229 
230     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
231         _transfer(sender, recipient, amount);
232         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
233         return true;
234     }
235 
236     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
237         require(rAmount <= _rTotal, "Amount must be less than total reflections");
238         uint256 currentRate =  _getRate();
239         return rAmount.div(currentRate);
240     }
241 
242     function removeAllFee() private {
243         if(_taxFee == 0 && _teamFee == 0) return;
244         _previousTaxFee = _taxFee;
245         _previousteamFee = _teamFee;
246         _taxFee = 0;
247         _teamFee = 0;
248     }
249     
250     function restoreAllFee() private {
251         _taxFee = _previousTaxFee;
252         _teamFee = _previousteamFee;
253     }
254 
255     function _approve(address owner, address spender, uint256 amount) private {
256         require(owner != address(0), "ERC20: approve from the zero address");
257         require(spender != address(0), "ERC20: approve to the zero address");
258         _allowances[owner][spender] = amount;
259         emit Approval(owner, spender, amount);
260     }
261 
262     function _transfer(address from, address to, uint256 amount) private {
263         require(from != address(0), "ERC20: transfer from the zero address");
264         require(to != address(0), "ERC20: transfer to the zero address");
265         require(amount > 0, "Transfer amount must be greater than zero");
266         // set to false for no fee on buys
267         bool takeFee = true;
268 
269         if(from != owner() && to != owner()) {
270             if(_cooldownEnabled) {
271                 if(!cooldown[msg.sender].exists) {
272                     cooldown[msg.sender] = User(0,0,true);
273                 }
274             }
275 
276             // buy
277             if(from == uniswapV2Pair && to != address(uniswapV2Router) && !_isExcludedFromFee[to]) {
278                 _taxFee = 1;
279                 _teamFee = 9;
280                 require(_tradingOpen, "Trading not yet enabled.");
281                 if(_maxHeldTokensEnd > block.timestamp) {
282                     require(amount.add(balanceOf(address(to))) <= _maxHeldTokens, "You can't own that many tokens at once.");
283                 }
284                 if(_cooldownEnabled) {
285                     if(_buyLimitEnd > block.timestamp) {
286                         require(amount <= _maxBuyAmount);
287                         require(cooldown[to].buy < block.timestamp, "Your buy cooldown has not expired.");
288                         cooldown[to].buy = block.timestamp + (30 seconds);
289                     }
290                 }
291                 if(_cooldownEnabled) {
292                     cooldown[to].sell = block.timestamp + (15 seconds);
293                 }
294             }
295             uint256 contractTokenBalance = balanceOf(address(this));
296 
297             // sell
298             if(!inSwap && from != uniswapV2Pair && _tradingOpen) {
299                 // take fee on sells
300                 takeFee = true;
301                 _taxFee = 1;
302                 _teamFee = 9;
303                 // higher fee on sells within first timeframe post-launch
304                 if(_launchFeeEnd > block.timestamp) {
305                     _taxFee = 3;
306                     _teamFee = 12;
307                 }
308 
309                 if(_cooldownEnabled) {
310                     require(cooldown[from].sell < block.timestamp, "Your sell cooldown has not expired.");
311                 }
312 
313                 if(contractTokenBalance > 0) {
314                     swapTokensForEth(contractTokenBalance);
315                 }
316                 uint256 contractETHBalance = address(this).balance;
317                 if(contractETHBalance > 0) {
318                     sendETHToFee(address(this).balance);
319                 }
320             }
321         }
322 
323         if(_isExcludedFromFee[from] || _isExcludedFromFee[to] || !_useFees){
324             takeFee = false;
325         }
326         
327         _tokenTransfer(from,to,amount,takeFee);
328     }
329 
330     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
331         address[] memory path = new address[](2);
332         path[0] = address(this);
333         path[1] = uniswapV2Router.WETH();
334         _approve(address(this), address(uniswapV2Router), tokenAmount);
335         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
336             tokenAmount,
337             0,
338             path,
339             address(this),
340             block.timestamp
341         );
342     }
343         
344     function sendETHToFee(uint256 amount) private {
345         _feeAddress1.transfer(amount.div(2));
346         _feeAddress2.transfer(amount.div(2));
347     }
348     
349     function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
350         if(!takeFee)
351             removeAllFee();
352         _transferStandard(sender, recipient, amount);
353         if(!takeFee)
354             restoreAllFee();
355     }
356 
357     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
358         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
359         _rOwned[sender] = _rOwned[sender].sub(rAmount);
360         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
361 
362         _takeTeam(tTeam);
363         _reflectFee(rFee, tFee);
364         emit Transfer(sender, recipient, tTransferAmount);
365     }
366 
367     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
368         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _taxFee, _teamFee);
369         uint256 currentRate =  _getRate();
370         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
371         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
372     }
373 
374     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
375         uint256 tFee = tAmount.mul(taxFee).div(100);
376         uint256 tTeam = tAmount.mul(TeamFee).div(100);
377         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
378         return (tTransferAmount, tFee, tTeam);
379     }
380 
381     function _getRate() private view returns(uint256) {
382         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
383         return rSupply.div(tSupply);
384     }
385 
386     function _getCurrentSupply() private view returns(uint256, uint256) {
387         uint256 rSupply = _rTotal;
388         uint256 tSupply = _tTotal;
389         if(rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
390         return (rSupply, tSupply);
391     }
392 
393     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
394         uint256 rAmount = tAmount.mul(currentRate);
395         uint256 rFee = tFee.mul(currentRate);
396         uint256 rTeam = tTeam.mul(currentRate);
397         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
398         return (rAmount, rTransferAmount, rFee);
399     }
400 
401     function _takeTeam(uint256 tTeam) private {
402         uint256 currentRate =  _getRate();
403         uint256 rTeam = tTeam.mul(currentRate);
404 
405         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
406     }
407 
408     function _reflectFee(uint256 rFee, uint256 tFee) private {
409         _rTotal = _rTotal.sub(rFee);
410         _tFeeTotal = _tFeeTotal.add(tFee);
411     }
412 
413     receive() external payable {}
414     
415     function openTrading() external onlyOwner() {
416         require(!_tradingOpen,"trading is already open");
417         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
418         uniswapV2Router = _uniswapV2Router;
419         _approve(address(this), address(uniswapV2Router), _tTotal);
420         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
421         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
422         _maxBuyAmount = 5000000000 * 10**9;
423         // 1,000,000,000,000 total tokens
424         // 50,000,000,000 = 5% of total token count
425         _maxHeldTokens = 50000000000 * 10**9;
426         _buyLimitEnd = block.timestamp + (120 seconds);
427         _maxHeldTokensEnd = block.timestamp + (12 hours);
428         _launchFeeEnd = block.timestamp + (1 hours);
429         _tradingOpen = true;
430         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
431     }
432 
433     function manualswap() external {
434         require(_msgSender() == _feeAddress1);
435         uint256 contractBalance = balanceOf(address(this));
436         swapTokensForEth(contractBalance);
437     }
438     
439     function manualsend() external {
440         require(_msgSender() == _feeAddress1);
441         uint256 contractETHBalance = address(this).balance;
442         sendETHToFee(contractETHBalance);
443     }
444 
445     function toggleFees() external {
446         require(_msgSender() == _feeAddress1);
447         _useFees = false;
448         emit UseFeesBooleanUpdated(_useFees);
449     }
450 
451     function updateFeeAddress1(address newAddress) external {
452         require(_msgSender() == _feeAddress1);
453         _feeAddress1 = payable(newAddress);
454         emit FeeAddress1Updated(_feeAddress1);
455     }
456 
457     function updateFeeAddress2(address newAddress) external {
458         require(_msgSender() == _feeAddress2);
459         _feeAddress2 = payable(newAddress);
460         emit FeeAddress2Updated(_feeAddress2);
461     }
462 
463     function setCooldownEnabled() external {
464         require(_msgSender() == _feeAddress1);
465         _cooldownEnabled = !_cooldownEnabled;
466         emit CooldownEnabledUpdated(_cooldownEnabled);
467     }
468 
469     function cooldownEnabled() public view returns (bool) {
470         return _cooldownEnabled;
471     }
472 
473     function balancePool() public view returns (uint) {
474         return balanceOf(uniswapV2Pair);
475     }
476 
477     function balanceContract() public view returns (uint) {
478         return balanceOf(address(this));
479     }
480 
481     function usingFees() public view returns (bool) {
482         return _useFees;
483     }
484 
485     function whatIsFeeAddress1() public view returns (address) {
486         return _feeAddress1;
487     }
488 
489     function whatIsFeeAddress2() public view returns (address) {
490         return _feeAddress2;
491     }
492 }