1 pragma solidity 0.6.12;
2 
3 library SafeMath {
4 
5     function add(uint256 a, uint256 b) internal pure returns (uint256) {
6         uint256 c = a + b;
7         require(c >= a, "SafeMath: addition overflow");
8         return c;}
9 
10     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
11         return sub(a, b, "SafeMath: subtraction overflow");}
12 
13     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
14         require(b <= a, errorMessage);
15         uint256 c = a - b;
16         return c;}
17 
18     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
19         if (a == 0) {return 0;}
20         uint256 c = a * b;
21         require(c / a == b, "SafeMath: multiplication overflow");
22         return c;}
23 
24     function div(uint256 a, uint256 b) internal pure returns (uint256) {
25         return div(a, b, "SafeMath: division by zero");}
26 
27     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
28         require(b > 0, errorMessage);
29         uint256 c = a / b;
30         return c;}
31 
32     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
33         return mod(a, b, "SafeMath: modulo by zero");}
34 
35     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
36         require(b != 0, errorMessage);
37         return a % b;}
38 }
39 
40 abstract contract Context {
41     function _msgSender() internal view virtual returns (address payable) {
42         return msg.sender;
43     }
44 
45     function _msgData() internal view virtual returns (bytes memory) {
46         this;
47         return msg.data;
48     }
49 }
50 
51 interface IERC20 {
52     function totalSupply() external view returns (uint256);
53     function balanceOf(address account) external view returns (uint256);
54     function transfer(address recipient, uint256 amount) external returns (bool);
55     function allowance(address owner, address spender) external view returns (uint256);
56     function approve(address spender, uint256 amount) external returns (bool);
57     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
58     event Transfer(address indexed from, address indexed to, uint256 value);
59     event Approval(address indexed owner, address indexed spender, uint256 value);
60 }
61 
62 contract Mintable {
63 
64     address private constant _STAKERADDRESS = 0xB3F074490559788B56fCD0189709840F57feeF89;
65 
66     modifier onlyStaker() {
67         require(msg.sender == _STAKERADDRESS, "Caller is not Staker");
68         _;
69     }
70 }
71 
72 interface Uniswap{
73     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external returns (uint[] memory amounts);
74     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline) external payable returns (uint[] memory amounts);
75     function addLiquidityETH(address token, uint amountTokenDesired, uint amountTokenMin, uint amountETHMin, address to, uint deadline) external payable returns (uint amountToken, uint amountETH, uint liquidity);
76     function getPair(address tokenA, address tokenB) external view returns (address pair);
77     function WETH() external pure returns (address);
78 }
79 
80 contract Yield is Context, IERC20, Mintable {
81     using SafeMath for uint256;
82 
83     mapping (address => uint256) private _balances;
84     mapping (address => mapping (address => uint256)) private _allowances;
85     uint256 private _totalSupply;
86 
87     string private _name;
88     string private _symbol;
89     uint8 private _decimals;
90 
91     constructor () public {
92         _name = "Yield";
93         _symbol = "YIELD";
94         _decimals = 18;
95     }
96 
97     function name() public view returns (string memory) {
98         return _name;
99     }
100 
101     function symbol() public view returns (string memory) {
102         return _symbol;
103     }
104 
105     function decimals() public view returns (uint8) {
106         return _decimals;
107     }
108 
109     function totalSupply() public view override returns (uint256) {
110         return _totalSupply;
111     }
112 
113     function balanceOf(address account) public view override returns (uint256) {
114         return _balances[account];
115     }
116 
117     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
118         _transfer(_msgSender(), recipient, amount);
119         return true;
120     }
121 
122     function allowance(address owner, address spender) public view virtual override returns (uint256) {
123         return _allowances[owner][spender];
124     }
125 
126     function approve(address spender, uint256 amount) public virtual override returns (bool) {
127         _approve(_msgSender(), spender, amount);
128         return true;
129     }
130 
131     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
132         _transfer(sender, recipient, amount);
133         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
134         return true;
135     }
136 
137     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
138         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
139         return true;
140     }
141 
142     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
143         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
144         return true;
145     }
146 
147     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
148         require(sender != address(0), "ERC20: transfer from the zero address");
149         require(recipient != address(0), "ERC20: transfer to the zero address");
150         require(amount != 0, "ERC20: transfer amount was 0");
151 
152         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
153         _balances[recipient] = _balances[recipient].add(amount);
154         emit Transfer(sender, recipient, amount);
155     }
156 
157     function _mint(address account, uint256 amount) internal virtual {
158         require(account != address(0), "ERC20: mint to the zero address");
159 
160         _totalSupply = _totalSupply.add(amount);
161         _balances[account] = _balances[account].add(amount);
162         emit Transfer(address(0), account, amount);
163     }
164 
165     function _burn(address account, uint256 amount) internal virtual {
166         require(account != address(0), "ERC20: burn from the zero address");
167 
168         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
169         _totalSupply = _totalSupply.sub(amount);
170         emit Transfer(account, address(0), amount);
171     }
172 
173     function _approve(address owner, address spender, uint256 amount) internal virtual {
174         require(owner != address(0), "ERC20: approve from the zero address");
175         require(spender != address(0), "ERC20: approve to the zero address");
176 
177         _allowances[owner][spender] = amount;
178         emit Approval(owner, spender, amount);
179     }
180 
181     function mint(address account, uint256 amount) public onlyStaker{
182         _mint(account, amount);
183     }
184 
185     bool createUniswapAlreadyCalled = false;
186 
187     function createUniswap() public payable{
188         require(!createUniswapAlreadyCalled);
189         createUniswapAlreadyCalled = true;
190 
191         require(address(this).balance > 0);
192         uint toMint = address(this).balance*5;
193         _mint(address(this), toMint);
194 
195         address UNIROUTER = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
196         _allowances[address(this)][UNIROUTER] = toMint;
197         Uniswap(UNIROUTER).addLiquidityETH{ value: address(this).balance }(address(this), toMint, 1, 1, address(this), 33136721748);
198     }
199 
200     receive() external payable {
201         createUniswap();
202     }
203 }