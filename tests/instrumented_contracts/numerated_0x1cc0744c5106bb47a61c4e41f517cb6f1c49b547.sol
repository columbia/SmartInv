1 pragma solidity 0.6.0;
2 
3 interface IERC20 {
4 
5     function totalSupply() external view returns (uint256);
6     function balanceOf(address account) external view returns (uint256);
7     function transfer(address recipient, uint256 amount) external returns (bool);
8     function allowance(address owner, address spender) external view returns (uint256);
9     function approve(address spender, uint256 amount) external returns (bool);
10     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
11     event Transfer(address indexed from, address indexed to, uint256 value);
12     event Approval(address indexed owner, address indexed spender, uint256 value);
13 }
14 
15 
16 library SafeMath {
17 
18     function add(uint256 a, uint256 b) internal pure returns (uint256) {
19         uint256 c = a + b;
20         require(c >= a, "SafeMath: addition overflow");
21 
22         return c;
23     }
24 
25     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26         return sub(a, b, "SafeMath: subtraction overflow");
27     }
28 
29     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
30         require(b <= a, errorMessage);
31         uint256 c = a - b;
32 
33         return c;
34     }
35 
36     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
37         if (a == 0) {
38             return 0;
39         }
40 
41         uint256 c = a * b;
42         require(c / a == b, "SafeMath: multiplication overflow");
43 
44         return c;
45     }
46 
47     function div(uint256 a, uint256 b) internal pure returns (uint256) {
48         return div(a, b, "SafeMath: division by zero");
49     }
50 
51     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
52         require(b > 0, errorMessage);
53         uint256 c = a / b;
54         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
55 
56         return c;
57     }
58 
59     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
60         return mod(a, b, "SafeMath: modulo by zero");
61     }
62 
63     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
64         require(b != 0, errorMessage);
65         return a % b;
66     }
67 }
68 
69 abstract contract Context {
70     function _msgSender() internal view virtual returns (address payable) {
71         return msg.sender;
72     }
73 
74     function _msgData() internal view virtual returns (bytes memory) {
75         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
76         return msg.data;
77     }
78 }
79 
80 contract ERC20 is Context, IERC20 {
81     using SafeMath for uint256;
82 
83     mapping (address => uint256) private _balances;
84 
85     mapping (address => mapping (address => uint256)) private _allowances;
86 
87     uint256 private _totalSupply;
88 
89     string private _name;
90     string private _symbol;
91     uint8 private _decimals;
92 
93     constructor () public {
94         _name = "Chalice Finance";
95         _symbol = "CHAL";
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
151 
152         _beforeTokenTransfer(sender, recipient, amount);
153 
154         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
155         _balances[recipient] = _balances[recipient].add(amount);
156         emit Transfer(sender, recipient, amount);
157     }
158 
159     function _mint(address account, uint256 amount) internal virtual {
160         require(account != address(0), "ERC20: mint to the zero address");
161 
162         _beforeTokenTransfer(address(0), account, amount);
163 
164         _totalSupply = _totalSupply.add(amount);
165         _balances[account] = _balances[account].add(amount);
166         emit Transfer(address(0), account, amount);
167     }
168 
169     function _burn(address account, uint256 amount) internal virtual {
170         require(account != address(0), "ERC20: burn from the zero address");
171 
172         _beforeTokenTransfer(account, address(0), amount);
173 
174         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
175         _totalSupply = _totalSupply.sub(amount);
176         emit Transfer(account, address(0), amount);
177     }
178 
179     function _approve(address owner, address spender, uint256 amount) internal virtual {
180         require(owner != address(0), "ERC20: approve from the zero address");
181         require(spender != address(0), "ERC20: approve to the zero address");
182 
183         _allowances[owner][spender] = amount;
184         emit Approval(owner, spender, amount);
185     }
186 
187     function _setupDecimals(uint8 decimals_) internal {
188         _decimals = decimals_;
189     }
190 
191     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
192 }
193 
194 
195 contract CHALToken is ERC20 {
196     constructor() public {
197         uint8 decimals_ = 18;
198         uint256 supply_ = 13000 * 10**uint256(decimals_);
199         
200         _mint(msg.sender, supply_);
201         _setupDecimals(decimals_);
202     }
203     
204     function burn(uint256 amount) external {
205         _burn(msg.sender, amount);
206     }
207 }