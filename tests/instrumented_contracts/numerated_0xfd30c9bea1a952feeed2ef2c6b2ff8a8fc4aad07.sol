1 pragma solidity ^0.6.0;
2 
3 interface IERC20 {
4 
5     function totalSupply() external view returns (uint256);
6 
7     function balanceOf(address account) external view returns (uint256);
8 
9     function transfer(address recipient, uint256 amount) external returns (bool);
10 
11     function allowance(address owner, address spender) external view returns (uint256);
12 
13     function approve(address spender, uint256 amount) external returns (bool);
14 
15     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
16 
17     event Transfer(address indexed from, address indexed to, uint256 value);
18 
19     event Approval(address indexed owner, address indexed spender, uint256 value);
20 }
21 
22 pragma solidity ^0.6.0;
23 
24 library SafeMath {
25 
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         require(c >= a, "SafeMath: addition overflow");
29 
30         return c;
31     }
32 
33     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34         return sub(a, b, "SafeMath: subtraction overflow");
35     }
36 
37     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
38         require(b <= a, errorMessage);
39         uint256 c = a - b;
40 
41         return c;
42     }
43 
44     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
45 
46         if (a == 0) {
47             return 0;
48         }
49 
50         uint256 c = a * b;
51         require(c / a == b, "SafeMath: multiplication overflow");
52 
53         return c;
54     }
55 
56     function div(uint256 a, uint256 b) internal pure returns (uint256) {
57         return div(a, b, "SafeMath: division by zero");
58     }
59 
60     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
61         require(b > 0, errorMessage);
62         uint256 c = a / b;
63 
64         return c;
65     }
66 
67     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
68         return mod(a, b, "SafeMath: modulo by zero");
69     }
70 
71     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
72         require(b != 0, errorMessage);
73         return a % b;
74     }
75 }
76 
77 pragma solidity ^0.6.0;
78 
79 contract ERC20 is IERC20 {
80     using SafeMath for uint256;
81 
82     mapping (address => uint256) private _balances;
83 
84     mapping (address => mapping (address => uint256)) private _allowances;
85 
86     uint256 private _totalSupply;
87 
88     string private _name;
89     string private _symbol;
90     uint8 private _decimals;
91 
92     constructor (string memory name, string memory symbol, uint8 decimals) public {
93         _name = name;
94         _symbol = symbol;
95         _decimals = decimals;
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
119         _transfer(msg.sender, recipient, amount);
120         return true;
121     }
122 
123     function allowance(address owner, address spender) public view virtual override returns (uint256) {
124         return _allowances[owner][spender];
125     }
126 
127     function approve(address spender, uint256 amount) public virtual override returns (bool) {
128         _approve(msg.sender, spender, amount);
129         return true;
130     }
131 
132     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
133         _transfer(sender, recipient, amount);
134         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
135         return true;
136     }
137 
138     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
139         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
140         return true;
141     }
142 
143     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
144         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
145         return true;
146     }
147 
148     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
149         require(sender != address(0), "ERC20: transfer from the zero address");
150         require(recipient != address(0), "ERC20: transfer to the zero address");
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
180 }
181 
182 
183 pragma solidity ^0.6.0;
184 
185 abstract contract ERC20Burnable is ERC20 {
186 
187     function burn(uint256 amount) public virtual {
188         _burn(msg.sender, amount);
189     }
190 
191     function burnFrom(address account, uint256 amount) public virtual {
192         uint256 decreasedAllowance = allowance(account, msg.sender).sub(amount, "ERC20: burn amount exceeds allowance");
193 
194         _approve(account, msg.sender, decreasedAllowance);
195         _burn(account, amount);
196     }
197 }
198 
199 pragma solidity ^0.6.0;
200 
201 contract Polkally is ERC20Burnable {
202     uint256 public constant INITIAL_SUPPLY = 100000 * 10**3 * 10**18;
203 
204     constructor() ERC20("Polkally", "KALLY", 18) public {
205         _mint(msg.sender, INITIAL_SUPPLY);
206     }
207 }