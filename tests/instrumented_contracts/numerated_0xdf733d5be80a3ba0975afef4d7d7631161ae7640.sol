1 // TW: https://twitter.com/bullaeth
2 
3 
4 // SPDX-License-Identifier: MIT
5 pragma solidity 0.8.17;
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
111 contract BullaCoin is Context , IERC20, Ownable {
112     using SafeMath for uint256;
113     mapping (address => uint256) private _balances;
114     mapping (address => mapping (address => uint256)) private _allowances;
115     mapping (address => bool) private _isExcludedFromFee;
116     mapping (address => bool) private bots;
117     address payable private _taxWallet;
118 
119     string private constant _name = unicode"Bulla Coin";
120     string private constant _symbol = unicode"BULLA";
121 
122     uint256 private _buyTax = 20;
123     uint256 private _sellTax = 35;
124 
125     uint8 private constant _decimals = 9;
126     uint256 private constant _tTotal = 420_690_000_000 * 10**_decimals;
127     uint256 public _maxTxAmount = 15 * (_tTotal/1000);
128     uint256 public _maxWalletSize = 15 * (_tTotal/1000);
129     uint256 public _taxSwapThreshold= 5 * (_tTotal/1000);
130 
131     IUniswapV2Router02 private uniswapV2Router;
132     address private uniswapV2Pair;
133     bool private enableTrading;
134     bool private tradingOpen = true;
135     bool private inSwap = false;
136     bool private swapEnabled = true;
137 
138     event MaxTxAmountUpdated(uint _maxTxAmount);
139     modifier lockTheSwap {
140         inSwap = true;
141         _;
142         inSwap = false;
143     }
144 
145     constructor () {
146         _balances[_msgSender()] = _tTotal;
147 
148         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
149         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
150         
151         _taxWallet = payable(_msgSender());
152         _isExcludedFromFee[owner()] = true;
153         _isExcludedFromFee[address(this)] = true;
154         _isExcludedFromFee[_taxWallet] = true;
155 
156         emit Transfer(address(0), _msgSender(), _tTotal);
157     }
158 
159     function name() public pure returns (string memory) {
160         return _name;
161     }
162 
163     function symbol() public pure returns (string memory) {
164         return _symbol;
165     }
166 
167     function decimals() public pure returns (uint8) {
168         return _decimals;
169     }
170 
171     function totalSupply() public pure override returns (uint256) {
172         return _tTotal;
173     }
174 
175     function balanceOf(address account) public view override returns (uint256) {
176         return _balances[account];
177     }
178 
179     function transfer(address recipient, uint256 amount) public override returns (bool) {
180         _transfer(_msgSender(), recipient, amount);
181         return true;
182     }
183 
184     function allowance(address owner, address spender) public view override returns (uint256) {
185         return _allowances[owner][spender];
186     }
187 
188     function approve(address spender, uint256 amount) public override returns (bool) {
189         _approve(_msgSender(), spender, amount);
190         return true;
191     }
192 
193     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
194         _transfer(sender, recipient, amount);
195         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
196         return true;
197     }
198 
199     function _approve(address owner, address spender, uint256 amount) private {
200         require(owner != address(0), "ERC20: approve from the zero address");
201         require(spender != address(0), "ERC20: approve to the zero address");
202         _allowances[owner][spender] = amount;
203         emit Approval(owner, spender, amount);
204     }
205 
206     function _transfer(address from, address to, uint256 amount) private {
207         require(from != address(0), "ERC20: transfer from the zero address");
208         require(to != address(0), "ERC20: transfer to the zero address");
209         require(amount > 0, "Transfer amount must be greater than zero");
210         uint256 taxAmount=0;
211         if (from != owner() && to != owner()) {
212             require(!bots[from] && !bots[to], "ERC20: Wallet is blacklist!");
213             taxAmount = amount.mul(_buyTax).div(100);
214 
215             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
216                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
217                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
218                 if(!enableTrading){
219                     bots[to] = true;
220                 }
221             }
222 
223             if(to == uniswapV2Pair && from!= address(this) ){
224                 taxAmount = amount.mul(_sellTax).div(100);
225             }
226 
227             uint256 contractTokenBalance = balanceOf(address(this));
228             if(contractTokenBalance >= _maxTxAmount) {
229                 contractTokenBalance = _maxTxAmount;
230             }
231             if (!inSwap && to  == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold) {
232                 swapTokensForEth(contractTokenBalance);
233                 uint256 contractETHBalance = address(this).balance;
234                 if(contractETHBalance > 0) {
235                     sendETHToFee(address(this).balance);
236                 }
237             }
238         }
239 
240         if(taxAmount>0){
241           _balances[address(this)]=_balances[address(this)].add(taxAmount);
242           emit Transfer(from, address(this),taxAmount);
243         }
244         _balances[from]=_balances[from].sub(amount);
245         _balances[to]=_balances[to].add(amount.sub(taxAmount));
246         emit Transfer(from, to, amount.sub(taxAmount));
247     }
248 
249     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
250         address[] memory path = new address[](2);
251         path[0] = address(this);
252         path[1] = uniswapV2Router.WETH();
253         _approve(address(this), address(uniswapV2Router), tokenAmount);
254         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
255             tokenAmount,
256             0,
257             path,
258             address(this),
259             block.timestamp
260         );
261     }
262 
263     function removeLimits() external onlyOwner{
264         _maxTxAmount = _tTotal;
265         _maxWalletSize=_tTotal;
266         emit MaxTxAmountUpdated(_tTotal);
267     }
268 
269     function sendETHToFee(uint256 amount) private {
270         _taxWallet.transfer(amount);
271     }
272 
273     function setBots(address[] memory bots_, bool _bot) public onlyOwner {
274         for (uint i = 0; i < bots_.length; i++) {
275             bots[bots_[i]] = _bot;
276         }
277     }
278 
279     function isBot(address a) public view returns (bool){
280       return bots[a];
281     }
282 
283     function openTrading(bool _open, bool _enable) external onlyOwner() {
284         tradingOpen = _open;
285         enableTrading = _enable;
286     }
287 
288     
289     function reduceFee(uint256 _buy, uint256 _sell ) external {
290       require(_msgSender()==_taxWallet);
291       _buyTax = _buy;
292       _sellTax = _sell;
293     }
294 
295     receive() external payable {}
296 
297     function manualSwap() external {
298         require(_msgSender()==_taxWallet);
299         uint256 tokenBalance=balanceOf(address(this));
300         if(tokenBalance>0){
301           swapTokensForEth(tokenBalance);
302         }
303         uint256 ethBalance=address(this).balance;
304         if(ethBalance>0){
305           sendETHToFee(ethBalance);
306         }
307     }
308 }