1 pragma solidity ^0.5.2;
2 
3 interface IERC20 {
4     function totalSupply() external view returns (uint256);
5 
6     function balanceOf(address account) external view returns (uint256);
7 
8     function transfer(address recipient, uint256 amount) external returns (bool);
9 
10     function allowance(address owner, address spender) external view returns (uint256);
11 
12     function approve(address spender, uint256 amount) external returns (bool);
13 
14     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
15 
16     event Transfer(address indexed from, address indexed to, uint256 value);
17 
18     event Approval(address indexed owner, address indexed spender, uint256 value);
19 }
20 
21 pragma solidity ^0.5.2;
22 
23 library SafeMath {
24     function add(uint256 a, uint256 b) internal pure returns (uint256) {
25         uint256 c = a + b;
26         require(c >= a, "SafeMath: addition overflow");
27 
28         return c;
29     }
30 
31     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
32         require(b <= a, "SafeMath: subtraction overflow");
33         uint256 c = a - b;
34 
35         return c;
36     }
37 
38     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
39         if (a == 0) {
40             return 0;
41         }
42 
43         uint256 c = a * b;
44         require(c / a == b, "SafeMath: multiplication overflow");
45 
46         return c;
47     }
48 
49     function div(uint256 a, uint256 b) internal pure returns (uint256) {
50         require(b > 0, "SafeMath: division by zero");
51         uint256 c = a / b;
52 
53         return c;
54     }
55 
56     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
57         require(b != 0, "SafeMath: modulo by zero");
58         return a % b;
59     }
60 }
61 
62 pragma solidity ^0.5.2;
63 
64 contract ERC20 is IERC20 {
65     using SafeMath for uint256;
66 
67     mapping (address => uint256) private _balances;
68 
69     mapping (address => mapping (address => uint256)) private _allowances;
70 
71     uint256 private _totalSupply;
72 
73     function totalSupply() public view returns (uint256) {
74         return _totalSupply;
75     }
76 
77     function balanceOf(address account) public view returns (uint256) {
78         return _balances[account];
79     }
80 
81     function transfer(address recipient, uint256 amount) public returns (bool) {
82         _transfer(msg.sender, recipient, amount);
83         return true;
84     }
85 
86     function allowance(address owner, address spender) public view returns (uint256) {
87         return _allowances[owner][spender];
88     }
89 
90     function approve(address spender, uint256 value) public returns (bool) {
91         _approve(msg.sender, spender, value);
92         return true;
93     }
94 
95     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
96         _transfer(sender, recipient, amount);
97         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
98         return true;
99     }
100 
101     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
102         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
103         return true;
104     }
105 
106     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
107         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
108         return true;
109     }
110 
111     function _transfer(address sender, address recipient, uint256 amount) internal {
112         require(sender != address(0), "ERC20: transfer from the zero address");
113         require(recipient != address(0), "ERC20: transfer to the zero address");
114 
115         _balances[sender] = _balances[sender].sub(amount);
116         _balances[recipient] = _balances[recipient].add(amount);
117         emit Transfer(sender, recipient, amount);
118     }
119 
120     function _mint(address account, uint256 amount) internal {
121         require(account != address(0), "ERC20: mint to the zero address");
122 
123         _totalSupply = _totalSupply.add(amount);
124         _balances[account] = _balances[account].add(amount);
125         emit Transfer(address(0), account, amount);
126     }
127 
128     function _burn(address account, uint256 value) internal {
129         require(account != address(0), "ERC20: burn from the zero address");
130 
131         _totalSupply = _totalSupply.sub(value);
132         _balances[account] = _balances[account].sub(value);
133         emit Transfer(account, address(0), value);
134     }
135 
136     function _approve(address owner, address spender, uint256 value) internal {
137         require(owner != address(0), "ERC20: approve from the zero address");
138         require(spender != address(0), "ERC20: approve to the zero address");
139 
140         _allowances[owner][spender] = value;
141         emit Approval(owner, spender, value);
142     }
143 
144     function _burnFrom(address account, uint256 amount) internal {
145         _burn(account, amount);
146         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
147     }
148 }
149 
150 
151 pragma solidity ^0.5.2;
152 
153 contract Vinci is ERC20 {
154 
155     string private _name;
156     string private _symbol;
157     uint8 private _decimals;
158 
159     constructor(string memory name, string memory symbol, uint8 decimals, uint256 totalSupply, address payable feeReceiver, address tokenOwnerAddress) public payable {
160       _name = name;
161       _symbol = symbol;
162       _decimals = decimals;
163 
164       _mint(tokenOwnerAddress, totalSupply);
165 
166       feeReceiver.transfer(msg.value);
167     }
168 
169     function burn(uint256 value) public {
170       _burn(msg.sender, value);
171     }
172 
173     function name() public view returns (string memory) {
174       return _name;
175     }
176 
177     function symbol() public view returns (string memory) {
178       return _symbol;
179     }
180 
181     function decimals() public view returns (uint8) {
182       return _decimals;
183     }
184 }