1 pragma solidity ^0.5.0;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5         if (a == 0) return 0;
6 
7         uint256 c = a * b;
8         require(c / a == b, "SafeMath: multiplication overflow");
9 
10         return c;
11     }
12 
13     function div(uint256 a, uint256 b) internal pure returns (uint256) {
14         require(b > 0, "SafeMath: division by zero");
15         uint256 c = a / b;
16 
17         return c;
18     }
19 
20     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21         require(b <= a, "SafeMath: subtraction overflow");
22         uint256 c = a - b;
23 
24         return c;
25     }
26 
27     function add(uint256 a, uint256 b) internal pure returns (uint256) {
28         uint256 c = a + b;
29         require(c >= a, "SafeMath: addition overflow");
30 
31         return c;
32     }
33 
34     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
35         require(b != 0, "SafeMath: modulo by zero");
36         return a % b;
37     }
38 }
39 
40 library Roles {
41     struct Role {
42         mapping (address => bool) bearer;
43     }
44 
45     function add(Role storage role, address account) internal {
46         require(!has(role, account), "Roles: account already has role");
47         role.bearer[account] = true;
48     }
49 
50     function remove(Role storage role, address account) internal {
51         require(has(role, account), "Roles: account does not have role");
52         role.bearer[account] = false;
53     }
54 
55     function has(Role storage role, address account) internal view returns (bool) {
56         require(account != address(0), "Roles: account is the zero account");
57         return role.bearer[account];
58     }
59 }
60 
61 contract PauserRole {
62     using Roles for Roles.Role;
63 
64     event PauserAdded(address indexed account);
65     event PauserRemoved(address indexed account);
66 
67     Roles.Role private _pausers;
68 
69     constructor() internal {
70         _addPauser(msg.sender);
71     }
72 
73     modifier onlyPauser() {
74         require(isPauser(msg.sender), "PauserRole: caller does not have the Pauser role");
75         _;
76     }
77 
78     function isPauser(address account) public view returns (bool) {
79         return _pausers.has(account);
80     }
81 
82     function addPauser(address account) public onlyPauser {
83         _addPauser(account);
84     }
85 
86     function renouncePauser() public {
87         _removePauser(msg.sender);
88     }
89 
90     function _addPauser(address account) internal {
91         _pausers.add(account);
92         emit PauserAdded(account);
93     }
94 
95     function _removePauser(address account) internal {
96         _pausers.remove(account);
97         emit PauserRemoved(account);
98     }
99 }
100 
101 contract AdministratorRole {
102     using Roles for Roles.Role;
103 
104     event AdministractorTransfered(address indexed previousAdmin, address indexed newAdmin);
105     event LockerAdded(address indexed account);
106     event LockerRemoved(address indexed account);
107 
108     address private _admin;
109     Roles.Role private _lockers;
110 
111     constructor() internal {
112         _admin = msg.sender;
113 
114         emit AdministractorTransfered(address(0), _admin);
115     }
116 
117     function administrator() public view returns (address) {
118         return _admin;
119     }
120 
121     modifier onlyAdministrator() {
122         require(isAdministrator(), "AdministratorRole: caller is not the administrator");
123         _;
124     }
125 
126     function isAdministrator() public view returns (bool) {
127         return msg.sender == _admin;
128     }
129 
130     function transferAdministrator(address newAdmin) public onlyAdministrator {
131         _transferAdministrator(newAdmin);
132     }
133 
134     function _transferAdministrator(address newAdmin) internal {
135         require(newAdmin != address(0), "Ownable: new owner is the zero address");
136         emit AdministractorTransfered(_admin, newAdmin);
137         _admin = newAdmin;
138     }
139 
140     modifier lockerExists(address account) {
141         require(isLocker(account), "AdministratorRole: account is not a locker");
142         _;
143     }
144 
145     modifier lockerNotExists(address account) {
146         require(!isLocker(account), "AdministratorRole: account is a locker");
147         _;
148     }
149 
150     modifier onlyUnlocker() {
151         require(!isLocker(msg.sender), "AdministratorRole: caller is a locker");
152         _;
153     }
154 
155     modifier onlyLocker() {
156         require(isLocker(msg.sender), "AdministratorRole: caller is not a locker");
157         _;
158     }
159 
160     function isLocker(address account) public view returns (bool) {
161         return _lockers.has(account);
162     }
163 
164     function addLocker(address account) public onlyAdministrator lockerNotExists(account) {
165         _addLocker(account);
166     }
167 
168     function removeLocker(address account) public onlyAdministrator lockerExists(account) {
169         _removeLocker(account);
170     }
171 
172     function _addLocker(address account) internal {
173         _lockers.add(account);
174         emit LockerAdded(account);
175     }
176 
177     function _removeLocker(address account) internal {
178         _lockers.remove(account);
179         emit LockerRemoved(account);
180     }
181 }
182 
183 contract Ownable {
184     address private _owner;
185 
186     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
187 
188     constructor() internal {
189         _owner = msg.sender;
190 
191         emit OwnershipTransferred(address(0), _owner);
192     }
193 
194     function owner() public view returns (address) {
195         return _owner;
196     }
197 
198     modifier onlyOwner() {
199         require(isOwner(), "Ownable: caller is not the owner");
200         _;
201     }
202 
203     function isOwner() public view returns (bool) {
204         return msg.sender == _owner;
205     }
206 
207     function transferOwnership(address newOwner) public onlyOwner {
208         _transferOwnership(newOwner);
209     }
210 
211     function _transferOwnership(address newOwner) internal {
212         require(newOwner != address(0), "Ownable: new owner is the zero address");
213         emit OwnershipTransferred(_owner, newOwner);
214         _owner = newOwner;
215     }
216 }
217 
218 contract Pausable is PauserRole {
219     event Paused(address account);
220     event Unpaused(address account);
221 
222     bool private _paused;
223 
224     constructor() internal {
225         _paused = false;
226     }
227 
228     function paused() public view returns (bool) {
229         return _paused;
230     }
231 
232     modifier whenNotPaused() {
233         require(!_paused, "Pausable: paused");
234         _;
235     }
236 
237     modifier whenPaused() {
238         require(_paused, "Pausable: not paused");
239         _;
240     }
241 
242     function pause() public onlyPauser whenNotPaused {
243         _paused = true;
244         emit Paused(msg.sender);
245     }
246 
247     function unpause() public onlyPauser whenPaused {
248         _paused = false;
249         emit Unpaused(msg.sender);
250     }
251 }
252 
253 interface IERC20 {
254     function transfer(address to, uint256 value) external returns (bool);
255 
256     function approve(address spender, uint256 value) external returns (bool);
257 
258     function transferFrom(address from, address to, uint256 value) external returns (bool);
259 
260     function totalSupply() external view returns (uint256);
261 
262     function balanceOf(address who) external view returns (uint256);
263 
264     function allowance(address owner, address spender) external view returns (uint256);
265 
266     event Transfer(address indexed from, address indexed to, uint256 value);
267 
268     event Approval(address indexed owner, address indexed spender, uint256 value);
269 }
270 
271 contract ERC20 is IERC20, AdministratorRole, Pausable {
272     using SafeMath for uint256;
273 
274     mapping (address => uint256) private _balances;
275 
276     mapping (address => mapping (address => uint256)) private _allowed;
277 
278     uint256 private _totalSupply;
279 
280     function totalSupply() public view returns (uint256) {
281         return _totalSupply;
282     }
283 
284     function balanceOf(address owner) public view returns (uint256) {
285         return _balances[owner];
286     }
287 
288     function allowance(address owner, address spender) public view returns (uint256) {
289         return _allowed[owner][spender];
290     }
291 
292     function transfer(address to, uint256 value) public whenNotPaused onlyUnlocker returns (bool) {
293         _transfer(msg.sender, to, value);
294         return true;
295     }
296 
297     function approve(address spender, uint256 value) public whenNotPaused onlyUnlocker returns (bool) {
298         if (value != 0 && _allowed[msg.sender][spender] != 0) return false;
299         _approve(msg.sender, spender, value);
300         return true;
301     }
302 
303     function transferFrom(address from, address to, uint256 value) public whenNotPaused lockerNotExists(from) returns (bool) {
304         _transfer(from, to, value);
305         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
306         return true;
307     }
308 
309     function increaseAllowance(address spender, uint256 addedValue) public whenNotPaused onlyUnlocker returns (bool) {
310         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
311         return true;
312     }
313 
314     function decreaseAllowance(address spender, uint256 subtractedValue) public whenNotPaused onlyUnlocker returns (bool) {
315         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
316         return true;
317     }
318 
319     function _transfer(address from, address to, uint256 value) internal {
320         require(to != address(0), "ERC20: transfer to zero address");
321 
322         _balances[from] = _balances[from].sub(value);
323         _balances[to] = _balances[to].add(value);
324         emit Transfer(from, to, value);
325     }
326 
327     function _approve(address owner, address spender, uint256 value) internal {
328         require(owner != address(0), "ERC20: approve from the zero address");
329         require(spender != address(0), "ERC20: approve to the zero address");
330 
331         _allowed[owner][spender] = value;
332         emit Approval(owner, spender, value);
333     }
334 
335     function _mint(address account, uint256 value) internal {
336         require(account != address(0), "ERC20: mint to zero address");
337         _totalSupply = _totalSupply.add(value);
338         _balances[account] = _balances[account].add(value);
339         emit Transfer(address(0), account, value);
340     }
341 }
342 
343 contract ERC20Detailed is IERC20 {
344     string private _name;
345     string private _symbol;
346     uint8 private _decimals;
347 
348     constructor(string memory name, string memory symbol, uint8 decimals) public {
349         _name = name;
350         _symbol = symbol;
351         _decimals = decimals;
352     }
353 
354     function name() public view returns (string memory) {
355         return _name;
356     }
357 
358     function symbol() public view returns (string memory) {
359         return _symbol;
360     }
361 
362     function decimals() public view returns (uint8) {
363         return _decimals;
364     }
365 }
366 
367 contract ETMToken is Ownable, ERC20Detailed, ERC20 {
368     using SafeMath for uint256;
369 
370     uint8 public constant DECIMALS = 18;
371     uint256 private INIT_SUPPLY = uint256(210000000).mul(10 ** uint256(DECIMALS));
372     bool private _destoried = false;
373 
374     constructor() public ERC20Detailed("EnTanMo", "ETM", DECIMALS) {
375         _mint(msg.sender, INIT_SUPPLY);
376     }
377 
378     function destory() public onlyOwner returns (bool) {
379         if (!_destoried) {
380             selfdestruct(address(0));
381             _destoried = true;
382             return true;
383         }
384 
385         return false;
386     }
387 }