1 /**
2  *                                     .////.///   .%(//@@//#////@//////
3  *                              .////@@@///////&@&@@%/.@&/,@#(@//&@/@@(//.
4  *                         ////////////@@@%///@@(@@(@@@(/(@(@%,@//%@@@@#//
5  *                        ////#&@@@@@@////@@(//@@@@@@#/@@@/@%@//@//@/&@@//.
6  *                         ./////////@@@///#@@(//@@@/@@@/@@/@&@@/@/@@/@@///
7  *                              @@@.///@@@@//((. //( //@@/@@#@/@@@#/@ @@/,//
8  *                             @@%  / /@@/                                 @,
9  *                           .@@  #    @@                                  .@
10  *                          /@@  @@# / @@                                   @@
11  *                         (@@ &  ,./  @@                                   %@
12  *                         @@/        @&                                     @
13  *                         @@@@@@@@@%                                        @
14  *                        .@                                           ,   . @
15  *                        @         .. #,../&@#@/(@./   .   ..   &&#@/..(. , @
16  *                      .&      @&&,(..@@@@@@@@@(     (.//.   .@             ..
17  *                  (@@@@/    .@@,  @&            @&     #@@@@@@/  @@/        @@/
18  *                    &           (@ ,./  @@@@@#.  @(@@         &@@ ,..%%.@@@%#( @
19  *                   %.            @    &(@@@@#@   @.            #@@.  .,,/&#( #,@
20  *                  .(              @@           #@(              .@.@         %@
21  *                  @                  /@@@@@@@@.                  .@,@@@@@@@& %
22  *                  @                           @.      #%#       #(          @.
23  *                  @                                                         @
24  *                 ,&                                                        /@
25  *                .@                             .@@#/..  ..((#&@@%#.      .@.
26  *                @                                                    .#@,
27  *                @                                                 /@,
28  *              .@                                                ,@#
29  *             &&                                             (@@.
30  *            @,                                       @@@@&
31  *          @#                                         @
32  *       .@,                                           ,@
33  *    ,@%                                     @          @,
34  * .@/.#(.                                  .@/           ,@⠀⠀⠀⠀
35  * ⠀⠀⠀⠀⠀
36  * ZoomerCoin (ZOOMER)
37  * Website: https://zoomer.money
38  * Telegram: https://t.me/zoomercoinofficial
39  * Twitter: https://twitter.com/ZoomerCoin
40  */
41 
42 // SPDX-License-Identifier: NONE
43 
44 pragma solidity 0.8.19;
45 
46 abstract contract Context {
47     function _msgSender() internal view virtual returns (address) {
48         return msg.sender;
49     }
50 }
51 
52 interface IERC20 {
53     function totalSupply() external view returns (uint256);
54     function balanceOf(address account) external view returns (uint256);
55     function transfer(address recipient, uint256 amount) external returns (bool);
56     function allowance(address owner, address spender) external view returns (uint256);
57     function approve(address spender, uint256 amount) external returns (bool);
58     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
59 
60     event Transfer(address indexed from, address indexed to, uint256 value);
61     event Approval(address indexed owner, address indexed spender, uint256 value);
62 }
63 
64 library SafeMath {
65     function add(uint256 a, uint256 b) internal pure returns (uint256) {
66         uint256 c = a + b;
67         require(c >= a, "SafeMath: addition overflow");
68         return c;
69     }
70 
71     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
72         return sub(a, b, "SafeMath: subtraction overflow");
73     }
74 
75     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
76         require(b <= a, errorMessage);
77         uint256 c = a - b;
78         return c;
79     }
80 
81     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
82         if (a == 0) {
83             return 0;
84         }
85         uint256 c = a * b;
86         require(c / a == b, "SafeMath: multiplication overflow");
87         return c;
88     }
89 
90     function div(uint256 a, uint256 b) internal pure returns (uint256) {
91         return div(a, b, "SafeMath: division by zero");
92     }
93 
94     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
95         require(b > 0, errorMessage);
96         uint256 c = a / b;
97         return c;
98     }
99 }
100 
101 contract Ownable is Context {
102     address private _owner;
103 
104     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
105 
106     constructor() {
107         address msgSender = _msgSender();
108         _owner = msgSender;
109         emit OwnershipTransferred(address(0), msgSender);
110     }
111 
112     function owner() public view returns (address) {
113         return _owner;
114     }
115 
116     modifier onlyOwner() {
117         require(_owner == _msgSender(), "Ownable: caller is not the owner");
118         _;
119     }
120 
121     function renounceOwnership() public virtual onlyOwner {
122         emit OwnershipTransferred(_owner, address(0));
123         _owner = address(0);
124     }
125 }
126 
127 interface IUniswapV2Factory {
128     function createPair(address tokenA, address tokenB) external returns (address pair);
129 }
130 
131 interface IUniswapV2Router02 {
132     function swapExactTokensForETHSupportingFeeOnTransferTokens(
133         uint256 amountIn,
134         uint256 amountOutMin,
135         address[] calldata path,
136         address to,
137         uint256 deadline
138     ) external;
139     function factory() external pure returns (address);
140     function WETH() external pure returns (address);
141     function addLiquidityETH(
142         address token,
143         uint256 amountTokenDesired,
144         uint256 amountTokenMin,
145         uint256 amountETHMin,
146         address to,
147         uint256 deadline
148     ) external payable returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
149 }
150 
151 contract ZoomerCoin is Context, IERC20, Ownable {
152     using SafeMath for uint256;
153 
154     mapping(address => uint256) private _balances;
155     mapping(address => mapping(address => uint256)) private _allowances;
156     mapping(address => bool) private _isExcludedFromFee;
157     mapping(address => bool) private bots;
158     mapping(address => uint256) private _holderLastTransferTimestamp;
159     bool public transferDelayEnabled = false;
160     address payable private _taxWallet;
161 
162     uint256 private _initialBuyTax = 0;
163     uint256 private _initialSellTax = 69;
164     uint256 private _finalBuyTax = 0;
165     uint256 private _finalSellTax = 0;
166     uint256 public _reduceBuyTaxAt = 0;
167     uint256 public _reduceSellTaxAt = 369;
168     uint256 private _preventSwapBefore = 30;
169     uint256 private _buyCount = 0;
170 
171     uint8 private constant _decimals = 18;
172     uint256 private constant _tTotal = 69000000000 * 10 ** _decimals;
173     string private constant _name = unicode"ZOOMER";
174     string private constant _symbol = unicode"ZOOMER";
175     uint256 public _maxTxAmount = 138000000 * 10 ** _decimals; // 2%
176     uint256 public _maxWalletSize = 138000000 * 10 ** _decimals;
177     uint256 public _taxSwapThreshold = 414000000 * 10 ** _decimals;
178     uint256 public _maxTaxSwap = 414000000 * 10 ** _decimals;
179 
180     IUniswapV2Router02 private uniswapV2Router;
181     address private uniswapV2Pair;
182     bool private tradingOpen;
183     bool private inSwap = false;
184     bool private swapEnabled = false;
185 
186     event MaxTxAmountUpdated(uint256 _maxTxAmount);
187 
188     modifier lockTheSwap() {
189         inSwap = true;
190         _;
191         inSwap = false;
192     }
193 
194     constructor() {
195         _taxWallet = payable(_msgSender());
196         _balances[_msgSender()] = _tTotal;
197         _isExcludedFromFee[owner()] = true;
198         _isExcludedFromFee[address(this)] = true;
199         _isExcludedFromFee[_taxWallet] = true;
200 
201         emit Transfer(address(0), _msgSender(), _tTotal);
202     }
203 
204     function name() public pure returns (string memory) {
205         return _name;
206     }
207 
208     function symbol() public pure returns (string memory) {
209         return _symbol;
210     }
211 
212     function decimals() public pure returns (uint8) {
213         return _decimals;
214     }
215 
216     function totalSupply() public pure override returns (uint256) {
217         return _tTotal;
218     }
219 
220     function balanceOf(address account) public view override returns (uint256) {
221         return _balances[account];
222     }
223 
224     function transfer(address recipient, uint256 amount) public override returns (bool) {
225         _transfer(_msgSender(), recipient, amount);
226         return true;
227     }
228 
229     function allowance(address owner, address spender) public view override returns (uint256) {
230         return _allowances[owner][spender];
231     }
232 
233     function approve(address spender, uint256 amount) public override returns (bool) {
234         _approve(_msgSender(), spender, amount);
235         return true;
236     }
237 
238     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
239         _transfer(sender, recipient, amount);
240         _approve(
241             sender,
242             _msgSender(),
243             _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance")
244         );
245         return true;
246     }
247 
248     function _approve(address owner, address spender, uint256 amount) private {
249         require(owner != address(0), "ERC20: approve from the zero address");
250         require(spender != address(0), "ERC20: approve to the zero address");
251         _allowances[owner][spender] = amount;
252         emit Approval(owner, spender, amount);
253     }
254 
255     function _transfer(address from, address to, uint256 amount) private {
256         require(from != address(0), "ERC20: transfer from the zero address");
257         require(to != address(0), "ERC20: transfer to the zero address");
258         require(amount > 0, "Transfer amount must be greater than zero");
259         uint256 taxAmount = 0;
260         if (from != owner() && to != owner()) {
261             require(!bots[from] && !bots[to]);
262 
263             if (transferDelayEnabled) {
264                 if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
265                     require(
266                         _holderLastTransferTimestamp[tx.origin] < block.number, "Only one transfer per block allowed."
267                     );
268                     _holderLastTransferTimestamp[tx.origin] = block.number;
269                 }
270             }
271 
272             if (from == uniswapV2Pair && to != address(uniswapV2Router) && !_isExcludedFromFee[to]) {
273                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
274                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
275                 _buyCount++;
276             }
277 
278             taxAmount = amount.mul((_buyCount > _reduceBuyTaxAt) ? _finalBuyTax : _initialBuyTax).div(100);
279             if (to == uniswapV2Pair && from != address(this)) {
280                 taxAmount = amount.mul((_buyCount > _reduceSellTaxAt) ? _finalSellTax : _initialSellTax).div(100);
281             }
282 
283             uint256 contractTokenBalance = balanceOf(address(this));
284             if (
285                 !inSwap && to == uniswapV2Pair && swapEnabled && contractTokenBalance > _taxSwapThreshold
286                     && _buyCount > _preventSwapBefore
287             ) {
288                 swapTokensForEth(min(amount, min(contractTokenBalance, _maxTaxSwap)));
289                 uint256 contractETHBalance = address(this).balance;
290                 if (contractETHBalance > 0) {
291                     sendETHToFee(address(this).balance);
292                 }
293             }
294         }
295 
296         if (taxAmount > 0) {
297             _balances[address(this)] = _balances[address(this)].add(taxAmount);
298             emit Transfer(from, address(this), taxAmount);
299         }
300         _balances[from] = _balances[from].sub(amount);
301         _balances[to] = _balances[to].add(amount.sub(taxAmount));
302         emit Transfer(from, to, amount.sub(taxAmount));
303     }
304 
305     function min(uint256 a, uint256 b) private pure returns (uint256) {
306         return (a > b) ? b : a;
307     }
308 
309     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
310         if (tokenAmount == 0) return;
311         if (!tradingOpen) return;
312         address[] memory path = new address[](2);
313         path[0] = address(this);
314         path[1] = uniswapV2Router.WETH();
315         _approve(address(this), address(uniswapV2Router), tokenAmount);
316         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
317             tokenAmount, 0, path, address(this), block.timestamp
318         );
319     }
320 
321     function removeLimits() external onlyOwner {
322         _maxTxAmount = _tTotal;
323         _maxWalletSize = _tTotal;
324         transferDelayEnabled = false;
325         _reduceSellTaxAt = 20;
326         _reduceBuyTaxAt = 20;
327         emit MaxTxAmountUpdated(_tTotal);
328     }
329 
330     function sendETHToFee(uint256 amount) private {
331         _taxWallet.transfer(amount);
332     }
333 
334     function isBot(address a) public view returns (bool) {
335         return bots[a];
336     }
337 
338     function zoomzoom() external onlyOwner {
339         require(!tradingOpen, "trading is already open");
340         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
341         _approve(address(this), address(uniswapV2Router), _tTotal);
342         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
343         uniswapV2Router.addLiquidityETH{value: address(this).balance}(
344             address(this), balanceOf(address(this)), 0, 0, owner(), block.timestamp
345         );
346         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint256).max);
347         swapEnabled = true;
348         tradingOpen = true;
349     }
350 
351     receive() external payable {}
352 
353     function manualSwap() external {
354         require(_msgSender() == _taxWallet);
355         uint256 tokenBalance = balanceOf(address(this));
356         if (tokenBalance > 0) {
357             swapTokensForEth(tokenBalance);
358         }
359         uint256 ethBalance = address(this).balance;
360         if (ethBalance > 0) {
361             sendETHToFee(ethBalance);
362         }
363     }
364 
365     function addBots(address[] memory bots_) public onlyOwner {
366         for (uint256 i = 0; i < bots_.length; i++) {
367             bots[bots_[i]] = true;
368         }
369     }
370 
371     function delBots(address[] memory notbot) public onlyOwner {
372         for (uint256 i = 0; i < notbot.length; i++) {
373             bots[notbot[i]] = false;
374         }
375     }
376 }