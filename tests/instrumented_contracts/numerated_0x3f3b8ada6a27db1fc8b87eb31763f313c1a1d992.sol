1 /*
2   
3   TWITTER: https://twitter.com/fathercoineth
4   
5   TELEGRAM: https://t.me/fathercoineth
6   
7   WEBSITE: https://fathererc.com
8 
9 */
10 
11 
12 // SPDX-License-Identifier: MIT
13 pragma solidity 0.8.17;
14 
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19 }
20 
21 interface IERC20 {
22     function totalSupply() external view returns (uint256);
23     function balanceOf(address account) external view returns (uint256);
24     function transfer(address recipient, uint256 amount) external returns (bool);
25     function allowance(address owner, address spender) external view returns (uint256);
26     function approve(address spender, uint256 amount) external returns (bool);
27     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
28     event Transfer(address indexed from, address indexed to, uint256 value);
29     event Approval(address indexed owner, address indexed spender, uint256 value);
30 }
31 
32 library SafeMath {
33     function add(uint256 a, uint256 b) internal pure returns (uint256) {
34         uint256 c = a + b;
35         require(c >= a, "SafeMath: addition overflow");
36         return c;
37     }
38 
39     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40         return sub(a, b, "SafeMath: subtraction overflow");
41     }
42 
43     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
44         require(b <= a, errorMessage);
45         uint256 c = a - b;
46         return c;
47     }
48 
49     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
50         if (a == 0) {
51             return 0;
52         }
53         uint256 c = a * b;
54         require(c / a == b, "SafeMath: multiplication overflow");
55         return c;
56     }
57 
58     function div(uint256 a, uint256 b) internal pure returns (uint256) {
59         return div(a, b, "SafeMath: division by zero");
60     }
61 
62     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
63         require(b > 0, errorMessage);
64         uint256 c = a / b;
65         return c;
66     }
67 
68 }
69 
70 contract Ownable is Context {
71     address private _owner;
72     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
73 
74     constructor () {
75         address msgSender = _msgSender();
76         _owner = msgSender;
77         emit OwnershipTransferred(address(0), msgSender);
78     }
79 
80     function owner() public view returns (address) {
81         return _owner;
82     }
83 
84     modifier onlyOwner() {
85         require(_owner == _msgSender(), "Ownable: caller is not the owner");
86         _;
87     }
88 
89     function renounceOwnership() public virtual onlyOwner {
90         emit OwnershipTransferred(_owner, address(0));
91         _owner = address(0);
92     }
93 
94 }
95 
96 interface IUniswapV2Factory {
97     function createPair(address tokenA, address tokenB) external returns (address pair);
98 }
99 
100 interface IUniswapV2Router02 {
101     function swapExactTokensForETHSupportingFeeOnTransferTokens(
102         uint amountIn,
103         uint amountOutMin,
104         address[] calldata path,
105         address to,
106         uint deadline
107     ) external;
108     function factory() external pure returns (address);
109     function WETH() external pure returns (address);
110 }
111 
112 contract father is Context , IERC20, Ownable {
113     using SafeMath for uint256;
114 
115     mapping (address => uint256) private _balances;
116     mapping (address => mapping (address => uint256)) private _allowances;
117     mapping (address => bool) private _isExcludedFromFee;
118     mapping (address => bool) private bots;
119     address payable private _taxwallet;
120     uint8 private constant _decimals = 9;
121 
122     string private constant _name = "FATHER";
123     string private constant _symbol = "FATHER";
124 
125     uint256 private _buyTax = 25;
126     uint256 private _sellTax = 35;
127 
128     uint256 private constant _tTotal = 420_420_420_690_690_690 * 10**_decimals;
129     uint256 public _maxTxAmount = 2 * (_tTotal/100);
130     uint256 public _maxWalletSize = 2 * (_tTotal/100);
131     uint256 public _taxSwapThreshold = 1 * (_tTotal/1000);
132 
133     IUniswapV2Router02 public uniswapV2Router;
134     address public uniswapV2Pair;
135     bool private tradingOpen = true;
136     bool private inSwap = false;
137     bool private swapEnabled = true;
138 
139     event MaxTxAmountUpdated(uint _maxTxAmount);
140     modifier lockTheSwap {
141         inSwap = true;
142         _;
143         inSwap = false;
144     }
145 
146     constructor () {
147         _balances[_msgSender()] = _tTotal;
148 
149         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
150         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
151         
152         _taxwallet = payable(_msgSender());
153         _isExcludedFromFee[owner()] = true;
154         _isExcludedFromFee[address(this)] = true;
155         _isExcludedFromFee[_taxwallet] = true;
156 
157         emit Transfer(address(0), _msgSender(), _tTotal);
158     }
159 
160     function name() public pure returns (string memory) {
161         return _name;
162     }
163 
164     function symbol() public pure returns (string memory) {
165         return _symbol;
166     }
167 
168     function decimals() public pure returns (uint8) {
169         return _decimals;
170     }
171 
172     function totalSupply() public pure override returns (uint256) {
173         return _tTotal;
174     }
175 
176     function balanceOf(address account) public view override returns (uint256) {
177         return _balances[account];
178     }
179 
180     function transfer(address recipient, uint256 amount) public override returns (bool) {
181         _transfer(_msgSender(), recipient, amount);
182         return true;
183     }
184 
185     function allowance(address owner, address spender) public view override returns (uint256) {
186         return _allowances[owner][spender];
187     }
188 
189     function approve(address spender, uint256 amount) public override returns (bool) {
190         _approve(_msgSender(), spender, amount);
191         return true;
192     }
193 
194     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
195         _transfer(sender, recipient, amount);
196         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
197         return true;
198     }
199 
200     function _approve(address owner, address spender, uint256 amount) private {
201         require(owner != address(0), "ERC20: approve from the zero address");
202         require(spender != address(0), "ERC20: approve to the zero address");
203         _allowances[owner][spender] = amount;
204         emit Approval(owner, spender, amount);
205     }
206 
207     function _transfer(address from, address to, uint256 amount) private {
208         require(from != address(0), "ERC20: transfer from the zero address");
209         require(to != address(0), "ERC20: transfer to the zero address");
210         require(amount > 0, "Transfer amount must be greater than zero");
211         uint256 taxAmount=0;
212         if (from != owner() && to != owner()) {
213             require(tradingOpen == true, "ERC20: This account cannot send tokens until trading is enabled");
214             require(!bots[from] && !bots[to], "ERC20: Wallet is blacklist!");
215             taxAmount = amount.mul(_buyTax).div(100);
216 
217             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
218                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
219                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
220             }
221 
222             if(to == uniswapV2Pair && from!= address(this) ){
223                 taxAmount = amount.mul(_sellTax).div(100);
224             }
225 
226             uint256 contractTokenBalance = balanceOf(address(this));
227             if(contractTokenBalance >= _maxTxAmount) {
228                 contractTokenBalance = _maxTxAmount;
229             }
230             if (!inSwap && to  == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold) {
231                 swapTokensForEth(contractTokenBalance);
232                 uint256 contractETHBalance = address(this).balance;
233                 if(contractETHBalance > 0) {
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
248     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
249         address[] memory path = new address[](2);
250         path[0] = address(this);
251         path[1] = uniswapV2Router.WETH();
252         _approve(address(this), address(uniswapV2Router), tokenAmount);
253         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
254             tokenAmount,
255             0,
256             path,
257             address(this),
258             block.timestamp
259         );
260     }
261 
262     function removeLimits() external onlyOwner {
263         _maxTxAmount = _tTotal;
264         _maxWalletSize=_tTotal;
265         emit MaxTxAmountUpdated(_tTotal);
266     }
267 
268     function sendETHToFee(uint256 amount) private {
269         _taxwallet.transfer(amount);
270     }
271 
272     function openTrading() external onlyOwner {
273         require(tradingOpen == false, "Trading is enabled!");
274         tradingOpen = true;
275     }
276     
277     function setFee(uint256 _buy, uint256 _sell ) external onlyOwner {
278       _buyTax = _buy;
279       _sellTax = _sell;
280     }
281 
282     receive() external payable {}
283 
284     function manualSwap() external {
285         require(_msgSender()==_taxwallet);
286         uint256 tokenBalance=balanceOf(address(this));
287         if(tokenBalance>0){
288           swapTokensForEth(tokenBalance);
289         }
290         uint256 ethBalance=address(this).balance;
291         if(ethBalance>0){
292           sendETHToFee(ethBalance);
293         }
294     }
295 }