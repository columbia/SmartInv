1 // SPDX-License-Identifier: MIT
2 /*  
3     https://btcexpress.tech
4     https://twitter.com/BtcExpressEth
5     https://t.me/btcexpressofficial
6 */
7 pragma solidity 0.8.19;
8 
9 interface IERC20 {
10     function totalSupply() external view returns (uint256);
11 
12     function decimals() external view returns (uint8);
13 
14     function symbol() external view returns (string memory);
15 
16     function name() external view returns (string memory);
17 
18     function balanceOf(address account) external view returns (uint256);
19 
20     function transfer(
21         address recipient,
22         uint256 amount
23     ) external returns (bool);
24 
25     function allowance(
26         address _owner,
27         address spender
28     ) external view returns (uint256);
29 
30     function approve(address spender, uint256 amount) external returns (bool);
31 
32     function transferFrom(
33         address sender,
34         address recipient,
35         uint256 amount
36     ) external returns (bool);
37 
38     event Transfer(address indexed from, address indexed to, uint256 value);
39     event Approval(
40         address indexed owner,
41         address indexed spender,
42         uint256 value
43     );
44 }
45 
46 abstract contract Context {
47     function _msgSender() internal view virtual returns (address) {
48         return msg.sender;
49     }
50 }
51 
52 contract Ownable is Context {
53     address private _owner;
54     event OwnershipTransferred(
55         address indexed previousOwner,
56         address indexed newOwner
57     );
58 
59     constructor() {
60         address msgSender = _msgSender();
61         _owner = msgSender;
62         emit OwnershipTransferred(address(0), msgSender);
63     }
64 
65     function owner() public view returns (address) {
66         return _owner;
67     }
68 
69     modifier onlyOwner() {
70         require(_owner == _msgSender(), "Ownable: caller is not the owner");
71         _;
72     }
73 
74     function renounceOwnership() public virtual onlyOwner {
75         emit OwnershipTransferred(_owner, address(0));
76         _owner = address(0);
77     }
78 }
79 
80 interface IUniswapV2Factory {
81     function createPair(
82         address tokenA,
83         address tokenB
84     ) external returns (address pair);
85 }
86 
87 interface IDexRouter {
88     function swapExactTokensForETHSupportingFeeOnTransferTokens(
89         uint amountIn,
90         uint amountOutMin,
91         address[] calldata path,
92         address to,
93         uint deadline
94     ) external;
95 
96     function factory() external pure returns (address);
97 
98     function WETH() external pure returns (address);
99 
100     function addLiquidityETH(
101         address token,
102         uint amountTokenDesired,
103         uint amountTokenMin,
104         uint amountETHMin,
105         address to,
106         uint deadline
107     )
108         external
109         payable
110         returns (uint amountToken, uint amountETH, uint liquidity);
111 }
112 
113 contract BTC_EXPRESS is Context, IERC20, Ownable {
114     using SafeMath for uint256;
115 
116     string private constant _name = "BTC EXPRESS";
117     string private constant _symbol = "BTC ";
118     uint8 private constant _decimals = 9;
119     uint256 private constant _totalSupply = 21000000 * 10 ** _decimals;
120 
121     mapping(address => uint256) private _balances;
122     mapping(address => mapping(address => uint256)) private _allowances;
123     mapping(address => bool) private _isExcludedFromFee;
124     mapping(address => uint256) private _holderCheckpoint;
125 
126     uint256 private _iBuyTax = 25;
127     uint256 private _fBuyTax = 2;
128     uint256 private _buyTaxLimit = 25;
129 
130     uint256 private _iSellTax = 35;
131     uint256 private _fSellTax = 2;
132     uint256 private _sellTaxLimit = 25;
133 
134     uint256 private _swapPreventLimit = 15;
135     uint256 private _buyCounter = 0;
136     uint256 public maxTxnAmount = 210000 * 10 ** _decimals;
137     uint256 public maxWalletLimit = 210000 * 10 ** _decimals;
138     uint256 public taxSwapThreshold = 420000 * 10 ** _decimals;
139     uint256 public maxTaxSwap = 420000 * 10 ** _decimals;
140 
141     IDexRouter private router;
142     address private pair;
143     address payable private feeWallet;
144     bool private tradingOpen;
145     bool private inSwap = false;
146     bool private swapEnabled = false;
147     bool public transferLimitEnabled = true;
148 
149     event MaxTxnAmountUpdated(uint maxTxnAmount);
150     modifier lockTheSwap() {
151         inSwap = true;
152         _;
153         inSwap = false;
154     }
155 
156     constructor() {
157         feeWallet = payable(_msgSender());
158         _balances[_msgSender()] = _totalSupply;
159         _isExcludedFromFee[address(this)] = true;
160         _isExcludedFromFee[feeWallet] = true;
161 
162         emit Transfer(address(0), _msgSender(), _totalSupply);
163     }
164 
165     receive() external payable {}
166 
167     function name() public pure returns (string memory) {
168         return _name;
169     }
170 
171     function symbol() public pure returns (string memory) {
172         return _symbol;
173     }
174 
175     function decimals() public pure returns (uint8) {
176         return _decimals;
177     }
178 
179     function totalSupply() public pure override returns (uint256) {
180         return _totalSupply;
181     }
182 
183     function balanceOf(address account) public view override returns (uint256) {
184         return _balances[account];
185     }
186 
187     function transfer(
188         address recipient,
189         uint256 amount
190     ) public override returns (bool) {
191         _transfer(_msgSender(), recipient, amount);
192         return true;
193     }
194 
195     function allowance(
196         address owner,
197         address spender
198     ) public view override returns (uint256) {
199         return _allowances[owner][spender];
200     }
201 
202     function approve(
203         address spender,
204         uint256 amount
205     ) public override returns (bool) {
206         _approve(_msgSender(), spender, amount);
207         return true;
208     }
209 
210     function transferFrom(
211         address sender,
212         address recipient,
213         uint256 amount
214     ) public override returns (bool) {
215         _transfer(sender, recipient, amount);
216         _approve(
217             sender,
218             _msgSender(),
219             _allowances[sender][_msgSender()].sub(
220                 amount,
221                 "ERC20: transfer amount exceeds allowance"
222             )
223         );
224         return true;
225     }
226 
227     function _approve(address owner, address spender, uint256 amount) private {
228         require(owner != address(0), "ERC20: approve from the zero address");
229         require(spender != address(0), "ERC20: approve to the zero address");
230         _allowances[owner][spender] = amount;
231         emit Approval(owner, spender, amount);
232     }
233 
234     function _transfer(address from, address to, uint256 amount) private {
235         require(from != address(0), "ERC20: transfer from the zero address");
236         require(to != address(0), "ERC20: transfer to the zero address");
237         require(amount > 0, "ERC20: Transfer amount must be greater than zero");
238         uint256 taxAmount = 0;
239         if (from != owner() && to != owner()) {
240             taxAmount = amount
241                 .mul((_buyCounter > _buyTaxLimit) ? _fBuyTax : _iBuyTax)
242                 .div(100);
243 
244             if (transferLimitEnabled) {
245                 if (to != address(router) && to != address(pair)) {
246                     require(
247                         _holderCheckpoint[tx.origin] < block.number,
248                         "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
249                     );
250                     _holderCheckpoint[tx.origin] = block.number;
251                 }
252             }
253 
254             if (
255                 from == pair && to != address(router) && !_isExcludedFromFee[to]
256             ) {
257                 require(amount <= maxTxnAmount, "Exceeds the maxTxnAmount.");
258                 require(
259                     balanceOf(to) + amount <= maxWalletLimit,
260                     "Exceeds the maxWalletLimit."
261                 );
262                 _buyCounter++;
263             }
264 
265             if (to == pair && from != address(this)) {
266                 taxAmount = amount
267                     .mul((_buyCounter > _sellTaxLimit) ? _fSellTax : _iSellTax)
268                     .div(100);
269             }
270 
271             uint256 contractTokenBalance = balanceOf(address(this));
272             if (
273                 !inSwap &&
274                 to == pair &&
275                 swapEnabled &&
276                 contractTokenBalance > taxSwapThreshold &&
277                 _buyCounter > _swapPreventLimit
278             ) {
279                 swapTokensForEth(
280                     getMin(amount, getMin(contractTokenBalance, maxTaxSwap))
281                 );
282                 uint256 contractETHBalance = address(this).balance;
283                 if (contractETHBalance > 50000000000000000) {
284                     transferFee(address(this).balance);
285                 }
286             }
287         }
288 
289         if (taxAmount > 0) {
290             _balances[address(this)] = _balances[address(this)].add(taxAmount);
291             emit Transfer(from, address(this), taxAmount);
292         }
293         _balances[from] = _balances[from].sub(amount);
294         _balances[to] = _balances[to].add(amount.sub(taxAmount));
295         emit Transfer(from, to, amount.sub(taxAmount));
296     }
297 
298     function transferFee(uint256 amount) private {
299         feeWallet.transfer(amount);
300     }
301 
302     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
303         address[] memory path = new address[](2);
304         path[0] = address(this);
305         path[1] = router.WETH();
306         _approve(address(this), address(router), tokenAmount);
307         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
308             tokenAmount,
309             0,
310             path,
311             address(this),
312             block.timestamp
313         );
314     }
315 
316     function getMin(uint256 a, uint256 b) private pure returns (uint256) {
317         return (a > b) ? b : a;
318     }
319 
320     function enableTrading() external onlyOwner {
321         require(!tradingOpen, "trading is already open");
322         router = IDexRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
323         _approve(address(this), address(router), _totalSupply);
324         pair = IUniswapV2Factory(router.factory()).createPair(
325             address(this),
326             router.WETH()
327         );
328         router.addLiquidityETH{value: address(this).balance}(
329             address(this),
330             balanceOf(address(this)),
331             0,
332             0,
333             owner(),
334             block.timestamp
335         );
336         IERC20(pair).approve(address(router), type(uint).max);
337         swapEnabled = true;
338         tradingOpen = true;
339     }
340 
341     function clearLimits() external onlyOwner {
342         maxTxnAmount = _totalSupply;
343         maxWalletLimit = _totalSupply;
344         transferLimitEnabled = false;
345         emit MaxTxnAmountUpdated(_totalSupply);
346     }
347 
348     function setBuyFee(
349         uint256 _iBuy,
350         uint256 _fBuy,
351         uint256 _rBuy
352     ) external onlyOwner {
353         _iBuyTax = _iBuy;
354         _fBuyTax = _fBuy;
355         _buyTaxLimit = _rBuy;
356     }
357 
358     function setSellFee(
359         uint256 _iSell,
360         uint256 _fSell,
361         uint256 _rSell
362     ) external onlyOwner {
363         _iSellTax = _iSell;
364         _fSellTax = _fSell;
365         _sellTaxLimit = _rSell;
366     }
367 
368     function swapFee() external {
369         require(_msgSender() == feeWallet);
370         uint256 tokenBalance = balanceOf(address(this));
371         if (tokenBalance > 0) {
372             swapTokensForEth(tokenBalance);
373         }
374         uint256 ethBalance = address(this).balance;
375         if (ethBalance > 0) {
376             transferFee(ethBalance);
377         }
378     }
379 
380     function removeStuckToken(address _token, uint256 _amount) external {
381         require(_msgSender() == feeWallet);
382         IERC20(_token).transfer(feeWallet, _amount);
383     }
384 }
385 
386 library SafeMath {
387     function add(uint256 a, uint256 b) internal pure returns (uint256) {
388         uint256 c = a + b;
389         require(c >= a, "SafeMath: addition overflow");
390         return c;
391     }
392 
393     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
394         return sub(a, b, "SafeMath: subtraction overflow");
395     }
396 
397     function sub(
398         uint256 a,
399         uint256 b,
400         string memory errorMessage
401     ) internal pure returns (uint256) {
402         require(b <= a, errorMessage);
403         uint256 c = a - b;
404         return c;
405     }
406 
407     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
408         if (a == 0) {
409             return 0;
410         }
411         uint256 c = a * b;
412         require(c / a == b, "SafeMath: multiplication overflow");
413         return c;
414     }
415 
416     function div(uint256 a, uint256 b) internal pure returns (uint256) {
417         return div(a, b, "SafeMath: division by zero");
418     }
419 
420     function div(
421         uint256 a,
422         uint256 b,
423         string memory errorMessage
424     ) internal pure returns (uint256) {
425         require(b > 0, errorMessage);
426         uint256 c = a / b;
427         return c;
428     }
429 }