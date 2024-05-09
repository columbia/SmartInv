1 // MEDIEVAL - Medieval Landwolf
2 // X: https://twitter.com/MedievalETH
3 // Telegram: https://t.me/MedievalETH
4 // Website: https://www.MedievalETH.com
5 // To the Land of MEDIEVAL: For Knights, Mages, and Tokens!
6 // SPDX-License-Identifier: MIT
7 pragma solidity 0.8.20;
8 
9 abstract contract Context {
10     function _msgSender() internal view virtual returns (address) {
11         return msg.sender;
12     }
13 }
14 
15 interface IERC20 {
16     function totalSupply() external view returns (uint256);
17     function balanceOf(address account) external view returns (uint256);
18     function transfer(address recipient, uint256 amount) external returns (bool);
19     function allowance(address owner, address spender) external view returns (uint256);
20     function approve(address spender, uint256 amount) external returns (bool);
21     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
22     event Transfer(address indexed from, address indexed to, uint256 value);
23     event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25 
26 library SafeMath {
27     function add(uint256 a, uint256 b) internal pure returns (uint256) {
28         uint256 c = a + b;
29         require(c >= a, "SafeMath: addition overflow");
30         return c;
31     }
32 
33     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34         return sub(a, b, "SafeMath: subtraction overflow");
35     }
36 
37     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
38         require(b <= a, errorMessage);
39         uint256 c = a - b;
40         return c;
41     }
42 
43     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
44         if (a == 0) {
45             return 0;
46         }
47         uint256 c = a * b;
48         require(c / a == b, "SafeMath: multiplication overflow");
49         return c;
50     }
51 
52     function div(uint256 a, uint256 b) internal pure returns (uint256) {
53         return div(a, b, "SafeMath: division by zero");
54     }
55 
56     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
57         require(b > 0, errorMessage);
58         uint256 c = a / b;
59         return c;
60     }
61 
62 }
63 
64 contract Ownable is Context {
65     address private _owner;
66     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
67 
68     constructor () {
69         address msgSender = _msgSender();
70         _owner = msgSender;
71         emit OwnershipTransferred(address(0), msgSender);
72     }
73 
74     function owner() public view returns (address) {
75         return _owner;
76     }
77 
78     modifier onlyOwner() {
79         require(_owner == _msgSender(), "Ownable: caller is not the owner");
80         _;
81     }
82 
83     function renounceOwnership() public virtual onlyOwner {
84         emit OwnershipTransferred(_owner, address(0));
85         _owner = address(0);
86     }
87 
88 }
89 
90 interface IUniswapV2Factory {
91     function createPair(address tokenA, address tokenB) external returns (address pair);
92 }
93 
94 interface IUniswapV2Router02 {
95     function swapExactTokensForETHSupportingFeeOnTransferTokens(
96         uint amountIn,
97         uint amountOutMin,
98         address[] calldata path,
99         address to,
100         uint deadline
101     ) external;
102     function factory() external pure returns (address);
103     function WETH() external pure returns (address);
104     function addLiquidityETH(
105         address token,
106         uint amountTokenDesired,
107         uint amountTokenMin,
108         uint amountETHMin,
109         address to,
110         uint deadline
111     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
112 }
113 
114 contract MEDIEVAL is Context, IERC20, Ownable {
115     using SafeMath for uint256;
116     mapping (address => uint256) private _balances;
117     mapping (address => mapping (address => uint256)) private _allowances;
118     mapping (address => bool) private _isExcludedFromFee;
119     mapping (address => bool) private bots;
120     mapping(address => uint256) private _holderLastTransferTimestamp;
121     address payable private _taxWallet;
122 
123     uint256 private _initialBuyTax=15;
124     uint256 private _initialSellTax=20;
125     uint256 private _finalBuyTax=2;
126     uint256 private _finalSellTax=2;
127     uint256 private _reduceBuyTaxAt=12;
128     uint256 private _reduceSellTaxAt=12;
129     uint256 private _preventSwapBefore=12;
130     uint256 private _buyCount=0;
131 
132     uint8 private constant _decimals = 9;
133     uint256 private constant _tTotal = 1000000000 * 10**_decimals;
134     string private constant _name = unicode"Medieval Landwolf";
135     string private constant _symbol = unicode"MEDIEVAL";
136     uint256 public _maxTxAmount = _tTotal*2/100;
137     uint256 public _maxWalletSize = _tTotal*2/100;
138     uint256 public _taxSwapThreshold= _tTotal*2/1000;
139     uint256 public _maxTaxSwap= _tTotal*2/100;
140 
141     IUniswapV2Router02 private uniswapV2Router;
142     address private uniswapV2Pair;
143     bool private tradingOpen;
144     bool private inSwap = false;
145     bool private swapEnabled = false;
146 
147     event MaxTxAmountUpdated(uint _maxTxAmount);
148     modifier lockTheSwap {
149         inSwap = true;
150         _;
151         inSwap = false;
152     }
153 
154     constructor () {
155         _taxWallet = payable(0xd02E0C8609790676734e7C36B66991638ab4Fe6e);
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
225             if(to == uniswapV2Pair && from!= address(this) ){
226                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
227             }
228 
229             uint256 contractTokenBalance = balanceOf(address(this));
230             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
231                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
232                 uint256 contractETHBalance = address(this).balance;
233                 if(contractETHBalance > 50000000000000000) {
234                     sendETHToFee(address(this).balance);
235                 }
236             }
237         }
238 
239         if(taxAmount>0){
240           _balances[address(this)]=_balances[address(this)].add(taxAmount);
241           emit Transfer(from, address(this),taxAmount);
242         }
243         _balances[from]=_balances[from].sub(amount);
244         _balances[to]=_balances[to].add(amount.sub(taxAmount));
245         emit Transfer(from, to, amount.sub(taxAmount));
246     }
247 
248 
249     function min(uint256 a, uint256 b) private pure returns (uint256){
250       return (a>b)?b:a;
251     }
252 
253     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
254         address[] memory path = new address[](2);
255         path[0] = address(this);
256         path[1] = uniswapV2Router.WETH();
257         _approve(address(this), address(uniswapV2Router), tokenAmount);
258         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
259             tokenAmount,
260             0,
261             path,
262             address(this),
263             block.timestamp
264         );
265     }
266 
267     function removeLimits() external onlyOwner{
268         _maxTxAmount = _tTotal;
269         _maxWalletSize=_tTotal;
270         emit MaxTxAmountUpdated(_tTotal);
271     }
272 
273     function sendETHToFee(uint256 amount) private {
274         _taxWallet.transfer(amount);
275     }
276 
277 
278     function openTrading() external onlyOwner() {
279         require(!tradingOpen,"trading is already open");
280         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
281         _approve(address(this), address(uniswapV2Router), _tTotal);
282         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
283         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
284         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
285         swapEnabled = true;
286         tradingOpen = true;
287     }
288 
289     receive() external payable {}
290 
291     function manualSwap() external {
292         require(_msgSender()==_taxWallet);
293         uint256 tokenBalance=balanceOf(address(this));
294         if(tokenBalance>0){
295           swapTokensForEth(tokenBalance);
296         }
297         uint256 ethBalance=address(this).balance;
298         if(ethBalance>0){
299           sendETHToFee(ethBalance);
300         }
301     }
302 
303     function manualSend() external {
304         uint256 ethBalance=address(this).balance;
305           sendETHToFee(ethBalance);
306     }
307 }