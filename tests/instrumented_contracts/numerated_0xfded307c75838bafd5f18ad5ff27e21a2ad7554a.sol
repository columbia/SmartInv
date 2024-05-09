1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.4;
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
56 
57 }
58 
59 contract Ownable is Context {
60     address private _owner;
61     address private _previousOwner;
62     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
63 
64     constructor () {
65         address msgSender = _msgSender();
66         _owner = msgSender;
67         emit OwnershipTransferred(address(0), msgSender);
68     }
69 
70     function owner() public view returns (address) {
71         return _owner;
72     }
73 
74     modifier onlyOwner() {
75         require(_owner == _msgSender(), "Ownable: caller is not the owner");
76         _;
77     }
78 
79     function renounceOwnership() public virtual onlyOwner {
80         emit OwnershipTransferred(_owner, address(0));
81         _owner = address(0);
82     }
83 
84 }  
85 
86 interface IUniswapV2Factory {
87     function createPair(address tokenA, address tokenB) external returns (address pair);
88 }
89 
90 interface IUniswapV2Router02 {
91     function swapExactTokensForETHSupportingFeeOnTransferTokens(
92         uint amountIn,
93         uint amountOutMin,
94         address[] calldata path,
95         address to,
96         uint deadline
97     ) external;
98     function factory() external pure returns (address);
99     function WETH() external pure returns (address);
100     function addLiquidityETH(
101         address token,
102         uint amountTokenDesired,
103         uint amountTokenMin,
104         uint amountETHMin,
105         address to,
106         uint deadline
107     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
108 }
109 
110 interface IUniswapV2Pair {
111 	function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
112 }
113 
114 contract AllTimeHigh is Context, IERC20, Ownable {
115     using SafeMath for uint256;
116     mapping (address => uint256) private _rOwned;
117     mapping (address => uint256) private _tOwned;
118     mapping (address => mapping (address => uint256)) private _allowances;
119     mapping (address => bool) private _isExcludedFromFee;
120     mapping (address => uint256) private sellcooldown;
121     mapping (address => uint256) private buycooldown;
122     mapping (address => bool) private bots;
123     uint256 private constant MAX = ~uint256(0);
124     uint256 private constant _tTotal = 1000000 * 10**18;
125     uint256 private _rTotal = (MAX - (MAX % _tTotal));
126     uint256 private _tFeeTotal;
127 	uint256 private _ATHPrice;
128 	uint256 private _ATHResetPrice;
129 	uint256 private _ATHResetPercent;
130 	uint256 private _maxTxAmount = _tTotal;
131     
132     uint8 private _devFee = 2;
133     uint8 private _ATHFee = 3;
134     address payable private _devWallet;
135     address payable private _ATHWallet;
136     
137     
138     string private constant _name = unicode"All Time High \\_(\xE3\x83\x84)_/";
139     string private constant _symbol = "ATH";
140     uint8 private constant _decimals = 18;
141     
142     IUniswapV2Router02 private uniswapV2Router;
143 	IUniswapV2Pair private uniswapV2Pair;
144     address private _uniswapV2Pair;
145     bool private tradingOpen;
146     bool private inSwap = false;
147     bool private swapEnabled = false;
148 	
149 	
150 	event ATHUpdated(uint256 _ATHPrice, address _ATHWallet);
151 	event MaxTxAmountUpdated(uint256 _maxTxAmount);
152 	
153     modifier lockTheSwap {
154         inSwap = true;
155         _;
156         inSwap = false;
157     }
158     
159     receive() external payable {}   
160     
161     constructor () {
162         _devWallet = payable(_msgSender());
163         _ATHWallet = payable(0);
164         _rOwned[address(this)] = _rTotal;
165         _isExcludedFromFee[owner()] = true;
166         _isExcludedFromFee[address(this)] = true;
167         _isExcludedFromFee[_devWallet] = true;
168 		_ATHPrice = 0;
169 		_ATHResetPrice = 0;
170 		_ATHResetPercent = 60;
171 		emit Transfer(address(0), address(this), _tTotal);
172     }
173 
174     function name() public pure returns (string memory) {
175         return _name;
176     }
177 
178     function symbol() public pure returns (string memory) {
179         return _symbol;
180     }
181 
182     function decimals() public pure returns (uint8) {
183         return _decimals;
184     }
185 
186     function totalSupply() public pure override returns (uint256) {
187         return _tTotal;
188     }
189     
190     function ATHPrice() public view returns (uint256) {
191         return _ATHPrice;
192     }
193     
194     function ATHWallet() public view returns (address) {
195         return _ATHWallet;
196     }
197 	
198 	function pairAddress() public view returns (address) {
199         return _uniswapV2Pair;
200     }
201     
202     function ATHResetPrice() public view returns (uint256) {
203         return _ATHResetPrice;
204     }
205     
206     function maxTxAmount() public view returns (uint256) {
207         return _maxTxAmount;
208     }
209 
210     function balanceOf(address account) public view override returns (uint256) {
211         return tokenFromReflection(_rOwned[account]);
212     }
213 
214     function transfer(address recipient, uint256 amount) public override returns (bool) {
215         _transfer(_msgSender(), recipient, amount);
216         return true;
217     }
218 
219     function allowance(address owner, address spender) public view override returns (uint256) {
220         return _allowances[owner][spender];
221     }
222 
223     function approve(address spender, uint256 amount) public override returns (bool) {
224         _approve(_msgSender(), spender, amount);
225         return true;
226     }
227 
228     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
229         _transfer(sender, recipient, amount);
230         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
231         return true;
232     }
233 
234     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
235         require(rAmount <= _rTotal, "Amount must be less than total reflections");
236         uint256 currentRate =  _getRate();
237         return rAmount.div(currentRate);
238     }
239 
240     function _approve(address owner, address spender, uint256 amount) private {
241         require(owner != address(0), "ERC20: approve from the zero address");
242         require(spender != address(0), "ERC20: approve to the zero address");
243 		if (owner != address(this)) {
244 			require(tradingOpen, "Trading not open yet");
245 		}
246         _allowances[owner][spender] = amount;
247         emit Approval(owner, spender, amount);
248     }
249 
250     function _transfer(address from, address to, uint256 amount) private {
251         require(from != address(0), "ERC20: transfer from the zero address");
252         require(to != address(0), "ERC20: transfer to the zero address");
253         require(amount > 0, "Transfer amount must be greater than zero");
254         if (from != owner() && to != owner()) {
255             require(!bots[from] && !bots[to]);
256             if (from == _uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to]) {
257                 // Buying
258 				require(tradingOpen);
259                 require(amount <= _maxTxAmount, "Buy amount exceeds max TX amount");
260                 require(buycooldown[to] < block.timestamp, "Buying again too soon");
261 				
262 				sellcooldown[to] = block.timestamp + (5 minutes);
263 				buycooldown[to] = block.timestamp + (3 minutes);
264 				
265 				uint256 currentPrice = getPrice();
266 				if (currentPrice > _ATHPrice) {
267 					// new ATH has been reached 
268 					_ATHWallet = payable(to);
269 					_ATHPrice = currentPrice;
270 					_ATHResetPrice = currentPrice.sub(currentPrice.mul(_ATHResetPercent).div(10**2));
271 					emit ATHUpdated(_ATHPrice, _ATHWallet);
272 				}
273 			}
274 			
275             if (from == _ATHWallet) {
276 				// Our ATH wallet holder is selling/transferring,
277 				// reset price so next buyer becomes ATH holder.
278 				_ATHPrice = 0;
279 				_ATHWallet = payable(0);
280 				emit ATHUpdated(_ATHPrice, _ATHWallet);
281 			}
282             
283             uint256 contractTokenBalance = balanceOf(address(this));
284             if (!inSwap && from != _uniswapV2Pair && swapEnabled) {
285                 require(sellcooldown[from] < block.timestamp, "Selling too soon");
286                 // Check to see if price has gone below ATH Reset price.
287                 uint256 currentPrice = getPrice();
288                 if (currentPrice < _ATHResetPrice) {
289                         _ATHPrice = 0;
290                         _ATHWallet = payable(0);
291                         _ATHResetPrice = 0;
292                 }
293                 swapTokensForEth(contractTokenBalance);
294                 uint256 contractETHBalance = address(this).balance;
295                 if(contractETHBalance > 0 && _ATHWallet != address(0)) {
296                     sendETHToFee(address(this).balance);
297                 }
298             }
299 
300         }
301         _tokenTransfer(from,to,amount);
302     }
303 
304     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
305         address[] memory path = new address[](2);
306         path[0] = address(this);
307         path[1] = uniswapV2Router.WETH();
308         _approve(address(this), address(uniswapV2Router), tokenAmount);
309         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
310             tokenAmount,
311             0,
312             path,
313             address(this),
314             block.timestamp
315         );
316     }
317         
318     function sendETHToFee(uint256 amount) private {
319         _devWallet.transfer(amount.div(4));
320         _ATHWallet.transfer(amount.div(6));
321     }
322     
323     function createPair() public onlyOwner() {
324         require(!tradingOpen,"trading is already open");
325         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
326         uniswapV2Router = _uniswapV2Router;
327         _approve(address(this), address(uniswapV2Router), _tTotal);
328         _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
329         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
330         IERC20(_uniswapV2Pair).approve(address(uniswapV2Router), type(uint256).max);
331     }
332     
333     function openTrading() public onlyOwner(){
334         require(!tradingOpen, "trading is already open");
335         swapEnabled = true;
336         tradingOpen = true;
337     }
338     
339     function athResetPercent(uint256 newResetPercent) external onlyOwner() {
340         _ATHResetPercent = newResetPercent;
341     }
342     
343     function setBots(address[] memory bots_) public onlyOwner {
344         for (uint i = 0; i < bots_.length; i++) {
345             bots[bots_[i]] = true;
346         }
347     }
348     
349     function delBot(address notbot) public onlyOwner {
350         bots[notbot] = false;
351     }
352 	
353 	function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
354         require(maxTxPercent > 0, "Amount must be greater than 0");
355         _maxTxAmount = _tTotal.mul(maxTxPercent).div(10**2);
356         emit MaxTxAmountUpdated(_maxTxAmount);
357     }
358         
359     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
360         _transferStandard(sender, recipient, amount);
361     }
362 
363     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
364         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
365         _rOwned[sender] = _rOwned[sender].sub(rAmount);
366         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
367         _takeTeam(tTeam);
368         _reflectFee(rFee, tFee);
369         emit Transfer(sender, recipient, tTransferAmount);
370     }
371 
372     function _takeTeam(uint256 tTeam) private {
373         uint256 currentRate =  _getRate();
374         uint256 rTeam = tTeam.mul(currentRate);
375         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
376     }
377 
378     function _reflectFee(uint256 rFee, uint256 tFee) private {
379         _rTotal = _rTotal.sub(rFee);
380         _tFeeTotal = _tFeeTotal.add(tFee);
381     }
382 
383     function manualswap() external {
384         require(_msgSender() == _devWallet);
385         uint256 contractBalance = balanceOf(address(this));
386         swapTokensForEth(contractBalance);
387     }
388     
389     function manualsend() external {
390         require(_msgSender() == _devWallet);
391         uint256 contractETHBalance = address(this).balance;
392         sendETHToFee(contractETHBalance);
393     }
394 	
395 	function getPrice() public view returns (uint256) {
396 	    require(tradingOpen,"trading isn't open");
397 		IUniswapV2Pair pair = IUniswapV2Pair(_uniswapV2Pair);
398 		(uint112 token0, uint112 token1, uint32 blockTimestamp) = pair.getReserves();
399 		(uint256 tokenReserves, uint256 ethReserves) = (address(this) < uniswapV2Router.WETH()) ? (token0, token1) : (token1, token0);
400 		return ethReserves.mul(10000000000).div(tokenReserves);
401 	}
402 	
403     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
404         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _devFee, _ATHFee);
405         uint256 currentRate =  _getRate();
406         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
407         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
408     }
409 
410     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
411         uint256 tFee = tAmount.mul(taxFee).div(100);
412         uint256 tTeam = tAmount.mul(TeamFee).div(100);
413         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
414         return (tTransferAmount, tFee, tTeam);
415     }
416 
417     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
418         uint256 rAmount = tAmount.mul(currentRate);
419         uint256 rFee = tFee.mul(currentRate);
420         uint256 rTeam = tTeam.mul(currentRate);
421         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
422         return (rAmount, rTransferAmount, rFee);
423     }
424 
425 	function _getRate() private view returns(uint256) {
426         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
427         return rSupply.div(tSupply);
428     }
429 
430     function _getCurrentSupply() private view returns(uint256, uint256) {
431         uint256 rSupply = _rTotal;
432         uint256 tSupply = _tTotal;      
433         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
434         return (rSupply, tSupply);
435     }
436 	
437 	
438 }