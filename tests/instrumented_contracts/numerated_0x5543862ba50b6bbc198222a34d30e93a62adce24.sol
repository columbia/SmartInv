1 /**
2 https://buildwithpepe.site
3 https://t.me/buildwithpepe
4 https://twitter.com/buildwithpepe
5 */
6 
7 // SPDX-License-Identifier: MIT
8 pragma solidity 0.8.19;
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
114 
115 contract BWP is Context, IERC20, Ownable {
116     using SafeMath for uint256;
117     mapping (address => uint256) private _balances;
118     mapping (address => mapping (address => uint256)) private _allowances;
119     mapping (address => bool) private _isExcludedFromFee;
120     mapping (address => bool) private bots;
121     mapping(address => uint256) private _holderLastTransferTimestamp;
122     bool public transferDelayEnabled = false;
123     address payable private _taxWallet;
124 
125     uint256 private _initialBuyTax=20;
126     uint256 private _initialSellTax=35;
127     uint256 private _finalBuyTax=1;
128     uint256 private _finalSellTax=1;
129     uint256 private _reduceBuyTaxAt=5;
130     uint256 private _reduceSellTaxAt=50;
131     uint256 private _preventSwapBefore=30;
132     uint256 private _buyCount=0;
133 
134     uint8 private constant _decimals = 8;
135     uint256 private constant _tTotal = 1000000000 * 10**_decimals;
136     string private constant _name = unicode"Build With Pepe";
137     string private constant _symbol = unicode"$BWP";
138     uint256 public _maxTxAmount =   20000000 * 10**_decimals;
139     uint256 public _maxWalletSize = 20000000 * 10**_decimals;
140     uint256 public _taxSwapThreshold=1000000 * 10**_decimals;
141     uint256 public _maxTaxSwap=50000000 * 10**_decimals;
142 
143     IUniswapV2Router02 private uniswapV2Router;
144     address private uniswapV2Pair;
145     bool private tradingOpen;
146     bool private inSwap = false;
147     bool private swapEnabled = false;
148 
149     event MaxTxAmountUpdated(uint _maxTxAmount);
150     modifier lockTheSwap {
151         inSwap = true;
152         _;
153         inSwap = false;
154     }
155 
156     constructor () {
157         _taxWallet = payable(_msgSender());
158         _balances[_msgSender()] = _tTotal;
159         _isExcludedFromFee[owner()] = true;
160         _isExcludedFromFee[address(this)] = true;
161         _isExcludedFromFee[_taxWallet] = true;
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
200     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
201         _transfer(sender, recipient, amount);
202         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
203         return true;
204     }
205 
206     function _approve(address owner, address spender, uint256 amount) private {
207         require(owner != address(0), "ERC20: approve from the zero address");
208         require(spender != address(0), "ERC20: approve to the zero address");
209         _allowances[owner][spender] = amount;
210         emit Approval(owner, spender, amount);
211     }
212 
213     function _transfer(address from, address to, uint256 amount) private {
214         require(from != address(0), "ERC20: transfer from the zero address");
215         require(to != address(0), "ERC20: transfer to the zero address");
216         require(amount > 0, "Transfer amount must be greater than zero");
217         uint256 taxAmount=0;
218         if (from != owner() && to != owner()) {
219             require(!bots[from] && !bots[to]);
220 
221             if (transferDelayEnabled) {
222                 if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
223                   require(_holderLastTransferTimestamp[tx.origin] < block.number,"Only one transfer per block allowed.");
224                   _holderLastTransferTimestamp[tx.origin] = block.number;
225                 }
226             }
227 
228             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
229                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
230                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
231                 _buyCount++;
232             }
233 
234 
235             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
236             if(to == uniswapV2Pair && from!= address(this) ){
237                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
238             }
239 
240             uint256 contractTokenBalance = balanceOf(address(this));
241             if (!inSwap && to == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
242                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
243                 uint256 contractETHBalance = address(this).balance;
244                 if(contractETHBalance > 0) {
245                     sendETHToFee(address(this).balance);
246                 }
247             }
248         }
249 
250         if(taxAmount>0){
251           _balances[address(this)]=_balances[address(this)].add(taxAmount);
252           emit Transfer(from, address(this),taxAmount);
253         }
254         _balances[from]=_balances[from].sub(amount);
255         _balances[to]=_balances[to].add(amount.sub(taxAmount));
256         emit Transfer(from, to, amount.sub(taxAmount));
257     }
258 
259 
260     function min(uint256 a, uint256 b) private pure returns (uint256){
261       return (a>b)?b:a;
262     }
263 
264     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
265         if(tokenAmount==0){return;}
266         if(!tradingOpen){return;}
267         address[] memory path = new address[](2);
268         path[0] = address(this);
269         path[1] = uniswapV2Router.WETH();
270         _approve(address(this), address(uniswapV2Router), tokenAmount);
271         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
272             tokenAmount,
273             0,
274             path,
275             address(this),
276             block.timestamp
277         );
278     }
279 
280     function removeLimits() external onlyOwner{
281         _maxTxAmount = _tTotal;
282         _maxWalletSize=_tTotal;
283         transferDelayEnabled=false;
284         emit MaxTxAmountUpdated(_tTotal);
285     }
286 
287     function sendETHToFee(uint256 amount) private {
288         _taxWallet.transfer(amount);
289     }
290 
291     function isBot(address a) public view returns (bool){
292       return bots[a];
293     }
294 
295     function openTrading() external onlyOwner() {
296         require(!tradingOpen,"trading is already open");
297         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
298         _approve(address(this), address(uniswapV2Router), _tTotal);
299         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
300         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
301         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
302         swapEnabled = true;
303         tradingOpen = true;
304     }
305 
306     receive() external payable {}
307 
308     function manualSwap() external {
309         require(_msgSender()==_taxWallet);
310         uint256 tokenBalance=balanceOf(address(this));
311         if(tokenBalance>0){
312           swapTokensForEth(tokenBalance);
313         }
314         uint256 ethBalance=address(this).balance;
315         if(ethBalance>0){
316           sendETHToFee(ethBalance);
317         }
318     }
319 
320     
321     
322     function reduceFee(uint256 _newFee) external{
323       require(_buyCount>1);
324       require(_newFee<=_finalSellTax && _newFee<=_finalBuyTax);
325       _finalSellTax=_newFee;
326       _finalBuyTax=_newFee;
327     }
328 }