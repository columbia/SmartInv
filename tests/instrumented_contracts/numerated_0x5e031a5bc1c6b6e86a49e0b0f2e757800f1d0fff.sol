1 pragma solidity 0.5.6;
2 
3 
4 
5 
6 // ERC20 declare
7 contract IERC20 {
8   function totalSupply() public view returns (uint256);
9   function balanceOf(address who) public view returns (uint256);
10   function transfer(address to, uint256 value) public returns (bool);
11   function allowance(address owner, address spender) public view returns (uint256);
12   function transferFrom(address from, address to, uint256 value) public returns (bool);
13   function approve(address spender, uint256 value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15   event Approval(address indexed owner, address indexed spender, uint256 value);
16   event Burn(address indexed burner, uint256 value);
17 }
18 
19 
20 
21 
22 // Ownable
23 contract Ownable {
24   address public owner;
25   address public admin;
26 
27   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
28 
29 
30   constructor() public {
31     owner = msg.sender;
32   }
33 
34 
35   modifier onlyOwner() {
36     require(msg.sender == owner);
37     _;
38   }
39 
40   modifier onlyOwnerOrAdmin() {
41     require((msg.sender == owner || msg.sender == admin));
42     _;
43   }
44 
45 
46   function transferOwnership(address newOwner) onlyOwner public {
47     require(newOwner != address(0));
48     require(newOwner != owner);
49     require(newOwner != admin);
50 
51     emit OwnershipTransferred(owner, newOwner);
52     owner = newOwner;
53   }
54 
55   function setAdmin(address newAdmin) onlyOwner public {
56     require(admin != newAdmin);
57     require(owner != newAdmin);
58 
59     admin = newAdmin;
60   }
61 }
62 
63 
64 
65 
66 // ERC20 functions
67 contract ERC20 is IERC20, Ownable {
68     using SafeMath for uint256;
69 
70     mapping (address => uint256) private _balances;
71     mapping(address => bool) internal locks;
72     mapping (address => mapping (address => uint256)) private _allowed;
73     
74     uint256 public Max_supply = 10000000000 * (10 ** 18);
75     uint256 private _totalSupply;
76 
77     function totalSupply() public view returns (uint256) {
78         return _totalSupply;
79     }
80 
81 
82     function balanceOf(address owner) public view returns (uint256) {
83         return _balances[owner];
84     }
85 
86 
87     function allowance(address owner, address spender) public view returns (uint256) {
88         return _allowed[owner][spender];
89     }
90 
91 
92     function transfer(address to, uint256 value) public returns (bool) {
93         _transfer(msg.sender, to, value);
94         return true;
95     }
96     
97     function _transfer(address from, address to, uint256 value) internal {
98         require(to != address(0));
99         require(locks[msg.sender] == false);
100         _balances[from] = _balances[from].sub(value);
101         _balances[to] = _balances[to].add(value);
102         emit Transfer(from, to, value);
103     }
104     
105 
106     function approve(address spender, uint256 value) public returns (bool) {
107         _approve(msg.sender, spender, value);
108         return true;
109     }
110     
111     function _approve(address owner, address spender, uint256 value) internal {
112         require(spender != address(0));
113         require(owner != address(0));
114 
115         _allowed[owner][spender] = value;
116         emit Approval(owner, spender, value);
117     }
118 
119     function transferFrom(address from, address to, uint256 value) public returns (bool) {
120         _transfer(from, to, value);
121         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
122         return true;
123     }
124 
125 
126     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
127         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
128         return true;
129     }
130 
131 
132     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
133         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
134         return true;
135     }
136 
137 
138     function _mint(address account, uint256 value) internal {
139         require(account != address(0));
140         require(Max_supply >= _totalSupply.add(value));
141         _totalSupply = _totalSupply.add(value);
142         _balances[account] = _balances[account].add(value);
143         emit Transfer(address(0), account, value);
144     }
145     
146     
147     function burn(address from, uint256 value) public onlyOwner {
148         _burn(from, value);
149     }
150     
151 
152     function _burn(address account, uint256 value) internal {
153         require(account != address(0));
154         
155         _totalSupply = _totalSupply.sub(value);
156         _balances[account] = _balances[account].sub(value);
157         emit Transfer(account, address(0), value);
158     }
159     
160 
161     function lock(address _owner) public onlyOwner returns (bool) {
162         require(locks[_owner] == false);
163         locks[_owner] = true;
164         return true;
165     }
166 
167     function unlock(address _owner) public onlyOwner returns (bool) {
168         require(locks[_owner] == true);
169         locks[_owner] = false;
170         return true;
171     }
172 
173     function showLockState(address _owner) public view returns (bool) {
174         return locks[_owner];
175     }
176 
177 }
178 
179 
180 // Pause, Mint base
181 library Roles {
182     struct Role {
183         mapping (address => bool) bearer;
184     }
185 
186 
187     function add(Role storage role, address account) internal {
188         require(account != address(0));
189         require(!has(role, account));
190 
191         role.bearer[account] = true;
192     }
193 
194 
195     function remove(Role storage role, address account) internal {
196         require(account != address(0));
197         require(has(role, account));
198 
199         role.bearer[account] = false;
200     }
201 
202 
203     function has(Role storage role, address account) internal view returns (bool) {
204         require(account != address(0));
205         return role.bearer[account];
206     }
207 }
208 
209 
210 
211 // ERC20Detailed
212 contract ERC20Detailed is IERC20 {
213     string private _name;
214     string private _symbol;
215     uint8 private _decimals;
216 
217     constructor (string memory name, string memory symbol, uint8 decimals) public {
218         _name = name;
219         _symbol = symbol;
220         _decimals = decimals;
221     }
222     
223     function decimals() public view returns (uint8) {
224         return _decimals;
225     }
226 }
227 
228 
229 
230 
231 // Math
232 library Math {
233 
234     function max(uint256 a, uint256 b) internal pure returns (uint256) {
235         return a >= b ? a : b;
236     }
237 
238 
239     function min(uint256 a, uint256 b) internal pure returns (uint256) {
240         return a < b ? a : b;
241     }
242 
243 
244     function average(uint256 a, uint256 b) internal pure returns (uint256) {
245         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
246     }
247 }
248 
249 
250 
251 
252 // SafeMath
253 library SafeMath {
254   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
255     if (a == 0 || b == 0) {
256       return 0;
257     }
258 
259     uint256 c = a * b;
260     assert(c / a == b);
261     return c;
262   }
263 
264   function div(uint256 a, uint256 b) internal pure returns (uint256) {
265     // assert(b > 0); // Solidity automatically throws when dividing by 0
266     uint256 c = a / b;
267     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
268     return c;
269   }
270 
271   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
272     assert(b <= a);
273     return a - b;
274   }
275 
276   function add(uint256 a, uint256 b) internal pure returns (uint256) {
277     uint256 c = a + b;
278     assert(c >= a); // overflow check
279     return c;
280   }
281 }
282 
283 
284 
285 
286 // Pause part
287 contract PauserRole {
288     using Roles for Roles.Role;
289 
290     event PauserAdded(address indexed account);
291     event PauserRemoved(address indexed account);
292 
293     Roles.Role private _pausers;
294 
295     constructor () internal {
296         _addPauser(msg.sender);
297     }
298 
299     modifier onlyPauser() {
300         require(isPauser(msg.sender));
301         _;
302     }
303 
304     function isPauser(address account) public view returns (bool) {
305         return _pausers.has(account);
306     }
307 
308     function addPauser(address account) public onlyPauser {
309         _addPauser(account);
310     }
311 
312     function renouncePauser() public {
313         _removePauser(msg.sender);
314     }
315 
316     function _addPauser(address account) internal {
317         _pausers.add(account);
318         emit PauserAdded(account);
319     }
320 
321     function _removePauser(address account) internal {
322         _pausers.remove(account);
323         emit PauserRemoved(account);
324     }
325 }
326 
327 
328 
329 
330 
331 contract Pausable is PauserRole {
332     event Paused(address account);
333     event Unpaused(address account);
334 
335     bool private _paused;
336 
337     constructor () internal {
338         _paused = false;
339     }
340 
341     function paused() public view returns (bool) {
342         return _paused;
343     }
344 
345 
346     modifier whenNotPaused() {
347         require(!_paused);
348         _;
349     }
350 
351 
352     modifier whenPaused() {
353         require(_paused);
354         _;
355     }
356 
357 
358     function pause() public onlyPauser whenNotPaused {
359         _paused = true;
360         emit Paused(msg.sender);
361     }
362 
363 
364     function unpause() public onlyPauser whenPaused {
365         _paused = false;
366         emit Unpaused(msg.sender);
367     }
368 }
369 
370 
371 
372 
373 contract ERC20Pausable is ERC20, Pausable {
374     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
375         return super.transfer(to, value);
376     }
377 
378     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
379         return super.transferFrom(from, to, value);
380     }
381 
382     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
383         return super.approve(spender, value);
384     }
385 
386     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool) {
387         return super.increaseAllowance(spender, addedValue);
388     }
389 
390     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool) {
391         return super.decreaseAllowance(spender, subtractedValue);
392     }
393 }
394 
395 
396 
397 
398 // Mintable part
399 contract MinterRole {
400     using Roles for Roles.Role;
401 
402     event MinterAdded(address indexed account);
403     event MinterRemoved(address indexed account);
404 
405     Roles.Role private _minters;
406 
407     constructor () internal {
408         _addMinter(msg.sender);
409     }
410 
411     modifier onlyMinter() {
412         require(isMinter(msg.sender));
413         _;
414     }
415 
416     function isMinter(address account) public view returns (bool) {
417         return _minters.has(account);
418     }
419 
420     function addMinter(address account) public onlyMinter {
421         _addMinter(account);
422     }
423 
424     function renounceMinter() public {
425         _removeMinter(msg.sender);
426     }
427 
428     function _addMinter(address account) internal {
429         _minters.add(account);
430         emit MinterAdded(account);
431     }
432 
433     function _removeMinter(address account) internal {
434         _minters.remove(account);
435         emit MinterRemoved(account);
436     }
437 }
438 
439 
440 
441 
442 contract ERC20Mintable is ERC20, MinterRole {
443     function mint(address to, uint256 value) public onlyMinter returns (bool) {
444         _mint(to, value);
445         return true;
446     }
447 }
448 
449 
450 
451 // Token detailed
452 contract DAFIN is ERC20, ERC20Detailed, ERC20Pausable, ERC20Mintable {
453     
454     string public constant name = "DAFIN";
455     string public constant symbol = "DAF";
456     
457     uint8 public constant DECIMALS = 18;
458     uint256 public constant INITIAL_SUPPLY = 300000000 * (10 ** uint256(DECIMALS));
459 
460     constructor () public ERC20Detailed(name, symbol, DECIMALS) {
461         _mint(msg.sender, INITIAL_SUPPLY);
462     }
463   
464 }