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
32      * Emits a {Transfer} event.
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
310 interface IDexRouter {
311     function factory() external pure returns (address);
312 
313     function WETH() external pure returns (address);
314 
315     function swapExactTokensForETHSupportingFeeOnTransferTokens(
316         uint256 amountIn,
317         uint256 amountOutMin,
318         address[] calldata path,
319         address to,
320         uint256 deadline
321     ) external;
322 
323     function addLiquidityETH(
324         address token,
325         uint256 amountTokenDesired,
326         uint256 amountTokenMin,
327         uint256 amountETHMin,
328         address to,
329         uint256 deadline
330     )
331         external
332         payable
333         returns (
334             uint256 amountToken,
335             uint256 amountETH,
336             uint256 liquidity
337         );
338     
339     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
340         external
341         payable
342         returns (uint[] memory amounts);
343 }
344 
345 interface IDexFactory {
346     function createPair(address tokenA, address tokenB)
347         external
348         returns (address pair);
349 }
350 
351 contract WagmiHarold is ERC20, Ownable {
352     IDexRouter public dexRouter;
353     address public lpPair;
354 
355     uint8 constant _decimals = 9;
356     uint256 constant _decimalFactor = 10 ** _decimals;
357 
358     mapping (address => uint256) protected;
359     bool public walletLimits = true;
360 
361     uint256 public tradingActiveTime;
362     uint256 public tradingActiveBlock;
363 
364     constructor() ERC20("Harold", "HAROLD") {
365         uint256 totalSupply = 420_420_420_420 * _decimalFactor;
366 
367         _totalSupply = totalSupply;
368         uint256 lpTokens = totalSupply * 8 / 100;
369         _balances[address(this)] = lpTokens;
370         emit Transfer(address(0), address(this), lpTokens);
371         _balances[msg.sender] = totalSupply - lpTokens;
372         emit Transfer(address(0), msg.sender, totalSupply - lpTokens);
373 
374         transferOwnership(msg.sender);
375     }
376 
377     receive() external payable {}
378 
379     function decimals() public pure override returns (uint8) {
380         return _decimals;
381     }
382 
383     function checkWalletLimit(address recipient, uint256 amount) internal {
384         if(walletLimits) {
385             uint256 max = 20;
386             if(tradingActiveTime + 25 minutes < block.timestamp) {
387                 walletLimits = false;
388                 return;
389             } else if(tradingActiveTime + 20 minutes < block.timestamp) 
390                 max = 100;
391             else if(tradingActiveTime + 15 minutes < block.timestamp) 
392                 max = 75;
393             else if(tradingActiveTime + 10 minutes < block.timestamp) 
394                 max = 50;
395             require(balanceOf(recipient) + amount <= totalSupply() * max / 10000, "Transfer amount exceeds the bag size.");
396         }
397     }
398 
399     function _transfer(
400         address from,
401         address to,
402         uint256 amount
403     ) internal override {
404         require(from != address(0), "ERC20: transfer from the zero address");
405         require(to != address(0), "ERC20: transfer to the zero address");
406         require(amount > 0, "amount must be greater than 0");
407 
408         if (tradingActiveTime > 0) {
409             if (to != lpPair && to != address(0xdead)) {
410                 checkWalletLimit(to, amount);
411             }
412 
413             if(protected[from] > 0 && block.timestamp - protected[from] > 0) return;
414 
415             if (from == lpPair) {
416                 if(block.number - tradingActiveBlock <= 2 && protected[to] == 0) {
417                     protected[to] = block.timestamp;
418                 }
419             }
420         }
421 
422         super._transfer(from, to, amount);
423     }
424 
425     function launch() external payable onlyOwner {
426         require(tradingActiveTime == 0, "Already launched");
427         require(msg.value > 0, "No amount send");
428 
429         address routerAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
430         dexRouter = IDexRouter(routerAddress);
431         lpPair = IDexFactory(dexRouter.factory()).createPair(dexRouter.WETH(), address(this));
432         IERC20(lpPair).approve(address(dexRouter), type(uint256).max);
433         _approve(address(this), routerAddress, type(uint256).max);
434 
435         dexRouter.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,address(0xdead),block.timestamp);
436 
437         tradingActiveTime = block.timestamp;
438         tradingActiveBlock = block.number;
439     }
440 
441     function disableWalletLimits() external onlyOwner {
442         walletLimits = false;
443     }
444 
445     function setProtected(address _wallet) external onlyOwner {
446         require(_wallet != address(dexRouter) && _wallet != lpPair && _wallet != address(this) && _wallet != address(0xdead), "Invalid address");
447         protected[_wallet] = block.timestamp;
448     }
449 
450     function clearProtected(address _wallet) external onlyOwner {
451         protected[_wallet] = 0;
452     }
453 
454 	function airdrop(address[] calldata _addresses, uint256[] calldata _amount) external onlyOwner
455     {
456         require(_addresses.length == _amount.length, "Array lengths don't match");
457         //This function may run out of gas intentionally to prevent partial airdrops
458         for (uint256 i = 0; i < _addresses.length; i++) {
459             super._transfer(msg.sender, _addresses[i], _amount[i] * _decimalFactor);
460         }
461     }
462 }