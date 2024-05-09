1 /**
2  *
3 */
4 
5 /**
6 
7 Socials:
8 The ticker : $DREAMS
9 
10 Telegram : https://t.me/DREAMSPORTAL
11 
12 X ✔️: https://x.com/DREAMSERC
13 
14 Website 🌍: https://dreams.tf/
15                             
16 
17 **/
18 // SPDX-License-Identifier: MIT
19 
20 
21 pragma solidity 0.8.20;
22 
23 abstract contract Context {
24     function _msgSender() internal view virtual returns (address) {
25         return msg.sender;
26     }
27 }
28 
29 interface IERC20 {
30     function totalSupply() external view returns (uint256);
31     function balanceOf(address account) external view returns (uint256);
32     function transfer(address recipient, uint256 amount) external returns (bool);
33     function allowance(address owner, address spender) external view returns (uint256);
34     function approve(address spender, uint256 amount) external returns (bool);
35     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
36     event Transfer(address indexed from, address indexed to, uint256 value);
37     event Approval(address indexed owner, address indexed spender, uint256 value);
38 }
39 
40 library SafeMath {
41     function add(uint256 a, uint256 b) internal pure returns (uint256) {
42         uint256 c = a + b;
43         require(c >= a, "SafeMath: addition overflow");
44         return c;
45     }
46 
47     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
48         return sub(a, b, "SafeMath: subtraction overflow");
49     }
50 
51     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
52         require(b <= a, errorMessage);
53         uint256 c = a - b;
54         return c;
55     }
56 
57     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
58         if (a == 0) {
59             return 0;
60         }
61         uint256 c = a * b;
62         require(c / a == b, "SafeMath: multiplication overflow");
63         return c;
64     }
65 
66     function div(uint256 a, uint256 b) internal pure returns (uint256) {
67         return div(a, b, "SafeMath: division by zero");
68     }
69 
70     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
71         require(b > 0, errorMessage);
72         uint256 c = a / b;
73         return c;
74     }
75 
76 }
77 
78 contract Ownable is Context {
79     address private _owner;
80     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
81 
82     constructor () {
83         address msgSender = _msgSender();
84         _owner = msgSender;
85         emit OwnershipTransferred(address(0), msgSender);
86     }
87 
88     function owner() public view returns (address) {
89         return _owner;
90     }
91 
92     modifier onlyOwner() {
93         require(_owner == _msgSender(), "Ownable: caller is not the owner");
94         _;
95     }
96 
97     function renounceOwnership() public virtual onlyOwner {
98         emit OwnershipTransferred(_owner, address(0));
99         _owner = address(0);
100     }
101 
102 }
103 
104 interface IUniswapV2Factory {
105     function createPair(address tokenA, address tokenB) external returns (address pair);
106 }
107 
108 interface IUniswapV2Router02 {
109     function swapExactTokensForETHSupportingFeeOnTransferTokens(
110         uint amountIn,
111         uint amountOutMin,
112         address[] calldata path,
113         address to,
114         uint deadline
115     ) external;
116     function factory() external pure returns (address);
117     function WETH() external pure returns (address);
118     function addLiquidityETH(
119         address token,
120         uint amountTokenDesired,
121         uint amountTokenMin,
122         uint amountETHMin,
123         address to,
124         uint deadline
125     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
126 }
127 
128 contract DREAMS is Context, IERC20, Ownable {
129     using SafeMath for uint256;
130     mapping (address => uint256) private _balances;
131     mapping (address => mapping (address => uint256)) private _allowances;
132     mapping (address => bool) private _isExcludedFromFee;
133     mapping (address => bool) private _buyerMap;
134     mapping (address => bool) private bots;
135     mapping(address => uint256) private _holderLastTransferTimestamp;
136     bool public transferDelayEnabled = false;
137     address payable private _taxWallet;
138 
139     uint256 private _initialBuyTax=20;
140     uint256 private _initialSellTax=20;
141     uint256 private _finalBuyTax=2;
142     uint256 private _finalSellTax=2;
143     uint256 private _reduceBuyTaxAt=19;
144     uint256 private _reduceSellTaxAt=30;
145     uint256 private _preventSwapBefore=30;
146     uint256 private _buyCount=0;
147 
148     uint8 private constant _decimals = 8;
149     uint256 private constant _tTotal = 7660270000 * 10**_decimals;
150     string private constant _name = unicode"Hello, I am an honest dev with honest problems. My life is caught in a spiral of misery, running in a hamster wheel of seeking dopamine in any form. Instead of resorting to smoking crack, which would ultimately shorten the pain of life, I started by trading futures and then ventured into the shitcoin market. Everything went smoothly; I made several hundred thousand dollars and was driven by the frenzy of the bull market. Now I have a gambling problem, or an addiction? Is it an addiction? No. It's a battle of life that I impose on myself and probability theory. I will catch myself 100,000 X, be sure of that. I'm cut out for the job. I'll launch a coin and free myself from the clutches of my suicidal thoughts. I just want positively charged dopamine, not the kind that comes from losing money while getting excited about it and squandering my mother's pension. But how can I manage to pump up this coin to nine or ten figures and make everyone rich in the process? I implore you, buy this coin and work hard, support the dev with love, otherwise he'll strangle himself wearing a Batman costume while pleasuring himself. So please buy this coin; it's important for the dev's well-being. The dev is working hard, give him a break and boost him up. HarryPotterObamaSonicPepeMilady, and now Dev Inu. Wow. We're all gonna make it. 1,000,000x. Soon to be rich at last. Then I'll leave behind my gambling life, raise children, and marry the woman who's been waiting for me for 5 years. This coin will make it. My blood, sweat, and tears. My DREAMS.";
151     string private constant _symbol = unicode"DREAMS";
152     uint256 public _maxTxAmount = 153205400 * 10**_decimals;
153     uint256 public _maxWalletSize = 153205400 * 10**_decimals;
154     uint256 public _taxSwapThreshold= 15320540 * 10**_decimals;
155     uint256 public _maxTaxSwap= 63205400 * 10**_decimals;
156 
157     IUniswapV2Router02 private uniswapV2Router;
158     address private uniswapV2Pair;
159     bool private tradingOpen;
160     bool private inSwap = false;
161     bool private swapEnabled = false;
162 
163     event MaxTxAmountUpdated(uint _maxTxAmount);
164     modifier lockTheSwap {
165         inSwap = true;
166         _;
167         inSwap = false;
168     }
169 
170     constructor () {
171         _taxWallet = payable(_msgSender());
172         _balances[_msgSender()] = _tTotal;
173         _isExcludedFromFee[owner()] = true;
174         _isExcludedFromFee[address(this)] = true;
175         _isExcludedFromFee[_taxWallet] = true;
176 
177         emit Transfer(address(0), _msgSender(), _tTotal);
178     }
179 
180     function name() public pure returns (string memory) {
181         return _name;
182     }
183 
184     function symbol() public pure returns (string memory) {
185         return _symbol;
186     }
187 
188     function decimals() public pure returns (uint8) {
189         return _decimals;
190     }
191 
192     function totalSupply() public pure override returns (uint256) {
193         return _tTotal;
194     }
195 
196     function balanceOf(address account) public view override returns (uint256) {
197         return _balances[account];
198     }
199 
200     function transfer(address recipient, uint256 amount) public override returns (bool) {
201         _transfer(_msgSender(), recipient, amount);
202         return true;
203     }
204 
205     function allowance(address owner, address spender) public view override returns (uint256) {
206         return _allowances[owner][spender];
207     }
208 
209     function approve(address spender, uint256 amount) public override returns (bool) {
210         _approve(_msgSender(), spender, amount);
211         return true;
212     }
213 
214     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
215         _transfer(sender, recipient, amount);
216         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
217         return true;
218     }
219 
220     function _approve(address owner, address spender, uint256 amount) private {
221         require(owner != address(0), "ERC20: approve from the zero address");
222         require(spender != address(0), "ERC20: approve to the zero address");
223         _allowances[owner][spender] = amount;
224         emit Approval(owner, spender, amount);
225     }
226 
227     function _transfer(address from, address to, uint256 amount) private {
228         require(from != address(0), "ERC20: transfer from the zero address");
229         require(to != address(0), "ERC20: transfer to the zero address");
230         require(amount > 0, "Transfer amount must be greater than zero");
231         uint256 taxAmount=0;
232         if (from != owner() && to != owner()) {
233             require(!bots[from] && !bots[to]);
234 
235             if (transferDelayEnabled) {
236                 if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
237                   require(_holderLastTransferTimestamp[tx.origin] < block.number,"Only one transfer per block allowed.");
238                   _holderLastTransferTimestamp[tx.origin] = block.number;
239                 }
240             }
241 
242             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
243                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
244                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
245                 if(_buyCount<_preventSwapBefore){
246                   require(!isContract(to));
247                 }
248                 _buyCount++;
249                 _buyerMap[to]=true;
250             }
251 
252 
253             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
254             if(to == uniswapV2Pair && from!= address(this) ){
255                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
256                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
257                 require(_buyCount>_preventSwapBefore || _buyerMap[from],"Seller is not buyer");
258             }
259 
260             uint256 contractTokenBalance = balanceOf(address(this));
261             if (!inSwap && to == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
262                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
263                 uint256 contractETHBalance = address(this).balance;
264                 if(contractETHBalance > 0) {
265                     sendETHToFee(address(this).balance);
266                 }
267             }
268         }
269 
270         if(taxAmount>0){
271           _balances[address(this)]=_balances[address(this)].add(taxAmount);
272           emit Transfer(from, address(this),taxAmount);
273         }
274         _balances[from]=_balances[from].sub(amount);
275         _balances[to]=_balances[to].add(amount.sub(taxAmount));
276         emit Transfer(from, to, amount.sub(taxAmount));
277     }
278 
279 
280     function min(uint256 a, uint256 b) private pure returns (uint256){
281       return (a>b)?b:a;
282     }
283 
284     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
285         if(tokenAmount==0){return;}
286         if(!tradingOpen){return;}
287         address[] memory path = new address[](2);
288         path[0] = address(this);
289         path[1] = uniswapV2Router.WETH();
290         _approve(address(this), address(uniswapV2Router), tokenAmount);
291         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
292             tokenAmount,
293             0,
294             path,
295             address(this),
296             block.timestamp
297         );
298     }
299 
300     function removeLimits() external onlyOwner{
301         _maxTxAmount = _tTotal;
302         _maxWalletSize=_tTotal;
303         transferDelayEnabled=false;
304         emit MaxTxAmountUpdated(_tTotal);
305     }
306 
307     function sendETHToFee(uint256 amount) private {
308         _taxWallet.transfer(amount);
309     }
310 
311     function isBot(address a) public view returns (bool){
312       return bots[a];
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
324     }
325 
326     receive() external payable {}
327 
328     function isContract(address account) private view returns (bool) {
329         uint256 size;
330         assembly {
331             size := extcodesize(account)
332         }
333         return size > 0;
334     }
335 
336     function manualSwap() external {
337         require(_msgSender()==_taxWallet);
338         uint256 tokenBalance=balanceOf(address(this));
339         if(tokenBalance>0){
340           swapTokensForEth(tokenBalance);
341         }
342         uint256 ethBalance=address(this).balance;
343         if(ethBalance>0){
344           sendETHToFee(ethBalance);
345         }
346     }
347 
348     
349     
350     
351 }