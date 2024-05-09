1 pragma solidity ^0.6.8;
2 
3 
4 library EnumerableSet {
5 
6 
7 
8 
9 
10 
11 
12 
13 
14     struct Set {
15 
16         bytes32[] _values;
17 
18 
19 
20         mapping (bytes32 => uint256) _indexes;
21     }
22 
23 
24     function _add(Set storage set, bytes32 value) private returns (bool) {
25         if (!_contains(set, value)) {
26             set._values.push(value);
27 
28 
29             set._indexes[value] = set._values.length;
30             return true;
31         } else {
32             return false;
33         }
34     }
35 
36 
37     function _remove(Set storage set, bytes32 value) private returns (bool) {
38 
39         uint256 valueIndex = set._indexes[value];
40 
41         if (valueIndex != 0) {
42 
43 
44 
45 
46             uint256 toDeleteIndex = valueIndex - 1;
47             uint256 lastIndex = set._values.length - 1;
48 
49 
50 
51 
52             bytes32 lastvalue = set._values[lastIndex];
53 
54 
55             set._values[toDeleteIndex] = lastvalue;
56 
57             set._indexes[lastvalue] = toDeleteIndex + 1;
58 
59 
60             set._values.pop();
61 
62 
63             delete set._indexes[value];
64 
65             return true;
66         } else {
67             return false;
68         }
69     }
70 
71 
72     function _contains(Set storage set, bytes32 value) private view returns (bool) {
73         return set._indexes[value] != 0;
74     }
75 
76 
77     function _length(Set storage set) private view returns (uint256) {
78         return set._values.length;
79     }
80 
81 
82     function _at(Set storage set, uint256 index) private view returns (bytes32) {
83         require(set._values.length > index, "EnumerableSet: index out of bounds");
84         return set._values[index];
85     }
86 
87 
88 
89     struct Bytes32Set {
90         Set _inner;
91     }
92 
93 
94     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
95         return _add(set._inner, value);
96     }
97 
98 
99     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
100         return _remove(set._inner, value);
101     }
102 
103 
104     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
105         return _contains(set._inner, value);
106     }
107 
108 
109     function length(Bytes32Set storage set) internal view returns (uint256) {
110         return _length(set._inner);
111     }
112 
113 
114     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
115         return _at(set._inner, index);
116     }
117 
118 
119 
120     struct AddressSet {
121         Set _inner;
122     }
123 
124 
125     function add(AddressSet storage set, address value) internal returns (bool) {
126         return _add(set._inner, bytes32(uint256(uint160(value))));
127     }
128 
129 
130     function remove(AddressSet storage set, address value) internal returns (bool) {
131         return _remove(set._inner, bytes32(uint256(uint160(value))));
132     }
133 
134 
135     function contains(AddressSet storage set, address value) internal view returns (bool) {
136         return _contains(set._inner, bytes32(uint256(uint160(value))));
137     }
138 
139 
140     function length(AddressSet storage set) internal view returns (uint256) {
141         return _length(set._inner);
142     }
143 
144 
145     function at(AddressSet storage set, uint256 index) internal view returns (address) {
146         return address(uint160(uint256(_at(set._inner, index))));
147     }
148 
149 
150 
151 
152     struct UintSet {
153         Set _inner;
154     }
155 
156 
157     function add(UintSet storage set, uint256 value) internal returns (bool) {
158         return _add(set._inner, bytes32(value));
159     }
160 
161 
162     function remove(UintSet storage set, uint256 value) internal returns (bool) {
163         return _remove(set._inner, bytes32(value));
164     }
165 
166 
167     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
168         return _contains(set._inner, bytes32(value));
169     }
170 
171 
172     function length(UintSet storage set) internal view returns (uint256) {
173         return _length(set._inner);
174     }
175 
176 
177     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
178         return uint256(_at(set._inner, index));
179     }
180 }
181 
182 library Address {
183 
184     function isContract(address account) internal view returns (bool) {
185 
186 
187 
188 
189         uint256 size;
190 
191         assembly { size := extcodesize(account) }
192         return size > 0;
193     }
194 
195 
196     function sendValue(address payable recipient, uint256 amount) internal {
197         require(address(this).balance >= amount, "Address: insufficient balance");
198 
199 
200         (bool success, ) = recipient.call{ value: amount }("");
201         require(success, "Address: unable to send value, recipient may have reverted");
202     }
203 
204 
205     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
206       return functionCall(target, data, "Address: low-level call failed");
207     }
208 
209 
210     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
211         return functionCallWithValue(target, data, 0, errorMessage);
212     }
213 
214 
215     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
216         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
217     }
218 
219 
220     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
221         require(address(this).balance >= value, "Address: insufficient balance for call");
222         require(isContract(target), "Address: call to non-contract");
223 
224 
225         (bool success, bytes memory returndata) = target.call{ value: value }(data);
226         return _verifyCallResult(success, returndata, errorMessage);
227     }
228 
229 
230     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
231         return functionStaticCall(target, data, "Address: low-level static call failed");
232     }
233 
234 
235     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
236         require(isContract(target), "Address: static call to non-contract");
237 
238 
239         (bool success, bytes memory returndata) = target.staticcall(data);
240         return _verifyCallResult(success, returndata, errorMessage);
241     }
242 
243 
244     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
245         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
246     }
247 
248 
249     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
250         require(isContract(target), "Address: delegate call to non-contract");
251 
252 
253         (bool success, bytes memory returndata) = target.delegatecall(data);
254         return _verifyCallResult(success, returndata, errorMessage);
255     }
256 
257     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
258         if (success) {
259             return returndata;
260         } else {
261 
262             if (returndata.length > 0) {
263 
264 
265 
266                 assembly {
267                     let returndata_size := mload(returndata)
268                     revert(add(32, returndata), returndata_size)
269                 }
270             } else {
271                 revert(errorMessage);
272             }
273         }
274     }
275 }
276 
277 abstract contract Context {
278     function _msgSender() internal view virtual returns (address payable) {
279         return msg.sender;
280     }
281 
282     function _msgData() internal view virtual returns (bytes memory) {
283         this;
284         return msg.data;
285     }
286 }
287 
288 abstract contract AccessControl is Context {
289     using EnumerableSet for EnumerableSet.AddressSet;
290     using Address for address;
291 
292     struct RoleData {
293         EnumerableSet.AddressSet members;
294         bytes32 adminRole;
295     }
296 
297     mapping (bytes32 => RoleData) private _roles;
298 
299     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
300 
301 
302     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
303 
304 
305     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
306 
307 
308     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
309 
310 
311     function hasRole(bytes32 role, address account) public view returns (bool) {
312         return _roles[role].members.contains(account);
313     }
314 
315 
316     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
317         return _roles[role].members.length();
318     }
319 
320 
321     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
322         return _roles[role].members.at(index);
323     }
324 
325 
326     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
327         return _roles[role].adminRole;
328     }
329 
330 
331     function grantRole(bytes32 role, address account) public virtual {
332         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
333 
334         _grantRole(role, account);
335     }
336 
337 
338     function revokeRole(bytes32 role, address account) public virtual {
339         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
340 
341         _revokeRole(role, account);
342     }
343 
344 
345     function renounceRole(bytes32 role, address account) public virtual {
346         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
347 
348         _revokeRole(role, account);
349     }
350 
351 
352     function _setupRole(bytes32 role, address account) internal virtual {
353         _grantRole(role, account);
354     }
355 
356 
357     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
358         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
359         _roles[role].adminRole = adminRole;
360     }
361 
362     function _grantRole(bytes32 role, address account) private {
363         if (_roles[role].members.add(account)) {
364             emit RoleGranted(role, account, _msgSender());
365         }
366     }
367 
368     function _revokeRole(bytes32 role, address account) private {
369         if (_roles[role].members.remove(account)) {
370             emit RoleRevoked(role, account, _msgSender());
371         }
372     }
373 }
374 
375 interface IERC20 {
376 
377     function totalSupply() external view returns (uint256);
378 
379 
380     function balanceOf(address account) external view returns (uint256);
381 
382 
383     function transfer(address recipient, uint256 amount) external returns (bool);
384 
385 
386     function allowance(address owner, address spender) external view returns (uint256);
387 
388 
389     function approve(address spender, uint256 amount) external returns (bool);
390 
391 
392     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
393 
394 
395     event Transfer(address indexed from, address indexed to, uint256 value);
396 
397 
398     event Approval(address indexed owner, address indexed spender, uint256 value);
399 }
400 
401 library SafeMath {
402 
403     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
404         uint256 c = a + b;
405         if (c < a) return (false, 0);
406         return (true, c);
407     }
408 
409 
410     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
411         if (b > a) return (false, 0);
412         return (true, a - b);
413     }
414 
415 
416     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
417 
418 
419 
420         if (a == 0) return (true, 0);
421         uint256 c = a * b;
422         if (c / a != b) return (false, 0);
423         return (true, c);
424     }
425 
426 
427     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
428         if (b == 0) return (false, 0);
429         return (true, a / b);
430     }
431 
432 
433     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
434         if (b == 0) return (false, 0);
435         return (true, a % b);
436     }
437 
438 
439     function add(uint256 a, uint256 b) internal pure returns (uint256) {
440         uint256 c = a + b;
441         require(c >= a, "SafeMath: addition overflow");
442         return c;
443     }
444 
445 
446     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
447         require(b <= a, "SafeMath: subtraction overflow");
448         return a - b;
449     }
450 
451 
452     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
453         if (a == 0) return 0;
454         uint256 c = a * b;
455         require(c / a == b, "SafeMath: multiplication overflow");
456         return c;
457     }
458 
459 
460     function div(uint256 a, uint256 b) internal pure returns (uint256) {
461         require(b > 0, "SafeMath: division by zero");
462         return a / b;
463     }
464 
465 
466     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
467         require(b > 0, "SafeMath: modulo by zero");
468         return a % b;
469     }
470 
471 
472     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
473         require(b <= a, errorMessage);
474         return a - b;
475     }
476 
477 
478     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
479         require(b > 0, errorMessage);
480         return a / b;
481     }
482 
483 
484     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
485         require(b > 0, errorMessage);
486         return a % b;
487     }
488 }
489 
490 contract ERC20 is Context, IERC20 {
491     using SafeMath for uint256;
492 
493     mapping (address => uint256) private _balances;
494 
495     mapping (address => mapping (address => uint256)) private _allowances;
496 
497     uint256 private _totalSupply;
498 
499     string private _name;
500     string private _symbol;
501     uint8 private _decimals;
502 
503 
504     constructor (string memory name_, string memory symbol_) public {
505         _name = name_;
506         _symbol = symbol_;
507         _decimals = 18;
508     }
509 
510 
511     function name() public view virtual returns (string memory) {
512         return _name;
513     }
514 
515 
516     function symbol() public view virtual returns (string memory) {
517         return _symbol;
518     }
519 
520 
521     function decimals() public view virtual returns (uint8) {
522         return _decimals;
523     }
524 
525 
526     function totalSupply() public view virtual override returns (uint256) {
527         return _totalSupply;
528     }
529 
530 
531     function balanceOf(address account) public view virtual override returns (uint256) {
532         return _balances[account];
533     }
534 
535 
536     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
537         _transfer(_msgSender(), recipient, amount);
538         return true;
539     }
540 
541 
542     function allowance(address owner, address spender) public view virtual override returns (uint256) {
543         return _allowances[owner][spender];
544     }
545 
546 
547     function approve(address spender, uint256 amount) public virtual override returns (bool) {
548         _approve(_msgSender(), spender, amount);
549         return true;
550     }
551 
552 
553     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
554         _transfer(sender, recipient, amount);
555         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
556         return true;
557     }
558 
559 
560     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
561         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
562         return true;
563     }
564 
565 
566     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
567         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
568         return true;
569     }
570 
571 
572     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
573         require(sender != address(0), "ERC20: transfer from the zero address");
574         require(recipient != address(0), "ERC20: transfer to the zero address");
575 
576         _beforeTokenTransfer(sender, recipient, amount);
577 
578         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
579         _balances[recipient] = _balances[recipient].add(amount);
580         emit Transfer(sender, recipient, amount);
581     }
582 
583 
584     function _mint(address account, uint256 amount) internal virtual {
585         require(account != address(0), "ERC20: mint to the zero address");
586 
587         _beforeTokenTransfer(address(0), account, amount);
588 
589         _totalSupply = _totalSupply.add(amount);
590         _balances[account] = _balances[account].add(amount);
591         emit Transfer(address(0), account, amount);
592     }
593 
594 
595     function _burn(address account, uint256 amount) internal virtual {
596         require(account != address(0), "ERC20: burn from the zero address");
597 
598         _beforeTokenTransfer(account, address(0), amount);
599 
600         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
601         _totalSupply = _totalSupply.sub(amount);
602         emit Transfer(account, address(0), amount);
603     }
604 
605 
606     function _approve(address owner, address spender, uint256 amount) internal virtual {
607         require(owner != address(0), "ERC20: approve from the zero address");
608         require(spender != address(0), "ERC20: approve to the zero address");
609 
610         _allowances[owner][spender] = amount;
611         emit Approval(owner, spender, amount);
612     }
613 
614 
615     function _setupDecimals(uint8 decimals_) internal virtual {
616         _decimals = decimals_;
617     }
618 
619 
620     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
621 }
622 
623 abstract contract ERC20Burnable is Context, ERC20 {
624     using SafeMath for uint256;
625 
626 
627     function burn(uint256 amount) public virtual {
628         _burn(_msgSender(), amount);
629     }
630 
631 
632     function burnFrom(address account, uint256 amount) public virtual {
633         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
634 
635         _approve(account, _msgSender(), decreasedAllowance);
636         _burn(account, amount);
637     }
638 }
639 
640 abstract contract Pausable is Context {
641 
642     event Paused(address account);
643 
644 
645     event Unpaused(address account);
646 
647     bool private _paused;
648 
649 
650     constructor () internal {
651         _paused = false;
652     }
653 
654 
655     function paused() public view virtual returns (bool) {
656         return _paused;
657     }
658 
659 
660     modifier whenNotPaused() {
661         require(!paused(), "Pausable: paused");
662         _;
663     }
664 
665 
666     modifier whenPaused() {
667         require(paused(), "Pausable: not paused");
668         _;
669     }
670 
671 
672     function _pause() internal virtual whenNotPaused {
673         _paused = true;
674         emit Paused(_msgSender());
675     }
676 
677 
678     function _unpause() internal virtual whenPaused {
679         _paused = false;
680         emit Unpaused(_msgSender());
681     }
682 }
683 
684 abstract contract ERC20Pausable is ERC20, Pausable {
685 
686     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
687         super._beforeTokenTransfer(from, to, amount);
688 
689         require(!paused(), "ERC20Pausable: token transfer while paused");
690     }
691 }
692 
693 contract ERC20PresetMinterPauser is Context, AccessControl, ERC20Burnable, ERC20Pausable {
694     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
695     bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
696 
697 
698     constructor(string memory name, string memory symbol) public ERC20(name, symbol) {
699         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
700 
701         _setupRole(MINTER_ROLE, _msgSender());
702         _setupRole(PAUSER_ROLE, _msgSender());
703     }
704 
705 
706     function mint(address to, uint256 amount) public virtual {
707         require(hasRole(MINTER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have minter role to mint");
708         _mint(to, amount);
709     }
710 
711 
712     function pause() public virtual {
713         require(hasRole(PAUSER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have pauser role to pause");
714         _pause();
715     }
716 
717 
718     function unpause() public virtual {
719         require(hasRole(PAUSER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have pauser role to unpause");
720         _unpause();
721     }
722 
723     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override(ERC20, ERC20Pausable) {
724         super._beforeTokenTransfer(from, to, amount);
725     }
726 }
727 
728 abstract contract EMToken is ERC20PresetMinterPauser {
729     constructor(string memory name, string memory symbol) public ERC20PresetMinterPauser(name, symbol) {
730         _setupDecimals(6);
731     }
732 
733     function burn(uint256 amount) public override {
734         require(hasRole(MINTER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have minter role to burn");
735 
736         super.burn(amount);
737     }
738 }
739 
740 contract NGM is EMToken {
741     constructor() public EMToken("Next Generation Money", "NGM") {}
742 }