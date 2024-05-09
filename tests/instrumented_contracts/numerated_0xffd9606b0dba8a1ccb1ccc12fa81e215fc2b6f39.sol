1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.6.2;
3 
4 library EnumerableSet {
5     struct Set {
6         bytes32[] _values;
7         mapping (bytes32 => uint256) _indexes;
8     }
9 
10     function _add(Set storage set, bytes32 value) private returns (bool) {
11         if (!_contains(set, value)) {
12             set._values.push(value);
13             set._indexes[value] = set._values.length;
14             return true;
15         } else {
16             return false;
17         }
18     }
19 
20     function _remove(Set storage set, bytes32 value) private returns (bool) {
21         uint256 valueIndex = set._indexes[value];
22 
23         if (valueIndex != 0) {
24             uint256 toDeleteIndex = valueIndex - 1;
25             uint256 lastIndex = set._values.length - 1;
26 
27             bytes32 lastvalue = set._values[lastIndex];
28 
29             set._values[toDeleteIndex] = lastvalue;
30             set._indexes[lastvalue] = toDeleteIndex + 1;
31             set._values.pop();
32 
33             delete set._indexes[value];
34 
35             return true;
36         } else {
37             return false;
38         }
39     }
40 
41     function _contains(Set storage set, bytes32 value) private view returns (bool) {
42         return set._indexes[value] != 0;
43     }
44 
45     function _length(Set storage set) private view returns (uint256) {
46         return set._values.length;
47     }
48 
49     function _at(Set storage set, uint256 index) private view returns (bytes32) {
50         require(set._values.length > index, "EnumerableSet: index out of bounds");
51         return set._values[index];
52     }
53 
54     struct AddressSet {
55         Set _inner;
56     }
57 
58     function add(AddressSet storage set, address value) internal returns (bool) {
59         return _add(set._inner, bytes32(uint256(value)));
60     }
61 
62     function remove(AddressSet storage set, address value) internal returns (bool) {
63         return _remove(set._inner, bytes32(uint256(value)));
64     }
65 
66     function contains(AddressSet storage set, address value) internal view returns (bool) {
67         return _contains(set._inner, bytes32(uint256(value)));
68     }
69 
70     function length(AddressSet storage set) internal view returns (uint256) {
71         return _length(set._inner);
72     }
73 
74     function at(AddressSet storage set, uint256 index) internal view returns (address) {
75         return address(uint256(_at(set._inner, index)));
76     }
77 
78     struct UintSet {
79         Set _inner;
80     }
81 
82     function add(UintSet storage set, uint256 value) internal returns (bool) {
83         return _add(set._inner, bytes32(value));
84     }
85 
86     function remove(UintSet storage set, uint256 value) internal returns (bool) {
87         return _remove(set._inner, bytes32(value));
88     }
89 
90     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
91         return _contains(set._inner, bytes32(value));
92     }
93 
94     function length(UintSet storage set) internal view returns (uint256) {
95         return _length(set._inner);
96     }
97 
98     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
99         return uint256(_at(set._inner, index));
100     }
101 }
102 
103 library Address {
104     function isContract(address account) internal view returns (bool) {
105         uint256 size;
106         assembly { size := extcodesize(account) }
107         return size > 0;
108     }
109 
110     function sendValue(address payable recipient, uint256 amount) internal {
111         require(address(this).balance >= amount, "Address: insufficient balance");
112 
113         (bool success, ) = recipient.call{ value: amount }("");
114         require(success, "Address: unable to send value, recipient may have reverted");
115     }
116 
117     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
118       return functionCall(target, data, "Address: low-level call failed");
119     }
120 
121     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
122         return _functionCallWithValue(target, data, 0, errorMessage);
123     }
124 
125     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
126         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
127     }
128 
129     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
130         require(address(this).balance >= value, "Address: insufficient balance for call");
131         return _functionCallWithValue(target, data, value, errorMessage);
132     }
133 
134     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
135         require(isContract(target), "Address: call to non-contract");
136 
137         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
138         if (success) {
139             return returndata;
140         } else {
141             if (returndata.length > 0) {
142                 assembly {
143                     let returndata_size := mload(returndata)
144                     revert(add(32, returndata), returndata_size)
145                 }
146             } else {
147                 revert(errorMessage);
148             }
149         }
150     }
151 }
152 
153 abstract contract Context {
154     function _msgSender() internal view virtual returns (address payable) {
155         return msg.sender;
156     }
157 
158     function _msgData() internal view virtual returns (bytes memory) {
159         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
160         return msg.data;
161     }
162 }
163 
164 abstract contract AccessControl is Context {
165     using EnumerableSet for EnumerableSet.AddressSet;
166     using Address for address;
167 
168     struct RoleData {
169         EnumerableSet.AddressSet members;
170         bytes32 adminRole;
171     }
172 
173     mapping (bytes32 => RoleData) private _roles;
174 
175     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
176 
177     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
178     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
179     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
180 
181     function hasRole(bytes32 role, address account) public view returns (bool) {
182         return _roles[role].members.contains(account);
183     }
184 
185     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
186         return _roles[role].members.length();
187     }
188 
189     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
190         return _roles[role].members.at(index);
191     }
192 
193     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
194         return _roles[role].adminRole;
195     }
196 
197     function grantRole(bytes32 role, address account) public virtual {
198         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
199 
200         _grantRole(role, account);
201     }
202 
203     function revokeRole(bytes32 role, address account) public virtual {
204         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
205 
206         _revokeRole(role, account);
207     }
208 
209     function renounceRole(bytes32 role, address account) public virtual {
210         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
211 
212         _revokeRole(role, account);
213     }
214 
215     function _setupRole(bytes32 role, address account) internal virtual {
216         _grantRole(role, account);
217     }
218 
219     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
220         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
221         _roles[role].adminRole = adminRole;
222     }
223 
224     function _grantRole(bytes32 role, address account) private {
225         if (_roles[role].members.add(account)) {
226             emit RoleGranted(role, account, _msgSender());
227         }
228     }
229 
230     function _revokeRole(bytes32 role, address account) private {
231         if (_roles[role].members.remove(account)) {
232             emit RoleRevoked(role, account, _msgSender());
233         }
234     }
235 }
236 
237 interface IERC20 {
238     function totalSupply() external view returns (uint256);
239     function balanceOf(address account) external view returns (uint256);
240     function transfer(address recipient, uint256 amount) external returns (bool);
241     function allowance(address owner, address spender) external view returns (uint256);
242     function approve(address spender, uint256 amount) external returns (bool);
243     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
244 
245     event Transfer(address indexed from, address indexed to, uint256 value);
246     event Approval(address indexed owner, address indexed spender, uint256 value);
247 }
248 
249 library SafeMath {
250     function add(uint256 a, uint256 b) internal pure returns (uint256) {
251         uint256 c = a + b;
252         require(c >= a, "SafeMath: addition overflow");
253 
254         return c;
255     }
256 
257     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
258         return sub(a, b, "SafeMath: subtraction overflow");
259     }
260 
261     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
262         require(b <= a, errorMessage);
263         uint256 c = a - b;
264 
265         return c;
266     }
267 
268     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
269 
270         if (a == 0) {
271             return 0;
272         }
273 
274         uint256 c = a * b;
275         require(c / a == b, "SafeMath: multiplication overflow");
276 
277         return c;
278     }
279 
280     function div(uint256 a, uint256 b) internal pure returns (uint256) {
281         return div(a, b, "SafeMath: division by zero");
282     }
283 
284     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
285         require(b > 0, errorMessage);
286         uint256 c = a / b;
287         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
288 
289         return c;
290     }
291 
292     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
293         return mod(a, b, "SafeMath: modulo by zero");
294     }
295 
296     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
297         require(b != 0, errorMessage);
298         return a % b;
299     }
300 }
301 
302 contract ERC20 is Context, IERC20 {
303     using SafeMath for uint256;
304     using Address for address;
305 
306     mapping (address => uint256) private _balances;
307     mapping (address => mapping (address => uint256)) private _allowances;
308 
309     uint256 private _totalSupply;
310     string private _name;
311     string private _symbol;
312     uint8 private _decimals;
313 
314     constructor (string memory name, string memory symbol) public {
315         _name = name;
316         _symbol = symbol;
317         _decimals = 18;
318     }
319 
320     function name() public view returns (string memory) {
321         return _name;
322     }
323 
324     function symbol() public view returns (string memory) {
325         return _symbol;
326     }
327 
328     function decimals() public view returns (uint8) {
329         return _decimals;
330     }
331 
332     function totalSupply() public view override returns (uint256) {
333         return _totalSupply;
334     }
335 
336     function balanceOf(address account) public view override returns (uint256) {
337         return _balances[account];
338     }
339 
340     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
341         _transfer(_msgSender(), recipient, amount);
342         return true;
343     }
344 
345     function allowance(address owner, address spender) public view virtual override returns (uint256) {
346         return _allowances[owner][spender];
347     }
348 
349     function approve(address spender, uint256 amount) public virtual override returns (bool) {
350         _approve(_msgSender(), spender, amount);
351         return true;
352     }
353 
354     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
355         _transfer(sender, recipient, amount);
356         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
357         return true;
358     }
359 
360     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
361         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
362         return true;
363     }
364 
365     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
366         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
367         return true;
368     }
369 
370     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
371         require(sender != address(0), "ERC20: transfer from the zero address");
372         require(recipient != address(0), "ERC20: transfer to the zero address");
373 
374         _beforeTokenTransfer(sender, recipient, amount);
375 
376         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
377         _balances[recipient] = _balances[recipient].add(amount);
378         emit Transfer(sender, recipient, amount);
379     }
380 
381     function _mint(address account, uint256 amount) internal virtual {
382         require(account != address(0), "ERC20: mint to the zero address");
383 
384         _beforeTokenTransfer(address(0), account, amount);
385 
386         _totalSupply = _totalSupply.add(amount);
387         _balances[account] = _balances[account].add(amount);
388         emit Transfer(address(0), account, amount);
389     }
390 
391     function _burn(address account, uint256 amount) internal virtual {
392         require(account != address(0), "ERC20: burn from the zero address");
393 
394         _beforeTokenTransfer(account, address(0), amount);
395 
396         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
397         _totalSupply = _totalSupply.sub(amount);
398         emit Transfer(account, address(0), amount);
399     }
400 
401     function _approve(address owner, address spender, uint256 amount) internal virtual {
402         require(owner != address(0), "ERC20: approve from the zero address");
403         require(spender != address(0), "ERC20: approve to the zero address");
404 
405         _allowances[owner][spender] = amount;
406         emit Approval(owner, spender, amount);
407     }
408 
409     function _setupDecimals(uint8 decimals_) internal {
410         _decimals = decimals_;
411     }
412 
413     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
414 }
415 
416 abstract contract ERC20Burnable is Context, ERC20 {
417     function burn(uint256 amount) public virtual {
418         _burn(_msgSender(), amount);
419     }
420 
421     function burnFrom(address account, uint256 amount) public virtual {
422         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
423 
424         _approve(account, _msgSender(), decreasedAllowance);
425         _burn(account, amount);
426     }
427 }
428 
429 contract Lockable is Context {
430     event Locked(address account);
431     event Unlocked(address account);
432     
433     mapping(address => bool) private _locked;
434     
435     function locked(address _to) public view returns (bool) {
436         return _locked[_to];
437     }
438     
439     function _lock(address to) internal virtual {
440         require(to != address(0), "ERC20: lock to the zero address");
441         
442         _locked[to] = true;
443         emit Locked(to);
444     }
445     
446     function _unlock(address to) internal virtual {
447         require(to != address(0), "ERC20: lock to the zero address");
448 
449         _locked[to] = false;
450         emit Unlocked(to);
451     }
452 }
453 
454 contract Pausable is Context {
455     event Paused(address account);
456     event Unpaused(address account);
457 
458     bool private _paused;
459 
460     constructor () internal {
461         _paused = false;
462     }
463 
464     function paused() public view returns (bool) {
465         return _paused;
466     }
467 
468     modifier whenNotPaused() {
469         require(!_paused, "Pausable: paused");
470         _;
471     }
472 
473     modifier whenPaused() {
474         require(_paused, "Pausable: not paused");
475         _;
476     }
477 
478     function _pause() internal virtual whenNotPaused {
479         _paused = true;
480         emit Paused(_msgSender());
481     }
482 
483     function _unpause() internal virtual whenPaused {
484         _paused = false;
485         emit Unpaused(_msgSender());
486     }
487 }
488 
489 abstract contract ERC20Pausable is ERC20, Pausable, Lockable {
490     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
491         super._beforeTokenTransfer(from, to, amount);
492 
493         require(!paused(), "ERC20Pausable: token transfer while paused");
494         require(!locked(from), "CustomLockable: token transfer while locked");
495     }
496 }
497 
498 contract ERC20PresetMinterPauser is Context, AccessControl, ERC20Burnable, ERC20Pausable {
499     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
500     bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
501 
502     constructor(string memory name, string memory symbol) public ERC20(name, symbol) {
503         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
504         _setupRole(MINTER_ROLE, _msgSender());
505         _setupRole(PAUSER_ROLE, _msgSender());
506     }
507 
508     function mint(address to, uint256 amount) public virtual {
509         require(hasRole(MINTER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have minter role to mint");
510         _mint(to, amount);
511     }
512 
513     function pause() public virtual {
514         require(hasRole(PAUSER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have pauser role to pause");
515         _pause();
516     }
517 
518     function unpause() public virtual {
519         require(hasRole(PAUSER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have pauser role to unpause");
520         _unpause();
521     }
522     
523     function lock(address to) public virtual {
524         require(hasRole(PAUSER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have pauser role to lock");
525         _lock(to);
526     }
527 
528     function unlock(address to) public virtual {
529         require(hasRole(PAUSER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have pauser role to unlock");
530         _unlock(to);
531     }
532 
533     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override(ERC20, ERC20Pausable) {
534         super._beforeTokenTransfer(from, to, amount);
535     }
536 }
537 
538 contract Ownable is Context {
539     address private _owner;
540 
541     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
542 
543     constructor () internal {
544         address msgSender = _msgSender();
545         _owner = msgSender;
546         emit OwnershipTransferred(address(0), msgSender);
547     }
548 
549     function owner() public view returns (address) {
550         return _owner;
551     }
552 
553     modifier onlyOwner() {
554         require(_owner == _msgSender(), "Ownable: caller is not the owner");
555         _;
556     }
557 
558     function renounceOwnership() public virtual onlyOwner {
559         emit OwnershipTransferred(_owner, address(0));
560         _owner = address(0);
561     }
562 
563     function transferOwnership(address newOwner) public virtual onlyOwner {
564         require(newOwner != address(0), "Ownable: new owner is the zero address");
565         emit OwnershipTransferred(_owner, newOwner);
566         _owner = newOwner;
567     }
568 }
569 
570 contract MRToken is Ownable, ERC20PresetMinterPauser {
571     constructor ()
572         ERC20PresetMinterPauser("MiningRevolution", "MR")
573         public
574     {
575         mint(msg.sender, 1*(10**8)*(10**uint256(decimals())) );
576     }
577 }