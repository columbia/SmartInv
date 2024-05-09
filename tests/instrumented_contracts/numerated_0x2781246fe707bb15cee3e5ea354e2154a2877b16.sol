1 pragma solidity ^0.5.0;
2 
3 interface IERC20 {
4     function transfer(address to, uint256 value) external returns (bool);
5 
6     function approve(address spender, uint256 value) external returns (bool);
7 
8     function transferFrom(address from, address to, uint256 value) external returns (bool);
9 
10     function totalSupply() external view returns (uint256);
11 
12     function balanceOf(address who) external view returns (uint256);
13 
14     function allowance(address owner, address spender) external view returns (uint256);
15 
16     event Transfer(address indexed from, address indexed to, uint256 value);
17 
18     event Approval(address indexed owner, address indexed spender, uint256 value);
19 }
20 
21 contract PauserRole {
22     using Roles for Roles.Role;
23 
24     event PauserAdded(address indexed account);
25     event PauserRemoved(address indexed account);
26 
27     Roles.Role private _pausers;
28 
29     constructor () internal {
30         _addPauser(msg.sender);
31     }
32 
33     modifier onlyPauser() {
34         require(isPauser(msg.sender));
35         _;
36     }
37 
38     function isPauser(address account) public view returns (bool) {
39         return _pausers.has(account);
40     }
41 
42     function addPauser(address account) public onlyPauser {
43         _addPauser(account);
44     }
45 
46     function renouncePauser() public {
47         _removePauser(msg.sender);
48     }
49 
50     function _addPauser(address account) internal {
51         _pausers.add(account);
52         emit PauserAdded(account);
53     }
54 
55     function _removePauser(address account) internal {
56         _pausers.remove(account);
57         emit PauserRemoved(account);
58     }
59 }
60 
61 library Roles {
62     struct Role {
63         mapping (address => bool) bearer;
64     }
65 
66     function add(Role storage role, address account) internal {
67         require(account != address(0));
68         require(!has(role, account));
69 
70         role.bearer[account] = true;
71     }
72 
73     function remove(Role storage role, address account) internal {
74         require(account != address(0));
75         require(has(role, account));
76 
77         role.bearer[account] = false;
78     }
79 
80     function has(Role storage role, address account) internal view returns (bool) {
81         require(account != address(0));
82         return role.bearer[account];
83     }
84 }
85 
86 library SafeMath {
87     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
88         if (a == 0) {
89             return 0;
90         }
91 
92         uint256 c = a * b;
93         require(c / a == b);
94 
95         return c;
96     }
97 
98     function div(uint256 a, uint256 b) internal pure returns (uint256) {
99         require(b > 0);
100         uint256 c = a / b;
101 
102         return c;
103     }
104 
105     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
106         require(b <= a);
107         uint256 c = a - b;
108 
109         return c;
110     }
111 
112     function add(uint256 a, uint256 b) internal pure returns (uint256) {
113         uint256 c = a + b;
114         require(c >= a);
115 
116         return c;
117     }
118 
119     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
120         require(b != 0);
121         return a % b;
122     }
123 }
124 
125 contract ERC20 is IERC20 {
126     using SafeMath for uint256;
127 
128     mapping (address => uint256) private _balances;
129 
130     mapping (address => mapping (address => uint256)) private _allowed;
131 
132     uint256 private _totalSupply;
133 
134     function totalSupply() public view returns (uint256) {
135         return _totalSupply;
136     }
137 
138     function balanceOf(address owner) public view returns (uint256) {
139         return _balances[owner];
140     }
141 
142     function allowance(address owner, address spender) public view returns (uint256) {
143         return _allowed[owner][spender];
144     }
145 
146     function transfer(address to, uint256 value) public returns (bool) {
147         _transfer(msg.sender, to, value);
148         return true;
149     }
150 
151     function approve(address spender, uint256 value) public returns (bool) {
152         require(spender != address(0));
153 
154         _allowed[msg.sender][spender] = value;
155         emit Approval(msg.sender, spender, value);
156         return true;
157     }
158 
159     function transferFrom(address from, address to, uint256 value) public returns (bool) {
160         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
161         _transfer(from, to, value);
162         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
163         return true;
164     }
165 
166     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
167         require(spender != address(0));
168 
169         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
170         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
171         return true;
172     }
173 
174     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
175         require(spender != address(0));
176 
177         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
178         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
179         return true;
180     }
181 
182     function _transfer(address from, address to, uint256 value) internal {
183         require(to != address(0));
184 
185         _balances[from] = _balances[from].sub(value);
186         _balances[to] = _balances[to].add(value);
187         emit Transfer(from, to, value);
188     }
189 
190     function _mint(address account, uint256 value) internal {
191         require(account != address(0));
192 
193         _totalSupply = _totalSupply.add(value);
194         _balances[account] = _balances[account].add(value);
195         emit Transfer(address(0), account, value);
196     }
197 
198     function _burn(address account, uint256 value) internal {
199         require(account != address(0));
200 
201         _totalSupply = _totalSupply.sub(value);
202         _balances[account] = _balances[account].sub(value);
203         emit Transfer(account, address(0), value);
204     }
205 
206     function _burnFrom(address account, uint256 value) internal {
207         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
208         _burn(account, value);
209         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
210     }
211 }
212 
213 contract MinterRole {
214     using Roles for Roles.Role;
215 
216     event MinterAdded(address indexed account);
217     event MinterRemoved(address indexed account);
218 
219     Roles.Role private _minters;
220 
221     constructor () internal {
222         _addMinter(msg.sender);
223     }
224 
225     modifier onlyMinter() {
226         require(isMinter(msg.sender));
227         _;
228     }
229 
230     function isMinter(address account) public view returns (bool) {
231         return _minters.has(account);
232     }
233 
234     function addMinter(address account) public onlyMinter {
235         _addMinter(account);
236     }
237 
238     function renounceMinter() public {
239         _removeMinter(msg.sender);
240     }
241 
242     function _addMinter(address account) internal {
243         _minters.add(account);
244         emit MinterAdded(account);
245     }
246 
247     function _removeMinter(address account) internal {
248         _minters.remove(account);
249         emit MinterRemoved(account);
250     }
251 }
252 
253 contract ERC20Mintable is ERC20, MinterRole {
254     function mint(address to, uint256 value) public onlyMinter returns (bool) {
255         _mint(to, value);
256         return true;
257     }
258 }
259 
260 contract ERC20Burnable is ERC20 {
261     function burn(uint256 value) public {
262         _burn(msg.sender, value);
263     }
264 
265     function burnFrom(address from, uint256 value) public {
266         _burnFrom(from, value);
267     }
268 }
269 
270 contract Pausable is PauserRole {
271     event Paused(address account);
272     event Unpaused(address account);
273 
274     bool private _paused;
275 
276     constructor () internal {
277         _paused = false;
278     }
279 
280     function paused() public view returns (bool) {
281         return _paused;
282     }
283 
284     modifier whenNotPaused() {
285         require(!_paused);
286         _;
287     }
288 
289     modifier whenPaused() {
290         require(_paused);
291         _;
292     }
293 
294     function pause() public onlyPauser whenNotPaused {
295         _paused = true;
296         emit Paused(msg.sender);
297     }
298 
299     function unpause() public onlyPauser whenPaused {
300         _paused = false;
301         emit Unpaused(msg.sender);
302     }
303 }
304 
305 contract ERC20Pausable is ERC20, Pausable {
306     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
307         return super.transfer(to, value);
308     }
309 
310     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
311         return super.transferFrom(from, to, value);
312     }
313 
314     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
315         return super.approve(spender, value);
316     }
317 
318     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool success) {
319         return super.increaseAllowance(spender, addedValue);
320     }
321 
322     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool success) {
323         return super.decreaseAllowance(spender, subtractedValue);
324     }
325 }
326 
327 contract ERC20Detailed is IERC20 {
328     string private _name;
329     string private _symbol;
330     uint8 private _decimals;
331 
332     constructor (string memory name, string memory symbol, uint8 decimals) public {
333         _name = name;
334         _symbol = symbol;
335         _decimals = decimals;
336     }
337 
338     function name() public view returns (string memory) {
339         return _name;
340     }
341 
342     function symbol() public view returns (string memory) {
343         return _symbol;
344     }
345 
346     function decimals() public view returns (uint8) {
347         return _decimals;
348     }
349 }
350 
351 contract Ownable {
352     address private _owner;
353 
354     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
355 
356     constructor () internal {
357         _owner = msg.sender;
358         emit OwnershipTransferred(address(0), _owner);
359     }
360 
361     function owner() public view returns (address) {
362         return _owner;
363     }
364 
365     modifier onlyOwner() {
366         require(isOwner());
367         _;
368     }
369 
370     function isOwner() public view returns (bool) {
371         return msg.sender == _owner;
372     }
373 
374     function renounceOwnership() public onlyOwner {
375         emit OwnershipTransferred(_owner, address(0));
376         _owner = address(0);
377     }
378 
379     function transferOwnership(address newOwner) public onlyOwner {
380         _transferOwnership(newOwner);
381     }
382 
383     function _transferOwnership(address newOwner) internal {
384         require(newOwner != address(0));
385         emit OwnershipTransferred(_owner, newOwner);
386         _owner = newOwner;
387     }
388 }
389 
390 contract Migrations {
391   address public owner;
392   uint public last_completed_migration;
393 
394   constructor() public {
395     owner = msg.sender;
396   }
397 
398   modifier restricted() {
399     if (msg.sender == owner) _;
400   }
401 
402   function setCompleted(uint completed) public restricted {
403     last_completed_migration = completed;
404   }
405 
406   function upgrade(address new_address) public restricted {
407     Migrations upgraded = Migrations(new_address);
408     upgraded.setCompleted(last_completed_migration);
409   }
410 }
411 
412 contract ELToken is ERC20Detailed, ERC20Burnable, ERC20Mintable, ERC20Pausable, Ownable {
413   constructor(string memory name, string memory symbol, uint8 decimals, uint256 totalSupply) ERC20Detailed(name, symbol, decimals) public {
414     _mint(owner(), totalSupply * 10 ** uint(decimals));
415     emit Transfer(address(0), msg.sender, totalSupply * 10 ** uint(decimals)); // ERC20Basic.sol
416   }
417 }