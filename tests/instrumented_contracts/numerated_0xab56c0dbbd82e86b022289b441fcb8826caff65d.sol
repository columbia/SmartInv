1 /*
2 The one and only wish, the Bullish Wish
3 
4 Make your wish to Ryusei now.
5 
6 Zero Tax
7 
8 No Telegram, no website, no twitter.
9 
10 Annoucement only on: https://medium.com/@Ryuseiii
11 */
12 
13 
14 // SPDX-License-Identifier: MIT
15 
16 pragma solidity 0.8.16;
17 
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address) {
20         return msg.sender;
21     }
22 }
23 
24 interface IERC20 {
25     function totalSupply() external view returns (uint256);
26     function balanceOf(address account) external view returns (uint256);
27     function transfer(address recipient, uint256 amount) external returns (bool);
28     function allowance(address owner, address spender) external view returns (uint256);
29     function approve(address spender, uint256 amount) external returns (bool);
30     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
31     event Transfer(address indexed from, address indexed to, uint256 value);
32     event Approval(address indexed owner, address indexed spender, uint256 value);
33 }
34 
35 library SafeMath {
36     function add(uint256 a, uint256 b) internal pure returns (uint256) {
37         uint256 c = a + b;
38         require(c >= a, "SafeMath: addition overflow");
39         return c;
40     }
41 
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         return sub(a, b, "SafeMath: subtraction overflow");
44     }
45 
46     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
47         require(b <= a, errorMessage);
48         uint256 c = a - b;
49         return c;
50     }
51 
52     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
53         if (a == 0) {
54             return 0;
55         }
56         uint256 c = a * b;
57         require(c / a == b, "SafeMath: multiplication overflow");
58         return c;
59     }
60 
61     function div(uint256 a, uint256 b) internal pure returns (uint256) {
62         return div(a, b, "SafeMath: division by zero");
63     }
64 
65     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
66         require(b > 0, errorMessage);
67         uint256 c = a / b;
68         return c;
69     }
70 
71 }
72 
73 contract Ownable is Context {
74     address private _owner;
75     address private _previousOwner;
76     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
77 
78     constructor () {
79         address msgSender = _msgSender();
80         _owner = msgSender;
81         emit OwnershipTransferred(address(0), msgSender);
82     }
83 
84     function owner() public view returns (address) {
85         return _owner;
86     }
87 
88     modifier onlyOwner() {
89         require(_owner == _msgSender(), "Ownable: caller is not the owner");
90         _;
91     }
92 
93     function renounceOwnership() public virtual onlyOwner {
94         emit OwnershipTransferred(_owner, address(0));
95         _owner = address(0);
96     }
97 
98 }
99 
100 interface IUniswapV2Factory {
101     function createPair(address tokenA, address tokenB) external returns (address pair);
102 }
103 
104 interface IUniswapV2Router02 {
105     function swapExactTokensForETHSupportingFeeOnTransferTokens(
106         uint amountIn,
107         uint amountOutMin,
108         address[] calldata path,
109         address to,
110         uint deadline
111     ) external;
112     function factory() external pure returns (address);
113     function WETH() external pure returns (address);
114     function addLiquidityETH(
115         address token,
116         uint amountTokenDesired,
117         uint amountTokenMin,
118         uint amountETHMin,
119         address to,
120         uint deadline
121     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
122 }
123 
124 contract Bullish is Context, IERC20, Ownable { 
125     using SafeMath for uint256;
126     mapping (address => uint256) private _rOwned;
127     mapping (address => uint256) private _tOwned;
128     mapping (address => mapping (address => uint256)) private _allowances;
129     mapping (address => bool) private _isExcludedFromFee;
130     mapping (address => bool) private bots;
131     mapping (address => uint) private cooldown;
132     uint256 private constant MAX = ~uint256(0);
133     uint256 private constant _tTotal = 1000000000 * 10**8;
134     uint256 private _rTotal = (MAX - (MAX % _tTotal));
135     uint256 private _tFeeTotal;
136 
137     uint256 private _feeAddr1;
138     uint256 private _feeAddr2;
139     uint256 private _initialTax;
140     uint256 private _finalTax;
141     uint256 private _reduceTaxTarget;
142     uint256 private _reduceTaxCountdown;
143     address payable private _feeAddrWallet;
144 
145     string private constant _name = "The Bullish Wish";
146     string private constant _symbol = "Ryusei";
147     uint8 private constant _decimals = 8;
148 
149     IUniswapV2Router02 private uniswapV2Router;
150     address private uniswapV2Pair;
151     bool private tradingOpen;
152     bool private inSwap = false;
153     bool private swapEnabled = false;
154     bool private cooldownEnabled = false;
155     uint256 public _maxTxAmount = _tTotal.mul(20).div(1000); 
156     uint256 public _maxWalletSize = _tTotal.mul(20).div(1000);
157     event MaxTxAmountUpdated(uint _maxTxAmount);
158     modifier lockTheSwap {
159         inSwap = true;
160         _;
161         inSwap = false;
162     }
163 
164     constructor () {
165         _feeAddrWallet = payable(_msgSender());
166         _rOwned[_msgSender()] = _rTotal;
167         _isExcludedFromFee[owner()] = true;
168         _isExcludedFromFee[address(this)] = true;
169         _isExcludedFromFee[_feeAddrWallet] = true;
170         _initialTax=6;
171         _finalTax=0;
172         _reduceTaxCountdown=44;
173         _reduceTaxTarget = _reduceTaxCountdown.div(2);
174         emit Transfer(address(0), _msgSender(), _tTotal);
175     }
176 
177     function name() public pure returns (string memory) {
178         return _name;
179     }
180 
181     function symbol() public pure returns (string memory) {
182         return _symbol;
183     }
184 
185     function decimals() public pure returns (uint8) {
186         return _decimals;
187     }
188 
189     function totalSupply() public pure override returns (uint256) {
190         return _tTotal;
191     }
192 
193     function balanceOf(address account) public view override returns (uint256) {
194         return tokenFromReflection(_rOwned[account]);
195     }
196 
197     function transfer(address recipient, uint256 amount) public override returns (bool) {
198         _transfer(_msgSender(), recipient, amount);
199         return true;
200     }
201 
202     function allowance(address owner, address spender) public view override returns (uint256) {
203         return _allowances[owner][spender];
204     }
205 
206     function approve(address spender, uint256 amount) public override returns (bool) {
207         _approve(_msgSender(), spender, amount);
208         return true;
209     }
210 
211     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
212         _transfer(sender, recipient, amount);
213         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
214         return true;
215     }
216 
217     function setCooldownEnabled(bool onoff) external onlyOwner() {
218         cooldownEnabled = onoff;
219     }
220 
221     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
222         require(rAmount <= _rTotal, "Amount must be less than total reflections");
223         uint256 currentRate =  _getRate();
224         return rAmount.div(currentRate);
225     }
226 
227     function _approve(address owner, address spender, uint256 amount) private {
228         require(owner != address(0), "ERC20: approve from the zero address");
229         require(spender != address(0), "ERC20: approve to the zero address");
230         _allowances[owner][spender] = amount;
231         emit Approval(owner, spender, amount);
232     }
233 
234     function _transfer(address from, address to, uint256 amount) private {
235         require(from != address(0), "ERC20: transfer from the zero address");
236         require(to != address(0), "ERC20: transfer to the zero address");
237         require(amount > 0, "Transfer amount must be greater than zero");
238 
239 
240         if (from != owner() && to != owner()) {
241             require(!bots[from] && !bots[to]);
242             _feeAddr1 = 0;
243             _feeAddr2 = (_reduceTaxCountdown==0)?_finalTax:_initialTax;
244             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
245                 // Cooldown
246                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
247                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
248                 if(_reduceTaxCountdown>0){_reduceTaxCountdown--;}
249             }
250 
251 
252             uint256 contractTokenBalance = balanceOf(address(this));
253             if (!inSwap && from != uniswapV2Pair && swapEnabled && contractTokenBalance>0 && _reduceTaxCountdown<_reduceTaxTarget) {
254                 swapTokensForEth(contractTokenBalance);
255                 uint256 contractETHBalance = address(this).balance;
256                 if(contractETHBalance > 0) {
257                     sendETHToFee(address(this).balance);
258                 }
259             }
260         }else{
261           _feeAddr1 = 0;
262           _feeAddr2 = 0;
263         }
264 
265         _tokenTransfer(from,to,amount);
266     }
267 
268     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
269         address[] memory path = new address[](2);
270         path[0] = address(this);
271         path[1] = uniswapV2Router.WETH();
272         _approve(address(this), address(uniswapV2Router), tokenAmount);
273         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
274             tokenAmount,
275             0,
276             path,
277             address(this),
278             block.timestamp
279         );
280     }
281 
282 
283     function removeLimits() external onlyOwner{
284         _maxTxAmount = _tTotal;
285         _maxWalletSize = _tTotal;
286     }
287 
288     function sendETHToFee(uint256 amount) private {
289         _feeAddrWallet.transfer(amount);
290     }
291 
292     function addBots(address[] memory bots_) public onlyOwner {
293         for (uint i = 0; i < bots_.length; i++) {
294             bots[bots_[i]] = true;
295         }
296     }
297 
298     function delBots(address[] memory notbot) public onlyOwner {
299       for (uint i = 0; i < notbot.length; i++) {
300           bots[notbot[i]] = false;
301       }
302 
303     }
304 
305     function openTrading() external onlyOwner() {
306         require(!tradingOpen,"trading is already open");
307         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
308         uniswapV2Router = _uniswapV2Router;
309         _approve(address(this), address(uniswapV2Router), _tTotal);
310         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
311         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
312         swapEnabled = true;
313         cooldownEnabled = true;
314 
315         tradingOpen = true;
316         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
317     }
318 
319     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
320         _transferStandard(sender, recipient, amount);
321     }
322 
323     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
324         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
325         _rOwned[sender] = _rOwned[sender].sub(rAmount);
326         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
327         _takeTeam(tTeam);
328         _reflectFee(rFee, tFee);
329         emit Transfer(sender, recipient, tTransferAmount);
330     }
331 
332     function _takeTeam(uint256 tTeam) private {
333         uint256 currentRate =  _getRate();
334         uint256 rTeam = tTeam.mul(currentRate);
335         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
336     }
337 
338     function _reflectFee(uint256 rFee, uint256 tFee) private {
339         _rTotal = _rTotal.sub(rFee);
340         _tFeeTotal = _tFeeTotal.add(tFee);
341     }
342 
343     receive() external payable {}
344 
345     function manualswap() external {
346         require(_msgSender() == _feeAddrWallet);
347         uint256 contractBalance = balanceOf(address(this));
348         swapTokensForEth(contractBalance);
349     }
350 
351     function manualsend() external {
352         require(_msgSender() == _feeAddrWallet);
353         uint256 contractETHBalance = address(this).balance;
354         sendETHToFee(contractETHBalance);
355     }
356 
357 
358     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
359         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _feeAddr1, _feeAddr2);
360         uint256 currentRate =  _getRate();
361         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
362         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
363     }
364 
365     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
366         uint256 tFee = tAmount.mul(taxFee).div(100);
367         uint256 tTeam = tAmount.mul(TeamFee).div(100);
368         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
369         return (tTransferAmount, tFee, tTeam);
370     }
371 
372     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
373         uint256 rAmount = tAmount.mul(currentRate);
374         uint256 rFee = tFee.mul(currentRate);
375         uint256 rTeam = tTeam.mul(currentRate);
376         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
377         return (rAmount, rTransferAmount, rFee);
378     }
379 
380 	function _getRate() private view returns(uint256) {
381         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
382         return rSupply.div(tSupply);
383     }
384 
385     function _getCurrentSupply() private view returns(uint256, uint256) {
386         uint256 rSupply = _rTotal;
387         uint256 tSupply = _tTotal;
388         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
389         return (rSupply, tSupply);
390     }
391 }