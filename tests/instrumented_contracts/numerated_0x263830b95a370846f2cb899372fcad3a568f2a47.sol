1 /**
2 https://t.me/TaikaResearch
3 
4 https://twitter.com/TaikaResearch
5 */
6 
7 // SPDX-License-Identifier: Unlicensed
8 
9 pragma solidity ^0.8.4;
10 
11 abstract contract Context {
12     function _msgSender() internal view virtual returns (address) {
13         return msg.sender;
14     }
15 }
16 
17 interface IERC20 {
18     function totalSupply() external view returns (uint256);
19     function balanceOf(address account) external view returns (uint256);
20     function transfer(address recipient, uint256 amount) external returns (bool);
21     function allowance(address owner, address spender) external view returns (uint256);
22     function approve(address spender, uint256 amount) external returns (bool);
23     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
24     event Transfer(address indexed from, address indexed to, uint256 value);
25     event Approval(address indexed owner, address indexed spender, uint256 value);
26 }
27 
28 library SafeMath {
29     function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         require(c >= a, "SafeMath: addition overflow");
32         return c;
33     }
34 
35     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36         return sub(a, b, "SafeMath: subtraction overflow");
37     }
38 
39     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
40         require(b <= a, errorMessage);
41         uint256 c = a - b;
42         return c;
43     }
44 
45     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
46         if (a == 0) {
47             return 0;
48         }
49         uint256 c = a * b;
50         require(c / a == b, "SafeMath: multiplication overflow");
51         return c;
52     }
53 
54     function div(uint256 a, uint256 b) internal pure returns (uint256) {
55         return div(a, b, "SafeMath: division by zero");
56     }
57 
58     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
59         require(b > 0, errorMessage);
60         uint256 c = a / b;
61         return c;
62     }
63 
64 }
65 
66 abstract contract Ownable is Context {
67     address private _owner;
68 
69     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
70 
71     constructor() {
72         _transferOwnership(_msgSender());
73     }
74 
75     function owner() public view virtual returns (address) {
76         return _owner;
77     }
78 
79     modifier onlyOwner() {
80         require(owner() == _msgSender(), "Ownable: caller is not the owner");
81         _;
82     }
83 
84     function renounceOwnership() public virtual onlyOwner {
85         _transferOwnership(address(0));
86     }
87 
88     function transferOwnership(address newOwner) public virtual onlyOwner {
89         require(newOwner != address(0), "Ownable: new owner is the zero address");
90         _transferOwnership(newOwner);
91     }
92 
93     function _transferOwnership(address newOwner) internal virtual {
94         address oldOwner = _owner;
95         _owner = newOwner;
96         emit OwnershipTransferred(oldOwner, newOwner);
97     }
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
124 contract Taika is Context, IERC20, Ownable {
125     using SafeMath for uint256;
126     mapping (address => uint256) private _rOwned;
127     mapping (address => uint256) private _tOwned;
128     mapping (address => mapping (address => uint256)) private _allowances;
129     mapping (address => bool) private _isExcludedFromFee;
130     mapping (address => bool) private bots;
131 
132     uint256 private constant MAX = ~uint256(0);
133     uint256 private constant _tTotal = 1 * 1e15 * 1e9; 
134     uint256 public _maxWalletSize;
135     uint256 public _maxTxn;
136 
137     uint256 private _rTotal = (MAX - (MAX % _tTotal));
138     uint256 private _tFeeTotal;
139     uint256 private _sellTax;
140     uint256 private _buyTax;
141     uint256 public SWAPamount = 1 * 1e13 * 1e9; // 1%
142     
143     uint256 private _feeAddr1;
144     uint256 private _feeAddr2;
145     address payable private dev;
146     address payable private mktg;
147 
148 
149     event maxWalletSizeamountUpdated(uint _maxWalletSize);
150     event maxTxnUpdate(uint _maxTxn);
151     event SWAPamountUpdated(uint SWAPamount);
152 
153     string private constant _name = unicode"Taika Suru 退化する";
154     string private constant _symbol = "Taika";
155     uint8 private constant _decimals = 9;
156     
157     IUniswapV2Router02 private uniswapV2Router;
158     address private uniswapV2Pair;
159     bool private tradingOpen;
160     bool private inSwap = false;
161     bool private swapEnabled = false;
162    
163     modifier lockTheSwap {
164         inSwap = true;
165         _;
166         inSwap = false;
167     }
168     constructor () {
169         dev = payable(0x822333AA385E454787bedE9A776D5eC1fa9c473A);
170         mktg = payable(0x7eE9425a459a278D4A206568A501c8e3136B370E);
171 
172         _rOwned[address(this)] = _rTotal;
173         _sellTax = 30;
174         _buyTax = 0;
175         _isExcludedFromFee[owner()] = true;
176         _isExcludedFromFee[address(this)] = true;
177         _isExcludedFromFee[dev] = true;
178         _isExcludedFromFee[address(0)] = true;
179 
180 
181         emit Transfer(address(0), address(this), _tTotal);
182     }
183 
184     function name() public pure returns (string memory) {
185         return _name;
186     }
187 
188     function symbol() public pure returns (string memory) {
189         return _symbol;
190     }
191 
192     function decimals() public pure returns (uint8) {
193         return _decimals;
194     }
195 
196     function totalSupply() public pure override returns (uint256) {
197         return _tTotal;
198     }
199 
200     function balanceOf(address account) public view override returns (uint256) {
201         return tokenFromReflection(_rOwned[account]);
202     }
203 
204     function transfer(address recipient, uint256 amount) public override returns (bool) {
205         _transfer(_msgSender(), recipient, amount);
206         return true;
207     }
208 
209     function allowance(address owner, address spender) public view override returns (uint256) {
210         return _allowances[owner][spender];
211     }
212 
213     function approve(address spender, uint256 amount) public override returns (bool) {
214         _approve(_msgSender(), spender, amount);
215         return true;
216     }
217 
218     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
219         _transfer(sender, recipient, amount);
220         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
221         return true;
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
238         require(!bots[from] && !bots[to]);
239         require(amount > 0, "Transfer amount must be greater than zero");
240         
241         if (! _isExcludedFromFee[to] && ! _isExcludedFromFee[from]) {
242             _feeAddr1 = 0;
243             _feeAddr2 = _buyTax;
244         }
245 
246         if (to != uniswapV2Pair && ! _isExcludedFromFee[to] && ! _isExcludedFromFee[from]) {
247             require(amount + balanceOf(to) <= _maxWalletSize, "Over max wallet size.");
248             require(amount <= _maxTxn, "Buy transfer amount exceeds the maxTransactionAmount.");
249 
250         }
251         
252 
253         if (to == uniswapV2Pair && from != address(uniswapV2Router) && ! _isExcludedFromFee[from]) {
254             require(!bots[from] && !bots[to]);
255             _feeAddr1 = 0;
256             _feeAddr2 = _sellTax;
257         }
258 
259         if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
260             _feeAddr1 = 0;
261             _feeAddr2 = 0;
262         }
263 
264         uint256 contractTokenBalance = balanceOf(address(this));
265         if (!inSwap && from != uniswapV2Pair && swapEnabled) {
266             if (contractTokenBalance > SWAPamount) {
267                 swapTokensForEth(contractTokenBalance);
268             }
269             
270             uint256 contractETHBalance = address(this).balance;
271             if(contractETHBalance > 0) {
272                 sendETHToFee(address(this).balance);
273             }
274         }    
275 		
276         _tokenTransfer(from,to,amount);
277     }
278 
279     function openTrading() external onlyOwner() {
280         require(!tradingOpen,"trading is already open");
281         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
282         uniswapV2Router = _uniswapV2Router;
283         _approve(address(this), address(uniswapV2Router), _tTotal);
284         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
285         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
286         swapEnabled = true;
287         _maxWalletSize = 3 * 1e13 * 1e9; //3%
288         _maxTxn = 3 * 1e13 * 1e9;
289 
290         tradingOpen = true;
291         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
292     }
293 
294     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
295         address[] memory path = new address[](2);
296         path[0] = address(this);
297         path[1] = uniswapV2Router.WETH();
298         _approve(address(this), address(uniswapV2Router), tokenAmount);
299         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
300             tokenAmount,
301             0,
302             path,
303             address(this),
304             block.timestamp
305         );
306     }
307 
308     function updateFees(uint256 sellTax, uint256 reflections, uint256 buyTax) external onlyOwner {
309         _feeAddr1 = reflections;
310         _sellTax = sellTax;
311         _buyTax = buyTax;
312         require(reflections <= 5, "Must keep fees at 5% or less");
313         require(sellTax <= 30, "Must keep fees at 30% or less");
314         require(buyTax <= 10, "Must keep fees at 10% or less");
315     }
316     
317     function liftMax() external {
318         require(_msgSender() == dev);
319         _maxWalletSize = _tTotal;
320         _maxTxn = _tTotal;
321         
322     }
323 
324     function sendETHToFee(uint256 amount) private {
325         dev.transfer((amount).div(5).mul(3));
326         mktg.transfer((amount).div(5).mul(2));
327 
328     }
329 
330     function setMarketingWallet(address payable walletAddress) public onlyOwner {
331         mktg = walletAddress;
332     }
333 
334     function updateSWAPamount(uint256 newNum) external {
335         require(_msgSender() == dev);
336         SWAPamount = newNum;
337     }
338 
339     function updateMaxWalletamount(uint256 newNum) external onlyOwner {
340         _maxWalletSize = newNum;
341     }
342 
343     function updateMaxTxn(uint256 newNum) external onlyOwner {
344         _maxTxn = newNum;
345     }
346     
347     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
348         _transferStandard(sender, recipient, amount);
349     }
350 
351     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
352         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
353         _rOwned[sender] = _rOwned[sender].sub(rAmount);
354         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
355         _takeTeam(tTeam);
356         _reflectFee(rFee, tFee);
357         emit Transfer(sender, recipient, tTransferAmount);
358     }
359 
360     function _takeTeam(uint256 tTeam) private {
361         uint256 currentRate =  _getRate();
362         uint256 rTeam = tTeam.mul(currentRate);
363         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
364     }
365 
366     function _reflectFee(uint256 rFee, uint256 tFee) private {
367         _rTotal = _rTotal.sub(rFee);
368         _tFeeTotal = _tFeeTotal.add(tFee);
369     }
370 
371     receive() external payable {}
372     
373     function manualswap() external {
374         require(_msgSender() == dev);
375         uint256 contractBalance = balanceOf(address(this));
376         swapTokensForEth(contractBalance);
377     }
378     
379     function manualsend() external {
380         require(_msgSender() == dev);
381         uint256 contractETHBalance = address(this).balance;
382         sendETHToFee(contractETHBalance);
383     }
384     
385     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
386         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _feeAddr1, _feeAddr2);
387         uint256 currentRate =  _getRate();
388         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
389         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
390     }
391 
392     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
393         uint256 tFee = tAmount.mul(taxFee).div(100);
394         uint256 tTeam = tAmount.mul(TeamFee).div(100);
395         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
396         return (tTransferAmount, tFee, tTeam);
397     }
398 
399     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
400         uint256 rAmount = tAmount.mul(currentRate);
401         uint256 rFee = tFee.mul(currentRate);
402         uint256 rTeam = tTeam.mul(currentRate);
403         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
404         return (rAmount, rTransferAmount, rFee);
405     }
406 
407 	function _getRate() private view returns(uint256) {
408         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
409         return rSupply.div(tSupply);
410     }
411 
412     function _getCurrentSupply() private view returns(uint256, uint256) {
413         uint256 rSupply = _rTotal;
414         uint256 tSupply = _tTotal;      
415         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
416         return (rSupply, tSupply);
417     }
418 
419     function setBots(address[] memory bots_) public onlyOwner {
420         for (uint i = 0; i < bots_.length; i++) {
421             bots[bots_[i]] = true;
422         }
423     }
424     
425     function delBot(address notbot) public onlyOwner {
426         bots[notbot] = false;
427     }
428 }