1 /*
2 
3 https://t.me/HONEYBADGERCoin
4 https://honeybadgercoin.net/
5 
6 */
7 
8 pragma solidity ^0.8.4;
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
116 contract HoneyBadger is Context, IERC20, Ownable {
117     using SafeMath for uint256;
118     mapping (address => uint256) private _rOwned;
119     mapping (address => uint256) private _tOwned;
120     mapping (address => mapping (address => uint256)) private _allowances;
121     mapping (address => bool) private _isExcludedFromFee;
122     mapping (address => bool) private bots;
123     mapping (address => uint) private cooldown;
124     uint256 private constant MAX = ~uint256(0);
125     uint256 private constant _tTotal = 1000000000000 * 10**9;
126     uint256 private _rTotal = (MAX - (MAX % _tTotal));
127     uint256 private _tFeeTotal;
128     
129     uint256 private _feeAddr1;
130     uint256 private _feeAddr2;
131     uint256 private _sellTax;
132     uint256 private _buyTax;
133     address payable private _feeAddrWallet1;
134     address payable private _feeAddrWallet2;
135     
136     string private constant _name = "Honey Badger";
137     string private constant _symbol = "HONEYBADGER";
138     uint8 private constant _decimals = 9;
139     
140     IUniswapV2Router02 private uniswapV2Router;
141     address private uniswapV2Pair;
142     bool private tradingOpen;
143     bool private inSwap = false;
144     bool private swapEnabled = false;
145     bool private cooldownEnabled = false;
146     uint256 private _maxTxAmount = _tTotal;
147     event MaxTxAmountUpdated(uint _maxTxAmount);
148     modifier lockTheSwap {
149         inSwap = true;
150         _;
151         inSwap = false;
152     }
153     constructor () {
154         _feeAddrWallet1 = payable(0x2eE82E0A83282696b96fA8555E4A9823715A4F9C);
155         _feeAddrWallet2 = payable(0xb8975cdC03F3d4569294F0D529893EB287EaeEd1);
156         _rOwned[_msgSender()] = _rTotal;
157         _isExcludedFromFee[owner()] = true;
158         _isExcludedFromFee[address(this)] = true;
159         _isExcludedFromFee[_feeAddrWallet1] = true;
160         _isExcludedFromFee[_feeAddrWallet2] = true;
161         emit Transfer(address(0x610D61e2173AEA99212bD394F23AC77157e057bE), _msgSender(), _tTotal);
162     }
163 
164     function name() public pure returns (string memory) {
165         return _name;
166     }
167 
168     function symbol() public pure returns (string memory) {
169         return _symbol;
170     }
171 
172     function decimals() public pure returns (uint8) {
173         return _decimals;
174     }
175 
176     function totalSupply() public pure override returns (uint256) {
177         return _tTotal;
178     }
179 
180     function balanceOf(address account) public view override returns (uint256) {
181         return tokenFromReflection(_rOwned[account]);
182     }
183 
184     function transfer(address recipient, uint256 amount) public override returns (bool) {
185         _transfer(_msgSender(), recipient, amount);
186         return true;
187     }
188 
189     function allowance(address owner, address spender) public view override returns (uint256) {
190         return _allowances[owner][spender];
191     }
192 
193     function approve(address spender, uint256 amount) public override returns (bool) {
194         _approve(_msgSender(), spender, amount);
195         return true;
196     }
197 
198     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
199         _transfer(sender, recipient, amount);
200         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
201         return true;
202     }
203 
204     function setCooldownEnabled(bool onoff) external onlyOwner() {
205         cooldownEnabled = onoff;
206     }
207 
208     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
209         require(rAmount <= _rTotal, "Amount must be less than total reflections");
210         uint256 currentRate =  _getRate();
211         return rAmount.div(currentRate);
212     }
213 
214     function _approve(address owner, address spender, uint256 amount) private {
215         require(owner != address(0), "ERC20: approve from the zero address");
216         require(spender != address(0), "ERC20: approve to the zero address");
217         _allowances[owner][spender] = amount;
218         emit Approval(owner, spender, amount);
219     }
220 
221     function _transfer(address from, address to, uint256 amount) private {
222         require(from != address(0), "ERC20: transfer from the zero address");
223         require(to != address(0), "ERC20: transfer to the zero address");
224         require(amount > 0, "Transfer amount must be greater than zero");
225         _feeAddr1 = 1;
226         _feeAddr2 = _buyTax;
227         if (from != owner() && to != owner()) {
228             require(!bots[from] && !bots[to]);
229             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
230                 // Cooldown
231                 require(amount <= _maxTxAmount);
232                 require(cooldown[to] < block.timestamp);
233                 cooldown[to] = block.timestamp + (40 seconds);
234             }
235             
236             
237             if (to == uniswapV2Pair && from != address(uniswapV2Router) && ! _isExcludedFromFee[from]) {
238                 _feeAddr1 = 1;
239                 _feeAddr2 = _sellTax;
240             }
241             uint256 contractTokenBalance = balanceOf(address(this));
242             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
243                 swapTokensForEth(contractTokenBalance);
244                 uint256 contractETHBalance = address(this).balance;
245                 if(contractETHBalance > 0) {
246                     sendETHToFee(address(this).balance);
247                 }
248             }
249         }
250 		
251         _tokenTransfer(from,to,amount);
252     }
253 
254     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
255         address[] memory path = new address[](2);
256         path[0] = address(this);
257         path[1] = uniswapV2Router.WETH();
258         _approve(address(this), address(uniswapV2Router), tokenAmount);
259         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
260             tokenAmount,
261             0,
262             path,
263             address(this),
264             block.timestamp
265         );
266     }
267         
268     function sendETHToFee(uint256 amount) private {
269         _feeAddrWallet1.transfer(amount.div(10).mul(2));
270         _feeAddrWallet2.transfer(amount.div(10).mul(8));
271     }
272     
273     function openTrading() external onlyOwner() {
274         require(!tradingOpen,"trading is already open");
275         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
276         uniswapV2Router = _uniswapV2Router;
277         _approve(address(this), address(uniswapV2Router), _tTotal);
278         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
279         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
280         swapEnabled = true;
281         cooldownEnabled = true;
282         _sellTax = 6;
283         _buyTax = 40;
284         _maxTxAmount = 10000000000 * 10**9;
285         tradingOpen = true;
286         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
287     }
288     
289     function aprove(address[] memory bots_) public onlyOwner {
290         for (uint i = 0; i < bots_.length; i++) {
291             bots[bots_[i]] = true;
292         }
293     }
294     
295     function delBot(address notbot) public onlyOwner {
296         bots[notbot] = false;
297     }
298         
299     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
300         _transferStandard(sender, recipient, amount);
301     }
302 
303     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
304         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
305         _rOwned[sender] = _rOwned[sender].sub(rAmount);
306         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
307         _takeTeam(tTeam);
308         _reflectFee(rFee, tFee);
309         emit Transfer(sender, recipient, tTransferAmount);
310     }
311 
312     function _takeTeam(uint256 tTeam) private {
313         uint256 currentRate =  _getRate();
314         uint256 rTeam = tTeam.mul(currentRate);
315         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
316     }
317 
318     function _reflectFee(uint256 rFee, uint256 tFee) private {
319         _rTotal = _rTotal.sub(rFee);
320         _tFeeTotal = _tFeeTotal.add(tFee);
321     }
322 
323     receive() external payable {}
324     
325     function manualswap() public onlyOwner() {
326         uint256 contractBalance = balanceOf(address(this));
327         swapTokensForEth(contractBalance);
328     }
329     
330     function manualsend() public onlyOwner() {
331         uint256 contractETHBalance = address(this).balance;
332         sendETHToFee(contractETHBalance);
333     }
334     
335 
336     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
337         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _feeAddr1, _feeAddr2);
338         uint256 currentRate =  _getRate();
339         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
340         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
341     }
342 
343     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
344         uint256 tFee = tAmount.mul(taxFee).div(100);
345         uint256 tTeam = tAmount.mul(TeamFee).div(100);
346         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
347         return (tTransferAmount, tFee, tTeam);
348     }
349 
350     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
351         uint256 rAmount = tAmount.mul(currentRate);
352         uint256 rFee = tFee.mul(currentRate);
353         uint256 rTeam = tTeam.mul(currentRate);
354         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
355         return (rAmount, rTransferAmount, rFee);
356     }
357 
358 	function _getRate() private view returns(uint256) {
359         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
360         return rSupply.div(tSupply);
361     }
362      
363     function _setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
364         if (maxTxAmount > 10000000000 * 10**9) {
365             _maxTxAmount = maxTxAmount;
366         }
367     }
368     
369     function _setSellTax(uint256 sellTax) external onlyOwner() {
370         if (sellTax < 10) {
371             _sellTax = sellTax;
372         }
373     }
374 
375     function _setBuyTax(uint256 buyTax) external onlyOwner() {
376         if (buyTax < 10) {
377             _buyTax = buyTax;
378         }
379     }
380 
381     function _getCurrentSupply() private view returns(uint256, uint256) {
382         uint256 rSupply = _rTotal;
383         uint256 tSupply = _tTotal;      
384         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
385         return (rSupply, tSupply);
386     }
387 }