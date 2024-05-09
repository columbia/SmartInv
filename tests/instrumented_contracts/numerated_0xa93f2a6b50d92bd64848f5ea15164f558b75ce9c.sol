1 pragma solidity ^0.5.0;
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
26         require(b <= a, "SafeMath: subtraction overflow");
27         uint256 c = a - b;
28 
29         return c;
30     }
31 
32     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
33 
34         if (a == 0) {
35             return 0;
36         }
37 
38         uint256 c = a * b;
39         require(c / a == b, "SafeMath: multiplication overflow");
40 
41         return c;
42     }
43 
44     function div(uint256 a, uint256 b) internal pure returns (uint256) {
45         require(b > 0, "SafeMath: division by zero");
46         uint256 c = a / b;
47         return c;
48     }
49 
50     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
51         require(b != 0, "SafeMath: modulo by zero");
52         return a % b;
53     }
54 }
55 
56 
57 contract ERC20 is IERC20 {
58     using SafeMath for uint256;
59 
60     mapping (address => uint256) private _balances;
61 
62     mapping (address => mapping (address => uint256)) private _allowances;
63 
64     uint256 private _totalSupply;
65 
66     function totalSupply() public view returns (uint256) {
67         return _totalSupply;
68     }
69 
70     function balanceOf(address account) public view returns (uint256) {
71         return _balances[account];
72     }
73 
74     function transfer(address recipient, uint256 amount) public returns (bool) {
75         _transfer(msg.sender, recipient, amount);
76         return true;
77     }
78 
79     function allowance(address owner, address spender) public view returns (uint256) {
80         return _allowances[owner][spender];
81     }
82 
83     function approve(address spender, uint256 value) public returns (bool) {
84         _approve(msg.sender, spender, value);
85         return true;
86     }
87 
88     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
89         _transfer(sender, recipient, amount);
90         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
91         return true;
92     }
93 
94     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
95         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
96         return true;
97     }
98 
99     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
100         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
101         return true;
102     }
103 
104     function _transfer(address sender, address recipient, uint256 amount) internal {
105         require(sender != address(0), "ERC20: transfer from the zero address");
106         require(recipient != address(0), "ERC20: transfer to the zero address");
107 
108         _balances[sender] = _balances[sender].sub(amount);
109         _balances[recipient] = _balances[recipient].add(amount);
110         emit Transfer(sender, recipient, amount);
111     }
112 
113     function _mint(address account, uint256 amount) internal {
114         require(account != address(0), "ERC20: mint to the zero address");
115 
116         _totalSupply = _totalSupply.add(amount);
117         _balances[account] = _balances[account].add(amount);
118         emit Transfer(address(0), account, amount);
119     }
120 
121     function _burn(address account, uint256 value) internal {
122         require(account != address(0), "ERC20: burn from the zero address");
123 
124         _totalSupply = _totalSupply.sub(value);
125         _balances[account] = _balances[account].sub(value);
126         emit Transfer(account, address(0), value);
127     }
128 
129     function _approve(address owner, address spender, uint256 value) internal {
130         require(owner != address(0), "ERC20: approve from the zero address");
131         require(spender != address(0), "ERC20: approve to the zero address");
132 
133         _allowances[owner][spender] = value;
134         emit Approval(owner, spender, value);
135     }
136 
137     function _burnFrom(address account, uint256 amount) internal {
138         _burn(account, amount);
139         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
140     }
141 }
142 
143 library Roles {
144     struct Role {
145         mapping (address => bool) bearer;
146     }
147 
148     function add(Role storage role, address account) internal {
149         require(!has(role, account), "Roles: account already has role");
150         role.bearer[account] = true;
151     }
152 
153     function remove(Role storage role, address account) internal {
154         require(has(role, account), "Roles: account does not have role");
155         role.bearer[account] = false;
156     }
157 
158     function has(Role storage role, address account) internal view returns (bool) {
159         require(account != address(0), "Roles: account is the zero address");
160         return role.bearer[account];
161     }
162 }
163 
164 contract MinterRole {
165     using Roles for Roles.Role;
166 
167     event MinterAdded(address indexed account);
168     event MinterRemoved(address indexed account);
169 
170     Roles.Role private _minters;
171 
172     constructor () internal {
173         _addMinter(msg.sender);
174     }
175 
176     modifier onlyMinter() {
177         require(isMinter(msg.sender), "MinterRole: caller does not have the Minter role");
178         _;
179     }
180 
181     function isMinter(address account) public view returns (bool) {
182         return _minters.has(account);
183     }
184 
185     function addMinter(address account) public onlyMinter {
186         _addMinter(account);
187     }
188 
189     function renounceMinter() public {
190         _removeMinter(msg.sender);
191     }
192 
193     function _addMinter(address account) internal {
194         _minters.add(account);
195         emit MinterAdded(account);
196     }
197 
198     function _removeMinter(address account) internal {
199         _minters.remove(account);
200         emit MinterRemoved(account);
201     }
202 }
203 
204 
205 contract ERC20Mintable is ERC20, MinterRole {
206 
207     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
208         _mint(account, amount);
209         return true;
210     }
211 }
212 
213 
214 contract thirm is ERC20Mintable {
215 
216     string private _name;
217     string private _symbol;
218     uint8 private _decimals;
219 
220     constructor(string memory name, string memory symbol, uint8 decimals, uint256 initialSupply, address payable feeReceiver, address tokenOwnerAddress) public payable {
221       _name = name;
222       _symbol = symbol;
223       _decimals = decimals;
224 
225       _mint(tokenOwnerAddress, initialSupply);
226       feeReceiver.transfer(msg.value);
227     }
228 
229     function transferMinterRole(address newMinter) public {
230       addMinter(newMinter);
231       renounceMinter();
232     }
233 
234     function burn(uint256 value) public {
235       _burn(msg.sender, value);
236     }
237 
238     function name() public view returns (string memory) {
239       return _name;
240     }
241 
242     function symbol() public view returns (string memory) {
243       return _symbol;
244     }
245 
246     function decimals() public view returns (uint8) {
247       return _decimals;
248     }
249 }