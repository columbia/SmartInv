1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.13;
3 
4 abstract contract Context {
5     function _msgSender() internal view virtual returns (address) {
6         return msg.sender;
7     }
8 
9     function _msgData() internal view virtual returns (bytes calldata) {
10         return msg.data;
11     }
12 }
13 
14 interface IERC20 {
15    
16     function totalSupply() external view returns (uint256);
17 
18     function balanceOf(address account) external view returns (uint256);
19 
20     function transfer(address to, uint256 amount) external returns (bool);
21 
22     function allowance(address owner, address spender) external view returns (uint256);
23 
24     function approve(address spender, uint256 amount) external returns (bool);
25 
26     function transferFrom(
27         address from,
28         address to,
29         uint256 amount
30     ) external returns (bool);
31 
32     event Transfer(address indexed from, address indexed to, uint256 value);
33 
34   
35     event Approval(address indexed owner, address indexed spender, uint256 value);
36 }
37 
38 interface IERC20Metadata is IERC20 {
39    
40     function name() external view returns (string memory);
41 
42     function symbol() external view returns (string memory);
43 
44     function decimals() external view returns (uint8);
45 }
46 
47 abstract contract Ownable is Context {
48     address private _owner;
49 
50     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
51 
52     
53     constructor() {
54         _transferOwnership(_msgSender());
55     }
56 
57    
58     function owner() public view virtual returns (address) {
59         return _owner;
60     }
61 
62     modifier onlyOwner() {
63         require(owner() == _msgSender(), "Ownable: caller is not the owner");
64         _;
65     }
66 
67     function renounceOwnership() public virtual onlyOwner {
68         _transferOwnership(address(0));
69     }
70 
71    
72     function transferOwnership(address newOwner) public virtual onlyOwner {
73         require(newOwner != address(0), "Ownable: new owner is the zero address");
74         _transferOwnership(newOwner);
75     }
76 
77   
78     function _transferOwnership(address newOwner) internal virtual {
79         address oldOwner = _owner;
80         _owner = newOwner;
81         emit OwnershipTransferred(oldOwner, newOwner);
82     }
83 }
84 
85 interface IUniswapV2Factory {
86     function createPair(address tokenA, address tokenB) external returns (address pair);
87 }
88 
89 interface IUniswapV2Pair {
90     function sync() external;
91 }
92 
93 interface IUniswapV2Router01 {
94     function factory() external pure returns (address);
95 
96     function WETH() external pure returns (address);
97 
98     function addLiquidity(
99         address tokenA,
100         address tokenB,
101         uint256 amountADesired,
102         uint256 amountBDesired,
103         uint256 amountAMin,
104         uint256 amountBMin,
105         address to,
106         uint256 deadline
107     )
108         external
109         returns (
110             uint256 amountA,
111             uint256 amountB,
112             uint256 liquidity
113         );
114 
115     function addLiquidityETH(
116         address token,
117         uint256 amountTokenDesired,
118         uint256 amountTokenMin,
119         uint256 amountETHMin,
120         address to,
121         uint256 deadline
122     )
123         external
124         payable
125         returns (
126             uint256 amountToken,
127             uint256 amountETH,
128             uint256 liquidity
129         );
130 }
131 
132 interface IUniswapV2Router02 is IUniswapV2Router01 {
133     function removeLiquidityETHSupportingFeeOnTransferTokens(
134         address token,
135         uint256 liquidity,
136         uint256 amountTokenMin,
137         uint256 amountETHMin,
138         address to,
139         uint256 deadline
140     ) external returns (uint256 amountETH);
141 
142     function swapExactTokensForETHSupportingFeeOnTransferTokens(
143         uint256 amountIn,
144         uint256 amountOutMin,
145         address[] calldata path,
146         address to,
147         uint256 deadline
148     ) external;
149 
150     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
151         uint256 amountIn,
152         uint256 amountOutMin,
153         address[] calldata path,
154         address to,
155         uint256 deadline
156     ) external;
157 
158     function swapExactETHForTokensSupportingFeeOnTransferTokens(
159         uint256 amountOutMin,
160         address[] calldata path,
161         address to,
162         uint256 deadline
163     ) external payable;
164 }
165 
166 
167 contract SUNNI is Context, IERC20, IERC20Metadata, Ownable {
168     
169     mapping(address => uint256) private _balances;
170     mapping(address => mapping(address => uint256)) private _allowances;
171 
172     uint256 private _totalSupply;
173     string private _name;
174     string private _symbol;
175 
176 
177     bool private inSwap;
178 
179     uint256 internal _FeeCollected;
180     
181     uint256 public minTokensBeforeSwap;
182     
183     IUniswapV2Router02 public router;
184     address public pair;
185 
186     uint public _feeDecimal = 2;
187     // index 0 = buy fee, index 1 = sell fee, index 2 = p2p fee
188     uint[] public _Fee;
189 
190     address public fee_wallet;
191 
192     bool public swapEnabled = true;
193     bool public isFeeActive = true;
194     mapping(address => bool) public isTaxless;
195     event Swap(uint swaped);
196 
197 
198     event DelegateVotesChanged(
199     address indexed delegate, 
200     uint previousBalance, 
201     uint newBalance
202     );
203 
204     event DelegateChanged(
205     address indexed delegator, 
206     address indexed fromDelegate, 
207     address indexed toDelegate
208     );
209 
210     constructor(address _fee_wallet) {
211         
212 
213         string memory e_name = "SUNNI";
214         string memory e_symbol = "SUNNI";
215         uint e_totalSupply = 10_000_000_000 ether;
216         minTokensBeforeSwap = 1_000 ether ;   
217 
218         fee_wallet = _fee_wallet;
219 
220         _name = e_name;
221         _symbol = e_symbol;
222 
223         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
224         pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
225      
226 
227         router = _uniswapV2Router;
228 
229         _Fee.push(3000); // Buy  fee
230         _Fee.push(3000); // Sell fee 
231         _Fee.push(0); // P2P  fee 
232 
233         isTaxless[msg.sender] = true;
234         isTaxless[address(this)] = true;
235         isTaxless[fee_wallet] = true;
236         isTaxless[address(0)] = true;
237 
238         _mint(msg.sender, e_totalSupply);
239 
240     }
241 
242  
243     function name() public view virtual override returns (string memory) {
244         return _name;
245     }
246 
247   
248     function symbol() public view virtual override returns (string memory) {
249         return _symbol;
250     }
251 
252  
253     function decimals() public view virtual override returns (uint8) {
254         return 18;
255     }
256 
257   
258     function totalSupply() public view virtual override returns (uint256) {
259         return _totalSupply;
260     }
261 
262  
263     function balanceOf(address account) public view virtual override returns (uint256) {
264         return _balances[account];
265     }
266 
267  
268     function transfer(address to, uint256 amount) public virtual override returns (bool) {
269         address owner = _msgSender();
270         _transfer(owner, to, amount);
271         return true;
272     }
273 
274     
275     function allowance(address owner, address spender) public view virtual override returns (uint256) {
276         return _allowances[owner][spender];
277     }
278 
279    
280     function approve(address spender, uint256 amount) public virtual override returns (bool) {
281         address owner = _msgSender();
282         _approve(owner, spender, amount);
283         return true;
284     }
285 
286     function transferFrom(
287         address from,
288         address to,
289         uint256 amount
290     ) public virtual override returns (bool) {
291         address spender = _msgSender();
292         _spendAllowance(from, spender, amount);
293         _transfer(from, to, amount);
294         return true;
295     }
296 
297     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
298         address owner = _msgSender();
299         _approve(owner, spender, _allowances[owner][spender] + addedValue);
300         return true;
301     }
302 
303  
304     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
305         address owner = _msgSender();
306         uint256 currentAllowance = _allowances[owner][spender];
307         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
308         unchecked {
309             _approve(owner, spender, currentAllowance - subtractedValue);
310         }
311 
312         return true;
313     }
314 
315     
316     function _transfer(
317         address from,
318         address to,
319         uint256 amount
320     ) internal virtual {
321         require(from != address(0), "ERC20: transfer from the zero address");
322         require(to != address(0), "ERC20: transfer to the zero address");
323 
324         _beforeTokenTransfer(from, to, amount);
325 
326     
327     
328         if (swapEnabled && !inSwap && from != pair ) {
329            swap();
330         }
331 
332         uint256 feesCollected;
333         if ((isFeeActive) && !isTaxless[from] && !isTaxless[to] && !inSwap) {
334             bool sell = to == pair;
335             bool p2p = from != pair && to != pair;
336             feesCollected = calculateFee(p2p ? 2 : sell ? 1 : 0, amount);
337         }
338 
339         amount -= feesCollected;
340         _balances[from] -= feesCollected;
341         _balances[address(this)] += feesCollected;
342 
343         uint256 fromBalance = _balances[from];
344         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
345         unchecked {
346             _balances[from] = fromBalance - amount;
347         }
348         _balances[to] += amount;
349 
350         emit Transfer(from, to, amount);
351 
352         _afterTokenTransfer(from, to, amount);
353     }
354 
355     function _mint(address account, uint256 amount) internal virtual {
356         require(account != address(0), "ERC20: mint to the zero address");
357 
358         _beforeTokenTransfer(address(0), account, amount);
359 
360         _totalSupply += amount;
361         _balances[account] += amount;
362         emit Transfer(address(0), account, amount);
363 
364         _afterTokenTransfer(address(0), account, amount);
365     }
366 
367   
368     function _burn(address account, uint256 amount) internal virtual {
369         require(account != address(0), "ERC20: burn from the zero address");
370 
371         _beforeTokenTransfer(account, address(0), amount);
372 
373         uint256 accountBalance = _balances[account];
374         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
375         unchecked {
376             _balances[account] = accountBalance - amount;
377         }
378         _totalSupply -= amount;
379 
380         emit Transfer(account, address(0), amount);
381 
382         _afterTokenTransfer(account, address(0), amount);
383     }
384 
385     function _approve(
386         address owner,
387         address spender,
388         uint256 amount
389     ) internal virtual {
390         require(owner != address(0), "ERC20: approve from the zero address");
391         require(spender != address(0), "ERC20: approve to the zero address");
392 
393         _allowances[owner][spender] = amount;
394         emit Approval(owner, spender, amount);
395     }
396 
397   
398     function _spendAllowance(
399         address owner,
400         address spender,
401         uint256 amount
402     ) internal virtual {
403         uint256 currentAllowance = allowance(owner, spender);
404         if (currentAllowance != type(uint256).max) {
405             require(currentAllowance >= amount, "ERC20: insufficient allowance");
406             unchecked {
407                 _approve(owner, spender, currentAllowance - amount);
408             }
409         }
410     }
411 
412     function _beforeTokenTransfer(
413         address from,
414         address to,
415         uint256 amount
416     ) internal virtual {}
417 
418   
419     function _afterTokenTransfer(
420         address from,
421         address to,
422         uint256 amount
423     ) internal virtual {}
424 
425 
426  modifier lockTheSwap() {
427         inSwap = true;
428         _;
429         inSwap = false;
430     }
431 
432     function sendViaCall(address payable _to, uint amount) private {
433         (bool sent, bytes memory data) = _to.call{value: amount}("");
434         data;
435         require(sent, "Failed to send Ether");
436     }
437 
438     function swap() private  lockTheSwap {
439         
440         uint swapAmount = balanceOf(address(this));
441         if(minTokensBeforeSwap > swapAmount) return;
442         
443         address[] memory sellPath = new address[](2);
444         sellPath[0] = address(this);
445         sellPath[1] = router.WETH();       
446 
447 
448         _approve(address(this), address(router), swapAmount);
449         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
450             swapAmount,
451             0,
452             sellPath,
453             address(this),
454             block.timestamp
455         );
456 
457     
458         // Send to Fee Wallet
459         if(address(this).balance > 0) sendViaCall(payable(fee_wallet), address(this).balance);
460         emit Swap(swapAmount);
461        
462     }
463 
464      function calculateFee(uint256 feeIndex, uint256 amount) internal view returns(uint256) {
465         uint256 fee = (amount * _Fee[feeIndex]) / (10**(_feeDecimal + 2));
466         return fee;
467     }
468 
469     function setMinTokensBeforeSwap(uint256 amount) external onlyOwner {
470         minTokensBeforeSwap = amount;
471     }
472 
473     function setFeeWallet(address wallet)  external onlyOwner {
474         fee_wallet = wallet;
475     }
476 
477     function setFees(uint256 buy, uint256 sell, uint256 p2p) external onlyOwner {
478         _Fee[0] = buy;
479         _Fee[1] = sell;
480         _Fee[2] = p2p;
481     }
482 
483     function setSwapEnabled(bool enabled) external onlyOwner {
484         swapEnabled = enabled;
485     }
486 
487     function setFeeActive(bool value) external onlyOwner {
488         isFeeActive = value;
489     }
490 
491     function setTaxless(address account, bool value) external onlyOwner {
492         isTaxless[account] = value;
493     }
494 
495     fallback() external payable {}
496     receive() external payable {}
497 }