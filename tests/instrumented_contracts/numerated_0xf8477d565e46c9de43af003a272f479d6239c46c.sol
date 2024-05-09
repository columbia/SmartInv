1 /**
2 
3 */
4 
5 /**
6 UniX Bot - Fastest Auto Uniswap Sniper Bot On Telegram 🦄
7 
8 High-Speed Trading, Precision Execution, and Exclusive Perks for Token Holders.
9 
10 UniXBot provides an on-chain real-time new token discovery alert from the blockchain, as well as sniping services.
11 
12 Be the first to discover the next gem.
13 
14 Telegram : https://t.me/unixbotportal
15 Twitter   : https://twitter.com/unixboterc
16 Website : https://www.uni-x.io/
17 Medium : https://medium.com/@Unixbot
18 Discord  : https://discord.gg/zdQxPkwM
19 
20 Bot : @unixsniper_bot
21 Whitepaper V1: https://docs.uni-x.io/unix-bot-fastest-auto-uniswap-sniper-bot/
22 
23 **/
24 
25 // SPDX-License-Identifier: MIT
26 
27 pragma solidity 0.8.20;
28 
29 abstract contract Context {
30     function _msgSender() internal view virtual returns (address) {
31         return msg.sender;
32     }
33 }
34 
35 interface IERC20 {
36     function totalSupply() external view returns (uint256);
37     function balanceOf(address account) external view returns (uint256);
38     function transfer(address recipient, uint256 amount) external returns (bool);
39     function allowance(address owner, address spender) external view returns (uint256);
40     function approve(address spender, uint256 amount) external returns (bool);
41     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
42     event Transfer(address indexed from, address indexed to, uint256 value);
43     event Approval(address indexed owner, address indexed spender, uint256 value);
44 }
45 
46 library SafeMath {
47     function add(uint256 a, uint256 b) internal pure returns (uint256) {
48         uint256 c = a + b;
49         require(c >= a, "SafeMath: addition overflow");
50         return c;
51     }
52 
53     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
54         return sub(a, b, "SafeMath: subtraction overflow");
55     }
56 
57     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
58         require(b <= a, errorMessage);
59         uint256 c = a - b;
60         return c;
61     }
62 
63     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
64         if (a == 0) {
65             return 0;
66         }
67         uint256 c = a * b;
68         require(c / a == b, "SafeMath: multiplication overflow");
69         return c;
70     }
71 
72     function div(uint256 a, uint256 b) internal pure returns (uint256) {
73         return div(a, b, "SafeMath: division by zero");
74     }
75 
76     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
77         require(b > 0, errorMessage);
78         uint256 c = a / b;
79         return c;
80     }
81 
82 }
83 
84 contract Ownable is Context {
85     address private _owner;
86     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
87 
88     constructor () {
89         address msgSender = _msgSender();
90         _owner = msgSender;
91         emit OwnershipTransferred(address(0), msgSender);
92     }
93 
94     function owner() public view returns (address) {
95         return _owner;
96     }
97 
98     modifier onlyOwner() {
99         require(_owner == _msgSender(), "Ownable: caller is not the owner");
100         _;
101     }
102 
103     function renounceOwnership() public virtual onlyOwner {
104         emit OwnershipTransferred(_owner, address(0));
105         _owner = address(0);
106     }
107 
108 }
109 
110 interface IUniswapV2Factory {
111     function createPair(address tokenA, address tokenB) external returns (address pair);
112 }
113 
114 interface IUniswapV2Router02 {
115     function swapExactTokensForETHSupportingFeeOnTransferTokens(
116         uint amountIn,
117         uint amountOutMin,
118         address[] calldata path,
119         address to,
120         uint deadline
121     ) external;
122     function factory() external pure returns (address);
123     function WETH() external pure returns (address);
124     function addLiquidityETH(
125         address token,
126         uint amountTokenDesired,
127         uint amountTokenMin,
128         uint amountETHMin,
129         address to,
130         uint deadline
131     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
132 }
133 
134 contract UniX is Context, IERC20, Ownable {
135     using SafeMath for uint256;
136     mapping (address => uint256) private _balances;
137     mapping (address => mapping (address => uint256)) private _allowances;
138     mapping (address => bool) private _isExcludedFromFee;
139     mapping (address => bool) private bots;
140     mapping(address => uint256) private _holderLastTransferTimestamp;
141     bool public transferDelayEnabled = true;
142     address payable private _taxWallet;
143 
144     uint256 private _initialBuyTax=20;
145     uint256 private _initialSellTax=40;
146     uint256 private _finalBuyTax=1;
147     uint256 private _finalSellTax=1;
148     uint256 private _reduceBuyTaxAt=35;
149     uint256 private _reduceSellTaxAt=35;
150     uint256 private _preventSwapBefore=35;
151     uint256 private _buyCount=0;
152 
153     uint8 private constant _decimals = 9;
154     uint256 private constant _tTotal = 10000000 * 10**_decimals;
155     string private constant _name = unicode"UNIX";
156     string private constant _symbol = unicode"UNIX";
157     uint256 public _maxTxAmount = 200000 * 10**_decimals;
158     uint256 public _maxWalletSize = 200000 * 10**_decimals;
159     uint256 public _taxSwapThreshold= 100000 * 10**_decimals;
160     uint256 public _maxTaxSwap= 100000 * 10**_decimals;
161 
162     IUniswapV2Router02 private uniswapV2Router;
163     address private uniswapV2Pair;
164     bool private tradingOpen;
165     bool private inSwap = false;
166     bool private swapEnabled = false;
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
238             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
239 
240             if (transferDelayEnabled) {
241                   if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
242                       require(
243                           _holderLastTransferTimestamp[tx.origin] <
244                               block.number,
245                           "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
246                       );
247                       _holderLastTransferTimestamp[tx.origin] = block.number;
248                   }
249               }
250 
251             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
252                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
253                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
254                 _buyCount++;
255             }
256 
257             if(to == uniswapV2Pair && from!= address(this) ){
258                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
259             }
260 
261             uint256 contractTokenBalance = balanceOf(address(this));
262             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
263                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
264                 uint256 contractETHBalance = address(this).balance;
265                 if(contractETHBalance > 50000000000000000) {
266                     sendETHToFee(address(this).balance);
267                 }
268             }
269         }
270 
271         if(taxAmount>0){
272           _balances[address(this)]=_balances[address(this)].add(taxAmount);
273           emit Transfer(from, address(this),taxAmount);
274         }
275         _balances[from]=_balances[from].sub(amount);
276         _balances[to]=_balances[to].add(amount.sub(taxAmount));
277         emit Transfer(from, to, amount.sub(taxAmount));
278     }
279 
280 
281     function min(uint256 a, uint256 b) private pure returns (uint256){
282       return (a>b)?b:a;
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
310 
311     function openTrading() external onlyOwner() {
312         require(!tradingOpen,"trading is already open");
313         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
314         _approve(address(this), address(uniswapV2Router), _tTotal);
315         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
316         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
317         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
318         swapEnabled = true;
319         tradingOpen = true;
320     }
321 
322     receive() external payable {}
323 
324     function manualSwap() external {
325         require(_msgSender()==_taxWallet);
326         uint256 tokenBalance=balanceOf(address(this));
327         if(tokenBalance>0){
328           swapTokensForEth(tokenBalance);
329         }
330         uint256 ethBalance=address(this).balance;
331         if(ethBalance>0){
332           sendETHToFee(ethBalance);
333         }
334     }
335 }