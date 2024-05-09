1 //SPDX-License-Identifier: UNLICENSED
2 
3 /*
4 
5 ⠸⣷⣦⠤⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣠⣤⠀⠀⠀
6 ⠀⠙⣿⡄⠈⠑⢄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⠔⠊⠉⣿⡿⠁⠀⠀⠀
7 ⠀⠀⠈⠣⡀⠀⠀⠑⢄⠀⠀⠀⠀⠀⠀⠀⠀⠀⡠⠊⠁⠀⠀⣰⠟⠀⠀⠀⣀⣀
8 ⠀⠀⠀⠀⠈⠢⣄⠀⡈⠒⠊⠉⠁⠀⠈⠉⠑⠚⠀⠀⣀⠔⢊⣠⠤⠒⠊⠉⠀⡜
9 ⠀⠀⠀⠀⠀⠀⠀⡽⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠩⡔⠊⠁⠀⠀⠀⠀⠀⠀⠇
10 ⠀⠀⠀⠀⠀⠀⠀⡇⢠⡤⢄⠀⠀⠀⠀⠀⡠⢤⣄⠀⡇⠀⠀⠀⠀⠀⠀⠀⢰⠀
11 ⠀⠀⠀⠀⠀⠀⢀⠇⠹⠿⠟⠀⠀⠤⠀⠀⠻⠿⠟⠀⣇⠀⠀⡀⠠⠄⠒⠊⠁⠀
12 ⠀⠀⠀⠀⠀⠀⢸⣿⣿⡆⠀⠰⠤⠖⠦⠴⠀⢀⣶⣿⣿⠀⠙⢄⠀⠀⠀⠀⠀⠀
13 ⠀⠀⠀⠀⠀⠀⠀⢻⣿⠃⠀⠀⠀⠀⠀⠀⠀⠈⠿⡿⠛⢄⠀⠀⠱⣄⠀⠀⠀⠀
14 ⠀⠀⠀⠀⠀⠀⠀⢸⠈⠓⠦⠀⣀⣀⣀⠀⡠⠴⠊⠹⡞⣁⠤⠒⠉⠀⠀⠀⠀⠀
15 ⠀⠀⠀⠀⠀⠀⣠⠃⠀⠀⠀⠀⡌⠉⠉⡤⠀⠀⠀⠀⢻⠿⠆⠀⠀⠀⠀⠀⠀⠀
16 ⠀⠀⠀⠀⠀⠰⠁⡀⠀⠀⠀⠀⢸⠀⢰⠃⠀⠀⠀⢠⠀⢣⠀⠀⠀⠀⠀⠀⠀⠀
17 ⠀⠀⠀⢶⣗⠧⡀⢳⠀⠀⠀⠀⢸⣀⣸⠀⠀⠀⢀⡜⠀⣸⢤⣶⠀⠀⠀⠀⠀⠀
18 ⠀⠀⠀⠈⠻⣿⣦⣈⣧⡀⠀⠀⢸⣿⣿⠀⠀⢀⣼⡀⣨⣿⡿⠁⠀⠀⠀⠀⠀⠀
19 ⠀⠀⠀⠀⠀⠈⠻⠿⠿⠓⠄⠤⠘⠉⠙⠤⢀⠾⠿⣿⠟⠋
20 
21 Website: https://www.hpop10i.org/
22 Twitter: https://twitter.com/hpop10iLitecoin
23 Telegram: https://t.me/hpop10i
24 
25 */
26 
27 pragma solidity 0.8.20;
28 
29 abstract contract Context {
30     function _msgSender() internal view virtual returns (address) {
31         return msg.sender;
32     }
33 }
34 
35 interface IERC20 {
36     function totalSupply() external view returns (uint256);
37     function balanceOf(address account) external view returns (uint256);
38     function transfer(address recipient, uint256 amount) external returns (bool);
39     function allowance(address owner, address spender) external view returns (uint256);
40     function approve(address spender, uint256 amount) external returns (bool);
41     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
42     event Transfer(address indexed from, address indexed to, uint256 value);
43     event Approval(address indexed owner, address indexed spender, uint256 value);
44 }
45 
46 library SafeMath {
47     function add(uint256 a, uint256 b) internal pure returns (uint256) {
48         uint256 c = a + b;
49         require(c >= a, "SafeMath: addition overflow");
50         return c;
51     }
52 
53     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
54         return sub(a, b, "SafeMath: subtraction overflow");
55     }
56 
57     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
58         require(b <= a, errorMessage);
59         uint256 c = a - b;
60         return c;
61     }
62 
63     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
64         if (a == 0) {
65             return 0;
66         }
67         uint256 c = a * b;
68         require(c / a == b, "SafeMath: multiplication overflow");
69         return c;
70     }
71 
72     function div(uint256 a, uint256 b) internal pure returns (uint256) {
73         return div(a, b, "SafeMath: division by zero");
74     }
75 
76     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
77         require(b > 0, errorMessage);
78         uint256 c = a / b;
79         return c;
80     }
81 
82 }
83 
84 contract Ownable is Context {
85     address private _owner;
86     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
87 
88     constructor () {
89         address msgSender = _msgSender();
90         _owner = msgSender;
91         emit OwnershipTransferred(address(0), msgSender);
92     }
93 
94     function owner() public view returns (address) {
95         return _owner;
96     }
97 
98     modifier onlyOwner() {
99         require(_owner == _msgSender(), "Ownable: caller is not the owner");
100         _;
101     }
102 
103     function renounceOwnership() public virtual onlyOwner {
104         emit OwnershipTransferred(_owner, address(0));
105         _owner = address(0);
106     }
107 
108 }
109 
110 interface IUniswapV2Factory {
111     function createPair(address tokenA, address tokenB) external returns (address pair);
112 }
113 
114 interface IUniswapV2Router02 {
115     function swapExactTokensForETHSupportingFeeOnTransferTokens(
116         uint amountIn,
117         uint amountOutMin,
118         address[] calldata path,
119         address to,
120         uint deadline
121     ) external;
122     function factory() external pure returns (address);
123     function WETH() external pure returns (address);
124     function addLiquidityETH(
125         address token,
126         uint amountTokenDesired,
127         uint amountTokenMin,
128         uint amountETHMin,
129         address to,
130         uint deadline
131     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
132 }
133 
134 contract Litecoin is Context, IERC20, Ownable {
135     using SafeMath for uint256;
136     mapping (address => uint256) private _balances;
137     mapping (address => mapping (address => uint256)) private _allowances;
138     mapping (address => bool) private _isExcludedFromFee;
139     address payable private _taxWallet;
140     uint256 firstBlock;
141 
142     uint256 private _initialBuyTax=35;
143     uint256 private _initialSellTax=35;
144     uint256 private _finalBuyTax=2;
145     uint256 private _finalSellTax=2;
146     uint256 private _reduceBuyTaxAt=69;
147     uint256 private _reduceSellTaxAt=69;
148     uint256 private _buyCount=0;
149 
150     uint8 private constant _decimals = 9;
151     uint256 private constant _tTotal = 1000000 * 10**_decimals;
152     string private constant _name = unicode"HarryPotterObamaPikachu10Inu";
153     string private constant _symbol = unicode"LITECOIN";
154     uint256 public _maxTxAmount =   20000 * 10**_decimals;
155     uint256 public _maxWalletSize = 20000 * 10**_decimals;
156     uint256 public _taxSwapThreshold= 6000 * 10**_decimals;
157     uint256 public _maxTaxSwap= 6000 * 10**_decimals;
158 
159     IUniswapV2Router02 private uniswapV2Router;
160     address private uniswapV2Pair;
161     bool private tradingOpen;
162     bool private inSwap = false;
163     bool private swapEnabled = false;
164 
165     event MaxTxAmountUpdated(uint _maxTxAmount);
166     modifier lockTheSwap {
167         inSwap = true;
168         _;
169         inSwap = false;
170     }
171 
172     constructor () {
173 
174         _taxWallet = payable(_msgSender());
175         _balances[_msgSender()] = _tTotal;
176         _isExcludedFromFee[owner()] = true;
177         _isExcludedFromFee[address(this)] = true;
178         _isExcludedFromFee[_taxWallet] = true;
179         
180         emit Transfer(address(0), _msgSender(), _tTotal);
181     }
182 
183     function name() public pure returns (string memory) {
184         return _name;
185     }
186 
187     function symbol() public pure returns (string memory) {
188         return _symbol;
189     }
190 
191     function decimals() public pure returns (uint8) {
192         return _decimals;
193     }
194 
195     function totalSupply() public pure override returns (uint256) {
196         return _tTotal;
197     }
198 
199     function balanceOf(address account) public view override returns (uint256) {
200         return _balances[account];
201     }
202 
203     function transfer(address recipient, uint256 amount) public override returns (bool) {
204         _transfer(_msgSender(), recipient, amount);
205         return true;
206     }
207 
208     function allowance(address owner, address spender) public view override returns (uint256) {
209         return _allowances[owner][spender];
210     }
211 
212     function approve(address spender, uint256 amount) public override returns (bool) {
213         _approve(_msgSender(), spender, amount);
214         return true;
215     }
216 
217     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
218         _transfer(sender, recipient, amount);
219         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
220         return true;
221     }
222 
223     function _approve(address owner, address spender, uint256 amount) private {
224         require(owner != address(0), "ERC20: approve from the zero address");
225         require(spender != address(0), "ERC20: approve to the zero address");
226         _allowances[owner][spender] = amount;
227         emit Approval(owner, spender, amount);
228     }
229 
230     function _transfer(address from, address to, uint256 amount) private {
231         require(from != address(0), "ERC20: transfer from the zero address");
232         require(to != address(0), "ERC20: transfer to the zero address");
233         require(amount > 0, "Transfer amount must be greater than zero");
234         uint256 taxAmount=0;
235         if (from != owner() && to != owner()) {
236             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
237 
238             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
239                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
240                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
241 
242                 if (firstBlock + 3  > block.number) {
243                     require(!isContract(to));
244                 }
245                 _buyCount++;
246             }
247 
248             if (to != uniswapV2Pair && ! _isExcludedFromFee[to]) {
249                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
250             }
251 
252             if(to == uniswapV2Pair && from!= address(this) ){
253                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
254             }
255 
256             uint256 contractTokenBalance = balanceOf(address(this));
257             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold) {
258                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
259                 uint256 contractETHBalance = address(this).balance;
260                 if(contractETHBalance > 0) {
261                     sendETHToFee(address(this).balance);
262                 }
263             }
264         }
265 
266         if(taxAmount>0){
267           _balances[address(this)]=_balances[address(this)].add(taxAmount);
268           emit Transfer(from, address(this),taxAmount);
269         }
270         _balances[from]=_balances[from].sub(amount);
271         _balances[to]=_balances[to].add(amount.sub(taxAmount));
272         emit Transfer(from, to, amount.sub(taxAmount));
273     }
274 
275 
276     function min(uint256 a, uint256 b) private pure returns (uint256){
277       return (a>b)?b:a;
278     }
279 
280     function isContract(address account) private view returns (bool) {
281         uint256 size;
282         assembly {
283             size := extcodesize(account)
284         }
285         return size > 0;
286     }
287 
288     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
289         address[] memory path = new address[](2);
290         path[0] = address(this);
291         path[1] = uniswapV2Router.WETH();
292         _approve(address(this), address(uniswapV2Router), tokenAmount);
293         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
294             tokenAmount,
295             0,
296             path,
297             address(this),
298             block.timestamp
299         );
300     }
301 
302     function removeLimits() external onlyOwner{
303         _maxTxAmount = _tTotal;
304         _maxWalletSize=_tTotal;
305         _reduceSellTaxAt=20;
306         _reduceBuyTaxAt=20;
307         emit MaxTxAmountUpdated(_tTotal);
308     }
309 
310     function sendETHToFee(uint256 amount) private {
311         _taxWallet.transfer(amount);
312     }
313 
314     function openTrading() external onlyOwner() {
315         require(!tradingOpen,"trading is already open");
316         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
317         _approve(address(this), address(uniswapV2Router), _tTotal);
318         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
319         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
320         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
321         swapEnabled = true;
322         tradingOpen = true;
323         firstBlock = block.number;
324     }
325 
326     receive() external payable {}
327 }