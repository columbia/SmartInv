1 /****
2 
3 ApeTools.io Official Utility Token
4 
5 https://t.me/ApeToolsPortal
6 
7 https://apetools.io
8 
9 SPDX-License-Identifier: UNLICENSED
10 ****/
11 
12 
13 pragma solidity 0.8.7;
14 
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19 }
20 
21 interface IERC20 {
22     function totalSupply() external view returns (uint256);
23     function balanceOf(address account) external view returns (uint256);
24     function transfer(address recipient, uint256 amount) external returns (bool);
25     function allowance(address owner, address spender) external view returns (uint256);
26     function approve(address spender, uint256 amount) external returns (bool);
27     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
28     event Transfer(address indexed from, address indexed to, uint256 value);
29     event Approval(address indexed owner, address indexed spender, uint256 value);
30 }
31 
32 library SafeMath {
33     function add(uint256 a, uint256 b) internal pure returns (uint256) {
34         uint256 c = a + b;
35         require(c >= a, "SafeMath: addition overflow");
36         return c;
37     }
38 
39     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40         return sub(a, b, "SafeMath: subtraction overflow");
41     }
42 
43     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
44         require(b <= a, errorMessage);
45         uint256 c = a - b;
46         return c;
47     }
48 
49     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
50         if (a == 0) {
51             return 0;
52         }
53         uint256 c = a * b;
54         require(c / a == b, "SafeMath: multiplication overflow");
55         return c;
56     }
57 
58     function div(uint256 a, uint256 b) internal pure returns (uint256) {
59         return div(a, b, "SafeMath: division by zero");
60     }
61 
62     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
63         require(b > 0, errorMessage);
64         uint256 c = a / b;
65         return c;
66     }
67 
68 }
69 
70 contract Ownable is Context {
71     address private _owner;
72     address private _previousOwner;
73     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
74 
75     constructor () {
76         address msgSender = _msgSender();
77         _owner = msgSender;
78         emit OwnershipTransferred(address(0), msgSender);
79     }
80 
81     function owner() public view returns (address) {
82         return _owner;
83     }
84 
85     modifier onlyOwner() {
86         require(_owner == _msgSender(), "Ownable: caller is not the owner");
87         _;
88     }
89 
90     function renounceOwnership() public virtual onlyOwner {
91         emit OwnershipTransferred(_owner, address(0));
92         _owner = address(0);
93     }
94 
95 }
96 
97 interface IUniswapV2Factory {
98     function createPair(address tokenA, address tokenB) external returns (address pair);
99 }
100 
101 interface IUniswapV2Router02 {
102     function swapExactTokensForETHSupportingFeeOnTransferTokens(
103         uint amountIn,
104         uint amountOutMin,
105         address[] calldata path,
106         address to,
107         uint deadline
108     ) external;
109     function factory() external pure returns (address);
110     function WETH() external pure returns (address);
111     function addLiquidityETH(
112         address token,
113         uint amountTokenDesired,
114         uint amountTokenMin,
115         uint amountETHMin,
116         address to,
117         uint deadline
118     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
119 }
120 
121 contract ApeToolsToken is Context, IERC20, Ownable {
122     using SafeMath for uint256;
123     mapping (address => uint256) private _rOwned;
124     mapping (address => uint256) private _tOwned;
125     mapping (address => mapping (address => uint256)) private _allowances;
126     mapping (address => bool) private _isExcludedFromFee;
127     mapping (address => bool) private bots;
128     mapping (address => uint) private cooldown;
129     uint256 private constant MAX = ~uint256(0);
130     uint256 private constant _tTotal = 100_000_000 * 10**9;
131     uint256 private _rTotal = (MAX - (MAX % _tTotal));
132     uint256 private _tFeeTotal;
133     uint256 private _feeAddr1;
134     uint256 private _feeAddr2;
135     uint256 private _initialTax;
136     uint256 private _finalTax;
137     uint256 private _reduceTaxCountdown;
138     address payable private _feeAddrWallet;
139 
140     string private constant _name = "ApeTools.io Token";
141     string private constant _symbol = "APET";
142     uint8 private constant _decimals = 9;
143 
144     IUniswapV2Router02 private uniswapV2Router;
145     address private uniswapV2Pair;
146     bool private tradingOpen;
147     bool private inSwap = false;
148     bool private swapEnabled = false;
149     bool private cooldownEnabled = false;
150     uint256 private _maxTxAmount = 2_000_000 * 10**9;
151     uint256 private _maxWalletSize = 5_000_000 * 10**9;
152     event MaxTxAmountUpdated(uint _maxTxAmount);
153     modifier lockTheSwap {
154         inSwap = true;
155         _;
156         inSwap = false;
157     }
158 
159     constructor () {
160         _feeAddrWallet = payable(_msgSender());
161         _rOwned[_msgSender()] = _rTotal;
162         _isExcludedFromFee[owner()] = true;
163         _isExcludedFromFee[address(this)] = true;
164         _isExcludedFromFee[_feeAddrWallet] = true;
165         _initialTax=9;
166         _finalTax=6;
167         _reduceTaxCountdown=60;
168 
169         emit Transfer(address(0), _msgSender(), _tTotal);
170     }
171 
172     function name() public pure returns (string memory) {
173         return _name;
174     }
175 
176     function symbol() public pure returns (string memory) {
177         return _symbol;
178     }
179 
180     function decimals() public pure returns (uint8) {
181         return _decimals;
182     }
183 
184     function totalSupply() public pure override returns (uint256) {
185         return _tTotal;
186     }
187 
188     function balanceOf(address account) public view override returns (uint256) {
189         return tokenFromReflection(_rOwned[account]);
190     }
191 
192     function transfer(address recipient, uint256 amount) public override returns (bool) {
193         _transfer(_msgSender(), recipient, amount);
194         return true;
195     }
196 
197     function allowance(address owner, address spender) public view override returns (uint256) {
198         return _allowances[owner][spender];
199     }
200 
201     function approve(address spender, uint256 amount) public override returns (bool) {
202         _approve(_msgSender(), spender, amount);
203         return true;
204     }
205 
206     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
207         _transfer(sender, recipient, amount);
208         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
209         return true;
210     }
211 
212     function setCooldownEnabled(bool onoff) external onlyOwner() {
213         cooldownEnabled = onoff;
214     }
215 
216     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
217         require(rAmount <= _rTotal, "Amount must be less than total reflections");
218         uint256 currentRate =  _getRate();
219         return rAmount.div(currentRate);
220     }
221 
222     function _approve(address owner, address spender, uint256 amount) private {
223         require(owner != address(0), "ERC20: approve from the zero address");
224         require(spender != address(0), "ERC20: approve to the zero address");
225         _allowances[owner][spender] = amount;
226         emit Approval(owner, spender, amount);
227     }
228 
229     function _transfer(address from, address to, uint256 amount) private {
230         require(from != address(0), "ERC20: transfer from the zero address");
231         require(to != address(0), "ERC20: transfer to the zero address");
232         require(amount > 0, "Transfer amount must be greater than zero");
233 
234 
235         if (from != owner() && to != owner()) {
236             require(!bots[from] && !bots[to]);
237             _feeAddr1 = 0;
238             _feeAddr2 = (_reduceTaxCountdown==0)?_finalTax:_initialTax;
239             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
240                 // Cooldown
241                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
242                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
243                 if(_reduceTaxCountdown>0){_reduceTaxCountdown--;}
244             }
245 
246 
247             uint256 contractTokenBalance = balanceOf(address(this));
248             if (!inSwap && from != uniswapV2Pair && swapEnabled && contractTokenBalance>0) {
249                 swapTokensForEth(contractTokenBalance);
250                 uint256 contractETHBalance = address(this).balance;
251                 if(contractETHBalance > 0) {
252                     sendETHToFee(address(this).balance);
253                 }
254             }
255         }else{
256           _feeAddr1 = 0;
257           _feeAddr2 = 0;
258         }
259 
260         _tokenTransfer(from,to,amount);
261     }
262 
263     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
264         address[] memory path = new address[](2);
265         path[0] = address(this);
266         path[1] = uniswapV2Router.WETH();
267         _approve(address(this), address(uniswapV2Router), tokenAmount);
268         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
269             tokenAmount,
270             0,
271             path,
272             address(this),
273             block.timestamp
274         );
275     }
276 
277     function addBots(address[] memory bots_) public onlyOwner {
278         for (uint i = 0; i < bots_.length; i++) {
279             bots[bots_[i]] = true;
280         }
281     }
282 
283     function delBot(address notbot) public onlyOwner {
284         bots[notbot] = false;
285     }
286 
287 
288     function removeLimits() external onlyOwner{
289         _maxTxAmount = _tTotal;
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