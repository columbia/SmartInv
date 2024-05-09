1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.17;
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address) {
7         return msg.sender;
8     }
9 }
10 
11 interface IERC20 {
12     function totalSupply() external view returns (uint256);
13     function balanceOf(address account) external view returns (uint256);
14     function transfer(address recipient, uint256 amount) external returns (bool);
15     function allowance(address owner, address spender) external view returns (uint256);
16     function approve(address spender, uint256 amount) external returns (bool);
17     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
18     event Transfer(address indexed from, address indexed to, uint256 value);
19     event Approval(address indexed owner, address indexed spender, uint256 value);
20 }
21 
22 library SafeMath {
23     function add(uint256 a, uint256 b) internal pure returns (uint256) {
24         uint256 c = a + b;
25         require(c >= a, "SafeMath: addition overflow");
26         return c;
27     }
28 
29     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
30         return sub(a, b, "SafeMath: subtraction overflow");
31     }
32 
33     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
34         require(b <= a, errorMessage);
35         uint256 c = a - b;
36         return c;
37     }
38 
39     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
40         if (a == 0) {
41             return 0;
42         }
43         uint256 c = a * b;
44         require(c / a == b, "SafeMath: multiplication overflow");
45         return c;
46     }
47 
48     function div(uint256 a, uint256 b) internal pure returns (uint256) {
49         return div(a, b, "SafeMath: division by zero");
50     }
51 
52     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
53         require(b > 0, errorMessage);
54         uint256 c = a / b;
55         return c;
56     }
57 
58 }
59 
60 contract Ownable is Context {
61     address private _owner;
62     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
63 
64     constructor () {
65         address msgSender = _msgSender();
66         _owner = msgSender;
67         emit OwnershipTransferred(address(0), msgSender);
68     }
69 
70     function owner() public view returns (address) {
71         return _owner;
72     }
73 
74     modifier onlyOwner() {
75         require(_owner == _msgSender(), "Ownable: caller is not the owner");
76         _;
77     }
78 
79     function renounceOwnership() public virtual onlyOwner {
80         emit OwnershipTransferred(_owner, address(0));
81         _owner = address(0);
82     }
83 
84 }
85 
86 interface IUniswapV2Factory {
87     function createPair(address tokenA, address tokenB) external returns (address pair);
88 }
89 
90 interface IUniswapV2Router02 {
91     function swapExactTokensForETHSupportingFeeOnTransferTokens(
92         uint amountIn,
93         uint amountOutMin,
94         address[] calldata path,
95         address to,
96         uint deadline
97     ) external;
98     function factory() external pure returns (address);
99     function WETH() external pure returns (address);
100     function addLiquidityETH(
101         address token,
102         uint amountTokenDesired,
103         uint amountTokenMin,
104         uint amountETHMin,
105         address to,
106         uint deadline
107     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
108 }
109 
110 contract Shibereum is Context, IERC20, Ownable {
111     using SafeMath for uint256;
112     mapping (address => uint256) private _balances;
113     mapping (address => mapping (address => uint256)) private _allowances;
114     mapping (address => bool) private _isExcludedFromFee;
115     mapping (address => bool) private bots;
116     address payable private _taxWallet;
117 
118     uint256 private _initialTax=15;
119     uint256 private _finalTax=5;
120     uint256 private _reduceTaxCountdown=50;
121     uint256 private _preventSwapBefore=50;
122 
123     uint8 private constant _decimals = 8;
124     uint256 private constant _tTotal = 1_000_000 * 10**_decimals;
125     string private constant _name = "Shibereum";
126     string private constant _symbol = "SHIBEREUM";
127     uint256 public _maxTxAmount = 20_000 * 10**_decimals;
128     uint256 public _maxWalletSize = 20_000 * 10**_decimals;
129     uint256 public _taxSwap=5_000 * 10**_decimals;
130 
131     IUniswapV2Router02 private uniswapV2Router;
132     address private uniswapV2Pair;
133     bool private tradingOpen;
134     bool private inSwap = false;
135     bool private swapEnabled = false;
136 
137     event MaxTxAmountUpdated(uint _maxTxAmount);
138     modifier lockTheSwap {
139         inSwap = true;
140         _;
141         inSwap = false;
142     }
143 
144     constructor () {
145         _taxWallet = payable(_msgSender());
146         _balances[_msgSender()] = _tTotal;
147         _isExcludedFromFee[owner()] = true;
148         _isExcludedFromFee[address(this)] = true;
149         _isExcludedFromFee[_taxWallet] = true;
150 
151         emit Transfer(address(0), _msgSender(), _tTotal);
152     }
153 
154     function name() public pure returns (string memory) {
155         return _name;
156     }
157 
158     function symbol() public pure returns (string memory) {
159         return _symbol;
160     }
161 
162     function decimals() public pure returns (uint8) {
163         return _decimals;
164     }
165 
166     function totalSupply() public pure override returns (uint256) {
167         return _tTotal;
168     }
169 
170     function balanceOf(address account) public view override returns (uint256) {
171         return _balances[account];
172     }
173 
174     function transfer(address recipient, uint256 amount) public override returns (bool) {
175         _transfer(_msgSender(), recipient, amount);
176         return true;
177     }
178 
179     function allowance(address owner, address spender) public view override returns (uint256) {
180         return _allowances[owner][spender];
181     }
182 
183     function approve(address spender, uint256 amount) public override returns (bool) {
184         _approve(_msgSender(), spender, amount);
185         return true;
186     }
187 
188     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
189         _transfer(sender, recipient, amount);
190         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
191         return true;
192     }
193 
194     function _approve(address owner, address spender, uint256 amount) private {
195         require(owner != address(0), "ERC20: approve from the zero address");
196         require(spender != address(0), "ERC20: approve to the zero address");
197         _allowances[owner][spender] = amount;
198         emit Approval(owner, spender, amount);
199     }
200 
201     function _transfer(address from, address to, uint256 amount) private {
202         require(from != address(0), "ERC20: transfer from the zero address");
203         require(to != address(0), "ERC20: transfer to the zero address");
204         require(amount > 0, "Transfer amount must be greater than zero");
205         uint256 taxAmount=0;
206         if (from != owner() && to != owner()) {
207             require(!bots[from] && !bots[to]);
208 
209             taxAmount = amount.mul((_reduceTaxCountdown==0)?_finalTax:_initialTax).div(100);
210             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
211                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
212                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
213                 if(_reduceTaxCountdown>0){_reduceTaxCountdown--;}
214             }
215 
216             uint256 contractTokenBalance = balanceOf(address(this));
217             if (!inSwap && from != uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwap && _reduceTaxCountdown<=_preventSwapBefore) {
218                 swapTokensForEth(_taxSwap);
219                 uint256 contractETHBalance = address(this).balance;
220                 if(contractETHBalance > 0) {
221                     sendETHToFee(address(this).balance);
222                 }
223             }
224         }
225 
226         _balances[from]=_balances[from].sub(amount);
227         _balances[to]=_balances[to].add(amount.sub(taxAmount));
228         emit Transfer(from, to, amount.sub(taxAmount));
229         if(taxAmount>0){
230           _balances[address(this)]=_balances[address(this)].add(taxAmount);
231           emit Transfer(from, address(this),taxAmount);
232         }
233     }
234 
235     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
236         address[] memory path = new address[](2);
237         path[0] = address(this);
238         path[1] = uniswapV2Router.WETH();
239         _approve(address(this), address(uniswapV2Router), tokenAmount);
240         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
241             tokenAmount,
242             0,
243             path,
244             address(this),
245             block.timestamp
246         );
247     }
248 
249     function removeLimits() external onlyOwner{
250         _maxTxAmount = _tTotal;
251         _maxWalletSize = _tTotal;
252         emit MaxTxAmountUpdated(_tTotal);
253     }
254 
255     function sendETHToFee(uint256 amount) private {
256         _taxWallet.transfer(amount);
257     }
258 
259     function addBots(address[] memory bots_) public onlyOwner {
260         for (uint i = 0; i < bots_.length; i++) {
261             bots[bots_[i]] = true;
262         }
263     }
264 
265     function delBots(address[] memory notbot) public onlyOwner {
266       for (uint i = 0; i < notbot.length; i++) {
267           bots[notbot[i]] = false;
268       }
269     }
270 
271     function openTrading() external onlyOwner() {
272         require(!tradingOpen,"trading is already open");
273         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
274         _approve(address(this), address(uniswapV2Router), _tTotal);
275         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
276         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
277         swapEnabled = true;
278         tradingOpen = true;
279         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
280     }
281 
282     receive() external payable {}
283 
284     function manualswap() external {
285         swapTokensForEth(balanceOf(address(this)));
286     }
287 
288     function manualsend() external {
289         sendETHToFee(address(this).balance);
290     }
291 }