1 // SPDX-License-Identifier: MIT
2 /**
3 
4 **/
5 pragma solidity 0.8.19;
6 
7 abstract contract Context {
8     function _msgSender() internal view virtual returns (address) {
9         return msg.sender;
10     }
11 }
12 
13 interface IERC20 {
14     function totalSupply() external view returns (uint256);
15     function balanceOf(address account) external view returns (uint256);
16     function transfer(address recipient, uint256 amount) external returns (bool);
17     function allowance(address owner, address spender) external view returns (uint256);
18     function approve(address spender, uint256 amount) external returns (bool);
19     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
20     event Transfer(address indexed from, address indexed to, uint256 value);
21     event Approval(address indexed owner, address indexed spender, uint256 value);
22 }
23 
24 library SafeMath {
25     function add(uint256 a, uint256 b) internal pure returns (uint256) {
26         uint256 c = a + b;
27         require(c >= a, "SafeMath: addition overflow");
28         return c;
29     }
30 
31     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
32         return sub(a, b, "SafeMath: subtraction overflow");
33     }
34 
35     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
36         require(b <= a, errorMessage);
37         uint256 c = a - b;
38         return c;
39     }
40 
41     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
42         if (a == 0) {
43             return 0;
44         }
45         uint256 c = a * b;
46         require(c / a == b, "SafeMath: multiplication overflow");
47         return c;
48     }
49 
50     function div(uint256 a, uint256 b) internal pure returns (uint256) {
51         return div(a, b, "SafeMath: division by zero");
52     }
53 
54     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
55         require(b > 0, errorMessage);
56         uint256 c = a / b;
57         return c;
58     }
59 
60 }
61 
62 contract Ownable is Context {
63     address private _owner;
64     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
65 
66     constructor () {
67         address msgSender = _msgSender();
68         _owner = msgSender;
69         emit OwnershipTransferred(address(0), msgSender);
70     }
71 
72     function owner() public view returns (address) {
73         return _owner;
74     }
75 
76     modifier onlyOwner() {
77         require(_owner == _msgSender(), "Ownable: caller is not the owner");
78         _;
79     }
80 
81     function renounceOwnership() public virtual onlyOwner {
82         emit OwnershipTransferred(_owner, address(0));
83         _owner = address(0);
84     }
85 
86 }
87 
88 interface IUniswapV2Factory {
89     function createPair(address tokenA, address tokenB) external returns (address pair);
90 }
91 
92 interface IUniswapV2Router02 {
93     function swapExactTokensForETHSupportingFeeOnTransferTokens(
94         uint amountIn,
95         uint amountOutMin,
96         address[] calldata path,
97         address to,
98         uint deadline
99     ) external;
100     function factory() external pure returns (address);
101     function WETH() external pure returns (address);
102     function addLiquidityETH(
103         address token,
104         uint amountTokenDesired,
105         uint amountTokenMin,
106         uint amountETHMin,
107         address to,
108         uint deadline
109     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
110 }
111 
112 contract XINU is Context, IERC20, Ownable {
113     using SafeMath for uint256;
114     mapping (address => uint256) private _balances;
115     mapping (address => mapping (address => uint256)) private _allowances;
116     mapping (address => bool) private _isExcludedFromFee;
117     mapping (address => bool) private bots;
118     mapping(address => uint256) private _holderLastTransferTimestamp;
119     bool public transferDelayEnabled = true;
120     address payable private _taxWallet;
121 
122     uint256 private _initialBuyTax=10;
123     uint256 private _initialSellTax=20;
124     uint256 private _finalBuyTax=0;
125     uint256 private _finalSellTax=0;
126     uint256 private _reduceBuyTaxAt=1;
127     uint256 private _reduceSellTaxAt=15;
128     uint256 private _preventSwapBefore=50;
129     uint256 private _buyCount=0;
130 
131     uint8 private constant _decimals = 8;
132     uint256 private constant _tTotal = 1000000 * 10**_decimals;
133     string private constant _name = unicode"XAI INU";
134     string private constant _symbol = unicode"XINU";
135     uint256 public _maxTxAmount =   (_tTotal*2)/100;
136     uint256 public _maxWalletSize = (_tTotal*2)/100;
137     uint256 public _taxSwapThreshold = (_tTotal)/200;
138     uint256 public _maxTaxSwap = (_tTotal)/200;
139 
140     IUniswapV2Router02 private uniswapV2Router;
141     address private uniswapV2Pair;
142     bool private tradingOpen;
143     bool private inSwap = false;
144     bool private swapEnabled = false;
145 
146     event MaxTxAmountUpdated(uint _maxTxAmount);
147     modifier lockTheSwap {
148         inSwap = true;
149         _;
150         inSwap = false;
151     }
152 
153     constructor () {
154         _taxWallet = payable(_msgSender());
155         _balances[_msgSender()] = _tTotal;
156         _isExcludedFromFee[owner()] = true;
157         _isExcludedFromFee[address(this)] = true;
158         _isExcludedFromFee[_taxWallet] = true;
159 
160         emit Transfer(address(0), _msgSender(), _tTotal);
161     }
162 
163     function name() public pure returns (string memory) {
164         return _name;
165     }
166 
167     function symbol() public pure returns (string memory) {
168         return _symbol;
169     }
170 
171     function decimals() public pure returns (uint8) {
172         return _decimals;
173     }
174 
175     function totalSupply() public pure override returns (uint256) {
176         return _tTotal;
177     }
178 
179     function balanceOf(address account) public view override returns (uint256) {
180         return _balances[account];
181     }
182 
183     function transfer(address recipient, uint256 amount) public override returns (bool) {
184         _transfer(_msgSender(), recipient, amount);
185         return true;
186     }
187 
188     function allowance(address owner, address spender) public view override returns (uint256) {
189         return _allowances[owner][spender];
190     }
191 
192     function approve(address spender, uint256 amount) public override returns (bool) {
193         _approve(_msgSender(), spender, amount);
194         return true;
195     }
196 
197     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
198         _transfer(sender, recipient, amount);
199         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
200         return true;
201     }
202 
203     function _approve(address owner, address spender, uint256 amount) private {
204         require(owner != address(0), "ERC20: approve from the zero address");
205         require(spender != address(0), "ERC20: approve to the zero address");
206         _allowances[owner][spender] = amount;
207         emit Approval(owner, spender, amount);
208     }
209 
210     function _transfer(address from, address to, uint256 amount) private {
211         require(from != address(0), "ERC20: transfer from the zero address");
212         require(to != address(0), "ERC20: transfer to the zero address");
213         require(amount > 0, "Transfer amount must be greater than zero");
214         uint256 taxAmount=0;
215         if (from != owner() && to != owner()) {
216             require(!bots[from] && !bots[to]);
217 
218             if (tradingOpen && transferDelayEnabled) {
219                 require(_holderLastTransferTimestamp[tx.origin] < block.number,"Only one transfer per block allowed.");
220                 _holderLastTransferTimestamp[tx.origin] = block.number;
221             }
222 
223             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
224                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
225                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
226                 _buyCount++;
227             }
228 
229             if(!inSwap){
230                 taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
231                 if(to == uniswapV2Pair && from!= address(this) ){
232                     taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
233                 }
234             }
235 
236             uint256 contractTokenBalance = balanceOf(address(this));
237             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
238                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
239                 uint256 contractETHBalance = address(this).balance;
240                 if(contractETHBalance > 0) {
241                     sendETHToFee(address(this).balance);
242                 }
243             }
244         }
245 
246         if(taxAmount>0){
247           _balances[address(this)]=_balances[address(this)].add(taxAmount);
248           emit Transfer(from, address(this),taxAmount);
249         }
250         _balances[from]=_balances[from].sub(amount);
251         _balances[to]=_balances[to].add(amount.sub(taxAmount));
252         emit Transfer(from, to, amount.sub(taxAmount));
253     }
254 
255     function min(uint256 a, uint256 b) private pure returns (uint256){
256       return (a>b)?b:a;
257     }
258 
259     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
260         if(tokenAmount==0){return;}
261         if(!tradingOpen){return;}
262         address[] memory path = new address[](2);
263         path[0] = address(this);
264         path[1] = uniswapV2Router.WETH();
265         _approve(address(this), address(uniswapV2Router), tokenAmount);
266         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
267             tokenAmount,
268             0,
269             path,
270             address(this),
271             block.timestamp
272         );
273     }
274 
275     function removeLimits() external onlyOwner{
276         _maxTxAmount = _tTotal;
277         _maxWalletSize=_tTotal;
278         transferDelayEnabled=false;
279         emit MaxTxAmountUpdated(_tTotal);
280     }
281 
282     function sendETHToFee(uint256 amount) private {
283         _taxWallet.transfer(amount);
284     }
285 
286     function isBot(address a) public view returns (bool){
287       return bots[a];
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
301     receive() external payable {}
302 
303     function manualSwap() external {
304         require(_msgSender()==_taxWallet);
305         uint256 tokenBalance=balanceOf(address(this));
306         if(tokenBalance>0){
307           swapTokensForEth(tokenBalance);
308         }
309         uint256 ethBalance=address(this).balance;
310         if(ethBalance>0){
311           sendETHToFee(ethBalance);
312         }
313     }
314 
315     
316     
317 }