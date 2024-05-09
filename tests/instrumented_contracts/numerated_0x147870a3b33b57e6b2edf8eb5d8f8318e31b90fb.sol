1 /*
2 
3 2,300 years ago, $JYOMON a powerful and hunter dog was born
4 under the breed of Shiba Inu.
5 But during the World War II, the breed faced massive extinction
6 And only 5 breeds survive. 
7 
8 $SHIBA INU
9 $SANIN SHIBA INU
10 $MINO SHIBA INU
11 $SHINSHU SHIBA INU
12 
13 and lastly
14 
15 $JYOMON SHIBA INU
16 
17 Now entering DEFI to conquer the moon mission and be known again. 
18 $JYOMON will be one of strongest inus.
19 
20 Telegram: https://t.me/JyomonShibainu
21 Twitter: https://twitter.com/Jyomonshibainu
22 Medium:https://medium.com/@jyomonshiba/jyomon-9e82d958a8a1
23 
24 
25 */
26 
27 // SPDX-License-Identifier: MIT
28 
29 pragma solidity 0.8.16;
30 
31 abstract contract Context {
32     function _msgSender() internal view virtual returns (address) {
33         return msg.sender;
34     }
35 }
36 
37 interface IERC20 {
38     function totalSupply() external view returns (uint256);
39     function balanceOf(address account) external view returns (uint256);
40     function transfer(address recipient, uint256 amount) external returns (bool);
41     function allowance(address owner, address spender) external view returns (uint256);
42     function approve(address spender, uint256 amount) external returns (bool);
43     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
44     event Transfer(address indexed from, address indexed to, uint256 value);
45     event Approval(address indexed owner, address indexed spender, uint256 value);
46 }
47 
48 library SafeMath {
49     function add(uint256 a, uint256 b) internal pure returns (uint256) {
50         uint256 c = a + b;
51         require(c >= a, "SafeMath: addition overflow");
52         return c;
53     }
54 
55     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
56         return sub(a, b, "SafeMath: subtraction overflow");
57     }
58 
59     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
60         require(b <= a, errorMessage);
61         uint256 c = a - b;
62         return c;
63     }
64 
65     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
66         if (a == 0) {
67             return 0;
68         }
69         uint256 c = a * b;
70         require(c / a == b, "SafeMath: multiplication overflow");
71         return c;
72     }
73 
74     function div(uint256 a, uint256 b) internal pure returns (uint256) {
75         return div(a, b, "SafeMath: division by zero");
76     }
77 
78     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
79         require(b > 0, errorMessage);
80         uint256 c = a / b;
81         return c;
82     }
83 
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
137 contract JYOMON is Context, IERC20, Ownable { 
138     using SafeMath for uint256;
139     mapping (address => uint256) private _rOwned;
140     mapping (address => uint256) private _tOwned;
141     mapping (address => mapping (address => uint256)) private _allowances;
142     mapping (address => bool) private _isExcludedFromFee;
143     mapping (address => bool) private bots;
144     mapping (address => uint) private cooldown;
145     uint256 private constant MAX = ~uint256(0);
146     uint256 private constant _tTotal = 1000000000000 * 10**8;
147     uint256 private _rTotal = (MAX - (MAX % _tTotal));
148     uint256 private _tFeeTotal;
149 
150     uint256 private _feeAddr1;
151     uint256 private _feeAddr2;
152     uint256 private _initialTax;
153     uint256 private _finalTax;
154     uint256 private _reduceTaxTarget;
155     uint256 private _reduceTaxCountdown;
156     address payable private _feeAddrWallet;
157 
158     string private constant _name = "JYOMON SHIBA INU";
159     string private constant _symbol = "JYOMON";
160     uint8 private constant _decimals = 8;
161 
162     IUniswapV2Router02 private uniswapV2Router;
163     address private uniswapV2Pair;
164     bool private tradingOpen;
165     bool private inSwap = false;
166     bool private swapEnabled = false;
167     bool private cooldownEnabled = false;
168     uint256 public _maxTxAmount = _tTotal.mul(2).div(100); 
169     uint256 public _maxWalletSize = _tTotal.mul(2).div(100);
170     event MaxTxAmountUpdated(uint _maxTxAmount);
171     modifier lockTheSwap {
172         inSwap = true;
173         _;
174         inSwap = false;
175     }
176 
177     constructor () {
178         _feeAddrWallet = payable(_msgSender());
179         _rOwned[_msgSender()] = _rTotal;
180         _isExcludedFromFee[owner()] = true;
181         _isExcludedFromFee[address(this)] = true;
182         _isExcludedFromFee[_feeAddrWallet] = true;
183         _initialTax=7;
184         _finalTax=5;
185         _reduceTaxCountdown=60;
186         _reduceTaxTarget = _reduceTaxCountdown.div(2);
187         emit Transfer(address(0), _msgSender(), _tTotal);
188     }
189 
190     function name() public pure returns (string memory) {
191         return _name;
192     }
193 
194     function symbol() public pure returns (string memory) {
195         return _symbol;
196     }
197 
198     function decimals() public pure returns (uint8) {
199         return _decimals;
200     }
201 
202     function totalSupply() public pure override returns (uint256) {
203         return _tTotal;
204     }
205 
206     function balanceOf(address account) public view override returns (uint256) {
207         return tokenFromReflection(_rOwned[account]);
208     }
209 
210     function transfer(address recipient, uint256 amount) public override returns (bool) {
211         _transfer(_msgSender(), recipient, amount);
212         return true;
213     }
214 
215     function allowance(address owner, address spender) public view override returns (uint256) {
216         return _allowances[owner][spender];
217     }
218 
219     function approve(address spender, uint256 amount) public override returns (bool) {
220         _approve(_msgSender(), spender, amount);
221         return true;
222     }
223 
224     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
225         _transfer(sender, recipient, amount);
226         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
227         return true;
228     }
229 
230     function setCooldownEnabled(bool onoff) external onlyOwner() {
231         cooldownEnabled = onoff;
232     }
233 
234     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
235         require(rAmount <= _rTotal, "Amount must be less than total reflections");
236         uint256 currentRate =  _getRate();
237         return rAmount.div(currentRate);
238     }
239 
240     function _approve(address owner, address spender, uint256 amount) private {
241         require(owner != address(0), "ERC20: approve from the zero address");
242         require(spender != address(0), "ERC20: approve to the zero address");
243         _allowances[owner][spender] = amount;
244         emit Approval(owner, spender, amount);
245     }
246 
247     function _transfer(address from, address to, uint256 amount) private {
248         require(from != address(0), "ERC20: transfer from the zero address");
249         require(to != address(0), "ERC20: transfer to the zero address");
250         require(amount > 0, "Transfer amount must be greater than zero");
251 
252 
253         if (from != owner() && to != owner()) {
254             require(!bots[from] && !bots[to]);
255             _feeAddr1 = 0;
256             _feeAddr2 = (_reduceTaxCountdown==0)?_finalTax:_initialTax;
257             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
258                 // Cooldown
259                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
260                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
261                 if(_reduceTaxCountdown>0){_reduceTaxCountdown--;}
262             }
263 
264 
265             uint256 contractTokenBalance = balanceOf(address(this));
266             if (!inSwap && from != uniswapV2Pair && swapEnabled && contractTokenBalance>0 && _reduceTaxCountdown<_reduceTaxTarget) {
267                 swapTokensForEth(contractTokenBalance);
268                 uint256 contractETHBalance = address(this).balance;
269                 if(contractETHBalance > 0) {
270                     sendETHToFee(address(this).balance);
271                 }
272             }
273         }else{
274           _feeAddr1 = 0;
275           _feeAddr2 = 0;
276         }
277 
278         _tokenTransfer(from,to,amount);
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
295 
296     function removeLimits() external onlyOwner{
297         _maxTxAmount = _tTotal;
298         _maxWalletSize = _tTotal;
299     }
300 
301     function sendETHToFee(uint256 amount) private {
302         _feeAddrWallet.transfer(amount);
303     }
304 
305     function addBots(address[] memory bots_) public onlyOwner {
306         for (uint i = 0; i < bots_.length; i++) {
307             bots[bots_[i]] = true;
308         }
309     }
310 
311     function delBots(address[] memory notbot) public onlyOwner {
312       for (uint i = 0; i < notbot.length; i++) {
313           bots[notbot[i]] = false;
314       }
315 
316     }
317 
318     function openTrading() external onlyOwner() {
319         require(!tradingOpen,"trading is already open");
320         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
321         uniswapV2Router = _uniswapV2Router;
322         _approve(address(this), address(uniswapV2Router), _tTotal);
323         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
324         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
325         swapEnabled = true;
326         cooldownEnabled = true;
327 
328         tradingOpen = true;
329         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
330     }
331 
332     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
333         _transferStandard(sender, recipient, amount);
334     }
335 
336     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
337         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
338         _rOwned[sender] = _rOwned[sender].sub(rAmount);
339         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
340         _takeTeam(tTeam);
341         _reflectFee(rFee, tFee);
342         emit Transfer(sender, recipient, tTransferAmount);
343     }
344 
345     function _takeTeam(uint256 tTeam) private {
346         uint256 currentRate =  _getRate();
347         uint256 rTeam = tTeam.mul(currentRate);
348         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
349     }
350 
351     function _reflectFee(uint256 rFee, uint256 tFee) private {
352         _rTotal = _rTotal.sub(rFee);
353         _tFeeTotal = _tFeeTotal.add(tFee);
354     }
355 
356     receive() external payable {}
357 
358     function manualswap() external {
359         require(_msgSender() == _feeAddrWallet);
360         uint256 contractBalance = balanceOf(address(this));
361         swapTokensForEth(contractBalance);
362     }
363 
364     function manualsend() external {
365         require(_msgSender() == _feeAddrWallet);
366         uint256 contractETHBalance = address(this).balance;
367         sendETHToFee(contractETHBalance);
368     }
369 
370 
371     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
372         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _feeAddr1, _feeAddr2);
373         uint256 currentRate =  _getRate();
374         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
375         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
376     }
377 
378     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
379         uint256 tFee = tAmount.mul(taxFee).div(100);
380         uint256 tTeam = tAmount.mul(TeamFee).div(100);
381         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
382         return (tTransferAmount, tFee, tTeam);
383     }
384 
385     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
386         uint256 rAmount = tAmount.mul(currentRate);
387         uint256 rFee = tFee.mul(currentRate);
388         uint256 rTeam = tTeam.mul(currentRate);
389         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
390         return (rAmount, rTransferAmount, rFee);
391     }
392 
393 	function _getRate() private view returns(uint256) {
394         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
395         return rSupply.div(tSupply);
396     }
397 
398     function _getCurrentSupply() private view returns(uint256, uint256) {
399         uint256 rSupply = _rTotal;
400         uint256 tSupply = _tTotal;
401         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
402         return (rSupply, tSupply);
403     }
404 }