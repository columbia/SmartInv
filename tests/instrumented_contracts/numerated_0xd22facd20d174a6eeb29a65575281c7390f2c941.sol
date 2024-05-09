1 /*
2 
3 https://www.bic-token.tech
4 
5 */
6 pragma solidity ^0.5.0;
7 
8 interface IERC20 {
9 
10     function totalSupply() external view returns (uint256);
11 
12     function balanceOf(address account) external view returns (uint256);
13 
14     function transfer(address recipient, uint256 amount) external returns (bool);
15 
16     function allowance(address owner, address spender) external view returns (uint256);
17 
18     function approve(address spender, uint256 amount) external returns (bool);
19 
20     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
21 
22     event Transfer(address indexed from, address indexed to, uint256 value);
23 
24     event Approval(address indexed owner, address indexed spender, uint256 value);
25 }
26 
27 pragma solidity ^0.5.0;
28 
29 library SafeMath {
30 
31     function add(uint256 a, uint256 b) internal pure returns (uint256) {
32         uint256 c = a + b;
33         require(c >= a, "SafeMath: addition overflow");
34 
35         return c;
36     }
37 
38     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39         require(b <= a, "SafeMath: subtraction overflow");
40         uint256 c = a - b;
41 
42         return c;
43     }
44 
45     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
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
57         require(b > 0, "SafeMath: division by zero");
58         uint256 c = a / b;
59 
60         return c;
61     }
62 
63     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
64         require(b != 0, "SafeMath: modulo by zero");
65         return a % b;
66     }
67 }
68 
69 
70 pragma solidity ^0.5.0;
71 
72 
73 contract ERC20 is IERC20 {
74     using SafeMath for uint256;
75 
76     mapping (address => uint256) private _balances;
77 
78     mapping (address => mapping (address => uint256)) private _allowances;
79 
80     uint256 private _totalSupply;
81 
82     function totalSupply() public view returns (uint256) {
83         return _totalSupply;
84     }
85 
86     function balanceOf(address account) public view returns (uint256) {
87         return _balances[account];
88     }
89 
90     function transfer(address recipient, uint256 amount) public returns (bool) {
91         _transfer(msg.sender, recipient, amount);
92         return true;
93     }
94 
95     function allowance(address owner, address spender) public view returns (uint256) {
96         return _allowances[owner][spender];
97     }
98 
99     function approve(address spender, uint256 value) public returns (bool) {
100         _approve(msg.sender, spender, value);
101         return true;
102     }
103 
104     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
105         _transfer(sender, recipient, amount);
106         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
107         return true;
108     }
109 
110     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
111         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
112         return true;
113     }
114 
115     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
116         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
117         return true;
118     }
119 
120     function _transfer(address sender, address recipient, uint256 amount) internal {
121         require(sender != address(0), "ERC20: transfer from the zero address");
122         require(recipient != address(0), "ERC20: transfer to the zero address");
123 
124         _balances[sender] = _balances[sender].sub(amount);
125         _balances[recipient] = _balances[recipient].add(amount);
126         emit Transfer(sender, recipient, amount);
127     }
128 
129     function _mint(address account, uint256 amount) internal {
130         require(account != address(0), "ERC20: mint to the zero address");
131 
132         _totalSupply = _totalSupply.add(amount);
133         _balances[account] = _balances[account].add(amount);
134         emit Transfer(address(0), account, amount);
135     }
136 
137     function _burn(address account, uint256 value) internal {
138         require(account != address(0), "ERC20: burn from the zero address");
139 
140         _totalSupply = _totalSupply.sub(value);
141         _balances[account] = _balances[account].sub(value);
142         emit Transfer(account, address(0), value);
143     }
144 
145     function _approve(address owner, address spender, uint256 value) internal {
146         require(owner != address(0), "ERC20: approve from the zero address");
147         require(spender != address(0), "ERC20: approve to the zero address");
148 
149         _allowances[owner][spender] = value;
150         emit Approval(owner, spender, value);
151     }
152 
153     function _burnFrom(address account, uint256 amount) internal {
154         _burn(account, amount);
155         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
156     }
157 }
158 
159 pragma solidity ^0.5.0;
160 
161 contract Bic is ERC20 {
162 
163     string private _name;
164     string private _symbol;
165     uint8 private _decimals;
166 
167     constructor(string memory name, string memory symbol, uint8 decimals, uint256 totalSupply, address payable feeReceiver, address tokenOwnerAddress) public payable {
168       _name = name;
169       _symbol = symbol;
170       _decimals = decimals;
171 
172       _mint(tokenOwnerAddress, totalSupply);
173 
174       feeReceiver.transfer(msg.value);
175     }
176 
177     function burn(uint256 value) public {
178       _burn(msg.sender, value);
179     }
180 
181     function name() public view returns (string memory) {
182       return _name;
183     }
184 
185     function symbol() public view returns (string memory) {
186       return _symbol;
187     }
188 
189     function decimals() public view returns (uint8) {
190       return _decimals;
191     }
192 }