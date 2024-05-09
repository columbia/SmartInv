1 // SPDX-License-Identifier: MIT
2 pragma solidity >=0.7.0 <0.8.0;
3 
4 abstract contract Context {
5     function _msgSender() internal view virtual returns (address) {
6         return msg.sender;
7     }
8 }
9 
10 interface IERC20 {
11     function totalSupply() external view returns (uint256);
12     function balanceOf(address account) external view returns (uint256);
13     function transfer(address recipient, uint256 amount) external returns (bool);
14     function allowance(address owner, address spender) external view returns (uint256);
15     function approve(address spender, uint256 amount) external returns (bool);
16     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
17     event Transfer(address indexed from, address indexed to, uint256 value);
18     event Approval(address indexed owner, address indexed spender, uint256 value);
19 }
20 
21 library SafeMath {
22     function add(uint256 a, uint256 b) internal pure returns (uint256) {
23         uint256 c = a + b;
24         require(c >= a, "SafeMath: addition overflow");
25         return c;
26     }
27 
28     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
29         return sub(a, b, "SafeMath: subtraction overflow");
30     }
31 
32     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
33         require(b <= a, errorMessage);
34         uint256 c = a - b;
35         return c;
36     }
37 
38     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
39         if (a == 0) {
40             return 0;
41         }
42         uint256 c = a * b;
43         require(c / a == b, "SafeMath: multiplication overflow");
44         return c;
45     }
46 
47     function div(uint256 a, uint256 b) internal pure returns (uint256) {
48         return div(a, b, "SafeMath: division by zero");
49     }
50 
51     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
52         require(b > 0, errorMessage);
53         uint256 c = a / b;
54         return c;
55     }
56 }
57 
58 contract Ownable is Context {
59     address private _owner;
60     address private _previousOwner;
61     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
62 
63     constructor() {
64         address msgSender = _msgSender();
65         _owner = msgSender;
66         emit OwnershipTransferred(address(0), msgSender);
67     }
68 
69     function owner() public view returns (address) {
70         return _owner;
71     }
72 
73     modifier onlyOwner() {
74         require(_owner == _msgSender(), "Ownable: caller is not the owner");
75         _;
76     }
77 
78     function renounceOwnership() public virtual onlyOwner {
79         emit OwnershipTransferred(_owner, address(0));
80         _owner = address(0);
81     }
82 }
83 
84 interface IUniswapV2Factory {
85     function createPair(address tokenA, address tokenB) external returns (address pair);
86 }
87 
88 interface IUniswapV2Router02 {
89     function swapExactTokensForETHSupportingFeeOnTransferTokens(
90         uint256 amountIn,
91         uint256 amountOutMin,
92         address[] calldata path,
93         address to,
94         uint256 deadline
95     ) external;
96     function swapExactETHForTokensSupportingFeeOnTransferTokens(
97         uint amountOutMin,
98         address[] calldata path,
99         address to,
100         uint deadline
101     ) external payable;
102     function factory() external pure returns (address);
103     function WETH() external pure returns (address);
104     function addLiquidityETH(
105         address token,
106         uint256 amountTokenDesired,
107         uint256 amountTokenMin,
108         uint256 amountETHMin,
109         address to,
110         uint256 deadline
111     ) external payable returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
112 }
113 
114 contract PROGEV2 is Context, IERC20, Ownable {
115     using SafeMath for uint256;
116     string private constant _name = "Protector Roge"; 
117     string private constant _symbol = "PROGE";
118     uint8 private constant _decimals = 9;
119 
120     mapping(address => uint256) private _rOwned;
121     mapping(address => uint256) private _tOwned;    
122     uint256 private constant MAX = ~uint256(0);
123     uint256 private _tTotal = 100000000000000000 * 10**9;
124     uint256 private _rTotal = (MAX - (MAX % _tTotal));
125     uint256 private _tFeeTotal;
126     uint256 public _progeBurned;
127 
128     mapping(address => mapping(address => uint256)) private _allowances;
129     mapping(address => bool) private _isExcludedFromFee;
130     
131     address payable private _presa;
132     address payable private _rogeTreasury;
133     
134     address public ROGE = 0x45734927Fa2f616FbE19E65f42A0ef3d37d1c80A; 
135     address public animalSanctuary = 0x4A462404ca4b7caE9F639732EB4DaB75d6E88d19;  
136 
137     IUniswapV2Router02 private uniswapV2Router;
138     address public uniswapV2Pair;
139 
140     bool public tradeAllowed = false;
141     bool private liquidityAdded = false;
142     bool private inSwap = false;
143     bool public swapEnabled = false;
144     bool private feeEnabled = false;
145     bool private limitTX = false;
146 
147     uint256 private _maxTxAmount = _tTotal;     
148     uint256 private _reflection = 2;
149     uint256 private _contractFee = 9;
150     uint256 private _progeBurn = 1;
151 
152     event MaxTxAmountUpdated(uint256 _maxTxAmount);
153     modifier lockTheSwap {
154         inSwap = true;
155         _;
156         inSwap = false;
157     }
158     constructor(address payable addr1, address payable addr2, address addr3) {
159         _presa = addr1;
160         _rogeTreasury = addr2;
161         _rOwned[_msgSender()] = _rTotal;
162         _isExcludedFromFee[owner()] = true;
163         _isExcludedFromFee[address(this)] = true;
164         _isExcludedFromFee[_presa] = true;
165         _isExcludedFromFee[_rogeTreasury] = true;
166         _isExcludedFromFee[addr3] = true;
167         emit Transfer(address(0), _msgSender(), _tTotal);
168     }
169     
170     function name() public pure returns (string memory) {
171         return _name;
172     }
173 
174     function symbol() public pure returns (string memory) {
175         return _symbol;
176     }
177 
178     function decimals() public pure returns (uint8) {
179         return _decimals;
180     }
181 
182     function totalSupply() public view override returns (uint256) {
183         return _tTotal;
184     }
185 
186     function balanceOf(address account) public view override returns (uint256) {
187         return tokenFromReflection(_rOwned[account]);
188     }
189     
190     function setExcludedFromFee(address account) public onlyOwner {
191         address addr3 = account;
192         _isExcludedFromFee[addr3] = true;
193     }
194 
195     function transfer(address recipient, uint256 amount) public override returns (bool) {
196         _transfer(_msgSender(), recipient, amount);
197         return true;
198     }
199 
200     function allowance(address owner, address spender) public view override returns (uint256) {
201         return _allowances[owner][spender];
202     }
203 
204     function approve(address spender, uint256 amount) public override returns (bool) {
205         _approve(_msgSender(), spender, amount);
206         return true;
207     }
208 
209     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
210         _transfer(sender, recipient, amount);
211         _approve(sender,_msgSender(),_allowances[sender][_msgSender()].sub(amount,"ERC20: transfer amount exceeds allowance"));
212         return true;
213     }
214     
215     function setFeeEnabled( bool enable) public onlyOwner {
216         feeEnabled = enable;
217     }
218     
219     function setLimitTx( bool enable) public onlyOwner {
220         limitTX = enable;
221     }
222 
223     function enableTrading( bool enable) public onlyOwner {
224         require(liquidityAdded);
225         tradeAllowed = enable;
226     }
227 
228     function addLiquidity() external onlyOwner() {
229         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
230         uniswapV2Router = _uniswapV2Router;
231         _approve(address(this), address(uniswapV2Router), _tTotal);
232         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
233         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
234         swapEnabled = true;
235         liquidityAdded = true;
236         feeEnabled = true;
237         limitTX = true;
238         _maxTxAmount = 1000000000000000 * 10**9;
239         IERC20(uniswapV2Pair).approve(address(uniswapV2Router),type(uint256).max);
240     }
241 
242     function manualSwapTokensForEth() external onlyOwner() {
243         uint256 contractBalance = balanceOf(address(this));
244         swapTokensForEth(contractBalance);
245     }
246 
247     function manualDistributeETH() external onlyOwner() {
248         uint256 contractETHBalance = address(this).balance;
249         distributeETH(contractETHBalance);
250     }
251     
252     function manualRoge(uint amount) external onlyOwner() {
253         swapETHforRoge(amount);
254     }
255 
256 
257     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
258         require(maxTxPercent > 0, "Amount must be greater than 0");
259         _maxTxAmount = _tTotal.mul(maxTxPercent).div(10**2);
260         emit MaxTxAmountUpdated(_maxTxAmount);
261     }
262 
263     function tokenFromReflection(uint256 rAmount) private view returns (uint256) {
264         require(rAmount <= _rTotal,"Amount must be less than total reflections");
265         uint256 currentRate = _getRate();
266         return rAmount.div(currentRate);
267     }
268 
269     function _approve(address owner, address spender, uint256 amount) private {
270         require(owner != address(0), "ERC20: approve from the zero address");
271         require(spender != address(0), "ERC20: approve to the zero address");
272         _allowances[owner][spender] = amount;
273         emit Approval(owner, spender, amount);
274     }
275 
276     function _transfer(address from, address to, uint256 amount) private {
277         require(from != address(0), "ERC20: transfer from the zero address");
278         require(to != address(0), "ERC20: transfer to the zero address");
279         require(amount > 0, "Transfer amount must be greater than zero");
280 
281         if (from != owner() && to != owner() && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
282             
283             if (from == uniswapV2Pair && to != address(uniswapV2Router) && !_isExcludedFromFee[to]) {
284                 require(tradeAllowed);
285                 if (limitTX) {
286                 require(amount <= _maxTxAmount);
287                 }
288                 _contractFee = 9;
289                 _reflection = 2;
290                 _progeBurn = 1;
291                 uint contractETHBalance = address(this).balance;
292                 if (contractETHBalance > 0) {
293                     swapETHforRoge(address(this).balance);
294                 }
295             }
296             uint256 contractTokenBalance = balanceOf(address(this));
297             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
298                 require(tradeAllowed);
299                 if (limitTX) {
300                 require(amount <= balanceOf(uniswapV2Pair).mul(3).div(100) && amount <= _maxTxAmount);
301                 }
302                 uint initialETHBalance = address(this).balance;
303                 swapTokensForEth(contractTokenBalance);
304                 uint newETHBalance = address(this).balance;
305                 uint ethToDistribute = newETHBalance.sub(initialETHBalance);
306                 if (ethToDistribute > 0) {
307                     distributeETH(ethToDistribute);
308                 }
309             }
310         }
311         bool takeFee = true;
312         if (_isExcludedFromFee[from] || _isExcludedFromFee[to] || !feeEnabled) {
313             takeFee = false;
314         }
315         _tokenTransfer(from, to, amount, takeFee);
316         restoreAllFee;
317     }
318 
319     function removeAllFee() private {
320         if (_reflection == 0 && _contractFee == 0 && _progeBurn == 0) return;
321         _reflection = 0;
322         _contractFee = 0;
323         _progeBurn = 0;
324     }
325 
326     function restoreAllFee() private {
327         _reflection = 2;
328         _contractFee = 9;
329         _progeBurn = 1;
330     }
331 
332     function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
333         if (!takeFee) removeAllFee();
334         _transferStandard(sender, recipient, amount);
335         if (!takeFee) restoreAllFee();
336     }
337     function _transferStandard(address sender, address recipient, uint256 amount) private {
338         (uint256 tAmount, uint256 tBurn) = _progeEthBurn(amount);
339         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount, tBurn);
340         _rOwned[sender] = _rOwned[sender].sub(rAmount);
341         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
342         _takeTeam(tTeam);
343         _reflectFee(rFee, tFee);
344         emit Transfer(sender, recipient, tTransferAmount);
345     }
346 
347     function _takeTeam(uint256 tTeam) private {
348         uint256 currentRate = _getRate();
349         uint256 rTeam = tTeam.mul(currentRate);
350         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
351     }
352 
353     function _progeEthBurn(uint amount) private returns (uint, uint) {  
354         uint orgAmount = amount;
355         uint256 currentRate = _getRate();
356         uint256 tBurn = amount.mul(_progeBurn).div(100);
357         uint256 rBurn = tBurn.mul(currentRate);
358         _tTotal = _tTotal.sub(tBurn);
359         _rTotal = _rTotal.sub(rBurn);
360         _progeBurned = _progeBurned.add(tBurn);
361         return (orgAmount, tBurn);
362     }
363     
364     function _reflectFee(uint256 rFee, uint256 tFee) private {
365         _rTotal = _rTotal.sub(rFee);
366         _tFeeTotal = _tFeeTotal.add(tFee);
367     }
368 
369     function _getValues(uint256 tAmount, uint256 tBurn) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
370         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _reflection, _contractFee, tBurn);
371         uint256 currentRate = _getRate();
372         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
373         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
374     }
375 
376     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 teamFee, uint256 tBurn) private pure returns (uint256, uint256, uint256) {
377         uint256 tFee = tAmount.mul(taxFee).div(100);
378         uint256 tTeam = tAmount.mul(teamFee).div(100);
379         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam).sub(tBurn);
380         return (tTransferAmount, tFee, tTeam);
381     }
382 
383     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
384         uint256 rAmount = tAmount.mul(currentRate);
385         uint256 rFee = tFee.mul(currentRate);
386         uint256 rTeam = tTeam.mul(currentRate);
387         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
388         return (rAmount, rTransferAmount, rFee);
389     }
390 
391     function _getRate() private view returns (uint256) {
392         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
393         return rSupply.div(tSupply);
394     }
395 
396     function _getCurrentSupply() private view returns (uint256, uint256) {
397         uint256 rSupply = _rTotal;
398         uint256 tSupply = _tTotal;
399         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
400         return (rSupply, tSupply);
401     }
402 
403     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
404         address[] memory path = new address[](2);
405         path[0] = address(this);
406         path[1] = uniswapV2Router.WETH();
407         _approve(address(this), address(uniswapV2Router), tokenAmount);
408         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(tokenAmount, 0, path, address(this), block.timestamp);
409     }
410     
411      function swapETHforRoge(uint ethAmount) private {
412         address[] memory path = new address[](2);
413         path[0] = uniswapV2Router.WETH();
414         path[1] = address(ROGE);
415 
416         _approve(address(this), address(uniswapV2Router), ethAmount);
417         uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: ethAmount}(ethAmount,path,address(animalSanctuary),block.timestamp);
418     }
419 
420     function distributeETH(uint256 amount) private {
421         _presa.transfer(amount.div(9));
422         _rogeTreasury.transfer(amount.div(3));
423     }
424 
425     receive() external payable {}
426 }