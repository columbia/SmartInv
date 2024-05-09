1 pragma solidity >=0.5.0 <0.6.0;
2 
3 library SafeMath {
4 
5     function add(uint256 a, uint256 b) internal pure returns (uint256) {
6         uint256 c = a + b;
7         require(c >= a, "SafeMath: addition overflow");
8         return c;
9     }
10 
11     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
12         require(b <= a, "SafeMath: subtraction overflow");
13         uint256 c = a - b;
14         return c;
15     }
16 
17     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
18         if (a == 0) {
19             return 0;
20         }
21         uint256 c = a * b;
22         require(c / a == b, "SafeMath: multiplication overflow");
23         return c;
24     }
25 
26     function div(uint256 a, uint256 b) internal pure returns (uint256) {
27         require(b > 0, "SafeMath: division by zero");
28         uint256 c = a / b;
29         return c;
30     }
31 
32     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
33         require(b != 0, "SafeMath: modulo by zero");
34         return a % b;
35     }
36 }
37 
38 contract Ownable {
39     address private _owner;
40 
41     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
42 
43     constructor () internal {
44         _owner = msg.sender;
45         emit OwnershipTransferred(address(0), _owner);
46     }
47 
48     function owner() public view returns (address) {
49         return _owner;
50     }
51 
52     modifier onlyOwner() {
53         require(isOwner(), "Ownable: caller is not the owner");
54         _;
55     }
56 
57     function isOwner() public view returns (bool) {
58         return msg.sender == _owner;
59     }
60 
61     function renounceOwnership() public onlyOwner {
62         emit OwnershipTransferred(_owner, address(0));
63         _owner = address(0);
64     }
65 
66     function transferOwnership(address newOwner) public onlyOwner {
67         _transferOwnership(newOwner);
68     }
69 
70     function _transferOwnership(address newOwner) internal {
71         require(newOwner != address(0), "Ownable: new owner is the zero address");
72         emit OwnershipTransferred(_owner, newOwner);
73         _owner = newOwner;
74     }
75 }
76 
77 interface IERC20 {
78     function totalSupply() external view returns (uint256);
79     function balanceOf(address account) external view returns (uint256);
80     function transfer(address recipient, uint256 amount) external returns (bool);
81     function allowance(address owner, address spender) external view returns (uint256);
82     function approve(address spender, uint256 amount) external returns (bool);
83     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
84     event Transfer(address indexed from, address indexed to, uint256 value);
85     event Approval(address indexed owner, address indexed spender, uint256 value);
86 }
87 
88 contract ERC20 is IERC20, Ownable {
89     using SafeMath for uint256;
90     mapping (address => uint256) private _balances;
91     mapping (address => mapping (address => uint256)) private _allowances;
92     uint256 private _totalSupply;
93 
94     function totalSupply() public view returns (uint256) {
95         return _totalSupply;
96     }
97 
98     function balanceOf(address account) public view returns (uint256) {
99         return _balances[account];
100     }
101 
102     function transfer(address recipient, uint256 amount) public returns (bool) {
103         _transfer(msg.sender, recipient, amount);
104         return true;
105     }
106 
107     function allowance(address owner, address spender) public view returns (uint256) {
108         return _allowances[owner][spender];
109     }
110 
111     function approve(address spender, uint256 value) public returns (bool) {
112         _approve(msg.sender, spender, value);
113         return true;
114     }
115 
116     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
117         _transfer(sender, recipient, amount);
118         _approve(sender, msg.sender,
119         _allowances[sender][msg.sender].sub(amount));
120         return true;
121     }
122 
123     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
124         _approve(msg.sender, spender,
125         _allowances[msg.sender][spender].add(addedValue));
126         return true;
127     }
128 
129     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
130         _approve(msg.sender, spender,
131         _allowances[msg.sender][spender].sub(subtractedValue));
132         return true;
133     }
134 
135     function _transfer(address sender, address recipient, uint256 amount) internal {
136         require(sender != address(0), "ERC20: transfer from the zero address");
137         require(recipient != address(0), "ERC20: transfer to the zero address");
138 
139         _balances[sender] = _balances[sender].sub(amount);
140         _balances[recipient] = _balances[recipient].add(amount);
141         emit Transfer(sender, recipient, amount);
142     }
143 
144     function _mint(address account, uint256 amount) internal {
145         require(account != address(0), "ERC20: mint to the zero address");
146         _totalSupply = _totalSupply.add(amount);
147         _balances[account] = _balances[account].add(amount);
148         emit Transfer(address(0), account, amount);
149     }
150 
151     function _burn(address account, uint256 value) internal {
152         require(account != address(0), "ERC20: burn from the zero address");
153 
154         _totalSupply = _totalSupply.sub(value);
155         _balances[account] = _balances[account].sub(value);
156         emit Transfer(account, address(0), value);
157     }
158 
159     function _approve(address owner, address spender, uint256 value) internal {
160         require(owner != address(0), "ERC20: approve from the zero address");
161         require(spender != address(0), "ERC20: approve to the zero address");
162 
163         _allowances[owner][spender] = value;
164         emit Approval(owner, spender, value);
165     }
166 
167     function _burnFrom(address account, uint256 amount) internal {
168         _burn(account, amount);
169         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
170     }
171 }
172 
173 contract ERC20Detailed is IERC20 {
174     string private _name;
175     string private _symbol;
176     uint8 private _decimals;
177 
178     constructor (string memory name, string memory symbol, uint8 decimals) public {
179         _name = name;
180         _symbol = symbol;
181         _decimals = decimals;
182     }
183 
184     function name() public view returns (string memory) {
185         return _name;
186     }
187 
188     function symbol() public view returns (string memory) {
189         return _symbol;
190     }
191 
192     function decimals() public view returns (uint8) {
193         return _decimals;
194     }
195 }
196 
197 contract ERC20Burnable is ERC20 {
198 
199     function burn(uint256 amount) public {
200         _burn(msg.sender, amount);
201     }
202 
203     function burnFrom(address account, uint256 amount) public {
204         _burnFrom(account, amount);
205     }
206 }
207 
208 library Roles {
209     struct Role {
210         mapping (address => bool) bearer;
211     }
212 
213     function add(Role storage role, address account) internal {
214         require(!has(role, account), "Roles: account already has role");
215         role.bearer[account] = true;
216     }
217 
218     function remove(Role storage role, address account) internal {
219         require(has(role, account), "Roles: account does not have role");
220         role.bearer[account] = false;
221     }
222 
223     function has(Role storage role, address account) internal view returns (bool) {
224         require(account != address(0), "Roles: account is the zero address");
225         return role.bearer[account];
226     }
227 }
228 
229 contract PauserRole {
230     using Roles for Roles.Role;
231 
232     event PauserAdded(address indexed account);
233     event PauserRemoved(address indexed account);
234 
235     Roles.Role private _pausers;
236 
237     constructor () internal {
238         _addPauser(msg.sender);
239     }
240 
241     modifier onlyPauser() {
242         require(isPauser(msg.sender), "PauserRole: caller does not have the Pauser role");
243         _;
244     }
245 
246     function isPauser(address account) public view returns (bool) {
247         return _pausers.has(account);
248     }
249 
250     function addPauser(address account) public onlyPauser {
251         _addPauser(account);
252     }
253 
254     function renouncePauser() public {
255         _removePauser(msg.sender);
256     }
257 
258     function _addPauser(address account) internal {
259         _pausers.add(account);
260         emit PauserAdded(account);
261     }
262 
263     function _removePauser(address account) internal {
264         _pausers.remove(account);
265         emit PauserRemoved(account);
266     }
267 }
268 
269 contract Pausable is PauserRole {
270 
271     event Paused(address account);
272     event Unpaused(address account);
273     bool private _paused;
274 
275     constructor () internal {
276         _paused = false;
277     }
278 
279     function paused() public view returns (bool) {
280         return _paused;
281     }
282 
283     modifier whenNotPaused() {
284         require(!_paused, "Pausable: paused");
285         _;
286     }
287 
288     modifier whenPaused() {
289         require(_paused, "Pausable: not paused");
290         _;
291     }
292 
293     function pause() public onlyPauser whenNotPaused {
294         _paused = true;
295         emit Paused(msg.sender);
296     }
297 
298     function unpause() public onlyPauser whenPaused {
299         _paused = false;
300         emit Unpaused(msg.sender);
301     }
302 }
303 
304 contract ERC20Pausable is ERC20, Pausable {
305     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
306         return super.transfer(to, value);
307     }
308 
309     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
310         return super.transferFrom(from, to, value);
311     }
312 
313     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
314         return super.approve(spender, value);
315     }
316 
317     function increaseAllowance(address spender, uint256 addedValue) public whenNotPaused returns (bool) {
318         return super.increaseAllowance(spender, addedValue);
319     }
320 
321     function decreaseAllowance(address spender, uint256 subtractedValue) public whenNotPaused returns (bool) {
322         return super.decreaseAllowance(spender, subtractedValue);
323     }
324 }
325 
326 contract ERC20Frozen is ERC20 {
327     mapping (address => bool) private frozenAccounts;
328     event FrozenFunds(address target, bool frozen);
329 
330     function freezeAccount(address target) public onlyOwner {
331         frozenAccounts[target] = true;
332         emit FrozenFunds(target, true);
333     }
334 
335     function unFreezeAccount(address target) public onlyOwner {
336         frozenAccounts[target] = false;
337         emit FrozenFunds(target, false);
338     }
339 
340     function frozen(address _target) public view returns (bool) {
341         return frozenAccounts[_target];
342     }
343 
344     modifier canTransfer(address _sender) {
345         require(!frozenAccounts[_sender], "ERC20Frozen: fronzon sender address");
346         _;
347     }
348 
349     function transfer(address _to, uint256 _value) public canTransfer(msg.sender) returns (bool success) {
350         return super.transfer(_to, _value);
351     }
352 
353     function transferFrom(address _from, address _to, uint256 _value) public canTransfer(_from) returns (bool success) {
354         return super.transferFrom(_from, _to, _value);
355     }
356 }
357 
358 contract BnxToken is ERC20, ERC20Detailed, ERC20Burnable, ERC20Pausable, ERC20Frozen {
359 
360     constructor () public ERC20Detailed("BnxToken", "BNX", 18) {
361         _mint(msg.sender, 70000000 * (10 ** uint256(decimals())));
362     }
363 }