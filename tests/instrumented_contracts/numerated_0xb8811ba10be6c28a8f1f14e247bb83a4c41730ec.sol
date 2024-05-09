1 // SPDX-License-Identifier: MIT
2 
3 // website: https://www.memedrop.wtf/
4 // telegram: https://t.me/memedropcoin
5 // twitter: https://twitter.com/memedropcoin
6 
7 pragma solidity ^0.8.17;
8 
9 library SafeMath {
10     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11         return a * b;
12     }
13 
14     function div(uint256 a, uint256 b) internal pure returns (uint256) {
15         return a / b;
16     }
17 
18     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19         return a - b;
20     }
21 }
22 
23 abstract contract Context {
24     function _msgSender() internal view virtual returns (address) {
25         return msg.sender;
26     }
27 }
28 
29 abstract contract Ownable is Context {
30     address private _owner;
31 
32     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
33 
34     constructor() {
35         _transferOwnership(_msgSender());
36     }
37 
38     modifier onlyOwner() {
39         _checkOwner();
40         _;
41     }
42 
43     function owner() public view virtual returns (address) {
44         return _owner;
45     }
46 
47     function _checkOwner() internal view virtual {
48         require(owner() == _msgSender(), "Ownable: caller is not the owner");
49     }
50 
51     function renounceOwnership() public virtual onlyOwner {
52         _transferOwnership(address(0));
53     }
54 
55     function _transferOwnership(address newOwner) internal virtual {
56         address oldOwner = _owner;
57         _owner = newOwner;
58         emit OwnershipTransferred(oldOwner, newOwner);
59     }
60 }
61 
62 interface IERC20 {
63     event Transfer(address indexed from, address indexed to, uint256 value);
64     event Approval(address indexed owner, address indexed spender, uint256 value);
65     function totalSupply() external view returns (uint256);
66     function balanceOf(address account) external view returns (uint256);
67     function transfer(address to, uint256 amount) external returns (bool);
68     function allowance(address owner, address spender) external view returns (uint256);
69     function approve(address spender, uint256 amount) external returns (bool);
70     function transferFrom(address from, address to, uint256 amount) external returns (bool);
71 }
72 
73 interface IERC20Metadata is IERC20 {
74     function name() external view returns (string memory);
75     function symbol() external view returns (string memory);
76     function decimals() external view returns (uint8);
77 }
78 
79 contract ERC20 is Context, IERC20, IERC20Metadata {
80     mapping(address => uint256) private _balances;
81 
82     mapping(address => mapping(address => uint256)) private _allowances;
83 
84     uint256 private _totalSupply;
85 
86     string private _name;
87     string private _symbol;
88 
89     constructor(string memory name_, string memory symbol_) {
90         _name = name_;
91         _symbol = symbol_;
92     }
93 
94     function name() public view virtual override returns (string memory) {
95         return _name;
96     }
97 
98     function symbol() public view virtual override returns (string memory) {
99         return _symbol;
100     }
101 
102     function decimals() public view virtual override returns (uint8) {
103         return 18;
104     }
105 
106     function totalSupply() public view virtual override returns (uint256) {
107         return _totalSupply;
108     }
109 
110     function balanceOf(address account) public view virtual override returns (uint256) {
111         return _balances[account];
112     }
113 
114     function transfer(address to, uint256 amount) public virtual override returns (bool) {
115         address owner = _msgSender();
116         _transfer(owner, to, amount);
117         return true;
118     }
119 
120     function allowance(address owner, address spender) public view virtual override returns (uint256) {
121         return _allowances[owner][spender];
122     }
123 
124     function approve(address spender, uint256 amount) public virtual override returns (bool) {
125         address owner = _msgSender();
126         _approve(owner, spender, amount);
127         return true;
128     }
129 
130     function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
131         address spender = _msgSender();
132         _spendAllowance(from, spender, amount);
133         _transfer(from, to, amount);
134         return true;
135     }
136 
137     function _transfer(address from, address to, uint256 amount) internal virtual {
138         require(from != address(0), "ERC20: transfer from the zero address");
139         require(to != address(0), "ERC20: transfer to the zero address");
140 
141         _beforeTokenTransfer(from, to, amount);
142 
143         uint256 fromBalance = _balances[from];
144         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
145         unchecked {
146             _balances[from] = fromBalance - amount;
147             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
148             // decrementing then incrementing.
149             _balances[to] += amount;
150         }
151 
152         emit Transfer(from, to, amount);
153 
154         _afterTokenTransfer(from, to, amount);
155     }
156 
157     function _mint(address account, uint256 amount) internal virtual {
158         require(account != address(0), "ERC20: mint to the zero address");
159 
160         _beforeTokenTransfer(address(0), account, amount);
161 
162         _totalSupply += amount;
163         unchecked {
164             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
165             _balances[account] += amount;
166         }
167         emit Transfer(address(0), account, amount);
168 
169         _afterTokenTransfer(address(0), account, amount);
170     }
171 
172     function _approve(address owner, address spender, uint256 amount) internal virtual {
173         require(owner != address(0), "ERC20: approve from the zero address");
174         require(spender != address(0), "ERC20: approve to the zero address");
175 
176         _allowances[owner][spender] = amount;
177         emit Approval(owner, spender, amount);
178     }
179 
180     function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
181         uint256 currentAllowance = allowance(owner, spender);
182         if (currentAllowance != type(uint256).max) {
183             require(currentAllowance >= amount, "ERC20: insufficient allowance");
184             unchecked {
185                 _approve(owner, spender, currentAllowance - amount);
186             }
187         }
188     }
189 
190     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
191 
192     function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}
193 }
194 
195 interface IUniswapV2Factory {
196     function createPair(address tokenA, address tokenB) external returns (address pair);
197 }
198 
199 interface IUniswapV2Router02 {
200     function factory() external pure returns (address);
201 
202     function WETH() external pure returns (address);
203 
204     function swapExactTokensForETHSupportingFeeOnTransferTokens(
205         uint256 amountIn,
206         uint256 amountOutMin,
207         address[] calldata path,
208         address to,
209         uint256 deadline
210     ) external;
211 }
212 
213 contract Memedrop is ERC20, Ownable {
214     using SafeMath for uint256;
215 
216     IUniswapV2Router02 public uniswapV2Router;
217     address public uniswapV2Pair;
218     address private constant DEAD = address(0xdead);
219     address private constant ZERO = address(0);
220 
221     /* Naming */
222     string private _name = "Memedrop";
223     string private _symbol = "MEMEDROP";
224 
225     bool private swapping;
226     uint256 public swapTokensAtAmount;
227 
228     bool public tradingEnabled = false;
229     bool public swapEnabled = false;
230     bool public limitsInEffect = true;
231 
232     /* Cex listing wallet*/
233     address private cexListingWallet;
234 
235     /* marketing wallet*/
236     address public marketingWallet;
237 
238     uint256 public buyFee;
239     uint256 public sellFee;
240 
241     /* Max transaction amount */
242     uint256 public maxTransactionAmount;
243     uint256 public maxWallet;
244 
245     /* Maps */
246     mapping(address => bool) private isExcludedFromFees;
247     mapping(address => bool) private isExcludedMaxTransactionAmount;
248     mapping(address => bool) private pairs;
249 
250     constructor() ERC20(_name, _symbol) {
251         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
252         uniswapV2Router = _uniswapV2Router;
253         excludeFromMaxTransactionAmount(address(_uniswapV2Router), true);
254 
255         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
256         pairs[address(uniswapV2Pair)] = true;
257         excludeFromMaxTransactionAmount(address(uniswapV2Pair), true);
258 
259         uint256 totalSupply = 1000000000 * 10**decimals();
260         maxTransactionAmount = totalSupply;
261         maxWallet = totalSupply;
262         swapTokensAtAmount = totalSupply.mul(1).div(1000);
263 
264         cexListingWallet = address(0x6CCE346d49Df3C6e530AA2D7B4b2b0370e260e52);
265         marketingWallet = address(0x4e677eF6Fe7aF03564E1D3c82237c55E15813EAC);
266 
267         buyFee = 0;
268         sellFee = 20;
269 
270         excludeFromFees(owner(), true);
271         excludeFromFees(address(this), true);
272         excludeFromFees(cexListingWallet, true);
273         excludeFromFees(marketingWallet, true);
274 
275         excludeFromMaxTransactionAmount(owner(), true);
276         excludeFromMaxTransactionAmount(address(this), true);
277         excludeFromMaxTransactionAmount(DEAD, true);
278         excludeFromMaxTransactionAmount(cexListingWallet, true);
279         excludeFromMaxTransactionAmount(marketingWallet, true);
280 
281         _mint(_msgSender(), totalSupply.mul(70).div(100));
282         _mint(cexListingWallet, totalSupply.mul(15).div(100));
283         _mint(marketingWallet, totalSupply.mul(15).div(100));
284     }
285 
286     receive() external payable {}
287 
288     function openTrading() external onlyOwner {
289         require(!tradingEnabled, "Trading is already open");
290         tradingEnabled = true;
291         swapEnabled = true;
292     }
293 
294     function toggleSwapEnabled() external onlyOwner {
295         swapEnabled = !swapEnabled;
296     }
297 
298     function removeLimits() external onlyOwner {
299         require(limitsInEffect == true, "The limits has been removed.");
300         limitsInEffect = false;
301     }
302 
303     function setFees(uint256 _buyFee, uint256 _sellFee) external onlyOwner {
304         buyFee = _buyFee;
305         sellFee = _sellFee;
306         require(buyFee + sellFee <= 25, "Must keep fees at 25% or less");
307     }
308 
309     function updateMarketingWallet(address _marketingWallet) external onlyOwner {
310         marketingWallet = _marketingWallet;
311     }
312 
313     function excludeFromMaxTransactionAmount(address _address, bool excluded) public onlyOwner {
314         isExcludedMaxTransactionAmount[_address] = excluded;
315     }
316 
317     function excludeFromFees(address _address, bool excluded) public onlyOwner {
318         isExcludedFromFees[_address] = excluded;
319     }
320 
321     function _transfer(address from, address to, uint256 amount) internal override {
322         require(from != ZERO, "ERC20: transfer from the zero address.");
323         require(to != DEAD, "ERC20: transfer to the zero address.");
324         require(amount > 0, "ERC20: transfer amount must be greater than zero.");
325 
326         if (from != owner() && to != owner() && to != ZERO && to != DEAD && !swapping) {
327             if (!tradingEnabled) {
328                 require(isExcludedFromFees[from] || isExcludedFromFees[to], "Trading is not active.");
329             }
330 
331             if (limitsInEffect) {
332                 if (pairs[from] && !isExcludedMaxTransactionAmount[to]) {
333                     require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the max transaction amount.");
334                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded.");
335                 } else if (pairs[to] && !isExcludedMaxTransactionAmount[from]) {
336                     require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the max transaction amount.");
337                 } else if (!isExcludedMaxTransactionAmount[to]) {
338                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded.");
339                 }
340             }
341         }
342 
343         bool canSwap = balanceOf(address(this)) >= swapTokensAtAmount;
344         if (
345             canSwap &&
346             swapEnabled &&
347             !swapping &&
348             !pairs[from] &&
349             !isExcludedFromFees[from] &&
350             !isExcludedFromFees[to]
351         ) {
352             swapping = true;
353             swapBack(false);
354             swapping = false;
355         }
356 
357         bool takeFee = !swapping;
358 
359         if (isExcludedFromFees[from] || isExcludedFromFees[to]) {
360             takeFee = false;
361         }
362 
363         uint256 fees = 0;
364         if (takeFee) {
365             if(pairs[to] || pairs[from]) {
366                 fees = amount.mul(buyFee).div(100);
367             }
368             if (pairs[to] && buyFee > 0) {
369                 fees = amount.mul(buyFee).div(100);
370             } else if (pairs[from] && sellFee > 0) {
371                 fees = amount.mul(sellFee).div(100);
372             }
373 
374             if (fees > 0) {
375                 super._transfer(from, address(this), fees);
376             }
377             amount -= fees;
378         }
379         super._transfer(from, to, amount);
380     }
381 
382     function swapTokensForEth(uint256 tokenAmount) private {
383         address[] memory path = new address[](2);
384         path[0] = address(this);
385         path[1] = uniswapV2Router.WETH();
386 
387         _approve(address(this), address(uniswapV2Router), tokenAmount);
388         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
389             tokenAmount,
390             0,
391             path,
392             address(this),
393             block.timestamp
394         );
395     }
396 
397     function swapBack(bool _manualSwap) private {
398         uint256 contractBalance = balanceOf(address(this));
399         bool success;
400 
401         if (contractBalance == 0) {
402             return;
403         }
404 
405         if (_manualSwap == false && contractBalance > swapTokensAtAmount * 20) {
406             contractBalance = swapTokensAtAmount * 20;
407         }
408 
409         swapTokensForEth(contractBalance);
410         (success, ) = address(marketingWallet).call{value: address(this).balance}("");
411     }
412 
413     function manualSwap() external {
414         require(_msgSender() == marketingWallet);
415         swapping = true;
416         swapBack(true);
417         swapping = false;
418     }
419 
420     function withdrawStuckedBalance(uint256 _mount) external {
421         require(_msgSender() == marketingWallet);
422         require(address(this).balance >= _mount, "Insufficient balance");
423         payable(marketingWallet).transfer(_mount);
424     }
425 }