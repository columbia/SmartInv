1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.7;
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address) {
7         return msg.sender;
8     }
9 
10     function _msgData() internal view virtual returns (bytes calldata) {
11         return msg.data;
12     }
13 }
14 
15 interface IERC20 {
16     function totalSupply() external view returns (uint256);
17     function balanceOf(address account) external view returns (uint256);
18     function transfer(address to, uint256 amount) external returns (bool);
19     function allowance(address owner, address spender) external view returns (uint256);
20     function approve(address spender, uint256 amount) external returns (bool);
21     function transferFrom(
22         address from,
23         address to,
24         uint256 amount
25     ) external returns (bool);
26 
27     event Transfer(address indexed from, address indexed to, uint256 value);
28     event Approval(address indexed owner, address indexed spender, uint256 value);
29 }
30 
31 interface IERC20Metadata is IERC20 {
32     function name() external view returns (string memory);
33     function symbol() external view returns (string memory);
34     function decimals() external view returns (uint8);
35 }
36 
37 contract ERC20 is Context, IERC20, IERC20Metadata {
38     mapping(address => uint256) private _balances;
39 
40     mapping(address => mapping(address => uint256)) private _allowances;
41 
42     uint256 private _totalSupply;
43 
44     string private _name;
45     string private _symbol;
46 
47     constructor(string memory name_, string memory symbol_) {
48         _name = name_;
49         _symbol = symbol_;
50     }
51 
52     function name() public view virtual override returns (string memory) {
53         return _name;
54     }
55 
56     function symbol() public view virtual override returns (string memory) {
57         return _symbol;
58     }
59 
60     function decimals() public view virtual override returns (uint8) {
61         return 18;
62     }
63 
64     function totalSupply() public view virtual override returns (uint256) {
65         return _totalSupply;
66     }
67 
68     function balanceOf(address account) public view virtual override returns (uint256) {
69         return _balances[account];
70     }
71 
72     function transfer(address to, uint256 amount) public virtual override returns (bool) {
73         address owner = _msgSender();
74         _transfer(owner, to, amount);
75         return true;
76     }
77 
78     function allowance(address owner, address spender) public view virtual override returns (uint256) {
79         return _allowances[owner][spender];
80     }
81 
82     function approve(address spender, uint256 amount) public virtual override returns (bool) {
83         address owner = _msgSender();
84         _approve(owner, spender, amount);
85         return true;
86     }
87 
88     function transferFrom(
89         address from,
90         address to,
91         uint256 amount
92     ) public virtual override returns (bool) {
93         address spender = _msgSender();
94         _spendAllowance(from, spender, amount);
95         _transfer(from, to, amount);
96         return true;
97     }
98 
99     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
100         address owner = _msgSender();
101         _approve(owner, spender, _allowances[owner][spender] + addedValue);
102         return true;
103     }
104 
105     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
106         address owner = _msgSender();
107         uint256 currentAllowance = _allowances[owner][spender];
108         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
109         unchecked {
110             _approve(owner, spender, currentAllowance - subtractedValue);
111         }
112 
113         return true;
114     }
115 
116     function _transfer(
117         address from,
118         address to,
119         uint256 amount
120     ) internal virtual {
121         require(from != address(0), "ERC20: transfer from the zero address");
122         require(to != address(0), "ERC20: transfer to the zero address");
123 
124         _beforeTokenTransfer(from, to, amount);
125 
126         uint256 fromBalance = _balances[from];
127         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
128         unchecked {
129             _balances[from] = fromBalance - amount;
130         }
131         _balances[to] += amount;
132 
133         emit Transfer(from, to, amount);
134 
135         _afterTokenTransfer(from, to, amount);
136     }
137 
138     function _mint(address account, uint256 amount) internal virtual {
139         require(account != address(0), "ERC20: mint to the zero address");
140 
141         _beforeTokenTransfer(address(0), account, amount);
142 
143         _totalSupply += amount;
144         _balances[account] += amount;
145         emit Transfer(address(0), account, amount);
146 
147         _afterTokenTransfer(address(0), account, amount);
148     }
149 
150     function _burn(address account, uint256 amount) internal virtual {
151         require(account != address(0), "ERC20: burn from the zero address");
152 
153         _beforeTokenTransfer(account, address(0), amount);
154 
155         uint256 accountBalance = _balances[account];
156         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
157         unchecked {
158             _balances[account] = accountBalance - amount;
159         }
160         _totalSupply -= amount;
161 
162         emit Transfer(account, address(0), amount);
163 
164         _afterTokenTransfer(account, address(0), amount);
165     }
166 
167     function _approve(
168         address owner,
169         address spender,
170         uint256 amount
171     ) internal virtual {
172         require(owner != address(0), "ERC20: approve from the zero address");
173         require(spender != address(0), "ERC20: approve to the zero address");
174 
175         _allowances[owner][spender] = amount;
176         emit Approval(owner, spender, amount);
177     }
178 
179     function _spendAllowance(
180         address owner,
181         address spender,
182         uint256 amount
183     ) internal virtual {
184         uint256 currentAllowance = allowance(owner, spender);
185         if (currentAllowance != type(uint256).max) {
186             require(currentAllowance >= amount, "ERC20: insufficient allowance");
187             unchecked {
188                 _approve(owner, spender, currentAllowance - amount);
189             }
190         }
191     }
192 
193     function _beforeTokenTransfer(
194         address from,
195         address to,
196         uint256 amount
197     ) internal virtual {}
198 
199     function _afterTokenTransfer(
200         address from,
201         address to,
202         uint256 amount
203     ) internal virtual {}
204 }
205 
206 interface IUniswapV2Factory {
207     function createPair(address tokenA, address tokenB) external returns (address pair);
208 }
209 
210 interface IUniswapV2Router01 {
211     function factory() external pure returns (address);
212     function WETH() external pure returns (address);
213     function addLiquidityETH(
214         address token,
215         uint amountTokenDesired,
216         uint amountTokenMin,
217         uint amountETHMin,
218         address to,
219         uint deadline
220     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
221 }
222 
223 interface IUniswapV2Router02 is IUniswapV2Router01 {
224     function swapExactTokensForETHSupportingFeeOnTransferTokens(
225         uint amountIn,
226         uint amountOutMin,
227         address[] calldata path,
228         address to,
229         uint deadline
230     ) external;
231 }
232 
233 abstract contract Ownable is Context {
234     address private _owner;
235 
236     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
237 
238     constructor() {
239         _transferOwnership(_msgSender());
240     }
241 
242     function owner() public view virtual returns (address) {
243         return _owner;
244     }
245 
246     modifier onlyOwner() {
247         require(owner() == _msgSender(), "Ownable: caller is not the owner");
248         _;
249     }
250 
251     function renounceOwnership() public virtual onlyOwner {
252         _transferOwnership(address(0));
253     }
254 
255     function transferOwnership(address newOwner) public virtual onlyOwner {
256         require(newOwner != address(0), "Ownable: new owner is the zero address");
257         _transferOwnership(newOwner);
258     }
259 
260     function _transferOwnership(address newOwner) internal virtual {
261         address oldOwner = _owner;
262         _owner = newOwner;
263         emit OwnershipTransferred(oldOwner, newOwner);
264     }
265 }
266 
267 library SafeMath {
268     function add(uint256 a, uint256 b) internal pure returns (uint256) {
269         return a + b;
270     }
271 
272     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
273         return a - b;
274     }
275 
276     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
277         return a * b;
278     }
279 
280     function div(uint256 a, uint256 b) internal pure returns (uint256) {
281         return a / b;
282     }
283 
284     function sub(
285         uint256 a,
286         uint256 b,
287         string memory errorMessage
288     ) internal pure returns (uint256) {
289         unchecked {
290             require(b <= a, errorMessage);
291             return a - b;
292         }
293     }
294 
295     function div(
296         uint256 a,
297         uint256 b,
298         string memory errorMessage
299     ) internal pure returns (uint256) {
300         unchecked {
301             require(b > 0, errorMessage);
302             return a / b;
303         }
304     }
305 }
306 
307 /*
308     * Froge ERC20 contract starts here
309 */
310 
311 contract FrogeToken is ERC20, Ownable {
312     using SafeMath for uint256;
313 
314     IUniswapV2Router02 private _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
315     address private _uniswapV2Pair;
316     
317     uint256 public maxHoldings;
318     uint256 public feeTokenThreshold;
319     bool public feesDisabled;
320         
321     bool private _inSwap;
322     uint256 private _swapFee = 3;
323     uint256 private _tokensForFee;
324     address private _feeAddr;
325 
326     mapping (address => bool) private _excludedLimits;
327 
328     // much like onlyOwner() but used for the feeAddr so that once renounced fees and maxholdings can still be disabled
329     modifier onlyFeeAddr() {
330         require(_feeAddr == _msgSender(), "Caller is not the _feeAddr address.");
331         _;
332     }
333 
334     constructor(address feeAddr) ERC20("Froge", "FROGE") payable {
335         uint256 totalSupply = 690420000000000000000000000000000;
336         uint256 totalLiquidity = totalSupply * 90 / 100; // 90%
337 
338         maxHoldings = totalSupply * 2 / 100; // 2%
339         feeTokenThreshold = totalSupply * 1 / 1000; // .1%
340 
341         _feeAddr = feeAddr;
342 
343         // exclution from fees and limits
344         _excludedLimits[owner()] = true;
345         _excludedLimits[address(this)] = true;
346         _excludedLimits[address(0xdead)] = true;
347 
348         // mint lp tokens to the contract and remaning to deployer
349         _mint(address(this), totalLiquidity);
350         _mint(msg.sender, totalSupply.sub(totalLiquidity));
351     }
352 
353     function createV2LP() external onlyOwner {
354         // create pair
355         _uniswapV2Pair = IUniswapV2Factory(
356             _uniswapV2Router.factory()).createPair(address(this), 
357             _uniswapV2Router.WETH()
358         );
359 
360         // add lp to pair
361         _addLiquidity(
362             balanceOf(address(this)), 
363             address(this).balance
364         );
365     }
366 
367     // updates the amount of tokens that needs to be reached before fee is swapped
368     function updateFeeTokenThreshold(uint256 newThreshold) external onlyFeeAddr {        
369   	    require(newThreshold >= totalSupply() * 1 / 100000, "Swap threshold cannot be lower than 0.001% total supply.");
370   	    require(newThreshold <= totalSupply() * 5 / 1000, "Swap threshold cannot be higher than 0.5% total supply.");
371   	    feeTokenThreshold = newThreshold;
372   	}
373 
374     function _transfer(
375         address from,
376         address to,
377         uint256 amount
378     ) internal override {
379         require(from != address(0), "Transfer from the zero address not allowed.");
380         require(to != address(0), "Transfer to the zero address not allowed.");
381 
382         // no reason to waste gas
383         bool isBuy = from == _uniswapV2Pair;
384         bool exluded = _excludedLimits[from] || _excludedLimits[to];
385 
386         if (amount == 0) {
387             super._transfer(from, to, 0);
388             return;
389         }
390 
391         // if pair has not yet been created
392         if (_uniswapV2Pair == address(0)) {
393             require(exluded, "Please wait for the LP pair to be created.");
394             return;
395         }
396 
397         // max holding check
398         if (maxHoldings > 0 && isBuy && to != owner() && to != address(this))
399             require(super.balanceOf(to) + amount <= maxHoldings, "Balance exceeds max holdings amount, consider using a second wallet.");
400         
401         // take fees if they haven't been perm disabled
402         if (!feesDisabled) {
403             uint256 contractTokenBalance = balanceOf(address(this));
404             bool canSwap = contractTokenBalance >= feeTokenThreshold;
405             if (
406                 canSwap &&
407                 !_inSwap &&
408                 !isBuy &&
409                 !_excludedLimits[from] &&
410                 !_excludedLimits[to]
411             ) {
412                 _inSwap = true;
413                 swapFee();
414                 _inSwap = false;
415             }
416 
417 
418             // check if we should be taking the fee
419             bool takeFee = !_inSwap;
420             if (exluded || !isBuy && to != _uniswapV2Pair) takeFee = false;
421             
422             if (takeFee) {
423                 uint256 fees = amount.mul(_swapFee).div(100);
424                 _tokensForFee = amount.mul(_swapFee).div(100);
425                 
426                 if (fees > 0)
427                     super._transfer(from, address(this), fees);
428                 
429                 amount -= fees;
430             }
431         }
432 
433         super._transfer(from, to, amount);
434     }
435 
436     // swaps tokens to eth
437     function _swapTokensForEth(uint256 tokenAmount) internal {
438         address[] memory path = new address[](2);
439         path[0] = address(this);
440         path[1] = _uniswapV2Router.WETH();
441 
442         _approve(address(this), address(_uniswapV2Router), tokenAmount);
443 
444         _uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
445             tokenAmount,
446             0,
447             path,
448             address(this),
449             block.timestamp
450         );
451     }
452 
453     // does what it says
454     function _addLiquidity(uint256 tokenAmount, uint256 ethAmount) internal {
455         _approve(address(this), address(_uniswapV2Router), tokenAmount);
456 
457         _uniswapV2Router.addLiquidityETH{value: ethAmount}(
458             address(this),
459             tokenAmount,
460             0,
461             0,
462             _feeAddr,
463             block.timestamp
464         );
465     }
466 
467     // swaps fee from tokens to eth
468     function swapFee() internal {
469         uint256 contractBal = balanceOf(address(this));
470         uint256 tokensForLiq = _tokensForFee.div(3); // 1% fee is lp
471         uint256 tokensForFee = _tokensForFee.sub(tokensForLiq); // remaning 2% is marketing/cex/development
472         
473         if (contractBal == 0 || _tokensForFee == 0) return;
474         if (contractBal > feeTokenThreshold) contractBal = feeTokenThreshold;
475         
476         // Halve the amount of liquidity tokens
477         uint256 liqTokens = contractBal * tokensForLiq / _tokensForFee / 2;
478         uint256 amountToSwapForETH = contractBal.sub(liqTokens);
479         
480         uint256 initETHBal = address(this).balance;
481 
482         _swapTokensForEth(amountToSwapForETH);
483         
484         uint256 ethBalance = address(this).balance.sub(initETHBal);
485         uint256 ethFee = ethBalance.mul(tokensForFee).div(_tokensForFee);
486         uint256 ethLiq = ethBalance - ethFee;
487         
488         _tokensForFee = 0;
489 
490         payable(_feeAddr).transfer(ethFee);
491                 
492         if (liqTokens > 0 && ethLiq > 0) 
493             _addLiquidity(liqTokens, ethLiq);
494     }
495 
496     // perm disable fees
497     function disableFees() external onlyFeeAddr {
498         feesDisabled = true;
499     }
500 
501     // perm disable max holdings
502     function disableHoldingLimit() external onlyFeeAddr {
503         maxHoldings = 0;
504     }
505 
506     // transfers any stuck eth from contract to feeAddr
507     function transferStuckETH() external {
508         payable(_feeAddr).transfer(address(this).balance);
509     }
510 
511     receive() external payable {}
512 }