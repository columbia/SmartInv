1 // SPDX-License-Identifier: MIT
2 
3 /*
4  
5 _________  ________ ________________________   ____________  
6 \_   ___ \ \_____  \\______   \______   \   \ /   /\_____  \ 
7 /    \  \/  /   |   \|       _/|    |  _/\   Y   /  /  ____/ 
8 \     \____/    |    \    |   \|    |   \ \     /  /       \ 
9  \______  /\_______  /____|_  /|______  /  \___/   \_______ \
10 
11  
12 forked from Orb + Core
13 
14 
15 Website: corb.finance
16 
17 */
18 
19 
20 
21 pragma solidity ^0.6.6;
22 
23 library SafeMath {
24    
25     function add(uint256 a, uint256 b) internal pure returns (uint256) {
26         uint256 c = a + b;
27         require(c >= a, "SafeMath: addition overflow");
28         return c;}
29 
30     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31         return sub(a, b, "SafeMath: subtraction overflow");}
32 
33     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
34         require(b <= a, errorMessage);
35         uint256 c = a - b;
36         return c;}
37 
38     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
39         if (a == 0) {return 0;}
40         uint256 c = a * b;
41         require(c / a == b, "SafeMath: multiplication overflow");
42         return c;}
43 
44     function div(uint256 a, uint256 b) internal pure returns (uint256) {
45         return div(a, b, "SafeMath: division by zero");}
46 
47     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
48         require(b > 0, errorMessage);
49         uint256 c = a / b;
50         return c;}
51 
52     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
53         return mod(a, b, "SafeMath: modulo by zero");}
54 
55     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
56         require(b != 0, errorMessage);
57         return a % b;}
58 }
59 
60 abstract contract Context {
61     function _msgSender() internal view virtual returns (address payable) {
62         return msg.sender;
63     }
64 
65     function _msgData() internal view virtual returns (bytes memory) {
66         this;
67         return msg.data;
68     }
69 }
70 
71 interface IERC20 {
72     function totalSupply() external view returns (uint256);
73     function balanceOf(address account) external view returns (uint256);
74     function transfer(address recipient, uint256 amount) external returns (bool);
75     function allowance(address owner, address spender) external view returns (uint256);
76     function approve(address spender, uint256 amount) external returns (bool);
77     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
78     event Transfer(address indexed from, address indexed to, uint256 value);
79     event Approval(address indexed owner, address indexed spender, uint256 value);
80 }
81 
82 contract Mintable {
83     
84     address private constant _STAKERADDRESS = 0x8072b65a95165Ad7020B791E436775034Fec89Fb;
85     
86     modifier onlyStaker() {
87         require(msg.sender == _STAKERADDRESS, "Caller is not Staker");
88         _;
89     }
90 }
91 
92 interface Uniswap{
93     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external returns (uint[] memory amounts);
94     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline) external payable returns (uint[] memory amounts);
95     function addLiquidityETH(address token, uint amountTokenDesired, uint amountTokenMin, uint amountETHMin, address to, uint deadline) external payable returns (uint amountToken, uint amountETH, uint liquidity);
96     function getPair(address tokenA, address tokenB) external view returns (address pair);
97     function WETH() external pure returns (address);
98 }
99 
100 contract CorbV2 is Context, IERC20, Mintable {
101     using SafeMath for uint256;
102 
103     mapping (address => uint256) private _balances;
104     mapping (address => mapping (address => uint256)) private _allowances;
105     uint256 private _totalSupply;
106 
107     string private _name;
108     string private _symbol;
109     uint8 private _decimals;
110 
111     constructor () public {
112         _name = "CorbV2";
113         _symbol = "CorbV2";
114         _decimals = 18;
115     }
116 
117     function name() public view returns (string memory) {
118         return _name;
119     }
120 
121     function symbol() public view returns (string memory) {
122         return _symbol;
123     }
124 
125     function decimals() public view returns (uint8) {
126         return _decimals;
127     }
128 
129     function totalSupply() public view override returns (uint256) {
130         return _totalSupply;
131     }
132 
133     function balanceOf(address account) public view override returns (uint256) {
134         return _balances[account];
135     }
136  
137     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
138         _transfer(_msgSender(), recipient, amount);
139         return true;
140     }
141 
142     function allowance(address owner, address spender) public view virtual override returns (uint256) {
143         return _allowances[owner][spender];
144     }
145 
146     function approve(address spender, uint256 amount) public virtual override returns (bool) {
147         _approve(_msgSender(), spender, amount);
148         return true;
149     }
150 
151     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
152         _transfer(sender, recipient, amount);
153         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
154         return true;
155     }
156 
157     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
158         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
159         return true;
160     }
161 
162     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
163         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
164         return true;
165     }
166 
167     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
168         require(sender != address(0), "ERC20: transfer from the zero address");
169         require(recipient != address(0), "ERC20: transfer to the zero address");
170         require(amount != 0, "ERC20: transfer amount was 0");
171         
172         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
173         _balances[recipient] = _balances[recipient].add(amount);
174         emit Transfer(sender, recipient, amount);
175     }
176 
177     function _mint(address account, uint256 amount) internal virtual {
178         require(account != address(0), "ERC20: mint to the zero address");
179 
180         _totalSupply = _totalSupply.add(amount);
181         _balances[account] = _balances[account].add(amount);
182         emit Transfer(address(0), account, amount);
183     }
184 
185     function _burn(address account, uint256 amount) internal virtual {
186         require(account != address(0), "ERC20: burn from the zero address");
187 
188         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
189         _totalSupply = _totalSupply.sub(amount);
190         emit Transfer(account, address(0), amount);
191     }
192     
193     function burn(uint256 amount) public {
194         _burn(msg.sender, amount);
195     }
196     
197     function _approve(address owner, address spender, uint256 amount) internal virtual {
198         require(owner != address(0), "ERC20: approve from the zero address");
199         require(spender != address(0), "ERC20: approve to the zero address");
200 
201         _allowances[owner][spender] = amount;
202         emit Approval(owner, spender, amount);
203     }
204     
205     function mint(address account, uint256 amount) public onlyStaker{
206         _mint(account, amount);
207     }
208     
209     bool createUniswapAlreadyCalled = false;
210     
211     function createUniswap() public payable{
212         require(!createUniswapAlreadyCalled);
213         createUniswapAlreadyCalled = true;
214         
215         require(address(this).balance > 0);
216         uint toMint = address(this).balance;
217         _mint(address(this), toMint);
218         
219         address UNIROUTER = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
220         _allowances[address(this)][UNIROUTER] = toMint;
221         Uniswap(UNIROUTER).addLiquidityETH{ value: address(this).balance }(address(this), toMint, 1, 1, address(this), 33136721748);
222     }
223     
224     receive() external payable {
225         createUniswap();
226     }
227 }