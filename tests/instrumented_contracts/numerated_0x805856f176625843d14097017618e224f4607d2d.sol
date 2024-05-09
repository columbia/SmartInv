1 interface IERC20 {
2     function totalSupply() external view returns (uint256);
3     function balanceOf(address account) external view returns (uint256);
4     function transfer(address recipient, uint256 amount) external returns (bool);
5     function allowance(address owner, address spender) external view returns (uint256);
6     function approve(address spender, uint256 amount) external returns (bool);
7     function transferFrom(
8         address sender,
9         address recipient,
10         uint256 amount
11     ) external returns (bool);
12     event Transfer(address indexed from, address indexed to, uint256 value);
13     event Approval(address indexed owner, address indexed spender, uint256 value);
14 }
15 interface IERC20Metadata is IERC20 {
16     function name() external view returns (string memory);
17     function symbol() external view returns (string memory);
18     function decimals() external view returns (uint8);
19 }
20 abstract contract Context {
21     function _msgSender() internal view virtual returns (address) {
22         return msg.sender;
23     }
24     function _msgData() internal view virtual returns (bytes calldata) {
25         return msg.data;
26     }
27 }
28 contract ERC20 is Context, IERC20, IERC20Metadata {
29     mapping(address => uint256) private _balances;
30     mapping(address => mapping(address => uint256)) private _allowances;
31     uint256 private _totalSupply;
32     string private _name;
33     string private _symbol;
34     constructor(string memory name_, string memory symbol_) {
35         _name = name_;
36         _symbol = symbol_;
37     }
38     function name() public view virtual override returns (string memory) {
39         return _name;
40     }
41     function symbol() public view virtual override returns (string memory) {
42         return _symbol;
43     }
44     function decimals() public view virtual override returns (uint8) {
45         return 18;
46     }
47     function totalSupply() public view virtual override returns (uint256) {
48         return _totalSupply;
49     }
50     function balanceOf(address account) public view virtual override returns (uint256) {
51         return _balances[account];
52     }
53     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
54         _transfer(_msgSender(), recipient, amount);
55         return true;
56     }
57     function allowance(address owner, address spender) public view virtual override returns (uint256) {
58         return _allowances[owner][spender];
59     }
60     function approve(address spender, uint256 amount) public virtual override returns (bool) {
61         _approve(_msgSender(), spender, amount);
62         return true;
63     }
64     function transferFrom(
65         address sender,
66         address recipient,
67         uint256 amount
68     ) public virtual override returns (bool) {
69         _transfer(sender, recipient, amount);
70 
71         uint256 currentAllowance = _allowances[sender][_msgSender()];
72         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
73         unchecked {
74             _approve(sender, _msgSender(), currentAllowance - amount);
75         }
76 
77         return true;
78     }
79     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
80         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
81         return true;
82     }
83     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
84         uint256 currentAllowance = _allowances[_msgSender()][spender];
85         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
86         unchecked {
87             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
88         }
89 
90         return true;
91     }
92     function _transfer(
93         address sender,
94         address recipient,
95         uint256 amount
96     ) internal virtual {
97         require(sender != address(0), "ERC20: transfer from the zero address");
98         require(recipient != address(0), "ERC20: transfer to the zero address");
99 
100         _beforeTokenTransfer(sender, recipient, amount);
101 
102         uint256 senderBalance = _balances[sender];
103         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
104         unchecked {
105             _balances[sender] = senderBalance - amount;
106         }
107         _balances[recipient] += amount;
108 
109         emit Transfer(sender, recipient, amount);
110 
111         _afterTokenTransfer(sender, recipient, amount);
112     }
113     function _mint(address account, uint256 amount) internal virtual {
114         require(account != address(0), "ERC20: mint to the zero address");
115 
116         _beforeTokenTransfer(address(0), account, amount);
117 
118         _totalSupply += amount;
119         _balances[account] += amount;
120         emit Transfer(address(0), account, amount);
121 
122         _afterTokenTransfer(address(0), account, amount);
123     }
124     function _burn(address account, uint256 amount) internal virtual {
125         require(account != address(0), "ERC20: burn from the zero address");
126 
127         _beforeTokenTransfer(account, address(0), amount);
128 
129         uint256 accountBalance = _balances[account];
130         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
131         unchecked {
132             _balances[account] = accountBalance - amount;
133         }
134         _totalSupply -= amount;
135 
136         emit Transfer(account, address(0), amount);
137 
138         _afterTokenTransfer(account, address(0), amount);
139     }
140     function _approve(
141         address owner,
142         address spender,
143         uint256 amount
144     ) internal virtual {
145         require(owner != address(0), "ERC20: approve from the zero address");
146         require(spender != address(0), "ERC20: approve to the zero address");
147 
148         _allowances[owner][spender] = amount;
149         emit Approval(owner, spender, amount);
150     }
151     function _beforeTokenTransfer(
152         address from,
153         address to,
154         uint256 amount
155     ) internal virtual {}
156     function _afterTokenTransfer(
157         address from,
158         address to,
159         uint256 amount
160     ) internal virtual {}
161 }
162 abstract contract ERC20Burnable is Context, ERC20 {
163     function burn(uint256 amount) public virtual {
164         _burn(_msgSender(), amount);
165     }
166     function burnFrom(address account, uint256 amount) public virtual {
167         uint256 currentAllowance = allowance(account, _msgSender());
168         require(currentAllowance >= amount, "ERC20: burn amount exceeds allowance");
169         unchecked {
170             _approve(account, _msgSender(), currentAllowance - amount);
171         }
172         _burn(account, amount);
173     }
174 }
175 abstract contract Pausable is Context {
176     event Paused(address account);
177     event Unpaused(address account);
178     bool private _paused;
179     constructor() {
180         _paused = false;
181     }
182     function paused() public view virtual returns (bool) {
183         return _paused;
184     }
185     modifier whenNotPaused() {
186         require(!paused(), "Pausable: paused");
187         _;
188     }
189     modifier whenPaused() {
190         require(paused(), "Pausable: not paused");
191         _;
192     }
193     function _pause() internal virtual whenNotPaused {
194         _paused = true;
195         emit Paused(_msgSender());
196     }
197     function _unpause() internal virtual whenPaused {
198         _paused = false;
199         emit Unpaused(_msgSender());
200     }
201 }
202 interface IAccessControl {
203     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
204     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
205     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
206     function hasRole(bytes32 role, address account) external view returns (bool);
207     function getRoleAdmin(bytes32 role) external view returns (bytes32);
208     function grantRole(bytes32 role, address account) external;
209     function revokeRole(bytes32 role, address account) external;
210     function renounceRole(bytes32 role, address account) external;
211 }
212 library Strings {
213     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
214     function toString(uint256 value) internal pure returns (string memory) {
215         if (value == 0) {
216             return "0";
217         }
218         uint256 temp = value;
219         uint256 digits;
220         while (temp != 0) {
221             digits++;
222             temp /= 10;
223         }
224         bytes memory buffer = new bytes(digits);
225         while (value != 0) {
226             digits -= 1;
227             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
228             value /= 10;
229         }
230         return string(buffer);
231     }
232     function toHexString(uint256 value) internal pure returns (string memory) {
233         if (value == 0) {
234             return "0x00";
235         }
236         uint256 temp = value;
237         uint256 length = 0;
238         while (temp != 0) {
239             length++;
240             temp >>= 8;
241         }
242         return toHexString(value, length);
243     }
244     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
245         bytes memory buffer = new bytes(2 * length + 2);
246         buffer[0] = "0";
247         buffer[1] = "x";
248         for (uint256 i = 2 * length + 1; i > 1; --i) {
249             buffer[i] = _HEX_SYMBOLS[value & 0xf];
250             value >>= 4;
251         }
252         require(value == 0, "Strings: hex length insufficient");
253         return string(buffer);
254     }
255 }
256 interface IERC165 {
257     function supportsInterface(bytes4 interfaceId) external view returns (bool);
258 }
259 abstract contract ERC165 is IERC165 {
260     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
261         return interfaceId == type(IERC165).interfaceId;
262     }
263 }
264 abstract contract AccessControl is Context, IAccessControl, ERC165 {
265     struct RoleData {
266         mapping(address => bool) members;
267         bytes32 adminRole;
268     }
269     mapping(bytes32 => RoleData) private _roles;
270     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
271     modifier onlyRole(bytes32 role) {
272         _checkRole(role, _msgSender());
273         _;
274     }
275     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
276         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
277     }
278     function hasRole(bytes32 role, address account) public view override returns (bool) {
279         return _roles[role].members[account];
280     }
281     function _checkRole(bytes32 role, address account) internal view {
282         if (!hasRole(role, account)) {
283             revert(
284                 string(
285                     abi.encodePacked(
286                         "AccessControl: account ",
287                         Strings.toHexString(uint160(account), 20),
288                         " is missing role ",
289                         Strings.toHexString(uint256(role), 32)
290                     )
291                 )
292             );
293         }
294     }
295     function getRoleAdmin(bytes32 role) public view override returns (bytes32) {
296         return _roles[role].adminRole;
297     }
298     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
299         _grantRole(role, account);
300     }
301     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
302         _revokeRole(role, account);
303     }
304     function renounceRole(bytes32 role, address account) public virtual override {
305         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
306 
307         _revokeRole(role, account);
308     }
309     function _setupRole(bytes32 role, address account) internal virtual {
310         _grantRole(role, account);
311     }
312     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
313         bytes32 previousAdminRole = getRoleAdmin(role);
314         _roles[role].adminRole = adminRole;
315         emit RoleAdminChanged(role, previousAdminRole, adminRole);
316     }
317     function _grantRole(bytes32 role, address account) private {
318         if (!hasRole(role, account)) {
319             _roles[role].members[account] = true;
320             emit RoleGranted(role, account, _msgSender());
321         }
322     }
323     function _revokeRole(bytes32 role, address account) private {
324         if (hasRole(role, account)) {
325             _roles[role].members[account] = false;
326             emit RoleRevoked(role, account, _msgSender());
327         }
328     }
329 }
330 contract BES is ERC20Burnable, Pausable, AccessControl {
331     mapping(address => LockUp) private _lockup;
332     bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
333     event Jail(address indexed prisoner, uint256 until, uint256 amount);
334     event Unjail(address indexed prisoner);
335     struct LockUp {
336         uint256 until;
337         uint256 amount;
338     }
339     function jail(
340         address account,
341         uint256 until,
342         uint256 amount
343     ) public onlyRole(DEFAULT_ADMIN_ROLE) {
344         require(account != address(0), "Prison: zero address can't be in jail");
345 
346         _lockup[account] = LockUp({until: until, amount: amount});
347         emit Jail(account, until, amount);
348     }
349     function unjail(address account) public onlyRole(DEFAULT_ADMIN_ROLE) {
350         require(
351             account != address(0),
352             "Prison: zero address can't be released"
353         );
354 
355         _lockup[account] = LockUp({until: 0, amount: 0});
356         emit Unjail(account);
357     }
358     function isPrisoner(address account) public view returns (bool) {
359         return _lockup[account].until > block.timestamp;
360     }
361     function releaseTimeOf(address account) public view returns (uint256) {
362         if (!isPrisoner(account)) {
363             return 0;
364         }
365 
366         return _lockup[account].until;
367     }
368     function frozenBalanceOf(address account) public view returns (uint256) {
369         if (!isPrisoner(account)) {
370             return 0;
371         }
372 
373         return _lockup[account].amount;
374     }
375     function freeBalanceOf(address account) public view returns (uint256) {
376         uint256 _prisonerBalance = balanceOf(account);
377         uint256 _frozenBalance = frozenBalanceOf(account);
378         if (_frozenBalance > _prisonerBalance) {
379             return 0;
380         }
381         return _prisonerBalance - _frozenBalance;
382     }
383     constructor(
384         string memory name,
385         string memory symbol,
386         uint256 maxSupply
387     ) ERC20(name, symbol) {
388         _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
389         _setupRole(PAUSER_ROLE, msg.sender);
390 
391         _mint(msg.sender, maxSupply);
392     }
393     function pause() public onlyRole(PAUSER_ROLE) {
394         _pause();
395     }
396     function unpause() public onlyRole(PAUSER_ROLE) {
397         _unpause();
398     }
399     function airdropMultiWithLocks(
400         address[] memory to,
401         uint256[] memory amount,
402         uint256[] memory until
403     ) public onlyRole(DEFAULT_ADMIN_ROLE) {
404         require(
405             to.length == amount.length && amount.length == until.length,
406             "Airdrop: arguments must have same length"
407         );
408         for (uint256 i = 0; i < to.length; i++) {
409             _transfer(msg.sender, to[i], amount[i]);
410             jail(to[i], until[i], frozenBalanceOf(to[i]) + amount[i]);
411         }
412     }
413     function airdropMultiWithLock(
414         address[] memory to,
415         uint256[] memory amount,
416         uint256 until
417     ) public onlyRole(DEFAULT_ADMIN_ROLE) {
418         require(
419             to.length == amount.length,
420             "Airdrop: arguments must have same length"
421         );
422         for (uint256 i = 0; i < to.length; i++) {
423             _transfer(msg.sender, to[i], amount[i]);
424             jail(to[i], until, frozenBalanceOf(to[i]) + amount[i]);
425         }
426     }
427     function airdropMulti(address[] memory to, uint256[] memory amount) public {
428         require(
429             to.length == amount.length,
430             "Airdrop: arguments must have same length"
431         );
432         for (uint256 i = 0; i < to.length; i++) {
433             _transfer(msg.sender, to[i], amount[i]);
434         }
435     }
436     function airdropWithLock(
437         address[] memory to,
438         uint256 amount,
439         uint256 until
440     ) public onlyRole(DEFAULT_ADMIN_ROLE) {
441         for (uint256 i = 0; i < to.length; i++) {
442             _transfer(msg.sender, to[i], amount);
443             jail(to[i], until, frozenBalanceOf(to[i]) + amount);
444         }
445     }
446     function airdrop(address[] memory to, uint256 amount) public {
447         for (uint256 i = 0; i < to.length; i++) {
448             _transfer(msg.sender, to[i], amount);
449         }
450     }
451     function transferFrozen(address recipient, uint256 amount)
452         public
453         onlyRole(DEFAULT_ADMIN_ROLE)
454         returns (bool)
455     {
456         uint256 frozenBalance = frozenBalanceOf(msg.sender);
457         require(
458             frozenBalance >= amount,
459             "Prison: amount exceeds frozen balance"
460         );
461         uint256 releaseTime = releaseTimeOf(msg.sender);
462         jail(msg.sender, releaseTime, frozenBalance - amount);
463         jail(recipient, releaseTime, frozenBalanceOf(recipient) + amount);
464         _transfer(msg.sender, recipient, amount);
465         return true;
466     }
467     function transferWithLock(
468         address recipient,
469         uint256 amount,
470         uint256 until
471     ) public onlyRole(DEFAULT_ADMIN_ROLE) returns (bool) {
472         _transfer(msg.sender, recipient, amount);
473         jail(recipient, until, frozenBalanceOf(recipient) + amount);
474         return true;
475     }
476     function _beforeTokenTransfer(
477         address from,
478         address to,
479         uint256 amount
480     ) internal override whenNotPaused {
481         require(
482             !isPrisoner(from) || freeBalanceOf(from) >= amount,
483             "Prison: amount exceeds free balance"
484         );
485         super._beforeTokenTransfer(from, to, amount);
486     }
487 }