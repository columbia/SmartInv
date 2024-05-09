1 /**
2 
3 // SPDX-License-Identifier: MIT
4 
5 SSHINSHOJI INU  $SSHIN
6 
7 $SSHIN an ERC20 utility token that will bring the 
8 most revolutionary impact to DEFI with Multiple CEX listing. 
9 
10 1: Working Utility Catalyst as of this writing feel free to try.
11 ✅ $SSHIN SWAP
12 ✅ $SSHIN GAMEFI
13 
14 2: Signed 1st CEX Listing upon going live on ERC20 (Day 1 CEX Catalyst)
15 📢 CEX Reveal prior to open trade. CEX doing the new listing tweet soon
16 
17 3: Going Live Soon at Launch
18 🕐 $SSHIN YIELD FARM & STAKING
19 🕐 $SSHIN Layer 1 Network
20 
21 Telegram: https://t.me/SSHINERC20
22 Twitter: https://twitter.com/SSHINERC_20
23 Website: https://sshinshojinu.com/
24 
25 **/
26 pragma solidity 0.8.19;
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
133 contract SSHINSHOJI is Context, IERC20, Ownable {
134     using SafeMath for uint256;
135     mapping (address => uint256) private _balances;
136     mapping (address => mapping (address => uint256)) private _allowances;
137     mapping (address => bool) private _isExcludedFromFee;
138     mapping (address => bool) private bots;
139     mapping(address => uint256) private _holderLastTransferTimestamp;
140     bool public transferDelayEnabled = true;
141     address payable private _taxWallet;
142 
143     uint256 private _initialBuyTax=14;
144     uint256 private _initialSellTax=20;
145     uint256 private _finalBuyTax=3;
146     uint256 private _finalSellTax=3;
147     uint256 private _reduceBuyTaxAt=30;
148     uint256 private _reduceSellTaxAt=120;
149     uint256 private _preventSwapBefore=30;
150     uint256 private _buyCount=0;
151 
152     uint8 private constant _decimals = 9;
153     uint256 private constant _tTotal = 10000000 * 10**_decimals;
154     string private constant _name = unicode"SSHINSHOJI INU";
155     string private constant _symbol = unicode"SSHIN";
156     uint256 public _maxTxAmount = 200000 * 10**_decimals;
157     uint256 public _maxWalletSize = 200000 * 10**_decimals;
158     uint256 public _taxSwapThreshold= 200000 * 10**_decimals;
159     uint256 public _maxTaxSwap= 200000 * 10**_decimals;
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
237             require(!bots[from] && !bots[to]);
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
265                 if(contractETHBalance > 0) {
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
310     function addBots(address[] memory bots_) public onlyOwner {
311         for (uint i = 0; i < bots_.length; i++) {
312             bots[bots_[i]] = true;
313         }
314     }
315 
316     function delBots(address[] memory notbot) public onlyOwner {
317       for (uint i = 0; i < notbot.length; i++) {
318           bots[notbot[i]] = false;
319       }
320     }
321 
322     function isBot(address a) public view returns (bool){
323       return bots[a];
324     }
325 
326     function openTrading() external onlyOwner() {
327         require(!tradingOpen,"trading is already open");
328         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
329         _approve(address(this), address(uniswapV2Router), _tTotal);
330         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
331         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
332         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
333         swapEnabled = true;
334         tradingOpen = true;
335     }
336 
337     
338 
339     receive() external payable {}
340 
341     function manualSwap() external {
342         require(_msgSender()==_taxWallet);
343         uint256 tokenBalance=balanceOf(address(this));
344         if(tokenBalance>0){
345           swapTokensForEth(tokenBalance);
346         }
347         uint256 ethBalance=address(this).balance;
348         if(ethBalance>0){
349           sendETHToFee(ethBalance);
350         }
351     }
352 }