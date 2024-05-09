1 // SPDX-License-Identifier: MIT
2 
3 
4 pragma solidity 0.8.19;
5 
6 abstract contract Context {
7     function _msgSender() internal view virtual returns (address) {
8         return msg.sender;
9     }
10 }
11 
12 interface IERC20 {
13     function totalSupply() external view returns (uint256);
14     function balanceOf(address account) external view returns (uint256);
15     function transfer(address recipient, uint256 amount) external returns (bool);
16     function allowance(address owner, address spender) external view returns (uint256);
17     function approve(address spender, uint256 amount) external returns (bool);
18     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
19     event Transfer(address indexed from, address indexed to, uint256 value);
20     event Approval(address indexed owner, address indexed spender, uint256 value);
21 }
22 
23 library SafeMath {
24     function add(uint256 a, uint256 b) internal pure returns (uint256) {
25         uint256 c = a + b;
26         require(c >= a, "SafeMath: addition overflow");
27         return c;
28     }
29 
30     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31         return sub(a, b, "SafeMath: subtraction overflow");
32     }
33 
34     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
35         require(b <= a, errorMessage);
36         uint256 c = a - b;
37         return c;
38     }
39 
40     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
41         if (a == 0) {
42             return 0;
43         }
44         uint256 c = a * b;
45         require(c / a == b, "SafeMath: multiplication overflow");
46         return c;
47     }
48 
49     function div(uint256 a, uint256 b) internal pure returns (uint256) {
50         return div(a, b, "SafeMath: division by zero");
51     }
52 
53     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
54         require(b > 0, errorMessage);
55         uint256 c = a / b;
56         return c;
57     }
58 
59 }
60 
61 contract Ownable is Context {
62     address private _owner;
63     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
64 
65     constructor () {
66         address msgSender = _msgSender();
67         _owner = msgSender;
68         emit OwnershipTransferred(address(0), msgSender);
69     }
70 
71     function owner() public view returns (address) {
72         return _owner;
73     }
74 
75     modifier onlyOwner() {
76         require(_owner == _msgSender(), "Ownable: caller is not the owner");
77         _;
78     }
79 
80     function renounceOwnership() public virtual onlyOwner {
81         emit OwnershipTransferred(_owner, address(0));
82         _owner = address(0);
83     }
84 
85 }
86 
87 interface IUniswapV2Factory {
88     function createPair(address tokenA, address tokenB) external returns (address pair);
89 }
90 
91 interface IUniswapV2Router02 {
92     function swapExactTokensForETHSupportingFeeOnTransferTokens(
93         uint amountIn,
94         uint amountOutMin,
95         address[] calldata path,
96         address to,
97         uint deadline
98     ) external;
99     function factory() external pure returns (address);
100     function WETH() external pure returns (address);
101     function addLiquidityETH(
102         address token,
103         uint amountTokenDesired,
104         uint amountTokenMin,
105         uint amountETHMin,
106         address to,
107         uint deadline
108     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
109 }
110 
111 contract BitrockToken is Context , IERC20, Ownable {
112     using SafeMath for uint256;
113     mapping (address => uint256) private _balances;
114     mapping (address => mapping (address => uint256)) private _allowances;
115     mapping (address => bool) private _isExcludedFromFee;
116     mapping(address => uint256) private _holderLastTransferTimestamp;
117     bool public transferDelayEnabled = true;
118     address payable private _taxWallet;
119 
120     /// initial buy, sell fee till first 10 buys
121     uint256 private _initialBuyTax=15;
122     uint256 private _initialSellTax=30;
123 
124     ///final buy, sell fee
125     uint256 private _finalBuyTax=4;
126     uint256 private _finalSellTax=4;
127 
128     /// fee split info
129     uint256 private _marketingFee = 3; 
130     uint256 private _lpFee = 1;
131     
132     ///after how many buy sell should redue to final tax
133     uint256 private _reduceBuyTaxAt=15;
134     uint256 private _reduceSellTaxAt=15;
135     uint256 private _preventSwapBefore=10;
136     uint256 private _buyCount=0;
137 
138     uint8 private constant _decimals = 9;
139     uint256 private constant _tTotal = 100000000 * 10**_decimals; // 100 million max supply
140     string private constant _name = "Bitrock" ;
141     string private constant _symbol = "BITROCK" ;
142     uint256 public _maxTxAmount = 2000000 * 10**_decimals; // 2% of the supply
143     uint256 public _maxWalletSize = 2000000 * 10**_decimals; // 2% of the supply
144     uint256 public _taxSwapThreshold= 100000 * 10**_decimals;
145     uint256 public _maxTaxSwap= 1000000 * 10**_decimals;
146 
147     IUniswapV2Router02 private uniswapV2Router;
148     address private uniswapV2Pair;
149     bool private tradingOpen;
150     bool private inSwap = false;
151     bool private swapEnabled = false;
152 
153     event MaxTxAmountUpdated(uint _maxTxAmount);
154     modifier lockTheSwap {
155         inSwap = true;
156         _;
157         inSwap = false;
158     }
159 
160     constructor () {
161         _taxWallet = payable(_msgSender());
162         _balances[_msgSender()] = _tTotal;
163         _isExcludedFromFee[owner()] = true;
164         _isExcludedFromFee[address(this)] = true;
165         _isExcludedFromFee[_taxWallet] = true;
166 
167         emit Transfer(address(0), _msgSender(), _tTotal);
168     }
169 
170     function name() public pure returns (string memory) {
171         return _name;
172     }
173 
174     function symbol() public pure returns (string memory) {
175         return _symbol;
176     }
177 
178     function decimals() public pure returns (uint8) {
179         return _decimals;
180     }
181 
182     function totalSupply() public pure override returns (uint256) {
183         return _tTotal;
184     }
185 
186     function balanceOf(address account) public view override returns (uint256) {
187         return _balances[account];
188     }
189 
190     function transfer(address recipient, uint256 amount) public override returns (bool) {
191         _transfer(_msgSender(), recipient, amount);
192         return true;
193     }
194 
195     function allowance(address owner, address spender) public view override returns (uint256) {
196         return _allowances[owner][spender];
197     }
198 
199     function approve(address spender, uint256 amount) public override returns (bool) {
200         _approve(_msgSender(), spender, amount);
201         return true;
202     }
203 
204     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
205         _transfer(sender, recipient, amount);
206         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
207         return true;
208     }
209 
210     function _approve(address owner, address spender, uint256 amount) private {
211         require(owner != address(0), "ERC20: approve from the zero address");
212         require(spender != address(0), "ERC20: approve to the zero address");
213         _allowances[owner][spender] = amount;
214         emit Approval(owner, spender, amount);
215     }
216 
217     function _transfer(address from, address to, uint256 amount) private {
218         require(from != address(0), "ERC20: transfer from the zero address");
219         require(to != address(0), "ERC20: transfer to the zero address");
220         require(amount > 0, "Transfer amount must be greater than zero");
221         uint256 taxAmount=0;
222         if (from != owner() && to != owner() && from != address(this)) {
223             
224 
225             if (transferDelayEnabled) {
226                   if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
227                       require(
228                           _holderLastTransferTimestamp[tx.origin] <
229                               block.number,
230                           "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
231                       );
232                       _holderLastTransferTimestamp[tx.origin] = block.number;
233                   }
234               }
235 
236             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
237                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
238                 taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
239                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
240                 _buyCount++;
241             }
242 
243             if(to == uniswapV2Pair && from!= address(this) ){
244                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
245             }
246 
247             uint256 contractTokenBalance = balanceOf(address(this));
248             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
249                 swapAndLiquify(min(amount,min(contractTokenBalance,_maxTaxSwap)));
250             }
251         }
252 
253         if(taxAmount>0){
254           _balances[address(this)]=_balances[address(this)].add(taxAmount);
255           emit Transfer(from, address(this),taxAmount);
256         }
257         _balances[from]=_balances[from].sub(amount);
258         _balances[to]=_balances[to].add(amount.sub(taxAmount));
259         emit Transfer(from, to, amount.sub(taxAmount));
260     }
261 
262 
263     function min(uint256 a, uint256 b) private pure returns (uint256){
264       return (a>b)?b:a;
265     }
266 
267     function swapAndLiquify (uint256 tokens) private lockTheSwap {
268       uint256 lpTokens = (tokens * _lpFee) / 2;
269       uint256 swapTokens = tokens - lpTokens;
270       swapTokensForEth (swapTokens);
271       uint256 ethBalance = address(this).balance;
272       uint256 marketingPart = (ethBalance * _marketingFee) / (_marketingFee + _lpFee);
273       if(marketingPart > 0){
274       (bool success,) = _taxWallet.call{value: marketingPart}("");
275       if (success && lpTokens > 0){
276       addLiquidity(lpTokens, address(this).balance);
277        }
278       }
279     }
280 
281     function swapTokensForEth(uint256 tokenAmount) private  {
282         address[] memory path = new address[](2);
283         path[0] = address(this);
284         path[1] = uniswapV2Router.WETH();
285         _approve(address(this), address(uniswapV2Router), tokenAmount);
286         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
287             tokenAmount,
288             0,
289             path,
290             address(this),
291             block.timestamp
292         );
293     }
294 
295     function addLiquidity (uint256 tokens, uint256 eth) private {
296         uint256 allowedTokens = allowance(address(this), address(uniswapV2Router));
297         if(allowedTokens < tokens){
298          _approve(address(this), address(uniswapV2Router), ~uint256(0));
299         }
300         uniswapV2Router.addLiquidityETH{value: eth}(
301             address(this),
302             tokens,
303             0,
304             0,
305             _taxWallet,
306             block.timestamp);
307     }
308 
309     function removeLimits() external onlyOwner{
310         _maxTxAmount = _tTotal;
311         _maxWalletSize=_tTotal;
312         transferDelayEnabled=false;
313         emit MaxTxAmountUpdated(_tTotal);
314     }
315 
316 
317     function openTrading() external onlyOwner() {
318         require(!tradingOpen,"trading is already open");
319         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
320         _approve(address(this), address(uniswapV2Router), _tTotal);
321         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
322         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
323         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
324         swapEnabled = true;
325         tradingOpen = true;
326     }
327 
328     
329     function reduceFee(uint256 marketingFee, uint256 liquidityFee) external onlyOwner{
330       uint256 totalFee = marketingFee + liquidityFee;
331       require(totalFee<=_finalBuyTax &&totalFee <=_finalSellTax);
332       _marketingFee = marketingFee;
333       _lpFee = liquidityFee;
334       _finalBuyTax= totalFee;
335       _finalSellTax= totalFee;
336     }
337 
338     receive() external payable {}
339 
340     function manualSwap() external {
341         require(_msgSender()==_taxWallet);
342         uint256 tokenBalance=balanceOf(address(this));
343         if(tokenBalance>0){
344           swapAndLiquify(tokenBalance);
345         }
346       
347     }
348 }