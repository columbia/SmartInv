1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.19;
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address) {
7         return msg.sender;
8     }
9 
10     function _msgData() internal view virtual returns (bytes calldata) {
11         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
12         return msg.data;
13     }
14 }
15 
16 interface IERC20 {
17     /**
18      * @dev Returns the amount of tokens in existence.
19      */
20     function totalSupply() external view returns (uint256);
21 
22     /**
23      * @dev Returns the amount of tokens owned by `account`.
24      */
25     function balanceOf(address account) external view returns (uint256);
26 
27     /**
28      * @dev Moves `amount` tokens from the caller's account to `recipient`.
29      *
30      * Returns a boolean value indicating whether the operation succeeded.
31      *
32      * Emits a {Transfer} event. C U ON THE MOON
33      */
34     function transfer(address recipient, uint256 amount)
35         external
36         returns (bool);
37 
38     /**
39      * @dev Returns the remaining number of tokens that `spender` will be
40      * allowed to spend on behalf of `owner` through {transferFrom}. This is
41      * zero by default.
42      *
43      * This value changes when {approve} or {transferFrom} are called.
44      */
45     function allowance(address owner, address spender)
46         external
47         view
48         returns (uint256);
49 
50     /**
51      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
52      *
53      * Returns a boolean value indicating whether the operation succeeded.
54      *
55      * IMPORTANT: Beware that changing an allowance with this method brings the risk
56      * that someone may use both the old and the new allowance by unfortunate
57      * transaction ordering. One possible solution to mitigate this race
58      * condition is to first reduce the spender's allowance to 0 and set the
59      * desired value afterwards:
60      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
61      *
62      * Emits an {Approval} event.
63      */
64     function approve(address spender, uint256 amount) external returns (bool);
65 
66     /**
67      * @dev Moves `amount` tokens from `sender` to `recipient` using the
68      * allowance mechanism. `amount` is then deducted from the caller's
69      * allowance.
70      *
71      * Returns a boolean value indicating whether the operation succeeded.
72      *
73      * Emits a {Transfer} event.
74      */
75     function transferFrom(
76         address sender,
77         address recipient,
78         uint256 amount
79     ) external returns (bool);
80 
81     /**
82      * @dev Emitted when `value` tokens are moved from one account (`from`) to
83      * another (`to`).
84      *
85      * Note that `value` may be zero.
86      */
87     event Transfer(address indexed from, address indexed to, uint256 value);
88 
89     /**
90      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
91      * a call to {approve}. `value` is the new allowance.
92      */
93     event Approval(
94         address indexed owner,
95         address indexed spender,
96         uint256 value
97     );
98 }
99 
100 interface IERC20Metadata is IERC20 {
101     /**
102      * @dev Returns the name of the token.
103      */
104     function name() external view returns (string memory);
105 
106     /**
107      * @dev Returns the symbol of the token.
108      */
109     function symbol() external view returns (string memory);
110 
111     /**
112      * @dev Returns the decimals places of the token.
113      */
114     function decimals() external view returns (uint8);
115 }
116 
117 contract ERC20 is Context, IERC20, IERC20Metadata {
118     mapping(address => uint256) internal _balances;
119 
120     mapping(address => mapping(address => uint256)) private _allowances;
121 
122     uint256 internal _totalSupply;
123 
124     string private _name;
125     string private _symbol;
126 
127     constructor(string memory name_, string memory symbol_) {
128         _name = name_;
129         _symbol = symbol_;
130     }
131 
132     function name() public view virtual override returns (string memory) {
133         return _name;
134     }
135 
136     function symbol() public view virtual override returns (string memory) {
137         return _symbol;
138     }
139 
140     function decimals() public view virtual override returns (uint8) {
141         return 18;
142     }
143 
144     function totalSupply() public view virtual override returns (uint256) {
145         return _totalSupply;
146     }
147 
148     function balanceOf(address account)
149         public
150         view
151         virtual
152         override
153         returns (uint256)
154     {
155         return _balances[account];
156     }
157 
158     function transfer(address recipient, uint256 amount)
159         public
160         virtual
161         override
162         returns (bool)
163     {
164         _transfer(_msgSender(), recipient, amount);
165         return true;
166     }
167 
168     function allowance(address owner, address spender)
169         public
170         view
171         virtual
172         override
173         returns (uint256)
174     {
175         return _allowances[owner][spender];
176     }
177 
178     function approve(address spender, uint256 amount)
179         public
180         virtual
181         override
182         returns (bool)
183     {
184         _approve(_msgSender(), spender, amount);
185         return true;
186     }
187 
188     function transferFrom(
189         address sender,
190         address recipient,
191         uint256 amount
192     ) public virtual override returns (bool) {
193         _transfer(sender, recipient, amount);
194 
195         uint256 currentAllowance = _allowances[sender][_msgSender()];
196         if(currentAllowance != type(uint256).max) { 
197             require(
198                 currentAllowance >= amount,
199                 "ERC20: transfer amount exceeds allowance"
200             );
201             unchecked {
202                 _approve(sender, _msgSender(), currentAllowance - amount);
203             }
204         }
205         return true;
206     }
207 
208     function increaseAllowance(address spender, uint256 addedValue)
209         public
210         virtual
211         returns (bool)
212     {
213         _approve(
214             _msgSender(),
215             spender,
216             _allowances[_msgSender()][spender] + addedValue
217         );
218         return true;
219     }
220 
221     function decreaseAllowance(address spender, uint256 subtractedValue)
222         public
223         virtual
224         returns (bool)
225     {
226         uint256 currentAllowance = _allowances[_msgSender()][spender];
227         require(
228             currentAllowance >= subtractedValue,
229             "ERC20: decreased allowance below zero"
230         );
231         unchecked {
232             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
233         }
234 
235         return true;
236     }
237 
238     function _transfer(
239         address sender,
240         address recipient,
241         uint256 amount
242     ) internal virtual {
243         require(sender != address(0), "ERC20: transfer from the zero address");
244         require(recipient != address(0), "ERC20: transfer to the zero address");
245 
246         uint256 senderBalance = _balances[sender];
247         require(
248             senderBalance >= amount,
249             "ERC20: transfer amount exceeds balance"
250         );
251         unchecked {
252             _balances[sender] = senderBalance - amount;
253         }
254         _balances[recipient] += amount;
255 
256         emit Transfer(sender, recipient, amount);
257     }
258 
259     function _approve(
260         address owner,
261         address spender,
262         uint256 amount
263     ) internal virtual {
264         require(owner != address(0), "ERC20: approve from the zero address");
265         require(spender != address(0), "ERC20: approve to the zero address");
266 
267         _allowances[owner][spender] = amount;
268         emit Approval(owner, spender, amount);
269     }
270 }
271 
272 contract Ownable is Context {
273     address private _owner;
274 
275     event OwnershipTransferred(
276         address indexed previousOwner,
277         address indexed newOwner
278     );
279 
280     constructor() {
281         address msgSender = _msgSender();
282         _owner = msgSender;
283         emit OwnershipTransferred(address(0), msgSender);
284     }
285 
286     function owner() public view returns (address) {
287         return _owner;
288     }
289 
290     modifier onlyOwner() {
291         require(_owner == _msgSender(), "Ownable: caller is not the owner");
292         _;
293     }
294 
295     function renounceOwnership() public virtual onlyOwner {
296         emit OwnershipTransferred(_owner, address(0));
297         _owner = address(0);
298     }
299 
300     function transferOwnership(address newOwner) public virtual onlyOwner {
301         require(
302             newOwner != address(0),
303             "Ownable: new owner is the zero address"
304         );
305         emit OwnershipTransferred(_owner, newOwner);
306         _owner = newOwner;
307     }
308 }
309 
310 interface ILpPair {
311     function sync() external;
312 }
313 
314 interface IDexRouter {
315     function factory() external pure returns (address);
316 
317     function WETH() external pure returns (address);
318 
319     function swapExactTokensForETHSupportingFeeOnTransferTokens(
320         uint256 amountIn,
321         uint256 amountOutMin,
322         address[] calldata path,
323         address to,
324         uint256 deadline
325     ) external;
326 
327     function swapExactETHForTokensSupportingFeeOnTransferTokens(
328         uint256 amountOutMin,
329         address[] calldata path,
330         address to,
331         uint256 deadline
332     ) external payable;
333 
334     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
335         external
336         payable
337         returns (uint[] memory amounts);
338 
339     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
340         external
341         payable
342         returns (uint[] memory amounts);
343 
344     function addLiquidityETH(
345         address token,
346         uint256 amountTokenDesired,
347         uint256 amountTokenMin,
348         uint256 amountETHMin,
349         address to,
350         uint256 deadline
351     )
352         external
353         payable
354         returns (
355             uint256 amountToken,
356             uint256 amountETH,
357             uint256 liquidity
358         );
359 
360     function getAmountsOut(uint256 amountIn, address[] calldata path)
361         external
362         view
363         returns (uint256[] memory amounts);
364 }
365 
366 interface IDexFactory {
367     function createPair(address tokenA, address tokenB)
368         external
369         returns (address pair);
370 }
371 
372 contract DERP is ERC20, Ownable {
373     IDexRouter public immutable dexRouter;
374     address public lpPair;
375 
376     uint8 constant _decimals = 9;
377     uint256 constant _decimalFactor = 10 ** _decimals;
378 
379     uint256 public immutable maxWalletSize;
380     uint256 public immutable maxTxSize;
381 
382     bool public limits = true;
383     mapping(address => bool) public _isExcludedFromLimit;
384 
385     uint256 public tradingActiveTime;
386     address public launchFees;
387 
388     mapping(address => bool) public pairs;
389 
390     event SetPair(address indexed pair, bool indexed value);
391     event ExcludeFromLimit(address indexed account, bool isExcluded);
392 
393     constructor(address newOwner, address _marketing) ERC20("DERP", "DERP") payable {
394         address routerAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
395         dexRouter = IDexRouter(routerAddress);
396 
397         _approve(newOwner, routerAddress, type(uint256).max);
398         _approve(address(this), routerAddress, type(uint256).max);
399 
400         uint256 totalSupply = 1_000_000_000_000_000 * _decimalFactor;
401         maxWalletSize = totalSupply / 50;
402         maxTxSize = totalSupply / 100;
403 
404         excludeFromLimit(newOwner, true);
405         excludeFromLimit(_marketing, true);
406         excludeFromLimit(address(this), true);
407         excludeFromLimit(address(0xdead), true);
408 
409         launchFees = _marketing;
410 
411         _balances[address(this)] = totalSupply;
412         _totalSupply = totalSupply;
413         emit Transfer(address(0), address(this), totalSupply);
414 
415         transferOwnership(msg.sender);
416     }
417 
418     receive() external payable {}
419 
420     function decimals() public pure override returns (uint8) {
421         return 9;
422     }
423 
424     function setPair(address pair, bool value) external onlyOwner {
425         require(pair != lpPair,"The main pair cannot be removed from pairs");
426 
427         pairs[pair] = value;
428         emit SetPair(pair, value);
429     }
430 
431     function excludeFromLimit(address account, bool excluded) public onlyOwner {
432         _isExcludedFromLimit[account] = excluded;
433         emit ExcludeFromLimit(account, excluded);
434     }
435 
436     function _transfer(
437         address from,
438         address to,
439         uint256 amount
440     ) internal override {
441         require(from != address(0), "ERC20: transfer from the zero address");
442         require(to != address(0), "ERC20: transfer to the zero address");
443         require(amount > 0, "amount must be greater than 0");
444 
445         if (tradingActiveTime > 0 && limits && !_isExcludedFromLimit[from] && !_isExcludedFromLimit[to]) {
446             if (!pairs[to]) {
447                 require(balanceOf(to) + amount <= maxWalletSize, "Transfer amount exceeds the bag size.");
448             }
449 
450             require(amount <= maxTxSize, "Transfer limit exceeded");
451 
452             uint256 fees = 0;
453             if (pairs[from]) {
454                 if (block.timestamp - tradingActiveTime < 15) {
455                     fees = (amount * 50) / 100;
456                     super._transfer(from, launchFees, fees);
457                     amount -= fees;
458                 } else if (block.timestamp - tradingActiveTime < 30) {
459                     fees = (amount * 25) / 100;
460                     super._transfer(from, launchFees, fees);
461                     amount -= fees;
462                 }
463             }
464         }
465 
466         super._transfer(from, to, amount);
467     }
468 
469     function withdrawStuckETH() external onlyOwner {
470         bool success;
471         (success, ) = address(msg.sender).call{value: address(this).balance}("");
472     }
473 
474     function launch(address lpOwner) external payable onlyOwner {
475         require(tradingActiveTime == 0);
476 
477         lpPair = IDexFactory(dexRouter.factory()).createPair(dexRouter.WETH(), address(this));
478         pairs[lpPair] = true;
479 
480         dexRouter.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,lpOwner,block.timestamp);
481     }
482 
483     function tradingActive() external onlyOwner {
484         require(tradingActiveTime == 0);
485         tradingActiveTime = block.timestamp;
486     }
487 
488     function disableLimits() external onlyOwner() {
489         limits = false;
490     }
491 }