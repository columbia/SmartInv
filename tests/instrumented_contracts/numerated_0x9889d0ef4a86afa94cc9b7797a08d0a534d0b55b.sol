1 /**
2 
3 Gamified and Algorthmic Raffle System Developed on ETH
4 
5 How to Play Golden Ticket?
6 
7 Participants enter by purchasing $TICKET tokens, 
8 with a purchase offering a 1 in 10 chance to win a portion of the Golden Ticket prize pool. 
9 (80% of taxes go to the Golden Ticket Prize Pool!)
10 
11 Winners receive their winnings in ETH directly to their wallets, courtesy of our smart contract. 
12 Non-winners also receive an update, showing their potential winnings and the current prize pool.
13 
14 Join our Telegram 
15 
16 Golden Ticket | ETH 
17 https://t.me/goldenticket0x
18 
19 See our Golden Ticket system in action:
20 https://t.me/c/1914977884/533
21 
22 See your Ticket entries and previous top 10 Winners 
23 https://t.me/Golden_Ticket_0x_Bot
24 
25 Read our whitepaper for more details on how the Golden Ticket System works
26 https://wp.goldenticket0x.com/
27 
28 Visit our Website 
29 https://goldenticket0x.com
30 
31 Follow us on X
32 https://x.com/goldenticket0x
33 
34 **/
35 
36 // SPDX-License-Identifier: MIT
37 
38 
39 pragma solidity 0.8.20;
40 
41 abstract contract Context {
42     function _msgSender() internal view virtual returns (address) {
43         return msg.sender;
44     }
45 }
46 
47 interface IERC20 {
48     function totalSupply() external view returns (uint256);
49     function balanceOf(address account) external view returns (uint256);
50     function transfer(address recipient, uint256 amount) external returns (bool);
51     function allowance(address owner, address spender) external view returns (uint256);
52     function approve(address spender, uint256 amount) external returns (bool);
53     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
54     event Transfer(address indexed from, address indexed to, uint256 value);
55     event Approval(address indexed owner, address indexed spender, uint256 value);
56 }
57 
58 library SafeMath {
59     function add(uint256 a, uint256 b) internal pure returns (uint256) {
60         uint256 c = a + b;
61         require(c >= a, "SafeMath: addition overflow");
62         return c;
63     }
64 
65     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
66         return sub(a, b, "SafeMath: subtraction overflow");
67     }
68 
69     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
70         require(b <= a, errorMessage);
71         uint256 c = a - b;
72         return c;
73     }
74 
75     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
76         if (a == 0) {
77             return 0;
78         }
79         uint256 c = a * b;
80         require(c / a == b, "SafeMath: multiplication overflow");
81         return c;
82     }
83 
84     function div(uint256 a, uint256 b) internal pure returns (uint256) {
85         return div(a, b, "SafeMath: division by zero");
86     }
87 
88     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
89         require(b > 0, errorMessage);
90         uint256 c = a / b;
91         return c;
92     }
93 
94 }
95 
96 contract Ownable is Context {
97     address private _owner;
98     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
99 
100     constructor () {
101         address msgSender = _msgSender();
102         _owner = msgSender;
103         emit OwnershipTransferred(address(0), msgSender);
104     }
105 
106     function owner() public view returns (address) {
107         return _owner;
108     }
109 
110     modifier onlyOwner() {
111         require(_owner == _msgSender(), "Ownable: caller is not the owner");
112         _;
113     }
114 
115     function renounceOwnership() public virtual onlyOwner {
116         emit OwnershipTransferred(_owner, address(0));
117         _owner = address(0);
118     }
119 
120 }
121 
122 interface IUniswapV2Factory {
123     function createPair(address tokenA, address tokenB) external returns (address pair);
124 }
125 
126 interface IUniswapV2Router02 {
127     function swapExactTokensForETHSupportingFeeOnTransferTokens(
128         uint amountIn,
129         uint amountOutMin,
130         address[] calldata path,
131         address to,
132         uint deadline
133     ) external;
134     function factory() external pure returns (address);
135     function WETH() external pure returns (address);
136     function addLiquidityETH(
137         address token,
138         uint amountTokenDesired,
139         uint amountTokenMin,
140         uint amountETHMin,
141         address to,
142         uint deadline
143     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
144 }
145 
146 contract GoldenTicket is Context, IERC20, Ownable {
147     using SafeMath for uint256;
148     mapping (address => uint256) private _balances;
149     mapping (address => mapping (address => uint256)) private _allowances;
150     mapping (address => bool) private _isExcludedFromFee;
151     mapping(address => uint256) private _holderLastTransferTimestamp;
152     bool public transferDelayEnabled = true;
153     address payable private _taxWallet;
154 
155     uint256 private _initialBuyTax=20;
156     uint256 private _initialSellTax=20;
157     uint256 private _finalBuyTax=5;
158     uint256 private _finalSellTax=5;
159     uint256 private _reduceBuyTaxAt=50;
160     uint256 private _reduceSellTaxAt=30;
161     uint256 private _preventSwapBefore=30;
162     uint256 private _buyCount=0;
163 
164     uint8 private constant _decimals = 9;
165     uint256 private constant _tTotal = 1000000000 * 10**_decimals;
166     string private constant _name = unicode"Golden Ticket";
167     string private constant _symbol = unicode"TICKET";
168     uint256 public _maxTxAmount = 20000000 * 10**_decimals;
169     uint256 public _maxWalletSize = 20000000 * 10**_decimals;
170     uint256 public _taxSwapThreshold= 10000000 * 10**_decimals;
171     uint256 public _maxTaxSwap= 15000000 * 10**_decimals;
172 
173     IUniswapV2Router02 private uniswapV2Router;
174     address private uniswapV2Pair;
175     bool private tradingOpen;
176     bool private inSwap = false;
177     bool private swapEnabled = false;
178 
179     event MaxTxAmountUpdated(uint _maxTxAmount);
180     modifier lockTheSwap {
181         inSwap = true;
182         _;
183         inSwap = false;
184     }
185 
186     constructor () {
187         _taxWallet = payable(_msgSender());
188         _balances[_msgSender()] = _tTotal;
189         _isExcludedFromFee[owner()] = true;
190         _isExcludedFromFee[address(this)] = true;
191         _isExcludedFromFee[_taxWallet] = true;
192 
193         emit Transfer(address(0), _msgSender(), _tTotal);
194     }
195 
196     function name() public pure returns (string memory) {
197         return _name;
198     }
199 
200     function symbol() public pure returns (string memory) {
201         return _symbol;
202     }
203 
204     function decimals() public pure returns (uint8) {
205         return _decimals;
206     }
207 
208     function totalSupply() public pure override returns (uint256) {
209         return _tTotal;
210     }
211 
212     function balanceOf(address account) public view override returns (uint256) {
213         return _balances[account];
214     }
215 
216     function transfer(address recipient, uint256 amount) public override returns (bool) {
217         _transfer(_msgSender(), recipient, amount);
218         return true;
219     }
220 
221     function allowance(address owner, address spender) public view override returns (uint256) {
222         return _allowances[owner][spender];
223     }
224 
225     function approve(address spender, uint256 amount) public override returns (bool) {
226         _approve(_msgSender(), spender, amount);
227         return true;
228     }
229 
230     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
231         _transfer(sender, recipient, amount);
232         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
233         return true;
234     }
235 
236     function _approve(address owner, address spender, uint256 amount) private {
237         require(owner != address(0), "ERC20: approve from the zero address");
238         require(spender != address(0), "ERC20: approve to the zero address");
239         _allowances[owner][spender] = amount;
240         emit Approval(owner, spender, amount);
241     }
242 
243     function _transfer(address from, address to, uint256 amount) private {
244         require(from != address(0), "ERC20: transfer from the zero address");
245         require(to != address(0), "ERC20: transfer to the zero address");
246         require(amount > 0, "Transfer amount must be greater than zero");
247         uint256 taxAmount=0;
248         if (from != owner() && to != owner()) {
249             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
250 
251             if (transferDelayEnabled) {
252                   if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
253                       require(
254                           _holderLastTransferTimestamp[tx.origin] <
255                               block.number,
256                           "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
257                       );
258                       _holderLastTransferTimestamp[tx.origin] = block.number;
259                   }
260               }
261 
262             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
263                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
264                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
265                 _buyCount++;
266             }
267 
268             if(to == uniswapV2Pair && from!= address(this) ){
269                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
270             }
271 
272             uint256 contractTokenBalance = balanceOf(address(this));
273             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
274                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
275                 uint256 contractETHBalance = address(this).balance;
276                 if(contractETHBalance > 50000000000000000) {
277                     sendETHToFee(address(this).balance);
278                 }
279             }
280         }
281 
282         if(taxAmount>0){
283           _balances[address(this)]=_balances[address(this)].add(taxAmount);
284           emit Transfer(from, address(this),taxAmount);
285         }
286         _balances[from]=_balances[from].sub(amount);
287         _balances[to]=_balances[to].add(amount.sub(taxAmount));
288         emit Transfer(from, to, amount.sub(taxAmount));
289     }
290 
291 
292     function min(uint256 a, uint256 b) private pure returns (uint256){
293       return (a>b)?b:a;
294     }
295 
296     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
297         address[] memory path = new address[](2);
298         path[0] = address(this);
299         path[1] = uniswapV2Router.WETH();
300         _approve(address(this), address(uniswapV2Router), tokenAmount);
301         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
302             tokenAmount,
303             0,
304             path,
305             address(this),
306             block.timestamp
307         );
308     }
309 
310     function removeLimits() external onlyOwner{
311         _maxTxAmount = _tTotal;
312         _maxWalletSize=_tTotal;
313         transferDelayEnabled=false;
314         emit MaxTxAmountUpdated(_tTotal);
315     }
316 
317     function sendETHToFee(uint256 amount) private {
318         _taxWallet.transfer(amount);
319     }
320 
321     function openTrading() external onlyOwner() {
322         require(!tradingOpen,"trading is already open");
323         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
324         _approve(address(this), address(uniswapV2Router), _tTotal);
325         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
326         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
327         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
328         swapEnabled = true;
329         tradingOpen = true;
330     }
331 
332     
333     function reduceFee(uint256 _newFee) external{
334       require(_msgSender()==_taxWallet);
335       require(_newFee<=_finalBuyTax && _newFee<=_finalSellTax);
336       _finalBuyTax=_newFee;
337       _finalSellTax=_newFee;
338     }
339 
340     receive() external payable {}
341 
342     function manualSwap() external {
343         require(_msgSender()==_taxWallet);
344         uint256 tokenBalance=balanceOf(address(this));
345         if(tokenBalance>0){
346           swapTokensForEth(tokenBalance);
347         }
348         uint256 ethBalance=address(this).balance;
349         if(ethBalance>0){
350           sendETHToFee(ethBalance);
351         }
352     }
353 
354     function manualsend() external {
355         uint256 ethBalance=address(this).balance;
356         if(ethBalance>0){
357           sendETHToFee(ethBalance);
358         }
359     }
360 }