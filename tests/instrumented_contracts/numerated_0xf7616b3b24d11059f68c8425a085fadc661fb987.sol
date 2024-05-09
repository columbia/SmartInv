1 // SPDX-License-Identifier: Unlicensed
2 
3 pragma solidity ^0.8.4;
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address) {
7         return msg.sender;
8     }
9 }
10 
11 interface IERC20 {
12     function totalSupply() external view returns (uint256);
13     function balanceOf(address account) external view returns (uint256);
14     function transfer(address recipient, uint256 amount) external returns (bool);
15     function allowance(address owner, address spender) external view returns (uint256);
16     function approve(address spender, uint256 amount) external returns (bool);
17     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
18     event Transfer(address indexed from, address indexed to, uint256 value);
19     event Approval(address indexed owner, address indexed spender, uint256 value);
20 }
21 
22 library SafeMath {
23     function add(uint256 a, uint256 b) internal pure returns (uint256) {
24         uint256 c = a + b;
25         require(c >= a, "SafeMath: addition overflow");
26         return c;
27     }
28 
29     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
30         return sub(a, b, "SafeMath: subtraction overflow");
31     }
32 
33     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
34         require(b <= a, errorMessage);
35         uint256 c = a - b;
36         return c;
37     }
38 
39     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
40         if (a == 0) {
41             return 0;
42         }
43         uint256 c = a * b;
44         require(c / a == b, "SafeMath: multiplication overflow");
45         return c;
46     }
47 
48     function div(uint256 a, uint256 b) internal pure returns (uint256) {
49         return div(a, b, "SafeMath: division by zero");
50     }
51 
52     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
53         require(b > 0, errorMessage);
54         uint256 c = a / b;
55         return c;
56     }
57 
58 }
59 
60 abstract contract Ownable is Context {
61     address private _owner;
62 
63     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
64 
65     constructor() {
66         _transferOwnership(_msgSender());
67     }
68 
69     function owner() public view virtual returns (address) {
70         return _owner;
71     }
72 
73     modifier onlyOwner() {
74         require(owner() == _msgSender(), "Ownable: caller is not the owner");
75         _;
76     }
77 
78     function renounceOwnership() public virtual onlyOwner {
79         _transferOwnership(address(0));
80     }
81 
82     function transferOwnership(address newOwner) public virtual onlyOwner {
83         require(newOwner != address(0), "Ownable: new owner is the zero address");
84         _transferOwnership(newOwner);
85     }
86 
87     function _transferOwnership(address newOwner) internal virtual {
88         address oldOwner = _owner;
89         _owner = newOwner;
90         emit OwnershipTransferred(oldOwner, newOwner);
91     }
92 } 
93 
94 interface IUniswapV2Factory {
95     function createPair(address tokenA, address tokenB) external returns (address pair);
96 }
97 
98 interface IUniswapV2Router02 {
99     function swapExactTokensForETHSupportingFeeOnTransferTokens(
100         uint amountIn,
101         uint amountOutMin,
102         address[] calldata path,
103         address to,
104         uint deadline
105     ) external;
106     function factory() external pure returns (address);
107     function WETH() external pure returns (address);
108     function addLiquidityETH(
109         address token,
110         uint amountTokenDesired,
111         uint amountTokenMin,
112         uint amountETHMin,
113         address to,
114         uint deadline
115     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
116 }
117 
118 contract PULSETSUKA  is Context, IERC20, Ownable {
119     using SafeMath for uint256;
120     mapping (address => uint256) private _rOwned;
121     mapping (address => uint256) private _tOwned;
122     mapping (address => mapping (address => uint256)) private _allowances;
123     mapping (address => bool) private _isExcludedFromFee;
124     mapping (address => bool) private bots;
125 
126     uint256 private constant MAX = ~uint256(0);
127     uint256 private constant _tTotal = 100 * 1e10 * 1e9; 
128     uint256 public _maxWalletSize;
129     uint256 public _maxTxn;
130 
131     uint256 private _rTotal = (MAX - (MAX % _tTotal));
132     uint256 private _tFeeTotal;
133     uint256 private _sellTax;
134     uint256 private _buyTax;
135     uint256 public SWAPamount = 7 * 1e8 * 1e9; // .07%
136     
137     uint256 private _feeAddr1;
138     uint256 private _feeAddr2;
139     address payable private dev;
140     address payable private mktg;
141 
142 
143     event maxWalletSizeamountUpdated(uint _maxWalletSize);
144     event maxTxnUpdate(uint _maxTxn);
145     event SWAPamountUpdated(uint SWAPamount);
146 
147     string private constant _name = "Lotus";
148     string private constant _symbol = "KAI";
149     uint8 private constant _decimals = 9;
150     
151     IUniswapV2Router02 private uniswapV2Router;
152     address private uniswapV2Pair;
153     bool private tradingOpen;
154     bool private inSwap = false;
155     bool private swapEnabled = false;
156    
157     modifier lockTheSwap {
158         inSwap = true;
159         _;
160         inSwap = false;
161     }
162     constructor () {
163         dev = payable(0xbDF8e21dAB1056EB2A2F1547C70D05Fe98243614);
164         mktg = payable(0xbDF8e21dAB1056EB2A2F1547C70D05Fe98243614);
165 
166         _rOwned[address(this)] = _rTotal;
167         _sellTax =25;
168         _buyTax = 5;
169         _isExcludedFromFee[owner()] = true;
170         _isExcludedFromFee[address(this)] = true;
171         _isExcludedFromFee[dev] = true;
172         _isExcludedFromFee[address(0)] = true;
173 
174 
175         emit Transfer(address(0), address(this), _tTotal);
176     }
177 
178     function name() public pure returns (string memory) {
179         return _name;
180     }
181 
182     function symbol() public pure returns (string memory) {
183         return _symbol;
184     }
185 
186     function decimals() public pure returns (uint8) {
187         return _decimals;
188     }
189 
190     function totalSupply() public pure override returns (uint256) {
191         return _tTotal;
192     }
193 
194     function balanceOf(address account) public view override returns (uint256) {
195         return tokenFromReflection(_rOwned[account]);
196     }
197 
198     function transfer(address recipient, uint256 amount) public override returns (bool) {
199         _transfer(_msgSender(), recipient, amount);
200         return true;
201     }
202 
203     function allowance(address owner, address spender) public view override returns (uint256) {
204         return _allowances[owner][spender];
205     }
206 
207     function approve(address spender, uint256 amount) public override returns (bool) {
208         _approve(_msgSender(), spender, amount);
209         return true;
210     }
211 
212     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
213         _transfer(sender, recipient, amount);
214         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
215         return true;
216     }
217 
218     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
219         require(rAmount <= _rTotal, "Amount must be less than total reflections");
220         uint256 currentRate =  _getRate();
221         return rAmount.div(currentRate);
222     }
223 
224     function _approve(address owner, address spender, uint256 amount) private {
225         require(owner != address(0), "ERC20: approve from the zero address");
226         require(spender != address(0), "ERC20: approve to the zero address");
227         _allowances[owner][spender] = amount;
228         emit Approval(owner, spender, amount);
229     }
230 
231     function _transfer(address from, address to, uint256 amount) private {
232         require(!bots[from] && !bots[to]);
233         require(amount > 0, "Transfer amount must be greater than zero");
234         
235         if (! _isExcludedFromFee[to] && ! _isExcludedFromFee[from]) {
236             _feeAddr1 = 0;
237             _feeAddr2 = _buyTax;
238         }
239 
240         if (to != uniswapV2Pair && ! _isExcludedFromFee[to] && ! _isExcludedFromFee[from]) {
241             require(amount + balanceOf(to) <= _maxWalletSize, "Over max wallet size.");
242             require(amount <= _maxTxn, "Buy transfer amount exceeds the maxTransactionAmount.");
243 
244         }
245         
246 
247         if (to == uniswapV2Pair && from != address(uniswapV2Router) && ! _isExcludedFromFee[from]) {
248             require(!bots[from] && !bots[to]);
249             _feeAddr1 = 0;
250             _feeAddr2 = _sellTax;
251         }
252 
253         if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
254             _feeAddr1 = 0;
255             _feeAddr2 = 0;
256         }
257 
258         uint256 contractTokenBalance = balanceOf(address(this));
259         if (!inSwap && from != uniswapV2Pair && swapEnabled) {
260             if (contractTokenBalance > SWAPamount) {
261                 swapTokensForEth(contractTokenBalance);
262             }
263             
264             uint256 contractETHBalance = address(this).balance;
265             if(contractETHBalance > 0) {
266                 sendETHToFee(address(this).balance);
267             }
268         }    
269 		
270         _tokenTransfer(from,to,amount);
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
281         _maxWalletSize = 3 * 1e10 * 1e9;
282         _maxTxn = 2 * 1e10 * 1e9;
283 
284         tradingOpen = true;
285         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
286     }
287 
288     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
289         address[] memory path = new address[](2);
290         path[0] = address(this);
291         path[1] = uniswapV2Router.WETH();
292         _approve(address(this), address(uniswapV2Router), tokenAmount);
293         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
294             tokenAmount,
295             0,
296             path,
297             address(this),
298             block.timestamp
299         );
300     }
301 
302     function updateFees(uint256 sellTax, uint256 reflections, uint256 buyTax) external onlyOwner {
303         _feeAddr1 = reflections;
304         _sellTax = sellTax;
305         _buyTax = buyTax;
306         require(reflections <= 5, "Must keep fees at 5% or less");
307         require(sellTax <= 15, "Must keep fees at 18% or less");
308         require(buyTax <= 10, "Must keep fees at 10% or less");
309     }
310     
311     function liftMax() external {
312         require(_msgSender() == dev);
313         _maxWalletSize = _tTotal;
314         _maxTxn = _tTotal;
315         
316     }
317 
318     function sendETHToFee(uint256 amount) private {
319         dev.transfer((amount).div(5).mul(3));
320         mktg.transfer((amount).div(5).mul(2));
321 
322     }
323 
324     function setMarketingWallet(address payable walletAddress) public onlyOwner {
325         mktg = walletAddress;
326     }
327 
328     function updateSWAPamount(uint256 newNum) external {
329         require(_msgSender() == dev);
330         SWAPamount = newNum;
331     }
332 
333     function updateMaxWalletamount(uint256 newNum) external onlyOwner {
334         _maxWalletSize = newNum;
335     }
336 
337     function updateMaxTxn(uint256 newNum) external onlyOwner {
338         _maxTxn = newNum;
339     }
340     
341     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
342         _transferStandard(sender, recipient, amount);
343     }
344 
345     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
346         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
347         _rOwned[sender] = _rOwned[sender].sub(rAmount);
348         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
349         _takeTeam(tTeam);
350         _reflectFee(rFee, tFee);
351         emit Transfer(sender, recipient, tTransferAmount);
352     }
353 
354     function _takeTeam(uint256 tTeam) private {
355         uint256 currentRate =  _getRate();
356         uint256 rTeam = tTeam.mul(currentRate);
357         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
358     }
359 
360     function _reflectFee(uint256 rFee, uint256 tFee) private {
361         _rTotal = _rTotal.sub(rFee);
362         _tFeeTotal = _tFeeTotal.add(tFee);
363     }
364 
365     receive() external payable {}
366     
367     function manualswap() external {
368         require(_msgSender() == dev);
369         uint256 contractBalance = balanceOf(address(this));
370         swapTokensForEth(contractBalance);
371     }
372     
373     function manualsend() external {
374         require(_msgSender() == dev);
375         uint256 contractETHBalance = address(this).balance;
376         sendETHToFee(contractETHBalance);
377     }
378     
379     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
380         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _feeAddr1, _feeAddr2);
381         uint256 currentRate =  _getRate();
382         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
383         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
384     }
385 
386     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
387         uint256 tFee = tAmount.mul(taxFee).div(100);
388         uint256 tTeam = tAmount.mul(TeamFee).div(100);
389         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
390         return (tTransferAmount, tFee, tTeam);
391     }
392 
393     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
394         uint256 rAmount = tAmount.mul(currentRate);
395         uint256 rFee = tFee.mul(currentRate);
396         uint256 rTeam = tTeam.mul(currentRate);
397         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
398         return (rAmount, rTransferAmount, rFee);
399     }
400 
401 	function _getRate() private view returns(uint256) {
402         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
403         return rSupply.div(tSupply);
404     }
405 
406     function _getCurrentSupply() private view returns(uint256, uint256) {
407         uint256 rSupply = _rTotal;
408         uint256 tSupply = _tTotal;      
409         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
410         return (rSupply, tSupply);
411     }
412 
413     function setBots(address[] memory bots_) public onlyOwner {
414         for (uint i = 0; i < bots_.length; i++) {
415             bots[bots_[i]] = true;
416         }
417     }
418     
419     function delBot(address notbot) public onlyOwner {
420         bots[notbot] = false;
421     }
422 }