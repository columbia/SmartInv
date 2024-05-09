1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.17;
3 
4 interface IERC20 {
5     function totalSupply() external view returns (uint);
6 
7     function balanceOf(address account) external view returns (uint);
8 
9     function transfer(address recipient, uint amount) external returns (bool);
10 
11     function allowance(address owner, address spender) external view returns (uint);
12 
13     function approve(address spender, uint amount) external returns (bool);
14 
15     function transferFrom(address sender, address recipient, uint amount) external returns (bool);
16 
17     event Transfer(address indexed from, address indexed to, uint value);
18     event Approval(address indexed owner, address indexed spender, uint value);
19 }
20 
21 interface IUniswapV2Factory {
22     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
23 
24     function feeTo() external view returns (address);
25     function feeToSetter() external view returns (address);
26 
27     function getPair(address tokenA, address tokenB) external view returns (address pair);
28     function allPairs(uint) external view returns (address pair);
29     function allPairsLength() external view returns (uint);
30 
31     function createPair(address tokenA, address tokenB) external returns (address pair);
32 
33     function setFeeTo(address) external;
34     function setFeeToSetter(address) external;
35 }
36 
37 interface IUniswapV2Pair {
38     event Approval(address indexed owner, address indexed spender, uint value);
39     event Transfer(address indexed from, address indexed to, uint value);
40 
41     function name() external pure returns (string memory);
42     function symbol() external pure returns (string memory);
43     function decimals() external pure returns (uint8);
44     function totalSupply() external view returns (uint);
45     function balanceOf(address owner) external view returns (uint);
46     function allowance(address owner, address spender) external view returns (uint);
47 
48     function approve(address spender, uint value) external returns (bool);
49     function transfer(address to, uint value) external returns (bool);
50     function transferFrom(address from, address to, uint value) external returns (bool);
51 
52     function DOMAIN_SEPARATOR() external view returns (bytes32);
53     function PERMIT_TYPEHASH() external pure returns (bytes32);
54     function nonces(address owner) external view returns (uint);
55 
56     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
57     
58     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
59     event Swap(
60         address indexed sender,
61         uint amount0In,
62         uint amount1In,
63         uint amount0Out,
64         uint amount1Out,
65         address indexed to
66     );
67     event Sync(uint112 reserve0, uint112 reserve1);
68 
69     function MINIMUM_LIQUIDITY() external pure returns (uint);
70     function factory() external view returns (address);
71     function token0() external view returns (address);
72     function token1() external view returns (address);
73     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
74     function price0CumulativeLast() external view returns (uint);
75     function price1CumulativeLast() external view returns (uint);
76     function kLast() external view returns (uint);
77 
78     function burn(address to) external returns (uint amount0, uint amount1);
79     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
80     function skim(address to) external;
81     function sync() external;
82 
83     function initialize(address, address) external;
84 }
85 
86 interface IUniswapV2Router01 {
87     function factory() external pure returns (address);
88     function WETH() external pure returns (address);
89 
90     function addLiquidity(
91         address tokenA,
92         address tokenB,
93         uint amountADesired,
94         uint amountBDesired,
95         uint amountAMin,
96         uint amountBMin,
97         address to,
98         uint deadline
99     ) external returns (uint amountA, uint amountB, uint liquidity);
100     function addLiquidityETH(
101         address token,
102         uint amountTokenDesired,
103         uint amountTokenMin,
104         uint amountETHMin,
105         address to,
106         uint deadline
107     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
108     function removeLiquidity(
109         address tokenA,
110         address tokenB,
111         uint liquidity,
112         uint amountAMin,
113         uint amountBMin,
114         address to,
115         uint deadline
116     ) external returns (uint amountA, uint amountB);
117     function removeLiquidityETH(
118         address token,
119         uint liquidity,
120         uint amountTokenMin,
121         uint amountETHMin,
122         address to,
123         uint deadline
124     ) external returns (uint amountToken, uint amountETH);
125     function removeLiquidityWithPermit(
126         address tokenA,
127         address tokenB,
128         uint liquidity,
129         uint amountAMin,
130         uint amountBMin,
131         address to,
132         uint deadline,
133         bool approveMax, uint8 v, bytes32 r, bytes32 s
134     ) external returns (uint amountA, uint amountB);
135     function removeLiquidityETHWithPermit(
136         address token,
137         uint liquidity,
138         uint amountTokenMin,
139         uint amountETHMin,
140         address to,
141         uint deadline,
142         bool approveMax, uint8 v, bytes32 r, bytes32 s
143     ) external returns (uint amountToken, uint amountETH);
144     function swapExactTokensForTokens(
145         uint amountIn,
146         uint amountOutMin,
147         address[] calldata path,
148         address to,
149         uint deadline
150     ) external returns (uint[] memory amounts);
151     function swapTokensForExactTokens(
152         uint amountOut,
153         uint amountInMax,
154         address[] calldata path,
155         address to,
156         uint deadline
157     ) external returns (uint[] memory amounts);
158     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
159         external
160         payable
161         returns (uint[] memory amounts);
162     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
163         external
164         returns (uint[] memory amounts);
165     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
166         external
167         returns (uint[] memory amounts);
168     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
169         external
170         payable
171         returns (uint[] memory amounts);
172 
173     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
174     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
175     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
176     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
177     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
178 }
179 
180 interface IUniswapV2Router02 is IUniswapV2Router01 {
181     function removeLiquidityETHSupportingFeeOnTransferTokens(
182         address token,
183         uint liquidity,
184         uint amountTokenMin,
185         uint amountETHMin,
186         address to,
187         uint deadline
188     ) external returns (uint amountETH);
189     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
190         address token,
191         uint liquidity,
192         uint amountTokenMin,
193         uint amountETHMin,
194         address to,
195         uint deadline,
196         bool approveMax, uint8 v, bytes32 r, bytes32 s
197     ) external returns (uint amountETH);
198 
199     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
200         uint amountIn,
201         uint amountOutMin,
202         address[] calldata path,
203         address to,
204         uint deadline
205     ) external;
206     function swapExactETHForTokensSupportingFeeOnTransferTokens(
207         uint amountOutMin,
208         address[] calldata path,
209         address to,
210         uint deadline
211     ) external payable;
212     function swapExactTokensForETHSupportingFeeOnTransferTokens(
213         uint amountIn,
214         uint amountOutMin,
215         address[] calldata path,
216         address to,
217         uint deadline
218     ) external;
219 }
220 
221 interface IWrap {
222     function withdraw() external;
223 }
224 
225 library Address {
226     function isContract(address account) internal view returns (bool) {
227         bytes32 codehash;
228         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
229         // solhint-disable-next-line no-inline-assembly
230         assembly {codehash := extcodehash(account)}
231         return (codehash != 0x0 && codehash != accountHash);
232     }
233 }
234 
235 library SafeMath {
236     function add(uint a, uint b) internal pure returns (uint) {
237         uint c = a + b;
238         require(c >= a, "SafeMath: addition overflow");
239 
240         return c;
241     }
242 
243     function sub(uint a, uint b) internal pure returns (uint) {
244         return sub(a, b, "SafeMath: subtraction overflow");
245     }
246 
247     function sub(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
248         require(b <= a, errorMessage);
249         uint c = a - b;
250 
251         return c;
252     }
253 
254     function mul(uint a, uint b) internal pure returns (uint) {
255         if (a == 0) {
256             return 0;
257         }
258 
259         uint c = a * b;
260         require(c / a == b, "SafeMath: multiplication overflow");
261 
262         return c;
263     }
264 
265     function div(uint a, uint b) internal pure returns (uint) {
266         return div(a, b, "SafeMath: division by zero");
267     }
268 
269     function div(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
270         // Solidity only automatically asserts when dividing by 0
271         require(b > 0, errorMessage);
272         uint c = a / b;
273 
274         return c;
275     }
276 }
277 
278 library SafeERC20 {
279 
280     using SafeMath for uint;
281 
282     using Address for address;
283 
284     function safeTransfer(IERC20 token, address to, uint value) internal {
285         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
286     }
287 
288     function safeTransferFrom(IERC20 token, address from, address to, uint value) internal {
289         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
290     }
291 
292     function safeApprove(IERC20 token, address spender, uint value) internal {
293         require((value == 0) || (token.allowance(address(this), spender) == 0),
294             "SafeERC20: approve from non-zero to non-zero allowance"
295         );
296         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
297     }
298 
299     function callOptionalReturn(IERC20 token, bytes memory data) private {
300         require(address(token).isContract(), "SafeERC20: call to non-contract");
301 
302         // solhint-disable-next-line avoid-low-level-calls
303         (bool success, bytes memory returndata) = address(token).call(data);
304         require(success, "SafeERC20: low-level call failed");
305 
306         if (returndata.length > 0) {// Return data is optional
307             // solhint-disable-next-line max-line-length
308             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
309         }
310     }
311 }
312 
313 abstract contract Context {
314     constructor () {}
315 
316     function _msgSender() internal view returns (address payable) {
317         return payable(msg.sender);
318     }
319 }
320 
321 contract Ownable is Context {
322 
323     address public _owner;
324 
325     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
326 
327     constructor () {
328         address msgSender = _msgSender();
329         _owner = msgSender;
330         emit OwnershipTransferred(address(0), msgSender);
331     }
332 
333     /**
334      * @dev Throws if called by any account other than the owner.
335      */
336     modifier onlyOwner() {
337         require(_owner == _msgSender(), "Ownable: caller is not the owner");
338         _;
339     }
340 
341     function transferOwnership(address newOwner) public onlyOwner {
342         emit OwnershipTransferred(_owner, newOwner);
343         _owner = newOwner;
344     }
345 }
346 
347 contract ERC20 is Context, IERC20 {
348     using SafeMath for uint;
349 
350     mapping (address => uint) public _balances;
351 
352     mapping (address => mapping (address => uint)) private _allowances;
353 
354     uint private _totalSupply;
355 
356     string private _name;
357     string private _symbol;
358     uint8 private _decimals;
359 
360     constructor (string memory __name, string memory __symbol, uint8 __decimals, uint __totalSupply) {
361         _name = __name;
362         _symbol = __symbol;
363         _decimals = __decimals;
364         _totalSupply = __totalSupply;
365     }
366 
367     function name() public view returns (string memory) {
368         return _name;
369     }
370 
371     function symbol() public view returns (string memory) {
372         return _symbol;
373     }
374 
375     function decimals() public view returns (uint8) {
376         return _decimals;
377     }
378 
379     function totalSupply() public view returns (uint) {
380         return _totalSupply;
381     }
382 
383     function balanceOf(address account) public view returns (uint) {
384         return _balances[account];
385     }
386 
387     function transfer(address recipient, uint amount) public returns (bool) {
388         _transfer(_msgSender(), recipient, amount);
389         return true;
390     }
391 
392     function allowance(address owner, address spender) public view returns (uint) {
393         return _allowances[owner][spender];
394     }
395 
396     function approve(address spender, uint amount) public returns (bool) {
397         _approve(_msgSender(), spender, amount);
398         return true;
399     }
400 
401     function transferFrom(address sender, address recipient, uint amount) public returns (bool) {
402         _transfer(sender, recipient, amount);
403         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
404         return true;
405     }
406 
407     function increaseAllowance(address spender, uint addedValue) public returns (bool) {
408         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
409         return true;
410     }
411 
412     function decreaseAllowance(address spender, uint subtractedValue) public returns (bool) {
413         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
414         return true;
415     }
416 
417     function _transfer(address sender, address recipient, uint amount) internal virtual {
418         require(sender != address(0), "ERC20: transfer from the zero address");
419         require(recipient != address(0), "ERC20: transfer to the zero address");
420 
421         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
422         _balances[recipient] = _balances[recipient].add(amount);
423         emit Transfer(sender, recipient, amount);
424     }
425 
426     function _burn(address account, uint amount) internal {
427         require(account != address(0), "ERC20: burn from the zero address");
428 
429         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
430         _totalSupply = _totalSupply.sub(amount);
431         emit Transfer(account, address(0), amount);
432     }
433     function _approve(address owner, address spender, uint amount) internal {
434         require(owner != address(0), "ERC20: approve from the zero address");
435         require(spender != address(0), "ERC20: approve to the zero address");
436 
437         _allowances[owner][spender] = amount;
438         emit Approval(owner, spender, amount);
439     }
440 }
441 
442 contract FISTDAO is ERC20, Ownable {
443     using SafeERC20 for IERC20;
444     using Address for address;
445     using SafeMath for uint;
446 
447     uint256 public _totalTaxIfBuying = 3;
448     uint256 public _totalTaxIfSelling = 3;
449     uint256 public _buyFeeAmount;
450     uint256 public _sellFeeAmount;
451 
452     bool public swap = true;
453     bool private swaping = false;
454 
455     address public uniswapPair;
456     address public receiveBuyFeeWallet = 0x982b4C94955F6B566C0a46f8DD65B00bF61897c5; 
457     address public receiveSellFeeWallet = 0x54Db7B1e507ae8B7AAF9f25be8ba474Fe4Df927b; 
458     IWrap public wrap = IWrap(0x9eF0A42E1E217C61480735E177E46F0Eaa6eB30A);
459     IUniswapV2Router02 public uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
460 
461     mapping (address => bool) public isMarketPair; 
462 
463     constructor () ERC20("FIST Coin DAO", "FISTDAO", 8, 5000 * 10 ** 8){
464         address msgSender = _msgSender();
465         _balances[msg.sender] = totalSupply();
466         emit Transfer(address(0), msgSender, totalSupply());
467         uniswapPair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
468         isMarketPair[uniswapPair] = true;
469     }
470 
471     function _transfer(address sender, address recipient, uint amount) internal override {
472         require(sender != address(0), "ERC20: transfer sender the zero address");
473         require(recipient != address(0), "ERC20: transfer recipient the zero address");
474         if (amount == 0) {
475             super._transfer(sender, recipient, 0);
476             return;
477         }
478         bool freeOfCharge = sender == address(this) || sender == _owner || sender == receiveBuyFeeWallet || sender == receiveSellFeeWallet || recipient == address(this) || recipient == _owner || recipient == receiveBuyFeeWallet || recipient == receiveSellFeeWallet;
479         if (!freeOfCharge) {
480             bool isSwap = sender == uniswapPair || recipient == uniswapPair;
481             require(!isSwap || swap, "swap not start");
482             uint256 feeAmount = 0;
483             if(isMarketPair[sender]) {
484                 feeAmount = amount.mul(_totalTaxIfBuying).div(100);
485                 super._transfer(sender, address(this), feeAmount);
486                 _buyFeeAmount = _buyFeeAmount + feeAmount;
487             } else if(isMarketPair[recipient]) {
488                 feeAmount = amount.mul(_totalTaxIfSelling).div(100);
489                 super._transfer(sender, address(this), feeAmount);
490                 _sellFeeAmount = _sellFeeAmount + feeAmount;
491             }
492             amount = amount.sub(feeAmount);
493             uint currentBalance = balanceOf(address(this));
494             if (currentBalance > 0 && !swaping && sender != uniswapPair) {
495                 swaping = true; 
496                 if(_buyFeeAmount > 0) {
497                     _swapTokensForEther(_buyFeeAmount, receiveBuyFeeWallet);
498                 }
499                 if(_sellFeeAmount > 0) {
500                     _swapTokensForEther(_sellFeeAmount, receiveSellFeeWallet);
501                 }
502                 _buyFeeAmount = 0;
503                 _sellFeeAmount = 0;
504                 swaping = false;
505             }
506         }
507         super._transfer(sender, recipient, amount);
508     }
509 
510     function _swapTokensForEther(uint256 tokenAmount, address to) private {
511         address[] memory path = new address[](2);
512         path[0] = address(this);
513         path[1] = uniswapV2Router.WETH();
514         _approve(address(this), address(uniswapV2Router), tokenAmount);
515         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
516             tokenAmount,
517             0,
518             path,
519             to,
520             block.timestamp
521         );
522         if (to == address(wrap)) {
523             wrap.withdraw();
524         }
525     }
526 }