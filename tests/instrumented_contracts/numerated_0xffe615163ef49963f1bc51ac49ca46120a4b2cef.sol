1 // SPDX-License-Identifier: UNLICENSED
2 pragma solidity 0.6.12;
3 
4 library SafeMath {
5    
6     function add(uint256 a, uint256 b) internal pure returns (uint256) {
7         uint256 c = a + b;
8         require(c >= a, "SafeMath: addition overflow");
9         return c;}
10 
11     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
12         return sub(a, b, "SafeMath: subtraction overflow");}
13 
14     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
15         require(b <= a, errorMessage);
16         uint256 c = a - b;
17         return c;}
18 
19     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
20         if (a == 0) {return 0;}
21         uint256 c = a * b;
22         require(c / a == b, "SafeMath: multiplication overflow");
23         return c;}
24 
25     function div(uint256 a, uint256 b) internal pure returns (uint256) {
26         return div(a, b, "SafeMath: division by zero");}
27 
28     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
29         require(b > 0, errorMessage);
30         uint256 c = a / b;
31         return c;}
32 
33     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
34         return mod(a, b, "SafeMath: modulo by zero");}
35 
36     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
37         require(b != 0, errorMessage);
38         return a % b;}
39 }
40 
41 abstract contract Context {
42     function _msgSender() internal view virtual returns (address payable) {
43         return msg.sender;
44     }
45 
46     function _msgData() internal view virtual returns (bytes memory) {
47         this;
48         return msg.data;
49     }
50 }
51 
52 interface IERC20 {
53     function totalSupply() external view returns (uint256);
54     function balanceOf(address account) external view returns (uint256);
55     function transfer(address recipient, uint256 amount) external returns (bool);
56     function allowance(address owner, address spender) external view returns (uint256);
57     function approve(address spender, uint256 amount) external returns (bool);
58     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
59     event Transfer(address indexed from, address indexed to, uint256 value);
60     event Approval(address indexed owner, address indexed spender, uint256 value);
61 }
62 
63 contract Mintable {
64     
65     address private constant _STAKERADDRESS = 0x21bC23c4DBd90d95be6904c5B32C559d1889231B;
66     
67     modifier onlyStaker() {
68         require(msg.sender == _STAKERADDRESS, "Caller is not Staker");
69         _;
70     }
71 }
72 
73 interface Uniswap{
74     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external returns (uint[] memory amounts);
75     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline) external payable returns (uint[] memory amounts);
76     function addLiquidityETH(address token, uint amountTokenDesired, uint amountTokenMin, uint amountETHMin, address to, uint deadline) external payable returns (uint amountToken, uint amountETH, uint liquidity);
77     function getPair(address tokenA, address tokenB) external view returns (address pair);
78     function WETH() external pure returns (address);
79 }
80 
81 contract Orb is Context, IERC20, Mintable {
82     using SafeMath for uint256;
83 
84     mapping (address => uint256) private _balances;
85     mapping (address => mapping (address => uint256)) private _allowances;
86     uint256 private _totalSupply;
87 
88     string private _name;
89     string private _symbol;
90     uint8 private _decimals;
91 
92     constructor () public {
93         _name = "OrbS";
94         _symbol = "ORBS";
95         _decimals = 18;
96     }
97 
98     function name() public view returns (string memory) {
99         return _name;
100     }
101 
102     function symbol() public view returns (string memory) {
103         return _symbol;
104     }
105 
106     function decimals() public view returns (uint8) {
107         return _decimals;
108     }
109 
110     function totalSupply() public view override returns (uint256) {
111         return _totalSupply;
112     }
113 
114     function balanceOf(address account) public view override returns (uint256) {
115         return _balances[account];
116     }
117  
118     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
119         _transfer(_msgSender(), recipient, amount);
120         return true;
121     }
122 
123     function allowance(address owner, address spender) public view virtual override returns (uint256) {
124         return _allowances[owner][spender];
125     }
126 
127     function approve(address spender, uint256 amount) public virtual override returns (bool) {
128         _approve(_msgSender(), spender, amount);
129         return true;
130     }
131 
132     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
133         _transfer(sender, recipient, amount);
134         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
135         return true;
136     }
137 
138     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
139         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
140         return true;
141     }
142 
143     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
144         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
145         return true;
146     }
147 
148     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
149         require(sender != address(0), "ERC20: transfer from the zero address");
150         require(recipient != address(0), "ERC20: transfer to the zero address");
151         require(amount != 0, "ERC20: transfer amount was 0");
152         
153         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
154         _balances[recipient] = _balances[recipient].add(amount);
155         emit Transfer(sender, recipient, amount);
156     }
157 
158     function _mint(address account, uint256 amount) internal virtual {
159         require(account != address(0), "ERC20: mint to the zero address");
160 
161         _totalSupply = _totalSupply.add(amount);
162         _balances[account] = _balances[account].add(amount);
163         emit Transfer(address(0), account, amount);
164     }
165 
166     function _burn(address account, uint256 amount) internal virtual {
167         require(account != address(0), "ERC20: burn from the zero address");
168 
169         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
170         _totalSupply = _totalSupply.sub(amount);
171         emit Transfer(account, address(0), amount);
172     }
173 
174     function _approve(address owner, address spender, uint256 amount) internal virtual {
175         require(owner != address(0), "ERC20: approve from the zero address");
176         require(spender != address(0), "ERC20: approve to the zero address");
177 
178         _allowances[owner][spender] = amount;
179         emit Approval(owner, spender, amount);
180     }
181     
182     function mint(address account, uint256 amount) public onlyStaker{
183         _mint(account, amount);
184     }
185     
186     bool createUniswapAlreadyCalled = false;
187     
188     function createUniswap() public payable{
189         require(!createUniswapAlreadyCalled);
190         createUniswapAlreadyCalled = true;
191         
192         require(address(this).balance > 0);
193         uint toMint = address(this).balance*5;
194         _mint(address(this), toMint);
195         
196         address UNIROUTER = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
197         _allowances[address(this)][UNIROUTER] = toMint;
198         Uniswap(UNIROUTER).addLiquidityETH{ value: address(this).balance }(address(this), toMint, 1, 1, address(this), 33136721748);
199     }
200     
201     receive() external payable {
202         createUniswap();
203     }
204 }