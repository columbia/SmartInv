1 // SPDX-License-Identifier: MIT
2 
3 /**
4  * 
5  ¦¦¦¦¦¦   ¦¦¦¦¦  ¦¦¦¦¦¦¦ ¦¦¦¦¦¦¦ ¦¦¦    ¦¦      ¦¦ ¦¦     ¦¦ ¦¦¦    ¦¦ ¦¦    ¦¦ 
6 ¦¦   ¦¦ ¦¦   ¦¦ ¦¦      ¦¦      ¦¦¦¦   ¦¦      ¦¦ ¦¦     ¦¦ ¦¦¦¦   ¦¦ ¦¦    ¦¦ 
7 ¦¦¦¦¦¦  ¦¦¦¦¦¦¦ ¦¦¦¦¦¦¦ ¦¦¦¦¦   ¦¦ ¦¦  ¦¦      ¦¦ ¦¦     ¦¦ ¦¦ ¦¦  ¦¦ ¦¦    ¦¦ 
8 ¦¦   ¦¦ ¦¦   ¦¦      ¦¦ ¦¦      ¦¦  ¦¦ ¦¦ ¦¦   ¦¦ ¦¦     ¦¦ ¦¦  ¦¦ ¦¦ ¦¦    ¦¦ 
9 ¦¦¦¦¦¦  ¦¦   ¦¦ ¦¦¦¦¦¦¦ ¦¦¦¦¦¦¦ ¦¦   ¦¦¦¦  ¦¦¦¦¦  ¦¦     ¦¦ ¦¦   ¦¦¦¦  ¦¦¦¦¦¦  
10                                                                                
11                                                                                
12  
13    # Basenji Inu
14 
15    2% fee auto distribute to all holders
16    6% fee auto moved to Charity wallet
17 
18  */
19 
20 pragma solidity ^0.8.4;
21 
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
128 contract BAJINU is Context, IERC20, Ownable {
129     using SafeMath for uint256;
130 
131     mapping (address => uint256) private _rOwned;
132     mapping (address => uint256) private _tOwned;
133     mapping (address => mapping (address => uint256)) private _allowances;
134     mapping (address => bool) private _isExcludedFromFee;
135     mapping (address => bool) private bots;
136     mapping (address => uint) private cooldown;
137 
138     uint256 private constant MAX = ~uint256(0);
139     uint256 private constant _tTotal = 1e15 * 10**9;
140     uint256 private _rTotal = (MAX - (MAX % _tTotal));
141     uint256 private _tFeeTotal;
142 
143     string private constant _name = "Basenji Inu";
144     string private constant _symbol = 'BAJINU';
145     uint8 private constant _decimals = 9;
146 
147     uint256 private _taxFee = 2;
148     uint256 private _charityFee = 6;
149 
150     uint256 private _previousTaxFee = _taxFee;
151     uint256 private _previousCharityFee = _charityFee;
152     address private _charityAddress = 0x3BA8B0f69098cb4A27d8019ddf375146bb1B1d2A;
153 
154     IUniswapV2Router02 private uniswapV2Router;
155     address private uniswapV2Pair;
156     bool private tradingOpen;
157     bool private inSwap = false;
158     bool private swapEnabled = false;
159     uint256 private _maxTxAmount = _tTotal;
160 
161     event MaxTxAmountUpdated(uint _maxTxAmount);
162 
163     modifier lockTheSwap {
164         inSwap = true;
165         _;
166         inSwap = false;
167     }
168 
169     constructor () {
170         _rOwned[_msgSender()] = _rTotal;
171 
172         _isExcludedFromFee[owner()] = true;
173         _isExcludedFromFee[address(this)] = true;
174         _isExcludedFromFee[_charityAddress] = true;
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
219     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
220         require(rAmount <= _rTotal, "Amount must be less than total reflections");
221         uint256 currentRate =  _getRate();
222         return rAmount.div(currentRate);
223     }
224 
225     function removeAllFee() private {
226         if(_taxFee == 0 && _charityFee == 0) return;
227         _previousTaxFee = _taxFee;
228         _previousCharityFee = _charityFee;
229         _taxFee = 0;
230         _charityFee = 0;
231     }
232     
233     function restoreAllFee() private {
234         _taxFee = _previousTaxFee;
235         _charityFee = _previousCharityFee;
236     }
237 
238     function _approve(address owner, address spender, uint256 amount) private {
239         require(owner != address(0), "ERC20: approve from the zero address");
240         require(spender != address(0), "ERC20: approve to the zero address");
241         _allowances[owner][spender] = amount;
242         emit Approval(owner, spender, amount);
243     }
244 
245     function _transfer(address from, address to, uint256 amount) private {
246         require(from != address(0), "ERC20: transfer from the zero address");
247         require(to != address(0), "ERC20: transfer to the zero address");
248         require(amount > 0, "Transfer amount must be greater than zero");
249 
250         if (from != owner() && to != owner()) {
251             require(amount <= _maxTxAmount);
252 
253             uint256 contractTokenBalance = balanceOf(address(this));
254             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
255                 swapTokensForEth(contractTokenBalance);
256                 uint256 contractETHBalance = address(this).balance;
257                 if(contractETHBalance > 0) {
258                     sendETHToCharity(address(this).balance);
259                 }
260             }
261         }
262         bool takeFee = true;
263 
264         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
265             takeFee = false;
266         }
267 		
268         _tokenTransfer(from,to,amount,takeFee);
269     }
270 
271     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
272         address[] memory path = new address[](2);
273         path[0] = address(this);
274         path[1] = uniswapV2Router.WETH();
275         _approve(address(this), address(uniswapV2Router), tokenAmount);
276         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
277             tokenAmount,
278             0,
279             path,
280             address(this),
281             block.timestamp
282         );
283     }
284         
285     function sendETHToCharity(uint256 amount) private {
286         payable(_charityAddress).transfer(amount);
287     }
288     
289     function openTrading() external onlyOwner() {
290         require(!tradingOpen,"trading is already open");
291         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
292         uniswapV2Router = _uniswapV2Router;
293         _approve(address(this), address(uniswapV2Router), _tTotal);
294         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
295         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
296         swapEnabled = true;
297         _maxTxAmount = 5e12 * 10**9;
298         tradingOpen = true;
299         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
300     }
301         
302     function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
303         if(!takeFee)
304             removeAllFee();
305         _transferStandard(sender, recipient, amount);
306         if(!takeFee)
307             restoreAllFee();
308     }
309 
310     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
311         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tCharity) = _getValues(tAmount);
312         _rOwned[sender] = _rOwned[sender].sub(rAmount);
313         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
314         _takeCharity(tCharity);
315         _reflectFee(rFee, tFee);
316         emit Transfer(sender, recipient, tTransferAmount);
317     }
318 
319     function _takeCharity(uint256 tCharity) private {
320         uint256 currentRate =  _getRate();
321         uint256 rCharity = tCharity.mul(currentRate);
322         _rOwned[address(this)] = _rOwned[address(this)].add(rCharity);
323     }
324 
325     function _reflectFee(uint256 rFee, uint256 tFee) private {
326         _rTotal = _rTotal.sub(rFee);
327         _tFeeTotal = _tFeeTotal.add(tFee);
328     }
329 
330     receive() external payable {}
331     
332     function manualswap() external {
333         require(_msgSender() == _charityAddress);
334         uint256 contractBalance = balanceOf(address(this));
335         swapTokensForEth(contractBalance);
336     }
337     
338     function manualsend() external {
339         require(_msgSender() == _charityAddress);
340         uint256 contractETHBalance = address(this).balance;
341         sendETHToCharity(contractETHBalance);
342     }
343     
344     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
345         (uint256 tTransferAmount, uint256 tFee, uint256 tCharity) = _getTValues(tAmount, _taxFee, _charityFee);
346         uint256 currentRate =  _getRate();
347         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tCharity, currentRate);
348         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tCharity);
349     }
350 
351     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 CharityFee) private pure returns (uint256, uint256, uint256) {
352         uint256 tFee = tAmount.mul(taxFee).div(100);
353         uint256 tCharity = tAmount.mul(CharityFee).div(100);
354         uint256 tTransferAmount = tAmount.sub(tFee).sub(tCharity);
355         return (tTransferAmount, tFee, tCharity);
356     }
357 
358     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tCharity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
359         uint256 rAmount = tAmount.mul(currentRate);
360         uint256 rFee = tFee.mul(currentRate);
361         uint256 rCharity = tCharity.mul(currentRate);
362         uint256 rTransferAmount = rAmount.sub(rFee).sub(rCharity);
363         return (rAmount, rTransferAmount, rFee);
364     }
365 
366 	function _getRate() private view returns(uint256) {
367         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
368         return rSupply.div(tSupply);
369     }
370 
371     function _getCurrentSupply() private view returns(uint256, uint256) {
372         uint256 rSupply = _rTotal;
373         uint256 tSupply = _tTotal;      
374         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
375         return (rSupply, tSupply);
376     }
377 
378     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
379         require(maxTxPercent > 0, "Amount must be greater than 0");
380         _maxTxAmount = _tTotal.mul(maxTxPercent).div(10**2);
381         emit MaxTxAmountUpdated(_maxTxAmount);
382     }
383 }