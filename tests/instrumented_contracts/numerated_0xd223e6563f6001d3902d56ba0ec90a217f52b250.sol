1 //Crypto Messiah Inu (cMessiahInu)
2 
3 /*
4 ⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄
5 ⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄
6 ⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⣠⣴⣶⣶⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄
7 ⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⢠⣤⣿⣾⣿⣿⣿⣿⣿⣤⣾⣛⣛⠳⢤⣄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄
8 ⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⢀⣤⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣾⣿⣿⠶⠶⠶⠶⠤⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄
9 ⠄⠄⠄⠄⠄⠄⠄⠄⡀⣠⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄
10 ⠄⠄⠄⠄⠄⠄⠄⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣤⡀⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄
11 ⠄⠄⠄⠄⠄⠄⣤⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠋⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄
12 ⠄⠄⠄⠄⢀⡾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄
13 ⠄⠄⠄⠄⢸⣷⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣍⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄
14 ⠄⠄⠄⠄⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣅⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄
15 ⠄⠄⠄⠄⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄
16 ⠄⠄⠄⠄⢘⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡧⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄
17 ⠄⠄⠄⠄⢸⢿⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⢀
18 ⠄⠄⠄⠄⠄⠸⠄⢻⣿⣿⣿⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⣤⣀⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⣤⣿
19 ⠄⠄⠄⠄⠄⠄⠄⠸⠿⣇⠻⣦⢹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠟⠉⠄⠄⠄⠄⠄⠄⠄⠄⠄⣀⠄⠄⠄⠄⠈⠄⠄⠄⠄⠄⠄⠄⠄⠹
20 ⠄⠄⠄⠄⠄⠄⠄⠄⠄⢻⠄⠛⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠏⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⡤⠃⠄⠄⡀⣠⠄⠄⠛⠃⠄⠄⠄⠄⠄⠄
21 ⠄⠄⠄⠄⠄⠄⠄⠄⠄⠉⠄⠄⠈⠱⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠉⠄⠄⠄⠄⠄⠄⠄⠈⠄⠄⢀⡾⠄⠄⠈⠄⣀⣬⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄
22 ⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⢠⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡏⠄⠄⠄⢰⣿⣶⣦⣄⠄⠄⠄⣼⠃⠄⠄⠄⢀⣿⠟⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄
23 ⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠄⠄⠄⠄⢸⢿⣿⣿⣽⡆⠄⠄⠃⠄⠄⠄⠄⠸⠋⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄
24 ⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⢠⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠄⠄⠄⠄⠘⢦⣻⣿⣿⠃⠄⠄⠄⠄⠄⠄⢀⣴⣶⣶⣶⣦⡀⠄⠄⠄⠄⠄⠄⠄
25 ⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠇⠄⠄⠄⠄⠄⠄⠉⠉⠉⠄⠄⠄⠄⠄⠄⢠⣾⣿⣿⣿⣿⣿⣿⣦⡀⠄⠄⠄⠄⠄
26 ⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⢙⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡏⠄⠄⠄⠄⠄⠄⠄⠄⠰⠆⠄⠄⠄⠄⠄⠄⠾⠿⢿⣿⣿⣿⣿⡿⠉⠉⠲⣄⠄⠄⠄
27 ⠄⠄⠄⠄⠄⠄⠄⢠⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠄⠄⠄⠄⠄⠄⠄⠄⠘⠃⠤⣤⣾⡿⠏⠄⠄⠄⠄⠙⠛⠛⠋⠄⠄⠄⠄⠈⠛⠛⠆
28 ⠄⠄⠄⠄⢀⣰⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠄⠄⠄⠄⠄⠄⠄⠄⠄⢱⣶⠟⠋⠁⠄⡀⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄
29 ⠄⠄⠄⢠⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠇⠄⠄⠄⠄⠄⠄⠄⠄⠄⢸⠗⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄
30 ⠄⢀⣀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄
31 ⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄
32 ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⡀⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄
33 ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⡄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄
34 ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣤⡀⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄
35 */
36 
37 //Limit Buy
38 //Cooldown
39 //Bot Protect
40 //Liqudity dev provides and lock
41 //TG: https://t.me/cryptomessiahinu
42 //Website: TBA
43 //CG, CMC listing: Ongoing
44 // SPDX-License-Identifier: Unlicensed
45 
46 pragma solidity ^0.8.4;
47 
48 abstract contract Context {
49     function _msgSender() internal view virtual returns (address) {
50         return msg.sender;
51     }
52 }
53 
54 interface IERC20 {
55     function totalSupply() external view returns (uint256);
56 
57     function balanceOf(address account) external view returns (uint256);
58 
59     function transfer(address recipient, uint256 amount)
60         external
61         returns (bool);
62 
63     function allowance(address owner, address spender)
64         external
65         view
66         returns (uint256);
67 
68     function approve(address spender, uint256 amount) external returns (bool);
69 
70     function transferFrom(
71         address sender,
72         address recipient,
73         uint256 amount
74     ) external returns (bool);
75 
76     event Transfer(address indexed from, address indexed to, uint256 value);
77     event Approval(
78         address indexed owner,
79         address indexed spender,
80         uint256 value
81     );
82 }
83 
84 library SafeMath {
85     function add(uint256 a, uint256 b) internal pure returns (uint256) {
86         uint256 c = a + b;
87         require(c >= a, "SafeMath: addition overflow");
88         return c;
89     }
90 
91     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
92         return sub(a, b, "SafeMath: subtraction overflow");
93     }
94 
95     function sub(
96         uint256 a,
97         uint256 b,
98         string memory errorMessage
99     ) internal pure returns (uint256) {
100         require(b <= a, errorMessage);
101         uint256 c = a - b;
102         return c;
103     }
104 
105     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
106         if (a == 0) {
107             return 0;
108         }
109         uint256 c = a * b;
110         require(c / a == b, "SafeMath: multiplication overflow");
111         return c;
112     }
113 
114     function div(uint256 a, uint256 b) internal pure returns (uint256) {
115         return div(a, b, "SafeMath: division by zero");
116     }
117 
118     function div(
119         uint256 a,
120         uint256 b,
121         string memory errorMessage
122     ) internal pure returns (uint256) {
123         require(b > 0, errorMessage);
124         uint256 c = a / b;
125         return c;
126     }
127 }
128 
129 contract Ownable is Context {
130     address private _owner;
131     address private _previousOwner;
132     event OwnershipTransferred(
133         address indexed previousOwner,
134         address indexed newOwner
135     );
136 
137     constructor() {
138         address msgSender = _msgSender();
139         _owner = msgSender;
140         emit OwnershipTransferred(address(0), msgSender);
141     }
142 
143     function owner() public view returns (address) {
144         return _owner;
145     }
146 
147     modifier onlyOwner() {
148         require(_owner == _msgSender(), "Ownable: caller is not the owner");
149         _;
150     }
151 
152     function renounceOwnership() public virtual onlyOwner {
153         emit OwnershipTransferred(_owner, address(0));
154         _owner = address(0);
155     }
156 }
157 
158 interface IUniswapV2Factory {
159     function createPair(address tokenA, address tokenB)
160         external
161         returns (address pair);
162 }
163 
164 interface IUniswapV2Router02 {
165     function swapExactTokensForETHSupportingFeeOnTransferTokens(
166         uint256 amountIn,
167         uint256 amountOutMin,
168         address[] calldata path,
169         address to,
170         uint256 deadline
171     ) external;
172 
173     function factory() external pure returns (address);
174 
175     function WETH() external pure returns (address);
176 
177     function addLiquidityETH(
178         address token,
179         uint256 amountTokenDesired,
180         uint256 amountTokenMin,
181         uint256 amountETHMin,
182         address to,
183         uint256 deadline
184     )
185         external
186         payable
187         returns (
188             uint256 amountToken,
189             uint256 amountETH,
190             uint256 liquidity
191         );
192 }
193 
194 contract cMESSIAHINU is Context, IERC20, Ownable {
195     using SafeMath for uint256;
196 
197     string private constant _name = "Crypto Messiah Inu";
198     string private constant _symbol = "cMESSIAHINU \xF0\x9F\x8D\x9B";
199     uint8 private constant _decimals = 9;
200 
201     // RFI
202     mapping(address => uint256) private _rOwned;
203     mapping(address => uint256) private _tOwned;
204     mapping(address => mapping(address => uint256)) private _allowances;
205     mapping(address => bool) private _isExcludedFromFee;
206     uint256 private constant MAX = ~uint256(0);
207     uint256 private constant _tTotal = 1000000000000 * 10**9;
208     uint256 private _rTotal = (MAX - (MAX % _tTotal));
209     uint256 private _tFeeTotal;
210     uint256 private _taxFee = 5;
211     uint256 private _teamFee = 10;
212 
213     // Bot detection
214     mapping(address => bool) private bots;
215     mapping(address => uint256) private cooldown;
216     address payable private _teamAddress;
217     address payable private _marketingFunds;
218     IUniswapV2Router02 private uniswapV2Router;
219     address private uniswapV2Pair;
220     bool private tradingOpen;
221     bool private inSwap = false;
222     bool private swapEnabled = false;
223     bool private cooldownEnabled = false;
224     uint256 private _maxTxAmount = _tTotal;
225 
226     event MaxTxAmountUpdated(uint256 _maxTxAmount);
227     modifier lockTheSwap {
228         inSwap = true;
229         _;
230         inSwap = false;
231     }
232 
233     constructor(address payable addr1, address payable addr2) {
234         _teamAddress = addr1;
235         _marketingFunds = addr2;
236         _rOwned[_msgSender()] = _rTotal;
237         _isExcludedFromFee[owner()] = true;
238         _isExcludedFromFee[address(this)] = true;
239         _isExcludedFromFee[_teamAddress] = true;
240         _isExcludedFromFee[_marketingFunds] = true;
241         emit Transfer(address(0), _msgSender(), _tTotal);
242     }
243 
244     function name() public pure returns (string memory) {
245         return _name;
246     }
247 
248     function symbol() public pure returns (string memory) {
249         return _symbol;
250     }
251 
252     function decimals() public pure returns (uint8) {
253         return _decimals;
254     }
255 
256     function totalSupply() public pure override returns (uint256) {
257         return _tTotal;
258     }
259 
260     function balanceOf(address account) public view override returns (uint256) {
261         return tokenFromReflection(_rOwned[account]);
262     }
263 
264     function transfer(address recipient, uint256 amount)
265         public
266         override
267         returns (bool)
268     {
269         _transfer(_msgSender(), recipient, amount);
270         return true;
271     }
272 
273     function allowance(address owner, address spender)
274         public
275         view
276         override
277         returns (uint256)
278     {
279         return _allowances[owner][spender];
280     }
281 
282     function approve(address spender, uint256 amount)
283         public
284         override
285         returns (bool)
286     {
287         _approve(_msgSender(), spender, amount);
288         return true;
289     }
290 
291     function transferFrom(
292         address sender,
293         address recipient,
294         uint256 amount
295     ) public override returns (bool) {
296         _transfer(sender, recipient, amount);
297         _approve(
298             sender,
299             _msgSender(),
300             _allowances[sender][_msgSender()].sub(
301                 amount,
302                 "ERC20: transfer amount exceeds allowance"
303             )
304         );
305         return true;
306     }
307 
308     function setCooldownEnabled(bool onoff) external onlyOwner() {
309         cooldownEnabled = onoff;
310     }
311 
312     function tokenFromReflection(uint256 rAmount)
313         private
314         view
315         returns (uint256)
316     {
317         require(
318             rAmount <= _rTotal,
319             "Amount must be less than total reflections"
320         );
321         uint256 currentRate = _getRate();
322         return rAmount.div(currentRate);
323     }
324 
325     function removeAllFee() private {
326         if (_taxFee == 0 && _teamFee == 0) return;
327         _taxFee = 0;
328         _teamFee = 0;
329     }
330 
331     function restoreAllFee() private {
332         _taxFee = 5;
333         _teamFee = 12;
334     }
335 
336     function _approve(
337         address owner,
338         address spender,
339         uint256 amount
340     ) private {
341         require(owner != address(0), "ERC20: approve from the zero address");
342         require(spender != address(0), "ERC20: approve to the zero address");
343         _allowances[owner][spender] = amount;
344         emit Approval(owner, spender, amount);
345     }
346 
347     function _transfer(
348         address from,
349         address to,
350         uint256 amount
351     ) private {
352         require(from != address(0), "ERC20: transfer from the zero address");
353         require(to != address(0), "ERC20: transfer to the zero address");
354         require(amount > 0, "Transfer amount must be greater than zero");
355 
356         if (from != owner() && to != owner()) {
357             if (cooldownEnabled) {
358                 if (
359                     from != address(this) &&
360                     to != address(this) &&
361                     from != address(uniswapV2Router) &&
362                     to != address(uniswapV2Router)
363                 ) {
364                     require(
365                         _msgSender() == address(uniswapV2Router) ||
366                             _msgSender() == uniswapV2Pair,
367                         "ERR: Uniswap only"
368                     );
369                 }
370             }
371             require(amount <= _maxTxAmount);
372             require(!bots[from] && !bots[to]);
373             if (
374                 from == uniswapV2Pair &&
375                 to != address(uniswapV2Router) &&
376                 !_isExcludedFromFee[to] &&
377                 cooldownEnabled
378             ) {
379                 require(cooldown[to] < block.timestamp);
380                 cooldown[to] = block.timestamp + (15 seconds);
381             }
382             uint256 contractTokenBalance = balanceOf(address(this));
383             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
384                 swapTokensForEth(contractTokenBalance);
385                 uint256 contractETHBalance = address(this).balance;
386                 if (contractETHBalance > 0) {
387                     sendETHToFee(address(this).balance);
388                 }
389             }
390         }
391         bool takeFee = true;
392 
393         if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
394             takeFee = false;
395         }
396 
397         _tokenTransfer(from, to, amount, takeFee);
398     }
399 
400     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
401         address[] memory path = new address[](2);
402         path[0] = address(this);
403         path[1] = uniswapV2Router.WETH();
404         _approve(address(this), address(uniswapV2Router), tokenAmount);
405         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
406             tokenAmount,
407             0,
408             path,
409             address(this),
410             block.timestamp
411         );
412     }
413 
414     function sendETHToFee(uint256 amount) private {
415         _teamAddress.transfer(amount.div(2));
416         _marketingFunds.transfer(amount.div(2));
417     }
418 
419     function openTrading() external onlyOwner() {
420         require(!tradingOpen, "trading is already open");
421         IUniswapV2Router02 _uniswapV2Router =
422             IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
423         uniswapV2Router = _uniswapV2Router;
424         _approve(address(this), address(uniswapV2Router), _tTotal);
425         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
426             .createPair(address(this), _uniswapV2Router.WETH());
427         uniswapV2Router.addLiquidityETH{value: address(this).balance}(
428             address(this),
429             balanceOf(address(this)),
430             0,
431             0,
432             owner(),
433             block.timestamp
434         );
435         swapEnabled = true;
436         cooldownEnabled = true;
437         _maxTxAmount = 2500000000 * 10**9;
438         tradingOpen = true;
439         IERC20(uniswapV2Pair).approve(
440             address(uniswapV2Router),
441             type(uint256).max
442         );
443     }
444 
445     function manualswap() external {
446         require(_msgSender() == _teamAddress);
447         uint256 contractBalance = balanceOf(address(this));
448         swapTokensForEth(contractBalance);
449     }
450 
451     function manualsend() external {
452         require(_msgSender() == _teamAddress);
453         uint256 contractETHBalance = address(this).balance;
454         sendETHToFee(contractETHBalance);
455     }
456 
457     function setBots(address[] memory bots_) public onlyOwner {
458         for (uint256 i = 0; i < bots_.length; i++) {
459             bots[bots_[i]] = true;
460         }
461     }
462 
463     function delBot(address notbot) public onlyOwner {
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
524             _getTValues(tAmount, _taxFee, _teamFee);
525         uint256 currentRate = _getRate();
526         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
527             _getRValues(tAmount, tFee, tTeam, currentRate);
528         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
529     }
530 
531     function _getTValues(
532         uint256 tAmount,
533         uint256 taxFee,
534         uint256 TeamFee
535     )
536         private
537         pure
538         returns (
539             uint256,
540             uint256,
541             uint256
542         )
543     {
544         uint256 tFee = tAmount.mul(taxFee).div(100);
545         uint256 tTeam = tAmount.mul(TeamFee).div(100);
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
583     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
584         require(maxTxPercent > 0, "Amount must be greater than 0");
585         _maxTxAmount = _tTotal.mul(maxTxPercent).div(10**2);
586         emit MaxTxAmountUpdated(_maxTxAmount);
587     }
588 }