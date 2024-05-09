1 /**
2 
3 Tax : 0/0
4 
5 Total supply:
6 1,000,000,000
7 Max Buy:
8 20,000,000
9 Max Wallet:
10 20,000,000
11 
12 Medium 
13 https://medium.com/@Uketamo/uketamo-the-philosophy-to-live-by-cedb1d7e4c74
14 Locked for 150 days 
15 https://www.team.finance/view-coin/0x6dD8106609BF0f0D703abc12585Fea32502f3A2E?name=Uketamo&symbol=Uketamo
16 Renounced
17 https://www.etherscan.io/tx/0xdd8487c46618c28bb209ad9641935ac2d13b1c7b476cbb1d72e59075e01adcbe
18 
19 */
20 
21 // SPDX-License-Identifier: MIT
22 
23 pragma solidity 0.8.16;
24 
25 abstract contract Context {
26     function _msgSender() internal view virtual returns (address) {
27         return msg.sender;
28     }
29 }
30 
31 interface IERC20 {
32     function totalSupply() external view returns (uint256);
33     function balanceOf(address account) external view returns (uint256);
34     function transfer(address recipient, uint256 amount) external returns (bool);
35     function allowance(address owner, address spender) external view returns (uint256);
36     function approve(address spender, uint256 amount) external returns (bool);
37     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
38     event Transfer(address indexed from, address indexed to, uint256 value);
39     event Approval(address indexed owner, address indexed spender, uint256 value);
40 }
41 
42 library SafeMath {
43     function add(uint256 a, uint256 b) internal pure returns (uint256) {
44         uint256 c = a + b;
45         require(c >= a, "SafeMath: addition overflow");
46         return c;
47     }
48 
49     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
50         return sub(a, b, "SafeMath: subtraction overflow");
51     }
52 
53     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
54         require(b <= a, errorMessage);
55         uint256 c = a - b;
56         return c;
57     }
58 
59     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
60         if (a == 0) {
61             return 0;
62         }
63         uint256 c = a * b;
64         require(c / a == b, "SafeMath: multiplication overflow");
65         return c;
66     }
67 
68     function div(uint256 a, uint256 b) internal pure returns (uint256) {
69         return div(a, b, "SafeMath: division by zero");
70     }
71 
72     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
73         require(b > 0, errorMessage);
74         uint256 c = a / b;
75         return c;
76     }
77 
78 }
79 
80 contract Ownable is Context {
81     address private _owner;
82     address private _previousOwner;
83     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
84 
85     constructor () {
86         address msgSender = _msgSender();
87         _owner = msgSender;
88         emit OwnershipTransferred(address(0), msgSender);
89     }
90 
91     function owner() public view returns (address) {
92         return _owner;
93     }
94 
95     modifier onlyOwner() {
96         require(_owner == _msgSender(), "Ownable: caller is not the owner");
97         _;
98     }
99 
100     function renounceOwnership() public virtual onlyOwner {
101         emit OwnershipTransferred(_owner, address(0));
102         _owner = address(0);
103     }
104 
105 }
106 
107 interface IUniswapV2Factory {
108     function createPair(address tokenA, address tokenB) external returns (address pair);
109 }
110 
111 interface IUniswapV2Router02 {
112     function swapExactTokensForETHSupportingFeeOnTransferTokens(
113         uint amountIn,
114         uint amountOutMin,
115         address[] calldata path,
116         address to,
117         uint deadline
118     ) external;
119     function factory() external pure returns (address);
120     function WETH() external pure returns (address);
121     function addLiquidityETH(
122         address token,
123         uint amountTokenDesired,
124         uint amountTokenMin,
125         uint amountETHMin,
126         address to,
127         uint deadline
128     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
129 }
130 
131 contract Uketamo is Context, IERC20, Ownable {
132     using SafeMath for uint256;
133     mapping (address => uint256) private _rOwned;
134     mapping (address => uint256) private _tOwned;
135     mapping (address => mapping (address => uint256)) private _allowances;
136     mapping (address => bool) private _isExcludedFromFee;
137     mapping (address => bool) private bots;
138     mapping (address => uint) private cooldown;
139     uint256 private constant MAX = ~uint256(0);
140     uint256 private constant _tTotal = 1_000_000_000 * 10**8;
141     uint256 private _rTotal = (MAX - (MAX % _tTotal));
142     uint256 private _tFeeTotal;
143 
144     uint256 private _feeAddr1;
145     uint256 private _feeAddr2;
146     uint256 private _initialTax;
147     uint256 private _finalTax;
148     uint256 private _reduceTaxCountdown;
149     address payable private _feeAddrWallet;
150 
151     string private constant _name = "Uketamo";
152     string private constant _symbol = "Uketamo";
153     uint8 private constant _decimals = 8;
154 
155     IUniswapV2Router02 private uniswapV2Router;
156     address private uniswapV2Pair;
157     bool private tradingOpen;
158     bool private inSwap = false;
159     bool private swapEnabled = false;
160     bool private cooldownEnabled = false;
161     uint256 public _maxTxAmount = 20_000_000 * 10**8;
162     uint256 public _maxWalletSize = 20_000_000 * 10**8;
163     event MaxTxAmountUpdated(uint _maxTxAmount);
164     modifier lockTheSwap {
165         inSwap = true;
166         _;
167         inSwap = false;
168     }
169 
170     constructor () {
171         _feeAddrWallet = payable(_msgSender());
172         _rOwned[_msgSender()] = _rTotal;
173         _isExcludedFromFee[owner()] = true;
174         _isExcludedFromFee[address(this)] = true;
175         _isExcludedFromFee[_feeAddrWallet] = true;
176         _initialTax=2;
177         _finalTax=0;
178         _reduceTaxCountdown=60;
179 
180         emit Transfer(address(0), _msgSender(), _tTotal);
181     }
182 
183     function name() public pure returns (string memory) {
184         return _name;
185     }
186 
187     function symbol() public pure returns (string memory) {
188         return _symbol;
189     }
190 
191     function decimals() public pure returns (uint8) {
192         return _decimals;
193     }
194 
195     function totalSupply() public pure override returns (uint256) {
196         return _tTotal;
197     }
198 
199     function balanceOf(address account) public view override returns (uint256) {
200         return tokenFromReflection(_rOwned[account]);
201     }
202 
203     function transfer(address recipient, uint256 amount) public override returns (bool) {
204         _transfer(_msgSender(), recipient, amount);
205         return true;
206     }
207 
208     function allowance(address owner, address spender) public view override returns (uint256) {
209         return _allowances[owner][spender];
210     }
211 
212     function approve(address spender, uint256 amount) public override returns (bool) {
213         _approve(_msgSender(), spender, amount);
214         return true;
215     }
216 
217     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
218         _transfer(sender, recipient, amount);
219         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
220         return true;
221     }
222 
223     function setCooldownEnabled(bool onoff) external onlyOwner() {
224         cooldownEnabled = onoff;
225     }
226 
227     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
228         require(rAmount <= _rTotal, "Amount must be less than total reflections");
229         uint256 currentRate =  _getRate();
230         return rAmount.div(currentRate);
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
245 
246         if (from != owner() && to != owner()) {
247             require(!bots[from] && !bots[to]);
248             _feeAddr1 = 0;
249             _feeAddr2 = (_reduceTaxCountdown==0)?_finalTax:_initialTax;
250             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
251                 // Cooldown
252                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
253                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
254                 if(_reduceTaxCountdown>0){_reduceTaxCountdown--;}
255             }
256 
257 
258             uint256 contractTokenBalance = balanceOf(address(this));
259             if (!inSwap && from != uniswapV2Pair && swapEnabled && contractTokenBalance>0 && _reduceTaxCountdown<30) {
260                 swapTokensForEth(contractTokenBalance);
261                 uint256 contractETHBalance = address(this).balance;
262                 if(contractETHBalance > 0) {
263                     sendETHToFee(address(this).balance);
264                 }
265             }
266         }else{
267           _feeAddr1 = 0;
268           _feeAddr2 = 0;
269         }
270 
271         _tokenTransfer(from,to,amount);
272     }
273 
274     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
275         address[] memory path = new address[](2);
276         path[0] = address(this);
277         path[1] = uniswapV2Router.WETH();
278         _approve(address(this), address(uniswapV2Router), tokenAmount);
279         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
280             tokenAmount,
281             0,
282             path,
283             address(this),
284             block.timestamp
285         );
286     }
287 
288 
289     function removeLimits() external onlyOwner{
290         _maxTxAmount = _tTotal;
291         _maxWalletSize = _tTotal;
292     }
293 
294     function sendETHToFee(uint256 amount) private {
295         _feeAddrWallet.transfer(amount);
296     }
297 
298     function addBots(address[] memory bots_) public onlyOwner {
299         for (uint i = 0; i < bots_.length; i++) {
300             bots[bots_[i]] = true;
301         }
302     }
303 
304     function delBots(address[] memory notbot) public onlyOwner {
305       for (uint i = 0; i < notbot.length; i++) {
306           bots[notbot[i]] = false;
307       }
308 
309     }
310 
311     function openTrading() external onlyOwner() {
312         require(!tradingOpen,"trading is already open");
313         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
314         uniswapV2Router = _uniswapV2Router;
315         _approve(address(this), address(uniswapV2Router), _tTotal);
316         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
317         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
318         swapEnabled = true;
319         cooldownEnabled = true;
320 
321         tradingOpen = true;
322         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
323     }
324 
325     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
326         _transferStandard(sender, recipient, amount);
327     }
328 
329     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
330         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
331         _rOwned[sender] = _rOwned[sender].sub(rAmount);
332         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
333         _takeTeam(tTeam);
334         _reflectFee(rFee, tFee);
335         emit Transfer(sender, recipient, tTransferAmount);
336     }
337 
338     function _takeTeam(uint256 tTeam) private {
339         uint256 currentRate =  _getRate();
340         uint256 rTeam = tTeam.mul(currentRate);
341         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
342     }
343 
344     function _reflectFee(uint256 rFee, uint256 tFee) private {
345         _rTotal = _rTotal.sub(rFee);
346         _tFeeTotal = _tFeeTotal.add(tFee);
347     }
348 
349     receive() external payable {}
350 
351     function manualswap() external {
352         require(_msgSender() == _feeAddrWallet);
353         uint256 contractBalance = balanceOf(address(this));
354         swapTokensForEth(contractBalance);
355     }
356 
357     function manualsend() external {
358         require(_msgSender() == _feeAddrWallet);
359         uint256 contractETHBalance = address(this).balance;
360         sendETHToFee(contractETHBalance);
361     }
362 
363 
364     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
365         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _feeAddr1, _feeAddr2);
366         uint256 currentRate =  _getRate();
367         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
368         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
369     }
370 
371     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
372         uint256 tFee = tAmount.mul(taxFee).div(100);
373         uint256 tTeam = tAmount.mul(TeamFee).div(100);
374         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
375         return (tTransferAmount, tFee, tTeam);
376     }
377 
378     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
379         uint256 rAmount = tAmount.mul(currentRate);
380         uint256 rFee = tFee.mul(currentRate);
381         uint256 rTeam = tTeam.mul(currentRate);
382         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
383         return (rAmount, rTransferAmount, rFee);
384     }
385 
386 	function _getRate() private view returns(uint256) {
387         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
388         return rSupply.div(tSupply);
389     }
390 
391     function _getCurrentSupply() private view returns(uint256, uint256) {
392         uint256 rSupply = _rTotal;
393         uint256 tSupply = _tTotal;
394         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
395         return (rSupply, tSupply);
396     }
397 }