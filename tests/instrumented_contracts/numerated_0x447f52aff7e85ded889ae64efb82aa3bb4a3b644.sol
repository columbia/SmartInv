1 /**
2 Big brother is all around us. They can see and hear everything we are doing. 
3 History has been erased, language has been changed, and independent thinking, also known as thought crimes, can get you arrested or vaporized. 
4 Allegiance must be sworn to the Party.
5 However, an underground movement is gaining strength known as the Brotherhood. 
6 Their mission is to take down the Party at all costs. The time to act is now, or has 1984 become our not-so-distant reality?
7 Paper hands need not apply, as to be part of the Brotherhood means you are to see our mission through until Valhalla Victory as jeets will be vaporized.
8 */
9 
10 
11 pragma solidity 0.8.7;
12 // SPDX-License-Identifier: UNLICENSED
13 abstract contract Context {
14     function _msgSender() internal view virtual returns (address) {
15         return msg.sender;
16     }
17 }
18 
19 interface IERC20 {
20     function totalSupply() external view returns (uint256);
21     function balanceOf(address account) external view returns (uint256);
22     function transfer(address recipient, uint256 amount) external returns (bool);
23     function allowance(address owner, address spender) external view returns (uint256);
24     function approve(address spender, uint256 amount) external returns (bool);
25     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
26     event Transfer(address indexed from, address indexed to, uint256 value);
27     event Approval(address indexed owner, address indexed spender, uint256 value);
28 }
29 
30 library SafeMath {
31     function add(uint256 a, uint256 b) internal pure returns (uint256) {
32         uint256 c = a + b;
33         require(c >= a, "SafeMath: addition overflow");
34         return c;
35     }
36 
37     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38         return sub(a, b, "SafeMath: subtraction overflow");
39     }
40 
41     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
42         require(b <= a, errorMessage);
43         uint256 c = a - b;
44         return c;
45     }
46 
47     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
48         if (a == 0) {
49             return 0;
50         }
51         uint256 c = a * b;
52         require(c / a == b, "SafeMath: multiplication overflow");
53         return c;
54     }
55 
56     function div(uint256 a, uint256 b) internal pure returns (uint256) {
57         return div(a, b, "SafeMath: division by zero");
58     }
59 
60     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
61         require(b > 0, errorMessage);
62         uint256 c = a / b;
63         return c;
64     }
65 
66 }
67 
68 contract Ownable is Context {
69     address private _owner;
70     address private _previousOwner;
71     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
72 
73     constructor () {
74         address msgSender = _msgSender();
75         _owner = msgSender;
76         emit OwnershipTransferred(address(0), msgSender);
77     }
78 
79     function owner() public view returns (address) {
80         return _owner;
81     }
82 
83     modifier onlyOwner() {
84         require(_owner == _msgSender(), "Ownable: caller is not the owner");
85         _;
86     }
87 
88     function renounceOwnership() public virtual onlyOwner {
89         emit OwnershipTransferred(_owner, address(0));
90         _owner = address(0);
91     }
92 
93 }
94 
95 interface IUniswapV2Factory {
96     function createPair(address tokenA, address tokenB) external returns (address pair);
97 }
98 
99 interface IUniswapV2Router02 {
100     function swapExactTokensForETHSupportingFeeOnTransferTokens(
101         uint amountIn,
102         uint amountOutMin,
103         address[] calldata path,
104         address to,
105         uint deadline
106     ) external;
107     function factory() external pure returns (address);
108     function WETH() external pure returns (address);
109     function addLiquidityETH(
110         address token,
111         uint amountTokenDesired,
112         uint amountTokenMin,
113         uint amountETHMin,
114         address to,
115         uint deadline
116     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
117 }
118 
119 contract Bigbrother is Context, IERC20, Ownable {
120     using SafeMath for uint256;
121     mapping (address => uint256) private _rOwned;
122     mapping (address => uint256) private _tOwned;
123     mapping (address => mapping (address => uint256)) private _allowances;
124     mapping (address => bool) private _isExcludedFromFee;
125     mapping (address => bool) private bots;
126     mapping (address => uint) private cooldown;
127     uint256 private constant MAX = ~uint256(0);
128     uint256 private constant _tTotal = 8_000_000 * 10**9;
129     uint256 private _rTotal = (MAX - (MAX % _tTotal));
130     uint256 private _tFeeTotal;
131 
132     uint256 private _feeAddr1;
133     uint256 private _feeAddr2;
134     uint256 private _initialTax;
135     uint256 private _finalTax;
136     uint256 private _reduceTaxCountdown;
137     address payable private _feeAddrWallet;
138 
139     string private constant _name = "The 1984";
140     string private constant _symbol = "1984";
141     uint8 private constant _decimals = 9;
142 
143     IUniswapV2Router02 private uniswapV2Router;
144     address private uniswapV2Pair;
145     bool private tradingOpen;
146     bool private inSwap = false;
147     bool private swapEnabled = false;
148     bool private cooldownEnabled = false;
149     uint256 private _maxTxAmount = 160_000 * 10**9;
150     uint256 private _maxWalletSize = 160_000 * 10**9;
151     event MaxTxAmountUpdated(uint _maxTxAmount);
152     modifier lockTheSwap {
153         inSwap = true;
154         _;
155         inSwap = false;
156     }
157 
158     constructor () {
159         _feeAddrWallet = payable(_msgSender());
160         _rOwned[_msgSender()] = _rTotal;
161         _isExcludedFromFee[owner()] = true;
162         _isExcludedFromFee[address(this)] = true;
163         _isExcludedFromFee[_feeAddrWallet] = true;
164         _initialTax=7;
165         _finalTax=4;
166         _reduceTaxCountdown=60;
167 
168         emit Transfer(address(0), _msgSender(), _tTotal);
169     }
170 
171     function name() public pure returns (string memory) {
172         return _name;
173     }
174 
175     function symbol() public pure returns (string memory) {
176         return _symbol;
177     }
178 
179     function decimals() public pure returns (uint8) {
180         return _decimals;
181     }
182 
183     function totalSupply() public pure override returns (uint256) {
184         return _tTotal;
185     }
186 
187     function balanceOf(address account) public view override returns (uint256) {
188         return tokenFromReflection(_rOwned[account]);
189     }
190 
191     function transfer(address recipient, uint256 amount) public override returns (bool) {
192         _transfer(_msgSender(), recipient, amount);
193         return true;
194     }
195 
196     function allowance(address owner, address spender) public view override returns (uint256) {
197         return _allowances[owner][spender];
198     }
199 
200     function approve(address spender, uint256 amount) public override returns (bool) {
201         _approve(_msgSender(), spender, amount);
202         return true;
203     }
204 
205     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
206         _transfer(sender, recipient, amount);
207         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
208         return true;
209     }
210 
211     function setCooldownEnabled(bool onoff) external onlyOwner() {
212         cooldownEnabled = onoff;
213     }
214 
215     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
216         require(rAmount <= _rTotal, "Amount must be less than total reflections");
217         uint256 currentRate =  _getRate();
218         return rAmount.div(currentRate);
219     }
220 
221     function _approve(address owner, address spender, uint256 amount) private {
222         require(owner != address(0), "ERC20: approve from the zero address");
223         require(spender != address(0), "ERC20: approve to the zero address");
224         _allowances[owner][spender] = amount;
225         emit Approval(owner, spender, amount);
226     }
227 
228     function _transfer(address from, address to, uint256 amount) private {
229         require(from != address(0), "ERC20: transfer from the zero address");
230         require(to != address(0), "ERC20: transfer to the zero address");
231         require(amount > 0, "Transfer amount must be greater than zero");
232 
233 
234         if (from != owner() && to != owner()) {
235             require(!bots[from] && !bots[to]);
236             _feeAddr1 = 0;
237             _feeAddr2 = (_reduceTaxCountdown==0)?_finalTax:_initialTax;
238             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
239                 // Cooldown
240                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
241                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
242                 if(_reduceTaxCountdown>0){_reduceTaxCountdown--;}
243             }
244 
245 
246             uint256 contractTokenBalance = balanceOf(address(this));
247             if (!inSwap && from != uniswapV2Pair && swapEnabled && contractTokenBalance>0) {
248                 swapTokensForEth(contractTokenBalance);
249                 uint256 contractETHBalance = address(this).balance;
250                 if(contractETHBalance > 0) {
251                     sendETHToFee(address(this).balance);
252                 }
253             }
254         }else{
255           _feeAddr1 = 0;
256           _feeAddr2 = 0;
257         }
258 
259         _tokenTransfer(from,to,amount);
260     }
261 
262     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
263         address[] memory path = new address[](2);
264         path[0] = address(this);
265         path[1] = uniswapV2Router.WETH();
266         _approve(address(this), address(uniswapV2Router), tokenAmount);
267         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
268             tokenAmount,
269             0,
270             path,
271             address(this),
272             block.timestamp
273         );
274     }
275 
276     function addBots(address[] memory bots_) public onlyOwner {
277         for (uint i = 0; i < bots_.length; i++) {
278             bots[bots_[i]] = true;
279         }
280     }
281 
282     function delBot(address notbot) public onlyOwner {
283         bots[notbot] = false;
284     }
285 
286 
287     function removeLimits() external onlyOwner{
288         _maxTxAmount = _tTotal;
289         _maxWalletSize = _tTotal;
290     }
291 
292     function sendETHToFee(uint256 amount) private {
293         _feeAddrWallet.transfer(amount);
294     }
295 
296     function openTrading() external onlyOwner() {
297         require(!tradingOpen,"trading is already open");
298         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
299         uniswapV2Router = _uniswapV2Router;
300         _approve(address(this), address(uniswapV2Router), _tTotal);
301         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
302         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
303         swapEnabled = true;
304         cooldownEnabled = true;
305 
306         tradingOpen = true;
307         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
308     }
309 
310     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
311         _transferStandard(sender, recipient, amount);
312     }
313 
314     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
315         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
316         _rOwned[sender] = _rOwned[sender].sub(rAmount);
317         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
318         _takeTeam(tTeam);
319         _reflectFee(rFee, tFee);
320         emit Transfer(sender, recipient, tTransferAmount);
321     }
322 
323     function _takeTeam(uint256 tTeam) private {
324         uint256 currentRate =  _getRate();
325         uint256 rTeam = tTeam.mul(currentRate);
326         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
327     }
328 
329     function _reflectFee(uint256 rFee, uint256 tFee) private {
330         _rTotal = _rTotal.sub(rFee);
331         _tFeeTotal = _tFeeTotal.add(tFee);
332     }
333 
334     receive() external payable {}
335 
336     function manualswap() external {
337         require(_msgSender() == _feeAddrWallet);
338         uint256 contractBalance = balanceOf(address(this));
339         swapTokensForEth(contractBalance);
340     }
341 
342     function manualsend() external {
343         require(_msgSender() == _feeAddrWallet);
344         uint256 contractETHBalance = address(this).balance;
345         sendETHToFee(contractETHBalance);
346     }
347 
348 
349     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
350         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _feeAddr1, _feeAddr2);
351         uint256 currentRate =  _getRate();
352         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
353         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
354     }
355 
356     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
357         uint256 tFee = tAmount.mul(taxFee).div(100);
358         uint256 tTeam = tAmount.mul(TeamFee).div(100);
359         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
360         return (tTransferAmount, tFee, tTeam);
361     }
362 
363     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
364         uint256 rAmount = tAmount.mul(currentRate);
365         uint256 rFee = tFee.mul(currentRate);
366         uint256 rTeam = tTeam.mul(currentRate);
367         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
368         return (rAmount, rTransferAmount, rFee);
369     }
370 
371 	function _getRate() private view returns(uint256) {
372         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
373         return rSupply.div(tSupply);
374     }
375 
376     function _getCurrentSupply() private view returns(uint256, uint256) {
377         uint256 rSupply = _rTotal;
378         uint256 tSupply = _tTotal;
379         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
380         return (rSupply, tSupply);
381     }
382 }