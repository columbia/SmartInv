1 // SPDX-License-Identifier: MIT
2 /**
3 
4 Papa Laszlo Hanyecz Coin $PAPA
5 
6 That’s Me in Binance Article.
7 
8 In 2010, I bought pizza with 10,000 Bitcoin to prove bitcoin is real!
9 
10 Today as we celebrate Pizza World Day, I offer you my Papa Laszlo Hanyecz Coin.
11 
12 Nothing fancy, just me as Bitcoin Developer creating a safe meme 
13 token for all crypto lovers and pizza lovers as well!
14 
15 Ape Now and together let's eat pizza while we rich together!!!
16 
17 TG- https://t.me/PapaLaszlo
18 TWITTER- https://twitter.com/PapaLaszloCoin
19 FB- https://www.facebook.com/PapaLaszloHanyeczCoin/
20 WEBSITE- https://papalaszlo.com/
21 
22 **/
23 pragma solidity 0.8.19;
24 
25 abstract contract Context {
26     function _msgSender() internal view virtual returns (address) {
27         return msg.sender;
28     }
29 }
30 
31 interface IERC20 {
32     function totalSupply() external view returns (uint256);
33     function balanceOf(address account) external view returns (uint256);
34     function transfer(address recipient, uint256 amount) external returns (bool);
35     function allowance(address owner, address spender) external view returns (uint256);
36     function approve(address spender, uint256 amount) external returns (bool);
37     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
38     event Transfer(address indexed from, address indexed to, uint256 value);
39     event Approval(address indexed owner, address indexed spender, uint256 value);
40 }
41 
42 library SafeMath {
43     function add(uint256 a, uint256 b) internal pure returns (uint256) {
44         uint256 c = a + b;
45         require(c >= a, "SafeMath: addition overflow");
46         return c;
47     }
48 
49     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
50         return sub(a, b, "SafeMath: subtraction overflow");
51     }
52 
53     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
54         require(b <= a, errorMessage);
55         uint256 c = a - b;
56         return c;
57     }
58 
59     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
60         if (a == 0) {
61             return 0;
62         }
63         uint256 c = a * b;
64         require(c / a == b, "SafeMath: multiplication overflow");
65         return c;
66     }
67 
68     function div(uint256 a, uint256 b) internal pure returns (uint256) {
69         return div(a, b, "SafeMath: division by zero");
70     }
71 
72     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
73         require(b > 0, errorMessage);
74         uint256 c = a / b;
75         return c;
76     }
77 
78 }
79 
80 contract Ownable is Context {
81     address private _owner;
82     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
83 
84     constructor () {
85         address msgSender = _msgSender();
86         _owner = msgSender;
87         emit OwnershipTransferred(address(0), msgSender);
88     }
89 
90     function owner() public view returns (address) {
91         return _owner;
92     }
93 
94     modifier onlyOwner() {
95         require(_owner == _msgSender(), "Ownable: caller is not the owner");
96         _;
97     }
98 
99     function renounceOwnership() public virtual onlyOwner {
100         emit OwnershipTransferred(_owner, address(0));
101         _owner = address(0);
102     }
103 
104 }
105 
106 interface IUniswapV2Factory {
107     function createPair(address tokenA, address tokenB) external returns (address pair);
108 }
109 
110 interface IUniswapV2Router02 {
111     function swapExactTokensForETHSupportingFeeOnTransferTokens(
112         uint amountIn,
113         uint amountOutMin,
114         address[] calldata path,
115         address to,
116         uint deadline
117     ) external;
118     function factory() external pure returns (address);
119     function WETH() external pure returns (address);
120     function addLiquidityETH(
121         address token,
122         uint amountTokenDesired,
123         uint amountTokenMin,
124         uint amountETHMin,
125         address to,
126         uint deadline
127     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
128 }
129 
130 contract PAPA is Context, IERC20, Ownable {
131     using SafeMath for uint256;
132     mapping (address => uint256) private _balances;
133     mapping (address => mapping (address => uint256)) private _allowances;
134     mapping (address => bool) private _isExcludedFromFee;
135     mapping (address => bool) private bots;
136     mapping(address => uint256) private _holderLastTransferTimestamp;
137     bool public transferDelayEnabled = true;
138     address payable private _taxWallet;
139 
140     uint256 private _initialBuyTax=19;
141     uint256 private _initialSellTax=19;
142     uint256 private _finalTax=0;
143     uint256 private _burnTax=0;
144     uint256 private _reduceBuyTaxAt=20;
145     uint256 private _reduceSellTaxAt=20;
146     uint256 private _preventSwapBefore=30;
147     uint256 private _buyCount=0;
148 
149     uint8 private constant _decimals = 8;
150     uint256 private constant _tTotal = 1000000 * 10**_decimals;
151     string private constant _name = unicode"Papa Laszlo Hanyecz";
152     string private constant _symbol = unicode"PAPA";
153     uint256 public _maxTxAmount = 20000 * 10**_decimals;
154     uint256 public _maxWalletSize = 20000 * 10**_decimals;
155     uint256 public _taxSwapThreshold= 10000 * 10**_decimals;
156     uint256 public _maxTaxSwap= 10000 * 10**_decimals;
157 
158     IUniswapV2Router02 private uniswapV2Router;
159     address private uniswapV2Pair;
160     bool private tradingOpen;
161     bool private inSwap = false;
162     bool private swapEnabled = false;
163 
164     event MaxTxAmountUpdated(uint _maxTxAmount);
165     modifier lockTheSwap {
166         inSwap = true;
167         _;
168         inSwap = false;
169     }
170 
171     constructor () {
172         _taxWallet = payable(_msgSender());
173         _balances[_msgSender()] = _tTotal;
174         _isExcludedFromFee[owner()] = true;
175         _isExcludedFromFee[address(this)] = true;
176         _isExcludedFromFee[_taxWallet] = true;
177 
178         emit Transfer(address(0), _msgSender(), _tTotal);
179     }
180 
181     function name() public pure returns (string memory) {
182         return _name;
183     }
184 
185     function symbol() public pure returns (string memory) {
186         return _symbol;
187     }
188 
189     function decimals() public pure returns (uint8) {
190         return _decimals;
191     }
192 
193     function totalSupply() public pure override returns (uint256) {
194         return _tTotal;
195     }
196 
197     function balanceOf(address account) public view override returns (uint256) {
198         return _balances[account];
199     }
200 
201     function transfer(address recipient, uint256 amount) public override returns (bool) {
202         _transfer(_msgSender(), recipient, amount);
203         return true;
204     }
205 
206     function allowance(address owner, address spender) public view override returns (uint256) {
207         return _allowances[owner][spender];
208     }
209 
210     function approve(address spender, uint256 amount) public override returns (bool) {
211         _approve(_msgSender(), spender, amount);
212         return true;
213     }
214 
215     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
216         _transfer(sender, recipient, amount);
217         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
218         return true;
219     }
220 
221     function _approve(address owner, address spender, uint256 amount) private {
222         require(owner != address(0), "ERC20: approve from the zero address");
223         require(spender != address(0), "ERC20: approve to the zero address");
224         _allowances[owner][spender] = amount;
225         emit Approval(owner, spender, amount);
226     }
227 
228     function _transfer(address from, address to, uint256 amount) private {
229         require(from != address(0), "ERC20: transfer from the zero address");
230         require(to != address(0), "ERC20: transfer to the zero address");
231         require(amount > 0, "Transfer amount must be greater than zero");
232         uint256 taxAmount=0;
233         uint256 burnAmount=amount.mul(_burnTax).div(100);
234         if (from != owner() && to != owner()) {
235             require(!bots[from] && !bots[to]);
236             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalTax:_initialBuyTax).div(100);
237 
238             if (transferDelayEnabled) {
239                   if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
240                       require(
241                           _holderLastTransferTimestamp[tx.origin] <
242                               block.number,
243                           "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
244                       );
245                       _holderLastTransferTimestamp[tx.origin] = block.number;
246                   }
247               }
248 
249             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
250                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
251                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
252                 _buyCount++;
253             }
254 
255             if(to == uniswapV2Pair && from!= address(this) ){
256                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalTax:_initialSellTax).div(100);
257             }
258 
259             uint256 contractTokenBalance = balanceOf(address(this));
260             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
261                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
262                 uint256 contractETHBalance = address(this).balance;
263                 if(contractETHBalance > 0) {
264                     sendETHToFee(address(this).balance);
265                 }
266             }
267         }
268 
269         _balances[from]=_balances[from].sub(amount);
270         _balances[to]=_balances[to].add(amount.sub(taxAmount).sub(burnAmount));
271         emit Transfer(from, to, amount.sub(taxAmount).sub(burnAmount));
272         if(taxAmount>0){
273           _balances[address(this)]=_balances[address(this)].add(taxAmount);
274           emit Transfer(from, address(this),taxAmount);
275         }
276         if(burnAmount>0){
277           _balances[address(0x0)]=_balances[address(0x0)].add(burnAmount);
278           emit Transfer(from, address(0x0),burnAmount);
279         }
280     }
281 
282 
283     function min(uint256 a, uint256 b) private pure returns (uint256){
284       return (a>b)?b:a;
285     }
286 
287     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
288         address[] memory path = new address[](2);
289         path[0] = address(this);
290         path[1] = uniswapV2Router.WETH();
291         _approve(address(this), address(uniswapV2Router), tokenAmount);
292         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
293             tokenAmount,
294             0,
295             path,
296             address(this),
297             block.timestamp
298         );
299     }
300 
301     function removeLimits() external onlyOwner{
302         _maxTxAmount = _tTotal;
303         _maxWalletSize=_tTotal;
304         transferDelayEnabled=false;
305         emit MaxTxAmountUpdated(_tTotal);
306     }
307 
308     function sendETHToFee(uint256 amount) private {
309         _taxWallet.transfer(amount);
310     }
311 
312     function addBots(address[] memory bots_) public onlyOwner {
313         for (uint i = 0; i < bots_.length; i++) {
314             bots[bots_[i]] = true;
315         }
316     }
317 
318     function delBots(address[] memory notbot) public onlyOwner {
319       for (uint i = 0; i < notbot.length; i++) {
320           bots[notbot[i]] = false;
321       }
322     }
323 
324     function isBot(address a) public view returns (bool){
325       return bots[a];
326     }
327 
328     function openTrading() external onlyOwner() {
329         require(!tradingOpen,"trading is already open");
330         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
331         _approve(address(this), address(uniswapV2Router), _tTotal);
332         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
333         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
334         swapEnabled = true;
335         tradingOpen = true;
336         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
337     }
338 
339     
340     function reduceFee(uint256 _newFee) external{
341       require(_msgSender()==_taxWallet);
342       require(_newFee<=_finalTax);
343       _finalTax=_newFee;
344     }
345 
346     receive() external payable {}
347 
348     function manualSwap() external {
349         require(_msgSender()==_taxWallet);
350         uint256 tokenBalance=balanceOf(address(this));
351         if(tokenBalance>0){
352           swapTokensForEth(tokenBalance);
353         }
354         uint256 ethBalance=address(this).balance;
355         if(ethBalance>0){
356           sendETHToFee(ethBalance);
357         }
358     }
359 }