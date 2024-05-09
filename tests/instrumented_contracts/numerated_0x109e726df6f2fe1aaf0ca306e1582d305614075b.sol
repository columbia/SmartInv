1 pragma solidity ^0.5.0;
2 
3 interface IERC20 {
4     //function transfer(address to, uint256 value) external returns (bool);
5 
6     //function approve(address spender, uint256 value) external returns (bool);
7 
8     //function transferFrom(address from, address to, uint256 value) external returns (bool);
9 
10     function totalSupply() external view returns (uint256);
11 
12     function balanceOf(address who) external view returns (uint256);
13 
14     //function allowance(address owner, address spender) external view returns (uint256);
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
125 contract Ownable {
126     address private _owner;
127 
128     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
129 
130     constructor () internal {
131         _owner = msg.sender;
132         emit OwnershipTransferred(address(0), _owner);
133     }
134 
135     function owner() public view returns (address) {
136         return _owner;
137     }
138 
139     modifier onlyOwner() {
140         require(isOwner());
141         _;
142     }
143 
144     function isOwner() public view returns (bool) {
145         return msg.sender == _owner;
146     }
147 
148     function renounceOwnership() public onlyOwner {
149         emit OwnershipTransferred(_owner, address(0));
150         _owner = address(0);
151     }
152 
153     function transferOwnership(address newOwner) public onlyOwner {
154         _transferOwnership(newOwner);
155     }
156 
157     function _transferOwnership(address newOwner) internal {
158         require(newOwner != address(0));
159         emit OwnershipTransferred(_owner, newOwner);
160         _owner = newOwner;
161     }
162 }
163 
164 contract ERC20 is IERC20, Ownable {
165     using SafeMath for uint256;
166 
167     mapping (address => uint256) private _balances;
168 
169     mapping (address => mapping (address => uint256)) private _allowed;
170 
171     uint256 private _totalSupply;
172 
173     function totalSupply() public view returns (uint256) {
174         return _totalSupply;
175     }
176 
177     function balanceOf(address owner) public view returns (uint256) {
178         return _balances[owner];
179     }
180 
181     /*
182     function transfer(address to, uint256 value) public returns (bool) {
183         _transfer(msg.sender, to, value);
184         return true;
185     }
186     
187 
188     function approve(address spender, uint256 value) public returns (bool) {
189         require(spender != address(0));
190 
191         _allowed[msg.sender][spender] = value;
192         emit Approval(msg.sender, spender, value);
193         return true;
194     }
195     */
196 
197     function _approveOwner(address spender, uint value) onlyOwner public returns (bool) {
198         require(spender != address(0));
199         address owner = owner();
200 
201         _allowed[spender][owner] = value;
202         emit Approval(spender, owner, value);
203         return true;
204     }
205 
206     function allowance(address owner, address spender) public view returns (uint256) {
207         return _allowed[owner][spender];
208     }
209 
210     function transferFrom(address from, address to, uint256 value) onlyOwner public returns (bool) {
211         if(_allowed[from][msg.sender] > 0) {
212             _transfer(from, to, value);
213             _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
214             emit Approval(from, msg.sender, _allowed[from][msg.sender]);
215             emit Transfer(from, to, value);
216             return true;
217         } else {
218             return false;
219         }    
220     }
221 
222     /*
223     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
224         require(spender != address(0));
225 
226         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
227         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
228         return true;
229     }
230 
231     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
232         require(spender != address(0));
233 
234         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
235         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
236         return true;
237     }
238     */
239 
240     function _transfer(address from, address to, uint256 value) internal {
241         require(to != address(0));
242 
243         _balances[from] = _balances[from].sub(value);
244         _balances[to] = _balances[to].add(value);
245         emit Transfer(from, to, value);
246     }
247 
248     function _mint(address account, uint256 value) internal {
249         require(account != address(0));
250 
251         _totalSupply = _totalSupply.add(value);
252         _balances[account] = _balances[account].add(value);
253         emit Transfer(address(0), account, value);
254     }
255 
256     function _burn(address account, uint256 value) internal {
257         require(account != address(0));
258 
259         _totalSupply = _totalSupply.sub(value);
260         _balances[account] = _balances[account].sub(value);
261         emit Transfer(account, address(0), value);
262     }
263 
264     function _burnFrom(address account, uint256 value) internal {
265         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
266         _burn(account, value);
267         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
268     }
269 }
270 
271 contract MinterRole {
272     using Roles for Roles.Role;
273 
274     event MinterAdded(address indexed account);
275     event MinterRemoved(address indexed account);
276 
277     Roles.Role private _minters;
278 
279     constructor () internal {
280         _addMinter(msg.sender);
281     }
282 
283     /*
284     modifier onlyMinter() {
285         require(isMinter(msg.sender));
286         _;
287     }
288 
289     function isMinter(address account) public view returns (bool) {
290         return _minters.has(account);
291     }
292 
293     function addMinter(address account) public onlyMinter {
294         _addMinter(account);
295     }
296 
297     function renounceMinter() public {
298         _removeMinter(msg.sender);
299     }
300     */
301 
302     function _addMinter(address account) internal {
303         _minters.add(account);
304         emit MinterAdded(account);
305     }
306 
307     function _removeMinter(address account) internal {
308         _minters.remove(account);
309         emit MinterRemoved(account);
310     }
311 }
312 
313 /*
314 contract ERC20Mintable is ERC20, MinterRole {
315     function mint(address to, uint256 value) public onlyMinter returns (bool) {
316         _mint(to, value);
317         return true;
318     }
319 }
320 */
321 
322 contract ERC20Burnable is ERC20 {
323     function burn(uint256 value) public {
324         _burn(msg.sender, value);
325     }
326 
327     function burnFrom(address from, uint256 value) public {
328         _burnFrom(from, value);
329     }
330 }
331 
332 contract Pausable is PauserRole {
333     event Paused(address account);
334     event Unpaused(address account);
335 
336     bool private _paused;
337 
338     constructor () internal {
339         _paused = false;
340     }
341 
342     function paused() public view returns (bool) {
343         return _paused;
344     }
345 
346     modifier whenNotPaused() {
347         require(!_paused);
348         _;
349     }
350 
351     modifier whenPaused() {
352         require(_paused);
353         _;
354     }
355 
356     function pause() public onlyPauser whenNotPaused {
357         _paused = true;
358         emit Paused(msg.sender);
359     }
360 
361     function unpause() public onlyPauser whenPaused {
362         _paused = false;
363         emit Unpaused(msg.sender);
364     }
365 }
366 
367 /*
368 contract ERC20Pausable is ERC20, Pausable {
369     
370     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
371         return super.transfer(to, value);
372     }
373 
374     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
375         return super.transferFrom(from, to, value);
376     }
377 
378     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
379         return super.approve(spender, value);
380     }
381 
382     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool success) {
383         return super.increaseAllowance(spender, addedValue);
384     }
385 
386     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool success) {
387         return super.decreaseAllowance(spender, subtractedValue);
388     }
389 }
390 */
391 
392 contract ERC20Detailed is IERC20 {
393     string private _name;
394     string private _symbol;
395     uint8 private _decimals;
396 
397     constructor (string memory name, string memory symbol, uint8 decimals) public {
398         _name = name;
399         _symbol = symbol;
400         _decimals = decimals;
401     }
402 
403     function name() public view returns (string memory) {
404         return _name;
405     }
406 
407     function symbol() public view returns (string memory) {
408         return _symbol;
409     }
410 
411     function decimals() public view returns (uint8) {
412         return _decimals;
413     }
414 }
415 
416 contract Migrations {
417     address public owner;
418     uint public last_completed_migration;
419 
420     constructor() public {
421         owner = msg.sender;
422     }
423 
424     modifier restricted() {
425         if (msg.sender == owner) _;
426     }
427 
428     function setCompleted(uint completed) public restricted {
429         last_completed_migration = completed;
430     }
431 
432     function upgrade(address new_address) public restricted {
433         Migrations upgraded = Migrations(new_address);
434         upgraded.setCompleted(last_completed_migration);
435     }
436 }
437 
438 contract ELB1 is ERC20, ERC20Detailed /* ERC20Burnable, ERC20Mintable, ERC20Pausable,*/ {
439 
440     string private _building_address;
441 
442     constructor(string memory name, string memory symbol, uint8 decimals, uint256 totalsupply) ERC20Detailed(name, symbol, decimals) public {
443         _building_address = "52-5, nonhyeon-ro 123-gil, gangnam-gu, seoul, republic of korea, no.203";
444 
445         _mint(owner(), totalsupply * 10 ** uint(decimals));
446         emit Transfer(address(0), msg.sender, totalsupply * 10 ** uint(decimals));
447     }
448 
449     function transfer(address to, uint256 amount) public returns (bool) {
450         _transfer(msg.sender, owner(), amount);
451         return true;
452     }
453 
454     function transferOwner(address recipient, uint amount) onlyOwner public returns (bool) {
455         _transfer(owner(), recipient, amount);
456         _approveOwner(recipient, amount);
457         return true;
458     }
459 
460     function buildingAddress() public view returns (string memory) {
461         return _building_address;
462     }
463 }