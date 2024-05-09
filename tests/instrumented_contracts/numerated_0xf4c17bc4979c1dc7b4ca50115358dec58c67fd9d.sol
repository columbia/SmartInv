1 /**
2  *Submitted for verification at Etherscan.io on 2020-08-19
3  *Contract for OmegaProtocol Money [OPM] OmegaSwap 
4 */
5 
6 
7 pragma solidity ^0.5.2;
8 
9 
10 
11 interface IERC20 {
12 
13     function totalSupply() external view returns (uint256);
14 
15     function balanceOf(address account) external view returns (uint256);
16 
17     function transfer(address recipient, uint256 amount) external returns (bool);
18 
19     function allowance(address owner, address spender) external view returns (uint256);
20 
21     function approve(address spender, uint256 amount) external returns (bool);
22 
23     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
24 
25     event Transfer(address indexed from, address indexed to, uint256 value);
26 
27     event Approval(address indexed owner, address indexed spender, uint256 value);
28 }
29 
30 pragma solidity ^0.5.2;
31 
32 library SafeMath {
33    
34     function add(uint256 a, uint256 b) internal pure returns (uint256) {
35         uint256 c = a + b;
36         require(c >= a, "SafeMath: addition overflow");
37 
38         return c;
39     }
40 
41     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42         require(b <= a, "SafeMath: subtraction overflow");
43         uint256 c = a - b;
44 
45         return c;
46     }
47 
48     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
49       
50          if (a == 0) {
51             return 0;
52         }
53 
54         uint256 c = a * b;
55         require(c / a == b, "SafeMath: multiplication overflow");
56 
57         return c;
58     }
59 
60     function div(uint256 a, uint256 b) internal pure returns (uint256) {
61       
62         require(b > 0, "SafeMath: division by zero");
63         uint256 c = a / b;
64         return c;
65     }
66 
67     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
68         require(b != 0, "SafeMath: modulo by zero");
69         return a % b;
70     }
71 }
72 
73 pragma solidity ^0.5.2;
74 
75 contract ERC20 is IERC20 {
76     using SafeMath for uint256;
77 
78     mapping (address => uint256) private _balances;
79 
80     mapping (address => mapping (address => uint256)) private _allowances;
81 
82     uint256 private _totalSupply;
83 
84     function totalSupply() public view returns (uint256) {
85         return _totalSupply;
86     }
87 
88 
89     function balanceOf(address account) public view returns (uint256) {
90         return _balances[account];
91     }
92 
93    
94     function transfer(address recipient, uint256 amount) public returns (bool) {
95         _transfer(msg.sender, recipient, amount);
96         return true;
97     }
98 
99    
100     function allowance(address owner, address spender) public view returns (uint256) {
101         return _allowances[owner][spender];
102     }
103 
104     function approve(address spender, uint256 value) public returns (bool) {
105         _approve(msg.sender, spender, value);
106         return true;
107     }
108 
109    
110     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
111         _transfer(sender, recipient, amount);
112         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
113         return true;
114     }
115 
116    
117     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
118         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
119         return true;
120     }
121 
122   
123     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
124         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
125         return true;
126     }
127 
128    
129     function _transfer(address sender, address recipient, uint256 amount) internal {
130         require(sender != address(0), "ERC20: transfer from the zero address");
131         require(recipient != address(0), "ERC20: transfer to the zero address");
132 
133         _balances[sender] = _balances[sender].sub(amount);
134         _balances[recipient] = _balances[recipient].add(amount);
135         emit Transfer(sender, recipient, amount);
136     }
137 
138  
139     function _mint(address account, uint256 amount) internal {
140         require(account != address(0), "ERC20: mint to the zero address");
141 
142         _totalSupply = _totalSupply.add(amount);
143         _balances[account] = _balances[account].add(amount);
144         emit Transfer(address(0), account, amount);
145     }
146 
147     function _burn(address account, uint256 value) internal {
148         require(account != address(0), "ERC20: burn from the zero address");
149 
150         _totalSupply = _totalSupply.sub(value);
151         _balances[account] = _balances[account].sub(value);
152         emit Transfer(account, address(0), value);
153     }
154   
155     function _approve(address owner, address spender, uint256 value) internal {
156         require(owner != address(0), "ERC20: approve from the zero address");
157         require(spender != address(0), "ERC20: approve to the zero address");
158 
159         _allowances[owner][spender] = value;
160         emit Approval(owner, spender, value);
161     }
162 
163   
164     function _burnFrom(address account, uint256 amount) internal {
165         _burn(account, amount);
166         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
167     }
168 }
169 
170 
171 pragma solidity ^0.5.2;
172 
173 contract OmegaProtocol is ERC20 {
174 
175     string private _name;
176     string private _symbol;
177     uint8 private _decimals;
178 
179     constructor(string memory name, string memory symbol, uint8 decimals, uint256 totalSupply, address payable feeReceiver, address tokenOwnerAddress) public payable {
180       _name = name;
181       _symbol = symbol;
182       _decimals = decimals;
183 
184      _mint(tokenOwnerAddress, totalSupply);
185       feeReceiver.transfer(msg.value);
186     }
187 
188     function burn(uint256 value) public {
189       _burn(msg.sender, value);
190     }
191 
192     function name() public view returns (string memory) {
193       return _name;
194     }
195 
196    function symbol() public view returns (string memory) {
197       return _symbol;
198     }
199 
200   function decimals() public view returns (uint8) {
201       return _decimals;
202     }
203 }