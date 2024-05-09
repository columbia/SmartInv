1 pragma solidity ^0.5.0;
2 
3 library SafeMath {
4     function add(uint256 a, uint256 b) internal pure returns (uint256) {
5         uint256 c = a + b;
6         require(c >= a, "SafeMath: addition overflow");
7 
8         return c;
9     }
10     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
11         require(b <= a, "SafeMath: subtraction overflow");
12         uint256 c = a - b;
13 
14         return c;
15     }
16 
17     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
18         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
19         // benefit is lost if 'b' is also tested.
20         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
21         if (a == 0) {
22             return 0;
23         }
24 
25         uint256 c = a * b;
26         require(c / a == b, "SafeMath: multiplication overflow");
27 
28         return c;
29     }
30 
31     function div(uint256 a, uint256 b) internal pure returns (uint256) {
32         // Solidity only automatically asserts when dividing by 0
33         require(b > 0, "SafeMath: division by zero");
34         uint256 c = a / b;
35         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
36 
37         return c;
38     }
39 
40     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
41         require(b != 0, "SafeMath: modulo by zero");
42         return a % b;
43     }
44 }
45 
46 
47 interface IERC20 {
48     function totalSupply() external view returns (uint256);
49 
50     function balanceOf(address account) external view returns (uint256);
51 
52     function transfer(address recipient, uint256 amount) external returns (bool);
53 
54     function allowance(address owner, address spender) external view returns (uint256);
55 
56     function approve(address spender, uint256 amount) external returns (bool);
57 
58     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
59 
60     event Transfer(address indexed from, address indexed to, uint256 value);
61 
62     event Approval(address indexed owner, address indexed spender, uint256 value);
63 }
64 
65 
66 contract ERC20 is IERC20 {
67     using SafeMath for uint256;
68 
69     mapping (address => uint256) private _balances;
70 
71     mapping (address => mapping (address => uint256)) private _allowances;
72 
73     uint256 private _totalSupply;
74 
75     function totalSupply() public view returns (uint256) {
76         return _totalSupply;
77     }
78 
79     function balanceOf(address account) public view returns (uint256) {
80         return _balances[account];
81     }
82 
83     function transfer(address recipient, uint256 amount) public returns (bool) {
84         _transfer(msg.sender, recipient, amount);
85         return true;
86     }
87 
88     function allowance(address owner, address spender) public view returns (uint256) {
89         return _allowances[owner][spender];
90     }
91 
92     function approve(address spender, uint256 value) public returns (bool) {
93         _approve(msg.sender, spender, value);
94         return true;
95     }
96 
97     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
98         _transfer(sender, recipient, amount);
99         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
100         return true;
101     }
102 
103     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
104         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
105         return true;
106     }
107 
108     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
109         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
110         return true;
111     }
112 
113     function _transfer(address sender, address recipient, uint256 amount) internal {
114         require(sender != address(0), "ERC20: transfer from the zero address");
115         require(recipient != address(0), "ERC20: transfer to the zero address");
116 
117         _balances[sender] = _balances[sender].sub(amount);
118         _balances[recipient] = _balances[recipient].add(amount);
119         emit Transfer(sender, recipient, amount);
120     }
121 
122     function _mint(address account, uint256 amount) internal {
123         require(account != address(0), "ERC20: mint to the zero address");
124 
125         _totalSupply = _totalSupply.add(amount);
126         _balances[account] = _balances[account].add(amount);
127         emit Transfer(address(0), account, amount);
128     }
129 
130     function _burn(address account, uint256 value) internal {
131         require(account != address(0), "ERC20: burn from the zero address");
132 
133         _totalSupply = _totalSupply.sub(value);
134         _balances[account] = _balances[account].sub(value);
135         emit Transfer(account, address(0), value);
136     }
137 
138     function _approve(address owner, address spender, uint256 value) internal {
139         require(owner != address(0), "ERC20: approve from the zero address");
140         require(spender != address(0), "ERC20: approve to the zero address");
141 
142         _allowances[owner][spender] = value;
143         emit Approval(owner, spender, value);
144     }
145     function _burnFrom(address account, uint256 amount) internal {
146         _burn(account, amount);
147         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
148     }
149 }
150 
151 
152 library Roles {
153     struct Role {
154         mapping (address => bool) bearer;
155     }
156 
157     function add(Role storage role, address account) internal {
158         require(!has(role, account), "Roles: account already has role");
159         role.bearer[account] = true;
160     }
161 
162     function remove(Role storage role, address account) internal {
163         require(has(role, account), "Roles: account does not have role");
164         role.bearer[account] = false;
165     }
166 
167     function has(Role storage role, address account) internal view returns (bool) {
168         require(account != address(0), "Roles: account is the zero address");
169         return role.bearer[account];
170     }
171 }
172 
173 
174 
175 
176 contract MinterRole {
177     using Roles for Roles.Role;
178 
179     event MinterAdded(address indexed account);
180     event MinterRemoved(address indexed account);
181 
182     Roles.Role private _minters;
183 
184     constructor () internal {
185         _addMinter(msg.sender);
186     }
187 
188     modifier onlyMinter() {
189         require(isMinter(msg.sender), "MinterRole: caller does not have the Minter role");
190         _;
191     }
192 
193     function isMinter(address account) public view returns (bool) {
194         return _minters.has(account);
195     }
196 
197     function addMinter(address account) public onlyMinter {
198         _addMinter(account);
199     }
200 
201     function renounceMinter() public {
202         _removeMinter(msg.sender);
203     }
204 
205     function _addMinter(address account) internal {
206         _minters.add(account);
207         emit MinterAdded(account);
208     }
209 
210     function _removeMinter(address account) internal {
211         _minters.remove(account);
212         emit MinterRemoved(account);
213     }
214 }
215 
216 contract ERC20Mintable is ERC20, MinterRole {
217     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
218         _mint(account, amount);
219         return true;
220     }
221 }
222 
223 contract ERC20Burnable is ERC20 {
224 
225     function burn(uint256 amount) public {
226         _burn(msg.sender, amount);
227     }
228 
229     function burnFrom(address account, uint256 amount) public {
230         _burnFrom(account, amount);
231     }
232 }
233 
234 
235 // NOTICE: change this name
236 contract CabGoldToken is ERC20Mintable, ERC20Burnable {
237   using SafeMath for uint256;
238 
239   string public name = "CAB Gold Token";
240   string public symbol = "CG";
241   uint8 public decimals = 18;
242   bool public active = false;
243 }