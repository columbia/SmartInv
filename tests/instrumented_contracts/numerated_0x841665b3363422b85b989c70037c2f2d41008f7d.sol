1 // SPDX-License-Identifier: MIT
2 /* social:
3  https://twitter.com/MiloliCoin
4  https://www.miloli.xyz/
5  */
6 pragma solidity ^0.8.17;
7 
8 library SafeMath {
9     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10         return a * b;
11     }
12 
13     function div(uint256 a, uint256 b) internal pure returns (uint256) {
14         return a / b;
15     }
16 
17     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18         return a - b;
19     }
20 }
21 
22 abstract contract Context {
23     function _msgSender() internal view virtual returns (address) {
24         return msg.sender;
25     }
26 }
27 
28 abstract contract Ownable is Context {
29     address private _owner;
30 
31     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
32 
33     constructor() {
34         _transferOwnership(_msgSender());
35     }
36 
37     modifier onlyOwner() {
38         _checkOwner();
39         _;
40     }
41 
42     function owner() public view virtual returns (address) {
43         return _owner;
44     }
45 
46     function _checkOwner() internal view virtual {
47         require(owner() == _msgSender(), "Ownable: caller is not the owner");
48     }
49 
50     function renounceOwnership() public virtual onlyOwner {
51         _transferOwnership(address(0));
52     }
53 
54     function _transferOwnership(address newOwner) internal virtual {
55         address oldOwner = _owner;
56         _owner = newOwner;
57         emit OwnershipTransferred(oldOwner, newOwner);
58     }
59 }
60 
61 interface IERC20 {
62     event Transfer(address indexed from, address indexed to, uint256 value);
63     event Approval(address indexed owner, address indexed spender, uint256 value);
64     function totalSupply() external view returns (uint256);
65     function balanceOf(address account) external view returns (uint256);
66     function transfer(address to, uint256 amount) external returns (bool);
67     function allowance(address owner, address spender) external view returns (uint256);
68     function approve(address spender, uint256 amount) external returns (bool);
69     function transferFrom(address from, address to, uint256 amount) external returns (bool);
70 }
71 
72 interface IERC20Metadata is IERC20 {
73     function name() external view returns (string memory);
74     function symbol() external view returns (string memory);
75     function decimals() external view returns (uint8);
76 }
77 
78 contract ERC20 is Context, IERC20, IERC20Metadata {
79     mapping(address => uint256) private _balances;
80 
81     mapping(address => mapping(address => uint256)) private _allowances;
82 
83     uint256 private _totalSupply;
84 
85     string private _name;
86     string private _symbol;
87 
88     constructor(string memory name_, string memory symbol_) {
89         _name = name_;
90         _symbol = symbol_;
91     }
92 
93     function name() public view virtual override returns (string memory) {
94         return _name;
95     }
96 
97     function symbol() public view virtual override returns (string memory) {
98         return _symbol;
99     }
100 
101     function decimals() public view virtual override returns (uint8) {
102         return 18;
103     }
104 
105     function totalSupply() public view virtual override returns (uint256) {
106         return _totalSupply;
107     }
108 
109     function balanceOf(address account) public view virtual override returns (uint256) {
110         return _balances[account];
111     }
112 
113     function transfer(address to, uint256 amount) public virtual override returns (bool) {
114         address owner = _msgSender();
115         _transfer(owner, to, amount);
116         return true;
117     }
118 
119     function allowance(address owner, address spender) public view virtual override returns (uint256) {
120         return _allowances[owner][spender];
121     }
122 
123     function approve(address spender, uint256 amount) public virtual override returns (bool) {
124         address owner = _msgSender();
125         _approve(owner, spender, amount);
126         return true;
127     }
128 
129     function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
130         address spender = _msgSender();
131         _spendAllowance(from, spender, amount);
132         _transfer(from, to, amount);
133         return true;
134     }
135 
136     function _transfer(address from, address to, uint256 amount) internal virtual {
137         require(from != address(0), "ERC20: transfer from the zero address");
138         require(to != address(0), "ERC20: transfer to the zero address");
139 
140         _beforeTokenTransfer(from, to, amount);
141 
142         uint256 fromBalance = _balances[from];
143         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
144         unchecked {
145             _balances[from] = fromBalance - amount;
146             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
147             // decrementing then incrementing.
148             _balances[to] += amount;
149         }
150 
151         emit Transfer(from, to, amount);
152 
153         _afterTokenTransfer(from, to, amount);
154     }
155 
156     function _mint(address account, uint256 amount) internal virtual {
157         require(account != address(0), "ERC20: mint to the zero address");
158 
159         _beforeTokenTransfer(address(0), account, amount);
160 
161         _totalSupply += amount;
162         unchecked {
163             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
164             _balances[account] += amount;
165         }
166         emit Transfer(address(0), account, amount);
167 
168         _afterTokenTransfer(address(0), account, amount);
169     }
170 
171     function _approve(address owner, address spender, uint256 amount) internal virtual {
172         require(owner != address(0), "ERC20: approve from the zero address");
173         require(spender != address(0), "ERC20: approve to the zero address");
174 
175         _allowances[owner][spender] = amount;
176         emit Approval(owner, spender, amount);
177     }
178 
179     function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
180         uint256 currentAllowance = allowance(owner, spender);
181         if (currentAllowance != type(uint256).max) {
182             require(currentAllowance >= amount, "ERC20: insufficient allowance");
183             unchecked {
184                 _approve(owner, spender, currentAllowance - amount);
185             }
186         }
187     }
188 
189     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
190 
191     function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}
192 }
193 
194 interface IUniswapV2Factory {
195     function createPair(address tokenA, address tokenB) external returns (address pair);
196 }
197 
198 interface IUniswapV2Router02 {
199     function factory() external pure returns (address);
200 
201     function WETH() external pure returns (address);
202 
203     function swapExactTokensForETHSupportingFeeOnTransferTokens(
204         uint256 amountIn,
205         uint256 amountOutMin,
206         address[] calldata path,
207         address to,
208         uint256 deadline
209     ) external;
210 }
211 
212 contract miloli is ERC20, Ownable {
213     using SafeMath for uint256;
214 
215     IUniswapV2Router02 public uniswapV2Router;
216     address public uniswapV2Pair;
217     address private constant DEAD = address(0xdead);
218     address private constant ZERO = address(0);
219 
220     /* Naming */
221     string private _name = "Miloli Coin";
222     string private _symbol = "$MILOLI";
223 
224     bool private swapping;
225     uint256 public swapTokensAtAmount;
226 
227     bool public tradingEnabled = false;
228     bool public swapEnabled = false;
229     bool public limitsInEffect = true;
230 
231     /* Cex listing wallet*/
232     address private cexListingWallet;
233 
234     /* marketing wallet*/
235     address public marketingWallet;
236 
237     uint256 public buyFee;
238     uint256 public sellFee;
239 
240     /* Max transaction amount */
241     uint256 public maxTransactionAmount;
242     uint256 public maxWallet;
243 
244     /* Maps */
245     mapping(address => bool) private isExcludedFromFees;
246     mapping(address => bool) private isExcludedMaxTransactionAmount;
247     mapping(address => bool) private pairs;
248 
249     constructor() ERC20(_name, _symbol) {
250         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
251         uniswapV2Router = _uniswapV2Router;
252         excludeFromMaxTransactionAmount(address(_uniswapV2Router), true);
253 
254         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
255         pairs[address(uniswapV2Pair)] = true;
256         excludeFromMaxTransactionAmount(address(uniswapV2Pair), true);
257 
258         uint256 totalSupply = 100000000000 * 10**decimals();
259         maxTransactionAmount = totalSupply;
260         maxWallet = totalSupply;
261         swapTokensAtAmount = totalSupply.mul(1).div(1000);
262 
263         cexListingWallet = address(0x3b832C4D293D3d778D9cB28cEcF7e070245a7ebF);
264         marketingWallet = address(0xc07700222D7978246755153db283637Fa9460204);
265 
266         buyFee = 5;
267         sellFee = 5;
268 
269         excludeFromFees(owner(), true);
270         excludeFromFees(address(this), true);
271         excludeFromFees(cexListingWallet, true);
272         excludeFromFees(marketingWallet, true);
273 
274         excludeFromMaxTransactionAmount(owner(), true);
275         excludeFromMaxTransactionAmount(address(this), true);
276         excludeFromMaxTransactionAmount(DEAD, true);
277         excludeFromMaxTransactionAmount(cexListingWallet, true);
278         excludeFromMaxTransactionAmount(marketingWallet, true);
279 
280         _mint(_msgSender(), totalSupply.mul(90).div(100));
281         _mint(cexListingWallet, totalSupply.mul(50).div(1000));
282         _mint(marketingWallet, totalSupply.mul(50).div(1000));
283     }
284 
285     receive() external payable {}
286 
287     function openTrading() external onlyOwner {
288         require(!tradingEnabled, "Trading is already open");
289         tradingEnabled = true;
290         swapEnabled = true;
291     }
292 
293     function toggleSwapEnabled() external onlyOwner {
294         swapEnabled = !swapEnabled;
295     }
296 
297     function removeLimits() external onlyOwner {
298         require(limitsInEffect == true, "The limits has been removed.");
299         limitsInEffect = false;
300     }
301 
302     function setFees(uint256 _buyFee, uint256 _sellFee) external onlyOwner {
303         buyFee = _buyFee;
304         sellFee = _sellFee;
305         require(buyFee + sellFee <= 25, "Must keep fees at 25% or less");
306     }
307 
308     function updateMarketingWallet(address _marketingWallet) external onlyOwner {
309         marketingWallet = _marketingWallet;
310     }
311 
312     function excludeFromMaxTransactionAmount(address _address, bool excluded) public onlyOwner {
313         isExcludedMaxTransactionAmount[_address] = excluded;
314     }
315 
316     function excludeFromFees(address _address, bool excluded) public onlyOwner {
317         isExcludedFromFees[_address] = excluded;
318     }
319 
320     function _transfer(address from, address to, uint256 amount) internal override {
321         require(from != ZERO, "ERC20: transfer from the zero address.");
322         require(to != DEAD, "ERC20: transfer to the zero address.");
323         require(amount > 0, "ERC20: transfer amount must be greater than zero.");
324 
325         if (from != owner() && to != owner() && to != ZERO && to != DEAD && !swapping) {
326             if (!tradingEnabled) {
327                 require(isExcludedFromFees[from] || isExcludedFromFees[to], "Trading is not active.");
328             }
329 
330             if (limitsInEffect) {
331                 if (pairs[from] && !isExcludedMaxTransactionAmount[to]) {
332                     require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the max transaction amount.");
333                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded.");
334                 } else if (pairs[to] && !isExcludedMaxTransactionAmount[from]) {
335                     require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the max transaction amount.");
336                 } else if (!isExcludedMaxTransactionAmount[to]) {
337                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded.");
338                 }
339             }
340         }
341 
342         bool canSwap = balanceOf(address(this)) >= swapTokensAtAmount;
343         if (
344             canSwap &&
345             swapEnabled &&
346             !swapping &&
347             !pairs[from] &&
348             !isExcludedFromFees[from] &&
349             !isExcludedFromFees[to]
350         ) {
351             swapping = true;
352             swapBack(false);
353             swapping = false;
354         }
355 
356         bool takeFee = !swapping;
357 
358         if (isExcludedFromFees[from] || isExcludedFromFees[to]) {
359             takeFee = false;
360         }
361 
362         uint256 fees = 0;
363         if (takeFee) {
364             if(pairs[to] || pairs[from]) {
365                 fees = amount.mul(buyFee).div(100);
366             }
367             if (pairs[to] && buyFee > 0) {
368                 fees = amount.mul(buyFee).div(100);
369             } else if (pairs[from] && sellFee > 0) {
370                 fees = amount.mul(sellFee).div(100);
371             }
372 
373             if (fees > 0) {
374                 super._transfer(from, address(this), fees);
375             }
376             amount -= fees;
377         }
378         super._transfer(from, to, amount);
379     }
380 
381     function swapTokensForEth(uint256 tokenAmount) private {
382         address[] memory path = new address[](2);
383         path[0] = address(this);
384         path[1] = uniswapV2Router.WETH();
385 
386         _approve(address(this), address(uniswapV2Router), tokenAmount);
387         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
388             tokenAmount,
389             0,
390             path,
391             address(this),
392             block.timestamp
393         );
394     }
395 
396     function swapBack(bool _manualSwap) private {
397         uint256 contractBalance = balanceOf(address(this));
398         bool success;
399 
400         if (contractBalance == 0) {
401             return;
402         }
403 
404         if (_manualSwap == false && contractBalance > swapTokensAtAmount * 20) {
405             contractBalance = swapTokensAtAmount * 20;
406         }
407 
408         swapTokensForEth(contractBalance);
409         (success, ) = address(marketingWallet).call{value: address(this).balance}("");
410     }
411 
412     function manualSwap() external {
413         require(_msgSender() == marketingWallet);
414         swapping = true;
415         swapBack(true);
416         swapping = false;
417     }
418 
419     function withdrawStuckedBalance(uint256 _mount) external {
420         require(_msgSender() == marketingWallet);
421         require(address(this).balance >= _mount, "Insufficient balance");
422         payable(marketingWallet).transfer(_mount);
423     }
424 }