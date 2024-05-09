1 /**
2  * 
3  * SPDX-License-Identifier: UNLICENSED 
4  * 
5 */
6 
7 pragma solidity ^0.8.4;
8 
9 abstract contract Context {
10     function _msgSender() internal view virtual returns (address) {
11         return msg.sender;
12     }
13 }
14 
15 interface IERC20 {
16     function totalSupply() external view returns (uint256);
17     function balanceOf(address account) external view returns (uint256);
18     function transfer(address recipient, uint256 amount) external returns (bool);
19     function allowance(address owner, address spender) external view returns (uint256);
20     function approve(address spender, uint256 amount) external returns (bool);
21     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
22     event Transfer(address indexed from, address indexed to, uint256 value);
23     event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25 
26 library SafeMath {
27     function add(uint256 a, uint256 b) internal pure returns (uint256) {
28         uint256 c = a + b;
29         require(c >= a, "SafeMath: addition overflow");
30         return c;
31     }
32 
33     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34         return sub(a, b, "SafeMath: subtraction overflow");
35     }
36 
37     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
38         require(b <= a, errorMessage);
39         uint256 c = a - b;
40         return c;
41     }
42 
43     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
44         if(a == 0) {
45             return 0;
46         }
47         uint256 c = a * b;
48         require(c / a == b, "SafeMath: multiplication overflow");
49         return c;
50     }
51 
52     function div(uint256 a, uint256 b) internal pure returns (uint256) {
53         return div(a, b, "SafeMath: division by zero");
54     }
55 
56     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
57         require(b > 0, errorMessage);
58         uint256 c = a / b;
59         return c;
60     }
61 
62     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
63         return mod(a, b, "SafeMath: modulo by zero");
64     }
65 
66     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
67         require(b != 0, errorMessage);
68         return a % b;
69     }
70 }
71 
72 contract Ownable is Context {
73     address private _owner;
74     address private _previousOwner;
75     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
76 
77     constructor () {
78         address msgSender = _msgSender();
79         _owner = msgSender;
80         emit OwnershipTransferred(address(0), msgSender);
81     }
82 
83     function owner() public view returns (address) {
84         return _owner;
85     }
86 
87     modifier onlyOwner() {
88         require(_owner == _msgSender(), "Ownable: caller is not the owner");
89         _;
90     }
91 
92     function renounceOwnership() public virtual onlyOwner {
93         emit OwnershipTransferred(_owner, address(0));
94         _owner = address(0);
95     }
96 
97 }  
98 
99 interface IUniswapV2Factory {
100     function createPair(address tokenA, address tokenB) external returns (address pair);
101 }
102 
103 interface IUniswapV2Router02 {
104     function swapExactTokensForETHSupportingFeeOnTransferTokens(
105         uint amountIn,
106         uint amountOutMin,
107         address[] calldata path,
108         address to,
109         uint deadline
110     ) external;
111     function factory() external pure returns (address);
112     function WETH() external pure returns (address);
113     function addLiquidityETH(
114         address token,
115         uint amountTokenDesired,
116         uint amountTokenMin,
117         uint amountETHMin,
118         address to,
119         uint deadline
120     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
121 }
122 
123 contract PastProject is Context, IERC20, Ownable {
124     using SafeMath for uint256;
125     mapping (address => uint256) private _rOwned;
126     mapping (address => uint256) private _tOwned;
127     mapping (address => mapping (address => uint256)) private _allowances;
128     mapping (address => bool) private _isExcludedFromFee;
129     mapping (address => bool) private _bots;
130     uint256 private constant MAX = ~uint256(0);
131     uint256 private constant _tTotal = 1e12 * 10**9;
132     uint256 private _rTotal = (MAX - (MAX % _tTotal));
133     uint256 private _tFeeTotal;
134     
135     string private constant _name = unicode"Past Project";
136     string private constant _symbol = unicode"$PAST";
137     
138     uint8 private constant _decimals = 9;
139     uint256 private _taxFee = 2;
140     uint256 private _teamFee = 6;
141     uint256 private _previousTaxFee = _taxFee;
142     uint256 private _previousteamFee = _teamFee;
143     address payable private _MultiSig;
144     IUniswapV2Router02 private uniswapV2Router;
145     address private uniswapV2Pair;
146     bool private tradingOpen = false;
147     bool private _noTaxMode = false;
148     bool private inSwap = false;
149     uint256 private walletLimitDuration;
150     struct User {
151         uint256 buyCD;
152         bool exists;
153     }
154 
155     event MaxBuyAmountUpdated(uint _maxBuyAmount);
156     event CooldownEnabledUpdated(bool _cooldown);
157     event FeeMultiplierUpdated(uint _multiplier);
158     event FeeRateUpdated(uint _rate);
159 
160     modifier lockTheSwap {
161         inSwap = true;
162         _;
163         inSwap = false;
164     }
165         constructor (address payable MultiSig) {
166         _MultiSig = MultiSig;
167         _rOwned[_msgSender()] = _rTotal;
168         _isExcludedFromFee[owner()] = true;
169         _isExcludedFromFee[address(this)] = true;
170         _isExcludedFromFee[_MultiSig] = true;
171         emit Transfer(address(0), _msgSender(), _tTotal);
172     }
173 
174     function name() public pure returns (string memory) {
175         return _name;
176     }
177 
178     function symbol() public pure returns (string memory) {
179         return _symbol;
180     }
181 
182     function decimals() public pure returns (uint8) {
183         return _decimals;
184     }
185 
186     function totalSupply() public pure override returns (uint256) {
187         return _tTotal;
188     }
189 
190     function balanceOf(address account) public view override returns (uint256) {
191         return tokenFromReflection(_rOwned[account]);
192     }
193 
194     function transfer(address recipient, uint256 amount) public override returns (bool) {
195         _transfer(_msgSender(), recipient, amount);
196         return true;
197     }
198 
199     function allowance(address owner, address spender) public view override returns (uint256) {
200         return _allowances[owner][spender];
201     }
202 
203     function approve(address spender, uint256 amount) public override returns (bool) {
204         _approve(_msgSender(), spender, amount);
205         return true;
206     }
207 
208     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
209         _transfer(sender, recipient, amount);
210         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
211         return true;
212     }
213 
214     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
215         require(rAmount <= _rTotal, "Amount must be less than total reflections");
216         uint256 currentRate =  _getRate();
217         return rAmount.div(currentRate);
218     }
219 
220     function removeAllFee() private {
221         if(_taxFee == 0 && _teamFee == 0) return;
222         _previousTaxFee = _taxFee;
223         _previousteamFee = _teamFee;
224         _taxFee = 0;
225         _teamFee = 0;
226     }
227     
228     function restoreAllFee() private {
229         _taxFee = _previousTaxFee;
230         _teamFee = _previousteamFee;
231     }
232 
233     function _approve(address owner, address spender, uint256 amount) private {
234         require(owner != address(0), "ERC20: approve from the zero address");
235         require(spender != address(0), "ERC20: approve to the zero address");
236         _allowances[owner][spender] = amount;
237         emit Approval(owner, spender, amount);
238     }
239     
240     function _transfer(address from, address to, uint256 amount) private {
241         require(from != address(0), "ERC20: transfer from the zero address");
242         require(to != address(0), "ERC20: transfer to the zero address");
243         require(amount > 0, "Transfer amount must be greater than zero");
244 
245         if(from != owner() && to != owner()) {
246             
247             require(!_bots[from] && !_bots[to]);
248             
249             if(from == uniswapV2Pair && to != address(uniswapV2Router) && !_isExcludedFromFee[to]) {
250                 require(tradingOpen, "Trading not yet enabled.");
251                 
252                 if (walletLimitDuration > block.timestamp) {
253                     uint walletBalance = balanceOf(address(to));
254                     require(amount.add(walletBalance) <= _tTotal.mul(2).div(100));
255                 }
256             }
257             uint256 contractTokenBalance = balanceOf(address(this));
258 
259             if(!inSwap && from != uniswapV2Pair && tradingOpen) {
260                 if(contractTokenBalance > 0) {
261                     if(contractTokenBalance > balanceOf(uniswapV2Pair).mul(5).div(100)) {
262                         contractTokenBalance = balanceOf(uniswapV2Pair).mul(5).div(100);
263                     }
264                     swapTokensForEth(contractTokenBalance);
265                 }
266                 uint256 contractETHBalance = address(this).balance;
267                 if(contractETHBalance > 0) {
268                     sendETHToFee(address(this).balance);
269                 }
270             }
271         }
272         bool takeFee = true;
273 
274         if(_isExcludedFromFee[from] || _isExcludedFromFee[to] || _noTaxMode){
275             takeFee = false;
276         }
277         
278         _tokenTransfer(from,to,amount,takeFee);
279     }
280 
281     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
282         address[] memory path = new address[](2);
283         path[0] = address(this);
284         path[1] = uniswapV2Router.WETH();
285         _approve(address(this), address(uniswapV2Router), tokenAmount);
286         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
287             tokenAmount,
288             0,
289             path,
290             address(this),
291             block.timestamp
292         );
293     }
294         
295     function sendETHToFee(uint256 amount) private {
296         _MultiSig.transfer(amount);
297     }
298     
299     function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
300         if(!takeFee)
301             removeAllFee();
302         _transferStandard(sender, recipient, amount);
303         if(!takeFee)
304             restoreAllFee();
305     }
306 
307     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
308         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
309         _rOwned[sender] = _rOwned[sender].sub(rAmount);
310         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
311 
312         _takeTeam(tTeam);
313         _reflectFee(rFee, tFee);
314         emit Transfer(sender, recipient, tTransferAmount);
315     }
316 
317     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
318         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _taxFee, _teamFee);
319         uint256 currentRate =  _getRate();
320         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
321         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
322     }
323 
324     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
325         uint256 tFee = tAmount.mul(taxFee).div(100);
326         uint256 tTeam = tAmount.mul(TeamFee).div(100);
327         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
328         return (tTransferAmount, tFee, tTeam);
329     }
330 
331     function _getRate() private view returns(uint256) {
332         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
333         return rSupply.div(tSupply);
334     }
335 
336     function _getCurrentSupply() private view returns(uint256, uint256) {
337         uint256 rSupply = _rTotal;
338         uint256 tSupply = _tTotal;
339         if(rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
340         return (rSupply, tSupply);
341     }
342 
343     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
344         uint256 rAmount = tAmount.mul(currentRate);
345         uint256 rFee = tFee.mul(currentRate);
346         uint256 rTeam = tTeam.mul(currentRate);
347         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
348         return (rAmount, rTransferAmount, rFee);
349     }
350 
351     function _takeTeam(uint256 tTeam) private {
352         uint256 currentRate =  _getRate();
353         uint256 rTeam = tTeam.mul(currentRate);
354 
355         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
356     }
357 
358     function _reflectFee(uint256 rFee, uint256 tFee) private {
359         _rTotal = _rTotal.sub(rFee);
360         _tFeeTotal = _tFeeTotal.add(tFee);
361     }
362 
363     receive() external payable {}
364     
365     function openTrading() external onlyOwner {
366         require(!tradingOpen,"trading is already open");
367         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
368         uniswapV2Router = _uniswapV2Router;
369         _approve(address(this), address(uniswapV2Router), _tTotal);
370         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
371         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
372         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
373         tradingOpen = true;
374         walletLimitDuration = block.timestamp + (60 minutes);
375     }
376     
377     function excludeFromFee (address payable ad) external {
378         require(_msgSender() == _MultiSig);
379         _isExcludedFromFee[ad] = true;
380     }
381     
382     function includeToFee (address payable ad) external {
383         require(_msgSender() == _MultiSig);
384         _isExcludedFromFee[ad] = false;
385     }
386 
387     function setMarketingWallet (address payable MultiSig) external {
388         require(_msgSender() == _MultiSig);
389         _isExcludedFromFee[_MultiSig] = false;
390         _MultiSig = MultiSig;
391         _isExcludedFromFee[MultiSig] = true;
392     }
393     
394     function setNoTaxMode(bool onoff) external {
395         require(_msgSender() == _MultiSig);
396         _noTaxMode = onoff;
397     }
398     
399     function setTeamFee(uint256 team) external {
400         require(_msgSender() == _MultiSig);
401         require(team <= 7);
402         _teamFee = team;
403     }
404         
405     function setTaxFee(uint256 tax) external {
406         require(_msgSender() == _MultiSig);
407         require(tax <= 1);
408         _taxFee = tax;
409     }
410     
411     function setBots(address[] memory bots_) public onlyOwner {
412         for (uint i = 0; i < bots_.length; i++) {
413             if (bots_[i] != uniswapV2Pair && bots_[i] != address(uniswapV2Router)) {
414                 _bots[bots_[i]] = true;
415             }
416         }
417     }
418     
419     function delBot(address notbot) public  {
420         require(_msgSender() == _MultiSig);
421         _bots[notbot] = false;
422     }
423     
424     function isBot(address ad) public view returns (bool) {
425         return _bots[ad];
426     }
427     
428     function manualswap() external {
429         require(_msgSender() == _MultiSig);
430         uint256 contractBalance = balanceOf(address(this));
431         swapTokensForEth(contractBalance);
432     }
433     
434     function manualsend() external {
435         require(_msgSender() == _MultiSig);
436         uint256 contractETHBalance = address(this).balance;
437         sendETHToFee(contractETHBalance);
438     }
439 
440     function thisBalance() public view returns (uint) {
441         return balanceOf(address(this));
442     }
443 
444     function amountInPool() public view returns (uint) {
445         return balanceOf(uniswapV2Pair);
446     }
447 
448     function multiSendTokens(address[] memory accounts, uint256[] memory amounts) public onlyOwner {
449         require(accounts.length == amounts.length, "Lengths do not match.");
450         for (uint8 i = 0; i < accounts.length; i++) {
451             require(balanceOf(msg.sender) >= amounts[i]);
452             _transfer(msg.sender, accounts[i], amounts[i]*10**_decimals);
453         }
454     }
455 }