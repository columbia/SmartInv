1 pragma solidity ^0.5.0;
2 
3 
4 library SafeMath {
5 
6     function add(uint256 a, uint256 b) internal pure returns (uint256) {
7         uint256 c = a + b;
8         require(c >= a, "SafeMath: addition overflow");
9 
10         return c;
11     }
12 
13     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
14         require(b <= a, "SafeMath: subtraction overflow");
15         uint256 c = a - b;
16 
17         return c;
18     }
19 
20     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
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
32         require(b > 0, "SafeMath: division by zero");
33         uint256 c = a / b;
34         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35 
36         return c;
37     }
38 
39     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
40         require(b != 0, "SafeMath: modulo by zero");
41         return a % b;
42     }
43 }
44 
45 
46 contract Ownable {
47 
48     address private _owner;
49 
50     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
51 
52     constructor () internal {
53         _owner = msg.sender;
54         emit OwnershipTransferred(address(0), _owner);
55     }
56 
57     function owner() public view returns (address) {
58         return _owner;
59     }
60 
61     modifier onlyOwner() {
62         require(isOwner(), "Ownable: caller is not the owner");
63         _;
64     }
65 
66     function isOwner() public view returns (bool) {
67         return msg.sender == _owner;
68     }
69 
70     // function renounceOwnership() public onlyOwner {
71     //     emit OwnershipTransferred(_owner, address(0));
72     //     _owner = address(0);
73     // }
74 
75     function transferOwnership(address newOwner) public onlyOwner {
76         _transferOwnership(newOwner);
77     }
78 
79     function _transferOwnership(address newOwner) internal {
80         require(newOwner != address(0), "Ownable: new owner is the zero address");
81         emit OwnershipTransferred(_owner, newOwner);
82         _owner = newOwner;
83     }
84 }
85 
86 
87 library Roles {
88 
89     struct Role {
90         mapping (address => bool) bearer;
91     }
92 
93     function add(Role storage role, address account) internal {
94         require(!has(role, account), "Roles: account already has role");
95         role.bearer[account] = true;
96     }
97 
98     function remove(Role storage role, address account) internal {
99         require(has(role, account), "Roles: account does not have role");
100         role.bearer[account] = false;
101     }
102 
103     function has(Role storage role, address account) internal view returns (bool) {
104         require(account != address(0), "Roles: account is the zero address");
105         return role.bearer[account];
106     }
107 }
108 
109 
110 contract PauserRole is Ownable {
111 
112     using Roles for Roles.Role;
113 
114     event PauserAdded(address indexed account);
115 
116     event PauserRemoved(address indexed account);
117 
118     Roles.Role private _pausers;
119 
120     constructor () internal {
121         _addPauser(msg.sender);
122     }
123 
124     modifier onlyPauser() {
125         require(isPauser(msg.sender), "PauserRole: caller does not have the Pauser role");
126         _;
127     }
128 
129     function isPauser(address account) public view returns (bool) {
130         return _pausers.has(account);
131     }
132 
133     function addPauser(address account) public onlyOwner {
134         _addPauser(account);
135     }
136 
137     function removePauser(address account) public onlyOwner {
138         _removePauser(account);
139     }
140 
141     function renouncePauser() public {
142         _removePauser(msg.sender);
143     }
144 
145     function _addPauser(address account) internal {
146         _pausers.add(account);
147         emit PauserAdded(account);
148     }
149 
150     function _removePauser(address account) internal {
151         _pausers.remove(account);
152         emit PauserRemoved(account);
153     }
154 }
155 
156 
157 contract Pausable is PauserRole {
158 
159     event Paused(address account);
160 
161     event Unpaused(address account);
162 
163     bool private _paused;
164 
165     constructor () internal {
166         _paused = false;
167     }
168 
169     function paused() public view returns (bool) {
170         return _paused;
171     }
172 
173     modifier whenNotPaused() {
174         require(!_paused, "Pausable: paused");
175         _;
176     }
177 
178     modifier whenPaused() {
179         require(_paused, "Pausable: not paused");
180         _;
181     }
182 
183     function pause() public onlyPauser whenNotPaused {
184         _paused = true;
185         emit Paused(msg.sender);
186     }
187 
188     function unpause() public onlyPauser whenPaused {
189         _paused = false;
190         emit Unpaused(msg.sender);
191     }
192 }
193 
194 
195 interface IERC20 {
196 
197     function totalSupply() external view returns (uint256);
198 
199     function balanceOf(address account) external view returns (uint256);
200 
201     function transfer(address recipient, uint256 amount) external returns (bool);
202 
203     function allowance(address owner, address spender) external view returns (uint256);
204 
205     function approve(address spender, uint256 amount) external returns (bool);
206 
207     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
208 
209     event Transfer(address indexed from, address indexed to, uint256 value);
210 
211     event Approval(address indexed owner, address indexed spender, uint256 value);
212 }
213 
214 
215 contract ERC20 is IERC20, Ownable {
216 
217     using SafeMath for uint256;
218 
219     mapping (address => uint256) private _balances;
220 
221     mapping (address => mapping (address => uint256)) private _allowances;
222 
223     uint256 private _totalSupply;
224 
225     event Issue(address indexed account, uint256 amount);
226 
227     event Redeem(address indexed account, uint256 value);
228 
229     function totalSupply() public view returns (uint256) {
230         return _totalSupply;
231     }
232 
233     function balanceOf(address account) public view returns (uint256) {
234         return _balances[account];
235     }
236 
237     function transfer(address recipient, uint256 amount) public returns (bool) {
238         _transfer(msg.sender, recipient, amount);
239         return true;
240     }
241 
242     function allowance(address owner, address spender) public view returns (uint256) {
243         return _allowances[owner][spender];
244     }
245 
246     function approve(address spender, uint256 value) public returns (bool) {
247         _approve(msg.sender, spender, value);
248         return true;
249     }
250 
251     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
252         _transfer(sender, recipient, amount);
253         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
254         return true;
255     }
256 
257     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
258         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
259         return true;
260     }
261 
262     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
263         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
264         return true;
265     }
266 
267     function _transfer(address sender, address recipient, uint256 amount) internal {
268         require(sender != address(0), "ERC20: transfer from the zero address");
269         require(recipient != address(0), "ERC20: transfer to the zero address");
270 
271         _balances[sender] = _balances[sender].sub(amount);
272         _balances[recipient] = _balances[recipient].add(amount);
273         emit Transfer(sender, recipient, amount);
274     }
275 
276     function _approve(address owner, address spender, uint256 value) internal {
277         require(owner != address(0), "ERC20: approve from the zero address");
278         require(spender != address(0), "ERC20: approve to the zero address");
279 
280         _allowances[owner][spender] = value;
281         emit Approval(owner, spender, value);
282     }
283 
284     function _issue(address account, uint256 amount) internal {
285         require(account != address(0), "CoinFactory: issue to the zero address");
286 
287         _totalSupply = _totalSupply.add(amount);
288         _balances[account] = _balances[account].add(amount);
289         emit Transfer(address(0), account, amount);
290         emit Issue(account, amount);
291     }
292 
293     function _redeem(address account, uint256 value) internal {
294         require(account != address(0), "CoinFactory: redeem from the zero address");
295 
296         _totalSupply = _totalSupply.sub(value);
297         _balances[account] = _balances[account].sub(value);
298         emit Transfer(account, address(0), value);
299         emit Redeem(account, value);
300     }
301 }
302 
303 
304 contract ERC20Pausable is ERC20, Pausable {
305 
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
318     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool) {
319         return super.increaseAllowance(spender, addedValue);
320     }
321 
322     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool) {
323         return super.decreaseAllowance(spender, subtractedValue);
324     }
325 }
326 
327 
328 contract CoinFactoryAdminRole is Ownable {
329 
330     using Roles for Roles.Role;
331 
332     event CoinFactoryAdminRoleAdded(address indexed account);
333 
334     event CoinFactoryAdminRoleRemoved(address indexed account);
335 
336     Roles.Role private _coinFactoryAdmins;
337 
338     constructor () internal {
339         _addCoinFactoryAdmin(msg.sender);
340     }
341 
342     modifier onlyCoinFactoryAdmin() {
343         require(isCoinFactoryAdmin(msg.sender), "CoinFactoryAdminRole: caller does not have the CoinFactoryAdmin role");
344         _;
345     }
346 
347     function isCoinFactoryAdmin(address account) public view returns (bool) {
348         return _coinFactoryAdmins.has(account);
349     }
350 
351     function addCoinFactoryAdmin(address account) public onlyOwner {
352         _addCoinFactoryAdmin(account);
353     }
354 
355     function removeCoinFactoryAdmin(address account) public onlyOwner {
356         _removeCoinFactoryAdmin(account);
357     }
358 
359     function renounceCoinFactoryAdmin() public {
360         _removeCoinFactoryAdmin(msg.sender);
361     }
362 
363     function _addCoinFactoryAdmin(address account) internal {
364         _coinFactoryAdmins.add(account);
365         emit CoinFactoryAdminRoleAdded(account);
366     }
367 
368     function _removeCoinFactoryAdmin(address account) internal {
369         _coinFactoryAdmins.remove(account);
370         emit CoinFactoryAdminRoleRemoved(account);
371     }
372 }
373 
374 
375 contract CoinFactory is ERC20, CoinFactoryAdminRole {
376 
377     function issue(address account, uint256 amount) public onlyCoinFactoryAdmin returns (bool) {
378         _issue(account, amount);
379         return true;
380     }
381 
382     function redeem(address account, uint256 amount) public onlyCoinFactoryAdmin returns (bool) {
383         _redeem(account, amount);
384         return true;
385     }
386 }
387 
388 
389 contract BlacklistAdminRole is Ownable {
390 
391     using Roles for Roles.Role;
392 
393     event BlacklistAdminAdded(address indexed account);
394     event BlacklistAdminRemoved(address indexed account);
395 
396     Roles.Role private _blacklistAdmins;
397 
398     constructor () internal {
399         _addBlacklistAdmin(msg.sender);
400     }
401 
402     modifier onlyBlacklistAdmin() {
403         require(isBlacklistAdmin(msg.sender), "BlacklistAdminRole: caller does not have the BlacklistAdmin role");
404         _;
405     }
406 
407     function isBlacklistAdmin(address account) public view returns (bool) {
408         return _blacklistAdmins.has(account);
409     }
410 
411     function addBlacklistAdmin(address account) public onlyOwner {
412         _addBlacklistAdmin(account);
413     }
414 
415     function removeBlacklistAdmin(address account) public onlyOwner {
416         _removeBlacklistAdmin(account);
417     }
418 
419     function renounceBlacklistAdmin() public {
420         _removeBlacklistAdmin(msg.sender);
421     }
422 
423     function _addBlacklistAdmin(address account) internal {
424         _blacklistAdmins.add(account);
425         emit BlacklistAdminAdded(account);
426     }
427 
428     function _removeBlacklistAdmin(address account) internal {
429         _blacklistAdmins.remove(account);
430         emit BlacklistAdminRemoved(account);
431     }
432 }
433 
434 
435 contract Blacklist is ERC20, BlacklistAdminRole {
436 
437     mapping (address => bool) private _blacklist;
438 
439     event BlacklistAdded(address indexed account);
440 
441     event BlacklistRemoved(address indexed account);
442 
443     function isBlacklist(address account) public view returns (bool) {
444         return _blacklist[account];
445     }
446 
447     function addBlacklist(address[] memory accounts) public onlyBlacklistAdmin returns (bool) {
448         for(uint i = 0; i < accounts.length; i++) {
449             _addBlacklist(accounts[i]);
450         }
451     }
452 
453     function removeBlacklist(address[] memory accounts) public onlyBlacklistAdmin returns (bool) {
454         for(uint i = 0; i < accounts.length; i++) {
455             _removeBlacklist(accounts[i]);
456         }
457     }
458 
459     function _addBlacklist(address account) internal {
460         _blacklist[account] = true;
461         emit BlacklistAdded(account);
462     }
463 
464     function _removeBlacklist(address account) internal {
465         _blacklist[account] = false;
466         emit BlacklistRemoved(account);
467     }
468 }
469 
470 contract DHToken is ERC20, ERC20Pausable, CoinFactory, Blacklist {
471 
472     string public name;
473     string public symbol;
474     uint8 public decimals;
475     uint256 private _totalSupply;
476 
477     constructor (string memory _name, string memory _symbol, uint8 _decimals) public {
478         _totalSupply = 0;
479         name = _name;
480         symbol = _symbol;
481         decimals = _decimals;
482     }
483 
484     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
485         require(!isBlacklist(msg.sender), "DHToken: caller in blacklist can't transfer");
486         require(!isBlacklist(to), "DHToken: not allow to transfer to recipient address in blacklist");
487         return super.transfer(to, value);
488     }
489 
490     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
491         require(!isBlacklist(msg.sender), "DHToken: caller in blacklist can't transferFrom");
492         require(!isBlacklist(from), "DHToken: from in blacklist can't transfer");
493         require(!isBlacklist(to), "DHToken: not allow to transfer to recipient address in blacklist");
494         return super.transferFrom(from, to, value);
495     }
496 }