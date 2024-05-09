1 /**
2 ██████╗░░█████╗░███╗░░██╗███████╗██████╗░░█████╗░██████╗░
3 ██╔══██╗██╔══██╗████╗░██║██╔════╝██╔══██╗██╔══██╗██╔══██╗
4 ██████╦╝██║░░██║██╔██╗██║█████╗░░██████╔╝███████║██║░░██║
5 ██╔══██╗██║░░██║██║╚████║██╔══╝░░██╔═══╝░██╔══██║██║░░██║
6 ██████╦╝╚█████╔╝██║░╚███║███████╗██║░░░░░██║░░██║██████╔╝
7 ╚═════╝░░╚════╝░╚═╝░░╚══╝╚══════╝╚═╝░░░░░╚═╝░░╚═╝╚═════╝░
8 
9 BonePad, all your needs for the Shibarium Chain. 
10 
11 Socials:
12 website: https://bonepad.finance/
13 Telegram: https://t.me/BonePadFinance
14 Twitter: https://twitter.com/bonepadfinance
15 
16 tax: 5/5, Marketing & Development
17 **/
18 
19 pragma solidity 0.8.7;
20 // SPDX-License-Identifier: UNLICENSED
21 abstract contract Context {
22     function _msgSender() internal view virtual returns (address) {
23         return msg.sender;
24     }
25 }
26 
27 interface IERC20 {
28     function totalSupply() external view returns (uint256);
29     function balanceOf(address account) external view returns (uint256);
30     function transfer(address recipient, uint256 amount) external returns (bool);
31     function allowance(address owner, address spender) external view returns (uint256);
32     function approve(address spender, uint256 amount) external returns (bool);
33     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
34     event Transfer(address indexed from, address indexed to, uint256 value);
35     event Approval(address indexed owner, address indexed spender, uint256 value);
36 }
37 
38 library SafeMath {
39     function add(uint256 a, uint256 b) internal pure returns (uint256) {
40         uint256 c = a + b;
41         require(c >= a, "SafeMath: addition overflow");
42         return c;
43     }
44 
45     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
46         return sub(a, b, "SafeMath: subtraction overflow");
47     }
48 
49     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
50         require(b <= a, errorMessage);
51         uint256 c = a - b;
52         return c;
53     }
54 
55     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
56         if (a == 0) {
57             return 0;
58         }
59         uint256 c = a * b;
60         require(c / a == b, "SafeMath: multiplication overflow");
61         return c;
62     }
63 
64     function div(uint256 a, uint256 b) internal pure returns (uint256) {
65         return div(a, b, "SafeMath: division by zero");
66     }
67 
68     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
69         require(b > 0, errorMessage);
70         uint256 c = a / b;
71         return c;
72     }
73 
74 }
75 
76 contract Ownable is Context {
77     address private _owner;
78     address private _previousOwner;
79     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
80 
81     constructor () {
82         address msgSender = _msgSender();
83         _owner = msgSender;
84         emit OwnershipTransferred(address(0), msgSender);
85     }
86 
87     function owner() public view returns (address) {
88         return _owner;
89     }
90 
91     modifier onlyOwner() {
92         require(_owner == _msgSender(), "Ownable: caller is not the owner");
93         _;
94     }
95 
96     function renounceOwnership() public virtual onlyOwner {
97         emit OwnershipTransferred(_owner, address(0));
98         _owner = address(0);
99     }
100 
101 }
102 
103 interface IUniswapV2Factory {
104     function createPair(address tokenA, address tokenB) external returns (address pair);
105 }
106 
107 interface IUniswapV2Router02 {
108     function swapExactTokensForETHSupportingFeeOnTransferTokens(
109         uint amountIn,
110         uint amountOutMin,
111         address[] calldata path,
112         address to,
113         uint deadline
114     ) external;
115     function factory() external pure returns (address);
116     function WETH() external pure returns (address);
117     function addLiquidityETH(
118         address token,
119         uint amountTokenDesired,
120         uint amountTokenMin,
121         uint amountETHMin,
122         address to,
123         uint deadline
124     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
125 }
126 
127 contract BonePad is Context, IERC20, Ownable {
128     using SafeMath for uint256;
129     mapping (address => uint256) private _rOwned;
130     mapping (address => uint256) private _tOwned;
131     mapping (address => mapping (address => uint256)) private _allowances;
132     mapping (address => bool) private _isExcludedFromFee;
133     mapping (address => bool) public bots;
134     mapping (address => uint) private cooldown;
135     uint256 private constant MAX = ~uint256(0);
136     uint256 private constant _tTotal = 1_000_000 * 10**9;
137     uint256 private _rTotal = (MAX - (MAX % _tTotal));
138     uint256 private _tFeeTotal;
139 
140     bool private dBlocksEnabled = true;
141     uint256 public lBlock = 0;
142     uint256 private dBlocks = 2;
143 
144     uint256 private _feeAddr1;
145     uint256 private _feeAddr2;
146     uint256 private _initialTax = 5;
147     uint256 private _finalTax = 5;
148     uint256 private _reduceTaxCountdown = 10;
149     address payable private _feeAddrWallet;
150 
151     string private constant _name = "BonePad";
152     string private constant _symbol = "BONEPAD";
153     uint8 private constant _decimals = 9;
154 
155     IUniswapV2Router02 private uniswapV2Router;
156     address private uniswapV2Pair;
157     bool private tradingOpen;
158     bool private inSwap = false;
159     bool private swapEnabled = false;
160     bool private cooldownEnabled = false;
161     uint256 private _maxTxAmount = 1_000_000 * 10**9;
162     uint256 private _maxWalletSize = 20_000 * 10**9;
163     event MaxTxAmountUpdated(uint _maxTxAmount);
164     modifier lockTheSwap {
165         inSwap = true;
166         _;
167         inSwap = false;
168     }
169 
170     constructor () {
171         _rOwned[_msgSender()] = _rTotal;
172         _isExcludedFromFee[owner()] = true;
173         _isExcludedFromFee[address(this)] = true;
174         _isExcludedFromFee[_feeAddrWallet] = true;
175         _feeAddrWallet = payable(_msgSender());
176 
177         emit Transfer(address(0), _msgSender(), _tTotal);
178     }
179 
180     function name() public pure returns (string memory) {
181         return _name;
182     }
183 
184     function symbol() public pure returns (string memory) {
185         return _symbol;
186     }
187 
188     function decimals() public pure returns (uint8) {
189         return _decimals;
190     }
191 
192     function totalSupply() public pure override returns (uint256) {
193         return _tTotal;
194     }
195 
196     function balanceOf(address account) public view override returns (uint256) {
197         return tokenFromReflection(_rOwned[account]);
198     }
199 
200     function transfer(address recipient, uint256 amount) public override returns (bool) {
201         _transfer(_msgSender(), recipient, amount);
202         return true;
203     }
204 
205     function allowance(address owner, address spender) public view override returns (uint256) {
206         return _allowances[owner][spender];
207     }
208 
209     function approve(address spender, uint256 amount) public override returns (bool) {
210         _approve(_msgSender(), spender, amount);
211         return true;
212     }
213 
214     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
215         _transfer(sender, recipient, amount);
216         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
217         return true;
218     }
219 
220     function setCooldownEnabled(bool onoff) external onlyOwner() {
221         cooldownEnabled = onoff;
222     }
223 
224     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
225         require(rAmount <= _rTotal, "Amount must be less than total reflections");
226         uint256 currentRate =  _getRate();
227         return rAmount.div(currentRate);
228     }
229 
230     function _approve(address owner, address spender, uint256 amount) private {
231         require(owner != address(0), "ERC20: approve from the zero address");
232         require(spender != address(0), "ERC20: approve to the zero address");
233         _allowances[owner][spender] = amount;
234         emit Approval(owner, spender, amount);
235     }
236 
237     function _transfer(address from, address to, uint256 amount) private {
238         require(from != address(0), "ERC20: transfer from the zero address");
239         require(to != address(0), "ERC20: transfer to the zero address");
240         require(amount > 0, "Transfer amount must be greater than zero");
241 
242 
243         if (from != owner() && to != owner()) {
244             require(!bots[from], "Blacklisted.");
245             _feeAddr1 = 0;
246             _feeAddr2 = (_reduceTaxCountdown==0)?_finalTax:_initialTax;
247             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
248                 // Cooldown
249                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
250                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
251                 if(_reduceTaxCountdown>0){_reduceTaxCountdown--;}
252 
253                 if (dBlocksEnabled) {
254                     if (block.number <= (lBlock + dBlocks)) {
255                         bots[to] = true;
256                     }
257                 }
258             }
259 
260             uint256 contractTokenBalance = balanceOf(address(this));
261             if (!inSwap && from != uniswapV2Pair && swapEnabled && contractTokenBalance>0) {
262                 swapTokensForEth(contractTokenBalance);
263                 uint256 contractETHBalance = address(this).balance;
264                 if(contractETHBalance > 0) {
265                     sendETHToFee(address(this).balance);
266                 }
267             }
268         }else{
269           _feeAddr1 = 0;
270           _feeAddr2 = 0;
271         }
272 
273         _tokenTransfer(from,to,amount);
274     }
275 
276     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
277         address[] memory path = new address[](2);
278         path[0] = address(this);
279         path[1] = uniswapV2Router.WETH();
280         _approve(address(this), address(uniswapV2Router), tokenAmount);
281         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
282             tokenAmount,
283             0,
284             path,
285             address(this),
286             block.timestamp
287         );
288     }
289 
290     function removeLimits() external onlyOwner {
291         _maxTxAmount = _tTotal;
292         _maxWalletSize = _tTotal;
293     }
294 
295     function sendETHToFee(uint256 amount) private {
296         _feeAddrWallet.transfer(amount);
297     }
298 
299     function openTrading() external onlyOwner() {
300         require(!tradingOpen,"trading is already open");
301         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
302         uniswapV2Router = _uniswapV2Router;
303         _approve(address(this), address(uniswapV2Router), _tTotal);
304         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
305         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
306         swapEnabled = true;
307         cooldownEnabled = true;
308         lBlock = block.number;
309         tradingOpen = true;
310         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
311     }
312 
313     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
314         _transferStandard(sender, recipient, amount);
315     }
316 
317     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
318         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
319         _rOwned[sender] = _rOwned[sender].sub(rAmount);
320         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
321         _takeTeam(tTeam);
322         _reflectFee(rFee, tFee);
323         emit Transfer(sender, recipient, tTransferAmount);
324     }
325 
326     function _takeTeam(uint256 tTeam) private {
327         uint256 currentRate =  _getRate();
328         uint256 rTeam = tTeam.mul(currentRate);
329         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
330     }
331 
332     function _reflectFee(uint256 rFee, uint256 tFee) private {
333         _rTotal = _rTotal.sub(rFee);
334         _tFeeTotal = _tFeeTotal.add(tFee);
335     }
336 
337     receive() external payable {}
338 
339     function manualswap() external {
340         require(_msgSender() == _feeAddrWallet);
341         uint256 contractBalance = balanceOf(address(this));
342         swapTokensForEth(contractBalance);
343     }
344 
345     function manualsend() external {
346         require(_msgSender() == _feeAddrWallet);
347         uint256 contractETHBalance = address(this).balance;
348         sendETHToFee(contractETHBalance);
349     }
350 
351 
352     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
353         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _feeAddr1, _feeAddr2);
354         uint256 currentRate =  _getRate();
355         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
356         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
357     }
358 
359     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
360         uint256 tFee = tAmount.mul(taxFee).div(100);
361         uint256 tTeam = tAmount.mul(TeamFee).div(100);
362         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
363         return (tTransferAmount, tFee, tTeam);
364     }
365 
366     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
367         uint256 rAmount = tAmount.mul(currentRate);
368         uint256 rFee = tFee.mul(currentRate);
369         uint256 rTeam = tTeam.mul(currentRate);
370         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
371         return (rAmount, rTransferAmount, rFee);
372     }
373 
374 	function _getRate() private view returns(uint256) {
375         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
376         return rSupply.div(tSupply);
377     }
378 
379     function _getCurrentSupply() private view returns(uint256, uint256) {
380         uint256 rSupply = _rTotal;
381         uint256 tSupply = _tTotal;
382         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
383         return (rSupply, tSupply);
384     }
385 }