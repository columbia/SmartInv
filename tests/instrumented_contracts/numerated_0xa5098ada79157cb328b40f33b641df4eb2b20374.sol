1 pragma solidity >=0.6.2;
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
40 
41 interface IERC20 {
42 	event Approval(address indexed owner, address indexed spender, uint value);
43     event Transfer(address indexed from, address indexed to, uint value);
44 
45     function name() external view returns (string memory);
46     function symbol() external view returns (string memory);
47     function decimals() external view returns (uint8);
48     function totalSupply() external view returns (uint);
49     function balanceOf(address owner) external view returns (uint);
50     function allowance(address owner, address spender) external view returns (uint);
51 
52     function approve(address spender, uint value) external returns (bool);
53     function transfer(address to, uint value) external returns (bool);
54     function transferFrom(address from, address to, uint value) external returns (bool);
55 }
56 
57 
58 interface IUniswapV2Router02 {
59     function addLiquidityETH(
60         address token,
61         uint amountTokenDesired,
62         uint amountTokenMin,
63         uint amountETHMin,
64         address to,
65         uint deadline
66     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
67     function removeLiquidityETH(
68       address token,
69       uint liquidity,
70       uint amountTokenMin,
71       uint amountETHMin,
72       address to,
73       uint deadline
74     ) external returns (uint amountToken, uint amountETH);
75 }
76 
77 
78 abstract contract Context {
79     function _msgSender() internal view virtual returns (address payable) {
80         return msg.sender;
81     }
82 
83     function _msgData() internal view virtual returns (bytes memory) {
84         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
85         return msg.data;
86     }
87 }
88 
89 
90 contract Euler is Context, IERC20 {
91     using SafeMath for uint256;
92 
93     mapping(address => uint256) private _balances;
94     mapping(address => mapping (address => uint256)) private _allowances;
95     uint256 private _totalSupply;
96 
97     string private _name;
98     string private _symbol;
99     uint8 private _decimals;
100 	address private immutable ADMIN_ADDRESS;
101 
102     constructor () public {
103         _name = "Euler";
104         _symbol = "EXP";
105         _decimals = 18;
106 		ADMIN_ADDRESS = msg.sender;
107     }
108 	
109 	address private STAKERADDRESS;
110 	bool private StakerAddressGiven = false;
111 	bool private uniswapCreated = false;
112 
113 	
114 	//Admin function to define address of staking contract
115     //Can only be called once to set staker address
116     function setStakerAddress(address _STAKERADDRESS) public {
117 		require(msg.sender == ADMIN_ADDRESS, "Caller is not admin.");
118         require(!StakerAddressGiven, "Staker Address already defined.");
119         StakerAddressGiven = true;
120         STAKERADDRESS = _STAKERADDRESS;
121     }
122 
123     function name() public view override returns (string memory) {
124         return _name;
125     }
126 
127     function symbol() public view override returns (string memory) {
128         return _symbol;
129     }
130 
131     function decimals() public view override returns (uint8) {
132         return _decimals;
133     }
134 
135     function totalSupply() public view override returns (uint256) {
136         return _totalSupply;
137     }
138 
139     function balanceOf(address account) public view override returns (uint256) {
140         return _balances[account];
141     }
142  
143     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
144         _transfer(_msgSender(), recipient, amount);
145         return true;
146     }
147 
148     function allowance(address owner, address spender) public view virtual override returns (uint256) {
149         return _allowances[owner][spender];
150     }
151 
152     function approve(address spender, uint256 amount) public virtual override returns (bool) {
153         _approve(_msgSender(), spender, amount);
154         return true;
155     }
156 
157     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
158         _transfer(sender, recipient, amount);
159         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
160         return true;
161     }
162 
163     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
164         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
165         return true;
166     }
167 
168     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
169         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
170         return true;
171     }
172 
173     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
174         require(sender != address(0), "ERC20: transfer from the zero address");
175         require(recipient != address(0), "ERC20: transfer to the zero address");
176         require(amount != 0, "ERC20: transfer amount was 0");
177         
178         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
179         _balances[recipient] = _balances[recipient].add(amount);
180         emit Transfer(sender, recipient, amount);
181     }
182 
183     function _mint(address account, uint256 amount) internal virtual {
184         require(account != address(0), "ERC20: mint to the zero address");
185 
186         _totalSupply = _totalSupply.add(amount);
187         _balances[account] = _balances[account].add(amount);
188         emit Transfer(address(0), account, amount);
189     }
190 
191     function _burn(address account, uint256 amount) internal virtual {
192         require(account != address(0), "ERC20: burn from the zero address");
193 
194         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
195         _totalSupply = _totalSupply.sub(amount);
196         emit Transfer(account, address(0), amount);
197     }
198 
199     function _approve(address owner, address spender, uint256 amount) internal virtual {
200         require(owner != address(0), "ERC20: approve from the zero address");
201         require(spender != address(0), "ERC20: approve to the zero address");
202 
203         _allowances[owner][spender] = amount;
204         emit Approval(owner, spender, amount);
205     }
206     
207     function mint(address account, uint256 amount) public {
208 		require(msg.sender == STAKERADDRESS, "Caller is not Staker");
209         _mint(account, amount);
210     }
211     
212     function burn(uint256 amount) public virtual {
213         _burn(_msgSender(), amount);
214     }
215 }