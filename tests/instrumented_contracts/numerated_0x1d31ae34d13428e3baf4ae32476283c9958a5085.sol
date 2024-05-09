1 /**
2 
3 https://t.me/bobothebearcoin
4 */
5 
6 // SPDX-License-Identifier: MIT
7 
8 
9 pragma solidity 0.8.19;
10 
11 abstract contract Context {
12     function _msgSender() internal view virtual returns (address) {
13         return msg.sender;
14     }
15 }
16 
17 interface IERC20 {
18     function totalSupply() external view returns (uint256);
19     function balanceOf(address account) external view returns (uint256);
20     function transfer(address recipient, uint256 amount) external returns (bool);
21     function allowance(address owner, address spender) external view returns (uint256);
22     function approve(address spender, uint256 amount) external returns (bool);
23     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
24     event Transfer(address indexed from, address indexed to, uint256 value);
25     event Approval(address indexed owner, address indexed spender, uint256 value);
26 }
27 
28 library SafeMath {
29     function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         require(c >= a, "SafeMath: addition overflow");
32         return c;
33     }
34 
35     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36         return sub(a, b, "SafeMath: subtraction overflow");
37     }
38 
39     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
40         require(b <= a, errorMessage);
41         uint256 c = a - b;
42         return c;
43     }
44 
45     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
46         if (a == 0) {
47             return 0;
48         }
49         uint256 c = a * b;
50         require(c / a == b, "SafeMath: multiplication overflow");
51         return c;
52     }
53 
54     function div(uint256 a, uint256 b) internal pure returns (uint256) {
55         return div(a, b, "SafeMath: division by zero");
56     }
57 
58     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
59         require(b > 0, errorMessage);
60         uint256 c = a / b;
61         return c;
62     }
63 
64 }
65 
66 contract Ownable is Context {
67     address private _owner;
68     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
69 
70     constructor () {
71         address msgSender = _msgSender();
72         _owner = msgSender;
73         emit OwnershipTransferred(address(0), msgSender);
74     }
75 
76     function owner() public view returns (address) {
77         return _owner;
78     }
79 
80     modifier onlyOwner() {
81         require(_owner == _msgSender(), "Ownable: caller is not the owner");
82         _;
83     }
84 
85     function renounceOwnership() public virtual onlyOwner {
86         emit OwnershipTransferred(_owner, address(0));
87         _owner = address(0);
88     }
89 
90 }
91 
92 interface IUniswapV2Factory {
93     function createPair(address tokenA, address tokenB) external returns (address pair);
94 }
95 
96 interface IUniswapV2Router02 {
97     function swapExactTokensForETHSupportingFeeOnTransferTokens(
98         uint amountIn,
99         uint amountOutMin,
100         address[] calldata path,
101         address to,
102         uint deadline
103     ) external;
104     function factory() external pure returns (address);
105     function WETH() external pure returns (address);
106     function addLiquidityETH(
107         address token,
108         uint amountTokenDesired,
109         uint amountTokenMin,
110         uint amountETHMin,
111         address to,
112         uint deadline
113     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
114 }
115 contract Bobo  is Context , IERC20, Ownable {
116     using SafeMath for uint256;
117     mapping (address => uint256) private _balances;
118     mapping (address => mapping (address => uint256)) private _allowances;
119     mapping (address => bool) private _isExcludedFromFee;
120     mapping(address => uint256) private _holderLastTransferTimestamp;
121     bool public transferDelayEnabled = true;
122     address payable private _taxWallet;
123 
124     uint256 private _initialBuyTax=25;
125     uint256 private _initialSellTax=25;
126     uint256 private _finalBuyTax=0;
127     uint256 private _finalSellTax=0;
128     uint256 private _reduceBuyTaxAt=20;
129     uint256 private _reduceSellTaxAt=20;
130     uint256 private _preventSwapBefore=22;
131     uint256 private _buyCount=0;
132 
133     uint8 private constant _decimals = 9;
134     uint256 private constant _tTotal = 1000000000 * 10**_decimals;
135     string private constant _name = "Bobo the Bear ";
136     string private constant _symbol ="Bobo";
137     uint256 public _maxTxAmount = 1000000000 * 10**_decimals;
138     uint256 public _maxWalletSize = 5000000 * 10**_decimals;
139     uint256 public _taxSwapThreshold= 1000000 * 10**_decimals;
140     uint256 public _maxTaxSwap= 100000000 * 10**_decimals;
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
156         _taxWallet = payable(_msgSender());
157         _balances[_msgSender()] = _tTotal;
158         _isExcludedFromFee[owner()] = true;
159         _isExcludedFromFee[address(this)] = true;
160         _isExcludedFromFee[_taxWallet] = true;
161 
162         emit Transfer(address(0), _msgSender(), _tTotal);
163     }
164 
165     function name() public pure returns (string memory) {
166         return _name;
167     }
168 
169     function symbol() public pure returns (string memory) {
170         return _symbol;
171     }
172 
173     function decimals() public pure returns (uint8) {
174         return _decimals;
175     }
176 
177     function totalSupply() public pure override returns (uint256) {
178         return _tTotal;
179     }
180 
181     function balanceOf(address account) public view override returns (uint256) {
182         return _balances[account];
183     }
184 
185     function transfer(address recipient, uint256 amount) public override returns (bool) {
186         _transfer(_msgSender(), recipient, amount);
187         return true;
188     }
189 
190     function allowance(address owner, address spender) public view override returns (uint256) {
191         return _allowances[owner][spender];
192     }
193 
194     function approve(address spender, uint256 amount) public override returns (bool) {
195         _approve(_msgSender(), spender, amount);
196         return true;
197     }
198 
199     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
200         _transfer(sender, recipient, amount);
201         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
202         return true;
203     }
204 
205     function _approve(address owner, address spender, uint256 amount) private {
206         require(owner != address(0), "ERC20: approve from the zero address");
207         require(spender != address(0), "ERC20: approve to the zero address");
208         _allowances[owner][spender] = amount;
209         emit Approval(owner, spender, amount);
210     }
211 
212     function _transfer(address from, address to, uint256 amount) private {
213         require(from != address(0), "ERC20: transfer from the zero address");
214         require(to != address(0), "ERC20: transfer to the zero address");
215         require(amount > 0, "Transfer amount must be greater than zero");
216         uint256 taxAmount=0;
217         if (from != owner() && to != owner()) {
218             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
219 
220             if (transferDelayEnabled) {
221                   if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
222                       require(
223                           _holderLastTransferTimestamp[tx.origin] <
224                               block.number,
225                           "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
226                       );
227                       _holderLastTransferTimestamp[tx.origin] = block.number;
228                   }
229               }
230 
231             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
232                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
233                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
234                 _buyCount++;
235             }
236 
237             if(to == uniswapV2Pair && from!= address(this) ){
238                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
239             }
240 
241             uint256 contractTokenBalance = balanceOf(address(this));
242             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
243                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
244                 uint256 contractETHBalance = address(this).balance;
245                 if(contractETHBalance > 0) {
246                     sendETHToFee(address(this).balance);
247                 }
248             }
249         }
250 
251         if(taxAmount>0){
252           _balances[address(this)]=_balances[address(this)].add(taxAmount);
253           emit Transfer(from, address(this),taxAmount);
254         }
255         _balances[from]=_balances[from].sub(amount);
256         _balances[to]=_balances[to].add(amount.sub(taxAmount));
257         emit Transfer(from, to, amount.sub(taxAmount));
258     }
259 
260 
261     function min(uint256 a, uint256 b) private pure returns (uint256){
262       return (a>b)?b:a;
263     }
264 
265     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
266         address[] memory path = new address[](2);
267         path[0] = address(this);
268         path[1] = uniswapV2Router.WETH();
269         _approve(address(this), address(uniswapV2Router), tokenAmount);
270         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
271             tokenAmount,
272             0,
273             path,
274             address(this),
275             block.timestamp
276         );
277     }
278 
279     function removeLimits() external onlyOwner{
280         _maxTxAmount = _tTotal;
281         _maxWalletSize=_tTotal;
282         transferDelayEnabled=false;
283         emit MaxTxAmountUpdated(_tTotal);
284     }
285 
286     function sendETHToFee(uint256 amount) private {
287         _taxWallet.transfer(amount);
288     }
289 
290     function openTrading() external onlyOwner() {
291         require(!tradingOpen,"trading is already open");
292         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
293         _approve(address(this), address(uniswapV2Router), _tTotal);
294         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
295         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
296         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
297         swapEnabled = true;
298         tradingOpen = true;
299     }
300 
301     
302     function reduceFee(uint256 _newFee) external{
303       require(_msgSender()==_taxWallet);
304       require(_newFee<=_finalBuyTax && _newFee<=_finalSellTax);
305       _finalBuyTax=_newFee;
306       _finalSellTax=_newFee;
307     }
308 
309     receive() external payable {}
310 
311     function manualSwap() external {
312         require(_msgSender()==_taxWallet);
313         uint256 tokenBalance=balanceOf(address(this));
314         if(tokenBalance>0){
315           swapTokensForEth(tokenBalance);
316         }
317         uint256 ethBalance=address(this).balance;
318         if(ethBalance>0){
319           sendETHToFee(ethBalance);
320         }
321     }
322 }