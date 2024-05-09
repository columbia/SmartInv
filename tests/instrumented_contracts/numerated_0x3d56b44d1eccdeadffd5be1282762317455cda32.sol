1 pragma solidity 0.6.12;
2 
3 
4 /**
5  *Submitted for verification at Etherscan.io on 2020-09-25
6 */
7 library SafeMath {
8 
9     function add(uint256 a, uint256 b) internal pure returns (uint256) {
10         uint256 c = a + b;
11         require(c >= a, "SafeMath: addition overflow");
12         return c;}
13 
14     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
15         return sub(a, b, "SafeMath: subtraction overflow");}
16 
17     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
18         require(b <= a, errorMessage);
19         uint256 c = a - b;
20         return c;}
21 
22     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
23         if (a == 0) {return 0;}
24         uint256 c = a * b;
25         require(c / a == b, "SafeMath: multiplication overflow");
26         return c;}
27 
28     function div(uint256 a, uint256 b) internal pure returns (uint256) {
29         return div(a, b, "SafeMath: division by zero");}
30 
31     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
32         require(b > 0, errorMessage);
33         uint256 c = a / b;
34         return c;}
35 
36     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
37         return mod(a, b, "SafeMath: modulo by zero");}
38 
39     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
40         require(b != 0, errorMessage);
41         return a % b;}
42 }
43 
44 abstract contract Context {
45     function _msgSender() internal view virtual returns (address payable) {
46         return msg.sender;
47     }
48 
49     function _msgData() internal view virtual returns (bytes memory) {
50         this;
51         return msg.data;
52     }
53 }
54 
55 interface IERC20 {
56     function totalSupply() external view returns (uint256);
57     function balanceOf(address account) external view returns (uint256);
58     function transfer(address recipient, uint256 amount) external returns (bool);
59     function allowance(address owner, address spender) external view returns (uint256);
60     function approve(address spender, uint256 amount) external returns (bool);
61     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
62     event Transfer(address indexed from, address indexed to, uint256 value);
63     event Approval(address indexed owner, address indexed spender, uint256 value);
64 }
65 
66 contract Mintable {
67 
68     address public STAKERADDRESS;
69 
70     modifier onlyStaker() {
71         require(msg.sender == STAKERADDRESS, "Caller is not Staker");
72         _;
73     }
74 }
75 
76 interface Uniswap {
77     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external returns (uint[] memory amounts);
78     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline) external payable returns (uint[] memory amounts);
79     function addLiquidityETH(address token, uint amountTokenDesired, uint amountTokenMin, uint amountETHMin, address to, uint deadline) external payable returns (uint amountToken, uint amountETH, uint liquidity);
80     function getPair(address tokenA, address tokenB) external view returns (address pair);
81     function WETH() external pure returns (address);
82 }
83 
84 contract FOMOToken is Context, IERC20, Mintable {
85     using SafeMath for uint256;
86 
87     mapping (address => uint256) private _balances;
88     mapping (address => mapping (address => uint256)) private _allowances;
89     uint256 private _totalSupply;
90 
91     string private _name;
92     string private _symbol;
93     uint8 private _decimals;
94 
95     constructor (address _STAKERADDRESS) public {
96         STAKERADDRESS = _STAKERADDRESS;
97         _name = "FOMO World";
98         _symbol = "FOMO";
99         _decimals = 18;
100     }
101 
102     function name() public view returns (string memory) {
103         return _name;
104     }
105 
106     function symbol() public view returns (string memory) {
107         return _symbol;
108     }
109 
110     function decimals() public view returns (uint8) {
111         return _decimals;
112     }
113 
114     function totalSupply() public view override returns (uint256) {
115         return _totalSupply;
116     }
117 
118     function balanceOf(address account) public view override returns (uint256) {
119         return _balances[account];
120     }
121 
122     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
123         _transfer(_msgSender(), recipient, amount);
124         return true;
125     }
126 
127     function allowance(address owner, address spender) public view virtual override returns (uint256) {
128         return _allowances[owner][spender];
129     }
130 
131     function approve(address spender, uint256 amount) public virtual override returns (bool) {
132         _approve(_msgSender(), spender, amount);
133         return true;
134     }
135 
136     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
137         _transfer(sender, recipient, amount);
138         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
139         return true;
140     }
141 
142     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
143         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
144         return true;
145     }
146 
147     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
148         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
149         return true;
150     }
151 
152     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
153         require(sender != address(0), "ERC20: transfer from the zero address");
154         require(recipient != address(0), "ERC20: transfer to the zero address");
155         require(amount != 0, "ERC20: transfer amount was 0");
156 
157         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
158         _balances[recipient] = _balances[recipient].add(amount);
159         emit Transfer(sender, recipient, amount);
160     }
161 
162     function _mint(address account, uint256 amount) internal virtual {
163         require(account != address(0), "ERC20: mint to the zero address");
164 
165         _totalSupply = _totalSupply.add(amount);
166         _balances[account] = _balances[account].add(amount);
167         emit Transfer(address(0), account, amount);
168     }
169 
170     function _burn(address account, uint256 amount) internal virtual {
171         require(account != address(0), "ERC20: burn from the zero address");
172 
173         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
174         _totalSupply = _totalSupply.sub(amount);
175         emit Transfer(account, address(0), amount);
176     }
177 
178     function _approve(address owner, address spender, uint256 amount) internal virtual {
179         require(owner != address(0), "ERC20: approve from the zero address");
180         require(spender != address(0), "ERC20: approve to the zero address");
181 
182         _allowances[owner][spender] = amount;
183         emit Approval(owner, spender, amount);
184     }
185 
186     function mint(address account, uint256 amount) public onlyStaker{
187         _mint(account, amount);
188     }
189 
190     bool createUniswapAlreadyCalled = false;
191 
192     function createUniswap() public payable{
193         require(!createUniswapAlreadyCalled);
194         createUniswapAlreadyCalled = true;
195 
196         require(address(this).balance > 0);
197         uint toMint = address(this).balance*5;
198         _mint(address(this), toMint);
199 
200         address UNIROUTER = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
201         _allowances[address(this)][UNIROUTER] = toMint;
202         Uniswap(UNIROUTER).addLiquidityETH{ value: address(this).balance }(address(this), toMint, 1, 1, address(this), 33136721748);
203     }
204 
205     receive() external payable {
206         createUniswap();
207     }
208 }