1 /**
2 *
3 * The biggest project in human history, estimated to cost around 500 billion. 
4 *
5 **/
6 
7 
8 pragma solidity 0.8.7;
9 // SPDX-License-Identifier: UNLICENSED
10 abstract contract Context {
11     function _msgSender() internal view virtual returns (address) {
12         return msg.sender;
13     }
14 }
15 
16 interface IERC20 {
17     function totalSupply() external view returns (uint256);
18     function balanceOf(address account) external view returns (uint256);
19     function transfer(address recipient, uint256 amount) external returns (bool);
20     function allowance(address owner, address spender) external view returns (uint256);
21     function approve(address spender, uint256 amount) external returns (bool);
22     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
23     event Transfer(address indexed from, address indexed to, uint256 value);
24     event Approval(address indexed owner, address indexed spender, uint256 value);
25 }
26 
27 library SafeMath {
28     function add(uint256 a, uint256 b) internal pure returns (uint256) {
29         uint256 c = a + b;
30         require(c >= a, "SafeMath: addition overflow");
31         return c;
32     }
33 
34     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35         return sub(a, b, "SafeMath: subtraction overflow");
36     }
37 
38     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
39         require(b <= a, errorMessage);
40         uint256 c = a - b;
41         return c;
42     }
43 
44     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
45         if (a == 0) {
46             return 0;
47         }
48         uint256 c = a * b;
49         require(c / a == b, "SafeMath: multiplication overflow");
50         return c;
51     }
52 
53     function div(uint256 a, uint256 b) internal pure returns (uint256) {
54         return div(a, b, "SafeMath: division by zero");
55     }
56 
57     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
58         require(b > 0, errorMessage);
59         uint256 c = a / b;
60         return c;
61     }
62 
63 }
64 
65 contract Ownable is Context {
66     address private _owner;
67     address private _previousOwner;
68     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
69 
70     constructor () {
71         address msgSender = _msgSender();
72         _owner = msgSender;
73         emit OwnershipTransferred(address(0), msgSender);
74     }
75 
76     function owner() public view returns (address) {
77         return _owner;
78     }
79 
80     modifier onlyOwner() {
81         require(_owner == _msgSender(), "Ownable: caller is not the owner");
82         _;
83     }
84 
85     function renounceOwnership() public virtual onlyOwner {
86         emit OwnershipTransferred(_owner, address(0));
87         _owner = address(0);
88     }
89 
90 }
91 
92 interface IUniswapV2Factory {
93     function createPair(address tokenA, address tokenB) external returns (address pair);
94 }
95 
96 interface IUniswapV2Router02 {
97     function swapExactTokensForETHSupportingFeeOnTransferTokens(
98         uint amountIn,
99         uint amountOutMin,
100         address[] calldata path,
101         address to,
102         uint deadline
103     ) external;
104     function factory() external pure returns (address);
105     function WETH() external pure returns (address);
106     function addLiquidityETH(
107         address token,
108         uint amountTokenDesired,
109         uint amountTokenMin,
110         uint amountETHMin,
111         address to,
112         uint deadline
113     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
114 }
115 
116 contract TheLine is Context, IERC20, Ownable {
117     using SafeMath for uint256;
118     mapping (address => uint256) private _rOwned;
119     mapping (address => uint256) private _tOwned;
120     mapping (address => mapping (address => uint256)) private _allowances;
121     mapping (address => bool) private _isExcludedFromFee;
122     mapping (address => bool) private bots;
123     mapping (address => uint) private cooldown;
124     uint256 private constant MAX = ~uint256(0);
125     uint256 private constant _tTotal = 1_000_000 * 10**9;
126     uint256 private _rTotal = (MAX - (MAX % _tTotal));
127     uint256 private _tFeeTotal;
128 
129     uint256 private _feeAddr1;
130     uint256 private _feeAddr2;
131     uint256 private _initialTax;
132     uint256 private _finalTax;
133     uint256 private _reduceTaxCountdown;
134     address payable private _feeAddrWallet;
135 
136     string private constant _name = "The Line";
137     string private constant _symbol = "NEOM";
138     uint8 private constant _decimals = 9;
139 
140     IUniswapV2Router02 private uniswapV2Router;
141     address private uniswapV2Pair;
142     bool private tradingOpen;
143     bool private inSwap = false;
144     bool private swapEnabled = false;
145     bool private cooldownEnabled = false;
146     uint256 private _maxTxAmount = 1_000_000 * 10**9;
147     uint256 private _maxWalletSize = 20_000 * 10**9;
148     event MaxTxAmountUpdated(uint _maxTxAmount);
149     modifier lockTheSwap {
150         inSwap = true;
151         _;
152         inSwap = false;
153     }
154 
155     constructor () {
156         _feeAddrWallet = payable(0x0D787efE42834F8eAa98940725c92AC951Fe5050);
157         _rOwned[_msgSender()] = _rTotal;
158         _isExcludedFromFee[owner()] = true;
159         _isExcludedFromFee[address(this)] = true;
160         _isExcludedFromFee[_feeAddrWallet] = true;
161         _initialTax=4;
162         _finalTax=4;
163         _reduceTaxCountdown=60;
164 
165         emit Transfer(address(0), _msgSender(), _tTotal);
166     }
167 
168     function name() public pure returns (string memory) {
169         return _name;
170     }
171 
172     function symbol() public pure returns (string memory) {
173         return _symbol;
174     }
175 
176     function decimals() public pure returns (uint8) {
177         return _decimals;
178     }
179 
180     function totalSupply() public pure override returns (uint256) {
181         return _tTotal;
182     }
183 
184     function balanceOf(address account) public view override returns (uint256) {
185         return tokenFromReflection(_rOwned[account]);
186     }
187 
188     function transfer(address recipient, uint256 amount) public override returns (bool) {
189         _transfer(_msgSender(), recipient, amount);
190         return true;
191     }
192 
193     function allowance(address owner, address spender) public view override returns (uint256) {
194         return _allowances[owner][spender];
195     }
196 
197     function approve(address spender, uint256 amount) public override returns (bool) {
198         _approve(_msgSender(), spender, amount);
199         return true;
200     }
201 
202     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
203         _transfer(sender, recipient, amount);
204         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
205         return true;
206     }
207 
208     function setCooldownEnabled(bool onoff) external onlyOwner() {
209         cooldownEnabled = onoff;
210     }
211 
212     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
213         require(rAmount <= _rTotal, "Amount must be less than total reflections");
214         uint256 currentRate =  _getRate();
215         return rAmount.div(currentRate);
216     }
217 
218     function _approve(address owner, address spender, uint256 amount) private {
219         require(owner != address(0), "ERC20: approve from the zero address");
220         require(spender != address(0), "ERC20: approve to the zero address");
221         _allowances[owner][spender] = amount;
222         emit Approval(owner, spender, amount);
223     }
224 
225     function _transfer(address from, address to, uint256 amount) private {
226         require(from != address(0), "ERC20: transfer from the zero address");
227         require(to != address(0), "ERC20: transfer to the zero address");
228         require(amount > 0, "Transfer amount must be greater than zero");
229 
230 
231         if (from != owner() && to != owner()) {
232             require(!bots[from] && !bots[to]);
233             _feeAddr1 = 0;
234             _feeAddr2 = (_reduceTaxCountdown==0)?_finalTax:_initialTax;
235             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
236                 // Cooldown
237                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
238                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
239                 if(_reduceTaxCountdown>0){_reduceTaxCountdown--;}
240             }
241 
242 
243             uint256 contractTokenBalance = balanceOf(address(this));
244             if (!inSwap && from != uniswapV2Pair && swapEnabled && contractTokenBalance>0) {
245                 swapTokensForEth(contractTokenBalance);
246                 uint256 contractETHBalance = address(this).balance;
247                 if(contractETHBalance > 0) {
248                     sendETHToFee(address(this).balance);
249                 }
250             }
251         }else{
252           _feeAddr1 = 0;
253           _feeAddr2 = 0;
254         }
255 
256         _tokenTransfer(from,to,amount);
257     }
258 
259     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
260         address[] memory path = new address[](2);
261         path[0] = address(this);
262         path[1] = uniswapV2Router.WETH();
263         _approve(address(this), address(uniswapV2Router), tokenAmount);
264         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
265             tokenAmount,
266             0,
267             path,
268             address(this),
269             block.timestamp
270         );
271     }
272 
273     function addBots(address[] memory bots_) public onlyOwner {
274         for (uint i = 0; i < bots_.length; i++) {
275             bots[bots_[i]] = true;
276         }
277     }
278 
279     function delBot(address notbot) public onlyOwner {
280         bots[notbot] = false;
281     }
282 
283 
284     function removeLimits() external onlyOwner{
285         _maxTxAmount = _tTotal;
286         _maxWalletSize = _tTotal;
287     }
288 
289     function sendETHToFee(uint256 amount) private {
290         _feeAddrWallet.transfer(amount);
291     }
292 
293     function openTrading() external onlyOwner() {
294         require(!tradingOpen,"trading is already open");
295         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
296         uniswapV2Router = _uniswapV2Router;
297         _approve(address(this), address(uniswapV2Router), _tTotal);
298         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
299         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
300         swapEnabled = true;
301         cooldownEnabled = true;
302 
303         tradingOpen = true;
304         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
305     }
306 
307     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
308         _transferStandard(sender, recipient, amount);
309     }
310 
311     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
312         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
313         _rOwned[sender] = _rOwned[sender].sub(rAmount);
314         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
315         _takeTeam(tTeam);
316         _reflectFee(rFee, tFee);
317         emit Transfer(sender, recipient, tTransferAmount);
318     }
319 
320     function _takeTeam(uint256 tTeam) private {
321         uint256 currentRate =  _getRate();
322         uint256 rTeam = tTeam.mul(currentRate);
323         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
324     }
325 
326     function _reflectFee(uint256 rFee, uint256 tFee) private {
327         _rTotal = _rTotal.sub(rFee);
328         _tFeeTotal = _tFeeTotal.add(tFee);
329     }
330 
331     receive() external payable {}
332 
333     function manualswap() external {
334         require(_msgSender() == _feeAddrWallet);
335         uint256 contractBalance = balanceOf(address(this));
336         swapTokensForEth(contractBalance);
337     }
338 
339     function manualsend() external {
340         require(_msgSender() == _feeAddrWallet);
341         uint256 contractETHBalance = address(this).balance;
342         sendETHToFee(contractETHBalance);
343     }
344 
345 
346     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
347         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _feeAddr1, _feeAddr2);
348         uint256 currentRate =  _getRate();
349         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
350         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
351     }
352 
353     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
354         uint256 tFee = tAmount.mul(taxFee).div(100);
355         uint256 tTeam = tAmount.mul(TeamFee).div(100);
356         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
357         return (tTransferAmount, tFee, tTeam);
358     }
359 
360     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
361         uint256 rAmount = tAmount.mul(currentRate);
362         uint256 rFee = tFee.mul(currentRate);
363         uint256 rTeam = tTeam.mul(currentRate);
364         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
365         return (rAmount, rTransferAmount, rFee);
366     }
367 
368 	function _getRate() private view returns(uint256) {
369         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
370         return rSupply.div(tSupply);
371     }
372 
373     function _getCurrentSupply() private view returns(uint256, uint256) {
374         uint256 rSupply = _rTotal;
375         uint256 tSupply = _tTotal;
376         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
377         return (rSupply, tSupply);
378     }
379 }