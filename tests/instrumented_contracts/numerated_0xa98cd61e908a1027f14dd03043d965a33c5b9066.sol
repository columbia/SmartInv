1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.4;
3 
4 interface IERC20 {
5     function totalSupply() external view returns (uint256);
6     function balanceOf(address account) external view returns (uint256);
7     function transfer(address to, uint256 amount) external returns (bool);
8     function allowance(address owner, address spender) external view returns (uint256);
9     function approve(address spender, uint256 amount) external returns (bool);
10     function transferFrom(
11         address from,
12         address to,
13         uint256 amount
14     ) external returns (bool);
15 
16     event Transfer(address indexed from, address indexed to, uint256 value);
17     event Approval(address indexed owner, address indexed spender, uint256 value);
18 }
19 
20 abstract contract Context {
21     function _msgSender() internal view virtual returns (address) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal view virtual returns (bytes calldata) {
26         return msg.data;
27     }
28 }
29 
30 contract ERC20 is Context, IERC20 {
31     mapping(address => uint256) private _balances;
32 
33     mapping(address => mapping(address => uint256)) private _allowances;
34 
35     uint256 private _totalSupply;
36 
37     string private _name;
38     string private _symbol;
39 
40     constructor(string memory name_, string memory symbol_) {
41         _name = name_;
42         _symbol = symbol_;
43     }
44 
45     function name() public view virtual returns (string memory) {
46         return _name;
47     }
48 
49     function symbol() public view virtual returns (string memory) {
50         return _symbol;
51     }
52 
53     function decimals() public view virtual returns (uint8) {
54         return 18;
55     }
56 
57     function totalSupply() public view virtual override returns (uint256) {
58         return _totalSupply;
59     }
60 
61     function balanceOf(address account) public view virtual override returns (uint256) {
62         return _balances[account];
63     }
64 
65     function transfer(address to, uint256 amount) public virtual override returns (bool) {
66         address owner = _msgSender();
67         _transfer(owner, to, amount);
68         return true;
69     }
70 
71     function allowance(address owner, address spender) public view virtual override returns (uint256) {
72         return _allowances[owner][spender];
73     }
74 
75     function approve(address spender, uint256 amount) public virtual override returns (bool) {
76         address owner = _msgSender();
77         _approve(owner, spender, amount);
78         return true;
79     }
80 
81     function transferFrom(
82         address from,
83         address to,
84         uint256 amount
85     ) public virtual override returns (bool) {
86         address spender = _msgSender();
87         _spendAllowance(from, spender, amount);
88         _transfer(from, to, amount);
89         return true;
90     }
91 
92     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
93         address owner = _msgSender();
94         _approve(owner, spender, _allowances[owner][spender] + addedValue);
95         return true;
96     }
97 
98     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
99         address owner = _msgSender();
100         uint256 currentAllowance = _allowances[owner][spender];
101         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
102         unchecked {
103             _approve(owner, spender, currentAllowance - subtractedValue);
104         }
105 
106         return true;
107     }
108 
109     function _transfer(
110         address from,
111         address to,
112         uint256 amount
113     ) internal virtual {
114         require(from != address(0), "ERC20: transfer from the zero address");
115         require(to != address(0), "ERC20: transfer to the zero address");
116 
117         _beforeTokenTransfer(from, to, amount);
118 
119         uint256 fromBalance = _balances[from];
120         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
121         unchecked {
122             _balances[from] = fromBalance - amount;
123         }
124         _balances[to] += amount;
125 
126         emit Transfer(from, to, amount);
127 
128         _afterTokenTransfer(from, to, amount);
129     }
130 
131     function _mint(address account, uint256 amount) internal virtual {
132         require(account != address(0), "ERC20: mint to the zero address");
133 
134         _beforeTokenTransfer(address(0), account, amount);
135 
136         _totalSupply += amount;
137         _balances[account] += amount;
138         emit Transfer(address(0), account, amount);
139 
140         _afterTokenTransfer(address(0), account, amount);
141     }
142 
143     function _burn(address account, uint256 amount) internal virtual {
144         require(account != address(0), "ERC20: burn from the zero address");
145 
146         _beforeTokenTransfer(account, address(0), amount);
147 
148         uint256 accountBalance = _balances[account];
149         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
150         unchecked {
151             _balances[account] = accountBalance - amount;
152         }
153         _totalSupply -= amount;
154 
155         emit Transfer(account, address(0), amount);
156 
157         _afterTokenTransfer(account, address(0), amount);
158     }
159 
160     function _approve(
161         address owner,
162         address spender,
163         uint256 amount
164     ) internal virtual {
165         require(owner != address(0), "ERC20: approve from the zero address");
166         require(spender != address(0), "ERC20: approve to the zero address");
167 
168         _allowances[owner][spender] = amount;
169         emit Approval(owner, spender, amount);
170     }
171 
172     function _spendAllowance(
173         address owner,
174         address spender,
175         uint256 amount
176     ) internal virtual {
177         uint256 currentAllowance = allowance(owner, spender);
178         if (currentAllowance != type(uint256).max) {
179             require(currentAllowance >= amount, "ERC20: insufficient allowance");
180             unchecked {
181                 _approve(owner, spender, currentAllowance - amount);
182             }
183         }
184     }
185 
186     function _beforeTokenTransfer(
187         address from,
188         address to,
189         uint256 amount
190     ) internal virtual {}
191 
192     function _afterTokenTransfer(
193         address from,
194         address to,
195         uint256 amount
196     ) internal virtual {}
197 }
198 
199 abstract contract ERC20Burnable is Context, ERC20 {
200 
201     function burn(uint256 amount) public virtual {
202         _burn(_msgSender(), amount);
203     }
204 
205     function burnFrom(address account, uint256 amount) public virtual {
206         _spendAllowance(account, _msgSender(), amount);
207         _burn(account, amount);
208     }
209 }
210 
211 abstract contract Pausable is Context {
212 
213     event Paused(address account);
214 
215     event Unpaused(address account);
216 
217     bool private _paused;
218 
219     constructor() {
220         _paused = false;
221     }
222 
223     function paused() public view virtual returns (bool) {
224         return _paused;
225     }
226 
227     modifier whenNotPaused() {
228         require(!paused(), "Pausable: paused");
229         _;
230     }
231 
232     modifier whenPaused() {
233         require(paused(), "Pausable: not paused");
234         _;
235     }
236 
237     function _pause() internal virtual whenNotPaused {
238         _paused = true;
239         emit Paused(_msgSender());
240     }
241 
242     function _unpause() internal virtual whenPaused {
243         _paused = false;
244         emit Unpaused(_msgSender());
245     }
246 }
247 
248 
249 interface IAccessControl {
250 
251     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
252     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
253     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
254     function hasRole(bytes32 role, address account) external view returns (bool);
255     function getRoleAdmin(bytes32 role) external view returns (bytes32);
256     function grantRole(bytes32 role, address account) external;
257     function revokeRole(bytes32 role, address account) external;
258     function renounceRole(bytes32 role, address account) external;
259 }
260 
261 library Strings {
262     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
263 
264     function toString(uint256 value) internal pure returns (string memory) {
265         // Inspired by OraclizeAPI's implementation - MIT licence
266 
267         if (value == 0) {
268             return "0";
269         }
270         uint256 temp = value;
271         uint256 digits;
272         while (temp != 0) {
273             digits++;
274             temp /= 10;
275         }
276         bytes memory buffer = new bytes(digits);
277         while (value != 0) {
278             digits -= 1;
279             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
280             value /= 10;
281         }
282         return string(buffer);
283     }
284 
285     function toHexString(uint256 value) internal pure returns (string memory) {
286         if (value == 0) {
287             return "0x00";
288         }
289         uint256 temp = value;
290         uint256 length = 0;
291         while (temp != 0) {
292             length++;
293             temp >>= 8;
294         }
295         return toHexString(value, length);
296     }
297 
298     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
299         bytes memory buffer = new bytes(2 * length + 2);
300         buffer[0] = "0";
301         buffer[1] = "x";
302         for (uint256 i = 2 * length + 1; i > 1; --i) {
303             buffer[i] = _HEX_SYMBOLS[value & 0xf];
304             value >>= 4;
305         }
306         require(value == 0, "Strings: hex length insufficient");
307         return string(buffer);
308     }
309 }
310 
311 
312 interface IERC165 {
313     function supportsInterface(bytes4 interfaceId) external view returns (bool);
314 }
315 
316 abstract contract ERC165 is IERC165 {
317     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
318         return interfaceId == type(IERC165).interfaceId;
319     }
320 }
321 
322 abstract contract AccessControl is Context, IAccessControl, ERC165 {
323     struct RoleData {
324         mapping(address => bool) members;
325         bytes32 adminRole;
326     }
327 
328     mapping(bytes32 => RoleData) private _roles;
329 
330     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
331 
332     modifier onlyRole(bytes32 role) {
333         _checkRole(role, _msgSender());
334         _;
335     }
336 
337     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
338         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
339     }
340 
341     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
342         return _roles[role].members[account];
343     }
344 
345     function _checkRole(bytes32 role, address account) internal view virtual {
346         if (!hasRole(role, account)) {
347             revert(
348                 string(
349                     abi.encodePacked(
350                         "AccessControl: account ",
351                         Strings.toHexString(uint160(account), 20),
352                         " is missing role ",
353                         Strings.toHexString(uint256(role), 32)
354                     )
355                 )
356             );
357         }
358     }
359 
360     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
361         return _roles[role].adminRole;
362     }
363 
364     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
365         _grantRole(role, account);
366     }
367 
368     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
369         _revokeRole(role, account);
370     }
371 
372     function renounceRole(bytes32 role, address account) public virtual override {
373         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
374 
375         _revokeRole(role, account);
376     }
377 
378     function _setupRole(bytes32 role, address account) internal virtual {
379         _grantRole(role, account);
380     }
381 
382     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
383         bytes32 previousAdminRole = getRoleAdmin(role);
384         _roles[role].adminRole = adminRole;
385         emit RoleAdminChanged(role, previousAdminRole, adminRole);
386     }
387 
388     function _grantRole(bytes32 role, address account) internal virtual {
389         if (!hasRole(role, account)) {
390             _roles[role].members[account] = true;
391             emit RoleGranted(role, account, _msgSender());
392         }
393     }
394 
395     function _revokeRole(bytes32 role, address account) internal virtual {
396         if (hasRole(role, account)) {
397             _roles[role].members[account] = false;
398             emit RoleRevoked(role, account, _msgSender());
399         }
400     }
401 }
402 
403 contract NetonToken is ERC20, Pausable, ERC20Burnable, AccessControl {
404 
405     // Roles
406     bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE"); 
407     bytes32 public constant LOCKER_ROLE = keccak256("LOCKER_ROLE"); 
408 
409     // lock
410     mapping (address => uint256) private _lockBalance;
411 
412     // Declare an Event
413     event SetLock(address indexed _account, uint256 _amount);
414     event UnLock(address indexed _account, uint256 _amount);
415 
416     // init
417     constructor(address pauser, address locker) ERC20("NETON", "NTO") {
418        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
419        _setupRole(PAUSER_ROLE, pauser);
420        _setupRole(LOCKER_ROLE, locker);
421 
422        _mint(msg.sender, 2000000000 * 10 ** decimals());
423     }
424 
425     function getAccountLock(address account) public view returns (uint256) {
426         return _lockBalance[account];
427     }
428 
429     function setLock(address account, uint256 amount) onlyRole(LOCKER_ROLE) public returns (bool) {
430 
431         require((balanceOf(account) - getAccountLock(account)) >= amount, "ERC20: lock amount is exceeded");
432 
433         _lockBalance[account] += amount; 
434 
435         emit SetLock(account, amount);
436         return true;
437     }
438 
439     function multiLock(address[] memory accounts, uint256[] memory amounts) onlyRole(LOCKER_ROLE) public returns (bool) {
440 
441         require(accounts.length == amounts.length, "ERC20: lengths of two arrays are not equal");
442 
443         for(uint i = 0; i < accounts.length; i++) {
444             setLock(accounts[i], amounts[i]);
445         }
446         return true;
447     }
448 
449     function unlock(address account, uint256 amount) onlyRole(LOCKER_ROLE) public returns (bool) {
450 
451         require(getAccountLock(account) >= amount, "ERC20: unlock amount is exceeded.");
452 
453         _lockBalance[account] -= amount;
454         emit UnLock(account, amount);
455         return true;
456     }
457 
458     function pause() public onlyRole(PAUSER_ROLE) {
459         _pause();
460     }
461 
462     function unpause() public onlyRole(PAUSER_ROLE) {
463         _unpause();
464     }
465 
466     function _beforeTokenTransfer(address from, address to, uint256 amount)
467         internal
468         whenNotPaused
469         override
470     {
471         super._beforeTokenTransfer(from, to, amount);
472     }
473 
474     function multiTransfer(address[] memory accounts, uint256[] memory amounts) public returns (bool) {
475 
476         require(accounts.length == amounts.length, "ERC20: lengths of two arrays are not equal");
477 
478         for(uint i = 0; i < accounts.length; i++) {
479             _transfer(msg.sender, accounts[i], amounts[i]);
480         }
481         return true;
482     }
483 
484     function _transfer(address sender, address recipient, uint256 amount) internal override {
485 
486         require((balanceOf(sender) - getAccountLock(sender)) >= amount, "ERC20: transfer amount exceeds balance");
487 	    return super._transfer(sender, recipient, amount);
488 	}
489 }