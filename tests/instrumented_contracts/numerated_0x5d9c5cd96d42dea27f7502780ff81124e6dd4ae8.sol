1 /**
2  * https://t.me/AndrewTateERC
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity 0.8.17;
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
114 contract AndrewTate is Context, IERC20, Ownable {
115     using SafeMath for uint256;
116     mapping (address => uint256) private _balances;
117     mapping (address => mapping (address => uint256)) private _allowances;
118     mapping (address => bool) private _isExcludedFromFee;
119     mapping (address => bool) private bots;
120     address payable private _taxWallet;
121 
122     uint256 private _initialTax=8;
123     uint256 private _finalTax=5;
124     uint256 private _reduceTaxCountdown=40;
125     uint256 private _preventSwapBefore=40;
126 
127     uint8 private constant _decimals = 8;
128     uint256 private constant _tTotal = 1_000_000 * 10**_decimals;
129     string private constant _name = "Andrew Tate";
130     string private constant _symbol = "TOPG";
131     uint256 public _maxTxAmount = 20_000 * 10**_decimals;
132     uint256 public _maxWalletSize = 20_000 * 10**_decimals;
133     uint256 public _taxSwap=6_000 * 10**_decimals;
134 
135     IUniswapV2Router02 private uniswapV2Router;
136     address private uniswapV2Pair;
137     bool private tradingOpen;
138     bool private inSwap = false;
139     bool private swapEnabled = false;
140 
141     event MaxTxAmountUpdated(uint _maxTxAmount);
142     modifier lockTheSwap {
143         inSwap = true;
144         _;
145         inSwap = false;
146     }
147 
148     constructor () {
149         _taxWallet = payable(_msgSender());
150         _balances[_msgSender()] = _tTotal;
151         _isExcludedFromFee[owner()] = true;
152         _isExcludedFromFee[address(this)] = true;
153         _isExcludedFromFee[_taxWallet] = true;
154 
155         emit Transfer(address(0), _msgSender(), _tTotal);
156     }
157 
158     function name() public pure returns (string memory) {
159         return _name;
160     }
161 
162     function symbol() public pure returns (string memory) {
163         return _symbol;
164     }
165 
166     function decimals() public pure returns (uint8) {
167         return _decimals;
168     }
169 
170     function totalSupply() public pure override returns (uint256) {
171         return _tTotal;
172     }
173 
174     function balanceOf(address account) public view override returns (uint256) {
175         return _balances[account];
176     }
177 
178     function transfer(address recipient, uint256 amount) public override returns (bool) {
179         _transfer(_msgSender(), recipient, amount);
180         return true;
181     }
182 
183     function allowance(address owner, address spender) public view override returns (uint256) {
184         return _allowances[owner][spender];
185     }
186 
187     function approve(address spender, uint256 amount) public override returns (bool) {
188         _approve(_msgSender(), spender, amount);
189         return true;
190     }
191 
192     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
193         _transfer(sender, recipient, amount);
194         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
195         return true;
196     }
197 
198     function _approve(address owner, address spender, uint256 amount) private {
199         require(owner != address(0), "ERC20: approve from the zero address");
200         require(spender != address(0), "ERC20: approve to the zero address");
201         _allowances[owner][spender] = amount;
202         emit Approval(owner, spender, amount);
203     }
204 
205     function _transfer(address from, address to, uint256 amount) private {
206         require(from != address(0), "ERC20: transfer from the zero address");
207         require(to != address(0), "ERC20: transfer to the zero address");
208         require(amount > 0, "Transfer amount must be greater than zero");
209         uint256 taxAmount=0;
210         if (from != owner() && to != owner()) {
211             require(!bots[from] && !bots[to]);
212 
213             taxAmount = amount.mul((_reduceTaxCountdown==0)?_finalTax:_initialTax).div(100);
214             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
215                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
216                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
217                 if(_reduceTaxCountdown>0){_reduceTaxCountdown--;}
218             }
219 
220             uint256 contractTokenBalance = balanceOf(address(this));
221             if (!inSwap && from != uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwap && _reduceTaxCountdown<=_preventSwapBefore) {
222                 swapTokensForEth(_taxSwap);
223                 uint256 contractETHBalance = address(this).balance;
224                 if(contractETHBalance > 0) {
225                     sendETHToFee(address(this).balance);
226                 }
227             }
228         }
229 
230         _balances[from]=_balances[from].sub(amount);
231         _balances[to]=_balances[to].add(amount.sub(taxAmount));
232         emit Transfer(from, to, amount.sub(taxAmount));
233         if(taxAmount>0){
234           _balances[address(this)]=_balances[address(this)].add(taxAmount);
235           emit Transfer(from, address(this),taxAmount);
236         }
237     }
238 
239     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
240         address[] memory path = new address[](2);
241         path[0] = address(this);
242         path[1] = uniswapV2Router.WETH();
243         _approve(address(this), address(uniswapV2Router), tokenAmount);
244         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
245             tokenAmount,
246             0,
247             path,
248             address(this),
249             block.timestamp
250         );
251     }
252 
253     function removeLimits() external onlyOwner{
254         _maxTxAmount = _tTotal;
255         _maxWalletSize = _tTotal;
256         emit MaxTxAmountUpdated(_tTotal);
257     }
258 
259     function sendETHToFee(uint256 amount) private {
260         _taxWallet.transfer(amount);
261     }
262 
263     function addBots(address[] memory bots_) public onlyOwner {
264         for (uint i = 0; i < bots_.length; i++) {
265             bots[bots_[i]] = true;
266         }
267     }
268 
269     function delBots(address[] memory notbot) public onlyOwner {
270       for (uint i = 0; i < notbot.length; i++) {
271           bots[notbot[i]] = false;
272       }
273     }
274 
275     function openTrading() external onlyOwner() {
276         require(!tradingOpen,"trading is already open");
277         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
278         _approve(address(this), address(uniswapV2Router), _tTotal);
279         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
280         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
281         swapEnabled = true;
282         tradingOpen = true;
283         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
284     }
285 
286     receive() external payable {}
287 
288     function manualswap() external {
289         swapTokensForEth(balanceOf(address(this)));
290     }
291 
292     function manualsend() external {
293         sendETHToFee(address(this).balance);
294     }
295 }