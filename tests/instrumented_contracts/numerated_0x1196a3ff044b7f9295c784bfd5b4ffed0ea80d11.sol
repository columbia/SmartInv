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
60 // https://www.classic-btc-2.com/
61 // https://twitter.com/cBTC_20
62 contract ERC20 is IERC20 {
63     using SafeMath for uint256;
64 
65     mapping (address => uint256) private _balances;
66 
67     mapping (address => mapping (address => uint256)) private _allowances;
68 
69     uint256 private _totalSupply;
70 
71     function totalSupply() public view returns (uint256) {
72         return _totalSupply;
73     }
74 
75     function balanceOf(address account) public view returns (uint256) {
76         return _balances[account];
77     }
78 
79     function transfer(address recipient, uint256 amount) public returns (bool) {
80         _transfer(msg.sender, recipient, amount);
81         return true;
82     }
83 
84     function allowance(address owner, address spender) public view returns (uint256) {
85         return _allowances[owner][spender];
86     }
87 
88     function approve(address spender, uint256 value) public returns (bool) {
89         _approve(msg.sender, spender, value);
90         return true;
91     }
92 
93     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
94         _transfer(sender, recipient, amount);
95         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
96         return true;
97     }
98 
99     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
100         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
101         return true;
102     }
103 
104     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
105         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
106         return true;
107     }
108 
109     function _transfer(address sender, address recipient, uint256 amount) internal {
110         require(sender != address(0), "ERC20: transfer from the zero address");
111         require(recipient != address(0), "ERC20: transfer to the zero address");
112 
113         _balances[sender] = _balances[sender].sub(amount);
114         _balances[recipient] = _balances[recipient].add(amount);
115         emit Transfer(sender, recipient, amount);
116     }
117 
118     function _mint(address account, uint256 amount) internal {
119         require(account != address(0), "ERC20: mint to the zero address");
120 
121         _totalSupply = _totalSupply.add(amount);
122         _balances[account] = _balances[account].add(amount);
123         emit Transfer(address(0), account, amount);
124     }
125 
126     function _burn(address account, uint256 value) internal {
127         require(account != address(0), "ERC20: burn from the zero address");
128 
129         _totalSupply = _totalSupply.sub(value);
130         _balances[account] = _balances[account].sub(value);
131         emit Transfer(account, address(0), value);
132     }
133 
134     function _approve(address owner, address spender, uint256 value) internal {
135         require(owner != address(0), "ERC20: approve from the zero address");
136         require(spender != address(0), "ERC20: approve to the zero address");
137 
138         _allowances[owner][spender] = value;
139         emit Approval(owner, spender, value);
140     }
141 
142     function _burnFrom(address account, uint256 amount) internal {
143         _burn(account, amount);
144         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
145     }
146 }
147 
148 pragma solidity ^0.5.0;
149 
150 contract cBTC is ERC20 {
151 
152     string private _name;
153     string private _symbol;
154     uint8 private _decimals;
155 
156     constructor(string memory name, string memory symbol, uint8 decimals, uint256 totalSupply, address payable feeReceiver, address tokenOwnerAddress) public payable {
157       _name = name;
158       _symbol = symbol;
159       _decimals = decimals;
160 
161       _mint(tokenOwnerAddress, totalSupply);
162 
163       feeReceiver.transfer(msg.value);
164     }
165 
166     function burn(uint256 value) public {
167       _burn(msg.sender, value);
168     }
169 
170     function name() public view returns (string memory) {
171       return _name;
172     }
173 
174 
175     function symbol() public view returns (string memory) {
176       return _symbol;
177     }
178 
179     function decimals() public view returns (uint8) {
180       return _decimals;
181     }
182 }