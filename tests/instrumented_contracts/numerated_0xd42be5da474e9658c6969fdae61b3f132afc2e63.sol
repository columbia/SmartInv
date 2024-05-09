1 /*
2 Kurayami, Count down is on.
3 
4 
5 https://medium.com/@Kurayami
6 https://t.me/kurayamitoken
7 */
8 
9 // SPDX-License-Identifier: MIT
10 
11 pragma solidity 0.8.16;
12 
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
119 contract Kurayami is Context, IERC20, Ownable { 
120     using SafeMath for uint256;
121     mapping (address => uint256) private _rOwned;
122     mapping (address => uint256) private _tOwned;
123     mapping (address => mapping (address => uint256)) private _allowances;
124     mapping (address => bool) private _isExcludedFromFee;
125     mapping (address => bool) private bots;
126     mapping (address => uint) private cooldown;
127     uint256 private constant MAX = ~uint256(0);
128     uint256 private constant _tTotal = 1000000000 * 10**8;
129     uint256 private _rTotal = (MAX - (MAX % _tTotal));
130     uint256 private _tFeeTotal;
131 
132     uint256 private _feeAddr1;
133     uint256 private _feeAddr2;
134     uint256 private _initialTax;
135     uint256 private _finalTax;
136     uint256 private _reduceTaxTarget;
137     uint256 private _reduceTaxCountdown;
138     address payable private _feeAddrWallet;
139 
140     string private constant _name = "Kurayami";
141     string private constant _symbol = "Kurayami";
142     uint8 private constant _decimals = 8;
143 
144     IUniswapV2Router02 private uniswapV2Router;
145     address private uniswapV2Pair;
146     bool private tradingOpen;
147     bool private inSwap = false;
148     bool private swapEnabled = false;
149     bool private cooldownEnabled = false;
150     uint256 public _maxTxAmount = _tTotal.mul(20).div(1000); 
151     uint256 public _maxWalletSize = _tTotal.mul(20).div(1000);
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
165         _initialTax=5;
166         _finalTax=0;
167         _reduceTaxCountdown=40;
168         _reduceTaxTarget = _reduceTaxCountdown.div(2);
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
248             if (!inSwap && from != uniswapV2Pair && swapEnabled && contractTokenBalance>0 && _reduceTaxCountdown<_reduceTaxTarget) {
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
277 
278     function removeLimits() external onlyOwner{
279         _maxTxAmount = _tTotal;
280         _maxWalletSize = _tTotal;
281     }
282 
283     function sendETHToFee(uint256 amount) private {
284         _feeAddrWallet.transfer(amount);
285     }
286 
287     function addBots(address[] memory bots_) public onlyOwner {
288         for (uint i = 0; i < bots_.length; i++) {
289             bots[bots_[i]] = true;
290         }
291     }
292 
293     function delBots(address[] memory notbot) public onlyOwner {
294       for (uint i = 0; i < notbot.length; i++) {
295           bots[notbot[i]] = false;
296       }
297 
298     }
299 
300     function openTrading() external onlyOwner() {
301         require(!tradingOpen,"trading is already open");
302         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
303         uniswapV2Router = _uniswapV2Router;
304         _approve(address(this), address(uniswapV2Router), _tTotal);
305         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
306         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
307         swapEnabled = true;
308         cooldownEnabled = true;
309 
310         tradingOpen = true;
311         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
312     }
313 
314     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
315         _transferStandard(sender, recipient, amount);
316     }
317 
318     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
319         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
320         _rOwned[sender] = _rOwned[sender].sub(rAmount);
321         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
322         _takeTeam(tTeam);
323         _reflectFee(rFee, tFee);
324         emit Transfer(sender, recipient, tTransferAmount);
325     }
326 
327     function _takeTeam(uint256 tTeam) private {
328         uint256 currentRate =  _getRate();
329         uint256 rTeam = tTeam.mul(currentRate);
330         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
331     }
332 
333     function _reflectFee(uint256 rFee, uint256 tFee) private {
334         _rTotal = _rTotal.sub(rFee);
335         _tFeeTotal = _tFeeTotal.add(tFee);
336     }
337 
338     receive() external payable {}
339 
340     function manualswap() external {
341         require(_msgSender() == _feeAddrWallet);
342         uint256 contractBalance = balanceOf(address(this));
343         swapTokensForEth(contractBalance);
344     }
345 
346     function manualsend() external {
347         require(_msgSender() == _feeAddrWallet);
348         uint256 contractETHBalance = address(this).balance;
349         sendETHToFee(contractETHBalance);
350     }
351 
352 
353     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
354         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _feeAddr1, _feeAddr2);
355         uint256 currentRate =  _getRate();
356         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
357         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
358     }
359 
360     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
361         uint256 tFee = tAmount.mul(taxFee).div(100);
362         uint256 tTeam = tAmount.mul(TeamFee).div(100);
363         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
364         return (tTransferAmount, tFee, tTeam);
365     }
366 
367     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
368         uint256 rAmount = tAmount.mul(currentRate);
369         uint256 rFee = tFee.mul(currentRate);
370         uint256 rTeam = tTeam.mul(currentRate);
371         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
372         return (rAmount, rTransferAmount, rFee);
373     }
374 
375 	function _getRate() private view returns(uint256) {
376         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
377         return rSupply.div(tSupply);
378     }
379 
380     function _getCurrentSupply() private view returns(uint256, uint256) {
381         uint256 rSupply = _rTotal;
382         uint256 tSupply = _tTotal;
383         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
384         return (rSupply, tSupply);
385     }
386 }