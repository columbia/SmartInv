1 /**
2 
3 ███████╗███████╗██████╗░░█████╗░  ████████╗░█████╗░██╗░░██╗
4 ╚════██║██╔════╝██╔══██╗██╔══██╗  ╚══██╔══╝██╔══██╗╚██╗██╔╝
5 ░░███╔═╝█████╗░░██████╔╝██║░░██║  ░░░██║░░░███████║░╚███╔╝░
6 ██╔══╝░░██╔══╝░░██╔══██╗██║░░██║  ░░░██║░░░██╔══██║░██╔██╗░
7 ███████╗███████╗██║░░██║╚█████╔╝  ░░░██║░░░██║░░██║██╔╝╚██╗
8 ╚══════╝╚══════╝╚═╝░░╚═╝░╚════╝░  ░░░╚═╝░░░╚═╝░░╚═╝╚═╝░░╚═╝
9 
10 First real, safe and 0% tax Schrödinger coin, Elons lovely cat.
11 
12 Socials:
13 Telegram: https://t.me/ElonsCatERC
14 
15 tax: 0/0
16 **/
17 
18 pragma solidity 0.8.7;
19 // SPDX-License-Identifier: UNLICENSED
20 abstract contract Context {
21     function _msgSender() internal view virtual returns (address) {
22         return msg.sender;
23     }
24 }
25 
26 interface IERC20 {
27     function totalSupply() external view returns (uint256);
28     function balanceOf(address account) external view returns (uint256);
29     function transfer(address recipient, uint256 amount) external returns (bool);
30     function allowance(address owner, address spender) external view returns (uint256);
31     function approve(address spender, uint256 amount) external returns (bool);
32     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
33     event Transfer(address indexed from, address indexed to, uint256 value);
34     event Approval(address indexed owner, address indexed spender, uint256 value);
35 }
36 
37 library SafeMath {
38     function add(uint256 a, uint256 b) internal pure returns (uint256) {
39         uint256 c = a + b;
40         require(c >= a, "SafeMath: addition overflow");
41         return c;
42     }
43 
44     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45         return sub(a, b, "SafeMath: subtraction overflow");
46     }
47 
48     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
49         require(b <= a, errorMessage);
50         uint256 c = a - b;
51         return c;
52     }
53 
54     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
55         if (a == 0) {
56             return 0;
57         }
58         uint256 c = a * b;
59         require(c / a == b, "SafeMath: multiplication overflow");
60         return c;
61     }
62 
63     function div(uint256 a, uint256 b) internal pure returns (uint256) {
64         return div(a, b, "SafeMath: division by zero");
65     }
66 
67     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
68         require(b > 0, errorMessage);
69         uint256 c = a / b;
70         return c;
71     }
72 
73 }
74 
75 contract Ownable is Context {
76     address private _owner;
77     address private _previousOwner;
78     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
79 
80     constructor () {
81         address msgSender = _msgSender();
82         _owner = msgSender;
83         emit OwnershipTransferred(address(0), msgSender);
84     }
85 
86     function owner() public view returns (address) {
87         return _owner;
88     }
89 
90     modifier onlyOwner() {
91         require(_owner == _msgSender(), "Ownable: caller is not the owner");
92         _;
93     }
94 
95     function renounceOwnership() public virtual onlyOwner {
96         emit OwnershipTransferred(_owner, address(0));
97         _owner = address(0);
98     }
99 
100 }
101 
102 interface IUniswapV2Factory {
103     function createPair(address tokenA, address tokenB) external returns (address pair);
104 }
105 
106 interface IUniswapV2Router02 {
107     function swapExactTokensForETHSupportingFeeOnTransferTokens(
108         uint amountIn,
109         uint amountOutMin,
110         address[] calldata path,
111         address to,
112         uint deadline
113     ) external;
114     function factory() external pure returns (address);
115     function WETH() external pure returns (address);
116     function addLiquidityETH(
117         address token,
118         uint amountTokenDesired,
119         uint amountTokenMin,
120         uint amountETHMin,
121         address to,
122         uint deadline
123     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
124 }
125 
126 contract ElonsCat is Context, IERC20, Ownable {
127     using SafeMath for uint256;
128     mapping (address => uint256) private _rOwned;
129     mapping (address => uint256) private _tOwned;
130     mapping (address => mapping (address => uint256)) private _allowances;
131     mapping (address => bool) private _isExcludedFromFee;
132     mapping (address => bool) public bots;
133     mapping (address => uint) private cooldown;
134     uint256 private constant MAX = ~uint256(0);
135     uint256 private constant _tTotal = 1_000_000 * 10**9;
136     uint256 private _rTotal = (MAX - (MAX % _tTotal));
137     uint256 private _tFeeTotal;
138 
139     bool private dBlocksEnabled = true;
140     uint256 public lBlock = 0;
141     uint256 private dBlocks = 0;
142 
143     uint256 private _feeAddr1;
144     uint256 private _feeAddr2;
145     uint256 private _initialTax = 8;
146     uint256 private _finalTax = 0;
147     uint256 private _reduceTaxCountdown = 20;
148     address payable private _feeAddrWallet;
149 
150     string private constant _name = unicode"Schrödinger";
151     string private constant _symbol = "ELONSCAT";
152     uint8 private constant _decimals = 9;
153 
154     IUniswapV2Router02 private uniswapV2Router;
155     address private uniswapV2Pair;
156     bool private tradingOpen;
157     bool private inSwap = false;
158     bool private swapEnabled = false;
159     bool private cooldownEnabled = false;
160     uint256 private _maxTxAmount = 1_000_000 * 10**9;
161     uint256 private _maxWalletSize = 20_000 * 10**9;
162     event MaxTxAmountUpdated(uint _maxTxAmount);
163     modifier lockTheSwap {
164         inSwap = true;
165         _;
166         inSwap = false;
167     }
168 
169     constructor () {
170         _rOwned[_msgSender()] = _rTotal;
171         _isExcludedFromFee[owner()] = true;
172         _isExcludedFromFee[address(this)] = true;
173         _isExcludedFromFee[_feeAddrWallet] = true;
174         _feeAddrWallet = payable(_msgSender());
175 
176         emit Transfer(address(0), _msgSender(), _tTotal);
177     }
178 
179     function name() public pure returns (string memory) {
180         return _name;
181     }
182 
183     function symbol() public pure returns (string memory) {
184         return _symbol;
185     }
186 
187     function decimals() public pure returns (uint8) {
188         return _decimals;
189     }
190 
191     function totalSupply() public pure override returns (uint256) {
192         return _tTotal;
193     }
194 
195     function balanceOf(address account) public view override returns (uint256) {
196         return tokenFromReflection(_rOwned[account]);
197     }
198 
199     function transfer(address recipient, uint256 amount) public override returns (bool) {
200         _transfer(_msgSender(), recipient, amount);
201         return true;
202     }
203 
204     function allowance(address owner, address spender) public view override returns (uint256) {
205         return _allowances[owner][spender];
206     }
207 
208     function approve(address spender, uint256 amount) public override returns (bool) {
209         _approve(_msgSender(), spender, amount);
210         return true;
211     }
212 
213     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
214         _transfer(sender, recipient, amount);
215         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
216         return true;
217     }
218 
219     function setCooldownEnabled(bool onoff) external onlyOwner() {
220         cooldownEnabled = onoff;
221     }
222 
223     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
224         require(rAmount <= _rTotal, "Amount must be less than total reflections");
225         uint256 currentRate =  _getRate();
226         return rAmount.div(currentRate);
227     }
228 
229     function _approve(address owner, address spender, uint256 amount) private {
230         require(owner != address(0), "ERC20: approve from the zero address");
231         require(spender != address(0), "ERC20: approve to the zero address");
232         _allowances[owner][spender] = amount;
233         emit Approval(owner, spender, amount);
234     }
235 
236     function _transfer(address from, address to, uint256 amount) private {
237         require(from != address(0), "ERC20: transfer from the zero address");
238         require(to != address(0), "ERC20: transfer to the zero address");
239         require(amount > 0, "Transfer amount must be greater than zero");
240 
241 
242         if (from != owner() && to != owner()) {
243             require(!bots[from], "Blacklisted.");
244             _feeAddr1 = 0;
245             _feeAddr2 = (_reduceTaxCountdown==0)?_finalTax:_initialTax;
246             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
247                 // Cooldown
248                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
249                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
250                 if(_reduceTaxCountdown>0){_reduceTaxCountdown--;}
251 
252                 if (dBlocksEnabled) {
253                     if (block.number <= (lBlock + dBlocks)) {
254                         bots[to] = true;
255                     }
256                 }
257             }
258 
259             uint256 contractTokenBalance = balanceOf(address(this));
260             if (!inSwap && from != uniswapV2Pair && swapEnabled && contractTokenBalance>0) {
261                 swapTokensForEth(contractTokenBalance);
262                 uint256 contractETHBalance = address(this).balance;
263                 if(contractETHBalance > 0) {
264                     sendETHToFee(address(this).balance);
265                 }
266             }
267         }else{
268           _feeAddr1 = 0;
269           _feeAddr2 = 0;
270         }
271 
272         _tokenTransfer(from,to,amount);
273     }
274 
275     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
276         address[] memory path = new address[](2);
277         path[0] = address(this);
278         path[1] = uniswapV2Router.WETH();
279         _approve(address(this), address(uniswapV2Router), tokenAmount);
280         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
281             tokenAmount,
282             0,
283             path,
284             address(this),
285             block.timestamp
286         );
287     }
288 
289     function removeLimits() external onlyOwner {
290         _maxTxAmount = _tTotal;
291         _maxWalletSize = _tTotal;
292     }
293 
294     function sendETHToFee(uint256 amount) private {
295         _feeAddrWallet.transfer(amount);
296     }
297 
298     function openTrading() external onlyOwner() {
299         require(!tradingOpen,"trading is already open");
300         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
301         uniswapV2Router = _uniswapV2Router;
302         _approve(address(this), address(uniswapV2Router), _tTotal);
303         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
304         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
305         swapEnabled = true;
306         cooldownEnabled = true;
307         lBlock = block.number;
308         tradingOpen = true;
309         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
310     }
311 
312     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
313         _transferStandard(sender, recipient, amount);
314     }
315 
316     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
317         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
318         _rOwned[sender] = _rOwned[sender].sub(rAmount);
319         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
320         _takeTeam(tTeam);
321         _reflectFee(rFee, tFee);
322         emit Transfer(sender, recipient, tTransferAmount);
323     }
324 
325     function _takeTeam(uint256 tTeam) private {
326         uint256 currentRate =  _getRate();
327         uint256 rTeam = tTeam.mul(currentRate);
328         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
329     }
330 
331     function _reflectFee(uint256 rFee, uint256 tFee) private {
332         _rTotal = _rTotal.sub(rFee);
333         _tFeeTotal = _tFeeTotal.add(tFee);
334     }
335 
336     receive() external payable {}
337 
338     function manualswap() external {
339         require(_msgSender() == _feeAddrWallet);
340         uint256 contractBalance = balanceOf(address(this));
341         swapTokensForEth(contractBalance);
342     }
343 
344     function manualsend() external {
345         require(_msgSender() == _feeAddrWallet);
346         uint256 contractETHBalance = address(this).balance;
347         sendETHToFee(contractETHBalance);
348     }
349 
350 
351     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
352         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _feeAddr1, _feeAddr2);
353         uint256 currentRate =  _getRate();
354         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
355         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
356     }
357 
358     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
359         uint256 tFee = tAmount.mul(taxFee).div(100);
360         uint256 tTeam = tAmount.mul(TeamFee).div(100);
361         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
362         return (tTransferAmount, tFee, tTeam);
363     }
364 
365     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
366         uint256 rAmount = tAmount.mul(currentRate);
367         uint256 rFee = tFee.mul(currentRate);
368         uint256 rTeam = tTeam.mul(currentRate);
369         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
370         return (rAmount, rTransferAmount, rFee);
371     }
372 
373 	function _getRate() private view returns(uint256) {
374         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
375         return rSupply.div(tSupply);
376     }
377 
378     function _getCurrentSupply() private view returns(uint256, uint256) {
379         uint256 rSupply = _rTotal;
380         uint256 tSupply = _tTotal;
381         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
382         return (rSupply, tSupply);
383     }
384 }