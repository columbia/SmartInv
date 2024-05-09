1 /*
2 
3 $TESLA | Tesla Inu
4 
5 The Cryptocurrency representing the nearly $1T Company TESLA
6 
7 https://t.me/TESLAINUportal
8 
9 Tokenomics
10 Max Supply: 100K
11 Tax: 4/6
12 Max TX: 2.5%
13 
14 */
15 
16 pragma solidity ^0.8.9;
17 // SPDX-License-Identifier: UNLICENSED
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
124 contract TeslaInu is Context, IERC20, Ownable {
125     using SafeMath for uint256;
126     mapping (address => uint256) private _rOwned;
127     mapping (address => uint256) private _tOwned;
128     mapping (address => mapping (address => uint256)) private _allowances;
129     mapping (address => bool) private _isExcludedFromFee;
130     mapping (address => bool) private bots;
131     mapping (address => uint) private cooldown;
132     uint256 private constant MAX = ~uint256(0);
133     uint256 private constant _tTotal = 100000 * 10**9;
134     uint256 private _rTotal = (MAX - (MAX % _tTotal));
135     uint256 private _tFeeTotal;
136     
137     uint256 private _feeAddr1;
138     uint256 private _feeAddr2;
139     address payable private _feeAddrWallet;
140     string private constant _name = "Tesla Inu";
141     string private constant _symbol = "TESLA";
142     uint8 private constant _decimals = 9;
143     
144     IUniswapV2Router02 private uniswapV2Router;
145     address private uniswapV2Pair;
146     bool private tradingOpen;
147     bool private inSwap = false;
148     bool private swapEnabled = false;
149     bool private cooldownEnabled = false;
150     uint256 private _maxTxAmount = _tTotal;
151     uint256 private _maxWalletSize = _tTotal;
152     event MaxTxAmountUpdated(uint _maxTxAmount);
153     modifier lockTheSwap {
154         inSwap = true;
155         _;
156         inSwap = false;
157     }
158 
159     constructor () {
160         _feeAddrWallet = payable(0x15c1557a553f3C6779868725b1BeE5b0514d06F0);
161         _rOwned[_msgSender()] = _rTotal;
162         _isExcludedFromFee[owner()] = true;
163         _isExcludedFromFee[address(this)] = true;
164         _isExcludedFromFee[_feeAddrWallet] = true;
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
229         _feeAddr1 = 0;
230         _feeAddr2 = 4;
231         if (from != owner() && to != owner()) {
232             require(!bots[from] && !bots[to]);
233             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
234                 // Cooldown
235                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
236                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
237                 require(cooldown[to] < block.timestamp);
238                 cooldown[to] = block.timestamp + (30 seconds);
239             }
240             
241             
242             if (to == uniswapV2Pair && from != address(uniswapV2Router) && ! _isExcludedFromFee[from]) {
243                 _feeAddr1 = 0;
244                 _feeAddr2 = 6;
245             }
246             uint256 contractTokenBalance = balanceOf(address(this));
247             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
248                 swapTokensForEth(contractTokenBalance);
249                 uint256 contractETHBalance = address(this).balance;
250                 if(contractETHBalance > 0) {
251                     sendETHToFee(address(this).balance);
252                 }
253             }
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
273     function removeLimits() external onlyOwner{
274         _maxTxAmount = _tTotal;
275         _maxWalletSize = _tTotal;
276     }
277 
278     function changeMaxTxAmount(uint256 percentage) external onlyOwner{
279         require(percentage>0);
280         _maxTxAmount = _tTotal.mul(percentage).div(100);
281     }
282 
283     function changeMaxWalletSize(uint256 percentage) external onlyOwner{
284         require(percentage>0);
285         _maxWalletSize = _tTotal.mul(percentage).div(100);
286     }
287         
288     function sendETHToFee(uint256 amount) private {
289         _feeAddrWallet.transfer(amount);
290     }  
291 
292     function openTrading() external onlyOwner() {
293         require(!tradingOpen,"trading is already open");
294         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
295         uniswapV2Router = _uniswapV2Router;
296         _approve(address(this), address(uniswapV2Router), _tTotal);
297         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
298         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
299         swapEnabled = true;
300         cooldownEnabled = true;
301         _maxTxAmount = _tTotal.mul(25).div(1000);
302         _maxWalletSize = _tTotal.mul(30).div(1000);
303         tradingOpen = true;
304         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
305     }
306     
307     function nonosquare(address[] memory bots_) public onlyOwner {
308         for (uint i = 0; i < bots_.length; i++) {
309             bots[bots_[i]] = true;
310         }
311     }
312     
313     function delBot(address notbot) public onlyOwner {
314         bots[notbot] = false;
315     }
316         
317     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
318         _transferStandard(sender, recipient, amount);
319     }
320 
321     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
322         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
323         _rOwned[sender] = _rOwned[sender].sub(rAmount);
324         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
325         _takeTeam(tTeam);
326         _reflectFee(rFee, tFee);
327         emit Transfer(sender, recipient, tTransferAmount);
328     }
329 
330     function _takeTeam(uint256 tTeam) private {
331         uint256 currentRate =  _getRate();
332         uint256 rTeam = tTeam.mul(currentRate);
333         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
334     }
335 
336     function _reflectFee(uint256 rFee, uint256 tFee) private {
337         _rTotal = _rTotal.sub(rFee);
338         _tFeeTotal = _tFeeTotal.add(tFee);
339     }
340 
341     receive() external payable {}
342     
343     function manualswap() external {
344         require(_msgSender() == _feeAddrWallet);
345         uint256 contractBalance = balanceOf(address(this));
346         swapTokensForEth(contractBalance);
347     }
348     
349     function manualsend() external {
350         require(_msgSender() == _feeAddrWallet);
351         uint256 contractETHBalance = address(this).balance;
352         sendETHToFee(contractETHBalance);
353     }
354     
355 
356     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
357         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _feeAddr1, _feeAddr2);
358         uint256 currentRate =  _getRate();
359         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
360         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
361     }
362 
363     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
364         uint256 tFee = tAmount.mul(taxFee).div(100);
365         uint256 tTeam = tAmount.mul(TeamFee).div(100);
366         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
367         return (tTransferAmount, tFee, tTeam);
368     }
369 
370     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
371         uint256 rAmount = tAmount.mul(currentRate);
372         uint256 rFee = tFee.mul(currentRate);
373         uint256 rTeam = tTeam.mul(currentRate);
374         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
375         return (rAmount, rTransferAmount, rFee);
376     }
377 
378 	function _getRate() private view returns(uint256) {
379         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
380         return rSupply.div(tSupply);
381     }
382 
383     function _getCurrentSupply() private view returns(uint256, uint256) {
384         uint256 rSupply = _rTotal;
385         uint256 tSupply = _tTotal;      
386         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
387         return (rSupply, tSupply);
388     }
389 }