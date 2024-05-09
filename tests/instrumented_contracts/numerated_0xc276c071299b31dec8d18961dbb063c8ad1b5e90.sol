1 /**
2  *  Hybrid Bank Stable Coin HBUSD
3 */
4 
5 pragma solidity 0.5.17;
6 
7 library SafeMath {
8 
9     function add(uint256 a, uint256 b) internal pure returns (uint256) {
10         uint256 c = a + b;
11         require(c >= a, "SafeMath: addition overflow");
12 
13         return c;
14     }
15 
16     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
17 	    return sub(a, b, "SafeMath: subtraction overflow");
18     }
19 
20     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
21 	    require(b <= a, errorMessage);
22 	    uint256 c = a - b;
23 
24 	    return c;
25     }
26 }
27 
28 contract Ownable {
29 
30     address private _owner;
31 
32     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
33 
34     constructor () internal {
35         _owner = msg.sender;
36         emit OwnershipTransferred(address(0), _owner);
37     }
38 
39     function owner() public view returns (address) {
40         return _owner;
41     }
42 
43     modifier onlyOwner() {
44         require(msg.sender == _owner, "Caller is not owner");
45         _;
46     }
47 
48     function transferOwnership(address newOwner) public onlyOwner {
49         require(newOwner != address(0), "new owner is the zero address");
50         emit OwnershipTransferred(_owner, newOwner);
51         _owner = newOwner;
52     }
53 }
54 
55 library Roles {
56 
57     struct Role {
58         mapping (address => bool) bearer;
59     }
60 
61     function add(Role storage role, address account) internal {
62         require(!has(role, account), "Roles: account already has role");
63         role.bearer[account] = true;
64     }
65 
66     function remove(Role storage role, address account) internal {
67         require(has(role, account), "Roles: account does not have role");
68         role.bearer[account] = false;
69     }
70 
71     function has(Role storage role, address account) internal view returns (bool) {
72         require(account != address(0), "Roles: account is the zero address");
73         return role.bearer[account];
74     }
75 }
76 
77 contract PauserRole is Ownable {
78 
79     using Roles for Roles.Role;
80 
81     event PauserAdded(address indexed account);
82 
83     event PauserRemoved(address indexed account);
84 
85     Roles.Role private _pausers;
86 
87     constructor () internal {
88         _addPauser(msg.sender);
89     }
90 
91     modifier onlyPauser() {
92         require(isPauser(msg.sender), "caller does not have the Pauser role");
93         _;
94     }
95 
96     function isPauser(address account) public view returns (bool) {
97         return _pausers.has(account);
98     }
99 
100     function addPauser(address account) public onlyOwner {
101         _addPauser(account);
102     }
103 
104     function removePauser(address account) public onlyOwner {
105         _removePauser(account);
106     }
107 
108     function renouncePauser() public {
109         _removePauser(msg.sender);
110     }
111 
112     function _addPauser(address account) internal {
113         _pausers.add(account);
114         emit PauserAdded(account);
115     }
116 
117     function _removePauser(address account) internal {
118         _pausers.remove(account);
119         emit PauserRemoved(account);
120     }
121 }
122 
123 contract Pausable is PauserRole {
124 
125     event Paused(address account);
126 
127     event Unpaused(address account);
128 
129     bool private _paused;
130 
131     constructor () internal {
132         _paused = false;
133     }
134 
135     function paused() public view returns (bool) {
136         return _paused;
137     }
138 
139     modifier whenNotPaused() {
140         require(!_paused, "Pausable: paused");
141         _;
142     }
143 
144     modifier whenPaused() {
145         require(_paused, "Pausable: not paused");
146         _;
147     }
148 
149     function pause() public onlyPauser whenNotPaused {
150         _paused = true;
151         emit Paused(msg.sender);
152     }
153 
154     function unpause() public onlyPauser whenPaused {
155         _paused = false;
156         emit Unpaused(msg.sender);
157     }
158 }
159 
160 interface IERC20 {
161 
162     function totalSupply() external view returns (uint256);
163 
164     function balanceOf(address account) external view returns (uint256);
165 
166     function transfer(address recipient, uint256 amount) external returns (bool);
167 
168     function allowance(address owner, address spender) external view returns (uint256);
169 
170     function approve(address spender, uint256 amount) external returns (bool);
171 
172     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
173 
174     event Transfer(address indexed from, address indexed to, uint256 value);
175 
176     event Approval(address indexed owner, address indexed spender, uint256 value);
177 }
178 
179 contract ERC20 is IERC20, Ownable {
180 
181     using SafeMath for uint256;
182 
183     mapping (address => uint256) private _balances;
184 
185     mapping (address => mapping (address => uint256)) private _allowances;
186 
187     uint256 private _totalSupply;
188 
189     event Issue(address indexed account, uint256 amount);
190 
191     event Redeem(address indexed account, uint256 value);
192 
193     function totalSupply() public view returns (uint256) {
194         return _totalSupply;
195     }
196 
197     function balanceOf(address account) public view returns (uint256) {
198         return _balances[account];
199     }
200 
201     function transfer(address recipient, uint256 amount) public returns (bool) {
202         _transfer(msg.sender, recipient, amount);
203         return true;
204     }
205 
206     function allowance(address owner, address spender) public view returns (uint256) {
207         return _allowances[owner][spender];
208     }
209 
210     function approve(address spender, uint256 value) public returns (bool) {
211         _approve(msg.sender, spender, value);
212         return true;
213     }
214 
215     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
216         _transfer(sender, recipient, amount);
217         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
218         return true;
219     }
220 
221     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
222         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
223         return true;
224     }
225 
226     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
227         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
228         return true;
229     }
230 
231     function _transfer(address sender, address recipient, uint256 amount) internal {
232         require(sender != address(0), "ERC20: transfer from the zero address");
233         require(recipient != address(0), "ERC20: transfer to the zero address");
234 
235         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
236         _balances[recipient] = _balances[recipient].add(amount);
237         emit Transfer(sender, recipient, amount);
238     }
239 
240     function _approve(address owner, address spender, uint256 value) internal {
241         require(owner != address(0), "ERC20: approve from the zero address");
242         require(spender != address(0), "ERC20: approve to the zero address");
243 
244         _allowances[owner][spender] = value;
245         emit Approval(owner, spender, value);
246     }
247 
248     function _issue(address account, uint256 amount) internal {
249         require(account != address(0), "CoinFactory: issue to the zero address");
250 
251         _totalSupply = _totalSupply.add(amount);
252         _balances[account] = _balances[account].add(amount);
253         emit Transfer(address(0), account, amount);
254         emit Issue(account, amount);
255     }
256 
257     function _redeem(address account, uint256 value) internal {
258         require(account != address(0), "CoinFactory: redeem from the zero address");
259 
260         _balances[account] = _balances[account].sub(value, "ERC20: burn amount exceeds balance");
261         _totalSupply = _totalSupply.sub(value);
262         emit Transfer(account, address(0), value);
263         emit Redeem(account, value);
264     }
265 }
266 
267 contract ERC20Pausable is ERC20, Pausable {
268 
269     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
270         return super.transfer(to, value);
271     }
272 
273     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
274         return super.transferFrom(from, to, value);
275     }
276 
277     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
278         return super.approve(spender, value);
279     }
280 
281     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool) {
282         return super.increaseAllowance(spender, addedValue);
283     }
284 
285     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool) {
286         return super.decreaseAllowance(spender, subtractedValue);
287     }
288 }
289 
290 contract CoinFactoryAdminRole is Ownable {
291 
292     using Roles for Roles.Role;
293 
294     event CoinFactoryAdminRoleAdded(address indexed account);
295 
296     event CoinFactoryAdminRoleRemoved(address indexed account);
297 
298     Roles.Role private _coinFactoryAdmins;
299 
300     constructor () internal {
301         _addCoinFactoryAdmin(msg.sender);
302     }
303 
304     modifier onlyCoinFactoryAdmin() {
305         require(isCoinFactoryAdmin(msg.sender), "CoinFactoryAdminRole: caller does not have the CoinFactoryAdmin role");
306         _;
307     }
308 
309     function isCoinFactoryAdmin(address account) public view returns (bool) {
310         return _coinFactoryAdmins.has(account);
311     }
312 
313     function addCoinFactoryAdmin(address account) public onlyOwner {
314         _addCoinFactoryAdmin(account);
315     }
316 
317     function removeCoinFactoryAdmin(address account) public onlyOwner {
318         _removeCoinFactoryAdmin(account);
319     }
320 
321     function renounceCoinFactoryAdmin() public {
322         _removeCoinFactoryAdmin(msg.sender);
323     }
324 
325     function _addCoinFactoryAdmin(address account) internal {
326         _coinFactoryAdmins.add(account);
327         emit CoinFactoryAdminRoleAdded(account);
328     }
329 
330     function _removeCoinFactoryAdmin(address account) internal {
331         _coinFactoryAdmins.remove(account);
332         emit CoinFactoryAdminRoleRemoved(account);
333     }
334 }
335 
336 contract CoinFactory is ERC20, CoinFactoryAdminRole {
337 
338     function issue(address account, uint256 amount) public onlyCoinFactoryAdmin returns (bool) {
339         _issue(account, amount);
340         return true;
341     }
342 
343     function redeem(address account, uint256 amount) public onlyCoinFactoryAdmin returns (bool) {
344         _redeem(account, amount);
345         return true;
346     }
347 }
348 
349 contract BlacklistAdminRole is Ownable {
350 
351     using Roles for Roles.Role;
352 
353     event BlacklistAdminAdded(address indexed account);
354     event BlacklistAdminRemoved(address indexed account);
355 
356     Roles.Role private _blacklistAdmins;
357 
358     constructor () internal {
359         _addBlacklistAdmin(msg.sender);
360     }
361 
362     modifier onlyBlacklistAdmin() {
363         require(isBlacklistAdmin(msg.sender), "BlacklistAdminRole: caller does not have the BlacklistAdmin role");
364         _;
365     }
366 
367     function isBlacklistAdmin(address account) public view returns (bool) {
368         return _blacklistAdmins.has(account);
369     }
370 
371     function addBlacklistAdmin(address account) public onlyOwner {
372         _addBlacklistAdmin(account);
373     }
374 
375     function removeBlacklistAdmin(address account) public onlyOwner {
376         _removeBlacklistAdmin(account);
377     }
378 
379     function renounceBlacklistAdmin() public {
380         _removeBlacklistAdmin(msg.sender);
381     }
382 
383     function _addBlacklistAdmin(address account) internal {
384         _blacklistAdmins.add(account);
385         emit BlacklistAdminAdded(account);
386     }
387 
388     function _removeBlacklistAdmin(address account) internal {
389         _blacklistAdmins.remove(account);
390         emit BlacklistAdminRemoved(account);
391     }
392 }
393 
394 contract Blacklisted is ERC20, BlacklistAdminRole {
395 
396     mapping (address => bool) public _blacklisted;
397 
398     event BlacklistAdded(address indexed account);
399 
400     event BlacklistRemoved(address indexed account);
401 
402     function isBlacklisted(address account) public view returns (bool) {
403         return _blacklisted[account];
404     }
405 
406     function _addBlacklist(address account) internal {
407         _blacklisted[account] = true;
408         emit BlacklistAdded(account);
409     }
410 
411     function _removeBlacklist(address account) internal {
412         _blacklisted[account] = false;
413         emit BlacklistRemoved(account);
414     }
415 }
416 
417 contract HBUSDToken is ERC20, ERC20Pausable, CoinFactory, Blacklisted {
418 
419     string public name;
420     string public symbol;
421     uint256 public decimals;
422     uint256 private _totalSupply;
423 
424     constructor (string memory _name, string memory _symbol, uint8 _decimals) public {
425         _totalSupply = 0;
426         name = _name;
427         symbol = _symbol;
428         decimals = _decimals;
429     }
430 
431     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
432         require(!isBlacklisted(msg.sender), "caller in blacklist, no permission to transfer");
433         require(!isBlacklisted(to), "transfer to blacklist address not permitted");
434         return super.transfer(to, value);
435     }
436 
437     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
438         require(!isBlacklisted(msg.sender), "caller in blacklist, no permission to transferFrom");
439         require(!isBlacklisted(from), "from address in blacklist");
440         require(!isBlacklisted(to), "recipient address in blacklist");
441         return super.transferFrom(from, to, value);
442     }
443 }