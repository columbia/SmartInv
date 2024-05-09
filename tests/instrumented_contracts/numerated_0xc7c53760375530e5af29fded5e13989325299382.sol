1 // SPDX-License-Identifier: MIT
2 
3 /**
4 
5 ⠀⠀⠀⢀⣀⣠⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⠄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡶⠀⠐⠶⣄⠀⠀⠲⣄⠀⠀⠀⠀⠀⠀⢠⡀⠀⠀⠰⣦⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
6 ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⠀⠀⠀⠀⠈⠛⢦⣀⠈⢳⡀⠀⠀⠀⠀⠀⢳⡀⠀⠀⠸⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀
7 ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡄⠀⠀⠀⢀⡇⠀⠀⠀⠀⠀⠀⠀⠈⠑⠦⣱⣄⠀⠀⠀⠀⠀⢧⠀⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀
8 ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣘⠀⠀⠀⠀⣾⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢦⡀⠀⠀⠀⠈⣇⠀⠀⢻⡀⠀⠀⠀⠀⠀⠀⠀⠀
9 ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⠉⠛⠲⠤⣰⣁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠀⠀⠈⠳⡀⠀⠀⠀⢸⡄⠀⠈⢧⠀⠀⠀⠀⠀⠀⠀⠀
10 ⣿⣿⣿⣿⣿⣽⣿⣿⣿⠟⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⠇⠀⠀⠀⢀⡏⠉⠉⠓⠒⠒⠒⠒⠒⠀⠀⠀⢸⣧⡆⠀⠀⠹⣆⠀⠀⠀⣷⡀⠀⠸⡆⠀⠀⠀⠀⠀⠀⠀
11 ⠉⠉⠉⠉⠉⠉⠉⣱⠏⠀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣾⠋⠀⠀⠀⢀⠟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢹⣆⠀⠀⣿⣿⡄⠀⢿⠀⠀⠀⠀⠀⠀⠀
12 ⠀⠀⠂⠀⠀⠀⡼⠁⣠⠊⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣾⣿⠏⠀⠀⠀⢠⡎⠀⠀⢀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⡀⠀⢸⣿⣿⣦⢸⡇⠀⠀⠀⠀⠀⠀
13 ⠀⠀⠀⠀⠀⣼⣡⠞⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⠾⠋⣼⠋⠀⠀⠀⣠⠏⠀⣹⠟⠁⠀⠀⠀⠀⠀⠀⠀⢀⣀⣠⣾⡤⠤⣤⣤⣴⠋⠙⣷⠀⢸⣿⣿⣿⣿⣧⠀⠀⠀⠀⠀⠀
14 ⠐⡙⠀⠀⣰⡷⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⠞⠁⠀⣼⠃⠀⠀⢀⡼⠃⠀⠘⠁⠀⠀⠀⠀⠀⢀⡤⠔⢚⣭⣿⣿⣿⣷⣿⣿⣿⣿⣿⣾⣟⣿⠋⢻⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀
15 ⣸⠁⠀⢠⡟⠁⠀⠀⠀⠀⠀⠀⠀⠀⣠⣶⣋⠀⠀⠀⡼⠁⠀⠀⣠⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠊⢉⣴⣾⣿⡿⠛⠋⠉⠉⠉⠉⠉⠛⢾⣿⣿⠉⠀⢠⢻⣿⣿⣿⠀⠀⠀⠀⢀⡠
16 ⠏⠀⢠⠟⠀⠀⠀⠀⠀⠀⠀⢀⡴⢞⠟⠉⠉⠉⠳⡾⠁⠀⣠⠞⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣾⣿⠿⢫⠷⢋⣉⣉⡙⠲⣦⡀⠀⢀⣼⡿⠉⡇⠀⡜⠈⢻⡾⣿⠀⢀⣤⠄⠀⠀
17 ⣄⢠⠏⠀⠀⠀⠀⠀⠀⣠⡾⠋⠀⠀⠀⣀⣀⣀⡾⠁⣠⢴⡁⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣾⡿⠟⠁⠀⡟⢠⢀⣴⡦⠙⣆⣨⠷⣴⣿⠟⠓⢠⠇⣰⠇⠀⠸⡇⣿⣾⣿⣿⠀⠀⡀
18 ⢿⡏⠀⠀⠀⠀⢀⣴⠟⢹⠃⢀⡤⠚⠉⠁⢀⡞⣠⠞⠁⠀⠹⣄⠀⠀⠀⠀⠀⠀⠀⠀⡾⠟⠀⠀⠀⠀⣿⣘⣦⣿⣥⣾⣅⣒⣻⠟⠃⠀⠀⣸⣠⠏⠀⠀⠀⣿⣸⣿⣿⣿⠀⢠⠃
19 ⡾⠀⠀⠀⢀⣴⡿⠋⠀⡼⠀⠈⠀⣄⠀⣰⡿⠚⠁⠀⠀⠀⠀⠈⢦⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡴⠒⠛⠋⠉⠉⠟⢻⣿⣶⣾⣷⣶⣶⣶⣾⡟⠁⠀⠀⠀⠀⣿⢹⣿⣿⣿⢠⡞⠀
20 ⠃⠀⠀⢠⣾⠟⠀⠀⢰⣷⣶⣶⣶⣾⣿⣿⣿⣿⣿⣷⣶⣦⣤⣄⣈⣷⠀⠀⢀⣤⠞⠀⠀⠔⠋⠀⠀⠀⠀⠀⠀⠀⠈⢿⣿⣿⣿⣿⣿⣿⣿⣷⣄⠀⠀⠀⢸⣿⣿⣿⣿⣿⣾⡇⠀
21 ⠀⠀⢠⡿⠧⣤⣴⡶⣿⣿⣿⠟⢛⡏⠉⣯⡴⢆⣙⣨⣷⠴⠤⠴⢋⡴⣯⠴⣫⠐⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠛⠿⣯⢿⣿⣿⣿⣧⡀⠀⣼⣿⣿⣿⣿⣧⣿⡇⠀
22 ⠀⢀⡞⠀⠀⠀⢀⣽⣿⡿⣿⣷⣾⣧⣤⠽⠿⠟⠋⠁⠀⠀⠀⠀⡠⢞⠷⠊⠐⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⢦⣀⣀⣀⣀⣤⠤⠞⠛⢣⡻⣿⣿⣿⣷⣸⣿⣿⣿⣿⡟⣿⡿⠁⠀
23 ⠀⠞⠀⠀⣠⢶⣿⣿⣟⣿⡆⠹⠿⠯⠄⠀⠀⠀⠀⠂⠀⠀⠀⠀⠵⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠛⠻⠤⠤⠤⣄⣀⣀⣹⣿⣿⣿⣿⣿⣿⣿⣿⣿⢷⣿⠁⠀⠀
24 ⠀⠀⣠⠞⠁⢸⣿⣿⣿⣿⣇⠀⠀⠀⣀⠀⠀⠀⠀⣠⣴⣤⣶⣶⣦⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠳⠤⢽⣟⢿⣿⣿⣷⣽⣻⣿⡿⠁⠀⠀⠀
25 ⠗⠉⠀⠀⠀⠸⣿⣿⡏⢿⣿⠀⣼⣿⣿⣿⣿⣿⣿⣿⢿⣟⣻⡿⠃⠀⠀⠐⠾⠄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⠖⠂⠀⠀⢀⣼⣿⣿⣿⣿⣿⣿⣿⢿⡇⠀⠀⠀⠀
26 ⠀⠀⠀⠀⠀⠀⣿⣿⣿⡾⣿⣿⣿⣿⣿⣽⣿⣿⣿⡿⠿⠟⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠁⠀⠀⣠⣿⢳⣿⣿⣿⣿⣿⣿⣿⡿⠁⠀⠀⠀⠀
27 ⠀⠀⠀⠀⠀⠰⠛⣿⣿⣿⣿⣿⣿⣿⣿⡿⠉⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⡤⠤⢤⣤⣤⣴⣿⠇⠀⠀⠀⠀⠀⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠇⠀⡠⠀⠀⠀
28 ⠀⠀⠀⡠⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⡃⠀⠀⠀⠀⠀⠀⠀⠀⠀⣄⣀⣀⣠⡤⠴⠒⠒⠋⣁⣠⣴⣿⡝⠛⢻⣿⠀⠀⠀⠀⢠⣾⣿⣿⢣⣿⣿⣿⣿⣿⣿⡿⡹⣠⠞⠁⠀⠀⠀
29 ⠀⣠⣬⡤⠤⢤⣤⣿⣿⣿⣿⣿⣿⢻⣿⣷⣄⠀⠀⠀⠀⠀⠀⠀⠀⠈⢻⣿⣿⡿⠟⠓⠒⠛⠻⠿⣿⠟⠁⠀⢸⠃⠀⠀⠀⢀⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢞⣵⠃⠀⠀⠀⠀⠀
30 ⠚⠉⠀⠀⠀⠀⠈⣿⣴⣿⣿⣿⣿⡼⣿⣏⠻⣦⡐⠦⠀⠀⠀⠀⠀⠀⠀⠙⢿⡄⠀⠀⠀⠀⠀⠲⠃⠀⠀⢀⡾⠀⠀⠀⣠⣾⣿⣿⣿⢿⣿⣿⣿⣿⣿⠟⢉⠞⠁⣠⠴⠋⠀⠀⠀
31 ⠀⠀⠀⠀⠀⠀⠀⠹⣿⣿⣿⣿⣿⣿⣿⣿⣧⡈⠛⣷⣄⣀⠀⠀⠀⠀⠀⠀⠀⠉⠓⠶⣄⡀⠀⠀⠀⢀⣠⠞⠁⠀⣠⣾⣿⣿⣿⡟⣿⣿⣿⠟⠋⠁⠀⣠⠏⣠⠞⠁⠀⠀⠀⠀⠀
32 ⠀⠀⠀⠀⠀⠀⠀⠀⢻⣿⣿⣿⣿⣿⣿⡿⣿⣿⣆⠈⠻⣿⣿⣶⣤⣀⠀⠀⠀⠀⠀⢠⠀⡈⠙⠛⠛⠉⠀⠀⢠⣾⣿⣿⣿⣿⣿⡿⠟⠋⠀⠀⠀⠀⢠⣣⡾⠋⠀⠀⠀⠀⠀⠀⠀
33 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⣿⣿⣿⣿⣿⣷⡹⣿⣿⣧⡄⠈⢻⡟⠉⠉⠛⣶⣄⡀⠀⠀⠀⡇⠀⠀⠀⠀⠀⢠⣿⣿⣿⣿⣿⡿⠋⠀⠀⠀⠀⠀⠀⢠⠿⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀
34 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⣿⣿⣿⣿⣿⣿⣿⣽⣿⣿⣿⠺⣧⣭⣦⡀⠀⠘⠀⠉⢷⣬⡉⠁⠀⠀⠀⠀⣠⣿⣿⣿⣿⢿⠏⠀⠀⠀⠀⠀⠀⠀⢠⠏⢠⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀
35 ⠀⠀⠀⠀⠀⣀⠤⠄⠀⠀⢻⣿⣿⣿⣿⣿⣿⣿⣼⣿⣿⣧⢻⣿⡿⠿⢷⣾⡀⠻⣾⣿⣿⣿⣶⣶⣶⡾⢹⣿⣿⣿⠏⠏⠀⠀⠀⠀⠀⠀⠀⢠⠏⠀⡼⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
36 ⠀⠀⠀⠀⠈⠀⠀⠀⠇⠀⠘⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢸⣿⣧⠀⡸⠛⠶⣄⠌⠻⠙⢿⡿⠟⠋⣠⣾⣿⣿⠏⠘⠀⠀⠀⠀⠀⠀⠀⠀⣾⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
37 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠾⠿⠿⠿⠷⠄⠀⠞⢓⡷⠄⠀⠱⠄⠰⠋⠘⠿⠿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠐⠿⠀⠀⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
38 
39 WORLD PEACE HAS BEEN DELCARED
40 
41 Web : https://peacecoin.world/
42 Twitter : https://twitter.com/WPCERC20
43 Tg : https://t.me/WorldPeaceCoin
44 
45 With love by, @FDASHO on telegram.
46 */
47 
48 
49 pragma solidity 0.8.20;
50 
51 abstract contract Context {
52     function _msgSender() internal view virtual returns (address) {
53         return msg.sender;
54     }
55 }
56 
57 interface IERC20 {
58     function totalSupply() external view returns (uint256);
59     function balanceOf(address account) external view returns (uint256);
60     function transfer(address recipient, uint256 amount) external returns (bool);
61     function allowance(address owner, address spender) external view returns (uint256);
62     function approve(address spender, uint256 amount) external returns (bool);
63     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
64     event Transfer(address indexed from, address indexed to, uint256 value);
65     event Approval(address indexed owner, address indexed spender, uint256 value);
66 }
67 
68 library SafeMath {
69     function add(uint256 a, uint256 b) internal pure returns (uint256) {
70         uint256 c = a + b;
71         require(c >= a, "SafeMath: addition overflow");
72         return c;
73     }
74 
75     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
76         return sub(a, b, "SafeMath: subtraction overflow");
77     }
78 
79     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
80         require(b <= a, errorMessage);
81         uint256 c = a - b;
82         return c;
83     }
84 
85     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
86         if (a == 0) {
87             return 0;
88         }
89         uint256 c = a * b;
90         require(c / a == b, "SafeMath: multiplication overflow");
91         return c;
92     }
93 
94     function div(uint256 a, uint256 b) internal pure returns (uint256) {
95         return div(a, b, "SafeMath: division by zero");
96     }
97 
98     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
99         require(b > 0, errorMessage);
100         uint256 c = a / b;
101         return c;
102     }
103 
104 }
105 
106 contract Ownable is Context {
107     address private _owner;
108     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
109 
110     constructor () {
111         address msgSender = _msgSender();
112         _owner = msgSender;
113         emit OwnershipTransferred(address(0), msgSender);
114     }
115 
116     function owner() public view returns (address) {
117         return _owner;
118     }
119 
120     modifier onlyOwner() {
121         require(_owner == _msgSender(), "Ownable: caller is not the owner");
122         _;
123     }
124 
125     function renounceOwnership() public virtual onlyOwner {
126         emit OwnershipTransferred(_owner, address(0));
127         _owner = address(0);
128     }
129 
130 }
131 
132 interface IUniswapV2Factory {
133     function createPair(address tokenA, address tokenB) external returns (address pair);
134 }
135 
136 interface IUniswapV2Router02 {
137     function swapExactTokensForETHSupportingFeeOnTransferTokens(
138         uint amountIn,
139         uint amountOutMin,
140         address[] calldata path,
141         address to,
142         uint deadline
143     ) external;
144     function factory() external pure returns (address);
145     function WETH() external pure returns (address);
146     function addLiquidityETH(
147         address token,
148         uint amountTokenDesired,
149         uint amountTokenMin,
150         uint amountETHMin,
151         address to,
152         uint deadline
153     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
154 }
155 
156 contract WORLDPEACE is Context, IERC20, Ownable {
157     using SafeMath for uint256;
158     mapping (address => uint256) private _balances;
159     mapping (address => mapping (address => uint256)) private _allowances;
160     mapping (address => bool) private _isExcludedFromFee;
161     address payable private _taxWallet; // Marketing Wallet
162     address payable private _teamWallet; // Team Wallet
163     uint256 private _taxWalletPercentage = 50; // 50%
164     uint256 private _teamWalletPercentage = 50; // 50%
165 
166     uint256 firstBlock;
167 
168     uint256 private _initialBuyTax=20;
169     uint256 private _initialSellTax=25;
170     uint256 private _finalBuyTax=1;
171     uint256 private _finalSellTax=1;
172     uint256 private _reduceBuyTaxAt=20;
173     uint256 private _reduceSellTaxAt=30;
174     uint256 private _preventSwapBefore=25;
175     uint256 private _buyCount=0;
176 
177     uint8 private constant _decimals = 9;
178     uint256 private constant _tTotal = 8000000000 * 10**_decimals;
179     string private constant _name = unicode"WORLD PEACE COIN";
180     string private constant _symbol = unicode"WPC";
181     uint256 public _maxTxAmount =  _tTotal / 100;
182     uint256 public _maxWalletSize =   _tTotal / 100;
183     uint256 public _taxSwapThreshold=  _tTotal / 100;
184     uint256 public _maxTaxSwap=   _tTotal / 100;
185 
186     IUniswapV2Router02 private uniswapV2Router;
187     address private uniswapV2Pair;
188     bool private tradingOpen;
189     bool private inSwap = false;
190     bool private swapEnabled = false;
191 
192     event MaxTxAmountUpdated(uint _maxTxAmount);
193     event ClearStuck(uint256 amount);
194     event ClearToken(address TokenAddressCleared, uint256 Amount);
195     modifier lockTheSwap {
196         inSwap = true;
197         _;
198         inSwap = false;
199     }
200 
201     constructor () {
202 
203         _taxWallet = payable(_msgSender());
204         _teamWallet = payable(0x42Cc125EF59826a8503bd7fa8D60349aD19776B7);
205         _balances[_msgSender()] = _tTotal;
206         _isExcludedFromFee[owner()] = true;
207         _isExcludedFromFee[address(this)] = true;
208         _isExcludedFromFee[_taxWallet] = true;
209         
210         emit Transfer(address(0), _msgSender(), _tTotal);
211     }
212 
213     function name() public pure returns (string memory) {
214         return _name;
215     }
216 
217     function symbol() public pure returns (string memory) {
218         return _symbol;
219     }
220 
221     function decimals() public pure returns (uint8) {
222         return _decimals;
223     }
224 
225     function totalSupply() public pure override returns (uint256) {
226         return _tTotal;
227     }
228 
229     function balanceOf(address account) public view override returns (uint256) {
230         return _balances[account];
231     }
232 
233     function transfer(address recipient, uint256 amount) public override returns (bool) {
234         _transfer(_msgSender(), recipient, amount);
235         return true;
236     }
237 
238     function allowance(address owner, address spender) public view override returns (uint256) {
239         return _allowances[owner][spender];
240     }
241 
242     function approve(address spender, uint256 amount) public override returns (bool) {
243         _approve(_msgSender(), spender, amount);
244         return true;
245     }
246 
247     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
248         _transfer(sender, recipient, amount);
249         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
250         return true;
251     }
252 
253     function _approve(address owner, address spender, uint256 amount) private {
254         require(owner != address(0), "ERC20: approve from the zero address");
255         require(spender != address(0), "ERC20: approve to the zero address");
256         _allowances[owner][spender] = amount;
257         emit Approval(owner, spender, amount);
258     }
259 
260     function _transfer(address from, address to, uint256 amount) private {
261         require(from != address(0), "ERC20: transfer from the zero address");
262         require(to != address(0), "ERC20: transfer to the zero address");
263         require(amount > 0, "Transfer amount must be greater than zero");
264         uint256 taxAmount=0;
265 
266         if (from != owner() && to != owner()) {
267             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
268 
269             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
270                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
271                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
272 
273                 if (firstBlock + 3  > block.number) {
274                     require(!isContract(to));
275                 }
276                 _buyCount++;
277             }
278 
279             if (to != uniswapV2Pair && ! _isExcludedFromFee[to]) {
280                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
281             }
282 
283             if(to == uniswapV2Pair && from!= address(this) ){
284                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
285             }
286 
287             uint256 contractTokenBalance = balanceOf(address(this));
288             if (!inSwap && to == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
289                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
290                 uint256 contractETHBalance = address(this).balance;
291                 if(contractETHBalance > 0) {
292                     sendETHToFee(address(this).balance);
293                 }
294             }
295         }
296 
297         if(taxAmount>0){
298           _balances[address(this)]=_balances[address(this)].add(taxAmount);
299           emit Transfer(from, address(this),taxAmount);
300         }
301         _balances[from]=_balances[from].sub(amount);
302         _balances[to]=_balances[to].add(amount.sub(taxAmount));
303         emit Transfer(from, to, amount.sub(taxAmount));
304     }
305 
306 
307     function min(uint256 a, uint256 b) private pure returns (uint256){
308       return (a>b)?b:a;
309     }
310 
311     function isContract(address account) private view returns (bool) {
312         uint256 size;
313         assembly {
314             size := extcodesize(account)
315         }
316         return size > 0;
317     }
318 
319     function isExcludedFromFee(address account) public view returns (bool) {
320         return _isExcludedFromFee[account];
321     }
322 
323     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
324         address[] memory path = new address[](2);
325         path[0] = address(this);
326         path[1] = uniswapV2Router.WETH();
327         _approve(address(this), address(uniswapV2Router), tokenAmount);
328         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
329             tokenAmount,
330             0,
331             path,
332             address(this),
333             block.timestamp
334         );
335     }
336 
337     function removeLimits() external onlyOwner{
338         _maxTxAmount = _tTotal;
339         _maxWalletSize=_tTotal;
340         emit MaxTxAmountUpdated(_tTotal);
341     }
342 
343     function sendETHToFee(uint256 amount) private {
344         uint256 taxWalletShare = amount * _taxWalletPercentage / 100;
345         uint256 teamWalletShare = amount * _teamWalletPercentage / 100;
346 
347         _taxWallet.transfer(taxWalletShare);
348         _teamWallet.transfer(teamWalletShare);
349     }
350 
351     function clearStuckToken(address tokenAddress, uint256 tokens) external returns (bool success) {
352              if(tokens == 0){
353             tokens = IERC20(tokenAddress).balanceOf(address(this));
354         }
355         emit ClearToken(tokenAddress, tokens);
356         return IERC20(tokenAddress).transfer(_taxWallet, tokens);
357     }
358 
359     function manualSend() external {
360         require(address(this).balance > 0, "Contract balance must be greater than zero");
361 
362         uint256 balance = address(this).balance; // Check
363         payable(_taxWallet).transfer(balance); // Effects + Interaction
364     }
365  
366     function manualSwap() external{
367         uint256 tokenBalance=balanceOf(address(this));
368         if(tokenBalance>0){
369           swapTokensForEth(tokenBalance);
370         }
371         uint256 ethBalance=address(this).balance;
372         if(ethBalance>0){
373           sendETHToFee(ethBalance);
374         }
375     }
376 
377     function DECLAREWORLDPEACE() external onlyOwner() {
378         require(!tradingOpen,"trading is already open");
379 
380         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
381         _approve(address(this), address(uniswapV2Router), _tTotal);
382         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
383 
384         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this), balanceOf(address(this)), 0, 0, owner(), block.timestamp);
385         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
386 
387         swapEnabled = true;
388         tradingOpen = true;
389         firstBlock = block.number;
390     }
391 
392 
393     receive() external payable {}
394 }