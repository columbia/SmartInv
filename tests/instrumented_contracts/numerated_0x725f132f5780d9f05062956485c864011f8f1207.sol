1 pragma solidity 0.5.15;
2 
3 library SafeMath {
4     function add(uint256 a, uint256 b) internal pure returns (uint256) {
5         uint256 c = a + b;
6         require(c >= a, "SafeMath: addition overflow");
7 
8         return c;
9     }
10 
11     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
12         require(b <= a, "SafeMath: subtraction overflow");
13         uint256 c = a - b;
14 
15         return c;
16     }
17 
18     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
19         if (a == 0) {
20             return 0;
21         }
22 
23         uint256 c = a * b;
24         require(c / a == b, "SafeMath: multiplication overflow");
25 
26         return c;
27     }
28 
29     function div(uint256 a, uint256 b) internal pure returns (uint256) {
30         require(b > 0, "SafeMath: division by zero");
31         uint256 c = a / b;
32 
33         return c;
34     }
35 
36     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
37         require(b != 0, "SafeMath: modulo by zero");
38         return a % b;
39     }
40 }
41 
42 interface IERC20 {
43     function totalSupply() external view returns (uint256);
44 
45     function balanceOf(address account) external view returns (uint256);
46 
47     function transfer(address recipient, uint256 amount) external returns (bool);
48 
49     function allowance(address owner, address spender) external view returns (uint256);
50 
51     function approve(address spender, uint256 amount) external returns (bool);
52 
53     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
54 
55     event Transfer(address indexed from, address indexed to, uint256 value);
56 
57     event Approval(address indexed owner, address indexed spender, uint256 value);
58 }
59 
60 contract ERC20 is IERC20 {
61     using SafeMath for uint256;
62 
63     mapping (address => uint256) private _balances;
64 
65     mapping (address => mapping (address => uint256)) private _allowances;
66 
67     uint256 private _totalSupply;
68 
69     function totalSupply() public view returns (uint256) {
70         return _totalSupply;
71     }
72 
73     function balanceOf(address account) public view returns (uint256) {
74         return _balances[account];
75     }
76 
77     function transfer(address recipient, uint256 amount) public returns (bool) {
78         _transfer(msg.sender, recipient, amount);
79         return true;
80     }
81 
82     function allowance(address owner, address spender) public view returns (uint256) {
83         return _allowances[owner][spender];
84     }
85 
86     function approve(address spender, uint256 value) public returns (bool) {
87         _approve(msg.sender, spender, value);
88         return true;
89     }
90 
91     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
92         _transfer(sender, recipient, amount);
93         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
94         return true;
95     }
96 
97     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
98         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
99         return true;
100     }
101 
102     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
103         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
104         return true;
105     }
106 
107     function _transfer(address sender, address recipient, uint256 amount) internal {
108         require(sender != address(0), "ERC20: transfer from the zero address");
109         require(recipient != address(0), "ERC20: transfer to the zero address");
110 
111         _balances[sender] = _balances[sender].sub(amount);
112         _balances[recipient] = _balances[recipient].add(amount);
113         emit Transfer(sender, recipient, amount);
114     }
115 
116     function _mint(address account, uint256 amount) internal {
117         require(account != address(0), "ERC20: mint to the zero address");
118 
119         _totalSupply = _totalSupply.add(amount);
120         _balances[account] = _balances[account].add(amount);
121         emit Transfer(address(0), account, amount);
122     }
123 
124     function _burn(address account, uint256 value) internal {
125         require(account != address(0), "ERC20: burn from the zero address");
126 
127         _totalSupply = _totalSupply.sub(value);
128         _balances[account] = _balances[account].sub(value);
129         emit Transfer(account, address(0), value);
130     }
131 
132     function _approve(address owner, address spender, uint256 value) internal {
133         require(owner != address(0), "ERC20: approve from the zero address");
134         require(spender != address(0), "ERC20: approve to the zero address");
135 
136         _allowances[owner][spender] = value;
137         emit Approval(owner, spender, value);
138     }
139 
140     function _burnFrom(address account, uint256 amount) internal {
141         _burn(account, amount);
142         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
143     }
144 }
145 
146 contract ERC20Burnable is ERC20 {
147 
148     function burn(uint256 amount) public {
149         _burn(msg.sender, amount);
150     }
151 
152     function burnFrom(address account, uint256 amount) public {
153         _burnFrom(account, amount);
154     }
155 }
156 
157 contract ERC20Detailed is IERC20 {
158     string private _name;
159     string private _symbol;
160     uint8 private _decimals;
161 
162     constructor (string memory name, string memory symbol, uint8 decimals) public {
163         _name = name;
164         _symbol = symbol;
165         _decimals = decimals;
166     }
167 
168     function name() public view returns (string memory) {
169         return _name;
170     }
171 
172     function symbol() public view returns (string memory) {
173         return _symbol;
174     }
175 
176     function decimals() public view returns (uint8) {
177         return _decimals;
178     }
179 }
180 
181 library Roles {
182     struct Role {
183         mapping (address => bool) bearer;
184     }
185 
186     function add(Role storage role, address account) internal {
187         require(!has(role, account), "Roles: account already has role");
188         role.bearer[account] = true;
189     }
190 
191     function remove(Role storage role, address account) internal {
192         require(has(role, account), "Roles: account does not have role");
193         role.bearer[account] = false;
194     }
195 
196     function has(Role storage role, address account) internal view returns (bool) {
197         require(account != address(0), "Roles: account is the zero address");
198         return role.bearer[account];
199     }
200 }
201 
202 contract PauserRole {
203     using Roles for Roles.Role;
204 
205     event PauserAdded(address indexed account);
206     event PauserRemoved(address indexed account);
207 
208     Roles.Role private _pausers;
209 
210     constructor () internal {
211         _addPauser(msg.sender);
212     }
213 
214     modifier onlyPauser() {
215         require(isPauser(msg.sender), "PauserRole: caller does not have the Pauser role");
216         _;
217     }
218 
219     function isPauser(address account) public view returns (bool) {
220         return _pausers.has(account);
221     }
222 
223     function addPauser(address account) public onlyPauser {
224         _addPauser(account);
225     }
226 
227     function renouncePauser() public {
228         _removePauser(msg.sender);
229     }
230 
231     function _addPauser(address account) internal {
232         _pausers.add(account);
233         emit PauserAdded(account);
234     }
235 
236     function _removePauser(address account) internal {
237         _pausers.remove(account);
238         emit PauserRemoved(account);
239     }
240 }
241 
242 contract Pausable is PauserRole {
243     event Paused(address account);
244 
245     event Unpaused(address account);
246 
247     bool private _paused;
248 
249     constructor () internal {
250         _paused = false;
251     }
252 
253     function paused() public view returns (bool) {
254         return _paused;
255     }
256 
257     modifier whenNotPaused() {
258         require(!_paused, "Pausable: paused");
259         _;
260     }
261 
262     modifier whenPaused() {
263         require(_paused, "Pausable: not paused");
264         _;
265     }
266 
267     function pause() public onlyPauser whenNotPaused {
268         _paused = true;
269         emit Paused(msg.sender);
270     }
271 
272     function unpause() public onlyPauser whenPaused {
273         _paused = false;
274         emit Unpaused(msg.sender);
275     }
276 }
277 
278 contract ERC20Pausable is ERC20, Pausable {
279     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
280         return super.transfer(to, value);
281     }
282 
283     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
284         return super.transferFrom(from, to, value);
285     }
286 
287     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
288         return super.approve(spender, value);
289     }
290 
291     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool) {
292         return super.increaseAllowance(spender, addedValue);
293     }
294 
295     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool) {
296         return super.decreaseAllowance(spender, subtractedValue);
297     }
298 }
299 
300 contract SKS is ERC20Burnable, ERC20Pausable, ERC20Detailed {
301     constructor () public ERC20Detailed("SKEYES", "SKS", 6) {
302         _mint(msg.sender, 210000000 * (10 ** uint256(decimals())));
303     }
304 }