1 pragma solidity ^0.5.0;
2 interface IERC20 {
3     function totalSupply() external view returns (uint256);
4 
5     function balanceOf(address account) external view returns (uint256);
6 
7     function transfer(address recipient, uint256 amount) external returns (bool);
8 
9     function allowance(address owner, address spender) external view returns (uint256);
10 
11     function approve(address spender, uint256 amount) external returns (bool);
12 
13     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
14 
15     event Transfer(address indexed from, address indexed to, uint256 value);
16     event Approval(address indexed owner, address indexed spender, uint256 value);
17 }
18 
19 pragma solidity ^0.5.0;
20 
21 library SafeMath {
22     function add(uint256 a, uint256 b) internal pure returns (uint256) {
23         uint256 c = a + b;
24         require(c >= a, "SafeMath: addition overflow");
25 
26         return c;
27     }
28 
29     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
30         require(b <= a, "SafeMath: subtraction overflow");
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
48         require(b > 0, "SafeMath: division by zero");
49         uint256 c = a / b;
50         return c;
51     }
52 
53     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
54         require(b != 0, "SafeMath: modulo by zero");
55         return a % b;
56     }
57 }
58 
59 pragma solidity ^0.5.0;
60 
61 contract ERC20 is IERC20 {
62     using SafeMath for uint256;
63 
64     mapping (address => uint256) private _balances;
65 
66     mapping (address => mapping (address => uint256)) private _allowances;
67 
68     uint256 private _totalSupply;
69 
70     function totalSupply() public view returns (uint256) {
71         return _totalSupply;
72     }
73 
74     function balanceOf(address account) public view returns (uint256) {
75         return _balances[account];
76     }
77 
78     function transfer(address recipient, uint256 amount) public returns (bool) {
79         _transfer(msg.sender, recipient, amount);
80         return true;
81     }
82 
83     function allowance(address owner, address spender) public view returns (uint256) {
84         return _allowances[owner][spender];
85     }
86 
87     function approve(address spender, uint256 value) public returns (bool) {
88         _approve(msg.sender, spender, value);
89         return true;
90     }
91 
92     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
93         _transfer(sender, recipient, amount);
94         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
95         return true;
96     }
97 
98     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
99         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
100         return true;
101     }
102 
103     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
104         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
105         return true;
106     }
107 
108     function _transfer(address sender, address recipient, uint256 amount) internal {
109         require(sender != address(0), "ERC20: transfer from the zero address");
110         require(recipient != address(0), "ERC20: transfer to the zero address");
111 
112         _balances[sender] = _balances[sender].sub(amount);
113         _balances[recipient] = _balances[recipient].add(amount);
114         emit Transfer(sender, recipient, amount);
115     }
116 
117     function _mint(address account, uint256 amount) internal {
118         require(account != address(0), "ERC20: mint to the zero address");
119 
120         _totalSupply = _totalSupply.add(amount);
121         _balances[account] = _balances[account].add(amount);
122         emit Transfer(address(0), account, amount);
123     }
124 
125     function _burn(address account, uint256 value) internal {
126         require(account != address(0), "ERC20: burn from the zero address");
127 
128         _totalSupply = _totalSupply.sub(value);
129         _balances[account] = _balances[account].sub(value);
130         emit Transfer(account, address(0), value);
131     }
132 
133     function _approve(address owner, address spender, uint256 value) internal {
134         require(owner != address(0), "ERC20: approve from the zero address");
135         require(spender != address(0), "ERC20: approve to the zero address");
136 
137         _allowances[owner][spender] = value;
138         emit Approval(owner, spender, value);
139     }
140 
141     function _burnFrom(address account, uint256 amount) internal {
142         _burn(account, amount);
143         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
144     }
145 }
146 
147 pragma solidity ^0.5.0;
148 
149 contract Whistler is ERC20 {
150 
151     string private _name;
152     string private _symbol;
153     uint8 private _decimals;
154 
155     constructor(string memory name, string memory symbol, uint8 decimals, uint256 totalSupply, address payable feeReceiver, address tokenOwnerAddress) public payable {
156       _name = name;
157       _symbol = symbol;
158       _decimals = decimals;
159 
160       _mint(tokenOwnerAddress, totalSupply);
161 
162       feeReceiver.transfer(msg.value);
163     }
164 
165     function burn(uint256 value) public {
166       _burn(msg.sender, value);
167     }
168 
169     function name() public view returns (string memory) {
170       return _name;
171     }
172 
173 
174     function symbol() public view returns (string memory) {
175       return _symbol;
176     }
177 
178     function decimals() public view returns (uint8) {
179       return _decimals;
180     }
181 }