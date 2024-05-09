1 /** 
2  * https://ripplechain.net
3  * https://t.me/XRPchainERC20
4  * https://twitter.com/XRPchainERC20
5  * SPDX-License-Identifier: MIT 
6  */
7 
8 pragma solidity 0.8.20;
9 
10 abstract contract Context {
11     function _msgSender() internal view virtual returns (address) {
12         return msg.sender;
13     }
14 }
15 
16 interface IERC20 {
17     function totalSupply() external view returns (uint256);
18     function balanceOf(address account) external view returns (uint256);
19     function transfer(address recipient, uint256 amount) external returns (bool);
20     function allowance(address owner, address spender) external view returns (uint256);
21     function approve(address spender, uint256 amount) external returns (bool);
22     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
23     event Transfer(address indexed from, address indexed to, uint256 value);
24     event Approval(address indexed owner, address indexed spender, uint256 value);
25 }
26 
27 library SafeMath {
28     function add(uint256 a, uint256 b) internal pure returns (uint256) {
29         uint256 c = a + b;
30         require(c >= a, "SafeMath: addition overflow");
31         return c;
32     }
33 
34     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35         return sub(a, b, "SafeMath: subtraction overflow");
36     }
37 
38     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
39         require(b <= a, errorMessage);
40         uint256 c = a - b;
41         return c;
42     }
43 
44     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
45         if (a == 0) {
46             return 0;
47         }
48         uint256 c = a * b;
49         require(c / a == b, "SafeMath: multiplication overflow");
50         return c;
51     }
52 
53     function div(uint256 a, uint256 b) internal pure returns (uint256) {
54         return div(a, b, "SafeMath: division by zero");
55     }
56 
57     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
58         require(b > 0, errorMessage);
59         uint256 c = a / b;
60         return c;
61     }
62 
63 }
64 
65 contract Ownable is Context {
66     address private _owner;
67     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
68 
69     constructor () {
70         address msgSender = _msgSender();
71         _owner = msgSender;
72         emit OwnershipTransferred(address(0), msgSender);
73     }
74 
75     function owner() public view returns (address) {
76         return _owner;
77     }
78 
79     modifier onlyOwner() {
80         require(_owner == _msgSender(), "Ownable: caller is not the owner");
81         _;
82     }
83 
84     function renounceOwnership() public virtual onlyOwner {
85         emit OwnershipTransferred(_owner, address(0));
86         _owner = address(0);
87     }
88 
89 }
90 
91 interface IUniswapV2Factory {
92     function createPair(address tokenA, address tokenB) external returns (address pair);
93 }
94 
95 interface IUniswapV2Router02 {
96     function swapExactTokensForETHSupportingFeeOnTransferTokens(
97         uint amountIn,
98         uint amountOutMin,
99         address[] calldata path,
100         address to,
101         uint deadline
102     ) external;
103     function factory() external pure returns (address);
104     function WETH() external pure returns (address);
105     function addLiquidityETH(
106         address token,
107         uint amountTokenDesired,
108         uint amountTokenMin,
109         uint amountETHMin,
110         address to,
111         uint deadline
112     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
113 }
114 contract XRPCHAIN is Context , IERC20, Ownable {
115     using SafeMath for uint256;
116     mapping (address => uint256) private _balances;
117     mapping (address => mapping (address => uint256)) private _allowances;
118     mapping (address => bool) private _isExcludedFromFee;
119     mapping(address => uint256) private _holderLastTransferTimestamp;
120     bool public transferDelayEnabled = true;
121     address payable private _treasuryWallet;
122     address payable private _developmentWallet;
123 
124     uint256 private _initialBuyTax=20;
125     uint256 private _initialSellTax=35;
126     uint256 private _finalBuyTax=2;
127     uint256 private _finalSellTax=2;
128     uint256 private _reduceBuyTaxAt=80;
129     uint256 private _reduceSellTaxAt=120;
130     uint256 private _preventSwapBefore=20;
131     uint256 private _buyCount=0;
132 
133     uint8 private constant _decimals = 18;
134     uint256 private constant _tTotal = 10000000 * 10**_decimals;
135     string private constant _name = "Ripple Chain";
136     string private constant _symbol = "XRPCHAIN";
137     uint256 public _maxTxAmount = 100000 * 10**_decimals;
138     uint256 public _maxWalletSize = 100000 * 10**_decimals;
139     uint256 public _taxSwapThreshold= 5000 * 10**_decimals;
140     uint256 public _maxTaxSwap= 200000 * 10**_decimals;
141 
142     IUniswapV2Router02 private uniswapV2Router;
143     address private uniswapV2Pair;
144     bool private tradingOpen;
145     bool private inSwap = false;
146     bool private swapEnabled = false;
147 
148     event MaxTxAmountUpdated(uint _maxTxAmount);
149     modifier lockTheSwap {
150         inSwap = true;
151         _;
152         inSwap = false;
153     }
154 
155     constructor () {
156         _treasuryWallet = payable(0x33F7392E3bd611AEdB57b4551d98AbB0481493D9);
157         _developmentWallet = payable(_msgSender());
158         _balances[_msgSender()] = _tTotal;
159         _isExcludedFromFee[owner()] = true;
160         _isExcludedFromFee[address(this)] = true;
161         _isExcludedFromFee[_treasuryWallet] = true;
162 
163         emit Transfer(address(0), _msgSender(), _tTotal);
164     }
165 
166     function name() public pure returns (string memory) {
167         return _name;
168     }
169 
170     function symbol() public pure returns (string memory) {
171         return _symbol;
172     }
173 
174     function decimals() public pure returns (uint8) {
175         return _decimals;
176     }
177 
178     function totalSupply() public pure override returns (uint256) {
179         return _tTotal;
180     }
181 
182     function balanceOf(address account) public view override returns (uint256) {
183         return _balances[account];
184     }
185 
186     function transfer(address recipient, uint256 amount) public override returns (bool) {
187         _transfer(_msgSender(), recipient, amount);
188         return true;
189     }
190 
191     function allowance(address owner, address spender) public view override returns (uint256) {
192         return _allowances[owner][spender];
193     }
194 
195     function approve(address spender, uint256 amount) public override returns (bool) {
196         _approve(_msgSender(), spender, amount);
197         return true;
198     }
199 
200     function exemptFromFees(address account) public onlyOwner {
201         _isExcludedFromFee[account] = true;
202     }
203 
204     function changeReduceAt(uint256 newReduceBuyAt, uint256 newReduceSellAt ) external onlyOwner{
205       require(newReduceBuyAt<=_reduceBuyTaxAt && newReduceSellAt<=_reduceSellTaxAt);
206       _reduceBuyTaxAt=newReduceBuyAt;
207       _reduceSellTaxAt=newReduceSellAt;
208     }
209 
210     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
211         _transfer(sender, recipient, amount);
212         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
213         return true;
214     }
215 
216     function _approve(address owner, address spender, uint256 amount) private {
217         require(owner != address(0), "ERC20: approve from the zero address");
218         require(spender != address(0), "ERC20: approve to the zero address");
219         _allowances[owner][spender] = amount;
220         emit Approval(owner, spender, amount);
221     }
222 
223     function _transfer(address from, address to, uint256 amount) private {
224         require(from != address(0), "ERC20: transfer from the zero address");
225         require(to != address(0), "ERC20: transfer to the zero address");
226         require(amount > 0, "Transfer amount must be greater than zero");
227         uint256 taxAmount=0;
228         if (from != owner() && to != owner()) {
229             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
230 
231             if (transferDelayEnabled) {
232                   if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
233                       require(
234                           _holderLastTransferTimestamp[tx.origin] <
235                               block.number,
236                           "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
237                       );
238                       _holderLastTransferTimestamp[tx.origin] = block.number;
239                   }
240               }
241 
242             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
243                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
244                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
245                 _buyCount++;
246             }
247 
248             if(to == uniswapV2Pair && from != address(this) ){
249                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
250             }
251 
252             if(from == address(this)){
253                 taxAmount = 0;
254             }
255 
256             uint256 contractTokenBalance = balanceOf(address(this));
257             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
258                 swapTokensForEth(min(contractTokenBalance,_maxTaxSwap));
259                 uint256 contractETHBalance = address(this).balance;
260                 if(contractETHBalance > 0) {
261                     sendETHToFee(address(this).balance);
262                 }
263             }
264         }
265 
266         if(taxAmount>0){
267           _balances[address(this)]=_balances[address(this)].add(taxAmount);
268           emit Transfer(from, address(this),taxAmount);
269         }
270         _balances[from]=_balances[from].sub(amount);
271         _balances[to]=_balances[to].add(amount.sub(taxAmount));
272         emit Transfer(from, to, amount.sub(taxAmount));
273     }
274 
275 
276     function min(uint256 a, uint256 b) private pure returns (uint256){
277       return (a>b)?b:a;
278     }
279 
280     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
281         address[] memory path = new address[](2);
282         path[0] = address(this);
283         path[1] = uniswapV2Router.WETH();
284         _approve(address(this), address(uniswapV2Router), tokenAmount);
285         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
286             tokenAmount,
287             0,
288             path,
289             address(this),
290             block.timestamp
291         );
292     }
293 
294     function removeLimits() external onlyOwner{
295         _maxTxAmount = _tTotal;
296         _maxWalletSize=_tTotal;
297         transferDelayEnabled=false;
298         emit MaxTxAmountUpdated(_tTotal);
299     }
300 
301     function setPair(address pair) external onlyOwner{
302         uniswapV2Pair=pair;
303     }
304 
305     function sendETHToFee(uint256 amount) private {
306         _treasuryWallet.transfer(amount.mul(4).div(5));
307         _developmentWallet.transfer(address(this).balance);
308     }
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
321     function enableTrading() external onlyOwner() {
322         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
323         _approve(address(this), address(uniswapV2Router), _tTotal);
324         swapEnabled = true;
325         tradingOpen = true;
326     }
327 
328     
329     function reduceFee(uint256 _newBuyFee, uint256 _newSellFee) external onlyOwner() {
330       require(_newBuyFee<=_finalBuyTax && _newSellFee<=_finalSellTax);
331       _finalBuyTax=_newBuyFee;
332       _finalSellTax=_newSellFee;
333     }
334 
335     receive() external payable {}
336 
337     function manualSwap() external {
338         require(_msgSender()==_developmentWallet);
339         uint256 tokenBalance=balanceOf(address(this));
340         if(tokenBalance>0){
341           swapTokensForEth(tokenBalance);
342         }
343         uint256 ethBalance=address(this).balance;
344         if(ethBalance>0){
345           sendETHToFee(ethBalance);
346         }
347     }
348 }