1 //
2 // Liquid Lottery (LIQLO) is the first token from Read This Contract (RTC)!
3 // If you don't know what RTC is, join the Telegram:
4 // > https://t.me/ReadThisContract
5 //
6 // Nothing fancy in this token contract, but a play on the Uniswap pool!
7 // The rules are simple:
8 //
9 // 0. LIQLO-ETH pool on Uniswap starts with 1 ETH and 10 LIQLO.
10 //    Supply is low because you will win the rest of LIQLO tokens!
11 //
12 //    1,000 LIQLO is reserved for prizes. 100 LIQLO is airdropped to RTC holders.
13 //    This means total & final supply is 1,110 LIQLO. Minting is locked for ever!
14 //
15 // 1. Add liquidity to RTC-ETH pool on Uniswap.
16 //    Every 1 ETH worth of RTC-ETH you add to the pool counts as 1 "ticket".
17 //    > https://uniswap.info/pair/0xfde42a9422cb0ee84ede728ab503487b382d135e
18 //
19 // 2. Once per day when RTC-ETH pool liquidity is above 32 ETH, a random "ticket" receives:
20 //    1 ETH + 1 RTC + 1 LIQLO.
21 //
22 // 3. Once per day when RTC-ETH pool liquidity is above 32 ETH, the top liquidity provider receives:
23 //    1 ETH + 2 RTC + 3 LIQLO.
24 //
25 // 4. The daily prize of 2 ETH comes from selling RTC reserve back to the pool, meaning once per day
26 //    there is a small chance to enter RTC at a discount.
27 //
28 // 5. Collect LIQLO tokens to use for staking in the next token contract!
29 //
30 // Good luck!
31 //
32 // Veronika
33 //
34 
35 // //////////////////////////////////////////////////////////////////////////////// //
36 //                                                                                  //
37 //                               ////   //////   /////                              //
38 //                              //        //     //                                 //
39 //                              //        //     /////                              //
40 //                                                                                  //
41 //                              Never break the chain.                              //
42 //                                                                                  //
43 // //////////////////////////////////////////////////////////////////////////////// //
44 
45 pragma solidity ^0.6.0;
46 
47 contract Context {
48     constructor () internal { }
49 
50     function _msgSender() internal view virtual returns (address payable) {
51         return msg.sender;
52     }
53 
54     function _msgData() internal view virtual returns (bytes memory) {
55         this;
56         return msg.data;
57     }
58 }
59 
60 pragma solidity ^0.6.0;
61 
62 library SafeMath {
63     function add(uint256 a, uint256 b) internal pure returns (uint256) {
64         uint256 c = a + b;
65         require(c >= a, "SafeMath: addition overflow");
66 
67         return c;
68     }
69 
70     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
71         return sub(a, b, "SafeMath: subtraction overflow");
72     }
73 
74     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
75         require(b <= a, errorMessage);
76         uint256 c = a - b;
77 
78         return c;
79     }
80 
81     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
82         if (a == 0) {
83             return 0;
84         }
85 
86         uint256 c = a * b;
87         require(c / a == b, "SafeMath: multiplication overflow");
88 
89         return c;
90     }
91 
92     function div(uint256 a, uint256 b) internal pure returns (uint256) {
93         return div(a, b, "SafeMath: division by zero");
94     }
95 
96     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
97         require(b > 0, errorMessage);
98         uint256 c = a / b;
99 
100         return c;
101     }
102 
103     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
104         return mod(a, b, "SafeMath: modulo by zero");
105     }
106 
107     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
108         require(b != 0, errorMessage);
109         return a % b;
110     }
111 }
112 
113 pragma solidity ^0.6.0;
114 
115 contract Ownable is Context {
116     address private _owner;
117 
118     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
119 
120     constructor () internal {
121         address msgSender = _msgSender();
122         _owner = msgSender;
123         emit OwnershipTransferred(address(0), msgSender);
124     }
125 
126     function owner() public view returns (address) {
127         return _owner;
128     }
129 
130     modifier onlyOwner() {
131         require(_owner == _msgSender(), "Ownable: caller is not the owner");
132         _;
133     }
134 
135     function renounceOwnership() public virtual onlyOwner {
136         emit OwnershipTransferred(_owner, address(0));
137         _owner = address(0);
138     }
139 
140     function transferOwnership(address newOwner) public virtual onlyOwner {
141         require(newOwner != address(0), "Ownable: new owner is the zero address");
142         emit OwnershipTransferred(_owner, newOwner);
143         _owner = newOwner;
144     }
145 }
146 
147 pragma solidity ^0.6.2;
148 
149 library Address {
150     function isContract(address account) internal view returns (bool) {
151         bytes32 codehash;
152         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
153         assembly { codehash := extcodehash(account) }
154         return (codehash != accountHash && codehash != 0x0);
155     }
156 
157     function sendValue(address payable recipient, uint256 amount) internal {
158         require(address(this).balance >= amount, "Address: insufficient balance");
159 
160         (bool success, ) = recipient.call{ value: amount }("");
161         require(success, "Address: unable to send value, recipient may have reverted");
162     }
163 }
164 
165 pragma solidity ^0.6.0;
166 
167 interface IERC20 {
168     function totalSupply() external view returns (uint256);
169 
170     function balanceOf(address account) external view returns (uint256);
171 
172     function transfer(address recipient, uint256 amount) external returns (bool);
173 
174     function allowance(address owner, address spender) external view returns (uint256);
175 
176     function approve(address spender, uint256 amount) external returns (bool);
177 
178     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
179 
180     event Transfer(address indexed from, address indexed to, uint256 value);
181 
182     event Approval(address indexed owner, address indexed spender, uint256 value);
183 }
184 
185 pragma solidity ^0.6.0;
186 
187 contract ERC20 is Context, IERC20 {
188     using SafeMath for uint256;
189     using Address for address;
190 
191     mapping (address => uint256) private _balances;
192 
193     mapping (address => mapping (address => uint256)) private _allowances;
194 
195     uint256 private _totalSupply;
196 
197     string private _name;
198     string private _symbol;
199     uint8 private _decimals;
200 
201     constructor (string memory name, string memory symbol) public {
202         _name = name;
203         _symbol = symbol;
204         _decimals = 18;
205     }
206 
207     function name() public view returns (string memory) {
208         return _name;
209     }
210 
211     function symbol() public view returns (string memory) {
212         return _symbol;
213     }
214 
215     function decimals() public view returns (uint8) {
216         return _decimals;
217     }
218 
219     function totalSupply() public view override returns (uint256) {
220         return _totalSupply;
221     }
222 
223     function balanceOf(address account) public view override returns (uint256) {
224         return _balances[account];
225     }
226 
227     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
228         _transfer(_msgSender(), recipient, amount);
229         return true;
230     }
231 
232     function allowance(address owner, address spender) public view virtual override returns (uint256) {
233         return _allowances[owner][spender];
234     }
235 
236     function approve(address spender, uint256 amount) public virtual override returns (bool) {
237         _approve(_msgSender(), spender, amount);
238         return true;
239     }
240 
241     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
242         _transfer(sender, recipient, amount);
243         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
244         return true;
245     }
246 
247     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
248         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
249         return true;
250     }
251 
252     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
253         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
254         return true;
255     }
256 
257     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
258         require(sender != address(0), "ERC20: transfer from the zero address");
259         require(recipient != address(0), "ERC20: transfer to the zero address");
260 
261         _beforeTokenTransfer(sender, recipient, amount);
262 
263         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
264         _balances[recipient] = _balances[recipient].add(amount);
265         emit Transfer(sender, recipient, amount);
266     }
267 
268     function _mint(address account, uint256 amount) internal virtual {
269         require(account != address(0), "ERC20: mint to the zero address");
270 
271         _beforeTokenTransfer(address(0), account, amount);
272 
273         _totalSupply = _totalSupply.add(amount);
274         _balances[account] = _balances[account].add(amount);
275         emit Transfer(address(0), account, amount);
276     }
277 
278     function _burn(address account, uint256 amount) internal virtual {
279         require(account != address(0), "ERC20: burn from the zero address");
280 
281         _beforeTokenTransfer(account, address(0), amount);
282 
283         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
284         _totalSupply = _totalSupply.sub(amount);
285         emit Transfer(account, address(0), amount);
286     }
287 
288     function _approve(address owner, address spender, uint256 amount) internal virtual {
289         require(owner != address(0), "ERC20: approve from the zero address");
290         require(spender != address(0), "ERC20: approve to the zero address");
291 
292         _allowances[owner][spender] = amount;
293         emit Approval(owner, spender, amount);
294     }
295 
296     function _setupDecimals(uint8 decimals_) internal {
297         _decimals = decimals_;
298     }
299 
300     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
301 }
302 
303 pragma solidity ^0.6.0;
304 
305 abstract contract ERC20Capped is ERC20 {
306     uint256 private _cap;
307 
308     constructor (uint256 cap) public {
309         require(cap > 0, "ERC20Capped: cap is 0");
310         _cap = cap;
311     }
312 
313     function cap() public view returns (uint256) {
314         return _cap;
315     }
316 
317     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
318         super._beforeTokenTransfer(from, to, amount);
319 
320         if (from == address(0)) {
321             require(totalSupply().add(amount) <= _cap, "ERC20Capped: cap exceeded");
322         }
323     }
324 }
325 
326 pragma solidity ^0.6.0;
327 
328 abstract contract ERC20Burnable is Context, ERC20 {
329 
330     function burn(uint256 amount) public virtual {
331         _burn(_msgSender(), amount);
332     }
333 
334     function burnFrom(address account, uint256 amount) public virtual {
335         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
336 
337         _approve(account, _msgSender(), decreasedAllowance);
338         _burn(account, amount);
339     }
340 }
341 
342 pragma solidity ^0.6.0;
343 
344 interface IERC165 {
345     function supportsInterface(bytes4 interfaceId) external view returns (bool);
346 }
347 
348 pragma solidity ^0.6.2;
349 
350 library ERC165Checker {
351     bytes4 private constant _INTERFACE_ID_INVALID = 0xffffffff;
352 
353     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
354 
355     function supportsERC165(address account) internal view returns (bool) {
356         return _supportsERC165Interface(account, _INTERFACE_ID_ERC165) &&
357             !_supportsERC165Interface(account, _INTERFACE_ID_INVALID);
358     }
359 
360     function supportsInterface(address account, bytes4 interfaceId) internal view returns (bool) {
361         return supportsERC165(account) &&
362             _supportsERC165Interface(account, interfaceId);
363     }
364 
365 
366     function supportsAllInterfaces(address account, bytes4[] memory interfaceIds) internal view returns (bool) {
367         if (!supportsERC165(account)) {
368             return false;
369         }
370 
371         for (uint256 i = 0; i < interfaceIds.length; i++) {
372             if (!_supportsERC165Interface(account, interfaceIds[i])) {
373                 return false;
374             }
375         }
376 
377         return true;
378     }
379 
380 
381     function _supportsERC165Interface(address account, bytes4 interfaceId) private view returns (bool) {
382         (bool success, bool result) = _callERC165SupportsInterface(account, interfaceId);
383 
384         return (success && result);
385     }
386 
387 
388     function _callERC165SupportsInterface(address account, bytes4 interfaceId)
389         private
390         view
391         returns (bool, bool)
392     {
393         bytes memory encodedParams = abi.encodeWithSelector(_INTERFACE_ID_ERC165, interfaceId);
394         (bool success, bytes memory result) = account.staticcall{ gas: 30000 }(encodedParams);
395         if (result.length < 32) return (false, false);
396         return (success, abi.decode(result, (bool)));
397     }
398 }
399 
400 pragma solidity ^0.6.0;
401 
402 contract ERC165 is IERC165 {
403 
404     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
405 
406 
407     mapping(bytes4 => bool) private _supportedInterfaces;
408 
409     constructor () internal {
410         _registerInterface(_INTERFACE_ID_ERC165);
411     }
412 
413 
414     function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
415         return _supportedInterfaces[interfaceId];
416     }
417 
418 
419     function _registerInterface(bytes4 interfaceId) internal virtual {
420         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
421         _supportedInterfaces[interfaceId] = true;
422     }
423 }
424 
425 pragma solidity ^0.6.0;
426 
427 contract TokenRecover is Ownable {
428 
429 
430     function recoverERC20(address tokenAddress, uint256 tokenAmount) public onlyOwner {
431         IERC20(tokenAddress).transfer(owner(), tokenAmount);
432     }
433 }
434 
435 pragma solidity ^0.6.0;
436 
437 library EnumerableSet {
438 
439     struct Set {
440         bytes32[] _values;
441 
442         mapping (bytes32 => uint256) _indexes;
443     }
444 
445 
446     function _add(Set storage set, bytes32 value) private returns (bool) {
447         if (!_contains(set, value)) {
448             set._values.push(value);
449             set._indexes[value] = set._values.length;
450             return true;
451         } else {
452             return false;
453         }
454     }
455 
456 
457     function _remove(Set storage set, bytes32 value) private returns (bool) {
458         uint256 valueIndex = set._indexes[value];
459 
460         if (valueIndex != 0) {
461             uint256 toDeleteIndex = valueIndex - 1;
462             uint256 lastIndex = set._values.length - 1;
463 
464             bytes32 lastvalue = set._values[lastIndex];
465 
466             set._values[toDeleteIndex] = lastvalue;
467             set._indexes[lastvalue] = toDeleteIndex + 1;
468             set._values.pop();
469 
470             delete set._indexes[value];
471 
472             return true;
473         } else {
474             return false;
475         }
476     }
477 
478 
479     function _contains(Set storage set, bytes32 value) private view returns (bool) {
480         return set._indexes[value] != 0;
481     }
482 
483 
484     function _length(Set storage set) private view returns (uint256) {
485         return set._values.length;
486     }
487 
488     function _at(Set storage set, uint256 index) private view returns (bytes32) {
489         require(set._values.length > index, "EnumerableSet: index out of bounds");
490         return set._values[index];
491     }
492 
493     struct AddressSet {
494         Set _inner;
495     }
496 
497 
498     function add(AddressSet storage set, address value) internal returns (bool) {
499         return _add(set._inner, bytes32(uint256(value)));
500     }
501 
502 
503     function remove(AddressSet storage set, address value) internal returns (bool) {
504         return _remove(set._inner, bytes32(uint256(value)));
505     }
506 
507 
508     function contains(AddressSet storage set, address value) internal view returns (bool) {
509         return _contains(set._inner, bytes32(uint256(value)));
510     }
511 
512 
513     function length(AddressSet storage set) internal view returns (uint256) {
514         return _length(set._inner);
515     }
516 
517     function at(AddressSet storage set, uint256 index) internal view returns (address) {
518         return address(uint256(_at(set._inner, index)));
519     }
520 
521 
522     struct UintSet {
523         Set _inner;
524     }
525 
526 
527     function add(UintSet storage set, uint256 value) internal returns (bool) {
528         return _add(set._inner, bytes32(value));
529     }
530 
531 
532     function remove(UintSet storage set, uint256 value) internal returns (bool) {
533         return _remove(set._inner, bytes32(value));
534     }
535 
536 
537     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
538         return _contains(set._inner, bytes32(value));
539     }
540 
541 
542     function length(UintSet storage set) internal view returns (uint256) {
543         return _length(set._inner);
544     }
545 
546     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
547         return uint256(_at(set._inner, index));
548     }
549 }
550 
551 pragma solidity ^0.6.0;
552 
553 abstract contract AccessControl is Context {
554     using EnumerableSet for EnumerableSet.AddressSet;
555     using Address for address;
556 
557     struct RoleData {
558         EnumerableSet.AddressSet members;
559         bytes32 adminRole;
560     }
561 
562     mapping (bytes32 => RoleData) private _roles;
563 
564     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
565 
566 
567     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
568 
569 
570     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
571 
572 
573     function hasRole(bytes32 role, address account) public view returns (bool) {
574         return _roles[role].members.contains(account);
575     }
576 
577 
578     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
579         return _roles[role].members.length();
580     }
581 
582 
583     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
584         return _roles[role].members.at(index);
585     }
586 
587 
588     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
589         return _roles[role].adminRole;
590     }
591 
592 
593     function grantRole(bytes32 role, address account) public virtual {
594         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
595 
596         _grantRole(role, account);
597     }
598 
599 
600     function revokeRole(bytes32 role, address account) public virtual {
601         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
602 
603         _revokeRole(role, account);
604     }
605 
606 
607     function renounceRole(bytes32 role, address account) public virtual {
608         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
609 
610         _revokeRole(role, account);
611     }
612 
613 
614     function _setupRole(bytes32 role, address account) internal virtual {
615         _grantRole(role, account);
616     }
617 
618 
619     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
620         _roles[role].adminRole = adminRole;
621     }
622 
623     function _grantRole(bytes32 role, address account) private {
624         if (_roles[role].members.add(account)) {
625             emit RoleGranted(role, account, _msgSender());
626         }
627     }
628 
629     function _revokeRole(bytes32 role, address account) private {
630         if (_roles[role].members.remove(account)) {
631             emit RoleRevoked(role, account, _msgSender());
632         }
633     }
634 }
635 
636 pragma solidity ^0.6.0;
637 
638 contract Roles is AccessControl {
639 
640     bytes32 public constant MINTER_ROLE = keccak256("MINTER");
641     bytes32 public constant OPERATOR_ROLE = keccak256("OPERATOR");
642 
643     constructor () public {
644         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
645         _setupRole(MINTER_ROLE, _msgSender());
646         _setupRole(OPERATOR_ROLE, _msgSender());
647     }
648 
649     modifier onlyMinter() {
650         require(hasRole(MINTER_ROLE, _msgSender()), "Roles: caller does not have the MINTER role");
651         _;
652     }
653 
654     modifier onlyOperator() {
655         require(hasRole(OPERATOR_ROLE, _msgSender()), "Roles: caller does not have the OPERATOR role");
656         _;
657     }
658 }
659 
660 pragma solidity ^0.6.0;
661 
662 contract LiquidLottery is ERC20Capped, ERC20Burnable, Roles, TokenRecover {
663 
664     bool private _mintingFinished = false;
665 
666     bool private _transferEnabled = false;
667 
668 
669     event MintFinished();
670 
671 
672     event TransferEnabled();
673 
674 
675     modifier canMint() {
676         require(!_mintingFinished, "LiquidLottery: minting is finished");
677         _;
678     }
679 
680 
681     modifier canTransfer(address from) {
682         require(
683             _transferEnabled || hasRole(OPERATOR_ROLE, from),
684             "LiquidLottery: transfer is not enabled or from does not have the OPERATOR role"
685         );
686         _;
687     }
688 
689 
690     constructor(
691         string memory name,
692         string memory symbol,
693         uint8 decimals,
694         uint256 cap,
695         uint256 initialSupply,
696         bool transferEnabled,
697         bool mintingFinished
698     )
699         public
700         ERC20Capped(cap)
701         ERC20(name, symbol)
702     {
703         require(
704             mintingFinished == false || cap == initialSupply,
705             "LiquidLottery: if finish minting, cap must be equal to initialSupply"
706         );
707 
708         _setupDecimals(decimals);
709 
710         if (initialSupply > 0) {
711             _mint(owner(), initialSupply);
712         }
713 
714         if (mintingFinished) {
715             finishMinting();
716         }
717 
718         if (transferEnabled) {
719             enableTransfer();
720         }
721     }
722 
723 
724     function mintingFinished() public view returns (bool) {
725         return _mintingFinished;
726     }
727 
728 
729     function transferEnabled() public view returns (bool) {
730         return _transferEnabled;
731     }
732 
733 
734     function mint(address to, uint256 value) public canMint onlyMinter {
735         _mint(to, value);
736     }
737 
738 
739     function transfer(address to, uint256 value) public virtual override(ERC20) canTransfer(_msgSender()) returns (bool) {
740         return super.transfer(to, value);
741     }
742 
743 
744     function transferFrom(address from, address to, uint256 value) public virtual override(ERC20) canTransfer(from) returns (bool) {
745         return super.transferFrom(from, to, value);
746     }
747 
748 
749     function finishMinting() public canMint onlyOwner {
750         _mintingFinished = true;
751 
752         emit MintFinished();
753     }
754 
755 
756     function enableTransfer() public onlyOwner {
757         _transferEnabled = true;
758 
759         emit TransferEnabled();
760     }
761 
762 
763     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override(ERC20, ERC20Capped) {
764         super._beforeTokenTransfer(from, to, amount);
765     }
766 }