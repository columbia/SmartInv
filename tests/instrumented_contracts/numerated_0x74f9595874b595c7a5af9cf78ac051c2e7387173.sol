1 /* 
2  * Proof Ethereum Token v 2.5
3  * Developed by Krasava Digital Solutions
4  * Special thanks for the assistance provided by BelovITLab LC
5 */
6 
7 pragma solidity 0.6.6;
8 
9 abstract contract Context {
10     function _msgSender() internal view virtual returns (address payable) {
11         return msg.sender;
12     }
13     function _msgData() internal view virtual returns (bytes memory) {
14         this;
15         return msg.data;
16     }
17 }
18 
19 interface IERC20 {
20     function totalSupply() external view returns (uint256);
21     function balanceOf(address account) external view returns (uint256);
22     function transfer(address recipient, uint256 amount) external returns (bool);
23     function allowance(address owner, address spender) external view returns (uint256);
24     function approve(address spender, uint256 amount) external returns (bool);
25     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
26     event Transfer(address indexed from, address indexed to, uint256 value);
27     event Approval(address indexed owner, address indexed spender, uint256 value);
28 }
29 
30 contract ERC20 is Context, IERC20 {
31     using SafeMath for uint256;
32     using Address for address;
33     mapping (address => uint256) private _balances;
34     mapping (address => mapping (address => uint256)) private _allowances;
35     uint256 private _totalSupply;
36     string private _name;
37     string private _symbol;
38     uint8 private _decimals;
39     constructor (string memory name, string memory symbol) public {
40         _name = name;
41         _symbol = symbol;
42         _decimals = 18;
43     }    
44     function name() public view returns (string memory) {
45         return _name;
46     }    
47     function symbol() public view returns (string memory) {
48         return _symbol;
49     }    
50     function decimals() public view returns (uint8) {
51         return _decimals;
52     }
53     function totalSupply() public view override returns (uint256) {
54         return _totalSupply;
55     }
56     function balanceOf(address account) public view override returns (uint256) {
57         return _balances[account];
58     }
59     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
60         _transfer(_msgSender(), recipient, amount);
61         return true;
62     }
63     function allowance(address owner, address spender) public view virtual override returns (uint256) {
64         return _allowances[owner][spender];
65     }
66     function approve(address spender, uint256 amount) public virtual override returns (bool) {
67         _approve(_msgSender(), spender, amount);
68         return true;
69     }
70     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
71         _transfer(sender, recipient, amount);
72         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
73         return true;
74     }
75     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
76         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
77         return true;
78     }
79     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
80         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
81         return true;
82     }
83     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
84         require(sender != address(0), "ERC20: transfer from the zero address");
85         require(recipient != address(0), "ERC20: transfer to the zero address");
86         _beforeTokenTransfer(sender, recipient, amount);
87         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
88         _balances[recipient] = _balances[recipient].add(amount);
89         emit Transfer(sender, recipient, amount);
90     }
91     function _mint(address account, uint256 amount) internal virtual {
92         require(account != address(0), "ERC20: mint to the zero address");
93         _beforeTokenTransfer(address(0), account, amount);
94         _totalSupply = _totalSupply.add(amount);
95         _balances[account] = _balances[account].add(amount);
96         emit Transfer(address(0), account, amount);
97     }
98     function _burn(address account, uint256 amount) internal virtual {
99         require(account != address(0), "ERC20: burn from the zero address");
100         _beforeTokenTransfer(account, address(0), amount);
101         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
102         _totalSupply = _totalSupply.sub(amount);
103         emit Transfer(account, address(0), amount);
104     }
105     function _approve(address owner, address spender, uint256 amount) internal virtual {
106         require(owner != address(0), "ERC20: approve from the zero address");
107         require(spender != address(0), "ERC20: approve to the zero address");
108         _allowances[owner][spender] = amount;
109         emit Approval(owner, spender, amount);
110     }
111     function _setupDecimals(uint8 decimals_) internal {
112         _decimals = decimals_;
113     }
114     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
115 }
116 
117 contract ERC20DecimalsMock is ERC20 {
118     constructor (string memory name, string memory symbol, uint8 decimals) public ERC20(name, symbol) {
119         _setupDecimals(decimals);
120     }
121 }
122 
123 library SafeMath {
124     function add(uint256 a, uint256 b) internal pure returns (uint256) {
125         uint256 c = a + b;
126         require(c >= a, "SafeMath: addition overflow");
127         return c;
128     }
129     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
130         return sub(a, b, "SafeMath: subtraction overflow");
131     }
132     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
133         require(b <= a, errorMessage);
134         uint256 c = a - b;
135         return c;
136     }
137     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
138         if (a == 0) {
139             return 0;
140         }
141         uint256 c = a * b;
142         require(c / a == b, "SafeMath: multiplication overflow");
143         return c;
144     }
145     function div(uint256 a, uint256 b) internal pure returns (uint256) {
146         return div(a, b, "SafeMath: division by zero");
147     }
148     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
149         require(b > 0, errorMessage);
150         uint256 c = a / b;
151         return c;
152     }
153     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
154         return mod(a, b, "SafeMath: modulo by zero");
155     }
156     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
157         require(b != 0, errorMessage);
158         return a % b;
159     }
160 }
161 
162 library Address {
163     function isContract(address account) internal view returns (bool) {
164         bytes32 codehash;
165         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
166         assembly { codehash := extcodehash(account) }
167         return (codehash != accountHash && codehash != 0x0);
168     }
169     function sendValue(address payable recipient, uint256 amount) internal {
170         require(address(this).balance >= amount, "Address: insufficient balance");
171         (bool success, ) = recipient.call{ value: amount }("");
172         require(success, "Address: unable to send value, recipient may have reverted");
173     }
174 }
175 
176 library SafeERC20 {
177     using SafeMath for uint256;
178     using Address for address;
179     function safeTransfer(IERC20 token, address to, uint256 value) internal {
180         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
181     }
182     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
183         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
184     }
185     function safeApprove(IERC20 token, address spender, uint256 value) internal {
186         require((value == 0) || (token.allowance(address(this), spender) == 0),
187             "SafeERC20: approve from non-zero to non-zero allowance"
188         );
189         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
190     }
191     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
192         uint256 newAllowance = token.allowance(address(this), spender).add(value);
193         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
194     }
195     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
196         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
197         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
198     }
199     function _callOptionalReturn(IERC20 token, bytes memory data) private {
200         require(address(token).isContract(), "SafeERC20: call to non-contract");
201         (bool success, bytes memory returndata) = address(token).call(data);
202         require(success, "SafeERC20: low-level call failed");
203         if (returndata.length > 0) {
204             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
205         }
206     }
207 }
208 
209 contract Ownable is Context {
210     address private _owner;
211     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
212     constructor () internal {
213         address msgSender = _msgSender();
214         _owner = msgSender;
215         emit OwnershipTransferred(address(0), msgSender);
216     }
217     function owner() public view returns (address) {
218         return _owner;
219     }
220     modifier onlyOwner() {
221         require(_owner == _msgSender(), "Ownable: caller is not the owner");
222         _;
223     }
224     function renounceOwnership() public virtual onlyOwner {
225         emit OwnershipTransferred(_owner, address(0));
226         _owner = address(0);
227     }
228     function transferOwnership(address newOwner) public virtual onlyOwner {
229         require(newOwner != address(0), "Ownable: new owner is the zero address");
230         emit OwnershipTransferred(_owner, newOwner);
231         _owner = newOwner;
232     }
233 }
234 
235 library EnumerableSet {
236     struct Set {
237         bytes32[] _values;
238         mapping (bytes32 => uint256) _indexes;
239     }
240     function _add(Set storage set, bytes32 value) private returns (bool) {
241         if (!_contains(set, value)) {
242             set._values.push(value);
243             set._indexes[value] = set._values.length;
244             return true;
245         } else {
246             return false;
247         }
248     }
249     function _remove(Set storage set, bytes32 value) private returns (bool) {
250         uint256 valueIndex = set._indexes[value];
251         if (valueIndex != 0) {
252             uint256 toDeleteIndex = valueIndex - 1;
253             uint256 lastIndex = set._values.length - 1;
254             bytes32 lastvalue = set._values[lastIndex];
255             set._values[toDeleteIndex] = lastvalue;
256             set._indexes[lastvalue] = toDeleteIndex + 1;
257             set._values.pop();
258             delete set._indexes[value];
259             return true;
260         } else {
261             return false;
262         }
263     }
264     function _contains(Set storage set, bytes32 value) private view returns (bool) {
265         return set._indexes[value] != 0;
266     }
267     function _length(Set storage set) private view returns (uint256) {
268         return set._values.length;
269     }
270     function _at(Set storage set, uint256 index) private view returns (bytes32) {
271         require(set._values.length > index, "EnumerableSet: index out of bounds");
272         return set._values[index];
273     }
274     struct AddressSet {
275         Set _inner;
276     }
277     function add(AddressSet storage set, address value) internal returns (bool) {
278         return _add(set._inner, bytes32(uint256(value)));
279     }
280     function remove(AddressSet storage set, address value) internal returns (bool) {
281         return _remove(set._inner, bytes32(uint256(value)));
282     }
283     function contains(AddressSet storage set, address value) internal view returns (bool) {
284         return _contains(set._inner, bytes32(uint256(value)));
285     }
286     function length(AddressSet storage set) internal view returns (uint256) {
287         return _length(set._inner);
288     }
289     function at(AddressSet storage set, uint256 index) internal view returns (address) {
290         return address(uint256(_at(set._inner, index)));
291     }
292     struct UintSet {
293         Set _inner;
294     }
295     function add(UintSet storage set, uint256 value) internal returns (bool) {
296         return _add(set._inner, bytes32(value));
297     }
298     function remove(UintSet storage set, uint256 value) internal returns (bool) {
299         return _remove(set._inner, bytes32(value));
300     }
301     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
302         return _contains(set._inner, bytes32(value));
303     }
304     function length(UintSet storage set) internal view returns (uint256) {
305         return _length(set._inner);
306     }
307     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
308         return uint256(_at(set._inner, index));
309     }
310 }
311 
312 abstract contract AccessControl is Context {
313     using EnumerableSet for EnumerableSet.AddressSet;
314     using Address for address;
315     struct RoleData {
316         EnumerableSet.AddressSet members;
317         bytes32 adminRole;
318     }
319     mapping (bytes32 => RoleData) private _roles;
320     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
321     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
322     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
323     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
324     function hasRole(bytes32 role, address account) public view returns (bool) {
325         return _roles[role].members.contains(account);
326     }
327     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
328         return _roles[role].members.length();
329     }
330     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
331         return _roles[role].members.at(index);
332     }
333     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
334         return _roles[role].adminRole;
335     }
336     function grantRole(bytes32 role, address account) public virtual {
337         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
338         _grantRole(role, account);
339     }
340     function revokeRole(bytes32 role, address account) public virtual {
341         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
342         _revokeRole(role, account);
343     }
344     function renounceRole(bytes32 role, address account) public virtual {
345         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
346         _revokeRole(role, account);
347     }
348     function _setupRole(bytes32 role, address account) internal virtual {
349         _grantRole(role, account);
350     }
351     function _unsetRole(bytes32 role, address account) internal virtual {
352         _revokeRole(role, account);
353     }
354     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
355         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
356         _roles[role].adminRole = adminRole;
357     }
358     function _grantRole(bytes32 role, address account) private {
359         if (_roles[role].members.add(account)) {
360             emit RoleGranted(role, account, _msgSender());
361         }
362     }
363     function _revokeRole(bytes32 role, address account) private {
364         if (_roles[role].members.remove(account)) {
365             emit RoleRevoked(role, account, _msgSender());
366         }
367     }
368 }
369 
370 contract Pausable is Context {
371     event Paused(address account);
372     event Unpaused(address account);
373     bool private _paused;
374     constructor () internal {
375         _paused = false;
376     }
377     function paused() public view returns (bool) {
378         return _paused;
379     }
380     modifier whenNotPaused() {
381         require(!_paused, "Pausable: paused");
382         _;
383     }
384     modifier whenPaused() {
385         require(_paused, "Pausable: not paused");
386         _;
387     }
388     function _pause() internal virtual whenNotPaused {
389         _paused = true;
390         emit Paused(_msgSender());
391     }
392     function _unpause() internal virtual whenPaused {
393         _paused = false;
394         emit Unpaused(_msgSender());
395     }
396 }
397 
398 interface EthRateInterface {
399     function EthToUsdRate() external view returns(uint256);
400 }
401 
402 contract ProofCoin is ERC20DecimalsMock("PROOF", "PRF", 6), Ownable, AccessControl, Pausable {
403     using SafeERC20 for IERC20;
404     struct User {address user_referer; uint32 last_transaction; uint256 user_profit;}
405     bytes32 public constant contractAdmin = keccak256("contractAdmin");
406     bool public ethBuyOn = true;
407     bool public usdtBuyOn = true;
408     bool public daiBuyOn = true;
409     address[] public founders;
410     address[] public cashiers;
411     address[] public managers;
412     uint256 private eth_custom_rate;
413     uint256 private usd_rate = 100;
414     uint256 private initial_bounty = 2e10;
415     uint256 private fixed_total_suply = 1e12;
416     IERC20 public daiToken = IERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F);
417     IERC20 public usdtToken = IERC20(0xdAC17F958D2ee523a2206206994597C13D831ec7);
418     EthRateInterface public EthRateSource = EthRateInterface(0x9dd4C0a264B53e26B61Fa27922Ac4697f0b9dD8b);
419     event ProfitPayout(uint32 timestamp, address indexed addr, uint256 amount);
420     event TimeProfit(uint256 balance, uint256 hold, uint256 percent, uint256 min, uint256 tax, uint256 reward, uint256 total);
421     event ReferalProfit(uint256 balance, uint256 profit, uint256 percent, uint256 min, uint256 tax, uint256 reward, uint256 total);
422     mapping(address => User) public users;
423     modifier onlyFounders() {
424         for(uint256 i = 0; i < founders.length; i++) {
425             if(founders[i] == msg.sender) {
426                 _;
427                 return;
428             }
429         }
430         revert("Access denied");
431     }
432     constructor() public {
433         _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
434         _setupRole(contractAdmin, msg.sender);
435         _setupRole(contractAdmin, 0x2589171E72A4aaa7b0e7Cc493DB6db7e32aC97d4);
436         _setupRole(contractAdmin, 0x3d027e252A275650643cE83934f492B6914D3341);
437         _setupRole(contractAdmin, 0xe74400179854ca60bCD0d3dA3BB0A2BA9028FB76);
438         _setupRole(contractAdmin, 0x30517CaE41977fc9d4a21e2423b7D5Ce8D19d0cb);
439         _setupRole(contractAdmin, 0x5e646586E572D5D6B44153e81224D26F23B00651);
440         founders.push(0x2589171E72A4aaa7b0e7Cc493DB6db7e32aC97d4);
441         founders.push(0x3d027e252A275650643cE83934f492B6914D3341);
442         founders.push(0xe74400179854ca60bCD0d3dA3BB0A2BA9028FB76);
443         founders.push(0x30517CaE41977fc9d4a21e2423b7D5Ce8D19d0cb);
444         cashiers.push(0x1411B85AaE2Dc11927566042401a6DE158cE4413);
445         managers.push(0x5e646586E572D5D6B44153e81224D26F23B00651);
446     }
447     function _beforeTokenTransfer(address _from, address _to, uint256 _amount) internal override {
448         if(_from != address(0)) {
449             uint256 f_profit = _timeProfit(_from);
450             if(f_profit > 0 && users[_from].user_referer != address(0)) _refReward(users[_from].user_referer, f_profit);
451         }
452         if(_from != _to) {
453             uint256 t_profit = _timeProfit(_to);
454             if(t_profit > 0 && users[_to].user_referer != address(0)) _refReward(users[_to].user_referer, t_profit);
455             if(users[_to].user_referer == address(0) && _from != address(0) && users[_from].user_referer != _to && _amount > 0) users[_to].user_referer = _from;
456             if(users[_to].last_transaction == 0) users[_to].last_transaction = uint32(block.timestamp);
457         } else {
458             _profitPayout(_from);
459         }
460     }
461     function _timeProfit(address _account) private returns(uint256 value) {
462         uint256 balance = this.balanceOf(_account);
463         uint256 hold = block.timestamp - users[_account].last_transaction;
464         if(balance >= 1e7 && hold > 0) {
465             uint256 percent;
466             if(balance >= 1e7 && balance < 1e8) percent = 10;
467             if(balance >= 1e8 && balance < 5e8) percent = 13;
468             if(balance >= 5e8 && balance < 1e9) percent = 17;
469             if(balance >= 1e9 && balance < 5e9) percent = 22;
470             if(balance >= 5e9 && balance < 1e10) percent = 28;
471             if(balance >= 1e10 && balance < 5e10) percent = 35;
472             if(balance >= 5e10 && balance < 1e11) percent = 43;
473             if(balance >= 1e11 && balance < 5e11) percent = 52;
474             if(balance >= 5e11 && balance < 1e12) percent = 62;
475             value = hold * balance * percent / 864 / 1e6;
476             if(value > 0) {
477                 uint256 min = hold * balance / 2592 / 1e5;
478                 uint256 tax = this.totalSupply() < 1e15 ? value * this.totalSupply() / 1e15 : 0;
479                 value -= tax;
480                 if(value < min) value = min;
481                 users[_account].user_profit += value;
482                 emit TimeProfit(balance, hold, percent, min, tax, value, users[_account].user_profit);
483             }
484         }
485         users[_account].last_transaction = uint32(block.timestamp);
486     }
487     function _refReward(address _referer, uint256 _amount) private returns(uint256 value) {
488         uint256 balance = this.balanceOf(_referer);
489         if(balance >= 1e8 && balance < 1e12) {
490             uint256 percent;
491             if(balance >= 1e8 && balance < 1e9) percent = 520;
492             if(balance >= 1e9 && balance < 1e10) percent = 750;
493             if(balance >= 1e10 && balance < 1e11) percent = 1280;
494             if(balance >= 1e11 && balance < 1e12) percent = 2650;
495             value =_amount * percent / 10000;
496             uint256 min = _amount / 100;
497             uint256 tax = this.totalSupply() < 1e15 ? value * this.totalSupply() / 1e15 : 0;
498             value -= tax;
499             if(value < min) value = min;
500             users[_referer].user_profit = users[_referer].user_profit + value;
501             emit ReferalProfit(balance, _amount, percent, min, tax, value, users[_referer].user_profit);
502         }
503     }
504     function _profitPayout(address _account) private {
505         uint256 userProfit = users[_account].user_profit;
506         if(userProfit > 0) {
507             users[_account].user_profit = 0;
508             _mint(_account, userProfit);
509         }
510         emit ProfitPayout(uint32(block.timestamp), _account, userProfit);
511     }
512     receive() payable external whenNotPaused {
513         require(ethBuyOn, "ETH buy is off");
514         require(this.ethRate() > 0, "Set ETH rate first");
515         uint256 amount = msg.value * this.ethRate() * 100 / usd_rate / 1e18;
516         _buy(msg.sender, amount);
517     }
518     function _buy(address _account, uint256 _amount) private {
519         require(_amount > 0, "Zero amount");
520         _mint(_account, _amount);
521     }
522     function ethRate() external view returns(uint256) {
523         uint256 ext_rate = EthRateSource.EthToUsdRate();
524         if(eth_custom_rate > 0) {
525             return ext_rate > 0 && eth_custom_rate > ext_rate ? ext_rate : eth_custom_rate;
526         } else {
527             return ext_rate;
528         }
529     }
530     function ethBuySwitch(bool _value) external {
531         require(hasRole(contractAdmin, msg.sender), "Caller is not a CONTRACT ADMIN");
532         ethBuyOn = _value;
533     }
534     function ethBuy() external payable whenNotPaused {
535         require(ethBuyOn, "ETH buy is off");
536         require(this.ethRate() > 0, "Set ETH rate first");        
537         uint256 amount = msg.value * this.ethRate() * 100 / usd_rate / 1e18;
538         _buy(msg.sender, amount);
539     }
540     function ethRateSet(uint256 _value) external onlyFounders {
541         eth_custom_rate = _value;
542     }
543     function ethRateUp(uint256 _value) external {
544         require(hasRole(contractAdmin, msg.sender), "Caller is not a CONTRACT ADMIN");
545         require(eth_custom_rate > _value, "Wrong rate");
546         eth_custom_rate = _value;
547     }    
548     function ethRateAddr(address _source) external onlyFounders {
549         EthRateSource = EthRateInterface(_source);
550     }
551     function ethUniswapRate() external view returns(uint256) {
552         return EthRateSource.EthToUsdRate();
553     }
554     function ethCustomRate() external view returns(uint256) {
555         return eth_custom_rate;
556     }
557     function daiBuySwitch(bool _value) external {
558         require(hasRole(contractAdmin, msg.sender), "Caller is not a CONTRACT ADMIN");
559         daiBuyOn = _value;
560     }
561     function daiBuy(uint256 _value) external whenNotPaused {
562         require(daiBuyOn, "DAI buy is off");
563         daiToken.safeTransferFrom(msg.sender, address(this), _value);
564         uint256 amount = _value * 100 / usd_rate / 1e12;
565         _buy(msg.sender, amount);
566     }
567     function usdtBuySwitch(bool _value) external {
568         require(hasRole(contractAdmin, msg.sender), "Caller is not a CONTRACT ADMIN");
569         usdtBuyOn = _value;
570     }
571     function usdtBuy(uint256 _value) external whenNotPaused {
572         require(usdtBuyOn, "Tether buy is off");
573         usdtToken.safeTransferFrom(msg.sender, address(this), _value);
574         uint256 amount = _value * 100 / usd_rate;
575         _buy(msg.sender, amount);
576     }
577     function usdRateSet(uint256 _value) external onlyFounders {
578         require(_value >= 100, "Wrong rate");
579         usd_rate = _value;
580     }
581     function usdRateUp(uint256 _value) external {
582         require(hasRole(contractAdmin, msg.sender), "Caller is not a CONTRACT ADMIN");
583         require(_value > usd_rate, "Wrong rate");
584         usd_rate = _value;
585     }
586     function usdRate() external view returns(uint256) {
587         return usd_rate;
588     }    
589     function getProfit() external {
590         require(users[msg.sender].user_profit > 0, "This account has no PROFIT");
591         _profitPayout(msg.sender);
592     }      
593     function getRefs() external {
594         require(users[address(this)].user_profit > 0, "This account has no PROFIT");
595         _profitPayout(address(this));
596     }   
597     function getProofs() external {
598         require(this.balanceOf(address(this)) > founders.length * 1e6 + 1e8, "Not enougth PRF");
599         uint256 amount = this.balanceOf(address(this)) - 1e8;
600         for(uint8 i = 0; i < founders.length; i++) {
601             _transfer(address(this), founders[i], amount / founders.length);
602         }
603     }    
604     function initialBounty(address _to, uint256 _value) external onlyFounders {
605         require(initial_bounty > 0, "Initital bounty is over 20000 PRF");
606         if(_value > initial_bounty) _value = initial_bounty;
607         initial_bounty -= _value;
608         fixed_total_suply += _value * 100;
609         _mint(_to, _value);
610     }
611     function getBounties() external {
612         require(this.totalSupply() > (founders.length + managers.length) * 1e6 + fixed_total_suply, "Not enougth PRF");
613         uint256 amount = (this.totalSupply() - fixed_total_suply) / 200;
614         for(uint8 i = 0; i < founders.length; i++) {
615             _mint(founders[i], amount / founders.length);
616         }
617         for(uint8 i = 0; i < managers.length; i++) {
618             _mint(managers[i], amount / managers.length);
619         }
620         fixed_total_suply = this.totalSupply();
621     }
622     function getEthers() external {
623         require(address(this).balance > (founders.length + cashiers.length) * 1e15, "Not enougth ETH");
624         uint256 amount = address(this).balance / 2;
625         for(uint8 i = 0; i < founders.length; i++) {
626             payable(founders[i]).transfer(amount / founders.length);
627         }
628         for(uint8 i = 0; i < cashiers.length; i++) {
629             payable(cashiers[i]).transfer(amount / cashiers.length);
630         }
631     }    
632     function getTethers() external {
633         require(usdtToken.balanceOf(address(this)) > (founders.length + cashiers.length) * 1e6, "Not enougth USDT");
634         uint256 amount = usdtToken.balanceOf(address(this)) / 2;
635         for(uint8 i = 0; i < founders.length; i++) {
636             usdtToken.safeTransfer(founders[i], amount / founders.length);
637         }
638         for(uint8 i = 0; i < cashiers.length; i++) {
639             usdtToken.safeTransfer(cashiers[i], amount / cashiers.length);
640         }
641     }    
642     function getDais() external {
643         require(daiToken.balanceOf(address(this)) > (founders.length + cashiers.length) * 1e18, "Not enougth DAI");
644         uint256 amount = daiToken.balanceOf(address(this)) / 2;
645         for(uint8 i = 0; i < founders.length; i++) {
646             daiToken.safeTransfer(founders[i], amount / founders.length);
647         }
648         for(uint8 i = 0; i < cashiers.length; i++) {
649             daiToken.safeTransfer(cashiers[i], amount / cashiers.length);
650         }
651     }
652     function initialBountyLimit() external view returns(uint256 limit) {
653         return (initial_bounty);
654     }
655     function overTax() external view returns(uint256 tax) {
656         return  this.totalSupply() < 1e15 ? this.totalSupply() / 1e13 : 0;
657     }
658     function onBoard() external view returns(uint256 refs, uint256 bounty, uint256 prf, uint256 eth, uint256 usdt, uint256 dai) {
659         bounty = this.totalSupply() > fixed_total_suply ? (this.totalSupply() - fixed_total_suply) / 100 : 0;
660         return (users[address(this)].user_profit, bounty, this.balanceOf(address(this)), address(this).balance, usdtToken.balanceOf(address(this)), daiToken.balanceOf(address(this)));
661     }
662     function userInfo() external view returns(address referer, uint256 balance, uint256 last_transaction, uint256 profit) {
663         return (users[msg.sender].user_referer, this.balanceOf(msg.sender), users[msg.sender].last_transaction, users[msg.sender].user_profit);
664     }
665     function setDefaultReferer() external {
666         require(users[msg.sender].user_referer == address(0), "Your referrer will not understand");
667         users[msg.sender].user_referer = address(this);
668     }
669     function setManagers(uint256 _index, address _account) external onlyFounders {
670         if(managers.length > _index) {
671             if(_account == address(0)) {
672                 for(uint256 i = 0; i < managers.length - 1; i++) {
673                     managers[i] = i < _index ? managers[i] : managers[i + 1];
674                 }
675                 managers.pop();
676             } else managers[_index] = _account;
677         } else {
678             require(_account != address(0), "Zero address");
679             managers.push(_account);
680         }
681     }
682     function setCashiers(uint256 _index, address _account) external onlyFounders {
683         if(cashiers.length > _index) {
684             if(_account == address(0)) {
685                 for(uint256 i = 0; i < cashiers.length - 1; i++) {
686                     cashiers[i] =  i < _index ? cashiers[i] : cashiers[i + 1];
687                 }
688                 cashiers.pop();
689             } else cashiers[_index] = _account;
690         } else {
691             require(_account != address(0), "Zero address");
692             cashiers.push(_account);
693         }
694     }
695     function pauseOn() external onlyFounders {
696         _pause();
697     }
698     function pauseOff() external onlyFounders {
699         _unpause();
700     }
701     function adminUnset(address _account) external onlyFounders {
702         _unsetRole(contractAdmin, _account);
703     }
704     function adminSetup(address _account) external onlyFounders {
705         _setupRole(contractAdmin, _account);
706     }    
707     function burn(uint256 _amount) external{
708         _burn(msg.sender, _amount);
709     }
710 }