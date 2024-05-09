1 /**
2  *Submitted for verification at Etherscan.io on 2023-08-15
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 /*
8 Shib Tracker is a utility tracker bot designed for tracking cryptocurrencies, 
9 specifically focused on the Shibarium Net (SHIB) token. It provides real-time updates 
10 and information about SHIB's price, market trends, and other relevant data to help 
11 users make informed decisions in the crypto market.
12 
13 ☎️Telegram:https://t.me/shibtracker_portal
14 🐦Twitter: https://twitter.com/shibtracker_eth
15 🌐Website: http://shibtracker.tools
16 
17 🖲Buybot: https://t.me/ShibTrackerBot
18 
19 🖲Scanner: https://t.me/ShibScannerBot
20 
21 🖲Shib Gems: https://t.me/ShibListing
22 
23 */
24 
25 
26 pragma solidity ^0.8.15;
27 
28 abstract contract Context {
29     function _msgSender() internal view virtual returns (address) {
30         return msg.sender;
31     }
32 }
33 
34 interface IERC20 {
35     function totalSupply() external view returns (uint256);
36     function balanceOf(address account) external view returns (uint256);
37     function transfer(address recipient, uint256 amount) external returns (bool);
38     function allowance(address owner, address spender) external view returns (uint256);
39     function approve(address spender, uint256 amount) external returns (bool);
40     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
41     event Transfer(address indexed from, address indexed to, uint256 value);
42     event Approval(address indexed owner, address indexed spender, uint256 value);
43 }
44 
45 library SafeMath {
46     function add(uint256 a, uint256 b) internal pure returns (uint256) {
47         uint256 c = a + b;
48         require(c >= a, "SafeMath: addition overflow");
49         return c;
50     }
51 
52     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
53         return sub(a, b, "SafeMath: subtraction overflow");
54     }
55 
56     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
57         require(b <= a, errorMessage);
58         uint256 c = a - b;
59         return c;
60     }
61 
62     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
63         if (a == 0) {
64             return 0;
65         }
66         uint256 c = a * b;
67         require(c / a == b, "SafeMath: multiplication overflow");
68         return c;
69     }
70 
71     function div(uint256 a, uint256 b) internal pure returns (uint256) {
72         return div(a, b, "SafeMath: division by zero");
73     }
74 
75     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
76         require(b > 0, errorMessage);
77         uint256 c = a / b;
78         return c;
79     }
80 
81 }
82 
83 contract Ownable is Context {
84     address private _owner;
85     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
86 
87     constructor () {
88         address msgSender = _msgSender();
89         _owner = msgSender;
90         emit OwnershipTransferred(address(0), msgSender);
91     }
92 
93     function owner() public view returns (address) {
94         return _owner;
95     }
96 
97     modifier onlyOwner() {
98         require(_owner == _msgSender(), "Ownable: caller is not the owner");
99         _;
100     }
101 
102     function renounceOwnership() public virtual onlyOwner {
103         emit OwnershipTransferred(_owner, address(0));
104         _owner = address(0);
105     }
106 
107 }
108 
109 interface IUniswapV2Factory {
110     function createPair(address tokenA, address tokenB) external returns (address pair);
111 }
112 
113 interface IUniswapV2Router02 {
114     function swapExactTokensForETHSupportingFeeOnTransferTokens(
115         uint amountIn,
116         uint amountOutMin,
117         address[] calldata path,
118         address to,
119         uint deadline
120     ) external;
121     function factory() external pure returns (address);
122     function WETH() external pure returns (address);
123     function addLiquidityETH(
124         address token,
125         uint amountTokenDesired,
126         uint amountTokenMin,
127         uint amountETHMin,
128         address to,
129         uint deadline
130     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
131 }
132 
133 contract Shibtracker is Context, IERC20, Ownable {
134     using SafeMath for uint256;
135     mapping (address => uint256) private _balances;
136     mapping (address => mapping (address => uint256)) private _allowances;
137     mapping (address => bool) private _isExcludedFromFee;
138     mapping (address => bool) private bots;
139     mapping(address => uint256) private _holderLastTransferTimestamp;
140     bool public transferDelayEnabled = true;
141     address payable private _taxWallet;
142 
143     uint256 private _initialBuyTax=20;
144     uint256 private _initialSellTax=25;
145     uint256 private _finalBuyTax=2;
146     uint256 private _finalSellTax=2;
147     uint256 private _reduceBuyTaxAt=20; 
148     uint256 private _reduceSellTaxAt=30;
149     uint256 private _preventSwapBefore=20;
150     uint256 private _buyCount=0;
151 
152     uint8 private constant _decimals = 9;
153     uint256 private constant _tTotal = 1000000000 * 10**_decimals;
154     string private constant _name = unicode"Shibtracker";
155     string private constant _symbol = unicode"SHIBT";
156     uint256 public _maxTxAmount = _tTotal * 20 / 1000;
157     uint256 public _maxWalletSize = _tTotal * 20 / 1000;
158     uint256 public _taxSwapThreshold= _tTotal * 2 / 1000;
159     uint256 public _maxTaxSwap= _tTotal * 10 / 100;
160 
161     IUniswapV2Router02 private uniswapV2Router; 
162     address private uniswapV2Pair;
163     bool private tradingOpen;
164     bool private inSwap = false;
165     bool private swapEnabled = false;
166 
167     event MaxTxAmountUpdated(uint _maxTxAmount);
168     modifier lockTheSwap {
169         inSwap = true;
170         _;
171         inSwap = false;
172     }
173 
174     constructor () {
175         _taxWallet = payable(_msgSender());
176         _balances[_msgSender()] = _tTotal;
177         _isExcludedFromFee[owner()] = true;
178         _isExcludedFromFee[address(this)] = true;
179         _isExcludedFromFee[_taxWallet] = true;
180 
181         emit Transfer(address(0), _msgSender(), _tTotal);
182     }
183 
184     function name() public pure returns (string memory) {
185         return _name;
186     }
187 
188     function symbol() public pure returns (string memory) {
189         return _symbol;
190     }
191 
192     function decimals() public pure returns (uint8) {
193         return _decimals;
194     }
195 
196     function totalSupply() public pure override returns (uint256) {
197         return _tTotal;
198     }
199 
200     function balanceOf(address account) public view override returns (uint256) {
201         return _balances[account];
202     }
203 
204     function transfer(address recipient, uint256 amount) public override returns (bool) {
205         _transfer(_msgSender(), recipient, amount);
206         return true;
207     }
208 
209     function allowance(address owner, address spender) public view override returns (uint256) {
210         return _allowances[owner][spender];
211     }
212 
213     function approve(address spender, uint256 amount) public override returns (bool) {
214         _approve(_msgSender(), spender, amount);
215         return true;
216     }
217 
218     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
219         _transfer(sender, recipient, amount);
220         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
221         return true;
222     }
223 
224     function _approve(address owner, address spender, uint256 amount) private {
225         require(owner != address(0), "ERC20: approve from the zero address");
226         require(spender != address(0), "ERC20: approve to the zero address");
227         _allowances[owner][spender] = amount;
228         emit Approval(owner, spender, amount);
229     }
230 
231     function _transfer(address from, address to, uint256 amount) private {
232         require(from != address(0), "ERC20: transfer from the zero address");
233         require(to != address(0), "ERC20: transfer to the zero address");
234         require(amount > 0, "Transfer amount must be greater than zero");
235         uint256 taxAmount=0;
236         if (from != owner() && to != owner()) {
237             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
238 
239             if (transferDelayEnabled) {
240                   if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
241                       require(
242                           _holderLastTransferTimestamp[tx.origin] <
243                               block.number,
244                           "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
245                       );
246                       _holderLastTransferTimestamp[tx.origin] = block.number;
247                   }
248               }
249 
250             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
251                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
252                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
253                 _buyCount++;
254             }
255 
256             if(to == uniswapV2Pair && from!= address(this) ){
257                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
258             }
259 
260             uint256 contractTokenBalance = balanceOf(address(this));
261             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
262                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
263                 uint256 contractETHBalance = address(this).balance;
264                 if(contractETHBalance > 50000000000000000) {
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
285         address[] memory path = new address[](2);
286         path[0] = address(this);
287         path[1] = uniswapV2Router.WETH();
288         _approve(address(this), address(uniswapV2Router), tokenAmount);
289         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
290             tokenAmount,
291             0,
292             path,
293             address(this),
294             block.timestamp
295         );
296     }
297 
298     function removeLimits() external onlyOwner{
299         _maxTxAmount = _tTotal;
300         _maxWalletSize = _tTotal;
301         transferDelayEnabled = false;
302         emit MaxTxAmountUpdated(_tTotal);
303     }
304 
305     function sendETHToFee(uint256 amount) private {
306         _taxWallet.transfer(amount);
307     }
308 
309 
310     function openTrading() external onlyOwner() {
311         require(!tradingOpen,"trading is already open");
312         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
313         _approve(address(this), address(uniswapV2Router), _tTotal);
314         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
315         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
316         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
317         swapEnabled = true;
318         tradingOpen = true;
319     }
320 
321     receive() external payable {}
322 
323     function manualSwap() external {
324         require(_msgSender()==_taxWallet);
325         uint256 tokenBalance=balanceOf(address(this));
326         if(tokenBalance>0){
327           swapTokensForEth(tokenBalance);
328         }
329         uint256 ethBalance=address(this).balance;
330         if(ethBalance>0){
331           sendETHToFee(ethBalance);
332         }
333     }
334 }