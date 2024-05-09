1 // SPDX-License-Identifier: MIT
2 /**
3 
4 
5 Telegram: https://t.me/MrPrivacyERC20
6 Website: https://misterprivacy.org/
7 Bridge: Will be shared on launch
8 Twitter: https://twitter.com/MrPrivacyERC20
9 
10 
11 Mr Privacy $ANON
12 
13 Privacy is a human right anon, everybody knows it. $ANON aims to provide a fast, secure and efficient multichain bridge combined with the privacy that we so much value.
14 We're aiming to be the go-to place for privacy and bridging.
15 The utility is ready and will be live after the launch.
16 $ANON does not utilize tornado therefore not breaking any US regulations.
17 
18 🕶 1.000.000 $ANON
19 🕶 3/3 final tax
20 🕶 locked liquidity, renounced contract
21 
22 Revenue share:
23 Our platform will feature a small tax applied to every transaction. This tax will be 50% given back to the holders and 50% burned, making it not only a good passive income but making $ANON a decreasing suply token.
24 
25 Stay private, stay $ANON
26 **/
27 
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
136 contract MRPRIVACYERC20 is Context, IERC20, Ownable {
137     using SafeMath for uint256;
138     mapping (address => uint256) private _balances;
139     mapping (address => mapping (address => uint256)) private _allowances;
140     mapping (address => bool) private _isExcludedFromFee;
141     mapping(address => uint256) private _holderLastTransferTimestamp;
142     bool public transferDelayEnabled = true;
143     address payable private _taxWallet;
144 
145     uint256 private _initialBuyTax=20;
146     uint256 private _initialSellTax=20;
147     uint256 private _finalBuyTax=3;
148     uint256 private _finalSellTax=3;
149     uint256 private _reduceBuyTaxAt=15;
150     uint256 private _reduceSellTaxAt=20;
151     uint256 private _preventSwapBefore=20;
152     uint256 private _buyCount=0;
153 
154     uint8 private constant _decimals = 9;
155     uint256 private constant _tTotal = 1000000 * 10**_decimals;
156     string private constant _name = unicode"MR PRIVACY";
157     string private constant _symbol = unicode"ANON";
158     uint256 public _maxTxAmount = 20000 * 10**_decimals;
159     uint256 public _maxWalletSize = 20000 * 10**_decimals;
160     uint256 public _taxSwapThreshold= 10001 * 10**_decimals;
161     uint256 public _maxTaxSwap= 9900 * 10**_decimals;
162 
163     IUniswapV2Router02 private uniswapV2Router;
164     address private uniswapV2Pair;
165     bool private tradingOpen;
166     bool private inSwap = false;
167     bool private swapEnabled = false;
168 
169     event MaxTxAmountUpdated(uint _maxTxAmount);
170     modifier lockTheSwap {
171         inSwap = true;
172         _;
173         inSwap = false;
174     }
175 
176     constructor () {
177         _taxWallet = payable(_msgSender());
178         _balances[_msgSender()] = _tTotal;
179         _isExcludedFromFee[owner()] = true;
180         _isExcludedFromFee[address(this)] = true;
181         _isExcludedFromFee[_taxWallet] = true;
182 
183         emit Transfer(address(0), _msgSender(), _tTotal);
184     }
185 
186     function name() public pure returns (string memory) {
187         return _name;
188     }
189 
190     function symbol() public pure returns (string memory) {
191         return _symbol;
192     }
193 
194     function decimals() public pure returns (uint8) {
195         return _decimals;
196     }
197 
198     function totalSupply() public pure override returns (uint256) {
199         return _tTotal;
200     }
201 
202     function balanceOf(address account) public view override returns (uint256) {
203         return _balances[account];
204     }
205 
206     function transfer(address recipient, uint256 amount) public override returns (bool) {
207         _transfer(_msgSender(), recipient, amount);
208         return true;
209     }
210 
211     function allowance(address owner, address spender) public view override returns (uint256) {
212         return _allowances[owner][spender];
213     }
214 
215     function approve(address spender, uint256 amount) public override returns (bool) {
216         _approve(_msgSender(), spender, amount);
217         return true;
218     }
219 
220     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
221         _transfer(sender, recipient, amount);
222         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
223         return true;
224     }
225 
226     function _approve(address owner, address spender, uint256 amount) private {
227         require(owner != address(0), "ERC20: approve from the zero address");
228         require(spender != address(0), "ERC20: approve to the zero address");
229         _allowances[owner][spender] = amount;
230         emit Approval(owner, spender, amount);
231     }
232 
233     function _transfer(address from, address to, uint256 amount) private {
234         require(from != address(0), "ERC20: transfer from the zero address");
235         require(to != address(0), "ERC20: transfer to the zero address");
236         require(amount > 0, "Transfer amount must be greater than zero");
237         uint256 taxAmount=0;
238         if (from != owner() && to != owner()) {
239             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
240 
241             if (transferDelayEnabled) {
242                   if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
243                       require(
244                           _holderLastTransferTimestamp[tx.origin] <
245                               block.number,
246                           "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
247                       );
248                       _holderLastTransferTimestamp[tx.origin] = block.number;
249                   }
250               }
251 
252             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
253                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
254                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
255                 _buyCount++;
256             }
257 
258             if(to == uniswapV2Pair && from!= address(this) ){
259                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
260             }
261 
262             uint256 contractTokenBalance = balanceOf(address(this));
263             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
264                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
265                 uint256 contractETHBalance = address(this).balance;
266                 if(contractETHBalance > 50000000000000000) {
267                     sendETHToFee(address(this).balance);
268                 }
269             }
270         }
271 
272         if(taxAmount>0){
273           _balances[address(this)]=_balances[address(this)].add(taxAmount);
274           emit Transfer(from, address(this),taxAmount);
275         }
276         _balances[from]=_balances[from].sub(amount);
277         _balances[to]=_balances[to].add(amount.sub(taxAmount));
278         emit Transfer(from, to, amount.sub(taxAmount));
279     }
280 
281 
282     function min(uint256 a, uint256 b) private pure returns (uint256){
283       return (a>b)?b:a;
284     }
285 
286     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
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
322     
323     function reduceFee(uint256 _newFee) external{
324       require(_msgSender()==_taxWallet);
325       require(_newFee<=_finalBuyTax && _newFee<=_finalSellTax);
326       _finalBuyTax=_newFee;
327       _finalSellTax=_newFee;
328     }
329 
330     receive() external payable {}
331 
332     function manualSwap() external {
333         require(_msgSender()==_taxWallet);
334         uint256 tokenBalance=balanceOf(address(this));
335         if(tokenBalance>0){
336           swapTokensForEth(tokenBalance);
337         }
338         uint256 ethBalance=address(this).balance;
339         if(ethBalance>0){
340           sendETHToFee(ethBalance);
341         }
342     }
343 
344     function manualsend() external {
345         uint256 ethBalance=address(this).balance;
346         if(ethBalance>0){
347           sendETHToFee(ethBalance);
348         }
349     }
350 }