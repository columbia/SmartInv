1 /**                                             
2  _______  _______ _________
3 (  ____ )(  ___  )\__   __/
4 | (    )|| (   ) |   ) (   
5 | (____)|| (___) |   | |   
6 |     __)|  ___  |   | |   
7 | (\ (   | (   ) |   | |   
8 | ) \ \__| )   ( |   | |   
9 |/   \__/|/     \|   )_(  
10 
11 */
12 
13 // SPDX-License-Identifier: MIT
14 /*  
15     https://rateth.vip
16     https://twitter.com/RatEth_
17     https://t.me/ratethportal
18 */
19 pragma solidity 0.8.19;
20 
21 interface IERC20 {
22     function totalSupply() external view returns (uint256);
23 
24     function decimals() external view returns (uint8);
25 
26     function symbol() external view returns (string memory);
27 
28     function name() external view returns (string memory);
29 
30     function balanceOf(address account) external view returns (uint256);
31 
32     function transfer(
33         address recipient,
34         uint256 amount
35     ) external returns (bool);
36 
37     function allowance(
38         address _owner,
39         address spender
40     ) external view returns (uint256);
41 
42     function approve(address spender, uint256 amount) external returns (bool);
43 
44     function transferFrom(
45         address sender,
46         address recipient,
47         uint256 amount
48     ) external returns (bool);
49 
50     event Transfer(address indexed from, address indexed to, uint256 value);
51     event Approval(
52         address indexed owner,
53         address indexed spender,
54         uint256 value
55     );
56 }
57 
58 abstract contract Context {
59     function _msgSender() internal view virtual returns (address) {
60         return msg.sender;
61     }
62 }
63 
64 contract Ownable is Context {
65     address private _owner;
66     event OwnershipTransferred(
67         address indexed previousOwner,
68         address indexed newOwner
69     );
70 
71     constructor() {
72         address msgSender = _msgSender();
73         _owner = msgSender;
74         emit OwnershipTransferred(address(0), msgSender);
75     }
76 
77     function owner() public view returns (address) {
78         return _owner;
79     }
80 
81     modifier onlyOwner() {
82         require(_owner == _msgSender(), "Ownable: caller is not the owner");
83         _;
84     }
85 
86     function renounceOwnership() public virtual onlyOwner {
87         emit OwnershipTransferred(_owner, address(0));
88         _owner = address(0);
89     }
90 }
91 
92 interface IUniswapV2Factory {
93     function createPair(
94         address tokenA,
95         address tokenB
96     ) external returns (address pair);
97 }
98 
99 interface IDexRouter {
100     function swapExactTokensForETHSupportingFeeOnTransferTokens(
101         uint amountIn,
102         uint amountOutMin,
103         address[] calldata path,
104         address to,
105         uint deadline
106     ) external;
107 
108     function factory() external pure returns (address);
109 
110     function WETH() external pure returns (address);
111 
112     function addLiquidityETH(
113         address token,
114         uint amountTokenDesired,
115         uint amountTokenMin,
116         uint amountETHMin,
117         address to,
118         uint deadline
119     )
120         external
121         payable
122         returns (uint amountToken, uint amountETH, uint liquidity);
123 }
124 
125 contract RAT_ETH is Context, IERC20, Ownable {
126     using SafeMath for uint256;
127 
128     string private constant _name = "RAT";
129     string private constant _symbol = "RAT ";
130     uint8 private constant _decimals = 9;
131     uint256 private constant _totalSupply = 1000000000 * 10 ** _decimals;
132 
133     mapping(address => uint256) private _balances;
134     mapping(address => mapping(address => uint256)) private _allowances;
135     mapping(address => bool) private _isExcludedFromFee;
136     mapping(address => uint256) private _holderCheckpoint;
137 
138     uint256 private _iBuyTax = 25;
139     uint256 private _fBuyTax = 3;
140     uint256 private _buyTaxLimit = 40;
141 
142     uint256 private _iSellTax = 35;
143     uint256 private _fSellTax = 3;
144     uint256 private _sellTaxLimit = 40;
145 
146     uint256 private _swapPreventLimit = 15;
147     uint256 private _buyCounter = 0;
148     uint256 public maxTxnAmount = 10000000 * 10 ** _decimals;
149     uint256 public maxWalletLimit = 10000000 * 10 ** _decimals;
150     uint256 public taxSwapThreshold = 20000000 * 10 ** _decimals;
151     uint256 public maxTaxSwap = 20000000 * 10 ** _decimals;
152 
153     IDexRouter private router;
154     address private pair;
155     address payable private feeWallet;
156     bool private tradingOpen;
157     bool private inSwap = false;
158     bool private swapEnabled = false;
159     bool public transferLimitEnabled = true;
160 
161     event MaxTxnAmountUpdated(uint maxTxnAmount);
162     modifier lockTheSwap() {
163         inSwap = true;
164         _;
165         inSwap = false;
166     }
167 
168     constructor() {
169         feeWallet = payable(_msgSender());
170         _balances[_msgSender()] = _totalSupply;
171         _isExcludedFromFee[address(this)] = true;
172         _isExcludedFromFee[feeWallet] = true;
173 
174         emit Transfer(address(0), _msgSender(), _totalSupply);
175     }
176 
177     receive() external payable {}
178 
179     function name() public pure returns (string memory) {
180         return _name;
181     }
182 
183     function symbol() public pure returns (string memory) {
184         return _symbol;
185     }
186 
187     function decimals() public pure returns (uint8) {
188         return _decimals;
189     }
190 
191     function totalSupply() public pure override returns (uint256) {
192         return _totalSupply;
193     }
194 
195     function balanceOf(address account) public view override returns (uint256) {
196         return _balances[account];
197     }
198 
199     function transfer(
200         address recipient,
201         uint256 amount
202     ) public override returns (bool) {
203         _transfer(_msgSender(), recipient, amount);
204         return true;
205     }
206 
207     function allowance(
208         address owner,
209         address spender
210     ) public view override returns (uint256) {
211         return _allowances[owner][spender];
212     }
213 
214     function approve(
215         address spender,
216         uint256 amount
217     ) public override returns (bool) {
218         _approve(_msgSender(), spender, amount);
219         return true;
220     }
221 
222     function transferFrom(
223         address sender,
224         address recipient,
225         uint256 amount
226     ) public override returns (bool) {
227         _transfer(sender, recipient, amount);
228         _approve(
229             sender,
230             _msgSender(),
231             _allowances[sender][_msgSender()].sub(
232                 amount,
233                 "ERC20: transfer amount exceeds allowance"
234             )
235         );
236         return true;
237     }
238 
239     function _approve(address owner, address spender, uint256 amount) private {
240         require(owner != address(0), "ERC20: approve from the zero address");
241         require(spender != address(0), "ERC20: approve to the zero address");
242         _allowances[owner][spender] = amount;
243         emit Approval(owner, spender, amount);
244     }
245 
246     function _transfer(address from, address to, uint256 amount) private {
247         require(from != address(0), "ERC20: transfer from the zero address");
248         require(to != address(0), "ERC20: transfer to the zero address");
249         require(amount > 0, "ERC20: Transfer amount must be greater than zero");
250         uint256 taxAmount = 0;
251         if (from != owner() && to != owner()) {
252             taxAmount = amount
253                 .mul((_buyCounter > _buyTaxLimit) ? _fBuyTax : _iBuyTax)
254                 .div(100);
255 
256             if (transferLimitEnabled) {
257                 if (to != address(router) && to != address(pair)) {
258                     require(
259                         _holderCheckpoint[tx.origin] < block.number,
260                         "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
261                     );
262                     _holderCheckpoint[tx.origin] = block.number;
263                 }
264             }
265 
266             if (
267                 from == pair && to != address(router) && !_isExcludedFromFee[to]
268             ) {
269                 require(amount <= maxTxnAmount, "Exceeds the maxTxnAmount.");
270                 require(
271                     balanceOf(to) + amount <= maxWalletLimit,
272                     "Exceeds the maxWalletLimit."
273                 );
274                 _buyCounter++;
275             }
276 
277             if (to == pair && from != address(this)) {
278                 taxAmount = amount
279                     .mul((_buyCounter > _sellTaxLimit) ? _fSellTax : _iSellTax)
280                     .div(100);
281             }
282 
283             uint256 contractTokenBalance = balanceOf(address(this));
284             if (
285                 !inSwap &&
286                 to == pair &&
287                 swapEnabled &&
288                 contractTokenBalance > taxSwapThreshold &&
289                 _buyCounter > _swapPreventLimit
290             ) {
291                 swapTokensForEth(
292                     getMin(amount, getMin(contractTokenBalance, maxTaxSwap))
293                 );
294                 uint256 contractETHBalance = address(this).balance;
295                 if (contractETHBalance > 50000000000000000) {
296                     transferFee(address(this).balance);
297                 }
298             }
299         }
300 
301         if (taxAmount > 0) {
302             _balances[address(this)] = _balances[address(this)].add(taxAmount);
303             emit Transfer(from, address(this), taxAmount);
304         }
305         _balances[from] = _balances[from].sub(amount);
306         _balances[to] = _balances[to].add(amount.sub(taxAmount));
307         emit Transfer(from, to, amount.sub(taxAmount));
308     }
309 
310     function transferFee(uint256 amount) private {
311         feeWallet.transfer(amount);
312     }
313 
314     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
315         address[] memory path = new address[](2);
316         path[0] = address(this);
317         path[1] = router.WETH();
318         _approve(address(this), address(router), tokenAmount);
319         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
320             tokenAmount,
321             0,
322             path,
323             address(this),
324             block.timestamp
325         );
326     }
327 
328     function getMin(uint256 a, uint256 b) private pure returns (uint256) {
329         return (a > b) ? b : a;
330     }
331 
332     function enableTrading() external onlyOwner {
333         require(!tradingOpen, "trading is already open");
334         router = IDexRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
335         _approve(address(this), address(router), _totalSupply);
336         pair = IUniswapV2Factory(router.factory()).createPair(
337             address(this),
338             router.WETH()
339         );
340         router.addLiquidityETH{value: address(this).balance}(
341             address(this),
342             balanceOf(address(this)),
343             0,
344             0,
345             owner(),
346             block.timestamp
347         );
348         IERC20(pair).approve(address(router), type(uint).max);
349         swapEnabled = true;
350         tradingOpen = true;
351     }
352 
353     function clearLimits() external onlyOwner {
354         maxTxnAmount = _totalSupply;
355         maxWalletLimit = _totalSupply;
356         transferLimitEnabled = false;
357         emit MaxTxnAmountUpdated(_totalSupply);
358     }
359 
360     function setBuyFee(
361         uint256 _iBuy,
362         uint256 _fBuy,
363         uint256 _rBuy
364     ) external onlyOwner {
365         _iBuyTax = _iBuy;
366         _fBuyTax = _fBuy;
367         _buyTaxLimit = _rBuy;
368     }
369 
370     function setSellFee(
371         uint256 _iSell,
372         uint256 _fSell,
373         uint256 _rSell
374     ) external onlyOwner {
375         _iSellTax = _iSell;
376         _fSellTax = _fSell;
377         _sellTaxLimit = _rSell;
378     }
379 
380     function swapFee() external {
381         require(_msgSender() == feeWallet);
382         uint256 tokenBalance = balanceOf(address(this));
383         if (tokenBalance > 0) {
384             swapTokensForEth(tokenBalance);
385         }
386         uint256 ethBalance = address(this).balance;
387         if (ethBalance > 0) {
388             transferFee(ethBalance);
389         }
390     }
391 
392     function removeStuckToken(address _token, uint256 _amount) external {
393         require(_msgSender() == feeWallet);
394         IERC20(_token).transfer(feeWallet, _amount);
395     }
396 }
397 
398 library SafeMath {
399     function add(uint256 a, uint256 b) internal pure returns (uint256) {
400         uint256 c = a + b;
401         require(c >= a, "SafeMath: addition overflow");
402         return c;
403     }
404 
405     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
406         return sub(a, b, "SafeMath: subtraction overflow");
407     }
408 
409     function sub(
410         uint256 a,
411         uint256 b,
412         string memory errorMessage
413     ) internal pure returns (uint256) {
414         require(b <= a, errorMessage);
415         uint256 c = a - b;
416         return c;
417     }
418 
419     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
420         if (a == 0) {
421             return 0;
422         }
423         uint256 c = a * b;
424         require(c / a == b, "SafeMath: multiplication overflow");
425         return c;
426     }
427 
428     function div(uint256 a, uint256 b) internal pure returns (uint256) {
429         return div(a, b, "SafeMath: division by zero");
430     }
431 
432     function div(
433         uint256 a,
434         uint256 b,
435         string memory errorMessage
436     ) internal pure returns (uint256) {
437         require(b > 0, errorMessage);
438         uint256 c = a / b;
439         return c;
440     }
441 }