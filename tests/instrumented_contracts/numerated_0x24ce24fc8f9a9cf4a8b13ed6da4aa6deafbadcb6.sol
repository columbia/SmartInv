1 // SPDX-License-Identifier: MIT
2 
3 /*
4 
5 Telegram : https://t.me/bronyofficial
6 Twitter : https://twitter.com/bronyofficial/
7 Website : https://brony.schizocorn.lol/
8 
9 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
10 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡀⢤⣖⣚⠭⠭⠷⠖⠒⠒⠒⠒⠲⠿⠭⠽⢒⣶⣤⢄⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
11 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⠴⣺⡵⣚⣉⣤⣴⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡰⠋⠙⠒⠭⣓⣦⣀⠀⠀⠀⢠⣾⠭⣕⢤⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
12 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡴⠊⠀⣛⡯⣿⣾⡶⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠞⠀⠀⠀⠀⠀⠀⠈⠙⠯⣓⢶⣷⠃⠀⠀⠳⣝⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
13 ⠀⠀⠀⠀⠀⠀⠀⠀⣠⣔⡡⢔⣪⣙⡦⢚⡝⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡰⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⣽⠇⠀⠀⠀⠀⠘⣎⢦⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
14 ⠀⠀⠀⠀⠀⠀⠀⠐⠋⡽⡵⠁⣠⢞⡵⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⠞⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⠀⠀⠀⠀⠹⡄⠈⢎⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
15 ⠀⠀⠀⠀⠀⠀⠀⠀⡼⡹⢀⡜⡡⠊⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣿⡇⠀⠀⠀⠀⠀⢹⠀⠈⡼⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
16 ⠀⠀⠀⠀⠀⠀⠀⢰⢡⢧⢋⡼⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡴⠁⠀⠀⠀⠀⠀⠀⢀⠀⠀⠀⠀⢀⢼⡿⠻⡇⠀⠀⠀⠀⠀⠘⡇⠀⢳⢱⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
17 ⠀⠀⠀⠀⠀⠀⠀⣈⣾⢃⡞⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⣀⣀⣼⣀⠀⠀⣀⣠⣤⣶⣯⠏⠀⠀⢀⡴⡡⠊⠀⠀⠁⠀⠀⠀⠀⠀⠀⡇⠀⠸⡜⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
18 ⠀⠀⠀⠀⠀⠀⠀⡿⢃⡞⠀⢀⣠⠀⠀⠀⠀⠀⠀⠀⠀⠾⠋⠀⢀⡞⢀⣹⣶⠾⠛⠉⣠⡾⠋⠀⣀⣴⡿⠾⠶⢤⣄⠀⠀⠀⠀⠀⠀⠀⢠⠇⠀⢀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
19 ⠀⠀⠀⠀⠀⠀⠀⡇⡼⢀⣖⠉⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⡾⣻⠟⠋⠀⢀⣠⡾⠋⣀⠴⣺⠗⠋⠀⠀⠀⠀⠀⠓⠀⠀⠀⠀⠀⠀⡾⠀⠀⢸⢰⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
20 ⠀⠀⠀⠀⠀⠀⢸⢹⣵⡿⡟⢸⠀⠀⠀⠀⠀⠀⠀⠀⢀⡴⣚⠗⠋⠀⠀⣀⠴⢋⣛⡳⠽⠓⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡜⡜⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
21 ⠀⠀⠀⠀⠀⠀⡟⢨⢿⢠⠃⡏⠀⠀⠀⠀⠀⠀⣠⠔⡩⠚⠁⠀⠀⠀⠀⠉⠉⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⡿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
22 ⠀⠀⠀⠀⠀⠀⣧⠛⢆⡿⢸⠁⠀⠀⠀⠀⣠⠞⡵⠊⠀⢀⣴⣞⠛⠛⠲⡄⠀⠀⠀⠀⠀⠀⣠⠖⠚⠓⢦⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⡿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
23 ⠀⠀⠀⠀⠀⠀⠁⠀⠈⡇⡼⠀⠀⠀⢀⠞⡡⠊⠀⠀⠀⣿⣿⣿⣿⣦⠀⡇⣠⡄⠀⠀⠀⢸⣡⣴⣶⣤⠀⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢹⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
24 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⡇⠀⠀⡴⢡⠞⠁⠀⠀⠀⠀⠙⢿⣿⣿⣇⣴⠛⠉⠀⠀⠲⠦⣼⣿⣿⣿⣿⣠⠟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢹⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
25 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⡇⢀⠞⣰⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⠋⣙⣛⣶⣖⣋⡐⠚⢧⠈⠉⠉⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⢸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
26 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⣧⠏⣾⢹⠀⠀⠀⠀⠀⣀⠀⠀⠀⠀⢛⣫⣷⣶⣖⢺⠻⣿⣷⠸⣇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⢸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
27 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⠈⡜⠸⡄⡄⠀⠀⠀⠀⠙⡇⠀⢀⡴⣟⣿⣩⣇⣾⣉⡟⢹⠛⣇⠉⠀⠀⣴⠆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡎⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
28 ⠵⢖⣠⢄⡀⠀⠀⠀⠀⠈⠞⠀⠀⢧⢣⠀⠀⠀⠀⠀⣿⣾⣿⣾⣿⣿⡿⢿⣿⣿⣿⣿⣶⣿⣦⡀⢸⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⢡⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⠤⢀
29 ⠀⠀⠈⠙⠺⢷⡤⡀⠀⠀⠀⠀⠀⠘⡌⢆⠀⠀⢀⡴⠿⣿⣿⣿⡟⠁⠀⢀⡼⠋⠀⠀⠙⣻⣿⡿⠻⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⠃⡞⠀⠀⠀⠀⠀⠀⠀⠀⠀⡠⠊⡡⠔⠉
30 ⠀⠀⠀⠀⠀⠀⠉⠻⣷⣄⡀⠀⠀⠀⠱⡌⣆⠀⠀⠀⠀⠈⠙⣷⣿⣄⣀⠛⠀⣀⣀⣠⣾⣷⠟⠀⠀⠈⠛⠀⠀⠀⠀⠀⠀⠀⠀⢀⠎⡜⠀⠀⠀⠀⠀⠀⠀⠀⡤⢋⠴⠋⠀⠀⠀
31 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢝⢦⡀⠀⠀⠙⣌⢦⠀⠀⠀⠀⠀⠘⢿⣠⣿⡿⣿⢻⢹⣧⠾⢡⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⢏⣜⢇⠀⠀⠀⠀⠀⠀⡠⢊⡴⠃⠀⠀⠀⠀⠀
32 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢝⢦⠀⠀⠈⠣⡱⣄⠀⠀⠀⣤⣀⠉⠙⠛⠿⠛⠋⠁⠀⡼⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⣣⠎⢹⠘⡆⠀⠀⠀⢀⠜⡰⢋⡀⠀⠀⠀⠀⠀⠀
33 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣴⡶⢶⡿⠳⣄⠀⠀⠈⠪⣷⣄⠀⠈⠉⠓⠒⢯⣍⡙⠒⠒⠛⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣼⢗⡇⠀⡸⠀⢱⠀⠀⡰⠋⡨⠟⠛⠻⣷⠀⠀⠀⠀⠀
34 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢿⡆⠀⠉⠓⢬⢢⡀⠀⠀⠈⠙⠳⣦⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡴⠋⠹⣸⠁⣰⠃⠀⢸⠀⡴⡡⠊⠀⠀⠀⠀⣿⠀⠀⠀⠀⠀
35 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢿⡀⠀⠀⠀⠱⣕⣄⠀⠀⠀⠀⠀⠉⢻⢲⠤⠄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠐⠉⠀⢀⣇⡏⡴⠁⠀⠀⢸⢞⡔⠁⠀⠀⠀⠀⣰⡟⠀⠀⠀⠀⠀
36 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢷⡀⠀⠀⠀⠈⢞⢦⠀⠀⠀⠀⠀⠈⢇⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡸⠸⠞⠀⠀⠀⠀⢸⡞⠀⠀⠀⠀⠀⣰⡷⠁⠀⠀⠀⠀⠀
37 ⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⡶⣦⣬⣿⣄⠀⠀⠀⠈⠳⣣⡀⠀⠀⠀⠀⠘⢸⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⠃⠀⠀⠀⠀⠀⠀⢸⠀⠀⠀⠀⠀⡰⢿⣴⡶⠯⠽⢗⣦⠀
38 ⠄⠀⠒⠲⢤⣄⡀⠀⡿⡃⠀⠀⠀⠉⠺⣷⣄⠀⠀⠀⠱⡝⣄⠀⠀⠀⠀⡇⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡎⠀⠀⠀⠀⠀⠀⡄⢸⠀⠀⠀⢀⣼⠖⠋⠀⠀⠀⠀⠀⢹⡇
39 ⠀⠀⠀⠀⠀⠀⠈⠁⢹⣇⠀⠀⠀⠀⠀⠀⠙⢷⡀⠀⠀⠈⢾⣆⠀⠀⢀⠇⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⠀⠀⡄⠀⠀⠀⢠⡇⡏⠀⠀⡰⠋⠀⠀⠀⠀⠀⠀⠀⢀⣾⠃
40 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⣷⣄⠀⠀⠀⠀⠀⠀⠁⠀⠀⠀⠈⢮⣣⢠⢏⡆⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡞⠀⡼⡇⠀⠀⠀⣾⢷⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⡿⠁⠀
41 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠛⢷⣤⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠻⡋⡜⣿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⢰⠁⡇⠀⠀⣼⣿⡞⠀⠀⠀⠀⠀⠀⠀⠀⣠⣴⠟⠋⠀⠀⠀
42 
43 */
44 
45 pragma solidity 0.8.21;
46 
47 abstract contract Context {
48     function _msgSender() internal view virtual returns (address) {
49         return msg.sender;
50     }
51 }
52 
53 interface IERC20 {
54     function totalSupply() external view returns (uint256);
55     function balanceOf(address account) external view returns (uint256);
56     function transfer(address recipient, uint256 amount) external returns (bool);
57     function allowance(address owner, address spender) external view returns (uint256);
58     function approve(address spender, uint256 amount) external returns (bool);
59     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
60     event Transfer(address indexed from, address indexed to, uint256 value);
61     event Approval(address indexed owner, address indexed spender, uint256 value);
62 }
63 
64 library SafeMath {
65     function add(uint256 a, uint256 b) internal pure returns (uint256) {
66         uint256 c = a + b;
67         require(c >= a, "SafeMath: addition overflow");
68         return c;
69     }
70 
71     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
72         return sub(a, b, "SafeMath: subtraction overflow");
73     }
74 
75     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
76         require(b <= a, errorMessage);
77         uint256 c = a - b;
78         return c;
79     }
80 
81     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
82         if (a == 0) {
83             return 0;
84         }
85         uint256 c = a * b;
86         require(c / a == b, "SafeMath: multiplication overflow");
87         return c;
88     }
89 
90     function div(uint256 a, uint256 b) internal pure returns (uint256) {
91         return div(a, b, "SafeMath: division by zero");
92     }
93 
94     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
95         require(b > 0, errorMessage);
96         uint256 c = a / b;
97         return c;
98     }
99 
100 }
101 
102 contract Ownable is Context {
103     address private _owner;
104     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
105 
106     constructor () {
107         address msgSender = _msgSender();
108         _owner = msgSender;
109         emit OwnershipTransferred(address(0), msgSender);
110     }
111 
112     function owner() public view returns (address) {
113         return _owner;
114     }
115 
116     modifier onlyOwner() {
117         require(_owner == _msgSender(), "Ownable: caller is not the owner");
118         _;
119     }
120 
121     function renounceOwnership() public virtual onlyOwner {
122         emit OwnershipTransferred(_owner, address(0));
123         _owner = address(0);
124     }
125 
126 }
127 
128 interface IUniswapV2Factory {
129     function createPair(address tokenA, address tokenB) external returns (address pair);
130 }
131 
132 interface IUniswapV2Router02 {
133     function swapExactTokensForETHSupportingFeeOnTransferTokens(
134         uint amountIn,
135         uint amountOutMin,
136         address[] calldata path,
137         address to,
138         uint deadline
139     ) external;
140     function factory() external pure returns (address);
141     function WETH() external pure returns (address);
142     function addLiquidityETH(
143         address token,
144         uint amountTokenDesired,
145         uint amountTokenMin,
146         uint amountETHMin,
147         address to,
148         uint deadline
149     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
150 }
151 
152 contract Schizocorn is Context, IERC20, Ownable {
153     using SafeMath for uint256;
154 
155     mapping (address => uint256) private _balances;
156     mapping (address => mapping (address => uint256)) private _allowances;
157     mapping (address => bool) private _isExcludedFromFee;
158     mapping(address => uint256) private _holderLastTransferTimestamp;
159     bool public transferDelayEnabled = true;
160     address payable private _taxWallet;
161 
162     // Taxes
163     uint256 private _buyTax = 15;
164     uint256 private _sellTax = 20;
165 
166     uint8 private constant _decimals = 18;
167     uint256 private constant _tTotal = 69000000420 * 10**_decimals;
168     string private constant _name = unicode"Schizocorn";
169     string private constant _symbol = unicode"BRONY";
170     uint256 public _maxTxAmount = _tTotal * 2 / 1000;
171     uint256 public _maxWalletSize = _tTotal * 42 / 10000;
172     uint256 public _taxSwapThreshold= _tTotal * 25 / 10000;
173 
174     IUniswapV2Router02 private uniswapV2Router;
175     address private uniswapV2Pair;
176     bool private tradingOpen;
177     bool private inSwap = false;
178     bool private swapEnabled = false;
179 
180     event MaxTxAmountUpdated(uint _maxTxAmount);
181     modifier lockTheSwap {
182         inSwap = true;
183         _;
184         inSwap = false;
185     }
186 
187     constructor (address taxWallet) {
188         _taxWallet = payable(taxWallet);
189         _balances[_msgSender()] = _tTotal;
190         _isExcludedFromFee[owner()] = true;
191         _isExcludedFromFee[address(this)] = true;
192         _isExcludedFromFee[_taxWallet] = true;
193 
194         emit Transfer(address(0), _msgSender(), _tTotal);
195     }
196 
197     function name() public pure returns (string memory) {
198         return _name;
199     }
200 
201     function symbol() public pure returns (string memory) {
202         return _symbol;
203     }
204 
205     function decimals() public pure returns (uint8) {
206         return _decimals;
207     }
208 
209     function totalSupply() public pure override returns (uint256) {
210         return _tTotal;
211     }
212 
213     function balanceOf(address account) public view override returns (uint256) {
214         return _balances[account];
215     }
216 
217     function transfer(address recipient, uint256 amount) public override returns (bool) {
218         _transfer(_msgSender(), recipient, amount);
219         return true;
220     }
221 
222     function allowance(address owner, address spender) public view override returns (uint256) {
223         return _allowances[owner][spender];
224     }
225 
226     function approve(address spender, uint256 amount) public override returns (bool) {
227         _approve(_msgSender(), spender, amount);
228         return true;
229     }
230 
231     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
232         _transfer(sender, recipient, amount);
233         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
234         return true;
235     }
236 
237     function _approve(address owner, address spender, uint256 amount) private {
238         require(owner != address(0), "ERC20: approve from the zero address");
239         require(spender != address(0), "ERC20: approve to the zero address");
240         _allowances[owner][spender] = amount;
241         emit Approval(owner, spender, amount);
242     }
243 
244     function _transfer(address from, address to, uint256 amount) private {
245         require(from != address(0), "ERC20: transfer from the zero address");
246         require(to != address(0), "ERC20: transfer to the zero address");
247         require(amount > 0, "Transfer amount must be greater than zero");
248 
249         uint256 taxAmount = 0;
250 
251         if (from != owner() && to != owner()) {
252             if (transferDelayEnabled) {
253                 if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
254                     require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
255                     _holderLastTransferTimestamp[tx.origin] = block.number;
256                 }
257             }
258 
259             if (from == uniswapV2Pair && to != address(uniswapV2Router) && !_isExcludedFromFee[to]) {
260                 taxAmount = amount.mul(_buyTax).div(100);
261                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
262                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
263             }
264 
265             if (to == uniswapV2Pair && from != address(this)) {
266                 taxAmount = amount.mul(_sellTax).div(100);
267             }
268 
269             uint256 contractTokenBalance = balanceOf(address(this));
270             if (!inSwap && to == uniswapV2Pair && swapEnabled && contractTokenBalance > _taxSwapThreshold) {
271                 if(amount >= _taxSwapThreshold) {
272                     swapTokensForEth(_taxSwapThreshold);
273                 } else {
274                     swapTokensForEth(amount);
275                 }
276             }
277         }
278 
279         if(taxAmount > 0) {
280             _balances[address(this)] = _balances[address(this)].add(taxAmount);
281             emit Transfer(from, address(this), taxAmount);
282         }
283 
284         _balances[from] = _balances[from].sub(amount);
285         _balances[to] = _balances[to].add(amount.sub(taxAmount));
286         emit Transfer(from, to, amount.sub(taxAmount));
287     }
288 
289     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
290         address[] memory path = new address[](2);
291         path[0] = address(this);
292         path[1] = uniswapV2Router.WETH();
293         _approve(address(this), address(uniswapV2Router), tokenAmount);
294         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
295             tokenAmount,
296             0,
297             path,
298             address(_taxWallet),
299             block.timestamp
300         );
301     }
302 
303     function setBuyTax(uint256 tax) external onlyOwner {
304         require(tax <= 50, "Tax should be less than or equal to 50");
305         _buyTax = tax;
306     }
307 
308     function setSellTax(uint256 tax) external onlyOwner {
309         require(tax <= 50, "Tax should be less than or equal to 50");
310         _sellTax = tax;
311     }
312     
313     function setMaxTransaction(uint256 percent) external onlyOwner {
314         _maxTxAmount = _tTotal * percent / 1000;
315     }
316 
317     function setMaxWallet(uint256 percent) external onlyOwner {
318         _maxWalletSize = _tTotal * percent / 1000;
319     }
320 
321     function removeLimits() external onlyOwner{
322         _maxTxAmount = _tTotal;
323         _maxWalletSize=_tTotal;
324         transferDelayEnabled=false;
325         emit MaxTxAmountUpdated(_tTotal);
326     }
327 
328     function disableTransferDelay() external onlyOwner {
329         transferDelayEnabled=false;
330     }
331 
332     function openTrading() external onlyOwner() {
333         require(!tradingOpen,"Trading is already open");
334         uniswapV2Router = IUniswapV2Router02(
335             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
336             );
337         _approve(address(this), address(uniswapV2Router), _tTotal);
338         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
339         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
340         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
341         swapEnabled = true;
342         tradingOpen = true;
343     }
344 
345     receive() external payable {}
346 }