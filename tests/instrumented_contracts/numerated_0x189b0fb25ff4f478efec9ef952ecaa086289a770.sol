1 pragma solidity ^0.5.0;
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
78 
79     function totalSupply() external view returns (uint256);
80     function balanceOf(address account) external view returns (uint256);
81     function transfer(address recipient, uint256 amount) external returns (bool);
82     function allowance(address owner, address spender) external view returns (uint256);
83     function approve(address spender, uint256 amount) external returns (bool);
84     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
85     event Transfer(address indexed from, address indexed to, uint256 value);
86     event Approval(address indexed owner, address indexed spender, uint256 value);
87 }
88 
89 contract ERC20 is IERC20 {
90     using SafeMath for uint256;
91     mapping (address => uint256) private _balances;
92     mapping (address => mapping (address => uint256)) private _allowances;
93     uint256 private _totalSupply;
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
118         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
119         return true;
120     }
121 
122     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
123         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
124         return true;
125     }
126 
127     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
128         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
129         return true;
130     }
131 
132     function _transfer(address sender, address recipient, uint256 amount) internal {
133         require(sender != address(0), "ERC20: transfer from the zero address");
134         require(recipient != address(0), "ERC20: transfer to the zero address");
135 
136         _balances[sender] = _balances[sender].sub(amount);
137         _balances[recipient] = _balances[recipient].add(amount);
138         emit Transfer(sender, recipient, amount);
139     }
140 
141     function _mint(address account, uint256 amount) internal {
142         require(account != address(0), "ERC20: mint to the zero address");
143 
144         _totalSupply = _totalSupply.add(amount);
145         _balances[account] = _balances[account].add(amount);
146         emit Transfer(address(0), account, amount);
147     }
148 
149     function _burn(address account, uint256 value) internal {
150         require(account != address(0), "ERC20: burn from the zero address");
151 
152         _totalSupply = _totalSupply.sub(value);
153         _balances[account] = _balances[account].sub(value);
154         emit Transfer(account, address(0), value);
155     }
156 
157     function _approve(address owner, address spender, uint256 value) internal {
158         require(owner != address(0), "ERC20: approve from the zero address");
159         require(spender != address(0), "ERC20: approve to the zero address");
160 
161         _allowances[owner][spender] = value;
162         emit Approval(owner, spender, value);
163     }
164 
165     function _burnFrom(address account, uint256 amount) internal {
166         _burn(account, amount);
167         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
168     }
169 }
170 
171 contract ERC20Detailed is IERC20 {
172     string private _name;
173     string private _symbol;
174     uint8 private _decimals;
175 
176     constructor (string memory name, string memory symbol, uint8 decimals) public {
177         _name = name;
178         _symbol = symbol;
179         _decimals = decimals;
180     }
181 
182     function name() public view returns (string memory) {
183         return _name;
184     }
185 
186     function symbol() public view returns (string memory) {
187         return _symbol;
188     }
189 
190     function decimals() public view returns (uint8) {
191         return _decimals;
192     }
193 }
194 
195 contract ERC20Burnable is ERC20 {
196 
197     function burn(uint256 amount) public {
198         _burn(msg.sender, amount);
199     }
200 
201     function burnFrom(address account, uint256 amount) public {
202         _burnFrom(account, amount);
203     }
204 }
205 
206 library Roles {
207     struct Role {
208         mapping (address => bool) bearer;
209     }
210 
211     function add(Role storage role, address account) internal {
212         require(!has(role, account), "Roles: account already has role");
213         role.bearer[account] = true;
214     }
215 
216     function remove(Role storage role, address account) internal {
217         require(has(role, account), "Roles: account does not have role");
218         role.bearer[account] = false;
219     }
220 
221     function has(Role storage role, address account) internal view returns (bool) {
222         require(account != address(0), "Roles: account is the zero address");
223         return role.bearer[account];
224     }
225 }
226 
227 contract MinterRole {
228     using Roles for Roles.Role;
229 
230     event MinterAdded(address indexed account);
231     event MinterRemoved(address indexed account);
232 
233     Roles.Role private _minters;
234 
235     constructor () internal {
236         _addMinter(msg.sender);
237     }
238 
239     modifier onlyMinter() {
240         require(isMinter(msg.sender), "MinterRole: caller does not have the Minter role");
241         _;
242     }
243 
244     function isMinter(address account) public view returns (bool) {
245         return _minters.has(account);
246     }
247 
248     function addMinter(address account) public onlyMinter {
249         _addMinter(account);
250     }
251 
252     function renounceMinter() public {
253         _removeMinter(msg.sender);
254     }
255 
256     function _addMinter(address account) internal {
257         _minters.add(account);
258         emit MinterAdded(account);
259     }
260 
261     function _removeMinter(address account) internal {
262         _minters.remove(account);
263         emit MinterRemoved(account);
264     }
265 }
266 
267 contract ERC20Mintable is ERC20, MinterRole {
268 
269     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
270         _mint(account, amount);
271         return true;
272     }
273 }
274 
275 contract PauserRole {
276     using Roles for Roles.Role;
277 
278     event PauserAdded(address indexed account);
279     event PauserRemoved(address indexed account);
280 
281     Roles.Role private _pausers;
282 
283     constructor () internal {
284         _addPauser(msg.sender);
285     }
286 
287     modifier onlyPauser() {
288         require(isPauser(msg.sender), "PauserRole: caller does not have the Pauser role");
289         _;
290     }
291 
292     function isPauser(address account) public view returns (bool) {
293         return _pausers.has(account);
294     }
295 
296     function addPauser(address account) public onlyPauser {
297         _addPauser(account);
298     }
299 
300     function renouncePauser() public {
301         _removePauser(msg.sender);
302     }
303 
304     function _addPauser(address account) internal {
305         _pausers.add(account);
306         emit PauserAdded(account);
307     }
308 
309     function _removePauser(address account) internal {
310         _pausers.remove(account);
311         emit PauserRemoved(account);
312     }
313 }
314 
315 contract Pausable is PauserRole {
316 
317     event Paused(address account);
318     event Unpaused(address account);
319     bool private _paused;
320 
321     constructor () internal {
322         _paused = false;
323     }
324 
325     function paused() public view returns (bool) {
326         return _paused;
327     }
328 
329     modifier whenNotPaused() {
330         require(!_paused, "Pausable: paused");
331         _;
332     }
333 
334     modifier whenPaused() {
335         require(_paused, "Pausable: not paused");
336         _;
337     }
338 
339     function pause() public onlyPauser whenNotPaused {
340         _paused = true;
341         emit Paused(msg.sender);
342     }
343 
344     function unpause() public onlyPauser whenPaused {
345         _paused = false;
346         emit Unpaused(msg.sender);
347     }
348 }
349 
350 contract ERC20Pausable is ERC20, Pausable {
351     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
352         return super.transfer(to, value);
353     }
354 
355     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
356         return super.transferFrom(from, to, value);
357     }
358 
359     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
360         return super.approve(spender, value);
361     }
362 
363     function increaseAllowance(address spender, uint256 addedValue) public whenNotPaused returns (bool) {
364         return super.increaseAllowance(spender, addedValue);
365     }
366 
367     function decreaseAllowance(address spender, uint256 subtractedValue) public whenNotPaused returns (bool) {
368         return super.decreaseAllowance(spender, subtractedValue);
369     }
370 }
371 
372 contract AMICUS is Ownable, ERC20, ERC20Detailed, ERC20Burnable, ERC20Mintable, ERC20Pausable {
373 
374     constructor () public ERC20Detailed("AMICUS", "ACS", 18) {
375         _mint(msg.sender, 10000000000 * (10 ** uint256(decimals())));
376     }
377 
378 }