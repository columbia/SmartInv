1 pragma solidity ^0.8.0;
2 // SPDX-License-Identifier: Unlicensed
3 
4 interface IERC20 {
5 	function totalSupply() external view returns (uint256);
6 	function balanceOf(address account) external view returns (uint256);
7 	function transfer(address recipient, uint256 amount) external returns (bool);
8 	function allowance(address owner, address spender) external view returns (uint256);
9 	function approve(address spender, uint256 amount) external returns (bool);
10 	function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
11 	event Transfer(address indexed from, address indexed to, uint256 value);
12 	event Approval(address indexed owner, address indexed spender, uint256 value);
13 }
14 
15 abstract contract ReentrancyGuard {
16     uint256 private constant _NOT_ENTERED = 1;
17     uint256 private constant _ENTERED = 2;
18     uint256 private _status;
19     constructor () {
20         _status = _NOT_ENTERED;
21     }
22 
23     modifier nonReentrant() {
24         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
25         _status = _ENTERED;
26         _;
27         _status = _NOT_ENTERED;
28     }
29 }
30 
31 library SafeMath {
32 	function add(uint256 a, uint256 b) internal pure returns (uint256) {uint256 c = a + b; require(c >= a, "SafeMath: addition overflow"); return c;}
33 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {return sub(a, b, "SafeMath: subtraction overflow");}
34 	function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {require(b <= a, errorMessage);uint256 c = a - b;return c;}
35 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {if (a == 0) {return 0;}uint256 c = a * b;require(c / a == b, "SafeMath: multiplication overflow");return c;}
36 	function div(uint256 a, uint256 b) internal pure returns (uint256) {return div(a, b, "SafeMath: division by zero");}
37 	function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {require(b > 0, errorMessage);uint256 c = a / b;return c;}
38 	function mod(uint256 a, uint256 b) internal pure returns (uint256) {return mod(a, b, "SafeMath: modulo by zero");}
39 	function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {require(b != 0, errorMessage);return a % b;}
40 }
41 
42 abstract contract Context {
43 	function _msgSender() internal view virtual returns (address) {return msg.sender;}
44 	function _msgData() internal view virtual returns (bytes memory) {this;return msg.data;}
45 }
46 
47 library Address {
48 
49 	function isContract(address account) internal view returns (bool) {
50 		bytes32 codehash;
51 		bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
52 		// solhint-disable-next-line no-inline-assembly
53 		assembly { codehash := extcodehash(account) }
54 		return (codehash != accountHash && codehash != 0x0);
55 	}
56 
57 	function sendValue(address payable recipient, uint256 amount) internal {
58 		require(address(this).balance >= amount, "Address: insufficient balance");
59 		// solhint-disable-next-line avoid-low-level-calls, avoid-call-value
60 		(bool success, ) = recipient.call{ value: amount }("");
61 		require(success, "Address: unable to send value, recipient may have reverted");
62 	}
63 
64 	function functionCall(address target, bytes memory data) internal returns (bytes memory) {
65 	  return functionCall(target, data, "Address: low-level call failed");
66 	}
67 
68 	function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
69 		return _functionCallWithValue(target, data, 0, errorMessage);
70 	}
71 
72 	function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
73 		return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
74 	}
75 
76 	function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
77 		require(address(this).balance >= value, "Address: insufficient balance for call");
78 		return _functionCallWithValue(target, data, value, errorMessage);
79 	}
80 
81 	function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
82 		require(isContract(target), "Address: call to non-contract");
83 		// solhint-disable-next-line avoid-low-level-calls
84 		(bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
85 		if (success) {
86 			return returndata;
87 		} else {
88 			if (returndata.length > 0) {
89 				// solhint-disable-next-line no-inline-assembly
90 				assembly {
91 					let returndata_size := mload(returndata)
92 					revert(add(32, returndata), returndata_size)
93 				}
94 			} else {
95 				revert(errorMessage);
96 			}
97 		}
98 	}
99 }
100 
101 contract Ownable is Context {
102 	address private _owner;
103 	address private _previousOwner;
104 
105 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
106 	constructor () {
107 		address msgSender = _msgSender();
108 		_owner = msgSender;
109 		emit OwnershipTransferred(address(0), msgSender);
110 	}
111 	function owner() public view returns (address) {return _owner;}
112 	modifier onlyOwner() {require(_owner == _msgSender(), "Ownable: caller is not the owner");_;}
113 	function renounceOwnership() public virtual onlyOwner {emit OwnershipTransferred(_owner, address(0)); _owner = address(0);}
114 	function transferOwnership(address newOwner) public virtual onlyOwner {
115 		require(newOwner != address(0), "Ownable: new owner is the zero address");
116 		emit OwnershipTransferred(_owner, newOwner);
117 		_owner = newOwner;
118 	}
119 }
120 
121 interface IUniswapV2Factory {
122 	event PairCreated(address indexed token0, address indexed token1, address pair, uint);
123 	function feeTo() external view returns (address);
124 	function feeToSetter() external view returns (address);
125 	function getPair(address tokenA, address tokenB) external view returns (address pair);
126 	function allPairs(uint) external view returns (address pair);
127 	function allPairsLength() external view returns (uint);
128 	function createPair(address tokenA, address tokenB) external returns (address pair);
129 	function setFeeTo(address) external;
130 	function setFeeToSetter(address) external;
131 }
132 
133 interface IUniswapV2Pair {
134 	event Approval(address indexed owner, address indexed spender, uint value);
135 	event Transfer(address indexed from, address indexed to, uint value);
136 	function name() external pure returns (string memory);
137 	function symbol() external pure returns (string memory);
138 	function decimals() external pure returns (uint8);
139 	function totalSupply() external view returns (uint);
140 	function balanceOf(address owner) external view returns (uint);
141 	function allowance(address owner, address spender) external view returns (uint);
142 	function approve(address spender, uint value) external returns (bool);
143 	function transfer(address to, uint value) external returns (bool);
144 	function transferFrom(address from, address to, uint value) external returns (bool);
145 	function DOMAIN_SEPARATOR() external view returns (bytes32);
146 	function PERMIT_TYPEHASH() external pure returns (bytes32);
147 	function nonces(address owner) external view returns (uint);
148 	function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
149 	event Mint(address indexed sender, uint amount0, uint amount1);
150 	event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
151 	event Swap(address indexed sender, uint amount0In, uint amount1In, uint amount0Out, uint amount1Out, address indexed to);
152 	event Sync(uint112 reserve0, uint112 reserve1);
153 	function MINIMUM_LIQUIDITY() external pure returns (uint);
154 	function factory() external view returns (address);
155 	function token0() external view returns (address);
156 	function token1() external view returns (address);
157 	function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
158 	function price0CumulativeLast() external view returns (uint);
159 	function price1CumulativeLast() external view returns (uint);
160 	function kLast() external view returns (uint);
161 	function mint(address to) external returns (uint liquidity);
162 	function burn(address to) external returns (uint amount0, uint amount1);
163 	function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
164 	function skim(address to) external;
165 	function sync() external;
166 	function initialize(address, address) external;
167 }
168 
169 interface IUniswapV2Router01 {
170 	function factory() external pure returns (address);
171 	function WETH() external pure returns (address);
172 	function addLiquidity( address tokenA, address tokenB, uint amountADesired, uint amountBDesired, uint amountAMin, uint amountBMin, address to, uint deadline
173 	) external returns (uint amountA, uint amountB, uint liquidity);
174 	function addLiquidityETH( address token, uint amountTokenDesired, uint amountTokenMin, uint amountETHMin, address to, uint deadline
175 	) external payable returns (uint amountToken, uint amountETH, uint liquidity);
176 	function removeLiquidity( address tokenA, address tokenB, uint liquidity, uint amountAMin, uint amountBMin, address to, uint deadline
177 	) external returns (uint amountA, uint amountB);
178 	function removeLiquidityETH( address token, uint liquidity, uint amountTokenMin, uint amountETHMin, address to, uint deadline
179 	) external returns (uint amountToken, uint amountETH);
180 	function removeLiquidityWithPermit( address tokenA, address tokenB, uint liquidity, uint amountAMin, uint amountBMin, address to, uint deadline, bool approveMax, uint8 v, bytes32 r, bytes32 s
181 	) external returns (uint amountA, uint amountB);
182 	function removeLiquidityETHWithPermit( address token, uint liquidity, uint amountTokenMin, uint amountETHMin, address to, uint deadline, bool approveMax, uint8 v, bytes32 r, bytes32 s
183 	) external returns (uint amountToken, uint amountETH);
184 	function swapExactTokensForTokens( uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline
185 	) external returns (uint[] memory amounts);
186 	function swapTokensForExactTokens( uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline
187 	) external returns (uint[] memory amounts);
188 	function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline) external payable returns (uint[] memory amounts);
189 	function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline) external returns (uint[] memory amounts);
190 	function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external returns (uint[] memory amounts);
191 	function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline) external payable returns (uint[] memory amounts);
192 	function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
193 	function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
194 	function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
195 	function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
196 	function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
197 }
198 
199 interface IUniswapV2Router02 is IUniswapV2Router01 {
200 	function removeLiquidityETHSupportingFeeOnTransferTokens( address token, uint liquidity, uint amountTokenMin, uint amountETHMin, address to, uint deadline
201 	) external returns (uint amountETH);
202 	function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens( address token, uint liquidity, uint amountTokenMin, uint amountETHMin, address to, uint deadline, bool approveMax, uint8 v, bytes32 r, bytes32 s
203 	) external returns (uint amountETH);
204 	function swapExactTokensForTokensSupportingFeeOnTransferTokens( uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline
205 	) external;
206 	function swapExactETHForTokensSupportingFeeOnTransferTokens( uint amountOutMin, address[] calldata path, address to, uint deadline
207 	) external payable;
208 	function swapExactTokensForETHSupportingFeeOnTransferTokens( uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline
209 	) external;
210 }
211 
212 contract BoboCash is Context, IERC20, Ownable, ReentrancyGuard {
213 	using SafeMath for uint256;
214 	using Address for address;
215 
216 	mapping (address => uint256) private _rOwned;
217 	mapping (address => uint256) private _tOwned;
218 	mapping (address => mapping (address => uint256)) private _allowances;
219 
220 	mapping (address => bool) private _isExcludedFromFee;
221 	mapping (address => bool) private _isExcludedFromReward;
222 	address[] private _excludedFromReward;
223 
224 	address BURN_ADDRESS = 0x000000000000000000000000000000000000dEaD;
225 
226 
227 	uint256 private constant MAX = ~uint256(0);
228 	uint256 private _tTotal = 1000000 * 10**6 * 10**9;
229 	uint256 private _rTotal = (MAX - (MAX % _tTotal));
230 	uint256 private _tHODLrRewardsTotal;
231 
232 	string private _name = "Bobo Cash";
233 	string private _symbol = "BOBO";
234 	uint8 private _decimals = 9;
235 
236 	uint256 public _rewardFee = 4;
237 	uint256 private _previousRewardFee = _rewardFee;
238 
239 	uint256 public _burnFee = 1;
240 	uint256 private _previousBurnFee = _burnFee;
241 
242 	IUniswapV2Router02 public immutable uniswapV2Router;
243 	address public immutable uniswapV2Pair;
244 	uint256 public _maxTxAmount = 1000 * 10**6 * 10**9;
245 
246 	event TransferBurn(address indexed from, address indexed burnAddress, uint256 value);
247 //The Bobo army thanks Ryan from NSM for pointing up the flaws of most meme tokens. We further improved the code. Specifically, we fixed the reward exclusion. No rewards are lost in the reward exclusion process. May the Bobo god bless you with lots of crypto gainz, incredible health and pussy.
248 	constructor () {
249 		_rOwned[_msgSender()] = _rTotal;
250 		IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
251 		uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
252 		uniswapV2Router = _uniswapV2Router;
253 		_isExcludedFromFee[owner()] = true;
254 		_isExcludedFromFee[address(this)] = true;
255 		_isExcludedFromReward[address(this)] = true;
256 		_isExcludedFromFee[BURN_ADDRESS] = true;
257 		_isExcludedFromReward[BURN_ADDRESS] = true;
258 		_excludedFromReward.push(BURN_ADDRESS);
259 		_excludedFromReward.push(address(this));
260 		emit Transfer(address(0), _msgSender(), _tTotal);
261 	}
262 
263 	function name() public view returns (string memory) {return _name;}
264 	function symbol() public view returns (string memory) {return _symbol;}
265 	function decimals() public view returns (uint8) {return _decimals;}
266 	function totalSupply() public view override returns (uint256) {return _tTotal;}
267 
268 	function balanceOf(address account) public view override returns (uint256) {
269 		if (_isExcludedFromReward[account]) return _tOwned[account];
270 		return tokenFromReflection(_rOwned[account]);
271 	}
272 
273 	function withdraw() external onlyOwner nonReentrant{
274 		uint256 balance = IERC20(address(this)).balanceOf(address(this));
275 		IERC20(address(this)).transfer(msg.sender, balance);
276 		payable(msg.sender).transfer(address(this).balance);
277 	}
278 
279 	function transfer(address recipient, uint256 amount) public override returns (bool) {
280 		_transfer(_msgSender(), recipient, amount);
281 		return true;
282 	}
283 
284 	function allowance(address owner, address spender) public view override returns (uint256) {
285 		return _allowances[owner][spender];
286 	}
287 
288 	function approve(address spender, uint256 amount) public override returns (bool) {
289 		_approve(_msgSender(), spender, amount);
290 		return true;
291 	}
292 
293 	function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
294 		_transfer(sender, recipient, amount);
295 		_approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
296 		return true;
297 	}
298 
299 	function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
300 		_approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
301 		return true;
302 	}
303 
304 	function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
305 		_approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
306 		return true;
307 	}
308 
309 	function totalHODLrRewards() public view returns (uint256) {
310 		return _tHODLrRewardsTotal;
311 	}
312 
313 	function totalBurned() public view returns (uint256) {
314 		return balanceOf(BURN_ADDRESS);
315 	}
316 
317 	function deliver(uint256 tAmount) public {
318 		address sender = _msgSender();
319 		require(!_isExcludedFromReward[sender], "Excluded addresses cannot call this function");
320 		(uint256 rAmount,,,,,) = _getValues(tAmount);
321 		_rOwned[sender] = _rOwned[sender].sub(rAmount);
322 		_rTotal = _rTotal.sub(rAmount);
323 		_tHODLrRewardsTotal = _tHODLrRewardsTotal.add(tAmount);
324 	}
325 
326 	function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
327 		require(tAmount <= _tTotal, "Amount must be less than supply");
328 		if (!deductTransferFee) {
329 			(uint256 rAmount,,,,,) = _getValues(tAmount);
330 			return rAmount;
331 		} else {
332 			(,uint256 rTransferAmount,,,,) = _getValues(tAmount);
333 			return rTransferAmount;
334 		}
335 	}
336 
337 	function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
338 		require(rAmount <= _rTotal, "Amount must be less than total reflections");
339 		uint256 currentRate =  _getRate();
340 		return rAmount.div(currentRate);
341 	}
342 
343 	function isExcludedFromReward(address account) public view returns (bool) {
344 		return _isExcludedFromReward[account];
345 	}
346 
347 
348 	function excludeFromReward(address account) public onlyOwner {
349 		require(!_isExcludedFromReward[account], "Account is already excluded");
350 		if(_rOwned[account] > 0) {
351 			_tOwned[account] = tokenFromReflection(_rOwned[account]);
352 		}
353 		_isExcludedFromReward[account] = true;
354 		_excludedFromReward.push(account);
355 	}
356 
357 	function includeInReward(address account) external onlyOwner {
358 		require(_isExcludedFromReward[account], "Account is already excluded");
359 		for (uint256 i = 0; i < _excludedFromReward.length; i++) {
360 			if (_excludedFromReward[i] == account) {
361 				_excludedFromReward[i] = _excludedFromReward[_excludedFromReward.length - 1];
362 				_tOwned[account] = 0;
363 				_isExcludedFromReward[account] = false;
364 				_excludedFromReward.pop();
365 				break;
366 			}
367 		}
368 	}
369 
370 	function excludeFromFee(address account) public onlyOwner {
371 		_isExcludedFromFee[account] = true;
372 	}
373 
374 	function includeInFee(address account) public onlyOwner {
375 		_isExcludedFromFee[account] = false;
376 	}
377 
378 	function setRewardFeePercent(uint256 rewardFee) external onlyOwner {
379 		_rewardFee = rewardFee;
380 	}
381 
382 	function setBurnFeePercent(uint256 burnFee) external onlyOwner {
383 		_burnFee = burnFee;
384 	}
385 
386 	function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner {
387 		_maxTxAmount = _tTotal.mul(maxTxPercent).div(
388 			10**2
389 		);
390 	}
391 
392 	receive() external payable {}
393 
394 	function _HODLrFee(uint256 rHODLrFee, uint256 tHODLrFee) private {
395 		_rTotal = _rTotal.sub(rHODLrFee);
396 		_tHODLrRewardsTotal = _tHODLrRewardsTotal.add(tHODLrFee);
397 	}
398 
399 	function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
400 		(uint256 tTransferAmount, uint256 tHODLrFee, uint256 tBurn) = _getTValues(tAmount);
401 		(uint256 rAmount, uint256 rTransferAmount, uint256 rHODLrFee) = _getRValues(tAmount, tHODLrFee, tBurn, _getRate());
402 		return (rAmount, rTransferAmount, rHODLrFee, tTransferAmount, tHODLrFee, tBurn);
403 	}
404 
405 	function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
406 		uint256 tHODLrFee = calculateRewardFee(tAmount);
407 		uint256 tBurn = calculateBurnFee(tAmount);
408 		uint256 tTransferAmount = tAmount.sub(tHODLrFee).sub(tBurn);
409 		return (tTransferAmount, tHODLrFee, tBurn);
410 	}
411 
412 	function _getRValues(uint256 tAmount, uint256 tHODLrFee, uint256 tBurn, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
413 		uint256 rAmount = tAmount.mul(currentRate);
414 		uint256 rHODLrFee = tHODLrFee.mul(currentRate);
415 		uint256 rBurn = tBurn.mul(currentRate);
416 		uint256 rTransferAmount = rAmount.sub(rHODLrFee).sub(rBurn);
417 		return (rAmount, rTransferAmount, rHODLrFee);
418 	}
419 
420 	function _getRate() public view returns(uint256) {
421 		(uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
422 		return rSupply.div(tSupply);
423 	}
424 
425 	function _getCurrentSupply() public view returns(uint256, uint256) {
426 		uint256 rSupply = _rTotal;
427 		uint256 tSupply = _tTotal;
428 		for (uint256 i = 0; i < _excludedFromReward.length; i++) {
429 			if (_rOwned[_excludedFromReward[i]] > rSupply || _tOwned[_excludedFromReward[i]] > tSupply) return (_rTotal, _tTotal);
430 			rSupply = rSupply.sub(_rOwned[_excludedFromReward[i]]);
431 			tSupply = tSupply.sub(_tOwned[_excludedFromReward[i]]);
432 		}
433 		if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
434 		return (rSupply, tSupply);
435 	}
436 
437 
438 
439 	function calculateRewardFee(uint256 _amount) private view returns (uint256) {
440 		return _amount.mul(_rewardFee).div(
441 			10**2
442 		);
443 	}
444 
445 	function calculateBurnFee(uint256 _amount) private view returns (uint256) {
446 		return _amount.mul(_burnFee).div(
447 			10**2
448 		);
449 	}
450 
451 	function removeAllFee() private {
452 		if(_rewardFee == 0 && _burnFee == 0) return;
453 		_previousRewardFee = _rewardFee;
454 		_previousBurnFee = _burnFee;
455 		_rewardFee = 0;
456 		_burnFee = 0;
457 	}
458 
459 	function restoreAllFee() private {
460 		_rewardFee = _previousRewardFee;
461 		_burnFee = _previousBurnFee;
462 	}
463 
464 	function isExcludedFromFee(address account) public view returns(bool) {
465 		return _isExcludedFromFee[account];
466 	}
467 
468 	function _approve(address owner, address spender, uint256 amount) private {
469 		require(owner != address(0), "ERC20: approve from the zero address");
470 		require(spender != address(0), "ERC20: approve to the zero address");
471 		_allowances[owner][spender] = amount;
472 		emit Approval(owner, spender, amount);
473 	}
474 
475 	function _transfer(
476 		address from,
477 		address to,
478 		uint256 amount
479 	) private {
480 		require(from != address(0), "ERC20: transfer from the zero address");
481 		require(to != address(0), "ERC20: transfer to the zero address");
482 		require(amount > 0, "Transfer amount must be greater than zero");
483 		if(from != owner() && to != owner())
484 			require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
485 		bool takeFee = true;
486 		if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
487 			takeFee = false;
488 		}
489 		_tokenTransfer(from,to,amount,takeFee);
490 	}
491 	function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
492 		if(!takeFee)
493 			removeAllFee();
494 		if (_isExcludedFromReward[sender] && !_isExcludedFromReward[recipient]) {
495 			_transferFromExcluded(sender, recipient, amount);
496 		} else if (!_isExcludedFromReward[sender] && _isExcludedFromReward[recipient]) {
497 			_transferToExcluded(sender, recipient, amount);
498 		} else if (!_isExcludedFromReward[sender] && !_isExcludedFromReward[recipient]) {
499 			_transferStandard(sender, recipient, amount);
500 		} else if (_isExcludedFromReward[sender] && _isExcludedFromReward[recipient]) {
501 			_transferBothExcluded(sender, recipient, amount);
502 		} else {
503 			_transferStandard(sender, recipient, amount);
504 		}
505 		if(!takeFee)
506 			restoreAllFee();
507 	}
508 
509 	function _transferBurn(uint256 tBurn) private {
510 		uint256 currentRate = _getRate();
511 		uint256 rBurn = tBurn.mul(currentRate);
512 		_rOwned[BURN_ADDRESS] = _rOwned[BURN_ADDRESS].add(rBurn);
513 		if(_isExcludedFromReward[BURN_ADDRESS])
514 			_tOwned[BURN_ADDRESS] = _tOwned[BURN_ADDRESS].add(tBurn);
515 	}
516 
517 	function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
518 		(
519 			uint256 rAmount,
520 			uint256 rTransferAmount,
521 			uint256 rHODLrFee,
522 			uint256 tTransferAmount,
523 			uint256 tHODLrFee,
524 			uint256 tBurn
525 		) = _getValues(tAmount);
526 		_tOwned[sender] = _tOwned[sender].sub(tAmount);
527 		_rOwned[sender] = _rOwned[sender].sub(rAmount);
528 		_rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
529 		_transferBurn(tBurn);
530 		_HODLrFee(rHODLrFee, tHODLrFee);
531 		emit TransferBurn(sender, BURN_ADDRESS, tBurn);
532 		emit Transfer(sender, recipient, tTransferAmount);
533 	}
534 
535 	function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
536 		(uint256 rAmount, uint256 rTransferAmount, uint256 rHODLrFee, uint256 tTransferAmount, uint256 tHODLrFee, uint256 tBurn) = _getValues(tAmount);
537 		_rOwned[sender] = _rOwned[sender].sub(rAmount);
538 		_tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
539 		_rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
540 		_transferBurn(tBurn);
541 		_HODLrFee(rHODLrFee, tHODLrFee);
542 		emit TransferBurn(sender, BURN_ADDRESS, tBurn);
543 		emit Transfer(sender, recipient, tTransferAmount);
544 	}
545 
546 	function _transferStandard(address sender, address recipient, uint256 tAmount) private {
547 		(uint256 rAmount, uint256 rTransferAmount, uint256 rHODLrFee, uint256 tTransferAmount, uint256 tHODLrFee, uint256 tBurn) = _getValues(tAmount);
548 		_rOwned[sender] = _rOwned[sender].sub(rAmount);
549 		_rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
550 		_transferBurn(tBurn);
551 		_HODLrFee(rHODLrFee, tHODLrFee);
552 		emit TransferBurn(sender, BURN_ADDRESS, tBurn);
553 		emit Transfer(sender, recipient, tTransferAmount);
554 	}
555 
556 	function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
557 		(uint256 rAmount, uint256 rTransferAmount, uint256 rHODLrFee, uint256 tTransferAmount, uint256 tHODLrFee, uint256 tBurn) = _getValues(tAmount);
558 		_tOwned[sender] = _tOwned[sender].sub(tAmount);
559 		_rOwned[sender] = _rOwned[sender].sub(rAmount);
560 		_tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
561 		_rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
562 		_transferBurn(tBurn);
563 		_HODLrFee(rHODLrFee, tHODLrFee);
564 		emit TransferBurn(sender, BURN_ADDRESS, tBurn);
565 		emit Transfer(sender, recipient, tTransferAmount);
566 	}
567 
568 }