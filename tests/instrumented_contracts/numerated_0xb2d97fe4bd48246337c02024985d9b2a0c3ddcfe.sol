1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.9;
4 
5 interface IUniswapV2Router01 {
6     function factory() external pure returns (address);
7     function WETH() external pure returns (address);
8 
9     function addLiquidity(
10         address tokenA,
11         address tokenB,
12         uint amountADesired,
13         uint amountBDesired,
14         uint amountAMin,
15         uint amountBMin,
16         address to,
17         uint deadline
18     ) external returns (uint amountA, uint amountB, uint liquidity);
19     function addLiquidityETH(
20         address token,
21         uint amountTokenDesired,
22         uint amountTokenMin,
23         uint amountETHMin,
24         address to,
25         uint deadline
26     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
27     function removeLiquidity(
28         address tokenA,
29         address tokenB,
30         uint liquidity,
31         uint amountAMin,
32         uint amountBMin,
33         address to,
34         uint deadline
35     ) external returns (uint amountA, uint amountB);
36     function removeLiquidityETH(
37         address token,
38         uint liquidity,
39         uint amountTokenMin,
40         uint amountETHMin,
41         address to,
42         uint deadline
43     ) external returns (uint amountToken, uint amountETH);
44     function removeLiquidityWithPermit(
45         address tokenA,
46         address tokenB,
47         uint liquidity,
48         uint amountAMin,
49         uint amountBMin,
50         address to,
51         uint deadline,
52         bool approveMax, uint8 v, bytes32 r, bytes32 s
53     ) external returns (uint amountA, uint amountB);
54     function removeLiquidityETHWithPermit(
55         address token,
56         uint liquidity,
57         uint amountTokenMin,
58         uint amountETHMin,
59         address to,
60         uint deadline,
61         bool approveMax, uint8 v, bytes32 r, bytes32 s
62     ) external returns (uint amountToken, uint amountETH);
63     function swapExactTokensForTokens(
64         uint amountIn,
65         uint amountOutMin,
66         address[] calldata path,
67         address to,
68         uint deadline
69     ) external returns (uint[] memory amounts);
70     function swapTokensForExactTokens(
71         uint amountOut,
72         uint amountInMax,
73         address[] calldata path,
74         address to,
75         uint deadline
76     ) external returns (uint[] memory amounts);
77     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
78         external
79         payable
80         returns (uint[] memory amounts);
81     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
82         external
83         returns (uint[] memory amounts);
84     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
85         external
86         returns (uint[] memory amounts);
87     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
88         external
89         payable
90         returns (uint[] memory amounts);
91 
92     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
93     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
94     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
95     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
96     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
97 }
98 
99 interface IUniswapV2Router02 is IUniswapV2Router01 {
100     function removeLiquidityETHSupportingFeeOnTransferTokens(
101         address token,
102         uint liquidity,
103         uint amountTokenMin,
104         uint amountETHMin,
105         address to,
106         uint deadline
107     ) external returns (uint amountETH);
108     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
109         address token,
110         uint liquidity,
111         uint amountTokenMin,
112         uint amountETHMin,
113         address to,
114         uint deadline,
115         bool approveMax, uint8 v, bytes32 r, bytes32 s
116     ) external returns (uint amountETH);
117 
118     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
119         uint amountIn,
120         uint amountOutMin,
121         address[] calldata path,
122         address to,
123         uint deadline
124     ) external;
125     function swapExactETHForTokensSupportingFeeOnTransferTokens(
126         uint amountOutMin,
127         address[] calldata path,
128         address to,
129         uint deadline
130     ) external payable;
131     function swapExactTokensForETHSupportingFeeOnTransferTokens(
132         uint amountIn,
133         uint amountOutMin,
134         address[] calldata path,
135         address to,
136         uint deadline
137     ) external;
138 }
139 
140 interface IUniswapV2Factory {
141     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
142 
143     function feeTo() external view returns (address);
144     function feeToSetter() external view returns (address);
145 
146     function getPair(address tokenA, address tokenB) external view returns (address pair);
147     function allPairs(uint) external view returns (address pair);
148     function allPairsLength() external view returns (uint);
149 
150     function createPair(address tokenA, address tokenB) external returns (address pair);
151 
152     function setFeeTo(address) external;
153     function setFeeToSetter(address) external;
154 }
155 
156 interface IUniswapV2Pair {
157     event Approval(address indexed owner, address indexed spender, uint value);
158     event Transfer(address indexed from, address indexed to, uint value);
159 
160     function name() external pure returns (string memory);
161     function symbol() external pure returns (string memory);
162     function decimals() external pure returns (uint8);
163     function totalSupply() external view returns (uint);
164     function balanceOf(address owner) external view returns (uint);
165     function allowance(address owner, address spender) external view returns (uint);
166 
167     function approve(address spender, uint value) external returns (bool);
168     function transfer(address to, uint value) external returns (bool);
169     function transferFrom(address from, address to, uint value) external returns (bool);
170 
171     function DOMAIN_SEPARATOR() external view returns (bytes32);
172     function PERMIT_TYPEHASH() external pure returns (bytes32);
173     function nonces(address owner) external view returns (uint);
174 
175     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
176 
177     event Mint(address indexed sender, uint amount0, uint amount1);
178     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
179     event Swap(
180         address indexed sender,
181         uint amount0In,
182         uint amount1In,
183         uint amount0Out,
184         uint amount1Out,
185         address indexed to
186     );
187     event Sync(uint112 reserve0, uint112 reserve1);
188 
189     function MINIMUM_LIQUIDITY() external pure returns (uint);
190     function factory() external view returns (address);
191     function token0() external view returns (address);
192     function token1() external view returns (address);
193     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
194     function price0CumulativeLast() external view returns (uint);
195     function price1CumulativeLast() external view returns (uint);
196     function kLast() external view returns (uint);
197 
198     function mint(address to) external returns (uint liquidity);
199     function burn(address to) external returns (uint amount0, uint amount1);
200     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
201     function skim(address to) external;
202     function sync() external;
203 
204     function initialize(address, address) external;
205 }
206 
207 abstract contract Context {
208     function _msgSender() internal view virtual returns (address) {
209         return msg.sender;
210     }
211 
212     function _msgData() internal view virtual returns (bytes calldata) {
213         return msg.data;
214     }
215 }
216 
217 abstract contract Ownable is Context {
218     address private _owner;
219 
220     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
221 
222     /**
223      * @dev Initializes the contract setting the deployer as the initial owner.
224      */
225     constructor() {
226         _setOwner(_msgSender());
227     }
228 
229     /**
230      * @dev Returns the address of the current owner.
231      */
232     function owner() public view virtual returns (address) {
233         return _owner;
234     }
235 
236     /**
237      * @dev Throws if called by any account other than the owner.
238      */
239     modifier onlyOwner() {
240         require(owner() == _msgSender(), "Ownable: caller is not the owner");
241         _;
242     }
243 
244     /**
245      * @dev Leaves the contract without owner. It will not be possible to call
246      * `onlyOwner` functions anymore. Can only be called by the current owner.
247      *
248      * NOTE: Renouncing ownership will leave the contract without an owner,
249      * thereby removing any functionality that is only available to the owner.
250      */
251     function renounceOwnership() public virtual onlyOwner {
252         _setOwner(address(0));
253     }
254 
255     /**
256      * @dev Transfers ownership of the contract to a new account (`newOwner`).
257      * Can only be called by the current owner.
258      */
259     function transferOwnership(address newOwner) public virtual onlyOwner {
260         require(newOwner != address(0), "Ownable: new owner is the zero address");
261         _setOwner(newOwner);
262     }
263 
264     function _setOwner(address newOwner) private {
265         address oldOwner = _owner;
266         _owner = newOwner;
267         emit OwnershipTransferred(oldOwner, newOwner);
268     }
269 }
270 
271 /**
272  * @dev Interface of the ERC20 standard as defined in the EIP.
273  */
274 interface IERC20 {
275     /**
276      * @dev Returns the amount of tokens in existence.
277      */
278     function totalSupply() external view returns (uint256);
279 
280     /**
281      * @dev Returns the amount of tokens owned by `account`.
282      */
283     function balanceOf(address account) external view returns (uint256);
284 
285     /**
286      * @dev Moves `amount` tokens from the caller's account to `recipient`.
287      *
288      * Returns a boolean value indicating whether the operation succeeded.
289      *
290      * Emits a {Transfer} event.
291      */
292     function transfer(address recipient, uint256 amount) external returns (bool);
293 
294     /**
295      * @dev Returns the remaining number of tokens that `spender` will be
296      * allowed to spend on behalf of `owner` through {transferFrom}. This is
297      * zero by default.
298      *
299      * This value changes when {approve} or {transferFrom} are called.
300      */
301     function allowance(address owner, address spender) external view returns (uint256);
302 
303     /**
304      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
305      *
306      * Returns a boolean value indicating whether the operation succeeded.
307      *
308      * IMPORTANT: Beware that changing an allowance with this method brings the risk
309      * that someone may use both the old and the new allowance by unfortunate
310      * transaction ordering. One possible solution to mitigate this race
311      * condition is to first reduce the spender's allowance to 0 and set the
312      * desired value afterwards:
313      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
314      *
315      * Emits an {Approval} event.
316      */
317     function approve(address spender, uint256 amount) external returns (bool);
318 
319     /**
320      * @dev Moves `amount` tokens from `sender` to `recipient` using the
321      * allowance mechanism. `amount` is then deducted from the caller's
322      * allowance.
323      *
324      * Returns a boolean value indicating whether the operation succeeded.
325      *
326      * Emits a {Transfer} event.
327      */
328     function transferFrom(
329         address sender,
330         address recipient,
331         uint256 amount
332     ) external returns (bool);
333 
334     /**
335      * @dev Emitted when `value` tokens are moved from one account (`from`) to
336      * another (`to`).
337      *
338      * Note that `value` may be zero.
339      */
340     event Transfer(address indexed from, address indexed to, uint256 value);
341 
342     /**
343      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
344      * a call to {approve}. `value` is the new allowance.
345      */
346     event Approval(address indexed owner, address indexed spender, uint256 value);
347 }
348 
349 contract LiumToken is Ownable, IERC20 {
350 
351     string private _name = "LIUM Protocol";
352     string private _symbol = "LIUM";
353 
354     uint256 private _totalSupply;
355     mapping(address => uint256) private _balances;
356     mapping(address => mapping(address => uint256)) private _allowances;
357 
358     IUniswapV2Router02 public uniswapV2Router;
359     address public uniswapV2Pair;
360 
361     constructor() {
362         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
363 
364         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
365             .createPair(address(this), _uniswapV2Router.WETH());
366 
367         uniswapV2Router = _uniswapV2Router;
368         uniswapV2Pair = _uniswapV2Pair;
369 
370         _mint(owner(), 100000000 * (10**18));
371     }
372 
373     receive() external payable {
374 
375     }
376 
377     function name() public view returns (string memory) {
378         return _name;
379     }
380 
381     function symbol() public view returns (string memory) {
382         return _symbol;
383     }
384 
385     function decimals() public pure returns (uint8) {
386         return 18;
387     }
388 
389     function totalSupply() public view virtual override returns (uint256) {
390         return _totalSupply;
391     }
392 
393     function balanceOf(address account) public view virtual override returns (uint256) {
394         return _balances[account];
395     }    
396     
397     function allowance(address owner, address spender) public view virtual override returns (uint256) {
398         return _allowances[owner][spender];
399     }    
400 
401     function approve(address spender, uint256 amount) public virtual override returns (bool) {
402         _approve(_msgSender(), spender, amount);
403         return true;
404     }
405 
406     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
407         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
408         return true;
409     }
410 
411     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
412         uint256 currentAllowance = _allowances[_msgSender()][spender];
413         require(currentAllowance >= subtractedValue, "LIUM: decreased allowance below zero");
414         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
415         return true;
416     }
417 
418     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
419         _transfer(_msgSender(), recipient, amount);
420         return true;
421     }
422 
423     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
424         _transfer(sender, recipient, amount);
425         uint256 currentAllowance = _allowances[sender][_msgSender()];
426         require(currentAllowance >= amount, "LIUM: transfer amount exceeds allowance");
427         _approve(sender, _msgSender(), currentAllowance - amount);
428         return true;
429     }    
430 
431     function _transfer(address sender, address recipient, uint256 amount) internal {
432         _executeTransfer(sender, recipient, amount);
433     }
434 
435     function _executeTransfer(address sender, address recipient, uint256 amount) private {
436         require(sender != address(0), "LIUM: transfer from the zero address");
437         require(recipient != address(0), "LIUM: transfer to the zero address");
438         uint256 senderBalance = _balances[sender];
439         require(senderBalance >= amount, "LIUM: transfer amount exceeds balance");
440         _balances[sender] = senderBalance - amount;
441         _balances[recipient] += amount;
442         emit Transfer(sender, recipient, amount);       
443     }
444 
445     function _approve(address owner, address spender, uint256 amount) private {
446         require(owner != address(0), "LIUM: approve from the zero address");
447         require(spender != address(0), "LIUM: approve to the zero address");
448         _allowances[owner][spender] = amount;
449         emit Approval(owner, spender, amount);
450     }
451 
452     function _mint(address account, uint256 amount) private {
453         require(account != address(0), "LIUM: mint to the zero address");
454         _totalSupply += amount;
455         _balances[account] += amount;
456         emit Transfer(address(0), account, amount);
457     }
458 }