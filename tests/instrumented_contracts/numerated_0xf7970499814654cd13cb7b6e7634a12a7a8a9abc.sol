1 pragma solidity ^0.5.0;
2 
3 contract Context {
4     constructor () internal { }
5 
6     function _msgSender() internal view returns (address) {
7         return msg.sender;
8     }
9 
10     function _msgData() internal view returns (bytes memory) {
11         this;
12         return msg.data;
13     }
14 }
15 
16 interface IERC20 {
17     function totalSupply() external view returns (uint256);
18     function balanceOf(address account) external view returns (uint256);
19     function transfer(address recipient, uint256 amount) external returns (bool);
20     function allowance(address owner, address spender) external view returns (uint256);
21     function approve(address spender, uint256 amount) external returns (bool);
22     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
23     event Transfer(address indexed from, address indexed to, uint256 value);
24     event Approval(address indexed owner, address indexed spender, uint256 value);
25 }
26 
27 library SafeMath {
28     function add(uint256 a, uint256 b) internal pure returns (uint256) {
29         uint256 c = a + b;
30         require(c >= a, "SafeMath: addition overflow");
31 
32         return c;
33     }
34 
35     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36         return sub(a, b, "SafeMath: subtraction overflow");
37     }
38 
39     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
40         require(b <= a, errorMessage);
41         uint256 c = a - b;
42 
43         return c;
44     }
45 
46     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
47         if (a == 0) {
48             return 0;
49         }
50 
51         uint256 c = a * b;
52         require(c / a == b, "SafeMath: multiplication overflow");
53 
54         return c;
55     }
56 
57     function div(uint256 a, uint256 b) internal pure returns (uint256) {
58         return div(a, b, "SafeMath: division by zero");
59     }
60 
61     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
62         require(b > 0, errorMessage);
63         uint256 c = a / b;
64 
65         return c;
66     }
67 
68     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
69         return mod(a, b, "SafeMath: modulo by zero");
70     }
71 
72     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
73         require(b != 0, errorMessage);
74         return a % b;
75     }
76 }
77 
78 contract ERC20 is Context, IERC20 {
79     using SafeMath for uint256;
80 
81     mapping (address => uint256) private _balances;
82 
83     mapping (address => mapping (address => uint256)) private _allowances;
84 
85     string private _name;
86     string private _symbol;
87     uint8 private _decimals;
88 
89     uint256 private _totalSupply;
90 
91     constructor (
92         string memory name,
93         string memory symbol,
94         uint8 decimals,
95         uint256 totalSupply
96     ) public {
97         _name = name;
98         _symbol = symbol;
99         _decimals = decimals;
100         _mint(msg.sender, totalSupply);
101     }
102 
103     function name() public view returns (string memory) {
104         return _name;
105     }
106 
107     function symbol() public view returns (string memory) {
108         return _symbol;
109     }
110 
111     function decimals() public view returns (uint8) {
112         return _decimals;
113     }
114 
115     function totalSupply() public view returns (uint256) {
116         return _totalSupply;
117     }
118 
119     function balanceOf(address account) public view returns (uint256) {
120         return _balances[account];
121     }
122 
123     function transfer(address recipient, uint256 amount) public returns (bool) {
124         _transfer(_msgSender(), recipient, amount);
125         return true;
126     }
127 
128     function allowance(address owner, address spender) public view returns (uint256) {
129         return _allowances[owner][spender];
130     }
131 
132     function approve(address spender, uint256 amount) public returns (bool) {
133         _approve(_msgSender(), spender, amount);
134         return true;
135     }
136 
137     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
138         _transfer(sender, recipient, amount);
139         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
140         return true;
141     }
142 
143     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
144         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
145         return true;
146     }
147 
148     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
149         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
150         return true;
151     }
152 
153     function _transfer(address sender, address recipient, uint256 amount) internal {
154         require(sender != address(0), "ERC20: transfer from the zero address");
155         require(recipient != address(0), "ERC20: transfer to the zero address");
156 
157         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
158         _balances[recipient] = _balances[recipient].add(amount);
159         emit Transfer(sender, recipient, amount);
160     }
161 
162     function _mint(address account, uint256 amount) internal {
163         require(account != address(0), "ERC20: mint to the zero address");
164 
165         _totalSupply = _totalSupply.add(amount);
166         _balances[account] = _balances[account].add(amount);
167         emit Transfer(address(0), account, amount);
168     }
169 
170     function _burn(address account, uint256 amount) internal {
171         require(account != address(0), "ERC20: burn from the zero address");
172 
173         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
174         _totalSupply = _totalSupply.sub(amount);
175         emit Transfer(account, address(0), amount);
176     }
177 
178     function _approve(address owner, address spender, uint256 amount) internal {
179         require(owner != address(0), "ERC20: approve from the zero address");
180         require(spender != address(0), "ERC20: approve to the zero address");
181 
182         _allowances[owner][spender] = amount;
183         emit Approval(owner, spender, amount);
184     }
185 
186     function _burnFrom(address account, uint256 amount) internal {
187         _burn(account, amount);
188         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
189     }
190 }