1 //
2 // Speculative Resistance (SPECTRE) is the fourth token from Read This Contract (RTC)!
3 // If you don't know what RTC is, read on and join the Telegram:
4 // > https://veravoss.github.io/rtc/
5 // > https://t.me/ReadThisContract
6 //
7 // SPECTRE is intended as a deflationary token with reducing supply and appreciating value, and a fair launch.
8 // It has simple rules:
9 //
10 // 0. SPECTRE-ETH pool on Uniswap will be prepared with 5 ETH and 50,000 SPECTRE ("V Liquidity"):
11 //    Pool creation will be split into steps to resist speculative bots. Pool will start with little liquidity
12 //    and more will be added every 10 minutes. Price may be suppressed to maintain the ability to add liquidity.
13 //    Monitor the Telegram group to know when the SPECTRE-ETH pool is finalised.
14 //
15 //    Total supply is 56,000 SPECTRE. 5,000 is airdropped to RTC holders and Uniswap LP holders of RTC pairs (-SWSH, -LIQLO, -ETH).
16 //    1,000 is kept in reserve to create future pools paired with SPECTRE. Minting is locked, supply is final.
17 //
18 // 1. Whenever SPECTRE-ETH Uniswap pool Ethereum liquidity is above 12 ETH, the following process can occur:
19 //    - 10% of "V Liquidity" is removed from the pool through Uniswap,
20 //    - all un-pooled ETH is used to regularly buy SPECTRE back from the pool at 1 ETH chunks,
21 //    - all un-pooled & bought-back SPECTRE, minus a 1% dev fee, is sent to Burn Address,
22 //
23 //    The process is triggered randomly. Can happen multiple times per day, or not at all, as long as the liquidity
24 //    condition is met. Think of it as a random, upwards rebasing of the pool's liquidity.
25 //
26 // 2. SPECTRE supply reduces logarithmically and "V Liquidity" approaches zero, effectively locking it over time.
27 //
28 // 3. SPECTRE tokens will be used to unlock RTC ecosystem lootboxes with NFTs possessing special abilities within
29 //    the RTC ecosystem! SPECTRE-ETH and other pairs will arrive to SwapShip.finance in near future.
30 //
31 // Good luck!
32 //
33 // Veronika
34 //
35 // //////////////////////////////////////////////////////////////////////////////// //
36 //                                                                                  //
37 //                               ////   //////   /////                              //
38 //                              //        //     //                                 //
39 //                              //        //     /////                              //
40 //                                                                                  //
41 //                              Never break the chain.                              //
42 //                                                                                  //
43 // //////////////////////////////////////////////////////////////////////////////// //
44 pragma solidity ^0.6.0;
45 contract Context {
46     constructor () internal { }
47     function _msgSender() internal view virtual returns (address payable) {
48         return msg.sender;
49     }
50     function _msgData() internal view virtual returns (bytes memory) {
51         this;
52         return msg.data;
53     }
54 }
55 pragma solidity ^0.6.0;
56 library SafeMath {
57     function add(uint256 a, uint256 b) internal pure returns (uint256) {
58         uint256 c = a + b;
59         require(c >= a, "SafeMath: addition overflow");
60         return c;
61     }
62     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
63         return sub(a, b, "SafeMath: subtraction overflow");
64     }
65     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
66         require(b <= a, errorMessage);
67         uint256 c = a - b;
68         return c;
69     }
70     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
71         if (a == 0) {
72             return 0;
73         }
74         uint256 c = a * b;
75         require(c / a == b, "SafeMath: multiplication overflow");
76         return c;
77     }
78     function div(uint256 a, uint256 b) internal pure returns (uint256) {
79         return div(a, b, "SafeMath: division by zero");
80     }
81     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
82         require(b > 0, errorMessage);
83         uint256 c = a / b;
84         return c;
85     }
86     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
87         return mod(a, b, "SafeMath: modulo by zero");
88     }
89     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
90         require(b != 0, errorMessage);
91         return a % b;
92     }
93 }
94 pragma solidity ^0.6.0;
95 contract Ownable is Context {
96     address private _owner;
97     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
98     constructor () internal {
99         address msgSender = _msgSender();
100         _owner = msgSender;
101         emit OwnershipTransferred(address(0), msgSender);
102     }
103     function owner() public view returns (address) {
104         return _owner;
105     }
106     modifier onlyOwner() {
107         require(_owner == _msgSender(), "Ownable: caller is not the owner");
108         _;
109     }
110     function renounceOwnership() public virtual onlyOwner {
111         emit OwnershipTransferred(_owner, address(0));
112         _owner = address(0);
113     }
114     function transferOwnership(address newOwner) public virtual onlyOwner {
115         require(newOwner != address(0), "Ownable: new owner is the zero address");
116         emit OwnershipTransferred(_owner, newOwner);
117         _owner = newOwner;
118     }
119 }
120 pragma solidity ^0.6.2;
121 library Address {
122     function isContract(address account) internal view returns (bool) {
123         bytes32 codehash;
124         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
125         assembly { codehash := extcodehash(account) }
126         return (codehash != accountHash && codehash != 0x0);
127     }
128     function sendValue(address payable recipient, uint256 amount) internal {
129         require(address(this).balance >= amount, "Address: insufficient balance");
130         (bool success, ) = recipient.call{ value: amount }("");
131         require(success, "Address: unable to send value, recipient may have reverted");
132     }
133 }
134 pragma solidity ^0.6.0;
135 interface IERC20 {
136     function totalSupply() external view returns (uint256);
137     function balanceOf(address account) external view returns (uint256);
138     function transfer(address recipient, uint256 amount) external returns (bool);
139     function allowance(address owner, address spender) external view returns (uint256);
140     function approve(address spender, uint256 amount) external returns (bool);
141     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
142     event Transfer(address indexed from, address indexed to, uint256 value);
143     event Approval(address indexed owner, address indexed spender, uint256 value);
144 }
145 pragma solidity ^0.6.0;
146 contract ERC20 is Context, IERC20 {
147     using SafeMath for uint256;
148     using Address for address;
149     mapping (address => uint256) private _balances;
150     mapping (address => mapping (address => uint256)) private _allowances;
151     uint256 private _totalSupply;
152     string private _name;
153     string private _symbol;
154     uint8 private _decimals;
155     constructor (string memory name, string memory symbol) public {
156         _name = name;
157         _symbol = symbol;
158         _decimals = 18;
159     }
160     function name() public view returns (string memory) {
161         return _name;
162     }
163     function symbol() public view returns (string memory) {
164         return _symbol;
165     }
166     function decimals() public view returns (uint8) {
167         return _decimals;
168     }
169     function totalSupply() public view override returns (uint256) {
170         return _totalSupply;
171     }
172     function balanceOf(address account) public view override returns (uint256) {
173         return _balances[account];
174     }
175     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
176         _transfer(_msgSender(), recipient, amount);
177         return true;
178     }
179     function allowance(address owner, address spender) public view virtual override returns (uint256) {
180         return _allowances[owner][spender];
181     }
182     function approve(address spender, uint256 amount) public virtual override returns (bool) {
183         _approve(_msgSender(), spender, amount);
184         return true;
185     }
186     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
187         _transfer(sender, recipient, amount);
188         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
189         return true;
190     }
191     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
192         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
193         return true;
194     }
195     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
196         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
197         return true;
198     }
199     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
200         require(sender != address(0), "ERC20: transfer from the zero address");
201         require(recipient != address(0), "ERC20: transfer to the zero address");
202         _beforeTokenTransfer(sender, recipient, amount);
203         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
204         _balances[recipient] = _balances[recipient].add(amount);
205         emit Transfer(sender, recipient, amount);
206     }
207     function _mint(address account, uint256 amount) internal virtual {
208         require(account != address(0), "ERC20: mint to the zero address");
209         _beforeTokenTransfer(address(0), account, amount);
210         _totalSupply = _totalSupply.add(amount);
211         _balances[account] = _balances[account].add(amount);
212         emit Transfer(address(0), account, amount);
213     }
214     function _burn(address account, uint256 amount) internal virtual {
215         require(account != address(0), "ERC20: burn from the zero address");
216         _beforeTokenTransfer(account, address(0), amount);
217         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
218         _totalSupply = _totalSupply.sub(amount);
219         emit Transfer(account, address(0), amount);
220     }
221     function _approve(address owner, address spender, uint256 amount) internal virtual {
222         require(owner != address(0), "ERC20: approve from the zero address");
223         require(spender != address(0), "ERC20: approve to the zero address");
224         _allowances[owner][spender] = amount;
225         emit Approval(owner, spender, amount);
226     }
227     function _setupDecimals(uint8 decimals_) internal {
228         _decimals = decimals_;
229     }
230     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
231 }
232 pragma solidity ^0.6.0;
233 abstract contract ERC20Capped is ERC20 {
234     uint256 private _cap;
235     constructor (uint256 cap) public {
236         require(cap > 0, "ERC20Capped: cap is 0");
237         _cap = cap;
238     }
239     function cap() public view returns (uint256) {
240         return _cap;
241     }
242     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
243         super._beforeTokenTransfer(from, to, amount);
244         if (from == address(0)) {
245             require(totalSupply().add(amount) <= _cap, "ERC20Capped: cap exceeded");
246         }
247     }
248 }
249 pragma solidity ^0.6.0;
250 abstract contract ERC20Burnable is Context, ERC20 {
251     function burn(uint256 amount) public virtual {
252         _burn(_msgSender(), amount);
253     }
254     function burnFrom(address account, uint256 amount) public virtual {
255         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
256         _approve(account, _msgSender(), decreasedAllowance);
257         _burn(account, amount);
258     }
259 }
260 pragma solidity ^0.6.0;
261 interface IERC165 {
262     function supportsInterface(bytes4 interfaceId) external view returns (bool);
263 }
264 pragma solidity ^0.6.2;
265 library ERC165Checker {
266     bytes4 private constant _INTERFACE_ID_INVALID = 0xffffffff;
267     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
268     function supportsERC165(address account) internal view returns (bool) {
269         return _supportsERC165Interface(account, _INTERFACE_ID_ERC165) &&
270             !_supportsERC165Interface(account, _INTERFACE_ID_INVALID);
271     }
272     function supportsInterface(address account, bytes4 interfaceId) internal view returns (bool) {
273         return supportsERC165(account) &&
274             _supportsERC165Interface(account, interfaceId);
275     }
276 
277     function supportsAllInterfaces(address account, bytes4[] memory interfaceIds) internal view returns (bool) {
278         if (!supportsERC165(account)) {
279             return false;
280         }
281         for (uint256 i = 0; i < interfaceIds.length; i++) {
282             if (!_supportsERC165Interface(account, interfaceIds[i])) {
283                 return false;
284             }
285         }
286         return true;
287     }
288 
289     function _supportsERC165Interface(address account, bytes4 interfaceId) private view returns (bool) {
290         (bool success, bool result) = _callERC165SupportsInterface(account, interfaceId);
291         return (success && result);
292     }
293 
294     function _callERC165SupportsInterface(address account, bytes4 interfaceId)
295         private
296         view
297         returns (bool, bool)
298     {
299         bytes memory encodedParams = abi.encodeWithSelector(_INTERFACE_ID_ERC165, interfaceId);
300         (bool success, bytes memory result) = account.staticcall{ gas: 30000 }(encodedParams);
301         if (result.length < 32) return (false, false);
302         return (success, abi.decode(result, (bool)));
303     }
304 }
305 pragma solidity ^0.6.0;
306 contract ERC165 is IERC165 {
307     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
308 
309     mapping(bytes4 => bool) private _supportedInterfaces;
310     constructor () internal {
311         _registerInterface(_INTERFACE_ID_ERC165);
312     }
313 
314     function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
315         return _supportedInterfaces[interfaceId];
316     }
317 
318     function _registerInterface(bytes4 interfaceId) internal virtual {
319         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
320         _supportedInterfaces[interfaceId] = true;
321     }
322 }
323 pragma solidity ^0.6.0;
324 contract TokenRecover is Ownable {
325 
326     function recoverERC20(address tokenAddress, uint256 tokenAmount) public onlyOwner {
327         IERC20(tokenAddress).transfer(owner(), tokenAmount);
328     }
329 }
330 pragma solidity ^0.6.0;
331 library EnumerableSet {
332     struct Set {
333         bytes32[] _values;
334         mapping (bytes32 => uint256) _indexes;
335     }
336 
337     function _add(Set storage set, bytes32 value) private returns (bool) {
338         if (!_contains(set, value)) {
339             set._values.push(value);
340             set._indexes[value] = set._values.length;
341             return true;
342         } else {
343             return false;
344         }
345     }
346 
347     function _remove(Set storage set, bytes32 value) private returns (bool) {
348         uint256 valueIndex = set._indexes[value];
349         if (valueIndex != 0) {
350             uint256 toDeleteIndex = valueIndex - 1;
351             uint256 lastIndex = set._values.length - 1;
352             bytes32 lastvalue = set._values[lastIndex];
353             set._values[toDeleteIndex] = lastvalue;
354             set._indexes[lastvalue] = toDeleteIndex + 1;
355             set._values.pop();
356             delete set._indexes[value];
357             return true;
358         } else {
359             return false;
360         }
361     }
362 
363     function _contains(Set storage set, bytes32 value) private view returns (bool) {
364         return set._indexes[value] != 0;
365     }
366 
367     function _length(Set storage set) private view returns (uint256) {
368         return set._values.length;
369     }
370     function _at(Set storage set, uint256 index) private view returns (bytes32) {
371         require(set._values.length > index, "EnumerableSet: index out of bounds");
372         return set._values[index];
373     }
374     struct AddressSet {
375         Set _inner;
376     }
377 
378     function add(AddressSet storage set, address value) internal returns (bool) {
379         return _add(set._inner, bytes32(uint256(value)));
380     }
381 
382     function remove(AddressSet storage set, address value) internal returns (bool) {
383         return _remove(set._inner, bytes32(uint256(value)));
384     }
385 
386     function contains(AddressSet storage set, address value) internal view returns (bool) {
387         return _contains(set._inner, bytes32(uint256(value)));
388     }
389 
390     function length(AddressSet storage set) internal view returns (uint256) {
391         return _length(set._inner);
392     }
393     function at(AddressSet storage set, uint256 index) internal view returns (address) {
394         return address(uint256(_at(set._inner, index)));
395     }
396 
397     struct UintSet {
398         Set _inner;
399     }
400 
401     function add(UintSet storage set, uint256 value) internal returns (bool) {
402         return _add(set._inner, bytes32(value));
403     }
404 
405     function remove(UintSet storage set, uint256 value) internal returns (bool) {
406         return _remove(set._inner, bytes32(value));
407     }
408 
409     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
410         return _contains(set._inner, bytes32(value));
411     }
412 
413     function length(UintSet storage set) internal view returns (uint256) {
414         return _length(set._inner);
415     }
416     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
417         return uint256(_at(set._inner, index));
418     }
419 }
420 pragma solidity ^0.6.0;
421 abstract contract AccessControl is Context {
422     using EnumerableSet for EnumerableSet.AddressSet;
423     using Address for address;
424     struct RoleData {
425         EnumerableSet.AddressSet members;
426         bytes32 adminRole;
427     }
428     mapping (bytes32 => RoleData) private _roles;
429     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
430 
431     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
432 
433     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
434 
435     function hasRole(bytes32 role, address account) public view returns (bool) {
436         return _roles[role].members.contains(account);
437     }
438 
439     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
440         return _roles[role].members.length();
441     }
442 
443     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
444         return _roles[role].members.at(index);
445     }
446 
447     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
448         return _roles[role].adminRole;
449     }
450 
451     function grantRole(bytes32 role, address account) public virtual {
452         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
453         _grantRole(role, account);
454     }
455 
456     function revokeRole(bytes32 role, address account) public virtual {
457         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
458         _revokeRole(role, account);
459     }
460 
461     function renounceRole(bytes32 role, address account) public virtual {
462         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
463         _revokeRole(role, account);
464     }
465 
466     function _setupRole(bytes32 role, address account) internal virtual {
467         _grantRole(role, account);
468     }
469 
470     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
471         _roles[role].adminRole = adminRole;
472     }
473     function _grantRole(bytes32 role, address account) private {
474         if (_roles[role].members.add(account)) {
475             emit RoleGranted(role, account, _msgSender());
476         }
477     }
478     function _revokeRole(bytes32 role, address account) private {
479         if (_roles[role].members.remove(account)) {
480             emit RoleRevoked(role, account, _msgSender());
481         }
482     }
483 }
484 pragma solidity ^0.6.0;
485 contract Roles is AccessControl {
486     bytes32 public constant MINTER_ROLE = keccak256("MINTER");
487     bytes32 public constant OPERATOR_ROLE = keccak256("OPERATOR");
488     constructor () public {
489         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
490         _setupRole(MINTER_ROLE, _msgSender());
491         _setupRole(OPERATOR_ROLE, _msgSender());
492     }
493     modifier onlyMinter() {
494         require(hasRole(MINTER_ROLE, _msgSender()), "Roles: caller does not have the MINTER role");
495         _;
496     }
497     modifier onlyOperator() {
498         require(hasRole(OPERATOR_ROLE, _msgSender()), "Roles: caller does not have the OPERATOR role");
499         _;
500     }
501 }
502 pragma solidity ^0.6.0;
503 contract SPECTRE is ERC20Capped, ERC20Burnable, Roles, TokenRecover {
504     bool private _mintingFinished = false;
505     bool private _transferEnabled = false;
506 
507     event MintFinished();
508 
509     event TransferEnabled();
510 
511     modifier canMint() {
512         require(!_mintingFinished, "SPECTRE: minting is finished");
513         _;
514     }
515 
516     modifier canTransfer(address from) {
517         require(
518             _transferEnabled || hasRole(OPERATOR_ROLE, from),
519             "SPECTRE: transfer is not enabled or from does not have the OPERATOR role"
520         );
521         _;
522     }
523 
524     constructor()
525         public
526         ERC20Capped(56000000000000000000000)
527         ERC20("Speculative Resistance RTC", "SPECTRE")
528     {
529         uint256 initialSupply = 56000000000000000000000;
530         bool transferEnabled = true;
531         bool mintingFinished = true;
532         
533         if (initialSupply > 0) {
534             _mint(owner(), initialSupply);
535         }
536         if (mintingFinished) {
537             finishMinting();
538         }
539         if (transferEnabled) {
540             enableTransfer();
541         }
542     }
543 
544     function mintingFinished() public view returns (bool) {
545         return _mintingFinished;
546     }
547 
548     function transferEnabled() public view returns (bool) {
549         return _transferEnabled;
550     }
551 
552     function mint(address to, uint256 value) public canMint onlyMinter {
553         _mint(to, value);
554     }
555 
556     function transfer(address to, uint256 value) public virtual override(ERC20) canTransfer(_msgSender()) returns (bool) {
557         return super.transfer(to, value);
558     }
559 
560     function transferFrom(address from, address to, uint256 value) public virtual override(ERC20) canTransfer(from) returns (bool) {
561         return super.transferFrom(from, to, value);
562     }
563 
564     function finishMinting() public canMint onlyOwner {
565         _mintingFinished = true;
566         emit MintFinished();
567     }
568 
569     function enableTransfer() public onlyOwner {
570         _transferEnabled = true;
571         emit TransferEnabled();
572     }
573 
574     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override(ERC20, ERC20Capped) {
575         super._beforeTokenTransfer(from, to, amount);
576     }
577 }