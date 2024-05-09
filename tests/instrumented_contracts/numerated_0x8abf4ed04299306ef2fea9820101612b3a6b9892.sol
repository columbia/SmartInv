1 /**
2 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
3 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣶⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
4 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⣿⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
5 ⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⣿⣿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
6 ⠀⠀⠀⠀⠀⠀⢀⣴⣿⣿⣿⣿⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
7 ⠀⠀⠀⠀⠀⢠⣾⣿⣿⣿⣿⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
8 ⠀⠀⠀⠀⣠⣿⣿⣿⣿⣿⣿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
9 ⠀⠀⠀⣰⣿⣿⣿⣿⣿⣿⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
10 ⠀⠀⢠⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
11 ⠀⠀⣾⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
12 ⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
13 ⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
14 ⢀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
15 ⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
16 ⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
17 ⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
18 ⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
19 ⠀⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠
20 ⠀⠘⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⡟
21 ⠀⠀⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣾⣿⠁
22 ⠀⠀⠈⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣾⣿⣿⠇⠀
23 ⠀⠀⠀⠈⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣤⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣴⣿⣿⣿⣿⠏⠀⠀
24 ⠀⠀⠀⠀⠈⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣦⣄⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣤⣶⣿⣿⣿⣿⣿⣿⠋⠀⠀⠀
25 ⠀⠀⠀⠀⠀⠀⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣶⣤⣤⣤⣄⣀⣀⣀⣀⣤⣤⣤⣴⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠁⠀⠀⠀⠀
26 ⠀⠀⠀⠀⠀⠀⠀⠈⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠏⠀⠀⠀⠀⠀⠀
27 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠁⠀⠀⠀⠀⠀⠀⠀
28 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀
29 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠛⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
30 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠛⠿⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠟⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
31 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠉⠛⠛⠛⠿⠿⠿⠿⠿⠿⠟⠛⠛⠋⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
32 
33 
34 https://t.me/moon_erc20
35 
36 */
37 
38 // SPDX-License-Identifier: Unlicensed
39 pragma solidity ^0.8.14;
40 abstract contract Context {
41     function _msgSender() internal view virtual returns (address) {
42         return msg.sender;
43     }
44 }
45 
46 interface IERC20 {
47     function totalSupply() external view returns (uint256);
48 
49     function balanceOf(address account) external view returns (uint256);
50 
51     function transfer(address recipient, uint256 amount) external returns (bool);
52 
53     function allowance(address owner, address spender) external view returns (uint256);
54 
55     function approve(address spender, uint256 amount) external returns (bool);
56 
57     function transferFrom(
58         address sender,
59         address recipient,
60         uint256 amount
61     ) external returns (bool);
62 
63     event Transfer(address indexed from, address indexed to, uint256 value);
64     event Approval(
65         address indexed owner,
66         address indexed spender,
67         uint256 value
68     );
69 }
70 
71 contract Ownable is Context {
72     address private _owner;
73     address private _previousOwner;
74     event OwnershipTransferred(
75         address indexed previousOwner,
76         address indexed newOwner
77     );
78 
79     constructor() {
80         address msgSender = _msgSender();
81         _owner = msgSender;
82         emit OwnershipTransferred(address(0), msgSender);
83     }
84 
85     function owner() public view returns (address) {
86         return _owner;
87     }
88 
89     modifier onlyOwner() {
90         require(_owner == _msgSender(), "Ownable: caller is not the owner");
91         _;
92     }
93 
94     function renounceOwnership() public virtual onlyOwner {
95         emit OwnershipTransferred(_owner, address(0));
96         _owner = address(0);
97     }
98 
99     function transferOwnership(address newOwner) public virtual onlyOwner {
100         require(newOwner != address(0), "Ownable: new owner is the zero address");
101         emit OwnershipTransferred(_owner, newOwner);
102         _owner = newOwner;
103     }
104 
105 }
106 
107 library SafeMath {
108     function add(uint256 a, uint256 b) internal pure returns (uint256) {
109         uint256 c = a + b;
110         require(c >= a, "SafeMath: addition overflow");
111         return c;
112     }
113 
114     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
115         return sub(a, b, "SafeMath: subtraction overflow");
116     }
117 
118     function sub(
119         uint256 a,
120         uint256 b,
121         string memory errorMessage
122     ) internal pure returns (uint256) {
123         require(b <= a, errorMessage);
124         uint256 c = a - b;
125         return c;
126     }
127 
128     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
129         if (a == 0) {
130             return 0;
131         }
132         uint256 c = a * b;
133         require(c / a == b, "SafeMath: multiplication overflow");
134         return c;
135     }
136 
137     function div(uint256 a, uint256 b) internal pure returns (uint256) {
138         return div(a, b, "SafeMath: division by zero");
139     }
140 
141     function div(
142         uint256 a,
143         uint256 b,
144         string memory errorMessage
145     ) internal pure returns (uint256) {
146         require(b > 0, errorMessage);
147         uint256 c = a / b;
148         return c;
149     }
150 }
151 
152 interface IUniswapV2Factory {
153     function createPair(address tokenA, address tokenB)
154         external
155         returns (address pair);
156 }
157 
158 interface IUniswapV2Router02 {
159     function swapExactTokensForETHSupportingFeeOnTransferTokens(
160         uint256 amountIn,
161         uint256 amountOutMin,
162         address[] calldata path,
163         address to,
164         uint256 deadline
165     ) external;
166 
167     function factory() external pure returns (address);
168 
169     function WETH() external pure returns (address);
170 
171     function addLiquidityETH(
172         address token,
173         uint256 amountTokenDesired,
174         uint256 amountTokenMin,
175         uint256 amountETHMin,
176         address to,
177         uint256 deadline
178     )
179         external
180         payable
181         returns (
182             uint256 amountToken,
183             uint256 amountETH,
184             uint256 liquidity
185         );
186 }
187 
188 contract Moon is Context, IERC20, Ownable {
189 
190     using SafeMath for uint256;
191 
192     string private constant _name = "MOON";
193     string private constant _symbol = "MOON";
194     uint8 private constant _decimals = 9;
195 
196     mapping(address => uint256) private _rOwned;
197     mapping(address => uint256) private _tOwned;
198     mapping(address => mapping(address => uint256)) private _allowances;
199     mapping(address => bool) private _isExcludedFromFee;
200     uint256 private constant MAX = ~uint256(0);
201     uint256 private constant _tTotal = 1000000000000000000 * 10**9;
202     uint256 private _rTotal = (MAX - (MAX % _tTotal));
203     uint256 private _tFeeTotal;
204     uint256 private _redisFeeOnBuy = 0;
205     uint256 private _taxFeeOnBuy = 20;
206     uint256 private _redisFeeOnSell = 0;
207     uint256 private _taxFeeOnSell = 45;
208 
209     //Original Fee
210     uint256 private _redisFee = _redisFeeOnSell;
211     uint256 private _taxFee = _taxFeeOnSell;
212 
213     uint256 private _previousredisFee = _redisFee;
214     uint256 private _previoustaxFee = _taxFee;
215 
216     mapping(address => bool) public bots; mapping (address => uint256) public _buyMap;
217     mapping (address => bool) public preTrader;
218     address payable private _developmentAddress = payable(0xF34C1270B29873759ffB1F54035d81DaD6bFb18c);
219     address payable private _marketingAddress = payable(0xF34C1270B29873759ffB1F54035d81DaD6bFb18c);
220 
221     IUniswapV2Router02 public uniswapV2Router;
222     address public uniswapV2Pair;
223 
224     bool private tradingOpen;
225     bool private inSwap = false;
226     bool private swapEnabled = true;
227 
228     uint256 public _maxTxAmount = 10000000000000000 * 10**9;
229     uint256 public _maxWalletSize = 10000000000000000 * 10**9;
230     uint256 public _swapTokensAtAmount = 500000000000 * 10**9;
231 
232     event MaxTxAmountUpdated(uint256 _maxTxAmount);
233     modifier lockTheSwap {
234         inSwap = true;
235         _;
236         inSwap = false;
237     }
238 
239     constructor() {
240 
241         _rOwned[_msgSender()] = _rTotal;
242 
243         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//
244         uniswapV2Router = _uniswapV2Router;
245         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
246             .createPair(address(this), _uniswapV2Router.WETH());
247 
248         _isExcludedFromFee[owner()] = true;
249         _isExcludedFromFee[address(this)] = true;
250         _isExcludedFromFee[_developmentAddress] = true;
251         _isExcludedFromFee[_marketingAddress] = true;
252 
253         emit Transfer(address(0), _msgSender(), _tTotal);
254     }
255 
256     function name() public pure returns (string memory) {
257         return _name;
258     }
259 
260     function symbol() public pure returns (string memory) {
261         return _symbol;
262     }
263 
264     function decimals() public pure returns (uint8) {
265         return _decimals;
266     }
267 
268     function totalSupply() public pure override returns (uint256) {
269         return _tTotal;
270     }
271 
272     function balanceOf(address account) public view override returns (uint256) {
273         return tokenFromReflection(_rOwned[account]);
274     }
275 
276     function transfer(address recipient, uint256 amount)
277         public
278         override
279         returns (bool)
280     {
281         _transfer(_msgSender(), recipient, amount);
282         return true;
283     }
284 
285     function allowance(address owner, address spender)
286         public
287         view
288         override
289         returns (uint256)
290     {
291         return _allowances[owner][spender];
292     }
293 
294     function approve(address spender, uint256 amount)
295         public
296         override
297         returns (bool)
298     {
299         _approve(_msgSender(), spender, amount);
300         return true;
301     }
302 
303     function transferFrom(
304         address sender,
305         address recipient,
306         uint256 amount
307     ) public override returns (bool) {
308         _transfer(sender, recipient, amount);
309         _approve(
310             sender,
311             _msgSender(),
312             _allowances[sender][_msgSender()].sub(
313                 amount,
314                 "ERC20: transfer amount exceeds allowance"
315             )
316         );
317         return true;
318     }
319 
320     function tokenFromReflection(uint256 rAmount)
321         private
322         view
323         returns (uint256)
324     {
325         require(
326             rAmount <= _rTotal,
327             "Amount must be less than total reflections"
328         );
329         uint256 currentRate = _getRate();
330         return rAmount.div(currentRate);
331     }
332 
333     function removeAllFee() private {
334         if (_redisFee == 0 && _taxFee == 0) return;
335 
336         _previousredisFee = _redisFee;
337         _previoustaxFee = _taxFee;
338 
339         _redisFee = 0;
340         _taxFee = 0;
341     }
342 
343     function restoreAllFee() private {
344         _redisFee = _previousredisFee;
345         _taxFee = _previoustaxFee;
346     }
347 
348     function _approve(
349         address owner,
350         address spender,
351         uint256 amount
352     ) private {
353         require(owner != address(0), "ERC20: approve from the zero address");
354         require(spender != address(0), "ERC20: approve to the zero address");
355         _allowances[owner][spender] = amount;
356         emit Approval(owner, spender, amount);
357     }
358 
359     function _transfer(
360         address from,
361         address to,
362         uint256 amount
363     ) private {
364         require(from != address(0), "ERC20: transfer from the zero address");
365         require(to != address(0), "ERC20: transfer to the zero address");
366         require(amount > 0, "Transfer amount must be greater than zero");
367 
368         	if (from != owner() && to != owner() && !preTrader[from] && !preTrader[to]) {
369 
370             //Trade start check
371             if (!tradingOpen) {
372                 require(preTrader[from], "TOKEN: This account cannot send tokens until trading is enabled");
373             }
374 
375             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
376             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
377 
378             if(to != uniswapV2Pair) {
379                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
380             }
381 
382             uint256 contractTokenBalance = balanceOf(address(this));
383             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
384 
385             if(contractTokenBalance >= _maxTxAmount)
386             {
387                 contractTokenBalance = _maxTxAmount;
388             }
389 
390             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
391                 swapTokensForEth(contractTokenBalance);
392                 uint256 contractETHBalance = address(this).balance;
393                 if (contractETHBalance > 0) {
394                     sendETHToFee(address(this).balance);
395                 }
396             }
397         }
398 
399         bool takeFee = true;
400 
401         //Transfer Tokens
402         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
403             takeFee = false;
404         } else {
405 
406             //Set Fee for Buys
407             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
408                 _redisFee = _redisFeeOnBuy;
409                 _taxFee = _taxFeeOnBuy;
410             }
411 
412             //Set Fee for Sells
413             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
414                 _redisFee = _redisFeeOnSell;
415                 _taxFee = _taxFeeOnSell;
416             }
417 
418         }
419 
420         _tokenTransfer(from, to, amount, takeFee);
421     }
422 
423     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
424         address[] memory path = new address[](2);
425         path[0] = address(this);
426         path[1] = uniswapV2Router.WETH();
427         _approve(address(this), address(uniswapV2Router), tokenAmount);
428         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
429             tokenAmount,
430             0,
431             path,
432             address(this),
433             block.timestamp
434         );
435     }
436 
437     function sendETHToFee(uint256 amount) private {
438         _marketingAddress.transfer(amount);
439     }
440 
441     function setTrading(bool _tradingOpen) public onlyOwner {
442         tradingOpen = _tradingOpen;
443     }
444 
445     function manualswap() external {
446         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
447         uint256 contractBalance = balanceOf(address(this));
448         swapTokensForEth(contractBalance);
449     }
450 
451     function manualsend() external {
452         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
453         uint256 contractETHBalance = address(this).balance;
454         sendETHToFee(contractETHBalance);
455     }
456 
457     function blockBots(address[] memory bots_) public onlyOwner {
458         for (uint256 i = 0; i < bots_.length; i++) {
459             bots[bots_[i]] = true;
460         }
461     }
462 
463     function unblockBot(address notbot) public onlyOwner {
464         bots[notbot] = false;
465     }
466 
467     function _tokenTransfer(
468         address sender,
469         address recipient,
470         uint256 amount,
471         bool takeFee
472     ) private {
473         if (!takeFee) removeAllFee();
474         _transferStandard(sender, recipient, amount);
475         if (!takeFee) restoreAllFee();
476     }
477 
478     function _transferStandard(
479         address sender,
480         address recipient,
481         uint256 tAmount
482     ) private {
483         (
484             uint256 rAmount,
485             uint256 rTransferAmount,
486             uint256 rFee,
487             uint256 tTransferAmount,
488             uint256 tFee,
489             uint256 tTeam
490         ) = _getValues(tAmount);
491         _rOwned[sender] = _rOwned[sender].sub(rAmount);
492         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
493         _takeTeam(tTeam);
494         _reflectFee(rFee, tFee);
495         emit Transfer(sender, recipient, tTransferAmount);
496     }
497 
498     function _takeTeam(uint256 tTeam) private {
499         uint256 currentRate = _getRate();
500         uint256 rTeam = tTeam.mul(currentRate);
501         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
502     }
503 
504     function _reflectFee(uint256 rFee, uint256 tFee) private {
505         _rTotal = _rTotal.sub(rFee);
506         _tFeeTotal = _tFeeTotal.add(tFee);
507     }
508 
509     receive() external payable {}
510 
511     function _getValues(uint256 tAmount)
512         private
513         view
514         returns (
515             uint256,
516             uint256,
517             uint256,
518             uint256,
519             uint256,
520             uint256
521         )
522     {
523         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
524             _getTValues(tAmount, _redisFee, _taxFee);
525         uint256 currentRate = _getRate();
526         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
527             _getRValues(tAmount, tFee, tTeam, currentRate);
528         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
529     }
530 
531     function _getTValues(
532         uint256 tAmount,
533         uint256 redisFee,
534         uint256 taxFee
535     )
536         private
537         pure
538         returns (
539             uint256,
540             uint256,
541             uint256
542         )
543     {
544         uint256 tFee = tAmount.mul(redisFee).div(100);
545         uint256 tTeam = tAmount.mul(taxFee).div(100);
546         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
547         return (tTransferAmount, tFee, tTeam);
548     }
549 
550     function _getRValues(
551         uint256 tAmount,
552         uint256 tFee,
553         uint256 tTeam,
554         uint256 currentRate
555     )
556         private
557         pure
558         returns (
559             uint256,
560             uint256,
561             uint256
562         )
563     {
564         uint256 rAmount = tAmount.mul(currentRate);
565         uint256 rFee = tFee.mul(currentRate);
566         uint256 rTeam = tTeam.mul(currentRate);
567         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
568         return (rAmount, rTransferAmount, rFee);
569     }
570 
571     function _getRate() private view returns (uint256) {
572         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
573         return rSupply.div(tSupply);
574     }
575 
576     function _getCurrentSupply() private view returns (uint256, uint256) {
577         uint256 rSupply = _rTotal;
578         uint256 tSupply = _tTotal;
579         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
580         return (rSupply, tSupply);
581     }
582 
583     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
584         _redisFeeOnBuy = redisFeeOnBuy;
585         _redisFeeOnSell = redisFeeOnSell;
586         _taxFeeOnBuy = taxFeeOnBuy;
587         _taxFeeOnSell = taxFeeOnSell;
588     }
589 
590     //Set minimum tokens required to swap.
591     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
592         _swapTokensAtAmount = swapTokensAtAmount;
593     }
594 
595     //Set minimum tokens required to swap.
596     function toggleSwap(bool _swapEnabled) public onlyOwner {
597         swapEnabled = _swapEnabled;
598     }
599 
600     //Set maximum transaction
601     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
602         _maxTxAmount = maxTxAmount;
603     }
604 
605     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
606         _maxWalletSize = maxWalletSize;
607     }
608 
609     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
610         for(uint256 i = 0; i < accounts.length; i++) {
611             _isExcludedFromFee[accounts[i]] = excluded;
612         }
613     }
614 
615     function allowPreTrading(address[] calldata accounts) public onlyOwner {
616         for(uint256 i = 0; i < accounts.length; i++) {
617                  preTrader[accounts[i]] = true;
618         }
619     }
620 
621     function removePreTrading(address[] calldata accounts) public onlyOwner {
622         for(uint256 i = 0; i < accounts.length; i++) {
623                  delete preTrader[accounts[i]];
624         }
625     }
626 }