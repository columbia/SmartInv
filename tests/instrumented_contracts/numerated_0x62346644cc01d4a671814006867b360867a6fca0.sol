1 /**
2  *
3 */
4 
5 /**
6 
7 We are reborn from the ashes like a Polish cow phoenix. Our Polish community is as resilient as the delicate casing of a Krakow sausage. 
8 Our old leader has banished us, and thus, @MadCowCall has chosen to let the revolution of Polish cows flourish, 
9 to replace the Euro with $PLOW, and to close the borders of Poland. Enough is enough! 
10 This European left-wing agenda that dumps our milk prices and deports tainted foreign meat into our country. 
11 I call it carcasses! Enough with Romanian slaughterhouses! We will create the new Poland out of Europe and replace the diversity of populations with Polish cows. 
12 MoooMoooo is the motto.
13 
14  _________
15 < Muuuuh! >
16  ---------
17         \   ^__^
18          \  (@@)\_______
19             (__)\       )\/\
20                 ||----w |
21                 ||     ||
22 
23 https://www.youtube.com/watch?v=OyDyOweu-PA
24 our national anthem ... <3 
25 **/
26 
27 // SPDX-License-Identifier: MIT
28 
29 pragma solidity 0.8.20;
30 
31 abstract contract Context {
32     function _msgSender() internal view virtual returns (address) {
33         return msg.sender;
34     }
35 }
36 
37 interface IERC20 {
38     function totalSupply() external view returns (uint256);
39     function balanceOf(address account) external view returns (uint256);
40     function transfer(address recipient, uint256 amount) external returns (bool);
41     function allowance(address owner, address spender) external view returns (uint256);
42     function approve(address spender, uint256 amount) external returns (bool);
43     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
44     event Transfer(address indexed from, address indexed to, uint256 value);
45     event Approval(address indexed owner, address indexed spender, uint256 value);
46 }
47 
48 library SafeMath {
49     function add(uint256 a, uint256 b) internal pure returns (uint256) {
50         uint256 c = a + b;
51         require(c >= a, "SafeMath: addition overflow");
52         return c;
53     }
54 
55     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
56         return sub(a, b, "SafeMath: subtraction overflow");
57     }
58 
59     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
60         require(b <= a, errorMessage);
61         uint256 c = a - b;
62         return c;
63     }
64 
65     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
66         if (a == 0) {
67             return 0;
68         }
69         uint256 c = a * b;
70         require(c / a == b, "SafeMath: multiplication overflow");
71         return c;
72     }
73 
74     function div(uint256 a, uint256 b) internal pure returns (uint256) {
75         return div(a, b, "SafeMath: division by zero");
76     }
77 
78     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
79         require(b > 0, errorMessage);
80         uint256 c = a / b;
81         return c;
82     }
83 
84 }
85 
86 contract Ownable is Context {
87     address private _owner;
88     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
89 
90     constructor () {
91         address msgSender = _msgSender();
92         _owner = msgSender;
93         emit OwnershipTransferred(address(0), msgSender);
94     }
95 
96     function owner() public view returns (address) {
97         return _owner;
98     }
99 
100     modifier onlyOwner() {
101         require(_owner == _msgSender(), "Ownable: caller is not the owner");
102         _;
103     }
104 
105     function renounceOwnership() public virtual onlyOwner {
106         emit OwnershipTransferred(_owner, address(0));
107         _owner = address(0);
108     }
109 
110 }
111 
112 interface IUniswapV2Factory {
113     function createPair(address tokenA, address tokenB) external returns (address pair);
114 }
115 
116 interface IUniswapV2Router02 {
117     function swapExactTokensForETHSupportingFeeOnTransferTokens(
118         uint amountIn,
119         uint amountOutMin,
120         address[] calldata path,
121         address to,
122         uint deadline
123     ) external;
124     function factory() external pure returns (address);
125     function WETH() external pure returns (address);
126     function addLiquidityETH(
127         address token,
128         uint amountTokenDesired,
129         uint amountTokenMin,
130         uint amountETHMin,
131         address to,
132         uint deadline
133     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
134 }
135 
136 contract PLOW is Context, IERC20, Ownable {
137     using SafeMath for uint256;
138     mapping (address => uint256) private _balances;
139     mapping (address => mapping (address => uint256)) private _allowances;
140     mapping (address => bool) private _isExcludedFromFee;
141     mapping (address => bool) private bots;
142     mapping(address => uint256) private _holderLastTransferTimestamp;
143     bool public transferDelayEnabled = true;
144     address payable private _taxWallet;
145 
146     uint256 private _buyTax=22;
147     uint256 private _sellTax=33;
148     uint256 private _preventSwapBefore=15;
149     uint256 private _buyCount=0;
150 
151     uint8 private constant _decimals = 9;
152     uint256 private constant _tTotal = 1000000000 * 10**_decimals;
153     string private constant _name = unicode"Polish Cow";
154     string private constant _symbol = unicode"PLOW";
155     uint256 public _maxTxAmount = 20000000 * 10**_decimals;
156     uint256 public _maxWalletSize = 20000000 * 10**_decimals;
157     uint256 public _taxSwapThreshold= 2000000  * 10**_decimals;
158     uint256 public _maxTaxSwap= 10000000 * 10**_decimals;
159     uint256 public _totalRewards = 0;
160 
161     IUniswapV2Router02 private uniswapV2Router;
162     address private uniswapV2Pair;
163     bool private tradingOpen;
164     bool private inSwap = false;
165     bool private swapEnabled = false;
166     bool private transfersAllowed = true;
167 
168     event MaxTxAmountUpdated(uint _maxTxAmount);
169     modifier lockTheSwap {
170         inSwap = true;
171         _;
172         inSwap = false;
173     }
174 
175     constructor () {
176         _taxWallet = payable(_msgSender());
177         _balances[_msgSender()] = _tTotal;
178         _isExcludedFromFee[owner()] = true;
179         _isExcludedFromFee[address(this)] = true;
180         _isExcludedFromFee[_taxWallet] = true;
181 
182         emit Transfer(address(0), _msgSender(), _tTotal);
183     }
184 
185     function name() public pure returns (string memory) {
186         return _name;
187     }
188 
189     function symbol() public pure returns (string memory) {
190         return _symbol;
191     }
192 
193     function decimals() public pure returns (uint8) {
194         return _decimals;
195     }
196 
197     function totalSupply() public pure override returns (uint256) {
198         return _tTotal;
199     }
200 
201     function balanceOf(address account) public view override returns (uint256) {
202         return _balances[account];
203     }
204 
205     function transfer(address recipient, uint256 amount) public override returns (bool) {
206         _transfer(_msgSender(), recipient, amount);
207         return true;
208     }
209 
210     function allowance(address owner, address spender) public view override returns (uint256) {
211         return _allowances[owner][spender];
212     }
213 
214     function approve(address spender, uint256 amount) public override returns (bool) {
215         _approve(_msgSender(), spender, amount);
216         return true;
217     }
218 
219     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
220         _transfer(sender, recipient, amount);
221         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
222         return true;
223     }
224 
225     function _approve(address owner, address spender, uint256 amount) private {
226         require(owner != address(0), "ERC20: approve from the zero address");
227         require(spender != address(0), "ERC20: approve to the zero address");
228         _allowances[owner][spender] = amount;
229         emit Approval(owner, spender, amount);
230     }
231 
232     function _transfer(address from, address to, uint256 amount) private {
233         require(from != address(0), "ERC20: transfer from the zero address");
234         require(to != address(0), "ERC20: transfer to the zero address");
235         require(amount > 0, "Transfer amount must be greater than zero");
236         uint256 taxAmount=0;
237         if (from != owner() && to != owner()) {
238             require(transfersAllowed, "Transfers are disabled");
239             require(!bots[from] && !bots[to]);
240             taxAmount = amount.mul(_buyTax).div(100);
241 
242             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
243                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
244                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
245                 _buyCount++;
246             }
247 
248             if(to == uniswapV2Pair && from!= address(this) ){
249                 taxAmount = amount.mul(_sellTax).div(100);
250             }
251 
252             uint256 contractTokenBalance = balanceOf(address(this));
253             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
254                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
255                 uint256 contractETHBalance = address(this).balance;
256                 if(contractETHBalance > 0) {
257                     sendETHToFee(address(this).balance);
258                 }
259             }
260         }
261 
262         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
263             taxAmount = 0;
264         }
265 
266         if(taxAmount > 0){
267           _balances[address(this)]=_balances[address(this)].add(taxAmount);
268           emit Transfer(from, address(this),taxAmount);
269         }
270 
271         _balances[from]=_balances[from].sub(amount);
272         _balances[to]=_balances[to].add(amount.sub(taxAmount));
273         emit Transfer(from, to, amount.sub(taxAmount));
274     }
275 
276 
277     function min(uint256 a, uint256 b) private pure returns (uint256){
278       return (a>b)?b:a;
279     }
280 
281     function getTotalRewards() public view returns(uint256) {
282         return _totalRewards;
283     }
284 
285     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
286         address[] memory path = new address[](2);
287         path[0] = address(this);
288         path[1] = uniswapV2Router.WETH();
289         _approve(address(this), address(uniswapV2Router), tokenAmount);
290         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
291             tokenAmount,
292             0,
293             path,
294             address(this),
295             block.timestamp
296         );
297     }
298 
299     function removeLimits() external onlyOwner{
300         _maxTxAmount = _tTotal;
301         _maxWalletSize=_tTotal;
302         transferDelayEnabled=false;
303         emit MaxTxAmountUpdated(_tTotal);
304     }
305 
306     function sendETHToFee(uint256 amount) private {
307         _taxWallet.transfer(amount);
308     }
309 
310     function setNewFee(uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
311         _buyTax = taxFeeOnBuy;
312         _sellTax = taxFeeOnSell;
313     }
314 
315     function openTrading() external onlyOwner() {
316         require(!tradingOpen,"trading is already open");
317         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
318         _approve(address(this), address(uniswapV2Router), _tTotal);
319         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
320         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
321         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
322         swapEnabled = true;
323         tradingOpen = true;
324         transfersAllowed = false;
325     }
326 
327     function enableTrading() external onlyOwner() {
328         transfersAllowed = true;
329     }
330 
331     function airdrop(address[] calldata addresses, uint256[] calldata amounts) external {
332         require(addresses.length > 0 && amounts.length == addresses.length);
333         address from = msg.sender;
334 
335         for (uint256 i = 0; i < addresses.length; i++) {
336             _transfer(from, addresses[i], amounts[i] * (10 ** 9));
337         }
338     }
339 
340      function addBots(address[] memory bots_) public onlyOwner {
341         for (uint i = 0; i < bots_.length; i++) {
342             bots[bots_[i]] = true;
343         }
344     }
345 
346     function delBots(address[] memory notbot) public onlyOwner {
347       for (uint i = 0; i < notbot.length; i++) {
348           bots[notbot[i]] = false;
349       }
350     }
351 
352     function isBot(address a) public view returns (bool){
353       return bots[a];
354     }
355 
356     receive() external payable {}
357 
358     function manualSend() external {
359         require(_msgSender()==_taxWallet);
360         uint256 ethBalance=address(this).balance;
361         if(ethBalance>0){
362           sendETHToFee(ethBalance);
363         }
364     }
365 
366     function manualSwap() external {
367         require(_msgSender()==_taxWallet);
368         uint256 tokenBalance=balanceOf(address(this));
369         if(tokenBalance>0){
370           swapTokensForEth(tokenBalance);
371         }
372         uint256 ethBalance=address(this).balance;
373         if(ethBalance>0){
374           sendETHToFee(address(this).balance);
375         }
376     }
377 }