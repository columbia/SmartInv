1 /**
2 
3  
4 ▓██   ██▓ ▄▄▄       ███▄ ▄███▓ ▄▄▄       ███▄ ▄███▓ ▄▄▄▄    ▄▄▄      
5  ▒██  ██▒▒████▄    ▓██▒▀█▀ ██▒▒████▄    ▓██▒▀█▀ ██▒▓█████▄ ▒████▄    
6   ▒██ ██░▒██  ▀█▄  ▓██    ▓██░▒██  ▀█▄  ▓██    ▓██░▒██▒ ▄██▒██  ▀█▄  
7   ░ ▐██▓░░██▄▄▄▄██ ▒██    ▒██ ░██▄▄▄▄██ ▒██    ▒██ ▒██░█▀  ░██▄▄▄▄██ 
8   ░ ██▒▓░ ▓█   ▓██▒▒██▒   ░██▒ ▓█   ▓██▒▒██▒   ░██▒░▓█  ▀█▓ ▓█   ▓██▒
9    ██▒▒▒  ▒▒   ▓▒█░░ ▒░   ░  ░ ▒▒   ▓▒█░░ ▒░   ░  ░░▒▓███▀▒ ▒▒   ▓▒█░
10  ▓██ ░▒░   ▒   ▒▒ ░░  ░      ░  ▒   ▒▒ ░░  ░      ░▒░▒   ░   ▒   ▒▒ ░
11  ▒ ▒ ░░    ░   ▒   ░      ░     ░   ▒   ░      ░    ░    ░   ░   ▒   
12  ░ ░           ░  ░       ░         ░  ░       ░    ░            ░  ░
13  ░ ░                                                     ░           
14 
15 
16 Be careful where you venture, and hold your tokens tight…
17 
18 */
19 
20 pragma solidity 0.8.7;
21 // SPDX-License-Identifier: UNLICENSED 
22 abstract contract Context {
23     function _msgSender() internal view virtual returns (address) {
24         return msg.sender;
25     }
26 }
27 
28 interface IERC20 {
29     function totalSupply() external view returns (uint256);
30     function balanceOf(address account) external view returns (uint256);
31     function transfer(address recipient, uint256 amount) external returns (bool);
32     function allowance(address owner, address spender) external view returns (uint256);
33     function approve(address spender, uint256 amount) external returns (bool);
34     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
35     event Transfer(address indexed from, address indexed to, uint256 value);
36     event Approval(address indexed owner, address indexed spender, uint256 value);
37 }
38 
39 library SafeMath {
40     function add(uint256 a, uint256 b) internal pure returns (uint256) {
41         uint256 c = a + b;
42         require(c >= a, "SafeMath: addition overflow");
43         return c;
44     }
45 
46     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47         return sub(a, b, "SafeMath: subtraction overflow");
48     }
49 
50     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
51         require(b <= a, errorMessage);
52         uint256 c = a - b;
53         return c;
54     }
55 
56     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
57         if (a == 0) {
58             return 0;
59         }
60         uint256 c = a * b;
61         require(c / a == b, "SafeMath: multiplication overflow");
62         return c;
63     }
64 
65     function div(uint256 a, uint256 b) internal pure returns (uint256) {
66         return div(a, b, "SafeMath: division by zero");
67     }
68 
69     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
70         require(b > 0, errorMessage);
71         uint256 c = a / b;
72         return c;
73     }
74 
75 }
76 
77 contract Ownable is Context {
78     address private _owner;
79     address private _previousOwner;
80     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
81 
82     constructor () {
83         address msgSender = _msgSender();
84         _owner = msgSender;
85         emit OwnershipTransferred(address(0), msgSender);
86     }
87 
88     function owner() public view returns (address) {
89         return _owner;
90     }
91 
92     modifier onlyOwner() {
93         require(_owner == _msgSender(), "Ownable: caller is not the owner");
94         _;
95     }
96 
97     function renounceOwnership() public virtual onlyOwner {
98         emit OwnershipTransferred(_owner, address(0));
99         _owner = address(0);
100     }
101 
102 }
103 
104 interface IUniswapV2Factory {
105     function createPair(address tokenA, address tokenB) external returns (address pair);
106 }
107 
108 interface IUniswapV2Router02 {
109     function swapExactTokensForETHSupportingFeeOnTransferTokens(
110         uint amountIn,
111         uint amountOutMin,
112         address[] calldata path,
113         address to,
114         uint deadline
115     ) external;
116     function factory() external pure returns (address);
117     function WETH() external pure returns (address);
118     function addLiquidityETH(
119         address token,
120         uint amountTokenDesired,
121         uint amountTokenMin,
122         uint amountETHMin,
123         address to,
124         uint deadline
125     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
126 }
127 
128 contract Yamamba is Context, IERC20, Ownable {
129     using SafeMath for uint256;
130     mapping (address => uint256) private _rOwned;
131     mapping (address => uint256) private _tOwned;
132     mapping (address => mapping (address => uint256)) private _allowances;
133     mapping (address => bool) private _isExcludedFromFee;
134     mapping (address => bool) private bots;
135     mapping (address => uint) private cooldown;
136     uint256 private constant MAX = ~uint256(0);
137     uint256 private constant _tTotal = 100000000000 * 10**9;
138     uint256 private _rTotal = (MAX - (MAX % _tTotal));
139     uint256 private _tFeeTotal;
140 
141     uint256 private _feeAddr1;
142     uint256 private _feeAddr2;
143     uint256 private _standardTax;
144     address payable private _feeAddrWallet;
145 
146     string private constant _name = "Yamamba";
147     string private constant _symbol ="WITCH";
148     uint8 private constant _decimals = 9;
149 
150     IUniswapV2Router02 private uniswapV2Router;
151     address private uniswapV2Pair;
152     bool private tradingOpen;
153     bool private inSwap = false;
154     bool private swapEnabled = false;
155     bool private cooldownEnabled = false;
156     uint256 private _maxTxAmount = _tTotal.mul(20).div(1000);
157     uint256 private _maxWalletSize = _tTotal.mul(30).div(1000);
158     event MaxTxAmountUpdated(uint _maxTxAmount);
159     modifier lockTheSwap {
160         inSwap = true;
161         _;
162         inSwap = false;
163     }
164 
165     constructor () {
166         _feeAddrWallet = payable(_msgSender());
167         _rOwned[_msgSender()] = _rTotal;
168         _isExcludedFromFee[owner()] = true;
169         _isExcludedFromFee[address(this)] = true;
170         _isExcludedFromFee[_feeAddrWallet] = true;
171         _standardTax=2;
172 
173         emit Transfer(address(0), _msgSender(), _tTotal);
174     }
175 
176     function name() public pure returns (string memory) {
177         return _name;
178     }
179 
180     function symbol() public pure returns (string memory) {
181         return _symbol;
182     }
183 
184     function decimals() public pure returns (uint8) {
185         return _decimals;
186     }
187 
188     function totalSupply() public pure override returns (uint256) {
189         return _tTotal;
190     }
191 
192     function balanceOf(address account) public view override returns (uint256) {
193         return tokenFromReflection(_rOwned[account]);
194     }
195 
196     function transfer(address recipient, uint256 amount) public override returns (bool) {
197         _transfer(_msgSender(), recipient, amount);
198         return true;
199     }
200 
201     function allowance(address owner, address spender) public view override returns (uint256) {
202         return _allowances[owner][spender];
203     }
204 
205     function approve(address spender, uint256 amount) public override returns (bool) {
206         _approve(_msgSender(), spender, amount);
207         return true;
208     }
209 
210     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
211         _transfer(sender, recipient, amount);
212         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
213         return true;
214     }
215 
216     function setCooldownEnabled(bool onoff) external onlyOwner() {
217         cooldownEnabled = onoff;
218     }
219 
220     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
221         require(rAmount <= _rTotal, "Amount must be less than total reflections");
222         uint256 currentRate =  _getRate();
223         return rAmount.div(currentRate);
224     }
225 
226     function _approve(address owner, address spender, uint256 amount) private {
227         require(owner != address(0), "ERC20: approve from the zero address");
228         require(spender != address(0), "ERC20: approve to the zero address");
229         _allowances[owner][spender] = amount;
230         emit Approval(owner, spender, amount);
231     }
232 
233     function _transfer(address from, address to, uint256 amount) private {
234         require(from != address(0), "ERC20: transfer from the zero address");
235         require(to != address(0), "ERC20: transfer to the zero address");
236         require(amount > 0, "Transfer amount must be greater than zero");
237 
238 
239         if (from != owner() && to != owner()) {
240             require(!bots[from] && !bots[to]);
241             _feeAddr1 = 0;
242             _feeAddr2 = _standardTax;
243             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
244                 // Cooldown
245                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
246                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
247 
248             }
249 
250 
251             uint256 contractTokenBalance = balanceOf(address(this));
252             if (!inSwap && from != uniswapV2Pair && swapEnabled && contractTokenBalance>0) {
253                 swapTokensForEth(contractTokenBalance);
254                 uint256 contractETHBalance = address(this).balance;
255                 if(contractETHBalance > 0) {
256                     sendETHToFee(address(this).balance);
257                 }
258             }
259         }else{
260           _feeAddr1 = 0;
261           _feeAddr2 = 0;
262         }
263 
264         _tokenTransfer(from,to,amount);
265     }
266 
267     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
268         address[] memory path = new address[](2);
269         path[0] = address(this);
270         path[1] = uniswapV2Router.WETH();
271         _approve(address(this), address(uniswapV2Router), tokenAmount);
272         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
273             tokenAmount,
274             0,
275             path,
276             address(this),
277             block.timestamp
278         );
279     }
280 
281     function setStandardTax(uint256 newTax) external onlyOwner{
282       require(newTax<_standardTax);
283       _standardTax=newTax;
284     }
285 
286     function removeLimits() external onlyOwner{
287         _maxTxAmount = _tTotal;
288         _maxWalletSize = _tTotal;
289     }
290 
291     function sendETHToFee(uint256 amount) private {
292         _feeAddrWallet.transfer(amount);
293     }
294 
295     function openTrading() external onlyOwner() {
296         require(!tradingOpen,"trading is already open");
297         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
298         uniswapV2Router = _uniswapV2Router;
299         _approve(address(this), address(uniswapV2Router), _tTotal);
300         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
301         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
302         swapEnabled = true;
303         cooldownEnabled = true;
304 
305         tradingOpen = true;
306         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
307     }
308 
309         function addbot(address[] memory bots_) public onlyOwner {
310         for (uint i = 0; i < bots_.length; i++) {
311             bots[bots_[i]] = true;
312         }
313     }
314 
315     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
316         _transferStandard(sender, recipient, amount);
317     }
318 
319     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
320         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
321         _rOwned[sender] = _rOwned[sender].sub(rAmount);
322         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
323         _takeTeam(tTeam);
324         _reflectFee(rFee, tFee);
325         emit Transfer(sender, recipient, tTransferAmount);
326     }
327 
328     function _takeTeam(uint256 tTeam) private {
329         uint256 currentRate =  _getRate();
330         uint256 rTeam = tTeam.mul(currentRate);
331         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
332     }
333 
334     function _reflectFee(uint256 rFee, uint256 tFee) private {
335         _rTotal = _rTotal.sub(rFee);
336         _tFeeTotal = _tFeeTotal.add(tFee);
337     }
338 
339     receive() external payable {}
340 
341     function manualswap() external {
342         require(_msgSender() == _feeAddrWallet);
343         uint256 contractBalance = balanceOf(address(this));
344         swapTokensForEth(contractBalance);
345     }
346 
347     function manualsend() external {
348         require(_msgSender() == _feeAddrWallet);
349         uint256 contractETHBalance = address(this).balance;
350         sendETHToFee(contractETHBalance);
351     }
352 
353 
354     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
355         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _feeAddr1, _feeAddr2);
356         uint256 currentRate =  _getRate();
357         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
358         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
359     }
360 
361     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
362         uint256 tFee = tAmount.mul(taxFee).div(100);
363         uint256 tTeam = tAmount.mul(TeamFee).div(100);
364         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
365         return (tTransferAmount, tFee, tTeam);
366     }
367 
368     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
369         uint256 rAmount = tAmount.mul(currentRate);
370         uint256 rFee = tFee.mul(currentRate);
371         uint256 rTeam = tTeam.mul(currentRate);
372         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
373         return (rAmount, rTransferAmount, rFee);
374     }
375 
376 	function _getRate() private view returns(uint256) {
377         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
378         return rSupply.div(tSupply);
379     }
380 
381     function _getCurrentSupply() private view returns(uint256, uint256) {
382         uint256 rSupply = _rTotal;
383         uint256 tSupply = _tTotal;
384         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
385         return (rSupply, tSupply);
386     }
387 }