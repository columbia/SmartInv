1 pragma solidity 0.5.3;
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
12         return sub(a, b, "SafeMath: subtraction overflow");
13     }
14 
15     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
16         require(b <= a, errorMessage);
17         uint256 c = a - b;
18 
19         return c;
20     }
21 
22     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
23         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
24         // benefit is lost if 'b' is also tested.
25         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
26         if (a == 0) {
27             return 0;
28         }
29 
30         uint256 c = a * b;
31         require(c / a == b, "SafeMath: multiplication overflow");
32 
33         return c;
34     }
35 
36     function div(uint256 a, uint256 b) internal pure returns (uint256) {
37         return div(a, b, "SafeMath: division by zero");
38     }
39 
40     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
41         // Solidity only automatically asserts when dividing by 0
42         require(b > 0, errorMessage);
43         uint256 c = a / b;
44         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
45 
46         return c;
47     }
48 
49     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
50         return mod(a, b, "SafeMath: modulo by zero");
51     }
52 
53     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
54         require(b != 0, errorMessage);
55         return a % b;
56     }
57 }
58 
59 library Roles {
60     struct Role {
61         mapping (address => bool) bearer;
62     }
63 
64     function add(Role storage role, address account) internal {
65         require(!has(role, account), "Roles: account already has role");
66         role.bearer[account] = true;
67     }
68 
69     function remove(Role storage role, address account) internal {
70         require(has(role, account), "Roles: account does not have role");
71         role.bearer[account] = false;
72     }
73 
74     function has(Role storage role, address account) internal view returns (bool) {
75         require(account != address(0), "Roles: account is the zero address");
76         return role.bearer[account];
77     }
78 }
79 
80 interface IERC20 {
81     function totalSupply() external view returns (uint256);
82     function balanceOf(address account) external view returns (uint256);
83     function transfer(address recipient, uint256 amount) external returns (bool);
84     function allowance(address owner, address spender) external view returns (uint256);
85     function approve(address spender, uint256 amount) external returns (bool);
86     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
87 
88     event Transfer(address indexed from, address indexed to, uint256 value);
89     event Approval(address indexed owner, address indexed spender, uint256 value);
90 }
91 
92 contract Context {
93     constructor () internal { }
94     // solhint-disable-previous-line no-empty-blocks
95 
96     function _msgSender() internal view returns (address) {
97         return msg.sender;
98     }
99 
100     function _msgData() internal view returns (bytes memory) {
101         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
102         return msg.data;
103     }
104 }
105 
106 contract Ownable is Context {
107     address private _owner;
108 
109     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
110 
111     constructor () internal {
112         _owner = _msgSender();
113         emit OwnershipTransferred(address(0), _owner);
114     }
115 
116     function owner() public view returns (address) {
117         return _owner;
118     }
119 
120     modifier onlyOwner() {
121         require(isOwner(), "Ownable: caller is not the owner");
122         _;
123     }
124 
125     function isOwner() public view returns (bool) {
126         return _msgSender() == _owner;
127     }
128 
129     function renounceOwnership() public onlyOwner {
130         emit OwnershipTransferred(_owner, address(0));
131         _owner = address(0);
132     }
133 
134     function transferOwnership(address newOwner) public onlyOwner {
135         _transferOwnership(newOwner);
136     }
137 
138     function _transferOwnership(address newOwner) internal {
139         require(newOwner != address(0), "Ownable: new owner is the zero address");
140         emit OwnershipTransferred(_owner, newOwner);
141         _owner = newOwner;
142     }
143 }
144 
145 contract PauserRole is Context, Ownable {
146     using Roles for Roles.Role;
147 
148     event PauserAdded(address indexed account);
149     event PauserRemoved(address indexed account);
150 
151     Roles.Role private _pausers;
152 
153     constructor () internal {
154         _addPauser(_msgSender());
155     }
156 
157     modifier onlyPauser() {
158         require(isPauser(_msgSender()), "PauserRole: caller does not have the Pauser role");
159         _;
160     }
161 
162     function isPauser(address account) public view returns (bool) {
163         return _pausers.has(account);
164     }
165 
166     function addPauser(address account) public onlyOwner {
167         _addPauser(account);
168     }
169 
170     function removePauser(address account) public onlyOwner {
171         _removePauser(account);
172     }
173 
174     function renouncePauser() public {
175         _removePauser(_msgSender());
176     }
177 
178     function _addPauser(address account) internal {
179         _pausers.add(account);
180         emit PauserAdded(account);
181     }
182 
183     function _removePauser(address account) internal {
184         _pausers.remove(account);
185         emit PauserRemoved(account);
186     }
187 }
188 
189 contract Pausable is PauserRole {
190     event Paused(address account);
191     event Unpaused(address account);
192 
193     bool private _paused;
194 
195     constructor () internal {
196         _paused = false;
197     }
198 
199     function paused() public view returns (bool) {
200         return _paused;
201     }
202 
203     modifier whenNotPaused() {
204         require(!_paused, "Pausable: paused");
205         _;
206     }
207 
208     modifier whenPaused() {
209         require(_paused, "Pausable: not paused");
210         _;
211     }
212 
213     function pause() public onlyPauser whenNotPaused {
214         _paused = true;
215         emit Paused(_msgSender());
216     }
217 
218     function unpause() public onlyPauser whenPaused {
219         _paused = false;
220         emit Unpaused(_msgSender());
221     }
222 }
223 
224 contract ERC20 is Context, IERC20 {
225     using SafeMath for uint256;
226 
227     mapping (address => uint256) private _balances;
228     mapping (address => mapping (address => uint256)) private _allowances;
229 
230     uint256 private _totalSupply;
231 
232     function totalSupply() public view returns (uint256) {
233         return _totalSupply;
234     }
235 
236     function balanceOf(address account) public view returns (uint256) {
237         return _balances[account];
238     }
239 
240     function transfer(address recipient, uint256 amount) public returns (bool) {
241         _transfer(_msgSender(), recipient, amount);
242         return true;
243     }
244 
245     function allowance(address owner, address spender) public view returns (uint256) {
246         return _allowances[owner][spender];
247     }
248 
249     function approve(address spender, uint256 amount) public returns (bool) {
250         _approve(_msgSender(), spender, amount);
251         return true;
252     }
253 
254     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
255         _transfer(sender, recipient, amount);
256         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
257         return true;
258     }
259 
260     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
261         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
262         return true;
263     }
264 
265     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
266         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
267         return true;
268     }
269 
270     function _transfer(address sender, address recipient, uint256 amount) internal {
271         require(sender != address(0), "ERC20: transfer from the zero address");
272         require(recipient != address(0), "ERC20: transfer to the zero address");
273 
274         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
275         _balances[recipient] = _balances[recipient].add(amount);
276         emit Transfer(sender, recipient, amount);
277     }
278 
279     function _mint(address account, uint256 amount) internal {
280         require(account != address(0), "ERC20: mint to the zero address");
281 
282         _totalSupply = _totalSupply.add(amount);
283         _balances[account] = _balances[account].add(amount);
284         emit Transfer(address(0), account, amount);
285     }
286 
287     function _burn(address account, uint256 amount) internal {
288         require(account != address(0), "ERC20: burn from the zero address");
289 
290         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
291         _totalSupply = _totalSupply.sub(amount);
292         emit Transfer(account, address(0), amount);
293     }
294 
295     function _approve(address owner, address spender, uint256 amount) internal {
296         require(owner != address(0), "ERC20: approve from the zero address");
297         require(spender != address(0), "ERC20: approve to the zero address");
298 
299         _allowances[owner][spender] = amount;
300         emit Approval(owner, spender, amount);
301     }
302 
303     function _burnFrom(address account, uint256 amount) internal {
304         _burn(account, amount);
305         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
306     }
307 }
308 
309 contract ERC20Pausable is ERC20, Pausable {
310     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
311         return super.transfer(to, value);
312     }
313 
314     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
315         return super.transferFrom(from, to, value);
316     }
317 
318     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
319         return super.approve(spender, value);
320     }
321 
322     function increaseAllowance(address spender, uint256 addedValue) public whenNotPaused returns (bool) {
323         return super.increaseAllowance(spender, addedValue);
324     }
325 
326     function decreaseAllowance(address spender, uint256 subtractedValue) public whenNotPaused returns (bool) {
327         return super.decreaseAllowance(spender, subtractedValue);
328     }
329 }
330 
331 contract ERC20Detailed {
332     string private _name;
333     string private _symbol;
334     uint8 private _decimals;
335 
336     constructor (string memory name, string memory symbol, uint8 decimals) public {
337         _name = name;
338         _symbol = symbol;
339         _decimals = decimals;
340     }
341 
342     function name() public view returns (string memory) {
343         return _name;
344     }
345 
346     function symbol() public view returns (string memory) {
347         return _symbol;
348     }
349 
350     function decimals() public view returns (uint8) {
351         return _decimals;
352     }
353 }
354 
355 contract BOMBXToken is ERC20Pausable, ERC20Detailed {
356     constructor() ERC20Detailed("XIO Network", "XIO", 18) public {
357         _mint(msg.sender, 100000000 * 10 ** 18);
358     }
359 
360     function multiTransfer(address[] memory receivers, uint256[] memory amounts) public {
361         for (uint256 i = 0; i < receivers.length; i++) {
362         transfer(receivers[i], amounts[i]);
363         }
364     }
365 }